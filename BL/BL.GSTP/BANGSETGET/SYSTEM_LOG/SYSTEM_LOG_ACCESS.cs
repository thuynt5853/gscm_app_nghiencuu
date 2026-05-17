using System;
using System.Net;
using System.Web;
using System.Collections.Specialized;
using System.Text.RegularExpressions;
using System.Collections.Generic;
using Oracle.ManagedDataAccess.Client;
using Module.Common;
using System.Data;
using System.Reflection;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;

namespace BL.GSTP.BANGSETGET.SYSTEM_LOG
{
    public class SYSTEM_LOG_ACCESS
    {
        public Decimal ID { get; set; }
        public String USERNAME { get; set; }
        public String IP_CLIENT { get; set; }
        public String IP_WEBSERVER { get; set; }
        public String DEVICE { get; set; }
        public String OS_PLATFORM { get; set; }
        public String HOSTNAME { get; set; }

        public String BROWSER { get; set; }
        public String URL_SITE { get; set; }
        public Decimal? SESSION_ID { get; set; }
        public Decimal? ID_TYPE { get; set; }
        public DateTime? LOGIN_DATE { get; set; }
        public DateTime? LOGOUT_DATE { get; set; }
        public Decimal? STATUS { get; set; }
        public String USERAGENT { get; set; }
        public String NGUOITAO { get; set; }
        public DateTime? NGAYTAO { get; set; }
        public String PM_NOIBO { get; set; }



        private string GetLoadBalancerIp()
        {
            // Nếu Load Balancer sử dụng một header cụ thể, bạn có thể lấy IP từ đây
            // Ví dụ: "HTTP_X_LOAD_BALANCER_IP" (tùy thuộc vào cấu hình của Load Balancer)
            return HttpContext.Current.Request.ServerVariables["HTTP_X_LOAD_BALANCER_IP"] ?? "Không có IP Load Balancer";
        }

        public static string GetLocalIPAddress()
        {
            var host = Dns.GetHostEntry(Dns.GetHostName());
            foreach (var ip in host.AddressList)
            {
                if (ip.AddressFamily == AddressFamily.InterNetwork)
                {
                    return ip.ToString();
                }
            }
            throw new Exception("No network adapters with an IPv4 address in the system!");
        }
        //tuning 20/03/2026
        public void insertLogAccess(decimal status, string username)
        {
            // Lấy các giá trị từ Request ngay lập tức (vì HttpContext sẽ mất khi sang luồng khác)
            var request = HttpContext.Current.Request;
            string ip = request.ServerVariables["HTTP_X_FORWARDED_FOR"];
            string IP_CLIENT = !string.IsNullOrEmpty(ip) ? ip.Split(',')[0].Trim() : request.ServerVariables["REMOTE_ADDR"];
            string currentUrl = request.Url.AbsoluteUri;
            // Tránh lỗi IPv6 loopback (::1) nếu chạy local
            if (IP_CLIENT == "::1") IP_CLIENT = "127.0.0.1";
            // Sử dụng StringBuilder để cộng chuỗi Header (nhanh hơn cộng chuỗi + thông thường)
            var headerBuilder = new StringBuilder();
            string device = "Unknown";
            foreach (string key in request.Headers.AllKeys)
            {
                string value = request.Headers[key];
                headerBuilder.Append(key).Append(" = ").Append(value).Append("<br/>");
                if (key.Equals("User-Agent", StringComparison.OrdinalIgnoreCase) && !string.IsNullOrEmpty(value))
                {
                    var match = Regex.Match(value, @"\(([^)]*)\)");
                    if (match.Success) device = match.Groups[1].Value;
                }
            }

            var bc = request.Browser;

            // 2. Đẩy toàn bộ việc nặng (DNS + Database) ra luồng phụ
            Task.Run(() => {
                string hostname = "unknown";
                try
                {
                    // Việc này có thể mất 5 giây, nhưng luồng chính đã chạy xong từ lâu rồi
                    System.Net.IPHostEntry entry = System.Net.Dns.GetHostEntry(IP_CLIENT);
                    if (entry != null) hostname = entry.HostName;
                }
                catch
                {
                    hostname = "not-resolved";
                }
                // Tạo object log
                SYSTEM_LOG_ACCESS sysLog = new SYSTEM_LOG_ACCESS
                {
                    USERNAME = username,
                    IP_CLIENT = IP_CLIENT,
                    IP_WEBSERVER = GetLocalIPAddress(),
                    HOSTNAME = hostname,//"pending", // Bỏ DNS Lookup vì nó cực chậm (mất 2-10 giây)
                    DEVICE = device,
                    OS_PLATFORM = Environment.OSVersion.VersionString,
                    BROWSER = bc.Browser + " ver: " + bc.Version,
                    URL_SITE = currentUrl, // Dùng trực tiếp URL hiện tại thay vì GetFinalRedirect (gây chậm mạng)
                    SESSION_ID = 0,
                    ID_TYPE = 1,
                    LOGIN_DATE = DateTime.Now,
                    STATUS = status,
                    USERAGENT = headerBuilder.ToString(),
                    NGAYTAO = DateTime.Now,
                    NGUOITAO = "SYSTEM",
                    PM_NOIBO = "QLTA"
                };
                DataExtensions.Insert(sysLog);
            });
        }

