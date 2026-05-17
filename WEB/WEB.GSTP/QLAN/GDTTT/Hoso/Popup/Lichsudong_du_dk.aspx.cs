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
    public partial class Lichsudong_du_dk : System.Web.UI.Page
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
                string thamphan = Request["thamphan"] + "";
                GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                if (strarrid != "")
                {
                    LoadDSTrung();
                    LoadDSKemTheo();
                    LoadBoSung();
                    decimal ID = Convert.ToDecimal(strarrid);
                    dgList.DataSource = oBL.LICHSUDON(ID);
                    dgList.DataBind();
                }
            }
        }
        private void LoadDSTrung()
        {
            string thamphan = Request["thamphan"] + "";
            string strarrid = Request["arrid"] + "";
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            if (strarrid != "")
            {
                DataTable tbl = oBL.DANHSACHDONTRUNG(Convert.ToDecimal(strarrid));
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    dgDSDonTrung.DataSource = tbl;
                    dgDSDonTrung.DataBind();
                    if (thamphan == "1")
                    {
                        dgDSDonTrung.Columns[9].Visible = false;
                    }
                    else
                    {
                        dgDSDonTrung.Columns[9].Visible = true;
                    }
                    pnDSTrung.Visible = true;
                }
                else
                {
                    pnDSTrung.Visible = false;
                }
            }
        }
        private void LoadDSKemTheo()
        {
            string strarrid = Request["arrid"] + "";
            string thamphan = Request["thamphan"] + "";
            if (strarrid != "")
            {
                decimal DonID = Convert.ToDecimal(strarrid);
                GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                DataTable tbl = oBL.DANHSACHDON_KEMTHEO(DonID);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    dgDSDonKemTheo.DataSource = tbl;
                    dgDSDonKemTheo.DataBind();
                    if (thamphan == "1")
                    {
                        dgDSDonKemTheo.Columns[9].Visible = false;
                    }
                    else
                    {
                        dgDSDonKemTheo.Columns[9].Visible = true;
                    }
                    pnDS_DonKemTheo.Visible = true;
                }
                else
                {
                    pnDS_DonKemTheo.Visible = false;
                }
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
        protected void dgDSDonTrung_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            switch (e.CommandName)
            {
                case "Xoa":
                    decimal ID = Convert.ToDecimal(e.CommandArgument.ToString());
                    GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                    GDTTT_DON d = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();
                    decimal DontrungID = d.DONTRUNGID == null ? 0 : (decimal)d.DONTRUNGID;
                    decimal ARR_DON_ID = d.ARR_DON_ID == null ? 0 : (decimal)d.ARR_DON_ID;
                    if (ARR_DON_ID > 0)
                    {
                        d.ARR_DON_ID = 0;   //hủy trùng cho trường mới ARR_DON_ID 25/06/2024
                        d.CD_TA_TRANGTHAI = 1;  //1 Đơn chưa đủ điều kiện
                        dt.SaveChanges();
                        LoadDSTrung();
                    }
                    //else //hiện tại tạm thời đóng lại vì việc quản lý đơn trùng không quản lý nữa
                    //{
                    //    if (DontrungID > 0)
                    //    {
                    //        d.DONTRUNGID = 0;
                    //        d.SOLUONGDON = 1;
                    //        dt.SaveChanges();
                    //        oBL.UPDATESOLUONGDON(DontrungID);
                    //        LoadDSDon();
                    //    }
                    //    else //Đơn Hủy chính là đơn gốc
                    //    {
                    //        d.SOLUONGDON = 1;
                    //        dt.SaveChanges();
                    //        List<GDTTT_DON> lstT = dt.GDTTT_DON.Where(x => x.DONTRUNGID == ID).OrderByDescending(x => x.NGAYTAO).ToList();

                    //        if (lstT.Count == 1)
                    //        {
                    //            d.SOLUONGDON = 1;
                    //            lstT[0].SOLUONGDON = 1;
                    //            lstT[0].DONTRUNGID = 0;
                    //            dt.SaveChanges();
                    //            LoadDSDon();
                    //        }
                    //        if (lstT.Count > 1)
                    //        {
                    //            GDTTT_DON dtGoc = lstT[0];
                    //            dtGoc.SOLUONGDON = 1;
                    //            dtGoc.DONTRUNGID = 0;
                    //            foreach (GDTTT_DON dt in lstT)
                    //            {
                    //                if (dt.ID != dtGoc.ID)
                    //                {
                    //                    dt.SOLUONGDON = 1;
                    //                    dt.DONTRUNGID = dtGoc.ID;
                    //                }
                    //            }
                    //            dt.SaveChanges();
                    //            oBL.UPDATESOLUONGDON(dtGoc.ID);
                    //            LoadDSDon();
                    //        }
                    //    }
                    //}
                    break;
            }
        }
        protected void dgDSDonKemTheo_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            switch (e.CommandName)
            {
                case "Xoa":
                    decimal ID = Convert.ToDecimal(e.CommandArgument.ToString());
                    GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                    GDTTT_DON d = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();
                    decimal DontrungID = d.DONTRUNGID == null ? 0 : (decimal)d.DONTRUNGID;
                    decimal ARR_DON_ID = d.ARR_DON_ID == null ? 0 : (decimal)d.ARR_DON_ID;
                    if (ARR_DON_ID > 0)
                    {
                        d.ARR_DON_ID = 0;   //hủy trùng cho trường mới ARR_DON_ID 25/06/2024
                        d.CD_TA_TRANGTHAI = 1;  //1 Đơn chưa đủ điều kiện
                        dt.SaveChanges();
                        LoadDSKemTheo();
                    }
                    //else //hiện tại tạm thời đóng lại vì việc quản lý đơn trùng không quản lý nữa
                    //{
                    //    if (DontrungID > 0)
                    //    {
                    //        d.DONTRUNGID = 0;
                    //        d.SOLUONGDON = 1;
                    //        dt.SaveChanges();
                    //        oBL.UPDATESOLUONGDON(DontrungID);
                    //        LoadDSDon();
                    //    }
                    //    else //Đơn Hủy chính là đơn gốc
                    //    {
                    //        d.SOLUONGDON = 1;
                    //        dt.SaveChanges();
                    //        List<GDTTT_DON> lstT = dt.GDTTT_DON.Where(x => x.DONTRUNGID == ID).OrderByDescending(x => x.NGAYTAO).ToList();

                    //        if (lstT.Count == 1)
                    //        {
                    //            d.SOLUONGDON = 1;
                    //            lstT[0].SOLUONGDON = 1;
                    //            lstT[0].DONTRUNGID = 0;
                    //            dt.SaveChanges();
                    //            LoadDSDon();
                    //        }
                    //        if (lstT.Count > 1)
                    //        {
                    //            GDTTT_DON dtGoc = lstT[0];
                    //            dtGoc.SOLUONGDON = 1;
                    //            dtGoc.DONTRUNGID = 0;
                    //            foreach (GDTTT_DON dt in lstT)
                    //            {
                    //                if (dt.ID != dtGoc.ID)
                    //                {
                    //                    dt.SOLUONGDON = 1;
                    //                    dt.DONTRUNGID = dtGoc.ID;
                    //                }
                    //            }
                    //            dt.SaveChanges();
                    //            oBL.UPDATESOLUONGDON(dtGoc.ID);
                    //            LoadDSDon();
                    //        }
                    //    }
                    //}
                    break;
            }
        }
    }
}