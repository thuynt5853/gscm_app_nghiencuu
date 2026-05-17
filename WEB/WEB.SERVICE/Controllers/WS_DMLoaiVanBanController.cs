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
    public class WS_DMLoaiVanBanController : ApiController
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
        /// API đồng bộ loại văn bản
        /// </summary>
        /// <param name="requestTime">Thời gian đồng bộ</param>
        /// <returns>Danh sách loại văn bản - Hardcode</returns>
        [HttpGet]
        [Route("api/loai-van-ban")]
        public DM_Response GetAllLoaiVanBan(string requestTime = null)
        {
            if (!isAccesable(getTokenInHeader()))
            {
                DM_Response token = new DM_Response();
                token.Message = "01";
                token.Note = "Token key quá hạn hoặc không tìm thấy trên hệ thống";
                return token;
            }
            List<DM_LoaiVanBanDTO> result = new List<DM_LoaiVanBanDTO>();

            DM_Response Res = new DM_Response();
            Res.Message = "00";
            Res.Note = "Danh sách loại văn bản";

            // Thực hiện hard code danh mục loại văn bản
                DM_LoaiVanBanDTO dto1 = new DM_LoaiVanBanDTO();
                dto1.maLoaiVanBan = "Văn bản hành chính,Tài liệu chung";
                dto1.tenLoaiVanBan = "Văn bản hành chính,Tài liệu chung";
                dto1.id = 5;
                result.Add(dto1);

                DM_LoaiVanBanDTO dto2 = new DM_LoaiVanBanDTO();
                dto2.maLoaiVanBan = "Đơn đề nghị GĐT,TT";
                dto2.tenLoaiVanBan = "Đơn đề nghị GĐT,TT";
                dto2.id = 1;
                result.Add(dto2);

                DM_LoaiVanBanDTO dto3 = new DM_LoaiVanBanDTO();
                dto3.maLoaiVanBan = "Công văn";
                dto3.tenLoaiVanBan = "Công văn";
                dto3.id = 2;
                result.Add(dto3);

                DM_LoaiVanBanDTO dto4 = new DM_LoaiVanBanDTO();
                dto4.maLoaiVanBan = "Đơn đề nghị GĐT,TT kèm theo CV chuyển đơn";
                dto4.tenLoaiVanBan = "Đơn đề nghị GĐT,TT kèm theo CV chuyển đơn";
                dto4.id = 3;
                result.Add(dto4);

                DM_LoaiVanBanDTO dto5 = new DM_LoaiVanBanDTO();
                dto5.maLoaiVanBan = "Hồ sơ Kháng nghị GĐT,TT";
                dto5.tenLoaiVanBan = "Hồ sơ Kháng nghị GĐT,TT";
                dto5.id = 4;
                result.Add(dto5);

                DM_LoaiVanBanDTO dto6 = new DM_LoaiVanBanDTO();
                dto6.maLoaiVanBan = "CV kiến nghị GĐT,TT";
                dto6.tenLoaiVanBan = "CV kiến nghị GĐT,TT";
                dto6.id = 6;
                result.Add(dto6);

                DM_LoaiVanBanDTO dto7 = new DM_LoaiVanBanDTO();
                dto7.maLoaiVanBan = "CV kiến nghị GĐT,TT kèm theo Hồ sơ";
                dto7.tenLoaiVanBan = "CV kiến nghị GĐT,TT kèm theo Hồ sơ";
                dto7.id = 9;
                result.Add(dto7);

                DM_LoaiVanBanDTO dto8 = new DM_LoaiVanBanDTO();
                dto8.maLoaiVanBan = "Thông báo phát hiện vi phạm pháp luật";
                dto8.tenLoaiVanBan = "Thông báo phát hiện vi phạm pháp luật";
                dto8.id = 7;
                result.Add(dto8);

                DM_LoaiVanBanDTO dto9 = new DM_LoaiVanBanDTO();
                dto9.maLoaiVanBan = "Đơn khiếu nại tư pháp";
                dto9.tenLoaiVanBan = "Đơn khiếu nại tư pháp";
                dto9.id = 8;
                result.Add(dto9);
            Res.Data = result;
            
            return Res;
        }
    }
}