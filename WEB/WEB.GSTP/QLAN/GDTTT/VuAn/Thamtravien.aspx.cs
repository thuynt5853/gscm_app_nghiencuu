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
    public partial class Thamtravien : System.Web.UI.Page
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
        protected void Page_Load(object sender, EventArgs e)
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
                LoadDropTinh();
                LoadDropInBieuMau();
                LoadQHPLTK();
                SetGetSessionTK(false);
                if (Session[SS_TK.NGUYENDON] != null)
                    Load_Data();
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                
            }
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
                    Session[SS_TK.QHPKLT] = ddlQHPLTK.SelectedValue;
                    Session[SS_TK.QHPLDN] = ddlQHPLDN.SelectedValue;
                    Session[SS_TK.TRALOIDON] = ddlTraloi.SelectedValue;
                    Session[SS_TK.NGUOIGUI] = txtNguoiguidon.Text;
                    Session[SS_TK.COQUANCHUYENDON] = txtCoquanchuyendon.Text;
                    Session[SS_TK.LOAICV] = ddlLoaiCV.SelectedValue;
                    Session[SS_TK.THULY_TU] = txtThuly_Tu.Text;
                    Session[SS_TK.THULY_DEN] = txtThuly_Den.Text;
                    Session[SS_TK.SOTHULY] = txtThuly_So.Text;
                    Session[SS_TK.MUONHOSO] = ddlMuonHoso.SelectedValue;
                    Session[SS_TK.TRANGTHAITHULY] = ddlTrangthaithuly.SelectedValue;
                    Session[SS_TK.KETQUATHULY] = ddlKetquaThuLy.SelectedValue;
                    Session[SS_TK.KETQUAXETXU] = ddlKetquaXX.SelectedValue;


                    //int isTotrinh = Convert.ToInt16(ddlTotrinh.SelectedValue);
                    //int isMuonHoSo = Convert.ToInt16(ddlMuonHoso.SelectedValue);
                    //int isYKienKLToTrinh = Convert.ToInt16(dropIsYKienKetLuatTrinhLD.SelectedValue);

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
                    txtSoQDBA.Text = Session[SS_TK.SOBAQD] + "";
                    txtNgayBAQD.Text = Session[SS_TK.NGAYBAQD] + "";
                    if (Session[SS_TK.TOAANXX] != null) ddlToaXetXu.SelectedValue = Session[SS_TK.TOAANXX] + "";

                    txtNguyendon.Text = Session[SS_TK.NGUYENDON] + "";
                    txtBidon.Text = Session[SS_TK.BIDON] + "";
                    if (Session[SS_TK.LOAIAN] != null) ddlLoaiAn.SelectedValue = Session[SS_TK.LOAIAN] + "";
                    if (Session[SS_TK.THAMTRAVIEN] != null) ddlThamtravien.SelectedValue = Session[SS_TK.THAMTRAVIEN] + "";
                    if (Session[SS_TK.LANHDAOPHUTRACH] != null) ddlPhoVuTruong.SelectedValue = Session[SS_TK.LANHDAOPHUTRACH] + "";
                    if (Session[SS_TK.THAMPHAN] != null) ddlThamphan.SelectedValue = Session[SS_TK.THAMPHAN] + "";
                    if (Session[SS_TK.QHPKLT] != null) ddlQHPLTK.SelectedValue = Session[SS_TK.QHPKLT] + "";
                    if (Session[SS_TK.QHPLDN] != null) ddlQHPLDN.SelectedValue = Session[SS_TK.QHPLDN] + "";
                    if (Session[SS_TK.TRALOIDON] != null) ddlTraloi.SelectedValue = Session[SS_TK.TRALOIDON] + "";

                    txtNguoiguidon.Text = Session[SS_TK.NGUOIGUI] + "";
                    txtCoquanchuyendon.Text = Session[SS_TK.COQUANCHUYENDON] + "";
                    if (Session[SS_TK.LOAICV] != null) ddlLoaiCV.SelectedValue = Session[SS_TK.LOAICV] + "";
                    if (Session[SS_TK.MUONHOSO] != null) ddlMuonHoso.SelectedValue = Session[SS_TK.MUONHOSO] + "";
                    txtThuly_Tu.Text = Session[SS_TK.THULY_TU] + "";
                    txtThuly_Den.Text = Session[SS_TK.THULY_DEN] + "";
                    txtThuly_So.Text = Session[SS_TK.SOTHULY] + "";
                    if (Session[SS_TK.TRANGTHAITHULY] != null) ddlTrangthaithuly.SelectedValue = Session[SS_TK.TRANGTHAITHULY] + "";
                    if (Session[SS_TK.KETQUATHULY] != null) ddlKetquaThuLy.SelectedValue = Session[SS_TK.KETQUATHULY] + "";
                    if (Session[SS_TK.KETQUAXETXU] != null) ddlKetquaXX.SelectedValue = Session[SS_TK.KETQUAXETXU] + "";
                }
            }
            catch (Exception ex) { }
        }
        private void LoadQHPLTK()
        {
            ddlQHPLTK.Items.Clear();
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            DM_PHONGBAN obj = dt.DM_PHONGBAN.Where(x => x.ID == PBID).FirstOrDefault() ?? new DM_PHONGBAN();
            if (obj.ISHINHSU == 1)
            {
                ddlQHPLTK.DataSource = dt.DM_BOLUAT_TOIDANH.Where(x => x.LUATID == 5 && x.LOAI == 2).OrderBy(x => x.TENTOIDANH).ToList();
                ddlQHPLTK.DataTextField = "TENTOIDANH";
                ddlQHPLTK.DataValueField = "ID";
                ddlQHPLTK.DataBind();
                ddlQHPLTK.Items.Insert(0, new ListItem("Chọn", "0"));
                return;
            }
            List<DM_QHPL_TK> lstDM = null;
            if (obj.ISDANSU == 1)
            {
                lstDM = dt.DM_QHPL_TK.Where(x => x.ENABLE == 1 && (x.STYLES == ENUM_QHPLTK.DANSU || x.STYLES == ENUM_QHPLTK.KINHDOANH_THUONGMAI || x.STYLES == ENUM_QHPLTK.PHASAN)).OrderBy(y => y.STYLES).ToList();
            }
            if (obj.ISHANHCHINH == 1)
            {
                lstDM = dt.DM_QHPL_TK.Where(x => x.ENABLE == 1 && (x.STYLES == ENUM_QHPLTK.HANHCHINH || x.STYLES == ENUM_QHPLTK.HONNHAN_GIADINH || x.STYLES == ENUM_QHPLTK.LAODONG)).OrderBy(y => y.STYLES).ToList();
            }
            ddlQHPLTK.DataSource = lstDM;
            ddlQHPLTK.DataTextField = "CASE_NAME";
            ddlQHPLTK.DataValueField = "ID";
            ddlQHPLTK.DataBind();
            ddlQHPLTK.Items.Insert(0, new ListItem("Chọn", "0"));
        }
        private void LoadDropTinh()
        {
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

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
            //Load Thẩm phán
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();
            DataTable oCBDT = oGDTBL.CANBO_GETBYDONVI(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
            ddlThamphan.DataSource = oCBDT;
            ddlThamphan.DataTextField = "HOTEN";
            ddlThamphan.DataValueField = "ID";
            ddlThamphan.DataBind();
            ddlThamphan.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
            //Loại án
            ddlLoaiAn.Items.Clear();
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            DM_PHONGBAN obj = dt.DM_PHONGBAN.Where(x => x.ID == PBID).FirstOrDefault() ?? new DM_PHONGBAN();
            if (obj.ISHINHSU == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
                dgList.Columns[6].Visible = false;
                dgList.Columns[5].HeaderText = "Bị cáo";
                lblTitleBC.Text = "Bị cáo";
                lblTitleBD.Visible = txtBidon.Visible = false;
            }
            if (obj.ISDANSU == 1) ddlLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
            if (obj.ISHANHCHINH == 1) ddlLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
            if (obj.ISHNGD == 1) ddlLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
            if (obj.ISKDTM == 1) ddlLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
            if (obj.ISLAODONG == 1) ddlLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
            if (obj.ISPHASAN == 1) ddlLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC.AN_PHASAN));
            ddlLoaiAn.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));

            string strCanBoID = Session[ENUM_SESSION.SESSION_CANBOID] + "";
            decimal CanboID = Convert.ToDecimal(strCanBoID);
            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault();        
            bool isLanhdao = false;
            if (oCB.CHUCVUID != null && oCB.CHUCVUID != 0)
            {
                DM_DATAITEM oCV = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCVUID).FirstOrDefault();
                if (oCV.MA == ENUM_CHUCVU.CHUCVU_VT)//Vụ trưởng
                {
                    isLanhdao = true;
                    //Thẩm tra viên
                    DataTable oTTVDT = oGDTBL.CANBO_GETBYPHONGBAN(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), PBID, ENUM_CHUCDANH.CHUCDANH_TTV);
                    ddlThamtravien.DataSource = oTTVDT;
                    ddlThamtravien.DataTextField = "HOTEN";
                    ddlThamtravien.DataValueField = "ID";
                    ddlThamtravien.DataBind();
                    ddlThamtravien.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
                    //Lãnh đạo
                    DM_CANBO_BL oCBBL = new DM_CANBO_BL();
                    DataTable oTLDDT = oGDTBL.CANBO_GETBYDONVI_2CHUCVU(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), PBID, ENUM_CHUCVU.CHUCVU_PVT, ENUM_CHUCVU.CHUCVU_VT);
                    ddlPhoVuTruong.DataSource = oTLDDT;
                    ddlPhoVuTruong.DataTextField = "HOTEN";
                    ddlPhoVuTruong.DataValueField = "ID";
                    ddlPhoVuTruong.DataBind();
                    ddlPhoVuTruong.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
                }
                else if (oCV.MA == ENUM_CHUCVU.CHUCVU_PVT)//Phó Vụ trưởng
                {
                    isLanhdao = true;
                    //Thẩm tra viên
                    DataTable oTTVDT = oDMCBBL.DM_CANBO_PB_CHUCDANH(PBID, "TTV", oCB.ID, 0, 1, 10000);
                    
                    ddlThamtravien.DataSource = oTTVDT;
                    ddlThamtravien.DataTextField = "HOTEN";
                    ddlThamtravien.DataValueField = "CanBoID";
                    ddlThamtravien.DataBind();
                    ddlThamtravien.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
                    //Lãnh đạo                  
                    ddlPhoVuTruong.Items.Insert(0, new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                }
            }
            if(isLanhdao==false)
            {
                //Lãnh đạo
                DM_CANBO_BL oCBBL = new DM_CANBO_BL();
                DataTable oTLDDT = oGDTBL.CANBO_GETBYDONVI_2CHUCVU(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), PBID, ENUM_CHUCVU.CHUCVU_PVT, ENUM_CHUCVU.CHUCVU_VT);
                ddlPhoVuTruong.DataSource = oTLDDT;
                ddlPhoVuTruong.DataTextField = "HOTEN";
                ddlPhoVuTruong.DataValueField = "ID";
                ddlPhoVuTruong.DataBind();
                ddlPhoVuTruong.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));

                ddlThamtravien.Items.Insert(0, new ListItem(oCB.HOTEN, oCB.ID.ToString()));
            }
           
            //QHPL Định nghĩa
            ddlQHPLDN.DataSource = oGDTBL.QHPL_DINHNGHIA_LIST(PBID);
            ddlQHPLDN.DataTextField = "TENQHPL";
            ddlQHPLDN.DataValueField = "ID";
            ddlQHPLDN.DataBind();
            ddlQHPLDN.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
            //Trình trạng thụ lý
            ddlTrangthaithuly.DataSource = dt.GDTTT_DM_TINHTRANG.OrderBy(x => x.THUTU).ToList();
            ddlTrangthaithuly.DataTextField = "TENTINHTRANG";
            ddlTrangthaithuly.DataValueField = "ID";
            ddlTrangthaithuly.DataBind();
            ddlTrangthaithuly.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
            //Trình trạng thụ lý
            DM_DATAITEM_BL oDMBL = new DM_DATAITEM_BL();
            ddlKetquaXX.DataSource = oDMBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.KETLUANGDTTT);
            ddlKetquaXX.DataTextField = "MA_TEN";
            ddlKetquaXX.DataValueField = "ID";
            ddlKetquaXX.DataBind();
            ddlKetquaXX.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));

            ddlQHPLTK.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
        }

        private DataTable getDS(int page_size, int pageindex)
        {
            decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            GDTTT_VUAN_BL oBL = new GDTTT_VUAN_BL();
            decimal vToaRaBAQD = Convert.ToDecimal(ddlToaXetXu.SelectedValue);
            string vSoBAQD = txtSoQDBA.Text.Trim(), vNgayBAQD = txtNgayBAQD.Text, vNguoiGui = txtNguoiguidon.Text.Trim();
            string vCoquanchuyendon = txtCoquanchuyendon.Text;
            string vNguyendon = txtNguyendon.Text;
            string vBidon = txtBidon.Text;
            decimal vLoaiAn = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
            decimal vThamtravien = Convert.ToDecimal(ddlThamtravien.SelectedValue);
            decimal vLanhdao = Convert.ToDecimal(ddlPhoVuTruong.SelectedValue);
            decimal vThamphan = Convert.ToDecimal(ddlThamphan.SelectedValue);
            decimal vQHPLID = Convert.ToDecimal(ddlQHPLTK.SelectedValue);
            decimal vQHPLDNID = Convert.ToDecimal(ddlQHPLDN.SelectedValue);
            decimal vTraloidon = Convert.ToDecimal(ddlTraloi.SelectedValue);
            decimal vLoaiCVID = Convert.ToDecimal(ddlLoaiCV.SelectedValue);
            DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            string vSoThuly = txtThuly_So.Text;
            decimal vTrangthai = Convert.ToDecimal(ddlTrangthaithuly.SelectedValue);
            decimal vKetquathuly = Convert.ToDecimal(ddlKetquaThuLy.SelectedValue);
            decimal vKetquaxetxu = Convert.ToDecimal(ddlKetquaXX.SelectedValue);

            int isTotrinh = Convert.ToInt16(ddlTotrinh.SelectedValue);
            int isMuonHoSo = Convert.ToInt16(ddlMuonHoso.SelectedValue);
            int isYKienKLToTrinh = Convert.ToInt16(dropIsYKienKetLuatTrinhLD.SelectedValue);
            
            int LoaiAnDB = 0; int isHoanTHA = 2;
            int isBuocTT = 0;
            DataTable oDT = oBL.VUAN_SEARCH(Session[ENUM_SESSION.SESSION_USERID] + "","0","NGAYTHULYDON", "DESC", vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD, vNguoiGui,
               vCoquanchuyendon, vNguyendon, vBidon, vLoaiAn, vThamtravien, vLanhdao, vThamphan,
               vQHPLID, vQHPLDNID, vTraloidon, vLoaiCVID, vNgayThulyTu, vNgayThulyDen, vSoThuly,
               vTrangthai, vKetquathuly, vKetquaxetxu, isMuonHoSo, isTotrinh, isYKienKLToTrinh, isBuocTT, LoaiAnDB,null
               , isHoanTHA,0, 2, 0, 0,0,0,0,0,null
               , 1, null, null
               , pageindex, page_size);
            return oDT;
        }
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
        protected void btnThemmoi_Click(object sender, EventArgs e)
        {
            SetGetSessionTK(true);
            Response.Redirect("Thongtinvuan.aspx?type=new");

        }
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
                    if (dt.GDTTT_QUANLYHS.Where(x => x.VUANID == ID).ToList().Count > 0 || dt.GDTTT_QUANLYHS.Where(x => x.VUANID == ID).ToList().Count > 0)
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
                    string StrMsgArr = "PopupReport('/QLAN/GDTTT/Hoso/Popup/Lichsudon.aspx?arrid=" + e.CommandArgument + "','Danh sách đơn trùng',1000,500);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsgArr, true);
                    break;
                case "CongVan81":
                    string StrMsgArr81 = "PopupReport('/QLAN/GDTTT/Hoso/Popup/Lichsudon.aspx?arrid=" + e.CommandArgument + "','Danh sách đơn trùng',1000,500);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsgArr81, true);
                    break;
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

        //protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        //{
        //    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
        //    if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        //    {
        //        LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
        //        LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
        //        lblSua.Visible = oPer.CAPNHAT;
        //        lbtXoa.Visible = oPer.XOA;
        //    }
        //}


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

            ddlQHPLTK.SelectedIndex = 0;
            ddlQHPLDN.SelectedIndex = 0;
            ddlTraloi.SelectedIndex = 0;

            txtNguoiguidon.Text = "";
            txtCoquanchuyendon.Text = "";
            ddlLoaiCV.SelectedIndex = 0;

            txtThuly_Tu.Text = "";
            txtThuly_Den.Text = "";
            txtThuly_So.Text = "";

            ddlTrangthaithuly.SelectedIndex = 0;
            ddlKetquaThuLy.SelectedIndex = 0;
            ddlKetquaXX.SelectedIndex = 0;
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
            String Parameter = "rID=" + dropMauBC.SelectedValue;
            DataTable tbl = SearchNoPaging();
            Session[SessionName] = tbl;
            string URL = "/QLAN/GDTTT/VuAn/BaoCao/ViewBC.aspx" + (string.IsNullOrEmpty(Parameter) ? "" : "?" + Parameter);
            Cls_Comon.CallFunctionJS(this, this.GetType(), "PopupReport('" + URL + "','In báo cáo',1000,600)");


            // Cls_Comon.ShowMessage(this, this.GetType(),"thông báo", ReportName);
        }
        private DataTable SearchNoPaging()
        {
            decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            GDTTT_VUAN_BL oBL = new GDTTT_VUAN_BL();
            decimal vToaRaBAQD = Convert.ToDecimal(ddlToaXetXu.SelectedValue);
            string vSoBAQD = txtSoQDBA.Text.Trim(), vNgayBAQD = txtNgayBAQD.Text, vNguoiGui = txtNguoiguidon.Text.Trim();
            string vCoquanchuyendon = txtCoquanchuyendon.Text;
            string vNguyendon = txtNguyendon.Text;
            string vBidon = txtBidon.Text;
            decimal vLoaiAn = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
            decimal vThamtravien = Convert.ToDecimal(ddlThamtravien.SelectedValue);
            decimal vLanhdao = Convert.ToDecimal(ddlPhoVuTruong.SelectedValue);
            decimal vThamphan = Convert.ToDecimal(ddlThamphan.SelectedValue);
            decimal vQHPLID = Convert.ToDecimal(ddlQHPLTK.SelectedValue);
            decimal vQHPLDNID = Convert.ToDecimal(ddlQHPLDN.SelectedValue);
            decimal vTraloidon = Convert.ToDecimal(ddlTraloi.SelectedValue);
            decimal vLoaiCVID = Convert.ToDecimal(ddlLoaiCV.SelectedValue);
            DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            string vSoThuly = txtThuly_So.Text;
            decimal vTrangthai = Convert.ToDecimal(ddlTrangthaithuly.SelectedValue);
            decimal vKetquathuly = Convert.ToDecimal(ddlKetquaThuLy.SelectedValue);
            decimal vKetquaxetxu = Convert.ToDecimal(ddlKetquaXX.SelectedValue);
            //int page_size = Convert.ToInt32(ddlPageCount.SelectedValue);
            //int pageindex = Convert.ToInt32(hddPageIndex.Value);

            int isTotrinh = Convert.ToInt16(ddlTotrinh.SelectedValue);
            int isMuonHoSo = Convert.ToInt16(ddlMuonHoso.SelectedValue);
            int isYKienKLToTrinh = Convert.ToInt16(dropIsYKienKetLuatTrinhLD.SelectedValue);
            int isBuocTT = 0;
            int LoaiAnDB = 0;
            int HoanTHA = 2;
            DataTable oDT = oBL.VUAN_Search_NoPaging(vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD, vNguoiGui,
               vCoquanchuyendon, vNguyendon, vBidon, vLoaiAn, vThamtravien, vLanhdao, vThamphan,
               vQHPLID, vQHPLDNID, vTraloidon, vLoaiCVID, vNgayThulyTu, vNgayThulyDen, vSoThuly,
               vTrangthai, vKetquathuly, vKetquaxetxu, isMuonHoSo, isTotrinh, isYKienKLToTrinh, isBuocTT
               , LoaiAnDB, HoanTHA,0,2, 0,0);
            return oDT;
        }
        protected void ddlLoaiAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
            LoadDropQHPL();
        }
        void LoadDropQHPL()
        {
            LoadDropQHPLTheoLoaiAn();
            LoadDropQHPLDN_TheoLoaiAn();
        }
        void LoadDropQHPLTheoLoaiAn()
        {
            String loai_an = ddlLoaiAn.SelectedValue;
            if (loai_an == ENUM_LOAIVUVIEC.AN_HINHSU)
            {
                ddlQHPLTK.DataSource = dt.DM_BOLUAT_TOIDANH.Where(x => x.LUATID == 5 && x.LOAI == 2).OrderBy(x => x.TENTOIDANH).ToList();
                ddlQHPLTK.DataTextField = "TENTOIDANH";
                ddlQHPLTK.DataValueField = "ID";
                ddlQHPLTK.DataBind();
                ddlQHPLTK.Items.Insert(0, new ListItem("Chọn", "0"));
            }
            else
            {
                List<DM_QHPL_TK> lstDM = null;
                int loai_an_id = 0;
                //DANSU=0;HONNHAN_GIADINH=1;KINHDOANH_THUONGMAI=2;LAODONG=3;HANHCHINH=4;PHASAN=5;NGANHKINHTE=15;

                if (loai_an != "0")
                {
                    switch (loai_an)
                    {
                        case ENUM_LOAIVUVIEC.AN_DANSU:
                            loai_an_id = 0;
                            break;
                        case ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH:
                            loai_an_id = 1;
                            break;
                        case ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI:
                            loai_an_id = 2;
                            break;
                        case ENUM_LOAIVUVIEC.AN_LAODONG:
                            loai_an_id = 3;
                            break;
                        case ENUM_LOAIVUVIEC.AN_HANHCHINH:
                            loai_an_id = 4;
                            break;
                        case ENUM_LOAIVUVIEC.AN_PHASAN:
                            loai_an_id = 5;
                            break;
                    }
                    lstDM = dt.DM_QHPL_TK.Where(x => x.ENABLE == 1 && (x.STYLES == loai_an_id)).OrderBy(y => y.STYLES).ToList();
                }
                else
                {
                    decimal PBID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");
                    DM_PHONGBAN obj = dt.DM_PHONGBAN.Where(x => x.ID == PBID).FirstOrDefault() ?? new DM_PHONGBAN();
                    if (obj.ISDANSU == 1)
                    {
                        lstDM = dt.DM_QHPL_TK.Where(x => x.ENABLE == 1 && (x.STYLES == 0 || x.STYLES == 2 || x.STYLES == 5)).OrderBy(z => z.STYLES).OrderBy(y => y.STYLES).ToList();
                    }
                    if (obj.ISHANHCHINH == 1)
                    {
                        lstDM = dt.DM_QHPL_TK.Where(x => x.ENABLE == 1 && (x.STYLES == 4 || x.STYLES == 1 || x.STYLES == 3)).OrderBy(z => z.STYLES).OrderBy(y => y.STYLES).ToList();
                    }
                }
                ddlQHPLTK.DataSource = lstDM;
                ddlQHPLTK.DataTextField = "CASE_NAME";
                ddlQHPLTK.DataValueField = "ID";
                ddlQHPLTK.DataBind();
                ddlQHPLTK.Items.Insert(0, new ListItem("Chọn", "0"));
            }
        }
        void LoadDropQHPLDN_TheoLoaiAn()
        {
            int loai_an = Convert.ToInt16(ddlLoaiAn.SelectedValue);
            //QHPL Định nghĩa
            List<GDTTT_DM_QHPL> lst = null;
            if (loai_an > 0)
                lst = dt.GDTTT_DM_QHPL.Where(x => x.LOAIAN == loai_an).OrderBy(y => y.TENQHPL).ToList();
            else
            {
                decimal PBID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");
                DM_PHONGBAN obj = dt.DM_PHONGBAN.Where(x => x.ID == PBID).FirstOrDefault() ?? new DM_PHONGBAN();
                if (obj.ISDANSU == 1)
                {
                    lst = dt.GDTTT_DM_QHPL.Where(x => x.LOAIAN == ENUM_QHPLTK.DANSU || x.LOAIAN == ENUM_QHPLTK.KINHDOANH_THUONGMAI || x.LOAIAN == ENUM_QHPLTK.PHASAN).OrderBy(y => y.TENQHPL).ToList();
                }
                if (obj.ISHANHCHINH == 1)
                {
                    lst = dt.GDTTT_DM_QHPL.Where(x => x.LOAIAN == ENUM_QHPLTK.HANHCHINH || x.LOAIAN == ENUM_QHPLTK.HONNHAN_GIADINH || x.LOAIAN == ENUM_QHPLTK.LAODONG).OrderBy(y => y.TENQHPL).ToList();
                }
            }
            if (lst != null)
                ddlQHPLDN.DataSource = lst;

            ddlQHPLDN.DataTextField = "TENQHPL";
            ddlQHPLDN.DataValueField = "ID";
            ddlQHPLDN.DataBind();
            ddlQHPLDN.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
        }
        protected void ddlMuonHoso_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
            if (ddlMuonHoso.SelectedValue == "1")
                dropMauBC.SelectedValue = "2";
            else if (ddlMuonHoso.SelectedValue == "0")
                dropMauBC.SelectedValue = "1";
        }
        protected void ddlTrangthaithuly_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlTrangthaithuly.SelectedValue != "0")
            {
                SetTieuDeBaoCao();
                decimal tt = Convert.ToDecimal(ddlTrangthaithuly.SelectedValue);
                GDTTT_DM_TINHTRANG objTT = dt.GDTTT_DM_TINHTRANG.Where(x => x.ID == tt).FirstOrDefault();
                if (objTT.GIAIDOAN == 2)
                {
                    dropIsYKienKetLuatTrinhLD.Visible = lttYKienKetLuan.Visible = true;
                }
                else
                {
                    dropIsYKienKetLuatTrinhLD.Visible = lttYKienKetLuan.Visible = false;
                    dropIsYKienKetLuatTrinhLD.SelectedValue = "2";
                }
            }
            else
            {
                dropIsYKienKetLuatTrinhLD.Visible = lttYKienKetLuan.Visible = false;
                dropIsYKienKetLuatTrinhLD.SelectedValue = "2";
            }
        }
        protected void ddlPhoVuTruong_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
        }
        protected void ddlThamphan_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
        }
        protected void ddlTotrinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
            if (ddlTotrinh.SelectedValue != "2")
                dropMauBC.SelectedValue = "3";
        }
        protected void dropIsYKienKetLuatTrinhLD_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
            if (dropIsYKienKetLuatTrinhLD.Visible == true && dropIsYKienKetLuatTrinhLD.SelectedValue != "0")
            {
                dropMauBC.SelectedValue = "4";
            }
        }

        void SetTieuDeBaoCao()
        {
            string tieudebc = "";

            //-------------------------------------
            if (ddlLoaiAn.SelectedValue != "0")
                tieudebc += " " + ddlLoaiAn.SelectedItem.Text.ToLower();

            //-------------------------------------
            String canbophutrach = "";
            if (ddlThamphan.SelectedValue != "0")
                canbophutrach = "thẩm phán " + Cls_Comon.FormatTenRieng(ddlThamphan.SelectedItem.Text);

            //if (!String.IsNullOrEmpty(canbophutrach))
            //    canbophutrach += ", ";
            //if (ddlThamtravien.SelectedValue != "0")
            //    canbophutrach +=((string.IsNullOrEmpty(canbophutrach))?"":", " )+ "thẩm tra viên " + ddlThamtravien.SelectedItem.Text;

            if (ddlPhoVuTruong.SelectedValue != "0")
                canbophutrach += ((string.IsNullOrEmpty(canbophutrach)) ? "" : ", ") + "lãnh đạo Vụ " + ddlPhoVuTruong.SelectedItem.Text;

            if (!String.IsNullOrEmpty(canbophutrach))
                canbophutrach += " phụ trách";

            tieudebc += (string.IsNullOrEmpty(canbophutrach)) ? "" : " do " + canbophutrach;
            //-------------------------------------
            if (ddlMuonHoso.SelectedValue != "2")
                tieudebc += " " + ddlMuonHoso.SelectedItem.Text.ToLower();

            if (ddlTotrinh.SelectedValue != "2")
                tieudebc += " " + ddlTotrinh.SelectedItem.Text.ToLower();

            if (ddlTrangthaithuly.SelectedValue != "0")
                tieudebc += " " + ddlTrangthaithuly.SelectedItem.Text.ToLower();

            if (dropIsYKienKetLuatTrinhLD.Visible == true && dropIsYKienKetLuatTrinhLD.SelectedValue != "2")
                tieudebc += " " + dropIsYKienKetLuatTrinhLD.SelectedItem.Text.ToLower();

            txtTieuDeBC.Text = "Danh sách các vụ án" + tieudebc;
        }
    }
}
