using BL.GSTP;
using BL.GSTP.ALD;
using BL.GSTP.DLQGC06;
using DAL.GSTP;
using Module.Common;
using Module.Common.C06;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

namespace WEB.GSTP.QLAN.ALD.Hoso.Popup
{
    public partial class pDuongSuUpdate : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public decimal DonID = 0, DuongSuID = 0;
        private const decimal ROOT = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCombobox();
                DuongSuID = (String.IsNullOrEmpty(Request["dsID"] + "")) ? 0 : Convert.ToDecimal(Request["dsID"] + "");
                if (DuongSuID > 0)
                {
                    ALD_DON_DUONGSU oND = dt.ALD_DON_DUONGSU.Where(x => x.ID == DuongSuID).FirstOrDefault();

                    if (oND != null)
                    {
                        DonID = Convert.ToDecimal(oND.DONID);
                    }
                    loadedit(DuongSuID);
                    CheckQuyen(DonID);
                }

                hddid.Value = DuongSuID.ToString();
                if (hddid.Value == "" || hddid.Value == "0") SetTinhHuyenMacDinh();


            }
        }
        private void CheckQuyen(decimal DONID)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.UrlReferrer.AbsolutePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);

            //21-01-2026 check vụ án đã có bản án thì không cho lưu sửa
            bool daCoBanAn = dt.ALD_PHUCTHAM_BANAN.Any(x => x.DONID == DONID);
            if (daCoBanAn)
            {
                lbthongbao.Text = "Vụ việc đã có bản án, không được sửa đổi!";
                lbthongbao.Visible = true;
                Cls_Comon.SetButton(cmdUpdate, false);
            }


            //ALD_DON oT = dt.ALD_DON.Where(x => x.ID == DONID).FirstOrDefault();
            //if (oT != null)
            //{
            //    hdfNgayNhanDon.Value = oT.NGAYNHANDON + "" == "" ? "" : ((DateTime)oT.NGAYNHANDON).ToString("dd/MM/yyyy");
            //    if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
            //    {
            //        lbthongbao.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
            //        Cls_Comon.SetButton(cmdUpdate, false);
            //        return;
            //    }
            //}
            string StrMsg = "Không được sửa đổi thông tin.";
            string Result = new ALD_CHUYEN_NHAN_AN_BL().Check_NhanAn(DONID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            if (Result != "")
            {
                lbthongbao.Text = Result;
                Cls_Comon.SetButton(cmdUpdate, false);
                return;
            }
        }
        private void SetTinhHuyenMacDinh()
        {
            //Set defaul value Tinh/Huyen dua theo tai khoan dang nhap
            Cls_Comon.SetValueComboBox(ddlNoiSongTinh, Session[ENUM_SESSION.SESSION_TINH_ID]);
            LoadDropNoiSongHuyen();
            Cls_Comon.SetValueComboBox(ddlNoiSongHuyen, Session[ENUM_SESSION.SESSION_QUAN_ID]);

            Cls_Comon.SetValueComboBox(ddl_NDD_Tinh, Session[ENUM_SESSION.SESSION_TINH_ID]);
            LoadDrop_NDD_Huyen();
            Cls_Comon.SetValueComboBox(ddl_NDD_Huyen, Session[ENUM_SESSION.SESSION_QUAN_ID]);

        }

        private void LoadCombobox()
        {
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            //Load quốc tịch
            DataTable dtQuoctich = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.QUOCTICH);
            ddlND_Quoctich.DataSource = dtQuoctich;
            ddlND_Quoctich.DataTextField = "TEN";
            ddlND_Quoctich.DataValueField = "ID";
            ddlND_Quoctich.DataBind();

            ddlTucachTotung.DataSource = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.TUCACHTOTUNG_DS);
            ddlTucachTotung.DataTextField = "TEN";
            ddlTucachTotung.DataValueField = "MA";
            ddlTucachTotung.DataBind();

            LoadDropTinh();
        }
        private bool CheckValid()
        {
            if (hdfNgayNhanDon.Value == "")
            {
                lbthongbao.Text = "Bạn hãy lưu thông tin đơn trước khi thêm đương sự khác. Hãy kiểm tra lại.";
                return false;
            }
            DateTime dNgayNhan = DateTime.Parse(hdfNgayNhanDon.Value, cul, DateTimeStyles.NoCurrentDateDefault);
            if (txtTennguyendon.Text == "")
            {
                lbthongbao.Text = "Chưa nhập tên đương sự";
                txtTennguyendon.Focus();
                return false;
            }
            else if (txtTennguyendon.Text.Length > 250)
            {
                lbthongbao.Text = "Tên đương sự không nhập quá 250 ký tự.";
                txtTennguyendon.Focus();
                return false;
            }
            if (pnNDCanhan.Visible)// cá nhân
            {
                if (txtND_Ngaysinh.Text != "")
                {
                    if (Cls_Comon.IsValidDate(txtND_Ngaysinh.Text) == false)
                    {
                        lbthongbao.Text = "Bạn chưa nhập ngày sinh nguyên đơn theo định dạng dd/MM/yyyy. Hãy nhập lại.";
                        txtND_Ngaysinh.Focus();
                        return false;
                    }
                    DateTime NgaySinh_ND = DateTime.Parse(txtND_Ngaysinh.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                    if (NgaySinh_ND > DateTime.Now)
                    {
                        lbthongbao.Text = "Ngày sinh nguyên đơn không được lớn hơn ngày hiện tại. Hãy nhập lại.";
                        txtND_Ngaysinh.Focus();
                        return false;
                    }
                    if (NgaySinh_ND > dNgayNhan)
                    {
                        lbthongbao.Text = "Ngày sinh nguyên đơn không được lớn hơn ngày nhận đơn. Hãy nhập lại.";
                        txtND_Ngaysinh.Focus();
                        return false;
                    }
                }
                if (txtND_Namsinh.Text != "")
                {
                    if (txtND_Namsinh.Text.Trim().Length < 4)
                    {
                        lbthongbao.Text = "Năm sinh của nguyên đơn phải là số gồm 04 chữ số. Hãy kiểm tra lại.";
                        Cls_Comon.SetFocus(this, this.GetType(), txtND_Namsinh.ClientID);
                        return false;
                    }
                    int namsinh = Convert.ToInt32(txtND_Namsinh.Text);
                    if (namsinh == 0)
                    {
                        lbthongbao.Text = "Năm sinh của nguyên đơn phải lớn hơn 0. Hãy kiểm tra lại.";
                        Cls_Comon.SetFocus(this, this.GetType(), txtND_Namsinh.ClientID);
                        return false;
                    }
                    else if (namsinh > dNgayNhan.Year)
                    {
                        lbthongbao.Text = "Năm sinh của nguyên đơn không thể lớn hơn năm của ngày nhận đơn. Hãy kiểm tra lại!";
                        Cls_Comon.SetFocus(this, this.GetType(), txtND_Namsinh.ClientID);
                        return false;
                    }
                    else if (namsinh > DateTime.Now.Year)
                    {
                        lbthongbao.Text = "Năm sinh của nguyên đơn không thể lớn hơn năm hiện tại. Hãy kiểm tra lại!";
                        Cls_Comon.SetFocus(this, this.GetType(), txtND_Namsinh.ClientID);
                        return false;
                    }
                }

                if (txtNoiLamViec.Text.Trim().Length > 500)
                {
                    lbthongbao.Text = "Nơi làm việc của đương sự không nhập quá 500 ký tự.";
                    Cls_Comon.SetFocus(this, this.GetType(), txtNoiLamViec.ClientID);
                    return false;
                }
            }

            int lengthEmail_ND = txtEmail.Text.Trim().Length;
            if (lengthEmail_ND > 0)
            {
                if (lengthEmail_ND > 250)
                {
                    lbthongbao.Text = "Email không nhập quá 250 ký tự. Hãy nhập lại.";
                    Cls_Comon.SetFocus(this, this.GetType(), txtEmail.ClientID);
                    return false;
                }
                string email = txtEmail.Text.Trim();
                int atpos = email.IndexOf("@");
                var dotpos = email.LastIndexOf(".");
                if (atpos < 1 || dotpos < atpos + 2 || dotpos + 2 >= lengthEmail_ND)
                {
                    lbthongbao.Text = "Địa chỉ email chưa đúng.";
                    Cls_Comon.SetFocus(this, this.GetType(), txtEmail.ClientID);
                    return false;
                }
            }
            return true;
        }
        protected void txtND_Ngaysinh_TextChanged(object sender, EventArgs e)
        {
            if (txtND_Ngaysinh.Text != "")
            {
                if (Cls_Comon.IsValidDate(txtND_Ngaysinh.Text))
                {
                    DateTime NgaySinh_ND = DateTime.Parse(txtND_Ngaysinh.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                    txtND_Namsinh.Text = NgaySinh_ND.Year.ToString();

                }
            }
            else
            {
                if (txtND_Namsinh.Text != "" && txtND_Namsinh.Text.Length == 4)
                {
                    if (Cls_Comon.IsValidDate(hdfNgayNhanDon.Value))
                    {
                        string NgaySinhstr = "01/01/" + txtND_Namsinh.Text;
                        DateTime NgayNhan = DateTime.Parse(hdfNgayNhanDon.Value, cul, DateTimeStyles.NoCurrentDateDefault),
                                 NgaySinh_ND = DateTime.Parse(NgaySinhstr, cul, DateTimeStyles.NoCurrentDateDefault);

                    }
                }
            }
            txtND_Namsinh.Focus();
        }
        protected void txtND_Namsinh_TextChanged(object sender, EventArgs e)
        {
            if (txtND_Namsinh.Text.Length == 4)
            {
                string NgaySinhstr = "";
                if (txtND_Ngaysinh.Text == "")
                {
                    NgaySinhstr = "01/01/" + txtND_Namsinh.Text;
                }
                else
                {
                    if (Cls_Comon.IsValidDate(txtND_Ngaysinh.Text))
                    {
                        string[] arr = txtND_Ngaysinh.Text.Split('/');
                        NgaySinhstr = arr[0] + "/" + arr[1] + "/" + txtND_Namsinh.Text;
                        txtND_Ngaysinh.Text = NgaySinhstr;
                    }
                }
                if (NgaySinhstr != "" && Cls_Comon.IsValidDate(hdfNgayNhanDon.Value))
                {
                    DateTime NgayNhan = DateTime.Parse(hdfNgayNhanDon.Value, cul, DateTimeStyles.NoCurrentDateDefault),
                             NgaySinh_ND = DateTime.Parse(NgaySinhstr, cul, DateTimeStyles.NoCurrentDateDefault);
                    // txtND_Tuoi.Text = TinhTuoi(NgaySinh_ND, NgayNhan).ToString();
                }
            }
            chkONuocNgoai.Focus();
        }
        private int TinhTuoi(DateTime NgaySinh, DateTime NgayNhanDon)
        {
            try
            {
                int nam = NgayNhanDon.Year - NgaySinh.Year;
                if (nam > 0)
                {
                    int thang = NgayNhanDon.Month - NgaySinh.Month;
                    if (thang == 0)
                    {
                        int ngay = NgayNhanDon.Day - NgaySinh.Day;
                        if (ngay <= 0)
                        { nam = nam - 1; }
                    }
                    else if (thang < 0)
                    {
                        nam = nam - 1;
                    }
                }
                return nam;
            }
            catch { return 0; }
        }
        protected void ddlLoaiNguyendon_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlLoaiNguyendon.SelectedValue == "1")
            {
                pnNDCanhan.Visible = true;
                pnNDTochuc.Visible = false;
                chkISBVQLNK.Visible = false;
            }
            else
            {
                pnNDCanhan.Visible = false;
                pnNDTochuc.Visible = true;
                chkISBVQLNK.Visible = true;
            }
            Cls_Comon.SetFocus(this, this.GetType(), ddlTucachTotung.ClientID);
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                decimal ID = Convert.ToDecimal(hddid.Value);
                ALD_DON_DUONGSU oND = dt.ALD_DON_DUONGSU.Where(x => x.ID == ID).FirstOrDefault();
                oND.DONID = oND.DONID;
                oND.TENDUONGSU = Convert.ToDecimal(ddlLoaiNguyendon.SelectedValue) == 1 ? Cls_Comon.FormatTenRieng(txtTennguyendon.Text) : Cls_Comon.FormatTenTochuc(txtTennguyendon.Text);
                oND.ISDAIDIEN = oND.ISDAIDIEN;
                oND.TUCACHTOTUNG_MA = ddlTucachTotung.SelectedValue;
                if (chkISBVQLNK.Visible)
                    oND.ISBVQLNGUOIKHAC = chkISBVQLNK.Checked ? 1 : 0;
                else
                    oND.ISBVQLNGUOIKHAC = 0;
                oND.LOAIDUONGSU = Convert.ToDecimal(ddlLoaiNguyendon.SelectedValue);
                oND.SOCMND = txtND_CMND.Text.Replace(" ", "");
                oND.SO_CCCD = txtND_CCCD.Text.Replace(" ", "");
                oND.SO_HO_CHIEU = txtND_HoChieu.Text.Replace(" ", "");

                oND.QUOCTICHID = Convert.ToDecimal(ddlND_Quoctich.SelectedValue);

                oND.TAMTRUTINHID = Convert.ToDecimal(ddlNoiSongTinh.SelectedValue);
                oND.TAMTRUID = Convert.ToDecimal(ddlNoiSongHuyen.SelectedValue);
                oND.TAMTRUCHITIET = txtND_TTChitiet.Text;
                oND.DIACHICOQUAN = txtNoiLamViec.Text.Trim() + "";

                DateTime dNDNgaysinh;
                dNDNgaysinh = (String.IsNullOrEmpty(txtND_Ngaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NGAYSINH = dNDNgaysinh;
                oND.NAMSINH = txtND_Namsinh.Text == "" ? 0 : Convert.ToDecimal(txtND_Namsinh.Text);
                //oND.TUOI = txtND_Tuoi.Text == "" ? 0 : Convert.ToDecimal(txtND_Tuoi.Text);
                oND.GIOITINH = Convert.ToDecimal(ddlND_Gioitinh.SelectedValue);
                oND.EMAIL = txtEmail.Text;
                oND.DIENTHOAI = txtDienthoai.Text;
                oND.SINHSONG_NUOCNGOAI = chkONuocNgoai.Checked == true ? 1 : 0;
                oND.FAX = txtFax.Text;
                if (pnNDTochuc.Visible)
                {
                    oND.NGUOIDAIDIEN = Cls_Comon.FormatTenRieng(txtND_NDD_Ten.Text);
                    oND.CHUCVU = txtND_NDD_Chucvu.Text;
                    if (ddl_NDD_Huyen.SelectedValue != "0")
                    {
                        oND.NDD_DIACHIID = Convert.ToDecimal(ddl_NDD_Huyen.SelectedValue);
                    }
                    oND.NDD_DIACHICHITIET = txtND_NDD_Diachichitiet.Text;
                }
                oND.ISDON = oND.ISDON;

                //Cập nhật trạng thái C06
                oND.CHK_KHONG_CO = chkBoxCMNDND.Checked ? "1" : "0";

                //Trạng thái Xac thuc Du lieu quoc gia của duong su
                if (chkKhongLamSachND.Checked)
                {
                    oND.XACTHUC_DLDCQG = 3; // ngươi dùng xác nhận không làm sạch được
                }
                else
                {
                    if (hdTrangThaiXacThucND.Value != "1")
                        oND.XACTHUC_DLDCQG = 0;
                    else
                        oND.XACTHUC_DLDCQG = Convert.ToInt16(hdTrangThaiXacThucND.Value);
                }
                //END

                oND.NGAYSUA = DateTime.Now;
                oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                dt.SaveChanges();

                lbthongbao.Text = "Lưu thành công!";
            }
            catch (Exception ex)
            {
            }
        }
        private void Resetcontrols()
        {
            hddid.Value = "0";
            txtTennguyendon.Text = txtND_NDD_Ten.Text = txtND_NDD_Chucvu.Text = txtND_CMND.Text = txtND_Ngaysinh.Text = "";
            txtND_NDD_Diachichitiet.Text = txtND_Namsinh.Text = txtND_TTChitiet.Text = txtEmail.Text = txtDienthoai.Text = txtFax.Text = "";

        }
        public void loadedit(decimal ID)
        {
            DM_HANHCHINH_BL oHCBL = new DM_HANHCHINH_BL();
            ALD_DON_DUONGSU oND = dt.ALD_DON_DUONGSU.Where(x => x.ID == ID).FirstOrDefault();
            hddid.Value = oND.ID.ToString();

            if (oND.TENDUONGSU != null)
            {
                txtTennguyendon.Text = oND.TENDUONGSU;
                txtTennguyendon.Enabled = false;
            }

            if (oND.LOAIDUONGSU != null)
            {
                ddlLoaiNguyendon.SelectedValue = oND.LOAIDUONGSU.ToString();
                ddlLoaiNguyendon.Enabled = false;
            }
            if (ddlLoaiNguyendon.SelectedValue == "1")
            {
                pnNDCanhan.Visible = true;
                pnNDTochuc.Visible = false;
                chkISBVQLNK.Visible = false;
            }
            else
            {
                pnNDCanhan.Visible = false;
                pnNDTochuc.Visible = true;
                chkISBVQLNK.Visible = true;
                if (oND.ISBVQLNGUOIKHAC == 1) chkISBVQLNK.Checked = true;
            }
            if (oND.SOCMND != null)
            {
                txtND_CMND.Text = oND.SOCMND;
                txtND_CMND.Enabled = false;
            }
            if (oND.SO_CCCD != null)
            {
                txtND_CCCD.Text = oND.SO_CCCD;
                txtND_CCCD.Enabled = false;
            }

            if (oND.SO_HO_CHIEU != null)
            {
                txtND_HoChieu.Text = oND.SO_HO_CHIEU;
                txtND_HoChieu.Enabled = false;
            }

            if (oND.QUOCTICHID != null)
            {
                ddlND_Quoctich.SelectedValue = oND.QUOCTICHID.ToString();
                ddlND_Quoctich.Enabled = false;
            }

            if (oND.TUCACHTOTUNG_MA != null)
            {
                ddlTucachTotung.SelectedValue = oND.TUCACHTOTUNG_MA;
                ddlTucachTotung.Enabled = false;
            }


            if (oND.TAMTRUTINHID != null)
            {
                ddlNoiSongTinh.Enabled = false;
                ddlNoiSongTinh.SelectedValue = oND.TAMTRUTINHID.ToString();
                LoadDropNoiSongHuyen();
                if (oND.TAMTRUID != null)
                {
                    ddlNoiSongHuyen.Enabled = false;
                    ddlNoiSongHuyen.SelectedValue = oND.TAMTRUID.ToString();
                }

            }

            if (oND.TAMTRUCHITIET != null)
            {
                txtND_TTChitiet.Text = oND.TAMTRUCHITIET;
                txtND_TTChitiet.Enabled = false;
            }
            if (oND.DIACHICOQUAN != null)
            {
                txtNoiLamViec.Text = oND.DIACHICOQUAN + "";
                txtNoiLamViec.Enabled = false;
            }

            if (oND.NGAYSINH != DateTime.MinValue)
            {
                txtND_Ngaysinh.Text = ((DateTime)oND.NGAYSINH).ToString("dd/MM/yyyy", cul);
                txtND_Ngaysinh.Enabled = false;
            }

            if (oND.NAMSINH != 0)
            {
                txtND_Namsinh.Text = oND.NAMSINH == 0 ? "" : oND.NAMSINH.ToString();
                txtND_Namsinh.Enabled = false;
            }

            // txtND_Tuoi.Text = oND.TUOI == 0 ? "" : oND.TUOI.ToString();

            if (oND.GIOITINH != null)
            {
                ddlND_Gioitinh.SelectedValue = oND.GIOITINH.ToString();
                ddlND_Gioitinh.Enabled = false;
            }

            if (pnNDTochuc.Visible)
            {
                if (oND.NGUOIDAIDIEN != null)
                {
                    txtND_NDD_Ten.Text = oND.NGUOIDAIDIEN;
                    txtND_NDD_Ten.Enabled = false;
                }

                if (oND.CHUCVU != null)
                {
                    txtND_NDD_Chucvu.Text = oND.CHUCVU;
                    txtND_NDD_Chucvu.Enabled = false;
                }

                if (oND.NDD_DIACHIID != null)
                {
                    DM_HANHCHINH hc = dt.DM_HANHCHINH.Where(x => x.ID == oND.NDD_DIACHIID).FirstOrDefault<DM_HANHCHINH>();
                    if (hc != null)
                    {
                        ddl_NDD_Tinh.Enabled = false;
                        ddl_NDD_Tinh.SelectedValue = hc.CAPCHAID.ToString();
                        LoadDrop_NDD_Huyen();
                        ddl_NDD_Huyen.SelectedValue = hc.ID.ToString();
                        ddl_NDD_Huyen.Enabled = false;
                    }
                }
                if (oND.NDD_DIACHICHITIET != null)
                {
                    txtND_NDD_Diachichitiet.Text = oND.NDD_DIACHICHITIET;
                    txtND_NDD_Diachichitiet.Enabled = false;
                }

            }
            if (oND.SINHSONG_NUOCNGOAI != null)
            {
                chkONuocNgoai.Checked = oND.SINHSONG_NUOCNGOAI == 1 ? true : false;
                chkONuocNgoai.Enabled = false;
            }

            if (ddlND_Quoctich.SelectedIndex > 0)
            {
                chkONuocNgoai.Visible = false;
            }
            else
            {
                chkONuocNgoai.Visible = true;
            }

            if (oND.EMAIL != null)
            {
                txtEmail.Text = oND.EMAIL + "";
                txtEmail.Enabled = false;
            }

            if (oND.DIENTHOAI != null)
            {
                txtDienthoai.Text = oND.DIENTHOAI + "";
                txtDienthoai.Enabled = false;
            }
            if (oND.FAX != null)
            {
                txtFax.Text = oND.FAX;
                txtFax.Enabled = false;
            }
            if (oND.XACTHUC_DLDCQG == 3)
            {
                chkKhongLamSachND.Checked = true;
            }
            if (oND.CHK_KHONG_CO == "1")
            {
                chkBoxCMNDND.Checked = true;
            }
        }
        protected void ddlND_Quoctich_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlND_Quoctich.SelectedIndex > 0)
            {
                chkONuocNgoai.Visible = false;
            }
            else
            {
                chkONuocNgoai.Visible = true;
            }
            if (ddlLoaiNguyendon.SelectedValue == "1")
                Cls_Comon.SetFocus(this, this.GetType(), ddlND_Gioitinh.ClientID);
            else
                Cls_Comon.SetFocus(this, this.GetType(), txtEmail.ClientID);
        }
        protected void chkONuocNgoai_CheckedChanged(object sender, EventArgs e)
        {
            Cls_Comon.SetFocus(this, this.GetType(), ddlNoiSongTinh.ClientID);
        }
        private void LoadDropTinh()
        {
            List<DM_HANHCHINH> lstTinh = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == ROOT).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstTinh != null && lstTinh.Count > 0)
            {


                ddlNoiSongTinh.DataSource = lstTinh;
                ddlNoiSongTinh.DataTextField = "TEN";
                ddlNoiSongTinh.DataValueField = "ID";
                ddlNoiSongTinh.DataBind();

                ddl_NDD_Tinh.DataSource = lstTinh;
                ddl_NDD_Tinh.DataTextField = "TEN";
                ddl_NDD_Tinh.DataValueField = "ID";
                ddl_NDD_Tinh.DataBind();

                //ddlThuongTruTinh.Items.Insert(0,new ListItem("---Chọn---", "0"));
                ddlNoiSongTinh.Items.Insert(0, new ListItem("---Chọn---", "0"));
                ddl_NDD_Tinh.Items.Insert(0, new ListItem("---Chọn---", "0"));
            }
            else
            {
                // ddlThuongTruTinh.Items.Insert(0, new ListItem("---Chọn---", "0"));
                ddlNoiSongTinh.Items.Insert(0, new ListItem("---Chọn---", "0"));
                ddl_NDD_Tinh.Items.Insert(0, new ListItem("---Chọn---", "0"));
            }
            //LoadDropThuongTruHuyen();
            LoadDropNoiSongHuyen();
            LoadDrop_NDD_Huyen();
        }
        //private void LoadDropThuongTruHuyen()
        //{
        //    ddlThuongTruHuyen.Items.Clear();
        //    decimal TinhID = Convert.ToDecimal(ddlThuongTruTinh.SelectedValue);
        //    if (TinhID == 0)
        //    {
        //        ddlThuongTruHuyen.Items.Insert(0,new ListItem("---Chọn---", "0"));
        //        return;
        //    }
        //    List<DM_HANHCHINH> lstHuyen = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == TinhID).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
        //    if (lstHuyen != null && lstHuyen.Count > 0)
        //    {
        //        ddlThuongTruHuyen.DataSource = lstHuyen;
        //        ddlThuongTruHuyen.DataTextField = "TEN";
        //        ddlThuongTruHuyen.DataValueField = "ID";
        //        ddlThuongTruHuyen.DataBind();
        //        ddlThuongTruHuyen.Items.Insert(0, new ListItem("---Chọn---", "0"));
        //    }
        //    else
        //    {
        //        ddlThuongTruHuyen.Items.Add(new ListItem("---Chọn---", "0"));
        //    }
        //}
        private void LoadDropNoiSongHuyen()
        {
            ddlNoiSongHuyen.Items.Clear();
            decimal TinhID = Convert.ToDecimal(ddlNoiSongTinh.SelectedValue);
            if (TinhID == 0)
            {
                ddlNoiSongHuyen.Items.Insert(0, new ListItem("---Chọn---", "0"));
                return;
            }
            List<DM_HANHCHINH> lstHuyen = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == TinhID).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstHuyen != null && lstHuyen.Count > 0)
            {
                ddlNoiSongHuyen.DataSource = lstHuyen;
                ddlNoiSongHuyen.DataTextField = "TEN";
                ddlNoiSongHuyen.DataValueField = "ID";
                ddlNoiSongHuyen.DataBind();
                ddlNoiSongHuyen.Items.Insert(0, new ListItem("---Chọn---", "0"));
            }
            else
            {
                ddlNoiSongHuyen.Items.Add(new ListItem("---Chọn---", "0"));
            }
        }
        private void LoadDrop_NDD_Huyen()
        {
            ddl_NDD_Huyen.Items.Clear();
            decimal TinhID = Convert.ToDecimal(ddl_NDD_Tinh.SelectedValue);
            if (TinhID == 0)
            {
                ddl_NDD_Huyen.Items.Insert(0, new ListItem("---Chọn---", "0"));
                return;
            }
            List<DM_HANHCHINH> lstHuyen = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == TinhID).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstHuyen != null && lstHuyen.Count > 0)
            {
                ddl_NDD_Huyen.DataSource = lstHuyen;
                ddl_NDD_Huyen.DataTextField = "TEN";
                ddl_NDD_Huyen.DataValueField = "ID";
                ddl_NDD_Huyen.DataBind();
                ddl_NDD_Huyen.Items.Insert(0, new ListItem("---Chọn---", "0"));
            }
            else
            {
                ddl_NDD_Huyen.Items.Add(new ListItem("---Chọn---", "0"));
            }
        }

        protected void ddlNoiSongTinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDropNoiSongHuyen();
                Cls_Comon.SetFocus(this, this.GetType(), ddlNoiSongHuyen.ClientID);
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void ddl_NDD_Tinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDrop_NDD_Huyen();
                Cls_Comon.SetFocus(this, this.GetType(), ddl_NDD_Huyen.ClientID);
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        //--------------------------------
        protected void btnGet037_Click(object sender, EventArgs e)
        {
            string quocTich = ddlND_Quoctich.SelectedValue;
            if (quocTich == "2")
            {
                string soDinhDanh = txtND_CCCD.Text.Trim();
                if (string.IsNullOrEmpty(soDinhDanh))
                {
                    string strMsg = "Vui lòng nhập Thẻ căn cước của Đương sự!";
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                    return;
                }

                string HoTen = txtTennguyendon.Text.Trim();
                if (string.IsNullOrEmpty(HoTen))
                {
                    string strMsg = "Vui lòng nhập Họ và Tên của Đương sự!";
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                    return;
                }

                string NamSinh = txtND_Namsinh.Text.Trim();
                if (string.IsNullOrEmpty(NamSinh))
                {
                    string strMsg = "Vui lòng nhập Năm sinh của Đương sự!";
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                    return;
                }

                string NamSinhFormat = "";
                if (!string.IsNullOrWhiteSpace(NamSinh) && NamSinh.Length == 8)
                {
                    try
                    {
                        DateTime dt = DateTime.ParseExact(NamSinh, "ddMMyyyy", System.Globalization.CultureInfo.InvariantCulture);
                        NamSinhFormat = dt.ToString("yyyyMMdd");
                    }
                    catch (FormatException)
                    {
                        // Handle lỗi nếu không đúng định dạng
                        string strMsg = "Năm sinh không đúng định dạng, Vui lòng kiểm tra lại!";
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                        return;
                    }
                }
                else
                {
                    NamSinhFormat = NamSinh;
                }

                var client = new CallApi037();
                // Gọi phương thức async theo kiểu đồng bộ (blocking)
                string vMadonvi = Session[ENUM_SESSION.SESSION_MADONVI] + "";
                string vTenTaiKHoan = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                decimal CurrUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
                QT_NGUOISUDUNG oTaiK = null;
                DM_CANBO oCanBo = null;
                if (CurrUserID > 0)
                {
                    oTaiK = dt.QT_NGUOISUDUNG.Where(x => x.ID == CurrUserID).First();
                    if (oTaiK != null)
                        oCanBo = dt.DM_CANBO.Where(x => x.ID == oTaiK.CANBOID).FirstOrDefault();
                }
                string vSoCCCDTaiKHoan = null;
                string result = "";
                if (oCanBo != null)
                {
                    if (oCanBo.SOCCCD != null)
                    {
                        vSoCCCDTaiKHoan = oCanBo.SOCCCD.ToString();

                        result = client.SendRequestAsync(vMadonvi, vSoCCCDTaiKHoan, vTenTaiKHoan, soDinhDanh, ConvertToUnsign(HoTen), NamSinhFormat)
                                               .GetAwaiter()
                                               .GetResult();
                    }
                    else
                    {
                        string strMsg = "Cán bộ Tòa án chưa được cập nhật số định danh cá nhân nên không dùng được chức năng Kiểm tra này!";
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                        return;
                    }
                }

                if (result == "Err")
                {
                    string strMsg = "Lỗi hệ thống, đề nghị liên hệ với Quản trị viên!";
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                    return;
                }

                //Luu goi API thành công thì lưu
                DLQGC06_BL oBL = new DLQGC06_BL();
                decimal CANBO_ID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
                DM_CANBO canBo = dt.DM_CANBO.Where(x => x.ID == CANBO_ID).FirstOrDefault();
                string don_id = Session[ENUM_LOAIAN.AN_LAODONG] + "";
                string username = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                var vLichSu = oBL.HistoryC06_CALL_API037(don_id, canBo.SOCMND, canBo.HOTEN, username, result);

                // Xử lý kết quả XML
                CongDan037 CongDan = ParseSoapResponse(result);
                if (CongDan == null)
                {
                    string strMsg = "Không tồn tại dữ liệu về Đương sự! Đề nghị kiểm tra lại Họ tên, CCCD, Năm sinh";
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                    return;
                }
                else
                {
                    if (CongDan.HoVaTen.Ten == null)
                    {
                        string strMsg = "Không tồn tại dữ liệu về Đương sự! Đề nghị kiểm tra lại Họ tên, CCCD, Năm sinh";
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                        return;
                    }

                    //Nếu tồn tại dữ liệu thì khóa truong thong tin khong cho sua
                    chkKhongLamSachND.Checked = chkBoxCMNDND.Checked = false;
                    ddlND_Quoctich.Enabled = false;
                    hdTrangThaiXacThucND.Value = "1";
                    Session.Remove("CongDan");
                    Session["CongDan"] = CongDan;
                    string StrMsg = "PopupCenter('/QLAN/ALD/Hoso/Popup/pGetDuongSu037.aspx?caller=DuongSuND','Thông tin công dân từ hệ thống Cơ sở dữ liệu quốc gia về dân cư',850,700);";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
                }
            }
            else
            {
                string strMsg = "Chỉ áp dụng với Công dân quốc tịch Việt Nam!";
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                return;
            }
        }
        public static string ConvertToUnsign(string input)
        {
            if (string.IsNullOrEmpty(input))
                return string.Empty;

            // Xử lý ký tự Đ/đ thủ công
            input = input.Replace("Đ", "D").Replace("đ", "d");

            // Chuẩn hóa thành dạng không dấu
            string normalized = input.Normalize(NormalizationForm.FormD);
            var sb = new StringBuilder();

            foreach (char c in normalized)
            {
                UnicodeCategory uc = CharUnicodeInfo.GetUnicodeCategory(c);
                if (uc != UnicodeCategory.NonSpacingMark)
                {
                    sb.Append(c);
                }
            }

            string unsign = sb.ToString().Normalize(NormalizationForm.FormC);

            // Xóa tất cả ký tự không phải chữ và số
            unsign = Regex.Replace(unsign, @"[^a-zA-Z0-9]", "");

            return unsign.ToUpper();
        }

        private CongDan037 ParseSoapResponse(string xml)
        {
            CongDan037 citizen = new CongDan037();

            XmlDocument doc = new XmlDocument();
            doc.LoadXml(xml);

            XmlNamespaceManager nsmgr = new XmlNamespaceManager(doc.NameTable);
            nsmgr.AddNamespace("soapenv", "http://schemas.xmlsoap.org/soap/envelope/");
            nsmgr.AddNamespace("ns1", "http://www.mic.gov.vn/dancu/1.0");

            // Truy cập chính xác nút <ns1:CongDan>
            XmlNode congDanNode = doc.SelectSingleNode("//soapenv:Envelope/soapenv:Body/ns1:CongdanCollection/ns1:CongDan", nsmgr);

            if (congDanNode == null)
                return citizen; //

            citizen.SoDinhDanh = congDanNode.SelectSingleNode("ns1:SoDinhDanh", nsmgr)?.InnerText;
            citizen.SoCMND = congDanNode.SelectSingleNode("ns1:SoCMND", nsmgr)?.InnerText;
            citizen.GioiTinh = congDanNode.SelectSingleNode("ns1:GioiTinh", nsmgr)?.InnerText;
            citizen.DanToc = congDanNode.SelectSingleNode("ns1:DanToc", nsmgr)?.InnerText;

            XmlNode ngaySinhNode = congDanNode.SelectSingleNode("ns1:NgayThangNamSinh", nsmgr);
            if (ngaySinhNode != null)
            {
                citizen.NamSinh = ngaySinhNode.SelectSingleNode("ns1:Nam", nsmgr)?.InnerText;
                citizen.NgayThangNam = ngaySinhNode.SelectSingleNode("ns1:NgayThangNam", nsmgr)?.InnerText;
            }

            // Trích xuất Họ tên
            XmlNode hoTenNode = congDanNode.SelectSingleNode("ns1:HoVaTen", nsmgr);
            if (hoTenNode != null)
            {
                citizen.HoVaTen = new HoVaTen
                {
                    Ho = hoTenNode.SelectSingleNode("ns1:Ho", nsmgr)?.InnerText,
                    ChuDem = hoTenNode.SelectSingleNode("ns1:ChuDem", nsmgr)?.InnerText,
                    Ten = hoTenNode.SelectSingleNode("ns1:Ten", nsmgr)?.InnerText
                };
            }
            //Dia chi
            //Noi o hien tai
            XmlNode noiOHienTaiNode = congDanNode.SelectSingleNode("ns1:NoiOHienTai", nsmgr);
            if (noiOHienTaiNode != null)
            {
                citizen.NoiOHienTai = new DiaChi()
                {
                    MaTinhThanh = noiOHienTaiNode.SelectSingleNode("ns1:MaTinhThanh", nsmgr)?.InnerText,
                    MaPhuongXa = noiOHienTaiNode.SelectSingleNode("ns1:MaPhuongXa", nsmgr)?.InnerText,
                    ChiTiet = noiOHienTaiNode.SelectSingleNode("ns1:ChiTiet", nsmgr)?.InnerText
                };
            }
            //Que quan
            XmlNode queQuanNode = congDanNode.SelectSingleNode("ns1:QueQuan", nsmgr);
            if (queQuanNode != null)
            {
                citizen.QueQuan = new DiaChi()
                {
                    MaTinhThanh = queQuanNode.SelectSingleNode("ns1:MaTinhThanh", nsmgr)?.InnerText,
                    MaPhuongXa = queQuanNode.SelectSingleNode("ns1:MaPhuongXa", nsmgr)?.InnerText,
                    ChiTiet = queQuanNode.SelectSingleNode("ns1:ChiTiet", nsmgr)?.InnerText
                };
            }
            //Thường trú
            XmlNode thuongTruNode = congDanNode.SelectSingleNode("ns1:ThuongTru", nsmgr);
            if (thuongTruNode != null)
            {
                citizen.ThuongTru = new DiaChi()
                {
                    MaTinhThanh = thuongTruNode.SelectSingleNode("ns1:MaTinhThanh", nsmgr)?.InnerText,
                    MaPhuongXa = thuongTruNode.SelectSingleNode("ns1:MaPhuongXa", nsmgr)?.InnerText,
                    ChiTiet = thuongTruNode.SelectSingleNode("ns1:ChiTiet", nsmgr)?.InnerText
                };
            }

            return citizen;
        }

        protected void chkBoxCMNDND_CheckedChanged(object sender, EventArgs e)
        {

            if (!chkBoxCMNDND.Checked)
            {
                ltCMNDND.Text = "<span style='color:red'>(*)</span>";
                ltCCCDND.Text = "<span style='color:red'>(*)</span>";
            }
            else
            {
                ltCMNDND.Text = "";
                ltCCCDND.Text = "";
            }

        }
    }
}