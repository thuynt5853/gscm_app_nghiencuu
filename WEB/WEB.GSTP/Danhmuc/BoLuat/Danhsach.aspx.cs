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

namespace WEB.GSTP.Danhmuc.BoLuat
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
                    LoadDropLoai();
                    LoadGrid();
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        void LoadDropLoai()
        {
            dropLoai.Items.Clear();
            dropLoai.Items.Add(new ListItem("---------- chọn -------------", ""));
            dropLoai.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
            dropLoai.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
            dropLoai.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
            dropLoai.Items.Add(new ListItem("Hôn nhân - Gia đình ", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
            dropLoai.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
            dropLoai.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
        }
        void LoadDropHieuLuc()
        {
            dropHieuLuc.Items.Clear();
            dropHieuLuc.Items.Add(new ListItem("-----Tất cả------", "2"));
            dropHieuLuc.Items.Add(new ListItem("Đang sử dụng", "1"));
            dropHieuLuc.Items.Add(new ListItem("Không sử dụng", "0"));
        }
       
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            DM_BOLUAT obj = new DM_BOLUAT();
            int CurrID = 0;
            if (hddCurrID.Value != "" && hddCurrID.Value != "0")
            {
                CurrID = Convert.ToInt32(hddCurrID.Value);
                obj = dt.DM_BOLUAT.Where(x => x.ID == CurrID).FirstOrDefault();
                if (obj != null)
                {
                    obj.NGAYSUA = DateTime.Now;
                    obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] +"";
                }
            }
            obj.HIEULUC = Convert.ToDecimal(rdHieuLuc.SelectedValue);
            obj.TENBOLUAT = txtTen.Text.Trim();
            obj.NGAYBANHANH = (String.IsNullOrEmpty(txtNgayBanHanh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayBanHanh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
          

            string loai =dropLoai.SelectedValue;
            obj.LOAI = loai;
            if (CurrID == 0)
            {               
                obj.NGAYTAO = DateTime.Now;
                obj.NGAYSUA = DateTime.Now;
                obj.NGUOISUA = obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] +"";
                dt.DM_BOLUAT.Add(obj);
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
            hddCurrID.Value = "0";
            txtTen.Text = "";
            //chkActive.Checked = false;
            rdHieuLuc.SelectedIndex = -1;

            txtNgayBanHanh.Text = "";
            dropLoai.SelectedValue = "";
        }
       
        public void LoadInfo(decimal ID)
        {
            DM_BOLUAT oT = dt.DM_BOLUAT.Where(x => x.ID == ID).FirstOrDefault();
            if (oT == null) return;
            {
                txtTen.Text = oT.TENBOLUAT;
                // chkActive.Checked = (Convert.ToInt32(oT.HIEULUC) == 0) ? false : true;
                rdHieuLuc.SelectedValue = oT.HIEULUC + "";

                string date_tungay = Convert.ToDateTime(oT.NGAYBANHANH).ToString("dd/MM/yyyy", cul);
                string min_date = DateTime.MinValue.ToString("dd/MM/yyyy", cul);

                txtNgayBanHanh.Text = (min_date == date_tungay) ? "" : date_tungay;
                dropLoai.SelectedValue = (string.IsNullOrEmpty(oT.LOAI + "")) ? "" : oT.LOAI.ToString();
            }
        }
        public void LoadGrid()
        {
            string textsearch = txttimkiem.Text.Trim();
            int hieuluc = (string.IsNullOrEmpty(dropHieuLuc.SelectedValue))? 2: Convert.ToInt32(dropHieuLuc.SelectedValue);
            int page_size = 20;
            int pageindex = Convert.ToInt32(hddPageIndex.Value);

            DM_BOLUAT_BL objBL = new DM_BOLUAT_BL();
            DataTable tbl = objBL.DM_BOLUAT_GetAllPaging(textsearch, hieuluc, pageindex, page_size);
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
            decimal curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "toidanh":
                    Response.Redirect("Edit.aspx?boluatID=" + curr_id);
                    break;
                case "Sua":
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
                    Resetcontrol();

                    break;
            }
        }
        public void xoa(decimal id)
        {
            List<DM_BOLUAT_TOIDANH> lst = dt.DM_BOLUAT_TOIDANH.Where(x => x.LUATID == id).ToList();
            if (lst.Count > 0)
            {
                lbthongbao.Text = "Nhóm danh mục đã có dữ liệu, không thể xóa được.";
                return;
            }

            DM_BOLUAT oT = dt.DM_BOLUAT.Where(x => x.ID == id).FirstOrDefault();
            dt.DM_BOLUAT.Remove(oT);
            dt.SaveChanges();

            hddPageIndex.Value = "1";
            LoadGrid();
            Resetcontrol();
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
    }
}