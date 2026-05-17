using BL.GSTP;
using BL.GSTP.APS;
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

namespace WEB.GSTP.QLAN.APS.Hoso
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
            Session[keyDonID] = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_PHASAN]);
            Session[keyLoaiAnId] = Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_PHASAN);
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                SetDonGhep();
                LoadCombobox();
                string current_id = Request["ID"] + "";
                string strtype = Request["type"] + "";
                DsPSDuongSu1.Visible = false;
                DsPSDuongSu1.DonID = 0;
                LoadLoaiDon(false);
                string strDonID = Session["PS_THEMDSK"] + "";
                if (strtype == "new")
                {
                    ltCMNDND.Text = "<span style='color:red'>(*)</span>";
                    ltCCCDND.Text = "<span style='color:red'>(*)</span>";
                    ltCMNDBD.Text = "<span style='color:red'>(*)</span>";
                    ltCCCDBD.Text = "<span style='color:red'>(*)</span>";
                    DONGHEP.Visible = false;
                    if (strDonID != "")
                    {
                        hddID.Value = Session["PS_THEMDSK"] + "";
                        decimal ID = Convert.ToDecimal(Session["PS_THEMDSK"]);
                        LoadInfo(ID);
                        DsPSDuongSu1.Visible = true;
                        DsPSDuongSu1.DonID = ID;
                        DsPSDuongSu1.ReLoad();
                    }
                }
                else if (strtype == "list")
                {
                    if (current_id != "" && current_id != "0")
                    {
                        hddID.Value = current_id.ToString();
                        decimal ID = Convert.ToDecimal(current_id);
                        LoadInfo(ID);
                        DsPSDuongSu1.Visible = true;
                        DsPSDuongSu1.DonID = ID;
                        DsPSDuongSu1.ReLoad();
                    }
                }
                else
                {
                    current_id = Session[ENUM_LOAIAN.AN_PHASAN] + "";
                    if (current_id != "" && current_id != "0")
                    {
                        hddID.Value = current_id.ToString();
                        decimal ID = Convert.ToDecimal(current_id);
                        LoadInfo(ID);
                        DsPSDuongSu1.Visible = true;
                        DsPSDuongSu1.DonID = ID;
                        DsPSDuongSu1.ReLoad();
                    }
                }
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                Cls_Comon.SetButton(cmdUpdateSelect, oPer.CAPNHAT);
                Cls_Comon.SetButton(cmdUpdateAndNew, oPer.CAPNHAT);
                Cls_Comon.SetButton(cmdUpdateSelectB, oPer.CAPNHAT);
                Cls_Comon.SetButton(cmdUpdateAndNewB, oPer.CAPNHAT);
                Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                Cls_Comon.SetButton(cmdUpdateB, oPer.CAPNHAT);
                if (hddID.Value != "" && hddID.Value != "0")
                {
                    decimal ID = Convert.ToDecimal(hddID.Value);
                    APS_DON oT = dt.APS_DON.Where(x => x.ID == ID).FirstOrDefault();
                    if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                    {
                        lstMsgT.Text = lstMsgB.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                        Cls_Comon.SetButton(cmdUpdateSelect, false);
                        Cls_Comon.SetButton(cmdUpdateAndNew, false);
                        Cls_Comon.SetButton(cmdUpdateSelectB, false);
                        Cls_Comon.SetButton(cmdUpdateAndNewB, false);
                        Cls_Comon.SetButton(cmdUpdate, false);
                        Cls_Comon.SetButton(cmdUpdateB, false);
                        return;
                    }
                    string StrMsg = "Không được sửa đổi thông tin.";
                    string Result = new APS_CHUYEN_NHAN_AN_BL().Check_NhanAn(ID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    if (Result != "")
                    {
                        lstMsgT.Text = lstMsgB.Text = Result;
                        Cls_Comon.SetButton(cmdUpdateSelect, false);
                        Cls_Comon.SetButton(cmdUpdateAndNew, false);
                        Cls_Comon.SetButton(cmdUpdateSelectB, false);
                        Cls_Comon.SetButton(cmdUpdateAndNewB, false);
                        Cls_Comon.SetButton(cmdUpdate, false);
                        Cls_Comon.SetButton(cmdUpdateB, false);
                        return;
                    }
                }
                else
                    SetTinhHuyenMacDinh();
                ddlHinhthucnhandon.Focus();


                if (strtype != "new")
                {
                    //current_id = Session[ENUM_LOAIAN.AN_PHASAN] + "";
                    if (!string.IsNullOrEmpty(current_id))
                    {
                        decimal Id = Convert.ToDecimal(current_id);
                        List<APS_DON_XULY> oDON_XLY = dt.APS_DON_XULY.Where(x => x.DONID == Id).ToList<APS_DON_XULY>();
                        if (oDON_XLY.Count > 0)
                        {
                            lstMsgT.Text = lstMsgB.Text = "Đơn đã được xử lý không được thay đổi !";
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
                    DsPSDuongSu1.hiddenbtnThemMoi();
                    DONGHEP.hiddenbtnThemMoi();
                }
                
            }
            DsPSDuongSu1.DonID = Convert.ToDecimal(hddID.Value);
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
            APS_DON oT = dt.APS_DON.Where(x => x.ID == ID).FirstOrDefault();
            txtMaVuViec.Text = oT.MAVUVIEC;
            txtTenVuViec.Text = oT.TENVUVIEC;
            // if (oT.SOTHUTU != null) txtSothutu.Text = oT.SOTHUTU.ToString();
            ddlHinhthucnhandon.SelectedValue = oT.HINHTHUCNHANDON.ToString();
            if (oT.HINHTHUCNHANDON == 3)
                LoadLoaiDon(true);
            else
                LoadLoaiDon(false);
            if (oT.NGAYVIETDON != DateTime.MinValue) txtNgayViet.Text = ((String.IsNullOrEmpty(oT.NGAYVIETDON + "")) || (((DateTime)oT.NGAYVIETDON) == DateTime.MinValue)) ? "" : ((DateTime)oT.NGAYVIETDON).ToString("dd/MM/yyyy", cul); //((DateTime)oT.NGAYVIETDON).ToString("dd/MM/yyyy", cul);
            if (oT.NGAYNHANDON != DateTime.MinValue) txtNgayNhan.Text = ((String.IsNullOrEmpty(oT.NGAYNHANDON + "")) || (((DateTime)oT.NGAYNHANDON) == DateTime.MinValue)) ? "" : ((DateTime)oT.NGAYNHANDON).ToString("dd/MM/yyyy", cul); //((DateTime)oT.NGAYNHANDON).ToString("dd/MM/yyyy", cul);
            ddlLoaiQuanhe.SelectedValue = oT.LOAIQUANHE.ToString();
            ddlQuanhephapluat.SelectedValue = oT.QUANHEPHAPLUATID.ToString();
            if (ddlCanbonhandon.Items.FindByValue(oT.CANBONHANDONID + "") != null)
                ddlCanbonhandon.SelectedValue = oT.CANBONHANDONID + "";
            if (ddlThamphankynhandon.Items.FindByValue(oT.THAMPHANKYNHANDON + "") != null)
                ddlThamphankynhandon.SelectedValue = oT.THAMPHANKYNHANDON + "";
            ddlYeutonuocngoai.SelectedValue = oT.YEUTONUOCNGOAI.ToString();
            txtDonkiencuanguoikhac.Text = oT.DONKIENCUANGUOIKHAC;
            ddlLoaidon.SelectedValue = oT.LOAIDON.ToString();
            txtNoidungkhoikien.Text = oT.NOIDUNGKHOIKIEN;
            //Load Nguyên đơn
            #region "NGUYÊN ĐƠN ĐẠI DIỆN"
            List<APS_DON_DUONGSU> lstNguyendon = dt.APS_DON_DUONGSU.Where(x => x.DONID == oT.ID && x.ISDAIDIEN == 1 && x.TUCACHTOTUNG_MA == ENUM_PHASAN_TUCACHTOTUNG.NGUOIYEUCAUPS).ToList();
            APS_DON_DUONGSU oND = new APS_DON_DUONGSU();
            DM_HANHCHINH_BL oHCBL = new DM_HANHCHINH_BL();
            if (lstNguyendon.Count > 0)
            {
                oND = lstNguyendon[0];
                txtTennguyendon.Text = oND.TENDUONGSU;
                ddlLoaiNguyendon.SelectedValue = oND.LOAIDUONGSU.ToString();
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
                txtND_NoiLamViec.Text = oND.DIACHICOQUAN + "";
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
                //if (oND.HKTTTINHID != null)
                //{
                //    ddlThuongTru_Tinh_NguyenDon.SelectedValue = oND.HKTTTINHID.ToString();
                //    LoadDropThuongTru_Huyen_NguyenDon();
                //    if (oND.HKTTID != null)
                //    {
                //        ddlThuongTru_Huyen_NguyenDon.SelectedValue = oND.HKTTID.ToString();
                //    }
                //}
                //txtND_HKTT_Chitiet.Text = oND.HKTTCHITIET;
                if (oND.NGAYSINH != DateTime.MinValue) txtND_Ngaysinh.Text = ((DateTime)oND.NGAYSINH).ToString("dd/MM/yyyy", cul);

                txtND_Namsinh.Text = oND.NAMSINH == 0 ? "" : oND.NAMSINH.ToString();
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
                    //   lblND_Batbuoc1.Text = 
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
                    //lblND_Batbuoc1.Text = 
                    lblND_Batbuoc2.Text = "";
                }
                else
                {
                    //lblND_Batbuoc1.Text =
                    lblND_Batbuoc2.Text = "(*)";
                }

                decimal IDLOAIND = Convert.ToDecimal(ddlLoaiNguyendon.SelectedValue);
                DM_DATAITEM oItem = dt.DM_DATAITEM.Where(x => x.ID == IDLOAIND).FirstOrDefault();
                if (oItem.MA == ENUM_DOITUONG_NOPYCPS.NGUOILAODONG)
                {
                    pnNDCanhan.Visible = true;
                    pnNDTochuc.Visible = false;
                }
                else
                {
                    pnNDCanhan.Visible = false;
                    pnNDTochuc.Visible = true;
                }

            }
            #endregion
            //Load Bị đơn
            #region "BỊ ĐƠN ĐẠI DIỆN"
            List<APS_DON_DUONGSU> lstBidon = dt.APS_DON_DUONGSU.Where(x => x.DONID == oT.ID && x.ISDAIDIEN == 1 && x.TUCACHTOTUNG_MA == ENUM_PHASAN_TUCACHTOTUNG.DNHTXBITUYENBOPS).ToList();
            APS_DON_DUONGSU oBD = new APS_DON_DUONGSU();
            if (lstBidon.Count > 0)
            {
                oBD = lstBidon[0];
                txtBD_Ten.Text = oBD.TENDUONGSU;

                ddlLoaiBidon.SelectedValue = oBD.LOAIDUONGSU.ToString();
                //if (string.IsNullOrEmpty(oBD.SOCMND))
                //{
                //    chkBoxCMNDBD.Checked = true;
                //    ltCMNDBD.Text = "";
                //}
                //else
                //{
                //    ltCMNDBD.Text = "<span style='color:red'>(*)</span>";
                //    chkBoxCMNDBD.Checked = false;
                //}
                txtBD_CMND.Text = oBD.SOCMND;
                txtBD_CCCD.Text = oBD.SO_CCCD;
                txtBD_HoChieu.Text = oBD.SO_HO_CHIEU;
                ddlBD_Quoctich.SelectedValue = oBD.QUOCTICHID.ToString();
                txtBD_NoiLamViec.Text = oBD.DIACHICOQUAN + "";
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
                //if (oBD.HKTTTINHID != null)
                //{
                //    ddlThuongTru_Tinh_BiDon.SelectedValue = oBD.HKTTTINHID.ToString();
                //    LoadDropThuongTru_Huyen_BiDon();
                //    if (oBD.HKTTID != null)
                //    {
                //        ddlThuongTru_Huyen_BiDon.SelectedValue = oBD.HKTTID.ToString();
                //    }
                //}
                //txtBD_HKTT_Chitiet.Text = oBD.HKTTCHITIET;
                if (oBD.NGAYSINH != DateTime.MinValue) txtBD_Ngaysinh.Text = ((DateTime)oBD.NGAYSINH).ToString("dd/MM/yyyy", cul);

                txtBD_Namsinh.Text = oBD.NAMSINH == 0 ? "" : oBD.NAMSINH.ToString();
                ddlBD_Gioitinh.SelectedValue = oBD.GIOITINH.ToString();
                txtBD_NDD_ten.Text = oBD.NGUOIDAIDIEN;
                txtBD_NDD_Chucvu.Text = oBD.CHUCVU;
                txtBD_Email.Text = oBD.EMAIL + "";
                txtBD_Dienthoai.Text = oBD.DIENTHOAI + "";
                txtBD_Fax.Text = oBD.FAX + "";
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
                if (oBD.SINHSONG_NUOCNGOAI != null) chkBD_ONuocNgoai.Checked = oBD.SINHSONG_NUOCNGOAI == 1 ? true : false;
                txtBD_NDD_Diachichitiet.Text = oBD.NDD_DIACHICHITIET;
                if (ddlBD_Quoctich.SelectedIndex > 0)
                {
                    // lblBD_Batbuoc1.Text =
                    //lblBD_Batbuoc2.Text = "";
                    chkBD_ONuocNgoai.Visible = false;
                }
                else
                {
                    // lblBD_Batbuoc1.Text =
                    //lblBD_Batbuoc2.Text = "(*)";
                    chkBD_ONuocNgoai.Visible = true;
                }
                if (chkBD_ONuocNgoai.Checked)
                {
                    //  lblBD_Batbuoc1.Text =
                    //lblBD_Batbuoc2.Text = "";
                }
                else
                {
                    // lblBD_Batbuoc1.Text =
                    //lblBD_Batbuoc2.Text = "(*)";
                }
                decimal IDLOAIBD = Convert.ToDecimal(ddlLoaiBidon.SelectedValue);
                DM_QHPL_TK oItem = dt.DM_QHPL_TK.Where(x => x.ID == IDLOAIBD).FirstOrDefault();
                if ((oItem.ARRSAPXEP + "/").Contains("0/401/"))
                {
                    lstNganhKT.Visible = true;
                    ddlNganhKT.Visible = true;
                    if (oBD.NGANHKINHTEID != null) ddlNganhKT.SelectedValue = oBD.NGANHKINHTEID.ToString();
                }
                else
                {
                    lstNganhKT.Visible = false;
                    ddlNganhKT.Visible = false;
                }
            }
            else
            {

                DsPSDuongSu1.Visible = false;

            }
            #endregion
        }
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
            DateTime dNgayNhan = (String.IsNullOrEmpty(txtNgayNhan.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            //if (txtNgayViet.Text != "")
            //{
            //    DateTime dNgayViet = DateTime.Parse(this.txtNgayViet.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            //    if (dNgayViet > dNgayNhan)
            //    {
            //        lstMsgT.Text = lstMsgB.Text = "Ngày ghi trên đơn không được lớn hơn ngày nhận đơn.";
            //        txtNgayViet.Focus();
            //        return false;
            //    }
            //}
            if (txtNgayNhan.Text == "")
            {
                lstMsgT.Text = lstMsgB.Text = "Chưa nhập ngày nhận đơn";
                txtNgayNhan.Focus();
                return false;
            }
            if (dNgayNhan > DateTime.Now)
            {
                lstMsgT.Text = lstMsgB.Text = "Ngày nhận đơn không được lớn hơn ngày hiện tại !";
                txtNgayNhan.Focus();
                return false;
            }
            if (ddlCanbonhandon.Items.Count == 0)
            {
                lstMsgT.Text = lstMsgB.Text = "Chưa chọn người nhận đơn";
                return false;
            }
            if (txtTennguyendon.Text == "")
            {
                lstMsgT.Text = lstMsgB.Text = "Chưa nhập tên nguyên đơn";
                txtTennguyendon.Focus();
                return false;
            }
            if (ddlLoaiNguyendon.SelectedValue == "1")
            {
                if (txtND_Namsinh.Text == "")
                {
                    lstMsgT.Text = lstMsgB.Text = "Chưa nhập năm sinh nguyên đơn";
                    txtND_Namsinh.Focus();
                    return false;
                }
                if (lblND_Batbuoc2.Text != "")
                {
                    //if (ddlThuongTru_Huyen_NguyenDon.SelectedValue == "0")
                    //{
                    //    lstMsgT.Text = lstMsgB.Text = "Chưa chọn nơi thường trú của nguyên đơn!";
                    //    return false;
                    //}
                    if (ddlTamTru_Huyen_NguyenDon.SelectedValue == "0")
                    {
                        lstMsgT.Text = lstMsgB.Text = "Chưa chọn nơi sinh sống của nguyên đơn!";
                        return false;
                    }
                }
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
                if (!string.IsNullOrEmpty(txtND_CCCD.Text) && txtND_CCCD.Text.Length != 12)
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
                    if (!string.IsNullOrEmpty(txtBD_HoChieu.Text) && txtBD_HoChieu.Text.Length < 8)
                    {
                        lstMsgT.Text = lstMsgB.Text = "Số hộ chiếu chưa đúng định dạng!";
                        txtBD_HoChieu.Focus();
                        return false;
                    }
                }

            }
            #endregion

            if (ddlLoaiBidon.SelectedValue == "1")
            {
                //if (lblBD_Batbuoc2.Text != "")
                //{
                //    //if (ddlThuongTru_Huyen_BiDon.SelectedValue == "0")
                //    //{
                //    //    lstMsgT.Text = lstMsgB.Text = "Chưa chọn nơi thường trú của bị đơn!";
                //    //    return false;
                //    //}
                //    if (ddlTamTru_Huyen_BiDon.SelectedValue == "0")
                //    {
                //        lstMsgT.Text = lstMsgB.Text = "Chưa chọn nơi sinh sống của bị đơn";
                //        return false;
                //    }
                //}
            }
            if (txtBD_Ten.Text == "")
            {
                lstMsgT.Text = lstMsgB.Text = "Chưa nhập tên bị đơn";
                txtBD_Ten.Focus();
                return false;
            }

            return true;
        }
        private void ResetControls()
        {
            txtMaVuViec.Text = "";
            txtTenVuViec.Text = "";
            // txtSothutu.Text = "";
            txtNgayViet.Text = txtNgayNhan.Text = "";
            txtDonkiencuanguoikhac.Text = "";
            txtNoidungkhoikien.Text = "";

            txtTennguyendon.Text = "";
            txtND_CMND.Text = "";
            txtND_CCCD.Text = "";
            txtND_HoChieu.Text = "";
            txtND_Ngaysinh.Text = "";
            txtND_Namsinh.Text = "";
            //txtND_HKTT_Chitiet.Text = "";
            txtND_TTChitiet.Text = "";
            txtND_NDD_Diachichitiet.Text = "";
            chkND_ONuocNgoai.Checked = chkBD_ONuocNgoai.Checked = false;
            txtBD_Ten.Text = "";
            txtBD_CMND.Text = "";
            txtBD_CCCD.Text = "";
            txtBD_HoChieu.Text = "";
            txtBD_Ngaysinh.Text = txtBD_Namsinh.Text = "";
            // txtBD_HKTT_Chitiet.Text = "";
            txtBD_Tamtru_Chitiet.Text = "";
            txtBD_NDD_Diachichitiet.Text = "";
            hddID.Value = "0";
        }
        private void LoadCombobox()
        {
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            //Load đối tượng nộp đơn
            ddlLoaiNguyendon.Items.Clear();
            ddlLoaiNguyendon.DataSource = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.DOITUONGNOPYCPS);
            ddlLoaiNguyendon.DataTextField = "TEN";
            ddlLoaiNguyendon.DataValueField = "ID";
            ddlLoaiNguyendon.DataBind();
            //Loại hình doanh nghiệp
            ddlLoaiBidon.Items.Clear();
            ddlLoaiBidon.DataSource = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.PHASAN).OrderBy(y => y.ARRTHUTU).ToList();
            ddlLoaiBidon.DataTextField = "CASE_NAME";
            ddlLoaiBidon.DataValueField = "ID";
            ddlLoaiBidon.DataBind();
            //Ngành kinh tế 
            ddlNganhKT.Items.Clear();
            ddlNganhKT.DataSource = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.NGANHKINHTE).OrderBy(y => y.ARRTHUTU).ToList();
            ddlNganhKT.DataTextField = "CASE_NAME";
            ddlNganhKT.DataValueField = "ID";
            ddlNganhKT.DataBind();
            //Load cán bộ
            ddlCanbonhandon.Items.Clear();
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            ddlCanbonhandon.DataSource = oCBDT;
            ddlCanbonhandon.DataTextField = "MA_TEN";
            ddlCanbonhandon.DataValueField = "ID";
            ddlCanbonhandon.DataBind();
            //Set mặc định cán bộ loginf
            try
            {
                string strCBID = Session[ENUM_SESSION.SESSION_CANBOID] + "";
                if (strCBID != "") ddlCanbonhandon.SelectedValue = strCBID;
            }
            catch { }
            ddlThamphankynhandon.Items.Clear();
            ddlThamphankynhandon.DataSource = oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
            ddlThamphankynhandon.DataTextField = "MA_TEN";
            ddlThamphankynhandon.DataValueField = "ID";
            ddlThamphankynhandon.DataBind();
            ddlThamphankynhandon.Items.Insert(0, new ListItem("--Chọn thẩm phán--", "0"));
            //Load Quan hệ pháp luật
            ddlQuanhephapluat.Items.Clear();
            ddlQuanhephapluat.DataSource = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.QUANHEPL_YEUCAUPS);
            ddlQuanhephapluat.DataTextField = "TEN";
            ddlQuanhephapluat.DataValueField = "ID";
            ddlQuanhephapluat.DataBind();
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
                APS_DON oT;
                #region "THÔNG TIN ĐƠN KHỞI KIỆN"
                if (hddID.Value == "" || hddID.Value == "0")
                {
                    oT = new APS_DON();
                }
                else
                {
                    decimal ID = Convert.ToDecimal(hddID.Value);
                    oT = dt.APS_DON.Where(x => x.ID == ID).FirstOrDefault();
                }
                oT.TENVUVIEC = txtTennguyendon.Text + " - " + txtBD_Ten.Text + " - " + ddlQuanhephapluat.SelectedItem.Text;
                // oT.SOTHUTU = (txtSothutu.Text == "") ? 0 : Convert.ToDecimal(txtSothutu.Text);
                oT.HINHTHUCNHANDON = Convert.ToDecimal(ddlHinhthucnhandon.SelectedValue);
                DateTime dNgayViet;
                DateTime dNgayNhan;
                dNgayViet = (String.IsNullOrEmpty(txtNgayViet.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayViet.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                dNgayNhan = (String.IsNullOrEmpty(txtNgayNhan.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oT.NGAYVIETDON = dNgayViet;
                oT.NGAYNHANDON = dNgayNhan;
                oT.LOAIQUANHE = Convert.ToDecimal(ddlLoaiQuanhe.SelectedValue);
                oT.QUANHEPHAPLUATID = Convert.ToDecimal(ddlQuanhephapluat.SelectedValue);
                oT.CANBONHANDONID = Convert.ToDecimal(ddlCanbonhandon.SelectedValue);
                oT.THAMPHANKYNHANDON = Convert.ToDecimal(ddlThamphankynhandon.SelectedValue);
                oT.YEUTONUOCNGOAI = Convert.ToDecimal(ddlYeutonuocngoai.SelectedValue);
                oT.DONKIENCUANGUOIKHAC = txtDonkiencuanguoikhac.Text;
                oT.LOAIDON = Convert.ToDecimal(ddlLoaidon.SelectedValue);
                oT.NOIDUNGKHOIKIEN = txtNoidungkhoikien.Text;

                if (hddID.Value == "" || hddID.Value == "0")
                {
                    APS_DON_BL dsBL = new APS_DON_BL();
                    oT.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    oT.TT = dsBL.GETNEWTT((decimal)oT.TOAANID);
                    oT.TRANGTHAI = ENUM_DS_TRANGTHAI.TAOMOI;
                    //oT.MAVUVIEC = Session[ENUM_SESSION.SESSION_MADONVI] + "." + ENUM_LOAIVUVIEC.AN_PHASAN + "." + oT.TT.ToString();
                    oT.NGAYTAO = DateTime.Now;
                    oT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    oT.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                    dt.APS_DON.Add(oT);
                    dt.SaveChanges();
                    hddID.Value = oT.ID.ToString();
                    //Sinh ma vu viec
                    oT.MAVUVIEC = ENUM_LOAIVUVIEC.AN_PHASAN + "." + Session[ENUM_SESSION.SESSION_MADONVI] + "." + oT.ID.ToString();
                    dt.SaveChanges();


                    //anhvh add 26/06/2020
                    GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                    GD.GAIDOAN_INSERT_UPDATE("7", oT.ID, 2, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0, 0);
                }
                else
                {
                    oT.NGAYSUA = DateTime.Now;
                    oT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.SaveChanges();
                }
                #endregion
                //Lưu nguyên đơn đại diện
                #region "NGUYÊN ĐƠN ĐẠI DIỆN"
                List<APS_DON_DUONGSU> lstNguyendon = dt.APS_DON_DUONGSU.Where(x => x.DONID == oT.ID && x.ISDAIDIEN == 1 && x.TUCACHTOTUNG_MA == ENUM_PHASAN_TUCACHTOTUNG.NGUOIYEUCAUPS).ToList();
                APS_DON_DUONGSU oND = new APS_DON_DUONGSU();
                if (lstNguyendon.Count > 0) oND = lstNguyendon[0];
                oND.DONID = oT.ID;
                oND.TENDUONGSU = Convert.ToDecimal(ddlLoaiNguyendon.SelectedValue) == 1 ? Cls_Comon.FormatTenRieng(txtTennguyendon.Text) : Cls_Comon.FormatTenTochuc(txtTennguyendon.Text);
                oND.ISDAIDIEN = 1;
                oND.TUCACHTOTUNG_MA = ENUM_PHASAN_TUCACHTOTUNG.NGUOIYEUCAUPS;
                oND.LOAIDUONGSU = Convert.ToDecimal(ddlLoaiNguyendon.SelectedValue);
                oND.SOCMND = txtND_CMND.Text;
                oND.SO_CCCD = txtND_CCCD.Text;
                oND.SO_HO_CHIEU = txtND_HoChieu.Text;
                oND.QUOCTICHID = Convert.ToDecimal(ddlND_Quoctich.SelectedValue);
                oND.TAMTRUTINHID = Convert.ToDecimal(ddlTamTru_Tinh_NguyenDon.SelectedValue);
                oND.TAMTRUID = Convert.ToDecimal(ddlTamTru_Huyen_NguyenDon.SelectedValue);
                oND.TAMTRUCHITIET = txtND_TTChitiet.Text;
                oND.DIACHICOQUAN = txtND_NoiLamViec.Text.Trim();
                //ond.hktttinhid = convert.todecimal(ddlthuongtru_tinh_nguyendon.selectedvalue);
                //ond.hkttid = convert.todecimal(ddlthuongtru_huyen_nguyendon.selectedvalue);
                //ond.hkttchitiet = txtnd_hktt_chitiet.text;
                DateTime dNDNgaysinh;
                dNDNgaysinh = (String.IsNullOrEmpty(txtND_Ngaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NGAYSINH = dNDNgaysinh;

                oND.NAMSINH = txtND_Namsinh.Text == "" ? 0 : Convert.ToDecimal(txtND_Namsinh.Text);
                oND.GIOITINH = Convert.ToDecimal(ddlND_Gioitinh.SelectedValue);
                oND.NGUOIDAIDIEN = Cls_Comon.FormatTenRieng(txtND_NDD_Ten.Text);
                oND.SINHSONG_NUOCNGOAI = chkND_ONuocNgoai.Checked == true ? 1 : 0;
                oND.CHUCVU = txtND_NDD_Chucvu.Text;
                oND.EMAIL = txtND_Email.Text;
                oND.DIENTHOAI = txtND_Dienthoai.Text;
                oND.FAX = txtND_Fax.Text;
                oND.NDD_DIACHIID = Convert.ToDecimal(ddlNDD_Huyen_NguyenDon.SelectedValue);
                oND.NDD_DIACHICHITIET = txtND_NDD_Diachichitiet.Text;
                oND.NDD_DIACHICHITIET = txtND_NDD_Diachichitiet.Text;
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
                    dt.APS_DON_DUONGSU.Add(oND);
                    dt.SaveChanges();
                }
                #endregion
                #region "BỊ ĐƠN ĐẠI DIỆN"
                List<APS_DON_DUONGSU> lstBidon = dt.APS_DON_DUONGSU.Where(x => x.DONID == oT.ID && x.ISDAIDIEN == 1 && x.TUCACHTOTUNG_MA == ENUM_PHASAN_TUCACHTOTUNG.DNHTXBITUYENBOPS).ToList();
                APS_DON_DUONGSU oBD = new APS_DON_DUONGSU();
                if (lstBidon.Count > 0) oBD = lstBidon[0];
                oBD.DONID = oT.ID;
                oBD.TENDUONGSU = Convert.ToDecimal(ddlLoaiBidon.SelectedValue) == 1 ? Cls_Comon.FormatTenRieng(txtBD_Ten.Text) : Cls_Comon.FormatTenTochuc(txtBD_Ten.Text);
                oBD.ISDAIDIEN = 1;
                oBD.TUCACHTOTUNG_MA = ENUM_PHASAN_TUCACHTOTUNG.DNHTXBITUYENBOPS;
                oBD.LOAIDUONGSU = Convert.ToDecimal(ddlLoaiBidon.SelectedValue);
                if (ddlNganhKT.Visible)
                    oBD.NGANHKINHTEID = Convert.ToDecimal(ddlNganhKT.SelectedValue);
                else
                    oBD.NGANHKINHTEID = 0;
                oBD.SOCMND = txtBD_CMND.Text;
                oBD.SO_CCCD = txtBD_CCCD.Text;
                oBD.SO_HO_CHIEU = txtBD_HoChieu.Text;
                oBD.QUOCTICHID = Convert.ToDecimal(ddlBD_Quoctich.SelectedValue);
                oBD.TAMTRUTINHID = Convert.ToDecimal(ddlTamTru_Tinh_BiDon.SelectedValue);
                oBD.TAMTRUID = Convert.ToDecimal(ddlTamTru_Huyen_BiDon.SelectedValue);
                oBD.TAMTRUCHITIET = txtBD_Tamtru_Chitiet.Text;
                oBD.DIACHICOQUAN = txtBD_NoiLamViec.Text.Trim();
                //oBD.HKTTTINHID = Convert.ToDecimal(ddlThuongTru_Tinh_BiDon.SelectedValue);
                //oBD.HKTTID = Convert.ToDecimal(ddlThuongTru_Huyen_BiDon.SelectedValue);
                //oBD.HKTTCHITIET = txtBD_HKTT_Chitiet.Text;
                DateTime dBDNgaysinh;
                dBDNgaysinh = (String.IsNullOrEmpty(txtBD_Ngaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtBD_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oBD.NGAYSINH = dBDNgaysinh;

                oBD.NAMSINH = txtBD_Namsinh.Text == "" ? 0 : Convert.ToDecimal(txtBD_Namsinh.Text);
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
                    dt.APS_DON_DUONGSU.Add(oBD);
                    dt.SaveChanges();
                }
                #endregion
                APS_DON_DUONGSU_BL oDonBL = new APS_DON_DUONGSU_BL();
                oDonBL.APS_DON_YEUTONUOCNGOAI_UPDATE(oT.ID);
                return true;
            }
            catch (Exception ex)
            {
                lstMsgT.Text = lstMsgB.Text = "Lỗi: " + ex.Message;
                return false;
            }
        }
        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            if (SaveData())
            {
                lstMsgT.Text = lstMsgB.Text = "Lưu thông tin đơn thành công !";
                Session["PS_THEMDSK"] = hddID.Value;
                DsPSDuongSu1.Visible = true;
                DsPSDuongSu1.DonID = Convert.ToDecimal(hddID.Value);
                DsPSDuongSu1.ReLoad();

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
                    oNSD.IDANPHASAN = IDVuViec;
                    dt.SaveChanges();
                }
                Session[ENUM_LOAIAN.AN_PHASAN] = IDVuViec;
                Response.Redirect("Thongtindon.aspx");
                //Cls_Comon.ShowMessageAndRedirect(this, this.GetType(), "MsgDSDON", "Lưu thông tin thành công, tiếp theo hãy chọn chức năng khác cần thao tác trong danh sách bên trái !", Cls_Comon.GetRootURL() + "/Trangchu.aspx");
            }
        }
        protected void cmdUpdateAndNew_Click(object sender, EventArgs e)
        {
            if (SaveData())
            {
                ResetControls();
                lstMsgT.Text = lstMsgB.Text = "Hoàn thành Lưu, bạn hãy nhập thông tin đơn tiếp theo !";
                DsPSDuongSu1.Visible = false;
                DsPSDuongSu1.DonID = 0;
                // txtSothutu.Focus();
            }
        }
        protected void cmdQuaylai_Click(object sender, EventArgs e)
        {
            Response.Redirect("Danhsach.aspx");
        }
        protected void txtND_Ngaysinh_TextChanged(object sender, EventArgs e)
        {
            DateTime d;
            d = (String.IsNullOrEmpty(txtND_Ngaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (d != DateTime.MinValue)
            {
                txtND_Namsinh.Text = d.Year.ToString();
            }
            txtND_Namsinh.Focus();
        }
        protected void txtBD_Ngaysinh_TextChanged(object sender, EventArgs e)
        {
            DateTime d;
            d = (String.IsNullOrEmpty(txtBD_Ngaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtBD_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (d != DateTime.MinValue)
            {
                txtBD_Namsinh.Text = d.Year.ToString();
            }
            txtBD_Namsinh.Focus();
        }
        protected void ddlLoaiBidon_SelectedIndexChanged(object sender, EventArgs e)
        {
            decimal ID = Convert.ToDecimal(ddlLoaiBidon.SelectedValue);
            DM_QHPL_TK oItem = dt.DM_QHPL_TK.Where(x => x.ID == ID).FirstOrDefault();
            if ((oItem.ARRSAPXEP + "/").Contains("0/401/"))
            {
                lstNganhKT.Visible = true;
                ddlNganhKT.Visible = true;
                Cls_Comon.SetFocus(this, this.GetType(), ddlNganhKT.ClientID);
            }
            else
            {
                lstNganhKT.Visible = false;
                ddlNganhKT.Visible = false;
                Cls_Comon.SetFocus(this, this.GetType(), txtBD_Ten.ClientID);
            }
        }
        protected void ddlLoaiQuanhe_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadCombobox();
        }
        protected void ddlLoaiNguyendon_SelectedIndexChanged(object sender, EventArgs e)
        {
            decimal ID = Convert.ToDecimal(ddlLoaiNguyendon.SelectedValue);
            DM_DATAITEM oItem = dt.DM_DATAITEM.Where(x => x.ID == ID).FirstOrDefault();
            if (oItem.MA == ENUM_DOITUONG_NOPYCPS.NGUOILAODONG)
            {
                pnNDCanhan.Visible = true;
                pnNDTochuc.Visible = false;
            }
            else
            {
                pnNDCanhan.Visible = false;
                pnNDTochuc.Visible = true;
            }
            Cls_Comon.SetFocus(this, this.GetType(), txtTennguyendon.ClientID);
        }
        protected void ddlND_Quoctich_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlND_Quoctich.SelectedIndex > 0)
            {
                // lblND_Batbuoc1.Text = 
                lblND_Batbuoc2.Text = "";
                chkND_ONuocNgoai.Visible = false;
            }
            else
            {
                //lblND_Batbuoc1.Text =
                lblND_Batbuoc2.Text = "(*)";
                chkND_ONuocNgoai.Visible = true;
            }
            decimal ID = Convert.ToDecimal(ddlLoaiNguyendon.SelectedValue);
            DM_DATAITEM oItem = dt.DM_DATAITEM.Where(x => x.ID == ID).FirstOrDefault();
            if (oItem.MA == ENUM_DOITUONG_NOPYCPS.NGUOILAODONG)
                Cls_Comon.SetFocus(this, this.GetType(), ddlND_Gioitinh.ClientID);
            else
                Cls_Comon.SetFocus(this, this.GetType(), txtND_Email.ClientID);
        }
        protected void chkND_ONuocNgoai_CheckedChanged(object sender, EventArgs e)
        {
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
            Cls_Comon.SetFocus(this, this.GetType(), ddlTamTru_Tinh_NguyenDon.ClientID);
        }
        protected void ddlBD_Quoctich_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlBD_Quoctich.SelectedIndex > 0)
            {
                // lblBD_Batbuoc1.Text =
                //lblBD_Batbuoc2.Text = "";
                chkBD_ONuocNgoai.Visible = false;
            }
            else
            {
                //lblBD_Batbuoc1.Text = 
                //lblBD_Batbuoc2.Text = "(*)";
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
                // lblBD_Batbuoc1.Text = 
                //lblBD_Batbuoc2.Text = "(*)";
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

                //ddlThuongTru_Tinh_NguyenDon.DataSource = lstTinh;
                //ddlThuongTru_Tinh_NguyenDon.DataTextField = "TEN";
                //ddlThuongTru_Tinh_NguyenDon.DataValueField = "ID";
                //ddlThuongTru_Tinh_NguyenDon.DataBind();


                //ddlThuongTru_Tinh_BiDon.DataSource = lstTinh;
                //ddlThuongTru_Tinh_BiDon.DataTextField = "TEN";
                //ddlThuongTru_Tinh_BiDon.DataValueField = "ID";
                //ddlThuongTru_Tinh_BiDon.DataBind();

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
            //ddlThuongTru_Tinh_NguyenDon.Items.Add(new ListItem("---Chọn---", "0"));
            //ddlThuongTru_Tinh_BiDon.Items.Add(new ListItem("---Chọn---", "0"));
            ddlTamTru_Tinh_NguyenDon.Items.Insert(0, new ListItem("---Chọn---", "0"));
            ddlTamTru_Tinh_BiDon.Items.Insert(0, new ListItem("---Chọn---", "0"));
            LoadDropNDD_Huyen_NguyenDon();
            LoadDropNDD_Huyen_BiDon();
            //LoadDropThuongTru_Huyen_NguyenDon();
            //LoadDropThuongTru_Huyen_BiDon();
            LoadDropTamTru_Huyen_NguyenDon();
            LoadDropTamTru_Huyen_BiDon();
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
        //private void LoadDropThuongTru_Huyen_NguyenDon()
        //{
        //    ddlThuongTru_Huyen_NguyenDon.Items.Clear();
        //    decimal TinhID = Convert.ToDecimal(ddlThuongTru_Tinh_NguyenDon.SelectedValue);
        //    if (TinhID == 0)
        //    {
        //        ddlThuongTru_Huyen_NguyenDon.Items.Add(new ListItem("---Chọn---", "0"));
        //        return;
        //    }
        //    List<DM_HANHCHINH> lstHuyen = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == TinhID).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
        //    if (lstHuyen != null && lstHuyen.Count > 0)
        //    {
        //        ddlThuongTru_Huyen_NguyenDon.DataSource = lstHuyen;
        //        ddlThuongTru_Huyen_NguyenDon.DataTextField = "TEN";
        //        ddlThuongTru_Huyen_NguyenDon.DataValueField = "ID";
        //        ddlThuongTru_Huyen_NguyenDon.DataBind();
        //        ddlThuongTru_Huyen_NguyenDon.Items.Insert(0, new ListItem("---Chọn---", "0"));
        //    }
        //    else
        //    {
        //        ddlThuongTru_Huyen_NguyenDon.Items.Add(new ListItem("---Chọn---", "0"));
        //    }
        //}
        //private void LoadDropThuongTru_Huyen_BiDon()
        //{
        //    ddlThuongTru_Huyen_BiDon.Items.Clear();
        //    decimal TinhID = Convert.ToDecimal(ddlThuongTru_Tinh_BiDon.SelectedValue);
        //    if (TinhID == 0)
        //    {
        //        ddlThuongTru_Huyen_BiDon.Items.Add(new ListItem("---Chọn---", "0"));
        //        return;
        //    }
        //    List<DM_HANHCHINH> lstHuyen = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == TinhID).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
        //    if (lstHuyen != null && lstHuyen.Count > 0)
        //    {
        //        ddlThuongTru_Huyen_BiDon.DataSource = lstHuyen;
        //        ddlThuongTru_Huyen_BiDon.DataTextField = "TEN";
        //        ddlThuongTru_Huyen_BiDon.DataValueField = "ID";
        //        ddlThuongTru_Huyen_BiDon.DataBind();
        //        ddlThuongTru_Huyen_BiDon.Items.Insert(0, new ListItem("---Chọn---", "0"));
        //    }
        //    else
        //    {
        //        ddlThuongTru_Huyen_BiDon.Items.Add(new ListItem("---Chọn---", "0"));
        //    }
        //}
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
        //protected void ddlThuongTru_Tinh_BiDon_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        LoadDropThuongTru_Huyen_BiDon();
        //        Cls_Comon.SetFocus(this, this.GetType(), ddlThuongTru_Huyen_BiDon.ClientID);
        //    }
        //    catch (Exception ex) { lstMsgT.Text = lstMsgB.Text = ex.Message; }
        //}
        //protected void ddlThuongTru_Tinh_NguyenDon_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        LoadDropThuongTru_Huyen_NguyenDon();
        //        Cls_Comon.SetFocus(this, this.GetType(), ddlThuongTru_Huyen_NguyenDon.ClientID);
        //    }
        //    catch (Exception ex) { lstMsgT.Text = lstMsgB.Text = ex.Message; }
        //}
    }
}