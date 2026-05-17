using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BL.GSTP.BANGSETGET
{
    public class CUS_CHUYENAN_INPUT
    {
        public string ToaAn_ID { get; set; }
        public string ToaAn_Ten { get; set; }

        public string VuViecID { get; set; }

        public string MaVuVien { get; set; }
        public string TenVuVien { get; set; }
        public string LyDoId { get; set; }//THGN
        public string NgayGiao { get; set; }//dd/MM/yyyy
        public string GhiChu { get; set; } 
        public string ToaGiao { get; set; } 
        public string TruongHopGiaoNhan { get; set; }
        public bool? isEnableToaAnTen { get; set; }
    }
    public class CUS_NHANAN_INPUT
    {
        public string NhanAnID { get; set; }
        public string MaVuViec { get; set; }

        public string TenVuViec { get; set; }

        public string NgayGiao { get; set; }
        public string ToaGiao { get; set; }
        public string ToaNhan { get; set; }//THGN
        public string TruongHopGiaoNhan { get; set; }//dd/MM/yyyy
        public string NgayNhan { get; set; } 
    }
}