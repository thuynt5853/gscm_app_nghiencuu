using BL.GSTP;
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

namespace WEB.GSTP.QLAN.GDTTT.VuAn.Popup
{
    public partial class DSDonQuocHoi : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public string GetDate(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return "";
                else
                    return Convert.ToDateTime(obj).ToString("dd/MM/yyyy");
            }
            catch (Exception ex)
            { return ""; }
        }
        public bool GetBool(object obj)
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
            if (!IsPostBack)
            {
                decimal VuAnID = (String.IsNullOrEmpty(Request["vID"] + "")) ? 0 : Convert.ToDecimal(Request["vID"] + "");
                Decimal NhomAnQH = 1023;
                GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                //DataTable tbl = oBL.DANHSACHDONTHEOVuAnID(VuAnID);
                //lay cac đon co loai= CV+don , trang thai = da nhan theo vu an id
                DataTable tbl = oBL.GetAllByVuAn_TrangThaiChuyenDon(VuAnID, 2, 3, NhomAnQH);
                if (tbl != null && tbl.Rows.Count>0)
                {
                    dgDon.DataSource = tbl;
                    dgDon.DataBind();
                }
                if (VuAnID > 0)
                {
                    GDTTT_VUAN oT = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
                    txtNguyendon.Text = oT.NGUYENDON + "";
                    txtBidon.Text = oT.BIDON + "";
                    if(oT.QHPL_DINHNGHIAID !=null && oT.QHPL_DINHNGHIAID !=0)
                    {
                        GDTTT_DM_QHPL oQH = dt.GDTTT_DM_QHPL.Where(x => x.ID == oT.QHPL_DINHNGHIAID).FirstOrDefault();
                        txtQHPL.Text = oQH.TENQHPL;
                    }
                    if (oT.LOAIAN == 1)
                    {
                        lblTitleBC.Text = "Bi cáo đầu vụ";
                        lblTitleBCDV.Text = "Bị cáo khiếu nại";
                        lblTitleTD.Text = "Tội danh";
                    }
                    else
                    {
                        lblTitleBC.Text = "Nguyên đơn/ Người khởi kiện";
                        lblTitleBCDV.Text = "Bị đơn/ Người  bị kiện";
                        lblTitleTD.Text = "Quan hệ pháp luật";
                    }
                    
                }
            }
        }
       
    }
}