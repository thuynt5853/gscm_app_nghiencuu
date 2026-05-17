using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WEB.GSTP.Models
{
    /* Bản án của vụ án trong lần xét xử hiện tại (object) */
    public class BAN_AN
    {
        /* Số bản án */
        public string SOBANAN { get; set; }
        /* Ngày bản án dd-MM-yyyy */
        public string NGAYBANAN { get; set; }
        /* Mã kết quả vụ án */
        public string KETQUA { get; set; }
        /* Mã lý do */
        public string LYDO { get; set; }
        /* Tên người ký */
        public string NGUOIKY { get; set; }
    }
}