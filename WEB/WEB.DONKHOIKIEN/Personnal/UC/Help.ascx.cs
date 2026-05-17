using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.DONKHOIKIEN.Personnal.UC
{
    public partial class Help : System.Web.UI.UserControl
    {
        public String CodePage = "";
        protected void Page_Load(object sender, EventArgs e)
        {   
            string CurrPage = HttpContext.Current.Request.Url.PathAndQuery.ToLower();           
            if (!CurrPage.Contains("/"))
                CodePage = CurrPage.ToLower().Replace(".aspx", "");
            else
            {
                string[] arr = CurrPage.Split('/');
                foreach(String item in arr)
                {
                    if (item.Length>0 && item.Contains(".aspx"))
                        CodePage = item.ToLower().Replace(".aspx", "");
                }
            }
        }
    }
}