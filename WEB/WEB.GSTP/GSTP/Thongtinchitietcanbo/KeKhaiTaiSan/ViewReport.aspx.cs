using BL.GSTP.GSTP;
using DAL.GSTP;
using Microsoft.Reporting.WebForms;
using Module.Common;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.GSTP.Thongtinchitietcanbo.KeKhaiTaiSan
{
    public partial class ViewReport : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
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
                string DataSetName = "DataSet1", reportName = "KeKhaiTaiSan.rdlc";
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
                else
                {
                    ReportViewer1.Visible = false;
                }
            }
        }
        private DataTable GetData(string MaDongBo)
        {
            RootObject_CanBo_KeKhaiTaiSan rob = new RootObject_CanBo_KeKhaiTaiSan();
            DataTable tbl = CreateTable();
            #region Đọc từ file JSON
            //using (StreamReader r = new StreamReader(Server.MapPath("~/GSTP/Thongtinchitietcanbo/KeKhaiTaiSan/data_JSON_Chuan_KeKhaiTaiSan.json")))
            //{
            //    string json = r.ReadToEnd();
            //    json = json.Replace("\"[", "[");
            //    json = json.Replace("]\"", "]");
            //    rob = JsonConvert.DeserializeObject<RootObject_CanBo_KeKhaiTaiSan>(json);
            //}
            #endregion
            #region Đọc từ server
            string url = "http://10.1.19.76/integrated.asmx/ws_kekhaitaisanthunhap";
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
                        string response = responseReader.ReadToEnd();
                        response = response.Replace("\"[", "[");
                        response = response.Replace("]\"", "]");
                        rob = JsonConvert.DeserializeObject<RootObject_CanBo_KeKhaiTaiSan>(response);
                    }
                }
            }
            #endregion
            if (rob != null && rob.d != null)
            {
                NumberFormatInfo provider = new NumberFormatInfo();
                provider.NumberDecimalSeparator = ",";
                provider.NumberGroupSeparator = ".";
                provider.NumberGroupSizes = new int[] { 3 };
                foreach (CANBO_KEKHAITAISAN item in rob.d)
                {
                    DataRow row = tbl.NewRow();
                    row["NHA_GIATRI"] = item.NHA_GIATRI + "" == "" ? "" : Convert.ToDouble(item.NHA_GIATRI).ToString("#,0.##", cul);
                    row["NHA_TANGGIAM"] = item.NHA_TANGGIAM + "" == "" ? "" : Convert.ToDouble(item.NHA_TANGGIAM).ToString("#,0.##", cul);
                    row["NHA_THONGTIN"] = item.NHA_THONGTIN;
                    row["QSDD_GIATRI"] = item.QSDD_GIATRI + "" == "" ? "" : Convert.ToDouble(item.QSDD_GIATRI).ToString("#,0.##", cul);
                    row["QSDD_TANGGIAM"] = item.QSDD_TANGGIAM + "" == "" ? "" : Convert.ToDouble(item.QSDD_TANGGIAM).ToString("#,0.##", cul);
                    row["QSDD_THONGTIN"] = item.QSDD_THONGTIN;
                    row["TSNG_GIATRI"] = item.TSNG_GIATRI + "" == "" ? "" : Convert.ToDouble(item.TSNG_GIATRI).ToString("#,0.##", cul); ;
                    row["TSND_TANGGIAM"] = item.TSND_TANGGIAM + "" == "" ? "" : Convert.ToDouble(item.TSND_TANGGIAM).ToString("#,0.##", cul);
                    row["TSNG_THONGTIN"] = item.TSNG_THONGTIN;
                    row["TKNN_GIATRI"] = item.TKNN_GIATRI + "" == "" ? "" : Convert.ToDouble(item.TKNN_GIATRI).ToString("#,0.##", cul);
                    row["TKNN_TANGGIAM"] = item.TKNN_TANGGIAM + "" == "" ? "" : Convert.ToDouble(item.TKNN_TANGGIAM).ToString("#,0.##", cul);
                    row["TKNN_THONGTIN"] = item.TKNN_THONGTIN;
                    row["BDTN_GIATRI"] = item.BDTN_GIATRI + "" == "" ? "" : Convert.ToDouble(item.BDTN_GIATRI).ToString("#,0.##", cul);
                    row["BDTN_THONGTIN"] = item.BDTN_THONGTIN;
                    row["BDX_GIATRI"] = item.BDX_GIATRI + "" == "" ? "" : Convert.ToDouble(item.BDX_GIATRI).ToString("#,0.##", cul);
                    row["BDX_TANGGIAM"] = item.BDX_TANGGIAM + "" == "" ? "" : Convert.ToDouble(item.BDX_TANGGIAM).ToString("#,0.##", cul);
                    row["BDX_THONGTIN"] = item.BDX_THONGTIN;
                    row["BDT_GIATRI"] = item.BDT_GIATRI + "" == "" ? "" : Convert.ToDouble(item.BDT_GIATRI).ToString("#,0.##", cul);
                    row["BDT_TANGGIAM"] = item.BDT_TANGGIAM + "" == "" ? "" : Convert.ToDouble(item.BDT_TANGGIAM).ToString("#,0.##", cul);
                    row["BDT_THONGTIN"] = item.BDT_THONGTIN;
                    row["BDTSK_GIATRI"] = item.BDTSK_GIATRI + "" == "" ? "" : Convert.ToDouble(item.BDTSK_GIATRI).ToString("#,0.##", cul);
                    row["BDTSK_TANGGIAM"] = item.BDTSK_TANGGIAM + "" == "" ? "" : Convert.ToDouble(item.BDTSK_TANGGIAM).ToString("#,0.##", cul);
                    row["BDTSK_THONGTIN"] = item.BDTSK_TANGGIAM;
                    tbl.Rows.Add(row);
                }
            }
            return tbl;
        }
        private DataTable CreateTable()
        {
            DataTable tbl = new DataTable();
            tbl.Columns.Add("NHA_GIATRI", typeof(string));
            tbl.Columns.Add("NHA_TANGGIAM", typeof(string));
            tbl.Columns.Add("NHA_THONGTIN", typeof(string));
            tbl.Columns.Add("QSDD_GIATRI", typeof(string));
            tbl.Columns.Add("QSDD_TANGGIAM", typeof(string));
            tbl.Columns.Add("QSDD_THONGTIN", typeof(string));
            tbl.Columns.Add("TSNG_GIATRI", typeof(string));
            tbl.Columns.Add("TSND_TANGGIAM", typeof(string));
            tbl.Columns.Add("TSNG_THONGTIN", typeof(string));
            tbl.Columns.Add("TKNN_GIATRI", typeof(string));
            tbl.Columns.Add("TKNN_TANGGIAM", typeof(string));
            tbl.Columns.Add("TKNN_THONGTIN", typeof(string));
            tbl.Columns.Add("BDTN_GIATRI", typeof(string));
            tbl.Columns.Add("BDTN_THONGTIN", typeof(string));
            tbl.Columns.Add("BDX_GIATRI", typeof(string));
            tbl.Columns.Add("BDX_TANGGIAM", typeof(string));
            tbl.Columns.Add("BDX_THONGTIN", typeof(string));
            tbl.Columns.Add("BDT_GIATRI", typeof(string));
            tbl.Columns.Add("BDT_TANGGIAM", typeof(string));
            tbl.Columns.Add("BDT_THONGTIN", typeof(string));
            tbl.Columns.Add("BDTSK_GIATRI", typeof(string));
            tbl.Columns.Add("BDTSK_TANGGIAM", typeof(string));
            tbl.Columns.Add("BDTSK_THONGTIN", typeof(string));
            return tbl;
        }
    }
}