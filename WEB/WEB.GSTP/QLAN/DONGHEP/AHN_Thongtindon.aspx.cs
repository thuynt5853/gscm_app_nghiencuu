using BL.GSTP;
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

namespace WEB.GSTP.QLAN.DONGHEP
{
    public partial class AHN_Thongtindon : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private const decimal ROOT = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["DONGHEPID"] != "")
                {
                    cmdUpdateAndNewB.Visible = false;
                }
                txtGhichu.Visible = false;
                txtNguoiNop.Visible = false;
                txtNguoiNopDocLap.Visible = false;
                lbNoidung.Text = "Nội dung khởi kiện";

                txtNgayNhan.Text = DateTime.Now.ToString("dd/MM/yyyy");
                LoadCombobox();
                LoadNguoibiKhangCao();
                string current_id = Request["ID"] + "";
                string strtype = Request["type"] + "";
                LoadLoaiDon(false);
                string strDonID = Session["HN_THEMDSK"] + "";
                if (strtype == "new")
                {
                    if (strDonID != "")
                    {
                        hddID.Value = Session["HN_THEMDSK"] + "";
                        decimal ID = Convert.ToDecimal(Session["HN_THEMDSK"]);
                        LoadInfo(ID);
                    }
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
                    string DonghepId = Request["DONGHEPID"] + "";
                    if (!string.IsNullOrEmpty(DonghepId))
                    {
                        hddID.Value = DonghepId.ToString();
                        decimal ID = Convert.ToDecimal(DonghepId);
                        LoadInfo(ID);

                    }
                    else
                    {
                        current_id = Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] + "";
                        if (string.IsNullOrEmpty(current_id))
                        {
                            Response.Redirect("/Trangchu.aspx");
                            Response.End();
                        }
                        decimal IdDon = Convert.ToDecimal(current_id);
                        AHN_DON oT = dt.AHN_DON.Where(x => x.ID == IdDon).FirstOrDefault();
                        txtQuanhephapluat_name(oT);
                        if (oT.QHPLTKID != null)
                            ddlQHPLTK.SelectedValue = oT.QHPLTKID.ToString();

                    }
                    ddlQHPLTK.Enabled = false;
                    txtQuanhephapluat.Enabled = false;
                }
                if (hddID.Value != "" && hddID.Value != "0")
                {

                }
                else
                    SetTinhHuyenMacDinh();
                ddlHinhthucnhandon.Focus();

                ltCMNDND.Text = "<span style='color:red'>(*)</span>";
                ltCMNDBD.Text = "<span style='color:red'>(*)</span>";
            }
        }

        void LoadNguoibiKhangCao()
        {
            int DONID = Convert.ToInt32(Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH]);
            txtNguoiNop.Items.Clear();
            txtNguoiNop.Items.Clear();
            List<AHN_DON_DUONGSU> listycPhanto = dt.AHN_DON_DUONGSU.Where(x => x.DONID == DONID && x.TUCACHTOTUNG_MA == "BIDON").OrderBy(x => x.TENDUONGSU).ToList<AHN_DON_DUONGSU>();
            List<AHN_DON_DUONGSU> listycDocLap = dt.AHN_DON_DUONGSU.Where(x => x.DONID == DONID && x.TUCACHTOTUNG_MA == "QUYENNVLQ").OrderBy(x => x.TENDUONGSU).ToList<AHN_DON_DUONGSU>();
            if (listycPhanto != null)
            {
                int count_item = listycPhanto.Count;
                if (count_item > 0)
                {
                    txtNguoiNop.DataSource = listycPhanto;
                    txtNguoiNop.DataTextField = "TENDUONGSU";
                    txtNguoiNop.DataValueField = "ID";
                    txtNguoiNop.DataBind();
                }
            }
            else
                txtNguoiNop.Items.Add(new ListItem("--- Chọn ---", "0"));

            if (listycDocLap != null)
            {
                int count_item = listycDocLap.Count;
                if (count_item > 0)
                {
                    txtNguoiNopDocLap.DataSource = listycDocLap;
                    txtNguoiNopDocLap.DataTextField = "TENDUONGSU";
                    txtNguoiNopDocLap.DataValueField = "ID";
                    txtNguoiNopDocLap.DataBind();
                }
            }
            else
                txtNguoiNopDocLap.Items.Add(new ListItem("--- Chọn ---", "0"));
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
            DON_CHITIET oT = dt.DON_CHITIET.Where(x => x.ID == ID && x.LOAIANID == 3).FirstOrDefault();
            AHN_DON obj = dt.AHN_DON.Where(x => x.ID == oT.DONID).FirstOrDefault();
            txtMaVuViec.Text = obj.MAVUVIEC;
            txtTenVuViec.Text = obj.TENVUVIEC;
            if (oT.HINHTHUCNHANDON == 3)
                LoadLoaiDon(true);
            else
                LoadLoaiDon(false);
            ddlHinhthucnhandon.SelectedValue = oT.HINHTHUCNHANDON.ToString();
            if (oT.NGAYVIETDON != DateTime.MinValue && oT.NGAYVIETDON != null) txtNgayViet.Text = ((DateTime)oT.NGAYVIETDON).ToString("dd/MM/yyyy", cul);
            if (oT.NGAYNHANDON != DateTime.MinValue && oT.NGAYNHANDON != null) txtNgayNhan.Text = ((DateTime)oT.NGAYNHANDON).ToString("dd/MM/yyyy", cul);
            ddlLoaiQuanhe.SelectedValue = obj.LOAIQUANHE.ToString();
            chkKhongCoNYC2.Visible = obj.LOAIQUANHE == 1 ? false : true;
            txtQuanhephapluat_name(obj);
            if (obj.QHPLTKID != null)
                ddlQHPLTK.SelectedValue = obj.QHPLTKID.ToString();
            //Kiểm tra ẩn/hiện lý do ly hôn
            DM_DATAITEM oTItem = dt.DM_DATAITEM.Where(x => x.ID == obj.QUANHEPHAPLUATID).FirstOrDefault();
            trLydoLyhon.Visible = false;

            DM_QHPL_TK oDMTCT = dt.DM_QHPL_TK.Where(x => x.ID == obj.QHPLTKID).FirstOrDefault();
            if (oDMTCT != null)
                if (oDMTCT.ARRSAPXEP.Contains("0/1042"))
                {
                    trLydoLyhon.Visible = true;
                    txtSoconchuathanhnien.Text = obj.SOCONCHUATHANHNIEN == null ? "" : obj.SOCONCHUATHANHNIEN.ToString();
                    txtSoconduoi7tuoi.Text = obj.SOCONDUOI7TUOI == null ? "" : obj.SOCONDUOI7TUOI.ToString();
                }

            if (ddlCanbonhandon.Items.FindByValue(oT.CANBONHANDONID + "") != null)
                ddlCanbonhandon.SelectedValue = oT.CANBONHANDONID + "";
            if (ddlThamphankynhandon.Items.FindByValue(oT.THAMPHANKYNHANDON + "") != null)
                ddlThamphankynhandon.SelectedValue = oT.THAMPHANKYNHANDON + "";
            ddlYeutonuocngoai.SelectedValue = oT.YEUTONUOCNGOAI.ToString();
            txtGhichu.Text = oT.GHICHU;
            txtDonkiencuanguoikhac.Text = obj.DONKIENCUANGUOIKHAC;
            ddlLoaidon.SelectedValue = oT.LOAIDON.ToString();
            txtNoidungkhoikien.Text = oT.NOIDUNGKHOIKIEN;
            var loaiDon = oT.LOAIDON.ToString();
            if (loaiDon == "8")
            {
                pnDuongSuChiTiet.Visible = false;
                pnTTDuongSu.Visible = false;
                lbNoidung.Text = "Nội dung phản tố";
                lbTenNguoiPhanTo.Text = "Tên người yêu cầu phản tố <span class='batbuoc'>(*)</span>";
                txtNguoiNop.Visible = true;
                txtNguoiNopDocLap.Visible = false;
                lbTenNguoiPhanTo.Visible = true;
                try
                {
                    List<DON_DUONGSU_CHITIET> oListDs = dt.DON_DUONGSU_CHITIET.Where(x => x.DONCHITIETID == ID).ToList();
                    for (int i = 0; i < oListDs.Count; i++)
                    {
                        txtNguoiNop.Items.FindByValue(oListDs[i].DUONGSUID.ToString()).Selected = true;
                    }
                }
                catch { }
            }
            else if (loaiDon == "9")
            {
                pnDuongSuChiTiet.Visible = false;
                pnTTDuongSu.Visible = false;
                lbNoidung.Text = "Nội dung độc lập";
                lbTenNguoiPhanTo.Text = "Tên người yêu cầu độc lập <span class='batbuoc'>(*)</span>";
                txtNguoiNopDocLap.Visible = true;
                txtNguoiNop.Visible = false;
                lbTenNguoiPhanTo.Visible = true;
                txtGhichu.Visible = true;
                lbGhiChu.Visible = true;
                lbGhiChu.Text = "Ghi chú";
                try
                {
                    List<DON_DUONGSU_CHITIET> oListDs = dt.DON_DUONGSU_CHITIET.Where(x => x.DONCHITIETID == ID).ToList();
                    for (int i = 0; i < oListDs.Count; i++)
                    {
                        txtNguoiNopDocLap.Items.FindByValue(oListDs[i].DUONGSUID.ToString()).Selected = true;
                    }
                }
                catch { }
            }
            else
            {
                pnDuongSuChiTiet.Visible = true;
                pnTTDuongSu.Visible = true;
                lbNoidung.Text = "Nội dung khởi kiện";
                txtNguoiNop.Visible = false;
                txtNguoiNopDocLap.Visible = false;
                lbTenNguoiPhanTo.Visible = false;
            }

            //Load Nguyên đơn
            #region "NGUYÊN ĐƠN ĐẠI DIỆN"
            //List<DON_CHITIET_DUONGSU> lstNguyendon = dt.DON_CHITIET_DUONGSU.Where(x => x.DONID == oT.ID && x.LOAIANID == 3 && x.ISDAIDIEN == 1 && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON).ToList();
            DM_HANHCHINH_BL oHCBL = new DM_HANHCHINH_BL();
            AHN_DON_DUONGSU oND = null;
            AHN_DON_DUONGSU oBD = null;
            if (oT.LOAIDON != 8 && oT.LOAIDON != 9)
            {
                List<DON_DUONGSU_CHITIET> oListDs = dt.DON_DUONGSU_CHITIET.Where(x => x.DONCHITIETID == ID).ToList();
                for (int i = 0; i < oListDs.Count; i++)
                {
                    int IDduongSu = Convert.ToInt32(oListDs[i].DUONGSUID);
                    AHN_DON_DUONGSU Ods = dt.AHN_DON_DUONGSU.Where(x => x.ID == IDduongSu).FirstOrDefault();
                    if (Ods != null)
                    {
                        if (Ods.TUCACHTOTUNG_MA == "NGUYENDON" && Ods.ISDAIDIEN_DONCHITIET == 1)
                        {
                            oND = dt.AHN_DON_DUONGSU.Where(x => x.ID == IDduongSu).FirstOrDefault();
                        }
                        if (Ods.TUCACHTOTUNG_MA == "BIDON" && Ods.ISDAIDIEN_DONCHITIET == 1)
                        {
                            oBD = dt.AHN_DON_DUONGSU.Where(x => x.ID == IDduongSu).FirstOrDefault();
                        }
                    }


                }


                if (oListDs.Count > 0)
                {
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
                    ddlListDuongSu.SelectedValue = oND.ID.ToString();
                    txtND_NoiLamViec.Text = oND.DIACHICOQUAN + "";
                    if (oND.NGAYSINH != DateTime.MinValue && oND.NGAYSINH != null) txtND_Ngaysinh.Text = ((DateTime)oND.NGAYSINH).ToString("dd/MM/yyyy", cul);

                    txtND_Namsinh.Text = oND.NAMSINH == 0 ? "" : oND.NAMSINH.ToString();
                    txtND_Tuoi.Text = oND.TUOI == 0 ? "" : oND.TUOI.ToString();
                    ddlND_Gioitinh.SelectedValue = oND.GIOITINH.ToString();
                    txtND_NDD_Ten.Text = oND.NGUOIDAIDIEN;
                    txtND_NDD_Chucvu.Text = oND.CHUCVU;
                    if (oND.SOCMND == null)
                    {
                        chkBoxCMNDND.Checked = true;
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
                        //lblND_Batbuoc1.Text = 
                        lblND_Batbuoc2.Text = "";
                    }
                    else
                    {
                        //lblND_Batbuoc1.Text =
                        lblND_Batbuoc2.Text = "(*)";
                    }
                    if (oND.TENDUONGSU != null) txtTennguyendon.Enabled = false; else txtTennguyendon.Enabled = true;
                    if (oND.LOAIDUONGSU != null)
                    {
                        ddlLoaiNguyendon.Enabled = false;
                    }
                    else
                    {
                        ddlLoaiNguyendon.Enabled = true;
                    }
                    txtND_CMND.Enabled = false;
                    chkBoxCMNDND.Enabled = false;
                    if (oND.LOAIDUONGSU == 1)
                    {
                        if (oND.GIOITINH != null) ddlND_Gioitinh.Enabled = false; else ddlND_Gioitinh.Enabled = true;
                        if (oND.NGAYSINH != null && oND.NGAYSINH != DateTime.MinValue) txtND_Ngaysinh.Enabled = false; else txtND_Ngaysinh.Enabled = true;
                        if (oND.NAMSINH != null && oND.NAMSINH != 0) txtND_Namsinh.Enabled = false; else txtND_Namsinh.Enabled = true;
                        if (oND.TAMTRUTINHID != null && oND.TAMTRUTINHID != 0) ddlTamTru_Tinh_NguyenDon.Enabled = false; else ddlTamTru_Tinh_NguyenDon.Enabled = true;
                        if (oND.TAMTRUID != null && oND.TAMTRUID != 0) ddlTamTru_Huyen_NguyenDon.Enabled = false; else ddlTamTru_Huyen_NguyenDon.Enabled = true;
                        if (oND.TAMTRUCHITIET != null) txtND_TTChitiet.Enabled = false; else txtND_TTChitiet.Enabled = true;
                        if (oND.DIACHICOQUAN != null) txtND_NoiLamViec.Enabled = false; else txtND_NoiLamViec.Enabled = true;
                    }
                    if (oND.LOAIDUONGSU == 2 || oND.LOAIDUONGSU == 3)
                    {
                        if (oND.TAMTRUTINHID != null && oND.TAMTRUTINHID != 0) ddlNDD_Tinh_NguyenDon.Enabled = false; else ddlNDD_Tinh_NguyenDon.Enabled = true;
                        if (oND.NDD_DIACHIID != null && oND.NDD_DIACHIID != 0) ddlNDD_Huyen_NguyenDon.Enabled = false; else ddlNDD_Huyen_NguyenDon.Enabled = true;
                        if (oND.NDD_DIACHICHITIET != null) txtND_NDD_Diachichitiet.Enabled = false; else txtND_NDD_Diachichitiet.Enabled = true;
                        if (oND.NGUOIDAIDIEN != null) txtND_NDD_Ten.Enabled = false; else txtND_NDD_Ten.Enabled = true;
                        if (oND.CHUCVU != null) txtND_NDD_Chucvu.Enabled = false; else txtND_NDD_Chucvu.Enabled = true;
                    }
                    if (oND.EMAIL != null) txtND_Email.Enabled = false; else txtND_Email.Enabled = true;
                    if (oND.DIENTHOAI != null) txtND_Dienthoai.Enabled = false; else txtND_Dienthoai.Enabled = true;
                    if (oND.FAX != null) txtND_Fax.Enabled = false; else txtND_Fax.Enabled = true;
                    if (oND.QUOCTICHID != null && oND.QUOCTICHID != 0) ddlND_Quoctich.Enabled = false; else ddlND_Quoctich.Enabled = true;

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

                    txtBD_Ten.Text = oBD.TENDUONGSU;

                    ddlLoaiBidon.SelectedValue = oBD.LOAIDUONGSU.ToString();
                    txtBD_CMND.Text = oBD.SOCMND;
                    ddlBD_Quoctich.SelectedValue = oBD.QUOCTICHID.ToString();
                    DropDownListDuongSu.SelectedValue = oBD.ID.ToString();
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
                    if (oBD.SOCMND == null)
                    {
                        chkBoxCMNDBD.Checked = true;
                    }
                    txtBD_Namsinh.Text = oBD.NAMSINH == 0 ? "" : oBD.NAMSINH.ToString();
                    txtBD_Tuoi.Text = oBD.TUOI == 0 ? "" : oBD.TUOI.ToString();
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
                        //lblBD_Batbuoc1.Text = 
                        //lblBD_Batbuoc2.Text = "";
                        chkBD_ONuocNgoai.Visible = false;
                    }
                    else
                    {
                        //lblBD_Batbuoc1.Text =
                        //lblBD_Batbuoc2.Text = "(*)";
                        chkBD_ONuocNgoai.Visible = true;
                    }
                    //if (chkBD_ONuocNgoai.Checked)
                    //{
                    //    // lblBD_Batbuoc1.Text = 
                    //    lblBD_Batbuoc2.Text = "";
                    //}
                    //else
                    //{
                    //    //  lblBD_Batbuoc1.Text =
                    //    lblBD_Batbuoc2.Text = "(*)";
                    //}
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
                    if (oBD.TENDUONGSU != null) txtBD_Ten.Enabled = false; else txtBD_Ten.Enabled = true;
                    if (oBD.LOAIDUONGSU != null) ddlLoaiBidon.Enabled = false; else ddlLoaiBidon.Enabled = true;
                    txtBD_CMND.Enabled = false;
                    chkBoxCMNDBD.Enabled = false;
                    if (oBD.LOAIDUONGSU == 1)
                    {
                        if (oBD.GIOITINH != null) ddlBD_Gioitinh.Enabled = false; else ddlBD_Gioitinh.Enabled = true;
                        if (oBD.NGAYSINH != null && oBD.NGAYSINH != DateTime.MinValue) txtBD_Ngaysinh.Enabled = false; else txtBD_Ngaysinh.Enabled = true;
                        if (oBD.NAMSINH != null && oBD.NAMSINH != 0) txtBD_Namsinh.Enabled = false; else txtBD_Namsinh.Enabled = true;
                        if (oBD.TAMTRUTINHID != null && oBD.TAMTRUTINHID != 0) ddlTamTru_Tinh_BiDon.Enabled = false; else ddlTamTru_Tinh_BiDon.Enabled = true;
                        if (oBD.TAMTRUID != null && oBD.TAMTRUID != 0) ddlTamTru_Huyen_BiDon.Enabled = false; else ddlTamTru_Huyen_BiDon.Enabled = true;
                        if (oBD.TAMTRUCHITIET != null) txtBD_Tamtru_Chitiet.Enabled = false; else txtBD_Tamtru_Chitiet.Enabled = true;
                        if (oBD.DIACHICOQUAN != null) txtBD_NoiLamViec.Enabled = false; else txtBD_NoiLamViec.Enabled = true;
                    }
                    if (oBD.LOAIDUONGSU == 2 || oBD.LOAIDUONGSU == 3)
                    {
                        if (oBD.TAMTRUTINHID != null && oBD.TAMTRUTINHID != 0) ddlNDD_Tinh_BiDon.Enabled = false; else ddlNDD_Tinh_BiDon.Enabled = true;
                        if (oBD.NDD_DIACHIID != null && oBD.NDD_DIACHIID != 0) ddlNDD_Huyen_BiDon.Enabled = false; else ddlNDD_Huyen_BiDon.Enabled = true;
                        if (oBD.NDD_DIACHICHITIET != null) txtBD_NDD_Diachichitiet.Enabled = false; else txtBD_NDD_Diachichitiet.Enabled = true;
                        if (oBD.NGUOIDAIDIEN != null) txtBD_NDD_ten.Enabled = false; else txtBD_NDD_ten.Enabled = true;
                        if (oBD.CHUCVU != null) txtBD_NDD_Chucvu.Enabled = false; else txtBD_NDD_Chucvu.Enabled = true;
                    }
                    if (oBD.EMAIL != null) txtBD_Email.Enabled = false; else txtBD_Email.Enabled = true;
                    if (oBD.DIENTHOAI != null) txtBD_Dienthoai.Enabled = false; else txtBD_Dienthoai.Enabled = true;
                    if (oBD.FAX != null) txtBD_Fax.Enabled = false; else txtBD_Fax.Enabled = true;
                    if (oBD.QUOCTICHID != null) ddlBD_Quoctich.Enabled = false; else ddlBD_Quoctich.Enabled = true;
                }
                else
                {
                    chkKhongCoNYC2.Checked = true;
                    SetEnableNYC2(false);
                }
            }
            #endregion
        }
        private bool CheckValid()
        {
            if (txtQuanhephapluat.Text == null || txtQuanhephapluat.Text == "")
            {
                lstMsgB.Text = "Chưa nhập quan hệ pháp luật.";
                txtQuanhephapluat.Focus();
                return false;
            }
            if (txtQuanhephapluat.Text.Trim().Length >= 500)
            {
                lstMsgB.Text = "Quan hệ pháp luật nhập quá dài.";
                txtQuanhephapluat.Focus();
                return false;
            }
            if (txtNgayNhan.Text == "")
            {
                lstMsgB.Text = "Chưa nhập ngày nhận đơn";
                txtNgayNhan.Focus();
                return false;
            }
            #region Thiều
            if (ddlLoaidon.SelectedValue != "8" && ddlLoaidon.SelectedValue != "9")
            {
                if (!chkBoxCMNDND.Checked)
                {
                    if (string.IsNullOrEmpty(txtND_CMND.Text))
                    {
                        lstMsgB.Text = "Bạn chưa nhập Số CMND/ Thẻ căn cước/ Hộ chiếu.";
                        txtND_CMND.Focus();
                        return false;
                    }

                }

                if (!chkBoxCMNDBD.Checked)
                {
                    if (string.IsNullOrEmpty(txtBD_CMND.Text))
                    {
                        lstMsgB.Text = "Bạn chưa nhập Số CMND/ Thẻ căn cước/ Hộ chiếu.";
                        txtBD_CMND.Focus();
                        return false;
                    }

                }
                #endregion
                DateTime dNgayNhan = (String.IsNullOrEmpty(txtNgayNhan.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (dNgayNhan > DateTime.Now)
                {
                    lstMsgB.Text = "Ngày nhận đơn không được lớn hơn ngày hiện tại !";
                    txtNgayNhan.Focus();
                    return false;
                }
                if (ddlQHPLTK.SelectedIndex == 0)
                {
                    lstMsgB.Text = "Chưa chọn quan hệ pháp luật dùng thống kê";
                    Cls_Comon.SetFocus(this, this.GetType(), ddlQHPLTK.ClientID);
                    return false;
                }
                decimal IDChitieuTK = Convert.ToDecimal(ddlQHPLTK.SelectedValue);
                if (dt.DM_QHPL_TK.Where(x => x.PARENT_ID == IDChitieuTK).ToList().Count > 0)
                {
                    lstMsgB.Text = "Quan hệ pháp luật dùng cho thống kê chỉ được chọn mã con, bạn hãy chọn lại !";
                    Cls_Comon.SetFocus(this, this.GetType(), ddlQHPLTK.ClientID);
                    return false;
                }
                if (trLydoLyhon.Visible)
                {
                    if (txtSoconduoi7tuoi.Text == "")
                    {
                        lstMsgB.Text = "Chưa nhập số con dưới 7 tuổi";
                        txtSoconduoi7tuoi.Focus();
                        return false;
                    }
                    if (txtSoconchuathanhnien.Text == "")
                    {
                        lstMsgB.Text = "Chưa nhập số con từ 7 đến dưới 18 tuổi";
                        txtSoconchuathanhnien.Focus();
                        return false;
                    }
                }
                if (ddlCanbonhandon.Items.Count == 0)
                {
                    lstMsgB.Text = "Chưa chọn người nhận đơn";
                    Cls_Comon.SetFocus(this, this.GetType(), ddlCanbonhandon.ClientID);
                    return false;
                }
                if (txtTennguyendon.Text == "")
                {
                    lstMsgB.Text = "Chưa nhập tên nguyên đơn";
                    txtTennguyendon.Focus();
                    return false;
                }
                if (ddlLoaiNguyendon.SelectedValue == "1")
                {
                    if (txtND_Namsinh.Text == "")
                    {
                        lstMsgB.Text = "Chưa nhập năm sinh nguyên đơn";
                        txtND_Namsinh.Focus();
                        return false;
                    }
                    if (lblND_Batbuoc2.Text != "")
                    {
                        //if (ddlThuongTru_Huyen_NguyenDon.SelectedValue == "0")
                        //{
                        //    lstMsgB.Text = "Chưa chọn nơi thường trú của nguyên đơn!";
                        //    Cls_Comon.SetFocus(this, this.GetType(), ddlThuongTru_Huyen_NguyenDon.ClientID);
                        //    return false;
                        //}
                        if (ddlTamTru_Huyen_NguyenDon.SelectedValue == "0")
                        {
                            lstMsgB.Text = "Chưa chọn nơi sinh sống của nguyên đơn!";
                            Cls_Comon.SetFocus(this, this.GetType(), ddlTamTru_Huyen_NguyenDon.ClientID);
                            return false;
                        }
                    }
                }
                if (chkKhongCoNYC2.Checked == false)
                {
                    if (ddlLoaiBidon.SelectedValue == "1")
                    {

                        //if (lblBD_Batbuoc2.Text != "")
                        //{
                        //    //if (ddlThuongTru_Huyen_BiDon.SelectedValue == "0")
                        //    //{
                        //    //    lstMsgB.Text = "Chưa chọn nơi thường trú của bị đơn!";
                        //    //    Cls_Comon.SetFocus(this, this.GetType(), ddlThuongTru_Huyen_BiDon.ClientID);
                        //    //    return false;
                        //    //}
                        //    if (ddlTamTru_Huyen_BiDon.SelectedValue == "0")
                        //    {
                        //        lstMsgB.Text = "Chưa chọn nơi sinh sống của bị đơn";
                        //        Cls_Comon.SetFocus(this, this.GetType(), ddlTamTru_Huyen_BiDon.ClientID);
                        //        return false;
                        //    }
                        //}
                    }
                    if (txtBD_Ten.Text == "")
                    {
                        lstMsgB.Text = "Chưa nhập tên bị đơn";
                        txtBD_Ten.Focus();
                        return false;
                    }
                }
            }
            else
            {
                if (txtNguoiNop.Text == "" && ddlLoaidon.SelectedValue == "8")
                {
                    lstMsgB.Text = "Bạn chưa nhập người nộp đơn";
                    txtNguoiNop.Focus();
                    return false;
                }
                if (txtNguoiNopDocLap.Text == "" && ddlLoaidon.SelectedValue == "9")
                {
                    lstMsgB.Text = "Bạn chưa nhập người nộp đơn";
                    txtNguoiNopDocLap.Focus();
                    return false;
                }
            }
            return true;
        }
        private void ResetControls()
        {
            ddlQuanhephapluat.SelectedIndex = 0;
            txtMaVuViec.Text = "";
            txtTenVuViec.Text = "";
            // txtSothutu.Text = "";
            txtNgayViet.Text = "";
            chkISBVQLNK.Visible = false;
            txtNoidungkhoikien.Text = "";
            txtGhichu.Text = "";
            txtTennguyendon.Text = "";
            txtND_CMND.Text = "";
            txtND_Ngaysinh.Text = ""; ;
            txtND_Namsinh.Text = "";
            //  txtND_HKTT_Chitiet.Text = "";
            txtND_TTChitiet.Text = "";
            txtND_NDD_Diachichitiet.Text = "";
            chkND_ONuocNgoai.Checked = chkBD_ONuocNgoai.Checked = false;
            txtBD_Ten.Text = "";
            txtBD_CMND.Text = "";
            txtBD_Ngaysinh.Text = txtBD_Namsinh.Text = "";
            //txtBD_HKTT_Chitiet.Text = "";
            txtBD_NDD_Diachichitiet.Text = "";
            hddID.Value = "0";
            //ddlLoaidon.SelectedValue = "1";
            ddlListDuongSu.SelectedIndex = 0;
            DropDownListDuongSu.SelectedIndex = 0;
            ddlLoaiNguyendon.SelectedIndex = 0;
            ddlLoaiBidon.SelectedIndex = 0;
            ddlTamTru_Tinh_NguyenDon.SelectedIndex = 0;
            ddlTamTru_Tinh_BiDon.SelectedIndex = 0;
            ddlTamTru_Huyen_NguyenDon.SelectedIndex = 0;
            ddlTamTru_Huyen_BiDon.SelectedIndex = 0;
            txtND_NoiLamViec.Text = "";
            txtND_Email.Text = "";
            txtND_Dienthoai.Text = "";
            txtND_Fax.Text = "";
            txtBD_NoiLamViec.Text = "";
            txtBD_Email.Text = "";
            txtBD_Dienthoai.Text = "";
            txtBD_Fax.Text = "";
            txtNguoiNop.Items.Clear();
            txtNguoiNopDocLap.Items.Clear();
            txtBD_Tamtru_Chitiet.Text = "";
            ddlNDD_Tinh_BiDon.SelectedIndex = 0;
            ddlNDD_Huyen_BiDon.SelectedIndex = 0;
            txtBD_NDD_ten.Text = "";
            txtBD_NDD_Chucvu.Text = "";
            ddlNDD_Tinh_NguyenDon.SelectedIndex = 0;
            ddlNDD_Huyen_NguyenDon.SelectedIndex = 0;
            txtND_NDD_Ten.Text = "";
            txtND_NDD_Chucvu.Text = "";
            txtTennguyendon.Enabled = true;
            ddlLoaiNguyendon.Enabled = true;
            txtND_CMND.Enabled = true;
            chkBoxCMNDND.Enabled = true;
            txtND_Ngaysinh.Enabled = true;
            txtND_Namsinh.Enabled = true;
            ddlND_Gioitinh.Enabled = true;
            ddlTamTru_Tinh_NguyenDon.Enabled = true;
            ddlTamTru_Huyen_NguyenDon.Enabled = true;
            txtND_TTChitiet.Enabled = true;
            txtND_NoiLamViec.Enabled = true;
            txtND_Email.Enabled = true;
            txtND_Dienthoai.Enabled = true;
            txtND_Fax.Enabled = true;
            chkISBVQLNK.Enabled = true;
            chkND_ONuocNgoai.Enabled = true;
            ddlND_Quoctich.Enabled = true;
            ddlNDD_Tinh_NguyenDon.Enabled = true;
            ddlNDD_Huyen_NguyenDon.Enabled = true;
            txtND_NDD_Diachichitiet.Enabled = true;
            txtND_NDD_Ten.Enabled = true;
            txtND_NDD_Chucvu.Enabled = true;

            txtBD_Ten.Enabled = true;
            ddlLoaiBidon.Enabled = true;
            txtBD_CMND.Enabled = true;
            chkBoxCMNDBD.Enabled = true;
            txtBD_Ngaysinh.Enabled = true;
            txtBD_Namsinh.Enabled = true;
            ddlBD_Gioitinh.Enabled = true;
            ddlTamTru_Tinh_BiDon.Enabled = true;
            ddlTamTru_Huyen_BiDon.Enabled = true;
            txtBD_NDD_Diachichitiet.Enabled = true;
            txtBD_Email.Enabled = true;
            txtBD_Dienthoai.Enabled = true;
            txtBD_Fax.Enabled = true;
            chkISBVQLNK.Enabled = true;
            chkBD_ONuocNgoai.Enabled = true;
            ddlBD_Quoctich.Enabled = true;
            ddlNDD_Tinh_BiDon.Enabled = true;
            ddlNDD_Huyen_BiDon.Enabled = true;
            txtBD_NDD_ten.Enabled = true;
            txtBD_NDD_Chucvu.Enabled = true;
            txtBD_NoiLamViec.Enabled = true;

            LoadLoaiDon(false);
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
            if (chkBoxCMNDND.Checked == true)
            {
                txtND_CMND.Enabled = false;
            }
            else
            {
                txtND_CMND.Enabled = true;
            }

            if (chkBoxCMNDBD.Checked == true)
            {
                txtBD_CMND.Enabled = false;
            }
            else
            {
                txtBD_CMND.Enabled = true;
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

            //Load đương sự
            LoaddsDuongSu();
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
            ddlQuanhephapluat.DataSource = oBL.DM_DATAITEM_GETBY2GROUPNAME(ENUM_DANHMUC.QUANHEPL_YEUCAU_HNGD, ENUM_DANHMUC.QUANHEPL_TRANHCHAP_HNGD);
            ddlQuanhephapluat.DataTextField = "TEN";
            ddlQuanhephapluat.DataValueField = "ID";
            ddlQuanhephapluat.DataBind();
            //Load QHPL Thống kê.
            ddlQHPLTK.Items.Clear();
            ddlQHPLTK.DataSource = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.HONNHAN_GIADINH && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
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

            ////Lý do ly hon
            //DataTable dtLydolyhon = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.LYDOLYHON);

            //ddlLydoLyhon.DataSource = dtLydolyhon;
            //ddlLydoLyhon.DataTextField = "TEN";
            //ddlLydoLyhon.DataValueField = "ID";
            //ddlLydoLyhon.DataBind();

            LoadDropTinh();
        }
        private bool SaveData()
        {
            try
            {
                if (!CheckValid()) return false;
                DON_CHITIET oT;
                #region "THÔNG TIN ĐƠN KHỞI KIỆN"
                decimal ID = Convert.ToDecimal(hddID.Value);
                if (hddID.Value == "" || hddID.Value == "0")
                {
                    oT = new DON_CHITIET();
                }
                else
                {
                    oT = dt.DON_CHITIET.Where(x => x.ID == ID && x.LOAIANID == 3).FirstOrDefault();
                }
                oT.DONID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH]);
                oT.LOAIANID = Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH);
                //oT.TENVUVIEC = txtTennguyendon.Text + " - " + txtBD_Ten.Text + " - " + ddlQuanhephapluat.SelectedItem.Text;
                // oT.SOTHUTU = (txtSothutu.Text == "") ? 0 : Convert.ToDecimal(txtSothutu.Text);
                oT.HINHTHUCNHANDON = Convert.ToDecimal(ddlHinhthucnhandon.SelectedValue);
                DateTime dNgayViet;
                DateTime dNgayNhan;
                dNgayViet = (String.IsNullOrEmpty(txtNgayViet.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayViet.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                dNgayNhan = (String.IsNullOrEmpty(txtNgayNhan.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oT.NGAYVIETDON = dNgayViet;
                oT.NGAYNHANDON = dNgayNhan;
                //oT.LOAIQUANHE = Convert.ToDecimal(ddlLoaiQuanhe.SelectedValue);
                //oT.QUANHEPHAPLUATID = Convert.ToDecimal(ddlQuanhephapluat.SelectedValue);

                //oT.TENVUVIEC = txtTennguyendon.Text + " - " + txtBD_Ten.Text + " - " + txtQuanhephapluat.Text;
                //oT.QUANHEPHAPLUATID = null;
                //if (txtQuanhephapluat.Text != null || txtQuanhephapluat.Text != "")
                //oT.QUANHEPHAPLUAT_NAME = txtQuanhephapluat.Text;
                //if (txtQuanhephapluat.Text == "" || txtQuanhephapluat.Text == null)
                // oT.QUANHEPHAPLUAT_NAME = null;

                //oT.QHPLTKID = Convert.ToDecimal(ddlQHPLTK.SelectedValue);
                oT.CANBONHANDONID = Convert.ToDecimal(ddlCanbonhandon.SelectedValue);
                oT.THAMPHANKYNHANDON = Convert.ToDecimal(ddlThamphankynhandon.SelectedValue);
                oT.YEUTONUOCNGOAI = Convert.ToDecimal(ddlYeutonuocngoai.SelectedValue);
                //oT.DONKIENCUANGUOIKHAC = txtDonkiencuanguoikhac.Text;
                oT.LOAIDON = Convert.ToDecimal(ddlLoaidon.SelectedValue);
                oT.NOIDUNGKHOIKIEN = txtNoidungkhoikien.Text;
                oT.GHICHU = txtGhichu.Text;
                //if (trLydoLyhon.Visible)
                //{
                //    oT.SOCONCHUATHANHNIEN = txtSoconchuathanhnien.Text == "" ? 0 : Convert.ToDecimal(txtSoconchuathanhnien.Text);
                //    oT.SOCONDUOI7TUOI = txtSoconduoi7tuoi.Text == "" ? 0 : Convert.ToDecimal(txtSoconduoi7tuoi.Text);
                //}
                //else
                //{
                //    oT.SOCONCHUATHANHNIEN = 0;
                //    oT.LYDOLYHONID = 0;
                //}
                if (hddID.Value == "" || hddID.Value == "0")
                {
                    AHN_DON_BL dsBL = new AHN_DON_BL();
                    oT.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    //oT.TT = dsBL.GETNEWTT((decimal)oT.TOAANID);
                    //oT.TRANGTHAI = ENUM_DS_TRANGTHAI.TAOMOI;
                    //oT.MAVUVIEC = ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH + Session[ENUM_SESSION.SESSION_MADONVI] + oT.TT.ToString();
                    oT.NGAYTAO = DateTime.Now;
                    oT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    //oT.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                    oT.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.DON_CHITIET.Add(oT);
                    dt.SaveChanges();
                    //hddID.Value = oT.ID.ToString();
                    //anhvh add 26/06/2020
                    //GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                    //GD.GAIDOAN_INSERT_UPDATE("3", oT.ID, 2, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0, 0);
                }
                else
                {
                    oT.NGAYSUA = DateTime.Now;
                    oT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.SaveChanges();
                }
                if (ddlLoaidon.SelectedValue != "8" && ddlLoaidon.SelectedValue != "9")
                {


                    #endregion
                    //Lưu nguyên đơn đại diện
                    #region "NGUYÊN ĐƠN ĐẠI DIỆN"
                    int idDuongSuND = Convert.ToInt32(ddlListDuongSu.SelectedValue);
                    int idDuongSuBD = Convert.ToInt32(DropDownListDuongSu.SelectedValue);
                    AHN_DON_DUONGSU oND = null;
                    if (idDuongSuND == 0)
                    {
                        oND = new AHN_DON_DUONGSU();
                    }
                    else
                    {
                        oND = dt.AHN_DON_DUONGSU.Where(x => x.ID == idDuongSuND).FirstOrDefault();
                    }
                    decimal donid = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH]);
                    oND.DONID = donid;
                    oND.TENDUONGSU = Convert.ToDecimal(ddlLoaiNguyendon.SelectedValue) == 1 ? Cls_Comon.FormatTenRieng(txtTennguyendon.Text) : Cls_Comon.FormatTenTochuc(txtTennguyendon.Text);
                    if (oND.ISDAIDIEN == 1)
                    {
                        oND.ISDAIDIEN = 1;
                    }
                    else
                    {
                        oND.ISDAIDIEN = 0;
                    }
                    oND.TUCACHTOTUNG_MA = ENUM_DANSU_TUCACHTOTUNG.NGUYENDON;
                    oND.LOAIDUONGSU = Convert.ToDecimal(ddlLoaiNguyendon.SelectedValue);
                    if (chkISBVQLNK.Visible)
                        oND.ISBVQLNGUOIKHAC = chkISBVQLNK.Checked ? 1 : 0;
                    else
                        oND.ISBVQLNGUOIKHAC = 0;
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
                    oND.TUOI = txtND_Tuoi.Text == "" ? 0 : Convert.ToDecimal(txtND_Tuoi.Text);
                    oND.GIOITINH = Convert.ToDecimal(ddlND_Gioitinh.SelectedValue);
                    oND.NGUOIDAIDIEN = Cls_Comon.FormatTenRieng(txtND_NDD_Ten.Text);
                    oND.SINHSONG_NUOCNGOAI = chkND_ONuocNgoai.Checked == true ? 1 : 0;
                    oND.CHUCVU = txtND_NDD_Chucvu.Text;
                    oND.EMAIL = txtND_Email.Text;
                    oND.DIENTHOAI = txtND_Dienthoai.Text;
                    oND.FAX = txtND_Fax.Text;
                    oND.ISDAIDIEN_DONCHITIET = 1;
                    if (pnNDTochuc.Visible)
                    {
                        oND.NDD_DIACHIID = Convert.ToDecimal(ddlNDD_Huyen_NguyenDon.SelectedValue);
                        oND.NDD_DIACHICHITIET = txtND_NDD_Diachichitiet.Text;
                    }
                    oND.ISSOTHAM = 1;
                    oND.ISDON = 1;
                    if (idDuongSuND != 0)
                    {
                        oND.NGAYSUA = DateTime.Now;
                        oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        dt.SaveChanges();
                    }
                    else
                    {
                        oND.ISDONCHITIET = 1;
                        oND.NGAYTAO = DateTime.Now;
                        oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        //oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        
                        // an hn
                        if (oND.TOA_GIAIQUYET_ID == null)
                            oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        
                        dt.AHN_DON_DUONGSU.Add(oND);
                        dt.SaveChanges();
                    }
                    #endregion
                    if (chkKhongCoNYC2.Checked == false)
                    {
                        #region "BỊ ĐƠN ĐẠI DIỆN"
                        AHN_DON_DUONGSU oBD = null;
                        if (idDuongSuBD == 0)
                        {
                            oBD = new AHN_DON_DUONGSU();
                        }
                        else
                        {
                            oBD = dt.AHN_DON_DUONGSU.Where(x => x.ID == idDuongSuBD).FirstOrDefault();
                        }
                        oBD.DONID = donid;
                        oBD.TENDUONGSU = Convert.ToDecimal(ddlLoaiBidon.SelectedValue) == 1 ? Cls_Comon.FormatTenRieng(txtBD_Ten.Text) : Cls_Comon.FormatTenTochuc(txtBD_Ten.Text);
                        if (oBD.ISDAIDIEN == 1)
                        {
                            oBD.ISDAIDIEN = 1;
                        }
                        else
                        {
                            oBD.ISDAIDIEN = 0;
                        }
                        oBD.TUCACHTOTUNG_MA = ENUM_DANSU_TUCACHTOTUNG.BIDON;
                        oBD.LOAIDUONGSU = Convert.ToDecimal(ddlLoaiBidon.SelectedValue);
                        oBD.SOCMND = txtBD_CMND.Text;
                        // VNPT Nguyễn Đăng Huy Hoàng 11/11/2025 18:15:00
                        // lưu trường cccd phục vụ gửi thông báo tống đạt
                        oBD.SO_CCCD = txtBD_CMND.Text;
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
                        oBD.TUOI = txtBD_Tuoi.Text == "" ? 0 : Convert.ToDecimal(txtBD_Tuoi.Text);
                        oBD.GIOITINH = Convert.ToDecimal(ddlBD_Gioitinh.SelectedValue);
                        oBD.NGUOIDAIDIEN = Cls_Comon.FormatTenRieng(txtBD_NDD_ten.Text);
                        oBD.SINHSONG_NUOCNGOAI = chkBD_ONuocNgoai.Checked == true ? 1 : 0;
                        oBD.CHUCVU = txtBD_NDD_Chucvu.Text;
                        oBD.EMAIL = txtBD_Email.Text;
                        oBD.DIENTHOAI = txtBD_Dienthoai.Text;
                        oBD.FAX = txtBD_Fax.Text;
                        oBD.ISDAIDIEN_DONCHITIET = 1;
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
                        if (idDuongSuBD != 0)
                        {
                            oBD.NGAYSUA = DateTime.Now;
                            oBD.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            dt.SaveChanges();
                        }
                        else
                        {
                            oBD.ISDONCHITIET = 1;
                            oBD.NGAYTAO = DateTime.Now;
                            oBD.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            //oBD.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                            
                            // an hn
                            if (oBD.TOA_GIAIQUYET_ID == null)
                                oBD.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                            
                            dt.AHN_DON_DUONGSU.Add(oBD);
                            dt.SaveChanges();
                        }
                        List<DON_DUONGSU_CHITIET> oListDsBD = dt.DON_DUONGSU_CHITIET.Where(x => x.DONCHITIETID == ID).ToList();
                        AHN_DON_DUONGSU oDuongSu_BD = null;
                        for (int i = 0; i < oListDsBD.Count; i++)
                        {
                            int IDduongSu = Convert.ToInt32(oListDsBD[i].DUONGSUID);
                            AHN_DON_DUONGSU Ods = dt.AHN_DON_DUONGSU.Where(x => x.ID == IDduongSu).FirstOrDefault();
                            if (Ods != null)
                            {
                                if (Ods.TUCACHTOTUNG_MA == "BIDON" && Ods.ISDAIDIEN_DONCHITIET == 1)
                                {
                                    oDuongSu_BD = dt.AHN_DON_DUONGSU.Where(x => x.ID == IDduongSu).FirstOrDefault();
                                }
                            }

                        }
                        DON_DUONGSU_CHITIET oDuongSu_ChiTiet_BD = null;
                        if (hddID.Value == "" || hddID.Value == "0")
                        {
                            oDuongSu_ChiTiet_BD = new DON_DUONGSU_CHITIET();
                        }
                        else
                        {
                            oDuongSu_ChiTiet_BD = dt.DON_DUONGSU_CHITIET.Where(x => x.DUONGSUID == oDuongSu_BD.ID && x.DONCHITIETID == ID).FirstOrDefault();
                        }
                        oDuongSu_ChiTiet_BD.DUONGSUID = oBD.ID;
                        oDuongSu_ChiTiet_BD.DONID = donid;
                        oDuongSu_ChiTiet_BD.DONCHITIETID = oT.ID;
                        oDuongSu_ChiTiet_BD.LOAIAN = 3;
                        oDuongSu_ChiTiet_BD.NGAYTAO = DateTime.Now;
                        oDuongSu_ChiTiet_BD.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        if (hddID.Value == "" || hddID.Value == "0")
                        {
                            //oDuongSu_ChiTiet_BD.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                            if (oDuongSu_ChiTiet_BD.TOA_GIAIQUYET_ID == null)
                                oDuongSu_ChiTiet_BD.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                            
                            dt.DON_DUONGSU_CHITIET.Add(oDuongSu_ChiTiet_BD);
                            dt.SaveChanges();
                        }
                        else
                        {
                            oDuongSu_ChiTiet_BD.NGAYSUA = DateTime.Now;
                            oDuongSu_ChiTiet_BD.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            dt.SaveChanges();
                        }
                    }
                    DON_DUONGSU_CHITIET oDuongSu_ChiTiet_ND = null;
                    List<DON_DUONGSU_CHITIET> oListDs = dt.DON_DUONGSU_CHITIET.Where(x => x.DONCHITIETID == ID).ToList();
                    AHN_DON_DUONGSU oDuongSu_ND = null;
                    for (int i = 0; i < oListDs.Count; i++)
                    {
                        int IDduongSu = Convert.ToInt32(oListDs[i].DUONGSUID);
                        AHN_DON_DUONGSU Ods = dt.AHN_DON_DUONGSU.Where(x => x.ID == IDduongSu).FirstOrDefault();
                        if (Ods != null)
                        {
                            if (Ods.TUCACHTOTUNG_MA == "NGUYENDON" && Ods.ISDAIDIEN_DONCHITIET == 1)
                            {
                                oDuongSu_ND = dt.AHN_DON_DUONGSU.Where(x => x.ID == IDduongSu).FirstOrDefault();
                            }
                        }

                    }
                    if (hddID.Value == "" || hddID.Value == "0")
                    {
                        oDuongSu_ChiTiet_ND = new DON_DUONGSU_CHITIET();
                    }
                    else
                    {
                        oDuongSu_ChiTiet_ND = dt.DON_DUONGSU_CHITIET.Where(x => x.DUONGSUID == oDuongSu_ND.ID && x.DONCHITIETID == ID).FirstOrDefault();
                    }
                    oDuongSu_ChiTiet_ND.DUONGSUID = oND.ID;
                    oDuongSu_ChiTiet_ND.DONID = donid;
                    oDuongSu_ChiTiet_ND.DONCHITIETID = oT.ID;
                    oDuongSu_ChiTiet_ND.LOAIAN = 3;
                    oDuongSu_ChiTiet_ND.NGAYTAO = DateTime.Now;
                    oDuongSu_ChiTiet_ND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    if (hddID.Value == "" || hddID.Value == "0")
                    {
                        //oDuongSu_ChiTiet_ND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        if (oDuongSu_ChiTiet_ND.TOA_GIAIQUYET_ID == null)
                            oDuongSu_ChiTiet_ND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        
                        dt.DON_DUONGSU_CHITIET.Add(oDuongSu_ChiTiet_ND);
                        dt.SaveChanges();
                    }
                    else
                    {
                        oDuongSu_ChiTiet_ND.NGAYSUA = DateTime.Now;
                        oDuongSu_ChiTiet_ND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        dt.SaveChanges();
                    }


                    #endregion
                }

                else
                {
                    decimal donid = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH]);
                    if (txtNguoiNopDocLap != null)
                    {
                        if (txtNguoiNopDocLap.Items.Count > 0)
                        {
                            List<DON_DUONGSU_CHITIET> oDuongSu_ChiTiet_ND_delete = dt.DON_DUONGSU_CHITIET.Where(x => x.DONCHITIETID == ID).ToList();
                            dt.DON_DUONGSU_CHITIET.RemoveRange(oDuongSu_ChiTiet_ND_delete);
                            for (int i = 0; i < txtNguoiNopDocLap.Items.Count; i++)
                            {
                                if (txtNguoiNopDocLap.Items[i].Selected)
                                {
                                    int idDuongSu = Convert.ToInt32(txtNguoiNopDocLap.Items[i].Value);
                                    DON_DUONGSU_CHITIET oDuongSu_ChiTiet_ND = new DON_DUONGSU_CHITIET();
                                    oDuongSu_ChiTiet_ND.DUONGSUID = Convert.ToInt32(txtNguoiNopDocLap.Items[i].Value);
                                    oDuongSu_ChiTiet_ND.DONID = donid;
                                    oDuongSu_ChiTiet_ND.DONCHITIETID = oT.ID;
                                    oDuongSu_ChiTiet_ND.LOAIAN = 3;
                                    oDuongSu_ChiTiet_ND.NGAYTAO = DateTime.Now;
                                    oDuongSu_ChiTiet_ND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                    //oDuongSu_ChiTiet_ND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                                    
                                    if (oDuongSu_ChiTiet_ND.TOA_GIAIQUYET_ID == null)
                                        oDuongSu_ChiTiet_ND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                                    
                                    dt.DON_DUONGSU_CHITIET.Add(oDuongSu_ChiTiet_ND);
                                    dt.SaveChanges();
                                }
                            }
                        }
                    }
                    if (txtNguoiNop != null)
                    {
                        if (txtNguoiNop.Items.Count > 0)
                        {
                            List<DON_DUONGSU_CHITIET> oDuongSu_ChiTiet_ND_delete = dt.DON_DUONGSU_CHITIET.Where(x => x.DONCHITIETID == ID).ToList();
                            dt.DON_DUONGSU_CHITIET.RemoveRange(oDuongSu_ChiTiet_ND_delete);
                            for (int i = 0; i < txtNguoiNop.Items.Count; i++)
                            {
                                if (txtNguoiNop.Items[i].Selected)
                                {
                                    int idDuongSu = Convert.ToInt32(txtNguoiNop.Items[i].Value);
                                    DON_DUONGSU_CHITIET oDuongSu_ChiTiet_ND = new DON_DUONGSU_CHITIET();
                                    oDuongSu_ChiTiet_ND.DUONGSUID = Convert.ToInt32(txtNguoiNop.Items[i].Value);
                                    oDuongSu_ChiTiet_ND.DONID = donid;
                                    oDuongSu_ChiTiet_ND.DONCHITIETID = oT.ID;
                                    oDuongSu_ChiTiet_ND.LOAIAN = 3;
                                    oDuongSu_ChiTiet_ND.NGAYTAO = DateTime.Now;
                                    oDuongSu_ChiTiet_ND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                    //oDuongSu_ChiTiet_ND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                                    
                                    if (oDuongSu_ChiTiet_ND.TOA_GIAIQUYET_ID == null)
                                        oDuongSu_ChiTiet_ND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                                    
                                    dt.DON_DUONGSU_CHITIET.Add(oDuongSu_ChiTiet_ND);
                                    dt.SaveChanges();
                                }
                            }
                        }
                    }

                }
                hddID.Value = oT.ID.ToString();
                SetDonGhep();
                return true;
            }
            catch (Exception ex)
            {
                lstMsgB.Text = "Lỗi: " + ex.Message;
                return false;
            }
        }
        private void SetDonGhep()
        {
            if (!string.IsNullOrEmpty(Request.QueryString["DONGHEPID"]))
            {
                string keyDonID = "DONGHEP.DONIDCHITIET" + Session[ENUM_SESSION.SESSION_USERID].ToString();
                Session[keyDonID] = Request.QueryString["DONGHEPID"].ToString();
            }
            else
            {
                string keyDonID = "DONGHEP.DONIDCHITIET" + Session[ENUM_SESSION.SESSION_USERID].ToString();
                Session[keyDonID] = hddID.Value;
            }

        }
        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            if (SaveData())
            {
                lstMsgB.Text = "Lưu thông tin đơn thành công !";
                Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
                //Session["HN_THEMDSK"] = hddID.Value;
            }
        }

        protected void lkThemDuongSuKhac_Click(object sender, EventArgs e)
        {
            if (SaveData())
            {
                string DonID = hddID.Value;
                if (!string.IsNullOrEmpty(DonID) && DonID != "0")
                {
                    string StrMsg = "PopupCenter('/QLAN/AHN/Hoso/Popup/pDuongsuChiTiet.aspx?hsID=" + DonID + "&bID=0','Thêm đương sự',950,450);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
                }

                //Session["DS_THEMDSK"] = hddID.Value;

            }
        }

        //protected void cmdUpdateSelect_Click(object sender, EventArgs e)
        //{
        //    if (SaveData())
        //    {
        //        decimal IDVuViec = Convert.ToDecimal(hddID.Value);
        //        //Lưu vào người dùng
        //        decimal IDUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
        //        QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDUser).FirstOrDefault();
        //        if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") == oNSD.DONVIID.ToString())
        //        {
        //            oNSD.IDANHNGD = IDVuViec;
        //            dt.SaveChanges();
        //        }
        //        Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] = IDVuViec;
        //        Response.Redirect("Thongtindon.aspx");
        //        //Cls_Comon.ShowMessageAndRedirect(this, this.GetType(), "MsgDSDON", "Lưu thông tin thành công, tiếp theo hãy chọn chức năng khác cần thao tác trong danh sách bên trái !", Cls_Comon.GetRootURL() + "/Trangchu.aspx");
        //    }
        //}
        protected void cmdUpdateAndNew_Click(object sender, EventArgs e)
        {
            if (SaveData())
            {
                ResetControls();
                lstMsgB.Text = "Hoàn thành Lưu, bạn hãy nhập thông tin đơn tiếp theo !";
                Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
                // txtSothutu.Focus();
            }
        }
        protected void cmdQuaylai_Click(object sender, EventArgs e)
        {
            Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();window.close();");
        }
        protected void txtND_Ngaysinh_TextChanged(object sender, EventArgs e)
        {
            DateTime d;
            d = (String.IsNullOrEmpty(txtND_Ngaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (d != DateTime.MinValue)
            {
                txtND_Namsinh.Text = d.Year.ToString();
                //Tính tuổi 
                DateTime dNgayNhan = (String.IsNullOrEmpty(txtNgayNhan.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (dNgayNhan != DateTime.MinValue)
                {
                    txtND_Tuoi.Text = (dNgayNhan.Year - d.Year).ToString();

                }
            }
            if (txtND_Ngaysinh.Text != "")
            {
                if (Cls_Comon.IsValidDate(txtND_Ngaysinh.Text))
                {
                    DateTime NgaySinh_ND = DateTime.Parse(txtND_Ngaysinh.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                    txtND_Namsinh.Text = NgaySinh_ND.Year.ToString();
                }
            }
        }
        protected void txtBD_Ngaysinh_TextChanged(object sender, EventArgs e)
        {
            DateTime d;
            d = (String.IsNullOrEmpty(txtBD_Ngaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtBD_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (d != DateTime.MinValue)
            {
                txtBD_Namsinh.Text = d.Year.ToString();
                //Tính tuổi 
                DateTime dNgayNhan = (String.IsNullOrEmpty(txtNgayNhan.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (dNgayNhan != DateTime.MinValue)
                {
                    txtBD_Tuoi.Text = (dNgayNhan.Year - d.Year).ToString();


                }
            }
            if (txtBD_Ngaysinh.Text != "")
            {
                if (Cls_Comon.IsValidDate(txtBD_Ngaysinh.Text))
                {
                    DateTime NgaySinh_BD = DateTime.Parse(txtBD_Ngaysinh.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                    txtBD_Namsinh.Text = NgaySinh_BD.Year.ToString();
                }
            }
        }
        protected void txtND_Namsinh_TextChanged(object sender, EventArgs e)
        {
            if (txtND_Namsinh.Text.Length == 4)
            {
                string NgaySinhstr = "";
                if (txtND_Ngaysinh.Text == "")
                {
                    NgaySinhstr = "";
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
                txtND_Ngaysinh.Text = NgaySinhstr;
            }
        }
        protected void txtBD_Namsinh_TextChanged(object sender, EventArgs e)
        {
            if (txtBD_Namsinh.Text.Length == 4)
            {
                string NgaySinhstr = "";
                if (txtBD_Ngaysinh.Text == "")
                {
                    NgaySinhstr = "";
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
                txtBD_Ngaysinh.Text = NgaySinhstr;
            }

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
            txtBD_Ten.Focus();
        }
        protected void ddlLoaiQuanhe_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadCombobox();

            if (ddlLoaiQuanhe.SelectedValue == "1")
            {
                lstTitleNguyendon.Text = "Thông tin nguyên đơn (đại diện)";
                lstTitleBidon.Text = "Thông tin bị đơn (đại diện)";
                chkKhongCoNYC2.Visible = false;
            }
            else
            {
                lstTitleNguyendon.Text = "Người yêu cầu 1 (Người yêu cầu)";
                lstTitleBidon.Text = "Người yêu cầu 2 (Người bị yêu cầu)";
                chkKhongCoNYC2.Visible = true;
            }
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
            //if (chkBD_ONuocNgoai.Checked)
            //{
            //    //lblBD_Batbuoc1.Text = 
            //    lblBD_Batbuoc2.Text = "";
            //}
            //else
            //{
            //    // lblBD_Batbuoc1.Text = 
            //    lblBD_Batbuoc2.Text = "(*)";
            //}
            Cls_Comon.SetFocus(this, this.GetType(), ddlTamTru_Tinh_BiDon.ClientID);

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
            if (ddlLoaiQuanhe.SelectedValue == "1")
            {
                lstTitleNguyendon.Text = "Thông tin nguyên đơn (đại diện)";
                lstTitleBidon.Text = "Thông tin bị đơn (đại diện)";
                chkKhongCoNYC2.Visible = false;
            }
            else
            {
                lstTitleNguyendon.Text = "Người yêu cầu 1 (Người yêu cầu)";
                lstTitleBidon.Text = "Người yêu cầu 2 (Người bị yêu cầu)";
                chkKhongCoNYC2.Visible = true;
            }
            Cls_Comon.SetFocus(this, this.GetType(), ddlQHPLTK.ClientID);
        }
        private void ChangeQuanhePL()
        {
            trLydoLyhon.Visible = false;
            // Kiểm tra ẩn / hiện lý do ly hôn
            if (ddlQHPLTK.Items.Count > 0)
            {
                decimal IDItem = Convert.ToDecimal(ddlQHPLTK.SelectedValue);
                DM_QHPL_TK oT = dt.DM_QHPL_TK.Where(x => x.ID == IDItem).FirstOrDefault();
                if (oT.ARRSAPXEP.Contains("0/1042"))
                {
                    trLydoLyhon.Visible = true;
                    Cls_Comon.SetFocus(this, this.GetType(), txtSoconduoi7tuoi.ClientID);
                    return;
                }
            }
            Cls_Comon.SetFocus(this, this.GetType(), ddlCanbonhandon.ClientID);
        }
        private void SetEnableNYC2(bool blnFlag)
        {
            ddlLoaiBidon.Enabled = txtBD_Ten.Enabled = txtBD_NDD_Diachichitiet.Enabled = blnFlag;
            txtBD_NDD_ten.Enabled = txtBD_NDD_Chucvu.Enabled = txtBD_CMND.Enabled = ddlBD_Quoctich.Enabled = ddlBD_Gioitinh.Enabled = blnFlag;
            txtBD_Ngaysinh.Enabled = txtBD_Namsinh.Enabled = chkBD_ONuocNgoai.Enabled = blnFlag;
            txtBD_Tamtru_Chitiet.Enabled = txtBD_Email.Enabled = txtBD_Dienthoai.Enabled = txtBD_Fax.Enabled = blnFlag;
        }
        protected void chkKhongCoNYC2_CheckedChanged(object sender, EventArgs e)
        {
            SetEnableNYC2(chkKhongCoNYC2.Checked ? false : true);
            Cls_Comon.SetFocus(this, this.GetType(), chkKhongCoNYC2.ClientID);
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
            catch (Exception ex) { lstMsgB.Text = ex.Message; }
        }
        protected void ddlNDD_Tinh_BiDon_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDropNDD_Huyen_BiDon();
                Cls_Comon.SetFocus(this, this.GetType(), ddlNDD_Huyen_BiDon.ClientID);
            }
            catch (Exception ex) { lstMsgB.Text = ex.Message; }
        }
        protected void ddlTamTru_Tinh_NguyenDon_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDropTamTru_Huyen_NguyenDon();
                Cls_Comon.SetFocus(this, this.GetType(), ddlTamTru_Huyen_NguyenDon.ClientID);

            }
            catch (Exception ex) { lstMsgB.Text = ex.Message; }
        }
        protected void ddlTamTru_Tinh_BiDon_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDropTamTru_Huyen_BiDon();
                Cls_Comon.SetFocus(this, this.GetType(), ddlTamTru_Huyen_BiDon.ClientID);

            }
            catch (Exception ex) { lstMsgB.Text = ex.Message; }
        }
        //protected void ddlThuongTru_Tinh_BiDon_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        LoadDropThuongTru_Huyen_BiDon();
        //        Cls_Comon.SetFocus(this, this.GetType(), ddlThuongTru_Huyen_BiDon.ClientID);

        //    }
        //    catch (Exception ex) { lstMsgB.Text = ex.Message; }
        //}
        //protected void ddlThuongTru_Tinh_NguyenDon_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        LoadDropThuongTru_Huyen_NguyenDon();
        //        Cls_Comon.SetFocus(this, this.GetType(), ddlThuongTru_Huyen_NguyenDon.ClientID);
        //    }
        //    catch (Exception ex) { lstMsgB.Text = ex.Message; }
        //}

        protected void ddlQHPLTK_SelectedIndexChanged(object sender, EventArgs e)
        {
            ChangeQuanhePL();

        }

        private void txtQuanhephapluat_name(AHN_DON oT)
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

        protected void ddlLoaidon_SelectedIndexChanged(object sender, EventArgs e)
        {
            var loaiDon = ddlLoaidon.SelectedValue;
            if (loaiDon == "8")
            {
                pnTTDuongSu.Visible = false;
                lbNoidung.Text = "Nội dung phản tố";
                lbTenNguoiPhanTo.Text = "Tên người yêu cầu phản tố <span class='batbuoc'>(*)</span>";
                txtNguoiNop.Visible = true;
                txtNguoiNopDocLap.Visible = false;
                lbTenNguoiPhanTo.Visible = true;
                lbGhiChu.Visible = false;
                txtGhichu.Visible = false;
                pnDuongSuChiTiet.Visible = false;
            }
            else if (loaiDon == "9")
            {
                pnTTDuongSu.Visible = false;
                lbNoidung.Text = "Nội dung độc lập";
                lbTenNguoiPhanTo.Text = "Tên người yêu cầu độc lập <span class='batbuoc'>(*)</span>";
                txtNguoiNopDocLap.Visible = true;
                txtNguoiNop.Visible = false;
                lbTenNguoiPhanTo.Visible = true;
                lbGhiChu.Visible = true;
                lbGhiChu.Text = "Ghi chú";
                txtGhichu.Visible = true;
                pnDuongSuChiTiet.Visible = false;
            }
            else
            {
                pnTTDuongSu.Visible = true;
                lbNoidung.Text = "Nội dung khởi kiện";
                txtNguoiNop.Visible = false;
                txtNguoiNopDocLap.Visible = false;
                lbTenNguoiPhanTo.Visible = false;
                lbGhiChu.Visible = false;
                txtGhichu.Visible = false;
                pnDuongSuChiTiet.Visible = true;
            }
        }

        protected void ddlListDuongSu_SelectedIndexChanged(object sender, EventArgs e)
        {
            decimal donid = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH]);
            int idDuongSu = Convert.ToInt32(ddlListDuongSu.SelectedValue);
            if (ddlListDuongSu.SelectedValue == "0")
            {
                chkISBVQLNK.Visible = false;
                txtTennguyendon.Enabled = true;
                ddlLoaiNguyendon.Enabled = true;
                txtND_CMND.Enabled = true;
                chkBoxCMNDND.Enabled = true;
                txtND_Ngaysinh.Enabled = true;
                txtND_Namsinh.Enabled = true;
                ddlND_Gioitinh.Enabled = true;
                ddlTamTru_Tinh_NguyenDon.Enabled = true;
                ddlTamTru_Huyen_NguyenDon.Enabled = true;
                txtND_TTChitiet.Enabled = true;
                txtND_NoiLamViec.Enabled = true;
                txtND_Email.Enabled = true;
                txtND_Dienthoai.Enabled = true;
                txtND_Fax.Enabled = true;
                chkISBVQLNK.Enabled = true;
                chkND_ONuocNgoai.Enabled = true;
                ddlND_Quoctich.Enabled = true;
                ddlNDD_Tinh_NguyenDon.Enabled = true;
                ddlNDD_Huyen_NguyenDon.Enabled = true;
                txtND_NDD_Diachichitiet.Enabled = true;
                txtND_NDD_Ten.Enabled = true;
                txtND_NDD_Chucvu.Enabled = true;
            }
            else
            {
                AHN_DON_DUONGSU oDS = dt.AHN_DON_DUONGSU.Where(x => x.DONID == donid && x.ID == idDuongSu).FirstOrDefault();
                if (oDS.TENDUONGSU != null) txtTennguyendon.Enabled = false; else txtTennguyendon.Enabled = true;
                if (oDS.LOAIDUONGSU != null)
                {
                    ddlLoaiNguyendon.Enabled = false;
                }
                else
                {
                    ddlLoaiNguyendon.Enabled = true;
                }
                txtND_CMND.Enabled = false;
                chkBoxCMNDND.Enabled = false;
                if (oDS.LOAIDUONGSU == 1)
                {
                    if (oDS.GIOITINH != null) ddlND_Gioitinh.Enabled = false; else ddlND_Gioitinh.Enabled = true;
                    if (oDS.NGAYSINH != null && oDS.NGAYSINH != DateTime.MinValue) txtND_Ngaysinh.Enabled = false; else txtND_Ngaysinh.Enabled = true;
                    if (oDS.NAMSINH != null && oDS.NAMSINH != 0) txtND_Namsinh.Enabled = false; else txtND_Namsinh.Enabled = true;
                    if (oDS.TAMTRUTINHID != null && oDS.TAMTRUTINHID != 0) ddlTamTru_Tinh_NguyenDon.Enabled = false; else ddlTamTru_Tinh_NguyenDon.Enabled = true;
                    if (oDS.TAMTRUID != null && oDS.TAMTRUID != 0) ddlTamTru_Huyen_NguyenDon.Enabled = false; else ddlTamTru_Huyen_NguyenDon.Enabled = true;
                    if (oDS.TAMTRUCHITIET != null) txtND_TTChitiet.Enabled = false; else txtND_TTChitiet.Enabled = true;
                    if (oDS.DIACHICOQUAN != null) txtND_NoiLamViec.Enabled = false; else txtND_NoiLamViec.Enabled = true;
                }
                if (oDS.LOAIDUONGSU == 2 || oDS.LOAIDUONGSU == 3)
                {
                    if (oDS.TAMTRUTINHID != null && oDS.TAMTRUTINHID != 0) ddlNDD_Tinh_NguyenDon.Enabled = false; else ddlNDD_Tinh_NguyenDon.Enabled = true;
                    if (oDS.NDD_DIACHIID != null && oDS.NDD_DIACHIID != 0) ddlNDD_Huyen_NguyenDon.Enabled = false; else ddlNDD_Huyen_NguyenDon.Enabled = true;
                    if (oDS.NDD_DIACHICHITIET != null) txtND_NDD_Diachichitiet.Enabled = false; else txtND_NDD_Diachichitiet.Enabled = true;
                    if (oDS.NGUOIDAIDIEN != null) txtND_NDD_Ten.Enabled = false; else txtND_NDD_Ten.Enabled = true;
                    if (oDS.CHUCVU != null) txtND_NDD_Chucvu.Enabled = false; else txtND_NDD_Chucvu.Enabled = true;
                }
                if (oDS.EMAIL != null) txtND_Email.Enabled = false; else txtND_Email.Enabled = true;
                if (oDS.DIENTHOAI != null) txtND_Dienthoai.Enabled = false; else txtND_Dienthoai.Enabled = true;
                if (oDS.FAX != null) txtND_Fax.Enabled = false; else txtND_Fax.Enabled = true;
                if (oDS.QUOCTICHID != null && oDS.QUOCTICHID != 0) ddlND_Quoctich.Enabled = false; else ddlND_Quoctich.Enabled = true;
            }
            if (idDuongSu == 0)
            {
                ddlLoaiNguyendon.SelectedValue = "1";
                txtTennguyendon.Text = "";
                txtND_CMND.Text = "";
                chkBoxCMNDND.Checked = false;
                ddlND_Gioitinh.SelectedValue = "0";
                chkND_ONuocNgoai.Checked = false;
                txtND_Ngaysinh.Text = "";
                txtND_Namsinh.Text = "";
                txtND_TTChitiet.Text = "";
                txtND_NoiLamViec.Text = "";
                txtND_Email.Text = "";
                txtND_Dienthoai.Text = "";
                txtND_Fax.Text = "";
                ddlND_Quoctich.SelectedValue = "2";
                Cls_Comon.SetValueComboBox(ddlTamTru_Tinh_NguyenDon, Session[ENUM_SESSION.SESSION_TINH_ID]);
                LoadDropNoiSongHuyen();
                Cls_Comon.SetValueComboBox(ddlTamTru_Huyen_NguyenDon, Session[ENUM_SESSION.SESSION_QUAN_ID]);
                pnNDCanhan.Visible = true;
                pnNDTochuc.Visible = false;
                chkISBVQLNK.Visible = false;
            }

            else
            {

                AHN_DON_DUONGSU oDuongSu = dt.AHN_DON_DUONGSU.Where(x => x.DONID == donid && x.ID == idDuongSu).FirstOrDefault();
                if (oDuongSu.LOAIDUONGSU == 1)
                {
                    ddlLoaiNguyendon.SelectedValue = "1";
                    pnNDCanhan.Visible = true;
                    pnNDTochuc.Visible = false;
                    chkISBVQLNK.Visible = false;
                }
                else if (oDuongSu.LOAIDUONGSU == 2)
                {
                    ddlLoaiNguyendon.SelectedValue = "2";
                    pnNDCanhan.Visible = false;
                    pnNDTochuc.Visible = true;
                    chkISBVQLNK.Visible = true;
                }
                else if (oDuongSu.LOAIDUONGSU == 3)
                {
                    ddlLoaiNguyendon.SelectedValue = "3";
                    pnNDCanhan.Visible = false;
                    pnNDTochuc.Visible = true;
                    chkISBVQLNK.Visible = true;
                }
                txtTennguyendon.Text = oDuongSu.TENDUONGSU;

                if (oDuongSu.SOCMND == null)
                {
                    chkBoxCMNDND.Checked = true;
                    txtND_CMND.Text = "";
                }
                else
                {
                    chkBoxCMNDND.Checked = false;
                    txtND_CMND.Text = oDuongSu.SOCMND;
                }

                ddlND_Quoctich.SelectedValue = oDuongSu.QUOCTICHID.ToString();
                if (oDuongSu.GIOITINH == 1)
                {
                    ddlND_Gioitinh.SelectedValue = "1";
                }
                else if (oDuongSu.GIOITINH == 0)
                {
                    ddlND_Gioitinh.SelectedValue = "0";
                }
                if (oDuongSu.SINHSONG_NUOCNGOAI == 1)
                {
                    chkND_ONuocNgoai.Checked = true;
                }
                else
                {
                    chkND_ONuocNgoai.Checked = false;
                }
                if (oDuongSu.NAMSINH == 0)
                {
                    txtND_Namsinh.Text = "";
                    txtND_Ngaysinh.Text = "";
                }
                else
                {
                    txtND_Namsinh.Text = oDuongSu.NAMSINH.ToString();
                    if (oDuongSu.NGAYSINH == null)
                    {
                        if (txtND_Namsinh.Text.Length == 4)
                        {
                            string NgaySinhstr = "";
                            if (txtND_Ngaysinh.Text == "")
                            {
                                NgaySinhstr = "";
                                txtND_Ngaysinh.Text = NgaySinhstr;
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
                        else
                        {
                            txtND_Ngaysinh.Text = "";
                        }
                    }
                    else
                    {
                        if (oDuongSu.NGAYSINH != DateTime.MinValue)
                        {
                            txtND_Ngaysinh.Text = ((DateTime)oDuongSu.NGAYSINH).ToString("dd/MM/yyyy", cul);
                        }
                        else
                        {
                            txtND_Ngaysinh.Text = "";
                        }
                    }
                }
                txtND_TTChitiet.Text = oDuongSu.TAMTRUCHITIET;
                txtND_Tuoi.Text = oDuongSu.TUOI.ToString();
                txtND_NoiLamViec.Text = oDuongSu.DIACHICOQUAN;
                txtND_Email.Text = oDuongSu.EMAIL;
                txtND_Dienthoai.Text = oDuongSu.DIENTHOAI;
                txtND_Fax.Text = oDuongSu.FAX;
                if (oDuongSu.TAMTRUTINHID != null)
                {
                    ddlTamTru_Tinh_NguyenDon.SelectedValue = oDuongSu.TAMTRUTINHID.ToString();
                    LoadDropNoiSongHuyen();
                    try
                    {
                        if (oDuongSu.TAMTRUID != null) ddlTamTru_Huyen_NguyenDon.SelectedValue = oDuongSu.TAMTRUID.ToString();
                    }
                    catch (Exception ex) { }
                }
                txtND_NDD_Ten.Text = oDuongSu.NGUOIDAIDIEN;
                txtND_NDD_Chucvu.Text = oDuongSu.CHUCVU;
                if (oDuongSu.NDD_DIACHIID != null)
                {
                    DM_HANHCHINH Huyen_NDD_NguyenDon = dt.DM_HANHCHINH.Where(x => x.ID == oDuongSu.NDD_DIACHIID).FirstOrDefault<DM_HANHCHINH>();
                    if (Huyen_NDD_NguyenDon != null)
                    {
                        ddlNDD_Tinh_NguyenDon.SelectedValue = Huyen_NDD_NguyenDon.CAPCHAID.ToString();
                        LoadDropNDD_Huyen_NguyenDon();
                        ddlNDD_Huyen_NguyenDon.SelectedValue = Huyen_NDD_NguyenDon.ID.ToString();
                    }
                }
                txtND_NDD_Diachichitiet.Text = oDuongSu.NDD_DIACHICHITIET;
            }
        }

        protected void DropDownListDuongSu_SelectedIndexChanged(object sender, EventArgs e)
        {
            decimal donidBD = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH]);
            int idDuongSuBD = Convert.ToInt32(DropDownListDuongSu.SelectedValue);
            if (DropDownListDuongSu.SelectedValue == "0")
            {
                txtBD_Ten.Enabled = true;
                ddlLoaiBidon.Enabled = true;
                txtBD_CMND.Enabled = true;
                chkBoxCMNDBD.Enabled = true;
                txtBD_Ngaysinh.Enabled = true;
                txtBD_Namsinh.Enabled = true;
                ddlBD_Gioitinh.Enabled = true;
                ddlTamTru_Tinh_BiDon.Enabled = true;
                ddlTamTru_Huyen_BiDon.Enabled = true;
                txtBD_NDD_Diachichitiet.Enabled = true;
                txtBD_Email.Enabled = true;
                txtBD_Dienthoai.Enabled = true;
                txtBD_Fax.Enabled = true;
                chkISBVQLNK.Enabled = true;
                chkBD_ONuocNgoai.Enabled = true;
                ddlBD_Quoctich.Enabled = true;
                ddlNDD_Tinh_BiDon.Enabled = true;
                ddlNDD_Huyen_BiDon.Enabled = true;
                txtBD_NDD_ten.Enabled = true;
                txtBD_NDD_Chucvu.Enabled = true;
                txtBD_NoiLamViec.Enabled = true;
                txtBD_Tamtru_Chitiet.Enabled = true;
            }
            else
            {
                AHN_DON_DUONGSU oDS = dt.AHN_DON_DUONGSU.Where(x => x.DONID == donidBD && x.ID == idDuongSuBD).FirstOrDefault();
                if (oDS.TENDUONGSU != null) txtBD_Ten.Enabled = false; else txtBD_Ten.Enabled = true;
                if (oDS.LOAIDUONGSU != null) ddlLoaiBidon.Enabled = false; else ddlLoaiBidon.Enabled = true;
                txtBD_CMND.Enabled = false;
                chkBoxCMNDBD.Enabled = false;
                if (oDS.LOAIDUONGSU == 1)
                {
                    if (oDS.GIOITINH != null) ddlBD_Gioitinh.Enabled = false; else ddlBD_Gioitinh.Enabled = true;
                    if (oDS.NGAYSINH != null && oDS.NGAYSINH != DateTime.MinValue) txtBD_Ngaysinh.Enabled = false; else txtBD_Ngaysinh.Enabled = true;
                    if (oDS.NAMSINH != null && oDS.NAMSINH != 0) txtBD_Namsinh.Enabled = false; else txtBD_Namsinh.Enabled = true;
                    if (oDS.TAMTRUTINHID != null && oDS.TAMTRUTINHID != 0) ddlTamTru_Tinh_BiDon.Enabled = false; else ddlTamTru_Tinh_BiDon.Enabled = true;
                    if (oDS.TAMTRUID != null && oDS.TAMTRUID != 0) ddlTamTru_Huyen_BiDon.Enabled = false; else ddlTamTru_Huyen_BiDon.Enabled = true;
                    if (oDS.TAMTRUCHITIET != null) txtBD_Tamtru_Chitiet.Enabled = false; else txtBD_Tamtru_Chitiet.Enabled = true;
                    if (oDS.DIACHICOQUAN != null) txtBD_NoiLamViec.Enabled = false; else txtBD_NoiLamViec.Enabled = true;
                }
                if (oDS.LOAIDUONGSU == 2 || oDS.LOAIDUONGSU == 3)
                {
                    if (oDS.TAMTRUTINHID != null && oDS.TAMTRUTINHID != 0) ddlNDD_Tinh_BiDon.Enabled = false; else ddlNDD_Tinh_BiDon.Enabled = true;
                    if (oDS.NDD_DIACHIID != null && oDS.NDD_DIACHIID != 0) ddlNDD_Huyen_BiDon.Enabled = false; else ddlNDD_Huyen_BiDon.Enabled = true;
                    if (oDS.NDD_DIACHICHITIET != null) txtBD_NDD_Diachichitiet.Enabled = false; else txtBD_NDD_Diachichitiet.Enabled = true;
                    if (oDS.NGUOIDAIDIEN != null) txtBD_NDD_ten.Enabled = false; else txtBD_NDD_ten.Enabled = true;
                    if (oDS.CHUCVU != null) txtBD_NDD_Chucvu.Enabled = false; else txtBD_NDD_Chucvu.Enabled = true;
                }
                if (oDS.EMAIL != null) txtBD_Email.Enabled = false; else txtBD_Email.Enabled = true;
                if (oDS.DIENTHOAI != null) txtBD_Dienthoai.Enabled = false; else txtBD_Dienthoai.Enabled = true;
                if (oDS.FAX != null) txtBD_Fax.Enabled = false; else txtBD_Fax.Enabled = true;
                if (oDS.QUOCTICHID != null) ddlBD_Quoctich.Enabled = false; else ddlBD_Quoctich.Enabled = true;
            }
            if (idDuongSuBD == 0)
            {
                ddlLoaiBidon.SelectedValue = "1";
                txtBD_Ten.Text = "";
                txtBD_CMND.Text = "";
                chkBoxCMNDND.Checked = false;
                ddlBD_Gioitinh.SelectedValue = "0";
                chkBD_ONuocNgoai.Checked = false;
                txtBD_Ngaysinh.Text = "";
                txtBD_Namsinh.Text = "";
                txtBD_Tamtru_Chitiet.Text = "";
                txtBD_NoiLamViec.Text = "";
                txtBD_Email.Text = "";
                txtBD_Dienthoai.Text = "";
                txtBD_Fax.Text = "";
                ddlBD_Quoctich.SelectedValue = "2";
                Cls_Comon.SetValueComboBox(ddlTamTru_Tinh_BiDon, Session[ENUM_SESSION.SESSION_TINH_ID]);
                LoadDropNoiSongHuyenBD();
                Cls_Comon.SetValueComboBox(ddlTamTru_Huyen_BiDon, Session[ENUM_SESSION.SESSION_QUAN_ID]);
                pnBD_Canhan.Visible = true;
                pnBD_Tochuc.Visible = false;
            }

            else
            {

                AHN_DON_DUONGSU oDuongSu = dt.AHN_DON_DUONGSU.Where(x => x.DONID == donidBD && x.ID == idDuongSuBD).FirstOrDefault();
                if (oDuongSu.LOAIDUONGSU == 1)
                {
                    ddlLoaiBidon.SelectedValue = "1";
                    pnBD_Canhan.Visible = true;
                    pnBD_Tochuc.Visible = false;
                }
                else if (oDuongSu.LOAIDUONGSU == 2)
                {
                    ddlLoaiBidon.SelectedValue = "2";
                    pnBD_Canhan.Visible = false;
                    pnBD_Tochuc.Visible = true;
                }
                else if (oDuongSu.LOAIDUONGSU == 3)
                {
                    ddlLoaiBidon.SelectedValue = "3";
                    pnBD_Canhan.Visible = false;
                    pnBD_Tochuc.Visible = true;
                }
                txtBD_Ten.Text = oDuongSu.TENDUONGSU;
                if (oDuongSu.SOCMND == null)
                {
                    chkBoxCMNDBD.Checked = true;
                    txtBD_CMND.Text = "";
                }
                else
                {
                    chkBoxCMNDBD.Checked = false;
                    txtBD_CMND.Text = oDuongSu.SOCMND;
                }

                ddlBD_Quoctich.SelectedValue = oDuongSu.QUOCTICHID.ToString();
                if (oDuongSu.GIOITINH == 1)
                {
                    ddlBD_Gioitinh.SelectedValue = "1";
                }
                else if (oDuongSu.GIOITINH == 0)
                {
                    ddlBD_Gioitinh.SelectedValue = "0";
                }
                if (oDuongSu.SINHSONG_NUOCNGOAI == 1)
                {
                    chkBD_ONuocNgoai.Checked = true;
                }
                else
                {
                    chkBD_ONuocNgoai.Checked = false;
                }
                if (oDuongSu.NAMSINH == 0)
                {
                    txtBD_Namsinh.Text = "";
                    txtBD_Ngaysinh.Text = "";
                }
                else
                {
                    txtBD_Namsinh.Text = oDuongSu.NAMSINH.ToString();
                    if (oDuongSu.NGAYSINH == null)
                    {
                        if (txtBD_Namsinh.Text.Length == 4)
                        {
                            string NgaySinhstr = "";
                            if (txtBD_Ngaysinh.Text == "")
                            {
                                NgaySinhstr = "";
                                txtBD_Ngaysinh.Text = NgaySinhstr;
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
                        else
                        {
                            txtND_Ngaysinh.Text = "";
                        }
                    }
                    else
                    {
                        if (oDuongSu.NGAYSINH != DateTime.MinValue)
                        {
                            txtBD_Ngaysinh.Text = ((DateTime)oDuongSu.NGAYSINH).ToString("dd/MM/yyyy", cul);
                        }
                        else
                        {
                            txtBD_Ngaysinh.Text = "";
                        }
                    }
                }
                txtBD_Tamtru_Chitiet.Text = oDuongSu.TAMTRUCHITIET;
                txtBD_NoiLamViec.Text = oDuongSu.DIACHICOQUAN;
                txtBD_Email.Text = oDuongSu.EMAIL;
                txtBD_Tuoi.Text = oDuongSu.TUOI.ToString();
                txtBD_Dienthoai.Text = oDuongSu.DIENTHOAI;
                txtBD_Fax.Text = oDuongSu.FAX;
                if (oDuongSu.TAMTRUTINHID != null)
                {
                    ddlTamTru_Tinh_BiDon.SelectedValue = oDuongSu.TAMTRUTINHID.ToString();
                    LoadDropNoiSongHuyenBD();
                    try
                    {
                        if (oDuongSu.TAMTRUID != null) ddlTamTru_Huyen_BiDon.SelectedValue = oDuongSu.TAMTRUID.ToString();
                    }
                    catch (Exception ex) { }
                }
                txtBD_NDD_ten.Text = oDuongSu.NGUOIDAIDIEN;
                txtBD_NDD_Chucvu.Text = oDuongSu.CHUCVU;
                if (oDuongSu.NDD_DIACHIID != null)
                {
                    DM_HANHCHINH Huyen_NDD_BiDon = dt.DM_HANHCHINH.Where(x => x.ID == oDuongSu.NDD_DIACHIID).FirstOrDefault<DM_HANHCHINH>();
                    if (Huyen_NDD_BiDon != null)
                    {
                        ddlNDD_Tinh_BiDon.SelectedValue = Huyen_NDD_BiDon.CAPCHAID.ToString();
                        LoadDropNDD_Huyen_BiDon();
                        ddlNDD_Huyen_BiDon.SelectedValue = Huyen_NDD_BiDon.ID.ToString();
                    }
                }
                txtBD_NDD_Diachichitiet.Text = oDuongSu.NDD_DIACHICHITIET;
            }
        }
        private void LoadDropNoiSongHuyen()
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

        private void LoadDropNoiSongHuyenBD()
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
        protected void cmdLoadDsKhac_Click(object sender, EventArgs e)
        {
            DsDuongSu.LoadGrid();
            LoaddsDuongSu();
        }

        void LoaddsDuongSu()
        {
            decimal DonCT = 0;
            //Load đương sự
            if (Request.QueryString["DONGHEPID"] != "")
            {
                DonCT = Convert.ToDecimal(Request.QueryString["DONGHEPID"]);
            }
            else
            {
                DonCT = Convert.ToDecimal(hddID.Value);
            }
            decimal donid = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH]);
            AHN_DON_DUONGSU_BL ADS_BL = new AHN_DON_DUONGSU_BL();
            DataTable DuongSu = ADS_BL.AHN_DON_DUONGSU_Getall(DonCT, donid);
            ddlListDuongSu.DataSource = DuongSu;
            ddlListDuongSu.DataTextField = "TENDUONGSU";
            ddlListDuongSu.DataValueField = "ID";
            ddlListDuongSu.DataBind();
            ddlListDuongSu.Items.Insert(0, new ListItem("Đương sự mới", "0"));

            DataTable DuongSuBD = ADS_BL.AHN_DON_DUONGSU_Getall_BiDon(DonCT, donid);
            DropDownListDuongSu.DataSource = DuongSuBD;
            DropDownListDuongSu.DataTextField = "TENDUONGSU";
            DropDownListDuongSu.DataValueField = "ID";
            DropDownListDuongSu.DataBind();
            DropDownListDuongSu.Items.Insert(0, new ListItem("Đương sự mới", "0"));
        }

    }
}