using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WEB.Service.Service.Auth
{
    public class Notification
    {
        public string tongdatId { get; set; }
        public string notiTypeCode { get; set; }
        public string notiName { get; set; }
        public string notiNumber { get; set; }
        public string sendPlaceCode { get; set; }
        public string sendPlaceName { get; set; }
        public string citizenNumber { get; set; }
        public string citizenName { get; set; }
        public string area { get; set; }
        public string documentNumber { get; set; }
        public string publishDate { get; set; }
        public string fileId { get; set; }
        public string fileName { get; set; }
        public List<string> note { get; set; }


    }
}