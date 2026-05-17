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
using BL.GSTP.ALD;

namespace WEB.GSTP.QLAN.ALD.Hoso.Popup
{
    public partial class pDuongSuKhacChiTiet : System.Web.UI.UserControl
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");

        private decimal donid;
        public decimal DonID
        {
            get { return donid; }
            set { donid = value; }
        }
        private decimal donidChitiet;
        public decimal DonIDChitiet
        {
            get { return donidChitiet; }
            set { donidChitiet = value; }
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
                string strDonID = Session["DS_THEMDSK"] + "";
                string DONID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_LAODONG]).ToString();
                if (DONID != "" && DonID == 0)
                    DonID = Convert.ToDecimal(DONID);
                LoadGrid();
                string Result = new ALD_CHUYEN_NHAN_AN_BL().Check_NhanAn(DonID, "");
                //if (Result != "")
                //{
                //    lkThemNguoiTGTT.Visible = false;
                //}
                foreach (DataGridItem item in dgList.Items)
                {
                    LinkButton lblSua = (LinkButton)item.FindControl("lblSua");
                    LinkButton lbtXoa = (LinkButton)item.FindControl("lbtXoa");
                    if (Result != "")
                    {
                        lblSua.Text="Chi tiết";
                        lbtXoa.Visible = false;
                    }
                }
            }
        }
        public void hiddenbtnThemMoi()
        {
            //lkThemNguoiTGTT.Visible = false;
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Sua":

                    string StrMsg = "PopupCenter('/QLAN/ALD/Hoso/Popup/pDuongsuChiTiet.aspx?hsID=" + DonID.ToString() + "&bID=" + ND_id + " ','Thêm đương sự',950,450);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
                    break;
                case "Xoa":
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    
                    xoa(ND_id);
                    LtrThongBao.Text = "Xóa thành công";
                    
                    break;
            }

        }
        public void LoadGrid()
        {
            int page_size = 5;
            int pageindex = Convert.ToInt32(hddPageIndex.Value);

            ALD_DON_DUONGSU_BL oBL = new ALD_DON_DUONGSU_BL();

            string keyDonID = "DONGHEP.DONIDCHITIET" + Session[ENUM_SESSION.SESSION_USERID].ToString();
            decimal IDChitiet = Convert.ToDecimal(Session[keyDonID]);

            DataTable oDT = oBL.ALD_DON_DUONGSU_NOTDAIDIEN_CHITIET(IDChitiet);
            //if (oDT != null && oDT.Rows.Count > 0)
            //{
            #region "Xác định số lượng trang"
            hddTotalPage.Value = Cls_Comon.GetTotalPage(Convert.ToInt32(oDT.Rows.Count), page_size).ToString();
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
            ALD_DON_DUONGSU oT = dt.ALD_DON_DUONGSU.Where(x => x.ID == id).FirstOrDefault();
            dt.ALD_DON_DUONGSU.Remove(oT);
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
                // rpt.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGrid();
            }
            catch (Exception ex) { }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                //  rpt.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
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
                // rpt.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
                hddPageIndex.Value = lbCurrent.Text;
                LoadGrid();
            }
            catch (Exception ex) { }
        }

        protected void lkThemNguoiTGTT_Click(object sender, EventArgs e)
        {
            string strDonID = Session["DS_THEMDSK"] + "";
            if (strDonID != "" && DonID == 0)
                DonID = Convert.ToDecimal(strDonID);

            string StrMsg = "PopupCenter('/QLAN/ALD/Hoso/Popup/pDuongsuChiTiet.aspx?hsID=" + DonID.ToString() + "&bID=0','Thêm đương sự',950,450);";
            System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
        }
    }
}