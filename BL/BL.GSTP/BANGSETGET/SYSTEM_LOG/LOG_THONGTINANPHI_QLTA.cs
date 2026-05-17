using System;
using System.Collections.Specialized;
using System.Text.RegularExpressions;
using System.Web;

namespace BL.GSTP.BANGSETGET
{
    public class LOG_THONGTINANPHI_QLTA
    {
        public Decimal ID { get; set; }
        public String DONID { get; set; }
        public String APID { get; set; }
        public String MA_THONGBAO { get; set; }
        public DateTime NGAYTAO { get; set; }
        public String USERNAME { get; set; }
        public String STATUS { get; set; } //Thêm, sửa, xóa
        public String CONTENT_JSON { get; set; }
        public String CONTENT_JSON_OLD { get; set; }
        public String URL_SITE { get; set; }
        public String BROWSER { get; set; }
        public String IP_CLIENT { get; set; }
        public String IP_WEBSERVER { get; set; }
        public String DEVICE { get; set; }
        public String HOSTNAME { get; set; }
        public String OS_PLATFORM { get; set; }
        
        // Chức năng LOG_THONGTINANPHI_QLTA
        public void InsertLog(string DonID, string APID, string MaThongBao, string username, string status, string Json, string JsonOld)
        {
            string IP_CLIENT = HAMDUNGCHUNG.GetClientIp();
            string IP_WEBSERVER = HAMDUNGCHUNG.GetLocalIPAddress();
            string url = HAMDUNGCHUNG.GetCurrentUrl(HttpContext.Current.Request);
            string hostname = HAMDUNGCHUNG.GetHostName(IP_CLIENT);
            string BROWSER = HAMDUNGCHUNG.GetBrower();
            string Device = HAMDUNGCHUNG.GetDevice();
            string Os = HAMDUNGCHUNG.GetOS_PLATFORM();
            
            LOG_THONGTINANPHI_QLTA sysLog = new LOG_THONGTINANPHI_QLTA();
            sysLog.DONID = DonID;
            sysLog.APID = APID;
            sysLog.MA_THONGBAO = MaThongBao;
            sysLog.NGAYTAO = DateTime.Now;
            sysLog.USERNAME = username;
            sysLog.STATUS = status;
            sysLog.CONTENT_JSON = Json;
            sysLog.CONTENT_JSON_OLD = JsonOld;
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