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
    public partial class uDSBiCao : System.Web.UI.UserControl
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
                    AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == vu_an_id).FirstOrDefault();
                    hddGiaiDoanVuAn.Value = oT.MAGIAIDOAN.ToString();
                    string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, "", Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    if (Result != "")
                    {
                        hddShowCommand.Value = "False";
                    }

                    //check vu an ket thuc de thong bao khong cho sua
                    Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                    if (anKetThuc)
                    {
                        hddShowCommand.Value = "False";
                    }
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

            /* GTEL-DUCPH 18-09-2025 15h40 Viết hàm mới lấy thêm trạng thái xác thực của bị can*/

            //AHS_BICANBICAO_BL objBL = new AHS_BICANBICAO_BL();
            //DataTable tbl = objBL.GetAllByVuAn_RemoveBiCaoID(VuAnID, RemoveBiCaoID, pageindex, page_size);
            AHS_BICANBICAO_NC_BL objBL = new AHS_BICANBICAO_NC_BL();
            DataTable tbl = objBL.AHS_BICAO_GETALL_BY_VUANID(VuAnID, pageindex, page_size);
            /* END GTEL-DUCPH 18-09-2025 15h40 Viết hàm mới lấy thêm trạng thái xác thực của bị can*/
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

                int ma_gd = (String.IsNullOrEmpty(hddGiaiDoanVuAn.Value)) ? 0 : Convert.ToInt16(hddGiaiDoanVuAn.Value);
                if (ma_gd == (int)ENUM_GIAIDOANVUAN.PHUCTHAM || ma_gd == (int)ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    lttSua.Text = "<a href='javascript:;' onclick='popup_edit_bicao(" + rv["ID"].ToString() + ");'>Chi tiết</a>";
                    Cls_Comon.SetLinkButton(lbtXoa, false);
                }
                int IsAnST = (string.IsNullOrEmpty(rowView["CheckDelete"] + "")) ? 0 : Convert.ToInt16(rowView["CheckDelete"] + "");
                if (IsAnST > 0)
                    lbtXoa.Visible = false;
                if (hddShowCommand.Value == "False")
                {
                    lttSua.Text = "<a href='javascript:;' onclick='popup_edit_bicao(" + rv["ID"].ToString() + ");'>Chi tiết</a>";
                    Cls_Comon.SetLinkButton(lbtXoa, false);
                }
                HiddenField hdid = (HiddenField)e.Item.FindControl("hdid");
                decimal bcID = Convert.ToDecimal(hdid.Value);
                AHS_BICANBICAO bc = dt.AHS_BICANBICAO.Where(x => x.ID == bcID).FirstOrDefault();
                if (bc.GDTAOHS == 1 || bc.GDTAOHS == 2) lttSua.Visible = lbtXoa.Visible = false;


                // check quyền để hiển thị nút xoá
                HiddenField hddToaGiaiQuyetID = (HiddenField)e.Item.FindControl("hddToaGiaiQuyetID");
                string toaGiaiQuyetID = hddToaGiaiQuyetID.Value.ToString();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (toaGiaiQuyetID != donviID)
                {
                    lbtXoa.Visible = false;
                    lttSua.Visible = false;
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
                    string StrMsg = "Không được sửa đổi thông tin.";
                    string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    if (Result != "")
                    {
                        LtrThongBao.Text = Result;
                        return;
                    }
                    xoa_bi_can(curr_id);
                    break;
            }
        }
        public void xoa_bi_can(decimal id)
        {
            //---------nhan than cua bi cao------
            List<AHS_BICAN_NHANTHAN> lst = dt.AHS_BICAN_NHANTHAN.Where(x => x.BICANID == id).ToList<AHS_BICAN_NHANTHAN>();
            if (lst != null && lst.Count > 0)
            {
                foreach (AHS_BICAN_NHANTHAN obj in lst)
                    dt.AHS_BICAN_NHANTHAN.Remove(obj);
            }
            //---------Toi danh tuong ung --------------
            List<AHS_SOTHAM_CAOTRANG_DIEULUAT> lstToiDanh = dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.VUANID == VuAnID && x.BICANID == id).ToList<AHS_SOTHAM_CAOTRANG_DIEULUAT>();
            if (lstToiDanh != null && lstToiDanh.Count > 0)
            {
                foreach (AHS_SOTHAM_CAOTRANG_DIEULUAT objTD in lstToiDanh)
                    dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Remove(objTD);
            }
            //---------Bien phap nc----------
            List<AHS_SOTHAM_BIENPHAPNGANCHAN> lstNganChan = dt.AHS_SOTHAM_BIENPHAPNGANCHAN.Where(x => x.VUANID == VuAnID && x.BICANID == id).ToList<AHS_SOTHAM_BIENPHAPNGANCHAN>();
            if (lstNganChan != null && lstNganChan.Count > 0)
            {
                foreach (AHS_SOTHAM_BIENPHAPNGANCHAN objNC in lstNganChan)
                    dt.AHS_SOTHAM_BIENPHAPNGANCHAN.Remove(objNC);
            }
            //--------Bi cao---------------
            AHS_BICANBICAO oT = dt.AHS_BICANBICAO.Where(x => x.ID == id).FirstOrDefault();
            int bicandauvu = (int)oT.BICANDAUVU;
            dt.AHS_BICANBICAO.Remove(oT);

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