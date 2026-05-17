using System;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Module.Common;
using System.Globalization;
using DAL.GSTP;
using System.Data;
using System.IO;
using BL.GSTP.QLAN;
using Oracle.ManagedDataAccess.Client;
using DocumentFormat.OpenXml;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Wordprocessing;
using System.Text.RegularExpressions;
using System.Runtime.Caching;

namespace WEB.GSTP.QLAN.BAOCAOCA
{
    public partial class uThongKe_Chanhan : System.Web.UI.UserControl
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");

        public DateTime currentDate = DateTime.Now;
        public DateTime startDate, endDate;
        public DateTime startDateBefore, endDateBefore;

        public string redirect_Giaiquyetdon = "DanhsachCA_VUAN.aspx";
        public string redirect_Xxgdttt = "DanhsachCA_VUAN.aspx";//"DanhsachCA_VUAN.aspx";

        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            scriptManager.RegisterPostBackControl(this.btnXemBC_TP);
            scriptManager.RegisterPostBackControl(this.btnXemBC_TPTATCM1);
            scriptManager.RegisterPostBackControl(this.btnXemBC_STPT_M2);

            try
            {
                if (!IsPostBack)
                {
                    string strCanBoID = Session[ENUM_SESSION.SESSION_CANBOID] + "";

                    if (strCanBoID != "" && strCanBoID != "0")
                    {
                        //lblTieude_STPT.Text = ("tổng quan tình hình xử lý đơn của các toàn án nhân dân").ToUpper();

                        LoadDropThamphan();
                        LoadDropToaAn();

                        SetGetSessionTK();
                       
                        LoadTKThamphan();
                        LoadTKThamphan_ANQH();
                        LoadTKThamphan_THOIHIEU();
                    }

                    Clear_SessionTK();

                }
            }
            catch (Exception ex)
            {
                string errorMessage = ex.ToString();
                ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('" + ex.ToString() + "!')", true);
            }
        }

        #region load dropdownlist
        private void LoadDropThamphan()
        {
            DASHBOARD_GDT_BL OBL = new DASHBOARD_GDT_BL();
            decimal vThamphan_id;
            if (ddlThamphan.SelectedValue == "" || ddlThamphan.SelectedValue == "0")
            {
                vThamphan_id = 0;
            }
            else
            {
                vThamphan_id = Convert.ToInt32(ddlThamphan.SelectedValue);
            }

            DataTable tbl = OBL.MHCA_DANHSACH_THAMPHAN_TOICAO(Session[ENUM_SESSION.SESSION_DONVIID] + "", (Int32)vThamphan_id);
            ddlThamphan.DataSource = tbl;
            ddlThamphan.DataTextField = "HOTEN";
            ddlThamphan.DataValueField = "ID";
            ddlThamphan.DataBind();
        }
        private void LoadDropToaAn()
        {
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
            DM_TOAAN oT = dt.DM_TOAAN.Where(x => x.ID == ToaAnID).FirstOrDefault();

            OracleParameter[] parameters = new OracleParameter[] {
            new OracleParameter("DONVIID",ToaAnID.ToString()),
            new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging_baocao("PKG_DASHBOARD.DASHBOARD_GET_DANHSACH_TOAAN", parameters);

            DropToaAn.DataSource = tbl;
            DropToaAn.DataTextField = "TENDONVI";
            DropToaAn.DataValueField = "ID";
            DropToaAn.DataBind();

            foreach (System.Web.UI.WebControls.ListItem item in DropToaAn.Items)
            {
                if (item.Value == "1")
                {
                    DropToaAn.Items.Remove(item);
                    break;
                }
            }
            DropToaAn.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Tất cả --", "0"));
            DropToaAn.SelectedIndex = 0;
        }
        #endregion

        protected void TabClick(object sender, EventArgs e)
        {
            LinkButton clickedButton = (LinkButton)sender;
            string viewName = clickedButton.Attributes["data-view"];

            // Thay đổi tab tương ứng
            if (viewName == "ViewTATC")
            {
                // Đặt ViewTATC làm tab hiện tại
                mv1.ActiveViewIndex = 0;
                ddlThamphan.SelectedValue = "0";
            }
            else if (viewName == "ViewTPTATC")
            {
                mv1.ActiveViewIndex = 1;
                Load_DataTPTATCM1();
            }
            else if (viewName == "ViewPCA")
            {
                mv1.ActiveViewIndex = 3;
                Load_DataPCAM1();
            }
            else if (viewName == "ViewVUGDKT")
            {
                mv1.ActiveViewIndex = 4;
                Load_DataVUGDKTM1();
            }
            else if (viewName == "ViewTAND")
            {
                // Đặt ViewTAND làm tab hiện tại
                mv1.ActiveViewIndex = 2;
                LoadTK_Toaan_STPT();
                ViewTAND_M2.Visible = false;
            }
            
            // Xử lý chọn tab
            tabtatc.CssClass = "tab " + (viewName == "ViewTATC" ? "selected" : "");
            tabtptatc.CssClass = "tab " + (viewName == "ViewTPTATC" ? "selected" : "");
            tabtpca.CssClass = "tab " + (viewName == "ViewPCA" ? "selected" : "");
            tabstpt.CssClass = "tab " + (viewName == "ViewTAND" ? "selected" : "");
            tabgdkt.CssClass = "tab " + (viewName == "ViewVUGDKT" ? "selected" : "");
        }
        // Thay đổi tab đang hiển thị trong MultiView
        private void SetActiveTab(string viewId)
        {
            // Thiết lập view trong MultiView
            mv1.SetActiveView(mv1.FindControl(viewId) as System.Web.UI.WebControls.View);

            // Đảm bảo các tab được cập nhật đúng
            tabtatc.CssClass = viewId == "ViewTATC" ? "tab selected" : "tab";
            tabtptatc.CssClass = viewId == "ViewTPTATC" ? "tab selected" : "tab";
            tabtpca.CssClass = viewId == "ViewPCA" ? "tab selected" : "tab";
            tabstpt.CssClass = viewId == "ViewTAND" ? "tab selected" : "tab";
            tabgdkt.CssClass = viewId == "ViewVUGDKT" ? "tab selected" : "tab";
        }
        void Clear_SessionTK()
        {
            Session[SS_BAOCAO_CA.LOAIAN] = 0;
            Session[SS_BAOCAO_CA.THAMPHAN] = "0";
            Session[SS_BAOCAO_CA.TUNGAY] = "";
            Session[SS_BAOCAO_CA.DENNGAY] = "";
            Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "";

            Session[SS_BAOCAO_CA.VUANIDs] = "";

            Session[SS_BAOCAO_CA.VALUE_TAB] = "";
            Session[SS_BAOCAO_CA.VALUE_TIME] = "";

            Session[SS_BAOCAO_CA.VALUE_ANQUOCHOI] = "";
            Session[SS_BAOCAO_CA.VALUE_ANTHOIHIEU] = "";
        }
        private void SetGetSessionTK()
        {
            if (Session[SS_BAOCAO_CA.VALUE_TAB] != null && Session[SS_BAOCAO_CA.VALUE_TAB].ToString() != "")
            {
                if (Session[SS_BAOCAO_CA.VALUE_TAB].ToString() == "ViewTATC")
                {
                    SetActiveTab("ViewTATC");

                    if (Session[SS_BAOCAO_CA.THAMPHAN] != null && Session[SS_BAOCAO_CA.THAMPHAN].ToString() != "")
                    {
                        ddlThamphan.SelectedValue = Session[SS_BAOCAO_CA.THAMPHAN].ToString();
                    }

                    if (Session[SS_BAOCAO_CA.VALUE_TIME] != null && Session[SS_BAOCAO_CA.VALUE_TIME].ToString() != "")
                    {
                        ddl_Load_Thoigian.SelectedValue = Session[SS_BAOCAO_CA.VALUE_TIME].ToString();
                    }
                }
                else if (Session[SS_BAOCAO_CA.VALUE_TAB].ToString() == "ViewTPTATC")
                {
                    SetActiveTab("ViewTPTATC");
                    Load_DataTPTATCM1();
                }
                else if (Session[SS_BAOCAO_CA.VALUE_TAB].ToString() == "ViewPCA")
                {
                    SetActiveTab("ViewPCA");
                    Load_DataPCAM1();
                }
                else if (Session[SS_BAOCAO_CA.VALUE_TAB].ToString() == "ViewVUGDKT")
                {
                    SetActiveTab("ViewVUGDKT");
                    Load_DataVUGDKTM1();
                }
                else if (Session[SS_BAOCAO_CA.VALUE_TAB].ToString() == "ViewTAND")
                {
                    SetActiveTab("ViewTAND");
                    LoadTK_Toaan_STPT();
                }
            }
            else
            {
                mv1.ActiveViewIndex = 0;
                SetActiveTab("ViewTATC");
            }
        }

        public string FormatNumberWithDot(decimal value)
        {
            if (value == 0)
            {
                return "";
            }

            CultureInfo cul = new CultureInfo("vi-VN");
            cul.NumberFormat.NumberDecimalSeparator = ",";
            cul.NumberFormat.NumberGroupSeparator = ".";
            
            string formattedNumber = value.ToString("#,0.###", cul);
            
            return Regex.Replace(formattedNumber, ",0+$", "");
        }

        string get_Loaian_number(string strLoaiAn)
        {
            if (strLoaiAn == "Hình sự")
            {
                return ENUM_LOAIVUVIEC.AN_HINHSU;
            }
            else if (strLoaiAn == "Dân sự")
            {
                return ENUM_LOAIVUVIEC.AN_DANSU;
            }
            else if (strLoaiAn == "Hôn nhân và gia đình")
            {
                return ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH;
            }
            else if (strLoaiAn == "Kinh doanh, thương mại")
            {
                return ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI;
            }
            else if (strLoaiAn == "Lao động")
            {
                return ENUM_LOAIVUVIEC.AN_LAODONG;
            }
            else if (strLoaiAn == "Hành chính")
            {
                return ENUM_LOAIVUVIEC.AN_HANHCHINH;
            }
            else if (strLoaiAn == "Phá sản")
            {
                return ENUM_LOAIVUVIEC.AN_PHASAN;
            }
            else
            {
                return "0";
            }
        }
        public void set_thoigian(DropDownList ddl_Thoigian)
        {
            switch (ddl_Thoigian.SelectedValue.ToLower())
            {
                case "year":
                    // Chọn năm - lấy ngày bắt đầu và kết thúc của năm hiện tại
                    startDate = new DateTime(currentDate.Year, 1, 1);
                    endDate = new DateTime(currentDate.Year, 12, 31);
                    break;

                case "month":
                    // Chọn tháng - lấy ngày bắt đầu và kết thúc của tháng hiện tại
                    startDate = new DateTime(currentDate.Year, currentDate.Month, 1);
                    endDate = startDate.AddMonths(1).AddDays(-1); // Lấy ngày cuối tháng
                    break;

                case "week":
                    // Chọn tuần - lấy ngày bắt đầu và kết thúc của tuần hiện tại (từ thứ 2 đến chủ nhật)
                    int daysToStartOfWeek = (int)currentDate.DayOfWeek;
                    // Nếu ngày là Chủ nhật (DayOfWeek = 0), set startDate là ngày thứ 2
                    startDate = currentDate.AddDays(daysToStartOfWeek == 0 ? -6 : -daysToStartOfWeek + 1);
                    endDate = startDate.AddDays(6); // Thứ 7 của tuần hiện tại
                    break;

                default:
                    throw new ArgumentException("Lỗi: Chưa chọn xuất dữ liệu theo Năm, Tháng hay Tuần");
            }
        }

        #region pn_TANDTC_TOICAO_CHUNG
        protected void btnXemBC_TP_Click(object sender, EventArgs e)
        {
            string strCanBoID = ddlThamphan.SelectedValue;

            decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

            Literal Table_Str_Totals = new Literal();

            set_thoigian(ddl_Load_Thoigian);
            string tungay = startDate.ToString("dd/MM/yyyy", cul);
            string denngay = endDate.ToString("dd/MM/yyyy", cul);

            string canboid = Session[ENUM_SESSION.SESSION_CANBOID] + "";

            decimal vThamphanID = 0;
            vThamphanID = Convert.ToDecimal(strCanBoID);


            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.ReturnValue ),
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vThamphanID",vThamphanID),
                new OracleParameter("vTuNgay",startDate),
                new OracleParameter("vDenNgay",endDate)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging_baocao("PKG_DASHBOARD_BAOCAO.DASHBOARD_M1_TATC_BAOCAO", parameters);


            DataRow row = tbl.NewRow();



            if (tbl != null && tbl.Rows.Count > 0)
            {
                row = tbl.Rows[0];
                Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
            }

            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=Thong_Ke_BC_TP.doc"); Response.Cache.SetCacheability(HttpCacheability.NoCache);
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
            Response.Write("<!-- /* Style Definitions */" +
                                          "p.MsoFooter, li.MsoFooter, div.MsoFooter" +
                                          "{margin:0in;" +
                                          "margin-bottom:.0001pt;" +
                                          "mso-pagination:widow-orphan;" +
                                          "tab-stops:center 3.0in right 6.0in;" +
                                          "font-size:12.0pt;}");
            Response.Write("@page Section1 {size:595.45pt 841.7pt; margin:0.78740196228in 0.78740196228in 0.78740196228in 1.181in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;mso-footer: f1;}");
            Response.Write("div.Section1 {page:Section1;}");
            Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5905511811in 0.2992125984in 0.5905511811in 0.5984251969in;mso-header: h1;mso-header-margin:.2in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
            Response.Write("div.Section2 {page:Section2;}");
            Response.Write("<style>");
            Response.Write("</head>");
            Response.Write("<body>");
            Response.Write("<div class=Section2>");//chỉ định khổ giấy
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

        protected void ddl_Load_Thoigian_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadTKThamphan();
            LoadTKThamphan_ANQH();
            LoadTKThamphan_THOIHIEU();

            Session[SS_BAOCAO_CA.VALUE_TIME] = ddl_Load_Thoigian.SelectedValue;

            SetActiveTab("ViewTATC");
        }

        protected void ddlThamphan_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadTKThamphan();
            LoadTKThamphan_ANQH();
            LoadTKThamphan_THOIHIEU();
            SetActiveTab("ViewTATC");
        }

        #endregion

        #region pn_TANDTC_THAMPHAM_TOICAO

        public void LoadTKThamphan()
        {
            try
            {
                decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                set_thoigian(ddl_Load_Thoigian);

                string tungay = startDate.ToString("dd/MM/yyyy", cul);
                string denngay = endDate.ToString("dd/MM/yyyy", cul);

                decimal vThamphanID = Convert.ToDecimal(ddlThamphan.SelectedValue);

                // Tạo key duy nhất cho cache
                string cacheKey = $"TKThamphan_{vToaAnID}_{vThamphanID}_{tungay}_{denngay}";

                // Sử dụng MemoryCache
                ObjectCache cache = MemoryCache.Default;
                DataTable tbl = cache.Get(cacheKey) as DataTable;

                if (tbl == null) // Nếu chưa có cache
                {
                    OracleParameter[] parameters = new OracleParameter[] {
                                                new OracleParameter("vToaAnID", vToaAnID.ToString()),
                                                new OracleParameter("vThamphanid", vThamphanID),
                                                new OracleParameter("vTuNgay", tungay),
                                                new OracleParameter("vDenNgay", denngay),
                                                new OracleParameter("curReturn", OracleDbType.RefCursor, ParameterDirection.Output )
                                            };

                    tbl = Cls_Comon.GetTableByProcedurePaging_baocao("PKG_DASHBOARD_UPDATE_V2.DASHBOARD_GDT_EXP", parameters);

                    // Lưu cache trong 60 phút
                    double vTime = Convert.ToDouble(System.Configuration.ConfigurationManager.AppSettings["KeyCache_b"]);
                    cache.Set(cacheKey, tbl, DateTimeOffset.Now.AddMinutes(vTime));
                }

                // Bind dữ liệu
                if (tbl != null)
                {
                    rptThamPhan.DataSource = tbl;
                    rptThamPhan.DataBind();
                }
                else
                {
                    rptThamPhan.DataSource = null;
                    rptThamPhan.DataBind();
                }
            }
            catch (Exception ex)
            {
                string errorMessage = ex.ToString();
                string script = $"console.error('{errorMessage}');";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "LogError", script, true);
            }
        }

        protected void rptThamPhan_ItemCommand(object sender, RepeaterCommandEventArgs e)
        {
            string strCanBoID = ddlThamphan.SelectedValue;
            decimal CanboID = Convert.ToDecimal(ddlThamphan.SelectedValue);
            string strLoaiAn = e.CommandArgument.ToString();
            if (strLoaiAn == "0") return;
            if (strLoaiAn.Length == 1) strLoaiAn = "0" + strLoaiAn;

            Session[SS_BAOCAO_CA.THAMPHAN] = strCanBoID;
            Session[SS_BAOCAO_CA.LOAIAN] = get_Loaian_number(strLoaiAn);

            set_thoigian(ddl_Load_Thoigian);

            string tungay = startDate.ToString("dd/MM/yyyy", cul);
            string denngay = endDate.ToString("dd/MM/yyyy", cul);

            Session[SS_BAOCAO_CA.TUNGAY] = tungay;
            Session[SS_BAOCAO_CA.DENNGAY] = denngay;
            
            Session[SS_BAOCAO_CA.VALUE_TIME] = ddl_Load_Thoigian.SelectedValue;

            string strTrangThai = e.CommandName;
            switch (strTrangThai)
            {
                case "COLUMN_1":
                    // GIẢI QUYẾT ĐƠN - Tổng số đơn	- Cũ chuyển sang
                    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "2";
                    Response.Redirect(redirect_Giaiquyetdon);
                    break;
                case "COLUMN_2":
                    // GIẢI QUYẾT ĐƠN - Tổng số đơn - Mới thụ lý
                    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "3";
                    Response.Redirect(redirect_Giaiquyetdon);
                    break;
                case "COLUMN_3":
                    // GIẢI QUYẾT ĐƠN - Đã giải quyết xong - Tổng số
                    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "4";
                    Response.Redirect(redirect_Giaiquyetdon);
                    break;
                case "COLUMN_4":
                    //  GIẢI QUYẾT ĐƠN - Đã giải quyết xong - Trả lời đơn
                    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "5";
                    Response.Redirect(redirect_Giaiquyetdon);
                    break;
                case "COLUMN_5":
                    //  GIẢI QUYẾT ĐƠN - Đã giải quyết xong - Kháng nghị
                    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "6";
                    Response.Redirect(redirect_Giaiquyetdon);
                    break;
                case "COLUMN_6":
                    // GIẢI QUYẾT ĐƠN - Đã giải quyết xong - Xếp đơn
                    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "7";
                    Response.Redirect(redirect_Giaiquyetdon);
                    break;
                case "COLUMN_7":
                    // GIẢI QUYẾT ĐƠN - Chưa giải quyết xong
                    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "8";
                    Response.Redirect(redirect_Xxgdttt);
                    break;
                case "COLUMN_8":
                    //XÉT XỬ GIÁM ĐỐC THẨM, TÁI THẨM - Đã giải quyết xong - Tổng số Chưa chuyền tham số cho tổng số
                    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "9";
                    Response.Redirect(redirect_Xxgdttt);
                    break;
                case "COLUMN_9":
                    // XÉT XỬ GIÁM ĐỐC THẨM, TÁI THẨM - Đã giải quyết xong - Chưa tách chánh án kháng nghị hay vks kháng nghị
                    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "10";
                    Response.Redirect(redirect_Xxgdttt);
                    break;
                case "COLUMN_10":
                    // XÉT XỬ GIÁM ĐỐC THẨM, TÁI THẨM - Đã giải quyết xong - Chưa tách chánh án kháng nghị hay vks kháng nghị
                    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "11";
                    Response.Redirect(redirect_Xxgdttt);
                    break;
                case "COLUMN_11":
                    // XÉT XỬ GIÁM ĐỐC THẨM, TÁI THẨM - Đã xét xử
                    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "12";
                    Response.Redirect(redirect_Xxgdttt);
                    break;
                case "COLUMN_12":
                    // XÉT XỬ GIÁM ĐỐC THẨM, TÁI THẨM - Chưa xét xử
                    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "13";
                    Response.Redirect(redirect_Xxgdttt);
                    break;
            }
        }
        protected void rptThamPhan_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                // Lấy dữ liệu từ DataRowView
                DataRowView row = (DataRowView)e.Item.DataItem;

                // Lặp qua các cột từ COLUMN_1 đến COLUMN_12
                for (int i = 1; i <= 12; i++)
                {
                    string columnName = "COLUMN_" + i;

                    // Kiểm tra dữ liệu trong cột
                    if (row[columnName] != DBNull.Value)
                    {
                        decimal value = Convert.ToDecimal(row[columnName]);

                        // Tìm LinkButton trong dòng hiện tại và gán giá trị
                        LinkButton linkButton = (LinkButton)e.Item.FindControl("LinkButton" + (i));

                        if (linkButton != null)
                        {
                            linkButton.Text = FormatNumberWithDot(value);
                        }
                    }
                }
            }
        }
        #endregion

        #region pn_TANDTC_AN_QUOC_HOI

        public void LoadTKThamphan_ANQH()
        {
            try
            {
                decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                set_thoigian(ddl_Load_Thoigian);

                string tungay = startDate.ToString("dd/MM/yyyy", cul);
                string denngay = endDate.ToString("dd/MM/yyyy", cul);

                decimal vThamphanID = Convert.ToDecimal(ddlThamphan.SelectedValue);
                // Tạo key duy nhất cho cache
                string cacheKey = $"TKThamphanQH_{vToaAnID}_{vThamphanID}_{tungay}_{denngay}";

                // Sử dụng MemoryCache
                ObjectCache cache = MemoryCache.Default;
                DataTable tbl = cache.Get(cacheKey) as DataTable;

                if (tbl == null) // Nếu chưa có cache
                { 
                    
                    OracleParameter[] parameters = new OracleParameter[] {
                                        new OracleParameter("vToaAnID",vToaAnID.ToString()),
                                        new OracleParameter("vThamphanid",vThamphanID),
                                        new OracleParameter("vTuNgay",tungay),
                                        new OracleParameter("vDenNgay",denngay),
                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                         };
                    tbl = Cls_Comon.GetTableByProcedurePaging_baocao("PKG_DASHBOARD_UPDATE_V2.DASHBOARD_GDT_QH_EXP", parameters);
                    // Lưu cache trong 60 phút
                    double vTime = Convert.ToDouble(System.Configuration.ConfigurationManager.AppSettings["KeyCache_b"]);
                    cache.Set(cacheKey, tbl, DateTimeOffset.Now.AddMinutes(vTime));
                }


                if (tbl != null)
                {
                    rptThamPhan_ANQH.DataSource = tbl;
                    rptThamPhan_ANQH.DataBind();
                }
                else
                {
                    rptThamPhan_ANQH.DataSource = null;
                    rptThamPhan_ANQH.DataBind();
                }
            }
            catch (Exception ex)
            {
                string errorMessage = ex.ToString();

                // Gửi thông tin lỗi vào console của trình duyệt
                string script = $"console.error('{errorMessage}');";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "LogError", script, true);
            }
        }

        protected void rptThamPhan_ItemCommand_ANQH(object source, RepeaterCommandEventArgs e)
        {
            string strCanBoID = ddlThamphan.SelectedValue;
            decimal CanboID = Convert.ToDecimal(ddlThamphan.SelectedValue);
            string strLoaiAn = e.CommandArgument.ToString();
            if (strLoaiAn == "0") return;
            if (strLoaiAn.Length == 1) strLoaiAn = "0" + strLoaiAn;

            Session[SS_BAOCAO_CA.THAMPHAN] = strCanBoID;
            Session[SS_BAOCAO_CA.LOAIAN] = get_Loaian_number(strLoaiAn);
            Session[SS_BAOCAO_CA.VALUE_ANQUOCHOI] = "99";

            set_thoigian(ddl_Load_Thoigian);

            string tungay = startDate.ToString("dd/MM/yyyy", cul);
            string denngay = endDate.ToString("dd/MM/yyyy", cul);

            Session[SS_BAOCAO_CA.TUNGAY] = tungay;
            Session[SS_BAOCAO_CA.DENNGAY] = denngay;
            
            Session[SS_BAOCAO_CA.VALUE_TIME] = ddl_Load_Thoigian.SelectedValue;

            string strTrangThai = e.CommandName;
            switch (strTrangThai)
            {
                case "COLUMN_1":
                    // GIẢI QUYẾT ĐƠN - Tổng số đơn	- Cũ còn lại
                    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "2";
                    break;
                case "COLUMN_2":
                    // GIẢI QUYẾT ĐƠN - Tổng số đơn	- Thu lý mới
                    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "3";
                    break;
                case "COLUMN_3":
                    // GIẢI QUYẾT ĐƠN - Đã giải quyết xong - Tổng số
                    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "4";
                    break;
                case "COLUMN_4":
                    //  GIẢI QUYẾT ĐƠN - Đã giải quyết xong - Trả lời đơn
                    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "5";
                    break;
                case "COLUMN_5":
                    //  GIẢI QUYẾT ĐƠN - Đã giải quyết xong - Kháng nghị
                    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "6";
                    break;
                case "COLUMN_6":
                    // GIẢI QUYẾT ĐƠN - Đã giải quyết xong - Xếp đơn
                    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "7";
                    break;
                case "COLUMN_7":
                    // GIẢI QUYẾT ĐƠN - Chưa giải quyết xong
                    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "8";
                    break;
                case "COLUMN_8":
                    //XÉT XỬ GIÁM ĐỐC THẨM, TÁI THẨM - Đã giải quyết xong - Tổng số Chưa chuyền tham số cho tổng số
                    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "9";
                    break;
                case "COLUMN_9":
                    // XÉT XỬ GIÁM ĐỐC THẨM, TÁI THẨM - Đã giải quyết xong - Chưa tách chánh án kháng nghị hay vks kháng nghị
                    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "10";
                    break;
                case "COLUMN_10":
                    // XÉT XỬ GIÁM ĐỐC THẨM, TÁI THẨM - Đã giải quyết xong - Chưa tách chánh án kháng nghị hay vks kháng nghị
                    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "11";
                    break;
                case "COLUMN_11":
                    // XÉT XỬ GIÁM ĐỐC THẨM, TÁI THẨM - Đã xét xử
                    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "12";
                    break;
                case "COLUMN_12":
                    // XÉT XỬ GIÁM ĐỐC THẨM, TÁI THẨM - Chưa xét xử
                    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "13";
                    break;
            }
            Response.Redirect(redirect_Xxgdttt);
        }
        protected void rptThamPhan_ItemDataBound_ANQH(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                // Lấy dữ liệu từ DataRowView
                DataRowView row = (DataRowView)e.Item.DataItem;

                // Lặp qua các cột từ COLUMN_1 đến COLUMN_11
                for (int i = 1; i <= 12; i++)
                {
                    string columnName = "COLUMN_" + i;

                    // Kiểm tra dữ liệu trong cột
                    if (row[columnName] != DBNull.Value)
                    {
                        decimal value = Convert.ToDecimal(row[columnName]);

                        // Tìm LinkButton trong dòng hiện tại và gán giá trị
                        LinkButton linkButton = (LinkButton)e.Item.FindControl("LinkButton" + (i) + "_ANQH");

                        if (linkButton != null)
                        {
                            linkButton.Text = FormatNumberWithDot(value);
                        }
                    }
                }
            }
        }

        #endregion

        #region pn_TANDTC_THOIHIEU

        public void LoadTKThamphan_THOIHIEU()
        {
            try
            {
                decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                set_thoigian(ddl_Load_Thoigian);

                string tungay = startDate.ToString("dd/MM/yyyy", cul);
                string denngay = endDate.ToString("dd/MM/yyyy", cul);

                decimal vThamphanID = Convert.ToDecimal(ddlThamphan.SelectedValue);

                // Tạo key duy nhất cho cache
                string cacheKey = $"TKThamphanThoiHieu_{vToaAnID}_{vThamphanID}_{tungay}_{denngay}";

                // Sử dụng MemoryCache
                ObjectCache cache = MemoryCache.Default;
                DataTable tbl = cache.Get(cacheKey) as DataTable;

                if (tbl == null) // Nếu chưa có cache
                { 

                    OracleParameter[] parameters = new OracleParameter[] {
                                                new OracleParameter("vToaAnID",vToaAnID.ToString()),
                                                new OracleParameter("vThamphanid",vThamphanID),
                                                new OracleParameter("vTuNgay",tungay),
                                                new OracleParameter("vDenNgay",denngay),
                                                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                 };
                
                    tbl = Cls_Comon.GetTableByProcedurePaging_baocao("PKG_DASHBOARD_UPDATE_V2.DASHBOARD_GDT_THOIHIEU_EXP", parameters);
                    // Lưu cache trong 60 phút
                    double vTime = Convert.ToDouble(System.Configuration.ConfigurationManager.AppSettings["KeyCache_b"]);
                    cache.Set(cacheKey, tbl, DateTimeOffset.Now.AddMinutes(vTime));
                }

                // Bind dữ liệu
                if (tbl != null)
                {
                    rptThamPhan_THOIHIEU.DataSource = tbl;
                    rptThamPhan_THOIHIEU.DataBind();
                }
                else
                {
                    rptThamPhan_THOIHIEU.DataSource = null;
                    rptThamPhan_THOIHIEU.DataBind();
                }
            }
            catch (Exception ex)
            {
                string errorMessage = ex.ToString();

                // Gửi thông tin lỗi vào console của trình duyệt
                string script = $"console.error('{errorMessage}');";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "LogError", script, true);
            }
        }

        protected void rptThamPhan_ItemCommand_THOIHIEU(object source, RepeaterCommandEventArgs e)
        {
            string strCanBoID = ddlThamphan.SelectedValue;
            decimal CanboID = Convert.ToDecimal(ddlThamphan.SelectedValue);
            string strLoaiAn = e.CommandArgument.ToString();

            if (strLoaiAn == "0") return;
            if (strLoaiAn.Length == 1) strLoaiAn = "0" + strLoaiAn;

            Session[SS_BAOCAO_CA.THAMPHAN] = strCanBoID;
            Session[SS_BAOCAO_CA.LOAIAN] = get_Loaian_number(strLoaiAn);
            Session[SS_BAOCAO_CA.VALUE_ANTHOIHIEU] = "3";

            set_thoigian(ddl_Load_Thoigian);

            string tungay = startDate.ToString("dd/MM/yyyy", cul);
            string denngay = endDate.ToString("dd/MM/yyyy", cul);

            Session[SS_BAOCAO_CA.TUNGAY] = tungay;
            Session[SS_BAOCAO_CA.DENNGAY] = denngay;
            
            Session[SS_BAOCAO_CA.VALUE_TIME] = ddl_Load_Thoigian.SelectedValue;

            string strTrangThai = e.CommandName;
            switch (strTrangThai)
            {
                case "COLUMN_1":
                    // GIẢI QUYẾT ĐƠN - Tổng số đơn	- Cũ còn lại
                    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "2";
                    break;
                case "COLUMN_2":
                    // GIẢI QUYẾT ĐƠN - Tổng số đơn	- Thụ lý mới
                    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "3";
                    break;
                case "COLUMN_3":
                    // GIẢI QUYẾT ĐƠN - Đã giải quyết xong - Tổng số
                    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "4";
                    break;
                case "COLUMN_4":
                    //  GIẢI QUYẾT ĐƠN - Đã giải quyết xong - Trả lời đơn
                    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "5";
                    break;
                case "COLUMN_5":
                    //  GIẢI QUYẾT ĐƠN - Đã giải quyết xong - Kháng nghị
                    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "6";
                    break;
                case "COLUMN_6":
                    // GIẢI QUYẾT ĐƠN - Đã giải quyết xong - Xếp đơn
                    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "7";
                    break;
                case "COLUMN_7":
                    // GIẢI QUYẾT ĐƠN - Chưa giải quyết xong
                    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "8";
                    break;
                case "COLUMN_8":
                    //XÉT XỬ GIÁM ĐỐC THẨM, TÁI THẨM - Đã giải quyết xong - Tổng số
                    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "9";
                    break;
                case "COLUMN_9":
                    // XÉT XỬ GIÁM ĐỐC THẨM, TÁI THẨM - Đã giải quyết xong - Chưa tách chánh án kháng nghị
                    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "10";
                    break;
                case "COLUMN_10":
                    // XÉT XỬ GIÁM ĐỐC THẨM, TÁI THẨM - Đã giải quyết xong - Chưa tách vks kháng nghị
                    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "11";
                    break;
                case "COLUMN_11":
                    // XÉT XỬ GIÁM ĐỐC THẨM, TÁI THẨM - Đã xét xử
                    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "12";
                    break;
                case "COLUMN_12":
                    // XÉT XỬ GIÁM ĐỐC THẨM, TÁI THẨM - Chưa xét xử
                    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "13";
                    break;
            }

            Response.Redirect(redirect_Xxgdttt);
        }
        protected void rptThamPhan_ItemDataBound_THOIHIEU(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                // Lấy dữ liệu từ DataRowView
                DataRowView row = (DataRowView)e.Item.DataItem;

                // Lặp qua các cột từ COLUMN_1 đến COLUMN_11
                for (int i = 1; i <= 12; i++)
                {
                    string columnName = "COLUMN_" + i;

                    // Kiểm tra dữ liệu trong cột
                    if (row[columnName] != DBNull.Value)
                    {
                        decimal value = Convert.ToDecimal(row[columnName]);

                        // Tìm LinkButton trong dòng hiện tại và gán giá trị
                        LinkButton linkButton = (LinkButton)e.Item.FindControl("LinkButton" + (i) + "_THOIHIEU");

                        if (linkButton != null)
                        {
                            linkButton.Text = FormatNumberWithDot(value);
                        }
                    }
                }
            }
        }

        #endregion

        #region PN_STPT_Chung
        public string Load_Thoigian_STPT = "month";
        public void set_thoigianBefore_STPT_M2(DropDownList ddl_Thoigian)
        {
            switch (ddl_Thoigian.SelectedValue.ToLower())
            {
                case "year":
                    // 1 năm trước - lấy ngày bắt đầu và kết thúc của năm trước
                    startDateBefore = startDate.AddYears(-1);
                    endDateBefore = endDate.AddYears(-1);
                    break;

                case "month":
                    // 1 tháng trước - lấy ngày bắt đầu và kết thúc của tháng trước
                    startDateBefore = startDate.AddMonths(-1);
                    endDateBefore = endDate.AddMonths(-1);
                    break;

                case "week":
                    // 1 tuần trước - lấy ngày bắt đầu và kết thúc của tuần trước
                    startDateBefore = startDate.AddDays(-7);
                    endDateBefore = endDate.AddDays(-7);
                    break;

                default:
                    throw new ArgumentException("Lỗi: Chưa chọn xuất dữ liệu theo Năm, Tháng hay Tuần");
            }
        }

        #endregion
        
        //#region pn_STPT_M2
        //protected void rptToaan_STPT_M2_ItemDataBound(object sender, RepeaterItemEventArgs e)
        //{
        //    if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        //    {
        //        DataRowView row = (DataRowView)e.Item.DataItem;

        //        string tangGiam = row["TANGGIAM"]?.ToString()?.Trim();
        //        string tyle = row["TYLE_TANGGIAM"]?.ToString()?.Trim();
        //        string kyTruoc = row["TYLE_KYTRUOC"]?.ToString()?.Trim();
        //        string loaiToa = row["LOAITOA"]?.ToString()?.Trim();
        //        string ten = row["TEN"]?.ToString()?.Trim();

        //        tyle = string.IsNullOrEmpty(tyle) ? "0 %" : tyle;
        //        kyTruoc = string.IsNullOrEmpty(kyTruoc) ? "0 %" : kyTruoc;

        //        // Xử lý lblCOLUMN_5 (Tăng/Giảm)
        //        Label lbtn = (Label)e.Item.FindControl("lblCOLUMN_5");
        //        if (lbtn != null)
        //        {
        //            string color = "black";
        //            if (tangGiam == "Tăng") color = "green";
        //            else if (tangGiam == "Giảm") color = "red";

        //            lbtn.Text = $@"
        //        <span style='font-size:12px; color:{color};'>{tangGiam}: {tyle}</span><br />
        //        <span style='font-size:12px;'> <i>(Kỳ trước: {kyTruoc})</i></span>";
        //        }

        //        // Nếu là cấp huyện thì cho TEN nghiêng
        //        Label lblTen = (Label)e.Item.FindControl("lblCOLUMN_1");
        //        if (lblTen != null)
        //        {
        //            string style = "";
        //            if (loaiToa == "CAPHUYEN")
        //            {
        //                lblTen.Font.Italic = true;
        //                style = "font-size:12px;";
        //            }
        //            else
        //            {
        //                lblTen.Font.Italic = false;
        //                style = "font-size:13px;";
        //            }
                    
        //            lblTen.Text = $"<span style='{style}'>{ten}</span>";
        //        }
        //    }
        //}
        //protected void ddlLoaiTimkiem_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    lstTenBangtimkiem.Text = ddlLoaiTimkiem.SelectedItem.ToString().ToUpper();
        //    LoadTK_Toaan_STPT();
        //}
        //protected void DropToaAn_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    LoadTK_Toaan_STPT();
        //}

        //protected void ddl_Load_Thoigian_STPT_M2_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    LoadTK_Toaan_STPT();
        //}

        //private void LoadTK_Toaan_STPT()
        //{
        //    try
        //    {
        //        lstTenBangtimkiem.Text = ddlLoaiTimkiem.SelectedItem.ToString().ToUpper();

        //        set_thoigian(ddl_Load_Thoigian_STPT_M2);
        //        set_thoigianBefore_STPT_M2(ddl_Load_Thoigian_STPT_M2);

        //        string tungay = startDate.ToString("dd/MM/yyyy", cul);
        //        string denngay = endDate.ToString("dd/MM/yyyy", cul);
        //        string tungay_truoc = startDateBefore.ToString("dd/MM/yyyy", cul);
        //        string denngay_truoc = endDateBefore.ToString("dd/MM/yyyy", cul);

        //        OracleParameter[] parameters = new OracleParameter[] {
        //        new OracleParameter("vToaAnID",Convert.ToDecimal(DropToaAn.SelectedValue)),
        //        new OracleParameter("vTuNgay",tungay),
        //        new OracleParameter("vDenNgay",denngay),
        //        new OracleParameter("vTuNgayTruoc",tungay_truoc),
        //        new OracleParameter("vDenNgayTruoc",denngay_truoc),
        //        new OracleParameter("vColumn",ddlLoaiTimkiem.SelectedValue),
        //        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
        //         };
        //        DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DASHBOARD.DASHBOARD_M2_STPT", parameters);

        //        if (tbl != null)
        //        {
        //            rptToaan_STPT_M2.DataSource = tbl;
        //            rptToaan_STPT_M2.DataBind();
        //        }
        //        else
        //        {
        //            rptToaan_STPT_M2.DataSource = null;
        //            rptToaan_STPT_M2.DataBind();
        //        }
        //        SetActiveTab("ViewTAND");
        //    }
        //    catch (Exception ex)
        //    {
        //        string errorMessage = ex.ToString();

        //        // Gửi thông tin lỗi vào console của trình duyệt
        //        string script = $"console.error('{errorMessage}');";
        //        ScriptManager.RegisterStartupScript(this, this.GetType(), "LogError", script, true);
        //    }
        //}

        //protected void btnXemBC_STPT_M2_Click(object sender, EventArgs e)
        //{
        //    string fileName = "report.docx";

        //    set_thoigian(ddl_Load_Thoigian_STPT_M2);
        //    set_thoigianBefore_STPT_M2(ddl_Load_Thoigian_STPT_M2);

        //    string tungay = startDate.ToString("dd/MM/yyyy", cul);
        //    string denngay = endDate.ToString("dd/MM/yyyy", cul);
        //    string tungay_truoc = startDateBefore.ToString("dd/MM/yyyy", cul);
        //    string denngay_truoc = endDateBefore.ToString("dd/MM/yyyy", cul);

        //    // Gọi lại database để lấy dữ liệu
        //    DataTable dta = GetReportData();

        //    if (dta != null && dta.Rows.Count > 0)
        //    {
        //        // Xuất file Word từ DataTable
        //        ExportToWord(dta);
        //    }

        //    using (MemoryStream memStream = new MemoryStream())
        //    {
        //        using (WordprocessingDocument wordDoc = WordprocessingDocument.Create(memStream, WordprocessingDocumentType.Document, true))
        //        {
        //            MainDocumentPart mainPart = wordDoc.AddMainDocumentPart();
        //            mainPart.Document = new DocumentFormat.OpenXml.Wordprocessing.Document();
        //            DocumentFormat.OpenXml.Wordprocessing.Body body = mainPart.Document.AppendChild(new DocumentFormat.OpenXml.Wordprocessing.Body());

        //            // Đặt lề trang (trái: 2cm, phải: 3cm, trên: 2cm, dưới: 2cm)
        //            SectionProperties sectionProps = new SectionProperties();
        //            PageMargin pageMargins = new PageMargin()
        //            {
        //                Top = (int)(2.0 * 567),    // 2 cm
        //                Bottom = (int)(2.0 * 567), // 2 cm
        //                Left = (int)(2.0 * 567),   // 2 cm
        //                Right = (int)(3.0 * 567)   // 3 cm
        //            };
        //            sectionProps.Append(pageMargins);
        //            body.Append(sectionProps);

        //            // Tiêu đề
        //            body.Append(CreateParagraph(lstTenBangtimkiem.Text, true, 14, JustificationValues.Center));
        //            body.Append(CreateParagraph("Từ ngày " + tungay + " đến ngày " + denngay, false, 14, JustificationValues.Center));
        //            body.Append(CreateParagraph("", false, 28, JustificationValues.Left));

        //            // Bảng dữ liệu
        //            DocumentFormat.OpenXml.Wordprocessing.Table table = CreateTableFromDataTable(dta);
        //            body.Append(table);

        //            mainPart.Document.Save();
        //        }

        //        // Xuất file về trình duyệt
        //        byte[] fileBytes = memStream.ToArray();
        //        Response.Clear();
        //        Response.ContentType = "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
        //        Response.AddHeader("Content-Disposition", "attachment; filename=" + fileName);
        //        Response.BinaryWrite(fileBytes);
        //        Response.End();
        //    }
        //}
        //private DataTable GetReportData()
        //{
        //    set_thoigian(ddl_Load_Thoigian_STPT_M2);
        //    set_thoigianBefore_STPT_M2(ddl_Load_Thoigian_STPT_M2);

        //    string tungay = startDate.ToString("dd/MM/yyyy", cul);
        //    string denngay = endDate.ToString("dd/MM/yyyy", cul);
        //    string tungay_truoc = startDateBefore.ToString("dd/MM/yyyy", cul);
        //    string denngay_truoc = endDateBefore.ToString("dd/MM/yyyy", cul);

        //    OracleParameter[] parameters = new OracleParameter[] {
        //        new OracleParameter("vToaAnID",Convert.ToDecimal(DropToaAn.SelectedValue)),
        //        new OracleParameter("vTuNgay",tungay),
        //        new OracleParameter("vDenNgay",denngay),
        //        new OracleParameter("vTuNgayTruoc",tungay_truoc),
        //        new OracleParameter("vDenNgayTruoc",denngay_truoc),
        //        new OracleParameter("vColumn",ddlLoaiTimkiem.SelectedValue),
        //        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
        //         };

        //    // Gọi stored procedure và trả về DataTable
        //    DataTable dt = Cls_Comon.GetTableByProcedurePaging("PKG_DASHBOARD.DASHBOARD_M2_STPT", parameters);

        //    // Tạo DataTable mới với đúng 5 cột yêu cầu
        //    DataTable newDt = new DataTable();
        //    newDt.Columns.Add("STT", typeof(string));
        //    newDt.Columns.Add("Tên đơn vị", typeof(string));
        //    newDt.Columns.Add("Tổng số vụ án thụ lý", typeof(string));
        //    newDt.Columns.Add("Tổng số giải quyết", typeof(string));
        //    newDt.Columns.Add("Tỷ lệ giải quyết", typeof(string));
        //    newDt.Columns.Add("Tỷ lệ giải quyết so với cùng kỳ", typeof(string));
        //    int stt = 1;
        //    foreach (DataRow row in dt.Rows)
        //    {
        //        string tangGiam = row["TANGGIAM"].ToString();      // "Tăng"/"Giảm"
        //        string tyleTangGiam = row["TYLE_TANGGIAM"].ToString(); // Tỷ lệ tăng/giảm
        //        string tyleKyTruoc = row["TYLE_KYTRUOC"].ToString();   // Tỷ lệ kỳ trước

        //        // Gộp thành 1 chuỗi cho cột cuối cùng
        //        string tileGiaiQuyetSoSanh = $"{tangGiam}: {tyleTangGiam} \n(Kỳ trước: {tyleKyTruoc})";

        //        newDt.Rows.Add(
        //            stt.ToString(),
        //            row["TEN"],
        //            row["COLUMN_1"],
        //            row["COLUMN_2"],
        //            row["COLUMN_3"],
        //            tileGiaiQuyetSoSanh
        //        );
        //        stt++;
        //    }
            
        //    return newDt; // Trả về bảng chỉ chứa cột cần thiết
        //}
        //private void ExportToWord(DataTable dt)
        //{
        //    using (MemoryStream stream = new MemoryStream())
        //    {
        //        using (WordprocessingDocument doc = WordprocessingDocument.Create(stream, WordprocessingDocumentType.Document, true))
        //        {
        //            MainDocumentPart mainPart = doc.AddMainDocumentPart();
        //            mainPart.Document = new DocumentFormat.OpenXml.Wordprocessing.Document();
        //            DocumentFormat.OpenXml.Wordprocessing.Body body = mainPart.Document.AppendChild(new DocumentFormat.OpenXml.Wordprocessing.Body());

        //            // Định dạng tiêu đề
        //            DocumentFormat.OpenXml.Wordprocessing.Paragraph title = new DocumentFormat.OpenXml.Wordprocessing.Paragraph(
        //                new DocumentFormat.OpenXml.Wordprocessing.Run(new Text(lstTenBangtimkiem.Text.ToUpper()))
        //            );
        //            title.ParagraphProperties = new ParagraphProperties(
        //                new Justification() { Val = JustificationValues.Center },
        //                new SpacingBetweenLines() { After = "0", LineRule = LineSpacingRuleValues.Auto, Line = "240" } // Single spacing
        //            );
        //            RunProperties titleFont = new RunProperties(
        //                new RunFonts() { Ascii = "Times New Roman", HighAnsi = "Times New Roman" },
        //                new DocumentFormat.OpenXml.Wordprocessing.FontSize() { Val = "28" } // 14px
        //            );
        //            title.GetFirstChild<DocumentFormat.OpenXml.Wordprocessing.Run>().PrependChild(titleFont);
        //            body.AppendChild(title);

        //            // Thêm dòng "Từ ngày đến ngày"
        //            string tungay = startDate.ToString("dd/MM/yyyy", cul);
        //            string denngay = endDate.ToString("dd/MM/yyyy", cul);
        //            DocumentFormat.OpenXml.Wordprocessing.Paragraph dateRangeParagraph = new DocumentFormat.OpenXml.Wordprocessing.Paragraph(
        //                new DocumentFormat.OpenXml.Wordprocessing.Run(new Text("Từ ngày " + tungay + " đến ngày " + denngay))
        //            );
        //            dateRangeParagraph.ParagraphProperties = new ParagraphProperties(
        //                new Justification() { Val = JustificationValues.Center },
        //                new SpacingBetweenLines() { After = "0", LineRule = LineSpacingRuleValues.Auto, Line = "240" } // Single spacing
        //            );

        //            // Định dạng font chữ và kích thước cho dòng "Từ ngày đến ngày"
        //            RunProperties dateRangeFont = new RunProperties(
        //                new RunFonts() { Ascii = "Times New Roman", HighAnsi = "Times New Roman" },
        //                new DocumentFormat.OpenXml.Wordprocessing.FontSize() { Val = "28" } // 14px
        //            );
        //            dateRangeParagraph.GetFirstChild<DocumentFormat.OpenXml.Wordprocessing.Run>().PrependChild(dateRangeFont);
        //            body.AppendChild(dateRangeParagraph);

        //            // Cách dòng
        //            body.AppendChild(new DocumentFormat.OpenXml.Wordprocessing.Paragraph(new DocumentFormat.OpenXml.Wordprocessing.Run(new Text(""))));

        //            // Định dạng bảng với viền
        //            DocumentFormat.OpenXml.Wordprocessing.Table table = CreateTableFromDataTable(dt);
        //            body.AppendChild(table);
        //        }

        //        // Trả file về trình duyệt
        //        Response.Clear();
        //        Response.ContentType = "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
        //        Response.AddHeader("Content-Disposition", "attachment; filename=report.docx");
        //        Response.BinaryWrite(stream.ToArray());
        //        Response.End();
        //    }
        //}
        //private DocumentFormat.OpenXml.Wordprocessing.Paragraph CreateParagraph(string text, bool isBold, int fontSize, JustificationValues alignment)
        //{
        //    DocumentFormat.OpenXml.Wordprocessing.Run run = new DocumentFormat.OpenXml.Wordprocessing.Run(new Text(text));

        //    RunProperties runProperties = new RunProperties(
        //        new RunFonts() { Ascii = "Times New Roman", HighAnsi = "Times New Roman" }, // Đặt font
        //        new DocumentFormat.OpenXml.Wordprocessing.FontSize() { Val = (fontSize * 2).ToString() } // Kích thước half-points
        //    );

        //    if (isBold) runProperties.Append(new Bold());
        //    run.PrependChild(runProperties);

        //    DocumentFormat.OpenXml.Wordprocessing.Paragraph paragraph = new DocumentFormat.OpenXml.Wordprocessing.Paragraph(run);
        //    paragraph.PrependChild(new ParagraphProperties(new Justification() { Val = alignment }));

        //    return paragraph;
        //}
        //private DocumentFormat.OpenXml.Wordprocessing.Table CreateTableFromDataTable(DataTable dt)
        //{
        //    DocumentFormat.OpenXml.Wordprocessing.Table table = new DocumentFormat.OpenXml.Wordprocessing.Table();

        //    // Định nghĩa viền của bảng (Size = 1)
        //    TableProperties props = new TableProperties(new TableBorders(
        //        new TopBorder() { Val = BorderValues.Single, Size = 1 },    // Viền trên
        //        new BottomBorder() { Val = BorderValues.Single, Size = 1 }, // Viền dưới
        //        new LeftBorder() { Val = BorderValues.Single, Size = 1 },   // Viền trái
        //        new RightBorder() { Val = BorderValues.Single, Size = 1 },  // Viền phải
        //        new InsideHorizontalBorder() { Val = BorderValues.Single, Size = 1 },  // Viền ngang
        //        new InsideVerticalBorder() { Val = BorderValues.Single, Size = 1 }    // Viền dọc
        //    ));
        //    table.AppendChild(props);

        //    // **Tạo tiêu đề bảng (Căn giữa và in đậm)**
        //    DocumentFormat.OpenXml.Wordprocessing.TableRow headerRow = new DocumentFormat.OpenXml.Wordprocessing.TableRow();
        //    string[] columnNames = { "STT", "Tên đơn vị", "Tổng số vụ án thụ lý", "Tổng số giải quyết", "Tỷ lệ giải quyết", "Tỷ lệ giải quyết so với cùng kỳ" };

        //    foreach (string colName in columnNames)
        //    {
        //        DocumentFormat.OpenXml.Wordprocessing.TableCell cell = new DocumentFormat.OpenXml.Wordprocessing.TableCell();
        //        DocumentFormat.OpenXml.Wordprocessing.Paragraph para = new DocumentFormat.OpenXml.Wordprocessing.Paragraph(new DocumentFormat.OpenXml.Wordprocessing.Run(
        //            new RunProperties(
        //                new RunFonts() { Ascii = "Times New Roman", HighAnsi = "Times New Roman" },
        //                new DocumentFormat.OpenXml.Wordprocessing.FontSize() { Val = "22" }, // Font size 11px
        //                new Bold() // In đậm tiêu đề
        //            ),
        //            new Text(colName)
        //        ));

        //        // Định dạng khoảng cách và căn giữa nội dung
        //        para.ParagraphProperties = new ParagraphProperties(
        //            new Justification() { Val = JustificationValues.Center },
        //            new SpacingBetweenLines() { Before = "120", After = "120", Line = "240", LineRule = LineSpacingRuleValues.Auto } // 6px trước & sau, line spacing single
        //        );

        //        cell.Append(para);
        //        headerRow.Append(cell);
        //    }

        //    // Chèn thêm đoạn này để lặp lại tiêu đề
        //    TableRowProperties trProps = new TableRowProperties(new TableHeader());
        //    headerRow.AppendChild(trProps);

        //    table.Append(headerRow);

        //    // **Dữ liệu bảng**
        //    foreach (DataRow row in dt.Rows)
        //    {
        //        DocumentFormat.OpenXml.Wordprocessing.TableRow tableRow = new DocumentFormat.OpenXml.Wordprocessing.TableRow();

        //        // Không cho phép ngắt dòng giữa trang
        //        TableRowProperties rowProps = new TableRowProperties(new CantSplit());
        //        tableRow.AppendChild(rowProps);

        //        for (int i = 0; i < dt.Columns.Count; i++)
        //        {
        //            DocumentFormat.OpenXml.Wordprocessing.TableCell cell = new DocumentFormat.OpenXml.Wordprocessing.TableCell();

        //            // Tạo nội dung
        //            DocumentFormat.OpenXml.Wordprocessing.Paragraph para = new DocumentFormat.OpenXml.Wordprocessing.Paragraph(
        //                new DocumentFormat.OpenXml.Wordprocessing.Run(
        //                    new RunProperties(
        //                        new RunFonts() { Ascii = "Times New Roman", HighAnsi = "Times New Roman" },
        //                        new DocumentFormat.OpenXml.Wordprocessing.FontSize() { Val = "22" } // Font size 11px
        //                    ),
        //                    new Text(row[i].ToString()) { Space = SpaceProcessingModeValues.Preserve } // preserve space
        //                )
        //            );

        //            // 👉 Căn trái nếu là cột "Tên đơn vị" (cột số 1)
        //            JustificationValues alignment = (i == 1) ? JustificationValues.Left : JustificationValues.Center;

        //            para.ParagraphProperties = new ParagraphProperties(
        //                new Justification() { Val = alignment },
        //                new SpacingBetweenLines() { Before = "120", After = "120", Line = "240", LineRule = LineSpacingRuleValues.Auto },
        //                new Indentation() { Left = "57", Right = "57" } // 0.1 cm = ~57 twips
        //            );

        //            // Căn giữa chiều dọc
        //            TableCellProperties cellProps = new TableCellProperties();
        //            cellProps.Append(new TableCellVerticalAlignment() { Val = TableVerticalAlignmentValues.Center });

        //            cell.Append(cellProps);
        //            cell.Append(para);
        //            tableRow.Append(cell);
        //        }
        //        table.Append(tableRow);
        //    }

        //    return table;
        //}        
        //#endregion

        #region pn_TPTATC_M1
        protected void btnXemBC_TPTATCM1_Click(object sender, EventArgs e)
        {
            string strCanBoID = ddlThamphan.SelectedValue;

            decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

            Literal Table_Str_Totals = new Literal();

            set_thoigian(ddl_Load_Thoigian);
            string tungay = startDate.ToString("dd/MM/yyyy", cul);
            string denngay = endDate.ToString("dd/MM/yyyy", cul);

            string canboid = Session[ENUM_SESSION.SESSION_CANBOID] + "";

            decimal vThamphanID = 0;
            vThamphanID = Convert.ToDecimal(strCanBoID);


            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.ReturnValue ),
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vThamphanID",vThamphanID),
                new OracleParameter("vTuNgay",startDate),
                new OracleParameter("vDenNgay",endDate)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging_baocao("PKG_DASHBOARD_BAOCAO.DASHBOARD_M1_TPTATC_BAOCAO", parameters);


            DataRow row = tbl.NewRow();



            if (tbl != null && tbl.Rows.Count > 0)
            {
                row = tbl.Rows[0];
                Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
            }

            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=Thong_Ke_BC_TP.doc"); Response.Cache.SetCacheability(HttpCacheability.NoCache);
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
            Response.Write("<!-- /* Style Definitions */" +
                                          "p.MsoFooter, li.MsoFooter, div.MsoFooter" +
                                          "{margin:0in;" +
                                          "margin-bottom:.0001pt;" +
                                          "mso-pagination:widow-orphan;" +
                                          "tab-stops:center 3.0in right 6.0in;" +
                                          "font-size:12.0pt;}");
            Response.Write("@page Section1 {size:595.45pt 841.7pt; margin:0.78740196228in 0.78740196228in 0.78740196228in 1.181in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;mso-footer: f1;}");
            Response.Write("div.Section1 {page:Section1;}");
            //Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5905511811in 0.2992125984in 0.5905511811in 0.5984251969in;mso-header: h1;mso-header-margin:.2in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
            //Response.Write("@page Section2 { size: 841.7pt 595.45pt;  margin: 0.787in 1.181in 0.787in 0.787in; mso - header: h1; mso - header - margin: .2in; mso - footer - margin: .3in;mso - paper - source: 0; mso - footer: f1;}");
            Response.Write("@page Section2 {size: 841.7pt 595.45pt; margin: 1.181in 0.787in 0.787in 0.787in; mso - header: h1;mso - header - margin: .2in;mso - footer - margin: .3in;mso - paper - source: 0;mso - footer: f1;}");
            Response.Write("div.Section2 {page:Section2;}");
            Response.Write("<style>");
            Response.Write("</head>");
            Response.Write("<body>");
            Response.Write("<div class=Section2>");//chỉ định khổ giấy
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
        protected void ddl_Load_Thoigian_TPTATCM1_SelectedIndexChanged(object sender, EventArgs e)
        {
            Load_DataTPTATCM1();
            SetActiveTab("ViewTPTATC");
        }
        protected void rptTPTATCM1_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            set_thoigian(ddl_Load_Thoigian_TPTATCM1);

            string tungay = startDate.ToString("dd/MM/yyyy", cul);
            string denngay = endDate.ToString("dd/MM/yyyy", cul);

            Session[SS_BAOCAO_CA.TUNGAY] = tungay;
            Session[SS_BAOCAO_CA.DENNGAY] = denngay;
            Session[SS_BAOCAO_CA.VALUE_TAB] = "ViewTPTATC";
            Session[SS_BAOCAO_CA.VALUE_TIME] = ddl_Load_Thoigian_TPTATCM1.SelectedValue;
            Session[SS_BAOCAO_CA.THAMPHAN] = e.CommandArgument.ToString();

            string strTrangThai = e.CommandName;
            switch (strTrangThai)
            {
                //Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "X"; //Số này theo màn mức 1 tab TATC

                case "COLUMN_1":
                    // GIẢI QUYẾT ĐƠN - Tổng số đơn	
                    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "2";
                    Response.Redirect(redirect_Giaiquyetdon);
                    break;
                case "COLUMN_2":
                    // GIẢI QUYẾT ĐƠN - Đã giải quyết xong - Tổng số
                    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "3";
                    Response.Redirect(redirect_Giaiquyetdon);
                    break;
                case "COLUMN_3":
                    // GIẢI QUYẾT ĐƠN - Chưa giải quyết xong
                    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "7";
                    Response.Redirect(redirect_Giaiquyetdon);
                    break;
                case "COLUMN_4":
                    //XÉT XỬ GIÁM ĐỐC THẨM, TÁI THẨM - Tổng số vụ án
                    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "8";
                    Response.Redirect(redirect_Xxgdttt);
                    break;
                case "COLUMN_5":
                    // XÉT XỬ GIÁM ĐỐC THẨM, TÁI THẨM - Đã xét xử
                    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "11";
                    Response.Redirect(redirect_Xxgdttt);
                    break;
                case "COLUMN_6":
                    // XÉT XỬ GIÁM ĐỐC THẨM, TÁI THẨM - Chưa xét xử
                    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "12";
                    Response.Redirect(redirect_Xxgdttt);
                    break;
            }
        }
        protected void rptTPTATCM1_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                // Lấy dữ liệu từ DataRowView
                DataRowView row = (DataRowView)e.Item.DataItem;
                
                // Lặp qua các cột từ COLUMN_1 đến COLUMN_11
                for (int i = 1; i <= 6; i++)
                {
                    string columnName = "COLUMN_" + i;

                    // Kiểm tra dữ liệu trong cột
                    if (row[columnName] != DBNull.Value)
                    {
                        decimal value = Convert.ToDecimal(row[columnName]);

                        // Tìm LinkButton trong dòng hiện tại và gán giá trị
                        LinkButton linkButton = (LinkButton)e.Item.FindControl("LinkButton" + (i) + "_TPTATCM1");

                        if (linkButton != null)
                        {
                            linkButton.Text = FormatNumberWithDot(value);
                        }
                    }
                }

                // Tính tỷ lệ GQD: COLUMN_3 / (COLUMN_1 + COLUMN_2)
                decimal col1 = Convert.ToDecimal(row["COLUMN_1"]);
                decimal col2 = Convert.ToDecimal(row["COLUMN_2"]);
                decimal col3 = Convert.ToDecimal(row["COLUMN_3"]);

                decimal tyleGQD = (col1 + col2) != 0 ? col3 / (col1 + col2) : 0;

                LinkButton linkTyleGQD = (LinkButton)e.Item.FindControl("LinkTyleGQD_TPTATCM1");
                if (linkTyleGQD != null)
                {
                    linkTyleGQD.Text = tyleGQD.ToString("P2"); // Hiển thị dạng phần trăm, ví dụ 34.56%
                }

                // Tính tỷ lệ XXGQT: COLUMN_6 / COLUMN_5
                decimal col5 = Convert.ToDecimal(row["COLUMN_5"]);
                decimal col6 = Convert.ToDecimal(row["COLUMN_6"]);

                decimal tyleXXGQT = col6 != 0 ? col6 / col5 : 0;

                LinkButton linkTyleXXGQT = (LinkButton)e.Item.FindControl("LinkTyleXXGQT_TPTATCM1");
                if (linkTyleXXGQT != null)
                {
                    linkTyleXXGQT.Text = tyleXXGQT.ToString("P2");
                }
            }
        }
        public void Load_DataTPTATCM1()
        {
            try
            {
                set_thoigian(ddl_Load_Thoigian_TPTATCM1);

                string tungay = startDate.ToString("dd/MM/yyyy", cul);
                string denngay = endDate.ToString("dd/MM/yyyy", cul);

                OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vToaAnID","1"),
                new OracleParameter("vThamphanid", "0"),
                new OracleParameter("vTuNgay",tungay),
                new OracleParameter("vDenNgay",denngay),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                 };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging_baocao("PKG_DASHBOARD_UPDATE_V2.DASHBOARD_M1_TPTATC", parameters);

                if (tbl != null)
                {
                    rptTPTATCM1.DataSource = tbl;
                    rptTPTATCM1.DataBind();
                }
                else
                {
                    rptTPTATCM1.DataSource = null;
                    rptTPTATCM1.DataBind();
                }
                SetActiveTab("ViewTPTATC");
            }
            catch (Exception ex)
            {
                string errorMessage = ex.ToString();

                // Gửi thông tin lỗi vào console của trình duyệt
                string script = $"console.error('{errorMessage}');";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "LogError", script, true);
            }
        }
        #endregion
        
        #region pn_PCA_M1
        protected void btnXemBC_PCAM1_Click(object sender, EventArgs e)
        {
            string strCanBoID = ddlThamphan.SelectedValue;

            decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

            Literal Table_Str_Totals = new Literal();

            set_thoigian(ddl_Load_Thoigian);
            string tungay = startDate.ToString("dd/MM/yyyy", cul);
            string denngay = endDate.ToString("dd/MM/yyyy", cul);

            string canboid = Session[ENUM_SESSION.SESSION_CANBOID] + "";

            decimal vThamphanID = 0;
            vThamphanID = Convert.ToDecimal(strCanBoID);


            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.ReturnValue ),
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vThamphanID",vThamphanID),
                new OracleParameter("vTuNgay",startDate),
                new OracleParameter("vDenNgay",endDate)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging_baocao("PKG_DASHBOARD_BAOCAO.DASHBOARD_M1_PCA_BAOCAO", parameters);


            DataRow row = tbl.NewRow();



            if (tbl != null && tbl.Rows.Count > 0)
            {
                row = tbl.Rows[0];
                Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
            }

            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=Thong_Ke_BC_TP.doc"); Response.Cache.SetCacheability(HttpCacheability.NoCache);
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
            Response.Write("<!-- /* Style Definitions */" +
                                          "p.MsoFooter, li.MsoFooter, div.MsoFooter" +
                                          "{margin:0in;" +
                                          "margin-bottom:.0001pt;" +
                                          "mso-pagination:widow-orphan;" +
                                          "tab-stops:center 3.0in right 6.0in;" +
                                          "font-size:12.0pt;}");
            Response.Write("@page Section1 {size:595.45pt 841.7pt; margin:0.78740196228in 0.78740196228in 0.78740196228in 1.181in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;mso-footer: f1;}");
            Response.Write("div.Section1 {page:Section1;}");
            //Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5905511811in 0.2992125984in 0.5905511811in 0.5984251969in;mso-header: h1;mso-header-margin:.2in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
            //Response.Write("@page Section2 { size: 841.7pt 595.45pt;  margin: 0.787in 1.181in 0.787in 0.787in; mso - header: h1; mso - header - margin: .2in; mso - footer - margin: .3in;mso - paper - source: 0; mso - footer: f1;}");
            Response.Write("@page Section2 {size: 841.7pt 595.45pt; margin: 1.181in 0.787in 0.787in 0.787in; mso - header: h1;mso - header - margin: .2in;mso - footer - margin: .3in;mso - paper - source: 0;mso - footer: f1;}");
            Response.Write("div.Section2 {page:Section2;}");
            Response.Write("<style>");
            Response.Write("</head>");
            Response.Write("<body>");
            Response.Write("<div class=Section2>");//chỉ định khổ giấy
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
        protected void ddl_Load_Thoigian_PCAM1_SelectedIndexChanged(object sender, EventArgs e)
        {
            Load_DataPCAM1();
            SetActiveTab("ViewPCA");
        }
        protected void rptPCAM1_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            set_thoigian(ddl_Load_Thoigian_PCAM1);

            string tungay = startDate.ToString("dd/MM/yyyy", cul);
            string denngay = endDate.ToString("dd/MM/yyyy", cul);

            Session[SS_BAOCAO_CA.TUNGAY] = tungay;
            Session[SS_BAOCAO_CA.DENNGAY] = denngay;
            Session[SS_BAOCAO_CA.VALUE_TAB] = "ViewPCA";
            Session[SS_BAOCAO_CA.VALUE_TIME] = ddl_Load_Thoigian_PCAM1.SelectedValue;
            Session[SS_BAOCAO_CA.THAMPHAN] = e.CommandArgument.ToString();

            string strTrangThai = e.CommandName;
            //switch (strTrangThai)
            //{
                //Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "X"; //Số này theo màn mức 1 tab TATC

                //case "COLUMN_1":
                //    // GIẢI QUYẾT ĐƠN - Tổng số đơn	
                //    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "2";
                //    Response.Redirect(redirect_Giaiquyetdon);
                //    break;
                //case "COLUMN_2":
                //    // GIẢI QUYẾT ĐƠN - Đã giải quyết xong - Tổng số
                //    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "3";
                //    Response.Redirect(redirect_Giaiquyetdon);
                //    break;
                //case "COLUMN_3":
                //    // GIẢI QUYẾT ĐƠN - Chưa giải quyết xong
                //    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "7";
                //    Response.Redirect(redirect_Giaiquyetdon);
                //    break;
                //case "COLUMN_4":
                //    //XÉT XỬ GIÁM ĐỐC THẨM, TÁI THẨM - Tổng số vụ án
                //    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "8";
                //    Response.Redirect(redirect_Xxgdttt);
                //    break;
                //case "COLUMN_5":
                //    // XÉT XỬ GIÁM ĐỐC THẨM, TÁI THẨM - Đã xét xử
                //    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "11";
                //    Response.Redirect(redirect_Xxgdttt);
                //    break;
                //case "COLUMN_6":
                //    // XÉT XỬ GIÁM ĐỐC THẨM, TÁI THẨM - Chưa xét xử
                //    Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "12";
                //    Response.Redirect(redirect_Xxgdttt);
                //    break;
            //}
        }
        protected void rptPCAM1_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                // Lấy dữ liệu từ DataRowView
                DataRowView row = (DataRowView)e.Item.DataItem;

                // Lặp qua các cột từ COLUMN_1 đến COLUMN_11
                for (int i = 1; i <= 10; i++)
                {
                    string columnName = "COLUMN_" + i;

                    // Kiểm tra dữ liệu trong cột
                    if (row[columnName] != DBNull.Value)
                    {
                        decimal value = Convert.ToDecimal(row[columnName]);

                        // Tìm LinkButton trong dòng hiện tại và gán giá trị
                        LinkButton linkButton = (LinkButton)e.Item.FindControl("LinkButton" + (i) + "_PCAM1");

                        if (linkButton != null)
                        {
                            linkButton.Text = FormatNumberWithDot(value);
                        }
                    }
                }
            }
        }
        public void Load_DataPCAM1()
        {
            try
            {
                set_thoigian(ddl_Load_Thoigian_PCAM1);

                string tungay = startDate.ToString("dd/MM/yyyy", cul);
                string denngay = endDate.ToString("dd/MM/yyyy", cul);

                OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vToaAnID","1"),
                new OracleParameter("vThamphanid", "0"),
                new OracleParameter("vTuNgay",tungay),
                new OracleParameter("vDenNgay",denngay),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                 };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging_baocao("PKG_DASHBOARD_UPDATE_V2.DASHBOARD_M1_PCA", parameters);

                if (tbl != null)
                {
                    rptPCAM1.DataSource = tbl;
                    rptPCAM1.DataBind();
                }
                else
                {
                    rptPCAM1.DataSource = null;
                    rptPCAM1.DataBind();
                }
                SetActiveTab("ViewPCA");
            }
            catch (Exception ex)
            {
                string errorMessage = ex.ToString();

                // Gửi thông tin lỗi vào console của trình duyệt
                string script = $"console.error('{errorMessage}');";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "LogError", script, true);
            }
        }
        #endregion
        
        #region pn_VUGDKT_M1
        protected void btnXemBC_VUGDKTM1_Click(object sender, EventArgs e)
        {
            string strCanBoID = ddlThamphan.SelectedValue;

            decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

            Literal Table_Str_Totals = new Literal();

            set_thoigian(ddl_Load_Thoigian);
            string tungay = startDate.ToString("dd/MM/yyyy", cul);
            string denngay = endDate.ToString("dd/MM/yyyy", cul);

            string canboid = Session[ENUM_SESSION.SESSION_CANBOID] + "";

            decimal vThamphanID = 0;
            vThamphanID = Convert.ToDecimal(strCanBoID);


            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.ReturnValue ),
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vThamphanID",vThamphanID),
                new OracleParameter("vTuNgay",startDate),
                new OracleParameter("vDenNgay",endDate)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging_baocao("PKG_DASHBOARD_BAOCAO.DASHBOARD_M1_VUGDKT_BAOCAO", parameters);


            DataRow row = tbl.NewRow();



            if (tbl != null && tbl.Rows.Count > 0)
            {
                row = tbl.Rows[0];
                Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
            }

            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=Thong_Ke_BC_TP.doc"); Response.Cache.SetCacheability(HttpCacheability.NoCache);
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
            Response.Write("<!-- /* Style Definitions */" +
                                          "p.MsoFooter, li.MsoFooter, div.MsoFooter" +
                                          "{margin:0in;" +
                                          "margin-bottom:.0001pt;" +
                                          "mso-pagination:widow-orphan;" +
                                          "tab-stops:center 3.0in right 6.0in;" +
                                          "font-size:12.0pt;}");
            Response.Write("@page Section1 {size:595.45pt 841.7pt; margin:0.78740196228in 0.78740196228in 0.78740196228in 1.181in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;mso-footer: f1;}");
            Response.Write("div.Section1 {page:Section1;}");
            //Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5905511811in 0.2992125984in 0.5905511811in 0.5984251969in;mso-header: h1;mso-header-margin:.2in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
            //Response.Write("@page Section2 { size: 841.7pt 595.45pt;  margin: 0.787in 1.181in 0.787in 0.787in; mso - header: h1; mso - header - margin: .2in; mso - footer - margin: .3in;mso - paper - source: 0; mso - footer: f1;}");
            Response.Write("@page Section2 {size: 841.7pt 595.45pt; margin: 1.181in 0.787in 0.787in 0.787in; mso - header: h1;mso - header - margin: .2in;mso - footer - margin: .3in;mso - paper - source: 0;mso - footer: f1;}");
            Response.Write("div.Section2 {page:Section2;}");
            Response.Write("<style>");
            Response.Write("</head>");
            Response.Write("<body>");
            Response.Write("<div class=Section2>");//chỉ định khổ giấy
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
        protected void ddl_Load_Thoigian_VUGDKTM1_SelectedIndexChanged(object sender, EventArgs e)
        {
            Load_DataVUGDKTM1();
            SetActiveTab("ViewVUGDKT");
        }
        protected void rptVUGDKTM1_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            set_thoigian(ddl_Load_Thoigian_VUGDKTM1);

            string tungay = startDate.ToString("dd/MM/yyyy", cul);
            string denngay = endDate.ToString("dd/MM/yyyy", cul);

            Session[SS_BAOCAO_CA.TUNGAY] = tungay;
            Session[SS_BAOCAO_CA.DENNGAY] = denngay;
            Session[SS_BAOCAO_CA.VALUE_TAB] = "ViewVUGDKT";
            Session[SS_BAOCAO_CA.VALUE_TIME] = ddl_Load_Thoigian_VUGDKTM1.SelectedValue;
            Session[SS_BAOCAO_CA.THAMPHAN] = e.CommandArgument.ToString();
        }
        protected void rptVUGDKTM1_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                // Lấy dữ liệu từ DataRowView
                DataRowView row = (DataRowView)e.Item.DataItem;

                // Lặp qua các cột từ COLUMN_1 đến COLUMN_11
                for (int i = 1; i <= 10; i++)
                {
                    string columnName = "COLUMN_" + i;

                    // Kiểm tra dữ liệu trong cột
                    if (row[columnName] != DBNull.Value)
                    {
                        decimal value = Convert.ToDecimal(row[columnName]);

                        // Tìm LinkButton trong dòng hiện tại và gán giá trị
                        LinkButton linkButton = (LinkButton)e.Item.FindControl("LinkButton" + (i) + "_VUGDKTM1");

                        if (linkButton != null)
                        {
                            linkButton.Text = FormatNumberWithDot(value);
                        }
                    }
                }
                
                // Tính tỷ lệ GQD: COLUMN_3 / (COLUMN_1 + COLUMN_2)
                decimal col1 = Convert.ToDecimal(row["COLUMN_1"]);
                decimal col2 = Convert.ToDecimal(row["COLUMN_2"]);
                decimal col3 = Convert.ToDecimal(row["COLUMN_3"]);

                decimal tyleGQD = (col1 + col2) != 0 ? col3 / (col1 + col2) : 0;

                LinkButton LinkTyleGQD_VUGDKTM1 = (LinkButton)e.Item.FindControl("LinkTyleGQD_VUGDKTM1");
                if (LinkTyleGQD_VUGDKTM1 != null)
                {
                    LinkTyleGQD_VUGDKTM1.Text = tyleGQD.ToString("P2"); // Hiển thị dạng phần trăm, ví dụ 34.56%
                }
            }
        }
        public void Load_DataVUGDKTM1()
        {
            try
            {
                set_thoigian(ddl_Load_Thoigian_VUGDKTM1);

                string tungay = startDate.ToString("dd/MM/yyyy", cul);
                string denngay = endDate.ToString("dd/MM/yyyy", cul);

                OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vToaAnID","1"),
                new OracleParameter("vThamphanid", "0"),
                new OracleParameter("vTuNgay",tungay),
                new OracleParameter("vDenNgay",denngay),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                 };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging_baocao("PKG_DASHBOARD_UPDATE_V2.DASHBOARD_M1_VUGDKT", parameters);

                if (tbl != null)
                {
                    rptVUGDKTM1.DataSource = tbl;
                    rptVUGDKTM1.DataBind();
                }
                else
                {
                    rptVUGDKTM1.DataSource = null;
                    rptVUGDKTM1.DataBind();
                }
                SetActiveTab("ViewVUGDKT");
            }
            catch (Exception ex)
            {
                string errorMessage = ex.ToString();

                // Gửi thông tin lỗi vào console của trình duyệt
                string script = $"console.error('{errorMessage}');";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "LogError", script, true);
            }
        }
        #endregion
        
        #region pn_STPT_M1

        public void LoadTK_Toaan_STPT()
        {
            try
            {
                set_thoigian(ddl_Load_Thoigian_STPT);
                set_thoigianBefore_STPT_M2(ddl_Load_Thoigian_STPT);

                string tungay = startDate.ToString("dd/MM/yyyy", cul);
                string denngay = endDate.ToString("dd/MM/yyyy", cul);
                string tungay_truoc = startDateBefore.ToString("dd/MM/yyyy", cul);
                string denngay_truoc = endDateBefore.ToString("dd/MM/yyyy", cul);

                OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vToaAnID","0"),
                new OracleParameter("vTuNgay",tungay),
                new OracleParameter("vDenNgay",denngay),
                new OracleParameter("vTuNgayTruoc",tungay_truoc),
                new OracleParameter("vDenNgayTruoc",denngay_truoc),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                 };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging_baocao("PKG_DASHBOARD.DASHBOARD_STPT_EXP", parameters);

                if (tbl != null)
                {
                    rptToaan_STPT.DataSource = tbl;
                    rptToaan_STPT.DataBind();
                }
                else
                {
                    rptToaan_STPT.DataSource = null;
                    rptToaan_STPT.DataBind();
                }

                SetActiveTab("ViewTAND");
            }
            catch (Exception ex)
            {
                string errorMessage = ex.ToString();

                // Gửi thông tin lỗi vào console của trình duyệt
                string script = $"console.error('{errorMessage}');";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "LogError", script, true);
            }
        }

        protected void rptToaan_STPT_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string strTrangThai = e.CommandName;
            switch (strTrangThai)
            {
                case "COLUMN_1":
                    ddlLoaiTimkiem.SelectedValue = "1";
                    break;
                case "COLUMN_2":
                    ddlLoaiTimkiem.SelectedValue = "2";
                    break;
                case "COLUMN_3":
                    ddlLoaiTimkiem.SelectedValue = "3";
                    break;
                case "COLUMN_4":
                    ddlLoaiTimkiem.SelectedValue = "4";
                    break;
                case "COLUMN_5":
                    ddlLoaiTimkiem.SelectedValue = "3";
                    break;
                case "COLUMN_6":
                    ddlLoaiTimkiem.SelectedValue = "3";
                    break;
            }

            ddl_Load_Thoigian_STPT_M2.SelectedValue = ddl_Load_Thoigian_STPT.SelectedValue;

            ViewTAND_M1.Visible = false;
            ViewTAND_M2.Visible = true;

            Load_Data();
        }
        protected void rptToaan_STPT_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView row = (DataRowView)e.Item.DataItem;

                string tangGiam = row["TANGGIAM"]?.ToString()?.Trim(); // Đã có nhờ fix SQL
                string tyle = row["TYLE_TANGGIAM"]?.ToString()?.Trim();
                string kyTruoc = row["TYLE_KYTRUOC"]?.ToString()?.Trim();

                tyle = string.IsNullOrEmpty(tyle) ? "0 %" : tyle;
                kyTruoc = string.IsNullOrEmpty(kyTruoc) ? "0 %" : kyTruoc;

                LinkButton lbtn = (LinkButton)e.Item.FindControl("LinkButton6_Toaan_STPT");
                if (lbtn != null)
                {
                    string color = "black";
                    if (tangGiam == "Tăng") color = "green";
                    else if (tangGiam == "Giảm") color = "red";

                    // Chia làm 2 span: một span có màu, một span không
                    lbtn.Text = $@"
                            <span style='font-size:14px; color:{color};'>{tangGiam}: {tyle}</span><br />
                            <span style='font-size:14px;'> <i>(Kỳ trước: {kyTruoc})</i></span>";
                }
            }
        }

        protected void ddl_Load_Thoigian_STPT_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadTK_Toaan_STPT();
        }

        #endregion

        #region pn_STPT_M2
        protected void rptToaan_STPT_M2_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView row = (DataRowView)e.Item.DataItem;

                string tangGiam = row["TANGGIAM"]?.ToString()?.Trim();
                string tyle = row["TYLE_TANGGIAM"]?.ToString()?.Trim();
                string kyTruoc = row["TYLE_KYTRUOC"]?.ToString()?.Trim();
                string loaiToa = row["LOAITOA"]?.ToString()?.Trim();
                string ten = row["TEN"]?.ToString()?.Trim();

                tyle = string.IsNullOrEmpty(tyle) ? "0 %" : tyle;
                kyTruoc = string.IsNullOrEmpty(kyTruoc) ? "0 %" : kyTruoc;

                // Xử lý lblCOLUMN_5 (Tăng/Giảm)
                Label lbtn = (Label)e.Item.FindControl("lblCOLUMN_5");
                if (lbtn != null)
                {
                    string color = "black";
                    if (tangGiam == "Tăng") color = "green";
                    else if (tangGiam == "Giảm") color = "red";

                    lbtn.Text = $@"
                <span style='font-size:12px; color:{color};'>{tangGiam}: {tyle}</span><br />
                <span style='font-size:12px;'> <i>(Kỳ trước: {kyTruoc})</i></span>";
                }

                // Nếu là cấp huyện thì cho TEN nghiêng
                Label lblTen = (Label)e.Item.FindControl("lblCOLUMN_1");
                if (lblTen != null)
                {
                    string style = "";
                    if (loaiToa == "CAPHUYEN")
                    {
                        lblTen.Font.Italic = true;
                        style = "font-size:12px;";
                    }
                    else
                    {
                        lblTen.Font.Italic = false;
                        style = "font-size:13px;";
                    }

                    lblTen.Text = $"<span style='{style}'>{ten}</span>";
                }
            }
        }
        protected void ddlLoaiTimkiem_SelectedIndexChanged(object sender, EventArgs e)
        {
            lstTenBangtimkiem.Text = ddlLoaiTimkiem.SelectedItem.ToString().ToUpper();
            Load_Data();
        }
        protected void DropToaAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            Load_Data();
        }

        protected void ddl_Load_Thoigian_STPT_M2_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddl_Load_Thoigian_STPT.SelectedValue = ddl_Load_Thoigian_STPT_M2.SelectedValue;
            Load_Data();
        }

        private void Load_Data()
        {
            try
            {
                lstTenBangtimkiem.Text = ddlLoaiTimkiem.SelectedItem.ToString().ToUpper();

                set_thoigian(ddl_Load_Thoigian_STPT_M2);
                set_thoigianBefore_STPT_M2(ddl_Load_Thoigian_STPT_M2);

                string tungay = startDate.ToString("dd/MM/yyyy", cul);
                string denngay = endDate.ToString("dd/MM/yyyy", cul);
                string tungay_truoc = startDateBefore.ToString("dd/MM/yyyy", cul);
                string denngay_truoc = endDateBefore.ToString("dd/MM/yyyy", cul);

                OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vToaAnID",Convert.ToDecimal(DropToaAn.SelectedValue)),
                new OracleParameter("vTuNgay",tungay),
                new OracleParameter("vDenNgay",denngay),
                new OracleParameter("vTuNgayTruoc",tungay_truoc),
                new OracleParameter("vDenNgayTruoc",denngay_truoc),
                new OracleParameter("vColumn",ddlLoaiTimkiem.SelectedValue),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                 };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging_baocao("PKG_DASHBOARD.DASHBOARD_M2_STPT", parameters);

                if (tbl != null)
                {
                    rptToaan_STPT_M2.DataSource = tbl;
                    rptToaan_STPT_M2.DataBind();
                }
                else
                {
                    rptToaan_STPT_M2.DataSource = null;
                    rptToaan_STPT_M2.DataBind();
                }
                SetActiveTab("ViewTAND");
            }
            catch (Exception ex)
            {
                string errorMessage = ex.ToString();

                // Gửi thông tin lỗi vào console của trình duyệt
                string script = $"console.error('{errorMessage}');";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "LogError", script, true);
            }
        }

        protected void btnXemBC_STPT_M2_Click(object sender, EventArgs e)
        {
            string fileName = "report.docx";

            set_thoigian(ddl_Load_Thoigian_STPT_M2);
            set_thoigianBefore_STPT_M2(ddl_Load_Thoigian_STPT_M2);

            string tungay = startDate.ToString("dd/MM/yyyy", cul);
            string denngay = endDate.ToString("dd/MM/yyyy", cul);
            string tungay_truoc = startDateBefore.ToString("dd/MM/yyyy", cul);
            string denngay_truoc = endDateBefore.ToString("dd/MM/yyyy", cul);

            // Gọi lại database để lấy dữ liệu
            DataTable dta = GetReportData();

            if (dta != null && dta.Rows.Count > 0)
            {
                // Xuất file Word từ DataTable
                ExportToWord(dta);
            }

            using (MemoryStream memStream = new MemoryStream())
            {
                using (WordprocessingDocument wordDoc = WordprocessingDocument.Create(memStream, WordprocessingDocumentType.Document, true))
                {
                    MainDocumentPart mainPart = wordDoc.AddMainDocumentPart();
                    mainPart.Document = new DocumentFormat.OpenXml.Wordprocessing.Document();
                    DocumentFormat.OpenXml.Wordprocessing.Body body = mainPart.Document.AppendChild(new DocumentFormat.OpenXml.Wordprocessing.Body());

                    // Đặt lề trang (trái: 2cm, phải: 3cm, trên: 2cm, dưới: 2cm)
                    SectionProperties sectionProps = new SectionProperties();
                    PageMargin pageMargins = new PageMargin()
                    {
                        Top = (int)(2.0 * 567),    // 2 cm
                        Bottom = (int)(2.0 * 567), // 2 cm
                        Left = (int)(2.0 * 567),   // 2 cm
                        Right = (int)(3.0 * 567)   // 3 cm
                    };
                    sectionProps.Append(pageMargins);
                    body.Append(sectionProps);

                    // Tiêu đề
                    body.Append(CreateParagraph(lstTenBangtimkiem.Text, true, 14, JustificationValues.Center));
                    body.Append(CreateParagraph("Từ ngày " + tungay + " đến ngày " + denngay, false, 14, JustificationValues.Center));
                    body.Append(CreateParagraph("", false, 28, JustificationValues.Left));

                    // Bảng dữ liệu
                    DocumentFormat.OpenXml.Wordprocessing.Table table = CreateTableFromDataTable(dta);
                    body.Append(table);

                    mainPart.Document.Save();
                }

                // Xuất file về trình duyệt
                byte[] fileBytes = memStream.ToArray();
                Response.Clear();
                Response.ContentType = "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
                Response.AddHeader("Content-Disposition", "attachment; filename=" + fileName);
                Response.BinaryWrite(fileBytes);
                Response.End();
            }
        }
        private DataTable GetReportData()
        {
            set_thoigian(ddl_Load_Thoigian_STPT_M2);
            set_thoigianBefore_STPT_M2(ddl_Load_Thoigian_STPT_M2);

            string tungay = startDate.ToString("dd/MM/yyyy", cul);
            string denngay = endDate.ToString("dd/MM/yyyy", cul);
            string tungay_truoc = startDateBefore.ToString("dd/MM/yyyy", cul);
            string denngay_truoc = endDateBefore.ToString("dd/MM/yyyy", cul);

            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vToaAnID",Convert.ToDecimal(DropToaAn.SelectedValue)),
                new OracleParameter("vTuNgay",tungay),
                new OracleParameter("vDenNgay",denngay),
                new OracleParameter("vTuNgayTruoc",tungay_truoc),
                new OracleParameter("vDenNgayTruoc",denngay_truoc),
                new OracleParameter("vColumn",ddlLoaiTimkiem.SelectedValue),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                 };

            // Gọi stored procedure và trả về DataTable
            DataTable dt = Cls_Comon.GetTableByProcedurePaging_baocao("PKG_DASHBOARD.DASHBOARD_M2_STPT", parameters);

            // Tạo DataTable mới với đúng 5 cột yêu cầu
            DataTable newDt = new DataTable();
            newDt.Columns.Add("STT", typeof(string));
            newDt.Columns.Add("Tên đơn vị", typeof(string));
            newDt.Columns.Add("Tổng số vụ án thụ lý", typeof(string));
            newDt.Columns.Add("Tổng số giải quyết", typeof(string));
            newDt.Columns.Add("Tỷ lệ giải quyết", typeof(string));
            newDt.Columns.Add("Tỷ lệ giải quyết so với cùng kỳ", typeof(string));
            int stt = 1;
            foreach (DataRow row in dt.Rows)
            {
                string tangGiam = row["TANGGIAM"].ToString();      // "Tăng"/"Giảm"
                string tyleTangGiam = row["TYLE_TANGGIAM"].ToString(); // Tỷ lệ tăng/giảm
                string tyleKyTruoc = row["TYLE_KYTRUOC"].ToString();   // Tỷ lệ kỳ trước

                // Gộp thành 1 chuỗi cho cột cuối cùng
                string tileGiaiQuyetSoSanh = $"{tangGiam}: {tyleTangGiam} \n(Kỳ trước: {tyleKyTruoc})";

                newDt.Rows.Add(
                    stt.ToString(),
                    row["TEN"],
                    row["COLUMN_1"],
                    row["COLUMN_2"],
                    row["COLUMN_3"],
                    tileGiaiQuyetSoSanh
                );
                stt++;
            }

            return newDt; // Trả về bảng chỉ chứa cột cần thiết
        }
        private void ExportToWord(DataTable dt)
        {
            using (MemoryStream stream = new MemoryStream())
            {
                using (WordprocessingDocument doc = WordprocessingDocument.Create(stream, WordprocessingDocumentType.Document, true))
                {
                    MainDocumentPart mainPart = doc.AddMainDocumentPart();
                    mainPart.Document = new DocumentFormat.OpenXml.Wordprocessing.Document();
                    DocumentFormat.OpenXml.Wordprocessing.Body body = mainPart.Document.AppendChild(new DocumentFormat.OpenXml.Wordprocessing.Body());

                    // Định dạng tiêu đề
                    DocumentFormat.OpenXml.Wordprocessing.Paragraph title = new DocumentFormat.OpenXml.Wordprocessing.Paragraph(
                        new DocumentFormat.OpenXml.Wordprocessing.Run(new Text(lstTenBangtimkiem.Text.ToUpper()))
                    );
                    title.ParagraphProperties = new ParagraphProperties(
                        new Justification() { Val = JustificationValues.Center },
                        new SpacingBetweenLines() { After = "0", LineRule = LineSpacingRuleValues.Auto, Line = "240" } // Single spacing
                    );
                    RunProperties titleFont = new RunProperties(
                        new RunFonts() { Ascii = "Times New Roman", HighAnsi = "Times New Roman" },
                        new DocumentFormat.OpenXml.Wordprocessing.FontSize() { Val = "28" } // 14px
                    );
                    title.GetFirstChild<DocumentFormat.OpenXml.Wordprocessing.Run>().PrependChild(titleFont);
                    body.AppendChild(title);

                    // Thêm dòng "Từ ngày đến ngày"
                    string tungay = startDate.ToString("dd/MM/yyyy", cul);
                    string denngay = endDate.ToString("dd/MM/yyyy", cul);
                    DocumentFormat.OpenXml.Wordprocessing.Paragraph dateRangeParagraph = new DocumentFormat.OpenXml.Wordprocessing.Paragraph(
                        new DocumentFormat.OpenXml.Wordprocessing.Run(new Text("Từ ngày " + tungay + " đến ngày " + denngay))
                    );
                    dateRangeParagraph.ParagraphProperties = new ParagraphProperties(
                        new Justification() { Val = JustificationValues.Center },
                        new SpacingBetweenLines() { After = "0", LineRule = LineSpacingRuleValues.Auto, Line = "240" } // Single spacing
                    );

                    // Định dạng font chữ và kích thước cho dòng "Từ ngày đến ngày"
                    RunProperties dateRangeFont = new RunProperties(
                        new RunFonts() { Ascii = "Times New Roman", HighAnsi = "Times New Roman" },
                        new DocumentFormat.OpenXml.Wordprocessing.FontSize() { Val = "28" } // 14px
                    );
                    dateRangeParagraph.GetFirstChild<DocumentFormat.OpenXml.Wordprocessing.Run>().PrependChild(dateRangeFont);
                    body.AppendChild(dateRangeParagraph);

                    // Cách dòng
                    body.AppendChild(new DocumentFormat.OpenXml.Wordprocessing.Paragraph(new DocumentFormat.OpenXml.Wordprocessing.Run(new Text(""))));

                    // Định dạng bảng với viền
                    DocumentFormat.OpenXml.Wordprocessing.Table table = CreateTableFromDataTable(dt);
                    body.AppendChild(table);
                }

                // Trả file về trình duyệt
                Response.Clear();
                Response.ContentType = "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
                Response.AddHeader("Content-Disposition", "attachment; filename=report.docx");
                Response.BinaryWrite(stream.ToArray());
                Response.End();
            }
        }
        private DocumentFormat.OpenXml.Wordprocessing.Paragraph CreateParagraph(string text, bool isBold, int fontSize, JustificationValues alignment)
        {
            DocumentFormat.OpenXml.Wordprocessing.Run run = new DocumentFormat.OpenXml.Wordprocessing.Run(new Text(text));

            RunProperties runProperties = new RunProperties(
                new RunFonts() { Ascii = "Times New Roman", HighAnsi = "Times New Roman" }, // Đặt font
                new DocumentFormat.OpenXml.Wordprocessing.FontSize() { Val = (fontSize * 2).ToString() } // Kích thước half-points
            );

            if (isBold) runProperties.Append(new Bold());
            run.PrependChild(runProperties);

            DocumentFormat.OpenXml.Wordprocessing.Paragraph paragraph = new DocumentFormat.OpenXml.Wordprocessing.Paragraph(run);
            paragraph.PrependChild(new ParagraphProperties(new Justification() { Val = alignment }));

            return paragraph;
        }
        private DocumentFormat.OpenXml.Wordprocessing.Table CreateTableFromDataTable(DataTable dt)
        {
            DocumentFormat.OpenXml.Wordprocessing.Table table = new DocumentFormat.OpenXml.Wordprocessing.Table();

            // Định nghĩa viền của bảng (Size = 1)
            TableProperties props = new TableProperties(new TableBorders(
                new TopBorder() { Val = BorderValues.Single, Size = 1 },    // Viền trên
                new BottomBorder() { Val = BorderValues.Single, Size = 1 }, // Viền dưới
                new LeftBorder() { Val = BorderValues.Single, Size = 1 },   // Viền trái
                new RightBorder() { Val = BorderValues.Single, Size = 1 },  // Viền phải
                new InsideHorizontalBorder() { Val = BorderValues.Single, Size = 1 },  // Viền ngang
                new InsideVerticalBorder() { Val = BorderValues.Single, Size = 1 }    // Viền dọc
            ));
            table.AppendChild(props);

            // **Tạo tiêu đề bảng (Căn giữa và in đậm)**
            DocumentFormat.OpenXml.Wordprocessing.TableRow headerRow = new DocumentFormat.OpenXml.Wordprocessing.TableRow();
            string[] columnNames = { "STT", "Tên đơn vị", "Tổng số vụ án thụ lý", "Tổng số giải quyết", "Tỷ lệ giải quyết", "Tỷ lệ giải quyết so với cùng kỳ" };

            foreach (string colName in columnNames)
            {
                DocumentFormat.OpenXml.Wordprocessing.TableCell cell = new DocumentFormat.OpenXml.Wordprocessing.TableCell();
                DocumentFormat.OpenXml.Wordprocessing.Paragraph para = new DocumentFormat.OpenXml.Wordprocessing.Paragraph(new DocumentFormat.OpenXml.Wordprocessing.Run(
                    new RunProperties(
                        new RunFonts() { Ascii = "Times New Roman", HighAnsi = "Times New Roman" },
                        new DocumentFormat.OpenXml.Wordprocessing.FontSize() { Val = "22" }, // Font size 11px
                        new Bold() // In đậm tiêu đề
                    ),
                    new Text(colName)
                ));

                // Định dạng khoảng cách và căn giữa nội dung
                para.ParagraphProperties = new ParagraphProperties(
                    new Justification() { Val = JustificationValues.Center },
                    new SpacingBetweenLines() { Before = "120", After = "120", Line = "240", LineRule = LineSpacingRuleValues.Auto } // 6px trước & sau, line spacing single
                );

                cell.Append(para);
                headerRow.Append(cell);
            }

            // Chèn thêm đoạn này để lặp lại tiêu đề
            TableRowProperties trProps = new TableRowProperties(new TableHeader());
            headerRow.AppendChild(trProps);

            table.Append(headerRow);

            // **Dữ liệu bảng**
            foreach (DataRow row in dt.Rows)
            {
                DocumentFormat.OpenXml.Wordprocessing.TableRow tableRow = new DocumentFormat.OpenXml.Wordprocessing.TableRow();

                // Không cho phép ngắt dòng giữa trang
                TableRowProperties rowProps = new TableRowProperties(new CantSplit());
                tableRow.AppendChild(rowProps);

                for (int i = 0; i < dt.Columns.Count; i++)
                {
                    DocumentFormat.OpenXml.Wordprocessing.TableCell cell = new DocumentFormat.OpenXml.Wordprocessing.TableCell();

                    // Tạo nội dung
                    DocumentFormat.OpenXml.Wordprocessing.Paragraph para = new DocumentFormat.OpenXml.Wordprocessing.Paragraph(
                        new DocumentFormat.OpenXml.Wordprocessing.Run(
                            new RunProperties(
                                new RunFonts() { Ascii = "Times New Roman", HighAnsi = "Times New Roman" },
                                new DocumentFormat.OpenXml.Wordprocessing.FontSize() { Val = "22" } // Font size 11px
                            ),
                            new Text(row[i].ToString()) { Space = SpaceProcessingModeValues.Preserve } // preserve space
                        )
                    );

                    // 👉 Căn trái nếu là cột "Tên đơn vị" (cột số 1)
                    JustificationValues alignment = (i == 1) ? JustificationValues.Left : JustificationValues.Center;

                    para.ParagraphProperties = new ParagraphProperties(
                        new Justification() { Val = alignment },
                        new SpacingBetweenLines() { Before = "120", After = "120", Line = "240", LineRule = LineSpacingRuleValues.Auto },
                        new Indentation() { Left = "57", Right = "57" } // 0.1 cm = ~57 twips
                    );

                    // Căn giữa chiều dọc
                    TableCellProperties cellProps = new TableCellProperties();
                    cellProps.Append(new TableCellVerticalAlignment() { Val = TableVerticalAlignmentValues.Center });

                    cell.Append(cellProps);
                    cell.Append(para);
                    tableRow.Append(cell);
                }
                table.Append(tableRow);
            }

            return table;
        }
        #endregion
    }

}