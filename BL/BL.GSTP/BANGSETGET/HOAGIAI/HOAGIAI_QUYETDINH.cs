//----------------------------------------------------------------------------------------------------------------------
// Create by       : GS template 1.0
// Template create : GS
// Create date     : 12/9/2023
//----------------------------------------------------------------------------------------------------------------------
using System;

namespace BL.GSTP.BANGSETGET.HOAGIAI
{
    public partial class HOAGIAI_QUYETDINH
    {
        public Decimal ID { get; set; }
        public Decimal? HOAGIAIID { get; set; }
        public Decimal? KETQUAID { get; set; }
        public Decimal? QUYETDINHID { get; set; }
        public DateTime? NGAYHOAGIAI { get; set; }
        public String DIADIEM { get; set; }
        public Decimal? LYDOID { get; set; }
        public Decimal? NGUOIKYID { get; set; }
        public String CHUCVU { get; set; }
        public DateTime? NGAYQUYETDINH { get; set; }
        public String SOQUYETDINH { get; set; }
        public Decimal? FILEID { get; set; }
        public DateTime? NGAYTAO { get; set; }
        public String NGUOITAO { get; set; }
        public DateTime? NGAYSUA { get; set; }
        public String NGUOISUA { get; set; }
        public String LYDO { get; set; }
        public String NGUOIKY { get; set; }
        public Decimal? TK_CHAPNHAN { get; set; } //1-Cho ly hôn, 3-Không công nhận là vợ chồng, 4-Khác
    }
}