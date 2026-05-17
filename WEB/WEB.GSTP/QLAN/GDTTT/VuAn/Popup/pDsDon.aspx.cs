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
    public partial class pDsDon : System.Web.UI.Page
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
                    GDTTT_DON_BL oBL = new GDTTT_DON_BL();

                    //------------------------------
                    String ArrDonID = (String.IsNullOrEmpty(Request["arrid"] + "")) ? "" : Request["arrid"].ToString();
                    if (ArrDonID.Length > 0)
                    {
                        tbl = oBL.DANHSACHDONTHEOID(',' + ArrDonID + ',');
                        if (tbl != null && tbl.Rows.Count > 0)
                        {
                            dgDon.DataSource = tbl;
                            dgDon.DataBind();
                            pnBoSung.Visible = false;
                            string strvdcid = Request["vdcid"] + "";
                            if (strvdcid == "") dgDon.Columns[dgDon.Columns.Count - 1].Visible = false;
                            return;
                        }
                    }
                    else
                    {
                        decimal VuAnID = (String.IsNullOrEmpty(Request["vID"] + "")) ? 0 : Convert.ToDecimal(Request["vID"] + "");
                        tbl = oBL.GetAllByVuAn_TrangThaiChuyenDon(VuAnID, 2, 4, 0);
                        if (tbl != null && tbl.Rows.Count > 0)
                        {
                            dgDon.DataSource = tbl;
                            dgDon.DataBind();
                            pnBoSung.Visible = false;
                            dgDon.Columns[dgDon.Columns.Count - 1].Visible = false;
                            return;
                        }
                        if (VuAnID > 0)
                        {
                            decimal ID = Convert.ToDecimal(VuAnID);
                            LoadDSDon();
                            LoadBoSung();
                            dgList.DataSource = oBL.LICHSUDON(ID);
                            dgList.DataBind();
                        }

                    }
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
            switch (e.CommandName)
            {
                case "Xoa":
                    decimal ID = Convert.ToDecimal(e.CommandArgument.ToString());
                    GDTTT_DON_BOSUNG oT = dt.GDTTT_DON_BOSUNG.Where(x => x.ID == ID).FirstOrDefault();
                    dt.GDTTT_DON_BOSUNG.Remove(oT);
                    dt.SaveChanges();
                    lbthongbao.Text = "Xóa thành công!";
                    LoadBoSung();
                    break;
            }
        }
        protected void dgDon_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            switch (e.CommandName)
            {
                case "Tralai":
                    decimal ID = Convert.ToDecimal(e.CommandArgument.ToString());
                    string strvdcid = Request["vdcid"] + "";
                    if (strvdcid != "")
                    {
                        decimal dcid = Convert.ToDecimal(strvdcid);
                        GDTTT_DON_CHUYEN oDC = dt.GDTTT_DON_CHUYEN.Where(x => x.ID == dcid).FirstOrDefault();
                        oDC.SOLUONGDON = oDC.SOLUONGDON - 1;
                        oDC.ARRDONTRUNG = (oDC.ARRDONTRUNG + ",").Replace((ID.ToString() + ","), "");
                        dt.SaveChanges();
                        GDTTT_DON oDon = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();
                        oDon.CD_TRANGTHAI = 3;
                        dt.SaveChanges();

                        Response.Redirect("pDsDon.aspx?vdcid=" + strvdcid + "&arrid=" + oDC.ARRDONTRUNG);
                    }
                    break;
            }
        }
        private void LoadBoSung()
        {
            string strVID = Request["vid"] + "";
            if (strVID != "")
            {
                GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                decimal ID = Convert.ToDecimal(strVID);
                dgDS.DataSource = oBL.BOSUNGTAILIEU(ID);
                dgDS.DataBind();
            }
            if (dgDS.Items.Count > 0)
                pnBoSung.Visible = true;
            else
                pnBoSung.Visible = false;
        }
    }
}