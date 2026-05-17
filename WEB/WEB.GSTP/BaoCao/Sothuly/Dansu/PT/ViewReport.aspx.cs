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

namespace WEB.GSTP.BaoCao.Sothuly.Dansu.PT
{
    public partial class ViewReport : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    LoadDonVi();
                    txtNgay_Tu.Text = "01/" + string.Format("{0:MM}", DateTime.Today) + "/" + DateTime.Today.Year;
                    txtNgay_Den.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now);
                }
            }
            catch (Exception ex) { lblmsg.Text = ex.Message; }
        }
        private void LoadDonVi()
        {
            decimal DonViLogin = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            if (CheckDonViChildren(DonViLogin))
            {
                chkAll.Visible = true;
            }
            else
            {
                chkAll.Visible = false; chkAll.Checked = false;
            }
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("donviID",DonViLogin),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_TOAAN_GETBY", prm);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                ddlDonVi.DataSource = tbl;
                ddlDonVi.DataTextField = "TenDonVi";
                ddlDonVi.DataValueField = "ID";
                ddlDonVi.DataBind();
            }
        }
        protected void ddlDonVi_SelectedIndexChanged(object sender, EventArgs e)
        {
            decimal DonVi = Convert.ToDecimal(ddlDonVi.SelectedValue);
            List<DM_TOAAN> lst = dt.DM_TOAAN.Where(x => x.CAPCHAID == DonVi).ToList();
            if (CheckDonViChildren(DonVi))
            {
                chkAll.Visible = true;
            }
            else
            {
                chkAll.Visible = false; chkAll.Checked = false;
            }
        }
        private bool CheckDonViChildren(Decimal DonViID)
        {
            bool Result = false;
            List<DM_TOAAN> lst = dt.DM_TOAAN.Where(x => x.CAPCHAID == DonViID).ToList();
            if (lst.Count > 0)
            {
                Result = true;
            }
            return Result;
        }
        protected void btnXemBC_Click(object sender, EventArgs e)
        {
            try
            {
                LoadReport();
            }
            catch (Exception ex) { lblmsg.Text = ex.Message; }
        }
        private void LoadReport()
        {
            lblmsg.Text = "";
            string TenToaAn = ddlDonVi.SelectedItem.Text, IsHaveToaAnCon = "FALSE", TuNgay = txtNgay_Tu.Text,
                DenNgay = txtNgay_Den.Text;
            decimal ToaAnID = Convert.ToDecimal(ddlDonVi.SelectedValue);
            if (CheckData() == false)
            {
                return;
            }
            if (chkAll.Checked)
            {
                IsHaveToaAnCon = "TRUE";
            }
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("in_TOAANID",ToaAnID),
                                                                        new OracleParameter("in_TOAANCAPCON",IsHaveToaAnCon),
                                                                        new OracleParameter("in_NGAYBATDAU",TuNgay),
                                                                        new OracleParameter("in_NGAYKETTHUC",DenNgay),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = new DataTable();
            try
            {
                string sql = "PKG_GSTP_SOTHULY_PHUCTHAM.SO_DANSU_PHUCTHAM";
                tbl = Cls_Comon.GetTableByProcedurePaging(sql, parameters);
            }
            catch { }
            rptSoTL_ADS_PT rpt = new rptSoTL_ADS_PT();
            rpt.Parameters["TenToaAn"].Value = TenToaAn.Replace(".", "");
            rpt.Parameters["TuNgay"].Value = txtNgay_Tu.Text;
            rpt.Parameters["DenNgay"].Value = txtNgay_Den.Text;
            rpt.DataSource = tbl;
            rptView.OpenReport(rpt);

            if (tbl.Rows.Count == 0)
            {
                lblmsg.Text = "Không có dữ liệu phù hợp. Hãy chọn lại!";
            }
        }
        private bool CheckData()
        {
            string TuNgay = txtNgay_Tu.Text, DenNgay = txtNgay_Den.Text;
            if (TuNgay == "")
            {
                lblmsg.Text = "Chưa nhập từ ngày. Hãy nhập lại!";
                Cls_Comon.SetFocus(this.txtNgay_Tu, this.GetType(), txtNgay_Tu.ClientID);
                return false;
            }
            if (TuNgay != "")
            {
                DateTime Day_TuNgay = DateTime.Now;
                if (DateTime.TryParse(TuNgay, new System.Globalization.CultureInfo("vi-VN"), System.Globalization.DateTimeStyles.NoCurrentDateDefault, out Day_TuNgay) == false)
                {
                    lblmsg.Text = "Chưa nhập từ ngày đúng theo định dạng (Ngày / Tháng / Năm). Hãy nhập lại!";
                    Cls_Comon.SetFocus(this.txtNgay_Tu, this.GetType(), txtNgay_Tu.ClientID);
                    return false;
                }
            }
            if (DenNgay == "")
            {
                lblmsg.Text = "Chưa nhập đến ngày. Hãy nhập lại!";
                Cls_Comon.SetFocus(this.txtNgay_Den, this.GetType(), txtNgay_Den.ClientID);
                return false;
            }
            if (DenNgay != "")
            {
                DateTime Day_DenNgay = DateTime.Now;
                if (DateTime.TryParse(DenNgay, new System.Globalization.CultureInfo("vi-VN"), System.Globalization.DateTimeStyles.NoCurrentDateDefault, out Day_DenNgay) == false)
                {
                    lblmsg.Text = "Chưa nhập đến ngày đúng theo định dạng (Ngày / Tháng / Năm). Hãy nhập lại!";
                    Cls_Comon.SetFocus(this.txtNgay_Den, this.GetType(), txtNgay_Den.ClientID);
                    return false;
                }
            }
            return true;
        }
    }
}