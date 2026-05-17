//----------------------------------------------------------------------------------------------------------------------
// Create by       : GS template 1.0
// Template create : GS
// Create date     : 12/9/2023
//----------------------------------------------------------------------------------------------------------------------
using System;

namespace BL.GSTP.BANGSETGET.HOAGIAI
{
    public partial class HOAGIAI_THAMPHAN
    {
        public Decimal ID { get; set; }
        public Decimal HOAGIAIID { get; set; }
        public Decimal? THAMPHANID { get; set; }
        public Decimal? HOAGIAIVIENID { get; set; }
        public DateTime? NGAYPHANCONG { get; set; }
        public DateTime? NGAYNHANPHANCONG { get; set; }
        public Decimal? NGUOIPHANCONGID { get; set; }
        public String MAVAITRO { get; set; }
        public Decimal? LUACHONHGV { get; set; }
        public Decimal? TOAANHGV { get; set; }
        public DateTime? NGAYTAO { get; set; }
        public String NGUOITAO { get; set; }
        public DateTime? NGAYSUA { get; set; }
        public String NGUOISUA { get; set; }
        public DateTime? NGAYCHIDINH { get; set; }
        public String LYDOCHIDINH { get; set; }
        public String GHICHU {  get; set; }
        public String NGUOIKY { get; set; }
    }
}