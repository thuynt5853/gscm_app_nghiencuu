using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.AHS;
using BL.GSTP.BANGSETGET;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.AHS.TaoHS.Popup
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
            
            if (this.VuAnID == 0){
                if (hddVuAnID.Value !="")
                    this.VuAnID = Convert.ToDecimal(hddVuAnID.Value);
                if (this.VuAnID == 0)
                    this.VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);
            }
                
            hddVuAnID.Value = this.VuAnID + "";
            if (!IsPostBack)
            {
                if (VuAnID > 0)
                {
                    Decimal vu_an_id = Convert.ToDecimal(hddVuAnID.Value);
                    AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == vu_an_id).FirstOrDefault();
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

            AHS_BICANBICAO_BL objBL = new AHS_BICANBICAO_BL();
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

                decimal bicaoid = Convert.ToDecimal(rv["ID"].ToString());
                AHS_BICANBICAO oT = dt.AHS_BICANBICAO.Where(x => x.VUANID == VuAnID && x.ID == bicaoid).FirstOrDefault();
                try { //-- Hình phạt tổng hợp
                    AHS_TONGHOPHINHPHAT ahs_tonghop = new AHS_TONGHOPHINHPHAT();
                    string THHinhPhat = ahs_tonghop.Tonghophinhphat_ST(VuAnID, bicaoid);
                    Label lblTHtoidanh = (Label)e.Item.FindControl("lblTHtoidanh");
                    lblTHtoidanh.Text = THHinhPhat;
                } catch (Exception ex) { }
                try { //-- Năm sinh bị cáo
                    string lbNamSinhBC = oT.NAMSINH.ToString();
                    Label lbNamSinh = (Label)e.Item.FindControl("lbNamSinh");
                    lbNamSinh.Text = lbNamSinhBC;
                } catch (Exception ex) { }
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
                    //string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    //if (Result != "")
                    //{
                    //    LtrThongBao.Text = Result;
                    //    return;
                    //}
                    AHS_PHUCTHAM_THULY oTLPT = dt.AHS_PHUCTHAM_THULY.Where(x => x.VUANID == VuAnID).FirstOrDefault() ?? new AHS_PHUCTHAM_THULY();
                    if (oTLPT.ID > 0)
                    {
                        string StrMsg = "Không được sửa đổi thông tin.";
                        LtrThongBao.Text = StrMsg;
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
            //---------Toi danh tuong ung ------
            List<AHS_SOTHAM_CAOTRANG_DIEULUAT> lstToiDanh = dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.VUANID == VuAnID && x.BICANID == id).ToList<AHS_SOTHAM_CAOTRANG_DIEULUAT>();
            if (lstToiDanh != null && lstToiDanh.Count > 0)
            {
                foreach (AHS_SOTHAM_CAOTRANG_DIEULUAT objTD in lstToiDanh)
                    dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Remove(objTD);
            }
            //---------Bien phap nc------
            List<AHS_SOTHAM_BIENPHAPNGANCHAN> lstNganChan = dt.AHS_SOTHAM_BIENPHAPNGANCHAN.Where(x => x.VUANID == VuAnID && x.BICANID == id).ToList<AHS_SOTHAM_BIENPHAPNGANCHAN>();
            if (lstNganChan != null && lstNganChan.Count > 0)
            {
                foreach (AHS_SOTHAM_BIENPHAPNGANCHAN objNC in lstNganChan)
                    dt.AHS_SOTHAM_BIENPHAPNGANCHAN.Remove(objNC);
            }
            //---------Ban an id------
            AHS_SOTHAM_BANAN bananid = dt.AHS_SOTHAM_BANAN.Where(x => x.VUANID == VuAnID).FirstOrDefault();
            //---------Hinh phat chi tiet------
            List<AHS_SOTHAM_BANAN_DIEU_CHITIET> lstHinhPhatCT = dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Where(x => x.VUANID == VuAnID && x.BICANID == id).ToList<AHS_SOTHAM_BANAN_DIEU_CHITIET>();
            if (lstHinhPhatCT != null && lstHinhPhatCT.Count > 0)
            {
                foreach (AHS_SOTHAM_BANAN_DIEU_CHITIET objNC in lstHinhPhatCT)
                    dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Remove(objNC);
            }
            //---------Hinh phat tong hop------
            List<AHS_SOTHAM_BANAN_DIEU_TONGHOP> lstHinhPhatTH = dt.AHS_SOTHAM_BANAN_DIEU_TONGHOP.Where(x => x.BANANID == bananid.ID && x.BICANID == id).ToList<AHS_SOTHAM_BANAN_DIEU_TONGHOP>();
            if (lstHinhPhatTH != null && lstHinhPhatTH.Count > 0)
            {
                foreach (AHS_SOTHAM_BANAN_DIEU_TONGHOP objNC in lstHinhPhatTH)
                    dt.AHS_SOTHAM_BANAN_DIEU_TONGHOP.Remove(objNC);
            }
            //---------Bi cao------
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