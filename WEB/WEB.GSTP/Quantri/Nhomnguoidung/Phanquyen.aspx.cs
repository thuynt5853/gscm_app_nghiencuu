using DAL.GSTP;
using BL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using BL.GSTP.BANGSETGET;

namespace WEB.GSTP.Quantri.Nhomnguoidung
{
    public partial class Phanquyen : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        public  bool GetNumber(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return false;
                else
                    return Convert.ToBoolean(obj);
            }
            catch (Exception ex)
            { return false; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string strID = Request["CID"] + "";
                LoadChuongtrinh();
                if (strID != "")
                {
                    decimal IDNhom = Convert.ToDecimal(strID);
                    QT_NHOMNGUOIDUNG oT = dt.QT_NHOMNGUOIDUNG.Where(x => x.ID == IDNhom).FirstOrDefault();
                    if (oT == null) return;
                    lstName.Text = oT.TEN;
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                    chkHethong.DataSource = dt.QT_HETHONG.ToList();
                    chkHethong.DataTextField = "TEN";
                    chkHethong.DataValueField = "ID";
                    chkHethong.DataBind();
                    foreach(ListItem i in chkHethong.Items)
                    {
                        decimal HTID = Convert.ToDecimal(i.Value);
                        if (dt.QT_NHOMNGUOIDUNG_HETHONG.Where(x => x.NHOMID == IDNhom && x.HETHONGID == HTID).ToList().Count > 0)
                            i.Selected = true;
                        }
                    get_value_ishome();
                }
            }
        }

        public void Check_dgMenu_column()
        {
            if(treemenu.SelectedValue== "101")
            {
                dgMenu.Columns[9].Visible = true;
                dgMenu.Columns[10].Visible = true;
                tk_login.Style.Remove("Display");
                tk_thanhnien.Style.Add("Display", "none");
                tk_chuathanhnien.Style.Add("Display", "none");
            }
            else if(treemenu.SelectedValue == "44")
            {
                dgMenu.Columns[9].Visible = false;
                dgMenu.Columns[10].Visible = false;
                tk_login.Style.Remove("Display");
                tk_thanhnien.Style.Add("Display", "none");
                tk_chuathanhnien.Style.Add("Display", "none");
            }
            else if (treemenu.SelectedValue == "23")
            {
                tk_login.Style.Add("Display", "none");
                tk_thanhnien.Style.Remove("Display");
                tk_chuathanhnien.Style.Remove("Display");
                dgMenu.Columns[9].Visible = false;
                dgMenu.Columns[10].Visible = false;
            }
            else
            {
                tk_login.Style.Add("Display", "none");
                tk_thanhnien.Style.Add("Display", "none");
                tk_chuathanhnien.Style.Add("Display", "none");
                dgMenu.Columns[9].Visible = false;
                dgMenu.Columns[10].Visible = false;
            }
        }
        private void LoadChuongtrinh()
        {
            decimal IDNhom = Convert.ToDecimal(Request["CID"]);
            treemenu.Nodes.Clear();
            List<QT_HETHONG> lstHT = dt.QT_HETHONG.OrderBy(x => x.THUTU).ToList();
            foreach (QT_HETHONG ht in lstHT)
            {
                if (dt.QT_NHOMNGUOIDUNG_HETHONG.Where(x => x.NHOMID == IDNhom && x.HETHONGID == ht.ID).ToList().Count > 0)
                {
                    TreeNode oRoot = CreateNode(ht.ID.ToString(), ht.TEN.ToString());
                    oRoot.NavigateUrl = "javascript:;";
                    List<QT_CHUONGTRINH> qtchuongtrinh = dt.QT_CHUONGTRINH.Where(x => x.HIEULUC == 1 && x.HETHONGID == ht.ID).OrderBy(y => y.THUTU).ToList();
                    if (qtchuongtrinh != null)
                    {
                        foreach (QT_CHUONGTRINH oT in qtchuongtrinh)
                        {
                            TreeNode oNode;
                            oNode = CreateNode(oT.ID.ToString(), oT.TEN.ToString());
                            oRoot.ChildNodes.Add(oNode);
                        }
                        //treemenu.Nodes[0].ChildNodes[0].Selected = true;
                        //LoadMenuByChuongtrinh(Convert.ToDecimal(treemenu.SelectedValue), Convert.ToDecimal(Request["CID"]));
                    }
                    treemenu.Nodes.Add(oRoot);
                }
            }
            foreach (TreeNode o in treemenu.Nodes) o.Expand();
        }

        private void LoadMenuByChuongtrinh(decimal ChuongtrinhID, decimal NhomID)
        {
            lstMess.Text=lstMsgB.Text = "";
            QT_MENU_BL qtBL = new QT_MENU_BL();
            DataTable tbl = qtBL.QT_NHOMNGUOIDUNG_MENU_GETBY_NOCACHE(ChuongtrinhID, NhomID);
            if (ChuongtrinhID == 23 && tbl.Rows.Count > 0)
            {
                int isThanhNien = Convert.ToInt32(tbl.Rows[0]["ISTHANHNIEN"].ToString() == "" ? "0" : tbl.Rows[0]["ISTHANHNIEN"].ToString());
                switch (isThanhNien)
                {
                    case 0: chkThanhNien.Checked = false; chkChuaThanhNien.Checked = false; break;
                    case 1: chkThanhNien.Checked = false; chkChuaThanhNien.Checked = true; break;
                    case 2: chkThanhNien.Checked = true; chkChuaThanhNien.Checked = false; break;
                    case 3: chkThanhNien.Checked = true; chkChuaThanhNien.Checked = true; break;                    
                }
            }
            else
            {
                chkThanhNien.Checked = false; chkChuaThanhNien.Checked = false;
            }
            dgMenu.DataSource = tbl;
            dgMenu.DataBind();
        }

        private TreeNode CreateNode(string sNodeId, string sNodeText)
        {
            TreeNode objTreeNode = new TreeNode();
            objTreeNode.Value = sNodeId;
            objTreeNode.Text = sNodeText;
            if (sNodeId == Guid.Empty.ToString())
            {
                objTreeNode.ImageUrl = "../../UI/img/root.gif";
            }
            return objTreeNode;
        }

        protected void treemenu_SelectedNodeChanged(object sender, EventArgs e)
        {
            cmdUpdate.Visible = Button1.Visible = dgMenu.Visible = true;
            Check_dgMenu_column();
            LoadMenuByChuongtrinh(Convert.ToDecimal(treemenu.SelectedValue), Convert.ToDecimal(Request["CID"]));
            //--Phân quyền màn hình thống ke sau login --anhvh 03/02/2020
            decimal IDNhom = Convert.ToDecimal(Request["CID"] + "");
            decimal ID_treemenu = Convert.ToDecimal(treemenu.SelectedValue);
            QT_MENU_BL qtBL = new QT_MENU_BL();
            DataTable lst_home = qtBL.Qt_Nhom_Home_Get_List(ID_treemenu, IDNhom);
            if (lst_home != null && lst_home.Rows.Count > 0)
            {
                chk_XEM.Checked = Convert.ToBoolean(Convert.ToInt32(lst_home.Rows[0]["XEM"]));
                chk_XEM_ALL.Checked = Convert.ToBoolean(Convert.ToInt32(lst_home.Rows[0]["XEM_ALL"]));
            }
            else
            {
                chk_XEM.Checked = false;
                chk_XEM_ALL.Checked = false;
            }
            //------------------------
        }
        protected void get_value_ishome()
        {
            QT_MENU_BL qtBL = new QT_MENU_BL();
            //--Phân quyền màn hình thống ke sau login --anhvh 25/01/2020
            decimal IDNhom = Convert.ToDecimal(Request["CID"] + "");
            DataTable lst_home = qtBL.Qt_Nhom_ISHome_Get_List(IDNhom);
            if (lst_home != null && lst_home.Rows.Count > 0)
            {
                chk_VIEW_TK.Checked = Convert.ToBoolean(Convert.ToInt32(lst_home.Rows[0]["VIEW_TK"]));
            }
            else
            {
                chk_VIEW_TK.Checked = false;
            }
        }
        protected void btnUpdate_IsHome_Click(object sender, EventArgs e)
        {
            lstMess_isHome.Text = "";
            string strNhomID = Request["CID"] + "";
            decimal IDNhom = Convert.ToDecimal(strNhomID);
            //------
            QT_MENU_BL qtBL = new QT_MENU_BL();
            QT_NHOMNGUOIDUNG_ISHOME oT_IShome = new QT_NHOMNGUOIDUNG_ISHOME();
            oT_IShome.NHOMID = Convert.ToDecimal(strNhomID);
            oT_IShome.VIEW_TK = chk_VIEW_TK.Checked ? 1 : 0;
            if(qtBL.QT_NHOMNGUOIDUNG_ISHOME_IN_UPDATE(oT_IShome)==true)
            {
                lstMess_isHome.Text = "Bạn đã cập nhật thành công.";
            }
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            lstMess.Text = lstMsgB.Text = "";
            string strNhomID = Request["CID"] + "";
            decimal IDNhom = Convert.ToDecimal(strNhomID);
            //--Phân quyền màn hình thống ke sau login --anhvh 03/02/2020
            decimal ID_treemenu = Convert.ToDecimal(treemenu.SelectedValue);
            QT_MENU_BL qtBL = new QT_MENU_BL();
            QT_NHOMNGUOIDUNG_HOME oT_home = new QT_NHOMNGUOIDUNG_HOME();
            oT_home.CHUONGTRINHID = Convert.ToDecimal(treemenu.SelectedValue);
            oT_home.NHOMID = Convert.ToDecimal(strNhomID);
            oT_home.XEM = chk_XEM.Checked ? 1 : 0;
            oT_home.XEM_ALL = chk_XEM_ALL.Checked ? 1 : 0;
            qtBL.QT_NHOMNGUOIDUNG_HOME_IN_UPDATE(oT_home);
            //----------------------------
            foreach (DataGridItem Item in dgMenu.Items)
            {
                string strID = Item.Cells[0].Text;
                decimal IDMenu = Convert.ToDecimal(strID);
                CheckBox chkDulieu = (CheckBox)Item.FindControl("chkDulieu");
                CheckBox chkXem = (CheckBox)Item.FindControl("chkXem");
                CheckBox chkCapnhat = (CheckBox)Item.FindControl("chkCapnhat");
                CheckBox chkTaomoi = (CheckBox)Item.FindControl("chkTaomoi");
                CheckBox chkXoa = (CheckBox)Item.FindControl("chkXoa");
                CheckBox chkISXINANGIAM = (CheckBox)Item.FindControl("chkISXINANGIAM");
                CheckBox chkGDT_ISXINANGIAM = (CheckBox)Item.FindControl("chkGDT_ISXINANGIAM");
                List<QT_NHOMNGUOIDUNG_MENU> lst = dt.QT_NHOMNGUOIDUNG_MENU.Where(x => x.MENUID == IDMenu && x.NHOMID == IDNhom).ToList();
                if (lst.Count == 0)
                {
                    if (chkXem.Checked || chkCapnhat.Checked || chkTaomoi.Checked || chkXoa.Checked 
                        || chkISXINANGIAM.Checked || chkGDT_ISXINANGIAM.Checked || chkChuaThanhNien.Checked  || chkThanhNien.Checked
                        || chkDulieu.Checked)
                    {
                        QT_NHOMNGUOIDUNG_MENU oT = new QT_NHOMNGUOIDUNG_MENU();
                        oT.NHOMID = IDNhom;
                        oT.MENUID = IDMenu;
                        oT.XEM = 1;                        
                        oT.TAOMOI = chkTaomoi.Checked ? 1 : 0;
                        oT.CAPNHAT = chkCapnhat.Checked ? 1 : 0;
                        oT.XOA = chkXoa.Checked ? 1 : 0;
                        oT.DULIEU = chkDulieu.Checked ? 1 : 0;
                        oT.ISXINANGIAM = chkISXINANGIAM.Checked ? 1 : 0;
                        oT.GDT_ISXINANGIAM = chkGDT_ISXINANGIAM.Checked ? 1 : 0;
                        oT.NGAYTAO = DateTime.Now;
                        oT.NGUOITAO = Session["UserName"] + "";
                        oT.ISTHANHNIEN = GetThanhNien();
                        dt.QT_NHOMNGUOIDUNG_MENU.Add(oT);
                        dt.SaveChanges();
                    }
                }
                else
                {
                    QT_NHOMNGUOIDUNG_MENU oT = lst[0];
                    oT.TAOMOI = chkTaomoi.Checked ? 1 : 0;
                    oT.CAPNHAT = chkCapnhat.Checked ? 1 : 0;
                    oT.XOA = chkXoa.Checked ? 1 : 0;
                    oT.XEM = chkXem.Checked ? 1 : 0;
                    oT.DULIEU = chkDulieu.Checked ? 1 : 0;
                    oT.ISXINANGIAM = chkISXINANGIAM.Checked ? 1 : 0;
                    oT.GDT_ISXINANGIAM = chkGDT_ISXINANGIAM.Checked ? 1 : 0;
                    oT.NGAYSUA = DateTime.Now;
                    oT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    oT.ISTHANHNIEN = GetThanhNien();
                    dt.SaveChanges();
                }
            }
            lstMess.Text = lstMsgB.Text = "Lưu thành công !";
        }
        public int GetThanhNien()
        {
            if (chkChuaThanhNien.Checked && chkThanhNien.Checked == false)
            {
                return 1; // chưa thanh niên = 1
            }
            if (chkChuaThanhNien.Checked == false && chkThanhNien.Checked)
            {
                return 2; // thanh niên = 2
            }
            if (chkChuaThanhNien.Checked && chkThanhNien.Checked)
            {
                return 3; // cả thanh niên và chưa thanh niên = 3
            }
            return 0;// không chọn = 0
        }
        protected void lblquaylai_Click(object sender, EventArgs e)
        {
            Response.Redirect("Danhsach.aspx");
        }

        //---------------CHỨC NĂNG-------------------
        protected void chkFullAll_CheckChange(object sender, EventArgs e)
        {
            CheckBox chkAll = (CheckBox)sender;         

            foreach (DataGridItem Item in dgMenu.Items)
            {
                CheckBox chk = (CheckBox)Item.FindControl("chkFull");
                chk.Checked = chkAll.Checked;
                CheckBox chkXem = (CheckBox)Item.FindControl("chkXem");

                CheckBox chkTaomoi = (CheckBox)Item.FindControl("chkTaomoi");

                CheckBox chkCapnhat = (CheckBox)Item.FindControl("chkCapnhat");
                CheckBox chkXoa = (CheckBox)Item.FindControl("chkXoa");
                CheckBox chkDulieu = (CheckBox)Item.FindControl("chkDulieu");
                CheckBox chkISXINANGIAM = (CheckBox)Item.FindControl("chkISXINANGIAM");
                CheckBox chkGDT_ISXINANGIAM = (CheckBox)Item.FindControl("chkGDT_ISXINANGIAM");
                if (chkXem.Enabled)
                    chkXem.Checked = chk.Checked;
                if (chkCapnhat.Enabled)
                    chkCapnhat.Checked = chk.Checked;
                if (chkTaomoi.Enabled)
                    chkTaomoi.Checked = chk.Checked;
                if (chkXoa.Enabled)
                    chkXoa.Checked = chk.Checked;
                if (chkDulieu.Enabled)
                    chkDulieu.Checked = chk.Checked;
                if (chkISXINANGIAM.Enabled)
                    chkISXINANGIAM.Checked = chk.Checked;
                if (chkGDT_ISXINANGIAM.Enabled)
                    chkGDT_ISXINANGIAM.Checked = chk.Checked;
            }
        }

        protected void chkFull_CheckedChanged(object sender, EventArgs e)
        {

            CheckBox chkFull = (CheckBox)sender;
          
            decimal ID = Convert.ToDecimal(chkFull.ToolTip);
            QT_MENU oT = dt.QT_MENU.Where(x => x.ID == ID).FirstOrDefault();
            foreach (DataGridItem Item in dgMenu.Items)
            {
                CheckBox chkXem = (CheckBox)Item.FindControl("chkXem");
                CheckBox chkCapnhat = (CheckBox)Item.FindControl("chkCapnhat");
                CheckBox chkTaomoi = (CheckBox)Item.FindControl("chkTaomoi");
                CheckBox chkXoa = (CheckBox)Item.FindControl("chkXoa");
                CheckBox chkFullChild = (CheckBox)Item.FindControl("chkFull");
                CheckBox chkDulieu = (CheckBox)Item.FindControl("chkDulieu");
                CheckBox chkISXINANGIAM = (CheckBox)Item.FindControl("chkISXINANGIAM");
                CheckBox chkGDT_ISXINANGIAM = (CheckBox)Item.FindControl("chkGDT_ISXINANGIAM");
                if (Item.Cells[0].Text.Equals(chkFull.ToolTip))
                {
                    if (chkXem.Enabled)
                        chkXem.Checked = chkFull.Checked;
                    if (chkCapnhat.Enabled)
                        chkCapnhat.Checked = chkFull.Checked;
                    if (chkTaomoi.Enabled)
                        chkTaomoi.Checked = chkFull.Checked;
                    if (chkXoa.Enabled)
                        chkXoa.Checked = chkFull.Checked;
                    if (chkDulieu.Enabled)
                        chkDulieu.Checked = chkFull.Checked;
                    if (chkISXINANGIAM.Enabled)
                        chkISXINANGIAM.Checked = chkFull.Checked;
                    if (chkGDT_ISXINANGIAM.Enabled)
                        chkGDT_ISXINANGIAM.Checked = chkFull.Checked;
                }
                if (chkFull.Checked)
                {
                    //Phân quyền lại cấp cha của node đang chọn                   
                    string strSapxep = "/" + Item.Cells[1].Text + "/";
                    if (("/" + oT.ARRSAPXEP + "/").Contains(strSapxep))
                        chkXem.Checked = true;
                    if (strSapxep.Contains("/" + oT.ARRSAPXEP + "/") && chkAuto.Checked)
                    {
                        chkXem.Checked = true;
                        chkCapnhat.Checked = true;
                        chkTaomoi.Checked = true;
                        chkXoa.Checked = true;
                        chkDulieu.Checked = true;
                        chkISXINANGIAM.Checked = true;
                        chkGDT_ISXINANGIAM.Checked = true;
                        chkFullChild.Checked = true;
                    }
                }
                else
                {
                    //Phân quyền lại cấp con của node đang chọn                   
                    string strSapxep = "/" + Item.Cells[1].Text + "/";
                    if (strSapxep.Contains("/" + oT.ARRSAPXEP + "/"))
                    {
                        chkXem.Checked = false;
                        chkCapnhat.Checked = false;
                        chkTaomoi.Checked = false;
                        chkXoa.Checked = false;
                        chkDulieu.Checked = false;
                        chkISXINANGIAM.Checked = false;
                        chkGDT_ISXINANGIAM.Checked = false;
                        chkFullChild.Checked = false;
                    }
                }
            }
        }

        public void chkXem_CheckedChanged(object sender, EventArgs e)
        {

            CheckBox chkXem = (CheckBox)sender;
            decimal ID = Convert.ToDecimal(chkXem.ToolTip);
            QT_MENU oT = dt.QT_MENU.Where(x => x.ID == ID).FirstOrDefault();
            foreach (DataGridItem Item in dgMenu.Items)
            {
                CheckBox chkXemChild = (CheckBox)Item.FindControl("chkXem");
                CheckBox chkCapnhat = (CheckBox)Item.FindControl("chkCapnhat");
                CheckBox chkTaomoi = (CheckBox)Item.FindControl("chkTaomoi");
                CheckBox chkXoa = (CheckBox)Item.FindControl("chkXoa");
                CheckBox chkDulieu = (CheckBox)Item.FindControl("chkDulieu");
                CheckBox chkISXINANGIAM = (CheckBox)Item.FindControl("chkISXINANGIAM");
                CheckBox chkGDT_ISXINANGIAM = (CheckBox)Item.FindControl("chkGDT_ISXINANGIAM");
                CheckBox chkFull = (CheckBox)Item.FindControl("chkFull");
                if (chkXem.Checked)
                {
                    //Phân quyền lại cấp cha của node đang chọn                   
                    string strSapxep = "/" + Item.Cells[1].Text + "/";
                    if (("/" + oT.ARRSAPXEP + "/").Contains(strSapxep))
                        chkXemChild.Checked = true;
                    if (strSapxep.Contains("/" + oT.ARRSAPXEP + "/") && chkAuto.Checked)
                    {
                        chkXemChild.Checked = true;
                    }
                }
                else
                {
                    //Phân quyền lại cấp con của node đang chọn                   
                    string strSapxep = "/" + Item.Cells[1].Text + "/";
                    if (strSapxep.Contains("/" + oT.ARRSAPXEP + "/"))
                    {
                        chkFull.Checked = false;
                        chkXemChild.Checked = false;
                        chkCapnhat.Checked = false;
                        chkTaomoi.Checked = false;
                        chkXoa.Checked = false;
                        chkDulieu.Checked = false;
                        chkISXINANGIAM.Checked = false;
                        chkGDT_ISXINANGIAM.Checked = false;
                    }
                }
            }
        }

        protected void chkCapnhat_CheckedChanged(object sender, EventArgs e)
        {

            CheckBox chkCapnhat = (CheckBox)sender;
            decimal ID = Convert.ToDecimal(chkCapnhat.ToolTip);
            QT_MENU oT = dt.QT_MENU.Where(x => x.ID == ID).FirstOrDefault();
            foreach (DataGridItem Item in dgMenu.Items)
            {
                CheckBox chkXem = (CheckBox)Item.FindControl("chkXem");
                CheckBox chkCapnhatChild = (CheckBox)Item.FindControl("chkCapnhat");
                if (chkCapnhat.Checked)
                {
                    //Phân quyền lại cấp cha của node đang chọn                   
                    string strSapxep = "/" + Item.Cells[1].Text + "/";
                    //if (("/" + oT.Sapxep + "/").Contains(strSapxep))
                    //    chkCapnhatChild.Checked = true;
                    if (strSapxep.Contains("/" + oT.ARRSAPXEP + "/") && chkAuto.Checked)
                    {
                        chkXem.Checked = true;
                        chkCapnhatChild.Checked = true;
                    }
                }
                else
                {
                    //Phân quyền lại cấp con của node đang chọn                   
                    string strSapxep = "/" + Item.Cells[1].Text + "/";
                    if (strSapxep.Contains("/" + oT.ARRSAPXEP + "/"))
                    {
                        chkCapnhatChild.Checked = false;
                    }
                }
            }
        }


        protected void chkXoa_CheckedChanged(object sender, EventArgs e)
        {

            CheckBox chkXoa = (CheckBox)sender;
            decimal ID = Convert.ToDecimal(chkXoa.ToolTip);
            QT_MENU oT = dt.QT_MENU.Where(x => x.ID == ID).FirstOrDefault();
            foreach (DataGridItem Item in dgMenu.Items)
            {
                CheckBox chkXem = (CheckBox)Item.FindControl("chkXem");
                CheckBox chkXoaChild = (CheckBox)Item.FindControl("chkXoa");
               
                if (chkXoa.Checked)
                {
                    //Phân quyền lại cấp cha của node đang chọn                   
                    string strSapxep = "/" + Item.Cells[1].Text + "/";
                    //if (("/" + oT.Sapxep + "/").Contains(strSapxep))
                    //    chkPheduyetChild.Checked = true;
                    if (strSapxep.Contains("/" + oT.ARRSAPXEP + "/") && chkAuto.Checked)
                    {
                        chkXem.Checked = true;
                        chkXoaChild.Checked = true;
                    }
                }
                else
                {
                    //Phân quyền lại cấp con của node đang chọn                   
                    string strSapxep = "/" + Item.Cells[1].Text + "/";
                    if (strSapxep.Contains("/" + oT.ARRSAPXEP + "/"))
                    {
                        chkXoaChild.Checked = false;
                    }
                }
            }
        }

        protected void chkDulieu_CheckedChanged(object sender, EventArgs e)
        {

            CheckBox chkXoa = (CheckBox)sender;
            decimal ID = Convert.ToDecimal(chkXoa.ToolTip);
            QT_MENU oT = dt.QT_MENU.Where(x => x.ID == ID).FirstOrDefault();
            foreach (DataGridItem Item in dgMenu.Items)
            {
                CheckBox chkXem = (CheckBox)Item.FindControl("chkXem");
                CheckBox chkDulieuChild = (CheckBox)Item.FindControl("chkDulieu");

                if (chkXoa.Checked)
                {
                    //Phân quyền lại cấp cha của node đang chọn                   
                    string strSapxep = "/" + Item.Cells[1].Text + "/";
                    //if (("/" + oT.Sapxep + "/").Contains(strSapxep))
                    //    chkPheduyetChild.Checked = true;
                    if (strSapxep.Contains("/" + oT.ARRSAPXEP + "/") && chkAuto.Checked)
                    {
                        chkXem.Checked = true;
                        chkDulieuChild.Checked = true;
                    }
                }
                else
                {
                    //Phân quyền lại cấp con của node đang chọn                   
                    string strSapxep = "/" + Item.Cells[1].Text + "/";
                    if (strSapxep.Contains("/" + oT.ARRSAPXEP + "/"))
                    {
                        chkDulieuChild.Checked = false;
                    }
                }
            }
        }
        protected void chkTaomoi_CheckedChanged(object sender, EventArgs e)
        {

            CheckBox chkTaomoi = (CheckBox)sender;
            decimal ID = Convert.ToDecimal(chkTaomoi.ToolTip);
            QT_MENU oT = dt.QT_MENU.Where(x => x.ID == ID).FirstOrDefault();
            foreach (DataGridItem Item in dgMenu.Items)
            {
                CheckBox chkXem = (CheckBox)Item.FindControl("chkXem");
                CheckBox chkTaomoiChild = (CheckBox)Item.FindControl("chkTaomoi");
                if (chkTaomoi.Checked)
                {
                    //Phân quyền lại cấp cha của node đang chọn                   
                    string strSapxep = "/" + Item.Cells[1].Text + "/";
                    //if (("/" + oT.Sapxep + "/").Contains(strSapxep))
                    //    chkPheduyetChild.Checked = true;
                    if (strSapxep.Contains("/" + oT.ARRSAPXEP + "/") && chkAuto.Checked)
                    {
                        chkXem.Checked = true;
                        chkTaomoiChild.Checked = true;
                    }
                }
                else
                {
                    //Phân quyền lại cấp con của node đang chọn                   
                    string strSapxep = "/" + Item.Cells[1].Text + "/";
                    if (strSapxep.Contains("/" + oT.ARRSAPXEP + "/"))
                    {
                        chkTaomoiChild.Checked = false;
                    }
                }
            }
        }

        protected void chkXemAll_CheckChange(object sender, EventArgs e)
        {
            CheckBox chkAll = (CheckBox)sender;

            foreach (DataGridItem Item in dgMenu.Items)
            {
                CheckBox chk = (CheckBox)Item.FindControl("chkXem");
                if (chk.Enabled)
                    chk.Checked = chkAll.Checked;

            }
        }

        protected void chkCapnhatAll_CheckChange(object sender, EventArgs e)
        {
            CheckBox chkAll = (CheckBox)sender;

            foreach (DataGridItem Item in dgMenu.Items)
            {
                CheckBox chk = (CheckBox)Item.FindControl("chkCapnhat");
                if (chk.Enabled)
                    chk.Checked = chkAll.Checked;

            }
        }

        protected void chkTaomoiAll_CheckChange(object sender, EventArgs e)
        {
            CheckBox chkAll = (CheckBox)sender;

            foreach (DataGridItem Item in dgMenu.Items)
            {
                CheckBox chk = (CheckBox)Item.FindControl("chkTaomoi");
                if (chk.Enabled)
                    chk.Checked = chkAll.Checked;

            }
        }


        protected void chkXoaAll_CheckChange(object sender, EventArgs e)
        {
            CheckBox chkAll = (CheckBox)sender;

            foreach (DataGridItem Item in dgMenu.Items)
            {
                CheckBox chk = (CheckBox)Item.FindControl("chkXoa");
                if (chk.Enabled)
                    chk.Checked = chkAll.Checked;

            }
        }

        protected void chkDulieuAll_CheckChange(object sender, EventArgs e)
        {
            CheckBox chkAll = (CheckBox)sender;

            foreach (DataGridItem Item in dgMenu.Items)
            {
                CheckBox chk = (CheckBox)Item.FindControl("chkDulieu");
                if (chk.Enabled)
                    chk.Checked = chkAll.Checked;

            }
        }

        protected void chkISXINANGIAM_ALL_CheckChange(object sender, EventArgs e)
        {
            CheckBox chkAll = (CheckBox)sender;

            foreach (DataGridItem Item in dgMenu.Items)
            {
                CheckBox chk = (CheckBox)Item.FindControl("chkISXINANGIAM");
                if (chk.Enabled)
                    chk.Checked = chkAll.Checked;

            }
        }
        protected void chkGDT_ISXINANGIAM_ALL_CheckChange(object sender, EventArgs e)
        {
            CheckBox chkAll = (CheckBox)sender;

            foreach (DataGridItem Item in dgMenu.Items)
            {
                CheckBox chk = (CheckBox)Item.FindControl("chkGDT_ISXINANGIAM");
                if (chk.Enabled)
                    chk.Checked = chkAll.Checked;

            }
        }
        protected void chkISXINANGIAM_CheckChange(object sender, EventArgs e)
        {

            CheckBox chkISXINANGIAM = (CheckBox)sender;
            decimal ID = Convert.ToDecimal(chkISXINANGIAM.ToolTip);
            QT_MENU oT = dt.QT_MENU.Where(x => x.ID == ID).FirstOrDefault();
            foreach (DataGridItem Item in dgMenu.Items)
            {
                CheckBox chkXem = (CheckBox)Item.FindControl("chkXem");
                CheckBox chkISXINANGIAM_Child = (CheckBox)Item.FindControl("chkISXINANGIAM");
                if (chkISXINANGIAM.Checked)
                {
                    //Phân quyền lại cấp cha của node đang chọn                   
                    string strSapxep = "/" + Item.Cells[1].Text + "/";
                    //if (("/" + oT.Sapxep + "/").Contains(strSapxep))
                    //    chkCapnhatChild.Checked = true;
                    if (strSapxep.Contains("/" + oT.ARRSAPXEP + "/") && chkAuto.Checked)
                    {
                        chkXem.Checked = true;
                        chkISXINANGIAM_Child.Checked = true;
                    }
                }
                else
                {
                    //Phân quyền lại cấp con của node đang chọn                   
                    string strSapxep = "/" + Item.Cells[1].Text + "/";
                    if (strSapxep.Contains("/" + oT.ARRSAPXEP + "/"))
                    {
                        chkISXINANGIAM_Child.Checked = false;
                    }
                }
            }
        }
        protected void chkGDT_ISXINANGIAM_CheckChange(object sender, EventArgs e)
        {

            CheckBox chkGDT_ISXINANGIAM = (CheckBox)sender;
            decimal ID = Convert.ToDecimal(chkGDT_ISXINANGIAM.ToolTip);
            QT_MENU oT = dt.QT_MENU.Where(x => x.ID == ID).FirstOrDefault();
            foreach (DataGridItem Item in dgMenu.Items)
            {
                CheckBox chkXem = (CheckBox)Item.FindControl("chkXem");
                CheckBox chkGDT_ISXINANGIAM_Child = (CheckBox)Item.FindControl("chkGDT_ISXINANGIAM");
                if (chkGDT_ISXINANGIAM.Checked)
                {
                    //Phân quyền lại cấp cha của node đang chọn                   
                    string strSapxep = "/" + Item.Cells[1].Text + "/";
                    //if (("/" + oT.Sapxep + "/").Contains(strSapxep))
                    //    chkCapnhatChild.Checked = true;
                    if (strSapxep.Contains("/" + oT.ARRSAPXEP + "/") && chkAuto.Checked)
                    {
                        chkXem.Checked = true;
                        chkGDT_ISXINANGIAM_Child.Checked = true;
                    }
                }
                else
                {
                    //Phân quyền lại cấp con của node đang chọn                   
                    string strSapxep = "/" + Item.Cells[1].Text + "/";
                    if (strSapxep.Contains("/" + oT.ARRSAPXEP + "/"))
                    {
                        chkGDT_ISXINANGIAM_Child.Checked = false;
                    }
                }
            }
        }
        protected void chkHethong_SelectedIndexChanged(object sender, EventArgs e)
        {
            string strID = Request["CID"] + "";
            decimal IDNhom = Convert.ToDecimal(strID);
            bool flag = false;
            foreach (ListItem i in chkHethong.Items)
            {
                decimal HethongID = Convert.ToDecimal(i.Value);
                if (i.Selected)
                {
                    if (dt.QT_NHOMNGUOIDUNG_HETHONG.Where(x => x.NHOMID == IDNhom && x.HETHONGID == HethongID).ToList().Count == 0)
                    {
                        QT_NHOMNGUOIDUNG_HETHONG oT = new QT_NHOMNGUOIDUNG_HETHONG();
                        oT.HETHONGID = HethongID;
                        oT.NHOMID = IDNhom;
                        oT.NGAYTAO = DateTime.Now;
                        oT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        dt.QT_NHOMNGUOIDUNG_HETHONG.Add(oT);
                        dt.SaveChanges();
                        flag = true;
                    }
                }
                else
                {
                    List<QT_NHOMNGUOIDUNG_HETHONG> lst = dt.QT_NHOMNGUOIDUNG_HETHONG.Where(x => x.NHOMID == IDNhom && x.HETHONGID == HethongID).ToList();
                    if (lst.Count > 0)
                    {
                        dt.QT_NHOMNGUOIDUNG_HETHONG.Remove(lst[0]);
                        dt.SaveChanges();
                        flag = true;
                    }
                }
            }
            if (flag)
            {
                LoadChuongtrinh();
            }
        }
       
    }
}