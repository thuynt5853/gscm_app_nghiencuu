using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.XLHC.Phuctham
{
    public partial class Capnhatkhangcaoquahan : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    LoadThamPhan();
                    hddPageIndex.Value = "1";
                    LoadGrid();
                    Cls_Comon.SetButton(cmdGiaiQuyet, false);
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private void LoadThamPhan()
        {
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
            ddlGQ_Thamphan.DataSource = oCBDT;
            ddlGQ_Thamphan.DataTextField = "MA_TEN";
            ddlGQ_Thamphan.DataValueField = "ID";
            ddlGQ_Thamphan.DataBind();
            ddlGQ_Thamphan.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }
        private void LoadGrid()
        {
            lbthongbao.Text = "";
            ptT.Visible = ptB.Visible = true;
            if (rdbTrangthai.SelectedValue == "1")
            {
                Cls_Comon.SetButton(cmdGiaiQuyet, false);
            }
            else
            {
                Cls_Comon.SetButton(cmdGiaiQuyet, true);
            }
            decimal vDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            DateTime? dFrom = DateTime.Now;
            DateTime? dTo = DateTime.Now;
            dFrom = (String.IsNullOrEmpty(txtTuNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            dTo = (String.IsNullOrEmpty(txtDenNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            XLHC_PHUCTHAM_BL oBL = new XLHC_PHUCTHAM_BL();
            int pageSize = dgList.PageSize, pageIndex = Convert.ToInt32(hddPageIndex.Value);
            //DataTable oDT = oBL.XLHC_PT_KCQUAHAN(vDonViID, txtMaVuViec.Text, txtTenVuViec.Text, dFrom, dTo, Convert.ToDecimal(rdbTrangthai.SelectedValue), pageIndex, pageSize);
            DataTable oDT = oBL.XLHC_PT_KCQUAHAN_V2(vDonViID, txtMaVuViec.Text, txtTenVuViec.Text, dFrom, dTo, Convert.ToDecimal(rdbTrangthai.SelectedValue), pageIndex, pageSize);

                    int Total = 0;
            if (oDT != null && oDT.Rows.Count > 0)
            {
                Total = Convert.ToInt32(oDT.Rows[0]["CountAll"]);
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Total, dgList.PageSize).ToString();
            }
            else
            {
                Cls_Comon.SetButton(cmdGiaiQuyet, false);
            }
            lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + Total.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
            Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                         lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
            dgList.DataSource = oDT;
            dgList.DataBind();
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
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
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
                hddPageIndex.Value = lbCurrent.Text;
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #endregion
        protected void cmdTimkiem_Click(object sender, EventArgs e)
        {
            try
            {
                #region Validate
                if (txtTuNgay.Text != "" && Cls_Comon.IsValidDate(txtTuNgay.Text) == false)
                {
                    lbthongbao.Text = "Bạn phải nhập kháng cáo từ ngày theo định dạng (dd/MM/yyyy)!";
                    txtTuNgay.Focus();
                    return;
                }
                if (txtDenNgay.Text != "" && Cls_Comon.IsValidDate(txtDenNgay.Text) == false)
                {
                    lbthongbao.Text = "Bạn phải nhập kháng cáo đến ngày theo định dạng (dd/MM/yyyy)!";
                    txtDenNgay.Focus();
                    return;
                }
                if (txtTuNgay.Text != "" && txtDenNgay.Text != "")
                {
                    DateTime TuNgay = DateTime.Parse(txtTuNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                    DateTime DenNgay = DateTime.Parse(txtDenNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                    if (DateTime.Compare(TuNgay, DenNgay) > 0)
                    {
                        lbthongbao.Text = "Bạn phải nhập kháng cáo từ ngày phải nhỏ hơn đến ngày!";
                        txtDenNgay.Focus();
                        return;
                    }
                }
                #endregion
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void chkChon_CheckedChanged(object sender, EventArgs e)
        {
            if (rdbTrangthai.SelectedValue == "1")
            {
                Cls_Comon.SetButton(cmdGiaiQuyet, false);
                return;
            }
            CheckBox chkXem = (CheckBox)sender;
            decimal ID = Convert.ToDecimal(chkXem.ToolTip);
            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                if (chkXem.Checked)
                {
                    if (chkXem.ToolTip != chkChon.ToolTip) chkChon.Checked = false;
                    Cls_Comon.SetButton(cmdGiaiQuyet, true);
                }
                else
                    Cls_Comon.SetButton(cmdGiaiQuyet, false);
            }
        }
        protected void cmdQuaylai_Click(object sender, EventArgs e)
        {
            pnDanhsach.Visible = true;
            pnCapnhat.Visible = false;
            try
            {
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void cmdGiaiQuyet_Click(object sender, EventArgs e)
        {
            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                if (chkChon.Checked)
                {
                    hddVuViecID.Value = Item.Cells[0].Text;
                    hddKhangCaoID.Value = Item.Cells[8].Text;
                }
            }
            if (hddVuViecID.Value + "" == "" || hddVuViecID.Value == "0")
            {
                lbthongbao.Text = "Bạn chưa chọn vụ việc để giải quyết. Hãy chọn lại!";
                return;
            }
            else
            {
                decimal ID = Convert.ToDecimal(hddVuViecID.Value);
                XLHC_DON don = dt.XLHC_DON.Where(x => x.ID == ID).FirstOrDefault<XLHC_DON>();
                if (don != null)
                {
                    lblTenVuAn.InnerText = "Vụ việc: " + don.TENVUVIEC;
                }
            }
            pnDanhsach.Visible = false;
            pnCapnhat.Visible = true;
        }
        protected void cmdCapnhat_Click(object sender, EventArgs e)
        {
            if (Cls_Comon.IsValidDate(txtNgaygiaiquyet.Text) == false)
            {
                lbthongbao.Text = "Bạn phải nhập ngày nhận theo định dạng (dd/MM/yyyy).";
                txtNgaygiaiquyet.Focus();
                return;
            }
            decimal VuViecID = Convert.ToDecimal(hddVuViecID.Value), DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            decimal khangCaoID = Convert.ToDecimal(hddKhangCaoID.Value);
            XLHC_SOTHAM_KHANGCAO oT = dt.XLHC_SOTHAM_KHANGCAO.Where(x => x.DONID == VuViecID && x.TOAANRAQDID == DonViID && x.ID == khangCaoID).FirstOrDefault();
            if (oT != null)
            {
                //Cập nhật lại thông tin giải quyết kháng cáo quá hạn
                oT.GQ_NGAY = txtNgaygiaiquyet.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgaygiaiquyet.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                oT.GQ_THAMPHANID = Convert.ToDecimal(ddlGQ_Thamphan.SelectedValue);
                oT.GQ_ISCHAPNHAN = Convert.ToDecimal(rdbChapnhan.SelectedValue);
                oT.GQ_TINHTRANG = 1;
                oT.GQ_GHICHU = txtGQGhichu.Text;
                dt.SaveChanges();
                txtMaVuViec.Text = txtTenVuViec.Text = txtTuNgay.Text = txtDenNgay.Text = "";
                rdbTrangthai.SelectedValue = "1";
                LoadGrid();
                pnDanhsach.Visible = true;
                pnCapnhat.Visible = false;
                Cls_Comon.SetButton(cmdGiaiQuyet, false);
            }
            else
            {
                lbthongBaoUpdate.Text = "Không tìm thấy kháng cáo cần giải quyết!";
            }
        }
    }
}