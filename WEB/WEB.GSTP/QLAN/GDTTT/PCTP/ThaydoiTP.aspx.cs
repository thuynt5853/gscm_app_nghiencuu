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
using BL.GSTP.BANGSETGET;
//using WEB.GSTP.QLAN.GDTTT.In;

namespace WEB.GSTP.QLAN.GDTTT.PCTP
{
    public partial class ThaydoiTP : System.Web.UI.Page
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
        Decimal CurrUserID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (!IsPostBack)
            {
                LoadPhongban();
                LoadDrop();
                if (ddlLoaiAn.SelectedValue == ENUM_LOAIVUVIEC.AN_HINHSU)
                {
                    labelNguyenDon.Text = "Bị cáo đầu vụ";
                    labelBiDon.Text = "Bị cáo";
                }
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
            //string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            string strPBID = ddlVuGKDT.SelectedValue;
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID); ;
            DM_PHONGBAN obj = dt.DM_PHONGBAN.Where(x => x.ID == PBID).FirstOrDefault() ?? new DM_PHONGBAN();
            if (obj.ISHINHSU == 1) ddlLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
            if (obj.ISDANSU == 1) ddlLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
            if (obj.ISHANHCHINH == 1) ddlLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
            if (obj.ISHNGD == 1) ddlLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
            if (obj.ISKDTM == 1) ddlLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
            if (obj.ISLAODONG == 1) ddlLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
            //if (obj.ISPHASAN == 1) ddlLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC.AN_PHASAN));
            if (ddlLoaiAn.Items.Count > 1)
                ddlLoaiAn.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
            //Load Thẩm phán
            try
            {
                LoadDropThamphan();
            }
            catch (Exception ex) { }
           
        }
        private void LoadPhongban()
        {//anhvh add 10/05/2021
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            List<DM_PHONGBAN> list = new List<DM_PHONGBAN>();
            List<DM_PHONGBAN> list_pb = dt.DM_PHONGBAN.Where(x => x.TOAANID == ToaAnID && (x.ISGIAIQUYETDON == 1 || x.ISGIAIQUYETDON == 2)).ToList();
            foreach (DM_PHONGBAN iss in list_pb)
            {
                if (iss.ID != 21 && iss.ID!=22)//21 Vụ Tổ chức - Cán bộ;22 Ban Thanh tra Tòa án nhân dân tối cao
                {
                    list.Add(iss);
                }
            }
            ddlVuGKDT.DataSource = list;
            ddlVuGKDT.DataTextField = "TENPHONGBAN";
            ddlVuGKDT.DataValueField = "ID";
            ddlVuGKDT.DataBind();
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
                DataTable tbl = oGDTBL.GDTTT_VuAn_GetAllCBTheoPB(LoginDonViID, PBID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                ddlThamphan.DataSource = tbl;
                ddlThamphan.DataTextField = "HOTEN";
                ddlThamphan.DataValueField = "ID";
                ddlThamphan.DataBind();
                ddlThamphan.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
            }
        }

        private DataTable getDS(int page_size, int pageindex)
        {
            decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            //decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            GDTTT_VUAN_THAMPHAN_HISTORY_BL oBL = new GDTTT_VUAN_THAMPHAN_HISTORY_BL();
            decimal vToaRaBAQD = Convert.ToDecimal(ddlToaXetXu.SelectedValue);
            string vSoBAQD = txtSoQDBA.Text.Trim(), vNgayBAQD = txtNgayBAQD.Text;

            string vNguyendon = txtNguyendon.Text;
            string vBidon = txtBidon.Text;
            decimal vLoaiAn = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
            decimal vThamphan = Convert.ToDecimal(ddlThamphan.SelectedValue);
            decimal vPhongban = Convert.ToDecimal(ddlVuGKDT.SelectedValue);
            decimal vQHPLID = 0; //Convert.ToDecimal(ddlQHPLTK.SelectedValue); ;
            decimal vQHPLDNID = 0;// Convert.ToDecimal(ddlQHPLDN.SelectedValue); ;

            DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            string vSoThuly = txtThuly_So.Text;
            decimal vTrangthai = Convert.ToDecimal(rdbPhancongThamphan.SelectedValue);
            decimal vGiaidoan = 0;
            //anhvh phân quyên liên quan đến án tử hình
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            decimal _ISXINANGIAM = Convert.ToDecimal(oPer.ISXINANGIAM);
            decimal _GDT_ISXINANGIAM = Convert.ToDecimal(oPer.GDT_ISXINANGIAM);
            //--------------
            DataTable oDT = oBL.GDTTT_VUAN_THAMPHAN_HISTORY_SEARCH(vToaAnID, vPhongban, vToaRaBAQD, vSoBAQD, vNgayBAQD,
               vNguyendon, vBidon, vLoaiAn,vThamphan,
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
                dgList.Visible = false; ;
            }
            else
            {
                dgList.PageSize = Convert.ToInt32(ddlPageCount.SelectedValue);
                dgList.DataSource = oDT;
                dgList.DataBind();
                dgList.Visible = true; gridHS.Visible = false;
            }

            ///txtNgayPhanCongTP
        }
        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            switch (e.CommandName)
            {
                case "SoDonTrung":   
                    string StrMsgArr = "PopupReport('/QLAN/GDTTT/VuAn/Popup/pDsDon.aspx?type=dt&vID=" + e.Item.Cells[0].Text + "','Danh sách đơn trùng',1000,500);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsgArr, true);
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

        void SetThamPhan(DropDownList ddl, DataGrid grid)
        {
            foreach (DataGridItem Item in grid.Items)
            {
                DropDownList dropThamPhan = (DropDownList)Item.FindControl("dropThamPhan");

                CheckBox chk = (CheckBox)Item.FindControl("chkChon");
                TextBox txtNgayPhanCongTP = (TextBox)Item.FindControl("txtNgayPhanCongTP");
                AjaxControlToolkit.CalendarExtender CE_PCTP = (AjaxControlToolkit.CalendarExtender)Item.FindControl("CE_PCTP");
                HiddenField hddISVKS_KN = (HiddenField)Item.FindControl("hddISVKS_KN");



                dropThamPhan.Items.Clear();
                Boolean IsLoadAll = false;
                decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                Decimal LoginDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
                decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);


                GDTTT_DON_BL oBL = new GDTTT_DON_BL();

                Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
                try
                {
                    DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).Single();
                    if (oCB.CHUCDANHID != null && oCB.CHUCDANHID != 0)
                    {
                        DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCDANHID).FirstOrDefault();
                        if (oCD.MA == "TPTATC")
                            dropThamPhan.Items.Add(new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                        else
                            IsLoadAll = true;
                    }
                    else
                        IsLoadAll = true;
                }
                catch (Exception ex) { IsLoadAll = true; }
                if (IsLoadAll)
                {
                    //DataTable tbl = oBL.CANBO_GETBYDONVI(ToaAnID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                    DataTable tbl = oBL.GDTTT_VuAn_GetAllCBTheoPB(LoginDonViID, PBID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                    if (tbl != null && tbl.Rows.Count > 0)
                    {
                        dropThamPhan.DataSource = tbl;
                        dropThamPhan.DataValueField = "ID";
                        dropThamPhan.DataTextField = "Hoten";
                        dropThamPhan.DataBind();
                        dropThamPhan.Items.Insert(0, new ListItem("Chọn", "0"));
                    }
                }
            }
        }
        //-------------------------------------------
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
            {
                DataRowView rv = (DataRowView)e.Item.DataItem;
                string strID = e.Item.Cells[0].Text;
                DM_CANBO_BL objCBBL = new DM_CANBO_BL();
                string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
                decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);

                //-----------dropThamphan---------
  
                Decimal LoginDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                DropDownList dropThamPhan = (DropDownList)e.Item.FindControl("dropThamPhan");
                dropThamPhan.Items.Clear();
                DataTable tbl = oBL.GDTTT_VuAn_GetAllCBTheoPB(LoginDonViID, PBID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    dropThamPhan.DataSource = tbl;
                    dropThamPhan.DataValueField = "ID";
                    dropThamPhan.DataTextField = "Hoten";
                    dropThamPhan.DataBind();
                    dropThamPhan.Items.Insert(0, new ListItem("Chọn", "0"));
                }
                //-------------------------------

                try
                {
                    //--------------
                    String tpID = "0";
                    String vNgaypc = "";
                    tpID = (String.IsNullOrEmpty(rv["THAMPHANID"] + "") ? "0" : rv["THAMPHANID"] + "");
                    vNgaypc = ((String.IsNullOrEmpty(rv["NGAYPHANCONGTP"] + "") || rv["NGAYPHANCONGTP"].ToString() == "01/01/0001") ? "" : rv["NGAYPHANCONGTP"] + "");

                    dropThamPhan.SelectedValue = tpID;
                   
                }
                catch (Exception ex) { }

             
                //----------------------------- 
                HiddenField hddCurrID = (HiddenField)e.Item.FindControl("hddCurrID");
                TextBox txtNgayPhanCongTP = (TextBox)e.Item.FindControl("txtNgayPhanCongTP");
                TextBox txtLyDo = (TextBox)e.Item.FindControl("txtLyDo");
                TextBox txtSoTT = (TextBox)e.Item.FindControl("txtSoTT");
                TextBox txtNgayToTrinh = (TextBox)e.Item.FindControl("txtNgayToTrinh");

                Literal lttTP = (Literal)e.Item.FindControl("lttTP");
                //--------------------------------------
                CheckBox chk = (CheckBox)e.Item.FindControl("chkChon");
                if (chk.Checked)
                {
                    dropThamPhan.Visible = true;
                    lttTP.Visible = false;
                    txtSoTT.Enabled = txtNgayToTrinh.Enabled = txtLyDo.Enabled = txtNgayPhanCongTP.Enabled = true;
                }
                else
                {
                    dropThamPhan.Visible = false;
                    lttTP.Visible = true;
                    txtSoTT.Enabled = txtNgayToTrinh.Enabled = txtLyDo.Enabled = txtNgayPhanCongTP.Enabled = false;
                }

                //--Hien thị lịch sử phân công TP ------------------------
               
                int count = 0;
                string StrDisplay = "", temp = "";
                string[] arr = null;
                Decimal CurrVuAnID = Convert.ToDecimal(hddCurrID.Value);
            
                String PhanCongTP = rv["PhanCongTP"] + "";
                String lttTP_GQD = "";
                StrDisplay = "";
                if (!String.IsNullOrEmpty(PhanCongTP))
                {
                    lttTP_GQD += "<b>- " + rv["TenThamPhan"] + ((String.IsNullOrEmpty(rv["NGAYPHANCONGTP"] + "") || rv["NGAYPHANCONGTP"].ToString() == "01/01/0001") ? "" : (" (" + (rv["NGAYPHANCONGTP"]).ToString() + ")")) + "</b>";
                    arr = PhanCongTP.Split("*".ToCharArray());
                    foreach (String str in arr)
                    {
                        if (str != "")
                        {
                            temp = txtNgayPhanCongTP.Text;
                            if (count == 0)
                                StrDisplay = "-" + (str.Replace(" - ", " - " + temp));
                            else
                                StrDisplay += "<br/>- " + str;
                            count++;
                        }
                    }
                }
                else lttTP_GQD += "<b>- " + rv["TenThamPhan"] + ((String.IsNullOrEmpty(rv["NGAYPHANCONGTP"] + "") || rv["NGAYPHANCONGTP"].ToString() == "01/01/0001") ? "" : (" (" + (rv["NGAYPHANCONGTP"]).ToString() + ")")) + "</b>";
                lttTP_GQD += (string.IsNullOrEmpty(StrDisplay) ? "" : "<br/>") + "<i>" + StrDisplay + "</i>";

                lttTP.Text = lttTP_GQD;


            }
        }
      
        protected void chkChon_CheckedChanged(object sender, EventArgs e)
        {
            CheckBox curr_chk = (CheckBox)sender;

            if (ddlLoaiAn.SelectedValue == ENUM_LOAIVUVIEC.AN_HINHSU)
            {
                SetPhanCongTP(curr_chk, gridHS);
            }
            else
            {
                SetPhanCongTP(curr_chk, dgList);
            }
        }
        void SetPhanCongTP(CheckBox curr_chk, DataGrid grid)
        {

            foreach (DataGridItem Item in grid.Items)
            {
                DropDownList dropThamPhan = (DropDownList)Item.FindControl("dropThamPhan");
                TextBox txtNgayPhanCongTP = (TextBox)Item.FindControl("txtNgayPhanCongTP");
                TextBox txtLyDo = (TextBox)Item.FindControl("txtLyDo");
                TextBox txtSoTT = (TextBox)Item.FindControl("txtSoTT");
                TextBox txtNgayToTrinh = (TextBox)Item.FindControl("txtNgayToTrinh");

                Literal lttTP = (Literal)Item.FindControl("lttTP");
                
                CheckBox chk = (CheckBox)Item.FindControl("chkChon");
         
                HiddenField hddISVKS_KN = (HiddenField)Item.FindControl("hddISVKS_KN");
                HiddenField NGAYPHANCONGTP = (HiddenField)Item.FindControl("NGAYPHANCONGTP");
                HiddenField hddTPID = (HiddenField)Item.FindControl("hddTPID");
                
                AjaxControlToolkit.CalendarExtender CE_PCTP = (AjaxControlToolkit.CalendarExtender)Item.FindControl("CE_PCTP");


                if (chk.Checked)
                {
                    dropThamPhan.Visible = true;
                    lttTP.Visible = false;
                    txtSoTT.Enabled = txtNgayToTrinh.Enabled = txtLyDo.Enabled = txtNgayPhanCongTP.Enabled = true;
                    if (rdbPhancongThamphan.SelectedValue == "0")
                    {
                        txtNgayPhanCongTP.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
                    }
                    if (NGAYPHANCONGTP != null)
                    {
                        if (!string.IsNullOrEmpty(NGAYPHANCONGTP.Value.Trim()))
                        {
                            CE_PCTP.StartDate = DateTime.ParseExact(NGAYPHANCONGTP.Value, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                            txtNgayPhanCongTP.Text = NGAYPHANCONGTP.Value;
                        }
                    }
                    if (!string.IsNullOrEmpty(hddTPID.Value.Trim()))
                        dropThamPhan.SelectedValue = hddTPID.Value;
                }
                else
                {
                    lttTP.Visible = true;
                    dropThamPhan.Visible = false;
                    if (rdbPhancongThamphan.SelectedValue == "0")
                        txtNgayPhanCongTP.Text = "";
                    txtSoTT.Enabled = txtNgayToTrinh.Enabled = txtNgayPhanCongTP.Enabled = txtLyDo.Enabled = false;
                }
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
            ddlThamphan.SelectedIndex = 0;

            //ddlQHPLTK.SelectedIndex = 0;
            //ddlQHPLDN.SelectedIndex = 0;
            txtThuly_Tu.Text = "";
            txtThuly_Den.Text = "";
            txtThuly_So.Text = "";

            rdbPhancongThamphan.SelectedValue = "0";
        }

        protected void dropThamPhan_SelectedIndexChanged(object sender, EventArgs e)
        {
            decimal temp_id = 0;
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
                    TextBox txtLyDo = (TextBox)Item.FindControl("txtLyDo");
                    TextBox txtSoTT = (TextBox)Item.FindControl("txtSoTT");
                    TextBox txtNgayToTrinh = (TextBox)Item.FindControl("txtNgayToTrinh");
                    TextBox txtNgayPhanCongTP = (TextBox)Item.FindControl("txtNgayPhanCongTP");
                    DropDownList dropThamPhan = (DropDownList)Item.FindControl("dropThamPhan");
                    temp_id = Convert.ToDecimal(dropThamPhan.SelectedValue);
                    if (temp_id > 0)
                    {
                        txtNgayPhanCongTP.Text = txtSoTT.Text = txtNgayToTrinh.Text = "";
                    }
                }
            }
        }
       
      

        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            UpdateVuAn_PhanCongPT();
        }
        void UpdateVuAn_PhanCongPT()
        {
            int count_update = 0, isphancong = 0;
            decimal temp_id = 0;

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
                    DropDownList dropThamPhan = (DropDownList)Item.FindControl("dropThamPhan");
                    GDTTT_VUAN oT = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
                    

                    //---------------------------------
                    temp_id = Convert.ToDecimal(dropThamPhan.SelectedValue);
                    DateTime? date_temp = (DateTime?)null;
                    TextBox txtNgayPhanCongTP = (TextBox)Item.FindControl("txtNgayPhanCongTP");
                    date_temp = txtNgayPhanCongTP.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayPhanCongTP.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                    //---Luu Lich su phan cong TP--

                    TextBox txtLyDo = (TextBox)Item.FindControl("txtLyDo");
                    TextBox txtSoTT = (TextBox)Item.FindControl("txtSoTT");
                    TextBox txtNgayToTrinh = (TextBox)Item.FindControl("txtNgayToTrinh");
                    String strMsg = "";
                    if (oT.THAMPHANID.ToString() == dropThamPhan.SelectedValue)
                    {
                        strMsg = "Bạn chưa chọn Thẩm phán";
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                        dropThamPhan.Focus();
                        break;
                    }
                    else if (Convert.ToDecimal(dropThamPhan.SelectedValue) == 0)
                    {
                        strMsg = "Bạn chưa chọn Thẩm phán";
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                        dropThamPhan.Focus();
                        break;
                    }
                    else if (txtNgayPhanCongTP.Text == "")
                    {
                        strMsg = "Bạn chưa chọn Ngày phân công TP";
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                        txtNgayPhanCongTP.Focus();
                        break;
                    }
                    else if (txtLyDo.Text == "")
                    {
                        strMsg = "Bạn chưa nhập Lý do thay đổi";
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                        txtLyDo.Focus();
                        break;
                    }
                    else if (txtSoTT.Text == "")
                    {
                        strMsg = "Bạn chưa nhập Số tờ trình";
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                        txtSoTT.Focus();
                        break;
                    }
                    else if (txtNgayToTrinh.Text == "")
                    {
                        strMsg = "Bạn chưa nhập Ngày tờ trình";
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                        txtNgayToTrinh.Focus();
                        break;
                    }
                    else
                    {
                        //String soTT = Convert.ToString(txtSoTT.Text.Trim());
                        //DateTime ngayTT = Convert.ToDateTime(txtNgayToTrinh.Text);
                        //GDTTT_DON oDon = dt.GDTTT_DON.Where(x => x.CD_SOTOTRINH == soTT && x.CD_NGAYTOTRINH == ngayTT).FirstOrDefault();
                        //if (oDon.TT > 0)
                        //{
                        //    strMsg = "Tờ trình " + soTT + "-" + txtNgayToTrinh.Text + " này đã có, bạn kiểm tra lại";
                        //    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                        //    txtSoTT.Focus();
                        //    break;
                        //}
                        //else
                        //{
                            if ((date_temp != (DateTime?)null) && (temp_id > 0))
                            {
                                isphancong++;
                                if (oT.THAMPHANID > 0 && oT.THAMPHANID != Convert.ToDecimal(dropThamPhan.SelectedValue))
                                    UpdateHistory_PCTP(VuAnID, txtLyDo.Text, 1, temp_id, DateTime.ParseExact(txtNgayPhanCongTP.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture), txtSoTT.Text, DateTime.ParseExact(txtNgayToTrinh.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture), CurrUserID);
                            }
                            //----cap nhat tham PHAN--------
                            if (oT.THAMPHANID != Convert.ToDecimal(dropThamPhan.SelectedValue))
                            {
                                oT.NGAYPHANCONGTP = date_temp;
                                oT.THAMPHANID = temp_id;
                            }
                            //---------------------------------
                            if (isphancong > 0)
                            {
                                lbtthongbao.ForeColor = System.Drawing.Color.Blue;
                                dt.SaveChanges();
                                count_update++;
                            }
                        //}
                    }
                }
            }
            if (count_update > 0)
            {
                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                Load_Data();
                lbtthongbao.Text = "Phân công Thẩm phán thành công !";
            }
           
        }
        void UpdateHistory_PCTP(Decimal CurrVuAnID, String Lydo, Decimal giaidoan,Decimal Thamphan_new, DateTime Denngay,String SoTT, DateTime NgayTT,Decimal CurrUserID)
        {
            
            DateTime? date_temp = (DateTime?)null;
            GDTTT_VUAN_PHANCONG_THAMPHAN obj = new GDTTT_VUAN_PHANCONG_THAMPHAN();
            GDTTT_VUAN_THAMPHAN_HISTORY_BL BLobj = new GDTTT_VUAN_THAMPHAN_HISTORY_BL();
            if (CurrVuAnID > 0)
            {
                GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == CurrVuAnID).Single();
                Decimal vThamPhanID = 0;

               
                vThamPhanID = (string.IsNullOrEmpty(oVA.THAMPHANID + "")) ? 0 : (Decimal)oVA.THAMPHANID;
                date_temp = oVA.NGAYPHANCONGTP;
           
               
                if (vThamPhanID > 0)
                {
                    obj = new GDTTT_VUAN_PHANCONG_THAMPHAN();

                    obj.THAMPHAN_ID_OLD = (decimal)oVA.THAMPHANID;
                    if (oVA.NGAYPHANCONGTP != null)
                        obj.TUNGAY = Convert.ToDateTime(oVA.NGAYPHANCONGTP);
                    obj.THAMPHAN_ID_NEW = Thamphan_new;
                    obj.DENNGAY = Denngay;
                    obj.VUANID = CurrVuAnID;
                    obj.LYDO = Lydo;
                    obj.GIAIDOAN = giaidoan;
                    obj.SOTT = SoTT;
                    obj.NGAYTT = NgayTT;
                    obj.CANBOSUA_ID = CurrUserID;
                    if (obj.THAMPHAN_ID_OLD > 0)
                    {
                        BLobj.GDTTT_VUAN_THAMPHAN_HISTORY_Insert_Update(obj);

                    }
                    
                }
               
            }
        }

        protected void cmdPrint_Click(object sender, EventArgs e)
        {
            String SessionName = "GDTTT_ReportPL".ToUpper();
            //--------------------------
            String ReportName = ("Danh sách các vụ án " + rdbPhancongThamphan.SelectedItem.Text).ToUpper();
            Session[SS_TK.TENBAOCAO] = ReportName.ToUpper();

            int page_size = 200000;
            int pageindex = 1;
            DataTable tbl = getDS(page_size, pageindex);
            Session[SessionName] = tbl;

            string para = "type=pc_ttv";
            string URL = "/QLAN/GDTTT/VuAn/BaoCao/ViewBC.aspx" + (string.IsNullOrEmpty(para) ? "" : "?" + para);
            Cls_Comon.CallFunctionJS(this, this.GetType(), "PopupReport('" + URL + "','In báo cáo',1000,600)");
        }

        protected void rdbPhancongThamphan_SelectedIndexChanged(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            Load_Data();
        }
        protected void ddlVuGKDT_SelectedIndexChanged(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            LoadDrop();
            Load_Data();
        }


    }
}
