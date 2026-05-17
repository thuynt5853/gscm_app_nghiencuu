using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Net.Http.Headers;
using System.IO;
using System.Configuration;
using System.ComponentModel.DataAnnotations;

namespace Module.Common
{
    public class Public_JudgmentInsertDto
    {
        [StringLength(2000)]
        public string NameJudgment { get; set; }
        public int LevelJudgment { get; set; }
        public int CourtId { get; set; }
        public int StatusJudgment { get; set; }
        public int CasesStyles { get; set; }
        [StringLength(250)]
        public string NumberJudgment { get; set; }
        public DateTime? DayJudgment { get; set; }
        public int CasesId { get; set; }
        [StringLength(3000)]
        public string SummaryContent { get; set; }
        public DateTime? DatePublic { get; set; }
        public int Status { get; set; }
        public int PublicStatus { get; set; }
        public int CreateUserId { get; set; }
        [StringLength(250)]
        public string CreateUser { get; set; }
        [StringLength(150)]
        public string DateActivation { get; set; }
    }
    public class Public_JudgmentUpdateDto
    {
        public int? Id { get; set; } // Khóa chính
        public string NameJudgment { get; set; } // Tên phán quyết
        public int? LevelJudgment { get; set; } // Cấp phán quyết
        public int? StatusJudgment { get; set; } // Trạng thái phán quyết
        public int? CasesStyles { get; set; } // Loại vụ án
        public string NumberJudgment { get; set; } // Số phán quyết
        public DateTime? DayJudgment { get; set; } // Ngày phán quyết
        public int? CasesId { get; set; } // ID vụ án
        public string SummaryContent { get; set; } // Nội dung tóm tắt
        public DateTime? DatePublic { get; set; } // Ngày công khai
        public int? Status { get; set; } // Trạng thái
        public int? PublicStatus { get; set; } // Trạng thái công khai
        public DateTime? EditDate { get; set; } // Ngày chỉnh sửa (nullable)
        public string EditUser { get; set; } // Tên người chỉnh sửa (nullable)
        public string DateActivation { get; set; } // Ngày kích hoạt
    }
    public class Public_JudgmentUpdateStatusDto
    {
        public int? Id { get; set; } // Khóa chính
        public int? Status { get; set; } // Trạng thái
        public string EditUser { get; set; } // Tên người chỉnh sửa (nullable)

    }

    public class Public_file_attach
    {
        public int iD_JUDGMENT { get; set; }
        public string filE_ATTACH { get; set; }
        public string filE_NAME { get; set; }
        public DateTime? datE_ATTACH { get; set; }
        public string filE_URL { get; set; }
    }
    public class Public_slow_date
    {
        public int? ID_JUDGMENT { get; set; } // Khóa chính từ Public_Judgment
        public string NOTE_SLOW_DATE { get; set; } // Nội dung
        public int? NUMBER_DATE { get; set; } 
    }

    public class Public_an_le
    {
        public int? ID_JUDGMENT { get; set; } // Khóa chính từ Public_Judgment
        public string NO_AN_LE { get; set; } // Số án lệ
    }

