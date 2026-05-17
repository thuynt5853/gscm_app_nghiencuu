
using Module.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Data;
//using BL.GSTP.Danhmuc;
//using BL.GSTP;
//using DAL.GSTP;
using System.Globalization;
using System.Web.UI.WebControls;
using DAL.DKK;
//using BL.DonKK.DanhMuc;

namespace WEB.GSTP.QTDKK.Tinbai
{
    public partial class Chuyenmuc : System.Web.UI.Page
    {
        DKKContextContainer dt = new DKKContextContainer();
        CultureInfo cul = new CultureInfo("vi-VN");
        private const int ROOT = 0, DEL = 0, ADD = 1, UPDATE = 2;
        private string PUBLIC_DEPT = "...";
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    LoadTreeview();
                    LoadDropParent();
                    hddPageIndex.Value = "1";
                    LoadListChildren(ROOT.ToString(), txttimkiem.Text);
                    FillThutu(GetListToaAnByParentID(ROOT.ToString()).Count + 1);
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(btnNew, oPer.TAOMOI);
                    Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                    Cls_Comon.SetButton(cmdDel, oPer.XOA);
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        public void LoadTreeview()
        {
            treemenu.Nodes.Clear();
            TreeNode oRoot = new TreeNode("Danh mục tin tức", ROOT.ToString());
            treemenu.Nodes.Add(oRoot);
            LoadTreeChild(oRoot, PUBLIC_DEPT);
            treemenu.Nodes[ROOT].Expand();
        }
        public void LoadTreeChild(TreeNode root, string dept)
        {
            decimal nID = Convert.ToDecimal(root.Value);
            List<DONKK_CHUYENMUC> listchild = dt.DONKK_CHUYENMUC.Where(x => x.CAPCHAID == nID).OrderBy(y => y.THUTU).ToList();
            if (listchild != null && listchild.Count > 0)
            {
                foreach (DONKK_CHUYENMUC child in listchild)
                {
                    TreeNode nodechild;
                    nodechild = CreateNode(child.ID.ToString(), child.TENCHUYENMUC.ToString());
                    root.ChildNodes.Add(nodechild);
                    LoadTreeChild(nodechild, PUBLIC_DEPT + dept);
                    root.CollapseAll();
                }
            }
        }
        private TreeNode CreateNode(string sNodeId, string sNodeText)
        {
            TreeNode objTreeNode = new TreeNode();
            objTreeNode.Value = sNodeId;
            objTreeNode.Text = sNodeText;
            return objTreeNode;
        }
        protected void treemenu_SelectedNodeChanged(object sender, EventArgs e)
        {
            try
            {
                lbthongbao.Text = "";
                hddToaAnID.Value = treemenu.SelectedValue;
                int hcID = Convert.ToInt32(treemenu.SelectedValue);
                loadedit(hcID);
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        public void loadedit(int ID)
        {
            DONKK_CHUYENMUC chuyenMuc = dt.DONKK_CHUYENMUC.Where(x => x.ID == ID).FirstOrDefault();
            if (chuyenMuc != null)
            {
                txtMa.Text = chuyenMuc.MACHUYENMUC;
                txtTen.Text = chuyenMuc.TENCHUYENMUC;
                hddPageIndex.Value = "1";
                LoadListChildren(ID.ToString(), txttimkiem.Text);
                dropParent.SelectedValue = Convert.ToString(chuyenMuc.CAPCHAID);
                FillThutu(GetListToaAnByParentID(dropParent.SelectedValue).Count);
                if (chuyenMuc.THUTU <= dropThuTu.Items.Count)
                    dropThuTu.SelectedValue = Convert.ToString(chuyenMuc.THUTU);
                else
                    dropThuTu.SelectedIndex = dropThuTu.Items.Count - 1;
                chkActive.Checked = chuyenMuc.HIEULUC == 0 ? false : true;
                cmdDel.Enabled = true;
            }
            else
            {
                txtTen.Text = txtMa.Text = "";
                hddPageIndex.Value = "1";
                LoadListChildren(ID.ToString(), txttimkiem.Text);
            }
        }
        public void LoadListChildren(string capchaid, string textKey)
        {
            int ParentID = Convert.ToInt32(capchaid), countItem = 0, pageSize = Convert.ToInt32(hddPageSize.Value), pageIndex = Convert.ToInt32(hddPageIndex.Value);
            textKey = textKey.Trim().ToLower();
            List<DONKK_CHUYENMUC> lst = dt.DONKK_CHUYENMUC.Where(x => x.CAPCHAID == ParentID && (x.MACHUYENMUC.ToLower().Contains(textKey) || x.TENCHUYENMUC.ToLower().Contains(textKey))).OrderBy(x => x.THUTU).ToList();
            if (lst != null && lst.Count > 0)
            {
                countItem = lst.Count;
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(countItem, pageSize).ToString();
                int pageSkip = (pageIndex - 1) * pageSize;
                dgList.DataSource = lst.Skip(pageSkip).Take(pageSize).ToList<DONKK_CHUYENMUC>();
                dgList.DataBind();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + countItem.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
                pndata.Visible = true;
            }
            else
            {
                dgList.DataSource = null;
                dgList.DataBind();
                pndata.Visible = false;
            }
        }
        private void FillThutu(int iCount)
        {
            dropThuTu.Items.Clear();
            if (iCount > 0)
            {
                for (int i = 1; i <= iCount; i++)
                {
                    dropThuTu.Items.Add(new ListItem(i.ToString(), i.ToString()));
                }
                dropThuTu.SelectedIndex = iCount - 1;
            }
            else
            {
                dropThuTu.Items.Add(new ListItem("1", "1"));
            }
        }
        public List<DONKK_CHUYENMUC> GetListToaAnByParentID(string chaid)
        {
            int ID = Convert.ToInt32(chaid);
            return dt.DONKK_CHUYENMUC.Where(x => x.CAPCHAID == ID).ToList();
        }
        /*-------------action--------------*/
        protected void btnNew_Click(object sender, EventArgs e)
        {
            try
            {
                reSetControl();
                if (treemenu.SelectedNode != null)
                {
                    dropParent.SelectedValue = treemenu.SelectedValue;
                    FillThutu(GetListToaAnByParentID(treemenu.SelectedValue).Count + 1);
                }
                else
                {
                    dropParent.SelectedValue = "0";
                    FillThutu(GetListToaAnByParentID("0").Count + 1);
                }
                hddToaAnID.Value = "0";
                cmdDel.Enabled = true;
                cmdUpdate.Enabled = true;
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                decimal danhMucID = Convert.ToDecimal(hddToaAnID.Value), ParentID = Convert.ToDecimal(dropParent.SelectedValue);
                int thuTu = Convert.ToInt32(dropThuTu.SelectedValue), action = UPDATE;
                string Ten = txtTen.Text.Trim(), nodeName = "";
                if (!ValidateForm(danhMucID, Ten))
                {
                    return;
                }
                bool isNew = false;
                DONKK_CHUYENMUC danhMuc = dt.DONKK_CHUYENMUC.Where(x => x.ID == danhMucID).FirstOrDefault<DONKK_CHUYENMUC>();
                if (danhMuc == null)
                {
                    isNew = true;
                    danhMuc = new DONKK_CHUYENMUC();
                    danhMuc.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                    danhMuc.NGAYTAO = DateTime.Now;
                    nodeName = dropParent.SelectedItem.Text;
                }
                else
                {
                    danhMuc.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                    danhMuc.NGAYSUA = DateTime.Now;
                    nodeName = danhMuc.TENCHUYENMUC;
                }
                danhMuc.CAPCHAID = ParentID;
                danhMuc.MACHUYENMUC = txtMa.Text.Trim();
                danhMuc.TENCHUYENMUC = Ten;
                danhMuc.CAPCHAID = Convert.ToDecimal(dropParent.SelectedValue);
                danhMuc.HIEULUC = (chkActive.Checked) ? Convert.ToDecimal(1) : Convert.ToDecimal(0);
                danhMuc.THUTU = thuTu;
                if (isNew)
                {
                    dt.DONKK_CHUYENMUC.Add(danhMuc);
                    action = ADD;
                }
                dt.SaveChanges();

                danhMucID = danhMuc.ID;
                EditNode(nodeName.Replace(".", ""), Ten.Replace(".", ""), danhMucID, action);
                // Nếu là sửa thì kiểm tra đơn vị sửa có đơn vị con hay không. Nếu có phải update lại ArrSapXep và ArrThuTu
                if (!isNew)
                {
                    List<DONKK_CHUYENMUC> lst = GetListToaAnByParentID(danhMuc.ID.ToString());
                    if (lst != null && lst.Count > 0)
                    {
                        //UpdateChildren(lst, strArrThuTu, strArrSapXep);
                    }
                }
                LoadDropParent();
                hddPageIndex.Value = "1";
                LoadListChildren(ParentID.ToString(), txttimkiem.Text);
                FillThutu(GetListToaAnByParentID(ParentID.ToString()).Count + 1);
                reSetControl();
                lbthongbao.Text = "Lưu thành công!";
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private void UpdateChildren(List<DONKK_CHUYENMUC> lst)
        {
            foreach (DONKK_CHUYENMUC item in lst)
            {
                dt.SaveChanges();
                List<DONKK_CHUYENMUC> lstChild = GetListToaAnByParentID(item.ID.ToString());
                if (lstChild != null && lstChild.Count > 0)
                {
                    UpdateChildren(lstChild);
                }
            }
        }
        private void UpdateChildren(List<DONKK_CHUYENMUC> lst, string ParrThuTu)
        {
            foreach (DONKK_CHUYENMUC item in lst)
            {
                dt.SaveChanges();
                List<DONKK_CHUYENMUC> lstChild = GetListToaAnByParentID(item.ID.ToString());
                if (lstChild != null && lstChild.Count > 0)
                {
                    UpdateChildren(lstChild);
                }
            }
        }
        protected void btnDel_Click(object sender, EventArgs e)
        {
            try
            {
                if (hddToaAnID.Value != "0")
                {
                    List<DONKK_CHUYENMUC> lst = GetListToaAnByParentID(hddToaAnID.Value);
                    if (lst != null && lst.Count > 0)
                    {
                        lbthongbao.Text = "Không xóa được vì có danh mục cấp dưới!";
                    }
                    else
                    {
                        int danhMucID = Convert.ToInt32(hddToaAnID.Value);
                        xoa(danhMucID);
                        reSetControl();
                        lbthongbao.Text = "Xóa thành công!";
                    }
                }
                else
                {
                    lbthongbao.Text = "Bạn chưa chọn thông tin cần xóa!";
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void cmdThutu_Click(object sender, EventArgs e)
        {
            try
            {
                string parentID = "0";
                decimal danhMucID = Convert.ToDecimal(dgList.Items[0].Cells[0].Text);
                DONKK_CHUYENMUC danhMuc = dt.DONKK_CHUYENMUC.Where(x => x.ID == danhMucID).FirstOrDefault<DONKK_CHUYENMUC>();
                if (danhMuc != null)
                {
                    parentID = danhMuc.CAPCHAID.ToString();
                    DONKK_CHUYENMUC ParentDMHanhChinh = dt.DONKK_CHUYENMUC.Where(x => x.ID == danhMuc.CAPCHAID).FirstOrDefault<DONKK_CHUYENMUC>();
                }
                int DMToaAnIDColIndex = 0;
                foreach (DataGridItem oItem in dgList.Items)
                {
                    danhMucID = Convert.ToDecimal(oItem.Cells[DMToaAnIDColIndex].Text);
                    danhMuc = dt.DONKK_CHUYENMUC.Where(x => x.ID == danhMucID).FirstOrDefault<DONKK_CHUYENMUC>();
                    DropDownList dropThuTu = (DropDownList)oItem.FindControl("DropThuTuChildren");
                    danhMuc.THUTU = Convert.ToInt32(dropThuTu.SelectedValue);
                    danhMuc.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                    danhMuc.NGAYSUA = DateTime.Now;
                    dt.SaveChanges();
                    List<DONKK_CHUYENMUC> lst = GetListToaAnByParentID(oItem.Cells[DMToaAnIDColIndex].Text);
                    if (lst.Count > 0)
                    {
                        UpdateChildren(lst);
                    }
                }
                LoadDropParent();
                hddPageIndex.Value = "1";
                LoadListChildren(parentID, txttimkiem.Text);
                lbthongbao.Text = "Lưu thứ tự thành công!";
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
            txtMa.Text = txtTen.Text = "";
            dropParent.SelectedIndex = 0;
            if (hddToaAnID.Value != "0")
            {
                decimal hcID = Convert.ToDecimal(hddToaAnID.Value);
                DONKK_CHUYENMUC dmHanhChinh = dt.DONKK_CHUYENMUC.Where(x => x.ID == hcID).FirstOrDefault<DONKK_CHUYENMUC>();
                if (dmHanhChinh != null)
                {
                    FillThutu(GetListToaAnByParentID(Convert.ToString(dmHanhChinh.CAPCHAID)).Count + 1);
                }
            }
            chkActive.Checked = false;
            hddToaAnID.Value = "0";
            txtMa.Focus();
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            try
            {
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
                {
                    DONKK_CHUYENMUC item = (DONKK_CHUYENMUC)e.Item.DataItem;
                    DropDownList dropThuTuChildren = (DropDownList)e.Item.FindControl("dropThuTuChildren");
                    decimal ParentID = Convert.ToDecimal(item.CAPCHAID), countItem = 0;
                    List<DONKK_CHUYENMUC> lst = dt.DONKK_CHUYENMUC.Where(x => x.CAPCHAID == ParentID).ToList();
                    if (lst != null && lst.Count > 0)
                    {
                        countItem = lst.Count;
                        for (int i = 1; i <= countItem; i++)
                        {
                            dropThuTuChildren.Items.Add(new ListItem(i.ToString(), i.ToString()));
                        }
                    }
                    if (countItem <= item.THUTU)
                    {
                        dropThuTuChildren.SelectedValue = countItem.ToString();
                    }
                    else
                    {
                        dropThuTuChildren.SelectedValue = item.THUTU.ToString();
                    }
                    LinkButton lbtSua = (LinkButton)e.Item.FindControl("lbtSua");
                    LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                    lbtSua.Visible = oPer.CAPNHAT; lbtXoa.Visible = oPer.XOA;
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        public void xoa(int id)
        {
            List<DONKK_CHUYENMUC> obj = dt.DONKK_CHUYENMUC.Where(x => x.CAPCHAID == id).ToList();
            if (obj != null && obj.Count > 0)
            {
                lbthongbao.Text = "Không xóa được vì có danhMuc cấp dưới!";
            }
            else
            {
                DONKK_CHUYENMUC danhMuc = dt.DONKK_CHUYENMUC.Where(x => x.ID == id).FirstOrDefault();
                if (danhMuc != null)
                {
                    dt.DONKK_CHUYENMUC.Remove(danhMuc);
                    dt.SaveChanges();
                    List<DONKK_CHUYENMUC> lst = dt.DONKK_CHUYENMUC.Where(x => x.CAPCHAID == danhMuc.CAPCHAID).OrderBy(y => y.THUTU).ToList();
                    if (lst.Count != 0 && lst != null)
                    {
                        hddPageIndex.Value = "1";
                        LoadListChildren(Convert.ToString(danhMuc.CAPCHAID), txttimkiem.Text);
                    }
                    else
                    {
                        pndata.Visible = false;
                    }
                    EditNode(danhMuc.TENCHUYENMUC, "", 0, DEL);
                    LoadDropParent();
                    lbthongbao.Text = "Xóa thành công!";
                }
            }
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            try
            {
                int danhMucID = Convert.ToInt32(e.CommandArgument.ToString());
                lbthongbao.Text = "";
                switch (e.CommandName)
                {
                    case "Sua":
                        loadedit(danhMucID);
                        hddToaAnID.Value = e.CommandArgument.ToString();
                        break;
                    case "Xoa":
                        // chỉ load lại danh sách các control phía trên giữ nguyên
                        string dropParentValue = "0";
                        if (dropParent.SelectedIndex != 0)
                        {
                            dropParentValue = dropParent.SelectedValue;
                        }
                        xoa(danhMucID);
                        if (dropParentValue != "0")
                        {
                            dropParent.SelectedValue = dropParentValue;
                        }
                        break;
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadListChildren(hddToaAnID.Value, txttimkiem.Text);
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadListChildren(hddToaAnID.Value, txttimkiem.Text);
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadListChildren(hddToaAnID.Value, txttimkiem.Text);
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadListChildren(hddToaAnID.Value, txttimkiem.Text);
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                hddPageIndex.Value = lbCurrent.Text;
                LoadListChildren(hddToaAnID.Value, txttimkiem.Text);
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #endregion
        protected void dropParent_SelectedIndexChanged(object sender, EventArgs e)
        {
            try { FillThutu(GetListToaAnByParentID(dropParent.SelectedValue).Count + 1); } catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private bool ValidateForm(decimal HanhChinhID, string Ten)
        {
            int lengthMa = txtMa.Text.Trim().Length;
            if (lengthMa <= 0 || lengthMa > 50)
            {
                lbthongbao.Text = "Mã danh mục không được trống hoặc quá 50 ký tự. Hãy nhập lại!";
                return false;
            }
            int lengthTen = txtTen.Text.Trim().Length;
            if (lengthTen <= 0 || lengthTen > 250)
            {
                lbthongbao.Text = "Tên danh mục không được trống hoặc quá 250 ký tự. Hãy nhập lại!";
                return false;
            }
            DONKK_CHUYENMUC danhMucCheck = dt.DONKK_CHUYENMUC.Where(x => x.TENCHUYENMUC.ToLower() == Ten.ToLower()).FirstOrDefault<DONKK_CHUYENMUC>();
            if (danhMucCheck != null)
            {
                if (danhMucCheck.ID != HanhChinhID)
                {
                    lbthongbao.Text = "Tên danh mục này đã tồn tại. Hãy nhập lại!";
                    txtTen.Focus();
                    return false;
                }
            }
            // Đơn vị cấp trên không thể là chính nó hoặc là đơn vị cấp dưới của nó
            if (hddToaAnID.Value != "0")
            {
                if (dropParent.SelectedValue == hddToaAnID.Value)
                {
                    lbthongbao.Text = "Danh mục cấp trên không thể là chính nó. Hãy chọn lại!";
                    return false;
                }
                if (dropParent.SelectedValue != "0")
                {
                    DONKK_CHUYENMUC danhMuc = dt.DONKK_CHUYENMUC.Where(x => x.ID == HanhChinhID).FirstOrDefault<DONKK_CHUYENMUC>();
                    if (danhMuc != null)
                    {
                        decimal danhMucPID = Convert.ToDecimal(dropParent.SelectedValue);
                        DONKK_CHUYENMUC danhMucP = dt.DONKK_CHUYENMUC.Where(x => x.ID == danhMucPID).FirstOrDefault<DONKK_CHUYENMUC>();
                        //if (danhMucP != null)
                        //{
                        //    lbthongbao.Text = "Tòa án cấp trên không thể là danhMuc cấp dưới của nó. Hãy chọn lại!";
                        //    return false;
                        //}
                    }
                }
            }
            return true;
        }
        protected void Btntimkiem_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadListChildren(hddToaAnID.Value, txttimkiem.Text);
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private void EditNode(string nodeName, string nodeNameEdit, decimal nodeID, int action)
        {
            // tim node
            if (treemenu.Nodes[ROOT].ChildNodes.Count > 0)
            {
                foreach (TreeNode node in treemenu.Nodes[ROOT].ChildNodes)
                {
                    if (node.Text.Equals(nodeName))
                    {
                        if (action == DEL)
                        {
                            treemenu.Nodes[ROOT].ChildNodes.Remove(node);
                            treemenu.Nodes[ROOT].Expand();
                        }
                        else if (action == UPDATE)
                        {
                            node.Text = nodeNameEdit;
                        }
                        else if (action == ADD)
                        {
                            TreeNode nodeNew = CreateNode(nodeID.ToString(), nodeNameEdit);
                            node.ChildNodes.Add(nodeNew);
                            node.Expand();
                        }
                        return;
                    }
                    if (EditNodeChild(node, nodeName, nodeNameEdit, nodeID, action))
                    {
                        return;
                    }
                }
            }
        }
        private bool EditNodeChild(TreeNode node, string nodeName, string nodeNameEdit, decimal nodeID, int action)
        {
            foreach (TreeNode nodeChild in node.ChildNodes)
            {
                if (nodeChild.Text.Equals(nodeName))
                {
                    if (action == DEL)
                    {
                        node.ChildNodes.Remove(nodeChild);
                        node.Expand();
                    }
                    else if (action == UPDATE)
                    {
                        nodeChild.Text = nodeNameEdit;
                    }
                    else if (action == ADD)
                    {
                        TreeNode nodeNew = CreateNode(nodeID.ToString(), nodeNameEdit);
                        nodeChild.ChildNodes.Add(nodeNew);
                        nodeChild.Expand();
                    }
                    return true;
                }
                if (EditNodeChild(nodeChild, nodeName, nodeNameEdit, nodeID, action))
                {
                    return true;
                }
            }
            return false;
        }
        private void LoadDropParent()
        {
            dropParent.Items.Clear();
            dropParent.DataSource = null;
            dropParent.DataBind();
            dropParent.Items.Add(new ListItem("Chọn", ROOT.ToString()));
            LoadDropParentListChild(0, PUBLIC_DEPT);
        }
        private void LoadDropParentListChild(decimal pID, string dept)
        {
            List<DONKK_CHUYENMUC> listchild = dt.DONKK_CHUYENMUC.Where(x => x.CAPCHAID == pID).OrderBy(y => y.THUTU).ToList();
            if (listchild != null && listchild.Count > 0)
            {
                foreach (DONKK_CHUYENMUC child in listchild)
                {
                    dropParent.Items.Add(new ListItem(dept + child.TENCHUYENMUC, child.ID.ToString()));
                    LoadDropParentListChild(child.ID, PUBLIC_DEPT + dept);
                }
            }
        }
    }
}