        public void insertLogAccess_old(decimal status, string username)
        {
            string IP_CLIENT = string.Empty;
            string ip = HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
            if (!string.IsNullOrEmpty(ip))
            {
                string[] ipRange = ip.Split(',');
                int le = ipRange.Length - 1;
                IP_CLIENT = ipRange[0];
            }
            else
            {
                IP_CLIENT = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"];
            }
            
            string IP_WEBSERVER = GetLocalIPAddress();


            string userAgent = " ";
            string device = " ";
            NameValueCollection headers = HttpContext.Current.Request.Headers;
            for (int i = 0; i < headers.Count; i++)
            {
                string key = headers.GetKey(i);
                string value = headers.Get(i);
                userAgent += key + " = " + value + "<br/>";
                if(key.Contains("User-Agent"))
                {
                    device = Regex.Match(value, @"\(([^)]*)\)").Groups[1].Value;
                }

            }
            
            var os = Environment.OSVersion;
            HttpBrowserCapabilities bc = HttpContext.Current.Request.Browser;

            string url = GetFinalRedirect(HttpContext.Current.Request.Url.AbsoluteUri);
            string hostname = "";
            try
            {
                System.Net.IPHostEntry entry = System.Net.Dns.GetHostEntry(IP_CLIENT);
                if (entry != null)
                {
                    hostname = entry.HostName;
                }
            }
            catch (System.Net.Sockets.SocketException ex)
            {
                hostname = "unknow"; //unknown host or not every IP has a name log exception (manage it)
            }


            SYSTEM_LOG_ACCESS sysLog = new SYSTEM_LOG_ACCESS();

            sysLog.USERNAME = username;
            sysLog.IP_CLIENT = IP_CLIENT;
            sysLog.IP_WEBSERVER = IP_WEBSERVER;
            sysLog.HOSTNAME = hostname;
            sysLog.DEVICE = device;
            sysLog.OS_PLATFORM = os.VersionString;
            sysLog.BROWSER = bc.Browser + " ver: " + bc.Version;
            sysLog.URL_SITE = url;
            sysLog.SESSION_ID = 0;
            sysLog.ID_TYPE = 1;
            sysLog.LOGIN_DATE = DateTime.Now;
            //sysLog.LOGOUT_DATE = 
            sysLog.STATUS = status;
            sysLog.USERAGENT = userAgent;
            sysLog.NGAYTAO = DateTime.Now;
            sysLog.NGUOITAO = "SYSTEM";
            sysLog.PM_NOIBO = "QLTA";

            DataExtensions.Insert(sysLog);
        }
        
