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

namespace WEB.GSTP.QLAN.XLHC.Hoso.Popup
{
    public partial class uDSBiCao : System.Web.UI.UserControl
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");

        private decimal donid;
        public decimal DonID
        {
            get { return donid; }
            set { donid = value; }
        }

        protected decimal remove_bicaoid;
        public decimal RemoveBiCaoID
        {
            get { return remove_bicaoid; }
            set { remove_bicaoid = value; }
        }

        public void ReLoad()
        {
            LoadGrid();
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            //if (!IsPostBack)
            //{

            if (DonID > 0)
                LoadGrid();
            string StrMsg = "Không được sửa đổi thông tin.";
            string Result = new XLHC_CHUYEN_NHAN_AN_BL().Check_NhanAn(DonID, StrMsg);
            if (Result != "")
            {
                LtrThongBao.Text = Result;
                lkThemNguoiTGTT.Enabled = false;
                return;
            }
            //}
        }
        public void LoadGrid()
        {
            hddDonID.Value = DonID.ToString();
            int page_size = 20;
            int pageindex = Convert.ToInt32(hddPageIndex.Value);

            XLHC_DON_DUONGSU_BL oBL = new XLHC_DON_DUONGSU_BL();

            DataTable oDT = oBL.XLHC_DON_DUONGSU_NOTDAIDIEN(DonID);

            if (oDT != null && oDT.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Convert.ToInt32(oDT.Rows.Count), page_size).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + oDT.Rows.Count.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion

                dgList.DataSource = oDT;
                dgList.DataBind();
                pnDS.Visible = true;
            }
            else
            {
                pnDS.Visible = false;
            }

        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Sua":

                    break;
                case "Xoa":
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (oPer.XOA == false)
                    {
                        LtrThongBao.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    string StrMsg = "Không được sửa đổi thông tin.";
                    string Result = new XLHC_CHUYEN_NHAN_AN_BL().Check_NhanAn(DonID, StrMsg);
                    if (Result != "")
                    {
                        LtrThongBao.Text = Result;
                        return;
                    }
                    xoa(ND_id);
                    break;
            }

        }
        public void xoa(decimal id)
        {
            XLHC_DUONGSU oT = dt.XLHC_DUONGSU.Where(x => x.ID == id).FirstOrDefault();
            dt.XLHC_DUONGSU.Remove(oT);
            dt.SaveChanges();

            hddPageIndex.Value = "1";
            LoadGrid();
        }
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) {  }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {

                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) {  }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                // rpt.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGrid();
            }
            catch (Exception ex) {  }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                //  rpt.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) {  }
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
            catch (Exception ex) {  }
        }
        protected void lkThemNguoiTGTT_Click(object sender, EventArgs e)
        {
            string StrMsg = "PopupReport('/QLAN/XLHC/Hoso/Popup/pDuongSu.aspx?hsID=" + DonID.ToString() + "&bID=0','Thêm đương sự',950,450);";
            System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
        }
    }
}