using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;
using System.Configuration;
using System.Threading;
using WEB.Service.Service.Auth;
using System.Data;
using WEB.Service.Controllers;

namespace WEB.Service.Service
{
    public class CallApiJobShared
    {
        public static async Task<string> jsh_ToaAnNotification(string token, DataTable jsonData,string loaiviec,decimal tongdatid,decimal doituongid)
        {
            string jshUrl = ConfigurationManager.AppSettings["ApiJobShared"] + "/rest/toaan/notification/create";
            //string jshUrl = "http://jobshare.toaan.gov.vn/rest/toaan/notification/create";
            var handler = new HttpClientHandler { UseProxy = false };
            using (var httpClient = new HttpClient(handler))
            {
                httpClient.Timeout = TimeSpan.FromSeconds(30);
                httpClient.DefaultRequestHeaders.Authorization =
                    new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", token);
              
                Notification oBody = new Notification();

                foreach (DataRow row in jsonData.Rows)
                {
                    //var noteString = row["note"]?.ToString() ?? "[]";  // Nếu 'note' là null hoặc rỗng, gán mảng rỗng
                    var noteString = row["note"]?.ToString()?.Trim() ?? "[]";
                    // Loại bỏ dấu ngoặc kép (dấu escape) trước khi giải mã (nếu có)
                    // Trong trường hợp này, noteString chứa một chuỗi JSON hợp lệ, nên không cần phải làm gì thêm.
                    string innerJsonString = noteString
                       .Replace("\\\"", "\"")  // bỏ escape của dấu "
                       .Trim('"');
                    List<string> noteList = new List<string>();
                    try
                    {
                        // Deserialize chuỗi JSON thành List<string>
                        noteList = JsonConvert.DeserializeObject<List<string>>(innerJsonString);
                    }
                    catch (Exception ex)
                    {
                        // Nếu có lỗi, gán danh sách rỗng và in lỗi
                        noteList = new List<string>();
                        Console.WriteLine($"Error parsing 'note': {ex.Message}");
                    }

                    oBody = new Notification
                        {
                            tongdatId = row["tongdatId"]?.ToString(),
                            notiTypeCode = row["notiTypeCode"]?.ToString(),
                            notiName = row["notiName"]?.ToString(),
                            notiNumber = row["notiNumber"]?.ToString(),
                            sendPlaceCode = row["sendPlaceCode"]?.ToString(),
                            sendPlaceName = row["sendPlaceName"]?.ToString(),
                            citizenNumber = row["citizenNumber"]?.ToString(),
                            citizenName = row["citizenName"]?.ToString(),
                            area = row["area"]?.ToString(),
                            documentNumber = row["documentNumber"]?.ToString(),
                            publishDate = row["publishDate"]?.ToString(),
                            fileId = row["fileId"]?.ToString(),
                            //fileId = Encoding.UTF8.GetString(Encoding.GetEncoding(1252).GetBytes(row["fileId"]?.ToString() ?? "")),
                            //fileId = Encoding.UTF8.GetString(Encoding.GetEncoding(1252).GetBytes(HttpUtility.UrlDecode(row["fileId"]?.ToString() ?? ""))),
                            fileName = row["fileName"]?.ToString(),
                            note = noteList
                        };
                }

                string json = JsonConvert.SerializeObject(oBody, Formatting.Indented);
                var content = new StringContent(json, Encoding.UTF8, "application/json");

                try
                {
                    Console.WriteLine("Đang gửi request tới: " + jshUrl);
                    var response = await httpClient.PostAsync(jshUrl, content).ConfigureAwait(false);
                    Console.WriteLine("Đã nhận response: " + response.StatusCode);

                    string responseBody = await response.Content.ReadAsStringAsync().ConfigureAwait(false);
                    Console.WriteLine("Nội dung phản hồi: " + responseBody);

                    if (response.IsSuccessStatusCode)
                    {
                        Console.WriteLine("thành công: " + response.StatusCode);
                        return response.StatusCode.ToString();
                    }
                    else
                    {
                        // mã lỗi 3
                        decimal vMaloi = VNEID_THONGBAOTA.Insert_log(3, loaiviec, tongdatid, doituongid, JsonConvert.DeserializeObject<DataTable>(json));
                        Console.WriteLine("❌ Lỗi từ server: " + response.StatusCode);
                        Console.WriteLine("Thông tin chi tiết: " + responseBody);
                        return response.StatusCode.ToString();
                    }

                }
                catch (TaskCanceledException ex)
                {
                    Console.WriteLine("⚠️ Request bị timeout sau 30 giây.");
                    //Luu vào bang JobShared_Err với trạng thái lâu hơn 30s mã 1
                    decimal vMaloi = VNEID_THONGBAOTA.Insert_log(1, loaiviec, tongdatid, doituongid, JsonConvert.DeserializeObject<DataTable>(json));
                    return "timeout";
                }
                catch (Exception ex)
                {
                    Console.WriteLine("❌ Lỗi API: " + ex.Message);
                    //Luu vào bang JobShared_Err với trang thai loi không gọi được api mã 2
                    decimal vMaloi = VNEID_THONGBAOTA.Insert_log(2, loaiviec, tongdatid, doituongid, JsonConvert.DeserializeObject<DataTable>(json));
                    return "errAPI";

                }
            }
        }
    }
}