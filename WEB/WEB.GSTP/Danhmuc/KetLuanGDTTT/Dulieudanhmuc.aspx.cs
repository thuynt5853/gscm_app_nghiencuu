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

namespace WEB.GSTP.Danhmuc.KetLuanGDTTT
{
    public partial class Dulieudanhmuc : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    LoadNhomDanhMuc();
                    LoadListLoaiAn();
                    LoadLayout();
                    LoadData();
                }
            }
            catch (Exception ex) { lbthongbao_DonCap.Text = lbthongbao_DaCap.Text = ex.Message; }
        }
        private void LoadNhomDanhMuc()
        {
            dropNhomDanhMuc.Items.Clear();
            String groupname = ENUM_DANHMUC.KETLUANGDTTT.ToUpper();
            DM_DATAGROUP obj = dt.DM_DATAGROUP.Where(x => x.MA.ToUpper() == groupname).Single();
            if (obj != null)
                dropNhomDanhMuc.Items.Add(new ListItem(obj.TEN, obj.ID.ToString()));
        }

        void LoadListLoaiAn()
        {
            chkLoaiAn.Items.Clear();
            chkLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIAN.AN_HINHSU));
            chkLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIAN.AN_DANSU));
            chkLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIAN.AN_HANHCHINH));
            chkLoaiAn.Items.Add(new ListItem("Hôn nhân & Gia đình", ENUM_LOAIAN.AN_HONNHAN_GIADINH));
            chkLoaiAn.Items.Add(new ListItem("KD & TM", ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI));
            chkLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIAN.AN_LAODONG));
            chkLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIAN.AN_PHASAN));
            chkLoaiAn.Items.Add(new ListItem("Biện pháp XLHC", ENUM_LOAIAN.BPXLHC));
        }
        private void LoadLayout()
        {
            decimal gID =Convert.ToDecimal(dropNhomDanhMuc.SelectedValue);
            DM_DATAGROUP group = dt.DM_DATAGROUP.Where(x => x.ID == gID).FirstOrDefault();
            if (group.LOAI == 2)//Đa cấp
            {
                pnlDonCap.Visible = false;
                pnlDaCap.Visible = true;
                cmdThem_DaCap.Visible = true;
                LoadDropCapCha();
                LoadTreeview();
            }
            else// Đơn cấp
            {
                pnlDonCap.Visible = true;
                pnlDaCap.Visible = false;
                cmdThem_DaCap.Visible = false;
            }
        }
        protected void dropNhomDanhMuc_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                hddParentID.Value = "0";
                lbthongbao_DaCap.Text = lbthongbao_DonCap.Text = "";
                LoadLayout();
                LoadData();
            }
            catch (Exception ex) { lbthongbao_DaCap.Text = lbthongbao_DonCap.Text = ex.Message; }
        }
       
        void LoadInfo(decimal curr_id, DM_DATAGROUP group)
        {
            DM_DATAITEM item = dt.DM_DATAITEM.Where(x => x.ID == curr_id).FirstOrDefault();
            if (group.LOAI == 1)
            {
                txtTen_DonCap.Text = item.TEN;
                txtMa_DonCap.Text = item.MA;
                txtMa_DonCap.Enabled = false;
                txtGhiChu_DonCap.Text = item.MOTA;
                txtThuTu_DonCap.Text = item.THUTU.ToString();
                chkTrangThai_DonCap.Checked = item.HIEULUC == 1 ? true : false;

             
            }
            else
            {
                txtTen_DaCap.Text = item.TEN;
                txtMa_DaCap.Text = item.MA;
                txtMa_DaCap.Enabled = false;
                txtGhiChu_DaCap.Text = item.MOTA;
                txtThuTu_DaCap.Text = item.THUTU.ToString();
                chkTrangThai_DaCap.Checked = item.HIEULUC == 1 ? true : false;
                dropDuLieu_CapCha.SelectedValue = item.CAPCHAID + "";
            }

            DM_DATAITEM_LOAIAN objLoaiAn = dt.DM_DATAITEM_LOAIAN.Where(x => x.DATAITEM_ID == item.ID).Single();
            if (objLoaiAn != null)
            {
                foreach (ListItem loai in chkLoaiAn.Items)
                {
                    switch (loai.Value)
                    {
                        case ENUM_LOAIAN.AN_HINHSU:
                            if (objLoaiAn.ISHINHSU == 1)
                                loai.Selected = true;
                            break;
                        case ENUM_LOAIAN.AN_DANSU:
                            if (objLoaiAn.ISDANSU == 1)
                                loai.Selected = true;
                            break;

                        case ENUM_LOAIAN.AN_HANHCHINH:
                            if (objLoaiAn.ISHANHCHINH == 1)
                                loai.Selected = true;
                            break;
                        case ENUM_LOAIAN.AN_HONNHAN_GIADINH:
                            if (objLoaiAn.ISHNGD == 1)
                                loai.Selected = true;
                            break;

                        case ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI:
                            if (objLoaiAn.ISKDTM == 1)
                                loai.Selected = true;
                            break;
                        case ENUM_LOAIAN.AN_LAODONG:
                            if (objLoaiAn.ISLAODONG == 1)
                                loai.Selected = true;
                            break;

                        case ENUM_LOAIAN.AN_PHASAN:
                            if (objLoaiAn.ISPHASAN == 1)
                                loai.Selected = true;
                            break;
                        case ENUM_LOAIAN.BPXLHC:
                            if (objLoaiAn.ISBPXLHC == 1)
                                loai.Selected = true;
                            break;
                    }
                }
            }
        }
        private void LoadData()
        {
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            string str = txtTimKiem.Text.Trim();
            decimal parentID =Convert.ToDecimal(hddParentID.Value);
            int pageIndex = Convert.ToInt32(hddPageIndex.Value);
            int pageSize = Convert.ToInt32(hddPageSize.Value);
            decimal groupID = Convert.ToDecimal(dropNhomDanhMuc.SelectedValue);
            DataTable lst = oBL.DM_DATAITEM_LOAIAN_SEARCH(groupID, parentID, str, pageIndex, pageSize);
            if (lst.Rows.Count > 0)
            {
                rpt.DataSource = lst;
                rpt.DataBind();
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Convert.ToInt32(lst.Rows[0]["Total"]), pageSize).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + lst.Rows[0]["Total"].ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
                PhanTrang_T.Visible = PhanTrang_D.Visible = rpt.Visible = true;
            }
            else
            {
                PhanTrang_T.Visible = PhanTrang_D.Visible = rpt.Visible = false;
            }
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadData();
            }
            catch (Exception ex) { lbthongbao_DonCap.Text = lbthongbao_DaCap.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                //dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                LoadData();
            }
            catch (Exception ex) { lbthongbao_DonCap.Text = lbthongbao_DaCap.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadData();
            }
            catch (Exception ex) { lbthongbao_DonCap.Text = lbthongbao_DaCap.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadData();
            }
            catch (Exception ex) { lbthongbao_DonCap.Text = lbthongbao_DaCap.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                hddPageIndex.Value = lbCurrent.Text;
                LoadData();
            }
            catch (Exception ex) { lbthongbao_DonCap.Text = lbthongbao_DaCap.Text = ex.Message; }
        }
        #endregion
        #region "Load treeview"
        private void LoadTreeview()
        {
            treemenu.Nodes.Clear();
            TreeNode oRoot = new TreeNode("Dữ liệu danh mục", "0");
            oRoot.ImageUrl = "~/_layouts/images/NCS.UI.MPI.Admin/root.gif";
            treemenu.Nodes.Add(oRoot);
            decimal itemID = 0;
            decimal IDGroup = Convert.ToDecimal(dropNhomDanhMuc.SelectedValue);
            List<DM_DATAITEM> lst = dt.DM_DATAITEM.Where(x => x.GROUPID == IDGroup && x.CAPCHAID == itemID).OrderBy(y => y.ARRTHUTU).ToList();
            foreach (DM_DATAITEM item in lst)
            {
                TreeNode oNode;
                oNode = CreateNode(item.ID.ToString(), item.TEN);
                oRoot.ChildNodes.Add(oNode);
                LoadTreeChild(oNode);
            }
            treemenu.ExpandAll();
            foreach (TreeNode oNode in treemenu.Nodes[0].ChildNodes)
            { oNode.CollapseAll(); }

        }
        private void LoadTreeChild(TreeNode root)
        {
            decimal itemID = Convert.ToDecimal(root.Value);
            List<DM_DATAITEM> listchild = dt.DM_DATAITEM.Where(x => x.CAPCHAID == itemID).OrderBy(y => y.ARRTHUTU).ToList();           
            foreach (DM_DATAITEM child in listchild)
            {
                TreeNode nodechild;
                nodechild = CreateNode(child.ID.ToString(), child.TEN.ToString());
                root.ChildNodes.Add(nodechild);
                LoadTreeChild(nodechild);
            }
        }
        private TreeNode CreateNode(string sNodeId, string sNodeText)
        {
            TreeNode objTreeNode = new TreeNode();
            objTreeNode.Value = sNodeId;
            objTreeNode.Text = sNodeText;
            if (sNodeId == "0")
            {
                objTreeNode.ImageUrl = "~/images/lines/root.gif";
            }
            return objTreeNode;
        }
        #endregion
        private string createArrThuTu(string str, decimal parentID)
        {
            string result = "", temp = "";
            int thutu = Convert.ToInt32(str);
            if (thutu < 10)
            {
                temp = "900" + thutu;
            }
            else if (thutu < 100)
            {
                temp = "90" + thutu;
            }
            else if (thutu < 1000)
            {
                temp = "9" + thutu;
            }
            else
            {
                temp = thutu + "";
            }
            DM_DATAITEM item = null;
            if (parentID != 0)
            {
                item = dt.DM_DATAITEM.Where(x => x.ID== parentID).FirstOrDefault();
            }

            if (item != null)
            {
                result = item.ARRTHUTU + "/" + temp;
            }
            else
            {
                result = temp;
            }
            return result;
        }
        private string createArrSapXep(decimal parentID, decimal itemID)
        {
            string result = "", temp = itemID.ToString();
            DM_DATAITEM item = null;
            if (parentID != 0)
            {
                item = dt.DM_DATAITEM.Where(x => x.ID == parentID).FirstOrDefault();
            }
            if (item != null)
            {
                result = item.ARRSAPXEP + "/" + temp;
            }
            else
            {
                result = temp;
            }
            return result;
        }
        protected void btnUpdate_DonCap_Click(object sender, EventArgs e)
        {
            try
            {
                decimal IDGroup = Convert.ToDecimal(dropNhomDanhMuc.SelectedValue);

                lbthongbao_DonCap.Text = ""; bool isNew = false;
                string ten_DonCap = txtTen_DonCap.Text.Trim();
                string ma_DonCap = txtMa_DonCap.Text.Trim();
                decimal gui_ZeroID =0;
                if (hddid.Value == "0")// Thêm mới
                {
                    List<DM_DATAITEM> lst = dt.DM_DATAITEM.Where(x => x.TEN == ten_DonCap && x.GROUPID == IDGroup).ToList();
                    if (lst.Count > 0)// Đã tồn tại
                    {
                        lbthongbao_DonCap.Text = "Tên này đã tồn tại.";
                        return;
                    }
                    if (!ma_DonCap.Equals(""))
                    {
                        List<DM_DATAITEM> lst_A = dt.DM_DATAITEM.Where(x => x.MA == ma_DonCap && x.GROUPID == IDGroup).ToList();                     
                        if (lst_A.Count > 0)
                        {
                            lbthongbao_DonCap.Text = "Mã này đã tồn tại.";
                            return;
                        }
                    }
                    isNew = true;

                    DM_DATAITEM obj_item = new DM_DATAITEM();
                    
                    obj_item.GROUPID = IDGroup;
                    obj_item.CAPCHAID = gui_ZeroID;
                    obj_item.TEN = txtTen_DonCap.Text;
                    obj_item.MA = txtMa_DonCap.Text;
                    obj_item.MOTA = txtGhiChu_DonCap.Text;
                    string stt = txtThuTu_DonCap.Text.Trim();
                    string arrThuTu = "";
                    if (stt == "")
                    {
                        obj_item.THUTU = 1;
                        arrThuTu = createArrThuTu("1", gui_ZeroID);
                    }
                    else
                    {
                        obj_item.THUTU = Convert.ToInt32(txtThuTu_DonCap.Text);
                        arrThuTu = createArrThuTu(txtThuTu_DonCap.Text, gui_ZeroID);
                    }
                    obj_item.ARRTHUTU = arrThuTu;
                    obj_item.SOCAP = arrThuTu.Split('/').Length;
                    obj_item.HIEULUC = chkTrangThai_DonCap.Checked?1:0;
                    obj_item.NGAYTAO = DateTime.Now;
                    obj_item.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                    dt.DM_DATAITEM.Add(obj_item);
                    dt.SaveChanges();
                    obj_item.ARRSAPXEP = createArrSapXep(obj_item.ID, gui_ZeroID);
                    dt.SaveChanges();
                    hddid.Value = obj_item.ID + "";
                }
                else// Sửa
                {
                    isNew = false;
                    decimal gui = Convert.ToDecimal(hddid.Value);
                    DM_DATAITEM obj_item = dt.DM_DATAITEM.Where(x=>x.ID==gui).FirstOrDefault();
                    if (obj_item != null)
                    {
                        List<DM_DATAITEM> lst = dt.DM_DATAITEM.Where(x => x.TEN == ten_DonCap && x.GROUPID == IDGroup).ToList();
                        if (lst.Count > 0)// Đã tồn tại
                        {
                            if (lst[0].ID != gui)
                            {
                                lbthongbao_DonCap.Text = "Tên này đã tồn tại.";
                                return;
                            }
                        }
                        if (!ma_DonCap.Equals(""))
                        {
                            List<DM_DATAITEM> lst_A = dt.DM_DATAITEM.Where(x => x.MA == ma_DonCap && x.GROUPID == IDGroup).ToList();
                            if (lst_A.Count > 0)
                            {
                                if (lst_A[0].ID != gui)
                                {
                                    lbthongbao_DonCap.Text = "Mã này đã tồn tại.";
                                    return;
                                }
                            }
                        }
                        obj_item.GROUPID = IDGroup;
                       
                        obj_item.TEN = txtTen_DonCap.Text;
                        obj_item.MA = txtMa_DonCap.Text;
                        obj_item.MOTA = txtGhiChu_DonCap.Text;
                     
                        string stt = txtThuTu_DonCap.Text.Trim();
                        string arrThuTu = "";
                        if (stt == "")
                        {
                            obj_item.THUTU = 1;
                            arrThuTu = createArrThuTu("1", gui_ZeroID);
                        }
                        else
                        {
                            obj_item.THUTU = Convert.ToDecimal(txtThuTu_DonCap.Text);
                            arrThuTu = createArrThuTu(txtThuTu_DonCap.Text, gui_ZeroID);
                        }
                        
                        obj_item.ARRTHUTU = arrThuTu;
                        obj_item.SOCAP = arrThuTu.Split('/').Length;
                        obj_item.HIEULUC =chkTrangThai_DonCap.Checked?1:0;
                        obj_item.NGAYSUA = DateTime.Now;
                        obj_item.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                        obj_item.ARRSAPXEP = createArrSapXep(gui_ZeroID, gui);
                        dt.SaveChanges();
                    }
                }
                Update_TheoLoaiAn();

                ResetValue_DonCap();
                hddid.Value = "0";
                if (isNew)// Thêm mới
                {
                    lbthongbao_DonCap.Text = "Thêm mới thành công.";
                }
                else
                {
                    lbthongbao_DonCap.Text = "Lưu thành công.";
                }
                hddPageIndex.Value = "1";
                LoadData();
            }
            catch (Exception ex) { lbthongbao_DonCap.Text = ex.Message; }
        }
        void Update_TheoLoaiAn()
        {
            Boolean IsUpdate = false;
            Decimal CurrId = (string.IsNullOrEmpty(hddid.Value)) ? 0 : Convert.ToDecimal(hddid.Value);
            DM_DATAITEM_LOAIAN obj = new DM_DATAITEM_LOAIAN();
            try
            {
                obj = dt.DM_DATAITEM_LOAIAN.Where(x => x.DATAITEM_ID == CurrId).Single();
                if (obj != null)
                    IsUpdate = true;
                else obj = new DM_DATAITEM_LOAIAN();
            }catch(Exception ex) { obj = new DM_DATAITEM_LOAIAN(); }
            obj.DATAITEM_ID = CurrId;
            obj.ISHINHSU = obj.ISDANSU = 0;
            obj.ISHANHCHINH = obj.ISHNGD = 0;
            obj.ISKDTM = obj.ISLAODONG = 0;
            obj.ISPHASAN = obj.ISBPXLHC = 0;
            foreach (ListItem loai in chkLoaiAn.Items)
            {
                switch (loai.Value)
                {
                    case ENUM_LOAIAN.AN_HINHSU:
                        if (loai.Selected)
                            obj.ISHINHSU = 1;
                        break;
                    case ENUM_LOAIAN.AN_DANSU:
                        if (loai.Selected )
                            obj.ISDANSU = 1;
                        break;

                    case ENUM_LOAIAN.AN_HANHCHINH:
                        if (loai.Selected)
                            obj.ISHANHCHINH = 1;
                        break;
                    case ENUM_LOAIAN.AN_HONNHAN_GIADINH:
                        if (loai.Selected)
                            obj.ISHNGD = 1;
                        break;

                    case ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI:
                        if (loai.Selected)
                            obj.ISKDTM = 1;
                        break;
                    case ENUM_LOAIAN.AN_LAODONG:
                        if (loai.Selected)
                            obj.ISLAODONG = 1;
                        break;

                    case ENUM_LOAIAN.AN_PHASAN:
                        if (loai.Selected)
                            obj.ISPHASAN = 1;
                        break;
                    case ENUM_LOAIAN.BPXLHC:
                        if (loai.Selected)
                            obj.ISBPXLHC = 1;
                        break;
                }
            }

            if (!IsUpdate) dt.DM_DATAITEM_LOAIAN.Add(obj);
            dt.SaveChanges();
        }
        protected void Btntimkiem_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadData();
            }
            catch (Exception ex) { lbthongbao_DaCap.Text = lbthongbao_DonCap.Text = ex.Message; }
        }
        protected void btnUpdate_DaCap_Click(object sender, EventArgs e)
        {
            try
            {
                decimal IDGroup = Convert.ToDecimal(dropNhomDanhMuc.SelectedValue);

                lbthongbao_DaCap.Text = "";
                string ten_DaCap = txtTen_DonCap.Text.Trim();
                string ma_DaCap = txtMa_DonCap.Text.Trim();
                bool isNew = false;
                decimal parentID = Convert.ToDecimal(dropDuLieu_CapCha.SelectedValue);
                DM_DATAITEM parent = null;
                if (parentID != 0)
                {
                    parent = dt.DM_DATAITEM.Where(x => x.ID == parentID).FirstOrDefault(); 
                }
                if (hddid.Value == "0")// Thêm mới
                {
                    isNew = true;
                    List<DM_DATAITEM> lst = dt.DM_DATAITEM.Where(x => x.TEN == ten_DaCap && x.GROUPID == IDGroup).ToList(); 
                    if (lst.Count > 0)// Đã tồn tại
                    {
                        lbthongbao_DaCap.Text = "Tên này đã tồn tại.";
                        return;
                    }
                    if (!ma_DaCap.Equals(""))
                    {
                        List<DM_DATAITEM> lst_A = dt.DM_DATAITEM.Where(x => x.MA == ma_DaCap && x.GROUPID == IDGroup).ToList(); 
                        if (lst_A.Count > 0)
                        {
                            lbthongbao_DaCap.Text = "Mã này đã tồn tại.";
                            return;
                        }
                    }

                    DM_DATAITEM obj_item = new DM_DATAITEM();
                   
                    obj_item.GROUPID = IDGroup;
                    obj_item.TEN = txtTen_DaCap.Text;
                    obj_item.MA = txtMa_DaCap.Text;
                    obj_item.CAPCHAID = parentID;
                    if (parent != null)
                    {
                        obj_item.MACAPCHA = parent.MA;
                    }
                    obj_item.MOTA = txtGhiChu_DaCap.Text;
                    string stt = txtThuTu_DaCap.Text.Trim();
                    string arrThuTu = "";
                    if (stt == "")
                    {
                        obj_item.THUTU = 1;
                        arrThuTu = createArrThuTu("1", parentID);
                    }
                    else
                    {
                        obj_item.THUTU = Convert.ToInt32(txtThuTu_DaCap.Text);
                        arrThuTu = createArrThuTu(txtThuTu_DaCap.Text, parentID);
                    }
                   
                    obj_item.ARRTHUTU = arrThuTu;
                    obj_item.SOCAP = arrThuTu.Split('/').Length;
                    obj_item.HIEULUC = chkTrangThai_DaCap.Checked?1:0;
                    obj_item.NGAYTAO = DateTime.Now;
                    obj_item.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.DM_DATAITEM.Add(obj_item);
                    dt.SaveChanges();
                    obj_item.ARRSAPXEP = createArrSapXep(parentID, obj_item.ID);
                    dt.SaveChanges();

                 
                }
                else// Sửa
                {
                    isNew = false;
                  
                    decimal gui = Convert.ToDecimal(hddid.Value);
                    DM_DATAITEM obj_item = dt.DM_DATAITEM.Where(x => x.ID == gui).FirstOrDefault();
                    if (obj_item != null)
                    {
                        List<DM_DATAITEM> lst = dt.DM_DATAITEM.Where(x => x.TEN == ten_DaCap && x.GROUPID == IDGroup).ToList();
                        if (lst.Count > 0)// Đã tồn tại
                        {
                            if (lst[0].ID != gui)
                            {
                                lbthongbao_DaCap.Text = "Tên này đã tồn tại.";
                                return;
                            }
                        }
                        if (!ma_DaCap.Equals(""))
                        {
                            List<DM_DATAITEM> lst_A = dt.DM_DATAITEM.Where(x => x.MA == ma_DaCap && x.GROUPID == IDGroup).ToList();
                            if (lst_A.Count > 0)
                            {
                                if (lst_A[0].ID != gui)
                                {
                                    lbthongbao_DaCap.Text = "Mã này đã tồn tại.";
                                    return;
                                }
                            }
                        }
                        obj_item.GROUPID = IDGroup;
                        obj_item.TEN = txtTen_DaCap.Text;
                        obj_item.MA = txtMa_DaCap.Text;
                        obj_item.CAPCHAID = parentID;
                        if (parent != null)
                        {
                            obj_item.MACAPCHA = parent.MA;
                        }
                        obj_item.MOTA = txtGhiChu_DaCap.Text;                    
                        string stt = txtThuTu_DaCap.Text.Trim();
                        string arrThuTu = "";
                        if (stt == "")
                        {
                            obj_item.THUTU = 1;
                            arrThuTu = createArrThuTu("1", parentID);
                        }
                        else
                        {
                            obj_item.THUTU = Convert.ToInt32(txtThuTu_DaCap.Text);
                            arrThuTu = createArrThuTu(txtThuTu_DaCap.Text, parentID);
                        }
                       
                        obj_item.ARRTHUTU = arrThuTu;
                        obj_item.SOCAP = arrThuTu.Split('/').Length;
                        obj_item.HIEULUC = chkTrangThai_DaCap.Checked?1:0;
                        obj_item.NGAYSUA= DateTime.Now;
                        obj_item.NGUOISUA= Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        updateChildArrThuTu_ArrSapXep(obj_item.ID);
                        dt.SaveChanges();
                    }
                }
                ResetValue_DaCap(); hddid.Value = "0";
                if (isNew)// Thêm mới
                {
                    lbthongbao_DaCap.Text = "Thêm mới thành công.";
                }
                else
                {
                    lbthongbao_DaCap.Text = "Lưu thành công.";
                }
                LoadData();
                LoadTreeview();
                LoadDropCapCha();
            }
            catch (Exception ex) { lbthongbao_DaCap.Text = ex.Message; }
        }
        private void updateChildArrThuTu_ArrSapXep(decimal parentID)
        {
            List<DM_DATAITEM> lst = dt.DM_DATAITEM.Where(x => x.CAPCHAID == parentID).ToList();
            if (lst.Count > 0)
            {
                foreach (DM_DATAITEM item in lst)
                {
                    item.ARRTHUTU = createArrThuTu(item.THUTU.ToString(), parentID);
                    item.ARRSAPXEP = createArrSapXep(parentID, item.ID);
                    updateChildArrThuTu_ArrSapXep(item.ID);
                }
            }
        }
        private void LoadDropCapCha()
        {
            dropDuLieu_CapCha.Items.Clear();
            dropDuLieu_CapCha.Items.Add(new ListItem("----- Chọn -----", "0"));
            decimal groupID = Convert.ToDecimal(dropNhomDanhMuc.SelectedValue);
            decimal parentID = 0;
            List<DM_DATAITEM> lst = dt.DM_DATAITEM.Where(x => x.CAPCHAID == parentID && x.GROUPID == groupID).OrderBy(y => y.ARRTHUTU).ToList();
            int cap = 0;
            string temp = "", prefix = "...";
            foreach (DM_DATAITEM item in lst)
            {
                cap = item.ARRTHUTU.ToString().Split('/').Length;
                temp = "";
                if (cap >= 2)
                {
                    for (int i = 2; i <= cap; i++)
                    {
                        temp += prefix;
                    }
                }
                dropDuLieu_CapCha.Items.Add(new ListItem(temp + item.TEN, item.ID.ToString()));
                LoadDataItemChild(item.ID, groupID);
            }
            dropDuLieu_CapCha.SelectedValue = hddParentID.Value;
        }
        private void LoadDataItemChild(decimal parentID, decimal groupID)
        {
            List<DM_DATAITEM> lst = dt.DM_DATAITEM.Where(x => x.CAPCHAID == parentID && x.GROUPID == groupID).OrderBy(y => y.ARRTHUTU).ToList();
            int cap = 0;
            string temp = "", prefix = "...";
            foreach (DM_DATAITEM item in lst)
            {
                cap = item.ARRTHUTU.ToString().Split('/').Length;
                temp = "";
                if (cap >= 2)
                {
                    for (int i = 2; i <= cap; i++)
                    {
                        temp += prefix;
                    }
                }
                dropDuLieu_CapCha.Items.Add(new ListItem(temp + item.TEN, item.ID.ToString()));
                LoadDataItemChild(item.ID, groupID);
            }
        }
        protected void treemenu_SelectedNodeChanged(object sender, EventArgs e)
        {
            try
            {
                hddid.Value = hddParentID.Value = treemenu.SelectedValue.ToString();
                Load_Item_DaCap_Info(Convert.ToDecimal(hddParentID.Value));
                LoadData();
            }
            catch (Exception ex) { lbthongbao_DaCap.Text = ex.Message; }
        }
        private void Load_Item_DaCap_Info(decimal itemID)
        {
            DM_DATAITEM item = dt.DM_DATAITEM.Where(x => x.ID==itemID).FirstOrDefault();
            if (item != null)
            {
                txtTen_DaCap.Text = item.TEN;
                txtMa_DaCap.Text = item.MA;
                dropDuLieu_CapCha.SelectedValue = item.CAPCHAID.ToString();
                txtGhiChu_DaCap.Text = item.MOTA;
                txtThuTu_DaCap.Text = item.THUTU.ToString();              
                chkTrangThai_DaCap.Checked = item.HIEULUC==1?true:false;
            }
        }
        private void Delete_DataItem(decimal ID)
        {
            List<DM_DATAITEM> lst = dt.DM_DATAITEM.Where(x => x.CAPCHAID==ID).ToList();
            if (lst.Count > 0)
            {
                lbthongbao_DaCap.Text = lbthongbao_DonCap.Text = "Dữ liệu danh mục này có cấp con không xóa được.";
                return;
            }
            else
            {
                DM_DATAITEM_LOAIAN obj = dt.DM_DATAITEM_LOAIAN.Where(x => x.DATAITEM_ID == ID).Single();
                dt.DM_DATAITEM_LOAIAN.Remove(obj);

                DM_DATAITEM del = dt.DM_DATAITEM.Where(x => x.ID == ID).FirstOrDefault();
                dt.DM_DATAITEM.Remove(del);

                dt.SaveChanges();
                hddPageIndex.Value = "1";
                LoadData();
                try
                {
                    LoadDropCapCha();
                    LoadTreeview();
                }catch(Exception ex) { }
            }
        }
        protected void btnXoa_DonCap_Click(object sender, EventArgs e)
        {
            try
            {
                if (hddid.Value == "0")
                {
                    lbthongbao_DonCap.Text = "Hãy chọn dữ liệu danh mục cần xóa.";
                }
                else
                {
                    decimal cur_id = Convert.ToDecimal(hddid.Value);
                    Delete_DataItem(cur_id);

                    ResetValue_DonCap();
                    hddid.Value = "0";
                    lbthongbao_DonCap.Text = "Xóa thành công.";
                    hddPageIndex.Value = "1";
                    LoadData();
                }
            }
            catch (Exception ex) { lbthongbao_DonCap.Text = ex.Message; }
        }
        protected void btnXoa_DaCap_Click(object sender, EventArgs e)
        {
            try
            {
                if (hddid.Value == "0")
                {
                    lbthongbao_DaCap.Text = "Hãy chọn dữ liệu danh mục cần xóa.";
                }
                else
                {
                    decimal cur_id = Convert.ToDecimal(hddid.Value);
                    Delete_DataItem(cur_id);
                    ResetValue_DaCap();
                    hddid.Value = "0";
                    lbthongbao_DaCap.Text = "Xóa thành công.";
                    hddPageIndex.Value = "1";
                    LoadData();
                }
            }
            catch (Exception ex) { lbthongbao_DaCap.Text = ex.Message; }
        }
     
        protected void btnThem_DonCap_Click(object sender, EventArgs e)
        {
            ResetValue_DonCap(); hddid.Value = "0";
        }
        protected void btnThem_DaCap_Click(object sender, EventArgs e)
        {
            ResetValue_DaCap(); hddid.Value = "0"; dropDuLieu_CapCha.SelectedValue = hddParentID.Value;
        }
        protected void btnLamMoi_DonCap_Click(object sender, EventArgs e)
        {
            ResetValue_DonCap();
            hddid.Value = "0";// nut them moi dl
        }
        protected void btnLamMoi_DaCap_Click(object sender, EventArgs e)
        {
            ResetValue_DaCap();
        }
        private void ResetValue_DonCap()
        {
            lbthongbao_DonCap.Text = txtTen_DonCap.Text = txtMa_DonCap.Text = txtGhiChu_DonCap.Text = txtThuTu_DonCap.Text = "";
            decimal IDGroup = Convert.ToDecimal(dropNhomDanhMuc.SelectedValue);
            List<DM_DATAITEM> lst = dt.DM_DATAITEM.Where(x => x.GROUPID == IDGroup).ToList();
            txtThuTu_DonCap.Text = (lst.Count + 1).ToString();
            txtTen_DonCap.Focus();
            // chkTrangThai_DonCap.Checked = false;
            txtMa_DonCap.Enabled = true;
            LoadListLoaiAn();
        }
        private void ResetValue_DaCap()
        {
            lbthongbao_DaCap.Text = txtTen_DaCap.Text = txtMa_DaCap.Text = txtGhiChu_DaCap.Text = txtThuTu_DaCap.Text = "";
            dropDuLieu_CapCha.SelectedValue = hddParentID.Value;
            //chkTrangThai_DaCap.Checked = false;
            decimal IDGroup = Convert.ToDecimal(dropNhomDanhMuc.SelectedValue);
            decimal IDCapcha = Convert.ToDecimal(dropDuLieu_CapCha.SelectedValue);
            List<DM_DATAITEM> lst = dt.DM_DATAITEM.Where(x => x.GROUPID == IDGroup&& x.CAPCHAID== IDCapcha).ToList();
            txtThuTu_DaCap.Text = (lst.Count + 1).ToString();
            txtTen_DaCap.Focus();
            txtMa_DaCap.Enabled = true;
        }

        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            try
            {
                decimal curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
                decimal gID = Convert.ToDecimal(dropNhomDanhMuc.SelectedValue);
                DM_DATAGROUP group = dt.DM_DATAGROUP.Where(x => x.ID == gID).FirstOrDefault();
                switch (e.CommandName)
                {
                    case "Sua":
                        lbthongbao_DaCap.Text = lbthongbao_DonCap.Text = "";
                        hddid.Value = e.CommandArgument.ToString();
                        LoadInfo(curr_id, group);
                        break;
                    case "Xoa":
                        // Kiểm tra quyền truy cập
                        Delete_DataItem(curr_id);
                        if (group.LOAI == 1)
                        {
                            ResetValue_DonCap();
                            lbthongbao_DonCap.Text = "Xóa thành công.";
                        }
                        else
                        {
                            ResetValue_DaCap();
                            lbthongbao_DaCap.Text = "Xóa thành công.";
                        }
                        hddid.Value = "0";
                        break;
                }
            }
            catch (Exception ex) { lbthongbao_DonCap.Text = lbthongbao_DaCap.Text = ex.Message; }
        }
    }
}