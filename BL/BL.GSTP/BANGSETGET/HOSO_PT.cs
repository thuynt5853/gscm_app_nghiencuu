using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BL.GSTP.BANGSETGET
{
    public class HOSO_PT
    {
        public decimal ID { get; set; }
        public Nullable<decimal> LOAIAN { get; set; }
        public Nullable<decimal> VUANID { get; set; }
        public Nullable<decimal> LOAI_CN { get; set; }
        public Nullable<decimal> CANBOID { get; set; }
        public Nullable<System.DateTime> NGAY_NC { get; set; }
        public Nullable<decimal> DV_GUI_NHAN { get; set; }
        public string NGUOI_NHAN_VKS { get; set; }
        public string GHICHU { get; set; }
        public string NGUOITAO { get; set; }
        public Nullable<System.DateTime> NGAYTAO { get; set; }
        public Nullable<decimal> LOAI_DV { get; set; }
        public Nullable<decimal> TOAANID { get; set; }
        public Nullable<decimal> TOA_GIAIQUYET_ID { get; set; }
    }
}