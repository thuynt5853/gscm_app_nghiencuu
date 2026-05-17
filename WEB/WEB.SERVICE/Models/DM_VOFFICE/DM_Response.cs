using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WEB.Service.Models
{
    public class DM_Response
    {
        public string Note { get; set; }
        public string Message { get; set; }
        public string RequestTime { get; set; }

        public object Data { get; set; }
    }
}