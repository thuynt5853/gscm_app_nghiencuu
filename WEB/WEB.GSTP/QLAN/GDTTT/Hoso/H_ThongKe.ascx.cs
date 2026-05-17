using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Module.Common;
using System.Globalization;
using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.Danhmuc;
using System.Data;
using BL.GSTP.GDTTT;
using BL.GSTP.BANGSETGET;
using System.Web.UI.HtmlControls;

namespace WEB.GSTP.QLAN.GDTTT.Hoso
{
    public partial class H_ThongKe : System.Web.UI.UserControl
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            string strMaCT = Session["MaChuongTrinh"] + "";//anhvh add 14/10/2020 chỉ cho hiện form login ghi nhấn vào trang chủ
            if (strMaCT != "0" && strMaCT != "")
            {
                return;
            }
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            scriptManager.RegisterPostBackControl(this.btnXemBC);
            //scriptManager.RegisterPostBackControl(this.btnXemBC_View);
            if (!IsPostBack)
            {
                DateTime start_date = DateTime.Today.AddMonths(0);//0 lấy tháng hiện tại;-1 lấy 1 tháng trở về trước tính từ ngày hiện tại
                string strDate = "01"+start_date.ToString("/MM/yyyy");
                txtNgaynhapTu.Text = strDate;
                //txtNgaynhapTu.Text = "01/12/" + Convert.ToString(DateTime.Now.Year-1);
                txtNgaynhapDen.Text = DateTime.Now.ToString("dd/MM/yyyy");
                //--------------
                decimal IDNhom = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_NHOMNSDID] + "");
                decimal ID_CHUONGTRINH = 44;//truyền mã menu chương trình hành chính tư pháp=44
                QT_MENU_BL qtBL = new QT_MENU_BL();
                DataTable lst_home = qtBL.Qt_Nhom_Home_Get_List(ID_CHUONGTRINH, IDNhom);
                if (Session["MA_HDSD"] + "" == "GDT" || Session["MA_HDSD"] + ""=="")
                {
                    if (lst_home != null && lst_home.Rows.Count > 0)
                    {
                        if (lst_home.Rows[0]["XEM"] + "" == "1")
                        {
                            pn.Visible = true;
                            pn_HCTP.Visible = true;
                            pn_HCTP_DAY.Visible = true;
                            LoadTKTrptHCTP();
                            LoadTKTrptHCTP_DAY();
                        }
                        else if (lst_home.Rows[0]["XEM"] + "" == "0")
                        {
                            pn.Visible = false;
                            pn_HCTP.Visible = false;
                            pn_HCTP_DAY.Visible = false;
                        }
                    }
                }
                else
                {
                    pn.Visible = false;
                    pn_HCTP.Visible = false;
                    pn_HCTP_DAY.Visible = false;
                }
            }
        }
        void ClearSession_TK()
        {
            Session[SS_TK.ISHOME] = "1";
            Session[SS_TK.SOBAQD] = "";
            Session[SS_TK.LOAIAN] = "";
            Session[SS_TK.NGAYNHANTU] = "";
            Session[SS_TK.NGAYNHANDEN] = "";
            Session[SS_TK.PHANLOAIDON] = "";
            Session[SS_TK.NGUOINHAP] = "";
            Session[SS_TK.PHANLOAIDON] = "";
            Session[SS_TK.ISDONGOC] = "";
            Session[SS_TK.ISTUHINH] = "";
            Session[SS_TK.TOAANXX] = "0";
            Session[SS_TK.SOBAQD] = "";
            Session[SS_TK.NGAYBAQD] = "";
            Session[SS_TK.NGUOIGUI] = "";
            Session[SS_TK.SOCMND] = "";
            Session[SS_TK.NGAYNHANTU] = "";
            Session[SS_TK.NGAYNHANDEN] = "";
            Session[SS_TK.HINHTHUCDON] = "";
            Session[SS_TK.MADON] = "";
            Session[SS_TK.TINHID] = 0;
            Session[SS_TK.HUYENID] = 0;
            Session[SS_TK.DIACHICHITIET] = "";
            Session[SS_TK.SOCV] = "";
            Session[SS_TK.NGAYCV] = "";
            Session[SS_TK.TRALOIDON] = "0";
            Session[SS_TK.LOAICHUYEN] = "-1";
            Session[SS_TK.TRANGTHAICHUYEN] = "-1";
            Session[SS_TK.PHONGBANCHUYEN] = "0";
            Session[SS_TK.LOAIAN] = "";
            Session[SS_TK.DIEUKIENCHUYEN] = "-1";
            Session[SS_TK.NGAYCHUYENTU] = "";
            Session[SS_TK.NGAYCHUYENDEN] = "";
            Session[SS_TK.TOAKHACID] = "0";
            Session[SS_TK.TENNGOAITOAAN] = "";
            Session[SS_TK.THULYDON] = "-1";
            Session[SS_TK.CHANHANCHIDAO] = "";
            Session[SS_TK.TRAIGIAM] = "";
            Session[SS_TK.THAMPHAN] = "";
            Session[SS_TK.LOAICV] = "";
            Session[SS_TK.BC_SOCV] = "";
            Session[SS_TK.BC_NGAYCV] = "";
            Session[SS_TK.BC_NGUOIKY] = "";
            Session[SS_TK.THULY_TU] = "";
            Session[SS_TK.THULY_DEN] = "";
            Session[SS_TK.SOTHULY] = "";
            Session[SS_TK.ARRSELECTID] = "";
            Session[SS_TK.CVPC_SO] = "";
            Session[SS_TK.CVPC_NGAY] = "";
            Session[SS_TK.CVPC_TenCQ] = "";
            Session[SS_TK.GUITOI_CA_TA] = "";
        }
        private bool CheckData()
        {
            string TuNgay = txtNgaynhapTu.Text, DenNgay = txtNgaynhapDen.Text;
            if (TuNgay == "")
            {
                lblmsg.Text = "Bạn chưa nhập từ ngày.";
                Cls_Comon.SetFocus(this.txtNgaynhapTu, this.GetType(), txtNgaynhapTu.ClientID);
                return false;
            }
            if (TuNgay != "")
            {
                DateTime Day_TuNgay = DateTime.Now;
                if (DateTime.TryParse(TuNgay, new System.Globalization.CultureInfo("vi-VN"), System.Globalization.DateTimeStyles.NoCurrentDateDefault, out Day_TuNgay) == false)
                {
                    lblmsg.Text = "Bạn nhập từ ngày chưa đúng theo định dạng (Ngày / Tháng / Năm).";
                    Cls_Comon.SetFocus(this.txtNgaynhapTu, this.GetType(), txtNgaynhapTu.ClientID);
                    return false;
                }
            }
            if (DenNgay == "")
            {
                lblmsg.Text = "Bạn chưa nhập đến ngày.";
                Cls_Comon.SetFocus(this.txtNgaynhapDen, this.GetType(), txtNgaynhapDen.ClientID);
                return false;
            }
            if (DenNgay != "")
            {
                DateTime Day_DenNgay = DateTime.Now;
                if (DateTime.TryParse(DenNgay, new System.Globalization.CultureInfo("vi-VN"), System.Globalization.DateTimeStyles.NoCurrentDateDefault, out Day_DenNgay) == false)
                {
                    lblmsg.Text = "Bạn nhập đến ngày đúng theo định dạng (Ngày / Tháng / Năm).";
                    Cls_Comon.SetFocus(this.txtNgaynhapDen, this.GetType(), txtNgaynhapDen.ClientID);
                    return false;
                }
            }
            if (TuNgay != "" && DenNgay != "")
            {
                if (DateTime.Parse(txtNgaynhapTu.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault) > DateTime.Parse(txtNgaynhapDen.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault))
                {
                    lblmsg.Text = "Từ ngày phải nhỏ hơn hoặc bằng đến ngày.";
                    return false;
                }
            }
            return true;
        }
        private void LoadTKTrptHCTP()
        {
            GDTTT_APP_BL oVABL = new GDTTT_APP_BL();
            decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            decimal strCanBoID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            String strUsername = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            String strNhomID = Session[ENUM_SESSION.SESSION_NHOMNSDID] + "";

            DataTable tbl = oVABL.THONGKE_THEO_HCTP_GET(vToaAnID, strUsername, strNhomID, txtNgaynhapTu.Text, txtNgaynhapDen.Text);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                lblmsg.Text = "";
            }
            rptHCTP.DataSource = tbl;
            rptHCTP.DataBind();
        }
        //---Số đơn xử lý trong ngày
        private void LoadTKTrptHCTP_DAY()
        {
            GDTTT_APP_BL oVABL = new GDTTT_APP_BL();
            decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            decimal strCanBoID =Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            String strUsername = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            String strNhomID = Session[ENUM_SESSION.SESSION_NHOMNSDID] + "";
            DataTable tbl = oVABL.THONGKE_NGUOIDUNG_HCTP_GET(vToaAnID, strUsername, strNhomID, txtNgaynhapTu.Text, txtNgaynhapDen.Text);
            rptHCTP_DAY.DataSource = tbl;
            rptHCTP_DAY.DataBind();
        }
        protected void btnXemBC_View_Click(object sender, EventArgs e)
        {
            if (CheckData() == false)
            {
                return;
            }
            LoadTKTrptHCTP();
            LoadTKTrptHCTP_DAY();
        }
        protected void btnXemBC_Click(object sender, EventArgs e)
        {
            if (CheckData() == false)
            {
                return;
            }
            decimal strCanBoID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            String strUsername = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            String strNhomID = Session[ENUM_SESSION.SESSION_NHOMNSDID] + "";
            //-------------------------------------
            Literal Table_Str_Totals = new Literal();
            GDTTT_BAOCAO_BL oBL = new GDTTT_BAOCAO_BL();
            DataTable tbl = new DataTable();
            DataRow row = tbl.NewRow();
            //-------------
            GDTTT_APP_BL oVABL = new GDTTT_APP_BL();
             tbl = oVABL.THONGKE_THEO_HCTP_EXPORT(vToaAnID, strUsername, strNhomID, txtNgaynhapTu.Text, txtNgaynhapDen.Text);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                lblmsg.Text = "";
            }
            //-----------
            if (tbl != null && tbl.Rows.Count > 0)
            {
                row = tbl.Rows[0];
                Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
            }
            //--------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=Thong_Ke_BC.doc");
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
            Response.Write("<!-- /* Style Definitions */" +
                                             "p.MsoFooter, li.MsoFooter, div.MsoFooter" +
                                             "{margin:0in;" +
                                             "margin-bottom:.0001pt;" +
                                             "mso-pagination:widow-orphan;" +
                                             "tab-stops:center 3.0in right 6.0in;" +
                                             "font-size:12.0pt;}");
            Response.Write("@page Section1 {size:595.45pt 841.7pt; margin:.75in .5in .75in .5in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");
            Response.Write("div.Section1 {page:Section1;}");
            //Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:1.25in 1.0in 1.25in 1.0in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");
            //Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.7in 0.5in 0.5in 0.5in;mso-header-margin:.1in;mso-footer-margin:.1in;mso-paper-source:0;}");
            Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.2in 0.2in 0.5in 0.2in;mso-header: h1;mso-header-margin:.2in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
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
        protected void rptHCTP_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string strCanBoID = Session[ENUM_SESSION.SESSION_CANBOID] + "";
            decimal CanboID = Convert.ToDecimal(strCanBoID);
            string strLoaiAn = e.CommandArgument.ToString();
            //if (strLoaiAn == "") return;
            if (strLoaiAn.Length == 1) strLoaiAn = "0" + strLoaiAn;
            ClearSession_TK();
            Session[SS_TK.SOBAQD] = "";
            Session[SS_TK.LOAIAN] = strLoaiAn;
            Session[SS_TK.NGAYNHAPTU] = txtNgaynhapTu.Text;
            Session[SS_TK.NGAYNHAPDEN] = txtNgaynhapDen.Text;
            Session[SS_TK.PHANLOAIDON] = "2";
            Session["MaChuongTrinh"] = "GDTTT_GQ";
            //--------------
            QT_MENU_BL qtBL = new QT_MENU_BL();
            DataTable lst_home = qtBL.Qt_Nhom_Home_Get_List(44, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_NHOMNSDID] + ""));
            if (lst_home != null && lst_home.Rows.Count > 0)
            {
                if (lst_home.Rows[0]["XEM"] + "" == "1")
                {
                    if (lst_home.Rows[0]["XEM_ALL"] + "" == "0")//không phải là lãnh đạo thì truyên user vào trong danh danh sách tìm kiếm 
                    {
                        Session[SS_TK.NGUOINHAP] = "," + Session[ENUM_SESSION.SESSION_USERNAME] + ",";
                    }
                }
            }
            //----------------
            string strTrangThai = e.CommandName;
            switch (strTrangThai)
            {
                case "COLUMN_1":
                    break;
                case "COLUMN_2":
                    Session[SS_TK.LOAICHUYEN] = "3";
                    break;
                case "COLUMN_3":
                    Session[SS_TK.LOAICHUYEN] = "-2";//Tòa khác + Ngoài tòa án
                    break;
                case "COLUMN_4":
                    Session[SS_TK.LOAICHUYEN] = "0";
                    Session[SS_TK.PHONGBANCHUYEN] = "0";
                    Session[SS_TK.DIEUKIENCHUYEN] = "1";
                    break;

                case "COLUMN_5":
                   // Session["TTTKVISIBLE"] = "0";//mở tìm kiếm nâng cao ở danh sách, vì nếu ko mở thì dữ liệu ko đúng, chưa tìm ra nguyên nhân *anhvh
                    Session[SS_TK.LOAICHUYEN] = "0";
                    Session[SS_TK.PHONGBANCHUYEN] = "2";
                    Session[SS_TK.DIEUKIENCHUYEN] = "0";
                    Session[SS_TK.THULYDON] = "2";
                    break;
                case "COLUMN_6":
                    Session[SS_TK.LOAICHUYEN] = "0";
                    Session[SS_TK.PHONGBANCHUYEN] = "2";
                    Session[SS_TK.DIEUKIENCHUYEN] = "0";
                    Session[SS_TK.THULYDON] = "1";
                    break;
                case "COLUMN_7":
                    Session[SS_TK.LOAICHUYEN] = "0";
                    Session[SS_TK.PHONGBANCHUYEN] = "3";
                    Session[SS_TK.DIEUKIENCHUYEN] = "0";
                    Session[SS_TK.THULYDON] = "2";
                    break;
                case "COLUMN_8":
                    Session[SS_TK.LOAICHUYEN] = "0";
                    Session[SS_TK.PHONGBANCHUYEN] = "3";
                    Session[SS_TK.DIEUKIENCHUYEN] = "0";
                    Session[SS_TK.THULYDON] = "1";
                    break;
                case "COLUMN_9":
                    Session[SS_TK.LOAICHUYEN] = "0";
                    Session[SS_TK.PHONGBANCHUYEN] = "4";
                    Session[SS_TK.DIEUKIENCHUYEN] = "0";
                    Session[SS_TK.THULYDON] = "2";
                    break;
                case "COLUMN_10":
                    Session[SS_TK.LOAICHUYEN] = "0";
                    Session[SS_TK.PHONGBANCHUYEN] = "4";
                    Session[SS_TK.DIEUKIENCHUYEN] = "0";
                    Session[SS_TK.THULYDON] = "1";
                    break;
                case "COLUMN_11":
                    Session[SS_TK.LOAICHUYEN] = "1";
                    Session[SS_TK.TOAKHACID] = "4";
                    break;
                case "COLUMN_12":
                    Session[SS_TK.LOAICHUYEN] = "1";
                    Session[SS_TK.TOAKHACID] = "5";
                    break;
                case "COLUMN_13":
                    Session[SS_TK.LOAICHUYEN] = "1";
                    Session[SS_TK.TOAKHACID] = "6";
                    break;
                case "COLUMN_14":
                    Session[SS_TK.LOAICHUYEN] = "0";
                    Session[SS_TK.PHONGBANCHUYEN] = "21";
                    break;
                case "COLUMN_15":
                    Session[SS_TK.LOAICHUYEN] = "0";
                    Session[SS_TK.PHONGBANCHUYEN] = "22";
                    break;
                case "COLUMN_16":
                    Session[SS_TK.LOAICHUYEN] = "1";
                    break;
                case "COLUMN_17":
                    Session[SS_TK.LOAICHUYEN] = "2";
                    break;
                case "COLUMN_18":
                    Session[SS_TK.LOAICHUYEN] = "4";
                    break;
                case "COLUMN_19":
                    //Session[SS_TK.NGAYNHAPTU] = "";
                    //Session[SS_TK.NGAYNHAPDEN] = "";
                    Session[SS_TK.NGAYCHUYENTU] = txtNgaynhapTu.Text;
                    Session[SS_TK.NGAYCHUYENDEN] = txtNgaynhapDen.Text;
                    Session[SS_TK.TRANGTHAICHUYEN] = "1";
                    //---------------
                    Session[SS_TK.LOAICHUYEN] = "0";
                    Session[SS_TK.PHONGBANCHUYEN] = "2";
                    Session[SS_TK.DIEUKIENCHUYEN] = "0";
                    Session[SS_TK.THULYDON] = "2";
                    break;
                case "COLUMN_20":
                    //Session[SS_TK.NGAYNHAPTU] = "";
                    //Session[SS_TK.NGAYNHAPDEN] = "";
                    Session[SS_TK.NGAYCHUYENTU] = txtNgaynhapTu.Text;
                    Session[SS_TK.NGAYCHUYENDEN] = txtNgaynhapDen.Text;
                    Session[SS_TK.TRANGTHAICHUYEN] = "1";
                    //-------------------
                    Session[SS_TK.LOAICHUYEN] = "0";
                    Session[SS_TK.PHONGBANCHUYEN] = "2";
                    Session[SS_TK.DIEUKIENCHUYEN] = "0";
                    Session[SS_TK.THULYDON] = "1";
                    break;
                case "COLUMN_21":
                    //Session[SS_TK.NGAYNHAPTU] = "";
                    //Session[SS_TK.NGAYNHAPDEN] = "";
                    Session[SS_TK.NGAYCHUYENTU] = txtNgaynhapTu.Text;
                    Session[SS_TK.NGAYCHUYENDEN] = txtNgaynhapDen.Text;
                    Session[SS_TK.TRANGTHAICHUYEN] = "1";
                    //-----------------
                    Session[SS_TK.LOAICHUYEN] = "0";
                    Session[SS_TK.PHONGBANCHUYEN] = "3";
                    Session[SS_TK.DIEUKIENCHUYEN] = "0";
                    Session[SS_TK.THULYDON] = "2";
                    break;
                case "COLUMN_22":
                    //Session[SS_TK.NGAYNHAPTU] = "";
                    //Session[SS_TK.NGAYNHAPDEN] = "";
                    Session[SS_TK.NGAYCHUYENTU] = txtNgaynhapTu.Text;
                    Session[SS_TK.NGAYCHUYENDEN] = txtNgaynhapDen.Text;
                    Session[SS_TK.TRANGTHAICHUYEN] = "1";
                    //----------------
                    Session[SS_TK.LOAICHUYEN] = "0";
                    Session[SS_TK.PHONGBANCHUYEN] = "3";
                    Session[SS_TK.DIEUKIENCHUYEN] = "0";
                    Session[SS_TK.THULYDON] = "1";
                    break;
                case "COLUMN_23":
                    //Session[SS_TK.NGAYNHAPTU] = "";
                    //Session[SS_TK.NGAYNHAPDEN] = "";
                    Session[SS_TK.NGAYCHUYENTU] = txtNgaynhapTu.Text;
                    Session[SS_TK.NGAYCHUYENDEN] = txtNgaynhapDen.Text;
                    Session[SS_TK.TRANGTHAICHUYEN] = "1";
                    //-----------------
                    Session[SS_TK.LOAICHUYEN] = "0";
                    Session[SS_TK.PHONGBANCHUYEN] = "4";
                    Session[SS_TK.DIEUKIENCHUYEN] = "0";
                    Session[SS_TK.THULYDON] = "2";
                    break;
                case "COLUMN_24":
                    //Session[SS_TK.NGAYNHAPTU] = "";
                    //Session[SS_TK.NGAYNHAPDEN] = "";
                    Session[SS_TK.NGAYCHUYENTU] = txtNgaynhapTu.Text;
                    Session[SS_TK.NGAYCHUYENDEN] = txtNgaynhapDen.Text;
                    Session[SS_TK.TRANGTHAICHUYEN] = "1";
                    //--------------
                    Session[SS_TK.LOAICHUYEN] = "0";
                    Session[SS_TK.PHONGBANCHUYEN] = "4";
                    Session[SS_TK.DIEUKIENCHUYEN] = "0";
                    Session[SS_TK.THULYDON] = "1";
                    break;
            }
            Response.Redirect("QLAN/GDTTT/Hoso/Danhsachdon.aspx");
        }
        protected void rptHCTP_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView dv = (DataRowView)e.Item.DataItem;
                if (dv["LOAIAN"] + "" == "")
                {
                    LinkButton LinkButton1 = (LinkButton)e.Item.FindControl("LinkButton1");
                    LinkButton1.Style.Remove("color");
                    LinkButton1.Style.Add("color", "#EE0E0E");
                }
            }
        }
         protected void rptHCTP_DAY_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string strCanBoID = Session[ENUM_SESSION.SESSION_CANBOID] + "";
            decimal CanboID = Convert.ToDecimal(strCanBoID);
            string []strUSERNAME = e.CommandArgument.ToString().Split(';');

            ClearSession_TK();
            Session[SS_TK.SOBAQD] = "";
            Session[SS_TK.PHANLOAIDON] = "2";
            if (strUSERNAME[1] != "")
            {
                Session[SS_TK.NGUOINHAP] = "," + strUSERNAME[1] + ",";
            }
            else
            {
                Session[SS_TK.NGUOINHAP] = "," + strUSERNAME[0] + ",";
            }

            string strTrangThai = e.CommandName;
            switch (strTrangThai)
            {
                case "COLUMN_1":
                    Session[SS_TK.NGAYNHAPTU] = DateTime.Now.Date.ToString("dd/MM/yyyy");
                    Session[SS_TK.NGAYNHAPDEN] = DateTime.Now.Date.ToString("dd/MM/yyyy");
                    break;
                case "COLUMN_2":
                    Session[SS_TK.NGAYNHAPTU] = "01/" + DateTime.Now.Month + "/" + DateTime.Now.Year;
                    Session[SS_TK.NGAYNHAPDEN] = DateTime.Now.Date.ToString("dd/MM/yyyy");//String.Format("dd/MM/yyyy", DateTime.Now.Date);
                    break;
                case "COLUMN_3":
                    Session[SS_TK.NGAYNHAPTU] = txtNgaynhapTu.Text;
                    Session[SS_TK.NGAYNHAPDEN] = txtNgaynhapDen.Text;
                    break;
            }
            Response.Redirect("QLAN/GDTTT/Hoso/Danhsachdon.aspx");

        }
        protected void rptHCTP_DAY_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView dv = (DataRowView)e.Item.DataItem;
                if (dv["v_TT"] + "" == "0")
                {
                    LinkButton LinkButton1 = (LinkButton)e.Item.FindControl("LinkButton1");
                    LinkButton1.Style.Remove("color");
                    LinkButton1.Style.Add("color", "#EE0E0E");
                    //-------------
                    LinkButton LinkButton2 = (LinkButton)e.Item.FindControl("LinkButton2");
                    LinkButton2.Style.Remove("color");
                    LinkButton2.Style.Add("color", "#EE0E0E");
                    //--------------
                    LinkButton LinkButton3 = (LinkButton)e.Item.FindControl("LinkButton3");
                    LinkButton3.Style.Remove("color");
                    LinkButton3.Style.Add("color", "#EE0E0E");
                    //--------------
                    HtmlTableCell hoten_td = (HtmlTableCell)e.Item.FindControl("hoten_td");
                    hoten_td.Style.Add("text-align","center");
                }
            }
        }
    }
}