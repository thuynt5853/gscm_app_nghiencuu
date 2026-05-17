
using Module.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Data;

using System.Globalization;
using System.Web.UI.WebControls;

using DAL.DKK;
using BL.GSTP.Danhmuc;

using BL.DonKK.DanhMuc;
using System.Collections;
using System.Configuration;

using System.Web.Security;

using System.Web.UI.HtmlControls;

using System.Web.UI.WebControls.WebParts;
using System.Text;
using BL.THONGKE;
using BL.THONGKE.Manager;
using BL.THONGKE.Info;
using BL.ThongKe;
using System.Reflection;

namespace WEB.GSTP.Baocao.Phulucquochoi
{
    public partial class Danhsach : System.Web.UI.Page
    {
        protected void upload_criminal_Unload(object sender, EventArgs e)
        {
            RegisterUpdatePanel((UpdatePanel)sender);
        }
        protected void RegisterUpdatePanel(UpdatePanel panel)
        {
            var sType = typeof(ScriptManager);
            var mInfo = sType.GetMethod("System.Web.UI.IScriptManagerInternal.RegisterUpdatePanel", BindingFlags.NonPublic | BindingFlags.Instance);
            if (mInfo != null)
                mInfo.Invoke(ScriptManager.GetCurrent(Page), new object[] { panel });
        }

        #region "HOLD OFF"
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
         

            scriptManager.RegisterPostBackControl(this.cmd_exels);
            //CONVERT SESSION
            ConvertSessions cs = new ConvertSessions();
            if (cs.convertSession2() == false)
            {
                return;
            }

