using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DAL.DKK;
using BL.DonKK.DanhMuc;
using Module.Common;

namespace WEB.DONKHOIKIEN.Personnal
{
    public partial class PersonalIndex : System.Web.UI.Page
    {
        DKKContextContainer dt = new DKKContextContainer();
        public Decimal UserID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (UserID == 0)
                Response.Redirect("/Trangchu.aspx");
            else
            {
                int MucDichSD = (string.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_MUCDICHSD] + "")) ? 0 : Convert.ToInt16(Session[ENUM_SESSION.SESSION_MUCDICHSD] + "");
                DONKK_USERS_BL objUserBL = new DONKK_USERS_BL();
                Boolean TinhTrangSD = objUserBL.CheckIsUse(UserID, MucDichSD);
                switch (MucDichSD)
                {
                    case 1:
                        if (TinhTrangSD)
                        {
                            //Response.Redirect("/Personnal/PersonalIndex.aspx");
                            // cho phep gui don kien
                            DsHoSo.Visible = true;
                            TopDKNhanVB.Visible = false;
                        }
                        else
                            Response.Redirect("/Personnal/GuiDonKien.aspx");
                        break;
                    case 2:
                        if (TinhTrangSD)
                        {
                            //Response.Redirect("/Personnal/PersonalIndex.aspx");
                            DsHoSo.Visible = false;
                            TopDKNhanVB.Visible = true;
                        }
                        else
                            Response.Redirect("/Personnal/DangKyNhanVB.aspx");
                        break;
                }                
            }
        }
    }
}