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
using BL.GSTP.Quantri;

namespace WEB.GSTP.QTCucTHA.DVTHA
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
                    LoadDropParent();
                    LoadDropLoaiToaAn();
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
        public void LoadDropLoaiToaAn()
        {
            dropLoaiToaAn.Items.Clear();
            QT_TUPHAP_BL oBL = new QT_TUPHAP_BL();
            DataTable dmLoaiVKS = oBL.DM_DATAITEM_GETBYGROUPNAME_THADS(ENUM_DANHMUC.LOAITOA);
            if (dmLoaiVKS != null && dmLoaiVKS.Rows.Count > 0)
            {
                dropLoaiToaAn.DataSource = dmLoaiVKS;
                dropLoaiToaAn.DataTextField = "TEN";
                dropLoaiToaAn.DataValueField = "MA";
                dropLoaiToaAn.DataBind();
            }
            else
            {
                dropLoaiToaAn.Items.Add(new ListItem("Chọn", "0"));
            }
        }
        public void LoadTreeview()
        {
            treemenu.Nodes.Clear();
            TreeNode oRoot = new TreeNode("Danh mục thi hành án dân sự", ROOT.ToString());
            treemenu.Nodes.Add(oRoot);
            LoadTreeChild(oRoot, "");
            treemenu.Nodes[ROOT].Expand();
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
            List<DM_DONVITHIHANHAN> listchild = dt.DM_DONVITHIHANHAN.Where(x => x.CAPCHAID == nID).OrderBy(y => y.THUTU).ToList();
            if (listchild != null && listchild.Count > 0)
            {
                foreach (DM_DONVITHIHANHAN child in listchild)
                {
                    TreeNode nodechild;
                    nodechild = CreateNode(child.ID.ToString(), child.TEN.ToString());
                    root.ChildNodes.Add(nodechild);
                    LoadTreeChild(nodechild, PUBLIC_DEPT + dept);
                    root.CollapseAll();
                }
            }
        }
        public List<DM_DONVITHIHANHAN> GetListToaAnByParentID(string chaid)
        {
            int ID = Convert.ToInt32(chaid);
            return dt.DM_DONVITHIHANHAN.Where(x => x.CAPCHAID == ID).ToList();
        }
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
                decimal toaAnID = Convert.ToDecimal(hddToaAnID.Value), ParentID = Convert.ToDecimal(dropParent.SelectedValue);
                int thuTu = Convert.ToInt32(dropThuTu.SelectedValue), action = UPDATE;
                string Ten = txtTen.Text.Trim(), nodeName = "";
                if (!ValidateForm(toaAnID, Ten))
                {
                    return;
                }
                bool isNew = false;
                DM_DONVITHIHANHAN toaAn = dt.DM_DONVITHIHANHAN.Where(x => x.ID == toaAnID).FirstOrDefault<DM_DONVITHIHANHAN>();
                if (toaAn == null)
                {
                    isNew = true;
                    toaAn = new DM_DONVITHIHANHAN();
                    toaAn.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                    toaAn.NGAYTAO = DateTime.Now;
                    nodeName = dropParent.SelectedItem.Text;
                }
                else
                {
                    toaAn.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                    toaAn.NGAYSUA = DateTime.Now;
                    nodeName = toaAn.TEN;
                }
                toaAn.CAPCHAID = ParentID;
                toaAn.MA = txtMa.Text.Trim();
                toaAn.TEN = Ten;
                toaAn.LOAITOA = dropLoaiToaAn.SelectedValue;
                toaAn.HANHCHINHID = hddDonViHanhChinh.Value == "" ? 0 : Convert.ToDecimal(hddDonViHanhChinh.Value);
                toaAn.DIACHI = txtDiaChi.Text.Trim();
                toaAn.DIENTHOAI = txtDienThoai.Text.Trim();
                toaAn.FAX = txtFax.Text.Trim();
                toaAn.EMAIL = txtEmail.Text.Trim();
                toaAn.SOCAP = GetLevel(ParentID) + 1;
                toaAn.HIEULUC = (chkActive.Checked) ? Convert.ToDecimal(1) : Convert.ToDecimal(0);
                toaAn.THUTU = thuTu;
                toaAn.TENCOQUANTHA = txtTenCQTHA.Text;
                toaAn.DIACHICOQUANTHA = txtDiachiCQTHA.Text;
                toaAn.NHANDKKONLINE = Convert.ToDecimal(rdNhanDKKOnline.SelectedValue + "");
                if (isNew)
                {
                    dt.DM_DONVITHIHANHAN.Add(toaAn);
                    action = ADD;
                }
                dt.SaveChanges();
                #region Lưu ArrSapXep và ArrThuTu
                string strArrSapXep = "", strArrThuTu = "", strTen = "";
                DM_DONVITHIHANHAN toaAnParent = dt.DM_DONVITHIHANHAN.Where(x => x.ID == ParentID).FirstOrDefault<DM_DONVITHIHANHAN>();
                if (toaAnParent == null)
                {
                    strTen = toaAn.TEN;
                    strArrSapXep = "0/" + toaAn.ID;
                    if (thuTu < 10)
                    {
                        strArrThuTu = "0" + "/" + dropThuTu.SelectedValue + "00";
                    }
                    else
                    {
                        strArrThuTu = "0" + "/9" + dropThuTu.SelectedValue;
                    }
                    toaAn.MA_TEN = toaAn.TEN;
                }
                else
                {

                    strArrSapXep = toaAnParent.ARRSAPXEP + "/" + toaAn.ID;
                    if (thuTu < 10)
                    {
                        strArrThuTu = toaAnParent.ARRTHUTU + "/" + dropThuTu.SelectedValue + "00";
                    }
                    else
                    {
                        strArrThuTu = toaAnParent.ARRTHUTU + "/9" + dropThuTu.SelectedValue;
                    }
                    if (toaAn.LOAITOA == "CAPHUYEN" || toaAn.LOAITOA == "QSKHUVUC")
                        toaAn.MA_TEN = toaAn.TEN + "," + toaAnParent.TEN.Replace("Cục Thi hành án", "");
                    else
                        toaAn.MA_TEN = toaAn.TEN;
                  
                }

                toaAn.ARRSAPXEP = strArrSapXep; toaAn.ARRTHUTU = strArrThuTu;
                dt.SaveChanges();
                #endregion
                toaAnID = toaAn.ID;
                EditNode(nodeName.Replace(".", ""), Ten.Replace(".", ""), toaAnID, action);
                // Nếu là sửa thì kiểm tra đơn vị sửa có đơn vị con hay không. Nếu có phải update lại ArrSapXep và ArrThuTu
                if (!isNew)
                {
                    List<DM_DONVITHIHANHAN> lst = GetListToaAnByParentID(toaAn.ID.ToString());
                    if (lst != null && lst.Count > 0)
                    {
                        UpdateChildren(lst, strArrThuTu, strArrSapXep, toaAn.MA_TEN, Convert.ToInt32(toaAn.SOCAP));
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
        private void UpdateChildren(List<DM_DONVITHIHANHAN> lst, string ParrThuTu, string ParrSapXep, string MaTen, int SoCap)
        {
            string Ten = MaTen;
            if (MaTen.Contains("-"))
            {
                string[] arrStr = MaTen.Split('-');
                Ten = arrStr[0].ToString().Trim();
            }
            foreach (DM_DONVITHIHANHAN item in lst)
            {
                if (item.LOAITOA == "CAPHUYEN" || item.LOAITOA == "QSKHUVUC")
                    item.MA_TEN = item.TEN + "," + Ten.Replace("Tòa án nhân dân", "");
                else
                    item.MA_TEN = item.TEN;
                
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
                List<DM_DONVITHIHANHAN> lstChild = GetListToaAnByParentID(item.ID.ToString());
                if (lstChild != null && lstChild.Count > 0)
                {
                    UpdateChildren(lstChild, item.ARRTHUTU, item.ARRSAPXEP, item.MA_TEN, Convert.ToInt32(item.SOCAP));
                }
            }
        }
        private void UpdateChildren(List<DM_DONVITHIHANHAN> lst, string ParrThuTu,string strParentTen)
        {
            foreach (DM_DONVITHIHANHAN item in lst)
            {
                if (item.THUTU < 10)
                {
                    item.ARRTHUTU = ParrThuTu + "/" + item.THUTU + "00";
                }
                else
                {
                    item.ARRTHUTU = ParrThuTu + "/9" + item.THUTU;
                }
                if (item.LOAITOA == "CAPHUYEN" || item.LOAITOA == "QSKHUVUC")
                    item.MA_TEN = item.TEN + "," + strParentTen.Replace("Tòa án nhân dân", "");
                else
                    item.MA_TEN = item.TEN;
                dt.SaveChanges();
                List<DM_DONVITHIHANHAN> lstChild = GetListToaAnByParentID(item.ID.ToString());
                if (lstChild != null && lstChild.Count > 0)
                {
                    UpdateChildren(lstChild, item.ARRTHUTU, item.TEN);
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
                DM_DONVITHIHANHAN dv = dt.DM_DONVITHIHANHAN.Where(x => x.ID == dvID).FirstOrDefault<DM_DONVITHIHANHAN>();
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
                if (hddToaAnID.Value != "0")
                {
                    List<DM_DONVITHIHANHAN> lst = GetListToaAnByParentID(hddToaAnID.Value);
                    if (lst != null && lst.Count > 0)
                    {
                        lbthongbao.Text = "Không xóa được vì có tòa án cấp dưới!";
                    }
                    else
                    {
                        int toaAnID = Convert.ToInt32(hddToaAnID.Value);
                        xoa(toaAnID);
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
                decimal toaAnID = Convert.ToDecimal(dgList.Items[0].Cells[0].Text);
                DM_DONVITHIHANHAN toaAn = dt.DM_DONVITHIHANHAN.Where(x => x.ID == toaAnID).FirstOrDefault<DM_DONVITHIHANHAN>();
                if (toaAn != null)
                {
                    parentID = toaAn.CAPCHAID.ToString();
                    DM_DONVITHIHANHAN ParentDMHanhChinh = dt.DM_DONVITHIHANHAN.Where(x => x.ID == toaAn.CAPCHAID).FirstOrDefault<DM_DONVITHIHANHAN>();
                    if (ParentDMHanhChinh != null)
                    {
                        strArrThuTuParent = ParentDMHanhChinh.ARRTHUTU;
                    }
                    else
                    {
                        strArrThuTuParent = "0";
                    }
                }
                int DMToaAnIDColIndex = 0;
                foreach (DataGridItem oItem in dgList.Items)
                {
                    toaAnID = Convert.ToDecimal(oItem.Cells[DMToaAnIDColIndex].Text);
                    toaAn = dt.DM_DONVITHIHANHAN.Where(x => x.ID == toaAnID).FirstOrDefault<DM_DONVITHIHANHAN>();
                    DropDownList dropThuTu = (DropDownList)oItem.FindControl("DropThuTuChildren");
                    toaAn.THUTU = Convert.ToInt32(dropThuTu.SelectedValue);
                    if (toaAn.THUTU < 10)
                    {
                        toaAn.ARRTHUTU = strArrThuTuParent + "/" + dropThuTu.SelectedValue + "00";
                    }
                    else
                    {
                        toaAn.ARRTHUTU = strArrThuTuParent + "/9" + dropThuTu.SelectedValue;
                    }
                    toaAn.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                    toaAn.NGAYSUA = DateTime.Now;
                    dt.SaveChanges();
                    List<DM_DONVITHIHANHAN> lst = GetListToaAnByParentID(oItem.Cells[DMToaAnIDColIndex].Text);
                    if (lst.Count > 0)
                    {
                        UpdateChildren(lst, toaAn.ARRTHUTU, toaAn.TEN);
                    }
                }
                LoadDropParent();
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
                lbthongbao.Text = ""; hddToaAnID.Value = treemenu.SelectedValue;
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
            txtMa.Text = txtTen.Text = "";
            dropParent.SelectedIndex = 0;
            dropLoaiToaAn.SelectedIndex = 0;
            txtDonViHanhChinh.Text = ""; hddDonViHanhChinh.Value = "0";
            txtDiaChi.Text = txtDienThoai.Text = txtFax.Text = txtEmail.Text=txtTenCQTHA.Text=txtDiachiCQTHA.Text="";
            if (hddToaAnID.Value != "0")
            {
                decimal hcID = Convert.ToDecimal(hddToaAnID.Value);
                DM_DONVITHIHANHAN dmHanhChinh = dt.DM_DONVITHIHANHAN.Where(x => x.ID == hcID).FirstOrDefault<DM_DONVITHIHANHAN>();
                if (dmHanhChinh != null)
                {
                    FillThutu(GetListToaAnByParentID(Convert.ToString(dmHanhChinh.CAPCHAID)).Count + 1);
                }
            }
            chkActive.Checked = false;
            hddToaAnID.Value = "0";
            txtMa.Focus();
            rdNhanDKKOnline.SelectedValue = "0";
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
                    DM_DONVITHIHANHAN item = (DM_DONVITHIHANHAN)e.Item.DataItem;
                    DropDownList dropThuTuChildren = (DropDownList)e.Item.FindControl("dropThuTuChildren");
                    decimal ParentID = Convert.ToDecimal(item.CAPCHAID), countItem = 0;
                    List<DM_DONVITHIHANHAN> lst = dt.DM_DONVITHIHANHAN.Where(x => x.CAPCHAID == ParentID).ToList();
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
            List<DM_DONVITHIHANHAN> obj = dt.DM_DONVITHIHANHAN.Where(x => x.CAPCHAID == id).ToList();
            if (obj != null && obj.Count > 0)
            {
                lbthongbao.Text = "Không xóa được vì có tòa án cấp dưới!";
            }
            else
            {
                DM_DONVITHIHANHAN toaAn = dt.DM_DONVITHIHANHAN.Where(x => x.ID == id).FirstOrDefault();
                if (toaAn != null)
                {
                    dt.DM_DONVITHIHANHAN.Remove(toaAn);
                    dt.SaveChanges();
                    List<DM_DONVITHIHANHAN> lst = dt.DM_DONVITHIHANHAN.Where(x => x.CAPCHAID == toaAn.CAPCHAID).OrderBy(y => y.THUTU).ToList();
                    if (lst.Count != 0 && lst != null)
                    {
                        hddPageIndex.Value = "1";
                        LoadListChildren(Convert.ToString(toaAn.CAPCHAID), txttimkiem.Text);
                    }
                    else
                    {
                        pndata.Visible = false;
                    }
                    EditNode(toaAn.TEN, "", 0, DEL);
                    LoadDropParent();
                    lbthongbao.Text = "Xóa thành công!";
                }
            }
        }
        public void loadedit(int ID)
        {
            DM_DONVITHIHANHAN toaAn = dt.DM_DONVITHIHANHAN.Where(x => x.ID == ID).FirstOrDefault();
            if (toaAn != null)
            {
                txtMa.Text = toaAn.MA;
                txtTen.Text = toaAn.TEN;
                hddPageIndex.Value = "1";
                LoadListChildren(ID.ToString(), txttimkiem.Text);
                dropParent.SelectedValue = Convert.ToString(toaAn.CAPCHAID);
                FillThutu(GetListToaAnByParentID(dropParent.SelectedValue).Count);
                if (toaAn.THUTU <= dropThuTu.Items.Count)
                    dropThuTu.SelectedValue = Convert.ToString(toaAn.THUTU);
                else
                    dropThuTu.SelectedIndex = dropThuTu.Items.Count - 1;
                dropLoaiToaAn.SelectedValue = toaAn.LOAITOA;
                if (toaAn.HANHCHINHID != 0)
                {
                    DM_HANHCHINH_BL hcbl = new DM_HANHCHINH_BL();
                    txtDonViHanhChinh.Text = hcbl.GetTextByID(Convert.ToDecimal(toaAn.HANHCHINHID));
                    hddDonViHanhChinh.Value = toaAn.HANHCHINHID.ToString();
                }
                else
                {
                    txtDonViHanhChinh.Text = "";
                    hddDonViHanhChinh.Value = "0";
                }
                txtDiaChi.Text = toaAn.DIACHI;
                txtDienThoai.Text = toaAn.DIENTHOAI;
                txtFax.Text = toaAn.FAX;
                txtEmail.Text = toaAn.EMAIL;
                 txtTenCQTHA.Text= toaAn.TENCOQUANTHA;
                txtDiachiCQTHA.Text= toaAn.DIACHICOQUANTHA;
                chkActive.Checked = toaAn.HIEULUC == 0 ? false : true;
                cmdDel.Enabled = true;
                rdNhanDKKOnline.SelectedValue = (String.IsNullOrEmpty(toaAn.NHANDKKONLINE + "")) ? "0" : toaAn.NHANDKKONLINE.ToString();
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
                int toaAnID = Convert.ToInt32(e.CommandArgument.ToString());
                lbthongbao.Text = "";
                switch (e.CommandName)
                {
                    case "Sua":
                        loadedit(toaAnID);
                        hddToaAnID.Value = e.CommandArgument.ToString();
                        break;
                    case "Xoa":
                        // chỉ load lại danh sách các control phía trên giữ nguyên
                        string dropParentValue = "0";
                        if (dropParent.SelectedIndex != 0)
                        {
                            dropParentValue = dropParent.SelectedValue;
                        }
                        xoa(toaAnID);
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
            List<DM_DONVITHIHANHAN> lst = dt.DM_DONVITHIHANHAN.Where(x => x.CAPCHAID == ParentID && (x.MA.ToLower().Contains(textKey) || x.TEN.ToLower().Contains(textKey))).OrderBy(x => x.ARRTHUTU).ToList();
            if (lst != null && lst.Count > 0)
            {
                countItem = lst.Count;
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(countItem, pageSize).ToString();
                dgList.PageSize = pageSize;
                int pageSkip = (pageIndex - 1) * pageSize;
                dgList.DataSource = lst.Skip(pageSkip).Take(pageSize).ToList<DM_DONVITHIHANHAN>();
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
                lbthongbao.Text = "Mã tòa án không được trống hoặc quá 50 ký tự. Hãy nhập lại!";
                return false;
            }
            int lengthTen = txtTen.Text.Trim().Length;
            if (lengthTen <= 0 || lengthTen > 250)
            {
                lbthongbao.Text = "Tên tòa án không được trống hoặc quá 250 ký tự. Hãy nhập lại!";
                return false;
            }
            //DM_DONVITHIHANHAN toaAnCheck = dt.DM_DONVITHIHANHAN.Where(x => x.TEN.ToLower() == Ten.ToLower()).FirstOrDefault<DM_DONVITHIHANHAN>();
            //if (toaAnCheck != null)
            //{
            //    if (toaAnCheck.ID != HanhChinhID)
            //    {
            //        lbthongbao.Text = "Tên tòa án này đã tồn tại. Hãy nhập lại!";
            //        txtTen.Focus();
            //        return false;
            //    }
            //}
            int lengthDiaChi = txtDiaChi.Text.Trim().Length;
            if (lengthDiaChi > 250)
            {
                lbthongbao.Text = "Địa chỉ không quá 250 ký tự. Hãy nhập lại!";
                txtDiaChi.Focus();
                return false;
            }
            int lengthDienThoai = txtDienThoai.Text.Trim().Length;
            if (lengthDienThoai > 250)
            {
                lbthongbao.Text = "Điện thoại không quá 250 ký tự. Hãy nhập lại!";
                txtDienThoai.Focus();
                return false;
            }
            int lengthFax = txtFax.Text.Trim().Length;
            if (lengthFax > 150)
            {
                lbthongbao.Text = "Fax không quá 150 ký tự. Hãy nhập lại!";
                txtFax.Focus();
                return false;
            }
            int lengthEmail = txtEmail.Text.Trim().Length;
            if (lengthEmail > 150)
            {
                lbthongbao.Text = "Email không quá 150 ký tự. Hãy nhập lại!";
                txtEmail.Focus();
                return false;
            }
            // Đơn vị cấp trên không thể là chính nó hoặc là đơn vị cấp dưới của nó
            if (hddToaAnID.Value != "0")
            {
                if (dropParent.SelectedValue == hddToaAnID.Value)
                {
                    lbthongbao.Text = "Tòa án cấp trên không thể là chính nó. Hãy chọn lại!";
                    return false;
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
            LoadDropParentListChild(0, "");
        }
        private void LoadDropParentListChild(decimal pID, string dept)
        {
            List<DM_DONVITHIHANHAN> listchild = dt.DM_DONVITHIHANHAN.Where(x => x.CAPCHAID == pID).OrderBy(y => y.THUTU).ToList();
            if (listchild != null && listchild.Count > 0)
            {
                foreach (DM_DONVITHIHANHAN child in listchild)
                {
                    dropParent.Items.Add(new ListItem(dept + child.TEN, child.ID.ToString()));
                    LoadDropParentListChild(child.ID, PUBLIC_DEPT + dept);
                }
            }
        }
    }
}