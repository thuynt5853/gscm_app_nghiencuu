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

namespace WEB.GSTP.Danhmuc.VienKiemSat
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
                    LoadDropLoaiVKS();
                    hddPageIndex.Value = "1";
                    LoadListChildren(ROOT.ToString(), txttimkiem.Text);
                    FillThutu(GetListVKSByParentID(ROOT.ToString()).Count + 1);
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(btnNew, oPer.TAOMOI);
                    Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                    Cls_Comon.SetButton(cmdDel, oPer.XOA);

                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        public void LoadDropLoaiVKS()
        {
            dropLoaiVKS.Items.Clear();
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable dmLoaiVKS = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.LOAIVIENKIEMSOAT);
            if (dmLoaiVKS != null && dmLoaiVKS.Rows.Count > 0)
            {
                dropLoaiVKS.DataSource = dmLoaiVKS;
                dropLoaiVKS.DataTextField = "TEN";
                dropLoaiVKS.DataValueField = "MA";
                dropLoaiVKS.DataBind();
            }
            else
            {
                dropLoaiVKS.Items.Add(new ListItem("Chọn", "0"));
            }
        }
        public void LoadTreeview()
        {
            treemenu.Nodes.Clear();
            TreeNode oRoot = new TreeNode("Danh mục viện kiểm soát", ROOT.ToString());
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
            decimal nID = Convert.ToDecimal(root.Value);
            List<DM_VKS> listchild = dt.DM_VKS.Where(x => x.CAPCHAID == nID).OrderBy(y => y.THUTU).ToList();
            if (listchild != null && listchild.Count > 0)
            {
                foreach (DM_VKS child in listchild)
                {
                    TreeNode nodechild;
                    nodechild = CreateNode(child.ID.ToString(), child.TEN.ToString());
                    root.ChildNodes.Add(nodechild);
                    LoadTreeChild(nodechild, PUBLIC_DEPT + dept);
                    root.CollapseAll();
                }
            }
        }
        public List<DM_VKS> GetListVKSByParentID(string chaid)
        {
            int ID = Convert.ToInt32(chaid);
            return dt.DM_VKS.Where(x => x.CAPCHAID == ID).ToList();
        }
        protected void btnNew_Click(object sender, EventArgs e)
        {
            try
            {
                reSetControl();
                if (treemenu.SelectedNode != null)
                {
                    dropParent.SelectedValue = treemenu.SelectedValue;
                    FillThutu(GetListVKSByParentID(treemenu.SelectedValue).Count + 1);
                }
                else
                {
                    dropParent.SelectedValue = "0";
                    FillThutu(GetListVKSByParentID("0").Count + 1);
                }
                hddVKSID.Value = "0";
                cmdDel.Enabled = true;
                cmdUpdate.Enabled = true;
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                decimal vKSID = Convert.ToDecimal(hddVKSID.Value), ParentID = Convert.ToDecimal(dropParent.SelectedValue);
                int thuTu = Convert.ToInt32(dropThuTu.SelectedValue), action = UPDATE;
                string Ten = txtTen.Text.Trim(), nodeName = "";
                if (!ValidateForm(vKSID, Ten))
                {
                    return;
                }
                bool isNew = false;
                DM_VKS vKS = dt.DM_VKS.Where(x => x.ID == vKSID).FirstOrDefault<DM_VKS>();
                if (vKS == null)
                {
                    isNew = true;
                    vKS = new DM_VKS();
                    vKS.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                    vKS.NGAYTAO = DateTime.Now;
                    nodeName = dropParent.SelectedItem.Text;
                }
                else
                {
                    vKS.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                    vKS.NGAYSUA = DateTime.Now;
                    nodeName = vKS.TEN;
                }
                vKS.CAPCHAID = ParentID;
                vKS.MA = txtMa.Text.Trim();
                vKS.TEN = Ten;
                vKS.CAPCHAID = Convert.ToDecimal(dropParent.SelectedValue);
                vKS.LOAIVKS = dropLoaiVKS.SelectedValue;
                vKS.HANHCHINHID = hddDonViHanhChinh.Value == "" ? 0 : Convert.ToDecimal(hddDonViHanhChinh.Value);
                vKS.TOAANID = hddToaAnTuongUng.Value == "" ? 0 : Convert.ToDecimal(hddToaAnTuongUng.Value);
                vKS.SOCAP = GetLevel(ParentID) + 1;
                vKS.HIEULUC = (chkActive.Checked) ? Convert.ToDecimal(1) : Convert.ToDecimal(0);
                vKS.THUTU = thuTu;
                if (isNew)
                {
                    dt.DM_VKS.Add(vKS);
                    action = ADD;
                }
                dt.SaveChanges();
                #region Lưu ArrSapXep và ArrThuTu
                string strArrSapXep = "", strArrThuTu = "", strTen = "";
                DM_VKS vKSParent = dt.DM_VKS.Where(x => x.ID == ParentID).FirstOrDefault<DM_VKS>();
                if (vKSParent == null)
                {
                    strTen = vKS.TEN;
                    strArrSapXep = "0/" + vKS.ID;
                    if (thuTu < 10)
                    {
                        strArrThuTu = "0" + "/" + dropThuTu.SelectedValue + "00";
                    }
                    else
                    {
                        strArrThuTu = "0" + "/9" + dropThuTu.SelectedValue;
                    }
                }
                else
                {
                    string[] arrMaTen = vKSParent.MA_TEN.Split('-');
                    strTen = vKS.TEN + ", " + arrMaTen[1].Trim();
                    strArrSapXep = vKSParent.ARRSAPXEP + "/" + vKS.ID;
                    if (thuTu < 10)
                    {
                        strArrThuTu = vKSParent.ARRTHUTU + "/" + dropThuTu.SelectedValue + "00";
                    }
                    else
                    {
                        strArrThuTu = vKSParent.ARRTHUTU + "/9" + dropThuTu.SelectedValue;
                    }
                }
                vKS.MA_TEN = vKS.MA + " - " + strTen;
                vKS.ARRSAPXEP = strArrSapXep; vKS.ARRTHUTU = strArrThuTu;
                dt.SaveChanges();
                #endregion
                vKSID = vKS.ID;
                EditNode(nodeName.Replace(".", ""), Ten.Replace(".", ""), vKSID, action);
                // Nếu là sửa thì kiểm tra đơn vị sửa có đơn vị con hay không. Nếu có phải update lại ArrSapXep và ArrThuTu
                if (!isNew)
                {
                    List<DM_VKS> lst = GetListVKSByParentID(vKS.ID.ToString());
                    if (lst != null && lst.Count > 0)
                    {
                        UpdateChildren(lst, strArrThuTu, strArrSapXep, vKS.MA_TEN, Convert.ToInt32(vKS.SOCAP));
                    }
                }
                LoadDropParent();
                hddPageIndex.Value = "1";
                LoadListChildren(ParentID.ToString(), txttimkiem.Text);
                FillThutu(GetListVKSByParentID(ParentID.ToString()).Count + 1);
                reSetControl();
                lbthongbao.Text = "Lưu thành công!";
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private void UpdateChildren(List<DM_VKS> lst, string ParrThuTu, string ParrSapXep, string MaTen, int SoCap)
        {
            string[] arrStr = MaTen.Split('-');
            string Ten = arrStr[1].ToString().Trim();
            foreach (DM_VKS item in lst)
            {
                item.MA_TEN = item.MA + " - " + item.TEN + ", " + Ten;
                item.ARRSAPXEP = ParrSapXep + "/" + item.ID;
                if (item.THUTU < 10)
                {
                    item.ARRTHUTU = ParrThuTu + "/" + item.THUTU + "00";
                }
                else
                {
                    item.ARRTHUTU = ParrThuTu + "/9" + item.THUTU;
                }
                item.SOCAP = SoCap + 1;
                dt.SaveChanges();
                List<DM_VKS> lstChild = GetListVKSByParentID(item.ID.ToString());
                if (lstChild != null && lstChild.Count > 0)
                {
                    UpdateChildren(lstChild, item.ARRTHUTU, item.ARRSAPXEP, item.MA_TEN, Convert.ToInt32(item.SOCAP));
                }
            }
        }
        private void UpdateChildren(List<DM_VKS> lst, string ParrThuTu)
        {
            foreach (DM_VKS item in lst)
            {
                if (item.THUTU < 10)
                {
                    item.ARRTHUTU = ParrThuTu + "/" + item.THUTU + "00";
                }
                else
                {
                    item.ARRTHUTU = ParrThuTu + "/9" + item.THUTU;
                }
                dt.SaveChanges();
                List<DM_VKS> lstChild = GetListVKSByParentID(item.ID.ToString());
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
                DM_VKS dv = dt.DM_VKS.Where(x => x.ID == dvID).FirstOrDefault<DM_VKS>();
                if (dv != null)
                {
                    level = (int)dv.SOCAP;
                }
            }
            return level;
        }
        protected void btnDel_Click(object sender, EventArgs e)
        {
            try
            {
                if (hddVKSID.Value != "0")
                {
                    List<DM_VKS> lst = GetListVKSByParentID(hddVKSID.Value);
                    if (lst != null && lst.Count > 0)
                    {
                        lbthongbao.Text = "Không xóa được vì có viện kiểm soát cấp dưới!";
                    }
                    else
                    {
                        int vKSID = Convert.ToInt32(hddVKSID.Value);
                        Xoa(vKSID);
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
                decimal vKSID = Convert.ToDecimal(dgList.Items[0].Cells[0].Text);
                DM_VKS vKS = dt.DM_VKS.Where(x => x.ID == vKSID).FirstOrDefault<DM_VKS>();
                if (vKS != null)
                {
                    parentID = vKS.CAPCHAID.ToString();
                    DM_VKS ParentDMVKS = dt.DM_VKS.Where(x => x.ID == vKS.CAPCHAID).FirstOrDefault<DM_VKS>();
                    if (ParentDMVKS != null)
                    {
                        strArrThuTuParent = ParentDMVKS.ARRTHUTU;
                    }
                    else
                    {
                        strArrThuTuParent = "0";
                    }
                }
                int vKSColIndex = 0;
                foreach (DataGridItem oItem in dgList.Items)
                {
                    vKSID = Convert.ToDecimal(oItem.Cells[vKSColIndex].Text);
                    vKS = dt.DM_VKS.Where(x => x.ID == vKSID).FirstOrDefault<DM_VKS>();
                    DropDownList dropThuTu = (DropDownList)oItem.FindControl("DropThuTuChildren");
                    vKS.THUTU = Convert.ToInt32(dropThuTu.SelectedValue);
                    if (vKS.THUTU < 10)
                    {
                        vKS.ARRTHUTU = strArrThuTuParent + "/" + dropThuTu.SelectedValue + "00";
                    }
                    else
                    {
                        vKS.ARRTHUTU = strArrThuTuParent + "/9" + dropThuTu.SelectedValue;
                    }
                    vKS.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                    vKS.NGAYSUA = DateTime.Now;
                    dt.SaveChanges();
                    List<DM_VKS> lst = GetListVKSByParentID(oItem.Cells[vKSColIndex].Text);
                    if (lst.Count > 0)
                    {
                        UpdateChildren(lst, vKS.ARRTHUTU);
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
                lbthongbao.Text = ""; hddVKSID.Value = treemenu.SelectedValue;
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
            txtMa.Text = txtTen.Text = txtDonViHanhChinh.Text = txtToaAn.Text = "";
            dropParent.SelectedIndex = 0;
            dropLoaiVKS.SelectedIndex = 0;
            hddDonViHanhChinh.Value = hddToaAnTuongUng.Value = "0";
            if (hddVKSID.Value != "0")
            {
                decimal hcID = Convert.ToDecimal(hddVKSID.Value);
                DM_VKS dmHanhChinh = dt.DM_VKS.Where(x => x.ID == hcID).FirstOrDefault<DM_VKS>();
                if (dmHanhChinh != null)
                {
                    FillThutu(GetListVKSByParentID(Convert.ToString(dmHanhChinh.CAPCHAID)).Count + 1);
                }
            }
            chkActive.Checked = false;
            hddVKSID.Value = "0";
            txtMa.Focus();
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
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            try
            {
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
                {
                    DM_VKS item = (DM_VKS)e.Item.DataItem;
                    DropDownList dropThuTuChildren = (DropDownList)e.Item.FindControl("dropThuTuChildren");
                    decimal ParentID = Convert.ToDecimal(item.CAPCHAID), countItem = 0;
                    List<DM_VKS> lst = dt.DM_VKS.Where(x => x.CAPCHAID == ParentID).ToList();
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
        public void Xoa(int id)
        {
            List<DM_VKS> obj = dt.DM_VKS.Where(x => x.CAPCHAID == id).ToList();
            if (obj != null && obj.Count > 0)
            {
                lbthongbao.Text = "Không xóa được vì có đơn vị cấp dưới!";
            }
            else
            {
                DM_VKS vKS = dt.DM_VKS.Where(x => x.ID == id).FirstOrDefault();
                if (vKS != null)
                {
                    dt.DM_VKS.Remove(vKS);
                    dt.SaveChanges();
                    List<DM_VKS> lst = dt.DM_VKS.Where(x => x.CAPCHAID == vKS.CAPCHAID).OrderBy(y => y.THUTU).ToList();
                    if (lst.Count != 0 && lst != null)
                    {
                        hddPageIndex.Value = "1";
                        LoadListChildren(Convert.ToString(vKS.CAPCHAID), txttimkiem.Text);
                    }
                    else
                    {
                        pndata.Visible = false;
                    }
                    EditNode(vKS.TEN, "", 0, DEL);
                    LoadDropParent();
                    lbthongbao.Text = "Xóa thành công!";
                }
            }
        }
        public void loadedit(int ID)
        {
            DM_VKS vKS = dt.DM_VKS.Where(x => x.ID == ID).FirstOrDefault();
            if (vKS != null)
            {
                txtMa.Text = vKS.MA;
                txtTen.Text = vKS.TEN;
                hddPageIndex.Value = "1";
                LoadListChildren(ID.ToString(), txttimkiem.Text);
                dropParent.SelectedValue = Convert.ToString(vKS.CAPCHAID);
                FillThutu(GetListVKSByParentID(dropParent.SelectedValue).Count);
                if (vKS.THUTU <= dropThuTu.Items.Count)
                    dropThuTu.SelectedValue = Convert.ToString(vKS.THUTU);
                else
                    dropThuTu.SelectedIndex = dropThuTu.Items.Count - 1;
                dropLoaiVKS.SelectedValue = vKS.LOAIVKS;
                if (vKS.HANHCHINHID != 0)
                {
                    DM_VKS_BL vKSbl = new DM_VKS_BL();
                    txtDonViHanhChinh.Text = vKSbl.GetTextByID(Convert.ToDecimal(vKS.HANHCHINHID));
                    hddDonViHanhChinh.Value = vKS.HANHCHINHID.ToString();
                }
                else
                {
                    txtDonViHanhChinh.Text = "";
                    hddDonViHanhChinh.Value = "0";
                }
                if (vKS.TOAANID != 0)
                {
                    DM_TOAAN dM_TOAAN = dt.DM_TOAAN.Where(x => x.ID == vKS.TOAANID).FirstOrDefault<DM_TOAAN>();
                    if (dM_TOAAN != null)
                    {
                        txtToaAn.Text = dM_TOAAN.TEN;
                        hddToaAnTuongUng.Value = vKS.TOAANID.ToString();
                    }
                    else
                    {
                        txtToaAn.Text = "";
                        hddToaAnTuongUng.Value = "0";
                    }
                }
                else
                {
                    txtToaAn.Text = "";
                    hddToaAnTuongUng.Value = "0";
                }
                chkActive.Checked = vKS.HIEULUC == 0 ? false : true;
                cmdDel.Enabled = true;
            }
            else
            {
                txtTen.Text = txtMa.Text = "";
                hddPageIndex.Value = "1";
                LoadListChildren(ID.ToString(), txttimkiem.Text);
            }
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            try
            {
                int vKSID = Convert.ToInt32(e.CommandArgument.ToString());
                lbthongbao.Text = "";
                switch (e.CommandName)
                {
                    case "Sua":
                        loadedit(vKSID);
                        hddVKSID.Value = e.CommandArgument.ToString();
                        break;
                    case "Xoa":
                        // chỉ load lại danh sách các control phía trên giữ nguyên
                        string dropParentValue = "0";
                        if (dropParent.SelectedIndex != 0)
                        {
                            dropParentValue = dropParent.SelectedValue;
                        }
                        Xoa(vKSID);
                        if (dropParentValue != "0")
                        {
                            dropParent.SelectedValue = dropParentValue;
                        }
                        break;
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        public void LoadListChildren(string capchaid, string textKey)
        {
            int ParentID = Convert.ToInt32(capchaid), countItem = 0, pageSize = Convert.ToInt32(hddPageSize.Value), pageIndex = Convert.ToInt32(hddPageIndex.Value);
            textKey = textKey.Trim().ToLower();
            List<DM_VKS> lst = dt.DM_VKS.Where(x => x.CAPCHAID == ParentID && (x.MA.ToLower().Contains(textKey) || x.TEN.ToLower().Contains(textKey))).OrderBy(x => x.ARRTHUTU).ToList();
            if (lst != null && lst.Count > 0)
            {
                countItem = lst.Count;
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(countItem, pageSize).ToString();
                int pageSkip = (pageIndex - 1) * pageSize;
                dgList.DataSource = lst.Skip(pageSkip).Take(pageSize).ToList<DM_VKS>();
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
                LoadListChildren(hddVKSID.Value, txttimkiem.Text);
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadListChildren(hddVKSID.Value, txttimkiem.Text);
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadListChildren(hddVKSID.Value, txttimkiem.Text);
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadListChildren(hddVKSID.Value, txttimkiem.Text);
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                hddPageIndex.Value = lbCurrent.Text;
                LoadListChildren(hddVKSID.Value, txttimkiem.Text);
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #endregion
        protected void dropParent_SelectedIndexChanged(object sender, EventArgs e)
        {
            try { FillThutu(GetListVKSByParentID(dropParent.SelectedValue).Count + 1); } catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private bool ValidateForm(decimal HanhChinhID, string Ten)
        {
            int lengthMa = txtMa.Text.Trim().Length;
            if (lengthMa <= 0 || lengthMa > 50)
            {
                lbthongbao.Text = "Mã viện kiểm soát không được trống hoặc quá 50 ký tự!";
                return false;
            }
            int lengthTen = txtTen.Text.Trim().Length;
            if (lengthTen <= 0 || lengthTen > 250)
            {
                lbthongbao.Text = "Tên viện kiểm soát không được trống hoặc quá 250 ký tự!";
                return false;
            }
            DM_VKS vKSCheck = dt.DM_VKS.Where(x => x.TEN.ToLower() == Ten.ToLower()).FirstOrDefault<DM_VKS>();
            if (vKSCheck != null)
            {
                if (vKSCheck.ID != HanhChinhID)
                {
                    lbthongbao.Text = "Tên viện kiểm soát này đã tồn tại. Hãy nhập lại!";
                    txtTen.Focus();
                    return false;
                }
            }
            // Đơn vị cấp trên không thể là chính nó hoặc là đơn vị cấp dưới của nó
            if (hddVKSID.Value != "0")
            {
                if (dropParent.SelectedValue == hddVKSID.Value)
                {
                    lbthongbao.Text = "Viện kiểm soát cấp trên không thể là chính nó. Hãy chọn lại!";
                    return false;
                }
                if (dropParent.SelectedValue != "0")
                {
                    DM_VKS vKS = dt.DM_VKS.Where(x => x.ID == HanhChinhID).FirstOrDefault<DM_VKS>();
                    if (vKS != null)
                    {
                        string arrSapXep = vKS.ARRSAPXEP + "/";
                        decimal vKSPID = Convert.ToDecimal(dropParent.SelectedValue);
                        DM_VKS vKSP = dt.DM_VKS.Where(x => x.ID == vKSPID).FirstOrDefault<DM_VKS>();
                        if (vKSP != null)
                        {
                            string pArrSapXep = vKSP.ARRSAPXEP;
                            if (!arrSapXep.Contains(pArrSapXep))
                            {
                                lbthongbao.Text = "Viện kiểm soát cấp trên không thể là viện kiểm soát cấp dưới của nó. Hãy chọn lại!";
                                return false;
                            }
                        }
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
                LoadListChildren(hddVKSID.Value, txttimkiem.Text);
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
            List<DM_VKS> listchild = dt.DM_VKS.Where(x => x.CAPCHAID == pID).OrderBy(y => y.THUTU).ToList();
            if (listchild != null && listchild.Count > 0)
            {
                foreach (DM_VKS child in listchild)
                {
                    dropParent.Items.Add(new ListItem(dept + child.TEN, child.ID.ToString()));
                    LoadDropParentListChild(child.ID, PUBLIC_DEPT + dept);
                }
            }
        }

    }
}