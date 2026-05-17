using BL.GSTP;
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

namespace WEB.GSTP.BaoCao.PCTP
{
    public partial class ViewReport : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadReport();
            }
        }
        private void LoadReport()
        {
            try
            {
                decimal vID = 0;
                if (Request["cid"] != null)
                    vID = Convert.ToInt32(Request["cid"]);
                PCTP_KETQUA oKQ = dt.PCTP_KETQUA.Where(x => x.ID == vID).FirstOrDefault();
                PCTP_BL oBL = new PCTP_BL();
                DataTable tbl = null;
                string DataSetName = "DataSet1";
                string reportName = "";
                decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    reportName = "rptLichSuPCTP.rdlc";
                tbl = oBL.PCTP_TPGQD_DAPHANCONG(ToaAnID, vID);
                
                String path = "~/BaoCao/PCTP/" + reportName;
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    string strNguoiphancong = "";
                    string strNguoithuchien = "";
                    if (oKQ.NGUOITHUCHIENID !=null)
                    {
                        QT_NGUOISUDUNG oCBTH = dt.QT_NGUOISUDUNG.Where(x => x.ID == oKQ.NGUOITHUCHIENID).FirstOrDefault();
                        strNguoithuchien = oCBTH.HOTEN;
                    }
                    if (oKQ.NGUOIKY != null)
                    {
                        DM_CANBO oCBNK = dt.DM_CANBO.Where(x => x.ID == oKQ.NGUOIKY).FirstOrDefault();
                        strNguoiphancong = oCBNK.HOTEN;
                    }
                    List<ReportParameter> parms = new List<ReportParameter>();
                    parms.Add(new ReportParameter("Ngayphancong", Convert.ToDateTime(oKQ.NGAYPHANCONG).ToString("dd/MM/yyyy HH:mm")));
                    parms.Add(new ReportParameter("Nguoithuchien", strNguoithuchien));
                    parms.Add(new ReportParameter("Nguoiphancong", strNguoiphancong));
                    parms.Add(new ReportParameter("TuNgay", Convert.ToDateTime(oKQ.TUNGAY).ToString("dd/MM/yyyy")));
                    parms.Add(new ReportParameter("DenNgay", Convert.ToDateTime(oKQ.DENNGAY).ToString("dd/MM/yyyy")));
                  
                    ReportViewer1.ProcessingMode = ProcessingMode.Local;
                    ReportViewer1.LocalReport.ReportPath = Server.MapPath(path);
                    ReportViewer1.LocalReport.ReportEmbeddedResource = "WEB.GSTP.BaoCao.PCTP." + reportName;
                    if (parms != null)
                    {
                        ReportViewer1.LocalReport.SetParameters(parms);
                    }
                    ReportViewer1.LocalReport.DataSources.Clear();
                    ReportViewer1.LocalReport.DataSources.Add(new ReportDataSource(DataSetName, tbl));
                    ReportViewer1.Visible = true;
                    ReportViewer1.LocalReport.EnableExternalImages = true;
                    ReportViewer1.LocalReport.EnableHyperlinks = true;
                    ReportViewer1.ShowReportBody = true;
                    ReportViewer1.LocalReport.Refresh();
                    ReportViewer1.LocalReport.DisplayName = "PhanCong_TP_GQD";
                }
                else
                {
                    //lttMsg.Text = "Không tìm thấy dữ liệu theo điều kiện đã chọn.";
                    ReportViewer1.Visible = false;
                }
            }
            catch (Exception ex)
            {
                ReportViewer1.Visible = false;
            }
        }
    }
}