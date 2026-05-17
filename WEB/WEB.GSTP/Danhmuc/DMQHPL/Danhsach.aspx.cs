using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using BL.GSTP;

namespace WEB.GSTP.Danhmuc.DMQHPL
{
    public partial class Danhsach : System.Web.UI.Page
    {
        private string PUBLIC_DEPT = "...";
        GSTPContext dt = new GSTPContext();
        private const int ROOT = 0, DEL = 0, ADD = 1, UPDATE = 2;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    LoadTreeview();
                    LoadDropParent();
                    LoadDrop_QHPL_CONGBO();
                    dgList.CurrentPageIndex = 0;
                    hddPageIndex.Value = "1";
                    LoadListChildren(ROOT.ToString(), txttimkiem.Text);
                    FillThutu(GetListHanhChinhByID(ROOT.ToString()).Count + 1);
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(cmdNew, oPer.TAOMOI);
                    Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                    Cls_Comon.SetButton(cmdDel, oPer.XOA);
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        public void LoadTreeview()
        {
            treemenu.Nodes.Clear();
            TreeNode oRoot = new TreeNode("Quan hệ pháp luật", ROOT.ToString());
            treemenu.Nodes.Add(oRoot);
            LoadTreeChild(oRoot, PUBLIC_DEPT);
            treemenu.Nodes[0].Expand();
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
            decimal LoaiAn = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
            decimal nID = Convert.ToDecimal(root.Value);
            List<DM_QHPL_TK> listchild = dt.DM_QHPL_TK.Where(x => x.PARENT_ID == nID && x.STYLES== LoaiAn).OrderBy(y => y.ORDERS).ToList();
            if (listchild != null && listchild.Count > 0)
            {
                foreach (DM_QHPL_TK child in listchild)
                {
                    TreeNode nodechild;
                    nodechild = CreateNode(child.ID.ToString(), child.CASE_NAME.ToString());
                    root.ChildNodes.Add(nodechild);
                    LoadTreeChild(nodechild, PUBLIC_DEPT + dept);
                    root.CollapseAll();
                }
            }
        }
        public List<DM_QHPL_TK> GetListHanhChinhByID(string chaid)
        {
            int ID = Convert.ToInt32(chaid);
            decimal LoaiAn = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
            return dt.DM_QHPL_TK.Where(x => x.PARENT_ID == ID && x.STYLES == LoaiAn).ToList();
        }
        protected void btnNew_Click(object sender, EventArgs e)
        {
            try
            {
                btnLammoi_Click(sender, e);
                if (treemenu.SelectedNode != null)
                {
                    dropParent.SelectedValue = treemenu.SelectedValue;
                    FillThutu(GetListHanhChinhByID(treemenu.SelectedValue).Count + 1);
                }
                else
                {
                    btnLammoi_Click(sender, e);
                    dropParent.SelectedValue = "0";
                    FillThutu(GetListHanhChinhByID("0").Count + 1);
                }
                hddid.Value = "0";
                cmdDel.Enabled = true;
                cmdUpdate.Enabled = true;
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                Decimal HanhChinhID = Convert.ToDecimal(hddid.Value), ParentID = Convert.ToDecimal(dropParent.SelectedValue);
                int thuTu = Convert.ToInt32(dropthutu.SelectedValue), action = UPDATE;
                string Ten = txtTen.Text.Trim(), nodeName = "";
                if (!ValidateForm(HanhChinhID, Ten))
                {
                    return;
                }
                bool isNew = false;
                DM_QHPL_TK dmHanhChinh = dt.DM_QHPL_TK.Where(x => x.ID == HanhChinhID).FirstOrDefault<DM_QHPL_TK>();
                if (dmHanhChinh == null)
                {
                    isNew = true;
                    dmHanhChinh = new DM_QHPL_TK();
                  
                    nodeName = dropParent.SelectedItem.Text;
                }
                else
                {
               
                    nodeName = dmHanhChinh.CASE_NAME;
                }
                dmHanhChinh.PARENT_ID = ParentID;
              
                dmHanhChinh.CASE_NAME = txtTen.Text.Trim();
                dmHanhChinh.STYLES = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
                dmHanhChinh.ENABLE = (chkActive.Checked) ? Convert.ToDecimal(1) : Convert.ToDecimal(0);
                dmHanhChinh.ORDERS = thuTu;

                dmHanhChinh.CONGBO_CASE_ID = Convert.ToInt16(ddlQHPL_CONGBO.SelectedValue);
                dmHanhChinh.CONGBO_CASE_NAME = ddlQHPL_CONGBO.SelectedItem.ToString();

                if (isNew)
                {
                    dt.DM_QHPL_TK.Add(dmHanhChinh);
                    action = ADD;
                }
                dt.SaveChanges();
                #region Lưu ArrSapXep và ArrThuTu
                string strArrSapXep = "", strArrThuTu = "", strTen = "";
                DM_QHPL_TK HanhChinhParent = dt.DM_QHPL_TK.Where(x => x.ID == ParentID).FirstOrDefault<DM_QHPL_TK>();
                if (HanhChinhParent == null)
                {
                    strTen = dmHanhChinh.CASE_NAME;
                    strArrSapXep = "0/" + dmHanhChinh.ID;
                    if (thuTu < 10)
                    {
                        strArrThuTu = "0" + "/" + dropthutu.SelectedValue + "00";
                    }
                    else
                    {
                        strArrThuTu = "0" + "/9" + dropthutu.SelectedValue;
                    }
                }
                else
                {
                   
                    strArrSapXep = HanhChinhParent.ARRSAPXEP + "/" + dmHanhChinh.ID;
                    if (thuTu < 10)
                    {
                        strArrThuTu = HanhChinhParent.ARRTHUTU + "/" + dropthutu.SelectedValue + "00";
                    }
                    else
                    {
                        strArrThuTu = HanhChinhParent.ARRTHUTU + "/9" + dropthutu.SelectedValue;
                    }
                }
               
                dmHanhChinh.ARRSAPXEP = strArrSapXep; dmHanhChinh.ARRTHUTU = strArrThuTu;
                dt.SaveChanges();
                #endregion
                HanhChinhID = dmHanhChinh.ID;
                EditNode(nodeName.Replace(".", ""), Ten.Replace(".", ""), HanhChinhID, action);
                // Nếu là sửa thì kiểm tra QHPL sửa có QHPL con hay không. Nếu có phải update lại ArrSapXep và ArrThuTu
                if (!isNew)
                {
                    List<DM_QHPL_TK> lst = GetListHanhChinhByID(dmHanhChinh.ID.ToString());
                    if (lst != null && lst.Count > 0)
                    {
                        UpdateChildren(lst, strArrThuTu, strArrSapXep, "", 0);
                    }
                }
                LoadDropParent();
                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                LoadListChildren(ParentID.ToString(), txttimkiem.Text);
                FillThutu(GetListHanhChinhByID(ParentID.ToString()).Count + 1);
                btnLammoi_Click(sender, e);
                lbthongbao.Text = "Lưu thành công!";
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private void UpdateChildren(List<DM_QHPL_TK> lst, string ParrThuTu, string ParrSapXep, string MaTen, int SoCap)
        {
            foreach (DM_QHPL_TK item in lst)
            {
               
                item.ARRSAPXEP = ParrSapXep + "/" + item.ID;
                if (item.ORDERS < 10)
                {
                    item.ARRTHUTU = ParrThuTu + "/" + item.ORDERS + "00";
                }
                else
                {
                    item.ARRTHUTU = ParrThuTu + "/9" + item.ORDERS;
                }
                dt.SaveChanges();
                List<DM_QHPL_TK> lstChild = GetListHanhChinhByID(item.ID.ToString());
                if (lstChild != null && lstChild.Count > 0)
                {
                    UpdateChildren(lstChild, item.ARRTHUTU, item.ARRSAPXEP, "", 0);
                }
            }
        }
        private void UpdateChildren(List<DM_QHPL_TK> lst, string ParrThuTu)
        {
            foreach (DM_QHPL_TK item in lst)
            {
                if (item.ORDERS < 10)
                {
                    item.ARRTHUTU = ParrThuTu + "/" + item.ORDERS + "00";
                }
                else
                {
                    item.ARRTHUTU = ParrThuTu + "/9" + item.ORDERS;
                }
                dt.SaveChanges();
                List<DM_QHPL_TK> lstChild = GetListHanhChinhByID(item.ID.ToString());
                if (lstChild != null && lstChild.Count > 0)
                {
                    UpdateChildren(lstChild, item.ARRTHUTU);
                }
            }
        }
        private int GetLevel(decimal dvID)
        {
            int level = 0;
            if (dvID == 0)
            {
                level = 0;
            }
            else
            {
                DM_QHPL_TK dv = dt.DM_QHPL_TK.Where(x => x.ID == dvID).FirstOrDefault<DM_QHPL_TK>();
                if (dv != null)
                {
                    level = 0;
                }
            }
            return level;
        }
        protected void btnDel_Click(object sender, EventArgs e)
        {
            try
            {
                if (hddid.Value != "0")
                {
                    List<DM_QHPL_TK> lst = GetListHanhChinhByID(hddid.Value);
                    if (lst != null && lst.Count > 0)
                    {
                        lbthongbao.Text = "Không xóa được vì có cấp dưới!";
                    }
                    else
                    {
                        int dvID = Convert.ToInt32(hddid.Value);
                        xoa(dvID);
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
                string strArrThuTuParent = "0", parentID = "0";
                decimal hcID = Convert.ToDecimal(dgList.Items[0].Cells[0].Text);
                DM_QHPL_TK dmHanhChinh = dt.DM_QHPL_TK.Where(x => x.ID == hcID).FirstOrDefault<DM_QHPL_TK>();
                if (dmHanhChinh != null)
                {
                    parentID = dmHanhChinh.PARENT_ID.ToString();
                    DM_QHPL_TK ParentDMHanhChinh = dt.DM_QHPL_TK.Where(x => x.ID == dmHanhChinh.PARENT_ID).FirstOrDefault<DM_QHPL_TK>();
                    if (ParentDMHanhChinh != null)
                    {
                        strArrThuTuParent = ParentDMHanhChinh.ARRTHUTU;
                    }
                    else
                    {
                        strArrThuTuParent = "0";
                    }
                }
                int DMHanhChinhIDColIndex = 0;
                foreach (DataGridItem oItem in dgList.Items)
                {
                    hcID = Convert.ToDecimal(oItem.Cells[DMHanhChinhIDColIndex].Text);
                    dmHanhChinh = dt.DM_QHPL_TK.Where(x => x.ID == hcID).FirstOrDefault<DM_QHPL_TK>();
                    DropDownList DropThuTu = (DropDownList)oItem.FindControl("DropThuTuChildren");
                    dmHanhChinh.ORDERS = Convert.ToInt32(DropThuTu.SelectedValue);
                    DM_QHPL_TK HanhChinhParent = dt.DM_QHPL_TK.Where(x => x.ID == dmHanhChinh.PARENT_ID).FirstOrDefault<DM_QHPL_TK>();
                    if (HanhChinhParent == null)
                        dmHanhChinh.ARRSAPXEP = "0/" + dmHanhChinh.ID;
                    else
                        dmHanhChinh.ARRSAPXEP = HanhChinhParent.ARRSAPXEP+ "/" + dmHanhChinh.ID;
                    if (dmHanhChinh.ORDERS < 10)
                    {
                        dmHanhChinh.ARRTHUTU = strArrThuTuParent + "/" + DropThuTu.SelectedValue + "00";
                    }
                    else
                    {
                        dmHanhChinh.ARRTHUTU = strArrThuTuParent + "/9" + DropThuTu.SelectedValue;
                    }
                  
                    dt.SaveChanges();
                    List<DM_QHPL_TK> lst = GetListHanhChinhByID(oItem.Cells[DMHanhChinhIDColIndex].Text);
                    if (lst.Count > 0)
                    {
                        UpdateChildren(lst, dmHanhChinh.ARRTHUTU, dmHanhChinh.ARRSAPXEP,"",0);
                    }
                }
                hddPageIndex.Value = "1";
                LoadListChildren(parentID, txttimkiem.Text);
                lbthongbao.Text = "Lưu thứ tự thành công!";
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void treemenu_SelectedNodeChanged(object sender, EventArgs e)
        {
            try
            {
                lbthongbao.Text = ""; hddid.Value = treemenu.SelectedValue;
                int hcID = Convert.ToInt32(treemenu.SelectedValue);
                loadedit(hcID);
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
            if (hddid.Value != "0")
            {
                decimal hcID = Convert.ToDecimal(hddid.Value);
                DM_QHPL_TK dmHanhChinh = dt.DM_QHPL_TK.Where(x => x.ID == hcID).FirstOrDefault<DM_QHPL_TK>();
                if (dmHanhChinh != null)
                {
                    FillThutu(GetListHanhChinhByID(Convert.ToString(dmHanhChinh.PARENT_ID)).Count + 1);
                }
            }
            hddid.Value = "0";
            chkActive.Checked = false;
            txtTen.Focus();
        }
        private void FillThutu(int iCount)
        {
            dropthutu.Items.Clear();
            if (iCount > 0)
            {
                for (int i = 1; i <= iCount; i++)
                {
                    dropthutu.Items.Add(new ListItem(i.ToString(), i.ToString()));
                }
                dropthutu.SelectedIndex = iCount - 1;
            }
            else
            {
                dropthutu.Items.Add(new ListItem("1", "1"));
            }
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            try
            {
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
                {
                    DM_QHPL_TK item = (DM_QHPL_TK)e.Item.DataItem;
                    DropDownList DropThuTuChildren = (DropDownList)e.Item.FindControl("DropThuTuChildren");
                    decimal ParentID = Convert.ToDecimal(item.PARENT_ID), countItem = 0;
                    List<DM_QHPL_TK> lst = dt.DM_QHPL_TK.Where(x => x.PARENT_ID == ParentID).ToList();
                    if (lst != null && lst.Count > 0)
                    {
                        countItem = lst.Count;
                        for (int i = 1; i <= countItem; i++)
                        {
                            DropThuTuChildren.Items.Add(new ListItem(i.ToString(), i.ToString()));
                        }
                    }
                    if (countItem <= item.ORDERS)
                    {
                        DropThuTuChildren.SelectedValue = countItem.ToString();
                    }
                    else
                    {
                        DropThuTuChildren.SelectedValue = item.ORDERS.ToString();
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
            List<DM_QHPL_TK> obj = dt.DM_QHPL_TK.Where(x => x.PARENT_ID == id).ToList();
            if (obj != null && obj.Count > 0)
            {
                lbthongbao.Text = "Không xóa được vì có QHPL cấp dưới!";
            }
            else
            {
                DM_QHPL_TK dmHanhChinh = dt.DM_QHPL_TK.Where(x => x.ID == id).FirstOrDefault();
                if (dmHanhChinh != null)
                {
                    dt.DM_QHPL_TK.Remove(dmHanhChinh);
                    dt.SaveChanges();
                    List<DM_QHPL_TK> lst = dt.DM_QHPL_TK.Where(x => x.PARENT_ID == dmHanhChinh.PARENT_ID).OrderBy(y => y.ORDERS).ToList();
                    if (lst.Count != 0 && lst != null)
                    {
                        dgList.CurrentPageIndex = 0;
                        hddPageIndex.Value = "1";
                        LoadListChildren(Convert.ToString(dmHanhChinh.PARENT_ID), txttimkiem.Text);
                    }
                    else
                    {
                        pndata.Visible = false;
                    }
                    EditNode(dmHanhChinh.CASE_NAME, "", 0, DEL);
                    LoadDropParent();
                    lbthongbao.Text = "Xóa thành công!";
                }
            }
        }
        public void loadedit(int ID)
        {
            DM_QHPL_TK dmHanhChinh = dt.DM_QHPL_TK.Where(x => x.ID == ID).FirstOrDefault();
            if (dmHanhChinh != null)
            {
                if(dmHanhChinh.CONGBO_CASE_ID != null)
                {
                    ddlQHPL_CONGBO.SelectedValue = dmHanhChinh.CONGBO_CASE_ID.ToString();
                }
                else
                {
                    ddlQHPL_CONGBO.SelectedIndex = 0;
                }

                txtTen.Text = dmHanhChinh.CASE_NAME;
                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                LoadListChildren(ID.ToString(), txttimkiem.Text);
                dropParent.SelectedValue = Convert.ToString(dmHanhChinh.PARENT_ID);
                FillThutu(GetListHanhChinhByID(dropParent.SelectedValue).Count);
                if (dmHanhChinh.ORDERS <= dropthutu.Items.Count)
                    dropthutu.SelectedValue = Convert.ToString(dmHanhChinh.ORDERS);
                else
                    dropthutu.SelectedIndex = dropthutu.Items.Count - 1;
                chkActive.Checked = dmHanhChinh.ENABLE == 0 ? false : true;
                cmdDel.Enabled = true;
            }
            else
            {
                txtTen.Text = "";
                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                LoadListChildren(ID.ToString(), txttimkiem.Text);
            }
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            try
            {
                int HanhChinhID = Convert.ToInt32(e.CommandArgument.ToString());
                lbthongbao.Text = "";
                switch (e.CommandName)
                {
                    case "Sua":
                        loadedit(HanhChinhID);
                        hddid.Value = e.CommandArgument.ToString();
                        break;
                    case "Xoa":
                        // chỉ load lại danh sách các control phía trên giữ nguyên
                        string dropParentValue = "0";
                        if (dropParent.SelectedIndex != 0)
                        {
                            dropParentValue = dropParent.SelectedValue;
                        }
                        xoa(HanhChinhID);
                        if (dropParentValue != "0")
                        {
                            dropParent.SelectedValue = dropParentValue;
                        }
                        break;
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        public void LoadListChildren(string capchaid, string txtKey)
        {
            txtKey = txtKey.Trim().ToLower();
            decimal LoaiAn = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
            int ParentID = Convert.ToInt32(capchaid), countItem = 0, pageSize = Convert.ToInt32(hddPageSize.Value), pageIndex = Convert.ToInt32(hddPageIndex.Value);
            List<DM_QHPL_TK> lst = dt.DM_QHPL_TK.Where(x => x.PARENT_ID == ParentID && x.STYLES== LoaiAn &&  x.CASE_NAME.ToLower().Contains(txtKey)).OrderBy(x => x.ORDERS).ToList();
            if (lst != null && lst.Count > 0)
            {
                countItem = lst.Count;
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(countItem, pageSize).ToString();
                int pageSkip = (pageIndex - 1) * pageSize;
                dgList.PageSize = pageSize;
                dgList.DataSource = lst.Skip(pageSkip).Take(pageSize).ToList<DM_QHPL_TK>();
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
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadListChildren(hddid.Value, txttimkiem.Text);
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadListChildren(hddid.Value, txttimkiem.Text);
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadListChildren(hddid.Value, txttimkiem.Text.Trim());
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadListChildren(hddid.Value, txttimkiem.Text);
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                hddPageIndex.Value = lbCurrent.Text;
                LoadListChildren(hddid.Value, txttimkiem.Text);
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #endregion

        
        protected void ddlLoaiAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadTreeview();
            reSetControl();
            LoadDropParent();
            LoadDrop_QHPL_CONGBO();
        }
        protected void dropParent_SelectedIndexChanged(object sender, EventArgs e)
        {
            try { FillThutu(GetListHanhChinhByID(dropParent.SelectedValue).Count + 1); } catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private bool ValidateForm(decimal HanhChinhID, string Ten)
        {
           
            int lengthTen = txtTen.Text.Trim().Length;
            if (lengthTen <= 0 || lengthTen > 250)
            {
                lbthongbao.Text = "Tên QHPL không được trống hoặc quá 250 ký tự!";
                return false;
            }
            DM_QHPL_TK dmHanhChinhCheck = dt.DM_QHPL_TK.Where(x => x.CASE_NAME.ToLower() == Ten.ToLower()).FirstOrDefault<DM_QHPL_TK>();
            if (dmHanhChinhCheck != null)
            {
                if (dmHanhChinhCheck.ID != HanhChinhID)
                {
                    lbthongbao.Text = "Tên QHPL này đã tồn tại. Hãy nhập lại!";
                    txtTen.Focus();
                    return false;
                }
            }
            // QHPL cấp trên không thể là chính nó hoặc là QHPL cấp dưới của nó
            if (hddid.Value != "0")
            {
                if (dropParent.SelectedValue == hddid.Value)
                {
                    lbthongbao.Text = "QHPL cấp trên không thể là chính nó. Hãy chọn lại!";
                    return false;
                }
                if (dropParent.SelectedValue != "0")
                {
                    DM_QHPL_TK HanhChinh = dt.DM_QHPL_TK.Where(x => x.ID == HanhChinhID).FirstOrDefault<DM_QHPL_TK>();
                    if (HanhChinh != null)
                    {
                        string arrSapXep = HanhChinh.ARRSAPXEP + "/";
                        decimal pHanhChinhID = Convert.ToDecimal(dropParent.SelectedValue);
                        DM_QHPL_TK PHanhChinh = dt.DM_QHPL_TK.Where(x => x.ID == pHanhChinhID).FirstOrDefault<DM_QHPL_TK>();
                        if (PHanhChinh != null)
                        {
                            string pArrSapXep = PHanhChinh.ARRSAPXEP;
                            if (!arrSapXep.Contains(pArrSapXep))
                            {
                                lbthongbao.Text = "QHPL cấp trên không thể là QHPL cấp dưới của nó. Hãy chọn lại!";
                                return false;
                            }
                        }
                    }
                }
            }
            return true;
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
        protected void Btntimkiem_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                LoadListChildren(hddid.Value, txttimkiem.Text);
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
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
            decimal LoaiAN = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
            List<DM_QHPL_TK> listchild = dt.DM_QHPL_TK.Where(x => x.PARENT_ID == pID &&x.STYLES== LoaiAN).OrderBy(y => y.ORDERS).ToList();
            if (listchild != null && listchild.Count > 0)
            {
                foreach (DM_QHPL_TK child in listchild)
                {
                    dropParent.Items.Add(new ListItem(dept + child.CASE_NAME, child.ID.ToString()));
                    LoadDropParentListChild(child.ID, PUBLIC_DEPT + dept);
                }
            }
        }
        private void LoadDrop_QHPL_CONGBO()
        {
            int CASES_STYLES = -1;
            switch (ddlLoaiAn.SelectedItem.ToString())
            {
                case "Hình sự": CASES_STYLES = 50; break;
                case "Dân sự": CASES_STYLES = 0; break;
                case "Hôn nhân & Gia đình": CASES_STYLES = 1; break;
                case "Kinh doanh & Thương mại": CASES_STYLES = 2; break;
                case "Lao động": CASES_STYLES = 3; break;
                case "Hành chính": CASES_STYLES = 4; break;
                case "Phá sản": CASES_STYLES = 5; break;
            }

            CONGBO_BL TK_BL = new CONGBO_BL();
            DataTable tbl = TK_BL.DBLINK_GET_LIST_TC_CASES_LIST_FULL(CASES_STYLES.ToString());
            ddlQHPL_CONGBO.DataSource = tbl;
            ddlQHPL_CONGBO.DataTextField = "CASE_NAME";
            ddlQHPL_CONGBO.DataValueField = "ID";
            ddlQHPL_CONGBO.DataBind();
            ddlQHPL_CONGBO.Items.Insert(0, new ListItem(" -- Chọn QHPL -- ", "0"));
        }
    }
}