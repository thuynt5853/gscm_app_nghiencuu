using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


using Module.Common;
using System.Globalization;

using DAL.DKK;
using BL.DonKK.DanhMuc;

namespace WEB.DONKHOIKIEN
{
    public partial class LostPass : System.Web.UI.Page
    {
        DKKContextContainer dt = new DKKContextContainer();
        public Decimal UserID = 0;
        CultureInfo cul = new CultureInfo("vi-VN");
        int SoLuongKyTu = 6;
        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "getIMG()", true);
        }
        protected void cmdRefreshCode_Click(object sender, ImageClickEventArgs e)
        {
            ScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "getIMG()", true);
        }

        protected void cmdSend_Click(object sender, EventArgs e)
        {
            if (txtMaCapCha.Text.Trim() != Convert.ToString(Cache[hddcapcha.Value]))
            {
                lbthongbao.Text = "<div class='msg_thongbao'>Chuỗi xác nhận không chính xác</div>";
                txtMaCapCha.Focus();
                return;
            }
            //--------------------------
            String email = txtEmail.Text.Trim();
            string cmnd = txtCMND.Text.Trim();

            DONKK_USERS obj = dt.DONKK_USERS.Where(x=>x.EMAIL == email
                                                   && x.NDD_CMND == cmnd).Single<DONKK_USERS>();
            if (obj != null )
            {                
                String new_pass = Cls_Comon.Randomnumber();
                obj.PASSWORD = Cls_Comon.MD5Encrypt(new_pass);
                obj.PASSWORDMODIFIEDDATE = DateTime.Now;
                dt.SaveChanges();

                Module.Common.Cls_SendMail.SendResetMatKhau(obj.EMAIL, obj.NDD_HOTEN, obj.EMAIL, new_pass);
                lbthongbao.Text = "Hệ thống đã gửi mật khẩu mới về địa chỉ email người dùng thành công!";
                pn.Visible = false;
            }
        }
    }
}