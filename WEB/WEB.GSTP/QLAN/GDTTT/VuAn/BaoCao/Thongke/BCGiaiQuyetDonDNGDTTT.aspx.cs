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
   
    public partial class BCGiaiQuyetDonDNGDTTT : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            scriptManager.RegisterPostBackControl(this.btnXemBC);
            try
            {
                if (!IsPostBack)
                {
                    txtNgay_Tu.Text = "";//"01/" + string.Format("{0:MM}", DateTime.Today) + "/" + DateTime.Today.Year;
                    txtNgay_Den.Text = "";//string.Format("{0:dd/MM/yyyy}", DateTime.Now);
                    string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
                    decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
                }
            }
            catch (Exception ex) { lblmsg.Text = ex.Message; }
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
            //----
            if (CheckData() == false)
            {
                return;
            }
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            Int32 PBID = strPBID == "" ? 0 : Convert.ToInt32(strPBID);
            object Result = new object();
            //DM_PHONGBAN oPB = dt.DM_PHONGBAN.Where(x => x.ID == PBID).FirstOrDefault();
            DateTime? vNgayTu = txtNgay_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgay_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime? vNgayDen = txtNgay_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgay_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            Literal Table_Str_Totals = new Literal();
            GDTTT_BAOCAO_BL oBL = new GDTTT_BAOCAO_BL();
            DataTable tbl = new DataTable();
            DataRow row = tbl.NewRow();
            //-------------
            tbl = oBL.BaoCao_GQ_DonDN_GDTTT(ToaAnID, PBID, vNgayTu, vNgayDen);
            //-----------
            if (tbl != null && tbl.Rows.Count > 0)
            {
                row = tbl.Rows[0];
                Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
            }
            //--------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=BC_GQ_DONDN_GDTTT.doc");
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
            Response.Write("@page Section1 {size:595.45pt 841.7pt; margin:0.7874015748in 0.5905511811in 0.7086614173in 1.18in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");
            Response.Write("div.Section1 {page:Section1;}");
            //Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:1.25in 1.0in 1.25in 1.0in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");
            Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5in 1.0in 0.5in 1.0in;mso-header-margin:.1in;mso-footer-margin:.1in;mso-paper-source:0;}");
            Response.Write("div.Section2 {page:Section2;}");
            Response.Write("<style>");
            Response.Write("</head>");
            Response.Write("<body>");
            Response.Write("<div class=Section1>");
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
                lblmsg.Text = "Bạn chưa nhập từ ngày.";
                Cls_Comon.SetFocus(this.txtNgay_Tu, this.GetType(), txtNgay_Tu.ClientID);
                return false;
            }
            if (TuNgay != "")
            {
                DateTime Day_TuNgay = DateTime.Now;
                if (DateTime.TryParse(TuNgay, new System.Globalization.CultureInfo("vi-VN"), System.Globalization.DateTimeStyles.NoCurrentDateDefault, out Day_TuNgay) == false)
                {
                    lblmsg.Text = "Bạn nhập từ ngày chưa đúng theo định dạng (Ngày / Tháng / Năm).";
                    Cls_Comon.SetFocus(this.txtNgay_Tu, this.GetType(), txtNgay_Tu.ClientID);
                    return false;
                }
            }
            if (DenNgay == "")
            {
                lblmsg.Text = "Bạn chưa nhập đến ngày.";
                Cls_Comon.SetFocus(this.txtNgay_Den, this.GetType(), txtNgay_Den.ClientID);
                return false;
            }
            if (DenNgay != "")
            {
                DateTime Day_DenNgay = DateTime.Now;
                if (DateTime.TryParse(DenNgay, new System.Globalization.CultureInfo("vi-VN"), System.Globalization.DateTimeStyles.NoCurrentDateDefault, out Day_DenNgay) == false)
                {
                    lblmsg.Text = "Bạn nhập đến ngày đúng theo định dạng (Ngày / Tháng / Năm).";
                    Cls_Comon.SetFocus(this.txtNgay_Den, this.GetType(), txtNgay_Den.ClientID);
                    return false;
                }
            }
            if (TuNgay != "" && DenNgay != "")
            {
                if (DateTime.Parse(txtNgay_Tu.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault) > DateTime.Parse(txtNgay_Den.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault))
                {
                    lblmsg.Text = "Từ ngày phải nhỏ hơn hoặc bằng đến ngày.";
                    return false;
                }

            }
            return true;
        }
    }
}