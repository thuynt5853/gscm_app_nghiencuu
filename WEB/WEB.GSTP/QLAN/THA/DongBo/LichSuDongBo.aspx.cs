using BL.GSTP.THA;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.THA.DongBo
{
    public partial class LichSuDongBo : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);

            if (!IsPostBack)
            {
                Load_Data();
            }
        }

        private void dataGridAllVisible(bool isVisible)
        {
            DgList_All.Visible = isVisible;
        }

        void visibleDataGrid(int page_size, DataTable tbl)
        {
            DgList_All.Visible = true;
            DgList_All.DataSource = tbl;
            DgList_All.PageSize = page_size;
            DgList_All.DataBind();
        }
        void Load_Data()
        {
            try
            {
                DongBoDLDCQG_BL oBL = new DongBoDLDCQG_BL();
                dataGridAllVisible(false);
                int page_size = Convert.ToInt32(dropPageSize.SelectedValue), pageindex = Convert.ToInt32(hddPageIndex.Value), count_all = 0;

                string KHOBAQDID = Request["KHOBAQDID"] + "";

                DataTable tbl = oBL.GetPagingLichSuDuLieuDongBo(KHOBAQDID, pageindex, page_size);


                if (tbl.Rows.Count > 0)
                {
                    #region "Xác định số lượng trang"

                    count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");
                    hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
                    lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                    Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                                 lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);

                    #endregion "Xác định số lượng trang"
                }
                else
                {
                    hddTotalPage.Value = "1";
                    Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                               lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                    lstSobanghiT.Text = lstSobanghiB.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";
                }

                visibleDataGrid(page_size, tbl);
            }
            catch (Exception ex)
            {

                throw;
            }

        }

        #region "Phân trang"

        protected void dropPageSize_SelectedIndexChanged(object sender, EventArgs e)
        {
            dropPageSize.SelectedValue = dropPageSize.SelectedValue;
            hddPageIndex.Value = "1";
            Load_Data();
        }

        protected void lbTBack_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            Load_Data();
        }

        protected void lbTFirst_Click(object sender, EventArgs e)
        {
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
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            Load_Data();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            hddPageIndex.Value = lbCurrent.Text;
            Load_Data();
        }
        #endregion "Phân trang"
    }
}