using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Module.Common;
using DAL.DKK;
using BL.DonKK.DanhMuc;
using BL.DonKK;
namespace WEB.DONKHOIKIEN.UserControl
{
    public partial class Home_HuongDan : System.Web.UI.UserControl
    {
        public Decimal UserID = 0;
        public int MucDichSD = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            pn.Visible = true;
            UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (UserID > 0)
                MucDichSD = (string.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_MUCDICHSD] + "")) ? 0 : Convert.ToInt16(Session[ENUM_SESSION.SESSION_MUCDICHSD] + "");
                
           
        }
    }
}