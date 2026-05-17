using BL.GSTP;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.CONGBOBAQD;
using Module.Common;
using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.CONGBO
{
    public partial class LichSuCongBo : System.Web.UI.Page
    {
        private Decimal hsID = 0;
        private BAQD_CONGBO bAQD_CONGBO = new BAQD_CONGBO();
        private RSAHelprer rSAHelprer;

        protected void Page_Load(object sender, EventArgs e)
        {
            //lblThongbao.Text = "";
            string hsID = Request.QueryString["hsID"];
            if (String.IsNullOrEmpty(hsID))
            {
                Response.Redirect("/Trangchu.aspx");
            }

            if (Session[ENUM_SESSION.RSA] == null)
            {
                this.rSAHelprer = new RSAHelprer();
                Session[ENUM_SESSION.RSA] = this.rSAHelprer;
            }
            else
            {
                this.rSAHelprer = Session[ENUM_SESSION.RSA] as RSAHelprer;
            }
            if (!String.IsNullOrEmpty(hsID))
            {
                try
                {
                    this.hsID = Convert.ToDecimal(this.rSAHelprer.Decryption(hsID));
                }
                catch { }
            }
            if (!String.IsNullOrEmpty(hsID))
            {
                try
                {
                    this.bAQD_CONGBO = DataExtensions.FindById<BAQD_CONGBO>(this.hsID);
                }
                catch { }
            }
            if (this.bAQD_CONGBO == null)
            {
                Response.Redirect("/Trangchu.aspx");
            }
            if (!Page.IsPostBack)
            {
                //string filePath = Request.FilePath;
                //MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                Page.Form.Enctype = "multipart/form-data";
                this.Load_Data();
            }
        }

        private void Load_Data()
        {
            CONGBO_BL congBo_BL = new CONGBO_BL();

            int page_size = Convert.ToInt32(hddPageSize.Value),
                pageindex = Convert.ToInt32(hddPageIndex.Value),
                count_all = 0;
            var tbl = congBo_BL.Get_BAQD_CONGBO_LICHSU_LIST(BAQD_CONGBO_ID: this.hsID, PageSize: page_size, PageIndex: pageindex);
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
                lstSobanghiT.Text = lstSobanghiB.Text = "Không có lịch sử cho cho BA/QĐ công bố này!";
            }
            dgList.CurrentPageIndex = 0;
            dgList.PageSize = page_size;
            dgList.DataSource = tbl;
            dgList.DataBind();
        }

        #region "Phân trang"

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

        protected void dropPageSize_SelectedIndexChanged(object sender, EventArgs e)
        {
            dropPageSize2.SelectedValue = dropPageSize.SelectedValue;
            hddPageIndex.Value = "1";
            hddPageSize.Value = dropPageSize.SelectedValue;
            Load_Data();
        }

        protected void dropPageSize2_SelectedIndexChanged(object sender, EventArgs e)
        {
            dropPageSize.SelectedValue = dropPageSize2.SelectedValue;
            hddPageIndex.Value = "1";
            hddPageSize.Value = dropPageSize2.SelectedValue;
            Load_Data();
        }

        #endregion "Phân trang"
    }
}