using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Data;
using System.Web.UI.WebControls;
using DAL.DKK;
using BL.GSTP.Danhmuc;
using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using BL.DonKK.DanhMuc;
namespace WEB.DONKHOIKIEN
{
    public partial class LienHe : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        private const int ROOT = 0, DEL = 0, ADD = 1, UPDATE = 2;
        string public_dept = "...";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadData();
            }
            txtToaAn.Attributes.Add("keypress", "search_data();");
        }
        protected void cmdSearch_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            Decimal ToaAnID = (string.IsNullOrEmpty(hddToaAnID.Value)) ? 1 : Convert.ToDecimal(hddToaAnID.Value);
            LoadData();
        }
        public void LoadData()
        {
            lbthongbao.Text = "";
            Decimal ToaAnID = (string.IsNullOrEmpty(hddToaAnID.Value)) ? 0 : Convert.ToDecimal(hddToaAnID.Value);
            string textsearch = txtToaAn.Text.Trim();
            int type_search = 0;
            if (ToaAnID == 0 && String.IsNullOrEmpty(textsearch))
            {
                type_search = 1;
                ToaAnID = 1;
            }
            else
            {
                if (String.IsNullOrEmpty(textsearch) && ToaAnID > 0)
                {
                    type_search =1;
                    ToaAnID = 1;
                }
            }
            int countItem = 0;
            int pageSize = Convert.ToInt32(hddPageSize.Value);
            int pageIndex = Convert.ToInt32(hddPageIndex.Value);
            DONKK_USERS_BL objBL = new DONKK_USERS_BL();
            DataTable tbl = objBL.GetAllToaAnByDK(ToaAnID, textsearch, pageIndex, pageSize);
            if (tbl != null && tbl.Rows.Count>0)
            {
                if (type_search > 0)
                {
                    //sap xep theo cha-con
                    String temp = "";
                    string ArrSapXep = "";
                    string ten_toa_an = "";
                    String[] arr = null;
                    foreach (DataRow row in tbl.Rows)
                    {
                        temp = "";
                        ten_toa_an = row["Ten"].ToString();
                        ArrSapXep = ("/" + row["ArrSapXep"].ToString()).Replace("/0/", "");
                        if (ArrSapXep.Contains("/"))
                        {
                            arr = ArrSapXep.Split('/');
                            for (int i = 1; i < arr.Length; i++)
                                temp += public_dept;
                        }

                        temp += ten_toa_an;
                        row["Ten"] = temp;
                    }
                }
                //--------------------------------
                countItem = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");
                hddTotalPage.Value = Cls_Comon.GetTotalPage(countItem, pageSize).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + countItem.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);

                rpt.Visible = pnPaging1.Visible = pnPaging2.Visible = true;
                rpt.DataSource = tbl;
                rpt.DataBind();
                hddToaAnID.Value = "";
            }
            else
            {
                rpt.DataSource = null;
                rpt.DataBind();
                rpt.Visible = pnPaging1.Visible = pnPaging2.Visible = false;
            }
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
    }
}