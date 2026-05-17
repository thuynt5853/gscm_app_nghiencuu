//----------------------------------------------------------------------------------------------------------------------
// Create by       : GS template 1.0
// Template create : GS
// Create date     : 12/9/2023
//----------------------------------------------------------------------------------------------------------------------
using System;

namespace BL.GSTP.BANGSETGET.HOAGIAI
{
    public partial class HOAGIAI_DON_GIAONHAN
    {
        public Decimal ID { get; set; }
        public Decimal? HOAGIAIID { get; set; }
        public DateTime? NGAYGIAO { get; set; }
        public DateTime? NGAYGIAOTHUC { get; set; }
        public Decimal NGUOIGIAOID { get; set; }
        public DateTime? NGAYNHAN { get; set; }
        public DateTime? NGAYLAP { get; set; }
        public Decimal? NGUOINHANID { get; set; }
        public Decimal? TRANGTHAI { get; set; }
        public String GHICHU { get; set; }
        public DateTime? NGAYTAO { get; set; }
        public String NGUOITAO { get; set; }
        public DateTime? NGAYSUA { get; set; }
        public String NGUOISUA { get; set; }
    }
}