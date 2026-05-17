using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using System;
using System.Text;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WEB.GSTP.QLAN.GDTTT.In;
using BL.GSTP.BANGSETGET;
using BL.GSTP.GDTTT;

namespace WEB.GSTP.QLAN.GDTTT.Giaiquyet
{
    public partial class Danhsach_TP : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private const decimal ROOT = 0;
        public Decimal PhongBanID, CurrDonViID, USERID = 0;
        public string Loaian = "0";
        public bool GetBool(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return false;
                else
                    return Convert.ToBoolean(obj);
            }
            catch (Exception ex)
            { return false; }
        }
        public string GetDate(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return "";
                else
                    return Convert.ToDateTime(obj).ToString("dd/MM/yyyy");
            }
            catch (Exception ex)
            { return ""; }
        }
        String SessionInBC = "GDTTTDon_INBC_VISIBLE";
        String SessionSearch = "TTBCVISIBLE";
        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            scriptManager.RegisterPostBackControl(this.cmdInDonDaNhan);
            scriptManager.RegisterPostBackControl(this.cmdInDonChuyen);


            CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            PhongBanID = (String.IsNullOrEmpty(strPBID + "")) ? 0 : Convert.ToDecimal(strPBID);
            USERID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);

            if (!IsPostBack)
            {
                if ((Session[SessionSearch] + "") == "0")
                {
                    lbtTTBC.Text = "[ Mở ]";
                    pnTTBC.Visible = false;
                }
                if ((Session[SessionSearch] + "") == "0")
                {
                    lbtTTTK.Text = "[ Thu gọn ]";
                    pnTTTK.Visible = true;
                }

                txtBC_Ngay.Text = DateTime.Now.ToString("dd/MM/yyyy");
                LoadDropTinh();
                LoadPhongban();
                //LoadDropTTV_TheoCanBoLogin();
                //load loai an
                LoadDropLoaiAn();

                SetGetSessionTK(false);
                Load_Data();
                set_button();
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath
                    , Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                SetTieuDeBaoCao();


            }
            //LoadPhongban();
        }
        private void SetGetSessionTK(bool isSet)
        {
            try
            {
                if (isSet)
                {
                    Session[SS_TK.ISHOME] = "0";
                    Session[SS_TK.NGUOIGUI] = txtNguoigui.Text;
                    Session[SS_TK.SOBAQD] = txtSoQDBA.Text;
                    Session[SS_TK.NGAYBAQD] = txtNgayBAQD.Text;
                    Session[SS_TK.TOAANXX] = ddlToaXetXu.SelectedValue;
                    Session[SS_TK.NGAYNHANTU] = txtNgayNhanTu.Text;
                    Session[SS_TK.NGAYNHANDEN] = txtNgayNhanDen.Text;

                    Session[SS_TK.PHONGBANCHUYEN] = ddlPhongban.SelectedValue;

                    Session[SS_TK.NGAYCHUYENTU] = txtNgaychuyenTu.Text;
                    Session[SS_TK.NGAYCHUYENDEN] = txtNgaychuyenDen.Text;

                    Session[SS_TK.THULYDON] = ddlThuLy.SelectedValue;
                    Session[SS_TK.HINHTHUCDON] = ddlHinhthucdon.SelectedValue;
                    Session[SS_TK.SOCMND] = txtSoCMND.Text;
                    Session[SS_TK.MADON] = txtSohieudon.Text;
                    Session[SS_TK.TINHID] = ddlTinh.SelectedValue;
                    Session[SS_TK.HUYENID] = ddlHuyen.SelectedValue;
                    Session[SS_TK.DIACHICHITIET] = txtDiachi.Text;
                    //Session[SS_TK.TRALOIDON] = ddlTraloi.SelectedValue;

                    Session[SS_TK.SOCV] = txtCV_So.Text;
                    Session[SS_TK.NGAYCV] = txtCV_Ngay.Text;
                    Session[SS_TK.TRANGTHAICHUYEN] = rdbTrangThai.SelectedValue;

                    Session[SS_TK.THULY_TU] = txtThuly_Tu.Text;
                    Session[SS_TK.THULY_DEN] = txtThuly_Den.Text;
                    Session[SS_TK.SOTHULY] = txtThuly_So.Text;

                    Session[SS_TK.LOAIAN] = ddlLoaiAn.SelectedValue;
                    Session[SS_TK.THAMTRAVIEN] = 0;//ddlThamtravien.SelectedValue;
                    Session[SS_TK.GhepDon_VuAn] = rdGhepVuAn.SelectedValue;

                }
                else
                {
                    int IsHome = (string.IsNullOrEmpty(Session[SS_TK.ISHOME] + "")) ? 0 : Convert.ToInt16(Session[SS_TK.ISHOME] + "");
                    if (IsHome == 1)
                    {
                        txtNguoigui.Text = Session[SS_TK.NGUOIGUI] + "";
                        txtSoQDBA.Text = Session[SS_TK.SOBAQD] + "";
                        txtNgayBAQD.Text = Session[SS_TK.NGAYBAQD] + "";
                        if (Session[SS_TK.TOAANXX] != null) ddlToaXetXu.SelectedValue = Session[SS_TK.TOAANXX] + "";
                        txtNgayNhanTu.Text = Session[SS_TK.NGAYNHANTU] + "";
                        txtNgayNhanDen.Text = Session[SS_TK.NGAYNHANDEN] + "";

                        if (Session[SS_TK.PHONGBANCHUYEN] != null) ddlPhongban.SelectedValue = Session[SS_TK.PHONGBANCHUYEN] + "";
                        txtNgaychuyenTu.Text = Session[SS_TK.NGAYCHUYENTU] + "";
                        txtNgaychuyenDen.Text = Session[SS_TK.NGAYCHUYENDEN] + "";
                        if (Session[SS_TK.THULYDON] != null) ddlThuLy.SelectedValue = Session[SS_TK.THULYDON] + "";
                        if (Session[SS_TK.HINHTHUCDON] != null) ddlHinhthucdon.SelectedValue = Session[SS_TK.HINHTHUCDON] + "";
                        txtSoCMND.Text = Session[SS_TK.SOCMND] + "";
                        txtSohieudon.Text = Session[SS_TK.MADON] + "";
                        if (Session[SS_TK.TINHID] != null) ddlTinh.SelectedValue = Session[SS_TK.TINHID] + "";
                        ddlTinh_SelectedIndexChanged(null, null);
                        if (Session[SS_TK.HUYENID] != null) ddlHuyen.SelectedValue = Session[SS_TK.HUYENID] + "";
                        txtDiachi.Text = Session[SS_TK.DIACHICHITIET] + "";
                        //if (Session[SS_TK.TRALOIDON] != null) ddlTraloi.SelectedValue = Session[SS_TK.TRALOIDON] + "";

                        txtCV_So.Text = Session[SS_TK.SOCV] + "";
                        txtCV_Ngay.Text = Session[SS_TK.NGAYCV] + "";
                        if (Session[SS_TK.TRANGTHAICHUYEN] != null) rdbTrangThai.SelectedValue = Session[SS_TK.TRANGTHAICHUYEN] + "";

                        txtThuly_Tu.Text = Session[SS_TK.THULY_TU] + "";
                        txtThuly_Den.Text = Session[SS_TK.THULY_DEN] + "";
                        txtThuly_So.Text = Session[SS_TK.SOTHULY] + "";
                        if (Session[SS_TK.LOAIAN] != null) ddlLoaiAn.SelectedValue = Session[SS_TK.LOAIAN] + "";

                    }
                }
            }
            catch (Exception ex) { }
        }
        private DataTable GetDSKemDonTrung(bool isCV, bool isTraigiam, bool isChiDao)
        {
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            decimal ToaRaBAQD = Convert.ToDecimal(ddlToaXetXu.SelectedValue);
            decimal HinhThucDon = Convert.ToDecimal(ddlHinhthucdon.SelectedValue);
            Decimal DiaChiTinh = Convert.ToDecimal(ddlTinh.SelectedValue);
            Decimal DiaChiHuyen = Convert.ToDecimal(ddlHuyen.SelectedValue);//, TraLoi = Convert.ToDecimal(ddlTraloi.SelectedValue)
            string SoBAQD = txtSoQDBA.Text.Trim();
            String NgayBAQD = txtNgayBAQD.Text;
            string NguoiGui = txtNguoigui.Text.Trim(), strNguoiNhap = "";
            string SoCMND = txtSoCMND.Text.Trim();
            string SoHieuDon = txtSohieudon.Text.Trim();
            string DiaChiCT = txtDiachi.Text.Trim();
            string SoCongVan = txtCV_So.Text.Trim();
            string NgayCongVan = txtCV_Ngay.Text;
            DateTime? TuNgay = txtNgayNhanTu.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayNhanTu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime? DenNgay = txtNgayNhanDen.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayNhanDen.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            if (isCV) HinhThucDon = 3;

            bool isOnPrint = true;
            string vArrSelectID = "";
            if (isOnPrint)
            {
                foreach (DataGridItem Item in dgList.Items)
                {
                    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                    if (chkChon.Checked)
                    {
                        if (vArrSelectID == "") vArrSelectID = chkChon.ToolTip;
                        else vArrSelectID = vArrSelectID + "," + chkChon.ToolTip;
                    }
                }
            }
            if (vArrSelectID != "") vArrSelectID = "," + vArrSelectID + ",";

            decimal vNoichuyen = -1;
            decimal vTrangthai = Convert.ToDecimal(rdbTrangThai.SelectedValue);
            decimal vCD_DONVIID = Convert.ToDecimal(ddlPhongban.SelectedValue);

            DateTime? vNgaychuyenTu = txtNgaychuyenTu.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgaychuyenTu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime? vNgaychuyenDen = txtNgaychuyenDen.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgaychuyenDen.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            decimal vIsThuLy = Convert.ToDecimal(ddlThuLy.SelectedValue);
            decimal vPhanloaixuly = Convert.ToDecimal(ddlPhanloaiDdon.SelectedValue);
            if (ddlThuLy.Visible == false) vIsThuLy = -1;

            DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            string vSoThuly = txtThuly_So.Text;
            decimal vPhancongTTV = 0;//Convert.ToDecimal(ddlThamtravien.SelectedValue);
            decimal vloaian = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
            DataTable oDT = oBL.GDTTT_DON_KEM_DONTRUNG_SEARCH(ToaAnID, ToaRaBAQD, SoBAQD, NgayBAQD, NguoiGui
                , SoCMND, TuNgay, DenNgay, HinhThucDon, SoHieuDon, DiaChiTinh, DiaChiHuyen
                , DiaChiCT, SoCongVan, NgayCongVan, 0, strNguoiNhap, vNoichuyen
                , vTrangthai, vCD_DONVIID, vNgaychuyenTu, vNgaychuyenDen
                , vArrSelectID, vIsThuLy, vPhanloaixuly
                , vNgayThulyTu, vNgayThulyDen, vSoThuly, vPhancongTTV, vloaian);
            return oDT;
        }
        private DataTable getDS(bool isCV, bool isOnPrint, bool isTraigiam, bool isChiDao)
        {
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            decimal ToaRaBAQD = Convert.ToDecimal(ddlToaXetXu.SelectedValue);
            decimal HinhThucDon = Convert.ToDecimal(ddlHinhthucdon.SelectedValue);
            Decimal DiaChiTinh = Convert.ToDecimal(ddlTinh.SelectedValue);
            Decimal DiaChiHuyen = Convert.ToDecimal(ddlHuyen.SelectedValue);//, TraLoi = Convert.ToDecimal(ddlTraloi.SelectedValue)
            string SoBAQD = txtSoQDBA.Text.Trim();
            String NgayBAQD = txtNgayBAQD.Text;
            string NguoiGui = txtNguoigui.Text.Trim(), strNguoiNhap = "";
            string SoCMND = txtSoCMND.Text.Trim();
            string SoHieuDon = txtSohieudon.Text.Trim();
            string DiaChiCT = txtDiachi.Text.Trim();
            string SoCongVan = txtCV_So.Text.Trim();
            string NgayCongVan = txtCV_Ngay.Text;
            string v_user_loign = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            DateTime? TuNgay = txtNgayNhanTu.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayNhanTu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime? DenNgay = txtNgayNhanDen.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayNhanDen.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            if (isCV) HinhThucDon = 3;

            string vArrSelectID = "";
            if (isOnPrint)
            {
                foreach (DataGridItem Item in dgList.Items)
                {
                    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                    if (chkChon.Checked)
                    {
                        if (vArrSelectID == "") vArrSelectID = chkChon.ToolTip;
                        else vArrSelectID = vArrSelectID + "," + chkChon.ToolTip;
                    }
                }
            }
            if (vArrSelectID != "") vArrSelectID = "," + vArrSelectID + ",";

            decimal vNoichuyen = Convert.ToDecimal(ddlPhongban.SelectedValue);
            decimal vTrangthai = Convert.ToDecimal(rdbTrangThai.SelectedValue);
            decimal vCD_DONVIID = Convert.ToDecimal(ddlPhongban.SelectedValue);
            DateTime? vNgaychuyenTu = txtNgaychuyenTu.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgaychuyenTu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime? vNgaychuyenDen = txtNgaychuyenDen.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgaychuyenDen.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            decimal vIsThuLy = Convert.ToDecimal(ddlThuLy.SelectedValue);
            decimal vPhanloaixuly = Convert.ToDecimal(ddlPhanloaiDdon.SelectedValue);
            if (ddlThuLy.Visible == false) vIsThuLy = -1;

            DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            string vSoThuly = txtThuly_So.Text;

            decimal vPhancongTTV = 0;                //Convert.ToDecimal(ddlThamtravien.SelectedValue);
            //them loai an 
            decimal vLoaiAn = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
            decimal vGiaoTHS = 0;
            int page_size = Convert.ToInt32(ddlPageCount.SelectedValue);
            int pageindex = Convert.ToInt32(hddPageIndex.Value);
            if (isOnPrint) page_size = 10000;
            int status_ghepvuan = Convert.ToInt16(rdGhepVuAn.SelectedValue);
            //anhvh phân quyên liên quan đến án tử hình
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            decimal _ISXINANGIAM = Convert.ToDecimal(oPer.ISXINANGIAM);
            decimal _GDT_ISXINANGIAM = Convert.ToDecimal(oPer.GDT_ISXINANGIAM);
            //-------------------
            DataTable oDT;

            if (vTrangthai == 5) //tìm danh sách vụ án kháng nghị của thẩm phán đang đăng nhập
            {
                oDT = oBL.VAKN_GIAIQUYET_SEARCH_TP(v_user_loign, ToaAnID, ToaRaBAQD, SoBAQD, NgayBAQD, NguoiGui,
                                        SoCMND, TuNgay, DenNgay, HinhThucDon, SoHieuDon, DiaChiTinh, DiaChiHuyen
                                        , DiaChiCT, SoCongVan, NgayCongVan, 0, strNguoiNhap, vNoichuyen,
                                        vTrangthai, vCD_DONVIID, vNgaychuyenTu, vNgaychuyenDen
                                        , vArrSelectID, vIsThuLy, vPhanloaixuly
                                        , vNgayThulyTu, vNgayThulyDen, vSoThuly, vPhancongTTV, vLoaiAn, vGiaoTHS, status_ghepvuan, _ISXINANGIAM, _GDT_ISXINANGIAM
                                        , pageindex, page_size);
            }
            else
            {
                oDT = oBL.GDTTT_GIAIQUYET_SEARCH_TP(v_user_loign, ToaAnID, ToaRaBAQD, SoBAQD, NgayBAQD, NguoiGui,
                                        SoCMND, TuNgay, DenNgay, HinhThucDon, SoHieuDon, DiaChiTinh, DiaChiHuyen
                                        , DiaChiCT, SoCongVan, NgayCongVan, 0, strNguoiNhap, vNoichuyen,
                                        vTrangthai, vCD_DONVIID, vNgaychuyenTu, vNgaychuyenDen
                                        , vArrSelectID, vIsThuLy, vPhanloaixuly
                                        , vNgayThulyTu, vNgayThulyDen, vSoThuly, vPhancongTTV, vLoaiAn, vGiaoTHS, status_ghepvuan, _ISXINANGIAM, _GDT_ISXINANGIAM
                                        , pageindex, page_size);
            }

            return oDT;
        }
        private void Load_Data()
        {

            DataTable oDT = getDS(false, false, false, false);

            int count_all = 0;
            if (oDT.Rows.Count > 0)
                count_all = Convert.ToInt32(oDT.Rows[0]["CountAll"] + "");
            if (oDT != null && count_all > 0)
            {
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, Convert.ToInt32(ddlPageCount.SelectedValue)).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString() + " </b> đơn trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
            }
            else
            {
                hddTotalPage.Value = "1";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                           lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                lstSobanghiT.Text = lstSobanghiB.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";
            }

            dgList.PageSize = Convert.ToInt32(ddlPageCount.SelectedValue);
            dgList.DataSource = oDT;
            dgList.DataBind();

        }
        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
            SetGetSessionTK(true);
        }


        #region "Phân trang"

        protected void lbTBack_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 2).ToString();
            Load_Data();
        }

        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            // dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            Load_Data();
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            // dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            Load_Data();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            //dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex.Value = lbCurrent.Text;
            Load_Data();
        }

        protected void ddlPageCount_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount2.SelectedValue = ddlPageCount.SelectedValue;
            //  dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        protected void ddlPageCount2_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount.SelectedValue = ddlPageCount2.SelectedValue;
            // dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        #endregion

        protected void ddlPhongban_SelectedIndexChanged(object sender, EventArgs e)
        {

            LoadLoaiAn(Convert.ToDecimal(ddlPhongban.SelectedValue));

            if (ddlPhongban.SelectedValue == "0")
            {
                cmdInDonChuyen.Enabled = false;
                btnLuuVB.Enabled = false;
            }
            else
            {
                cmdInDonChuyen.Enabled = true;
                btnLuuVB.Enabled = true;
            }

        }
        private void LoadLoaiAn(decimal PBID)
        {
            ddlLoaiAn.Items.Clear();
            if (PBID > 0)
            {
                DM_PHONGBAN obj = dt.DM_PHONGBAN.Where(x => x.ID == PBID).FirstOrDefault() ?? new DM_PHONGBAN();
                if (obj.ISHINHSU == 1) ddlLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
                if (obj.ISDANSU == 1) ddlLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
                if (obj.ISHANHCHINH == 1) ddlLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
                if (obj.ISHNGD == 1) ddlLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
                if (obj.ISKDTM == 1) ddlLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
                if (obj.ISLAODONG == 1) ddlLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
                if (obj.ISPHASAN == 1) ddlLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC.AN_PHASAN));
            }
            else
            {
                ddlLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
                ddlLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
                ddlLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
                ddlLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
                ddlLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
                ddlLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
                ddlLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC.AN_PHASAN));
            }
            ddlLoaiAn.Items.Add(new ListItem("Chưa xác định", "55"));
            ddlLoaiAn.Items.Insert(0, new ListItem("Tất cả", "0"));
            //----------anhvh add 20/08/2020 check thêm nếu là phó chánh an thì chỉ lấy những loại án của PCA đó-------------------------
            Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault();

        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            int with_popup = 950;
            int height_popup = 750;
            string Strxt = "";
            Session[SS_TK.HCTP_GHICHU] = txtBC_Ghichu.Text;
            Loaian = ddlLoaiAn.SelectedValue;//Session[SS_TK.LOAIAN]+"";
            if (Loaian == "")
                Loaian = Session[SS_TK.LOAIAN] + "";
            //----------
            switch (e.CommandName)
            {
                case "NewVA":
                    String ND_id = e.CommandArgument.ToString();
                    String[] ND_id_arr = ND_id.Split(';');
                    if (Loaian == "01")
                    {
                        Strxt = "PopupReport('/QLAN/GDTTT/Giaiquyet/Popup/pVuAnHS.aspx?vid=" + ND_id_arr[0] + "&IsMapVuAn=" + ND_id_arr[1] + "&IsThuLy=" + ND_id_arr[2]
                            + "&ARRDONTRUNG=" + ND_id_arr[3] + "&vNgayNhan=" + txtBC_Ngay.Text + "&PhongbanID=" + ddlPhongban.SelectedValue
                            + "','Thêm mới vụ án'," + with_popup + "," + height_popup + ");";
                    }
                    else
                    {
                        Strxt = "PopupReport('/QLAN/GDTTT/Giaiquyet/Popup/pVuAn.aspx?vid=" + ND_id_arr[0] + "','Thêm mới vụ án'," + with_popup + "," + height_popup + ");";
                    }
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), Strxt, true);
                    break;
                case "ThuLyLai":
                    Strxt = "PopupReport('/QLAN/GDTTT/Giaiquyet/Popup/pVuAn.aspx?type=1&vid=" + e.CommandArgument + "','Thêm mới vụ án'," + with_popup + "," + height_popup + ");";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), Strxt, true);
                    break;
                case "don_chuadu_dk":
                    string StrMsgArr_dk = "PopupReport('/QLAN/GDTTT/Hoso/Popup/Lichsudong_du_dk.aspx?arrid=" + e.CommandArgument + "&thamphan=1','Danh sách đơn trùng',1000,500);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsgArr_dk, true);
                    break;
                //case "SoDonTrung":
                //    HiddenField hddDCID = (HiddenField)e.Item.FindControl("hddDCID");
                //    string StrMsgArr = "PopupReport('/QLAN/GDTTT/VuAn/Popup/pDsDon.aspx?vdcid=" + hddDCID.Value + "&arrid=" + e.CommandArgument + "','Danh sách đơn trùng'," + with_popup + "," + height_popup + ");";
                //    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsgArr, true);
                //    break;
                case "GHEPVA":
                    Strxt = "PopupReport('/QLAN/GDTTT/VuAn/Popup/pGhepVA.aspx?did=" + e.CommandArgument + "','Ghép vụ án'," + (with_popup + 200) + "," + height_popup + ");";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), Strxt, true);
                    break;
                case "HUY_GHEPVA":
                    Huy_GhepVA(Convert.ToDecimal(e.CommandArgument));
                    break;
            }
        }
        void Huy_GhepVA(Decimal DonID)
        {
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            decimal PhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");
            Decimal VuAnID = 0;
            GDTTT_DON obj = dt.GDTTT_DON.Where(x => x.ID == DonID).Single();
            if (obj != null)
            {
                VuAnID = (decimal)obj.VUVIECID;
                obj.VUVIECID = 0;
                //obj.CD_TRANGTHAI = 1;
                //obj.CD_NGAYXULY = null;
                dt.SaveChanges();
                //-------------------------------
                //-----update thong tin : tongdon, isanqh, isanchidao, arrnguoikhieunai
                GDTTT_DON_BL objBL = new GDTTT_DON_BL();
                objBL.Update_Don_TH(VuAnID);

                hddPageIndex.Value = "1";
                Load_Data();
                lbtthongbao.Text = "Hủy ghép vụ án thành công!";
            }
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Header)
            {
                if (rdbTrangThai.SelectedValue == "3")
                {
                    e.Item.Cells[10].Text = "Lịch sử chuyển đơn";
                    dgList.Columns[11].Visible = true;
                }
            }
            else if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rv = (DataRowView)e.Item.DataItem;
                //HiddenField hddPhanLoaiDon = (HiddenField)e.Item.FindControl("hddPhanLoaiDon");
                int PhanLoaiDon = (string.IsNullOrEmpty(rv["PHANLOAIXULY"] + "")) ? 0 : Convert.ToInt16(rv["PHANLOAIXULY"] + "");

                HiddenField hddCurrDonID = (HiddenField)e.Item.FindControl("hddCurrDonID");
                Decimal CurrDonID = (String.IsNullOrEmpty(hddCurrDonID.Value)) ? 0 : Convert.ToDecimal(hddCurrDonID.Value);
                //------------------------------------------
                Literal lttThuLy = (Literal)e.Item.FindControl("lttThuLy");
                int TinhTrangThuLy = String.IsNullOrEmpty((rv["IsThuLy"] + "")) ? -1 : Convert.ToInt16(rv["IsThuLy"] + "");
                String temp = (String.IsNullOrEmpty(rv["TL_SO"] + "")) ? "" : "<b>" + rv["TL_So"] + "</b>";
                if (temp.Length > 0)
                    temp += "<br/>";
                temp += rv["TL_NGAY_TEXT"] + "";
                if (temp.Length > 0)
                    temp += "<br/>";
                temp += rv["TRANGTHAITHULY"] + "";

                lttThuLy.Text = temp;
                //------------------------------------------
                Decimal DonChuyenCung_ThuLyMoi_ID = String.IsNullOrEmpty((rv["DonThuLyMoi_ID"] + "")) ? 0 : Convert.ToDecimal(rv["DonThuLyMoi_ID"] + "");
                if (DonChuyenCung_ThuLyMoi_ID > 0)
                {
                    hddCurrDonID.Value = DonChuyenCung_ThuLyMoi_ID.ToString();
                    GDTTT_DON oDon = dt.GDTTT_DON.Where(x => x.ID == DonChuyenCung_ThuLyMoi_ID).Single();
                    temp = (String.IsNullOrEmpty(oDon.TL_SO + "")) ? "" : "<b>" + oDon.TL_SO + "</b>";
                    if (temp.Length > 0)
                        temp += "<br/>";
                    temp += String.IsNullOrEmpty(oDon.TL_NGAY + "") ? "" : Convert.ToDateTime(oDon.TL_NGAY).ToString("dd/MM/yyyy", cul);
                    if (temp.Length > 0)
                        temp += "<br/>";
                    temp += "Thụ lý mới";
                    lttThuLy.Text = temp;
                    TinhTrangThuLy = 1;
                }

                //------------------------------------------
                int trangthai = Convert.ToInt16(rdbTrangThai.SelectedValue);
                Panel pnVuAnInfo = (Panel)e.Item.FindControl("pnVuAnInfo");
                Panel pnTTV = (Panel)e.Item.FindControl("pnTTV");

                Literal lttNewVuAn = (Literal)e.Item.FindControl("lttNewVuAn");
                LinkButton lkThemVA = (LinkButton)e.Item.FindControl("lkThemVA");
                LinkButton lkGhepVuAn = (LinkButton)e.Item.FindControl("lkGhepVuAn");
                Literal lttTTV = (Literal)e.Item.FindControl("lttTTV");
                int IsMapVuAn = Convert.ToInt32(rv["IsMapVuAn"] + "");
                HiddenField hddVuAnID = (HiddenField)e.Item.FindControl("hddVuAnID");
                if (rdbTrangThai.SelectedValue == "3")
                {
                    List<GDTTT_DON_CHUYEN> lstChuyen = dt.GDTTT_DON_CHUYEN.Where(x => x.DONID == CurrDonID).ToList();
                    pnVuAnInfo.Visible = false;
                    lkThemVA.Visible = lkGhepVuAn.Visible = false;
                    //lttNewVuAn.Text = lstChuyen[0].GHICHU + "";
                    dgList.Columns[10].ItemStyle.HorizontalAlign = HorizontalAlign.Left;
                    lttNewVuAn.Text = rv["GHICHU_HIS"] + "";

                    Literal lttTLTrangthai = (Literal)e.Item.FindControl("lttTLTrangthai");
                    dgList.Columns[11].Visible = true;
                    lttTLTrangthai.Text = rv["TT_DON"] + "";
                    //HorizontalAlign.
                }
                else
                {
                    dgList.Columns[11].Visible = false;
                }
            }
        }

        protected void ddlTinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadNG_Huyen();
            }
            catch (Exception ex) { lstSobanghiT.Text = lstSobanghiB.Text = ex.Message; }
        }
        private void LoadPhongban()
        {
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            ddlPhongban.DataSource = dt.DM_PHONGBAN.Where(x => x.TOAANID == ToaAnID && x.ISGIAIQUYETDON == 1).ToList();
            //ddlPhongban.DataSource = dt.DM_PHONGBAN.Where(x => x.TOAANID == ToaAnID).ToList();
            ddlPhongban.DataTextField = "TENPHONGBAN";
            ddlPhongban.DataValueField = "ID";
            ddlPhongban.DataBind();
            ddlPhongban.Items.Insert(0, new ListItem("--Chọn đơn vị--", "0"));
            //if (strPBID != "") ddlPhongban.SelectedValue = strPBID;
            //ddlPhongban.Enabled = false;

        }
        private void LoadDropTinh()
        {
            //Load loại sổ văn bản
            DM_DATAITEM_BL soBL = new DM_DATAITEM_BL();
            DataTable tblso = soBL.DM_DATAITEM_GETBYGROUPNAME("QLSO_THAMPHAN");
            if (tblso.Rows.Count > 0)
            {
                ddlLoaiso.DataSource = tblso;
                ddlLoaiso.DataTextField = "TEN";
                ddlLoaiso.DataValueField = "MA";
                ddlLoaiso.DataBind();
                ddlLoaiso.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            }


            List<DM_HANHCHINH> lstTinh = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == ROOT).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstTinh != null && lstTinh.Count > 0)
            {
                ddlTinh.DataSource = lstTinh;
                ddlTinh.DataTextField = "TEN";
                ddlTinh.DataValueField = "ID";
                ddlTinh.DataBind();
            }
            ddlTinh.Items.Insert(0, new ListItem("--- Tỉnh/Thành phố ---", "0"));
            LoadNG_Huyen();

            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            QT_NGUOIDUNG_BL oNDBL = new QT_NGUOIDUNG_BL();

            DM_TOAAN_BL oTABL = new DM_TOAAN_BL();
            DataTable dtTA = oTABL.DM_TOAAN_GETBYNOTCUR(1, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            ddlToaXetXu.DataSource = dtTA;
            ddlToaXetXu.DataTextField = "MA_TEN";
            ddlToaXetXu.DataValueField = "ID";
            ddlToaXetXu.DataBind();
            ddlToaXetXu.Items.Insert(0, new ListItem("--- Chọn --- ", "0"));
        }
        private void LoadNG_Huyen()
        {
            ddlHuyen.Items.Clear();
            decimal TinhID = Convert.ToDecimal(ddlTinh.SelectedValue);
            if (TinhID != 0)
            {
                List<DM_HANHCHINH> lstHuyen = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == TinhID).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
                if (lstHuyen != null && lstHuyen.Count > 0)
                {
                    ddlHuyen.DataSource = lstHuyen;
                    ddlHuyen.DataTextField = "TEN";
                    ddlHuyen.DataValueField = "ID";
                    ddlHuyen.DataBind();
                }
            }
            ddlHuyen.Items.Insert(0, new ListItem("--- Quận/Huyện ---", "0"));
        }
        //void LoadDropTTV_TheoCanBoLogin()
        //{
        //    decimal CurrNhomNSDID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_NHOMNSDID] + "");
        //    QT_NHOMNGUOIDUNG oGroup = dt.QT_NHOMNGUOIDUNG.Where(x => x.ID == CurrNhomNSDID).Single();
        //    int loai_hotro_db = (int)oGroup.LOAI;

        //    string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
        //    decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
        //    GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();
        //    Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
        //    DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault();
        //    decimal chucdanh_id = (string.IsNullOrEmpty(oCB.CHUCDANHID + "")) ? 0 : Convert.ToDecimal(oCB.CHUCDANHID);
        //    decimal chucvu_id = (string.IsNullOrEmpty(oCB.CHUCVUID + "")) ? 0 : Convert.ToDecimal(oCB.CHUCVUID);
        //    if (chucvu_id > 0)
        //    {
        //        DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == chucvu_id).FirstOrDefault();
        //        if (oCD.MA == ENUM_CHUCVU.CHUCVU_PVT && loai_hotro_db != 1)
        //        {
        //            LoadDropTTV_TheoLanhDao(CanboID);
        //        }
        //        else
        //        {
        //            LoadAll_TTV();
        //        }
        //    }
        //    else if (chucdanh_id > 0)
        //    {
        //        DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == chucdanh_id).Single();
        //        if ((oCD.MA == ENUM_CHUCDANH.CHUCDANH_TTV || oCD.MA == "TTVC") && loai_hotro_db != 1)
        //        {
        //            ddlThamtravien.Items.Clear();
        //            ddlThamtravien.Items.Add(new ListItem(oCB.HOTEN, oCB.ID.ToString()));
        //            hddLoaiTK.Value = ENUM_CHUCDANH.CHUCDANH_TTV;
        //        }
        //        else LoadAll_TTV();
        //    }
        //}

        //void LoadAll_TTV()
        //{
        //    GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();
        //    string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
        //    decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
        //    Decimal LoginDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

        //    //Thẩm tra viên
        //    DataTable tblTheoPB = oGDTBL.GDTTT_VuAn_GetAllCBTheoPB(LoginDonViID, PBID, ENUM_CHUCDANH.CHUCDANH_TTV);
        //    ddlThamtravien.DataSource = tblTheoPB;
        //    ddlThamtravien.DataTextField = "HOTEN";
        //    ddlThamtravien.DataValueField = "ID";
        //    ddlThamtravien.DataBind();
        //    ddlThamtravien.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
        //}

        //void LoadDropTTV_TheoLanhDao(Decimal LanhDaoID)
        //{
        //    string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
        //    decimal PhongBanID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
        //    ddlThamtravien.Items.Clear();
        //    try
        //    {
        //        DM_CANBO_BL obj = new DM_CANBO_BL();

        //        DataTable tbl = obj.DM_CANBO_PB_CHUCDANH(PhongBanID, "TTV", LanhDaoID, 0, 1, 200000);
        //        if (tbl != null && tbl.Rows.Count > 0)
        //        {
        //            ddlThamtravien.DataSource = tbl;
        //            ddlThamtravien.DataTextField = "HOTEN";
        //            ddlThamtravien.DataValueField = "CanBoID";
        //            ddlThamtravien.DataBind();
        //            ddlThamtravien.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
        //        }
        //    }
        //    catch (Exception ex)
        //    { }
        //}
        void LoadDropLoaiAn()
        {
            //Decimal ChucVuPCA = 0;
            //try { ChucVuPCA = dt.DM_DATAITEM.Where(x => x.MA == "PCA").FirstOrDefault().ID; } catch (Exception ex) { }

            Boolean IsLoadAll = false;
            ddlLoaiAn.Items.Clear();
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            DM_PHONGBAN obj = dt.DM_PHONGBAN.Where(x => x.ID == PBID).FirstOrDefault() ?? new DM_PHONGBAN();

            Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault();
            if (oCB.CHUCDANHID != null && oCB.CHUCDANHID != 0)
            {
                Decimal CurrChucVuID = string.IsNullOrEmpty(oCB.CHUCVUID + "") ? 0 : (decimal)oCB.CHUCVUID;

                DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCDANHID).FirstOrDefault();
                if (oCD.MA == "TPTATC")
                {
                    oCD = dt.DM_DATAITEM.Where(x => x.ID == CurrChucVuID).FirstOrDefault();
                    if (oCD != null)
                    {
                        if (oCD.MA == "CA")
                            IsLoadAll = true;
                        else if (oCD.MA == "PCA")
                            LoadLoaiAnPhuTrach(oCB);
                    }
                    else
                        LoadLoaiAnPhuTrach(oCB);
                    //    IsLoadAll = true;//anhvh load thẩm phán Dào Thị Minh Thủy --test
                    //if (IsLoadAll) LoadAllLoaiAn();
                }
                else
                {
                    if (obj.ISHINHSU == 1)
                    {
                        ddlLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
                        //dgList.Columns[6].Visible = false;
                        //dgList.Columns[5].HeaderText = "Bị cáo";
                        //    lblTitleBC.Text = "Bị cáo";
                        //   lblTitleBD.Visible = txtBidon.Visible = false;

                    }
                    LoadLoaiAnPhuTrach_TheoPB(obj);
                }
            }

            // if (obj.ISPHASAN == 1) ddlLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC.AN_PHASAN));
            if (ddlLoaiAn.Items.Count > 1)
            {
                //anhvh add 05/04/2021 check loai an nếu tồn tại án hình sự thì không insert lựa chọn tất cả
                //Boolean check_add = true;
                //foreach (ListItem li in ddlLoaiAn.Items)
                //{
                //    if (li.Value == "01")
                //    {
                //        check_add = false;
                //        break;
                //    }
                //}
                //if (check_add == true)
                //{
                ddlLoaiAn.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
                //}
            }
        }
        void LoadAllLoaiAn()
        {
            ddlLoaiAn.Items.Clear();
            ddlLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
            ddlLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
            ddlLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
            ddlLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
            ddlLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
            ddlLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
        }

        void LoadLoaiAnPhuTrach_TheoPB(DM_PHONGBAN obj)
        {
            if (obj.ISDANSU == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
            }
            if (obj.ISHANHCHINH == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
            }
            if (obj.ISHNGD == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
            }
            if (obj.ISKDTM == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
            }
            if (obj.ISLAODONG == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
            }
        }
        void LoadLoaiAnPhuTrach(DM_CANBO obj)
        {
            if (obj.ISDANSU == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
            }
            if (obj.ISHANHCHINH == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
            }
            if (obj.ISHNGD == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
            }
            if (obj.ISKDTM == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
            }
            if (obj.ISLAODONG == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
            }
            if (obj.ISHINHSU == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
            }
        }

        //---------------CHỨC NĂNG-------------------
        protected void chkChonAll_CheckChange(object sender, EventArgs e)
        {
            CheckBox chkAll = (CheckBox)sender;

            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chk = (CheckBox)Item.FindControl("chkChon");
                chk.Checked = chkAll.Checked;
            }
        }

        private string getDiaDiem(decimal ToaAnID)
        {
            try
            {
                string strDiadiem = "";
                DM_TOAAN oT = dt.DM_TOAAN.Where(x => x.ID == ToaAnID).FirstOrDefault();
                strDiadiem = oT.TEN.Replace("Tòa án nhân dân ", "");
                switch (oT.LOAITOA)
                {
                    case "CAPHUYEN":
                        DM_TOAAN opT = dt.DM_TOAAN.Where(x => x.ID == oT.CAPCHAID).FirstOrDefault();
                        strDiadiem = opT.TEN.Replace("Tòa án nhân dân ", "");
                        strDiadiem = strDiadiem.Replace("tỉnh", "");
                        strDiadiem = strDiadiem.Replace("Tỉnh", "");
                        strDiadiem = strDiadiem.Replace("thành phố", "");
                        strDiadiem = strDiadiem.Replace("Thành phố", "");
                        if (strDiadiem.Contains("Hồ Chí Minh"))
                            strDiadiem = "Tp." + strDiadiem;
                        break;
                    case "CAPTINH":
                        strDiadiem = strDiadiem.Replace("tỉnh", "");
                        strDiadiem = strDiadiem.Replace("Tỉnh", "");
                        strDiadiem = strDiadiem.Replace("thành phố", "");
                        strDiadiem = strDiadiem.Replace("Thành phố", "");
                        if (strDiadiem.Contains("Hồ Chí Minh"))
                            strDiadiem = "Tp." + strDiadiem;
                        break;
                    case "CAPCAO":
                        strDiadiem = strDiadiem.Replace("cấp cao", "");
                        strDiadiem = strDiadiem.Replace("tại", "");
                        strDiadiem = strDiadiem.Replace("tỉnh", "");
                        strDiadiem = strDiadiem.Replace("Tỉnh", "");
                        strDiadiem = strDiadiem.Replace("thành phố", "");
                        strDiadiem = strDiadiem.Replace("Thành phố", "");
                        if (strDiadiem.Contains("Hồ Chí Minh"))
                            strDiadiem = "Tp." + strDiadiem;
                        break;
                }
                return strDiadiem;
            }
            catch (Exception ex) { return ""; }
        }


        protected void lbtTTBC_Click(object sender, EventArgs e)
        {
            if (pnTTBC.Visible)
            {
                lbtTTBC.Text = "[ Mở ]";
                pnTTBC.Visible = false;
                Session["SessionSearch"] = "0";
            }
            else
            {
                lbtTTBC.Text = "[ Đóng ]";
                pnTTBC.Visible = true;
                Session["SessionSearch"] = "1";
            }
        }
        protected void lbtTTTK_Click(object sender, EventArgs e)
        {
            if (pnTTTK.Visible == false)
            {
                lbtTTTK.Text = "[ Thu gọn ]";
                pnTTTK.Visible = true;
                Session["TTTKVISIBLE"] = "0";
            }
            else
            {
                lbtTTTK.Text = "[ Nâng cao ]";
                pnTTTK.Visible = false;
                Session["TTTKVISIBLE"] = "1";
            }
        }


        protected void cmdLammoi_Click(object sender, EventArgs e)
        {
            txtNguoigui.Text = "";
            txtSoQDBA.Text = "";
            txtNgayBAQD.Text = "";
            ddlToaXetXu.SelectedIndex = 0;
            txtNgayNhanTu.Text = "";
            txtNgayNhanDen.Text = "";
            ddlTinh.SelectedIndex = 0;
            ddlHuyen.SelectedIndex = 0;
            txtDiachi.Text = "";
            //ddlTraloi.SelectedIndex = 0;
            ddlHinhthucdon.SelectedIndex = 0;
            txtSoCMND.Text = "";
            txtSohieudon.Text = "";
            txtNgaychuyenTu.Text = txtNgaychuyenDen.Text = "";
            ddlThuLy.SelectedIndex = 0;
            ddlPhanloaiDdon.SelectedIndex = 0;
            txtCV_So.Text = "";
            txtCV_Ngay.Text = "";
            rdbTrangThai.SelectedIndex = 0;
            set_button();
            Session[SS_TK.HCTP_GHICHU] = string.Empty;
        }

        protected void rdbTrangThai_SelectedIndexChanged(object sender, EventArgs e)
        {
            set_button();
            SetTieuDeBaoCao();

        }
        void set_button()
        {
            pnGhepVuAn.Visible = false; rdGhepVuAn.SelectedValue = "2";
            if (rdbTrangThai.SelectedValue == "1")
            {
                Cls_Comon.SetButton(cmdTralai, true);
                Cls_Comon.SetButton(cmdNhandon, true);
                cmdNhandon.Text = "Nhận đơn";
                cmdInDonDaNhan.Visible = false;
            }
            else if (rdbTrangThai.SelectedValue == "2")
            {
                Cls_Comon.SetButton(cmdTralai, true);
                Cls_Comon.SetButton(cmdNhandon, true);
                cmdNhandon.Text = "Chuyển đơn";
                pnGhepVuAn.Visible = false;
                cmdInDonDaNhan.Visible = true;
            }
            else if (rdbTrangThai.SelectedValue == "4")
            {
                Cls_Comon.SetButton(cmdTralai, false);
                Cls_Comon.SetButton(cmdNhandon, true);
                cmdNhandon.Text = "Thu hồi";
                pnGhepVuAn.Visible = false;
                cmdInDonDaNhan.Visible = true;
            }
            else
            {
                Cls_Comon.SetButton(cmdTralai, false);
                Cls_Comon.SetButton(cmdNhandon, false);
                cmdInDonDaNhan.Visible = false;
            }
        }

        void xoa_thongtinchuyen(Decimal CurrDonID, Decimal CurrDonViNhanID)
        {
            try
            {
                List<GDTTT_DON_CHUYEN> lstC = dt.GDTTT_DON_CHUYEN.Where(x => x.DONID == CurrDonID
                                                                            && x.PHONGBANNHANID == CurrDonViNhanID).OrderByDescending(x => x.NGAYCHUYEN).ToList();
                if (lstC.Count > 0)
                {
                    GDTTT_DON_CHUYEN oC = lstC[0];
                    //Xóa thông tin đẫ chuyển từ bảng đơn chuyển
                    dt.GDTTT_DON_CHUYEN.Remove(oC);
                    dt.SaveChanges();

                }
            }
            catch (Exception ex) { }
        }


        //-----------------------------------
        protected void lkInBC_OpenForm_Click(object sender, EventArgs e)
        {
            if (pnInBC.Visible == false)
            {
                lkInBC_OpenForm.Text = "[ Thu gọn ]";
                pnInBC.Visible = true;
                Session[SessionInBC] = "0";
            }
            else
            {
                lkInBC_OpenForm.Text = "[ Mở ]";
                pnInBC.Visible = false;
                Session[SessionInBC] = "1";
            }
        }
        protected void cmdInDonTrung_Click(object sender, EventArgs e)
        {
            SetGetSessionTK(true);
            String SessionName = "GDTTT_DonTrung_ReportPL".ToUpper();
            //--------------------------
            String ReportName = "";
            if (String.IsNullOrEmpty(txtTieuDeBC.Text.Trim()))
                SetTieuDeBaoCao();
            ReportName = txtTieuDeBC.Text.Trim();
            Session[SS_TK.TENBAOCAO] = ReportName.ToUpper();

            DataTable tbl = GetDSKemDonTrung(false, false, false);
            Session[SessionName] = tbl;

            string URL = "/QLAN/GDTTT/Giaiquyet/BaoCao/ViewBC.aspx?type=2";
            Cls_Comon.CallFunctionJS(this, this.GetType(), "PopupReport('" + URL + "','In báo cáo',1000,600)");

        }
        protected void cmdPrint_Click(object sender, EventArgs e)
        {
            SetGetSessionTK(true);
            String SessionName = "GDTTT_Don_ReportPL".ToUpper();
            //--------------------------
            String ReportName = "";
            if (String.IsNullOrEmpty(txtTieuDeBC.Text.Trim()))
                SetTieuDeBaoCao();
            ReportName = txtTieuDeBC.Text.Trim();
            Session[SS_TK.TENBAOCAO] = ReportName.ToUpper();

            DataTable tbl = getDS(false, true, false, false);
            Session[SessionName] = tbl;

            string URL = "/QLAN/GDTTT/Giaiquyet/BaoCao/ViewBC.aspx";
            Cls_Comon.CallFunctionJS(this, this.GetType(), "PopupReport('" + URL + "','In báo cáo',1000,600)");
        }

        protected void cmdInDonDaNhan_Click(object sender, EventArgs e)
        {

        }

        protected void ddlHinhthucdon_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
        }
        protected void ddlToaXetXu_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
        }
        protected void ddlPhanloaiDdon_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
        }
        protected void ddlTraloi_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
        }
        protected void ddlThuLy_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
        }
        //protected void ddlThamtravien_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    SetTieuDeBaoCao();
        //}
        //them loai an
        protected void Drop_LoaiSo_SelectedIndexChanged(object sender, EventArgs e)
        {   //Lay so van ban theo loại VB
            if (ddlLoaiso.SelectedValue != "0" && rdbTrangThai.SelectedValue == "2")
            {

                Layso_SoVB();
                btnLuuVB.Enabled = true;
                btnLuuVB.CssClass = "buttoninput";
            }
            else
            {
                btnLuuVB.Enabled = false;
                btnLuuVB.CssClass = "buttonprintdisable";
            }


        }
        private void Layso_SoVB()
        {
            //Load loại sổ văn bản
            string vddlLoaiso = ddlLoaiso.SelectedValue;
            DateTime dNgayCV = (String.IsNullOrEmpty(txtBC_Ngaydk.Text.Trim())) ? DateTime.Now : DateTime.Parse(this.txtBC_Ngaydk.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();

            txtBC_SoCV.Text = oBL.SOVB_GETMAXTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), PhongBanID, dNgayCV.Year, vddlLoaiso).ToString();
            txtBC_Ngaydk.Text = dNgayCV.ToString("dd/MM/yyyy");
        }
        protected void ddlLoaiAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
            Load_Data();
        }
        void SetTieuDeBaoCao()
        {
            //string tieudebc = "Danh  sách đơn chuyển";
            //tieudebc += " " + rdbTrangThai.SelectedItem.Text.ToLower() + " từ HCTP";
            ////-------------------------------------

            //if (ddlPhanloaiDdon.SelectedValue != "0")
            //    tieudebc += " " + ddlPhanloaiDdon.SelectedItem.Text.ToLower();

            //if (ddlHinhthucdon.SelectedValue != "0")
            //    tieudebc += " có hình thức đơn là " + ddlHinhthucdon.SelectedItem.Text.ToLower();

            //if (ddlThuLy.SelectedValue != "-1")
            //    tieudebc += " là " + ddlThuLy.SelectedItem.Text.ToLower();

            //if (ddlToaXetXu.SelectedValue != "0")
            //    tieudebc += " do " + ddlToaXetXu.SelectedItem.Text + " ra BA/QD";

            //if (ddlThamtravien.SelectedValue != "0")
            //    tieudebc += ", TTV " + ddlThamtravien.SelectedItem.Text + " phụ trách";

            //if (ddlLoaiAn.SelectedValue != "0")
            //    tieudebc += ", của án " + ddlLoaiAn.SelectedItem.Text;

            //if (ddlTraloi.SelectedValue != "0")
            //    tieudebc += " " + ddlTraloi.SelectedItem.Text.ToLower();
            //txtTieuDeBC.Text = "Danh sách đơn" + tieudebc.Replace("...", "");
        }
        protected void cmdInDonChuyen_Click(object sender, EventArgs e)
        {
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            decimal ToaRaBAQD = Convert.ToDecimal(ddlToaXetXu.SelectedValue),
                HinhThucDon = Convert.ToDecimal(ddlHinhthucdon.SelectedValue), DiaChiTinh = 0,
                DiaChiHuyen = 0, TraLoidon = 0;
            string SoBAQD = txtSoQDBA.Text.Trim(), NgayBAQD = txtNgayBAQD.Text, NguoiGui = txtNguoigui.Text.Trim(),
                SoCMND = txtSoCMND.Text.Trim(), SoHieuDon = txtSohieudon.Text.Trim(), DiaChiCT = txtDiachi.Text.Trim(),
                SoCongVan = txtCV_So.Text.Trim(), NgayCongVan = txtCV_Ngay.Text;

            DateTime? TuNgay = txtNgayNhanTu.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayNhanTu.Text, cul, DateTimeStyles.NoCurrentDateDefault),
                DenNgay = txtNgayNhanDen.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayNhanDen.Text + " 23:59:59", cul, DateTimeStyles.NoCurrentDateDefault);
            if (ddlHuyen.SelectedValue == "0")
            {
                DiaChiTinh = 0;
                DiaChiHuyen = 0;
            }
            else
            {
                decimal TinhHuyenID = Convert.ToDecimal(ddlHuyen.SelectedValue);
                DM_HANHCHINH oDMHC = dt.DM_HANHCHINH.Where(x => x.ID == TinhHuyenID).FirstOrDefault();
                if (oDMHC.LOAI == 1)//TỈnh
                {
                    DiaChiTinh = (decimal)oDMHC.ID;
                    DiaChiHuyen = 0;
                }
                else
                {
                    DiaChiTinh = (decimal)oDMHC.CAPCHAID;
                    DiaChiHuyen = oDMHC.ID;
                }
            }
            string vArrSelectID = "";
            //danh sac don chon de in
            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                if (chkChon.Checked)
                {
                    if (vArrSelectID == "") vArrSelectID = chkChon.ToolTip;
                    else vArrSelectID = vArrSelectID + "," + chkChon.ToolTip;
                }
            }

            if (vArrSelectID != "") vArrSelectID = "," + vArrSelectID + ",";

            decimal vCD_DONVIID = Convert.ToDecimal(ddlPhongban.SelectedValue);

            DateTime? vNgaychuyenTu = txtNgaychuyenTu.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgaychuyenTu.Text, cul, DateTimeStyles.NoCurrentDateDefault)
                , vNgaychuyenDen = txtNgaychuyenDen.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgaychuyenDen.Text + " 23:59:59", cul, DateTimeStyles.NoCurrentDateDefault);
            decimal vIsThuLy = Convert.ToDecimal(ddlThuLy.SelectedValue);
            decimal vPhanloaixuly = 0;// Convert.ToDecimal(ddlPhanloaiDdon.SelectedValue);

            DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault)
                , vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text + " 23:59:59", cul, DateTimeStyles.NoCurrentDateDefault);

            string vSoThuly = txtThuly_So.Text;

            decimal vTrangthai = Convert.ToDecimal(rdbTrangThai.SelectedValue);
            string vCVPC_So = txtCV_So.Text.Trim(), vCVPC_Ngay = txtCV_Ngay.Text;

            int page_size = Convert.ToInt32(ddlPageCount.SelectedValue);
            int pageindex = Convert.ToInt32(hddPageIndex.Value);

            pageindex = 1;
            page_size = 10000;

            decimal vLoaiAn = Convert.ToDecimal(ddlLoaiAn.SelectedValue);

            //Can yeu cau tim So CV va Ngay CV chuyen de in
            SetGetSessionTK(true);

            //--------------------------
            //String ReportName = "DANH SÁCH ĐƠN THỤ LÝ MỚI THẨM PHÁN CHUYỂN VỤ GIÁM ĐỐC KIỂM TRA ";


            Literal Table_Str_Totals = new Literal();
            DataTable tbl = new DataTable();
            DataRow row = tbl.NewRow();
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            //-------------
            tbl = oBL.GDTTT_DON_DS_TL_MOI_THAMPHAN(txtBC_Ngaydk.Text, txtBC_Nguoiky.Text, txtBC_SoCV.Text,
                    Session[ENUM_SESSION.SESSION_USERID] + "",
                    ToaAnID, ToaRaBAQD, SoBAQD, NgayBAQD, NguoiGui,
                    SoCMND, TuNgay, DenNgay, HinhThucDon, SoHieuDon, DiaChiTinh, DiaChiHuyen,
                    DiaChiCT, TraLoidon, vTrangthai, vCD_DONVIID,
                    vNgaychuyenTu, vNgaychuyenDen, vArrSelectID, vIsThuLy, vSoThuly,
                    vNgayThulyTu, vNgayThulyDen, 0, vLoaiAn, vCVPC_So, vCVPC_Ngay, pageindex, page_size);




            //-----------
            if (tbl != null && tbl.Rows.Count > 0)
            {
                row = tbl.Rows[0];
                Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
            }
            //-------------------Export---------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=DS_DON_TL_MOI_TP.xls");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/vnd.xls";
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            Response.Write(AddExcelStyling(2, null));   // add the style props to get the page orientation
            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.Write("</body>");   // add the style props to get the page orientation
            Response.Write("</html>");   // add the style props to get the page orientation
            Response.End();




        }
        private void LoadReport(DataTable tbl)
        {
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            Int32 PBID = strPBID == "" ? 0 : Convert.ToInt32(strPBID);
            object Result = new object();

            Literal Table_Str_Totals = new Literal();

            //-------------------------- String.IsNullOrEmpty(row["HS_TenToiDanh"] + "") ? "" : "
            SetGetSessionTK(true);
            String SessionName = "GDTTT_Don_ReportPL".ToUpper();
            //--------------------------
            String ReportName = "";
            if (String.IsNullOrEmpty(txtTieuDeBC.Text.Trim()))
                SetTieuDeBaoCao();
            ReportName = txtTieuDeBC.Text.Trim().ToUpper();
            Session[SS_TK.TENBAOCAO] = ReportName.ToUpper();
            Session[SessionName] = tbl;

            //den ngày
            DateTime dateAndTime = DateTime.Now;
            DateTime? vDenNgay = txtThuly_Den.Text == "" ? (DateTime?)dateAndTime : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);

            //Tiêu đề ngày tháng
            String title_date = "Tính ";
            if (!String.IsNullOrEmpty(txtThuly_Tu.Text + ""))
            {
                title_date += " từ ngày " + Convert.ToDateTime(txtThuly_Tu.Text).ToString("dd/MM/yyyy") + " đến ngày " + Convert.ToDateTime(vDenNgay).ToString("dd/MM/yyyy") + " ";
            }
            else
            {
                title_date += " đến ngày" + Convert.ToDateTime(vDenNgay).ToString("dd/MM/yyyy") + " ";
            }



            foreach (DataRow row in tbl.Rows)
            {

                Table_Str_Totals.Text += "<tr style=\"font-size: 11pt;\">"
                    + "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\">" + row["STT"] + "</td>"
                    + "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\">" + row["arrTTTL"] + "</td>"
                    + "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\">" + Convert.ToDateTime(row["NGAYNHANDON"]).ToString("dd/MM/yyyy") + "</td>"
                    + "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\">" + row["BAQD_SO"] + "<br/>" + (String.IsNullOrEmpty(row["BAQD_NGAYBA"] + "") ? "" : Convert.ToDateTime(row["BAQD_NGAYBA"]).ToString("dd/MM/yyyy")) + "</td>"
                    + "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\">" + row["TOAXX_VietTat"] + "</td>"
                    + "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\">" + row["QHPLDN"] + "</td>"
                    + "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\">" + row["NGUYENDON"] + "</td>"
                    + "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\">" + row["BIDON"] + "</td>"
                    + "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\">" + row["DONGKHIEUNAI"] + "</td>"
                    + "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\">" + row["NGAYTTVNHAN_THS"] + "</td>"
                    + "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\">" + row["NGAYNHANHOSO"] + "</td>"
                    + "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\">" + row["TENTHAMTRAVIEN"] + "</td>"
                    + "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\"></td></ tr > ";
            }

            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=BC_NHANDON&THULY_GDTTT.doc");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/msword";
            HttpContext.Current.Response.ContentEncoding = System.Text.UnicodeEncoding.UTF8;
            Response.Write("<html");
            Response.Write("<head>");
            Response.Write("<!--[if gte mso 9]> <xml> <w:WordDocument> <w:View>Print</w:View> <w:Zoom>100</w:Zoom> <w:DoNotOptimizeForBrowser/> </w:WordDocument> </xml> <![endif]-->");
            Response.Write("<META HTTP-EQUIV=Content-Type CONTENT=text/html; charset=UTF-8>");
            Response.Write("<meta name=ProgId content=Word.Document>");
            Response.Write("<meta name=Generator content=Microsoft Word 9>");
            Response.Write("<meta name=Originator content=Microsoft Word 9>");

            Response.Write("<style>");
            Response.Write("@page Section1 {size:595.45pt 841.7pt; margin:0.7874015748in 0.5905511811in 0.7086614173in 1.18in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");
            Response.Write("div.Section1 {page:Section1;}");
            //Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:1.25in 1.0in 1.25in 1.0in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");
            Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5in 1.0in 0.5in 1.0in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");
            Response.Write("div.Section2 {page:Section2;}");


            Response.Write("</style>");
            Response.Write("<style type=\"text/css\">" +
                            ".csFAC41405 {color:#000000;background-color:transparent;border-left:#000000 1px solid;border-top:#000000 1px solid;border-right:#000000 1px solid;border-bottom:#000000 1px solid;font-family:Times New Roman; font-size:16px; font-weight:bold; font-style:normal; }" +
                            ".cs92D6B3BE {color:#000000;background-color:transparent;border-left:#000000 1px solid;border-top-style: none;border-right:#000000 1px solid;border-bottom:#000000 1px solid;font-family:Times New Roman; font-size:16px; font-weight:normal; font-style:normal; padding-top:3px;padding-left:3px;padding-right:3px;}" +
                            ".cs55A4355E {color:#000000;background-color:transparent;border-left-style: none;border-top:#000000 1px solid;border-right:#000000 1px solid;border-bottom:#000000 1px solid;font-family:Times New Roman; font-size:16px; font-weight:bold; font-style:normal; }" +
                            ".cs9308C9E5 {color:#000000;background-color:transparent;border-left-style: none;border-top-style: none;border-right:#000000 1px solid;border-bottom:#000000 1px solid;font-family:Times New Roman; font-size:16px; font-weight:normal; font-style:normal; padding-top:3px;padding-left:3px;padding-right:3px;}" +
                            ".csC9A92AEB {color:#000000;background-color:transparent;border-left-style: none;border-top-style: none;border-right-style: none;border-bottom-style: none;font-family:Times New Roman; font-size:16px; font-weight:bold; font-style:italic; padding-left:2px;padding-right:2px;}" +
                            ".cs1EF4761A {color:#000000;background-color:transparent;border-left-style: none;border-top-style: none;border-right-style: none;border-bottom-style: none;font-family:Times New Roman; font-size:16px; font-weight:bold; font-style:normal; padding-left:2px;padding-right:2px;}" +
                            ".csAC6A4475 { height: 0px; width: 0px; overflow: hidden; font - size:0px; line - height:0px;}" +
                            "</style>");


            Response.Write("</head>");
            Response.Write("<body>");
            Response.Write("<div class=Section2>");
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            htmlWrite.WriteLine("<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" style=\"font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;\">");

            htmlWrite.WriteLine("<tr style=\"vertical - align:top;\">" +
                                    "<td style = \"width:0px;height:24px;\"></td >" +
                                    "<td class=\"cs1EF4761A\" colspan=\"10\" style=\"width:1032px;height:24px;line-height:18px;text-align:center;vertical-align:middle;\"><nobr>" +
                                    ReportName + "</nobr></td>" +
                                "</tr>");



            htmlWrite.WriteLine("<tr style=\"vertical - align:top;padding-top:0pt; padding-bottom:5pt;text-align:center;\"><td colspan=\"12\"> (" + title_date + ")</td></tr>");
            htmlWrite.WriteLine("<tr style=\"vertical - align:top;padding-top:5pt; padding-bottom:5pt;text-align:left;\"><td colspan=\"8\"> Tổng số đơn đề nghị và các tài liệu kèm theo là: " + tbl.Rows.Count + "</td><td colspan=\"4\"></td></tr>");
            htmlWrite.WriteLine("<tr style=\"vertical - align:top;\">" +
                                    "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;font-weight:bold;\">STT</nobr></td>" +
                                    "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Số &<br/>Ngày thụ lý</td>" +
                                    "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Ngày thụ lý<br/>của Vụ</td>" +
                                    "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Bản án<br/>Số & Ngày</td>" +
                                    "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Tòa xét xử</td>" +
                                    "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Quan hệ pháp luật</td>" +
                                    "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Nguyên đơn/<br/>Người khởi kiện</td>" +
                                    "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Bị đơn/<br/>Người bị kiện</td>" +
                                    "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Người<br/>kháng nghị</td>" +
                                    "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Ngày nhận<br/>THS</td>" +
                                    "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Ngày<br/>nhận HS</td>" +
                                    "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Thẩm<br/>tra viên</td>" +
                                    "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Ký nhận</td>" +
                                  "</tr>");

            Table_Str_Totals.Text += "<tr style=\"height: 1pt;\">" +
                                  "<td style = \"width:20pt;\"></td>" +
                                  "<td style = \"width:80pt;\" ></td >" +
                                  "<td style = \"width:80pt;\"></td >" +
                                  "<td style = \"width:80pt;\" ></td >" +
                                  "<td style = \"width:80pt;\" ></td >" +
                                  "<td style = \"width:100pt;\" ></td >" +
                                  "<td style = \"width:80pt;\" ></td >" +
                                  "<td style = \"width:80pt;\" ></td >" +
                                  "<td style = \"width:80pt;\" ></td >" +
                                  "<td style = \"width:80pt;\" ></td >" +
                                  "<td style = \"width:80pt;\" ></td >" +
                                  "<td style = \"width:80pt;\" ></td >" +
                                  "<td style = \"width:80pt;\" ></td ></tr>" +
                                  "</table>";
            Table_Str_Totals.RenderControl(htmlWrite);

            Response.Write(stringWrite.ToString());
            Response.Write("</div>");
            Response.Write("</body>");
            Response.Write("</html>");
            Response.End();
        }
        private void LoadReportHS(DataTable tbl)
        {
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            Int32 PBID = strPBID == "" ? 0 : Convert.ToInt32(strPBID);
            object Result = new object();

            Literal Table_Str_Totals = new Literal();

            //-------------------------- String.IsNullOrEmpty(row["HS_TenToiDanh"] + "") ? "" : "
            SetGetSessionTK(true);
            String SessionName = "GDTTT_Don_ReportPL".ToUpper();
            //--------------------------
            String ReportName = "";
            if (String.IsNullOrEmpty(txtTieuDeBC.Text.Trim()))
                SetTieuDeBaoCao();
            ReportName = txtTieuDeBC.Text.Trim().ToUpper();
            Session[SS_TK.TENBAOCAO] = ReportName.ToUpper();
            Session[SessionName] = tbl;

            //den ngày
            DateTime dateAndTime = DateTime.Now;
            DateTime? vDenNgay = txtThuly_Den.Text == "" ? (DateTime?)dateAndTime : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);

            //Tiêu đề ngày tháng
            String title_date = "Tính ";
            if (!String.IsNullOrEmpty(txtThuly_Tu.Text + ""))
            {
                title_date += " từ ngày " + Convert.ToDateTime(txtThuly_Tu.Text).ToString("dd/MM/yyyy") + " đến ngày " + Convert.ToDateTime(vDenNgay).ToString("dd/MM/yyyy") + " ";
            }
            else
            {
                title_date += " đến ngày" + Convert.ToDateTime(vDenNgay).ToString("dd/MM/yyyy") + " ";
            }



            foreach (DataRow row in tbl.Rows)
            {

                Table_Str_Totals.Text += "<tr style=\"font - size: 11pt; \">"
                        + "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000; height: 50pt;\">" + row["STT"] + "</td>"
                        + "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\">" + row["arrTTTL"] + "</td>"
                        + "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\">" + Convert.ToDateTime(row["NGAYNHANDON"]).ToString("dd/MM/yyyy") + "</nobr></td>"
                        + "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\">" + row["BAQD_SO"] + "<br/>" + Convert.ToDateTime(row["BAQD_NGAYBA"]).ToString("dd/MM/yyyy") + "</td>"
                        + "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\"> " + row["TOAXX_VietTat"] + "</td>"
                        + "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\">" + row["QHPNDN_Report"] + "</td>"
                        + "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\">" + row["NGUYENDON"] + "<br/>" + row["BIDON"] + "</td>"
                        + "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\">" + row["DONGKHIEUNAI"] + " </td>"
                        + "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\">" + row["NGAYTTVNHAN_THS"] + " </td>"
                        + "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\">" + row["NGAYNHANHOSO"] + "</td>"
                        + "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\">" + row["TENTHAMTRAVIEN"] + "</td>"
                        + "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\"></td></ tr > ";
            }

            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=BC_NHANDON&THULY_GDTTT.doc");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/msword";
            HttpContext.Current.Response.ContentEncoding = System.Text.UnicodeEncoding.UTF8;
            Response.Write("<html");
            Response.Write("<head>");
            Response.Write("<!--[if gte mso 9]> <xml> <w:WordDocument> <w:View>Print</w:View> <w:Zoom>100</w:Zoom> <w:DoNotOptimizeForBrowser/> </w:WordDocument> </xml> <![endif]-->");
            Response.Write("<META HTTP-EQUIV=Content-Type CONTENT=text/html; charset=UTF-8>");
            Response.Write("<meta name=ProgId content=Word.Document>");
            Response.Write("<meta name=Generator content=Microsoft Word 9>");
            Response.Write("<meta name=Originator content=Microsoft Word 9>");

            Response.Write("<style>");
            Response.Write("@page Section1 {size:595.45pt 841.7pt; margin:0.7874015748in 0.5905511811in 0.7086614173in 1.18in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");
            Response.Write("div.Section1 {page:Section1;}");
            //Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:1.25in 1.0in 1.25in 1.0in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");
            Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5in 1.0in 0.5in 1.0in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");
            Response.Write("div.Section2 {page:Section2;}");


            Response.Write("</style>");
            Response.Write("<style type=\"text/css\">" +
                            ".csFAC41405 {color:#000000;background-color:transparent;border-left:#000000 1px solid;border-top:#000000 1px solid;border-right:#000000 1px solid;border-bottom:#000000 1px solid;font-family:Times New Roman; font-size:16px; font-weight:bold; font-style:normal; }" +
                            ".cs92D6B3BE {color:#000000;background-color:transparent;border-left:#000000 1px solid;border-top-style: none;border-right:#000000 1px solid;border-bottom:#000000 1px solid;font-family:Times New Roman; font-size:16px; font-weight:normal; font-style:normal; padding-top:3px;padding-left:3px;padding-right:3px;}" +
                            ".cs55A4355E {color:#000000;background-color:transparent;border-left-style: none;border-top:#000000 1px solid;border-right:#000000 1px solid;border-bottom:#000000 1px solid;font-family:Times New Roman; font-size:16px; font-weight:bold; font-style:normal; }" +
                            ".cs9308C9E5 {color:#000000;background-color:transparent;border-left-style: none;border-top-style: none;border-right:#000000 1px solid;border-bottom:#000000 1px solid;font-family:Times New Roman; font-size:16px; font-weight:normal; font-style:normal; padding-top:3px;padding-left:3px;padding-right:3px;}" +
                            ".csC9A92AEB {color:#000000;background-color:transparent;border-left-style: none;border-top-style: none;border-right-style: none;border-bottom-style: none;font-family:Times New Roman; font-size:16px; font-weight:bold; font-style:italic; padding-left:2px;padding-right:2px;}" +
                            ".cs1EF4761A {color:#000000;background-color:transparent;border-left-style: none;border-top-style: none;border-right-style: none;border-bottom-style: none;font-family:Times New Roman; font-size:16px; font-weight:bold; font-style:normal; padding-left:2px;padding-right:2px;}" +
                            ".csAC6A4475 { height: 0px; width: 0px; overflow: hidden; font - size:0px; line - height:0px;}" +
                            "</style>");


            Response.Write("</head>");
            Response.Write("<body>");
            Response.Write("<div class=Section2>");
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            htmlWrite.WriteLine("<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" style=\"font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;\">");


            htmlWrite.WriteLine("<tr style=\"vertical - align:top;\">" +
                                    "<td style = \"width:0px;height:24px;\"></td >" +
                                    "<td class=\"cs1EF4761A\" colspan=\"10\" style=\"height:24px;line-height:18px;text-align:center;vertical-align:middle;\"><nobr>" +
                                    ReportName + "</nobr></td>" +
                                "</tr>");



            htmlWrite.WriteLine("<tr style=\"vertical - align:top;padding-top:0pt; padding-bottom:5pt;text-align:center;\"><td colspan=\"12\"> (" + title_date + ")</td></tr>");
            htmlWrite.WriteLine("<tr style=\"vertical - align:top;padding-top:5pt; padding-bottom:5pt;text-align:left;\"><td colspan=\"8\"> Tổng số đơn đề nghị và các tài liệu kèm theo là: " + tbl.Rows.Count + "</td><td colspan=\"4\"></td></tr>");
            htmlWrite.WriteLine("<tr>" +
                                    "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;font-weight:bold;\">STT</td>" +
                                    "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Số &<br/>Ngày thụ lý</td>" +
                                    "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Ngày thụ lý<br/>của Vụ</td>" +
                                    "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Bản án<br/>Số & Ngày</td>" +
                                    "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Tòa xét xử</td>" +
                                    "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Tội danh</td>" +
                                    "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Bị cáo</td>" +
                                    "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Người<br/>kháng nghị</td>" +
                                    "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Ngày nhận<br/>THS</td>" +
                                    "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Ngày<br/>nhận HS</td>" +
                                    "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Thẩm<br/>tra viên</td>" +
                                    "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Ghi chú</td>" +
                                  "</tr>");

            Table_Str_Totals.Text += "<tr style=\"height: 1pt;\">" +
                                  "<td style = \"width:20pt;\"></td>" +
                                  "<td style = \"width:80pt;\" ></td >" +
                                  "<td style = \"width:80pt;\"></td >" +
                                  "<td style = \"width:80pt;\" ></td >" +
                                  "<td style = \"width:80pt;\" ></td >" +
                                  "<td style = \"width:100pt;\" ></td >" +
                                  "<td style = \"width:80pt;\" ></td >" +
                                  "<td style = \"width:80pt;\" ></td >" +
                                  "<td style = \"width:80pt;\" ></td >" +
                                  "<td style = \"width:80pt;\" ></td >" +
                                  "<td style = \"width:80pt;\" ></td >" +
                                  "<td style = \"width:80pt;\" ></td ></tr>" +
                                  "</table>";

            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.Write("</div>");
            Response.Write("</body>");
            Response.Write("</html>");
            Response.End();
        }
        private bool Check_Chuyendon()
        {
            //decimal CurrDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            //PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            //String strMsg = "";
            //foreach (DataGridItem Item in dgList.Items)
            //{
            //    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
            //    if (chkChon.Checked)
            //    {
            //        string strID = Item.Cells[0].Text;
            //        decimal ID = Convert.ToDecimal(strID);
            //        GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();
            //        GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            //        if (oBL.CHECK_SOVB_DON("CV_VUGD", CurrDonViID, PhongBanID, ID) == 0)//CV_VUGD con van chuyen vu
            //        {
            //            strMsg = "Bạn chưa nhập công văn chuyển vụ";
            //            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
            //            return false;
            //        }
            //    }
            //}
            return true;
        }
        //-----------------------------
        //rdbTrangThai.SelectedValue == "1": nhận đơn
        //rdbTrangThai.SelectedValue == "2": chuyển đơn
        //rdbTrangThai.SelectedValue == "4": thu hồi
        protected void cmdNhandon_Click(object sender, EventArgs e)
        {
            if (rdbTrangThai.SelectedValue == "1")
            {
                //Kiểm tra ngày nhận đơn
                if (txtBC_Ngay.Text == "")
                {

                    ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Chưa nhập ngày nhận đơn!')", true);
                    lbtthongbao.ForeColor = System.Drawing.Color.Red;
                    txtBC_Ngay.Focus();
                }
                DateTime? vNgayNhan = txtBC_Ngay.Text == "" ? (DateTime?)null : DateTime.Parse(txtBC_Ngay.Text, cul, DateTimeStyles.NoCurrentDateDefault);

                decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
                //decimal PhongbanID = Convert.ToDecimal(ddlPhongban.SelectedValue);
                int iCount = 0;
                //Decimal CurrThamPhanID = 0;
                if (PhongBanID > 0)
                {
                    foreach (DataGridItem Item in dgList.Items)
                    {
                        CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                        HiddenField hddVuAnID = (HiddenField)Item.FindControl("hddVuAnID");
                        HiddenField hddIsMapVuAn = (HiddenField)Item.FindControl("hddIsMapVuAn");
                        HiddenField hddIsThuLy = (HiddenField)Item.FindControl("hddIsThuLy");
                        HiddenField hddArrDonTrung = (HiddenField)Item.FindControl("hddArrDonTrung");

                        if (chkChon.Checked)
                        {
                            string strID = Item.Cells[0].Text;
                            decimal DonID = Convert.ToDecimal(strID);
                            //ID của vụ án nếu Đơn đã ghép với Vụ án tức Don.Vuviecid  = va.ID
                            //decimal VuAnID = Convert.ToDecimal(hddVuAnID.Value);
                            //int ismap_vuan = Convert.ToInt16(hddIsMapVuAn.Value);
                            //int isthuly = Convert.ToInt16(hddIsThuLy.Value);
                            //Boolean IsKQ = true;
                            ////Kiem tra xem vu an da co KQ chua
                            //if (VuAnID > 0)
                            //    IsKQ = CheckKQGQ(VuAnID);
                            GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == DonID).FirstOrDefault();
                            /*nhan don tat ca cac vụ
                            -don thu ly moi(Chưa nhan đơn)-- > map duoc vu an
                            -- > se kiem tra : Da co giai quyet don hay chua-- > co roi thì cho ghep vu an
                            --> chua co-- > Tao mới vu an(nhu bay gio)*/
                            //node:03.08.2020  
                            //COMMENT ON COLUMN GDTTT_DON.CD_TRANGTHAI IS 'TRANG THAI CHUYEN(0,null Chưa chuyển,1 Đã chuyển,2 Đã nhận,3 Bị trả lại (phải xóa công văn chuyển vụ mới được trả lại), 4 Bị trả lại nhưng chỉ sửa những thông tin cơ bản (không được hủy trùng và xóa đơn kèm theo) )';
                            //COMMENT ON COLUMN GDTTT_DON.CD_LOAI  IS 'NOICHUYEN(0 nội bộ,1 tòa khác,2 ngoài tòa án)';
                            //COMMENT ON COLUMN GDTTT_DON.CD_TA_TRANGTHAI IS '(1 Đơn chưa đủ điều kiện,0 Đơn đủ điều kiện,2 truong hop tu chua du dk thanh du dk thu ly)';
                            //COMMENT ON COLUMN GDTTT_DON.BAQD_TOAANID IS 'Tòa xét xử';
                            //COMMENT ON COLUMN GDTTT_DON.BAQD_LOAIAN IS 'Loại án ID';
                            //COMMENT ON COLUMN GDTTT_DON.BAQD_CAPXETXU IS 'Cấp xét xử';
                            //COMMENT ON COLUMN GDTTT_DON.DONTRUNGID IS 'Đơn trùng';
                            //COMMENT ON COLUMN GDTTT_DON.CD_SOCV IS 'Số công văn chuyển';
                            //-----------------------------
                            if (oT != null)
                            {
                                if (oT.CD_LOAI == 0)//oT.CD_TRANGTHAI == 1 &&
                                {
                                    #region update don chuyen
                                    //Update danh sách lịch sử chuyển đơn;
                                    List<GDTTT_DON_CHUYEN> lstC = dt.GDTTT_DON_CHUYEN.Where(x => x.DONID == DonID
                                                                                            && x.DONVINHANID == ToaAnID
                                                                                            && x.PHONGBANNHANID == PhongBanID
                                                                                          ).OrderByDescending(x => x.NGAYCHUYEN).ToList();
                                    if (lstC.Count > 0)
                                    {
                                        iCount += 1;
                                        GDTTT_DON_CHUYEN oC = lstC[0];
                                        //lưu ngày nhận thực tế
                                        oC.NGAYNHAN = DateTime.Now;
                                        oC.TRANGTHAI = 2;
                                        oC.NGUOINHAN = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                        oC.GHICHU = txtBC_Ghichu.Text;
                                        dt.SaveChanges();
                                    }
                                    #endregion
                                }
                            }
                        }
                    }
                    //---------------------------------
                    if (iCount == 0)
                        ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Chưa chọn đơn cần nhận!')", true);
                    else
                    {
                        Load_Data();
                        //lbtthongbao.Text = "Hoàn thành nhận " + iCount.ToString() + " đơn !";
                        ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Hoàn thành nhận " + iCount.ToString() + " đơn !')", true);
                    }
                }
                else
                {
                    ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Tài khoản chưa gán với Phòng ban!')", true);
                }
            }
            else if (rdbTrangThai.SelectedValue == "2")
            {
                //chuyen cac vu
                if (Check_Chuyendon() == true)
                {
                    try
                    {
                        decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
                        decimal PhongbanID = Convert.ToDecimal(ddlPhongban.SelectedValue);
                        decimal PBID = 0;
                        if (strPBID != "") PBID = Convert.ToDecimal(strPBID);

                        bool flag = false;
                        int iCount = 0;
                        foreach (DataGridItem Item in dgList.Items)
                        {
                            CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                            if (chkChon.Checked)
                            {
                                flag = true;
                                string strID = Item.Cells[0].Text;
                                decimal ID = Convert.ToDecimal(strID);
                                GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();
                                if (oT != null)
                                {
                                    //node:03.08.2020  
                                    //COMMENT ON COLUMN GDTTT_DON.CD_TRANGTHAI IS 'TRANG THAI CHUYEN(0,null Chưa chuyển,1 Đã chuyển,2 Đã nhận,3 Bị trả lại)';
                                    //COMMENT ON COLUMN GDTTT_DON.CD_LOAI  IS 'NOICHUYEN(0 nội bộ,1 tòa khác,2 ngoài tòa án)';
                                    //COMMENT ON COLUMN GDTTT_DON.CD_TA_TRANGTHAI IS '(1 Đơn chưa đủ điều kiện,0 Đơn đủ điều kiện)';
                                    //COMMENT ON COLUMN GDTTT_DON.BAQD_TOAANID IS 'Tòa xét xử';
                                    //COMMENT ON COLUMN GDTTT_DON.BAQD_LOAIAN IS 'Loại án ID';
                                    //COMMENT ON COLUMN GDTTT_DON.BAQD_CAPXETXU IS 'Cấp xét xử';
                                    //COMMENT ON COLUMN GDTTT_DON.DONTRUNGID IS 'Đơn trùng';
                                    //COMMENT ON COLUMN GDTTT_DON.CD_SOCV IS 'Số công văn chuyển';
                                    oT.CD_TRANGTHAI = 1;
                                    oT.CD_NGAYXULY = DateTime.Now;
                                    //---------------------------------
                                    //if ((oT.CD_SOTOTRINH + "") != "")
                                    //{
                                    iCount += 1;
                                    Update_DonChuyen(oT, PBID, chkChon.ToolTip);
                                    //CHuyển đồng thời các đơn trùng kèm theo
                                    string[] strarr = chkChon.ToolTip.Split(',');
                                    if (strarr.Length > 1)
                                    {
                                        for (int k = 0; k < strarr.Length; k++)
                                        {
                                            decimal kID = Convert.ToDecimal(strarr[k]);
                                            GDTTT_DON kDon = dt.GDTTT_DON.Where(x => x.ID == kID).FirstOrDefault();
                                            kDon.CD_TRANGTHAI = 1;
                                            kDon.CD_NGAYXULY = oT.CD_NGAYXULY;
                                        }
                                    }
                                    //}
                                }
                            }
                        }
                        dt.SaveChanges();
                        if (flag == false)
                        {
                            //lbtthongbao.Text = "Chưa chọn đơn để chuyển !";
                            ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Chưa chọn đơn để chuyển!')", true);
                            return;
                        }
                        else
                        {

                            Load_Data();
                            //lbtthongbao.Text = "Hoàn thành chuyển " + iCount.ToString() + " đơn !";
                            ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Hoàn thành chuyển " + iCount.ToString() + " đơn !')", true);
                        }
                    }
                    catch (Exception ex)
                    {
                        lbtthongbao.Text = "Lỗi khi chuyển đơn: " + ex.Message;

                    }
                }
            }
            else if (rdbTrangThai.SelectedValue == "4")//Thu hồi
            {
                try
                {
                    decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
                    decimal PBID = 0;
                    if (strPBID != "") PBID = Convert.ToDecimal(strPBID);

                    bool flag = false;
                    int iCount = 0;
                    String da_nhan = "";//add 06/04/2021
                    foreach (DataGridItem Item in dgList.Items)
                    {
                        CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                        if (chkChon.Checked)
                        {
                            flag = true;
                            string strID = Item.Cells[0].Text;
                            decimal ID = Convert.ToDecimal(strID);
                            GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();
                            //----Lấy đơn vị của thẩm phán được phân công
                            //DM_CANBO cb = dt.DM_CANBO.Where(x => x.ID == oT.THAMPHANID).FirstOrDefault();
                            //----Lấy đơn vị giải quyết 
                            GDTTT_DON_CHUYEN objc = dt.GDTTT_DON_CHUYEN.Where(x => x.DONID == ID && x.DONVINHANID == oT.TOAANID
                            && x.PHONGBANNHANID == oT.CD_TA_DONVIID).FirstOrDefault();

                            //COMMENT ON COLUMN GDTTT_DON.CD_TRANGTHAI IS 'TRANG THAI CHUYEN(0,null Chưa chuyển,1 Đã chuyển,2 Đã nhận,3 Bị trả lại)';
                            //COMMENT ON COLUMN GDTTT_DON.CD_LOAI  IS 'NOICHUYEN(0 nội bộ,1 tòa khác,2 ngoài tòa án)';
                            //COMMENT ON COLUMN GDTTT_DON.CD_TA_TRANGTHAI IS '(1 Đơn chưa đủ điều kiện,0 Đơn đủ điều kiện)';
                            //COMMENT ON COLUMN GDTTT_DON.BAQD_TOAANID IS 'Tòa xét xử';
                            //COMMENT ON COLUMN GDTTT_DON.BAQD_LOAIAN IS 'Loại án ID';
                            //COMMENT ON COLUMN GDTTT_DON.BAQD_CAPXETXU IS 'Cấp xét xử';
                            //COMMENT ON COLUMN GDTTT_DON.DONTRUNGID IS 'Đơn trùng';
                            //COMMENT ON COLUMN GDTTT_DON.CD_SOCV IS 'Số công văn chuyển';

                            if (objc.TRANGTHAI == 2)//1 Chưa nhận; 2 Đã nhận; 3 Trả lại; 4 Đã chuyển
                            {
                                da_nhan += oT.NGUOIGUI_HOTEN + ";";
                            }
                            if ((objc.TRANGTHAI == 1) && (oT.CD_LOAI > 0 || (oT.CD_LOAI == 0 && oT.CD_TA_TRANGTHAI == 0)))
                            {
                                oT.CD_TRANGTHAI = 0;
                                oT.CD_NGAYXULY = DateTime.Now;
                                iCount += 1;
                                string strArrDon = chkChon.ToolTip;
                                string[] strarr = strArrDon.Split(',');

                                //CHuyển đồng thời các đơn trùng kèm theo
                                if (strarr.Length > 1)
                                {
                                    for (int k = 0; k < strarr.Length; k++)
                                    {
                                        decimal kID = Convert.ToDecimal(strarr[k]);
                                        GDTTT_DON kDon = dt.GDTTT_DON.Where(x => x.ID == kID).FirstOrDefault();
                                        kDon.CD_TRANGTHAI = 0;
                                        dt.SaveChanges();
                                    }
                                }
                                //Xóa thông tin đẫ chuyển từ bảng đơn chuyển KHi Thu Hồi đơn
                                xoa_thongtinchuyen(ID, Convert.ToDecimal(oT.CD_TA_DONVIID));

                                GDTTT_DON_CHUYEN objLUp;
                                List<GDTTT_DON_CHUYEN> lstUp = dt.GDTTT_DON_CHUYEN.Where(x => x.DONID == ID && x.DONVINHANID == oT.TOAANID && x.PHONGBANNHANID == PBID).OrderByDescending(x => x.NGAYCHUYEN).ToList();
                                if (lstUp.Count > 0)
                                {
                                    objLUp = lstUp[0];
                                    objLUp.TRANGTHAI = 2;//update về đã nhận
                                    da_nhan += "";
                                }


                            }
                            dt.SaveChanges();
                        }
                    }
                    dt.SaveChanges();
                    if (flag == false)
                    {
                        //lbtthongbao.Text = "Chưa chọn đơn để thu hồi !";
                        ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Chưa chọn đơn để thu hồi !')", true);
                        return;
                    }
                    else
                    {
                        Load_Data();
                        if (da_nhan != "")
                        {
                            //lbtthongbao.Text = "đơn: " + da_nhan + " đã nhận không thể thu hồi";
                            ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('đơn: " + da_nhan + " đã nhận không thể thu hồi !')", true);
                        }
                        else
                        {
                            //lbtthongbao.Text = "Hoàn thành thu hồi " + iCount.ToString() + " đơn !";
                            ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Hoàn thành thu hồi " + iCount.ToString() + " đơn !')", true);
                        }
                    }
                }
                catch (Exception ex)
                {
                    lbtthongbao.Text = "Lỗi khi chuyển đơn: " + ex.Message;
                }
            }
        }
        void Update_DonChuyen(GDTTT_DON oT, Decimal PBID, String ArrDonTrung)
        {
            Decimal DonID = oT.ID;
            GDTTT_DON_CHUYEN objLS;
            List<GDTTT_DON_CHUYEN> lstC = dt.GDTTT_DON_CHUYEN.Where(x => x.DONID == DonID
            && x.DONVINHANID == oT.TOAANID
            && x.PHONGBANNHANID == oT.CD_TA_DONVIID).OrderByDescending(x => x.NGAYCHUYEN).ToList();
            //List<GDTTT_DON_CHUYEN> lstC = dt.GDTTT_DON_CHUYEN.Where(x => x.DONID == DonID).OrderByDescending(x => x.NGAYCHUYEN).ToList();
            if (lstC.Count > 0)
                objLS = lstC[0];
            else
                objLS = new GDTTT_DON_CHUYEN();
            objLS.DONID = DonID;
            objLS.DONVICHUYENID = oT.TOAANID;

            objLS.PHONGBANCHUYENID = PBID;

            objLS.NGAYCHUYEN = DateTime.Now;
            objLS.TRANGTHAI = 1;//đã chuyển
            objLS.NGUOICHUYEN = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            objLS.SOCV = oT.CD_SOCV;
            objLS.NGUOIKY = oT.CD_NGUOIKY;
            objLS.NGAYCV = oT.CD_NGAYCV;
            objLS.LOAICHUYEN = oT.CD_LOAI;

            string[] strarr = ArrDonTrung.Split(',');
            objLS.SOLUONGDON = strarr.Length;//Số lượng đơn chuyển đến
            objLS.ARRDONTRUNG = ArrDonTrung;//Danh sách các đơn chuyển cùng 
            switch ((int)oT.CD_LOAI) //COMMENT ON COLUMN GDTTT_DON.CD_LOAI  IS 'NOICHUYEN(0 nội bộ,1 tòa khác,2 ngoài tòa án)';
            {
                case 0:
                    objLS.DONVINHANID = oT.TOAANID;
                    objLS.PHONGBANNHANID = oT.CD_TA_DONVIID;
                    break;
                case 1:
                    objLS.DONVINHANID = oT.CD_TK_DONVIID;
                    objLS.PHONGBANNHANID = 0;
                    break;
            }
            if (lstC.Count == 0)
                dt.GDTTT_DON_CHUYEN.Add(objLS);
            dt.SaveChanges();
            //---------------------------
            GDTTT_DON_CHUYEN objLUp;
            DM_CANBO cb = dt.DM_CANBO.Where(x => x.ID == oT.THAMPHANID).FirstOrDefault();
            List<GDTTT_DON_CHUYEN> lstUp = dt.GDTTT_DON_CHUYEN.Where(x => x.DONID == DonID && x.DONVINHANID == oT.TOAANID && x.PHONGBANNHANID == cb.PHONGBANID).OrderByDescending(x => x.NGAYCHUYEN).ToList();
            if (lstUp.Count > 0)
            {
                objLUp = lstUp[0];
                objLUp.TRANGTHAI = 4;//đã chuyển
            }
            dt.SaveChanges();
        }
        protected void cmdTralai_Click(object sender, EventArgs e)
        {
            if (Check_TraLai() == true)
            {
                //Kiểm tra ngày trả lại đơn
                if (txtBC_Ngay.Text == "")
                {
                    lbtthongbao.Text = "Chưa nhập ngày trả lại đơn !";
                    lbtthongbao.ForeColor = System.Drawing.Color.Red;
                    txtBC_Ngay.Focus();
                }
                DateTime? vNgayNhan = txtBC_Ngay.Text == "" ? (DateTime?)null : DateTime.Parse(txtBC_Ngay.Text, cul, DateTimeStyles.NoCurrentDateDefault);

                decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
                decimal PhongbanID = Convert.ToDecimal(ddlPhongban.SelectedValue);
                String strMsg = "";
                bool flag = false;
                int iCount = 0;
                Decimal CurrVuAnID = 0;
                // String ListNguoiKN = "";
                foreach (DataGridItem Item in dgList.Items)
                {
                    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                    if (chkChon.Checked)
                    {
                        flag = true;
                        string strID = Item.Cells[0].Text;
                        decimal ID = Convert.ToDecimal(strID);
                        GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();

                        CurrVuAnID = (String.IsNullOrEmpty(oT.VUVIECID + "") ? 0 : (Decimal)oT.VUVIECID);
                        if ((oT.CD_LOAI > 0 || (oT.CD_LOAI == 0 && oT.CD_TA_TRANGTHAI == 0)))
                        {
                            iCount += 1;
                            //COMMENT ON COLUMN GDTTT_DON.CD_TRANGTHAI IS 'TRANG THAI CHUYEN(0,null Chưa chuyển,1 Đã chuyển,2 Đã nhận,3 Bị trả lại (phải xóa công văn chuyển vụ mới được trả lại),4 Bị trả lại nhưng không được sửa)';
                            if (ddlTralai_truonghop.SelectedValue == "2")
                            {
                                oT.CD_TRANGTHAI = 4;
                            }
                            else
                            {
                                oT.CD_TRANGTHAI = 3;
                            }
                            oT.CD_NGAYXULY = vNgayNhan;
                            dt.SaveChanges();
                            //Update danh sách lịch sử chuyển đơn;
                            update_lichsu_chuyendon(ID, ToaAnID, PhongBanID, (DateTime)oT.CD_NGAYXULY);
                            //16/10/2024 đóng lại vì đơn kem theo list không cần update CD_TRANGTHAI vì lấy theo arr_don_id và CD_TA_TRANGTHAI=3 là đơn kèm theo
                            //Update danh sách các đơn chuyển cùng
                            //try
                            //{
                            //    string strArrDon = chkChon.ToolTip;
                            //    string[] strarr = strArrDon.Split(',');
                            //    if (strarr.Length > 1)
                            //    {
                            //        strArrDon = "," + strArrDon + ",";
                            //        List<GDTTT_DON> lstTrung = dt.GDTTT_DON.Where(x => x.ID != oT.ID
                            //                                                        && strArrDon.Contains("," + x.ID.ToString() + ",")).ToList();
                            //        foreach (GDTTT_DON oDT in lstTrung)
                            //        {
                            //            if (ddlTralai_truonghop.SelectedValue == "2")
                            //            {
                            //                oDT.CD_TRANGTHAI = 4;
                            //            }
                            //            else
                            //            {
                            //                oDT.CD_TRANGTHAI = 3;
                            //            }
                            //            oDT.VUVIECID = 0;
                            //            ListNguoiKN += (String.IsNullOrEmpty(ListNguoiKN + "") ? "" : ", ") + (String.IsNullOrEmpty(oDT.NGUOIGUI_HOTEN + "") ? "" : oDT.NGUOIGUI_HOTEN);
                            //        }
                            //        dt.SaveChanges();
                            //    }
                            //}
                            //catch (Exception ex) { }
                        }
                        dt.SaveChanges();
                    }
                }
                if (flag == false)
                {
                    strMsg = "Bạn chưa chọn đơn cần trả lại";
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                    return;
                }
                if (txtBC_Ghichu.Text == "")
                {
                    strMsg = "Bạn phải nhập lý do trả lại";
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                    return;
                }
                if (iCount >= 0)
                {
                    Load_Data();
                    strMsg = "Hoàn thành trả lại " + iCount.ToString() + " đơn !";
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                }
            }
        }
        private bool Check_TraLai()
        {
            decimal CurrDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            String strMsg = "";
            if (ddlTralai_truonghop.SelectedValue == "0")
            {
                strMsg = "Bạn chưa chọn trường hợp trả lại";
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                return false;
            }
            if (ddlTralai_truonghop.SelectedValue == "1")
            {
                foreach (DataGridItem Item in dgList.Items)
                {
                    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                    if (chkChon.Checked)
                    {
                        string strID = Item.Cells[0].Text;
                        decimal ID = Convert.ToDecimal(strID);
                        GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();
                        GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                        if (oBL.CHECK_SOVB_DON("CV_VUGD", CurrDonViID, PhongBanID, ID) != 0)//CV_VUGD con van chuyen vu
                        {
                            strMsg = "Bạn phải xóa công văn chuyển vụ trước";
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                            return false;
                        }
                    }
                }
            }
            return true;
        }
        void update_lichsu_chuyendon(Decimal CurrDonID, Decimal CurrDonViNhanID, Decimal CurrPhongBanID, DateTime CurrNgayNhan)
        {
            try
            {
                List<GDTTT_DON_CHUYEN> lstC = dt.GDTTT_DON_CHUYEN.Where(x => x.DONID == CurrDonID
                                                                            && x.DONVINHANID == CurrDonViNhanID
                                                                            && x.PHONGBANNHANID == CurrPhongBanID).OrderByDescending(x => x.NGAYCHUYEN).ToList();
                if (lstC.Count > 0)
                {
                    GDTTT_DON_CHUYEN oC = lstC[0];
                    //lưu ngày nhận là ngày hiện tại CurrNgayNhan
                    //oC.NGAYNHAN = DateTime.Now;
                    //oC.TRANGTHAI = 3;
                    //oC.NGUOINHAN = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    //oC.GHICHU = txtBC_Ghichu.Text;
                    //dt.SaveChanges();
                    //lưu thông tin đơn trả lại vào bảng lịch xử
                    GDTTT_DON_CHUYEN_HISTORY oH = new GDTTT_DON_CHUYEN_HISTORY();
                    oH.DONID = oC.DONID;
                    oH.DONVICHUYENID = oC.DONVICHUYENID;
                    oH.DONVINHANID = oC.DONVINHANID;
                    oH.NGAYCHUYEN = oC.NGAYCHUYEN;
                    oH.NGAYNHAN = oC.NGAYNHAN;
                    oH.TRANGTHAI = 3;
                    oH.NGUOICHUYEN = oC.NGUOICHUYEN;
                    oH.NGUOINHAN = oC.NGUOINHAN;
                    oH.PHONGBANCHUYENID = oC.PHONGBANCHUYENID;
                    oH.PHONGBANNHANID = oC.PHONGBANNHANID;
                    oH.SOCV = oC.SOCV;
                    oH.NGAYCV = oC.NGAYCV;
                    oH.NGUOIKY = oC.NGUOIKY;
                    oH.LOAICHUYEN = oC.LOAICHUYEN;
                    oH.GHICHU = txtBC_Ghichu.Text;
                    oH.SOLUONGDON = oC.SOLUONGDON;
                    oH.ARRDONTRUNG = oC.ARRDONTRUNG;
                    oH.NGAYTRA = DateTime.Now;
                    oH.NGUOITRA = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                    dt.GDTTT_DON_CHUYEN_HISTORY.Add(oH);
                    dt.SaveChanges();
                    //Xóa thông tin đẫ chuyển từ bảng đơn chuyển
                    dt.GDTTT_DON_CHUYEN.Remove(oC);
                    dt.SaveChanges();

                }
            }
            catch (Exception ex) { }
        }
        protected void txtBC_Ngaydk_TextChanged(object sender, EventArgs e)
        {
        }
        protected void btnLuuVB_Click(object sender, EventArgs e)
        {
            //lay ID gan voi User
            QT_NGUOISUDUNG objuser = dt.QT_NGUOISUDUNG.Where(x => x.ID == USERID).Single();
            if ((txtBC_Ngaydk.Text == "" || txtBC_SoCV.Text == "" || txtBC_Nguoiky.Text == ""))
            {
                //lbtthongbao.Text = "Chưa nhập đầy đủ thông tin số công văn, ngày chuyển, người ký!";
                ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Chưa nhập đầy đủ thông tin số công văn, ngày chuyển, người ký!')", true);
                return;
            }
            else
            {
                try
                {
                    GDTTT_DON_BL oBL = new GDTTT_DON_BL();

                    decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
                    decimal PBID = 0;
                    if (strPBID != "") PBID = Convert.ToDecimal(strPBID);
                    //kiem tra đã có số CV chưa
                    bool flag = false;
                    string mess;
                    //Kiem tra xem số công văn chuyển này đã có chưa 
                    string vCD_SOCV = txtBC_SoCV.Text;
                    DateTime vCD_NGAYCV = (String.IsNullOrEmpty(txtBC_Ngaydk.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtBC_Ngaydk.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                    //Lấy các đơn id sẽ thêm số
                    string donid_chon = null;
                    foreach (DataGridItem Item in dgList.Items)
                    {
                        CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                        if (chkChon.Checked)
                        {
                            flag = true;
                            string strID = Item.Cells[0].Text;
                            if (donid_chon == null)
                                donid_chon = strID;
                            else
                                donid_chon = donid_chon + ',' + strID;
                        }

                    }
                    if (donid_chon != null)
                    {
                        //Kiểm tra đơn đã có số chưa, nếu có rồi thì không cho thêm số
                        string[] strarr = donid_chon.Split(',');
                        if (strarr.Length > 0)
                        {
                            for (int k = 0; k < strarr.Length; k++)
                            {
                                decimal kID = Convert.ToDecimal(strarr[k]);
                                if (oBL.CHECK_DON_LUUSO_CANHAN(CurrDonViID, PhongBanID, Convert.ToDecimal(objuser.CANBOID), ddlLoaiso.SelectedValue, kID) == true)
                                {
                                    mess = "alert('Đơn này đã Có Số " + ddlLoaiso.SelectedItem + "! Bạn kiểm tra lại')";
                                    ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", mess, true);
                                    return;
                                }
                            }
                        }
                    }

                    if (flag == false)
                    {
                        ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Chưa chọn đơn để thêm số Công văn!')", true);
                        //lbtthongbao.Text = "Chưa chọn đơn để thêm số Công văn!";
                        return;
                    }


                    // kiem tra SOCV da ton tai chua CHECK_SOVANBAN
                    decimal vPHATHANHID = 0;
                    if (oBL.CHECK_SOVANBAN_CANHAN(CurrDonViID, PhongBanID, Convert.ToDecimal(objuser.CANBOID), ddlLoaiso.SelectedValue, vCD_SOCV, txtBC_Ngaydk.Text.Trim()) == true)
                    {
                        mess = "alert('Số" + ddlLoaiso.SelectedItem + " " + vCD_SOCV + " Ngày " + vCD_NGAYCV.ToString("dd/MM/yyyy") + " này đã tồn tại! Bạn kiểm tra lại')";
                        ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", mess, true);
                    }
                    else
                    {
                        //Thêm các loại Công Văn Tham phan 
                        //insert vao So Van ban
                        vPHATHANHID = oBL.SOVANBAN_INSERT(CurrDonViID, PhongBanID, 0, Convert.ToDecimal(objuser.CANBOID).ToString(), ddlLoaiso.SelectedValue, vCD_SOCV, txtBC_Ngaydk.Text.Trim(),
                            txtBC_Nguoiky.Text.Trim(), null, Session[ENUM_SESSION.SESSION_USERNAME] + "");
                        if (vPHATHANHID > 0)
                        {
                            mess = "Cập nhật Số Văn bản thành công!";
                            foreach (DataGridItem Item in dgList.Items)
                            {
                                CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                                if (chkChon.Checked)
                                {

                                    string strID = Item.Cells[0].Text;
                                    decimal ID = Convert.ToDecimal(strID);
                                    //Insert sophathanh_don
                                    oBL.SOPHATHANH_DON_INSERT(vPHATHANHID, ID, Session[ENUM_SESSION.SESSION_USERNAME] + "");
                                    //Chuyển đồng thời các đơn trùng kèm theo
                                    string[] strarr = chkChon.ToolTip.Split(',');
                                    if (strarr.Length > 1)
                                    {
                                        for (int k = 0; k < strarr.Length; k++)
                                        {
                                            decimal kID = Convert.ToDecimal(strarr[k]);
                                            oBL.SOPHATHANH_DON_INSERT(vPHATHANHID, kID, Session[ENUM_SESSION.SESSION_USERNAME] + "");
                                        }
                                    }
                                }
                            }
                        }
                        else
                            mess = "Cập nhật Số Văn bản lỗi. Liên hệ với quản trị để được hỗ trợ!";


                        ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('" + mess + "!')", true);
                    }

                    //Lay so van ban theo loại VB
                    Layso_SoVB();
                    Load_Data();
                }
                catch (Exception ex)
                {
                    lbtthongbao.Text = "Lỗi khi thêm số Công văn: " + ex.Message;
                }
            }
        }

        protected void btnQuanlyVB_Click(object sender, EventArgs e)
        {
            Response.Redirect("/QLAN/GDTTT/Hoso/Quanlycapso.aspx");
        }

        private string AddExcelStyling(Int32 landscape, String INSERT_PAGE_BREAK)
        {
            // add the style props to get the page orientation
            StringBuilder sb = new StringBuilder();
            sb.Append("<html xmlns:o='urn:schemas-microsoft-com:office:office'\n" +
            "xmlns:x='urn:schemas-microsoft-com:office:excel'\n" +
            "xmlns='http://www.w3.org/TR/REC-html40'>\n" +
            "<head>\n");
            sb.Append("<style>\n");
            sb.Append("@page");
            //page margin can be changed based on requirement.....            
            //sb.Append("{margin:0.5in 0.2992125984in 0.5in 0.5984251969in;\n");
            sb.Append("{margin:0.5905511811in 0.2992125984in 0.5905511811in 0.5984251969in;\n");
            sb.Append("mso-header-margin:.5in;\n");
            sb.Append("mso-footer-margin:.5in;\n");
            if (landscape == 2)//landscape orientation
            {
                sb.Append("mso-page-orientation:landscape;}\n");
            }
            sb.Append("</style>\n");
            sb.Append("<!--[if gte mso 9]><xml>\n");
            sb.Append("<x:ExcelWorkbook>\n");
            sb.Append("<x:ExcelWorksheets>\n");
            sb.Append("<x:ExcelWorksheet>\n");
            sb.Append("<x:Name>Projects 3 </x:Name>\n");
            sb.Append("<x:WorksheetOptions>\n");
            sb.Append("<x:Print>\n");
            sb.Append("<x:ValidPrinterInfo/>\n");
            sb.Append("<x:PaperSizeIndex>9</x:PaperSizeIndex>\n");
            sb.Append("<x:HorizontalResolution>600</x:HorizontalResolution\n");
            sb.Append("<x:VerticalResolution>600</x:VerticalResolution\n");
            sb.Append("</x:Print>\n");
            sb.Append("<x:Selected/>\n");
            sb.Append("<x:DoNotDisplayGridlines/>\n");
            sb.Append("<x:ProtectContents>False</x:ProtectContents>\n");
            sb.Append("<x:ProtectObjects>False</x:ProtectObjects>\n");
            sb.Append("<x:ProtectScenarios>False</x:ProtectScenarios>\n");
            sb.Append("</x:WorksheetOptions>\n");
            //-------------
            if (INSERT_PAGE_BREAK != null)
            {
                sb.Append("<x:PageBreaks> xmlns='urn:schemas-microsoft-com:office:excel'\n");
                sb.Append("<x:RowBreaks>\n");
                String[] rows_ = INSERT_PAGE_BREAK.Split(',');
                String Append_s = "";
                for (int i = 0; i < rows_.Length; i++)
                {
                    Append_s = Append_s + "<x:RowBreak><x:Row>" + rows_[i] + "</x:Row></x:RowBreak>\n";
                }
                sb.Append(Append_s);
                sb.Append("</x:RowBreaks>\n");
                sb.Append("</x:PageBreaks>\n");
            }
            //----------
            sb.Append("</x:ExcelWorksheet>\n");
            sb.Append("</x:ExcelWorksheets>\n");
            sb.Append("<x:WindowHeight>12780</x:WindowHeight>\n");
            sb.Append("<x:WindowWidth>19035</x:WindowWidth>\n");
            sb.Append("<x:WindowTopX>0</x:WindowTopX>\n");
            sb.Append("<x:WindowTopY>15</x:WindowTopY>\n");
            sb.Append("<x:ProtectStructure>False</x:ProtectStructure>\n");
            sb.Append("<x:ProtectWindows>False</x:ProtectWindows>\n");
            sb.Append("</x:ExcelWorkbook>\n");
            sb.Append("</xml><![endif]-->\n");
            sb.Append("</head>\n");
            sb.Append("<body>\n");
            return sb.ToString();
        }
    }
}