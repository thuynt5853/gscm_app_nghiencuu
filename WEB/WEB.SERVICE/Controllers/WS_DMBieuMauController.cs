using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using WEB.Service.Controllers.Utils;
using WEB.Service.Models;

namespace WEB.Service.Controllers
{
    public class WS_DMBieuMauController : ApiController
    {
        private GSTPContext dt = new GSTPContext();

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
        private bool isAccesable(string tokenKey)
        {
            DM_TOKEN_KEY oTokenKey = dt.DM_TOKEN_KEY.Where(x => x.TOKEN_KEY.ToLower() == tokenKey.ToLower()).FirstOrDefault<DM_TOKEN_KEY>();
            if(oTokenKey != null)
                return oTokenKey.EXPIRED_TIME >= DataUtils.GetCurrentUnixTimestampMillis(DateTime.Now);
            return false;
        }
       
        /// <summary>
        /// API đồng bộ danh mục chức vụ
        /// </summary>
        /// <param name="requestTime">Thời gian đồng bộ</param>
        /// <returns>Danh sách chức vu có trong hệ thống</returns>
        [HttpGet]
        [Route("api/get/getAllBM")]
        public DM_Response GetBieuMau(string requestTime = null)
        {
            if(!isAccesable(getTokenInHeader()))
            {
                DM_Response Res = new DM_Response();
                Res.Message = "01";
                Res.Note = "Token key quá hạn hoặc không tìm thấy trên hệ thống";
                return Res;
            }
            DM_Response Response = new DM_Response();
            Response.Message = "00";
            Response.RequestTime = requestTime;
            Response.Note = "Thành công";

            if (requestTime != null)
            {
                double ticks = double.Parse(requestTime);
                TimeSpan time = TimeSpan.FromMilliseconds(ticks);
                DateTime requestDate = new DateTime(1970, 1, 1) + time;
                List<DM_BIEUMAU> dataItem = dt.DM_BIEUMAU.ToList<DM_BIEUMAU>();
                ConvertData(Response, dataItem);
            }
            else
            {
                List<DM_BIEUMAU> dataItem = dt.DM_BIEUMAU.ToList<DM_BIEUMAU>();
                ConvertData(Response, dataItem);
            }

            return Response;
        }

        /// <summary>
        /// Hàm thực hiện convert dữ liệu lấy từ DB
        /// </summary>
        /// <param name="Response">Kết quả trả về</param>
        /// <param name="dataItem">Thông tin lấy được từ trong DB</param>
        private static void ConvertData(DM_Response Response, List<DM_BIEUMAU> dataItem)
        {
            List<DM_BieuMau> bieuMauList = dataItem
                .Select(x => new DM_BieuMau
                {
                    BieuMauId = x.ID,
                    TenBieuMau = x.TENBM,
                    MaBieuMau = x.MABM,
                    Status = x.ACTIVE ?? 0
                })
                .ToList();
            DM_BieuMauResponse BieuMauResponse = new DM_BieuMauResponse();
            BieuMauResponse.BieuMaus = bieuMauList;
            Response.Data = BieuMauResponse;
        }
    }
}
