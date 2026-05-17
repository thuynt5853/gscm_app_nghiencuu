using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WEB.Service.Models.DM_VOFFICE
{
    public class ToiDanhDTO
    {

        public decimal Id { get; set; }

        public string Dieu { get; set; }

        public string TenToiDanh { get; set; }

        public decimal? LuatId { get; set; }

        public decimal? loai { get; set; }

        public decimal? hieuluc { get; set; }
    }
}