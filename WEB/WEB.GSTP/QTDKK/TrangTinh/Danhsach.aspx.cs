
using Module.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Data;

using System.Globalization;
using System.Web.UI.WebControls;
//using BL.GSTP.Danhmuc;
//using BL.GSTP;
//using DAL.GSTP;
using BL.GSTP;
using DAL.GSTP;

using BL.GSTP.Danhmuc;
using BL.DonKK.DanhMuc;


namespace WEB.GSTP.QTDKK.Trangtinh
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
                    LoadGrid();

                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
      
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            DM_TRANGTINH obj = new DM_TRANGTINH();
            int CurrID =(String.IsNullOrEmpty(hddCurrID.Value))?0: Convert.ToInt32(hddCurrID.Value);
            //if (hddCurrID.Value != "" && hddCurrID.Value != "0")
            //{
            //    CurrID = Convert.ToInt32(hddCurrID.Value);
            //    obj = dt.DM_TRANGTINH.Where(x => x.ID == CurrID).FirstOrDefault<DM_TRANGTINH>();
            //}
            //--check--------------------------------
            String matrang = txtMa.Text.Trim();
            string tentrang = txtTen.Text.Trim();
            Boolean IsUpdate = false;
            List<DM_TRANGTINH> lst = dt.DM_TRANGTINH.Where(x => x.MATRANG == matrang).ToList<DM_TRANGTINH>();
            if (lst != null && lst.Count > 0)
            {
                obj = lst[0];
                if (obj.ID != CurrID)
                {
                    lbthongbao.Text = "Mã trang đã tồn tại, hãy nhập mã trang khác.";
                    txtMa.Focus();
                    return;
                }
                else
                {
                    IsUpdate = true;
                }
            }
            else
                obj = new DM_TRANGTINH();
            if (!IsUpdate)
            {
                obj.MATRANG = matrang;
                obj.TENTRANG = tentrang;
                obj.NOIDUNG = txtNoiDung.Text.Trim();
                obj.NGAYTAO = DateTime.Now;
                obj.NGAYSUA = DateTime.Now;
                obj.NGUOISUA = obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                dt.DM_TRANGTINH.Add(obj);
            }
            else
            {
                obj.MATRANG = matrang;
                obj.TENTRANG = tentrang;
                obj.NOIDUNG = txtNoiDung.Text.Trim();
                obj.NGAYSUA = DateTime.Now;
                obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            }

            dt.SaveChanges();

            //------------------------
            hddPageIndex.Value = "1";
            LoadGrid();
            Resetcontrol();
            lbthongbao.Text = "Cập nhật thành công!";
        }

        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            Resetcontrol();
        }
        protected void Resetcontrol()
        {
            lbthongbao.Text = "";
            hddCurrID.Value = "0";
            txtTen.Text = txtMa.Text = txtNoiDung.Text = "";
        }

        public void LoadInfo(decimal ID)
        {
            DM_TRANGTINH oT = dt.DM_TRANGTINH.Where(x => x.ID == ID).FirstOrDefault();
            if (oT == null) return;
            {
                txtMa.Text = oT.MATRANG;
                txtTen.Text = oT.TENTRANG;
                txtNoiDung.Text = oT.NOIDUNG;
            }
        }
        public void LoadGrid()
        {
            lbthongbao.Text = "";
            int page_size = 10;
            int pageindex = Convert.ToInt32(hddPageIndex.Value);
            DataTable tbl = null;
            DM_TRANGTINH_BL objBL = new DM_TRANGTINH_BL();
            tbl = objBL.GetAllPaging(pageindex, page_size);
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
                if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
                {
                    LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                    Cls_Comon.SetLinkButton(lblSua, oPer.CAPNHAT);

                    LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                    Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);
                }
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
                    Resetcontrol();
                    break;
            }
        }
        public void xoa(decimal id)
        {
            DM_TRANGTINH oT = dt.DM_TRANGTINH.Where(x => x.ID == id).FirstOrDefault();
            dt.DM_TRANGTINH.Remove(oT);
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
    }
}