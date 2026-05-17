//----------------------------------------------------------------------------------------------------------------------
// Create by       : GS template 1.0
// Template create : GS
// Create date     : 27/3/2023
//----------------------------------------------------------------------------------------------------------------------
using System;

namespace BL.GSTP.BANGSETGET
{
    public partial class KHANGCAOQUAHAN_QUYETDINH
    {
        public Decimal ID { get; set; }
        public Decimal? LOAIAN { get; set; }
        public Decimal? DONID { get; set; }
        public Decimal? THULYID { get; set; }
        public Decimal? TOAANID { get; set; }

        public String SOQD { get; set; }
        public DateTime? NGAYQD { get; set; }
        public String LYDOKCQH { get; set; }

        public Decimal? KETQUA { get; set; }
        public DateTime? NGAYGIAIQUYET { get; set; }

        public String GHICHU { get; set; }

        public DateTime? NGAYTAO { get; set; }
        public String NGUOITAO { get; set; }
        public DateTime? NGAYSUA { get; set; }
        public String NGUOISUA { get; set; }
    }
}