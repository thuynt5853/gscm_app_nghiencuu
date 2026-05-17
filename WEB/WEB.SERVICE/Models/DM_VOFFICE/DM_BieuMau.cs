using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WEB.Service.Models
{
    public class DM_BieuMau
    {
        public decimal BieuMauId { get; set; }
        public string TenBieuMau { get; set; }
        public string MaBieuMau { get; set; }
        public decimal Status { get; set; }
    }
}