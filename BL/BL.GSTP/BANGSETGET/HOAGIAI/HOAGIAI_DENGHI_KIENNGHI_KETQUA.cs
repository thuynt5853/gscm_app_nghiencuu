//----------------------------------------------------------------------------------------------------------------------
// Create by       : GS template 1.0
// Template create : GS
// Create date     : 12/9/2023
//----------------------------------------------------------------------------------------------------------------------
using System;

namespace BL.GSTP.BANGSETGET.HOAGIAI
{
    public partial class HOAGIAI_DENGHI_KIENNGHI_KETQUA
    {
        public Decimal ID { get; set; }
        public Decimal HOAGIAIID { get; set; }
        public DateTime? NGAYGIAO { get; set; }
        public DateTime? NGAYNHAN { get; set; }
        public Decimal? TOANHANID { get; set; }
        public Decimal? THAMPHANID { get; set; }
        public Decimal? QUYETDINHID { get; set; }
        public String SOQUYETDINH { get; set; }
        public DateTime? NGAYQUYETDINH { get; set; }
        public DateTime? NGAYTAO { get; set; }
        public String NGUOITAO { get; set; }
        public DateTime? NGAYSUA { get; set; }
        public String NGUOISUA { get; set; }
        public String SOTHULY { get; set; }
        public DateTime? NGAYTHULY { get; set; }
    }
}