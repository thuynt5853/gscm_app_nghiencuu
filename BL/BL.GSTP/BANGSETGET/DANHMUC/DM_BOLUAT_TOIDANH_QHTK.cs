//----------------------------------------------------------------------------------------------------------------------
// Create by       : GS template 1.0
// Template create : GS
// Create date     : 17/7/2023
//----------------------------------------------------------------------------------------------------------------------
using System;

namespace BL.GSTP.BANGSETGET.DANHMUC
{
    public partial class DM_BOLUAT_TOIDANH_QHTK
    {
        public Decimal ID { get; set; }
        public String TOIDANHTK_TEN { get; set; }
        public Decimal? TOIDANHTK_ID { get; set; }
        public Decimal? TOIDANH_ID { get; set; }
        public Decimal CONGBO_CASE_ID { get; set; }
        public String CONGBO_CASE_NAME { get; set; }
    }
}