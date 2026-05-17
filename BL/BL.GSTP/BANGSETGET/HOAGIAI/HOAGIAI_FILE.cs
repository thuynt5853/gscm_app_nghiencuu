//----------------------------------------------------------------------------------------------------------------------
// Create by       : GS template 1.0
// Template create : GS
// Create date     : 12/9/2023
//----------------------------------------------------------------------------------------------------------------------
using System;

namespace BL.GSTP.BANGSETGET.HOAGIAI
{
    public partial class HOAGIAI_FILE
    {
        public Decimal ID { get; set; }
        public Decimal? LOAIFILE { get; set; }
        public Decimal? KIEUFILE { get; set; }
        public String TENFILE { get; set; }
        public String DUOIFILE { get; set; }
        public Decimal? KICHTHUOC { get; set; }
        public String NGUOITAO { get; set; }
        public DateTime? NGAYTAO { get; set; }
        public String NGUOISUA { get; set; }
        public DateTime? NGAYSUA { get; set; }
        public Decimal? FILESERVER_ID { get; set; }
    }
}