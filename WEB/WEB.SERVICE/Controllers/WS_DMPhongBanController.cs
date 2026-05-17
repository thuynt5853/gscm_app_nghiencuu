using DAL.GSTP;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using WEB.Service.Controllers.Utils;
using WEB.Service.Models;
using WEB.Service.Models.DM_VOFFICE;

namespace WEB.Service.Controllers
{
    public class WS_DMPhongBanController : ApiController
    {

        private GSTPContext context = new GSTPContext();

        /// <summary>
        /// Hàm lấy thông tin token từ header
        /// </summary>
        /// <returns>Trả lại giá trị token từ header</returns>
        private string getTokenInHeader()
        {
            var re = Request;
            var headers = re.Headers;
            if (headers.Contains("token"))
            {
                string token = headers.GetValues("token").First();
                return token;
            }
            return null;
        }

        /// <summary>
        /// Hàm kiểm tra token hợp lệ
        /// </summary>
        /// <param name="token">Token kiểm tra</param>
        /// <returns>Trả về true nếu token hợp lệ, false nếu không hợp lệ</returns>
        private bool isAccesable(string token)
        {
            DM_TOKEN_KEY oTokenKey = context.DM_TOKEN_KEY
                .Where(x => x.TOKEN_KEY.ToLower() == token.ToLower())
                .FirstOrDefault<DM_TOKEN_KEY>();
            if (oTokenKey != null)
                return oTokenKey.EXPIRED_TIME >= DataUtils.GetCurrentUnixTimestampMillis(DateTime.Now);
            return false;
        }

        /// <summary>
        /// API đồng bộ danh sách phòng ban
        /// </summary>
        /// <param name="requestTime">Thời gian đồng bộ</param>
        /// <returns>Danh sách phòng ban</returns>
        [HttpGet]
        [Route("api/phong-ban")]
        public DM_Response GetAllPhongBan(string requestTime = null)
        {
            if (!isAccesable(getTokenInHeader()))
            {
                DM_Response token = new DM_Response();
                token.Message = "01";
                token.Note = "Token key quá hạn hoặc không tìm thấy trên hệ thống";
                return token;
            }


            // Toa an
            List<DM_TOAAN> toaAns;
            if (requestTime != null)
            {
                double ticks = double.Parse(requestTime);
                TimeSpan time = TimeSpan.FromMilliseconds(ticks);
                DateTime requestDate = new DateTime(1970, 1, 1) + time;
                toaAns = context.DM_TOAAN
                    .Where(x => (x.NGAYSUA >= requestDate && x.NGAYTAO >= requestDate && x.HIEULUC == 1))
                    .ToList();
            }
            else
            {
                toaAns = context.DM_TOAAN
                .Where(x => (x.HIEULUC == 1)).ToList();
            }

            List<DM_PhongBanDTO> result = new List<DM_PhongBanDTO>();
            List<DM_TOAAN> root = toaAns.FindAll(x => x.CAPCHAID == 0 && x.HIEULUC == 1).ToList();
            foreach (DM_TOAAN element1 in root)
            {
                DM_PhongBanDTO resultE = toDTO(element1, "1");
                result.Add(resultE);
            }

            foreach (DM_PhongBanDTO element in result)
            {
                DeQuy(toaAns, element);
            }

            // Phong ban
            List<DM_PHONGBAN> phongBanEntities = context.DM_PHONGBAN.ToList();
            List<DM_PHONGBAN> rootPhongBanEntities = phongBanEntities.FindAll(x => x.CAPCHAID == 0 || x.CAPCHAID == null).ToList();
            List<DM_PhongBanDTO> rootPhongBanDTOs = toDTOs(rootPhongBanEntities);
            foreach (DM_PhongBanDTO phongBan in rootPhongBanDTOs)
            {
                DeQuy(phongBanEntities, phongBan);
            }
            setPhongBan(result, rootPhongBanDTOs);

            DM_Response Res = new DM_Response();
            Res.Message = "00";
            Res.Note = "Danh sách tòa án";
            Res.Data = result;
            return Res;
        }

        /// <summary>
        /// Hàm đệ quy thực hiện tạo cây phòng ban phân cấp cha con
        /// </summary>
        /// <param name="result">Danh sách phòng ban dưới dạng cây</param>
        /// <param name="phongBans">Danh sách toàn bộ phòng ban</param>
        private void setPhongBan(List<DM_PhongBanDTO> result, List<DM_PhongBanDTO> phongBans)
        {
            foreach (DM_PhongBanDTO phongBan in result)
            {
                if (phongBan.type == "1")
                {
                    if ("CAPTINH".Equals(phongBan.deptType))
                    {
                        List<DM_PhongBanDTO> childrenPhongBanForHuyen = phongBans.Where(x => x.parentId == null).ToList();
                        List<DM_PhongBanDTO> childrenPhongBanForHuyenWithParentId = new List<DM_PhongBanDTO>();
                        childrenPhongBanForHuyen.ForEach((child) => {
                            DM_PhongBanDTO clone = (DM_PhongBanDTO) child.Clone();
                            clone.parentId = phongBan.id;
                            childrenPhongBanForHuyenWithParentId.Add(clone);
                        });
                        phongBan.children.AddRange(childrenPhongBanForHuyenWithParentId);
                    }
                    List<DM_PhongBanDTO> childrenPhongBan = phongBans.Where(x => x.parentId == phongBan.id).ToList();
                    if (childrenPhongBan.Count != 0)
                    {
                        phongBan.children.AddRange(childrenPhongBan);
                    }
                    if (phongBan.children != null && phongBan.children.Count != 0)
                    {
                        setPhongBan(phongBan.children, phongBans);
                    }
                }
            }
        }

