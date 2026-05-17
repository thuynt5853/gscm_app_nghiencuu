using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WEB.Service.Service.Auth
{
    public class AuthResponse
    {
        public string token { get; set; }
        public string token_type { get; set; }
        public string expires_in { get; set; }
    }
}