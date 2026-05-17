
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

namespace WEB.GSTP.Baocao.Baocaothidua
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
                //txt_day_from.Text = String.Format("{0:dd/MM/yyyy}", Libs.Cms.Manager.Database.GetFirstDayOfMonth(DateTime.Now.Month - 2));
                //txt_day_to.Text = String.Format("{0:dd/MM/yyyy}", Libs.Cms.Manager.Database.GetLastDayOfMonth(DateTime.Now));
                txt_day_from.Text = "01/10/2017";
                txt_day_to.Text = "30/11/2017";
                Load_Ra_Detail_Total();
            }
            //}
            //catch (Exception ex) {
            //    //lbthongbao.Text = ex.Message;
            //}
        }
        #endregion
        public void Load_Ra_Detail_Total()
        {
            String v_typecourts = Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString());
            String str_typeusers = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            ListItem items = new ListItem();
            Ra_level_trial.Items.Clear();
            //Ra_level_trial.Width = 300;
            ListItem itemss = new ListItem();
            if (str_typeusers == "T" || str_typeusers == "H")
            {
                Drop_object_div.Style.Add("display", "none");
                itemss = new ListItem("Cấp xét xử ", "1");
                Ra_level_trial.Items.Add(itemss);
                itemss = new ListItem("Sơ thẩm, phúc thẩm tỉnh và danh sách huyện ", "2");
                Ra_level_trial.Items.Add(itemss);
            }
            else
            {
                itemss = new ListItem("Theo tỉnh ", "0");
                Ra_level_trial.Items.Add(itemss);
                itemss = new ListItem("Cấp xét xử ", "1");
                Ra_level_trial.Items.Add(itemss);
                itemss = new ListItem("Sơ thẩm, phúc thẩm tỉnh và danh sách huyện", "2");
                Ra_level_trial.Items.Add(itemss);
            }
            Ra_level_trial.Items[0].Selected = true;
        }
        protected void cmd_Ok_s_Click(object sender, EventArgs e)
        {
            if (Drop_Skin.SelectedValue == "0")
            {
                Ex_Drop_Emulation_6Cases();
            }
            if (Drop_Skin.SelectedValue == "1")
            {
                Ex_Drop_Emulation_Civil_Marr();
            }
            if (Drop_Skin.SelectedValue == "2")
            {
                Ex_Drop_Emulation_Eco_Labo_Admin();
            }
            if (Drop_Skin.SelectedValue == "3")
            {
                Ex_Drop_Emulation_Criminal_Results();
            }
        }
        protected void Drop_Skin_SelectedIndexChanged(object sender, EventArgs e)
        {
            String v_typecourts = Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString());
            String str_typeusers = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
        }
        public void Ex_Drop_Emulation_6Cases()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 0;
            Int16 owis = 0;//chưa dùng đến tham số trên
            Int32 sth = 0;//chưa dùng đến tham số trên
            Int32 v_TYPES_OF = 0;
            if (Vleustype == "H")
            {
                v_options = 5;//user dang nhap la cap huyện
                v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                v_Names = "CÁC HUYỆN + TỈNH";
            }
            else if (Vleustype == "T")
            {
                v_options = 6;//user dang nhap la cap tinh 
                v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                v_Names = "CÁC HUYỆN + " + Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
            }
            else
            {
                v_options = 7;//ten dang nhap la vu tong hop hoac admin
                v_court = Drop_object.SelectedValue;//gia trị cua cụm
                v_Names = Drop_object.SelectedItem.Text;
            }
            if (v_court == "") { v_Names = "Các tỉnh"; v_court = "-1"; }
            M_Judge_Economics M_Objecs = new M_Judge_Economics();
            List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
            Literal Table_Str_Totals = new Literal();
            if (Ra_level_trial.SelectedValue == "0")//Theo tỉnh
            {
                li_sw = M_Objecs.Judge_Export_Emulation_Provin("", v_TYPES_OF, v_Names, v_court, "", Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
            }
            else if (Ra_level_trial.SelectedValue == "1")//Cấp xét xử
            {
                li_sw = M_Objecs.Judge_Export_Emulation_CXX("", v_TYPES_OF, v_Names, v_court, "", Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
            }
            else if (Ra_level_trial.SelectedValue == "2")//Sơ thẩm, phúc thẩm tỉnh và danh sách huyện
            {
                li_sw = M_Objecs.Judge_Export_Emulation_District("", v_TYPES_OF, v_Names, v_court, "", Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
            }
            #region Lay bao cao chi tiet cap huyen
            foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
            {
                Table_Str_Totals.Text += its.Text_Report;
            }
            //-------------------Export---------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=Emulation_6Cases.xls");
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
        public void Ex_Drop_Emulation_Civil_Marr()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 0;
            Int16 owis = 0;//chưa dùng đến tham số trên
            Int32 sth = 0;//chưa dùng đến tham số trên
            Int32 v_TYPES_OF = 0;
            if (Vleustype == "H")
            {
                v_options = 5;//user dang nhap la cap huyện
                v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                v_Names = "CÁC HUYỆN + TỈNH";
            }
            else if (Vleustype == "T")
            {
                v_options = 6;//user dang nhap la cap tinh 
                v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                v_Names = "CÁC HUYỆN + " + Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
            }
            else
            {
                v_options = 7;//ten dang nhap la vu tong hop hoac admin
                v_court = Drop_object.SelectedValue;//gia trị cua cụm
                v_Names = Drop_object.SelectedItem.Text;
            }
            if (v_court == "") { v_Names = "Các tỉnh"; v_court = "-1"; }
            M_Judge_Economics M_Objecs = new M_Judge_Economics();
            List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
            Literal Table_Str_Totals = new Literal();
            if (Ra_level_trial.SelectedValue == "0")//Theo tỉnh
            {
                //du lieu tinh + huyen
                li_sw = M_Objecs.Judge_Export_Emulation_Civil_Marr_Provin("", v_TYPES_OF, v_Names, v_court, "", Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
            }
            else if (Ra_level_trial.SelectedValue == "1")//Cấp xét xử
            {
                li_sw = M_Objecs.Judge_Export_Emulation_Civil_Marr_CXX("", v_TYPES_OF, v_Names, v_court, "", Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
            }
            else if (Ra_level_trial.SelectedValue == "2")//Sơ thẩm, phúc thẩm tỉnh và danh sách huyện
            {
                li_sw = M_Objecs.Judge_Export_Emulation_Civil_Marr_District("", v_TYPES_OF, v_Names, v_court, "", Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
            }
            #region Lay bao cao chi tiet cap huyen
            foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
            {
                Table_Str_Totals.Text += its.Text_Report;
            }
            //-------------------Export---------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=Emulation_Civil_Marr.xls");
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
        public void Ex_Drop_Emulation_Eco_Labo_Admin()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 0;
            Int16 owis = 0;//chưa dùng đến tham số trên
            Int32 sth = 0;//chưa dùng đến tham số trên
            Int32 v_TYPES_OF = 0;
            if (Vleustype == "H")
            {
                v_options = 5;//user dang nhap la cap huyện
                v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                v_Names = "CÁC HUYỆN + TỈNH";
            }
            else if (Vleustype == "T")
            {
                v_options = 6;//user dang nhap la cap tinh 
                v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                v_Names = "CÁC HUYỆN + " + Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
            }
            else
            {
                v_options = 7;//ten dang nhap la vu tong hop hoac admin
                v_court = Drop_object.SelectedValue;//gia trị cua cụm
                v_Names = Drop_object.SelectedItem.Text;
            }
            if (v_court == "") { v_Names = "Các tỉnh"; v_court = "-1"; }
            M_Judge_Economics M_Objecs = new M_Judge_Economics();
            List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
            Literal Table_Str_Totals = new Literal();
            if (Ra_level_trial.SelectedValue == "0")//Theo tỉnh
            {
                //du lieu tinh + huyen
                li_sw = M_Objecs.Judge_Export_Emu_Eco_Labor_Ad_Provin("", v_TYPES_OF, v_Names, v_court, "", Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
            }
            else if (Ra_level_trial.SelectedValue == "1")//Cấp xét xử
            {
                li_sw = M_Objecs.Judge_Export_Emu_Eco_Labor_Ad_CXX("", v_TYPES_OF, v_Names, v_court, "", Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
            }
            else if (Ra_level_trial.SelectedValue == "2")//Sơ thẩm, phúc thẩm tỉnh và danh sách huyện
            {
                li_sw = M_Objecs.Judge_Export_Emu_Eco_Labor_Ad_District("", v_TYPES_OF, v_Names, v_court, "", Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
            }
            #region Lay bao cao chi tiet cap huyen
            foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
            {
                Table_Str_Totals.Text += its.Text_Report;
            }
            //-------------------Export---------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=Emulation_Eco_Labor_Admin.xls");
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
        public void Ex_Drop_Emulation_Criminal_Results()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 0;
            Int16 owis = 0;//chưa dùng đến tham số trên
            Int32 sth = 0;//chưa dùng đến tham số trên
            Int32 v_TYPES_OF = 0;
            if (Vleustype == "H")
            {
                v_options = 5;//user dang nhap la cap huyện
                v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                v_Names = "CÁC HUYỆN + TỈNH";
            }
            else if (Vleustype == "T")
            {
                v_options = 6;//user dang nhap la cap tinh 
                v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                v_Names = "CÁC HUYỆN + " + Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
            }
            else
            {
                v_options = 7;//ten dang nhap la vu tong hop hoac admin
                v_court = Drop_object.SelectedValue;//gia trị cua cụm
                v_Names = Drop_object.SelectedItem.Text;
            }
            if (v_court == "") { v_Names = "Các tỉnh"; v_court = "-1"; }
            M_Judge_Economics M_Objecs = new M_Judge_Economics();
            List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
            Literal Table_Str_Totals = new Literal();
            if (Ra_level_trial.SelectedValue == "0")//Theo tỉnh
            {
                //du lieu tinh + huyen
                li_sw = M_Objecs.Judge_Export_Emu_Crimin_Res_Provin("", v_TYPES_OF, v_Names, v_court, "", Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
            }
            else if (Ra_level_trial.SelectedValue == "1")//Cấp xét xử
            {
                li_sw = M_Objecs.Judge_Export_Emu_Crimin_Res_CXX("", v_TYPES_OF, v_Names, v_court, "", Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
            }
            else if (Ra_level_trial.SelectedValue == "2")//Sơ thẩm, phúc thẩm tỉnh và danh sách huyện
            {
                li_sw = M_Objecs.Judge_Export_Emu_Crimin_Res_District("", v_TYPES_OF, v_Names, v_court, "", Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
            }
            #region Lay bao cao chi tiet cap huyen
            foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
            {
                Table_Str_Totals.Text += its.Text_Report;
            }
            //-------------------Export---------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=Emulation_Criminal_Results.xls");
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
    }
}