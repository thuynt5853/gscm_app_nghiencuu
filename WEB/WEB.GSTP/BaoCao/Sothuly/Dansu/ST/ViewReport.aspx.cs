using DAL.GSTP;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.BaoCao.Sothuly.Dansu.ST
{
    public partial class ViewReport : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            scriptManager.RegisterPostBackControl(this.btnExportExcel);

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
            string TenToaAn = ddlDonVi.SelectedItem.Text, IsHaveToaAnCon = "FALSE", TuNgay = txtNgay_Tu.Text, DenNgay = txtNgay_Den.Text;
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
                string sql = "PKG_GSTP_SOTHULY_SOTHAM.SO_DANSU_SOTHAM";
                tbl = Cls_Comon.GetTableByProcedurePaging(sql, parameters);
            }
            catch { }
            rptSoTL_ADS_ST rpt = new rptSoTL_ADS_ST();
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

        protected void btnExportExcel_Click(object sender, EventArgs e)
        {
            try
            {
                lblmsg.Text = "";
                string TenToaAn = ddlDonVi.SelectedItem.Text, IsHaveToaAnCon = "FALSE", TuNgay = txtNgay_Tu.Text, DenNgay = txtNgay_Den.Text;
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
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GSTP_SOTHULY_SOTHAM_PRINT.SO_DANSU_SOTHAM", parameters);
                //-----------------------------------------
                Literal Table_Str_Totals = new Literal();
                DataRow row = tbl.NewRow();
                //-----------
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=dsdaxu.xls");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/vnd.xls";
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                Response.Write(AddExcelStyling(2, null));   // add the style props to get the page orientation
                Table_Str_Totals.RenderControl(htmlWrite);
                Response.Write(stringWrite.ToString());
                Response.Write("</body>");   // add the style props to get the page orientation
                Response.Write("</html>");   // add the style props to get the page orientation
                Response.End();
            }
            catch (System.Data.Entity.Validation.DbEntityValidationException dbEx)
            {
                foreach (var validationErrors in dbEx.EntityValidationErrors)
                {
                    foreach (var validationError in validationErrors.ValidationErrors)
                    {
                        lblmsg.Text = "property: " + validationError.PropertyName + " Error: " + validationError.ErrorMessage;
                    }
                }
            }
            catch (Exception ex)
            {
                // Xử lý lỗi chung (Nếu có lỗi ngoài DbEntityValidationException)
                lblmsg.Text = "Lỗi hệ thống: " + ex.Message;
            }
        }

        private string AddExcelStyling(Int32 landscape, String INSERT_PAGE_BREAK)
        {
            // add the style props to get the page orientation
            StringBuilder sb = new StringBuilder();
            sb.Append("<html xmlns:o='urn:schemas-microsoft-com:office:office'\n" +
            "xmlns:x='urn:schemas-microsoft-com:office:excel'\n" +
            "xmlns='http://www.w3.org/TR/REC-html40'>\n" +
            "<head>\n");
            sb.Append("<style>\n");
            sb.Append("@page");
            //page margin can be changed based on requirement.....
            //sb.Append("{margin:0.5in 0.2992125984in 0.5in 0.5984251969in;\n");
            sb.Append("{margin:0.5905511811in 0.2992125984in 0.5905511811in 0.5984251969in;\n");
            sb.Append("mso-header-margin:.5in;\n");
            sb.Append("mso-footer-margin:.5in;\n");
            if (landscape == 2)//landscape orientation
            {
                sb.Append("mso-page-orientation:landscape;}\n");
            }
            sb.Append("</style>\n");
            sb.Append("<!--[if gte mso 9]><xml>\n");
            sb.Append("<x:ExcelWorkbook>\n");
            sb.Append("<x:ExcelWorksheets>\n");
            sb.Append("<x:ExcelWorksheet>\n");
            sb.Append("<x:Name>Projects 3 </x:Name>\n");
            sb.Append("<x:WorksheetOptions>\n");
            sb.Append("<x:Print>\n");
            sb.Append("<x:ValidPrinterInfo/>\n");
            sb.Append("<x:PaperSizeIndex>9</x:PaperSizeIndex>\n");
            sb.Append("<x:HorizontalResolution>600</x:HorizontalResolution\n");
            sb.Append("<x:VerticalResolution>600</x:VerticalResolution\n");
            sb.Append("</x:Print>\n");
            sb.Append("<x:Selected/>\n");
            sb.Append("<x:DoNotDisplayGridlines/>\n");
            sb.Append("<x:ProtectContents>False</x:ProtectContents>\n");
            sb.Append("<x:ProtectObjects>False</x:ProtectObjects>\n");
            sb.Append("<x:ProtectScenarios>False</x:ProtectScenarios>\n");
            sb.Append("</x:WorksheetOptions>\n");
            //-------------
            if (INSERT_PAGE_BREAK != null)
            {
                sb.Append("<x:PageBreaks> xmlns='urn:schemas-microsoft-com:office:excel'\n");
                sb.Append("<x:RowBreaks>\n");
                String[] rows_ = INSERT_PAGE_BREAK.Split(',');
                String Append_s = "";
                for (int i = 0; i < rows_.Length; i++)
                {
                    Append_s = Append_s + "<x:RowBreak><x:Row>" + rows_[i] + "</x:Row></x:RowBreak>\n";
                }
                sb.Append(Append_s);
                sb.Append("</x:RowBreaks>\n");
                sb.Append("</x:PageBreaks>\n");
            }
            //----------
            sb.Append("</x:ExcelWorksheet>\n");
            sb.Append("</x:ExcelWorksheets>\n");
            sb.Append("<x:WindowHeight>12780</x:WindowHeight>\n");
            sb.Append("<x:WindowWidth>19035</x:WindowWidth>\n");
            sb.Append("<x:WindowTopX>0</x:WindowTopX>\n");
            sb.Append("<x:WindowTopY>15</x:WindowTopY>\n");
            sb.Append("<x:ProtectStructure>False</x:ProtectStructure>\n");
            sb.Append("<x:ProtectWindows>False</x:ProtectWindows>\n");
            sb.Append("</x:ExcelWorkbook>\n");
            sb.Append("</xml><![endif]-->\n");
            sb.Append("</head>\n");
            sb.Append("<body>\n");
            return sb.ToString();
        }
    }
}