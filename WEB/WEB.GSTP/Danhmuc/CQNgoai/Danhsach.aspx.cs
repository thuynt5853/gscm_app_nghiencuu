using BL.GSTP;
using BL.GSTP.Danhmuc;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.Danhmuc.CQNgoai
{
    public partial class Danhsach : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {                   
                    LoadData();
                }
            }
            catch (Exception ex) { }
        }
        private void LoadData()
        {
            
            string str = txtTimKiem.Text.Trim().ToLower();
            int pageIndex = Convert.ToInt32(hddPageIndex.Value), pageSize = Convert.ToInt32(hddPageSize.Value);
            List<DM_COQUANNGOAI> lst;
            if (str == "")
                lst = dt.DM_COQUANNGOAI.ToList();
            else
                lst = dt.DM_COQUANNGOAI.Where(x=>x.TENCOQUAN.ToLower().Contains(str)).ToList();
           
            if (lst != null && lst.Count > 0)
            {
                int Total = lst.Count;
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Total, pageSize).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + Total.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
               
            }
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value)-1;
            dgList.DataSource = lst;
            dgList.DataBind();
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            try
            {
                decimal curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
                switch (e.CommandName)
                {               
                    case "Xoa":
                        Xoa(curr_id);
                        break;
                }
            }
            catch (Exception ex) {  }
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                hddPageIndex.Value = lbCurrent.Text;
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #endregion
     
        private void Xoa(decimal id)
        {
            DM_COQUANNGOAI kqPT = dt.DM_COQUANNGOAI.Where(x => x.ID == id).FirstOrDefault<DM_COQUANNGOAI>();
            if (kqPT != null)
            {
                dt.DM_COQUANNGOAI.Remove(kqPT);
                dt.SaveChanges();
            }
           
            hddPageIndex.Value = "1";
            LoadData();
           
        }
        protected void cmdTimkiem_Click(object sender, EventArgs e)
        {
            try
            {

                hddPageIndex.Value = "1";
                LoadData();
            }
            catch (Exception ex) {  }
        }
    
    }
}