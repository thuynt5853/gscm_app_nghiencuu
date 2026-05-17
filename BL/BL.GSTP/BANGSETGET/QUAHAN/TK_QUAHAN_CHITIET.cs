using System;

namespace BL.GSTP.BANGSETGET.QUAHAN
{
    //Thêm bảng TK_QUAHAN_CHITIET
    public partial class TK_QUAHAN_CHITIET
    {
        public Decimal ID { get; set; }
        public Decimal DONID { get; set; }
        public string MAVUVIEC { get; set; }
        public Decimal TKQUAHANID { get; set; }
        public Decimal LYDO_QUAHAN { get; set; }
        public string CHITIET_LYDO { get; set; }
        public DateTime? NGAYTAO { get; set; }
        public string NGUOITAO { get; set; }
        public DateTime? NGAYSUA { get; set; }
        public string NGUOISUA { get; set; }
        public Decimal ISSOTHAM { get; set; }
        public Decimal ISPHUCTHAM { get; set; }
    }
}
