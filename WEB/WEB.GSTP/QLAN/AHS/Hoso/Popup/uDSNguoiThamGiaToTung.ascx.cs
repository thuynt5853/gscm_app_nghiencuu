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
    public partial class uDSNguoiThamGiaToTung : System.Web.UI.UserControl
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");

        private decimal vuanid;
        public decimal VuAnID
        {
            get { return vuanid; }
            set { vuanid = value; }
        }        
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (VuAnID > 0)
                {
                    AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
                    hddGiaiDoanVuAn.Value = oT.MAGIAIDOAN.ToString();

                    //check vu an ket thuc de thong bao khong cho sua
                    Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                    if (anKetThuc)
                    {
                        hddShowCommand.Value = "False";
                    }
                    LoadGrid();
                }
                else
                    pnPagingBottom.Visible = pnPagingTop.Visible = rpt.Visible = false;
            }
        }
        
        public void LoadGrid()
        {
            int page_size = 20;
            int pageindex = Convert.ToInt32(hddPageIndex.Value);
            AHS_SOTHAM_BL objBL = new AHS_SOTHAM_BL();
            DataTable tbl = objBL.AHS_NTGTT_GetByVuAnID(VuAnID, "HOSO", pageindex, page_size);
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
                pnPagingBottom.Visible = pnPagingTop.Visible = rpt.Visible = true;
            }
            else
                pnPagingBottom.Visible = pnPagingTop.Visible = rpt.Visible = false;
        }

        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Xoa":
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (oPer.XOA == false)
                    {
                        Cls_Comon.ShowMessage(this, this.GetType(),"Thông báo", "Bạn không có quyền xóa!");
                        return;
                    }
                    string StrMsg = "Không được sửa đổi thông tin.";
                    string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    if (Result != "")
                    {
                        LtrThongBao.Text = Result;
                        return;
                    }
                    xoa(curr_id);
                    break;
            }
        }
        public void xoa(decimal id)
        {
            AHS_NGUOITHAMGIATOTUNG oND = dt.AHS_NGUOITHAMGIATOTUNG.Where(x => x.ID == id).FirstOrDefault();
            if (oND != null)
            {
                dt.AHS_NGUOITHAMGIATOTUNG.Remove(oND);
                List<AHS_NGUOITHAMGIATOTUNG_TUCACH> lst = dt.AHS_NGUOITHAMGIATOTUNG_TUCACH.Where(x => x.NGUOIID == id).ToList<AHS_NGUOITHAMGIATOTUNG_TUCACH>();
                if (lst != null && lst.Count > 0)
                { dt.AHS_NGUOITHAMGIATOTUNG_TUCACH.RemoveRange(lst); }
                dt.SaveChanges();
                hddPageIndex.Value = "1";
                LoadGrid();
                Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Xóa thành công!");
            }
        }
        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rv = (DataRowView)e.Item.DataItem;
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
               
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                Literal lttSua = (Literal)e.Item.FindControl("lttSua");


                lttSua.Text = "<a href='javascript:;' onclick='popup_form_edit(" + rv["ID"].ToString() + ");'>Sửa</a>";

                int ma_gd = (String.IsNullOrEmpty(hddGiaiDoanVuAn.Value)) ? 0 : Convert.ToInt16(hddGiaiDoanVuAn.Value);
                if (ma_gd == (int)ENUM_GIAIDOANVUAN.PHUCTHAM || ma_gd == (int)ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    lttSua.Text = "<a href='javascript:;' onclick='popup_form_edit(" + rv["ID"].ToString() + ");'>Chi tiết</a>";
                    Cls_Comon.SetLinkButton(lbtXoa, false);
                }

                if (hddGiaiDoanVuAn.Value !="HOSO")
                    lbtXoa.Visible = false;
                string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, "", Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                if (Result != "")
                {
                    lttSua.Text = "<a href='javascript:;' onclick='popup_form_edit(" + rv["ID"].ToString() + ");'>Chi tiết</a>";
                    Cls_Comon.SetLinkButton(lbtXoa, false);
                }

                if (hddShowCommand.Value == "False")
                {
                    lttSua.Text = "<a href='javascript:;' onclick='popup_form_edit(" + rv["ID"].ToString() + ");'>Chi tiết</a>";
                    Cls_Comon.SetLinkButton(lbtXoa, false);
                }

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
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { LtrThongBao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {

                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { LtrThongBao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                // rpt.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGrid();
            }
            catch (Exception ex) { LtrThongBao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                //  rpt.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { LtrThongBao.Text = ex.Message; }
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
            catch (Exception ex) { LtrThongBao.Text = ex.Message; }
        }
    }
}