using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WEB.Service.Models
{
    public class TokenResponse
    {
        public string TokenKey { get; set; }
        public long ExpiredTime { get; set; }
    }
}