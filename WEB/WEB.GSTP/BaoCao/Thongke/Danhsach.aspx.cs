
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
using BL.THONGKE;
using BL.THONGKE.Manager;
using BL.THONGKE.Info;
using System.Text;
using BL.ThongKe;

namespace WEB.GSTP.Baocao.Thongke
{
    public partial class Danhsach : System.Web.UI.Page
    {
        public int i = 1;
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
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
                String str_typeusers = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
                Get_Skin_Options();
                Get_Option_Permission(v_typecourts, str_typeusers);
                Get_Report_Times_Options();
                Get_Data_Courts();

            }
            //}
            //catch (Exception ex) {
            //    //lbthongbao.Text = ex.Message;
            //}
        }
        public void Get_Skin_Options()
        {
            Drop_Skin.Items.Clear();
            List<Functions> List_Functions = (List<Functions>)Session["Function_List_Shows"];
            int[] arsv = new int[10] { 18, 26, 32, 37, 42, 47, 53, 57, 61, 65 };
            //SELECT * FROM TC_FUNCTIONS TC WHERE TC.POSTION=1 and TC.ID_PARENT=0 and TC.ID <>1 ORDER BY TC.ID;
            int vsi = 0;
            foreach (Functions its in List_Functions)
            {
                if ((its.ID_PARENT == 0) && (its.POSTION == 1) && (its.ID != 1))
                {
                    for (int i = 0; i <= 9; i++)
                    {
                        if (its.ID == arsv[i])
                        {
                            vsi = Convert.ToInt32(its.ID);
                            //vsi=i
                            break;
                        }
                    }
                    ListItem ites = new ListItem(its.FUNCTION_NAME, vsi.ToString());
                    Drop_Skin.Items.Add(ites);
                }
            }
        }
        public void Get_Data_Courts()
        {
            M_Courts M_Objects = new M_Courts();
            Int32 value_courts = Convert.ToInt32(Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString()));
            String str_typeusers = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_typecourts = Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString());
            Int32 ssv = 0;
            ssv = Convert.ToInt32(Drop_Options.SelectedValue);//không xử dụng mảng so sánh mà lấy TYPE_OF trực tiếp từ Drop_Options.SelectedValue;
            String Dr_ = Drop_Options.SelectedValue;
            if (str_typeusers != "H")
            {
                if (str_typeusers == "T")
                {

                    DGList.DataSource = M_Objects.Court_List_Exports(Drop_object.SelectedValue, Convert.ToInt32(Drop_Report_Times.SelectedValue), ssv, Convert.ToInt32(Drop_Wasexpre.SelectedValue), value_courts, "0");
                }
                else if (str_typeusers == "TW")
                {
                    if (v_typecourts == "1")
                    {
                        DGList.DataSource = M_Objects.Court_List_Exports(Drop_object.SelectedValue, Convert.ToInt32(Drop_Report_Times.SelectedValue), ssv, Convert.ToInt32(Drop_Wasexpre.SelectedValue), value_courts, "1");
                    }
                }
                else
                {
                    DGList.DataSource = M_Objects.Court_List_Exports(Drop_object.SelectedValue, Convert.ToInt32(Drop_Report_Times.SelectedValue), ssv, Convert.ToInt32(Drop_Wasexpre.SelectedValue), value_courts, "1");
                }
            }
            DGList.DataBind();
        }
        public void Get_Object_Permission(String v_typecourts, String str_typeusers)
        {
            ListItem items = new ListItem();
            Drop_object.Items.Clear();
            M_Export_Permissions M_Object = new M_Export_Permissions();
            Functions obj_fun = M_Object.Function_List_ID(Convert.ToInt32(Drop_Options.SelectedValue));
            String[] arrst = obj_fun.DESCRIPTION.Split(',');
            for (Int16 i = 1; i < arrst.Length - 1; i++)
            {
                if (str_typeusers == "H")
                {
                    if (arrst[i] == "H")
                    {
                        items = new ListItem("Cấp huyện", "H");
                        Drop_object.Items.Add(items);
                    }
                }
                else if (str_typeusers == "T")
                {
                    //if (arrst[i] == "T")
                    //{
                    //    items = new ListItem("Cấp tỉnh", "T");
                    //    Drop_object.Items.Add(items);
                    //}
                    if (arrst[i] == "H")
                    {
                        items = new ListItem("Cấp huyện", "H");
                        Drop_object.Items.Add(items);
                    }
                }
                else if (str_typeusers == "CW")
                {
                    if (arrst[i] == "CW")
                    {
                        items = new ListItem("Cấp cao", "CW");
                        Drop_object.Items.Add(items);
                    }
                }
                else if (str_typeusers == "TW")
                {
                    if (v_typecourts == "1")
                    {
                        if (arrst[i] == "T")
                        {
                            items = new ListItem("Cấp tỉnh", "T");
                            Drop_object.Items.Add(items);
                        }
                        if (arrst[i] == "H")
                        {
                            items = new ListItem("Cấp huyện", "H");
                            Drop_object.Items.Add(items);
                        }
                        if (arrst[i] == "CW")
                        {
                            items = new ListItem("Cấp cao", "CW");
                            Drop_object.Items.Add(items);
                        }
                        if (arrst[i] == "TW")
                        {
                            items = new ListItem("Cấp tối cao", "TW");
                            Drop_object.Items.Add(items);
                        }
                    }
                    else
                    {
                        if (arrst[i] == "TW")
                        {
                            items = new ListItem("Cấp tối cao", "TW");
                            Drop_object.Items.Add(items);
                        }
                    }
                }
                else
                {
                    if (arrst[i] == "T")
                    {
                        items = new ListItem("Cấp tỉnh", "T");
                        Drop_object.Items.Add(items);
                    }
                    if (arrst[i] == "H")
                    {
                        items = new ListItem("Cấp huyện", "H");
                        Drop_object.Items.Add(items);
                    }
                    if (arrst[i] == "CW")
                    {
                        items = new ListItem("Cấp cao", "CW");
                        Drop_object.Items.Add(items);
                    }
                    if (arrst[i] == "TW")
                    {
                        items = new ListItem("Cấp tối cao", "TW");
                        Drop_object.Items.Add(items);
                    }
                }
            }
            string values = Drop_Options.SelectedValue;
        }
        protected void Drop_Options_SelectedIndexChanged(object sender, EventArgs e)
        {
            String v_typecourts = Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString());
            String str_typeusers = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            Get_Object_Permission(v_typecourts, str_typeusers);
            Get_Data_Courts();
        }
        protected void Drop_TYPES_REPORT_SelectedIndexChanged(object sender, EventArgs e)
        {
            Get_Report_Times_Options();
        }
        protected void Drop_Skin_SelectedIndexChanged(object sender, EventArgs e)
        {
            String v_typecourts = Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString());
            String str_typeusers = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            Get_Option_Permission(v_typecourts, str_typeusers);
            Get_Data_Courts();
        }
        protected void Drop_Wasexport_SelectedIndexChanged(object sender, EventArgs e)
        {
            Get_Data_Courts();
        }
        protected void DDrop_object_SelectedIndexChanged(object sender, EventArgs e)
        {
            Get_Data_Courts();
        }
        protected void Drop_Report_Times_SelectedIndexChanged(object sender, EventArgs e)
        {
            Get_Data_Courts();
        }
        public void Get_Option_Permission(String v_typecourts, String str_typeusers)
        {
            List<Functions> List_Functions = (List<Functions>)Session["Function_List_Shows"];
            ListItem items = new ListItem();
            Drop_Options.Items.Clear();
            M_Export_Permissions M_Object = new M_Export_Permissions();
            List<Functions> List_fun = M_Object.Function_List_Per(Convert.ToInt32(Drop_Skin.SelectedValue), Database.GetUserName(Session["Sesion_Manager_ID"].ToString()));
            foreach (Functions its in List_fun)
            {
                items = new ListItem(its.FUNCTION_NAME, Convert.ToString(its.ID));
                Drop_Options.Items.Add(items);
            }
            Get_Object_Permission(v_typecourts, str_typeusers);
        }
        public void Get_Report_Times_Options()
        {
            M_ReportTimes M_Objects = new M_ReportTimes();
            Drop_Report_Times.DataSource = M_Objects.Report_Times_List_Statistics(Convert.ToInt32(Drop_TYPES_REPORT.SelectedValue));
            Drop_Report_Times.DataBind();
        }
        protected void DGList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                e.Item.Attributes.Add("OnMouseOver", "this.style.backgroundColor = '#d7e5f1';");
                if (e.Item.ItemType == ListItemType.AlternatingItem)
                {
                    e.Item.Attributes.Add("OnMouseOut", "this.style.backgroundColor = 'White';");
                }
                else
                {
                    e.Item.Attributes.Add("OnMouseOut", "this.style.backgroundColor = '#F1F5F6';");
                }
            }
        }
        protected void cmd_exels_Click(object sender, EventArgs e)
        {
            String vasv = "Da_Bao_Cao";
            if (Drop_Wasexpre.SelectedValue == "0")
            {
                vasv = "Chua_Bao_Cao";
            }
            Response.Clear();
            Response.ClearContent();
            Response.Write("<meta http-equiv=Content-Type content=\"text/html; charset=utf-8\">");
            this.EnableViewState = false;
            Response.AddHeader("content-disposition", "attachment;filename=Thong_Ke_Cac_Toa_" + vasv + ".xls;");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/vnd.ms-excel";
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            DGList.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.End();
        }
    }
}