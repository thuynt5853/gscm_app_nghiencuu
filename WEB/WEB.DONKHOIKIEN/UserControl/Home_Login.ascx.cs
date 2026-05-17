using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DAL.DKK;
using BL.DonKK.DanhMuc;
using Module.Common;
using System.Data;
using BL.DonKK;
using System.Globalization;
using VGCA;
using System.Text;
using System.IO;
using System.Drawing;
using System.Drawing.Text;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;

namespace WEB.DONKHOIKIEN.UserControl
{
    public partial class Home_Login : System.Web.UI.UserControl
    {
        DKKContextContainer dt = new DKKContextContainer();
        public Decimal UserID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] +""))? 0:Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (UserID > 0)
            {
                pnLogin.Visible = false;
                pnHelp.Visible = false;
            }
            else
            {
                if (!IsPostBack)
                {
                    lttHeader.Text = "Đăng nhập";
                    pnLogin.Visible = true;
                    //Set AuthCode to Session-------------------------
                    Session.Add("AuthCode", WebAuth.GetAuthCode());
                    imCaptcha.ImageUrl = CaptchaImage("");
                }
            }
        }
        //cmdRefresh_Click
        protected void cmdRefresh_Click(object sender, EventArgs e)
        {
            imCaptcha.ImageUrl = CaptchaImage("");
        }
        protected void cmdSigOut_Click(object sender, EventArgs e)
        {
            String UserName = Session[ENUM_SESSION.SESSION_USERTEN] + "";
            UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");

            DONKK_USER_HISTORY_BL objBL = new DONKK_USER_HISTORY_BL();
            objBL.WriteLog(UserID, ENUM_HD_NGUOIDUNG_DKK.DANGXUAT, UserName + " - Đăng xuất");

            Session[ENUM_SESSION.SESSION_USERID] = "";
            Session[ENUM_SESSION.SESSION_USERNAME] ="";

            Session[ENUM_SESSION.SESSION_DONVIID] = "";
            Session[ENUM_SESSION.SESSION_LOAIUSER] = "";
            Session[ENUM_SESSION.SESSION_USERTEN] = "";
            Session[ENUM_SESSION.SESSION_TINH_ID] = "";
            Session[ENUM_SESSION.SESSION_QUAN_ID] = "";
            Session[ENUM_SESSION.SESSION_MUCDICHSD] = "";
            pnLogin.Visible = false;
        }
        public string CaptchaImage(string prefix, bool noisy = true)
        {
            var rand = new Random((int)DateTime.Now.Ticks);
            const string combination = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";

            var captcha = new StringBuilder();

            for (var i = 0; i < 6; i++)
                captcha.Append(combination[rand.Next(combination.Length)]);

            // Set encrypted captcha to session
            string captchaSessionName = string.IsNullOrWhiteSpace(prefix) ? "captcha" : prefix;
            Session[captchaSessionName] = captcha.ToString();

            //image stream
            string z;
            using (var mem = new MemoryStream())
            using (var bmp = new Bitmap(120, 50))
            using (var gfx = Graphics.FromImage(bmp))
            {
                gfx.TextRenderingHint = TextRenderingHint.ClearTypeGridFit;
                gfx.SmoothingMode = SmoothingMode.AntiAlias;
                gfx.FillRectangle(Brushes.White, new Rectangle(0, 0, bmp.Width, bmp.Height));

                //add noise
                if (noisy)
                {
                    int i;
                    var pen = new Pen(Color.Yellow);
                    for (i = 1; i < 10; i++)
                    {
                        pen.Color = Color.FromArgb(
                            rand.Next(0, 255),
                            rand.Next(0, 255),
                            rand.Next(0, 255));

                        var r = rand.Next(0, 120 / 3);
                        var x = rand.Next(0, 120);
                        var y = rand.Next(0, 50);

                        gfx.DrawEllipse(pen, x - r, y - r, r, r);
                    }
                }

                //add question
                gfx.DrawString(captcha.ToString(), new Font("Tahoma", 20), Brushes.Gray, 3, 6);

                //render as Jpeg
                bmp.Save(mem, ImageFormat.Jpeg);
                z = @"data:image/png;base64," + Convert.ToBase64String(mem.GetBuffer());
            }

            return z;
        }
        protected void cmdLogin_Click(object sender, EventArgs e)
        {           
            string msg = "";
            DONKK_USERS_BL objBL = new DONKK_USERS_BL();
            Decimal CurrUser = 0;
            String Email = txtUserName.Text.Trim().ToLower();
            string Pass = Cls_Comon.MD5Encrypt(txtPass.Text.Trim());
            if (Session["captcha"].ToString()!=txtCaptcha.Text)
            {
                txtCaptcha.Text = "";
                
                msg = "Mã xác thực không đúng, vui lòng nhập lại!";
                Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", msg);
                imCaptcha.ImageUrl = CaptchaImage("");
                return;
            }
            DataTable tbl = objBL.CheckLogin(Email, Pass);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                DataRow row = tbl.Rows[0];
                int trangthai = Convert.ToInt16(row["STATUS"] + "");
                CurrUser = (String.IsNullOrEmpty(row["ID"] + "")) ? 0 : Convert.ToDecimal(row["ID"] +"");

                switch (trangthai)
                {
                    case 0:
                        msg = "Tài khoản '" + Email + "' đang đợi phê duyệt, chưa được cấp phép sử dụng! Cám ơn!";
                        Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", msg);
                        break;
                    case 2:
                            Login(row);
                        break;
                    case 1:
                        msg = "Tài khoản '" + Email+"' đang bị khóa vì không được sử dụng hơn 6 tháng kể từ vụ việc cuối! Cám ơn!";
                        Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", msg);
                        break;
                    case 3:
                        Login(row);
                        break;
                }
            }
            else
            {
                msg = "Tài khoản truy cập không hợp lệ. Đề nghị kiểm tra lại!";
                imCaptcha.ImageUrl = CaptchaImage("");
                Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", msg);
                return;
            }
        }

        void Login(DataRow row)
        {
            UserID = Convert.ToDecimal(row["ID"] + "");
            Session[ENUM_SESSION.SESSION_USERID] = UserID;
            Session[ENUM_SESSION.SESSION_USERNAME] = row["EMAIL"] + "";

            //Session[ENUM_SESSION.SESSION_DONVIID] = obj.DONVIID;
            Session[ENUM_SESSION.SESSION_TINH_ID] = row["DIACHI_TINH_ID"] + "";
            Session[ENUM_SESSION.SESSION_QUAN_ID] = row["DIACHI_HUYEN_ID"] + "";
            Session[ENUM_SESSION.SESSION_LOAIUSER] = row["USERTYPE"] + "";
            Session[ENUM_SESSION.SESSION_MUCDICHSD] = row["MUCDICH_SD"] + "";
            string temp = (string.IsNullOrEmpty(row["NDD_HOTEN"] + "")) ? row["EMAIL"] + "" : row["NDD_HOTEN"] + "";
            int user_type = Convert.ToInt16(row["USERTYPE"] + "");
            if (user_type == 1)
                Session[ENUM_SESSION.SESSION_USERTEN] = temp;
            else
                Session[ENUM_SESSION.SESSION_USERTEN] = (string.IsNullOrEmpty(row["DN_TENVN"] + "")) ? temp : row["DN_TENVN"] + "";

            pnLogin.Visible = false;
            //---------------------
            pnLogin.Visible = false;
            lttHeader.Text = "Tài khoản";

            DONKK_USER_HISTORY_BL objLogBL = new DONKK_USER_HISTORY_BL();
            objLogBL.WriteLog(UserID, ENUM_HD_NGUOIDUNG_DKK.DANGNHAP, Session[ENUM_SESSION.SESSION_USERTEN].ToString() + " - Đăng nhập thành công");

            //------------------------
            int MucDichSD = Convert.ToInt32(row["MUCDICH_SD"]+"");
            DONKK_USERS_BL objUserBL = new DONKK_USERS_BL();
            Boolean TinhTrangSD = objUserBL.CheckIsUse(UserID, MucDichSD);
            switch(MucDichSD )
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

        //----------------------------
        //protected void cmdCheckChuKySo_Click(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        string authCode = Session["AuthCode"].ToString();
        //        string signature = Signature1.Value;
        //        WebAuth auth = new WebAuth(authCode, signature);
        //        if (auth.Validate())
        //        {
        //            string temp_email = auth.CertificateInfo.Email;
        //            txtUserName.Text = temp_email;
        //            txtUserName.Enabled = false;
        //            pnCTS.Visible = pnHelp.Visible = false;
        //            pnLogin.Visible = true;
        //        }
        //        else
        //        {
        //            string thongbao = "Thiết bị chứng thư số chưa được tích hợp vào máy tính hoặc VGCA Sign Service chưa được kích hoạt";
        //            Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", thongbao);
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        // Response.Write("Lỗi: " + ex.Message);
        //        string thongbao = "Thiết bị chứng thư số chưa được tích hợp vào máy tính hoặc VGCA Sign Service chưa được kích hoạt";
        //        Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", thongbao);
        //    }
        //}
    }
}