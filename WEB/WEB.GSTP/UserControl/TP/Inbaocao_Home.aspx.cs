using BL.GSTP;
using Microsoft.Reporting.WebForms;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.UserControl.TP
{
    public partial class Inbaocao_Home : System.Web.UI.Page
    {
        DM_CANBO_BL bl = new DM_CANBO_BL();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                decimal UserID = Session[ENUM_SESSION.SESSION_USERID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                string TenChanhAn = "", path= "~/UserControl/TP/rptChanhAnHome.rdlc", report_name= "rptChanhAnHome.rdlc", DataSetName= "DataSet1";
                DataTable tbl_CA = bl.DM_CANBO_GETCA_PCA_BY_USERID(UserID);
                if (tbl_CA.Rows.Count > 0)
                {
                    TenChanhAn = (tbl_CA.Rows[0]["TenChucVu"].ToString() + " " + tbl_CA.Rows[0]["hoten"].ToString()).ToUpper();
                }
                DataTable tbl = Session["Data_ChanhAn_Home"] == null ? null : (DataTable)Session["Data_ChanhAn_Home"];
                if (tbl.Rows.Count > 0)
                {
                    string TuNgay = "01/01" + DateTime.Now.ToString("/yyyy"),
                           DenNgay = "31/12" + DateTime.Now.ToString("/yyyy");
                    List<ReportParameter> parms = null;
                    parms = new List<ReportParameter>
                    {
                        new ReportParameter("PrmTenChanhAn", TenChanhAn),
                        new ReportParameter("PrmTuNgay", TuNgay),
                        new ReportParameter("PrmDenNgay", DenNgay)
                    };
                    ReportViewer1.ProcessingMode = ProcessingMode.Local;
                    ReportViewer1.LocalReport.ReportPath = Server.MapPath(path);
                    ReportViewer1.LocalReport.ReportEmbeddedResource = "WEB.WEB.GSTP.UserControl.TP." + report_name.ToUpper();
                    if (parms != null)
                    {
                        ReportViewer1.LocalReport.SetParameters(parms);
                    }
                    ReportDataSource rds = new ReportDataSource(DataSetName, tbl);
                    ReportViewer1.LocalReport.DataSources.Clear();
                    ReportViewer1.LocalReport.DataSources.Add(rds);
                    ReportViewer1.Visible = true;
                    ReportViewer1.LocalReport.EnableExternalImages = true;
                    ReportViewer1.LocalReport.EnableHyperlinks = true;
                    ReportViewer1.ShowReportBody = true;
                    ReportViewer1.LocalReport.Refresh();
                    ReportViewer1.LocalReport.DisplayName = "chanh_an_thong_ke_home";
                }
            }
            catch (Exception ex) { ltlmsg.InnerText = ex.Message; }
        }
    }
}