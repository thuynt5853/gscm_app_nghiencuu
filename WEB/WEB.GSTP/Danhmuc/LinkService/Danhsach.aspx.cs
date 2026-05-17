using DAL.GSTP;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.Danhmuc.LinkService
{
    public partial class Danhsach : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    hddPageIndex.Value = "1";
                    LoadDanhSach();
                }
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
        private void LoadDanhSach()
        {
            int Total = 0, PageSize = Convert.ToInt32(hddPageSize.Value), PageIndex = Convert.ToInt16(hddPageIndex.Value);
            string Key = txtKey.Text.Trim().ToLower();
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vKey",Key),
                new OracleParameter("vPageIndex",PageIndex),
                new OracleParameter("vPageSize",PageSize),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GSTP_LINKSVR_GETDATA", prm);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                Total = Convert.ToInt32(tbl.Rows[0]["Total"]);
            }
            dgList.PageSize = PageSize;
            dgList.CurrentPageIndex = 0;
            dgList.DataSource = tbl;
            dgList.DataBind();
            #region "Xác định số lượng trang"
            hddTotalPage.Value = Cls_Comon.GetTotalPage(Total, PageSize).ToString();
            lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + Total.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
            Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                         lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
            #endregion
            if (Total == 0)
            {
                lstSobanghiT.Text = lstSobanghiB.Text = "";
                lbtthongbao.Text = "Không có dữ liệu.";
                PhanTrangT.Visible = PhanTrangB.Visible = false;
            }
            else
            {
                PhanTrangT.Visible = PhanTrangB.Visible = true;
            }
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadDanhSach();
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadDanhSach();
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadDanhSach();
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadDanhSach();
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                hddPageIndex.Value = lbCurrent.Text;
                LoadDanhSach();
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
        #endregion
        protected void cmdTimkiem_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadDanhSach();
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal ID= Convert.ToDecimal(e.CommandArgument.ToString());
            GSTP_LINKSVR LinkSV = dt.GSTP_LINKSVR.Where(x => x.ID == ID).FirstOrDefault();
            switch (e.CommandName)
            {
                case "Sua":
                    if (LinkSV != null)
                    {
                        txtMa.Text = LinkSV.MA + "";
                        txtDuongDan.Text = LinkSV.LINK + "";
                        txtGhiChu.Text = LinkSV.GHICHU + "";
                        hddID.Value = LinkSV.ID + "";
                    }
                    break;
                case "Xoa":
                    if (LinkSV != null)
                    {
                        dt.GSTP_LINKSVR.Remove(LinkSV);
                        dt.SaveChanges();
                        hddPageIndex.Value = "1";
                        LoadDanhSach();
                        ResetControl();
                        lbtthongbao.Text="Xóa thành công!";
                    }
                    break;
            }
        }
        private void ResetControl()
        {
            txtMa.Text = txtDuongDan.Text = txtGhiChu.Text = "";hddID.Value = "0";
        }
        protected void cmdLammoi_Click(object sender, EventArgs e)
        {
            ResetControl();
        }
        protected void cmdLuu_Click(object sender, EventArgs e)
        {
            if (CheckValiDate() == false)
            {
                return;
            }
            string Ma = txtMa.Text.Trim();
            decimal ID = Convert.ToDecimal(hddID.Value);
            if (CheckIsExists(Ma,ID))
            {
                return;
            }
            bool isNew = false;
            GSTP_LINKSVR LinkSV = dt.GSTP_LINKSVR.Where(x => x.ID == ID).FirstOrDefault();
            if (LinkSV == null)
            {
                LinkSV = new GSTP_LINKSVR();
                isNew = true;
            }
            LinkSV.MA = Ma;
            LinkSV.LINK = txtDuongDan.Text.Trim();
            LinkSV.GHICHU = txtGhiChu.Text.Trim();
            if (isNew)
            {
                dt.GSTP_LINKSVR.Add(LinkSV);
            }
            dt.SaveChanges();
            hddPageIndex.Value = "1";
            LoadDanhSach();
            ResetControl();
            lbtthongbao.Text = "Lưu thành công!";
        }
        private bool CheckValiDate()
        {
            int LengthMa = txtMa.Text.Trim().Length;
            if (LengthMa == 0)
            {
                lbtthongbao.Text = "Chưa nhập mã dịch vụ. Hãy nhập lại!";
                txtMa.Focus();
                return false;
            }
            if (LengthMa > 50)
            {
                lbtthongbao.Text = "Mã dịch vụ không quá 50 ký tự. Hãy nhập lại!";
                txtMa.Focus();
                return false;
            }
            int LengthDuongDan = txtDuongDan.Text.Trim().Length;
            if (LengthDuongDan == 0)
            {
                lbtthongbao.Text = "Chưa nhập đường dẫn dịch vụ. Hãy nhập lại!";
                txtDuongDan.Focus();
                return false;
            }
            if (LengthDuongDan > 250)
            {
                lbtthongbao.Text = "Đường dẫn dịch vụ không quá 250 ký tự. Hãy nhập lại!";
                txtDuongDan.Focus();
                return false;
            }
            return true;
        }
        private bool CheckIsExists(string Ma,decimal ID)
        {
            string StrMa = Ma.Trim().ToLower();
            GSTP_LINKSVR LinhSV = dt.GSTP_LINKSVR.Where(x => x.MA.ToLower() == StrMa).FirstOrDefault();
            if (LinhSV != null)
            {
                if (LinhSV.ID != ID)
                {
                    lbtthongbao.Text = "Mã dịch vụ đã tồn tại. Hãy nhập lại!";
                    return true;
                }
            }
            return false;
        }
    }
}