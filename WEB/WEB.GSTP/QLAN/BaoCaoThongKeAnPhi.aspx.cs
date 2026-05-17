using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web.UI.WebControls;
using System.Web.UI;
using System.Web;
using BL.GSTP.GDTTT;
using BL.GSTP.ADS;
using System.Text;

namespace WEB.GSTP.QLAN
{
    public partial class BaoCaoThongKeAnPhi : System.Web.UI.Page
    {
        //--------------------------------
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            scriptManager.RegisterPostBackControl(this.cmdPrint);
            if (!IsPostBack)
            {
                DateTime start_date = DateTime.Today.AddMonths(0);//0 lấy tháng hiện tại;-1 lấy 1 tháng trở về trước tính từ ngày hiện tại
                string strDate = "01" + start_date.ToString("/MM/yyyy");
                txtTuNgay.Text = strDate;
                txtDenNgay.Text = DateTime.Now.ToString("dd/MM/yyyy");
                //Bao_Cao_permi();
                //LoadTatCaLoaiAn();
                var CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                if (CurrDonViID > 0)
                {
                    DM_TOAAN objDV = dt.DM_TOAAN.Where(x => x.ID == CurrDonViID).FirstOrDefault();
                    String str_typeusers = objDV.LOAITOA;
                    Session["LOAITOA"] = objDV.LOAITOA;
                    Session["TEN_DV"] = objDV.TEN;
                    //Get_Object_Permission(str_typeusers);
                }
            }
        }
        
