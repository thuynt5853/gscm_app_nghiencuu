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

namespace WEB.GSTP.Danhmuc.CanBoVKS
{
    public partial class Danhsach : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        private const int ROOT = 0;
        private string PUBLIC_DEPT = "...";
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    LoadDropChucVu();                    
                    hddPageIndex.Value = "1";
                    Load_Data();
                    //MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    //Cls_Comon.SetButton(cmdThemmoi, oPer.TAOMOI);
                }
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
      
        public void LoadDropChucVu()
        {
            DropChucVu.Items.Clear();
            //DropChucVu.Items.Add(new ListItem("Chọn", ""));
            DropChucVu.Items.Add(new ListItem("Kiểm sát viên", ENUM_CHUCDANH.CHUCDANH_KSV));
            DropChucVu.Items.Add(new ListItem("Hội thẩm nhân dân", ENUM_CHUCDANH.CHUCDANH_HTND));
        }
        private void Load_Data()
        {
            DM_CANBOVKS_BL CanBoBL = new DM_CANBOVKS_BL();
            decimal ID_TOAAN = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
            DM_VKS dmvks = dt.DM_VKS.Where(x => x.TOAANID == ID_TOAAN).FirstOrDefault<DM_VKS>();

            String Group_Ma = DropChucVu.SelectedValue;
            String KeySearch = txKey.Text.Trim();
            int CurPage = Convert.ToInt32(hddPageIndex.Value), PageSize = Convert.ToInt32(hddPageSize.Value);
            DataTable oDT = CanBoBL.DM_CANBOVKS_SEARCH(dmvks.ID, Group_Ma, KeySearch, CurPage, PageSize);
            if (oDT != null && oDT.Rows.Count > 0)
            {
                int Total = Convert.ToInt32(oDT.Rows[0]["Total"].ToString());
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Total, PageSize).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + Total.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
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

            dgList.DataSource = oDT;
            dgList.DataBind();

        }
        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                Load_Data();
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
        protected void btnThemmoi_Click(object sender, EventArgs e)
        {
            Response.Redirect("Capnhat.aspx");
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            switch (e.CommandName)
            {
                case "Sua":
                    Response.Redirect("Capnhat.aspx?cb=" + e.CommandArgument.ToString());
                    break;
                case "Xoa":
                    decimal ID = Convert.ToDecimal(e.CommandArgument);
                    DM_CANBOVKS cbo = dt.DM_CANBOVKS.Where(x => x.ID == ID).FirstOrDefault<DM_CANBOVKS>();
                    if (cbo != null)
                    {
                        dt.DM_CANBOVKS.Remove(cbo);
                        dt.SaveChanges();
                    }
                    hddPageIndex.Value = "1";
                    Load_Data();
                    lbtthongbao.Text = "Xóa thành công!";
                    break;
            }
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            try
            {
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
                {
                    LinkButton lbtSua = (LinkButton)e.Item.FindControl("lbtSua");
                    LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                    lbtSua.Visible = oPer.CAPNHAT; lbtXoa.Visible = oPer.XOA;

                    if (DropChucVu.SelectedValue != ENUM_CHUCDANH.CHUCDANH_KSV)
                        lbtSua.Visible = lbtXoa.Visible = false;
                }
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                Load_Data();
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                Load_Data();
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                Load_Data();
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                Load_Data();
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                hddPageIndex.Value = lbCurrent.Text;
                Load_Data();
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
        #endregion

        protected void DropChucVu_SelectedIndexChanged(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            Load_Data();
        }
    }
}