using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.GDTTT.VuAn
{
    public partial class DanhsachRutKN : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private const decimal ROOT = 0;
        Decimal trangthai_trinh_id = 0;
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
        protected void Page_Load(object sender, EventArgs e)
        {
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
                    if ((Session[SessionInBC] + "") == "0")
                    {
                        lkInBC_OpenForm.Text = "[ Thu gọn ]";
                        pnInBC.Visible = true;
                    }
                    //---------------------------
                    LoadDropBox();
                    LoadDropInBieuMau();
                    SetGetSessionTK(false);
                    if (Session[SS_TK.NGUYENDON] != null)
                        Load_Data();               
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(btnThemmoi, oPer.TAOMOI);               
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
                    
                    Session[SS_TK.TRALOIDON] = ddlTraloi.SelectedValue;
                 
                    Session[SS_TK.LOAICV] = ddlLoaiCV.SelectedValue;
                    Session[SS_TK.THULY_TU] = txtThuly_Tu.Text;
                    Session[SS_TK.THULY_DEN] = txtThuly_Den.Text;
                    Session[SS_TK.SOTHULY] = txtThuly_So.Text;
                   

                    string vArrSelectID = "";
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
                        if (Session[SS_TK.TRALOIDON] != null) ddlTraloi.SelectedValue = Session[SS_TK.TRALOIDON] + "";
                        if (Session[SS_TK.LOAICV] != null) ddlLoaiCV.SelectedValue = Session[SS_TK.LOAICV] + "";

                        txtThuly_Tu.Text = Session[SS_TK.THULY_TU] + "";
                        txtThuly_Den.Text = Session[SS_TK.THULY_DEN] + "";
                        txtThuly_So.Text = Session[SS_TK.SOTHULY] + "";
                    }
                }
                Session[SS_TK.TRANGTHAITHULY] = 14;// ddlTrangthaithuly.SelectedValue;
                Session[SS_TK.KETQUATHULY] = 1; //ddlKetquaThuLy.SelectedValue;
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
                      
            //Load loại công văn
            DM_DATAITEM_BL cvBL = new DM_DATAITEM_BL();
            DataTable tbl = cvBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.LOAICVGDTTT);
            if (tbl.Rows.Count > 0)
            {
                ddlLoaiCV.DataSource = tbl;
                ddlLoaiCV.DataTextField = "MA_TEN";
                ddlLoaiCV.DataValueField = "ID";
                ddlLoaiCV.DataBind();
            }
            ddlLoaiCV.Items.Insert(0, new ListItem("Tất cả trừ 8.1", "-1"));
            ddlLoaiCV.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));

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
                    || oCD.MA == "C010" || oCD.MA == "C008" || oCD.MA == "C009"
                    || oCD.MA == "042")
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
                //DataTable oCBDT = oGDTBL.CANBO_GETBYDONVI(LoginDonViID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                DataTable tbl = oGDTBL.GDTTT_VUAN_GETALLCBTHEOPB_ALLXX(LoginDonViID, PBID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
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
            if (obj != null)
            {
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
            else
            {
                ddlLoaiAn.Items.AddRange(ClsHelper.GetEnumLoaiAn().ToArray());
                ddlLoaiAn.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
            }
        }

        protected void btnThemmoi_Click(object sender, EventArgs e)
        {
            SetGetSessionTK(true);
            Response.Redirect("Thongtinvuan.aspx?type=new");

        }
        //-----------------------------------------
        private void Load_Data()
        {
            SetTieuDeBaoCao();
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
            }
            else
            {
                hddTotalPage.Value = "1";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                           lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                lstSobanghiT.Text = lstSobanghiB.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";

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
            
            decimal vLoaiCVID = Convert.ToDecimal(ddlLoaiCV.SelectedValue);
            DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            string vSoThuly = txtThuly_So.Text;
            
            int LoaiAnDB = Convert.ToInt16(dropAnDB.SelectedValue);
            int isHoanTHA = Convert.ToInt16(dropHoanTHA.SelectedValue);

            int isRutKN = Convert.ToInt16(rdRutKN.SelectedValue);
            DataTable oDT = oBL.VUAN_RUTKN_SEARCH(vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD
                                                   , vNguyendon, vBidon, vLoaiAn
                                                   , vThamtravien, vLanhdao, vThamphan
                                                   , vNgayThulyTu, vNgayThulyDen, vSoThuly
                                                   , LoaiAnDB, isHoanTHA, isRutKN
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
        String temp = "";
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            switch (e.CommandName)
            {
                case "Sua":
                    Response.Redirect("Thongtinvuan.aspx?ID=" + e.CommandArgument.ToString());
                    break;
                case "Xoa":
                    if (oPer.XOA == false)
                    {
                        lbtthongbao.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    decimal ID = Convert.ToDecimal(e.CommandArgument);
                    if(dt.GDTTT_QUANLYHS.Where(x=>x.VUANID== ID).ToList().Count>0 || dt.GDTTT_QUANLYHS.Where(x => x.VUANID == ID).ToList().Count > 0)
                    {
                        lbtthongbao.Text = "Đã có dữ liệu liên quan, không được phép xóa!";
                        return;
                    }
                    GDTTT_VUAN oT = dt.GDTTT_VUAN.Where(x => x.ID == ID).FirstOrDefault();
                    dt.GDTTT_VUAN.Remove(oT);
                    dt.SaveChanges();
                    dgList.CurrentPageIndex = 0;
                    hddPageIndex.Value = "1";
                    Load_Data();
                    break;
                case "QLHS":
                    string StrQLHS = "PopupReport('/QLAN/GDTTT/VuAn/Popup/QLHoso.aspx?vid=" + e.CommandArgument + "','Quản lý mượn trả hồ sơ',1000,600);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrQLHS, true);
                    break;
                case "TOTRINH":
                    string StrTotrinh = "PopupReport('/QLAN/GDTTT/VuAn/Popup/QLTotrinh.aspx?vid=" + e.CommandArgument + "','Quản lý tờ trình',1000,700);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrTotrinh, true);
                    break;
                case "KETQUA":
                    string StrKetqua = "PopupReport('/QLAN/GDTTT/VuAn/Popup/Ketqua.aspx?vid=" + e.CommandArgument + "','Kết quả giải quyết',850,500);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrKetqua, true);
                    break;
                case "SoDonTrung":
                    string StrMsgArr = "PopupReport('/QLAN/GDTTT/VuAn/Popup/pDsDon.aspx?arrid=" + e.CommandArgument + "','Danh sách đơn trùng',1000,500);";
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
        
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                temp = "";

                DataRowView rv = (DataRowView)e.Item.DataItem;  
                Decimal CurrVuAnID = Convert.ToDecimal(rv["ID"] + "");

                Literal lttLanTT = (Literal)e.Item.FindControl("lttLanTT");
                Literal lttDetaiTinhTrang = (Literal)e.Item.FindControl("lttDetaiTinhTrang");
                lttLanTT.Text = rv["TENTINHTRANG"] + "";

                int trangthai = String.IsNullOrEmpty(rv["TRANGTHAIID"] + "") ? 0 : Convert.ToInt32(rv["TRANGTHAIID"] + "");                               
                if ((trangthai == (int)ENUM_GDTTT_TRANGTHAI.TRINH_THAMPHAN)
                    || (trangthai == (int)ENUM_GDTTT_TRANGTHAI.TRINH_PHOVT)
                    || (trangthai == (int)ENUM_GDTTT_TRANGTHAI.TRINH_VUTRUONG))
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
                                lttDetaiTinhTrang.Text = "<br/><span style='margin-right:10px;'>Ngày: " + Convert.ToDateTime(objTT.NGAYTRINH).ToString("dd/MM/yyyy", cul) + "</span>";

                            lttDetaiTinhTrang.Text += (string.IsNullOrEmpty(lttDetaiTinhTrang.Text)) ? "" : "<br/>";
                            lttDetaiTinhTrang.Text += objTT.YKIEN + "";
                        }
                    }
                    catch (Exception ex) { }
                    #endregion
                }
                else
                {
                    switch (trangthai)
                    {
                        case (int)ENUM_GDTTT_TRANGTHAI.PHANCONG_TTV:
                            //hien ngay phan cong + qua trinh_ghi chu (GDTTT_VuAn)                       
                            lttDetaiTinhTrang.Text = (string.IsNullOrEmpty(rv["NGAYPHANCONGTTV"] + "") ? "" : (rv["NGAYPHANCONGTTV"].ToString() + "<br/>"))
                                                        + rv["QUATRINH_GHICHU"] + "";
                            break;
                        case (int)ENUM_GDTTT_TRANGTHAI.TRALOIDON:
                            lttDetaiTinhTrang.Text = String.IsNullOrEmpty(rv["GDQ_SO"] + "") ? "" : ("<span style='padding-right:10px;'>Số: <b>" + rv["GDQ_SO"].ToString() + "</b></span>");
                            lttDetaiTinhTrang.Text += (string.IsNullOrEmpty(rv["GDQ_NGAY"] + "")) ? "" : ("Ngày: <b>" + rv["GDQ_NGAY"].ToString() + "</b>");
                            break;
                        case (int)ENUM_GDTTT_TRANGTHAI.KHANGNGHI:
                            lttLanTT.Text = "<b>Kháng nghị " + rv["LoaiKN"].ToString() + " </b>";
                            lttDetaiTinhTrang.Text = String.IsNullOrEmpty(rv["GDQ_SO"] + "") ? "" : ("<span style='padding-right:10px;'>Số: <b>" + rv["GDQ_SO"].ToString() + "</b></span>");
                            lttDetaiTinhTrang.Text += (string.IsNullOrEmpty(rv["GDQ_NGAY"] + "")) ? "" : ("Ngày: <b>" + rv["GDQ_NGAY"].ToString() + "</b>");                          
                            break;
                        case (int)ENUM_GDTTT_TRANGTHAI.XEPDON:
                            lttDetaiTinhTrang.Text = String.IsNullOrEmpty(rv["GDQ_SO"] + "") ? "" : ("<span style='padding-right:10px;'>Số: <b>" + rv["GDQ_SO"].ToString() + "</b></span>");
                            lttDetaiTinhTrang.Text += (string.IsNullOrEmpty(rv["GDQ_NGAY"] + "")) ? "" : ("Ngày: <b>" + rv["GDQ_NGAY"].ToString() + "</b>");                                                        
                            break;
                    }
                }
                //--------------------------
                if (Convert.ToInt16(rv["IsRutKN"] + "") > 0)
                {
                    if (lttLanTT.Text.Length > 0)
                        lttLanTT.Text += "<br/><span class='line_space'></span>";
                    lttLanTT.Text += "<br/><b>Rút kháng nghị</b>";
                    temp = String.IsNullOrEmpty(rv["SORUTKN"] + "") ? "" : "Số <b>" + rv["SORUTKN"].ToString() + "</b>";
                    if ((temp != "") && (!String.IsNullOrEmpty(rv["NGAYRUTKN"].ToString())))
                        temp += " ngày <b>" + rv["NGAYRUTKN"] + "" + "</b>";
                    if (!String.IsNullOrEmpty(temp))
                        lttLanTT.Text += "<br/>" + temp;
                }
                //-------------------------------
                Literal lttKQGQ = (Literal)e.Item.FindControl("lttKQGQ");
                int IsHoanTHA = Convert.ToInt16(rv["GQD_IsHoanTHA"] + "");
                if (IsHoanTHA > 0)
                {
                    lttKQGQ.Text = "<span class='line_space'>";
                    lttKQGQ.Text += "<b>Hoãn thi hành án</b>" + "<br/>";
                    lttKQGQ.Text += "<span style='margin-right:10px;'>Số: <b>" + rv["GQD_HoanTHA_So"].ToString() + "</b></span>";
                    lttKQGQ.Text += "<span style=''>Ngày: <b>" + rv["GQD_HoanTHA_Ngay"].ToString() + "</b></span><br/>";
                    lttKQGQ.Text += "";
                    lttKQGQ.Text += "</span>";
                }

                //---------------------------
                Literal lttOther = (Literal)e.Item.FindControl("lttOther");
                int soluong = String.IsNullOrEmpty(rv["IsHoSo"] + "") ? 0 : Convert.ToInt32(rv["IsHoSo"] + "");
                lttOther.Text = "<div class='line_space'><b>" + ((soluong>0)?"Đã có hồ sơ":"Chưa có hồ sơ")+ "</b></div>";

                soluong = String.IsNullOrEmpty(rv["IsToTrinh"] + "") ? 0 : Convert.ToInt32(rv["IsToTrinh"] + "");
                lttOther.Text += "<div class='full_width'>Số lượng tờ trình: <b>" + soluong + "</b></div>";
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
            
            ddlTraloi.SelectedIndex = 0;         

           
            ddlLoaiCV.SelectedIndex = 0;
            
            txtThuly_Tu.Text = "";
            txtThuly_Den.Text = "";          
            txtThuly_So.Text = "";

            //ddlTrangthaithuly.SelectedIndex = 0;
            //ddlKetquaThuLy.SelectedIndex = 0;
            //ddlKetquaXX.SelectedIndex = 0;
        }
        //---------------------------------
        void LoadDropInBieuMau()
        {
            //dropBM.Items.Clear();
            //string report_name = "";
            //string TenThamPhan =(ddlThamphan.SelectedValue == "0")? "...": ddlThamphan.SelectedItem.Text.ToUpper();
            //for (int i = 1; i <= 6; i++)
            //{
            //    switch (i)
            //    {
            //        case 1:
            //            report_name = "DANH SÁCH CÁC VỤ ÁN HÀNH CHÍNH DO THẨM PHÁN " + TenThamPhan
            //                           + " PHỤ TRÁCH CHƯA CÓ HỒ SƠ";
            //            break;
            //        case 2:
            //            report_name = "Phụ lục 2: DANH SÁCH CÁC VỤ ÁN HÀNH CHÍNH DO THẨM PHÁN " + TenThamPhan
            //                        + " PHỤ TRÁCH ĐÃ CÓ HỒ SƠ";
            //            break;
            //        case 3:
            //            report_name = "Phụ lục 3: DANH SÁCH CÁC VỤ ÁN HÀNH CHÍNH DO THẨM PHÁN " + TenThamPhan
            //                        + " PHỤ TRÁCH THẨM TRA VIÊN ĐÃ CÓ TỜ TRÌNH LÃNH ĐẠO VỤ";
            //            break;
            //        case 4:
            //            report_name = "Phụ lục 4: DANH SÁCH CÁC VỤ ÁN HÀNH CHÍNH THẨM PHÁN " + TenThamPhan
            //                        + " ";
            //            break;
            //        case 5:
            //            report_name = "Phụ lục 5: DANH SÁCH CÁC VỤ ÁN HÀNH CHÍNH THẨM PHÁN " + TenThamPhan
            //                        + " YÊU CẦU THẨM TRA VIÊN NGHIÊN CỨU THÊM, GIẢI TRÌNH BỔ SUNG";
            //            break;
            //        case 6:
            //            report_name = "Phụ lục 6: DANH SÁCH CÁC VỤ ÁN HÀNH CHÍNH THẨM PHÁN " + TenThamPhan
            //                        + " ĐÃ CÓ Ý KIẾN KẾT LUẬN";
            //            break;
            //    }
            //    dropBM.Items.Add(new ListItem(report_name, i.ToString()));
            //}
        }

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
            String ReportName = "";
            if (String.IsNullOrEmpty(txtTieuDeBC.Text))
                SetTieuDeBaoCao();
            ReportName = txtTieuDeBC.Text.Trim();
            Session[SS_TK.TENBAOCAO] = ReportName.ToUpper();
            String Parameter = "type=va&rID=" + dropMauBC.SelectedValue;
            DataTable tbl = getDS(200000000, 1);
            Session[SessionName] = tbl;
            string URL = "/QLAN/GDTTT/VuAn/BaoCao/ViewBC.aspx" + (string.IsNullOrEmpty(Parameter) ? "" : "?" + Parameter);
            Cls_Comon.CallFunctionJS(this, this.GetType(), "PopupReport('" + URL + "','In báo cáo',1000,600)");
        }
        private DataTable SearchNoPaging()
        {
            //decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            //decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            //GDTTT_VUAN_BL oBL = new GDTTT_VUAN_BL();
            //decimal vToaRaBAQD = Convert.ToDecimal(ddlToaXetXu.SelectedValue);
            //string vSoBAQD = txtSoQDBA.Text.Trim(), vNgayBAQD = txtNgayBAQD.Text;
            
            //string vNguyendon = txtNguyendon.Text;
            //string vBidon = txtBidon.Text;
            //decimal vLoaiAn = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
            //decimal vThamtravien = Convert.ToDecimal(ddlThamtravien.SelectedValue);
            //decimal vLanhdao = Convert.ToDecimal(ddlPhoVuTruong.SelectedValue);
            //decimal vThamphan = Convert.ToDecimal(ddlThamphan.SelectedValue);
            //decimal vQHPLID = 0;
            //decimal vQHPLDNID = 0;

            //decimal vTraloidon = Convert.ToDecimal(ddlTraloi.SelectedValue);
            //decimal vLoaiCVID = Convert.ToDecimal(ddlLoaiCV.SelectedValue);
            //DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            //DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            //string vSoThuly = txtThuly_So.Text;
            //decimal vTrangthai = Convert.ToDecimal(ddlTrangthaithuly.SelectedValue);
            //decimal vKetquathuly = Convert.ToDecimal(ddlKetquaThuLy.SelectedValue);
            //decimal vKetquaxetxu = Convert.ToDecimal(ddlKetquaXX.SelectedValue);
            ////int page_size = Convert.ToInt32(ddlPageCount.SelectedValue);
            ////int pageindex = Convert.ToInt32(hddPageIndex.Value);

            //int isTotrinh = Convert.ToInt16(ddlTotrinh.SelectedValue);
            //int isMuonHoSo =Convert.ToInt16( ddlMuonHoso.SelectedValue);
            //int isYKienKLToTrinh = Convert.ToInt16(dropIsYKienKetLuatTrinhLD.SelectedValue);

            //int LoaiAnDB = Convert.ToInt16(dropAnDB.SelectedValue);
            //int ishoantha = Convert.ToInt16(dropHoanTHA.SelectedValue);
            DataTable oDT = null;
            //oDT = oBL.VUAN_Search_NoPaging(vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD, vNguoiGui,
            //   vCoquanchuyendon, vNguyendon, vBidon, vLoaiAn, vThamtravien, vLanhdao, vThamphan,
            //   vQHPLID, vQHPLDNID, vTraloidon, vLoaiCVID, vNgayThulyTu, vNgayThulyDen, vSoThuly,
            //   vTrangthai, vKetquathuly, vKetquaxetxu, isMuonHoSo, isTotrinh,   isYKienKLToTrinh, LoaiAnDB, ishoantha);
            return oDT;
        }
        protected void ddlLoaiAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
            Load_Data();
        }
        protected void ddlLoaiCV_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlLoaiCV.SelectedValue != "0")
                SetTieuDeBaoCao();
            //-------------------------------------
            decimal cv_quochoi = 1023;
            decimal loaicv = Convert.ToDecimal(ddlLoaiCV.SelectedValue);
            List<DM_DATAITEM> lst = dt.DM_DATAITEM.Where(x => x.ID == cv_quochoi
                                                            || x.ARRSAPXEP.Contains(cv_quochoi + "/")).ToList();
            if (lst != null && lst.Count > 0)
            {
                Cls_Comon.SetValueComboBox(dropMauBC, "5");
            }
            ////-------------------------------------
            //dgList.CurrentPageIndex = 0;
            //hddPageIndex.Value = "1";
            //Load_Data();
            SetGetSessionTK(true);
        }
        
        protected void ddlPhoVuTruong_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
        }
        protected void ddlThamphan_SelectedIndexChanged(object sender, EventArgs e)
        {
           SetTieuDeBaoCao();
        }


        protected void dropAnDB_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
        }
        void SetTieuDeBaoCao()
        {
            string tieudebc = "";

            //-------------------------------------
            if (ddlLoaiAn.SelectedValue != "0")
                tieudebc += " " + ddlLoaiAn.SelectedItem.Text.ToLower();
            //-------------------------------------
            if (dropAnDB.SelectedValue != "0")
                    tieudebc += " là " + dropAnDB.SelectedItem.Text.ToLower();
            //-------------------------------------
            String canbophutrach = "";
            if (ddlThamphan.SelectedValue != "0")
                canbophutrach = "thẩm phán " + Cls_Comon.FormatTenRieng( ddlThamphan.SelectedItem.Text);

            //if (!String.IsNullOrEmpty(canbophutrach))
            //    canbophutrach += ", ";
            //if (ddlThamtravien.SelectedValue != "0")
            //    canbophutrach +=((string.IsNullOrEmpty(canbophutrach))?"":", " )+ "thẩm tra viên " + ddlThamtravien.SelectedItem.Text;

            if (ddlPhoVuTruong.SelectedValue != "0")
                canbophutrach +=((string.IsNullOrEmpty(canbophutrach))?"":", " )+ "lãnh đạo Vụ " + ddlPhoVuTruong.SelectedItem.Text;

            if (!String.IsNullOrEmpty(canbophutrach))
                canbophutrach += " phụ trách";

            tieudebc += (string.IsNullOrEmpty(canbophutrach))?"": " do " + canbophutrach;
            //----------------------------
            if (rdRutKN.SelectedValue == "1")
                tieudebc += " thực hiện " + rdRutKN.SelectedItem.Text.ToLower();

            txtTieuDeBC.Text = "Danh sách các vụ án" + tieudebc.Replace("...", "");

        }   
    }
}
