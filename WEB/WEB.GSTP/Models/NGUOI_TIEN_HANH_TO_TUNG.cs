using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WEB.GSTP.Models
{
    /* Danh sách người tiến hành tố tụng (List<object>) */
    public class NGUOI_TIEN_HANH_TO_TUNG
    {
        /* Mã cán bộ */
        public string MACANBO { get; set; }
        /* Tên cán bộ */
        public string TENCANBO { get; set; }
        /* Mã tư cách người tiến hành tố tụng */
        public string TUCACHTOTUNG { get; set; }
    }
}