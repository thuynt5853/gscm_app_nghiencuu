using BL.GSTP;
using BL.GSTP.GSTP;
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

namespace WEB.GSTP.GSTP
{
    public partial class Danhsach : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    LoadDropDonVi();
                    LoadDropChucDanh();
                    if(Session["HSC"] + "" == "1")
                    {
                        txtTen.Text = Session["TenThamPhan"] + "";
                    }
                    hddPageIndex.Value = "1";
                    LoadData();
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private void LoadDropDonVi()
        {
            decimal DonViLogin = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            DM_TOAAN_BL toanBL = new DM_TOAAN_BL();
            DataTable dmToaAn = toanBL.DM_TOAAN_GETBY(DonViLogin);
            if (dmToaAn != null && dmToaAn.Rows.Count > 0)
            {
                ddlDonVi.DataSource = dmToaAn;
                ddlDonVi.DataTextField = "arrTEN";
                ddlDonVi.DataValueField = "ID";
                ddlDonVi.DataBind();
            }
            ddlDonVi.Items.Insert(0, new ListItem("Tất cả", "0"));
        }
        private void LoadDropChucDanh()
        {
            DM_DATAGROUP gChucDanh = dt.DM_DATAGROUP.Where(x => x.MA == ENUM_DANHMUC.CHUCDANH).FirstOrDefault<DM_DATAGROUP>();
            if (gChucDanh != null)
            {
                string MaChucDanhTP = "TPSC,TPTC,TPCC";
                List<DM_DATAITEM> lstChucDanh = dt.DM_DATAITEM.Where(x => x.GROUPID == gChucDanh.ID && MaChucDanhTP.Contains(x.MA)).ToList<DM_DATAITEM>();
                if (lstChucDanh.Count > 0)
                {
                    ddlChucDanh.DataSource = lstChucDanh;
                    ddlChucDanh.DataTextField = "TEN";
                    ddlChucDanh.DataValueField = "ID";
                    ddlChucDanh.DataBind();
                }
            }
            ddlChucDanh.Items.Insert(0, new ListItem("Tất cả", "0"));
        }
        protected void cmdTimkiem_Click(object sender, EventArgs e)
        {
            try
            {
                Session["HSC"] = "0";
                hddPageIndex.Value = "1";
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private bool CheckValid()
        {
            if (txtTuNgay.Text.Trim() != "" && Cls_Comon.IsValidDate(txtTuNgay.Text) == false)
            {
                lbthongbao.Text = "Ngày phân công từ ngày phải nhập theo định dạng (dd/MM/yyyy)!";
                txtTuNgay.Focus();
                return false;
            }

            if (txtDenNgay.Text.Trim() != "" && Cls_Comon.IsValidDate(txtDenNgay.Text) == false)
            {
                lbthongbao.Text = "Ngày phân công đến ngày phải nhập theo định dạng (dd/MM/yyyy)!";
                txtDenNgay.Focus();
                return false;
            }
            if (txtTuNgay.Text.Trim() != "" && txtDenNgay.Text.Trim() != "")
            {
                DateTime TuNgay = DateTime.Parse(txtTuNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault),
                       DenNgay = DateTime.Parse(txtDenNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                if (DateTime.Compare(TuNgay, DenNgay) > 0)
                {
                    lbthongbao.Text = "Ngày phân công từ ngày phải nhỏ hơn đến ngày.";
                    txtTuNgay.Focus();
                    return false;
                }
            }
            return true;
        }
        private void LoadData()
        {
            lbthongbao.Text = "";
            DSThamPhan.Visible = true;
            if (!CheckValid())
            {
                return;
            }
            #region xử lý dữ liệu nhập
            decimal DonViLogin = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]),
                    DonViID = Convert.ToDecimal(ddlDonVi.SelectedValue),
                    ChucDanh = Convert.ToDecimal(ddlChucDanh.SelectedValue);
            string TenThamPhan = txtTen.Text.Trim() ,
                   NgaySinh = txtNgaySinh.Text,
                   VaiTro = ddlvaiTro.SelectedValue,
                   SaphetNhiemKy = "0", KhieuNai = "0", KyLuat = "0", AnBiHuy = "0", AnApDungBPTT = "0", AnDinhChi = "0", AnTamDinhChi = "0",
                   AnQuaHan = "0", AnBiSua = "0", AnTreo = "0";
            DateTime? TuNgay = txtTuNgay.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(txtTuNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault),
                      DenNgay = txtDenNgay.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(txtDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            int Total = 0, PageSize = Convert.ToInt32(hddPageSize.Value), PageIndex = Convert.ToInt32(hddPageIndex.Value);
            foreach (ListItem item in chkListTrangThai.Items)
            {
                if (item.Selected)
                {
                    switch (item.Value)
                    {
                        case "0":
                            SaphetNhiemKy = "1";
                            break;
                        case "1":
                            KhieuNai = "1";
                            break;
                        case "2":
                            KyLuat = "1";
                            break;
                        case "3":
                            AnBiHuy = "1";
                            break;
                        case "4":
                            AnApDungBPTT = "1";
                            break;
                        case "5":
                            AnDinhChi = "1";
                            break;
                        case "6":
                            AnTamDinhChi = "1";
                            break;
                        case "7":
                            AnQuaHan = "1";
                            break;
                        case "8":
                            AnBiSua = "1";
                            break;
                        case "9":
                            AnTreo = "1";
                            break;
                    }
                }
            }
            #endregion
            GSTP_BL bl = new GSTP_BL();
            DataTable tbl = bl.DS_THAMPHAN_BYTOAAN(DonViLogin, DonViID, TenThamPhan, NgaySinh, ChucDanh, VaiTro, TuNgay, DenNgay, SaphetNhiemKy, KhieuNai, KyLuat, AnBiHuy, AnApDungBPTT, AnDinhChi, AnTamDinhChi, AnQuaHan, AnBiSua, AnTreo, PageIndex, PageSize);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                Total = Convert.ToInt32(tbl.Rows[0]["Total"] + "");
            }
            hddTotalPage.Value = Cls_Comon.GetTotalPage(Total, PageSize).ToString();
            lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + Total + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
            Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                         lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);

            dgList.PageSize = PageSize;
            dgList.DataSource = tbl;
            dgList.DataBind();
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                Session["HSC"] = "0";
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                Session["HSC"] = "0";
                hddPageIndex.Value = "1";
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                Session["HSC"] = "0";
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                Session["HSC"] = "0";
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                Session["HSC"] = "0";
                LinkButton lbCurrent = (LinkButton)sender;
                hddPageIndex.Value = lbCurrent.Text;
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #endregion
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal TPid = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "DanhGia":
                    Session[ENUM_LOAIAN.AN_GSTP] = TPid.ToString();
                    Session["MaChuongTrinh"] = ENUM_LOAIAN.AN_GSTP;
                    Response.Redirect("Thongtintonghop.aspx");
                    break;
            }
        }

    }
}