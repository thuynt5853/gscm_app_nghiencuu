using BL.GSTP;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.UserControl.QLA
{
    public partial class ThongKeVanBanTongDatChuaDangCTTDT : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                string strUserID = Session[ENUM_SESSION.SESSION_USERID] + "";
                if (strUserID == "") Response.Redirect(Cls_Comon.GetRootURL() + "/Login.aspx");
                string strMaHeThong = Session["MaHeThong"] + "";
                if (strMaHeThong == "") Response.Redirect(Cls_Comon.GetRootURL() + "/Launcher.aspx");
                string strMaChuongTrinh = Session["MaChuongTrinh"] + "";
                if (!IsPostBack)
                {
                    decimal IDHethong = Convert.ToDecimal(strMaHeThong);
                    decimal USERID = Convert.ToDecimal(strUserID);

                    QT_NGUOIDUNG_BL oBL = new QT_NGUOIDUNG_BL();
                    DataTable lst;
                    string strSessionKey = "CHUONGTRINH_" + USERID.ToString() + "_" + IDHethong.ToString();
                    if (Session[strSessionKey] == null)
                        lst = oBL.QT_CHUONGTRINH_GETBYUSER(USERID, IDHethong);
                    else
                        lst = (DataTable)Session[strSessionKey];
                    if (lst != null && lst.Rows.Count > 0)
                    {
                        foreach (DataRow r in lst.Rows)
                        {
                            hddList_Menu_LoaiAn.Value += r["MA"] + ";";
                        }
                    }
                   
                    if (strMaChuongTrinh == "" || strMaChuongTrinh == "0")//Tab menu trang chủ
                        LoadData();
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private void LoadData()
        {
            int Total = 0, PageSize = Convert.ToInt32(hddPageSize.Value), PageIndex = Convert.ToInt16(hddPageIndexCT.Value);
            decimal TOAAN_ID = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vToaAnID",TOAAN_ID),
                new OracleParameter("vListTab_Menu_LoaiAn",hddList_Menu_LoaiAn.Value),
                new OracleParameter("vPageIndex",PageIndex),
                new OracleParameter("vPageSize",PageSize),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("THONGKEVB_CHUADANG_CTTDT", prm);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                Total = Convert.ToInt32(tbl.Rows[0]["Total"]);
            }
            dgList.PageSize = PageSize;
            dgList.CurrentPageIndex = 0;
            dgList.DataSource = tbl;
            dgList.DataBind();
            #region "Xác định số lượng trang"
            hddTotalPageCT.Value = Cls_Comon.GetTotalPage(Total, PageSize).ToString();
            lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + Total.ToString() + " </b> bản ghi trong <b>" + hddTotalPageCT.Value + "</b> trang";
            Cls_Comon.SetPageButton(hddTotalPageCT, hddPageIndexCT, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                         lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
            #endregion
            if (Total == 0)
            {
                lstSobanghiT.Text = lstSobanghiB.Text = "";
                pnData.Visible = PhanTrangT.Visible = PhanTrangB.Visible = false;
            }
            else
            {
                pnData.Visible = PhanTrangT.Visible = PhanTrangB.Visible = true;
            }
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndexCT.Value = (Convert.ToInt32(hddPageIndexCT.Value) - 1).ToString();
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndexCT.Value = "1";
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndexCT.Value = Convert.ToInt32(hddTotalPageCT.Value).ToString();
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndexCT.Value = (Convert.ToInt32(hddPageIndexCT.Value) + 1).ToString();
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                hddPageIndexCT.Value = lbCurrent.Text;
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #endregion
    }
}