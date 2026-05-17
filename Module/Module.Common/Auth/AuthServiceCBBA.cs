using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;


namespace Module.Common.Auth
{
    public class AuthServiceCBBA
    {
        public async Task<string> AuthenticateAsync()
        {
            using (var httpClient = new HttpClient())
            {
                var loginData = new
                {
                    secretId = "QLTA",
                    secretPass = "k5yXfEPIg8epwr9oUKBMuh6ZP1O76F18bxEpQRsE"
                };

                string json = JsonConvert.SerializeObject(loginData);
                var content = new StringContent(json, Encoding.UTF8, "application/json");

                var loginUrl = "http://10.1.19.161:8007/oauth2/JWTToken";

                try
                {
                    //var response = await httpClient.PostAsync(loginUrl, content);
                    httpClient.Timeout = TimeSpan.FromSeconds(10);
                    Console.WriteLine("Đang gửi request tới: " + loginUrl);
                    var response = await httpClient.PostAsync(loginUrl, content).ConfigureAwait(false);
                    Console.WriteLine("Đã nhận response: " + response.StatusCode);

                    string responseBody = await response.Content.ReadAsStringAsync().ConfigureAwait(false);
                    Console.WriteLine("Nội dung phản hồi: " + responseBody);

                    if (response.IsSuccessStatusCode)
                    {
                        var result = JsonConvert.DeserializeObject<LoginResponse>(responseBody);
                        return result.token;
                    }
                    else
                    {
                        Console.WriteLine("❌ Lỗi từ server: " + response.StatusCode);
                        Console.WriteLine("Thông tin chi tiết: " + responseBody);
                        return null;
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine("❌ Lỗi kết nối hoặc JSON: " + ex.Message);
                    return null;
                }
            }
        }
       
    }
}