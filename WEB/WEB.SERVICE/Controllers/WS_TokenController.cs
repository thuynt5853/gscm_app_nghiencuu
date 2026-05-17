using BL.GSTP.BANGSETGET;
using DAL.GSTP;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Security.Cryptography;
using System.Text;
using System.Web.Http;
using WEB.Service.Controllers.Utils;
using WEB.Service.Models;

namespace WEB.Service.Controllers
{
    public class WS_TokenController : ApiController
    {
        private GSTPContext dt = new GSTPContext();

        /// <summary>
        /// Hàm thực hiện validate và tạo token kết nối với hệ thống voffice
        /// </summary>
        /// <param name="MaDongBo">Mã đồng bộ được gửi từ hệ thống Voffice</param>
        /// <returns>Token được sinh mới từ mã đồng bộ</returns>
        /// 
        /// <summary>
        /// API đồng bộ danh sách tỉnh/huyện
        /// </summary>
        /// <param name="requestTime">Thời gian đồng bộ</param>
        /// <returns>Danh sách tỉnh/huyện</returns>
        [HttpGet]
        [Route("api/GetToken/{MaDongBo}")]
        public object GetToken([FromUri] string MaDongBo)
        {
            MessageResult oMsg = new MessageResult();
            LOG_API log = new LOG_API();
            var CONTENT_JSON = "";
            List<DM_TOKEN_KEY> list = dt.DM_TOKEN_KEY.ToList<DM_TOKEN_KEY>();
            Console.Out.Write(list.Count);
            DM_TOKEN_KEY oTokenKey = dt.DM_TOKEN_KEY.Where(x => x.SECRET_KEY.ToLower() == MaDongBo.ToLower()).FirstOrDefault<DM_TOKEN_KEY>();
            if (oTokenKey == null)
            {
                oMsg.Status = "01";
                oMsg.Message = "SecretKey không đúng :3 ";

                //Log call api
                CONTENT_JSON = JsonConvert.SerializeObject(oTokenKey, Formatting.Indented);
                log.InsertLog("api/GetToken", oMsg.Message, CONTENT_JSON);

                return oMsg;
            }


            TokenResponse token = new TokenResponse();
            token.TokenKey = HashSh1(MaDongBo);
            token.ExpiredTime = DataUtils.GetCurrentUnixTimestampMillis(DateTime.Now.AddDays(1));

            oTokenKey.LAST_LOGIN = DateTime.Now;
            oTokenKey.EXPIRED_TIME = token.ExpiredTime;
            oTokenKey.TOKEN_KEY = token.TokenKey;
            dt.SaveChanges();
            
            oMsg.Status = "00";
            oMsg.Message = "Thành công";
            oMsg.Data = token;

            //Log call api
            CONTENT_JSON = JsonConvert.SerializeObject(oTokenKey, Formatting.Indented);
            log.InsertLog("api/GetToken", oMsg.Message, CONTENT_JSON);

            return oMsg;
        }

        public object Get(string MaDongBo)
        {
            MessageResult oMsg = new MessageResult();

            List<DM_TOKEN_KEY> list = dt.DM_TOKEN_KEY.ToList<DM_TOKEN_KEY>();
            Console.Out.Write(list.Count);
            DM_TOKEN_KEY oTokenKey = dt.DM_TOKEN_KEY.Where(x => x.SECRET_KEY.ToLower() == MaDongBo.ToLower()).FirstOrDefault<DM_TOKEN_KEY>();
            if (oTokenKey == null)
            {
                oMsg.Status = "01";
                oMsg.Message = "SecretKey không đúng, phải nhập VOffice-Secretkey để test nhé :v ";
                return oMsg;
            }
            
        
            TokenResponse token = new TokenResponse();
            token.TokenKey = HashSh1(MaDongBo);
            token.ExpiredTime = DataUtils.GetCurrentUnixTimestampMillis(DateTime.Now.AddDays(1));

            oTokenKey.LAST_LOGIN = DateTime.Now;
            oTokenKey.EXPIRED_TIME = token.ExpiredTime;
            oTokenKey.TOKEN_KEY = token.TokenKey;
            dt.SaveChanges();

            oMsg.Status = "00";
            oMsg.Message = "Thành công";
            oMsg.Data = token;
            return oMsg;
        }


        /// <summary>
        /// Hàm thực hiện hash dữ liệu sh1
        /// </summary>
        /// <param name="input">input cần hash</param>
        /// <returns>chuỗi được hash</returns>
        static string HashSh1(string input)
        {
            using (SHA1Managed sha1 = new SHA1Managed())
            {
                var hashSh1 = sha1.ComputeHash(Encoding.UTF8.GetBytes(input));

                // declare stringbuilder
                var sb = new StringBuilder(hashSh1.Length * 2);

                // computing hashSh1
                foreach (byte b in hashSh1)
                {
                    // "x2"
                    sb.Append(b.ToString("X2").ToLower());
                }


                return sb.ToString();
            }
        }
    }

    
}
