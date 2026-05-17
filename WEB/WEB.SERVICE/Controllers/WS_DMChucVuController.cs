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
    public class WS_DMChucVuController : ApiController
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

        // GET: api/WS_DMChucVu
        public IEnumerable<string> Get()
        {
            return new string[] { "value1", "value2" };
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
        [Route("api/get/getAllChucVu")]
        public DM_Response GetChucVuS(string requestTime = null)
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
                // groupId = 13 => danh mục chức vụ
                List<DM_DATAITEM> dataItem = dt.DM_DATAITEM.Where(x => x.GROUPID == 13 && (x.NGAYSUA >= requestDate || x.NGAYTAO >= requestDate)).ToList<DM_DATAITEM>();
                ConvertData(Response, dataItem);
            }
            else
            {
                List<DM_DATAITEM> dataItem = dt.DM_DATAITEM.Where(x => x.GROUPID == 13).ToList<DM_DATAITEM>();
                ConvertData(Response, dataItem);
            }

            return Response;
        }

        /// <summary>
        /// Hàm thực hiện convert dữ liệu lấy từ DB
        /// </summary>
        /// <param name="Response">Kết quả trả về</param>
        /// <param name="dataItem">Thông tin lấy được từ trong DB</param>
        private static void ConvertData(DM_Response Response, List<DM_DATAITEM> dataItem)
        {
            List<DM_ChucVu> DmChucVus = new List<DM_ChucVu>();
            dataItem.ForEach(x =>
            {
                DM_ChucVu ChucVu = new DM_ChucVu();
                ChucVu.Id = Decimal.ToInt64(x.ID);
                ChucVu.MaChucVu = x.MA;
                ChucVu.TenChucVu = x.TEN;
                ChucVu.GhiChu = x.MOTA;
                ChucVu.HieuLuc = Convert.ToInt64(x.HIEULUC);
                DmChucVus.Add(ChucVu);

            });
            DM_ChucVuResponse ChucVuResponse = new DM_ChucVuResponse();
            ChucVuResponse.ChucVus = DmChucVus;
            Response.Data = ChucVuResponse;
        }
    }
}
