using System;
using System.Collections.Specialized;
using System.Text.RegularExpressions;
using System.Web;

namespace BL.GSTP.BANGSETGET
{
    public class LOG_KQGQ_QDT_QLTA
    {
        public Decimal ID { get; set; }
        public String VUANID { get; set; }
        public String DONID { get; set; }
        public String TENBANG { get; set; }
        public DateTime NGAYTAO { get; set; }
        public String USERNAME { get; set; }
        public String STATUS { get; set; } //Thêm, sửa, xóa
        public String JSON_GDTTT_VUAN_KETQUA { get; set; }
        public String JSON_GDTTT_VUAN_KETQUA_OLD { get; set; }
        public String JSON_GDTTT_VUAN_KETQUA_DON { get; set; }
        public String JSON_GDTTT_VUAN_KETQUA_DON_OLD { get; set; }
        public String URL_SITE { get; set; }
        public String BROWSER { get; set; }
        public String IP_CLIENT { get; set; }
        public String IP_WEBSERVER { get; set; }
        public String DEVICE { get; set; }
        public String HOSTNAME { get; set; }
        public String OS_PLATFORM { get; set; }
        
        // Chức năng LOG
        public void InsertLog(string VuAnID, string DonID, string TenBang, string username, string status, string Json_GDTTT_VUAN_KETQUA, string Json_GDTTT_VUAN_KETQUA_Old, string Json_GDTTT_VUAN_KETQUA_DON, string Json_GDTTT_VUAN_KETQUA_DON_Old)
        {
            string IP_CLIENT = HAMDUNGCHUNG.GetClientIp();
            string IP_WEBSERVER = HAMDUNGCHUNG.GetLocalIPAddress();
            string url = HAMDUNGCHUNG.GetCurrentUrl(HttpContext.Current.Request);
            string hostname = HAMDUNGCHUNG.GetHostName(IP_CLIENT);
            string BROWSER = HAMDUNGCHUNG.GetBrower();
            string Device = HAMDUNGCHUNG.GetDevice();
            string Os = HAMDUNGCHUNG.GetOS_PLATFORM();

            LOG_KQGQ_QDT_QLTA sysLog = new LOG_KQGQ_QDT_QLTA();
            sysLog.VUANID = VuAnID;
            sysLog.DONID = DonID;
            sysLog.TENBANG = TenBang;
            sysLog.NGAYTAO = DateTime.Now;
            sysLog.USERNAME = username;
            sysLog.STATUS = status;
            sysLog.JSON_GDTTT_VUAN_KETQUA = Json_GDTTT_VUAN_KETQUA;
            sysLog.JSON_GDTTT_VUAN_KETQUA_OLD = Json_GDTTT_VUAN_KETQUA_Old;
            sysLog.JSON_GDTTT_VUAN_KETQUA_DON = Json_GDTTT_VUAN_KETQUA_DON;
            sysLog.JSON_GDTTT_VUAN_KETQUA_DON_OLD = Json_GDTTT_VUAN_KETQUA_DON_Old;
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