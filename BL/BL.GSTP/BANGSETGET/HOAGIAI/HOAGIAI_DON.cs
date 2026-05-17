//----------------------------------------------------------------------------------------------------------------------
// Create by       : GS template 1.0
// Template create : GS
// Create date     : 12/9/2023
//----------------------------------------------------------------------------------------------------------------------
using System;

namespace BL.GSTP.BANGSETGET.HOAGIAI
{
    public partial class HOAGIAI_DON
    {
        public Decimal ID { get; set; }
        public Decimal? TOAANID { get; set; }
        public Decimal VUVIECID { get; set; }
        public String MAVUVIEC { get; set; }
        public String TENVUVIEC { get; set; }
        public String NGUOITAO { get; set; }
        public DateTime? NGAYTAO { get; set; }
        public String NGUOISUA { get; set; }
        public DateTime? NGAYSUA { get; set; }
        public Decimal? LOAIANID { get; set; }
    }
}