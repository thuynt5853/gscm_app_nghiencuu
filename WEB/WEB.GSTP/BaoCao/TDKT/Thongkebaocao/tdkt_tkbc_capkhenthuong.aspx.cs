using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.BaoCao.TDKT.Thongkebaocao
{
    public partial class tdkt_tkbc_capkhenthuong : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                string strUserID = Session[ENUM_SESSION.SESSION_USERID] + "";
                if (strUserID == "") Response.Redirect(Cls_Comon.GetRootURL() + "/Login.aspx");
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        protected void BtnXem_Click(object sender, EventArgs e)
        {
            try
            {
                LoadReport();
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        protected void BtnLamMoi_Click(object sender, EventArgs e)
        {
            TxtTuNgay.Text = TxtDenNgay.Text = "";
        }
        private void LoadReport()
        {
            Lblthongbao.Text = "";
            string CapDonVi = DropCapDonVi.SelectedValue;
            decimal DonViID = 0
                    , HinhThuc_ThiDuaID = 0
                    , HinhThuc_KhenThuongID = 0;
            DateTime? TuNgay = TxtTuNgay.Text.Trim() == "" ? (DateTime?)null : Convert.ToDateTime(TxtTuNgay.Text, cul)
                      , DenNgay = TxtDenNgay.Text.Trim() == "" ? (DateTime?)null : Convert.ToDateTime(TxtDenNgay.Text, cul);
            OracleParameter[] parameters = new OracleParameter[] {
                    new OracleParameter("IN_DONVIID",DonViID),
                    new OracleParameter("IN_TUNGAY",TuNgay),
                    new OracleParameter("IN_DENNGAY",DenNgay),
                    new OracleParameter("IN_HINH_THUC_THI_DUA",HinhThuc_ThiDuaID),
                    new OracleParameter("IN_HINH_THUC_KHEN_THUONG",HinhThuc_KhenThuongID),
                    new OracleParameter("IN_CAP_DON_VI",CapDonVi),
                    new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("TDKT_THONGKE_BAOCAO", parameters);
            if (tbl.Rows.Count > 0)
            {
                rpt_tkbc rpt = new rpt_tkbc();
                DTBIEUMAU objds = new DTBIEUMAU();
                foreach (DataRow item in tbl.Rows)
                {
                    DTBIEUMAU.TDKT_TKE_BCAORow r = objds.TDKT_TKE_BCAO.NewTDKT_TKE_BCAORow();
                    r["STT"] = item["STT"];
                    r["LOAIDOITUONG"] = item["LOAIDOITUONG"];
                    r["TENDOITUONG"] = item["TENDOITUONG"];
                    r["CHUCDANH"] = item["CHUCDANH"];
                    r["DIACHI"] = item["DIACHI"];
                    r["LOAI_HINH_KHEN_THUONG"] = item["LOAI_HINH_KHEN_THUONG"];
                    r["HINH_THUC_KHEN_THUONG"] = item["HINH_THUC_KHEN_THUONG"];
                    objds.TDKT_TKE_BCAO.AddTDKT_TKE_BCAORow(r);
                }
                objds.AcceptChanges();
                rpt.DataSource = objds;
                rpt.CreateDocument();
                rptView.OpenReport(rpt);
            }
            else { Lblthongbao.Text = "Không tìm thấy dữ liệu phù hợp. Hãy xem lại!"; }

        }
    }
}