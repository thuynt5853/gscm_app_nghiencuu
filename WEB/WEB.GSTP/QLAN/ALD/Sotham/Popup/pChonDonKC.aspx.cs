using DAL.GSTP;
using BL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Data;
using BL.GSTP.Danhmuc;
using System.Globalization;
using System.Web.UI.WebControls;
using BL.GSTP.DONGHEP;
using BL.GSTP.ALD;

namespace WEB.GSTP.QLAN.ALD.Sotham.Popup
{
    public partial class pChonDonKC : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public decimal BanAnID = 0, DuongSuID = 0, DonID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session[ENUM_LOAIAN.AN_LAODONG] != null)
            {
                DonID = (String.IsNullOrEmpty(Request["ID"] + "")) ? 0 : Convert.ToDecimal(Request["ID"] + "");
                if (!IsPostBack)
                {
                    DuongSuID = (String.IsNullOrEmpty(Request["KCID"] + "")) ? 0 : Convert.ToDecimal(Request["KCID"] + "");

                    LoadDrop();
                    LoadGrid();
                }
            }
            else
                Response.Redirect("/Login.aspx");
        }
        void LoadDrop()
        {
            ddlNguoikhangcao.Items.Clear();
            ALD_DON_DUONGSU_BL oDSBL = new ALD_DON_DUONGSU_BL();
            ddlNguoikhangcao.Items.Clear();
            //Load đương sự
            ddlNguoikhangcao.DataSource = oDSBL.ALD_DUONGSU_KHANGCAO(DonID);
            ddlNguoikhangcao.DataTextField = "TENDUONGSU";
            ddlNguoikhangcao.DataValueField = "ID";
            ddlNguoikhangcao.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            ddlNguoikhangcao.DataBind();
            ddlNguoikhangcao.SelectedValue = DuongSuID.ToString();
        }
        public void LoadGrid()
        {
            int hieuluc = 1;
            int pagesize = 20;
            int pageindex = Convert.ToInt32(hddPageIndex.Value);

            DONGHEP_BL objBL = new DONGHEP_BL();
            DataTable tbl = objBL.GetDonGhepDonKC_DUONGSUID(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), DonID, DuongSuID, 5, pageindex, pagesize);

            if (tbl != null && tbl.Rows.Count > 0)
            {
                int count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");

                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, pagesize).ToString();
                //lstSobanghiB.Text = "Có <b>" + count_all + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion

                rpt.DataSource = tbl;
                rpt.DataBind();
                pndata.Visible = true;
            }
            else
            {
                pndata.Visible = false;
                lbthongbao.Text = "Không tìm thấy dữ liệu phù hợp điều kiện!";
            }
        }

        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            switch (e.CommandName)
            {
                case "chon":
                    string IDDONKHAC = e.CommandArgument.ToString();
                    SetDonGhep(IDDONKHAC);
                    Cls_Comon.CallFunctionJS(this, this.GetType(), "Close()");
                    break;
            }
        }

        private void SetDonGhep(string IDDONKHAC)
        {
            string keyDonID = "THONGTIN.DONKHAC.DONID" + Session[ENUM_SESSION.SESSION_USERID].ToString();
            Session[keyDonID] = Convert.ToDecimal(IDDONKHAC);
        }

        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                //  rpt.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
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
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #endregion
        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
            }
        }
    }
}