using Microsoft.Reporting.WebForms;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.UserControl.TP
{
    public partial class Inbaocao_Danhsach : System.Web.UI.Page
    {
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                DateTime TuNgay = DateTime.Parse("01/01/" + DateTime.Now.Year.ToString() + " 00:00:00", cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime DenNgay = DateTime.Parse("31/12/" + DateTime.Now.Year.ToString() + " 23:59:59", cul, DateTimeStyles.NoCurrentDateDefault);
                decimal ToaAnID = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                string CapXetXu = Session["HOME_CA_CAPXETXU"] + "",
                       LoaiAn = Session["HOME_CA_LOAIAN"] + "", ThongTinThongKe = Session["HOME_CA_NHOM_THONG_KE"] + "",
                       strCapXetXu = CapXetXu == "ST" ? "Sơ thẩm" : "Phúc thẩm",strLoaiAn="", strThongTinThongKe="",
                       path = "~/UserControl/TP/rptDanhSachAn.rdlc", report_name = "rptDanhSachAn.rdlc", DataSetName = "DataSet1";
                switch (LoaiAn)
                {
                    case "AHS":
                        strLoaiAn = "Hình sự";
                        break;
                    case "AHS_CHUA_THANH_NIEN":
                        strLoaiAn = "Án hình sự chưa thành niên";
                        break;
                    case "ADS":
                        strLoaiAn = "Dân sự";
                        break;
                    case "AKT":
                        strLoaiAn = "Kinh doanh, Thương mại";
                        break;
                    case "AHC":
                        strLoaiAn = "Hành chính";
                        break;
                    case "AHN":
                        strLoaiAn = "Hôn nhân và Gia đình";
                        break;
                    case "ALD":
                        strLoaiAn = "Lao động";
                        break;
                    case "APS":
                        strLoaiAn = "Phá sản";
                        break;
                    case "XLHC":
                        strLoaiAn = "Biện pháp XLHC";
                        break;
                    default:
                        strLoaiAn = "";
                        break;
                };
                switch (ThongTinThongKe)
                {
                    case "NHAPVUAN":
                        strThongTinThongKe = "Nhập vụ án";
                        break;
                    case "CHUYENVUAN":
                        strThongTinThongKe = "Chuyển vụ án";
                        break;
                    case "AN_TON":
                        strThongTinThongKe = "Án tồn chuyển sang";
                        break;
                    case "AN_CHO_THU_LY":
                        strThongTinThongKe = "Án chờ thụ lý";
                        break;
                    case "AN_THU_LY_CHUA_PC":
                        strThongTinThongKe = "Án đã thụ lý >> Chưa phân công TP";
                        break;
                    case "AN_THU_LY_DA_PC":
                        strThongTinThongKe = "Đã thụ lý >> Đã phân công TP";
                        break;
                    case "DA_LEN_LICH_XET_XU":
                        strThongTinThongKe = "Đã lên lịch xét xử";
                        break;
                    case "DA_GIAI_QUYET":
                        strThongTinThongKe = "Đã giải quyết";
                        break;
                    case "CON_LAI":
                        strThongTinThongKe = "Còn lại (Chưa GQ xong)";
                        break;
                    case "AN_TDC":
                        strThongTinThongKe = "Án tạm đình chỉ";
                        break;
                    case "AN_SUA_HUY":
                        strThongTinThongKe = "Án bị sửa/hủy";
                        break;
                    case "AN_QH_DANG_GQ":
                        strThongTinThongKe = "Án quá hạn đang giải quyết";
                        break;
                    case "AN_QH_DA_GQ":
                        strThongTinThongKe = "Án quá hạn đã giải quyết";
                        break;
                    default:
                        strThongTinThongKe = "";
                        break;
                };
                //OracleParameter[] prm = new OracleParameter[]
                //{
                //new OracleParameter("v_TOAANID",ToaAnID),
                //new OracleParameter("v_CAP_XET_XU",CapXetXu),
                //new OracleParameter("v_LOAIAN",LoaiAn),
                //new OracleParameter("V_NHOM_THONG_KE",ThongTinThongKe),
                //new OracleParameter("v_DATE_TUNGAY",TuNgay),
                //new OracleParameter("v_DATE_DENNGAY",DenNgay),
                //new OracleParameter("curReturn",OracleDbType.RefCursor,ParameterDirection.Output)
                //};
                DataTable tbl = (DataTable)Session["HOME_CA_LIST_VUAN"];
                if (tbl.Rows.Count > 0)
                {
                    List<ReportParameter> parms = null;
                    parms = new List<ReportParameter>
                    {
                        new ReportParameter("CapXetXu", strCapXetXu),
                        new ReportParameter("LoaiAn", strLoaiAn),
                        new ReportParameter("ThongTinTK", strThongTinThongKe)
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
                    ReportViewer1.LocalReport.DisplayName = "chanh_an_thong_ke_home_danh_sach";
                }
            }
            catch (Exception ex) { ltlmsg.InnerText = ex.Message; }
        }
    }
}