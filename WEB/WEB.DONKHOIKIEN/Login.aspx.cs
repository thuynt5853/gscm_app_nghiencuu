using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Module.Common;
using BL.DonKK.DanhMuc;
namespace WEB.DONKHOIKIEN
{
    public partial class Login : System.Web.UI.Page
    {
        public Decimal UserID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (UserID > 0)
            {
                int MucDichSD = Convert.ToInt32(Session[ENUM_SESSION.SESSION_MUCDICHSD] + "");
                DONKK_USERS_BL objUserBL = new DONKK_USERS_BL();
                Boolean TinhTrangSD = objUserBL.CheckIsUse(UserID, MucDichSD);
                switch (MucDichSD)
                {
                    case 1:
                        if (TinhTrangSD)
                            Response.Redirect("/Personnal/PersonalIndex.aspx");
                        else
                            Response.Redirect("/Personnal/GuiDonKien.aspx");
                        break;
                    case 2:
                        if (TinhTrangSD)
                            Response.Redirect("/Personnal/PersonalIndex.aspx");
                        else
                            Response.Redirect("/Personnal/DangKyNhanVB.aspx");
                        break;
                }
            }
        }
    }
}