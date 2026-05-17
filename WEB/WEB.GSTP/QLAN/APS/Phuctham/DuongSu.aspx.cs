using BL.GSTP.APS;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.APS.Phuctham
{
    public partial class DuongSu : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public bool GetNumber(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return false;
                else
                    return Convert.ToBoolean(obj);
            }
            catch (Exception ex)
            { return false; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    string current_id = Session[ENUM_LOAIAN.AN_PHASAN] + "";
                    if (current_id == "") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/APS/Hoso/Danhsach.aspx");
                    LoadGrid();
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(cmdChonDuongSu, oPer.CAPNHAT);
                    //Kiểm tra thẩm phán giải quyết đơn             
                    decimal DONID = Convert.ToDecimal(current_id);
                    APS_DON oT = dt.APS_DON.Where(x => x.ID == DONID).FirstOrDefault();
                    List<APS_PHUCTHAM_THULY> lstCount = dt.APS_PHUCTHAM_THULY.Where(x => x.DONID == DONID).ToList();
                    if (lstCount.Count == 0 || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.HOSO || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
                    {
                        lbthongbao.Text = "Chưa cập nhật thông tin thụ lý phúc thẩm!";
                        Cls_Comon.SetButton(cmdChonDuongSu, false);
                        return;
                    }
                    List<APS_DON_THAMPHAN> lstTP = dt.APS_DON_THAMPHAN.Where(x => x.DONID == DONID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETPHUCTHAM).ToList();
                    if (lstTP.Count == 0)
                    {
                        lbthongbao.Text = "Chưa phân công thẩm phán giải quyết !";
                        Cls_Comon.SetButton(cmdChonDuongSu, false);
                        return;
                    }
                    if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                    {
                        lbthongbao.Text = "Vụ việc đã được chuyển lên tòa án cấp trên, không được sửa đổi !";
                        Cls_Comon.SetButton(cmdChonDuongSu, false);
                        return;
                    }
                    if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
                    {
                        lbthongbao.Text = "Vụ việc đã được chuyển xét xử lại cấp sơ thẩm, không được sửa đổi !";
                        Cls_Comon.SetButton(cmdChonDuongSu, false);
                        return;
                    }
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void cmdChonDuongSu_Click(object sender, EventArgs e)
        {
            foreach (DataGridItem oItem in dgList.Items)
            {
                string strID = oItem.Cells[0].Text;
                decimal DSID = Convert.ToDecimal(strID);
                CheckBox chkSoTham = (CheckBox)oItem.FindControl("chkSoTham");
                APS_DON_DUONGSU oT = dt.APS_DON_DUONGSU.Where(x => x.ID == DSID).FirstOrDefault();
                oT.ISPHUCTHAM = chkSoTham.Checked == true ? 1 : 0;
                dt.SaveChanges();
            }
            lbthongbao.Text = "Hoàn thành lưu đương sự tham gia thụ lý Sơ thẩm !";
        }
        public void LoadGrid()
        {
            APS_DON_DUONGSU_BL oBL = new APS_DON_DUONGSU_BL();
            string current_id = Session[ENUM_LOAIAN.AN_PHASAN] + "";
            decimal ID = Convert.ToDecimal(current_id);
            DataTable oDT = oBL.APS_PHUCTHAM_DUONGSU_GETBY(ID, 0);

            if (oDT != null && oDT.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Convert.ToInt32(oDT.Rows.Count), Convert.ToInt32(20)).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + oDT.Rows.Count.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion

                dgList.DataSource = oDT;
                dgList.DataBind();
                pndata.Visible = true;
            }
            else
            {
                pndata.Visible = false;
            }
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
                hddPageIndex.Value = lbCurrent.Text;
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #endregion
    }
}