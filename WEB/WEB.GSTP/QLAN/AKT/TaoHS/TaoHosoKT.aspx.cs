using BL.GSTP;
using BL.GSTP.AKT;
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
using System.Web.Script.Serialization;

namespace WEB.GSTP.QLAN.AKT.TaoHS
{
    public partial class TaoHosoKT : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private const decimal ROOT = 0;
        private const decimal KHANGCAO = 1, KHANGNGHI = 2;
        public decimal DonID = 0;
        public string usercurent = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                DonID = (string.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + "");
                usercurent = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                LoadCombobox();
                qlhl_check_load(2);
                ddlLoaiNguyendon_SelectedIndexChanged(sender, e);
                ddlLoaiBidon_SelectedIndexChanged(sender, e);
                string current_id = Request["ID"] + "";
                string strtype = Request["type"] + "";
                DsDuongSu1.Visible = false;
                DsDuongSu1.DonID = 0;
                ltCMNDND.Text = "<span style='color:red'>(*)</span>";
                ltCMNDBD.Text = "<span style='color:red'>(*)</span>";
                string strDonID = Session["KT_THEMDSK"] + "";
                if (strtype == "new")
                {
                    
                    if (strDonID != "")
                    {
                        hddID.Value = Session["KT_THEMDSK"] + "";
                        decimal ID = Convert.ToDecimal(Session["KT_THEMDSK"]);
                        LoadInfo(ID);
                        DsDuongSu1.Visible = true;
                        DsDuongSu1.DonID = ID;
                        DsDuongSu1.ReLoad();

                        uDSNguoiThamGiaToTung.Visible = true;
                        uDSNguoiThamGiaToTung.Donid = ID;
                        uDSNguoiThamGiaToTung.LoadGrid();
                    }
                }
                else if (strtype == "list")
                {
                    if (current_id != "" && current_id != "0")
                    {
                        hddID.Value = current_id.ToString();
                        decimal ID = Convert.ToDecimal(current_id);
                        LoadInfo(ID);
                        DsDuongSu1.Visible = true;
                        DsDuongSu1.DonID = ID;
                        DsDuongSu1.ReLoad();

                        uDSNguoiThamGiaToTung.Visible = true;
                        uDSNguoiThamGiaToTung.Donid = ID;
                        uDSNguoiThamGiaToTung.LoadGrid();
                    }
                }
                else
                {
                    current_id = Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + "";
                    if (current_id != "" && current_id != "0")
                    {
                        hddID.Value = current_id.ToString();
                        decimal ID = Convert.ToDecimal(current_id);
                        LoadInfo(ID);
                        DsDuongSu1.Visible = true;
                        DsDuongSu1.DonID = ID;
                        DsDuongSu1.ReLoad();

                        uDSNguoiThamGiaToTung.Visible = true;
                        uDSNguoiThamGiaToTung.Donid = ID;
                        uDSNguoiThamGiaToTung.LoadGrid();
                        pnNguoiTGTT.Visible = true;
                        pnThemDS.Visible = true;
                    }
                    else
                    {
                        pnNguoiTGTT.Visible = false;
                        pnThemDS.Visible = false;
                    }
                }
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));

                Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                Cls_Comon.SetButton(cmdUpdateSelect, oPer.CAPNHAT);
                Cls_Comon.SetButton(cmdUpdateKCKN, oPer.CAPNHAT);


                AKT_PHUCTHAM_THULY oTLPT = dt.AKT_PHUCTHAM_THULY.Where(x => x.DONID == DonID).FirstOrDefault() ?? new AKT_PHUCTHAM_THULY();
                if (oTLPT.ID > 0){
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdUpdateSelect, false);
                    Cls_Comon.SetButton(cmdUpdateKCKN, false);
                    Cls_Comon.SetButton(cmdXoaHoSo, false);
                }

            }
            DsDuongSu1.DonID = Convert.ToDecimal(hddID.Value);
            uDSNguoiThamGiaToTung.Donid = Convert.ToDecimal(hddID.Value);
        }
        #region Thiều
        protected void chkBoxCMNDND_CheckedChanged(object sender, EventArgs e)
        {

            if (!chkBoxCMNDND.Checked)
            {
                ltCMNDND.Text = "<span style='color:red'>(*)</span>";
            }
            else
            {
                ltCMNDND.Text = "";
            }

        }
        protected void chkBoxCMNDBD_CheckedChanged(object sender, EventArgs e)
        {

            if (!chkBoxCMNDBD.Checked)
            {
                ltCMNDBD.Text = "<span style='color:red'>(*)</span>";
            }
            else
            {
                ltCMNDBD.Text = "";
            }

        }
        #endregion
        private void SetTinhHuyenMacDinh()
        {
            //Set defaul value Tinh/Huyen dua theo tai khoan dang nhap
            Cls_Comon.SetValueComboBox(ddlNDD_Tinh_NguyenDon, Session[ENUM_SESSION.SESSION_TINH_ID]);
            LoadDropNDD_Huyen_NguyenDon();
            Cls_Comon.SetValueComboBox(ddlNDD_Huyen_NguyenDon, Session[ENUM_SESSION.SESSION_QUAN_ID]);

            Cls_Comon.SetValueComboBox(ddlNDD_Tinh_BiDon, Session[ENUM_SESSION.SESSION_TINH_ID]);
            LoadDropNDD_Huyen_BiDon();
            Cls_Comon.SetValueComboBox(ddlNDD_Huyen_BiDon, Session[ENUM_SESSION.SESSION_QUAN_ID]);
           
           Cls_Comon.SetValueComboBox(ddlTamTru_Tinh_NguyenDon, Session[ENUM_SESSION.SESSION_TINH_ID]);
            LoadDropTamTru_Huyen_NguyenDon();
            Cls_Comon.SetValueComboBox(ddlTamTru_Huyen_NguyenDon, Session[ENUM_SESSION.SESSION_QUAN_ID]);
           
            Cls_Comon.SetValueComboBox(ddlTamTru_Tinh_BiDon, Session[ENUM_SESSION.SESSION_TINH_ID]);
            LoadDropTamTru_Huyen_BiDon();
            Cls_Comon.SetValueComboBox(ddlTamTru_Huyen_BiDon, Session[ENUM_SESSION.SESSION_QUAN_ID]);
          
        }
       
        private void LoadInfo(decimal ID)
        {
            AKT_DON oT = dt.AKT_DON.Where(x => x.ID == ID).FirstOrDefault();
            if (oT != null)
            {
                txtTenVuViec.Text = oT.TENVUVIEC;
                txtQuanhephapluat_name(oT);
                if (oT.QHPLTKID != null)
                {
                    ddlQHPLTK.SelectedValue = oT.QHPLTKID.ToString();
                    qlhl_check_load(2);
                }
                //Load ra thông tin BA/QĐ
                AKT_SOTHAM_BANAN oBA = dt.AKT_SOTHAM_BANAN.Where(x => x.DONID == oT.ID).FirstOrDefault() ?? new AKT_SOTHAM_BANAN();
                if (oBA.ID > 0)
                {
                    rdbLoaiBAQD.SelectedValue = "1";
                    ddlToaxxST.SelectedValue = oBA.TOAANID + "";
                    txtSobanan.Text = oBA.SOBANAN;
                    txtNgayBA.Text = (((DateTime)oBA.NGAYTUYENAN) == DateTime.MinValue) ? "" : ((DateTime)oBA.NGAYTUYENAN).ToString("dd/MM/yyyy", cul);
                    pnBanan.Visible = true;
                    pnQD.Visible = false;
                }
                else
                {
                    AKT_SOTHAM_QUYETDINH oQD = dt.AKT_SOTHAM_QUYETDINH.Where(x => x.DONID == oT.ID).FirstOrDefault() ?? new AKT_SOTHAM_QUYETDINH();
                    if (oQD.ID > 0)
                    {
                        rdbLoaiBAQD.SelectedValue = "0";
                        ddlToaxxST.SelectedValue = oQD.TOAANID + "";
                        ddlQuyetdinh.SelectedValue = oQD.QUYETDINHID.ToString();
                        txtSoQD.Text = oQD.SOQD;
                        txtNgayQD.Text = (((DateTime)oQD.NGAYQD) == DateTime.MinValue) ? "" : ((DateTime)oQD.NGAYQD).ToString("dd/MM/yyyy", cul);
                        pnBanan.Visible = false;
                        pnQD.Visible = true;
                    }
                }
                //Load Chuyển án và nhận án
                AKT_CHUYEN_NHAN_AN oCN = dt.AKT_CHUYEN_NHAN_AN.Where(x => x.VUANID == oT.ID).FirstOrDefault<AKT_CHUYEN_NHAN_AN>();
                if (oCN != null)
                {
                    ddlNguoinhanHS.SelectedValue = oCN.NGUOINHANID.ToString();
                    txtNgayNhanHS.Text = (((DateTime)oCN.NGAYNHAN) == DateTime.MinValue) ? "" : ((DateTime)oCN.NGAYNHAN).ToString("dd/MM/yyyy", cul);
                    txtSoButLuc.Text = oCN.SOBUTLUC + "";
                }
                //Load KCKN hddKCID
                LoadComboboxKhangCao(oT.ID);
                LoadComboboxKhangNghi();
                LoadGridKCKN();

                //Load Nguyên đơn
                #region "NGUYÊN ĐƠN ĐẠI DIỆN"
                List<AKT_DON_DUONGSU> lstNguyendon = dt.AKT_DON_DUONGSU.Where(x => x.DONID == oT.ID && x.ISDAIDIEN == 1 && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON).ToList();
                AKT_DON_DUONGSU oND = new AKT_DON_DUONGSU();
                DM_HANHCHINH_BL oHCBL = new DM_HANHCHINH_BL();
                if (lstNguyendon.Count > 0)
                {
                    oND = lstNguyendon[0];
                    txtTennguyendon.Text = oND.TENDUONGSU;
                    ddlLoaiNguyendon.SelectedValue = oND.LOAIDUONGSU.ToString();
                    if (ddlLoaiNguyendon.SelectedValue == "1")
                    {
                        pnNDCanhan.Visible = true;
                        pnNDTochuc.Visible = false;
                        //chkISBVQLNK.Visible = false;
                    }
                    else
                    {
                        pnNDCanhan.Visible = false;
                        pnNDTochuc.Visible = true;
                        //chkISBVQLNK.Visible = true;
                        //if (oND.ISBVQLNGUOIKHAC == 1) chkISBVQLNK.Checked = true;
                    }
                    #region Thiều
                    if (string.IsNullOrEmpty(oND.SOCMND))
                    {
                        chkBoxCMNDND.Checked = true;

                        ltCMNDND.Text = "";
                    }
                    else
                    {
                        ltCMNDND.Text = "<span style='color:red'>(*)</span>";
                        chkBoxCMNDND.Checked = false;
                    }
                    #endregion
                    txtND_CMND.Text = oND.SOCMND;
                    ddlND_Quoctich.SelectedValue = oND.QUOCTICHID.ToString();
                    if (oND.TAMTRUTINHID != null)
                    {
                        ddlTamTru_Tinh_NguyenDon.SelectedValue = oND.TAMTRUTINHID.ToString();
                        LoadDropTamTru_Huyen_NguyenDon();
                        if (oND.TAMTRUID != null)
                        {
                            ddlTamTru_Huyen_NguyenDon.SelectedValue = oND.TAMTRUID.ToString();
                        }
                    }
                    txtND_TTChitiet.Text = oND.TAMTRUCHITIET;
                    txtND_NoiLamViec.Text = oND.DIACHICOQUAN;

                    if (oND.NGAYSINH != DateTime.MinValue) txtND_Ngaysinh.Text = ((DateTime)oND.NGAYSINH).ToString("dd/MM/yyyy", cul);
                    txtND_Namsinh.Text = oND.NAMSINH == 0 ? "" : oND.NAMSINH.ToString();
                    //txtND_Tuoi.Text = oND.TUOI == 0 ? "" : oND.TUOI.ToString();
                    ddlND_Gioitinh.SelectedValue = oND.GIOITINH.ToString();
                    txtND_NDD_Ten.Text = oND.NGUOIDAIDIEN;
                    txtND_NDD_Chucvu.Text = oND.CHUCVU;
                    if (oND.NDD_DIACHIID != null)
                    {
                        DM_HANHCHINH Huyen_NDD_NguyenDon = dt.DM_HANHCHINH.Where(x => x.ID == oND.NDD_DIACHIID).FirstOrDefault<DM_HANHCHINH>();
                        if (Huyen_NDD_NguyenDon != null)
                        {
                            ddlNDD_Tinh_NguyenDon.SelectedValue = Huyen_NDD_NguyenDon.CAPCHAID.ToString();
                            LoadDropNDD_Huyen_NguyenDon();
                            ddlNDD_Huyen_NguyenDon.SelectedValue = Huyen_NDD_NguyenDon.ID.ToString();
                        }
                    }
                    txtND_NDD_Diachichitiet.Text = oND.NDD_DIACHICHITIET;
                    txtND_Email.Text = oND.EMAIL + "";
                    txtND_Dienthoai.Text = oND.DIENTHOAI + "";
                    txtND_Fax.Text = oND.FAX + "";
                    if (oND.SINHSONG_NUOCNGOAI != null) chkND_ONuocNgoai.Checked = oND.SINHSONG_NUOCNGOAI == 1 ? true : false;
                    if (ddlND_Quoctich.SelectedIndex > 0)
                    {
                        //lblND_Batbuoc1.Text = 
                        lblND_Batbuoc2.Text = "";
                        chkND_ONuocNgoai.Visible = false;
                    }
                    else
                    {
                        //lblND_Batbuoc1.Text = 
                        lblND_Batbuoc2.Text = "(*)";
                        chkND_ONuocNgoai.Visible = true;
                    }
                    if (chkND_ONuocNgoai.Checked)
                    {
                        // lblND_Batbuoc1.Text = 
                        lblND_Batbuoc2.Text = "";
                    }
                    else
                    {
                        //lblND_Batbuoc1.Text = 
                        lblND_Batbuoc2.Text = "(*)";
                    }
                }
                #endregion
                //Load Bị đơn
                #region "BỊ ĐƠN ĐẠI DIỆN"
                List<AKT_DON_DUONGSU> lstBidon = dt.AKT_DON_DUONGSU.Where(x => x.DONID == oT.ID && x.ISDAIDIEN == 1 && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.BIDON).ToList();
                AKT_DON_DUONGSU oBD = new AKT_DON_DUONGSU();
                if (lstBidon.Count > 0)
                {
                    oBD = lstBidon[0];
                    txtBD_Ten.Text = oBD.TENDUONGSU;

                    ddlLoaiBidon.SelectedValue = oBD.LOAIDUONGSU.ToString();
                    if (ddlLoaiBidon.SelectedValue == "1")
                    {
                        pnBD_Canhan.Visible = true;
                        pnBD_Tochuc.Visible = false;
                    }
                    else
                    {
                        pnBD_Canhan.Visible = false;
                        pnBD_Tochuc.Visible = true;
                    }
                    #region Thiều
                    if (string.IsNullOrEmpty(oBD.SOCMND))
                    {
                        chkBoxCMNDBD.Checked = true;
                        ltCMNDBD.Text = "";
                    }
                    else
                    {
                        ltCMNDBD.Text = "<span style='color:red'>(*)</span>";
                        chkBoxCMNDBD.Checked = false;
                    }
                    #endregion
                    txtBD_CMND.Text = oBD.SOCMND;
                    ddlBD_Quoctich.SelectedValue = oBD.QUOCTICHID.ToString();

                    if (oBD.TAMTRUTINHID != null)
                    {
                        ddlTamTru_Tinh_BiDon.SelectedValue = oBD.TAMTRUTINHID.ToString();
                        LoadDropTamTru_Huyen_BiDon();
                        if (oBD.TAMTRUID != null)
                        {
                            ddlTamTru_Huyen_BiDon.SelectedValue = oBD.TAMTRUID.ToString();
                        }
                    }
                    txtBD_Tamtru_Chitiet.Text = oBD.TAMTRUCHITIET;
                    txtBD_NoiLamViec.Text = oBD.DIACHICOQUAN + "";

                    if (oBD.NGAYSINH != DateTime.MinValue) txtBD_Ngaysinh.Text = ((DateTime)oBD.NGAYSINH).ToString("dd/MM/yyyy", cul);
                    txtBD_Namsinh.Text = oBD.NAMSINH == 0 ? "" : oBD.NAMSINH.ToString();
                    ddlBD_Gioitinh.SelectedValue = oBD.GIOITINH.ToString();
                    txtBD_NDD_Chucvu.Text = oBD.CHUCVU;
                    txtBD_Email.Text = oBD.EMAIL + "";
                    txtBD_Dienthoai.Text = oBD.DIENTHOAI + "";
                    txtBD_Fax.Text = oBD.FAX + "";
                    if (oBD.SINHSONG_NUOCNGOAI != null) chkBD_ONuocNgoai.Checked = oBD.SINHSONG_NUOCNGOAI == 1 ? true : false;
                    if (oBD.NDD_DIACHIID != null)
                    {
                        DM_HANHCHINH Huyen_NDD_BiDon = dt.DM_HANHCHINH.Where(x => x.ID == oBD.NDD_DIACHIID).FirstOrDefault<DM_HANHCHINH>();
                        if (Huyen_NDD_BiDon != null)
                        {
                            ddlNDD_Tinh_BiDon.SelectedValue = Huyen_NDD_BiDon.CAPCHAID.ToString();
                            LoadDropNDD_Huyen_BiDon();
                            ddlNDD_Huyen_BiDon.SelectedValue = Huyen_NDD_BiDon.ID.ToString();
                        }
                    }
                    txtBD_NDD_Diachichitiet.Text = oBD.NDD_DIACHICHITIET;
                    txtBD_NDD_ten.Text = oBD.NGUOIDAIDIEN;
                    if (ddlBD_Quoctich.SelectedIndex > 0)
                    {
                        chkBD_ONuocNgoai.Visible = false;
                    }
                    else
                    {
                        chkBD_ONuocNgoai.Visible = true;
                    }

                }
                #endregion
                ddlThuly.SelectedIndex = Convert.ToInt16(oT.TRUONGHOPTHULY);
                if (oT.TRUONGHOPTHULY == 1) //Nếu thụ lý lại thì ẩn kháng cáo kháng nghị
                {
                    pnKhangCao.Visible = false;
                    lastPanel.Visible = false;
                    cmdUpdate.Visible = false;
                }
                else if (oT.TRUONGHOPTHULY == 0)
                {
                    pnKhangCao.Visible = true;
                    lastPanel.Visible = true;
                    cmdUpdate.Visible = true;
                }
            }
        }
        private bool CheckValid()
        {
            if (txtQuanhephapluat.Text == null || txtQuanhephapluat.Text == "")
            {
                lstMsgT.Text = lstMsgB.Text = "Chưa nhập quan hệ pháp luật.";
                txtQuanhephapluat.Focus();
                return false;
            }
            if (txtQuanhephapluat.Text.Trim().Length >= 500)
            {
                lstMsgT.Text = lstMsgB.Text = "Quan hệ pháp luật nhập quá dài.";
                txtQuanhephapluat.Focus();
                return false;
            }
            #region Thiều
            if (!chkBoxCMNDND.Checked)
            {
                if (string.IsNullOrEmpty(txtND_CMND.Text))
                {
                    lstMsgT.Text = lstMsgB.Text = "Bạn chưa nhập Số CMND/ Thẻ căn cước/ Hộ chiếu.";
                    txtND_CMND.Focus();
                    return false;
                }

            }

            if (!chkBoxCMNDBD.Checked)
            {
                if (string.IsNullOrEmpty(txtBD_CMND.Text))
                {
                    lstMsgT.Text = lstMsgB.Text = "Bạn chưa nhập Số CMND/ Thẻ căn cước/ Hộ chiếu.";
                    txtBD_CMND.Focus();
                    return false;
                }

            }
            #endregion
            if (ddlToaxxST.SelectedIndex == 0)
            {
                lstMsgT.Text = lstMsgB.Text = "Bạn chưa chọn Tòa xét xử Sơ thẩm.";
                Cls_Comon.SetFocus(this, this.GetType(), ddlQHPLTK.ClientID);
                return false;
            }

            if (txtTenVuViec.Text.Trim() == "")
            {
                lstMsgT.Text = lstMsgB.Text = "Bạn chưa nhập tên Vụ việc.";
                txtTenVuViec.Focus();
                return false;
            }

            if (ddlQHPLTK.SelectedIndex == 0)
            {
                lstMsgT.Text = lstMsgB.Text = "Bạn chưa chọn quan hệ pháp luật dùng thống kê.";
                Cls_Comon.SetFocus(this, this.GetType(), ddlQHPLTK.ClientID);
                return false;
            }
            decimal IDChitieuTK = Convert.ToDecimal(ddlQHPLTK.SelectedValue);
            if (dt.DM_QHPL_TK.Where(x => x.PARENT_ID == IDChitieuTK).ToList().Count > 0)
            {
                lstMsgT.Text = lstMsgB.Text = "Quan hệ pháp luật dùng cho thống kê chỉ được chọn mã con. Hãy chọn lại.";
                Cls_Comon.SetFocus(this, this.GetType(), ddlQHPLTK.ClientID);
                return false;
            }

            // Nhận hồ sơ
            if (ddlNguoinhanHS.SelectedIndex == 0)
            {
                lstMsgT.Text = lstMsgB.Text = "Bạn chưa chọn Người nhận Hồ sơ.";
                Cls_Comon.SetFocus(this, this.GetType(), ddlNguoinhanHS.ClientID);
                return false;
            }
            if (txtNgayNhanHS.Text == "")
            {
                lstMsgT.Text = lstMsgB.Text = "Bạn chưa nhập ngày nhận Hồ sơ.";
                txtNgayNhanHS.Focus();
                return false;
            }
            if (Cls_Comon.IsValidDate(txtNgayNhanHS.Text) == false)
            {
                lstMsgT.Text = lstMsgB.Text = "Bạn phải nhập ngày nhận Hồ sơ theo định dạng dd/MM/yyyy.";
                txtNgayNhanHS.Focus();
                return false;
            }
            //if (txtSoButLuc.Text == "")
            //{
            //    lstMsgT.Text = lstMsgB.Text = "Bạn chưa nhập Số bút lục Hồ sơ.";
            //    txtSoButLuc.Focus();
            //    return false;
            //}

            // Bị đơn
            if (txtTennguyendon.Text == "")
            {
                lstMsgT.Text = lstMsgB.Text = "Bạn chưa nhập tên nguyên đơn.";
                txtTennguyendon.Focus();
                return false;
            }
            else if (txtTennguyendon.Text.Length > 250)
            {
                lstMsgT.Text = lstMsgB.Text = "Tên nguyên đơn không nhập quá 250 ký tự.";
                txtTennguyendon.Focus();
                return false;
            }
            if (pnNDCanhan.Visible)// cá nhân
            {
                if (txtND_Ngaysinh.Text != "")
                {
                    if (Cls_Comon.IsValidDate(txtND_Ngaysinh.Text) == false)
                    {
                        lstMsgT.Text = lstMsgB.Text = "Bạn chưa nhập ngày sinh nguyên đơn theo định dạng dd/MM/yyyy. Hãy nhập lại.";
                        txtND_Ngaysinh.Focus();
                        return false;
                    }
                    DateTime NgaySinh_ND = DateTime.Parse(txtND_Ngaysinh.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                    if (NgaySinh_ND > DateTime.Now)
                    {
                        lstMsgT.Text = lstMsgB.Text = "Ngày sinh nguyên đơn không được lớn hơn ngày hiện tại. Hãy nhập lại.";
                        txtND_Ngaysinh.Focus();
                        return false;
                    }
                    
                }
                if (txtND_Namsinh.Text == "")
                {
                    lstMsgT.Text = lstMsgB.Text = "Bạn chưa nhập năm sinh nguyên đơn.";
                    txtND_Namsinh.Focus();
                    return false;
                }
                else
                {
                    if (txtND_Namsinh.Text.Trim().Length < 4)
                    {
                        lstMsgT.Text = lstMsgB.Text = "Năm sinh của nguyên đơn phải là số gồm 04 chữ số. Hãy kiểm tra lại.";
                        Cls_Comon.SetFocus(this, this.GetType(), txtND_Namsinh.ClientID);
                        return false;
                    }
                    int namsinh = Convert.ToInt32(txtND_Namsinh.Text);
                    if (namsinh == 0)
                    {
                        lstMsgT.Text = lstMsgB.Text = "Năm sinh của nguyên đơn phải lớn hơn 0. Hãy kiểm tra lại.";
                        Cls_Comon.SetFocus(this, this.GetType(), txtND_Namsinh.ClientID);
                        return false;
                    }
                   
                    else if (namsinh > DateTime.Now.Year)
                    {
                        lstMsgT.Text = lstMsgB.Text = "Năm sinh của nguyên đơn không thể lớn hơn năm hiện tại. Hãy kiểm tra lại!";
                        Cls_Comon.SetFocus(this, this.GetType(), txtND_Namsinh.ClientID);
                        return false;
                    }
                }
                
                if (txtND_NoiLamViec.Text.Trim().Length > 500)
                {
                    lstMsgT.Text = lstMsgB.Text = "Nơi làm việc của nguyên đơn không nhập quá 500 ký tự.";
                    Cls_Comon.SetFocus(this, this.GetType(), txtND_NoiLamViec.ClientID);
                    return false;
                }
            }
            int lengthEmail_ND = txtND_Email.Text.Trim().Length;
            if (lengthEmail_ND > 0)
            {
                if (lengthEmail_ND > 250)
                {
                    lstMsgT.Text = lstMsgB.Text = "Email của nguyên đơn không nhập quá 250 ký tự. Hãy nhập lại.";
                    Cls_Comon.SetFocus(this, this.GetType(), txtND_Email.ClientID);
                    return false;
                }
                string email = txtND_Email.Text.Trim();
                int atpos = email.IndexOf("@");
                var dotpos = email.LastIndexOf(".");
                if (atpos < 1 || dotpos < atpos + 2 || dotpos + 2 >= lengthEmail_ND)
                {
                    lstMsgT.Text = lstMsgB.Text = "Địa chỉ email của nguyên đơn chưa đúng.";
                    Cls_Comon.SetFocus(this, this.GetType(), txtND_Email.ClientID);
                    return false;
                }
            }
            // Bị đơn
            decimal _option = 0;
            if (ddlQHPLTK.SelectedValue != "0")
            {
                Decimal qhplid = Convert.ToDecimal(ddlQHPLTK.SelectedValue);
                DM_QHPL_TK qhpltk = dt.DM_QHPL_TK.Where(x => x.ID == qhplid).FirstOrDefault();
                _option = Convert.ToDecimal(qhpltk.OPTIONS);
            }
            if (_option == 0)
            {
                if (txtBD_Ten.Text == "")
                {
                    lstMsgT.Text = lstMsgB.Text = "Bạn chưa nhập tên bị đơn.";
                    txtBD_Ten.Focus();
                    return false;
                }
                else if (txtBD_Ten.Text.Length > 250)
                {
                    lstMsgT.Text = lstMsgB.Text = "Tên bị đơn không nhập quá 250 ký tự.";
                    txtBD_Ten.Focus();
                    return false;
                }
            }
            if (pnBD_Canhan.Visible)// Cá nhân
            {
                if (txtBD_Ngaysinh.Text != "")
                {
                    if (Cls_Comon.IsValidDate(txtBD_Ngaysinh.Text) == false)
                    {
                        lstMsgT.Text = lstMsgB.Text = "Bạn chưa nhập ngày sinh bị đơn theo định dạng dd/MM/yyyy. Hãy nhập lại.";
                        txtBD_Ngaysinh.Focus();
                        return false;
                    }
                    DateTime NgaySinh_BD = DateTime.Parse(txtBD_Ngaysinh.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                    if (NgaySinh_BD > DateTime.Now)
                    {
                        lstMsgT.Text = lstMsgB.Text = "Ngày sinh bị đơn không được lớn hơn ngày hiện tại. Hãy nhập lại.";
                        txtBD_Ngaysinh.Focus();
                        return false;
                    }
                   
                }
                if (txtBD_Namsinh.Text != "")
                {
                    if (txtBD_Namsinh.Text.Trim().Length < 4)
                    {
                        lstMsgT.Text = lstMsgB.Text = "Năm sinh của bị đơn phải là số gồm 04 chữ số. Hãy kiểm tra lại.";
                        Cls_Comon.SetFocus(this, this.GetType(), txtBD_Namsinh.ClientID);
                        return false;
                    }
                    int namsinh = Convert.ToInt32(txtBD_Namsinh.Text);
                    if (namsinh == 0)
                    {
                        lstMsgT.Text = lstMsgB.Text = "Năm sinh của bị đơn phải lớn hơn 0. Hãy kiểm tra lại.";
                        Cls_Comon.SetFocus(this, this.GetType(), txtBD_Namsinh.ClientID);
                        return false;
                    }
                    
                    else if (namsinh > DateTime.Now.Year)
                    {
                        lstMsgT.Text = lstMsgB.Text = "Năm sinh của bị đơn không thể lớn hơn năm hiện tại. Hãy kiểm tra lại!";
                        Cls_Comon.SetFocus(this, this.GetType(), txtBD_Namsinh.ClientID);
                        return false;
                    }
                }
                if (txtBD_NoiLamViec.Text.Trim().Length > 500)
                {
                    lstMsgT.Text = lstMsgB.Text = "Nơi làm việc của bị đơn không nhập quá 500 ký tự.";
                    Cls_Comon.SetFocus(this, this.GetType(), txtBD_NoiLamViec.ClientID);
                    return false;
                }
            }
            int lengthEmail_BD = txtBD_Email.Text.Trim().Length;
            if (lengthEmail_BD > 0)
            {
                if (lengthEmail_BD > 250)
                {
                    lstMsgT.Text = lstMsgB.Text = "Email của bị đơn không nhập quá 250 ký tự. Hãy nhập lại.";
                    Cls_Comon.SetFocus(this, this.GetType(), txtBD_Email.ClientID);
                    return false;
                }
                string email = txtBD_Email.Text.Trim();
                int atpos = email.IndexOf("@");
                var dotpos = email.LastIndexOf(".");
                if (atpos < 1 || dotpos < atpos + 2 || dotpos + 2 >= lengthEmail_BD)
                {
                    lstMsgT.Text = lstMsgB.Text = "Địa chỉ email của bị đơn chưa đúng.";
                    Cls_Comon.SetFocus(this, this.GetType(), txtBD_Email.ClientID);
                    return false;
                }
            }
            return true;
        }
        private void ResetControls()
        {
            txtQuanhephapluat.Text = null;
            ddlQuanhephapluat.SelectedIndex = 0;

            txtTenVuViec.Text = "";
          
            txtTennguyendon.Text = "";
            txtND_CMND.Text = "";
            txtND_Ngaysinh.Text = "";
            txtND_Namsinh.Text = "";
            //  txtND_HKTT_Chitiet.Text = "";
            txtND_TTChitiet.Text = "";
            txtND_NDD_Diachichitiet.Text = "";
            chkND_ONuocNgoai.Checked = chkBD_ONuocNgoai.Checked = false;
            txtBD_Ten.Text = "";
            txtBD_CMND.Text = "";
            txtBD_Ngaysinh.Text = txtBD_Namsinh.Text = "";
            //txtBD_HKTT_Chitiet.Text = "";
            txtBD_Tamtru_Chitiet.Text = "";
            txtBD_NDD_Diachichitiet.Text = "";
            hddID.Value = "0";
        }


        private void LoadCombobox()
        {
            ddlToaxxST.Items.Clear();

            DM_TOAAN_BL oT = new DM_TOAAN_BL();
            ddlToaxxST.DataSource = oT.DM_TOAAN_GETBY_PARENT("3", Session[ENUM_SESSION.SESSION_DONVIID] + "", Session["CAP_XET_XU"] + "");
            //ddlToaxxST.DataSource = oBL.dm
            ddlToaxxST.DataTextField = "arrTEN";
            ddlToaxxST.DataValueField = "ID";
            ddlToaxxST.DataBind();
            ddlToaxxST.Items.Insert(0, new ListItem("--- Chọn Tòa xét xử Sơ Thẩm ---", "0"));
            ddlToaxxST.SelectedValue = "0";
            string current_Donid = Session[ENUM_SESSION.SESSION_DONVIID] + "";
            ddlToaxxST.Items.Remove(ddlToaxxST.Items.FindByValue(current_Donid));

            //---Load ra Quyết định Vụ án
            // Quyết định bắt tạm giam không hiển thị ở quyết định vụ án (ISDUONGSUYEUCAU=1)
            decimal LoaiQD = 0;
            DM_QD_LOAI objLoaiQD = dt.DM_QD_LOAI.Where(x => x.HIEULUC == 1 && x.ISDANSU == 1 && x.MA == "DC").FirstOrDefault();
            if (objLoaiQD != null)
            {
                LoaiQD = objLoaiQD.ID;
            }
            ddlQuyetdinh.Items.Clear();
            List<DM_QD_QUYETDINH> lst = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == LoaiQD && x.ISKDTM == 1 && x.ISSOTHAM == 1).OrderBy(y => y.TEN).ToList();
            if (lst != null && lst.Count > 0)
            {
                ddlQuyetdinh.DataSource = lst;
                ddlQuyetdinh.DataTextField = "TEN";
                ddlQuyetdinh.DataValueField = "ID";
                ddlQuyetdinh.DataBind();
            }
            ddlQuyetdinh.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            ddlQuyetdinh.Items.Insert(1, new ListItem("93-DS. Quyết định giải quyết việc dân sự", "11"));
            ddlQuyetdinh.Items.Insert(2, new ListItem("19-VDS. Quyết định đình chỉ việc xét đơn yêu cầu giải quyết việc dân sự", "422"));
            ddlQuyetdinh.Items.Insert(3, new ListItem("20-VDS. Quyết định đình chỉ giải quyết sơ thẩm việc dân sự", "423"));
            ddlQuyetdinh.Items.Insert(4, new ListItem("22-VDS. Quyết định sơ thẩm giải quyết việc dân sự", "425"));

            ddlQuyetdinh.SelectedIndex = 0;
            //Load Nguoi nhan HS 
            LoadDrop_TTV_TK();

            //Load Quan hệ pháp luật
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            ddlQuanhephapluat.Items.Clear();
            ddlQuanhephapluat.DataSource = oBL.DM_DATAITEM_GETBY2GROUPNAME(ENUM_DANHMUC.QUANHEPL_YEUCAU_KDTM, ENUM_DANHMUC.QUANHEPL_TRANHCHAP_KDTM);
            ddlQuanhephapluat.DataTextField = "TEN";
            ddlQuanhephapluat.DataValueField = "ID";
            ddlQuanhephapluat.DataBind();
            //Load QHPL Thống kê.
            ddlQHPLTK.Items.Clear();
            ddlQHPLTK.DataSource = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.KINHDOANH_THUONGMAI && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
            ddlQHPLTK.DataTextField = "CASE_NAME";
            ddlQHPLTK.DataValueField = "ID";
            ddlQHPLTK.DataBind();
            ddlQHPLTK.Items.Insert(0, new ListItem("--Chọn QHPL dùng thống kê--", "0"));

            //Load quốc tịch
            DataTable dtQuoctich = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.QUOCTICH);
            ddlND_Quoctich.Items.Clear();
            ddlND_Quoctich.DataSource = dtQuoctich;
            ddlND_Quoctich.DataTextField = "TEN";
            ddlND_Quoctich.DataValueField = "ID";
            ddlND_Quoctich.DataBind();
            ddlBD_Quoctich.Items.Clear();
            ddlBD_Quoctich.DataSource = dtQuoctich;
            ddlBD_Quoctich.DataTextField = "TEN";
            ddlBD_Quoctich.DataValueField = "ID";
            ddlBD_Quoctich.DataBind();

            LoadDropTinh();

            //Load thong tin kháng cáo
            decimal vDonid = Convert.ToDecimal(hddID.Value);
            LoadComboboxKhangCao(vDonid);
            LoadComboboxKhangNghi();
            LoadGridKCKN();
        }
        protected void LoadDrop_TTV_TK()
        {
            Decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
            DM_CANBO_BL objBL = new DM_CANBO_BL();
            DataTable tbl = null;

            tbl = objBL.GET_ThuKy_TTVS_CV(ToaAnID.ToString());
            ddlNguoinhanHS.DataSource = tbl;
            ddlNguoinhanHS.DataTextField = "MA_TEN";
            ddlNguoinhanHS.DataValueField = "ID";
            ddlNguoinhanHS.DataBind();
            ddlNguoinhanHS.Items.Insert(0, new ListItem("-- Chọn --", ""));
        }

        private bool SaveData()
        {
            try
            {
                if (!CheckValid()) return false;
                SaveDuongSu_VUVIEC();

                decimal VuAnID = string.IsNullOrEmpty(hddID.Value) ? 0 : Convert.ToDecimal(hddID.Value);
                //Luu thong tin Bản án Quyết định
                if (rdbLoaiBAQD.SelectedValue == "1")
                    UpdateBanAn(VuAnID);
                else
                    UpdateQuyetDinh(VuAnID);
                // Lưu thông tin chuyển nhận án
                Chuyenan_Nhanan(VuAnID);

                pnNguoiTGTT.Visible = true;
                pnThemDS.Visible = true;

                return true;
            }
            catch (Exception ex)
            {
                lstMsgT.Text = lstMsgB.Text = "Lỗi: " + ex.Message;
                return false;
            }
        }
        public void SaveDuongSu_VUVIEC()
        {
            AKT_DON oT;
            #region "THÔNG TIN ĐƠN KHỞI KIỆN"
            if (hddID.Value == "" || hddID.Value == "0")
            {
                oT = new AKT_DON();
            }
            else
            {
                decimal ID = Convert.ToDecimal(hddID.Value);
                oT = dt.AKT_DON.Where(x => x.ID == ID).FirstOrDefault();
            }
            //oT.TENVUVIEC = txtTennguyendon.Text + " - " + txtBD_Ten.Text + " - " + ddlQuanhephapluat.SelectedItem.Text;
            // oT.SOTHUTU = (txtSothutu.Text == "") ? 0 : Convert.ToDecimal(txtSothutu.Text);
            oT.HINHTHUCNHANDON = 0;

            oT.TENVUVIEC = txtTennguyendon.Text + " - " + txtBD_Ten.Text + " - " + txtQuanhephapluat.Text;
            oT.TRUONGHOPTHULY = ddlThuly.SelectedIndex;
            oT.QUANHEPHAPLUATID = null;
            if (txtQuanhephapluat.Text != null || txtQuanhephapluat.Text != "")
                oT.QUANHEPHAPLUAT_NAME = txtQuanhephapluat.Text;
            if (txtQuanhephapluat.Text == "" || txtQuanhephapluat.Text == null)
                oT.QUANHEPHAPLUAT_NAME = null;

            oT.QHPLTKID = Convert.ToDecimal(ddlQHPLTK.SelectedValue);
            //Loai đơn mặc định là THụ lý mới 
            oT.LOAIDON = 1;

            if (hddID.Value == "" || hddID.Value == "0")
            {
                AKT_DON_BL dsBL = new AKT_DON_BL();
                oT.TOAANID = Convert.ToDecimal(ddlToaxxST.SelectedValue);
                oT.TT = dsBL.GETNEWTT((decimal)oT.TOAANID);
                oT.TRANGTHAI = ENUM_DS_TRANGTHAI.TAOMOI;
                string donvitao = ddlToaxxST.SelectedValue;
                oT.MAVUVIEC = ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI + donvitao + oT.TT.ToString();
                oT.NGAYTAO = DateTime.Now;
                oT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] +"";
                oT.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;// anhvh edit 17/04/2020 không dùng ENUM_GIAIDOANVUAN.HOSO vì không phù hợp với nghiệp vụ tòa án
                // insert toa_gq_id
                if (oT.TOA_GIAIQUYET_ID == null)
                {
                    oT.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                }
                dt.AKT_DON.Add(oT);
                dt.SaveChanges();
                hddID.Value = oT.ID.ToString();
                //anhvh add 26/06/2020
                GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                if (ddlThuly.SelectedIndex == 0)
                    GD.GAIDOAN_INSERT_UPDATE("4", oT.ID, 2, Convert.ToDecimal(ddlToaxxST.SelectedValue), 0, 0, 0, 0);
                //GD.GAIDOAN_INSERT_UPDATE("2", oT.ID,2, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]),0,0,0,0);
            }
            else
            {
                oT.NGAYSUA = DateTime.Now;
                oT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] +"";
                dt.SaveChanges();
            }
            #endregion
            //Lưu nguyên đơn đại diện
            #region "NGUYÊN ĐƠN ĐẠI DIỆN"
            List<AKT_DON_DUONGSU> lstNguyendon = dt.AKT_DON_DUONGSU.Where(x => x.DONID == oT.ID && x.ISDAIDIEN == 1 && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON).ToList();
            AKT_DON_DUONGSU oND = new AKT_DON_DUONGSU();
            if (lstNguyendon.Count > 0) oND = lstNguyendon[0];
            oND.DONID = oT.ID;
            oND.TENDUONGSU = Convert.ToDecimal(ddlLoaiNguyendon.SelectedValue) == 1 ? Cls_Comon.FormatTenRieng(txtTennguyendon.Text) : Cls_Comon.FormatTenTochuc(txtTennguyendon.Text);
            oND.ISDAIDIEN = 1;
            oND.TUCACHTOTUNG_MA = ENUM_DANSU_TUCACHTOTUNG.NGUYENDON;
            oND.LOAIDUONGSU = Convert.ToDecimal(ddlLoaiNguyendon.SelectedValue);
            //if (chkISBVQLNK.Visible)
            //    oND.ISBVQLNGUOIKHAC = chkISBVQLNK.Checked ? 1 : 0;
            //else
            //    oND.ISBVQLNGUOIKHAC = 0;
            oND.SOCMND = txtND_CMND.Text;
            oND.QUOCTICHID = Convert.ToDecimal(ddlND_Quoctich.SelectedValue);
            oND.TAMTRUTINHID = Convert.ToDecimal(ddlTamTru_Tinh_NguyenDon.SelectedValue);
            oND.TAMTRUID = Convert.ToDecimal(ddlTamTru_Huyen_NguyenDon.SelectedValue);
            oND.TAMTRUCHITIET = txtND_TTChitiet.Text;
            oND.DIACHICOQUAN = txtND_NoiLamViec.Text.Trim();

            //oND.HKTTTINHID = Convert.ToDecimal(ddlThuongTru_Tinh_NguyenDon.SelectedValue);
            //oND.HKTTID = Convert.ToDecimal(ddlThuongTru_Huyen_NguyenDon.SelectedValue);
            //oND.HKTTCHITIET = txtND_HKTT_Chitiet.Text;
            DateTime dNDNgaysinh;
            dNDNgaysinh = (String.IsNullOrEmpty(txtND_Ngaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            oND.NGAYSINH = dNDNgaysinh;

            oND.NAMSINH = txtND_Namsinh.Text == "" ? 0 : Convert.ToDecimal(txtND_Namsinh.Text);
            // oND.TUOI = txtND_Tuoi.Text == "" ? 0 : Convert.ToDecimal(txtND_Tuoi.Text);
            oND.GIOITINH = Convert.ToDecimal(ddlND_Gioitinh.SelectedValue);
            oND.NGUOIDAIDIEN = Cls_Comon.FormatTenRieng(txtND_NDD_Ten.Text);
            oND.SINHSONG_NUOCNGOAI = chkND_ONuocNgoai.Checked == true ? 1 : 0;
            oND.CHUCVU = txtND_NDD_Chucvu.Text;
            oND.EMAIL = txtND_Email.Text;
            oND.DIENTHOAI = txtND_Dienthoai.Text;
            oND.FAX = txtND_Fax.Text;
            if (pnNDTochuc.Visible)
            {
                oND.NDD_DIACHIID = Convert.ToDecimal(ddlNDD_Huyen_NguyenDon.SelectedValue);
                oND.NDD_DIACHICHITIET = txtND_NDD_Diachichitiet.Text;
            }
            oND.ISSOTHAM = 1;
            oND.ISDON = 1;
            if (lstNguyendon.Count > 0)
            {
                oND.NGAYSUA = DateTime.Now;
                oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                dt.SaveChanges();
            }
            else
            {
                oND.NGAYTAO = DateTime.Now;
                oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                // insert toa_gq_id
                if (oND.TOA_GIAIQUYET_ID == null)
                {
                    oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                }
                dt.AKT_DON_DUONGSU.Add(oND);
                dt.SaveChanges();
            }
            #endregion
            #region "BỊ ĐƠN ĐẠI DIỆN"

                List<AKT_DON_DUONGSU> lstBidon = dt.AKT_DON_DUONGSU.Where(x => x.DONID == oT.ID && x.ISDAIDIEN == 1 && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.BIDON).ToList();
                AKT_DON_DUONGSU oBD = new AKT_DON_DUONGSU();
                if (lstBidon.Count > 0) oBD = lstBidon[0];
                oBD.DONID = oT.ID;
                oBD.TENDUONGSU = Convert.ToDecimal(ddlLoaiBidon.SelectedValue) == 1 ? Cls_Comon.FormatTenRieng(txtBD_Ten.Text) : Cls_Comon.FormatTenTochuc(txtBD_Ten.Text);
                oBD.ISDAIDIEN = 1;
                oBD.TUCACHTOTUNG_MA = ENUM_DANSU_TUCACHTOTUNG.BIDON;
                oBD.LOAIDUONGSU = Convert.ToDecimal(ddlLoaiBidon.SelectedValue);
                oBD.SOCMND = txtBD_CMND.Text;
                oBD.QUOCTICHID = Convert.ToDecimal(ddlBD_Quoctich.SelectedValue);
                oBD.TAMTRUTINHID = Convert.ToDecimal(ddlTamTru_Tinh_BiDon.SelectedValue);
                oBD.TAMTRUID = Convert.ToDecimal(ddlTamTru_Huyen_BiDon.SelectedValue);
                oBD.TAMTRUCHITIET = txtBD_Tamtru_Chitiet.Text;
                oBD.DIACHICOQUAN = txtBD_NoiLamViec.Text.Trim();


                DateTime dBDNgaysinh;
                dBDNgaysinh = (String.IsNullOrEmpty(txtBD_Ngaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtBD_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oBD.NGAYSINH = dBDNgaysinh;

                oBD.NAMSINH = txtBD_Namsinh.Text == "" ? 0 : Convert.ToDecimal(txtBD_Namsinh.Text);
                //oBD.TUOI = txtBD_Tuoi.Text == "" ? 0 : Convert.ToDecimal(txtBD_Tuoi.Text);
                oBD.GIOITINH = Convert.ToDecimal(ddlBD_Gioitinh.SelectedValue);
                oBD.NGUOIDAIDIEN = Cls_Comon.FormatTenRieng(txtBD_NDD_ten.Text);
                oBD.SINHSONG_NUOCNGOAI = chkBD_ONuocNgoai.Checked == true ? 1 : 0;
                oBD.CHUCVU = txtBD_NDD_Chucvu.Text;
                oBD.EMAIL = txtBD_Email.Text;
                oBD.DIENTHOAI = txtBD_Dienthoai.Text;
                oBD.FAX = txtBD_Fax.Text;
                if (pnBD_Tochuc.Visible)
                {
                    if (ddlNDD_Huyen_BiDon.SelectedValue != "0")
                    {
                        oBD.NDD_DIACHIID = Convert.ToDecimal(ddlNDD_Huyen_BiDon.SelectedValue);
                    }
                    oBD.NDD_DIACHICHITIET = txtBD_NDD_Diachichitiet.Text;
                }
                oBD.ISSOTHAM = 1;
                oBD.ISDON = 1;
                if (lstBidon.Count > 0)
                {
                    oBD.NGAYSUA = DateTime.Now;
                    oBD.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.SaveChanges();
                }
                else
                {
                    oBD.NGAYTAO = DateTime.Now;
                    oBD.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    // insert toa_gq_id
                    if (oBD.TOA_GIAIQUYET_ID == null)
                    {
                        oBD.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    }
                    dt.AKT_DON_DUONGSU.Add(oBD);
                    dt.SaveChanges();
                }
            
            #endregion
            AKT_DON_DUONGSU_BL oDonBL = new AKT_DON_DUONGSU_BL();
            oDonBL.AKT_DON_YEUTONUOCNGOAI_UPDATE(oT.ID);
        }

        void UpdateBanAn(decimal VuAnId)
        {
            Boolean IsUpdate = false;
            DateTime date_temp;
            AKT_SOTHAM_BANAN obj = new AKT_SOTHAM_BANAN();
            if (VuAnId > 0)
            {
                obj = dt.AKT_SOTHAM_BANAN.Where(x => x.DONID == VuAnId).SingleOrDefault<AKT_SOTHAM_BANAN>();
                if (obj != null)
                    IsUpdate = true;
                else
                    obj = new AKT_SOTHAM_BANAN();
            }
            else
                obj = new AKT_SOTHAM_BANAN();

            obj.DONID = VuAnId;
            //-----------------------------------------   
            date_temp = (String.IsNullOrEmpty(txtNgayBA.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayBA.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.NGAYTUYENAN = date_temp;
            //-----------------------------------------
            Decimal ToaAnID = Convert.ToDecimal(ddlToaxxST.SelectedValue);
            obj.TOAANID = ToaAnID;
            obj.SOBANAN = txtSobanan.Text.Trim();
            if (IsUpdate)
            {
                obj.NGAYSUA = DateTime.Now;
                obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] +"";
                dt.SaveChanges();
            }
            else
            {
                obj.NGAYTAO = DateTime.Now;
                obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] +"";
                // insert toa_gq_id
                if (obj.TOA_GIAIQUYET_ID == null)
                {
                    obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                }
                dt.AKT_SOTHAM_BANAN.Add(obj);
                dt.SaveChanges();
                hddBAQDID.Value = obj.ID + "";
            }

        }
        void UpdateQuyetDinh(decimal VuAnId)
        {
            Boolean IsUpdate = false;
            AKT_SOTHAM_QUYETDINH oND = new AKT_SOTHAM_QUYETDINH();
            if (VuAnId > 0)
            {
                oND = dt.AKT_SOTHAM_QUYETDINH.Where(x => x.DONID == VuAnId).SingleOrDefault<AKT_SOTHAM_QUYETDINH>();
                if (oND != null)
                    IsUpdate = true;
                else
                    oND = new AKT_SOTHAM_QUYETDINH();
            }
            else
                oND = new AKT_SOTHAM_QUYETDINH();

            try
            {
                oND.QUYETDINHID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
                DM_QD_QUYETDINH objQD = dt.DM_QD_QUYETDINH.Where(x => x.ID == oND.QUYETDINHID).SingleOrDefault();
                if (objQD != null)
                    oND.LOAIQDID = objQD.LOAIID;
            }
            catch (Exception ex) { }


            oND.TOAANID = Convert.ToDecimal(ddlToaxxST.SelectedValue);
            oND.SOQD = txtSoQD.Text.Trim();
            DateTime NgayQD = DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            oND.NGAYQD = NgayQD;

            oND.DONID = VuAnId;
            oND.QUYETDINHID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
            oND.NGUOIYEUCAUID = oND.NGUOIBIYEUCAUID = 0;
            oND.GHICHU = "";

            if (IsUpdate)
            {
                oND.NGAYSUA = DateTime.Now;
                oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                dt.SaveChanges();
            }
            else
            {
                oND.NGAYTAO = DateTime.Now;
                oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                dt.AKT_SOTHAM_QUYETDINH.Add(oND);
                dt.SaveChanges();
            }
            hddBAQDID.Value = oND.ID + "";
        }

        void Chuyenan_Nhanan(decimal VuAnID)
        {
            //Chuyen và nhận án luôn
            Boolean IsUpdate = false;
            AKT_CHUYEN_NHAN_AN oND = new AKT_CHUYEN_NHAN_AN();

            if (VuAnID > 0)
            {
                oND = dt.AKT_CHUYEN_NHAN_AN.Where(x => x.VUANID == VuAnID).SingleOrDefault<AKT_CHUYEN_NHAN_AN>();
                if (oND != null)
                    IsUpdate = true;
                else
                    oND = new AKT_CHUYEN_NHAN_AN();
            }
            else
                oND = new AKT_CHUYEN_NHAN_AN();

            oND.VUANID = VuAnID;
            oND.TOACHUYENID = Convert.ToDecimal(ddlToaxxST.SelectedValue);
            oND.NGUOIGIAOID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            oND.TOANHANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            oND.NGAYGIAO = DateTime.Now;
            oND.NGAYNHAN = DateTime.Now;
            oND.NGUOINHANID = Convert.ToDecimal(ddlNguoinhanHS.SelectedValue);
            if (txtSoButLuc.Text != "")
            {
                oND.SOBUTLUC = Convert.ToDecimal(txtSoButLuc.Text);
            }
            //-----------------------------
            DM_DATAGROUP oG = dt.DM_DATAGROUP.Where(x => x.MA == ENUM_DANHMUC.TRUONGHOP_GIAONHAN).FirstOrDefault();
            AKT_SOTHAM_KHANGCAO oKC = dt.AKT_SOTHAM_KHANGCAO.Where(x => x.DONID == VuAnID).FirstOrDefault<AKT_SOTHAM_KHANGCAO>();
            AKT_SOTHAM_KHANGNGHI oKN = dt.AKT_SOTHAM_KHANGNGHI.Where(x => x.DONID == VuAnID).FirstOrDefault<AKT_SOTHAM_KHANGNGHI>();
            if (oKC != null && oKN != null)
                oND.TRUONGHOPGIAONHANID = 268; //Do khang cao va kn phuc tham
            else if (oKC != null && oKN == null)
                oND.TRUONGHOPGIAONHANID = 267; //Do khang cao phuc tham
            else if (oKC == null && oKN != null)
                oND.TRUONGHOPGIAONHANID = 269; //do khang nghi  phuc tham
            else if (ddlThuly.SelectedIndex == 1)
                oND.TRUONGHOPGIAONHANID = 998; // ko có kháng cáo kháng nghị //do giám đốc thẩm hủy để xx lại phúc thẩm
            else
                oND.TRUONGHOPGIAONHANID = 0;


            oND.TRANGTHAI = 1;// 0: Chuyển chờ nhận, 1: Nhận
            oND.NGAYTAO = DateTime.Now;
            if (!IsUpdate)
                dt.AKT_CHUYEN_NHAN_AN.Add(oND);
            dt.SaveChanges();

            //Nhan an thì update lại Mã giai đoạn
            AKT_DON oVuAn = dt.AKT_DON.Where(x => x.ID == VuAnID).FirstOrDefault();
            oVuAn.MAGIAIDOAN = ENUM_GIAIDOANVUAN.PHUCTHAM;
            oVuAn.TOAPHUCTHAMID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            dt.SaveChanges();

            GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
            if (ddlThuly.SelectedIndex == 1)
                GD.GAIDOAN_INSERT_UPDATE_XXLAI_PHUCTHAM("4", VuAnID, 3, Convert.ToDecimal(ddlToaxxST.SelectedValue), Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0);
            else
                GD.GAIDOAN_INSERT_UPDATE("4", VuAnID, 3, 0, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0);
        }

        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            if (SaveData())
            {
                lstMsgT.Text = lstMsgB.Text = "Lưu thông tin đơn thành công !";
                Session["KT_THEMDSK"] = hddID.Value;
                DsDuongSu1.Visible = true;
                DsDuongSu1.DonID = Convert.ToDecimal(hddID.Value);
                DsDuongSu1.ReLoad();

                uDSNguoiThamGiaToTung.Visible = true;
                uDSNguoiThamGiaToTung.Donid = Convert.ToDecimal(hddID.Value);
                uDSNguoiThamGiaToTung.LoadGrid();

                decimal vDonid = Convert.ToDecimal(hddID.Value);
                LoadComboboxKhangCao(vDonid);
                LoadComboboxKhangNghi();
                LoadGridKCKN();

            }
        }
        protected void cmdUpdateSelect_Click(object sender, EventArgs e)
        {
            if (SaveData())
            {
                decimal IDVuViec = Convert.ToDecimal(hddID.Value);
                //Lưu vào người dùng
                decimal IDUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDUser).FirstOrDefault();
                if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") == oNSD.DONVIID.ToString())
                {
                    oNSD.IDANDANSU = IDVuViec;
                    dt.SaveChanges();
                }
                Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] = IDVuViec;
                Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
                //Cls_Comon.ShowMessageAndRedirect(this, this.GetType(), "MsgDSDON", "Lưu thông tin thành công, tiếp theo hãy chọn chức năng cần thao tác trong danh sách bên trái !", Cls_Comon.GetRootURL() + "/Trangchu.aspx");

            }
        }
        protected void cmdUpdateKCKN_Click(object sender, EventArgs e)
        {
            decimal ID = 0, IsKhangCao = 0, vDonID = Convert.ToDecimal(hddID.Value);
            AKT_DON oDon = dt.AKT_DON.Where(x => x.ID == vDonID).FirstOrDefault();
            if (rdbPanelKC.SelectedValue == KHANGCAO.ToString() && rdbPanelKN.SelectedValue == KHANGCAO.ToString())// Kháng cáo
            {
                IsKhangCao = KHANGCAO;
                if (!CheckValid(IsKhangCao)) return;
                AKT_SOTHAM_KHANGCAO oND;
                if (hddKCID.Value == "" || hddKCID.Value == "0")
                {
                    oND = new AKT_SOTHAM_KHANGCAO();
                    if (rdbQuahan_KC.SelectedValue == "1")
                    {
                        DM_TOAAN toa = dt.DM_TOAAN.Where(x => x.ID == oDon.TOAANID).FirstOrDefault<DM_TOAAN>();
                        if (toa != null)
                        {
                            oND.GQ_TOAANID = toa.CAPCHAID;
                        }
                        oND.GQ_TINHTRANG = 0;
                    }
                }
                else
                {
                    ID = Convert.ToDecimal(hddKCID.Value);
                    oND = dt.AKT_SOTHAM_KHANGCAO.Where(x => x.ID == ID).FirstOrDefault();
                }
                oND.DONID = vDonID;
                oND.HINHTHUCNHAN = Convert.ToDecimal(rdbHinhThucNhanDon.SelectedValue);
                oND.NGAYVIETDON = (String.IsNullOrEmpty(txtNgayvietdonKC.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayvietdonKC.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NGAYKHANGCAO = (String.IsNullOrEmpty(txtNgaykhangcao.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaykhangcao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.DUONGSUID = Convert.ToDecimal(ddlNguoikhangcao.SelectedValue);
                oND.LOAIKHANGCAO = Convert.ToDecimal(rdbLoaiKC.SelectedValue);
                oND.SOQDBA = Convert.ToDecimal(ddlSOQDBA_KC.SelectedValue);
                oND.ISQUAHAN = Convert.ToDecimal(rdbQuahan_KC.SelectedValue);
                oND.NGAYQDBA = (String.IsNullOrEmpty(txtNgayQDBA_KC.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQDBA_KC.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.TOAANRAQDID = oDon.TOAANID;
                oND.NOIDUNGKHANGCAO = txtNoidungKC.Text;
               
                if (hddKCID.Value == "" || hddKCID.Value == "0")
                {
                    oND.NGAYTAO = DateTime.Now;
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    // insert toa_gq_id
                    if (oND.TOA_GIAIQUYET_ID == null)
                    {
                        oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    }
                    dt.AKT_SOTHAM_KHANGCAO.Add(oND);
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                }
                dt.SaveChanges();
                ID = oND.ID;
                hddKCID.Value = "0";
            }
            else if (rdbPanelKC.SelectedValue == KHANGNGHI.ToString() && rdbPanelKN.SelectedValue == KHANGNGHI.ToString())// Kháng nghị
            {
                IsKhangCao = KHANGNGHI;
                if (!CheckValid(IsKhangCao)) return;

                AKT_SOTHAM_KHANGNGHI oND;
                if (hddKNID.Value == "" || hddKNID.Value == "0")
                    oND = new AKT_SOTHAM_KHANGNGHI();
                else
                {
                    ID = Convert.ToDecimal(hddKNID.Value);
                    oND = dt.AKT_SOTHAM_KHANGNGHI.Where(x => x.ID == ID).FirstOrDefault();
                }
                oND.DONID = vDonID;
                oND.SOKN = txtSokhangnghi.Text;
                oND.NGAYKN = (String.IsNullOrEmpty(txtNgaykhangnghi.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaykhangnghi.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.DONVIKN = Convert.ToDecimal(rdbDonVi.SelectedValue);
                oND.CAPKN = Convert.ToDecimal(rdbCapkhangnghi.SelectedValue);
                oND.LOAIKN = Convert.ToDecimal(rdbLoaiKN.SelectedValue);
                oND.BANANID = Convert.ToDecimal(ddlSOQDBAKhangNghi.SelectedValue);
                oND.NGAYBANAN = (String.IsNullOrEmpty(txtNgayQDBA_KN.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQDBA_KN.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.TOAANRAQDID = oDon.TOAANID;
                oND.NOIDUNGKN = txtNoidungKN.Text;
                if (trDVKN.Visible)
                    oND.TOAAN_VKS_KN = Convert.ToDecimal(ddlDonViKN.SelectedValue);
               
                if (hddKNID.Value == "" || hddKNID.Value == "0")
                {
                    oND.NGAYTAO = DateTime.Now;
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    // insert toa_gq_id
                    if (oND.TOA_GIAIQUYET_ID == null)
                    {
                        oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    }
                    dt.AKT_SOTHAM_KHANGNGHI.Add(oND);
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                }
                dt.SaveChanges();
                ID = oND.ID;
                hddKNID.Value = "0";
            }
            // Lưu thông tin chuyển nhận án
            Chuyenan_Nhanan(vDonID);

            ResetControlsKCKN();
            LoadGridKCKN();
            lstMsgT.Text = lstMsgB.Text = "Hoàn thành Lưu Kháng cáo Kháng Nghị!";
            
        }

        protected void cmdXoaHoSo_Click(object sender, EventArgs e)
        {
            decimal ID = Convert.ToDecimal(hddID.Value);
            string strDonviTao = Session[ENUM_SESSION.SESSION_USERNAME] +"";
            //Kiem tra neu chua Thu ly Phuc tham và Hồ sơ do Tòa cấp cao nhập thi cho xóa Hồ sơ án sơ thẩm
            //myClass.Where(x => (x.MyOtherObject == null) ? false : x.MyOtherObject.Name == "Name").ToList();
            AKT_PHUCTHAM_THULY oTLPT = dt.AKT_PHUCTHAM_THULY.Where(x => x.DONID == ID).FirstOrDefault() ?? new AKT_PHUCTHAM_THULY();
            if (oTLPT.ID == 0)
            {
                AKT_DON oVa = dt.AKT_DON.Where(x => x.ID == ID).First();
                if (oVa != null)
                {
                    //Nếu đơn được tao boi TACC HCM thi cho xoa
                    //if (oVa.NGUOITAO == usercurent)
                    //{
                        XoaHoSo(ID);
                        //Hủy ghim
                        decimal IDVuViec = 0;
                        //Lưu vào người dùng
                        decimal IDUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                        QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDUser).FirstOrDefault();
                        if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") == oNSD.DONVIID.ToString())
                        {
                            oNSD.IDANDANSU = IDVuViec;
                            dt.SaveChanges();
                        }
                        Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] = IDVuViec;
                        Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
                    //}
                

                }
            }
        }
        public void XoaHoSo(decimal ID)
        {
            //Luu thong tin Hồ sơ án trước khi xoa
            string strUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            AKT_DON oT = dt.AKT_DON.Where(x => x.ID == ID).FirstOrDefault();
            var json = new JavaScriptSerializer().Serialize(oT);
            ADS_DON_BL oBLDS = new ADS_DON_BL();
            if (oBLDS.HISTORY_ALLDATA_BY_VUANID(Convert.ToDecimal(oT.ID), 4, Session[ENUM_SESSION.SESSION_USERID] + "", strUserName, "Tạo hồ sơ KC/KN án Kinh Tế", "Xóa", json) == false)
            {
                return;
            }//Ket thuc

            //thực hiện việc xóa toàn bộ hồ sơ Sơ thẩm mình tạo khi chưa nhập các thông tin của án Phúc Thẩm
            AKT_DON_BL oBL = new AKT_DON_BL();
            if (oBL.DELETE_ALLDATA_BY_VUANID(ID + "") == true)
            {
                //Xóa thông tin Giai đoan
                GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                GD.GIAIDOAN_DELETES("4", ID,2);
            }
            
        }
        public void xoAKT(decimal id)
        {
            AKT_DON_DUONGSU oT = dt.AKT_DON_DUONGSU.Where(x => x.ID == id).FirstOrDefault();
            //Luu thông tin đương sự trước khi xóa
            string strUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            var json = new JavaScriptSerializer().Serialize(oT);
            ADS_DON_BL oBLDS = new ADS_DON_BL();
            if (oBLDS.HISTORY_ALLDATA_BY_VUANID(Convert.ToDecimal(oT.ID), 4, Session[ENUM_SESSION.SESSION_USERID] + "", strUserName, "Xoa Duong su trong Tạo hồ sơ KC/KN Kinh Tế", "Xóa", json) == false)
            {
                return;
            }//Ket thuc 

            //Xoa Duong su
            dt.AKT_DON_DUONGSU.Remove(oT);
            dt.SaveChanges();
        }
        protected void ddlLoaiBidon_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlLoaiBidon.SelectedValue == "1")
            {
                pnBD_Canhan.Visible = true;
                pnBD_Tochuc.Visible = false;
                txtBD_Ten.Focus();
            }
            else
            {
                pnBD_Canhan.Visible = false;
                pnBD_Tochuc.Visible = true;
                txtBD_Ten.Focus();
            }
        }
        protected void ddlQuanhephapluat_SelectedIndexChanged(object sender, EventArgs e)
        {
        }
        protected void ddlQHPLTK_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlQHPLTK.SelectedValue != "0")
            {
                Decimal qhplid = Convert.ToDecimal(ddlQHPLTK.SelectedValue);
                DM_QHPL_TK qhpltk = dt.DM_QHPL_TK.Where(x => x.ID == qhplid).FirstOrDefault();
                qlhl_check_load(Convert.ToDecimal(qhpltk.OPTIONS));
            }

        }
        protected void qlhl_check_load(decimal value)
        {
            // value := 0 -tranh chấp  1 -yêu cầu  2 - Load theo "Quan hệ pháp luật dùng cho thống kê"
            if (value == 2 && ddlQHPLTK.SelectedValue != "0")
            {
                Decimal qhplid = Convert.ToDecimal(ddlQHPLTK.SelectedValue);
                DM_QHPL_TK qhpltk = dt.DM_QHPL_TK.Where(x => x.ID == qhplid).FirstOrDefault();
                value = Convert.ToDecimal(qhpltk.OPTIONS);
            }
            if (value == 0)//tranh chấp
            {
                lbl_ttnguyendon.Text = "Thông tin nguyên đơn (đại diện)";
                lbl_ttbidon.Text = "Thông tin bị đơn (đại diện)";

                lbl_nguyendonla.Text = "Nguyên đơn là";
                lbl_tennguyendon.Text = "Tên nguyên đơn";
                lbl_bidonla.Text = "Bị đơn là";
                lbl_tenbidon.Text = "Tên bị đơn";
                chkBoxCMNDBD.Checked = false;
            }
            else if (value == 1)//yêu cầu
            {
                lbl_ttnguyendon.Text = "Thông tin người yêu cầu";
                lbl_ttbidon.Text = "Thông tin người bị yêu cầu/người liên quan";

                lbl_nguyendonla.Text = "Người yêu cầu là";
                lbl_tennguyendon.Text = "Tên người yêu cầu";
                lbl_bidonla.Text = "Người bị yêu cầu/người liên quan là";
                lbl_tenbidon.Text = "Tên người bị yêu cầu/người liên quan";
                chkBoxCMNDBD.Checked = true;
            }
            else
            {
                lbl_ttnguyendon.Text = "Thông tin nguyên đơn (đại diện)";
                lbl_ttbidon.Text = "Thông tin bị đơn (đại diện)";

                lbl_nguyendonla.Text = "Nguyên đơn là";
                lbl_tennguyendon.Text = "Tên nguyên đơn";
                lbl_bidonla.Text = "Bị đơn là";
                lbl_tenbidon.Text = "Tên bị đơn";
                chkBoxCMNDBD.Checked = false;
            }

        }
        protected void ddlQuyetdinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlQuyetdinh.SelectedValue == "11" ||
                ddlQuyetdinh.SelectedValue == "422" ||
                ddlQuyetdinh.SelectedValue == "423" ||
                ddlQuyetdinh.SelectedValue == "425")
            {
                qlhl_check_load(1);
            }
            else
            {
                qlhl_check_load(2);
            }
        }
        protected void ddlLoaiNguyendon_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlLoaiNguyendon.SelectedValue == "1")
            {
                pnNDCanhan.Visible = true;
                pnNDTochuc.Visible = false;
                //chkISBVQLNK.Visible = false;

                Cls_Comon.SetFocus(this, this.GetType(), txtTennguyendon.ClientID);
            }
            else
            {
                pnNDCanhan.Visible = false;
                pnNDTochuc.Visible = true;
                //chkISBVQLNK.Visible = true;

                //Cls_Comon.SetFocus(this, this.GetType(), chkISBVQLNK.ClientID);
            }
        }
        protected void ddlND_Quoctich_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlND_Quoctich.SelectedIndex > 0)
            {
                //lblND_Batbuoc1.Text = 
                lblND_Batbuoc2.Text = "";
                chkND_ONuocNgoai.Visible = false;
            }
            else
            {
                //lblND_Batbuoc1.Text = 
                lblND_Batbuoc2.Text = "(*)";
                chkND_ONuocNgoai.Visible = true;
            }
            if (ddlLoaiNguyendon.SelectedValue == "1")
                Cls_Comon.SetFocus(this, this.GetType(), ddlND_Gioitinh.ClientID);
            else
                Cls_Comon.SetFocus(this, this.GetType(), txtND_Email.ClientID);

        }
        protected void chkND_ONuocNgoai_CheckedChanged(object sender, EventArgs e)
        {
            if (chkND_ONuocNgoai.Checked)
            {
                //lblND_Batbuoc1.Text =
                lblND_Batbuoc2.Text = "";
            }
            else
            {
                //lblND_Batbuoc1.Text = 
                lblND_Batbuoc2.Text = "(*)";
            }
            Cls_Comon.SetFocus(this, this.GetType(), ddlTamTru_Tinh_NguyenDon.ClientID);
        }
        protected void ddlBD_Quoctich_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlBD_Quoctich.SelectedIndex > 0)
            {
                chkBD_ONuocNgoai.Visible = false;
            }
            else
            {
                chkBD_ONuocNgoai.Visible = true;
            }
            if (ddlLoaiBidon.SelectedValue == "1")
                Cls_Comon.SetFocus(this, this.GetType(), ddlBD_Gioitinh.ClientID);
            else
                Cls_Comon.SetFocus(this, this.GetType(), txtBD_Email.ClientID);

        }
        protected void chkBD_ONuocNgoai_CheckedChanged(object sender, EventArgs e)
        {
            if (chkBD_ONuocNgoai.Checked)
            {
                //lblBD_Batbuoc1.Text = 
                //lblBD_Batbuoc2.Text = "";
            }
            else
            {
                //lblBD_Batbuoc1.Text = 
               // lblBD_Batbuoc2.Text = "(*)";
            }
            Cls_Comon.SetFocus(this, this.GetType(), ddlTamTru_Tinh_BiDon.ClientID);

        }
        private void LoadDropTinh()
        {
            ddlNDD_Tinh_NguyenDon.Items.Clear();
            ddlNDD_Tinh_BiDon.Items.Clear();
            ddlTamTru_Tinh_NguyenDon.Items.Clear();
            ddlTamTru_Tinh_BiDon.Items.Clear();
            List<DM_HANHCHINH> lstTinh = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == ROOT).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstTinh != null && lstTinh.Count > 0)
            {
                ddlNDD_Tinh_NguyenDon.DataSource = lstTinh;
                ddlNDD_Tinh_NguyenDon.DataTextField = "TEN";
                ddlNDD_Tinh_NguyenDon.DataValueField = "ID";
                ddlNDD_Tinh_NguyenDon.DataBind();

                ddlNDD_Tinh_BiDon.DataSource = lstTinh;
                ddlNDD_Tinh_BiDon.DataTextField = "TEN";
                ddlNDD_Tinh_BiDon.DataValueField = "ID";
                ddlNDD_Tinh_BiDon.DataBind();                

                ddlTamTru_Tinh_NguyenDon.DataSource = lstTinh;
                ddlTamTru_Tinh_NguyenDon.DataTextField = "TEN";
                ddlTamTru_Tinh_NguyenDon.DataValueField = "ID";
                ddlTamTru_Tinh_NguyenDon.DataBind();

                ddlTamTru_Tinh_BiDon.DataSource = lstTinh;
                ddlTamTru_Tinh_BiDon.DataTextField = "TEN";
                ddlTamTru_Tinh_BiDon.DataValueField = "ID";
                ddlTamTru_Tinh_BiDon.DataBind();
            }

            ddlNDD_Tinh_NguyenDon.Items.Insert(0, new ListItem("---Chọn---", "0"));
            ddlNDD_Tinh_BiDon.Items.Insert(0, new ListItem("---Chọn---", "0"));
          
            ddlTamTru_Tinh_NguyenDon.Items.Insert(0, new ListItem("---Chọn---", "0"));
            ddlTamTru_Tinh_BiDon.Items.Insert(0, new ListItem("---Chọn---", "0"));

            LoadDropNDD_Huyen_NguyenDon();
           
            LoadDropNDD_Huyen_BiDon();
           
          
            LoadDropTamTru_Huyen_NguyenDon();
        
          LoadDropTamTru_Huyen_BiDon();
          
        }
        private  void SetValueComboBox(DropDownList ddl, object value)
        {
            ddl.ClearSelection();
            string str = value + "";
            if (str == "") return;
            if (ddl.Items.FindByValue(str) != null)
                ddl.SelectedValue = str;
        }
        private void LoadDropNDD_Huyen_NguyenDon()
        {
            ddlNDD_Huyen_NguyenDon.Items.Clear();
            decimal TinhID = Convert.ToDecimal(ddlNDD_Tinh_NguyenDon.SelectedValue);
            if (TinhID == 0)
            {
                ddlNDD_Huyen_NguyenDon.Items.Add(new ListItem("---Chọn---", "0"));
                return;
            }
            List<DM_HANHCHINH> lstHuyen = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == TinhID).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstHuyen != null && lstHuyen.Count > 0)
            {
                ddlNDD_Huyen_NguyenDon.DataSource = lstHuyen;
                ddlNDD_Huyen_NguyenDon.DataTextField = "TEN";
                ddlNDD_Huyen_NguyenDon.DataValueField = "ID";
                ddlNDD_Huyen_NguyenDon.DataBind();
            }
            ddlNDD_Huyen_NguyenDon.Items.Insert(0, new ListItem("---Chọn---", "0"));
        }
        private void LoadDropNDD_Huyen_BiDon()
        {
            ddlNDD_Huyen_BiDon.Items.Clear();
            decimal TinhID = Convert.ToDecimal(ddlNDD_Tinh_BiDon.SelectedValue);
            if (TinhID == 0)
            {
                ddlNDD_Huyen_BiDon.Items.Add(new ListItem("---Chọn---", "0"));
                return;
            }
            List<DM_HANHCHINH> lstHuyen = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == TinhID).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstHuyen != null && lstHuyen.Count > 0)
            {
                ddlNDD_Huyen_BiDon.DataSource = lstHuyen;
                ddlNDD_Huyen_BiDon.DataTextField = "TEN";
                ddlNDD_Huyen_BiDon.DataValueField = "ID";
                ddlNDD_Huyen_BiDon.DataBind();
            }
            ddlNDD_Huyen_BiDon.Items.Insert(0, new ListItem("---Chọn---", "0"));
        }
        private void LoadDropTamTru_Huyen_NguyenDon()
        {
            ddlTamTru_Huyen_NguyenDon.Items.Clear();
            decimal TinhID = Convert.ToDecimal(ddlTamTru_Tinh_NguyenDon.SelectedValue);
            if (TinhID == 0)
            {
                ddlTamTru_Huyen_NguyenDon.Items.Add(new ListItem("---Chọn---", "0"));
                return;
            }
            List<DM_HANHCHINH> lstHuyen = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == TinhID).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstHuyen != null && lstHuyen.Count > 0)
            {
                ddlTamTru_Huyen_NguyenDon.DataSource = lstHuyen;
                ddlTamTru_Huyen_NguyenDon.DataTextField = "TEN";
                ddlTamTru_Huyen_NguyenDon.DataValueField = "ID";
                ddlTamTru_Huyen_NguyenDon.DataBind();
            }
            ddlTamTru_Huyen_NguyenDon.Items.Insert(0, new ListItem("---Chọn---", "0"));
        }
        private void LoadDropTamTru_Huyen_BiDon()
        {
            ddlTamTru_Huyen_BiDon.Items.Clear();
            decimal TinhID = Convert.ToDecimal(ddlTamTru_Tinh_BiDon.SelectedValue);
            if (TinhID == 0)
            {
                ddlTamTru_Huyen_BiDon.Items.Add(new ListItem("---Chọn---", "0"));
                return;
            }
            List<DM_HANHCHINH> lstHuyen = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == TinhID).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstHuyen != null && lstHuyen.Count > 0)
            {
                ddlTamTru_Huyen_BiDon.DataSource = lstHuyen;
                ddlTamTru_Huyen_BiDon.DataTextField = "TEN";
                ddlTamTru_Huyen_BiDon.DataValueField = "ID";
                ddlTamTru_Huyen_BiDon.DataBind();
            }
            ddlTamTru_Huyen_BiDon.Items.Insert(0, new ListItem("---Chọn---", "0"));
        }
        protected void ddlNDD_Tinh_NguyenDon_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDropNDD_Huyen_NguyenDon();
                Cls_Comon.SetFocus(this, this.GetType(), ddlNDD_Huyen_NguyenDon.ClientID);

            }
            catch (Exception ex) { lstMsgT.Text = lstMsgB.Text = ex.Message; }
        }
        protected void ddlNDD_Tinh_BiDon_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDropNDD_Huyen_BiDon();
                Cls_Comon.SetFocus(this, this.GetType(), ddlNDD_Huyen_BiDon.ClientID);

            }
            catch (Exception ex) { lstMsgT.Text = lstMsgB.Text = ex.Message; }
        }
        protected void ddlTamTru_Tinh_NguyenDon_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDropTamTru_Huyen_NguyenDon();
                Cls_Comon.SetFocus(this, this.GetType(), ddlTamTru_Huyen_NguyenDon.ClientID);

            }
            catch (Exception ex) { lstMsgT.Text = lstMsgB.Text = ex.Message; }
        }
        protected void ddlTamTru_Tinh_BiDon_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDropTamTru_Huyen_BiDon();
                Cls_Comon.SetFocus(this, this.GetType(), ddlTamTru_Huyen_BiDon.ClientID);

            }
            catch (Exception ex) { lstMsgT.Text = lstMsgB.Text = ex.Message; }
        }
        protected void txtNgayNhan_TextChanged(object sender, EventArgs e)
        {
            
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
                
            }
            chkND_ONuocNgoai.Focus();
        }
        protected void txtBD_Ngaysinh_TextChanged(object sender, EventArgs e)
        {
            if (txtBD_Ngaysinh.Text != "")
            {
                if (Cls_Comon.IsValidDate(txtBD_Ngaysinh.Text))
                {
                    DateTime NgaySinh_BD = DateTime.Parse(txtBD_Ngaysinh.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                    txtBD_Namsinh.Text = NgaySinh_BD.Year.ToString();
                   
                }
            }
           
            txtBD_Namsinh.Focus();
        }
        protected void txtBD_Namsinh_TextChanged(object sender, EventArgs e)
        {
            if (txtBD_Namsinh.Text.Length == 4)
            {
                string NgaySinhstr = "";
                if (txtBD_Ngaysinh.Text == "")
                {
                    NgaySinhstr = "01/01/" + txtBD_Namsinh.Text;
                }
                else
                {
                    if (Cls_Comon.IsValidDate(txtBD_Ngaysinh.Text))
                    {
                        string[] arr = txtBD_Ngaysinh.Text.Split('/');
                        NgaySinhstr = arr[0] + "/" + arr[1] + "/" + txtBD_Namsinh.Text;
                        txtBD_Ngaysinh.Text = NgaySinhstr;
                    }
                }
               
            }
            chkBD_ONuocNgoai.Focus();
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

        protected void rdbLoaiBAQD_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdbLoaiBAQD.SelectedValue == "1")
            {
                pnQD.Visible = false;
                pnBanan.Visible = true;
            }
            else
            {
                pnQD.Visible = true;
                pnBanan.Visible = false;
            }
        }

        private void LoadComboboxKhangCao(decimal vDonid)
        {
            Load_ListBiCan(vDonid);
            Load_ListNguoiThamGiaToTung(vDonid);
            LoadQD_BAKhangCao(vDonid);
        }

        void Load_ListBiCan( decimal vDonid)
        {
            AKT_DON_DUONGSU_BL oDSBL = new AKT_DON_DUONGSU_BL();
            ddlNguoikhangcao.Items.Clear();
            //Load đương sự
            ddlNguoikhangcao.DataSource = oDSBL.AKT_SOTHAM_DUONGSU_GETBY(vDonid, 1);
            ddlNguoikhangcao.DataTextField = "ARRDUONGSU";
            ddlNguoikhangcao.DataValueField = "ID";
            ddlNguoikhangcao.DataBind();

        }

        void Load_ListNguoiThamGiaToTung(decimal vDonid)
        {
            //ddlNguoikhangcao.Items.Clear();

            string hoten = "";
            List<AKT_DON_THAMGIATOTUNG> lst = dt.AKT_DON_THAMGIATOTUNG.Where(x => x.DONID == vDonid).ToList();
            if (lst != null && lst.Count > 0)
            {

                foreach (AKT_DON_THAMGIATOTUNG item in lst)
                {
                    DM_DATAITEM tc = dt.DM_DATAITEM.Where(x => x.MA == item.TUCACHTGTTID).First();
                    hoten = item.HOTEN + " -- " + tc.TEN;
                    ddlNguoikhangcao.Items.Add(new ListItem(hoten, item.ID.ToString()));
                }

            }
            ddlNguoikhangcao.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }

        void LoadDrop_ST_BanAn(DropDownList drop, Decimal DonID)
        {
            String temp = "";
            List<AKT_SOTHAM_BANAN> lst = dt.AKT_SOTHAM_BANAN.Where(x => x.DONID == DonID).OrderByDescending(y => y.NGAYTUYENAN).ToList();
            if (lst != null && lst.Count > 0)
            {
                foreach (AKT_SOTHAM_BANAN item in lst)
                {
                    temp = item.SOBANAN + "-" + ((DateTime)item.NGAYTUYENAN).ToString("dd/MM/yyyy", cul);
                    drop.Items.Add(new ListItem(temp, item.ID.ToString()));
                }
            }
            else
                drop.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }
        void LoadDrop_ST_QuyetDinh(DropDownList drop, Decimal DonID)
        {
            String temp = "";
            AKT_SOTHAM_BL objBL = new AKT_SOTHAM_BL();
            DataTable tblQD = objBL.AKT_SOTHAM_QUYETDINH_GETLIST(DonID);
            if (tblQD != null && tblQD.Rows.Count > 0)
            {
                foreach (DataRow row in tblQD.Rows)
                {
                    temp = row["SOQD"].ToString() + " - " + row["TENQD"].ToString();
                    drop.Items.Add(new ListItem(temp, row["ID"].ToString()));
                }
            }
            else
                drop.Items.Insert(0, new ListItem("--- Chọn ---", "0"));

            objBL = new AKT_SOTHAM_BL();
        }

        private void LoadQD_BAKhangCao(Decimal vDonid)
        {
            
            ddlSOQDBA_KC.Items.Clear();
            if (rdbLoaiKC.SelectedValue == "0")
            {
                LoadDrop_ST_BanAn(ddlSOQDBA_KC, vDonid);
            }
            else
            {
                LoadDrop_ST_QuyetDinh(ddlSOQDBA_KC, vDonid);
            }
            LoadQD_BA_InfoKhangCao(vDonid);
        }
        private void LoadQD_BA_InfoKhangCao(decimal vDonid)
        {
            if (ddlSOQDBA_KC.SelectedValue == "0") return;
            if (rdbLoaiKC.SelectedValue == "0")
            {
                decimal ID = Convert.ToDecimal(ddlSOQDBA_KC.SelectedValue);
                AKT_SOTHAM_BANAN oT = dt.AKT_SOTHAM_BANAN.Where(x => x.ID == ID).FirstOrDefault();
                if (oT != null)
                {
                    txtNgayQDBA_KC.Text = string.IsNullOrEmpty(oT.NGAYTUYENAN + "") ? "" : ((DateTime)oT.NGAYTUYENAN).ToString("dd/MM/yyyy", cul);
                }
                else { txtNgayQDBA_KC.Text = ""; }
            }
            else
            {
                decimal ID = Convert.ToDecimal(ddlSOQDBA_KC.SelectedValue);
                AKT_SOTHAM_QUYETDINH oT = dt.AKT_SOTHAM_QUYETDINH.Where(x => x.ID == ID).FirstOrDefault();
                if (oT != null)
                {
                    txtNgayQDBA_KC.Text = string.IsNullOrEmpty(oT.NGAYQD + "") ? "" : ((DateTime)oT.NGAYQD).ToString("dd/MM/yyyy", cul);
                }
                else { txtNgayQDBA_KC.Text = ""; }
            }
          
            AKT_DON oDon = dt.AKT_DON.Where(x => x.ID == vDonid).FirstOrDefault();
            if (oDon != null)
            {
                DM_TOAAN oToaAn = dt.DM_TOAAN.Where(x => x.ID == oDon.TOAANID).FirstOrDefault();
                if (oToaAn != null)
                { txtToaAnQD_KC.Text = oToaAn.TEN; }
                else { txtToaAnQD_KC.Text = ""; }
            }
            else
            {
                txtToaAnQD_KC.Text = "";
            }
        }
        private void LoadComboboxKhangNghi()
        {
            decimal vDonid = Convert.ToDecimal(hddID.Value);
            LoadQD_BAKhangNghi(vDonid);
        }
        private void LoadQD_BAKhangNghi(decimal vDonid)
        {
            ddlSOQDBAKhangNghi.Items.Clear();
            if (rdbLoaiKN.SelectedValue == "0")
                LoadDrop_ST_BanAn(ddlSOQDBAKhangNghi, vDonid);
            else
                LoadDrop_ST_QuyetDinh(ddlSOQDBAKhangNghi, vDonid);
            LoadQD_BA_InfoKhangNghi();
        }
        private void LoadQD_BA_InfoKhangNghi()
        {
            if (ddlSOQDBAKhangNghi.Items.Count == 0) return;
            if (rdbLoaiKN.SelectedValue == "0")
            {
                decimal ID = Convert.ToDecimal(ddlSOQDBAKhangNghi.SelectedValue);
                AKT_SOTHAM_BANAN oT = dt.AKT_SOTHAM_BANAN.Where(x => x.ID == ID).FirstOrDefault();
                if (oT != null)
                    txtNgayQDBA_KN.Text = string.IsNullOrEmpty(oT.NGAYTUYENAN + "") ? "" : ((DateTime)oT.NGAYTUYENAN).ToString("dd/MM/yyyy", cul);
                else
                    txtNgayQDBA_KN.Text = "";
            }
            else
            {
                decimal ID = Convert.ToDecimal(ddlSOQDBAKhangNghi.SelectedValue);
                AKT_SOTHAM_QUYETDINH oT = dt.AKT_SOTHAM_QUYETDINH.Where(x => x.ID == ID).FirstOrDefault();
                if (oT != null)
                    txtNgayQDBA_KN.Text = string.IsNullOrEmpty(oT.NGAYQD + "") ? "" : ((DateTime)oT.NGAYQD).ToString("dd/MM/yyyy", cul);
                else
                    txtNgayQDBA_KN.Text = "";
            }
            //decimal DonID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + "");
            decimal DonID = Convert.ToDecimal(hddID.Value);
            AKT_DON oDon = dt.AKT_DON.Where(x => x.ID == DonID).FirstOrDefault();
            if (oDon != null)
            {
                DM_TOAAN oToaAn = dt.DM_TOAAN.Where(x => x.ID == oDon.TOAANID).FirstOrDefault();
                if (oToaAn != null)
                    txtToaAnQD_KN.Text = oToaAn.TEN;
                else txtToaAnQD_KN.Text = "";
            }
            else
                txtToaAnQD_KN.Text = "";
        }
        public void LoadGridKCKN()
        {
            AKT_SOTHAM_BL oBL = new AKT_SOTHAM_BL();
            decimal ID = (string.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + "");
            DataTable oDT = oBL.AKT_SOTHAM_KCaoKNghi_GETLIST(ID);
            if (oDT != null && oDT.Rows.Count > 0)
            {
                dgList.DataSource = oDT;
                dgList.DataBind();
                pndata.Visible = true;
            }
            else
                pndata.Visible = false;
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;
                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                Cls_Comon.SetLinkButton(lblSua, oPer.CAPNHAT);
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);
                //string current_id = Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + "";
                string current_id = hddID.Value;
                decimal DONID = Convert.ToDecimal(current_id);
                //Kiem tra neu duyet Khang cao rồi thi không cho sửa hoặc xóa
                //AKT_SOTHAM_KHANGCAO oKC = dt.AKT_SOTHAM_KHANGCAO.Where(x => x.DONID == DONID).FirstOrDefault();
                //if (oKC.GQ_TINHTRANG == 1)
                //    lblSua.Visible = lbtXoa.Visible = false;
            }
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            try
            {
                decimal ID = 0, IsKhangCao = 0;
                string StrPara = "";
                StrPara = e.CommandArgument.ToString();
                if (StrPara.Contains(";#"))
                {
                    string[] arr = StrPara.Split(';');
                    ID = Convert.ToDecimal(arr[0] + "");
                    IsKhangCao = Convert.ToDecimal(arr[1].Replace("#", "") + "");
                }
                switch (e.CommandName)
                {
                   
                    case "Sua":
                        lbthongbao.Text = "";
                        LoadEdit(ID, IsKhangCao);
                        if (IsKhangCao == 1)
                            hddKCID.Value = ID.ToString();
                        else
                            hddKNID.Value = ID.ToString();
                        break;
                    case "Xoa":
                        MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                        if (oPer.XOA == false || cmdUpdateKCKN.Enabled == false)
                        {
                            lbthongbao.Text = "Bạn không có quyền xóa!";
                            return;
                        }
                        decimal DonID = Convert.ToDecimal(hddID.Value);
                        string StrMsg = "Không được sửa đổi thông tin khi đã Thụ lý Phúc thẩm.";
                        //string Result = new AKT_CHUYEN_NHAN_AN_BL().Check_NhanAn(DonID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                        //if (Result != "")
                        //{
                        AKT_PHUCTHAM_THULY oTLPT = dt.AKT_PHUCTHAM_THULY.Where(x => x.DONID == DonID).FirstOrDefault() ?? new AKT_PHUCTHAM_THULY();
                        if (oTLPT.ID > 0)
                        {
                            lbthongbao.Text = StrMsg;
                            return;
                        }
                        xoa(ID, IsKhangCao);
                        hddKCID.Value = hddKNID.Value = "0";
                        break;
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        public void LoadEdit(decimal ID, decimal IsKhangCao)
        {
            lbthongbao.Text = "";
            rdbPanelKC.Visible = rdbPanelKN.Visible = false;
            if (IsKhangCao == KHANGCAO)// Kháng cáo
            {
                rdbPanelKC.SelectedValue = rdbPanelKN.SelectedValue = KHANGCAO.ToString();
                pnKhangCao.Visible = true;
                hddShowKhangCao.Value = "1";
                pnKhangNghi.Visible = false;
                AKT_SOTHAM_KHANGCAO oND = dt.AKT_SOTHAM_KHANGCAO.Where(x => x.ID == ID).FirstOrDefault();
                if (oND != null)
                {
                    hddID.Value = oND.DONID.ToString();
                    rdbHinhThucNhanDon.SelectedValue = oND.HINHTHUCNHAN.ToString();
                    txtNgayvietdonKC.Text = string.IsNullOrEmpty(oND.NGAYVIETDON + "") ? "" : ((DateTime)oND.NGAYVIETDON).ToString("dd/MM/yyyy", cul);
                    txtNgaykhangcao.Text = string.IsNullOrEmpty(oND.NGAYKHANGCAO + "") ? "" : ((DateTime)oND.NGAYKHANGCAO).ToString("dd/MM/yyyy", cul);
                    ddlNguoikhangcao.SelectedValue = oND.DUONGSUID.ToString();
                    rdbLoaiKC.SelectedValue = oND.LOAIKHANGCAO.ToString();
                    LoadQD_BAKhangCao(Convert.ToDecimal(oND.DONID));
                    ddlSOQDBA_KC.SelectedValue = oND.SOQDBA.ToString();
                    rdbQuahan_KC.SelectedValue = oND.ISQUAHAN.ToString();
                    txtNgayQDBA_KC.Text = string.IsNullOrEmpty(oND.NGAYQDBA + "") ? "" : ((DateTime)oND.NGAYQDBA).ToString("dd/MM/yyyy", cul);
                    DM_TOAAN oToaAn = dt.DM_TOAAN.Where(x => x.ID == oND.TOAANRAQDID).FirstOrDefault();
                    if (oToaAn != null) { txtToaAnQD_KC.Text = oToaAn.TEN; } else { txtToaAnQD_KC.Text = ""; }
                    txtNoidungKC.Text = oND.NOIDUNGKHANGCAO;
                   
                }
            }
            else // Kháng nghị
            {
                rdbPanelKC.SelectedValue = rdbPanelKN.SelectedValue = KHANGNGHI.ToString();
                pnKhangCao.Visible = false;
                hddShowKhangCao.Value = "0";
                pnKhangNghi.Visible = true;
                AKT_SOTHAM_KHANGNGHI oND = dt.AKT_SOTHAM_KHANGNGHI.Where(x => x.ID == ID).FirstOrDefault();
                if (oND != null)
                {
                    hddID.Value = oND.DONID.ToString();
                    rdbDonVi.SelectedValue = oND.DONVIKN.ToString();
                    txtSokhangnghi.Text = oND.SOKN;
                    txtNgaykhangnghi.Text = string.IsNullOrEmpty(oND.NGAYKN + "") ? "" : ((DateTime)oND.NGAYKN).ToString("dd/MM/yyyy", cul);

                    rdbLoaiKN.SelectedValue = oND.LOAIKN.ToString();
                    LoadQD_BAKhangNghi(Convert.ToDecimal(oND.DONID));
                    ddlSOQDBAKhangNghi.SelectedValue = oND.BANANID.ToString();
                    txtNgayQDBA_KN.Text = string.IsNullOrEmpty(oND.NGAYBANAN + "") ? "" : ((DateTime)oND.NGAYBANAN).ToString("dd/MM/yyyy", cul);
                    DM_TOAAN oToaAn = dt.DM_TOAAN.Where(x => x.ID == oND.TOAANRAQDID).FirstOrDefault();
                    if (oToaAn != null)
                    { txtToaAnQD_KN.Text = oToaAn.TEN; }
                    else { txtToaAnQD_KN.Text = ""; }
                    txtNoidungKN.Text = oND.NOIDUNGKN;
                  

                    rdbCapkhangnghi.Items.Clear();
                    if (rdbDonVi.SelectedValue == "0")//Chánh án
                    {
                        rdbCapkhangnghi.Items.Add(new ListItem("Cấp trên", "1"));
                        rdbCapkhangnghi.SelectedValue = "1";
                    }
                    else//Viện kiểm sát
                    {
                        rdbCapkhangnghi.Items.Add(new ListItem("Cùng cấp", "0"));
                        rdbCapkhangnghi.Items.Add(new ListItem("Cấp trên", "1"));
                        rdbCapkhangnghi.SelectedValue = "0";
                    }
                    rdbCapkhangnghi.SelectedValue = oND.CAPKN.ToString();
                    if (rdbCapkhangnghi.SelectedValue == "0")
                    {
                        trDVKN.Visible = false;
                    }
                    else
                    {
                        trDVKN.Visible = true;
                        LoadDVKN();
                        ddlDonViKN.SelectedValue = oND.TOAAN_VKS_KN.ToString();
                    }

                }
            }
        }
        public void xoa(decimal ID, decimal IsKhangCao)
        {
            if (IsKhangCao == KHANGCAO)// Kháng cáo
            {
                AKT_SOTHAM_KHANGCAO oND = dt.AKT_SOTHAM_KHANGCAO.Where(x => x.ID == ID).FirstOrDefault();
                if (oND != null)
                {
                    dt.AKT_SOTHAM_KHANGCAO.Remove(oND);
                }
            }
            else // Kháng nghị
            {
                AKT_SOTHAM_KHANGNGHI oND = dt.AKT_SOTHAM_KHANGNGHI.Where(x => x.ID == ID).FirstOrDefault();
                if (oND != null)
                {
                    dt.AKT_SOTHAM_KHANGNGHI.Remove(oND);
                }
            }
            dt.SaveChanges();

            LoadGridKCKN();
            ResetControlsKCKN();
            lbthongbao.Text = "Xóa thành công!";
        }
        protected void rdbPanelKN_SelectedIndexChanged(object sender, EventArgs e)
        {
            lbthongbao.Text = "";
            if (rdbPanelKN.SelectedValue == KHANGCAO.ToString()) // Kháng cáo
            {
                rdbPanelKC.SelectedValue = KHANGCAO.ToString();
                pnKhangCao.Visible = true; hddShowKhangCao.Value = "1";
                pnKhangNghi.Visible = false;
                Cls_Comon.SetFocus(this, this.GetType(), txtNgayvietdonKC.ClientID);
            }
            else // Kháng nghị
            {
                rdbPanelKC.SelectedValue = KHANGNGHI.ToString();
                pnKhangCao.Visible = false; hddShowKhangCao.Value = "0";
                pnKhangNghi.Visible = true;
                Cls_Comon.SetFocus(this, this.GetType(), txtSokhangnghi.ClientID);
            }
        }
        protected void ddlThuly_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlThuly.SelectedIndex == 0)
            {
                pnKhangCao.Visible = true;
                lastPanel.Visible = true;
                cmdUpdate.Visible = true;
            }
            else
            {
                pnKhangCao.Visible = false;
                lastPanel.Visible = false;
                cmdUpdate.Visible = false;
            }
        }
        protected void rdbPanelKC_SelectedIndexChanged(object sender, EventArgs e)
        {
            lbthongbao.Text = "";
            if (rdbPanelKC.SelectedValue == KHANGCAO.ToString()) // Kháng cáo
            {
                rdbPanelKN.SelectedValue = KHANGCAO.ToString();
                pnKhangCao.Visible = true;
                hddShowKhangCao.Value = "1";
                pnKhangNghi.Visible = false;
                Cls_Comon.SetFocus(this, this.GetType(), txtNgayvietdonKC.ClientID);
            }
            else // Kháng nghị
            {
                rdbPanelKN.SelectedValue = KHANGNGHI.ToString();
                pnKhangCao.Visible = false; hddShowKhangCao.Value = "0";
                pnKhangNghi.Visible = true;
                Cls_Comon.SetFocus(this, this.GetType(), txtSokhangnghi.ClientID);
            }
        }
        protected void rdbLoaiKN_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                decimal vDonid = Convert.ToDecimal(hddID.Value);
                txtNgayQDBA_KN.Text = "";
                LoadQD_BAKhangNghi(vDonid);
                Cls_Comon.SetFocus(this, this.GetType(), ddlSOQDBAKhangNghi.ClientID);
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void rdbDonVi_SelectedIndexChanged(object sender, EventArgs e)
        {
            rdbCapkhangnghi.Items.Clear();
            if (rdbDonVi.SelectedValue == "0")//Chánh án
            {
                rdbCapkhangnghi.Items.Add(new ListItem("Cấp trên", "1"));
                rdbCapkhangnghi.SelectedValue = "1";
            }
            else//Viện kiểm sát
            {
                rdbCapkhangnghi.Items.Add(new ListItem("Cùng cấp", "0"));
                rdbCapkhangnghi.Items.Add(new ListItem("Cấp trên", "1"));
                rdbCapkhangnghi.SelectedValue = "0";
            }
            if (rdbCapkhangnghi.SelectedValue == "0")
            {
                decimal vdonid = Convert.ToDecimal(hddID.Value);
                AKT_DON oD = dt.AKT_DON.Where(x => x.ID == vdonid).FirstOrDefault();
                decimal ToaAnID = 0;
                if (oD != null)
                    ToaAnID = Convert.ToDecimal(oD.TOAANID);
                else
                    ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                ddlDonViKN.Items.Clear();
                //decimal ToaAnID = Convert.ToDecimal(vdonviid);
                List<DM_VKS> lstVKS = dt.DM_VKS.Where(x => x.TOAANID == ToaAnID).ToList();
                if (lstVKS.Count > 0)
                {
                    ddlDonViKN.Items.Add(new ListItem(lstVKS[0].TEN, lstVKS[0].ID.ToString()));
                }
                trDVKN.Visible = true;
            }
            else
            {
                trDVKN.Visible = true;
                LoadDVKN();
            }
        }
        private void LoadDVKN()
        {
            decimal vdonid = Convert.ToDecimal(hddID.Value);
            AKT_DON oD = dt.AKT_DON.Where(x => x.ID == vdonid).FirstOrDefault();
            decimal ToaAnID = 0;
            if (oD != null)
                ToaAnID = Convert.ToDecimal(oD.TOAANID);
            else
            {
                ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            }
            ddlDonViKN.Items.Clear();
            //decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            DM_TOAAN oTA = dt.DM_TOAAN.Where(x => x.ID == ToaAnID).FirstOrDefault();
            if (rdbDonVi.SelectedValue == "0")//Tòa án
            {
                DM_TOAAN oTAP1 = dt.DM_TOAAN.Where(x => x.ID == oTA.CAPCHAID).FirstOrDefault();
                ddlDonViKN.Items.Add(new ListItem(oTAP1.TEN, oTAP1.ID.ToString()));
                if (oTAP1.CAPCHAID != 0)
                {
                    DM_TOAAN oTAP2 = dt.DM_TOAAN.Where(x => x.ID == oTAP1.CAPCHAID).FirstOrDefault();
                    ddlDonViKN.Items.Add(new ListItem(oTAP2.TEN, oTAP2.ID.ToString()));
                    if (oTAP2.CAPCHAID != 0)
                    {
                        DM_TOAAN oTAP3 = dt.DM_TOAAN.Where(x => x.ID == oTAP2.CAPCHAID).FirstOrDefault();
                        ddlDonViKN.Items.Add(new ListItem(oTAP3.TEN, oTAP3.ID.ToString()));
                    }
                }
            }
            else//Viện kiểm sát
            {
                List<DM_VKS> lstVKS = dt.DM_VKS.Where(x => x.TOAANID == ToaAnID).ToList();
                if (lstVKS.Count > 0)
                {
                    decimal IDVKS1 = (decimal)lstVKS[0].CAPCHAID;
                    DM_VKS oVKS1 = dt.DM_VKS.Where(x => x.ID == IDVKS1).FirstOrDefault();
                    ddlDonViKN.Items.Add(new ListItem(oVKS1.TEN, oVKS1.ID.ToString()));
                    if (oVKS1.CAPCHAID != 0)
                    {
                        DM_VKS oVKS2 = dt.DM_VKS.Where(x => x.ID == oVKS1.CAPCHAID).FirstOrDefault();
                        ddlDonViKN.Items.Add(new ListItem(oVKS2.TEN, oVKS2.ID.ToString()));
                        if (oVKS2.CAPCHAID != 0)
                        {
                            DM_VKS oVKS3 = dt.DM_VKS.Where(x => x.ID == oVKS2.CAPCHAID).FirstOrDefault();
                            ddlDonViKN.Items.Add(new ListItem(oVKS3.TEN, oVKS3.ID.ToString()));
                        }
                    }
                }
            }
        }
        protected void rdbCapkhangnghi_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdbCapkhangnghi.SelectedValue == "0")
            {
                trDVKN.Visible = false;
            }
            else
            {
                trDVKN.Visible = true;
                LoadDVKN();
            }
        }
        private void ResetControlsKCKN()
        {
            lbthongbao.Text = "";
            rdbPanelKC.Visible = rdbPanelKN.Visible = true;
            if (rdbPanelKC.SelectedValue == KHANGCAO.ToString() && rdbPanelKN.SelectedValue == KHANGCAO.ToString())//
            {
                #region Kháng cáo
                rdbHinhThucNhanDon.SelectedValue = "1";
                txtNgayvietdonKC.Text = txtNgaykhangcao.Text = "";
                ddlNguoikhangcao.SelectedIndex = 0;
                rdbLoaiKC.SelectedValue = "0";
                rdbQuahan_KC.SelectedValue = "0";
                LoadQD_BAKhangCao(0);
                txtNoidungKC.Text = "";
                hddKCID.Value = "0";

                #endregion
            }
            else if (rdbPanelKC.SelectedValue == KHANGNGHI.ToString() && rdbPanelKN.SelectedValue == KHANGNGHI.ToString())
            {
                #region Kháng nghị
                txtSokhangnghi.Text = txtNgaykhangnghi.Text = "";
                rdbCapkhangnghi.SelectedValue = "1";
                rdbLoaiKN.SelectedValue = "0";
                LoadQD_BA_InfoKhangNghi();
                txtNoidungKN.Text = "";
                hddKNID.Value = "0";
                #endregion
            }
            rdbLoaiKC.SelectedValue = null;
        }
        private bool CheckValid(decimal isKhangCao)
        {
            if (isKhangCao == KHANGCAO)// Kháng cáo
            {
                if (rdbHinhThucNhanDon.SelectedValue == "")
                {
                    lbthongbao.Text = "Bạn chưa chọn hình thức nhận đơn. Hãy chọn lại!";
                    return false;
                }
                if (txtNgayvietdonKC.Text.Trim().Length > 0 && Cls_Comon.IsValidDate(txtNgayvietdonKC.Text) == false)
                {
                    lbthongbao.Text = "Ngày viết đơn phải theo định dạng (dd/MM/yyyy)!";
                    txtNgayvietdonKC.Focus();
                    return false;
                }
                if (Cls_Comon.IsValidDate(txtNgaykhangcao.Text) == false)
                {
                    lbthongbao.Text = "Ngày kháng cáo chưa nhập hoặc không theo định dạng (dd/MM/yyyy)!";
                    txtNgaykhangcao.Focus();
                    return false;
                }


                if (ddlNguoikhangcao.SelectedValue == "0")
                {
                    lbthongbao.Text = "Chưa chọn người kháng cáo. Hãy chọn lại!";
                    ddlNguoikhangcao.Focus();
                    return false;
                }
                if (rdbLoaiKC.SelectedValue == "")
                {
                    lbthongbao.Text = "Bạn chưa chọn loại kháng cáo. Hãy chọn lại!";
                    return false;
                }
                if (ddlSOQDBA_KC.SelectedValue == "0")
                {
                    lbthongbao.Text = "Bạn chưa chọn số QĐ/BA. Hãy chọn lại!";
                    return false;
                }
                if (rdbQuahan_KC.SelectedValue == "")
                {
                    lbthongbao.Text = "Bạn chưa chọn loại kháng cáo quá hạn. Hãy chọn lại!";
                    return false;
                }
                if (txtNoidungKC.Text == "")
                {
                    lbthongbao.Text = "Bạn chưa nhập nội dung kháng cáo.";
                    return false;
                }

                //Kiểm tra ngày kháng cáo
                DateTime dNgayKC = (String.IsNullOrEmpty(txtNgaykhangcao.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgaykhangcao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (dNgayKC > DateTime.Now)
                {
                    lbthongbao.Text = "Ngày kháng cáo không được lớn hơn ngày hiện tại !";
                    txtNgaykhangcao.Focus();
                    return false;
                }
                DateTime dNgayQDBA = (String.IsNullOrEmpty(txtNgayQDBA_KC.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayQDBA_KC.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                decimal DONID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI]);
                decimal DSID = Convert.ToDecimal(ddlNguoikhangcao.SelectedValue);
                if (rdbLoaiKC.SelectedValue == "0")//Bản án
                {
                    if (dNgayKC < dNgayQDBA)
                    {
                        lbthongbao.Text = "Ngày kháng cáo không được trước ngày bản án !";
                        txtNgaykhangcao.Focus();
                        return false;
                    }
                }
                else//Quyết định
                {
                    if (dNgayKC < dNgayQDBA)
                    {
                        lbthongbao.Text = "Ngày kháng cáo không được trước ngày quyết định !";
                        txtNgaykhangcao.Focus();
                        return false;
                    }
                }
            }
            else// Kháng nghị
            {
                if (txtSokhangnghi.Text == "")
                {
                    lbthongbao.Text = "Bạn chưa nhập số kháng nghị. Hãy nhập lại!";
                    txtSokhangnghi.Focus();
                    return false;
                }
                if (Cls_Comon.IsValidDate(txtNgaykhangnghi.Text) == false)
                {
                    lbthongbao.Text = "Ngày kháng nghị phải theo định dạng (dd/MM/yyyy)!";
                    txtNgaykhangnghi.Focus();
                    return false;
                }
                if (rdbCapkhangnghi.SelectedValue == "")
                {
                    lbthongbao.Text = "Bạn chưa chọn cấp kháng nghị. Hãy chọn lại!";
                    return false;
                }
                if (rdbLoaiKN.SelectedValue == "")
                {
                    lbthongbao.Text = "Bạn chưa chọn loại kháng nghị. Hãy chọn lại!";
                    return false;
                }
                if (ddlSOQDBAKhangNghi.SelectedValue == "0")
                {
                    lbthongbao.Text = "Bạn chưa chọn số QĐ/BA. Hãy chọn lại!";
                    return false;
                }
                if (txtNoidungKN.Text == "")
                {
                    lbthongbao.Text = "Bạn chưa nhập nội dung kháng nghị.";
                    return false;
                }
                if (txtNoidungKN.Text.Trim().Length > 1000)
                {
                    lbthongbao.Text = "Nội dung kháng nghị không quá 1000 ký tự. Hãy nhập lại!";
                    txtNoidungKN.Focus();
                    return false;
                }
            }
            return true;
        }

        protected void rdbLoaiKC_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                txtNgayQDBA_KC.Text = "";
                decimal vDonid = Convert.ToDecimal(hddID.Value);
                LoadQD_BAKhangCao(vDonid);
                Cls_Comon.SetFocus(this, this.GetType(), ddlSOQDBA_KC.ClientID);
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void ddlSOQDBA_KC_SelectedIndexChanged(object sender, EventArgs e)
        {
            txtNgayQDBA_KC.Text = "";
            try {
                decimal vDonid = Convert.ToDecimal(hddID.Value);
                LoadQD_BA_InfoKhangCao(vDonid);
            } catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void ddlSOQDBAKhangNghi_SelectedIndexChanged(object sender, EventArgs e)
        {
            txtNgayQDBA_KN.Text = "";
            LoadQD_BA_InfoKhangNghi();
        }

        //-----------------------------------------------
        protected void lkThemDuongSuKhac_Click(object sender, EventArgs e)
        {
            string strDonID = Session["KT_THEMDSK"] + "";
            if (strDonID != "" && DonID == 0)
                DonID = Convert.ToDecimal(strDonID);
            else
                DonID = Convert.ToDecimal(hddID.Value);

            string StrMsg = "PopupReport('/QLAN/AKT/TaoHS/Popup/pDuongsu.aspx?hsID=" + DonID.ToString() + "&bID=0','Thêm người tham gia tố tụng',950,450);";
            System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
        }
        protected void lkThemNguoiTGTT_Click(object sender, EventArgs e)
        {
            string strDonID = Session["KT_THEMDSK"] + "";
            if (strDonID != "" && DonID == 0)
                DonID = Convert.ToDecimal(strDonID);
            else
                DonID = Convert.ToDecimal(hddID.Value);

            string StrMsg = "PopupReport('/QLAN/AKT/TaoHS/Popup/pNguoiThamgiaTT.aspx?hsID=" + DonID.ToString() + "&bID=0','Thêm người tham gia tố tụng',950,450);";
            System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
        }
        protected void cmdLoadDsDuongSuKhac_Click(object sender, EventArgs e)
        {
            decimal vDONID = Convert.ToDecimal(hddID.Value);
            DsDuongSu1.DonID = vDONID;
            DsDuongSu1.LoadGrid();
            LoadComboboxKhangCao(vDONID);
            LoadComboboxKhangNghi();
            LoadGridKCKN();

        }
        protected void cmdLoadDsNguoiTGTT_Click(object sender, EventArgs e)
        {
            decimal vDONID = Convert.ToDecimal(hddID.Value);
            uDSNguoiThamGiaToTung.Donid = vDONID;
            uDSNguoiThamGiaToTung.LoadGrid();

            LoadComboboxKhangCao(vDONID);
            LoadComboboxKhangNghi();
            LoadGridKCKN();

        }


        private void txtQuanhephapluat_name(AKT_DON oT)
        {
            if (oT.QUANHEPHAPLUAT_NAME != null)
            {
                txtQuanhephapluat.Text = oT.QUANHEPHAPLUAT_NAME;
            }
            else if (oT.QUANHEPHAPLUATID != null && oT.QUANHEPHAPLUATID != 0)
            {
                decimal IDQHPL = Convert.ToDecimal(oT.QUANHEPHAPLUATID.ToString());
                DM_DATAITEM obj = dt.DM_DATAITEM.Where(x => x.ID == IDQHPL).FirstOrDefault();
                if (obj != null) txtQuanhephapluat.Text = obj.TEN.ToString();
            }
            else
                txtQuanhephapluat.Text = null;
        }
    }
}