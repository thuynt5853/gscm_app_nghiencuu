
using Module.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Data;

using System.Globalization;
using System.Web.UI.WebControls;

using DAL.DKK;
using BL.GSTP.Danhmuc;

using BL.DonKK.DanhMuc;

namespace WEB.GSTP.QTDKK.Tinbai
{
    public partial class DanhsachTB : System.Web.UI.Page
    {
        DKKContextContainer dt = new DKKContextContainer();
        CultureInfo cul = new CultureInfo("vi-VN");
        private const int ROOT = 0, DEL = 0, ADD = 1, UPDATE = 2;
        private string PUBLIC_DEPT = "...";
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    LoadDropChuyenMuc();
                    LoadDropTrangthai();
                    LoadGrid();
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private void LoadDropChuyenMuc()
        {
            dropChuyenMuc.Items.Clear();
            dropChuyenMuc.DataSource = null;
            dropChuyenMuc.DataBind();
            dropChuyenMuc.Items.Add(new ListItem("Chọn chuyên mục tin", ROOT.ToString()));
            LoadDropChuyenMucListChild(0, PUBLIC_DEPT);
        }

        private void LoadDropTrangthai()
        {
            dropTrangThai.Items.Clear();
            dropTrangThai.Items.Add(new ListItem("--- Chọn trạng thái ---", "0"));
            dropTrangThai.Items.Add(new ListItem("Đang lưu", "1"));
            dropTrangThai.Items.Add(new ListItem("Đã đăng", "2"));
            dropTrangThai.Items.Add(new ListItem("Hạ xuống", "3"));
        }
        private void LoadDropChuyenMucListChild(decimal pID, string dept)
        {
            DataTable tbl = null;
            DONKK_CHUYENMUC_BL obj = new DONKK_CHUYENMUC_BL();
            tbl = obj.GetAllByCapChaID(pID);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                Decimal current_id = 0;
                foreach (DataRow row in tbl.Rows)
                {
                    current_id = Convert.ToDecimal(row["ID"].ToString());
                    dropChuyenMuc.Items.Add(new ListItem(dept + row["TENCHUYENMUC"] + "", current_id.ToString()));
                    LoadDropChuyenMucListChild(current_id, PUBLIC_DEPT + dept);
                }
            }
        }
        public void LoadGrid()
        {
            lbthongbao.Text = "";
            DataTable tbl = null;
            int page_size = 10;
            int pageindex = Convert.ToInt32(hddPageIndex.Value);
            string tukhoa = txtTukhoa.Text.Trim();
            int chuyenmucID = Convert.ToInt32(dropChuyenMuc.SelectedValue);
            int trangthai = Convert.ToInt32(dropTrangThai.SelectedValue);

            DonKK_TinTuc_BL objBL = new DonKK_TinTuc_BL();
            tbl = objBL.GetAllPaging(tukhoa, chuyenmucID, trangthai, pageindex, page_size);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                int count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");

                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
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
        protected void btnTimKiem_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
            
        }
        protected void btnThemMoi_Click(object sender, EventArgs e)
        {
            Response.Redirect("CapnhatTB.aspx");
        }
        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
                {
                    LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                    Cls_Comon.SetLinkButton(lblSua, oPer.CAPNHAT);

                    LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                    Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);
                }
            }
        }
        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Sua":
                    Response.Redirect("CapnhatTB.aspx?tbID=" + e.CommandArgument.ToString());
                    break;
                case "Xoa":
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (oPer.XOA == false)
                    {
                        lbthongbao.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    xoa(curr_id);
                    break;
            }
        }
        public void xoa(decimal id)
        {
            DONKK_TINTUC oT = dt.DONKK_TINTUC.Where(x => x.ID == id).FirstOrDefault();
            dt.DONKK_TINTUC.Remove(oT);
            dt.SaveChanges();

            hddPageIndex.Value = "1";
            LoadGrid();
            lbthongbao.Text = "Xóa thành công!";
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
                // rpt.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
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
        protected void dropTrangThai_SelectedIndexChanged(object sender, EventArgs e)
        {
            return;
        }
        protected void dropChuyenMuc_SelectedIndexChanged(object sender, EventArgs e)
        {
            return;
        }
        protected void btnDel_Click(object sender, EventArgs e)
        {
            try
            {
                if (hddCurrID.Value != "0")
                {
                    int id = Convert.ToInt32(hddCurrID.Value);
                    DONKK_TINTUC oT = dt.DONKK_TINTUC.Where(x => x.ID == id && x.TRANGTHAI == 2).FirstOrDefault();
                    if (oT != null)
                    {
                        lbthongbao.Text = "Không xóa được vì tin đã được duyệt!";
                    }
                    else
                    {
                        int danhMucID = Convert.ToInt32(hddCurrID.Value);
                        xoa(danhMucID);
                        lbthongbao.Text = "Xóa thành công!";
                    }
                }
                else
                {
                    lbthongbao.Text = "Bạn chưa chọn thông tin cần xóa!";
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
    }
}