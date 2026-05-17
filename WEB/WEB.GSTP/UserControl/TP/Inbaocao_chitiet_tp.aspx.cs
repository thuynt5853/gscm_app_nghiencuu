using DAL.GSTP;
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
    public partial class Inbaocao_chitiet_tp : System.Web.UI.Page
    {
        GSTPContext gsdt = new GSTPContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                
                decimal UserID = Session[ENUM_SESSION.SESSION_USERID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                string TenThamPhan = "", path = "~/UserControl/TP/rptThamPhan_ChiTiet_Home.rdlc", report_name = "rptThamPhan_ChiTiet_Home.rdlc", DataSetName = "DataSet1";
                if (Session["TrangChu_ChanhAn_TPID"] + "" != "")
                {
                    decimal ThamPanID = Convert.ToDecimal(Session["TrangChu_ChanhAn_TPID"]);
                    DM_CANBO cb = gsdt.DM_CANBO.Where(x => x.ID == ThamPanID).FirstOrDefault();
                    if (cb != null)
                    {
                        TenThamPhan = ("Thẩm phán " + cb.HOTEN).ToUpper();
                    }
                }
                DataTable tbl = Session["Data_CA_Home_ChiTiet_TP"] == null ? null : (DataTable)Session["Data_CA_Home_ChiTiet_TP"];
                if (tbl.Rows.Count > 0)
                {
                    List<ReportParameter> parms = null;
                    parms = new List<ReportParameter>
                    {
                        new ReportParameter("PrmTenThamPhan", TenThamPhan),
                        new ReportParameter("PrmTuNgay", "01/01/2020"),
                        new ReportParameter("PrmDenNgay", "31/12/2020")
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
                    ReportViewer1.LocalReport.DisplayName = "tham_phan_thong_ke_home";
                }
            }
            catch (Exception ex) { ltlmsg.InnerText = ex.Message; }
        }
    }
}