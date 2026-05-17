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

namespace WEB.GSTP.UserControl.TP
{
    public partial class hoso_vks_Home : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            scriptManager.RegisterPostBackControl(this.cmd_In_ds);
            if (!IsPostBack)
            {
                txt_TINH_DEN_NGAY.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now);
                LoadCombobox();
                LoadAllLoaiAn();
                LoadGrid();
            }
        }
        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            LoadGrid();
        }
        void LoadAllLoaiAn()
        {
            ddlLoaiAn.Items.Clear();
            ddlLoaiAn.Items.Add(new ListItem("---Chọn---", ""));
            ddlLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU));
            ddlLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC_NUMBER.AN_DANSU));
            ddlLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH));
            ddlLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI));
            ddlLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG));
            ddlLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH));
            ddlLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC_NUMBER.AN_PHASAN));
        }
        private void LoadCombobox()
        {
            //--------------------
            dropCapxx.Items.Clear();
            if (Session["CAP_XET_XU"] + "" == "CAPHUYEN")
            {
                dropCapxx.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
            }
            else if (Session["CAP_XET_XU"] + "" == "CAPTINH")
            {
                dropCapxx.Items.Add(new ListItem("-- Tất cả --", ""));
                dropCapxx.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
                dropCapxx.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
            }
            else if (Session["CAP_XET_XU"] + "" == "CAPCAO")
            {
                dropCapxx.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
            }
            else
            {
                dropCapxx.Items.Add(new ListItem("-- Tất cả --", ""));
                dropCapxx.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
                dropCapxx.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
            }
        }
        protected void cmdLammoi_Click(object sender, EventArgs e)
        {
            clear_form_search();
        }
        protected void clear_form_search()
        {
            ddlLoaiAn.SelectedValue = string.Empty;
            ddl_SONGAY_QUAHAN.SelectedValue = "0"; txt_TENDUONGSU.Text = string.Empty; 
            txt_TUNGAY.Text = string.Empty; txt_DENNGAY.Text = string.Empty; txt_TINH_DEN_NGAY.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now);

        }
        protected void cmd_In_ds_Click(object sender, EventArgs e)
        {
            Literal Table_Str_Totals = new Literal();
            DataTable tbl = new DataTable();
            DataRow row = tbl.NewRow();
            //-------------
            CANH_BAO_STPT objBL = new CANH_BAO_STPT();
            tbl = objBL.Hoso_PT_List_vks_export(ddl_SONGAY_QUAHAN.SelectedValue, txt_TINH_DEN_NGAY.Text, ddlLoaiAn.SelectedValue, txt_TUNGAY.Text, txt_DENNGAY.Text, txt_TENDUONGSU.Text.Trim(), dropCapxx.SelectedValue, Session[ENUM_SESSION.SESSION_DONVIID] + "", 0, 0);
            //-----------
            if (tbl != null && tbl.Rows.Count > 0)
            {
                row = tbl.Rows[0];
                Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
            }
            //-------------------Export---------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=ds_hoso.xls");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/vnd.xls";
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.End();
        }
        public void LoadGrid()
        {
            int page_size = 20;
            int pageindex = Convert.ToInt32(hddPageIndex.Value);
            CANH_BAO_STPT objBL = new CANH_BAO_STPT();
            DataTable tbl = objBL.Hoso_PT_List_vks(ddl_SONGAY_QUAHAN.SelectedValue, txt_TINH_DEN_NGAY.Text, ddlLoaiAn.SelectedValue, txt_TUNGAY.Text, txt_DENNGAY.Text, txt_TENDUONGSU.Text.Trim(), dropCapxx.SelectedValue, Session[ENUM_SESSION.SESSION_DONVIID] + "", pageindex, page_size);
            DataRow row = tbl.NewRow();
            if (tbl != null && tbl.Rows.Count > 0)
            {
                //------------------------
                int count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");

                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion

                rpt.DataSource = tbl;
                rpt.DataBind();
                pnPagingBottom.Visible = pnPagingTop.Visible = rpt.Visible = true;
            }
            else
                pnPagingBottom.Visible = pnPagingTop.Visible = rpt.Visible = false;
        }

        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_id = Convert.ToDecimal(e.CommandArgument.ToString());

        }
        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {

            }
        }
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { LtrThongBao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {

                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { LtrThongBao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                // rpt.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGrid();
            }
            catch (Exception ex) { LtrThongBao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                //  rpt.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { LtrThongBao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                // rpt.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
                hddPageIndex.Value = lbCurrent.Text;
                LoadGrid();
            }
            catch (Exception ex) { LtrThongBao.Text = ex.Message; }
        }
    }
}