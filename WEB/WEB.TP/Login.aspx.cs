
using System;
using System.Collections.Generic;
using System.DirectoryServices;
using System.Globalization;
using System.Linq;
using System.Threading;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using BL.GSTP;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.SYSTEM_LOG;
using DAL.GSTP;

using System.Text;
using System.IO;
using System.Drawing;
using System.Drawing.Text;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using Module.Common;

namespace WEB.TP
{
    public partial class Login : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session.Clear();
                //try
                //{
                //    List<DM_TRANGTINH> lstHT = dt.DM_TRANGTINH.Where(x => x.MATRANG == "hotrologingscm").ToList();
                //    if (lstHT.Count > 0)
                //    {
                //        lsthotro.Text = lstHT[0].NOIDUNG;
                //    }
                //}
                //catch (Exception ex) { }
                //imCaptcha.ImageUrl = CaptchaImage("");
                //MAXACTHUC1.Visible = false;
            }
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            //scriptManager.RegisterPostBackControl(this.cmdLogIn);
            scriptManager.RegisterPostBackControl(this.txtUserName);
        }
        //cmdRefresh_Click
        protected void cmdRefresh_Click(object sender, EventArgs e)
        {
            //imCaptcha.ImageUrl = CaptchaImage("");
        }
        public string CaptchaImage(string prefix, bool noisy = false)
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
            using (var bmp = new Bitmap(120, 40))
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
                        var y = rand.Next(0, 40);

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
        protected void txtUserName_TextChanged(object sender, EventArgs e)
        {

            CheckAccessCode(txtUserName.Text.Trim());
        }
        private void CheckAccessCode(string accessCode)
        {
            var OLogAccessFail = SYSTEM_LOG_ACCESS_ANPHI.GetThongTinDangNhapTrongNgay<SYSTEM_LOG_ACCESS_ANPHI>(accessCode, -1);
            DateTime? ThoiGian_DangNhap_Dung_GanNhat_TrongNgay = null;
            var OLogAccessPassed = SYSTEM_LOG_ACCESS_ANPHI.GetThongTinDangNhapTrongNgay<SYSTEM_LOG_ACCESS_ANPHI>(accessCode, 1);
            if (OLogAccessPassed.Count > 0)
            {
                ThoiGian_DangNhap_Dung_GanNhat_TrongNgay = OLogAccessPassed.FirstOrDefault().NGAYTAO;
            }
            string msg = "";
            if (string.IsNullOrEmpty(accessCode))
            {
                msg = "Tên tài khoản không được để trống.";
                Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", msg);
                txtUserName.Focus();
                return;
            }
            List<TUPHAP_NGUOISUDUNG> lst = null;
            lst = dt.TUPHAP_NGUOISUDUNG.Where(x => x.USERNAME.ToLower() == accessCode
                                        && x.HIEULUC == 0).ToList<TUPHAP_NGUOISUDUNG>();
            if (lst.Count != 0)
            {
                msg = "Tài khoản này đã bị khoá. Vui lòng liên hệ quản trị viên để được hướng dẫn!";
                Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", msg);
                txtUserName.Focus();
                return;
            }

            lst = dt.TUPHAP_NGUOISUDUNG.Where(x => x.USERNAME.ToLower() == accessCode).ToList<TUPHAP_NGUOISUDUNG>();
            if (lst.Count == 0)
            {
                msg = "Tài khoản này không tồn tại. Vui lòng liên hệ quản trị viên để được hướng dẫn!";
                Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", msg);
                txtUserName.Focus();
                return;
            }

            var oQUANTRI_MATKHAU_ANPHI = DataExtensions.FindById<QUANTRI_MATKHAU_ANPHI>(1);
            #region CheckPassword                       
            if (OLogAccessFail != null)
            {
                if (oQUANTRI_MATKHAU_ANPHI != null && !string.IsNullOrEmpty(oQUANTRI_MATKHAU_ANPHI.SOLAN_NHAPSAI))
                {
                    if (ThoiGian_DangNhap_Dung_GanNhat_TrongNgay != null)
                    {
                        OLogAccessFail = OLogAccessFail.Where(o => o.NGAYTAO > ThoiGian_DangNhap_Dung_GanNhat_TrongNgay).ToList();
                        if ((OLogAccessFail.Count) >= 3 && OLogAccessFail.Count <= int.Parse(oQUANTRI_MATKHAU_ANPHI.SOLAN_NHAPSAI))
                        {
                            msg = "Tài khoản " + accessCode + " đã nhập sai " + (OLogAccessFail.Count) + " lần. Nếu quá " + oQUANTRI_MATKHAU_ANPHI.SOLAN_NHAPSAI + " lần tài khoản sẽ bị tạm khoá. Vui lòng liên hệ quản trị viên để được hướng dẫn!";
                            Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", msg);
                            txtPass.Focus();
                            //MAXACTHUC1.Visible = true;
                            //imCaptcha.ImageUrl = CaptchaImage(""); // Show captcha label or any related elements
                            return;
                        }
                        else
                        {
                            //MAXACTHUC1.Visible = false;
                            txtPass.Focus();
                            return;
                        }
                    }
                    else
                    {
                        if (OLogAccessFail.Count >= 3 && OLogAccessFail.Count <= int.Parse(oQUANTRI_MATKHAU_ANPHI.SOLAN_NHAPSAI))
                        {
                            msg = "Tài khoản " + accessCode + " đã nhập sai " + (OLogAccessFail.Count) + " lần. Nếu quá " + oQUANTRI_MATKHAU_ANPHI.SOLAN_NHAPSAI + " lần tài khoản sẽ bị tạm khoá. Vui lòng liên hệ quản trị viên để được hướng dẫn!";
                            Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", msg);
                            txtPass.Focus();
                            //MAXACTHUC1.Visible = true;
                            //imCaptcha.ImageUrl = CaptchaImage(""); // Show captcha label or any related elements
                            return;
                        }
                        else
                        {
                            //MAXACTHUC1.Visible = false;
                            txtPass.Focus();
                            return;
                        }
                    }
                }
            }
            #endregion
        }
        protected void cmdLogIn_Click(object sender, ImageClickEventArgs e)
        {
            string msg = "";
            var oQUANTRI_MATKHAU_ANPHI = DataExtensions.FindById<QUANTRI_MATKHAU_ANPHI>(1);
            try
            {
                //cmdLogIn.Enabled = false;
                //cmdLogIn.Visible = false;
                if (txtUserName.Text.Trim() == "")
                {
                    //lttMsg.Text = "Chưa nhập mã truy cập !";
                    msg = "Chưa nhập mã truy cập !";
                    Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", msg);
                    return;
                }
                string strPass = Cls_Comon.MD5Encrypt(txtPass.Text);               
                string user_name = txtUserName.Text.Trim().ToLower();

                //if (Session["captcha"].ToString() != txtCaptcha.Text)
                //{
                //    txtCaptcha.Text = "";

                //    msg = "Mã xác thực không đúng, vui lòng nhập lại!";
                //    Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", msg);
                //    imCaptcha.ImageUrl = CaptchaImage("");
                //    return;
                //}

                List<TUPHAP_NGUOISUDUNG> lst = null;
                TUPHAP_NGUOISUDUNG oT = null;
                var OLogAccessFail = SYSTEM_LOG_ACCESS_ANPHI.GetThongTinDangNhapTrongNgay<SYSTEM_LOG_ACCESS_ANPHI>(user_name, -1);
                DateTime? ThoiGian_DangNhap_Dung_GanNhat_TrongNgay = null;
                var OLogAccessPassed = SYSTEM_LOG_ACCESS_ANPHI.GetThongTinDangNhapTrongNgay<SYSTEM_LOG_ACCESS_ANPHI>(user_name, 1);
                if (OLogAccessPassed.Count > 0)
                {
                    ThoiGian_DangNhap_Dung_GanNhat_TrongNgay = OLogAccessPassed.FirstOrDefault().NGAYTAO;
                }
                if (OLogAccessFail != null)
                {
                    if (oQUANTRI_MATKHAU_ANPHI != null && !string.IsNullOrEmpty(oQUANTRI_MATKHAU_ANPHI.SOLAN_NHAPSAI))
                    {
                        if (ThoiGian_DangNhap_Dung_GanNhat_TrongNgay != null)
                        {
                            OLogAccessFail = OLogAccessFail.Where(o => o.NGAYTAO > ThoiGian_DangNhap_Dung_GanNhat_TrongNgay).ToList();
                        }
                    }
                }
                lst = dt.TUPHAP_NGUOISUDUNG.Where(x => x.USERNAME.ToLower() == user_name
                                            && x.HIEULUC == 0).ToList<TUPHAP_NGUOISUDUNG>();
                if (lst.Count != 0)
                {
                    //ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Tài khoản này đã bị khoá. Vui lòng liên hệ quản trị viên để được hướng dẫn!')", true);
                    msg = "Tài khoản này đã bị khoá. Vui lòng liên hệ quản trị viên để được hướng dẫn!";
                    Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", msg);
                    return;
                }

                QT_TUPHAP_BL objBL = new QT_TUPHAP_BL();
                DataTable tbl = objBL.CheckLogin(user_name, strPass);
                if (tbl != null && tbl.Rows.Count>0)
                {
                    if (OLogAccessFail.Count >= 3)
                    {
                        //MAXACTHUC1.Visible = true;
                        //imCaptcha.ImageUrl = CaptchaImage(""); // Show captcha label or any related elements 
                        //if (Session["captcha"].ToString() != txtCaptcha.Text)
                        //{
                        //    txtCaptcha.Text = "";
                        //    msg = "Mã xác thực không đúng, vui lòng nhập lại!";
                        //    Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", msg);
                        //    txtCaptcha.Focus();
                        //    imCaptcha.ImageUrl = CaptchaImage("");
                        //    return;
                        //}
                    }
                    DataRow row = tbl.Rows[0];
                    LoginSuccess(row);
                    Save_log_access();

                    Response.Redirect("trangchu.aspx");
                }
                else
                {
                    #region CheckPassword                       
                    if (OLogAccessFail != null)
                    {
                        if (oQUANTRI_MATKHAU_ANPHI != null && !string.IsNullOrEmpty(oQUANTRI_MATKHAU_ANPHI.SOLAN_NHAPSAI))
                        {
                            if (ThoiGian_DangNhap_Dung_GanNhat_TrongNgay != null)
                            {
                                OLogAccessFail = OLogAccessFail.Where(o => o.NGAYTAO > ThoiGian_DangNhap_Dung_GanNhat_TrongNgay).ToList();
                                if ((OLogAccessFail.Count + 1) >= 3 && OLogAccessFail.Count + 1 <= int.Parse(oQUANTRI_MATKHAU_ANPHI.SOLAN_NHAPSAI))
                                {
                                    msg = "Bạn đã nhập sai " + (OLogAccessFail.Count + 1) + " lần. Nếu quá " + oQUANTRI_MATKHAU_ANPHI.SOLAN_NHAPSAI + " lần tài khoản sẽ bị tạm khoá. Vui lòng liên hệ quản trị viên để được hướng dẫn!";
                                    Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", msg);
                                    txtPass.Focus();
                                    //MAXACTHUC1.Visible = true;
                                    //imCaptcha.ImageUrl = CaptchaImage(""); // Show captcha label or any related elements
                                    Save_log_access();
                                    return;
                                }
                                //if ((OLogAccessFail.Count + 1) > 3 && OLogAccessFail.Count + 1 <= int.Parse(oQUANTRI_MATKHAU_ANPHI.SOLAN_NHAPSAI))
                                //{
                                //    if (Session["captcha"].ToString() != txtCaptcha.Text)
                                //    {
                                //        txtCaptcha.Text = "";
                                //        msg = "Mã xác thực không đúng, vui lòng nhập lại!";
                                //        Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", msg);
                                //        imCaptcha.ImageUrl = CaptchaImage("");
                                //        return;
                                //    }
                                //    msg = "Bạn đã nhập sai " + (OLogAccessFail.Count + 1) + " lần. Nếu quá " + oQUANTRI_MATKHAU_ANPHI.SOLAN_NHAPSAI + " lần tài khoản sẽ bị tạm khoá. Vui lòng liên hệ quản trị viên để được hướng dẫn!";
                                //    Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", msg);
                                //    MAXACTHUC1.Visible = true;
                                //    imCaptcha.ImageUrl = CaptchaImage(""); // Show captcha label or any related elements
                                //    Save_log_access();
                                //    return;
                                //}
                                if ((OLogAccessFail.Count + 1) > int.Parse(oQUANTRI_MATKHAU_ANPHI.SOLAN_NHAPSAI))
                                {
                                    var Lockacc = dt.TUPHAP_NGUOISUDUNG.Where(x => x.USERNAME.ToLower() == user_name
                                            && x.HIEULUC == 1).ToList<TUPHAP_NGUOISUDUNG>();
                                    if (Lockacc.Count > 0)
                                    {
                                        oT = Lockacc[0];
                                        oT.HIEULUC = 0;
                                        dt.SaveChanges();
                                        //ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Bạn đã đăng nhập sai quá " + oQUANTRI_MATKHAU_ANPHI.SOLAN_NHAPSAI + " lần. Tài khoản sẽ bị tạm khoá. Vui lòng liên hệ quản trị viên để được hướng dẫn!')", true);
                                        msg = "Bạn đã đăng nhập sai quá " + oQUANTRI_MATKHAU_ANPHI.SOLAN_NHAPSAI + " lần. Tài khoản sẽ bị tạm khoá. Vui lòng liên hệ quản trị viên để được hướng dẫn!";
                                        Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", msg);
                                        txtUserName.Focus();
                                        return;
                                    }
                                }
                            }
                            else
                            {
                                if ((OLogAccessFail.Count + 1) >= 3 && OLogAccessFail.Count + 1 <= int.Parse(oQUANTRI_MATKHAU_ANPHI.SOLAN_NHAPSAI))
                                {
                                    msg = "Bạn đã nhập sai " + (OLogAccessFail.Count + 1) + " lần. Nếu quá " + oQUANTRI_MATKHAU_ANPHI.SOLAN_NHAPSAI + " lần tài khoản sẽ bị tạm khoá. Vui lòng liên hệ quản trị viên để được hướng dẫn!";
                                    Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", msg);
                                    txtPass.Focus();
                                    //MAXACTHUC1.Visible = true;
                                    //imCaptcha.ImageUrl = CaptchaImage(""); // Show captcha label or any related elements 
                                    Save_log_access();
                                    return;
                                }
                                //if ((OLogAccessFail.Count + 1) > 3 && OLogAccessFail.Count + 1 <= int.Parse(oQUANTRI_MATKHAU_ANPHI.SOLAN_NHAPSAI))
                                //{
                                //    if (Session["captcha"].ToString() != txtCaptcha.Text)
                                //    {
                                //        txtCaptcha.Text = "";
                                //        msg = "Mã xác thực không đúng, vui lòng nhập lại!";
                                //        Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", msg);
                                //        imCaptcha.ImageUrl = CaptchaImage("");
                                //        return;
                                //    }
                                //    //ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Bạn đã nhập sai " + (OLogAccessFail.Count) + " lần. Nếu quá " + oQUANTRI_MATKHAU_ANPHI.SOLAN_NHAPSAI + " lần tài khoản sẽ bị tạm khoá. Vui lòng liên hệ quản trị viên để được hướng dẫn!')", true);
                                //    msg = "Bạn đã nhập sai " + (OLogAccessFail.Count + 1) + " lần. Nếu quá " + oQUANTRI_MATKHAU_ANPHI.SOLAN_NHAPSAI + " lần tài khoản sẽ bị tạm khoá. Vui lòng liên hệ quản trị viên để được hướng dẫn!";
                                //    Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", msg);
                                //    MAXACTHUC1.Visible = true;
                                //    imCaptcha.ImageUrl = CaptchaImage(""); // Show captcha label or any related elements 
                                //    Save_log_access();
                                //    return;
                                //}
                                if ((OLogAccessFail.Count + 1) > int.Parse(oQUANTRI_MATKHAU_ANPHI.SOLAN_NHAPSAI))
                                {
                                    var Lockacc = dt.TUPHAP_NGUOISUDUNG.Where(x => x.USERNAME.ToLower() == user_name
                                            && x.HIEULUC == 1).ToList<TUPHAP_NGUOISUDUNG>();
                                    if (Lockacc.Count > 0)
                                    {
                                        oT = Lockacc[0];
                                        oT.HIEULUC = 0;
                                        dt.SaveChanges();
                                        //ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Bạn đã đăng nhập sai quá " + oQUANTRI_MATKHAU_ANPHI.SOLAN_NHAPSAI + " lần. Tài khoản sẽ bị tạm khoá. Vui lòng liên hệ quản trị viên để được hướng dẫn!')", true);
                                        msg = "Bạn đã đăng nhập sai quá " + oQUANTRI_MATKHAU_ANPHI.SOLAN_NHAPSAI + " lần. Tài khoản sẽ bị tạm khoá. Vui lòng liên hệ quản trị viên để được hướng dẫn!";
                                        Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", msg);
                                        txtUserName.Focus();
                                        return;
                                    }
                                }
                            }
                        }
                    }
                    #endregion
                    //lttMsg.Text = "Mã truy cập hoặc mật khẩu không đúng !";
                    //Mã xác thực
                    //failedLoginAttempts++;
                    //if (failedLoginAttempts >= 3)
                    //{
                    //    imCaptcha.Visible = true; // Show captcha image 
                    //    txtCaptcha.Visible = true;
                    //    cmdRefresh.Visible = true;
                    //    imCaptcha.ImageUrl = CaptchaImage(""); // Show captcha label or any related elements 
                    //    if (Session["captcha"].ToString() != txtCaptcha.Text)
                    //    {
                    //        txtCaptcha.Text = "";
                    //        msg = "Mã xác thực không đúng, vui lòng nhập lại!";
                    //        Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", msg);
                    //        imCaptcha.ImageUrl = CaptchaImage("");
                    //        return;
                    //    }
                    //}
                    //End mã xác thực
                    msg = "Mật khẩu không đúng !";
                    Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", msg);
                    txtPass.Focus();
                    Save_log_access();
                    //cmdLogIn.Enabled = true;
                    //cmdLogIn.Visible = true;
                    return;
                }
            }
            catch (Exception ex)
            {
                lttMsg.Text = ex.ToString();
            }
            //finally
            //{
            //    Save_log_access();
            //}
        }
        void LoginSuccess(DataRow row)
        {
            Session[ENUM_SESSION.SESSION_USERID] = row["ID"];
            Session[ENUM_SESSION.SESSION_USERNAME] = row["USERNAME"];
            Session[ENUM_SESSION.SESSION_USERTEN] = row["HOTEN"];
            Session[ENUM_SESSION.SESSION_DONVIID] = row["DONVITHA_ID"];           
            Session[ENUM_SESSION.SESSION_TENDONVI] = row["MA_TEN"];
            Session["TEN_DV"] = row["TEN"];
            Session["LOAITOA"] = row["LOAITOA"];
            Session["CAP_CUC"] = row["CAP_CUC"];
            Session.Timeout = 120;
        }
        
        private void Save_log_access()
        {
            try
            {
                
            }
            catch (Exception ex)
            {
                lttMsg.Text = ex.ToString();
            }
            finally
            {
                SYSTEM_LOG_ACCESS_ANPHI log = new SYSTEM_LOG_ACCESS_ANPHI();
                if (Session[ENUM_SESSION.SESSION_USERNAME] != null)
                {
                    log.insertLogAccess(1, Session[ENUM_SESSION.SESSION_USERNAME].ToString());
                }
                else
                {
                    log.insertLogAccess(-1, txtUserName.Text);
                }
            }
        }
    }
}