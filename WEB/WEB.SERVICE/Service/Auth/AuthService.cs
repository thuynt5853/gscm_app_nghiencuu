using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Net.Http.Headers;
using Newtonsoft.Json.Linq;
using System.Configuration;

namespace WEB.Service.Service.Auth
{
    public class AuthService
    {
        public async Task<string> AuthenticateAsync()
        {
            using (var httpClient = new HttpClient())
            {

                var loginUrl = ConfigurationManager.AppSettings["ApiJobShared"] + "/oauth2/token";
                //var loginUrl = "http://jobshare.toaan.gov.vn/oauth2/token";
                string username = "toa-an-api-client";
                string password = "00cb22c0a92d45458e7fb0915242a92f";
                try
                {
                    Console.WriteLine("Bắt đầu tạo Authorization Header...");
                    // Tạo chuỗi base64 từ username:password
                    var byteArray = Encoding.ASCII.GetBytes($"{username}:{password}");
                    var authHeader = Convert.ToBase64String(byteArray);
                    httpClient.DefaultRequestHeaders.Authorization =
                        new AuthenticationHeaderValue("Basic", authHeader);

                    // Nội dung gửi lên cần có grant_type
                    var content = new StringContent("grant_type=client_credentials", Encoding.UTF8, "application/x-www-form-urlencoded");
                    // Tăng timeout (nếu server phản hồi chậm)
                    httpClient.Timeout = TimeSpan.FromSeconds(10);
                    var response = await httpClient.PostAsync(loginUrl, content).ConfigureAwait(false);
                    string responseBody = await response.Content.ReadAsStringAsync().ConfigureAwait(false);
                    Console.WriteLine("Nội dung phản hồi: " + responseBody);
                    if (response.IsSuccessStatusCode)
                    {
                        string json = await response.Content.ReadAsStringAsync();
                        //var result = JsonConvert.DeserializeObject<LoginResponse>(responseBody);
                        // Dùng JObject để lấy token
                        var obj = JObject.Parse(json);
                        return obj["access_token"]?.ToString();
                    }
                    else
                    {
                        Console.WriteLine("Lỗi xác thực: " + response.StatusCode);
                        return null;
                    }
                }
                catch (HttpRequestException httpEx)
                {
                    Console.WriteLine("Lỗi kết nối HTTP: " + httpEx.Message);
                    return null;
                }
                catch (TaskCanceledException timeoutEx)
                {
                    Console.WriteLine("Lỗi timeout hoặc bị huỷ request: " + timeoutEx.Message);
                    return null;
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Lỗi không xác định: " + ex.Message);
                    return null;
                }
            }
        }
       
    }
}