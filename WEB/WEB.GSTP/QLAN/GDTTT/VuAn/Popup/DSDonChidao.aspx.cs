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
    public partial class DSDonChidao : System.Web.UI.Page
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
                //string strVID = Request["vid"] + "";
                //string strarrid = Request["arrid"] + "";
                //GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                //if (strarrid != "")
                //{
                //    dgDon.DataSource = oBL.DANHSACHDONTHEOID(',' + strarrid + ',');
                //    dgDon.DataBind();
                //}

                decimal VuAnID = (String.IsNullOrEmpty(Request["vID"] + "")) ? 0 : Convert.ToDecimal(Request["vID"] + "");

                GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                DataTable tbl = oBL.DANHSACHDONCHIDAO_ByVuAnID(VuAnID, 2);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    dgDon.DataSource = tbl;
                    dgDon.DataBind();
                }
                if (VuAnID > 0)
                {
                    GDTTT_VUAN oT = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
                    txtNguyendon.Text = oT.NGUYENDON + "";
                    txtBidon.Text = oT.BIDON + "";
                    if (oT.QHPL_DINHNGHIAID != null && oT.QHPL_DINHNGHIAID != 0)
                    {
                        GDTTT_DM_QHPL oQH = dt.GDTTT_DM_QHPL.Where(x => x.ID == oT.QHPL_DINHNGHIAID).FirstOrDefault();
                        txtQHPL.Text = oQH.TENQHPL;
                    }
                }
            }
        }

    }
}