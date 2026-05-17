//----------------------------------------------------------------------------------------------------------------------
// Create by       : GS template 1.0
// Template create : GS
// Create date     : 12/9/2023
//----------------------------------------------------------------------------------------------------------------------
using System;

namespace BL.GSTP.BANGSETGET.CONGBOBAQD
{
    public partial class BAQD_CONGBO
    {
        public Decimal ID { get; set; }
        public Decimal LOAIANID { get; set; }
        public Decimal CAPXETXU { get; set; }
        public Decimal ISBA { get; set; }
        public Decimal BAQDID { get; set; }
        public Decimal? TRANGTHAI { get; set; }
        public DateTime? NGAYHIEULUC { get; set; }
        public String NGUOITAO { get; set; }
        public DateTime? NGAYTAO { get; set; }
        public String NGUOISUA { get; set; }
        public DateTime? NGAYSUA { get; set; }
        public Decimal? LYDOTUCHOI { get; set; }
        public String MAVUAN { get; set; }
        public String GHICHU { get; set; }
        public Decimal VUVIECID { get; set; }
        public Decimal? PUBLIC_JUDGMENT_ID { get; set; }
        public String TENVIVIEC_MAHOA { get; set; }
        public String THONGTINVUVIEC { get; set; }
    }
}