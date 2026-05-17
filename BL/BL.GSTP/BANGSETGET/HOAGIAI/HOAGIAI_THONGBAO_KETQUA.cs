//----------------------------------------------------------------------------------------------------------------------
// Create by       : GS template 1.0
// Template create : GS
// Create date     : 12/9/2023
//----------------------------------------------------------------------------------------------------------------------
using System;

namespace BL.GSTP.BANGSETGET.HOAGIAI
{
    public partial class HOAGIAI_THONGBAO_KETQUA
    {
        public Decimal ID { get; set; }
        public Decimal HOAGIAIID { get; set; }
        public Decimal THONGBAOID { get; set; }
        public Decimal DUONGSUID { get; set; }
        public DateTime? NGAYDSTRALOI { get; set; }
        public Decimal LUACHONID { get; set; }
        public Decimal? HOAGIAIVIENID { get; set; }
        public DateTime? NGAYTAO { get; set; }
        public String NGUOITAO { get; set; }
        public DateTime? NGAYSUA { get; set; }
        public String NGUOISUA { get; set; }
        public Decimal? TOAANHGV {  get; set; }
    }
}