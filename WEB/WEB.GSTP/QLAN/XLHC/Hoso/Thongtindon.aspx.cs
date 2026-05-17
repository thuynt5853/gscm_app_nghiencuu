using BL.GSTP;
using BL.GSTP.BANGSETGET;
using DAL.GSTP;
using Module.Common;
using NLog;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.XLHC.Hoso
{
    public partial class Thongtindon : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public decimal QuocTichVN = 0;
        private const decimal ROOT = 0;
        private Logger logger = NLog.LogManager.GetCurrentClassLogger();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {

                if (!IsPostBack)
                {
                    LoadCombobox();
                    txtIdSoDinhDanhCaNhan.Enabled = true;
                    string current_id = Request["ID"] + "";
                    string strtype = Request["type"] + "";

                    if (strtype == "new")
                    {

                    }
                    else if (strtype == "list")
                    {
                        if (current_id != "" && current_id != "0")
                        {
                            hddID.Value = current_id.ToString();
                            decimal ID = Convert.ToDecimal(current_id);
                            LoadInfo(ID);

                        }
                    }
                    else
                    {
                        current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
                        if (current_id != "" && current_id != "0")
                        {
                            hddID.Value = current_id.ToString();
                            decimal ID = Convert.ToDecimal(current_id);
                            LoadInfo(ID);
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
                        XLHC_DON oT = dt.XLHC_DON.Where(x => x.ID == ID).FirstOrDefault();
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
                        string Result = new XLHC_CHUYEN_NHAN_AN_BL().Check_NhanAn(ID, StrMsg);
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
                    {
                        SetTinhHuyenMacDinh();
                        // Những combobox old nếu là thêm mới
                        // Ẩn cán bộ nhận đơn toà cũ
                        ddlOldCanbonhandon.Visible = false;
                        // Thẩm phán ký nhận đơn toà cũ
                        ddlOldThamphankynhandon.Visible = false;
                    }
                    if (strtype != "new")
                    {
                        current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
                        if (!string.IsNullOrEmpty(current_id))
                        {
                            decimal Id = Convert.ToDecimal(current_id);
                            List<XLHC_DON_XULY> oDON_XLY = dt.XLHC_DON_XULY.Where(x => x.DONID == Id).ToList<XLHC_DON_XULY>();
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
                    }

                    decimal DONID = Session[ENUM_LOAIAN.BPXLHC] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC]);
                    CheckQuyen(DONID);
                } //If !PostBack
            }
            catch (Exception ex)
            {
                lstMsgT.Text = ENUM_MESSAGE.SERVER_ERROR;
                logger.Error("[toaanid={} donid={}] loi xay ra: {}", Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC]), ex);
            }
        }

        //Check quyen CRUD du lieu
        //Yeu cau: Không được thêm, sửa, xóa khi đã có bước A3( Xử lý hồ sơ)
        private void CheckQuyen(decimal DONID)
        {
            //Man A.3 - Xu ly ho so:
            //QLAN/XLHC/XuLyDon/Danhsach.aspx
            //Check neu co Don thif khong cho cap nhat
            List<XLHC_DON_XULY> oDON_XLY = dt.XLHC_DON_XULY.Where(x => x.DONID == DONID).ToList<XLHC_DON_XULY>();
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
                return;
            }

            //-Thừa hơn thiếu, có thể check tiếp các bước ở phía sau
            XLHC_DON oT = dt.XLHC_DON.Where(x => x.ID == DONID).FirstOrDefault();
            if (oT != null)
            {
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    lstMsgT.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdUpdateB, false);
                    Cls_Comon.SetButton(cmdUpdateSelect, false);
                    Cls_Comon.SetButton(cmdUpdateAndNew, false);
                    Cls_Comon.SetButton(cmdUpdateSelectB, false);
                    Cls_Comon.SetButton(cmdUpdateAndNewB, false);
                    return;
                }
            }
        }
        private void SetTinhHuyenMacDinh()
        {
            //Set defaul value Tinh/Huyen dua theo tai khoan dang nhap
            Cls_Comon.SetValueComboBox(ddlThuongTru_Tinh, Session[ENUM_SESSION.SESSION_TINH_ID]);
            LoadDropThuongTru_Huyen();
            Cls_Comon.SetValueComboBox(ddlThuongTru_Huyen, Session[ENUM_SESSION.SESSION_QUAN_ID]);

            Cls_Comon.SetValueComboBox(ddlTamTru_Tinh, Session[ENUM_SESSION.SESSION_TINH_ID]);
            LoadDropTamTru_Huyen();
            Cls_Comon.SetValueComboBox(ddlTamTru_Huyen, Session[ENUM_SESSION.SESSION_QUAN_ID]);

            Cls_Comon.SetValueComboBox(ddlTinh_CQDN, Session[ENUM_SESSION.SESSION_TINH_ID]);
            LoadDropHuyen_CQDN();
            Cls_Comon.SetValueComboBox(ddlHuyen_CQDN, Session[ENUM_SESSION.SESSION_QUAN_ID]);


        }

        private void LoadInfo(decimal ID)
        {
            DM_HANHCHINH_BL oHCBL = new DM_HANHCHINH_BL();

            XLHC_DON oT = dt.XLHC_DON.Where(x => x.ID == ID).FirstOrDefault();
            hddID.Value = oT.ID.ToString();
            txtMaVuViec.Text = oT.MAVUVIEC;
            txtTenVuViec.Text = oT.TENVUVIEC;
            // if (oT.SOTHUTU != null) txtSothutu.Text = oT.SOTHUTU.ToString();
            ddlHinhthucnhandon.SelectedValue = oT.HINHTHUCNHANDON.ToString();
            if (oT.NGAYVIETDON != DateTime.MinValue) txtNgayViet.Text = ((DateTime)oT.NGAYVIETDON).ToString("dd/MM/yyyy", cul);
            if (oT.NGAYNHANDON != DateTime.MinValue) txtNgayNhan.Text = ((DateTime)oT.NGAYNHANDON).ToString("dd/MM/yyyy", cul);


            ddlQuanhephapluat.SelectedValue = oT.QUANHEPHAPLUATID.ToString();

            // Gán toà án giải quyết
            hddToaanId.Value = oT.TOAANID.ToString();
            hddToaAnGiaiQuyetId.Value = oT.TOA_GIAIQUYET_ID.ToString();
            string type = Request["type"] + "";
            //Load old cán bộ
            /*
            1. Người tạo/sửa: VNPT-Nguyễn Trung Kiên
            2. Mô tả: Chỉ load danh sách đối với đơn cũ được bàn giao; tránh load full tất cả thẩm phán
            */
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            ddlOldCanbonhandon.Items.Clear();
            var toaGiaiQuyetId = hddToaAnGiaiQuyetId.Value;
            DataTable oOldCBDT = toaGiaiQuyetId.Equals("0") || type.Equals("new") ? new DataTable() : oDMCBBL.DM_CANBO_GETBYDONVI(Convert.ToDecimal(toaGiaiQuyetId));
            ddlOldCanbonhandon.DataSource = oOldCBDT;
            ddlOldCanbonhandon.DataTextField = "MA_TEN";
            ddlOldCanbonhandon.DataValueField = "ID";
            ddlOldCanbonhandon.DataBind();

            // Load old thảm phán ký nhận đơn
            ddlOldThamphankynhandon.Items.Clear();
            /*
            1. Người tạo/sửa: VNPT-Nguyễn Trung Kiên
            2. Mô tả: Chỉ load danh sách đối với đơn cũ được bàn giao; tránh load full tất cả thẩm phán
            */
            //ddlOldThamphankynhandon.DataSource = oDMCBBL.DM_CANBO_GETBYDONVI(Convert.ToDecimal(toaGiaiQuyetId));
            ddlOldThamphankynhandon.DataSource = toaGiaiQuyetId.Equals("0") || type.Equals("new") ? new DataTable() : oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(Convert.ToDecimal(toaGiaiQuyetId), ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
            ddlOldThamphankynhandon.DataTextField = "MA_TEN";
            ddlOldThamphankynhandon.DataValueField = "ID";
            ddlOldThamphankynhandon.DataBind();
            ddlOldThamphankynhandon.Items.Insert(0, new ListItem("--Chọn thẩm phán--", "0"));

            if (ddlCanbonhandon.Items.FindByValue(oT.CANBONHANDONID + "") != null)
                ddlCanbonhandon.SelectedValue = oT.CANBONHANDONID + "";
            if (ddlOldCanbonhandon.Items.FindByValue(oT.CANBONHANDONID + "") != null)
            {
                ddlOldCanbonhandon.SelectedValue = oT.CANBONHANDONID + "";
            }
            if (ddlThamphankynhandon.Items.FindByValue(oT.THAMPHANKYNHANDON + "") != null)
                ddlThamphankynhandon.SelectedValue = oT.THAMPHANKYNHANDON + "";
            if (ddlOldThamphankynhandon.Items.FindByValue(oT.THAMPHANKYNHANDON + "") != null)
            {
                ddlOldThamphankynhandon.SelectedValue = oT.THAMPHANKYNHANDON + "";
            }

            //ddlLoaidon.SelectedValue = oT.LOAIDON.ToString();ddlCanbonhandon
            txtNoidungkhoikien.Text = oT.NOIDUNGKHOIKIEN;
            //Load Nguyên hồ sơ
            #region "NGUYÊN hồ sơ ĐẠI DIỆN"
            txtTennguyendon.Text = oT.CQDN_TEN + "";
            if (oT.CQDN_DIACHIID != null)
            {
                DM_HANHCHINH Huyen_CQDN = dt.DM_HANHCHINH.Where(x => x.ID == oT.CQDN_DIACHIID).FirstOrDefault<DM_HANHCHINH>();
                if (Huyen_CQDN != null)
                {
                    ddlTinh_CQDN.SelectedValue = Huyen_CQDN.CAPCHAID.ToString();
                    LoadDropHuyen_CQDN();
                    ddlHuyen_CQDN.SelectedValue = Huyen_CQDN.ID.ToString();
                }
            }
            txtDiachichitiet_CQDN.Text = oT.CQDN_DIACHICHITIET + "";
            txtND_Email.Text = oT.CQDN_EMAIL + "";
            txtND_Dienthoai.Text = oT.CQDN_DIENTHOAI + "";
            txtND_Fax.Text = oT.CQDN_FAX + "";
            txtND_NDD_Ten.Text = oT.CQDN_NGUOIDAIDIEN + "";
            txtND_NDD_Chucvu.Text = oT.CQDN_CHUCVU + "";
            #endregion



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
            //Load đối tượng
            LoadThongTinDoituong();
            //#endregion
        }
        private void LoadThongTinDoituong()
        {
            decimal DonId = Convert.ToDecimal(hddID.Value);
            XLHC_DUONGSU obj = null;
            try
            {
                obj = dt.XLHC_DUONGSU.Where(x => x.DONID == DonId && x.BICANDAUVU == 1 && x.LOAIDOITUONG != 2).OrderBy(y => y.NGAYTAO).ToList<XLHC_DUONGSU>()[0];
            }
            catch (Exception ex) { obj = null; }

            if (obj != null)
            {

                txtTenBiCan.Text = obj.HOTEN;
                //txtCMND.Text = obj.SOCMND;
                if (obj.NGHENGHIEPID > 0)
                    dropNgheNghiep.SelectedValue = obj.NGHENGHIEPID.ToString();

                //-------------------------------------
                //if (obj.QUOCTICHID > 0)
                //    dropQuocTich.SelectedValue = obj.QUOCTICHID.ToString();

                //-------------------------------------
                if (obj.TAMTRUTINHID != null)
                {
                    ddlTamTru_Tinh.SelectedValue = obj.TAMTRUTINHID.ToString();
                    LoadDropTamTru_Huyen();
                    if (obj.TAMTRU != null)
                    {
                        ddlTamTru_Huyen.SelectedValue = obj.TAMTRU.ToString();
                    }
                }
                txtTamtru_Chitiet.Text = obj.TAMTRUCHITIET;
                if (obj.HKTTTINHID != null)
                {
                    ddlThuongTru_Tinh.SelectedValue = obj.HKTTTINHID.ToString();
                    LoadDropThuongTru_Huyen();
                    if (obj.HKTT != null)
                    {
                        ddlThuongTru_Huyen.SelectedValue = obj.HKTT.ToString();
                    }
                }
                txtHKTT_Chitiet.Text = obj.KHTTCHITIET;

                if (obj.NGAYSINH != DateTime.MinValue)
                    txtNgaysinh.Text = ((DateTime)obj.NGAYSINH).ToString("dd/MM/yyyy", cul);
                txtNamSinh.Text = obj.NAMSINH + "";
                txtND_Tuoi.Text = obj.TUOI == 0 ? "" : obj.TUOI.ToString();
                ddlGioitinh.SelectedValue = obj.GIOITINH.ToString();
                //-------------------------------------
                txtTenKhac.Text = obj.TENKHAC + "";

                if (obj.DANTOCID > 0)
                    dropDanToc.SelectedValue = obj.DANTOCID + "";
                if (obj.TONGIAOID > 0)
                    dropTonGiao.SelectedValue = obj.TONGIAOID + "";

                //if (obj.QUOCTICHID > 0)
                //    dropQuocTich.SelectedValue = obj.QUOCTICHID + "";
                if (obj.TRINHDOVANHOAID > 0)
                    dropTrinhDoVH.SelectedValue = obj.TRINHDOVANHOAID + "";

                if (obj.NGHENGHIEPID > 0)
                    dropNgheNghiep.SelectedValue = obj.NGHENGHIEPID + "";

                //if (obj.TINHTRANGGIAMGIUID > 0)
                //    dropTinhTrangGiamGiu.SelectedValue = obj.TINHTRANGGIAMGIUID + "";


                txtHoTenBo.Text = obj.HOTENBO + "";

                txtIdSoDinhDanhCaNhan.Text = obj.SODINHDANHCANHAN + "";
                txtIdHoChieu.Text = obj.HOCHIEU + "";

                if (obj.NAMSINHBO != null) txtNamSinhBo.Text = obj.NAMSINHBO.ToString();
                txtHotenMe.Text = obj.HOTENME;
                if (obj.NAMSINHME != null) txtNamSinhMe.Text = obj.NAMSINHME.ToString();

                rdTreViThanhNien.SelectedValue = (String.IsNullOrEmpty(obj.ISTREVITHANHNIEN + "")) ? "0" : obj.ISTREVITHANHNIEN.ToString();
                if (rdTreViThanhNien.SelectedValue == "1")
                {
                    pnTreViThanhNien.Visible = true;
                    rdTreMoCoi.SelectedValue = obj.TREMOCOI + "";
                    rdTreBoHoc.SelectedValue = obj.TREBOHOC + "";
                    rdTreLangThang.SelectedValue = obj.TRELANGTHANG + "";

                    rdLyHon.SelectedValue = obj.BOMELYHON + "";
                    rdNguoiXuiGiuc.SelectedValue = obj.CONGUOIXUIGIUC + "";
                }
                else
                    pnTreViThanhNien.Visible = false;

                rdNGhienHut.SelectedValue = obj.NGHIENHUT + "";
                rdTinhTrangTaiPham.SelectedValue = obj.TAIPHAM + "";
                //--------------------------------------
                txtTienAn.Text = (string.IsNullOrEmpty(obj.TIENAN + "")) ? "" : obj.TIENAN.ToString();
                txtTienSu.Text = (string.IsNullOrEmpty(obj.TIENSU + "")) ? "" : obj.TIENSU.ToString();
            }
        }
        private bool CheckValid()
        {
            if (txtNgayNhan.Text == "")
            {
                lstMsgT.Text = lstMsgB.Text = "Chưa nhập ngày nhận hồ sơ";
                txtNgayNhan.Focus();
                return false;
            }
            DateTime dNgayNhan = (String.IsNullOrEmpty(txtNgayNhan.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (dNgayNhan > DateTime.Now)
            {
                lstMsgT.Text = lstMsgB.Text = "Ngày nhận đơn không được lớn hơn ngày hiện tại !";
                txtNgayNhan.Focus();
                return false;
            }
            if (ddlCanbonhandon.Items.Count == 0)
            {
                lstMsgT.Text = lstMsgB.Text = "Chưa chọn người nhận hồ sơ";
                ddlCanbonhandon.Focus();
                return false;
            }
            if (txtTennguyendon.Text == "")
            {
                lstMsgT.Text = lstMsgB.Text = "Chưa nhập tên cơ quan đề nghị";
                txtTennguyendon.Focus();
                return false;
            }
            if (txtNgayViet.Text == "")
            {
                lstMsgT.Text = lstMsgB.Text = "Chưa nhập ngày đề nghị";
                txtNgayViet.Focus();
                return false;
            }
            if (ddlHuyen_CQDN.SelectedValue == "0")
            {
                lstMsgT.Text = lstMsgB.Text = "Chưa chọn địa chỉ cơ quan đề nghị";
                return false;
            }

            if (txtTenBiCan.Text == "")
            {
                lstMsgT.Text = lstMsgB.Text = "Chưa nhập tên đối tượng bị đề nghị";
                txtTenBiCan.Focus();
                return false;
            }
            if (txtND_Tuoi.Text == "")
            {
                lstMsgT.Text = lstMsgB.Text = "Chưa nhập tuổi đối tượng bị đề nghị";
                txtND_Tuoi.Focus();
                return false;
            }

            if (ddlThuongTru_Huyen.SelectedValue == "0")
            {
                lstMsgT.Text = lstMsgB.Text = "Chưa chọn địa chỉ thường trú của đối tượng";
                return false;
            }
            if (ddlTamTru_Huyen.SelectedValue == "")
            {
                lstMsgT.Text = lstMsgB.Text = "Chưa chọn địa chỉ tạm trú của đối tượng";
                return false;
            }
            // ✅ Kiểm tra số định danh cá nhân nếu chọn "Có"
            if (rblChonNguonThongTin.SelectedValue == "1")
            {
                string cccd = txtIdSoDinhDanhCaNhan.Text.Trim();

                if (cccd == "")
                {
                    lstMsgT.Text = lstMsgB.Text = "Số định danh cá nhân không được bỏ trống";
                    return false;
                }

                if (cccd.Any(char.IsWhiteSpace))
                {
                    lstMsgT.Text = lstMsgB.Text = "Số định danh cá nhân không được chứa khoảng trắng.";
                    txtIdSoDinhDanhCaNhan.Focus();
                    return false;
                }
                if (!cccd.All(char.IsDigit))
                {
                    lstMsgT.Text = lstMsgB.Text = "Số định danh cá nhân chỉ được chứa các chữ số, không chứa ký tự đặc biệt hoặc chữ cái.";
                    txtIdSoDinhDanhCaNhan.Focus();
                    return false;
                }
                if (cccd.Length != 12)
                {
                    lstMsgT.Text = lstMsgB.Text = "Số định danh cá nhân phải gồm đúng 12 chữ số.";
                    txtIdSoDinhDanhCaNhan.Focus();
                    return false;
                }
            }

            // ✅ Kiểm tra hộ chiếu: chỉ chữ và số, không khoảng trắng hay ký tự đặc biệt
            string hoChieu = txtIdHoChieu.Text.Trim();
            if (!string.IsNullOrEmpty(hoChieu) && !System.Text.RegularExpressions.Regex.IsMatch(hoChieu, @"^[A-Za-z0-9]+$"))
            {
                lstMsgT.Text = lstMsgB.Text = "Số hộ chiếu không hợp lệ. Chỉ nhập chữ và số, không chứa dấu cách hoặc ký tự đặc biệt.";
                txtIdHoChieu.Focus();
                return false;
            }
            if (dropDanToc.SelectedValue == "0")
            {
                lstMsgT.Text = lstMsgB.Text = "Dân tộc không được bỏ trống!";
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

            txtNoidungkhoikien.Text = "";

            txtTennguyendon.Text = "";
            ResetFormBiCao();
            hddID.Value = "0";

        }
        void ResetFormBiCao()
        {
            //txtCMND.Text = txtNgaysinh.Text = txtNamSinh.Text = "";
            txtDiachichitiet_CQDN.Text = "";
            txtHKTT_Chitiet.Text = "";
            txtTamtru_Chitiet.Text = "";
            txtTamtru_Chitiet.Text = "";
            txtHKTT_Chitiet.Text = "";
            txtTenBiCan.Text = txtTenKhac.Text = "";
            txtHoTenBo.Text = txtHotenMe.Text = txtNamSinhBo.Text = txtNamSinhMe.Text = "";
            txtTienAn.Text = txtTienSu.Text = "0";
            rdTinhTrangTaiPham.SelectedValue = rdNGhienHut.SelectedValue = "0";
            rdLyHon.SelectedValue = rdNguoiXuiGiuc.SelectedValue = "0";
            rdTreViThanhNien.SelectedValue = rdTreBoHoc.SelectedValue = rdTreLangThang.SelectedValue = rdTreMoCoi.SelectedValue = "0";
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
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            ddlQuanhephapluat.Items.Clear();
            ddlQuanhephapluat.DataSource = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.QUANHEPL_DENGHI_XLHC);
            ddlQuanhephapluat.DataTextField = "TEN";
            ddlQuanhephapluat.DataValueField = "ID";
            ddlQuanhephapluat.DataBind();

            //-----------Load drop thong tin bi cao----------------------
            LoadDropByGroupName(dropDanToc, ENUM_DANHMUC.DANTOC, true);
            LoadDropByGroupName(dropNgheNghiep, ENUM_DANHMUC.NGHENGHIEP, true);

            //LoadDropByGroupName(dropQuocTich, ENUM_DANHMUC.QUOCTICH, false);
            //dropQuocTich.SelectedValue = QuocTichVN.ToString();

            LoadDropByGroupName(dropTrinhDoVH, ENUM_DANHMUC.TRINHDOVANHOA, false);
            //LoadDropByGroupName(dropTinhTrangGiamGiu, ENUM_DANHMUC.TINHTRANGGIAMGIU, false);
            LoadDropByGroupName(dropTonGiao, ENUM_DANHMUC.TONGIAO, false);

            LoadDropTinh();
        }
        void LoadDropByGroupName(DropDownList drop, string GroupName, Boolean ShowChangeAll)
        {
            drop.Items.Clear();
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(GroupName);
            if (ShowChangeAll)
                drop.Items.Add(new ListItem("------- chọn --------", "0"));
            foreach (DataRow row in tbl.Rows)
            {
                drop.Items.Add(new ListItem(row["TEN"] + "", row["ID"] + ""));
            }
        }
        private bool SaveData()
        {
            try
            {
                if (!CheckValid()) return false;
                XLHC_DON oT;
                #region "THÔNG TIN hồ sơ KHỞI KIỆN"
                if (hddID.Value == "" || hddID.Value == "0")
                {
                    oT = new XLHC_DON();
                }
                else
                {
                    decimal ID = Convert.ToDecimal(hddID.Value);
                    oT = dt.XLHC_DON.Where(x => x.ID == ID).FirstOrDefault();
                }
                oT.TENVUVIEC = txtTennguyendon.Text + " - " + txtTenBiCan.Text + " - " + ddlQuanhephapluat.SelectedItem.Text;
                // oT.SOTHUTU = (txtSothutu.Text == "") ? 0 : Convert.ToDecimal(txtSothutu.Text);
                oT.HINHTHUCNHANDON = Convert.ToDecimal(ddlHinhthucnhandon.SelectedValue);
                DateTime dNgayViet;
                DateTime dNgayNhan;
                dNgayViet = (String.IsNullOrEmpty(txtNgayViet.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayViet.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                dNgayNhan = (String.IsNullOrEmpty(txtNgayNhan.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oT.NGAYVIETDON = dNgayViet;
                oT.NGAYNHANDON = dNgayNhan;
                oT.LOAIQUANHE = 0;
                oT.QUANHEPHAPLUATID = Convert.ToDecimal(ddlQuanhephapluat.SelectedValue);
                oT.CANBONHANDONID = Convert.ToDecimal(ddlCanbonhandon.SelectedValue);
                oT.THAMPHANKYNHANDON = Convert.ToDecimal(ddlThamphankynhandon.SelectedValue);

                //oT.LOAIDON = Convert.ToDecimal(ddlLoaidon.SelectedValue);
                oT.NOIDUNGKHOIKIEN = txtNoidungkhoikien.Text;
                //Lưu nguyên hồ sơ đại diện
                #region "NGUYÊN hồ sơ ĐẠI DIỆN"
                oT.CQDN_TEN = Cls_Comon.FormatTenRieng(txtTennguyendon.Text);
                oT.CQDN_DIACHICHITIET = txtDiachichitiet_CQDN.Text;
                oT.CQDN_DIACHIID = Convert.ToDecimal(ddlHuyen_CQDN.SelectedValue);
                oT.CQDN_EMAIL = txtND_Email.Text;
                oT.CQDN_DIENTHOAI = txtND_Dienthoai.Text;
                oT.CQDN_FAX = txtND_Fax.Text;
                oT.CQDN_NGUOIDAIDIEN = Cls_Comon.FormatTenRieng(txtND_NDD_Ten.Text);
                oT.CQDN_CHUCVU = txtND_NDD_Chucvu.Text;
                
                #endregion
                if (hddID.Value == "" || hddID.Value == "0")
                {
                    XLHC_DON_BL dsBL = new XLHC_DON_BL();
                    oT.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    oT.TT = dsBL.GETNEWTT((decimal)oT.TOAANID);
                    oT.TRANGTHAI = ENUM_DS_TRANGTHAI.TAOMOI;
                    oT.MAVUVIEC = Session[ENUM_SESSION.SESSION_MADONVI] + "." + ENUM_LOAIVUVIEC.BPXLHC + "." + oT.TT.ToString();
                    oT.NGAYTAO = DateTime.Now;
                    oT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    oT.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                    oT.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.XLHC_DON.Add(oT);
                    dt.SaveChanges();
                    hddID.Value = oT.ID.ToString();
                    //anhvh add 26/06/2020
                    GIAI_DOAN_BL GD = new GIAI_DOAN_BL();

                    if (oT.ID == 0)
                    {
                        lstMsgT.Text = lstMsgB.Text = "Đơn bạn tạo đang được định danh với id bằng 0. Vui lòng báo lại ban quản trị!";
                        return false;
                    }
                    GD.GAIDOAN_INSERT_UPDATE_V2("8", oT.ID, 2, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0, 0);
                }
                else
                {
                    oT.NGAYSUA = DateTime.Now;
                    oT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.SaveChanges();
                }

                //vnpt -- Lê Bá Thọ thêm cơ quan đề nghị vào màn đương sự làm đại diện
                #endregion
                #region "Nguyên hồ sơ đại diện lưu cho bảng xlhc_duongsu"
                XLHC_DUONGSU oND = dt.XLHC_DUONGSU.Where(x => x.DONID == oT.ID && x.LOAIDOITUONG == 2 && x.BICANDAUVU == 1).FirstOrDefault();
                if (oND != null)
                {
                    oND.HOTEN = Cls_Comon.FormatTenRieng(txtTennguyendon.Text);
                    oND.EMAIL = txtND_Email.Text;
                    oND.DIENTHOAI = txtND_Dienthoai.Text;
                    oND.FAX = txtND_Fax.Text;
                    oND.TAMTRUTINHID = Convert.ToDecimal(ddlTinh_CQDN.SelectedValue);
                    oND.TAMTRU = Convert.ToDecimal(ddlHuyen_CQDN.SelectedValue);
                    oND.TAMTRUCHITIET = txtDiachichitiet_CQDN.Text;
                    oND.NGUOIDAIDIEN = Cls_Comon.FormatTenRieng(txtND_NDD_Ten.Text);
                    oND.CHUCVU = txtND_NDD_Chucvu.Text;
                    oND.NDD_DIACHIID = Convert.ToDecimal(ddlHuyen_CQDN.SelectedValue);
                    oND.NDD_DIACHICHITIET = txtDiachichitiet_CQDN.Text;
                    oND.QUOCTICHID = 2;
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.SaveChanges();
                } else
                {
                    oND = new XLHC_DUONGSU();
                    oND.BICANDAUVU = 1;
                    oND.DONID = oT.ID;
                    oND.LOAIDOITUONG = 2;
                    oND.HOTEN = Cls_Comon.FormatTenRieng(txtTennguyendon.Text);
                    oND.EMAIL = txtND_Email.Text;
                    oND.DIENTHOAI = txtND_Dienthoai.Text;
                    oND.FAX = txtND_Fax.Text;
                    oND.TAMTRUTINHID = Convert.ToDecimal(ddlTinh_CQDN.SelectedValue);
                    oND.TAMTRU = Convert.ToDecimal(ddlHuyen_CQDN.SelectedValue);
                    oND.TAMTRUCHITIET = txtDiachichitiet_CQDN.Text;
                    oND.NGUOIDAIDIEN = Cls_Comon.FormatTenRieng(txtND_NDD_Ten.Text);
                    oND.CHUCVU = txtND_NDD_Chucvu.Text;
                    oND.NDD_DIACHIID = Convert.ToDecimal(ddlHuyen_CQDN.SelectedValue);
                    oND.NDD_DIACHICHITIET = txtDiachichitiet_CQDN.Text;
                    oND.QUOCTICHID = 2;
                    oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    oND.NGAYSINH = DateTime.MinValue;
                    oND.NGAYTAO = DateTime.Now;
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.XLHC_DUONGSU.Add(oND);
                    dt.SaveChanges();
                }
                #endregion
                #region "BỊ hồ sơ ĐẠI DIỆN"
                SaveBiCao(oT.ID);
                #endregion
                return true;
            }
            catch (Exception ex)
            {
                lstMsgT.Text = lstMsgB.Text = "Lỗi: " + ex.Message;
                return false;
            }
        }
        //void SaveBiCao(Decimal DonID)
        //{

        //    List<XLHC_DUONGSU> lstBidon = dt.XLHC_DUONGSU.Where(x => x.DONID == DonID && x.BICANDAUVU == 1).ToList();
        //    XLHC_DUONGSU obj = new XLHC_DUONGSU();
        //    if (lstBidon.Count > 0) obj = lstBidon[0];


        //    obj.DONID = DonID;
        //    obj.MABICAN = "";
        //    obj.BICANDAUVU = 1;
        //    obj.HOTEN = Cls_Comon.FormatTenRieng(txtTenBiCan.Text.Trim());
        //    obj.TENKHAC = Cls_Comon.FormatTenRieng(txtTenKhac.Text.Trim());
        //    //obj.SOCMND = txtCMND.Text;
        //    obj.SODINHDANHCANHAN = txtIdSoDinhDanhCaNhan.Text.Trim();
        //    obj.HOCHIEU = txtIdHoChieu.Text.Trim();


        //    obj.GIOITINH = Convert.ToDecimal(ddlGioitinh.SelectedValue);

        //    DateTime date_temp;
        //    date_temp = (String.IsNullOrEmpty(txtNgaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
        //    obj.NGAYSINH = date_temp;

        //    //obj.NAMSINH = Convert.ToDecimal(txtNamSinh.Text);
        //    obj.TUOI = txtND_Tuoi.Text == "" ? 0 : Convert.ToDecimal(txtND_Tuoi.Text);
        //    obj.TAMTRUTINHID = Convert.ToDecimal(ddlTamTru_Tinh.SelectedValue);
        //    obj.TAMTRU = Convert.ToDecimal(ddlTamTru_Huyen.SelectedValue);
        //    obj.TAMTRUCHITIET = txtTamtru_Chitiet.Text;
        //    obj.HKTTTINHID = Convert.ToDecimal(ddlThuongTru_Tinh.SelectedValue);
        //    obj.HKTT = Convert.ToDecimal(ddlThuongTru_Huyen.SelectedValue);
        //    obj.KHTTCHITIET = txtHKTT_Chitiet.Text;

        //    //obj.QUOCTICHID = Convert.ToDecimal(dropQuocTich.SelectedValue);
        //    obj.DANTOCID = Convert.ToDecimal(dropDanToc.SelectedValue);
        //    obj.TONGIAOID = Convert.ToDecimal(dropTonGiao.SelectedValue);
        //    obj.TRINHDOVANHOAID = Convert.ToDecimal(dropTrinhDoVH.SelectedValue);
        //    //obj.TINHTRANGGIAMGIUID = Convert.ToDecimal(dropTinhTrangGiamGiu.SelectedValue);
        //    obj.NGHENGHIEPID = Convert.ToInt32(dropNgheNghiep.SelectedValue);
        //    obj.HOTENBO = Cls_Comon.FormatTenRieng(txtHoTenBo.Text.Trim());
        //    obj.NAMSINHBO = (String.IsNullOrEmpty(txtNamSinhBo.Text + "")) ? 0 : Convert.ToDecimal(txtNamSinhBo.Text.Trim());
        //    obj.HOTENME = Cls_Comon.FormatTenRieng(txtHotenMe.Text.Trim());
        //    obj.NAMSINHME = (String.IsNullOrEmpty(txtNamSinhMe.Text + "")) ? 0 : Convert.ToDecimal(txtNamSinhMe.Text.Trim());

        //    //--------------------------------
        //    obj.ISTREVITHANHNIEN = rdTreViThanhNien.SelectedValue == "" ? 0 : Convert.ToDecimal(rdTreViThanhNien.SelectedValue);
        //    obj.TREMOCOI = rdTreMoCoi.SelectedValue == "" ? 0 : Convert.ToDecimal(rdTreMoCoi.SelectedValue);
        //    obj.TREBOHOC = rdTreBoHoc.SelectedValue == "" ? 0 : Convert.ToDecimal(rdTreBoHoc.SelectedValue);
        //    obj.TRELANGTHANG = rdTreLangThang.SelectedValue == "" ? 0 : Convert.ToDecimal(rdTreLangThang.SelectedValue);
        //    obj.BOMELYHON = rdLyHon.SelectedValue == "" ? 0 : Convert.ToDecimal(rdLyHon.SelectedValue);

        //    obj.TRELANGTHANG = rdTreLangThang.SelectedValue == "" ? 0 : Convert.ToDecimal(rdTreLangThang.SelectedValue);
        //    obj.CONGUOIXUIGIUC = rdNguoiXuiGiuc.SelectedValue == "" ? 0 : Convert.ToDecimal(rdNguoiXuiGiuc.SelectedValue);
        //    obj.NGHIENHUT = rdNGhienHut.SelectedValue == "" ? 0 : Convert.ToDecimal(rdNGhienHut.SelectedValue);
        //    obj.TAIPHAM = rdTinhTrangTaiPham.SelectedValue == "" ? 0 : Convert.ToDecimal(rdTinhTrangTaiPham.SelectedValue);


        //    //--------------------------------
        //    obj.TIENAN = (string.IsNullOrEmpty(txtTienAn.Text + "")) ? 0 : Convert.ToInt32(txtTienAn.Text);
        //    obj.TIENSU = (string.IsNullOrEmpty(txtTienSu.Text + "")) ? 0 : Convert.ToInt32(txtTienSu.Text);

        //    if (lstBidon.Count > 0)
        //    {
        //        obj.NGAYSUA = DateTime.Now;
        //        obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
        //        dt.SaveChanges();
        //    }
        //    else
        //    {
        //        obj.NGAYTAO = DateTime.Now;
        //        obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
        //        dt.XLHC_DUONGSU.Add(obj);
        //        dt.SaveChanges();
        //    }
        //    lstMsgB.Text = "Lưu dữ liệu thành công!";
        //}
        private void SaveBiCao(Decimal DonID)
        {
            // Lấy thông tin người dùng từ Session
            String strUsername = Session[ENUM_SESSION.SESSION_USERNAME] + "";

            // Khởi tạo đối tượng business logic layer
            XLHC_DON_DUONGSU_BL oXLHCBL = new XLHC_DON_DUONGSU_BL();

            // Kiểm tra xem bị can đã tồn tại trong hệ thống chưa
            DataTable dtBiCan = oXLHCBL.XLHC_DUONGSU_GET_BY_DONID_BICANDAUVU(DonID, 1);

            // Chuẩn bị dữ liệu từ form để truyền vào store procedure
            Dictionary<string, object> parameters = new Dictionary<string, object>();

            // Nếu dtBiCan có dữ liệu, lấy thông tin từ record hiện có
            if (dtBiCan != null && dtBiCan.Rows.Count > 0)
            {
                DataRow row = dtBiCan.Rows[0];
                parameters.Add("@DONID", DonID);
                parameters.Add("@MABICAN", row["MABICAN"] != DBNull.Value ? row["MABICAN"].ToString() : "");
                parameters.Add("@BICANDAUVU", 1);
                parameters.Add("@HOTEN", Cls_Comon.FormatTenRieng(txtTenBiCan.Text.Trim()));
                parameters.Add("@TENKHAC", Cls_Comon.FormatTenRieng(txtTenKhac.Text.Trim()));
                parameters.Add("@SODINHDANHCANHAN", txtIdSoDinhDanhCaNhan.Text.Trim());
                parameters.Add("@HOCHIEU", txtIdHoChieu.Text.Trim());
                parameters.Add("@GIOITINH", Convert.ToDecimal(ddlGioitinh.SelectedValue));

                DateTime date_temp;
                date_temp = (String.IsNullOrEmpty(txtNgaysinh.Text.Trim())) ?
                    DateTime.MinValue :
                    DateTime.Parse(this.txtNgaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                parameters.Add("@NGAYSINH", date_temp);

                parameters.Add("@TUOI", txtND_Tuoi.Text == "" ? 0 : Convert.ToDecimal(txtND_Tuoi.Text));
                parameters.Add("@TAMTRUTINHID", Convert.ToDecimal(ddlTamTru_Tinh.SelectedValue));
                parameters.Add("@TAMTRU", Convert.ToDecimal(ddlTamTru_Huyen.SelectedValue));
                parameters.Add("@TAMTRUCHITIET", txtTamtru_Chitiet.Text);
                parameters.Add("@HKTTTINHID", Convert.ToDecimal(ddlThuongTru_Tinh.SelectedValue));
                parameters.Add("@HKTT", Convert.ToDecimal(ddlThuongTru_Huyen.SelectedValue));
                parameters.Add("@KHTTCHITIET", txtHKTT_Chitiet.Text);

                parameters.Add("@DANTOCID", Convert.ToDecimal(dropDanToc.SelectedValue));
                parameters.Add("@TONGIAOID", Convert.ToDecimal(dropTonGiao.SelectedValue));
                parameters.Add("@TRINHDOVANHOAID", Convert.ToDecimal(dropTrinhDoVH.SelectedValue));
                parameters.Add("@NGHENGHIEPID", Convert.ToInt32(dropNgheNghiep.SelectedValue));

                parameters.Add("@HOTENBO", Cls_Comon.FormatTenRieng(txtHoTenBo.Text.Trim()));
                parameters.Add("@NAMSINHBO", (String.IsNullOrEmpty(txtNamSinhBo.Text + "")) ? 0 : Convert.ToDecimal(txtNamSinhBo.Text.Trim()));
                parameters.Add("@HOTENME", Cls_Comon.FormatTenRieng(txtHotenMe.Text.Trim()));
                parameters.Add("@NAMSINHME", (String.IsNullOrEmpty(txtNamSinhMe.Text + "")) ? 0 : Convert.ToDecimal(txtNamSinhMe.Text.Trim()));

                parameters.Add("@ISTREVITHANHNIEN", rdTreViThanhNien.SelectedValue == "" ? 0 : Convert.ToDecimal(rdTreViThanhNien.SelectedValue));
                parameters.Add("@TREMOCOI", rdTreMoCoi.SelectedValue == "" ? 0 : Convert.ToDecimal(rdTreMoCoi.SelectedValue));
                parameters.Add("@TREBOHOC", rdTreBoHoc.SelectedValue == "" ? 0 : Convert.ToDecimal(rdTreBoHoc.SelectedValue));
                parameters.Add("@TRELANGTHANG", rdTreLangThang.SelectedValue == "" ? 0 : Convert.ToDecimal(rdTreLangThang.SelectedValue));
                parameters.Add("@BOMELYHON", rdLyHon.SelectedValue == "" ? 0 : Convert.ToDecimal(rdLyHon.SelectedValue));
                parameters.Add("@CONGUOIXUIGIUC", rdNguoiXuiGiuc.SelectedValue == "" ? 0 : Convert.ToDecimal(rdNguoiXuiGiuc.SelectedValue));
                parameters.Add("@NGHIENHUT", rdNGhienHut.SelectedValue == "" ? 0 : Convert.ToDecimal(rdNGhienHut.SelectedValue));
                parameters.Add("@TAIPHAM", rdTinhTrangTaiPham.SelectedValue == "" ? 0 : Convert.ToDecimal(rdTinhTrangTaiPham.SelectedValue));

                parameters.Add("@TIENAN", (string.IsNullOrEmpty(txtTienAn.Text + "")) ? 0 : Convert.ToInt32(txtTienAn.Text));
                parameters.Add("@TIENSU", (string.IsNullOrEmpty(txtTienSu.Text + "")) ? 0 : Convert.ToInt32(txtTienSu.Text));
                // VNPT- Lê Bá Thọ thêm TOA_GIAIQUYET_ID để hiển thị nút sửa 10-10-2025
                parameters.Add("@TOA_GIAIQUYET_ID", Session[ENUM_SESSION.SESSION_DONVIID] == null ? (object)DBNull.Value : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                // Trường hợp cập nhật - giữ nguyên người tạo và ngày tạo, cập nhật người sửa và ngày sửa
                parameters.Add("@NGAYSUA", DateTime.Now);
                parameters.Add("@NGUOISUA", strUsername);
                parameters.Add("@NGAYTAO", row["NGAYTAO"]);
                parameters.Add("@NGUOITAO", row["NGUOITAO"]);
                parameters.Add("@ACTION", "UPDATE");
            }
            else
            {
                // Trường hợp thêm mới
                parameters.Add("@DONID", DonID);
                parameters.Add("@MABICAN", "");
                parameters.Add("@BICANDAUVU", 1);
                parameters.Add("@HOTEN", Cls_Comon.FormatTenRieng(txtTenBiCan.Text.Trim()));
                parameters.Add("@TENKHAC", Cls_Comon.FormatTenRieng(txtTenKhac.Text.Trim()));
                parameters.Add("@SODINHDANHCANHAN", txtIdSoDinhDanhCaNhan.Text.Trim());
                parameters.Add("@HOCHIEU", txtIdHoChieu.Text.Trim());
                parameters.Add("@GIOITINH", Convert.ToDecimal(ddlGioitinh.SelectedValue));

                DateTime date_temp;
                date_temp = (String.IsNullOrEmpty(txtNgaysinh.Text.Trim())) ?
                    DateTime.MinValue :
                    DateTime.Parse(this.txtNgaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                parameters.Add("@NGAYSINH", date_temp);

                parameters.Add("@TUOI", txtND_Tuoi.Text == "" ? 0 : Convert.ToDecimal(txtND_Tuoi.Text));
                parameters.Add("@TAMTRUTINHID", Convert.ToDecimal(ddlTamTru_Tinh.SelectedValue));
                parameters.Add("@TAMTRU", Convert.ToDecimal(ddlTamTru_Huyen.SelectedValue));
                parameters.Add("@TAMTRUCHITIET", txtTamtru_Chitiet.Text);
                parameters.Add("@HKTTTINHID", Convert.ToDecimal(ddlThuongTru_Tinh.SelectedValue));
                parameters.Add("@HKTT", Convert.ToDecimal(ddlThuongTru_Huyen.SelectedValue));
                parameters.Add("@KHTTCHITIET", txtHKTT_Chitiet.Text);

                parameters.Add("@DANTOCID", Convert.ToDecimal(dropDanToc.SelectedValue));
                parameters.Add("@TONGIAOID", Convert.ToDecimal(dropTonGiao.SelectedValue));
                parameters.Add("@TRINHDOVANHOAID", Convert.ToDecimal(dropTrinhDoVH.SelectedValue));
                parameters.Add("@NGHENGHIEPID", Convert.ToInt32(dropNgheNghiep.SelectedValue));

                parameters.Add("@HOTENBO", Cls_Comon.FormatTenRieng(txtHoTenBo.Text.Trim()));
                parameters.Add("@NAMSINHBO", (String.IsNullOrEmpty(txtNamSinhBo.Text + "")) ? 0 : Convert.ToDecimal(txtNamSinhBo.Text.Trim()));
                parameters.Add("@HOTENME", Cls_Comon.FormatTenRieng(txtHotenMe.Text.Trim()));
                parameters.Add("@NAMSINHME", (String.IsNullOrEmpty(txtNamSinhMe.Text + "")) ? 0 : Convert.ToDecimal(txtNamSinhMe.Text.Trim()));

                parameters.Add("@ISTREVITHANHNIEN", rdTreViThanhNien.SelectedValue == "" ? 0 : Convert.ToDecimal(rdTreViThanhNien.SelectedValue));
                parameters.Add("@TREMOCOI", rdTreMoCoi.SelectedValue == "" ? 0 : Convert.ToDecimal(rdTreMoCoi.SelectedValue));
                parameters.Add("@TREBOHOC", rdTreBoHoc.SelectedValue == "" ? 0 : Convert.ToDecimal(rdTreBoHoc.SelectedValue));
                parameters.Add("@TRELANGTHANG", rdTreLangThang.SelectedValue == "" ? 0 : Convert.ToDecimal(rdTreLangThang.SelectedValue));
                parameters.Add("@BOMELYHON", rdLyHon.SelectedValue == "" ? 0 : Convert.ToDecimal(rdLyHon.SelectedValue));
                parameters.Add("@CONGUOIXUIGIUC", rdNguoiXuiGiuc.SelectedValue == "" ? 0 : Convert.ToDecimal(rdNguoiXuiGiuc.SelectedValue));
                parameters.Add("@NGHIENHUT", rdNGhienHut.SelectedValue == "" ? 0 : Convert.ToDecimal(rdNGhienHut.SelectedValue));
                parameters.Add("@TAIPHAM", rdTinhTrangTaiPham.SelectedValue == "" ? 0 : Convert.ToDecimal(rdTinhTrangTaiPham.SelectedValue));

                parameters.Add("@TIENAN", (string.IsNullOrEmpty(txtTienAn.Text + "")) ? 0 : Convert.ToInt32(txtTienAn.Text));
                parameters.Add("@TIENSU", (string.IsNullOrEmpty(txtTienSu.Text + "")) ? 0 : Convert.ToInt32(txtTienSu.Text));
                // VNPT- Lê Bá Thọ thêm TOA_GIAIQUYET_ID để hiển thị nút sửa 10-10-2025
                parameters.Add("@TOA_GIAIQUYET_ID",Session[ENUM_SESSION.SESSION_DONVIID] == null? (object)DBNull.Value : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                parameters.Add("@NGAYSUA", DBNull.Value);
                parameters.Add("@NGUOISUA", DBNull.Value);
                parameters.Add("@NGAYTAO", DateTime.Now);
                parameters.Add("@NGUOITAO", strUsername);
                parameters.Add("@ACTION", "INSERT");
            }

            // Gọi thủ tục lưu trữ
            int result = oXLHCBL.XLHC_DUONGSU_SAVE(parameters);

            // Hiển thị thông báo kết quả
            if (result > 0)
            {
                lstMsgB.Text = "Lưu dữ liệu thành công!";
            }
            else
            {
                lstMsgB.Text = "Có lỗi xảy ra khi lưu dữ liệu!";
            }
        }


        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            if (SaveData())
            {
                lstMsgT.Text = lstMsgB.Text = "Lưu thông tin hồ sơ thành công !";


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
                    oNSD.IDBPXLHC = IDVuViec;
                    dt.SaveChanges();
                }
                Session[ENUM_LOAIAN.BPXLHC] = IDVuViec;
                Response.Redirect("Thongtindon.aspx");
                // Cls_Comon.ShowMessageAndRedirect(this, this.GetType(), "MsgDSDON", "Lưu thông tin thành công, tiếp theo hãy chọn chức năng khác cần thao tác trong danh sách bên trái !", Cls_Comon.GetRootURL() + "/Trangchu.aspx");
            }
        }
        protected void cmdUpdateAndNew_Click(object sender, EventArgs e)
        {
            if (SaveData())
            {
                ResetControls();
                lstMsgT.Text = lstMsgB.Text = "Hoàn thành Lưu, bạn hãy nhập thông tin hồ sơ tiếp theo !";

            }
        }
        protected void cmdQuaylai_Click(object sender, EventArgs e)
        {
            Response.Redirect("Danhsach.aspx");
        }

        protected void txtNgaysinh_TextChanged(object sender, EventArgs e)
        {
            if (!String.IsNullOrEmpty(txtNgaysinh.Text))
            {
                DateTime date_temp;
                date_temp = (String.IsNullOrEmpty(txtNgaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (date_temp != DateTime.MinValue)
                {
                    txtNamSinh.Text = date_temp.Year + "";
                    //Tính tuổi 
                    DateTime dNgayNhan = (String.IsNullOrEmpty(txtNgayNhan.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    if (dNgayNhan != DateTime.MinValue)
                    {
                        txtND_Tuoi.Text = (dNgayNhan.Year - date_temp.Year).ToString();
                    }
                }
            }
            txtND_Tuoi.Focus();
        }
        protected void rdTreViThanhNien_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdTreViThanhNien.SelectedValue == "1")
                pnTreViThanhNien.Visible = true;
            else
                pnTreViThanhNien.Visible = false;
        }
        protected void dropQuocTich_SelectedIndexChanged(object sender, EventArgs e) { }
        private void LoadDropTinh()
        {
            ddlThuongTru_Tinh.Items.Clear();
            ddlTamTru_Tinh.Items.Clear();
            ddlTinh_CQDN.Items.Clear();
            List<DM_HANHCHINH> lstTinh = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == ROOT).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstTinh != null && lstTinh.Count > 0)
            {
                ddlThuongTru_Tinh.DataSource = lstTinh;
                ddlThuongTru_Tinh.DataTextField = "TEN";
                ddlThuongTru_Tinh.DataValueField = "ID";
                ddlThuongTru_Tinh.DataBind();

                ddlTamTru_Tinh.DataSource = lstTinh;
                ddlTamTru_Tinh.DataTextField = "TEN";
                ddlTamTru_Tinh.DataValueField = "ID";
                ddlTamTru_Tinh.DataBind();

                ddlTinh_CQDN.DataSource = lstTinh;
                ddlTinh_CQDN.DataTextField = "TEN";
                ddlTinh_CQDN.DataValueField = "ID";
                ddlTinh_CQDN.DataBind();
            }
            ddlThuongTru_Tinh.Items.Insert(0, new ListItem("---Chọn---", "0"));
            ddlTamTru_Tinh.Items.Insert(0, new ListItem("---Chọn---", "0"));
            ddlTinh_CQDN.Items.Insert(0, new ListItem("---Chọn---", "0"));
            LoadDropThuongTru_Huyen();
            LoadDropTamTru_Huyen();
            LoadDropHuyen_CQDN();
        }
        private void LoadDropThuongTru_Huyen()
        {
            ddlThuongTru_Huyen.Items.Clear();
            decimal TinhID = Convert.ToDecimal(ddlThuongTru_Tinh.SelectedValue);
            if (TinhID == 0)
            {
                ddlThuongTru_Huyen.Items.Add(new ListItem("---Chọn---", "0"));
                return;
            }
            List<DM_HANHCHINH> lstHuyen = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == TinhID).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstHuyen != null && lstHuyen.Count > 0)
            {
                ddlThuongTru_Huyen.DataSource = lstHuyen;
                ddlThuongTru_Huyen.DataTextField = "TEN";
                ddlThuongTru_Huyen.DataValueField = "ID";
                ddlThuongTru_Huyen.DataBind();
            }
            ddlThuongTru_Huyen.Items.Insert(0, new ListItem("---Chọn---", "0"));
        }
        private void LoadDropTamTru_Huyen()
        {
            ddlTamTru_Huyen.Items.Clear();
            decimal TinhID = Convert.ToDecimal(ddlTamTru_Tinh.SelectedValue);
            if (TinhID == 0)
            {
                ddlTamTru_Huyen.Items.Add(new ListItem("---Chọn---", "0"));
                return;
            }
            List<DM_HANHCHINH> lstHuyen = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == TinhID).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstHuyen != null && lstHuyen.Count > 0)
            {
                ddlTamTru_Huyen.DataSource = lstHuyen;
                ddlTamTru_Huyen.DataTextField = "TEN";
                ddlTamTru_Huyen.DataValueField = "ID";
                ddlTamTru_Huyen.DataBind();
            }
            ddlTamTru_Huyen.Items.Insert(0, new ListItem("---Chọn---", "0"));
        }
        private void LoadDropHuyen_CQDN()
        {
            ddlHuyen_CQDN.Items.Clear();
            decimal TinhID = Convert.ToDecimal(ddlTinh_CQDN.SelectedValue);
            if (TinhID == 0)
            {
                ddlHuyen_CQDN.Items.Add(new ListItem("---Chọn---", "0"));
                return;
            }
            List<DM_HANHCHINH> lstHuyen = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == TinhID).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstHuyen != null && lstHuyen.Count > 0)
            {
                ddlHuyen_CQDN.DataSource = lstHuyen;
                ddlHuyen_CQDN.DataTextField = "TEN";
                ddlHuyen_CQDN.DataValueField = "ID";
                ddlHuyen_CQDN.DataBind();
            }
            ddlHuyen_CQDN.Items.Insert(0, new ListItem("---Chọn---", "0"));
        }
        protected void ddlTinh_CQDN_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDropHuyen_CQDN();
                Cls_Comon.SetFocus(this, this.GetType(), ddlHuyen_CQDN.ClientID);
            }
            catch (Exception ex) { lstMsgT.Text = lstMsgB.Text = ex.Message; }
        }
        protected void ddlThuongTru_Tinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDropThuongTru_Huyen();
                Cls_Comon.SetFocus(this, this.GetType(), ddlThuongTru_Huyen.ClientID);
            }
            catch (Exception ex) { lstMsgT.Text = lstMsgB.Text = ex.Message; }
        }
        protected void ddlTamTru_Tinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDropTamTru_Huyen();
                Cls_Comon.SetFocus(this, this.GetType(), ddlTamTru_Huyen.ClientID);
            }
            catch (Exception ex) { lstMsgT.Text = lstMsgB.Text = ex.Message; }
        }
        protected void rblChonNguonThongTin_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rblChonNguonThongTin.SelectedValue == "0") // "Không"
            {
                txtIdSoDinhDanhCaNhan.Enabled = false;
                txtIdSoDinhDanhCaNhan.Text = ""; // Xóa dữ liệu nếu đã nhập
            }
            else // "Có"
            {
                txtIdSoDinhDanhCaNhan.Enabled = true;
            }
        }
        protected void ddlThamphankynhandon_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {

            }
            catch (Exception ex) { lstMsgT.Text = lstMsgB.Text = ex.Message; }
        }
    }
}