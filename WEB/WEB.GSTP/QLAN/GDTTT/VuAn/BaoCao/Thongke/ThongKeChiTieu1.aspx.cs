using BL.GSTP;
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
using BL.GSTP.GDTTT;
using System.Text;

namespace WEB.GSTP.QLAN.GDTTT.VuAn.BaoCao.Thongke
{
    public partial class ThongKeChiTieu1 : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            //scriptManager.RegisterPostBackControl(this.btnXemBC);
            scriptManager.RegisterPostBackControl(this.btnXuatBC);
            try
            {
                if (!IsPostBack)
                {
                    txtNgay_Tu_ky.Text = "01/01/" + DateTime.Today.Year;
                    txtNgay_Den_ky.Text = "31/12/" + DateTime.Today.Year;

                    txtNgay_Tu.Text = "01/" + string.Format("{0:MM}", DateTime.Today) + "/" + DateTime.Today.Year;
                    txtNgay_Den.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now);
                    string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
                    decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
                    GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();
                    //Thẩm tra viên
                    DataTable oTTVDT = oGDTBL.CANBO_GETBYPHONGBAN(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), PBID, ENUM_CHUCDANH.CHUCDANH_TTV);
                    ddlThamtravien.DataSource = oTTVDT;
                    ddlThamtravien.DataTextField = "HOTEN";
                    ddlThamtravien.DataValueField = "ID";
                    ddlThamtravien.DataBind();
                    ddlThamtravien.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));

                    //Lãnh đạo
                    DM_CANBO_BL oCBBL = new DM_CANBO_BL();
                    DataTable oTLDDT = oGDTBL.CANBO_GETBYDONVI_2CHUCVU(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), PBID, ENUM_CHUCVU.CHUCVU_PVT, ENUM_CHUCVU.CHUCVU_VT);
                    ddlPhoVuTruong.DataSource = oTLDDT;
                    ddlPhoVuTruong.DataTextField = "HOTEN";
                    ddlPhoVuTruong.DataValueField = "ID";
                    ddlPhoVuTruong.DataBind();
                    ddlPhoVuTruong.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
                }
            }
            catch (Exception ex) { lblmsg.Text = ex.Message; }
        }
        protected void btnXemBC_Click(object sender, EventArgs e)
        {
            try
            {
                Load_BC();
            }
            catch (Exception ex) { lblmsg.Text = ex.Message; }
        }

      

        private void Load_BC()
        {
            lblmsg.Text = "";

            if (CheckData() == false)
            {
                return;
            }
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            object Result = new object();
            decimal LanhDaoID = Convert.ToDecimal(ddlPhoVuTruong.SelectedValue);
            decimal ThamtraVienID = Convert.ToDecimal(ddlThamtravien.SelectedValue);
            DM_PHONGBAN oPB = dt.DM_PHONGBAN.Where(x => x.ID == PBID).FirstOrDefault();
            DateTime? vNgayTu = txtNgay_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgay_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime? vNgayDen = txtNgay_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgay_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);

            DateTime? vNgayTu_ky = txtNgay_Tu_ky.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgay_Tu_ky.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime? vNgayDen_ky = txtNgay_Den_ky.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgay_Den_ky.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            Literal Table_Str_Totals = new Literal();
            GDTTT_BAOCAO_BL oBL = new GDTTT_BAOCAO_BL();
            DataTable tbl = new DataTable();
            DataRow row = tbl.NewRow();
            //-------------
            tbl = oBL.GetAll_ThongKeChiTieu(oPB.TENPHONGBAN, ToaAnID, PBID, vNgayTu, vNgayDen, vNgayTu_ky, vNgayDen_ky, LanhDaoID, ThamtraVienID);
            //-----------
            if (tbl != null && tbl.Rows.Count > 0)
            {
                row = tbl.Rows[0];
                Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
            }
            lblNoidungBC.Text = Table_Str_Totals.Text;
        }

        protected void btnXuatBC_Click(object sender, EventArgs e)
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

            if (CheckData() == false)
            {
                return;
            }
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            object Result = new object();
            decimal LanhDaoID = Convert.ToDecimal(ddlPhoVuTruong.SelectedValue);
            decimal ThamtraVienID = Convert.ToDecimal(ddlThamtravien.SelectedValue);
            DM_PHONGBAN oPB = dt.DM_PHONGBAN.Where(x => x.ID == PBID).FirstOrDefault();
            DateTime? vNgayTu = txtNgay_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgay_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime? vNgayDen = txtNgay_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgay_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);

            DateTime? vNgayTu_ky = txtNgay_Tu_ky.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgay_Tu_ky.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime? vNgayDen_ky = txtNgay_Den_ky.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgay_Den_ky.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            Literal Table_Str_Totals = new Literal();
            GDTTT_BAOCAO_BL oBL = new GDTTT_BAOCAO_BL();
            DataTable tbl = new DataTable();
            DataRow row = tbl.NewRow();
            //-------------
            tbl = oBL.GetAll_ThongKeChiTieu(oPB.TENPHONGBAN, ToaAnID, PBID, vNgayTu, vNgayDen, vNgayTu_ky, vNgayDen_ky, LanhDaoID, ThamtraVienID);
            //-----------
            if (tbl != null && tbl.Rows.Count > 0)
            {
                row = tbl.Rows[0];
                Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
            }
            //--------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=thong_ke_chi_tieu_01.doc");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/msword";
            HttpContext.Current.Response.ContentEncoding = System.Text.UnicodeEncoding.UTF8;
            Response.Write("<html");
            Response.Write("<head>");
            Response.Write("<!--[if gte mso 9]> <xml> <w:WordDocument> <w:View>Print</w:View> <w:Zoom>100</w:Zoom> <w:DoNotOptimizeForBrowser/> </w:WordDocument> </xml> <![endif]-->");
            Response.Write("<META HTTP-EQUIV=Content-Type CONTENT=text/html; charset=UTF-8>");
            Response.Write("<meta name=ProgId content=Word.Document>");
            Response.Write("<meta name=Generator content=Microsoft Word 9>");
            Response.Write("<meta name=Originator content=Microsoft Word 9>");
            Response.Write("<style>");
            Response.Write("@page Section1 {size:595.45pt 841.7pt; margin:.75in .5in .75in .5in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");
            Response.Write("div.Section1 {page:Section1;}");
            //Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:1.25in 1.0in 1.25in 1.0in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");
            Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5in 1.0in 0.5in 1.0in;mso-header-margin:.1in;mso-footer-margin:.1in;mso-paper-source:0;}");
            Response.Write("div.Section2 {page:Section2;}");
            Response.Write("<style>");
            Response.Write("</head>");
            Response.Write("<body>");
            Response.Write("<div class=Section2>");
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.Write("</div>");
            Response.Write("</body>");
            Response.Write("</html>");
            Response.End();
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
        private string AddExcelStyling()
        {
            StringBuilder sb = new StringBuilder();

            sb.Append("\n" +
            "\n");

            sb.Append("<style>\n");
            sb.Append("@page");
            sb.Append("{margin:.2in .2in .2in .2in;\n");
            sb.Append("mso-header-margin:.3in;\n");
            sb.Append("mso-footer-margin:.3in;\n");

            sb.Append("mso-page-orientation:landscape;}\n"); // portrait or landscape
            sb.Append("</style>\n");
            sb.Append("<!--[if gte mso 9]><xml>\n");
            sb.Append("<x:ExcelWorkbook>\n");
            sb.Append("<x:ExcelWorksheets>\n");
            sb.Append("<x:ExcelWorksheet>\n");

            sb.Append("<x:Name>Projects 3 </x:Name>\n");
            sb.Append("<x:WorksheetOptions>\n");
            sb.Append("<x:Print>\n");
            sb.Append("<x:Scale>45</x:Scale>\n"); // scaling in percentage value
            sb.Append("<x:ValidPrinterInfo/>\n");

            sb.Append("<x:PaperSizeIndex>1</x:PaperSizeIndex>\n"); // 1=letter , 4=legal
            sb.Append("<x:HorizontalResolution>600</x:HorizontalResolution\n");
            sb.Append("<x:VerticalResolution>600</x:VerticalResolution\n");
            sb.Append("</x:Print>\n");
            sb.Append("<x:Selected/>\n");
            sb.Append("<x:DoNotDisplayGridlines/>\n");

            sb.Append("<x:ProtectContents>False</x:ProtectContents>\n");
            sb.Append("<x:ProtectObjects>False</x:ProtectObjects>\n");
            sb.Append("<x:ProtectScenarios>False</x:ProtectScenarios>\n");
            sb.Append("</x:WorksheetOptions>\n");
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
            sb.Append("\n");
            sb.Append("\n");
            return sb.ToString();
        }
        public void ExportDataGridToExcel(System.Web.UI.Control ctrl, System.Web.HttpResponse response)

        {

            response.Clear();
            response.Buffer = true;

            response.Cache.SetCacheability(HttpCacheability.NoCache);
            response.ContentType = "application/vnd.ms-excel";

            response.AddHeader("content-disposition", "attachment;filename=Projects.xls");
            response.Charset = "";

            this.EnableViewState = false;
            System.IO.StringWriter oStringWriter = new System.IO.StringWriter();

            System.Web.UI.HtmlTextWriter oHtmlTextWriter = new System.Web.UI.HtmlTextWriter(oStringWriter);
            //ClearControls(ctrl);

            ctrl.RenderControl(oHtmlTextWriter);

            // set content type and character set to cope with european chars like the umlaut.
            response.Write("<meta http-equiv=Content-Type content=\"text/html; charset=utf-8\">\n");

            // add the style props to get the page orientation

            response.Write(AddExcelStyling());

            response.Write(oStringWriter.ToString());
            response.Write("</body>"); response.Write("</html>");

            response.End();

        }

    }
}
