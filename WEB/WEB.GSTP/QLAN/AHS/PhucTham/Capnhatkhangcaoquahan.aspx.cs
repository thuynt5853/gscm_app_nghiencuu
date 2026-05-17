using BL.GSTP;
using BL.GSTP.AHS;
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

namespace WEB.GSTP.QLAN.AHS.PhucTham
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
                    LoadThamPhan1();
                    LoadThamPhan2();
                    hddPageIndex.Value = "1";
                    LoadGrid();
                    txtNgaygiaiquyet.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);

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
            string TP1 = hddTPTV1.Value;
            if (TP1 != "0" && TP1 != "")
                ddlGQ_Thamphan.Items.Remove(ddlGQ_Thamphan.Items.FindByValue(TP1));
            string TP2 = hddTPTV2.Value;
            if (TP2 != "0" && TP2 != "")
                ddlGQ_Thamphan.Items.Remove(ddlGQ_Thamphan.Items.FindByValue(TP2));
        }
        private void LoadThamPhan1()
        {
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
            ddlGQ_Thamphan1.DataSource = oCBDT;
            ddlGQ_Thamphan1.DataTextField = "MA_TEN";
            ddlGQ_Thamphan1.DataValueField = "ID";
            ddlGQ_Thamphan1.DataBind();
            ddlGQ_Thamphan1.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            string TP = hddTPCT.Value;
            if (TP != "0" && TP != "")
                ddlGQ_Thamphan1.Items.Remove(ddlGQ_Thamphan1.Items.FindByValue(TP));
            string TP2 = hddTPTV2.Value;
            if (TP2 != "0" && TP2 != "")
                ddlGQ_Thamphan1.Items.Remove(ddlGQ_Thamphan1.Items.FindByValue(TP2));
        }
        private void LoadThamPhan2()
        {
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THAMPHAN);

            ddlGQ_Thamphan2.DataSource = oCBDT;
            ddlGQ_Thamphan2.DataTextField = "MA_TEN";
            ddlGQ_Thamphan2.DataValueField = "ID";
            ddlGQ_Thamphan2.DataBind();
            ddlGQ_Thamphan2.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            string TP = hddTPCT.Value;
            if (TP != "0" && TP != "")
                ddlGQ_Thamphan2.Items.Remove(ddlGQ_Thamphan2.Items.FindByValue(TP));
            string TP1 = hddTPTV1.Value;
            if (TP1 != "0" && TP1 != "")
                ddlGQ_Thamphan2.Items.Remove(ddlGQ_Thamphan2.Items.FindByValue(TP1));
        }
        protected void ddlGQ_Thamphan_SelectedIndexChanged(object sender, EventArgs e)
        {
            string TP = ddlGQ_Thamphan.SelectedValue;
            string TP1 = ddlGQ_Thamphan1.SelectedValue;
            string TP2 = ddlGQ_Thamphan2.SelectedValue;
            if (TP != "" && TP != "0")
            {
                hddTPCT.Value = TP;
                if (TP1 == "" && TP1 == "0")
                {
                    LoadThamPhan1();
                }
                if (TP2 == "" && TP2 == "0")
                {
                    LoadThamPhan2();
                }

            }

        }
        protected void ddlGQ_Thamphan1_SelectedIndexChanged(object sender, EventArgs e)
        {
            string TP = ddlGQ_Thamphan.SelectedValue;
            string TP1 = ddlGQ_Thamphan1.SelectedValue;
            string TP2 = ddlGQ_Thamphan2.SelectedValue;
            if (TP1 != "0" && TP1 != "")
            {
                hddTPTV1.Value = TP1;
                if (TP == "0" && TP == "")
                {
                    LoadThamPhan();
                }
                if (TP2 == "0" && TP2 == "")
                {
                    LoadThamPhan2();
                }

            }
        }
        protected void ddlGQ_Thamphan2_SelectedIndexChanged(object sender, EventArgs e)
        {
            string TP = ddlGQ_Thamphan.SelectedValue;
            string TP1 = ddlGQ_Thamphan1.SelectedValue;
            string TP2 = ddlGQ_Thamphan2.SelectedValue;
            if (TP2 != "0" || TP2 != "")
            {
                hddTPTV2.Value = TP2;
                if (TP == "0" || TP == "")
                {
                    LoadThamPhan();
                }
                if (TP1 == "0" || TP1 == "")
                {
                    LoadThamPhan1();
                }

            }

        }
        private void LoadGrid()
        {
            lbthongbao.Text = "";
            ptT.Visible = ptB.Visible = true;
            if (rdbTrangthai.SelectedValue == "1")
                Cls_Comon.SetButton(cmdGiaiQuyet, false);
            else
                Cls_Comon.SetButton(cmdGiaiQuyet, true);

            decimal vDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            DateTime? dFrom = DateTime.Now;
            DateTime? dTo = DateTime.Now;
            dFrom = (String.IsNullOrEmpty(txtTuNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            dTo = (String.IsNullOrEmpty(txtDenNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            AHS_PHUCTHAM_BL oBL = new AHS_PHUCTHAM_BL();
            int pageSize = dgList.PageSize, pageIndex = Convert.ToInt32(hddPageIndex.Value);
            DataTable oDT = oBL.AHS_PT_KCQUAHAN(vDonViID, txtMaVuAn.Text, txtTenVuAn.Text, dFrom, dTo, Convert.ToDecimal(rdbTrangthai.SelectedValue), pageIndex, pageSize);
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
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                
                case "Xoa":
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    decimal ID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
                    string StrMsg = "Không được sửa đổi thông tin.";
                    string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(ID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    if (Result != "")
                    {
                        lbthongbao.Text = Result;
                        return;
                    }
                    xoa(ND_id);
                    break;
            }

        }

        public void xoa(decimal id)
        {
            AHS_SOTHAM_KHANGCAO oND = dt.AHS_SOTHAM_KHANGCAO.Where(x => x.VUANID == id).FirstOrDefault();
            if (oND != null)
            {
                oND.GQ_NGAY = null;
                oND.GQ_THAMPHANID = null;
                oND.GQ_THAMPHANID_1 =null;
                oND.GQ_THAMPHANID_2 = null;
                oND.GQ_ISCHAPNHAN = null;
                oND.GQ_TINHTRANG = null;
                oND.GQ_GHICHU = null;
                dt.SaveChanges();
               
                //dgList.CurrentPageIndex = 0;
                LoadGrid();
                //ResetControls();
            }
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
                hddTPTV1.Value = hddTPTV2.Value = hddTPCT.Value = "0";
                ddlGQ_Thamphan.Items.Clear();
                ddlGQ_Thamphan1.Items.Clear();
                ddlGQ_Thamphan2.Items.Clear();
                LoadThamPhan();
                LoadThamPhan1();
                LoadThamPhan2();
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
                }
            }
            if (hddVuViecID.Value + "" == "" || hddVuViecID.Value == "0")
            {
                lbthongbao.Text = "Bạn chưa chọn vụ án để giải quyết. Hãy chọn lại!";
                return;
            }
            else
            {
                decimal ID = Convert.ToDecimal(hddVuViecID.Value);
                AHS_VUAN vuAn = dt.AHS_VUAN.Where(x => x.ID == ID).FirstOrDefault<AHS_VUAN>();
                if (vuAn != null)
                {
                    lblTenVuAn.InnerText = "Vụ án: " + vuAn.TENVUAN;
                }
            }
            pnDanhsach.Visible = false;
            pnCapnhat.Visible = true;
            txtNgaygiaiquyet.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);

        }
        protected void cmdCapnhat_Click(object sender, EventArgs e)
        {
            #region Validate Data
            if (Cls_Comon.IsValidDate(txtNgaygiaiquyet.Text) == false)
            {
                lbthongbao.Text = "Bạn phải nhập ngày nhận theo định dạng (dd/MM/yyyy).";
                txtNgaygiaiquyet.Focus();
                return;
            }
            if (ddlGQ_Thamphan.SelectedValue == "0")
            {
                lbthongbao.Text = "Bạn chưa chọn thẩm phán. Hãy chọn lại!";
                ddlGQ_Thamphan.Focus();
                return;
            }
            if (rdbChapnhan.SelectedValue == "")
            {
                lbthongbao.Text = "Bạn chưa chọn kết quả. Hãy chọn lại!";
                return;
            }
            if (txtGQGhichu.Text.Length > 250)
            {
                lbthongbao.Text = "Bạn chưa chọn thẩm phán. Hãy chọn lại!";
                txtGQGhichu.Focus();
                return;
            }
            #endregion
            decimal VuAnID = Convert.ToDecimal(hddVuViecID.Value), DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            AHS_SOTHAM_KHANGCAO oT = dt.AHS_SOTHAM_KHANGCAO.Where(x => x.VUANID == VuAnID && x.GQ_TOAANID == DonViID).FirstOrDefault();
            if (oT != null)
            {
                //Cập nhật lại thông tin giải quyết kháng cáo quá hạn
                oT.GQ_NGAY = txtNgaygiaiquyet.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgaygiaiquyet.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                oT.GQ_THAMPHANID = Convert.ToDecimal(ddlGQ_Thamphan.SelectedValue);
                oT.GQ_THAMPHANID_1 = Convert.ToDecimal(ddlGQ_Thamphan1.SelectedValue);
                oT.GQ_THAMPHANID_2 = Convert.ToDecimal(ddlGQ_Thamphan2.SelectedValue);
                oT.GQ_ISCHAPNHAN = Convert.ToDecimal(rdbChapnhan.SelectedValue);
                oT.GQ_TINHTRANG = 1;
                oT.GQ_GHICHU = txtGQGhichu.Text;
                dt.SaveChanges();
                txtMaVuAn.Text = txtTenVuAn.Text = txtTuNgay.Text = txtDenNgay.Text = "";
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