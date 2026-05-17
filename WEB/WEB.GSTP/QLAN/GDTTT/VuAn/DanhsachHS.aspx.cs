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

namespace WEB.GSTP.QLAN.GDTTT.VuAn
{
    public partial class DanhsachHS : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private const decimal ROOT = 0;

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
        String SessionInBC = "GDTTTVA_INBC_VISIBLE";
        String SessionSearch = "TTTKVISIBLE";
        Decimal CurrUserID = 0;
        MenuPermission oPer = null;

        protected void Page_Load(object sender, EventArgs e)
        {
            Decimal Loaian = Convert.ToDecimal(Session[SS_TK.LOAIAN]);
            //if (Loaian == 1)
            //{
                ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
                scriptManager.RegisterPostBackControl(this.cmdPrint);
            //}

            CurrUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrUserID > 0)
            {
                if (!IsPostBack)
                {
                    if ((Session[SessionSearch] + "") == "0")
                    {
                        lbtTTTK.Text = "[ Thu gọn ]";
                        pnTTTK.Visible = true;
                    }
                    //---------------------------
                    LoadDropBox();
                    SetGetSessionTK(false);
                    oPer = Cls_Comon.GetMenuPer(Request.FilePath, CurrUserID);
                    //Khong cho Load du lieu khi chua nhan tim kiem
                    //if (Session[SS_TK.NGUYENDON] != null)
                    //    Load_Data();
                }
            }
            else
                Response.Redirect("/Login.aspx");
        }
        private void SetGetSessionTK(bool isSet)
        {
            try
            {
                if (isSet)
                {
                    Session[SS_TK.TOAANXX] = ddlToaXetXu.SelectedValue;
                    Session[SS_TK.SOBAQD] = txtSoQDBA.Text;
                    Session[SS_TK.NGAYBAQD] = txtNgayBAQD.Text;
                    Session[SS_TK.NGUYENDON] = txtNguyendon.Text;
                    Session[SS_TK.BIDON] = txtBidon.Text;
                    Session[SS_TK.LOAIAN] = ddlLoaiAn.SelectedValue;
                    Session[SS_TK.THAMTRAVIEN] = ddlThamtravien.SelectedValue;
                    Session[SS_TK.LANHDAOPHUTRACH] = ddlPhoVuTruong.SelectedValue;
                    Session[SS_TK.THAMPHAN] = ddlThamphan.SelectedValue;
                    Session[SS_TK.THULY_TU] = txtTuNgay.Text;
                    Session[SS_TK.THULY_DEN] = txtDenNgay.Text;
                    Session[SS_TK.SOTHULY] = txtThuly_So.Text;
                    Session[SS_TK.MUONHOSO] = ddlMuonHoso.SelectedValue;
                    Session[SS_TK.TRANGTHAITHULY] = "0";
                    string vArrSelectID = "";
                    foreach (DataGridItem Item in dgList.Items)
                    {
                        CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                        if (chkChon != null)
                        {
                            if (chkChon.Checked)
                            {
                                if (vArrSelectID == "") vArrSelectID = chkChon.ToolTip;
                                else vArrSelectID = vArrSelectID + "," + chkChon.ToolTip;
                            }
                        }
                    }
                    if (vArrSelectID != "") vArrSelectID = "," + vArrSelectID + ",";
                    Session[SS_TK.ARRSELECTID] = vArrSelectID;
                }
                else
                {
                    int IsHome = (string.IsNullOrEmpty(Session[SS_TK.ISHOME] + "")) ? 0 : Convert.ToInt16(Session[SS_TK.ISHOME] + "");
                    if (IsHome == 1)
                    {
                        txtSoQDBA.Text = Session[SS_TK.SOBAQD] + "";
                        txtNgayBAQD.Text = Session[SS_TK.NGAYBAQD] + "";
                        if (Session[SS_TK.TOAANXX] != null) ddlToaXetXu.SelectedValue = Session[SS_TK.TOAANXX] + "";

                        txtNguyendon.Text = Session[SS_TK.NGUYENDON] + "";
                        txtBidon.Text = Session[SS_TK.BIDON] + "";
                        if (Session[SS_TK.LOAIAN] != null) ddlLoaiAn.SelectedValue = Session[SS_TK.LOAIAN] + "";
                        if (Session[SS_TK.THAMTRAVIEN] != null) ddlThamtravien.SelectedValue = Session[SS_TK.THAMTRAVIEN] + "";
                        if (Session[SS_TK.LANHDAOPHUTRACH] != null) ddlPhoVuTruong.SelectedValue = Session[SS_TK.LANHDAOPHUTRACH] + "";
                        if (Session[SS_TK.THAMPHAN] != null) ddlThamphan.SelectedValue = Session[SS_TK.THAMPHAN] + "";
                        // if (Session[SS_TK.QHPKLT] != null) ddlQHPLTK.SelectedValue = Session[SS_TK.QHPKLT] + "";
                        // if (Session[SS_TK.QHPLDN] != null) ddlQHPLDN.SelectedValue = Session[SS_TK.QHPLDN] + "";
                        // if (Session[SS_TK.TRALOIDON] != null) ddlTraloi.SelectedValue = Session[SS_TK.TRALOIDON] + "";

                        //  txtNguoiguidon.Text = Session[SS_TK.NGUOIGUI] + "";
                        //  txtCoquanchuyendon.Text = Session[SS_TK.COQUANCHUYENDON] + "";
                        //  if (Session[SS_TK.LOAICV] != null) ddlLoaiCV.SelectedValue = Session[SS_TK.LOAICV] + "";

                        txtTuNgay.Text = Session[SS_TK.THULY_TU] + "";
                        txtDenNgay.Text = Session[SS_TK.THULY_DEN] + "";
                        txtThuly_So.Text = Session[SS_TK.SOTHULY] + "";

                        if (Session[SS_TK.MUONHOSO] != null)
                            ddlMuonHoso.SelectedValue = Session[SS_TK.MUONHOSO] + "";
                    }
                }
            }
            catch (Exception ex) { }
        }

        private void LoadDropBox()
        {
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);

            DM_TOAAN_BL oTABL = new DM_TOAAN_BL();
            DataTable dtTA = oTABL.DM_TOAAN_GETBYNOTCUR(0, 0);
            ddlToaXetXu.DataSource = dtTA;
            ddlToaXetXu.DataTextField = "MA_TEN";
            ddlToaXetXu.DataValueField = "ID";
            ddlToaXetXu.DataBind();
            ddlToaXetXu.Items.Insert(0, new ListItem("--- Chọn --- ", "0"));

            try
            {
                LoadDropThamphan();
            }
            catch (Exception ex) { }
            //Lãnh đạo
            try
            {
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                if (oPer.DULIEU == true)
                    LoadDropLanhDao();
                else
                {
                    LoadAll_TTV();
                    Load_AllLanhDao();
                }
                
            } catch (Exception ex) { }

            //Loại án
            LoadDropLoaiAn();

            SetVisible_SearchDateTime();
        }
        void LoadDropLanhDao()
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
                if (oCD.MA == ENUM_CHUCVU.CHUCVU_PVT)
                {
                    ddlPhoVuTruong.Items.Clear();
                    ddlPhoVuTruong.Items.Add(new ListItem(oCB.HOTEN, oCB.ID.ToString()));

                    hddLoaiTK.Value = ENUM_CHUCVU.CHUCVU_PVT;
                    //----------------------
                    LoadDropTTV_TheoLanhDao();
                }
                else
                {
                    Load_AllLanhDao();
                    // 042 la Pho truong phong quyen nhu TTV 
                    if (oCD.MA == "TTV" || oCD.MA == "TTVCC" || oCD.MA == "TTVC"
                    || oCD.MA == "TK1" || oCD.MA == "TK" || oCD.MA == "TKA" || oCD.MA == "C027"
                    || oCD.MA == "C010" || oCD.MA == "C008" || oCD.MA == "C009" || oCD.MA == "042")
                    {
                        ddlThamtravien.Items.Clear();
                        ddlThamtravien.Items.Add(new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                        hddLoaiTK.Value = ENUM_CHUCDANH.CHUCDANH_TTV;
                    }
                    else LoadAll_TTV();
                }
            }
            else if (chucdanh_id > 0)
            {
                Load_AllLanhDao();

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
        void Load_AllLanhDao()
        {
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            Decimal LoginDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();

            //DataTable oTLDDT = oGDTBL.CANBO_GETBYDONVI_2CHUCVU(LoginDonViID, PBID, ENUM_CHUCVU.CHUCVU_PVT, ENUM_CHUCVU.CHUCVU_VT);
            DataTable tbl = oGDTBL.GDTTT_VuAn_GetAllCBTheoPB(LoginDonViID, PBID, "LDV");
            ddlPhoVuTruong.DataSource = tbl;
            ddlPhoVuTruong.DataTextField = "HOTEN";
            ddlPhoVuTruong.DataValueField = "ID";
            ddlPhoVuTruong.DataBind();
            ddlPhoVuTruong.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
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

        void LoadDropTTV_TheoLanhDao()
        {
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PhongBanID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            ddlThamtravien.Items.Clear();
            Decimal LanhDaoID = Convert.ToDecimal(ddlPhoVuTruong.SelectedValue);
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
        void LoadDropThamphan()
        {
            Decimal LoginDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            //Load Thẩm phán
            GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();
            Boolean IsLoadAll = false;
            ddlThamphan.Items.Clear();
            Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            try
            {
                DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).Single();
                if (oCB.CHUCDANHID != null && oCB.CHUCDANHID != 0)
                {
                    DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCDANHID).FirstOrDefault();
                    if (oCD.MA == "TPTATC")
                        ddlThamphan.Items.Add(new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                    else
                        IsLoadAll = true;
                }
                else
                    IsLoadAll = true;
            }
            catch (Exception ex) { IsLoadAll = true; }
            if (IsLoadAll)
            {
                //DataTable oCBDT = oGDTBL.CANBO_GETBYDONVI(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                DataTable tbl = oGDTBL.GDTTT_VuAn_GetAllCBTheoPB(LoginDonViID, PBID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                ddlThamphan.DataSource = tbl;
                ddlThamphan.DataTextField = "HOTEN";
                ddlThamphan.DataValueField = "ID";
                ddlThamphan.DataBind();
                ddlThamphan.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
            }
        }
        void LoadDropLoaiAn()
        {
            ddlLoaiAn.Items.Clear();
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            DM_PHONGBAN obj = dt.DM_PHONGBAN.Where(x => x.ID == PBID).FirstOrDefault() ?? new DM_PHONGBAN();
                if (obj.ISHINHSU == 1)
                {
                    ddlLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
                    lblTitleBC.Text = "Bị cáo";
                    lblTitleBD.Visible = txtBidon.Visible = false;
                }
                else
                {
                    lblTitleBC.Text = "Nguyên đơn";
                    lblTitleBD.Visible = txtBidon.Visible = true;
                }
                if (obj.ISDANSU == 1) ddlLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
                if (obj.ISHANHCHINH == 1) ddlLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
                if (obj.ISHNGD == 1) ddlLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
                if (obj.ISKDTM == 1) ddlLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
                if (obj.ISLAODONG == 1) ddlLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
                if (obj.ISPHASAN == 1) ddlLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC.AN_PHASAN));
                if (ddlLoaiAn.Items.Count > 1 && obj.ISHINHSU != 1)
                    ddlLoaiAn.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
        }

        protected void btnThemmoi_Click(object sender, EventArgs e)
        {
            SetGetSessionTK(true);
            Response.Redirect("Thongtinvuan.aspx?type=new");

        }
        //-----------------------------------------
        private void Load_Data()
        {
            lbtthongbao.Text = "";
            lbTFirst.Visible = ddlPageCount.Visible = lbBFirst.Visible = ddlPageCount2.Visible = true;

            int page_size = Convert.ToInt32(ddlPageCount.SelectedValue);
            int pageindex = Convert.ToInt32(hddPageIndex.Value);
            DataTable oDT = getDS(page_size, pageindex);
            int count_all = 0;
            if (oDT.Rows.Count > 0)
                count_all = Convert.ToInt32(oDT.Rows[0]["CountAll"] + "");
            if (oDT != null && count_all > 0)
            {
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, Convert.ToInt32(ddlPageCount.SelectedValue)).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString("#,#", cul) + " </b> vụ án trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
                cmdPrintPhieuMuon.Visible = true;
            }
            else
            {
                hddTotalPage.Value = "1";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                           lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                lstSobanghiT.Text = lstSobanghiB.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";
                cmdPrintPhieuMuon.Visible = false;
            }
            if (ddlLoaiAn.SelectedValue == ENUM_LOAIVUVIEC.AN_HINHSU)
            {
                gridHS.PageSize = Convert.ToInt32(ddlPageCount.SelectedValue);
                gridHS.DataSource = oDT;
                gridHS.DataBind();
                gridHS.Visible = true;
                dgList.Visible = false; 
                lblTitleBC.Text = "Bị cáo";
                lblTitleBD.Visible = txtBidon.Visible = false;
            }
            else
            {
                dgList.PageSize = Convert.ToInt32(ddlPageCount.SelectedValue);
                dgList.DataSource = oDT;
                dgList.DataBind();
                dgList.Visible = true; gridHS.Visible = false;
                lblTitleBC.Text = "Nguyên đơn";
                lblTitleBD.Visible = txtBidon.Visible = true;
            }
        }
        private DataTable getDS(int page_size, int pageindex)
        {
            decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            GDTTT_VUAN_BL oBL = new GDTTT_VUAN_BL();
            decimal vToaRaBAQD = Convert.ToDecimal(ddlToaXetXu.SelectedValue);
            string vSoBAQD = txtSoQDBA.Text.Trim(), vNgayBAQD = txtNgayBAQD.Text;
            string vNguyendon = txtNguyendon.Text;
            string vBidon = txtBidon.Text;
            decimal vLoaiAn = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
            decimal vThamtravien = Convert.ToDecimal(ddlThamtravien.SelectedValue);
            decimal vLanhdao = Convert.ToDecimal(ddlPhoVuTruong.SelectedValue);
            decimal vThamphan = Convert.ToDecimal(ddlThamphan.SelectedValue);
            DateTime? hs_tungay = txtTuNgay.Text == "" ? (DateTime?)null : DateTime.Parse(txtTuNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime? hs_denngay = txtDenNgay.Text == "" ? (DateTime?)null : DateTime.Parse(txtDenNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            string vSoThuly = txtThuly_So.Text;

            decimal vKetquathuly = Convert.ToDecimal(ddlKetquaThuLy.SelectedValue);

            int isMuonHoSo = Convert.ToInt16(ddlMuonHoso.SelectedValue);
            
            decimal vSophieunhan = (string.IsNullOrEmpty((txtSophieunhan.Text + "")) ? 0 : Convert.ToDecimal((txtSophieunhan.Text)));
            string vLoaiphieu = ddlLoaiphieu.SelectedValue;
            //anhvh phân quyên liên quan đến án tử hình
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            decimal _ISXINANGIAM = Convert.ToDecimal(oPer.ISXINANGIAM);
            decimal _GDT_ISXINANGIAM = Convert.ToDecimal(oPer.GDT_ISXINANGIAM);
            //--------------
            DataTable oDT = oBL.QLHOSO_VUAN_SEARCH(vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD
                , vNguyendon, vBidon, vLoaiAn
                , vThamtravien, vLanhdao, vThamphan, vSophieunhan
                , hs_tungay, hs_denngay, vSoThuly
                , vKetquathuly
                , isMuonHoSo
                , vLoaiphieu, _ISXINANGIAM,_GDT_ISXINANGIAM
                , pageindex, page_size);
            return oDT;
        }

        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
            SetGetSessionTK(true);
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            switch (e.CommandName)
            {
                case "QLHS":
                    string StrQLHS = "PopupReport('/QLAN/GDTTT/VuAn/Popup/QLHoso.aspx?vid=" + e.CommandArgument + "','Quản lý mượn trả hồ sơ',1000,600);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrQLHS, true);
                    break;

                //case "KETQUA":
                //    string StrKetqua = "PopupReport('/QLAN/GDTTT/VuAn/Popup/Ketqua.aspx?vid=" + e.CommandArgument + "','Kết quả giải quyết',850,500);";
                //    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrKetqua, true);
                //    break;
                case "SoDonTrung":
                    string StrMsgArr = "PopupReport('/QLAN/GDTTT/VuAn/Popup/pDsDon.aspx?type=dt&vID=" + e.Item.Cells[0].Text + "','Danh sách đơn trùng',1000,500);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsgArr, true);
                    break;
                case "CongVan81":
                    string StrMsgArr81 = "PopupReport('/QLAN/GDTTT/VuAn/Popup/DSDonQuocHoi.aspx?vID=" + e.Item.Cells[0].Text + "&arrid=" + e.CommandArgument + "','Danh sách công văn 8.1',1000,500);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsgArr81, true);
                    break;
                case "CHIDAO":
                    string StrMsgChidao = "PopupReport('/QLAN/GDTTT/VuAn/Popup/DSDonChidao.aspx?vID=" + e.Item.Cells[0].Text + "&arrid=" + e.CommandArgument + "','Danh sách công văn 8.1',1000,500);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsgChidao, true);
                    break;
            }
        }

        decimal trangthai_trinh_id = 0;
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rv = (DataRowView)e.Item.DataItem;
                Decimal CurrVuAnID = Convert.ToDecimal(rv["ID"] + "");
                LinkButton cmdQLHoSo = (LinkButton)e.Item.FindControl("cmdQLHoSo");
                oPer = Cls_Comon.GetMenuPer(Request.FilePath, CurrUserID);
                Cls_Comon.SetLinkButton(cmdQLHoSo, oPer.TAOMOI);

                trangthai_trinh_id = 0;
                Literal lttLanTT = (Literal)e.Item.FindControl("lttLanTT");
                Literal lttDetaiTinhTrang = (Literal)e.Item.FindControl("lttDetaiTinhTrang");

                decimal KQ_GQD_ID = String.IsNullOrEmpty(rv["KQ_GQD_ID"] + "") ? 0 : Convert.ToInt32(rv["KQ_GQD_ID"] + "");
                int trangthai = String.IsNullOrEmpty(rv["TRANGTHAIID"] + "") ? 0 : Convert.ToInt32(rv["TRANGTHAIID"] + "");
                int GiaiDoanTrinh = String.IsNullOrEmpty(rv["GiaiDoanTrinh"] + "") ? 0 : Convert.ToInt32(rv["GiaiDoanTrinh"] + "");

                lttLanTT.Text = rv["TENTINHTRANG"] + "";
                if (trangthai != ENUM_GDTTT_TRANGTHAI.PHANCONG_TTV && GiaiDoanTrinh == 2)
                {
                    #region Thông tin lien quan den To trinh
                    try
                    {
                        trangthai_trinh_id = Convert.ToDecimal(trangthai);
                        List<GDTTT_TOTRINH> lstTT = dt.GDTTT_TOTRINH.Where(x => x.VUANID == CurrVuAnID
                                                          && x.TINHTRANGID == trangthai_trinh_id).OrderByDescending(y => y.NGAYTRINH).ToList();
                        if (lstTT != null && lstTT.Count > 0)
                        {
                            lttLanTT.Text += " lần " + lstTT.Count.ToString();
                            GDTTT_TOTRINH objTT = lstTT[0];
                            if (!string.IsNullOrEmpty(objTT.NGAYTRINH + "") || (DateTime)objTT.NGAYTRINH != DateTime.MinValue)
                                lttDetaiTinhTrang.Text = "<br/>Ngày trình: " + Convert.ToDateTime(objTT.NGAYTRINH).ToString("dd/MM/yyyy", cul);
                            if (!string.IsNullOrEmpty(objTT.NGAYTRA + "") || (DateTime)objTT.NGAYTRA != DateTime.MinValue)
                                lttDetaiTinhTrang.Text += "<br/><span style='margin-right:10px;'>Ngày trả: " + Convert.ToDateTime(objTT.NGAYTRA).ToString("dd/MM/yyyy", cul) + "</span>";

                            lttDetaiTinhTrang.Text += (string.IsNullOrEmpty(lttDetaiTinhTrang.Text)) ? "" : "<br/>";
                            lttDetaiTinhTrang.Text += objTT.YKIEN + "";
                        }
                    }
                    catch (Exception ex) { }
                    #endregion
                }
                else
                {
                    if (trangthai == (int)ENUM_GDTTT_TRANGTHAI.PHANCONG_TTV)
                    {
                        //hien ngay phan cong + qua trinh_ghi chu (GDTTT_VuAn)                       
                        lttDetaiTinhTrang.Text = (string.IsNullOrEmpty(rv["NGAYPHANCONGTTV"] + "") ? "" : (rv["NGAYPHANCONGTTV"].ToString() + "<br/>"))
                                                    + rv["QUATRINH_GHICHU"] + "";
                        lttDetaiTinhTrang.Text += (string.IsNullOrEmpty(rv["GQD_NGAYPHATHANHCV"] + "") || rv["GQD_NGAYPHATHANHCV"].ToString() == "01/01/0001") ? "" : "<br/>Ngày phát hành:" + rv["GQD_NGAYPHATHANHCV"].ToString();

                    }
                    else if (GiaiDoanTrinh == 3 && trangthai != 15)
                    {
                        int loai_giaiquyet_don = (string.IsNullOrEmpty(rv["KQ_GQD_ID"] + "")) ? 5 : Convert.ToInt16(rv["KQ_GQD_ID"] + "");
                        if (loai_giaiquyet_don <= 2)
                        {
                            String temp = "";
                            int loaian = String.IsNullOrEmpty(rv["LoaiAN"] + "") ? 0 : Convert.ToInt16(rv["LoaiAN"] + "");
                            if (loaian == Convert.ToInt16(ENUM_LOAIVUVIEC.AN_HINHSU))
                            {
                                lttLanTT.Text = "<b>" + rv["KQ_GQD"] + " " + rv["LoaiKN"].ToString() + " </b>";
                                if (loai_giaiquyet_don == 0)
                                    lttDetaiTinhTrang.Text = rv["AHS_THONGTINGQD"] + "";
                                else
                                {
                                    temp = String.IsNullOrEmpty(rv["GDQ_SO"] + "") ? "" : ("<span style=''>Số: <b>" + rv["GDQ_SO"].ToString() + "</b></span>");
                                    temp += (String.IsNullOrEmpty(temp) ? "" : (string.IsNullOrEmpty(rv["GDQ_NGAY"] + "")) ? "" : ("<br/>Ngày: <b>" + rv["GDQ_NGAY"].ToString() + "</b>"));
                                    temp += (string.IsNullOrEmpty(rv["GQD_NGAYPHATHANHCV"] + "") || rv["GQD_NGAYPHATHANHCV"].ToString() == "01/01/0001") ? "" : "<br/>Ngày phát hành:" + rv["GQD_NGAYPHATHANHCV"].ToString();

                                    lttDetaiTinhTrang.Text = temp;
                                }
                            }
                            else
                            {
                                lttLanTT.Text = "<b>" + rv["KQ_GQD"] + " " + rv["LoaiKN"].ToString() + " </b>";
                                temp = String.IsNullOrEmpty(rv["GDQ_SO"] + "") ? "" : ("<span style=''>Số: <b>" + rv["GDQ_SO"].ToString() + "</b></span>");
                                temp += (String.IsNullOrEmpty(temp) ? "" : (string.IsNullOrEmpty(rv["GDQ_NGAY"] + "")) ? "" : ("<br/>Ngày: <b>" + rv["GDQ_NGAY"].ToString() + "</b>"));
                                temp += (string.IsNullOrEmpty(rv["GQD_NGAYPHATHANHCV"] + "") || rv["GQD_NGAYPHATHANHCV"].ToString() == "01/01/0001") ? "" : "<br/>Ngày phát hành:" + rv["GQD_NGAYPHATHANHCV"].ToString();

                                lttDetaiTinhTrang.Text = temp;
                            }
                        }
                        else if (loai_giaiquyet_don == 4)
                            lttLanTT.Text = "<b>Thông báo VKS " + " </b><br/>" + rv["KQ_GQD"];
                        else
                            lttLanTT.Text = "<b>KQGQ_THS: " + " </b>" + rv["KQ_GQD"];
                    }
                    else if (trangthai == 15)
                    {
                        lttDetaiTinhTrang.Text = String.IsNullOrEmpty(rv["SOTHULYXXGDT"] + "") ? "" : ("<span style='padding-right:10px;'>Số: <b>" + rv["SOTHULYXXGDT"].ToString() + "</b></span>");
                        lttDetaiTinhTrang.Text += (string.IsNullOrEmpty(rv["NGAYTHULYXXGDT"] + "")) ? "" : ("Ngày: <b>" + rv["NGAYTHULYXXGDT"].ToString() + "</b>");

                    }
                }

                //-------------------------------
                Literal lttKQGQ = (Literal)e.Item.FindControl("lttKQGQ");
                int IsHoanTHA = Convert.ToInt16(rv["GQD_ISHOANTHA"] + "");
                if (IsHoanTHA > 0)
                {
                    lttKQGQ.Text = "<span class='line_space'>";
                    lttKQGQ.Text += "<b>Hoãn thi hành án</b>" + "<br/>";
                    lttKQGQ.Text += "Số: " + rv["GQD_HOANTHA_SO"].ToString() + "<br/>";
                    lttKQGQ.Text += "Ngày: " + rv["GQD_HOANTHA_NGAY"].ToString() + "<br/>";
                    lttKQGQ.Text += "";
                    lttKQGQ.Text += "</span>";
                }
                //---------------------------
                Literal lttOther = (Literal)e.Item.FindControl("lttOther");
                int soluong = String.IsNullOrEmpty(rv["IsHoSo"] + "") ? 0 : Convert.ToInt32(rv["IsHoSo"] + "");
                string NgayTTVNhanHS = rv["NGAYTTVNHANHS"] + "";
                string NgayMuonHS = rv["NGAYMUONHS"] + "";
                string NgayNhanHS = rv["NGAYNHANHS"] + "";
                // lttOther.Text = "<div class='line_space'><b>" + ((soluong > 0) ? "Đã có hồ sơ" : "Chưa có hồ sơ") + "</b></div>";
                //lttOther.Text = "<div class='line_space'><b>" + ((soluong > 0) ? "Đã có hồ sơ" + (string.IsNullOrEmpty(NgayNhanHS) ? "" : " (" + NgayNhanHS + ")") : "") + "</b></div>";
                //lttOther.Text = ((soluong > 0) ? "Đã có hồ sơ" + (string.IsNullOrEmpty(NgayTTVNhanHS) ? "" : "(" + NgayTTVNhanHS + ")") : (string.IsNullOrEmpty(NgayMuonHS) ? "" : "Phiếu mượn " + NgayMuonHS) ) + "</b></div>";
                lttOther.Text = ((soluong > 0) ? "Đã có hồ sơ " + (string.IsNullOrEmpty(NgayNhanHS) ? "" : " (" + NgayNhanHS + ") ") : (string.IsNullOrEmpty(NgayMuonHS) ? "" : "Phiếu mượn " + NgayMuonHS)) + "</b></div>";

            }
        }

        #region "Phân trang"

        protected void lbTBack_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
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

        protected void lbtTTTK_Click(object sender, EventArgs e)
        {
            if (pnTTTK.Visible == false)
            {
                lbtTTTK.Text = "[ Thu gọn ]";
                pnTTTK.Visible = true;
                Session[SessionSearch] = "0";
            }
            else
            {
                lbtTTTK.Text = "[ Nâng cao ]";
                pnTTTK.Visible = false;
                Session[SessionSearch] = "1";
            }
        }

        protected void cmdLammoi_Click(object sender, EventArgs e)
        {
            txtSoQDBA.Text = "";
            txtNgayBAQD.Text = "";
            ddlToaXetXu.SelectedIndex = 0;
            txtNguyendon.Text = "";
            txtBidon.Text = "";
            ddlLoaiAn.SelectedIndex = 0;

            ddlThamtravien.SelectedIndex = 0;
            ddlPhoVuTruong.SelectedIndex = 0;
            ddlThamphan.SelectedIndex = 0;
            txtThuly_So.Text = "";

            ddlKetquaThuLy.SelectedIndex = 0;
        }
        //---------------------------------      
        protected void cmdPrintPhieuMuon_Click(object sender, EventArgs e)
        {
            string link = "/QLAN/GDTTT/VuAn/Popup/PhieuMuon.aspx";
            String openpopup = "", listitem = "";
            foreach (DataGridItem item in dgList.Items)
            {
                CheckBox chkMuon = (CheckBox)item.FindControl("chkMuon");
                HiddenField hddVuAnID = (HiddenField)item.FindControl("hddVuAnID");
                if (chkMuon.Checked)
                    listitem += (string.IsNullOrEmpty(listitem + "")) ? hddVuAnID.Value : ("_" + hddVuAnID.Value);
            }
            if (!string.IsNullOrEmpty(listitem))
            {
                openpopup = "PopupReport('" + link + "?item=" + listitem + "','Phiếu mượn',1000,600)";
                Cls_Comon.CallFunctionJS(this, this.GetType(), openpopup);
            }
            else Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Bạn chưa chọn vụ án để tạo phiếu mượn!");
        }

        protected void ddlMuonHoso_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
            SetVisible_SearchDateTime();

            if (ddlMuonHoso.SelectedValue == "1")
                ddlLoaiphieu.SelectedValue = "3";
            else if (ddlMuonHoso.SelectedValue == "3")
                ddlLoaiphieu.SelectedValue = "0";
            else
                ddlLoaiphieu.SelectedValue = "";
        }
        protected void ddlLoaiAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
            Load_Data();
        }

        protected void ddlPhoVuTruong_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
        }

        protected void ddlThamtravien_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
        }
        protected void ddlThamphan_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
        }
        protected void ddlKetquaThuLy_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
        }

        protected void ddlLoaiphieu_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(ddlLoaiphieu.SelectedValue)) 
            {
                if ((ddlLoaiphieu.SelectedValue == "0" || ddlLoaiphieu.SelectedValue == "3"))
                {
                    txtSophieunhan.Enabled = txtTuNgay.Enabled = txtDenNgay.Enabled = true;
                }
                else
                    txtSophieunhan.Enabled = txtTuNgay.Enabled = txtDenNgay.Enabled = false;
            
            }
            else
                txtSophieunhan.Enabled = txtTuNgay.Enabled = txtDenNgay.Enabled = false;

        }
        void SetVisible_SearchDateTime()
        {
            string trangthai = ddlMuonHoso.SelectedValue;
            if (trangthai == "1" || trangthai == "3")
            {
                txtTuNgay.Enabled = txtDenNgay.Enabled = txtSophieunhan.Enabled = true;
            }
            else if (trangthai == "0"|| trangthai == "4")
            {
                txtTuNgay.Enabled = txtSophieunhan.Enabled = false;
                txtDenNgay.Enabled = false;
                txtTuNgay.Text = txtDenNgay.Text = txtSophieunhan.Text = "";
            }
            else
            {
                txtTuNgay.Text = txtDenNgay.Text = txtSophieunhan.Text = "";
                txtTuNgay.Enabled = txtDenNgay.Enabled = txtSophieunhan.Enabled = false;
            }
        }
        //---------------------------------
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
        protected void cmdPrint_Click(object sender, EventArgs e)
        {
            SetGetSessionTK(true);
            String SessionName = "GDTTT_ReportPL".ToUpper();
            //--------------------------
            //String ReportName = "";
            //if (String.IsNullOrEmpty(txtTieuDeBC.Text))
            //    SetTieuDeBaoCao();
            Decimal Loaian =Convert.ToDecimal(Session[SS_TK.LOAIAN]);
            if (Loaian == 1)
            {
                DataTable tbl = getDS(30000, 1);
                LoadReportHS(tbl);
            }
            else
            {
                DataTable tbl = getDS(30000, 1);
                LoadReport(tbl);
            }
            //}
            //else
            //{
            //    ReportName = txtTieuDeBC.Text.Trim();
            //    Session[SS_TK.TENBAOCAO] = ReportName.ToUpper();
            //    String Parameter = "type=va&rID=" + dropMauBC.SelectedValue;
            //    DataTable tbl = getDS(30000, 1);
            //    Session[SessionName] = tbl;
            //    string URL = "/QLAN/GDTTT/VuAn/BaoCao/ViewBC.aspx" + (string.IsNullOrEmpty(Parameter) ? "" : "?" + Parameter);
            //    Cls_Comon.CallFunctionJS(this, this.GetType(), "PopupReport('" + URL + "','In báo cáo',1000,600)");
            //}
           
        }
        private void LoadReport(DataTable tbl)
        { 
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            Int32 PBID = strPBID == "" ? 0 : Convert.ToInt32(strPBID);
            object Result = new object();
            
            Literal Table_Str_Totals = new Literal();

            //-------------------------- String.IsNullOrEmpty(row["HS_TenToiDanh"] + "") ? "" : "
            String ReportName = txtTieuDeBC.Text.Trim().ToUpper();
         
            foreach (DataRow row in tbl.Rows)
            {
                
                Table_Str_Totals.Text += "<tr style=\"font-size: 11pt;\">"
                   + "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;\">" + row["STT"] + "</td>"
                   + "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;\">" + row["SOANPHUCTHAM"] + "<br/>" + row["NGAYXUPHUCTHAM"] + "</td>"
                   + "<td style=\"text-align: left; vertical-align: middle; border: 0.1pt solid #000000;\">" + row["TOAXX_VietTat"] + "</td>"
                   + "<td style=\"text-align: left; vertical-align: middle; border: 0.1pt solid #000000;\">" + row["NGUYENDON"] + "</td>"
                    + "<td style=\"text-align: left; vertical-align: middle; border: 0.1pt solid #000000;\">" + row["BIDON"] + "</td>"
                   + "<td style=\"text-align: left; vertical-align: middle; border: 0.1pt solid #000000;\">" + row["QHPLDN"] + "</td>"
                   + "<td style=\"text-align: left; vertical-align: middle; border: 0.1pt solid #000000;\">" + row["TENTHAMTRAVIEN"] + " </td>";
                Table_Str_Totals.Text += "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;\">";

                Table_Str_Totals.Text += String.IsNullOrEmpty(row["NgayMuonHS"] + "") ? "" : row["NgayMuonHS"] + "</td>";

                Table_Str_Totals.Text += "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;\">";

                Table_Str_Totals.Text += String.IsNullOrEmpty(row["NgayNhanHS"] + "") ? "" : row["NgayNhanHS"] + "</td>";

                Table_Str_Totals.Text += "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;\"></td>"
                    + "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;\"></td>" +
                    "</ tr > ";
               

            }
            string loaitoa = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
            if (loaitoa.Contains("cấp cao"))
            {
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=BC_DONDN_GDTTT_THULY_VU_GDKT.xls");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/vnd.xls";
                HttpContext.Current.Response.ContentEncoding = System.Text.UnicodeEncoding.UTF8;
                Response.Write("<html");
                Response.Write("<head>");
                Response.Write("<!--[if gte mso 9]> <xml> <w:WordDocument> <w:View>Print</w:View> <w:Zoom>100</w:Zoom> <w:DoNotOptimizeForBrowser/> </w:WordDocument> </xml> <![endif]-->");
                Response.Write("<META HTTP-EQUIV=Content-Type CONTENT=text/html; charset=UTF-8>");
                Response.Write("<meta name=ProgId content=Word.Document>");
                Response.Write("<meta name=Generator content=Microsoft Word 9>");
                Response.Write("<meta name=Originator content=Microsoft Word 9>");
                Response.Write("<style>");
                Response.Write("<!-- /* Style Definitions */" +
                                              "p.MsoFooter, li.MsoFooter, div.MsoFooter" +
                                              "{margin:0in;" +
                                              "margin-bottom:.0001pt;" +
                                              "mso-pagination:widow-orphan;" +
                                              "tab-stops:center 3.0in right 6.0in;" +
                                              "font-size:12.0pt;}");

                Response.Write("@page Section1 {size:595.45pt 841.7pt; margin:0.7874015748in 0.5905511811in 0.7086614173in 1.18in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");
                Response.Write("div.Section1 {page:Section1;}");
                //Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:1.25in 1.0in 1.25in 1.0in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");         
                Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5in 1.0in 0.5in 1.0in;mso-header: h1;mso-header-margin:.0in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
                //Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5in 1.0in 0.5in 1.0in;mso-header-margin:.1in;mso-footer-margin:.1in;mso-paper-source:0;}");
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

                htmlWrite.WriteLine("<tr style=\"vertical - align:top;\"><td colspan=\"11\"></td></tr>");
                htmlWrite.WriteLine("<tr style=\"vertical-align:top;\">" +

                                        "<td class=\"cs1EF4761A\" colspan=\"10\" style=\"width:1032px;height:24px;line-height:18px;font-size:14pt;margin-top:24px;text-align:center;vertical-align:middle;\"><br>" +
                                        ReportName + "</br></td>" +
                                    "</tr>");
                htmlWrite.WriteLine("<tr style=\"vertical - align:top;\"><td colspan=\"11\"></td></tr>");

                htmlWrite.WriteLine("<tr style=\"vertical - align:top;\">" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-weight:bold;\">STT</nobr></td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Bản án<br/>Số & Ngày</td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Tòa xét xử</td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Nguyên đơn/<br/>Người khởi kiện</td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Bị đơn/<br/>Người bị kiện</td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Quan hệ pháp luật</td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Thẩm tra viên</td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Ngày mượn<br/>Hồ sơ</td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Ngày nhận<br/>Hồ sơ</td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Ghi chú</td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Ký nhận</td>" +
                                     "</tr>");

                Table_Str_Totals.Text += "<tr style=\"height: 1pt;\">" +
                                      "<td style = \"width:20pt;\"></td>" +
                                      "<td style = \"width:80pt;\" ></td >" +
                                      "<td style = \"width:80pt;\"></td >" +
                                      "<td style = \"width:80pt;\" ></td >" +
                                      "<td style = \"width:80pt;\" ></td >" +
                                      "<td style = \"width:120pt;\" ></td >" +
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
            else
            {
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=BC_DONDN_GDTTT_THULY_VU_GDKT.doc");
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
                Response.Write("<!-- /* Style Definitions */" +
                                              "p.MsoFooter, li.MsoFooter, div.MsoFooter" +
                                              "{margin:0in;" +
                                              "margin-bottom:.0001pt;" +
                                              "mso-pagination:widow-orphan;" +
                                              "tab-stops:center 3.0in right 6.0in;" +
                                              "font-size:12.0pt;}");

                Response.Write("@page Section1 {size:595.45pt 841.7pt; margin:0.7874015748in 0.5905511811in 0.7086614173in 1.18in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");
                Response.Write("div.Section1 {page:Section1;}");
                //Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:1.25in 1.0in 1.25in 1.0in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");         
                Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5in 1.0in 0.5in 1.0in;mso-header: h1;mso-header-margin:.0in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
                //Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5in 1.0in 0.5in 1.0in;mso-header-margin:.1in;mso-footer-margin:.1in;mso-paper-source:0;}");
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
                                        "<td class=\"cs1EF4761A\" colspan=\"10\" style=\"width:1032px;height:24px;line-height:18px;font-size:18pt;margin-top:24px;text-align:center;vertical-align:middle;\"><nobr>" +
                                        ReportName + "</nobr></td>" +
                                    "</tr>");
                htmlWrite.WriteLine("<tr style=\"vertical - align:top;\"><td colspan=\"11\"></td></tr>");

                htmlWrite.WriteLine("<tr style=\"vertical - align:top;\">" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-weight:bold;\">STT</nobr></td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Bản án<br/>Số & Ngày</td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Tòa xét xử</td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Nguyên đơn/<br/>Người khởi kiện</td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Bị đơn/<br/>Người bị kiện</td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Quan hệ pháp luật</td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Thẩm tra viên</td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Ngày mượn<br/>Hồ sơ</td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Ngày nhận<br/>Hồ sơ</td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Ghi chú</td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Ký nhận</td>" +
                                     "</tr>");

                Table_Str_Totals.Text += "<tr style=\"height: 1pt;\">" +
                                      "<td style = \"width:20pt;\"></td>" +
                                      "<td style = \"width:80pt;\" ></td >" +
                                      "<td style = \"width:80pt;\"></td >" +
                                      "<td style = \"width:80pt;\" ></td >" +
                                      "<td style = \"width:80pt;\" ></td >" +
                                      "<td style = \"width:120pt;\" ></td >" +
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

            
        }
        private void LoadReportHS(DataTable tbl)
        {
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            Int32 PBID = strPBID == "" ? 0 : Convert.ToInt32(strPBID);
            object Result = new object();

            Literal Table_Str_Totals = new Literal();

            //-------------------------- String.IsNullOrEmpty(row["HS_TenToiDanh"] + "") ? "" : "
            String ReportName = txtTieuDeBC.Text.Trim().ToUpper();

            foreach (DataRow row in tbl.Rows)
            {

                
                Table_Str_Totals.Text += "<tr style=\"font-size: 11pt;\">"
                   + "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;\">" + row["STT"] + "</td>"
                   + "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;\">" + row["SOANPHUCTHAM"] + "<br/>" + row["NGAYXUPHUCTHAM"] + "</td>"
                   + "<td style=\"text-align: left; vertical-align: middle; border: 0.1pt solid #000000;\">" + row["TOAXX_VietTat"] + "</td>"
                   + "<td style=\"text-align: left; vertical-align: middle; border: 0.1pt solid #000000;\">" + row["QHPLDN"] + "</td>"
                   + "<td style=\"text-align: left; vertical-align: middle; border: 0.1pt solid #000000;\">" + row["NGUYENDON"] + "(Đầu vụ)<br>" + row["BIDON"] + "</td>"
                   + "<td style=\"text-align: left; vertical-align: middle; border: 0.1pt solid #000000;\">" + row["TENTHAMTRAVIEN"] + " </td>";
                Table_Str_Totals.Text += "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;\">";

                Table_Str_Totals.Text += String.IsNullOrEmpty(row["NgayMuonHS"] + "") ? "" : row["NgayMuonHS"] + "</td>";

                Table_Str_Totals.Text += "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;\">";

                Table_Str_Totals.Text += String.IsNullOrEmpty(row["NgayNhanHS"] + "") ? "" : row["NgayNhanHS"] + "</td>";

                Table_Str_Totals.Text += "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;\"></td>"
                    + "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;\"></td>" +
                    "</ tr > ";

            }
            string loaitoa = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
            if (loaitoa.Contains("cấp cao"))
            {
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=BC_GQ_DONDN_GDTTT.xls");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/vnd.xls";
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
                Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5in 1.0in 0.5in 1.0in;mso-header-margin:.1in;mso-footer-margin:.1in;mso-paper-source:0;}");
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
                htmlWrite.WriteLine("<tr style=\"vertical - align:top;\"><td colspan=\"11\"></td></tr>");
                htmlWrite.WriteLine("<tr style=\"vertical-align:top;\">" +
                                       
                                        "<td class=\"cs1EF4761A\" colspan=\"10\" style=\"width:1032px;height:24px;line-height:18px;font-size:14pt;margin-top:24px;text-align:center;vertical-align:middle;\"><br>" +
                                        ReportName + "</br></td>" +
                                    "</tr>");
                htmlWrite.WriteLine("<tr style=\"vertical - align:top;\"><td colspan=\"11\"></td></tr>");


                htmlWrite.WriteLine("<tr style=\"vertical - align:top;\">" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-weight:bold;\">STT</td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Bản án<br/>Số & Ngày</td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Tòa xét xử</td>" +
                                        "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Tội danh</td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Bị cáo</td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Thẩm tra viên</td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Ngày mượn<br/>Hồ sơ</td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Ngày nhận<br/>Hồ sơ</td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Ghi chú</td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Ký nhận</td>" +
                                     "</tr>");

                Table_Str_Totals.Text += "<tr style=\"height: 1pt;\">" +
                                      "<td style = \"width:20pt;\"></td>" +
                                      "<td style = \"width:80pt;\" ></td >" +
                                      "<td style = \"width:80pt;\"></td >" +
                                      "<td style = \"width:80pt;\" ></td >" +
                                      "<td style = \"width:80pt;\" ></td >" +
                                      "<td style = \"width:120pt;\" ></td >" +
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
            else
            {
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=BC_GQ_DONDN_GDTTT.doc");
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
                Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5in 1.0in 0.5in 1.0in;mso-header-margin:.1in;mso-footer-margin:.1in;mso-paper-source:0;}");
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
                                        "<td class=\"cs1EF4761A\" colspan=\"10\" style=\"width:1032px;height:24px;line-height:18px;font-size:18pt;margin-top:24px;text-align:center;vertical-align:middle;\"><nobr>" +
                                        ReportName + "</nobr></td>" +
                                    "</tr>");
                htmlWrite.WriteLine("<tr style=\"vertical - align:top;\"><td colspan=\"11\"></td></tr>");


                htmlWrite.WriteLine("<tr style=\"vertical - align:top;\">" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-weight:bold;\">STT</td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Bản án<br/>Số & Ngày</td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Tòa xét xử</td>" +
                                        "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Tội danh</td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Bị cáo</td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Thẩm tra viên</td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Ngày mượn<br/>Hồ sơ</td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Ngày nhận<br/>Hồ sơ</td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Ghi chú</td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Ký nhận</td>" +
                                     "</tr>");

                Table_Str_Totals.Text += "<tr style=\"height: 1pt;\">" +
                                      "<td style = \"width:20pt;\"></td>" +
                                      "<td style = \"width:80pt;\" ></td >" +
                                      "<td style = \"width:80pt;\"></td >" +
                                      "<td style = \"width:80pt;\" ></td >" +
                                      "<td style = \"width:80pt;\" ></td >" +
                                      "<td style = \"width:120pt;\" ></td >" +
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

            
        }

        void SetTieuDeBaoCao()
        {
            string tieudebc = "";
            //-------------------------------------
            if (ddlLoaiAn.SelectedValue != "0")
                tieudebc += " " + ddlLoaiAn.SelectedItem.Text.ToLower();

            String canbophutrach = "";
            if (ddlPhoVuTruong.SelectedValue != "0")
                canbophutrach += ((string.IsNullOrEmpty(canbophutrach)) ? "" : ", ") + "lãnh đạo Vụ " + ddlPhoVuTruong.SelectedItem.Text;

            if (ddlThamphan.SelectedValue != "0")
            {
                canbophutrach += (string.IsNullOrEmpty(canbophutrach)) ? "" : ", ";
                canbophutrach = "thẩm phán " + Cls_Comon.FormatTenRieng(ddlThamphan.SelectedItem.Text);
            }

            if (!String.IsNullOrEmpty(canbophutrach))
                canbophutrach += " phụ trách";

            tieudebc += (string.IsNullOrEmpty(canbophutrach)) ? "" : " do " + canbophutrach;
            //-------------------------------------
            if (ddlMuonHoso.SelectedValue != "2")
            {
                if (ddlMuonHoso.SelectedValue == "3")
                    tieudebc += " chưa có Hồ sơ và " + ddlMuonHoso.SelectedItem.Text.ToLower();
                else if (ddlMuonHoso.SelectedValue == "4")
                    tieudebc += " chưa có Hồ sơ và " + ddlMuonHoso.SelectedItem.Text.ToLower();
                else
                    tieudebc += " " + ddlMuonHoso.SelectedItem.Text.ToLower();

                
            }
            if (txtDenNgay.Text.Trim() != "")
                tieudebc += " đến ngày " + txtDenNgay.Text.Trim();
            //--------------------------------------
            if (ddlKetquaThuLy.SelectedValue != "3")
            {
                int kq = Convert.ToInt32(ddlKetquaThuLy.SelectedValue);
                if (kq < 3)
                    tieudebc += " có kết quả thụ lý là";
                tieudebc += " " + ddlKetquaThuLy.SelectedItem.Text.Replace("...", "").ToLower();
            }
            //---------------------------------

            txtTieuDeBC.Text = "Danh sách các vụ án" + tieudebc.Replace("...", "");
        }

    }
}
