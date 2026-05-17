using DAL.GSTP;
using BL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Data;
using BL.GSTP.Danhmuc;
using System.Globalization;
using System.Web.UI.WebControls;

namespace WEB.GSTP.Danhmuc.BoLuat
{
    public partial class ToiDanh : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    LoadDropHieuLuc();
                    LoadThongTinBoLuat();

                    pnHinhPhat.Visible = false;
                    LoadListHinhPhat();
                    LoadGrid();
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        void LoadThongTinBoLuat()
        {
            int luatid = (Request["vID"] != null) ? Convert.ToInt32(Request["vID"] + "") : 0;
            if(luatid >0)
            {
                DM_BOLUAT obj = dt.DM_BOLUAT.Where(x => x.ID == luatid).Single<DM_BOLUAT>();
                if(obj != null)
                {
                    lttTenBoLuat.Text = "<b>" + obj.TENBOLUAT + "</b>";
                }
            }
        }
        void LoadDropHieuLuc()
        {
            dropHieuLuc.Items.Clear();
            dropHieuLuc.Items.Add(new ListItem("-----Tất cả------", "2"));
            dropHieuLuc.Items.Add(new ListItem("Đang sử dụng", "1"));
            dropHieuLuc.Items.Add(new ListItem("Không sử dụng", "0"));
        }
        
