using BL.GSTP.DLQGC06;
using DAL.GSTP;
using System;
using System.Globalization;
using System.Data;

namespace WEB.GSTP.QLAN.C06
{
    public partial class LichSuDongBo : System.Web.UI.Page
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
                string strVID = Request["vid"] + "";
                DLQGC06_BL oBL = new DLQGC06_BL();
                DataTable tbl = oBL.GetDulieu_LichSuChuyen(strVID);
                if (tbl.Rows.Count > 0)
                {
                    dgList.DataSource = tbl;
                    dgList.DataBind();
                }
                
            }
        }
        
      
    }
}