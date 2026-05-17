using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BL.GSTP.BANGSETGET.XLHC.KCKN
{
    public partial class XLHC_KCKNQDK_PHUCTHAM_THULY
    {
        public Decimal ID { get; set; }
        public Decimal? DONID { get; set; }
        public String MATHULY { get; set; }
        public Decimal? TRUONGHOPTHULY { get; set; }
        public DateTime? NGAYTHULY { get; set; }
        public String SOTHULY { get; set; }
        public Decimal? LOAIQUANHE { get; set; }
        public Decimal? QUANHEPHAPLUATID { get; set; }
        public DateTime? THOIHANTUNGAY { get; set; }
        public DateTime? THOIHANDENNGAY { get; set; }
        public String GHICHU { get; set; }
        public DateTime? NGAYTAO { get; set; }

        public String NGUOITAO { get; set; }
        public DateTime? NGAYSUA { get; set; }
        public String NGUOISUA { get; set; }
        public Decimal? TT { get; set; }
        public Decimal? TOAANID { get; set; }
        public Decimal? QHPLTKID { get; set; }
        //public Decimal? FILEID { get; set; }
        public String SOTHONGBAO { get; set; }
        public String QUANHEPHAPLUAT_NAME { get; set; }
        public DateTime? NGAYTHONGBAO { get; set; }
        public Decimal? NGUOIKY { get; set; }
        public Decimal TOA_GIAIQUYET_ID { get; set; }

        //public String VAITRO_NGUOIKY { get; set; }
        //public Decimal? TK_QUYETDINH { get; set; }
        //public String TENFILE { get; set; }

        //public String KIEUFILE { get; set; }
        //public byte[] NOIDUNGFILE { get; set; }
    }
}