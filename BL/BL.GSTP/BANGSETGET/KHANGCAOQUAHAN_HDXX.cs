//----------------------------------------------------------------------------------------------------------------------
// Create by       : GS template 1.0
// Template create : GS
// Create date     : 27/3/2023
//----------------------------------------------------------------------------------------------------------------------
using System;

namespace BL.GSTP.BANGSETGET
{
    public partial class KHANGCAOQUAHAN_HDXX
    {
        public Decimal ID { get; set; }
        public Decimal? LOAIAN { get; set; }
        public Decimal? DONID { get; set; }
        public Decimal? THULYID { get; set; }
        public Decimal? TOAANID { get; set; }
        
        public String MAVAITRO { get; set; }
        public Decimal? CANBOID { get; set; }
        
        public Decimal? NGUOIPHANCONGID { get; set; }
        public DateTime? NGAYPHANCONG { get; set; }
        public DateTime? NGAYNHANPHANCONG { get; set; }
        
        public Decimal? HIEULUC { get; set; }

        public DateTime? NGAYTAO { get; set; }
        public String NGUOITAO { get; set; }
        public DateTime? NGAYSUA { get; set; }
        public String NGUOISUA { get; set; }
    }
}