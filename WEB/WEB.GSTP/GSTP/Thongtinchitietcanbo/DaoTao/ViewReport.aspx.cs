using BL.GSTP.GSTP;
using DAL.GSTP;
using Microsoft.Reporting.WebForms;
using Module.Common;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.GSTP.Thongtinchitietcanbo.DaoTao
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
                    LoadReport();
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private void LoadReport()
        {
            decimal ThamPhanID = string.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_GSTP] + "") ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_GSTP]);
            string MaDongBo = "";
            DM_CANBO cbo = dt.DM_CANBO.Where(x => x.ID == ThamPhanID).FirstOrDefault<DM_CANBO>();
            if (cbo != null)
            {
                MaDongBo = cbo.MADONGBO;
            }
            if (MaDongBo != "")
            {
                string DataSetName = "DataSet1", reportName = "DaoTao.rdlc";
                DataTable tbl = GetData(MaDongBo);
                String path = "~/BaoCao/GSTP/" + reportName;
                if (tbl != null && tbl.Rows.Count > 0)
                {
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
            }
        }
        private DataTable GetData(string MaDongBo)
        {
            RootObject_CanBo_QTDaoTao rob = new RootObject_CanBo_QTDaoTao();
            DataTable tbl = CreateTable();
            rob = null;
            #region Đọc từ file JSON
            //using (StreamReader r = new StreamReader(Server.MapPath("~/GSTP/Thongtinchitietcanbo/DaoTao/data_JSON_Chuan_DaoTao.json")))
            //{
            //    string json = r.ReadToEnd();
            //    json = json.Replace("\"[", "[");
            //    json = json.Replace("]\"", "]");
            //    rob = JsonConvert.DeserializeObject<RootObject_CanBo_QTDaoTao>(json);
            //}
            #endregion
            #region Đọc từ server
            string url = "http://10.1.19.76/integrated.asmx/ws_daotaoboiduong";
            string inputData = "{\"id\":\"" + MaDongBo + "\"}";
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
            request.Method = "POST";
            request.ContentType = "application/json";
            request.ContentLength = inputData.Length;
            using (Stream webStream = request.GetRequestStream())
            using (StreamWriter requestWriter = new StreamWriter(webStream, System.Text.Encoding.ASCII))
            {
                requestWriter.Write(inputData);
            }
            WebResponse webResponse = request.GetResponse();
            using (Stream webStream = webResponse.GetResponseStream())
            {
                if (webStream != null)
                {
                    using (StreamReader responseReader = new StreamReader(webStream))
                    {
                        try
                        {
                            string response = responseReader.ReadToEnd();
                            response = response.Replace("\"[", "[");
                            response = response.Replace("]\"", "]");
                            response = response.Replace("\"{", "{");
                            response = response.Replace("\\", "");
                            response = response.Replace("}]}]}\"}", "}]}]}}");
                            rob = JsonConvert.DeserializeObject<RootObject_CanBo_QTDaoTao>(response);
                        }
                        catch (Exception ex) { lbthongbao.Text = ex.Message; }
                    }
                }
            }
            #endregion
            if (rob != null && rob.d != null)
            {
                foreach (CANBO_QTDAOTAO item in rob.d)
                {
                    DataRow row = tbl.NewRow();
                    row["TUTHANG"] = item.TUTHANG;
                    row["DENTHANG"] = item.DENTHANG;
                    row["TENTRUONG"] = item.TENTRUONG;
                    row["NGANHHOC"] = item.NGANHHOC;
                    row["TRINHDO"] = item.TRINHDO;
                    row["BANGCAP"] = item.BANGCAP;
                    row["XEPLOAI"] = item.XEPLOAI;
                    row["NAMTOTNGHIEP"] = item.NAMTOTNGHIEP;
                    row["NOIDUNGDAOTAO"] = item.NOIDUNGDAOTAO;
                    row["HINHTHUCDAOTAO"] = item.HINHTHUCDAOTAO;
                    row["CHUYENMON"] = item.CHUYENMON;
                    tbl.Rows.Add(row);
                }
            }
            return tbl;
        }
        private DataTable CreateTable()
        {
            DataTable tbl = new DataTable();
            tbl.Columns.Add("TUTHANG", typeof(string));
            tbl.Columns.Add("DENTHANG", typeof(string));
            tbl.Columns.Add("TENTRUONG", typeof(string));
            tbl.Columns.Add("NGANHHOC", typeof(string));
            tbl.Columns.Add("TRINHDO", typeof(string));
            tbl.Columns.Add("BANGCAP", typeof(string));
            tbl.Columns.Add("XEPLOAI", typeof(string));
            tbl.Columns.Add("NAMTOTNGHIEP", typeof(string));
            tbl.Columns.Add("NOIDUNGDAOTAO", typeof(string));
            tbl.Columns.Add("HINHTHUCDAOTAO", typeof(string));
            tbl.Columns.Add("CHUYENMON", typeof(string));
            return tbl;
        }
    }
}