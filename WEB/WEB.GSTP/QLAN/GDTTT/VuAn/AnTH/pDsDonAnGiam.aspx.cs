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
using BL.GSTP.GDTTT;


namespace WEB.GSTP.QLAN.GDTTT.VuAn.AnTH
{
    public partial class pDsDonAnGiam : System.Web.UI.Page
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
        Decimal CurrentUserID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrentUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrentUserID == 0)
                Response.Redirect("/Login.aspx");
            else
            {
                if (!IsPostBack)
                {
                    DataTable tbl = null;
                    GDTTT_TUHINH_BL oBL = new GDTTT_TUHINH_BL();

                    //------------------------------
                    decimal VuanID = (String.IsNullOrEmpty(Request["vID"] + "")) ? 0 : Convert.ToDecimal(Request["vID"] + "");
                    decimal DuongsuID = (String.IsNullOrEmpty(Request["dsID"] + "")) ? 0 : Convert.ToDecimal(Request["dsID"] + "");
                        tbl = oBL.GetDonByDuongsu(VuanID, DuongsuID);
                        if (tbl != null && tbl.Rows.Count > 0)
                        {
                            dgDon.DataSource = tbl;
                            dgDon.DataBind();
                            dgDon.Columns[dgDon.Columns.Count - 1].Visible = false;
                        }
                    DataTable tbl_donVu = null;
                    tbl_donVu = oBL.GetDonVu1ByDuongsu(VuanID, DuongsuID);
                    if (tbl_donVu != null && tbl_donVu.Rows.Count > 0)
                    {
                        dgDSDonVu1.DataSource = tbl_donVu;
                        dgDSDonVu1.DataBind();
                        dgDSDonVu1.Columns[dgDSDonVu1.Columns.Count - 1].Visible = false;
                        
                    }
                    return;
                    //pnDonVu1.Visible = false;
                    //if (DuongsuID > 0)
                    //{
                    //    decimal ID = Convert.ToDecimal(DuongsuID);
                    //    LoadDSDon();
                    //    LoadBoSung();
                    //    dgList.DataSource = oBL.LICHSUDON(ID);
                    //    dgList.DataBind();
                    //}


                }
            }
        }
        private void LoadDSDon()
        {
            string strVID = Request["vid"] + "";
            if (strVID != "")
            {
                GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                decimal ID = Convert.ToDecimal(strVID);
                dgDon.DataSource = oBL.DANHSACHDONTRUNG(ID);
                dgDon.DataBind();
                dgDon.Columns[dgDon.Columns.Count - 1].Visible = false;
            }
        }
        protected void dgDS_ItemCommand(object source, DataGridCommandEventArgs e)
        {
           
        }
        protected void dgDon_ItemCommand(object source, DataGridCommandEventArgs e)
        {
           
        }
       
    }
}