using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Security.Policy;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace Module.Common
{
    public class CallApiMinIO
    {
        ////Cach goi các API làm việc với MinIO
        //var authService = new AuthService();
        //string token = authService.AuthenticateAsync().GetAwaiter().GetResult();
        //if (!string.IsNullOrEmpty(token))
        //{
        //	Console.WriteLine("✅ Token: " + token);
        //	string vfileNam = Path.GetFileName(strFilePath).Replace(" ", "_");
        //        string vNameBuket = System.Configuration.ConfigurationManager.AppSettings["NameBuket"];
        //        //Tai file
        //        //CallApiMinIO.DownloadFileAsync(token, "manhnd/muc1/"+ vfileNam, vNameBuket).GetAwaiter().GetResult(); 
        //        ////Upload file
        //        CallApiMinIO.UploadFileAsync(token, strFilePath, "manhnd/muc1/"+ vfileNam, vNameBuket).GetAwaiter().GetResult();
        //        ////Kiem tra ton tai cua file
        //        //if(CallApiMinIO.CheckFileExistAsync(token, "manhnd/muc1/" + vfileNam, vNameBuket).GetAwaiter().GetResult())
        //        //{
        //        //    Console.WriteLine("Tồn tại file.");
        //        //}
        //        //else
        //        //    Console.WriteLine("Không tồn tại file.");
        //        ////Xoa file                            
        //        //if (CallApiMinIO.DeleteFileAsync(token, "manhnd/muc1/" + vfileNam, vNameBuket).GetAwaiter().GetResult())
        //        //{
        //        //    Console.WriteLine("Xoa file thành cong.");
        //        //}
        //        //else
        //        //    Console.WriteLine("Lỗi khi xóa file.");

        ////Tai file client 
        //          byte[] conten;
        //          conten = CallApiMinIO.DownloadFileAsync_file(token, vfileNam, vNameBuket).GetAwaiter().GetResult();
        //          var cacheKey = Guid.NewGuid().ToString("N");
        //          Context.Cache.Insert(key: cacheKey, value: conten, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
        //          ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=world.txt&Extension=.txt';", true);
        /////Tai theo cach cua anh Hoang anh
        //        //Load_Respon_File(vfileNam, conten);
        //    }
        //else
        //{
        //	Console.WriteLine("❌ Đăng nhập thất bại.");
        //}
        public static async Task<byte[]> DownloadFileAsync_file(string token,string vfileName, string bucket)
        {
            string downloadUrl = ConfigurationManager.AppSettings["ApiMinIO"] + "/download?p=" + vfileName + "&bucket=" + bucket;

            var httpClient = new HttpClient();
            httpClient.Timeout = TimeSpan.FromSeconds(60);

            httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

            var response = await httpClient.GetAsync(downloadUrl).ConfigureAwait(false);

            if (response.IsSuccessStatusCode)
            {
                string fileName = "downloaded_file";

                if (response.Content.Headers.ContentDisposition?.FileName != null)
                {
                    fileName = response.Content.Headers.ContentDisposition.FileName.Trim('"');
                }
                try
                {
                    string downloadsPath = Path.Combine(
                        Environment.GetFolderPath(Environment.SpecialFolder.UserProfile),
                        "Downloads"
                    );
                string fullPath = Path.Combine(downloadsPath, fileName);
                // Tạo thư mục nếu chưa có
                Directory.CreateDirectory(downloadsPath);

                 //------------------------
                    string filePath = Path.Combine(downloadsPath, "test.txt");
                    File.WriteAllText(filePath, "Testing write access");
                    Console.WriteLine("File written successfully.");
                }
                catch (UnauthorizedAccessException ex)
                {
                    Console.WriteLine("Access denied: " + ex.Message);
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Other error: " + ex.Message);
                }
                // Ghi file
                byte[] fileBytes = await response.Content.ReadAsByteArrayAsync();
                //File.WriteAllBytes(fullPath, fileBytes);

                //Console.WriteLine("✅ File đã lưu tại: " + fullPath);
                return fileBytes;
            }
            else
            {
                return null;
            }
        }

        public static async Task<byte[]> DownloadFileAsync_file_minio(string token, string vfileName, string bucket)
        {
            string baseUrl = ConfigurationManager.AppSettings["ApiMinIO"];
            string downloadUrl = $"{baseUrl}/download?p={Uri.EscapeDataString(vfileName)}&bucket={bucket}";

            using (var httpClient = new HttpClient())
            {
                httpClient.Timeout = TimeSpan.FromSeconds(60);
                httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

                var response = await httpClient.GetAsync(downloadUrl).ConfigureAwait(false);
                if (!response.IsSuccessStatusCode)
                    throw new Exception($"Tải file thất bại: {response.StatusCode}");

                return await response.Content.ReadAsByteArrayAsync();
            }
        }


        public static async Task<byte[]> DownloadFileAsync_file_Banan(string token, string vfileName, string bucket)
        {
            string downloadUrl = ConfigurationManager.AppSettings["ApiMinIO"] + "/download?p=" + vfileName + "&bucket=" + bucket;

            var httpClient = new HttpClient();
            httpClient.Timeout = TimeSpan.FromSeconds(60);

            httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

            var response = await httpClient.GetAsync(downloadUrl).ConfigureAwait(false);

            if (response.IsSuccessStatusCode)
            {
                // Ghi file
                byte[] fileBytes = await response.Content.ReadAsByteArrayAsync();
                return fileBytes;
            }
            else
            {
                return null;
            }
        }

        public static async Task DownloadFileAsync(string token, string vfileName, string bucket)
        {
            string downloadUrl = ConfigurationManager.AppSettings["ApiMinIO"] + "/download?p=" + vfileName + "&bucket=" + bucket;

            var httpClient = new HttpClient();
            httpClient.Timeout = TimeSpan.FromSeconds(10);

            httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

            var response = await httpClient.GetAsync(downloadUrl).ConfigureAwait(false);

            if (response.IsSuccessStatusCode)
            {
                string fileName = "downloaded_file";

                if (response.Content.Headers.ContentDisposition?.FileName != null)
                {
                    fileName = response.Content.Headers.ContentDisposition.FileName.Trim('"');
                }

                string downloadsPath = Path.Combine(
                        Environment.GetFolderPath(Environment.SpecialFolder.UserProfile),
                        "Downloads"
                    );

                string fullPath = Path.Combine(downloadsPath, fileName);

                // Tạo thư mục nếu chưa có
                Directory.CreateDirectory(downloadsPath);
                // Ghi file
                byte[] fileBytes = await response.Content.ReadAsByteArrayAsync();
                File.WriteAllBytes(fullPath, fileBytes);

                Console.WriteLine("✅ File đã lưu tại: " + fullPath);

            }
        }

        public static async Task UploadFileAsync(string token, string filePath, string vfileName, string bucket)
        {
            string uploadUrl = ConfigurationManager.AppSettings["ApiMinIO"] + "/upload?bucket=" + bucket + "&p=" + vfileName;

            var handler = new HttpClientHandler { UseProxy = false };
            using (var httpClient = new HttpClient(handler))
            {
                httpClient.Timeout = TimeSpan.FromSeconds(30);
                httpClient.DefaultRequestHeaders.Authorization =
                    new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", token);

                try
                {
                    Console.WriteLine("📤 Đang upload file...");

                    using (var multipart = new MultipartFormDataContent())
                    {
                        byte[] fileBytes = System.IO.File.ReadAllBytes(filePath);
                        var fileContent = new ByteArrayContent(fileBytes);
                        fileContent.Headers.ContentType =
                            new System.Net.Http.Headers.MediaTypeHeaderValue("application/octet-stream");

                        multipart.Add(fileContent, "file", System.IO.Path.GetFileName(filePath));

                        var response = await httpClient.PostAsync(uploadUrl, multipart).ConfigureAwait(false);
                        Console.WriteLine("📬 Phản hồi upload: " + response.StatusCode);
                        string responseText = await response.Content.ReadAsStringAsync().ConfigureAwait(false);
                        Console.WriteLine("🧾 Phản hồi nội dung: " + responseText);
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine("❌ Lỗi upload file: " + ex.Message);
                }
            }
        }

        /* UploadFileAsync trực tiếp theo định dạng Bytes
         * vfileName - Truyền cả đường dẫn lưu trữ
         */
        public static async Task UploadFileAsyncByBytes(string token, byte[] fileBytes, string vfilePath, string bucket) //vfilePath là full đường dẫn cả tên file
        {
            string uploadUrl = ConfigurationManager.AppSettings["ApiMinIO"] + "/upload?bucket=" + bucket + "&p=" + vfilePath;

            var handler = new HttpClientHandler { UseProxy = false };
            using (var httpClient = new HttpClient(handler))
            {
                httpClient.Timeout = TimeSpan.FromSeconds(30);
                httpClient.DefaultRequestHeaders.Authorization =
                    new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", token);

                try
                {
                    Console.WriteLine("📤 Đang upload file...");

                    using (var multipart = new MultipartFormDataContent())
                    {
                        var fileContent = new ByteArrayContent(fileBytes);
                        fileContent.Headers.ContentType =
                            new System.Net.Http.Headers.MediaTypeHeaderValue("application/octet-stream");
                        string vfileName = Path.GetFileName(vfilePath).Replace(" ", "_");
                        multipart.Add(fileContent, "file", vfileName);

                        var response = await httpClient.PostAsync(uploadUrl, multipart).ConfigureAwait(false);
                        Console.WriteLine("📬 Phản hồi upload: " + response.StatusCode);
                        string responseText = await response.Content.ReadAsStringAsync().ConfigureAwait(false);
                        Console.WriteLine("🧾 Phản hồi nội dung: " + responseText);
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine("❌ Lỗi upload file: " + ex.Message);
                }
            }
        }

        public static async Task<bool> CheckFileExistAsync(string token, string vfileName, string bucket)
        {
            string checkUrl = ConfigurationManager.AppSettings["ApiMinIO"] + "/check-exist?bucket=" + bucket + "&p=" + vfileName;
          
            var handler = new HttpClientHandler { UseProxy = false };
            using (var httpClient = new HttpClient(handler))
            {
                httpClient.Timeout = TimeSpan.FromSeconds(15);
                httpClient.DefaultRequestHeaders.Authorization =
                    new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", token);

                try
                {
                    Console.WriteLine("🔍 Kiểm tra file tồn tại: " + vfileName);
                    var response = await httpClient.GetAsync(checkUrl).ConfigureAwait(false);
                    string responseText = await response.Content.ReadAsStringAsync().ConfigureAwait(false);

                    Console.WriteLine("📬 Kết quả: " + response.StatusCode);
                    Console.WriteLine("📄 Nội dung phản hồi: " + responseText);

                    return response.IsSuccessStatusCode && responseText.Contains("true");
                }
                catch (Exception ex)
                {
                    Console.WriteLine("❌ Lỗi khi kiểm tra file: " + ex.Message);
                    return false;
                }
            }
        }

        public static async Task<bool> DeleteFileAsync(string token, string vfileName, string bucket)
        {
            string deleteUrl = ConfigurationManager.AppSettings["ApiMinIO"] + "/remove?bucket=" + bucket + "&p=" + vfileName;

            var httpClient = new HttpClient();
            httpClient.Timeout = TimeSpan.FromSeconds(60);

            httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

            HttpResponseMessage response = await httpClient.GetAsync(deleteUrl).ConfigureAwait(false);
            if (response.IsSuccessStatusCode)
            {
                Console.WriteLine("✅ Xóa file thành công.");
                return true;
            }
            else
            {
                string responseBody = await response.Content.ReadAsStringAsync();
                Console.WriteLine($"❌ Lỗi khi xóa file: {response.StatusCode}");
                Console.WriteLine("Chi tiết: " + responseBody);
                return false;
            }
        }
       

    }
}