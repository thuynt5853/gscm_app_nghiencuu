
using Module.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Data;

using System.Globalization;
using System.Web.UI.WebControls;

using BL.THONGKE;
using BL.THONGKE.Manager;
using BL.THONGKE.Info;
using BL.ThongKe;
using System.Reflection;

namespace WEB.GSTP.Baocao.Baocao
{
    public partial class Danhsach : System.Web.UI.Page
    {
        #region "HOLD OFF"
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            scriptManager.RegisterPostBackControl(this.cmd_courts_selects);
            scriptManager.RegisterPostBackControl(this.cmd_chapters);
            scriptManager.RegisterPostBackControl(this.cmd_crimial_selects);

            scriptManager.RegisterPostBackControl(this.cmd_exels);
            scriptManager.RegisterPostBackControl(this.cmd_reset);

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
                Get_Skin_Options();
                Get_Option_Permission(v_typecourts, str_typeusers);
                Getdata_Chapters();
                Get_Data_Cases();
                Load_Ra_Detail_Total();
                Load_Skin_Display();
            }
            //}
            //catch (Exception ex)
            //{
            //    lbthongbao.Text = ex.Message;
            //}
        }
        #endregion

        #region "RESET FORM (HOLD OFF)"
        private void resetform()
        {
            Ra_Detail_Total.SelectedIndex = 0;
            Ra_level_trial.SelectedIndex = 0;
            ch_options_TD.Checked = false;

            txt_day_from.Text = String.Format("{0:dd/MM/yyyy}", BL.THONGKE.Manager.Database.GetFirstDayOfMonth(DateTime.Now.Month));
            txt_day_to.Text = String.Format("{0:dd/MM/yyyy}", BL.THONGKE.Manager.Database.GetLastDayOfMonth(DateTime.Now));

            Drop_Skin.SelectedIndex = 0;
            Drop_Skin_SelectedIndexChanged(null, null);

            Drop_Options.SelectedIndex = 0;
            Drop_Options_SelectedIndexChanged(null, null);

            Drop_object.SelectedIndex = 0;
            Drop_object_SelectedIndexChanged(null, null);

            reset_DropCourt();
            reset_DropChapter();
            reset_DropCriminal();
            reset_DropCase();

            MP_Window_courts.Hide();
            MP_Window_Criminal.Hide();
            MP_Window_Chapters.Hide();
            MP_Window_Cases.Hide();
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
        private void reset_DropChapter()
        {
            txt_chapters.Text = String.Empty;

            //Ra_Chapters.UncheckAllNodes();
            //Ra_Chapters -> uncheck client
            Treeview_UncheckNode(Ra_Chapters);

            ScriptManager.RegisterStartupScript(this.Page, Page.GetType(), Guid.NewGuid().ToString(), "treeview_Unchecked('" + Ra_Chapters.ClientID + "')", true);
        }
        private void reset_DropCriminal()
        {
            txt_crimial_show.Text = String.Empty;
            hi_value_id_criminal.Value = String.Empty;

            //RT_Criminals.UncheckAllNodes();
            //RT_Criminals -> uncheck client
            Treeview_UncheckNode(RT_Criminals);

            ScriptManager.RegisterStartupScript(this.Page, Page.GetType(), Guid.NewGuid().ToString(), "treeview_Unchecked('" + RT_Criminals.ClientID + "')", true);
        }
        private void reset_DropCase()
        {
            txt_Case_shows.Text = String.Empty;
            hi_value_id_Cases.Value = String.Empty;

            //RT_Cases.UncheckAllNodes();
            //RT_Cases -> uncheck client
            Treeview_UncheckNode(RT_Cases);

            ScriptManager.RegisterStartupScript(this.Page, Page.GetType(), Guid.NewGuid().ToString(), "treeview_Unchecked('" + RT_Cases.ClientID + "')", true);
        }
        #endregion

        #region "TREEVIEW (HOLD OFF)"
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
        #endregion

        public void Load_Ra_Detail_Total()
        {
            String v_typecourts = Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString());
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            ListItem items = new ListItem();
            Ra_Detail_Total.Items.Clear();
            Ra_Detail_Total.Width = 200;
            if (Vleustype == "H" || Vleustype == "T")
            {

                switch (Drop_Options.SelectedValue)
                {
                    //mau khong chon danh muc loai an, loai viec, toi danh -> chi co tong hop
                    case "25"://ket qua thi hanh an hinh su
                    case "75"://9D
                    case "79"://1L
                    case "80"://1M
                    case "89"://9i
                    case "90"://9C
                        items = new ListItem("Tổng hợp", "0");
                        Ra_Detail_Total.Items.Add(items);
                        Ra_Detail_Total.SelectedValue = "0";
                        ch_options_TD.Visible = false;
                        break;
                    case "72"://1N
                    case "73"://1O
                    case "81"://1P
                    case "82"://9H
                    case "83"://1Q
                    case "84"://8D
                    case "85"://1R
                    case "86"://1S
                        items = new ListItem("Chi tiết", "1");
                        Ra_Detail_Total.Items.Add(items);
                        ch_options_TD.Visible = false;
                        break;
                    default:
                        items = new ListItem("Tổng hợp", "0");
                        Ra_Detail_Total.Items.Add(items);
                        items = new ListItem("Chi tiết", "1");
                        Ra_Detail_Total.Items.Add(items);
                        break;
                }
            }
            else if (Vleustype == "CW")
            {
                Ra_Detail_Total.Width = 600;
                switch (Drop_Options.SelectedValue)
                {
                    case "75"://9D
                    case "79":
                    case "80"://1M
                    case "89"://9i
                    case "90":
                        items = new ListItem("Tổng hợp", "0");
                        Ra_Detail_Total.Items.Add(items);
                        items = new ListItem("Tổng hợp ĐV trực thuộc", "3");
                        Ra_Detail_Total.Items.Add(items);
                        Ra_Detail_Total.SelectedValue = "0";
                        ch_options_TD.Visible = false;
                        break;
                    case "72"://1N
                    case "73"://1O
                    case "81"://1P
                    case "82"://9H
                    case "83"://1Q
                    case "84"://8D
                    case "85"://1R
                    case "86"://1S
                        items = new ListItem("Chi tiết", "1");
                        Ra_Detail_Total.Items.Add(items);
                        ch_options_TD.Visible = false;
                        break;
                    default:
                        items = new ListItem("Tổng hợp", "0");
                        Ra_Detail_Total.Items.Add(items);
                        items = new ListItem("Tổng hợp ĐV trực thuộc", "3");
                        Ra_Detail_Total.Items.Add(items);
                        items = new ListItem("Chi tiết", "1");
                        Ra_Detail_Total.Items.Add(items);
                        items = new ListItem("Chi tiết ĐV trực thuộc", "2");
                        Ra_Detail_Total.Items.Add(items);
                        break;
                }

            }
            else if (Vleustype == "TW")
            {
                if (v_typecourts == "1" || v_typecourts == "2")//vụ tổng hợp || toa quan su trung uong
                {
                    if (Drop_object.SelectedValue == "H")
                    {
                        Ra_Detail_Total.Width = 400;
                        switch (Drop_Options.SelectedValue)
                        {
                            case "25":
                            case "75"://9D
                            case "79":
                            case "80"://1M
                            case "89"://9i
                            case "90":
                                items = new ListItem("Tổng hợp", "0");
                                Ra_Detail_Total.Items.Add(items);
                                items = new ListItem("Chi tiết ĐV trực thuộc", "2");
                                Ra_Detail_Total.Items.Add(items);
                                Ra_Detail_Total.SelectedValue = "0";
                                ch_options_TD.Visible = false;
                                break;
                            case "73"://1O
                                items = new ListItem("Chi tiết", "1");
                                Ra_Detail_Total.Items.Add(items);
                                ch_options_TD.Visible = false;
                                break;
                            case "72"://1N
                            case "81"://1P
                            case "82"://9H
                            case "83"://1Q
                            case "84"://8D
                            case "85"://1R
                            case "86"://1S
                                items = new ListItem("Chi tiết", "1");
                                Ra_Detail_Total.Items.Add(items);
                                ch_options_TD.Visible = false;
                                break;
                            default:
                                items = new ListItem("Tổng hợp", "0");
                                Ra_Detail_Total.Items.Add(items);
                                items = new ListItem("Chi tiết ĐV trực thuộc", "2");
                                Ra_Detail_Total.Items.Add(items);
                                items = new ListItem("Chi tiết", "1");
                                Ra_Detail_Total.Items.Add(items);
                                break;
                        }
                    }
                    else if (Drop_object.SelectedValue == "CW")
                    {
                        Ra_Detail_Total.Width = 600;
                        switch (Drop_Options.SelectedValue)
                        {
                            case "75"://9D
                            case "79":
                            case "80":
                            case "89"://9i
                            case "90":
                                items = new ListItem("Tổng hợp", "0");
                                Ra_Detail_Total.Items.Add(items);
                                items = new ListItem("Tổng hợp ĐV trực thuộc", "3");
                                Ra_Detail_Total.Items.Add(items);
                                Ra_Detail_Total.SelectedValue = "0";
                                ch_options_TD.Visible = false;
                                break;
                            case "73"://1O
                            case "81"://1P
                            case "82"://9H
                            case "83"://1Q
                            case "84"://8D
                            case "85"://1R
                            case "86"://1S
                                items = new ListItem("Chi tiết", "1");
                                Ra_Detail_Total.Items.Add(items);
                                ch_options_TD.Visible = false;
                                break;
                            default:
                                items = new ListItem("Tổng hợp", "0");
                                Ra_Detail_Total.Items.Add(items);
                                items = new ListItem("Tổng hợp ĐV trực thuộc", "3");
                                Ra_Detail_Total.Items.Add(items);
                                items = new ListItem("Chi tiết", "1");
                                Ra_Detail_Total.Items.Add(items);
                                items = new ListItem("Chi tiết ĐV trực thuộc", "2");
                                Ra_Detail_Total.Items.Add(items);
                                break;
                        }
                    }
                    else if (Drop_object.SelectedValue == "TW")
                    {
                        Ra_Detail_Total.Width = 600;
                        switch (Drop_Options.SelectedValue)
                        {
                            case "79":
                            case "80":
                            case "90":
                                items = new ListItem("Tổng hợp", "0");
                                Ra_Detail_Total.Items.Add(items);
                                items = new ListItem("Tổng hợp ĐV trực thuộc", "3");
                                Ra_Detail_Total.Items.Add(items);
                                Ra_Detail_Total.SelectedValue = "0";
                                ch_options_TD.Visible = false;
                                break;
                            case "73"://1O
                            case "81"://1P
                            case "82"://9H
                            case "83"://1Q
                            case "84"://8D
                            case "85"://1R
                            case "86"://1S
                                items = new ListItem("Chi tiết", "1");
                                Ra_Detail_Total.Items.Add(items);
                                ch_options_TD.Visible = false;
                                break;
                            default:
                                items = new ListItem("Tổng hợp", "0");
                                Ra_Detail_Total.Items.Add(items);
                                items = new ListItem("Tổng hợp ĐV trực thuộc", "3");
                                Ra_Detail_Total.Items.Add(items);
                                items = new ListItem("Chi tiết", "1");
                                Ra_Detail_Total.Items.Add(items);
                                items = new ListItem("Chi tiết ĐV trực thuộc", "2");
                                Ra_Detail_Total.Items.Add(items);
                                break;
                        }
                    }
                    else if (Drop_object.SelectedValue == "T")
                    {
                        Ra_Detail_Total.Width = 300;
                        switch (Drop_Options.SelectedValue)
                        {
                            case "25":
                            case "75"://9D
                            case "79":
                            case "80":
                            case "89"://9i
                            case "90":
                                items = new ListItem("Tổng hợp", "0");
                                Ra_Detail_Total.Items.Add(items);
                                Ra_Detail_Total.SelectedValue = "0";
                                ch_options_TD.Visible = false;
                                break;
                            case "72"://1N
                            case "73"://1O
                            case "81"://1P
                            case "82"://9H
                            case "83"://1Q
                            case "84"://8D
                            case "85"://1R
                            case "86"://1S
                                items = new ListItem("Chi tiết", "1");
                                Ra_Detail_Total.Items.Add(items);
                                ch_options_TD.Visible = false;
                                break;
                            default:
                                items = new ListItem("Tổng hợp", "0");
                                Ra_Detail_Total.Items.Add(items);
                                items = new ListItem("Chi tiết", "1");
                                Ra_Detail_Total.Items.Add(items);
                                break;
                        }
                    }
                }
                else//khong phai vu tong hop
                {
                    Ra_Detail_Total.Width = 600;
                    switch (Drop_Options.SelectedValue)
                    {
                        case "79":
                        case "80":
                        case "90":
                            items = new ListItem("Tổng hợp", "0");
                            Ra_Detail_Total.Items.Add(items);
                            items = new ListItem("Tổng hợp ĐV trực thuộc", "3");
                            Ra_Detail_Total.Items.Add(items);
                            Ra_Detail_Total.SelectedValue = "0";
                            ch_options_TD.Visible = false;
                            break;
                        case "81"://1P
                        case "82"://9H
                        case "83"://1Q
                        case "84"://8D
                        case "85"://1R
                        case "86"://1S
                        case "73"://1O
                            items = new ListItem("Chi tiết", "1");
                            Ra_Detail_Total.Items.Add(items);
                            ch_options_TD.Visible = false;
                            break;
                        default:
                            items = new ListItem("Tổng hợp", "0");
                            Ra_Detail_Total.Items.Add(items);
                            items = new ListItem("Tổng hợp ĐV trực thuộc", "3");
                            Ra_Detail_Total.Items.Add(items);
                            items = new ListItem("Chi tiết", "1");
                            Ra_Detail_Total.Items.Add(items);
                            items = new ListItem("Chi tiết ĐV trực thuộc", "2");
                            Ra_Detail_Total.Items.Add(items);
                            break;
                    }

                    //}
                }
            }
            else //user admin hoặc trường hợp còn lại
            {
                if (Drop_object.SelectedValue == "H")
                {
                    Ra_Detail_Total.Width = 400;
                    switch (Drop_Options.SelectedValue)
                    {
                        case "25":
                        case "75"://9D
                        case "79":
                        case "80":
                        case "89"://9i
                        case "90":
                            items = new ListItem("Tổng hợp", "0");
                            Ra_Detail_Total.Items.Add(items);
                            items = new ListItem("Chi tiết ĐV trực thuộc", "2");
                            Ra_Detail_Total.Items.Add(items);
                            Ra_Detail_Total.SelectedValue = "0";
                            ch_options_TD.Visible = false;
                            break;
                        case "73"://1O
                        case "81"://1P
                        case "82"://9H
                        case "83"://1Q
                        case "84"://8D
                        case "85"://1R
                        case "86"://1S
                        case "72"://1N
                            items = new ListItem("Chi tiết", "1");
                            Ra_Detail_Total.Items.Add(items);
                            ch_options_TD.Visible = false;
                            break;
                        default:
                            items = new ListItem("Tổng hợp", "0");
                            Ra_Detail_Total.Items.Add(items);
                            items = new ListItem("Chi tiết ĐV trực thuộc", "2");
                            Ra_Detail_Total.Items.Add(items);
                            items = new ListItem("Chi tiết", "1");
                            Ra_Detail_Total.Items.Add(items);
                            break;
                    }
                }
                else if (Drop_object.SelectedValue == "CW")
                {
                    Ra_Detail_Total.Width = 600;
                    switch (Drop_Options.SelectedValue)
                    {
                        case "75"://9D
                        case "79":
                        case "80":
                        case "89"://9i
                        case "90":
                            items = new ListItem("Tổng hợp", "0");
                            Ra_Detail_Total.Items.Add(items);
                            items = new ListItem("Tổng hợp ĐV trực thuộc", "3");
                            Ra_Detail_Total.Items.Add(items);
                            Ra_Detail_Total.SelectedValue = "0";
                            ch_options_TD.Visible = false;
                            break;
                        case "81"://1P
                        case "82"://9H
                        case "83"://1Q
                        case "84"://8D
                        case "85"://1R
                        case "86"://1S
                        case "73"://1O
                            items = new ListItem("Chi tiết", "1");
                            Ra_Detail_Total.Items.Add(items);
                            ch_options_TD.Visible = false;
                            break;
                        default:
                            items = new ListItem("Tổng hợp", "0");
                            Ra_Detail_Total.Items.Add(items);
                            items = new ListItem("Tổng hợp ĐV trực thuộc", "3");
                            Ra_Detail_Total.Items.Add(items);
                            items = new ListItem("Chi tiết", "1");
                            Ra_Detail_Total.Items.Add(items);
                            items = new ListItem("Chi tiết ĐV trực thuộc", "2");
                            Ra_Detail_Total.Items.Add(items);
                            break;
                    }
                }
                else if (Drop_object.SelectedValue == "TW")
                {
                    Ra_Detail_Total.Width = 600;
                    switch (Drop_Options.SelectedValue)
                    {
                        case "79":
                        case "80":
                        case "90":
                            items = new ListItem("Tổng hợp", "0");
                            Ra_Detail_Total.Items.Add(items);
                            items = new ListItem("Tổng hợp ĐV trực thuộc", "3");
                            Ra_Detail_Total.Items.Add(items);
                            Ra_Detail_Total.SelectedValue = "0";
                            ch_options_TD.Visible = false;
                            break;
                        case "81"://1P
                        case "82"://9H
                        case "83"://1Q
                        case "84"://8D
                        case "85"://1R
                        case "86"://1S
                        case "73"://1O
                            items = new ListItem("Chi tiết", "1");
                            Ra_Detail_Total.Items.Add(items);
                            ch_options_TD.Visible = false;
                            break;
                        default:
                            items = new ListItem("Tổng hợp", "0");
                            Ra_Detail_Total.Items.Add(items);
                            items = new ListItem("Tổng hợp ĐV trực thuộc", "3");
                            Ra_Detail_Total.Items.Add(items);
                            items = new ListItem("Chi tiết", "1");
                            Ra_Detail_Total.Items.Add(items);
                            items = new ListItem("Chi tiết ĐV trực thuộc", "2");
                            Ra_Detail_Total.Items.Add(items);
                            break;
                    }

                }
                else if (Drop_object.SelectedValue == "T")
                {
                    Ra_Detail_Total.Width = 300;
                    switch (Drop_Options.SelectedValue)
                    {
                        case "25":
                        case "75"://9D
                        case "79":
                        case "80":
                        case "89"://9i
                        case "90":
                            items = new ListItem("Tổng hợp", "0");
                            Ra_Detail_Total.Items.Add(items);
                            Ra_Detail_Total.SelectedValue = "0";
                            ch_options_TD.Visible = false;
                            break;
                        case "72"://1N
                        case "73"://1O
                        case "81"://1P
                        case "82"://9H
                        case "83"://1Q
                        case "84"://8D
                        case "85"://1R
                        case "86"://1S
                            items = new ListItem("Chi tiết", "1");
                            Ra_Detail_Total.Items.Add(items);
                            ch_options_TD.Visible = false;
                            break;
                        default:
                            items = new ListItem("Tổng hợp", "0");
                            Ra_Detail_Total.Items.Add(items);
                            items = new ListItem("Chi tiết", "1");
                            Ra_Detail_Total.Items.Add(items);
                            break;
                    }

                }
            }
            Ra_Detail_Total.Items[0].Selected = true;
        }
        public void Get_Skin_Options()
        {
            Drop_Skin.Items.Clear();
            List<BL.THONGKE.Info.Functions> List_Functions = (List<BL.THONGKE.Info.Functions>)Session["Function_List_Shows"];
            int[] arsv = new int[10] { 18, 26, 32, 37, 42, 47, 53, 57, 61, 65 };
            //SELECT * FROM TC_FUNCTIONS TC WHERE TC.POSTION=1 and TC.ID_PARENT=0 and TC.ID <>1 ORDER BY TC.ID;
            int vsi = 0;
            foreach (BL.THONGKE.Info.Functions its in List_Functions)
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
        public void Get_Data_Cases()
        {
            txt_Case_shows.Text = String.Empty;
            hi_value_id_Cases.Value = String.Empty;
            BL.THONGKE.M_Cases M_Object = new BL.THONGKE.M_Cases();
            Int32 valusskin = 0;
            if (Drop_Skin.SelectedValue == "18")
            {
                string values = Drop_Options.SelectedValue;
                switch (values)
                {
                    case "66":
                    case "67":
                    case "74":
                        valusskin = 7;//Nhóm loại tội phạm "chung, tham nhũng, chức vụ"
                        break;
                    case "85":
                        valusskin = 9;//Nhóm loại tội phạm "tham nhũng, chức vụ"
                        break;
                    default:
                        break;
                }
            }
            if (Drop_Skin.SelectedValue == "26")
            {
                valusskin = 0;//dan su
            }
            if (Drop_Skin.SelectedValue == "32")
            {
                valusskin = 1;//hon nhan
            }
            if (Drop_Skin.SelectedValue == "37")
            {
                valusskin = 2;//kinh te
            }
            if (Drop_Skin.SelectedValue == "42")
            {
                valusskin = 3;//lao dong
            }
            if (Drop_Skin.SelectedValue == "47")
            {
                valusskin = 4;//hanh chinh
            }
            if (Drop_Skin.SelectedValue == "53")
            {
                valusskin = 5;//tuyen bo pha san
            }
            if (Drop_Skin.SelectedValue == "57")
            {
                valusskin = 11;//Áp dụng các biện pháp xử phạt hành chính
            }
            if (Drop_Skin.SelectedValue == "61")
            {
                valusskin = 14;//Đơn tư pháp -  6 loại án HS,DS,HNGĐ,KDTM,LĐ,HC
            }
            if (Drop_Skin.SelectedValue == "65")
            {
                //Mẫu thống kê khác
                string values = Drop_Options.SelectedValue;
                switch (values)
                {
                    case "69":
                    case "70":
                        valusskin = 8;//Ủy thác tư pháp vào Việt Nam - ra nước ngoài
                        break;
                    case "76":
                        valusskin = 14;// 6 loại án HS,DS,HNGĐ,KDTM,LĐ,HC
                        break;
                    case "77":
                        valusskin = 13;// Các biện pháp khẩn cấp tạm thời
                        break;
                    case "78":
                        valusskin = 10;// Các biện pháp khẩn cấp tạm thời
                        break;
                    case "82":
                        valusskin = 6;// Nhóm giải quyết yêu cầu bồi thường
                        break;
                    default:
                        break;
                }
            }
            List<BL.THONGKE.Info.Cases> List_Cases = M_Object.Cases_List_Exports(Convert.ToInt32(valusskin));
            //RT_Cases.DataFieldID = "ID";
            //RT_Cases.DataValueField = "ID";
            //RT_Cases.DataFieldParentID = "PARENT_ID";
            //RT_Cases.DataTextField = "CASE_NAME";
            //RT_Cases.CausesValidation = false;
            //RT_Cases.DataSource = List_Cases;
            //RT_Cases.DataBind();
            BL.ThongKe.Info.TreeviewNode tvn = new BL.ThongKe.Info.TreeviewNode();
            List<BL.ThongKe.Info.TreeviewNode> tvns = tvn.getCasesNode(List_Cases);
            Treeview_Load(RT_Cases, null, tvns);
        }
        protected void cmd_Ok_s_Click(object sender, EventArgs e)
        {
            if (Drop_Skin.SelectedValue == "18")
            {

                if (Drop_Options.SelectedValue == "19")
                {
                    //---------------Export hinh su so tham ca nhan pham toi
                    Ex_Drop_Options_0();
                }
                if (Drop_Options.SelectedValue == "68")
                {
                    //---------------Export hinh su so tham pháp nhân thương mại phạm tội
                    Ex_Drop_Options_0_PN();
                }
                if (Drop_Options.SelectedValue == "20")
                {
                    //---------------Export hinh sự pt ca nhan pham toi 
                    Ex_Drop_Options_Appeals();
                }
                if (Drop_Options.SelectedValue == "71")
                {
                    //---------------Export hinh sự pt phap nhan pham toi
                    Ex_Drop_Options_Appeals_PN();
                }
                if (Drop_Options.SelectedValue == "21")
                {
                    //---------------Export hinh sự GDT ca nhan
                    Ex_Drop_Options_Cassation();
                }
                if (Drop_Options.SelectedValue == "87")
                {
                    //---------------Export hinh sự GDT PN
                    Ex_Drop_Options_Cassation_PN();
                }
                if (Drop_Options.SelectedValue == "22")
                {
                    //---------------Export hinh sự TT CN
                    Ex_Drop_Options_Retrials();
                }
                if (Drop_Options.SelectedValue == "88")
                {
                    //---------------Export hinh sự TT PN
                    Ex_Drop_Options_Retrials_PN();
                }
                if (Drop_Options.SelectedValue == "23")
                {
                    //---------------Export hinh sự TT ĐB
                    Ex_Drop_Options_Special();
                }
                if (Drop_Options.SelectedValue == "24")
                {
                    //---------------Export hinh sự bị cáo là người chưa thành niên
                    Ex_Drop_Options_Youth_Instance();
                }
                if (Drop_Options.SelectedValue == "25")
                {
                    //---------------Export ket qua thi hanh an hinh su
                    Ex_Drop_Options_Criminal_Results();
                }
                if (Drop_Options.SelectedValue == "66")
                {
                    //---------------Export 1H
                    Ex_Drop_Options_1H();
                }
                if (Drop_Options.SelectedValue == "67")
                {
                    //---------------Export 1i
                    Ex_Drop_Options_1i();
                }
                if (Drop_Options.SelectedValue == "74")
                {
                    //---------------Export 1K
                    Ex_Drop_Options_1k();
                }
                if (Drop_Options.SelectedValue == "79")
                {
                    //---------------Export 1L
                    Ex_Drop_Options_1L();
                }
                if (Drop_Options.SelectedValue == "80")
                {
                    //---------------Export 1M
                    Ex_Drop_Options_1M();
                }
                if (Drop_Options.SelectedValue == "73")
                {
                    //---------------Export 1O
                    Ex_Drop_Options_1O();
                }
                if (Drop_Options.SelectedValue == "72")
                {
                    //---------------Export 1O
                    Ex_Drop_Options_1N();
                }
                if (Drop_Options.SelectedValue == "81")
                {
                    //---------------Export 1O
                    Ex_Drop_Options_1P();
                }
                if (Drop_Options.SelectedValue == "83")
                {
                    //---------------Export 1O
                    Ex_Drop_Options_1Q();
                }
                if (Drop_Options.SelectedValue == "85")
                {
                    //---------------Export 1O
                    Ex_Drop_Options_1R();
                }
                if (Drop_Options.SelectedValue == "86")
                {
                    //---------------Export 1O
                    Ex_Drop_Options_1S();
                }
            }
            else if (Drop_Skin.SelectedValue == "26")
            {
                if (Drop_Options.SelectedValue == "27")
                {
                    //---------------Export dan su st 
                    Ex_Drop_Options_Civils_Instances();
                }
                if (Drop_Options.SelectedValue == "28")
                { //---------------Export dan su pt
                    Ex_Drop_Options_Civil_Appeals();
                }
                if (Drop_Options.SelectedValue == "29")
                { //---------------Export dan su GĐT
                    Ex_Drop_Options_Civil_Cassation();
                }
                if (Drop_Options.SelectedValue == "30")
                { //---------------Export dan su TT
                    Ex_Drop_Options_Civil_Retrials();
                }
                if (Drop_Options.SelectedValue == "31")
                { //---------------Export dan su TT ĐB
                    Ex_Drop_Options_Civil_Special();
                }
            }
            else if (Drop_Skin.SelectedValue == "32")
            {
                if (Drop_Options.SelectedValue == "33")
                {
                    //---------------Export HNGD ST
                    Ex_Drop_Options_Marriges_Instances();
                }
                if (Drop_Options.SelectedValue == "34")
                {
                    //---------------Export HNGD PT
                    Ex_Drop_Options_Marriges_Appeals();
                }
                if (Drop_Options.SelectedValue == "35")
                {
                    //---------------Export HNGD GĐT
                    Ex_Drop_Options_Marriges_Cassation();
                }
                if (Drop_Options.SelectedValue == "36")
                {
                    //---------------Export HNGD TT
                    Ex_Drop_Options_Marriges_Retrials();
                }
            }
            else if (Drop_Skin.SelectedValue == "37")
            {
                if (Drop_Options.SelectedValue == "38")
                {
                    //---------------Export KT ST 
                    Ex_Drop_Options_Economics_Instances();
                }
                if (Drop_Options.SelectedValue == "39")
                {
                    //---------------Export KT PT
                    Ex_Drop_Options_Economics_Appeals();
                }
                if (Drop_Options.SelectedValue == "40")
                {
                    //---------------Export KT GĐT
                    Ex_Drop_Options_Economics_Cassation();
                }
                if (Drop_Options.SelectedValue == "41")
                {
                    //---------------Export KT TT
                    Ex_Drop_Options_Economics_Retrials();
                }
            }
            else if (Drop_Skin.SelectedValue == "42")
            {
                if (Drop_Options.SelectedValue == "43")
                {
                    //---------------Export Lao dong ST 
                    Ex_Drop_Options_Labors_Instances();
                }
                if (Drop_Options.SelectedValue == "44")
                {
                    //---------------Export Lao dong PT
                    Ex_Drop_Options_Labors_Appeals();
                }
                if (Drop_Options.SelectedValue == "46")
                {
                    //---------------Export Lao dong GĐT
                    Ex_Drop_Options_Labors_Cassation();
                }
                if (Drop_Options.SelectedValue == "45")
                {
                    //---------------Export Lao dong TT
                    Ex_Drop_Options_Labors_Retrials();
                }
            }
            else if (Drop_Skin.SelectedValue == "47")
            {
                if (Drop_Options.SelectedValue == "48")
                {
                    //---------------Export hanh chinh ST 
                    Ex_Drop_Options_Admin_Instances();
                }
                if (Drop_Options.SelectedValue == "49")
                {
                    //---------------Export hanh chinh PT
                    Ex_Drop_Options_Admin_Appeals();
                }
                if (Drop_Options.SelectedValue == "50")
                {
                    //---------------Export hanh chinh GĐT
                    Ex_Drop_Options_Admin_Cassation();
                }
                if (Drop_Options.SelectedValue == "51")
                {
                    //---------------Export hanh chinh GĐT
                    Ex_Drop_Options_Admin_Retrials();
                }
                if (Drop_Options.SelectedValue == "52")
                {
                    //---------------Export hanh chinh TTĐB
                    Ex_Drop_Options_Admin_Special();
                }
            }
            else if (Drop_Skin.SelectedValue == "57")
            {
                if (Drop_Options.SelectedValue == "58")
                {
                    Ex_Drop_Options_7A();
                }
                else if (Drop_Options.SelectedValue == "59")
                {
                    Ex_Drop_Options_7B();
                }
                else if (Drop_Options.SelectedValue == "60")
                {
                    Ex_Drop_Options_7C();
                }
            }
            else if (Drop_Skin.SelectedValue == "61")
            {
                if (Drop_Options.SelectedValue == "62")
                {
                    //---------------Export 8A
                    Ex_Drop_Options_8A();
                }
                else if (Drop_Options.SelectedValue == "63")
                {
                    Ex_Drop_Options_8B();
                }
                else if (Drop_Options.SelectedValue == "64")
                {
                    Ex_Drop_Options_8C();
                }
                else if (Drop_Options.SelectedValue == "84")
                {
                    Ex_Drop_Options_8D();
                }

            }
            else if (Drop_Skin.SelectedValue == "65")
            {
                if (Drop_Options.SelectedValue == "69")
                {
                    //---------------Export 9C
                    Ex_Drop_Options_9A();
                }
                if (Drop_Options.SelectedValue == "70")
                {
                    //---------------Export 9C
                    Ex_Drop_Options_9B();
                }
                if (Drop_Options.SelectedValue == "90")
                {
                    //---------------Export 9C
                    Ex_Drop_Options_9C();
                }
                if (Drop_Options.SelectedValue == "75")
                {
                    //---------------Export 9C
                    Ex_Drop_Options_9D();
                }


                if (Drop_Options.SelectedValue == "89")
                {
                    //---------------Export 9C
                    Ex_Drop_Options_9i();
                }
                if (Drop_Options.SelectedValue == "78")
                {
                    //---------------Export 9G
                    Ex_Drop_Options_9G();
                }
                if (Drop_Options.SelectedValue == "82")
                {
                    //---------------Export 9G
                    Ex_Drop_Options_9H();
                }
                if (Drop_Options.SelectedValue == "76")
                {
                    //---------------Export 9G
                    Ex_Drop_Options_9E();
                }
                if (Drop_Options.SelectedValue == "77")
                {
                    //---------------Export 9G
                    Ex_Drop_Options_9F();
                }
            }
            else if (Drop_Skin.SelectedValue == "53")
            {
                if (Drop_Options.SelectedValue == "54")
                {
                    Ex_Drop_Options_4E();
                }
                if (Drop_Options.SelectedValue == "55")
                {
                    Ex_Drop_Options_4F();
                }
                if (Drop_Options.SelectedValue == "56")
                {
                    Ex_Drop_Options_4G();
                }
            }
        }
        //---------------Export hinh su ------------------------------------
        public void Ex_Drop_Options_0()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_typecourts = Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString());
            String v_criminal = hi_value_id_criminal.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            String v_filename = "";
            if (v_typecourts == "2")
            {
                sth = 1;//option toa quan su
            }
            if (Drop_object.SelectedValue == "H")
            {
                if (Vleustype == "H")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                    hi_text_courts.Value = "Số liệu từ các Quận/Huyện: ";
                }
                else if (Vleustype == "T")
                {
                    v_options = 2;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    else
                    {
                        v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    }
                    v_Names = "CÁC HUYỆN " + Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC HUYỆN";
                }
            }
            else if (Drop_object.SelectedValue == "T")
            {
                if (Vleustype == "T")
                {
                    v_options = 1;
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC TỈNH";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Judge_Criminal M_Objecs = new M_Judge_Criminal();
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=HSST_TD.xls");
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
            else
            {
                if (Ra_Detail_Total.SelectedValue == "1")
                {
                    if ((Vleustype == "T") || (Vleustype == "H"))
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=HSST_Detai_District.xls");
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
                    else
                    { //khi la user vu tong hop

                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        if (Drop_object.SelectedValue == "H")
                        {
                            v_filename = "HSST_DETAIL_ALL_01";
                            li_sw = M_Objecs.Judge_Export_Detail_All_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        else
                        {
                            v_filename = "HSST_DETAIL_DISTRICT";
                            li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=" + v_filename + ".xls");
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
                if (Ra_Detail_Total.SelectedValue == "2")//chỉ vụ tổng hợp mới dùng
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_All(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HSST_Detai_All_01.xls");
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
                else//tổng hợp 
                {
                    //Cấp huyện hoặc cấp tỉnh
                    if ((Vleustype == "T") || (Vleustype == "H"))
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=HSST_Total_District.xls");
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
                    else //vụ tổng họp
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        if (Drop_object.SelectedValue == "H")
                        {
                            v_filename = "HSST_TOTAL_63";
                            li_sw = M_Objecs.Judge_Export_Total_All_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        else
                        {
                            v_filename = "HSST_TOTAL_DIS_63";
                            li_sw = M_Objecs.Judge_Export_Total_District_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        #region Lay bao cao tong hop
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=" + v_filename + ".xls");
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
        }
        public void Ex_Drop_Options_0_PN()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_typecourts = Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString());
            String v_criminal = hi_value_id_criminal.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (v_typecourts == "2")
            {
                sth = 1;//option toa quan su
            }
            if (Drop_object.SelectedValue == "H")
            {
                if (Vleustype == "H")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                    hi_text_courts.Value = "Số liệu từ các Quận/Huyện: ";
                }
                else if (Vleustype == "T")
                {
                    v_options = 2;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    else
                    {
                        v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    }
                    v_Names = "CÁC HUYỆN " + Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC HUYỆN";
                }
            }
            else if (Drop_object.SelectedValue == "T")
            {
                if (Vleustype == "T")
                {
                    v_options = 1;
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC TỈNH";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Criminal_Instan_Com M_Objecs = new M_Criminal_Instan_Com();
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=HSST_TD_PN.xls");
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
            else
            {
                if (Ra_Detail_Total.SelectedValue == "1")
                {
                    if ((Vleustype == "T") || (Vleustype == "H"))
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=HSST_Detai_District_PN.xls");
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
                    else
                    { //khi la user vu tong hop

                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        if (Drop_object.SelectedValue == "H")
                        {
                            li_sw = M_Objecs.Judge_Export_Detail_All_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        else
                        {
                            li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=HSST_Detai_All_01_PN.xls");
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
                if (Ra_Detail_Total.SelectedValue == "2")//chỉ vụ tổng hợp mới dùng
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_All(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HSST_Detai_All_PN.xls");
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
                else//tổng hợp 
                {
                    //Cấp huyện hoặc cấp tỉnh
                    if ((Vleustype == "T") || (Vleustype == "H"))
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=HSST_Total_District_PN.xls");
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
                    else //vụ tổng họp
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        if (Drop_object.SelectedValue == "H")
                        {
                            li_sw = M_Objecs.Judge_Export_Total_All_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        else
                        {
                            li_sw = M_Objecs.Judge_Export_Total_District_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        #region Lay bao cao tong hop
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=HSST_Total_All_PN.xls");
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
        }
        public void Ex_Drop_Options_Appeals()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_typecourts = Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString());
            String v_criminal = hi_value_id_criminal.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (v_typecourts == "2")
            {
                sth = 1;//option toa quan su
            }
            if (Drop_object.SelectedValue == "T")
            {
                if (Vleustype == "T")
                {
                    v_options = 1;
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                    hi_text_courts.Value = "Số liệu từ các Tỉnh/TP: ";
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC TỈNH";
                    hi_text_courts.Value = "Số liệu từ các Tỉnh/TP: ";
                }
            }
            else if (Drop_object.SelectedValue == "CW")
            {
                if (Vleustype == "CW")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_Names = "CÁC TÒA ÁN CẤP CAO";
                    hi_text_courts.Value = "Số liệu từ các tòa án CC: ";
                    v_court = Hi_value_ID_Court.Value;
                }
            }
            else if (Drop_object.SelectedValue == "TW")
            {
                if ((Vleustype == "TW") && (Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString()) != "1"))
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    v_Names = "CÁC TÒA ÁN TỐI CAO";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Criminal_Appeals M_Objecs = new M_Criminal_Appeals();
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=HSPT_TD.xls");
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
            else
            {
                if (Ra_Detail_Total.SelectedValue == "1")
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HSPT_Detai_District.xls");
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
                if (Ra_Detail_Total.SelectedValue == "2")//Cả tòa cấp cao, toi cao và vụ tổng hợp đều dùng
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District_CW(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet các tỉnh trực thuộc cấp cao
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HSPT_Detai_District_cw.xls");
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
                if (Ra_Detail_Total.SelectedValue == "3")// Tổng hợp 1
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HSST_Total_District_01.xls");
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
                else //tong hop
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HSST_Total_District.xls");
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
        public void Ex_Drop_Options_Appeals_PN()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_typecourts = Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString());
            String v_criminal = hi_value_id_criminal.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (v_typecourts == "2")
            {
                sth = 1;//option toa quan su
            }
            if (Drop_object.SelectedValue == "T")
            {
                if (Vleustype == "T")
                {
                    v_options = 1;
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                    hi_text_courts.Value = "Số liệu từ các Tỉnh/TP: ";
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC TỈNH";
                    hi_text_courts.Value = "Số liệu từ các Tỉnh/TP: ";
                }
            }
            else if (Drop_object.SelectedValue == "CW")
            {
                if (Vleustype == "CW")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_Names = "CÁC TÒA ÁN CẤP CAO";
                    hi_text_courts.Value = "Số liệu từ các tòa án CC: ";
                    v_court = Hi_value_ID_Court.Value;
                }
            }
            else if (Drop_object.SelectedValue == "TW")
            {
                if ((Vleustype == "TW") && (Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString()) != "1"))
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    v_Names = "CÁC TÒA ÁN TỐI CAO";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Criminal_Appea_Com M_Objecs = new M_Criminal_Appea_Com();
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=HSPT_TD_PN.xls");
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
            else
            {
                if (Ra_Detail_Total.SelectedValue == "1")
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HSPT_Detai_District_PN.xls");
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
                if (Ra_Detail_Total.SelectedValue == "2")//Cả tòa cấp cao, toi cao và vụ tổng hợp đều dùng
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District_CW(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet các tỉnh trực thuộc cấp cao
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HSPT_Detai_District_CW_PN.xls");
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
                if (Ra_Detail_Total.SelectedValue == "3")// Tổng hợp 1
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HSPT_Total_District_01_PN.xls");
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
                else //tong hop
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HSPT_Total_District_PN.xls");
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
        public void Ex_Drop_Options_Cassation()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_criminal = hi_value_id_criminal.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (Drop_object.SelectedValue == "CW")
            {
                if (Vleustype == "CW")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_Names = "CÁC TÒA ÁN CẤP CAO";
                    hi_text_courts.Value = "Số liệu từ các tòa án CC: ";
                    v_court = Hi_value_ID_Court.Value;
                }
            }
            else if (Drop_object.SelectedValue == "TW")
            {
                if ((Vleustype == "TW") && (Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString()) != "1"))
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    v_Names = "CÁC TÒA ÁN TỐI CAO";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Criminal_Cassation M_Objecs = new M_Criminal_Cassation();
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=HSGDT_TD.xls");
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
            else
            {
                if (Ra_Detail_Total.SelectedValue == "1")
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HSGDT_Detai_District.xls");
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
                if (Ra_Detail_Total.SelectedValue == "2")//Cả tòa cấp cao, toi cao và vụ tổng hợp đều dùng
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District_CW(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet các tỉnh trực thuộc cấp cao
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HSGDT_Detai_District_cw.xls");
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
                if (Ra_Detail_Total.SelectedValue == "3")// Tổng hợp 1
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HSGDT_Total_District_01.xls");
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
                else //tong hop
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HSGDT_Total_District.xls");
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
        public void Ex_Drop_Options_Cassation_PN()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_criminal = hi_value_id_criminal.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (Drop_object.SelectedValue == "CW")
            {
                if (Vleustype == "CW")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_Names = "CÁC TÒA ÁN CẤP CAO";
                    hi_text_courts.Value = "Số liệu từ các tòa án CC: ";
                    v_court = Hi_value_ID_Court.Value;
                }
            }
            else if (Drop_object.SelectedValue == "TW")
            {
                if ((Vleustype == "TW") && (Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString()) != "1"))
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    v_Names = "CÁC TÒA ÁN TỐI CAO";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Criminal_Cassati_Com M_Objecs = new M_Criminal_Cassati_Com();
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=HSGDT_TD_PN.xls");
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
            else
            {
                if (Ra_Detail_Total.SelectedValue == "1")
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HSGDT_Detai_Dis_PN.xls");
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
                if (Ra_Detail_Total.SelectedValue == "2")//Cả tòa cấp cao, toi cao và vụ tổng hợp đều dùng
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District_CW(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet các tỉnh trực thuộc cấp cao
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HSGDT_Detai_Dis_CW_PN.xls");
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
                if (Ra_Detail_Total.SelectedValue == "3")// Tổng hợp 1
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HSGDT_Total_Dis_01_PN.xls");
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
                else //tong hop
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HSGDT_Total_Dis_PN.xls");
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
        public void Ex_Drop_Options_Retrials()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_criminal = hi_value_id_criminal.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (Drop_object.SelectedValue == "CW")
            {
                if (Vleustype == "CW")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_Names = "CÁC TÒA ÁN CẤP CAO";
                    hi_text_courts.Value = "Số liệu từ các tòa án CC: ";
                    v_court = Hi_value_ID_Court.Value;
                }
            }
            else if (Drop_object.SelectedValue == "TW")
            {
                if ((Vleustype == "TW") && (Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString()) != "1"))
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    v_Names = "CÁC TÒA ÁN TỐI CAO";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Criminal_Retrials M_Objecs = new M_Criminal_Retrials();
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=HSTT_TD.xls");
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
            else
            {
                if (Ra_Detail_Total.SelectedValue == "1")
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HSTT_Detai_Dis.xls");
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
                if (Ra_Detail_Total.SelectedValue == "2")//Cả tòa cấp cao, toi cao và vụ tổng hợp đều dùng
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District_CW(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet các tỉnh trực thuộc cấp cao
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HSTT_Detai_Dis_CW.xls");
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
                if (Ra_Detail_Total.SelectedValue == "3")// Tổng hợp 1
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HSTT_Total_Dis_01.xls");
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
                else //tong hop
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HSTT_Total_Dis.xls");
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
        public void Ex_Drop_Options_Retrials_PN()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_criminal = hi_value_id_criminal.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (Drop_object.SelectedValue == "CW")
            {
                if (Vleustype == "CW")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_Names = "CÁC TÒA ÁN CẤP CAO";
                    hi_text_courts.Value = "Số liệu từ các tòa án CC: ";
                    v_court = Hi_value_ID_Court.Value;
                }
            }
            else if (Drop_object.SelectedValue == "TW")
            {
                if ((Vleustype == "TW") && (Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString()) != "1"))
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    v_Names = "CÁC TÒA ÁN TỐI CAO";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Criminal_Retria_Com M_Objecs = new M_Criminal_Retria_Com();
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=HSTT_TD_PN.xls");
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
            else
            {
                if (Ra_Detail_Total.SelectedValue == "1")
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HSTT_Detai_Dis_PN.xls");
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
                if (Ra_Detail_Total.SelectedValue == "2")//Cả tòa cấp cao, toi cao và vụ tổng hợp đều dùng
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District_CW(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet các tỉnh trực thuộc cấp cao
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HSTT_Detai_Dis_CW_PN.xls");
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
                if (Ra_Detail_Total.SelectedValue == "3")// Tổng hợp 1
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HSTT_Total_Dis_01_PN.xls");
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
                else //tong hop
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HSTT_Total_Dis_PN.xls");
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
        public void Ex_Drop_Options_Special()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_criminal = hi_value_id_criminal.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (Drop_object.SelectedValue == "TW")
            {
                if ((Vleustype == "TW") && (Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString()) != "1"))
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    v_Names = "CÁC TÒA ÁN TỐI CAO";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Criminal_Special M_Objecs = new M_Criminal_Special();
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=HS_TTĐB_TD.xls");
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
            else
            {
                if (Ra_Detail_Total.SelectedValue == "1")
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HS_TTĐB_Detai_Dis.xls");
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
                if (Ra_Detail_Total.SelectedValue == "2")//Cả tòa cấp cao, toi cao và vụ tổng hợp đều dùng
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District_CW(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet các tỉnh trực thuộc cấp cao
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HS_TTĐB_Detai_Dis_CW.xls");
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
                if (Ra_Detail_Total.SelectedValue == "3")// Tổng hợp 1
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HS_TTĐB_Total_Dis_01.xls");
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
                else //tong hop
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HS_TTĐB_Total_Dis.xls");
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
        public void Ex_Drop_Options_Youth_Instance()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_typecourts = Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString());
            String v_criminal = hi_value_id_criminal.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (v_typecourts == "2")
            {
                sth = 1;//option toa quan su
            }
            if (Drop_object.SelectedValue == "H")
            {
                if (Vleustype == "H")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                    hi_text_courts.Value = "Số liệu từ các Quận/Huyện: ";
                }
                else if (Vleustype == "T")
                {
                    v_options = 2;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    else
                    {
                        v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    }
                    v_Names = "CÁC HUYỆN " + Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC HUYỆN";
                }
            }
            else if (Drop_object.SelectedValue == "T")
            {
                if (Vleustype == "T")
                {
                    v_options = 1;
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC TỈNH";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Youth_Instance M_Objecs = new M_Youth_Instance();
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=BC_NCTN_TD.xls");
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
            else
            {
                if (Ra_Detail_Total.SelectedValue == "1")
                {
                    if ((Vleustype == "T") || (Vleustype == "H"))
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=BC_NCTN_Detai_District.xls");
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
                    else
                    { //khi la user vu tong hop

                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        if (Drop_object.SelectedValue == "H")
                        {
                            li_sw = M_Objecs.Judge_Export_Detail_All_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        else
                        {
                            li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=BC_NCTN_Detai_All.xls");
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
                if (Ra_Detail_Total.SelectedValue == "2")//chỉ vụ tổng hợp mới dùng
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_All(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=BC_NCTN_Detai_All_01.xls");
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
                else//tổng hợp 
                {
                    //Cấp huyện hoặc cấp tỉnh
                    if ((Vleustype == "T") || (Vleustype == "H"))
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=BC_NCTN_Total_District.xls");
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
                    else //vụ tổng họp
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        if (Drop_object.SelectedValue == "H")
                        {
                            li_sw = M_Objecs.Judge_Export_Total_All_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        else
                        {
                            li_sw = M_Objecs.Judge_Export_Total_District_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        #region Lay bao cao tong hop
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=BC_NCTN_Total_All.xls");
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
        }
        public void Ex_Drop_Options_Criminal_Results()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_criminal = hi_value_id_criminal.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (Drop_object.SelectedValue == "H")
            {
                if (Vleustype == "H")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                    hi_text_courts.Value = "Số liệu từ các Quận/Huyện: ";
                }
                else if (Vleustype == "T")
                {
                    v_options = 2;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    else
                    {
                        v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    }
                    v_Names = "CÁC HUYỆN " + Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC HUYỆN";
                }
            }
            else if (Drop_object.SelectedValue == "T")
            {
                if (Vleustype == "T")
                {
                    v_options = 1;
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC TỈNH";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Criminal_Results M_Objecs = new M_Criminal_Results();
            if (Ra_Detail_Total.SelectedValue == "0")// Tổng hợp 1
            {
                if ((Vleustype == "T") || (Vleustype == "H"))
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=KQ_THA_Total_District.xls");
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
                else //vụ tổng họp
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    if (Drop_object.SelectedValue == "H")
                    {
                        li_sw = M_Objecs.Judge_Export_Total_All_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    }
                    else
                    {
                        li_sw = M_Objecs.Judge_Export_Total_District_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    }
                    #region Lay bao cao tong hop
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=KQ_THA_Total_All.xls");
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
            if (Ra_Detail_Total.SelectedValue == "2")//chỉ vụ tổng hợp mới dùng
            {//chi tiết đơn vị trực thuộc
                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_Detail_All(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_criminal, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region Lay bao cao chi tiet cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=KQ_THA_Detai_All.xls");
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
        //---------------Export hinh su end------------------------------
        //---------------Export 1... ------------------------------------
        public void Ex_Drop_Options_1H()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_typecourts = Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (v_typecourts == "2")
            {
                sth = 1;//option toa quan su
            }
            if (Drop_object.SelectedValue == "H")
            {
                if (Vleustype == "H")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                    hi_text_courts.Value = "Số liệu từ các Quận/Huyện: ";
                }
                else if (Vleustype == "T")
                {
                    v_options = 2;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    else
                    {
                        v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    }
                    v_Names = "CÁC HUYỆN " + Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC HUYỆN";
                }
            }
            else if (Drop_object.SelectedValue == "T")
            {
                if (Vleustype == "T")
                {
                    v_options = 1;
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC TỈNH";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Probation1H M_Objecs = new M_Probation1H();
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=1H_TD.xls");
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
            else
            {//chi tiet
                if (Ra_Detail_Total.SelectedValue == "1")
                {
                    if ((Vleustype == "T") || (Vleustype == "H"))
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=1H_Detai_District.xls");
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
                    else
                    { //khi la user vu tong hop

                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        if (Drop_object.SelectedValue == "H")
                        {
                            li_sw = M_Objecs.Judge_Export_Detail_All_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        else
                        {
                            li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=1H_Detai_All_01.xls");
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
                if (Ra_Detail_Total.SelectedValue == "2")//chỉ vụ tổng hợp mới dùng
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_All(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=1H_Detai_All.xls");
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
                else//tổng hợp 
                {
                    //Cấp huyện hoặc cấp tỉnh
                    if ((Vleustype == "T") || (Vleustype == "H"))
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=1H_Total_District.xls");
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
                    else //vụ tổng họp
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        if (Drop_object.SelectedValue == "H")
                        {
                            li_sw = M_Objecs.Judge_Export_Total_All_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        else
                        {
                            li_sw = M_Objecs.Judge_Export_Total_District_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        #region Lay bao cao tong hop
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=1H_Total_63.xls");
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
        }
        public void Ex_Drop_Options_1i()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_typecourts = Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (v_typecourts == "2")
            {
                sth = 1;//option toa quan su
            }
            if (Drop_object.SelectedValue == "T")
            {
                if (Vleustype == "T")
                {
                    v_options = 1;
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                    hi_text_courts.Value = "Số liệu từ các Tỉnh/TP: ";
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC TỈNH";
                    hi_text_courts.Value = "Số liệu từ các Tỉnh/TP: ";
                }
            }
            else if (Drop_object.SelectedValue == "CW")
            {
                if (Vleustype == "CW")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_Names = "CÁC TÒA ÁN CẤP CAO";
                    hi_text_courts.Value = "Số liệu từ các tòa án CC: ";
                    v_court = Hi_value_ID_Court.Value;
                }
            }
            else if (Drop_object.SelectedValue == "TW")
            {
                if ((Vleustype == "TW") && (Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString()) != "1"))
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    v_Names = "CÁC TÒA ÁN TỐI CAO";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Probation1I M_Objecs = new M_Probation1I();
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=1i_TD.xls");
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
            else
            {
                if (Ra_Detail_Total.SelectedValue == "0")// Tổng hợp 1
                {
                    if (Vleustype == "T")
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=1i_Total_District.xls");
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
                    else //vụ tổng họp
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        if (Drop_object.SelectedValue == "T")
                        {
                            li_sw = M_Objecs.Judge_Export_Total_District_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        else// if (Drop_object.SelectedValue == "CW" || Drop_object.SelectedValue == "TW")
                        {
                            li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        #region Lay bao cao tong hop
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=1i_Total_All.xls");
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
                else if (Ra_Detail_Total.SelectedValue == "1")
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=1i_Detai_District.xls");
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
                else if (Ra_Detail_Total.SelectedValue == "2")//Cả tòa cấp cao, toi cao và vụ tổng hợp đều dùng
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District_CW(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet các tỉnh trực thuộc cấp cao
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=1i_Detai_District_cw.xls");
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
                else if (Ra_Detail_Total.SelectedValue == "3")// Tổng hợp 1
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=1i_Total_District_01.xls");
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
        public void Ex_Drop_Options_1k()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_typecourts = Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (v_typecourts == "2")
            {
                sth = 1;//option toa quan su
            }
            if (Drop_object.SelectedValue == "H")
            {
                if (Vleustype == "H")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                    hi_text_courts.Value = "Số liệu từ các Quận/Huyện: ";
                }
                else if (Vleustype == "T")
                {
                    v_options = 2;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    else
                    {
                        v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    }
                    v_Names = "CÁC HUYỆN " + Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC HUYỆN";
                }
            }
            else if (Drop_object.SelectedValue == "T")
            {
                if (Vleustype == "T")
                {
                    v_options = 1;
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC TỈNH";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Probation1K M_Objecs = new M_Probation1K();
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=1k_TD.xls");
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
            else
            {//chi tiet
                if (Ra_Detail_Total.SelectedValue == "1")
                {
                    if ((Vleustype == "T") || (Vleustype == "H"))
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=1k_Detai_District.xls");
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
                    else
                    { //khi la user vu tong hop

                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        if (Drop_object.SelectedValue == "H")
                        {
                            li_sw = M_Objecs.Judge_Export_Detail_All_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        else
                        {
                            li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=1k_Detai_All_01.xls");
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
                if (Ra_Detail_Total.SelectedValue == "2")//chỉ vụ tổng hợp mới dùng
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_All(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=1k_Detai_All.xls");
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
                else//tổng hợp 
                {
                    //Cấp huyện hoặc cấp tỉnh
                    if ((Vleustype == "T") || (Vleustype == "H"))
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=1k_Total_District.xls");
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
                    else //vụ tổng họp
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        if (Drop_object.SelectedValue == "H")
                        {
                            li_sw = M_Objecs.Judge_Export_Total_All_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        else
                        {
                            li_sw = M_Objecs.Judge_Export_Total_District_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        #region Lay bao cao tong hop
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=1k_Total_63.xls");
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
        }
        public void Ex_Drop_Options_1L()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_typecourts = Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (v_typecourts == "2")
            {
                sth = 1;//option toa quan su
            }
            if (Drop_object.SelectedValue == "H")
            {
                if (Vleustype == "H")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                    hi_text_courts.Value = "Số liệu từ các Quận/Huyện: ";
                }
                else if (Vleustype == "T")
                {
                    v_options = 2;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    else
                    {
                        v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    }
                    v_Names = "CÁC HUYỆN " + Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC HUYỆN";
                }
            }
            else if (Drop_object.SelectedValue == "T")
            {
                if (Vleustype == "T")
                {
                    v_options = 1;
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC TỈNH";
                }
            }
            else if (Drop_object.SelectedValue == "CW")
            {
                if (Vleustype == "CW")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_Names = "CÁC TÒA ÁN CẤP CAO";
                    hi_text_courts.Value = "Số liệu từ các tòa án CC: ";
                    v_court = Hi_value_ID_Court.Value;
                }
            }
            else if (Drop_object.SelectedValue == "TW")
            {
                if ((Vleustype == "TW") && (Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString()) != "1"))
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    v_Names = "CÁC TÒA ÁN TỐI CAO";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Violates1L M_Objecs = new M_Violates1L();
            if (Ra_Detail_Total.SelectedValue == "0")// Tổng hợp 1
            {
                //if (((Vleustype == "T") || (Vleustype == "H") || (Vleustype == "CW") || (Vleustype == "TW") && v_typecourts != "1"))
                if ((Vleustype == "T") || (Vleustype == "H"))
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=1L_Total_District.xls");
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
                else //vụ tổng họp
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    if (Drop_object.SelectedValue == "H")
                    {
                        li_sw = M_Objecs.Judge_Export_Total_All_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    }
                    else if (Drop_object.SelectedValue == "T")
                    {
                        li_sw = M_Objecs.Judge_Export_Total_District_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    }
                    else
                    //if (Drop_object.SelectedValue == "CW" || Drop_object.SelectedValue == "TW")
                    {
                        li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    }
                    #region Lay bao cao tong hop
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=1L_Total_All_63.xls");
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
            if (Ra_Detail_Total.SelectedValue == "2")//chỉ vụ tổng hợp mới dùng
            {//chi tiết đơn vị trực thuộc
                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_Detail_All(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region Lay bao cao chi tiet cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=1L_Detai_All.xls");
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
            if (Ra_Detail_Total.SelectedValue == "3")// Tổng hợp ĐV trực thuộc
            {
                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_Total_District_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region Lay bao cao chi tiet cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=1L_Total_District_01.xls");
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
        public void Ex_Drop_Options_1M()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_typecourts = Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            String v_filename = "";
            if (v_typecourts == "2")
            {
                sth = 1;//option toa quan su
            }
            if (Drop_object.SelectedValue == "H")
            {
                if (Vleustype == "H")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                    hi_text_courts.Value = "Số liệu từ các Quận/Huyện: ";
                }
                else if (Vleustype == "T")
                {
                    v_options = 2;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    else
                    {
                        v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    }
                    v_Names = "CÁC HUYỆN " + Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC HUYỆN";
                }
            }
            else if (Drop_object.SelectedValue == "T")
            {
                if (Vleustype == "T")
                {
                    v_options = 1;
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC TỈNH";
                }
            }
            else if (Drop_object.SelectedValue == "CW")
            {
                if (Vleustype == "CW")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_Names = "CÁC TÒA ÁN CẤP CAO";
                    hi_text_courts.Value = "Số liệu từ các tòa án CC: ";
                    v_court = Hi_value_ID_Court.Value;
                }
            }
            else if (Drop_object.SelectedValue == "TW")
            {
                if ((Vleustype == "TW") && (Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString()) != "1"))
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    v_Names = "CÁC TÒA ÁN TỐI CAO";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Drug_Inspection1M M_Objecs = new M_Drug_Inspection1M();
            if (Ra_Detail_Total.SelectedValue == "0")// Tổng hợp 1
            {
                //if (((Vleustype == "T") || (Vleustype == "H") || (Vleustype == "CW") || (Vleustype == "TW") && v_typecourts != "1"))
                if ((Vleustype == "T") || (Vleustype == "H"))
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=1M_Total_District.xls");
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
                else //vụ tổng họp
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    if (Drop_object.SelectedValue == "H")
                    {
                        v_filename = "1M_Total_All_63.xls";
                        li_sw = M_Objecs.Judge_Export_Total_All_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    }
                    else if (Drop_object.SelectedValue == "T")
                    {
                        v_filename = "1M_Total_All_Dis_63.xls";
                        li_sw = M_Objecs.Judge_Export_Total_District_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    }
                    else //if (Drop_object.SelectedValue == "CW" || Drop_object.SelectedValue == "TW")
                    {
                        v_filename = "1M_Total_District.xls";
                        li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    }
                    #region Lay bao cao tong hop
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=" + v_filename);
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
            if (Ra_Detail_Total.SelectedValue == "2")//chỉ vụ tổng hợp mới dùng
            {//chi tiết đơn vị trực thuộc
                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_Detail_All(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region Lay bao cao chi tiet cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=1M_Detai_All.xls");
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
            if (Ra_Detail_Total.SelectedValue == "3")// Tổng hợp ĐV trực thuộc
            {
                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_Total_District_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region Lay bao cao chi tiet cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=1M_Total_District_01.xls");
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
        public void Ex_Drop_Options_1O()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_typecourts = Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (v_typecourts == "2")
            {
                sth = 1;//option toa quan su
            }
            if (Drop_object.SelectedValue == "H")
            {
                if (Vleustype == "H")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                    hi_text_courts.Value = "Số liệu từ các Quận/Huyện: ";
                }
                else if (Vleustype == "T")
                {
                    v_options = 2;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    else
                    {
                        v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    }
                    v_Names = "CÁC HUYỆN " + Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC HUYỆN";
                }
            }
            else if (Drop_object.SelectedValue == "T")
            {
                if (Vleustype == "T")
                {
                    v_options = 1;
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC TỈNH";
                }
            }
            else if (Drop_object.SelectedValue == "CW")
            {
                if (Vleustype == "CW")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_Names = "CÁC TÒA ÁN CẤP CAO";
                    hi_text_courts.Value = "Số liệu từ các tòa án CC: ";
                    v_court = Hi_value_ID_Court.Value;
                }
            }
            else if (Drop_object.SelectedValue == "TW")
            {
                if ((Vleustype == "TW") && (Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString()) != "1"))
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    v_Names = "CÁC TÒA ÁN TỐI CAO";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Accused_1O M_Objecs = new M_Accused_1O();
            if (Ra_Detail_Total.SelectedValue == "1")
            {
                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                if (Drop_object.SelectedValue == "T")
                {
                    li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                }
                else
                {//if (Drop_object.SelectedValue == "CW" || Drop_object.SelectedValue == "TW")
                    //Cả tòa cấp cao, toi cao và vụ tổng hợp đều dùng
                    li_sw = M_Objecs.Judge_Export_Detail_District_CW(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                }
                #region Lay bao cao chi tiet cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=1O_Detai_District.xls");
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
        public void Ex_Drop_Options_1N()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_typecourts = Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (v_typecourts == "2")
            {
                sth = 1;//option toa quan su
            }
            if (Drop_object.SelectedValue == "H")
            {
                if (Vleustype == "H")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                    hi_text_courts.Value = "Số liệu từ các Quận/Huyện: ";
                }
                else if (Vleustype == "T")
                {
                    v_options = 2;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    else
                    {
                        v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    }
                    v_Names = "CÁC HUYỆN " + Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC HUYỆN";
                }
            }
            else if (Drop_object.SelectedValue == "T")
            {
                if (Vleustype == "T")
                {
                    v_options = 1;
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC TỈNH";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Accused_1N M_Objecs = new M_Accused_1N();
            if (Ra_Detail_Total.SelectedValue == "1")
            {
                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                if ((Vleustype == "T") || (Vleustype == "H"))
                {
                    li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                }
                else
                {
                    if (Drop_object.SelectedValue == "H")
                    {
                        li_sw = M_Objecs.Judge_Export_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    }
                    if (Drop_object.SelectedValue == "T")
                    {
                        li_sw = M_Objecs.Judge_Export_Provin(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    }
                }
                #region Lay bao cao chi tiet cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=1N_Detail_District.xls");
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
        public void Ex_Drop_Options_1P()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_typecourts = Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (v_typecourts == "2")
            {
                sth = 1;//option toa quan su
            }
            if (Drop_object.SelectedValue == "H")
            {
                if (Vleustype == "H")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                    hi_text_courts.Value = "Số liệu từ các Quận/Huyện: ";
                }
                else if (Vleustype == "T")
                {
                    v_options = 2;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    else
                    {
                        v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    }
                    v_Names = "CÁC HUYỆN " + Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC HUYỆN";
                }
            }
            else if (Drop_object.SelectedValue == "T")
            {
                if (Vleustype == "T")
                {
                    v_options = 1;
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC TỈNH";
                }
            }
            else if (Drop_object.SelectedValue == "CW")
            {
                if (Vleustype == "CW")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_Names = "CÁC TÒA ÁN CẤP CAO";
                    hi_text_courts.Value = "Số liệu từ các tòa án CC: ";
                    v_court = Hi_value_ID_Court.Value;
                }
            }
            else if (Drop_object.SelectedValue == "TW")
            {
                if ((Vleustype == "TW") && (Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString()) != "1"))
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    v_Names = "CÁC TÒA ÁN TỐI CAO";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Accused_1P M_Objecs = new M_Accused_1P();
            if (Ra_Detail_Total.SelectedValue == "1")
            {
                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                if (Vleustype == "T" || Vleustype == "H")
                {
                    li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                }
                else
                {
                    if (Drop_object.SelectedValue == "H")
                    {
                        li_sw = M_Objecs.Judge_Export_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    }
                    else if (Drop_object.SelectedValue == "T")
                    {
                        li_sw = M_Objecs.Judge_Export_Provin(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    }
                    else //CW OR TW
                    {
                        li_sw = M_Objecs.Judge_Export_Detail_CW(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    }
                }
                #region Lay bao cao chi tiet cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=1P_Detai_District.xls");
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
        public void Ex_Drop_Options_1Q()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_typecourts = Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (v_typecourts == "2")
            {
                sth = 1;//option toa quan su
            }
            if (Drop_object.SelectedValue == "H")
            {
                if (Vleustype == "H")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                    hi_text_courts.Value = "Số liệu từ các Quận/Huyện: ";
                }
                else if (Vleustype == "T")
                {
                    v_options = 2;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    else
                    {
                        v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    }
                    v_Names = "CÁC HUYỆN " + Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC HUYỆN";
                }
            }
            else if (Drop_object.SelectedValue == "T")
            {
                if (Vleustype == "T")
                {
                    v_options = 1;
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC TỈNH";
                }
            }
            else if (Drop_object.SelectedValue == "CW")
            {
                if (Vleustype == "CW")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_Names = "CÁC TÒA ÁN CẤP CAO";
                    hi_text_courts.Value = "Số liệu từ các tòa án CC: ";
                    v_court = Hi_value_ID_Court.Value;
                }
            }
            else if (Drop_object.SelectedValue == "TW")
            {
                if ((Vleustype == "TW") && (Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString()) != "1"))
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    v_Names = "CÁC TÒA ÁN TỐI CAO";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Accused_1Q M_Objecs = new M_Accused_1Q();
            if (Ra_Detail_Total.SelectedValue == "1")
            {
                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                if ((Vleustype == "T") || (Vleustype == "H"))
                {
                    li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                }
                else
                {
                    if (Drop_object.SelectedValue == "H")
                    {
                        li_sw = M_Objecs.Judge_Export_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    }
                    else if (Drop_object.SelectedValue == "T")
                    {
                        li_sw = M_Objecs.Judge_Export_Provin(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    }
                    else //CW OR TW
                    {
                        li_sw = M_Objecs.Judge_Export_Detail_CW(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    }
                }
                #region Lay bao cao chi tiet cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=1Q_Detai_District.xls");
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
        public void Ex_Drop_Options_1R()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_typecourts = Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (Drop_object.SelectedValue == "H")
            {
                if (Vleustype == "H")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                    hi_text_courts.Value = "Số liệu từ các Quận/Huyện: ";
                }
                else if (Vleustype == "T")
                {
                    v_options = 2;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    else
                    {
                        v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    }
                    v_Names = "CÁC HUYỆN " + Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC HUYỆN";
                }
            }
            else if (Drop_object.SelectedValue == "T")
            {
                if (Vleustype == "T")
                {
                    v_options = 1;
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC TỈNH";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Accused_1R M_Objecs = new M_Accused_1R();
            if (Ra_Detail_Total.SelectedValue == "1")
            {
                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                if ((Vleustype == "T") || (Vleustype == "H"))
                {
                    li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                }
                else
                {
                    if (Drop_object.SelectedValue == "H")
                    {
                        li_sw = M_Objecs.Judge_Export_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    }
                    if (Drop_object.SelectedValue == "T")
                    {
                        li_sw = M_Objecs.Judge_Export_Provin(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    }
                }
                #region Lay bao cao chi tiet cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=1R_Detai_District.xls");
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
        public void Ex_Drop_Options_1S()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (Drop_object.SelectedValue == "H")
            {
                if (Vleustype == "H")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                    hi_text_courts.Value = "Số liệu từ các Quận/Huyện: ";
                }
                else if (Vleustype == "T")
                {
                    v_options = 2;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    else
                    {
                        v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    }
                    v_Names = "CÁC HUYỆN " + Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC HUYỆN";
                }
            }
            else if (Drop_object.SelectedValue == "T")
            {
                if (Vleustype == "T")
                {
                    v_options = 1;
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC TỈNH";
                }
            }
            else if (Drop_object.SelectedValue == "CW")
            {
                if (Vleustype == "CW")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_Names = "CÁC TÒA ÁN CẤP CAO";
                    hi_text_courts.Value = "Số liệu từ các tòa án CC: ";
                    v_court = Hi_value_ID_Court.Value;
                }
            }
            else if (Drop_object.SelectedValue == "TW")
            {
                if ((Vleustype == "TW") && (Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString()) != "1"))
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    v_Names = "CÁC TÒA ÁN TỐI CAO";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Accused_1S M_Objecs = new M_Accused_1S();
            String v_typecourts = Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString());
            if (Ra_Detail_Total.SelectedValue == "1")
            {
                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                if ((Vleustype == "T") || (Vleustype == "H"))
                {
                    li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                }
                else
                {
                    if (Drop_object.SelectedValue == "H")
                    {

                        li_sw = M_Objecs.Judge_Export_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    }
                    else if (Drop_object.SelectedValue == "T")
                    {
                        li_sw = M_Objecs.Judge_Export_Provin(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    }
                    else//CW
                    {
                        li_sw = M_Objecs.Judge_Export_Detail_CW(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    }
                }
                #region Lay bao cao chi tiet cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=1S_Detai_District.xls");
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
        //---------------Export 1... end---------------------------------
        //---------------Export 9... ------------------------------------
        public void Ex_Drop_Options_7A()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (Drop_object.SelectedValue == "H")
            {
                if (Vleustype == "H")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                    hi_text_courts.Value = "Số liệu từ các Quận/Huyện: ";
                }
                else if (Vleustype == "T")
                {
                    v_options = 2;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    else
                    {
                        v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    }
                    v_Names = "CÁC HUYỆN " + Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC HUYỆN";
                }
            }
            else if (Drop_object.SelectedValue == "T")
            {
                if (Vleustype == "T")
                {
                    v_options = 1;
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC TỈNH";
                }
            }
            else if (Drop_object.SelectedValue == "CW")
            {
                if (Vleustype == "CW")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_Names = "CÁC TÒA ÁN CẤP CAO";
                    hi_text_courts.Value = "Số liệu từ các tòa án CC: ";
                    v_court = Hi_value_ID_Court.Value;
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Sanctions_Instances7A M_Objecs = new M_Sanctions_Instances7A();
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=DSST_TD.xls");
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
            else
            {
                String v_typecourts = Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString());
                if (Ra_Detail_Total.SelectedValue == "0")// Tổng hợp 1
                {
                    if (((Vleustype == "T") || (Vleustype == "H") || (Vleustype == "CW") || (Vleustype == "TW") && v_typecourts != "1"))
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=7A_Total_District.xls");
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
                    else //vụ tổng họp
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        li_sw = M_Objecs.Judge_Export_Total_All_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        #region Lay bao cao tong hop
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=7A_Total_All.xls");
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
                else if (Ra_Detail_Total.SelectedValue == "1")
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=DSPT_Detai_District.xls");
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
                else if (Ra_Detail_Total.SelectedValue == "2")//chỉ vụ tổng hợp mới dùng
                {//chi tiết đơn vị trực thuộc
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_All(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=7A_Detai_All.xls");
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
        public void Ex_Drop_Options_7B()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (Drop_object.SelectedValue == "H")
            {
                if (Vleustype == "H")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                    hi_text_courts.Value = "Số liệu từ các Quận/Huyện: ";
                }
                else if (Vleustype == "T")
                {
                    v_options = 2;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    else
                    {
                        v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    }
                    v_Names = "CÁC HUYỆN " + Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC HUYỆN";
                }
            }
            else if (Drop_object.SelectedValue == "T")
            {
                if (Vleustype == "T")
                {
                    v_options = 1;
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC TỈNH";
                }
            }
            else if (Drop_object.SelectedValue == "CW")
            {
                if (Vleustype == "CW")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_Names = "CÁC TÒA ÁN CẤP CAO";
                    hi_text_courts.Value = "Số liệu từ các tòa án CC: ";
                    v_court = Hi_value_ID_Court.Value;
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Sanctions_Instances7B M_Objecs = new M_Sanctions_Instances7B();
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=DSST_TD.xls");
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
            else
            {
                String v_typecourts = Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString());
                if (Ra_Detail_Total.SelectedValue == "0")// Tổng hợp 1
                {
                    if (((Vleustype == "T") || (Vleustype == "H") || (Vleustype == "CW") || (Vleustype == "TW") && v_typecourts != "1"))
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=7B_Total_District.xls");
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
                    else //vụ tổng họp
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        li_sw = M_Objecs.Judge_Export_Total_All_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        #region Lay bao cao tong hop
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=7B_Total_All.xls");
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
                else if (Ra_Detail_Total.SelectedValue == "1")
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=DSPT_Detai_District.xls");
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
                else if (Ra_Detail_Total.SelectedValue == "2")//chỉ vụ tổng hợp mới dùng
                {//chi tiết đơn vị trực thuộc
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_All(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=7B_Detai_All.xls");
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
        public void Ex_Drop_Options_7C()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (Drop_object.SelectedValue == "H")
            {
                if (Vleustype == "H")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                    hi_text_courts.Value = "Số liệu từ các Quận/Huyện: ";
                }
                else if (Vleustype == "T")
                {
                    v_options = 2;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    else
                    {
                        v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    }
                    v_Names = "CÁC HUYỆN " + Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC HUYỆN";
                }
            }
            else if (Drop_object.SelectedValue == "T")
            {
                if (Vleustype == "T")
                {
                    v_options = 1;
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC TỈNH";
                }
            }
            else if (Drop_object.SelectedValue == "CW")
            {
                if (Vleustype == "CW")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_Names = "CÁC TÒA ÁN CẤP CAO";
                    hi_text_courts.Value = "Số liệu từ các tòa án CC: ";
                    v_court = Hi_value_ID_Court.Value;
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Sanctions_Instances7C M_Objecs = new M_Sanctions_Instances7C();
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=DSST_TD.xls");
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
            else
            {
                String v_typecourts = Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString());
                if (Ra_Detail_Total.SelectedValue == "0")// Tổng hợp 1
                {
                    if (((Vleustype == "T") || (Vleustype == "H") || (Vleustype == "CW") || (Vleustype == "TW") && v_typecourts != "1"))
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=7C_Total_District.xls");
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
                    else //vụ tổng họp
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        li_sw = M_Objecs.Judge_Export_Total_All_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        #region Lay bao cao tong hop
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=7C_Total_All.xls");
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
                else if (Ra_Detail_Total.SelectedValue == "1")
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=DSPT_Detai_District.xls");
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
        //---------------Export 7... end---------------------------------
        //---------------Export 7 ----------------------------------
        public void Ex_Drop_Options_8A()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (Drop_object.SelectedValue == "CW")
            {
                if (Vleustype == "CW")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_Names = "CÁC TÒA ÁN CẤP CAO";
                    hi_text_courts.Value = "Số liệu từ các tòa án CC: ";
                    v_court = Hi_value_ID_Court.Value;
                }
            }
            else if (Drop_object.SelectedValue == "TW")
            {
                if ((Vleustype == "TW") && (Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString()) != "1"))
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    v_Names = "CÁC TÒA ÁN TỐI CAO";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Letters_twcw_8A M_Objecs = new M_Letters_twcw_8A();
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=8A_LSV.xls");
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
            else
            {
                if (Ra_Detail_Total.SelectedValue == "1")
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=8A_Detai_District.xls");
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
                if (Ra_Detail_Total.SelectedValue == "2")//Cả tòa cấp cao, toi cao và vụ tổng hợp đều dùng
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District_CW(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet các tỉnh trực thuộc cấp cao
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=8A_Detai_District_cw.xls");
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
                if (Ra_Detail_Total.SelectedValue == "3")// Tổng hợp 1
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=8A_Total_District_01.xls");
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
                else //tong hop
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=8A_Total_District.xls");
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
        public void Ex_Drop_Options_8B()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_criminal.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (Drop_object.SelectedValue == "H")
            {
                if (Vleustype == "H")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                    hi_text_courts.Value = "Số liệu từ các Quận/Huyện: ";
                }
                else if (Vleustype == "T")
                {
                    v_options = 2;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    else
                    {
                        v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    }
                    v_Names = "CÁC HUYỆN " + Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC HUYỆN";
                }
            }
            else if (Drop_object.SelectedValue == "T")
            {
                if (Vleustype == "T")
                {
                    v_options = 1;
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC TỈNH";
                }
            }
            else if (Drop_object.SelectedValue == "CW")
            {
                if (Vleustype == "CW")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_Names = "CÁC TÒA ÁN CẤP CAO";
                    hi_text_courts.Value = "Số liệu từ các tòa án CC: ";
                    v_court = Hi_value_ID_Court.Value;
                }
            }
            else if (Drop_object.SelectedValue == "TW")
            {
                if ((Vleustype == "TW") && (Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString()) != "1"))
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    v_Names = "CÁC TÒA ÁN TỐI CAO";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            String v_typecourts = Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString());
            M_Letters_htcw_8B M_Objecs = new M_Letters_htcw_8B();
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=8B_TD.xls");
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
            else
            {
                if (Ra_Detail_Total.SelectedValue == "1")
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=8B_Detai_District.xls");
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
                if (Ra_Detail_Total.SelectedValue == "2")//Cả tòa cấp cao, toi cao và vụ tổng hợp đều dùng
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    if (Drop_object.SelectedValue == "CW")
                    {
                        li_sw = M_Objecs.Judge_Export_Detail_District_CW(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    }
                    else if (Drop_object.SelectedValue == "H")
                    {
                        li_sw = M_Objecs.Judge_Export_Detail_All_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    }

                    #region Lay bao cao chi tiet các tỉnh trực thuộc cấp cao
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=8B_Detai_District_cw.xls");
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
                if (Ra_Detail_Total.SelectedValue == "3")// Tổng hợp 1
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=8B_Total_District_01.xls");
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
                else //tong hop
                {
                    if (((Vleustype == "T") || (Vleustype == "H") || (Vleustype == "CW") || (Vleustype == "TW") && v_typecourts != "1"))
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=8B_Total_District.xls");
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
                    else //vụ tổng họp
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        if (Drop_object.SelectedValue == "H")
                        {
                            li_sw = M_Objecs.Judge_Export_Total_All_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        if (Drop_object.SelectedValue == "T")
                        {
                            li_sw = M_Objecs.Judge_Export_Total_District_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        if (Drop_object.SelectedValue == "CW" || Drop_object.SelectedValue == "TW")
                        {
                            li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        #region Lay bao cao tong hop
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=8B_Total_All.xls");
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
        }
        public void Ex_Drop_Options_8C()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_typecourts = Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (v_typecourts == "2")
            {
                sth = 1;//option toa quan su
            }
            if (Drop_object.SelectedValue == "H")
            {
                if (Vleustype == "H")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                    hi_text_courts.Value = "Số liệu từ các Quận/Huyện: ";
                }
                else if (Vleustype == "T")
                {
                    v_options = 2;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    else
                    {
                        v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    }
                    v_Names = "CÁC HUYỆN " + Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC HUYỆN";
                }
            }
            else if (Drop_object.SelectedValue == "T")
            {
                if (Vleustype == "T")
                {
                    v_options = 1;
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC TỈNH";
                }
            }
            else if (Drop_object.SelectedValue == "CW")
            {
                if (Vleustype == "CW")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_Names = "CÁC TÒA ÁN CẤP CAO";
                    hi_text_courts.Value = "Số liệu từ các tòa án CC: ";
                    v_court = Hi_value_ID_Court.Value;
                }
            }
            else if (Drop_object.SelectedValue == "TW")
            {
                if ((Vleustype == "TW") && (Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString()) != "1"))
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    v_Names = "CÁC TÒA ÁN TỐI CAO";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Letters_htcwtw_8C M_Objecs = new M_Letters_htcwtw_8C();
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=8C_TD.xls");
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
            else
            {//chi tiet
                if (Ra_Detail_Total.SelectedValue == "1")
                {
                    if ((Vleustype == "T") || (Vleustype == "H") || (Vleustype == "TW") || (Vleustype == "CW"))
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=8C_Detai_District.xls");
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
                    else
                    { //khi la user vu tong hop, Vleustype="" la admin

                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        String name_file_xls = "";
                        if (Drop_object.SelectedValue == "H")
                        {
                            name_file_xls = "8C_Detai_All_01.xls";
                            li_sw = M_Objecs.Judge_Export_Detail_All_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        else
                        {
                            name_file_xls = "8C_Detai_District.xls";
                            li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=" + name_file_xls);
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
                if (Ra_Detail_Total.SelectedValue == "2")//Cả tòa cấp cao, toi cao và vụ tổng hợp đều dùng
                {
                    String name_file_xls = "";
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    if (Drop_object.SelectedValue == "H")
                    {
                        //Lay bao cao chi tiet cac don vi truc thuoc tinh chi vu tong hop moi dung
                        name_file_xls = "8C_Detai_All.xls";
                        li_sw = M_Objecs.Judge_Export_Detail_All(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    }
                    else if (Drop_object.SelectedValue == "TW" || Drop_object.SelectedValue == "CW")
                    {//Lay bao cao chi tiet các tỉnh trực thuộc cấp cao,toi cao
                        name_file_xls = "8C_Detai_District_cw.xls";
                        li_sw = M_Objecs.Judge_Export_Detail_District_CW(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    }
                    #region 
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=" + name_file_xls);
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
                if (Ra_Detail_Total.SelectedValue == "3")// Tổng hợp 1
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=8C_Total_District_01.xls");
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
                if (Ra_Detail_Total.SelectedValue == "0")//tổng hợp 
                {
                    if (((Vleustype == "T") || (Vleustype == "H") || (Vleustype == "CW") || (Vleustype == "TW") && v_typecourts != "1"))
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=8C_Total_District.xls");
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
                    else //vụ tổng họp Vleustype="" la admin
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        String name_file_xls = "";
                        if (Drop_object.SelectedValue == "H")
                        {
                            name_file_xls = "8C_Total_63.xls";
                            li_sw = M_Objecs.Judge_Export_Total_All_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        else if (Drop_object.SelectedValue == "T")
                        {
                            name_file_xls = "8C_Total_63.xls";
                            li_sw = M_Objecs.Judge_Export_Total_District_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        else //TW,CW
                        {
                            name_file_xls = "8C_Total_District.xls";
                            li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        #region Lay bao cao tong hop
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=" + name_file_xls);
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
        }
        public void Ex_Drop_Options_8D()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_typecourts = Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (v_typecourts == "2")
            {
                sth = 1;//option toa quan su
            }
            if (Drop_object.SelectedValue == "H")
            {
                if (Vleustype == "H")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                    hi_text_courts.Value = "Số liệu từ các Quận/Huyện: ";
                }
                else if (Vleustype == "T")
                {
                    v_options = 2;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    else
                    {
                        v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    }
                    v_Names = "CÁC HUYỆN " + Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC HUYỆN";
                }
            }
            else if (Drop_object.SelectedValue == "T")
            {
                if (Vleustype == "T")
                {
                    v_options = 1;
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC TỈNH";
                }
            }
            else if (Drop_object.SelectedValue == "CW")
            {
                if (Vleustype == "CW")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_Names = "CÁC TÒA ÁN CẤP CAO";
                    hi_text_courts.Value = "Số liệu từ các tòa án CC: ";
                    v_court = Hi_value_ID_Court.Value;
                }
            }
            else if (Drop_object.SelectedValue == "TW")
            {
                if ((Vleustype == "TW") && (Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString()) != "1"))
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    v_Names = "CÁC TÒA ÁN TỐI CAO";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Accused_8D M_Objecs = new M_Accused_8D();

            if (Ra_Detail_Total.SelectedValue == "1")
            {
                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                if ((Vleustype == "T") || (Vleustype == "H"))

                {
                    li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                }
                //user admin vu tong hop
                else
                {
                    if (Drop_object.SelectedValue == "H")
                    {
                        li_sw = M_Objecs.Judge_Export_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    }
                    else if (Drop_object.SelectedValue == "T")
                    {
                        li_sw = M_Objecs.Judge_Export_Provin(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);

                    }
                    else //CW OR TW
                    {
                        li_sw = M_Objecs.Judge_Export_Detail_CW(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    }
                }
                #region Lay bao cao chi tiet cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=8D_Detail_District.xls");
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
        //---------------Export 8.A end ------------------------------------
        //---------------Export Dan su ----------------------------------
        public void Ex_Drop_Options_9A()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (Drop_object.SelectedValue == "H")
            {
                if (Vleustype == "H")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                    hi_text_courts.Value = "Số liệu từ các Quận/Huyện: ";
                }
                else if (Vleustype == "T")
                {
                    v_options = 2;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    else
                    {
                        v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    }
                    v_Names = "CÁC HUYỆN " + Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC HUYỆN";
                }
            }
            else if (Drop_object.SelectedValue == "T")
            {
                if (Vleustype == "T")
                {
                    v_options = 1;
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC TỈNH";
                }
            }
            else if (Drop_object.SelectedValue == "CW")
            {
                if (Vleustype == "CW")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_Names = "CÁC TÒA ÁN CẤP CAO";
                    hi_text_courts.Value = "Số liệu từ các tòa án CC: ";
                    v_court = Hi_value_ID_Court.Value;
                }
            }
            else if (Drop_object.SelectedValue == "TW")
            {
                if ((Vleustype == "TW") && (Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString()) != "1"))
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    v_Names = "CÁC TÒA ÁN TỐI CAO";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Delegation9A M_Objecs = new M_Delegation9A();
            String v_typecourts = Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString());
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=DELE9A_DETAIL_TD.xls");
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
            else
            {
                if (Ra_Detail_Total.SelectedValue == "0")// Tổng hợp
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_TOTAL_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=9A_Total_63.xls");
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
                if (Ra_Detail_Total.SelectedValue == "1")//chi tiet
                {//chi tiết đơn vị trực thuộc
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Detail_All_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=9A_Detai_All_01.xls");
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
        public void Ex_Drop_Options_9B()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_typecourts = Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (Drop_object.SelectedValue == "H")
            {
                if (Vleustype == "H")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                    hi_text_courts.Value = "Số liệu từ các Quận/Huyện: ";
                }
                else if (Vleustype == "T")
                {
                    v_options = 2;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    else
                    {
                        v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    }
                    v_Names = "CÁC HUYỆN " + Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC HUYỆN";
                }
            }
            else if (Drop_object.SelectedValue == "T")
            {
                if (Vleustype == "T")
                {
                    v_options = 1;
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC TỈNH";
                }
            }
            else if (Drop_object.SelectedValue == "CW")
            {
                if (Vleustype == "CW")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_Names = "CÁC TÒA ÁN CẤP CAO";
                    hi_text_courts.Value = "Số liệu từ các tòa án CC: ";
                    v_court = Hi_value_ID_Court.Value;
                }
            }
            else if (Drop_object.SelectedValue == "TW")
            {
                if ((Vleustype == "TW") && (Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString()) != "1"))
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    v_Names = "CÁC TÒA ÁN TỐI CAO";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Delegation9B M_Objecs = new M_Delegation9B();
            if (ch_options_TD.Checked == true)
            {
                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=DELEG9B_DETAIL_TD.xls");
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
            else
            {
                if (Ra_Detail_Total.SelectedValue == "0")//tổng hợp
                {

                    if (Vleustype == "T" || Vleustype == "CW")
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();

                        li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);

                        #region Lay bao cao chi tiet 
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=9E_Total_District.xls");
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
                    else //vụ tổng họp Vleustype="" la admin
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        String name_file_xls = "";
                        if (Drop_object.SelectedValue == "T")
                        {
                            name_file_xls = "9B_Total_63.xls";
                            li_sw = M_Objecs.Judge_Export_Total_District_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        else //TW,CW
                        {
                            name_file_xls = "9B_Total_District.xls";
                            li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=" + name_file_xls);
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
                if (Ra_Detail_Total.SelectedValue == "1")// chi tiet
                {

                    if ((Vleustype == "T") || (Vleustype == "CW"))
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=9B_Detai_District.xls");
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
                    else
                    { //khi la user vu tong hop, Vleustype="" la admin

                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        String name_file_xls = "";
                        name_file_xls = "9B_Detai_District.xls";
                        li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=" + name_file_xls);
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
                if (Ra_Detail_Total.SelectedValue == "2")//Cả tòa cấp cao, toi cao và vụ tổng hợp đều dùng
                {
                    String name_file_xls = "";
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    {//Lay bao cao chi tiet các tỉnh trực thuộc cấp cao
                        name_file_xls = "9B_Detai_District_cw.xls";
                        li_sw = M_Objecs.Judge_Export_Detail_District_CW(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        #region 
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=" + name_file_xls);
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
                if (Ra_Detail_Total.SelectedValue == "3")// Tổng hợp 1
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=9B_Total_District_01.xls");
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
        public void Ex_Drop_Options_9C()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_typecourts = Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (v_typecourts == "2")
            {
                sth = 1;//option toa quan su
            }
            if (Drop_object.SelectedValue == "H")
            {
                if (Vleustype == "H")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                    hi_text_courts.Value = "Số liệu từ các Quận/Huyện: ";
                }
                else if (Vleustype == "T")
                {
                    v_options = 2;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    else
                    {
                        v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    }
                    v_Names = "CÁC HUYỆN " + Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC HUYỆN";
                }
            }
            else if (Drop_object.SelectedValue == "T")
            {
                if (Vleustype == "T")
                {
                    v_options = 1;
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC TỈNH";
                }
            }
            else if (Drop_object.SelectedValue == "CW")
            {
                if (Vleustype == "CW")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_Names = "CÁC TÒA ÁN CẤP CAO";
                    hi_text_courts.Value = "Số liệu từ các tòa án CC: ";
                    v_court = Hi_value_ID_Court.Value;
                }
            }
            else if (Drop_object.SelectedValue == "TW")
            {
                if ((Vleustype == "TW") && (Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString()) != "1"))
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    v_Names = "CÁC TÒA ÁN TỐI CAO";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Violate_9C M_Objecs = new M_Violate_9C();
            if (Ra_Detail_Total.SelectedValue == "0")// Tổng hợp 1
            {
                if (((Vleustype == "T") || (Vleustype == "H") || (Vleustype == "CW") || (Vleustype == "TW") && v_typecourts != "1"))
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=9C_Total_District.xls");
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
                else //vụ tổng họp
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    if (Drop_object.SelectedValue == "H")
                    {
                        li_sw = M_Objecs.Judge_Export_Total_All_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    }
                    if (Drop_object.SelectedValue == "T")
                    {
                        li_sw = M_Objecs.Judge_Export_Total_District_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    }
                    if (Drop_object.SelectedValue == "CW" || Drop_object.SelectedValue == "TW")
                    {
                        li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    }
                    #region Lay bao cao tong hop
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=9C_Total_All.xls");
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
            if (Ra_Detail_Total.SelectedValue == "2")//chỉ vụ tổng hợp mới dùng
            {//chi tiết đơn vị trực thuộc
                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_Detail_All(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region Lay bao cao chi tiet cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=9C_Detai_All.xls");
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
            if (Ra_Detail_Total.SelectedValue == "3")// Tổng hợp ĐV trực thuộc
            {
                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_Total_District_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region Lay bao cao chi tiet cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=9C_Total_District_01.xls");
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
        public void Ex_Drop_Options_9D()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (Drop_object.SelectedValue == "H")
            {
                if (Vleustype == "H")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                    hi_text_courts.Value = "Số liệu từ các Quận/Huyện: ";
                }
                else if (Vleustype == "T")
                {
                    v_options = 2;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    else
                    {
                        v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    }
                    v_Names = "CÁC HUYỆN " + Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC HUYỆN";
                }
            }
            else if (Drop_object.SelectedValue == "T")
            {
                if (Vleustype == "T")
                {
                    v_options = 1;
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC TỈNH";
                }
            }
            else if (Drop_object.SelectedValue == "CW")
            {
                if (Vleustype == "CW")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_Names = "CÁC TÒA ÁN CẤP CAO";
                    hi_text_courts.Value = "Số liệu từ các tòa án CC: ";
                    v_court = Hi_value_ID_Court.Value;
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Court_Fees9D M_Objecs = new M_Court_Fees9D();
            String v_typecourts = Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString());
            if (Ra_Detail_Total.SelectedValue == "0")// Tổng hợp 1
            {
                if (((Vleustype == "T") || (Vleustype == "H") || (Vleustype == "CW") || (Vleustype == "TW") && v_typecourts != "1"))
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=9D_Total_District.xls");
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
                else //vụ tổng họp
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    if (Drop_object.SelectedValue == "H")
                    {
                        li_sw = M_Objecs.Judge_Export_Total_All_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    }
                    if (Drop_object.SelectedValue == "T")
                    {
                        li_sw = M_Objecs.Judge_Export_Total_District_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    }
                    if (Drop_object.SelectedValue == "CW" || Drop_object.SelectedValue == "TW")
                    {
                        li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    }
                    #region Lay bao cao tong hop
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=9D_Total_All.xls");
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
            if (Ra_Detail_Total.SelectedValue == "2")//chỉ vụ tổng hợp mới dùng
            {//chi tiết đơn vị trực thuộc
                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_Detail_All(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region Lay bao cao chi tiet cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=9D_Detai_All.xls");
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
            if (Ra_Detail_Total.SelectedValue == "3")// Tổng hợp ĐV trực thuộc
            {
                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_Total_District_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region Lay bao cao chi tiet cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=9D_Total_District_01.xls");
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
        public void Ex_Drop_Options_9G()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_typecourts = Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (v_typecourts == "2")
            {
                sth = 1;//option toa quan su
            }
            if (Drop_object.SelectedValue == "H")
            {
                if (Vleustype == "H")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                    hi_text_courts.Value = "Số liệu từ các Quận/Huyện: ";
                }
                else if (Vleustype == "T")
                {
                    v_options = 2;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    else
                    {
                        v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    }
                    v_Names = "CÁC HUYỆN " + Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC HUYỆN";
                }
            }
            else if (Drop_object.SelectedValue == "T")
            {
                if (Vleustype == "T")
                {
                    v_options = 1;
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC TỈNH";
                }
            }
            else if (Drop_object.SelectedValue == "CW")
            {
                if (Vleustype == "CW")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_Names = "CÁC TÒA ÁN CẤP CAO";
                    hi_text_courts.Value = "Số liệu từ các tòa án CC: ";
                    v_court = Hi_value_ID_Court.Value;
                }
            }
            else if (Drop_object.SelectedValue == "TW")
            {
                if ((Vleustype == "TW") && (Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString()) != "1"))
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    v_Names = "CÁC TÒA ÁN TỐI CAO";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Violate_9G M_Objecs = new M_Violate_9G();
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=9G_TD.xls");
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
            else
            {//chi tiet
                if (Ra_Detail_Total.SelectedValue == "1")
                {
                    if ((Vleustype == "T") || (Vleustype == "H") || (Vleustype == "TW") || (Vleustype == "CW"))
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=9G_Detai_District.xls");
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
                    else
                    { //khi la user vu tong hop, Vleustype="" la admin

                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        String name_file_xls = "";
                        if (Drop_object.SelectedValue == "H")
                        {
                            name_file_xls = "9G_Detai_All_01";
                            li_sw = M_Objecs.Judge_Export_Detail_All_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        else
                        {
                            name_file_xls = "9G_Detai_District";
                            li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=" + name_file_xls);
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
                if (Ra_Detail_Total.SelectedValue == "2")//Cả tòa cấp cao, toi cao và vụ tổng hợp đều dùng
                {
                    String name_file_xls = "";
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    if (Drop_object.SelectedValue == "H")
                    {
                        //Lay bao cao chi tiet cac don vi truc thuoc tinh chi vu tong hop moi dung
                        name_file_xls = "9G_Detai_All.xls";
                        li_sw = M_Objecs.Judge_Export_Detail_All(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    }
                    else if (Drop_object.SelectedValue == "TW" || Drop_object.SelectedValue == "CW")
                    {//Lay bao cao chi tiet các tỉnh trực thuộc cấp cao,toi cao
                        name_file_xls = "9G_Detai_District_cw.xls";
                        li_sw = M_Objecs.Judge_Export_Detail_District_CW(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    }
                    #region 
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=" + name_file_xls);
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
                if (Ra_Detail_Total.SelectedValue == "3")// Tổng hợp 1
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=9G_Total_District_01.xls");
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
                if (Ra_Detail_Total.SelectedValue == "0")//tổng hợp 
                {
                    if (((Vleustype == "T") || (Vleustype == "H") || (Vleustype == "CW") || (Vleustype == "TW") && v_typecourts != "1"))
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=9G_Total_District.xls");
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
                    else //vụ tổng họp Vleustype="" la admin
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        String name_file_xls = "";
                        if (Drop_object.SelectedValue == "H")
                        {
                            name_file_xls = "9G_Total_63.xls";
                            li_sw = M_Objecs.Judge_Export_Total_All_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        else if (Drop_object.SelectedValue == "T")
                        {
                            name_file_xls = "9G_Total_63.xls";
                            li_sw = M_Objecs.Judge_Export_Total_District_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        else //TW,CW
                        {
                            name_file_xls = "9G_Total_District.xls";
                            li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        #region Lay bao cao tong hop
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=" + name_file_xls);
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
        }
        public void Ex_Drop_Options_9i()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (Drop_object.SelectedValue == "H")
            {
                if (Vleustype == "H")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                    hi_text_courts.Value = "Số liệu từ các Quận/Huyện: ";
                }
                else if (Vleustype == "T")
                {
                    v_options = 2;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    else
                    {
                        v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    }
                    v_Names = "CÁC HUYỆN " + Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC HUYỆN";
                }
            }
            else if (Drop_object.SelectedValue == "T")
            {
                if (Vleustype == "T")
                {
                    v_options = 1;
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC TỈNH";
                }
            }
            else if (Drop_object.SelectedValue == "CW")
            {
                if (Vleustype == "CW")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_Names = "CÁC TÒA ÁN CẤP CAO";
                    hi_text_courts.Value = "Số liệu từ các tòa án CC: ";
                    v_court = Hi_value_ID_Court.Value;
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Of_Justice9i M_Objecs = new M_Of_Justice9i();
            String v_typecourts = Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString());
            if (Ra_Detail_Total.SelectedValue == "0")// Tổng hợp 1
            {
                if (((Vleustype == "T") || (Vleustype == "H") || (Vleustype == "CW") || (Vleustype == "TW") && v_typecourts != "1"))
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=9i_Total_District.xls");
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
                else //vụ tổng họp
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    if (Drop_object.SelectedValue == "H")
                    {
                        li_sw = M_Objecs.Judge_Export_Total_All_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    }
                    if (Drop_object.SelectedValue == "T")
                    {
                        li_sw = M_Objecs.Judge_Export_Total_District_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    }
                    if (Drop_object.SelectedValue == "CW" || Drop_object.SelectedValue == "TW")
                    {
                        li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    }
                    #region Lay bao cao tong hop
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=9i_Total_All.xls");
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
            if (Ra_Detail_Total.SelectedValue == "2")//chỉ vụ tổng hợp mới dùng
            {//chi tiết đơn vị trực thuộc
                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_Detail_All(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region Lay bao cao chi tiet cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=9i_Detai_All.xls");
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
            if (Ra_Detail_Total.SelectedValue == "3")// Tổng hợp ĐV trực thuộc
            {
                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_Total_District_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region Lay bao cao chi tiet cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=9i_Total_District_01.xls");
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
        public void Ex_Drop_Options_9H()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_typecourts = Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (v_typecourts == "2")
            {
                sth = 1;//option toa quan su
            }
            if (Drop_object.SelectedValue == "H")
            {
                if (Vleustype == "H")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                    hi_text_courts.Value = "Số liệu từ các Quận/Huyện: ";
                }
                else if (Vleustype == "T")
                {
                    v_options = 2;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    else
                    {
                        v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    }
                    v_Names = "CÁC HUYỆN " + Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC HUYỆN";
                }
            }
            else if (Drop_object.SelectedValue == "T")
            {
                if (Vleustype == "T")
                {
                    v_options = 1;
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC TỈNH";
                }
            }
            else if (Drop_object.SelectedValue == "CW")
            {
                if (Vleustype == "CW")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_Names = "CÁC TÒA ÁN CẤP CAO";
                    hi_text_courts.Value = "Số liệu từ các tòa án CC: ";
                    v_court = Hi_value_ID_Court.Value;
                }
            }
            else if (Drop_object.SelectedValue == "TW")
            {
                if ((Vleustype == "TW") && (Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString()) != "1"))
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    v_Names = "CÁC TÒA ÁN TỐI CAO";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Accused_9H M_Objecs = new M_Accused_9H();
            if (Ra_Detail_Total.SelectedValue == "1")
            {
                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                if (Vleustype == "T" || Vleustype == "H")
                {
                    li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                }
                else
                {
                    if (Drop_object.SelectedValue == "H")
                    {
                        li_sw = M_Objecs.Judge_Export_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    }
                    else if (Drop_object.SelectedValue == "T")
                    {
                        li_sw = M_Objecs.Judge_Export_Provin(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    }
                    else //CW OR TW
                    {
                        li_sw = M_Objecs.Judge_Export_Detail_CW(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    }
                }
                #region Lay bao cao chi tiet cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=9H_Detai_District.xls");
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
        public void Ex_Drop_Options_9E()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_typecourts = Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (v_typecourts == "2")
            {
                sth = 1;//option toa quan su
            }
            if (Drop_object.SelectedValue == "H")
            {
                if (Vleustype == "H")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                    hi_text_courts.Value = "Số liệu từ các Quận/Huyện: ";
                }
                else if (Vleustype == "T")
                {
                    v_options = 2;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    else
                    {
                        v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    }
                    v_Names = "CÁC HUYỆN " + Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC HUYỆN";
                }
            }
            else if (Drop_object.SelectedValue == "T")
            {
                if (Vleustype == "T")
                {
                    v_options = 1;
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC TỈNH";
                }
            }
            else if (Drop_object.SelectedValue == "CW")
            {
                if (Vleustype == "CW")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_Names = "CÁC TÒA ÁN CẤP CAO";
                    hi_text_courts.Value = "Số liệu từ các tòa án CC: ";
                    v_court = Hi_value_ID_Court.Value;
                }
            }
            else if (Drop_object.SelectedValue == "TW")
            {
                if ((Vleustype == "TW") && (Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString()) != "1"))
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    v_Names = "CÁC TÒA ÁN TỐI CAO";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Verification9E M_Objecs = new M_Verification9E();
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=9E_TD.xls");
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
            else
            {//chi tiet
                if (Ra_Detail_Total.SelectedValue == "1")
                {
                    if ((Vleustype == "T") || (Vleustype == "H") || (Vleustype == "TW") || (Vleustype == "CW"))
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=9E_Detai_District.xls");
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
                    else
                    { //khi la user vu tong hop, Vleustype="" la admin

                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        String name_file_xls = "";
                        if (Drop_object.SelectedValue == "H")
                        {
                            name_file_xls = "9E_Detai_All_01.xls";
                            li_sw = M_Objecs.Judge_Export_Detail_All_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        else
                        {
                            name_file_xls = "9E_Detai_District.xls";
                            li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=" + name_file_xls);
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
                if (Ra_Detail_Total.SelectedValue == "2")//Cả tòa cấp cao, toi cao và vụ tổng hợp đều dùng
                {
                    String name_file_xls = "";
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    if (Drop_object.SelectedValue == "H")
                    {
                        //Lay bao cao chi tiet cac don vi truc thuoc tinh chi vu tong hop moi dung
                        name_file_xls = "9E_Detai_All.xls";
                        li_sw = M_Objecs.Judge_Export_Detail_All(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    }
                    else if (Drop_object.SelectedValue == "TW" || Drop_object.SelectedValue == "CW")
                    {//Lay bao cao chi tiet các tỉnh trực thuộc cấp cao,toi cao
                        name_file_xls = "9E_Detai_District_cw.xls";
                        li_sw = M_Objecs.Judge_Export_Detail_District_CW(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    }
                    #region 
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=" + name_file_xls);
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
                if (Ra_Detail_Total.SelectedValue == "3")// Tổng hợp 1
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=9E_Total_District_01.xls");
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
                if (Ra_Detail_Total.SelectedValue == "0")//tổng hợp 
                {
                    if (((Vleustype == "T") || (Vleustype == "H") || (Vleustype == "CW") || (Vleustype == "TW") && v_typecourts != "1"))
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=9E_Total_District.xls");
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
                    else //vụ tổng họp Vleustype="" la admin
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        String name_file_xls = "";
                        if (Drop_object.SelectedValue == "H")
                        {
                            name_file_xls = "9E_Total_63.xls";
                            li_sw = M_Objecs.Judge_Export_Total_All_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        else if (Drop_object.SelectedValue == "T")
                        {
                            name_file_xls = "9E_Total_63.xls";
                            li_sw = M_Objecs.Judge_Export_Total_District_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        else //TW,CW
                        {
                            name_file_xls = "9E_Total_District.xls";
                            li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        #region Lay bao cao tong hop
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=" + name_file_xls);
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
        }
        public void Ex_Drop_Options_9F()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_typecourts = Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (v_typecourts == "2")
            {
                sth = 1;//option toa quan su
            }
            if (Drop_object.SelectedValue == "H")
            {
                if (Vleustype == "H")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                    hi_text_courts.Value = "Số liệu từ các Quận/Huyện: ";
                }
                else if (Vleustype == "T")
                {
                    v_options = 2;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    else
                    {
                        v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    }
                    v_Names = "CÁC HUYỆN " + Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC HUYỆN";
                }
            }
            else if (Drop_object.SelectedValue == "T")
            {
                if (Vleustype == "T")
                {
                    v_options = 1;
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC TỈNH";
                }
            }
            else if (Drop_object.SelectedValue == "CW")
            {
                if (Vleustype == "CW")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_Names = "CÁC TÒA ÁN CẤP CAO";
                    hi_text_courts.Value = "Số liệu từ các tòa án CC: ";
                    v_court = Hi_value_ID_Court.Value;
                }
            }
            else if (Drop_object.SelectedValue == "TW")
            {
                if ((Vleustype == "TW") && (Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString()) != "1"))
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    v_Names = "CÁC TÒA ÁN TỐI CAO";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Emergency9F M_Objecs = new M_Emergency9F();
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=9F_TD.xls");
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
            else
            {//chi tiet
                if (Ra_Detail_Total.SelectedValue == "1")
                {
                    if ((Vleustype == "T") || (Vleustype == "H") || (Vleustype == "TW") || (Vleustype == "CW"))
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=9F_Detai_District.xls");
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
                    else
                    { //khi la user vu tong hop, Vleustype="" la admin

                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        String name_file_xls = "";
                        if (Drop_object.SelectedValue == "H")
                        {
                            name_file_xls = "9F_Detai_All_01.xls";
                            li_sw = M_Objecs.Judge_Export_Detail_All_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        else
                        {
                            name_file_xls = "9F_Detai_District.xls";
                            li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=" + name_file_xls);
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
                if (Ra_Detail_Total.SelectedValue == "2")//Cả tòa cấp cao, toi cao và vụ tổng hợp đều dùng
                {
                    String name_file_xls = "";
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    if (Drop_object.SelectedValue == "H")
                    {
                        //Lay bao cao chi tiet cac don vi truc thuoc tinh chi vu tong hop moi dung
                        name_file_xls = "9F_Detai_All.xls";
                        li_sw = M_Objecs.Judge_Export_Detail_All(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    }
                    else if (Drop_object.SelectedValue == "TW" || Drop_object.SelectedValue == "CW")
                    {//Lay bao cao chi tiet các tỉnh trực thuộc cấp cao,toi cao
                        name_file_xls = "9F_Detai_District_cw.xls";
                        li_sw = M_Objecs.Judge_Export_Detail_District_CW(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    }
                    #region 
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=" + name_file_xls);
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
                if (Ra_Detail_Total.SelectedValue == "3")// Tổng hợp 1
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=9F_Total_District_01.xls");
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
                if (Ra_Detail_Total.SelectedValue == "0")//tổng hợp 
                {
                    if (((Vleustype == "T") || (Vleustype == "H") || (Vleustype == "CW") || (Vleustype == "TW") && v_typecourts != "1"))
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=9F_Total_District.xls");
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
                    else //vụ tổng họp Vleustype="" la admin
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        String name_file_xls = "";
                        if (Drop_object.SelectedValue == "H")
                        {
                            name_file_xls = "9F_Total_63.xls";
                            li_sw = M_Objecs.Judge_Export_Total_All_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        else if (Drop_object.SelectedValue == "T")
                        {
                            name_file_xls = "9F_Total_63.xls";
                            li_sw = M_Objecs.Judge_Export_Total_District_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        else //TW,CW
                        {
                            name_file_xls = "9F_Total_District.xls";
                            li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        #region Lay bao cao tong hop
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=" + name_file_xls);
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
        }
        //---------------Export 9... end-----------------------------
        //---------------Export 4 -----------------------------------
        public void Ex_Drop_Options_4E()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (Drop_object.SelectedValue == "H")
            {
                if (Vleustype == "H")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                    hi_text_courts.Value = "Số liệu từ các Quận/Huyện: ";
                }
                else if (Vleustype == "T")
                {
                    v_options = 2;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    else
                    {
                        v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    }
                    v_Names = "CÁC HUYỆN " + Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC HUYỆN";
                }
            }
            else if (Drop_object.SelectedValue == "T")
            {
                if (Vleustype == "T")
                {
                    v_options = 1;
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC TỈNH";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Bankruptcys_Instances4E M_Objecs = new M_Bankruptcys_Instances4E();
            if (ch_options_TD.Checked == true)
            {
                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                if (Radio_4E.SelectedValue == "0")
                {
                    li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                }
                else if (Radio_4E.SelectedValue == "1")
                {
                    li_sw = M_Objecs.Judge_Export_TD_Group(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                }
                else if (Radio_4E.SelectedValue == "2")
                {
                    li_sw = M_Objecs.Judge_Export_TD_Parent(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                }
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=4E_TD.xls");
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
            else
            {//chi tiet
                if (Ra_Detail_Total.SelectedValue == "1")
                {
                    if ((Vleustype == "T") || (Vleustype == "H"))
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        if (Radio_4E.SelectedValue == "0")
                        {
                            li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        else if (Radio_4E.SelectedValue == "1")
                        {
                            li_sw = M_Objecs.Judge_Export_Detail_District_Group(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        else if (Radio_4E.SelectedValue == "2")
                        {
                            li_sw = M_Objecs.Judge_Export_Detail_District_Parent(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=4E_Detai_District.xls");
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
                    else
                    { //khi la user vu tong hop
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        if (Drop_object.SelectedValue == "H")
                        {
                            if (Radio_4E.SelectedValue == "0")
                            {
                                li_sw = M_Objecs.Judge_Export_Detail_All_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                            }
                            else if (Radio_4E.SelectedValue == "1")
                            {
                                li_sw = M_Objecs.Judge_Export_Detail_All_01_Group(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                            }
                            else if (Radio_4E.SelectedValue == "2")
                            {
                                li_sw = M_Objecs.Judge_Export_Detail_All_01_Parent(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                            }
                        }
                        else
                        {
                            if (Radio_4E.SelectedValue == "0")
                            {
                                li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                            }
                            else if (Radio_4E.SelectedValue == "1")
                            {
                                li_sw = M_Objecs.Judge_Export_Detail_District_Group(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                            }
                            else if (Radio_4E.SelectedValue == "2")
                            {
                                li_sw = M_Objecs.Judge_Export_Detail_District_Parent(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                            }
                        }
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=4E_Detai_All_01.xls");
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
                if (Ra_Detail_Total.SelectedValue == "2")//chỉ vụ tổng hợp mới dùng
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_All(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=4E_Detai_All.xls");
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
                else//tổng hợp 
                {
                    //Cấp huyện hoặc cấp tỉnh
                    if ((Vleustype == "T") || (Vleustype == "H"))
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=4E_Total_District.xls");
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
                    else //vụ tổng họp
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        if (Drop_object.SelectedValue == "H")
                        {
                            li_sw = M_Objecs.Judge_Export_Total_All_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        else
                        {
                            li_sw = M_Objecs.Judge_Export_Total_District_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        #region Lay bao cao tong hop
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=4E_Total_63.xls");
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
        }
        public void Ex_Drop_Options_4F()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (Drop_object.SelectedValue == "T")
            {
                if (Vleustype == "T")
                {
                    v_options = 1;
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                    hi_text_courts.Value = "Số liệu từ các Tỉnh/TP: ";
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC TỈNH";
                    hi_text_courts.Value = "Số liệu từ các Tỉnh/TP: ";
                }
            }
            else if (Drop_object.SelectedValue == "CW")
            {
                if (Vleustype == "CW")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_Names = "CÁC TÒA ÁN CẤP CAO";
                    hi_text_courts.Value = "Số liệu từ các tòa án CC: ";
                    v_court = Hi_value_ID_Court.Value;
                }
            }
            else if (Drop_object.SelectedValue == "TW")
            {
                if ((Vleustype == "TW") && (Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString()) != "1"))
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    v_Names = "CÁC TÒA ÁN TỐI CAO";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Bankruptcys_Appeals4F M_Objecs = new M_Bankruptcys_Appeals4F();
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=4F_TD.xls");
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
            else
            {
                if (Ra_Detail_Total.SelectedValue == "1")
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=4F_Detai_District.xls");
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
                if (Ra_Detail_Total.SelectedValue == "2")//Cả tòa cấp cao, toi cao và vụ tổng hợp đều dùng
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District_CW(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet các tỉnh trực thuộc cấp cao
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=4F_Detai_District_cw.xls");
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
                if (Ra_Detail_Total.SelectedValue == "3")// Tổng hợp 1
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=4F_Total_District_01.xls");
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
                else //tong hop
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=4F_Total_District.xls");
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
        public void Ex_Drop_Options_4G()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (Drop_object.SelectedValue == "CW")
            {
                if (Vleustype == "CW")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_Names = "CÁC TÒA ÁN CẤP CAO";
                    hi_text_courts.Value = "Số liệu từ các tòa án CC: ";
                    v_court = Hi_value_ID_Court.Value;
                }
            }
            else if (Drop_object.SelectedValue == "TW")
            {
                if ((Vleustype == "TW") && (Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString()) != "1"))
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    v_Names = "CÁC TÒA ÁN TỐI CAO";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Bankruptcys_Special4G M_Objecs = new M_Bankruptcys_Special4G();
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=4G_TD.xls");
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
            else
            {
                if (Ra_Detail_Total.SelectedValue == "1")
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=4G_Detai_District.xls");
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
                if (Ra_Detail_Total.SelectedValue == "2")//Cả tòa cấp cao, toi cao và vụ tổng hợp đều dùng
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District_CW(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet các tỉnh trực thuộc cấp cao
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=4G_Detai_District_cw.xls");
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
                if (Ra_Detail_Total.SelectedValue == "3")// Tổng hợp 1
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=4G_Total_District_01.xls");
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
                else //tong hop
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=4G_Total_District.xls");
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
        //---------------Export 4 END -----------------------------------
        //---------------Export Dan su ------------------------------
        public void Ex_Drop_Options_Civils_Instances()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (Drop_object.SelectedValue == "H")
            {
                if (Vleustype == "H")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                    hi_text_courts.Value = "Số liệu từ các Quận/Huyện: ";
                }
                else if (Vleustype == "T")
                {
                    v_options = 2;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    else
                    {
                        v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    }
                    v_Names = "CÁC HUYỆN " + Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC HUYỆN";
                }
            }
            else if (Drop_object.SelectedValue == "T")
            {
                if (Vleustype == "T")
                {
                    v_options = 1;
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC TỈNH";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Judge_Civil M_Objecs = new M_Judge_Civil();
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=DSST_TD.xls");
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
            else
            {//chi tiet
                if (Ra_Detail_Total.SelectedValue == "1")
                {
                    if ((Vleustype == "T") || (Vleustype == "H"))
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=DSST_Detai_District.xls");
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
                    else
                    { //khi la user vu tong hop

                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        if (Drop_object.SelectedValue == "H")
                        {
                            li_sw = M_Objecs.Judge_Export_Detail_All_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        else
                        {
                            li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=DSST_Detai_All_01.xls");
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
                if (Ra_Detail_Total.SelectedValue == "2")//chỉ vụ tổng hợp mới dùng
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_All(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=DSST_Detai_All.xls");
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
                else//tổng hợp 
                {
                    //Cấp huyện hoặc cấp tỉnh
                    if ((Vleustype == "T") || (Vleustype == "H"))
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=DSST_Total_District.xls");
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
                    else //vụ tổng họp
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        if (Drop_object.SelectedValue == "H")
                        {
                            li_sw = M_Objecs.Judge_Export_Total_All_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        else
                        {
                            li_sw = M_Objecs.Judge_Export_Total_District_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        #region Lay bao cao tong hop
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=DSST_Total_63.xls");
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
        }
        public void Ex_Drop_Options_Civil_Appeals()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (Drop_object.SelectedValue == "T")
            {
                if (Vleustype == "T")
                {
                    v_options = 1;
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                    hi_text_courts.Value = "Số liệu từ các Tỉnh/TP: ";
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC TỈNH";
                    hi_text_courts.Value = "Số liệu từ các Tỉnh/TP: ";
                }
            }
            else if (Drop_object.SelectedValue == "CW")
            {
                if (Vleustype == "CW")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_Names = "CÁC TÒA ÁN CẤP CAO";
                    hi_text_courts.Value = "Số liệu từ các tòa án CC: ";
                    v_court = Hi_value_ID_Court.Value;
                }
            }
            else if (Drop_object.SelectedValue == "TW")
            {
                if ((Vleustype == "TW") && (Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString()) != "1"))
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    v_Names = "CÁC TÒA ÁN TỐI CAO";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Civil_Appeals M_Objecs = new M_Civil_Appeals();
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=DSPT_TD.xls");
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
            else
            {
                if (Ra_Detail_Total.SelectedValue == "1")
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=DSPT_Detai_District.xls");
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
                if (Ra_Detail_Total.SelectedValue == "2")//Cả tòa cấp cao, toi cao và vụ tổng hợp đều dùng
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District_CW(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet các tỉnh trực thuộc cấp cao
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=DSPT_Detai_District_cw.xls");
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
                if (Ra_Detail_Total.SelectedValue == "3")// Tổng hợp 1
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=DSPT_Total_District_01.xls");
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
                else //tong hop
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=DSPT_Total_District.xls");
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
        public void Ex_Drop_Options_Civil_Cassation()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (Drop_object.SelectedValue == "CW")
            {
                if (Vleustype == "CW")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_Names = "CÁC TÒA ÁN CẤP CAO";
                    hi_text_courts.Value = "Số liệu từ các tòa án CC: ";
                    v_court = Hi_value_ID_Court.Value;
                }
            }
            else if (Drop_object.SelectedValue == "TW")
            {
                if ((Vleustype == "TW") && (Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString()) != "1"))
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    v_Names = "CÁC TÒA ÁN TỐI CAO";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Civil_Cassation M_Objecs = new M_Civil_Cassation();
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=DSGĐT_TD.xls");
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
            else
            {
                if (Ra_Detail_Total.SelectedValue == "1")
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=DSGĐT_Detai_District.xls");
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
                if (Ra_Detail_Total.SelectedValue == "2")//Cả tòa cấp cao, toi cao và vụ tổng hợp đều dùng
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District_CW(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet các tỉnh trực thuộc cấp cao
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=DSGĐT_Detai_District_cw.xls");
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
                if (Ra_Detail_Total.SelectedValue == "3")// Tổng hợp 1
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=DSGĐT_Total_District_01.xls");
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
                else //tong hop
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=DSGĐT_Total_District.xls");
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
        public void Ex_Drop_Options_Civil_Retrials()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (Drop_object.SelectedValue == "CW")
            {
                if (Vleustype == "CW")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_Names = "CÁC TÒA ÁN CẤP CAO";
                    hi_text_courts.Value = "Số liệu từ các tòa án CC: ";
                    v_court = Hi_value_ID_Court.Value;
                }
            }
            else if (Drop_object.SelectedValue == "TW")
            {
                if ((Vleustype == "TW") && (Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString()) != "1"))
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    v_Names = "CÁC TÒA ÁN TỐI CAO";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Civil_Retrials M_Objecs = new M_Civil_Retrials();
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=DSTT_TD.xls");
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
            else
            {
                if (Ra_Detail_Total.SelectedValue == "1")
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=DSTT_Detai_District.xls");
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
                if (Ra_Detail_Total.SelectedValue == "2")//Cả tòa cấp cao, toi cao và vụ tổng hợp đều dùng
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District_CW(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet các tỉnh trực thuộc cấp cao
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=DSTT_Detai_District_cw.xls");
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
                if (Ra_Detail_Total.SelectedValue == "3")// Tổng hợp 1
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=DSTT_Total_District_01.xls");
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
                else //tong hop
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=DSTT_Total_District.xls");
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
        public void Ex_Drop_Options_Civil_Special()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (Drop_object.SelectedValue == "TW")
            {
                if ((Vleustype == "TW") && (Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString()) != "1"))
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    v_Names = "CÁC TÒA ÁN TỐI CAO";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Civil_Special M_Objecs = new M_Civil_Special();
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=DSTTĐB_TD.xls");
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
            else
            {
                if (Ra_Detail_Total.SelectedValue == "1")
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=DSTTĐB_Detai_District.xls");
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
                if (Ra_Detail_Total.SelectedValue == "2")//Cả tòa cấp cao, toi cao và vụ tổng hợp đều dùng
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District_CW(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet các tỉnh trực thuộc cấp cao
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=DSTTĐB_Detai_District_cw.xls");
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
                if (Ra_Detail_Total.SelectedValue == "3")// Tổng hợp 1
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=DSTTĐB_Total_District_01.xls");
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
                else //tong hop
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=DSTTĐB_Total_District.xls");
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
        //---------------Export Dan su end---------------------------------
        //---------------Export Hon nhan gia dinh -------------------------
        public void Ex_Drop_Options_Marriges_Instances()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (Drop_object.SelectedValue == "H")
            {
                if (Vleustype == "H")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                    hi_text_courts.Value = "Số liệu từ các Quận/Huyện: ";
                }
                else if (Vleustype == "T")
                {
                    v_options = 2;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    else
                    {
                        v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    }
                    v_Names = "CÁC HUYỆN " + Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC HUYỆN";
                }
            }
            else if (Drop_object.SelectedValue == "T")
            {
                if (Vleustype == "T")
                {
                    v_options = 1;
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC TỈNH";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Judge_Marriges M_Objecs = new M_Judge_Marriges();
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=HNGĐ_TD.xls");
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
            else
            {//chi tiet
                if (Ra_Detail_Total.SelectedValue == "1")
                {
                    if ((Vleustype == "T") || (Vleustype == "H"))
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=HNGĐ_Detai_District.xls");
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
                    else
                    { //khi la user vu tong hop

                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        if (Drop_object.SelectedValue == "H")
                        {
                            li_sw = M_Objecs.Judge_Export_Detail_All_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        else
                        {
                            li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=HNGĐ_Detai_All_01.xls");
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
                if (Ra_Detail_Total.SelectedValue == "2")//chỉ vụ tổng hợp mới dùng
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_All(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HNGĐ_Detai_All.xls");
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
                else//tổng hợp 
                {
                    //Cấp huyện hoặc cấp tỉnh
                    if ((Vleustype == "T") || (Vleustype == "H"))
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=HNGĐ_Total_District.xls");
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
                    else //vụ tổng họp
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        if (Drop_object.SelectedValue == "H")
                        {
                            li_sw = M_Objecs.Judge_Export_Total_All_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        else
                        {
                            li_sw = M_Objecs.Judge_Export_Total_District_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        #region Lay bao cao tong hop
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=HNGĐ_Total_63.xls");
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
        }
        public void Ex_Drop_Options_Marriges_Appeals()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (Drop_object.SelectedValue == "T")
            {
                if (Vleustype == "T")
                {
                    v_options = 1;
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                    hi_text_courts.Value = "Số liệu từ các Tỉnh/TP: ";
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC TỈNH";
                    hi_text_courts.Value = "Số liệu từ các Tỉnh/TP: ";
                }
            }
            else if (Drop_object.SelectedValue == "CW")
            {
                if (Vleustype == "CW")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_Names = "CÁC TÒA ÁN CẤP CAO";
                    hi_text_courts.Value = "Số liệu từ các tòa án CC: ";
                    v_court = Hi_value_ID_Court.Value;
                }
            }
            else if (Drop_object.SelectedValue == "TW")
            {
                if ((Vleustype == "TW") && (Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString()) != "1"))
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    v_Names = "CÁC TÒA ÁN TỐI CAO";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Marriges_Appeals M_Objecs = new M_Marriges_Appeals();
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=HNPT_TD.xls");
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
            else
            {
                if (Ra_Detail_Total.SelectedValue == "1")
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HNPT_Detai_District.xls");
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
                if (Ra_Detail_Total.SelectedValue == "2")//Cả tòa cấp cao, toi cao và vụ tổng hợp đều dùng
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District_CW(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet các tỉnh trực thuộc cấp cao
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HNPT_Detai_District_cw.xls");
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
                if (Ra_Detail_Total.SelectedValue == "3")// Tổng hợp 1
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HNPT_Total_District_01.xls");
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
                else //tong hop
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HNPT_Total_District.xls");
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
        public void Ex_Drop_Options_Marriges_Cassation()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (Drop_object.SelectedValue == "CW")
            {
                if (Vleustype == "CW")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_Names = "CÁC TÒA ÁN CẤP CAO";
                    hi_text_courts.Value = "Số liệu từ các tòa án CC: ";
                    v_court = Hi_value_ID_Court.Value;
                }
            }
            else if (Drop_object.SelectedValue == "TW")
            {
                if ((Vleustype == "TW") && (Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString()) != "1"))
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    v_Names = "CÁC TÒA ÁN TỐI CAO";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Marriges_Cassation M_Objecs = new M_Marriges_Cassation();
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=HNGĐT_TD.xls");
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
            else
            {
                if (Ra_Detail_Total.SelectedValue == "1")
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HNGĐT_Detai_District.xls");
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
                if (Ra_Detail_Total.SelectedValue == "2")//Cả tòa cấp cao, toi cao và vụ tổng hợp đều dùng
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District_CW(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet các tỉnh trực thuộc cấp cao
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HNGĐT_Detai_District_cw.xls");
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
                if (Ra_Detail_Total.SelectedValue == "3")// Tổng hợp 1
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HNGĐT_Total_District_01.xls");
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
                else //tong hop
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HNGĐT_Total_District.xls");
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
        public void Ex_Drop_Options_Marriges_Retrials()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (Drop_object.SelectedValue == "CW")
            {
                if (Vleustype == "CW")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_Names = "CÁC TÒA ÁN CẤP CAO";
                    hi_text_courts.Value = "Số liệu từ các tòa án CC: ";
                    v_court = Hi_value_ID_Court.Value;
                }
            }
            else if (Drop_object.SelectedValue == "TW")
            {
                if ((Vleustype == "TW") && (Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString()) != "1"))
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    v_Names = "CÁC TÒA ÁN TỐI CAO";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Marriges_Retrials M_Objecs = new M_Marriges_Retrials();
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=HNTT_TD.xls");
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
            else
            {
                if (Ra_Detail_Total.SelectedValue == "1")
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HNTT_Detai_District.xls");
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
                if (Ra_Detail_Total.SelectedValue == "2")//Cả tòa cấp cao, toi cao và vụ tổng hợp đều dùng
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District_CW(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet các tỉnh trực thuộc cấp cao
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HNTT_Detai_District_cw.xls");
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
                if (Ra_Detail_Total.SelectedValue == "3")// Tổng hợp 1
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HNTT_Total_District_01.xls");
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
                else //tong hop
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HNTT_Total_District.xls");
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
        //---------------Export Hon nhan gia dinh end-----------------------
        //---------------Export Kinh te ------------------------------------
        public void Ex_Drop_Options_Economics_Instances()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = 38;
            if (Drop_object.SelectedValue == "H")
            {
                if (Vleustype == "H")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                    hi_text_courts.Value = "Số liệu từ các Quận/Huyện: ";
                }
                else if (Vleustype == "T")
                {
                    v_options = 2;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    else
                    {
                        v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    }
                    v_Names = "CÁC HUYỆN " + Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC HUYỆN";
                }
            }
            else if (Drop_object.SelectedValue == "T")
            {
                if (Vleustype == "T")
                {
                    v_options = 1;
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC TỈNH";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Judge_Economics M_Objecs = new M_Judge_Economics();
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=KTST_TD.xls");
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
            else
            {//chi tiet
                if (Ra_Detail_Total.SelectedValue == "1")
                {
                    if ((Vleustype == "T") || (Vleustype == "H"))
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=KTST_Detai_District.xls");
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
                    else
                    { //khi la user vu tong hop

                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        if (Drop_object.SelectedValue == "H")
                        {
                            li_sw = M_Objecs.Judge_Export_Detail_All_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        else
                        {
                            li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=KTST_Detai_All_01.xls");
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
                if (Ra_Detail_Total.SelectedValue == "2")//chỉ vụ tổng hợp mới dùng
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_All(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=KTST_Detai_All.xls");
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
                else//tổng hợp 
                {
                    //Cấp huyện hoặc cấp tỉnh
                    if ((Vleustype == "T") || (Vleustype == "H"))
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=KTST_Total_District.xls");
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
                    else //vụ tổng họp
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        if (Drop_object.SelectedValue == "H")
                        {
                            li_sw = M_Objecs.Judge_Export_Total_All_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        else
                        {
                            li_sw = M_Objecs.Judge_Export_Total_District_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        #region Lay bao cao tong hop
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=KTST_Total_63.xls");
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
        }
        public void Ex_Drop_Options_Economics_Appeals()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (Drop_object.SelectedValue == "T")
            {
                if (Vleustype == "T")
                {
                    v_options = 1;
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                    hi_text_courts.Value = "Số liệu từ các Tỉnh/TP: ";
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC TỈNH";
                    hi_text_courts.Value = "Số liệu từ các Tỉnh/TP: ";
                }
            }
            else if (Drop_object.SelectedValue == "CW")
            {
                if (Vleustype == "CW")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_Names = "CÁC TÒA ÁN CẤP CAO";
                    hi_text_courts.Value = "Số liệu từ các tòa án CC: ";
                    v_court = Hi_value_ID_Court.Value;
                }
            }
            else if (Drop_object.SelectedValue == "TW")
            {
                if ((Vleustype == "TW") && (Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString()) != "1"))
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    v_Names = "CÁC TÒA ÁN TỐI CAO";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Economic_Appeals M_Objecs = new M_Economic_Appeals();
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=TKPT_TD.xls");
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
            else
            {
                if (Ra_Detail_Total.SelectedValue == "1")
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=TKPT_Detai_District.xls");
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
                if (Ra_Detail_Total.SelectedValue == "2")//Cả tòa cấp cao, toi cao và vụ tổng hợp đều dùng
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District_CW(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet các tỉnh trực thuộc cấp cao
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=TKPT_Detai_District_cw.xls");
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
                if (Ra_Detail_Total.SelectedValue == "3")// Tổng hợp 1
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=TKPT_Total_District_01.xls");
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
                else //tong hop
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=TKPT_Total_District.xls");
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
        public void Ex_Drop_Options_Economics_Cassation()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (Drop_object.SelectedValue == "CW")
            {
                if (Vleustype == "CW")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_Names = "CÁC TÒA ÁN CẤP CAO";
                    hi_text_courts.Value = "Số liệu từ các tòa án CC: ";
                    v_court = Hi_value_ID_Court.Value;
                }
            }
            else if (Drop_object.SelectedValue == "TW")
            {
                if ((Vleustype == "TW") && (Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString()) != "1"))
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    v_Names = "CÁC TÒA ÁN TỐI CAO";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Economic_Cassation M_Objecs = new M_Economic_Cassation();
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=KTGĐT_TD.xls");
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
            else
            {
                if (Ra_Detail_Total.SelectedValue == "1")
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=KTGĐT_Detai_District.xls");
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
                if (Ra_Detail_Total.SelectedValue == "2")//Cả tòa cấp cao, toi cao và vụ tổng hợp đều dùng
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District_CW(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet các tỉnh trực thuộc cấp cao
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=KTGĐT_Detai_District_cw.xls");
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
                if (Ra_Detail_Total.SelectedValue == "3")// Tổng hợp 1
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=KTGĐT_Total_District_01.xls");
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
                else //tong hop
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=KTGĐT_Total_District.xls");
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
        public void Ex_Drop_Options_Economics_Retrials()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (Drop_object.SelectedValue == "CW")
            {
                if (Vleustype == "CW")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_Names = "CÁC TÒA ÁN CẤP CAO";
                    hi_text_courts.Value = "Số liệu từ các tòa án CC: ";
                    v_court = Hi_value_ID_Court.Value;
                }
            }
            else if (Drop_object.SelectedValue == "TW")
            {
                if ((Vleustype == "TW") && (Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString()) != "1"))
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    v_Names = "CÁC TÒA ÁN TỐI CAO";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Economic_Retrials M_Objecs = new M_Economic_Retrials();
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=KTTT_TD.xls");
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
            else
            {
                if (Ra_Detail_Total.SelectedValue == "1")
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=KTTT_Detai_District.xls");
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
                if (Ra_Detail_Total.SelectedValue == "2")//Cả tòa cấp cao, toi cao và vụ tổng hợp đều dùng
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District_CW(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet các tỉnh trực thuộc cấp cao
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=KTTT_Detai_District_cw.xls");
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
                if (Ra_Detail_Total.SelectedValue == "3")// Tổng hợp 1
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=KTTT_Total_District_01.xls");
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
                else //tong hop
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=KTTT_Total_District.xls");
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
        //---------------Export Kinh te end---------------------------------
        //---------------Export Lao dong ------------------------------------
        public void Ex_Drop_Options_Labors_Instances()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = 43;
            if (Drop_object.SelectedValue == "H")
            {
                if (Vleustype == "H")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                    hi_text_courts.Value = "Số liệu từ các Quận/Huyện: ";
                }
                else if (Vleustype == "T")
                {
                    v_options = 2;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    else
                    {
                        v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    }
                    v_Names = "CÁC HUYỆN " + Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC HUYỆN";
                }
            }
            else if (Drop_object.SelectedValue == "T")
            {
                if (Vleustype == "T")
                {
                    v_options = 1;
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC TỈNH";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Judge_Labors M_Objecs = new M_Judge_Labors();
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=LĐST_TD.xls");
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
            else
            {//chi tiet
                if (Ra_Detail_Total.SelectedValue == "1")
                {
                    if ((Vleustype == "T") || (Vleustype == "H"))
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=LĐST_Detai_District.xls");
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
                    else
                    { //khi la user vu tong hop

                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        if (Drop_object.SelectedValue == "H")
                        {
                            li_sw = M_Objecs.Judge_Export_Detail_All_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        else
                        {
                            li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=LĐST_Detai_All_01.xls");
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
                if (Ra_Detail_Total.SelectedValue == "2")//chỉ vụ tổng hợp mới dùng
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_All(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=LĐST_Detai_All.xls");
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
                else//tổng hợp 
                {
                    //Cấp huyện hoặc cấp tỉnh
                    if ((Vleustype == "T") || (Vleustype == "H"))
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=LĐST_Total_District.xls");
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
                    else //vụ tổng họp
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        if (Drop_object.SelectedValue == "H")
                        {
                            li_sw = M_Objecs.Judge_Export_Total_All_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        else
                        {
                            li_sw = M_Objecs.Judge_Export_Total_District_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        #region Lay bao cao tong hop
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=LĐST_Total_63.xls");
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
        }
        public void Ex_Drop_Options_Labors_Appeals()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (Drop_object.SelectedValue == "T")
            {
                if (Vleustype == "T")
                {
                    v_options = 1;
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                    hi_text_courts.Value = "Số liệu từ các Tỉnh/TP: ";
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC TỈNH";
                    hi_text_courts.Value = "Số liệu từ các Tỉnh/TP: ";
                }
            }
            else if (Drop_object.SelectedValue == "CW")
            {
                if (Vleustype == "CW")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_Names = "CÁC TÒA ÁN CẤP CAO";
                    hi_text_courts.Value = "Số liệu từ các tòa án CC: ";
                    v_court = Hi_value_ID_Court.Value;
                }
            }
            else if (Drop_object.SelectedValue == "TW")
            {
                if ((Vleustype == "TW") && (Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString()) != "1"))
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    v_Names = "CÁC TÒA ÁN TỐI CAO";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Labor_Appeals M_Objecs = new M_Labor_Appeals();
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=LĐPT_TD.xls");
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
            else
            {
                if (Ra_Detail_Total.SelectedValue == "1")
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=LĐPT_Detai_District.xls");
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
                if (Ra_Detail_Total.SelectedValue == "2")//Cả tòa cấp cao, toi cao và vụ tổng hợp đều dùng
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District_CW(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet các tỉnh trực thuộc cấp cao
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=LĐPT_Detai_District_cw.xls");
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
                if (Ra_Detail_Total.SelectedValue == "3")// Tổng hợp 1
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=LĐPT_Total_District_01.xls");
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
                else //tong hop
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=LĐPT_Total_District.xls");
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
        public void Ex_Drop_Options_Labors_Cassation()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (Drop_object.SelectedValue == "CW")
            {
                if (Vleustype == "CW")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_Names = "CÁC TÒA ÁN CẤP CAO";
                    hi_text_courts.Value = "Số liệu từ các tòa án CC: ";
                    v_court = Hi_value_ID_Court.Value;
                }
            }
            else if (Drop_object.SelectedValue == "TW")
            {
                if ((Vleustype == "TW") && (Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString()) != "1"))
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    v_Names = "CÁC TÒA ÁN TỐI CAO";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Labor_Cassation M_Objecs = new M_Labor_Cassation();
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=LĐGĐT_TD.xls");
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
            else
            {
                if (Ra_Detail_Total.SelectedValue == "1")
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=LĐGĐT_Detai_District.xls");
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
                if (Ra_Detail_Total.SelectedValue == "2")//Cả tòa cấp cao, toi cao và vụ tổng hợp đều dùng
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District_CW(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet các tỉnh trực thuộc cấp cao
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=LĐGĐT_Detai_District_cw.xls");
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
                if (Ra_Detail_Total.SelectedValue == "3")// Tổng hợp 1
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=LĐGĐT_Total_District_01.xls");
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
                else //tong hop
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=LĐGĐT_Total_District.xls");
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
        public void Ex_Drop_Options_Labors_Retrials()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (Drop_object.SelectedValue == "CW")
            {
                if (Vleustype == "CW")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_Names = "CÁC TÒA ÁN CẤP CAO";
                    hi_text_courts.Value = "Số liệu từ các tòa án CC: ";
                    v_court = Hi_value_ID_Court.Value;
                }
            }
            else if (Drop_object.SelectedValue == "TW")
            {
                if ((Vleustype == "TW") && (Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString()) != "1"))
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    v_Names = "CÁC TÒA ÁN TỐI CAO";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Labor_Retrials M_Objecs = new M_Labor_Retrials();
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=LĐTT_TD.xls");
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
            else
            {
                if (Ra_Detail_Total.SelectedValue == "1")
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=LĐTT_Detai_District.xls");
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
                if (Ra_Detail_Total.SelectedValue == "2")//Cả tòa cấp cao, toi cao và vụ tổng hợp đều dùng
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District_CW(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet các tỉnh trực thuộc cấp cao
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=LĐTT_Detai_District_cw.xls");
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
                if (Ra_Detail_Total.SelectedValue == "3")// Tổng hợp 1
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=LĐTT_Total_District_01.xls");
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
                else //tong hop
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=LĐTT_Total_District.xls");
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
        //---------------Export Lao dong end---------------------------------
        //---------------Export hanh chinh ----------------------------------
        public void Ex_Drop_Options_Admin_Instances()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue); ;
            if (Drop_object.SelectedValue == "H")
            {
                if (Vleustype == "H")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                    hi_text_courts.Value = "Số liệu từ các Quận/Huyện: ";
                }
                else if (Vleustype == "T")
                {
                    v_options = 2;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    else
                    {
                        v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    }
                    v_Names = "CÁC HUYỆN " + Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC HUYỆN";
                }
            }
            else if (Drop_object.SelectedValue == "T")
            {
                if (Vleustype == "T")
                {
                    v_options = 1;
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC TỈNH";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Judge_Admin M_Objecs = new M_Judge_Admin();
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=HCST_TD.xls");
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
            else
            {//chi tiet
                if (Ra_Detail_Total.SelectedValue == "1")
                {
                    if ((Vleustype == "T") || (Vleustype == "H"))
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=HCST_Detai_District.xls");
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
                    else
                    { //khi la user vu tong hop

                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        if (Drop_object.SelectedValue == "H")
                        {
                            li_sw = M_Objecs.Judge_Export_Detail_All_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        else
                        {
                            li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=HCST_Detai_All_01.xls");
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
                if (Ra_Detail_Total.SelectedValue == "2")//chỉ vụ tổng hợp mới dùng
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_All(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HCST_Detai_All.xls");
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
                else//tổng hợp 
                {
                    //Cấp huyện hoặc cấp tỉnh
                    if ((Vleustype == "T") || (Vleustype == "H"))
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        #region Lay bao cao chi tiet cap huyen
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=HCST_Total_District.xls");
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
                    else //vụ tổng họp
                    {
                        List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                        Literal Table_Str_Totals = new Literal();
                        if (Drop_object.SelectedValue == "H")
                        {
                            li_sw = M_Objecs.Judge_Export_Total_All_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        else
                        {
                            li_sw = M_Objecs.Judge_Export_Total_District_63(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                        }
                        #region Lay bao cao tong hop
                        foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                        {
                            Table_Str_Totals.Text += its.Text_Report;
                        }
                        //-------------------Export---------------------------
                        Response.Clear();
                        Response.AddHeader("content-disposition", "attachment;filename=HCST_Total_63.xls");
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
        }
        public void Ex_Drop_Options_Admin_Appeals()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (Drop_object.SelectedValue == "T")
            {
                if (Vleustype == "T")
                {
                    v_options = 1;
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                    hi_text_courts.Value = "Số liệu từ các Tỉnh/TP: ";
                }
                else
                {
                    v_options = 3;
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CÁC TỈNH";
                    hi_text_courts.Value = "Số liệu từ các Tỉnh/TP: ";
                }
            }
            else if (Drop_object.SelectedValue == "CW")
            {
                if (Vleustype == "CW")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_Names = "CÁC TÒA ÁN CẤP CAO";
                    hi_text_courts.Value = "Số liệu từ các tòa án CC: ";
                    v_court = Hi_value_ID_Court.Value;
                }
            }
            else if (Drop_object.SelectedValue == "TW")
            {
                if ((Vleustype == "TW") && (Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString()) != "1"))
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    v_Names = "CÁC TÒA ÁN TỐI CAO";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Admin_Appeals M_Objecs = new M_Admin_Appeals();
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=HCPT_TD.xls");
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
            else
            {
                if (Ra_Detail_Total.SelectedValue == "1")
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HCPT_Detai_District.xls");
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
                if (Ra_Detail_Total.SelectedValue == "2")//Cả tòa cấp cao, toi cao và vụ tổng hợp đều dùng
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District_CW(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet các tỉnh trực thuộc cấp cao
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HCPT_Detai_District_cw.xls");
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
                if (Ra_Detail_Total.SelectedValue == "3")// Tổng hợp 1
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HCPT_Total_District_01.xls");
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
                else //tong hop
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HCPT_Total_District.xls");
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
        public void Ex_Drop_Options_Admin_Cassation()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (Drop_object.SelectedValue == "CW")
            {
                if (Vleustype == "CW")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_Names = "CÁC TÒA ÁN CẤP CAO";
                    hi_text_courts.Value = "Số liệu từ các tòa án CC: ";
                    v_court = Hi_value_ID_Court.Value;
                }
            }
            else if (Drop_object.SelectedValue == "TW")
            {
                if ((Vleustype == "TW") && (Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString()) != "1"))
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    v_Names = "CÁC TÒA ÁN TỐI CAO";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Admin_Cassation M_Objecs = new M_Admin_Cassation();
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=HCGĐT_TD.xls");
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
            else
            {
                if (Ra_Detail_Total.SelectedValue == "1")
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HCGĐT_Detai_District.xls");
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
                if (Ra_Detail_Total.SelectedValue == "2")//Cả tòa cấp cao, toi cao và vụ tổng hợp đều dùng
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District_CW(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet các tỉnh trực thuộc cấp cao
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HCGĐT_Detai_District_cw.xls");
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
                if (Ra_Detail_Total.SelectedValue == "3")// Tổng hợp 1
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HCGĐT_Total_District_01.xls");
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
                else //tong hop
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HCGĐT_Total_District.xls");
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
        public void Ex_Drop_Options_Admin_Retrials()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (Drop_object.SelectedValue == "CW")
            {
                if (Vleustype == "CW")
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    v_Names = "CÁC TÒA ÁN CẤP CAO";
                    hi_text_courts.Value = "Số liệu từ các tòa án CC: ";
                    v_court = Hi_value_ID_Court.Value;
                }
            }
            else if (Drop_object.SelectedValue == "TW")
            {
                if ((Vleustype == "TW") && (Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString()) != "1"))
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    v_Names = "CÁC TÒA ÁN TỐI CAO";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Admin_Retrials M_Objecs = new M_Admin_Retrials();
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=HCTT_TD.xls");
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
            else
            {
                if (Ra_Detail_Total.SelectedValue == "1")
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HCTT_Detai_District.xls");
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
                if (Ra_Detail_Total.SelectedValue == "2")//Cả tòa cấp cao, toi cao và vụ tổng hợp đều dùng
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District_CW(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet các tỉnh trực thuộc cấp cao
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HCTT_Detai_District_cw.xls");
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
                if (Ra_Detail_Total.SelectedValue == "3")// Tổng hợp 1
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HCTT_Total_District_01.xls");
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
                else //tong hop
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HCTT_Total_District.xls");
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
        public void Ex_Drop_Options_Admin_Special()
        {
            String Vleustype = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            String v_Cases = hi_value_id_Cases.Value;
            String v_court = "";
            String v_Names = "";
            Int16 v_options = 1;
            Int16 owis = 0;
            Int32 sth = 0;
            Int32 v_TYPES_OF = Convert.ToInt32(Drop_Options.SelectedValue);
            if (Drop_object.SelectedValue == "TW")
            {
                if ((Vleustype == "TW") && (Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString()) != "1"))
                {
                    v_court = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    v_Names = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString()).ToUpper();
                    owis = 1;
                }
                else
                {
                    v_options = 3;
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    v_Names = "CÁC TÒA ÁN TỐI CAO";
                }
            }
            if (v_court == "") { v_court = "-1"; }
            M_Admin_Special M_Objecs = new M_Admin_Special();
            if (ch_options_TD.Checked == true)
            {

                List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                Literal Table_Str_Totals = new Literal();
                li_sw = M_Objecs.Judge_Export_TD(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                #region BC theo toi danh cap huyen
                foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                {
                    Table_Str_Totals.Text += its.Text_Report;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=HC_TTĐB_TD.xls");
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
            else
            {
                if (Ra_Detail_Total.SelectedValue == "1")
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HC_TTĐB_Detai_District.xls");
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
                if (Ra_Detail_Total.SelectedValue == "2")//Cả tòa cấp cao, toi cao và vụ tổng hợp đều dùng
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Detail_District_CW(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet các tỉnh trực thuộc cấp cao
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HC_TTĐB_Detai_District_cw.xls");
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
                if (Ra_Detail_Total.SelectedValue == "3")// Tổng hợp 1
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District_01(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HC_TTĐB_Total_District_01.xls");
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
                else //tong hop
                {
                    List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
                    Literal Table_Str_Totals = new Literal();
                    li_sw = M_Objecs.Judge_Export_Total_District(Drop_object.SelectedValue, v_TYPES_OF, v_Names, v_court, v_Cases, Convert.ToDateTime(txt_day_from.Text + " 00:00:00", cul), Convert.ToDateTime(txt_day_to.Text + " 23:59:59", cul), v_options, owis, sth);
                    #region Lay bao cao chi tiet cap huyen
                    foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
                    {
                        Table_Str_Totals.Text += its.Text_Report;
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=HC_TTĐB_Total_District.xls");
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
        //---------------Export hanh chinh end-------------------------------
        public void Getdata_Courts(List<BL.THONGKE.Info.Courts> List_Courts)
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
                Treeview_Load(TreeView_Courts, null, tvns);
            }
            MP_Window_courts.Show();
        }
        public void Get_Courts_Options()
        {
            String v_typecourts = Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString());
            BL.THONGKE.M_Courts M_Objects = new M_Courts();
            if (Drop_object.SelectedValue == "TH")
            {
                Ra_level_tr_div.Attributes.Add("display", "Block");
                hi_value_objects.Value = String.Empty;
                txt_courts_show.Text = String.Empty;
                Show_Court_Cheks.Value = String.Empty;
                Drop_object.SelectedValue = "T";
            }
            if (Drop_object.SelectedValue == "H")
            {
                Ra_level_tr_div.Attributes.Add("display", "none");
                List<BL.THONGKE.Info.Courts> List_Courtsth = M_Objects.Court_List_Options_Huyen_QS(Convert.ToInt32(v_typecourts));
                Getdata_Courts(List_Courtsth);
            }
            else
            {
                Ra_level_tr_div.Attributes.Add("display", "none");
                List<BL.THONGKE.Info.Courts> List_Courts = M_Objects.Court_List_Options_QS(Convert.ToInt32(v_typecourts), Drop_object.SelectedValue);
                BL.THONGKE.Info.Courts obcourts = new BL.THONGKE.Info.Courts(1, 0, "T001", "Danh sách các tòa án", "", 0);
                List_Courts.Add(obcourts);
                foreach (BL.THONGKE.Info.Courts its in List_Courts)
                {
                    if (its.ID != 1)
                    {
                        its.PARENT_ID = 1;
                    }
                }
                Getdata_Courts(List_Courts);
            }
        }
        public void Get_Courts_Tinh()
        {
            Int32 value_courts = Convert.ToInt32(Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString()));
            BL.THONGKE.M_Courts M_Objects = new M_Courts();
            List<BL.THONGKE.Info.Courts> List_Courts = M_Objects.Court_List_Tinh(value_courts);
            BL.THONGKE.Info.Courts obcourts = new BL.THONGKE.Info.Courts(1, 0, "T001", "Danh sách các tòa án", "", 0);
            List_Courts.Add(obcourts);
            foreach (BL.THONGKE.Info.Courts its in List_Courts)
            {
                if (its.ID != 1)
                {
                    its.PARENT_ID = 1;
                }
            }
            Getdata_Courts(List_Courts);
        }

        #region "COMMENTS"
        /*
        protected void Ra_Chapters_NodeCheck(object o, TreeNodeEventArgs e)
        {
            IList<TreeNode> nodeCollection = Ra_Chapters.CheckedNodes;
            txt_chapters.Text = String.Empty;
            hi_value_id_chapters.Value = String.Empty;
            foreach (TreeNode node in nodeCollection)
            {
                if (node.Value != "1")
                {
                    txt_crimial_show.Text = String.Empty;
                    hi_value_id_criminal.Value = String.Empty;
                    if (txt_chapters.Text == "")
                    {
                        txt_chapters.Text = node.Text;
                        hi_value_id_chapters.Value = node.Value;
                    }
                    else
                    {
                        txt_chapters.Text += "-" + node.Text;
                        hi_value_id_chapters.Value += "," + node.Value;
                    }
                }
            }
        }
        protected void RT_Cases_NodeCheck(object o, TreeNodeEventArgs e)
        {
            IList<TreeNode> nodeCollection = RT_Cases.CheckedNodes;
            txt_Case_shows.Text = String.Empty;
            hi_value_id_Cases.Value = String.Empty;
            foreach (TreeNode node in nodeCollection)
            {
                if (node.Value != "0")
                {
                    if (txt_Case_shows.Text == "")
                    {
                        txt_Case_shows.Text = node.Text;
                        hi_value_id_Cases.Value = node.Value;
                    }
                    else
                    {
                        txt_Case_shows.Text += "-" + node.Text;
                        hi_value_id_Cases.Value += "," + node.Value;
                    }
                }
            }
        }
        protected void RT_Criminals_NodeCheck(object o, TreeNodeEventArgs e)
        {
            IList<TreeNode> nodeCollection = RT_Criminals.CheckedNodes;
            txt_crimial_show.Text = String.Empty;
            hi_value_id_criminal.Value = String.Empty;
            foreach (TreeNode node in nodeCollection)
            {
                if (node.Level != 0)
                {
                    if (txt_crimial_show.Text == "")
                    {
                        txt_crimial_show.Text = node.Text;
                        hi_value_id_criminal.Value = node.Value;
                    }
                    else
                    {
                        txt_crimial_show.Text += "-" + node.Text;
                        hi_value_id_criminal.Value += "," + node.Value;
                    }
                }
            }
        }
        */
        #endregion

        public void Get_Data_Criminals()
        {
            txt_crimial_show.Text = String.Empty;
            hi_value_id_criminal.Value = String.Empty;
            String s_values = "0";
            if (hi_value_id_chapters.Value != "")
            {
                s_values = hi_value_id_chapters.Value;
            }
            BL.THONGKE.M_Criminals M_Object = new BL.THONGKE.M_Criminals();
            List<BL.THONGKE.Info.Criminals> List_criminal = M_Object.Criminals_List_OfChapters(s_values);
            TreeNodeCollection nodeCollection = Ra_Chapters.CheckedNodes;
            int ss = 1;
            foreach (TreeNode node in nodeCollection)
            {
                if ((node.Checked == true) && (node.Value != "1"))
                {
                    BL.THONGKE.Info.Criminals obits = new BL.THONGKE.Info.Criminals();
                    obits.ID = ss;
                    obits.CRIMINAL_ID = (ss - 1).ToString();
                    obits.CRIMINAL_NAME = node.Text;
                    List_criminal.Add(obits);
                    foreach (BL.THONGKE.Info.Criminals its in List_criminal)
                    {
                        if (its.CHAPTER_ID.ToString() == node.Value)
                        {
                            its.CHAPTER_ID = ss;
                        }
                    }
                    ss++;
                }
            }
            BL.ThongKe.Info.TreeviewNode tvn = new BL.ThongKe.Info.TreeviewNode();
            List<BL.ThongKe.Info.TreeviewNode> tvns = tvn.getCriminalsNode(List_criminal);
            Treeview_Load(RT_Criminals, null, tvns);
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
                    hi_text_courts.Value = txt_courts_show.Text;
                }
                else if (Drop_object.SelectedValue == "TH" || Drop_object.SelectedValue == "T,H")
                {
                    Hi_value_ID_Court.Value = Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString());
                    txt_courts_show.Text = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString());
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
                if (str_typeusers == "TW" || str_typeusers == "CW")
                {
                    if (v_typecourts == "1" || v_typecourts == "2")
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
        public void Get_Option_Permission(String v_typecourts, String str_typeusers)
        {
            List<BL.THONGKE.Info.Functions> List_Functions = (List<BL.THONGKE.Info.Functions>)Session["Function_List_Shows"];
            ListItem items = new ListItem();
            Drop_Options.Items.Clear();
            BL.THONGKE.M_Export_Permissions M_Object = new BL.THONGKE.M_Export_Permissions();
            List<BL.THONGKE.Info.Functions> List_fun = M_Object.Function_List_Per(Convert.ToInt32(Drop_Skin.SelectedValue), Database.GetUserName(Session["Sesion_Manager_ID"].ToString()));
            foreach (BL.THONGKE.Info.Functions its in List_fun)
            {
                items = new ListItem(its.FUNCTION_NAME, Convert.ToString(its.ID));
                Drop_Options.Items.Add(items);
            }
            Get_Object_Permission(v_typecourts, str_typeusers);
        }
        public void Get_Object_Permission(String v_typecourts, String str_typeusers)
        {
            ListItem items = new ListItem();
            ch_options_TD.Visible = true;
            Ra_level_tr_div.Visible = false;
            Ra_level_tr_div.Attributes.Add("display", "none");
            Drop_object.Items.Clear();
            BL.THONGKE.M_Export_Permissions M_Object = new BL.THONGKE.M_Export_Permissions();
            BL.THONGKE.Info.Functions obj_fun = M_Object.Function_List_ID(Convert.ToInt32(Drop_Options.SelectedValue));
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
                    if (v_typecourts == "1")//v_typecourts==1 vu tong hop
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
                    else if (v_typecourts == "2")//v_typecourts==2 toa quan su trung uong
                    {
                        if (arrst[i] == "T")
                        {
                            items = new ListItem("Cấp Quân khu", "T");
                            Drop_object.Items.Add(items);
                        }
                        if (arrst[i] == "H")
                        {
                            items = new ListItem("Cấp khu vực", "H");
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
            Load_Options_4E_Check();
        }
        public void Load_Options_4E_Check()
        {
            if (Drop_Options.SelectedValue == "54")
            {
                Radio_4E.Visible = true;
                contai_4E_tr.Style.Remove("display");
            }
            else
            {
                Radio_4E.Visible = false;
                contai_4E_tr.Style.Add("Display", "none");
            }
        }
        protected void Drop_object_SelectedIndexChanged(object sender, EventArgs e)
        {
            reset_DropCourt();
            reset_DropChapter();
            reset_DropCriminal();
            reset_DropCase();

            Load_Ra_Detail_Total();
            hi_value_objects.Value = String.Empty;
            txt_courts_show.Text = String.Empty;
            Show_Court_Cheks.Value = String.Empty;
        }
        protected void Drop_Skin_SelectedIndexChanged(object sender, EventArgs e)
        {
            reset_DropCourt();
            reset_DropChapter();
            reset_DropCriminal();
            reset_DropCase();

            Hi_value_ID_Court.Value = String.Empty;
            String v_typecourts = Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString());
            String str_typeusers = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            Get_Option_Permission(v_typecourts, str_typeusers);
            Get_Data_Cases();
            Load_Ra_Detail_Total();
            Load_Skin_Display();
        }
        public void Load_Skin_Display()
        {
            if (Drop_Skin.SelectedValue == "18")//Hình sự
            {
                id_chapers_tabales.Visible = true;
                id_criminal_tabales.Visible = true;
                id_show_check.Visible = true;
                id_cases_tabales.Visible = false;
                ch_options_TD.Text = " Theo tội danh";
            }
            else
            {
                id_chapers_tabales.Visible = false;
                id_criminal_tabales.Visible = false;
                id_show_check.Visible = false;
                id_cases_tabales.Visible = true;
                ch_options_TD.Text = " Theo Loại vụ án, Loại việc";
            }
        }
        protected void Drop_Options_SelectedIndexChanged(object sender, EventArgs e)
        {
            reset_DropCourt();
            reset_DropChapter();
            reset_DropCriminal();
            reset_DropCase();

            Hi_value_ID_Court.Value = String.Empty;
            hi_text_courts.Value = String.Empty;
            hi_value_objects.Value = String.Empty;
            txt_courts_show.Text = String.Empty;
            Show_Court_Cheks.Value = String.Empty;
            String v_typecourts = Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString());
            String str_typeusers = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            Get_Object_Permission(v_typecourts, str_typeusers);
            Load_Ra_Detail_Total();
            string values = Drop_Options.SelectedValue;
            switch (values)
            {
                case "19":
                case "68":
                case "20":
                case "71":
                case "21":
                case "87":
                case "22":
                case "88":
                case "23":
                case "24":
                    id_chapers_tabales.Visible = true;
                    id_criminal_tabales.Visible = true;
                    id_show_check.Visible = false;
                    id_cases_tabales.Visible = false;
                    break;
                case "25":
                case "72":
                case "73":
                case "75":
                case "79":
                case "80":
                case "81":
                case "83":
                case "86":
                case "89":
                case "90":
                    id_chapers_tabales.Visible = false;
                    id_criminal_tabales.Visible = false;
                    id_show_check.Visible = false;
                    id_cases_tabales.Visible = false;
                    break;
                default:
                    Get_Data_Cases();
                    id_chapers_tabales.Visible = false;
                    id_criminal_tabales.Visible = false;
                    id_show_check.Visible = false;
                    id_cases_tabales.Visible = true;
                    break;
            }
            Load_Options_4E_Check();
        }

        #region "BUTTON SHOW POPUP (HOLD OFF)"
        protected void cmd_courts_selects_Click(object sender, EventArgs e)
        {
            String v_typecourts = Database.GetUserCourtUserType(Session["Sesion_Manager_ID"].ToString());
            String str_typeusers = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            Get_Permission_Courts(v_typecourts, str_typeusers);
            ScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "window_Shows_courts()", true);
        }
        protected void cmd_chapters_selects_Click(object sender, EventArgs e)
        {
            txt_courts_show.Text = hi_text_courts.Value;
            MP_Window_Chapters.Show();
            Getdata_Chapters();
            ScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "window_Shows_chapters()", true);
        }
        protected void cmd_crimial_select_Click(object sender, EventArgs e)
        {
            txt_chapters.Text = hi_txt_chapters.Value;
            if (hi_value_id_chapters.Value != "")
            {
                Get_Data_Criminals();
                MP_Window_Criminal.Show();
            }
            ScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "window_Shows_criminals()", true);
        }
        protected void cmd_reset_Click(object sender, EventArgs e)
        {
            resetform();
        }
        #endregion

        public void Getdata_Chapters()
        {
            BL.THONGKE.M_Chapters M_Object_Chapter = new BL.THONGKE.M_Chapters();
            //Bộ luật hình sự năm 1999;id=5
            //Luật sửa đổi, bổ sung một số điều của BLHS năm 2015;id=6
            //Luật sửa đổi, bổ sung một số điều của BLHS năm 2017;id=7
            //List<BL.THONGKE.Info.Chapters> List_Chapters = M_Object_Chapter.Chapters_List(3);
            List<BL.THONGKE.Info.Chapters> List_Chapters = M_Object_Chapter.Chapters_List(7);
            BL.THONGKE.Info.Chapters obits = new BL.THONGKE.Info.Chapters();
            obits.ID = 1;
            obits.TIMES = 0;
            obits.CHAPER_NAME = "Danh cách các chương";
            foreach (BL.THONGKE.Info.Chapters its in List_Chapters)
            {
                its.TIMES = 1;
            }
            List_Chapters.Add(obits);
            
            BL.ThongKe.Info.TreeviewNode tvn = new BL.ThongKe.Info.TreeviewNode();
            List<BL.ThongKe.Info.TreeviewNode> tvns = tvn.getChaptersNode(List_Chapters);
            Treeview_Load(Ra_Chapters, null, tvns);

        }

        protected void cmd_case_select_Click(object sender, EventArgs e)
        {
            txt_Case_shows.Text = hi_txt_Case.Value;
            if (hi_value_id_Cases.Value != "")
            {
                Get_Data_Cases();
                MP_Window_Cases.Show();
            }
            ScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "window_Shows_cases()", true);
        }
    }
}