using BL.GSTP;
using BL.GSTP.ADS;
using BL.GSTP.BANGSETGET.HOAGIAI;
using BL.GSTP.BANGSETGET;
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
using Module.Common.C06;
using BL.GSTP.DLQGC06;
using System.Text;
using System.Xml;
using System.Text.RegularExpressions;
using BL.GSTP.DLQGC12;

namespace WEB.GSTP.QLAN.ADS.Hoso
{
    public partial class Thongtindon : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private const decimal ROOT = 0;

        private void SetDonGhep()
        {
            string keyDonID = "DONGHEP.DONID" + Session[ENUM_SESSION.SESSION_USERID].ToString();
            string keyLoaiAnId = "DONGHEP.LOAIANID" + Session[ENUM_SESSION.SESSION_USERID].ToString();
            Session[keyDonID] = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_DANSU]);
            Session[keyLoaiAnId] = Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_DANSU);
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID]?.ToString()))
            {
                Response.Redirect("/Trangchu.aspx");
                return;
            }

            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            //scriptManager.RegisterPostBackControl(this.txtND_Ngaysinh);
            scriptManager.RegisterPostBackControl(this.ddlNDD_Tinh_NguyenDon);
            scriptManager.RegisterPostBackControl(this.ddlND_Quoctich);
            scriptManager.RegisterPostBackControl(this.chkBoxCMNDND);
            //scriptManager.RegisterPostBackControl(this.txtND_Namsinh);
            scriptManager.RegisterPostBackControl(this.ddlTamTru_Tinh_NguyenDon);

            scriptManager.RegisterPostBackControl(this.ddlBD_Quoctich);
            scriptManager.RegisterPostBackControl(this.ddlNDD_Tinh_BiDon);
            scriptManager.RegisterPostBackControl(this.chkBoxCMNDBD);
            scriptManager.RegisterPostBackControl(this.txtBD_Ngaysinh);
            scriptManager.RegisterPostBackControl(this.txtBD_Namsinh);
            scriptManager.RegisterPostBackControl(this.ddlTamTru_Tinh_BiDon);

            if (!IsPostBack)
            {
                try
                {
                    SetDonGhep();
                    txtNgayNhan.Text = DateTime.Now.ToString("dd/MM/yyyy");
                    LoadCombobox();
                    qlhl_check_load();
                    ddlLoaiNguyendon_SelectedIndexChanged(sender, e);
                    ddlLoaiBidon_SelectedIndexChanged(sender, e);
                    string current_id = Request["ID"] + "";
                    string strtype = Request["type"] + "";
                    DsDuongSu1.Visible = false;
                    DsDuongSu1.DonID = 0;
                    LoadLoaiDon(false);
                    string strDonID = Session["DS_THEMDSK"] + "";
                    if (strtype == "new")
                    {
                        ltCMNDND.Text = "<span style='color:red'>(*)</span>";
                        ltCCCDND.Text = "<span style='color:red'>(*)</span>";
                        ltCMNDBD.Text = "<span style='color:red'>(*)</span>";
                        ltCCCDBD.Text = "<span style='color:red'>(*)</span>";
                        DONGHEP.Visible = false;
                        if (strDonID != "")
                        {
                            hddID.Value = Session["DS_THEMDSK"] + "";
                            decimal ID = Convert.ToDecimal(Session["DS_THEMDSK"]);
                            LoadInfo(ID);
                            DsDuongSu1.Visible = true;
                            DsDuongSu1.DonID = ID;
                            DsDuongSu1.ReLoad();
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
                        }
                    }
                    else
                    {
                        current_id = Session[ENUM_LOAIAN.AN_DANSU] + "";
                        if (current_id != "" && current_id != "0")
                        {
                            hddID.Value = current_id.ToString();
                            decimal ID = Convert.ToDecimal(current_id);
                            LoadInfo(ID);
                            DsDuongSu1.Visible = true;
                            DsDuongSu1.DonID = ID;
                            DsDuongSu1.ReLoad();
                        }
                    }
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));

                    Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                    Cls_Comon.SetButton(cmdUpdateB, oPer.CAPNHAT);
                    Cls_Comon.SetButton(cmdUpdateSelect, oPer.CAPNHAT);
                    Cls_Comon.SetButton(cmdUpdateAndNew, oPer.CAPNHAT);
                    Cls_Comon.SetButton(cmdUpdateSelectB, oPer.CAPNHAT);
                    Cls_Comon.SetButton(cmdUpdateAndNewB, oPer.CAPNHAT);
                    Cls_Comon.SetFocus(this, this.GetType(), ddlHinhthucnhandon.ClientID);
                    if (hddID.Value != "" && hddID.Value != "0")
                    {
                        decimal ID = Convert.ToDecimal(hddID.Value);
                        ADS_DON oT = dt.ADS_DON.Where(x => x.ID == ID).FirstOrDefault();
                        if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                        {
                            lstMsgT.Text = lstMsgB.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                            Cls_Comon.SetButton(cmdUpdate, false);
                            Cls_Comon.SetButton(cmdUpdateB, false);
                            Cls_Comon.SetButton(cmdUpdateSelect, false);
                            Cls_Comon.SetButton(cmdUpdateAndNew, false);
                            Cls_Comon.SetButton(cmdUpdateSelectB, false);
                            Cls_Comon.SetButton(cmdUpdateAndNewB, false);
                            return;
                        }
                        string StrMsg = "Không được sửa đổi thông tin.";
                        string Result = new ADS_CHUYEN_NHAN_AN_BL().Check_NhanAn(ID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                        if (Result != "")
                        {
                            lstMsgT.Text = lstMsgB.Text = Result;
                            Cls_Comon.SetButton(cmdUpdate, false);
                            Cls_Comon.SetButton(cmdUpdateB, false);
                            Cls_Comon.SetButton(cmdUpdateSelect, false);
                            Cls_Comon.SetButton(cmdUpdateAndNew, false);
                            Cls_Comon.SetButton(cmdUpdateSelectB, false);
                            Cls_Comon.SetButton(cmdUpdateAndNewB, false);
                            return;
                        }

                        if (!String.IsNullOrEmpty(oT.TOA_GIAIQUYET_ID.ToString()) && oT.TOA_GIAIQUYET_ID != Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]))
                        {
                            Cls_Comon.SetButton(cmdUpdate, false);
                            Cls_Comon.SetButton(cmdUpdateB, false);
                            Cls_Comon.SetButton(cmdUpdateSelect, false);
                            Cls_Comon.SetButton(cmdUpdateAndNew, false);
                            Cls_Comon.SetButton(cmdUpdateSelectB, false);
                            Cls_Comon.SetButton(cmdUpdateAndNewB, false);
                            lstMsgT.Text = lstMsgB.Text = "Vụ việc được chuyển từ tòa cũ sau sát nhập không được sửa đổi !";
                        }
                        //check vụ án đã kết thúc không cho sửa xóa
                        Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                        if (anKetThuc)
                        {
                            lstMsgT.Text = lstMsgB.Text = "Vụ án đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới";
                            Cls_Comon.SetButton(cmdUpdate, false);
                            Cls_Comon.SetButton(cmdUpdateB, false);
                            Cls_Comon.SetButton(cmdUpdateSelect, false);
                            Cls_Comon.SetButton(cmdUpdateAndNew, false);
                            Cls_Comon.SetButton(cmdUpdateSelectB, false);
                            Cls_Comon.SetButton(cmdUpdateAndNewB, false);
                            return;
                        }

                    }
                    else
                    {
                        SetTinhHuyenMacDinh();

                        // Những combobox old nếu là thêm mới
                        // Ẩn cán bộ nhận đơn toà cũ
                        ddlOldCanbonhandon.Visible = false;
                        // Thẩm phán ký nhận đơn toà cũ
                        ddlOldThamphankynhandon.Visible = false;
                    }
                    ddlHinhthucnhandon.Focus();
                    if (strtype != "new")
                    {
                        current_id = Session[ENUM_LOAIAN.AN_DANSU] + "";
                        if (!string.IsNullOrEmpty(current_id))
                        {
                            decimal Id = Convert.ToDecimal(current_id);
                            List<ADS_DON_THAMPHAN> oDON_THAMPHAN = dt.ADS_DON_THAMPHAN.Where(x => x.DONID == Id).ToList<ADS_DON_THAMPHAN>();
                            if (oDON_THAMPHAN.Count > 0)
                            {
                                lstMsgT.Text = lstMsgB.Text = "Đã có thẩm phán giải quyết đơn, không được thay đổi !";
                                ckbTienHanhHG.Enabled = false;
                                Cls_Comon.SetButton(cmdUpdate, false);
                                Cls_Comon.SetButton(cmdUpdate, false);
                                Cls_Comon.SetButton(cmdUpdateB, false);
                                Cls_Comon.SetButton(cmdUpdateSelect, false);
                                Cls_Comon.SetButton(cmdUpdateAndNew, false);
                                Cls_Comon.SetButton(cmdUpdateSelectB, false);
                                Cls_Comon.SetButton(cmdUpdateAndNewB, false);
                            }
                            
                            List<ADS_DON_XULY> oDON_XLY = dt.ADS_DON_XULY.Where(x => x.DONID == Id).ToList<ADS_DON_XULY>();
                            if (oDON_XLY.Count > 0)
                            {
                                lstMsgT.Text = lstMsgB.Text = "Đơn đã được xử lý không được thay đổi !";
                                Cls_Comon.SetButton(cmdUpdate, false);
                                Cls_Comon.SetButton(cmdUpdate, false);
                                Cls_Comon.SetButton(cmdUpdateB, false);
                                Cls_Comon.SetButton(cmdUpdateSelect, false);
                                Cls_Comon.SetButton(cmdUpdateAndNew, false);
                                Cls_Comon.SetButton(cmdUpdateSelectB, false);
                                Cls_Comon.SetButton(cmdUpdateAndNewB, false);
                            }
                        }

                    }
                    if (Request["ChiTiet"] != null)
                    {
                        //chỉ xem chi tiết
                        cmdUpdate.Visible = false;
                        cmdUpdateSelect.Visible = false;
                        cmdUpdateAndNew.Visible = false;
                        cmdQuaylai.Visible = false;
                        cmdUpdateB.Visible = false;
                        cmdUpdateSelectB.Visible = false;
                        cmdUpdateAndNewB.Visible = false;
                        cmdQuaylaiB.Visible = false;
                        DsDuongSu1.hiddenbtnThemMoi();
                        DONGHEP.hiddenbtnThemMoi();
                    }
                }
                catch (Exception ex) { lstMsgT.Text = lstMsgB.Text = ex.Message; }
            }
            DsDuongSu1.DonID = Convert.ToDecimal(hddID.Value);
            EnableControl();
        }

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
        void LoadLoaiDon(bool blnTructuyen)
        {
            ddlHinhthucnhandon.Items.Clear();
            if (blnTructuyen)
                ddlHinhthucnhandon.Items.Add(new ListItem("Trực tuyến", "3"));
            else
            {
                ddlHinhthucnhandon.Items.Add(new ListItem("Trực tiếp", "1"));
                ddlHinhthucnhandon.Items.Add(new ListItem("Qua bưu điện", "2"));
            }
        }
        private void LoadInfo(decimal ID)
        {
            // GTEL-HUNGNQ 01-10-2025 lấy thông tin xác thực C06 của nguyên đơn
            KHOBAQD_BL adsDon = new KHOBAQD_BL();

            ADS_DON oT = dt.ADS_DON.Where(x => x.ID == ID).FirstOrDefault();
            txtMaVuViec.Text = oT.MAVUVIEC;
            txtTenVuViec.Text = oT.TENVUVIEC;
            // if (oT.SOTHUTU != null) txtSothutu.Text = oT.SOTHUTU.ToString();
            if (oT.HINHTHUCNHANDON == 3)
                LoadLoaiDon(true);
            else
                LoadLoaiDon(false);
            ddlHinhthucnhandon.SelectedValue = oT.HINHTHUCNHANDON.ToString();
            if (oT.NGAYVIETDON != DateTime.MinValue) txtNgayViet.Text = ((String.IsNullOrEmpty(oT.NGAYVIETDON + "")) || (((DateTime)oT.NGAYVIETDON) == DateTime.MinValue)) ? "" : ((DateTime)oT.NGAYVIETDON).ToString("dd/MM/yyyy", cul); //((DateTime)oT.NGAYVIETDON).ToString("dd/MM/yyyy", cul);
            if (oT.NGAYNHANDON != DateTime.MinValue) txtNgayNhan.Text = ((String.IsNullOrEmpty(oT.NGAYNHANDON + "")) || (((DateTime)oT.NGAYNHANDON) == DateTime.MinValue)) ? "" : ((DateTime)oT.NGAYNHANDON).ToString("dd/MM/yyyy", cul); //((DateTime)oT.NGAYNHANDON).ToString("dd/MM/yyyy", cul);
            ddlLoaiQuanhe.SelectedValue = oT.LOAIQUANHE.ToString();
            txtQuanhephapluat_name(oT);
            if (oT.QHPLTKID != null)
            {
                ddlQHPLTK.SelectedValue = oT.QHPLTKID.ToString();
                qlhl_check_load();
            }
            if (ddlCanbonhandon.Items.FindByValue(oT.CANBONHANDONID + "") != null)
            {
                ddlCanbonhandon.SelectedValue = oT.CANBONHANDONID + "";
            }
            if (ddlOldCanbonhandon.Items.FindByValue(oT.CANBONHANDONID + "") != null)
            {
                ddlOldCanbonhandon.SelectedValue = oT.CANBONHANDONID + "";
            }

            if (ddlThamphankynhandon.Items.FindByValue(oT.THAMPHANKYNHANDON + "") != null)
            {
                ddlThamphankynhandon.SelectedValue = oT.THAMPHANKYNHANDON + "";
            }
            if (ddlOldThamphankynhandon.Items.FindByValue(oT.THAMPHANKYNHANDON + "") != null)
            {
                ddlOldThamphankynhandon.SelectedValue = oT.THAMPHANKYNHANDON + "";
            }

            #region Trạng thái hòa giải
            if (oT.HOAGIAI_TRANGTHAI.GetValueOrDefault(0) > 0)
            {
                ckbTienHanhHG.Checked = true;
            }
            else
            {
                ckbTienHanhHG.Checked = false;
            }
            #endregion
            ddlYeutonuocngoai.SelectedValue = oT.YEUTONUOCNGOAI.ToString();

            ddlLoaidon.SelectedValue = oT.LOAIDON.ToString();
            txtNoidungkhoikien.Text = oT.NOIDUNGKHOIKIEN + "";
            //Load Nguyên đơn
            #region "NGUYÊN ĐƠN ĐẠI DIỆN"
            List<ADS_DON_DUONGSU> lstNguyendon = dt.ADS_DON_DUONGSU.Where(x => x.DONID == oT.ID && x.ISDAIDIEN == 1 && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON).ToList();
            ADS_DON_DUONGSU oND = new ADS_DON_DUONGSU();
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
                    chkISBVQLNK.Visible = false;
                }
                else
                {
                    pnNDCanhan.Visible = false;
                    pnNDTochuc.Visible = true;
                    chkISBVQLNK.Visible = true;
                    if (oND.ISBVQLNGUOIKHAC == 1) chkISBVQLNK.Checked = true;
                }
                //if (string.IsNullOrEmpty(oND.SOCMND))
                //{
                //    chkBoxCMNDND.Checked = true;

                //    ltCMNDND.Text = "";
                //}
                //else
                //{
                //    ltCMNDND.Text = "<span style='color:red'>(*)</span>";
                //    chkBoxCMNDND.Checked = false;
                //}
                txtND_CMND.Text = oND.SOCMND;
                txtND_CCCD.Text = oND.SO_CCCD;
                txtND_HoChieu.Text = oND.SO_HO_CHIEU;
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
                if (oND.NGAYSINH != DateTime.MinValue && oND.NGAYSINH != null) txtND_Ngaysinh.Text = ((DateTime)oND.NGAYSINH).ToString("dd/MM/yyyy", cul);
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

                // GTEL-HUNGNQ 01-10-2025 lấy thông tin xác thực C06 của nguyên đơn
                if (oND.XACTHUC_DLDCQG.HasValue)
                {
                    chkKhongLamSachND.Checked = oND.XACTHUC_DLDCQG.ToString() == "3";

                    if (chkKhongLamSachND.Checked)
                    {
                        hdTrangThaiXacThucND.Value = "3";
                    }
                    else
                    {
                        hdTrangThaiXacThucND.Value = oND.XACTHUC_DLDCQG.ToString();
                    }
                }

                if (!string.IsNullOrEmpty(oND.CHK_KHONG_CO))
                {
                    if (hdTrangThaiXacThucND.Value == "1")
                        chkBoxCMNDND.Checked = false;
                    else
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

                if (hdTrangThaiXacThucND.Value == "1")
                {
                    cmdGet037ND.Enabled = false;
                    chkKhongLamSachND.Enabled = false;
                    chkBoxCMNDND.Enabled = false;
                }
                else
                {
                    cmdGet037ND.Enabled = true;
                    chkKhongLamSachND.Enabled = true;
                    chkBoxCMNDND.Enabled = true;
                }
            }
            #endregion
            //Load Bị đơn
            #region "BỊ ĐƠN ĐẠI DIỆN"
            List<ADS_DON_DUONGSU> lstBidon = dt.ADS_DON_DUONGSU.Where(x => x.DONID == oT.ID && x.ISDAIDIEN == 1 && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.BIDON).ToList();
            ADS_DON_DUONGSU oBD = new ADS_DON_DUONGSU();
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
                //if (string.IsNullOrEmpty(oBD.SOCMND))
                //{
                //    chkBoxCMNDBD.Checked = true;
                //    ltCMNDBD.Text = "";
                //}
                //else
                //{
                //    ltCMNDBD.Text = "<span style='color:red'>(*)</span>";
                //    ltCCCDBD.Text = "<span style='color:red'>(*)</span>";
                //    chkBoxCMNDBD.Checked = false;
                //}
                txtBD_CMND.Text = oBD.SOCMND;
                // VNPT Nguyễn Đăng Huy Hoàng 12/11/2025 13:15:00
                // reload cccd phục vụ gửi thông báo tống đạt
                txtBD_CCCD.Text = oBD.SO_CCCD;
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
                if (oBD.NGAYSINH != DateTime.MinValue && oBD.NGAYSINH != null) txtBD_Ngaysinh.Text = ((DateTime)oBD.NGAYSINH).ToString("dd/MM/yyyy", cul);
                txtBD_Namsinh.Text = oBD.NAMSINH == 0 ? "" : oBD.NAMSINH.ToString();
                //txtBD_Tuoi.Text = oBD.TUOI == 0 ? "" : oBD.TUOI.ToString();
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
                    //lblBD_Batbuoc1.Text =
                    // lblBD_Batbuoc2.Text = "";
                    chkBD_ONuocNgoai.Visible = false;
                }
                else
                {
                    //lblBD_Batbuoc1.Text = 
                    //lblBD_Batbuoc2.Text = "(*)";
                    chkBD_ONuocNgoai.Visible = true;
                }

                // GTEL-HUNGNQ 01-10-2025 lấy thông tin xác thực C06 của nguyên đơn
                if (oBD.XACTHUC_DLDCQG.HasValue)
                {
                    chkKhongLamSachBD.Checked = oBD.XACTHUC_DLDCQG.ToString() == "3";

                    if (chkKhongLamSachBD.Checked)
                    {
                        hdTrangThaiXacThucBD.Value = "3";
                    }
                    else
                    {
                        hdTrangThaiXacThucBD.Value = oBD.XACTHUC_DLDCQG.ToString();
                    }
                }

                if (!string.IsNullOrEmpty(oBD.CHK_KHONG_CO))
                {
                    if (hdTrangThaiXacThucBD.Value == "1")
                        chkBoxCMNDBD.Checked = false;
                    else
                        chkBoxCMNDBD.Checked = oBD.CHK_KHONG_CO.ToString() == "1";
                }
                else
                {
                    chkBoxCMNDBD.Checked = false;
                }

                if (!chkBoxCMNDBD.Checked)
                {
                    ltCMNDBD.Text = "<span style='color:red'>(*)</span>";
                    ltCCCDBD.Text = "<span style='color:red'>(*)</span>";
                }
                else
                {
                    ltCMNDBD.Text = "";
                    ltCCCDBD.Text = "";
                }

                if (hdTrangThaiXacThucBD.Value == "1")
                {
                    cmdGet037BD.Enabled = false;
                    chkKhongLamSachBD.Enabled = false;
                    chkBoxCMNDBD.Enabled = false;
                }
                else
                {
                    cmdGet037BD.Enabled = true;
                    chkKhongLamSachBD.Enabled = true;
                    chkBoxCMNDBD.Enabled = true;
                }
            }
            #endregion

            // Gán toà án giải quyết
            hddToaanId.Value = oT.TOAANID.ToString();
            hddToaAnGiaiQuyetId.Value = oT.TOA_GIAIQUYET_ID.ToString();

            // Nếu là thêm thì ẩn toà cũ
            if (string.IsNullOrEmpty(hddID.Value) || hddID.Value == "0")
            {
                ddlOldCanbonhandon.Visible = false;
                ddlOldThamphankynhandon.Visible = false;
            }
            else
            {
                // Nếu là sửa thì ẩn toà cũ đi
                if (hddToaanId.Value == hddToaAnGiaiQuyetId.Value || string.IsNullOrEmpty(hddToaAnGiaiQuyetId.Value))
                {
                    ddlOldCanbonhandon.Visible = false;
                    ddlOldThamphankynhandon.Visible = false;
                }
                else if (hddToaanId.Value != hddToaAnGiaiQuyetId.Value && !string.IsNullOrEmpty(hddToaAnGiaiQuyetId.Value))
                {
                    ddlCanbonhandon.Visible = false;
                    ddlThamphankynhandon.Visible = false;
                }
            }
        }
        #region Thiều

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
        protected void chkBoxCMNDBD_CheckedChanged(object sender, EventArgs e)
        {

            if (!chkBoxCMNDBD.Checked)
            {
                ltCMNDBD.Text = "<span style='color:red'>(*)</span>";
                ltCCCDBD.Text = "<span style='color:red'>(*)</span>";
            }
            else
            {
                ltCMNDBD.Text = "";
                ltCCCDBD.Text = "";
            }

        }
        #endregion
        private bool CheckValid()
        {
            if (txtNgayViet.Text == "")
            {
                lstMsgT.Text = lstMsgB.Text = "Bạn chưa nhập ngày ghi trên đơn.";
                txtNgayViet.Focus();
                return false;
            }
            if (Cls_Comon.IsValidDate(txtNgayViet.Text) == false)
            {
                lstMsgT.Text = lstMsgB.Text = "Bạn phải nhập ngày ghi trên đơn theo định dạng dd/MM/yyyy.";
                txtNgayViet.Focus();
                return false;
            }
            DateTime dNgayNhan = DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (txtNgayViet.Text != "")
            {
                DateTime dNgayViet = DateTime.Parse(this.txtNgayViet.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (dNgayViet > dNgayNhan)
                {
                    lstMsgT.Text = lstMsgB.Text = "Ngày ghi trên đơn không được lớn hơn ngày nhận đơn.";
                    txtNgayViet.Focus();
                    return false;
                }
            }
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
            if (txtNgayNhan.Text == "")
            {
                lstMsgT.Text = lstMsgB.Text = "Bạn chưa nhập ngày nhận đơn.";
                txtNgayNhan.Focus();
                return false;
            }
            if (Cls_Comon.IsValidDate(txtNgayNhan.Text) == false)
            {
                lstMsgT.Text = lstMsgB.Text = "Bạn phải nhập ngày nhận đơn theo định dạng dd/MM/yyyy.";
                txtNgayNhan.Focus();
                return false;
            }
            if (dNgayNhan > DateTime.Now)
            {
                lstMsgT.Text = lstMsgB.Text = "Ngày nhận đơn không được lớn hơn ngày hiện tại.";
                txtNgayNhan.Focus();
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
            if (ddlCanbonhandon.Items.Count == 0)
            {
                lstMsgT.Text = lstMsgB.Text = "Bạn chưa chọn người nhận đơn.";
                Cls_Comon.SetFocus(this, this.GetType(), ddlCanbonhandon.ClientID);
                return false;
            }
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


            #region Thiều
            if (!chkBoxCMNDND.Checked)
            {
                if (string.IsNullOrEmpty(txtND_CMND.Text) && string.IsNullOrEmpty(txtND_CCCD.Text) && string.IsNullOrEmpty(txtND_HoChieu.Text))
                {
                    lstMsgT.Text = lstMsgB.Text = "Bạn cần nhập 1 trong 3 nội dung Số CMND/ Thẻ căn cước/ Hộ chiếu. Nếu không có vui lòng tích chọn 'Không có'.";
                    txtND_CMND.Focus();
                    return false;
                }

                if (!string.IsNullOrEmpty(txtND_CMND.Text) && txtND_CMND.Text.Length != 9)
                {
                    lstMsgT.Text = lstMsgB.Text = "Số CMND chưa đúng định dạng!";
                    txtND_CMND.Focus();
                    return false;
                }
                string cccd = txtND_CCCD.Text.Trim();

                if (!string.IsNullOrEmpty(cccd) &&
                    (cccd.Length != 12 || !cccd.All(char.IsDigit)))
                {
                    lstMsgT.Text = lstMsgB.Text = "Số CCCD chưa đúng định dạng!";
                    txtND_CCCD.Focus();
                    return false;
                }


                if (ddlND_Quoctich.SelectedValue == "2")
                {
                    //La nguoi VN thi so ho chieu la 8 ky tu
                    if (!string.IsNullOrEmpty(txtND_HoChieu.Text) && txtND_HoChieu.Text.Length != 8)
                    {
                        lstMsgT.Text = lstMsgB.Text = "Số hộ chiếu chưa đúng định dạng!";
                        txtND_HoChieu.Focus();
                        return false;
                    }
                }

            }

            if (!chkBoxCMNDBD.Checked)
            {
                if (string.IsNullOrEmpty(txtBD_CMND.Text) && string.IsNullOrEmpty(txtBD_CCCD.Text) && string.IsNullOrEmpty(txtBD_HoChieu.Text))
                {
                    lstMsgT.Text = lstMsgB.Text = "Bạn cần nhập 1 trong 3 nội dung Số CMND/ Thẻ căn cước/ Hộ chiếu. Nếu không có vui lòng tích chọn 'Không có'.";
                    txtBD_CMND.Focus();
                    return false;
                }

                if (!string.IsNullOrEmpty(txtBD_CMND.Text) && txtBD_CMND.Text.Length != 9)
                {
                    lstMsgT.Text = lstMsgB.Text = "Số CMND chưa đúng định dạng!";
                    txtBD_CMND.Focus();
                    return false;
                }
                if (!string.IsNullOrEmpty(txtBD_CCCD.Text) && txtBD_CCCD.Text.Length != 12)
                {
                    lstMsgT.Text = lstMsgB.Text = "Số CCCD chưa đúng định dạng!";
                    txtBD_CCCD.Focus();
                    return false;
                }

                if (ddlBD_Quoctich.SelectedValue == "2")
                {
                    //La nguoi VN thi so ho chieu la 8 ky tu
                    if (!string.IsNullOrEmpty(txtBD_HoChieu.Text) && txtBD_HoChieu.Text.Length != 8)
                    {
                        lstMsgT.Text = lstMsgB.Text = "Số hộ chiếu chưa đúng định dạng!";
                        txtBD_HoChieu.Focus();
                        return false;
                    }
                }



            }
            #endregion

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
                    if (NgaySinh_ND > dNgayNhan)
                    {
                        lstMsgT.Text = lstMsgB.Text = "Ngày sinh nguyên đơn không được lớn hơn ngày nhận đơn. Hãy nhập lại.";
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
                    else if (namsinh > dNgayNhan.Year)
                    {
                        lstMsgT.Text = lstMsgB.Text = "Năm sinh của nguyên đơn không thể lớn hơn năm của ngày nhận đơn. Hãy kiểm tra lại!";
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
                    if (NgaySinh_BD > dNgayNhan)
                    {
                        lstMsgT.Text = lstMsgB.Text = "Ngày sinh bị đơn không được lớn hơn ngày nhận đơn. Hãy nhập lại.";
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
                    else if (namsinh > dNgayNhan.Year)
                    {
                        lstMsgT.Text = lstMsgB.Text = "Năm sinh của bị đơn không thể lớn hơn năm của ngày nhận đơn. Hãy kiểm tra lại!";
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
            #region check bỏ tích hoà giải
            if (hddID.Value != "" && hddID.Value != "0")
            {
                decimal ID = Convert.ToDecimal(hddID.Value);
                var oT = dt.ADS_DON.Where(x => x.ID == ID).FirstOrDefault();
                if (ckbTienHanhHG.Checked == false)
                {
                    if (oT.HOAGIAI_TRANGTHAI.GetValueOrDefault(0) > 0)
                    {
                        HOAGIAI_DON hgdon = DataExtensions.GetAllWithClause<HOAGIAI_DON>($"VUVIECID = {oT.ID} AND LOAIANID = 2").FirstOrDefault();
                        if (hgdon != null)
                        {
                            HOAGIAI_THONGBAO hgtb = DataExtensions.GetAllWithClause<HOAGIAI_THONGBAO>($"HOAGIAIID = {hgdon.ID}").FirstOrDefault();
                            if (hgtb != null)
                            {
                                lstMsgT.Text = lstMsgB.Text = "Vụ việc đang trong tiến trình hoà giải.";
                                Cls_Comon.SetFocus(this, this.GetType(), ckbTienHanhHG.ClientID);
                                return false;
                            }
                        }
                    }
                }
            }
            #endregion check bỏ tích hoà giải

            return true;
        }
        private void ResetControls()
        {
            txtQuanhephapluat.Text = null;
            ddlQuanhephapluat.SelectedIndex = 0;
            txtMaVuViec.Text = "";
            txtTenVuViec.Text = "";
            // txtSothutu.Text = "";
            txtNgayViet.Text = txtNgayNhan.Text = "";

            txtNoidungkhoikien.Text = "";

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

            EnableControl();

            hddID.Value = "0";
            LoadLoaiDon(false);
        }
        private void LoadCombobox()
        {
            //Load cán bộ
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            ddlCanbonhandon.Items.Clear();

            DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            ddlCanbonhandon.DataSource = oCBDT;
            ddlCanbonhandon.DataTextField = "MA_TEN";
            ddlCanbonhandon.DataValueField = "ID";
            ddlCanbonhandon.DataBind();

            //Load old cán bộ
            ddlOldCanbonhandon.Items.Clear();
            var toaGiaiQuyetId = hddToaAnGiaiQuyetId.Value;
            DataTable oOldCBDT = oDMCBBL.DM_CANBO_GETBYDONVI(Convert.ToDecimal(toaGiaiQuyetId));
            ddlOldCanbonhandon.DataSource = oOldCBDT;
            ddlOldCanbonhandon.DataTextField = "MA_TEN";
            ddlOldCanbonhandon.DataValueField = "ID";
            ddlOldCanbonhandon.DataBind();

            //Set mặc định cán bộ loginf
            try
            {
                string strCBID = Session[ENUM_SESSION.SESSION_CANBOID] + "";
                if (strCBID != "") ddlCanbonhandon.SelectedValue = strCBID;
            }
            catch { }

            // Load thảm phán ký nhận đơn
            ddlThamphankynhandon.Items.Clear();
            ddlThamphankynhandon.DataSource = oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
            ddlThamphankynhandon.DataTextField = "MA_TEN";
            ddlThamphankynhandon.DataValueField = "ID";
            ddlThamphankynhandon.DataBind();
            ddlThamphankynhandon.Items.Insert(0, new ListItem("--Chọn thẩm phán--", "0"));

            // Load old thảm phán ký nhận đơn
            ddlOldThamphankynhandon.Items.Clear();
            ddlOldThamphankynhandon.DataSource = oDMCBBL.DM_CANBO_GETBYDONVI(Convert.ToDecimal(toaGiaiQuyetId));
            ddlOldThamphankynhandon.DataTextField = "MA_TEN";
            ddlOldThamphankynhandon.DataValueField = "ID";
            ddlOldThamphankynhandon.DataBind();
            ddlOldThamphankynhandon.Items.Insert(0, new ListItem("--Chọn thẩm phán--", "0"));

            //Load Quan hệ pháp luật
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            ddlQuanhephapluat.Items.Clear();
            ddlQuanhephapluat.DataSource = oBL.DM_DATAITEM_GETBY2GROUPNAME(ENUM_DANHMUC.QUANHEPL_YEUCAU, ENUM_DANHMUC.QUANHEPL_TRANHCHAP);
            ddlQuanhephapluat.DataTextField = "TEN";
            ddlQuanhephapluat.DataValueField = "ID";
            ddlQuanhephapluat.DataBind();
            //Load QHPL Thống kê.
            ddlQHPLTK.Items.Clear();
            ddlQHPLTK.DataSource = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.DANSU && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
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
        }
        private bool SaveData()
        {
            try
            {
                if (!CheckValid()) return false;
                ADS_DON oT;
                #region "THÔNG TIN ĐƠN KHỞI KIỆN"
                if (hddID.Value == "" || hddID.Value == "0")
                {
                    oT = new ADS_DON();
                }
                else
                {
                    decimal ID = Convert.ToDecimal(hddID.Value);
                    oT = dt.ADS_DON.Where(x => x.ID == ID).FirstOrDefault();
                }

                KHOBAQD_BL oDonNc = new KHOBAQD_BL();
                //oT.TENVUVIEC = txtTennguyendon.Text + " - " + txtBD_Ten.Text + " - " + ddlQuanhephapluat.SelectedItem.Text;
                // oT.SOTHUTU = (txtSothutu.Text == "") ? 0 : Convert.ToDecimal(txtSothutu.Text);
                oT.HINHTHUCNHANDON = Convert.ToDecimal(ddlHinhthucnhandon.SelectedValue);
                DateTime dNgayViet;
                DateTime dNgayNhan;
                dNgayViet = (String.IsNullOrEmpty(txtNgayViet.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayViet.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                dNgayNhan = (String.IsNullOrEmpty(txtNgayNhan.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oT.NGAYVIETDON = dNgayViet;
                oT.NGAYNHANDON = dNgayNhan;
                oT.LOAIQUANHE = Convert.ToDecimal(ddlLoaiQuanhe.SelectedValue);
                oT.TENVUVIEC = txtTennguyendon.Text + " - " + txtBD_Ten.Text + " - " + txtQuanhephapluat.Text;
                if (txtQuanhephapluat.Text != null || txtQuanhephapluat.Text != "")
                    oT.QUANHEPHAPLUAT_NAME = txtQuanhephapluat.Text;
                if (txtQuanhephapluat.Text == "" || txtQuanhephapluat.Text == null)
                    oT.QUANHEPHAPLUAT_NAME = null; oT.QHPLTKID = Convert.ToDecimal(ddlQHPLTK.SelectedValue);
                oT.CANBONHANDONID = Convert.ToDecimal(ddlCanbonhandon.SelectedValue);
                oT.THAMPHANKYNHANDON = Convert.ToDecimal(ddlThamphankynhandon.SelectedValue);
                oT.YEUTONUOCNGOAI = Convert.ToDecimal(ddlYeutonuocngoai.SelectedValue);

                oT.LOAIDON = Convert.ToDecimal(ddlLoaidon.SelectedValue);
                oT.NOIDUNGKHOIKIEN = txtNoidungkhoikien.Text;
                if (hddID.Value == "" || hddID.Value == "0")
                {
                    ADS_DON_BL dsBL = new ADS_DON_BL();
                    oT.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    oT.TT = dsBL.GETNEWTT((decimal)oT.TOAANID);
                    oT.TRANGTHAI = ENUM_DS_TRANGTHAI.TAOMOI;
                    //oT.MAVUVIEC = ENUM_LOAIVUVIEC.AN_DANSU + Session[ENUM_SESSION.SESSION_MADONVI] + oT.TT.ToString();
                    oT.NGAYTAO = DateTime.Now;
                    oT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    oT.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;// anhvh edit 17/04/2020 không dùng ENUM_GIAIDOANVUAN.HOSO vì không phù hợp với nghiệp vụ tòa án
                    //update 14082025
                    oT.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    oT.TOA_PHUCTHAM_GIAIQUYET_ID = oT.TOAPHUCTHAMID;
                    dt.ADS_DON.Add(oT);
                    dt.SaveChanges();
                    hddID.Value = oT.ID.ToString();

                    //Sinh ma vu viec
                    oT.MAVUVIEC = ENUM_LOAIVUVIEC.AN_DANSU + "." + Session[ENUM_SESSION.SESSION_MADONVI] + "." + oT.ID.ToString();
                    dt.SaveChanges();


                    //anhvh add 26/06/2020
                    GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                    GD.GAIDOAN_INSERT_UPDATE("2", oT.ID, 2, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0, 0);
                }
                else
                {
                    oT.NGAYSUA = DateTime.Now;
                    oT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.SaveChanges();
                }
                #region Trang Thái Hòa Giải
                if (ckbTienHanhHG.Checked)
                {
                    if (oT.HOAGIAI_TRANGTHAI.GetValueOrDefault(0) == 0)
                    {
                        oT.HOAGIAI_TRANGTHAI = (Decimal)ENUM_TRANGTHAI_HOAGIAI.HOAGIAI;
                    }
                    HOAGIAI_DON donHG = DataExtensions.GetAllWithClause<HOAGIAI_DON>($"VUVIECID = {oT.ID} AND LOAIANID = {ENUM_LOAIVUVIEC_NUMBER.AN_DANSU.toNumber()}").FirstOrDefault();
                    if (donHG == null)
                    {
                        donHG = new HOAGIAI_DON()
                        {
                            LOAIANID = ENUM_LOAIVUVIEC_NUMBER.AN_DANSU.toNumber(),
                            MAVUVIEC = oT.MAVUVIEC,
                            TOAANID = oT.TOAANID,
                            TENVUVIEC = oT.TENVUVIEC,
                            VUVIECID = oT.ID,
                            NGAYSUA = DateTime.Now,
                            NGAYTAO = DateTime.Now,
                            NGUOISUA = oT.NGUOISUA,
                            NGUOITAO = oT.NGUOITAO
                        };
                        DataExtensions.Insert(donHG);
                    }
                    else
                    {
                        donHG.NGAYSUA = DateTime.Now;
                        donHG.NGUOISUA = oT.NGUOISUA;
                        DataExtensions.Update(donHG);
                    }
                    dt.SaveChanges();
                }
                else
                {
                    if (oT.HOAGIAI_TRANGTHAI.GetValueOrDefault(0) > 0)
                    {
                        HOAGIAI_DON hgdon = DataExtensions.GetAllWithClause<HOAGIAI_DON>($"VUVIECID = {oT.ID} AND LOAIANID = 2").FirstOrDefault();
                        if (hgdon != null)
                        {
                            HOAGIAI_THONGBAO hgtb = DataExtensions.GetAllWithClause<HOAGIAI_THONGBAO>($"HOAGIAIID = {hgdon.ID}").FirstOrDefault();
                            if (hgtb != null)
                            {
                                return false;
                            }
                            else
                            {
                                DataExtensions.Delete(hgdon);
                                oT.HOAGIAI_TRANGTHAI = null;
                                dt.SaveChanges();
                            }
                        }
                        else
                        {
                            oT.HOAGIAI_TRANGTHAI = null;
                            dt.SaveChanges();
                        }
                    }
                }
                #endregion Trang Thái Hòa Giải
                #endregion
                //Lưu nguyên đơn đại diện
                #region "NGUYÊN ĐƠN ĐẠI DIỆN"
                List<ADS_DON_DUONGSU> lstNguyendon = dt.ADS_DON_DUONGSU.Where(x => x.DONID == oT.ID && x.ISDAIDIEN == 1 && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON).ToList();
                ADS_DON_DUONGSU oND = new ADS_DON_DUONGSU();
                if (lstNguyendon.Count > 0) oND = lstNguyendon[0];
                oND.DONID = oT.ID;
                oND.TENDUONGSU = Convert.ToDecimal(ddlLoaiNguyendon.SelectedValue) == 1 ? Cls_Comon.FormatTenRieng(txtTennguyendon.Text) : Cls_Comon.FormatTenTochuc(txtTennguyendon.Text);
                oND.ISDAIDIEN = 1;
                oND.TUCACHTOTUNG_MA = ENUM_DANSU_TUCACHTOTUNG.NGUYENDON;
                oND.LOAIDUONGSU = Convert.ToDecimal(ddlLoaiNguyendon.SelectedValue);
                if (chkISBVQLNK.Visible)
                    oND.ISBVQLNGUOIKHAC = chkISBVQLNK.Checked ? 1 : 0;
                else
                    oND.ISBVQLNGUOIKHAC = 0;
                oND.SOCMND = txtND_CMND.Text;
                oND.SO_CCCD = txtND_CCCD.Text;
                oND.SO_HO_CHIEU = txtND_HoChieu.Text;
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

                // GTEL-HUNGNQ 10-10-2025 Cập nhật trạng thái C06 dùng entity
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
                    //update 14082025
                    oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.ADS_DON_DUONGSU.Add(oND);
                    dt.SaveChanges();
                }

                #endregion

                #region "BỊ ĐƠN ĐẠI DIỆN"
                List<ADS_DON_DUONGSU> lstBidon = dt.ADS_DON_DUONGSU.Where(x => x.DONID == oT.ID && x.ISDAIDIEN == 1 && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.BIDON).ToList();
                ADS_DON_DUONGSU oBD = new ADS_DON_DUONGSU();
                if (lstBidon.Count > 0) oBD = lstBidon[0];
                oBD.DONID = oT.ID;
                oBD.TENDUONGSU = Convert.ToDecimal(ddlLoaiBidon.SelectedValue) == 1 ? Cls_Comon.FormatTenRieng(txtBD_Ten.Text) : Cls_Comon.FormatTenTochuc(txtBD_Ten.Text);
                oBD.ISDAIDIEN = 1;
                oBD.TUCACHTOTUNG_MA = ENUM_DANSU_TUCACHTOTUNG.BIDON;
                oBD.LOAIDUONGSU = Convert.ToDecimal(ddlLoaiBidon.SelectedValue);
                oBD.SOCMND = txtBD_CMND.Text;
                oBD.SO_CCCD = txtBD_CCCD.Text;
                oBD.SO_HO_CHIEU = txtBD_HoChieu.Text;
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

                // GTEL-HUNGNQ 10-10-2025 Cập nhật trạng thái C06 dùng entity
                oBD.CHK_KHONG_CO = chkBoxCMNDBD.Checked ? "1" : "0";

                //Trạng thái Xac thuc Du lieu quoc gia của duong su
                if (chkKhongLamSachBD.Checked)
                {
                    oBD.XACTHUC_DLDCQG = 3; // ngươi dùng xác nhận không làm sạch được
                }
                else
                {
                    if (hdTrangThaiXacThucBD.Value != "1")
                        oBD.XACTHUC_DLDCQG = 0;
                    else
                        oBD.XACTHUC_DLDCQG = Convert.ToInt16(hdTrangThaiXacThucBD.Value);
                }
                //END

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
                    //update 14082025
                    oBD.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.ADS_DON_DUONGSU.Add(oBD);
                    dt.SaveChanges();
                }


                #endregion
                ADS_DON_DUONGSU_BL oDonBL = new ADS_DON_DUONGSU_BL();
                oDonBL.ADS_DON_YEUTONUOCNGOAI_UPDATE(oT.ID);
                return true;
            }
            catch (Exception ex)
            {
                lstMsgT.Text = lstMsgB.Text = "Lỗi: " + ex.Message;
                return false;
            }
        }
        //lbtimkiem_Click

        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            if (SaveData())
            {
                lstMsgT.Text = lstMsgB.Text = "Lưu thông tin đơn thành công !";
                Session["DS_THEMDSK"] = hddID.Value;
                DsDuongSu1.Visible = true;
                DsDuongSu1.DonID = Convert.ToDecimal(hddID.Value);
                DsDuongSu1.ReLoad();
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
                Session[ENUM_LOAIAN.AN_DANSU] = IDVuViec;
                Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
                //Cls_Comon.ShowMessageAndRedirect(this, this.GetType(), "MsgDSDON", "Lưu thông tin thành công, tiếp theo hãy chọn chức năng cần thao tác trong danh sách bên trái !", Cls_Comon.GetRootURL() + "/Trangchu.aspx");

            }
        }
        protected void cmdUpdateAndNew_Click(object sender, EventArgs e)
        {
            if (SaveData())
            {
                ResetControls();
                lstMsgT.Text = lstMsgB.Text = "Hoàn thành Lưu, bạn hãy nhập thông tin đơn tiếp theo !";
                DsDuongSu1.Visible = true;
                DsDuongSu1.DonID = 0;
                Cls_Comon.SetFocus(this, this.GetType(), ddlHinhthucnhandon.ClientID);
            }
        }
        protected void cmdQuaylai_Click(object sender, EventArgs e)
        {
            Response.Redirect("Danhsach.aspx");
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
            decimal IDQHPL = Convert.ToDecimal(ddlQuanhephapluat.SelectedValue);
            DM_DATAITEM obj = dt.DM_DATAITEM.Where(x => x.ID == IDQHPL).FirstOrDefault();
            DM_DATAGROUP oGroup = dt.DM_DATAGROUP.Where(x => x.ID == obj.GROUPID).FirstOrDefault();
            if (oGroup.MA == ENUM_DANHMUC.QUANHEPL_TRANHCHAP)
                ddlLoaiQuanhe.SelectedValue = "1";
            else
                ddlLoaiQuanhe.SelectedValue = "2";
            Cls_Comon.SetFocus(this, this.GetType(), ddlQHPLTK.ClientID);

        }
        protected void ddlLoaiNguyendon_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlLoaiNguyendon.SelectedValue == "1")
            {
                pnNDCanhan.Visible = true;
                pnNDTochuc.Visible = false;
                chkISBVQLNK.Visible = false;

                Cls_Comon.SetFocus(this, this.GetType(), txtTennguyendon.ClientID);
            }
            else
            {
                pnNDCanhan.Visible = false;
                pnNDTochuc.Visible = true;
                chkISBVQLNK.Visible = true;

                Cls_Comon.SetFocus(this, this.GetType(), chkISBVQLNK.ClientID);
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
        private void SetValueComboBox(DropDownList ddl, object value)
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

        protected void ddlCanbonhandon_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {

            }
            catch (Exception ex) { lstMsgT.Text = lstMsgB.Text = ex.Message; }
        }

        protected void ddlThamphankynhandon_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {

            }
            catch (Exception ex) { lstMsgT.Text = lstMsgB.Text = ex.Message; }
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

                // GTEL-HUNGNQ 10-10-2025 fill giá trị từ Get037 về dropdownlist
                if (!string.IsNullOrEmpty(hidTamTru_Huyen_NguyenDon.Value))
                {
                    var item = ddlTamTru_Huyen_NguyenDon.Items.FindByValue(hidTamTru_Huyen_NguyenDon.Value);
                    if (item != null)
                    {
                        ddlTamTru_Huyen_NguyenDon.SelectedValue = hidTamTru_Huyen_NguyenDon.Value;
                    }
                }
                //END
                Cls_Comon.SetFocus(this, this.GetType(), ddlTamTru_Huyen_NguyenDon.ClientID);

            }
            catch (Exception ex) { lstMsgT.Text = lstMsgB.Text = ex.Message; }
        }
        protected void ddlTamTru_Tinh_BiDon_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                string valueFromPopup = Request["__EVENTARGUMENT"];
                if (!string.IsNullOrEmpty(valueFromPopup))
                {
                    ddlTamTru_Tinh_BiDon.SelectedValue = valueFromPopup;
                }
                LoadDropTamTru_Huyen_BiDon();

                // GTEL-HUNGNQ 10-10-2025 fill giá trị từ Get037 về dropdownlist
                if (!string.IsNullOrEmpty(hidTamTru_Huyen_BiDon.Value))
                {
                    var item = ddlTamTru_Tinh_BiDon.Items.FindByValue(hidTamTru_Huyen_BiDon.Value);
                    if (item != null)
                    {
                        ddlTamTru_Tinh_BiDon.SelectedValue = hidTamTru_Huyen_BiDon.Value;
                    }
                }
                //END

                Cls_Comon.SetFocus(this, this.GetType(), ddlTamTru_Huyen_BiDon.ClientID);

            }
            catch (Exception ex) { lstMsgT.Text = lstMsgB.Text = ex.Message; }
        }
        protected void txtNgayNhan_TextChanged(object sender, EventArgs e)
        {
            if (txtNgayNhan.Text != "" && Cls_Comon.IsValidDate(txtNgayNhan.Text))
            {
                DateTime NgayNhan = DateTime.Parse(txtNgayNhan.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                if (txtND_Namsinh.Text != "" && txtND_Namsinh.Text.Length == 4)
                {
                    string NgaySinhstr = "";
                    if (txtND_Ngaysinh.Text != "" && Cls_Comon.IsValidDate(txtND_Ngaysinh.Text))
                    {
                        string[] arr = txtND_Ngaysinh.Text.Split('/');
                        NgaySinhstr = arr[0] + "/" + arr[1] + "/" + txtND_Namsinh.Text;
                        txtND_Ngaysinh.Text = NgaySinhstr;
                    }
                    if (txtND_Ngaysinh.Text == "")
                    {
                        NgaySinhstr = "01/01/" + txtND_Namsinh.Text;
                    }
                    //DateTime NgaySinh = DateTime.Parse(NgaySinhstr, cul, DateTimeStyles.NoCurrentDateDefault);
                    //txtND_Tuoi.Text = TinhTuoi(NgaySinh, NgayNhan).ToString();
                }
                if (txtND_Namsinh.Text == "")
                {
                    if (Cls_Comon.IsValidDate(txtND_Ngaysinh.Text))
                    {
                        DateTime NgaySinh = DateTime.Parse(txtND_Ngaysinh.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                        // txtND_Tuoi.Text = TinhTuoi(NgaySinh, NgayNhan).ToString();
                        txtND_Namsinh.Text = NgaySinh.Year.ToString();
                    }
                }
                //Bị đơn
                if (txtBD_Namsinh.Text != "" && txtBD_Namsinh.Text.Length == 4)
                {
                    string NgaySinhstr = "";
                    if (txtBD_Ngaysinh.Text != "" && Cls_Comon.IsValidDate(txtBD_Ngaysinh.Text))
                    {
                        string[] arr = txtBD_Ngaysinh.Text.Split('/');
                        NgaySinhstr = arr[0] + "/" + arr[1] + "/" + txtBD_Namsinh.Text;
                        txtBD_Ngaysinh.Text = NgaySinhstr;
                    }
                    if (txtBD_Ngaysinh.Text == "")
                    {
                        NgaySinhstr = "01/01/" + txtBD_Namsinh.Text;
                    }
                    // DateTime NgaySinh = DateTime.Parse(NgaySinhstr, cul, DateTimeStyles.NoCurrentDateDefault);
                    //txtBD_Tuoi.Text = TinhTuoi(NgaySinh, NgayNhan).ToString();
                }
            }
        }
        protected void txtND_Ngaysinh_TextChanged(object sender, EventArgs e)
        {
            if (txtND_Ngaysinh.Text != "")
            {
                if (Cls_Comon.IsValidDate(txtND_Ngaysinh.Text))
                {
                    DateTime NgaySinh_ND = DateTime.Parse(txtND_Ngaysinh.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                    txtND_Namsinh.Text = NgaySinh_ND.Year.ToString();
                    //if (Cls_Comon.IsValidDate(txtNgayNhan.Text))
                    //{
                    //    DateTime NgayNhan = DateTime.Parse(txtNgayNhan.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                    //    txtND_Tuoi.Text = TinhTuoi(NgaySinh_ND, NgayNhan).ToString();
                    //}
                }
            }
            else
            {
                //if (txtND_Namsinh.Text != "" && txtND_Namsinh.Text.Length == 4)
                //{
                //    if (Cls_Comon.IsValidDate(txtNgayNhan.Text))
                //    {
                //        string NgaySinhstr = "01/01/" + txtND_Namsinh.Text;
                //        DateTime NgayNhan = DateTime.Parse(txtNgayNhan.Text, cul, DateTimeStyles.NoCurrentDateDefault),
                //                 NgaySinh_ND = DateTime.Parse(NgaySinhstr, cul, DateTimeStyles.NoCurrentDateDefault);
                //        txtND_Tuoi.Text = TinhTuoi(NgaySinh_ND, NgayNhan).ToString();
                //    }
                //}
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
                //if (NgaySinhstr != "" && Cls_Comon.IsValidDate(txtNgayNhan.Text))
                //{
                //    DateTime NgayNhan = DateTime.Parse(txtNgayNhan.Text, cul, DateTimeStyles.NoCurrentDateDefault),
                //             NgaySinh_ND = DateTime.Parse(NgaySinhstr, cul, DateTimeStyles.NoCurrentDateDefault);
                //    txtND_Tuoi.Text = TinhTuoi(NgaySinh_ND, NgayNhan).ToString();
                //}
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
                    //if (Cls_Comon.IsValidDate(txtNgayNhan.Text))
                    //{
                    //    DateTime NgayNhan = DateTime.Parse(txtNgayNhan.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                    //    txtBD_Tuoi.Text = TinhTuoi(NgaySinh_BD, NgayNhan).ToString();
                    //}
                }
            }
            //else
            //{
            //    if (txtBD_Namsinh.Text != "" && txtBD_Namsinh.Text.Length == 4)
            //    {
            //        if (Cls_Comon.IsValidDate(txtNgayNhan.Text))
            //        {
            //            string NgaySinhstr = "01/01/" + txtND_Namsinh.Text;
            //            DateTime NgayNhan = DateTime.Parse(txtNgayNhan.Text, cul, DateTimeStyles.NoCurrentDateDefault),
            //                     NgaySinh_BD = DateTime.Parse(NgaySinhstr, cul, DateTimeStyles.NoCurrentDateDefault);
            //            txtBD_Tuoi.Text = TinhTuoi(NgaySinh_BD, NgayNhan).ToString();
            //        }
            //    }
            //}
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
                //if (NgaySinhstr != "" && Cls_Comon.IsValidDate(txtNgayNhan.Text))
                //{
                //    DateTime NgayNhan = DateTime.Parse(txtNgayNhan.Text, cul, DateTimeStyles.NoCurrentDateDefault),
                //             NgaySinh_BD = DateTime.Parse(NgaySinhstr, cul, DateTimeStyles.NoCurrentDateDefault);
                //    txtBD_Tuoi.Text = TinhTuoi(NgaySinh_BD, NgayNhan).ToString();
                //}
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
        private void txtQuanhephapluat_name(ADS_DON oT)
        {
            if (oT.QUANHEPHAPLUAT_NAME != null)
            {
                txtQuanhephapluat.Text = oT.QUANHEPHAPLUAT_NAME;
            }
            else if (oT.QUANHEPHAPLUATID != null && oT.QUANHEPHAPLUATID != 0)
            {
                decimal IDQHPL = Convert.ToDecimal(oT.QUANHEPHAPLUATID.ToString());
                DM_DATAITEM obj = dt.DM_DATAITEM.Where(x => x.ID == IDQHPL).FirstOrDefault();
                if (obj != null)
                    txtQuanhephapluat.Text = obj.TEN.ToString();
            }
            else
                txtQuanhephapluat.Text = null;
        }

        protected void ddlQHPLTK_SelectedIndexChanged(object sender, EventArgs e)
        {
            qlhl_check_load();
        }
        protected void qlhl_check_load()
        {
            if (ddlQHPLTK.SelectedValue != "0")
            {
                Decimal qhplid = Convert.ToDecimal(ddlQHPLTK.SelectedValue);
                DM_QHPL_TK qhpltk = dt.DM_QHPL_TK.Where(x => x.ID == qhplid).FirstOrDefault();
                if (qhpltk.OPTIONS == 0)//tranh chấp
                {
                    lbl_ttnguyendon.Text = "Thông tin nguyên đơn (đại diện)";
                    lbl_ttbidon.Text = "Thông tin bị đơn (đại diện)";

                    lbl_nguyendonla.Text = "Nguyên đơn là";
                    lbl_tennguyendon.Text = "Tên nguyên đơn";
                    lbl_bidonla.Text = "Bị đơn là";
                    lbl_tenbidon.Text = "Tên bị đơn";
                    chkBoxCMNDBD.Checked = false;
                }
                else if (qhpltk.OPTIONS == 1)//yêu cầu
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
        }

        /* GTEL-HUNGNQ 01-10-2025 thêm check dữ liệu C06  theo cccd cho ND*/
        #region C06
        protected void btnGet037ND_Click(object sender, EventArgs e)
        {
            string quocTich = ddlBD_Quoctich.SelectedValue;
            if (quocTich == "2")
            {
                string soDinhDanh = txtND_CCCD.Text.Trim();
                if (string.IsNullOrEmpty(soDinhDanh))
                {
                    string strMsg = "Vui lòng nhập Thẻ căn cước của Nguyên đơn!";
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                    return;
                }

                string HoTen = txtTennguyendon.Text.Trim();
                if (string.IsNullOrEmpty(HoTen))
                {
                    string strMsg = "Vui lòng nhập Họ và Tên của Nguyên đơn!";
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                    return;
                }

                string NamSinh = txtND_Namsinh.Text.Trim();
                if (string.IsNullOrEmpty(NamSinh))
                {
                    string strMsg = "Vui lòng nhập Năm sinh của Nguyên đơn!";
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
                    txtTennguyendon.Text = CongDan.HoVaTen.Ten;
                    //Nếu tồn tại dữ liệu thì khóa truong thong tin khong cho sua
                    chkKhongLamSachND.Checked = chkBoxCMNDND.Checked = false;
                    ddlND_Quoctich.Enabled = false;
                    hdTrangThaiXacThucND.Value = "1";
                    Session.Remove("CongDan");
                    Session["CongDan"] = CongDan;
                    string StrMsg = "PopupCenter('/QLAN/ADS/Hoso/Popup/pGetDuongSu037.aspx?caller=DuongSuND','Thông tin công dân từ hệ thống Cơ sở dữ liệu quốc gia về dân cư',850,700);";
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
        protected void btnGet037BD_Click(object sender, EventArgs e)
        {
            string quocTich = ddlBD_Quoctich.SelectedValue;
            if (quocTich == "2")
            {
                string soDinhDanh = txtBD_CCCD.Text.Trim();

                if (string.IsNullOrEmpty(soDinhDanh))
                {
                    string strMsg = "Vui lòng nhập Thẻ căn cước của Bị đơn!";
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                    return;
                }

                string HoTen = txtBD_Ten.Text.Trim();
                if (string.IsNullOrEmpty(HoTen))
                {
                    string strMsg = "Vui lòng nhập Họ và Tên của Bị đơn!";
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                    return;
                }

                string NamSinh = txtBD_Namsinh.Text.Trim();
                if (string.IsNullOrEmpty(NamSinh))
                {
                    string strMsg = "Vui lòng nhập Năm sinh của Bị đơn!";
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
                    txtBD_Ten.Text = CongDan.HoVaTen.Ten;
                    //Nếu tồn tại dữ liệu thì khóa truong thong tin khong cho sua
                    chkKhongLamSachBD.Checked = chkBoxCMNDBD.Checked = false;
                    hdTrangThaiXacThucBD.Value = "1";
                    Session.Remove("CongDan");
                    Session["CongDan"] = CongDan;
                    string StrMsg = "PopupCenter('/QLAN/ADS/Hoso/Popup/pGetDuongSu037.aspx?caller=DuongSuBD','Thông tin công dân từ hệ thống Cơ sở dữ liệu quốc gia về dân cư',850,700);";
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
        private void EnableControl()
        {
            chkKhongLamSachND.Enabled = chkBoxCMNDND.Enabled = txtTennguyendon.Enabled = txtND_CCCD.Enabled = txtND_Namsinh.Enabled = hdTrangThaiXacThucND.Value != "1";
            chkKhongLamSachBD.Enabled = chkBoxCMNDBD.Enabled = txtBD_Ten.Enabled = txtBD_CCCD.Enabled = txtBD_Namsinh.Enabled = ddlBD_Quoctich.Enabled = hdTrangThaiXacThucBD.Value != "1";
        }
        #endregion
    }
}