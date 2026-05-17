using BL.GSTP;
using BL.GSTP.AHC;
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
using System.Xml;
using Module.Common.C06;
using System.Text;
using BL.GSTP.DLQGC06;
using System.Text.RegularExpressions;

namespace WEB.GSTP.QLAN.AHC.Hoso
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
            Session[keyDonID] = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HANHCHINH]);
            Session[keyLoaiAnId] = Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH);
        }

        private void setToaGiaiQuyetId()
        {
            string current_id = Request["ID"] + "";

            if (current_id == "" || current_id == "0")
            {
                current_id = Session[ENUM_LOAIAN.AN_HANHCHINH].ToString();
            }

            if (current_id != "" && current_id != "0")
            {
                var ID = Convert.ToDecimal(current_id);
                AHC_DON oT = dt.AHC_DON.Where(x => x.ID == ID).FirstOrDefault();
                hddToaAnGiaiQuyetId.Value = oT == null || oT.TOA_GIAIQUYET_ID == null ? "0" : oT.TOA_GIAIQUYET_ID.ToString();
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID]?.ToString()))
            {
                Response.Redirect("/Trangchu.aspx");
                return;
            }
            if (!IsPostBack)
            {
                try
                {
                    this.setToaGiaiQuyetId();
                    SetDonGhep();
                    LoadCombobox();
                    txtNgayNhan.Text = DateTime.Now.ToString("dd/MM/yyyy");
                    string current_id = Request["ID"] + "";
                    string strtype = Request["type"] + "";
                    DsHCDuongSu1.Visible = false;
                    DsHCDuongSu1.DonID = 0;
                    LoadLoaiDon(false);
                    string strDonID = Session["HC_THEMDSK"] + "";
                    if (strtype == "new")
                    {
                        ltCMNDND.Text = "<span style='color:red'>(*)</span>";
                        ltCCCDND.Text = "<span style='color:red'>(*)</span>";
                        ltCMNDBD.Text = "<span style='color:red'>(*)</span>";
                        ltCCCDBD.Text = "<span style='color:red'>(*)</span>";
                        DONGHEP.Visible = false;
                        if (strDonID != "")
                        {

                            hddID.Value = Session["HC_THEMDSK"] + "";
                            decimal ID = Convert.ToDecimal(Session["HC_THEMDSK"]);
                            LoadInfo(ID);
                            DsHCDuongSu1.Visible = true;
                            DsHCDuongSu1.DonID = ID;
                            DsHCDuongSu1.ReLoad();
                        }
                    }
                    else if (strtype == "list")
                    {
                        if (current_id != "" && current_id != "0")
                        {
                            hddID.Value = current_id.ToString();
                            decimal ID = Convert.ToDecimal(current_id);
                            LoadInfo(ID);
                            DsHCDuongSu1.Visible = true;
                            DsHCDuongSu1.DonID = ID;
                            DsHCDuongSu1.ReLoad();
                        }
                    }
                    else
                    {
                        current_id = Session[ENUM_LOAIAN.AN_HANHCHINH] + "";
                        if (current_id != "" && current_id != "0")
                        {
                            hddID.Value = current_id.ToString();
                            decimal ID = Convert.ToDecimal(current_id);
                            LoadInfo(ID);
                            DsHCDuongSu1.Visible = true;
                            DsHCDuongSu1.DonID = ID;
                            DsHCDuongSu1.ReLoad();
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
                        AHC_DON oT = dt.AHC_DON.Where(x => x.ID == ID).FirstOrDefault();
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
                        string Result = new AHC_CHUYEN_NHAN_AN_BL().Check_NhanAn(ID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
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


                        //Nếu mà là án đã kết thúc ẩn nút lưu 
                        //check vu an ket thuc de thong bao khong cho sua
                        Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                        if (anKetThuc)
                        {
                            Cls_Comon.SetButton(cmdUpdate, false);
                            Cls_Comon.SetButton(cmdUpdateSelect, false);
                            Cls_Comon.SetButton(cmdUpdateAndNew, false);

                            Cls_Comon.SetButton(cmdUpdateB, false);
                            Cls_Comon.SetButton(cmdUpdateSelectB, false);
                            Cls_Comon.SetButton(cmdUpdateAndNewB, false);


                            DONGHEP.hiddenbtnThemMoi();
                            DsHCDuongSu1.hiddenbtnThemMoi();
                            lstMsgT.Text = lstMsgB.Text = "Án đã kết thúc, không được sửa đổi !";

                        }

                    }

                    else
                    {
                        SetTinhHuyenMacDinh();
                        // Ẩn cán bộ nhận đơn toà cũ
                        ddlOldCanbonhandon.Visible = false;
                        // Thẩm phán ký nhận đơn toà cũ
                        ddlOldThamphankynhandon.Visible = false;

                    }
                    ddlHinhthucnhandon.Focus();

                    if (strtype != "new")
                    {
                        current_id = Session[ENUM_LOAIAN.AN_HANHCHINH] + "";
                        if (!string.IsNullOrEmpty(current_id))
                        {
                            decimal Id = Convert.ToDecimal(current_id);

                            List<AHC_DON_THAMPHAN> oDON_THAMPHAN = dt.AHC_DON_THAMPHAN.Where(x => x.DONID == Id).ToList<AHC_DON_THAMPHAN>();
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

                            AHC_DON oDon = dt.AHC_DON.Where(x => x.ID == Id).FirstOrDefault();
                            if (oDon.LOAIDON == 2)
                            {
                                lstMsgT.Text = lstMsgB.Text = "Đơn đã chuyển sang tòa án khác xử lý !";
                                Cls_Comon.SetButton(cmdUpdate, false);
                                Cls_Comon.SetButton(cmdUpdateB, false);
                                Cls_Comon.SetButton(cmdUpdateSelect, false);
                                Cls_Comon.SetButton(cmdUpdateAndNew, false);
                                Cls_Comon.SetButton(cmdUpdateSelectB, false);
                                Cls_Comon.SetButton(cmdUpdateAndNewB, false);
                            }
                            else
                            {
                                List<AHC_DON_XULY> oDON_XLY = dt.AHC_DON_XULY.Where(x => x.DONID == Id).ToList<AHC_DON_XULY>();
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
                        DsHCDuongSu1.hiddenbtnThemMoi();
                        DONGHEP.hiddenbtnThemMoi();
                    }

                    DsHCDuongSu1.DonID = Convert.ToDecimal(hddID.Value);
                }
                catch (Exception ex)
                {
                    lstMsgT.Text = lstMsgB.Text = "Lỗi: " + ex.Message;
                }
            }

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
            // GTEL-HUNGNQ 01-10-2025 tạo AHC_DON_DUONGSU_C06

            AHC_DON oT = dt.AHC_DON.Where(x => x.ID == ID).FirstOrDefault();
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


            txtQuanhephapluat_name(oT);
            if (oT.QHPLTKID != null)
            {
                ddlQHPLTK.SelectedValue = oT.QHPLTKID.ToString();
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

            ddlYeutonuocngoai.SelectedValue = oT.YEUTONUOCNGOAI.ToString();
            txtDonkiencuanguoikhac.Text = oT.DONKIENCUANGUOIKHAC;
            ddlLoaidon.SelectedValue = oT.LOAIDON.ToString();
            txtNoidungkhoikien.Text = oT.NOIDUNGKHOIKIEN;
            txtQDSO.Text = oT.SOQD + "";
            txtQDHanhvi.Text = oT.HANHVIHC + "";
            txtQDTen.Text = oT.TENQD + "";
            if (oT.NGAYQD != null) txtQDNgay.Text = ((DateTime)oT.NGAYQD).ToString("dd/MM/yyyy", cul);
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
            //Load Người khởi kiện
            #region "Người khởi kiện ĐẠI DIỆN"
            List<AHC_DON_DUONGSU> lstNguyendon = dt.AHC_DON_DUONGSU.Where(x => x.DONID == oT.ID && x.ISDAIDIEN == 1 && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON).ToList();
            AHC_DON_DUONGSU oND = new AHC_DON_DUONGSU();
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
                if (oND.TAMTRUTINHID != null)
                {
                    ddlTamTru_Tinh_NguyenDon.SelectedValue = oND.TAMTRUTINHID.ToString();
                    LoadDropTamTru_Huyen_NguyenDon();
                    if (oND.TAMTRUID != null)
                    {
                        ddlTamTru_Huyen_NguyenDon.SelectedValue = oND.TAMTRUID.ToString();
                    }
                }
                txtND_NoiLamViec.Text = oND.DIACHICOQUAN;
                //if (oND.HKTTTINHID != null)
                //{
                //    ddlThuongTru_Tinh_NguyenDon.SelectedValue = oND.HKTTTINHID.ToString();
                //    LoadDropThuongTru_Huyen_NguyenDon();
                //    if (oND.HKTTID != null)
                //    {
                //        ddlThuongTru_Huyen_NguyenDon.SelectedValue = oND.HKTTID.ToString();
                //    }
                //}
                txtND_TTChitiet.Text = oND.TAMTRUCHITIET;
                //txtND_HKTT_Chitiet.Text = oND.HKTTCHITIET;
                if (oND.NGAYSINH != DateTime.MinValue) txtND_Ngaysinh.Text = ((DateTime)oND.NGAYSINH).ToString("dd/MM/yyyy", cul);

                txtND_Namsinh.Text = oND.NAMSINH == 0 ? "" : oND.NAMSINH.ToString();
                ddlND_Gioitinh.SelectedValue = oND.GIOITINH.ToString();
                txtND_NDD_Ten.Text = oND.NGUOIDAIDIEN;
                if (pnNDTochuc.Visible)
                {
                    txtND_NDD_Chucvu.Text = oND.CHUCVU;
                }
                else
                {
                    txtND_ChucVu.Text = oND.CHUCVU;
                }
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
                    // lblND_Batbuoc1.Text = 
                    lblND_Batbuoc2.Text = "(*)";
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

            //Load người bị kiện
            #region "người bị kiện ĐẠI DIỆN"
            List<AHC_DON_DUONGSU> lstBidon = dt.AHC_DON_DUONGSU.Where(x => x.DONID == oT.ID && x.ISDAIDIEN == 1 && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.BIDON).ToList();
            AHC_DON_DUONGSU oBD = new AHC_DON_DUONGSU();
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
                txtBD_NoiLamViec.Text = oBD.DIACHICOQUAN;

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
                    //  lblBD_Batbuoc2.Text = "";
                    chkBD_ONuocNgoai.Visible = false;
                }
                else
                {
                    //lblBD_Batbuoc1.Text = 
                    // lblBD_Batbuoc2.Text = "(*)";
                    chkBD_ONuocNgoai.Visible = true;
                }
                if (chkBD_ONuocNgoai.Checked)
                {
                    // lblBD_Batbuoc1.Text = 
                    //  lblBD_Batbuoc2.Text = "";
                }
                else
                {
                    //lblBD_Batbuoc1.Text =
                    //lblBD_Batbuoc2.Text = "(*)";
                }
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

                // GTEL-HUNGNQ 01-10-2025 lấy thông tin xác thực C06 của bị đơn
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
            else
            {

                DsHCDuongSu1.Visible = false;

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
            DateTime dNgayNhan = (String.IsNullOrEmpty(txtNgayNhan.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
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
            if (ddlQHPLTK.SelectedIndex == 0)
            {
                lstMsgT.Text = lstMsgB.Text = "Chưa chọn quan hệ pháp luật dùng thống kê";
                Cls_Comon.SetFocus(this, this.GetType(), ddlQHPLTK.ClientID);
                return false;
            }
            decimal IDChitieuTK = Convert.ToDecimal(ddlQHPLTK.SelectedValue);
            if (dt.DM_QHPL_TK.Where(x => x.PARENT_ID == IDChitieuTK).ToList().Count > 0)
            {
                lstMsgT.Text = lstMsgB.Text = "Quan hệ pháp luật dùng cho thống kê chỉ được chọn mã con, bạn hãy chọn lại !";
                Cls_Comon.SetFocus(this, this.GetType(), ddlQHPLTK.ClientID);
                return false;
            }
            if (ddlCanbonhandon.Items.Count == 0)
            {
                lstMsgT.Text = lstMsgB.Text = "Chưa chọn người nhận đơn";
                Cls_Comon.SetFocus(this, this.GetType(), ddlCanbonhandon.ClientID);
                return false;
            }
            if (txtTennguyendon.Text == "")
            {
                lstMsgT.Text = lstMsgB.Text = "Chưa nhập tên người khởi kiện";
                txtTennguyendon.Focus();
                return false;
            }
            if (ddlLoaiNguyendon.SelectedValue == "1")
            {
                if (txtND_Namsinh.Text == "")
                {
                    lstMsgT.Text = lstMsgB.Text = "Chưa nhập năm sinh người khởi kiện";
                    txtND_Namsinh.Focus();
                    return false;
                }
                if (lblND_Batbuoc2.Text != "")
                {
                    //if (ddlThuongTru_Huyen_NguyenDon.SelectedValue == "0")
                    //{
                    //    lstMsgT.Text = lstMsgB.Text = "Chưa chọn nơi thường trú của người khởi kiện!";
                    //    Cls_Comon.SetFocus(this, this.GetType(), ddlThuongTru_Huyen_NguyenDon.ClientID);
                    //    return false;
                    //}
                    if (ddlTamTru_Huyen_NguyenDon.SelectedValue == "0")
                    {
                        lstMsgT.Text = lstMsgB.Text = "Chưa chọn nơi sinh sống của người khởi kiện!";
                        Cls_Comon.SetFocus(this, this.GetType(), ddlTamTru_Huyen_NguyenDon.ClientID);
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
                    if (!string.IsNullOrEmpty(txtBD_HoChieu.Text) && txtBD_HoChieu.Text.Length != 8)
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
                //if (txtBD_Namsinh.Text == "")
                //{
                //    lstMsgT.Text = lstMsgB.Text = "Chưa nhập năm sinh người bị kiện";
                //    txtBD_Namsinh.Focus();
                //    return false;
                //}
                //if (lblBD_Batbuoc2.Text != "")
                //{
                //    //if (ddlThuongTru_Huyen_BiDon.SelectedValue == "0")
                //    //{
                //    //    lstMsgT.Text = lstMsgB.Text = "Chưa chọn nơi thường trú của người bị kiện!";
                //    //    Cls_Comon.SetFocus(this, this.GetType(), ddlThuongTru_Huyen_BiDon.ClientID);
                //    //    return false;
                //    //}
                //    if (ddlTamTru_Huyen_BiDon.SelectedValue == "0")
                //    {
                //        lstMsgT.Text = lstMsgB.Text = "Chưa chọn nơi sinh sống của người bị kiện";
                //        Cls_Comon.SetFocus(this, this.GetType(), ddlTamTru_Huyen_BiDon.ClientID);
                //        return false;
                //    }
                //}
            }
            if (txtBD_Ten.Text == "")
            {
                lstMsgT.Text = lstMsgB.Text = "Chưa nhập tên người bị kiện";
                txtBD_Ten.Focus();
                return false;
            }
            #region check bỏ tích hoà giải
            if (hddID.Value != "" && hddID.Value != "0")
            {
                decimal ID = Convert.ToDecimal(hddID.Value);
                var oT = dt.AHC_DON.Where(x => x.ID == ID).FirstOrDefault();
                if (ckbTienHanhHG.Checked == false)
                {
                    if (oT.HOAGIAI_TRANGTHAI.GetValueOrDefault(0) > 0)
                    {
                        HOAGIAI_DON hgdon = DataExtensions.GetAllWithClause<HOAGIAI_DON>($"VUVIECID = {oT.ID} AND LOAIANID = {ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH.toNumber()}").FirstOrDefault();
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
            txtND_ChucVu.Text = "";

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

            LoadLoaiDon(false);
        }

        private void LoadCombobox()
        {
            //Load cán bộ
            ddlCanbonhandon.Items.Clear();
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            ddlCanbonhandon.DataSource = oCBDT;
            ddlCanbonhandon.DataTextField = "MA_TEN";
            ddlCanbonhandon.DataValueField = "ID";
            ddlCanbonhandon.DataBind();
            string type = Request["type"] + "";
            //Load old cán bộ
            ddlOldCanbonhandon.Items.Clear();
            var toaGiaiQuyetId = hddToaAnGiaiQuyetId.Value;
            DataTable oOldCBDT = toaGiaiQuyetId.Equals("0") || type.Equals("new") ? new DataTable() : oDMCBBL.DM_CANBO_GETBYDONVI(Convert.ToDecimal(toaGiaiQuyetId));
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
            ddlThamphankynhandon.Items.Clear();
            ddlThamphankynhandon.DataSource = oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
            ddlThamphankynhandon.DataTextField = "MA_TEN";
            ddlThamphankynhandon.DataValueField = "ID";
            ddlThamphankynhandon.DataBind();
            ddlThamphankynhandon.Items.Insert(0, new ListItem("--Chọn thẩm phán--", "0"));

            // Load old thảm phán ký nhận đơn
            ddlOldThamphankynhandon.Items.Clear();
            ddlOldThamphankynhandon.DataSource = toaGiaiQuyetId.Equals("0") || type.Equals("new") ? new DataTable() : oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(Convert.ToDecimal(toaGiaiQuyetId), ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
            ddlOldThamphankynhandon.DataTextField = "MA_TEN";
            ddlOldThamphankynhandon.DataValueField = "ID";
            ddlOldThamphankynhandon.DataBind();
            ddlOldThamphankynhandon.Items.Insert(0, new ListItem("--Chọn thẩm phán--", "0"));

            //Load Quan hệ pháp luật
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            ddlQuanhephapluat.Items.Clear();
            ddlQuanhephapluat.DataSource = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.QUANHEPL_KHIEUKIEN_HC);
            ddlQuanhephapluat.DataTextField = "TEN";
            ddlQuanhephapluat.DataValueField = "ID";
            ddlQuanhephapluat.DataBind();
            //Load QHPL Thống kê.
            ddlQHPLTK.Items.Clear();
            ddlQHPLTK.DataSource = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.HANHCHINH && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
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
                AHC_DON oT;
                
                #region "THÔNG TIN ĐƠN KHỞI KIỆN"
                if (hddID.Value == "" || hddID.Value == "0")
                {
                    oT = new AHC_DON();
                }
                else
                {
                    decimal ID = Convert.ToDecimal(hddID.Value);
                    oT = dt.AHC_DON.Where(x => x.ID == ID).FirstOrDefault();
                }
                //oT.TENVUVIEC = txtTennguyendon.Text + " - " + txtBD_Ten.Text + " - " + ddlQuanhephapluat.SelectedItem.Text;
                // oT.SOTHUTU = (txtSothutu.Text == "") ? 0 : Convert.ToDecimal(txtSothutu.Text);
                oT.HINHTHUCNHANDON = Convert.ToDecimal(ddlHinhthucnhandon.SelectedValue);
                DateTime dNgayViet;
                DateTime dNgayNhan;
                dNgayViet = (String.IsNullOrEmpty(txtNgayViet.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayViet.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                dNgayNhan = (String.IsNullOrEmpty(txtNgayNhan.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oT.NGAYVIETDON = dNgayViet;
                oT.NGAYNHANDON = dNgayNhan;
                oT.LOAIQUANHE = 1;

                //oT.QUANHEPHAPLUATID = Convert.ToDecimal(ddlQuanhephapluat.SelectedValue);

                oT.TENVUVIEC = txtTennguyendon.Text + " - " + txtBD_Ten.Text + " - " + txtQuanhephapluat.Text;
                oT.QUANHEPHAPLUATID = null;
                if (txtQuanhephapluat.Text != null || txtQuanhephapluat.Text != "")
                    oT.QUANHEPHAPLUAT_NAME = txtQuanhephapluat.Text;
                if (txtQuanhephapluat.Text == "" || txtQuanhephapluat.Text == null)
                    oT.QUANHEPHAPLUAT_NAME = null;

                oT.QHPLTKID = Convert.ToDecimal(ddlQHPLTK.SelectedValue);
                oT.CANBONHANDONID = Convert.ToDecimal(ddlCanbonhandon.SelectedValue);
                oT.THAMPHANKYNHANDON = Convert.ToDecimal(ddlThamphankynhandon.SelectedValue);
                oT.YEUTONUOCNGOAI = Convert.ToDecimal(ddlYeutonuocngoai.SelectedValue);
                oT.DONKIENCUANGUOIKHAC = txtDonkiencuanguoikhac.Text;
                oT.LOAIDON = Convert.ToDecimal(ddlLoaidon.SelectedValue);
                oT.NOIDUNGKHOIKIEN = txtNoidungkhoikien.Text;

                oT.SOQD = txtQDSO.Text;
                oT.HANHVIHC = txtQDHanhvi.Text;
                oT.TENQD = txtQDTen.Text;
                oT.NGAYQD = (String.IsNullOrEmpty(txtQDNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtQDNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (hddID.Value == "" || hddID.Value == "0")
                {
                    AHC_DON_BL dsBL = new AHC_DON_BL();
                    oT.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    oT.TT = dsBL.GETNEWTT((decimal)oT.TOAANID);
                    oT.TRANGTHAI = ENUM_DS_TRANGTHAI.TAOMOI;
                    //oT.MAVUVIEC = ENUM_LOAIVUVIEC.AN_HANHCHINH + Session[ENUM_SESSION.SESSION_MADONVI] + oT.TT.ToString();
                    oT.NGAYTAO = DateTime.Now;
                    oT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    oT.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                    //update 14082025
                    if (oT.TOA_GIAIQUYET_ID == null) oT.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    if (oT.TOA_PHUCTHAM_GIAIQUYET_ID == null)
                        oT.TOA_PHUCTHAM_GIAIQUYET_ID = oT.TOAPHUCTHAMID;
                    dt.AHC_DON.Add(oT);
                    dt.SaveChanges();
                    hddID.Value = oT.ID.ToString();
                    //Sinh ma vu viec
                    oT.MAVUVIEC = ENUM_LOAIVUVIEC.AN_HANHCHINH + "." + Session[ENUM_SESSION.SESSION_MADONVI] + "." + oT.ID.ToString();
                    dt.SaveChanges();

                    //anhvh add 26/06/2020
                    GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                    GD.GAIDOAN_INSERT_UPDATE("6", oT.ID, 2, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0, 0);
                }
                else
                {
                    oT.NGAYSUA = DateTime.Now;
                    oT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.SaveChanges();
                }
                #endregion

                #region Trang Thái Hòa Giải
                if (ckbTienHanhHG.Checked)
                {
                    if (oT.HOAGIAI_TRANGTHAI.GetValueOrDefault(0) == 0)
                    {
                        oT.HOAGIAI_TRANGTHAI = (Decimal)ENUM_TRANGTHAI_HOAGIAI.HOAGIAI;
                    }
                    HOAGIAI_DON donHG = DataExtensions.GetAllWithClause<HOAGIAI_DON>($"VUVIECID = {oT.ID} AND LOAIANID = {ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH.toNumber()}").FirstOrDefault();
                    if (donHG == null)
                    {
                        donHG = new HOAGIAI_DON()
                        {
                            LOAIANID = ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH.toNumber(),
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
                        HOAGIAI_DON hgdon = DataExtensions.GetAllWithClause<HOAGIAI_DON>($"VUVIECID = {oT.ID} AND LOAIANID = {ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH.toNumber()}").FirstOrDefault();
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
                //Lưu người khởi kiện đại diện
                #region "Người khởi kiện ĐẠI DIỆN"
                List<AHC_DON_DUONGSU> lstNguyendon = dt.AHC_DON_DUONGSU.Where(x => x.DONID == oT.ID && x.ISDAIDIEN == 1 && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON).ToList();
                AHC_DON_DUONGSU oND = new AHC_DON_DUONGSU();
                if (lstNguyendon.Count > 0) oND = lstNguyendon[0];
                oND.DONID = oT.ID;
                oND.TENDUONGSU = Convert.ToDecimal(ddlLoaiNguyendon.SelectedValue) == 1 ? Cls_Comon.FormatTenRieng(txtTennguyendon.Text) : Cls_Comon.FormatTenTochuc(txtTennguyendon.Text);
                oND.ISDAIDIEN = 1;
                oND.TUCACHTOTUNG_MA = ENUM_DANSU_TUCACHTOTUNG.NGUYENDON;
                oND.LOAIDUONGSU = Convert.ToDecimal(ddlLoaiNguyendon.SelectedValue);
                oND.SOCMND = txtND_CMND.Text;
                oND.SO_CCCD = txtND_CCCD.Text;
                oND.SO_HO_CHIEU = txtND_HoChieu.Text;
                oND.QUOCTICHID = Convert.ToDecimal(ddlND_Quoctich.SelectedValue);
                oND.TAMTRUTINHID = Convert.ToDecimal(ddlTamTru_Tinh_NguyenDon.SelectedValue);
                oND.TAMTRUID = Convert.ToDecimal(ddlTamTru_Huyen_NguyenDon.SelectedValue);
                oND.TAMTRUCHITIET = txtND_TTChitiet.Text;
                oND.DIACHICOQUAN = txtND_NoiLamViec.Text + "";

                DateTime dNDNgaysinh;
                dNDNgaysinh = (String.IsNullOrEmpty(txtND_Ngaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NGAYSINH = dNDNgaysinh;

                oND.NAMSINH = txtND_Namsinh.Text == "" ? 0 : Convert.ToDecimal(txtND_Namsinh.Text);
                oND.GIOITINH = Convert.ToDecimal(ddlND_Gioitinh.SelectedValue);
                oND.NGUOIDAIDIEN = Cls_Comon.FormatTenRieng(txtND_NDD_Ten.Text);
                oND.SINHSONG_NUOCNGOAI = chkND_ONuocNgoai.Checked == true ? 1 : 0;

                oND.EMAIL = txtND_Email.Text;
                oND.DIENTHOAI = txtND_Dienthoai.Text;
                oND.FAX = txtND_Fax.Text;
                if (pnNDTochuc.Visible)
                {
                    oND.NDD_DIACHIID = Convert.ToDecimal(ddlNDD_Huyen_NguyenDon.SelectedValue);
                    oND.NDD_DIACHICHITIET = txtND_NDD_Diachichitiet.Text;
                    oND.CHUCVU = txtND_NDD_Chucvu.Text;
                }
                else
                {
                    oND.CHUCVU = txtND_ChucVu.Text;
                }
                oND.NDD_DIACHICHITIET = txtND_NDD_Diachichitiet.Text;
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
                    //hoangndh-vnpt 14072025
                    oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.AHC_DON_DUONGSU.Add(oND);
                    dt.SaveChanges();
                }

                #endregion
                #region Trang Thái Hòa Giải
                if (ckbTienHanhHG.Checked)
                {
                    if (oT.HOAGIAI_TRANGTHAI.GetValueOrDefault(0) == 0)
                    {
                        oT.HOAGIAI_TRANGTHAI = (Decimal)ENUM_TRANGTHAI_HOAGIAI.HOAGIAI;
                    }
                    HOAGIAI_DON donHG = DataExtensions.GetAllWithClause<HOAGIAI_DON>($"VUVIECID = {oT.ID} AND LOAIANID = {ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH.toNumber()}").FirstOrDefault();
                    if (donHG == null)
                    {
                        donHG = new HOAGIAI_DON()
                        {
                            LOAIANID = ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH.toNumber(),
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
                #endregion Trang Thái Hòa Giải

                #region "người bị kiện ĐẠI DIỆN"
                List<AHC_DON_DUONGSU> lstBidon = dt.AHC_DON_DUONGSU.Where(x => x.DONID == oT.ID && x.ISDAIDIEN == 1 && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.BIDON).ToList();
                AHC_DON_DUONGSU oBD = new AHC_DON_DUONGSU();
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
                oBD.DIACHICOQUAN = txtBD_NoiLamViec.Text + "";
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
                    // update 130825
                    oBD.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.AHC_DON_DUONGSU.Add(oBD);
                    dt.SaveChanges();
                }
                #endregion

                AHC_DON_DUONGSU_BL oDonBL = new AHC_DON_DUONGSU_BL();
                oDonBL.AHC_DON_YEUTONUOCNGOAI_UPDATE(oT.ID);
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
                Session["HC_THEMDSK"] = hddID.Value;
                DsHCDuongSu1.Visible = true;
                DsHCDuongSu1.DonID = Convert.ToDecimal(hddID.Value);
                DsHCDuongSu1.ReLoad();
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
                    oNSD.IDANHANHCHINH = IDVuViec;
                    dt.SaveChanges();
                }
                Session[ENUM_LOAIAN.AN_HANHCHINH] = IDVuViec;
                Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
                //Cls_Comon.ShowMessageAndRedirect(this, this.GetType(), "MsgDSDON", "Lưu thông tin thành công, tiếp theo hãy chọn chức năng khác cần thao tác trong danh sách bên trái !", Cls_Comon.GetRootURL() + "/Trangchu.aspx");
            }
        }
        protected void cmdUpdateAndNew_Click(object sender, EventArgs e)
        {
            if (SaveData())
            {
                ResetControls();
                lstMsgT.Text = lstMsgB.Text = "Hoàn thành Lưu, bạn hãy nhập thông tin đơn tiếp theo !";
                DsHCDuongSu1.Visible = false;
                DsHCDuongSu1.DonID = 0;
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
            Cls_Comon.SetFocus(this, this.GetType(), txtBD_Ten.ClientID);
        }
        protected void ddlLoaiQuanhe_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadCombobox();
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
            Cls_Comon.SetFocus(this, this.GetType(), txtTennguyendon.ClientID);
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
                // lblND_Batbuoc1.Text = 
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
                // lblND_Batbuoc1.Text = 
                lblND_Batbuoc2.Text = "";
            }
            else
            {
                // lblND_Batbuoc1.Text =
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
                // lblBD_Batbuoc2.Text = "(*)";
                chkBD_ONuocNgoai.Visible = true;
            }
            if (ddlLoaiBidon.SelectedValue == "1")
                Cls_Comon.SetFocus(this, this.GetType(), ddlBD_Gioitinh.ClientID);
            else
                Cls_Comon.SetFocus(this, this.GetType(), txtBD_Email.ClientID);
        }
        protected void chkBD_ONuocNgoai_CheckedChanged(object sender, EventArgs e)
        {
            //if (chkBD_ONuocNgoai.Checked)
            //{
            //    //lblBD_Batbuoc1.Text = 
            //   // lblBD_Batbuoc2.Text = "";
            //}
            //else
            //{
            //    // lblBD_Batbuoc1.Text =
            //   // lblBD_Batbuoc2.Text = "(*)";
            //}
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
            //ddlThuongTru_Tinh_NguyenDon.Items.Insert(0, new ListItem("---Chọn---", "0"));
            //ddlThuongTru_Tinh_BiDon.Items.Insert(0, new ListItem("---Chọn---", "0"));
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
                string valueFromPopup = Request["__EVENTARGUMENT"];
                if (!string.IsNullOrEmpty(valueFromPopup))
                {
                    ddlTamTru_Tinh_NguyenDon.SelectedValue = valueFromPopup;
                }
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

        private void txtQuanhephapluat_name(AHC_DON oT)
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

        /* GTEL-HUNGNQ 01-10-2025 thêm check dữ liệu C06  theo cccd cho ND*/
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
                string don_id = Session[ENUM_LOAIAN.AN_HANHCHINH] + "";
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
                    chkKhongLamSachND.Enabled = chkBoxCMNDND.Enabled = false;
                    ddlND_Quoctich.Enabled = false;
                    hdTrangThaiXacThucND.Value = "1";
                    chkKhongLamSachND.Checked = chkBoxCMNDND.Checked = false;
                    Session.Remove("CongDan");
                    Session["CongDan"] = CongDan;
                    string StrMsg = "PopupCenter('/QLAN/AHC/Hoso/Popup/pGetDuongSu037.aspx?caller=DuongSuND','Thông tin công dân từ hệ thống Cơ sở dữ liệu quốc gia về dân cư',850,700);";
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

        /* GTEL-HUNGNQ 01-10-2025 thêm check dữ liệu C06  theo cccd cho BD*/
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
                string don_id = Session[ENUM_LOAIAN.AN_HANHCHINH] + "";
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
                    chkKhongLamSachBD.Checked = chkBoxCMNDBD.Checked = false;
                    ddlBD_Quoctich.Enabled = false;
                    hdTrangThaiXacThucBD.Value = "1";
                    Session.Remove("CongDan");
                    Session["CongDan"] = CongDan;
                    string StrMsg = "PopupCenter('/QLAN/AHC/Hoso/Popup/pGetDuongSu037.aspx?caller=DuongSuBD','Thông tin công dân từ hệ thống Cơ sở dữ liệu quốc gia về dân cư',850,700);";
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

        private void EnableControl()
        {
            chkKhongLamSachND.Enabled = chkBoxCMNDND.Enabled = txtTennguyendon.Enabled = txtND_CCCD.Enabled = txtND_Namsinh.Enabled = ddlND_Quoctich.Enabled = hdTrangThaiXacThucND.Value != "1";
            chkKhongLamSachBD.Enabled = chkBoxCMNDBD.Enabled = txtBD_Ten.Enabled = txtBD_CCCD.Enabled = txtBD_Namsinh.Enabled = ddlBD_Quoctich.Enabled = hdTrangThaiXacThucBD.Value != "1";
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

        //C06_CALL_API037_HISTORY
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