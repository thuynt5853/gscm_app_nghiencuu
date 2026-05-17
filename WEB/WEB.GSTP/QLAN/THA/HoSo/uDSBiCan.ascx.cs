using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.AHS;
using BL.GSTP.THA;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.THA.HoSo
{
    public partial class uDSBiCan : System.Web.UI.UserControl
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");

        private decimal vuanid;
        public decimal VuAnID
        {
            get { return vuanid; }
            set { vuanid = value; }
        }

        protected decimal remove_bicaoid;
        public decimal RemoveBiCaoID
        {
            get { return remove_bicaoid; }
            set { remove_bicaoid = value; }
        }

        public void Page_Load(object sender, EventArgs e)
        {
            hddVuAnID.Value = this.VuAnID + "";
            if (!IsPostBack)
            {
                if (VuAnID > 0)
                {
                    Decimal vu_an_id = Convert.ToDecimal(hddVuAnID.Value);
                    THA_VUAN oT = dt.THA_VUAN.Where(x => x.ID == vu_an_id).FirstOrDefault();
                    //hddGiaiDoanVuAn.Value = oT.MAGIAIDOAN.ToString();
                    //string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, "", Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    //if (Result != "")
                    //{
                    //    hddShowCommand.Value = "False";
                    //}
                    LoadGrid();
                }
                else
                    pnPagingBottom.Visible = pnPagingTop.Visible = rptBiCan.Visible = false;
            }
        }

        public void LoadGrid()
        {
            int page_size = 20;
            int pageindex = Convert.ToInt32(hddPageIndex.Value);
            if (Session[ENUM_THA_VUAN.SESSION_IDVUANTHA]+"" != "" && VuAnID == 0)
            {
                VuAnID = Convert.ToDecimal(Session[ENUM_THA_VUAN.SESSION_IDVUANTHA] + "");
            }
            THA_BIAN_BL objBL = new THA_BIAN_BL();
            DataTable tbl = objBL.GetAllByVuAn_RemoveBiCaoID(VuAnID, RemoveBiCaoID, pageindex, page_size);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                int count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");

                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion

                rptBiCan.DataSource = tbl;
                rptBiCan.DataBind();
                pnPagingBottom.Visible = pnPagingTop.Visible = rptBiCan.Visible = true;
            }
            else pnPagingBottom.Visible = pnPagingTop.Visible = rptBiCan.Visible = false;
        }
        protected void rptBiCan_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;
                DataRowView rv = (DataRowView)e.Item.DataItem;
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                Literal lttSua = (Literal)e.Item.FindControl("lttSua");
                lttSua.Text = "<a href='javascript:;' onclick='popup_edit_bicao(" + rv["ID"].ToString() + ");'>Sửa</a>";

                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                decimal ma_gd = (String.IsNullOrEmpty(hddGiaiDoanVuAn.Value)) ? 0 : Convert.ToDecimal(hddGiaiDoanVuAn.Value);
                if (ma_gd == (int)ENUM_GIAIDOANVUAN.PHUCTHAM || ma_gd == (int)ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    lttSua.Text = "<a href='javascript:;' onclick='popup_edit_bicao(" + rv["ID"].ToString() + ");'>Chi tiết</a>";
                    Cls_Comon.SetLinkButton(lbtXoa, false);
                }
                decimal IsAnST = (string.IsNullOrEmpty(rowView["CheckDelete"] + "")) ? 0 : Convert.ToDecimal(rowView["CheckDelete"] + "");
                decimal bianID = Convert.ToDecimal(rv["ID"].ToString());
                THA_BIAN objBiAn = dt.THA_BIAN.Where( x => x.ID == bianID).FirstOrDefault();
                if(objBiAn != null)
                {
                    THA_VUAN objVuAn = dt.THA_VUAN.Where(x => x.ID == objBiAn.VUANID).FirstOrDefault();

                    THA_THULY objThuLy = dt.THA_THULY.Where(x => x.VUANID == objBiAn.VUANID).FirstOrDefault();
                    if (objThuLy != null)
                    {
                        lbtXoa.Visible = false;
                    }
                    else if (objVuAn.IDVUANHETHONG != null  && objVuAn.IDVUANHETHONG != 0)
                    {
                        lbtXoa.Visible = false;
                    }

                    // Kiểm tra TOA_GIAIQUYET_ID
                    string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                    if (!string.IsNullOrEmpty(donviID) && objVuAn != null && objVuAn.TOA_GIAIQUYET_ID.HasValue)
                    {
                        if (objVuAn.TOA_GIAIQUYET_ID.ToString() != donviID)
                        {
                            lbtXoa.Visible = false;
                        }
                    }
                }
                //if (IsAnST > 0)
                //    lbtXoa.Visible = false;
                if (hddShowCommand.Value == "False")
                {
                    lttSua.Text = "<a href='javascript:;' onclick='popup_edit_bicao(" + rv["ID"].ToString() + ");'>Chi tiết</a>";
                    Cls_Comon.SetLinkButton(lbtXoa, false);
                }
            }
        }

        protected void rptBiCan_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Xoa":
                    //MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    //if (oPer.XOA == false)
                    //{
                    //    lstMsgB.Text = "Bạn không có quyền xóa!";
                    //    return;
                    //}
                    //string StrMsg = "Không được sửa đổi thông tin.";
                    //string Result = new THA_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg);
                    //if (Result != "")
                    //{
                    //    LtrThongBao.Text = Result;
                    //    return;
                    //}
                    xoa_bi_can(curr_id);
                    break;
            }
        }
        public void xoa_bi_can(decimal id)
        {
            //---------Toi danh tuong ung --------------
            List<THA_SOTHAM_CAOTRANG_DIEULUAT> lstToiDanh = dt.THA_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.VUANID == VuAnID && x.BICANID == id).ToList<THA_SOTHAM_CAOTRANG_DIEULUAT>();
            if (lstToiDanh != null && lstToiDanh.Count > 0)
            {
                foreach (THA_SOTHAM_CAOTRANG_DIEULUAT objTD in lstToiDanh)
                    dt.THA_SOTHAM_CAOTRANG_DIEULUAT.Remove(objTD);
            }
            //--------Bi cao---------------
            THA_BIAN oT = dt.THA_BIAN.Where(x => x.ID == id).FirstOrDefault();
            int bicandauvu = (int)oT.BICANDAUVU;
            dt.THA_BIAN.Remove(oT);

            //------------------------            
            dt.SaveChanges();
            //------------------------  
            hddPageIndex.Value = "1";
            LoadGrid();
            if (bicandauvu == 1)
                Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent()");
        }
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
                // rptBiCan.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGrid();
            }
            catch (Exception ex) { }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                //  rptBiCan.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
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
                // rptBiCan.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
                hddPageIndex.Value = lbCurrent.Text;
                LoadGrid();
            }
            catch (Exception ex) { }
        }

    }
}