    public class CallApiCBBA
    {
        private static readonly HttpClient client = new HttpClient();
        public static async Task<string> GetBearerToken()
        {
            try
            {
                var baseUrl = ConfigurationManager.AppSettings["ApiCBBA"];
                var clientId = ConfigurationManager.AppSettings["ApiCBBA:ClientId"];
                var clientSecret = ConfigurationManager.AppSettings["ApiCBBA:ClientSecret"];

                var url = baseUrl + "/oauth2/JWTToken";

                var loginObj = new
                {
                    secretId = clientId,
                    secretPass = clientSecret
                };

                var json = JsonConvert.SerializeObject(loginObj);
                var content = new StringContent(json, Encoding.UTF8, "application/json");

                using (var http = new HttpClient())
                {
                    http.Timeout = TimeSpan.FromSeconds(10);

                    var response = await http.PostAsync(url, content).ConfigureAwait(false);
                    var responseString = await response.Content.ReadAsStringAsync().ConfigureAwait(false);

                    if (!response.IsSuccessStatusCode)
                    {
                        Console.WriteLine("Lỗi lấy token: " + responseString);
                        return null;
                    }

                    var obj = JObject.Parse(responseString);
                    return obj["token"]?.ToString();   // API của bạn đang trả field "token"
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Exception lấy token: " + ex.Message);
                return null;
            }
        }
        public static async Task<decimal> Insert(string jsonBody)
        {
            try
            {
                var token = await GetBearerToken().ConfigureAwait(false); ;
                if (string.IsNullOrEmpty(token))
                {
                    Console.WriteLine("Không lấy được token");
                    return 0;
                }

                var url = ConfigurationManager.AppSettings["ApiCBBA"] + "/api/CBBA/insert";

                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Authorization =
                        new AuthenticationHeaderValue("Bearer", token);

                    var content = new StringContent(jsonBody, Encoding.UTF8, "application/json");

                    var response = await client.PostAsync(url, content).ConfigureAwait(false);
                    var responseString = await response.Content.ReadAsStringAsync().ConfigureAwait(false);

                    if (response.IsSuccessStatusCode)
                    {
                        var json = JObject.Parse(responseString);
                        var judgmentId = json["judgmentId"]?["value"]?.Value<int>() ?? 0;
                        return Convert.ToDecimal(judgmentId);
                    }
                    else
                    {
                        Console.WriteLine($"Lỗi Insert: {response.StatusCode} - {responseString}");
                        return 0;
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Exception Insert: " + ex.Message);
                return 0;
            }
        }

        public static async Task<decimal?> Update(string jsonBody)
        {
            try
            {
                var bearerToken = await GetBearerToken().ConfigureAwait(false); ;
                if (string.IsNullOrEmpty(bearerToken))
                {
                    Console.WriteLine("Không lấy được token");
                    return 0;
                }

                var url = ConfigurationManager.AppSettings["ApiCBBA"] + "/api/CBBA/update";

                var request = new HttpRequestMessage(new HttpMethod("PATCH"), url);
                request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", bearerToken);
                request.Content = new StringContent(jsonBody, Encoding.UTF8, "application/json");

                var response = await client.SendAsync(request).ConfigureAwait(false);

                if (response.IsSuccessStatusCode)
                {
                    var responseString = await response.Content.ReadAsStringAsync().ConfigureAwait(false);
                    var json = JObject.Parse(responseString);
                    var judgmentId = json["judgmentId"]?.Value<decimal>();

                    Console.WriteLine($"Cập nhật thành công. judgmentId = {judgmentId}");
                    return judgmentId;
                }
                else
                {
                    var error = await response.Content.ReadAsStringAsync().ConfigureAwait(false);
                    Console.WriteLine($"Lỗi khi cập nhật: {response.StatusCode} - {error}");
                    return null;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Exception: {ex.Message}");
                return null;
            }
        }
        public static async Task<decimal?> Update_Status(string jsonBody)
        {
            try
            {
                var bearerToken = await GetBearerToken().ConfigureAwait(false); ;
                if (string.IsNullOrEmpty(bearerToken))
                {
                    Console.WriteLine("Không lấy được token");
                    return 0;
                }

                var url = ConfigurationManager.AppSettings["ApiCBBA"] + "/api/CBBA/update-status";

                var request = new HttpRequestMessage(new HttpMethod("PATCH"), url);
                request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", bearerToken);
                request.Content = new StringContent(jsonBody, Encoding.UTF8, "application/json");

                var response = await client.SendAsync(request).ConfigureAwait(false);

                if (response.IsSuccessStatusCode)
                {
                    var responseString = await response.Content.ReadAsStringAsync().ConfigureAwait(false);
                    var json = JObject.Parse(responseString);
                    var judgmentId = json["judgmentId"]?.Value<decimal>();

                    Console.WriteLine($"Cập nhật thành công. judgmentId = {judgmentId}");
                    return judgmentId;
                }
                else
                {
                    var error = await response.Content.ReadAsStringAsync().ConfigureAwait(false);
                    Console.WriteLine($"Lỗi khi cập nhật: {response.StatusCode} - {error}");
                    return null;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Exception: {ex.Message}");
                return null;
            }
        }
        public static async Task<decimal> Insert_File_attach(string jsonBody)
        {
            try
            {
                var bearerToken = await GetBearerToken().ConfigureAwait(false); ;
                if (string.IsNullOrEmpty(bearerToken))
                {
                    Console.WriteLine("Không lấy được token");
                    return 0;
                }

                var url = ConfigurationManager.AppSettings["ApiCBBA"] + "/api/CBBA/insert-file-attach"; // Thay bằng URL thật

                // Thêm header Authorization
                client.DefaultRequestHeaders.Authorization =
                    new AuthenticationHeaderValue("Bearer", bearerToken);

                var content = new StringContent(jsonBody, Encoding.UTF8, "application/json");

                var response = await client.PostAsync(url, content).ConfigureAwait(false);

                if (response.IsSuccessStatusCode)
                {
                    var responseString = await response.Content.ReadAsStringAsync().ConfigureAwait(false);

                    // Parse JSON để lấy judgmentId
                    var json = JObject.Parse(responseString);
                    var judgmentId = json["judgmentId"].Value<decimal>();

                    Console.WriteLine($"Insert thành công. judgmentId = {judgmentId}");
                    return judgmentId;
                }
                else
                {
                    var error = await response.Content.ReadAsStringAsync().ConfigureAwait(false);
                    Console.WriteLine($"Lỗi khi insert: {response.StatusCode} - {error}");
                    return 0;
                }
            }
            catch (Exception ex)
            {
                return 0;
            }
        }
        public static async Task<decimal?> Update_File_attach(string jsonBody)
        {
            try
            {
                var bearerToken = await GetBearerToken().ConfigureAwait(false); ;
                if (string.IsNullOrEmpty(bearerToken))
                {
                    Console.WriteLine("Không lấy được token");
                    return 0;
                }

                var url = ConfigurationManager.AppSettings["ApiCBBA"] + "/api/CBBA/update-file-attach";

                var request = new HttpRequestMessage(new HttpMethod("PATCH"), url);
                request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", bearerToken);
                request.Content = new StringContent(jsonBody, Encoding.UTF8, "application/json");

                var response = await client.SendAsync(request).ConfigureAwait(false);

                if (response.IsSuccessStatusCode)
                {
                    var responseString = await response.Content.ReadAsStringAsync().ConfigureAwait(false);
                    var json = JObject.Parse(responseString);
                    var judgmentId = json["iD_JUDGMENT"]?.Value<decimal>();

                    Console.WriteLine($"Cập nhật thành công. judgmentId = {judgmentId}");
                    return judgmentId;
                }
                else
                {
                    var error = await response.Content.ReadAsStringAsync().ConfigureAwait(false);
                    Console.WriteLine($"Lỗi khi cập nhật: {response.StatusCode} - {error}");
                    return null;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Exception: {ex.Message}");
                return null;
            }
        }
        public static async Task<decimal> Insert_Anle(string jsonBody)
        {
            try
            {
                var bearerToken = await GetBearerToken().ConfigureAwait(false); ;
                if (string.IsNullOrEmpty(bearerToken))
                {
                    Console.WriteLine("Không lấy được token");
                    return 0;
                }

                var url = ConfigurationManager.AppSettings["ApiCBBA"] + "/api/CBBA/insert-anle"; // Thay bằng URL thật

                // Thêm header Authorization
                client.DefaultRequestHeaders.Authorization =
                    new AuthenticationHeaderValue("Bearer", bearerToken);

                var content = new StringContent(jsonBody, Encoding.UTF8, "application/json");

                var response = await client.PostAsync(url, content).ConfigureAwait(false);

                if (response.IsSuccessStatusCode)
                {
                    var responseString = await response.Content.ReadAsStringAsync().ConfigureAwait(false);

                    // Parse JSON để lấy judgmentId
                    var json = JObject.Parse(responseString);
                    var judgmentId = json["judgmentId"]?.Value<int>();

                    Console.WriteLine($"Insert thành công. judgmentId = {judgmentId}");
                    return Convert.ToDecimal(judgmentId);
                }
                else
                {
                    var error = await response.Content.ReadAsStringAsync().ConfigureAwait(false);
                    Console.WriteLine($"Lỗi khi insert: {response.StatusCode} - {error}");
                    return 0;
                }
            }
            catch (Exception ex)
            {
                return 0;
            }
        }
        public static async Task<decimal?> Update_Anle(string jsonBody)
        {
            try
            {
                var bearerToken = await GetBearerToken().ConfigureAwait(false); ;
                if (string.IsNullOrEmpty(bearerToken))
                {
                    Console.WriteLine("Không lấy được token");
                    return 0;
                }

                var url = ConfigurationManager.AppSettings["ApiCBBA"] + "/api/CBBA/update-anle";

                var request = new HttpRequestMessage(new HttpMethod("PATCH"), url);
                request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", bearerToken);
                request.Content = new StringContent(jsonBody, Encoding.UTF8, "application/json");

                var response = await client.SendAsync(request).ConfigureAwait(false);

                if (response.IsSuccessStatusCode)
                {
                    var responseString = await response.Content.ReadAsStringAsync().ConfigureAwait(false);
                    var json = JObject.Parse(responseString);
                    var judgmentId = json["iD_JUDGMENT"]?.Value<decimal>();

                    Console.WriteLine($"Cập nhật thành công. judgmentId = {judgmentId}");
                    return judgmentId;
                }
                else
                {
                    var error = await response.Content.ReadAsStringAsync().ConfigureAwait(false);
                    Console.WriteLine($"Lỗi khi cập nhật: {response.StatusCode} - {error}");
                    return null;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Exception: {ex.Message}");
                return null;
            }
        }
        public static async Task<decimal> Insert_Slow_date(string jsonBody)
        {
            try
            {
                var bearerToken = await GetBearerToken().ConfigureAwait(false); ;
                if (string.IsNullOrEmpty(bearerToken))
                {
                    Console.WriteLine("Không lấy được token");
                    return 0;
                }

                var url = ConfigurationManager.AppSettings["ApiCBBA"] + "/api/CBBA/insert-slow-date"; // Thay bằng URL thật

                // Thêm header Authorization
                client.DefaultRequestHeaders.Authorization =
                    new AuthenticationHeaderValue("Bearer", bearerToken);

                var content = new StringContent(jsonBody, Encoding.UTF8, "application/json");

                var response = await client.PostAsync(url, content).ConfigureAwait(false);

                if (response.IsSuccessStatusCode)
                {
                    var responseString = await response.Content.ReadAsStringAsync().ConfigureAwait(false);

                    // Parse JSON để lấy judgmentId
                    var json = JObject.Parse(responseString);
                    var judgmentId = json["judgmentId"]?.Value<int>();

                    Console.WriteLine($"Insert thành công. judgmentId = {judgmentId}");
                    return Convert.ToDecimal(judgmentId);
                }
                else
                {
                    var error = await response.Content.ReadAsStringAsync().ConfigureAwait(false);
                    Console.WriteLine($"Lỗi khi insert: {response.StatusCode} - {error}");
                    return 0;
                }
            }
            catch (Exception ex)
            {
                return 0;
            }
        }
        public static async Task<decimal?> Update_Slow_date(string jsonBody)
        {
            try
            {
                var bearerToken = await GetBearerToken().ConfigureAwait(false); ;
                if (string.IsNullOrEmpty(bearerToken))
                {
                    Console.WriteLine("Không lấy được token");
                    return 0;
                }

                var url = ConfigurationManager.AppSettings["ApiCBBA"] + "/api/CBBA/update-slow-date";

                var request = new HttpRequestMessage(new HttpMethod("PATCH"), url);
                request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", bearerToken);
                request.Content = new StringContent(jsonBody, Encoding.UTF8, "application/json");

                var response = await client.SendAsync(request).ConfigureAwait(false);

                if (response.IsSuccessStatusCode)
                {
                    var responseString = await response.Content.ReadAsStringAsync().ConfigureAwait(false);
                    var json = JObject.Parse(responseString);
                    var judgmentId = json["iD_JUDGMENT"]?.Value<decimal>();

                    Console.WriteLine($"Cập nhật thành công. judgmentId = {judgmentId}");
                    return judgmentId;
                }
                else
                {
                    var error = await response.Content.ReadAsStringAsync().ConfigureAwait(false);
                    Console.WriteLine($"Lỗi khi cập nhật: {response.StatusCode} - {error}");
                    return null;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Exception: {ex.Message}");
                return null;
            }
        }
    }
}