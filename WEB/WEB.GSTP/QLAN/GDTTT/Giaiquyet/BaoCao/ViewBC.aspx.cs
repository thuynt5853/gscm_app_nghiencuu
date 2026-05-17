using DAL.GSTP;
using Module.Common;
using System;
using System.Data;
using System.Globalization;
using System.Linq;

using BL.GSTP.GDTTT;

namespace WEB.GSTP.QLAN.GDTTT.Giaiquyet.BaoCao
{
    public partial class ViewBC : System.Web.UI.Page
    {
        CultureInfo cul = new CultureInfo("vi-VN");
        GSTPContext dt = new GSTPContext();
        Decimal CurrentUserID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrentUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrentUserID == 0)
                Response.Redirect("/Login.aspx");
            else
            {
                LoadReport();
            }
        }
        String SetThoiGian()
        {
            DateTime vNgayThulyTu = DateTime.MinValue;
            DateTime vNgayThulyDen = DateTime.MinValue;
            string DenNgay = "", TuNgay = "";
            String ThoiGian = "", temp = "";
            String KyTuXuongDong = "; ";
            //-------------------------
            #region nhận đơn tu ngay- den ngay
            if (!String.IsNullOrEmpty(Session[SS_TK.NGAYNHANTU] + ""))
            {
                vNgayThulyTu = DateTime.Parse(Session[SS_TK.NGAYNHANTU] + "", cul, DateTimeStyles.NoCurrentDateDefault);
                TuNgay = vNgayThulyTu.ToString("dd/MM/yyyy", cul);
            }
            if (!String.IsNullOrEmpty(Session[SS_TK.NGAYNHANDEN] + ""))
            {
                vNgayThulyDen = DateTime.Parse(Session[SS_TK.NGAYNHANDEN] + "", cul, DateTimeStyles.NoCurrentDateDefault);
                DenNgay = vNgayThulyDen.ToString("dd/MM/yyyy", cul);
            }
            else DenNgay = DateTime.Now.ToString("dd/MM/yyyy", cul);

            if (!String.IsNullOrEmpty(TuNgay))
                temp = "Nhận đơn tính từ ngày " + TuNgay;
            if (!String.IsNullOrEmpty(DenNgay))
            {
                if (!String.IsNullOrEmpty(temp))
                    temp += " đến ngày " + DenNgay;
                else
                    temp = "Nhận đơn tính đến ngày " + DenNgay;
            }
            #endregion
            if (!String.IsNullOrEmpty(temp))
                ThoiGian = temp;

            //--------------------------------
            temp = "";
            #region ngay chuyen don tu ngay- den ngay
            if (!String.IsNullOrEmpty(Session[SS_TK.NGAYCHUYENTU] + ""))
            {
                vNgayThulyTu = DateTime.Parse(Session[SS_TK.NGAYCHUYENTU] + "", cul, DateTimeStyles.NoCurrentDateDefault);
                TuNgay = vNgayThulyTu.ToString("dd/MM/yyyy", cul);
            }
            if (!String.IsNullOrEmpty(Session[SS_TK.NGAYCHUYENDEN] + ""))
            {
                vNgayThulyDen = DateTime.Parse(Session[SS_TK.NGAYCHUYENDEN] + "", cul, DateTimeStyles.NoCurrentDateDefault);
                DenNgay = vNgayThulyDen.ToString("dd/MM/yyyy", cul);
            }
            else DenNgay = DateTime.Now.ToString("dd/MM/yyyy", cul);

            if (!String.IsNullOrEmpty(TuNgay))
                temp = "Ngày chuyển đơn tính từ ngày " + TuNgay;
            if (!String.IsNullOrEmpty(DenNgay))
            {
                if (!String.IsNullOrEmpty(temp))
                    temp += " đến ngày " + DenNgay;
                else
                    temp = "Ngày chuyển đơn tính đến ngày " + DenNgay;
            }
            #endregion

            if ((!String.IsNullOrEmpty(temp)) && (!String.IsNullOrEmpty(ThoiGian)))
                ThoiGian += KyTuXuongDong + temp;
            else
                ThoiGian = temp;

            //----------------------------
            temp = "";
            #region Thu ly tu ngay- den ngay
            if (!String.IsNullOrEmpty(Session[SS_TK.THULY_TU] + ""))
            {
                vNgayThulyTu = DateTime.Parse(Session[SS_TK.THULY_TU] + "", cul, DateTimeStyles.NoCurrentDateDefault);
                TuNgay = vNgayThulyTu.ToString("dd/MM/yyyy", cul);
            }
            if (!String.IsNullOrEmpty(Session[SS_TK.THULY_DEN] + ""))
            {
                vNgayThulyDen = DateTime.Parse(Session[SS_TK.THULY_DEN] + "", cul, DateTimeStyles.NoCurrentDateDefault);
                DenNgay = vNgayThulyDen.ToString("dd/MM/yyyy", cul);
            }
            else DenNgay = DateTime.Now.ToString("dd/MM/yyyy", cul);

            if (!String.IsNullOrEmpty(TuNgay))
                temp = "Thụ lý tính từ ngày " + TuNgay;
            if (!String.IsNullOrEmpty(DenNgay))
            {
                if (!String.IsNullOrEmpty(temp))
                    temp += " đến ngày " + DenNgay;
                else
                    temp = "Thụ lý tính đến ngày " + DenNgay;
            }
            #endregion

            if ((!String.IsNullOrEmpty(temp)) && (!String.IsNullOrEmpty(ThoiGian)))
                ThoiGian += KyTuXuongDong + temp;
            else
                ThoiGian = temp;

            //----------------------------
            if (!String.IsNullOrEmpty(ThoiGian))
                ThoiGian = "(" + ThoiGian + ")";
            return ThoiGian;
        }
        private void LoadReport()
        {
            String ThoiGian = SetThoiGian();
            string report_name = Session[SS_TK.TENBAOCAO] + "";

            //-------------------------------- 
            int type = string.IsNullOrEmpty(Request["type"] + "") ? 1 : Convert.ToInt16(Request["type"] + "");
            String SessionName = "";
            DataTable tblData = null;
            if (type == 2)
                SessionName = "GDTTT_DonTrung_ReportPL".ToUpper();
            else
                SessionName = "GDTTT_Don_ReportPL".ToUpper();
            tblData = (DataTable)Session[SessionName];

            //--------------------------------
            if (type == 1)
            {
                PL1 rpt = new PL1();
                rpt.Parameters["TieuDeBC"].Value = report_name.ToUpper();
                rpt.Parameters["ThoiGian"].Value = ThoiGian;
                rpt.Parameters["TongSo"].Value = tblData.Rows.Count;
                rpt.DataSource = tblData;
                reportcontrol.OpenReport(rpt);
            }
            else
            {
                PL2 rpt = new PL2();
                rpt.Parameters["TieuDeBC"].Value = report_name.ToUpper();
                rpt.Parameters["ThoiGian"].Value = ThoiGian;
                rpt.Parameters["TongSo"].Value = tblData.Rows.Count;
                rpt.DataSource = tblData;
                reportcontrol.OpenReport(rpt);
            }
        }
    }
}