        //void Bao_Cao_permi()
        //{
        //    GDTTT_APP_BL obj_M = new GDTTT_APP_BL();
        //    DataTable objs = obj_M.Permi_Add_BC(Request.FilePath.ToString(), Convert.ToDecimal(Session["UserID"]));
        //    ddl_menu_bc.DataSource = objs;
        //    ddl_menu_bc.DataTextField = "TENMENU";
        //    ddl_menu_bc.DataValueField = "MAACTION";
        //    ddl_menu_bc.DataBind();
        //}
        protected void btn_NhapMoi_Click(object sender, EventArgs e)
        {
            txtTuNgay.Text = string.Empty;
            txtDenNgay.Text = string.Empty;
        }
        protected void cmdPrint_Click(object sender, EventArgs e)
        {
            if(txtTuNgay.Text=="")
            {
                lblmsg.Text = "Bạn phải nhập từ ngày.";
                return;
            }
            if (txtDenNgay.Text == "")
            {
                lblmsg.Text = "Bạn phải nhập đến ngày.";
                return;
            }
            try
                {
                //switch (ddl_menu_bc.SelectedValue)
                //{
                //    case "bcpt_01":
                        LoadReport_bcpt_1();//Tổng hợp số liệu xét xử của các tòa chuyên trách
                //        break;
                //    case "bcpt_02":
                //        LoadReport_bcpt_2();//Thống kê tình hình thụ lý, giải quyết xét xử theo trình tự phúc thẩm các loại vụ, việc
                //        break;
                //    case "bcpt_03":
                //        LoadReport_bcpt_3();//Kết quả thụ lý và giải quyết phúc thẩm án các loại
                //        break;
                //    case "bctk_hctp":
                //        LoadReport_bctk_hctp();//Thống kê cho HCTP về số đơn mặc định theo tuần
                //        break;
                //    case ENUM_BAOCAO_THONGKE.BAOCAOCHITIEUVEDONTHEOKY_THAMPHAN:
                //        LoadReport_bctk_ttp();//báo cáo thống kê theo thẩm phán
                //        break;
                //    case ENUM_BAOCAO_THONGKE.BAOCAOCHITIEUVEDONTHEOKY_LOAIAN:
                //        LoadReport_bctk_tla();//báo cáo thống kê theo loại án
                //        break;
                //        //default:
                //        //    break;
                //}
            }
            catch (Exception ex) { lblmsg.Text = ex.Message; }
        }
        private bool CheckData()
        {
            string TuNgay = txtTuNgay.Text, DenNgay = txtDenNgay.Text;
            if (TuNgay == "")
            {
                lblmsg.Text = "Bạn chưa nhập từ ngày.";
                Cls_Comon.SetFocus(this.txtTuNgay, this.GetType(), txtTuNgay.ClientID);
                return false;
            }
            if (TuNgay != "")
            {
                DateTime Day_TuNgay = DateTime.Now;
                if (DateTime.TryParse(TuNgay, new System.Globalization.CultureInfo("vi-VN"), System.Globalization.DateTimeStyles.NoCurrentDateDefault, out Day_TuNgay) == false)
                {
                    lblmsg.Text = "Bạn nhập từ ngày chưa đúng theo định dạng (Ngày / Tháng / Năm).";
                    Cls_Comon.SetFocus(this.txtTuNgay, this.GetType(), txtTuNgay.ClientID);
                    return false;
                }
            }
            if (DenNgay == "")
            {
                lblmsg.Text = "Bạn chưa nhập đến ngày.";
                Cls_Comon.SetFocus(this.txtDenNgay, this.GetType(), txtDenNgay.ClientID);
                return false;
            }
            if (DenNgay != "")
            {
                DateTime Day_DenNgay = DateTime.Now;
                if (DateTime.TryParse(DenNgay, new System.Globalization.CultureInfo("vi-VN"), System.Globalization.DateTimeStyles.NoCurrentDateDefault, out Day_DenNgay) == false)
                {
                    lblmsg.Text = "Bạn nhập đến ngày đúng theo định dạng (Ngày / Tháng / Năm).";
                    Cls_Comon.SetFocus(this.txtDenNgay, this.GetType(), txtDenNgay.ClientID);
                    return false;
                }
            }
            if (TuNgay != "" && DenNgay != "")
            {
                if (DateTime.Parse(txtTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault) > DateTime.Parse(txtDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault))
                {
                    lblmsg.Text = "Từ ngày phải nhỏ hơn hoặc bằng đến ngày.";
                    return false;
                }
            }
            return true;
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
        private void LoadReport_bcpt_1()
        {
            try
            {
                String v_court = "";
                Int16 v_options = 1;
                String v_Names = "";
                String Vleustype = Session["LOAITOA"].ToString();
                if (Drop_object.SelectedValue == "H")
                {
                    if (Vleustype == "CAPHUYEN")
                    {
                        v_court = Session[ENUM_SESSION.SESSION_DONVIID].ToString();
                        v_Names = Session["TEN_DV"].ToString().ToUpper();
                    }
                    else if (Vleustype == "CAPTINH")
                    {
                        v_Names = "CHI CỤC THI HÀNH ÁN DÂN SỰ ";
                        //if (Hi_value_ID_Court.Value != "")
                        //{
                        //    v_options = 1;
                        //    v_court = Hi_value_ID_Court.Value;
                        //}
                        //else
                        //{
                        v_court = Session[ENUM_SESSION.SESSION_DONVIID].ToString();
                        v_options = 2;
                        //}
                    }
                    else
                    {
                        v_court = Session[ENUM_SESSION.SESSION_DONVIID].ToString();
                        v_Names = "CHI CỤC THI HÀNH ÁN DÂN SỰ ";
                    }
                }
                else if (Drop_object.SelectedValue == "T")
                {
                    if (Vleustype == "CAPTINH")
                    {
                        v_court = Session[ENUM_SESSION.SESSION_DONVIID].ToString();
                        v_Names = "CỤC THI HÀNH ÁN DÂN SỰ";
                    }
                    else
                    {
                        v_court = Session[ENUM_SESSION.SESSION_DONVIID].ToString();
                        v_Names = "CỤC THI HÀNH ÁN DÂN SỰ ";
                    }
                }
                else if (Drop_object.SelectedValue == "TH")
                {
                    if (Vleustype == "CAPTINH")
                    {
                        v_court = Session[ENUM_SESSION.SESSION_DONVIID].ToString();
                        v_Names = "CỤC THI HÀNH ÁN DÂN SỰ";
                    }
                    else
                    {
                        v_court = Session[ENUM_SESSION.SESSION_DONVIID].ToString();
                        v_Names = "TỔNG CỤC THI HÀNH ÁN DÂN SỰ";
                    }
                }
                TAM_UNG_AN_PHI_BL oBL = new TAM_UNG_AN_PHI_BL();
                Literal Table_Str_Totals = new Literal();
                DataTable tbl = new DataTable();
                DataRow row = tbl.NewRow();
                //DataTable tbl = oBL.Tong_hop_so_lieu_xx(drop_cbtk.SelectedValue, Drop_ld_phong.SelectedValue, Session["CAP_XET_XU"] + "", Session[ENUM_SESSION.SESSION_DONVIID]+"", txtTuNgay.Text.Trim(), txtDenNgay.Text.Trim(),ddlLoaiAn.SelectedValue);
                tbl = oBL.GetAll_report(ddl_TRUCTUYEN.SelectedValue, v_Names, v_options, txtTuNgay.Text, txtDenNgay.Text, v_court, Drop_object.SelectedValue);
                
                //-----
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=mau_01.xls");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/vnd.xls";
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                Table_Str_Totals.RenderControl(htmlWrite);
                Response.Write(stringWrite.ToString());
                Response.End();
                //Response.Clear();
                //Response.AddHeader("content-disposition", "attachment;filename=Tonghop_solieu_xx.xls");
                //Response.Cache.SetCacheability(HttpCacheability.NoCache);
                //Response.ContentType = "application/vnd.xls";
                //System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                //System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                //htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                //Response.Write(AddExcelStyling(2, null));   // add the style props to get the page orientation
                //Table_Str_Totals.RenderControl(htmlWrite);
                //Response.Write(stringWrite.ToString());
                //Response.Write("</body>");   
                //Response.Write("</html>");   // add the style props to get the page orientation
                //Response.End();
            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
            }
        }
    }
}