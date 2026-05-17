using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WEB.Service.Models
{
    public class DM_ChucDanh
    {
        public long Id { get; set; }
        public string MaChucDanh { get; set; }
        public string TenChucDanh { get; set; }
        public string GhiChu { get; set; }

        public long HieuLuc { get; set; }
    }
}