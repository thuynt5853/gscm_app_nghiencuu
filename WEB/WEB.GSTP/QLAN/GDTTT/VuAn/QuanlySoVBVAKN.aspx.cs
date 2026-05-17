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
    public partial class QuanlySoVBVAKN : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private const decimal ROOT = 0, DA_CHUYEN = 0, DA_NHAN = 1;
        private const string CONNECTION_TO_DB_TRUNGGIAN = "DB_TRUNG_GIAN_Connection";
        private decimal UserID, CurrDonViID, PhongBanID = 0;
        public bool GetBool(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return false;
                else
                    return Convert.ToBoolean(obj);
            }
            catch { return false; }
        }
        public string Getdate(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return "";
                else
                    return Convert.ToDateTime(obj).ToString("dd/MM/yyyy HH:MM");
            }
            catch { return ""; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                UserID = Session[ENUM_SESSION.SESSION_USERID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
                if (!IsPostBack)
                {
                    if (txtNgayVB.Text == "")
                        txtNgayVB.Text = "01/01/" + DateTime.Now.Year;

                    if (txtNgayVB_den.Text == "")
                        txtNgayVB_den.Text = DateTime.Now.ToString("dd/MM/yyyy");

                    LoadDropDownList();
                    //Load du lieu
                    Load_Data();


                }
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
        private void LoadDropDownList()
        {

            //Load loại sổ văn bản
            DM_DATAITEM_BL soBL = new DM_DATAITEM_BL();
            DataTable tblso;

            tblso = soBL.DM_DATAITEM_GETBYGROUPNAME("QLSO_VUGD");
            if (tblso.Rows.Count > 0)
            {
                ddlLoaiso.DataSource = tblso;
                ddlLoaiso.DataTextField = "TEN";
                ddlLoaiso.DataValueField = "MA";
                ddlLoaiso.DataBind();
                //ddlLoaiso.Items.Insert(0, new ListItem("--- Chọn --- ", "0"));
            }
            //Load loai an theo phong ban
            LoadLoaiAn(Convert.ToDecimal(PhongBanID));
        }
        private DataTable getDS()
        {
            decimal PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            decimal CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();

            string SoCongVan, NgayCongVan, NgayCongVan_den, LoaiSO;
            LoaiSO = ddlLoaiso.SelectedValue;
            SoCongVan = txtSoCV.Text;
            NgayCongVan = txtNgayVB.Text;
            NgayCongVan_den = txtNgayVB_den.Text;
            decimal vloaiAn = Convert.ToDecimal(ddlLoaiAn.SelectedValue);

            int page_size = Convert.ToInt32(ddlPageCount.SelectedValue);
            int pageindex = Convert.ToInt32(hddPageIndex.Value);
            //page_size = 10000;
            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault();
            DataTable oDT = oBL.GDTTT_QLSOVBVAKN_SEARCH(CurrDonViID, PhongBanID, TYPE_SOVB_DONVI.VUGIAMDOC, null, LoaiSO, SoCongVan, NgayCongVan, NgayCongVan_den, vloaiAn, page_size, pageindex);
            return oDT;
        }
        private void Load_Data()
        {
            lbTFirst.Visible = ddlPageCount.Visible = lbBFirst.Visible = ddlPageCount2.Visible = true;
            DataTable oDT = getDS();
            int count_all = 0;
            if (oDT.Rows.Count > 0)
                count_all = Convert.ToInt32(oDT.Rows[0]["CountAll"] + "");
            if (oDT != null && oDT.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, Convert.ToInt32(ddlPageCount.SelectedValue)).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + oDT.Rows.Count.ToString() + " </b> đơn trong <b>" + hddTotalPage.Value + "</b> trang";
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
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));

            string strMsg;
            GDTTT_DON_BL oBLDel = new GDTTT_DON_BL();
            DataTable oDT;
            decimal ID;
            switch (e.CommandName)
            {
                case "SoDon":

                    string StrMsgArr = "PopupReport('/QLAN/GDTTT/Hoso/Popup/Viewdon.aspx?arrid=" + e.CommandArgument + "','Danh sách đơn trùng',1000,500);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsgArr, true);
                    break;

                case "Sua":

                    ID = Convert.ToDecimal(e.CommandArgument.ToString());
                    oDT = oBLDel.CHECK_GDTTT_SUASOVBVAKN(ID);

                    if (oDT.Rows.Count > 0 && Convert.ToDecimal(oDT.Rows[0]["vcheck"]) > 0)
                    {
                        strMsg = "Vụ án đã được chuyển đi không được phép sửa!";
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "');", true);
                    }
                    else
                    {
                        Session[SS_TK.ISHOME] = 1;
                        Response.Redirect("Popup/pSuaCongvan.aspx?ID=" + e.CommandArgument.ToString());
                        Load_Data();
                    }
                    break;
                case "Xoa":
                    ID = Convert.ToDecimal(e.CommandArgument.ToString());
                    oDT = oBLDel.CHECK_GDTTT_SUASOVBVAKN(ID);

                    if (oDT.Rows.Count > 0 && Convert.ToDecimal(oDT.Rows[0]["vcheck"]) > 0)
                    {
                        strMsg = "Vụ án đã được chuyển đi không được phép xóa!";
                    }
                    else
                    {
                        //----Xoa ở bang So van ban-----------------------
                        oBLDel.DELETE_ALL_SOVANBANVAKN(ID);
                        strMsg = "Xóa thành công văn bản của vụ án có đề xuất ý kiến kháng nghị!";
                        //----Xoa ơ đon đến khi xong các chuc nang in thi bỏ ----------------

                        Load_Data();
                    }
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "');", true);
                    break;
            }

        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            //----------------
            String LOAISO = ddlLoaiso.SelectedValue;
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {

                ImageButton cmdXoa = (ImageButton)e.Item.FindControl("cmdXoa");
                ImageButton lblSua = (ImageButton)e.Item.FindControl("cmdEdit");
                //if (LOAISO == "YCBS" || LOAISO == "SOTHULY" || LOAISO == "SOTHULYXX")
                //{
                //    lblSua.Visible = cmdXoa.Visible = false;
                //}
                //else
                //{
                //    lblSua.Visible = cmdXoa.Visible = true;
                //}
                lblSua.Visible = cmdXoa.Visible = true;
            }
        }
        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
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
            //dgList.CurrentPageIndex = 0;
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
            //dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
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
            //dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        protected void ddlPageCount2_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount.SelectedValue = ddlPageCount2.SelectedValue;
            //dgList.CurrentPageIndex = 0;
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
        protected void chkChon_CheckedChanged(object sender, EventArgs e)
        {

            CheckBox chk = (CheckBox)sender;
            decimal ID = Convert.ToDecimal(chk.ToolTip);

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
            ddlLoaiAn.Items.Insert(0, new ListItem("Tất cả", "0"));
            //----------

        }
    }
}