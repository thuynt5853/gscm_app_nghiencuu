using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WEB.GSTP.Models
{
    /* Lịch xét xử của vụ án (object) */
    public class LICH_XET_XU
    {
        /* Ngày xét xử dd-MM-yyyy */
        public string NGAYXETXU { get; set; }
        /* Mã tòa án nơi diễn ra phiên tòa */
        public string DIADIEMXETXU { get; set; }
    }
}