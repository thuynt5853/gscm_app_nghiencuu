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
    public class WS_DMTinhController : ApiController
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
        /// API đồng bộ danh sách tỉnh/huyện
        /// </summary>
        /// <param name="requestTime">Thời gian đồng bộ</param>
        /// <returns>Danh sách tỉnh/huyện</returns>
        [HttpGet]
        [Route("api/tinh")]
        public DM_Response GetAllTinh(string requestTime = null)
        {
            if (!isAccesable(getTokenInHeader()))
            {
                DM_Response token = new DM_Response();
                token.Message = "01";
                token.Note = "Token key quá hạn hoặc không tìm thấy trên hệ thống";
                return token;
            }
            // string requestTime = null;
            List<DM_HANHCHINH> allHanhChinhs;
            if (requestTime != null)
            {
                double ticks = double.Parse(requestTime);
                TimeSpan time = TimeSpan.FromMilliseconds(ticks);
                DateTime requestDate = new DateTime(1970, 1, 1) + time;
                allHanhChinhs = context.DM_HANHCHINH
                    .Where(x => (x.NGAYSUA >= requestDate && x.NGAYTAO >= requestDate && x.HIEULUC == 1))
                    .ToList();
            }
            else
            {
                allHanhChinhs = context.DM_HANHCHINH.ToList();
            }

            List<DMTinhDTO> result = new List<DMTinhDTO>();
            List<DM_HANHCHINH> root = allHanhChinhs.FindAll(x => x.CAPCHAID == 0 && x.HIEULUC == 1).ToList();
            foreach (DM_HANHCHINH element1 in root)
            {
                DMTinhDTO resultE = toDTO(element1);
                result.Add(resultE);
            }
            foreach (DMTinhDTO element1 in result)
            {
                DeQuy(allHanhChinhs, element1);
            }

            DM_Response Res = new DM_Response();
            Res.Message = "00";
            Res.Note = "Danh sách tỉnh";
            Res.Data = result;
            return Res;
        }

        /// <summary>
        /// Hàm đệ quy xây dụng danh mục phân cấp cha con
        /// </summary>
        /// <param name="alls">Danh sách tất cả danh mục hành chính</param>
        /// <param name="cha">Danh mục hành chính cha</param>
        private void DeQuy(List<DM_HANHCHINH> alls, DMTinhDTO cha)
        {
            List<DM_HANHCHINH> root = alls.FindAll(x => x.CAPCHAID.Equals(cha.id)).ToList();
            cha.children = toDTOs(root);
            if (cha.children != null && cha.children.Count != 0)
            {
                List<DMTinhDTO> childrens = cha.children;
                foreach (DMTinhDTO element1 in childrens)
                {
                    DeQuy(alls, element1);
                }
            }
        }

        /// <summary>
        /// Hàm thực hiện convert dữ liệu DB
        /// </summary>
        /// <param name="entity">Dữ liệu lấy từ DB</param>
        /// <returns>DTO dữ liệu trả về</returns>
        private DMTinhDTO toDTO(DM_HANHCHINH entity)
        {
            if (entity == null)
                return null;
            DMTinhDTO dto = new DMTinhDTO();
            dto.id = entity.ID;
            dto.maTinh = entity.MA;
            dto.tenTinh = entity.TEN;
            dto.parentId = entity.CAPCHAID;
            return dto;
        }

        /// <summary>
        /// Hàm thực hiện convert dữ liệu DB - list
        /// </summary>
        /// <param name="entities">Danh sách dữ liệu lấy từ DB</param>
        /// <returns>Danh sách DTO dữ liệu trả về</returns>
        private List<DMTinhDTO> toDTOs(List<DM_HANHCHINH> entities)
        {
            List<DMTinhDTO> result = new List<DMTinhDTO>();
            foreach (DM_HANHCHINH entity in entities)
            {
                DMTinhDTO dto = toDTO(entity);
                result.Add(dto);
            }
            return result;
        }
    }
}