using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WEB.GSTP.Models
{
    public class TOIDANH
    {
        /* Tội danh - Mã Bộ luật */
        public string BOLUAT { get; set; }
        /* Tội danh - Điều */
        public int DIEU { get; set; }
        /* Tội danh - Khoản */
        public int KHOAN { get; set; }
        /* Tội danh - Điểm */
        public string DIEM { get; set; }
        /* Tội danh - Mã hình phạt chính */
        public int HINHPHATCHINH { get; set; }
        /* Tội danh - Mức án "năm-tháng-ngày" */
        public string MUCAN { get; set; }
        /* Tội danh - Mã Hình phạt bổ sung */
        public string HINHPHATBOSUNG { get; set; }
        /* Tội danh - Chi tiết hình phạt bổ sung */
        public string CHITIETBOSUNG { get; set; }
        /* Tội danh - Là án treo? */
        public bool ISANTREO { get; set; }
    }
}