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
using BL.GSTP.BANGSETGET;
using Oracle.ManagedDataAccess.Client;


namespace WEB.GSTP.QLAN
{
    public partial class BaocaoNhapLieu : System.Web.UI.Page
    {
        //--------------------------------
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        Decimal CurrDonViID;
        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            scriptManager.RegisterPostBackControl(this.cmdPrint);
            if (!IsPostBack)
            {
                DateTime start_date = DateTime.Today.AddMonths(0);//0 lấy tháng hiện tại;-1 lấy 1 tháng trở về trước tính từ ngày hiện tại
                string strDate = "01" + start_date.ToString("/MM/yyyy");
                txtThuly_Tu.Text = strDate;
                txtThuly_Den.Text = DateTime.Now.ToString("dd/MM/yyyy");
                //LoadDropToaAn();

                CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                if (CurrDonViID > 0)
                {
                    DM_TOAAN objDV = dt.DM_TOAAN.Where(x => x.ID == CurrDonViID).FirstOrDefault();
                    String str_typeusers = objDV.LOAITOA;
                    Session["LOAITOA"] = objDV.LOAITOA;
                    //Get_Object_Permission(str_typeusers);
                    if (CurrDonViID ==1)
                        ddlLoaiBaocao.Items.Add(new ListItem("Báo cáo số liệu kết quả công tác thụ lý, giải quyết theo loại án (TC)", "6"));
                }
            }
        }
        protected void ddlLoaiBaocao_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlLoaiBaocao.SelectedValue == "1")
            {
                pnTINHTRANG_GIAIQUYET.Visible = true;
                lblThuly_Tungay.Text = "Thụ lý từ ngày";
                lblThuly_Denngay.Text = "Đến ngày";
            }
            else if (ddlLoaiBaocao.SelectedValue == "2")
            {
                pnTINHTRANG_GIAIQUYET.Visible = true;
                lblThuly_Tungay.Text = "Từ ngày";
                lblThuly_Denngay.Text = "Đến ngày";
            }
            else if (ddlLoaiBaocao.SelectedValue == "3")
            {
                pnTINHTRANG_GIAIQUYET.Visible = false;
                lblThuly_Tungay.Text = "Từ ngày";
                lblThuly_Denngay.Text = "Đến ngày";
            }
            else if (ddlLoaiBaocao.SelectedValue == "4")
            {
                pnTINHTRANG_GIAIQUYET.Visible = false;
                lblThuly_Tungay.Text = "Từ ngày";
                lblThuly_Denngay.Text = "Đến ngày";
            }
            else if (ddlLoaiBaocao.SelectedValue == "5")
            {
                pnTINHTRANG_GIAIQUYET.Visible = false;
                lblThuly_Tungay.Text = "Từ ngày";
                lblThuly_Denngay.Text = "Đến ngày";
            }
            else if (ddlLoaiBaocao.SelectedValue == "6")
            {
                pnTINHTRANG_GIAIQUYET.Visible = false;
                lblThuly_Tungay.Text = "Từ ngày";
                lblThuly_Denngay.Text = "Đến ngày";
            }
        }

        public void Get_Courts_Options()
        {
            String str_typeusers = Session["LOAITOA"].ToString();
            DM_TOAAN_BL qtBL = new DM_TOAAN_BL();
            DataTable oDT = new DataTable();
            oDT = qtBL.QT_Donvi_TA_BC(str_typeusers, Drop_object.SelectedValue);
            Getdata_Courts(oDT);
        }

        protected void btn_NhapMoi_Click(object sender, EventArgs e)
        {
            txtThuly_Tu.Text = string.Empty;
            txtThuly_Den.Text = string.Empty;
            reset_DropCourt();
        }
        protected void cmdPrint_Click(object sender, EventArgs e)
        {
            if (txtThuly_Tu.Text == "")
            {
                lblmsg.Text = "Bạn phải nhập từ ngày.";
                return;
            }
            if (txtThuly_Den.Text == "")
            {
                lblmsg.Text = "Bạn phải nhập đến ngày.";
                return;
            }
            if (ddlLoaiBaocao.SelectedValue == "1")
            {
                LoadReport_bcpt_1();//Tổng hợp số liệu
            }
            else if (ddlLoaiBaocao.SelectedValue == "2")
            {
                LoadReport_baocao_Hinhthucxetxu();
            }
            else if (ddlLoaiBaocao.SelectedValue == "3")
            {
                LoadReport_baocao_KETQUA_THULY_GIAIQUYET();
            }
            else if (ddlLoaiBaocao.SelectedValue == "4")
            {
                LoadReport_baocao_KETQUA_THULY_GIAIQUYET_2CAP();
            }
            else if (ddlLoaiBaocao.SelectedValue == "5")
            {
                LoadReport_bcpt_2();
            }
            else if (ddlLoaiBaocao.SelectedValue == "6")
            {
                LoadReport_nhaplieu_tc();
            }
        }
        private bool CheckData()
        {
            string TuNgay = txtThuly_Tu.Text, DenNgay = txtThuly_Den.Text;
            if (TuNgay == "")
            {
                lblmsg.Text = "Bạn chưa nhập từ ngày.";
                Cls_Comon.SetFocus(this.txtThuly_Tu, this.GetType(), txtThuly_Tu.ClientID);
                return false;
            }
            if (TuNgay != "")
            {
                DateTime Day_TuNgay = DateTime.Now;
                if (DateTime.TryParse(TuNgay, new System.Globalization.CultureInfo("vi-VN"), System.Globalization.DateTimeStyles.NoCurrentDateDefault, out Day_TuNgay) == false)
                {
                    lblmsg.Text = "Bạn nhập từ ngày chưa đúng theo định dạng (Ngày / Tháng / Năm).";
                    Cls_Comon.SetFocus(this.txtThuly_Tu, this.GetType(), txtThuly_Tu.ClientID);
                    return false;
                }
            }
            if (DenNgay == "")
            {
                lblmsg.Text = "Bạn chưa nhập đến ngày.";
                Cls_Comon.SetFocus(this.txtThuly_Den, this.GetType(), txtThuly_Den.ClientID);
                return false;
            }
            if (DenNgay != "")
            {
                DateTime Day_DenNgay = DateTime.Now;
                if (DateTime.TryParse(DenNgay, new System.Globalization.CultureInfo("vi-VN"), System.Globalization.DateTimeStyles.NoCurrentDateDefault, out Day_DenNgay) == false)
                {
                    lblmsg.Text = "Bạn nhập đến ngày đúng theo định dạng (Ngày / Tháng / Năm).";
                    Cls_Comon.SetFocus(this.txtThuly_Den, this.GetType(), txtThuly_Den.ClientID);
                    return false;
                }
            }
            if (TuNgay != "" && DenNgay != "")
            {
                if (DateTime.Parse(txtThuly_Tu.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault) > DateTime.Parse(txtThuly_Den.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault))
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




        protected void cmd_courts_selects_Click(object sender, EventArgs e)
        {
            String str_typeusers = Session["LOAITOA"].ToString();
            Get_Permission_Courts(str_typeusers);
            ScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "window_Shows_courts()", true);
        }
        public void Get_Permission_Courts(String str_typeusers)
        {
            if (str_typeusers == "TOICAO")
            {
                Get_Courts_Options();

            }
            else if (str_typeusers == "CAPCAO")
            {
                Get_Courts_CC();
            }
            else if (str_typeusers == "CAPTINH")
            {
                Get_Courts_Tinh();
            }
            else if (str_typeusers == "CAPHUYEN")
            {
                Get_Courts_Huyen();
            }

        }
        public void Get_Courts_CC()
        {
            String str_donvi_id = Session[ENUM_SESSION.SESSION_DONVIID].ToString();
            QT_TUPHAP_BL qtBL = new QT_TUPHAP_BL();
            DataTable oDT = new DataTable();
            //oDT = qtBL.QT_Donvi_THADS_TINH(str_donvi_id);
            DM_TOAAN_BL oBL = new DM_TOAAN_BL();
            oDT = oBL.GetDonVi_By_CapChaID_BCCC(Convert.ToDecimal(str_donvi_id));
            Getdata_Courts(oDT);
        }
        public void Get_Courts_Tinh()
        {
            String str_donvi_id = Session[ENUM_SESSION.SESSION_DONVIID].ToString();
            DataTable oDT = new DataTable();
            DM_TOAAN_BL oBL = new DM_TOAAN_BL();
            oDT = oBL.GET_Donvi_TA_TINH(str_donvi_id);
            Getdata_Courts(oDT);
        }
        public void Get_Courts_Huyen()
        {
            String str_donvi_id = Session[ENUM_SESSION.SESSION_DONVIID].ToString();
            DataTable oDT = new DataTable();
            DM_TOAAN_BL oBL = new DM_TOAAN_BL();
            oDT = oBL.GET_Donvi_TA_HUYEN(str_donvi_id);
            Getdata_Courts(oDT);
        }
        public void Get_Object_Permission(String str_typeusers)
        {
            ListItem items = new ListItem();
            Drop_object.Items.Clear();
            if (str_typeusers == "CAPCAO")
            {
                items = new ListItem("Tất cả", "TH");
                Drop_object.Items.Add(items);
                items = new ListItem("Cấp cao", "CAPCAO");
                Drop_object.Items.Add(items);
                items = new ListItem("Cấp tỉnh", "CAPTINH");
                Drop_object.Items.Add(items);
            }
            else if (str_typeusers == "CAPTINH")
            {
                items = new ListItem("Tất cả", "TH");
                Drop_object.Items.Add(items);
                items = new ListItem("Cấp tỉnh", "CAPTINH");
                Drop_object.Items.Add(items);
                items = new ListItem("Cấp huyện", "CAPHUYEN");
                Drop_object.Items.Add(items);
            }
            else if (str_typeusers == "TOICAO")
            {
                items = new ListItem("Tất cả", "TH");
                Drop_object.Items.Add(items);
                items = new ListItem("Tối cao", "TOICAO");
                Drop_object.Items.Add(items);
                items = new ListItem("Cấp cao", "CAPCAO");
                Drop_object.Items.Add(items);
                items = new ListItem("Cấp tỉnh", "CAPTINH");
                Drop_object.Items.Add(items);
                items = new ListItem("Cấp huyện", "CAPHUYEN");
                Drop_object.Items.Add(items);
            }
        }
        public void Getdata_Courts(DataTable oDT)
        {
            txt_courts_show.Text = String.Empty;
            Show_Court_Cheks.Value = String.Empty;
            Hi_value_ID_Court.Value = String.Empty;
            hi_value_objects.Value = Session[ENUM_SESSION.SESSION_DONVIID].ToString();
            List<TreeviewNode_toaan> tvn = new List<TreeviewNode_toaan>();
            foreach (DataRow row in oDT.Rows)
            {
                TreeviewNode_toaan nodes = new TreeviewNode_toaan();
                nodes.ID = row["ID"].ToString();
                nodes.PARENT_ID = row["CAPCHAID"].ToString();
                nodes.TEXT = row["TEN"].ToString();
                tvn.Add(nodes);
            }
            Treeview_Load(TreeView_Courts, null, tvn);
            MP_Window_courts.Show();
        }
        protected void Drop_object_SelectedIndexChanged(object sender, EventArgs e)
        {
            reset_DropCourt();
        }

        #region Báo cáo
        private void LoadReport_baocao_Hinhthucxetxu()
        {
            try
            {
                String v_court = "";
                v_court = Hi_value_ID_Court.Value;
                CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                        new OracleParameter("vDonViID", CurrDonViID),
                        new OracleParameter("V_TUNGAY",txtThuly_Tu.Text.Trim()),
                        new OracleParameter("V_DENNGAY",txtThuly_Den.Text.Trim()),
                        new OracleParameter("v_TOAANID",v_court)
                        };

                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_HINHTHUCXETXU.BAOCAO_XETXUTRUCTUYEN", parameters);

                Literal Table_Str_Totals = new Literal();
                DataRow row = tbl.NewRow();
                //-----
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=Tonghop_nhaplieu.xls");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/vnd.xls";
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                Response.Write(AddExcelStyling(2, null));   // add the style props to get the page orientation
                Table_Str_Totals.RenderControl(htmlWrite);
                Response.Write(stringWrite.ToString());
                Response.Write("</body>");
                Response.Write("</html>");   // add the style props to get the page orientation
                Response.End();
            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
            }
        }

        private void LoadReport_bcpt_1()
        {
            try
            {
                String v_court = "";
                v_court = Hi_value_ID_Court.Value;
                CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                STPT_BAOCAO_BL oBL = new STPT_BAOCAO_BL();
                DataTable tbl = oBL.Tong_hop_so_lieu_nhaplieu(CurrDonViID, DropTINHTRANG_THULY.SelectedValue,
                              DropTINHTRANG_GIAIQUYET.SelectedValue, txtThuly_Tu.Text.Trim(), txtThuly_Den.Text.Trim(), v_court);
                Literal Table_Str_Totals = new Literal();
                DataRow row = tbl.NewRow();
                //-----
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=Tonghop_nhaplieu.xls");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/vnd.xls";
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                Response.Write(AddExcelStyling(2, null));   // add the style props to get the page orientation
                Table_Str_Totals.RenderControl(htmlWrite);
                Response.Write(stringWrite.ToString());
                Response.Write("</body>");
                Response.Write("</html>");   // add the style props to get the page orientation
                Response.End();
            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
            }
        }
        
        private void LoadReport_nhaplieu_tc()
        {
            try
            {
                String v_court = "";
                v_court = Hi_value_ID_Court.Value;
                CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                STPT_BAOCAO_BL oBL = new STPT_BAOCAO_BL();
                DataTable tbl = oBL.Tong_hop_so_lieu_nhaplieu_TC(CurrDonViID, DropTINHTRANG_THULY.SelectedValue,
                              DropTINHTRANG_GIAIQUYET.SelectedValue, txtThuly_Tu.Text.Trim(), txtThuly_Den.Text.Trim(), v_court);
                Literal Table_Str_Totals = new Literal();
                DataRow row = tbl.NewRow();
                //-----
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=Tonghop_nhaplieu.xls");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/vnd.xls";
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                Response.Write(AddExcelStyling(2, null));   // add the style props to get the page orientation
                Table_Str_Totals.RenderControl(htmlWrite);
                Response.Write(stringWrite.ToString());
                Response.Write("</body>");
                Response.Write("</html>");   // add the style props to get the page orientation
                Response.End();
            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
            }
        }
        private void LoadReport_bcpt_2()
        {
            try
            {
                String v_court = "";
                v_court = Hi_value_ID_Court.Value;
                CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                STPT_BAOCAO_BL oBL = new STPT_BAOCAO_BL();
                DataTable tbl = oBL.Tong_hop_so_lieu_nhaplieu2(CurrDonViID, DropTINHTRANG_THULY.SelectedValue,
                              DropTINHTRANG_GIAIQUYET.SelectedValue, txtThuly_Tu.Text.Trim(), txtThuly_Den.Text.Trim(), v_court);
                Literal Table_Str_Totals = new Literal();
                DataRow row = tbl.NewRow();
                //-----
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=Tonghop_nhaplieu.xls");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/vnd.xls";
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                Response.Write(AddExcelStyling(2, null));   // add the style props to get the page orientation
                Table_Str_Totals.RenderControl(htmlWrite);
                Response.Write(stringWrite.ToString());
                Response.Write("</body>");
                Response.Write("</html>");   // add the style props to get the page orientation
                Response.End();
            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
            }
        }
        private void LoadReport_baocao_KETQUA_THULY_GIAIQUYET()
        {
            try
            {
                String v_court = "";
                v_court = Hi_value_ID_Court.Value;
                CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                        new OracleParameter("vDonViID", CurrDonViID),
                        new OracleParameter("V_TUNGAY",txtThuly_Tu.Text.Trim()),
                        new OracleParameter("V_DENNGAY",txtThuly_Den.Text.Trim()),
                        new OracleParameter("v_TOAANID",v_court)
                        };

                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("BAOCAO_KETQUA_THULY_GIAIQUYET", parameters);

                Literal Table_Str_Totals = new Literal();
                DataRow row = tbl.NewRow();
                //-----
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=Tonghop_nhaplieu.xls");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/vnd.xls";
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                Response.Write(AddExcelStyling(2, null));   // add the style props to get the page orientation
                Table_Str_Totals.RenderControl(htmlWrite);
                Response.Write(stringWrite.ToString());
                Response.Write("</body>");
                Response.Write("</html>");   // add the style props to get the page orientation
                Response.End();
            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
            }
        }
        private void LoadReport_baocao_KETQUA_THULY_GIAIQUYET_2CAP()
        {
            try
            {
                String v_court = "";
                v_court = Hi_value_ID_Court.Value;
                CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                        new OracleParameter("vDonViID", CurrDonViID),
                        new OracleParameter("V_TUNGAY",txtThuly_Tu.Text.Trim()),
                        new OracleParameter("V_DENNGAY",txtThuly_Den.Text.Trim()),
                        new OracleParameter("v_TOAANID",v_court)
                        };

                DataTable tbl = Cls_Comon.GetTableByProcedurePaging_baocao("BAOCAO_THULY_GIAIQUYET_2CAP", parameters);

                Literal Table_Str_Totals = new Literal();
                DataRow row = tbl.NewRow();
                //-----
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=Tonghop_nhaplieu.xls");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/vnd.xls";
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                Response.Write(AddExcelStyling(2, null));   // add the style props to get the page orientation
                Table_Str_Totals.RenderControl(htmlWrite);
                Response.Write(stringWrite.ToString());
                Response.Write("</body>");
                Response.Write("</html>");   // add the style props to get the page orientation
                Response.End();
            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
            }
        }

        #endregion


        private void reset_DropCourt()
        {
            txt_courts_show.Text = String.Empty;
            Show_Court_Cheks.Value = String.Empty;
            Hi_value_ID_Court.Value = String.Empty;
            hi_text_courts.Value = String.Empty;
            //TreeView_Courts.UncheckAllNodes();
            //TreeView_Courts -> uncheck client
            Treeview_UncheckNode(TreeView_Courts);
            ScriptManager.RegisterStartupScript(this.Page, Page.GetType(), Guid.NewGuid().ToString(), "treeview_Unchecked('" + TreeView_Courts.ClientID + "')", true);
        }


        #region "TREEVIEW (HOLD OFF)"
        private void Treeview_Load(TreeView tv, TreeNode rootNode, List<TreeviewNode_toaan> listNodes)
        {
            tv.Nodes.Clear();
            TreeNode oRoot;
            if (rootNode == null)
            {
                List<TreeviewNode_toaan> rootNodes = listNodes.FindAll(x => x.ID == Session[ENUM_SESSION.SESSION_DONVIID].ToString());
                if (rootNodes.Count > 0)
                {
                    foreach (TreeviewNode_toaan r in rootNodes)
                    {
                        oRoot = new TreeNode(r.TEXT, r.ID);
                        tv.Nodes.Add(oRoot);
                        Treeview_LoadChild(oRoot, "", oRoot, listNodes);
                        tv.Nodes[0].Expand();
                    }
                }
                else
                {
                    oRoot = new TreeNode("Danh sách", "0");
                    tv.Nodes.Add(oRoot);
                    Treeview_LoadChild(oRoot, "", oRoot, listNodes);
                    tv.Nodes[0].Expand();
                }
            }
            else
            {
                oRoot = rootNode;
                tv.Nodes.Add(oRoot);
                Treeview_LoadChild(oRoot, "", oRoot, listNodes);
                tv.Nodes[0].Expand();
            }
            //tv.Nodes[0].Expand();
            tv.ShowCheckBoxes = TreeNodeTypes.All;
            tv.ShowLines = true;
        }
        private void Treeview_LoadChild(TreeNode root, string dept, TreeNode currentNode, List<TreeviewNode_toaan> listNodes)
        {
            List<TreeviewNode_toaan> listchild = new List<TreeviewNode_toaan>();
            if (currentNode != null)
            {
                foreach (TreeviewNode_toaan n in listNodes)
                {
                    if (n.PARENT_ID == currentNode.Value)
                    {
                        listchild.Add(n);
                    }
                }
            }
            if (listchild.Count > 0)
            {
                foreach (TreeviewNode_toaan child in listchild)
                {
                    TreeNode nodechild;
                    nodechild = Treeview_CreateNode(child.ID, child.TEXT);
                    root.ChildNodes.Add(nodechild);
                    Treeview_LoadChild(nodechild, ".." + dept, nodechild, listNodes);
                    root.CollapseAll();
                }
            }
        }
        private TreeNode Treeview_CreateNode(string sNodeId, string sNodeText)
        {
            TreeNode objTreeNode = new TreeNode();
            objTreeNode.Value = sNodeId;
            objTreeNode.Text = sNodeText;
            return objTreeNode;
        }
        private void Treeview_UncheckNode(TreeView _treeView)
        {
            TreeNodeCollection nodeCollection = _treeView.Nodes;
            foreach (TreeNode node in nodeCollection)
            {
                node.Checked = false;
            }
        }
        #endregion

    }
}