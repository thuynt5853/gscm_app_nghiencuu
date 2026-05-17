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
using System.Text.RegularExpressions;
using BL.GSTP.BANGSETGET;

namespace WEB.GSTP.Quantri.Nguoidung
{
    public partial class Capnhat : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCombobox();
                string strID = Request["CID"] + "";
                if (strID != "")
                {
                    QT_NGUOIDUNG_BL oBL = new QT_NGUOIDUNG_BL();
                    QT_NGUOISUDUNG oT = oBL.GetByID(Convert.ToDecimal(strID));
                    if (oT == null) return;
                    ddlDonvi.SelectedValue = oT.DONVIID.ToString();
                    txtUsername.Text = oT.USERNAME;

                    chkHieuluc.Checked = oT.HIEULUC == 1 ? true : false;
                    chkIsPhanloaidon.Checked = oT.ISPHANLOAIDON == 1 ? true : false;
                    txtDienthoai.Text = oT.DIENTHOAI;
                    txtEmail.Text = oT.EMAIL;
                    txtGhichu.Text = oT.GHICHU;
                    chkIsDomain.Checked = oT.ISACCDOMAIN == 1 ? true : false;
                    ddlLoaiNhom.SelectedValue = oT.LOAIUSER.ToString();
                    LoadNhomquyen(Convert.ToDecimal(ddlDonvi.SelectedValue));
                    LoadPhongban(Convert.ToDecimal(ddlDonvi.SelectedValue));
                    if (oT.NHOMNSDID != null)
                        ddlNhomquyen.SelectedValue = oT.NHOMNSDID.ToString();
                    else
                        ddlNhomquyen.SelectedValue = "0";
                    //-----------------------
                    if (oT.PHONGBANID != null)
                        ddlPhongban.SelectedValue = oT.PHONGBANID.ToString();
                    else
                        ddlPhongban.SelectedValue = "0";
                    //-----------------
                    LoadPhongban_sub(Convert.ToDecimal(ddlDonvi.SelectedValue));
                    if (oT.PHONGBANID_SUB != null)
                        ddlPhongban_sub.SelectedValue = oT.PHONGBANID_SUB.ToString();
                    else
                        ddlPhongban_sub.SelectedValue = "0";
                    //--------------------
                    txtPass.Enabled = false; txtRePass.Enabled = false;

                    LoadCanbo(Convert.ToDecimal(ddlDonvi.SelectedValue), Convert.ToDecimal(ddlPhongban.SelectedValue));
                    if (oT.CANBOID != null)
                        ddlCanbo.SelectedValue = oT.CANBOID.ToString();
                    hddID.Value = oT.ID.ToString();

                    txtUsername.Enabled = false;
                }
                else {
                    txtUsername.Enabled = true;
                }
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
            }
        }
        private void LoadCanbo(decimal DonviID, decimal PhongBanID)
        {
            //Load cán bộ
            decimal PhongBanID_sub = 0;
            if(ddlPhongban_sub.SelectedValue!="0")
            {
                PhongBanID_sub = Convert.ToDecimal(ddlPhongban_sub.SelectedValue);
            }
            ddlCanbo.Items.Clear();
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI_PHONGBAN(DonviID, PhongBanID, PhongBanID_sub);
            ddlCanbo.DataSource = oCBDT;
            ddlCanbo.DataTextField = "MA_TEN";
            ddlCanbo.DataValueField = "ID";
            ddlCanbo.DataBind();
            ddlCanbo.Items.Insert(0, new ListItem("--Chọn cán bộ--", "0"));

        }
        private void LoadCombobox()
        {
            string strDonViID = Session["DonViID"] + "";
            if (strDonViID != "")
            {
                decimal DonViID = Convert.ToDecimal(strDonViID);
                DM_TOAAN oT = dt.DM_TOAAN.Where(x => x.ID == DonViID).FirstOrDefault();
                if (oT.LOAITOA == "CAPCAO")
                {
                    ddlDonvi.Items.Insert(0, new ListItem(oT.TEN, oT.ID.ToString()));
                }
                else
                {
                    DM_TOAAN_BL oBL = new DM_TOAAN_BL();
                    ddlDonvi.DataSource = oBL.DM_TOAAN_GETBY(DonViID);
                    ddlDonvi.DataTextField = "arrTEN";
                    ddlDonvi.DataValueField = "ID";
                    ddlDonvi.DataBind();
                }
            }
            string strLoaiUser = Session["LoaiUser"] + "";

            ddlLoaiNhom.Items.Clear();
            ddlLoaiNhom.Items.Add(new ListItem("Mặc định", "0"));
            if (strLoaiUser == "2")
            {
                ddlLoaiNhom.Items.Add(new ListItem("Quản trị đơn vị", "1"));
                ddlLoaiNhom.Items.Add(new ListItem("Quản trị hệ thống", "2"));
            }
            LoadNhomquyen(Convert.ToDecimal(strDonViID));
            LoadPhongban(Convert.ToDecimal(strDonViID));
            LoadPhongban_sub(Convert.ToDecimal(strDonViID));
            LoadCanbo(Convert.ToDecimal(strDonViID),Convert.ToDecimal(ddlPhongban.SelectedValue));
        }
        private void LoadPhongban(decimal DonViID)
        {
            ddlPhongban.Items.Clear();
            decimal VTOAANID = Convert.ToDecimal(ddlDonvi.SelectedValue);
            DM_TOAAN obta = dt.DM_TOAAN.Where(x => x.ID == VTOAANID).FirstOrDefault<DM_TOAAN>();
            if (obta.LOAITOA == "CAPTINH")
            {
                ddlPhongban.DataSource = dt.DM_PHONGBAN.Where(x => x.TOAANID == null && x.CAPCHAID == 0 && x.HIEULUC == 1).ToList();
                //List<DM_PHONGBAN> ilspb=dt.DM_PHONGBAN.Where(x => x.TOAANID == null && x.CAPCHAID == 0 && x.HIEULUC == 1).ToList();
            }
            else
            {
                 ddlPhongban.DataSource = dt.DM_PHONGBAN.Where(x => x.TOAANID == DonViID && x.CAPCHAID == 0 && x.HIEULUC == 1).ToList();
            }
            ddlPhongban.DataTextField = "TENPHONGBAN";
            ddlPhongban.DataValueField = "ID";
            ddlPhongban.DataBind();
            ddlPhongban.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
        }
        private void LoadPhongban_sub(decimal DonViID)
        {
            decimal V_CAPCHAID = 0;
            ddlPhongban_sub.Items.Clear();
            if (ddlPhongban.SelectedValue != "0")
            {
                V_CAPCHAID = Convert.ToDecimal(ddlPhongban.SelectedValue);
                ddlPhongban_sub.DataSource = dt.DM_PHONGBAN.Where(x => x.TOAANID == DonViID && x.CAPCHAID == V_CAPCHAID).ToList();
                ddlPhongban_sub.DataTextField = "TENPHONGBAN";
                ddlPhongban_sub.DataValueField = "ID";
                ddlPhongban_sub.DataBind();
                ddlPhongban_sub.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
            }
            else
            {
                ddlPhongban_sub.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
            }
        }
        private void LoadNhomquyen(decimal DonViID)
        {
            ddlNhomquyen.Items.Clear();
            DM_TOAAN oTA = dt.DM_TOAAN.Where(x => x.ID == DonViID).FirstOrDefault();
            QT_NHOMNGUOIDUNG_BL bl = new QT_NHOMNGUOIDUNG_BL();
            ddlNhomquyen.DataSource = dt.QT_NHOMNGUOIDUNG.Where(x => x.LOAITOA == oTA.LOAITOA).ToList();
            ddlNhomquyen.DataTextField = "TEN";
            ddlNhomquyen.DataValueField = "ID";
            ddlNhomquyen.DataBind();
            ddlNhomquyen.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                lbthongbao.Text = "";
                if (txtUsername.Text.Trim() == "")
                {
                    lbthongbao.Text = "User name không được để trống !";
                    return;
                }
                if (ddlNhomquyen.SelectedIndex == 0)
                {
                    lbthongbao.Text = "Chưa chọn nhóm quyền !";
                    return;
                }
                QT_NGUOIDUNG_BL oBL = new QT_NGUOIDUNG_BL();
                List<QT_NGUOISUDUNG> lstnguoidung = oBL.GetByUserName(txtUsername.Text.Trim());
                // string strID = Request["CID"] + "";

                if (hddID.Value == "" || hddID.Value == "0")
                {
                    if (lstnguoidung.Count > 0)
                    {
                        lbthongbao.Text = "Tên đăng nhập đã tồn tại!";
                        txtUsername.Focus();
                        return;
                    }
                    if (chkIsDomain.Checked == false)
                    {
                        //Kiểm tra mật khẩu
                        if (txtPass.Text.Length < 6)
                        {
                            lbthongbao.Text = "Mật khẩu chưa hợp lệ !";
                            txtPass.Focus();
                            return;
                        }
                        if (txtPass.Text != txtRePass.Text)
                        {
                            lbthongbao.Text = "Nhập lại mật khẩu chưa đúng !";
                            txtRePass.Focus();
                            return;
                        }
                        //anhpn
                        #region Check password
                        var OQUANTRI_MATKHAU = DataExtensions.FindById<QUANTRI_MATKHAU>(1);
                        if (OQUANTRI_MATKHAU != null)
                        {
                            //if (OQUANTRI_MATKHAU.KHONG_TRUNG_MK_CU == 1 && lstnguoidung.PASSWORD == Cls_Comon.MD5Encrypt(txtPass.Text))
                            //{
                            //    lbthongbao.Text = "Mật khẩu mới không được trùng mật khẩu cũ !";
                            //    return;
                            //}
                            if (!string.IsNullOrEmpty(OQUANTRI_MATKHAU.DO_DAI_TOI_THIEU) && txtPass.Text.Length < int.Parse(OQUANTRI_MATKHAU.DO_DAI_TOI_THIEU))
                            {
                                lbthongbao.Text = "Mật khẩu phải có tối thiểu " + OQUANTRI_MATKHAU.DO_DAI_TOI_THIEU + " ký tự!";
                                return;
                            }
                            var hasNumber = new Regex(@"[0-9]+");
                            var hasUpperChar = new Regex(@"[A-Z]+");
                            var hasLowerChar = new Regex(@"[a-z]+");
                            var hasSymbols = new Regex(@"[!@#$%^&*()_+=\[{\]};:<>|./?,-]");

                            if (OQUANTRI_MATKHAU.CHU_THUONG == 1 && !hasLowerChar.IsMatch(txtPass.Text))
                            {
                                lbthongbao.Text = "Mật khẩu phải có tối thiểu 01 ký tự thường!";
                                return;
                            }
                            else if (OQUANTRI_MATKHAU.CHU_HOA == 1 && !hasUpperChar.IsMatch(txtPass.Text))
                            {
                                lbthongbao.Text = "Mật khẩu phải có tối thiểu 01 ký tự in hoa!";
                                return;
                            }
                            else if (OQUANTRI_MATKHAU.CO_SO == 1 && !hasNumber.IsMatch(txtPass.Text))
                            {
                                lbthongbao.Text = "Mật khẩu phải có tối thiểu 01 ký tự số!";
                                return;
                            }
                            else if (!hasSymbols.IsMatch(txtPass.Text))
                            {
                                lbthongbao.Text = "Mật khẩu phải có tối thiểu 01 ký tự đặc biệt!";
                                return;
                            }
                            if (OQUANTRI_MATKHAU.CHUA_TEN_TAI_KHOAN == 1 && (txtPass.Text.ToLower()).Contains(txtUsername.Text.ToLower()))
                            {
                                lbthongbao.Text += "Mật khẩu không được chứa tên tài khoản !";
                                return;
                            }
                            var dllcanbo = Convert.ToDecimal(ddlCanbo.SelectedValue);
                            var OCanBo = dt.DM_CANBO.Where(x => x.ID == dllcanbo).FirstOrDefault();
                            if (OCanBo == null)
                            {
                                lbthongbao.Text += "Tài khoản đang không gắn với người sử dụng. Vui lòng liên hệ Quản trị viên để được hỗ trợ !";
                                return;
                            }
                            if (!string.IsNullOrEmpty(OCanBo.SODIENTHOAI))
                            {
                                var strSODIENTHOAI = OCanBo.SODIENTHOAI.Replace(" ", "");
                                if (OQUANTRI_MATKHAU.CHUA_SDT == 1 && txtPass.Text.Contains(strSODIENTHOAI))
                                {
                                    lbthongbao.Text = "Mật khẩu không được chứa số điện thoại !";
                                    return;
                                }
                            }
                            if (OQUANTRI_MATKHAU.CHUA_NAMSINH == 1 && OCanBo.NGAYSINH != null)
                            {
                                var StrNgaySinh = OCanBo.NGAYSINH.Value.ToString("ddMMyyyy");
                                var StrNgaySinh2 = OCanBo.NGAYSINH.Value.ToString("ddMMyy");
                                if (txtPass.Text.Contains(StrNgaySinh) || txtPass.Text.Contains(StrNgaySinh2))
                                {
                                    lbthongbao.Text = "Mật khẩu không được chứa ngày/tháng/năm sinh !";
                                    return;
                                }
                            }
                            var hoten = OCanBo.HOTEN.Split(' ').ToArray();
                            var str = ConvertToUnSign(hoten[hoten.Count() - 1]);
                            var strlower = str.ToLower();
                            if (OQUANTRI_MATKHAU.CHUA_TEN_NGUOISD == 1 && (txtPass.Text.Contains(str) || txtPass.Text.Contains(strlower)))
                            {
                                lbthongbao.Text += "Mật khẩu không được chứa tên người sử dụng!";
                                return;
                            }
                        }
                        #endregion
                    }
                    string strPass = Cls_Comon.MD5Encrypt(txtPass.Text);

                    QT_NGUOISUDUNG oT = new QT_NGUOISUDUNG();
                    oT.DONVIID = Convert.ToDecimal(ddlDonvi.SelectedValue);
                    oT.USERNAME = txtUsername.Text;
                    oT.PASSWORD = strPass;
                    oT.HOTEN = ddlCanbo.SelectedItem.Text;
                    oT.HIEULUC = chkHieuluc.Checked ? 1 : 0;
                    oT.ISPHANLOAIDON = chkIsPhanloaidon.Checked ? 1 : 0;
                    oT.DIENTHOAI = txtDienthoai.Text;
                    oT.EMAIL = txtEmail.Text;
                    oT.GHICHU = txtGhichu.Text;
                    oT.NHOMNSDID = Convert.ToDecimal(ddlNhomquyen.SelectedValue);
                    oT.PHONGBANID = Convert.ToDecimal(ddlPhongban.SelectedValue);
                    oT.PHONGBANID_SUB = Convert.ToDecimal(ddlPhongban_sub.SelectedValue);
                    oT.LOAIUSER = Convert.ToDecimal(ddlLoaiNhom.SelectedValue);
                    oT.ISACCDOMAIN = chkIsDomain.Checked ? 1 : 0;
                    oT.NGAYTAO = DateTime.Now;
                    oT.CANBOID = Convert.ToDecimal(ddlCanbo.SelectedValue);
                    oT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.QT_NGUOISUDUNG.Add(oT);
                    dt.SaveChanges();

                    var lst = dt.QT_NGUOISUDUNG.Where(x => x.USERNAME.ToLower() == txtUsername.Text
                                                && x.PASSWORD == strPass
                                                && x.HIEULUC == 1
                                                && x.ISACCDOMAIN == oT.ISACCDOMAIN).ToList<QT_NGUOISUDUNG>();

                    if (lst.Count > 0)
                    {
                        oT = lst[0];
                        var OBL = new VALIDATE_TAIKHOAN_BL();
                        //VALIDATE_TAIKHOAN checkvalidateTK = new VALIDATE_TAIKHOAN();
                        //checkvalidateTK.ID = oT.ID;
                        //checkvalidateTK.NGAY_THAY_DOI_MK = DateTime.Now;
                        //checkvalidateTK.MATKHAU_OLD = oT.PASSWORD;
                        //checkvalidateTK.NGUOI_DOI_MK = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        //DataExtensions.Insert<VALIDATE_TAIKHOAN>(checkvalidateTK);
                        //OBL.VALIDATE_TAIKHOAN_INSERT(checkvalidateTK);

                        var checkvalidatelog = new VALIDATE_TAIKHOAN_LOG();
                        checkvalidatelog.USER_ID = oT.ID;
                        checkvalidatelog.NGAY_THAY_DOI_MK = DateTime.Now;
                        checkvalidatelog.MATKHAU_OLD = oT.PASSWORD;
                        checkvalidatelog.NGUOI_DOI_MK = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        checkvalidatelog.NGUOI_DOI_MK_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                        DataExtensions.Insert<VALIDATE_TAIKHOAN_LOG>(checkvalidatelog);
                    }
                }
                else
                {
                    decimal ID = Convert.ToDecimal(hddID.Value);
                    QT_NGUOISUDUNG oT = dt.QT_NGUOISUDUNG.Where(x => x.ID == ID).FirstOrDefault();
                    if (lstnguoidung.Count >= 1 && oT.USERNAME.Trim().ToUpper() != txtUsername.Text.Trim().ToUpper())
                    {
                        lbthongbao.Text = "Tên đăng nhập đã tồn tại!";
                        txtUsername.Focus();
                        return;
                    }
                    
                    if (oT == null) return;
                    oT.DONVIID = Convert.ToDecimal(ddlDonvi.SelectedValue);
                    oT.USERNAME = txtUsername.Text;
                    oT.HOTEN = ddlCanbo.SelectedItem.Text;
                    oT.HIEULUC = chkHieuluc.Checked ? 1 : 0;
                    oT.ISPHANLOAIDON = chkIsPhanloaidon.Checked ? 1 : 0;
                    oT.DIENTHOAI = txtDienthoai.Text;
                    oT.EMAIL = txtEmail.Text;
                    oT.GHICHU = txtGhichu.Text;
                    oT.ISACCDOMAIN = chkIsDomain.Checked ? 1 : 0;
                    oT.NHOMNSDID = Convert.ToDecimal(ddlNhomquyen.SelectedValue);
                    oT.PHONGBANID = Convert.ToDecimal(ddlPhongban.SelectedValue);
                    oT.PHONGBANID_SUB = Convert.ToDecimal(ddlPhongban_sub.SelectedValue);
                    oT.LOAIUSER = Convert.ToDecimal(ddlLoaiNhom.SelectedValue);
                    oT.NGAYSUA = DateTime.Now;
                    oT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    oT.CANBOID = Convert.ToDecimal(ddlCanbo.SelectedValue);
                    dt.SaveChanges();
                }
                lbthongbao.Text = "Lưu thành công !";
                hddID.Value = "0";
                txtUsername.Text = txtPass.Text = txtRePass.Text = "";
                ddlCanbo.SelectedIndex = 0;
                txtDienthoai.Text = txtEmail.Text = txtGhichu.Text = "";
                //Response.Redirect("Danhsach.aspx");
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        public static string ConvertToUnSign(string text)
        {
            for (int i = 33; i < 48; i++)
            {
                text = text.Replace(((char)i).ToString(), "");
            }

            for (int i = 58; i < 65; i++)
            {
                text = text.Replace(((char)i).ToString(), "");
            }

            for (int i = 91; i < 97; i++)
            {
                text = text.Replace(((char)i).ToString(), "");
            }
            for (int i = 123; i < 127; i++)
            {
                text = text.Replace(((char)i).ToString(), "");
            }
            text = text.Replace(" ", "");
            Regex regex = new Regex(@"\p{IsCombiningDiacriticalMarks}+");
            string strFormD = text.Normalize(System.Text.NormalizationForm.FormD);
            return regex.Replace(strFormD, String.Empty).Replace('\u0111', 'd').Replace('\u0110', 'D');
        }

        protected void lblquaylai_Click(object sender, EventArgs e)
        {
            Response.Redirect("Danhsach.aspx");
        }
        protected void ddlDonvi_TextChanged(object sender, EventArgs e)
        {
            LoadNhomquyen(Convert.ToInt32(ddlDonvi.SelectedValue));
            LoadPhongban(Convert.ToDecimal(ddlDonvi.SelectedValue));
            LoadPhongban_sub(Convert.ToDecimal(ddlDonvi.SelectedValue));
            LoadCanbo(Convert.ToDecimal(ddlDonvi.SelectedValue), Convert.ToDecimal(ddlPhongban.SelectedValue));
        }
        protected void chkIsDomain_CheckedChanged(object sender, EventArgs e)
        {
            string strID = Request["CID"] + "";

            if (chkIsDomain.Checked)
            {
                txtPass.Enabled = false; txtRePass.Enabled = false;
            }
            else
            {
                if (strID == "") { txtPass.Enabled = true; txtRePass.Enabled = true; }
            }
        }
        protected void ddlPhongban_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadCanbo(Convert.ToDecimal(ddlDonvi.SelectedValue), Convert.ToDecimal(ddlPhongban.SelectedValue));
            LoadPhongban_sub(Convert.ToDecimal(ddlDonvi.SelectedValue));
        }
        protected void ddlPhongban_sub_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadCanbo(Convert.ToDecimal(ddlDonvi.SelectedValue), Convert.ToDecimal(ddlPhongban.SelectedValue));
        }
    }
}
