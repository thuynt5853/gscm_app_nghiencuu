using System;
using System.Collections.Specialized;
using System.Net;
using System.Net.Sockets;
using System.Text.RegularExpressions;
using System.Web;

namespace BL.GSTP.BANGSETGET
{
    public class HAMDUNGCHUNG
    {
        public static string GetClientIp()
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
            return IP_CLIENT;
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
        public static string GetCurrentUrl(HttpRequest request)
        {
            return request.Url.AbsoluteUri;
        }
        public static string GetHostName(string IP_CLIENT)
        {
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
            return hostname;
        }
        public static string GetBrower()
        {
            string BROWER = "unknow";
            HttpBrowserCapabilities bc = HttpContext.Current.Request.Browser;
            if (bc != null)
            {
                BROWER = bc.Browser + " ver: " + bc.Version;
            }
            return BROWER;
        }
        public static string GetDevice()
        {
            string device = "unknow";
            NameValueCollection headers = HttpContext.Current.Request.Headers;
            for (int i = 0; i < headers.Count; i++)
            {
                string key = headers.GetKey(i);
                string value = headers.Get(i);
                if (key.Contains("User-Agent"))
                {
                    device = Regex.Match(value, @"\(([^)]*)\)").Groups[1].Value;
                }
            }
            return device;
        }
        public static string GetOS_PLATFORM()
        {
            string OS = "unknow";
            var os = Environment.OSVersion;
            if (os != null)
            {
                OS = os.VersionString;
            }
            return OS;
        }
    }
}