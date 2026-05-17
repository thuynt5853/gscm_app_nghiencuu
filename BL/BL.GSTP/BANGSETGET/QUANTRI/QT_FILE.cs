//----------------------------------------------------------------------------------------------------------------------
// Create by       : GS template 1.0
// Template create : GS
// Create date     : 14/9/2023
//----------------------------------------------------------------------------------------------------------------------
using System;

namespace BL.GSTP.BANGSETGET.QUANTRI
{
    public partial class QT_FILE
    {
        public Decimal ID { get; set; }
        public String FILE_URL { get; set; }
        public String FILE_NAME { get; set; }
        public String FILE_TYPE { get; set; }
        public String FILE_CONNTENT_TYPE { get; set; }
        public Decimal? FILE_SIZE { get; set; }
        public String DESCRIPTION { get; set; }
        public DateTime? DATE_CREATED { get; set; }
        public DateTime? DATE_MODIFIED { get; set; }
        public short? DELETE_STATE { get; set; }
        public DateTime? DATE_DELETED { get; set; }
    }
}