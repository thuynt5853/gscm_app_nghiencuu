//----------------------------------------------------------------------------------------------------------------------
// Create by       : GS template 1.0
// Template create : GS
// Create date     : 27/3/2023
//----------------------------------------------------------------------------------------------------------------------
using System;

namespace BL.GSTP.BANGSETGET
{
    public partial class KHANGCAOQUAHAN_THULY
    {
        public Decimal ID { get; set; }
        public Decimal? LOAIAN { get; set; }
        public Decimal? DONID { get; set; }
        public Decimal? KHANGCAOID { get; set; }
        public Decimal? LOAIKHANGCAO { get; set; }
        public Decimal? TOAANID { get; set; }


        public String SOTHULY { get; set; }
        public DateTime? NGAYTHULY { get; set; }

        public Decimal? NGUOITHULYID { get; set; }


        public DateTime? NGAYTAO { get; set; }
        public String NGUOITAO { get; set; }
        public DateTime? NGAYSUA { get; set; }
        public String NGUOISUA { get; set; }

    }
}