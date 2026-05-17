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
using BL.GSTP.BANGSETGET;

namespace WEB.GSTP.QLAN.GDTTT.Giaiquyet.Popup
{
    public partial class GiaoNhanTHS : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        DataTable lstTTV;
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
        Decimal CurrentUserID = 0, CurrPhongBanID =0;
        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            scriptManager.RegisterPostBackControl(this.cmdPrint);
            //---------------------------
            CurrentUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            CurrPhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "") ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + ""));
            if (CurrentUserID == 0)
                Response.Redirect("/Login.aspx");
            else
            {
                if (!IsPostBack)
                {
                    Load_Data();
                }


            }
        }


        private DataTable getDS()
        {
            GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            Decimal LoginDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            lstTTV = oGDTBL.GDTTT_VuAn_GetAllCBTheoPB(LoginDonViID, PBID, ENUM_CHUCDANH.CHUCDANH_TTV);

            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            decimal ToaRaBAQD = 0, HinhThucDon = 0, DiaChiTinh = 0, DiaChiHuyen = 0, TraLoi = 0, vNoichuyen = 0, vTrangthai = 0, vCD_DONVIID = 0, vCD_TA_TRANGTHAI = 0, vIsThuLy = 0, vPhanloaixuly = 0, vPhancongTTV = 0;
            string SoBAQD, NgayBAQD, NguoiGui, SoCMND, SoHieuDon, DiaChiCT, SoCongVan, NgayCongVan, strNguoiNhap = "", vArrSelectID = "";
            DateTime? vNgaychuyenTu, vNgaychuyenDen, vNgayThulyTu, vNgayThulyDen, vNgayNhapTu, vNgayNhapDen;
            string vSoThuly;
            int status_ghepvuan = 0;
            decimal vLoaiAn = 0;
            NguoiGui = Session[SS_TK.NGUOIGUI] + "";
            SoBAQD = Session[SS_TK.SOBAQD] + "";
            NgayBAQD = Session[SS_TK.NGAYBAQD] + "";
            if (Session[SS_TK.TOAANXX] != null)
                ToaRaBAQD = Convert.ToDecimal(Session[SS_TK.TOAANXX]);
            if (Session[SS_TK.HINHTHUCDON] != null) HinhThucDon = Convert.ToDecimal(Session[SS_TK.HINHTHUCDON]);
            if (Session[SS_TK.TINHID] != null) DiaChiTinh = Convert.ToDecimal(Session[SS_TK.TINHID]);
            if (Session[SS_TK.HUYENID] != null) DiaChiHuyen = Convert.ToDecimal(Session[SS_TK.HUYENID]);
            DiaChiCT = Session[SS_TK.DIACHICHITIET] + "";
            if (Session[SS_TK.TRALOIDON] != null) TraLoi = Convert.ToDecimal(Session[SS_TK.TRALOIDON]);
            strNguoiNhap = Session[SS_TK.NGUOINHAP] + "";
            SoCMND = Session[SS_TK.SOCMND] + "";
            SoHieuDon = Session[SS_TK.MADON] + "";
            SoCongVan = Session[SS_TK.SOCV] + "";
            NgayCongVan = Session[SS_TK.NGAYCV] + "";
            vNgayNhapTu = (Session[SS_TK.NGAYNHANTU] + "") == "" ? (DateTime?)null : DateTime.Parse((Session[SS_TK.NGAYNHANTU] + ""), cul, DateTimeStyles.NoCurrentDateDefault);
            vNgayNhapDen = (Session[SS_TK.NGAYNHANDEN] + "") == "" ? (DateTime?)null : DateTime.Parse((Session[SS_TK.NGAYNHANDEN] + " 23:59:59"), cul, DateTimeStyles.NoCurrentDateDefault);
            //DateTime? TuNgay = txtNgayNhanTu.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayNhanTu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            //DateTime? DenNgay = txtNgayNhanDen.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayNhanDen.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            vArrSelectID = Session[SS_TK.ARRSELECTID] + "";

            vNoichuyen = -1;
            if (Session[SS_TK.TRANGTHAICHUYEN] != null) vTrangthai = Convert.ToDecimal(Session[SS_TK.TRANGTHAICHUYEN]);
            //if (Session[SS_TK.TOAKHACID] != null && vNoichuyen > 0) vCD_DONVIID = Convert.ToDecimal(Session[SS_TK.TOAKHACID]);
            vCD_DONVIID = CurrPhongBanID;


            vNgaychuyenTu = (Session[SS_TK.NGAYCHUYENTU] + "") == "" ? (DateTime?)null : DateTime.Parse((Session[SS_TK.NGAYCHUYENTU] + ""), cul, DateTimeStyles.NoCurrentDateDefault);
            vNgaychuyenDen = (Session[SS_TK.NGAYCHUYENDEN] + "") == "" ? (DateTime?)null : DateTime.Parse((Session[SS_TK.NGAYCHUYENDEN] + ""), cul, DateTimeStyles.NoCurrentDateDefault);

            if (Session[SS_TK.THULYDON] != null) vIsThuLy = Convert.ToDecimal(Session[SS_TK.THULYDON]);

            vPhanloaixuly = 0;
            // Convert.ToDecimal(ddlPhanloaiDdon.SelectedValue);

            vNgayThulyTu = (Session[SS_TK.THULY_TU] + "") == "" ? (DateTime?)null : DateTime.Parse((Session[SS_TK.THULY_TU] + ""), cul, DateTimeStyles.NoCurrentDateDefault);
            vNgayThulyDen = (Session[SS_TK.THULY_DEN] + "") == "" ? (DateTime?)null : DateTime.Parse((Session[SS_TK.THULY_DEN] + ""), cul, DateTimeStyles.NoCurrentDateDefault);

            vSoThuly = Session[SS_TK.SOTHULY] + "";
            if (Session[SS_TK.THAMTRAVIEN] != null) vPhancongTTV = Convert.ToDecimal(Session[SS_TK.THAMTRAVIEN]);
            if (Session[SS_TK.GhepDon_VuAn] != null) status_ghepvuan = Convert.ToInt32(Session[SS_TK.GhepDon_VuAn]);
            decimal status_giaoths = 0;
            if (Session[SS_TK.GIAOTHS] != null) status_giaoths = Convert.ToInt32(Session[SS_TK.GIAOTHS]);

            //them loai an 
            if (Session[SS_TK.LOAIAN] != null) vLoaiAn = Convert.ToDecimal(Session[SS_TK.LOAIAN]);
            int page_size = Convert.ToInt32(ddlPageCount.SelectedValue);
            int pageindex = Convert.ToInt32(hddPageIndex.Value);


            //anhvh phân quyên liên quan đến án tử hình
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            decimal _ISXINANGIAM = Convert.ToDecimal(oPer.ISXINANGIAM);
            decimal _GDT_ISXINANGIAM = Convert.ToDecimal(oPer.GDT_ISXINANGIAM);
            //------------------- GDTTT_GIAONHAN_THS
            DataTable oDT = oBL.GDTTT_GIAONHAN_THS(ToaAnID, ToaRaBAQD, SoBAQD, NgayBAQD, NguoiGui,
               SoCMND, vNgayNhapTu, vNgayNhapDen, HinhThucDon, SoHieuDon, DiaChiTinh, DiaChiHuyen
               , DiaChiCT, SoCongVan, NgayCongVan, TraLoi, strNguoiNhap, vNoichuyen,
               vTrangthai, vCD_DONVIID, vNgaychuyenTu, vNgaychuyenDen
               , vArrSelectID, vIsThuLy, vPhanloaixuly
               , vNgayThulyTu, vNgayThulyDen, vSoThuly, vPhancongTTV, vLoaiAn, status_giaoths, status_ghepvuan, _ISXINANGIAM, _GDT_ISXINANGIAM
               , pageindex, page_size);
            return oDT;
        }
        private void Load_Data()
        {
            DataTable oDT = getDS();
            int count_all = 0;
            if (oDT.Rows.Count > 0)
                count_all = Convert.ToInt32(oDT.Rows[0]["CountAll"] + "");
            if (oDT != null && count_all > 0)
            {
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, Convert.ToInt32(ddlPageCount.SelectedValue)).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString() + " </b> đơn trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
            }
            else
            {
                hddTotalPage.Value = "1";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                           lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                lstSobanghiT.Text = lstSobanghiB.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";
            }
            dgList.PageSize = Convert.ToInt32(ddlPageCount.SelectedValue);
            dgList.DataSource = oDT;
            dgList.DataBind();
            if (dgList.PageCount >= Convert.ToDecimal(hddTotalPage.Value))
            {
                cmdLuuAndNext.Visible = false;
                cmdLuu.Text = "Lưu";
            }
            else
                cmdLuu.Text = "Lưu";

        }

        private void SaveData()
        {
            foreach (DataGridItem item in dgList.Items)
            {
                DropDownList ddlNguoiGiao = (DropDownList)item.FindControl("ddlNguoiGiao");
                DropDownList ddlNguoiNhan = (DropDownList)item.FindControl("ddlNguoiNhan");
                TextBox txtNGAYNHANTHS = (TextBox)item.FindControl("txtNGAYNHANTHS");
                DateTime dNgayNhan = (String.IsNullOrEmpty(txtNGAYNHANTHS.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(txtNGAYNHANTHS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                TextBox txtGhiChu = (TextBox)item.FindControl("txtGhiChu");
                string strID = item.Cells[0].Text;
                decimal DON_ID = Convert.ToDecimal(strID);
                string strTHS_ID = item.Cells[1].Text;
                decimal giaonhanTHS_id = 0;
                try
                {
                    giaonhanTHS_id = Convert.ToDecimal(strTHS_ID);
                }
                catch (Exception ex)
                {
                    giaonhanTHS_id = 0;
                }
                GDTTT_DON_GIAONHAN_THS obj = new GDTTT_DON_GIAONHAN_THS();
                obj.ID = giaonhanTHS_id;
                obj.DONID = DON_ID;
                if (Convert.ToDecimal(ddlNguoiGiao.SelectedValue) > 0)
                    obj.NGUOICHUYEN_ID = Convert.ToDecimal(ddlNguoiGiao.SelectedValue);
                if (Convert.ToDecimal(ddlNguoiNhan.SelectedValue) > 0)
                    obj.NGUOINHAN_ID = Convert.ToDecimal(ddlNguoiNhan.SelectedValue);

                if (dNgayNhan != DateTime.MinValue)
                {
                    obj.NGAYCHUYEN = dNgayNhan;
                    obj.NGAYNHAN = dNgayNhan;
                }
                obj.GHICHU = txtGhiChu.Text;
                if (Convert.ToDecimal(ddlNguoiNhan.SelectedIndex) > 0 && Convert.ToDecimal(ddlNguoiGiao.SelectedIndex) > 0 && dNgayNhan != DateTime.MinValue)
                {
                    GDTTT_DON_BL bl = new GDTTT_DON_BL();
                    bl.GDTTT_DON_GIAONHAN_INSERT_UPDAT(obj);
                }

            }
        }
        protected void cmdLuu_Click(object sender, EventArgs e)
        {
            SaveData();
            Load_Data();
            lbthongbao.Text = "Lưu thành công trang hiện tại !";
        }
        protected void cmdLuuAndNext_Click(object sender, EventArgs e)
        {
            SaveData();
            lbthongbao.Text = "Lưu thành công trang hiện tại và chuyển sang trang tiếp !";
            if (dgList.CurrentPageIndex != Convert.ToDecimal(hddTotalPage.Value) - 1)
            {
                
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                Load_Data();
            }
            else
                lbthongbao.Text = "Lưu thành công trang hiện tại !";
        }
        protected void cmdPrint_Click(object sender, EventArgs e)
        {
            //String SessionName = "GDTTT_Don_ReportPL".ToUpper();
            ////--------------------------
            //String ReportName = "";

            //ReportName = "Danh sách giao Tiểu hồ sơ cho TTV ";
            //Session[SS_TK.TENBAOCAO] = ReportName.ToUpper();

            //DataTable tbl = getDS();
            //Session[SessionName] = tbl;

            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            lstTTV = oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_TTV);

            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            decimal ToaRaBAQD = 0, HinhThucDon = 0, DiaChiTinh = 0, DiaChiHuyen = 0, TraLoi = 0, vNoichuyen = 0, vTrangthai = 0, vCD_DONVIID = 0, vCD_TA_TRANGTHAI = 0, vIsThuLy = 0, vPhanloaixuly = 0, vPhancongTTV = 0;
            string SoBAQD, NgayBAQD, NguoiGui, SoCMND, SoHieuDon, DiaChiCT, SoCongVan, NgayCongVan, strNguoiNhap = "", vArrSelectID = "";
            DateTime? vNgaychuyenTu, vNgaychuyenDen, vNgayThulyTu, vNgayThulyDen, vNgayNhapTu, vNgayNhapDen;
            string vSoThuly;
            int status_ghepvuan = 0;
            decimal vLoaiAn = 0;
            NguoiGui = Session[SS_TK.NGUOIGUI] + "";
            SoBAQD = Session[SS_TK.SOBAQD] + "";
            NgayBAQD = Session[SS_TK.NGAYBAQD] + "";
            if (Session[SS_TK.TOAANXX] != null)
                ToaRaBAQD = Convert.ToDecimal(Session[SS_TK.TOAANXX]);
            if (Session[SS_TK.HINHTHUCDON] != null) HinhThucDon = Convert.ToDecimal(Session[SS_TK.HINHTHUCDON]);
            if (Session[SS_TK.TINHID] != null) DiaChiTinh = Convert.ToDecimal(Session[SS_TK.TINHID]);
            if (Session[SS_TK.HUYENID] != null) DiaChiHuyen = Convert.ToDecimal(Session[SS_TK.HUYENID]);
            DiaChiCT = Session[SS_TK.DIACHICHITIET] + "";
            if (Session[SS_TK.TRALOIDON] != null) TraLoi = Convert.ToDecimal(Session[SS_TK.TRALOIDON]);
            strNguoiNhap = Session[SS_TK.NGUOINHAP] + "";
            SoCMND = Session[SS_TK.SOCMND] + "";
            SoHieuDon = Session[SS_TK.MADON] + "";
            SoCongVan = Session[SS_TK.SOCV] + "";
            NgayCongVan = Session[SS_TK.NGAYCV] + "";
            vNgayNhapTu = (Session[SS_TK.NGAYNHANTU] + "") == "" ? (DateTime?)null : DateTime.Parse((Session[SS_TK.NGAYNHANTU] + ""), cul, DateTimeStyles.NoCurrentDateDefault);
            vNgayNhapDen = (Session[SS_TK.NGAYNHANDEN] + "") == "" ? (DateTime?)null : DateTime.Parse((Session[SS_TK.NGAYNHANDEN] + " 23:59:59"), cul, DateTimeStyles.NoCurrentDateDefault);
            //DateTime? TuNgay = txtNgayNhanTu.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayNhanTu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            //DateTime? DenNgay = txtNgayNhanDen.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayNhanDen.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            vArrSelectID = Session[SS_TK.ARRSELECTID] + "";

            vNoichuyen = -1;
            if (Session[SS_TK.TRANGTHAICHUYEN] != null) vTrangthai = Convert.ToDecimal(Session[SS_TK.TRANGTHAICHUYEN]);
            //if (Session[SS_TK.TOAKHACID] != null && vNoichuyen > 0) vCD_DONVIID = Convert.ToDecimal(Session[SS_TK.TOAKHACID]);
            vCD_DONVIID = CurrPhongBanID;

           vNgaychuyenTu = (Session[SS_TK.NGAYCHUYENTU] + "") == "" ? (DateTime?)null : DateTime.Parse((Session[SS_TK.NGAYCHUYENTU] + ""), cul, DateTimeStyles.NoCurrentDateDefault);
            vNgaychuyenDen = (Session[SS_TK.NGAYCHUYENDEN] + "") == "" ? (DateTime?)null : DateTime.Parse((Session[SS_TK.NGAYCHUYENDEN] + ""), cul, DateTimeStyles.NoCurrentDateDefault);

            if (Session[SS_TK.THULYDON] != null) vIsThuLy = Convert.ToDecimal(Session[SS_TK.THULYDON]);

            vPhanloaixuly = 0;
            // Convert.ToDecimal(ddlPhanloaiDdon.SelectedValue);

            vNgayThulyTu = (Session[SS_TK.THULY_TU] + "") == "" ? (DateTime?)null : DateTime.Parse((Session[SS_TK.THULY_TU] + ""), cul, DateTimeStyles.NoCurrentDateDefault);
            vNgayThulyDen = (Session[SS_TK.THULY_DEN] + "") == "" ? (DateTime?)null : DateTime.Parse((Session[SS_TK.THULY_DEN] + ""), cul, DateTimeStyles.NoCurrentDateDefault);

            vSoThuly = Session[SS_TK.SOTHULY] + "";
            if (Session[SS_TK.THAMTRAVIEN] != null) vPhancongTTV = Convert.ToDecimal(Session[SS_TK.THAMTRAVIEN]);
            if (Session[SS_TK.GhepDon_VuAn] != null) status_ghepvuan = Convert.ToInt32(Session[SS_TK.GhepDon_VuAn]);
            //them loai an 
            if (Session[SS_TK.LOAIAN] != null) vLoaiAn = Convert.ToDecimal(Session[SS_TK.LOAIAN]);
            int page_size = Convert.ToInt32(ddlPageCount.SelectedValue);
            int pageindex = Convert.ToInt32(hddPageIndex.Value);


            //anhvh phân quyên liên quan đến án tử hình
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            decimal _ISXINANGIAM = Convert.ToDecimal(oPer.ISXINANGIAM);
            decimal _GDT_ISXINANGIAM = Convert.ToDecimal(oPer.GDT_ISXINANGIAM);
            DataTable tbl = null;
            tbl = oBL.GDTTT_DON_GIAONHAN_THS_PRINT(ToaAnID, ToaRaBAQD, SoBAQD, NgayBAQD, NguoiGui,
               SoCMND, vNgayNhapTu, vNgayNhapDen, HinhThucDon, SoHieuDon, DiaChiTinh, DiaChiHuyen
               , DiaChiCT, SoCongVan, NgayCongVan, TraLoi, strNguoiNhap, vNoichuyen,
               vTrangthai, vCD_DONVIID, vNgaychuyenTu, vNgaychuyenDen
               , vArrSelectID, vIsThuLy, vPhanloaixuly
               , vNgayThulyTu, vNgayThulyDen, vSoThuly, vPhancongTTV, vLoaiAn, status_ghepvuan, _ISXINANGIAM, _GDT_ISXINANGIAM
               , pageindex, page_size);
            //DataTable tbl = oBL.GQD_VUAN_SEARCH_PRINT(vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD, vNguyendon, vBidon, vLoaiAn
            //                                       , vThamtravien, vLanhdao, vThamphan, vNgayThulyTu, vNgayThulyDen, vSoThuly, vLoaiNgay, vGQD_TuNgay, vGQD_DenNgay
            //                                       , vKetquathuly, vKetquaxetxu, vLoaiAnDB, LoaiAnDB_TH, typetb
            //                                       , 0, 0);
            //-----------------------------------------
            //-----------------------------------------
            Literal Table_Str_Totals = new Literal();
            DataRow row = tbl.NewRow();
            //-----------
            if (tbl != null && tbl.Rows.Count > 0)
            {
                row = tbl.Rows[0];
                Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
            }
            //--------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=BC_VUAN_TT_GDTTT.doc");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/msword";
            HttpContext.Current.Response.ContentEncoding = System.Text.UnicodeEncoding.UTF8;
            Response.Write("<html");
            Response.Write("<head>");
            Response.Write("<!--[if gte mso 9]> <xml> <w:WordDocument> <w:View>Print</w:View> <w:Zoom>100</w:Zoom> <w:DoNotOptimizeForBrowser/> </w:WordDocument> </xml> <![endif]-->");
            Response.Write("<META HTTP-EQUIV=Content-Type CONTENT=text/html; charset=UTF-8>");
            Response.Write("<meta name=ProgId content=Word.Document>");
            Response.Write("<meta name=Generator content=Microsoft Word 9>");
            Response.Write("<meta name=Originator content=Microsoft Word 9>");
            Response.Write("<style>");
            Response.Write("<!-- /* Style Definitions */" +
                                          "p.MsoFooter, li.MsoFooter, div.MsoFooter" +
                                          "{margin:0in;" +
                                          "margin-bottom:.0001pt;" +
                                          "mso-pagination:widow-orphan;" +
                                          "tab-stops:center 3.0in right 6.0in;" +
                                          "font-size:12.0pt;}");

            Response.Write("@page Section1 {size:595.45pt 841.7pt; margin:0.7874015748in 0.5905511811in 0.7086614173in 1.18in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");
            Response.Write("div.Section1 {page:Section1;}");
            //Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:1.25in 1.0in 1.25in 1.0in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");         
            Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.2in 0.2in 0.5in 0.2in;mso-header: h1;mso-header-margin:.2in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
            //Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5in 1.0in 0.5in 1.0in;mso-header-margin:.1in;mso-footer-margin:.1in;mso-paper-source:0;}");
            Response.Write("div.Section2 {page:Section2;}");
            Response.Write("<style>");
            Response.Write("</head>");
            Response.Write("<body>");
            Response.Write("<div class=Section2>");//chỉ định khổ giấy
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.Write("</div>");
            Response.Write("</body>");
            Response.Write("</html>");
            Response.End();
        }



        #region "Phân trang"

        protected void lbTBack_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            Load_Data();
        }

        protected void lbTFirst_Click(object sender, EventArgs e)
        {

            hddPageIndex.Value = "1";
            Load_Data();
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {

            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            Load_Data();
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {

            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            Load_Data();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;

            hddPageIndex.Value = lbCurrent.Text;
            Load_Data();
        }

        protected void ddlPageCount_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount2.SelectedValue = ddlPageCount.SelectedValue;

            hddPageIndex.Value = "1";
            Load_Data();
        }
        protected void ddlPageCount2_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount.SelectedValue = ddlPageCount2.SelectedValue;

            hddPageIndex.Value = "1";
            Load_Data();
        }
        #endregion

        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {

            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {


                try
                {
                    DataRowView rv = (DataRowView)e.Item.DataItem;

                    int V_THS_ID = String.IsNullOrEmpty((rv["ths_ID"] + "")) ? -1 : Convert.ToInt16(rv["ths_ID"] + "");
                    if (V_THS_ID <= 0)
                    {

                        ImageButton btn = e.Item.FindControl("IB_tn") as ImageButton;
                        btn.Visible = false;

                    }else
                    {
                        ImageButton btn = e.Item.FindControl("IB_tn") as ImageButton;
                        btn.Visible = true;
                    }
                    //------------------------------------------
                    Literal lttThuLy = (Literal)e.Item.FindControl("lttThuLy");
                    int TinhTrangThuLy = String.IsNullOrEmpty((rv["IsThuLy"] + "")) ? -1 : Convert.ToInt16(rv["IsThuLy"] + "");
                    String temp = (String.IsNullOrEmpty(rv["TL_SO"] + "")) ? "" : "<b>" + rv["TL_So"] + "</b>";
                    if (temp.Length > 0)
                        temp += "<br/>";
                    temp += rv["TL_NGAY_TEXT"] + "";
                    if (temp.Length > 0)
                        temp += "<br/>";
                    temp += rv["TRANGTHAITHULY"] + "";

                    lttThuLy.Text = temp;
                    //------------------------------------
                    Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
                    string vNguoigiao = rv["NGUOICHUYEN_ID"] + "";
                    string V_Nguoichuyen_ID = CanboID + "";

                    DropDownList ddlNguoiGiao = (DropDownList)e.Item.FindControl("ddlNguoiGiao");
                    ddlNguoiGiao.DataSource = lstTTV;
                    ddlNguoiGiao.DataTextField = "HOTEN";
                    ddlNguoiGiao.DataValueField = "ID";
                    ddlNguoiGiao.DataBind();
                    ddlNguoiGiao.Items.Insert(0, new ListItem("--Chọn", "0"));
                    if (vNguoigiao != "")
                    {
                        ddlNguoiGiao.SelectedValue = vNguoigiao;
                    }
                    else{
                        if (V_Nguoichuyen_ID != "")
                            ddlNguoiGiao.SelectedValue = V_Nguoichuyen_ID;
                        else
                            ddlNguoiGiao.SelectedValue = "5101";
                    }
                    //------------------------------------ 
                    string vPhancongTTV = rv["THAMTRAVIENID"]+"";
                    string v_NguoiNhan = rv["NGUOINHAN_ID"] + "";
                    //if (Session[SS_TK.THAMTRAVIEN] != null) vPhancongTTV = Convert.ToString(Session[SS_TK.THAMTRAVIEN]);
                    DropDownList ddlNguoiNhan = (DropDownList)e.Item.FindControl("ddlNguoiNhan");
                    ddlNguoiNhan.DataSource = lstTTV;
                    ddlNguoiNhan.DataTextField = "HOTEN";
                    ddlNguoiNhan.DataValueField = "ID";
                    ddlNguoiNhan.DataBind();
                    ddlNguoiNhan.Items.Insert(0, new ListItem("--Chọn", "0"));
                    if (v_NguoiNhan != "")
                    {
                        ddlNguoiNhan.SelectedValue = v_NguoiNhan;
                    }
                    else
                        ddlNguoiNhan.SelectedValue = vPhancongTTV;


                }
                catch (Exception ex) { }
            }
        }
        protected void ddlNguoiGiao_SelectedIndexChanged(object sender, EventArgs e)
        {
        }
        protected void ddlNguoiNhan_SelectedIndexChanged(object sender, EventArgs e)
        {
        }
        protected void IB_tn_Click(object sender, ImageClickEventArgs e)
        {
            ImageButton img = (ImageButton)sender;
            String THS_ID = img.CommandArgument;
            GDTTT_DON_BL bl = new GDTTT_DON_BL();
            if (THS_ID !=null)   
                bl.GDTTT_DON_GIAONHAN_DEL(Convert.ToDecimal(THS_ID));
            Load_Data();
        }
              
    }
}