using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Globalization;


namespace WEB.DONKHOIKIEN.MasterPages
{
    public partial class User : System.Web.UI.MasterPage
    {
        //DKKContextContainer dt = new DKKContextContainer();
        //public Decimal UserID = 0;
        //CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            //String home_canhan = "PersonalIndex".ToLower();
            //UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            //if (UserID > 0)
            //{              
            //    string CurrPage = HttpContext.Current.Request.Url.PathAndQuery.ToLower();
            //    int MucDichSD =(string.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_MUCDICHSD]+""))? 0: Convert.ToInt16(Session[ENUM_SESSION.SESSION_MUCDICHSD]+"");
            //    //if (MucDichSD == 2)
            //    //{
            //    //    if (CurrPage.Contains(home_canhan))
            //    //    {
            //    //        ltt.Text = "<a href=\"javascript:;\" onclick='alert(\"Bạn chưa đăng ký sử dụng chức năng này!\")'>";
            //    //            ltt.Text += "<div class='guidonkien_head'></div>";
            //    //        ltt.Text += "</a>";
            //    //    }
            //    //    else
            //    //        ltt.Text = "";
            //    //}
            //    if (MucDichSD == 2)
            //        ltt.Text = "";
            //    else
            //    {                    
            //        if (CurrPage.Contains(home_canhan))
            //            ltt.Text = "<a href='/Personnal/GuiDonKien.aspx'><div class='guidonkien_head'></div></a>";                    
            //        else
            //            ltt.Text = "";
            //    }
            //}
            //else
            //    ltt.Text = "";
        }

        //Xoa DL rac--------------
        //DONKK_DON_BL objBL = new DONKK_DON_BL();
        //objBL.DeleteDonTemp(UserID, Session[ENUM_SESSION.SESSION_USERNAME].ToString());
    }
}