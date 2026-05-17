using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.Danhmuc.Phongban
{
    public partial class Danhsach : System.Web.UI.Page
    {
        private string PUBLIC_DEPT = "..";
        GSTPContext dt = new GSTPContext();
        private const int ROOT = 0, DEL = 0, ADD = 1, UPDATE = 2;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    LoadTreeview();
               
                    hddPageIndex.Value = "1";
                    string strPath = Request.FilePath.ToString().ToLower();
                    //if (strPath.Substring(0, 1) == "/")
                    //{
                    //    strPath = strPath.Substring(1);
                    //}
                    MenuPermission oPer = Cls_Comon.GetMenuPer(strPath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(cmdLammoi, oPer.TAOMOI);
                    Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                  

                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        public void LoadTreeview()
        {
            treemenu.Nodes.Clear();
            List<DM_TOAAN> listchild = dt.DM_TOAAN.Where(x => x.CAPCHAID == 0).OrderBy(y => y.THUTU).ToList();
            if (listchild.Count > 0)
            {
                TreeNode oRoot = new TreeNode(listchild[0].TEN, listchild[0].ID.ToString());
                treemenu.Nodes.Add(oRoot);
                LoadTreeChild(oRoot, "");
                LoadDS(listchild[0].ID);
            }
            treemenu.Nodes[ROOT].Expand();
        }
        private void LoadDS(decimal TOAANID)
        {
            dgList.DataSource = dt.DM_PHONGBAN.Where(x => x.TOAANID == TOAANID).ToList();
            dgList.DataBind();
        }
        private TreeNode CreateNode(string sNodeId, string sNodeText)
        {
            TreeNode objTreeNode = new TreeNode();
            objTreeNode.Value = sNodeId;
            objTreeNode.Text = sNodeText;
            return objTreeNode;
        }
        public void LoadTreeChild(TreeNode root, string dept)
        {
            decimal nID = Convert.ToDecimal(root.Value);
            List<DM_TOAAN> listchild = dt.DM_TOAAN.Where(x => x.CAPCHAID == nID).OrderBy(y => y.THUTU).ToList();
            if (listchild != null && listchild.Count > 0)
            {
                foreach (DM_TOAAN child in listchild)
                {
                    TreeNode nodechild;
                    nodechild = CreateNode(child.ID.ToString(), child.TEN.ToString());
                    root.ChildNodes.Add(nodechild);
                    //if (child.LOAITOA != "CAPCAO")
                    //{
                        LoadTreeChild(nodechild, PUBLIC_DEPT + dept);
                    //}
                    root.CollapseAll();
                }
            }
        }
       
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                decimal toaAnID = Convert.ToDecimal(hddToaAnID.Value);              
                string Ten = txtTen.Text.Trim();
                if(hddToaAnID.Value=="0")
                {
                    lbthongbao.Text = "Chưa chọn tòa án !";
                    return;
                }
                if (txtTen.Text=="")
                {
                    lbthongbao.Text = "Chưa nhập tên phòng ban !";
                    return;
                }
                bool isNew = false;
                DM_PHONGBAN obj = new DM_PHONGBAN();
                if (hddID.Value=="0")
                {
                    isNew = true;
                   
                }
                else
                {
                    decimal IDPB = Convert.ToDecimal(hddID.Value);
                    obj = dt.DM_PHONGBAN.Where(x => x.ID == IDPB).FirstOrDefault();
                }
                obj.TOAANID = toaAnID;             
                obj.TENPHONGBAN = Ten;
                obj.HIEULUC = (chkActive.Checked) ? 1 : 0;
                obj.DIACHI = txtDiachi.Text;
                obj.ISHINHSU = (chkHinhSu.Checked) ? 1 : 0;
                obj.ISDANSU = (chkDanSu.Checked) ? 1 : 0;
                obj.ISHNGD = (chkHonNhanGD.Checked) ? 1 : 0;
                obj.ISKDTM = (chkKDTM.Checked) ? 1 : 0;
                obj.ISHANHCHINH = (chkHanhChinh.Checked) ? 1 : 0;
                obj.ISLAODONG = (chkLaoDong.Checked) ? 1 : 0;
                obj.ISPHASAN = (chkPhasan.Checked) ? 1 : 0;
                obj.ISBPXLHC = (chkXLHC.Checked) ? 1 : 0;
                obj.ISGIAIQUYETDON =Convert.ToDecimal(ddlLoai.SelectedValue);
                obj.HAUTOCV = txtHauto.Text;
                if (isNew)
                {
                    dt.DM_PHONGBAN.Add(obj);                    
                }
                dt.SaveChanges();            
                reSetControl();
                LoadDS(toaAnID);
                lbthongbao.Text = "Lưu thành công!";
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
     
        protected void treemenu_SelectedNodeChanged(object sender, EventArgs e)
        {
            try
            {
                lbthongbao.Text = ""; hddToaAnID.Value = treemenu.SelectedValue;
                txtMa.Text = treemenu.SelectedNode.Text;
                decimal hcID = Convert.ToDecimal(treemenu.SelectedValue);
                LoadDS(hcID);
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            try
            {
                reSetControl();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private void reSetControl()
        {
             txtTen.Text = "";
            txtDiachi.Text = "";
            txtHauto.Text = "";
            chkActive.Checked = false;
            hddID.Value = "0";
            txtMa.Focus();
        }          
        public void loadedit(decimal ID)
        {
            DM_PHONGBAN obj = dt.DM_PHONGBAN.Where(x => x.ID == ID).FirstOrDefault();
            if (obj != null)
            {
                txtTen.Text=obj.TENPHONGBAN;
                txtDiachi.Text = obj.DIACHI + "";
                chkActive.Checked= obj.HIEULUC ==1  ? true : false;
                chkHinhSu.Checked = obj.ISHINHSU == 1 ? true : false;
                chkDanSu.Checked = obj.ISDANSU == 1 ? true : false;
                chkHonNhanGD.Checked = obj.ISHNGD == 1 ? true : false;
                chkKDTM.Checked = obj.ISKDTM == 1 ? true : false;
                chkHanhChinh.Checked = obj.ISHANHCHINH == 1 ? true : false;
                chkLaoDong.Checked = obj.ISLAODONG == 1 ? true : false;
                chkPhasan.Checked = obj.ISPHASAN == 1 ? true : false;
                chkXLHC.Checked = obj.ISBPXLHC == 1 ? true : false;
                ddlLoai.SelectedValue = obj.ISGIAIQUYETDON+"";
                txtHauto.Text = obj.HAUTOCV + "";
            }
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            try
            {
                decimal ID = Convert.ToDecimal(e.CommandArgument.ToString());
                lbthongbao.Text = "";
                switch (e.CommandName)
                {
                    case "Sua":
                        loadedit(ID);
                        hddID.Value = e.CommandArgument.ToString();
                        break;
                    case "Xoa":
                        // chỉ load lại danh sách các control phía trên giữ nguyên
                        DM_PHONGBAN obj = dt.DM_PHONGBAN.Where(x => x.ID == ID).FirstOrDefault();
                        dt.DM_PHONGBAN.Remove(obj);
                        dt.SaveChanges();
                        reSetControl();
                        LoadDS(Convert.ToDecimal(hddToaAnID.Value));
                        break;
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
    }
}