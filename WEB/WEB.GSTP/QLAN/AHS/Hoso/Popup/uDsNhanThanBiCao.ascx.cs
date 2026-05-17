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
    public partial class uDsNhanThanBiCao : System.Web.UI.UserControl
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");

        private decimal vuanid;
        public decimal VuAnID
        {
            get { return vuanid; }
            set { vuanid = value; }
        }

        protected decimal bicanid;
        public decimal BiCanID
        {
            get { return bicanid; }
            set { bicanid = value; }
        }
        protected decimal isshowall;
        public decimal ShowAll
        {
            get { return isshowall; }
            set { isshowall = value; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {            
            if (!IsPostBack)
            {
                //if (BiCanID > 0)
                //    lkThemNhanThan.Visible = true;
                //else
                //    lkThemNhanThan.Visible = false;

                if (VuAnID > 0)
                {
                    CheckQuyen();
                    LoadDsNhanThanBiCao();
                }
            }
        }
        void CheckQuyen()
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            //-----------------------------------
            AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            hddGiaiDoanVuAn.Value = oT.MAGIAIDOAN + "";
            //if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
            //{
            //    //"Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
            //    Cls_Comon.SetLinkButton(lkThemNhanThan, false);
            //    return;
            //}
        }

        public void LoadDsNhanThanBiCao()
        {
            AHS_BICAN_NHANTHAN_BL objBL = new AHS_BICAN_NHANTHAN_BL();
            DataTable tbl = null;
            if (this.ShowAll == 1) tbl = objBL.GetByVuAn_BiAnID(VuAnID, BiCanID);
            else {
                int MoiQuanHeNhanThanID = 0;
                string QHNhanThan = ENUM_QH_NHANTHAN.CON;
                try { MoiQuanHeNhanThanID = (int)dt.DM_DATAITEM.Where(x => x.MA == QHNhanThan).FirstOrDefault().ID; } catch (Exception ex) { }

                tbl = objBL.AHS_BC_NHANTHAN_GetByLoaiQH(vuanid, BiCanID, MoiQuanHeNhanThanID);
            }
            if (tbl != null && tbl.Rows.Count > 0)
            {
                rptNhanThan.DataSource = tbl;
                rptNhanThan.DataBind();
                rptNhanThan.Visible = true;

                //------------------------------
                int ma_gd = (String.IsNullOrEmpty(hddGiaiDoanVuAn.Value)) ? 0 : Convert.ToInt16(hddGiaiDoanVuAn.Value);
                if (ma_gd == (int)ENUM_GIAIDOANVUAN.PHUCTHAM || ma_gd == (int)ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    foreach (RepeaterItem item in rptNhanThan.Items)
                    {
                        LinkButton lkEdit = (LinkButton)item.FindControl("lkEdit");
                        lkEdit.Text = lkEdit.ToolTip = "Chi tiết";

                        LinkButton lbtXoa = (LinkButton)item.FindControl("lbtXoa");
                        Cls_Comon.SetLinkButton(lbtXoa, false);
                    }
                }
            }
            else rptNhanThan.Visible = false;
        }
        protected void rptNhanThan_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rv = (DataRowView)e.Item.DataItem;
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                Literal lttSua = (Literal)e.Item.FindControl("lttSua");
                lttSua.Text = "<a href='javascript:;' onclick='popup_edit(" + rv["ID"].ToString() + ");'>Sửa</a>";

                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");

                int ma_gd = (String.IsNullOrEmpty(hddGiaiDoanVuAn.Value)) ? 0 : Convert.ToInt16(hddGiaiDoanVuAn.Value);
                if (ma_gd == (int)ENUM_GIAIDOANVUAN.PHUCTHAM || ma_gd == (int)ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    lttSua.Text = "<a href='javascript:;' onclick='popup_edit(" + rv["ID"].ToString() + ");'>Chi tiết</a>";
                    Cls_Comon.SetLinkButton(lbtXoa, false);
                }
            }
        }

        protected void rptNhanThan_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Xoa":
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (oPer.XOA == false)
                    {
                        Cls_Comon.ShowMessage(this, this.GetType(),"Thông báo","Bạn không có quyền xóa!");
                        return;
                    }
                    string StrMsg = "Không được sửa đổi thông tin.";
                    string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    if (Result != "")
                    {
                        LtrThongBao.Text = Result;
                        return;
                    }
                    xoa_nhanthan(curr_id);
                    break;
            }
        }
        public void xoa_nhanthan(decimal id)
        {
            AHS_BICAN_NHANTHAN oT = dt.AHS_BICAN_NHANTHAN.Where(x => x.ID == id).FirstOrDefault();
            dt.AHS_BICAN_NHANTHAN.Remove(oT);
            dt.SaveChanges();
            
            Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Xóa dữ liệu thành công!");
            LoadDsNhanThanBiCao();
        }
    }
}