
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DAL.DKK;
using BL.DonKK;
using BL.GSTP.Danhmuc;
using BL.DonKK.DanhMuc;
using Module.Common;

using System.Globalization;

namespace WEB.GSTP.QTDKK.History
{
    public partial class Danhsach : System.Web.UI.Page
    {
        DKKContextContainer dt = new DKKContextContainer();
        private const int ROOT = 0;
        private string PUBLIC_DEPT = "...";
        Decimal CurrUserID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrUserID > 0)
            {
                if (!IsPostBack)
                {
                  //  LoadDropChucNang();
                    LoadGrid();
                }
            }
            else
                Response.Redirect("/Login.aspx");
        }
        //void LoadDropChucNang()
        //{
        //    dropChucNang.Items.Clear();
        //    dropChucNang.Items.Add(new ListItem("Tất cả", ""));
        //   // dropChucNang.Items.Add(new ListItem("", ENUM_HD_NGUOIDUNG_DKK.));

        //    dropChucNang.Items.Add(new ListItem("Đăng nhập", ENUM_HD_NGUOIDUNG_DKK.DANGNHAP));
        //    dropChucNang.Items.Add(new ListItem("Đăng xuất", ENUM_HD_NGUOIDUNG_DKK.DANGXUAT));
        //    dropChucNang.Items.Add(new ListItem("-------------------", ""));
        //    dropChucNang.Items.Add(new ListItem("Thêm", ENUM_HD_NGUOIDUNG_DKK.THEM));
        //    dropChucNang.Items.Add(new ListItem("Sửa", ENUM_HD_NGUOIDUNG_DKK.SUA));
        //    dropChucNang.Items.Add(new ListItem("Xóa", ENUM_HD_NGUOIDUNG_DKK.XOA));
        //    dropChucNang.Items.Add(new ListItem("-------------------", ""));
        //    dropChucNang.Items.Add(new ListItem("Thêm tài liệu", ENUM_HD_NGUOIDUNG_DKK.THEMTAILIEU));
        //    dropChucNang.Items.Add(new ListItem("Xóa tài liệu", ENUM_HD_NGUOIDUNG_DKK.XOATAILIEU));
        //    dropChucNang.Items.Add(new ListItem("-------------------", ""));
        //    dropChucNang.Items.Add(new ListItem("Đăng ký nhận văn bản", ENUM_HD_NGUOIDUNG_DKK.DKNHANVB));
        //    dropChucNang.Items.Add(new ListItem("Xóa đăng ký nhận văn bản", ENUM_HD_NGUOIDUNG_DKK.XOADKNHANVB));
        //    dropChucNang.Items.Add(new ListItem("Nhận văn bản", ENUM_HD_NGUOIDUNG_DKK.NHANVB));
        //}
        public void LoadGrid()
        {
            lblThongBao.Text = "";
            DataTable tbl = null;
            int page_size = 10;
            int pageindex = Convert.ToInt32(hddPageIndex.Value);

            string MaAction = "";// dropChucNang.SelectedValue;
            string textsearch = txKey.Text.Trim();

            DateTime? dFrom = DateTime.Now;
            DateTime? dTo = DateTime.Now;
            CultureInfo cul = new CultureInfo("vi-VN");
            dFrom = (String.IsNullOrEmpty(txtTuNgay.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            dTo = (String.IsNullOrEmpty(txtDenNgay.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

            DONKK_USER_HISTORY_BL objBL = new DONKK_USER_HISTORY_BL();
            tbl = objBL.GetAll(textsearch,MaAction, dFrom, dTo , pageindex, page_size);
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
                rpt.Visible = true;
            }
            else
            {
                rpt.Visible = false;
                lblThongBao.Text = "Không tìm thấy dữ liệu phù hợp điều kiện!";
            }
        }
        protected void btnTimKiem_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lblThongBao.Text = ex.Message; }

        }
        //protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        //{
        //    if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        //    {
        //        MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
        //        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        //        {
        //            LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
        //            Cls_Comon.SetLinkButton(lblSua, oPer.CAPNHAT);

        //            LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
        //            Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);
        //        }
        //    }
        //}
        //protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        //{
        //    decimal curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
            //switch (e.CommandName)
            //{
            //    case "Sua":
            //        Response.Redirect("CapnhatTB.aspx?tbID=" + e.CommandArgument.ToString());
            //        break;
            //    case "Xoa":
            //        MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            //        if (oPer.XOA == false)
            //        {
            //            lblThongBao.Text = "Bạn không có quyền xóa!";
            //            return;
            //        }
            //        xoa(curr_id);
            //        break;
            //}
        //}
        //public void xoa(decimal id)
        //{
        //    DONKK_TINTUC oT = dt.DONKK_TINTUC.Where(x => x.ID == id).FirstOrDefault();
        //    dt.DONKK_TINTUC.Remove(oT);
        //    dt.SaveChanges();

        //    hddPageIndex.Value = "1";
        //    LoadGrid();
        //    lblThongBao.Text = "Xóa thành công!";
        //}

        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value)- 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lblThongBao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lblThongBao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                // rpt.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) 1;
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lblThongBao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                //  rpt.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lblThongBao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                // rpt.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) 1;
                hddPageIndex.Value = lbCurrent.Text;
                LoadGrid();
            }
            catch (Exception ex) { lblThongBao.Text = ex.Message; }
        }
        #endregion
    }
}