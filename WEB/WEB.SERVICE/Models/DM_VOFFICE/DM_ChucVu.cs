using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WEB.Service.Models
{
    public class DM_ChucVu
    {
        public long Id { get; set; }
        public string MaChucVu { get; set; }
        public string TenChucVu { get; set; }
        public string GhiChu { get; set; }

        public long HieuLuc { get; set; }
    }
}