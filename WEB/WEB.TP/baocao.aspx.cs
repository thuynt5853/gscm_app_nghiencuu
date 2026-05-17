using DAL.GSTP;
using BL.GSTP;
using BL.GSTP.TP_THADS;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using BL.THONGKE;
using BL.THONGKE.Manager;
using BL.THONGKE.Info;
using BL.ThongKe;

namespace WEB.TP
{
    public partial class baocao : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        private const int ROOT = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                String str_typeusers = Session["LOAITOA"].ToString();
                Get_Object_Permission(str_typeusers);
            }
        }
        protected void cmd_courts_selects_Click(object sender, EventArgs e)
        {
            String str_typeusers = Session["LOAITOA"].ToString();
            Get_Permission_Courts(str_typeusers);
             ScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "window_Shows_courts()", true);
        }
        protected void Drop_object_SelectedIndexChanged(object sender, EventArgs e)
        {
            reset_DropCourt();
        }
        public void Get_Courts_Options()
        {
            String str_typeusers = Session["LOAITOA"].ToString();
            QT_TUPHAP_BL qtBL = new QT_TUPHAP_BL();
            DataTable oDT = new DataTable();
            oDT = qtBL.QT_Donvi_THADS_BC(str_typeusers,Drop_object.SelectedValue);
            Getdata_Courts(oDT);
        }
        public void Getdata_Courts(DataTable oDT)
        {
            txt_courts_show.Text = String.Empty;
            Show_Court_Cheks.Value = String.Empty;
            Hi_value_ID_Court.Value = String.Empty;
            hi_value_objects.Value = Drop_object.SelectedValue;
            List<TreeviewNode_tp> tvn = new List<TreeviewNode_tp>();
            foreach (DataRow row in oDT.Rows)
            {
                TreeviewNode_tp nodes = new TreeviewNode_tp();
                nodes.ID = row["ID"].ToString();
                nodes.PARENT_ID = row["CAPCHAID"].ToString();
                nodes.TEXT = row["TEN"].ToString();
                tvn.Add(nodes);
            }
            Treeview_Load(TreeView_Courts, null, tvn);
            MP_Window_courts.Show();
        }
        public void Get_Permission_Courts(String str_typeusers)
        {
            if (str_typeusers == "CAPHUYEN")
            {
                Hi_value_ID_Court.Value = Session[ENUM_SESSION.SESSION_DONVIID].ToString();
                txt_courts_show.Text = Session["TEN_DV"].ToString();
                Show_Court_Cheks.Value = txt_courts_show.Text;
            }
            else if (str_typeusers == "CAPTINH")
            {
                if (Drop_object.SelectedValue == "T")
                {
                    Hi_value_ID_Court.Value = Session[ENUM_SESSION.SESSION_DONVIID].ToString();
                    txt_courts_show.Text = Session["TEN_DV"].ToString();
                    Show_Court_Cheks.Value = txt_courts_show.Text;
                    hi_text_courts.Value = txt_courts_show.Text;
                }
                else if (Drop_object.SelectedValue == "TH")
                {
                    Hi_value_ID_Court.Value = Session[ENUM_SESSION.SESSION_DONVIID].ToString();
                    txt_courts_show.Text = Session["TEN_DV"].ToString();
                    hi_text_courts.Value = txt_courts_show.Text;
                    Show_Court_Cheks.Value = txt_courts_show.Text;
                }
                else if (Drop_object.SelectedValue == "H")
                {
                    Get_Courts_Tinh();
                }
            }
            else
            {
                if (str_typeusers == "TOICAO")
                {
                        Get_Courts_Options();
                }
            }
        }
        public void Get_Courts_Tinh()
        {
            String str_donvi_id = Session[ENUM_SESSION.SESSION_DONVIID].ToString();
            QT_TUPHAP_BL qtBL = new QT_TUPHAP_BL();
            DataTable oDT = new DataTable();
            oDT = qtBL.QT_Donvi_THADS_TINH(str_donvi_id);
            Getdata_Courts(oDT);
        }
        public void Get_Object_Permission(String str_typeusers)
        {
            ListItem items = new ListItem();
            Drop_object.Items.Clear();
            if (str_typeusers == "CAPHUYEN")
            {
                items = new ListItem("Chi cục THADS", "H");
                Drop_object.Items.Add(items);
            }
            else if (str_typeusers == "CAPTINH")
            {
                items = new ListItem("Tất cả", "TH");
                Drop_object.Items.Add(items);
                items = new ListItem("Cục THADS", "T");
                Drop_object.Items.Add(items);
                items = new ListItem("Chi cục THADS", "H");
                Drop_object.Items.Add(items);
            }
            else if (str_typeusers == "TOICAO")
            {
                items = new ListItem("Tất cả", "TH");
                Drop_object.Items.Add(items);
                items = new ListItem("Cục THADS", "T");
                Drop_object.Items.Add(items);
                items = new ListItem("Chi cục THADS", "H");
                Drop_object.Items.Add(items);
            }
        }
        protected void cmd_reset_Click(object sender, EventArgs e)
        {
            resetform();
            txtTuNgay.Text = string.Empty;
            txtDenNgay.Text = string.Empty;
        }
        protected void cmd_Ok_s_Click(object sender, EventArgs e)
        {
            String v_court = "";
            Int16 v_options = 1;
            String v_Names = "";
            Literal Table_Str_Totals = new Literal();
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
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    else
                    {
                        v_court = Session[ENUM_SESSION.SESSION_DONVIID].ToString();
                        v_options = 2;
                    }
                }
                else
                {
                    v_court = Hi_value_ID_Court.Value;
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
                    v_court = Hi_value_ID_Court.Value;
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
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "TỔNG CỤC THI HÀNH ÁN DÂN SỰ";
                }
            }
            TAM_UNG_AN_PHI_BL oBL = new TAM_UNG_AN_PHI_BL();
            DataTable tbl = new DataTable();
            DataRow row = tbl.NewRow();
            //-------------
             tbl = oBL.GetAll_report(ddl_TRUCTUYEN.SelectedValue,v_Names, v_options, txtTuNgay.Text, txtDenNgay.Text, v_court, Drop_object.SelectedValue);
            //-----------
            if (tbl != null && tbl.Rows.Count > 0)
            {
                row = tbl.Rows[0];
                Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
            }
            //--------------------------
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
        }
        private void resetform()
        {
            reset_DropCourt();
        }
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
        private void Treeview_Load(TreeView tv, TreeNode rootNode, List<TreeviewNode_tp> listNodes)
        {
            tv.Nodes.Clear();
            TreeNode oRoot;
            if (rootNode == null)
            {
                List<TreeviewNode_tp> rootNodes = listNodes.FindAll(x => x.PARENT_ID == "0");
                if (rootNodes.Count > 0)
                {
                    foreach (TreeviewNode_tp r in rootNodes)
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
        private void Treeview_LoadChild(TreeNode root, string dept, TreeNode currentNode, List<TreeviewNode_tp> listNodes)
        {
            List<TreeviewNode_tp> listchild = new List<TreeviewNode_tp>();
            if (currentNode != null)
            {
                foreach (TreeviewNode_tp n in listNodes)
                {
                    if (n.PARENT_ID == currentNode.Value)
                    {
                        listchild.Add(n);
                    }
                }
            }
            if (listchild.Count > 0)
            {
                foreach (TreeviewNode_tp child in listchild)
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