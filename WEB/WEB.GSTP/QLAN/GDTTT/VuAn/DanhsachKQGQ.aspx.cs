using BL.GSTP;
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
namespace WEB.GSTP.QLAN.GDTTT.VuAn
{
    public partial class DanhsachKQGQ : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private const decimal ROOT = 0;
        string temp = "";


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
        Decimal CurrUserID = 0, CurrPhongBanID =0;
        MenuPermission oPer = null;

        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            scriptManager.RegisterPostBackControl(this.cmdPrint); 
            scriptManager.RegisterPostBackControl(this.cmdPrintBC);
            scriptManager.RegisterPostBackControl(this.cmdPrintBC5);
            //---------------------------
            CurrUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            CurrPhongBanID = (String.IsNullOrEmpty( Session[ENUM_SESSION.SESSION_PHONGBANID]+"") ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]+""));
            if (CurrUserID > 0)
            {
                oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    
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
                    SetVisible_SearchDateTime();
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
                    Session[SS_TK.THULY_TU] = txtGQD_TuNgay.Text;
                    Session[SS_TK.THULY_DEN] = txtGQD_DenNgay.Text;
                    Session[SS_TK.SOTHULY] = txtThuly_So.Text;
                    //Session[SS_TK.MUONHOSO] = ddlMuonHoso.SelectedValue;
                    Session[SS_TK.KETQUATHULY] = ddlKetquaThuLy.SelectedValue;
                    Session[SS_TK.KETQUAXETXU] = ddlKetquaXX.SelectedValue;

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

                        //if (Session[SS_TK.TRALOIDON] != null) ddlTraloi.SelectedValue = Session[SS_TK.TRALOIDON] + "";
                        // if (Session[SS_TK.LOAICV] != null) ddlLoaiCV.SelectedValue = Session[SS_TK.LOAICV] + "";

                        txtGQD_TuNgay.Text = Session[SS_TK.THULY_TU] + "";
                        txtGQD_DenNgay.Text = Session[SS_TK.THULY_DEN] + "";
                        txtThuly_So.Text = Session[SS_TK.SOTHULY] + "";

                        if (Session[SS_TK.KETQUATHULY] != null)
                            ddlKetquaThuLy.SelectedValue = Session[SS_TK.KETQUATHULY] + "";
                        if (Session[SS_TK.KETQUAXETXU] != null)
                            ddlKetquaXX.SelectedValue = Session[SS_TK.KETQUAXETXU] + "";

                        //if (Session[SS_TK.MUONHOSO] != null)
                        //    ddlMuonHoso.SelectedValue = Session[SS_TK.MUONHOSO] + "";
                        SetTieuDeBaoCao();
                    }
                }
            }
            catch (Exception ex) { }
        }
        private void LoadDropBox()
        {
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            //string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            //decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);

            DM_TOAAN_BL oTABL = new DM_TOAAN_BL();
            DataTable dtTA = oTABL.DM_TOAAN_GETBYNOTCUR(0, 0);
            ddlToaXetXu.DataSource = dtTA;
            ddlToaXetXu.DataTextField = "MA_TEN";
            ddlToaXetXu.DataValueField = "ID";
            ddlToaXetXu.DataBind();
            ddlToaXetXu.Items.Insert(0, new ListItem("--- Chọn --- ", "0"));
                        
            GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();

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

            //Trình trạng thụ lý
            DM_DATAITEM_BL oDMBL = new DM_DATAITEM_BL();
            ddlKetquaXX.DataSource = oDMBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.KETLUANGDTTT);
            ddlKetquaXX.DataTextField = "MA_TEN";
            ddlKetquaXX.DataValueField = "ID";
            ddlKetquaXX.DataBind();
            ddlKetquaXX.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
        }
        void LoadDropLanhDao()
        {
            decimal CurrNhomNSDID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_NHOMNSDID] + "");
            QT_NHOMNGUOIDUNG oGroup = dt.QT_NHOMNGUOIDUNG.Where(x => x.ID == CurrNhomNSDID).Single();
            int loai_hotro_db = (int)oGroup.LOAI;

            //string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            //decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
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
                    if ((oCD.MA == "TTV" || oCD.MA == "TTVCC" || oCD.MA == "TTVC"
                    || oCD.MA == "TK1" || oCD.MA == "TK" || oCD.MA == "TKA" || oCD.MA == "C027"
                    || oCD.MA == "C010" || oCD.MA == "C008" || oCD.MA == "C009"|| oCD.MA == "042") && loai_hotro_db != 1)
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
                if ((oCD.MA == "TTV" || oCD.MA == "TTVCC" || oCD.MA == "TTVC"
                    || oCD.MA == "TK1" || oCD.MA == "TK" || oCD.MA == "TKA" || oCD.MA == "C027"
                    || oCD.MA == "C010" || oCD.MA == "C008" || oCD.MA == "C009") && loai_hotro_db != 1)
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
            int count = 0;
            //Thẩm tra viên
            DataTable tblTheoPB = oGDTBL.GDTTT_VuAn_GetAllCBTheoPB(LoginDonViID, PBID, ENUM_CHUCDANH.CHUCDANH_TTV);
            count = tblTheoPB.Rows.Count;
            ddlThamtravien.DataSource = tblTheoPB;
            ddlThamtravien.DataTextField = "HOTEN";
            ddlThamtravien.DataValueField = "ID";
            ddlThamtravien.DataBind();
            ddlThamtravien.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
            ddlThamtravien.Items.Insert(count + 1, new ListItem("-- Chưa phân công --", "-1"));
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
            int count = 0;
            //Load Thẩm phán
            GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();
            Boolean IsLoadAll = false;
            ddlThamphan.Items.Clear();
            Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault();
            if (oCB.CHUCDANHID != null && oCB.CHUCDANHID != 0)
            {
                DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCDANHID).FirstOrDefault();
                if (oCD.MA== "TPTATC")
                {
                    ddlThamphan.Items.Add(new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                }
                else
                    IsLoadAll = true;
            }
            else
                IsLoadAll = true;
            if (IsLoadAll)
            {
                // DataTable oCBDT = oGDTBL.CANBO_GETBYDONVI(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                DataTable tbl = oGDTBL.GDTTT_VUAN_GETALLCBTHEOPB_ALLXX(LoginDonViID, PBID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                count = tbl.Rows.Count;
                ddlThamphan.DataSource = tbl;
                ddlThamphan.DataTextField = "HOTEN";
                ddlThamphan.DataValueField = "ID";
                ddlThamphan.DataBind();
                ddlThamphan.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
                ddlThamphan.Items.Insert(count + 1, new ListItem("-- Chưa phân công --", "-1"));
            }
        }

        protected void Drop_LoaiThamPhan_SelectedIndexChanged(object sender, EventArgs e)
        {
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);

            if (ddlLoaiThamPhan.SelectedValue == "0")
            {
                int count = 0;
                DataTable tbl = oBL.GDTTT_VuAn_GetAllCBTheoPB(ToaAnID, PBID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                count = tbl.Rows.Count;
                ddlThamphan.DataSource = tbl;
                ddlThamphan.DataTextField = "HOTEN";
                ddlThamphan.DataValueField = "ID";
                ddlThamphan.DataBind();
                ddlThamphan.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
            }
            else if (ddlLoaiThamPhan.SelectedValue == "1") // thẩm phán tối cao
            {
                ddlThamphan.DataSource = oBL.THAMPHAN_GETBY_NC(ToaAnID, "0", PBID);
                ddlThamphan.DataTextField = "hotenngaysinh";
                ddlThamphan.DataValueField = "ID";
                ddlThamphan.DataBind();
            }
            else if (ddlLoaiThamPhan.SelectedValue == "2") // thẩm phán bậc 3
            {
                ddlThamphan.DataSource = oBL.THAMPHAN_GETBY_NC(ToaAnID, "1", PBID);
                ddlThamphan.DataTextField = "hotenngaysinh";
                ddlThamphan.DataValueField = "ID";
                ddlThamphan.DataBind();
            }
        }

        void LoadDropLoaiAn()
        {
            ddlLoaiAn.Items.Clear();
            DM_PHONGBAN obj = dt.DM_PHONGBAN.Where(x => x.ID == CurrPhongBanID).FirstOrDefault();
            
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
            //SetGetSessionTK(true);
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
            int sumTLM = 0;
            if (oDT.Rows.Count > 0)
            {
                count_all = Convert.ToInt32(oDT.Rows[0]["CountAll"] + "");
                DataTable oDT2 = getDS(10000, pageindex);
                for (int i = 0; i < oDT2.Rows.Count; i++)
                {
                    sumTLM = Convert.ToInt32(oDT2.Rows[i]["cThulymoi"]) + sumTLM;
                }
            }
            if (oDT != null && count_all > 0)
            {
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, Convert.ToInt32(ddlPageCount.SelectedValue)).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString("#,#", cul) + " </b> vụ án " + "<b>(" + sumTLM + " đơn TLM)</b>  trong <b>" + hddTotalPage.Value + "</b> trang";
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
                
                gridHS.Visible = false;
                dgList.Visible = true;
           
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
           
            DateTime? vNgayThulyTu = txtThuLy_TuNgay.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuLy_TuNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime? vNgayThulyDen = txtThuly_DenNgay.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_DenNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            string vSoThuly = txtThuly_So.Text;

            DateTime? vGQD_TuNgay = txtGQD_TuNgay.Text == "" ? (DateTime?)null : DateTime.Parse(txtGQD_TuNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime? vGQD_DenNgay = txtGQD_DenNgay.Text == "" ? (DateTime?)null : DateTime.Parse(txtGQD_DenNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            
            decimal vLoaiAnDB = Convert.ToDecimal(dropAnDB.SelectedValue);
            String LoaiAnDB_TH = dropAnDB_TH.SelectedValue;
            decimal vKetquathuly = Convert.ToDecimal(ddlKetquaThuLy.SelectedValue);
            decimal vKetquaxetxu = Convert.ToDecimal(ddlKetquaXX.SelectedValue);

            //int isTotrinh = Convert.ToInt16(ddlTotrinh.SelectedValue);
            //int isMuonHoSo = Convert.ToInt16(ddlMuonHoso.SelectedValue);
            int typetb = Convert.ToInt16(dropTypeTB.SelectedValue);
            int vLoaiNgay = Convert.ToInt16(dropLoaiNgay.SelectedValue);
            /*DataTable tbl =  oBL.GQD_VUAN_SEARCH(vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD, vNguyendon, vBidon, vLoaiAn
                                                , vThamtravien, vLanhdao, vThamphan, vNgayThulyTu, vNgayThulyDen, vSoThuly, vLoaiNgay, vGQD_TuNgay, vGQD_DenNgay
                                                , vKetquathuly, vKetquaxetxu, vLoaiAnDB, LoaiAnDB_TH, typetb
                                                , pageindex, page_size);*/
            //duongph 21/03/2022
            decimal _LoaiGDT = Convert.ToDecimal(ddlLoaiGDT.SelectedValue);
            DataTable tbl = oBL.GQD_VUAN_SEARCH(vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD, vNguyendon, vBidon, vLoaiAn
                                                , vThamtravien, vLanhdao, vThamphan, vNgayThulyTu, vNgayThulyDen, vSoThuly, vLoaiNgay, vGQD_TuNgay, vGQD_DenNgay
                                                , vKetquathuly, vKetquaxetxu, vLoaiAnDB, LoaiAnDB_TH, typetb, _LoaiGDT
                                                , pageindex, page_size);
            return tbl;
        }

        protected void cmdTimkiem_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
            //SetGetSessionTK(true);
        }
        
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal vuanid = 0;
            temp = "";
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            switch (e.CommandName)
            {  
                case "KETQUA": 
                    string[] arr = e.CommandArgument.ToString().Split('#');
                    if (arr.Length > 0)
                    {
                        vuanid = String.IsNullOrEmpty(arr[0] + "") ? 0 : Convert.ToDecimal(arr[0] + "");
                        int loaian = String.IsNullOrEmpty(arr[1] + "") ? 0 : Convert.ToInt16(arr[1] + "");
                        if (loaian != Convert.ToInt16(ENUM_LOAIVUVIEC.AN_HINHSU))
                            temp = "PopupReport('/QLAN/GDTTT/VuAn/Popup/Ketqua.aspx?vid=" + vuanid + "','Kết quả giải quyết',950,650);";
                        else
                        {
                            temp = "PopupReport('/QLAN/GDTTT/VuAn/Popup/pKetquaHS.aspx?vid=" + vuanid + "','Kết quả giải quyết',950,650);";
                        }
                    }
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), temp, true);
                    break;
                case "SoDonTrung":
                    temp = "PopupReport('/QLAN/GDTTT/VuAn/Popup/pDsDon.aspx?vID=" + e.CommandArgument + "','Danh sách đơn trùng',1000,500);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), temp, true);
                    break;
                case "CongVan81":
                    temp = "PopupReport('/QLAN/GDTTT/VuAn/Popup/DSDonQuocHoi.aspx?vID=" + e.CommandArgument + "','Danh sách công văn 8.1',1000,500);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), temp, true);
                    break;
                case "CHIDAO":
                    temp = "PopupReport('/QLAN/GDTTT/VuAn/Popup/DSDonChidao.aspx?vID=" + e.CommandArgument + "','Danh sách công văn 8.1',1000,500);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), temp, true);
                    break;
                case "ThongBaoTT":
                    temp = "PopupReport('/QLAN/GDTTT/VuAn/Popup/pThongBaoTT.aspx?vid=" + e.CommandArgument + "','Kết quả giải quyết',950,650);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), temp, true);
                    break;
            }
        }

        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                LinkButton cmdKetqua = (LinkButton)e.Item.FindControl("cmdKetqua");
                Cls_Comon.SetLinkButton(cmdKetqua, oPer.TAOMOI);

                DataRowView rv = (DataRowView)e.Item.DataItem;
                Decimal CurrVuAnID = Convert.ToDecimal(rv["ID"] + "");
                decimal trangthai_trinh_id = 0;

                Literal lttLanTT = (Literal)e.Item.FindControl("lttLanTT");
                Literal lttDetaiTinhTrang = (Literal)e.Item.FindControl("lttDetaiTinhTrang");

                int trangthai = String.IsNullOrEmpty(rv["TRANGTHAIID"] + "") ? 0 : Convert.ToInt32(rv["TRANGTHAIID"] + "");
                int GiaiDoan = String.IsNullOrEmpty(rv["GiaiDoan"] + "") ? 0 : Convert.ToInt32(rv["GiaiDoan"] + "");

                lttLanTT.Text = rv["TENTINHTRANG"] + "";
                switch(GiaiDoan)
                {
                    case 0:
                        #region phan cong TTV
                        decimal THAMTRAVIENID = (string.IsNullOrEmpty(rv["THAMTRAVIENID"] + "")) ? 0 : Convert.ToDecimal(rv["THAMTRAVIENID"]+"");
                        if (THAMTRAVIENID > 0)
                        {
                           // lttDetaiTinhTrang.Text = "Đã phân công TTV";
                            lttDetaiTinhTrang.Text = (string.IsNullOrEmpty(rv["NGAYPHANCONGTTV"] + "")) ? "" : "<br/>" + rv["NGAYPHANCONGTTV"].ToString() ;
                            lttDetaiTinhTrang.Text += (string.IsNullOrEmpty(rv["QUATRINH_GHICHU"] + "")) ? "" : "<br/>" + rv["QUATRINH_GHICHU"] + "";
                        }
                        //else
                        //    lttDetaiTinhTrang.Text = "Chưa phân công TTV";
                        #endregion
                        break;
                    case 1:break;
                    case 2:
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
                                    lttDetaiTinhTrang.Text = "<br/>" + Convert.ToDateTime(objTT.NGAYTRINH).ToString("dd/MM/yyyy", cul);
                                if (!string.IsNullOrEmpty(objTT.NGAYTRA + "") || (DateTime)objTT.NGAYTRA != DateTime.MinValue)
                                    lttDetaiTinhTrang.Text += "<br/><span style='margin-right:10px;'>Ngày trả: " + Convert.ToDateTime(objTT.NGAYTRA).ToString("dd/MM/yyyy", cul) + "</span>";

                                lttDetaiTinhTrang.Text += (string.IsNullOrEmpty(lttDetaiTinhTrang.Text)) ? "" : "<br/>";
                                lttDetaiTinhTrang.Text += objTT.YKIEN + "";
                            }
                        }
                        catch (Exception ex) { }
                        #endregion
                        break;
                    case 3:
                        #region ket qua giai quyet don & ThuLy XX GDTTT
                        if ( trangthai != 15)
                        {
                            int loai_giaiquyet_don = (string.IsNullOrEmpty(rv["KQ_GQD_ID"] + "")) ? 5 : Convert.ToInt16(rv["KQ_GQD_ID"] + "");
                            if (loai_giaiquyet_don <= 3)
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
                                        if (loai_giaiquyet_don == 3)
                                        {
                                            temp += (string.IsNullOrEmpty(rv["GQD_NGAYPHATHANHCV"] + "") || rv["GQD_NGAYPHATHANHCV"].ToString() == "01/01/0001") ? "" : " - " + rv["GQD_NGAYPHATHANHCV"].ToString();
                                            if (rv["GQD_KETQUA"] + "" != "")
                                                temp += "<br/> " + rv["GQD_KETQUA"] + "";
                                        }
                                        else
                                        {
                                            temp += (string.IsNullOrEmpty(rv["GQD_NGAYPHATHANHCV"] + "") || rv["GQD_NGAYPHATHANHCV"].ToString() == "01/01/0001") ? "" : "<br/>Ngày phát hành:" + rv["GQD_NGAYPHATHANHCV"].ToString();
                                        }
                                        //lttDetaiTinhTrang.Text = temp;
                                        //----Có kết quả trả lời đơn---------------
                                        List<GDTTT_DON_TRALOI> lstTLD = dt.GDTTT_DON_TRALOI.Where(x => x.VUANID == CurrVuAnID && x.TYPETB == 3).ToList();
                                        if (lstTLD.Count > 0)
                                            temp += "</br> <b><b>Trả lời đơn </b></b> </br>" + rv["AHS_ThongTinGQD"] + "";
                                        
                                        lttDetaiTinhTrang.Text = temp;
                                    }

                                }
                                else
                                {
                                   
                                    if (loai_giaiquyet_don == 3)
                                    {
                                        lttLanTT.Text = "<b>" + rv["KQ_GQD"] + " " + rv["LoaiKN"].ToString() + " </b>";
                                        temp += String.IsNullOrEmpty(rv["GDQ_SO"] + "") ? "" : ("<span style=''>Số: <b>" + rv["GDQ_SO"].ToString() + "</b></span>");
                                        temp += (string.IsNullOrEmpty(rv["GQD_NGAYPHATHANHCV"] + "") || rv["GQD_NGAYPHATHANHCV"].ToString() == "01/01/0001") ? "" : " - Ngày:" + rv["GQD_NGAYPHATHANHCV"].ToString();
                                        if(rv["GQD_KETQUA"] + ""!="")
                                        temp += "<br/> "+ rv["GQD_KETQUA"] + "";
                                    }
                                    else
                                    {
                                        lttLanTT.Text = "<b>" + rv["KQ_GQD"] + " " + rv["LoaiKN"].ToString() + " </b>";
                                        temp = String.IsNullOrEmpty(rv["GDQ_SO"] + "") ? "" : ("<span style=''>Số: <b>" + rv["GDQ_SO"].ToString() + "</b></span>");
                                        temp += (String.IsNullOrEmpty(temp) ? "" : (string.IsNullOrEmpty(rv["GDQ_NGAY"] + "")) ? "" : ("<br/>Ngày: <b>" + rv["GDQ_NGAY"].ToString() + "</b>"));
                                        temp += (string.IsNullOrEmpty(rv["GQD_NGAYPHATHANHCV"] + "") || rv["GQD_NGAYPHATHANHCV"].ToString() == "01/01/0001") ? "" : "<br/>Ngày phát hành:" + rv["GQD_NGAYPHATHANHCV"].ToString();
                                    }

                                    //lttDetaiTinhTrang.Text = temp;
                                    //----Có kết quả trả lời đơn---------------
                                    List<GDTTT_VUAN_KETQUA> lstTLDs = DataExtensions.GetAllByVuAnId<GDTTT_VUAN_KETQUA>(CurrVuAnID);
                                    lstTLDs = lstTLDs.Where(o => o.TRANGTHAI == 1 && o.CAPNHATVUAN == 0).ToList();
                                    if (lstTLDs.Count > 0)
                                    {
                                        foreach (var lstTLD in lstTLDs)
                                        {
                                            if (lstTLD.GQD_LOAIKETQUA == 0)
                                            {
                                                temp += "</br> <b><b>Trả lời đơn </b></b> </br>" + "";
                                                temp += lstTLD.GDQ_SO == null ? "" : ("<span style=''>Số: <b>" + lstTLD.GDQ_SO.ToString() + "</b></span>");
                                                temp += (String.IsNullOrEmpty(temp) ? "" : (lstTLD.GDQ_NGAY == null) ? "" : ("<br/>Ngày: <b>" + lstTLD.GDQ_NGAY.Value.ToString("dd/MM/yyyy") + "</b>"));
                                                temp += ((lstTLD.GQD_NGAYPHATHANHCV == null) || lstTLD.GQD_NGAYPHATHANHCV.ToString() == "01/01/0001") ? "" : "<br/>Ngày phát hành:" + lstTLD.GQD_NGAYPHATHANHCV.Value.ToString("dd/MM/yyyy");
                                            }
                                            else if (lstTLD.GQD_LOAIKETQUA == 1)
                                            {
                                                temp += "</br> <b><b>Kháng nghị </b></b> </br>" + "";
                                                temp += lstTLD.GDQ_SO == null ? "" : ("<span style=''>Số: <b>" + lstTLD.GDQ_SO.ToString() + "</b></span>");
                                                temp += (String.IsNullOrEmpty(temp) ? "" : (lstTLD.GDQ_NGAY == null) ? "" : ("<br/>Ngày: <b>" + lstTLD.GDQ_NGAY.Value.ToString("dd/MM/yyyy") + "</b>"));
                                                temp += ((lstTLD.GQD_NGAYPHATHANHCV == null) || lstTLD.GQD_NGAYPHATHANHCV.ToString() == "01/01/0001") ? "" : "<br/>Ngày phát hành:" + lstTLD.GQD_NGAYPHATHANHCV.Value.ToString("dd/MM/yyyy");
                                            }
                                            else if (lstTLD.GQD_LOAIKETQUA == 2)
                                            {
                                                temp += "</br> <b><b>Xếp đơn </b></b> </br>" + "";
                                                temp += lstTLD.GDQ_SO == null ? "" : ("<span style=''>Số: <b>" + lstTLD.GDQ_SO.ToString() + "</b></span>");
                                                temp += (String.IsNullOrEmpty(temp) ? "" : (lstTLD.GDQ_NGAY == null) ? "" : ("<br/>Ngày: <b>" + lstTLD.GDQ_NGAY.Value.ToString("dd/MM/yyyy") + "</b>"));
                                                temp += ((lstTLD.GQD_NGAYPHATHANHCV == null) || lstTLD.GQD_NGAYPHATHANHCV.ToString() == "01/01/0001") ? "" : "<br/>Ngày phát hành:" + lstTLD.GQD_NGAYPHATHANHCV.Value.ToString("dd/MM/yyyy");
                                            }
                                            else if (lstTLD.GQD_LOAIKETQUA == 3)
                                            {
                                                temp += "</br> <b><b>Xử lý khác </b></b> </br>" + "";
                                                temp += lstTLD.GDQ_SO == null ? "" : ("<span style=''>Số: <b>" + lstTLD.GDQ_SO.ToString() + "</b></span>");
                                                temp += (String.IsNullOrEmpty(temp) ? "" : (lstTLD.GDQ_NGAY == null) ? "" : ("<br/>Ngày: <b>" + lstTLD.GDQ_NGAY.Value.ToString("dd/MM/yyyy") + "</b>"));
                                                temp += ((lstTLD.GQD_NGAYPHATHANHCV == null) || lstTLD.GQD_NGAYPHATHANHCV.ToString() == "01/01/0001") ? "" : "<br/>Ngày phát hành:" + lstTLD.GQD_NGAYPHATHANHCV.Value.ToString("dd/MM/yyyy");
                                            }
                                            else if (lstTLD.GQD_LOAIKETQUA == 4)
                                            {
                                                temp += "</br> <b><b>VKS giải quyết </b></b> </br>" + "";
                                                temp += lstTLD.GDQ_SO == null ? "" : ("<span style=''>Số: <b>" + lstTLD.GDQ_SO.ToString() + "</b></span>");
                                                temp += (String.IsNullOrEmpty(temp) ? "" : (lstTLD.GDQ_NGAY == null) ? "" : ("<br/>Ngày: <b>" + lstTLD.GDQ_NGAY.Value.ToString("dd/MM/yyyy") + "</b>"));
                                                temp += ((lstTLD.GQD_NGAYPHATHANHCV == null) || lstTLD.GQD_NGAYPHATHANHCV.ToString() == "01/01/0001") ? "" : "<br/>Ngày phát hành:" + lstTLD.GQD_NGAYPHATHANHCV.Value.ToString("dd/MM/yyyy");
                                            }
                                        }
                                    }
                                    lttDetaiTinhTrang.Text = temp;
                                    lttDetaiTinhTrang.Text = temp;
                                }
                            }
                            else if (loai_giaiquyet_don == 4)
                                lttLanTT.Text = "<b>Thông báo VKS " + " </b><br/>" + rv["KQ_GQD"];
                            else
                                lttLanTT.Text = "<b>KQGQ_THS: " + " </b>" + rv["KQ_GQD"];
                        }
                        else
                        {
                            lttDetaiTinhTrang.Text = String.IsNullOrEmpty(rv["SOTHULYXXGDT"] + "") ? "" : ("<span style='padding-right:10px;'>Số: <b>" + rv["SOTHULYXXGDT"].ToString() + "</b></span>");
                            lttDetaiTinhTrang.Text += (string.IsNullOrEmpty(rv["NGAYTHULYXXGDT"] + "")) ? "" : ("Ngày: <b>" + rv["NGAYTHULYXXGDT"].ToString() + "</b>");
                        }
                        #endregion
                        break;
                }
                // Hiển thị tất cả TTV đã tham gia vụ án-------------------------------
                if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
                {
                    DataRowView rvttv = (DataRowView)e.Item.DataItem;
                    string strID = e.Item.Cells[0].Text;

                    Literal lttTTV = (Literal)e.Item.FindControl("lttTTV");

                    int count = 0;
                    string StrDisplay = "", temp = "";
                    string[] arr = null;
                    //Decimal CurrVuAnID = Convert.ToDecimal(hddCurrID.Value);
                    String PhanCongTTV = rvttv["PHANCONGTTV"] + "";
                    if (!String.IsNullOrEmpty(PhanCongTTV))
                    {
                        lttTTV.Text = " TTV: <b>" + rvttv["TenThamTraVien"] + (String.IsNullOrEmpty(rvttv["NGAYPHANCONGTTV"] + "") ? "" : (" (" + rv["NGAYPHANCONGTTV"] + ")")) + "</b>";
                        arr = PhanCongTTV.Split("*".ToCharArray());
                        foreach (String str in arr)
                        {
                            if (str != "")
                            {
                                if (count == 0)
                                    StrDisplay = "-" + (str.Replace(" - ", " - " + temp));
                                else
                                    StrDisplay += "<br/>- " + str;
                                count++;
                            }
                        }

                    }
                    else lttTTV.Text = " TTV: <b>" + rv["TENTHAMTRAVIEN"] + "</b>";
                    lttTTV.Text += (string.IsNullOrEmpty(StrDisplay) ? "" : "<br/>") + "<i>" + StrDisplay + "</i>";

                    //---------------------

                }
                //-------------------------------
                Literal lttKQGQ = (Literal)e.Item.FindControl("lttKQGQ");
                int IsHoanTHA = Convert.ToInt16(rv["GQD_ISHOANTHA"] + ""); 
                if (IsHoanTHA>0)
                {
                    lttKQGQ.Text = "<span class='line_space'>";
                    lttKQGQ.Text += "<b>Hoãn thi hành án</b>" + "<br/>";
                    lttKQGQ.Text += "Số: " + rv["GQD_HOANTHA_SO"].ToString() + "<br/>";
                    lttKQGQ.Text += "Ngày: " + rv["GQD_HOANTHA_NGAY"].ToString() + "<br/>";
                    lttKQGQ.Text += "";
                    lttKQGQ.Text += "</span>";
                }
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

            dropAnDB.SelectedIndex = 0;
            dropAnDB_TH.SelectedIndex = 0;
            txtGQD_TuNgay.Text = "";
            txtGQD_DenNgay.Text = "";
            txtThuly_So.Text = "";
            
            ddlKetquaThuLy.SelectedIndex = 0;
            ddlKetquaXX.SelectedIndex = 0;
            SetVisible_SearchDateTime();
            dropLoaiNgay.SelectedValue = "0";
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
      
        protected void ddlLoaiAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
           
            Load_Data();
            // LoadDropQHPL();
        }
        protected void ddlMuonHoso_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao(); 
        }
        
        protected void dropAnDB_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();

            if (dropAnDB.SelectedValue == "1")
                dropTypeTB.Enabled = true;
            else
            {
                Cls_Comon.SetValueComboBox(dropTypeTB, 0);
                dropTypeTB.Enabled = false;
            }
        }
        protected void ddlKetquaThuLy_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
            SetVisible_SearchDateTime();
        }
        void SetVisible_SearchDateTime()
        {
            string ketqua = ddlKetquaThuLy.SelectedValue;
            if (ketqua == "3") 
            {
                txtGQD_TuNgay.Text = txtGQD_DenNgay.Text = "";
                dropLoaiNgay.Enabled = false;
                lblTuNgay.Enabled = txtGQD_TuNgay.Enabled = false;
                lblDenNgay.Enabled = txtGQD_DenNgay.Enabled = false;
            }
            else if (ketqua == "4")
            {
                dropLoaiNgay.Enabled = true;
                txtGQD_TuNgay.Text = "";
                lblTuNgay.Enabled = txtGQD_TuNgay.Enabled = false;                
                lblDenNgay.Enabled = txtGQD_DenNgay.Enabled = true;
            }
            else
            {
                dropLoaiNgay.Enabled = true;
                lblTuNgay.Enabled = txtGQD_TuNgay.Enabled = true;
                lblDenNgay.Enabled = txtGQD_DenNgay.Enabled = true;
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
        }
        protected void dropIsYKienKetLuatTrinhLD_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
        }

        void SetTieuDeBaoCao()
        {
            string tieudebc = "";
            //-------------------------------------
            if (ddlLoaiAn.SelectedValue != "0")
                tieudebc += " " + ddlLoaiAn.SelectedItem.Text.ToLower();
            if (dropAnDB.SelectedValue != "0")
                tieudebc += " là " + dropAnDB.SelectedItem.Text.ToLower();
            //-------------------------------------
            String canbophutrach = "";
            if (ddlThamphan.SelectedValue != "0")
                canbophutrach = "thẩm phán " + Cls_Comon.FormatTenRieng(ddlThamphan.SelectedItem.Text);
            
            if (ddlPhoVuTruong.SelectedValue != "0")
                canbophutrach += ((string.IsNullOrEmpty(canbophutrach)) ? "" : ", ") + "lãnh đạo Vụ " + ddlPhoVuTruong.SelectedItem.Text;

            if (!String.IsNullOrEmpty(canbophutrach))
                canbophutrach += " phụ trách";

            tieudebc += (string.IsNullOrEmpty(canbophutrach)) ? "" : " do " + canbophutrach;
            //-------------------------------------
            if (ddlKetquaThuLy.SelectedValue != "3")
            {
                if (ddlKetquaThuLy.SelectedValue == "4")
                    tieudebc += " chưa có kết quả giải quyết";
                else
                    tieudebc += " có kết quả giải quyết là " + ddlKetquaThuLy.SelectedItem.Text.Replace("...", "").ToLower();
            }
            txtTieuDeBC.Text = "Danh sách các vụ án" + tieudebc.Replace("...", "");
        }
        protected void cmdPrint_Click_older(object sender, EventArgs e)
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
            DataTable tbl = getDS(3000000, 1);
            Session[SessionName] = tbl;
            string URL = "/QLAN/GDTTT/VuAn/BaoCao/ViewBC.aspx" + (string.IsNullOrEmpty(Parameter) ? "" : "?" + Parameter);
            Cls_Comon.CallFunctionJS(this, this.GetType(), "PopupReport('" + URL + "','In báo cáo',1000,600)");

        }
        //anhvh add 20/12/2019
        protected void cmdPrint_Click(object sender, EventArgs e)
        {
            try
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

                DateTime? vNgayThulyTu = txtThuLy_TuNgay.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuLy_TuNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime? vNgayThulyDen = txtThuly_DenNgay.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_DenNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                string vSoThuly = txtThuly_So.Text;

                DateTime? vGQD_TuNgay = txtGQD_TuNgay.Text == "" ? (DateTime?)null : DateTime.Parse(txtGQD_TuNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime? vGQD_DenNgay = txtGQD_DenNgay.Text == "" ? (DateTime?)null : DateTime.Parse(txtGQD_DenNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);

                decimal vLoaiAnDB = Convert.ToDecimal(dropAnDB.SelectedValue);
                String LoaiAnDB_TH = dropAnDB_TH.SelectedValue;
                decimal vKetquathuly = Convert.ToDecimal(ddlKetquaThuLy.SelectedValue);
                decimal vKetquaxetxu = Convert.ToDecimal(ddlKetquaXX.SelectedValue);

                //int isTotrinh = Convert.ToInt16(ddlTotrinh.SelectedValue);
                //int isMuonHoSo = Convert.ToInt16(ddlMuonHoso.SelectedValue);
                int typetb = Convert.ToInt16(dropTypeTB.SelectedValue);
                int vLoaiNgay = Convert.ToInt16(dropLoaiNgay.SelectedValue);
                DataTable tbl = null;
                /*tbl = oBL.GQD_VUAN_SEARCH_PRINT(vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD, vNguyendon, vBidon, vLoaiAn
                                                   , vThamtravien, vLanhdao, vThamphan, vNgayThulyTu, vNgayThulyDen, vSoThuly, vLoaiNgay, vGQD_TuNgay, vGQD_DenNgay
                                                   , vKetquathuly, vKetquaxetxu, vLoaiAnDB, LoaiAnDB_TH, typetb
                                                   , 0, 0);*/

                //duongph 21/03/2022
                decimal _LoaiGDT = Convert.ToDecimal(ddlLoaiGDT.SelectedValue);
                tbl = oBL.GQD_VUAN_SEARCH_PRINT(vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD, vNguyendon, vBidon, vLoaiAn
                                                   , vThamtravien, vLanhdao, vThamphan, vNgayThulyTu, vNgayThulyDen, vSoThuly, vLoaiNgay, vGQD_TuNgay, vGQD_DenNgay
                                                   , vKetquathuly, vKetquaxetxu, vLoaiAnDB, LoaiAnDB_TH, typetb, _LoaiGDT
                                                   , 0, 0);
                
                //-----------------------------------------
                Literal Table_Str_Totals = new Literal();
                DataRow row = tbl.NewRow();
                //-----------
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                }
                string loaitoa = Session[ENUM_SESSION.SESSION_TENDONVI]+"";
                if (loaitoa.Contains("cấp cao"))
                {
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=BC_VUAN_GDTTT.xls");
                    Response.Cache.SetCacheability(HttpCacheability.NoCache);
                    Response.ContentType = "application/vnd.xls";
                    System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                    System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                    htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                    //Response.Write(AddExcelStyling(2, INSERT_PAGE_BREAK));   // add the style props to get the page orientation
                    Table_Str_Totals.RenderControl(htmlWrite);
                    Response.Write(stringWrite.ToString());
                    Response.Write("</body>");   // add the style props to get the page orientation
                    Response.Write("</html>");   // add the style props to get the page orientation
                    Response.End();
                }
                else
                {
                    //--------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=BC_VUAN_TT_GDTTT.doc");
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
                    Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.2in 0.2in 0.5in 0.2in;mso-header: h1;mso-header-margin:.2in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
                    //Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5in 1.0in 0.5in 1.0in;mso-header-margin:.1in;mso-footer-margin:.1in;mso-paper-source:0;}");
                    Response.Write("div.Section2 {page:Section2;}");
                    Response.Write("<style>");
                    Response.Write("</head>");
                    Response.Write("<body>");
                    Response.Write("<div class=Section2>");//chỉ định khổ giấy
                    System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                    System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                    htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                    Table_Str_Totals.RenderControl(htmlWrite);
                    Response.Write(stringWrite.ToString());
                    Response.Write("</div>");
                    Response.Write("</body>");
                    Response.Write("</html>");
                    Response.End();
                }
                
            }
            catch (Exception ex)
            {
                lbtthongbao.Text = ex.Message;
            }
        }

        protected void cmdPrintBC_Click(object sender, EventArgs e)
        {
            try
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

                DateTime? vNgayThulyTu = txtThuLy_TuNgay.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuLy_TuNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime? vNgayThulyDen = txtThuly_DenNgay.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_DenNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                string vSoThuly = txtThuly_So.Text;

                DateTime? vGQD_TuNgay = txtGQD_TuNgay.Text == "" ? (DateTime?)null : DateTime.Parse(txtGQD_TuNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime? vGQD_DenNgay = txtGQD_DenNgay.Text == "" ? (DateTime?)null : DateTime.Parse(txtGQD_DenNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);

                decimal vLoaiAnDB = Convert.ToDecimal(dropAnDB.SelectedValue);
                String LoaiAnDB_TH = dropAnDB_TH.SelectedValue;
                decimal vKetquathuly = Convert.ToDecimal(ddlKetquaThuLy.SelectedValue);
                decimal vKetquaxetxu = Convert.ToDecimal(ddlKetquaXX.SelectedValue);

                //int isTotrinh = Convert.ToInt16(ddlTotrinh.SelectedValue);
                //int isMuonHoSo = Convert.ToInt16(ddlMuonHoso.SelectedValue);
                int typetb = Convert.ToInt16(dropTypeTB.SelectedValue);
                int vLoaiNgay = Convert.ToInt16(dropLoaiNgay.SelectedValue);
                DataTable tbl = null;
                tbl = oBL.GQD_VUAN_SEARCH_PRINT_BC(vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD, vNguyendon, vBidon, vLoaiAn
                                                   , vThamtravien, vLanhdao, vThamphan, vNgayThulyTu, vNgayThulyDen, vSoThuly, vLoaiNgay, vGQD_TuNgay, vGQD_DenNgay
                                                   , vKetquathuly, vKetquaxetxu, vLoaiAnDB, LoaiAnDB_TH, typetb,3
                                                   , 0, 0);
                //-----------------------------------------
                Literal Table_Str_Totals = new Literal();
                DataRow row = tbl.NewRow();
                //-----------
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                }
                string loaitoa = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                if (loaitoa.Contains("cấp cao"))
                {
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=BC_VUAN_GDTTT.xls");
                    Response.Cache.SetCacheability(HttpCacheability.NoCache);
                    Response.ContentType = "application/vnd.xls";
                    System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                    System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                    htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                    //Response.Write(AddExcelStyling(2, INSERT_PAGE_BREAK));   // add the style props to get the page orientation
                    Table_Str_Totals.RenderControl(htmlWrite);
                    Response.Write(stringWrite.ToString());
                    Response.Write("</body>");   // add the style props to get the page orientation
                    Response.Write("</html>");   // add the style props to get the page orientation
                    Response.End();
                }
                else
                {
                    //--------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=BC_VUAN_TT_GDTTT.doc");
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
                    Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.2in 0.2in 0.5in 0.2in;mso-header: h1;mso-header-margin:.2in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
                    //Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5in 1.0in 0.5in 1.0in;mso-header-margin:.1in;mso-footer-margin:.1in;mso-paper-source:0;}");
                    Response.Write("div.Section2 {page:Section2;}");
                    Response.Write("<style>");
                    Response.Write("</head>");
                    Response.Write("<body>");
                    Response.Write("<div class=Section2>");//chỉ định khổ giấy
                    System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                    System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                    htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                    Table_Str_Totals.RenderControl(htmlWrite);
                    Response.Write(stringWrite.ToString());
                    Response.Write("</div>");
                    Response.Write("</body>");
                    Response.Write("</html>");
                    Response.End();
                }
            }
            catch (Exception ex)
            {
                lbtthongbao.Text = ex.Message;
            }
        }

        protected void cmdPrintBC5_Click(object sender, EventArgs e)
        {
            try
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

                DateTime? vNgayThulyTu = txtThuLy_TuNgay.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuLy_TuNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime? vNgayThulyDen = txtThuly_DenNgay.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_DenNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                string vSoThuly = txtThuly_So.Text;

                DateTime? vGQD_TuNgay = txtGQD_TuNgay.Text == "" ? (DateTime?)null : DateTime.Parse(txtGQD_TuNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime? vGQD_DenNgay = txtGQD_DenNgay.Text == "" ? (DateTime?)null : DateTime.Parse(txtGQD_DenNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);

                decimal vLoaiAnDB = Convert.ToDecimal(dropAnDB.SelectedValue);
                String LoaiAnDB_TH = dropAnDB_TH.SelectedValue;
                decimal vKetquathuly = Convert.ToDecimal(ddlKetquaThuLy.SelectedValue);
                decimal vKetquaxetxu = Convert.ToDecimal(ddlKetquaXX.SelectedValue);

                //int isTotrinh = Convert.ToInt16(ddlTotrinh.SelectedValue);
                //int isMuonHoSo = Convert.ToInt16(ddlMuonHoso.SelectedValue);
                int typetb = Convert.ToInt16(dropTypeTB.SelectedValue);
                int vLoaiNgay = Convert.ToInt16(dropLoaiNgay.SelectedValue);
                DataTable tbl = null;
                tbl = oBL.GQD_VUAN_SEARCH_PRINT_BC(vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD, vNguyendon, vBidon, vLoaiAn
                                                   , vThamtravien, vLanhdao, vThamphan, vNgayThulyTu, vNgayThulyDen, vSoThuly, vLoaiNgay, vGQD_TuNgay, vGQD_DenNgay
                                                   , vKetquathuly, vKetquaxetxu, vLoaiAnDB, LoaiAnDB_TH, typetb, 5
                                                   , 0, 0);
                //-----------------------------------------
                Literal Table_Str_Totals = new Literal();
                DataRow row = tbl.NewRow();
                //-----------
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                }
                string loaitoa = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                if (loaitoa.Contains("cấp cao"))
                {
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=BC_VUAN_GDTTT.xls");
                    Response.Cache.SetCacheability(HttpCacheability.NoCache);
                    Response.ContentType = "application/vnd.xls";
                    System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                    System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                    htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                    //Response.Write(AddExcelStyling(2, INSERT_PAGE_BREAK));   // add the style props to get the page orientation
                    Table_Str_Totals.RenderControl(htmlWrite);
                    Response.Write(stringWrite.ToString());
                    Response.Write("</body>");   // add the style props to get the page orientation
                    Response.Write("</html>");   // add the style props to get the page orientation
                    Response.End();
                }
                else
                {
                    //--------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=BC_VUAN_TT_GDTTT.doc");
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
                    Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.2in 0.2in 0.5in 0.2in;mso-header: h1;mso-header-margin:.2in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
                    //Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5in 1.0in 0.5in 1.0in;mso-header-margin:.1in;mso-footer-margin:.1in;mso-paper-source:0;}");
                    Response.Write("div.Section2 {page:Section2;}");
                    Response.Write("<style>");
                    Response.Write("</head>");
                    Response.Write("<body>");
                    Response.Write("<div class=Section2>");//chỉ định khổ giấy
                    System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                    System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                    htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                    Table_Str_Totals.RenderControl(htmlWrite);
                    Response.Write(stringWrite.ToString());
                    Response.Write("</div>");
                    Response.Write("</body>");
                    Response.Write("</html>");
                    Response.End();
                }
            }
            catch (Exception ex)
            {
                lbtthongbao.Text = ex.Message;
            }
        }

    }
}
