using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

using Module.Common;
using System.Globalization;

using DAL.DKK;
using BL.DonKK;
using BL.DonKK.DanhMuc;

using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.Danhmuc;

namespace WEB.GSTP.UserControl.DKK
{
    public partial class DonKKOnline : System.Web.UI.UserControl
    {
        DKKContextContainer dt = new DKKContextContainer();
        GSTPContext gsdt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
        Decimal UserID = 0;
        int IsPhanLoaiDonKK = 0;
        int MaHeThong = 0;
        public string strMaCT = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            //if (!IsPostBack)
            //{
                IsPhanLoaiDonKK = String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_ISPHANLOAIDON] + "") ? 0 : Convert.ToInt16(Session[ENUM_SESSION.SESSION_ISPHANLOAIDON] + "");

                strMaCT = Session["MaChuongTrinh"] + "";
                if (strMaCT=="" || strMaCT=="0")
                {
                    hddPageIndex.Value = "1";
                    if (IsPhanLoaiDonKK > 0)
                    {
                        pnDonKK.Visible = true;
                        LoadDS();
                    }
                    else
                        pnDonKK.Visible = false;
                }
                else pnDonKK.Visible = false;
            //}
        }

        protected void cmdLoadDSDonKK_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            LoadDS();
        }

        public void LoadDS()
        {
            //lttThongBao.Text = "";
            int page_size = Convert.ToInt16(hddPageSize.Value);
            decimal ToaAnID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
            
            int pageindex = Convert.ToInt32(hddPageIndex.Value);
            DataTable tbl = null;
            DONKK_DON_BL oBL = new DONKK_DON_BL();
            tbl = oBL.SearchByToaAn(0, ToaAnID, pageindex, page_size);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                int count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"]);
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString() + " </b> đơn kiện / <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion

                //----------------------
                rpt.DataSource = tbl;
                rpt.DataBind();
                rpt.Visible = pnPagingTop.Visible = pnPagingBottom.Visible = true;
                pnDonKK.Visible = true;
            }
            else
            {
                rpt.Visible = pnPagingTop.Visible = pnPagingBottom.Visible = pnDonKK.Visible = false;
            }
        }
        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rv = (DataRowView)e.Item.DataItem;
            }
        }

        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
            //switch (e.CommandName)
            //{
                //case "Xoa":
                //    xoa(ND_id);
                //    break;
            //}
        }
       
        #region paging
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            LoadDS();
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            LoadDS();
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            LoadDS();
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            LoadDS();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            //dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex.Value = lbCurrent.Text;
            LoadDS();
        }

        #endregion
    }
}