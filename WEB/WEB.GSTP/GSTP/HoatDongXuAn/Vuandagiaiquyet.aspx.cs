using BL.GSTP.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.GSTP.HoatDongXuAn
{
    public partial class Vuandagiaiquyet : System.Web.UI.Page
    {
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    hddPageIndex.Value = "1";
                    LoadData();
                }
            }
            catch (Exception ex) { lblthongbao.Text = ex.Message; }
        }
        private void LoadData()
        {
            lblthongbao.Text = "";
            PhanTrangTren.Visible = PhanTrangDuoi.Visible = true;
            decimal ThamPhanID = string.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_GSTP] + "") ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_GSTP]);
            int Total = 0, pageSize = Convert.ToInt32(hddPageSize.Value);
            string TenVuAn = txtTenVuAn.Text.Trim().ToLower(), SoQDBA = txtSoBAQD.Text.Trim().ToLower();
            DateTime? NgayQDBA = txtNgayBAQD.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayBAQD.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            GSTP_BL bl = new GSTP_BL();
            DataTable tbl = bl.DS_AN_DAGIAIQUYET_BYTP(ThamPhanID, TenVuAn, SoQDBA, NgayQDBA);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                Total = tbl.Rows.Count;
                dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 1;
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Total, pageSize).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + Total.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
            }
            else { lblthongbao.Text = "Không tìm thấy dữ liệu."; PhanTrangTren.Visible = PhanTrangDuoi.Visible = false; }
            dgList.PageSize = pageSize;
            dgList.DataSource = tbl;
            dgList.DataBind();
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadData();
            }
            catch (Exception ex) { lblthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadData();
            }
            catch (Exception ex) { lblthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadData();
            }
            catch (Exception ex) { lblthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadData();
            }
            catch (Exception ex) { lblthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                hddPageIndex.Value = lbCurrent.Text;
                LoadData();
            }
            catch (Exception ex) { lblthongbao.Text = ex.Message; }
        }
        #endregion
        protected void cmdTimkiem_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadData();
            }
            catch (Exception ex) { lblthongbao.Text = ex.Message; }
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;
                Label lblTrangThai = (Label)e.Item.FindControl("lblTrangThai");
                Label lblNgayPhanCong = (Label)e.Item.FindControl("lblNgayPhanCong");
                lblNgayPhanCong.Text = rowView["NGAYPHANCONG"] + ""==""?"":DateTime.Parse(rowView["NGAYPHANCONG"]+"",cul,DateTimeStyles.NoCurrentDateDefault).ToString("dd/MM/yyyy");
                string TrangThai = rowView["TrangThai"] + "";
                if (TrangThai != "" && TrangThai.Contains(','))
                {
                    TrangThai = TrangThai.Trim();
                    lblTrangThai.Text = TrangThai.Substring(0, TrangThai.Length - 6);
                }
            }
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            string[] arr = e.CommandArgument.ToString().Split('#');
            string VuAnID = arr[0], LinhVuc = arr[1], GiaiDoan = arr[2];
            Session["GSTP_CALL_VUAN_INFO"] = VuAnID;
            if (e.CommandName == "ChiTiet")
            {
                switch (LinhVuc)
                {
                    case "Hình sự":
                        Cls_Comon.CallFunctionJS(this, this.GetType(), "CallPopupAHS_DGQ()");
                        break;
                    case "Dân sự":
                        Cls_Comon.CallFunctionJS(this, this.GetType(), "CallPopupADS_DGQ()");
                        break;
                    case "HN & GĐ":
                        Cls_Comon.CallFunctionJS(this, this.GetType(), "CallPopupAHN_DGQ()");
                        break;
                    case "KD,TM":
                        Cls_Comon.CallFunctionJS(this, this.GetType(), "CallPopupAKT_DGQ()");
                        break;
                    case "Lao động":
                        Cls_Comon.CallFunctionJS(this, this.GetType(), "CallPopupALD_DGQ()");
                        break;
                    case "Hành chính":
                        Cls_Comon.CallFunctionJS(this, this.GetType(), "CallPopupAHC_DGQ()");
                        break;
                    case "Phá sản":
                        Cls_Comon.CallFunctionJS(this, this.GetType(), "CallPopupAPS_DGQ()");
                        break;
                    case "BP XLHC":
                        Cls_Comon.CallFunctionJS(this, this.GetType(), "CallPopupBPXLHC_DGQ()");
                        break;
                }
            }
        }

    }
}