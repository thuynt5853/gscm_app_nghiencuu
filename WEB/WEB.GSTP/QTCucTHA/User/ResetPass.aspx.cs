using DAL.GSTP;
using BL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

namespace WEB.GSTP.QTCucTHA.User
{
    public partial class ResetPass : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        protected void Page_Load(object sender, EventArgs e)
        {
          
            if (!IsPostBack)
            {
                CheckQuyen();
                decimal current_id = Convert.ToDecimal(Request["vID"] + "");
                hddID.Value = current_id.ToString();

                TUPHAP_NGUOISUDUNG oT = dt.TUPHAP_NGUOISUDUNG.Where(x => x.ID == current_id).FirstOrDefault();
                if (oT == null) return;
                txtUserName.Text = oT.USERNAME;
                if(oT.ISACCDOMAIN==1)
                {
                    txtPass.Enabled = txtRepass.Enabled=cmdSave.Enabled = false;
                    lttMsg.Text = "<div class='error_msg' style='color: red; '>Tài khoản domain không khởi tạo mật khẩu !</div>";
                }
            }
        }

        void CheckQuyen()
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdSave, oPer.CAPNHAT);
        }
        protected void cmdBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("Danhsach.aspx");
        }

        protected void cmdSave_Click(object sender, EventArgs e)
        {

            if (validateForm())
            {
               
                decimal current_id = Convert.ToDecimal(Request["vID"] + "");
                hddID.Value = current_id.ToString();
                TUPHAP_NGUOISUDUNG oT = dt.TUPHAP_NGUOISUDUNG.Where(x => x.ID == current_id).FirstOrDefault();
                oT.PASSWORD = Cls_Comon.MD5Encrypt(txtPass.Text);
                oT.NGAYSUA = DateTime.Now;
                oT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                dt.SaveChanges();
                Response.Redirect("Danhsach.aspx");
            }
        }
        Boolean validateForm()
        {
            bool val = true;
            if (txtPass.Text.Trim() == "")
            {
                lttMsg.Text = "<div class='error_msg'  style='color: red; '>Bạn chưa nhập mật khẩu !</div>";
                val = false;
            }
            else if (txtPass.Text.Length < 6)
            {
                lttMsg.Text = "<div class='error_msg'  style='color: red; '>Mật khẩu tối thiểu 6 ký tự !</div>";
                val = false;
            }
            else if (txtPass.Text.Length >= 100)
            {
                lttMsg.Text = "<div class='error_msg'  style='color: red; '>Mật khẩu nhập quá 100 ký tự !</div>";
                val = false;
            }
            else if (txtPass.Text != txtRepass.Text)
            {
                lttMsg.Text = "<div class='error_msg'  style='color: red; '>Nhập lại mật không chính xác !</div>";
                val = false;
            }
            return val;
        }

    }
}