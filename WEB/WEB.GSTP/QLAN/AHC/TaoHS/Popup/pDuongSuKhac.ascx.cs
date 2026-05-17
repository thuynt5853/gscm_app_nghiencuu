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
using BL.GSTP.AHC;

namespace WEB.GSTP.QLAN.AHC.TaoHS.Popup
{
    public partial class pDuongSuKhac : System.Web.UI.UserControl
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");

        private decimal donid;
        public decimal DonID
        {
            get { return donid; }
            set { donid = value; }
        }

        protected decimal remove_donid;
        public decimal RemoveBiCaoID
        {
            get { return remove_donid; }
            set { remove_donid = value; }
        }
        public void ReLoad()
        {
            LoadGrid();
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string strDonID = Session["HC_THEMDSK"] + "";
                if (strDonID != "" && DonID == 0)
                    DonID = Convert.ToDecimal(strDonID);
                LoadGrid();
                //string Result = new AHC_CHUYEN_NHAN_AN_BL().Check_NhanAn(DonID, "");
                //if (Result != "")
                //{
                //    lkThemNguoiTGTT.Visible = false;
                //}
                foreach(DataGridItem item in dgList.Items)
                {
                    
                    LinkButton lbtXoa = (LinkButton)item.FindControl("lbtXoa");
                    //if (Result != "")
                    //{
                    //    lblSua.Text="Chi tiết";
                    //    lbtXoa.Visible = false;
                    //}
                }
            }
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                //case "Sua":
                //    Cls_Comon.CallFunctionJS(this, this.GetType(), "popup_edit_duongsu(" + ND_id + ")");
                //    break;
                case "Xoa":
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (oPer.XOA == false)
                    {
                        LtrThongBao.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    //string Result = new AHC_CHUYEN_NHAN_AN_BL().Check_NhanAn(DonID, "");
                    //if (Result != "")
                    //{
                   
                    AHC_PHUCTHAM_THULY oTLPT = dt.AHC_PHUCTHAM_THULY.Where(x => x.DONID == DonID).FirstOrDefault() ?? new AHC_PHUCTHAM_THULY();
                    if (oTLPT.ID > 0)
                    {
                        string StrMsg = "Không được sửa đổi thông tin.";
                        LtrThongBao.Text = StrMsg;
                        return;
                    }

                    xoa(ND_id);
                    break;
            }

        }
        public void LoadGrid()
        {
            int pageindex = Convert.ToInt32(hddPageIndex.Value);

            AHC_DON_DUONGSU_BL oBL = new AHC_DON_DUONGSU_BL();
         
            DataTable oDT = oBL.AHC_DON_DUONGSU_NOTDAIDIEN(DonID);

            //if (oDT != null && oDT.Rows.Count > 0)
            //{
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Convert.ToInt32(oDT.Rows.Count), Convert.ToInt32(20)).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + oDT.Rows.Count.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion

                dgList.DataSource = oDT;
                dgList.DataBind();
                pnDS.Visible = true;
            //}
            //else
            //{
            //    dgList.DataSource = null;
            //    dgList.DataBind();
            //    pnDS.Visible = true;
            //}
          
        }
        
        public void xoa(decimal id)
        {
            AHC_DON_DUONGSU oT = dt.AHC_DON_DUONGSU.Where(x => x.ID == id).FirstOrDefault();
            dt.AHC_DON_DUONGSU.Remove(oT);
            dt.SaveChanges();

            hddPageIndex.Value = "1";
            LoadGrid();
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            LoadGrid();
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadGrid();
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            LoadGrid();
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            LoadGrid();
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex.Value = lbCurrent.Text;
            LoadGrid();
        }
        #endregion

        //protected void lkThemNguoiTGTT_Click(object sender, EventArgs e)
        //{
        //    string strDonID = Session["HC_THEMDSK"] + "";
        //    if (strDonID != "" && DonID == 0)
        //        DonID = Convert.ToDecimal(strDonID);

        //    string StrMsg = "PopupReport('/QLAN/AHC/TaoHS/Popup/pDuongsu.aspx?hsID=" + DonID.ToString() + "&bID=0','Thêm đương sự',950,450);";
        //    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
        //}
    }
}