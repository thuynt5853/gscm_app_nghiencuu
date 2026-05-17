
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

namespace WEB.GSTP.Baocao.Thongketonghop
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
                Get_Object_Permission(v_typecourts, str_typeusers);
                Get_Report_Times_Options();
                Getdata_Function_ID();
            }
            //}
            //catch (Exception ex) {
            //    //lbthongbao.Text = ex.Message;
            //}
        }
        public void Get_Report_Times_Options()
        {
            M_ReportTimes M_Objects = new M_ReportTimes();
            Drop_Report_Times.DataSource = M_Objects.Report_Times_List_Statistics(1);
            Drop_Report_Times.DataBind();
        }
        public void Get_Object_Permission(String v_typecourts, String str_typeusers)
        {
            ListItem items = new ListItem();
            Drop_object.Items.Clear();
            if (str_typeusers == "T")
            {
                items = new ListItem("Cấp huyện", "H");
                Drop_object.Items.Add(items);
            }
            else
            {
                //items = new ListItem("Cấp tỉnh", "T");
                //Drop_object.Items.Add(items);
                //items = new ListItem("Cấp huyện", "H");
                //Drop_object.Items.Add(items);
                items = new ListItem("Cấp tỉnh & huyện", "TH");
                Drop_object.Items.Add(items);
                items = new ListItem("Cấp cao", "CW");
                Drop_object.Items.Add(items);
                items = new ListItem("Cấp tối cao", "TW");
                Drop_object.Items.Add(items);
            }

        }
        protected void Drop_object_SelectedIndexChanged(object sender, EventArgs e)
        {
            hi_value_objects.Value = String.Empty;
            txt_courts_show.Text = String.Empty;
            Show_Court_Cheks.Value = String.Empty;
            if (Drop_object.SelectedValue == "H")
            {
                Court_selects.Attributes.CssStyle.Add("display", "none");
            }
            else
            {
                Court_selects.Attributes.CssStyle.Add("display", "normal");
            }
        }
        protected void cmd_exels_Click(object sender, EventArgs e)
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_court = "";
            String v_TYPES_OF = "";
            String V_filename = "";
            v_court = Hi_value_ID_Court.Value; v_TYPES_OF = hi_value_id_functions.Value;
            if (v_court == "") { v_court = "-1"; }

            M_Send_Unsents M_Objecs = new M_Send_Unsents();
            List<Judge_Report> li_sw = new List<Judge_Report>();
            Literal Table_Str_Totals = new Literal();
            if (Drop_Wasexpre.SelectedValue == "1")
            {
                V_filename = "Send_exp_da_gui.xls";
            }
            else
            {
                V_filename = "Unsents_chua_gui.xls";
            }
            if (Drop_object.SelectedValue == "TH")
            {
                li_sw = M_Objecs.Send_Unsents_Export(Drop_object.SelectedValue, v_TYPES_OF, v_court, Drop_Report_Times.SelectedValue, Drop_Wasexpre.SelectedValue);
            }
            else if (Drop_object.SelectedValue == "CW")
            {
                li_sw = M_Objecs.Send_Unsents_Export_CW(Drop_object.SelectedValue, v_TYPES_OF, v_court, Drop_Report_Times.SelectedValue, Drop_Wasexpre.SelectedValue);
            }
            else if (Drop_object.SelectedValue == "TW")
            {
                li_sw = M_Objecs.Send_Unsents_Export_TW(Drop_object.SelectedValue, v_TYPES_OF, v_court, Drop_Report_Times.SelectedValue, Drop_Wasexpre.SelectedValue);
            }
            #region BC theo toi danh cap huyen
            foreach (Judge_Report its in li_sw)
            {
                Table_Str_Totals.Text += its.Text_Report;
            }
            //-------------------Export---------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=" + V_filename);
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
        protected void cmd_courts_selects_Click(object sender, EventArgs e)
        {
            String v_typecourts = Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString());
            String str_typeusers = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            Get_Permission_Courts(v_typecourts, str_typeusers);
            ScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "Show_windows_courts()", true);
        }
        protected void cmd_Function_selects_Click(object sender, EventArgs e)
        {
            txt_courts_show.Text = hi_text_courts.Value;// Show_Court_Cheks.Value.ToString();------edit by anhvh 29/06/2011 copy by anhvh 19/03/2018
            MP_Window_Function.Show();
            ScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "Show_windows_functions()", true);
        }
        public void Get_Permission_Courts(String v_typecourts, String str_typeusers)
        {
            if (str_typeusers == "H")
            {
                Hi_value_ID_Court.Value = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                txt_courts_show.Text = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString());
                Show_Court_Cheks.Value = txt_courts_show.Text;
            }
            else if (str_typeusers == "T")
            {
                if (Drop_object.SelectedValue == "T")
                {
                    Hi_value_ID_Court.Value = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    txt_courts_show.Text = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString());
                    Show_Court_Cheks.Value = txt_courts_show.Text;
                }
                else if (Drop_object.SelectedValue == "TH")
                {
                    Hi_value_ID_Court.Value = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    txt_courts_show.Text = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString());
                    Show_Court_Cheks.Value = txt_courts_show.Text;
                }
                else if (Drop_object.SelectedValue == "H")
                {
                    Hi_value_ID_Court.Value = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    txt_courts_show.Text = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString());
                    Show_Court_Cheks.Value = txt_courts_show.Text;
                }
            }
            else
            {
                if (str_typeusers == "TW")
                {
                    if (v_typecourts == "1")
                    {
                        Get_Courts_Options();
                    }
                    else
                    {
                        Hi_value_ID_Court.Value = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                        txt_courts_show.Text = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString());
                        Show_Court_Cheks.Value = txt_courts_show.Text;
                    }
                }
                else
                {
                    Get_Courts_Options();
                }
            }
        }
        public void Get_Courts_Options()
        {
            Int32 value_courts = Convert.ToInt32(Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString()));
            M_Courts M_Objects = new M_Courts();
            if (Drop_object.SelectedValue == "TH")
            {

                hi_value_objects.Value = String.Empty;
                txt_courts_show.Text = String.Empty;
                Show_Court_Cheks.Value = String.Empty;

                List<Courts> List_Courts = M_Objects.Court_List_Options("T");
                Courts obcourts = new Courts(1, 0, "T001", "Danh sách các tòa án", "", 0);
                List_Courts.Add(obcourts);
                foreach (Courts its in List_Courts)
                {
                    if (its.ID != 1)
                    {
                        its.PARENT_ID = 1;
                    }
                }
                Getdata_Courts(List_Courts);
            }
            if (Drop_object.SelectedValue == "H")
            {
                List<Courts> List_Courtsth = M_Objects.Court_List_Options_Huyen();
                foreach (Courts itsH in List_Courtsth)
                {
                    if (itsH.ID == 1)
                    {
                        itsH.PARENT_ID = 0;
                        itsH.ID = 3;
                    }
                }
                Getdata_Courts(List_Courtsth);
            }
            if (Drop_object.SelectedValue == "T")
            {
                List<Courts> List_Courts = M_Objects.Court_List_Options("T");
                Courts obcourts = new Courts(1, 0, "T001", "Danh sách các tòa án", "", 0);
                List_Courts.Add(obcourts);
                foreach (Courts its in List_Courts)
                {
                    if (its.ID != 1)
                    {
                        its.PARENT_ID = 1;
                    }
                }
                Getdata_Courts(List_Courts);
            }
            if (Drop_object.SelectedValue == "TW")
            {
                List<Courts> List_Courts = M_Objects.Court_List_Options("TW");
                Courts obcourts = new Courts(1, 0, "T001", "Danh sách các tòa án", "", 0);
                List_Courts.Add(obcourts);
                foreach (Courts its in List_Courts)
                {
                    if (its.ID != 1)
                    {
                        its.PARENT_ID = 1;
                    }
                }
                Getdata_Courts(List_Courts);
            }
        }
        public void Getdata_Courts(List<Courts> List_Courts)
        {
            if (hi_value_objects.Value != Drop_object.SelectedValue)
            {
                txt_courts_show.Text = String.Empty;
                Show_Court_Cheks.Value = String.Empty;
                Hi_value_ID_Court.Value = String.Empty;
                hi_value_objects.Value = Drop_object.SelectedValue;
                //TreeView_Courts.DataFieldID = "ID";
                //TreeView_Courts.DataValueField = "ID";
                //TreeView_Courts.DataFieldParentID = "PARENT_ID";
                //TreeView_Courts.DataTextField = "COURT_NAME";
                //TreeView_Courts.CausesValidation = false;
                //TreeView_Courts.DataSource = List_Courts;
                //TreeView_Courts.DataBind();

                BL.ThongKe.Info.TreeviewNode tvn = new BL.ThongKe.Info.TreeviewNode();
                List<BL.ThongKe.Info.TreeviewNode> tvns = tvn.getCourtsNode(List_Courts);
                Treeview_Load(TreeView_Courts1, null, tvns);

            }
            MP_Window_courts.Show();
        }
        protected void cmd_reset_Click(object sender, EventArgs e)
        {
            resetform();
        }

        private void resetform()
        {
            txt_courts_show.Text = String.Empty;
            Show_Court_Cheks.Value = String.Empty;
            Hi_value_ID_Court.Value = String.Empty;
            hi_text_courts.Value = String.Empty;

            txt_Function_ID.Text = String.Empty;
            hi_value_id_functions.Value = String.Empty;

            //TreeView_Courts.UncheckAllNodes();
            Treeview_UncheckNode(TreeView_Courts1);

            //Ra_Chapters.UncheckAllNodes();
            Treeview_UncheckNode(Ra_Functions1);
        }

            public void Getdata_Function_ID()
        {
            M_Functions M_Object = new M_Functions();
            List<Functions> List_Function = M_Object.Function_List_Report();

            //Ra_Functions.DataFieldID = "ID";
            //Ra_Functions.DataValueField = "ID";
            //Ra_Functions.DataFieldParentID = "ID_PARENT";
            //Ra_Functions.DataTextField = "FUNCTION_NAME";
            //Ra_Functions.CausesValidation = false;
            //Ra_Functions.DataSource = List_Function;
            //Ra_Functions.DataBind();

            BL.ThongKe.Info.TreeviewNode tvn = new BL.ThongKe.Info.TreeviewNode();
            List<BL.ThongKe.Info.TreeviewNode> tvns = tvn.getFunctionNode(List_Function);
            Treeview_Load(Ra_Functions1, null, tvns);

        }
        //protected void Ra_Function_NodeCheck(object o, RadTreeNodeEventArgs e)
        //{
        //    IList<RadTreeNode> nodeCollection = Ra_Chapters.CheckedNodes;
        //    txt_Function_ID.Text = String.Empty;
        //    hi_value_id_chapters.Value = String.Empty;
        //    foreach (RadTreeNode node in nodeCollection)
        //    {
        //        if (node.Value != "1")
        //        {
        //            if (txt_Function_ID.Text == "")
        //            {
        //                txt_Function_ID.Text = node.Text;
        //                hi_value_id_chapters.Value = node.Value;
        //            }
        //            else
        //            {
        //                txt_Function_ID.Text += "," + node.Text;
        //                hi_value_id_chapters.Value += "," + node.Value;
        //            }
        //        }
        //    }
        //}

        //---------------Treeview-------------------------------

        private void Treeview_Load(TreeView tv, TreeNode rootNode, List<BL.ThongKe.Info.TreeviewNode> listNodes)
        {
            tv.Nodes.Clear();
            TreeNode oRoot;
            if (rootNode == null)
            {
                List<BL.ThongKe.Info.TreeviewNode> rootNodes = listNodes.FindAll(x => x.PARENT_ID == "0");
                if (rootNodes.Count > 0)
                {
                    foreach (BL.ThongKe.Info.TreeviewNode r in rootNodes)
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
        private void Treeview_LoadChild(TreeNode root, string dept, TreeNode currentNode, List<BL.ThongKe.Info.TreeviewNode> listNodes)
        {
            List<BL.ThongKe.Info.TreeviewNode> listchild = new List<BL.ThongKe.Info.TreeviewNode>();
            if (currentNode != null)
            {
                foreach (BL.ThongKe.Info.TreeviewNode n in listNodes)
                {
                    if (n.PARENT_ID == currentNode.Value)
                    {
                        listchild.Add(n);
                    }
                }
            }
            if (listchild.Count > 0)
            {
                foreach (BL.ThongKe.Info.TreeviewNode child in listchild)
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

        //---------------End Treeview-------------------------------
    }
}