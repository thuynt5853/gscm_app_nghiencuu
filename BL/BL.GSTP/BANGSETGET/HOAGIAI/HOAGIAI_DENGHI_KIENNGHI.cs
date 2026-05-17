//----------------------------------------------------------------------------------------------------------------------
// Create by       : GS template 1.0
// Template create : GS
// Create date     : 12/9/2023
//----------------------------------------------------------------------------------------------------------------------
using System;

namespace BL.GSTP.BANGSETGET.HOAGIAI
{
    public partial class HOAGIAI_DENGHI_KIENNGHI
    {
        public Decimal ID { get; set; }
        public Decimal? HOAGIAIID { get; set; }
        public Decimal? LOAIID { get; set; }
        public Decimal? TUCACHDUONGSU { get; set; }
        public DateTime? NGAYVIETDON { get; set; }
        public DateTime? NGAYDENGHI { get; set; }
        public Decimal? NGUOIDENGHIID { get; set; }
        public Decimal? NGUOIKIENNGHIID { get; set; }
        public Decimal? DONVIKIENNGHIID { get; set; }
        public String SOKIENNGHI { get; set; }
        public DateTime? NGAYKIENNGHI { get; set; }
        public String SOQUYETDINH { get; set; }
        public DateTime? NGAYQUYETDINH { get; set; }
        public Decimal? TOAANRAQUYETDINH { get; set; }
        public String NOIDUNG { get; set; }
        public Decimal? FILEID { get; set; }
        public DateTime? NGAYTAO { get; set; }
        public String NGUOITAO { get; set; }
        public DateTime? NGAYSUA { get; set; }
        public String NGUOISUA { get; set; }
        public Decimal? HINHTHUCNHANDON { get; set; }
    }
}