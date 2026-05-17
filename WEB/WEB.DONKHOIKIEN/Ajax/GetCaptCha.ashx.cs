using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;

namespace WEB.DONKHOIKIEN.Ajax
{
    /// <summary>
    /// Summary description for GetCaptCha
    /// </summary>
    public class GetCaptCha : IHttpHandler
    {
        public bool IsReusable { get { return true; } }

        public void ProcessRequest(HttpContext context)
        {
            try
            {
                //Clear old captcha
                if (context.Request.Form["oldcaptcha"] != null && !string.IsNullOrEmpty(context.Request.Form["oldcaptcha"]))
                {
                    context.Cache.Remove(context.Request.Form["oldcaptcha"]);
                }
                string captch = Guid.NewGuid().ToString();
                context.Cache.Add(captch, Randomnumber(), null, DateTime.Now.AddMinutes(5), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);

                context.Response.Write(captch);


            }
            catch (Exception ex)
            {
                throw ex;
                //context.Response.Write("{ \"ret\": \"-1\", \"msg\": \"" + ex.Message + "\" }");
            }
        }

        public string Randomnumber()
        {
            const byte LENGTH = 6;

            // chuỗi để lấy các kí tự sẽ sử dụng cho captcha
            const string chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";

            // Lưu chuỗi captcha trong quá trình tạo
            StringBuilder strCaptcha = new StringBuilder();

            Random rand = new Random();

            for (int i = 0; i < LENGTH; i++)
            {
                // Lấy kí tự ngẫu nhiên từ mảng chars
                string str = chars[rand.Next(chars.Length)].ToString();
                strCaptcha.Append(str);
            }
            string str1 = strCaptcha.ToString();
            return str1;
        }
    }
}