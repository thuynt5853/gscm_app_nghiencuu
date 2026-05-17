//----------------------------------------------------------------------------------------------------------------------
// Create by       : GS template 1.0
// Template create : GS
// Create date     : 12/9/2023
//----------------------------------------------------------------------------------------------------------------------
using System;

namespace BL.GSTP.BANGSETGET.HOAGIAI
{
    public partial class HOAGIAI_THONGBAO
    {
        public Decimal ID { get; set; }
        public Decimal HOAGIAIID { get; set; }
        public Decimal SOLAN { get; set; }
        public DateTime? NGAYTHONGBAO { get; set; }
        public String SOTHONGBAO { get; set; }
        public Decimal? NGUOIKYID { get; set; }
        public String NGUOIKY { get; set; }
        public Decimal? FILEID { get; set; }
        public DateTime? NGAYTAO { get; set; }
        public String NGUOITAO { get; set; }
        public DateTime? NGAYSUA { get; set; }
        public String NGUOISUA { get; set; }
    }
}