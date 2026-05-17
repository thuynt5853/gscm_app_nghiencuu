using System;
using System.Collections.Specialized;
using System.Text.RegularExpressions;
using System.Web;

namespace BL.GSTP.BANGSETGET
{
    public class LOG_TONGDAT_QLTA
    {
        public Decimal ID { get; set; }
        public String TENBANG { get; set; }
        public String TONGDAT_ID { get; set; } // ID của bảng tống đạt
        public DateTime NGAYTAO { get; set; }
        public String USERNAME { get; set; }
        public String STATUS { get; set; } //Thêm, sửa, xóa
        public String LYDO { get; set; }
        public String CONTENT_JSON { get; set; }
        public String CONTENT_JSON_OLD { get; set; }
        public String URL_SITE { get; set; }
        public String BROWSER { get; set; }
        public String IP_CLIENT { get; set; }
        public String IP_WEBSERVER { get; set; }
        public String DEVICE { get; set; }
        public String HOSTNAME { get; set; }
        public String OS_PLATFORM { get; set; }
        
        // Chức năng LOG
        public void InsertLog(string TENBANG, string TONGDAT_ID, string username, string status, string LYDO, string CONTENT_JSON, string CONTENT_JSON_OLD)
        {
            string IP_CLIENT = HAMDUNGCHUNG.GetClientIp();
            string IP_WEBSERVER = HAMDUNGCHUNG.GetLocalIPAddress();
            string url = HAMDUNGCHUNG.GetCurrentUrl(HttpContext.Current.Request);
            string hostname = HAMDUNGCHUNG.GetHostName(IP_CLIENT);
            string BROWSER = HAMDUNGCHUNG.GetBrower();
            string Device = HAMDUNGCHUNG.GetDevice();
            string Os = HAMDUNGCHUNG.GetOS_PLATFORM();

            LOG_TONGDAT_QLTA sysLog = new LOG_TONGDAT_QLTA();
            sysLog.TONGDAT_ID = TONGDAT_ID;
            sysLog.TENBANG = TENBANG;
            sysLog.LYDO = LYDO;
            sysLog.NGAYTAO = DateTime.Now;
            sysLog.USERNAME = username;
            sysLog.STATUS = status;
            sysLog.CONTENT_JSON = CONTENT_JSON;
            sysLog.CONTENT_JSON_OLD = CONTENT_JSON_OLD;
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