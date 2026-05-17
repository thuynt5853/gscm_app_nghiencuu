using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.Quantri.Menu
{
    public partial class Danhsach : System.Web.UI.Page
    {
        string Node_CT = "ct_";
        GSTPContext dt = new GSTPContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                loaddropchuongtrinh();
                dropParent.Items.Add(new ListItem("Chọn", "0"));
                LoadTreeview("");
                loadthutu();
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                Cls_Comon.SetButton(cmdNew, oPer.TAOMOI);
                Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                Cls_Comon.SetButton(cmdDel, oPer.XOA);
            }
        }
        public void loaddropchuongtrinh()
        {
            dropchuongtrinh.DataSource = dt.QT_CHUONGTRINH.OrderBy(x => x.THUTU).ToList();
            dropchuongtrinh.DataValueField = "ID";
            dropchuongtrinh.DataTextField = "TEN";
            dropchuongtrinh.DataBind();
        }

        public void LoadTreeview(string dept)
        {
            treemenu.Nodes.Clear();
            TreeNode oRoot = new TreeNode("", "0");
            List<QT_HETHONG> lstHT = dt.QT_HETHONG.OrderBy(x => x.THUTU).ToList();
            foreach (QT_HETHONG h in lstHT)
            {
                TreeNode oN;
                string new_valueht = "ht_" + h.ID.ToString();
                oN = CreateNode(new_valueht, h.TEN.ToString(), "");
                oN.NavigateUrl = "javascript:;";
                List<QT_CHUONGTRINH> qtchuongtrinh = dt.QT_CHUONGTRINH.Where(x=>x.HETHONGID==h.ID).OrderBy(x => x.THUTU).ToList();
                if (qtchuongtrinh != null)
                {
                    foreach (QT_CHUONGTRINH oT in qtchuongtrinh)
                    {
                        TreeNode oNode;
                        string new_value = Node_CT + oT.ID.ToString();
                        oNode = CreateNode(new_value, oT.TEN.ToString(), "");
                        oN.ChildNodes.Add(oNode);
                        LoadTreeChuongTrinh(oNode, (int)oT.ID, dept);
                    }
                }
                treemenu.Nodes.Add(oN);
            }
            treemenu.CollapseAll();   
            foreach(TreeNode n in treemenu.Nodes)
            {
                n.Expand();
            }
        }
        private TreeNode CreateNode(string sNodeId, string sNodeText, string strImages)
        {
            TreeNode objTreeNode = new TreeNode();
            objTreeNode.Value = sNodeId;
            objTreeNode.Text = sNodeText;           
            return objTreeNode;
        }
        string PUBLIC_DEPT = "...";
        public void LoadTreeChuongTrinh(TreeNode root, int node_chuongtrinh, string dept)
        {
            List<QT_MENU> list = dt.QT_MENU.Where(x => x.CHUONGTRINHID == node_chuongtrinh && x.CAPCHAID == 0).OrderBy(y => y.THUTU).ToList();
            foreach (QT_MENU oT in list)
            {
                TreeNode oNode;

                oNode = CreateNode(oT.ID.ToString(), oT.TENMENU.ToString(),  "");
                dropParent.Items.Add(new ListItem(dept + oT.TENMENU, oT.ID.ToString()));
                root.ChildNodes.Add(oNode);
                LoadTreeChild(oNode, dept);
            }
        }
        public void LoadTreeChild(TreeNode root, string dept)
        {
            decimal nID = Convert.ToDecimal(root.Value);
            List<QT_MENU> listchild = dt.QT_MENU.Where(x => x.CAPCHAID == nID).OrderBy(y => y.THUTU).ToList();
            if (listchild != null)
            {
                foreach (QT_MENU child in listchild)
                {
                    string strdept = PUBLIC_DEPT + dept;
                    TreeNode nodechild;
                    nodechild = CreateNode(child.ID.ToString(), child.TENMENU.ToString(),  "");
                    root.ChildNodes.Add(nodechild);
                    dropParent.Items.Add(new ListItem(strdept + child.TENMENU, child.ID.ToString()));
                    LoadTreeChild(nodechild, strdept);
                }
            }
        }
        
        string PUBLIC_DEPT1 = "...";

        public void LoadTreeviewselected(string dept, string sapxep, int id)
        {
            dropParent.Items.Add(new ListItem("Chọn", "0"));
            List<QT_CHUONGTRINH> qtchuongtrinh = dt.QT_CHUONGTRINH.OrderBy(x => x.THUTU).ToList();
            if (qtchuongtrinh != null)
            {
                foreach (QT_CHUONGTRINH oT in qtchuongtrinh)
                {
                    LoadTreeselected((int)oT.ID, dept, sapxep);
                }
            }

        }
        public void LoadTreeselected(int node_chuongtrinh, string dept, string sapxep)
        {
            List<QT_MENU> list = dt.QT_MENU.Where(x => x.CHUONGTRINHID == node_chuongtrinh && x.CAPCHAID == 0).OrderBy(y => y.THUTU).ToList();
            foreach (QT_MENU oT in list)
            {
                dropParent.Items.Add(new ListItem(dept + oT.TENMENU, oT.ID.ToString()));
                LoadTreeChildselected((int)oT.ID, dept, sapxep);
            }
        }
        public void LoadTreeChildselected(int chaid, string dept, string sapxep)
        {
            List<QT_MENU> listchild = dt.QT_MENU.Where(x => x.CAPCHAID == chaid).OrderBy(y => y.THUTU).ToList();
            if (listchild != null)
            {
                foreach (QT_MENU child in listchild)
                {
                    string strdept = PUBLIC_DEPT1 + dept;

                    dropParent.Items.Add(new ListItem(strdept + child.TENMENU, child.ID.ToString()));
                    LoadTreeChildselected((int)child.ID, strdept, sapxep);
                }
            }
        }

        public void fillthutuid(int chuongtrinhid, int chaid)
        {
            dropthutu.Items.Clear();
            List<QT_MENU> list = dt.QT_MENU.Where(x => x.CHUONGTRINHID == chuongtrinhid && x.CAPCHAID == chaid).ToList();
            dropthutu.SelectedValue = Convert.ToString(list.Count + 1);
        }
        public List<QT_MENU> GetListMenuByID(string chuongtrinhid, string chaid)
        {
            if (chuongtrinhid.Contains(Node_CT) == true || treemenu.SelectedNode == null)
            {
                if (chuongtrinhid.Contains(Node_CT) == true)
                {
                    int ID = Convert.ToInt32(chuongtrinhid.Split('_')[1]);
                    return dt.QT_MENU.Where(x => x.CHUONGTRINHID == ID && x.CAPCHAID == 0).ToList();
                }
                else
                {
                    int ID = Convert.ToInt32(chuongtrinhid);
                    return dt.QT_MENU.Where(x => x.CHUONGTRINHID == ID && x.CAPCHAID == 0).ToList();
                }
            }
            else
            {
                int ID = Convert.ToInt32(chaid);
                return dt.QT_MENU.Where(x => x.CAPCHAID == ID).ToList();
            }
        }

        protected void btnNew_Click(object sender, EventArgs e)
        {

            btnLammoi_Click(sender, e);
            if (treemenu.SelectedNode != null)
            {
                if (treemenu.SelectedValue.Contains(Node_CT) == false)
                {
                    decimal nID = Convert.ToInt32(treemenu.SelectedValue);
                    QT_MENU qt_menu=dt.QT_MENU.Where(x=>x.ID== nID).FirstOrDefault();
                    dropParent.Items.Insert(0, new ListItem(qt_menu.TENMENU, qt_menu.ID.ToString()));
                    dropParent.SelectedValue = treemenu.SelectedValue;
                    FillThutu(GetListMenuByID("0", dropParent.SelectedValue).Count + 1);
                    dropthutu.SelectedIndex = dropthutu.Items.Count - 1;
                }
                else
                {
                    dropParent.SelectedValue = "0";
                    dropchuongtrinh.SelectedValue = treemenu.SelectedValue.Split('_')[1];
                    FillThutu(GetListMenuByID(treemenu.SelectedValue, dropParent.SelectedValue).Count + 1);
                    dropthutu.SelectedIndex = dropthutu.Items.Count - 1;
                }
            }
            else
            {
                btnLammoi_Click(sender, e);
                dropParent.SelectedValue = "0";
                FillThutu(GetListMenuByID(dropchuongtrinh.SelectedValue, "0").Count + 1);
                dropthutu.SelectedIndex = dropthutu.Items.Count - 1;
            }
            //LoadTreeview();
            hddid.Value = "";
            cmdDel.Enabled = true;
            cmdUpdate.Enabled = true;
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            //them
            if (hddid.Value == "" || hddid.Value == "00" || hddid.Value == "0")
            {
                decimal nCTID = Convert.ToDecimal(dropchuongtrinh.SelectedValue);
                decimal nCCID = Convert.ToDecimal(dropParent.SelectedValue);
                int iTT = Convert.ToInt32(dropthutu.SelectedValue);
                List<QT_MENU> laythutu = dt.QT_MENU.Where(x => x.CHUONGTRINHID == nCTID && x.CAPCHAID == nCCID && x.THUTU == iTT).ToList();
                if (laythutu.Count >= 1)
                {
                    lbthongbao.Text = "Thứ tự trong một cấp không được trùng nhau !";
                }
                else
                {
                    QT_MENU qt_menu = new QT_MENU();
                    qt_menu.CAPCHAID = Convert.ToDecimal(dropParent.SelectedValue);
                    qt_menu.TENMENU = txtTen.Text.Trim();
                    qt_menu.DUONGDAN = txtDuongdan.Text.Trim();
                    qt_menu.MAACTION = txtMaaction.Text.Trim();
                    qt_menu.CHUONGTRINHID = Convert.ToInt32(dropchuongtrinh.SelectedValue);
                    qt_menu.ISPHANNHOM = chkIsPhannhom.Checked ? 1 : 0; 
                        qt_menu.ISNOTMENU = chkIsNotMenu.Checked ? 1 : 0; 
                    qt_menu.HIEULUC = chkActive.Checked ? 1 : 0; 
                    qt_menu.ACTION = chkAction.Checked ? 1 : 0;
                    qt_menu.TAOMOI = chkthemmoi.Checked ? 1 : 0;
                    qt_menu.CAPNHAT = chkCapnhat.Checked ? 1 : 0;
                    qt_menu.XOA = chkxoa.Checked ? 1 : 0;

                    qt_menu.QUYENSOTHAM = chkSotham.Checked ? 1 : 0;
                    qt_menu.QUYENPHUCTHAM = chkPhuctham.Checked ? 1 : 0;
                    qt_menu.QUYENTOICAO = chkToicao.Checked ? 1 : 0;
                    qt_menu.QUYENQUANTRI = chkQuantri.Checked ? 1 : 0;

                    qt_menu.ISSOTHAM = chkViewSotham.Checked ? 1 : 0;
                    qt_menu.ISPHUCTHAM = chkViewPhuctham.Checked ? 1 : 0;
                    qt_menu.ISPHUCTHAM_KCKNQDK = chkViewPhucthamQDK.Checked ? 1 : 0;

                    qt_menu.THUTU = Convert.ToInt32(dropthutu.Text);
                    qt_menu.ARRSAPXEP = "moi";
                    QT_MENU layidcha = dt.QT_MENU.Where(x => x.ID == qt_menu.CAPCHAID).FirstOrDefault();
                    dt.QT_MENU.Add(qt_menu);
                    dt.SaveChanges();
                    string dgdan;
                    string duongdan;
                    if (layidcha == null)
                    {
                        duongdan = "0/" + qt_menu.ID;
                        if (Convert.ToInt32(dropthutu.SelectedValue) < 10)
                        {
                            qt_menu.ARRTHUTU = "0" + "/" + dropthutu.SelectedValue + "00";
                        }
                        else
                        {
                            qt_menu.ARRTHUTU = "0" + "/9" + dropthutu.SelectedValue;
                        }
                    }
                    else
                    {
                        dgdan = layidcha.ARRSAPXEP;
                        duongdan = dgdan + "/" + qt_menu.ID;

                        if (Convert.ToInt32(dropthutu.SelectedValue) < 10)
                        {
                            qt_menu.ARRTHUTU = layidcha.ARRTHUTU + "/" + dropthutu.SelectedValue + "00";
                        }
                        else
                        {
                            qt_menu.ARRTHUTU = layidcha.ARRTHUTU + "/9" + dropthutu.SelectedValue;
                        }
                    }
                    qt_menu.ARRSAPXEP = duongdan;
                    dt.SaveChanges();
                    //loaddatasua();
                    //LoadTreeview("");
                    if(treemenu.SelectedNode !=null)
                    {
                        treemenu.SelectedNode.ChildNodes.Add(new TreeNode(qt_menu.TENMENU, qt_menu.ID.ToString()));
                        treemenu.SelectedNode.Expand();

                        FillThutu(treemenu.SelectedNode.ChildNodes.Count+1);

                    }
                    btnLammoi_Click(sender, e);
                    lbthongbao.Text = "Thêm mới thành công!";
                    return;
                }
            }
            //sua
            else
            {

                decimal nID = Convert.ToDecimal(hddid.Value);
                decimal nCTID = Convert.ToDecimal(dropchuongtrinh.SelectedValue);
                decimal nCCID = Convert.ToDecimal(dropParent.SelectedValue);
                int iTT = Convert.ToInt32(dropthutu.SelectedValue);

                QT_MENU laythutu = dt.QT_MENU.Where(x => x.ID == nID).FirstOrDefault();

                List<QT_MENU> laythutuchuowngtrinh = dt.QT_MENU.Where(x => x.CHUONGTRINHID == nCTID && x.CAPCHAID == nCCID && x.THUTU == iTT).ToList();
                List<QT_MENU> laymathutu = dt.QT_MENU.Where(x => x.CAPCHAID == nCCID && x.THUTU == iTT).ToList();

                if ((laythutu.THUTU == Convert.ToInt32(dropthutu.SelectedValue) && laythutu.CHUONGTRINHID == Convert.ToInt32(dropchuongtrinh.SelectedValue)) || (laymathutu.Count == 0 || laythutuchuowngtrinh.Count == 0))
                {
                    QT_MENU qt_menu = dt.QT_MENU.Where(x => x.ID == nID).FirstOrDefault();

                    if (qt_menu.ID == Convert.ToInt32(dropParent.SelectedValue))
                    {
                        lbthongbao.Text = "Menu cấp trên không thể là chính nó!";
                    }
                    else
                    {


                        qt_menu.TENMENU = txtTen.Text;
                        qt_menu.DUONGDAN = txtDuongdan.Text;
                        qt_menu.MAACTION = txtMaaction.Text;
                        qt_menu.CHUONGTRINHID = Convert.ToInt32(dropchuongtrinh.SelectedValue);
                        qt_menu.ISPHANNHOM = chkIsPhannhom.Checked ? 1 : 0;
                        qt_menu.ISNOTMENU = chkIsNotMenu.Checked ? 1 : 0;
                        qt_menu.HIEULUC = chkActive.Checked ? 1 : 0;
                        qt_menu.ACTION = chkAction.Checked ? 1 : 0;
                      
                        qt_menu.TAOMOI = chkthemmoi.Checked ? 1 : 0;
                        qt_menu.CAPNHAT = chkCapnhat.Checked ? 1 : 0;
                        qt_menu.XOA = chkxoa.Checked ? 1 : 0;

                        qt_menu.QUYENSOTHAM = chkSotham.Checked ? 1 : 0;
                        qt_menu.QUYENPHUCTHAM = chkPhuctham.Checked ? 1 : 0;
                        qt_menu.QUYENTOICAO = chkToicao.Checked ? 1 : 0;
                        qt_menu.QUYENQUANTRI = chkQuantri.Checked ? 1 : 0;
                        qt_menu.ISSOTHAM = chkViewSotham.Checked ? 1 : 0;
                        qt_menu.ISPHUCTHAM = chkViewPhuctham.Checked ? 1 : 0;
                        qt_menu.ISPHUCTHAM_KCKNQDK = chkViewPhucthamQDK.Checked ? 1 : 0;
                        qt_menu.THUTU = Convert.ToInt32(dropthutu.Text);
                        qt_menu.ARRSAPXEP = "moi";
                        QT_MENU layidcha = dt.QT_MENU.Where(x => x.ID ==qt_menu.CAPCHAID).FirstOrDefault();
                        
                        if (layidcha == null)
                        {
                            if (Convert.ToInt32(dropthutu.SelectedValue) < 10)
                            {
                                qt_menu.ARRTHUTU = "0" + "/" + dropthutu.SelectedValue + "00";
                            }
                            else
                            {
                                qt_menu.ARRTHUTU = "0" + "/9" + dropthutu.SelectedValue;
                            }
                            qt_menu.ARRSAPXEP = "0" + "/" + qt_menu.ID;
                        }
                        else
                        {
                            string arrthutu = layidcha.ARRTHUTU;
                            if (Convert.ToInt32(dropthutu.SelectedValue) < 10)
                            {
                                qt_menu.ARRTHUTU = arrthutu + "/" + dropthutu.SelectedValue + "00";
                            }
                            else
                            {
                                qt_menu.ARRTHUTU = arrthutu + "/9" + dropthutu.SelectedValue;
                            }
                            qt_menu.ARRSAPXEP = layidcha.ARRSAPXEP + "/" + qt_menu.ID;
                        }
                        if (qt_menu.CAPCHAID == Convert.ToInt32(dropParent.SelectedValue))
                        {
                            dt.SaveChanges();
                            QT_Menu_UpdateArrThutu(qt_menu);
                            loaddatasua();
                            btnLammoi_Click(sender, e);
                            lbthongbao.Text = "Lưu thành công!";
                            SuaArraychuongtrinhID((int)qt_menu.ID, Convert.ToInt32(qt_menu.CHUONGTRINHID));
                            return;
                        }
                        else
                        {
                            qt_menu.CAPCHAID = Convert.ToInt32(dropParent.SelectedValue);
                            if (layidcha == null)
                            {
                                qt_menu.ARRSAPXEP = "0" + "/" + qt_menu.ID;
                                dt.SaveChanges();
                                QT_Menu_UpdateArrThutu(qt_menu);
                                SuaArraychuongtrinhID((int)qt_menu.ID, Convert.ToInt32(qt_menu.CHUONGTRINHID));
                            }
                            else
                            {
                                string arrthutu = layidcha.ARRSAPXEP;
                                qt_menu.ARRSAPXEP = arrthutu + "/" + qt_menu.ID;
                                dt.SaveChanges();
                                QT_Menu_UpdateArrThutu(qt_menu);
                                SuaArraychuongtrinhID((int)qt_menu.ID, Convert.ToInt32(qt_menu.CHUONGTRINHID));
                            }
                            loaddatasua();
                            hddid.Value = dropParent.SelectedValue;
                            btnLammoi_Click(sender, e);
                            lbthongbao.Text = "Lưu thành công!";
                            return;
                        }

                    }
                }
                else
                {
                    lbthongbao.Text = "Thứ tự trong một cấp không được trùng nhau !";
                }
            }
            LoadTreeview("");
            //Reset Session Menu
            string strUserID = Session["UserID"] + "";
            int UserID = 0;
            if (strUserID != "") UserID = Convert.ToInt32(strUserID);
            string strKey = "XMLMenu_" + dropchuongtrinh.SelectedValue + "_" + UserID.ToString();
            Session[strKey] = null;
            dgList.DataSource = null;
            dgList.DataBind();
            lstSobanghiT.Text = lstSobanghiB.Text = "";
            pndata.Visible = false;
        }

        private void QT_Menu_UpdateArrThutu(QT_MENU oParent)
        {
            foreach(QT_MENU oT in dt.QT_MENU.Where(x=>x.CAPCHAID==oParent.ID).ToList())
            {
                string arrthutu = oParent.ARRTHUTU;
                if (oT.THUTU < 10)
                {
                    oT.ARRTHUTU = arrthutu + "/" + oT.THUTU.ToString() + "00";
                }
                else
                {
                    oT.ARRTHUTU = arrthutu + "/9" + oT.THUTU.ToString();
                }
                oT.ARRSAPXEP = oParent.ARRSAPXEP + "/" + oT.ID.ToString();
                dt.SaveChanges();
                QT_Menu_UpdateArrThutu(oT);
            }
            
        }
        public void SuaArraysapxep(int ID, string sapxep)
        {
            List<QT_MENU> dm__dvsudung = dt.QT_MENU.Where(x => x.ID == ID).OrderBy(y => y.THUTU).ToList();
            if (dm__dvsudung != null)
            {
                foreach (QT_MENU oT in dm__dvsudung)
                {
                    QT_MENU donvisd =new QT_MENU();
                    donvisd = dt.QT_MENU.Where(x => x.ID == oT.ID).FirstOrDefault();

                    if (Convert.ToInt32(oT.THUTU) < 10)
                    {
                        donvisd.ARRSAPXEP = sapxep + "/" + donvisd.ID;
                    }
                    else
                    {
                        donvisd.ARRSAPXEP = sapxep + "/" + donvisd.ID;
                    }
                    dt.SaveChanges();
                    Sauchildsapxep((int)donvisd.ID, donvisd.ARRSAPXEP);
                }
            }
        }

        public void Sauchildsapxep(int ID, string sapxep)
        {
            List<QT_MENU> dm__dvsudung = dt.QT_MENU.Where(x => x.ID == ID).OrderBy(y => y.THUTU).ToList();
            if (dm__dvsudung != null)
            {
                foreach (QT_MENU oT in dm__dvsudung)
                {
                    QT_MENU donvisudung = new QT_MENU();
                    donvisudung = dt.QT_MENU.Where(x => x.ID == oT.ID).FirstOrDefault();

                    if (Convert.ToInt32(oT.THUTU) < 10)
                    {
                        donvisudung.ARRSAPXEP = sapxep + "/" + donvisudung.ID;
                    }
                    else
                    {
                        donvisudung.ARRSAPXEP = sapxep + "/" + donvisudung.ID;
                    }
                    dt.SaveChanges();
                    Sauchildsapxep((int)donvisudung.ID, donvisudung.ARRSAPXEP);
                }
            }
        }

        public void SuaArraychuongtrinhID(int ID, int chuonngtrinhID)
        {
            List<QT_MENU> dm__dvsudung = dt.QT_MENU.Where(x => x.CAPCHAID == ID).OrderBy(y => y.THUTU).ToList();
            if (dm__dvsudung != null)
            {
                foreach (QT_MENU oT in dm__dvsudung)
                {
                    QT_MENU donvisd = new QT_MENU();
                    donvisd = dt.QT_MENU.Where(x => x.ID == oT.ID).FirstOrDefault();
                    donvisd.CHUONGTRINHID = chuonngtrinhID;
                    dt.SaveChanges();
                    SauchildchuongtrinhID((int)donvisd.ID, Convert.ToInt32(donvisd.CHUONGTRINHID));
                }
            }
        }

        public void SauchildchuongtrinhID(int ID, int chuonngtrinhID)
        {
            List<QT_MENU> dm__dvsudung = dt.QT_MENU.Where(x => x.CAPCHAID == ID).OrderBy(y => y.THUTU).ToList();
            if (dm__dvsudung != null)
            {
                foreach (QT_MENU oT in dm__dvsudung)
                {
                    QT_MENU donvisudung = new QT_MENU();
                    donvisudung = dt.QT_MENU.Where(x => x.ID == oT.ID).FirstOrDefault();

                    donvisudung.CHUONGTRINHID = chuonngtrinhID;
                    dt.SaveChanges();
                    SauchildchuongtrinhID((int)donvisudung.ID, Convert.ToInt32(donvisudung.CHUONGTRINHID));
                }
            }
        }
        
        public void SuaArraythutu(int ID, string arrthutu)
        {
            List<QT_MENU> dm__dvsudung = dt.QT_MENU.Where(x => x.CAPCHAID == ID).OrderBy(y => y.THUTU).ToList();
         
            if (dm__dvsudung != null)
            {
                foreach (QT_MENU oT in dm__dvsudung)
                {
                    QT_MENU duan = new QT_MENU();
                    duan = dt.QT_MENU.Where(x => x.ID == oT.ID).FirstOrDefault();

                    if (Convert.ToInt32(oT.THUTU) < 10)
                    {
                        duan.ARRTHUTU = arrthutu + "/" + duan.THUTU + "00";
                    }
                    else
                    {
                        duan.ARRTHUTU = arrthutu + "/9" + duan.THUTU;
                    }
                    dt.SaveChanges();
                    LoadTreeChild((int)duan.ID, duan.ARRTHUTU);
                }
            }
        }

        public void LoadTreeChild(int ID, string arrthutu)
        {
            List<QT_MENU> dm__dvsudung = dt.QT_MENU.Where(x => x.CAPCHAID == ID).OrderBy(y => y.THUTU).ToList();
          
            if (dm__dvsudung != null)
            {
                foreach (QT_MENU oT in dm__dvsudung)
                {
                    QT_MENU duanvongdoi = new QT_MENU();
                    duanvongdoi = dt.QT_MENU.Where(x => x.ID == oT.ID).FirstOrDefault();
                    if (Convert.ToInt32(oT.THUTU) < 10)
                    {
                        duanvongdoi.ARRTHUTU = arrthutu + "/" + duanvongdoi.THUTU + "00";
                    }
                    else
                    {
                        duanvongdoi.ARRTHUTU = arrthutu + "/9" + duanvongdoi.THUTU;
                    }
                    dt.SaveChanges();
                    LoadTreeChild((int)duanvongdoi.ID, duanvongdoi.ARRTHUTU);
                }
            }
        }
        protected void btnDel_Click(object sender, EventArgs e)
        {
            string s = hddid.Value;
            if (hddid.Value.Contains(Node_CT) == false)
            {
                if (hddid.Value != null || hddid.Value != "")
                {
                    decimal nID = Convert.ToDecimal(hddid.Value);
                 
                    List<QT_MENU> objhdid = dt.QT_MENU.Where(x => x.CAPCHAID == nID).ToList();
                   if (objhdid.Count > 0)
                    {
                        lbthongbao.Text = "Không xóa được vì có tin thông liên quan !";
                    }
                    else
                    {

                        QT_MENU laytt = dt.QT_MENU.Where(x => x.ID == nID).FirstOrDefault(); 
                        int capcha = Convert.ToInt32(laytt.CAPCHAID);
                        dt.QT_MENU.Remove(laytt);
                        dt.SaveChanges();
                        if (capcha != 0)
                        {
                            List<QT_MENU> dm_donvisudung = dt.QT_MENU.Where(x => x.CAPCHAID == capcha).ToList();
                            if (dm_donvisudung != null && dm_donvisudung.Count != 0)
                            {
                                objSubSite(Convert.ToString(capcha));
                                pndata.Visible = true;
                            }
                            else
                            {
                                pndata.Visible = false;
                            }
                        }
                        else
                        {
                            pndata.Visible = false;
                        }
                        btnLammoi_Click(sender, e);
                        lbthongbao.Text = "Xóa thành công!";
                        LoadTreeview("");
                    }
                }
                else
                {
                    lbthongbao.Text = "Bạn chưa chọn thông tin cần xóa !";
                }
                loadthutu();
            }
            else
            {
                lbthongbao.Text = "Đây là chương trình bạn không thể xóa được";
            }
        }
        protected void cmdThutu_Click(object sender, EventArgs e)
        {
            decimal capchaid = 0;
            decimal chuongtrinhid = 0;
            foreach (DataGridItem oItem in dgList.Items)
            {
                decimal nID = Convert.ToDecimal(oItem.Cells[0].Text);
                QT_MENU obj = dt.QT_MENU.Where(x => x.ID == nID).FirstOrDefault();

                DropDownList ddlTT = (DropDownList)oItem.FindControl("ddlThutu");
                string strID = oItem.Cells[0].Text;
                capchaid = Convert.ToDecimal(obj.CAPCHAID);
                chuongtrinhid = Convert.ToInt32(obj.CHUONGTRINHID);
                obj.THUTU = Convert.ToInt32(ddlTT.SelectedValue);
                if(capchaid==0)
                {
                    if (obj.THUTU < 10)
                    {
                        obj.ARRTHUTU = "0/" + obj.THUTU.ToString() + "00";
                    }
                    else
                    {
                        obj.ARRTHUTU =  "0/9" + obj.THUTU.ToString();
                    }
                    obj.ARRSAPXEP = "0/" + obj.ID.ToString();
                }
                else
                {
                    QT_MENU objPa = dt.QT_MENU.Where(x => x.ID == capchaid).FirstOrDefault();
                    string arrthutu = objPa.ARRTHUTU;
                    if (obj.THUTU < 10)
                    {
                        obj.ARRTHUTU = arrthutu + "/" + obj.THUTU.ToString() + "00";
                    }
                    else
                    {
                        obj.ARRTHUTU = arrthutu + "/9" + obj.THUTU.ToString();
                    }
                    obj.ARRSAPXEP = objPa.ARRSAPXEP + "/" + obj.ID.ToString();
                }
                dt.SaveChanges();
               QT_Menu_UpdateArrThutu(obj);
            }
            LoadTreeview("");
            lbthongbao.Text = "Lưu thứ tự thành công!";
        }
        public void loaddatasuathutu(int idcha, int chuongtrinhid)
        {
            if (idcha == 0)
            {
                int diemmenu = dt.QT_MENU.Where(x => x.CHUONGTRINHID== chuongtrinhid).ToList().Count;
                if (diemmenu > 0)
                {
                    objSubSite(Convert.ToString(chuongtrinhid));
                    pndata.Visible = true;
                }
                else
                {
                    pndata.Visible = false;
                }
            }
            else
            {
                int diemmenu = dt.QT_MENU.Where(x => x.CAPCHAID== idcha).ToList().Count;
                if (diemmenu > 0)
                {
                    objSubSite(Convert.ToString(idcha));
                    pndata.Visible = true;
                }
                else
                {
                    pndata.Visible = false;
                }
            }
        }
        protected void treemenu_SelectedNodeChanged(object sender, EventArgs e)
        {
            lbthongbao.Text = "";
            loadthutu();
            dgList.CurrentPageIndex = 0;
            string id_nodechange = treemenu.SelectedValue;
         
            hddid.Value = treemenu.SelectedValue;
            if (id_nodechange.Contains("ht_"))
            {

            }
             else   if (id_nodechange.Contains(Node_CT))
            {
                decimal nCTID = Convert.ToDecimal(treemenu.SelectedValue.Split('_')[1]);

                List<QT_MENU> lstMN = dt.QT_MENU.Where(x => x.CAPCHAID == 0 && x.CHUONGTRINHID == nCTID).OrderBy(y => y.THUTU).ToList();
                int demqtmenu =lstMN.Count;
                QT_CHUONGTRINH chuongtrinh = dt.QT_CHUONGTRINH.Where(x=>x.ID== nCTID).FirstOrDefault();
                //load thong tin theo th load CT
                dropchuongtrinh.SelectedValue = treemenu.SelectedValue.Split('_')[1];
                btnLammoi_Click(sender, e);
                dropParent.SelectedValue = "0";
                dropchuongtrinh.Enabled = true;
                if (treemenu.SelectedValue.Contains(Node_CT) == false)
                {
                    FillThutu(GetListMenuByID("0", dropParent.SelectedValue).Count + 1);
                }
                else
                {
                    FillThutu(GetListMenuByID(treemenu.SelectedValue, dropParent.SelectedValue).Count + 1);
                }
                if (chuongtrinh.THUTU < dropthutu.Items.Count)
                    dropthutu.SelectedValue = Convert.ToString(chuongtrinh.THUTU);
                else
                    dropthutu.SelectedIndex = dropthutu.Items.Count - 1;
                if (demqtmenu > 0)
                {
                    #region "Xác định số lượng trang"
                    int phan_du = demqtmenu % 20;
                    int phan_nguyen = demqtmenu / 20;
                    if (phan_du > 0)
                        hddTotalPage.Value = (phan_nguyen + 1).ToString();
                    else
                    {
                        if (phan_nguyen > 0)
                            hddTotalPage.Value = phan_nguyen.ToString();
                        else

                            hddTotalPage.Value = (phan_nguyen + 1).ToString();
                    }
                    lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + demqtmenu.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                    Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                                 lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                    #endregion

                    dgList.DataSource = lstMN;
                    dgList.DataBind();
                    pndata.Visible = true;
                }
                else
                {
                    pndata.Visible = false;
                }
            }
            else
            {
                dropParent.SelectedValue = "0";
                decimal nID = Convert.ToDecimal(treemenu.SelectedValue);
                QT_MENU qt_menu = dt.QT_MENU.Where(x => x.ID== nID).FirstOrDefault();



                dropParent.Items.Clear();
                LoadTreeviewselected("", qt_menu.ARRSAPXEP, (int)qt_menu.ID);

                txtDuongdan.Text = qt_menu.DUONGDAN;
                txtMaaction.Text = qt_menu.MAACTION;
             
                txtTen.Text = qt_menu.TENMENU;
                FillThutu(GetListMenuByID(dropchuongtrinh.SelectedValue, "0").Count + 1);
                if (qt_menu.THUTU < dropthutu.Items.Count)
                    dropthutu.SelectedValue = Convert.ToString(qt_menu.THUTU);
                else
                    dropthutu.SelectedIndex = dropthutu.Items.Count - 1;
                objSubSite(treemenu.SelectedValue);
                if (qt_menu.CAPCHAID == 0)
                {
                    dropParent.SelectedValue = "0";

                }
                else
                {
                    dropParent.SelectedValue = Convert.ToString(qt_menu.CAPCHAID);

                }
                hddid.Value = treemenu.SelectedValue;
                dropchuongtrinh.SelectedValue = Convert.ToString(qt_menu.CHUONGTRINHID);
               
                if (qt_menu.ISPHANNHOM == 1)
                    chkIsPhannhom.Checked = true;
                else
                    chkIsPhannhom.Checked = false;
                if (qt_menu.ISNOTMENU == 1)
                    chkIsNotMenu.Checked = true;
                else
                    chkIsNotMenu.Checked = false;
             

                if (qt_menu.HIEULUC == 1)
                    chkActive.Checked = true;
                else
                    chkActive.Checked = false;
                if (qt_menu.ACTION == 1)
                    chkAction.Checked = true;
                else
                    chkAction.Checked = false;
           
                if (qt_menu.CAPNHAT == 1)
                    chkCapnhat.Checked = true;
                else
                    chkCapnhat.Checked = false;
                if (qt_menu.XOA == 1)
                    chkxoa.Checked = true;
                else
                    chkxoa.Checked = false;

                if (qt_menu.TAOMOI == 1)
                    chkthemmoi.Checked = true;
                else
                    chkthemmoi.Checked = false;

                if (qt_menu.QUYENSOTHAM == 1)
                    chkSotham.Checked = true;
                else
                    chkSotham.Checked = false;
                if (qt_menu.QUYENPHUCTHAM == 1)
                    chkPhuctham.Checked = true;
                else
                    chkPhuctham.Checked = false;
                if (qt_menu.QUYENTOICAO == 1)
                    chkToicao.Checked = true;
                else
                    chkToicao.Checked = false;
                if (qt_menu.QUYENQUANTRI == 1)
                    chkQuantri.Checked = true;
                else
                    chkQuantri.Checked = false;
                if (qt_menu.ISSOTHAM == 1)
                    chkViewSotham.Checked = true;
                else
                    chkViewSotham.Checked = false;

                if (qt_menu.ISPHUCTHAM == 1)
                    chkViewPhuctham.Checked = true;
                else
                    chkViewPhuctham.Checked = false;

                if (qt_menu.ISPHUCTHAM_KCKNQDK == 1)
                    chkViewPhucthamQDK.Checked = true;
                else
                    chkViewPhucthamQDK.Checked = false;
            }
        }
        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            txtDuongdan.Text = "";
            txtMaaction.Text = "";
            txtMota.Text = "";
            txtTen.Text = "";
            //chkIsPhannhom.Checked = false;
            //chkAction.Checked = false;
            //chkActive.Checked = false;
            //chkCapnhat.Checked = false;
            //chkthemmoi.Checked = false;
            //chkxoa.Checked = false;
            //chkSotham.Checked = chkPhuctham.Checked = chkToicao.Checked = chkQuantri.Checked = true;
            //dropParent.SelectedValue = "0";
            chkViewSotham.Checked = chkViewPhuctham.Checked = chkViewPhucthamQDK.Checked = false;
            hddid.Value = "";
            dropchuongtrinh.Enabled = true;
            txtTen.Focus();
        }
        protected void dropParent_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (dropParent.SelectedValue != "0")
            {
                decimal nID = Convert.ToDecimal(dropParent.SelectedValue);
                QT_MENU oT = dt.QT_MENU.Where(x => x.ID == nID).FirstOrDefault();
                dropchuongtrinh.SelectedValue = oT.CHUONGTRINHID.ToString();
                dropchuongtrinh.Enabled = false;
            }
            else
            {
                dropchuongtrinh.Enabled = true;
            }

        }
        private void FillThutu(int iCount)
        {
            dropthutu.Items.Clear();
            for (int i = 1; i <= iCount; i++)
            {
                dropthutu.Items.Add(new ListItem(i.ToString(), i.ToString()));
            }
            dropthutu.SelectedIndex = dropthutu.Items.Count - 1;
        }
        public void loadthutu()
        {
            List<QT_MENU> list =dt.QT_MENU.ToList();
            if (list.Count > 0)
            {
                FillThutu(list.Count);

            }
        }

        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
            {
                QT_MENU item = (QT_MENU)e.Item.DataItem;
                //QT_MENU qt_menu = qt_menu_bl.GetById("ID", Convert.ToInt32(item.ID));
                DropDownList ddlThutu = (DropDownList)e.Item.FindControl("ddlThutu");
                if (treemenu.SelectedValue.Contains(Node_CT) == true)
                {
                    decimal nID = Convert.ToDecimal(treemenu.SelectedValue.Split('_')[1]);
                    List<QT_MENU> list = dt.QT_MENU.Where(x => x.CAPCHAID == 0 && x.CHUONGTRINHID == nID).ToList(); ;
                    for (int i = 1; i <= list.Count; i++)
                    {
                        ddlThutu.Items.Add(new ListItem(i.ToString(), i.ToString()));
                    }
                }
                else
                {
                    decimal nID = Convert.ToDecimal(treemenu.SelectedValue);
                    List<QT_MENU> list = dt.QT_MENU.Where(x => x.CAPCHAID == nID).ToList();
                    if (list.Count > 0)
                    {
                        for (int i = 1; i <= list.Count; i++)
                        {
                            ddlThutu.Items.Add(new ListItem(i.ToString(), i.ToString()));
                        }
                    }
                }
                if (ddlThutu.Items.Count < item.THUTU)
                {
                    ddlThutu.SelectedValue = Convert.ToString(ddlThutu.Items.Count);
                }
                else
                {
                    ddlThutu.SelectedValue = Convert.ToString(item.THUTU);
                }
            }


        }
        public void xoa(int id)
        {
            List<QT_MENU> obj = dt.QT_MENU.Where(x => x.CAPCHAID == id).ToList();
            if (obj.Count > 0)
            {
                lbthongbao.Text = "Không xóa được vì có tin thông liên quan !";
            }
            else
            {
                QT_MENU dmloaicongtrinh = dt.QT_MENU.Where(x => x.ID==id).FirstOrDefault();
                dt.QT_MENU.Remove(dmloaicongtrinh);
                dt.SaveChanges();

                List<QT_MENU> dem = dt.QT_MENU.Where(x => x.CAPCHAID == dmloaicongtrinh.CAPCHAID).OrderBy(y => y.THUTU).ToList();
                if (dem.Count != 0 && dem != null && dmloaicongtrinh.CAPCHAID != 0)
                {
                    dgList.CurrentPageIndex = 0;
                    objSubSite(Convert.ToString(dmloaicongtrinh.CAPCHAID));
                    pndata.Visible = true;
                }

                else
                {
                    pndata.Visible = false;
                }
                LoadTreeview("");
                // loaddropcapcha();
                loadthutu();
            }
        }
        public void loadedit(int ID)
        {
           QT_MENU qt_menu = dt.QT_MENU.Where(x => x.ID== ID).FirstOrDefault();
            txtDuongdan.Text = qt_menu.DUONGDAN;
            txtMaaction.Text = qt_menu.MAACTION;
     
            txtTen.Text = qt_menu.TENMENU;

            if (qt_menu.CAPCHAID == 0)
            {
                dropParent.SelectedValue = "0";
                dropchuongtrinh.Enabled = true;
            }
            else
            {
                dropParent.SelectedValue = Convert.ToString(qt_menu.CAPCHAID);
                dropchuongtrinh.Enabled = false;
            }
            if (qt_menu.THUTU <= dropthutu.Items.Count)
                dropthutu.SelectedValue = Convert.ToString(qt_menu.THUTU);
            else
                dropthutu.SelectedIndex = dropthutu.Items.Count - 1;
            if (qt_menu.ISPHANNHOM == 1)
                chkIsPhannhom.Checked = true;
            else
                chkIsPhannhom.Checked = false;
            if (qt_menu.ISNOTMENU == 1)
                chkIsNotMenu.Checked = true;
            else
                chkIsNotMenu.Checked = false;

            if (qt_menu.HIEULUC == 1)
                chkActive.Checked = true;
            else
                chkActive.Checked = false;

            if (qt_menu.ACTION == 1)
                chkAction.Checked = true;
            else
                chkAction.Checked = false;

            if (qt_menu.CAPNHAT == 1)
                chkCapnhat.Checked = true;
            else
                chkCapnhat.Checked = false;
            if (qt_menu.XOA == 1)
                chkxoa.Checked = true;
            else
                chkxoa.Checked = false;

            if (qt_menu.TAOMOI == 1)
                chkthemmoi.Checked = true;
            else
                chkthemmoi.Checked = false;

            if (qt_menu.QUYENSOTHAM == 1)
                chkSotham.Checked = true;
            else
                chkSotham.Checked = false;
            if (qt_menu.QUYENPHUCTHAM == 1)
                chkPhuctham.Checked = true;
            else
                chkPhuctham.Checked = false;
            if (qt_menu.QUYENTOICAO == 1)
                chkToicao.Checked = true;
            else
                chkToicao.Checked = false;
            if (qt_menu.QUYENQUANTRI == 1)
                chkQuantri.Checked = true;
            else
                chkQuantri.Checked = false;

            cmdDel.Enabled = true;


            if (qt_menu.ISSOTHAM == 1)
                chkViewSotham.Checked = true;
            else
                chkViewSotham.Checked = false;

            if (qt_menu.ISPHUCTHAM == 1)
                chkViewPhuctham.Checked = true;
            else
                chkViewPhuctham.Checked = false;
            if (qt_menu.ISPHUCTHAM_KCKNQDK == 1)
                chkViewPhucthamQDK.Checked = true;
            else
                chkViewPhucthamQDK.Checked = false;

        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            int chuyenmucID = Convert.ToInt32(e.CommandArgument.ToString());
            lbthongbao.Text = "";

            switch (e.CommandName)
            {

                case "Sua":
                    QT_MENU qt_menu = dt.QT_MENU.Where(x => x.ID == chuyenmucID).FirstOrDefault();
                   
                    dropParent.Items.Clear();
                    LoadTreeviewselected("", qt_menu.ARRSAPXEP, (int)qt_menu.ID);
                    loadedit(Convert.ToInt32(e.CommandArgument.ToString()));
                    hddid.Value = e.CommandArgument.ToString();
                    break;

                case "Xoa":                  
                            xoa(Convert.ToInt32(e.CommandArgument.ToString()));
                            //loaddropcapcha();
                            hddid.Value = "";                  
                    break;
            }


            //--------

        }
        public void loaddatasua()
        {
            decimal nID = Convert.ToDecimal(dropParent.SelectedValue);
            int demqtmenu = dt.QT_MENU.Where(x => x.CAPCHAID== nID).ToList().Count;
            if (demqtmenu > 0)
            {

                objSubSite(dropchuongtrinh.SelectedValue);
                pndata.Visible = true;
            }
            else
            {
                pndata.Visible = false;
            }
        }
        public void objSubSite(string capchaid)
        {
            //dgList.CurrentPageIndex = 0;
            List<QT_MENU> qtmenu = dt.QT_MENU.Where(x => x.CAPCHAID ==0).ToList();
            if (capchaid.Contains(Node_CT))
            {
                decimal nID = Convert.ToDecimal(treemenu.SelectedValue.Split('_')[1]);
                qtmenu = dt.QT_MENU.Where(x => x.CAPCHAID == 0 &&x.CHUONGTRINHID== nID).OrderBy(y=>y.THUTU).ToList();
            }
            else
            {
                decimal nID = Convert.ToDecimal(capchaid);
                qtmenu = dt.QT_MENU.Where(x => x.CAPCHAID == nID).OrderBy(y => y.THUTU).ToList(); 
            }
            if (qtmenu.Count > 0)
            {
                #region "Xác định số lượng trang"
                int phan_du = qtmenu.Count % 20;
                int phan_nguyen = qtmenu.Count / 20;
                if (phan_du > 0)
                    hddTotalPage.Value = (phan_nguyen + 1).ToString();
                else
                {
                    if (phan_nguyen > 0)
                        hddTotalPage.Value = phan_nguyen.ToString();
                    else

                        hddTotalPage.Value = (phan_nguyen + 1).ToString();
                }
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + qtmenu.Count.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion


                dgList.DataSource = qtmenu;
                dgList.DataBind();
                pndata.Visible = true;
            }
            else
            {
                pndata.Visible = false;
            }


        }
        #region "Phân trang"

        protected void lbTBack_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            objSubSite(hddid.Value);
        }

        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            objSubSite(hddid.Value);
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            objSubSite(hddid.Value);
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            objSubSite(hddid.Value);
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex.Value = lbCurrent.Text;
            objSubSite(hddid.Value);
        }

        #endregion



    }
}
