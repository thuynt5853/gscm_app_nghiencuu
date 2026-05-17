using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.Danhmuc.Toaan
{
    public partial class Danhsach : System.Web.UI.Page
    {
        private string PUBLIC_DEPT = "..";
        GSTPContext dt = new GSTPContext();
        private const int ROOT = 0, DEL = 0, ADD = 1, UPDATE = 2;

        /// <summary>
        /// Load page
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
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

                    #region [ SÁP NHẬP ]

                    // Ẩn phần quản lý sáp nhập khi load trang lần đầu
                    divSapNhapToaAn.Visible = false;

                    #endregion

                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(btnNew, oPer.TAOMOI);
                    Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                    Cls_Comon.SetButton(cmdDel, oPer.XOA);
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        /// <summary>
        /// Load data loại toà án
        /// </summary>
        public void LoadDropLoaiToaAn()
        {
            // Clear loại toà án
            dropLoaiToaAn.Items.Clear();
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();

            // Lấy loại toà án theo danh mục
            DataTable dmLoaiVKS = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.LOAITOA);
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

        /// <summary>
        /// Load tree view
        /// </summary>
        public void LoadTreeview()
        {
            treemenu.Nodes.Clear();
            TreeNode oRoot = new TreeNode("Danh mục tòa án", ROOT.ToString());
            treemenu.Nodes.Add(oRoot);
            LoadTreeChild(oRoot, "");
            treemenu.Nodes[ROOT].Expand();
        }

        /// <summary>
        /// Create Node
        /// </summary>
        /// <param name="sNodeId"></param>
        /// <param name="sNodeText"></param>
        /// <returns></returns>
        private TreeNode CreateNode(string sNodeId, string sNodeText)
        {
            TreeNode objTreeNode = new TreeNode();
            objTreeNode.Value = sNodeId;
            objTreeNode.Text = sNodeText;
            return objTreeNode;
        }

        /// <summary>
        ///  Load cây con
        /// </summary>
        /// <param name="root"></param>
        /// <param name="dept"></param>
        public void LoadTreeChild(TreeNode root, string dept)
        {
            decimal nID = Convert.ToDecimal(root.Value);

            // Xử lý tìm kiếm CAPCHAID thực tế sau khi sáp nhập theo bảng mapping

            #region Filter
            // Lấy giá trị filter theo Hiệu lực
            var filterHieuLuc = Convert.ToDecimal(rbFilterHieuLuc.SelectedValue);
            #endregion

            List<DM_TOAAN> listchild = dt.DM_TOAAN.Where(x => x.CAPCHAID == nID && (filterHieuLuc == -1 || x.HIEULUC == filterHieuLuc)).OrderBy(y => y.THUTU).ToList();
            if (listchild != null && listchild.Count > 0)
            {
                foreach (DM_TOAAN child in listchild)
                {
                    TreeNode nodechild;
                    nodechild = CreateNode(child.ID.ToString(), child.TEN.ToString());
                    root.ChildNodes.Add(nodechild);
                    LoadTreeChild(nodechild, PUBLIC_DEPT + dept);
                    root.CollapseAll();
                }
            }
        }

        /// <summary>
        /// Lấy danh sách toà án theo id cha
        /// </summary>
        /// <param name="chaid"></param>
        /// <returns></returns>
        public List<DM_TOAAN> GetListToaAnByParentID(string chaid)
        {
            #region Filter
            // Lấy giá trị filter theo Hiệu lực
            var filterHieuLuc = Convert.ToDecimal(rbFilterHieuLuc.SelectedValue);
            #endregion

            int ID = Convert.ToInt32(chaid);
            return dt.DM_TOAAN.Where(x => x.CAPCHAID == ID && x.HIEULUC == 1 && (filterHieuLuc == -1 || x.HIEULUC == filterHieuLuc)).ToList();
        }

        /// <summary>
        /// Selected filter hiệu lực
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void rbFilterHieuLuc_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadTreeview();
        }

        /// <summary>
        /// Tạo mới
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
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

        /// <summary>
        /// Cập nhật
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
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
                // Kiểm tra toà án có tồn tại hay chưa
                // Nếu chưa thì tạo mới (isNew = true), còn có rồi update các trường thông tin tương ứng
                DM_TOAAN toaAn = dt.DM_TOAAN.Where(x => x.ID == toaAnID).FirstOrDefault<DM_TOAAN>();
                if (toaAn == null)
                {
                    isNew = true;
                    toaAn = new DM_TOAAN();
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
                    dt.DM_TOAAN.Add(toaAn);
                    action = ADD;
                }
                dt.SaveChanges();

                #region Lưu ArrSapXep và ArrThuTu
                string strArrSapXep = "", strArrThuTu = "", strTen = "";
                DM_TOAAN toaAnParent = dt.DM_TOAAN.Where(x => x.ID == ParentID).FirstOrDefault<DM_TOAAN>();
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
                        toaAn.MA_TEN = toaAn.TEN + "," + toaAnParent.TEN.Replace("Tòa án nhân dân", "");
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
                    List<DM_TOAAN> lst = GetListToaAnByParentID(toaAn.ID.ToString());
                    if (lst != null && lst.Count > 0)
                    {
                        UpdateChildren(lst, strArrThuTu, strArrSapXep, toaAn.MA_TEN, Convert.ToInt32(toaAn.SOCAP));
                    }
                }
                LoadTreeview();
                LoadDropParent();
                LoadDropDonViMucTieu(); // Reload dropdown đơn vị mục tiêu khi có thay đổi dữ liệu tòa án
                hddPageIndex.Value = "1";
                LoadListChildren(ParentID.ToString(), txttimkiem.Text);
                FillThutu(GetListToaAnByParentID(ParentID.ToString()).Count + 1);
                reSetControl();
                lbthongbao.Text = "Lưu thành công!";
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        /// <summary>
        /// Cập nhật đơn vị con
        /// </summary>
        /// <param name="lst"></param>
        /// <param name="ParrThuTu"></param>
        /// <param name="ParrSapXep"></param>
        /// <param name="MaTen"></param>
        /// <param name="SoCap"></param>
        private void UpdateChildren(List<DM_TOAAN> lst, string ParrThuTu, string ParrSapXep, string MaTen, int SoCap)
        {
            string Ten = MaTen;
            if (MaTen.Contains("-"))
            {
                string[] arrStr = MaTen.Split('-');
                Ten = arrStr[0].ToString().Trim();
            }
            foreach (DM_TOAAN item in lst)
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
                List<DM_TOAAN> lstChild = GetListToaAnByParentID(item.ID.ToString());
                if (lstChild != null && lstChild.Count > 0)
                {
                    UpdateChildren(lstChild, item.ARRTHUTU, item.ARRSAPXEP, item.MA_TEN, Convert.ToInt32(item.SOCAP));
                }
            }
        }

        /// <summary>
        /// Cập nhật đơn vị con
        /// </summary>
        /// <param name="lst"></param>
        /// <param name="ParrThuTu"></param>
        /// <param name="strParentTen"></param>
        private void UpdateChildren(List<DM_TOAAN> lst, string ParrThuTu, string strParentTen)
        {
            foreach (DM_TOAAN item in lst)
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
                List<DM_TOAAN> lstChild = GetListToaAnByParentID(item.ID.ToString());
                if (lstChild != null && lstChild.Count > 0)
                {
                    UpdateChildren(lstChild, item.ARRTHUTU, item.TEN);
                }
            }
        }

        /// <summary>
        /// Lấy danh sách đơn vị cấp
        /// </summary>
        /// <param name="dvID"></param>
        /// <returns></returns>
        private int GetLevel(decimal dvID)
        {
            int level = 0;
            if (dvID == 0)
            {
                level = 0;
            }
            else
            {
                DM_TOAAN dv = dt.DM_TOAAN.Where(x => x.ID == dvID).FirstOrDefault<DM_TOAAN>();
                if (dv != null)
                {
                    level = (int)dv.SOCAP;
                }
            }
            return level;
        }

        /// <summary>
        /// Xoá
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnDel_Click(object sender, EventArgs e)
        {
            try
            {
                if (hddToaAnID.Value != "0")
                {
                    List<DM_TOAAN> lst = GetListToaAnByParentID(hddToaAnID.Value);
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

        /// <summary>
        /// Lưu thứ tự toà án con
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void cmdThutu_Click(object sender, EventArgs e)
        {
            try
            {
                string strArrThuTuParent = "0", parentID = "0";
                decimal toaAnID = Convert.ToDecimal(dgList.Items[0].Cells[0].Text);
                DM_TOAAN toaAn = dt.DM_TOAAN.Where(x => x.ID == toaAnID).FirstOrDefault<DM_TOAAN>();
                if (toaAn != null)
                {
                    parentID = toaAn.CAPCHAID.ToString();
                    DM_TOAAN ParentDMHanhChinh = dt.DM_TOAAN.Where(x => x.ID == toaAn.CAPCHAID).FirstOrDefault<DM_TOAAN>();
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
                    toaAn = dt.DM_TOAAN.Where(x => x.ID == toaAnID).FirstOrDefault<DM_TOAAN>();
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
                    List<DM_TOAAN> lst = GetListToaAnByParentID(oItem.Cells[DMToaAnIDColIndex].Text);
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

        /// <summary>
        /// Selected tree menu
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void treemenu_SelectedNodeChanged(object sender, EventArgs e)
        {
            try
            {
                lbthongbao.Text = ""; hddToaAnID.Value = treemenu.SelectedValue;
                int hcID = Convert.ToInt32(treemenu.SelectedValue);
                loadedit(hcID);

                // Hiển thị/ẩn phần quản lý sáp nhập tòa án
                UpdateSapNhapVisibility(hcID);
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        /// <summary>
        /// Refresh
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            try
            {
                reSetControl();

                // Ẩn phần quản lý sáp nhập khi làm mới
                divSapNhapToaAn.Visible = false;
                ResetSapNhapForm();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        /// <summary>
        /// Reset data
        /// </summary>
        private void reSetControl()
        {
            txtMa.Text = txtTen.Text = "";
            dropParent.SelectedIndex = 0;
            dropLoaiToaAn.SelectedIndex = 0;
            txtDonViHanhChinh.Text = ""; hddDonViHanhChinh.Value = "0";
            txtDiaChi.Text = txtDienThoai.Text = txtFax.Text = txtEmail.Text = txtTenCQTHA.Text = txtDiachiCQTHA.Text = "";
            if (hddToaAnID.Value != "0")
            {
                decimal hcID = Convert.ToDecimal(hddToaAnID.Value);
                DM_TOAAN dmHanhChinh = dt.DM_TOAAN.Where(x => x.ID == hcID).FirstOrDefault<DM_TOAAN>();
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

        /// <summary>
        /// Fill thứ tự
        /// </summary>
        /// <param name="iCount"></param>
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

        /// <summary>
        /// Danh sách toà án con
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            try
            {
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
                {
                    DM_TOAAN item = (DM_TOAAN)e.Item.DataItem;
                    DropDownList dropThuTuChildren = (DropDownList)e.Item.FindControl("dropThuTuChildren");
                    decimal ParentID = Convert.ToDecimal(item.CAPCHAID), countItem = 0;
                    List<DM_TOAAN> lst = dt.DM_TOAAN.Where(x => x.CAPCHAID == ParentID).ToList();
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

        /// <summary>
        /// Xoá
        /// </summary>
        /// <param name="id"></param>
        public void xoa(int id)
        {
            // Lấy danh sách toà án con
            List<DM_TOAAN> obj = dt.DM_TOAAN.Where(x => x.CAPCHAID == id).ToList();
            if (obj != null && obj.Count > 0)
            {
                lbthongbao.Text = "Không xóa được vì có tòa án cấp dưới!";
            }
            else
            {
                DM_TOAAN toaAn = dt.DM_TOAAN.Where(x => x.ID == id).FirstOrDefault();
                if (toaAn != null)
                {
                    dt.DM_TOAAN.Remove(toaAn);
                    dt.SaveChanges();
                    List<DM_TOAAN> lst = dt.DM_TOAAN.Where(x => x.CAPCHAID == toaAn.CAPCHAID).OrderBy(y => y.THUTU).ToList();
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

        /// <summary>
        /// Load edit
        /// </summary>
        /// <param name="ID"></param>
        public void loadedit(int ID)
        {
            DM_TOAAN toaAn = dt.DM_TOAAN.Where(x => x.ID == ID).FirstOrDefault();
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
                txtTenCQTHA.Text = toaAn.TENCOQUANTHA;
                txtDiachiCQTHA.Text = toaAn.DIACHICOQUANTHA;
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

        /// <summary>
        /// Item list
        /// </summary>
        /// <param name="source"></param>
        /// <param name="e"></param>
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

        /// <summary>
        /// Load danh sách toà án con
        /// </summary>
        /// <param name="capchaid"></param>
        /// <param name="textKey"></param>
        public void LoadListChildren(string capchaid, string textKey)
        {
            int ParentID = Convert.ToInt32(capchaid), countItem = 0, pageSize = Convert.ToInt32(hddPageSize.Value), pageIndex = Convert.ToInt32(hddPageIndex.Value);
            textKey = textKey.Trim().ToLower();
            List<DM_TOAAN> lst = dt.DM_TOAAN.Where(x => x.CAPCHAID == ParentID && (x.MA.ToLower().Contains(textKey) || x.TEN.ToLower().Contains(textKey))).OrderBy(x => x.ARRTHUTU).ToList();
            if (lst != null && lst.Count > 0)
            {
                countItem = lst.Count;
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(countItem, pageSize).ToString();
                dgList.PageSize = pageSize;
                int pageSkip = (pageIndex - 1) * pageSize;
                dgList.DataSource = lst.Skip(pageSkip).Take(pageSize).ToList<DM_TOAAN>();
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

        /// <summary>
        /// Selected đơn vị cha
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void dropParent_SelectedIndexChanged(object sender, EventArgs e)
        {
            try { FillThutu(GetListToaAnByParentID(dropParent.SelectedValue).Count + 1); } catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        /// <summary>
        /// Validate form data
        /// </summary>
        /// <param name="HanhChinhID"></param>
        /// <param name="Ten"></param>
        /// <returns></returns>
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
            //DM_TOAAN toaAnCheck = dt.DM_TOAAN.Where(x => x.TEN.ToLower() == Ten.ToLower()).FirstOrDefault<DM_TOAAN>();
            //if (toaAnCheck != null)
            //{
            //    if (toaAnCheck.ID != HanhChinhID)
            //    {
            //        lbthongbao.Text = "Tên tòa án này đã tồn tại. Hãy nhập lại!";
            //        txtTen.Focus();
            //        return false;
            //    }
            //}
            //if(hddDonViHanhChinh.Value=="" || hddDonViHanhChinh.Value=="0")
            //{
            //    lbthongbao.Text = "Chưa chọn đơn vị hành chính tương ứng!";
            //    txtDonViHanhChinh.Focus();
            //    return false;
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

        /// <summary>
        /// Tìm kiếm
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Btntimkiem_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadListChildren(hddToaAnID.Value, txttimkiem.Text);
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        /// <summary>
        /// Edit node
        /// </summary>
        /// <param name="nodeName"></param>
        /// <param name="nodeNameEdit"></param>
        /// <param name="nodeID"></param>
        /// <param name="action"></param>
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

        /// <summary>
        /// Edit note con
        /// </summary>
        /// <param name="node"></param>
        /// <param name="nodeName"></param>
        /// <param name="nodeNameEdit"></param>
        /// <param name="nodeID"></param>
        /// <param name="action"></param>
        /// <returns></returns>
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

        /// <summary>
        /// Load danh sách cha
        /// </summary>
        private void LoadDropParent()
        {
            dropParent.Items.Clear();
            dropParent.DataSource = null;
            dropParent.DataBind();
            dropParent.Items.Add(new ListItem("Chọn", ROOT.ToString()));
            LoadDropParentListChild(0, "");
        }

        /// <summary>
        /// Load danh sách toà án con theo id cha
        /// </summary>
        /// <param name="pID"></param>
        /// <param name="dept"></param>
        private void LoadDropParentListChild(decimal pID, string dept)
        {
            List<DM_TOAAN> listchild = dt.DM_TOAAN.Where(x => x.CAPCHAID == pID).OrderBy(y => y.THUTU).ToList();
            if (listchild != null && listchild.Count > 0)
            {
                foreach (DM_TOAAN child in listchild)
                {
                    dropParent.Items.Add(new ListItem(dept + child.TEN, child.ID.ToString()));
                    LoadDropParentListChild(child.ID, PUBLIC_DEPT + dept);
                }
            }
        }

        #region [ Quản lý sáp nhập tòa án ]

        /// <summary>
        /// Xử lý hiển thị/ẩn phần quản lý sáp nhập tòa án
        /// </summary>
        /// <param name="selectedToaAnID">ID tòa án được chọn</param>
        private void UpdateSapNhapVisibility(int selectedToaAnID)
        {
            try
            {
                // Chỉ hiển thị khi chọn tòa án thực sự (không phải root)
                if (selectedToaAnID > 0)
                {
                    // Hiển thị vùng chức năng sáp nhập
                    divSapNhapToaAn.Visible = true;

                    // Reset form sáp nhập khi chọn tòa án khác
                    ResetSapNhapForm();

                    // Load danh sách sáp nhập của tòa án này (nếu có)
                    LoadSapNhapList();
                }
                else
                {
                    // Ẩn vùng chức năng sáp nhập
                    divSapNhapToaAn.Visible = false;

                    // Clear thông báo
                    lblThongBaoSapNhap.Text = "";
                }
            }
            catch (Exception ex)
            {
                // Log lỗi nhưng không ảnh hưởng đến chức năng chính
                divSapNhapToaAn.Visible = false;
            }
        }

        /// <summary>
        /// LoadDropdown loại sáp nhập
        /// </summary>
        /// <param name="drop"></param>
        /// <param name="ShowChangeAll"></param>
        void LoadDropLoaiSapNhap(DropDownList drop, Boolean ShowChangeAll)
        {
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.LOAISAPNHAP);

            drop.Items.Clear();
            if (ShowChangeAll)
                drop.Items.Add(new ListItem("--- Chọn loại sáp nhập ---", ""));
            if (tbl != null && tbl.Rows.Count > 0)
            {
                foreach (DataRow row in tbl.Rows)
                    drop.Items.Add(new ListItem(row["TEN"] + "", row["MA"] + ""));
            }
        }

        /// <summary>
        /// SelectedChanged loại sáp nhập
        /// </summary>
        protected void dropLoaiSapNhap_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                //UpdateDonViMucTieuLabel();
                if (!string.IsNullOrEmpty(dropLoaiSapNhap.SelectedValue))
                {
                    // ClearDrop đơn vị mục tiêu
                    dropDonViMucTieu.ClearSelection();

                    // Cho phép chọn đơn vị mục tiêu
                    dropDonViMucTieu.Enabled = true;

                    // Load lại Dropd đơn vị mục tiêu
                    LoadDropDonViMucTieu();

                    // Cập nhật label đơn vị mục tiêu
                    switch (dropLoaiSapNhap.SelectedValue)
                    {
                        case ENUM_LOAISAPNHAP_MA.NHAP:
                            lblDonViMucTieu.Text = "Đơn vị trước sáp nhập";
                            break;
                        case ENUM_LOAISAPNHAP_MA.TACH:
                            lblDonViMucTieu.Text = "Đơn vị sau sáp nhập";
                            break;
                        default:
                            lblDonViMucTieu.Text = "Đơn vị mục tiêu";
                            break;
                    }
                }
                else
                {
                    // ClearDrop đơn vị mục tiêu
                    dropDonViMucTieu.ClearSelection();

                    // Cho phép chọn đơn vị mục tiêu
                    dropDonViMucTieu.Enabled = false;

                    // Cập nhật label đơn vị mục tiêu
                    lblDonViMucTieu.Text = "Đơn vị mục tiêu";
                }
            }
            catch (Exception ex)
            {
                lblThongBaoSapNhap.Text = "Lỗi: " + ex.Message;
                lblThongBaoSapNhap.ForeColor = System.Drawing.Color.Red;
            }
        }

        /// <summary>
        /// Load dropdown đơn vị mục tiêu - chỉ hiển thị tòa cùng cấp nếu có tòa án được chọn
        /// </summary>
        private void LoadDropDonViMucTieu()
        {
            try
            {
                // Kiểm tra xem có tòa án nào được chọn không
                int currentToaAnID = 0;
                if (!string.IsNullOrEmpty(hddToaAnID.Value) && int.TryParse(hddToaAnID.Value, out currentToaAnID) && currentToaAnID > 0)
                {
                    // Lấy dữ liệu từ BL
                    BL.GSTP.Danhmuc.DM_TOAAN_TACH_NHAP_MAPPING_BL bl = new BL.GSTP.Danhmuc.DM_TOAAN_TACH_NHAP_MAPPING_BL();

                    // Lấy danh sách những toà cùng cấp
                    DataTable dtSameLevelToas = bl.GETS_SAME_LEVEL_TOAANTID(currentToaAnID);
                    dropDonViMucTieu.Items.Clear();
                    dropDonViMucTieu.DataSource = null;
                    dropDonViMucTieu.DataBind();
                    dropDonViMucTieu.Items.Add(new ListItem("--- Chọn tòa án ---", "0"));
                    if (dtSameLevelToas != null && dtSameLevelToas.Rows != null && dtSameLevelToas.Rows.Count > 0)
                    {
                        // Lấy danh sách các Sáp nhập đã có của toà hiện tại

                        foreach (DataRow row in dtSameLevelToas.Rows)
                        {
                            // Kiểm tra không trùng thì thêm
                            if (dropDonViMucTieu.Items.FindByValue(row["ID"].ToString()) == null)
                            {
                                if (row["HIEULUC"].toNumber() == 0)
                                {
                                    ListItem listItem = new ListItem();
                                    listItem.Value = row["ID"].ToString();
                                    listItem.Text = row["TEN"].ToString();
                                    // Item không hiệu lực - hiển thị nhưng đánh dấu để validation chặn
                                    listItem.Attributes.Add("style", "color: #999999; pointer-events: none;");
                                    listItem.Attributes.Add("data-disabled", "true");
                                    listItem.Attributes.Add("disabled", "disabled");

                                    dropDonViMucTieu.Items.Add(listItem);

                                    // Thêm dòng mô tả thông tin nhập
                                    if (row["LOAISAPNHAP"].ToString() == ENUM_LOAISAPNHAP_MA.NHAP)
                                    {
                                        ListItem listDesItem = new ListItem();

                                        listDesItem.Value = row["ID"].ToString() + "-description";
                                        listDesItem.Text = "( Nhập vào " + row["TOTOAANTEN"].ToString() + " )";
                                        listDesItem.Attributes.Add("style", "color: #999999; pointer-events: none; font-style: italic; font-size: 0.85em;padding-top: 0; margin-top: 0; line-height: 6px;");
                                        listDesItem.Attributes.Add("data-disabled", "true");
                                        listDesItem.Attributes.Add("disabled", "disabled");

                                        dropDonViMucTieu.Items.Add(listDesItem);
                                    }
                                    // Thêm dòng mô tả thông tin Tách
                                    else if (row["LOAISAPNHAP"].ToString() == ENUM_LOAISAPNHAP_MA.TACH)
                                    {
                                        ListItem listDesItem = new ListItem();

                                        listDesItem.Value = row["ID"].ToString() + "-description";
                                        listDesItem.Text = "( Đã tách )";
                                        listDesItem.Attributes.Add("style", "color: #999999; pointer-events: none; font-style: italic; font-size: 0.85em;padding-top: 0; margin-top: 0; line-height: 6px;");
                                        listDesItem.Attributes.Add("data-disabled", "true");
                                        listDesItem.Attributes.Add("disabled", "disabled");

                                        dropDonViMucTieu.Items.Add(listDesItem);
                                    }

                                }
                                else
                                {
                                    ListItem listItem = new ListItem();

                                    listItem.Value = row["ID"].ToString();
                                    listItem.Text = row["TEN"].ToString();

                                    dropDonViMucTieu.Items.Add(listItem);
                                }
                            }
                        }
                    }
                }
                else
                {
                    // Nếu chưa chọn tòa án nào, hiển thị dropdown trống hoặc thông báo
                    dropDonViMucTieu.Items.Clear();
                    dropDonViMucTieu.Items.Add(new ListItem("-- Chọn tòa án --", "0"));
                }
            }
            catch (Exception ex)
            {
                lblThongBaoSapNhap.Text = "Lỗi: không lấy được danh sách toà mục tiêu!";
                lblThongBaoSapNhap.ForeColor = System.Drawing.Color.Red;
            }
        }

        /// <summary>
        /// Load danh sách sáp nhập từ database - Xử lý null values an toàn
        /// </summary>
        private void LoadSapNhapList()
        {
            try
            {
                // Lấy ID tòa án hiện tại được chọn
                decimal toaAnID = 0;
                if (!string.IsNullOrEmpty(hddToaAnID.Value) && decimal.TryParse(hddToaAnID.Value, out toaAnID) && toaAnID > 0)
                {
                    // Lấy dữ liệu từ BL
                    BL.GSTP.Danhmuc.DM_TOAAN_TACH_NHAP_MAPPING_BL bl = new BL.GSTP.Danhmuc.DM_TOAAN_TACH_NHAP_MAPPING_BL();
                    DataTable dtSapNhap = bl.GETS_BY_TOAANTID(toaAnID);

                    if (dtSapNhap != null && dtSapNhap.Rows.Count > 0)
                    {
                        // Xử lý null values trước khi bind
                        ProcessNullValuesInDataTable(dtSapNhap);

                        dgSapNhap.DataSource = dtSapNhap;
                        dgSapNhap.DataBind();
                    }
                    else
                    {
                        // Không có dữ liệu
                        dgSapNhap.DataSource = null;
                        dgSapNhap.DataBind();

                        lblThongBaoSapNhap.Text = "Chưa có thông tin sáp nhập cho tòa án này.";
                        lblThongBaoSapNhap.ForeColor = System.Drawing.Color.Blue;
                    }
                }
                else
                {
                    // Chưa chọn tòa án
                    dgSapNhap.DataSource = null;
                    dgSapNhap.DataBind();

                    lblThongBaoSapNhap.Text = "Vui lòng chọn tòa án để xem danh sách sáp nhập.";
                    lblThongBaoSapNhap.ForeColor = System.Drawing.Color.Orange;
                }
            }
            catch (Exception ex)
            {
                lblThongBaoSapNhap.Text = "Lỗi load danh sách sáp nhập: " + ex.Message;
                lblThongBaoSapNhap.ForeColor = System.Drawing.Color.Red;

                // Clear grid khi có lỗi
                dgSapNhap.DataSource = null;
                dgSapNhap.DataBind();
            }
        }

        /// <summary>
        /// DataBound event của DataGrid sáp nhập - Xử lý null values an toàn
        /// </summary>
        protected void dgSapNhap_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            try
            {
                if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
                {
                    // Xử lý dữ liệu của từng row để đảm bảo không có lỗi null
                    DataRowView rowView = (DataRowView)e.Item.DataItem;

                    // Có thể xử lý format dữ liệu ở đây nếu cần
                    // Ví dụ: format ngày, hiệu lực, v.v.

                    // Xử lý quyền hạn nếu có
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));

                    var toaAnId = e.Item.Cells[GetColumnIndexByName(dgSapNhap, "TOAANID")].Text.Trim();
                    var toToaAnId = e.Item.Cells[GetColumnIndexByName(dgSapNhap, "TOTOAANID")].Text.Trim();
                    var loai = e.Item.Cells[GetColumnIndexByName(dgSapNhap, "LOAI")].Text.Trim();

                    // Có thể ẩn/hiện button sửa/xóa dựa trên quyền
                    LinkButton lbtSuaSapNhap = (LinkButton)e.Item.FindControl("lbtSuaSapNhap");
                    LinkButton lbtXoaSapNhap = (LinkButton)e.Item.FindControl("lbtXoaSapNhap");
                    switch (loai)
                    {
                        // Chỉ cho đơn vị nhận sáp nhập được thao tác
                        case ENUM_LOAISAPNHAP_MA.NHAP:
                            if (lbtSuaSapNhap != null) lbtSuaSapNhap.Visible = toToaAnId == hddToaAnID.Value;
                            if (lbtXoaSapNhap != null) lbtXoaSapNhap.Visible = toToaAnId == hddToaAnID.Value;
                            break;
                        // Chỉ cho đơn vị bị sáp nhập được thao tác
                        case ENUM_LOAISAPNHAP_MA.TACH:
                            if (lbtSuaSapNhap != null) lbtSuaSapNhap.Visible = toaAnId == hddToaAnID.Value;
                            if (lbtXoaSapNhap != null) lbtXoaSapNhap.Visible = toaAnId == hddToaAnID.Value;
                            break;
                        default:
                            if (lbtSuaSapNhap != null) lbtSuaSapNhap.Visible = false;
                            if (lbtXoaSapNhap != null) lbtXoaSapNhap.Visible = false;
                            break;
                    }
                }
            }
            catch (Exception ex)
            {
                // Không throw exception để tránh crash trang
            }
        }

        private int GetColumnIndexByName(DataGrid grid, string name)
        {

            for (int i = 0; i < grid.Columns.Count; i++)
            {
                try
                {
                    var item = ((System.Web.UI.WebControls.BoundColumn)grid.Columns[i]).DataField;

                    if (!string.IsNullOrEmpty(item) && item.ToLower().Trim() == name.ToLower().Trim())
                    {
                        return i;
                    }
                }
                catch
                {
                }
            }

            return -1;
        }

        /// <summary>
        /// Xử lý command của DataGrid sáp nhập theo cấu trúc DM_TOAAN_TACH_NHAP_MAPPING_GS
        /// </summary>
        protected void dgSapNhap_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            try
            {
                // Lấy ID từ CommandArgument (column ID của DM_TOAAN_TACH_NHAP_MAPPING_GS)
                int sapNhapID = Convert.ToInt32(e.CommandArgument.ToString());
                lblThongBaoSapNhap.Text = "";

                switch (e.CommandName)
                {
                    case "SuaSapNhap":
                        LoadEditSapNhap(sapNhapID);
                        break;
                    case "XoaSapNhap":
                        DeleteSapNhap(sapNhapID);
                        break;
                }
            }
            catch (Exception ex)
            {
                lblThongBaoSapNhap.Text = "Lỗi xử lý command: " + ex.Message;
                lblThongBaoSapNhap.ForeColor = System.Drawing.Color.Red;
            }
        }

        /// <summary>
        /// Load dữ liệu để sửa từ DataGrid row theo cấu trúc DM_TOAAN_TACH_NHAP_MAPPING_GS
        /// </summary>
        private void LoadEditSapNhap(int sapNhapID)
        {
            try
            {
                // Lấy dữ liệu từ database theo ID
                decimal currentToaAnId = 0;
                if (!string.IsNullOrEmpty(hddToaAnID.Value) && decimal.TryParse(hddToaAnID.Value, out currentToaAnId) && currentToaAnId > 0)
                {
                    BL.GSTP.Danhmuc.DM_TOAAN_TACH_NHAP_MAPPING_BL bl = new BL.GSTP.Danhmuc.DM_TOAAN_TACH_NHAP_MAPPING_BL();
                    DataTable dtSapNhap = bl.GETS_BY_ID(sapNhapID);

                    if (dtSapNhap != null && dtSapNhap.Rows.Count > 0)
                    {
                        DataRow row = dtSapNhap.Rows[0];

                        hddSapNhapID.Value = sapNhapID.ToString();

                        // LOAI => dropLoaiSapNhap
                        string loaiSapNhap = "";
                        LoadDropLoaiSapNhap(dropLoaiSapNhap, true);
                        if (row["LOAI"] != DBNull.Value && row["LOAI"] != null)
                        {
                            loaiSapNhap = row["LOAI"].ToString(); ;
                            dropLoaiSapNhap.SelectedValue = row["LOAI"].ToString();
                            dropLoaiSapNhap.Enabled = false;
                        }

                        // TOTOAANID => dropToaMucTieu
                        LoadDropDonViMucTieu();
                        if (row["TOAANID"] != DBNull.Value && row["TOAANID"] != null)
                        {
                            switch (loaiSapNhap)
                            {
                                // Nếu là nhập thì gán DropDonViMucTieu là toaAnId
                                case ENUM_LOAISAPNHAP_MA.NHAP:
                                    dropDonViMucTieu.SelectedValue = row["TOAANID"].ToString();

                                    // Kiểm tra xem toà hiện tại khác toà được sát nhập disable dropToaMucTieu
                                    if (currentToaAnId.ToString() != row["TOTOAANID"].ToString())
                                    {
                                        dropDonViMucTieu.Enabled = false;
                                    }

                                    break;

                                // Nếu là tách thì gán DropDonViMucTieu là toToaId
                                case ENUM_LOAISAPNHAP_MA.TACH:
                                    dropDonViMucTieu.SelectedValue = row["TOTOAANID"].ToString();

                                    // Kiểm tra xem toà hiện tại khác toà gốc disable dropToaMucTieu
                                    if (currentToaAnId.ToString() != row["TOAANID"].ToString())
                                    {
                                        dropDonViMucTieu.Enabled = false;
                                    }

                                    break;
                            }
                        }

                        // NGAYHIEULUC -> txtNgayBatDauHieuLuc
                        if (row["NGAYHIEULUC"] != null || row["NGAYHIEULUC"] != DBNull.Value)
                        {
                            DateTime ngayHieuLuc = Convert.ToDateTime(row["NGAYHIEULUC"]);
                            txtNgayBatDauHieuLuc.Text = ngayHieuLuc.ToString("dd/MM/yyyy");
                        }

                        // GHICHU -> tbGhiChu
                        if (row["GHICHU"] != null || row["GHICHU"] != DBNull.Value)
                        {
                            tbGhiChu.Text = row["GHICHU"].ToString();
                        }

                        lblThongBaoSapNhap.Text = "Bạn đang chỉnh sửa cấu hình sáp nhập";
                        lblThongBaoSapNhap.ForeColor = System.Drawing.Color.Blue;
                    }
                }
            }
            catch (Exception ex)
            {
                lblThongBaoSapNhap.Text = "Lỗi load dữ liệu sửa: " + ex.Message;
                lblThongBaoSapNhap.ForeColor = System.Drawing.Color.Red;
            }
        }

        /// <summary>
        /// Validate form sáp nhập tích hợp với ASP.NET validation controls - Cho phép ngày null
        /// </summary>
        private bool ValidateSapNhapForm()
        {
            // Kiểm tra ASP.NET validation trước
            if (!Page.IsValid)
            {
                return false;
            }

            // Kiểm tra loại sáp nhập (không bắt buộc)
            if (string.IsNullOrEmpty(dropLoaiSapNhap.Text.Trim()))
            {
                lblThongBaoSapNhap.Text = "Vui lòng chọn loại sáp nhập!";
                lblThongBaoSapNhap.ForeColor = System.Drawing.Color.Red;
                return false;
            }

            // Kiểm tra đơn vị mục tiêu (bắt buộc)
            int donViMucTieuID = 0;
            if (!int.TryParse(dropDonViMucTieu.SelectedValue, out donViMucTieuID) || donViMucTieuID <= 0)
            {
                lblThongBaoSapNhap.Text = "Vui lòng chọn " + lblDonViMucTieu.Text + "!";
                lblThongBaoSapNhap.ForeColor = System.Drawing.Color.Red;
                return false;
            }

            // Kiểm tra ngày bắt đầu hiệu lực (không bắt buộc)
            if (string.IsNullOrEmpty(txtNgayBatDauHieuLuc.Text.Trim()))
            {
                lblThongBaoSapNhap.Text = "Vui lòng chọn ngày bắt đầu hiệu lực!";
                lblThongBaoSapNhap.ForeColor = System.Drawing.Color.Red;
                return false;
            }

            // Kiểm tra ngày bắt đầu hiệu lực (không bắt buộc)
            if (!string.IsNullOrEmpty(txtNgayBatDauHieuLuc.Text.Trim()))
            {
                DateTime ngayBatDau;
                if (!DateTime.TryParseExact(txtNgayBatDauHieuLuc.Text.Trim(), "dd/MM/yyyy", null,
                    System.Globalization.DateTimeStyles.None, out ngayBatDau))
                {
                    lblThongBaoSapNhap.Text = "Ngày bắt đầu hiệu lực không đúng định dạng (dd/MM/yyyy)!";
                    lblThongBaoSapNhap.ForeColor = System.Drawing.Color.Red;
                    return false;
                }
            }

            return true;
        }

        /// <summary>
        /// Xử lý null values trong DataTable để tránh lỗi khi bind vào DataGrid
        /// </summary>
        private void ProcessNullValuesInDataTable(DataTable dt)
        {
            if (dt == null || dt.Rows.Count == 0) return;

            try
            {
                foreach (DataRow row in dt.Rows)
                {
                    // Ngày hiệu lực
                    if (row["NGAYHIEULUC"] == DBNull.Value)
                    {
                        // row["NGAYHIEULUC"] = DateTime.MinValue; // Nếu muốn set giá trị mặc định
                        row["NGAYHIEULUC"] = "";
                    }

                    // Loại sáp nhập
                    if (row["LOAI"] == DBNull.Value)
                    {
                        row["LOAI"] = "";
                    }
                    if (row["LOAITEN"] == DBNull.Value)
                    {
                        row["LOAITEN"] = "";
                    }

                    // Toà Id
                    if (row["TOAANID"] == DBNull.Value)
                    {
                        row["TOAANID"] = "";
                    }
                    if (row["TOAANTEN"] == DBNull.Value)
                    {
                        row["TOAANTEN"] = "";
                    }

                    // To Toà Id
                    if (row["TOTOAANID"] == DBNull.Value)
                    {
                        row["TOTOAANID"] = "";
                    }
                    if (row["TOTOAANTEN"] == DBNull.Value)
                    {
                        row["TOTOAANTEN"] = "";
                    }

                    // Ghi chú
                    if (row["GHICHU"] == DBNull.Value)
                    {
                        row["GHICHU"] = "";
                    }
                }
            }
            catch (Exception ex)
            {
            }
        }

        /// <summary>
        /// Lưu thông tin sáp nhập
        /// </summary>
        protected void btnLuuSapNhap_Click(object sender, EventArgs e)
        {
            try
            {
                // JavaScript validation sẽ xử lý validation trước khi submit
                // Server-side validation cho an toàn bổ sung
                if (!ValidateSapNhapForm())
                    return;

                // Lấy tất cả thông tin cần thiết để lưu
                // ID tòa án hiện tại đang được chọn từ TreeView
                decimal toaAnHienTaiID = 0;
                if (!string.IsNullOrEmpty(hddToaAnID.Value) && decimal.TryParse(hddToaAnID.Value, out toaAnHienTaiID))
                {
                    // Lấy từ hidden field (được set khi chọn TreeView)
                }
                else if (!string.IsNullOrEmpty(treemenu.SelectedValue) && decimal.TryParse(treemenu.SelectedValue, out toaAnHienTaiID))
                {
                    // Fallback: lấy trực tiếp từ TreeView
                }
                else
                {
                    lblThongBaoSapNhap.Text = "Lỗi: Chưa chọn tòa án để quản lý sáp nhập!";
                    lblThongBaoSapNhap.ForeColor = System.Drawing.Color.Red;
                    return;
                }

                // Loại sáp nhập (bắt buộc)
                string loaiSatNhapMa = "";
                if (string.IsNullOrEmpty(dropLoaiSapNhap.SelectedValue))
                {
                    lblThongBaoSapNhap.Text = "Lỗi: Chưa chọn loại sáp nhập!";
                    lblThongBaoSapNhap.ForeColor = System.Drawing.Color.Red;
                    return;
                }
                else
                {
                    loaiSatNhapMa = dropLoaiSapNhap.SelectedValue;
                }

                // ID đơn vị mục tiêu (bắt buộc)
                decimal donViMucTieuID = 0;
                if (!decimal.TryParse(dropDonViMucTieu.SelectedValue, out donViMucTieuID) || donViMucTieuID == 0)
                {
                    lblThongBaoSapNhap.Text = "Lỗi: Chưa chọn đơn vị mục tiêu!";
                    lblThongBaoSapNhap.ForeColor = System.Drawing.Color.Red;
                    return;
                }

                // Ngày bắt đầu hiệu lực (bắt buộc)
                if (string.IsNullOrEmpty(txtNgayBatDauHieuLuc.Text.Trim()))
                {
                    lblThongBaoSapNhap.Text = "Lỗi: Chưa chọn ngày bắt đầu hiệu lực!";
                    lblThongBaoSapNhap.ForeColor = System.Drawing.Color.Red;
                    return;
                }
                DateTime? ngayBatDauHieuLuc = null;
                if (!string.IsNullOrEmpty(txtNgayBatDauHieuLuc.Text.Trim()))
                {
                    DateTime tempDate;
                    if (DateTime.TryParseExact(txtNgayBatDauHieuLuc.Text.Trim(), "dd/MM/yyyy", null, System.Globalization.DateTimeStyles.None, out tempDate))
                    {
                        ngayBatDauHieuLuc = tempDate;
                    }
                    else
                    {
                        lblThongBaoSapNhap.Text = "Lỗi: Ngày bắt đầu hiệu lực không đúng định dạng (dd/MM/yyyy)!";
                        lblThongBaoSapNhap.ForeColor = System.Drawing.Color.Red;
                        return;
                    }
                }

                // TODO: Implement save logic với các thông tin đã lấy được
                BL.GSTP.Danhmuc.DM_TOAAN_TACH_NHAP_MAPPING_BL bl = new BL.GSTP.Danhmuc.DM_TOAAN_TACH_NHAP_MAPPING_BL();
                BL.GSTP.BANGSETGET.DM_TOAAN_TACH_NHAP_MAPPING_GS gs = new BL.GSTP.BANGSETGET.DM_TOAAN_TACH_NHAP_MAPPING_GS();

                var sapNhapEntity = new BL.GSTP.BANGSETGET.DM_TOAAN_TACH_NHAP_MAPPING_GS()
                {
                    NGAYHIEULUC = ngayBatDauHieuLuc.HasValue ? ngayBatDauHieuLuc.Value : (DateTime?)null,
                    LOAI = dropLoaiSapNhap.SelectedValue,
                    TOTOAANID = toaAnHienTaiID,
                    GHICHU = tbGhiChu.Text.Trim(),
                    NGAYTAO = DateTime.Now,
                    NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME].ToString()
                };

                // Thêm
                // Xử lý gán toà Id theo loại sáp nhập
                switch (loaiSatNhapMa)
                {
                    case ENUM_LOAISAPNHAP_MA.NHAP:
                        sapNhapEntity.TOAANID = donViMucTieuID;
                        sapNhapEntity.TOTOAANID = toaAnHienTaiID;
                        break;
                    case ENUM_LOAISAPNHAP_MA.TACH:
                        sapNhapEntity.TOTOAANID = donViMucTieuID;
                        sapNhapEntity.TOAANID = toaAnHienTaiID;
                        break;
                }

                // Kiểm tra là thêm hay sửa
                if (hddSapNhapID.Value != null && hddSapNhapID.Value != "0")
                {
                    // Sửa
                    int sapNhapId = 0;
                    if (int.TryParse(hddSapNhapID.Value, out sapNhapId))
                    {
                        sapNhapEntity.ID = sapNhapId;

                        // Sửa mapping tách nhập
                        bl.EDIT(sapNhapEntity);
                    }
                    else
                    {
                        lblThongBaoSapNhap.Text = "ID bản ghi không hợp lệ!";
                        lblThongBaoSapNhap.ForeColor = System.Drawing.Color.Red;
                        return;
                    }
                }
                else
                {
                    // Thêm mapping tách nhập
                    bl.ADD(sapNhapEntity);
                }

                ResetSapNhapForm();
                LoadSapNhapList();
                LoadTreeview();

                lblThongBaoSapNhap.Text = $"Lưu thành công!";
                lblThongBaoSapNhap.ForeColor = System.Drawing.Color.Green;
            }
            catch (Exception ex)
            {
                lblThongBaoSapNhap.Text = "Lỗi: " + ex.Message;
                lblThongBaoSapNhap.ForeColor = System.Drawing.Color.Red;
            }
        }

        /// <summary>
        /// Xóa sáp nhập
        /// </summary>
        private void DeleteSapNhap(decimal sapNhapID)
        {
            try
            {
                // TODO: Implement delete logic
                BL.GSTP.Danhmuc.DM_TOAAN_TACH_NHAP_MAPPING_BL bl = new BL.GSTP.Danhmuc.DM_TOAAN_TACH_NHAP_MAPPING_BL();

                // Xoá
                bl.DELETE(sapNhapID);

                lblThongBaoSapNhap.Text = "Xóa thành công!";
                lblThongBaoSapNhap.ForeColor = System.Drawing.Color.Green;
                LoadSapNhapList();
                // Load Drop đơn vị mục tiêu
                LoadDropDonViMucTieu();
            }
            catch (Exception ex)
            {
                lblThongBaoSapNhap.Text = "Lỗi xoá dữ liệu: " + ex.Message;
                lblThongBaoSapNhap.ForeColor = System.Drawing.Color.Red;
            }
        }

        /// <summary>
        /// Làm mới form sáp nhập
        /// </summary>
        protected void btnLamMoiSapNhap_Click(object sender, EventArgs e)
        {
            ResetSapNhapForm();
        }

        /// <summary>
        /// Reset form sáp nhập
        /// </summary>
        private void ResetSapNhapForm()
        {
            hddSapNhapID.Value = "0";

            // Load Drop Loại sáp nhập
            LoadDropLoaiSapNhap(dropLoaiSapNhap, true);
            // Mặc định loại sáp nhập là Nhập
            dropLoaiSapNhap.SelectedValue = ENUM_LOAISAPNHAP_MA.NHAP;
            dropLoaiSapNhap.Enabled = true;

            // Load Drop đơn vị mục tiêu
            LoadDropDonViMucTieu();
            // Mặc định cho nhãn Đơn vị mục tiêu
            lblDonViMucTieu.Text = "Đơn vị trước sáp nhập";

            // Set mặc định ngày hiện tại cho thời gian bắt đầu hiệu lực
            DateTime NOW = DateTime.Now;
            txtNgayBatDauHieuLuc.Text = NOW.ToString("dd/MM/yyyy");

            // Clear Ghi chú
            tbGhiChu.Text = "";

            // Clear thông báo
            lblThongBaoSapNhap.Text = "";
        }

        #endregion
    }
}