using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.AHS;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.AHS.Hoso.Popup
{
    public partial class uDsToiDanh : System.Web.UI.UserControl
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");

        protected decimal vu_an_id;
        public decimal VuAnID
        {
            get { return vu_an_id; }
            set { vu_an_id = value; }
        }

        protected decimal bicaoid;
        public decimal BiCaoID
        {
            get { return bicaoid; }
            set { bicaoid = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (VuAnID > 0)
            {
                if (!IsPostBack)
                {
                    AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
                    hddGiaiDoanVuAn.Value = oT.MAGIAIDOAN.ToString();
                    LoadGrid();

                    if (oT.MAGIAIDOAN == (int)ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == (int)ENUM_GIAIDOANVUAN.THULYGDT)
                    {
                        pnThem.Visible = false;
                    }
                    string StrMsg = "Không được sửa đổi thông tin.";
                    string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    if (Result != "")
                    {
                        LtrThongBao.Text = Result;
                        pnThem.Visible = false;
                        return;
                    }
                }
                else pnPagingBottom.Visible = pnPagingTop.Visible = rpt.Visible = false;
            }
        }
        public void LoadGrid()
        {
            int page_size = 20;
            int pageindex = Convert.ToInt32(hddPageIndex.Value);
            decimal loaiboluat = Convert.ToDecimal(ENUM_LOAIVUVIEC.AN_HINHSU);

            AHS_SOTHAM_CAOTRANG_DIEULUAT_BL objBL = new AHS_SOTHAM_CAOTRANG_DIEULUAT_BL();
            DataTable tbl = objBL.GetAllByBiCaoID(BiCaoID, VuAnID, pageindex, page_size);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                int count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");

                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
                lstSobanghiB.Text = "Có <b>" + count_all + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion

                rpt.DataSource = tbl;
                rpt.DataBind();
                pnPagingBottom.Visible = pnPagingTop.Visible = rpt.Visible = true;
            }
            else
                pnPagingBottom.Visible = pnPagingTop.Visible = rpt.Visible = false;
        }

        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGrid();
            }
            catch (Exception ex) { }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                hddPageIndex.Value = lbCurrent.Text;
                LoadGrid();
            }
            catch (Exception ex) { }
        }
        #endregion
        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Xoa":
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (oPer.XOA == false)
                    {
                        Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Bạn không có quyền xóa!");
                        return;
                    }
                    string StrMsg = "Không được sửa đổi thông tin.";
                    string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    if (Result != "")
                    {
                        Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", Result);
                        return;
                    }
                    xoa(curr_id);
                    break;
            }
        }
        public void xoa(decimal id)
        {
            AHS_SOTHAM_CAOTRANG_DIEULUAT obj = dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.ID == id).FirstOrDefault();
            dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Remove(obj);
            dt.SaveChanges();

            hddPageIndex.Value = "1";
            LoadGrid();
            //lbthongbao.Text = "Xóa thành công!";
        }

        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                int ma_gd = (String.IsNullOrEmpty(hddGiaiDoanVuAn.Value)) ? 0 : Convert.ToInt16(hddGiaiDoanVuAn.Value);
                if (ma_gd == (int)ENUM_GIAIDOANVUAN.PHUCTHAM || ma_gd == (int)ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    Cls_Comon.SetLinkButton(lbtXoa, false);
                }
            }
        }

    }
}