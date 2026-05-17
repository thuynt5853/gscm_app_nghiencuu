using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WEB.GSTP.Models
{
    /* Danh sách các kháng cáo (List<object>) */
    public class KHANG_CAO
    {
        /* Tên người kháng cáo */
        public string NGUOIKHANGCAO { get; set; }
        /* GUID của người kháng cáo */
        public byte[] GUID { get; set; }
        /* Mã tư cách tố tụng */
        public string TUCACHTOTUNG { get; set; }
        /* Ngày kháng cáo dd-MM-yyyy */
        public string NGAYKHANGCAO { get; set; }
        /* Mã yêu cầu kháng cáo */
        public string YEUCAUKHANGCAO { get; set; }
        /* Nội dung kháng cáo */
        public string NOIDUNGKHANGCAO { get; set; }
    }
}