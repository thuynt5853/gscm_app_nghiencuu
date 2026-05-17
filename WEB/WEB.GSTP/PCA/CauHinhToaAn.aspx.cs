using BL.GSTP.PCTP;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.PCA
{
    public partial class CauHinhToaAn : System.Web.UI.Page
    {
        PCANN_BL pca = new PCANN_BL();
        public bool GetNumber(object obj)
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
        

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Load_Data();
            }
        }       
        private void Load_Data()
        {
            decimal toa_an_id = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            int page_size = Convert.ToInt32(dropPageSize.SelectedValue);          
            DataTable tbl = pca.PCANN_DS_TOAAN_CAUHINH(toa_an_id);
            if (tbl.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"
                int count_all = 1;
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
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

            dgList.DataSource = tbl;
            dgList.DataBind();
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            txtthongbao.Text = "";          
            foreach (DataGridItem Item in dgList.Items)
            {               
                CheckBox chkDon = (CheckBox)Item.FindControl("chkDon");
                decimal pcdon = chkDon.Checked == true? 1 : 0;
                pca.PCANN_CAUHINH_TOAAN(Convert.ToDecimal(Item.Cells[0].Text), pcdon);
            }
            
            txtthongbao.Text = "Lưu thành công !";
            Load_Data();
        }
        protected void dropPageSize_SelectedIndexChanged(object sender, EventArgs e)
        {
            dropPageSize2.SelectedValue = dropPageSize.SelectedValue;
            dgList.CurrentPageIndex = 0;
            dgList.PageSize = Convert.ToInt32(dropPageSize.SelectedValue);
            hddPageIndex.Value = "1";
            Load_Data();
        }
        protected void dropPageSize2_SelectedIndexChanged(object sender, EventArgs e)
        {
            dropPageSize.SelectedValue = dropPageSize2.SelectedValue;
            dgList.CurrentPageIndex = 0;
            dgList.PageSize = Convert.ToInt32(dropPageSize2.SelectedValue);
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
            dgList.CurrentPageIndex = 0;
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
            // dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex.Value = lbCurrent.Text;
            Load_Data();
        }

        #endregion
    }
}