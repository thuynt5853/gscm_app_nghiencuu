using BL.GSTP;
using BL.GSTP.GSTP;
using DAL.GSTP;
using Microsoft.Reporting.WebForms;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.BaoCao.GSTP
{
    public partial class Thamphananhuy : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    hddDonViLoginID.Value = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? "0" : Session[ENUM_SESSION.SESSION_DONVIID] + "";
                    LoadDropToaAn();
                    LoadDropChucDanh();
                    LoadDropChucVu();
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private void LoadDropToaAn()
        {
            decimal taID = Convert.ToDecimal(hddDonViLoginID.Value);
            string ArrSapXep = "0/";//, ArrSapXepEx = "0/";
            DM_TOAAN taLogin = dt.DM_TOAAN.Where(x => x.ID == taID).FirstOrDefault();
            if (taLogin != null)
            {
                ArrSapXep = taLogin.ARRSAPXEP + "/";
                //ArrSapXepEx = taLogin.ARRSAPXEP + "/";
            }
            List<DM_TOAAN> lst = dt.DM_TOAAN.Where(x => x.ARRSAPXEP.Contains(ArrSapXep) || x.ID == taID).OrderBy(x => x.ARRTHUTU).ToList();
            if (lst != null && lst.Count > 0)
            {
                ddlToaAn.DataSource = lst;
                ddlToaAn.DataTextField = "TEN";
                ddlToaAn.DataValueField = "ID";
                ddlToaAn.DataBind();
            }
            else
            {
                ddlToaAn.Items.Insert(0, new ListItem("-- Chọn --", "0"));
            }
        }
        public void LoadDropChucDanh()
        {
            ddlChucDanh.Items.Clear();
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable dmChucDanh = oBL.DM_DATAITEM_GetByGroupName_And_Key(ENUM_DANHMUC.CHUCDANH, "Thẩm phán");
            if (dmChucDanh != null && dmChucDanh.Rows.Count > 0)
            {
                ddlChucDanh.DataSource = dmChucDanh;
                ddlChucDanh.DataTextField = "TEN";
                ddlChucDanh.DataValueField = "ID";
                ddlChucDanh.DataBind();
            }
            ddlChucDanh.Items.Insert(0, new ListItem("-- Tất cả --", "0"));
        }
        public void LoadDropChucVu()
        {
            ddlChucVu.Items.Clear();
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable dmChucVu = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.CHUCVU);
            if (dmChucVu != null && dmChucVu.Rows.Count > 0)
            {
                ddlChucVu.DataSource = dmChucVu;
                ddlChucVu.DataTextField = "TEN";
                ddlChucVu.DataValueField = "ID";
                ddlChucVu.DataBind();
            }
            ddlChucVu.Items.Insert(0, new ListItem("-- Tất cả --", "0"));
        }
        private void LoadReport()
        {
            if (!CheckData())
            {
                return;
            }
            decimal ToaAn = Convert.ToDecimal(ddlToaAn.SelectedValue),
                    ChucDanh = Convert.ToDecimal(ddlChucDanh.SelectedValue),
                    ChucVu = Convert.ToDecimal(ddlChucVu.SelectedValue),
                    GomDonViCapDuoi = Convert.ToDecimal(ChkAllChild.Checked),
                    GioiTinh = Convert.ToDecimal(ddlGioiTinh.SelectedValue);
            string MaTP = txtMaTP.Text.Trim().ToLower(), 
                   TenTP = txtTenTP.Text.Trim().ToLower(), 
                   DiaChi = txtDiaChi.Text.Trim(),
                   SoCMND = txtCMND.Text.Trim(), 
                   NgaySinh = txtNgaySinh.Text, 
                   SoDienThoai = txtDienThoai.Text.Trim(),
                   NgayNhanCT = txtNgayNhanCT.Text, 
                   NgayBoNhiem = txtNgayBoNhiem.Text, 
                   NgayKetThuc = txtNgayKetThuc.Text, 
                   LoaiAn_HS = "", LoaiAn_DS = "", LoaiAn_HC = "", LoaiAn_HN = "", LoaiAn_KT = "", LoaiAn_LD = "", LoaiAn_PS = "", LoaiAn_XLHC = "";
            
            if (chkHinhsu.Checked)
            {
                LoaiAn_HS += ENUM_LOAIAN.AN_HINHSU + ",";
            }
            if (chkDansu.Checked)
            {
                LoaiAn_DS += ENUM_LOAIAN.AN_DANSU + ",";
            }
            if (chkHanhchinh.Checked)
            {
                LoaiAn_HC += ENUM_LOAIAN.AN_HANHCHINH + ",";
            }
            if (chkHNGD.Checked)
            {
                LoaiAn_HN += ENUM_LOAIAN.AN_HONNHAN_GIADINH + ",";
            }
            if (chkKDTM.Checked)
            {
                LoaiAn_KT += ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI + ",";
            }
            if (chkLaodong.Checked)
            {
                LoaiAn_LD += ENUM_LOAIAN.AN_LAODONG + ",";
            }
            if (chkPhasan.Checked)
            {
                LoaiAn_PS += ENUM_LOAIAN.AN_PHASAN + ",";
            }
            if (chkXLHC.Checked)
            {
                LoaiAn_XLHC += ENUM_LOAIAN.BPXLHC + ",";
            }
            GSTP_BL bl = new GSTP_BL();
            DataTable tbl = bl.REPORT_SOLUONG_TP_ANHUY(ToaAn, MaTP, TenTP, DiaChi, GioiTinh, SoCMND, NgaySinh, SoDienThoai, ChucDanh, ChucVu, NgayNhanCT,
                NgayBoNhiem, NgayKetThuc, LoaiAn_HS, LoaiAn_DS, LoaiAn_HC, LoaiAn_HN, LoaiAn_KT, LoaiAn_LD, LoaiAn_PS, LoaiAn_XLHC, GomDonViCapDuoi);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                string DataSetName = "DataSet1", reportName = "ThamphancoanTK.rdlc";
                String path = "~/BaoCao/GSTP/" + reportName;
                ReportViewer1.ProcessingMode = ProcessingMode.Local;
                ReportViewer1.LocalReport.ReportPath = Server.MapPath(path);
                ReportViewer1.LocalReport.ReportEmbeddedResource = "WEB.GSTP.BaoCao.GSTP." + reportName;
                ReportViewer1.LocalReport.DataSources.Clear();
                ReportViewer1.LocalReport.DataSources.Add(new ReportDataSource(DataSetName, tbl));
                ReportViewer1.Visible = true;
                ReportViewer1.LocalReport.EnableExternalImages = true;
                ReportViewer1.LocalReport.EnableHyperlinks = true;
                ReportViewer1.ShowReportBody = true;
                ReportViewer1.LocalReport.Refresh();
                ReportViewer1.LocalReport.DisplayName = "";
            }
            else
            {
                lbthongbao.Text = "Không tìm thấy dữ liệu.";
                ReportViewer1.Visible = false;
            }
        }
        protected void cmdXem_Click(object sender, EventArgs e)
        {
            try
            {
                LoadReport();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private bool CheckData()
        {
            if (txtNgaySinh.Text.Trim().Length > 0 && Cls_Comon.IsValidDate(txtNgaySinh.Text) == false)
            {
                lbthongbao.Text = "Bạn phải nhập ngày sinh theo định dạng (dd/MM/yyyy).";
                txtNgaySinh.Focus();
                return false;
            }
            if (txtNgayNhanCT.Text.Trim().Length > 0 && Cls_Comon.IsValidDate(txtNgayNhanCT.Text) == false)
            {
                lbthongbao.Text = "Bạn phải nhập ngày nhận công tác theo định dạng (dd/MM/yyyy).";
                txtNgayNhanCT.Focus();
                return false;
            }
            if (txtNgayBoNhiem.Text.Trim().Length > 0 && Cls_Comon.IsValidDate(txtNgayBoNhiem.Text) == false)
            {
                lbthongbao.Text = "Bạn phải nhập ngày bổ nhiệm theo định dạng (dd/MM/yyyy).";
                txtNgayBoNhiem.Focus();
                return false;
            }
            if (txtNgayKetThuc.Text.Trim().Length > 0 && Cls_Comon.IsValidDate(txtNgayKetThuc.Text) == false)
            {
                lbthongbao.Text = "Bạn phải nhập ngày kết thúc theo định dạng (dd/MM/yyyy).";
                txtNgayKetThuc.Focus();
                return false;
            }
            return true;
        }
        protected void chkAll_CheckedChanged(object sender, EventArgs e)
        {
            if (chkAll.Checked)
            {
                chkDansu.Checked = chkHanhchinh.Checked = chkHinhsu.Checked = chkHNGD.Checked = chkKDTM.Checked = chkLaodong.Checked = chkPhasan.Checked = chkXLHC.Checked = true;
            }
            else
            {
                chkDansu.Checked = chkHanhchinh.Checked = chkHinhsu.Checked = chkHNGD.Checked = chkKDTM.Checked = chkLaodong.Checked = chkPhasan.Checked = chkXLHC.Checked = false;
            }
        }
    }
}