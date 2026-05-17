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

namespace WEB.GSTP.GSTP.Thongtinchitietcanbo.KhenThuongKyLuat
{
    public partial class Khenthuongkyluat : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    LoadReportKyLuat();
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private void LoadReportKyLuat()
        {
            try
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
                    string DataSetName = "DataSet1", reportName = "Kyluat.rdlc";
                    DataTable tbl = GetDataKyLuat(MaDongBo);
                    String path = "~/BaoCao/GSTP/" + reportName;
                    if (tbl != null && tbl.Rows.Count > 0)
                    {
                        rpvKyLuat.ProcessingMode = ProcessingMode.Local;
                        rpvKyLuat.LocalReport.ReportPath = Server.MapPath(path);
                        rpvKyLuat.LocalReport.ReportEmbeddedResource = "WEB.GSTP.BaoCao.GSTP." + reportName;
                        rpvKyLuat.LocalReport.DataSources.Clear();
                        rpvKyLuat.LocalReport.DataSources.Add(new ReportDataSource(DataSetName, tbl));
                        rpvKyLuat.Visible = true;
                        rpvKyLuat.LocalReport.EnableExternalImages = true;
                        rpvKyLuat.LocalReport.EnableHyperlinks = true;
                        rpvKyLuat.ShowReportBody = true;
                        rpvKyLuat.LocalReport.Refresh();
                        rpvKyLuat.LocalReport.DisplayName = "";
                    }
                    else
                    {
                        rpvKyLuat.Visible = false;
                    }
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private DataTable GetDataKyLuat(string MaDongBo)
        {
            RootOject_CanBo_KyLuat rob = new RootOject_CanBo_KyLuat();
            DataTable tbl = CreateTableKyLuat();
            #region Đọc từ file JSON
            //using (StreamReader r = new StreamReader(Server.MapPath("~/GSTP/Thongtinchitietcanbo/KhenThuongKyLuat/data_JSON_KyLuat.json")))
            //{
            //    string json = r.ReadToEnd();
            //    json = json.Replace("\"[", "[");
            //    json = json.Replace("]\"", "]");
            //    rob = JsonConvert.DeserializeObject<RootOject_CanBo_KyLuat>(json);
            //}
            #endregion
            #region Đọc từ server
            ///GSTP_LINKSVR link=dt.GSTP_LINKSVR.Where(x=>x.MA=)
            string url = "http://10.1.19.76/integrated.asmx/ws_kyluat";
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
                        rob = JsonConvert.DeserializeObject<RootOject_CanBo_KyLuat>(response);
                    }
                }
            }
            #endregion
            if (rob != null && rob.d != null)
            {
                foreach (CANBO_KYLUAT item in rob.d)
                {
                    DataRow row = tbl.NewRow();
                    row["Name"] = item.Name;
                    row["REASON"] = item.REASON;
                    row["NOTES"] = item.NOTES;
                    row["DECISION_NO"] = item.DECISION_NO;
                    row["DECISION_NAME"] = item.DECISION_NAME;
                    row["EFFECTDATE"] = item.EFFECTDATE;
                    row["EXPIREDATE"] = item.EXPIREDATE;
                    row["VIOLATION_DATE"] = item.VIOLATION_DATE;
                    row["FULLNAME"] = item.FULLNAME;
                    row["APPROVE_NAME"] = item.APPROVE_NAME;
                    row["POS_APPROVE"] = item.POS_APPROVE;
                    row["SIGNDATE"] = item.SIGNDATE;
                    tbl.Rows.Add(row);
                }
            }
            return tbl;
        }
        private DataTable CreateTableKyLuat()
        {
            DataTable tbl = new DataTable();
            tbl.Columns.Add("Name", typeof(string));
            tbl.Columns.Add("REASON", typeof(string));
            tbl.Columns.Add("NOTES", typeof(string));
            tbl.Columns.Add("DECISION_NO", typeof(string));
            tbl.Columns.Add("DECISION_NAME", typeof(string));
            tbl.Columns.Add("EFFECTDATE", typeof(string));
            tbl.Columns.Add("EXPIREDATE", typeof(string));
            tbl.Columns.Add("VIOLATION_DATE", typeof(string));
            tbl.Columns.Add("FULLNAME", typeof(string));
            tbl.Columns.Add("APPROVE_NAME", typeof(string));
            tbl.Columns.Add("POS_APPROVE", typeof(string));
            tbl.Columns.Add("SIGNDATE", typeof(string));
            return tbl;
        }
    }
}