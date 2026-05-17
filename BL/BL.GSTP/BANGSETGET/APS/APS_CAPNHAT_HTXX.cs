using System;

namespace BL.GSTP.BANGSETGET.APS
{
    public partial class APS_CAPNHAT_HTXX
    {
        public Decimal ID { get; set; }
        public Decimal TOAANID { get; set; }
        public Decimal? MAGIAIDOAN { get; set; }

        public Decimal? CHUTOAID { get; set; }
        public String THUKY_IDS { get; set; }

        public DateTime? NGAYXETXU { get; set; }

        public String TENVUAN { get; set; }

        public Decimal LOAIBAQD { get; set; }
        public String SOBAQD { get; set; }
        public DateTime? NGAYBAQD { get; set; }

        public Decimal TRANGTHAI { get; set; }

        public String PHONGXETXU { get; set; }
        public String DIEMCAU_1 { get; set; }
        public String DIEMCAU_2 { get; set; }

        public String GHICHU { get; set; }

        public DateTime? NGAYTAO { get; set; }
        public String NGUOITAO { get; set; }
        public DateTime? NGAYSUA { get; set; }
        public String NGUOISUA { get; set; }
    }
}