using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using BL.GSTP;
using Module.Common;
using DAL.GSTP;

namespace WEB.TP.UC
{
    public partial class Header : System.Web.UI.UserControl
    {
        GSTPContext dt = new GSTPContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string strUserID = Session[ENUM_SESSION.SESSION_USERID] + "";
                if (strUserID == "") Response.Redirect(Cls_Comon.GetRootURL() + "/Login.aspx");
                lstUserName.Text = "Tài khoản: " + Session[ENUM_SESSION.SESSION_USERNAME] + "";
                //string strMaCT = Session["MaChuongTrinh"] + "";
                decimal DONVITHA_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                DM_DONVITHIHANHAN otDV = dt.DM_DONVITHIHANHAN.Where(x => x.ID == DONVITHA_ID).FirstOrDefault();
                li_tendonvi.Text = otDV.MA_TEN.ToUpper();
                //---------------
                LoadMenu();
                Load_tkth();
            }
        }
        protected void lkSigout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect(Cls_Comon.GetRootURL() + "/Login.aspx");
        }

        void LoadMenu()
        {
            decimal IDUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
            QT_TUPHAP_BL oBL = new QT_TUPHAP_BL();
            DataTable  lst = oBL.QT_CHUONGTRINH_GETBYUSER_THADS(IDUser);
            //rptMenu.DataSource = lst;
            //rptMenu.DataBind();
            ltt.Text = "";
            foreach (DataRow obj in lst.Rows)
            {
                ltt.Text += "<a href='" + obj["DUONGDAN"] + "?&thadsID=" + Convert.ToString(obj["ID"]) + "'  class='" + SetMenuClass(Convert.ToString(obj["DUONGDAN"])) + "'>" + obj["TENMENU"] + "</a>";
            }
        }
        protected void rptMenu_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            try
            {
                String ND_id = e.CommandArgument.ToString();
                String[] ND_id_arr = ND_id.Split(';');
                Session["MaChuongTrinh"] = ND_id_arr[0];
                switch (e.CommandName)
                {
                    case "SELECT":
                        Response.Redirect(Cls_Comon.GetRootURL() + ND_id_arr[1]);
                        break;
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView dv = (DataRowView)e.Item.DataItem;
                LinkButton cmdButton = (LinkButton)e.Item.FindControl("lbtChuongTrinh");
                String ND_id = cmdButton.CommandArgument;
                String[] ND_id_arr = ND_id.Split(';');
                string strMaCT = Session["MaChuongTrinh"] + "";
                if (strMaCT == "")
                {
                    if (dv["ID"].ToString() == "1")
                    {
                        cmdButton.CssClass = "menubuttonActive";
                    }
                }
                else if (strMaCT != "")
                {
                    if (ND_id_arr[0] == strMaCT)
                    {
                        cmdButton.CssClass = "menubuttonActive";
                    }
                    else
                        cmdButton.CssClass = "menubutton";
                }
            }
        }
        string SetMenuClass(string pagename)
        {
            String mn_active = "menubuttonActive";
            String mn_noactive = "menubutton";

            String menu_class = "";
            string CurrPage = HttpContext.Current.Request.Url.PathAndQuery.ToLower();
            if (CurrPage.Contains(pagename.ToLower()))
                menu_class = mn_active;
            else
                menu_class = mn_noactive;
            return menu_class;
        }
        protected void Load_tkth()
        {
            decimal current_id = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
            TUPHAP_NGUOISUDUNG nd = dt.TUPHAP_NGUOISUDUNG.Where(x => x.ID == current_id).FirstOrDefault();
            Decimal Donvi_ID = Convert.ToDecimal(nd.DONVITHA_ID);
            DM_TK_THANHTOAN ott = dt.DM_TK_THANHTOAN.Where(x => x.THA_ID == Donvi_ID).FirstOrDefault();
            if (ott != null)
            {
                if(ott.TEN_TK_THUHUONG!="" && ott.TEN_TK_THUHUONG!=null)
                {
                    tkth_div.Style.Add("Display", "none");
                }
                else
                {
                    tkth_div.Style.Remove("Display");
                }
                //---------------
               
            }

        }
    }
}