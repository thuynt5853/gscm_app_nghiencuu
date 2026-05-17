using BL.GSTP;
using BL.GSTP.BANGSETGET;
using BL.GSTP.GDTTT;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;
using WEB.GSTP.QLAN.GDTTT.In;
namespace WEB.GSTP.QLAN.GDTTT.Giaiquyet
{
    public partial class Danhsach : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        GDTTT_VUAN_KETQUA_BL oVAKQ = new GDTTT_VUAN_KETQUA_BL();
        private const decimal ROOT = 0;
        public Decimal PhongBanID = 0;
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
            
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            PhongBanID = (String.IsNullOrEmpty(strPBID + "")) ? 0 : Convert.ToDecimal(strPBID);
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

                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                if (oPer.DULIEU == true)
                    LoadDropTTV_TheoCanBoLogin();
                else
                {
                    LoadAll_TTV();
                }
                    

                //load loai an
                LoadDropLoaiAn();

                SetGetSessionTK(false);
                LoadDropThamphan();
                Load_Data();
                set_button();
               
                SetTieuDeBaoCao();
                
                cmdGiaoTHS.Visible = true;
               
            }
        }
        void LoadDropThamphan()
        {
            Decimal ChucVuPCA = 0;
            Decimal ChucVuCA = 0;
            Decimal ChucDanh_TPTATC = 0;
            Decimal ChucDanh_TPCC = 0;
            int count = 0;
            try { ChucVuPCA = dt.DM_DATAITEM.Where(x => x.MA == "PCA").FirstOrDefault().ID; } catch (Exception ex) { }
            try { ChucVuCA = dt.DM_DATAITEM.Where(x => x.MA == "CA").FirstOrDefault().ID; } catch (Exception ex) { }
            try { ChucDanh_TPTATC = dt.DM_DATAITEM.Where(x => x.MA == "TPTATC").FirstOrDefault().ID; } catch (Exception ex) { }
            try { ChucDanh_TPCC = dt.DM_DATAITEM.Where(x => x.MA == "TPCC").FirstOrDefault().ID; } catch (Exception ex) { }

            Decimal LoginDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            //Load Thẩm phán
            GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();
            Boolean IsLoadAll = false;
            ddlThamphan.Items.Clear();
            Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault();
            if (oCB.CHUCVUID != null && oCB.CHUCVUID == ChucVuPCA || oCB.CHUCVUID == ChucVuCA)
            {
                if (oCB.CHUCDANHID == ChucDanh_TPTATC || oCB.CHUCDANHID == ChucDanh_TPCC)
                {
                    //ddlThamphan.Items.Add(new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                    hddLoaiTK.Value = ENUM_CHUCDANH.CHUCDANH_THAMPHAN;
                    //----------anhvh add 30/10/2019
                    DataTable tbl = oGDTBL.GDTTT_Tp_Duoc_Phutrach(Session[ENUM_SESSION.SESSION_DONVIID] + "", Convert.ToInt32(oCB.ID));
                    ddlThamphan.DataSource = tbl;
                    ddlThamphan.DataTextField = "HOTEN";
                    ddlThamphan.DataValueField = "ID";
                    ddlThamphan.DataBind();
                }
                else
                    IsLoadAll = true;
            }
            else if (oCB.CHUCDANHID != null && oCB.CHUCDANHID != 0)
            {
                //DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCDANHID).FirstOrDefault();
                if (oCB.CHUCDANHID == ChucDanh_TPTATC || oCB.CHUCDANHID == ChucDanh_TPCC)
                {
                    ddlThamphan.Items.Add(new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                    hddLoaiTK.Value = ENUM_CHUCDANH.CHUCDANH_THAMPHAN;
                }
                else
                    IsLoadAll = true;
            }
            else
                IsLoadAll = true;
            if (IsLoadAll)
            {
                //DataTable oCBDT = oGDTBL.CANBO_GETBYDONVI(LoginDonViID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                DataTable tbl = oGDTBL.GDTTT_VuAn_GetAllCBTheoPB(LoginDonViID, PBID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                count = tbl.Rows.Count;
                ddlThamphan.DataSource = tbl;
                ddlThamphan.DataTextField = "HOTEN";
                ddlThamphan.DataValueField = "ID";
                ddlThamphan.DataBind();
                ddlThamphan.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
                //ddlThamphan.Items.Insert(count + 1, new ListItem("-- Chưa phân công --", "-1"));
            }
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
                    Session[SS_TK.THAMTRAVIEN] = ddlThamtravien.SelectedValue;
                    Session[SS_TK.GhepDon_VuAn] = rdGhepVuAn.SelectedValue;
                    Session[SS_TK.GIAOTHS] = ddlGiaoTHS.SelectedValue;
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
                        ddlTinh_SelectedIndexChanged( null, null);
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
            decimal vPhancongTTV = Convert.ToDecimal(ddlThamtravien.SelectedValue);
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
            Decimal DiaChiHuyen = Convert.ToDecimal(ddlHuyen.SelectedValue); //, TraLoi = Convert.ToDecimal(ddlTraloi.SelectedValue);
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
            decimal vCD_DONVIID = 0;
            decimal vPhancongTTV = 0;
            if (Session["CAP_XET_XU"] + "" == "CAPTINH")
            {
                //vCD_DONVIID = 382;
                vCD_DONVIID = PhongBanID;
                vPhancongTTV = 0;
            }
            else
            {
                vPhancongTTV = Convert.ToDecimal(ddlThamtravien.SelectedValue);
                vCD_DONVIID = Convert.ToDecimal(ddlPhongban.SelectedValue);
            }
               

            DateTime? vNgaychuyenTu = txtNgaychuyenTu.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgaychuyenTu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime? vNgaychuyenDen = txtNgaychuyenDen.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgaychuyenDen.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            decimal vIsThuLy = Convert.ToDecimal(ddlThuLy.SelectedValue);
            decimal vPhanloaixuly = Convert.ToDecimal(ddlPhanloaiDdon.SelectedValue);
            if (ddlThuLy.Visible == false) vIsThuLy = -1;

            DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            string vSoThuly = txtThuly_So.Text;
           
            //them loai an 
            decimal vLoaiAn = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
            decimal vGiaoTHS = Convert.ToDecimal(ddlGiaoTHS.SelectedValue);
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
            //tạm đóng
                oDT = oBL.GDTTT_GIAIQUYET_SEARCH(ddlNoiChuyen.SelectedValue,ddlThamphan.SelectedValue, ToaAnID, ToaRaBAQD, SoBAQD, NgayBAQD, NguoiGui,
                                        SoCMND, TuNgay, DenNgay, HinhThucDon, SoHieuDon, DiaChiTinh, DiaChiHuyen
                                        , DiaChiCT, SoCongVan, NgayCongVan, 0, strNguoiNhap, vNoichuyen,
                                        vTrangthai, vCD_DONVIID, vNgaychuyenTu, vNgaychuyenDen
                                        , vArrSelectID, vIsThuLy, vPhanloaixuly
                                        , vNgayThulyTu, vNgayThulyDen, vSoThuly, vPhancongTTV, vLoaiAn, vGiaoTHS, status_ghepvuan, _ISXINANGIAM, _GDT_ISXINANGIAM
                                        , pageindex, page_size);
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
        protected void ddlGiaoTHS_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlGiaoTHS.SelectedValue != "0")
            {
                rdbTrangThai.SelectedValue = "2";
                Cls_Comon.SetButton(cmdTralai, true);
                Cls_Comon.SetButton(cmdNhandon, false);
                Cls_Comon.SetButton(cmdGiaoTHS, true);
                rdGhepVuAn.SelectedValue = "1";
                pnGhepVuAn.Visible = true;
                cmdInDonDaNhan.Visible = true;
            }
                
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

        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            int with_popup = 950;
            int height_popup = 750;
            string Strxt = "";
            Session[SS_TK.HCTP_GHICHU] = txtBC_Ghichu.Text;
            Loaian = ddlLoaiAn.SelectedValue;//Session[SS_TK.LOAIAN]+"";
            if(Loaian=="")
                Loaian= Session[SS_TK.LOAIAN] + "";
            //----------
            switch (e.CommandName)
            {
                case "NewVA":
                    String ND_id = e.CommandArgument.ToString();
                    String[] ND_id_arr = ND_id.Split(';');
                    if (Loaian == "01")
                    {
                        Strxt = "PopupReport('/QLAN/GDTTT/Giaiquyet/Popup/pVuAnHS.aspx?vid=" + ND_id_arr[0]+ "&IsMapVuAn="+ND_id_arr[1] + "&IsThuLy=" + ND_id_arr[2]
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
                    //Khi co kết quả không được hủy ghép vụ án
                    decimal vDonid = Convert.ToDecimal(e.CommandArgument);
                    GDTTT_VUAN_KETQUA_DON_BL oB = new GDTTT_VUAN_KETQUA_DON_BL();
                    var Ckn = oB.GDTTT_VUAN_KETQUA_DON_GETBYID(vDonid);
                    if (Ckn != null && Ckn.Rows.Count > 0)
                    {
                        ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Đơn đã có kết quả không được hủy ghép vụ án!')", true);
                        break;
                    }
                    else
                    {
                        Huy_GhepVA(vDonid);
                        break;
                    }
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
                ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Hủy ghép vụ án thành công!')", true);
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

                    Decimal CurrVuAnId = (string.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value);
                    
                    int vLOAIDON = Convert.ToInt16(rv["LOAIDON"]);
                    //---------TRUONGHOPTHULY---------------- 1 đơn gdtt cap cao; 11 đon GDT Toi cao; 3 đon + cv câp cao; 31 đơn + cv tôi cao
                    if ( vLOAIDON == 1|| vLOAIDON == 2|| vLOAIDON == 3|| vLOAIDON ==6|| vLOAIDON == 8|| vLOAIDON == 9|| vLOAIDON == 10 || vLOAIDON == 11 || vLOAIDON == 31)
                        MapVuAnTuDong(rv, e, CurrDonID);

                    CurrVuAnId = (string.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value);

                    if (IsMapVuAn > 0)
                    {
                        pnVuAnInfo.Visible = true;
                        lkThemVA.Visible = false;
                        lkGhepVuAn.Visible = false;

                        switch (trangthai)
                        {
                            case 1:
                                //chua nhan don
                                break;
                            case 2:

                                //da nhan don
                                // if (CurrVuAnId > 0 && PhanLoaiDon == 3)
                                if (CurrVuAnId > 0)
                                {
                                    //Da ghep vu an + la don trung--> hien link "Huy ghep vu an"
                                    lkThemVA.Visible = false;
                                    lkGhepVuAn.Visible = true;
                                    lkGhepVuAn.Text = "Hủy ghép vụ án";
                                    lkGhepVuAn.CommandName = "HUY_GHEPVA";
                                }
                                break;
                            case 3:
                                //tra lai
                                break;
                        }
                    }
                    else
                    {
                        if (CurrVuAnId > 0)
                        {
                            if (TinhTrangThuLy == ENUM_GDTTT_TRANGTHAI.THULY_MOI)
                            {
                                lkThemVA.Visible = lttTTV.Visible = lkGhepVuAn.Visible = false;
                                pnTTV.Visible = false;
                            }
                        }
                        else
                        {
                            lkThemVA.Visible = false;
                            lkGhepVuAn.Visible = true;
                            pnTTV.Visible = lttTTV.Visible = pnVuAnInfo.Visible = false;
                            if (TinhTrangThuLy != ENUM_GDTTT_TRANGTHAI.THULY_MOI)
                            {
                                //don trung --> hien link "Ghep vu an 
                                lkGhepVuAn.Visible = true;
                                lkGhepVuAn.Text = "Ghép vụ án";
                                lkGhepVuAn.CommandName = "GHEPVA";
                            }
                        }
                    }

                    Decimal temp_id = String.IsNullOrEmpty(rv["VuAnID"] + "") ? 0 : Convert.ToDecimal(rv["VuAnID"] + "");

                    if (rdbTrangThai.SelectedValue == "2" && temp_id == 0 && IsMapVuAn == 0)
                    {
                        //da nhan don
                        pnVuAnInfo.Visible = false;
                        lttNewVuAn.Text = lttTTV.Text = "";
                        if (TinhTrangThuLy == ENUM_GDTTT_TRANGTHAI.THULY_MOI)
                        {
                            lkThemVA.Visible = true;
                            lkThemVA.Text = "Thêm vụ án";
                            lkThemVA.CommandName = "NewVA";
                        }
                        else
                        {//Hồ sơ KNVKS
                            if (rv["LOAIDON"]+"" == "4") {
                                lkThemVA.Visible = true;
                                lkThemVA.Text = "Thêm vụ án";
                                lkThemVA.CommandName = "NewVA";
                            }
                        }

                        lkGhepVuAn.Visible = true;
                        lkGhepVuAn.CommandName = "GHEPVA";
                        if (lkThemVA.Visible)
                            lkGhepVuAn.Text = " | Ghép vụ án";
                        else
                            lkGhepVuAn.Text = "Ghép vụ án";
                    }
                    else if (rdbTrangThai.SelectedValue == "1")
                    {
                        //chua nhan don
                        if (TinhTrangThuLy == ENUM_GDTTT_TRANGTHAI.THULY_MOI)
                        {
                            if (CurrVuAnId == 0)
                            {
                                lkThemVA.Visible = true;
                                lkGhepVuAn.Visible = true;
                                lkGhepVuAn.Text = " | Ghép vụ án";
                                lkGhepVuAn.CommandName = "GHEPVA";
                            }
                            else lkThemVA.Visible = lkGhepVuAn.Visible = false;
                        }
                        else
                        {
                            //da thu ly
                            if (CurrVuAnId > 0)
                                lkThemVA.Visible = lkGhepVuAn.Visible = false;
                            else lkGhepVuAn.Visible = true;
                        }
                    }
                }
            }
        }
        void MapVuAnTuDong(DataRowView rv, DataGridItemEventArgs e, Decimal donid)
        {
            Literal lttNewVuAn = (Literal)e.Item.FindControl("lttNewVuAn");
            Literal lttTTV = (Literal)e.Item.FindControl("lttTTV");
            Literal lttTP = (Literal)e.Item.FindControl("lttTP");
            LinkButton lkGhepVuAn = (LinkButton)e.Item.FindControl("lkGhepVuAn");
            LinkButton lkThemVA = (LinkButton)e.Item.FindControl("lkThemVA");
            Panel pnVuAnInfo = (Panel)e.Item.FindControl("pnVuAnInfo");
            HiddenField hddVuAnID = (HiddenField)e.Item.FindControl("hddVuAnID");
            int IsMapVuAn = Convert.ToInt32(rv["IsMapVuAn"] + "");
            //khi don.Vuviecid = va.id thì IsMapVuAn>0
            if (IsMapVuAn > 0)
            {
                #region Da thu ly vu an 
                int IsKetQuaGQDon = Convert.ToInt16(rv["IsKetQuaGQDon"] + "");
                int TinhTrangThuLy = Convert.ToInt16(rv["IsThuLy"] + "");
                //if (TinhTrangThuLy == 1 && IsKetQuaGQDon == 0)
                if (TinhTrangThuLy == 1)
                {
                    //Da tung thu ly nhung trang thai hien tai = thu ly moi 
                    //--> cho hien link "Thu ly lại"                    
                    lkThemVA.Visible = true;
                    lkThemVA.Text = "Thụ lý lại";
                    lkThemVA.CommandName = "ThuLyLai";
                }

                //---------------------------------
                pnVuAnInfo.Visible = true;
                lttNewVuAn.Text = "";
                #endregion
            }
            else
            {
                #region chua map vu an
                lkThemVA.Visible = lkGhepVuAn.Visible = true;
                ShowThongTinVuAn(rv, e, donid);
                #endregion
            }
        }
        void ShowThongTinVuAn(DataRowView rv, DataGridItemEventArgs e, Decimal Donid)
        {
            Literal lttNewVuAn = (Literal)e.Item.FindControl("lttNewVuAn");
            lttNewVuAn.Text = "";
            Literal lttTTV = (Literal)e.Item.FindControl("lttTTV");
            Literal lttTP = (Literal)e.Item.FindControl("lttTP");

            LinkButton lkThemVA = (LinkButton)e.Item.FindControl("lkThemVA");
            Panel pnVuAnInfo = (Panel)e.Item.FindControl("pnVuAnInfo");
            HiddenField hddVuAnID = (HiddenField)e.Item.FindControl("hddVuAnID");

            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

            String Don_SoBA = (rv["BAQD"] + "").Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "").Trim();
            DateTime Don_NgayBA = (String.IsNullOrEmpty(rv["BAQD_NGAYBA"] + "")) ? DateTime.MinValue : Convert.ToDateTime(rv["BAQD_NGAYBA"] + "");
            Decimal Don_ToaAn = (string.IsNullOrEmpty(rv["BAQD_TOAANID"] + "")) ? 0 : Convert.ToDecimal(rv["BAQD_TOAANID"] + "");
            Decimal Don_LoaiAn = String.IsNullOrEmpty(rv["BAQD_LOAIAN"] + "") ? 0 : Convert.ToDecimal(rv["BAQD_LOAIAN"] + "");

            int BAQD_CAPXETXU = String.IsNullOrEmpty(rv["BAQD_CAPXETXU"] + "") ? 0 : Convert.ToInt16(rv["BAQD_CAPXETXU"] + "");
            //List<GDTTT_VUAN> lst = null;
            GDTTT_VUAN_BL oBL = new GDTTT_VUAN_BL();
            DataTable tbl = null;
           
            if (Don_SoBA != "" && Don_NgayBA != DateTime.MinValue)
            {
                if (BAQD_CAPXETXU == ENUM_GIAIDOANVUAN.SOTHAM)
                {
                    if (Don_NgayBA != null)
                    {
                        //lst = dt.GDTTT_VUAN.Where(x => x.SOANSOTHAM.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "") == Don_SoBA.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "")
                        ////x.SOANSOTHAM.Trim().ToLower().Substring(0, x.SOANSOTHAM.Trim().IndexOf("/") ) == Don_SoBA.Trim().ToLower().Substring(0, Don_SoBA.Trim().IndexOf("/") )
                        //                            && x.LOAIAN == Don_LoaiAn

                        //                            && x.NGAYXUSOTHAM == Don_NgayBA
                        //                            && x.TOAANSOTHAM == Don_ToaAn
                        //                            && x.TOAANID == ToaAnID
                        //                        //&& x.GQD_LOAIKETQUA == null
                        //                        ).ToList();
                        tbl = oBL.GDTTT_GHEPDON_VUAN(ToaAnID, PhongBanID, Don_ToaAn.ToString(),Don_SoBA.Trim(), ((DateTime)Don_NgayBA).ToString("dd/MM/yyyy"), Don_LoaiAn, 2,  null, null,Donid);
                    }
                }
                else if (BAQD_CAPXETXU == ENUM_GIAIDOANVUAN.PHUCTHAM)
                {

                    tbl = oBL.GDTTT_GHEPDON_VUAN(ToaAnID, PhongBanID, Don_ToaAn.ToString(), Don_SoBA.Trim(), ((DateTime)Don_NgayBA).ToString("dd/MM/yyyy"), Don_LoaiAn, 3,  null, null,Donid);
                    //lst = dt.GDTTT_VUAN.Where(x => x.SOANPHUCTHAM.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "") == Don_SoBA.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "")
                    ////x.SOANPHUCTHAM.Trim().ToLower().Substring(0, x.SOANPHUCTHAM.Trim().IndexOf("/") ) == Don_SoBA.Trim().ToLower().Substring(0, Don_SoBA.Trim().IndexOf("/") )
                    //                          && x.LOAIAN == Don_LoaiAn
                    //                         && x.NGAYXUPHUCTHAM == Don_NgayBA
                    //                         && x.TOAPHUCTHAMID == Don_ToaAn
                    //                        //&& x.GQD_LOAIKETQUA == null
                    //                        && x.TOAANID == ToaAnID
                    //                        ).ToList();
                    //Nếu cấp PT không có thì KT cấp  ST
                    if (Donid > 0 && (tbl == null || tbl.Rows.Count == 0))
                    {
                        GDTTT_DON objDon = dt.GDTTT_DON.Where(x => x.ID == Donid).Single();
                        if (objDon.BAQD_NGAYBA_ST != null && objDon.BAQD_SO_ST != null)
                        {
                            tbl = oBL.GDTTT_GHEPDON_VUAN(ToaAnID, PhongBanID, objDon.BAQD_TOAANID_ST.ToString(), objDon.BAQD_SO_ST.Trim(), ((DateTime)objDon.BAQD_NGAYBA_ST).ToString("dd/MM/yyyy"), Don_LoaiAn, 2,  null, null,Donid);
                            //lst = dt.GDTTT_VUAN.Where(x => x.SOANSOTHAM.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "") == objDon.BAQD_SO_ST.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "")
                            ////x.SOANSOTHAM.Trim().ToLower().Substring(0, x.SOANSOTHAM.Trim().IndexOf("/") ) == objDon.BAQD_SO_ST.Trim().ToLower().Substring(0, objDon.BAQD_SO_ST.Trim().IndexOf("/") )
                            //                            && x.LOAIAN == Don_LoaiAn

                            //                           && x.NGAYXUSOTHAM == objDon.BAQD_NGAYBA_ST
                            //                           && x.TOAANSOTHAM == objDon.BAQD_TOAANID_ST
                            //                           && x.TOAANID == ToaAnID
                            //                          //&& x.GQD_LOAIKETQUA == null
                            //                          ).ToList();
                        }
                    }

                }
                else if (BAQD_CAPXETXU == ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    //lst = dt.GDTTT_VUAN.Where(x => x.SO_QDGDT.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "") == Don_SoBA.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "")
                    ////x.SO_QDGDT.Trim().ToLower().Substring(0, x.SO_QDGDT.Trim().IndexOf("/") ) == Don_SoBA.Trim().ToLower().Substring(0, Don_SoBA.Trim().IndexOf("/") )
                    //                             && x.LOAIAN == Don_LoaiAn

                    //                            && x.NGAYQD == Don_NgayBA
                    //                            && x.TOAQDID == Don_ToaAn
                    //                            && x.TOAANID == ToaAnID
                    //                            //&& x.GQD_LOAIKETQUA == null
                    //                            ).ToList();
                    tbl = oBL.GDTTT_GHEPDON_VUAN(ToaAnID, PhongBanID, Don_ToaAn.ToString(), Don_SoBA.Trim(), ((DateTime)Don_NgayBA).ToString("dd/MM/yyyy"), Don_LoaiAn, 4,  null, null,Donid);
                    //Nếu cấp GDT không có thì KT cấp PT và ST
                    if (Donid > 0 && (tbl == null || tbl.Rows.Count == 0))
                    {
                        GDTTT_DON objDon = dt.GDTTT_DON.Where(x => x.ID == Donid).Single();
                        //Kt BA PT neu có
                        if (objDon.BAQD_NGAYBA_PT != null && objDon.BAQD_SO_PT != null)
                        {
                            //lst = dt.GDTTT_VUAN.Where(x => x.SOANPHUCTHAM.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "") == objDon.BAQD_SO_PT.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "")
                            ////x.SOANPHUCTHAM.Trim().ToLower().Substring(0, x.SOANPHUCTHAM.Trim().IndexOf("/") ) == objDon.BAQD_SO_PT.Trim().ToLower().Substring(0, objDon.BAQD_SO_PT.Trim().IndexOf("/") )
                            //                             && x.LOAIAN == Don_LoaiAn

                            //                            && x.NGAYXUPHUCTHAM == objDon.BAQD_NGAYBA_PT
                            //                            && x.TOAPHUCTHAMID == objDon.BAQD_TOAANID_PT
                            //                            //&& x.GQD_LOAIKETQUA == null
                            //                            && x.TOAANID == ToaAnID
                            //                            ).ToList();
                            tbl = oBL.GDTTT_GHEPDON_VUAN(ToaAnID, PhongBanID, objDon.BAQD_TOAANID_PT.ToString(), objDon.BAQD_SO_PT.Trim(), ((DateTime)objDon.BAQD_NGAYBA_PT).ToString("dd/MM/yyyy"), Don_LoaiAn, 3,  null, null,Donid);
                            //Kiem tra BA ST nếu BA PT ko đúng
                            if (tbl == null || tbl.Rows.Count == 0)
                            {
                                if (objDon.BAQD_NGAYBA_ST != null && objDon.BAQD_SO_ST != null)
                                {
                                    tbl = oBL.GDTTT_GHEPDON_VUAN(ToaAnID, PhongBanID, objDon.BAQD_TOAANID_ST.ToString(), objDon.BAQD_SO_ST.Trim(), ((DateTime)objDon.BAQD_NGAYBA_ST).ToString("dd/MM/yyyy"), Don_LoaiAn, 2,  null, null,Donid);
                                    //lst = dt.GDTTT_VUAN.Where(x => x.SOANSOTHAM.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "") == objDon.BAQD_SO_ST.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "")
                                    ////x.SOANSOTHAM.Trim().ToLower().Substring(0, x.SOANSOTHAM.Trim().IndexOf("/") ) == objDon.BAQD_SO_ST.Trim().ToLower().Substring(0, objDon.BAQD_SO_ST.Trim().IndexOf("/") )
                                    //                            && x.LOAIAN == Don_LoaiAn

                                    //                           && x.NGAYXUSOTHAM == objDon.BAQD_NGAYBA_ST
                                    //                           && x.TOAANSOTHAM == objDon.BAQD_TOAANID_ST
                                    //                           && x.TOAANID == ToaAnID
                                    //                          //&& x.GQD_LOAIKETQUA == null
                                    //                          ).ToList();
                                }
                            }
                        }//Kiem tra BA ST nếu không có BA PT
                        else if (objDon.BAQD_NGAYBA_ST != null && objDon.BAQD_SO_ST != null)
                        {
                            tbl = oBL.GDTTT_GHEPDON_VUAN(ToaAnID, PhongBanID, objDon.BAQD_TOAANID_ST.ToString(), objDon.BAQD_SO_ST.Trim(), ((DateTime)objDon.BAQD_NGAYBA_ST).ToString("dd/MM/yyyy"), Don_LoaiAn, 3,  null, null,Donid);
                            //lst = dt.GDTTT_VUAN.Where(x => x.SOANSOTHAM.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "") == objDon.BAQD_SO_ST.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "")
                            ////x.SOANSOTHAM.Trim().ToLower().Substring(0, x.SOANSOTHAM.Trim().IndexOf("/") ) == objDon.BAQD_SO_ST.Trim().ToLower().Substring(0, objDon.BAQD_SO_ST.Trim().IndexOf("/") )
                            //                             && x.LOAIAN == Don_LoaiAn

                            //                           && x.NGAYXUSOTHAM == objDon.BAQD_NGAYBA_ST
                            //                           && x.TOAANSOTHAM == objDon.BAQD_TOAANID_ST
                            //                           && x.TOAANID == ToaAnID
                            //                          //&& x.GQD_LOAIKETQUA == null
                            //                          ).ToList();
                        }

                    }
                }
            }
            if (tbl != null && tbl.Rows.Count > 0)
            {
                decimal vID = tbl.Rows[0]["ID"].toNumber();
                GDTTT_VUAN objVA = dt.GDTTT_VUAN.Where(x => x.ID == vID).FirstOrDefault();
                hddVuAnID.Value = objVA.ID.ToString();
                String QHPL = "";

                if (!String.IsNullOrEmpty(objVA.QHPL_DINHNGHIAID + "") && objVA.QHPL_DINHNGHIAID > 0)
                    QHPL = dt.GDTTT_DM_QHPL.Where(x => x.ID == objVA.QHPL_DINHNGHIAID).Single().TENQHPL;
                String Str = "<span style='float:left; width:100%;'><b>" + rv["BAQD_SO"] + "" + "</b>"
                                + " - " + GetDate(rv["BAQD_NGAYBA"] + "") + "</span>";
                Str += "<b>" + objVA.NGUYENDON;
                Str += String.IsNullOrEmpty(objVA.BIDON + "") ? "" : (" - " + objVA.BIDON);
                Str += String.IsNullOrEmpty(QHPL) ? "" : " - " + QHPL;
                Str += "</b>";
                lttNewVuAn.Text = Str;
                lttNewVuAn.Visible = true;
                //------------------------------------------
                Str = "<hr style=\"border - color:#dcdcdc;\" />";
                string strTTV = "";
                int show_ttv = 0;
                try
                {
                    if (objVA.THAMTRAVIENID != null && objVA.THAMTRAVIENID > 0)
                    {
                        DM_CANBO oTTV = dt.DM_CANBO.Where(x => x.ID == objVA.THAMTRAVIENID).FirstOrDefault();
                        strTTV = " <b>TTV</b>: " + oTTV.HOTEN;
                        show_ttv++;
                    }
                    if (objVA.LANHDAOVUID != null && objVA.LANHDAOVUID > 0)
                    {
                        if (strTTV.Length > 0)
                            strTTV += ", ";
                        DM_CANBO oLDV = dt.DM_CANBO.Where(x => x.ID == objVA.LANHDAOVUID).FirstOrDefault();
                        strTTV += "<b>LĐV</b>: " + oLDV.HOTEN;
                        show_ttv++;
                    }
                    lttTTV.Text = strTTV;

                    if (objVA.THAMPHANID != null && objVA.THAMPHANID > 0)
                    {
                        DM_CANBO oTP = dt.DM_CANBO.Where(x => x.ID == objVA.THAMPHANID).FirstOrDefault();
                        lttTP.Text = "<b>TP</b>: " + oTP.HOTEN;
                        show_ttv++;
                    }
                }
                catch (Exception ex) { }
                //Str += " <b>TTV</b>: " + strTTV + ", <b>LĐV</b>: " + strLDV + ", <b>TP</b>: " + strTP;

                //--------------------------------
                lttNewVuAn.Text += (show_ttv > 0) ? Str : "";
                lkThemVA.Visible = false;
                pnVuAnInfo.Visible = false;
            }
            else pnVuAnInfo.Visible = true;
        }
       
        Decimal CheckMapVuAn(Decimal donid, Decimal Donvid)
        {
            //Kiem tra da co vu an (theo so an, ngayxu, toa xu) chua
            //neu vuan chua co kq giai quyet don --> cho ghep vu an--> currVuAnID>0
            //da co--> cho them mới --> CurrVuAnid=0


            GDTTT_DON oDon = dt.GDTTT_DON.Where(x => x.ID == donid).FirstOrDefault();
            Decimal CurrVuAnID = 0;
            //List<GDTTT_VUAN> lst = null;
            GDTTT_VUAN_BL oBL = new GDTTT_VUAN_BL();
            DataTable tbl = null;
            
            //Loại đơn là 4 = Hồ sơ kháng nghị VKS thi luôn tạo Vụ án mới
            if (oDon.LOAIDON != 4)
            {
                if (oDon.BAQD_CAPXETXU == ENUM_GIAIDOANVUAN.SOTHAM)
                {

                    //lst = dt.GDTTT_VUAN.Where(x => x.SOANSOTHAM.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "") == oDon.BAQD_SO_ST.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "")
                    ////x.SOANSOTHAM.Trim().ToLower().Substring(0, x.SOANSOTHAM.Trim().IndexOf("/")) == ReplaceSoBanAn(oDon.BAQD_SO_ST)  //.Contains(BA_ST)
                    //                                             && x.LOAIAN == oDon.BAQD_LOAIAN

                    //                                             && x.NGAYXUSOTHAM == oDon.BAQD_NGAYBA_ST
                    //                                             && x.TOAANSOTHAM == oDon.BAQD_TOAANID_ST
                    //                                             //&& x.GQD_LOAIKETQUA == null
                    //                                             && x.TOAANID == Donvid
                    //                                            )
                    //                    .OrderByDescending(x => x.NGAYTAO).ToList();

                    tbl = oBL.GDTTT_GHEPDON_VUAN(Donvid, PhongBanID, oDon.BAQD_TOAANID_ST.ToString(),oDon.BAQD_SO_ST, ((DateTime)oDon.BAQD_NGAYBA_ST).ToString("dd/MM/yyyy"), Convert.ToDecimal(oDon.BAQD_LOAIAN),2,null,null, donid);
                }
                else if (oDon.BAQD_CAPXETXU == ENUM_GIAIDOANVUAN.PHUCTHAM)
                {

                    //lst = dt.GDTTT_VUAN.Where(x => x.SOANPHUCTHAM.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "") == oDon.BAQD_SO_PT.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "")
                    ////x.SOANPHUCTHAM.Trim().ToLower().Substring(0, x.SOANPHUCTHAM.Trim().IndexOf("/") ) == ReplaceSoBanAn(oDon.BAQD_SO_PT)
                    //                                        && x.LOAIAN == oDon.BAQD_LOAIAN

                    //                                         && x.NGAYXUPHUCTHAM == oDon.BAQD_NGAYBA_PT
                    //                                         && x.TOAPHUCTHAMID == oDon.BAQD_TOAANID_PT
                    //                                        //&& x.GQD_LOAIKETQUA == null
                    //                                        && x.TOAANID == Donvid
                    //                                        )
                    //                    .OrderByDescending(x => x.NGAYTAO).ToList();
                    tbl = oBL.GDTTT_GHEPDON_VUAN(Donvid, PhongBanID, oDon.BAQD_TOAANID_PT.ToString(), oDon.BAQD_SO_PT, ((DateTime)oDon.BAQD_NGAYBA_PT).ToString("dd/MM/yyyy"), Convert.ToDecimal(oDon.BAQD_LOAIAN), 3, null,null, donid);
                    //Nếu cấp PT không có thì KT cấp  ST
                    if (donid > 0 && (tbl == null || tbl.Rows.Count == 0))
                    {
                        if (oDon.BAQD_NGAYBA_ST != null)
                        {
                            tbl = oBL.GDTTT_GHEPDON_VUAN(Donvid, PhongBanID, oDon.BAQD_TOAANID_ST.ToString(), oDon.BAQD_SO_ST, ((DateTime)oDon.BAQD_NGAYBA_ST).ToString("dd/MM/yyyy"), Convert.ToDecimal(oDon.BAQD_LOAIAN), 2,  null, null, donid);
                            //lst = dt.GDTTT_VUAN.Where(x => x.SOANSOTHAM.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "") == oDon.BAQD_SO_ST.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "")
                            ////x.SOANSOTHAM.Trim().ToLower().Substring(0, x.SOANSOTHAM.Trim().IndexOf("/") ) == ReplaceSoBanAn(oDon.BAQD_SO_ST)
                            //                           && x.LOAIAN == oDon.BAQD_LOAIAN

                            //                           && x.NGAYXUSOTHAM == oDon.BAQD_NGAYBA_ST
                            //                           && x.TOAANSOTHAM == oDon.BAQD_TOAANID_ST
                            //                          //&& x.GQD_LOAIKETQUA == null
                            //                          && x.TOAANID == Donvid
                            //                          )
                            //            .OrderByDescending(x => x.NGAYTAO).ToList();
                        }
                    }
                }
                else if (oDon.BAQD_CAPXETXU == ENUM_GIAIDOANVUAN.THULYGDT)
                {

                    //lst = dt.GDTTT_VUAN.Where(x => x.SO_QDGDT.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "") == oDon.BAQD_SO.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "")
                    ////x.SO_QDGDT.Trim().ToLower().Substring(0, x.SO_QDGDT.Trim().IndexOf("/") ) == ReplaceSoBanAn(oDon.BAQD_SO)
                    //                                   && x.LOAIAN == oDon.BAQD_LOAIAN

                    //                                    && x.NGAYQD == oDon.BAQD_NGAYBA
                    //                                    && x.TOAQDID == oDon.BAQD_TOAANID
                    //                                    //&& x.GQD_LOAIKETQUA == null
                    //                                    && x.TOAANID == Donvid
                    //                                    )
                    //                    .OrderByDescending(x => x.NGAYTAO).ToList();
                    tbl = oBL.GDTTT_GHEPDON_VUAN(Donvid, PhongBanID, oDon.BAQD_TOAANID.ToString(), oDon.BAQD_SO, ((DateTime)oDon.BAQD_NGAYBA).ToString("dd/MM/yyyy"), Convert.ToDecimal(oDon.BAQD_LOAIAN), 4,  null, null,donid);
                    //Nếu cấp GDT không có thì KT cấp PT và ST
                    if (donid > 0 && (tbl == null || tbl.Rows.Count == 0))
                    {

                        //Kt BA PT neu có
                        if (oDon.BAQD_NGAYBA_PT != null)
                        {

                            //lst = dt.GDTTT_VUAN.Where(x => x.SOANPHUCTHAM.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "") == oDon.BAQD_SO_PT.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "")
                            ////x.SOANPHUCTHAM.Trim().ToLower().Substring(0, x.SOANPHUCTHAM.Trim().IndexOf("/") ) == ReplaceSoBanAn(oDon.BAQD_SO_PT)
                            //                                && x.LOAIAN == oDon.BAQD_LOAIAN

                            //                                && x.NGAYXUPHUCTHAM == oDon.BAQD_NGAYBA_PT
                            //                                && x.TOAPHUCTHAMID == oDon.BAQD_TOAANID_PT
                            //                               //&& x.GQD_LOAIKETQUA == null
                            //                               && x.TOAANID == Donvid
                            //                               )
                            //                     .OrderByDescending(x => x.NGAYTAO).ToList();
                            tbl = oBL.GDTTT_GHEPDON_VUAN(Donvid, PhongBanID, oDon.BAQD_TOAANID_PT.ToString(), oDon.BAQD_SO_PT, ((DateTime)oDon.BAQD_NGAYBA_PT).ToString("dd/MM/yyyy"), Convert.ToDecimal(oDon.BAQD_LOAIAN), 3,  null, null, donid);
                            //Kiem tra BA ST nếu BA PT ko đúng
                            if (tbl == null || tbl.Rows.Count == 0)
                            {
                                if (oDon.BAQD_NGAYBA_ST != null)
                                {
                                    //lst = dt.GDTTT_VUAN.Where(x => x.SOANSOTHAM.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "") == oDon.BAQD_SO_ST.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "")
                                    ////x.SOANSOTHAM.Trim().ToLower().Substring(0, x.SOANSOTHAM.Trim().IndexOf("/") ) == ReplaceSoBanAn(oDon.BAQD_SO_ST)
                                    //                    && x.LOAIAN == oDon.BAQD_LOAIAN

                                    //                      && x.NGAYXUSOTHAM == oDon.BAQD_NGAYBA_ST
                                    //                      && x.TOAANSOTHAM == oDon.BAQD_TOAANID_ST
                                    //                      && x.TOAANID == Donvid
                                    //                     //&& x.GQD_LOAIKETQUA == null
                                    //                     )
                                    //                 .OrderByDescending(x => x.NGAYTAO).ToList();
                                    tbl = oBL.GDTTT_GHEPDON_VUAN(Donvid, PhongBanID, oDon.BAQD_TOAANID_ST.ToString(), oDon.BAQD_SO_ST, ((DateTime)oDon.BAQD_NGAYBA_ST).ToString("dd/MM/yyyy"), Convert.ToDecimal(oDon.BAQD_LOAIAN), 2,  null, null, donid);
                                }
                            }
                        }//Kiem tra BA ST nếu không có BA PT
                        else if (oDon.BAQD_NGAYBA_ST != null)
                        {
                            tbl = oBL.GDTTT_GHEPDON_VUAN(Donvid, PhongBanID, oDon.BAQD_TOAANID_ST.ToString(), oDon.BAQD_SO_ST, ((DateTime)oDon.BAQD_NGAYBA_ST).ToString("dd/MM/yyyy"), Convert.ToDecimal(oDon.BAQD_LOAIAN), 2, null,null, donid);
                            //lst = dt.GDTTT_VUAN.Where(x => x.SOANSOTHAM.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "") == oDon.BAQD_SO_ST.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "")
                            ////x.SOANSOTHAM.Trim().ToLower().Substring(0, x.SOANSOTHAM.Trim().IndexOf("/") ) == ReplaceSoBanAn(oDon.BAQD_SO_ST)
                            //                        && x.LOAIAN == oDon.BAQD_LOAIAN

                            //                          && x.NGAYXUSOTHAM == oDon.BAQD_NGAYBA_ST
                            //                          && x.TOAANSOTHAM == oDon.BAQD_TOAANID_ST
                            //                          && x.TOAANID == Donvid
                            //                         //&& x.GQD_LOAIKETQUA == null
                            //                         )
                            //                    .OrderByDescending(x => x.NGAYTAO).ToList();
                        }

                    }
                }
            }
            if (tbl != null && tbl.Rows.Count > 0)
            {
                //for (int i = 0; i < lst.Count; i++)
                //{
                //    GDTTT_VUAN objVA = lst[0];
                //    int LoaiKQ = String.IsNullOrEmpty(objVA.GQD_LOAIKETQUA + "") ? 5 : Convert.ToInt16(objVA.GQD_LOAIKETQUA + "");
                //    if (LoaiKQ == 5)
                //        CurrVuAnID = objVA.ID;
                //    else
                //        CurrVuAnID = 0;
                //}
                //int LoaiKQ = String.IsNullOrEmpty(tbl.Rows[0]["GQD_LOAIKETQUA"]+ "") ? 5 : Convert.ToInt16(tbl.Rows[0]["GQD_LOAIKETQUA"] + "");
                //if (LoaiKQ == 5)
                //    CurrVuAnID = Convert.ToDecimal(tbl.Rows[0]["ID"]);
                //else
                //    CurrVuAnID = 0;
                int LoaiKQ;
                for (int i = 0; i < tbl.Rows.Count; i++)
                {
                    LoaiKQ = String.IsNullOrEmpty(tbl.Rows[i]["GQD_LOAIKETQUA"] + "") ? 5 : Convert.ToInt16(tbl.Rows[i]["GQD_LOAIKETQUA"] + "");
                    if (LoaiKQ == 5)
                    {
                        CurrVuAnID = Convert.ToDecimal(tbl.Rows[i]["ID"]);
                        break;
                    }
                    else
                        CurrVuAnID = 0;
                }

            }

            return CurrVuAnID;
        }
        protected void ADD_BiCaoDauVu(Decimal donid, Decimal vuanid, Decimal Donvid)
        {
            //Kiem tra da co vu an (theo so an, ngayxu, toa xu) chua
            //de lay ra Bi cao dau vu của Vu an trươc loai bo vu an vua tao xong
            GDTTT_DON oDon = dt.GDTTT_DON.Where(x => x.ID == donid).FirstOrDefault();
            //List<GDTTT_VUAN> lst = null;
            GDTTT_VUAN_BL oBL = new GDTTT_VUAN_BL();
            DataTable tbl = null;

            if (oDon.BAQD_CAPXETXU == ENUM_GIAIDOANVUAN.SOTHAM)
            {
                tbl = oBL.GDTTT_GHEPDON_VUAN(Donvid, PhongBanID, oDon.BAQD_TOAANID_ST.ToString(), oDon.BAQD_SO_ST, ((DateTime)oDon.BAQD_NGAYBA_ST).ToString("dd/MM/yyyy"), Convert.ToDecimal(oDon.BAQD_LOAIAN), 2, null,vuanid.ToString(), donid);
                //lst = dt.GDTTT_VUAN.Where(x => x.SOANSOTHAM.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "") == oDon.BAQD_SO_ST.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "")
                ////x.SOANSOTHAM.Trim().ToLower().Substring(0, x.SOANSOTHAM.Trim().IndexOf("/") ) == ReplaceSoBanAn(oDon.BAQD_SO_ST)
                //                                            && x.LOAIAN == oDon.BAQD_LOAIAN

                //                                             && x.NGAYXUSOTHAM == oDon.BAQD_NGAYBA_ST
                //                                             && x.TOAANSOTHAM == oDon.BAQD_TOAANID_ST
                //                                             && x.ID != vuanid
                //                                             && x.TOAANID == oDon.TOAANID
                //                                            )
                //                    .OrderByDescending(x => x.NGAYTAO).ToList();

            }
            else if (oDon.BAQD_CAPXETXU == ENUM_GIAIDOANVUAN.PHUCTHAM)
            {
                //lst = dt.GDTTT_VUAN.Where(x => x.SOANPHUCTHAM.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "") == oDon.BAQD_SO_PT.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "")
                ////x.SOANPHUCTHAM.Trim().ToLower().Substring(0, x.SOANPHUCTHAM.Trim().IndexOf("/") ) == ReplaceSoBanAn(oDon.BAQD_SO_PT)
                //                                        && x.LOAIAN == oDon.BAQD_LOAIAN

                //                                         && x.NGAYXUPHUCTHAM == oDon.BAQD_NGAYBA_PT
                //                                         && x.TOAPHUCTHAMID == oDon.BAQD_TOAANID_PT
                //                                         && x.ID != vuanid
                //                                         && x.TOAANID == oDon.TOAANID
                //                                        )
                //                    .OrderByDescending(x => x.NGAYTAO).ToList();
                tbl = oBL.GDTTT_GHEPDON_VUAN(Donvid, PhongBanID, oDon.BAQD_TOAANID_PT.ToString(), oDon.BAQD_SO_PT, ((DateTime)oDon.BAQD_NGAYBA_PT).ToString("dd/MM/yyyy"), Convert.ToDecimal(oDon.BAQD_LOAIAN), 3, null, vuanid.ToString(), donid);
                //Nếu cấp PT không có thì KT cấp  ST
                if (donid > 0 && (tbl == null || tbl.Rows.Count == 0))
                {
                    //--------KHANHPQ EDIT
                    //KT BA ST NẾU CÓ
                    if (oDon.BAQD_NGAYBA_ST != null)
                    {
                        tbl = oBL.GDTTT_GHEPDON_VUAN(Donvid, PhongBanID, oDon.BAQD_TOAANID_ST.ToString(), oDon.BAQD_SO_ST, ((DateTime)oDon.BAQD_NGAYBA_ST).ToString("dd/MM/yyyy"), Convert.ToDecimal(oDon.BAQD_LOAIAN), 2, null, vuanid.ToString(), donid);
                    }
                    //lst = dt.GDTTT_VUAN.Where(x => x.SOANSOTHAM.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "") == oDon.BAQD_SO_ST.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "")
                    ////x.SOANSOTHAM.Trim().ToLower().Substring(0, x.SOANSOTHAM.Trim().IndexOf("/") ) == ReplaceSoBanAn(oDon.BAQD_SO_ST)
                    //                           && x.LOAIAN == oDon.BAQD_LOAIAN

                    //                           && x.NGAYXUSOTHAM == oDon.BAQD_NGAYBA_ST
                    //                           && x.TOAANSOTHAM == oDon.BAQD_TOAANID_ST
                    //                           && x.ID != vuanid
                    //                           && x.TOAANID == oDon.TOAANID
                    //                          )
                    //                .OrderByDescending(x => x.NGAYTAO).ToList();
                    //--------------------

                }
            }
            else if (oDon.BAQD_CAPXETXU == ENUM_GIAIDOANVUAN.THULYGDT)
            {
                tbl = oBL.GDTTT_GHEPDON_VUAN(Donvid, PhongBanID, oDon.BAQD_TOAANID.ToString(), oDon.BAQD_SO, ((DateTime)oDon.BAQD_NGAYBA).ToString("dd/MM/yyyy"), Convert.ToDecimal(oDon.BAQD_LOAIAN), 4, null, vuanid.ToString(), donid);
                //lst = dt.GDTTT_VUAN.Where(x =>  //x.SO_QDGDT.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "") == oDon.BAQD_SO.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "")
                //                                x.SO_QDGDT.Trim().ToLower().Substring(0, x.SO_QDGDT.Trim().IndexOf("/") ) == ReplaceSoBanAn(oDon.BAQD_SO)
                //                                && x.LOAIAN == oDon.BAQD_LOAIAN
                //                                && x.NGAYQD == oDon.BAQD_NGAYBA
                //                                && x.TOAQDID == oDon.BAQD_TOAANID
                //                                && x.ID != vuanid
                //                                && x.TOAANID == oDon.TOAANID
                //                                       )
                //                    .OrderByDescending(x => x.NGAYTAO).ToList();
                //Nếu cấp GDT không có thì KT cấp PT và ST
                if (donid > 0 && (tbl == null || tbl.Rows.Count == 0))
                {

                    //Kt BA PT neu có
                    if (oDon.BAQD_NGAYBA_PT != null)
                    {
                        tbl = oBL.GDTTT_GHEPDON_VUAN(Donvid, PhongBanID, oDon.BAQD_TOAANID_PT.ToString(), oDon.BAQD_SO_PT, ((DateTime)oDon.BAQD_NGAYBA_PT).ToString("dd/MM/yyyy"), Convert.ToDecimal(oDon.BAQD_LOAIAN), 3, null, vuanid.ToString(), donid);
                        //lst = dt.GDTTT_VUAN.Where(x => x.SOANPHUCTHAM.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "") == oDon.BAQD_SO_PT.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "")
                        //                            //x.SOANPHUCTHAM.Trim().ToLower().Substring(0, x.SOANPHUCTHAM.Trim().IndexOf("/") ) == ReplaceSoBanAn(oDon.BAQD_SO_PT)

                        //                             && x.LOAIAN == oDon.BAQD_LOAIAN
                        //                            && x.NGAYXUPHUCTHAM == oDon.BAQD_NGAYBA_PT
                        //                            && x.TOAPHUCTHAMID == oDon.BAQD_TOAANID_PT
                        //                            && x.ID != vuanid
                        //                                && x.TOAANID == oDon.TOAANID
                        //                               )
                        //            .OrderByDescending(x => x.NGAYTAO).ToList();
                        //Kiem tra BA ST nếu BA PT ko đúng
                        if (tbl == null || tbl.Rows.Count == 0)
                        {
                            if (oDon.BAQD_NGAYBA_ST != null)
                            {
                                tbl = oBL.GDTTT_GHEPDON_VUAN(Donvid, PhongBanID, oDon.BAQD_TOAANID_ST.ToString(), oDon.BAQD_SO_ST, ((DateTime)oDon.BAQD_NGAYBA_ST).ToString("dd/MM/yyyy"), Convert.ToDecimal(oDon.BAQD_LOAIAN), 2, null, vuanid.ToString(), donid);
                                //lst = dt.GDTTT_VUAN.Where(x => x.SOANSOTHAM.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "") == oDon.BAQD_SO_ST.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "")
                                //                        //x.SOANSOTHAM.Trim().ToLower().Substring(0, x.SOANSOTHAM.Trim().IndexOf("/") ) == ReplaceSoBanAn(oDon.BAQD_SO_ST)
                                //                        && x.LOAIAN == oDon.BAQD_LOAIAN

                                //                        && x.NGAYXUSOTHAM == oDon.BAQD_NGAYBA_ST
                                //                        && x.TOAANSOTHAM == oDon.BAQD_TOAANID_ST
                                //                        && x.ID != vuanid
                                //                        && x.TOAANID == oDon.TOAANID
                                //                     )
                                //                    .OrderByDescending(x => x.NGAYTAO).ToList();
                            }
                        }
                    }//Kiem tra BA ST nếu không có BA PT
                    else if (oDon.BAQD_NGAYBA_ST != null)
                    {
                        tbl = oBL.GDTTT_GHEPDON_VUAN(Donvid, PhongBanID, oDon.BAQD_TOAANID_ST.ToString(), oDon.BAQD_SO_ST, ((DateTime)oDon.BAQD_NGAYBA_ST).ToString("dd/MM/yyyy"), Convert.ToDecimal(oDon.BAQD_LOAIAN), 2, null, vuanid.ToString(), donid);

                        //lst = dt.GDTTT_VUAN.Where(x => x.SOANSOTHAM.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "") == oDon.BAQD_SO_ST.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "")
                        //                          //x.SOANSOTHAM.Trim().ToLower().Substring(0, x.SOANSOTHAM.Trim().IndexOf("/") ) == ReplaceSoBanAn(oDon.BAQD_SO_ST)
                        //                          && x.LOAIAN == oDon.BAQD_LOAIAN
                        //                         && x.NGAYXUSOTHAM == oDon.BAQD_NGAYBA_ST
                        //                          && x.TOAANSOTHAM == oDon.BAQD_TOAANID_ST
                        //                         && x.ID != vuanid
                        //                         && x.TOAANID == oDon.TOAANID
                        //                         )
                        //                    .OrderByDescending(x => x.NGAYTAO).ToList();
                    }

                }
            }
            string bican_dauvu = "", toidanh = "";
            if (tbl != null && tbl.Rows.Count > 0)
            {
           
                GDTTT_VUAN objVA = dt.GDTTT_VUAN.Where(x => x.ID == Convert.ToDecimal(tbl.Rows[0]["ID"]) 
                                                            ).First();
                List<GDTTT_VUAN_DUONGSU> lsDS = null;
                lsDS = dt.GDTTT_VUAN_DUONGSU.Where(x => x.VUANID == objVA.ID
                                                        && x.HS_BICANDAUVU == 1).ToList();

                for (int i = 0; i < lsDS.Count; i++)
                {
                    GDTTT_VUAN_DUONGSU objBC = new GDTTT_VUAN_DUONGSU();
                    objBC.VUANID = vuanid;
                    objBC.TENDUONGSU = lsDS[i].TENDUONGSU;
                    objBC.LOAI = lsDS[i].LOAI;
                    objBC.TUCACHTOTUNG = lsDS[i].TUCACHTOTUNG;
                    objBC.GIOITINH = lsDS[i].GIOITINH;
                    objBC.TINHID = lsDS[i].TINHID;
                    objBC.HUYENID = lsDS[i].HUYENID;
                    objBC.DIACHI = lsDS[i].DIACHI;
                    objBC.NGAYTAO = DateTime.Now;
                    objBC.NGUOITAO = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
                    objBC.ISINPUTADDRESS = lsDS[i].ISINPUTADDRESS;
                    objBC.HS_BICANDAUVU = 1;
                    objBC.HS_ISBICAO = lsDS[i].HS_ISBICAO;
                    objBC.HS_TOIDANHID = lsDS[i].HS_TOIDANHID;
                    objBC.HS_TENTOIDANH = lsDS[i].HS_TENTOIDANH;
                    objBC.HS_MUCAN = lsDS[i].HS_MUCAN;
                    objBC.HS_TUCACHTOTUNG = lsDS[i].HS_TUCACHTOTUNG;
                    objBC.HS_ISKHIEUNAI = 0;
                    objBC.NAMSINH = lsDS[i].NAMSINH;
                    //Thêm bản Bị cáo đầu vụ lấy từ Vụ án trước
                    dt.GDTTT_VUAN_DUONGSU.Add(objBC);
                    dt.SaveChanges();
                    //Danh sach ten bi cao dau vu
                    if (bican_dauvu != "")
                        bican_dauvu += (String.IsNullOrEmpty(bican_dauvu)) ? "" : ", ";
                    bican_dauvu += lsDS[i].TENDUONGSU;
                    toidanh += ((string.IsNullOrEmpty(toidanh + "")) ? "" : ", ") + lsDS[i].HS_TENTOIDANH;
                }
                //Update về bảng vụ án danh sách bị cáo đầu vụ và tội danh
                objVA = dt.GDTTT_VUAN.Where(x => x.ID == vuanid).Single();
                objVA.NGUYENDON = bican_dauvu;
                if (!String.IsNullOrEmpty(bican_dauvu))
                {
                    objVA.TENVUAN = bican_dauvu
                        + (String.IsNullOrEmpty(bican_dauvu + "") ? "" : (string.IsNullOrEmpty(toidanh + "") ? "" : " - "))
                        + toidanh;
                }
                dt.SaveChanges();
            }
        }

        protected void ADD_DUONGSU_DON(Decimal donid, Decimal new_vuanid)
        {
            //de lay ra Nguyen don và Bi don tu Don
            string vNguyenDon = "" , vBiDON = "";   
            List<GDTTT_DON_DUONGSU_CC> lsDS = null;
            lsDS = dt.GDTTT_DON_DUONGSU_CC.Where(x => x.DONID == donid).ToList();
            if (lsDS.Count > 0)
            {
                for (int i = 0; i < lsDS.Count; i++)
                {
                    GDTTT_VUAN_DUONGSU objBC = new GDTTT_VUAN_DUONGSU();
                    objBC.VUANID = new_vuanid;
                    objBC.DONID = donid;
                    objBC.TENDUONGSU = lsDS[i].TENDUONGSU;
                    objBC.LOAI = lsDS[i].LOAI;
                    objBC.TUCACHTOTUNG = lsDS[i].TUCACHTOTUNG;
                    objBC.GIOITINH = lsDS[i].GIOITINH;
                    objBC.TINHID = lsDS[i].TINHID;
                    objBC.HUYENID = lsDS[i].HUYENID;
                    objBC.DIACHI = lsDS[i].DIACHI;
                    objBC.NGAYTAO = DateTime.Now;
                    objBC.NGUOITAO = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
                    objBC.ISINPUTADDRESS = lsDS[i].ISINPUTADDRESS;

                    //Thêm bản Duong su tu don
                    dt.GDTTT_VUAN_DUONGSU.Add(objBC);
                    dt.SaveChanges();
                    
                    if (lsDS[i].TUCACHTOTUNG == "NGUYENDON")
                    {
                        if (vNguyenDon != "")
                            vNguyenDon += (String.IsNullOrEmpty(vNguyenDon)) ? "" : ", ";
                        vNguyenDon = lsDS[i].TENDUONGSU;
                    }
                    if (lsDS[i].TUCACHTOTUNG == "BIDON")
                    {
                        if (vBiDON != "")
                            vBiDON += (String.IsNullOrEmpty(vBiDON)) ? "" : ", ";
                        vBiDON = lsDS[i].TENDUONGSU;
                    }
                }
                //Update về bảng vụ án Tên vụ án
                GDTTT_VUAN objVA = dt.GDTTT_VUAN.Where(x => x.ID == new_vuanid).Single();
                objVA.NGUYENDON = vNguyenDon;
                objVA.BIDON = vBiDON;
                if (!String.IsNullOrEmpty(vNguyenDon) || !String.IsNullOrEmpty(vBiDON))
                {
                    objVA.TENVUAN = vNguyenDon + (String.IsNullOrEmpty(vNguyenDon + "") ? "" : (string.IsNullOrEmpty(vNguyenDon + "") ? "" : " - "))
                        + vBiDON+ (String.IsNullOrEmpty(vBiDON + "") ? "" : (string.IsNullOrEmpty(vBiDON + "") ? "" : " - "))
                        + objVA.QHPL_TEXT;
                }
                dt.SaveChanges();
                //--- Xoa nguyen don, bi don của don tu bang GDTTT_DON_DUONGSU_CC
                //for (int j = 0; j < lsDS.Count; j++)
                //{
                //    decimal vDuongSu_don = Convert.ToDecimal(lsDS[j].ID);
                //    GDTTT_DON_DUONGSU_CC objDSdon = dt.GDTTT_DON_DUONGSU_CC.Where(x => x.ID == vDuongSu_don).Single();
                //    if (objDSdon != null)
                //    {
                //        dt.GDTTT_DON_DUONGSU_CC.Remove(objDSdon);
                //        dt.SaveChanges();
                //    }
                    
                //}
            }
        }

        protected void ADD_BICAO_DON(Decimal donid, Decimal new_vuanid)
        {
            //de lay ra Nguyen don và Bi don tu Don
            string bican_dauvu = "", toidanh = "";
            List<GDTTT_DON_DUONGSU_CC> lsDS = null;
            lsDS = dt.GDTTT_DON_DUONGSU_CC.Where(x => x.DONID == donid).ToList();
            if (lsDS.Count > 0)
            {
                for (int i = 0; i < lsDS.Count; i++)
                {
                    GDTTT_VUAN_DUONGSU objBC = new GDTTT_VUAN_DUONGSU();
                    objBC.VUANID = new_vuanid;
                    objBC.DONID = donid;
                    objBC.TENDUONGSU = lsDS[i].TENDUONGSU;
                    objBC.LOAI = lsDS[i].LOAI;
                    objBC.TUCACHTOTUNG = lsDS[i].TUCACHTOTUNG;
                    objBC.GIOITINH = lsDS[i].GIOITINH;
                    objBC.TINHID = lsDS[i].TINHID;
                    objBC.HUYENID = lsDS[i].HUYENID;
                    objBC.DIACHI = lsDS[i].DIACHI;
                    objBC.NGAYTAO = DateTime.Now;
                    objBC.NGUOITAO = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
                    objBC.ISINPUTADDRESS = lsDS[i].ISINPUTADDRESS;
                    objBC.HS_BICANDAUVU = lsDS[i].HS_BICANDAUVU;
                    objBC.BICAOID = lsDS[i].BICAOID;
                    objBC.HS_ISBICAO = lsDS[i].HS_ISBICAO;
                    objBC.HS_TOIDANHID = lsDS[i].HS_TOIDANHID;
                    objBC.HS_TENTOIDANH = lsDS[i].HS_TENTOIDANH;
                    objBC.HS_MUCAN = lsDS[i].HS_MUCAN;
                    objBC.HS_TUCACHTOTUNG = lsDS[i].HS_TUCACHTOTUNG;

                    objBC.HS_ISKHIEUNAI = lsDS[i].HS_ISKHIEUNAI;
                    objBC.HS_LOAIBAKHIEUNAI = lsDS[i].HS_LOAIBAKHIEUNAI;
                    objBC.HS_NGAYBAKHIEUNAI = lsDS[i].HS_NGAYBAKHIEUNAI;
                    objBC.HS_NOIDUNGKHIEUNAI = lsDS[i].HS_NOIDUNGKHIEUNAI;
                    objBC.NAMSINH = lsDS[i].NAMSINH;
                    //Thêm bản Bị cáo lấy từ Đơn
                    dt.GDTTT_VUAN_DUONGSU.Add(objBC);
                    dt.SaveChanges();
                    //Danh sach ten bi cao dau vu
                    if (lsDS[i].HS_BICANDAUVU == 1)
                    {
                        if (bican_dauvu != "")
                            bican_dauvu += (String.IsNullOrEmpty(bican_dauvu)) ? "" : ", ";
                        bican_dauvu += lsDS[i].TENDUONGSU;
                        toidanh += ((string.IsNullOrEmpty(toidanh + "")) ? "" : ", ") + lsDS[i].HS_TENTOIDANH;
                    }
                    List<GDTTT_DON_DUONGSU_TOIDANH_CC> loTD_DON = null;
                    decimal vDuongsuid_old = Convert.ToDecimal(lsDS[i].ID);
                  
                    loTD_DON = dt.GDTTT_DON_DUONGSU_TOIDANH_CC.Where(x => x.DUONGSUID == vDuongsuid_old).ToList();
                    
                    for (int j = 0; j < loTD_DON.Count; j++)
                    {
                        GDTTT_VUAN_DUONGSU_TOIDANH oDSva = new GDTTT_VUAN_DUONGSU_TOIDANH();
                        oDSva.VUANID = new_vuanid;//id vu an moi
                        oDSva.DUONGSUID = objBC.ID;// id Duong su moi
                        oDSva.TOIDANHID = lsDS[j].HS_TOIDANHID;
                        oDSva.TENTOIDANH = lsDS[j].HS_TENTOIDANH;
                        dt.GDTTT_VUAN_DUONGSU_TOIDANH.Add(oDSva);
                        dt.SaveChanges();
                    }
                    //Update nguoi Khieu Nai mơi sinh ra vao bang DS-KN
                    if (lsDS[i].HS_ISKHIEUNAI == 1)
                    {
                        //Kiem tra Nguoi khieu nai nay co Khieu nai cho bi cao nao khong
                        List<GDTTT_DON_DS_KN_CC> oNKNCC = dt.GDTTT_DON_DS_KN_CC.Where(x => x.NGUOIKHIEUNAIID == vDuongsuid_old).ToList();
                        foreach  (GDTTT_DON_DS_KN_CC ist in oNKNCC)
                        {
                            ist.VUAN_NGUOIKHIEUNAI_NEW = objBC.ID;
                            dt.SaveChanges();
                        }
                    }

                    //Update Bi cao được khiếu nại mới Sinh ra ở Vu an vào Bảng  GDTTT_DON_DS_KN_CC để xác định Bị Cáo được khiếu nại
                    GDTTT_DON_DS_KN_CC odKNCC = dt.GDTTT_DON_DS_KN_CC.Where(x => x.BICAOID == vDuongsuid_old).FirstOrDefault();
                    if (odKNCC != null)
                    {
                        odKNCC.VUAN_BICAO_NEW = objBC.ID;
                        dt.SaveChanges();
                    }


                }
                //Them duong su khieu nai vào bang GDTTT_VUAN_DS_KN
                GDTTT_DON_DUONGSU_CC oDSKN_DON = dt.GDTTT_DON_DUONGSU_CC.Where(x => x.DONID == donid && x.HS_ISKHIEUNAI == 1).FirstOrDefault() ?? new GDTTT_DON_DUONGSU_CC();
                if (oDSKN_DON != null )
                {
                    List<GDTTT_DON_DS_KN_CC> lsDSKN = dt.GDTTT_DON_DS_KN_CC.Where(x => x.NGUOIKHIEUNAIID == oDSKN_DON.ID).ToList();
                    for (int k = 0; k < lsDSKN.Count; k++)
                    {
                        GDTTT_VUAN_DS_KN obDSKN = new GDTTT_VUAN_DS_KN();
                        obDSKN.VUANID = new_vuanid;
                        //ID người khiếu nại đang sai cần lấy ID mới của người khiếu lại
                        obDSKN.NGUOIKHIEUNAIID = lsDSKN[k].VUAN_NGUOIKHIEUNAI_NEW;
                        obDSKN.BICAOID = lsDSKN[k].VUAN_BICAO_NEW; 
                        obDSKN.NOIDUNGKHIEUNAI = lsDSKN[k].NOIDUNGKHIEUNAI;
                        dt.GDTTT_VUAN_DS_KN.Add(obDSKN);
                        dt.SaveChanges();
                    }
                }
              
                //Update về bảng vụ án Tên vụ án
                GDTTT_VUAN objVA = dt.GDTTT_VUAN.Where(x => x.ID == new_vuanid).Single();
                objVA.NGUYENDON = bican_dauvu;
                if (!String.IsNullOrEmpty(bican_dauvu))
                {
                    objVA.TENVUAN = bican_dauvu
                        + (String.IsNullOrEmpty(bican_dauvu + "") ? "" : (string.IsNullOrEmpty(toidanh + "") ? "" : " - "))
                        + toidanh;
                }
                dt.SaveChanges();

                //--- Xoa Bi cao và Toi danh của don tu bang GDTTT_DON_DUONGSU_CC 
                //for (int i = 0; i < lsDS.Count; i++)
                //{
                //    GDTTT_DON_DUONGSU_CC objDSdon = dt.GDTTT_DON_DUONGSU_CC.Where(x => x.DONID == donid).Single();
                //    dt.GDTTT_DON_DUONGSU_CC.Remove(objDSdon);
                //    dt.SaveChanges();

                //    GDTTT_DON_DUONGSU_TOIDANH_CC objDS_TD= dt.GDTTT_DON_DUONGSU_TOIDANH_CC.Where(x => x.DONID == donid).Single();
                //    dt.GDTTT_DON_DUONGSU_TOIDANH_CC.Remove(objDS_TD);
                //    dt.SaveChanges();


                //    GDTTT_DON_DS_KN_CC objDS_KN = dt.GDTTT_DON_DS_KN_CC.Where(x => x.DONID == donid).Single();
                //    dt.GDTTT_DON_DS_KN_CC.Remove(objDS_KN);
                //    dt.SaveChanges();
                //}
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
            ddlPhongban.DataTextField = "TENPHONGBAN";
            ddlPhongban.DataValueField = "ID";
            ddlPhongban.DataBind();
            ddlPhongban.Items.Insert(0, new ListItem("--Chọn đơn vị--", "0"));
            if (strPBID != "") ddlPhongban.SelectedValue = strPBID;
            ddlPhongban.Enabled = false;
        }
        private void LoadDropTinh()
        {
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

            LoadPhongban();

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
        void LoadDropTTV_TheoCanBoLogin()
        {
           
            decimal CurrNhomNSDID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_NHOMNSDID] + "");
            QT_NHOMNGUOIDUNG oGroup = dt.QT_NHOMNGUOIDUNG.Where(x => x.ID == CurrNhomNSDID).Single();
            int loai_hotro_db = (int)oGroup.LOAI;

            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();
            Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault();
            decimal chucdanh_id = (string.IsNullOrEmpty(oCB.CHUCDANHID + "")) ? 0 : Convert.ToDecimal(oCB.CHUCDANHID);
            decimal chucvu_id = (string.IsNullOrEmpty(oCB.CHUCVUID + "")) ? 0 : Convert.ToDecimal(oCB.CHUCVUID);
           
            if (chucvu_id > 0)
            {
                DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == chucvu_id).FirstOrDefault();
                if (oCD.MA == ENUM_CHUCVU.CHUCVU_PVT )
                {
                    LoadDropTTV_TheoLanhDao(CanboID);
                }
                else
                {
                    LoadAll_TTV();
                    
                }
            }
            else if (chucdanh_id > 0)
            {
                DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == chucdanh_id).Single();
                if (oCD.MA == "TTV" || oCD.MA == "TTVCC" || oCD.MA == "TTVC"
                    || oCD.MA == "TK1" || oCD.MA == "TK" || oCD.MA == "TKA" || oCD.MA == "C027"
                    || oCD.MA == "C010" || oCD.MA == "C008" || oCD.MA == "C009") 
                {
                    ddlThamtravien.Items.Clear();
                    ddlThamtravien.Items.Add(new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                    hddLoaiTK.Value = ENUM_CHUCDANH.CHUCDANH_TTV;
                }
                else LoadAll_TTV();
            }
        }
        
        void LoadAll_TTV()
        {
            GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            Decimal LoginDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

            //Thẩm tra viên
            DataTable tblTheoPB = oGDTBL.GDTTT_VuAn_GetAllCBTheoPB(LoginDonViID, PBID, ENUM_CHUCDANH.CHUCDANH_TTV);
            ddlThamtravien.DataSource = tblTheoPB;
            ddlThamtravien.DataTextField = "HOTEN";
            ddlThamtravien.DataValueField = "ID";
            ddlThamtravien.DataBind();
            ddlThamtravien.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
        }

        void LoadDropTTV_TheoLanhDao(Decimal LanhDaoID)
        {
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PhongBanID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            ddlThamtravien.Items.Clear();
            try
            {
                DM_CANBO_BL obj = new DM_CANBO_BL();

                DataTable tbl = obj.DM_CANBO_PB_CHUCDANH(PhongBanID, "TTV", LanhDaoID, 0, 1, 200000);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    ddlThamtravien.DataSource = tbl;
                    ddlThamtravien.DataTextField = "HOTEN";
                    ddlThamtravien.DataValueField = "CanBoID";
                    ddlThamtravien.DataBind();
                    ddlThamtravien.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
                }
            }
            catch (Exception ex)
            { }
        }
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
                        IsLoadAll = true;
                    if (IsLoadAll) LoadAllLoaiAn();
                }
                else
                {   if (obj.ISHINHSU == 1)
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
                Boolean check_add = true;
                foreach (ListItem li in ddlLoaiAn.Items)
                {
                    if (li.Value == "01")
                    {
                        check_add = false;
                        break;
                    }
                }
                if (check_add == true)
                {
                    ddlLoaiAn.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
                }
            }
        }
        void LoadAllLoaiAn()
        {
            ddlLoaiAn.Items.Clear();
            ddlLoaiAn.Items.AddRange(ClsHelper.GetEnumLoaiAn().ToArray());
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
            if (obj.ISPHASAN == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC.AN_PHASAN));
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
            if (obj.ISPHASAN == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC.AN_PHASAN));
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

        protected void cmdTralai_Click(object sender, EventArgs e)
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
            int iCount = 0;
            Decimal CurrVuAnID = 0;
            String ListNguoiKN = "";
            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                if (chkChon.Checked)
                {
                    string strID = Item.Cells[0].Text;
                    decimal ID = Convert.ToDecimal(strID);
                    GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();

                    CurrVuAnID = (String.IsNullOrEmpty(oT.VUVIECID + "") ? 0 : (Decimal)oT.VUVIECID);
                    if ((oT.CD_TRANGTHAI == 1 || oT.CD_TRANGTHAI == 2) && oT.CD_LOAI == 0)
                    {
                        //TRA DON
                        oT.CD_TRANGTHAI = 3;
                        oT.CD_NGAYXULY = vNgayNhan;
                        dt.SaveChanges();

                        //Update danh sách lịch sử chuyển đơn;
                        update_lichsu_chuyendon(ID, ToaAnID, PhongBanID, (DateTime)oT.CD_NGAYXULY);
                        //Xóa thông tin đẫ chuyển từ bảng đơn chuyển
                        List<GDTTT_DON_CHUYEN> lstC = dt.GDTTT_DON_CHUYEN.Where(x => x.DONID == ID
                                                                     && x.DONVINHANID == ToaAnID
                                                                     && x.PHONGBANNHANID == PhongBanID).OrderByDescending(x => x.NGAYCHUYEN).ToList();
                        if (lstC.Count > 0)
                        {
                            GDTTT_DON_CHUYEN oC = lstC[0];
                            dt.GDTTT_DON_CHUYEN.Remove(oC);
                            dt.SaveChanges();
                        }
                        //22/01/2026 khi trả lại thì tất cả đều về văn phòng hết theo yêu cầu mới
                        //update thong tin dư lieu tai tham phan
                        //DM_CANBO cb = dt.DM_CANBO.Where(x => x.ID == oT.THAMPHANID).FirstOrDefault();
                        //GDTTT_DON_CHUYEN objc = dt.GDTTT_DON_CHUYEN.Where(x => x.DONID == ID && x.DONVINHANID == oT.TOAANID
                        //&& x.PHONGBANNHANID == cb.PHONGBANID).FirstOrDefault();
                        //if (objc !=null)
                        //{
                        //    if (oT.ISTHULY == 1)
                        //    {
                        //        objc.TRANGTHAI = 2;//1 Chưa nhận; 2 Đã nhận; 3 Trả lại; 4 Đã chuyển
                        //    }
                        //    dt.SaveChanges();
                        //}
                        //Update danh sách các đơn chuyển cùng
                        try
                        {
                            string strArrDon = chkChon.ToolTip;
                            string[] strarr = strArrDon.Split(',');
                            if (strarr.Length > 1)
                            {
                                strArrDon = "," + strArrDon + ",";
                                List<GDTTT_DON> lstTrung = dt.GDTTT_DON.Where(x => x.ID != oT.ID
                                                                                && strArrDon.Contains("," + x.ID.ToString() + ",")).ToList();
                                foreach (GDTTT_DON oDT in lstTrung)
                                {
                                    oDT.CD_TRANGTHAI = 3;
                                    oDT.VUVIECID = 0;
                                    ListNguoiKN += (String.IsNullOrEmpty(ListNguoiKN + "") ? "" : ", ") + (String.IsNullOrEmpty(oDT.NGUOIGUI_HOTEN + "") ? "" : oDT.NGUOIGUI_HOTEN);
                                }
                                dt.SaveChanges();
                            }
                        }
                        catch (Exception ex) { }
                    }
                    //-------------------------
                    Boolean IsDelete = false;
                    List<GDTTT_DON> lstDonByAn = dt.GDTTT_DON.Where(x => x.VUVIECID == CurrVuAnID
                                                                      && x.CD_TRANGTHAI == 2 && x.ISTHULY == 1).ToList();
                    if (lstDonByAn != null && lstDonByAn.Count > 0)
                    {
                        //con don thu ly moi --> ko cho xoa vu an
                        IsDelete = false;
                    }
                    else
                    {
                        IsDelete = true;
                    }
                    //-------------------------
                    oT.VUVIECID = 0;
                    //int ISTHULY = (String.IsNullOrEmpty(oT.ISTHULY + "")) ? 0 : Convert.ToInt16(oT.ISTHULY);
                    //if (ISTHULY == 1)
                    if (IsDelete)
                    {
                        //KT vu an co nguyen don, bi don chua
                        //chua co ==> xoa luon vu an da tao (neu so don thu ly moi cua vu an =1)
                        //da co --> ko cho xoa vu an
                        if (CurrVuAnID > 0)
                        {
                            try
                            {
                                GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == CurrVuAnID).Single();
                                List<GDTTT_VUAN_DUONGSU> lstDS = dt.GDTTT_VUAN_DUONGSU.Where(x => x.VUANID == CurrVuAnID).ToList();
                                if (lstDS != null && lstDS.Count > 0)
                                {
                                    //co dduong su, ko xoa vu an, Update lai so thu ly, ngay thu ly cua vu an
                                    oVA.SOTHULYDON = "";
                                    oVA.NGAYTHULYDON = null;
                                    dt.SaveChanges();
                                }
                                else
                                {
                                    //chi co mot don thu ly moi--> xoa vu an
                                    dt.GDTTT_VUAN.Remove(oVA);

                                    ////------Update cac don da thu ly.VuViecID=0------------
                                    //lstDon = dt.GDTTT_DON.Where(x => x.VUVIECID == CurrVuAnID && (x.ISTHULY == null || x.ISTHULY == 0)).ToList();
                                    //foreach (GDTTT_DON oDon in lstDon)
                                    //    oDon.VUVIECID = 0;
                                    //dt.SaveChanges();
                                }
                            }
                            catch (Exception ex) { }
                        }
                    }

                    dt.SaveChanges();

                    //-----update thong tin trong vu an: tongdon, isanqh, isanchidao, arrnguoikhieunai
                    if (CurrVuAnID > 0)
                    {
                        GDTTT_DON_BL objBL = new GDTTT_DON_BL();
                        objBL.Update_Don_TH(CurrVuAnID);
                    }
                    iCount++;
                }
            }
            if (iCount == 0)
                lbtthongbao.Text = "Chưa chọn đơn trả lại!";
            else
            {
                Load_Data();
                lbtthongbao.Text = "Hoàn thành trả lại " + iCount.ToString() + " đơn !";
            }
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

                    ////Xóa thông tin đẫ chuyển từ bảng đơn chuyển
                    //dt.GDTTT_DON_CHUYEN.Remove(oC);
                    dt.SaveChanges();

                }
            }
            catch (Exception ex) { }
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

        protected void cmdGiaoTHS_Click(object sender, EventArgs e)
        {
            SetGetSessionTK(true);
            string StrMsg = "PopupReport('/QLAN/GDTTT/Giaiquyet/Popup/GiaoNhanTHS.aspx','Sửa đổi danh sách',1150,800);";
            System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
           
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
                Cls_Comon.SetButton(cmdGiaoTHS, false);
                cmdInDonDaNhan.Visible = false;
            }
            else if (rdbTrangThai.SelectedValue == "2")
            {
                Cls_Comon.SetButton(cmdTralai, true);
                Cls_Comon.SetButton(cmdNhandon, false);
                 Cls_Comon.SetButton(cmdGiaoTHS, true);

                pnGhepVuAn.Visible = true;
                cmdInDonDaNhan.Visible = true;
            }
            else
            {
                Cls_Comon.SetButton(cmdTralai, false);
                Cls_Comon.SetButton(cmdNhandon, false);
                Cls_Comon.SetButton(cmdGiaoTHS, false);
                cmdInDonDaNhan.Visible = false;
            }
        }

        protected void cmdNhandon_Click(object sender, EventArgs e)
        {
            //Kiểm tra ngày nhận đơn
            if (txtBC_Ngay.Text == "")
            {
                lbtthongbao.Text = "Chưa nhập ngày nhận đơn !";
                lbtthongbao.ForeColor = System.Drawing.Color.Red;
                txtBC_Ngay.Focus();
            }
            DateTime? vNgayNhan = txtBC_Ngay.Text == "" ? (DateTime?)null : DateTime.Parse(txtBC_Ngay.Text, cul, DateTimeStyles.NoCurrentDateDefault);

            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PhongbanID = Convert.ToDecimal(ddlPhongban.SelectedValue);
            int iCount = 0;
            Decimal CurrThamPhanID = 0;
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
                    decimal VuAnID = 0;
                    if (hddVuAnID.Value != "")
                    {
                        VuAnID = Convert.ToDecimal(hddVuAnID.Value);
                    }
                    int ismap_vuan = 0;
                    if (hddIsMapVuAn.Value != "")
                    {
                        ismap_vuan=Convert.ToInt16(hddIsMapVuAn.Value);
                    }
                    int isthuly = 0;
                    if (hddIsThuLy.Value!="")
                    {
                        isthuly = Convert.ToInt16(hddIsThuLy.Value);
                    }
                    
                    Boolean IsKQ = true;
                    //Kiem tra xem vu an da co KQ chua
                    if (VuAnID > 0)
                        IsKQ = CheckKQGQ(VuAnID);

                    GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == DonID).FirstOrDefault();
                    /*nhan don tat ca cac vụ
                    -don thu ly moi(Chưa nhan đơn)-- > map duoc vu an
                    -- > se kiem tra : Da co giai quyet don hay chua-- > co roi thì cho ghep vu an
                    --> chua co-- > Tao mới vu an(nhu bay gio)*/
                    if (oT.LOAIDON == 4)
                    {//Đơn là Hồ sơ của VKS thì mặc định tạo vụ án nếu đơn đó chưa có VỤ án
                        //Tao vu an khi đơn chưa có Vụ án
                        if (VuAnID == 0)
                        {
                            VuAnID = TaoVuAn_ThuLyMoi(DonID, null, ismap_vuan);

                            Decimal LoaiAn = String.IsNullOrEmpty(oT.BAQD_LOAIAN + "") ? 0 : (Decimal)oT.BAQD_LOAIAN;
                            if (LoaiAn == Convert.ToDecimal(ENUM_LOAIVUVIEC.AN_HINHSU))
                            {
                                List<GDTTT_DON_DUONGSU_CC> lsDS = null;
                                lsDS = dt.GDTTT_DON_DUONGSU_CC.Where(x => x.DONID == DonID).ToList();
                                if (lsDS.Count > 0)
                                {
                                    ADD_BICAO_DON(DonID, VuAnID);
                                }
                                else
                                {
                                    //Them bi cao dau vu neu cua vu an da ton toi Neu Don khong co bi cao
                                    ADD_BiCaoDauVu(DonID, VuAnID, ToaAnID);
                                }
                            }
                            else
                            {
                                //Them nguyen don, bi don
                                ADD_DUONGSU_DON(DonID, VuAnID);
                            }

                        }
                    }
                    else
                    {
                        //Đơn; Đơn + Công văn; Công Văn; Công Văn + Hồ sơ; Don Khieu nai tu phap
                        if (isthuly == 1)
                        {
                            CurrThamPhanID = String.IsNullOrEmpty(oT.THAMPHANID + "") ? 0 : (Decimal)oT.THAMPHANID;
                            try
                            {   // khi don.vuviecid >0 thì ismap_vuan >0
                                if (ismap_vuan > 0)
                                {
                                    //KT : vu an da co ket qua giai quyet (IsKQ == true)--> Them moi
                                    //Chua co kqgq--> ghep vu an                               
                                    if (IsKQ)
                                    {
                                        //Tao vu an
                                        if (VuAnID == 0)
                                        {
                                            VuAnID = TaoVuAn_ThuLyMoi(DonID, null, ismap_vuan);

                                            Decimal LoaiAn = String.IsNullOrEmpty(oT.BAQD_LOAIAN + "") ? 0 : (Decimal)oT.BAQD_LOAIAN;
                                            if (LoaiAn == Convert.ToDecimal(ENUM_LOAIVUVIEC.AN_HINHSU))
                                            {
                                                List<GDTTT_DON_DUONGSU_CC> lsDS = null;
                                                lsDS = dt.GDTTT_DON_DUONGSU_CC.Where(x => x.DONID == DonID).ToList();
                                                if (lsDS.Count > 0)
                                                {
                                                    ADD_BICAO_DON(DonID, VuAnID);
                                                }
                                                else
                                                {
                                                    //Them bi cao dau vu neu cua vu an da ton toi Neu Don khong co bi cao
                                                    ADD_BiCaoDauVu(DonID, VuAnID, ToaAnID);
                                                }
                                            }
                                            else
                                            {
                                                //Them nguyen don, bi don
                                                ADD_DUONGSU_DON(DonID, VuAnID);
                                            }

                                        }
                                    }
                                }
                                else
                                {
                                    //chua map vu an--> can kiem tra xem co thong tin vuan tuong ung chua
                                    VuAnID = CheckMapVuAn(DonID, ToaAnID);
                                    //Tao vu an
                                    if (VuAnID == 0)
                                    {
                                        VuAnID = TaoVuAn_ThuLyMoi(DonID, null, ismap_vuan);
                                        //Them duong su tu DOn
                                        Decimal LoaiAn = String.IsNullOrEmpty(oT.BAQD_LOAIAN + "") ? 0 : (Decimal)oT.BAQD_LOAIAN;
                                        if (LoaiAn == Convert.ToDecimal(ENUM_LOAIVUVIEC.AN_HINHSU))
                                        {
                                            List<GDTTT_DON_DUONGSU_CC> lsDS = null;
                                            lsDS = dt.GDTTT_DON_DUONGSU_CC.Where(x => x.DONID == DonID).ToList();
                                            if (lsDS.Count > 0)
                                            {
                                                ADD_BICAO_DON(DonID, VuAnID);
                                            }
                                            else
                                            {
                                                //Them bi cao dau vu neu cua vu an da ton toi Neu Don khong co bi cao
                                                ADD_BiCaoDauVu(DonID, VuAnID, ToaAnID);
                                            }
                                        }
                                        else
                                        {
                                            //Them nguyen don, bi don
                                            ADD_DUONGSU_DON(DonID, VuAnID);
                                        }
                                    }

                                }

                            }
                            catch (Exception ex) { }
                        }
                        else
                        {
                            if (ismap_vuan == 0)
                            {
                                // don ko phai la thu ly moi, ko map vu an
                                //--> KT trong cac don chuyen cung
                                //--> neu co don la ThuLyMoi 
                                //--> Tao vu an truoc roi moi ghep don dang nhan vao vụ an
                                try
                                {
                                    string ArrDonID = String.IsNullOrEmpty(hddArrDonTrung.Value) ? "" : ("," + hddArrDonTrung.Value + ",");
                                    List<GDTTT_DON> lst = dt.GDTTT_DON.Where(x => x.ISTHULY == 1
                                                                                && ArrDonID.Contains("," + x.ID + ",")).ToList();
                                    if (lst != null && lst.Count > 0)
                                    {
                                        //Tao vu an moi tu Don co trang thai = thu ly moi
                                        GDTTT_DON oDon = lst[0];
                                        CurrThamPhanID = String.IsNullOrEmpty(oDon.THAMPHANID + "") ? 0 : (Decimal)oDon.THAMPHANID;
                                        VuAnID = CheckMapVuAn(oDon.ID, ToaAnID);
                                        if (VuAnID == 0)
                                        {
                                            VuAnID = TaoVuAn_ThuLyMoi(oDon.ID, oDon, 0);
                                            //Them duong su tu DOn
                                            Decimal LoaiAn = String.IsNullOrEmpty(oT.BAQD_LOAIAN + "") ? 0 : (Decimal)oT.BAQD_LOAIAN;
                                            if (LoaiAn == Convert.ToDecimal(ENUM_LOAIVUVIEC.AN_HINHSU))
                                            {
                                                List<GDTTT_DON_DUONGSU_CC> lsDS = null;
                                                lsDS = dt.GDTTT_DON_DUONGSU_CC.Where(x => x.DONID == DonID).ToList();
                                                if (lsDS.Count > 0)
                                                {
                                                    ADD_BICAO_DON(DonID, VuAnID);
                                                }
                                                else
                                                {
                                                    //Them bi cao dau vu neu cua vu an da ton toi Neu Don khong co bi cao
                                                    ADD_BiCaoDauVu(DonID, VuAnID, ToaAnID);
                                                }
                                            }
                                            else
                                            {
                                                //Them nguyen don, bi don
                                                ADD_DUONGSU_DON(DonID, VuAnID);
                                            }
                                        }
                                    }
                                }
                                catch (Exception ex) { }
                            }
                        }
                    }
                    //-----------------------------
                    if (oT != null)
                    {
                        if (oT.CD_LOAI == 0)//oT.CD_TRANGTHAI == 1 &&
                        {
                            #region Update trang thai don
                            iCount += 1;
                            oT.CD_TRANGTHAI = 2;
                            //lưu ngày nhận theo người dùng nhập
                            oT.CD_NGAYXULY = vNgayNhan;
                            oT.VUVIECID = VuAnID;
                            dt.SaveChanges();
                            #endregion

                            #region update don chuyen
                            //Update danh sách lịch sử chuyển đơn;
                            List<GDTTT_DON_CHUYEN> lstC = dt.GDTTT_DON_CHUYEN.Where(x => x.DONID == DonID
                                                                                    && x.DONVINHANID == ToaAnID
                                                                                    && x.PHONGBANNHANID == PhongbanID
                                                                                  ).OrderByDescending(x => x.NGAYCHUYEN).ToList();
                            if (lstC.Count > 0)
                            {
                               
                                GDTTT_DON_CHUYEN oC = lstC[0];
                                //lưu ngày nhận thực tế
                                oC.NGAYNHAN = DateTime.Now;
                                oC.TRANGTHAI = 2;
                                oC.NGUOINHAN = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                oC.GHICHU = txtBC_Ghichu.Text;
                                dt.SaveChanges();
                            }

                            //Update danh sách các đơn chuyển cùng
                            string strArrDon = chkChon.ToolTip;
                            string[] strarr = strArrDon.Split(',');
                            if (strarr.Length > 1)
                            {
                                GDTTT_DON oDT = null;
                                Decimal currr_id = 0;
                                foreach (String item in strarr)
                                {
                                    if (item.Length > 0)
                                    {
                                        currr_id = Convert.ToDecimal(item);
                                        if (currr_id != oT.ID)
                                        {
                                            oDT = dt.GDTTT_DON.Where(x => x.ID == currr_id).Single();
                                            oDT.CD_TRANGTHAI = 2;
                                            oDT.VUVIECID = VuAnID;
                                        }
                                    }
                                }

                                //List<GDTTT_DON> lstTrung = dt.GDTTT_DON.Where(x => x.ID != oT.ID && strArrDon.Contains("," + x.ID.ToString() + ",")).ToList();
                                //foreach (GDTTT_DON oDT in lstTrung)
                                //{
                                //    oDT.CD_TRANGTHAI = 2;
                                //    oDT.VUVIECID = VuAnID;
                                //}
                                dt.SaveChanges();
                            }
                            #endregion
                        }
                    }
                    if (VuAnID > 0)
                    {
                        GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).Single();
                        if (CurrThamPhanID > 0) 
                            oVA.THAMPHANID = CurrThamPhanID;
                        dt.SaveChanges();

                        Decimal LoaiAn = String.IsNullOrEmpty(oT.BAQD_LOAIAN + "") ? 0 : (Decimal)oT.BAQD_LOAIAN;
                        //Update Lại đơn
                        GDTTT_DON objDon = dt.GDTTT_DON.Where(x => x.ID == DonID).FirstOrDefault();
                        objDon.VUVIECID = VuAnID;
                        dt.SaveChanges();
                        hddVuAnID.Value = Convert.ToString(VuAnID);
                        //Them các nguoi khieu nai moi tu các don ghep vao vu an 
                        if (LoaiAn == Convert.ToDecimal(ENUM_LOAIVUVIEC.AN_HINHSU))
                        {
                            List<GDTTT_DON> lstDon = dt.GDTTT_DON.Where(x => x.VUVIECID == VuAnID && x.ISTHULY == 1).ToList();
                            if (lstDon != null && lstDon.Count > 0)
                            {
                                foreach (GDTTT_DON oD in lstDon)
                                {
                                    if (oD.LOAIDON != 4) // Ho so KN VKS khong them Nguoi khieu nai
                                        ThemNguoiKhieuNai(VuAnID, oD.NGUOIGUI_HOTEN);
                                }
                            }
                        }
                        //-----update thong tin : tongdon, isanqh, isanchidao, arrnguoikhieunai
                        GDTTT_DON_BL objBL = new GDTTT_DON_BL();
                        objBL.Update_Don_TH(VuAnID);
                    }
                    //--------------
                    if (VuAnID > 0)
                        Update_TenVuAn(VuAnID);
                }
            }

            //---------------------------------
            if (iCount == 0)
                lbtthongbao.Text = "Chưa chọn đơn cần nhận!";
            else
            {
                Load_Data();
                lbtthongbao.Text = "Hoàn thành nhận " + iCount.ToString() + " đơn !";
            }
        }
        decimal ThemNguoiKhieuNai(Decimal CurrVuAnID, String TenDS)
        {
            String TenNguoiKhieuNai = TenDS.Trim().ToLower();
            GDTTT_VUAN_DUONGSU obj = new GDTTT_VUAN_DUONGSU();
            List<GDTTT_VUAN_DUONGSU> lst = dt.GDTTT_VUAN_DUONGSU.Where(x => x.VUANID == CurrVuAnID
                                                                         && x.HS_ISKHIEUNAI == 1
                                                              && x.TENDUONGSU.Trim().ToLower() == TenNguoiKhieuNai).ToList();
            if (lst == null || lst.Count == 0)
            {
                obj = new GDTTT_VUAN_DUONGSU();
                obj.VUANID = CurrVuAnID;
                obj.LOAI = 0;
                obj.GIOITINH = 2;
                obj.BICAOID = 0;
                obj.HS_TUCACHTOTUNG = "";
                //----------------------
                obj.HS_ISKHIEUNAI = 1;
                obj.HS_BICANDAUVU = 0;
                obj.HS_ISBICAO = 0;
                //----------------------
                obj.TUCACHTOTUNG = ENUM_DANSU_TUCACHTOTUNG.KHAC;
                obj.TENDUONGSU = Cls_Comon.FormatTenRieng(TenDS.Trim());
                obj.HS_MUCAN = "";
                obj.DIACHI = "";
                //----------------------
                obj.NGAYTAO = DateTime.Now;
                obj.NGUOITAO = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
                dt.GDTTT_VUAN_DUONGSU.Add(obj);
                dt.SaveChanges();
            }
            //-------------------------
            return obj.ID;
        }
        Boolean CheckKQGQ(Decimal VuAnID)
        {
            GDTTT_VUAN objVA = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).Single();
            if (objVA != null)
            {
                if (objVA.LOAIAN == 1)
                {
                    int LoaiKQ = String.IsNullOrEmpty(objVA.GQD_LOAIKETQUA + "") ? 5 : Convert.ToInt16(objVA.GQD_LOAIKETQUA + "");
                    if (LoaiKQ < 5)
                    {
                        return true;
                    }
                    else
                        return false;
                }
                else
                {
                    //lay thong tin tu bang ket qua GDTTT_VUAN_KETQUA
                    List<GDTTT_VUAN_KETQUA> lstVUAN_KETQUA = new List<GDTTT_VUAN_KETQUA>();
                    var checktrangthai = oVAKQ.GDTTT_VUAN_KETQUA_GETBYVUANID(VuAnID);
                    if (checktrangthai != null && checktrangthai.Rows.Count > 0)
                        return true;
                    else
                        return false;
                }
            }
            else return false;
        }
        Decimal TaoVuAn_ThuLyMoi(Decimal DonID, GDTTT_DON oDon, Decimal OldVuAnID)
        {
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            Decimal VuAnID = 0;
            GDTTT_VUAN objVA = new GDTTT_VUAN();
            if (oDon == null && DonID > 0)
                oDon = dt.GDTTT_DON.Where(x => x.ID == DonID).Single();

            if (oDon != null)
            {
                //---------TRUONGHOPTHULY---------------- 1 đơn gdtt cap cao; 11 đon GDT Toi cao; 3 đon + cv câp cao; 31 đơn + cv tôi cao
                if (oDon.LOAIDON == 1 || oDon.LOAIDON == 2 || oDon.LOAIDON == 3 || oDon.LOAIDON == 6 || oDon.LOAIDON == 9 || oDon.LOAIDON == 11 || oDon.LOAIDON == 31) 
                {
                    objVA.TRUONGHOPTHULY = 0;
                    //-------------------------------
                    objVA.TRANGTHAIID = 1; // chua phan cong TTV
                }
                else if (oDon.LOAIDON == 8 || oDon.LOAIDON == 10)
                {
                    //Khieu nai tu phap
                    objVA.TRUONGHOPTHULY = oDon.LOAIDON;
                    //-------------------------------
                    objVA.TRANGTHAIID = 1; // chua phan cong TTV
                    // Cần thêm Trương loại KN, Tố cáo vào bảng GDTTT_VUAN
                    //LOAIKNTC


                }
                else if (oDon.LOAIDON == 4)
                {
                    objVA.TRUONGHOPTHULY = 1;
                    objVA.GQD_LOAIKETQUA = 1;//khang nghi
                    objVA.GQD_KETQUA = "Kháng nghị";
                    objVA.ISVIENTRUONGKN = 1;
                    objVA.VIENTRUONGKN_SO = oDon.SO_HSKN;
                    objVA.XXGDTTT_SOBUTLUCKN = oDon.SOBUTLUC;
                    objVA.XXGDTTT_NOIDUNGKN = oDon.NOIDUNGKN;
                    if (!String.IsNullOrEmpty(oDon.NGAY_HSKN + ""))
                        objVA.VIENTRUONGKN_NGAY = objVA.GDQ_NGAY = oDon.NGAY_HSKN;
                    //Neu la Chanh an TANDTC khang nghị
                    if (oDon.DONVICHUYEN_HSKN == 818 || oDon.DONVICHUYEN_HSKN == 819 || oDon.DONVICHUYEN_HSKN == 820 || oDon.DONVICHUYEN_HSKN == 821)
                        objVA.THAMQUYENXXGDT = oDon.TOAANID;
                    else
                        objVA.THAMQUYENXXGDT = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]); // Nếu không phải tối cao, thì thẩm quyền xx gđt chắc chắn thuộc về đơn vị chuyển hồ sơ

                    objVA.VIENTRUONGKN_NGUOIKY = oDon.DONVICHUYEN_HSKN;
                    
                }
                //--------------------------------------------------------------
                if (oDon.LOAIDON == 8 || oDon.LOAIDON == 10)
                    objVA.QHPL_TEXT = oDon.NOIDUNGDON;
                else
                    objVA.QHPL_TEXT = oDon.QHPL_TEXT;


                objVA.TENVUAN = "Thụ lý mới ";
                //-----------------
                objVA.TOAANID = ToaAnID;
                objVA.PHONGBANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                objVA.PHONGBANGQ = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                //phân biệt Đơn đề nghị GDT hay TT
                objVA.LOAI_GDTTTT = oDon.LOAI_GDTTTT;
                //phan biet thụ lý xx gdt và thụ lý đơn gdt
                if (oDon.LOAIDON == 4) {
                    //----Thong tin thu ly xet xu GDT----------
                    objVA.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.THULY_XETXU_GDT;
                    objVA.SOTHULYXXGDT = oDon.TL_SO;
                    objVA.NGAYTHULYXXGDT = oDon.TL_NGAY;
                    objVA.XXGDTTT_NGAYVKSTRAHS = oDon.NGAYNHANDON;
                }
                else
                {
                    objVA.SOTHULYDON = oDon.TL_SO;
                    objVA.NGAYTHULYDON = oDon.TL_NGAY;
                }

                if (oDon.LOAIDON == 6 || oDon.LOAIDON == 9)
                {
                    objVA.NGUOIKHIEUNAI = oDon.CV_TENDONVI + "";
                }
                else
                {
                    if (oDon.DONGKHIEUNAI != null)
                    {
                        objVA.NGUOIKHIEUNAI = oDon.DONGKHIEUNAI + "";
                    }
                    else if (oDon.NGUOIGUI_HOTEN != null)
                    {
                        objVA.NGUOIKHIEUNAI = oDon.NGUOIGUI_HOTEN + "";
                        objVA.DIACHINGUOIDENGHI = oDon.NGUOIGUI_DIACHI;
                    }
                }
                
               
                decimal huyenid;
                if (oDon.CV_TENDONVI != null)
                {
                    huyenid = (string.IsNullOrEmpty(oDon.CV_HUYENID + "")) ? 0 : (decimal)oDon.CV_HUYENID; if (huyenid > 0)
                    {
                        objVA.DIACHINGUOIDENGHI += ((string.IsNullOrEmpty(objVA.DIACHINGUOIDENGHI + "")) ? "" : ", ")
                                                    + dt.DM_HANHCHINH.Where(x => x.ID == oDon.CV_HUYENID).FirstOrDefault().MA_TEN;
                    }
                }
                else
                {
                    huyenid = (string.IsNullOrEmpty(oDon.NGUOIGUI_HUYENID + "")) ? 0 : (decimal)oDon.NGUOIGUI_HUYENID;

                    if (huyenid > 0)
                    {
                        objVA.DIACHINGUOIDENGHI += ((string.IsNullOrEmpty(objVA.DIACHINGUOIDENGHI + "")) ? "" : ", ")
                                                    + dt.DM_HANHCHINH.Where(x => x.ID == oDon.NGUOIGUI_HUYENID).FirstOrDefault().MA_TEN;
                    }
                }
                    


                objVA.NGAYTRONGDON = oDon.NGAYGHITRENDON;
                objVA.NGAYNHANDONDENGHI = oDon.NGAYNHANDON;

                //------------------------------
                objVA.LOAIAN = String.IsNullOrEmpty(oDon.BAQD_LOAIAN + "") ? 0 : (Decimal)oDon.BAQD_LOAIAN;
                //--kiem tra đổ đúng bản án  BAQD_LOAIQDBA BAQD_CAPXETXU
                objVA.BAQD_LOAIQDBA = oDon.BAQD_LOAIQDBA;
                objVA.BAQD_CAPXETXU = oDon.BAQD_CAPXETXU;
             
                objVA.SO_QDGDT = oDon.BAQD_SO;
                objVA.NGAYQD = oDon.BAQD_NGAYBA;
                objVA.TOAQDID = String.IsNullOrEmpty(oDon.BAQD_TOAANID + "") ? 0 : (decimal)oDon.BAQD_TOAANID;
               
                objVA.SOANPHUCTHAM = oDon.BAQD_SO_PT;
                objVA.NGAYXUPHUCTHAM = oDon.BAQD_NGAYBA_PT;
                objVA.TOAPHUCTHAMID = String.IsNullOrEmpty(oDon.BAQD_TOAANID_PT + "") ? 0 : (decimal)oDon.BAQD_TOAANID_PT;
               
                objVA.SOANSOTHAM = oDon.BAQD_SO_ST;
                objVA.NGAYXUSOTHAM = oDon.BAQD_NGAYBA_ST;
                objVA.TOAANSOTHAM = String.IsNullOrEmpty(oDon.BAQD_TOAANID_ST + "") ? 0 : (decimal)oDon.BAQD_TOAANID_ST;

                
                //--------------------------------------------------------------

                decimal thamphan_id = (String.IsNullOrEmpty(oDon.THAMPHANID + "")) ? 0 : Convert.ToDecimal(oDon.THAMPHANID);
                objVA.THAMPHANID = thamphan_id;
                if (thamphan_id > 0)
                {
                    try
                    {
                        GDTTT_PCTP_CHITIET oKQCT = dt.GDTTT_PCTP_CHITIET.Where(x => x.DONID == DonID).Single();
                        //Lay ra ngay thực hiện Phân công TP 
                        if (oKQCT.NGAYPHANCONGTP == null)
                        {
                            GDTTT_PCTP_KETQUA oKQPC = dt.GDTTT_PCTP_KETQUA.Where(x => x.ID == oKQCT.KETQUAID).Single();
                            objVA.NGAYPHANCONGTP = oKQPC.NGAYPHANCONG;
                        }//nếu không có thì lấy ngày tờ trình
                        else
                            objVA.NGAYPHANCONGTP = oKQCT.NGAYPHANCONGTP;
                    }
                    catch (Exception ex) { }

                }
                
                objVA.THULYLAI_VUANID = OldVuAnID;
                
                objVA.ISTOTRINH = objVA.ISHOSO = objVA.HOSOID = 0;
                


                objVA.NGAYTAO = DateTime.Now;
                objVA.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                //kiem tra an tu hinh-------------------------------
                Decimal Loaian = Convert.ToDecimal(Session[SS_TK.LOAIAN]);
                if (Loaian == 1)
                {
                    if (oDon.ISTH_ANGIAM == 1 && oDon.ISTH_KEUOAN == 1)
                    {
                        objVA.ISXINANGIAM = 2;
                    }
                    else if (oDon.ISTH_ANGIAM == 1 && oDon.ISTH_KEUOAN == 0)
                    {
                        objVA.ISXINANGIAM = 1;
                    }
                    else if (oDon.ISANTUHINH == 1)
                    {
                        objVA.ISXINANGIAM = 2;
                    }
                    else
                        objVA.ISXINANGIAM = 0;
                }
                //-------------------------

                //decimal loaicv = (int)oDon.LOAICONGVAN;
                //if (loaicv > 0)
                //{
                //    DM_DATAITEM oDA = dt.DM_DATAITEM.Where(x => x.ID == loaicv).Single();
                //    string[] ArrSapXep = oDA.ARRSAPXEP.Split('/');
                //    if (ArrSapXep[0] == "1023" || ArrSapXep[0] == "1033")
                //        objVA.ISANQUOCHOI = 1;
                //}
                dt.GDTTT_VUAN.Add(objVA);
                //------------------------------
                dt.SaveChanges();
                VuAnID = objVA.ID;
                //Them lich su tao vu an 
                //Luu thong tin Vu an sau khi tao vu an                          
                var json = new JavaScriptSerializer().Serialize(objVA);
                ADS_DON_BL oBL_HIS = new ADS_DON_BL();
                oBL_HIS.HISTORY_ALLDATA_BY_VUANID(Convert.ToDecimal(DonID), 8, Session[ENUM_SESSION.SESSION_USERID] + "", Session[ENUM_SESSION.SESSION_USERNAME].ToString(), "Giam doc tham Don vi: " + ToaAnID + " Phong: " + PhongBanID+ " Nhan don", "TaoVuAn_Tu_Don", json);
                
                //Nếu loại đơn là CV kiến nghị kèm Hồ sơ thì Vụ án đã có hồ sơ
                if (oDon.LOAIDON == 9)
                {
                    //Tạo phiếu mượn hồ sơ
                    GDTTT_QUANLYHS oHS = new GDTTT_QUANLYHS();
                    oHS.LOAI = "3";
                    oHS.VUANID = objVA.ID;
                    // ngày nhận hồ sơ
                    oHS.NGAYTAO = oDon.NGAYNHANDON;
                    oHS.TENCANBO = oDon.NGUOITAO;
                    oHS.TRANGTHAI = Convert.ToInt16(oHS.LOAI);
                    oHS.GROUPID = Guid.Empty.ToString(); //Guid.NewGuid().ToString();               
                    dt.GDTTT_QUANLYHS.Add(oHS);
                    dt.SaveChanges();
                    //update lại trạng thái hồ sơ vào bảng Vụ án
                    GDTTT_VUAN objVA_HS = dt.GDTTT_VUAN.Where(x=> x.ID == VuAnID).Single();
                    objVA_HS.ISHOSO = 1;
                    objVA_HS.HOSOID = oHS.ID;
                    dt.SaveChanges();
                }
            }
            return VuAnID;
        }
        protected void cmdPhancongTTV_Click(object sender, EventArgs e)
        {
            SetGetSessionTK(true);
            string StrMsg = "PopupReport('/QLAN/GDTTT/Hoso/Popup/PhancongTTV.aspx','Phân công thẩm tra viên',1150,800);";
            System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
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
        protected void ddlThamtravien_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
        }
        //them loai an
        protected void ddlLoaiAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
            Load_Data();
        }

        void SetTieuDeBaoCao()
        {
            string tieudebc = "";
            tieudebc += " " + rdbTrangThai.SelectedItem.Text.ToLower() + " từ HCTP";
            //-------------------------------------

            if (ddlPhanloaiDdon.SelectedValue != "0")
                tieudebc += " " + ddlPhanloaiDdon.SelectedItem.Text.ToLower();

            if (ddlHinhthucdon.SelectedValue != "0")
                tieudebc += " có hình thức đơn là " + ddlHinhthucdon.SelectedItem.Text.ToLower();

            if (ddlThuLy.SelectedValue != "-1")
                tieudebc += " là " + ddlThuLy.SelectedItem.Text.ToLower();

            if (ddlToaXetXu.SelectedValue != "0")
                tieudebc += " do " + ddlToaXetXu.SelectedItem.Text + " ra BA/QD";

            if (ddlThamtravien.SelectedValue != "0")
                tieudebc += ", TTV " + ddlThamtravien.SelectedItem.Text + " phụ trách";

            if (ddlLoaiAn.SelectedValue != "0")
                tieudebc += ", của án " + ddlLoaiAn.SelectedItem.Text;

            //if (ddlTraloi.SelectedValue != "0")
            //    tieudebc += " " + ddlTraloi.SelectedItem.Text.ToLower();
            txtTieuDeBC.Text = "Danh sách đơn" + tieudebc.Replace("...", "");
        }
        protected void cmdInDonDaNhan_Click(object sender, EventArgs e)
        {

            SetGetSessionTK(true);
            String SessionName = "GDTTT_Don_ReportPL".ToUpper();
            //--------------------------
            String ReportName = "";
            if (String.IsNullOrEmpty(txtTieuDeBC.Text.Trim()))
                SetTieuDeBaoCao();
            ReportName = txtTieuDeBC.Text.Trim().ToUpper();
            Session[SS_TK.TENBAOCAO] = ReportName.ToUpper();

            DataTable tbl = GetDSKemDonTrung(false, false, false);

            Decimal Loaian = Convert.ToDecimal(Session[SS_TK.LOAIAN]);
            if (Loaian == 1)
            {
                LoadReportHS(tbl);
            }
            else
            {
                LoadReport(tbl);
            }
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

            Table_Str_Totals.Text +="<tr style=\"height: 1pt;\">" +
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
        //-----------------------------
        void Update_TenVuAn(Decimal vuanid)
        {
            GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == vuanid).Single();
            Decimal CurrVuAnID = vuanid;
            //GDTTT_VUAN_BL oBL = new GDTTT_VUAN_BL();
            //oBL.AHS_UpdateListTenDS(CurrVuAnID);

            string bican_dauvu = "", bican_khieunai = "", nguoikhieunai = "", toidanh = "";
            int is_bicao = 0, is_dauvu = 0, is_nguoikn = 0;

            List<GDTTT_VUAN_DUONGSU> lst = dt.GDTTT_VUAN_DUONGSU.Where(x => x.VUANID == CurrVuAnID).OrderBy(y => y.TUCACHTOTUNG).ToList();
            if (lst != null && lst.Count > 0)
            {
                foreach (GDTTT_VUAN_DUONGSU ds in lst)
                {
                    is_bicao = String.IsNullOrEmpty(ds.HS_ISBICAO + "") ? 0 : Convert.ToInt16(ds.HS_ISBICAO + "");
                    is_dauvu = String.IsNullOrEmpty(ds.HS_BICANDAUVU + "") ? 0 : Convert.ToInt16(ds.HS_BICANDAUVU + "");
                    is_nguoikn = String.IsNullOrEmpty(ds.HS_ISKHIEUNAI + "") ? 0 : Convert.ToInt16(ds.HS_ISKHIEUNAI + "");

                    if (is_dauvu == 1)
                    {
                        if (bican_dauvu != "")
                            bican_dauvu += (String.IsNullOrEmpty(bican_dauvu)) ? "" : ", ";
                        bican_dauvu += ds.TENDUONGSU;
                        toidanh += ((string.IsNullOrEmpty(toidanh + "")) ? "" : ", ") + ds.HS_TENTOIDANH;
                    }
                    else
                    {
                        // kiem tra xem co bi cao dau vu chua Neu chua thi lay ten vu an theo Bi cao hoặc nguoi khiếu nại
                        List<GDTTT_VUAN_DUONGSU> countDV = dt.GDTTT_VUAN_DUONGSU.Where(x => x.VUANID == CurrVuAnID && x.HS_BICANDAUVU == 1).OrderBy(y => y.TUCACHTOTUNG).ToList();
                        if (countDV.Count == 0)
                        {
                            if (is_bicao == 1)
                            {

                                if (ds.TENDUONGSU != "")
                                {
                                    List<GDTTT_VUAN_DS_KN> obj = dt.GDTTT_VUAN_DS_KN.Where(x => x.BICAOID == ds.ID).ToList();
                                    if (obj.Count > 0)
                                    {
                                        if (bican_khieunai != "")
                                            bican_khieunai += (String.IsNullOrEmpty(bican_khieunai)) ? "" : ", ";
                                        bican_khieunai += ds.TENDUONGSU;
                                    }
                                    else
                                    {
                                        if (bican_khieunai != "")
                                            bican_khieunai += (String.IsNullOrEmpty(bican_khieunai)) ? "" : ", ";
                                        bican_khieunai += ds.TENDUONGSU;
                                    }

                                }


                                toidanh += ((string.IsNullOrEmpty(toidanh + "")) ? "" : ", ") + ds.HS_TENTOIDANH;
                            }
                            else if (is_nguoikn == 1)
                            {
                                nguoikhieunai = (String.IsNullOrEmpty(nguoikhieunai)) ? "" : ", ";
                                nguoikhieunai += ds.TENDUONGSU;
                            }
                        }
                    }
                }
            }
            //---------------------------
            if (oVA == null)
                oVA = dt.GDTTT_VUAN.Where(x => x.ID == CurrVuAnID).Single();

            oVA.NGUYENDON = bican_dauvu;
            oVA.BIDON = bican_khieunai;
            oVA.NGUOIKHIEUNAI = nguoikhieunai;
            //------------------
            if (!String.IsNullOrEmpty(bican_dauvu))
            {
                oVA.TENVUAN = bican_dauvu
                    + (String.IsNullOrEmpty(bican_dauvu + "") ? "" : (string.IsNullOrEmpty(toidanh + "") ? "" : " - "))
                    + toidanh;
            }
            else if (!String.IsNullOrEmpty(bican_khieunai))
            {
                oVA.TENVUAN = bican_khieunai
                    + (String.IsNullOrEmpty(bican_khieunai + "") ? "" : (string.IsNullOrEmpty(toidanh + "") ? "" : " - "))
                    + toidanh;
            }
            dt.SaveChanges();
        }

    }
}
