using Module.Common.Auth;
using System;
using System.Configuration;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using System.Web;

namespace WEB.GSTP.Quantri.Cauhinh
{
    /// <summary>
    /// Summary description for FileDownload
    /// </summary>
    public class FileDownload : IHttpHandler
    {
        //public void ProcessRequest(HttpContext context)
        //{
        //    // Xử lý bất đồng bộ bằng cách chờ task hoàn thành
        //    ProcessRequestAsync(context).GetAwaiter().GetResult();
        //}

        public void ProcessRequest(HttpContext context)
        {
            try
            {
                var authService = new AuthService();
                string token = authService.AuthenticateAsync().GetAwaiter().GetResult();

                if (string.IsNullOrEmpty(token))
                {
                    context.Response.StatusCode = (int)HttpStatusCode.Unauthorized;
                    context.Response.Write("Không lấy được token từ MinIO");
                    return;
                }

                // Lấy tham số path từ query string
                string path = context.Request.QueryString["p"];
                if (string.IsNullOrEmpty(path))
                {
                    context.Response.StatusCode = (int)HttpStatusCode.BadRequest;
                    context.Response.Write("Thiếu tham số path (p)");
                    return;
                }
                
                string bucket = ConfigurationManager.AppSettings["NameBuket"];
                string internalUrl = $"{ConfigurationManager.AppSettings["ApiMinIO"]}/download?p={path}&bucket={HttpUtility.UrlEncode(bucket)}";
                //string internalUrl = ConfigurationManager.AppSettings["ApiMinIO"] +
                //                     "/download?p=" + HttpUtility.UrlEncode(path) +
                //                     "&bucket=" + HttpUtility.UrlEncode(bucket);

                using (var handler = new HttpClientHandler())
                {
                    //handler.AllowAutoRedirect = false; // Không cho tự động redirect

                    using (var httpClient = new HttpClient(handler))
                    {
                        httpClient.DefaultRequestHeaders.Authorization =
                            new AuthenticationHeaderValue("Bearer", token);

                        var response = httpClient.GetAsync(internalUrl, HttpCompletionOption.ResponseHeadersRead).ConfigureAwait(false).GetAwaiter().GetResult();
                        // ĐẢM BẢO REDIRECT SANG HTTPS
                        if (response.StatusCode == HttpStatusCode.Redirect)
                        {
                            var redirectUrl = response.Headers.Location.ToString();

                            // Sửa redirect URL sang HTTPS
                            if (redirectUrl.StartsWith("http://"))
                            {
                                redirectUrl = redirectUrl.Replace("http://", "https://");
                            }

                            response = httpClient.GetAsync(redirectUrl).GetAwaiter().GetResult();
                        }
                        byte[] fileBytes;

                        if (response.StatusCode == HttpStatusCode.Redirect ||
                            response.StatusCode == HttpStatusCode.Moved ||
                            response.StatusCode == HttpStatusCode.Found)
                        {
                            // Xử lý redirect
                            var redirectUrl = response.Headers.Location.ToString();
                            //redirectUrl = redirectUrl.Replace("http://", "https://");

                            using (var redirectClient = new HttpClient())
                            {
                                var finalResponse = redirectClient.GetAsync(redirectUrl).GetAwaiter().GetResult();
                                if (!finalResponse.IsSuccessStatusCode)
                                {
                                    context.Response.StatusCode = (int)HttpStatusCode.NotFound;
                                    context.Response.Write("File not found");
                                    return;
                                }

                                fileBytes = finalResponse.Content.ReadAsByteArrayAsync().GetAwaiter().GetResult();
                            }
                        }
                        else if (response.IsSuccessStatusCode)
                        {
                            fileBytes = response.Content.ReadAsByteArrayAsync().GetAwaiter().GetResult();
                        }
                        else
                        {
                            context.Response.StatusCode = (int)response.StatusCode;
                            context.Response.Write($"Lỗi khi tải file: {response.ReasonPhrase}");
                            return;
                        }

                        // Thiết lập headers và trả về file
                        path = HttpUtility.UrlDecode(path);
                        string fileName = Path.GetFileName(path);
                        string contentType = GetContentType(Path.GetExtension(fileName));

                        context.Response.Clear();
                        context.Response.ContentType = contentType;
                        context.Response.AddHeader("Content-Disposition", $"attachment; filename=\"{HttpUtility.UrlEncode(fileName)}\"");
                        context.Response.AddHeader("Content-Length", fileBytes.Length.ToString());
                        context.Response.AddHeader("Cache-Control", "no-cache");

                        context.Response.BinaryWrite(fileBytes);
                        context.Response.Flush();
                    }
                }
            }
            catch (Exception ex)
            {
                context.Response.StatusCode = (int)HttpStatusCode.InternalServerError;
                context.Response.Write($"Lỗi: {ex.Message}");
            }
        }
        private string GetContentType(string fileExtension)
        {
            switch (fileExtension.ToLower())
            {
                case ".pdf": return "application/pdf";
                case ".doc": return "application/msword";
                case ".docx": return "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
                case ".xls": return "application/vnd.ms-excel";
                case ".xlsx": return "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                case ".jpg":
                case ".jpeg": return "image/jpeg";
                case ".png": return "image/png";
                case ".zip": return "application/zip";
                case ".txt": return "text/plain";
                default: return "application/octet-stream";
            }
        }

        public bool IsReusable => false;
    }
}