using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.GSTP
{
    public partial class Chitiet_GDT : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            string strUserID = Session[ENUM_SESSION.SESSION_USERID] + "";
            if (strUserID == "") Response.Redirect(Cls_Comon.GetRootURL() + "/Login.aspx");
            string strMaHeThong = Session["MaHeThong"] + "";
            if (strMaHeThong == "") Response.Redirect(Cls_Comon.GetRootURL() + "/Launcher.aspx");
            if (!IsPostBack)
            {
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
                decimal DonViID = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID].ToString());
                string TenToaAn = "", Ma_Ten_ToaAn = "";
                DM_TOAAN otToaAN = dt.DM_TOAAN.Where(x => x.ID == DonViID).FirstOrDefault();
                if (otToaAN != null)
                {
                    TenToaAn = otToaAN.TEN + "";
                    Ma_Ten_ToaAn = otToaAN.MA_TEN + "";
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
                        ltrToaAn.Text = TenToaAn.Replace("Tòa án nhân dân", "TAND");
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
                if (Session["Page2_GDT_prm"] != null)
                {
                    DonViID = Convert.ToDecimal(Session["Page2_GDT_prm"] + "");
                }
                TenToaAn = "";
                if (DonViID != 0)
                {
                    string TenToa = "";
                    DM_TOAAN ta = dt.DM_TOAAN.Where(x => x.ID == DonViID).FirstOrDefault();
                    if (ta != null)
                    {
                        TenToa = ta.TEN;
                    }
                    TenToa = TenToa.ToLower().Replace("tòa án nhân dân", "TAND").Replace("tòa án quân sự", "TAQS");
                    lblTitleTrang2.Text = "Tình hình tổng hợp thụ lý; giải quyết đơn đề nghị GĐT,TT và xét xử GĐT,TT CỦA " + TenToa;
                    if (TenToa.Contains("tối cao"))
                    {
                        TenToaAn = "tối cao";
                        tr_Vu1.Visible = true;
                        tr_Vu2.Visible = true;
                        tr_Vu2_KT.Visible = true;
                        tr_Vu2_Row_Empty.Visible = true;
                        tr_Vu2_Tong.Visible = true;
                        tr_Vu3.Visible = true;
                        tr_Vu3_HC.Visible = true;
                        tr_Vu3_LD.Visible = true;
                        tr_Vu3_Row_Empty.Visible = true;
                        tr_Vu3_Tong.Visible = true;
                    }
                    else if (TenToa.Contains("cấp cao") && TenToa.Contains("hà nội"))
                    {
                        TenToaAn = "cấp cao tại hà nội";
                        tr_CC_HaNoi.Visible = true;
                        tr_CC_HaNoi_DS.Visible = true;
                        tr_CC_HaNoi_HC.Visible = true;
                        tr_CC_HaNoi_HN.Visible = true;
                        tr_CC_HaNoi_KT.Visible = true;
                        tr_CC_HaNoi_LD.Visible = true;
                        tr_CC_HaNoi_Row_Empty.Visible = false;
                        tr_CC_HaNoi_Tong.Visible = true;
                    }
                    else if (TenToa.Contains("cấp cao") && TenToa.Contains("đà nẵng"))
                    {
                        TenToaAn = "cấp cao tại đà nẵng";
                        tr_CC_DaNang.Visible = true;
                        tr_CC_DaNang_DS.Visible = true;
                        tr_CC_DaNang_HC.Visible = true;
                        tr_CC_DaNang_HN.Visible = true;
                        tr_CC_DaNang_KT.Visible = true;
                        tr_CC_DaNang_LD.Visible = true;
                        tr_CC_DaNang_Row_Empty.Visible = false;
                        tr_CC_DaNang_Tong.Visible = true;
                    }
                    else if (TenToa.Contains("cấp cao") && TenToa.Contains("hồ chí minh"))
                    {
                        TenToaAn = "cấp cao tại HCM";
                        tr_CC_HCM.Visible = true;
                        tr_CC_HCM_DS.Visible = true;
                        tr_CC_HCM_HC.Visible = true;
                        tr_CC_HCM_HN.Visible = true;
                        tr_CC_HCM_KT.Visible = true;
                        tr_CC_HCM_LD.Visible = true;
                        tr_CC_HCM_Row_Empty.Visible = false;
                        tr_CC_HCM_Tong.Visible = true;
                    }
                    MenuLeft.Style.Add("height", "799px !important");
                    MenuLeft_ex.Style.Add("height", "799px !important");
                    td_NoiDung.Style.Add("height", "703px !important");
                }
                else
                {
                    lblTitleTrang2.Text = "Tình hình tổng hợp thụ lý; giải quyết đơn đề nghị GĐT,TT và xét xử GĐT,TT CỦA CẢ NƯỚC";
                    tr_Vu1.Visible = true;
                    tr_Vu2.Visible = true;
                    tr_Vu2_KT.Visible = true;
                    tr_Vu2_Row_Empty.Visible = true;
                    tr_Vu2_Tong.Visible = true;
                    tr_Vu3.Visible = true;
                    tr_Vu3_HC.Visible = true;
                    tr_Vu3_LD.Visible = true;
                    tr_Vu3_Row_Empty.Visible = true;
                    tr_Vu3_Tong.Visible = true;
                    tr_CC_HaNoi.Visible = true;
                    tr_CC_HaNoi_DS.Visible = true;
                    tr_CC_HaNoi_HC.Visible = true;
                    tr_CC_HaNoi_HN.Visible = true;
                    tr_CC_HaNoi_KT.Visible = true;
                    tr_CC_HaNoi_LD.Visible = true;
                    tr_CC_HaNoi_Row_Empty.Visible = true;
                    tr_CC_HaNoi_Tong.Visible = true;
                    tr_CC_DaNang.Visible = true;
                    tr_CC_DaNang_DS.Visible = true;
                    tr_CC_DaNang_HC.Visible = true;
                    tr_CC_DaNang_HN.Visible = true;
                    tr_CC_DaNang_KT.Visible = true;
                    tr_CC_DaNang_LD.Visible = true;
                    tr_CC_DaNang_Row_Empty.Visible = true;
                    tr_CC_DaNang_Tong.Visible = true;
                    tr_CC_HCM.Visible = true;
                    tr_CC_HCM_DS.Visible = true;
                    tr_CC_HCM_HC.Visible = true;
                    tr_CC_HCM_HN.Visible = true;
                    tr_CC_HCM_KT.Visible = true;
                    tr_CC_HCM_LD.Visible = true;
                    tr_CC_HCM_Row_Empty.Visible = true;
                    tr_CC_HCM_Tong.Visible = true;
                }
                LoadData(DonViID, TenToaAn);
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
        protected void cmd_MenuLeft_Home_Click(object sender, EventArgs e)
        {
            Response.Redirect(Cls_Comon.GetRootURL() + "/GSTP/Danhsachtonghop.aspx");
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
        protected void cmd_TraCuu_Click(object sender, EventArgs e)
        {
            decimal DonViLoginID = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID].ToString());
            DM_CANBO_BL bl = new DM_CANBO_BL();
            string Ten = txtSearch.Text.Trim();
            DataTable tbl = bl.DM_CANBO_GET_THAMPHAN_TEN_DV(Ten, DonViLoginID, ENUM_DANHMUC.CHUCDANH);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                ltrTenTP.Text = tbl.Rows[0]["HOTEN"].ToString();
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
        }
        protected void cmd_DanhSach_Click(object sender, EventArgs e)
        {
            Session["MaChuongTrinh"] = null;
            Session["HSC"] = "1";
            Response.Redirect(Cls_Comon.GetRootURL() + "/GSTP/Danhsach.aspx");
        }
        private void LoadData(decimal DonViID, string TenToa)
        {
            #region Khai báo biến
            decimal AnHinhSu = Convert.ToDecimal(ENUM_LOAIVUVIEC.AN_HINHSU)
                    , AnDanSu = Convert.ToDecimal(ENUM_LOAIVUVIEC.AN_DANSU)
                    , AnKinhTe = Convert.ToDecimal(ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI)
                    , AnHNGD = Convert.ToDecimal(ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH)
                    , AnHanhChinh = Convert.ToDecimal(ENUM_LOAIVUVIEC.AN_HANHCHINH)
                    , AnLaoDong = Convert.ToDecimal(ENUM_LOAIVUVIEC.AN_LAODONG)
                    , Vu1 = 0, Vu2 = 0, Vu3 = 0, Vu_GDT = 0
                    , ToaCapCao_HaNoi = 0, ToacapCao_DaNang = 0, ToaCapCao_HCM = 0
                    , Tong_DonTrung = 0, Tong_DonMoi = 0, Tong_DaGiaiQuyet = 0, Tong_ChuaGiaiQuyet = 0, Tong_AnThoiHieu = 0
                    , Tong_VienTruongKN = 0, Tong_ChanhAnKN = 0, Tong_DaXetXuGDT = 0, Tong_ConLai = 0, Tong_QuaHanLuatDinh = 0
                    , Tong_RutKN = 0, Tong_KoChapNhanKNCuaVT = 0, Tong_HuyBanAn = 0;
            String cache_name = "";
            OracleParameter[] prm = new OracleParameter[] { };
            DataTable tbl = new DataTable();
            DM_TOAAN ta = null;
            #endregion
            if (DonViID == 0 || TenToa == "tối cao")
            {
                DM_PHONGBAN pb = dt.DM_PHONGBAN.Where(x => x.TOAANID == DonViID && x.TENPHONGBAN.ToUpper() == "VỤ GIÁM ĐỐC KIỂM TRA I").FirstOrDefault();
                if (pb != null)
                {
                    Vu1 = pb.ID;
                }
                pb = dt.DM_PHONGBAN.Where(x => x.TOAANID == DonViID && x.TENPHONGBAN.ToUpper().Contains("VỤ GIÁM ĐỐC KIỂM TRA II")).FirstOrDefault();
                if (pb != null)
                {
                    Vu2 = pb.ID;
                }
                pb = dt.DM_PHONGBAN.Where(x => x.TOAANID == DonViID && x.TENPHONGBAN.ToUpper().Contains("VỤ GIÁM ĐỐC KIỂM TRA III")).FirstOrDefault();
                if (pb != null)
                {
                    Vu3 = pb.ID;
                }
                #region Vụ GĐKT I -- Hình sự
                cache_name = "cache_GSTP_Page2_GDT_Vu1_AHS" + DonViID;
                if (Cache[cache_name] == null)
                {
                    prm = new OracleParameter[]
                    {
                    new OracleParameter("curr_loaian",AnHinhSu),
                    new OracleParameter("curr_toaanid",DonViID),
                    new OracleParameter("curr_vu_gdkt",Vu1),
                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
                    tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_ThongKeChung_TheoAn", prm);
                    Cache.Add(cache_name, tbl, null, DateTime.Now.AddMinutes(720), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
                }
                else
                {
                    tbl = (DataTable)Cache[cache_name];
                }
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    DataRow row = tbl.Rows[0];
                    ltr_Vu1_DonTrung.Text = Convert.ToDecimal(row["DonTrung"]).ToString("#,0.##", cul);
                    ltr_Vu1_DonMoi.Text = Convert.ToDecimal(row["DonMoi"]).ToString("#,0.##", cul);
                    ltr_Vu1_DaGiaiQuyet.Text = Convert.ToDecimal(row["DaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_Vu1_ChuaGiaiQuyet.Text = Convert.ToDecimal(row["ChuaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_Vu1_AnThoiHieu.Text = Convert.ToDecimal(row["AnThoiHieu"]).ToString("#,0.##", cul);
                    decimal Vu1_VienTruongKN = Convert.ToDecimal(row["VienTruongKN"]),
                            Vu1_ChanhAnKN = Convert.ToDecimal(row["ChanhAnKN"]);
                    ltr_Vu1_VienTruongKN.Text = Vu1_VienTruongKN.ToString("#,0.##", cul);
                    ltr_Vu1_ChanhAnKN.Text = Vu1_ChanhAnKN.ToString("#,0.##", cul);
                    ltr_Vu1_DaXetXuGDT.Text = Convert.ToDecimal(row["DaXetXuGDT"]).ToString("#,0.##", cul);
                    if (Vu1_VienTruongKN + Vu1_ChanhAnKN > 0)
                    {
                        ltr_Vu1_TyLe.Text = Math.Round((Convert.ToDecimal(row["DaXetXuGDT"]) / (Vu1_VienTruongKN + Vu1_ChanhAnKN) * 100), MidpointRounding.AwayFromZero).ToString("#,0.##", cul);
                    }
                    ltr_Vu1_ConLai.Text = Convert.ToDecimal(row["ChuaXetXuGDT"]).ToString("#,0.##", cul);
                    ltr_Vu1_QuaHanLuatDinh.Text = Convert.ToDecimal(row["QuaHanLuatDinh"]).ToString("#,0.##", cul);
                    ltr_Vu1_RutKN.Text = Convert.ToDecimal(row["RutKN"]).ToString("#,0.##", cul);
                    ltr_Vu1_KoChapNhanKNCuaVT.Text = Convert.ToDecimal(row["KoChapNhanKNCuaVT"]).ToString("#,0.##", cul);
                    ltr_Vu1_HuyBanAn.Text = Convert.ToDecimal(row["HuyBanAn"]).ToString("#,0.##", cul);
                }
                #endregion
                #region Vụ GĐKT II -- Dân sự
                tbl = null;
                cache_name = "cache_GSTP_Page2_GDT_Vu2_ADS" + DonViID;
                if (Cache[cache_name] == null)
                {
                    prm = new OracleParameter[]
                    {
                    new OracleParameter("curr_loaian",AnDanSu),
                    new OracleParameter("curr_toaanid",DonViID),
                    new OracleParameter("curr_vu_gdkt",Vu2),
                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
                    tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_ThongKeChung_TheoAn", prm);
                    Cache.Add(cache_name, tbl, null, DateTime.Now.AddMinutes(720), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
                }
                else
                {
                    tbl = (DataTable)Cache[cache_name];
                }
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    DataRow row = tbl.Rows[0];
                    #region Cộng dồn vào biến tổng
                    Tong_DonTrung = Tong_DonTrung + Convert.ToDecimal(row["DonTrung"]);
                    Tong_DonMoi = Tong_DonMoi + Convert.ToDecimal(row["DonMoi"]);
                    Tong_DaGiaiQuyet = Tong_DaGiaiQuyet + Convert.ToDecimal(row["DaGiaiQuyet"]);
                    Tong_ChuaGiaiQuyet = Tong_ChuaGiaiQuyet + Convert.ToDecimal(row["ChuaGiaiQuyet"]);
                    Tong_AnThoiHieu = Tong_AnThoiHieu + Convert.ToDecimal(row["AnThoiHieu"]);
                    decimal Vu2_KinhTe_VienTruongKN = Convert.ToDecimal(row["VienTruongKN"]),
                            Vu2_KinhTe_ChanhAnKN = Convert.ToDecimal(row["ChanhAnKN"]);
                    Tong_VienTruongKN = Tong_VienTruongKN + Vu2_KinhTe_VienTruongKN;
                    Tong_ChanhAnKN = Tong_ChanhAnKN + Vu2_KinhTe_ChanhAnKN;
                    Tong_DaXetXuGDT = Tong_DaXetXuGDT + Convert.ToDecimal(row["DaXetXuGDT"]);
                    Tong_ConLai = Tong_ConLai + Convert.ToDecimal(row["ChuaXetXuGDT"]);
                    Tong_QuaHanLuatDinh = Tong_QuaHanLuatDinh + Convert.ToDecimal(row["QuaHanLuatDinh"]);
                    Tong_RutKN = Tong_RutKN + Convert.ToDecimal(row["RutKN"]);
                    Tong_KoChapNhanKNCuaVT = Tong_KoChapNhanKNCuaVT + Convert.ToDecimal(row["KoChapNhanKNCuaVT"]);
                    Tong_HuyBanAn = Tong_HuyBanAn + Convert.ToDecimal(row["HuyBanAn"]);
                    #endregion
                    ltr_Vu2_DanSu_DonTrung.Text = Convert.ToDecimal(row["DonTrung"]).ToString("#,0.##", cul);
                    ltr_Vu2_DanSu_DonMoi.Text = Convert.ToDecimal(row["DonMoi"]).ToString("#,0.##", cul);
                    ltr_Vu2_DanSu_DaGiaiQuyet.Text = Convert.ToDecimal(row["DaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_Vu2_DanSu_ChuaGiaiQuyet.Text = Convert.ToDecimal(row["ChuaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_Vu2_DanSu_AnThoiHieu.Text = Convert.ToDecimal(row["AnThoiHieu"]).ToString("#,0.##", cul);
                    decimal Vu2_DanSu_VienTruongKN = Convert.ToDecimal(row["VienTruongKN"]),
                            Vu2_DanSu_ChanhAnKN = Convert.ToDecimal(row["ChanhAnKN"]);
                    ltr_Vu2_DanSu_VienTruongKN.Text = Vu2_DanSu_VienTruongKN.ToString("#,0.##", cul);
                    ltr_Vu2_DanSu_ChanhAnKN.Text = Vu2_DanSu_ChanhAnKN.ToString("#,0.##", cul);
                    ltr_Vu2_DanSu_DaXetXuGDT.Text = Convert.ToDecimal(row["DaXetXuGDT"]).ToString("#,0.##", cul);
                    if (Vu2_DanSu_VienTruongKN + Vu2_DanSu_ChanhAnKN > 0)
                    {
                        ltr_Vu2_DanSu_TyLe.Text = Math.Round((Convert.ToDecimal(row["DaXetXuGDT"]) / (Vu2_DanSu_VienTruongKN + Vu2_DanSu_ChanhAnKN) * 100), MidpointRounding.AwayFromZero).ToString("#,0.##", cul);
                    }
                    ltr_Vu2_DanSu_ConLai.Text = Convert.ToDecimal(row["ChuaXetXuGDT"]).ToString("#,0.##", cul);
                    ltr_Vu2_DanSu_QuaHanLuatDinh.Text = Convert.ToDecimal(row["QuaHanLuatDinh"]).ToString("#,0.##", cul);
                    ltr_Vu2_DanSu_RutKN.Text = Convert.ToDecimal(row["RutKN"]).ToString("#,0.##", cul);
                    ltr_Vu2_DanSu_KoChapNhanKNCuaVT.Text = Convert.ToDecimal(row["KoChapNhanKNCuaVT"]).ToString("#,0.##", cul);
                    ltr_Vu2_DanSu_HuyBanAn.Text = Convert.ToDecimal(row["HuyBanAn"]).ToString("#,0.##", cul);
                }
                #endregion
                #region Vụ GĐKT II -- Kinh doanh thương mại
                tbl = null;
                cache_name = "cache_GSTP_Page2_GDT_Vu2_AKT" + DonViID;
                if (Cache[cache_name] == null)
                {
                    prm = new OracleParameter[]
                    {
                    new OracleParameter("curr_loaian",AnKinhTe),
                    new OracleParameter("curr_toaanid",DonViID),
                    new OracleParameter("curr_vu_gdkt",Vu2),
                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
                    tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_ThongKeChung_TheoAn", prm);
                    Cache.Add(cache_name, tbl, null, DateTime.Now.AddMinutes(720), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
                }
                else
                {
                    tbl = (DataTable)Cache[cache_name];
                }
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    DataRow row = tbl.Rows[0];
                    #region Cộng dồn vào biến tổng
                    Tong_DonTrung = Tong_DonTrung + Convert.ToDecimal(row["DonTrung"]);
                    Tong_DonMoi = Tong_DonMoi + Convert.ToDecimal(row["DonMoi"]);
                    Tong_DaGiaiQuyet = Tong_DaGiaiQuyet + Convert.ToDecimal(row["DaGiaiQuyet"]);
                    Tong_ChuaGiaiQuyet = Tong_ChuaGiaiQuyet + Convert.ToDecimal(row["ChuaGiaiQuyet"]);
                    Tong_AnThoiHieu = Tong_AnThoiHieu + Convert.ToDecimal(row["AnThoiHieu"]);
                    decimal Vu2_KinhTe_VienTruongKN = Convert.ToDecimal(row["VienTruongKN"]),
                            Vu2_KinhTe_ChanhAnKN = Convert.ToDecimal(row["ChanhAnKN"]);
                    Tong_VienTruongKN = Tong_VienTruongKN + Vu2_KinhTe_VienTruongKN;
                    Tong_ChanhAnKN = Tong_ChanhAnKN + Vu2_KinhTe_ChanhAnKN;
                    Tong_DaXetXuGDT = Tong_DaXetXuGDT + Convert.ToDecimal(row["DaXetXuGDT"]);
                    Tong_ConLai = Tong_ConLai + Convert.ToDecimal(row["ChuaXetXuGDT"]);
                    Tong_QuaHanLuatDinh = Tong_QuaHanLuatDinh + Convert.ToDecimal(row["QuaHanLuatDinh"]);
                    Tong_RutKN = Tong_RutKN + Convert.ToDecimal(row["RutKN"]);
                    Tong_KoChapNhanKNCuaVT = Tong_KoChapNhanKNCuaVT + Convert.ToDecimal(row["KoChapNhanKNCuaVT"]);
                    Tong_HuyBanAn = Tong_HuyBanAn + Convert.ToDecimal(row["HuyBanAn"]);
                    #endregion
                    ltr_Vu2_KinhTe_DonTrung.Text = Convert.ToDecimal(row["DonTrung"]).ToString("#,0.##", cul);
                    ltr_Vu2_KinhTe_DonMoi.Text = Convert.ToDecimal(row["DonMoi"]).ToString("#,0.##", cul);
                    ltr_Vu2_KinhTe_DaGiaiQuyet.Text = Convert.ToDecimal(row["DaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_Vu2_KinhTe_ChuaGiaiQuyet.Text = Convert.ToDecimal(row["ChuaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_Vu2_KinhTe_AnThoiHieu.Text = Convert.ToDecimal(row["AnThoiHieu"]).ToString("#,0.##", cul);
                    ltr_Vu2_KinhTe_VienTruongKN.Text = Vu2_KinhTe_VienTruongKN.ToString("#,0.##", cul);
                    ltr_Vu2_KinhTe_ChanhAnKN.Text = Vu2_KinhTe_ChanhAnKN.ToString("#,0.##", cul);
                    ltr_Vu2_KinhTe_DaXetXuGDT.Text = Convert.ToDecimal(row["DaXetXuGDT"]).ToString("#,0.##", cul);
                    if (Vu2_KinhTe_VienTruongKN + Vu2_KinhTe_ChanhAnKN > 0)
                    {
                        ltr_Vu2_KinhTe_TyLe.Text = Math.Round((Convert.ToDecimal(row["DaXetXuGDT"]) / (Vu2_KinhTe_VienTruongKN + Vu2_KinhTe_ChanhAnKN) * 100), MidpointRounding.AwayFromZero).ToString("#,0.##", cul);
                    }
                    ltr_Vu2_KinhTe_ConLai.Text = Convert.ToDecimal(row["ChuaXetXuGDT"]).ToString("#,0.##", cul);
                    ltr_Vu2_KinhTe_QuaHanLuatDinh.Text = Convert.ToDecimal(row["QuaHanLuatDinh"]).ToString("#,0.##", cul);
                    ltr_Vu2_KinhTe_RutKN.Text = Convert.ToDecimal(row["RutKN"]).ToString("#,0.##", cul);
                    ltr_Vu2_KinhTe_KoChapNhanKNCuaVT.Text = Convert.ToDecimal(row["KoChapNhanKNCuaVT"]).ToString("#,0.##", cul);
                    ltr_Vu2_KinhTe_HuyBanAn.Text = Convert.ToDecimal(row["HuyBanAn"]).ToString("#,0.##", cul);
                }
                #endregion
                #region Vụ GĐKT II -- Tổng cộng
                ltr_Vu2_Tong_DonTrung.Text = Tong_DonTrung.ToString("#,0.##", cul);
                ltr_Vu2_Tong_DonMoi.Text = Tong_DonMoi.ToString("#,0.##", cul);
                ltr_Vu2_Tong_DaGiaiQuyet.Text = Tong_DaGiaiQuyet.ToString("#,0.##", cul);
                ltr_Vu2_Tong_ChuaGiaiQuyet.Text = Tong_ChuaGiaiQuyet.ToString("#,0.##", cul);
                ltr_Vu2_Tong_AnThoiHieu.Text = Tong_AnThoiHieu.ToString("#,0.##", cul);
                ltr_Vu2_Tong_VienTruongKN.Text = Tong_VienTruongKN.ToString("#,0.##", cul);
                ltr_Vu2_Tong_ChanhAnKN.Text = Tong_ChanhAnKN.ToString("#,0.##", cul);
                ltr_Vu2_Tong_DaXetXuGDT.Text = Tong_DaXetXuGDT.ToString("#,0.##", cul);
                if (Tong_VienTruongKN + Tong_ChanhAnKN > 0)
                {
                    ltr_Vu2_Tong_TyLe.Text = Math.Round((Tong_DaXetXuGDT / (Tong_VienTruongKN + Tong_ChanhAnKN) * 100), MidpointRounding.AwayFromZero).ToString("#,0.##", cul);
                }
                ltr_Vu2_Tong_ConLai.Text = Tong_ConLai.ToString("#,0.##", cul);
                ltr_Vu2_Tong_QuaHanLuatDinh.Text = Tong_QuaHanLuatDinh.ToString("#,0.##", cul);
                ltr_Vu2_Tong_RutKN.Text = Tong_RutKN.ToString("#,0.##", cul);
                ltr_Vu2_Tong_KoChapNhanKNCuaVT.Text = Tong_KoChapNhanKNCuaVT.ToString("#,0.##", cul);
                ltr_Vu2_Tong_HuyBanAn.Text = Tong_HuyBanAn.ToString("#,0.##", cul);
                #endregion
                #region reset lại giá trị các tổng
                Tong_DonTrung = Tong_DonMoi = Tong_DaGiaiQuyet = Tong_ChuaGiaiQuyet = Tong_AnThoiHieu = Tong_VienTruongKN = Tong_ChanhAnKN = 0;
                Tong_DaXetXuGDT = Tong_ConLai = Tong_QuaHanLuatDinh = Tong_RutKN = Tong_KoChapNhanKNCuaVT = Tong_HuyBanAn = 0;
                #endregion
                #region Vụ GĐKT III -- Hôn nhân và Gia đình
                tbl = null;
                cache_name = "cache_GSTP_Page2_GDT_Vu3_AHN" + DonViID;
                if (Cache[cache_name] == null)
                {
                    prm = new OracleParameter[]
                    {
                    new OracleParameter("curr_loaian",AnHNGD),
                    new OracleParameter("curr_toaanid",DonViID),
                    new OracleParameter("curr_vu_gdkt",Vu3),
                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
                    tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_ThongKeChung_TheoAn", prm);
                    Cache.Add(cache_name, tbl, null, DateTime.Now.AddMinutes(720), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
                }
                else
                {
                    tbl = (DataTable)Cache[cache_name];
                }
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    DataRow row = tbl.Rows[0];
                    #region Cộng dồn vào biến tổng
                    Tong_DonTrung = Tong_DonTrung + Convert.ToDecimal(row["DonTrung"]);
                    Tong_DonMoi = Tong_DonMoi + Convert.ToDecimal(row["DonMoi"]);
                    Tong_DaGiaiQuyet = Tong_DaGiaiQuyet + Convert.ToDecimal(row["DaGiaiQuyet"]);
                    Tong_ChuaGiaiQuyet = Tong_ChuaGiaiQuyet + Convert.ToDecimal(row["ChuaGiaiQuyet"]);
                    Tong_AnThoiHieu = Tong_AnThoiHieu + Convert.ToDecimal(row["AnThoiHieu"]);
                    decimal Vu2_KinhTe_VienTruongKN = Convert.ToDecimal(row["VienTruongKN"]),
                            Vu2_KinhTe_ChanhAnKN = Convert.ToDecimal(row["ChanhAnKN"]);
                    Tong_VienTruongKN = Tong_VienTruongKN + Vu2_KinhTe_VienTruongKN;
                    Tong_ChanhAnKN = Tong_ChanhAnKN + Vu2_KinhTe_ChanhAnKN;
                    Tong_DaXetXuGDT = Tong_DaXetXuGDT + Convert.ToDecimal(row["DaXetXuGDT"]);
                    Tong_ConLai = Tong_ConLai + Convert.ToDecimal(row["ChuaXetXuGDT"]);
                    Tong_QuaHanLuatDinh = Tong_QuaHanLuatDinh + Convert.ToDecimal(row["QuaHanLuatDinh"]);
                    Tong_RutKN = Tong_RutKN + Convert.ToDecimal(row["RutKN"]);
                    Tong_KoChapNhanKNCuaVT = Tong_KoChapNhanKNCuaVT + Convert.ToDecimal(row["KoChapNhanKNCuaVT"]);
                    Tong_HuyBanAn = Tong_HuyBanAn + Convert.ToDecimal(row["HuyBanAn"]);
                    #endregion
                    ltr_Vu3_HNGD_DonTrung.Text = Convert.ToDecimal(row["DonTrung"]).ToString("#,0.##", cul);
                    ltr_Vu3_HNGD_DonMoi.Text = Convert.ToDecimal(row["DonMoi"]).ToString("#,0.##", cul);
                    ltr_Vu3_HNGD_DaGiaiQuyet.Text = Convert.ToDecimal(row["DaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_Vu3_HNGD_ChuaGiaiQuyet.Text = Convert.ToDecimal(row["ChuaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_Vu3_HNGD_AnThoiHieu.Text = Convert.ToDecimal(row["AnThoiHieu"]).ToString("#,0.##", cul);
                    decimal Vu3_HNGD_VienTruongKN = Convert.ToDecimal(row["VienTruongKN"]),
                            Vu3_HNGD_ChanhAnKN = Convert.ToDecimal(row["ChanhAnKN"]);
                    ltr_Vu3_HNGD_VienTruongKN.Text = Vu3_HNGD_VienTruongKN.ToString("#,0.##", cul);
                    ltr_Vu3_HNGD_ChanhAnKN.Text = Vu3_HNGD_ChanhAnKN.ToString("#,0.##", cul);
                    ltr_Vu3_HNGD_DaXetXuGDT.Text = Convert.ToDecimal(row["DaXetXuGDT"]).ToString("#,0.##", cul);
                    if (Vu3_HNGD_VienTruongKN + Vu3_HNGD_ChanhAnKN > 0)
                    {
                        ltr_Vu3_HNGD_TyLe.Text = Math.Round((Convert.ToDecimal(row["DaXetXuGDT"]) / (Vu3_HNGD_VienTruongKN + Vu3_HNGD_ChanhAnKN) * 100), MidpointRounding.AwayFromZero).ToString("#,0.##", cul);
                    }
                    ltr_Vu3_HNGD_ConLai.Text = Convert.ToDecimal(row["ChuaXetXuGDT"]).ToString("#,0.##", cul);
                    ltr_Vu3_HNGD_QuaHanLuatDinh.Text = Convert.ToDecimal(row["QuaHanLuatDinh"]).ToString("#,0.##", cul);
                    ltr_Vu3_HNGD_RutKN.Text = Convert.ToDecimal(row["RutKN"]).ToString("#,0.##", cul);
                    ltr_Vu3_HNGD_KoChapNhanKNCuaVT.Text = Convert.ToDecimal(row["KoChapNhanKNCuaVT"]).ToString("#,0.##", cul);
                    ltr_Vu3_HNGD_HuyBanAn.Text = Convert.ToDecimal(row["HuyBanAn"]).ToString("#,0.##", cul);
                }
                #endregion
                #region Vụ GĐKT III -- Hành chính
                tbl = null;
                cache_name = "cache_GSTP_Page2_GDT_Vu3_AHC" + DonViID;
                if (Cache[cache_name] == null)
                {
                    prm = new OracleParameter[]
                    {
                    new OracleParameter("curr_loaian",AnHanhChinh),
                    new OracleParameter("curr_toaanid",DonViID),
                    new OracleParameter("curr_vu_gdkt",Vu3),
                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
                    tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_ThongKeChung_TheoAn", prm);
                    Cache.Add(cache_name, tbl, null, DateTime.Now.AddMinutes(720), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
                }
                else
                {
                    tbl = (DataTable)Cache[cache_name];
                }
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    DataRow row = tbl.Rows[0];
                    #region Cộng dồn vào biến tổng
                    Tong_DonTrung = Tong_DonTrung + Convert.ToDecimal(row["DonTrung"]);
                    Tong_DonMoi = Tong_DonMoi + Convert.ToDecimal(row["DonMoi"]);
                    Tong_DaGiaiQuyet = Tong_DaGiaiQuyet + Convert.ToDecimal(row["DaGiaiQuyet"]);
                    Tong_ChuaGiaiQuyet = Tong_ChuaGiaiQuyet + Convert.ToDecimal(row["ChuaGiaiQuyet"]);
                    Tong_AnThoiHieu = Tong_AnThoiHieu + Convert.ToDecimal(row["AnThoiHieu"]);
                    decimal Vu2_KinhTe_VienTruongKN = Convert.ToDecimal(row["VienTruongKN"]),
                            Vu2_KinhTe_ChanhAnKN = Convert.ToDecimal(row["ChanhAnKN"]);
                    Tong_VienTruongKN = Tong_VienTruongKN + Vu2_KinhTe_VienTruongKN;
                    Tong_ChanhAnKN = Tong_ChanhAnKN + Vu2_KinhTe_ChanhAnKN;
                    Tong_DaXetXuGDT = Tong_DaXetXuGDT + Convert.ToDecimal(row["DaXetXuGDT"]);
                    Tong_ConLai = Tong_ConLai + Convert.ToDecimal(row["ChuaXetXuGDT"]);
                    Tong_QuaHanLuatDinh = Tong_QuaHanLuatDinh + Convert.ToDecimal(row["QuaHanLuatDinh"]);
                    Tong_RutKN = Tong_RutKN + Convert.ToDecimal(row["RutKN"]);
                    Tong_KoChapNhanKNCuaVT = Tong_KoChapNhanKNCuaVT + Convert.ToDecimal(row["KoChapNhanKNCuaVT"]);
                    Tong_HuyBanAn = Tong_HuyBanAn + Convert.ToDecimal(row["HuyBanAn"]);
                    #endregion
                    ltr_Vu3_HanhChinh_DonTrung.Text = Convert.ToDecimal(row["DonTrung"]).ToString("#,0.##", cul);
                    ltr_Vu3_HanhChinh_DonMoi.Text = Convert.ToDecimal(row["DonMoi"]).ToString("#,0.##", cul);
                    ltr_Vu3_HanhChinh_DaGiaiQuyet.Text = Convert.ToDecimal(row["DaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_Vu3_HanhChinh_ChuaGiaiQuyet.Text = Convert.ToDecimal(row["ChuaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_Vu3_HanhChinh_AnThoiHieu.Text = Convert.ToDecimal(row["AnThoiHieu"]).ToString("#,0.##", cul);
                    decimal Vu3_HanhChinh_VienTruongKN = Convert.ToDecimal(row["VienTruongKN"]),
                            Vu3_HanhChinh_ChanhAnKN = Convert.ToDecimal(row["ChanhAnKN"]);
                    ltr_Vu3_HanhChinh_VienTruongKN.Text = Vu3_HanhChinh_VienTruongKN.ToString("#,0.##", cul);
                    ltr_Vu3_HanhChinh_ChanhAnKN.Text = Vu3_HanhChinh_ChanhAnKN.ToString("#,0.##", cul);
                    ltr_Vu3_HanhChinh_DaXetXuGDT.Text = Convert.ToDecimal(row["DaXetXuGDT"]).ToString("#,0.##", cul);
                    if (Vu3_HanhChinh_VienTruongKN + Vu3_HanhChinh_ChanhAnKN > 0)
                    {
                        ltr_Vu3_HanhChinh_TyLe.Text = Math.Round((Convert.ToDecimal(row["DaXetXuGDT"]) / (Vu3_HanhChinh_VienTruongKN + Vu3_HanhChinh_ChanhAnKN) * 100), MidpointRounding.AwayFromZero).ToString("#,0.##", cul);
                    }
                    ltr_Vu3_HanhChinh_ConLai.Text = Convert.ToDecimal(row["ChuaXetXuGDT"]).ToString("#,0.##", cul);
                    ltr_Vu3_HanhChinh_QuaHanLuatDinh.Text = Convert.ToDecimal(row["QuaHanLuatDinh"]).ToString("#,0.##", cul);
                    ltr_Vu3_HanhChinh_RutKN.Text = Convert.ToDecimal(row["RutKN"]).ToString("#,0.##", cul);
                    ltr_Vu3_HanhChinh_KoChapNhanKNCuaVT.Text = Convert.ToDecimal(row["KoChapNhanKNCuaVT"]).ToString("#,0.##", cul);
                    ltr_Vu3_HanhChinh_HuyBanAn.Text = Convert.ToDecimal(row["HuyBanAn"]).ToString("#,0.##", cul);
                }
                #endregion
                #region Vụ GĐKT III -- Lao động
                tbl = null;
                cache_name = "cache_GSTP_Page2_GDT_Vu3_ALD" + DonViID;
                if (Cache[cache_name] == null)
                {
                    prm = new OracleParameter[]
                    {
                    new OracleParameter("curr_loaian",AnLaoDong),
                    new OracleParameter("curr_toaanid",DonViID),
                    new OracleParameter("curr_vu_gdkt",Vu3),
                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
                    tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_ThongKeChung_TheoAn", prm);
                    Cache.Add(cache_name, tbl, null, DateTime.Now.AddMinutes(720), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
                }
                else
                {
                    tbl = (DataTable)Cache[cache_name];
                }
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    DataRow row = tbl.Rows[0];
                    #region Cộng dồn vào biến tổng
                    Tong_DonTrung = Tong_DonTrung + Convert.ToDecimal(row["DonTrung"]);
                    Tong_DonMoi = Tong_DonMoi + Convert.ToDecimal(row["DonMoi"]);
                    Tong_DaGiaiQuyet = Tong_DaGiaiQuyet + Convert.ToDecimal(row["DaGiaiQuyet"]);
                    Tong_ChuaGiaiQuyet = Tong_ChuaGiaiQuyet + Convert.ToDecimal(row["ChuaGiaiQuyet"]);
                    Tong_AnThoiHieu = Tong_AnThoiHieu + Convert.ToDecimal(row["AnThoiHieu"]);
                    decimal Vu2_KinhTe_VienTruongKN = Convert.ToDecimal(row["VienTruongKN"]),
                            Vu2_KinhTe_ChanhAnKN = Convert.ToDecimal(row["ChanhAnKN"]);
                    Tong_VienTruongKN = Tong_VienTruongKN + Vu2_KinhTe_VienTruongKN;
                    Tong_ChanhAnKN = Tong_ChanhAnKN + Vu2_KinhTe_ChanhAnKN;
                    Tong_DaXetXuGDT = Tong_DaXetXuGDT + Convert.ToDecimal(row["DaXetXuGDT"]);
                    Tong_ConLai = Tong_ConLai + Convert.ToDecimal(row["ChuaXetXuGDT"]);
                    Tong_QuaHanLuatDinh = Tong_QuaHanLuatDinh + Convert.ToDecimal(row["QuaHanLuatDinh"]);
                    Tong_RutKN = Tong_RutKN + Convert.ToDecimal(row["RutKN"]);
                    Tong_KoChapNhanKNCuaVT = Tong_KoChapNhanKNCuaVT + Convert.ToDecimal(row["KoChapNhanKNCuaVT"]);
                    Tong_HuyBanAn = Tong_HuyBanAn + Convert.ToDecimal(row["HuyBanAn"]);
                    #endregion
                    ltr_Vu3_LaoDong_DonTrung.Text = Convert.ToDecimal(row["DonTrung"]).ToString("#,0.##", cul);
                    ltr_Vu3_LaoDong_DonMoi.Text = Convert.ToDecimal(row["DonMoi"]).ToString("#,0.##", cul);
                    ltr_Vu3_LaoDong_DaGiaiQuyet.Text = Convert.ToDecimal(row["DaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_Vu3_LaoDong_ChuaGiaiQuyet.Text = Convert.ToDecimal(row["ChuaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_Vu3_LaoDong_AnThoiHieu.Text = Convert.ToDecimal(row["AnThoiHieu"]).ToString("#,0.##", cul);
                    decimal Vu3_LaoDong_VienTruongKN = Convert.ToDecimal(row["VienTruongKN"]),
                            Vu3_LaoDong_ChanhAnKN = Convert.ToDecimal(row["ChanhAnKN"]);
                    ltr_Vu3_LaoDong_VienTruongKN.Text = Vu3_LaoDong_VienTruongKN.ToString("#,0.##", cul);
                    ltr_Vu3_LaoDong_ChanhAnKN.Text = Vu3_LaoDong_ChanhAnKN.ToString("#,0.##", cul);
                    ltr_Vu3_LaoDong_DaXetXuGDT.Text = Convert.ToDecimal(row["DaXetXuGDT"]).ToString("#,0.##", cul);
                    if (Vu3_LaoDong_VienTruongKN + Vu3_LaoDong_ChanhAnKN > 0)
                    {
                        ltr_Vu3_LaoDong_TyLe.Text = Math.Round((Convert.ToDecimal(row["DaXetXuGDT"]) / (Vu3_LaoDong_VienTruongKN + Vu3_LaoDong_ChanhAnKN) * 100), MidpointRounding.AwayFromZero).ToString("#,0.##", cul);
                    }
                    ltr_Vu3_LaoDong_ConLai.Text = Convert.ToDecimal(row["ChuaXetXuGDT"]).ToString("#,0.##", cul);
                    ltr_Vu3_LaoDong_QuaHanLuatDinh.Text = Convert.ToDecimal(row["QuaHanLuatDinh"]).ToString("#,0.##", cul);
                    ltr_Vu3_LaoDong_RutKN.Text = Convert.ToDecimal(row["RutKN"]).ToString("#,0.##", cul);
                    ltr_Vu3_LaoDong_KoChapNhanKNCuaVT.Text = Convert.ToDecimal(row["KoChapNhanKNCuaVT"]).ToString("#,0.##", cul);
                    ltr_Vu3_LaoDong_HuyBanAn.Text = Convert.ToDecimal(row["HuyBanAn"]).ToString("#,0.##", cul);
                }
                #endregion
                #region Vụ GĐKT III -- Tổng cộng
                ltr_Vu3_Tong_DonTrung.Text = Tong_DonTrung.ToString("#,0.##", cul);
                ltr_Vu3_Tong_DonMoi.Text = Tong_DonMoi.ToString("#,0.##", cul);
                ltr_Vu3_Tong_DaGiaiQuyet.Text = Tong_DaGiaiQuyet.ToString("#,0.##", cul);
                ltr_Vu3_Tong_ChuaGiaiQuyet.Text = Tong_ChuaGiaiQuyet.ToString("#,0.##", cul);
                ltr_Vu3_Tong_AnThoiHieu.Text = Tong_AnThoiHieu.ToString("#,0.##", cul);
                ltr_Vu3_Tong_VienTruongKN.Text = Tong_VienTruongKN.ToString("#,0.##", cul);
                ltr_Vu3_Tong_ChanhAnKN.Text = Tong_ChanhAnKN.ToString("#,0.##", cul);
                ltr_Vu3_Tong_DaXetXuGDT.Text = Tong_DaXetXuGDT.ToString("#,0.##", cul);
                if (Tong_VienTruongKN + Tong_ChanhAnKN > 0)
                {
                    ltr_Vu3_Tong_TyLe.Text = Math.Round((Tong_DaXetXuGDT / (Tong_VienTruongKN + Tong_ChanhAnKN) * 100), MidpointRounding.AwayFromZero).ToString("#,0.##", cul);
                }
                ltr_Vu3_Tong_ConLai.Text = Tong_ConLai.ToString("#,0.##", cul);
                ltr_Vu3_Tong_QuaHanLuatDinh.Text = Tong_QuaHanLuatDinh.ToString("#,0.##", cul);
                ltr_Vu3_Tong_RutKN.Text = Tong_RutKN.ToString("#,0.##", cul);
                ltr_Vu3_Tong_KoChapNhanKNCuaVT.Text = Tong_KoChapNhanKNCuaVT.ToString("#,0.##", cul);
                ltr_Vu3_Tong_HuyBanAn.Text = Tong_HuyBanAn.ToString("#,0.##", cul);
                #endregion
            }
            else if (DonViID == 0 || TenToa == "cấp cao tại hà nội")
            {
                ta = dt.DM_TOAAN.Where(x => x.LOAITOA == "CAPCAO" && x.TEN.ToUpper().Contains("HÀ NỘI")).FirstOrDefault();
                if (ta != null)
                {
                    ToaCapCao_HaNoi = ta.ID;
                }
                #region reset lại giá trị các tổng
                Tong_DonTrung = Tong_DonMoi = Tong_DaGiaiQuyet = Tong_ChuaGiaiQuyet = Tong_AnThoiHieu = Tong_VienTruongKN = Tong_ChanhAnKN = 0;
                Tong_DaXetXuGDT = Tong_ConLai = Tong_QuaHanLuatDinh = Tong_RutKN = Tong_KoChapNhanKNCuaVT = Tong_HuyBanAn = 0;
                #endregion
                #region TAND CC tại Hà Nội -- Hình sự
                tbl = null;
                cache_name = "cache_GSTP_Page2_GDT_CC_HaNoi_AHS" + DonViID;
                if (Cache[cache_name] == null)
                {
                    prm = new OracleParameter[]
                    {
                    new OracleParameter("curr_loaian",AnHinhSu),
                    new OracleParameter("curr_toaanid",ToaCapCao_HaNoi),
                    new OracleParameter("curr_vu_gdkt",Vu_GDT),
                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
                    tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_ThongKeChung_TheoAn", prm);
                    Cache.Add(cache_name, tbl, null, DateTime.Now.AddMinutes(720), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
                }
                else
                {
                    tbl = (DataTable)Cache[cache_name];
                }
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    DataRow row = tbl.Rows[0];
                    #region Cộng dồn vào biến tổng
                    Tong_DonTrung = Tong_DonTrung + Convert.ToDecimal(row["DonTrung"]);
                    Tong_DonMoi = Tong_DonMoi + Convert.ToDecimal(row["DonMoi"]);
                    Tong_DaGiaiQuyet = Tong_DaGiaiQuyet + Convert.ToDecimal(row["DaGiaiQuyet"]);
                    Tong_ChuaGiaiQuyet = Tong_ChuaGiaiQuyet + Convert.ToDecimal(row["ChuaGiaiQuyet"]);
                    Tong_AnThoiHieu = Tong_AnThoiHieu + Convert.ToDecimal(row["AnThoiHieu"]);
                    decimal Vu2_KinhTe_VienTruongKN = Convert.ToDecimal(row["VienTruongKN"]),
                            Vu2_KinhTe_ChanhAnKN = Convert.ToDecimal(row["ChanhAnKN"]);
                    Tong_VienTruongKN = Tong_VienTruongKN + Vu2_KinhTe_VienTruongKN;
                    Tong_ChanhAnKN = Tong_ChanhAnKN + Vu2_KinhTe_ChanhAnKN;
                    Tong_DaXetXuGDT = Tong_DaXetXuGDT + Convert.ToDecimal(row["DaXetXuGDT"]);
                    Tong_ConLai = Tong_ConLai + Convert.ToDecimal(row["ChuaXetXuGDT"]);
                    Tong_QuaHanLuatDinh = Tong_QuaHanLuatDinh + Convert.ToDecimal(row["QuaHanLuatDinh"]);
                    Tong_RutKN = Tong_RutKN + Convert.ToDecimal(row["RutKN"]);
                    Tong_KoChapNhanKNCuaVT = Tong_KoChapNhanKNCuaVT + Convert.ToDecimal(row["KoChapNhanKNCuaVT"]);
                    Tong_HuyBanAn = Tong_HuyBanAn + Convert.ToDecimal(row["HuyBanAn"]);
                    #endregion
                    ltr_CCHaNoi_HinhSu_DonTrung.Text = Convert.ToDecimal(row["DonTrung"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_HinhSu_DonMoi.Text = Convert.ToDecimal(row["DonMoi"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_HinhSu_DaGiaiQuyet.Text = Convert.ToDecimal(row["DaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_HinhSu_ChuaGiaiQuyet.Text = Convert.ToDecimal(row["ChuaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_HinhSu_AnThoiHieu.Text = Convert.ToDecimal(row["AnThoiHieu"]).ToString("#,0.##", cul);
                    decimal CCHaNoi_HinhSu_VienTruongKN = Convert.ToDecimal(row["VienTruongKN"]),
                            CCHaNoi_HinhSu_ChanhAnKN = Convert.ToDecimal(row["ChanhAnKN"]);
                    ltr_CCHaNoi_HinhSu_VienTruongKN.Text = CCHaNoi_HinhSu_VienTruongKN.ToString("#,0.##", cul);
                    ltr_CCHaNoi_HinhSu_ChanhAnKN.Text = CCHaNoi_HinhSu_ChanhAnKN.ToString("#,0.##", cul);
                    ltr_CCHaNoi_HinhSu_DaXetXuGDT.Text = Convert.ToDecimal(row["DaXetXuGDT"]).ToString("#,0.##", cul);
                    if (CCHaNoi_HinhSu_VienTruongKN + CCHaNoi_HinhSu_ChanhAnKN > 0)
                    {
                        ltr_CCHaNoi_HinhSu_TyLe.Text = Math.Round((Convert.ToDecimal(row["DaXetXuGDT"]) / (CCHaNoi_HinhSu_VienTruongKN + CCHaNoi_HinhSu_ChanhAnKN) * 100), MidpointRounding.AwayFromZero).ToString("#,0.##", cul);
                    }
                    ltr_CCHaNoi_HinhSu_ConLai.Text = Convert.ToDecimal(row["ChuaXetXuGDT"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_HinhSu_QuaHanLuatDinh.Text = Convert.ToDecimal(row["QuaHanLuatDinh"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_HinhSu_RutKN.Text = Convert.ToDecimal(row["RutKN"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_HinhSu_KoChapNhanKNCuaVT.Text = Convert.ToDecimal(row["KoChapNhanKNCuaVT"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_HinhSu_HuyBanAn.Text = Convert.ToDecimal(row["HuyBanAn"]).ToString("#,0.##", cul);
                }
                #endregion
                #region TAND CC tại Hà Nội -- Dân sự
                tbl = null;
                cache_name = "cache_GSTP_Page2_GDT_CC_HaNoi_ADS" + DonViID;
                if (Cache[cache_name] == null)
                {
                    prm = new OracleParameter[]
                    {
                    new OracleParameter("curr_loaian",AnDanSu),
                    new OracleParameter("curr_toaanid",ToaCapCao_HaNoi),
                    new OracleParameter("curr_vu_gdkt",Vu_GDT),
                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
                    tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_ThongKeChung_TheoAn", prm);
                    Cache.Add(cache_name, tbl, null, DateTime.Now.AddMinutes(720), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
                }
                else
                {
                    tbl = (DataTable)Cache[cache_name];
                }
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    DataRow row = tbl.Rows[0];
                    #region Cộng dồn vào biến tổng
                    Tong_DonTrung = Tong_DonTrung + Convert.ToDecimal(row["DonTrung"]);
                    Tong_DonMoi = Tong_DonMoi + Convert.ToDecimal(row["DonMoi"]);
                    Tong_DaGiaiQuyet = Tong_DaGiaiQuyet + Convert.ToDecimal(row["DaGiaiQuyet"]);
                    Tong_ChuaGiaiQuyet = Tong_ChuaGiaiQuyet + Convert.ToDecimal(row["ChuaGiaiQuyet"]);
                    Tong_AnThoiHieu = Tong_AnThoiHieu + Convert.ToDecimal(row["AnThoiHieu"]);
                    decimal Vu2_KinhTe_VienTruongKN = Convert.ToDecimal(row["VienTruongKN"]),
                            Vu2_KinhTe_ChanhAnKN = Convert.ToDecimal(row["ChanhAnKN"]);
                    Tong_VienTruongKN = Tong_VienTruongKN + Vu2_KinhTe_VienTruongKN;
                    Tong_ChanhAnKN = Tong_ChanhAnKN + Vu2_KinhTe_ChanhAnKN;
                    Tong_DaXetXuGDT = Tong_DaXetXuGDT + Convert.ToDecimal(row["DaXetXuGDT"]);
                    Tong_ConLai = Tong_ConLai + Convert.ToDecimal(row["ChuaXetXuGDT"]);
                    Tong_QuaHanLuatDinh = Tong_QuaHanLuatDinh + Convert.ToDecimal(row["QuaHanLuatDinh"]);
                    Tong_RutKN = Tong_RutKN + Convert.ToDecimal(row["RutKN"]);
                    Tong_KoChapNhanKNCuaVT = Tong_KoChapNhanKNCuaVT + Convert.ToDecimal(row["KoChapNhanKNCuaVT"]);
                    Tong_HuyBanAn = Tong_HuyBanAn + Convert.ToDecimal(row["HuyBanAn"]);
                    #endregion
                    ltr_CCHaNoi_DanSu_DonTrung.Text = Convert.ToDecimal(row["DonTrung"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_DanSu_DonMoi.Text = Convert.ToDecimal(row["DonMoi"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_DanSu_DaGiaiQuyet.Text = Convert.ToDecimal(row["DaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_DanSu_ChuaGiaiQuyet.Text = Convert.ToDecimal(row["ChuaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_DanSu_AnThoiHieu.Text = Convert.ToDecimal(row["AnThoiHieu"]).ToString("#,0.##", cul);
                    decimal CCHaNoi_DanSu_VienTruongKN = Convert.ToDecimal(row["VienTruongKN"]),
                            CCHaNoi_DanSu_ChanhAnKN = Convert.ToDecimal(row["ChanhAnKN"]);
                    ltr_CCHaNoi_DanSu_VienTruongKN.Text = CCHaNoi_DanSu_VienTruongKN.ToString("#,0.##", cul);
                    ltr_CCHaNoi_DanSu_ChanhAnKN.Text = CCHaNoi_DanSu_ChanhAnKN.ToString("#,0.##", cul);
                    ltr_CCHaNoi_DanSu_DaXetXuGDT.Text = Convert.ToDecimal(row["DaXetXuGDT"]).ToString("#,0.##", cul);
                    if (CCHaNoi_DanSu_VienTruongKN + CCHaNoi_DanSu_ChanhAnKN > 0)
                    {
                        ltr_CCHaNoi_DanSu_TyLe.Text = Math.Round((Convert.ToDecimal(row["DaXetXuGDT"]) / (CCHaNoi_DanSu_VienTruongKN + CCHaNoi_DanSu_ChanhAnKN) * 100), MidpointRounding.AwayFromZero).ToString("#,0.##", cul);
                    }
                    ltr_CCHaNoi_DanSu_ConLai.Text = Convert.ToDecimal(row["ChuaXetXuGDT"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_DanSu_QuaHanLuatDinh.Text = Convert.ToDecimal(row["QuaHanLuatDinh"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_DanSu_RutKN.Text = Convert.ToDecimal(row["RutKN"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_DanSu_KoChapNhanKNCuaVT.Text = Convert.ToDecimal(row["KoChapNhanKNCuaVT"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_DanSu_HuyBanAn.Text = Convert.ToDecimal(row["HuyBanAn"]).ToString("#,0.##", cul);
                }
                #endregion
                #region TAND CC tại Hà Nội -- Kinh doanh thương mại
                tbl = null;
                cache_name = "cache_GSTP_Page2_GDT_CC_HaNoi_AKT" + DonViID;
                if (Cache[cache_name] == null)
                {
                    prm = new OracleParameter[]
                    {
                    new OracleParameter("curr_loaian",AnKinhTe),
                    new OracleParameter("curr_toaanid",ToaCapCao_HaNoi),
                    new OracleParameter("curr_vu_gdkt",Vu_GDT),
                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
                    tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_ThongKeChung_TheoAn", prm);
                    Cache.Add(cache_name, tbl, null, DateTime.Now.AddMinutes(720), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
                }
                else
                {
                    tbl = (DataTable)Cache[cache_name];
                }
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    DataRow row = tbl.Rows[0];
                    #region Cộng dồn vào biến tổng
                    Tong_DonTrung = Tong_DonTrung + Convert.ToDecimal(row["DonTrung"]);
                    Tong_DonMoi = Tong_DonMoi + Convert.ToDecimal(row["DonMoi"]);
                    Tong_DaGiaiQuyet = Tong_DaGiaiQuyet + Convert.ToDecimal(row["DaGiaiQuyet"]);
                    Tong_ChuaGiaiQuyet = Tong_ChuaGiaiQuyet + Convert.ToDecimal(row["ChuaGiaiQuyet"]);
                    Tong_AnThoiHieu = Tong_AnThoiHieu + Convert.ToDecimal(row["AnThoiHieu"]);
                    decimal Vu2_KinhTe_VienTruongKN = Convert.ToDecimal(row["VienTruongKN"]),
                            Vu2_KinhTe_ChanhAnKN = Convert.ToDecimal(row["ChanhAnKN"]);
                    Tong_VienTruongKN = Tong_VienTruongKN + Vu2_KinhTe_VienTruongKN;
                    Tong_ChanhAnKN = Tong_ChanhAnKN + Vu2_KinhTe_ChanhAnKN;
                    Tong_DaXetXuGDT = Tong_DaXetXuGDT + Convert.ToDecimal(row["DaXetXuGDT"]);
                    Tong_ConLai = Tong_ConLai + Convert.ToDecimal(row["ChuaXetXuGDT"]);
                    Tong_QuaHanLuatDinh = Tong_QuaHanLuatDinh + Convert.ToDecimal(row["QuaHanLuatDinh"]);
                    Tong_RutKN = Tong_RutKN + Convert.ToDecimal(row["RutKN"]);
                    Tong_KoChapNhanKNCuaVT = Tong_KoChapNhanKNCuaVT + Convert.ToDecimal(row["KoChapNhanKNCuaVT"]);
                    Tong_HuyBanAn = Tong_HuyBanAn + Convert.ToDecimal(row["HuyBanAn"]);
                    #endregion
                    ltr_CCHaNoi_KinhTe_DonTrung.Text = Convert.ToDecimal(row["DonTrung"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_KinhTe_DonMoi.Text = Convert.ToDecimal(row["DonMoi"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_KinhTe_DaGiaiQuyet.Text = Convert.ToDecimal(row["DaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_KinhTe_ChuaGiaiQuyet.Text = Convert.ToDecimal(row["ChuaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_KinhTe_AnThoiHieu.Text = Convert.ToDecimal(row["AnThoiHieu"]).ToString("#,0.##", cul);
                    decimal CCHaNoi_KinhTe_VienTruongKN = Convert.ToDecimal(row["VienTruongKN"]),
                            CCHaNoi_KinhTe_ChanhAnKN = Convert.ToDecimal(row["ChanhAnKN"]);
                    ltr_CCHaNoi_KinhTe_VienTruongKN.Text = CCHaNoi_KinhTe_VienTruongKN.ToString("#,0.##", cul);
                    ltr_CCHaNoi_KinhTe_ChanhAnKN.Text = CCHaNoi_KinhTe_ChanhAnKN.ToString("#,0.##", cul);
                    ltr_CCHaNoi_KinhTe_DaXetXuGDT.Text = Convert.ToDecimal(row["DaXetXuGDT"]).ToString("#,0.##", cul);
                    if (CCHaNoi_KinhTe_VienTruongKN + CCHaNoi_KinhTe_ChanhAnKN > 0)
                    {
                        ltr_CCHaNoi_KinhTe_TyLe.Text = Math.Round((Convert.ToDecimal(row["DaXetXuGDT"]) / (CCHaNoi_KinhTe_VienTruongKN + CCHaNoi_KinhTe_ChanhAnKN) * 100), MidpointRounding.AwayFromZero).ToString("#,0.##", cul);
                    }
                    ltr_CCHaNoi_KinhTe_ConLai.Text = Convert.ToDecimal(row["ChuaXetXuGDT"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_KinhTe_QuaHanLuatDinh.Text = Convert.ToDecimal(row["QuaHanLuatDinh"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_KinhTe_RutKN.Text = Convert.ToDecimal(row["RutKN"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_KinhTe_KoChapNhanKNCuaVT.Text = Convert.ToDecimal(row["KoChapNhanKNCuaVT"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_KinhTe_HuyBanAn.Text = Convert.ToDecimal(row["HuyBanAn"]).ToString("#,0.##", cul);
                }
                #endregion
                #region TAND CC tại Hà Nội -- Hôn nhân và Gia đình
                tbl = null;
                cache_name = "cache_GSTP_Page2_GDT_CC_HaNoi_AHN" + DonViID;
                if (Cache[cache_name] == null)
                {
                    prm = new OracleParameter[]
                    {
                    new OracleParameter("curr_loaian",AnHNGD),
                    new OracleParameter("curr_toaanid",ToaCapCao_HaNoi),
                    new OracleParameter("curr_vu_gdkt",Vu_GDT),
                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
                    tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_ThongKeChung_TheoAn", prm);
                    Cache.Add(cache_name, tbl, null, DateTime.Now.AddMinutes(720), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
                }
                else
                {
                    tbl = (DataTable)Cache[cache_name];
                }
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    DataRow row = tbl.Rows[0];
                    #region Cộng dồn vào biến tổng
                    Tong_DonTrung = Tong_DonTrung + Convert.ToDecimal(row["DonTrung"]);
                    Tong_DonMoi = Tong_DonMoi + Convert.ToDecimal(row["DonMoi"]);
                    Tong_DaGiaiQuyet = Tong_DaGiaiQuyet + Convert.ToDecimal(row["DaGiaiQuyet"]);
                    Tong_ChuaGiaiQuyet = Tong_ChuaGiaiQuyet + Convert.ToDecimal(row["ChuaGiaiQuyet"]);
                    Tong_AnThoiHieu = Tong_AnThoiHieu + Convert.ToDecimal(row["AnThoiHieu"]);
                    decimal Vu2_KinhTe_VienTruongKN = Convert.ToDecimal(row["VienTruongKN"]),
                            Vu2_KinhTe_ChanhAnKN = Convert.ToDecimal(row["ChanhAnKN"]);
                    Tong_VienTruongKN = Tong_VienTruongKN + Vu2_KinhTe_VienTruongKN;
                    Tong_ChanhAnKN = Tong_ChanhAnKN + Vu2_KinhTe_ChanhAnKN;
                    Tong_DaXetXuGDT = Tong_DaXetXuGDT + Convert.ToDecimal(row["DaXetXuGDT"]);
                    Tong_ConLai = Tong_ConLai + Convert.ToDecimal(row["ChuaXetXuGDT"]);
                    Tong_QuaHanLuatDinh = Tong_QuaHanLuatDinh + Convert.ToDecimal(row["QuaHanLuatDinh"]);
                    Tong_RutKN = Tong_RutKN + Convert.ToDecimal(row["RutKN"]);
                    Tong_KoChapNhanKNCuaVT = Tong_KoChapNhanKNCuaVT + Convert.ToDecimal(row["KoChapNhanKNCuaVT"]);
                    Tong_HuyBanAn = Tong_HuyBanAn + Convert.ToDecimal(row["HuyBanAn"]);
                    #endregion
                    ltr_CCHaNoi_HNGD_DonTrung.Text = Convert.ToDecimal(row["DonTrung"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_HNGD_DonMoi.Text = Convert.ToDecimal(row["DonMoi"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_HNGD_DaGiaiQuyet.Text = Convert.ToDecimal(row["DaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_HNGD_ChuaGiaiQuyet.Text = Convert.ToDecimal(row["ChuaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_HNGD_AnThoiHieu.Text = Convert.ToDecimal(row["AnThoiHieu"]).ToString("#,0.##", cul);
                    decimal CCHaNoi_HNGD_VienTruongKN = Convert.ToDecimal(row["VienTruongKN"]),
                            CCHaNoi_HNGD_ChanhAnKN = Convert.ToDecimal(row["ChanhAnKN"]);
                    ltr_CCHaNoi_HNGD_VienTruongKN.Text = CCHaNoi_HNGD_VienTruongKN.ToString("#,0.##", cul);
                    ltr_CCHaNoi_HNGD_ChanhAnKN.Text = CCHaNoi_HNGD_ChanhAnKN.ToString("#,0.##", cul);
                    ltr_CCHaNoi_HNGD_DaXetXuGDT.Text = Convert.ToDecimal(row["DaXetXuGDT"]).ToString("#,0.##", cul);
                    if (CCHaNoi_HNGD_VienTruongKN + CCHaNoi_HNGD_ChanhAnKN > 0)
                    {
                        ltr_CCHaNoi_HNGD_TyLe.Text = Math.Round((Convert.ToDecimal(row["DaXetXuGDT"]) / (CCHaNoi_HNGD_VienTruongKN + CCHaNoi_HNGD_ChanhAnKN) * 100), MidpointRounding.AwayFromZero).ToString("#,0.##", cul);
                    }
                    ltr_CCHaNoi_HNGD_ConLai.Text = Convert.ToDecimal(row["ChuaXetXuGDT"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_HNGD_QuaHanLuatDinh.Text = Convert.ToDecimal(row["QuaHanLuatDinh"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_HNGD_RutKN.Text = Convert.ToDecimal(row["RutKN"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_HNGD_KoChapNhanKNCuaVT.Text = Convert.ToDecimal(row["KoChapNhanKNCuaVT"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_HNGD_HuyBanAn.Text = Convert.ToDecimal(row["HuyBanAn"]).ToString("#,0.##", cul);
                }
                #endregion
                #region TAND CC tại Hà Nội -- Hành chính
                tbl = null;
                cache_name = "cache_GSTP_Page2_GDT_CC_HaNoi_AHC" + DonViID;
                if (Cache[cache_name] == null)
                {
                    prm = new OracleParameter[]
                    {
                    new OracleParameter("curr_loaian",AnHanhChinh),
                    new OracleParameter("curr_toaanid",ToaCapCao_HaNoi),
                    new OracleParameter("curr_vu_gdkt",Vu_GDT),
                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
                    tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_ThongKeChung_TheoAn", prm);
                    Cache.Add(cache_name, tbl, null, DateTime.Now.AddMinutes(720), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
                }
                else
                {
                    tbl = (DataTable)Cache[cache_name];
                }
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    DataRow row = tbl.Rows[0];
                    #region Cộng dồn vào biến tổng
                    Tong_DonTrung = Tong_DonTrung + Convert.ToDecimal(row["DonTrung"]);
                    Tong_DonMoi = Tong_DonMoi + Convert.ToDecimal(row["DonMoi"]);
                    Tong_DaGiaiQuyet = Tong_DaGiaiQuyet + Convert.ToDecimal(row["DaGiaiQuyet"]);
                    Tong_ChuaGiaiQuyet = Tong_ChuaGiaiQuyet + Convert.ToDecimal(row["ChuaGiaiQuyet"]);
                    Tong_AnThoiHieu = Tong_AnThoiHieu + Convert.ToDecimal(row["AnThoiHieu"]);
                    decimal Vu2_KinhTe_VienTruongKN = Convert.ToDecimal(row["VienTruongKN"]),
                            Vu2_KinhTe_ChanhAnKN = Convert.ToDecimal(row["ChanhAnKN"]);
                    Tong_VienTruongKN = Tong_VienTruongKN + Vu2_KinhTe_VienTruongKN;
                    Tong_ChanhAnKN = Tong_ChanhAnKN + Vu2_KinhTe_ChanhAnKN;
                    Tong_DaXetXuGDT = Tong_DaXetXuGDT + Convert.ToDecimal(row["DaXetXuGDT"]);
                    Tong_ConLai = Tong_ConLai + Convert.ToDecimal(row["ChuaXetXuGDT"]);
                    Tong_QuaHanLuatDinh = Tong_QuaHanLuatDinh + Convert.ToDecimal(row["QuaHanLuatDinh"]);
                    Tong_RutKN = Tong_RutKN + Convert.ToDecimal(row["RutKN"]);
                    Tong_KoChapNhanKNCuaVT = Tong_KoChapNhanKNCuaVT + Convert.ToDecimal(row["KoChapNhanKNCuaVT"]);
                    Tong_HuyBanAn = Tong_HuyBanAn + Convert.ToDecimal(row["HuyBanAn"]);
                    #endregion
                    ltr_CCHaNoi_HanhChinh_DonTrung.Text = Convert.ToDecimal(row["DonTrung"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_HanhChinh_DonMoi.Text = Convert.ToDecimal(row["DonMoi"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_HanhChinh_DaGiaiQuyet.Text = Convert.ToDecimal(row["DaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_HanhChinh_ChuaGiaiQuyet.Text = Convert.ToDecimal(row["ChuaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_HanhChinh_AnThoiHieu.Text = Convert.ToDecimal(row["AnThoiHieu"]).ToString("#,0.##", cul);
                    decimal CCHaNoi_HanhChinh_VienTruongKN = Convert.ToDecimal(row["VienTruongKN"]),
                            CCHaNoi_HanhChinh_ChanhAnKN = Convert.ToDecimal(row["ChanhAnKN"]);
                    ltr_CCHaNoi_HanhChinh_VienTruongKN.Text = CCHaNoi_HanhChinh_VienTruongKN.ToString("#,0.##", cul);
                    ltr_CCHaNoi_HanhChinh_ChanhAnKN.Text = CCHaNoi_HanhChinh_ChanhAnKN.ToString("#,0.##", cul);
                    ltr_CCHaNoi_HanhChinh_DaXetXuGDT.Text = Convert.ToDecimal(row["DaXetXuGDT"]).ToString("#,0.##", cul);
                    if (CCHaNoi_HanhChinh_VienTruongKN + CCHaNoi_HanhChinh_ChanhAnKN > 0)
                    {
                        ltr_CCHaNoi_HanhChinh_TyLe.Text = Math.Round((Convert.ToDecimal(row["DaXetXuGDT"]) / (CCHaNoi_HanhChinh_VienTruongKN + CCHaNoi_HanhChinh_ChanhAnKN) * 100), MidpointRounding.AwayFromZero).ToString("#,0.##", cul);
                    }
                    ltr_CCHaNoi_HanhChinh_ConLai.Text = Convert.ToDecimal(row["ChuaXetXuGDT"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_HanhChinh_QuaHanLuatDinh.Text = Convert.ToDecimal(row["QuaHanLuatDinh"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_HanhChinh_RutKN.Text = Convert.ToDecimal(row["RutKN"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_HanhChinh_KoChapNhanKNCuaVT.Text = Convert.ToDecimal(row["KoChapNhanKNCuaVT"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_HanhChinh_HuyBanAn.Text = Convert.ToDecimal(row["HuyBanAn"]).ToString("#,0.##", cul);
                }
                #endregion
                #region TAND CC tại Hà Nội -- Lao động
                tbl = null;
                cache_name = "cache_GSTP_Page2_GDT_CC_HaNoi_ALD" + DonViID;
                if (Cache[cache_name] == null)
                {
                    prm = new OracleParameter[]
                    {
                    new OracleParameter("curr_loaian",AnLaoDong),
                    new OracleParameter("curr_toaanid",ToaCapCao_HaNoi),
                    new OracleParameter("curr_vu_gdkt",Vu_GDT),
                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
                    tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_ThongKeChung_TheoAn", prm);
                    Cache.Add(cache_name, tbl, null, DateTime.Now.AddMinutes(720), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
                }
                else
                {
                    tbl = (DataTable)Cache[cache_name];
                }
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    DataRow row = tbl.Rows[0];
                    #region Cộng dồn vào biến tổng
                    Tong_DonTrung = Tong_DonTrung + Convert.ToDecimal(row["DonTrung"]);
                    Tong_DonMoi = Tong_DonMoi + Convert.ToDecimal(row["DonMoi"]);
                    Tong_DaGiaiQuyet = Tong_DaGiaiQuyet + Convert.ToDecimal(row["DaGiaiQuyet"]);
                    Tong_ChuaGiaiQuyet = Tong_ChuaGiaiQuyet + Convert.ToDecimal(row["ChuaGiaiQuyet"]);
                    Tong_AnThoiHieu = Tong_AnThoiHieu + Convert.ToDecimal(row["AnThoiHieu"]);
                    decimal Vu2_KinhTe_VienTruongKN = Convert.ToDecimal(row["VienTruongKN"]),
                            Vu2_KinhTe_ChanhAnKN = Convert.ToDecimal(row["ChanhAnKN"]);
                    Tong_VienTruongKN = Tong_VienTruongKN + Vu2_KinhTe_VienTruongKN;
                    Tong_ChanhAnKN = Tong_ChanhAnKN + Vu2_KinhTe_ChanhAnKN;
                    Tong_DaXetXuGDT = Tong_DaXetXuGDT + Convert.ToDecimal(row["DaXetXuGDT"]);
                    Tong_ConLai = Tong_ConLai + Convert.ToDecimal(row["ChuaXetXuGDT"]);
                    Tong_QuaHanLuatDinh = Tong_QuaHanLuatDinh + Convert.ToDecimal(row["QuaHanLuatDinh"]);
                    Tong_RutKN = Tong_RutKN + Convert.ToDecimal(row["RutKN"]);
                    Tong_KoChapNhanKNCuaVT = Tong_KoChapNhanKNCuaVT + Convert.ToDecimal(row["KoChapNhanKNCuaVT"]);
                    Tong_HuyBanAn = Tong_HuyBanAn + Convert.ToDecimal(row["HuyBanAn"]);
                    #endregion
                    ltr_CCHaNoi_LaoDong_DonTrung.Text = Convert.ToDecimal(row["DonTrung"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_LaoDong_DonMoi.Text = Convert.ToDecimal(row["DonMoi"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_LaoDong_DaGiaiQuyet.Text = Convert.ToDecimal(row["DaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_LaoDong_ChuaGiaiQuyet.Text = Convert.ToDecimal(row["ChuaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_LaoDong_AnThoiHieu.Text = Convert.ToDecimal(row["AnThoiHieu"]).ToString("#,0.##", cul);
                    decimal CCHaNoi_LaoDong_VienTruongKN = Convert.ToDecimal(row["VienTruongKN"]),
                            CCHaNoi_LaoDong_ChanhAnKN = Convert.ToDecimal(row["ChanhAnKN"]);
                    ltr_CCHaNoi_LaoDong_VienTruongKN.Text = CCHaNoi_LaoDong_VienTruongKN.ToString("#,0.##", cul);
                    ltr_CCHaNoi_LaoDong_ChanhAnKN.Text = CCHaNoi_LaoDong_ChanhAnKN.ToString("#,0.##", cul);
                    ltr_CCHaNoi_LaoDong_DaXetXuGDT.Text = Convert.ToDecimal(row["DaXetXuGDT"]).ToString("#,0.##", cul);
                    if (CCHaNoi_LaoDong_VienTruongKN + CCHaNoi_LaoDong_ChanhAnKN > 0)
                    {
                        ltr_CCHaNoi_LaoDong_TyLe.Text = Math.Round((Convert.ToDecimal(row["DaXetXuGDT"]) / (CCHaNoi_LaoDong_VienTruongKN + CCHaNoi_LaoDong_ChanhAnKN) * 100), MidpointRounding.AwayFromZero).ToString("#,0.##", cul);
                    }
                    ltr_CCHaNoi_LaoDong_ConLai.Text = Convert.ToDecimal(row["ChuaXetXuGDT"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_LaoDong_QuaHanLuatDinh.Text = Convert.ToDecimal(row["QuaHanLuatDinh"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_LaoDong_RutKN.Text = Convert.ToDecimal(row["RutKN"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_LaoDong_KoChapNhanKNCuaVT.Text = Convert.ToDecimal(row["KoChapNhanKNCuaVT"]).ToString("#,0.##", cul);
                    ltr_CCHaNoi_LaoDong_HuyBanAn.Text = Convert.ToDecimal(row["HuyBanAn"]).ToString("#,0.##", cul);
                }
                #endregion
                #region TAND CC tại Hà Nội -- Tổng cộng
                ltr_CCHaNoi_Tong_DonTrung.Text = Tong_DonTrung.ToString("#,0.##", cul);
                ltr_CCHaNoi_Tong_DonMoi.Text = Tong_DonMoi.ToString("#,0.##", cul);
                ltr_CCHaNoi_Tong_DaGiaiQuyet.Text = Tong_DaGiaiQuyet.ToString("#,0.##", cul);
                ltr_CCHaNoi_Tong_ChuaGiaiQuyet.Text = Tong_ChuaGiaiQuyet.ToString("#,0.##", cul);
                ltr_CCHaNoi_Tong_AnThoiHieu.Text = Tong_AnThoiHieu.ToString("#,0.##", cul);
                ltr_CCHaNoi_Tong_VienTruongKN.Text = Tong_VienTruongKN.ToString("#,0.##", cul);
                ltr_CCHaNoi_Tong_ChanhAnKN.Text = Tong_ChanhAnKN.ToString("#,0.##", cul);
                ltr_CCHaNoi_Tong_DaXetXuGDT.Text = Tong_DaXetXuGDT.ToString("#,0.##", cul);
                if (Tong_VienTruongKN + Tong_ChanhAnKN > 0)
                {
                    ltr_CCHaNoi_Tong_TyLe.Text = Math.Round((Tong_DaXetXuGDT / (Tong_VienTruongKN + Tong_ChanhAnKN) * 100), MidpointRounding.AwayFromZero).ToString("#,0.##", cul);
                }
                ltr_CCHaNoi_Tong_ConLai.Text = Tong_ConLai.ToString("#,0.##", cul);
                ltr_CCHaNoi_Tong_QuaHanLuatDinh.Text = Tong_QuaHanLuatDinh.ToString("#,0.##", cul);
                ltr_CCHaNoi_Tong_RutKN.Text = Tong_RutKN.ToString("#,0.##", cul);
                ltr_CCHaNoi_Tong_KoChapNhanKNCuaVT.Text = Tong_KoChapNhanKNCuaVT.ToString("#,0.##", cul);
                ltr_CCHaNoi_Tong_HuyBanAn.Text = Tong_HuyBanAn.ToString("#,0.##", cul);
                #endregion
            }
            else if (DonViID == 0 || TenToa == "cấp cao tại đà nẵng")
            {
                ta = dt.DM_TOAAN.Where(x => x.LOAITOA == "CAPCAO" && x.TEN.ToUpper().Contains("ĐÀ NẴNG")).FirstOrDefault();
                if (ta != null)
                {
                    ToacapCao_DaNang = ta.ID;
                }
                #region reset lại giá trị các tổng
                Tong_DonTrung = Tong_DonMoi = Tong_DaGiaiQuyet = Tong_ChuaGiaiQuyet = Tong_AnThoiHieu = Tong_VienTruongKN = Tong_ChanhAnKN = 0;
                Tong_DaXetXuGDT = Tong_ConLai = Tong_QuaHanLuatDinh = Tong_RutKN = Tong_KoChapNhanKNCuaVT = Tong_HuyBanAn = 0;
                #endregion
                #region TAND CC tại Đà Nẵng -- Hình sự
                tbl = null;
                cache_name = "cache_GSTP_Page2_GDT_CC_DaNang_AHS" + DonViID;
                if (Cache[cache_name] == null)
                {
                    prm = new OracleParameter[]
                    {
                    new OracleParameter("curr_loaian",AnHinhSu),
                    new OracleParameter("curr_toaanid",ToacapCao_DaNang),
                    new OracleParameter("curr_vu_gdkt",Vu_GDT),
                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
                    tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_ThongKeChung_TheoAn", prm);
                    Cache.Add(cache_name, tbl, null, DateTime.Now.AddMinutes(720), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
                }
                else
                {
                    tbl = (DataTable)Cache[cache_name];
                }
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    DataRow row = tbl.Rows[0];
                    #region Cộng dồn vào biến tổng
                    Tong_DonTrung = Tong_DonTrung + Convert.ToDecimal(row["DonTrung"]);
                    Tong_DonMoi = Tong_DonMoi + Convert.ToDecimal(row["DonMoi"]);
                    Tong_DaGiaiQuyet = Tong_DaGiaiQuyet + Convert.ToDecimal(row["DaGiaiQuyet"]);
                    Tong_ChuaGiaiQuyet = Tong_ChuaGiaiQuyet + Convert.ToDecimal(row["ChuaGiaiQuyet"]);
                    Tong_AnThoiHieu = Tong_AnThoiHieu + Convert.ToDecimal(row["AnThoiHieu"]);
                    decimal Vu2_KinhTe_VienTruongKN = Convert.ToDecimal(row["VienTruongKN"]),
                            Vu2_KinhTe_ChanhAnKN = Convert.ToDecimal(row["ChanhAnKN"]);
                    Tong_VienTruongKN = Tong_VienTruongKN + Vu2_KinhTe_VienTruongKN;
                    Tong_ChanhAnKN = Tong_ChanhAnKN + Vu2_KinhTe_ChanhAnKN;
                    Tong_DaXetXuGDT = Tong_DaXetXuGDT + Convert.ToDecimal(row["DaXetXuGDT"]);
                    Tong_ConLai = Tong_ConLai + Convert.ToDecimal(row["ChuaXetXuGDT"]);
                    Tong_QuaHanLuatDinh = Tong_QuaHanLuatDinh + Convert.ToDecimal(row["QuaHanLuatDinh"]);
                    Tong_RutKN = Tong_RutKN + Convert.ToDecimal(row["RutKN"]);
                    Tong_KoChapNhanKNCuaVT = Tong_KoChapNhanKNCuaVT + Convert.ToDecimal(row["KoChapNhanKNCuaVT"]);
                    Tong_HuyBanAn = Tong_HuyBanAn + Convert.ToDecimal(row["HuyBanAn"]);
                    #endregion
                    ltr_CCDaNang_HinhSu_DonTrung.Text = Convert.ToDecimal(row["DonTrung"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_HinhSu_DonMoi.Text = Convert.ToDecimal(row["DonMoi"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_HinhSu_DaGiaiQuyet.Text = Convert.ToDecimal(row["DaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_HinhSu_ChuaGiaiQuyet.Text = Convert.ToDecimal(row["ChuaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_HinhSu_AnThoiHieu.Text = Convert.ToDecimal(row["AnThoiHieu"]).ToString("#,0.##", cul);
                    decimal CCDaNang_HinhSu_VienTruongKN = Convert.ToDecimal(row["VienTruongKN"]),
                            CCDaNang_HinhSu_ChanhAnKN = Convert.ToDecimal(row["ChanhAnKN"]);
                    ltr_CCDaNang_HinhSu_VienTruongKN.Text = CCDaNang_HinhSu_VienTruongKN.ToString("#,0.##", cul);
                    ltr_CCDaNang_HinhSu_ChanhAnKN.Text = CCDaNang_HinhSu_ChanhAnKN.ToString("#,0.##", cul);
                    ltr_CCDaNang_HinhSu_DaXetXuGDT.Text = Convert.ToDecimal(row["DaXetXuGDT"]).ToString("#,0.##", cul);
                    if (CCDaNang_HinhSu_VienTruongKN + CCDaNang_HinhSu_ChanhAnKN > 0)
                    {
                        ltr_CCDaNang_HinhSu_TyLe.Text = Math.Round((Convert.ToDecimal(row["DaXetXuGDT"]) / (CCDaNang_HinhSu_VienTruongKN + CCDaNang_HinhSu_ChanhAnKN) * 100), MidpointRounding.AwayFromZero).ToString("#,0.##", cul);
                    }
                    ltr_CCDaNang_HinhSu_ConLai.Text = Convert.ToDecimal(row["ChuaXetXuGDT"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_HinhSu_QuaHanLuatDinh.Text = Convert.ToDecimal(row["QuaHanLuatDinh"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_HinhSu_RutKN.Text = Convert.ToDecimal(row["RutKN"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_HinhSu_KoChapNhanKNCuaVT.Text = Convert.ToDecimal(row["KoChapNhanKNCuaVT"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_HinhSu_HuyBanAn.Text = Convert.ToDecimal(row["HuyBanAn"]).ToString("#,0.##", cul);
                }
                #endregion
                #region TAND CC tại Đà Nẵng -- Dân sự
                tbl = null;
                cache_name = "cache_GSTP_Page2_GDT_CC_DaNang_ADS" + DonViID;
                if (Cache[cache_name] == null)
                {
                    prm = new OracleParameter[]
                    {
                    new OracleParameter("curr_loaian",AnDanSu),
                    new OracleParameter("curr_toaanid",ToacapCao_DaNang),
                    new OracleParameter("curr_vu_gdkt",Vu_GDT),
                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
                    tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_ThongKeChung_TheoAn", prm);
                    Cache.Add(cache_name, tbl, null, DateTime.Now.AddMinutes(720), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
                }
                else
                {
                    tbl = (DataTable)Cache[cache_name];
                }
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    DataRow row = tbl.Rows[0];
                    #region Cộng dồn vào biến tổng
                    Tong_DonTrung = Tong_DonTrung + Convert.ToDecimal(row["DonTrung"]);
                    Tong_DonMoi = Tong_DonMoi + Convert.ToDecimal(row["DonMoi"]);
                    Tong_DaGiaiQuyet = Tong_DaGiaiQuyet + Convert.ToDecimal(row["DaGiaiQuyet"]);
                    Tong_ChuaGiaiQuyet = Tong_ChuaGiaiQuyet + Convert.ToDecimal(row["ChuaGiaiQuyet"]);
                    Tong_AnThoiHieu = Tong_AnThoiHieu + Convert.ToDecimal(row["AnThoiHieu"]);
                    decimal Vu2_KinhTe_VienTruongKN = Convert.ToDecimal(row["VienTruongKN"]),
                            Vu2_KinhTe_ChanhAnKN = Convert.ToDecimal(row["ChanhAnKN"]);
                    Tong_VienTruongKN = Tong_VienTruongKN + Vu2_KinhTe_VienTruongKN;
                    Tong_ChanhAnKN = Tong_ChanhAnKN + Vu2_KinhTe_ChanhAnKN;
                    Tong_DaXetXuGDT = Tong_DaXetXuGDT + Convert.ToDecimal(row["DaXetXuGDT"]);
                    Tong_ConLai = Tong_ConLai + Convert.ToDecimal(row["ChuaXetXuGDT"]);
                    Tong_QuaHanLuatDinh = Tong_QuaHanLuatDinh + Convert.ToDecimal(row["QuaHanLuatDinh"]);
                    Tong_RutKN = Tong_RutKN + Convert.ToDecimal(row["RutKN"]);
                    Tong_KoChapNhanKNCuaVT = Tong_KoChapNhanKNCuaVT + Convert.ToDecimal(row["KoChapNhanKNCuaVT"]);
                    Tong_HuyBanAn = Tong_HuyBanAn + Convert.ToDecimal(row["HuyBanAn"]);
                    #endregion
                    ltr_CCDaNang_DanSu_DonTrung.Text = Convert.ToDecimal(row["DonTrung"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_DanSu_DonMoi.Text = Convert.ToDecimal(row["DonMoi"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_DanSu_DaGiaiQuyet.Text = Convert.ToDecimal(row["DaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_DanSu_ChuaGiaiQuyet.Text = Convert.ToDecimal(row["ChuaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_DanSu_AnThoiHieu.Text = Convert.ToDecimal(row["AnThoiHieu"]).ToString("#,0.##", cul);
                    decimal CCDaNang_DanSu_VienTruongKN = Convert.ToDecimal(row["VienTruongKN"]),
                            CCDaNang_DanSu_ChanhAnKN = Convert.ToDecimal(row["ChanhAnKN"]);
                    ltr_CCDaNang_DanSu_VienTruongKN.Text = CCDaNang_DanSu_VienTruongKN.ToString("#,0.##", cul);
                    ltr_CCDaNang_DanSu_ChanhAnKN.Text = CCDaNang_DanSu_ChanhAnKN.ToString("#,0.##", cul);
                    ltr_CCDaNang_DanSu_DaXetXuGDT.Text = Convert.ToDecimal(row["DaXetXuGDT"]).ToString("#,0.##", cul);
                    if (CCDaNang_DanSu_VienTruongKN + CCDaNang_DanSu_ChanhAnKN > 0)
                    {
                        ltr_CCDaNang_DanSu_TyLe.Text = Math.Round((Convert.ToDecimal(row["DaXetXuGDT"]) / (CCDaNang_DanSu_VienTruongKN + CCDaNang_DanSu_ChanhAnKN) * 100), MidpointRounding.AwayFromZero).ToString("#,0.##", cul);
                    }
                    ltr_CCDaNang_DanSu_ConLai.Text = Convert.ToDecimal(row["ChuaXetXuGDT"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_DanSu_QuaHanLuatDinh.Text = Convert.ToDecimal(row["QuaHanLuatDinh"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_DanSu_RutKN.Text = Convert.ToDecimal(row["RutKN"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_DanSu_KoChapNhanKNCuaVT.Text = Convert.ToDecimal(row["KoChapNhanKNCuaVT"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_DanSu_HuyBanAn.Text = Convert.ToDecimal(row["HuyBanAn"]).ToString("#,0.##", cul);
                }
                #endregion
                #region TAND CC tại Đà Nẵng -- Kinh doanh thương mại
                tbl = null;
                cache_name = "cache_GSTP_Page2_GDT_CC_DaNang_AKT" + DonViID;
                if (Cache[cache_name] == null)
                {
                    prm = new OracleParameter[]
                    {
                    new OracleParameter("curr_loaian",AnKinhTe),
                    new OracleParameter("curr_toaanid",ToacapCao_DaNang),
                    new OracleParameter("curr_vu_gdkt",Vu_GDT),
                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
                    tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_ThongKeChung_TheoAn", prm);
                    Cache.Add(cache_name, tbl, null, DateTime.Now.AddMinutes(720), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
                }
                else
                {
                    tbl = (DataTable)Cache[cache_name];
                }
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    DataRow row = tbl.Rows[0];
                    #region Cộng dồn vào biến tổng
                    Tong_DonTrung = Tong_DonTrung + Convert.ToDecimal(row["DonTrung"]);
                    Tong_DonMoi = Tong_DonMoi + Convert.ToDecimal(row["DonMoi"]);
                    Tong_DaGiaiQuyet = Tong_DaGiaiQuyet + Convert.ToDecimal(row["DaGiaiQuyet"]);
                    Tong_ChuaGiaiQuyet = Tong_ChuaGiaiQuyet + Convert.ToDecimal(row["ChuaGiaiQuyet"]);
                    Tong_AnThoiHieu = Tong_AnThoiHieu + Convert.ToDecimal(row["AnThoiHieu"]);
                    decimal Vu2_KinhTe_VienTruongKN = Convert.ToDecimal(row["VienTruongKN"]),
                            Vu2_KinhTe_ChanhAnKN = Convert.ToDecimal(row["ChanhAnKN"]);
                    Tong_VienTruongKN = Tong_VienTruongKN + Vu2_KinhTe_VienTruongKN;
                    Tong_ChanhAnKN = Tong_ChanhAnKN + Vu2_KinhTe_ChanhAnKN;
                    Tong_DaXetXuGDT = Tong_DaXetXuGDT + Convert.ToDecimal(row["DaXetXuGDT"]);
                    Tong_ConLai = Tong_ConLai + Convert.ToDecimal(row["ChuaXetXuGDT"]);
                    Tong_QuaHanLuatDinh = Tong_QuaHanLuatDinh + Convert.ToDecimal(row["QuaHanLuatDinh"]);
                    Tong_RutKN = Tong_RutKN + Convert.ToDecimal(row["RutKN"]);
                    Tong_KoChapNhanKNCuaVT = Tong_KoChapNhanKNCuaVT + Convert.ToDecimal(row["KoChapNhanKNCuaVT"]);
                    Tong_HuyBanAn = Tong_HuyBanAn + Convert.ToDecimal(row["HuyBanAn"]);
                    #endregion
                    ltr_CCDaNang_KinhTe_DonTrung.Text = Convert.ToDecimal(row["DonTrung"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_KinhTe_DonMoi.Text = Convert.ToDecimal(row["DonMoi"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_KinhTe_DaGiaiQuyet.Text = Convert.ToDecimal(row["DaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_KinhTe_ChuaGiaiQuyet.Text = Convert.ToDecimal(row["ChuaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_KinhTe_AnThoiHieu.Text = Convert.ToDecimal(row["AnThoiHieu"]).ToString("#,0.##", cul);
                    decimal CCDaNang_KinhTe_VienTruongKN = Convert.ToDecimal(row["VienTruongKN"]),
                            CCDaNang_KinhTe_ChanhAnKN = Convert.ToDecimal(row["ChanhAnKN"]);
                    ltr_CCDaNang_KinhTe_VienTruongKN.Text = CCDaNang_KinhTe_VienTruongKN.ToString("#,0.##", cul);
                    ltr_CCDaNang_KinhTe_ChanhAnKN.Text = CCDaNang_KinhTe_ChanhAnKN.ToString("#,0.##", cul);
                    ltr_CCDaNang_KinhTe_DaXetXuGDT.Text = Convert.ToDecimal(row["DaXetXuGDT"]).ToString("#,0.##", cul);
                    if (CCDaNang_KinhTe_VienTruongKN + CCDaNang_KinhTe_ChanhAnKN > 0)
                    {
                        ltr_CCDaNang_KinhTe_TyLe.Text = Math.Round((Convert.ToDecimal(row["DaXetXuGDT"]) / (CCDaNang_KinhTe_VienTruongKN + CCDaNang_KinhTe_ChanhAnKN) * 100), MidpointRounding.AwayFromZero).ToString("#,0.##", cul);
                    }
                    ltr_CCDaNang_KinhTe_ConLai.Text = Convert.ToDecimal(row["ChuaXetXuGDT"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_KinhTe_QuaHanLuatDinh.Text = Convert.ToDecimal(row["QuaHanLuatDinh"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_KinhTe_RutKN.Text = Convert.ToDecimal(row["RutKN"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_KinhTe_KoChapNhanKNCuaVT.Text = Convert.ToDecimal(row["KoChapNhanKNCuaVT"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_KinhTe_HuyBanAn.Text = Convert.ToDecimal(row["HuyBanAn"]).ToString("#,0.##", cul);
                }
                #endregion
                #region TAND CC tại Đà Nẵng -- Hôn nhân và Gia đình
                tbl = null;
                cache_name = "cache_GSTP_Page2_GDT_CC_DaNang_AHN" + DonViID;
                if (Cache[cache_name] == null)
                {
                    prm = new OracleParameter[]
                    {
                    new OracleParameter("curr_loaian",AnHNGD),
                    new OracleParameter("curr_toaanid",ToacapCao_DaNang),
                    new OracleParameter("curr_vu_gdkt",Vu_GDT),
                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
                    tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_ThongKeChung_TheoAn", prm);
                    Cache.Add(cache_name, tbl, null, DateTime.Now.AddMinutes(720), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
                }
                else
                {
                    tbl = (DataTable)Cache[cache_name];
                }
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    DataRow row = tbl.Rows[0];
                    #region Cộng dồn vào biến tổng
                    Tong_DonTrung = Tong_DonTrung + Convert.ToDecimal(row["DonTrung"]);
                    Tong_DonMoi = Tong_DonMoi + Convert.ToDecimal(row["DonMoi"]);
                    Tong_DaGiaiQuyet = Tong_DaGiaiQuyet + Convert.ToDecimal(row["DaGiaiQuyet"]);
                    Tong_ChuaGiaiQuyet = Tong_ChuaGiaiQuyet + Convert.ToDecimal(row["ChuaGiaiQuyet"]);
                    Tong_AnThoiHieu = Tong_AnThoiHieu + Convert.ToDecimal(row["AnThoiHieu"]);
                    decimal Vu2_KinhTe_VienTruongKN = Convert.ToDecimal(row["VienTruongKN"]),
                            Vu2_KinhTe_ChanhAnKN = Convert.ToDecimal(row["ChanhAnKN"]);
                    Tong_VienTruongKN = Tong_VienTruongKN + Vu2_KinhTe_VienTruongKN;
                    Tong_ChanhAnKN = Tong_ChanhAnKN + Vu2_KinhTe_ChanhAnKN;
                    Tong_DaXetXuGDT = Tong_DaXetXuGDT + Convert.ToDecimal(row["DaXetXuGDT"]);
                    Tong_ConLai = Tong_ConLai + Convert.ToDecimal(row["ChuaXetXuGDT"]);
                    Tong_QuaHanLuatDinh = Tong_QuaHanLuatDinh + Convert.ToDecimal(row["QuaHanLuatDinh"]);
                    Tong_RutKN = Tong_RutKN + Convert.ToDecimal(row["RutKN"]);
                    Tong_KoChapNhanKNCuaVT = Tong_KoChapNhanKNCuaVT + Convert.ToDecimal(row["KoChapNhanKNCuaVT"]);
                    Tong_HuyBanAn = Tong_HuyBanAn + Convert.ToDecimal(row["HuyBanAn"]);
                    #endregion
                    ltr_CCDaNang_HNGD_DonTrung.Text = Convert.ToDecimal(row["DonTrung"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_HNGD_DonMoi.Text = Convert.ToDecimal(row["DonMoi"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_HNGD_DaGiaiQuyet.Text = Convert.ToDecimal(row["DaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_HNGD_ChuaGiaiQuyet.Text = Convert.ToDecimal(row["ChuaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_HNGD_AnThoiHieu.Text = Convert.ToDecimal(row["AnThoiHieu"]).ToString("#,0.##", cul);
                    decimal CCDaNang_HNGD_VienTruongKN = Convert.ToDecimal(row["VienTruongKN"]),
                            CCDaNang_HNGD_ChanhAnKN = Convert.ToDecimal(row["ChanhAnKN"]);
                    ltr_CCDaNang_HNGD_VienTruongKN.Text = CCDaNang_HNGD_VienTruongKN.ToString("#,0.##", cul);
                    ltr_CCDaNang_HNGD_ChanhAnKN.Text = CCDaNang_HNGD_ChanhAnKN.ToString("#,0.##", cul);
                    ltr_CCDaNang_HNGD_DaXetXuGDT.Text = Convert.ToDecimal(row["DaXetXuGDT"]).ToString("#,0.##", cul);
                    if (CCDaNang_HNGD_VienTruongKN + CCDaNang_HNGD_ChanhAnKN > 0)
                    {
                        ltr_CCDaNang_HNGD_TyLe.Text = Math.Round((Convert.ToDecimal(row["DaXetXuGDT"]) / (CCDaNang_HNGD_VienTruongKN + CCDaNang_HNGD_ChanhAnKN) * 100), MidpointRounding.AwayFromZero).ToString("#,0.##", cul);
                    }
                    ltr_CCDaNang_HNGD_ConLai.Text = Convert.ToDecimal(row["ChuaXetXuGDT"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_HNGD_QuaHanLuatDinh.Text = Convert.ToDecimal(row["QuaHanLuatDinh"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_HNGD_RutKN.Text = Convert.ToDecimal(row["RutKN"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_HNGD_KoChapNhanKNCuaVT.Text = Convert.ToDecimal(row["KoChapNhanKNCuaVT"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_HNGD_HuyBanAn.Text = Convert.ToDecimal(row["HuyBanAn"]).ToString("#,0.##", cul);
                }
                #endregion
                #region TAND CC tại Đà Nẵng -- Hành chính
                tbl = null;
                cache_name = "cache_GSTP_Page2_GDT_CC_DaNang_AHC" + DonViID;
                if (Cache[cache_name] == null)
                {
                    prm = new OracleParameter[]
                    {
                    new OracleParameter("curr_loaian",AnHanhChinh),
                    new OracleParameter("curr_toaanid",ToacapCao_DaNang),
                    new OracleParameter("curr_vu_gdkt",Vu_GDT),
                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
                    tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_ThongKeChung_TheoAn", prm);
                    Cache.Add(cache_name, tbl, null, DateTime.Now.AddMinutes(720), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
                }
                else
                {
                    tbl = (DataTable)Cache[cache_name];
                }
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    DataRow row = tbl.Rows[0];
                    #region Cộng dồn vào biến tổng
                    Tong_DonTrung = Tong_DonTrung + Convert.ToDecimal(row["DonTrung"]);
                    Tong_DonMoi = Tong_DonMoi + Convert.ToDecimal(row["DonMoi"]);
                    Tong_DaGiaiQuyet = Tong_DaGiaiQuyet + Convert.ToDecimal(row["DaGiaiQuyet"]);
                    Tong_ChuaGiaiQuyet = Tong_ChuaGiaiQuyet + Convert.ToDecimal(row["ChuaGiaiQuyet"]);
                    Tong_AnThoiHieu = Tong_AnThoiHieu + Convert.ToDecimal(row["AnThoiHieu"]);
                    decimal Vu2_KinhTe_VienTruongKN = Convert.ToDecimal(row["VienTruongKN"]),
                            Vu2_KinhTe_ChanhAnKN = Convert.ToDecimal(row["ChanhAnKN"]);
                    Tong_VienTruongKN = Tong_VienTruongKN + Vu2_KinhTe_VienTruongKN;
                    Tong_ChanhAnKN = Tong_ChanhAnKN + Vu2_KinhTe_ChanhAnKN;
                    Tong_DaXetXuGDT = Tong_DaXetXuGDT + Convert.ToDecimal(row["DaXetXuGDT"]);
                    Tong_ConLai = Tong_ConLai + Convert.ToDecimal(row["ChuaXetXuGDT"]);
                    Tong_QuaHanLuatDinh = Tong_QuaHanLuatDinh + Convert.ToDecimal(row["QuaHanLuatDinh"]);
                    Tong_RutKN = Tong_RutKN + Convert.ToDecimal(row["RutKN"]);
                    Tong_KoChapNhanKNCuaVT = Tong_KoChapNhanKNCuaVT + Convert.ToDecimal(row["KoChapNhanKNCuaVT"]);
                    Tong_HuyBanAn = Tong_HuyBanAn + Convert.ToDecimal(row["HuyBanAn"]);
                    #endregion
                    ltr_CCDaNang_HanhChinh_DonTrung.Text = Convert.ToDecimal(row["DonTrung"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_HanhChinh_DonMoi.Text = Convert.ToDecimal(row["DonMoi"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_HanhChinh_DaGiaiQuyet.Text = Convert.ToDecimal(row["DaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_HanhChinh_ChuaGiaiQuyet.Text = Convert.ToDecimal(row["ChuaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_HanhChinh_AnThoiHieu.Text = Convert.ToDecimal(row["AnThoiHieu"]).ToString("#,0.##", cul);
                    decimal CCDaNang_HanhChinh_VienTruongKN = Convert.ToDecimal(row["VienTruongKN"]),
                            CCDaNang_HanhChinh_ChanhAnKN = Convert.ToDecimal(row["ChanhAnKN"]);
                    ltr_CCDaNang_HanhChinh_VienTruongKN.Text = CCDaNang_HanhChinh_VienTruongKN.ToString("#,0.##", cul);
                    ltr_CCDaNang_HanhChinh_ChanhAnKN.Text = CCDaNang_HanhChinh_ChanhAnKN.ToString("#,0.##", cul);
                    ltr_CCDaNang_HanhChinh_DaXetXuGDT.Text = Convert.ToDecimal(row["DaXetXuGDT"]).ToString("#,0.##", cul);
                    if (CCDaNang_HanhChinh_VienTruongKN + CCDaNang_HanhChinh_ChanhAnKN > 0)
                    {
                        ltr_CCDaNang_HanhChinh_TyLe.Text = Math.Round((Convert.ToDecimal(row["DaXetXuGDT"]) / (CCDaNang_HanhChinh_VienTruongKN + CCDaNang_HanhChinh_ChanhAnKN) * 100), MidpointRounding.AwayFromZero).ToString("#,0.##", cul);
                    }
                    ltr_CCDaNang_HanhChinh_ConLai.Text = Convert.ToDecimal(row["ChuaXetXuGDT"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_HanhChinh_QuaHanLuatDinh.Text = Convert.ToDecimal(row["QuaHanLuatDinh"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_HanhChinh_RutKN.Text = Convert.ToDecimal(row["RutKN"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_HanhChinh_KoChapNhanKNCuaVT.Text = Convert.ToDecimal(row["KoChapNhanKNCuaVT"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_HanhChinh_HuyBanAn.Text = Convert.ToDecimal(row["HuyBanAn"]).ToString("#,0.##", cul);
                }
                #endregion
                #region TAND CC tại Đà Nẵng -- Lao động
                tbl = null;
                cache_name = "cache_GSTP_Page2_GDT_CC_DaNang_ALD" + DonViID;
                if (Cache[cache_name] == null)
                {
                    prm = new OracleParameter[]
                    {
                    new OracleParameter("curr_loaian",AnLaoDong),
                    new OracleParameter("curr_toaanid",ToacapCao_DaNang),
                    new OracleParameter("curr_vu_gdkt",Vu_GDT),
                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
                    tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_ThongKeChung_TheoAn", prm);
                    Cache.Add(cache_name, tbl, null, DateTime.Now.AddMinutes(720), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
                }
                else
                {
                    tbl = (DataTable)Cache[cache_name];
                }
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    DataRow row = tbl.Rows[0];
                    #region Cộng dồn vào biến tổng
                    Tong_DonTrung = Tong_DonTrung + Convert.ToDecimal(row["DonTrung"]);
                    Tong_DonMoi = Tong_DonMoi + Convert.ToDecimal(row["DonMoi"]);
                    Tong_DaGiaiQuyet = Tong_DaGiaiQuyet + Convert.ToDecimal(row["DaGiaiQuyet"]);
                    Tong_ChuaGiaiQuyet = Tong_ChuaGiaiQuyet + Convert.ToDecimal(row["ChuaGiaiQuyet"]);
                    Tong_AnThoiHieu = Tong_AnThoiHieu + Convert.ToDecimal(row["AnThoiHieu"]);
                    decimal Vu2_KinhTe_VienTruongKN = Convert.ToDecimal(row["VienTruongKN"]),
                            Vu2_KinhTe_ChanhAnKN = Convert.ToDecimal(row["ChanhAnKN"]);
                    Tong_VienTruongKN = Tong_VienTruongKN + Vu2_KinhTe_VienTruongKN;
                    Tong_ChanhAnKN = Tong_ChanhAnKN + Vu2_KinhTe_ChanhAnKN;
                    Tong_DaXetXuGDT = Tong_DaXetXuGDT + Convert.ToDecimal(row["DaXetXuGDT"]);
                    Tong_ConLai = Tong_ConLai + Convert.ToDecimal(row["ChuaXetXuGDT"]);
                    Tong_QuaHanLuatDinh = Tong_QuaHanLuatDinh + Convert.ToDecimal(row["QuaHanLuatDinh"]);
                    Tong_RutKN = Tong_RutKN + Convert.ToDecimal(row["RutKN"]);
                    Tong_KoChapNhanKNCuaVT = Tong_KoChapNhanKNCuaVT + Convert.ToDecimal(row["KoChapNhanKNCuaVT"]);
                    Tong_HuyBanAn = Tong_HuyBanAn + Convert.ToDecimal(row["HuyBanAn"]);
                    #endregion
                    ltr_CCDaNang_LaoDong_DonTrung.Text = Convert.ToDecimal(row["DonTrung"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_LaoDong_DonMoi.Text = Convert.ToDecimal(row["DonMoi"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_LaoDong_DaGiaiQuyet.Text = Convert.ToDecimal(row["DaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_LaoDong_ChuaGiaiQuyet.Text = Convert.ToDecimal(row["ChuaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_LaoDong_AnThoiHieu.Text = Convert.ToDecimal(row["AnThoiHieu"]).ToString("#,0.##", cul);
                    decimal CCDaNang_LaoDong_VienTruongKN = Convert.ToDecimal(row["VienTruongKN"]),
                            CCDaNang_LaoDong_ChanhAnKN = Convert.ToDecimal(row["ChanhAnKN"]);
                    ltr_CCDaNang_LaoDong_VienTruongKN.Text = CCDaNang_LaoDong_VienTruongKN.ToString("#,0.##", cul);
                    ltr_CCDaNang_LaoDong_ChanhAnKN.Text = CCDaNang_LaoDong_ChanhAnKN.ToString("#,0.##", cul);
                    ltr_CCDaNang_LaoDong_DaXetXuGDT.Text = Convert.ToDecimal(row["DaXetXuGDT"]).ToString("#,0.##", cul);
                    if (CCDaNang_LaoDong_VienTruongKN + CCDaNang_LaoDong_ChanhAnKN > 0)
                    {
                        ltr_CCDaNang_LaoDong_TyLe.Text = Math.Round((Convert.ToDecimal(row["DaXetXuGDT"]) / (CCDaNang_LaoDong_VienTruongKN + CCDaNang_LaoDong_ChanhAnKN) * 100), MidpointRounding.AwayFromZero).ToString("#,0.##", cul);
                    }
                    ltr_CCDaNang_LaoDong_ConLai.Text = Convert.ToDecimal(row["ChuaXetXuGDT"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_LaoDong_QuaHanLuatDinh.Text = Convert.ToDecimal(row["QuaHanLuatDinh"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_LaoDong_RutKN.Text = Convert.ToDecimal(row["RutKN"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_LaoDong_KoChapNhanKNCuaVT.Text = Convert.ToDecimal(row["KoChapNhanKNCuaVT"]).ToString("#,0.##", cul);
                    ltr_CCDaNang_LaoDong_HuyBanAn.Text = Convert.ToDecimal(row["HuyBanAn"]).ToString("#,0.##", cul);
                }
                #endregion
                #region TAND CC tại Đà Nẵng -- Tổng cộng
                ltr_CCDaNang_Tong_DonTrung.Text = Tong_DonTrung.ToString("#,0.##", cul);
                ltr_CCDaNang_Tong_DonMoi.Text = Tong_DonMoi.ToString("#,0.##", cul);
                ltr_CCDaNang_Tong_DaGiaiQuyet.Text = Tong_DaGiaiQuyet.ToString("#,0.##", cul);
                ltr_CCDaNang_Tong_ChuaGiaiQuyet.Text = Tong_ChuaGiaiQuyet.ToString("#,0.##", cul);
                ltr_CCDaNang_Tong_AnThoiHieu.Text = Tong_AnThoiHieu.ToString("#,0.##", cul);
                ltr_CCDaNang_Tong_VienTruongKN.Text = Tong_VienTruongKN.ToString("#,0.##", cul);
                ltr_CCDaNang_Tong_ChanhAnKN.Text = Tong_ChanhAnKN.ToString("#,0.##", cul);
                ltr_CCDaNang_Tong_DaXetXuGDT.Text = Tong_DaXetXuGDT.ToString("#,0.##", cul);
                if (Tong_VienTruongKN + Tong_ChanhAnKN > 0)
                {
                    ltr_CCDaNang_Tong_TyLe.Text = Math.Round((Tong_DaXetXuGDT / (Tong_VienTruongKN + Tong_ChanhAnKN) * 100), MidpointRounding.AwayFromZero).ToString("#,0.##", cul);
                }
                ltr_CCDaNang_Tong_ConLai.Text = Tong_ConLai.ToString("#,0.##", cul);
                ltr_CCDaNang_Tong_QuaHanLuatDinh.Text = Tong_QuaHanLuatDinh.ToString("#,0.##", cul);
                ltr_CCDaNang_Tong_RutKN.Text = Tong_RutKN.ToString("#,0.##", cul);
                ltr_CCDaNang_Tong_KoChapNhanKNCuaVT.Text = Tong_KoChapNhanKNCuaVT.ToString("#,0.##", cul);
                ltr_CCDaNang_Tong_HuyBanAn.Text = Tong_HuyBanAn.ToString("#,0.##", cul);
                #endregion
            }
            else if (DonViID == 0 || TenToa == "cấp cao tại HCM")
            {
                ta = dt.DM_TOAAN.Where(x => x.LOAITOA == "CAPCAO" && x.TEN.ToUpper().Contains("HỒ CHÍ MINH")).FirstOrDefault();
                if (ta != null)
                {
                    ToaCapCao_HCM = ta.ID;
                }
                #region reset lại giá trị các tổng
                Tong_DonTrung = Tong_DonMoi = Tong_DaGiaiQuyet = Tong_ChuaGiaiQuyet = Tong_AnThoiHieu = Tong_VienTruongKN = Tong_ChanhAnKN = 0;
                Tong_DaXetXuGDT = Tong_ConLai = Tong_QuaHanLuatDinh = Tong_RutKN = Tong_KoChapNhanKNCuaVT = Tong_HuyBanAn = 0;
                #endregion
                #region TAND CC tại TP Hồ Chí Minh -- Hình sự
                tbl = null;
                cache_name = "cache_GSTP_Page2_GDT_CC_HoChiMinh_AHS" + DonViID;
                if (Cache[cache_name] == null)
                {
                    prm = new OracleParameter[]
                    {
                    new OracleParameter("curr_loaian",AnHinhSu),
                    new OracleParameter("curr_toaanid",ToaCapCao_HCM),
                    new OracleParameter("curr_vu_gdkt",Vu_GDT),
                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
                    tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_ThongKeChung_TheoAn", prm);
                    Cache.Add(cache_name, tbl, null, DateTime.Now.AddMinutes(720), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
                }
                else
                {
                    tbl = (DataTable)Cache[cache_name];
                }
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    DataRow row = tbl.Rows[0];
                    #region Cộng dồn vào biến tổng
                    Tong_DonTrung = Tong_DonTrung + Convert.ToDecimal(row["DonTrung"]);
                    Tong_DonMoi = Tong_DonMoi + Convert.ToDecimal(row["DonMoi"]);
                    Tong_DaGiaiQuyet = Tong_DaGiaiQuyet + Convert.ToDecimal(row["DaGiaiQuyet"]);
                    Tong_ChuaGiaiQuyet = Tong_ChuaGiaiQuyet + Convert.ToDecimal(row["ChuaGiaiQuyet"]);
                    Tong_AnThoiHieu = Tong_AnThoiHieu + Convert.ToDecimal(row["AnThoiHieu"]);
                    decimal Vu2_KinhTe_VienTruongKN = Convert.ToDecimal(row["VienTruongKN"]),
                            Vu2_KinhTe_ChanhAnKN = Convert.ToDecimal(row["ChanhAnKN"]);
                    Tong_VienTruongKN = Tong_VienTruongKN + Vu2_KinhTe_VienTruongKN;
                    Tong_ChanhAnKN = Tong_ChanhAnKN + Vu2_KinhTe_ChanhAnKN;
                    Tong_DaXetXuGDT = Tong_DaXetXuGDT + Convert.ToDecimal(row["DaXetXuGDT"]);
                    Tong_ConLai = Tong_ConLai + Convert.ToDecimal(row["ChuaXetXuGDT"]);
                    Tong_QuaHanLuatDinh = Tong_QuaHanLuatDinh + Convert.ToDecimal(row["QuaHanLuatDinh"]);
                    Tong_RutKN = Tong_RutKN + Convert.ToDecimal(row["RutKN"]);
                    Tong_KoChapNhanKNCuaVT = Tong_KoChapNhanKNCuaVT + Convert.ToDecimal(row["KoChapNhanKNCuaVT"]);
                    Tong_HuyBanAn = Tong_HuyBanAn + Convert.ToDecimal(row["HuyBanAn"]);
                    #endregion
                    ltr_CCHCM_HinhSu_DonTrung.Text = Convert.ToDecimal(row["DonTrung"]).ToString("#,0.##", cul);
                    ltr_CCHCM_HinhSu_DonMoi.Text = Convert.ToDecimal(row["DonMoi"]).ToString("#,0.##", cul);
                    ltr_CCHCM_HinhSu_DaGiaiQuyet.Text = Convert.ToDecimal(row["DaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_CCHCM_HinhSu_ChuaGiaiQuyet.Text = Convert.ToDecimal(row["ChuaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_CCHCM_HinhSu_AnThoiHieu.Text = Convert.ToDecimal(row["AnThoiHieu"]).ToString("#,0.##", cul);
                    decimal CCHCM_HinhSu_VienTruongKN = Convert.ToDecimal(row["VienTruongKN"]),
                            CCHCM_HinhSu_ChanhAnKN = Convert.ToDecimal(row["ChanhAnKN"]);
                    ltr_CCHCM_HinhSu_VienTruongKN.Text = CCHCM_HinhSu_VienTruongKN.ToString("#,0.##", cul);
                    ltr_CCHCM_HinhSu_ChanhAnKN.Text = CCHCM_HinhSu_ChanhAnKN.ToString("#,0.##", cul);
                    ltr_CCHCM_HinhSu_DaXetXuGDT.Text = Convert.ToDecimal(row["DaXetXuGDT"]).ToString("#,0.##", cul);
                    if (CCHCM_HinhSu_VienTruongKN + CCHCM_HinhSu_ChanhAnKN > 0)
                    {
                        ltr_CCHCM_HinhSu_TyLe.Text = Math.Round((Convert.ToDecimal(row["DaXetXuGDT"]) / (CCHCM_HinhSu_VienTruongKN + CCHCM_HinhSu_ChanhAnKN) * 100), MidpointRounding.AwayFromZero).ToString("#,0.##", cul);
                    }
                    ltr_CCHCM_HinhSu_ConLai.Text = Convert.ToDecimal(row["ChuaXetXuGDT"]).ToString("#,0.##", cul);
                    ltr_CCHCM_HinhSu_QuaHanLuatDinh.Text = Convert.ToDecimal(row["QuaHanLuatDinh"]).ToString("#,0.##", cul);
                    ltr_CCHCM_HinhSu_RutKN.Text = Convert.ToDecimal(row["RutKN"]).ToString("#,0.##", cul);
                    ltr_CCHCM_HinhSu_KoChapNhanKNCuaVT.Text = Convert.ToDecimal(row["KoChapNhanKNCuaVT"]).ToString("#,0.##", cul);
                    ltr_CCHCM_HinhSu_HuyBanAn.Text = Convert.ToDecimal(row["HuyBanAn"]).ToString("#,0.##", cul);
                }
                #endregion
                #region TAND CC tại TP Hồ Chí Minh -- Dân sự
                tbl = null;
                cache_name = "cache_GSTP_Page2_GDT_CC_HoChiMinh_ADS" + DonViID;
                if (Cache[cache_name] == null)
                {
                    prm = new OracleParameter[]
                    {
                    new OracleParameter("curr_loaian",AnDanSu),
                    new OracleParameter("curr_toaanid",ToaCapCao_HCM),
                    new OracleParameter("curr_vu_gdkt",Vu_GDT),
                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
                    tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_ThongKeChung_TheoAn", prm);
                    Cache.Add(cache_name, tbl, null, DateTime.Now.AddMinutes(720), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
                }
                else
                {
                    tbl = (DataTable)Cache[cache_name];
                }
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    DataRow row = tbl.Rows[0];
                    #region Cộng dồn vào biến tổng
                    Tong_DonTrung = Tong_DonTrung + Convert.ToDecimal(row["DonTrung"]);
                    Tong_DonMoi = Tong_DonMoi + Convert.ToDecimal(row["DonMoi"]);
                    Tong_DaGiaiQuyet = Tong_DaGiaiQuyet + Convert.ToDecimal(row["DaGiaiQuyet"]);
                    Tong_ChuaGiaiQuyet = Tong_ChuaGiaiQuyet + Convert.ToDecimal(row["ChuaGiaiQuyet"]);
                    Tong_AnThoiHieu = Tong_AnThoiHieu + Convert.ToDecimal(row["AnThoiHieu"]);
                    decimal Vu2_KinhTe_VienTruongKN = Convert.ToDecimal(row["VienTruongKN"]),
                            Vu2_KinhTe_ChanhAnKN = Convert.ToDecimal(row["ChanhAnKN"]);
                    Tong_VienTruongKN = Tong_VienTruongKN + Vu2_KinhTe_VienTruongKN;
                    Tong_ChanhAnKN = Tong_ChanhAnKN + Vu2_KinhTe_ChanhAnKN;
                    Tong_DaXetXuGDT = Tong_DaXetXuGDT + Convert.ToDecimal(row["DaXetXuGDT"]);
                    Tong_ConLai = Tong_ConLai + Convert.ToDecimal(row["ChuaXetXuGDT"]);
                    Tong_QuaHanLuatDinh = Tong_QuaHanLuatDinh + Convert.ToDecimal(row["QuaHanLuatDinh"]);
                    Tong_RutKN = Tong_RutKN + Convert.ToDecimal(row["RutKN"]);
                    Tong_KoChapNhanKNCuaVT = Tong_KoChapNhanKNCuaVT + Convert.ToDecimal(row["KoChapNhanKNCuaVT"]);
                    Tong_HuyBanAn = Tong_HuyBanAn + Convert.ToDecimal(row["HuyBanAn"]);
                    #endregion
                    ltr_CCHCM_DanSu_DonTrung.Text = Convert.ToDecimal(row["DonTrung"]).ToString("#,0.##", cul);
                    ltr_CCHCM_DanSu_DonMoi.Text = Convert.ToDecimal(row["DonMoi"]).ToString("#,0.##", cul);
                    ltr_CCHCM_DanSu_DaGiaiQuyet.Text = Convert.ToDecimal(row["DaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_CCHCM_DanSu_ChuaGiaiQuyet.Text = Convert.ToDecimal(row["ChuaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_CCHCM_DanSu_AnThoiHieu.Text = Convert.ToDecimal(row["AnThoiHieu"]).ToString("#,0.##", cul);
                    decimal CCHCM_DanSu_VienTruongKN = Convert.ToDecimal(row["VienTruongKN"]),
                            CCHCM_DanSu_ChanhAnKN = Convert.ToDecimal(row["ChanhAnKN"]);
                    ltr_CCHCM_DanSu_VienTruongKN.Text = CCHCM_DanSu_VienTruongKN.ToString("#,0.##", cul);
                    ltr_CCHCM_DanSu_ChanhAnKN.Text = CCHCM_DanSu_ChanhAnKN.ToString("#,0.##", cul);
                    ltr_CCHCM_DanSu_DaXetXuGDT.Text = Convert.ToDecimal(row["DaXetXuGDT"]).ToString("#,0.##", cul);
                    if (CCHCM_DanSu_VienTruongKN + CCHCM_DanSu_ChanhAnKN > 0)
                    {
                        ltr_CCHCM_DanSu_TyLe.Text = Math.Round((Convert.ToDecimal(row["DaXetXuGDT"]) / (CCHCM_DanSu_VienTruongKN + CCHCM_DanSu_ChanhAnKN) * 100), MidpointRounding.AwayFromZero).ToString("#,0.##", cul);
                    }
                    ltr_CCHCM_DanSu_ConLai.Text = Convert.ToDecimal(row["ChuaXetXuGDT"]).ToString("#,0.##", cul);
                    ltr_CCHCM_DanSu_QuaHanLuatDinh.Text = Convert.ToDecimal(row["QuaHanLuatDinh"]).ToString("#,0.##", cul);
                    ltr_CCHCM_DanSu_RutKN.Text = Convert.ToDecimal(row["RutKN"]).ToString("#,0.##", cul);
                    ltr_CCHCM_DanSu_KoChapNhanKNCuaVT.Text = Convert.ToDecimal(row["KoChapNhanKNCuaVT"]).ToString("#,0.##", cul);
                    ltr_CCHCM_DanSu_HuyBanAn.Text = Convert.ToDecimal(row["HuyBanAn"]).ToString("#,0.##", cul);
                }
                #endregion
                #region TAND CC tại TP Hồ Chí Minh -- Kinh doanh thương mại
                tbl = null;
                cache_name = "cache_GSTP_Page2_GDT_CC_HoChiMinh_AKT" + DonViID;
                if (Cache[cache_name] == null)
                {
                    prm = new OracleParameter[]
                    {
                    new OracleParameter("curr_loaian",AnKinhTe),
                    new OracleParameter("curr_toaanid",ToaCapCao_HCM),
                    new OracleParameter("curr_vu_gdkt",Vu_GDT),
                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
                    tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_ThongKeChung_TheoAn", prm);
                    Cache.Add(cache_name, tbl, null, DateTime.Now.AddMinutes(720), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
                }
                else
                {
                    tbl = (DataTable)Cache[cache_name];
                }
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    DataRow row = tbl.Rows[0];
                    #region Cộng dồn vào biến tổng
                    Tong_DonTrung = Tong_DonTrung + Convert.ToDecimal(row["DonTrung"]);
                    Tong_DonMoi = Tong_DonMoi + Convert.ToDecimal(row["DonMoi"]);
                    Tong_DaGiaiQuyet = Tong_DaGiaiQuyet + Convert.ToDecimal(row["DaGiaiQuyet"]);
                    Tong_ChuaGiaiQuyet = Tong_ChuaGiaiQuyet + Convert.ToDecimal(row["ChuaGiaiQuyet"]);
                    Tong_AnThoiHieu = Tong_AnThoiHieu + Convert.ToDecimal(row["AnThoiHieu"]);
                    decimal Vu2_KinhTe_VienTruongKN = Convert.ToDecimal(row["VienTruongKN"]),
                            Vu2_KinhTe_ChanhAnKN = Convert.ToDecimal(row["ChanhAnKN"]);
                    Tong_VienTruongKN = Tong_VienTruongKN + Vu2_KinhTe_VienTruongKN;
                    Tong_ChanhAnKN = Tong_ChanhAnKN + Vu2_KinhTe_ChanhAnKN;
                    Tong_DaXetXuGDT = Tong_DaXetXuGDT + Convert.ToDecimal(row["DaXetXuGDT"]);
                    Tong_ConLai = Tong_ConLai + Convert.ToDecimal(row["ChuaXetXuGDT"]);
                    Tong_QuaHanLuatDinh = Tong_QuaHanLuatDinh + Convert.ToDecimal(row["QuaHanLuatDinh"]);
                    Tong_RutKN = Tong_RutKN + Convert.ToDecimal(row["RutKN"]);
                    Tong_KoChapNhanKNCuaVT = Tong_KoChapNhanKNCuaVT + Convert.ToDecimal(row["KoChapNhanKNCuaVT"]);
                    Tong_HuyBanAn = Tong_HuyBanAn + Convert.ToDecimal(row["HuyBanAn"]);
                    #endregion
                    ltr_CCHCM_KinhTe_DonTrung.Text = Convert.ToDecimal(row["DonTrung"]).ToString("#,0.##", cul);
                    ltr_CCHCM_KinhTe_DonMoi.Text = Convert.ToDecimal(row["DonMoi"]).ToString("#,0.##", cul);
                    ltr_CCHCM_KinhTe_DaGiaiQuyet.Text = Convert.ToDecimal(row["DaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_CCHCM_KinhTe_ChuaGiaiQuyet.Text = Convert.ToDecimal(row["ChuaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_CCHCM_KinhTe_AnThoiHieu.Text = Convert.ToDecimal(row["AnThoiHieu"]).ToString("#,0.##", cul);
                    decimal CCHCM_KinhTe_VienTruongKN = Convert.ToDecimal(row["VienTruongKN"]),
                            CCHCM_KinhTe_ChanhAnKN = Convert.ToDecimal(row["ChanhAnKN"]);
                    ltr_CCHCM_KinhTe_VienTruongKN.Text = CCHCM_KinhTe_VienTruongKN.ToString("#,0.##", cul);
                    ltr_CCHCM_KinhTe_ChanhAnKN.Text = CCHCM_KinhTe_ChanhAnKN.ToString("#,0.##", cul);
                    ltr_CCHCM_KinhTe_DaXetXuGDT.Text = Convert.ToDecimal(row["DaXetXuGDT"]).ToString("#,0.##", cul);
                    if (CCHCM_KinhTe_VienTruongKN + CCHCM_KinhTe_ChanhAnKN > 0)
                    {
                        ltr_CCHCM_KinhTe_TyLe.Text = Math.Round((Convert.ToDecimal(row["DaXetXuGDT"]) / (CCHCM_KinhTe_VienTruongKN + CCHCM_KinhTe_ChanhAnKN) * 100), MidpointRounding.AwayFromZero).ToString("#,0.##", cul);
                    }
                    ltr_CCHCM_KinhTe_ConLai.Text = Convert.ToDecimal(row["ChuaXetXuGDT"]).ToString("#,0.##", cul);
                    ltr_CCHCM_KinhTe_QuaHanLuatDinh.Text = Convert.ToDecimal(row["QuaHanLuatDinh"]).ToString("#,0.##", cul);
                    ltr_CCHCM_KinhTe_RutKN.Text = Convert.ToDecimal(row["RutKN"]).ToString("#,0.##", cul);
                    ltr_CCHCM_KinhTe_KoChapNhanKNCuaVT.Text = Convert.ToDecimal(row["KoChapNhanKNCuaVT"]).ToString("#,0.##", cul);
                    ltr_CCHCM_KinhTe_HuyBanAn.Text = Convert.ToDecimal(row["HuyBanAn"]).ToString("#,0.##", cul);
                }
                #endregion
                #region TAND CC tại TP Hồ Chí Minh -- Hôn nhân và Gia đình
                tbl = null;
                cache_name = "cache_GSTP_Page2_GDT_CC_HoChiMinh_AHN" + DonViID;
                if (Cache[cache_name] == null)
                {
                    prm = new OracleParameter[]
                    {
                    new OracleParameter("curr_loaian",AnHNGD),
                    new OracleParameter("curr_toaanid",ToaCapCao_HCM),
                    new OracleParameter("curr_vu_gdkt",Vu_GDT),
                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
                    tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_ThongKeChung_TheoAn", prm);
                    Cache.Add(cache_name, tbl, null, DateTime.Now.AddMinutes(720), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
                }
                else
                {
                    tbl = (DataTable)Cache[cache_name];
                }
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    DataRow row = tbl.Rows[0];
                    #region Cộng dồn vào biến tổng
                    Tong_DonTrung = Tong_DonTrung + Convert.ToDecimal(row["DonTrung"]);
                    Tong_DonMoi = Tong_DonMoi + Convert.ToDecimal(row["DonMoi"]);
                    Tong_DaGiaiQuyet = Tong_DaGiaiQuyet + Convert.ToDecimal(row["DaGiaiQuyet"]);
                    Tong_ChuaGiaiQuyet = Tong_ChuaGiaiQuyet + Convert.ToDecimal(row["ChuaGiaiQuyet"]);
                    Tong_AnThoiHieu = Tong_AnThoiHieu + Convert.ToDecimal(row["AnThoiHieu"]);
                    decimal Vu2_KinhTe_VienTruongKN = Convert.ToDecimal(row["VienTruongKN"]),
                            Vu2_KinhTe_ChanhAnKN = Convert.ToDecimal(row["ChanhAnKN"]);
                    Tong_VienTruongKN = Tong_VienTruongKN + Vu2_KinhTe_VienTruongKN;
                    Tong_ChanhAnKN = Tong_ChanhAnKN + Vu2_KinhTe_ChanhAnKN;
                    Tong_DaXetXuGDT = Tong_DaXetXuGDT + Convert.ToDecimal(row["DaXetXuGDT"]);
                    Tong_ConLai = Tong_ConLai + Convert.ToDecimal(row["ChuaXetXuGDT"]);
                    Tong_QuaHanLuatDinh = Tong_QuaHanLuatDinh + Convert.ToDecimal(row["QuaHanLuatDinh"]);
                    Tong_RutKN = Tong_RutKN + Convert.ToDecimal(row["RutKN"]);
                    Tong_KoChapNhanKNCuaVT = Tong_KoChapNhanKNCuaVT + Convert.ToDecimal(row["KoChapNhanKNCuaVT"]);
                    Tong_HuyBanAn = Tong_HuyBanAn + Convert.ToDecimal(row["HuyBanAn"]);
                    #endregion
                    ltr_CCHCM_HNGD_DonTrung.Text = Convert.ToDecimal(row["DonTrung"]).ToString("#,0.##", cul);
                    ltr_CCHCM_HNGD_DonMoi.Text = Convert.ToDecimal(row["DonMoi"]).ToString("#,0.##", cul);
                    ltr_CCHCM_HNGD_DaGiaiQuyet.Text = Convert.ToDecimal(row["DaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_CCHCM_HNGD_ChuaGiaiQuyet.Text = Convert.ToDecimal(row["ChuaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_CCHCM_HNGD_AnThoiHieu.Text = Convert.ToDecimal(row["AnThoiHieu"]).ToString("#,0.##", cul);
                    decimal CCHCM_HNGD_VienTruongKN = Convert.ToDecimal(row["VienTruongKN"]),
                            CCHCM_HNGD_ChanhAnKN = Convert.ToDecimal(row["ChanhAnKN"]);
                    ltr_CCHCM_HNGD_VienTruongKN.Text = CCHCM_HNGD_VienTruongKN.ToString("#,0.##", cul);
                    ltr_CCHCM_HNGD_ChanhAnKN.Text = CCHCM_HNGD_ChanhAnKN.ToString("#,0.##", cul);
                    ltr_CCHCM_HNGD_DaXetXuGDT.Text = Convert.ToDecimal(row["DaXetXuGDT"]).ToString("#,0.##", cul);
                    if (CCHCM_HNGD_VienTruongKN + CCHCM_HNGD_ChanhAnKN > 0)
                    {
                        ltr_CCHCM_HNGD_TyLe.Text = Math.Round((Convert.ToDecimal(row["DaXetXuGDT"]) / (CCHCM_HNGD_VienTruongKN + CCHCM_HNGD_ChanhAnKN) * 100), MidpointRounding.AwayFromZero).ToString("#,0.##", cul);
                    }
                    ltr_CCHCM_HNGD_ConLai.Text = Convert.ToDecimal(row["ChuaXetXuGDT"]).ToString("#,0.##", cul);
                    ltr_CCHCM_HNGD_QuaHanLuatDinh.Text = Convert.ToDecimal(row["QuaHanLuatDinh"]).ToString("#,0.##", cul);
                    ltr_CCHCM_HNGD_RutKN.Text = Convert.ToDecimal(row["RutKN"]).ToString("#,0.##", cul);
                    ltr_CCHCM_HNGD_KoChapNhanKNCuaVT.Text = Convert.ToDecimal(row["KoChapNhanKNCuaVT"]).ToString("#,0.##", cul);
                    ltr_CCHCM_HNGD_HuyBanAn.Text = Convert.ToDecimal(row["HuyBanAn"]).ToString("#,0.##", cul);
                }
                #endregion
                #region TAND CC tại TP Hồ Chí Minh -- Hành chính
                tbl = null;
                cache_name = "cache_GSTP_Page2_GDT_CC_HoChiMinh_AHC" + DonViID;
                if (Cache[cache_name] == null)
                {
                    prm = new OracleParameter[]
                    {
                    new OracleParameter("curr_loaian",AnHanhChinh),
                    new OracleParameter("curr_toaanid",ToaCapCao_HCM),
                    new OracleParameter("curr_vu_gdkt",Vu_GDT),
                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
                    tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_ThongKeChung_TheoAn", prm);
                    Cache.Add(cache_name, tbl, null, DateTime.Now.AddMinutes(720), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
                }
                else
                {
                    tbl = (DataTable)Cache[cache_name];
                }
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    DataRow row = tbl.Rows[0];
                    #region Cộng dồn vào biến tổng
                    Tong_DonTrung = Tong_DonTrung + Convert.ToDecimal(row["DonTrung"]);
                    Tong_DonMoi = Tong_DonMoi + Convert.ToDecimal(row["DonMoi"]);
                    Tong_DaGiaiQuyet = Tong_DaGiaiQuyet + Convert.ToDecimal(row["DaGiaiQuyet"]);
                    Tong_ChuaGiaiQuyet = Tong_ChuaGiaiQuyet + Convert.ToDecimal(row["ChuaGiaiQuyet"]);
                    Tong_AnThoiHieu = Tong_AnThoiHieu + Convert.ToDecimal(row["AnThoiHieu"]);
                    decimal Vu2_KinhTe_VienTruongKN = Convert.ToDecimal(row["VienTruongKN"]),
                            Vu2_KinhTe_ChanhAnKN = Convert.ToDecimal(row["ChanhAnKN"]);
                    Tong_VienTruongKN = Tong_VienTruongKN + Vu2_KinhTe_VienTruongKN;
                    Tong_ChanhAnKN = Tong_ChanhAnKN + Vu2_KinhTe_ChanhAnKN;
                    Tong_DaXetXuGDT = Tong_DaXetXuGDT + Convert.ToDecimal(row["DaXetXuGDT"]);
                    Tong_ConLai = Tong_ConLai + Convert.ToDecimal(row["ChuaXetXuGDT"]);
                    Tong_QuaHanLuatDinh = Tong_QuaHanLuatDinh + Convert.ToDecimal(row["QuaHanLuatDinh"]);
                    Tong_RutKN = Tong_RutKN + Convert.ToDecimal(row["RutKN"]);
                    Tong_KoChapNhanKNCuaVT = Tong_KoChapNhanKNCuaVT + Convert.ToDecimal(row["KoChapNhanKNCuaVT"]);
                    Tong_HuyBanAn = Tong_HuyBanAn + Convert.ToDecimal(row["HuyBanAn"]);
                    #endregion
                    ltr_CCHCM_HanhChinh_DonTrung.Text = Convert.ToDecimal(row["DonTrung"]).ToString("#,0.##", cul);
                    ltr_CCHCM_HanhChinh_DonMoi.Text = Convert.ToDecimal(row["DonMoi"]).ToString("#,0.##", cul);
                    ltr_CCHCM_HanhChinh_DaGiaiQuyet.Text = Convert.ToDecimal(row["DaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_CCHCM_HanhChinh_ChuaGiaiQuyet.Text = Convert.ToDecimal(row["ChuaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_CCHCM_HanhChinh_AnThoiHieu.Text = Convert.ToDecimal(row["AnThoiHieu"]).ToString("#,0.##", cul);
                    decimal CCHCM_HanhChinh_VienTruongKN = Convert.ToDecimal(row["VienTruongKN"]),
                            CCHCM_HanhChinh_ChanhAnKN = Convert.ToDecimal(row["ChanhAnKN"]);
                    ltr_CCHCM_HanhChinh_VienTruongKN.Text = CCHCM_HanhChinh_VienTruongKN.ToString("#,0.##", cul);
                    ltr_CCHCM_HanhChinh_ChanhAnKN.Text = CCHCM_HanhChinh_ChanhAnKN.ToString("#,0.##", cul);
                    ltr_CCHCM_HanhChinh_DaXetXuGDT.Text = Convert.ToDecimal(row["DaXetXuGDT"]).ToString("#,0.##", cul);
                    if (CCHCM_HanhChinh_VienTruongKN + CCHCM_HanhChinh_ChanhAnKN > 0)
                    {
                        ltr_CCHCM_HanhChinh_TyLe.Text = Math.Round((Convert.ToDecimal(row["DaXetXuGDT"]) / (CCHCM_HanhChinh_VienTruongKN + CCHCM_HanhChinh_ChanhAnKN) * 100), MidpointRounding.AwayFromZero).ToString("#,0.##", cul);
                    }
                    ltr_CCHCM_HanhChinh_ConLai.Text = Convert.ToDecimal(row["ChuaXetXuGDT"]).ToString("#,0.##", cul);
                    ltr_CCHCM_HanhChinh_QuaHanLuatDinh.Text = Convert.ToDecimal(row["QuaHanLuatDinh"]).ToString("#,0.##", cul);
                    ltr_CCHCM_HanhChinh_RutKN.Text = Convert.ToDecimal(row["RutKN"]).ToString("#,0.##", cul);
                    ltr_CCHCM_HanhChinh_KoChapNhanKNCuaVT.Text = Convert.ToDecimal(row["KoChapNhanKNCuaVT"]).ToString("#,0.##", cul);
                    ltr_CCHCM_HanhChinh_HuyBanAn.Text = Convert.ToDecimal(row["HuyBanAn"]).ToString("#,0.##", cul);
                }
                #endregion
                #region TAND CC tại TP Hồ Chí Minh -- Lao động
                tbl = null;
                cache_name = "cache_GSTP_Page2_GDT_CC_HoChiMinh_ALD" + DonViID;
                if (Cache[cache_name] == null)
                {
                    prm = new OracleParameter[]
                    {
                    new OracleParameter("curr_loaian",AnLaoDong),
                    new OracleParameter("curr_toaanid",ToaCapCao_HCM),
                    new OracleParameter("curr_vu_gdkt",Vu_GDT),
                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
                    tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_ThongKeChung_TheoAn", prm);
                    Cache.Add(cache_name, tbl, null, DateTime.Now.AddMinutes(720), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
                }
                else
                {
                    tbl = (DataTable)Cache[cache_name];
                }
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    DataRow row = tbl.Rows[0];
                    #region Cộng dồn vào biến tổng
                    Tong_DonTrung = Tong_DonTrung + Convert.ToDecimal(row["DonTrung"]);
                    Tong_DonMoi = Tong_DonMoi + Convert.ToDecimal(row["DonMoi"]);
                    Tong_DaGiaiQuyet = Tong_DaGiaiQuyet + Convert.ToDecimal(row["DaGiaiQuyet"]);
                    Tong_ChuaGiaiQuyet = Tong_ChuaGiaiQuyet + Convert.ToDecimal(row["ChuaGiaiQuyet"]);
                    Tong_AnThoiHieu = Tong_AnThoiHieu + Convert.ToDecimal(row["AnThoiHieu"]);
                    decimal Vu2_KinhTe_VienTruongKN = Convert.ToDecimal(row["VienTruongKN"]),
                            Vu2_KinhTe_ChanhAnKN = Convert.ToDecimal(row["ChanhAnKN"]);
                    Tong_VienTruongKN = Tong_VienTruongKN + Vu2_KinhTe_VienTruongKN;
                    Tong_ChanhAnKN = Tong_ChanhAnKN + Vu2_KinhTe_ChanhAnKN;
                    Tong_DaXetXuGDT = Tong_DaXetXuGDT + Convert.ToDecimal(row["DaXetXuGDT"]);
                    Tong_ConLai = Tong_ConLai + Convert.ToDecimal(row["ChuaXetXuGDT"]);
                    Tong_QuaHanLuatDinh = Tong_QuaHanLuatDinh + Convert.ToDecimal(row["QuaHanLuatDinh"]);
                    Tong_RutKN = Tong_RutKN + Convert.ToDecimal(row["RutKN"]);
                    Tong_KoChapNhanKNCuaVT = Tong_KoChapNhanKNCuaVT + Convert.ToDecimal(row["KoChapNhanKNCuaVT"]);
                    Tong_HuyBanAn = Tong_HuyBanAn + Convert.ToDecimal(row["HuyBanAn"]);
                    #endregion
                    ltr_CCHCM_LaoDong_DonTrung.Text = Convert.ToDecimal(row["DonTrung"]).ToString("#,0.##", cul);
                    ltr_CCHCM_LaoDong_DonMoi.Text = Convert.ToDecimal(row["DonMoi"]).ToString("#,0.##", cul);
                    ltr_CCHCM_LaoDong_DaGiaiQuyet.Text = Convert.ToDecimal(row["DaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_CCHCM_LaoDong_ChuaGiaiQuyet.Text = Convert.ToDecimal(row["ChuaGiaiQuyet"]).ToString("#,0.##", cul);
                    ltr_CCHCM_LaoDong_AnThoiHieu.Text = Convert.ToDecimal(row["AnThoiHieu"]).ToString("#,0.##", cul);
                    decimal CCHCM_LaoDong_VienTruongKN = Convert.ToDecimal(row["VienTruongKN"]),
                            CCHCM_LaoDong_ChanhAnKN = Convert.ToDecimal(row["ChanhAnKN"]);
                    ltr_CCHCM_LaoDong_VienTruongKN.Text = CCHCM_LaoDong_VienTruongKN.ToString("#,0.##", cul);
                    ltr_CCHCM_LaoDong_ChanhAnKN.Text = CCHCM_LaoDong_ChanhAnKN.ToString("#,0.##", cul);
                    ltr_CCHCM_LaoDong_DaXetXuGDT.Text = Convert.ToDecimal(row["DaXetXuGDT"]).ToString("#,0.##", cul);
                    if (CCHCM_LaoDong_VienTruongKN + CCHCM_LaoDong_ChanhAnKN > 0)
                    {
                        ltr_CCHCM_LaoDong_TyLe.Text = Math.Round((Convert.ToDecimal(row["DaXetXuGDT"]) / (CCHCM_LaoDong_VienTruongKN + CCHCM_LaoDong_ChanhAnKN) * 100), MidpointRounding.AwayFromZero).ToString("#,0.##", cul);
                    }
                    ltr_CCHCM_LaoDong_ConLai.Text = Convert.ToDecimal(row["ChuaXetXuGDT"]).ToString("#,0.##", cul);
                    ltr_CCHCM_LaoDong_QuaHanLuatDinh.Text = Convert.ToDecimal(row["QuaHanLuatDinh"]).ToString("#,0.##", cul);
                    ltr_CCHCM_LaoDong_RutKN.Text = Convert.ToDecimal(row["RutKN"]).ToString("#,0.##", cul);
                    ltr_CCHCM_LaoDong_KoChapNhanKNCuaVT.Text = Convert.ToDecimal(row["KoChapNhanKNCuaVT"]).ToString("#,0.##", cul);
                    ltr_CCHCM_LaoDong_HuyBanAn.Text = Convert.ToDecimal(row["HuyBanAn"]).ToString("#,0.##", cul);
                }
                #endregion
                #region TAND CC tại TP Hồ Chí Minh -- Tổng cộng
                ltr_CCHCM_Tong_DonTrung.Text = Tong_DonTrung.ToString("#,0.##", cul);
                ltr_CCHCM_Tong_DonMoi.Text = Tong_DonMoi.ToString("#,0.##", cul);
                ltr_CCHCM_Tong_DaGiaiQuyet.Text = Tong_DaGiaiQuyet.ToString("#,0.##", cul);
                ltr_CCHCM_Tong_ChuaGiaiQuyet.Text = Tong_ChuaGiaiQuyet.ToString("#,0.##", cul);
                ltr_CCHCM_Tong_AnThoiHieu.Text = Tong_AnThoiHieu.ToString("#,0.##", cul);
                ltr_CCHCM_Tong_VienTruongKN.Text = Tong_VienTruongKN.ToString("#,0.##", cul);
                ltr_CCHCM_Tong_ChanhAnKN.Text = Tong_ChanhAnKN.ToString("#,0.##", cul);
                ltr_CCHCM_Tong_DaXetXuGDT.Text = Tong_DaXetXuGDT.ToString("#,0.##", cul);
                if (Tong_VienTruongKN + Tong_ChanhAnKN > 0)
                {
                    ltr_CCHCM_Tong_TyLe.Text = Math.Round((Tong_DaXetXuGDT / (Tong_VienTruongKN + Tong_ChanhAnKN) * 100), MidpointRounding.AwayFromZero).ToString("#,0.##", cul);
                }
                ltr_CCHCM_Tong_ConLai.Text = Tong_ConLai.ToString("#,0.##", cul);
                ltr_CCHCM_Tong_QuaHanLuatDinh.Text = Tong_QuaHanLuatDinh.ToString("#,0.##", cul);
                ltr_CCHCM_Tong_RutKN.Text = Tong_RutKN.ToString("#,0.##", cul);
                ltr_CCHCM_Tong_KoChapNhanKNCuaVT.Text = Tong_KoChapNhanKNCuaVT.ToString("#,0.##", cul);
                ltr_CCHCM_Tong_HuyBanAn.Text = Tong_HuyBanAn.ToString("#,0.##", cul);
                #endregion}
            }
        }
    }
}