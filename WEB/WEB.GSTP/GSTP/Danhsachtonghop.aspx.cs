using BL.GSTP;
using BL.GSTP.GSTP;
using DAL.GSTP;
using DevExpress.Utils;
using DevExpress.XtraCharts;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.GSTP
{
    public partial class Danhsachtonghop : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        GSTP_BL bl = new GSTP_BL();
        CultureInfo cul = new CultureInfo("vi-VN");
        private static DataTable tblTKTP = new DataTable();
        private const int PHAMVI_TRONG_NAM = 1, PHAMVI_TRONG_THANG = 2, PHAMVI_TRONG_NGAY = 3;

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                string strUserID = Session[ENUM_SESSION.SESSION_USERID] + "";
                if (strUserID == "") Response.Redirect(Cls_Comon.GetRootURL() + "/Login.aspx");
                string strMaHeThong = Session["MaHeThong"] + "";
                if (strMaHeThong == "") Response.Redirect(Cls_Comon.GetRootURL() + "/Launcher.aspx");
                if (!IsPostBack)
                {
                    string a = Session["MaChuongTrinh"] + "";
                    decimal IDHethong = Session["MaHeThong"] + "" == "" ? 0 : Convert.ToDecimal(Session["MaHeThong"] + "");
                    lstUserName.Text = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    QT_NGUOIDUNG_BL oBL = new QT_NGUOIDUNG_BL();
                    DataTable lstHT;
                    string strSessionKeyHT = "HETHONGGETBY_" + strUserID;
                    decimal USERID = Convert.ToDecimal(strUserID);
                    if (Session[strSessionKeyHT] == null)
                        lstHT = oBL.QT_HETHONG_GETBYUSER(USERID);
                    else
                        lstHT = (DataTable)Session[strSessionKeyHT];
                    liGSTP.Visible = liQLA.Visible = liTDKT.Visible = liTCCB.Visible = liQTHT.Visible = false;
                    if (lstHT.Rows.Count == 1) lbtBack.Visible = false;
                    if (lstHT.Rows.Count > 0)
                    {
                        foreach (DataRow r in lstHT.Rows)
                        {
                            switch (r["MA"] + "")
                            {
                                case "GSTP":
                                    liGSTP.Visible = true;
                                    break;
                                case "QLA":
                                    liQLA.Visible = true;
                                    break;
                                case "GDT":
                                    liGDT.Visible = true;
                                    break;
                                case "TDKT":
                                    liTDKT.Visible = true;
                                    break;
                                case "TCCB":
                                    liTCCB.Visible = true;
                                    break;
                                case "QTHT":
                                    liQTHT.Visible = true;
                                    break;
                            }
                        }
                    }
                    QT_HETHONG oHT = dt.QT_HETHONG.Where(x => x.ID == IDHethong).FirstOrDefault();
                    decimal DonViLoginID = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID].ToString());
                    string TenToaAn = "", Ma_Ten_ToaAn = "", CapToa = "";
                    DM_TOAAN otToaAN = dt.DM_TOAAN.Where(x => x.ID == DonViLoginID).FirstOrDefault();
                    if (otToaAN != null)
                    {
                        TenToaAn = otToaAN.TEN + "";
                        Ma_Ten_ToaAn = otToaAN.MA_TEN + "";
                        CapToa = otToaAN.LOAITOA + "";
                    }
                    lstHethong.Text = oHT.TEN.ToString().ToUpper() + "&nbsp;&nbsp; -&nbsp;&nbsp; " + Ma_Ten_ToaAn.ToUpper();
                    if (Session[ENUM_LOAIAN.AN_GSTP] + "" != "")
                    {
                        decimal ThamPhanID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_GSTP] + "");
                        DM_CANBO tp = dt.DM_CANBO.Where(x => x.ID == ThamPhanID).FirstOrDefault();
                        if (tp != null)
                        {
                            ltrTenTP.Text = tp.HOTEN;
                            DM_DATAITEM ChucDanh = dt.DM_DATAITEM.Where(x => x.ID == tp.CHUCDANHID).FirstOrDefault();
                            if (ChucDanh != null)
                            {
                                ltrChucDanh.Text = ChucDanh.TEN;
                            }
                            DM_TOAAN tpToaAn = dt.DM_TOAAN.Where(x => x.ID == tp.TOAANID).FirstOrDefault();
                            if (tpToaAn != null)
                            {
                                ltrToaAn.Text = TenToaAn.Replace("Tòa án nhân dân", "TAND");
                            }
                            ltrQuyetDinhBoNhiem.Text = tp.QDBONHIEM + "" == "" ? "" : "Số " + tp.QDBONHIEM + "," + tp.NGAYBONHIEM + "" == "" ? "" : "Ngày " + ((DateTime)tp.NGAYBONHIEM).ToString("dd/MM/yyyy");
                        }
                        else
                        {
                            ltrTenTP.Text = "Chưa có thẩm phán!";
                            ltrChucDanh.Text = ltrToaAn.Text = ltrQuyetDinhBoNhiem.Text = "";
                        }
                    }
                    else
                    {
                        ltrTenTP.Text = "Chưa có thẩm phán!";
                        ltrChucDanh.Text = ltrToaAn.Text = ltrQuyetDinhBoNhiem.Text = "";
                    }
                    LoadDropPhamVi();
                    LoadDropDonVi(DonViLoginID, TenToaAn, CapToa);
                    string MaMap = ddlDonVi.SelectedValue;
                    Resize_And_Load_DataForm(DonViLoginID, MaMap);
                    int V_PhamVi = 1;
                    if (Session["MAP_PHAMVI"] + "" == "")
                    {
                        V_PhamVi = Convert.ToInt32(ddlPhamvi.SelectedValue);
                    }
                    else
                    {
                        V_PhamVi = Convert.ToInt32(Session["MAP_PHAMVI"] + "");
                        ddlPhamvi.SelectedValue = Session["MAP_PHAMVI"] + "";
                    }
                    CreatMap(DonViLoginID, V_PhamVi);
                }
            }
            catch { }
        }
        private void LoadDropPhamVi()
        {
            ddlPhamvi.Items.Add(new ListItem("Trong năm", PHAMVI_TRONG_NAM.ToString()));
            ddlPhamvi.Items.Add(new ListItem("Trong tháng", PHAMVI_TRONG_THANG.ToString()));
            ddlPhamvi.Items.Add(new ListItem("Trong ngày", PHAMVI_TRONG_NGAY.ToString()));
        }
        private void LoadDropDonVi(decimal DonViID, string TenDonVi, string CapToa)
        {
            state_list.DataSource = null;
            state_list.DataBind();
            OracleParameter[] parameters = new OracleParameter[] {
                                                                    new OracleParameter("in_DONVIID",DonViID),
                                                                    new OracleParameter("in_CAPTOA",CapToa),
                                                                    new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_TOAAN_MAP_DONVI_CAPTOA", parameters);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                state_list.DataSource = tbl;
                state_list.DataTextField = "NAME";
                state_list.DataValueField = "MA";
                state_list.DataBind();
                if (CapToa == "CAPHUYEN")
                {
                    ddlDonVi.Items.Add(new ListItem(TenDonVi, DonViID.ToString()));
                }
                else
                {
                    ddlDonVi.DataSource = tbl;
                    ddlDonVi.DataTextField = "NAME";
                    ddlDonVi.DataValueField = "MA";
                    ddlDonVi.DataBind();
                }
            }
            if (CapToa == "TOICAO")
            {
                state_list.Items.Insert(0, new ListItem("--- Cả nước ---", "VNM000"));
                ddlDonVi.Items.Insert(0, new ListItem("--- Cả nước ---", "VNM000"));
            }
            state_list.SelectedIndex = 0;
            ddlDonVi.SelectedIndex = 0;
        }
        private void LoadThongKeSoTham(decimal DonViID, string CapToa, DateTime HienTai_TuNgay, DateTime Hientai_DenNgay)
        {
            string cache_name = "cache_GSTP_Home_ST_" + DonViID;
            DateTime Truoc_TuNgay = HienTai_TuNgay.AddYears(-1),
                     Truoc_DenNgay = Hientai_DenNgay.AddYears(-1);
            DataTable tbl = new DataTable();
            if (Cache[cache_name] == null)
            {
                tbl = Fill_Data_ToTable_SoTham(DonViID, CapToa, HienTai_TuNgay, Hientai_DenNgay);
                // Lưu cache
                Cache.Add(cache_name, tbl, null, DateTime.Now.AddMinutes(720), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
            }
            else
            {
                tbl = (DataTable)Cache[cache_name];
            }
            if (tbl != null && tbl.Rows.Count > 0)
            {
                // Năm hiện tại
                DataRow row = tbl.Rows[0];
                ltr_ST_TongThuLy_Nam_HienTai.Text = Convert.ToDecimal(row["V_TONGTHULY"] + "").ToString("#,0.##", cul);
                ltr_ST_GiaiQuyet_Nam_HienTai.Text = Convert.ToDecimal(row["V_GIAIQUYET"] + "").ToString("#,0.##", cul);
                ltr_ST_GiaiQuyet_Nam_HienTai_Percent.Text = Convert.ToDecimal(row["V_GIAIQUYET_TYLE"] + "").ToString("#,0.##", cul) + "%";
                ltr_ST_AnHuy_Sua_Nam_HienTai.Text = Convert.ToDecimal(row["V_ANHUY_SUA"] + "").ToString("#,0.##", cul);
                ltr_ST_AnHuy_Sua_Nam_HienTai_Percent.Text = Convert.ToDecimal(row["V_ANHUY_SUA_TYLE"] + "").ToString("#,0.##", cul) + "%";
                ltr_ST_Chua_GQ_Nam_Hientai.Text = Convert.ToDecimal(row["V_CHUA_GQ"] + "").ToString("#,0.##", cul);
                ltr_ST_Chua_GQ_Nam_Hientai_Percent.Text = Convert.ToDecimal(row["V_CHUA_GQ_TYLE"] + "").ToString("#,0.##", cul) + "%";
                ltr_ST_QuaHan_Nam_HienTai.Text = Convert.ToDecimal(row["V_QUAHAN"] + "").ToString("#,0.##", cul);
                ltr_ST_RutKN_Nam_HienTai.Text = Convert.ToDecimal(row["V_RUTKN"] + "").ToString("#,0.##", cul) + " / " + Convert.ToDecimal(row["V_RUTKN_THAMPHAN"] + "").ToString("#,0.##", cul);

                ltr_ST_HinhSu_TongThuLy.Text = Convert.ToDecimal(row["V_HINHSU_TONGTHULY"] + "").ToString("#,0.##", cul);
                ltr_ST_HinhSu_TongGiaiQuyet.Text = Convert.ToDecimal(row["V_HINHSU_TONGGIAIQUYET"] + "").ToString("#,0.##", cul);

                ltr_ST_DanSu_TongThuLy.Text = Convert.ToDecimal(row["V_DANSU_TONGTHULY"] + "").ToString("#,0.##", cul);
                ltr_ST_DanSu_TongGiaiQuyet.Text = Convert.ToDecimal(row["V_DANSU_TONGGIAIQUYET"] + "").ToString("#,0.##", cul);

                ltr_ST_HNGD_TongThuLy.Text = Convert.ToDecimal(row["V_HNGD_TONGTHULY"] + "").ToString("#,0.##", cul);
                ltr_ST_HNGD_TongGiaiQuyet.Text = Convert.ToDecimal(row["V_HNGD_TONGGIAIQUYET"] + "").ToString("#,0.##", cul);

                ltr_ST_KDTM_TongThuLy.Text = Convert.ToDecimal(row["V_KDTM_TONGTHULY"] + "").ToString("#,0.##", cul);
                ltr_ST_KDTM_TongGiaiQuyet.Text = Convert.ToDecimal(row["V_KDTM_TONGGIAIQUYET"] + "").ToString("#,0.##", cul);

                ltr_ST_HanhChinh_TongThuLy.Text = Convert.ToDecimal(row["V_HANHCHINH_TONGTHULY"] + "").ToString("#,0.##", cul);
                ltr_ST_HanhChinh_TongGiaiQuyet.Text = Convert.ToDecimal(row["V_HANHCHINH_TONGGIAIQUYET"] + "").ToString("#,0.##", cul);

                ltr_ST_LaoDong_TongThuLy.Text = Convert.ToDecimal(row["V_LAODONG_TONGTHULY"] + "").ToString("#,0.##", cul);
                ltr_ST_LaoDong_TongGiaiQuyet.Text = Convert.ToDecimal(row["V_LAODONG_TONGGIAIQUYET"] + "").ToString("#,0.##", cul);
                // Năm trước
                row = tbl.Rows[1];
                ltr_ST_TongThuLy_Nam_Truoc.Text = Convert.ToDecimal(row["V_TONGTHULY"] + "").ToString("#,0.##", cul);
                ltr_ST_GiaiQuyet_Nam_Truoc.Text = Convert.ToDecimal(row["V_GIAIQUYET"] + "").ToString("#,0.##", cul);
                ltr_ST_GiaiQuyet_Nam_Truoc_Percent.Text = Convert.ToDecimal(row["V_GIAIQUYET_TYLE"] + "").ToString("#,0.##", cul) + "%";
                ltr_ST_AnHuy_Sua_Nam_Truoc.Text = Convert.ToDecimal(row["V_ANHUY_SUA"] + "").ToString("#,0.##", cul);
                ltr_ST_AnHuy_Sua_Nam_Truoc_Percent.Text = Convert.ToDecimal(row["V_ANHUY_SUA_TYLE"] + "").ToString("#,0.##", cul) + "%";
                ltr_ST_Chua_GQ_Nam_Truoc.Text = Convert.ToDecimal(row["V_CHUA_GQ"] + "").ToString("#,0.##", cul);
                ltr_ST_Chua_GQ_Nam_Truoc_Percent.Text = Convert.ToDecimal(row["V_CHUA_GQ_TYLE"] + "").ToString("#,0.##", cul) + "%";
                ltr_ST_QuaHan_Nam_Truoc.Text = Convert.ToDecimal(row["V_QUAHAN"] + "").ToString("#,0.##", cul);
                ltr_ST_RutKN_Nam_Truoc.Text = Convert.ToDecimal(row["V_RUTKN"] + "").ToString("#,0.##", cul) + " / " + Convert.ToDecimal(row["V_RUTKN_THAMPHAN"] + "").ToString("#,0.##", cul);
            }
        }
        private void LoadThongKeSoTham_DKKTT(decimal DonViID, string CapToa, DateTime HienTai_TuNgay, DateTime Hientai_DenNgay)
        {
            string cache_name = "cache_GSTP_Home_ST_" + DonViID;
            DateTime Truoc_TuNgay = HienTai_TuNgay.AddYears(-1),
                     Truoc_DenNgay = Hientai_DenNgay.AddYears(-1);
            DataTable tbl = new DataTable();
            if (Cache[cache_name] == null)
            {
                tbl = Fill_Data_ToTable_SoTham_DKKTT(DonViID, CapToa, HienTai_TuNgay, Hientai_DenNgay);
                // Lưu cache
                Cache.Add(cache_name, tbl, null, DateTime.Now.AddMinutes(720), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
            }
            else
            {
                tbl = (DataTable)Cache[cache_name];
            }
            if (tbl != null && tbl.Rows.Count > 0)
            {
                // Năm hiện tại
                DataRow row = tbl.Rows[0];
                ltr_ST_Don_DaNhan_Nam_HienTai.Text = Convert.ToDecimal(row["V_TONGTHULY"] + "").ToString("#,0.##", cul);
               
            }
        }

        
        private void LoadThongKePhucTham(decimal DonViID, string CapToa, DateTime HienTai_TuNgay, DateTime Hientai_DenNgay)
        {
            string cache_name = "cache_GSTP_Home_PT_" + DonViID;
            DataTable tbl = new DataTable();
            if (Cache[cache_name] == null)
            {
                tbl = Fill_Data_ToTable_PhucTham(DonViID, CapToa, HienTai_TuNgay, Hientai_DenNgay);
                // Lưu cache
                Cache.Add(cache_name, tbl, null, DateTime.Now.AddMinutes(720), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
            }
            else
            {
                tbl = (DataTable)Cache[cache_name];
            }
            if (tbl != null && tbl.Rows.Count > 0)
            {
                // Năm hiện tại
                DataRow row = tbl.Rows[0];
                ltr_PT_TongThuLy_Nam_HienTai.Text = Convert.ToDecimal(row["V_TONGTHULY"] + "").ToString("#,0.##", cul);
                ltr_PT_GiaiQuyet_Nam_HienTai.Text = Convert.ToDecimal(row["V_GIAIQUYET"] + "").ToString("#,0.##", cul);
                ltr_PT_GiaiQuyet_Nam_HienTai_Percent.Text = Convert.ToDecimal(row["V_GIAIQUYET_TYLE"] + "").ToString("#,0.##", cul) + "%";
                ltr_PT_AnHuy_Sua_Nam_HienTai.Text = Convert.ToDecimal(row["V_ANHUY_SUA"] + "").ToString("#,0.##", cul);
                ltr_PT_AnHuy_Sua_Nam_HienTai_Percent.Text = Convert.ToDecimal(row["V_ANHUY_SUA_TYLE"] + "").ToString("#,0.##", cul) + "%";
                ltr_PT_Chua_GQ_Nam_Hientai.Text = Convert.ToDecimal(row["V_CHUA_GQ"] + "").ToString("#,0.##", cul);
                ltr_PT_Chua_GQ_Nam_Hientai_Percent.Text = Convert.ToDecimal(row["V_CHUA_GQ_TYLE"] + "").ToString("#,0.##", cul) + "%";
                ltr_PT_QuaHan_Nam_HienTai.Text = Convert.ToDecimal(row["V_QUAHAN"] + "").ToString("#,0.##", cul);
                ltr_PT_RutKN_Nam_HienTai.Text = Convert.ToDecimal(row["V_RUTKN"] + "").ToString("#,0.##", cul) + " / " + Convert.ToDecimal(row["V_RUTKN_THAMPHAN"] + "").ToString("#,0.##", cul);

                ltr_PT_HinhSu_TongThuLy.Text = Convert.ToDecimal(row["V_HINHSU_TONGTHULY"] + "").ToString("#,0.##", cul);
                ltr_PT_HinhSu_TongGiaiQuyet.Text = Convert.ToDecimal(row["V_HINHSU_TONGGIAIQUYET"] + "").ToString("#,0.##", cul);

                ltr_PT_DanSu_TongThuLy.Text = Convert.ToDecimal(row["V_DANSU_TONGTHULY"] + "").ToString("#,0.##", cul);
                ltr_PT_DanSu_TongGiaiQuyet.Text = Convert.ToDecimal(row["V_DANSU_TONGGIAIQUYET"] + "").ToString("#,0.##", cul);

                ltr_PT_HNGD_TongThuLy.Text = Convert.ToDecimal(row["V_HNGD_TONGTHULY"] + "").ToString("#,0.##", cul);
                ltr_PT_HNGD_TongGiaiQuyet.Text = Convert.ToDecimal(row["V_HNGD_TONGGIAIQUYET"] + "").ToString("#,0.##", cul);

                ltr_PT_KDTM_TongThuLy.Text = Convert.ToDecimal(row["V_KDTM_TONGTHULY"] + "").ToString("#,0.##", cul);
                ltr_PT_KDTM_TongGiaiQuyet.Text = Convert.ToDecimal(row["V_KDTM_TONGGIAIQUYET"] + "").ToString("#,0.##", cul);

                ltr_PT_HanhChinh_TongThuLy.Text = Convert.ToDecimal(row["V_HANHCHINH_TONGTHULY"] + "").ToString("#,0.##", cul);
                ltr_PT_HanhChinh_TongGiaiQuyet.Text = Convert.ToDecimal(row["V_HANHCHINH_TONGGIAIQUYET"] + "").ToString("#,0.##", cul);

                ltr_PT_LaoDong_TongThuLy.Text = Convert.ToDecimal(row["V_LAODONG_TONGTHULY"] + "").ToString("#,0.##", cul);
                ltr_PT_LaoDong_TongGiaiQuyet.Text = Convert.ToDecimal(row["V_LAODONG_TONGGIAIQUYET"] + "").ToString("#,0.##", cul);
                // Năm trước
                row = tbl.Rows[1];
                ltr_PT_TongThuLy_Nam_Truoc.Text = Convert.ToDecimal(row["V_TONGTHULY"] + "").ToString("#,0.##", cul);
                ltr_PT_GiaiQuyet_Nam_Truoc.Text = Convert.ToDecimal(row["V_GIAIQUYET"] + "").ToString("#,0.##", cul);
                ltr_PT_GiaiQuyet_Nam_Truoc_Percent.Text = Convert.ToDecimal(row["V_GIAIQUYET_TYLE"] + "").ToString("#,0.##", cul) + "%";
                ltr_PT_AnHuy_Sua_Nam_Truoc.Text = Convert.ToDecimal(row["V_ANHUY_SUA"] + "").ToString("#,0.##", cul);
                ltr_PT_AnHuy_Sua_Nam_Truoc_Percent.Text = Convert.ToDecimal(row["V_ANHUY_SUA_TYLE"] + "").ToString("#,0.##", cul) + "%";
                ltr_PT_Chua_GQ_Nam_Truoc.Text = Convert.ToDecimal(row["V_CHUA_GQ"] + "").ToString("#,0.##", cul);
                ltr_PT_Chua_GQ_Nam_Truoc_Percent.Text = Convert.ToDecimal(row["V_CHUA_GQ_TYLE"] + "").ToString("#,0.##", cul) + "%";
                ltr_PT_QuaHan_Nam_Truoc.Text = Convert.ToDecimal(row["V_QUAHAN"] + "").ToString("#,0.##", cul);
                ltr_PT_RutKN_Nam_Truoc.Text = Convert.ToDecimal(row["V_RUTKN"] + "").ToString("#,0.##", cul) + " / " + Convert.ToDecimal(row["V_RUTKN_THAMPHAN"] + "").ToString("#,0.##", cul);
            }
        }
        private void LoadThongKeGDT(decimal DonViID, DateTime HienTai_TuNgay, DateTime Hientai_DenNgay)
        {
            string cache_name = "cache_GSTP_Home_GDTTT_" + DonViID;
            DataTable tbl = new DataTable();
            if (Cache[cache_name] == null)
            {
                tbl = Fill_Data_ToTable_GDT(DonViID, HienTai_TuNgay, Hientai_DenNgay);
                Cache.Add(cache_name, tbl, null, DateTime.Now.AddMinutes(720), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
            }
            else
            {
                tbl = (DataTable)Cache[cache_name];

            }
            if (tbl != null && tbl.Rows.Count > 0)
            {
                // Kỳ hiện tại
                DataRow row = tbl.Rows[0];
                decimal DonVuAn_TongVuAn_KyBC = Convert.ToDecimal(row["DonVuAn_TongVuAn_KyBC"] + "");
                ltr_Don_VuAn_DonDeNghi_Nam_HienTai.Text = DonVuAn_TongVuAn_KyBC.ToString("#,0.##", cul);
                ltr_Don_VuAn_8_1_Nam_HienTai.Text = Convert.ToDecimal(row["DonVuAn_TongAnQH_KyBC"] + "").ToString("#,0.##", cul);
                ltr_Don_VuAn_ThoiHieu_Nam_HienTai.Text = Convert.ToDecimal(row["DonVuAn_HetThoiHieu_KyBC"] + "").ToString("#,0.##", cul);
                decimal DonVuAn_DaGQ_KyBC = Convert.ToDecimal(row["DonVuAn_DaGQ_KyBC"] + "");
                ltr_Don_VuAn_GiaiQuyetXong_Nam_HienTai.Text = DonVuAn_DaGQ_KyBC.ToString("#,0.##", cul);
                if (DonVuAn_TongVuAn_KyBC == 0)
                {
                    ltr_Don_VuAn_GiaiQuyetXong_Nam_HienTai_Percent.Text = "0%";
                }
                else
                {
                    ltr_Don_VuAn_GiaiQuyetXong_Nam_HienTai_Percent.Text = Math.Round((DonVuAn_DaGQ_KyBC / DonVuAn_TongVuAn_KyBC * 100), MidpointRounding.AwayFromZero).ToString("#,0.##", cul) + "%";
                }
                decimal DonVuAn_ChuaGQ_KyBC = Convert.ToDecimal(row["DonVuAn_ChuaGQ_KyBC"] + "");
                ltr_Don_VuAn_ChuaXong_Nam_HienTai.Text = DonVuAn_ChuaGQ_KyBC.ToString("#,0.##", cul);
                if (DonVuAn_TongVuAn_KyBC == 0)
                {
                    ltr_Don_VuAn_ChuaXong_Nam_HienTai_Percent.Text = "0%";
                }
                else
                {
                    ltr_Don_VuAn_ChuaXong_Nam_HienTai_Percent.Text = Math.Round((DonVuAn_ChuaGQ_KyBC / DonVuAn_TongVuAn_KyBC * 100), MidpointRounding.AwayFromZero).ToString("#,0.##", cul) + "%";
                }
                ltr_Don_Tong_DonDeNghi_Nam_HienTai.Text = Convert.ToDecimal(row["DonGDT_TongDon_KyBC"] + "").ToString("#,0.##", cul);
                ltr_Don_Chuyen_Vu1_Nam_HienTai.Text = Convert.ToDecimal(row["DonGDT_ChuyenVu1_KyBC"] + "").ToString("#,0.##", cul);
                ltr_Don_Chuyen_Vu2_Nam_HienTai.Text = Convert.ToDecimal(row["DonGDT_ChuyenVu2_KyBC"] + "").ToString("#,0.##", cul);
                ltr_Don_Chuyen_Vu3_Nam_HienTai.Text = Convert.ToDecimal(row["DonGDT_ChuyenVu3_KyBC"] + "").ToString("#,0.##", cul);
                ltr_Don_Chuyen_Khac_Nam_HienTai.Text = Convert.ToDecimal(row["DonGDT_ChuyenCQKhac_KyBC"] + "").ToString("#,0.##", cul);
                decimal XX_TongSo_KyBC = Convert.ToDecimal(row["XX_TongSo_KyBC"] + "");
                ltr_XetXu_TongThuLy_Nam_Hientai.Text = XX_TongSo_KyBC.ToString("#,0.##", cul);
                decimal XX_DaGQ_KyBC = Convert.ToDecimal(row["XX_DaGQ_KyBC"] + "");
                ltr_XetXu_GiaiQuyetXong_Nam_HienTai.Text = XX_DaGQ_KyBC.ToString("#,0.##", cul);
                if (XX_TongSo_KyBC == 0)
                {
                    ltr_XetXu_GiaiQuyetXong_Nam_HienTai_Percent.Text = "0%";
                }
                else
                {
                    ltr_XetXu_GiaiQuyetXong_Nam_HienTai_Percent.Text = Math.Round((XX_DaGQ_KyBC / XX_TongSo_KyBC * 100), MidpointRounding.AwayFromZero).ToString("#,0.##", cul) + "%";
                }
                decimal XX_ChuaGQ_KyBC = Convert.ToDecimal(row["XX_ChuaGQ_KyBC"] + "");
                ltr_XetXu_ChuaXong_Nam_HienTai.Text = XX_ChuaGQ_KyBC.ToString("#,0.##", cul);
                if (XX_TongSo_KyBC == 0)
                {
                    ltr_XetXu_ChuaXong_Nam_HienTai_Percent.Text = "0%";
                }
                else
                {
                    ltr_XetXu_ChuaXong_Nam_HienTai_Percent.Text = Math.Round((XX_ChuaGQ_KyBC / XX_TongSo_KyBC * 100), MidpointRounding.AwayFromZero).ToString("#,0.##", cul) + "%";
                }
                decimal XX_AnQuaHan_KyBC = Convert.ToDecimal(row["XX_AnQuaHan_KyBC"] + "");
                ltr_XetXu_QuaHan_Nam_HienTai.Text = XX_AnQuaHan_KyBC.ToString("#,0.##", cul);
                if (XX_TongSo_KyBC == 0)
                {
                    ltr_XetXu_QuaHan_Nam_HienTai_Percent.Text = "0%";
                }
                else
                {
                    ltr_XetXu_QuaHan_Nam_HienTai_Percent.Text = Math.Round((XX_AnQuaHan_KyBC / XX_TongSo_KyBC * 100), MidpointRounding.AwayFromZero).ToString("#,0.##", cul) + "%";
                }
                ltr_XetXu_HinhSu_TongThuLy.Text = Convert.ToDecimal(row["XX_HS_ThuLy"] + "").ToString("#,0.##", cul);
                ltr_XetXu_HinhSu_TongGiaiQuyet.Text = Convert.ToDecimal(row["XX_HS_ThuLy"] + "").ToString("#,0.##", cul);
                ltr_XetXu_DanSu_TongThuLy.Text = Convert.ToDecimal(row["XX_DS_ThuLy"] + "").ToString("#,0.##", cul);
                ltr_XetXu_DanSu_TongGiaiQuyet.Text = Convert.ToDecimal(row["XX_DS_ThuLy"] + "").ToString("#,0.##", cul);
                ltr_XetXu_HNGD_TongThuLy.Text = Convert.ToDecimal(row["XX_HNGD_ThuLy"] + "").ToString("#,0.##", cul);
                ltr_XetXu_HNGD_TongGiaiQuyet.Text = Convert.ToDecimal(row["XX_HNGD_ThuLy"] + "").ToString("#,0.##", cul);
                ltr_XetXu_KDTM_TongThuLy.Text = Convert.ToDecimal(row["XX_KDTM_ThuLy"] + "").ToString("#,0.##", cul);
                ltr_XetXu_KDTM_TongGiaiQuyet.Text = Convert.ToDecimal(row["XX_KDTM_ThuLy"] + "").ToString("#,0.##", cul);
                ltr_XetXu_HanhChinh_TongThuLy.Text = Convert.ToDecimal(row["XX_HC_ThuLy"] + "").ToString("#,0.##", cul);
                ltr_XetXu_HanhChinh_TongGiaiQuyet.Text = Convert.ToDecimal(row["XX_HC_ThuLy"] + "").ToString("#,0.##", cul);
                ltr_XetXu_LaoDong_TongThuLy.Text = Convert.ToDecimal(row["XX_LD_ThuLy"] + "").ToString("#,0.##", cul);
                ltr_XetXu_LaoDong_TongGiaiQuyet.Text = Convert.ToDecimal(row["XX_LD_ThuLy"] + "").ToString("#,0.##", cul);
                // Kỳ trước
                row = tbl.Rows[1];
                decimal DonVuAn_TongVuAn_KyTruoc = Convert.ToDecimal(row["DonVuAn_TongVuAn_KyBC"] + "");
                ltr_Don_VuAn_DonDeNghi_Nam_Truoc.Text = DonVuAn_TongVuAn_KyTruoc.ToString("#,0.##", cul);
                ltr_Don_VuAn_8_1_Nam_Truoc.Text = Convert.ToDecimal(row["DonVuAn_TongAnQH_KyBC"] + "").ToString("#,0.##", cul);
                ltr_Don_VuAn_ThoiHieu_Nam_Truoc.Text = Convert.ToDecimal(row["DonVuAn_HetThoiHieu_KyBC"] + "").ToString("#,0.##", cul);
                decimal DonVuAn_DaGQ_KyTruoc = Convert.ToDecimal(row["DonVuAn_DaGQ_KyBC"] + "");
                ltr_Don_VuAn_GiaiQuyetXong_Nam_Truoc.Text = DonVuAn_DaGQ_KyTruoc.ToString("#,0.##", cul);
                if (DonVuAn_TongVuAn_KyTruoc == 0)
                {
                    ltr_Don_VuAn_GiaiQuyetXong_Nam_Truoc_Percent.Text = "0%";
                }
                else
                {
                    ltr_Don_VuAn_GiaiQuyetXong_Nam_Truoc_Percent.Text = Math.Round((DonVuAn_DaGQ_KyTruoc / DonVuAn_TongVuAn_KyTruoc * 100), MidpointRounding.AwayFromZero).ToString("#,0.##", cul) + "%";
                }
                decimal DonVuAn_ChuaGQ_KyTruoc = Convert.ToDecimal(row["DonVuAn_ChuaGQ_KyBC"] + "");
                ltr_Don_VuAn_ChuaXong_Nam_Truoc.Text = DonVuAn_ChuaGQ_KyTruoc.ToString("#,0.##", cul);
                if (DonVuAn_TongVuAn_KyTruoc == 0)
                {
                    ltr_Don_VuAn_ChuaXong_Nam_Truoc_Percent.Text = "0%";
                }
                else
                {
                    ltr_Don_VuAn_ChuaXong_Nam_Truoc_Percent.Text = Math.Round((DonVuAn_ChuaGQ_KyTruoc / DonVuAn_TongVuAn_KyTruoc * 100), MidpointRounding.AwayFromZero).ToString("#,0.##", cul) + "%";
                }
                ltr_Don_Tong_DonDeNghi_Nam_Truoc.Text = Convert.ToDecimal(row["DonGDT_TongDon_KyBC"] + "").ToString("#,0.##", cul);
                ltr_Don_Chuyen_Vu1_Nam_Truoc.Text = Convert.ToDecimal(row["DonGDT_ChuyenVu1_KyBC"] + "").ToString("#,0.##", cul);
                ltr_Don_Chuyen_Vu2_Nam_Truoc.Text = Convert.ToDecimal(row["DonGDT_ChuyenVu2_KyBC"] + "").ToString("#,0.##", cul);
                ltr_Don_Chuyen_Vu3_Nam_Truoc.Text = Convert.ToDecimal(row["DonGDT_ChuyenVu3_KyBC"] + "").ToString("#,0.##", cul);
                ltr_Don_Chuyen_Khac_Nam_Truoc.Text = Convert.ToDecimal(row["DonGDT_ChuyenCQKhac_KyBC"] + "").ToString("#,0.##", cul);
                decimal XX_TongSo_KyTruoc = Convert.ToDecimal(row["XX_TongSo_KyBC"] + "");
                ltr_XetXu_TongThuLy_Nam_Truoc.Text = XX_TongSo_KyTruoc.ToString("#,0.##", cul);
                decimal XX_DaGQ_KyTruoc = Convert.ToDecimal(row["XX_DaGQ_KyBC"] + "");
                ltr_XetXu_GiaiQuyetXong_Nam_Truoc.Text = XX_DaGQ_KyTruoc.ToString("#,0.##", cul);
                if (XX_TongSo_KyTruoc == 0)
                {
                    ltr_XetXu_GiaiQuyetXong_Nam_Truoc_Percent.Text = "0%";
                }
                else
                {
                    ltr_XetXu_GiaiQuyetXong_Nam_Truoc_Percent.Text = Math.Round((XX_DaGQ_KyTruoc / XX_TongSo_KyTruoc * 100), MidpointRounding.AwayFromZero).ToString("#,0.##", cul) + "%";
                }
                decimal XX_ChuaGQ_KyTruoc = Convert.ToDecimal(row["XX_ChuaGQ_KyBC"] + "");
                ltr_XetXu_ChuaXong_Nam_Truoc.Text = XX_ChuaGQ_KyTruoc.ToString("#,0.##", cul);
                if (XX_TongSo_KyTruoc == 0)
                {
                    ltr_XetXu_ChuaXong_Nam_Truoc_Percent.Text = "0%";
                }
                else
                {
                    ltr_XetXu_ChuaXong_Nam_Truoc_Percent.Text = Math.Round((XX_ChuaGQ_KyTruoc / XX_TongSo_KyTruoc * 100), MidpointRounding.AwayFromZero).ToString("#,0.##", cul) + "%";
                }
                decimal XX_AnQuaHan_KyTruoc = Convert.ToDecimal(row["XX_AnQuaHan_KyBC"] + "");
                ltr_XetXu_QuaHan_Nam_Truoc.Text = XX_AnQuaHan_KyTruoc.ToString("#,0.##", cul);
                if (XX_TongSo_KyTruoc == 0)
                {
                    ltr_XetXu_QuaHan_Nam_Truoc_Percent.Text = "0%";
                }
                else
                {
                    ltr_XetXu_QuaHan_Nam_Truoc_Percent.Text = Math.Round((XX_AnQuaHan_KyTruoc / XX_TongSo_KyTruoc * 100), MidpointRounding.AwayFromZero).ToString("#,0.##", cul) + "%";
                }

            }
        }
        private void LoadThongKeThamPhan(decimal DonViID, string CapToa)
        {
            string cache_name = "cache_GSTP_Home_THAMPHAN_" + DonViID;
            DataTable tbl = new DataTable();
            if (Cache[cache_name] == null)
            {
                DateTime NamHientai_DauKy = DateTime.Parse("01/12/" + (DateTime.Now.Year - 1), cul),
                         NamHientai_CuoiKy = DateTime.Parse("30/11/" + DateTime.Now.Year, cul);

                tbl = Fill_Data_ToTable_ThamPhan(DonViID, CapToa, NamHientai_DauKy, NamHientai_CuoiKy);
                // Lưu cache
                Cache.Add(cache_name, tbl, null, DateTime.Now.AddMinutes(720), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
            }
            else
            {
                tbl = (DataTable)Cache[cache_name];

            }
            if (tbl != null && tbl.Rows.Count > 0)
            {
                // Năm hiện tại
                DataRow row = tbl.Rows[0];
                ltr_TP_DangCongTac_Nam_HienTai.Text = Convert.ToDecimal(row["V_TP_DANGCONGTAC"] + "").ToString("#,0.##", cul);
                ltr_TP_NhiemKy_Nam_HienTai.Text = Convert.ToDecimal(row["V_TP_NHIEMKY"] + "").ToString("#,0.##", cul);
                ltr_TP_DungXetXu_Nam_HienTai.Text = Convert.ToDecimal(row["V_TP_DUNG_XETXU"] + "").ToString("#,0.##", cul);
                ltr_TP_DungXetXu_Nam_HienTai_Percent.Text = Convert.ToDecimal(row["V_TP_DUNG_XETXU_TYLE"] + "").ToString("#,0.##", cul) + "%";
                ltr_TP_KhieuNai_Nam_HienTai.Text = Convert.ToDecimal(row["V_TP_KHIEUNAI_TOCAO"] + "").ToString("#,0.##", cul);
                ltr_TP_KhieuNai_Nam_HienTai_Percent.Text = Convert.ToDecimal(row["V_TP_KHIEUNAI_TOCAO_TYLE"] + "").ToString("#,0.##", cul) + "%";
                ltr_TP_AnHuy_Sua_Nam_HienTai.Text = Convert.ToDecimal(row["V_TP_SUAHUY"] + "").ToString("#,0.##", cul);
                ltr_TP_AnHuy_Sua_Nam_HienTai_Percent.Text = Convert.ToDecimal(row["V_TP_SUAHUY_TYLE"] + "").ToString("#,0.##", cul) + "%";
                ltr_TP_AnHuy_Sua_QD120.Text = Convert.ToDecimal(row["V_TP_SUAHUY_QD120"] + "").ToString("#,0.##", cul);
                // Năm trước
                row = tbl.Rows[1];
                ltr_TP_DangCongTac_Nam_Truoc.Text = Convert.ToDecimal(row["V_TP_DANGCONGTAC"] + "").ToString("#,0.##", cul);
                ltr_TP_NhiemKy_Nam_Truoc.Text = Convert.ToDecimal(row["V_TP_NHIEMKY"] + "").ToString("#,0.##", cul);
                ltr_TP_DungXetXu_Nam_Truoc.Text = Convert.ToDecimal(row["V_TP_DUNG_XETXU"] + "").ToString("#,0.##", cul);
                ltr_TP_DungXetXu_Nam_Truoc_Percent.Text = Convert.ToDecimal(row["V_TP_DUNG_XETXU_TYLE"] + "").ToString("#,0.##", cul) + "%";
                ltr_TP_KhieuNai_Nam_Truoc.Text = Convert.ToDecimal(row["V_TP_KHIEUNAI_TOCAO"] + "").ToString("#,0.##", cul);
                ltr_TP_KhieuNai_Nam_Truoc_Percent.Text = Convert.ToDecimal(row["V_TP_KHIEUNAI_TOCAO_TYLE"] + "").ToString("#,0.##", cul) + "%";
                ltr_TP_AnHuy_Sua_Nam_Truoc.Text = Convert.ToDecimal(row["V_TP_SUAHUY"] + "").ToString("#,0.##", cul);
                ltr_TP_AnHuy_Sua_Nam_Truoc_Percent.Text = Convert.ToDecimal(row["V_TP_SUAHUY_TYLE"] + "").ToString("#,0.##", cul) + "%";
            }
        }
        private void LoadCongBoBAQD(decimal DonViID, string CapToa)
        {
            string cache_name = "cache_GSTP_Home_CongBoBAQD_" + DonViID;
            DataTable tbl = new DataTable();
            if (Cache[cache_name] == null)
            {
                tbl = bl.GSTP_HOME_CongBoBAQD(DonViID, CapToa);
                Cache.Add(cache_name, tbl, null, DateTime.Now.AddMinutes(720), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
            }
            else
            {
                tbl = (DataTable)Cache[cache_name];

            }
            if (tbl != null && tbl.Rows.Count > 0)
            {
                DataRow row = tbl.Rows[0];
                ltrBA_DaXetXu_NamHienTai.Text = Convert.ToDecimal(row["V_DAXETXU_NAMHIENTAI"] + "").ToString("#,0.##", cul);
                ltrBA_DaXetXu_NamTruoc.Text = Convert.ToDecimal(row["V_DAXETXU_NAMTRUOC"] + "").ToString("#,0.##", cul);
                ltrBA_KCKN_NamHienTai.Text = Convert.ToDecimal(row["V_KCKN_NAMHIENTAI"] + "").ToString("#,0.##", cul);
                ltrBA_KCKN_NamTruoc.Text = Convert.ToDecimal(row["V_KCKN_NAMTRUOC"] + "").ToString("#,0.##", cul);
            }
            string strDonViID = DonViID.ToString();
            try
            {
                Load_Tong_CongBBA(strDonViID);
            }
            catch { }
        }
        protected void Load_Tong_CongBBA(String DonViID)
        {
            string cache_name = "cache_GSTP_Home_CongBoBA_" + DonViID;
            GSTP_APP_BL oBL = new GSTP_APP_BL();
            DataTable tbl = new DataTable();
            if (Cache[cache_name] == null)
            {
                tbl = oBL.Get_Tong_CongBBA(DonViID, null);
                Cache.Add(cache_name, tbl, null, DateTime.Now.AddMinutes(720), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
            }
            else
            {
                tbl = (DataTable)Cache[cache_name];

            }
            if (tbl != null && tbl.Rows.Count > 0)
            {
                DataRow row = tbl.NewRow();
                row = tbl.Rows[0];
                lbl_COLUMN_1.Text = row["COLUMN_1"] + "";
                lbl_COLUMN_2.Text = row["COLUMN_2"] + "";
                lbl_COLUMN_3.Text = row["COLUMN_3"] + "";
                lbl_COLUMN_4.Text = row["COLUMN_4"] + "";
                lbl_COLUMN_5.Text = row["COLUMN_5"] + "";
                lbl_COLUMN_6.Text = row["COLUMN_6"] + "";
                lbl_COLUMN_7.Text = row["COLUMN_7"] + "";
                lbl_COLUMN_8.Text = row["COLUMN_8"] + "";
                lbl_COLUMN_9.Text = row["COLUMN_9"] + "";
                lbl_COLUMN_10.Text = row["COLUMN_10"] + "";
                lbl_COLUMN_11.Text = row["COLUMN_11"] + "";
                lbl_COLUMN_12.Text = row["COLUMN_12"] + "";
            }
        }
        protected void lbtBack_Click(object sender, EventArgs e)
        {
            Response.Redirect(Cls_Comon.GetRootURL() + "/Launcher.aspx");
        }
        protected void btnGSTP_Click(object sender, EventArgs e)
        {
            QT_HETHONG oT = dt.QT_HETHONG.Where(x => x.MA == "GSTP").FirstOrDefault();
            Session["MaHeThong"] = oT.ID;
            Session["MaChuongTrinh"] = null;
            Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
        }
        protected void btnQLA_Click(object sender, EventArgs e)
        {
            QT_HETHONG oT = dt.QT_HETHONG.Where(x => x.MA == "QLA").FirstOrDefault();
            Session["MaHeThong"] = oT.ID;
            Session["MaChuongTrinh"] = null;
            Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
        }
        protected void btnGDT_Click(object sender, EventArgs e)
        {
            QT_HETHONG oT = dt.QT_HETHONG.Where(x => x.MA == "GDT").FirstOrDefault();
            Session["MaHeThong"] = oT.ID;
            Session["MaChuongTrinh"] = null;
            Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
        }
        protected void btnTDKT_Click(object sender, EventArgs e)
        {
            QT_HETHONG oT = dt.QT_HETHONG.Where(x => x.MA == "TDKT").FirstOrDefault();
            Session["MaHeThong"] = oT.ID;
            Session["MaChuongTrinh"] = null;
            Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
        }
        protected void btnTCCB_Click(object sender, EventArgs e)
        {
            QT_HETHONG oT = dt.QT_HETHONG.Where(x => x.MA == "TCCB").FirstOrDefault();
            Session["MaHeThong"] = oT.ID;
            Session["MaChuongTrinh"] = null;
            Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
        }
        protected void btnQTHT_Click(object sender, EventArgs e)
        {
            QT_HETHONG oT = dt.QT_HETHONG.Where(x => x.MA == "QTHT").FirstOrDefault();
            Session["MaHeThong"] = oT.ID;
            Session["MaChuongTrinh"] = null;
            Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
        }
        protected void lkSignout_Click(object sender, EventArgs e)
        {
            int so = int.Parse(Application.Get("OnlineNow").ToString());
            if (so > 0) so--;
            else
                so = 0;
            Application.Set("OnlineNow", so);
            // Xóa file js khi hết phiên Logout
            string strFileName_js = "mapdata_" + Session[ENUM_SESSION.SESSION_DONVIID] + ".js";
            string path_js = Server.MapPath("~/GSTP/") + strFileName_js;
            FileInfo oF_js = new FileInfo(path_js);
            if (oF_js.Exists)// Nếu file đã tồn tại
            {
                File.Delete(path_js);
            }
            //
            Session.Clear();
            Response.Redirect(Cls_Comon.GetRootURL() + "/Login.aspx");
        }
        protected void cmd_MenuLeft_DanhGiaThamPhan_Click(object sender, EventArgs e)
        {
            Session["MaChuongTrinh"] = "GSTP";
            Response.Redirect(Cls_Comon.GetRootURL() + "/GSTP/Thongtintonghop.aspx");
        }
        protected void cmd_MenuLeft_ThongKe_Click(object sender, EventArgs e)
        {
            Session["MaChuongTrinh"] = "GSTP_BCTK";
            Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
        }
        protected void cmd_MenuLeft_HDSD_Click(object sender, EventArgs e)
        {
            //Session["MaChuongTrinh"] = "GSTP_HDSD";
            //Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
            Session["MaChuongTrinh"] = "HDSD_APP";
            Response.Redirect(Cls_Comon.GetRootURL() + "/HDSD/HDSD.aspx");
        }
        protected void ddlPhamvi_SelectedIndexChanged(object sender, EventArgs e)
        {
            int V_PhamVi = Convert.ToInt32(ddlPhamvi.SelectedValue);
            Session["MAP_PHAMVI"] = ddlPhamvi.SelectedValue;
            Response.Redirect(Cls_Comon.GetRootURL() + "/GSTP/Danhsachtonghop.aspx");
        }
        private string CreateMapDataJS(decimal DonViLogin, int PhamVi)
        {
            string result = "", cache_name_map = "cache_GSTP_Home_MAP_" + PhamVi + "_" + DonViLogin;
            DateTime HienTai_TuNgay = DateTime.Now,
                     HienTai_DenNgay = DateTime.Now,
                     Truoc_TuNgay = DateTime.Now.AddDays(-1),
                     Truoc_DenNgay = DateTime.Now.AddDays(-1);

            if (PhamVi == PHAMVI_TRONG_NAM)// Trong năm
            {
                HienTai_TuNgay = DateTime.Parse("01/12/" + (DateTime.Now.Year - 1), cul);
                HienTai_DenNgay = DateTime.Parse("30/11/" + DateTime.Now.Year, cul);
                Truoc_TuNgay = DateTime.Parse("01/12/" + (DateTime.Now.Year - 2), cul);
                Truoc_DenNgay = DateTime.Parse("30/11/" + (DateTime.Now.Year - 1), cul);
                ltrPie_Phamvi.Text = "Thụ lý án trong năm";
            }
            else if (PhamVi == PHAMVI_TRONG_THANG)// Trong tháng
            {
                string LastDayOfMonth = DateTime.DaysInMonth(DateTime.Now.Year, DateTime.Now.Month).ToString();
                HienTai_TuNgay = DateTime.Parse("01/" + DateTime.Now.Month + "/" + DateTime.Now.Year, cul);
                HienTai_DenNgay = DateTime.Parse(LastDayOfMonth + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year, cul);
                DateTime Day_ThangTruoc = HienTai_TuNgay.AddMonths(-1);
                string LastDayOfMonth_ThangTruoc = DateTime.DaysInMonth(Day_ThangTruoc.Year, Day_ThangTruoc.Month).ToString();
                Truoc_TuNgay = DateTime.Parse("01/" + Day_ThangTruoc.Month + "/" + Day_ThangTruoc.Year, cul);
                Truoc_DenNgay = DateTime.Parse(LastDayOfMonth_ThangTruoc + "/" + Day_ThangTruoc.Month + "/" + Day_ThangTruoc.Year, cul);
                ltrPie_Phamvi.Text = "Thụ lý án trong tháng";
            }
            else // Trong ngày
            {
                ltrPie_Phamvi.Text = "Thụ lý án trong ngày";
            }
            DataTable tbl = new DataTable();
            if (Cache[cache_name_map] == null)
            {
                tbl = bl.GSTP_HOME_MAP(DonViLogin, HienTai_TuNgay, HienTai_DenNgay, Truoc_TuNgay, Truoc_DenNgay);
                Cache.Add(cache_name_map, tbl, null, DateTime.Now.AddMinutes(720), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
            }
            else
            {
                tbl = (DataTable)Cache[cache_name_map];
            }
            #region Create data to file js
            result += "var simplemaps_usmap_mapdata={ ";
            result += "main_settings: { ";
            // General settings
            result += "width: \"600\",";
            result += "background_color: \"#F2F2F2\",";
            result += "background_transparent: \"no\",";
            result += "border_color: \"#F2F2F2\",";
            result += "popups: \"detect\",";
            // State defaults
            result += "state_description: \"\",";
            result += "state_color: \"#f59d63\",";
            result += "state_hover_color: \"#fb3413\",";
            result += "state_url: \"\",";
            result += "border_size: 1.5,";
            result += "all_states_inactive: \"no\",";
            result += "all_states_zoomable: \"no\",";
            //Location defaults
            result += "location_description: \"Store closest to you!\",";
            result += "location_color: \"#FF0067\",";
            result += "location_opacity: 0.8,";
            result += "location_hover_opacity: 1,";
            result += "location_url: \"\",";
            result += "location_size: 25,";
            result += "location_type: \"square\",";
            result += "location_image_source: \"frog.png\",";
            result += "location_border_color: \"#FFFFFF\",";
            result += "location_border: 2,";
            result += "location_hover_border: 2.5,";
            result += "all_locations_inactive: \"no\",";
            result += "all_locations_hidden: \"no\",";
            //Label defaults
            result += "label_color: \"#d5ddec\",";
            result += "label_hover_color:\"#d5ddec\",";
            result += "label_size: 22,";
            result += "label_font: \"Arial\",";
            result += "hide_labels: \"no\",";
            //Zoom settings
            result += "manual_zoom: \"no\",";
            result += " back_image: \"no\",";
            result += "arrow_color: \"#cecece\",";
            result += "arrow_color_border: \"#808080\",";
            result += "initial_back: \"no\",";
            result += "initial_zoom: -1,";
            result += "initial_zoom_solo: \"no\",";
            result += "region_opacity: 1,";
            result += "region_hover_opacity: 0.6,";
            result += "zoom_out_incrementally: \"yes\",";
            result += "zoom_percentage: 0.99,";
            result += "zoom_time: 0.5,";
            //Popup settings
            result += "popup_color: \"white\",";
            result += "popup_opacity: 0.9,";
            result += "popup_shadow: 1,";
            result += "popup_corners: 5,";
            result += "popup_font: \"12px/1.5 Verdana, Arial, Helvetica, sans-serif\",";
            result += "popup_nocss: \"no\",";
            //Advanced settings
            result += "div: \"map\",";
            result += "auto_load: \"yes\",";
            result += "url_new_tab: \"yes\",";
            result += "images_directory: \"default\",";
            result += "fade_time: 0.1,";
            result += "link_text: \"View Website\"";
            result += "},";

            result += "state_specific: { ";
            int STT = 1, RownNum = tbl.Rows.Count;
            foreach (DataRow row in tbl.Rows)
            {
                if (STT == RownNum)
                {
                    result += row["v_MA"] + ": { ";
                    result += "name: \"" + row["v_NAME"] + "\",";
                    result += "description: \"" + row["v_DESCRIPTION"] + "\",";
                    result += "color: \"default\",";
                    result += "hover_color: \"default\",";
                    result += "url: \"\"";// không cho chuyển link khi bấm chọn tỉnh
                    //result += "url: \"" + row["v_URL"] + "\"";  
                    result += "}";
                }
                else
                {
                    result += row["v_MA"] + ": { ";
                    result += "name: \"" + row["v_NAME"] + "\",";
                    result += "description: \"" + row["v_DESCRIPTION"] + "\",";
                    result += "color: \"default\",";
                    result += "hover_color: \"default\",";
                    result += "url: \"\"";// không cho chuyển link khi bấm chọn tỉnh
                    //result += "url: \"" + row["v_URL"] + "\"";
                    result += "},";
                }
                STT++;
            }
            result += "},";
            result += "locations: { },";
            result += "labels: { }";
            result += "};";
            #endregion
            return result;
        }
        private void CreatMap(decimal DonViLogin, int PhamVi)
        {
            // Tạo dữ liệu cho MapDataJs
            string strFileName_js = "mapdata_" + Session[ENUM_SESSION.SESSION_DONVIID] + ".js";
            string path_js = Server.MapPath("~/GSTP/") + strFileName_js;
            string NoiDungFileJS = CreateMapDataJS(DonViLogin, PhamVi);
            FileInfo oF_js = new FileInfo(path_js);
            if (!oF_js.Exists)// Nếu file chưa tồn tại
            {
                using (FileStream fileStream = oF_js.Create())
                {
                    Byte[] txt = new UTF8Encoding(true).GetBytes(NoiDungFileJS);
                    fileStream.Write(txt, 0, txt.Length);
                    fileStream.Close();
                }
            }
            else // nếu đã tồn tại
            {
                // xóa dữ liệu trong file
                FileStream fileStream = File.Open(path_js, FileMode.Open);
                fileStream.SetLength(0);

                // Xóa file
                //File.Delete(path_js);
                // Tạo lại file 
                //oF_js = new FileInfo(path_js);
                //using (FileStream fileStream = oF_js.Create())
                //{
                // ghi dữ liệu vào file
                Byte[] txt = new UTF8Encoding(true).GetBytes(NoiDungFileJS);
                fileStream.Write(txt, 0, txt.Length);
                fileStream.Close();
                //}
            }
            // gọi file js vào page
            ltrMapjs.Text = "<script src='" + strFileName_js + "'></script>";
        }
        protected void lbtCallDanhSachThamPhan_Click(object sender, EventArgs e)
        {
            decimal DonViLoginID = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID].ToString());
            DM_CANBO_BL bl = new DM_CANBO_BL();
            string Ten = txtSearch.Text.Trim();
            DataTable tbl = bl.DM_CANBO_GET_THAMPHAN_TEN_DV(Ten, DonViLoginID, ENUM_DANHMUC.CHUCDANH);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                Ten = ltrTenTP.Text = tbl.Rows[0]["HOTEN"].ToString();
                ltrChucDanh.Text = tbl.Rows[0]["CHUCDANH"].ToString();
                ltrToaAn.Text = tbl.Rows[0]["TENTOAAN"].ToString();
                ltrQuyetDinhBoNhiem.Text = tbl.Rows[0]["QDBONHIEM"].ToString();
                Session[ENUM_LOAIAN.AN_GSTP] = tbl.Rows[0]["ID"].ToString();
                Session["MaChuongTrinh"] = ENUM_LOAIAN.AN_GSTP;
            }
            else
            {
                ltrTenTP.Text = "Chưa có thẩm phán!";
                ltrChucDanh.Text = ltrToaAn.Text = ltrQuyetDinhBoNhiem.Text = "";
            }
            Session["TenThamPhan"] = Ten;
            Session["HSC"] = "1";
            Response.Redirect(Cls_Comon.GetRootURL() + "/GSTP/Danhsach.aspx");
        }
        protected void lbtCallPage2_SoTham_Click(object sender, EventArgs e)
        {
            string MaMap = ddlDonVi.SelectedValue;
            decimal DonViID = 0;
            if (MaMap.Contains("VNM"))
            {
                if (MaMap != "VNM000")
                {
                    OracleParameter[] prm = new OracleParameter[]
                    {
                    new OracleParameter("MAP_MATOA",MaMap),
                    new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
                    DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GETTOAAN_BY_MAP", prm);
                    if (tbl != null && tbl.Rows.Count > 0)
                    {
                        DonViID = Convert.ToDecimal(tbl.Rows[0]["ID"] + "");
                    }
                }
            }
            else // Đơn vị cấp huyện sẽ không có tiền tố VNM
            {
                DonViID = Convert.ToDecimal(MaMap);
            }
            Session["Page2_ST_prm"] = DonViID;
            Response.Redirect(Cls_Comon.GetRootURL() + "/GSTP/Chitiet_SoTham.aspx");
        }
        protected void lbtCallPage2_PhucTham_Click(object sender, EventArgs e)
        {
            string MaMap = ddlDonVi.SelectedValue;
            decimal DonViID = 0;
            if (MaMap != "VNM000")
            {
                OracleParameter[] prm = new OracleParameter[]
                {
                    new OracleParameter("MAP_MATOA",MaMap),
                    new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GETTOAAN_BY_MAP", prm);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    DonViID = Convert.ToDecimal(tbl.Rows[0]["ID"] + "");
                }
            }
            Session["Page2_PT_prm"] = DonViID;
            Response.Redirect(Cls_Comon.GetRootURL() + "/GSTP/Chitiet_PhucTham.aspx");
        }
        protected void lbtCallPage2_GDT_Click(object sender, EventArgs e)
        {
            string MaMap = ddlDonVi.SelectedValue;
            decimal DonViID = 0;
            if (MaMap != "VNM000")
            {
                OracleParameter[] prm = new OracleParameter[]
                {
                    new OracleParameter("MAP_MATOA",MaMap),
                    new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GETTOAAN_BY_MAP", prm);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    DonViID = Convert.ToDecimal(tbl.Rows[0]["ID"] + "");
                }
            }
            Session["Page2_GDT_prm"] = DonViID;
            Response.Redirect(Cls_Comon.GetRootURL() + "/GSTP/Chitiet_GDT.aspx");
        }
        protected void lbtCallPage2_BAQD_Click(object sender, EventArgs e)
        {
            string MaMap = ddlDonVi.SelectedValue;
            decimal DonViID = 0;
            if (MaMap != "VNM000")
            {
                OracleParameter[] prm = new OracleParameter[]
                {
                    new OracleParameter("MAP_MATOA",MaMap),
                    new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GETTOAAN_BY_MAP", prm);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    DonViID = Convert.ToDecimal(tbl.Rows[0]["ID"] + "");
                }
            }
            Session["Page2_BAQD_prm"] = DonViID;
            Response.Redirect(Cls_Comon.GetRootURL() + "/GSTP/Chitiet_CongBoBA_QD.aspx");
        }
        protected void lbtCallPage2_BAQD_Public_Click(object sender, EventArgs e)
        {
            string MaMap = ddlDonVi.SelectedValue;
            decimal DonViID = 0;
            if (MaMap != "VNM000")
            {
                OracleParameter[] prm = new OracleParameter[]
                {
                    new OracleParameter("MAP_MATOA",MaMap),
                    new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GETTOAAN_BY_MAP", prm);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    DonViID = Convert.ToDecimal(tbl.Rows[0]["ID"] + "");
                }
            }
            Session["Page2_BAQD_prm"] = DonViID;
            Response.Redirect(Cls_Comon.GetRootURL() + "/GSTP/Chitiet_CongBoBA_QD.aspx?pub=1");
        }
        private void Resize_And_Load_DataForm(Decimal DonViLogin, string MaMap)
        {
            // Tổng hợp dữ liệu trong năm hiện tại, năm trước
            string CapToa = "";
            DateTime HienTai_TuNgay = DateTime.Parse("01/12/" + (DateTime.Now.Year - 1), cul);
            DateTime HienTai_DenNgay = DateTime.Parse("30/11/" + DateTime.Now.Year, cul);
            decimal DonViID = 0;
            DM_TOAAN ta = dt.DM_TOAAN.Where(x => x.ID == DonViLogin).FirstOrDefault();
            if (ta != null)
            {
                CapToa = ta.LOAITOA;
                DonViID = DonViLogin;
            }
            if (MaMap != "VNM000")
            {
                OracleParameter[] prm = new OracleParameter[]
                {
                    new OracleParameter("MAP_MATOA",MaMap),
                    new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GETTOAAN_BY_MAP", prm);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    CapToa = tbl.Rows[0]["LOAITOA"] + "";
                    DonViID = Convert.ToDecimal(tbl.Rows[0]["ID"] + "");
                }
            }
            else
            {
                CapToa = "";
                DonViID = 0;
            }
            GiaiDoanXetXu_SoTham.Visible = GiaiDoanXetXu_PhucTham.Visible = GiaiDoanXetXu_DonGDT.Visible = GiaiDoanXetXu_GDT.Visible = false;
            if (CapToa == "CAPHUYEN" || CapToa == "QSKHUVUC")
            {
                GiaiDoanXetXu_SoTham.Visible = true;
                LoadThongKeSoTham(DonViID, CapToa, HienTai_TuNgay, HienTai_DenNgay);
                NoiDung_BanDo.Style.Add("height", "1040px !important");
                MenuLeft.Style.Add("height", "1271px !important");
                MenuLeft_ex.Style.Add("height", "1271px !important");
            }
            else if (CapToa == "CAPTINH" || CapToa == "QSQUANKHU")
            {
                GiaiDoanXetXu_SoTham.Visible = GiaiDoanXetXu_PhucTham.Visible = true;
                LoadThongKeSoTham(DonViID, CapToa, HienTai_TuNgay, HienTai_DenNgay);
                LoadThongKePhucTham(DonViID, CapToa, HienTai_TuNgay, HienTai_DenNgay);
                NoiDung_BanDo.Style.Add("height", "1040px !important");
                MenuLeft.Style.Add("height", "1271px !important");
                MenuLeft_ex.Style.Add("height", "1271px !important");
            }
            else if (CapToa == "CAPCAO" || CapToa == "QSTRUNGUONG")
            {
                GiaiDoanXetXu_PhucTham.Visible = GiaiDoanXetXu_DonGDT.Visible = GiaiDoanXetXu_GDT.Visible = true;
                LoadThongKePhucTham(DonViID, CapToa, HienTai_TuNgay, HienTai_DenNgay);
                LoadThongKeGDT(DonViID, HienTai_TuNgay, HienTai_DenNgay);
                NoiDung_BanDo.Style.Add("height", "1040px !important");
                MenuLeft.Style.Add("height", "1271px !important");
                MenuLeft_ex.Style.Add("height", "1271px !important");
            }
            else if (CapToa == "TOICAO")
            {
                GiaiDoanXetXu_DonGDT.Visible = GiaiDoanXetXu_GDT.Visible = true;
                LoadThongKeGDT(DonViID, HienTai_TuNgay, HienTai_DenNgay);
                NoiDung_BanDo.Style.Add("height", "1040px !important");
                MenuLeft.Style.Add("height", "1271px !important");
                MenuLeft_ex.Style.Add("height", "1271px !important");
            }
            else // Cả nước
            {
                GiaiDoanXetXu_SoTham.Visible = GiaiDoanXetXu_PhucTham.Visible = GiaiDoanXetXu_DonGDT.Visible = GiaiDoanXetXu_GDT.Visible = true;
                LoadThongKeSoTham(DonViID, CapToa, HienTai_TuNgay, HienTai_DenNgay);
                LoadThongKePhucTham(DonViID, CapToa, HienTai_TuNgay, HienTai_DenNgay);
                LoadThongKeGDT(DonViID, HienTai_TuNgay, HienTai_DenNgay);
                NoiDung_BanDo.Style.Add("height", "1258px !important");
                MenuLeft.Style.Add("height", "1490px !important");
                MenuLeft_ex.Style.Add("height", "1490px !important");
            }
            LoadThongKeThamPhan(DonViID, CapToa);
            LoadCongBoBAQD(DonViID, CapToa);
        }
        protected void ddlDonVi_SelectedIndexChanged(object sender, EventArgs e)
        {
            int PhamVi = Convert.ToInt16(ddlPhamvi.SelectedValue);
            // Phần thống kê bên trái này là tính theo năm
            // Phạm vi là rong năm thì mới tính
            if (PhamVi == PHAMVI_TRONG_NAM)
            {
                decimal DonViLoginID = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID].ToString());
                string MaMap = ddlDonVi.SelectedValue;
                Resize_And_Load_DataForm(DonViLoginID, MaMap);
            }
        }
        private DataTable Fill_Data_ToTable_SoTham(decimal DonViID, string CapToa, DateTime Ky_HienTai_TuNgay, DateTime Ky_Hientai_DenNgay)
        {
            DateTime Ky_Truoc_DayKy = DateTime.Parse("01/12/" + (Ky_Hientai_DenNgay.Year - 2), cul),
                     Ky_Truoc_CuoiKy = DateTime.Parse("30/11/" + (Ky_Hientai_DenNgay.Year - 1), cul),
                     Ky_Truoc_Nua_DauKy = DateTime.Parse("01/12/" + (Ky_Hientai_DenNgay.Year - 3), cul),
                     Ky_Truoc_Nua_CuoiKy = DateTime.Parse("30/11/" + (Ky_Hientai_DenNgay.Year - 2), cul);
            DataTable tblResult = new DataTable();
            bool isNull = false;
            // tính kỳ hiện tại
            DataTable data = bl.GSTP_HOME_ST(DonViID, CapToa, Ky_HienTai_TuNgay, Ky_Hientai_DenNgay, Ky_Truoc_DayKy, Ky_Truoc_CuoiKy);
            if (data != null && data.Rows.Count > 0)
            {
                tblResult = data.Clone();
                DataRow row = tblResult.NewRow();
                row["V_STT"] = "1";
                row["V_TOAAN"] = "1";
                row["V_THULYMOI"] = data.Rows[0]["V_THULYMOI"];
                row["V_TONGTHULY"] = data.Rows[0]["V_TONGTHULY"];
                row["V_GIAIQUYET"] = data.Rows[0]["V_GIAIQUYET"];
                row["V_GIAIQUYET_TYLE"] = data.Rows[0]["V_GIAIQUYET_TYLE"];
                row["V_ANHUY_SUA"] = data.Rows[0]["V_ANHUY_SUA"];
                row["V_ANHUY_SUA_TYLE"] = data.Rows[0]["V_ANHUY_SUA_TYLE"];
                row["V_CHUA_GQ"] = data.Rows[0]["V_CHUA_GQ"];
                row["V_CHUA_GQ_TYLE"] = data.Rows[0]["V_CHUA_GQ_TYLE"];
                row["V_QUAHAN"] = data.Rows[0]["V_QUAHAN"];
                row["V_RUTKN"] = data.Rows[0]["V_RUTKN"];
                row["V_RUTKN_THAMPHAN"] = data.Rows[0]["V_RUTKN_THAMPHAN"];
                row["V_HINHSU_TONGTHULY"] = data.Rows[0]["V_HINHSU_TONGTHULY"];
                row["V_HINHSU_TONGGIAIQUYET"] = data.Rows[0]["V_HINHSU_TONGGIAIQUYET"];
                row["V_DANSU_TONGTHULY"] = data.Rows[0]["V_DANSU_TONGTHULY"];
                row["V_DANSU_TONGGIAIQUYET"] = data.Rows[0]["V_DANSU_TONGGIAIQUYET"];
                row["V_HNGD_TONGTHULY"] = data.Rows[0]["V_HNGD_TONGTHULY"];
                row["V_HNGD_TONGGIAIQUYET"] = data.Rows[0]["V_HNGD_TONGGIAIQUYET"];
                row["V_KDTM_TONGTHULY"] = data.Rows[0]["V_KDTM_TONGTHULY"];
                row["V_KDTM_TONGGIAIQUYET"] = data.Rows[0]["V_KDTM_TONGGIAIQUYET"];
                row["V_HANHCHINH_TONGTHULY"] = data.Rows[0]["V_HANHCHINH_TONGTHULY"];
                row["V_HANHCHINH_TONGGIAIQUYET"] = data.Rows[0]["V_HANHCHINH_TONGGIAIQUYET"];
                row["V_LAODONG_TONGTHULY"] = data.Rows[0]["V_LAODONG_TONGTHULY"];
                row["V_LAODONG_TONGGIAIQUYET"] = data.Rows[0]["V_LAODONG_TONGGIAIQUYET"];
                tblResult.Rows.Add(row);
            }
            else
            {
                isNull = true;
            }
            // Tính kỳ trước
            data = bl.GSTP_HOME_ST(DonViID, CapToa, Ky_Truoc_DayKy, Ky_Truoc_DayKy, Ky_Truoc_Nua_DauKy, Ky_Truoc_Nua_CuoiKy);
            if (data != null && data.Rows.Count > 0)
            {
                if (isNull)
                {
                    tblResult = data.Clone();
                }
                DataRow row = tblResult.NewRow();
                row["V_STT"] = "2";
                row["V_TOAAN"] = "2";
                row["V_THULYMOI"] = data.Rows[0]["V_THULYMOI"];
                row["V_TONGTHULY"] = data.Rows[0]["V_TONGTHULY"];
                row["V_GIAIQUYET"] = data.Rows[0]["V_GIAIQUYET"];
                row["V_GIAIQUYET_TYLE"] = data.Rows[0]["V_GIAIQUYET_TYLE"];
                row["V_ANHUY_SUA"] = data.Rows[0]["V_ANHUY_SUA"];
                row["V_ANHUY_SUA_TYLE"] = data.Rows[0]["V_ANHUY_SUA_TYLE"];
                row["V_CHUA_GQ"] = data.Rows[0]["V_CHUA_GQ"];
                row["V_CHUA_GQ_TYLE"] = data.Rows[0]["V_CHUA_GQ_TYLE"];
                row["V_QUAHAN"] = data.Rows[0]["V_QUAHAN"];
                row["V_RUTKN"] = data.Rows[0]["V_RUTKN"];
                row["V_RUTKN_THAMPHAN"] = data.Rows[0]["V_RUTKN_THAMPHAN"];
                row["V_HINHSU_TONGTHULY"] = data.Rows[0]["V_HINHSU_TONGTHULY"];
                row["V_HINHSU_TONGGIAIQUYET"] = data.Rows[0]["V_HINHSU_TONGGIAIQUYET"];
                row["V_DANSU_TONGTHULY"] = data.Rows[0]["V_DANSU_TONGTHULY"];
                row["V_DANSU_TONGGIAIQUYET"] = data.Rows[0]["V_DANSU_TONGGIAIQUYET"];
                row["V_HNGD_TONGTHULY"] = data.Rows[0]["V_HNGD_TONGTHULY"];
                row["V_HNGD_TONGGIAIQUYET"] = data.Rows[0]["V_HNGD_TONGGIAIQUYET"];
                row["V_KDTM_TONGTHULY"] = data.Rows[0]["V_KDTM_TONGTHULY"];
                row["V_KDTM_TONGGIAIQUYET"] = data.Rows[0]["V_KDTM_TONGGIAIQUYET"];
                row["V_HANHCHINH_TONGTHULY"] = data.Rows[0]["V_HANHCHINH_TONGTHULY"];
                row["V_HANHCHINH_TONGGIAIQUYET"] = data.Rows[0]["V_HANHCHINH_TONGGIAIQUYET"];
                row["V_LAODONG_TONGTHULY"] = data.Rows[0]["V_LAODONG_TONGTHULY"];
                row["V_LAODONG_TONGGIAIQUYET"] = data.Rows[0]["V_LAODONG_TONGGIAIQUYET"];
                tblResult.Rows.Add(row);
            }
            return tblResult;
        }
        private DataTable Fill_Data_ToTable_SoTham_DKKTT(decimal DonViID, string CapToa, DateTime Ky_HienTai_TuNgay, DateTime Ky_Hientai_DenNgay)
        {
            DateTime Ky_Truoc_DayKy = DateTime.Parse("01/12/" + (Ky_Hientai_DenNgay.Year - 2), cul),
                     Ky_Truoc_CuoiKy = DateTime.Parse("30/11/" + (Ky_Hientai_DenNgay.Year - 1), cul),
                     Ky_Truoc_Nua_DauKy = DateTime.Parse("01/12/" + (Ky_Hientai_DenNgay.Year - 3), cul),
                     Ky_Truoc_Nua_CuoiKy = DateTime.Parse("30/11/" + (Ky_Hientai_DenNgay.Year - 2), cul);
            DataTable tblResult = new DataTable();
            bool isNull = false;
            // tính kỳ hiện tại
            DataTable data = null;//bl.GSTP_HOME_ST_DKKTT(DonViID, CapToa, Ky_HienTai_TuNgay, Ky_Hientai_DenNgay, Ky_Truoc_DayKy, Ky_Truoc_CuoiKy);//
            if (data != null && data.Rows.Count > 0)
            {
                tblResult = data.Clone();
                DataRow row = tblResult.NewRow();
                row["V_STT"] = "1";
                row["V_TOAAN"] = "1";
                row["V_THULYMOI"] = data.Rows[0]["V_THULYMOI"];
                row["V_TONGTHULY"] = data.Rows[0]["V_TONGTHULY"];
                row["V_GIAIQUYET"] = data.Rows[0]["V_GIAIQUYET"];
                row["V_GIAIQUYET_TYLE"] = data.Rows[0]["V_GIAIQUYET_TYLE"];
                row["V_ANHUY_SUA"] = data.Rows[0]["V_ANHUY_SUA"];
                row["V_ANHUY_SUA_TYLE"] = data.Rows[0]["V_ANHUY_SUA_TYLE"];
                row["V_CHUA_GQ"] = data.Rows[0]["V_CHUA_GQ"];
                row["V_CHUA_GQ_TYLE"] = data.Rows[0]["V_CHUA_GQ_TYLE"];
                row["V_QUAHAN"] = data.Rows[0]["V_QUAHAN"];
                row["V_RUTKN"] = data.Rows[0]["V_RUTKN"];
                row["V_RUTKN_THAMPHAN"] = data.Rows[0]["V_RUTKN_THAMPHAN"];
                row["V_HINHSU_TONGTHULY"] = data.Rows[0]["V_HINHSU_TONGTHULY"];
                row["V_HINHSU_TONGGIAIQUYET"] = data.Rows[0]["V_HINHSU_TONGGIAIQUYET"];
                row["V_DANSU_TONGTHULY"] = data.Rows[0]["V_DANSU_TONGTHULY"];
                row["V_DANSU_TONGGIAIQUYET"] = data.Rows[0]["V_DANSU_TONGGIAIQUYET"];
                row["V_HNGD_TONGTHULY"] = data.Rows[0]["V_HNGD_TONGTHULY"];
                row["V_HNGD_TONGGIAIQUYET"] = data.Rows[0]["V_HNGD_TONGGIAIQUYET"];
                row["V_KDTM_TONGTHULY"] = data.Rows[0]["V_KDTM_TONGTHULY"];
                row["V_KDTM_TONGGIAIQUYET"] = data.Rows[0]["V_KDTM_TONGGIAIQUYET"];
                row["V_HANHCHINH_TONGTHULY"] = data.Rows[0]["V_HANHCHINH_TONGTHULY"];
                row["V_HANHCHINH_TONGGIAIQUYET"] = data.Rows[0]["V_HANHCHINH_TONGGIAIQUYET"];
                row["V_LAODONG_TONGTHULY"] = data.Rows[0]["V_LAODONG_TONGTHULY"];
                row["V_LAODONG_TONGGIAIQUYET"] = data.Rows[0]["V_LAODONG_TONGGIAIQUYET"];
                tblResult.Rows.Add(row);
            }
            else
            {
                isNull = true;
            }
            // Tính kỳ trước
            data = bl.GSTP_HOME_ST(DonViID, CapToa, Ky_Truoc_DayKy, Ky_Truoc_DayKy, Ky_Truoc_Nua_DauKy, Ky_Truoc_Nua_CuoiKy);
            if (data != null && data.Rows.Count > 0)
            {
                if (isNull)
                {
                    tblResult = data.Clone();
                }
                DataRow row = tblResult.NewRow();
                row["V_STT"] = "2";
                row["V_TOAAN"] = "2";
                row["V_THULYMOI"] = data.Rows[0]["V_THULYMOI"];
                row["V_TONGTHULY"] = data.Rows[0]["V_TONGTHULY"];
                row["V_GIAIQUYET"] = data.Rows[0]["V_GIAIQUYET"];
                row["V_GIAIQUYET_TYLE"] = data.Rows[0]["V_GIAIQUYET_TYLE"];
                row["V_ANHUY_SUA"] = data.Rows[0]["V_ANHUY_SUA"];
                row["V_ANHUY_SUA_TYLE"] = data.Rows[0]["V_ANHUY_SUA_TYLE"];
                row["V_CHUA_GQ"] = data.Rows[0]["V_CHUA_GQ"];
                row["V_CHUA_GQ_TYLE"] = data.Rows[0]["V_CHUA_GQ_TYLE"];
                row["V_QUAHAN"] = data.Rows[0]["V_QUAHAN"];
                row["V_RUTKN"] = data.Rows[0]["V_RUTKN"];
                row["V_RUTKN_THAMPHAN"] = data.Rows[0]["V_RUTKN_THAMPHAN"];
                row["V_HINHSU_TONGTHULY"] = data.Rows[0]["V_HINHSU_TONGTHULY"];
                row["V_HINHSU_TONGGIAIQUYET"] = data.Rows[0]["V_HINHSU_TONGGIAIQUYET"];
                row["V_DANSU_TONGTHULY"] = data.Rows[0]["V_DANSU_TONGTHULY"];
                row["V_DANSU_TONGGIAIQUYET"] = data.Rows[0]["V_DANSU_TONGGIAIQUYET"];
                row["V_HNGD_TONGTHULY"] = data.Rows[0]["V_HNGD_TONGTHULY"];
                row["V_HNGD_TONGGIAIQUYET"] = data.Rows[0]["V_HNGD_TONGGIAIQUYET"];
                row["V_KDTM_TONGTHULY"] = data.Rows[0]["V_KDTM_TONGTHULY"];
                row["V_KDTM_TONGGIAIQUYET"] = data.Rows[0]["V_KDTM_TONGGIAIQUYET"];
                row["V_HANHCHINH_TONGTHULY"] = data.Rows[0]["V_HANHCHINH_TONGTHULY"];
                row["V_HANHCHINH_TONGGIAIQUYET"] = data.Rows[0]["V_HANHCHINH_TONGGIAIQUYET"];
                row["V_LAODONG_TONGTHULY"] = data.Rows[0]["V_LAODONG_TONGTHULY"];
                row["V_LAODONG_TONGGIAIQUYET"] = data.Rows[0]["V_LAODONG_TONGGIAIQUYET"];
                tblResult.Rows.Add(row);
            }
            return tblResult;
        }
        

        private DataTable Fill_Data_ToTable_PhucTham(decimal DonViID, string CapToa, DateTime Ky_HienTai_TuNgay, DateTime Ky_Hientai_DenNgay)
        {
            DateTime Ky_Truoc_DayKy = DateTime.Parse("01/12/" + (Ky_Hientai_DenNgay.Year - 2), cul),
                     Ky_Truoc_CuoiKy = DateTime.Parse("30/11/" + (Ky_Hientai_DenNgay.Year - 1), cul),
                     Ky_Truoc_Nua_DauKy = DateTime.Parse("01/12/" + (Ky_Hientai_DenNgay.Year - 3), cul),
                     Ky_Truoc_Nua_CuoiKy = DateTime.Parse("30/11/" + (Ky_Hientai_DenNgay.Year - 2), cul);
            DataTable tblResult = new DataTable();
            bool isNull = false;
            // tính năm hiện tại
            DataTable data = bl.GSTP_HOME_PT(DonViID, CapToa, Ky_HienTai_TuNgay, Ky_Hientai_DenNgay, Ky_Truoc_DayKy, Ky_Truoc_CuoiKy);
            if (data != null && data.Rows.Count > 0)
            {
                tblResult = data.Clone();
                DataRow row = tblResult.NewRow();
                row["V_STT"] = "1";
                row["V_TOAAN"] = "1";
                row["V_THULYMOI"] = data.Rows[0]["V_THULYMOI"];
                row["V_TONGTHULY"] = data.Rows[0]["V_TONGTHULY"];
                row["V_GIAIQUYET"] = data.Rows[0]["V_GIAIQUYET"];
                row["V_GIAIQUYET_TYLE"] = data.Rows[0]["V_GIAIQUYET_TYLE"];
                row["V_ANHUY_SUA"] = data.Rows[0]["V_ANHUY_SUA"];
                row["V_ANHUY_SUA_TYLE"] = data.Rows[0]["V_ANHUY_SUA_TYLE"];
                row["V_CHUA_GQ"] = data.Rows[0]["V_CHUA_GQ"];
                row["V_CHUA_GQ_TYLE"] = data.Rows[0]["V_CHUA_GQ_TYLE"];
                row["V_QUAHAN"] = data.Rows[0]["V_QUAHAN"];
                row["V_RUTKN"] = data.Rows[0]["V_RUTKN"];
                row["V_RUTKN_THAMPHAN"] = data.Rows[0]["V_RUTKN_THAMPHAN"];
                row["V_HINHSU_TONGTHULY"] = data.Rows[0]["V_HINHSU_TONGTHULY"];
                row["V_HINHSU_TONGGIAIQUYET"] = data.Rows[0]["V_HINHSU_TONGGIAIQUYET"];
                row["V_DANSU_TONGTHULY"] = data.Rows[0]["V_DANSU_TONGTHULY"];
                row["V_DANSU_TONGGIAIQUYET"] = data.Rows[0]["V_DANSU_TONGGIAIQUYET"];
                row["V_HNGD_TONGTHULY"] = data.Rows[0]["V_HNGD_TONGTHULY"];
                row["V_HNGD_TONGGIAIQUYET"] = data.Rows[0]["V_HNGD_TONGGIAIQUYET"];
                row["V_KDTM_TONGTHULY"] = data.Rows[0]["V_KDTM_TONGTHULY"];
                row["V_KDTM_TONGGIAIQUYET"] = data.Rows[0]["V_KDTM_TONGGIAIQUYET"];
                row["V_HANHCHINH_TONGTHULY"] = data.Rows[0]["V_HANHCHINH_TONGTHULY"];
                row["V_HANHCHINH_TONGGIAIQUYET"] = data.Rows[0]["V_HANHCHINH_TONGGIAIQUYET"];
                row["V_LAODONG_TONGTHULY"] = data.Rows[0]["V_LAODONG_TONGTHULY"];
                row["V_LAODONG_TONGGIAIQUYET"] = data.Rows[0]["V_LAODONG_TONGGIAIQUYET"];
                tblResult.Rows.Add(row);
            }
            else
            {
                isNull = true;
            }
            // Tính năm trước
            data = bl.GSTP_HOME_PT(DonViID, CapToa, Ky_Truoc_DayKy, Ky_Truoc_CuoiKy, Ky_Truoc_Nua_DauKy, Ky_Truoc_Nua_CuoiKy);
            if (data != null && data.Rows.Count > 0)
            {
                if (isNull)
                {
                    tblResult = data.Clone();
                }
                DataRow row = tblResult.NewRow();
                row["V_STT"] = "2";
                row["V_TOAAN"] = "2";
                row["V_THULYMOI"] = data.Rows[0]["V_THULYMOI"];
                row["V_TONGTHULY"] = data.Rows[0]["V_TONGTHULY"];
                row["V_GIAIQUYET"] = data.Rows[0]["V_GIAIQUYET"];
                row["V_GIAIQUYET_TYLE"] = data.Rows[0]["V_GIAIQUYET_TYLE"];
                row["V_ANHUY_SUA"] = data.Rows[0]["V_ANHUY_SUA"];
                row["V_ANHUY_SUA_TYLE"] = data.Rows[0]["V_ANHUY_SUA_TYLE"];
                row["V_CHUA_GQ"] = data.Rows[0]["V_CHUA_GQ"];
                row["V_CHUA_GQ_TYLE"] = data.Rows[0]["V_CHUA_GQ_TYLE"];
                row["V_QUAHAN"] = data.Rows[0]["V_QUAHAN"];
                row["V_RUTKN"] = data.Rows[0]["V_RUTKN"];
                row["V_RUTKN_THAMPHAN"] = data.Rows[0]["V_RUTKN_THAMPHAN"];
                row["V_HINHSU_TONGTHULY"] = data.Rows[0]["V_HINHSU_TONGTHULY"];
                row["V_HINHSU_TONGGIAIQUYET"] = data.Rows[0]["V_HINHSU_TONGGIAIQUYET"];
                row["V_DANSU_TONGTHULY"] = data.Rows[0]["V_DANSU_TONGTHULY"];
                row["V_DANSU_TONGGIAIQUYET"] = data.Rows[0]["V_DANSU_TONGGIAIQUYET"];
                row["V_HNGD_TONGTHULY"] = data.Rows[0]["V_HNGD_TONGTHULY"];
                row["V_HNGD_TONGGIAIQUYET"] = data.Rows[0]["V_HNGD_TONGGIAIQUYET"];
                row["V_KDTM_TONGTHULY"] = data.Rows[0]["V_KDTM_TONGTHULY"];
                row["V_KDTM_TONGGIAIQUYET"] = data.Rows[0]["V_KDTM_TONGGIAIQUYET"];
                row["V_HANHCHINH_TONGTHULY"] = data.Rows[0]["V_HANHCHINH_TONGTHULY"];
                row["V_HANHCHINH_TONGGIAIQUYET"] = data.Rows[0]["V_HANHCHINH_TONGGIAIQUYET"];
                row["V_LAODONG_TONGTHULY"] = data.Rows[0]["V_LAODONG_TONGTHULY"];
                row["V_LAODONG_TONGGIAIQUYET"] = data.Rows[0]["V_LAODONG_TONGGIAIQUYET"];
                tblResult.Rows.Add(row);
            }
            return tblResult;
        }
        private DataTable Fill_Data_ToTable_GDT(decimal DonViID, DateTime Ky_HienTai_TuNgay, DateTime Ky_Hientai_DenNgay)
        {
            DateTime Ky_Truoc_DayKy = DateTime.Parse("01/12/" + (Ky_Hientai_DenNgay.Year - 2), cul),
                     Ky_Truoc_CuoiKy = DateTime.Parse("30/11/" + (Ky_Hientai_DenNgay.Year - 1), cul);
            DataTable tblResult = new DataTable();
            bool isNull = false;
            // tính năm hiện tại
            DataTable data = bl.GSTP_HOME_GDT(DonViID, Ky_HienTai_TuNgay, Ky_Hientai_DenNgay);
            if (data != null && data.Rows.Count > 0)
            {
                tblResult = data.Clone();
                DataRow row = tblResult.NewRow();
                row["V_STT"] = "1";
                row["V_TOAAN"] = "1";
                row["DonVuAn_TongVuAn_KyBC"] = data.Rows[0]["DonVuAn_TongVuAn_KyBC"];
                row["DonVuAn_TongAnQH_KyBC"] = data.Rows[0]["DonVuAn_TongAnQH_KyBC"];
                row["DonVuAn_HetThoiHieu_KyBC"] = data.Rows[0]["DonVuAn_HetThoiHieu_KyBC"];
                row["DonVuAn_DaGQ_KyBC"] = data.Rows[0]["DonVuAn_DaGQ_KyBC"];
                row["DonVuAn_ChuaGQ_KyBC"] = data.Rows[0]["DonVuAn_ChuaGQ_KyBC"];
                row["DonGDT_TongDon_KyBC"] = data.Rows[0]["DonGDT_TongDon_KyBC"];
                row["DonGDT_ChuyenVu1_KyBC"] = data.Rows[0]["DonGDT_ChuyenVu1_KyBC"];
                row["DonGDT_ChuyenVu2_KyBC"] = data.Rows[0]["DonGDT_ChuyenVu2_KyBC"];
                row["DonGDT_ChuyenVu3_KyBC"] = data.Rows[0]["DonGDT_ChuyenVu3_KyBC"];
                row["DonGDT_ChuyenCQKhac_KyBC"] = data.Rows[0]["DonGDT_ChuyenCQKhac_KyBC"];
                row["XX_TongSo_KyBC"] = data.Rows[0]["XX_TongSo_KyBC"];
                row["XX_DaGQ_KyBC"] = data.Rows[0]["XX_DaGQ_KyBC"];
                row["XX_ChuaGQ_KyBC"] = data.Rows[0]["XX_ChuaGQ_KyBC"];
                row["XX_AnQuaHan_KyBC"] = data.Rows[0]["XX_AnQuaHan_KyBC"];
                row["XX_HS_ThuLy"] = data.Rows[0]["XX_HS_ThuLy"];
                row["XX_HS_GiaiQuyet"] = data.Rows[0]["XX_HS_GiaiQuyet"];
                row["XX_DS_ThuLy"] = data.Rows[0]["XX_DS_ThuLy"];
                row["XX_DS_GiaiQuyet"] = data.Rows[0]["XX_DS_GiaiQuyet"];
                row["XX_HC_ThuLy"] = data.Rows[0]["XX_HC_ThuLy"];
                row["XX_HC_GiaiQuyet"] = data.Rows[0]["XX_HC_GiaiQuyet"];
                row["XX_HNGD_ThuLy"] = data.Rows[0]["XX_HNGD_ThuLy"];
                row["XX_HNGD_GiaiQuyet"] = data.Rows[0]["XX_HNGD_GiaiQuyet"];
                row["XX_LD_ThuLy"] = data.Rows[0]["XX_LD_ThuLy"];
                row["XX_LD_GiaiQuyet"] = data.Rows[0]["XX_LD_GiaiQuyet"];
                row["XX_KDTM_ThuLy"] = data.Rows[0]["XX_KDTM_ThuLy"];
                row["XX_KDTM_GiaiQuyet"] = data.Rows[0]["XX_KDTM_GiaiQuyet"];
                row["XX_ThuLyMoi"] = data.Rows[0]["XX_ThuLyMoi"];
                tblResult.Rows.Add(row);
            }
            else
            {
                isNull = true;
            }
            // Tính năm trước
            data = bl.GSTP_HOME_GDT(DonViID, Ky_Truoc_DayKy, Ky_Truoc_CuoiKy);
            if (data != null && data.Rows.Count > 0)
            {
                if (isNull)
                {
                    tblResult = data.Clone();
                }
                DataRow row = tblResult.NewRow();
                row["V_STT"] = "2";
                row["V_TOAAN"] = "2";
                row["DonVuAn_TongVuAn_KyBC"] = data.Rows[0]["DonVuAn_TongVuAn_KyBC"];
                row["DonVuAn_TongAnQH_KyBC"] = data.Rows[0]["DonVuAn_TongAnQH_KyBC"];
                row["DonVuAn_HetThoiHieu_KyBC"] = data.Rows[0]["DonVuAn_HetThoiHieu_KyBC"];
                row["DonVuAn_DaGQ_KyBC"] = data.Rows[0]["DonVuAn_DaGQ_KyBC"];
                row["DonVuAn_ChuaGQ_KyBC"] = data.Rows[0]["DonVuAn_ChuaGQ_KyBC"];
                row["DonGDT_TongDon_KyBC"] = data.Rows[0]["DonGDT_TongDon_KyBC"];
                row["DonGDT_ChuyenVu1_KyBC"] = data.Rows[0]["DonGDT_ChuyenVu1_KyBC"];
                row["DonGDT_ChuyenVu2_KyBC"] = data.Rows[0]["DonGDT_ChuyenVu2_KyBC"];
                row["DonGDT_ChuyenVu3_KyBC"] = data.Rows[0]["DonGDT_ChuyenVu3_KyBC"];
                row["DonGDT_ChuyenCQKhac_KyBC"] = data.Rows[0]["DonGDT_ChuyenCQKhac_KyBC"];
                row["XX_TongSo_KyBC"] = data.Rows[0]["XX_TongSo_KyBC"];
                row["XX_DaGQ_KyBC"] = data.Rows[0]["XX_DaGQ_KyBC"];
                row["XX_ChuaGQ_KyBC"] = data.Rows[0]["XX_ChuaGQ_KyBC"];
                row["XX_AnQuaHan_KyBC"] = data.Rows[0]["XX_AnQuaHan_KyBC"];
                row["XX_HS_ThuLy"] = data.Rows[0]["XX_HS_ThuLy"];
                row["XX_HS_GiaiQuyet"] = data.Rows[0]["XX_HS_GiaiQuyet"];
                row["XX_DS_ThuLy"] = data.Rows[0]["XX_DS_ThuLy"];
                row["XX_DS_GiaiQuyet"] = data.Rows[0]["XX_DS_GiaiQuyet"];
                row["XX_HC_ThuLy"] = data.Rows[0]["XX_HC_ThuLy"];
                row["XX_HC_GiaiQuyet"] = data.Rows[0]["XX_HC_GiaiQuyet"];
                row["XX_HNGD_ThuLy"] = data.Rows[0]["XX_HNGD_ThuLy"];
                row["XX_HNGD_GiaiQuyet"] = data.Rows[0]["XX_HNGD_GiaiQuyet"];
                row["XX_LD_ThuLy"] = data.Rows[0]["XX_LD_ThuLy"];
                row["XX_LD_GiaiQuyet"] = data.Rows[0]["XX_LD_GiaiQuyet"];
                row["XX_KDTM_ThuLy"] = data.Rows[0]["XX_KDTM_ThuLy"];
                row["XX_KDTM_GiaiQuyet"] = data.Rows[0]["XX_KDTM_GiaiQuyet"];
                row["XX_ThuLyMoi"] = data.Rows[0]["XX_ThuLyMoi"];
                tblResult.Rows.Add(row);
            }
            return tblResult;
        }
        private DataTable Fill_Data_ToTable_ThamPhan(decimal DonViID, string CapToa, DateTime Ky_HienTai_TuNgay, DateTime Ky_Hientai_DenNgay)
        {
            DateTime Ky_Truoc_DayKy = DateTime.Parse("01/12/" + (Ky_Hientai_DenNgay.Year - 2), cul),
                     Ky_Truoc_CuoiKy = DateTime.Parse("30/11/" + (Ky_Hientai_DenNgay.Year - 1), cul);
            DataTable tblResult = new DataTable();
            bool isNull = false;
            // tính năm hiện tại
            DataTable data = bl.GSTP_HOME_THAMPHAN(DonViID, CapToa, Ky_HienTai_TuNgay, Ky_Hientai_DenNgay);
            if (data != null && data.Rows.Count > 0)
            {
                tblResult = data.Clone();
                DataRow row = tblResult.NewRow();
                row["V_TP_DANGCONGTAC"] = data.Rows[0]["V_TP_DANGCONGTAC"];
                row["V_TP_NHIEMKY"] = data.Rows[0]["V_TP_NHIEMKY"];
                row["V_TP_DUNG_XETXU"] = data.Rows[0]["V_TP_DUNG_XETXU"];
                row["V_TP_DUNG_XETXU_TYLE"] = data.Rows[0]["V_TP_DUNG_XETXU_TYLE"];
                row["V_TP_KHIEUNAI_TOCAO"] = data.Rows[0]["V_TP_KHIEUNAI_TOCAO"];
                row["V_TP_KHIEUNAI_TOCAO_TYLE"] = data.Rows[0]["V_TP_KHIEUNAI_TOCAO_TYLE"];
                row["V_TP_SUAHUY"] = data.Rows[0]["V_TP_SUAHUY"];
                row["V_TP_SUAHUY_TYLE"] = data.Rows[0]["V_TP_SUAHUY_TYLE"];
                row["V_TP_SUAHUY_QD120"] = data.Rows[0]["V_TP_SUAHUY_QD120"];
                tblResult.Rows.Add(row);
            }
            else
            {
                isNull = true;
            }
            // Tính năm trước
            data = bl.GSTP_HOME_THAMPHAN(DonViID, CapToa, Ky_Truoc_DayKy, Ky_Truoc_CuoiKy);
            if (data != null && data.Rows.Count > 0)
            {
                if (isNull)
                {
                    tblResult = data.Clone();
                }
                DataRow row = tblResult.NewRow();
                row["V_TP_DANGCONGTAC"] = data.Rows[0]["V_TP_DANGCONGTAC"];
                row["V_TP_NHIEMKY"] = data.Rows[0]["V_TP_NHIEMKY"];
                row["V_TP_DUNG_XETXU"] = data.Rows[0]["V_TP_DUNG_XETXU"];
                row["V_TP_DUNG_XETXU_TYLE"] = data.Rows[0]["V_TP_DUNG_XETXU_TYLE"];
                row["V_TP_KHIEUNAI_TOCAO"] = data.Rows[0]["V_TP_KHIEUNAI_TOCAO"];
                row["V_TP_KHIEUNAI_TOCAO_TYLE"] = data.Rows[0]["V_TP_KHIEUNAI_TOCAO_TYLE"];
                row["V_TP_SUAHUY"] = data.Rows[0]["V_TP_SUAHUY"];
                row["V_TP_SUAHUY_TYLE"] = data.Rows[0]["V_TP_SUAHUY_TYLE"];
                row["V_TP_SUAHUY_QD120"] = data.Rows[0]["V_TP_SUAHUY_QD120"];
                tblResult.Rows.Add(row);
            }
            return tblResult;
        }

    }
}