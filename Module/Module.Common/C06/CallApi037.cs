using System;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using System.Net.Http;
using System.Configuration;
using NLog;
using System.Net;

namespace Module.Common.C06
{
    public class CallApi037
    {
        private readonly HttpClient _client;
        private readonly string _url_api = ConfigurationManager.AppSettings["C06_url_api"]; 

        // Các thông tin cấu hình
        private readonly string _url_xacthuc = ConfigurationManager.AppSettings["C06_url_xacthuc"];
        private readonly string _userName = ConfigurationManager.AppSettings["C06_userName"];  
        private readonly string _secretKey = ConfigurationManager.AppSettings["C06_secretKey"];
        private readonly string _X_Road_Client = ConfigurationManager.AppSettings["C06_X_Road_Client"];
        private readonly string _apiKey = ConfigurationManager.AppSettings["C06_apiKey"];

        public CallApi037()
        {
            _client = new HttpClient();

            var timestamp = ((long)(DateTime.UtcNow - new DateTime(1970, 1, 1)).TotalMilliseconds).ToString();
            var raw = _url_xacthuc + _userName + timestamp + _secretKey;

            // Tạo chuỗi hash SHA256
            string hash;
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(raw));
                hash = BitConverter.ToString(bytes).Replace("-", "").ToLower();
            }

            // Tạo Authorization base64 từ username:hash
            var authPlain = $"{_userName}:{hash}";
            var authBase64 = Convert.ToBase64String(Encoding.UTF8.GetBytes(authPlain));

            // Gắn các header
            _client.DefaultRequestHeaders.Add("Timestamp", timestamp);
            _client.DefaultRequestHeaders.Add("Authorization", $"Basic {authBase64}");
            _client.DefaultRequestHeaders.Add("X-Road-Client", _X_Road_Client);
            _client.DefaultRequestHeaders.Add("ApiKey", _apiKey);
            _client.DefaultRequestHeaders.Add("SOAPAction", "\"\""); // SOAP thường cần dòng này, ngay cả khi rỗng
          
        }

        public async Task<string> SendRequestAsync(string maDonVi, string soCCCDtaiKhoan,  string soTenKhoan,
                                            string soDinhDanh, string HoVaTen, string NamSinh)
        {
            string ngayThangNamSinhXml = "";

            if (NamSinh.Length == 4) // chỉ có năm
            {
                ngayThangNamSinhXml = $"<dan:Nam>{NamSinh}</dan:Nam>";
            }
            else if (NamSinh.Length == 8) // yyyyMMdd
            {
                ngayThangNamSinhXml = $"<dan:NgayThangNam>{NamSinh}</dan:NgayThangNam>";
            }


            var xml = $@"<soapenv:Envelope xmlns:soapenv=""http://schemas.xmlsoap.org/soap/envelope/"" xmlns:dan=""http://dancuquocgia.bca"">
                          <soapenv:Header/>
                          <soapenv:Body>
                            <dan:TraCuuThongTinCongDan>
                              <dan:MaYeuCau>RANDOM{DateTime.Now.ToString("HHmmssfff")}</dan:MaYeuCau>
                              <dan:MaDVC>VPCP</dan:MaDVC>
                              <dan:MaTichHop>037</dan:MaTichHop>                              
                              <dan:MaCanBo>{soCCCDtaiKhoan}</dan:MaCanBo>
                              <dan:MaDonVi>{maDonVi}</dan:MaDonVi>
                              <dan:TaiKhoan>{soTenKhoan}</dan:TaiKhoan>
                              <dan:SoDienThoai>0</dan:SoDienThoai>
                              <dan:SoDinhDanh>{soDinhDanh}</dan:SoDinhDanh>
                              <dan:HoVaTen>{HoVaTen}</dan:HoVaTen>
                              <dan:NgayThangNamSinh>
                                {ngayThangNamSinhXml}
                              </dan:NgayThangNamSinh>
                            </dan:TraCuuThongTinCongDan>
                          </soapenv:Body>
                        </soapenv:Envelope>";
          

            var content = new StringContent(xml, Encoding.UTF8, "application/xml");

            try
            {
                //ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;
                //ServicePointManager.ServerCertificateValidationCallback =
                //    (sender, certificate, chain, sslPolicyErrors) => true;
                var response = await _client.PostAsync(_url_api, content).ConfigureAwait(false); ;
                response.EnsureSuccessStatusCode();
                return await response.Content.ReadAsStringAsync().ConfigureAwait(false);
            }
            catch (Exception ex)
            {
                //return $"Lỗi khi gửi yêu cầu SOAP: {ex.Message}";
                // Tìm thông tin dòng lỗi từ StackTrace

                var logger = NLog.LogManager.GetCurrentClassLogger();
                var trace = new System.Diagnostics.StackTrace(ex, true);
                
                logger.Error(ex, $"|Time: {DateTime.Now:yyyy-MM-dd HH:mm:ss}");

                return "Err";

            }
        }

        

    }
}