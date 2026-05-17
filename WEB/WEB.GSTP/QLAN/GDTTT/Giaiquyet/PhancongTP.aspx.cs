using BL.GSTP;
using BL.GSTP.GDTTT;
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
namespace WEB.GSTP.QLAN.GDTTT.Giaiquyet
{
    public partial class PhancongTP : System.Web.UI.Page
    {
        //--
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
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if ((Session["TTBCVISIBLE"] + "") == "0")
                {
                    lbtTTBC.Text = "[ Mở ]";
                    pnTTBC.Visible = false;
                }
                if ((Session["TTTKVISIBLE"] + "") == "0")
                {
                    lbtTTTK.Text = "[ Thu gọn ]";
                    pnTTTK.Visible = true;
                }
                LoadDrop();

                Load_Data();
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            }
        }
        private void LoadDrop()
        {
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

            DM_TOAAN_BL oTABL = new DM_TOAAN_BL();
            DataTable dtTA = oTABL.DM_TOAAN_GETBYNOTCUR(0, 0);
            ddlToaXetXu.DataSource = dtTA;
            ddlToaXetXu.DataTextField = "MA_TEN";
            ddlToaXetXu.DataValueField = "ID";
            ddlToaXetXu.DataBind();
            ddlToaXetXu.Items.Insert(0, new ListItem("--- Chọn --- ", "0"));

            //Loại án
            ddlLoaiAn.Items.Clear();
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID); ;
            DM_PHONGBAN obj = dt.DM_PHONGBAN.Where(x => x.ID == PBID).FirstOrDefault() ?? new DM_PHONGBAN();
                if (obj.ISHINHSU == 1)
                {
                    ddlLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
                    labelNguyenDon.Text = "Bị cáo";
                    labelBiDon.Visible = txtBidon.Visible = false;
                }
                else
                {
                    labelNguyenDon.Text = "Nguyên đơn";
                    labelBiDon.Visible = txtBidon.Visible = true;
                }
                if (obj.ISDANSU == 1) ddlLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
                if (obj.ISHANHCHINH == 1) ddlLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
                if (obj.ISHNGD == 1) ddlLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
                if (obj.ISKDTM == 1) ddlLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
                if (obj.ISLAODONG == 1) ddlLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
                //if (obj.ISPHASAN == 1) ddlLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC.AN_PHASAN));
                if (ddlLoaiAn.Items.Count > 1 && obj.ISHINHSU != 1)
                    ddlLoaiAn.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
            
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
                    {
                        ddlThamphan.Items.Add(new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                        hddLoaiTK.Value = ENUM_CHUCDANH.CHUCDANH_THAMPHAN;
                    }
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
                DataTable tbl = oGDTBL.GDTTT_VuAn_GetAllCBTheoPB(LoginDonViID, PBID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                foreach (DataRow drow in tbl.Rows)
                {
                    if (Convert.ToDecimal(drow["HieuLuc"])==0)
                    {
                        drow.Delete();//Mark a row for deletion.
                    }
                    
                }
                tbl.AcceptChanges();
                ddlThamphan.DataSource = tbl;
                ddlThamphan.DataTextField = "HOTEN";
                ddlThamphan.DataValueField = "ID";
                ddlThamphan.DataBind();
                ddlThamphan.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
                ddlThamphan.Items.Insert(1, new ListItem("--- Chưa có thẩm phán ---", "-1"));
            }
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
            decimal vLanhdao = Convert.ToDecimal(ddlPhoVuTruong.SelectedValue); ;
            decimal vThamphan = Convert.ToDecimal(ddlThamphan.SelectedValue); ;
            decimal vQHPLID = 0; //Convert.ToDecimal(ddlQHPLTK.SelectedValue); ;
            decimal vQHPLDNID = 0;// Convert.ToDecimal(ddlQHPLDN.SelectedValue); ;

            DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            string vSoThuly = txtThuly_So.Text;
            decimal vTrangthai = Convert.ToDecimal(rdbPhancongThamtravien.SelectedValue);
            decimal vGiaidoan = Convert.ToDecimal(ddlGiaidoan.SelectedValue);
            //anhvh phân quyên liên quan đến án tử hình
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            decimal _ISXINANGIAM = Convert.ToDecimal(oPer.ISXINANGIAM);
            decimal _GDT_ISXINANGIAM = Convert.ToDecimal(oPer.GDT_ISXINANGIAM);
            //--------------
            DataTable oDT = oBL.VUAN_PHANCONGTP(vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD,
               vNguyendon, vBidon, vLoaiAn, vThamtravien, vLanhdao, vThamphan,
               vQHPLID, vQHPLDNID, vNgayThulyTu, vNgayThulyDen, vSoThuly,
               vTrangthai, _ISXINANGIAM, _GDT_ISXINANGIAM, vGiaidoan, pageindex, page_size);
            return oDT;
        }
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
                labelNguyenDon.Text = "Bị cáo";
                labelBiDon.Visible = txtBidon.Visible = false;
            }
            else
            {
                dgList.PageSize = Convert.ToInt32(ddlPageCount.SelectedValue);
                dgList.DataSource = oDT;
                dgList.DataBind();
                dgList.Visible = true; gridHS.Visible = false;
                labelNguyenDon.Text = "Nguyên đơn";
                labelBiDon.Visible = txtBidon.Visible = true;
            }
        }
        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {

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

        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
            {
                DataRowView rv = (DataRowView)e.Item.DataItem;
                string strID = e.Item.Cells[0].Text;
                string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
                decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);

                //-------------------------------

                DropDownList ddlTTV = (DropDownList)e.Item.FindControl("ddlTTV");
                //DM_CANBO_BL objCBBL = new DM_CANBO_BL();
                //DataTable oTTVDT = objCBBL.DM_CANBO_GetTTVTheoPhongBan(PBID, "TTV");
                Decimal LoginDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();
                DataTable oTTVDT = oGDTBL.GDTTT_VuAn_GetAllCBTheoPB(LoginDonViID, PBID, ENUM_CHUCDANH.CHUCDANH_TTV);
                ddlTTV.DataSource = oTTVDT;
                ddlTTV.DataTextField = "HoTen";
                ddlTTV.DataValueField = "ID";

                ddlTTV.DataBind();
                ddlTTV.Items.Insert(0, new ListItem("Chọn", "0"));
                ddlTTV.ToolTip = strID;
                try
                {
                    //--------------
                    String ttvID = "0";
                    String vNgaypc = "";
                    if (ddlGiaidoan.SelectedValue == "0" || ddlGiaidoan.SelectedValue == "2")
                    {
                        ttvID = (String.IsNullOrEmpty(rv["XXGDT_THAMTRAVIENID"] + "") ? "0" : rv["XXGDT_THAMTRAVIENID"] + "");
                        vNgaypc = ((String.IsNullOrEmpty(rv["XXGDT_NGAYPHANCONGTTV"] + "") || rv["XXGDT_NGAYPHANCONGTTV"].ToString() == "01/01/0001") ? "" : rv["XXGDT_NGAYPHANCONGTTV"] + "");
                        if (ttvID == "0")
                            ttvID = (String.IsNullOrEmpty(rv["THAMTRAVIENID"] + "") ? "0" : rv["THAMTRAVIENID"] + "");

                    }
                    else
                        ttvID = (String.IsNullOrEmpty(rv["THAMTRAVIENID"] + "") ? "0" : rv["THAMTRAVIENID"] + "");
                    ddlTTV.SelectedValue = ttvID;
                    //----------------- 
                    //HiddenField hddTTVID = (HiddenField)e.Item.FindControl("hddTTVID");

                    //ddlTTV.SelectedValue = hddTTVID.Value;
                }
                catch (Exception ex) { }

                //------------------------------------------

                DropDownList ddlLDV = (DropDownList)e.Item.FindControl("ddlLDV");
                DataTable oTLDDT = new DataTable();
                //if (PBID == 2 || PBID == 3 || PBID == 4)//vụ giám đốc kiểm tra
                //{
                //    oTLDDT = oDMCBBL.CANBO_GETBYDONVI_2CHUCVU(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), PBID, ENUM_CHUCVU.CHUCVU_PVT, ENUM_CHUCVU.CHUCVU_VT);
                //}
                //else//phòng giám đốc kiểm tra của tòa cấp cao
                //{//'042','043','041','059' Phó Trưởng phòng,Quyền Trưởng phòng,Trưởng phòng,Phó Trưởng phòng phụ trách
                //    oTLDDT = oDMCBBL.CANBO_GETBYDONVI_LANHDAO(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), PBID, ",042,043,041,059,");
                //}
                DataTable tbl = oGDTBL.GDTTT_VuAn_GetAllCBTheoPB(LoginDonViID, PBID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                foreach (DataRow drow in tbl.Rows)
                {
                    if (Convert.ToDecimal(drow["HieuLuc"]) == 0)
                    {
                        drow.Delete();//Mark a row for deletion.
                    }

                }
                tbl.AcceptChanges();
                ddlLDV.DataSource = tbl;
                ddlLDV.DataTextField = "HOTEN";
                ddlLDV.DataValueField = "ID";
                ddlLDV.DataBind();
                ddlLDV.Items.Insert(0, new ListItem("Chọn", "0"));

                //ddlLDV.DataSource = oTLDDT;
                //ddlLDV.DataTextField = "MA_TEN";
                //ddlLDV.DataValueField = "ID";
                //ddlLDV.DataBind();
                //ddlLDV.Items.Insert(0, new ListItem("Chọn", "0"));
                try
                {
                    //--------------
                    String LDVID = "0";
                    if (ddlGiaidoan.SelectedValue == "0" || ddlGiaidoan.SelectedValue == "2")
                    {
                        LDVID = (String.IsNullOrEmpty(rv["XXGDT_LANHDAOVUID"] + "") ? "0" : rv["XXGDT_LANHDAOVUID"] + "");
                        if (LDVID == "0")
                            LDVID = (String.IsNullOrEmpty(rv["LANHDAOVUID"] + "") ? "0" : rv["LANHDAOVUID"] + "");
                    }
                    else
                        LDVID = (String.IsNullOrEmpty(rv["LANHDAOVUID"] + "") ? "0" : rv["LANHDAOVUID"] + "");
                    ddlLDV.SelectedValue = LDVID;
                    //-----------------
                    //HiddenField hddLDVID = (HiddenField)e.Item.FindControl("hddLDVID");
                    //ddlLDV.SelectedValue = hddLDVID.Value;
                }
                catch (Exception ex) { }

                //----------------------------- 
                HiddenField hddCurrID = (HiddenField)e.Item.FindControl("hddCurrID");
                TextBox txtNgayPhanCongTTV = (TextBox)e.Item.FindControl("txtNgayPhanCongTTV");
                TextBox txtNgayNhanTHS = (TextBox)e.Item.FindControl("txtNgayNhanTHS");
                TextBox txtNgayPhanCongLD = (TextBox)e.Item.FindControl("txtNgayPhanCongLD");
                Literal lttTTV = (Literal)e.Item.FindControl("lttTTV");
                Literal lttLD = (Literal)e.Item.FindControl("lttLD");


                //txtNgayPhanCongTTV.Text = vNgaypc;hddNGAYTTV_GDT
                //--------------------------------------
                CheckBox chk = (CheckBox)e.Item.FindControl("chkChon");
                if (chk.Checked)
                {
                    ddlLDV.Visible = ddlTTV.Visible = true;
                    lttTTV.Visible = lttLD.Visible = false;
                    txtNgayPhanCongLD.Enabled = txtNgayPhanCongTTV.Enabled = txtNgayNhanTHS.Enabled = true;
                }
                else
                {
                    ddlLDV.Visible = ddlTTV.Visible = false;
                    lttTTV.Visible = lttLD.Visible = true;
                    txtNgayPhanCongLD.Enabled = txtNgayPhanCongTTV.Enabled = txtNgayNhanTHS.Enabled = false;
                }

                //--Hien thị TTV duoc phan cong------------------------
                int count = 0;
                string StrDisplay = "", temp = "";
                string[] arr = null;
                Decimal CurrVuAnID = Convert.ToDecimal(hddCurrID.Value);
                String PhanCongTTV_GDT = rv["PhanCongTTV_GDT"] + "";
                String lttTTV_GDT = "";
                HiddenField hddNGAYTTV_GDT = (HiddenField)e.Item.FindControl("hddNGAYTTV_GDT");
                if (!String.IsNullOrEmpty(PhanCongTTV_GDT))
                {
                    lttTTV_GDT += "<b>- " + rv["TENTHAMTRAVIEN_GDT"] + ((String.IsNullOrEmpty(rv["XXGDT_NGAYPHANCONGTTV"] + "") || rv["XXGDT_NGAYPHANCONGTTV"].ToString() == "01/01/0001") ? "" : (" (" + (rv["XXGDT_NGAYPHANCONGTTV"]).ToString() + ")")) + "</b>";
                    arr = PhanCongTTV_GDT.Split("*".ToCharArray());
                    foreach (String str in arr)
                    {
                        if (str != "")
                        {
                            if (!String.IsNullOrEmpty(hddNGAYTTV_GDT.Value))
                                temp = (hddNGAYTTV_GDT.Value).ToString();

                            if (count == 0)
                                StrDisplay = "-" + (str.Replace(" - ", " - " + temp));
                            else
                                StrDisplay += "<br/>- " + str;
                            count++;
                        }
                    }
                }
                else lttTTV_GDT += "<b>- " + rv["TENTHAMTRAVIEN_GDT"] + ((String.IsNullOrEmpty(rv["XXGDT_NGAYPHANCONGTTV"] + "") || rv["XXGDT_NGAYPHANCONGTTV"].ToString() == "01/01/0001") ? "" : (" (" + (rv["XXGDT_NGAYPHANCONGTTV"]).ToString() + ")")) + "</b>";
                lttTTV_GDT += (string.IsNullOrEmpty(StrDisplay) ? "" : "<br/>") + "<i>" + StrDisplay + "</i>";


                String PhanCongTTV = rv["PhanCongTTV"] + "";
                String lttTTV_GQD = "";
                StrDisplay = "";
                if (!String.IsNullOrEmpty(PhanCongTTV))
                {
                    lttTTV_GQD += "<b>- " + rv["TenThamTraVien"] + ((String.IsNullOrEmpty(rv["NGAYPHANCONGTTV"] + "") || rv["NGAYPHANCONGTTV"].ToString() == "01/01/0001") ? "" : (" (" + (rv["NGAYPHANCONGTTV"]).ToString() + ")")) + "</b>";
                    arr = PhanCongTTV.Split("*".ToCharArray());
                    foreach (String str in arr)
                    {
                        if (str != "")
                        {
                            temp = txtNgayPhanCongTTV.Text;
                            if (count == 0)
                                StrDisplay = "-" + (str.Replace(" - ", " - " + temp));
                            else
                                StrDisplay += "<br/>- " + str;
                            count++;
                        }
                    }
                }
                else lttTTV_GQD += "<b>- " + rv["TenThamTraVien"] + ((String.IsNullOrEmpty(rv["NGAYPHANCONGTTV"] + "") || rv["NGAYPHANCONGTTV"].ToString() == "01/01/0001") ? "" : (" (" + (rv["NGAYPHANCONGTTV"]).ToString() + ")")) + "</b>";

                lttTTV_GQD += (string.IsNullOrEmpty(StrDisplay) ? "" : "<br/>") + "<i>" + StrDisplay + "</i>";

                if (lttTTV_GDT != "<b>- </b><i></i>")
                {
                    if (!String.IsNullOrEmpty(PhanCongTTV))
                        lttTTV.Text = "<b>2. Giai đoạn XXGDT</b><br/>" + lttTTV_GDT + "<br/><b>1. Giai đoạn GQD</b><br/>" + lttTTV_GQD;
                    else
                        lttTTV.Text = "<b>2. Giai đoạn XXGDT</b><br/>" + lttTTV_GDT;
                }
                else if (lttTTV_GQD != "<b>- </b><i></i>")
                    lttTTV.Text = "<b>1. Giai đoạn GQD</b><br/>" + lttTTV_GQD;


                //lttTTV.Text += (string.IsNullOrEmpty(StrDisplay) ? "" : "<br/>") + "<i>" + StrDisplay + "</i>";



                //----Hien thị LD -----------------
                count = 0;
                StrDisplay = "";
                //---------LD giai doan XXGDT
                HiddenField hddNGAYLD_GDT = (HiddenField)e.Item.FindControl("hddNGAYLD_GDT");
                String PhanCongLD_XX = rv["PhanCongLD_GDT"] + "";
                String vlttLD_xx = "";
                if (!String.IsNullOrEmpty(PhanCongLD_XX))
                {
                    vlttLD_xx = "<b>- " + rv["TENLANHDAO_GDT"] + ((String.IsNullOrEmpty(rv["XXGDT_NGAYPHANCONGLD"] + "") || rv["XXGDT_NGAYPHANCONGLD"].ToString() == "01/01/0001") ? "" : ("(" + (rv["XXGDT_NGAYPHANCONGLD"]).ToString() + ")")) + "</b>";

                    arr = PhanCongLD_XX.Split("*".ToCharArray());
                    foreach (String str in arr)
                    {
                        if (str != "")
                        {
                            if (!String.IsNullOrEmpty(hddNGAYLD_GDT.Value))
                                temp = (hddNGAYLD_GDT.Value).ToString();
                            //temp = Convert.ToDateTime(hddNGAYLD_GDT.Value).ToString("dd/MM/yyyy");
                            if (count == 0)
                                StrDisplay = "-" + (str.Replace(" - ", " - " + temp));
                            else
                                StrDisplay += "<br/>- " + str;
                            count++;
                        }
                    }
                }
                else
                    vlttLD_xx = "<b>- " + rv["TENLANHDAO_GDT"] + ((String.IsNullOrEmpty(rv["XXGDT_NGAYPHANCONGLD"] + "") || rv["XXGDT_NGAYPHANCONGLD"].ToString() == "01/01/0001") ? "" : (" (" + (rv["XXGDT_NGAYPHANCONGLD"]).ToString() + ")")) + "</b>";

                vlttLD_xx += (string.IsNullOrEmpty(StrDisplay) ? "" : "<br/>") + "<i>" + StrDisplay + "</i>";

                //lttLD.Text += (string.IsNullOrEmpty(StrDisplay) ? "" : "<br/>") + "<i>" + StrDisplay + "</i>";

                //-- LD giai doan GQD
                StrDisplay = "";
                String PhanCongLD = rv["PhanCongLD"] + "";
                String vlttLD = "";
                if (!String.IsNullOrEmpty(PhanCongLD))
                {
                    vlttLD = "<b>- " + rv["TenLanhDao"] + (String.IsNullOrEmpty(rv["NGAYPHANCONGLD"] + "") || rv["NGAYPHANCONGLD"].ToString() == "01/01/0001" ? "" : ("(" + (rv["NGAYPHANCONGLD"]).ToString() + ")")) + "</b>";

                    arr = PhanCongLD.Split("*".ToCharArray());
                    foreach (String str in arr)
                    {
                        if (str != "")
                        {
                            temp = txtNgayPhanCongLD.Text;
                            if (count == 0)
                                StrDisplay = "-" + (str.Replace(" - ", " - " + temp));
                            else
                                StrDisplay += "<br/>- " + str;
                            count++;
                        }
                    }
                }
                else
                    vlttLD = "<b>- " + rv["TenLanhDao"] + ((String.IsNullOrEmpty(rv["NGAYPHANCONGLD"] + "") || rv["NGAYPHANCONGLD"].ToString() == "01/01/0001") ? "" : (" (" + (rv["NGAYPHANCONGLD"]).ToString() + ")")) + "</b>";
                vlttLD += (string.IsNullOrEmpty(StrDisplay) ? "" : "<br/>") + "<i>" + StrDisplay + "</i>";
                //lttLD.Text += (string.IsNullOrEmpty(StrDisplay) ? "" : "<br/>") + "<i>" + StrDisplay + "</i>";
                if (vlttLD_xx != "<b>- </b><i></i>")
                {
                    if (!String.IsNullOrEmpty(PhanCongLD))
                        lttLD.Text = "<b>2. Giai đoạn XXGDT</b><br/>" + vlttLD_xx + "<br/><b>1. Giai đoạn GQD</b><br/>" + vlttLD;
                    else
                        lttLD.Text = "<b>2. Giai đoạn XXGDT</b><br/>" + vlttLD_xx;
                }
                else if (vlttLD != "<b>- </b><i></i>")
                    lttLD.Text = "<b>1. Giai đoạn GQD</b><br/>" + vlttLD;



                //ddlGiaidoan.SelectedValue;
                //-------------------------------
                if (ddlGiaidoan.SelectedValue == "1")
                {
                    txtNgayPhanCongTTV.Text = ((String.IsNullOrEmpty(rv["NGAYPHANCONGTTV"] + "") || rv["NGAYPHANCONGTTV"].ToString() == "01/01/0001") ? "" : (" (" + (rv["NGAYPHANCONGTTV"]).ToString() + ")"));
                    txtNgayPhanCongLD.Text = ((String.IsNullOrEmpty(rv["NGAYPHANCONGLD"] + "") || rv["NGAYPHANCONGLD"].ToString() == "01/01/0001") ? "" : (" (" + (rv["NGAYPHANCONGLD"]).ToString() + ")"));

                }
                else
                {
                    if (!string.IsNullOrEmpty(hddNGAYTTV_GDT.Value.Trim()))
                    {
                        txtNgayPhanCongTTV.Text = hddNGAYTTV_GDT.Value;
                        if (!string.IsNullOrEmpty(hddNGAYLD_GDT.Value.Trim()))
                            txtNgayPhanCongLD.Text = hddNGAYLD_GDT.Value;
                    }
                    else
                    {
                        txtNgayPhanCongTTV.Text = ((String.IsNullOrEmpty(rv["NGAYPHANCONGTTV"] + "") || rv["NGAYPHANCONGTTV"].ToString() == "01/01/0001") ? "" : (" (" + (rv["NGAYPHANCONGTTV"]).ToString() + ")"));
                        txtNgayPhanCongLD.Text = ((String.IsNullOrEmpty(rv["NGAYPHANCONGLD"] + "") || rv["NGAYPHANCONGLD"].ToString() == "01/01/0001") ? "" : (" (" + (rv["NGAYPHANCONGLD"]).ToString() + ")"));
                    }

                }


            }
        }
        //---------------CHỨC NĂNG-------------------
        //protected void chkChonAll_CheckChange(object sender, EventArgs e)
        //{
        //    CheckBox chkAll = (CheckBox)sender;

        //    foreach (DataGridItem Item in dgList.Items)
        //    {
        //        CheckBox chk = (CheckBox)Item.FindControl("chkChon");
        //        chk.Checked = chkAll.Checked;
        //    }
        //}
        protected void chkChon_CheckedChanged(object sender, EventArgs e)
        {
            CheckBox curr_chk = (CheckBox)sender;

            if (ddlLoaiAn.SelectedValue == ENUM_LOAIVUVIEC.AN_HINHSU)
            {
                SetPhanCongTTV(curr_chk, gridHS);
            }
            else
            {

                SetPhanCongTTV(curr_chk, dgList);

            }
        }
        void SetPhanCongTTV(CheckBox curr_chk, DataGrid grid)
        {

            foreach (DataGridItem Item in grid.Items)
            {
                DropDownList ddlTTV = (DropDownList)Item.FindControl("ddlTTV");
                DropDownList ddlLDV = (DropDownList)Item.FindControl("ddlLDV");
                TextBox txtNgayPhanCongTTV = (TextBox)Item.FindControl("txtNgayPhanCongTTV");
                TextBox txtNgayNhanTHS = (TextBox)Item.FindControl("txtNgayNhanTHS");
                TextBox txtNgayPhanCongLD = (TextBox)Item.FindControl("txtNgayPhanCongLD");
                Literal lttTTV = (Literal)Item.FindControl("lttTTV");
                Literal lttLD = (Literal)Item.FindControl("lttLD");
                CheckBox chk = (CheckBox)Item.FindControl("chkChon");
                HiddenField hddNGAYTTV_GQD = (HiddenField)Item.FindControl("hddNGAYTTV_GQD");
                HiddenField hddTTVID = (HiddenField)Item.FindControl("hddTTVID");

                HiddenField hddNGAYTTV_GDT = (HiddenField)Item.FindControl("hddNGAYTTV_GDT");
                HiddenField hddTTVID_XXGDT = (HiddenField)Item.FindControl("hddTTVID_XXGDT");


                HiddenField hddNGAYLD_GQD = (HiddenField)Item.FindControl("hddNGAYLD_GQD");
                HiddenField hddLDVID = (HiddenField)Item.FindControl("hddLDVID");
                HiddenField hddNGAYLD_GDT = (HiddenField)Item.FindControl("hddNGAYLD_GDT");
                HiddenField hddLDVID_GDT = (HiddenField)Item.FindControl("hddLDVID_GDT");

                HiddenField hddISVKS_KN = (HiddenField)Item.FindControl("hddISVKS_KN");

                AjaxControlToolkit.CalendarExtender CE_PCTTV = (AjaxControlToolkit.CalendarExtender)Item.FindControl("CE_PCTTV");


                if (chk.Checked)
                {
                    ddlLDV.Visible = ddlTTV.Visible = true;
                    lttTTV.Visible = lttLD.Visible = false;
                    txtNgayPhanCongLD.Enabled = txtNgayPhanCongTTV.Enabled = txtNgayNhanTHS.Enabled = true;
                    if (rdbPhancongThamtravien.SelectedValue == "0")
                    {
                        txtNgayPhanCongLD.Text = txtNgayPhanCongTTV.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
                    }

                    if (ddlGiaidoan.SelectedValue != "1")
                    {
                        if (!string.IsNullOrEmpty(hddNGAYTTV_GDT.Value.Trim()))
                        {
                            txtNgayPhanCongTTV.Text = hddNGAYTTV_GDT.Value;
                            if (!string.IsNullOrEmpty(hddNGAYLD_GDT.Value.Trim()))
                                txtNgayPhanCongLD.Text = hddNGAYLD_GDT.Value;

                            try
                            {
                                CE_PCTTV.StartDate = DateTime.ParseExact(hddNGAYTTV_GDT.Value, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                            }
                            catch (Exception ex) { CE_PCTTV.StartDate = null; }

                            if (!string.IsNullOrEmpty(hddTTVID_XXGDT.Value.Trim()))
                                ddlTTV.SelectedValue = hddTTVID_XXGDT.Value;
                            if (!string.IsNullOrEmpty(hddLDVID_GDT.Value.Trim()))
                                ddlLDV.SelectedValue = hddLDVID_GDT.Value;

                        }
                        else
                        {
                            try
                            {
                                CE_PCTTV.StartDate = DateTime.ParseExact(hddNGAYTTV_GQD.Value, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                            }
                            catch (Exception ex) { CE_PCTTV.StartDate = null; }

                            if (!string.IsNullOrEmpty(hddNGAYTTV_GQD.Value.Trim()))
                                txtNgayPhanCongTTV.Text = hddNGAYTTV_GQD.Value;

                            try
                            {
                                ddlTTV.SelectedValue = hddTTVID.Value;

                            }
                            catch (Exception ex) { ddlTTV.SelectedValue = "0"; }


                            //if (!string.IsNullOrEmpty(hddNGAYLD_GQD.Value.Trim()))
                            //    txtNgayPhanCongLD.Text = hddNGAYLD_GQD.Value;

                            //if (!string.IsNullOrEmpty(hddLDVID.Value.Trim()))
                            //    ddlLDV.SelectedValue = hddLDVID.Value;
                        }
                    }
                    else
                    { //Khang nghị cua VKS 
                        if (hddISVKS_KN.Value == "1")
                        {
                            if (!string.IsNullOrEmpty(hddNGAYTTV_GDT.Value.Trim()))
                                CE_PCTTV.StartDate = DateTime.ParseExact(hddNGAYTTV_GDT.Value, "dd/MM/yyyy", CultureInfo.InvariantCulture);

                        }
                        else
                        {
                            if (!string.IsNullOrEmpty(hddNGAYTTV_GDT.Value.Trim()))
                                CE_PCTTV.EndDate = DateTime.ParseExact(hddNGAYTTV_GDT.Value, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                        }



                        if (!string.IsNullOrEmpty(hddNGAYTTV_GQD.Value.Trim()))
                            txtNgayPhanCongTTV.Text = hddNGAYTTV_GQD.Value;
                        //txtNgayPhanCongTTV.Text = (DateTime.ParseExact(hddNGAYTTV_GQD.Value, "dd/MM/yyyy", CultureInfo.InvariantCulture)).ToString();

                        if (!string.IsNullOrEmpty(hddTTVID.Value.Trim()))
                            ddlTTV.SelectedValue = hddTTVID.Value;

                        if (!string.IsNullOrEmpty(hddNGAYLD_GQD.Value.Trim()))
                            txtNgayPhanCongLD.Text = hddNGAYLD_GQD.Value;


                        if (!string.IsNullOrEmpty(hddLDVID.Value.Trim()))
                            ddlLDV.SelectedValue = hddLDVID.Value;
                    }
                }
                else
                {
                    lttTTV.Visible = lttLD.Visible = true;
                    ddlLDV.Visible = ddlTTV.Visible = false;
                    if (rdbPhancongThamtravien.SelectedValue == "0")
                        txtNgayPhanCongLD.Text = txtNgayPhanCongTTV.Text = "";
                    txtNgayPhanCongLD.Enabled = txtNgayPhanCongTTV.Enabled = txtNgayNhanTHS.Enabled = false;
                }
            }
        }

        protected void lbtTTBC_Click(object sender, EventArgs e)
        {
            if (pnTTBC.Visible)
            {
                lbtTTBC.Text = "[ Mở ]";
                pnTTBC.Visible = false;
                Session["TTBCVISIBLE"] = "0";
            }
            else
            {
                lbtTTBC.Text = "[ Đóng ]";
                pnTTBC.Visible = true;
                Session["TTBCVISIBLE"] = "1";
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
            txtSoQDBA.Text = "";
            txtNgayBAQD.Text = "";
            ddlToaXetXu.SelectedIndex = 0;
            txtNguyendon.Text = "";
            txtBidon.Text = "";
            ddlLoaiAn.SelectedIndex = 0;

            ddlThamtravien.SelectedIndex = 0;
            ddlPhoVuTruong.SelectedIndex = 0;
            ddlThamphan.SelectedIndex = 0;

            //ddlQHPLTK.SelectedIndex = 0;
            //ddlQHPLDN.SelectedIndex = 0;
            txtThuly_Tu.Text = "";
            txtThuly_Den.Text = "";
            txtThuly_So.Text = "";

            rdbPhancongThamtravien.SelectedValue = "0";
        }
        protected void ddlLoaiAn_SelectedIndexChanged(object sender, EventArgs e)
        {

            Load_Data();
        }

        protected void ddlTTV_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;
            string ID = ddl.ToolTip;

            if (ddlLoaiAn.SelectedValue == ENUM_LOAIVUVIEC.AN_HINHSU)
            {
                SetLanhDaoTheoTTV(ddl, gridHS);
            }
            else
            {
                SetLanhDaoTheoTTV(ddl, dgList);
            }
        }
        void SetLanhDaoTheoTTV(DropDownList ddl, DataGrid grid)
        {
            foreach (DataGridItem Item in grid.Items)
            {
                DropDownList ddlTTV = (DropDownList)Item.FindControl("ddlTTV");
                DropDownList ddlLDV = (DropDownList)Item.FindControl("ddlLDV");
                CheckBox chk = (CheckBox)Item.FindControl("chkChon");
                TextBox txtNgayPhanCongTTV = (TextBox)Item.FindControl("txtNgayPhanCongTTV");
                TextBox txtNgayPhanCongLD = (TextBox)Item.FindControl("txtNgayPhanCongLD");

                AjaxControlToolkit.CalendarExtender CE_PCTTV = (AjaxControlToolkit.CalendarExtender)Item.FindControl("CE_PCTTV");
                HiddenField hddNGAYTTV_GQD = (HiddenField)Item.FindControl("hddNGAYTTV_GQD");
                HiddenField hddNGAYTTV_GDT = (HiddenField)Item.FindControl("hddNGAYTTV_GDT");

                HiddenField hddISVKS_KN = (HiddenField)Item.FindControl("hddISVKS_KN");

                if (chk.Checked)
                {
                    decimal TTVID = Convert.ToDecimal(ddlTTV.SelectedValue);
                    decimal lanhdaoID = Convert.ToDecimal(ddlLDV.SelectedValue);
                    if (TTVID > 0)
                    {
                        if (rdbPhancongThamtravien.SelectedValue == "1")
                        {
                            txtNgayPhanCongTTV.Text = "";
                            if (ddlGiaidoan.SelectedValue != "1")
                            {
                                if (!string.IsNullOrEmpty(hddNGAYTTV_GDT.Value.Trim()))
                                    CE_PCTTV.StartDate = DateTime.ParseExact(hddNGAYTTV_GDT.Value, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                                else if (!string.IsNullOrEmpty(hddNGAYTTV_GQD.Value.Trim()) && hddISVKS_KN.Value == "0")
                                    CE_PCTTV.StartDate = DateTime.ParseExact(hddNGAYTTV_GQD.Value, "dd/MM/yyyy", CultureInfo.InvariantCulture);

                            }
                            else if (ddlGiaidoan.SelectedValue == "1" && hddISVKS_KN.Value == "0")
                            {

                                if (!string.IsNullOrEmpty(hddNGAYTTV_GDT.Value.Trim()))
                                    CE_PCTTV.EndDate = DateTime.ParseExact(hddNGAYTTV_GDT.Value, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                                else
                                {
                                    if (!string.IsNullOrEmpty(hddNGAYTTV_GQD.Value.Trim()))
                                        CE_PCTTV.StartDate = DateTime.ParseExact(hddNGAYTTV_GQD.Value, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                                }

                            }
                        }

                        string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
                        decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
                        if (lanhdaoID == 0)
                        {
                            //Lấy thông tin lãnh đạo
                            GDTTT_CACVU_CAUHINH_BL objBL = new GDTTT_CACVU_CAUHINH_BL();
                            DataTable tbl = objBL.GetLanhDaoNhanBCTheoTTV(PBID, TTVID);
                            if (tbl != null && tbl.Rows.Count > 0)
                            {
                                string strLDVID = tbl.Rows[0]["ID"] + "";
                                ddlLDV.SelectedValue = strLDVID;
                            }
                        }
                    }
                }
            }
        }

        protected void ddlLDV_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;
            string ID = ddl.ToolTip;
            if (ddlLoaiAn.SelectedValue == ENUM_LOAIVUVIEC.AN_HINHSU)
            {
                SetTTVTheoLanhDao(ddl, gridHS);
            }
            else
            {
                SetTTVTheoLanhDao(ddl, dgList);
            }
        }
        void SetTTVTheoLanhDao(DropDownList ddl, DataGrid grid)
        {
            foreach (DataGridItem Item in dgList.Items)
            {
                DropDownList ddlLDV = (DropDownList)Item.FindControl("ddlLDV");
                CheckBox chk = (CheckBox)Item.FindControl("chkChon");
                TextBox txtNgayPhanCongLD = (TextBox)Item.FindControl("txtNgayPhanCongLD");

                if (chk.Checked)
                {
                    decimal lanhdaoID = Convert.ToDecimal(ddlLDV.SelectedValue);
                    
                }
            }
        }


        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            UpdateVuAn_PhanCongCB();
        }
        void UpdateVuAn_PhanCongCB()
        {
            int count_update = 0, isphancong = 0;
            decimal temp_id = 0;
            decimal vgiaidoan = Convert.ToDecimal(ddlGiaidoan.SelectedValue);

            DataGridItemCollection lstG = dgList.Items;
            if (ddlLoaiAn.SelectedValue == ENUM_LOAIVUVIEC.AN_HINHSU)
            {
                lstG = gridHS.Items;
            }
            foreach (DataGridItem Item in lstG)
            {
                isphancong = 0;
                temp_id = 0;
                CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                if (chkChon.Checked)
                {
                    decimal VuAnID = Convert.ToDecimal(Item.Cells[0].Text);
                    DropDownList ddlTTV = (DropDownList)Item.FindControl("ddlTTV");
                    DropDownList ddlLDV = (DropDownList)Item.FindControl("ddlLDV");
                    GDTTT_VUAN oT = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();

                    
                    //---------------------------------
                    temp_id = Convert.ToDecimal(ddlTTV.SelectedValue);
                    DateTime? date_temp = (DateTime?)null;
                    TextBox txtNgayPhanCongTTV = (TextBox)Item.FindControl("txtNgayPhanCongTTV");
                    date_temp = txtNgayPhanCongTTV.Text == "" ? (DateTime?)null : DateTime.ParseExact(txtNgayPhanCongTTV.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    //---Luu Lich su phan cong TTV--DateTime.ParseExact(txtNgayPhanCongTTV, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    //DateTime.Parse(txtNgayPhanCongTTV.Text, cul, DateTimeStyles.NoCurrentDateDefault)
                    // UpdateHistory_PCCanBo(1, VuAnID, 2) = 1 là TTV, 2 LĐ; ID vụ an, 2 là Giaidoan GDT và 1 là GQD
                    if ((date_temp != (DateTime?)null) && (temp_id > 0))
                    {
                        isphancong++;
                        if (vgiaidoan == 0)
                        {
                            if (oT.XXGDT_THAMTRAVIENID > 0 && oT.XXGDT_THAMTRAVIENID != Convert.ToDecimal(ddlTTV.SelectedValue))
                            {
                                UpdateHistory_PCCanBo(1, VuAnID, 2);
                            }
                            else if (oT.ISVIENTRUONGKN == 1)
                            {
                                if (oT.XXGDT_THAMTRAVIENID > 0 && oT.XXGDT_THAMTRAVIENID != Convert.ToDecimal(ddlTTV.SelectedValue))
                                    UpdateHistory_PCCanBo(1, VuAnID, 2);
                            }
                            else if (oT.THAMTRAVIENID != Convert.ToDecimal(ddlTTV.SelectedValue))
                                UpdateHistory_PCCanBo(1, VuAnID, 1);

                        }
                        else if (vgiaidoan == 2 || oT.ISVIENTRUONGKN == 1)
                            if (oT.XXGDT_THAMTRAVIENID > 0 && oT.XXGDT_THAMTRAVIENID != Convert.ToDecimal(ddlTTV.SelectedValue))
                                UpdateHistory_PCCanBo(1, VuAnID, 2);
                            else
                            {
                                if (oT.ISVIENTRUONGKN != 1 && oT.THAMTRAVIENID > 0 && oT.THAMTRAVIENID != Convert.ToDecimal(ddlTTV.SelectedValue))
                                    UpdateHistory_PCCanBo(1, VuAnID, 1);

                            }

                    }

                    //----cap nhat tham tra vien---------
                    if (vgiaidoan == 0)
                    {
                        if ((oT.XXGDT_THAMTRAVIENID > 0 || oT.ISVIENTRUONGKN == 1) && oT.XXGDT_THAMTRAVIENID != Convert.ToDecimal(ddlTTV.SelectedValue))
                        {
                            oT.XXGDT_NGAYPHANCONGTTV = date_temp;
                            oT.XXGDT_THAMTRAVIENID = temp_id;
                        }
                        else
                        {
                            if (oT.THAMTRAVIENID != Convert.ToDecimal(ddlTTV.SelectedValue))
                            {
                                oT.NGAYPHANCONGTTV = date_temp;
                                oT.THAMTRAVIENID = temp_id;
                            }
                        }

                    }
                    else if (vgiaidoan == 2 || oT.ISVIENTRUONGKN == 1)
                    {
                        if (oT.XXGDT_THAMTRAVIENID > 0 && oT.XXGDT_THAMTRAVIENID != Convert.ToDecimal(ddlTTV.SelectedValue))
                        {
                            oT.XXGDT_NGAYPHANCONGTTV = date_temp;
                            oT.XXGDT_THAMTRAVIENID = temp_id;
                        }
                    }
                    else
                    {
                        if (oT.ISVIENTRUONGKN != 1 && oT.THAMTRAVIENID > 0 && oT.THAMTRAVIENID != Convert.ToDecimal(ddlTTV.SelectedValue))
                        {
                            oT.NGAYPHANCONGTTV = date_temp;
                            oT.THAMTRAVIENID = temp_id;
                        }
                    }



                    //---------------------------------
                    int trangthaiid = (string.IsNullOrEmpty(oT.TRANGTHAIID + "")) ? (int)ENUM_GDTTT_TRANGTHAI.THULY_MOI : (int)oT.TRANGTHAIID;
                    if ((trangthaiid == 1) && (date_temp != (DateTime?)null) && (temp_id > 0))
                        oT.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.PHANCONG_TTV;

                    //---------------------------------
                    TextBox txtNgayNhanTHS = (TextBox)Item.FindControl("txtNgayNhanTHS");
                    date_temp = txtNgayNhanTHS.Text == "" ? (DateTime?)null : DateTime.ParseExact(txtNgayNhanTHS.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    oT.NGAYTTVNHAN_THS = date_temp;

                    //--------------------------
                    temp_id = Convert.ToDecimal(ddlLDV.SelectedValue);
                    TextBox txtNgayPhanCongLD = (TextBox)Item.FindControl("txtNgayPhanCongLD");
                    date_temp = txtNgayPhanCongLD.Text == "" ? (DateTime?)null : DateTime.ParseExact(txtNgayPhanCongLD.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    //if ((date_temp != (DateTime?)null) && (temp_id > 0))
                    //{
                    //    isphancong++;
                    //    UpdateHistory_PCCanBo(2, VuAnID);
                    //}

                    //oT.NGAYPHANCONGLD = date_temp;
                    //oT.LANHDAOVUID = temp_id;
                    //---Luu Lich su phan cong LDV--
                    if ((date_temp != (DateTime?)null) && (temp_id > 0))
                    {
                        isphancong++;
                        if (vgiaidoan == 0)
                        {
                            if (oT.XXGDT_LANHDAOVUID > 0 && oT.XXGDT_LANHDAOVUID != Convert.ToDecimal(ddlLDV.SelectedValue))
                            {
                                UpdateHistory_PCCanBo(2, VuAnID, 2);
                            }
                            else if (oT.ISVIENTRUONGKN == 1)
                            {
                                if (oT.XXGDT_LANHDAOVUID > 0 && oT.XXGDT_LANHDAOVUID != Convert.ToDecimal(ddlLDV.SelectedValue))
                                    UpdateHistory_PCCanBo(2, VuAnID, 2);
                            }
                            else
                            {
                                if (oT.THAMPHANID > 0 && oT.THAMPHANID != Convert.ToDecimal(ddlLDV.SelectedValue))
                                    UpdateHistory_PCCanBo(2, VuAnID, 1);
                            }
                        }
                        else if (vgiaidoan == 2 || oT.ISVIENTRUONGKN == 1)
                        {
                            if (oT.XXGDT_LANHDAOVUID > 0 && oT.XXGDT_LANHDAOVUID != Convert.ToDecimal(ddlLDV.SelectedValue))
                                UpdateHistory_PCCanBo(2, VuAnID, 2);
                        }
                        else
                        {
                            if (oT.THAMPHANID > 0 && oT.THAMPHANID != Convert.ToDecimal(ddlLDV.SelectedValue))
                                UpdateHistory_PCCanBo(2, VuAnID, 1);
                        }
                    }


                    if (vgiaidoan == 0)
                    {
                        if (oT.XXGDT_LANHDAOVUID > 0 || oT.ISVIENTRUONGKN == 1)
                        {
                            if (oT.XXGDT_LANHDAOVUID != Convert.ToDecimal(ddlLDV.SelectedValue))
                            {
                                oT.XXGDT_NGAYPHANCONGLD = date_temp;
                                oT.XXGDT_LANHDAOVUID = temp_id;
                            }
                        }
                        else
                        {
                            if (oT.THAMPHANID != Convert.ToDecimal(ddlLDV.SelectedValue))
                            {
                                oT.NGAYPHANCONGTP = date_temp;
                                oT.THAMPHANID = temp_id;
                            }
                        }

                    }
                    else if (vgiaidoan == 2 || oT.ISVIENTRUONGKN == 1)
                    {
                        if (oT.XXGDT_LANHDAOVUID != Convert.ToDecimal(ddlLDV.SelectedValue))
                        {
                            oT.XXGDT_NGAYPHANCONGLD = date_temp;
                            oT.XXGDT_LANHDAOVUID = temp_id;
                        }
                    }
                    else
                    {
                        if (oT.THAMPHANID != Convert.ToDecimal(ddlLDV.SelectedValue))
                        {
                            oT.NGAYPHANCONGTP = date_temp;
                            oT.THAMPHANID = temp_id;
                        }
                    }


                    //----------------------- ----------
                    if (isphancong > 0)
                    {
                        lbtthongbao.ForeColor = System.Drawing.Color.Blue;
                        dt.SaveChanges();
                        count_update++;
                    }
                    else
                    {
                        lbtthongbao.ForeColor = System.Drawing.Color.Red;
                        lbtthongbao.Text = "Bạn cần chọn TP cần phân công";
                    }
                }
            }
            if (count_update > 0)
            {
                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                Load_Data();
                lbtthongbao.Text = "Phân công TP thành công !";
            }
            else
            {
                lbtthongbao.ForeColor = System.Drawing.Color.Red;
                lbtthongbao.Text = "Bạn chưa chọn vụ việc cần phân công cán bộ!";
            }
        }
        void UpdateHistory_PCCanBo(int type, Decimal CurrVuAnID, Decimal vGiaidoan)
        {
            //DateTime? date_temp = (String.IsNullOrEmpty(txtNgayPhanCong.Text.Trim())) ? (DateTime?)null : DateTime.Parse(txtNgayPhanCong.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime? date_temp = (DateTime?)null;
            GDTTT_VUAN_PHANCONGCB_HISTORY obj = new GDTTT_VUAN_PHANCONGCB_HISTORY();
            if (CurrVuAnID > 0)
            {
                GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == CurrVuAnID).Single();
                Decimal CanBoID = 0;
                if (vGiaidoan == 1 && oVA.ISVIENTRUONGKN != 1)
                {
                    switch (type)
                    {
                        case 1:// TTV
                            CanBoID = (string.IsNullOrEmpty(oVA.THAMTRAVIENID + "")) ? 0 : (Decimal)oVA.THAMTRAVIENID;
                            date_temp = oVA.NGAYPHANCONGTTV;
                            break;
                        case 2://LD
                            CanBoID = (string.IsNullOrEmpty(oVA.THAMPHANID + "")) ? 0 : (Decimal)oVA.THAMPHANID;
                            date_temp = oVA.NGAYPHANCONGTP;
                            break;
                    }
                }
                else
                {
                    switch (type)
                    {
                        case 1:// TTV
                            CanBoID = (string.IsNullOrEmpty(oVA.XXGDT_THAMTRAVIENID + "")) ? 0 : (Decimal)oVA.XXGDT_THAMTRAVIENID;
                            date_temp = oVA.XXGDT_NGAYPHANCONGTTV;
                            break;
                        case 2://LD
                            CanBoID = (string.IsNullOrEmpty(oVA.XXGDT_LANHDAOVUID + "")) ? 0 : (Decimal)oVA.XXGDT_LANHDAOVUID;
                            date_temp = oVA.XXGDT_NGAYPHANCONGLD;
                            break;
                    }
                }

                if (CanBoID > 0)
                {
                    List<GDTTT_VUAN_PHANCONGCB_HISTORY> lst = null;
                    lst = dt.GDTTT_VUAN_PHANCONGCB_HISTORY.Where(x => x.VUANID == CurrVuAnID
                                                                   && x.CANBOID == CanBoID
                                                                   && x.LOAI == type
                                                                   && x.TUNGAY == date_temp).ToList();
                    if (lst != null && lst.Count > 0)
                    {
                        //GDTTT_VUAN_PHANCONGCB_HISTORY oTemp = lst[0];
                        //obj.TUNGAY = ((DateTime)oTemp.DENNGAY);
                        //switch (type)
                        //{
                        //    case 1:// TTV
                        //        obj.CANBOID = (decimal)oVA.THAMTRAVIENID;
                        //        obj.DENNGAY = (String.IsNullOrEmpty(txtNgayPhanCong.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(txtNgayPhanCong.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        //        break;
                        //    case 2://LD
                        //        obj.CANBOID = (decimal)oVA.LANHDAOVUID;
                        //        obj.DENNGAY = (String.IsNullOrEmpty(txtNgayPhanCong.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(txtNgayPhanCong.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        //        break;
                        //}
                    }
                    else
                    {
                        obj = new GDTTT_VUAN_PHANCONGCB_HISTORY();
                        if (vGiaidoan == 1 && oVA.ISVIENTRUONGKN != 1)
                        {
                            switch (type)
                            {
                                case 1:// TTV
                                    obj.TUNGAY = date_temp;
                                    obj.CANBOID = (decimal)oVA.THAMTRAVIENID;
                                    break;
                                case 2://LD
                                    obj.TUNGAY = date_temp;
                                    obj.CANBOID = (decimal)oVA.THAMPHANID;
                                    break;
                            }
                        }
                        else
                        {
                            switch (type)
                            {
                                case 1:// TTV
                                    obj.TUNGAY = date_temp;
                                    obj.CANBOID = (decimal)oVA.XXGDT_THAMTRAVIENID;
                                    break;
                                case 2://LD
                                    obj.TUNGAY = date_temp;
                                    obj.CANBOID = (decimal)oVA.XXGDT_LANHDAOVUID;
                                    break;
                            }
                        }

                        obj.VUANID = CurrVuAnID;
                        obj.LOAI = (decimal)type;
                        obj.GIAIDOANGQ = vGiaidoan;
                        if (obj.CANBOID > 0)
                        {
                            dt.GDTTT_VUAN_PHANCONGCB_HISTORY.Add(obj);
                            dt.SaveChanges();
                        }
                    }
                }
            }
        }

        protected void cmdPrint_Click(object sender, EventArgs e)
        {
            String SessionName = "GDTTT_ReportPL".ToUpper();
            //--------------------------
            String ReportName = ("Danh sách các vụ án " + rdbPhancongThamtravien.SelectedItem.Text).ToUpper();
            Session[SS_TK.TENBAOCAO] = ReportName.ToUpper();

            int page_size = 200000;
            int pageindex = 1;
            DataTable tbl = getDS(page_size, pageindex);
            Session[SessionName] = tbl;

            string para = "type=pc_ttv";
            string URL = "/QLAN/GDTTT/VuAn/BaoCao/ViewBC.aspx" + (string.IsNullOrEmpty(para) ? "" : "?" + para);
            Cls_Comon.CallFunctionJS(this, this.GetType(), "PopupReport('" + URL + "','In báo cáo',1000,600)");
        }

        protected void rdbPhancongThamtravien_SelectedIndexChanged(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            if (rdbPhancongThamtravien.SelectedValue == "1")
                cmdXoa.Visible = true;
            else
                cmdXoa.Visible = false;
            Load_Data();
        }

        protected void cmdXoa_Click(object sender, EventArgs e)
        {
            Xoa_TTV_VuAn_PhanCongCB();
        }
        void Xoa_TTV_VuAn_PhanCongCB()
        {
            int count_update = 0;
            decimal vgiaidoan = Convert.ToDecimal(ddlGiaidoan.SelectedValue);
            string strMsg = "";
            DataGridItemCollection lstG = dgList.Items;
            if (ddlLoaiAn.SelectedValue == ENUM_LOAIVUVIEC.AN_HINHSU)
            {
                lstG = gridHS.Items;
            }
            foreach (DataGridItem Item in lstG)
            {
                CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                if (chkChon.Checked)
                {
                    decimal VuAnID = Convert.ToDecimal(Item.Cells[0].Text);
                    GDTTT_VUAN oT = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
                   
                    List<GDTTT_QUANLYHS> hs = dt.GDTTT_QUANLYHS.Where(x => x.VUANID == oT.ID).ToList();
                    List<GDTTT_TOTRINH> tt = dt.GDTTT_TOTRINH.Where(x => x.VUANID == oT.ID).ToList();
                    List<GDTTT_VUAN_PHANCONGCB_HISTORY> obLS = dt.GDTTT_VUAN_PHANCONGCB_HISTORY.Where(x => x.VUANID == oT.ID).ToList();

                    //Chua co Hồ sơ và chưa có tờ trình và chưa có kết quả giải quyết thì cho xóa
                    if (hs.Count == 0 && tt.Count == 0 && obLS.Count ==0 && oT.TRANGTHAIID < 13 )
                    {
                        //-----Xoa TTV, Lanh dao phu trach, Tham Phan------------------------
                         oT.TRANGTHAIID = 1;//chua phan cong TTV
                        oT.THAMTRAVIENID = oT.XXGDT_THAMTRAVIENID = null;
                        oT.NGAYPHANCONGTTV = null;
                        oT.NGAYTTVNHAN_THS = null;
                        oT.NGAYPHANCONGLD = null;
                        oT.LANHDAOVUID = null;
                        dt.SaveChanges();
                        count_update++;
                    }
                    else
                    {
                        strMsg = "Vụ án đã cập nhật bước tiếp theo không được xóa";
                    }
                }
               
            }
            if (count_update > 0)
            {
                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                Load_Data();
                strMsg = "Xóa thành công!";
            }
           
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "');", true);
        }


        protected void txtNgayPhanCongTTV_TextChanged(object sender, EventArgs e)
        {
            //TextBox ddl = (TextBox)sender;
            //string ID = ddl.ToolTip;
            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chk = (CheckBox)Item.FindControl("chkChon");
                TextBox txtNgayPhanCongTTV = (TextBox)Item.FindControl("txtNgayPhanCongTTV");
                TextBox txtNgayPhanCongLD = (TextBox)Item.FindControl("txtNgayPhanCongLD");

                if (chk.Checked)
                {

                    if (string.IsNullOrEmpty(txtNgayPhanCongLD.Text.Trim()))
                        txtNgayPhanCongLD.Text = txtNgayPhanCongTTV.Text;
                }
            }
        }
        protected void ddlGiaidoan_SelectedIndexChanged(object sender, EventArgs e)
        {
        }

    }
}