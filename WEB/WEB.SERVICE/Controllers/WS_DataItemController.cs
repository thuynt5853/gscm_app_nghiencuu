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
    public class WS_DataItemController : ApiController
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
        /// API đồng bộ thông tin quốc tịch
        /// </summary>
        /// <param name="requestTime">Thời gian gọi request đồng bộ</param>
        /// <returns>Danh sách quốc tịch</returns>
        [HttpGet]
        [Route("api/quoc-tich")]
        public DM_Response GetAllQuocTich(string requestTime = null)
        {
            if (!isAccesable(getTokenInHeader()))
            {
                DM_Response token = new DM_Response();
                token.Message = "01";
                token.Note = "Token key quá hạn hoặc không tìm thấy trên hệ thống";
                return token;
            }
            List<DM_DATAITEM> allQuocTichs;
            if (requestTime == null)
            {
                // groupId = 2 => quốc tịch
                allQuocTichs = context.DM_DATAITEM.Where(e => e.GROUPID == 2).ToList();
            }
            else
            {
                double ticks = double.Parse(requestTime);
                TimeSpan time = TimeSpan.FromMilliseconds(ticks);
                DateTime requestDate = new DateTime(1970, 1, 1) + time;
                allQuocTichs = context.DM_DATAITEM.Where(x => x.GROUPID == 2 && x.NGAYSUA >= requestDate && x.NGAYTAO >= requestDate).ToList();
            }
            List<QuocTichDTO> data = new List<QuocTichDTO>();
            foreach (DM_DATAITEM item in allQuocTichs)
            {
                QuocTichDTO dto = new QuocTichDTO();
                dto.Id = item.ID;
                dto.Ma = item.MA;
                dto.Ten = item.TEN;
                dto.Mota = item.MOTA;
                data.Add(dto);
            }
            DM_Response Res = new DM_Response();
            Res.Message = "00";
            Res.Note = "Danh sách quốc tịch";
            Res.Data = data;
            return Res;
        }

        /// <summary>
        /// API đồng bộ tư cách tố tụng
        /// </summary>
        /// <param name="requestTime">Thời gian đồng bộ</param>
        /// <returns>Tra về danh sách tư cách tố tụng</returns>
        [HttpGet]
        [Route("api/tu-cach-to-tung")]
        public DM_Response GetAllTuCachToTung(string requestTime = null)
        {
            if (!isAccesable(getTokenInHeader()))
            {
                DM_Response token = new DM_Response();
                token.Message = "01";
                token.Note = "Token key quá hạn hoặc không tìm thấy trên hệ thống";
                return token;
            }
            List<DM_DATAITEM> allQuocTichs;
            if (requestTime == null)
            {
                // groupId = 11, 16, 25 => tư cách tố tụng
                allQuocTichs = context.DM_DATAITEM.Where(e => e.GROUPID == 11 || e.GROUPID == 16 || e.GROUPID == 25).ToList();
            }
            else
            {
                double ticks = double.Parse(requestTime);
                TimeSpan time = TimeSpan.FromMilliseconds(ticks);
                DateTime requestDate = new DateTime(1970, 1, 1) + time;
                allQuocTichs = context.DM_DATAITEM.Where(x => (x.GROUPID == 11 || x.GROUPID == 16 || x.GROUPID == 25) && x.NGAYSUA >= requestDate && x.NGAYTAO >= requestDate).ToList();
            }
            List<QuocTichDTO> data = new List<QuocTichDTO>();
            foreach (DM_DATAITEM item in allQuocTichs)
            {
                QuocTichDTO dto = new QuocTichDTO();
                dto.Id = item.ID;
                dto.Ma = item.MA;
                dto.Ten = item.TEN;
                dto.Mota = item.GROUPID + "";
                data.Add(dto);
            }
            DM_Response Res = new DM_Response();
            Res.Message = "00";
            Res.Note = "Danh sách tố tụng";
            Res.Data = data;
            return Res;
        }

        /// <summary>
        /// API đồng bộ danh mục tội danh
        /// </summary>
        /// <param name="requestTime">Thời gian đồng bộ</param>
        /// <returns>Tra về danh sách tội danh</returns>
        [HttpGet]
        [Route("api/toi-danh")]
        public DM_Response getAllToiDanh(string requestTime = null)
        {
            if (!isAccesable(getTokenInHeader()))
            {
                DM_Response token = new DM_Response();
                token.Message = "01";
                token.Note = "Token key quá hạn hoặc không tìm thấy trên hệ thống";
                return token;
            }
            List<DM_BOLUAT_TOIDANH> allToiDanh;
            if (requestTime == null)
            {
                // lấy thông tin tội danh có luatId = 7, hieuluc = 1, loai = 2
                allToiDanh = context.DM_BOLUAT_TOIDANH.Where(e => e.LUATID == 7 && e.HIEULUC == 1 && e.LOAI == 2).ToList();
            } 
            else
            {
                double ticks = double.Parse(requestTime);
                TimeSpan time = TimeSpan.FromMilliseconds(ticks);
                DateTime requestDate = new DateTime(1970, 1, 1) + time;
                allToiDanh = context.DM_BOLUAT_TOIDANH.Where(x => (x.LUATID == 7 && x.HIEULUC == 1 && x.LOAI == 2) && x.NGAYSUA >= requestDate && x.NGAYTAO >= requestDate).ToList();
            }
            List<ToiDanhDTO> data = new List<ToiDanhDTO>();
            foreach (DM_BOLUAT_TOIDANH item in allToiDanh)
            {
                ToiDanhDTO dto = new ToiDanhDTO();
                dto.Id = item.ID;
                dto.Dieu = item.DIEU;
                dto.TenToiDanh = item.TENTOIDANH;
                dto.LuatId = item.LUATID;
                dto.loai = item.LOAI;
                dto.hieuluc = item.HIEULUC;
                data.Add(dto);
            }
            DM_Response Res = new DM_Response();
            Res.Message = "00";
            Res.Note = "Danh sách Tội danh";
            Res.Data = data;
            return Res;
        }
    }

}