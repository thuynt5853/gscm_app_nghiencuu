using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WEB.Service.Controllers.Utils
{
    public class DataUtils
    {

        // server TA
        //public const string END_POINT_VOFFICE = "http://192.168.0.19:8088/rest/dataMigration/tong-dat";
        //public const string END_POINT_VOFFICE_REALLOCATE = "http://192.168.0.19:8088/rest/dataMigration/tong-dat-thu-hoi";
        // localhost
        public const string END_POINT_VOFFICE = "http://localhost:8888/rest/dataMigration/tong-dat";
        public const string END_POINT_VOFFICE_REALLOCATE = "http://localhost:8888/rest/dataMigration/tong-dat-thu-hoi";

        public const string END_POINT_VOFFICE_GDTTT = "http://localhost:8888/rest/dataMigration/tongdat_gdkt";
        public const string END_POINT_VOFFICE_GDTTT_REALLOCATE = "http://localhost:8888/rest/dataMigration/tong-dat-thu-hoi";

        public const string END_POINT_VOFFICE_UNLOCK = "http://localhost:8888/rest/dataMigration/mo-khoa-tong-dat";

        // server TATC
        //public const string END_POINT_VOFFICE = "https://10.1.19.99/rest/dataMigration/tong-dat";
        //public const string END_POINT_VOFFICE_REALLOCATE = "https://10.1.19.99/rest/dataMigration/tong-dat-thu-hoi";
        // server TATC
        //public const string END_POINT_VOFFICE = "https://vbdh.toaan.gov.vn/rest/dataMigration/tong-dat";
        //public const string END_POINT_VOFFICE_REALLOCATE = "https://vbdh.toaan.gov.vn/rest/dataMigration/tong-dat-thu-hoi";




        private static readonly DateTime UnixEpoch = new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc);

        public static long GetCurrentUnixTimestampMillis(DateTime localDateTime)
        {
            DateTime univDateTime;
            univDateTime = localDateTime.ToUniversalTime();
            return (long)(univDateTime - UnixEpoch).TotalMilliseconds;
        }
    }
}