using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;
using Newtonsoft.Json;

namespace BL.GSTP.DLQGC06
{
    public class SignXmlViaHsmApi
    {
        private readonly string hsmApiUrl;

        public SignXmlViaHsmApi()
        {
            // Lấy URL HSM từ web.config
            hsmApiUrl = ConfigurationManager.AppSettings["HsmApiUrl"];
            if (string.IsNullOrWhiteSpace(hsmApiUrl))
                throw new Exception("Chưa cấu hình HsmApiUrl trong web.config");
        }

        /// <summary>
        /// Ký số danh sách C06_TOAAN_TINHTRANGHONNHAN thông qua API HSM.
        /// </summary>
        /// <param name="objL">Danh sách đối tượng cần ký</param>
        /// <param name="certAlias">Tên hoặc Serial chứng thư số</param>
        /// <param name="outputDirectory">Thư mục lưu file XML đã ký</param>
        /// <returns>Đường dẫn file XML đã ký hoặc null nếu lỗi</returns>
        public async Task<string> SignXmlViaHsmApiAsync(List<C06_TOAAN_TINHTRANGHONNHAN> objL,string certAlias,string outputDirectory)
        {
            try
            {
                // Bước 1: Serialize object sang XML string
                string unsignedXml;
                var serializer = new XmlSerializer(typeof(List<C06_TOAAN_TINHTRANGHONNHAN>));
                using (var stringWriter = new StringWriter())
                {
                    serializer.Serialize(stringWriter, objL);
                    unsignedXml = stringWriter.ToString();
                }

                // Bước 2: Tạo payload gửi lên HSM API
                var payload = new
                {
                    xml = unsignedXml,
                    certAlias = certAlias,
                    signMethod = "XAdES-BES" // hoặc XAdES-T nếu HSM hỗ trợ Timestamp
                };

                var jsonPayload = JsonConvert.SerializeObject(payload);
                var httpContent = new StringContent(jsonPayload, Encoding.UTF8, "application/json");

                // Bước 3: Gửi yêu cầu POST
                using (var httpClient = new HttpClient())
                {
                    // Nếu HSM yêu cầu token thì thêm dòng sau:
                    // httpClient.DefaultRequestHeaders.Add("Authorization", "Bearer YOUR_TOKEN");

                    HttpResponseMessage response = await httpClient.PostAsync(hsmApiUrl, httpContent);

                    if (!response.IsSuccessStatusCode)
                    {
                        string errorDetail = await response.Content.ReadAsStringAsync();
                        Console.WriteLine($"[HSM API ERROR] {response.StatusCode} - {errorDetail}");
                        return null;
                    }

                    string jsonResponse = await response.Content.ReadAsStringAsync();
                    dynamic result = JsonConvert.DeserializeObject(jsonResponse);
                    string signedXml = result?.signedXml;

                    if (string.IsNullOrWhiteSpace(signedXml))
                        throw new Exception("HSM API không trả lại nội dung XML đã ký.");

                    // Bước 4: Lưu file ký
                    string fileName = "TinhTrangHonNhan_signed_" + DateTime.Now.ToString("yyyyMMdd_HHmmss") + ".xml";
                    string signedFilePath = Path.Combine(outputDirectory, fileName);

                    if (!Directory.Exists(outputDirectory))
                        Directory.CreateDirectory(outputDirectory);

                    File.WriteAllText(signedFilePath, signedXml, Encoding.UTF8);

                    return signedFilePath;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("[Lỗi ký số] " + ex.Message);
                return null;
            }
        }
    }
}