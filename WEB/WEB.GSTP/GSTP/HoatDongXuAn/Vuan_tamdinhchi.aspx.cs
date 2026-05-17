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
    public partial class Vuan_tamdinhchi : System.Web.UI.Page
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
            string TenVuAn = txtTenVuAn.Text.Trim(), SoQDBA = txtSoBAQD.Text.Trim();
            DateTime? NgayQDBA = txtNgayBAQD.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayBAQD.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            GSTP_BL bl = new GSTP_BL();
            DataTable tbl = bl.DS_ANTDC_BYTP(ThamPhanID, TenVuAn, SoQDBA, NgayQDBA);
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
                if (txtNgayBAQD.Text.Trim().Length > 0 && Cls_Comon.IsValidDate(txtNgayBAQD.Text) == false)
                {
                    lblthongbao.Text = "Ngày QĐBA phải theo định dạng (dd/MM/yyyy)!";
                    txtNgayBAQD.Focus();
                    return;
                }
                hddPageIndex.Value = "1";
                LoadData();
            }
            catch (Exception ex) { lblthongbao.Text = ex.Message; }
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            string[] arr = e.CommandArgument.ToString().Split('#');
            string VuAnID = arr[0], LoaiAn = arr[1];
            Session["GSTP_CALL_VUAN_INFO"] = VuAnID;
            if (e.CommandName == "ChiTiet")
            {
                switch (LoaiAn)
                {
                    case "AHS":
                        Cls_Comon.CallFunctionJS(this, this.GetType(), "CallPopupInforAHS()");
                        break;
                    case "ADS":
                        Cls_Comon.CallFunctionJS(this, this.GetType(), "CallPopupInforADS()");
                        break;
                    case "AHN":
                        Cls_Comon.CallFunctionJS(this, this.GetType(), "CallPopupInforAHN()");
                        break;
                    case "AKT":
                        Cls_Comon.CallFunctionJS(this, this.GetType(), "CallPopupInforAKT()");
                        break;
                    case "ALD":
                        Cls_Comon.CallFunctionJS(this, this.GetType(), "CallPopupInforALD()");
                        break;
                    case "AHC":
                        Cls_Comon.CallFunctionJS(this, this.GetType(), "CallPopupInforAHC()");
                        break;
                    case "APS":
                        Cls_Comon.CallFunctionJS(this, this.GetType(), "CallPopupInforAPS()");
                        break;
                    case "XLHC":
                        Cls_Comon.CallFunctionJS(this, this.GetType(), "CallPopupInforBPXLHC()");
                        break;
                }
            }
        }
    }
}