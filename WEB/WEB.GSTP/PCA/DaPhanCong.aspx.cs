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
    public partial class DaPhanCong : System.Web.UI.Page
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
                decimal toa_an_id = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                DataTable check_pcdon = pca.PCANN_CHECK_TOA_PCDON(toa_an_id);
                if (check_pcdon.Rows.Count > 0)
                {
                    ddlgiaidoan.Enabled = false;
                }
                else
                {
                    ddlgiaidoan.Enabled = true;
                }
                Load_Data();               
            }
        }
        

        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        private void Load_Data()
        {
            
            //decimal toa_an_id = 27;
            decimal toa_an_id = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            decimal giai_doan = Convert.ToInt32(ddlgiaidoan.SelectedValue);
            string ten_vuan = Txtvuan.Text.Trim();
            string ten_thamphan = Textthamphan.Text.Trim();
            string tu_ngay = txtTuNgay.Text.Trim();
            string den_ngay = txtDenNgay.Text.Trim();

            int page_size = Convert.ToInt32(dropPageSize.SelectedValue);
            int pageindex = Convert.ToInt32(hddPageIndex.Value);
            
            DataTable tbl = pca.PCANN_DS_ANDAPC(giai_doan, toa_an_id, ten_vuan, ten_thamphan, tu_ngay, den_ngay, pageindex, page_size);
            if (tbl.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"
                int count_all = Convert.ToInt32(tbl.Rows[0]["count_all"] + "");
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

        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {             
                DataRowView rv = (DataRowView)e.Item.DataItem;
                Literal lttSua = (Literal)e.Item.FindControl("lttSua");
                if (rv["LOG"].ToString() != "0")
                {
                    lttSua.Text = "<a style='color:#0e7eee;cursor:pointer; margin-left:10px;' onclick = 'popup_lichsu(" + rv["ID_PHAN_CONG_AN"].ToString() + ");'>Lịch sử </a>";
                    //"<a href='javascript:;' onclick='popup_lichsu(" + rv["ID_PHAN_CONG_AN"].ToString() + ");'>Sửa</a>";
                }
                else
                {
                    lttSua.Text = "";
                }
               
            }
        }
        protected void ddlgiaidoan_SelectedIndexChanged(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
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

        protected void cmdLoadDsphancong_Click(object sender, EventArgs e)
        {
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