//----------------------------------------------------------------------------------------------------------------------
// Create by       : GS template 1.0
// Template create : GS
// Create date     : 12/9/2023
//----------------------------------------------------------------------------------------------------------------------
using System;

namespace BL.GSTP.BANGSETGET.HOAGIAI
{
    public partial class HOAGIAI_GHINHANKETQUA
    {
        public Decimal ID { get; set; }
        public Decimal? HOAGIAIID { get; set; }
        public DateTime? NGAYHOAGIAI { get; set; }
        public String DIADIEM { get; set; }
        public Decimal? YEUCAUQD { get; set; }
        public Decimal? KETQUAID { get; set; }
        public Decimal? LYDOHOANID { get; set; }
        public Decimal? LYDOID { get; set; }
        public Decimal? NGUOIKYID { get; set; }
        public String CHUCVU { get; set; }
        public DateTime? NGAYQUYETDINH { get; set; }
        public String SOQUYETDINH { get; set; }
        public DateTime? NGAYTHONGBAO { get; set; }
        public String SOTHONGBAO { get; set; }
        public DateTime? NGAYBIENBAN { get; set; }
        public Decimal? FILEID { get; set; }
        public DateTime? NGAYTAO { get; set; }
        public String NGUOITAO { get; set; }
        public DateTime? NGAYSUA { get; set; }
        public String NGUOISUA { get; set; }

        public string LYDOHOAN { get; set; }
        public string NGUOIKY { get; set; }
    }
}