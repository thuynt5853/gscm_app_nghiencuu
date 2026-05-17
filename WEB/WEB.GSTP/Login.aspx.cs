using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.DirectoryServices;
using System.Globalization;
using System.Linq;
using System.Threading;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.SYSTEM_LOG;
using System.Text.RegularExpressions;

namespace WEB.GSTP
{
    public partial class Login : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session.Clear();
                try
                {
                    List<DM_TRANGTINH> lstHT = dt.DM_TRANGTINH.Where(x => x.MATRANG == "hotrologingscm").ToList();
                    //if (lstHT.Count > 0)
                    //{
                    //    lsthotro.Text = lstHT[0].NOIDUNG;
                    //}
                }
                catch (Exception ex) { }
            }
        }
        protected void cmdLogIn_Click(object sender, ImageClickEventArgs e)
        {
            var OQUANTRI_MATKHAU = DataExtensions.FindById<QUANTRI_MATKHAU>(1);
            try
            {
                string user_name = txtUserName.Text.Trim().ToLower();
                if (user_name == "")
                {
                    lttMsg.Text = "Chưa nhập mã truy cập !";
                    txtUserName.Focus();
                    return;
                }

                if (string.IsNullOrEmpty(user_name))
                {
                    lttMsg.Text = "Chưa nhập mã truy cập !";
                    txtUserName.Focus();
                    return;
                }

                if (user_name.Length > 50)
                {
                    lttMsg.Text = "Tên đăng nhập không được quá 50 ký tự.";
                    txtUserName.Focus();
                    return;
                }

                if (!Regex.IsMatch(user_name, @"^[a-z0-9._@]+$")) // tùy theo yêu cầu tên người dùng
                {
                    lttMsg.Text = "Tên đăng nhập không hợp lệ.";
                    txtUserName.Focus();
                    return;
                }

                string strPass = Cls_Comon.MD5Encrypt(txtPass.Text);
                decimal HieuLuc = 1, IsAccDoMain = 1, IsNotAccDoMain = 0;
                List<QT_NGUOISUDUNG> lst = null;
                QT_NGUOISUDUNG oT = null;

                var OLogAccessFail = SYSTEM_LOG_ACCESS.GetThongTinDangNhapTrongNgay<SYSTEM_LOG_ACCESS>(user_name, -1);
                DateTime? ThoiGian_DangNhap_Dung_GanNhat_TrongNgay = null;
                var OLogAccessPassed = SYSTEM_LOG_ACCESS.GetThongTinDangNhapTrongNgay<SYSTEM_LOG_ACCESS>(user_name, 1);
                if (OLogAccessPassed.Count > 0)
                {
                    ThoiGian_DangNhap_Dung_GanNhat_TrongNgay = OLogAccessPassed.FirstOrDefault().NGAYTAO;
                }
                if (chkIsDomain.Checked)//Sử dụng account domain
                {
                    lst = dt.QT_NGUOISUDUNG.Where(x => x.USERNAME.ToLower() == user_name
                                                && x.HIEULUC == HieuLuc
                                                && x.ISACCDOMAIN == IsAccDoMain).ToList<QT_NGUOISUDUNG>();
                    if (lst.Count == 0)
                    {
                        lttMsg.Text = "Mã truy cập hoặc mật khẩu không đúng !";
                        // Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Mã truy cập hoặc mật khẩu không đúng !");
                        txtUserName.Focus();
                        //AnhPN 
                        #region CheckPassword                       
                        if (OLogAccessFail != null)
                        {
                            if (OQUANTRI_MATKHAU != null && !string.IsNullOrEmpty(OQUANTRI_MATKHAU.SOLAN_NHAPSAI))
                            {
                                if (ThoiGian_DangNhap_Dung_GanNhat_TrongNgay != null)
                                {
                                    OLogAccessFail = OLogAccessFail.Where(o => o.NGAYTAO > ThoiGian_DangNhap_Dung_GanNhat_TrongNgay).ToList();
                                    if (OLogAccessFail.Count > 3 && OLogAccessFail.Count < int.Parse(OQUANTRI_MATKHAU.SOLAN_NHAPSAI))
                                    {
                                        ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Bạn đã nhập sai " + (OLogAccessFail.Count + 1) + " lần. Nếu quá " + OQUANTRI_MATKHAU.SOLAN_NHAPSAI + " lần tài khoản sẽ bị tạm khoá. Vui lòng liên hệ quản trị viên để được hướng dẫn!')", true);
                                        return;
                                    }
                                    if (OLogAccessFail.Count > int.Parse(OQUANTRI_MATKHAU.SOLAN_NHAPSAI))
                                    {
                                        var Lockacc = dt.QT_NGUOISUDUNG.Where(x => x.USERNAME.ToLower() == user_name
                                                && x.HIEULUC == 1
                                                && x.ISACCDOMAIN == IsNotAccDoMain).ToList<QT_NGUOISUDUNG>();
                                        if (Lockacc.Count > 0)
                                        {
                                            oT = Lockacc[0];
                                            oT.HIEULUC = 0;
                                            dt.SaveChanges();
                                            ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Bạn đã đăng nhập sai quá " + OQUANTRI_MATKHAU.SOLAN_NHAPSAI + " lần. Tài khoản sẽ bị tạm khoá. Vui lòng liên hệ quản trị viên để được hướng dẫn!')", true);
                                            return;
                                        }
                                    }
                                }
                                else
                                {
                                    if (OLogAccessFail.Count > 3 && OLogAccessFail.Count < int.Parse(OQUANTRI_MATKHAU.SOLAN_NHAPSAI))
                                    {
                                        ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Bạn đã nhập sai " + (OLogAccessFail.Count + 1) + " lần. Nếu quá " + OQUANTRI_MATKHAU.SOLAN_NHAPSAI + " lần tài khoản sẽ bị tạm khoá. Vui lòng liên hệ quản trị viên để được hướng dẫn!')", true);
                                        return;
                                    }
                                    if (OLogAccessFail.Count > int.Parse(OQUANTRI_MATKHAU.SOLAN_NHAPSAI))
                                    {
                                        var Lockacc = dt.QT_NGUOISUDUNG.Where(x => x.USERNAME.ToLower() == user_name
                                                && x.HIEULUC == 1
                                                && x.ISACCDOMAIN == IsNotAccDoMain).ToList<QT_NGUOISUDUNG>();
                                        if (Lockacc.Count > 0)
                                        {
                                            oT = Lockacc[0];
                                            oT.HIEULUC = 0;
                                            dt.SaveChanges();
                                            ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Bạn đã đăng nhập sai quá " + OQUANTRI_MATKHAU.SOLAN_NHAPSAI + " lần. Tài khoản sẽ bị tạm khoá. Vui lòng liên hệ quản trị viên để được hướng dẫn!')", true);
                                            return;
                                        }
                                    }
                                }
                            }
                        }
                        #endregion
                        return;
                    }
                    bool status = IsAuthenticated(txtUserName.Text, txtPass.Text);
                    if (status)
                    {
                        oT = lst[0];
                    }
                    else
                    {
                        lttMsg.Text = "Mã truy cập hoặc mật khẩu không đúng !";
                        txtUserName.Focus();
                        //Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Mã truy cập hoặc mật khẩu không đúng !");
                        //AnhPN 
                        #region CheckPassword                       
                        if (OLogAccessFail != null)
                        {
                            if (OQUANTRI_MATKHAU != null && !string.IsNullOrEmpty(OQUANTRI_MATKHAU.SOLAN_NHAPSAI))
                            {
                                if (ThoiGian_DangNhap_Dung_GanNhat_TrongNgay != null)
                                {
                                    OLogAccessFail = OLogAccessFail.Where(o => o.NGAYTAO > ThoiGian_DangNhap_Dung_GanNhat_TrongNgay).ToList();
                                    if (OLogAccessFail.Count > 3 && OLogAccessFail.Count < int.Parse(OQUANTRI_MATKHAU.SOLAN_NHAPSAI))
                                    {
                                        ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Bạn đã nhập sai " + (OLogAccessFail.Count + 1) + " lần. Nếu quá " + OQUANTRI_MATKHAU.SOLAN_NHAPSAI + " lần tài khoản sẽ bị tạm khoá. Vui lòng liên hệ quản trị viên để được hướng dẫn!')", true);
                                        return;
                                    }
                                    if (OLogAccessFail.Count > int.Parse(OQUANTRI_MATKHAU.SOLAN_NHAPSAI))
                                    {
                                        var Lockacc = dt.QT_NGUOISUDUNG.Where(x => x.USERNAME.ToLower() == user_name
                                                && x.HIEULUC == 1
                                                && x.ISACCDOMAIN == IsNotAccDoMain).ToList<QT_NGUOISUDUNG>();
                                        if (Lockacc.Count > 0)
                                        {
                                            oT = Lockacc[0];
                                            oT.HIEULUC = 0;
                                            dt.SaveChanges();
                                            ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Bạn đã đăng nhập sai quá " + OQUANTRI_MATKHAU.SOLAN_NHAPSAI + " lần. Tài khoản sẽ bị tạm khoá. Vui lòng liên hệ quản trị viên để được hướng dẫn!')", true);
                                            return;
                                        }
                                    }
                                }
                                else
                                {
                                    if (OLogAccessFail.Count > 3 && OLogAccessFail.Count < int.Parse(OQUANTRI_MATKHAU.SOLAN_NHAPSAI))
                                    {
                                        ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Bạn đã nhập sai " + (OLogAccessFail.Count + 1) + " lần. Nếu quá " + OQUANTRI_MATKHAU.SOLAN_NHAPSAI + " lần tài khoản sẽ bị tạm khoá. Vui lòng liên hệ quản trị viên để được hướng dẫn!')", true);
                                        return;
                                    }
                                    if (OLogAccessFail.Count > int.Parse(OQUANTRI_MATKHAU.SOLAN_NHAPSAI))
                                    {
                                        var Lockacc = dt.QT_NGUOISUDUNG.Where(x => x.USERNAME.ToLower() == user_name
                                                && x.HIEULUC == 1
                                                && x.ISACCDOMAIN == IsNotAccDoMain).ToList<QT_NGUOISUDUNG>();
                                        if (Lockacc.Count > 0)
                                        {
                                            oT = Lockacc[0];
                                            oT.HIEULUC = 0;
                                            dt.SaveChanges();
                                            ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Bạn đã đăng nhập sai quá " + OQUANTRI_MATKHAU.SOLAN_NHAPSAI + " lần. Tài khoản sẽ bị tạm khoá. Vui lòng liên hệ quản trị viên để được hướng dẫn!')", true);
                                            return;
                                        }
                                    }
                                }
                            }
                        }
                        #endregion
                        return;
                    }
                }
                else //Không sử dụng account domain
                {
                    lst = dt.QT_NGUOISUDUNG.Where(x => x.USERNAME.ToLower() == user_name
                                                && x.HIEULUC == 0
                                                && x.ISACCDOMAIN == IsNotAccDoMain).ToList<QT_NGUOISUDUNG>();
                    if (lst.Count != 0)
                    {
                        ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Tài khoản này đã bị khoá. Vui lòng liên hệ quản trị viên để được hướng dẫn!')", true);
                        return;
                    }
                    lst = dt.QT_NGUOISUDUNG.Where(x => x.USERNAME.ToLower() == user_name
                                                && x.PASSWORD == strPass
                                                && x.HIEULUC == HieuLuc
                                                && x.ISACCDOMAIN == IsNotAccDoMain).ToList<QT_NGUOISUDUNG>();
                    if (lst.Count == 0)
                    {
                        lttMsg.Text = "Mã truy cập hoặc mật khẩu không đúng !";
                        txtUserName.Focus();

                        #region CheckPassword                       
                        if (OLogAccessFail != null)
                        {
                            if (OQUANTRI_MATKHAU != null && !string.IsNullOrEmpty(OQUANTRI_MATKHAU.SOLAN_NHAPSAI))
                            {
                                if (ThoiGian_DangNhap_Dung_GanNhat_TrongNgay != null)
                                {
                                    OLogAccessFail = OLogAccessFail.Where(o => o.NGAYTAO > ThoiGian_DangNhap_Dung_GanNhat_TrongNgay && o.PM_NOIBO == "QLTA").ToList();
                                    if (OLogAccessFail.Count > 3 && OLogAccessFail.Count < int.Parse(OQUANTRI_MATKHAU.SOLAN_NHAPSAI))
                                    {
                                        ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Bạn đã nhập sai " + (OLogAccessFail.Count + 1) + " lần. Nếu quá " + OQUANTRI_MATKHAU.SOLAN_NHAPSAI + " lần tài khoản sẽ bị tạm khoá. Vui lòng liên hệ quản trị viên để được hướng dẫn!')", true);
                                        return;
                                    }
                                    if (OLogAccessFail.Count > int.Parse(OQUANTRI_MATKHAU.SOLAN_NHAPSAI))
                                    {
                                        var Lockacc = dt.QT_NGUOISUDUNG.Where(x => x.USERNAME.ToLower() == user_name
                                                && x.HIEULUC == 1
                                                && x.ISACCDOMAIN == IsNotAccDoMain).ToList<QT_NGUOISUDUNG>();
                                        if (Lockacc.Count > 0)
                                        {
                                            oT = Lockacc[0];
                                            oT.HIEULUC = 0;
                                            dt.SaveChanges();
                                            ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Bạn đã đăng nhập sai quá " + OQUANTRI_MATKHAU.SOLAN_NHAPSAI + " lần. Tài khoản sẽ bị tạm khoá. Vui lòng liên hệ quản trị viên để được hướng dẫn!')", true);
                                            return;
                                        }
                                    }
                                }
                                else
                                {
                                    if (OLogAccessFail.Count > 3 && OLogAccessFail.Count < int.Parse(OQUANTRI_MATKHAU.SOLAN_NHAPSAI))
                                    {
                                        ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Bạn đã nhập sai " + (OLogAccessFail.Count + 1) + " lần. Nếu quá " + OQUANTRI_MATKHAU.SOLAN_NHAPSAI + " lần tài khoản sẽ bị tạm khoá. Vui lòng liên hệ quản trị viên để được hướng dẫn!')", true);
                                        return;
                                    }
                                    if (OLogAccessFail.Count > int.Parse(OQUANTRI_MATKHAU.SOLAN_NHAPSAI))
                                    {
                                        var Lockacc = dt.QT_NGUOISUDUNG.Where(x => x.USERNAME.ToLower() == user_name
                                                && x.HIEULUC == 1
                                                && x.ISACCDOMAIN == IsNotAccDoMain).ToList<QT_NGUOISUDUNG>();
                                        if (Lockacc.Count > 0)
                                        {
                                            oT = Lockacc[0];
                                            oT.HIEULUC = 0;
                                            dt.SaveChanges();
                                            ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Bạn đã đăng nhập sai quá " + OQUANTRI_MATKHAU.SOLAN_NHAPSAI + " lần. Tài khoản sẽ bị tạm khoá. Vui lòng liên hệ quản trị viên để được hướng dẫn!')", true);
                                            return;
                                        }
                                    }
                                }
                            }
                        }
                        #endregion
                        return;
                    }
                    else
                    {
                        oT = lst[0];
                    }
                }
                if (oT != null)
                {
                    Session[ENUM_SESSION.SESSION_USERID] = oT.ID;
                    Session[ENUM_SESSION.SESSION_NHOMNSDID] = oT.NHOMNSDID;
                    Session[ENUM_SESSION.SESSION_USERNAME] = oT.USERNAME;
                    Session[ENUM_SESSION.SESSION_DONVIID] = oT.DONVIID;
                    Session[ENUM_SESSION.SESSION_USERTEN] = oT.HOTEN;
                    Session[ENUM_SESSION.SESSION_LOAIUSER] = oT.LOAIUSER;
                    Session[ENUM_SESSION.SESSION_MACANBO] = oT.MACANBO;
                    Session[ENUM_SESSION.SESSION_CANBOID] = oT.CANBOID;
                    Session[ENUM_SESSION.SESSION_PHONGBANID] = oT.PHONGBANID;
                    Session[ENUM_LOAIAN.AN_HINHSU] = oT.IDAHINHSU;
                    Session[ENUM_LOAIAN.AN_DANSU] = oT.IDANDANSU;
                    Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] = oT.IDANKDTM;
                    Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] = oT.IDANHNGD;
                    Session[ENUM_LOAIAN.AN_LAODONG] = oT.IDANLAODONG;
                    Session[ENUM_LOAIAN.AN_HANHCHINH] = oT.IDANHANHCHINH;
                    Session[ENUM_LOAIAN.AN_PHASAN] = oT.IDANPHASAN;
                    Session[ENUM_LOAIAN.BPXLHC] = oT.IDBPXLHC;
                    Session[ENUM_LOAIAN.AN_GDTTT] = oT.IDGDTTT;
                    Session[ENUM_LOAIAN.AN_THA] = oT.IDTHA;
                    DM_TOAAN oTA = dt.DM_TOAAN.Where(x => x.ID == oT.DONVIID).FirstOrDefault();
                    Session[ENUM_SESSION.SESSION_MADONVI] = oTA.MA;
                    Session[ENUM_SESSION.SESSION_TENDONVI] = oTA.TEN;
                    Session["CAP_XET_XU"] = oTA.LOAITOA;
                    Session[ENUM_SESSION.SESSION_ISPHANLOAIDON] = (String.IsNullOrEmpty(oT.ISPHANLOAIDON + "")) ? 0 : Convert.ToInt16(oT.ISPHANLOAIDON.ToString());
                    if (oTA.HANHCHINHID != null)
                    {
                        DM_HANHCHINH oHC = dt.DM_HANHCHINH.Where(x => x.ID == oTA.HANHCHINHID).FirstOrDefault();
                        try
                        {
                            if (oHC.LOAI == 2)
                            {
                                Session[ENUM_SESSION.SESSION_TINH_ID] = oHC.CAPCHAID;
                                Session[ENUM_SESSION.SESSION_QUAN_ID] = oHC.ID;
                            }
                            else
                            {
                                Session[ENUM_SESSION.SESSION_TINH_ID] = oHC.ID;
                                Session[ENUM_SESSION.SESSION_QUAN_ID] = 0;
                            }
                        }
                        catch (Exception ex)
                        {
                            Session[ENUM_SESSION.SESSION_TINH_ID] = 0;
                            Session[ENUM_SESSION.SESSION_QUAN_ID] = 0;
                        }
                    }
                    else
                    {
                        Session[ENUM_SESSION.SESSION_TINH_ID] = 0;
                        Session[ENUM_SESSION.SESSION_QUAN_ID] = 0;
                    }

                    CultureInfo ci = new CultureInfo("vi-VN");
                    Thread.CurrentThread.CurrentCulture = ci;
                    Thread.CurrentThread.CurrentUICulture = ci;
                    try
                    {
                        //Số người online
                        int so = int.Parse(Application.Get("OnlineNow").ToString());
                        so++;
                        Application.Set("OnlineNow", so);
                        //Lượt truy cập
                        List<QT_THONGSO> lstLTC = dt.QT_THONGSO.ToList();
                        QT_THONGSO objLTC;
                        if (lstLTC.Count > 0)
                        {
                            objLTC = lstLTC[0];
                            if (objLTC.LUOTTRUYCAP != null) objLTC.LUOTTRUYCAP += 1;
                            else objLTC.LUOTTRUYCAP = 1;
                        }
                        else
                        {
                            objLTC = new QT_THONGSO();
                            objLTC.LUOTTRUYCAP = 1;
                            dt.QT_THONGSO.Add(objLTC);
                        }
                        dt.SaveChanges();
                    }
                    catch (Exception ex) { }
                    Response.Redirect("Launcher.aspx");
                }
            }
            catch (Exception ex)
            {
                lttMsg.Text = ex.ToString();
            }
            finally
            {
                SYSTEM_LOG_ACCESS log = new SYSTEM_LOG_ACCESS();
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
        public bool IsAuthenticated(string usr, string pwd)
        {
            bool authenticated = false;
            string srvr = global::System.Configuration.ConfigurationManager.AppSettings["LDAPSVR"] + "";
            try
            {
                DirectoryEntry entry = new DirectoryEntry(srvr, usr, pwd);
                object nativeObject = entry.NativeObject;
                authenticated = true;
            }
            catch (DirectoryServicesCOMException cex)
            {
                //not authenticated; reason why is in cex
            }
            catch (Exception ex)
            {
                //not authenticated due to some other exception [this is optional]
            }
            return authenticated;
        }
        protected void CapNhat_Click(object sender, EventArgs e)
        {
            Response.Redirect(Cls_Comon.GetRootURL() + "/ChangePass.aspx");
        }
        protected void btnThoat_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect(Cls_Comon.GetRootURL() + "/Login.aspx");
        }
    }
}