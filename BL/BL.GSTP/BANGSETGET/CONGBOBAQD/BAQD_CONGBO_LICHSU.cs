using System;

namespace BL.GSTP.BANGSETGET.CONGBOBAQD
{
    public partial class BAQD_CONGBO_LICHSU
    {
        public Decimal ID { get; set; }
        public Decimal BAQD_CONGBO_ID { get; set; }
        public String HANHDONG { get; set; }
        public Decimal? FILESERVER_ID_OLD { get; set; }
        public Decimal? FILESERVER_ID_NEW { get; set; }
        public String NGUOITAO { get; set; }
        public DateTime NGAYTAO { get; set; }

    }
}