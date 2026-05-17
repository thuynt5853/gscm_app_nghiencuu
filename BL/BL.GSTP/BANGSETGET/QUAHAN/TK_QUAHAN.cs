using System;

namespace BL.GSTP.BANGSETGET.QUAHAN
{
    //Thêm bảng TK_QUAHAN
    public partial class TK_QUAHAN
    {
        public Decimal ID { get; set; }
        public DateTime? NGAYTAO { get; set; }
        public string NGUOITAO { get; set; }
        public Decimal THANG { get; set; }
        public Decimal NAM { get; set; }
        public Decimal SOVUAN_QUAHAN { get; set; }
        public Decimal TRANGTHAI { get; set; }
        public Decimal LOAIAN { get; set; }
        public DateTime? NGAYSUA { get; set; }
        public string NGUOISUA { get; set; }
        public Decimal TOAANID {  get; set; }
    }
}
