using DAL.GSTP;
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
    public partial class ChiTietTP : System.Web.UI.Page
    {
        GSTPContext gsdt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    LtrTenThamPhan.Text = "Thẩm phán ";
                    txtTuNgay.Text = "01/01" + DateTime.Now.ToString("/yyyy");
                    txtDenNgay.Text = "31/12" + DateTime.Now.ToString("/yyyy");
                    if (Session["TrangChu_ChanhAn_TPID"] + "" != "")
                    {
                        decimal ThamPanID = Convert.ToDecimal(Session["TrangChu_ChanhAn_TPID"]);
                        DM_CANBO cb = gsdt.DM_CANBO.Where(x => x.ID == ThamPanID).FirstOrDefault();
                        if (cb != null)
                        {
                            LtrTenThamPhan.Text = "Thẩm phán " + cb.HOTEN;
                        }
                    }
                    LoadData();
                }
            }
            catch (Exception ex) { LtrThongBao.Text = ex.Message; }
        }
        private void LoadData()
        {
            DateTime TuNgay = DateTime.Parse(txtTuNgay.Text + " 00:00:00", cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime DenNgay = DateTime.Parse(txtDenNgay.Text + " 23:59:59", cul, DateTimeStyles.NoCurrentDateDefault);
            if (Session["TrangChu_ChanhAn_TuNgay"] + "" != "")
            {
                TuNgay = (DateTime)Session["TrangChu_ChanhAn_TuNgay"];
            }
            if (Session["TrangChu_ChanhAn_DenNgay"] + "" != "")
            {
                DenNgay = (DateTime)Session["TrangChu_ChanhAn_DenNgay"];
            }
            decimal ToaAnID = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            decimal ThamPhanID = Session["TrangChu_ChanhAn_TPID"] + "" == "" ? 0 : Convert.ToDecimal(Session["TrangChu_ChanhAn_TPID"]);
            OracleParameter[] parameters = new OracleParameter[]
                    {
                        new OracleParameter("vToaAnID",ToaAnID),
                        new OracleParameter("vThamPhanID",ThamPhanID),
                        new OracleParameter("vTungay",TuNgay),
                        new OracleParameter("vDenngay",DenNgay),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_QLA_TH.QLA_CA_TRANG_CHU_TP_CHITIET", parameters);
            if (tbl.Rows.Count > 0)
            {
                decimal Sum_NHAPVUAN = 0, Sum_CHUYENVUAN = 0, Sum_AN_DUOC_PC = 0, Sum_AN_DA_GQ = 0, Sum_DA_LEN_LICH_XET_XU = 0, Sum_DANG_HOAN = 0,
                        Sum_CON_LAI = 0, Sum_AN_TDC = 0, Sum_AN_HUY = 0, Sum_AN_SUA = 0, Sum_AN_QH_DANG_GQ = 0, Sum_AN_QH_DA_GQ = 0;
                string StrRowTotal = "", StrRowIndex = "";
                #region Load sơ thẩm
                // Load sơ thẩm án hình sự
                #region row chẵn
                DataRow[] rows = tbl.Select("v_CAP_XET_XU = 'ST' and v_LOAIAN = 'AHS'");
                DataRow row = rows[0];
                Sum_NHAPVUAN += Convert.ToDecimal(row["v_NHAPVUAN"]);
                Sum_CHUYENVUAN += Convert.ToDecimal(row["v_CHUYENVUAN"]);
                Sum_AN_DUOC_PC += Convert.ToDecimal(row["v_AN_DUOC_PC"]);
                Sum_AN_DA_GQ += Convert.ToDecimal(row["v_AN_DA_GQ"]);
                Sum_CON_LAI += Convert.ToDecimal(row["v_CON_LAI"]);
                Sum_DA_LEN_LICH_XET_XU += Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]);
                Sum_DANG_HOAN += Convert.ToDecimal(row["v_DANG_HOAN"]);
                Sum_AN_TDC += Convert.ToDecimal(row["v_AN_TDC"]);
                Sum_AN_HUY += Convert.ToDecimal(row["v_AN_HUY"]);
                Sum_AN_SUA += Convert.ToDecimal(row["v_AN_SUA"]);
                Sum_AN_QH_DANG_GQ += Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]);
                Sum_AN_QH_DA_GQ += Convert.ToDecimal(row["v_AN_QH_DA_GQ"]);
                StrRowIndex = "<tr class='chan'>";
                StrRowIndex += "<td rowspan='9' style='text-align: center;'>Sơ thẩm</td>";
                StrRowIndex += "<td>Hình sự</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_NHAPVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_CHUYENVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_DUOC_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_CON_LAI"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_DANG_HOAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_TDC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_HUY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_SUA"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_QH_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "</tr>";
                #endregion
                // Load sơ thẩm Án hình sự chưa thành niên
                #region row lẻ
                rows = tbl.Select("v_CAP_XET_XU = 'ST' and v_LOAIAN = 'AHS_CHUA_THANH_NIEN'");
                row = rows[0];
                Sum_NHAPVUAN += Convert.ToDecimal(row["v_NHAPVUAN"]);
                Sum_CHUYENVUAN += Convert.ToDecimal(row["v_CHUYENVUAN"]);
                Sum_AN_DUOC_PC += Convert.ToDecimal(row["v_AN_DUOC_PC"]);
                Sum_AN_DA_GQ += Convert.ToDecimal(row["v_AN_DA_GQ"]);
                Sum_CON_LAI += Convert.ToDecimal(row["v_CON_LAI"]);
                Sum_DA_LEN_LICH_XET_XU += Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]);
                Sum_DANG_HOAN += Convert.ToDecimal(row["v_DANG_HOAN"]);
                Sum_AN_TDC += Convert.ToDecimal(row["v_AN_TDC"]);
                Sum_AN_HUY += Convert.ToDecimal(row["v_AN_HUY"]);
                Sum_AN_SUA += Convert.ToDecimal(row["v_AN_SUA"]);
                Sum_AN_QH_DANG_GQ += Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]);
                Sum_AN_QH_DA_GQ += Convert.ToDecimal(row["v_AN_QH_DA_GQ"]);
                StrRowIndex += "<tr class='le'>";
                StrRowIndex += "<td>Án hình sự chưa thành niên</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_NHAPVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_CHUYENVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_DUOC_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_CON_LAI"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_DANG_HOAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_TDC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_HUY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_SUA"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_QH_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "</tr>";
                #endregion
                // Load sơ thẩm Dân sự
                #region row chẵn
                rows = tbl.Select("v_CAP_XET_XU = 'ST' and v_LOAIAN = 'ADS'");
                row = rows[0];
                Sum_NHAPVUAN += Convert.ToDecimal(row["v_NHAPVUAN"]);
                Sum_CHUYENVUAN += Convert.ToDecimal(row["v_CHUYENVUAN"]);
                Sum_AN_DUOC_PC += Convert.ToDecimal(row["v_AN_DUOC_PC"]);
                Sum_AN_DA_GQ += Convert.ToDecimal(row["v_AN_DA_GQ"]);
                Sum_CON_LAI += Convert.ToDecimal(row["v_CON_LAI"]);
                Sum_DA_LEN_LICH_XET_XU += Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]);
                Sum_DANG_HOAN += Convert.ToDecimal(row["v_DANG_HOAN"]);
                Sum_AN_TDC += Convert.ToDecimal(row["v_AN_TDC"]);
                Sum_AN_HUY += Convert.ToDecimal(row["v_AN_HUY"]);
                Sum_AN_SUA += Convert.ToDecimal(row["v_AN_SUA"]);
                Sum_AN_QH_DANG_GQ += Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]);
                Sum_AN_QH_DA_GQ += Convert.ToDecimal(row["v_AN_QH_DA_GQ"]);
                StrRowIndex += "<tr class='chan'>";
                StrRowIndex += "<td>Dân sự</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_NHAPVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_CHUYENVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_DUOC_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_CON_LAI"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_DANG_HOAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_TDC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_HUY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_SUA"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_QH_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "</tr>";
                #endregion
                // Load sơ thẩm KDTM
                #region row lẻ
                rows = tbl.Select("v_CAP_XET_XU = 'ST' and v_LOAIAN = 'AKT'");
                row = rows[0];
                Sum_NHAPVUAN += Convert.ToDecimal(row["v_NHAPVUAN"]);
                Sum_CHUYENVUAN += Convert.ToDecimal(row["v_CHUYENVUAN"]);
                Sum_AN_DUOC_PC += Convert.ToDecimal(row["v_AN_DUOC_PC"]);
                Sum_AN_DA_GQ += Convert.ToDecimal(row["v_AN_DA_GQ"]);
                Sum_CON_LAI += Convert.ToDecimal(row["v_CON_LAI"]);
                Sum_DA_LEN_LICH_XET_XU += Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]);
                Sum_DANG_HOAN += Convert.ToDecimal(row["v_DANG_HOAN"]);
                Sum_AN_TDC += Convert.ToDecimal(row["v_AN_TDC"]);
                Sum_AN_HUY += Convert.ToDecimal(row["v_AN_HUY"]);
                Sum_AN_SUA += Convert.ToDecimal(row["v_AN_SUA"]);
                Sum_AN_QH_DANG_GQ += Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]);
                Sum_AN_QH_DA_GQ += Convert.ToDecimal(row["v_AN_QH_DA_GQ"]);
                StrRowIndex += "<tr class='le'>";
                StrRowIndex += "<td>KDTM</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_NHAPVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_CHUYENVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_DUOC_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_CON_LAI"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_DANG_HOAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_TDC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_HUY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_SUA"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_QH_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "</tr>";
                #endregion
                // Load sơ thẩm Hành chính
                #region row chẵn
                rows = tbl.Select("v_CAP_XET_XU = 'ST' and v_LOAIAN = 'AHC'");
                row = rows[0];
                Sum_NHAPVUAN += Convert.ToDecimal(row["v_NHAPVUAN"]);
                Sum_CHUYENVUAN += Convert.ToDecimal(row["v_CHUYENVUAN"]);
                Sum_AN_DUOC_PC += Convert.ToDecimal(row["v_AN_DUOC_PC"]);
                Sum_AN_DA_GQ += Convert.ToDecimal(row["v_AN_DA_GQ"]);
                Sum_CON_LAI += Convert.ToDecimal(row["v_CON_LAI"]);
                Sum_DA_LEN_LICH_XET_XU += Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]);
                Sum_DANG_HOAN += Convert.ToDecimal(row["v_DANG_HOAN"]);
                Sum_AN_TDC += Convert.ToDecimal(row["v_AN_TDC"]);
                Sum_AN_HUY += Convert.ToDecimal(row["v_AN_HUY"]);
                Sum_AN_SUA += Convert.ToDecimal(row["v_AN_SUA"]);
                Sum_AN_QH_DANG_GQ += Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]);
                Sum_AN_QH_DA_GQ += Convert.ToDecimal(row["v_AN_QH_DA_GQ"]);
                StrRowIndex += "<tr class='chan'>";
                StrRowIndex += "<td>Hành chính</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_NHAPVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_CHUYENVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_DUOC_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_CON_LAI"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_DANG_HOAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_TDC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_HUY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_SUA"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_QH_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "</tr>";
                #endregion
                // Load sơ thẩm HNGĐ
                #region row lẻ
                rows = tbl.Select("v_CAP_XET_XU = 'ST' and v_LOAIAN = 'AHN'");
                row = rows[0];
                Sum_NHAPVUAN += Convert.ToDecimal(row["v_NHAPVUAN"]);
                Sum_CHUYENVUAN += Convert.ToDecimal(row["v_CHUYENVUAN"]);
                Sum_AN_DUOC_PC += Convert.ToDecimal(row["v_AN_DUOC_PC"]);
                Sum_AN_DA_GQ += Convert.ToDecimal(row["v_AN_DA_GQ"]);
                Sum_CON_LAI += Convert.ToDecimal(row["v_CON_LAI"]);
                Sum_DA_LEN_LICH_XET_XU += Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]);
                Sum_DANG_HOAN += Convert.ToDecimal(row["v_DANG_HOAN"]);
                Sum_AN_TDC += Convert.ToDecimal(row["v_AN_TDC"]);
                Sum_AN_HUY += Convert.ToDecimal(row["v_AN_HUY"]);
                Sum_AN_SUA += Convert.ToDecimal(row["v_AN_SUA"]);
                Sum_AN_QH_DANG_GQ += Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]);
                Sum_AN_QH_DA_GQ += Convert.ToDecimal(row["v_AN_QH_DA_GQ"]);
                StrRowIndex += "<tr class='le'>";
                StrRowIndex += "<td>HNGĐ</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_NHAPVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_CHUYENVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_DUOC_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_CON_LAI"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_DANG_HOAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_TDC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_HUY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_SUA"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_QH_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "</tr>";
                #endregion
                // Load sơ thẩm Lao động
                #region row chẵn
                rows = tbl.Select("v_CAP_XET_XU = 'ST' and v_LOAIAN = 'ALD'");
                row = rows[0];
                Sum_NHAPVUAN += Convert.ToDecimal(row["v_NHAPVUAN"]);
                Sum_CHUYENVUAN += Convert.ToDecimal(row["v_CHUYENVUAN"]);
                Sum_AN_DUOC_PC += Convert.ToDecimal(row["v_AN_DUOC_PC"]);
                Sum_AN_DA_GQ += Convert.ToDecimal(row["v_AN_DA_GQ"]);
                Sum_CON_LAI += Convert.ToDecimal(row["v_CON_LAI"]);
                Sum_DA_LEN_LICH_XET_XU += Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]);
                Sum_DANG_HOAN += Convert.ToDecimal(row["v_DANG_HOAN"]);
                Sum_AN_TDC += Convert.ToDecimal(row["v_AN_TDC"]);
                Sum_AN_HUY += Convert.ToDecimal(row["v_AN_HUY"]);
                Sum_AN_SUA += Convert.ToDecimal(row["v_AN_SUA"]);
                Sum_AN_QH_DANG_GQ += Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]);
                Sum_AN_QH_DA_GQ += Convert.ToDecimal(row["v_AN_QH_DA_GQ"]);
                StrRowIndex += "<tr class='chan'>";
                StrRowIndex += "<td>Lao động</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_NHAPVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_CHUYENVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_DUOC_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_CON_LAI"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_DANG_HOAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_TDC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_HUY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_SUA"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_QH_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "</tr>";
                #endregion
                // Load sơ thẩm Phá sản
                #region row lẻ
                rows = tbl.Select("v_CAP_XET_XU = 'ST' and v_LOAIAN = 'APS'");
                row = rows[0];
                Sum_NHAPVUAN += Convert.ToDecimal(row["v_NHAPVUAN"]);
                Sum_CHUYENVUAN += Convert.ToDecimal(row["v_CHUYENVUAN"]);
                Sum_AN_DUOC_PC += Convert.ToDecimal(row["v_AN_DUOC_PC"]);
                Sum_AN_DA_GQ += Convert.ToDecimal(row["v_AN_DA_GQ"]);
                Sum_CON_LAI += Convert.ToDecimal(row["v_CON_LAI"]);
                Sum_DA_LEN_LICH_XET_XU += Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]);
                Sum_DANG_HOAN += Convert.ToDecimal(row["v_DANG_HOAN"]);
                Sum_AN_TDC += Convert.ToDecimal(row["v_AN_TDC"]);
                Sum_AN_HUY += Convert.ToDecimal(row["v_AN_HUY"]);
                Sum_AN_SUA += Convert.ToDecimal(row["v_AN_SUA"]);
                Sum_AN_QH_DANG_GQ += Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]);
                Sum_AN_QH_DA_GQ += Convert.ToDecimal(row["v_AN_QH_DA_GQ"]);
                StrRowIndex += "<tr class='le'>";
                StrRowIndex += "<td>Phá sản</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_NHAPVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_CHUYENVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_DUOC_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_CON_LAI"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_DANG_HOAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_TDC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_HUY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_SUA"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_QH_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "</tr>";
                #endregion
                // Load sơ thẩm BPXLHC
                #region row chẵn
                rows = tbl.Select("v_CAP_XET_XU = 'ST' and v_LOAIAN = 'XLHC'");
                row = rows[0];
                Sum_NHAPVUAN += Convert.ToDecimal(row["v_NHAPVUAN"]);
                Sum_CHUYENVUAN += Convert.ToDecimal(row["v_CHUYENVUAN"]);
                Sum_AN_DUOC_PC += Convert.ToDecimal(row["v_AN_DUOC_PC"]);
                Sum_AN_DA_GQ += Convert.ToDecimal(row["v_AN_DA_GQ"]);
                Sum_CON_LAI += Convert.ToDecimal(row["v_CON_LAI"]);
                Sum_DA_LEN_LICH_XET_XU += Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]);
                Sum_DANG_HOAN += Convert.ToDecimal(row["v_DANG_HOAN"]);
                Sum_AN_TDC += Convert.ToDecimal(row["v_AN_TDC"]);
                Sum_AN_HUY += Convert.ToDecimal(row["v_AN_HUY"]);
                Sum_AN_SUA += Convert.ToDecimal(row["v_AN_SUA"]);
                Sum_AN_QH_DANG_GQ += Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]);
                Sum_AN_QH_DA_GQ += Convert.ToDecimal(row["v_AN_QH_DA_GQ"]);
                StrRowIndex += "<tr class='chan'>";
                StrRowIndex += "<td>BPXLHC</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_NHAPVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_CHUYENVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_DUOC_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_CON_LAI"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_DANG_HOAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_TDC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_HUY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_SUA"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_QH_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "</tr>";
                #endregion
                #endregion
                #region Load phúc thẩm
                // Load phúc thẩm án hình sự
                #region row lẻ
                rows = tbl.Select("v_CAP_XET_XU = 'PT' and v_LOAIAN = 'AHS'");
                row = rows[0];
                Sum_NHAPVUAN += Convert.ToDecimal(row["v_NHAPVUAN"]);
                Sum_CHUYENVUAN += Convert.ToDecimal(row["v_CHUYENVUAN"]);
                Sum_AN_DUOC_PC += Convert.ToDecimal(row["v_AN_DUOC_PC"]);
                Sum_AN_DA_GQ += Convert.ToDecimal(row["v_AN_DA_GQ"]);
                Sum_CON_LAI += Convert.ToDecimal(row["v_CON_LAI"]);
                Sum_DA_LEN_LICH_XET_XU += Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]);
                Sum_DANG_HOAN += Convert.ToDecimal(row["v_DANG_HOAN"]);
                Sum_AN_TDC += Convert.ToDecimal(row["v_AN_TDC"]);
                Sum_AN_HUY += Convert.ToDecimal(row["v_AN_HUY"]);
                Sum_AN_SUA += Convert.ToDecimal(row["v_AN_SUA"]);
                Sum_AN_QH_DANG_GQ += Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]);
                Sum_AN_QH_DA_GQ += Convert.ToDecimal(row["v_AN_QH_DA_GQ"]);
                StrRowIndex += "<tr class='le'>";
                StrRowIndex += "<td rowspan='9' style='text-align: center;'>Phúc thẩm</td>";
                StrRowIndex += "<td>Hình sự</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_NHAPVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_CHUYENVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_DUOC_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_CON_LAI"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_DANG_HOAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_TDC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_HUY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_SUA"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_QH_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "</tr>";
                #endregion
                // Load phúc thẩm Án hình sự chưa thành niên
                #region row chẵn
                rows = tbl.Select("v_CAP_XET_XU = 'PT' and v_LOAIAN = 'AHS_CHUA_THANH_NIEN'");
                row = rows[0];
                Sum_NHAPVUAN += Convert.ToDecimal(row["v_NHAPVUAN"]);
                Sum_CHUYENVUAN += Convert.ToDecimal(row["v_CHUYENVUAN"]);
                Sum_AN_DUOC_PC += Convert.ToDecimal(row["v_AN_DUOC_PC"]);
                Sum_AN_DA_GQ += Convert.ToDecimal(row["v_AN_DA_GQ"]);
                Sum_CON_LAI += Convert.ToDecimal(row["v_CON_LAI"]);
                Sum_DA_LEN_LICH_XET_XU += Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]);
                Sum_DANG_HOAN += Convert.ToDecimal(row["v_DANG_HOAN"]);
                Sum_AN_TDC += Convert.ToDecimal(row["v_AN_TDC"]);
                Sum_AN_HUY += Convert.ToDecimal(row["v_AN_HUY"]);
                Sum_AN_SUA += Convert.ToDecimal(row["v_AN_SUA"]);
                Sum_AN_QH_DANG_GQ += Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]);
                Sum_AN_QH_DA_GQ += Convert.ToDecimal(row["v_AN_QH_DA_GQ"]);
                StrRowIndex += "<tr class='chan'>";
                StrRowIndex += "<td>Án hình sự chưa thành niên</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_NHAPVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_CHUYENVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_DUOC_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_CON_LAI"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_DANG_HOAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_TDC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_HUY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_SUA"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_QH_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "</tr>";
                #endregion
                // Load phúc thẩm Dân sự
                #region row lẻ
                rows = tbl.Select("v_CAP_XET_XU = 'PT' and v_LOAIAN = 'ADS'");
                row = rows[0];
                Sum_NHAPVUAN += Convert.ToDecimal(row["v_NHAPVUAN"]);
                Sum_CHUYENVUAN += Convert.ToDecimal(row["v_CHUYENVUAN"]);
                Sum_AN_DUOC_PC += Convert.ToDecimal(row["v_AN_DUOC_PC"]);
                Sum_AN_DA_GQ += Convert.ToDecimal(row["v_AN_DA_GQ"]);
                Sum_CON_LAI += Convert.ToDecimal(row["v_CON_LAI"]);
                Sum_DA_LEN_LICH_XET_XU += Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]);
                Sum_DANG_HOAN += Convert.ToDecimal(row["v_DANG_HOAN"]);
                Sum_AN_TDC += Convert.ToDecimal(row["v_AN_TDC"]);
                Sum_AN_HUY += Convert.ToDecimal(row["v_AN_HUY"]);
                Sum_AN_SUA += Convert.ToDecimal(row["v_AN_SUA"]);
                Sum_AN_QH_DANG_GQ += Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]);
                Sum_AN_QH_DA_GQ += Convert.ToDecimal(row["v_AN_QH_DA_GQ"]);
                StrRowIndex += "<tr class='le'>";
                StrRowIndex += "<td>Dân sự</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_NHAPVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_CHUYENVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_DUOC_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_CON_LAI"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_DANG_HOAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_TDC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_HUY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_SUA"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_QH_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "</tr>";
                #endregion
                // Load phúc thẩm KDTM
                #region row chẵn
                rows = tbl.Select("v_CAP_XET_XU = 'PT' and v_LOAIAN = 'AKT'");
                row = rows[0];
                Sum_NHAPVUAN += Convert.ToDecimal(row["v_NHAPVUAN"]);
                Sum_CHUYENVUAN += Convert.ToDecimal(row["v_CHUYENVUAN"]);
                Sum_AN_DUOC_PC += Convert.ToDecimal(row["v_AN_DUOC_PC"]);
                Sum_AN_DA_GQ += Convert.ToDecimal(row["v_AN_DA_GQ"]);
                Sum_CON_LAI += Convert.ToDecimal(row["v_CON_LAI"]);
                Sum_DA_LEN_LICH_XET_XU += Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]);
                Sum_DANG_HOAN += Convert.ToDecimal(row["v_DANG_HOAN"]);
                Sum_AN_TDC += Convert.ToDecimal(row["v_AN_TDC"]);
                Sum_AN_HUY += Convert.ToDecimal(row["v_AN_HUY"]);
                Sum_AN_SUA += Convert.ToDecimal(row["v_AN_SUA"]);
                Sum_AN_QH_DANG_GQ += Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]);
                Sum_AN_QH_DA_GQ += Convert.ToDecimal(row["v_AN_QH_DA_GQ"]);
                StrRowIndex += "<tr class='chan'>";
                StrRowIndex += "<td>KDTM</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_NHAPVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_CHUYENVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_DUOC_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_CON_LAI"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_DANG_HOAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_TDC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_HUY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_SUA"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_QH_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "</tr>";
                #endregion
                // Load phúc thẩm Hành chính
                #region row lẻ
                rows = tbl.Select("v_CAP_XET_XU = 'PT' and v_LOAIAN = 'AHC'");
                row = rows[0];
                Sum_NHAPVUAN += Convert.ToDecimal(row["v_NHAPVUAN"]);
                Sum_CHUYENVUAN += Convert.ToDecimal(row["v_CHUYENVUAN"]);
                Sum_AN_DUOC_PC += Convert.ToDecimal(row["v_AN_DUOC_PC"]);
                Sum_AN_DA_GQ += Convert.ToDecimal(row["v_AN_DA_GQ"]);
                Sum_CON_LAI += Convert.ToDecimal(row["v_CON_LAI"]);
                Sum_DA_LEN_LICH_XET_XU += Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]);
                Sum_DANG_HOAN += Convert.ToDecimal(row["v_DANG_HOAN"]);
                Sum_AN_TDC += Convert.ToDecimal(row["v_AN_TDC"]);
                Sum_AN_HUY += Convert.ToDecimal(row["v_AN_HUY"]);
                Sum_AN_SUA += Convert.ToDecimal(row["v_AN_SUA"]);
                Sum_AN_QH_DANG_GQ += Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]);
                Sum_AN_QH_DA_GQ += Convert.ToDecimal(row["v_AN_QH_DA_GQ"]);
                StrRowIndex += "<tr class='le'>";
                StrRowIndex += "<td>Hành chính</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_NHAPVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_CHUYENVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_DUOC_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_CON_LAI"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_DANG_HOAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_TDC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_HUY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_SUA"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_QH_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "</tr>";
                #endregion
                // Load phúc thẩm HNGĐ
                #region row chẵn
                rows = tbl.Select("v_CAP_XET_XU = 'PT' and v_LOAIAN = 'AHN'");
                row = rows[0];
                Sum_NHAPVUAN += Convert.ToDecimal(row["v_NHAPVUAN"]);
                Sum_CHUYENVUAN += Convert.ToDecimal(row["v_CHUYENVUAN"]);
                Sum_AN_DUOC_PC += Convert.ToDecimal(row["v_AN_DUOC_PC"]);
                Sum_AN_DA_GQ += Convert.ToDecimal(row["v_AN_DA_GQ"]);
                Sum_CON_LAI += Convert.ToDecimal(row["v_CON_LAI"]);
                Sum_DA_LEN_LICH_XET_XU += Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]);
                Sum_DANG_HOAN += Convert.ToDecimal(row["v_DANG_HOAN"]);
                Sum_AN_TDC += Convert.ToDecimal(row["v_AN_TDC"]);
                Sum_AN_HUY += Convert.ToDecimal(row["v_AN_HUY"]);
                Sum_AN_SUA += Convert.ToDecimal(row["v_AN_SUA"]);
                Sum_AN_QH_DANG_GQ += Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]);
                Sum_AN_QH_DA_GQ += Convert.ToDecimal(row["v_AN_QH_DA_GQ"]);
                StrRowIndex += "<tr class='chan'>";
                StrRowIndex += "<td>HNGĐ</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_NHAPVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_CHUYENVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_DUOC_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_CON_LAI"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_DANG_HOAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_TDC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_HUY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_SUA"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_QH_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "</tr>";
                #endregion
                // Load phúc thẩm Lao động
                #region row lẻ
                rows = tbl.Select("v_CAP_XET_XU = 'PT' and v_LOAIAN = 'ALD'");
                row = rows[0];
                Sum_NHAPVUAN += Convert.ToDecimal(row["v_NHAPVUAN"]);
                Sum_CHUYENVUAN += Convert.ToDecimal(row["v_CHUYENVUAN"]);
                Sum_AN_DUOC_PC += Convert.ToDecimal(row["v_AN_DUOC_PC"]);
                Sum_AN_DA_GQ += Convert.ToDecimal(row["v_AN_DA_GQ"]);
                Sum_CON_LAI += Convert.ToDecimal(row["v_CON_LAI"]);
                Sum_DA_LEN_LICH_XET_XU += Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]);
                Sum_DANG_HOAN += Convert.ToDecimal(row["v_DANG_HOAN"]);
                Sum_AN_TDC += Convert.ToDecimal(row["v_AN_TDC"]);
                Sum_AN_HUY += Convert.ToDecimal(row["v_AN_HUY"]);
                Sum_AN_SUA += Convert.ToDecimal(row["v_AN_SUA"]);
                Sum_AN_QH_DANG_GQ += Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]);
                Sum_AN_QH_DA_GQ += Convert.ToDecimal(row["v_AN_QH_DA_GQ"]);
                StrRowIndex += "<tr class='le'>";
                StrRowIndex += "<td>Lao động</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_NHAPVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_CHUYENVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_DUOC_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_CON_LAI"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_DANG_HOAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_TDC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_HUY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_SUA"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_QH_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "</tr>";
                #endregion
                // Load phúc thẩm Phá sản
                #region row chẵn
                rows = tbl.Select("v_CAP_XET_XU = 'PT' and v_LOAIAN = 'APS'");
                row = rows[0];
                Sum_NHAPVUAN += Convert.ToDecimal(row["v_NHAPVUAN"]);
                Sum_CHUYENVUAN += Convert.ToDecimal(row["v_CHUYENVUAN"]);
                Sum_AN_DUOC_PC += Convert.ToDecimal(row["v_AN_DUOC_PC"]);
                Sum_AN_DA_GQ += Convert.ToDecimal(row["v_AN_DA_GQ"]);
                Sum_CON_LAI += Convert.ToDecimal(row["v_CON_LAI"]);
                Sum_DA_LEN_LICH_XET_XU += Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]);
                Sum_DANG_HOAN += Convert.ToDecimal(row["v_DANG_HOAN"]);
                Sum_AN_TDC += Convert.ToDecimal(row["v_AN_TDC"]);
                Sum_AN_HUY += Convert.ToDecimal(row["v_AN_HUY"]);
                Sum_AN_SUA += Convert.ToDecimal(row["v_AN_SUA"]);
                Sum_AN_QH_DANG_GQ += Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]);
                Sum_AN_QH_DA_GQ += Convert.ToDecimal(row["v_AN_QH_DA_GQ"]);
                StrRowIndex += "<tr class='chan'>";
                StrRowIndex += "<td>Phá sản</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_NHAPVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_CHUYENVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_DUOC_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_CON_LAI"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_DANG_HOAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_TDC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_HUY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_SUA"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_QH_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "</tr>";
                #endregion
                // Load phúc thẩm BPXLHC
                #region row lẻ
                rows = tbl.Select("v_CAP_XET_XU = 'PT' and v_LOAIAN = 'XLHC'");
                row = rows[0];
                Sum_NHAPVUAN += Convert.ToDecimal(row["v_NHAPVUAN"]);
                Sum_CHUYENVUAN += Convert.ToDecimal(row["v_CHUYENVUAN"]);
                Sum_AN_DUOC_PC += Convert.ToDecimal(row["v_AN_DUOC_PC"]);
                Sum_AN_DA_GQ += Convert.ToDecimal(row["v_AN_DA_GQ"]);
                Sum_CON_LAI += Convert.ToDecimal(row["v_CON_LAI"]);
                Sum_DA_LEN_LICH_XET_XU += Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]);
                Sum_DANG_HOAN += Convert.ToDecimal(row["v_DANG_HOAN"]);
                Sum_AN_TDC += Convert.ToDecimal(row["v_AN_TDC"]);
                Sum_AN_HUY += Convert.ToDecimal(row["v_AN_HUY"]);
                Sum_AN_SUA += Convert.ToDecimal(row["v_AN_SUA"]);
                Sum_AN_QH_DANG_GQ += Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]);
                Sum_AN_QH_DA_GQ += Convert.ToDecimal(row["v_AN_QH_DA_GQ"]);
                StrRowIndex += "<tr class='le'>";
                StrRowIndex += "<td>BPXLHC</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_NHAPVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_CHUYENVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_DUOC_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_CON_LAI"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_DANG_HOAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_TDC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_HUY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_SUA"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "<td style='text-align: right;'>" + Convert.ToDecimal(row["v_AN_QH_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowIndex += "</tr>";
                #endregion
                #endregion
                #region row Tổng (row chẵn)
                StrRowTotal += "<tr class='chan'>";
                StrRowTotal += "<td colspan='2' style='text-align: center; font-weight: bold;'>TỔNG</td>";
                StrRowTotal += "<td style='text-align: right; font-weight: bold;'>" + Sum_NHAPVUAN.ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowTotal += "<td style='text-align: right; font-weight: bold;'>" + Sum_CHUYENVUAN.ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowTotal += "<td style='text-align: right; font-weight: bold;'>" + Sum_AN_DUOC_PC.ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowTotal += "<td style='text-align: right; font-weight: bold;'>" + Sum_AN_DA_GQ.ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowTotal += "<td style='text-align: right; font-weight: bold;'>" + Sum_CON_LAI.ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowTotal += "<td style='text-align: right; font-weight: bold;'>" + Sum_DA_LEN_LICH_XET_XU.ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowTotal += "<td style='text-align: right; font-weight: bold;'>" + Sum_DANG_HOAN.ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowTotal += "<td style='text-align: right; font-weight: bold;'>" + Sum_AN_TDC.ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowTotal += "<td style='text-align: right; font-weight: bold;'>" + Sum_AN_HUY.ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowTotal += "<td style='text-align: right; font-weight: bold;'>" + Sum_AN_SUA.ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowTotal += "<td style='text-align: right; font-weight: bold;'>" + Sum_AN_QH_DANG_GQ.ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowTotal += "<td style='text-align: right; font-weight: bold;'>" + Sum_AN_QH_DA_GQ.ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                StrRowTotal += "</tr>";
                #endregion
                ltrContent.Text = StrRowTotal + StrRowIndex;
            }
            Session["Data_CA_Home_ChiTiet_TP"] = tbl;
        }
        protected void cmdInBaoCao_Click(object sender, EventArgs e)
        {
            Cls_Comon.CallFunctionJS(this, this.GetType(), "popup_home_inbaocao_chitiet_tp()");
        }

        protected void LbtBack_Click(object sender, EventArgs e)
        {
            string link = Cls_Comon.GetRootURL() + "/Trangchu.aspx";
            Response.Redirect(link);
        }
    }
}