            //XU LY POSTBACK
            //try
            //{
            if (!IsPostBack)
            {
                String v_typecourts = Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString());
                //v_typecourts: 0 tỉnh huyên - administrator;1 Vụ Tổng Hợp;2 (phúc thẩm);
                //3 Tòa chuyên trách cũ; 4 Tòa cấp cao
                String str_typeusers = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
                //"" khi login admin
                //txt_day_from.Text = String.Format("{0:dd/MM/yyyy}", BL.THONGKE.Manager.Database.GetFirstDayOfMonth(DateTime.Now.Month - 2));
                //txt_day_to.Text = String.Format("{0:dd/MM/yyyy}", BL.THONGKE.Manager.Database.GetLastDayOfMonth(DateTime.Now));
                //txt_day_from.Text = "01/10/2017";
                //txt_day_to.Text = "30/11/2017";
                txt_day_from.Text = String.Format("{0:dd/MM/yyyy}", BL.THONGKE.Manager.Database.GetFirstDayOfMonth(DateTime.Now.Month + 1));
                txt_day_to.Text = String.Format("{0:dd/MM/yyyy}", BL.THONGKE.Manager.Database.GetLastDayOfMonth(DateTime.Now));
                Get_Skin();
                Get_Option();
            }
            //}
            //catch (Exception ex) {
            //    //lbthongbao.Text = ex.Message;
            //}
        }
        #endregion

        public void Get_Option()
        {
            Drop_Options.Items.Clear();
            ListItem ites = new ListItem();
            string values = Drop_Skin.SelectedValue;
            Drop_Options.Visible = true;
            Drop_Skin.Width = 200;
            switch (values)
            {
                case "18":
                    ites = new ListItem("Sơ thẩm cá nhân", "19");
                    Drop_Options.Items.Add(ites);
                    ites = new ListItem("Phúc thẩm, GDT,TT cá nhân", "301");
                    Drop_Options.Items.Add(ites);
                    ites = new ListItem("Sơ thẩm pháp nhân", "68");
                    Drop_Options.Items.Add(ites);
                    ites = new ListItem("Phúc thẩm, GDT,TT pháp nhân", "302");
                    Drop_Options.Items.Add(ites);
                    break;
                case "26":
                case "32":
                case "42":
                case "47":
                    ites = new ListItem("ST,PT,GĐTTT", "303");
                    Drop_Options.Items.Add(ites);
                    break;
                case "37":
                    ites = new ListItem("ST,PT,GĐTTT,Tuyên bố PS", "304");
                    Drop_Options.Items.Add(ites);
                    break;
                default:
                    Drop_Skin.Width = 400;
                    Drop_Options.Visible = false;
                    break;
            }
        }
        public void Get_Ra_transfer_records()
        {
            string values = Drop_Skin.SelectedValue;
            switch (values)
            {
                case "203":
                case "204":
                    tr_transfer_records.Style.Add("Display", "block");
                    day_check_Compare.Style.Add("Display", "None");
                    break;
                case "219"://mau so sanh
                case "220"://mau so sanh
                    tr_transfer_records.Style.Add("Display", "block");
                    day_check_Compare.Style.Add("Display", "Block");
                    break;
                default:
                    tr_transfer_records.Style.Add("Display", "none");
                    day_check_Compare.Style.Add("Display", "None");
                    break;
            }
        }
        public void Get_Skin()
        {
            Drop_Skin.Items.Clear();
            ListItem ites = new ListItem();
            ites = new ListItem("Phụ lục QH Hình sự", "18");
            Drop_Skin.Items.Add(ites);
            ites = new ListItem("Phụ lục QH Dân sự", "26");
            Drop_Skin.Items.Add(ites);
            ites = new ListItem("Phụ lục QH Hôn nhân", "32");
            Drop_Skin.Items.Add(ites);
            ites = new ListItem("Phụ lục QH Kinh tế", "37");
            Drop_Skin.Items.Add(ites);
            ites = new ListItem("Phụ lục QH Lao động", "42");
            Drop_Skin.Items.Add(ites);
            ites = new ListItem("Phụ lục QH Hành chính", "47");
            Drop_Skin.Items.Add(ites);
            //-------------
            ites = new ListItem("Tổng thụ lý giải quyết các loại vụ việc của TAND", "203");
            Drop_Skin.Items.Add(ites);
            ites = new ListItem("Tổng thụ lý giải quyết các loại vụ việc của TAND so sánh", "219");
            Drop_Skin.Items.Add(ites);
            ites = new ListItem("Tỷ lệ hủy sửa các loại án của Tòa án nhân dân", "204");
            Drop_Skin.Items.Add(ites);
            ites = new ListItem("Tỷ lệ hủy sửa các loại án của Tòa án nhân dân so sánh", "220");
            Drop_Skin.Items.Add(ites);
            ites = new ListItem("Thụ lý, giải quyết đơn đề nghị GĐT, TT và các loại vụ án của 3 tòa cấp cao", "205");
            Drop_Skin.Items.Add(ites);
            ites = new ListItem("Thụ lý, giải quyết đơn đề nghị GĐT, TT và các loại vụ án của 3 vụ GĐKT", "206");
            Drop_Skin.Items.Add(ites);
            ites = new ListItem("Thụ lý, giải quyết các loại án GĐT,TT của 3 GĐKT (theo từng đơn vị)", "207");
            Drop_Skin.Items.Add(ites);
            ites = new ListItem("Thụ lý, giải quyết các loại án GĐT,TT của 3 tòa cấp cao", "208");
            Drop_Skin.Items.Add(ites);
            ites = new ListItem("Thụ lý, giải quyết các loại án GĐT,TT của 3 tòa cấp cao đối với các tỉnh", "209");
            Drop_Skin.Items.Add(ites);
            ites = new ListItem("Thụ lý, giải quyết các loại án PT và GĐT,TT của 3 tòa cấp cao", "210");
            Drop_Skin.Items.Add(ites);
            ites = new ListItem("Thụ lý, giải quyết các loại án PT và GĐT,TT của 3 tòa cấp cao theo cấp xét xử", "211");
            Drop_Skin.Items.Add(ites);
            ites = new ListItem("Thụ lý, giải quyết các loại án PT và GĐT,TT của 3 tòa cấp cao theo cấp xét xử đối với các tỉnh", "212");
            Drop_Skin.Items.Add(ites);
            ites = new ListItem("Thụ lý, giải quyết các loại án PT của 3 tòa cấp cao", "213");
            Drop_Skin.Items.Add(ites);
            ites = new ListItem("Thụ lý, giải quyết các loại án PT của 3 tòa cấp cao đối với các tỉnh", "214");
            Drop_Skin.Items.Add(ites);
            ites = new ListItem("Tổng hợp tình hình hủy, sửa của cấp tỉnh đối với cấp huyện", "215");
            Drop_Skin.Items.Add(ites);
            ites = new ListItem("Tổng hợp Hủy, sửa phúc thẩm của các tòa cấp cao đối với các tỉnh", "216");
            Drop_Skin.Items.Add(ites);
            ites = new ListItem("Tổng hợp Hủy, sửa GĐT,TT của các tòa cấp cao đối với các tỉnh", "217");
            Drop_Skin.Items.Add(ites);
            ites = new ListItem("Tổng hợp Hủy, sửa phúc thẩm và GĐT,TT của các tòa cấp cao đối với các tỉnh", "218");
            Drop_Skin.Items.Add(ites);
        }
        protected void cmd_Ok_s_Click(object sender, EventArgs e)
        {
            if (Drop_Skin.SelectedValue == "18")
            {
                if (Drop_Options.SelectedValue == "19")
                {
                    Ex_Drop_Options_0();
                }
                if (Drop_Options.SelectedValue == "68")
                {
                    Ex_Drop_Options_0_PN();
                }
                if (Drop_Options.SelectedValue == "301")
                {
                    Ex_Drop_Options_Appeals();
                }
                if (Drop_Options.SelectedValue == "302")
                {
                    Ex_Drop_Options_Appeals_PN();
                }
            }
            if (Drop_Skin.SelectedValue == "47")
            {
                Ex_Drop_Options_Admin();
            }
            if (Drop_Skin.SelectedValue == "26")
            {
                Ex_Drop_Options_Civil();
            }
            if (Drop_Skin.SelectedValue == "32")
            {
                Ex_Drop_Options_Marriges();
            }
            if (Drop_Skin.SelectedValue == "37")
            {
                Ex_Drop_Options_Economic();
            }
            if (Drop_Skin.SelectedValue == "42")
            {
                Ex_Drop_Options_Labor();
            }
            if (Drop_Skin.SelectedValue == "203")
            {
                Ex_Drop_Options_all_case();
            }
            if (Drop_Skin.SelectedValue == "204")
            {
                Ex_Drop_Options_all_case_Scale();
            }
            if (Drop_Skin.SelectedValue == "205")
            {
                Ex_Drop_Options_all_case_3CW();
            }
            if (Drop_Skin.SelectedValue == "206")
            {
                Ex_Drop_Options_all_case_3Vu_GDKT();
            }
            if (Drop_Skin.SelectedValue == "207")
            {
                Ex_Drop_Options_all_case_3Vu_GDKT_Court();
            }
            if (Drop_Skin.SelectedValue == "208")
            {
                Ex_Drop_Options_all_case_3CW_Total();
            }
            if (Drop_Skin.SelectedValue == "209")
            {
                Ex_Drop_Options_all_case_3CW_OF_Court();
            }
            if (Drop_Skin.SelectedValue == "210")
            {
                Ex_Drop_Options_3CW_PT_GDT_TT_Total();
            }
            if (Drop_Skin.SelectedValue == "211")
            {
                Ex_Drop_Options_3CW_PT_GDT_TT_CXX();
            }
            if (Drop_Skin.SelectedValue == "212")
            {
                Ex_3CW_PT_GDT_TT_CXX_OF_Court();
            }
            if (Drop_Skin.SelectedValue == "213")
            {
                Ex_Drop_Options_3CW_PT();
            }
            if (Drop_Skin.SelectedValue == "214")
            {
                Ex_Drop_Options_3CW_PT_OF_Court();
            }
            if (Drop_Skin.SelectedValue == "215")
            {
                Ex_Cancel_edit_Province_District();
            }
            if (Drop_Skin.SelectedValue == "216" || Drop_Skin.SelectedValue == "217" || Drop_Skin.SelectedValue == "218")
            {
                Ex_Cancel_edit_CW_Province();
            }
            if (Drop_Skin.SelectedValue == "219")
            {
                Ex_Drop_Options_all_case_Compare();
            }
            if (Drop_Skin.SelectedValue == "220")
            {
                Ex_Drop_Options_all_case_Scale_Compare();
            }
        }
        //Tong hop phu luc
        public void Ex_Drop_Options_all_case()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;//chưa dùng đến tham số trên
            Int32 sth = 0;//chưa dùng đến tham số trên
            Int32 v_TYPES_OF = 0;
            v_options = 7; //chưa dùng đến tham số trên //ten dang nhap la vu tong hop hoac admin
            v_Names = "";
            if (v_court == "") { v_court = "-1"; }
            M_Judge_Criminal M_Objecs = new M_Judge_Criminal();
            List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
            Literal Table_Str_Totals = new Literal();
            li_sw = M_Objecs.Judge_Export_Total_District_All_Case(Ra_transfer_records.SelectedValue, "", v_TYPES_OF, v_Names, v_court, "", Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
            #region Lay bao cao 
            foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
            {
                Table_Str_Totals.Text += its.Text_Report;
            }
            //-------------------Export---------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=Total_District_All_Cases.xls");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/vnd.xls";
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.End();
            #endregion
        }
        public void Ex_Drop_Options_all_case_Scale()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;//chưa dùng đến tham số trên
            Int32 sth = 0;//chưa dùng đến tham số trên
            Int32 v_TYPES_OF = 0;
            v_options = 7; //chưa dùng đến tham số trên //ten dang nhap la vu tong hop hoac admin
            v_Names = "";
            if (v_court == "") { v_court = "-1"; }
            M_Judge_Criminal M_Objecs = new M_Judge_Criminal();
            List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
            Literal Table_Str_Totals = new Literal();
            li_sw = M_Objecs.Judge_Export_Total_All_Case_Scale(Ra_transfer_records.SelectedValue, "", v_TYPES_OF, v_Names, v_court, "", Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
            #region Lay bao cao 
            foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
            {
                Table_Str_Totals.Text += its.Text_Report;
            }
            //-------------------Export---------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=Total_All_Cases_Scale.xls");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/vnd.xls";
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.End();
            #endregion
        }
        public void Ex_Drop_Options_all_case_3CW()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;//chưa dùng đến tham số trên
            Int32 sth = 0;//chưa dùng đến tham số trên
            Int32 v_TYPES_OF = 0;
            v_options = 7; //chưa dùng đến tham số trên //ten dang nhap la vu tong hop hoac admin
            v_Names = "";
            if (v_court == "") { v_court = "-1"; }
            M_Judge_Criminal M_Objecs = new M_Judge_Criminal();
            List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
            Literal Table_Str_Totals = new Literal();
            li_sw = M_Objecs.Judge_Export_Total_All_Case_3CW(Ra_transfer_records.SelectedValue, "", v_TYPES_OF, v_Names, v_court, "", Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
            #region Lay bao cao 
            foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
            {
                Table_Str_Totals.Text += its.Text_Report;
            }
            //-------------------Export---------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=Total_All_Cases_3CW.xls");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/vnd.xls";
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.End();
            #endregion
        }
        public void Ex_Drop_Options_all_case_3Vu_GDKT()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;//chưa dùng đến tham số trên
            Int32 sth = 0;//chưa dùng đến tham số trên
            Int32 v_TYPES_OF = 0;
            v_options = 7; //chưa dùng đến tham số trên //ten dang nhap la vu tong hop hoac admin
            v_Names = "";
            if (v_court == "") { v_court = "-1"; }
            M_Judge_Criminal M_Objecs = new M_Judge_Criminal();
            List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
            Literal Table_Str_Totals = new Literal();
            li_sw = M_Objecs.Judge_Export_Total_All_Case_3Vu_GDKT(Ra_transfer_records.SelectedValue, "", v_TYPES_OF, v_Names, v_court, "", Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
            #region Lay bao cao 
            foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
            {
                Table_Str_Totals.Text += its.Text_Report;
            }
            //-------------------Export---------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=Total_All_Cases_3TW.xls");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/vnd.xls";
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.End();
            #endregion
        }
        public void Ex_Drop_Options_all_case_3Vu_GDKT_Court()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;//chưa dùng đến tham số trên
            Int32 sth = 0;//chưa dùng đến tham số trên
            Int32 v_TYPES_OF = 0;
            v_options = 7; //chưa dùng đến tham số trên //ten dang nhap la vu tong hop hoac admin
            v_Names = "";
            if (v_court == "") { v_court = "-1"; }
            M_Judge_Criminal M_Objecs = new M_Judge_Criminal();
            List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
            Literal Table_Str_Totals = new Literal();
            li_sw = M_Objecs.Judge_Export_Total_All_Case_3Vu_GDKT_Court(Ra_transfer_records.SelectedValue, "", v_TYPES_OF, v_Names, v_court, "", Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
            #region Lay bao cao 
            foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
            {
                Table_Str_Totals.Text += its.Text_Report;
            }
            //-------------------Export---------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=Total_All_Cases_3CW_of_TW.xls");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/vnd.xls";
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.End();
            #endregion
        }
        public void Ex_Drop_Options_all_case_3CW_Total()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;//chưa dùng đến tham số trên
            Int32 sth = 0;//chưa dùng đến tham số trên
            Int32 v_TYPES_OF = 0;
            v_options = 7; //chưa dùng đến tham số trên //ten dang nhap la vu tong hop hoac admin
            v_Names = "";
            if (v_court == "") { v_court = "-1"; }
            M_Judge_Criminal M_Objecs = new M_Judge_Criminal();
            List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
            Literal Table_Str_Totals = new Literal();
            li_sw = M_Objecs.Judge_Export_Total_3CW(Ra_transfer_records.SelectedValue, "", v_TYPES_OF, v_Names, v_court, "", Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
            #region Lay bao cao 
            foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
            {
                Table_Str_Totals.Text += its.Text_Report;
            }
            //-------------------Export---------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=Total_All_Cases_3CW.xls");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/vnd.xls";
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.End();
            #endregion
        }
        public void Ex_Drop_Options_all_case_3CW_OF_Court()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;//chưa dùng đến tham số trên
            Int32 sth = 0;//chưa dùng đến tham số trên
            Int32 v_TYPES_OF = 0;
            v_options = 7; //chưa dùng đến tham số trên //ten dang nhap la vu tong hop hoac admin
            v_Names = "";
            if (v_court == "") { v_court = "-1"; }
            M_Judge_Criminal M_Objecs = new M_Judge_Criminal();
            List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
            Literal Table_Str_Totals = new Literal();
            li_sw = M_Objecs.Judge_Export_Total_3CW_Of_Court(Ra_transfer_records.SelectedValue, "", v_TYPES_OF, v_Names, v_court, "", Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
            #region Lay bao cao 
            foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
            {
                Table_Str_Totals.Text += its.Text_Report;
            }
            //-------------------Export---------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=Total_All_Cases_3CW_Of_Court.xls");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/vnd.xls";
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.End();
            #endregion
        }
        public void Ex_Drop_Options_3CW_PT_GDT_TT_Total()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;//chưa dùng đến tham số trên
            Int32 sth = 0;//chưa dùng đến tham số trên
            Int32 v_TYPES_OF = 0;
            v_options = 7; //chưa dùng đến tham số trên //ten dang nhap la vu tong hop hoac admin
            v_Names = "";
            if (v_court == "") { v_court = "-1"; }
            M_Judge_Criminal M_Objecs = new M_Judge_Criminal();
            List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
            Literal Table_Str_Totals = new Literal();
            li_sw = M_Objecs.Judge_Export_Total_3CW_PT_GDT_TT(Ra_transfer_records.SelectedValue, "", v_TYPES_OF, v_Names, v_court, "", Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
            #region Lay bao cao 
            foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
            {
                Table_Str_Totals.Text += its.Text_Report;
            }
            //-------------------Export---------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=Total_3CW_PT_GDT_TT.xls");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/vnd.xls";
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.End();
            #endregion
        }
        public void Ex_Drop_Options_3CW_PT_GDT_TT_CXX()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;//chưa dùng đến tham số trên
            Int32 sth = 0;//chưa dùng đến tham số trên
            Int32 v_TYPES_OF = 0;
            v_options = 7; //chưa dùng đến tham số trên //ten dang nhap la vu tong hop hoac admin
            v_Names = "";
            if (v_court == "") { v_court = "-1"; }
            M_Judge_Criminal M_Objecs = new M_Judge_Criminal();
            List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
            Literal Table_Str_Totals = new Literal();
            li_sw = M_Objecs.Judge_Export_3CW_PT_GDT_TT_CXX(Ra_transfer_records.SelectedValue, "", v_TYPES_OF, v_Names, v_court, "", Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
            #region Lay bao cao 
            foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
            {
                Table_Str_Totals.Text += its.Text_Report;
            }
            //-------------------Export---------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=3CW_PT_GDT_TT_CXX.xls");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/vnd.xls";
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.End();
            #endregion
        }
        public void Ex_3CW_PT_GDT_TT_CXX_OF_Court()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;//chưa dùng đến tham số trên
            Int32 sth = 0;//chưa dùng đến tham số trên
            Int32 v_TYPES_OF = 0;
            v_options = 7; //chưa dùng đến tham số trên //ten dang nhap la vu tong hop hoac admin
            v_Names = "";
            if (v_court == "") { v_court = "-1"; }
            M_Judge_Criminal M_Objecs = new M_Judge_Criminal();
            List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
            Literal Table_Str_Totals = new Literal();
            li_sw = M_Objecs.Judge_Export_3CW_PT_GDT_TT_CXX_Of_Court(Ra_transfer_records.SelectedValue, "", v_TYPES_OF, v_Names, v_court, "", Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
            #region Lay bao cao 
            foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
            {
                Table_Str_Totals.Text += its.Text_Report;
            }
            //-------------------Export---------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=3CW_PT_GDT_TT_CXX_OF_COURT.xls");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/vnd.xls";
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.End();
            #endregion
        }
        public void Ex_Drop_Options_3CW_PT()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;//chưa dùng đến tham số trên
            Int32 sth = 0;//chưa dùng đến tham số trên
            Int32 v_TYPES_OF = 0;
            v_options = 7; //chưa dùng đến tham số trên //ten dang nhap la vu tong hop hoac admin
            v_Names = "";
            if (v_court == "") { v_court = "-1"; }
            M_Judge_Criminal M_Objecs = new M_Judge_Criminal();
            List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
            Literal Table_Str_Totals = new Literal();
            li_sw = M_Objecs.Judge_Export_Total_3CW_PT(Ra_transfer_records.SelectedValue, "", v_TYPES_OF, v_Names, v_court, "", Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
            #region Lay bao cao 
            foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
            {
                Table_Str_Totals.Text += its.Text_Report;
            }
            //-------------------Export---------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=3CW_PT.xls");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/vnd.xls";
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.End();
            #endregion
        }
        public void Ex_Drop_Options_3CW_PT_OF_Court()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;//chưa dùng đến tham số trên
            Int32 sth = 0;//chưa dùng đến tham số trên
            Int32 v_TYPES_OF = 0;
            v_options = 7; //chưa dùng đến tham số trên //ten dang nhap la vu tong hop hoac admin
            v_Names = "";
            if (v_court == "") { v_court = "-1"; }
            M_Judge_Criminal M_Objecs = new M_Judge_Criminal();
            List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
            Literal Table_Str_Totals = new Literal();
            li_sw = M_Objecs.Judge_Export_3CW_PT_Of_Court(Ra_transfer_records.SelectedValue, "", v_TYPES_OF, v_Names, v_court, "", Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
            #region Lay bao cao 
            foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
            {
                Table_Str_Totals.Text += its.Text_Report;
            }
            //-------------------Export---------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=3CW_PT_OF_COURT.xls");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/vnd.xls";
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.End();
            #endregion
        }
        public void Ex_Cancel_edit_Province_District()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;//chưa dùng đến tham số trên
            Int32 sth = 0;//chưa dùng đến tham số trên
            Int32 v_TYPES_OF = 0;
            v_options = 7; //chưa dùng đến tham số trên //ten dang nhap la vu tong hop hoac admin
            v_Names = "";
            if (v_court == "") { v_court = "-1"; }
            M_Judge_Criminal M_Objecs = new M_Judge_Criminal();
            List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
            Literal Table_Str_Totals = new Literal();
            li_sw = M_Objecs.Judge_Cancel_edit_Provin(Ra_transfer_records.SelectedValue, "", v_TYPES_OF, v_Names, v_court, "", Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
            #region Lay bao cao 
            foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
            {
                Table_Str_Totals.Text += its.Text_Report;
            }
            //-------------------Export---------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=Cancel_edit_Province_District.xls");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/vnd.xls";
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.End();
            #endregion
        }
        public void Ex_Cancel_edit_CW_Province()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;//chưa dùng đến tham số trên
            Int32 sth = 0;//chưa dùng đến tham số trên
            Int32 v_TYPES_OF = 0;
            String v_Names_ext = "";
            if (Drop_Skin.SelectedValue == "216")
            {
                v_options = 8; //phuc tham
                v_Names_ext = "PT";
            }
            else if (Drop_Skin.SelectedValue == "217")
            {
                v_options = 9;//gdt,tt
                v_Names_ext = "GDT-TT";
            }
            else if (Drop_Skin.SelectedValue == "218")
            {
                v_options = 10;//pt va gdt,tt
                v_Names_ext = "PT-GDT-TT";
            }
            v_Names = "";
            if (v_court == "") { v_court = "-1"; }
            ////------------
            M_Judge_Criminal M_Objecs = new M_Judge_Criminal();
            List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
            Literal Table_Str_Totals = new Literal();
            li_sw = M_Objecs.Judge_Cancel_edit_CW_Province(Ra_transfer_records.SelectedValue, "", v_TYPES_OF, v_Names, v_court, "", Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
            #region Lay bao cao 
            foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
            {
                Table_Str_Totals.Text += its.Text_Report;
            }
            //-------------------Export---------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=Cancel_edit_CW_" + v_Names_ext + ".xls");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/vnd.xls";
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.End();
            #endregion
        }
        public void Ex_Drop_Options_all_case_Compare()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;//chưa dùng đến tham số trên
            Int32 sth = 0;//chưa dùng đến tham số trên
            Int32 v_TYPES_OF = 0;
            v_options = 7; //chưa dùng đến tham số trên //ten dang nhap la vu tong hop hoac admin
            v_Names = "";
            if (v_court == "") { v_court = "-1"; }
            M_Judge_Criminal M_Objecs = new M_Judge_Criminal();
            List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
            Literal Table_Str_Totals = new Literal();
            li_sw = M_Objecs.Judge_Export_Total_District_Compare(Convert.ToDateTime(txt_day_form_Com.Text + " 00:00:00"), Convert.ToDateTime(txt_day_to_Com.Text + " 23:59:59"), Ra_transfer_records.SelectedValue, "", v_TYPES_OF, v_Names, v_court, "", Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
            #region Lay bao cao 
            foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
            {
                Table_Str_Totals.Text += its.Text_Report;
            }
            //-------------------Export---------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=Total_All_Cases_Compare.xls");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/vnd.xls";
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.End();
            #endregion
        }
        public void Ex_Drop_Options_all_case_Scale_Compare()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;//chưa dùng đến tham số trên
            Int32 sth = 0;//chưa dùng đến tham số trên
            Int32 v_TYPES_OF = 0;
            v_options = 7; //chưa dùng đến tham số trên //ten dang nhap la vu tong hop hoac admin
            v_Names = "";
            if (v_court == "") { v_court = "-1"; }
            M_Judge_Criminal M_Objecs = new M_Judge_Criminal();
            List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
            Literal Table_Str_Totals = new Literal();
            li_sw = M_Objecs.Judge_Export_Total_District_Scale_Compare(Convert.ToDateTime(txt_day_form_Com.Text + " 00:00:00"), Convert.ToDateTime(txt_day_to_Com.Text + " 23:59:59"), Ra_transfer_records.SelectedValue, "", v_TYPES_OF, v_Names, v_court, "", Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
            #region Lay bao cao 
            foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
            {
                Table_Str_Totals.Text += its.Text_Report;
            }
            //-------------------Export---------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=Total_Compare_Scale.xls");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/vnd.xls";
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.End();
            #endregion
        }
        //end Tong hop phu luc
        //---------------Export hinh su ------------------------------------
        public void Ex_Drop_Options_0()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;//chưa dùng đến tham số trên
            Int32 sth = 0;//chưa dùng đến tham số trên
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            v_options = 7; //chưa dùng đến tham số trên //ten dang nhap la vu tong hop hoac admin
            v_Names = "";
            if (v_court == "") { v_court = "-1"; }
            M_Judge_Criminal M_Objecs = new M_Judge_Criminal();
            List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
            Literal Table_Str_Totals = new Literal();
            li_sw = M_Objecs.Judge_Export_Total_District_PL("", v_TYPES_OF, v_Names, v_court, "", Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
            #region Lay bao cao chi tiet cap huyen
            foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
            {
                Table_Str_Totals.Text += its.Text_Report;
            }
            //-------------------Export---------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=HSST_Total_District_HS_CN.xls");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/vnd.xls";
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.End();
            #endregion
        }
        public void Ex_Drop_Options_0_PN()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;//chưa dùng đến tham số trên
            Int32 sth = 0;//chưa dùng đến tham số trên
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            v_options = 7; //chưa dùng đến tham số trên //ten dang nhap la vu tong hop hoac admin
            v_Names = "";
            if (v_court == "") { v_court = "-1"; }
            M_Judge_Criminal M_Objecs = new M_Judge_Criminal();
            List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
            Literal Table_Str_Totals = new Literal();
            li_sw = M_Objecs.Judge_Export_Total_District_PL_PN("", v_TYPES_OF, v_Names, v_court, "", Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
            #region Lay bao cao chi tiet cap huyen
            foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
            {
                Table_Str_Totals.Text += its.Text_Report;
            }
            //-------------------Export---------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=HSST_Total_District_HS_PN.xls");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/vnd.xls";
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.End();
            #endregion
        }
        public void Ex_Drop_Options_Appeals()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;//chưa dùng đến tham số trên
            Int32 sth = 0;//chưa dùng đến tham số trên
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            v_options = 7; //chưa dùng đến tham số trên //ten dang nhap la vu tong hop hoac admin
            v_Names = "";
            if (v_court == "") { v_court = "-1"; }
            M_Criminal_Appeals M_Objecs = new M_Criminal_Appeals();
            List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
            Literal Table_Str_Totals = new Literal();
            li_sw = M_Objecs.Judge_Export_Total_Appeal_PL("", v_TYPES_OF, v_Names, v_court, "", Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
            #region Lay bao cao chi tiet cap huyen
            foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
            {
                Table_Str_Totals.Text += its.Text_Report;
            }
            //-------------------Export---------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=HSPTPLQH_PT_GDT_TT.xls");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/vnd.xls";
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.End();
            #endregion
        }
        public void Ex_Drop_Options_Appeals_PN()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;//chưa dùng đến tham số trên
            Int32 sth = 0;//chưa dùng đến tham số trên
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            v_options = 7; //chưa dùng đến tham số trên //ten dang nhap la vu tong hop hoac admin
            v_Names = "";
            if (v_court == "") { v_court = "-1"; }
            M_Criminal_Appea_Com M_Objecs = new M_Criminal_Appea_Com();
            List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
            Literal Table_Str_Totals = new Literal();
            li_sw = M_Objecs.Judge_Export_Total_Appeal_PL("", v_TYPES_OF, v_Names, v_court, "", Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
            #region Lay bao cao chi tiet cap huyen
            foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
            {
                Table_Str_Totals.Text += its.Text_Report;
            }
            //-------------------Export---------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=HSPN_PLQH_PT_GDT_TT.xls");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/vnd.xls";
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.End();
            #endregion
        }
        //---------------Export hinh su end------------------------------
        public void Ex_Drop_Options_Admin()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;//chưa dùng đến tham số trên
            Int32 sth = 0;//chưa dùng đến tham số trên
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            v_options = 7; //chưa dùng đến tham số trên //ten dang nhap la vu tong hop hoac admin
            v_Names = "";
            if (v_court == "") { v_court = "-1"; }
            M_Judge_Admin M_Objecs = new M_Judge_Admin();
            List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
            Literal Table_Str_Totals = new Literal();
            li_sw = M_Objecs.Judge_Export_Total_District_PL("", v_TYPES_OF, v_Names, v_court, "", Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
            #region Lay bao cao chi tiet cap huyen
            foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
            {
                Table_Str_Totals.Text += its.Text_Report;
            }
            //-------------------Export---------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=HC_Total_District_PL.xls");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/vnd.xls";
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.End();
            #endregion
        }
        //---------------Export 1... ------------------------------------
        public void Ex_Drop_Options_Civil()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;//chưa dùng đến tham số trên
            Int32 sth = 0;//chưa dùng đến tham số trên
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            v_options = 7; //chưa dùng đến tham số trên //ten dang nhap la vu tong hop hoac admin
            v_Names = "";
            if (v_court == "") { v_court = "-1"; }
            M_Judge_Civil M_Objecs = new M_Judge_Civil();
            List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
            Literal Table_Str_Totals = new Literal();
            li_sw = M_Objecs.Judge_Export_Total_District_PL("", v_TYPES_OF, v_Names, v_court, "", Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
            #region Lay bao cao chi tiet cap huyen
            foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
            {
                Table_Str_Totals.Text += its.Text_Report;
            }
            //-------------------Export---------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=DS_Total_District_PL.xls");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/vnd.xls";
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.End();
            #endregion
        }
        //---------------Export dan su end------------------------------
        public void Ex_Drop_Options_Marriges()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;//chưa dùng đến tham số trên
            Int32 sth = 0;//chưa dùng đến tham số trên
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            v_options = 7; //chưa dùng đến tham số trên //ten dang nhap la vu tong hop hoac admin
            v_Names = "";
            if (v_court == "") { v_court = "-1"; }
            M_Judge_Marriges M_Objecs = new M_Judge_Marriges();
            List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
            Literal Table_Str_Totals = new Literal();
            li_sw = M_Objecs.Judge_Export_PL("", v_TYPES_OF, v_Names, v_court, "", Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
            #region Lay bao cao chi tiet cap huyen
            foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
            {
                Table_Str_Totals.Text += its.Text_Report;
            }
            //-------------------Export---------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=HNGD_PL.xls");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/vnd.xls";
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.End();
            #endregion
        }
        public void Ex_Drop_Options_Economic()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;//chưa dùng đến tham số trên
            Int32 sth = 0;//chưa dùng đến tham số trên
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            v_options = 7; //chưa dùng đến tham số trên //ten dang nhap la vu tong hop hoac admin
            v_Names = "";
            if (v_court == "") { v_court = "-1"; }
            M_Judge_Economics M_Objecs = new M_Judge_Economics();
            List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
            Literal Table_Str_Totals = new Literal();
            li_sw = M_Objecs.Judge_Export_PL("", v_TYPES_OF, v_Names, v_court, "", Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
            #region Lay bao cao chi tiet cap huyen
            foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
            {
                Table_Str_Totals.Text += its.Text_Report;
            }
            //-------------------Export---------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=KTTM_PL.xls");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/vnd.xls";
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.End();
            #endregion
        }
        public void Ex_Drop_Options_Labor()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;//chưa dùng đến tham số trên
            Int32 sth = 0;//chưa dùng đến tham số trên
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            v_options = 7; //chưa dùng đến tham số trên //ten dang nhap la vu tong hop hoac admin
            v_Names = "";
            if (v_court == "") { v_court = "-1"; }
            M_Judge_Labors M_Objecs = new M_Judge_Labors();
            List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
            Literal Table_Str_Totals = new Literal();
            li_sw = M_Objecs.Judge_Export_PL("", v_TYPES_OF, v_Names, v_court, "", Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
            #region Lay bao cao chi tiet cap huyen
            foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
            {
                Table_Str_Totals.Text += its.Text_Report;
            }
            //-------------------Export---------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=LD_PL.xls");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/vnd.xls";
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.End();
            #endregion
        }
        protected void Drop_Skin_SelectedIndexChanged(object sender, EventArgs e)
        {
            String v_typecourts = Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString());
            String str_typeusers = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            Get_Option();
            Get_Ra_transfer_records();
        }
        protected void Drop_Options_SelectedIndexChanged(object sender, EventArgs e)
        {
            String v_typecourts = Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString());
            String str_typeusers = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
        }
    }
}