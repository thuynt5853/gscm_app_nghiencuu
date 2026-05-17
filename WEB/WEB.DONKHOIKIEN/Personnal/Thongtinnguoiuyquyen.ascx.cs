using BL.DonKK.Model;
using BL.GSTP.DONGHEP;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.DONKHOIKIEN.Personnal
{
    public partial class Thongtinnguoiuyquyen : System.Web.UI.UserControl
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public decimal DONID;
        public Decimal LOAIANID;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadGrid();
            }
        }
        private List<DONKK_DON_DUONGSU_TEMP> GetDataStoreSession()
        {
            decimal IdUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
            string Key = "DONKK_DON_DUONGSU_TEMP" + IdUser;
            if (Session[Key] == null)
            {
                return new List<DONKK_DON_DUONGSU_TEMP>();
            }
            else
            {
                return (List<DONKK_DON_DUONGSU_TEMP>)Session[Key];
            }
        }
        private void SetDataStoreSession(List<DONKK_DON_DUONGSU_TEMP> data)
        {
            decimal IdUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
            string Key = "DONKK_DON_DUONGSU_TEMP" + IdUser;
            Session[Key] = data;
        }

        private List<DONKK_DON_DUONGSU_TEMP> GetDataStoreSessionADDNEW()
        {
            decimal IdUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
            string Key = "DONKK_DON_DUONGSU_TEMP_ADDNEW" + IdUser;
            if (Session[Key] == null)
            {
                return new List<DONKK_DON_DUONGSU_TEMP>();
            }
            else
            {
                return (List<DONKK_DON_DUONGSU_TEMP>)Session[Key];
            }
        }
        private void SetDataStoreSessionADDNEW(List<DONKK_DON_DUONGSU_TEMP> data)
        {
            decimal IdUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
            string Key = "DONKK_DON_DUONGSU_TEMP_ADDNEW" + IdUser;
            Session[Key] = data;
        }


        public void LoadGrid()
        {
            var lstData = GetDataStoreSession();
            if (lstData != null && lstData.Count > 0)
            {
                int count_all = lstData.Count;
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, Convert.ToInt32(10)).ToString();
                //lstSobanghiB.Text = "Có <b>" + count_all.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                //Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             //lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion

                rptDuongSuKhac.DataSource = lstData;
                rptDuongSuKhac.DataBind();
                pnDuongSu.Visible = rptDuongSuKhac.Visible = true;
                //pnPagingDSKhacTop.Visible = PpnPagingDSKhacBottom.Visible = true;
            }
            else
            {
                pnDuongSu.Visible = false;
                //lstSobanghiT.Visible = false;
                rptDuongSuKhac.Visible = false;
                //pnPagingDSKhacTop.Visible = PpnPagingDSKhacBottom.Visible = false;
            }
        }
        protected void rptDuongSuKhac_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string ND_id = e.CommandArgument.ToString();
            //string keyDonID = "DONGHEP.DONID" + Session[ENUM_SESSION.SESSION_USERID].ToString();

            switch (e.CommandName)
            {
                case "Sua":
                    Cls_Comon.CallFunctionJS(this, this.GetType(), "show_popup_by_loaidsNguoiuyquyen('" + ENUM_DANSU_TUCACHTOTUNG.NGUOIUYQUYEN + "','" + ND_id + "')");
                    break;
                case "Xoa":
                    var lstData = GetDataStoreSession();
                    lstData.Remove(lstData.FirstOrDefault(s => s.ID_TEMP == ND_id));
                    SetDataStoreSession(lstData);
                    lttMsgDS.Text = "Xóa thành công";
                    LoadGrid();
                    break;
            }
        }


        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            LoadGrid();
        }

        protected void lbThemMoiDon_Click(object sender, EventArgs e)
        {
            //string keyDonID = "DONGHEP.DONID" + Session[ENUM_SESSION.SESSION_USERID].ToString();
            string keyLoaiAnId = "DONGHEP.LOAIANID" + Session[ENUM_SESSION.SESSION_USERID].ToString();
            LOAIANID = Convert.ToDecimal(Session[keyLoaiAnId]);
            Cls_Comon.CallFunctionJS(this, this.GetType(), "popup_edit_DONGHEP(" + LOAIANID + ")");
        }
        #region "Phân trang ds duong su"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            LoadGrid();
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {

            hddPageIndex.Value = "1";
            LoadGrid();
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            LoadGrid();
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            LoadGrid();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            hddPageIndex.Value = lbCurrent.Text;
            LoadGrid();
        }

        #endregion
    }
}