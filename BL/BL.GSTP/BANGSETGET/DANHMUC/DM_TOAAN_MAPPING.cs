//----------------------------------------------------------------------------------------------------------------------
// Create by       : GS template 1.0
// Template create : GS
// Create date     : 17/7/2023
//----------------------------------------------------------------------------------------------------------------------
using System;

namespace BL.GSTP.BANGSETGET.DANHMUC
{
    public partial class DM_TOAAN_MAPPING
    {
        public Decimal TOAANID { get; set; }
        public Decimal TOAANID_MAP { get; set; }
        private DateTime? NGAYTAO { get; set; }
        private string NGUOITAO { get; set; }
        private DateTime? NGAYSUA { get; set; }
        private string NGUOISUA { get; set; }
    }
}