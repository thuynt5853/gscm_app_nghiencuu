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
    public partial class uDsThuLy : System.Web.UI.UserControl
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
                    LoadGrid();
                }                    
                else rpt.Visible = false;
            }
        }
        private void LoadGrid()
        {          
            AHS_SOTHAM_THULY_BL obj = new AHS_SOTHAM_THULY_BL();
            DataTable tbl = obj.GetByVuAnID(this.VuAnID);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                rpt.DataSource = tbl;
                rpt.DataBind();
                rpt.Visible = true;
            }
            else rpt.Visible = false;
        }
        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                int ma_gd = (String.IsNullOrEmpty(hddGiaiDoanVuAn.Value)) ? 0 : Convert.ToInt16(hddGiaiDoanVuAn.Value);
                if (ma_gd == (int)ENUM_GIAIDOANVUAN.PHUCTHAM || ma_gd == (int)ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    lblSua.Text = lblSua.ToolTip = "Chi tiết";
                    Cls_Comon.SetLinkButton(lbtXoa, false);
                }
            }
        }
        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal ThuLyID = Convert.ToDecimal(e.CommandArgument.ToString());
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            switch (e.CommandName)
            {
                case "Sua":
                    //LoadInfo(ThuLyID);
                    break;
                case "Xoa":
                    if (oPer.XOA == false)
                    {
                        lstMsgB.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    string StrMsg = "Không được sửa đổi thông tin.";
                    string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    if (Result != "")
                    {
                        lstMsgB.Text = Result;
                        return;
                    }
                    AHS_SOTHAM_THULY oT = dt.AHS_SOTHAM_THULY.Where(x => x.ID == ThuLyID).FirstOrDefault();
                    dt.AHS_SOTHAM_THULY.Remove(oT);
                    dt.SaveChanges();
                    LoadGrid();
                    break;
            }
        }
    }
}