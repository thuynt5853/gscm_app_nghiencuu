using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.GDTTT.Hoso.Popup
{
    public partial class Kinhtrinh : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        Decimal CurrentUserID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrentUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrentUserID == 0)
                Response.Redirect("/Login.aspx");
            else
            {
                if (!IsPostBack)
                {
                    string strVID = Request["vid"] + "";
                    if (strVID != "")
                    {
                        decimal ID = Convert.ToDecimal(strVID);
                        GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();
                        txtNoidung.Text = oT.CHIDAO_KINHTRINH + "";
                    }
                }
            }
        }
        protected void cmdLuu_Click(object sender, EventArgs e)
        {
            string strVID = Request["vid"] + "";
            if (strVID != "")
            {
                decimal ID = Convert.ToDecimal(strVID);
                GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();
                oT.CHIDAO_KINHTRINH = txtNoidung.Text;
                dt.SaveChanges();
            }
            Cls_Comon.CallFunctionJS(this, this.GetType(), "window.close();");
        }
    }
}