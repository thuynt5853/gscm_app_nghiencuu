using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BL.GSTP.BANGSETGET
{
    public class VALIDATE_TAIKHOAN
    {
        public decimal ID { get; set; }
        public DateTime? NGAY_THAY_DOI_MK { get; set; }
        public string MATKHAU_OLD { get; set; }
        public string NGUOI_DOI_MK { get; set; }
        public decimal NGUOISUDUNG_ID { get; set; }
        
    }

    public class VALIDATE_TAIKHOAN_LOG
    {
        public decimal ID { get; set; }
        public decimal USER_ID { get; set; }
        public DateTime? NGAY_THAY_DOI_MK { get; set; }
        public string MATKHAU_OLD { get; set; }
        public string NGUOI_DOI_MK { get; set; }
        public decimal NGUOI_DOI_MK_ID { get; set; }
    }
}