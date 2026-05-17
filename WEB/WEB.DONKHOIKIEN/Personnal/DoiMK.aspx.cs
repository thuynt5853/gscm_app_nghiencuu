using System;
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
    public partial class DoiMK : System.Web.UI.Page
    {
        Decimal UserID = 0;
        String Email = "";
        DKKContextContainer dt = new DKKContextContainer();
        protected void Page_Load(object sender, EventArgs e)
        {
            UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (UserID > 0)
            {
                Email = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                txtEMAIL.Text = Email;
            }
            else
                Response.Redirect( "/Trangchu.aspx");
        }
        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            //Check oldpass
            String OldPass = Cls_Comon.MD5Encrypt( txtOldPass.Text);
            Email = txtEMAIL.Text.Trim();
            DONKK_USERS obj = dt.DONKK_USERS.Where(x => x.EMAIL.ToLower() == Email
                                                            && x.PASSWORD == OldPass
                                                            && x.STATUS >= 1).Single<DONKK_USERS>();
            if (obj == null)
            {
                lbthongbao.Text = "<div class='msg_thongbao'>Mật khẩu cũ không đúng !</div>";
                return;
            }
            else
            {
                obj.PASSWORD = Cls_Comon.MD5Encrypt(txtPASSWORD.Text.Trim());
                obj.PASSWORDMODIFIEDDATE = DateTime.Now;
                
                dt.SaveChanges();

                txtOldPass.Text = txtPASSWORD.Text = txtREPASSWORD.Text = "";
                lbthongbao.Text = "<div class='msg_thongbao'>Mật khẩu được đổi thành công!</div>";
            }
        }
    }
}