        public static string GetFinalRedirect(string url)
        {
            if (string.IsNullOrWhiteSpace(url))
                return url;

            int maxRedirCount = 8;  // prevent infinite loops
            string newUrl = url;
            do
            {
                HttpWebRequest req = null;
                HttpWebResponse resp = null;
                try
                {
                    req = (HttpWebRequest)HttpWebRequest.Create(url);
                    req.Method = "HEAD";
                    req.AllowAutoRedirect = false;
                    resp = (HttpWebResponse)req.GetResponse();
                    switch (resp.StatusCode)
                    {
                        case HttpStatusCode.OK:
                            return newUrl;
                        case HttpStatusCode.Redirect:
                        case HttpStatusCode.MovedPermanently:
                        case HttpStatusCode.RedirectKeepVerb:
                        case HttpStatusCode.RedirectMethod:
                            newUrl = resp.Headers["Location"];
                            if (newUrl == null)
                                return url;

                            if (newUrl.IndexOf("://", System.StringComparison.Ordinal) == -1)
                            {
                                // Doesn't have a URL Schema, meaning it's a relative or absolute URL
                                Uri u = new Uri(new Uri(url), newUrl);
                                newUrl = u.ToString();
                            }
                            break;
                        default:
                            return newUrl;
                    }
                    url = newUrl;
                }
                catch (WebException)
                {
                    // Return the last known good URL
                    return newUrl;
                }
                catch (Exception ex)
                {
                    return null;
                }
                finally
                {
                    if (resp != null)
                        resp.Close();
                }
            } while (maxRedirCount-- > 0);

            return newUrl;
        }

        #region AnhPN
        public static List<T> GetThongTinDangNhapTrongNgay<T>(string user_name, int status) where T : new()
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            try
            {
                DataTable tb = new DataTable();
                OracleDataAdapter adapter = new OracleDataAdapter(String.Format("SELECT * FROM {0} WHERE USERNAME = '"+ user_name + "' AND TO_DATE(LOGIN_DATE,'DD-MM-YYYY') = TO_DATE(SYSDATE,'DD-MM-YYYY') AND STATUS = "+ status + " AND PM_NOIBO='QLTA' ORDER BY NGAYTAO DESC", typeof(T).Name, user_name), conn);
                adapter.Fill(tb);
                adapter.Dispose();
                conn.Close(); conn.Dispose();
                return CreateListFromTable<T>(tb);
            }
            //catch (Exception ex)
            //{
            //    conn.Close(); conn.Dispose();
            //    return null;
            //}
            catch (System.Data.Entity.Validation.DbEntityValidationException dbEx)
            {
                foreach (var validationErrors in dbEx.EntityValidationErrors)
                {
                    foreach (var validationError in validationErrors.ValidationErrors)
                    {
                        string a = "property: " + validationError.PropertyName + " Error: " + validationError.ErrorMessage;
                    }
                }
                return null;
            }

        }
        public static List<T> CreateListFromTable<T>(DataTable tbl) where T : new()
        {
            // define return list
            List<T> lst = new List<T>();

            // go through each row
            foreach (DataRow r in tbl.Rows)
            {
                // add to the list
                lst.Add(CreateItemFromRow<T>(r));
            }

            // return the list
            return lst;
        }
        public static T CreateItemFromRow<T>(DataRow row) where T : new()
        {
            // create a new object
            T item = new T();

            // set the item
            SetItemFromRow(item, row);

            // return 
            return item;
        }
        public static void SetItemFromRow<T>(T item, DataRow row) where T : new()
        {
            int i = 0;
            // go through each column
            foreach (DataColumn c in row.Table.Columns)
            {
                // find the property for the column
                PropertyInfo p = item.GetType().GetProperty(c.ColumnName);

                // if exists, set the value
                if (p != null && row[c] != DBNull.Value)
                {
                    p.SetValue(item, row[c], null);
                }
            }
        }
        #endregion
    }


}