        protected void cmdQuayLai_Click(object sender, EventArgs e)
        {
            Response.Redirect("Danhsach.aspx");
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            DM_BOLUAT_TOIDANH obj = new DM_BOLUAT_TOIDANH();
            int CurrID = 0;
            if (hddToiDanh.Value != "" && hddToiDanh.Value != "0")
            {
                CurrID = Convert.ToInt32(hddToiDanh.Value);
                obj = dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == CurrID).FirstOrDefault();
                if (obj != null)
                {
                    obj.NGAYSUA = DateTime.Now;
                    obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] +"";
                }
            }
            obj.LUATID = Convert.ToInt32(Request["vID"] + "");
            obj.HIEULUC = (chkActive.Checked) ? 1 : 0;
            obj.TENTOIDANH = txtTenToiDanh.Text.Trim();
            obj.CHITIETTOIDANH = txtChiTietToiDanh.Text.Trim();
            obj.DIEM = txtDiem.Text.Trim();
            obj.KHOAN = txtKhoan.Text.Trim();
            obj.DIEU = txtDieu.Text.Trim();
            obj.CHUONG = txtChuong.Text.Trim();
            obj.COHINHPHAT = (chkIsHinhPhat.Checked) ? 1 : 0;
            
            if (CurrID == 0)
            {               
                obj.NGAYTAO = obj.NGAYSUA =DateTime.Now;
                obj.NGUOISUA = obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME]+"";                
                dt.DM_BOLUAT_TOIDANH.Add(obj);
            }
            dt.SaveChanges();

            CurrID = Convert.ToInt32(obj.ID);
            UpdateHinhPhat(CurrID);

            //------------------------
            hddPageIndex.Value = "1";
            LoadGrid();
            Resetcontrol();
            lbthongbao.Text = "Lưu thành công!";
        }

      
        void UpdateHinhPhat(int ToiDanhID)
        {           
            DM_BOLUAT_TOIDANH_HINHPHAT obj = new DM_BOLUAT_TOIDANH_HINHPHAT();
            String StrXoa = ",";
            String Temp = ",";
            
            DM_BOLUAT_TOIDANH_HINHPHAT_BL objBL = new DM_BOLUAT_TOIDANH_HINHPHAT_BL();
            DataTable tbl = objBL.GetByToiDanhID(ToiDanhID);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                foreach (DataRow row in tbl.Rows)
                    Temp += row["HINHPHATID"] + ",";
            }

            //---------------------------------
            Decimal HinhPhatID = 0;

            foreach (TreeNode node in treeHinhPhat.Nodes)
            {
                    if (node.ChildNodes.Count > 0)
                    {
                        foreach (TreeNode nodeChild in node.ChildNodes)
                        {
                            if (nodeChild.Checked)
                            {
                                if (!Temp.Contains("," + nodeChild.Value + ","))
                                {
                                    //Them moi
                                    HinhPhatID = Convert.ToDecimal(nodeChild.Value);
                                    obj = dt.DM_BOLUAT_TOIDANH_HINHPHAT.Where(x => x.TOIDANHID == ToiDanhID 
                                                                                && x.HINHPHATID == HinhPhatID).FirstOrDefault();
                                    if (obj == null)
                                    {
                                        obj = new DM_BOLUAT_TOIDANH_HINHPHAT();
                                        obj.TOIDANHID = ToiDanhID;
                                        obj.HINHPHATID = HinhPhatID;
                                        obj.NGAYTAO = obj.NGAYSUA = DateTime.Now;
                                        obj.NGUOISUA = obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                        dt.DM_BOLUAT_TOIDANH_HINHPHAT.Add(obj);
                                        dt.SaveChanges();
                                    }
                                }
                            }
                            else
                            {
                                if (Temp.Contains("," + nodeChild.Value + ","))
                                    StrXoa += nodeChild.Value + ",";
                            }
                        }
                    }
            }
            //------------------------
            if (StrXoa != ",")
            {
                String[] arr = StrXoa.Split(',');
                foreach (String item_del in arr)
                {
                    if (item_del.Length > 0)
                    {
                        HinhPhatID = Convert.ToInt32(item_del);
                        DM_BOLUAT_TOIDANH_HINHPHAT oT = dt.DM_BOLUAT_TOIDANH_HINHPHAT.Where(x => x.TOIDANHID == ToiDanhID && x.HINHPHATID == HinhPhatID).FirstOrDefault();
                        if (oT != null)
                            dt.DM_BOLUAT_TOIDANH_HINHPHAT.Remove(oT);                       
                    }
                }
                dt.SaveChanges();
            }
        }
        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            Resetcontrol();
        }
        protected void Resetcontrol()
        {
            hddToiDanh.Value = "0";
            txtTenToiDanh.Text = txtDiem.Text = txtDieu.Text = txtKhoan.Text = txtChiTietToiDanh.Text = "";

            chkIsHinhPhat.Checked = true;
            chkActive.Checked = false;
            chkIsHinhPhat.Checked = false;
            ResetTree();
        }
        void ResetTree()
        {
            foreach (TreeNode node in treeHinhPhat.Nodes)
            {
                node.Checked = false;

                if (node.ChildNodes.Count > 0)
                {
                    foreach (TreeNode nodeChild in node.ChildNodes)
                    {
                        nodeChild.Checked = false;
                    }
                }
            }
        }
        public void LoadInfo(decimal ID)
        {
            DM_BOLUAT_TOIDANH oT = dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == ID).FirstOrDefault();
            if (oT == null) return;
            {
                txtTenToiDanh.Text = oT.TENTOIDANH;
                chkActive.Checked = (Convert.ToInt32(oT.HIEULUC) == 0) ? false : true;
                chkIsHinhPhat.Checked = (Convert.ToInt32(oT.COHINHPHAT) == 0) ? false : true;
                txtChiTietToiDanh.Text = oT.CHITIETTOIDANH;
                txtDiem.Text = oT.DIEM + "";
                txtDieu.Text = oT.DIEU + "";
                txtKhoan.Text = oT.KHOAN + "";
                txtChuong.Text = oT.CHUONG + "";
                hddToiDanh.Value = ID.ToString();

                SetSelectedValue(oT.ID);
            }
        }
        void SetSelectedValue(decimal ToiDanhID)
        {
            DM_BOLUAT_TOIDANH_HINHPHAT_BL objBL = new DM_BOLUAT_TOIDANH_HINHPHAT_BL();
            DataTable tbl = objBL.GetByToiDanhID(ToiDanhID);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                chkIsHinhPhat.Checked = pnHinhPhat.Visible = true;
                foreach (DataRow row in tbl.Rows)
                {
                    foreach (TreeNode node in treeHinhPhat.Nodes)
                    {
                        if (node.Value == row["HINHPHATID"].ToString())
                            node.Checked = true;
                        else {
                            if (node.ChildNodes.Count > 0)
                            {
                                foreach (TreeNode nodeChild in node.ChildNodes)
                                {
                                    if (nodeChild.Value == row["HINHPHATID"].ToString())
                                    {
                                        nodeChild.Checked = true;
                                        node.ExpandAll();
                                    }
                                }
                            }
                         }
                    }
                }
            }
            else
                chkIsHinhPhat.Checked = pnHinhPhat.Visible = false;
        }

        public void LoadGrid()
        {
            string textsearch = txttimkiem.Text.Trim();
            int hieuluc = Convert.ToInt32(dropHieuLuc.SelectedValue);
            int pagesize = 20;
            int pageindex = Convert.ToInt32(hddPageIndex.Value);

            int luatid = Convert.ToInt32(Request["vID"]+"");
            DM_BOLUAT_TOIDANH_BL objBL = new DM_BOLUAT_TOIDANH_BL();
            DataTable tbl = objBL.GetAllByLuatID_Paging(luatid, textsearch,"", "", "", "", hieuluc, pageindex, pagesize);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                int count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");

                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, pagesize).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion

                rpt.DataSource = tbl;
                rpt.DataBind();
                pndata.Visible = true;
            }
            else
            {
                pndata.Visible = false;
                lbthongbao.Text = "Không tìm thấy dữ liệu phù hợp điều kiện!";
            }
        }
       
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
               // rpt.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
               
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
               // rpt.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
              //  rpt.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
               // rpt.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
                hddPageIndex.Value = lbCurrent.Text;
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #endregion
        protected void Btntimkiem_Click(object sender, EventArgs e)
        {
            try
            {               
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            lbthongbao.Text = "";
            decimal curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "hinhphat":
                    Response.Redirect("HinhPhat.aspx?tID=" + curr_id);
                    break;
                case "Sua":
                    Resetcontrol();
                    LoadInfo(curr_id);
                    hddToiDanh.Value = e.CommandArgument.ToString();
                    break;
                case "Xoa":
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (oPer.XOA == false)
                    {
                        lbthongbao.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    xoa(curr_id);
                    Resetcontrol();

                    break;
            }
        }
        public void xoa(decimal id)
        {
            List<DM_BOLUAT_TOIDANH_HINHPHAT> lst = dt.DM_BOLUAT_TOIDANH_HINHPHAT.Where(x => x.TOIDANHID == id).ToList();
            if (lst.Count > 0)
            {
                lbthongbao.Text = "Nhóm danh mục đã có dữ liệu, không thể xóa được.";
                return;
            }

            DM_BOLUAT_TOIDANH oT = dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == id).FirstOrDefault();
            dt.DM_BOLUAT_TOIDANH.Remove(oT);
            dt.SaveChanges();

            Resetcontrol();
            hddPageIndex.Value = "1";
            LoadGrid();
            lbthongbao.Text = "Xóa thành công!";
        }
        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                    Cls_Comon.SetLinkButton(lblSua, oPer.CAPNHAT);

                    LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                    Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);
            }
        }


        void LoadListHinhPhat()
        {
            treeHinhPhat.Nodes.Clear();
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.NHOMHINHPHAT);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                TreeNode node = null;
                foreach (DataRow row in tbl.Rows)
                {
                    node = new TreeNode(row["Ten"] + "","g_" +row["ID"] + "");
                    treeHinhPhat.Nodes.Add(node);
                    LoadNodeChild(node);
                }
            }
        }
       void LoadNodeChild(TreeNode nodeparent)
        {
            TreeNode node = null;
            Decimal Nhom = Convert.ToDecimal( nodeparent.Value.Replace("g_", ""));
            List<DM_HINHPHAT> lst = dt.DM_HINHPHAT.Where(x => x.NHOMHINHPHAT == Nhom).ToList<DM_HINHPHAT>();
            if (lst != null)
            {
                foreach (DM_HINHPHAT obj in lst)
                {
                    node = new TreeNode(obj.TENHINHPHAT, obj.ID.ToString());
                    nodeparent.ChildNodes.Add(node);
                }
            }
        }

        protected void chkIsHinhPhat_CheckedChanged(object sender, EventArgs e)
        {
            if (chkIsHinhPhat.Checked)               
                pnHinhPhat.Visible = true;
            else
                pnHinhPhat.Visible = false;
        }
    }
}