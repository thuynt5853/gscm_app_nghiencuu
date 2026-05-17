using BL.GSTP;
using BL.GSTP.ADS;
using BL.GSTP.DLQGC06;
using BL.GSTP.DLQGC12;
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

namespace WEB.GSTP.QLAN.ADS.Hoso
{
    public partial class DuongSu : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private const decimal ROOT = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string current_id = Session[ENUM_LOAIAN.AN_DANSU] + "";
                if (current_id == "") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/ADS/Hoso/Danhsach.aspx");
                LoadCombobox();
                //MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                //Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                decimal ID = Convert.ToDecimal(current_id);

                CheckQuyen(ID);
                //ADS_DON oDon = dt.ADS_DON.Where(x => x.ID == ID).FirstOrDefault();
                ADS_DON_XULY oDXuly = dt.ADS_DON_XULY.Where(x => x.DONID == ID && x.LOAIGIAIQUYET == 1).FirstOrDefault();
                if (oDXuly != null)
                {
                    lbthongbao.Text = "Đơn đã chuyển sang tòa án khác xử lý !";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                }
                //check vụ án đã kết thúc không cho sửa xóa
                Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                if (anKetThuc)
                {
                    lbthongbao.Text = "Vụ án đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                }
                SetTinhHuyenMacDinh();
                LoadGrid();
                ltCMNDND.Text = "<span style='color:red'>(*)</span>";
            }
            else
            {
                EnableControl();
            }
        }
        private void CheckQuyen(decimal ID)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);

            ADS_DON oT = dt.ADS_DON.Where(x => x.ID == ID).FirstOrDefault();
            if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
            {
                lbthongbao.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }
            string StrMsg = "Không được sửa đổi thông tin.";
            string Result = new ADS_CHUYEN_NHAN_AN_BL().Check_NhanAn(ID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            if (Result != "")
            {
                lbthongbao.Text = Result;
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }

            //check nếu vụ án đã có bản án thì không cho sửa thông tin đương sự
            bool daCoBanAn = dt.ADS_SOTHAM_BANAN.Any(x => x.DONID == ID);
            if (daCoBanAn)
            {
                lbthongbao.Text = "Đã có bản án, không được sửa đổi!";
                Cls_Comon.SetButton(cmdUpdate, false);
                //Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
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
            ddlND_Quoctich.Items.Clear();
            //Load quốc tịch
            DataTable dtQuoctich = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.QUOCTICH);
            ddlND_Quoctich.DataSource = dtQuoctich;
            ddlND_Quoctich.DataTextField = "TEN";
            ddlND_Quoctich.DataValueField = "ID";
            ddlND_Quoctich.DataBind();
            ddlTucachTotung.Items.Clear();
            ddlTucachTotung.DataSource = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.TUCACHTOTUNG_DS);
            ddlTucachTotung.DataTextField = "TEN";
            ddlTucachTotung.DataValueField = "MA";
            ddlTucachTotung.DataBind();

            LoadDropTinh();
        }
        private void ResetControls()
        {
            ddlLoaiNguyendon.Enabled = true;
            ddlTucachTotung.Enabled = true;
            txtTennguyendon.Text = "";
            txtND_CMND.Text = "";
            txtND_CCCD.Text = "";
            txtND_HoChieu.Text = "";
            txtND_Ngaysinh.Text = "";
            chkONuocNgoai.Checked = false;

            // GTEL-HUNGNQ 10-10-2025 reset dữ liệu khi ấn làm mới
            hdTrangThaiXacThuc.Value = "";
            hidNoiSongHuyen.Value = "";
            chkBoxCMNDND.Checked = false;
            chkKhongLamSach.Checked = false;
            cmdGet037.Enabled = chkBoxCMNDND.Enabled = chkKhongLamSach.Enabled = true;
            EnableControl();
            //END

            txtND_Namsinh.Text = "";
            // txtND_HKTT_Chitiet.Text = "";
            txtND_TTChitiet.Text = "";
            txtND_NDD_Ten.Text = "";
            txtEmail.Text = txtDienthoai.Text = txtFax.Text = txtND_NDD_Diachichitiet.Text = "";
            hddid.Value = "0";
            txtND_CCCD.Enabled = txtTennguyendon.Enabled = txtND_Namsinh.Enabled = txtND_Ngaysinh.Enabled = true;
            ddlND_Quoctich.Enabled = true;
            ddlNoiSongTinh.Enabled = ddlNoiSongHuyen.Enabled = true;
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);

            //15-01-2026
            string current_id = Session[ENUM_LOAIAN.AN_DANSU] + "";
            decimal DONID = Convert.ToDecimal(current_id);
            //check nếu vụ án đã có bản án thì không cho sửa thông tin đương sự
            bool daCoBanAn = dt.ADS_SOTHAM_BANAN.Any(x => x.DONID == DONID);
            if (daCoBanAn)
            {
                lbthongbao.Text = "Đã có bản án, không được sửa đổi!";
                Cls_Comon.SetButton(cmdUpdate, false);
            }
            //---------------
        }
        private bool CheckValid()
        {
            if (txtTennguyendon.Text == "")
            {
                lbthongbao.Text = "Chưa nhập tên đương sự";
                return false;
            }

            if (ddlLoaiNguyendon.SelectedValue == "1")
            {
                if (txtND_Namsinh.Text == "")
                {
                    lbthongbao.Text = "Chưa nhập năm sinh";
                    return false;
                }
                if (lblBatbuoc2.Text != "")
                {
                    //if (ddlThuongTruHuyen.SelectedValue == "0")
                    //{
                    //    lbthongbao.Text = "Chưa chọn nơi thường trú!";
                    //    return false;
                    //}
                    if (ddlNoiSongHuyen.SelectedValue == "0")
                    {
                        lbthongbao.Text = "Chưa chọn nơi sinh sống!";
                        return false;
                    }
                }
            }
            if (!chkBoxCMNDND.Checked)
            {
                if (string.IsNullOrEmpty(txtND_CMND.Text) && string.IsNullOrEmpty(txtND_CCCD.Text) && string.IsNullOrEmpty(txtND_HoChieu.Text))
                {
                    lbthongbao.Text = "Bạn cần nhập 1 trong 3 nội dung Số CMND/ Thẻ căn cước/ Hộ chiếu. Nếu không có vui lòng tích chọn 'Không có'.";
                    txtND_CMND.Focus();
                    return false;
                }
                if (!string.IsNullOrEmpty(txtND_CMND.Text) && txtND_CMND.Text.Length != 9)
                {
                    lbthongbao.Text = "Số CMND chưa đúng định dạng!";
                    txtND_CMND.Focus();
                    return false;
                }
                if (!string.IsNullOrEmpty(txtND_CCCD.Text) && txtND_CCCD.Text.Length != 12)
                {
                    lbthongbao.Text = "Số CCCD chưa đúng định dạng!";
                    txtND_CCCD.Focus();
                    return false;
                }

                if (ddlND_Quoctich.SelectedValue == "2")
                {
                    //La nguoi VN thi so ho chieu la 8 ky tu
                    if (!string.IsNullOrEmpty(txtND_HoChieu.Text) && txtND_HoChieu.Text.Length != 8)
                    {
                        lbthongbao.Text = "Số hộ chiếu chưa đúng định dạng!";
                        txtND_HoChieu.Focus();
                        return false;
                    }
                }

            }
            if (ddlND_Gioitinh.SelectedValue == "0" && ddlLoaiNguyendon.SelectedValue == "1")
            {
                lbthongbao.Text = "Bạn chưa chọn giới tính.";
                ddlND_Gioitinh.Focus();
                return false;
            }

            return true;
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
        protected void txtND_Ngaysinh_TextChanged(object sender, EventArgs e)
        {
            DateTime d;
            d = (String.IsNullOrEmpty(txtND_Ngaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (d != DateTime.MinValue)
            {

                txtND_Namsinh.Text = d.Year.ToString();
                ////Tính tuổi 
                //string current_id = Session[ENUM_LOAIAN.AN_DANSU] + "";
                //decimal ID = Convert.ToDecimal(current_id);
                //ADS_DON oT = dt.ADS_DON.Where(x => x.ID == ID).FirstOrDefault();
                //DateTime dNgayNhan = (DateTime)oT.NGAYNHANDON;
                //if (dNgayNhan != DateTime.MinValue)
                //{
                //    txtND_Tuoi.Text = (dNgayNhan.Year - d.Year).ToString();
                //}
            }
            chkONuocNgoai.Focus();
        }
        protected void ddlLoaiNguyendon_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlLoaiNguyendon.SelectedValue == "1")
            {
                pnNDCanhan.Visible = true;
                pnNDTochuc.Visible = false;
            }
            else
            {
                pnNDCanhan.Visible = false;
                pnNDTochuc.Visible = true;
            }
            Cls_Comon.SetFocus(this, this.GetType(), ddlTucachTotung.ClientID);
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (!CheckValid()) return;
                string current_id = Session[ENUM_LOAIAN.AN_DANSU] + "";
                decimal DONID = Convert.ToDecimal(current_id);

                //check nếu vụ án đã có bản án thì không cho sửa thông tin đương sự
                bool daCoBanAn = dt.ADS_SOTHAM_BANAN.Any(x => x.DONID == DONID);
                if (daCoBanAn)
                {
                    lbthongbao.Text = "Đã có bản án, không được sửa đổi!";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    return;
                }

                ADS_DON_DUONGSU oND;
                if (hddid.Value == "" || hddid.Value == "0")
                {
                    oND = new ADS_DON_DUONGSU();
                    oND.ISDAIDIEN = 0;
                }
                else
                {
                    decimal ID = Convert.ToDecimal(hddid.Value);
                    oND = dt.ADS_DON_DUONGSU.Where(x => x.ID == ID).FirstOrDefault();

                    if (oND.ISDAIDIEN != 0)
                    {
                        oND.ISDAIDIEN = 1;
                    }
                    else
                    {
                        oND.ISDAIDIEN = 0;
                    }
                }
                oND.DONID = DONID;
                oND.ISSOTHAM = 1;
                oND.TENDUONGSU = Convert.ToDecimal(ddlLoaiNguyendon.SelectedValue) == 1 ? Cls_Comon.FormatTenRieng(txtTennguyendon.Text) : Cls_Comon.FormatTenTochuc(txtTennguyendon.Text);

                oND.TUCACHTOTUNG_MA = ddlTucachTotung.SelectedValue;
                oND.LOAIDUONGSU = Convert.ToDecimal(ddlLoaiNguyendon.SelectedValue);
                oND.SOCMND = txtND_CMND.Text.Replace(" ", "");
                oND.SO_CCCD = txtND_CCCD.Text.Replace(" ", "");
                oND.SO_HO_CHIEU = txtND_HoChieu.Text.Replace(" ", "");
                oND.QUOCTICHID = Convert.ToDecimal(ddlND_Quoctich.SelectedValue);
                //oND.HKTTTINHID = Convert.ToDecimal(ddlThuongTruTinh.SelectedValue);
                //oND.HKTTID = Convert.ToDecimal(ddlThuongTruHuyen.SelectedValue);
                //oND.HKTTCHITIET = txtND_HKTT_Chitiet.Text;
                oND.TAMTRUTINHID = Convert.ToDecimal(ddlNoiSongTinh.SelectedValue);
                oND.TAMTRUID = Convert.ToDecimal(ddlNoiSongHuyen.SelectedValue);
                oND.TAMTRUCHITIET = txtND_TTChitiet.Text;
                oND.DIACHICOQUAN = txtNoiLamViec.Text.Trim() + "";

                DateTime dNDNgaysinh;
                dNDNgaysinh = (String.IsNullOrEmpty(txtND_Ngaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NGAYSINH = dNDNgaysinh;
                oND.THANGSINH = 0;
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

                oND.ISDON = 1;
                oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                if (hddid.Value == "" || hddid.Value == "0")
                {
                    oND.NGAYTAO = DateTime.Now;
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    //update 14082025
                    oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.ADS_DON_DUONGSU.Add(oND);
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                }
                // GTEL-HUNGNQ 10-10-2025 Cập nhật trạng thái C06 dùng entity
                oND.CHK_KHONG_CO = chkBoxCMNDND.Checked ? "1" : "0";

                //Trạng thái Xac thuc Du lieu quoc gia của duong su
                if (chkKhongLamSach.Checked)
                {
                    oND.XACTHUC_DLDCQG = 3; // ngươi dùng xác nhận không làm sạch được
                }
                else
                {
                    if (hdTrangThaiXacThuc.Value != "1")
                        oND.XACTHUC_DLDCQG = 0;
                    else
                        oND.XACTHUC_DLDCQG = Convert.ToInt16(hdTrangThaiXacThuc.Value);
                }
                //END
                dt.SaveChanges();

                lbthongbao.Text = "Lưu thành công!";
                ADS_DON_DUONGSU_BL oDonBL = new ADS_DON_DUONGSU_BL();
                oDonBL.ADS_DON_YEUTONUOCNGOAI_UPDATE(DONID);
                dgList.CurrentPageIndex = 0;
                LoadGrid();
                ResetControls();
            }
            catch (Exception ex)
            {
                lbthongbao.Text = "Lỗi: " + ex.Message;
            }
        }
        public void LoadGrid()
        {
            KHOBAQD_BL oBL = new KHOBAQD_BL();
            string current_id = Session[ENUM_LOAIAN.AN_DANSU] + "";
            decimal ID = Convert.ToDecimal(current_id);
            DataTable oDT = oBL.ADS_DON_DSDUONGSU_GETBY(ID);
            if (oDT != null && oDT.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Convert.ToInt32(oDT.Rows.Count), Convert.ToInt32(20)).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + oDT.Rows.Count.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion

                dgList.DataSource = oDT;
                dgList.DataBind();
                pndata.Visible = true;
            }
            else
            {
                pndata.Visible = false;
            }
        }
        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            ResetControls();
        }
        public void xoa(decimal id)
        {
            ADS_DON_DUONGSU oND = dt.ADS_DON_DUONGSU.Where(x => x.ID == id).FirstOrDefault();
            decimal DONID = (decimal)oND.DONID;

            ADS_ANPHI oAnphi = dt.ADS_ANPHI.Where(x => x.DONID == DONID).FirstOrDefault();
            if (oND.ISDAIDIEN == 1 && oAnphi != null)
            {
                lbthongbao.Text = "Giải quyết đơn đã có dữ liệu, không được phép xóa Đương sự đại diện!.";
                return;
            }

            ADS_DON_THAMPHAN oTPThuly = dt.ADS_DON_THAMPHAN.Where(x => x.DONID == DONID).FirstOrDefault();
            if (oND.ISDAIDIEN == 1 && oTPThuly != null)
            {
                lbthongbao.Text = "Đã phân công Thẩm phán giải quyết đơn, không được phép xóa Đương sự đại diện!.";
                return;
            }
            dt.ADS_DON_DUONGSU.Remove(oND);
            dt.SaveChanges();
            dgList.CurrentPageIndex = 0;
            LoadGrid();
            ResetControls();
            lbthongbao.Text = "Xóa thành công!";
            ADS_DON_DUONGSU_BL oDonBL = new ADS_DON_DUONGSU_BL();
            oDonBL.ADS_DON_YEUTONUOCNGOAI_UPDATE(DONID);
        }
        public void loadedit(decimal ID)
        {
            DM_HANHCHINH_BL oHCBL = new DM_HANHCHINH_BL();
            ADS_DON_DUONGSU oND = dt.ADS_DON_DUONGSU.Where(x => x.ID == ID).FirstOrDefault();
            ddlLoaiNguyendon.Enabled = false;
            ddlTucachTotung.Enabled = false;
            hddid.Value = oND.ID.ToString();
            txtTennguyendon.Text = oND.TENDUONGSU;
            ddlLoaiNguyendon.SelectedValue = oND.LOAIDUONGSU.ToString();

            txtND_CMND.Text = oND.SOCMND;
            txtND_CCCD.Text = oND.SO_CCCD;
            txtND_HoChieu.Text = oND.SO_HO_CHIEU;
            ddlND_Quoctich.SelectedValue = oND.QUOCTICHID.ToString();
            ddlTucachTotung.SelectedValue = oND.TUCACHTOTUNG_MA;
            if (oND.TAMTRUTINHID != null)
            {
                ddlNoiSongTinh.SelectedValue = oND.TAMTRUTINHID.ToString();
                LoadDropNoiSongHuyen();
                try
                {
                    if (oND.TAMTRUID != null) ddlNoiSongHuyen.SelectedValue = oND.TAMTRUID.ToString();
                }
                catch (Exception ex) { }
            }
            txtND_TTChitiet.Text = oND.TAMTRUCHITIET;
            txtNoiLamViec.Text = oND.DIACHICOQUAN + "";

            if (oND.NGAYSINH != DateTime.MinValue) txtND_Ngaysinh.Text = ((DateTime)oND.NGAYSINH).ToString("dd/MM/yyyy", cul);
            txtND_Namsinh.Text = oND.NAMSINH == 0 ? "" : oND.NAMSINH.ToString();
            // txtND_Tuoi.Text = oND.TUOI == 0 ? "" : oND.TUOI.ToString();
            ddlND_Gioitinh.SelectedValue = oND.GIOITINH.ToString();
            if (pnNDTochuc.Visible)
            {
                txtND_NDD_Ten.Text = oND.NGUOIDAIDIEN;
                txtND_NDD_Chucvu.Text = oND.CHUCVU;
                if (oND.NDD_DIACHIID != null)
                {
                    DM_HANHCHINH hc = dt.DM_HANHCHINH.Where(x => x.ID == oND.NDD_DIACHIID).FirstOrDefault<DM_HANHCHINH>();
                    if (hc != null)
                    {
                        ddl_NDD_Tinh.SelectedValue = hc.CAPCHAID.ToString();
                        LoadDrop_NDD_Huyen();
                        ddl_NDD_Huyen.SelectedValue = hc.ID.ToString();
                    }
                }
                txtND_NDD_Diachichitiet.Text = oND.NDD_DIACHICHITIET;
            }
            if (oND.SINHSONG_NUOCNGOAI != null) chkONuocNgoai.Checked = oND.SINHSONG_NUOCNGOAI == 1 ? true : false;
            if (ddlND_Quoctich.SelectedIndex > 0)
            {
                //lblBatbuoc1.Text =
                lblBatbuoc2.Text = "";
                chkONuocNgoai.Visible = false;
            }
            else
            {
                //lblBatbuoc1.Text = 
                lblBatbuoc2.Text = "(*)";
                chkONuocNgoai.Visible = true;
            }
            if (chkONuocNgoai.Checked)
            {
                // lblBatbuoc1.Text = 
                lblBatbuoc2.Text = "";
            }
            else
            {
                //lblBatbuoc1.Text = 
                lblBatbuoc2.Text = "(*)";
            }
            txtEmail.Text = oND.EMAIL + "";
            txtDienthoai.Text = oND.DIENTHOAI + "";
            txtFax.Text = oND.FAX;
            if (ddlLoaiNguyendon.SelectedValue == "1")
            {
                pnNDCanhan.Visible = true;
                pnNDTochuc.Visible = false;
            }
            else
            {
                pnNDCanhan.Visible = false;
                pnNDTochuc.Visible = true;
            }

            // GTEL-HUNGNQ 01-10-2025 lấy thông tin xác thực C06 của nguyên đơn
            if (oND.XACTHUC_DLDCQG.HasValue)
            {
                chkKhongLamSach.Checked = oND.XACTHUC_DLDCQG.ToString() == "3";

                if (chkKhongLamSach.Checked)
                {
                    hdTrangThaiXacThuc.Value = "3";
                }
                else
                {
                    hdTrangThaiXacThuc.Value = oND.XACTHUC_DLDCQG.ToString();
                }
            }

            if (!string.IsNullOrEmpty(oND.CHK_KHONG_CO))
            {
                if (hdTrangThaiXacThuc.Value == "1")
                    chkBoxCMNDND.Checked = false;
                else
                    chkBoxCMNDND.Checked = oND.CHK_KHONG_CO.ToString() == "1";
            }
            else
                chkBoxCMNDND.Checked = false;

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

            if (hdTrangThaiXacThuc.Value == "1")
            {
                cmdGet037.Enabled = chkBoxCMNDND.Enabled = chkKhongLamSach.Enabled = false;
            }
            else
            {
                cmdGet037.Enabled = chkBoxCMNDND.Enabled = chkKhongLamSach.Enabled = true;
            }
            //END
        }

        public void loadedit_dathuly(decimal ID)
        {
            DM_HANHCHINH_BL oHCBL = new DM_HANHCHINH_BL();
            ADS_DON_DUONGSU oND = dt.ADS_DON_DUONGSU.Where(x => x.ID == ID).FirstOrDefault();

            hddid.Value = oND.ID.ToString();
            if (oND.TENDUONGSU != null)
            {
                txtTennguyendon.Text = oND.TENDUONGSU;
                txtTennguyendon.Enabled = false;
            }

            ddlLoaiNguyendon.Enabled = false;
            ddlLoaiNguyendon.SelectedValue = oND.LOAIDUONGSU.ToString();
            txtND_CMND.Text = oND.SOCMND;
            txtND_CCCD.Text = oND.SO_CCCD;
            txtND_HoChieu.Text = oND.SO_HO_CHIEU;

            ddlND_Quoctich.Enabled = false;
            ddlND_Quoctich.SelectedValue = oND.QUOCTICHID?.ToString();

            ddlTucachTotung.Enabled = false;
            ddlTucachTotung.SelectedValue = oND.TUCACHTOTUNG_MA;
            if (oND.TAMTRUTINHID != null && oND.TAMTRUTINHID > 0)
            {
                ddlNoiSongTinh.Enabled = false;
                ddlNoiSongTinh.SelectedValue = oND.TAMTRUTINHID.ToString();
                LoadDropNoiSongHuyen();
                try
                {
                    if (oND.TAMTRUID != null && oND.TAMTRUID > 0)
                    {
                        ddlNoiSongHuyen.SelectedValue = oND.TAMTRUID.ToString();
                        ddlNoiSongHuyen.Enabled = false;
                    }
                    else
                        ddlNoiSongHuyen.Enabled = true;

                }
                catch (Exception ex) { }
            }
            else
                ddlNoiSongTinh.Enabled = true;
            if (oND.TAMTRUCHITIET != null)
            {
                txtND_TTChitiet.Text = oND.TAMTRUCHITIET;
                txtND_TTChitiet.Enabled = false;
            }
            else
            {
                txtND_TTChitiet.Text = null;
                txtND_TTChitiet.Enabled = true;
            }

            if (oND.DIACHICOQUAN != null)
            {
                txtNoiLamViec.Text = oND.DIACHICOQUAN + "";
                txtNoiLamViec.Enabled = false;
            }
            else
            {
                txtNoiLamViec.Text = "";
                txtNoiLamViec.Enabled = true;
            }


            if (oND.NGAYSINH != DateTime.MinValue)
            {
                txtND_Ngaysinh.Text = ((DateTime)oND.NGAYSINH).ToString("dd/MM/yyyy", cul);
                txtND_Ngaysinh.Enabled = false;
            }
            else
            {
                txtND_Ngaysinh.Text = null;
                txtND_Ngaysinh.Enabled = true;
            }

            if (oND.NAMSINH != 0)
            {
                txtND_Namsinh.Enabled = false;
                txtND_Namsinh.Text = oND.NAMSINH == 0 ? "" : oND.NAMSINH.ToString();
            }
            else
            {
                txtND_Namsinh.Enabled = true;
                txtND_Namsinh.Text = null;
            }

            //ddlND_Gioitinh.Enabled = false;
            ddlND_Gioitinh.SelectedValue = oND.GIOITINH.ToString();
            if (pnNDTochuc.Visible)
            {

                if (oND.NGUOIDAIDIEN != null)
                {
                    txtND_NDD_Ten.Text = oND.NGUOIDAIDIEN;
                    txtND_NDD_Ten.Enabled = false;
                }
                else
                {
                    txtND_NDD_Ten.Text = null;
                    txtND_NDD_Ten.Enabled = true;
                }
                if (oND.CHUCVU != null)
                {
                    txtND_NDD_Chucvu.Text = oND.CHUCVU;
                    txtND_NDD_Chucvu.Enabled = false;
                }
                else
                {
                    txtND_NDD_Chucvu.Text = null;
                    txtND_NDD_Chucvu.Enabled = true;
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
                else
                {
                    ddl_NDD_Tinh.Enabled = true;
                    ddl_NDD_Huyen.Enabled = true;
                }

                if (oND.NDD_DIACHICHITIET != null)
                {
                    txtND_NDD_Diachichitiet.Text = oND.NDD_DIACHICHITIET;
                    txtND_NDD_Diachichitiet.Enabled = false;
                }
                else
                {
                    txtND_NDD_Diachichitiet.Text = null;
                    txtND_NDD_Diachichitiet.Enabled = true;
                }

            }
            if (oND.SINHSONG_NUOCNGOAI != null)
                chkONuocNgoai.Enabled = false;
            else
                chkONuocNgoai.Enabled = true;
            chkONuocNgoai.Checked = oND.SINHSONG_NUOCNGOAI == 1 ? true : false;

            if (ddlND_Quoctich.SelectedIndex > 0)
            {
                //lblBatbuoc1.Text =
                lblBatbuoc2.Text = "";
                chkONuocNgoai.Visible = false;
            }
            else
            {
                //lblBatbuoc1.Text = 
                lblBatbuoc2.Text = "(*)";
                chkONuocNgoai.Visible = true;
            }
            if (chkONuocNgoai.Checked)
            {
                // lblBatbuoc1.Text = 
                lblBatbuoc2.Text = "";
            }
            else
            {
                //lblBatbuoc1.Text = 
                lblBatbuoc2.Text = "(*)";
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

            if (ddlLoaiNguyendon.SelectedValue == "1")
            {
                pnNDCanhan.Visible = true;
                pnNDTochuc.Visible = false;
            }
            else
            {
                pnNDCanhan.Visible = false;
                pnNDTochuc.Visible = true;
            }

            if (cmdUpdate.Enabled)
            {
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
            }

            // GTEL-HUNGNQ 01-10-2025 lấy thông tin xác thực C06 của nguyên đơn
            if (oND.XACTHUC_DLDCQG.HasValue)
            {
                chkKhongLamSach.Checked = oND.XACTHUC_DLDCQG.ToString() == "3";

                if (chkKhongLamSach.Checked)
                {
                    hdTrangThaiXacThuc.Value = "3";
                }
                else
                {
                    hdTrangThaiXacThuc.Value = oND.XACTHUC_DLDCQG.ToString();
                }
            }

            if (!string.IsNullOrEmpty(oND.CHK_KHONG_CO))
            {
                chkBoxCMNDND.Checked = oND.CHK_KHONG_CO.ToString() == "1";
            }
            else
            {
                chkBoxCMNDND.Checked = false;
            }

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

            if (hdTrangThaiXacThuc.Value == "1")
            {
                cmdGet037.Enabled = chkBoxCMNDND.Enabled = chkKhongLamSach.Enabled = false;
            }
            else
            {
                cmdGet037.Enabled = chkBoxCMNDND.Enabled = chkKhongLamSach.Enabled = true;
            }
            //END
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Xem":
                    lbthongbao.Text = "";
                    //loadedit(ND_id);
                    loadedit_dathuly(ND_id);
                    hddid.Value = e.CommandArgument.ToString();
                    break;
                case "Sua":
                    lbthongbao.Text = "";
                    loadedit(ND_id);
                    hddid.Value = e.CommandArgument.ToString();
                    break;
                case "Xoa":
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (oPer.XOA == false || cmdUpdate.Enabled == false)
                    {
                        lbthongbao.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    decimal ID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_DANSU] + "");
                    string StrMsg = "Không được sửa đổi thông tin.";
                    string Result = new ADS_CHUYEN_NHAN_AN_BL().Check_NhanAn(ID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    if (Result != "")
                    {
                        lbthongbao.Text = Result;
                        return;
                    }
                    xoa(ND_id);
                    ResetControls();

                    break;
            }

        }
        protected void ddlND_Quoctich_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlND_Quoctich.SelectedIndex > 0)
            {
                //lblBatbuoc1.Text =
                lblBatbuoc2.Text = "";
                chkONuocNgoai.Visible = false;
            }
            else
            {
                // lblBatbuoc1.Text =
                lblBatbuoc2.Text = "(*)";
                chkONuocNgoai.Visible = true;
            }
            if (ddlLoaiNguyendon.SelectedValue == "1")
                Cls_Comon.SetFocus(this, this.GetType(), ddlND_Gioitinh.ClientID);
            else
                Cls_Comon.SetFocus(this, this.GetType(), txtEmail.ClientID);
        }
        protected void chkONuocNgoai_CheckedChanged(object sender, EventArgs e)
        {
            if (chkONuocNgoai.Checked)
            {
                //lblBatbuoc1.Text =
                lblBatbuoc2.Text = "";
            }
            else
            {
                // lblBatbuoc1.Text =
                lblBatbuoc2.Text = "(*)";
            }
            Cls_Comon.SetFocus(this, this.GetType(), ddlNoiSongTinh.ClientID);
        }
        private void LoadDropTinh()
        {
            ddlNoiSongTinh.Items.Clear();
            ddl_NDD_Tinh.Items.Clear();
            List<DM_HANHCHINH> lstTinh = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == ROOT).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstTinh != null && lstTinh.Count > 0)
            {
                //ddlThuongTruTinh.DataSource = lstTinh;
                //ddlThuongTruTinh.DataTextField = "TEN";
                //ddlThuongTruTinh.DataValueField = "ID";
                //ddlThuongTruTinh.DataBind();

                ddlNoiSongTinh.DataSource = lstTinh;
                ddlNoiSongTinh.DataTextField = "TEN";
                ddlNoiSongTinh.DataValueField = "ID";
                ddlNoiSongTinh.DataBind();

                ddl_NDD_Tinh.DataSource = lstTinh;
                ddl_NDD_Tinh.DataTextField = "TEN";
                ddl_NDD_Tinh.DataValueField = "ID";
                ddl_NDD_Tinh.DataBind();
            }
            //ddlThuongTruTinh.Items.Insert(0,new ListItem("---Chọn---", "0"));
            ddlNoiSongTinh.Items.Insert(0, new ListItem("---Chọn---", "0"));
            ddl_NDD_Tinh.Items.Insert(0, new ListItem("---Chọn---", "0"));
            //LoadDropThuongTruHuyen();
            LoadDropNoiSongHuyen();
            LoadDrop_NDD_Huyen();
        }
        private void LoadDropNoiSongHuyen()
        {
            ddlNoiSongHuyen.Items.Clear();
            decimal TinhID = Convert.ToDecimal(ddlNoiSongTinh.SelectedValue);
            if (TinhID == 0)
            {
                ddlNoiSongHuyen.Items.Add(new ListItem("---Chọn---", "0"));
                return;
            }
            List<DM_HANHCHINH> lstHuyen = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == TinhID).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstHuyen != null && lstHuyen.Count > 0)
            {
                ddlNoiSongHuyen.DataSource = lstHuyen;
                ddlNoiSongHuyen.DataTextField = "TEN";
                ddlNoiSongHuyen.DataValueField = "ID";
                ddlNoiSongHuyen.DataBind();
            }
            ddlNoiSongHuyen.Items.Insert(0, new ListItem("---Chọn---", "0"));
        }
        private void LoadDrop_NDD_Huyen()
        {
            ddl_NDD_Huyen.Items.Clear();
            decimal TinhID = Convert.ToDecimal(ddl_NDD_Tinh.SelectedValue);
            if (TinhID == 0)
            {
                ddl_NDD_Huyen.Items.Add(new ListItem("---Chọn---", "0"));
                return;
            }
            List<DM_HANHCHINH> lstHuyen = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == TinhID).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstHuyen != null && lstHuyen.Count > 0)
            {
                ddl_NDD_Huyen.DataSource = lstHuyen;
                ddl_NDD_Huyen.DataTextField = "TEN";
                ddl_NDD_Huyen.DataValueField = "ID";
                ddl_NDD_Huyen.DataBind();
            }
            ddl_NDD_Huyen.Items.Insert(0, new ListItem("---Chọn---", "0"));
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
        protected void ddlNoiSongTinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                string valueFromPopup = Request["__EVENTARGUMENT"];
                if (!string.IsNullOrEmpty(valueFromPopup))
                {
                    ddlNoiSongTinh.SelectedValue = valueFromPopup;
                }
                LoadDropNoiSongHuyen();

                // GTEL-HUNGNQ 10-10-2025 fill giá trị từ Get037 về dropdownlist
                if (!string.IsNullOrEmpty(hidNoiSongHuyen.Value))
                {
                    var item = ddlNoiSongHuyen.Items.FindByValue(hidNoiSongHuyen.Value);
                    if (item != null)
                    {
                        ddlNoiSongHuyen.SelectedValue = hidNoiSongHuyen.Value;
                    }
                }
                //END

                Cls_Comon.SetFocus(this, this.GetType(), ddlNoiSongHuyen.ClientID);
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;

                LinkButton lblXem = (LinkButton)e.Item.FindControl("lblXem");
                Cls_Comon.SetLinkButton(lblXem, oPer.CAPNHAT);

                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                Cls_Comon.SetLinkButton(lblSua, oPer.CAPNHAT);

                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);

                string current_id = Session[ENUM_LOAIAN.AN_DANSU] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                ADS_DON oT = dt.ADS_DON.Where(x => x.ID == DONID).FirstOrDefault();
                ADS_ANPHI oAP = dt.ADS_ANPHI.Where(x => x.DONID == oT.ID).FirstOrDefault();

                /*1. Nếu vụ án đang trong giai đoạn phúc thẩm thì không được xóa
                  2. Nếu vụ án đã có thụ lý sơ thẩm thì không được xóa
                  3. Nếu vụ án đã có biên lai án phí thì không được sửa và xóa*/
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oAP != null || rowView.Row["XACTHUC_DLDCQG_TEN"].ToString() == "Đã xác thực")
                {
                    lblSua.Visible = lbtXoa.Visible = false;
                    lblXem.Visible = true;
                }
                else
                {
                    lblSua.Visible = lbtXoa.Visible = true;
                    lblXem.Visible = false;
                }

                if(rowView.Row["DAIDIEN"].ToString() == "X ")
                {
                    lbtXoa.Visible = false;
                }
                string toagiaiquyetID = rowView.Row["TOA_GIAIQUYET_ID"].ToString();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (toagiaiquyetID != donviID)
                {
                    lbtXoa.Visible = false;
                    lblSua.Visible = false;
                }
            }
        }

        //private void LoadDropThuongTruHuyen()
        //{
        //    ddlThuongTruHuyen.Items.Clear();
        //    decimal TinhID = Convert.ToDecimal(ddlThuongTruTinh.SelectedValue);
        //    if (TinhID == 0)
        //    {
        //        ddlThuongTruHuyen.Items.Add(new ListItem("---Chọn---", "0"));
        //        return;
        //    }
        //    List<DM_HANHCHINH> lstHuyen = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == TinhID).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
        //    if (lstHuyen != null && lstHuyen.Count > 0)
        //    {
        //        ddlThuongTruHuyen.DataSource = lstHuyen;
        //        ddlThuongTruHuyen.DataTextField = "TEN";
        //        ddlThuongTruHuyen.DataValueField = "ID";
        //        ddlThuongTruHuyen.DataBind();
        //        ddlThuongTruHuyen.Items.Insert(0,new ListItem("---Chọn---", "0"));
        //    }
        //    else
        //    {
        //        ddlThuongTruHuyen.Items.Add(new ListItem("---Chọn---", "0"));
        //    }
        //}

        //protected void ddlThuongTruTinh_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        LoadDropThuongTruHuyen();
        //        Cls_Comon.SetFocus(this, this.GetType(), ddlThuongTruHuyen.ClientID);
        //    }
        //    catch (Exception ex) { lbthongbao.Text = ex.Message; }
        //}

        // GTEL-HungNQ: thêm check C06  

        /* - GTEL-HUNGNQ
           - Check C06 và Mở popup thông tin bị can khi lấy dữ liệu từ API 037 tương tự logic của án Hôn Nhân
           - 30-09-2025 10h:00  
        */
        #region "Check C06"
        protected void btnGet037_Click(object sender, EventArgs e)
        {
            string quocTich = ddlND_Quoctich.SelectedValue;
            if (quocTich == "2")
            {
                txtND_CCCD.Enabled = txtTennguyendon.Enabled = txtND_Namsinh.Enabled = txtND_Ngaysinh.Enabled = true;
                string soDinhDanh = txtND_CCCD.Text.Trim();

                if (string.IsNullOrEmpty(soDinhDanh))
                {
                    string strMsg = "Vui lòng nhập Số Định Danh!";
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                    return;
                }

                string HoTen = txtTennguyendon.Text.Trim();
                if (string.IsNullOrEmpty(HoTen))
                {
                    string strMsg = "Vui lòng nhập Họ và Tên!";
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                    return;
                }

                string NamSinh = txtND_Namsinh.Text.Trim();
                if (string.IsNullOrEmpty(NamSinh))
                {
                    string strMsg = "Vui lòng nhập Năm sinh!";
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
                        string strMsg = "Năm sinh không đúng định dạng, Vui long kiểm tra lại!";
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
                string don_id = Session[ENUM_LOAIAN.AN_DANSU] + "";
                string username = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                var vLichSu = oBL.HistoryC06_CALL_API037(don_id, canBo.SOCMND, canBo.HOTEN, username, result);

                // Xử lý kết quả XML
                CongDan037 CongDan = ParseSoapResponse(result);
                if (CongDan == null)
                {
                    string strMsg = "Không tồn tại dữ liệu về Đương sự! Đề nghị kiểm tra lại Họ tên, CCCD, Năm sinh Đề nghị kiểm tra lại Họ tên, CCCD, Năm sinh";
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                    return;
                }
                else
                {
                    if (CongDan.HoVaTen.Ten == null)
                    {
                        string strMsg = "Không tồn tại dữ liệu về Đương sự! Đề nghị kiểm tra lại Họ tên, CCCD, Năm sinh ";
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                        return;
                    }

                    decimal DuongSuID = Convert.ToDecimal(hddid.Value);
                    decimal dsNamSinh = Convert.ToDecimal(txtND_Namsinh.Text);
                    if (DuongSuID > 0)
                    {
                        //Kiem tra duong su ton tai thi cap trạng thái đã xác thực
                        ADS_DON_DUONGSU ds = dt.ADS_DON_DUONGSU.Where(x => x.ID == DuongSuID).First();
                        if (ds != null)
                        {
                            if (ds.TENDUONGSU == txtTennguyendon.Text && ds.NAMSINH == dsNamSinh && ds.SO_CCCD == txtND_CCCD.Text)
                            {
                                if (ds.SOCMND == null)
                                {
                                    ds.SOCMND = CongDan.SoCMND;
                                    txtND_CMND.Text = CongDan.SoCMND;
                                    txtND_CCCD.Enabled = false;
                                }

                                ds.XACTHUC_DLDCQG = 1;
                                ds.CHK_KHONG_CO = "0";

                                dt.SaveChanges();
                            }

                        }
                    }

                    //Nếu tồn tại dữ liệu thì khóa truong thong tin khong cho sua
                    chkKhongLamSach.Checked = chkBoxCMNDND.Checked = false;
                    hdTrangThaiXacThuc.Value = "1";
                    Session.Remove("CongDan");
                    Session["CongDan"] = CongDan;
                    string StrMsg = "PopupCenter('/QLAN/ADS/Hoso/Popup/pGetDuongSu037.aspx?caller=DuongSu','Thông tin công dân từ hệ thống Cơ sở dữ liệu quốc gia về dân cư',850,700);";
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

        private static string ConvertToUnsign(string input)
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

        private void EnableControl()
        {
            chkKhongLamSach.Enabled = chkBoxCMNDND.Enabled = txtND_CCCD.Enabled = txtTennguyendon.Enabled = txtND_Namsinh.Enabled = ddlND_Quoctich.Enabled = txtND_Ngaysinh.Enabled = hdTrangThaiXacThuc.Value != "1";
        }
        #endregion

        #region "Phân trang"

        protected void lbTBack_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            LoadGrid();
        }

        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadGrid();
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            LoadGrid();
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            LoadGrid();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex.Value = lbCurrent.Text;
            LoadGrid();
        }

        #endregion
    }
}