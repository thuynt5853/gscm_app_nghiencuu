using DAL.GSTP;
using Module.Common;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net.Http;
using System.Net.Mime;
using System.Threading.Tasks;
using System.Web;

namespace BL.GSTP
{
    public class TroLyAoInfor
    {
        public string AccessToken { get; set; }
        public string UUID { get; set; }
    }
    public static class TroLyAoHelper
    {
        public class InforLogin
        {
            public InforLogin() { }
            public InforLogin(string userName, string password)
            {
                UserName = userName;
                Password = password;
                RememberMe = true;
                Confirm = true;
            }
            public InforLogin(string userName, string password, bool rememberMe, bool confirm)
            {
                UserName = userName;
                Password = password;
                RememberMe = rememberMe;
                Confirm = confirm;
            }
            [JsonProperty("userName")]
            public string UserName { get; set; }
            [JsonProperty("password")]
            public string Password { get; set; }
            [JsonProperty("rememberMe")]
            public bool RememberMe { get; set; }
            [JsonProperty("confirm")]
            public bool Confirm { get; set; }
        }
        public static async Task<TroLyAoInfor> GetToken()
        {

            try
            {
                InforLogin loginInfor = new InforLogin(userName: ConfigurationManager.AppSettings["MaHoaUserName"], password: ConfigurationManager.AppSettings["MaHoaPassword"]);
                using (HttpClient client = new HttpClient())
                {
                    TroLyAoInfor troLyAoInfor = new TroLyAoInfor() { UUID = "615f5f8f-jjff-kjaf-nnnn-laksdkfckn3141" };
                    var request = new HttpRequestMessage(HttpMethod.Post, ConfigurationManager.AppSettings["MaHoaUrlGetToken"]);
                    request.Headers.Add("User-Agent", "web-desktop");
                    request.Headers.Add("ip", "key");
                    request.Headers.Add("Device-UUID", troLyAoInfor.UUID.ToString());
                    request.Content = new StringContent(JsonConvert.SerializeObject(loginInfor), null, "application/json");
                    var response = await client.SendAsync(request);
                    response.EnsureSuccessStatusCode();
                    var resultText = await response.Content.ReadAsStringAsync();
                    TroLyAoResult result = JsonConvert.DeserializeObject<TroLyAoResult>(resultText.ToString());
                    if (result != null && result.Messages.Status == 200)
                    {
                        troLyAoInfor.AccessToken = result.AccessToken;
                        return troLyAoInfor;
                    }
                    return null;
                }
            }
            catch
            {
                return null;
            }
        }
        public class Messages
        {
            [JsonProperty("status")]
            public int Status;
        }

        public class TroLyAoResult
        {
            [JsonProperty("messages")]
            public Messages Messages;

            [JsonProperty("access_token")]
            public string AccessToken;
        }
    }
}