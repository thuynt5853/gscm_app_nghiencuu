using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WEB.GSTP.Models
{
    /* Danh sách các quyết định của vụ án trong lần xét xử hiện tại (List<object>) */
    public class QUYET_DINH
    {
        /* Mã của loại quyết định */
        public string MAQUYETDINH { get; set; }
        /* Số quyết định */
        public string SOQUYETDINH { get; set; }
        /* Ngày quyết định */
        public string NGAYQUYETDINH { get; set; }
        /* Tên người ký */
        public string NGUOIKY { get; set; }
    }
}