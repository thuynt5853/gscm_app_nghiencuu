using DAL.GSTP;
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
namespace WEB.GSTP.QLAN.THA.QuyetDinh
{
    public partial class Danhsach : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        Decimal CurrUserID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrUserID > 0)
            {
                if (!IsPostBack)
                {
                    LoadGrid();

                    //MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    //Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                }
            }
            else
                Response.Redirect("/Login.aspx");
        }
      

        public void LoadGrid()
        {
            //string textsearch = txttimkiem.Text.Trim();
            //int hieuluc = (string.IsNullOrEmpty(dropHieuLuc.SelectedValue)) ? 2 : Convert.ToInt32(dropHieuLuc.SelectedValue);
            //int page_size = 20;
            //int pageindex = Convert.ToInt32(hddPageIndex.Value);

            //DM_BOLUAT_BL objBL = new DM_BOLUAT_BL();
            //DataTable tbl = objBL.DM_BOLUAT_GetAllPaging(textsearch, hieuluc, pageindex, page_size);
            //if (tbl != null && tbl.Rows.Count > 0)
            //{
            //    int count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");

            //    #region "Xác định số lượng trang"
            //    hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
            //    lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
            //    Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
            //                 lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
            //    #endregion

            //    rpt.DataSource = tbl;
            //    rpt.DataBind();
            //    pndata.Visible = true;
            //}
            //else
            //{
            //    pndata.Visible = false;
            //    lbthongbao.Text = "Không tìm thấy dữ liệu phù hợp điều kiện!";
            //}
        }

        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                // rpt.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadGrid();
            }
            catch (Exception ex)
            {
                //lbthongbao.Text = ex.Message; 
            }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {

                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex)
            {
                //lbthongbao.Text = ex.Message; 
            }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                // rpt.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGrid();
            }
            catch (Exception ex)
            {
                //lbthongbao.Text = ex.Message; 
            }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                //  rpt.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadGrid();
            }
            catch (Exception ex)
            {
                //lbthongbao.Text = ex.Message; 
            }
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
            catch (Exception ex)
            {
                //lbthongbao.Text = ex.Message; 
            }
        }
        #endregion
        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "toidanh":
                    Response.Redirect("Edit.aspx?vID=" + curr_id);
                    break;
                case "Sua":
                    //LoadInfo(curr_id);
                    //hddCurrID.Value = e.CommandArgument.ToString();
                    break;
                case "Xoa":
                    //MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    //if (oPer.XOA == false)
                    //{
                    //    lbthongbao.Text = "Bạn không có quyền xóa!";
                    //    return;
                    //}
                    //xoa(curr_id);
                    //Resetcontrol();

                    break;
            }
        }
        public void xoa(decimal id)
        {
            //List<DM_BOLUAT_TOIDANH> lst = dt.DM_BOLUAT_TOIDANH.Where(x => x.LUATID == id).ToList();
            //if (lst.Count > 0)
            //{
            //    lbthongbao.Text = "Nhóm danh mục đã có dữ liệu, không thể xóa được.";
            //    return;
            //}

            //DM_BOLUAT oT = dt.DM_BOLUAT.Where(x => x.ID == id).FirstOrDefault();
            //dt.DM_BOLUAT.Remove(oT);
            //dt.SaveChanges();

            //hddPageIndex.Value = "1";
            //LoadGrid();
            //Resetcontrol();
            //lbthongbao.Text = "Xóa thành công!";
        }

        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                //MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                //LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                //Cls_Comon.SetLinkButton(lblSua, oPer.CAPNHAT);

                //LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                //Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);
            }
        }

        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex)
            {
                //lbthongbao.Text = ex.Message; 
            }
        }
        protected void btnThemmoi_Click(object sender, EventArgs e)
        {
            Response.Redirect("Edit.aspx");
        }
    }
}