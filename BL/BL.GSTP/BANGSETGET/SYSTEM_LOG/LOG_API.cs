using System;
using System.Collections.Specialized;
using System.Text.RegularExpressions;
using System.Web;

namespace BL.GSTP.BANGSETGET
{
    public class LOG_API
    {
        public Decimal ID { get; set; }
        public String TEN_API { get; set; }
        public DateTime NGAYTAO { get; set; }
        public String GHICHU { get; set; }
        public String CONTENT_JSON { get; set; }
        public String URL_SITE { get; set; }
        public String BROWSER { get; set; }
        public String IP_CLIENT { get; set; }
        public String IP_WEBSERVER { get; set; }
        public String DEVICE { get; set; }
        public String HOSTNAME { get; set; }
        public String OS_PLATFORM { get; set; }
        
        // Chức năng LOG
        public void InsertLog(string TEN_API, string GHICHU, string Json)
        {
            string IP_CLIENT = HAMDUNGCHUNG.GetClientIp();
            string IP_WEBSERVER = HAMDUNGCHUNG.GetLocalIPAddress();
            string url = HAMDUNGCHUNG.GetCurrentUrl(HttpContext.Current.Request);
            string hostname = HAMDUNGCHUNG.GetHostName(IP_CLIENT);
            string BROWSER = HAMDUNGCHUNG.GetBrower();
            string Device = HAMDUNGCHUNG.GetDevice();
            string Os = HAMDUNGCHUNG.GetOS_PLATFORM();

            LOG_API sysLog = new LOG_API();
            sysLog.TEN_API = TEN_API;
            sysLog.NGAYTAO = DateTime.Now;
            sysLog.GHICHU = GHICHU;
            sysLog.CONTENT_JSON = Json;
            sysLog.URL_SITE = url;
            sysLog.BROWSER = BROWSER;
            sysLog.IP_CLIENT = IP_CLIENT;
            sysLog.IP_WEBSERVER = IP_WEBSERVER;
            sysLog.DEVICE = Device;
            sysLog.HOSTNAME = hostname;
            sysLog.OS_PLATFORM = Os;

            DataExtensions.Insert(sysLog);
        }
    }


}