        /// <summary>
        /// Hàm đệ quy thực hiện xây dựng cây tòa án phân cấp cha con
        /// </summary>
        /// <param name="alls">danh sách tất cả tòa án</param>
        /// <param name="cha">Tòa án cha</param>
        private void DeQuy(List<DM_TOAAN> alls, DM_PhongBanDTO cha)
        {
            List<DM_TOAAN> root = alls.FindAll(x => x.CAPCHAID.Equals(cha.id)).ToList();
            cha.children = toDTOs(root);
            if (cha.children != null && cha.children.Count != 0)
            {
                List<DM_PhongBanDTO> childrens = cha.children;
                foreach (DM_PhongBanDTO element1 in childrens)
                {
                    DeQuy(alls, element1);
                }
            }
        }

        /// <summary>
        /// Hàm đệ quy thực hiện xây dựng cây phòng ban phân cấp cha con
        /// </summary>
        /// <param name="alls">danh sách tất cả phòng ban</param>
        /// <param name="cha">Tòa án cha</param>
        private void DeQuy(List<DM_PHONGBAN> alls, DM_PhongBanDTO cha)
        {
            List<DM_PhongBanDTO> childrens = toDTOs(alls.FindAll(x => x.CAPCHAID.Equals(cha.id)).ToList());
            cha.children = childrens;
            if (cha.children != null && cha.children.Count != 0)
            {
                foreach (DM_PhongBanDTO child in childrens)
                {
                    DeQuy(alls, child);
                }
            }
        }

        /// <summary>
        /// Hàm thực hiện convert dữ liệu lấy từ DB
        /// </summary>
        /// <param name="entity">Dữ liệu lấy từ DB - tòa án</param>
        /// <param name="type">Loại</param>
        /// <returns>Trả về phòng ban sau khi convert</returns>
        private DM_PhongBanDTO toDTO(DM_TOAAN entity, string type)
        {
            if (entity == null)
            {
                return null;
            }
            DM_PhongBanDTO dto = new DM_PhongBanDTO();
            dto.deptCode = entity.MA;
            dto.deptName = entity.TEN;
            dto.address = entity.DIACHI;
            dto.id = entity.ID;
            dto.parentId = entity.CAPCHAID;
            dto.identifyCode = entity.MADONGBO;
            dto.telephone = entity.DIENTHOAI;
            dto.fax = entity.FAX;
            dto.deptType = entity.LOAITOA;
            dto.isActive = entity.HIEULUC;
            dto.type = type;
            return dto;
        }

        /// <summary>
        /// Hàm thực hiện convert dữ liệu lấy từ DB
        /// </summary>
        /// <param name="entity">Dữ liệu lấy từ DB - phòng ban</param>
        /// <param name="type">Loại</param>
        /// <returns>Trả về phòng ban sau khi convert</returns>
        private DM_PhongBanDTO toDTO(DM_PHONGBAN entity)
        {
            if (entity == null)
            {
                return null;
            }
            DM_PhongBanDTO dto = new DM_PhongBanDTO();
            dto.deptCode = "";
            dto.deptName = entity.TENPHONGBAN;
            dto.address = entity.DIACHI;
            dto.id = entity.ID;
            dto.parentId = entity.CAPCHAID != null && entity.CAPCHAID != 0 ? entity.CAPCHAID : entity.TOAANID;
            dto.identifyCode = entity.MADONGBO;
            // dto.telephone = entity.DIENTHOAI;
            // dto.fax = entity.FAX;
            // dto.deptType = entity.LOAITOA;
            dto.isActive = entity.HIEULUC;
            dto.type = "0";
            return dto;
        }

        /// <summary>
        /// Hàm convert danh sách phòng ban từ DB về danh sách phòng ban dữ liệu chung
        /// </summary>
        /// <param name="entities">Danh sách phòng ban lấy từ DB</param>
        /// <returns>Danh sách phòng ban dữ liệu chung</returns>
        private List<DM_PhongBanDTO> toDTOs(List<DM_PHONGBAN> entities)
        {
            List<DM_PhongBanDTO> result = new List<DM_PhongBanDTO>();
            foreach (DM_PHONGBAN entity in entities)
            {
                DM_PhongBanDTO dto = toDTO(entity);
                result.Add(dto);
            }
            return result;
        }

        /// <summary>
        /// Hàm convert danh sách Tòa án từ DB về danh sách phòng ban dữ liệu chung
        /// </summary>
        /// <param name="entities">Danh sách tòa án lấy từ DB</param>
        /// <returns>Danh sách phòng ban dữ liệu chung</returns>
        private List<DM_PhongBanDTO> toDTOs(List<DM_TOAAN> entities)
        {
            List<DM_PhongBanDTO> result = new List<DM_PhongBanDTO>();
            foreach (DM_TOAAN entity in entities)
            {
                DM_PhongBanDTO dto = toDTO(entity, "1");
                result.Add(dto);
            }
            return result;
        }
    }
}