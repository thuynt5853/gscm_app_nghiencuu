using System;
using System.Collections.Generic;
using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BL.GSTP.GSTP;

namespace WEB.GSTP.GSTP
{
    public partial class Chitiet_PhucTham : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        GSTP_BL bl = new GSTP_BL();
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
                string TenToaAn = "", Ma_Ten_ToaAn = "", CapToa = "";
                DM_TOAAN otToaAN = dt.DM_TOAAN.Where(x => x.ID == DonViID).FirstOrDefault();
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
                if (Session["Page2_PT_prm"] != null)
                {
                    DonViID = Convert.ToDecimal(Session["Page2_PT_prm"] + "");
                }
                lblTitleTrang2.Text = "TÌNH HÌNH TỔNG HỢP THỤ LÝ, GIẢI QUYẾT CÁC LOẠI VỤ ÁN GIAI ĐOẠN PHÚC THẨM CỦA CẢ NƯỚC";
                bool IsTongHop = true;
                if (DonViID != 0)
                {
                    string TenToa = "";
                    DM_TOAAN ta = dt.DM_TOAAN.Where(x => x.ID == DonViID).FirstOrDefault();
                    if (ta != null)
                    {
                        TenToa = ta.TEN.ToLower().Replace("tòa án nhân dân", "TAND").Replace("tòa án quân sự", "TAQS");
                        lblTitleTrang2.Text = "TÌNH HÌNH TỔNG HỢP THỤ LÝ, GIẢI QUYẾT CÁC LOẠI VỤ ÁN GIAI ĐOẠN PHÚC THẨM CỦA " + TenToa;
                    }
                    if (TenToa.Contains("TAQS"))// TAQS chỉ tổng hợp loại án hình sự nên cần thay đổi giao diện
                    {
                        MenuLeft.Style.Add("height", "799px !important");
                        MenuLeft_ex.Style.Add("height", "799px !important");
                        td_NoiDung.Style.Add("height", "703px !important");
                        IsTongHop = false;
                        panDS.Visible = false;
                        panHN.Visible = false;
                        panKT.Visible = false;
                        panHC.Visible = false;
                        panLD.Visible = false;
                    }
                    else
                    {
                        MenuLeft.Style.Add("height", "1729px !important");
                        MenuLeft_ex.Style.Add("height", "1729px !important");
                    }
                }
                LoadGSTP_PAGE2_PHUCTHAM_HINHSU(DonViID);
                if (IsTongHop)// TAQS chỉ tổng hợp loại án hình sự
                {
                    LoadGSTP_PAGE2_PHUCTHAM_DANSU(DonViID);
                    LoadGSTP_PAGE2_PHUCTHAM_HNGD(DonViID);
                    LoadGSTP_PAGE2_PHUCTHAM_KINHTE(DonViID);
                    LoadGSTP_PAGE2_PHUCTHAM_HANHCHINH(DonViID);
                    LoadGSTP_PAGE2_PHUCTHAM_LAODONG(DonViID);
                }
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
        private void LoadGSTP_PAGE2_PHUCTHAM_HINHSU(decimal DonViLoginID)
        {
            string cache_name = "cache_GSTP_PAGE2_PHUCTHAM_HINHSU_" + DonViLoginID;
            DataTable tbl = new DataTable();
            if (Cache[cache_name] == null)
            {
                tbl = bl.GSTP_PAGE2_PHUCTHAM_HINHSU(DonViLoginID);
                Cache.Add(cache_name, tbl, null, DateTime.Now.AddMinutes(720), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
            }
            else
            {
                tbl = (DataTable)Cache[cache_name];
            }
            rpt_HinhSu.DataSource = tbl;
            rpt_HinhSu.DataBind();
        }
        private void LoadGSTP_PAGE2_PHUCTHAM_DANSU(decimal DonViLoginID)
        {
            string cache_name = "cache_GSTP_PAGE2_PHUCTHAM_DANSU_" + DonViLoginID;
            DataTable tbl = new DataTable();
            if (Cache[cache_name] == null)
            {
                tbl = bl.GSTP_PAGE2_PHUCTHAM_DANSU(DonViLoginID);
                Cache.Add(cache_name, tbl, null, DateTime.Now.AddMinutes(720), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
            }
            else
            {
                tbl = (DataTable)Cache[cache_name];
            }
            rpt_DanSu.DataSource = tbl;
            rpt_DanSu.DataBind();
        }
        private void LoadGSTP_PAGE2_PHUCTHAM_HNGD(decimal DonViLoginID)
        {
            string cache_name = "cache_GSTP_PAGE2_PHUCTHAM_HNGD_" + DonViLoginID;
            DataTable tbl = new DataTable();
            if (Cache[cache_name] == null)
            {
                tbl = bl.GSTP_PAGE2_PHUCTHAM_HNGD(DonViLoginID);
                Cache.Add(cache_name, tbl, null, DateTime.Now.AddMinutes(720), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
            }
            else
            {
                tbl = (DataTable)Cache[cache_name];
            }
            rpt_HNGD.DataSource = tbl;
            rpt_HNGD.DataBind();
        }
        private void LoadGSTP_PAGE2_PHUCTHAM_KINHTE(decimal DonViLoginID)
        {
            string cache_name = "cache_GSTP_PAGE2_PHUCTHAM_KINHTE_" + DonViLoginID;
            DataTable tbl = new DataTable();
            if (Cache[cache_name] == null)
            {
                tbl = bl.GSTP_PAGE2_PHUCTHAM_KINHTE(DonViLoginID);
                Cache.Add(cache_name, tbl, null, DateTime.Now.AddMinutes(720), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
            }
            else
            {
                tbl = (DataTable)Cache[cache_name];
            }
            rpt_KinhTe.DataSource = tbl;
            rpt_KinhTe.DataBind();
        }
        private void LoadGSTP_PAGE2_PHUCTHAM_HANHCHINH(decimal DonViLoginID)
        {
            string cache_name = "cache_GSTP_PAGE2_PHUCTHAM_HANHCHINH_" + DonViLoginID;
            DataTable tbl = new DataTable();
            if (Cache[cache_name] == null)
            {
                tbl = bl.GSTP_PAGE2_PHUCTHAM_HANHCHINH(DonViLoginID);
                Cache.Add(cache_name, tbl, null, DateTime.Now.AddMinutes(720), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
            }
            else
            {
                tbl = (DataTable)Cache[cache_name];
            }
            rpt_HanhChinh.DataSource = tbl;
            rpt_HanhChinh.DataBind();
        }
        private void LoadGSTP_PAGE2_PHUCTHAM_LAODONG(decimal DonViLoginID)
        {
            string cache_name = "cache_GSTP_PAGE2_PHUCTHAM_LAODONG_" + DonViLoginID;
            DataTable tbl = new DataTable();
            if (Cache[cache_name] == null)
            {
                tbl = bl.GSTP_PAGE2_PHUCTHAM_LAODONG(DonViLoginID);
                Cache.Add(cache_name, tbl, null, DateTime.Now.AddMinutes(720), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
            }
            else
            {
                tbl = (DataTable)Cache[cache_name];
            }
            //DataRow[] rows = tbl.Select("V_CAPTOA='Cộng'");
            rpt_LaoDong.DataSource = tbl;
            rpt_LaoDong.DataBind();
        }
    }
}