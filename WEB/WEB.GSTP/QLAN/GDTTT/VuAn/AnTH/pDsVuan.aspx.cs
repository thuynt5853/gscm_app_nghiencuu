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
    public partial class pDsVuan : System.Web.UI.Page
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
        String SoBA;
        String NgayBA;
        String ToaXX;
        String ddlLoaiBA;

        protected void Page_Load(object sender, EventArgs e)
        {
            CurrentUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");

            ddlLoaiBA = (String.IsNullOrEmpty(Session["ssddlLoaiBA"] + "")) ? "" : (Session["ssddlLoaiBA"] + "");
            if (Convert.ToDecimal(ddlLoaiBA)==2)
            {
                 SoBA = (String.IsNullOrEmpty(Session["ssSoBAST"] + "")) ? "" : (Session["ssSoBAST"] + "");
                 NgayBA = (String.IsNullOrEmpty(Session["ssNgayBAST"] + "")) ? "" : (Session["ssNgayBAST"] + "");
                 ToaXX = (String.IsNullOrEmpty(Session["ssdropToaAnST"] + "")) ? "" : (Session["ssdropToaAnST"] + "");
            }
            else
            {
                 SoBA = (String.IsNullOrEmpty(Session["ssSoBAPT"] + "")) ? "" : (Session["ssSoBAPT"] + "");
                 NgayBA = (String.IsNullOrEmpty(Session["ssNgayBA"] + "")) ? "" : (Session["ssNgayBA"] + "");
                 ToaXX = (String.IsNullOrEmpty(Session["ssdropToaAn"] + "")) ? "" : (Session["ssdropToaAn"] + "");
            }

            


            if (CurrentUserID == 0)
                Response.Redirect("/Login.aspx");
            else
            {
                if (!IsPostBack)
                {
                    DataTable tbl = null;
                    GDTTT_TUHINH_BL oBL = new GDTTT_TUHINH_BL();

                    tbl = oBL.SearchDanhSachVuAn(SoBA, Convert.ToDateTime(NgayBA), Convert.ToDecimal(ToaXX), Convert.ToDecimal(ddlLoaiBA));
                    if (tbl != null && tbl.Rows.Count > 0)
                    {
                        dgDsVuan.DataSource = tbl;
                        dgDsVuan.DataBind();
                        //dgDsVuan.Columns[dgDsVuan.Columns.Count - 1].Visible = false;
                    }

                    return;
                  

                }
            }
        }
        protected void dgDsVuan_ItemCommand(object source, DataGridCommandEventArgs e)
        {

            //-------------------------------
            Session.Remove("ssVuAnId");
            //-------------------------------
            string vuanid;
            Button ChonVuan = (Button)e.Item.FindControl("cmdChonVuan");
            if (!string.IsNullOrEmpty(e.CommandArgument.ToString()))
            {
                vuanid = e.CommandArgument.ToString();
                Session["ssVuAnId"] = vuanid;
                // ClientScript.RegisterStartupScript(typeof(Page), "closePage", "window.close();", true);
                ClientScript.RegisterStartupScript(typeof(Page), "closePage", "ReloadParent();", true);
            }

        }
        protected void dgDsVuan_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
           
        }

       

    }
}