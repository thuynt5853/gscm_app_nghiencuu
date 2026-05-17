using DAL.GSTP;
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
using BL.GSTP;

namespace WEB.GSTP.Danhmuc.HinhPhat
{
    public partial class Danhsach : System.Web.UI.Page
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
                    LoadDropNhomHinhPhat();
                    LoadDropLoaiGiaTriHP();
                    LoadGrid();

                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        void LoadDropNhomHinhPhat()
        {
            dropNhomHinhPhat.Items.Clear();
            dropNhom.Items.Clear();

            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.NHOMHINHPHAT);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                ListItem item = null;
                foreach (DataRow row in tbl.Rows)
                {
                    item = new ListItem(row["Ten"] + "", row["ID"] + "");
                    dropNhomHinhPhat.Items.Add(item);
                    dropNhom.Items.Add(item);
                }
            }
        }
        void LoadDropLoaiGiaTriHP()
        {
            dropLoaiHinhPhat.Items.Clear();
            dropLoaiHinhPhat.Items.Add(new ListItem("-----Tất cả------", ""));
            dropLoaiHinhPhat.Items.Add(new ListItem("Có / Không", ENUM_LOAIHINHPHAT.DANG_TRUE_FALSE_VALUE.ToString()));
            dropLoaiHinhPhat.Items.Add(new ListItem("Thời gian", ENUM_LOAIHINHPHAT.DANG_THOI_GIAN_VALUE.ToString()));
            dropLoaiHinhPhat.Items.Add(new ListItem("Số học", ENUM_LOAIHINHPHAT.DANG_SO_HOC_VALUE.ToString()));
            dropLoaiHinhPhat.Items.Add(new ListItem("Khác", ENUM_LOAIHINHPHAT.DANG_KHAC_VALUE.ToString()));
            dropLoaiHinhPhat.Items.Add(new ListItem("Mặc định chọn", ENUM_LOAIHINHPHAT.DEFAULT_TRUE.ToString()));
        }
        void LoadDropHieuLuc()
        {
            dropHieuLuc.Items.Clear();
            dropHieuLuc.Items.Add(new ListItem("-----Tất cả------", "2"));
            dropHieuLuc.Items.Add(new ListItem("Đang sử dụng", "1"));
            dropHieuLuc.Items.Add(new ListItem("Không sử dụng", "0"));
        }

        //-----------------------------------------------
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            DM_HINHPHAT obj = new DM_HINHPHAT();
            int CurrID = (string.IsNullOrEmpty(hddCurrID.Value)) ? 0 : Convert.ToInt32(hddCurrID.Value);
            decimal nhomhinhphat = Convert.ToDecimal(dropNhomHinhPhat.SelectedValue);

            //--check--------------------------------
            String mahinhphat = txtMa.Text.Trim();
            string tenhinhphat = txtTen.Text.Trim();
            try
            {
                List<DM_HINHPHAT> lst = dt.DM_HINHPHAT.Where(x => x.NHOMHINHPHAT == nhomhinhphat && x.TENHINHPHAT.ToLower().Contains(tenhinhphat.ToLower())).ToList<DM_HINHPHAT>();
                if (lst != null && lst.Count > 0)
                {
                    obj = lst[0];
                    if (obj.ID != CurrID)
                    {
                        Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Đã có hình phạt này trong nhóm " + dropNhomHinhPhat.SelectedItem.Text);
                        return;
                    }
                    else
                    {
                        obj.NGAYSUA = DateTime.Now;
                        obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    }
                }
                else
                {
                    if (CurrID > 0)
                    {
                        obj = dt.DM_HINHPHAT.Where(x => x.ID == CurrID).SingleOrDefault();
                        obj.NGAYSUA = DateTime.Now;
                        obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    }
                    else
                        obj = new DM_HINHPHAT();
                }
            }
            catch (Exception ex)
            { obj = new DM_HINHPHAT(); }

            obj.ISANTREO = Convert.ToDecimal(rdAnTreo.SelectedValue);
            obj.HIEULUC = Convert.ToDecimal(rdHieuLuc.SelectedValue);
            obj.MAHINHPHAT = mahinhphat;
            obj.TENHINHPHAT = tenhinhphat;
            obj.NHOMHINHPHAT = nhomhinhphat;
            obj.LOAIHINHPHAT = Convert.ToDecimal(dropLoaiHinhPhat.SelectedValue);
            obj.MOTA = txtMoTa.Text.Trim();
            obj.MUCDO = Convert.ToDecimal(txtThuTu.Text.Trim());

            if (CurrID == 0)
            {
                obj.NGAYTAO = DateTime.Now;
                obj.NGAYSUA = DateTime.Now;
                obj.NGUOISUA = obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                dt.DM_HINHPHAT.Add(obj);
            }

            dt.SaveChanges();

            //------------------------
            hddPageIndex.Value = "1";
            LoadGrid();           
            Resetcontrol();
            lbthongbao.Text = "Lưu thành công!";
        }

        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            Resetcontrol();
        }
        protected void Resetcontrol()
        {
            lbthongbao.Text = "";
            hddCurrID.Value = "0";
            txtThuTu.Text = txtTen.Text = txtMa.Text = txtMoTa.Text = "";
            rdAnTreo.SelectedIndex = rdHieuLuc.SelectedIndex = -1;
            dropNhomHinhPhat.SelectedIndex = 0;
            dropLoaiHinhPhat.SelectedIndex = 0;
            dropHieuLuc.SelectedValue = "1";
        }

        public void LoadInfo(decimal ID)
        {
            DM_HINHPHAT oT = dt.DM_HINHPHAT.Where(x => x.ID == ID).FirstOrDefault();
            if (oT == null) return;
            {
                txtMa.Text = oT.MAHINHPHAT;
                txtTen.Text = oT.TENHINHPHAT;
                txtMoTa.Text = oT.MOTA;
                txtThuTu.Text =oT.MUCDO+"";
                rdHieuLuc.SelectedValue = oT.HIEULUC + "";
                rdAnTreo.SelectedValue = oT.ISANTREO + "";
                dropNhomHinhPhat.SelectedValue = (string.IsNullOrEmpty(oT.NHOMHINHPHAT + "")) ? "" : oT.NHOMHINHPHAT.ToString();
                dropLoaiHinhPhat.SelectedValue = (string.IsNullOrEmpty(oT.LOAIHINHPHAT + "")) ? "" : oT.LOAIHINHPHAT.ToString();
            }
        }      
        public void LoadGrid()
        {
            lbthongbao.Text = "";
            string textsearch = txttimkiem.Text.Trim();
            int hieuluc = Convert.ToInt32(dropHieuLuc.SelectedValue);
            int page_size = 10;
            int pageindex = Convert.ToInt32(hddPageIndex.Value);
            int nhom = Convert.ToInt32(dropNhom.SelectedValue);
            DM_HINHPHAT_BL objBL = new DM_HINHPHAT_BL();
            DataTable tbl = objBL.GetAllPaging(nhom, textsearch, hieuluc, pageindex, page_size);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                int count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");

                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
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
        protected void Btntimkiem_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
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
        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Sua":
                    lbthongbao.Text = "";
                    LoadInfo(curr_id);
                    hddCurrID.Value = e.CommandArgument.ToString();
                    break;
                case "Xoa":
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (oPer.XOA == false)
                    {
                        lbthongbao.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    xoa(curr_id);
                    hddPageIndex.Value = "1";
                    LoadGrid();
                    break;
            }
        }
        public void xoa(decimal id)
        {
            List<DM_BOLUAT_TOIDANH_HINHPHAT> lst = dt.DM_BOLUAT_TOIDANH_HINHPHAT.Where(x => x.HINHPHATID == id).ToList();
            if (lst.Count > 0)
            {
                lbthongbao.Text = "Hình phạt này đã được sử dụng, không thể xóa được.";
                return;
            }

            DM_HINHPHAT oT = dt.DM_HINHPHAT.Where(x => x.ID == id).FirstOrDefault();
            dt.DM_HINHPHAT.Remove(oT);
            dt.SaveChanges();

            hddPageIndex.Value = "1";
            LoadGrid();
            Resetcontrol();
            lbthongbao.Text = "Xóa thành công!";
        }

        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
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
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
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
                hddPageIndex.Value = lbCurrent.Text;
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #endregion      
    }
}