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


namespace WEB.GSTP.QLAN.GDTTT.Hoso.Popup
{
    public partial class Lichsudon : System.Web.UI.Page
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
                string strarrid = Request["arrid"] + "";
                GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                if (strarrid !="")
                {
                    dgDon.DataSource = oBL.DANHSACHDONTHEOID(','+strarrid+',');
                    dgDon.DataBind();
                    //dgDon.Columns[8].Visible = false;
                    pnBoSung.Visible = false;
                    return;
                }
                if (strVID !="")
                {                   
                   
                    decimal ID = Convert.ToDecimal(strVID);
                    LoadDSDon();
                    LoadBoSung();
                    dgList.DataSource = oBL.LICHSUDON(ID);
                    dgList.DataBind();
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
        protected void dgDon_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            switch (e.CommandName)
            {
                case "Xoa":
                    decimal ID = Convert.ToDecimal(e.CommandArgument.ToString());
                    GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                    GDTTT_DON d = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();
                    decimal DontrungID = d.DONTRUNGID == null ? 0 : (decimal)d.DONTRUNGID;
                    if (DontrungID > 0)
                    {
                        d.DONTRUNGID = 0;
                        d.SOLUONGDON = 1;
                        dt.SaveChanges();
                        oBL.UPDATESOLUONGDON(DontrungID);
                        LoadDSDon();
                    }
                    else //Đơn Hủy chính là đơn gốc
                    {
                        d.SOLUONGDON = 1;
                        dt.SaveChanges();
                        List<GDTTT_DON> lstT = dt.GDTTT_DON.Where(x => x.DONTRUNGID == ID).OrderByDescending(x => x.NGAYTAO).ToList();
                        if (lstT.Count == 1)
                        {
                            d.SOLUONGDON = 1;
                            lstT[0].SOLUONGDON = 1;
                            lstT[0].DONTRUNGID = 0;
                            dt.SaveChanges();
                            LoadDSDon();
                        }
                        else if (lstT.Count > 1)
                        {
                            GDTTT_DON dtGoc = lstT[0];
                            dtGoc.SOLUONGDON = 1;
                            dtGoc.DONTRUNGID = 0;
                            foreach (GDTTT_DON dt in lstT)
                            {
                                if (dt.ID != dtGoc.ID)
                                {
                                    dt.SOLUONGDON = 1;
                                    dt.DONTRUNGID = dtGoc.ID;
                                }
                            }
                            dt.SaveChanges();
                            oBL.UPDATESOLUONGDON(dtGoc.ID);
                            LoadDSDon();
                        }
                    }
                    break;
            }
        }
    }
}