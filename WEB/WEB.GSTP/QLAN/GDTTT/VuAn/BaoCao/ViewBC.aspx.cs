using Aspose.Words;
using BL.GSTP.BANGSETGET;
using BL.GSTP.Danhmuc;
using BL.GSTP.GDTTT;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;

namespace WEB.GSTP.QLAN.GDTTT.VuAn.BaoCao
{
    public partial class ViewBC : System.Web.UI.Page
    {
        CultureInfo cul = new CultureInfo("vi-VN");
        GSTPContext dt = new GSTPContext();
        Decimal CurrentUserID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrentUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrentUserID == 0)
                Response.Redirect("/Login.aspx");
            else
            {
                LoadReport();
            }
        }
        private void LoadReport()
        {
            Decimal ThamPhanID = 0;
            string TenThamPhan = "";
            DateTime vNgayThulyTu = DateTime.MinValue;
            DateTime vNgayThulyDen = DateTime.MinValue;
            string DenNgay = "", TuNgay = "";
            String ThoiGian = "";
            string report_name = Session[SS_TK.TENBAOCAO] + "";
            String SessionName = "GDTTT_ReportPL".ToUpper();
            DataTable tblData = (DataTable)Session[SessionName];
            string type = (Request["type"] != null) ? Request["type"].ToString() : "";
            int PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToInt32(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");
            string loai_report = type.ToLower();
            if (loai_report != "hoso")
            {
                try
                {
                    #region Lay thong tin tham so
                    if (Session[SS_TK.THAMPHAN].ToString() != "0")
                    {
                        ThamPhanID = Convert.ToDecimal(Session[SS_TK.THAMPHAN] + "");
                        TenThamPhan = dt.DM_CANBO.Where(x => x.ID == ThamPhanID).FirstOrDefault().HOTEN.ToUpper();
                    }
                    if (!String.IsNullOrEmpty(Session[SS_TK.THULY_TU] + ""))
                    {
                        vNgayThulyTu = DateTime.Parse(Session[SS_TK.THULY_TU] + "", cul, DateTimeStyles.NoCurrentDateDefault);
                        TuNgay = vNgayThulyTu.ToString("dd/MM/yyyy", cul);
                    }
                    if (!String.IsNullOrEmpty(Session[SS_TK.THULY_DEN] + ""))
                    {
                        vNgayThulyDen = DateTime.Parse(Session[SS_TK.THULY_DEN] + "", cul, DateTimeStyles.NoCurrentDateDefault);
                        DenNgay = vNgayThulyDen.ToString("dd/MM/yyyy", cul);
                    }
                    else DenNgay = DateTime.Now.ToString("dd/MM/yyyy", cul);


                    if (!String.IsNullOrEmpty(TuNgay))
                        ThoiGian = "Tính từ ngày " + TuNgay;
                    if (!String.IsNullOrEmpty(DenNgay))
                    {
                        if (!String.IsNullOrEmpty(ThoiGian))
                            ThoiGian += " đến ngày " + DenNgay;
                        else
                            ThoiGian = "Tính đến ngày " + DenNgay;
                    }

                    if (!String.IsNullOrEmpty(ThoiGian))
                        ThoiGian = "(" + ThoiGian + ")";
                    #endregion 

                }
                catch (Exception ex) { }

                switch (loai_report)
                {
                    case "va":
                        int bm = (Request["rID"] != null) ? Convert.ToInt16(Request["rID"].ToString()) : 0;
                        switch (bm)
                        {
                            case 1:
                                HanhChinh.PL1 bc = new HanhChinh.PL1();
                                bc.Parameters["TieuDeBC"].Value = report_name;
                                bc.Parameters["DenNgay"].Value = ThoiGian;
                                bc.DataSource = tblData;
                                reportcontrol.OpenReport(bc);
                                break;
                            case 2:
                                HanhChinh.PL2 bc2 = new HanhChinh.PL2();
                                bc2.Parameters["TieuDeBC"].Value = report_name;
                                bc2.Parameters["DenNgay"].Value = ThoiGian;
                                bc2.DataSource = tblData;
                                reportcontrol.OpenReport(bc2);
                                break;
                            case 3:
                                HanhChinh.PL3 bc3 = new HanhChinh.PL3();
                                bc3.Parameters["TieuDeBC"].Value = report_name;
                                bc3.Parameters["DenNgay"].Value = ThoiGian;
                                bc3.DataSource = tblData;
                                reportcontrol.OpenReport(bc3);
                                break;
                            case 4:
                                HanhChinh.PL4 bc4 = new HanhChinh.PL4();
                                bc4.Parameters["TieuDeBC"].Value = report_name;
                                bc4.Parameters["DenNgay"].Value = ThoiGian;
                                bc4.DataSource = tblData;
                                reportcontrol.OpenReport(bc4);
                                break;
                            case 5:
                                AnQH.BM5 bc5 = new AnQH.BM5();
                                bc5.Parameters["TieuDeBC"].Value = report_name;
                                bc5.Parameters["DenNgay"].Value = ThoiGian;
                                if (tblData != null && tblData.Rows.Count > 0)
                                {
                                    int count_all = tblData.Rows.Count;
                                    bc5.Parameters["CountAll"].Value = count_all;
                                }
                                else
                                    bc5.Parameters["CountAll"].Value = 0;
                                bc5.DataSource = tblData;
                                reportcontrol.OpenReport(bc5);
                                break;
                        }
                        break;
                    case "xetxugdt":
                        ThoiGian += "  " + "Tổng số: " + ((tblData != null && tblData.Rows.Count > 0) ? tblData.Rows.Count.ToString() : "0") + " vụ";
                        XetXuGDT.DS xx = new XetXuGDT.DS();
                        xx.Parameters["TieuDeBC"].Value = report_name;
                        xx.Parameters["ThoiGian"].Value = ThoiGian;
                        xx.Parameters["TongSo"].Value = "";
                        xx.DataSource = tblData;
                        reportcontrol.OpenReport(xx);
                        break;
                    case "dstotrinh":
                        //In toan bo quan ly HS theo VuAnID
                        ToTrinh.Ds tt = new ToTrinh.Ds();
                        tt.Parameters["TieuDeBC"].Value = report_name;
                        tt.Parameters["ThoiGian"].Value = ThoiGian;
                        tt.DataSource = tblData;
                        reportcontrol.OpenReport(tt);
                        break;
                    case "pc_ttv":
                        DenNgay = DateTime.Now.ToString("dd/MM/yyyy", cul);
                        if (!String.IsNullOrEmpty(DenNgay))
                            ThoiGian = "(Tính từ ngày " + DenNgay + ")";

                        //lay ds phan cong TTV
                        HoSo.PCTTV pc = new HoSo.PCTTV();
                        pc.Parameters["TieuDeBC"].Value = report_name;
                        pc.Parameters["ThoiGian"].Value = ThoiGian;
                        pc.DataSource = tblData;
                        reportcontrol.OpenReport(pc);
                        break;
                    case "hoso_tt":
                        ToTrinh.DSVuAn dsva = new ToTrinh.DSVuAn();
                        dsva.Parameters["TieuDeBC"].Value = report_name;
                        dsva.Parameters["ThoiGian"].Value = ThoiGian;
                        dsva.DataSource = tblData;
                        reportcontrol.OpenReport(dsva);
                        break;
                    default:
                        break;
                }
            }
            else
            {
                string loai_bm = (Request["loai"] != null) ? Request["loai"].ToString() : "";
                switch (loai_bm)
                {
                    case "bm":
                        //in biểu mẫu muon hs cua 1 vu an
                        InHoSo_MotVuAn_Flexcel();
                        break;
                    case "ds":
                        DenNgay = DateTime.Now.ToString("dd/MM/yyyy", cul);
                        if (!String.IsNullOrEmpty(DenNgay))
                            ThoiGian = "(Tính từ ngày " + DenNgay + ")";



                        //In toan bo quan ly HS theo VuAnID
                        HoSo.HS hs = new HoSo.HS();
                        hs.Parameters["TieuDeBC"].Value = report_name.ToUpper();
                        hs.Parameters["ThoiGian"].Value = ThoiGian;


                        Decimal VuAnId = String.IsNullOrEmpty(Request["vid"] + "") ? 0 : Convert.ToDecimal(Request["vID"] + "");
                        if (VuAnId > 0)
                        {


                            GDTTT_VUAN objVA = dt.GDTTT_VUAN.Where(x => x.ID == VuAnId).Single();
                            if (objVA != null)
                            {
                                hs.Parameters["TenVuAn"].Value = objVA.TENVUAN;
                                if (objVA.BAQD_CAPXETXU == 2)
                                {
                                    hs.Parameters["SoBanAn"].Value = objVA.SOANSOTHAM;
                                    hs.Parameters["NgayBanAn"].Value = Convert.ToDateTime(objVA.NGAYXUSOTHAM).ToString("dd/MM/yyyy");
                                }
                                else if (objVA.BAQD_CAPXETXU == 3)
                                {
                                    hs.Parameters["SoBanAn"].Value = objVA.SOANPHUCTHAM;
                                    hs.Parameters["NgayBanAn"].Value = Convert.ToDateTime(objVA.NGAYXUPHUCTHAM).ToString("dd/MM/yyyy");
                                }
                                else
                                {
                                    if (objVA.SO_QDGDT != null)
                                        hs.Parameters["SoBanAn"].Value = objVA.SO_QDGDT;
                                    if (objVA.NGAYQD != null)
                                        hs.Parameters["NgayBanAn"].Value = Convert.ToDateTime(objVA.NGAYQD).ToString("dd/MM/yyyy");
                                }

                                GDTTT_DON oDon = dt.GDTTT_DON.Where(x => x.VUVIECID == objVA.ID && x.ISTHULY == 1).FirstOrDefault();
                                if (oDon != null)
                                {
                                    hs.Parameters["SoThuLy"].Value = oDon.TL_SO;
                                    hs.Parameters["NgayThuLy"].Value = Convert.ToDateTime(oDon.TL_NGAY).ToString("dd/MM/yyyy");
                                }

                            }
                        }

                        hs.DataSource = tblData;
                        reportcontrol.OpenReport(hs);
                        break;
                    case "mHS":
                        //In phieu muon ho so cua nhieu vu an
                        if (PhongBanID == 401)//3
                        {
                            HoSo.mMuonHS mMuonHS = new HoSo.mMuonHS();
                            mMuonHS.Parameters["TieuDeBC"].Value = report_name.ToUpper();
                            // mMuonHS.Parameters["ThoiGian"].Value = ThoiGian;
                            mMuonHS.DataSource = tblData;
                            reportcontrol.OpenReport(mMuonHS);
                        }
                        else InPhieuMuon_NhieuVuAn();
                        break;

                }
            }
        }
        void InHoSo_MotVuAn_Flexcel()
        {
            decimal temp_id = 0;
            string TenPhongBan = "", DiaChiGuiHS = "", Nguyendon = "", bidon = "";
            DateTime now = DateTime.Now;
            string quanhephapluat = "", V_QHPL_TEXT = "";
            String ToaAnThuLy = "", tenvuan = "", sobanan = "", ngaybanan = "";
            int PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToInt32(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");
            DM_PHONGBAN objPB = dt.DM_PHONGBAN.Where(x => x.ID == PhongBanID).Single();
            if (objPB != null)
            {
                TenPhongBan = objPB.TENPHONGBAN;
                DiaChiGuiHS = objPB.HAUTOCV;
            }
            //-----------------------------------
            string tenviettat = "";
            switch (PhongBanID)
            {
                case 381://2:
                    tenviettat = "GĐKTI";
                    break;
                case 401:// 3:
                    tenviettat = "GĐKTII";
                    break;
                case 382://4
                    tenviettat = "GĐKTIII";
                    break;
                case 361:
                    tenviettat = "GĐKTIV";
                    break;
                default:
                    tenviettat = TenPhongBan;
                    break;
            }
            //--------------------------------
            int loai_vu_an = 0;
            String Str_LoaiVuAn = "";
            String Str_TenLoaiVuAn = "";
            String Str_ToaAnThuLy = "";
            String Str_ToaAnThuLyBody = "";
            String StrToaXuDenghi = "";
            string Noidung_2 = "";
            String Noidung_3 = "";
            String DCGuiHS = "";
            string txtToaAnThuLy = "";
            string txtQHPL = "";
            string txtTenDonVi = "";
            string txtDonViLuu = "";
            string txtSoThongBao = "";
            string txtDiaDiem = "";
            string txtCanCuBoLuatTT = "";
            string txtNoiDung1 = "";
            string txtNoiDung2 = "";
            string txtNoiDung3 = "";
            string txtNguyenDon = "";
            string txtBiDon = "";
            string txtDiaChiGuiHS = "";
            string txtTENNGUOIKY = "";
            string txtChucVu = "";
            string txtTenChucVu = "";
            string txtTPTC = "";
            string txtTenPhongBan = "";
            string txtCapxetxu = "";
            string txtLoaidenghi = "";
            decimal? thamphanid = null;
            string txtLOAI_GDTTTT = "";
            string txtSOBA = "";
            string txtNGAYBA = "";
            string Noidung = "";
            string XmlFile = "";
            decimal isToaPhucTham = 0;
            Decimal hsId = String.IsNullOrEmpty(Request["hsID"] + "") ? 0 : Convert.ToDecimal(Request["hsID"] + "");
            Decimal VuAnId = String.IsNullOrEmpty(Request["vid"] + "") ? 0 : Convert.ToDecimal(Request["vID"] + "");
            if (VuAnId > 0)
            {
                GDTTT_VUAN objVA = dt.GDTTT_VUAN.Where(x => x.ID == VuAnId).Single();
                if (objVA != null)
                {
                    thamphanid = objVA.THAMPHANID;
                    loai_vu_an = (int)objVA.LOAIAN;
                    switch (loai_vu_an)
                    {
                        case 1:
                            Str_TenLoaiVuAn = ENUM_STR_LOAIVUVIEC.AN_HINHSU;
                            break;
                        case 2:
                            Str_TenLoaiVuAn = ENUM_STR_LOAIVUVIEC.AN_DANSU;
                            break;
                        case 3:
                            Str_TenLoaiVuAn = ENUM_STR_LOAIVUVIEC.AN_HONNHAN_GIADINH;
                            break;
                        case 4:
                            Str_TenLoaiVuAn = ENUM_STR_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI;
                            break;
                        case 5:
                            Str_TenLoaiVuAn = ENUM_STR_LOAIVUVIEC.AN_LAODONG;
                            break;
                        case 6:
                            Str_TenLoaiVuAn = ENUM_STR_LOAIVUVIEC.AN_HANHCHINH;
                            break;
                        case 7:
                            Str_TenLoaiVuAn = ENUM_STR_LOAIVUVIEC.AN_PHASAN;
                            break;
                        default:
                            Str_TenLoaiVuAn = loai_vu_an.ToString();
                            break;
                    }
                    if (loai_vu_an < 10)
                        Str_LoaiVuAn = "0" + loai_vu_an.ToString();

                    tenvuan = objVA.TENVUAN;
                    temp_id = (string.IsNullOrEmpty(objVA.QHPL_DINHNGHIAID + "")) ? 0 : (decimal)objVA.QHPL_DINHNGHIAID;
                    try
                    {
                        if (temp_id > 0)
                            quanhephapluat = dt.GDTTT_DM_QHPL.Where(x => x.ID == temp_id).Single().TENQHPL;
                    }
                    catch (Exception ex) { }
                    txtSOBA = objVA.SOANPHUCTHAM;
                    txtNGAYBA = (String.IsNullOrEmpty(objVA.NGAYXUPHUCTHAM + "") || (objVA.NGAYXUPHUCTHAM == DateTime.MinValue)) ? "" : ((DateTime)objVA.NGAYXUPHUCTHAM).ToString("dd/MM/yyyy", cul);
                    V_QHPL_TEXT = objVA.QHPL_TEXT;
                    DM_TOAAN objTA;
                    DM_TOAAN_TACH_NHAP_MAPPING_BL bl = new DM_TOAAN_TACH_NHAP_MAPPING_BL();
                    decimal V_TOTOAANID = 0;

                    if (objVA.LOAI_GDTTTT == 1)
                    {
                        txtLoaidenghi = "giám đốc thẩm";
                    }
                    else
                    {
                        txtLoaidenghi = "tái thẩm";
                    }

                    if (objVA.BAQD_CAPXETXU == 2)
                    {
                        txtCapxetxu = "sơ thẩm";
                        sobanan = objVA.SOANSOTHAM;
                        ngaybanan = ((DateTime)objVA.NGAYXUSOTHAM).ToString("dd/MM/yyyy", cul);
                        // Lấy dữ liệu từ BL
                        DataTable v_tb = bl.GETS_BY_TOAAN_ID(Convert.ToDecimal(objVA.TOAANSOTHAM));
                        if (v_tb != null && v_tb.Rows.Count != 0)
                        {
                            V_TOTOAANID = Convert.ToDecimal(v_tb.Rows[0]["TOTOAANID"].ToString());
                            objTA = dt.DM_TOAAN.Where(x => x.ID == V_TOTOAANID).FirstOrDefault();
                        }
                        else
                        {
                            objTA = dt.DM_TOAAN.Where(x => x.ID == objVA.TOAANSOTHAM).FirstOrDefault();
                        }
                        //--------------------
                    }
                    else if (objVA.BAQD_CAPXETXU == 3)
                    {
                        txtCapxetxu = "phúc thẩm";
                        sobanan = objVA.SOANPHUCTHAM;
                        ngaybanan = ((DateTime)objVA.NGAYXUPHUCTHAM).ToString("dd/MM/yyyy", cul);
                        DataTable v_tb = bl.GETS_BY_TOAAN_ID(Convert.ToDecimal(objVA.TOAPHUCTHAMID));
                        if (v_tb != null && v_tb.Rows.Count != 0)
                        {
                            V_TOTOAANID = Convert.ToDecimal(v_tb.Rows[0]["TOTOAANID"].ToString());
                            objTA = dt.DM_TOAAN.Where(x => x.ID == V_TOTOAANID).FirstOrDefault();
                        }
                        else
                        {
                            objTA = dt.DM_TOAAN.Where(x => x.ID == objVA.TOAPHUCTHAMID).FirstOrDefault();
                        }
                        //-------------------------
                    }
                    else
                    {
                        sobanan = objVA.SO_QDGDT;
                        ngaybanan = ((DateTime)objVA.NGAYQD).ToString("dd/MM/yyyy", cul);
                        DataTable v_tb = bl.GETS_BY_TOAAN_ID(Convert.ToDecimal(objVA.TOAQDID));
                        if (v_tb != null && v_tb.Rows.Count != 0)
                        {
                            V_TOTOAANID = Convert.ToDecimal(v_tb.Rows[0]["TOTOAANID"].ToString());
                            objTA = dt.DM_TOAAN.Where(x => x.ID == V_TOTOAANID).FirstOrDefault();
                        }
                        else
                        {
                            objTA = dt.DM_TOAAN.Where(x => x.ID == objVA.TOAQDID).FirstOrDefault();
                        }

                    }
                    if (objTA.TEN.Contains("Phúc thẩm"))
                    {
                        isToaPhucTham = 1;
                    }
                    Nguyendon = objVA.NGUYENDON;
                    bidon = objVA.BIDON;
                    if (string.IsNullOrEmpty(objVA.NGUYENDON) && string.IsNullOrEmpty(objVA.BIDON))
                    {
                        var OGDTTT_VUAN_DUONGSU = DataExtensions.GetAllByVuAnId<GDTTT_VUAN_DUONGSU>(VuAnId);
                        if (OGDTTT_VUAN_DUONGSU != null && OGDTTT_VUAN_DUONGSU.Count() > 0)
                        {
                            foreach (var item in OGDTTT_VUAN_DUONGSU)
                            {
                                if (item.TUCACHTOTUNG == "NGUYENDON")
                                {
                                    Nguyendon = item.TENDUONGSU;
                                }
                                if (item.TUCACHTOTUNG == "BIDON")
                                {
                                    bidon = item.TENDUONGSU;
                                }
                            }
                        }
                    }

                    Str_ToaAnThuLyBody = objTA.MA_TEN;
                    var result = objTA.MA_TEN.Split(new[] { "tại" }, StringSplitOptions.None);
                    if (result.Count() > 1)
                    {
                        Str_ToaAnThuLy = result[0] + "\r\n" + "tại" + result[1];
                    }
                    else
                    {
                        Str_ToaAnThuLy = result[0];
                    }

                    ToaAnThuLy = objTA.MA_TEN;

                    if (objVA.BAQD_CAPXETXU == 4)
                    {
                        objTA = dt.DM_TOAAN.Where(x => x.ID == objVA.TOAQDID).Single();
                        StrToaXuDenghi = objTA.MA_TEN;
                    }
                    else if (objVA.BAQD_CAPXETXU == 2)
                    {
                        objTA = dt.DM_TOAAN.Where(x => x.ID == objVA.TOAANSOTHAM).Single();
                        StrToaXuDenghi = objTA.MA_TEN;
                    }
                    else
                    {
                        objTA = dt.DM_TOAAN.Where(x => x.ID == objVA.TOAPHUCTHAMID).Single();
                        StrToaXuDenghi = objTA.MA_TEN;
                    }

                    txtLOAI_GDTTTT = objVA.LOAI_GDTTTT == 1 ? "giám đốc thẩm" : "tái thẩm";
                }
            }
            //----------------------------------
            GDTTT_QUANLYHS objHS = dt.GDTTT_QUANLYHS.Where(x => x.ID == hsId).Single();

            String SoHieu = objHS.SOPHIEU + "";
            DateTime ngay_hs = Convert.ToDateTime(objHS.NGAYTAO + "");
            String StrThoiGian_DiaDiem = "Hà Nội, ngày " + ngay_hs.Day.ToString("D2") + " tháng " + ngay_hs.Month.ToString() + " năm " + ngay_hs.Year.ToString();

            //-----------------------------------------

            int LoaiHs = Convert.ToInt16(objHS.LOAI);
            int IsMuonHS_VKS = (string.IsNullOrEmpty(objHS.ISMUONHOSOVKS + "")) ? 0 : Convert.ToInt16(objHS.ISMUONHOSOVKS);
            if (LoaiHs == 0)
            {
                if (PhongBanID == 382)//4
                {
                    Noidung = "Để có cơ sở giải quyết đơn đề nghị xem xét theo thủ tục giám đốc thẩm, tái thẩm của đương sự,";
                    Noidung += " đề nghị " + Str_ToaAnThuLyBody + " chuyển cho Vụ Giám đốc, kiểm tra III"
                            + " hồ sơ vụ án " + Str_TenLoaiVuAn + " về việc"
                            + V_QHPL_TEXT
                            + "\" giữa các đương sự là:";

                    txtTenPhongBan += "chuyển cho Vụ Giám đốc, kiểm tra III"
                                   + " hồ sơ vụ án " + Str_TenLoaiVuAn + " về việc";
                    txtQHPL = V_QHPL_TEXT;
                }
                else
                {
                    //-------------vu 2---------------
                    Noidung = "Để có cơ sở giải quyết đơn đề nghị xem xét theo thủ tục giám đốc thẩm, tái thẩm của đương sự,";
                    Noidung += " đề nghị " + Str_ToaAnThuLyBody + " chỉ đạo chuyển cho " + TenPhongBan
                        + " - Tòa án nhân dân tối cao hồ sơ vụ án \"" + quanhephapluat + "\" giữa các đương sự là:";

                    txtTenPhongBan += "chỉ đạo chuyển cho " + TenPhongBan
                        + " - Tòa án nhân dân tối cao hồ sơ vụ án";
                    txtQHPL = quanhephapluat;
                }
            }

            if (PhongBanID == 382)
            {
                XmlFile = Server.MapPath("~/TempUpload/mToTrinhV3.docx");

                txtNoiDung1 = Noidung;
                txtTenDonVi = " VỤ GIÁM ĐỐC, KIỂM TRA III";
                txtDonViLuu = "Vụ " + tenviettat + "-TANDTC";
                txtSoThongBao = SoHieu + "/RHS-" + tenviettat;///PM/TANDTC-
                txtDiaDiem = StrThoiGian_DiaDiem;
                txtCanCuBoLuatTT = "Căn cứ vào khoản 1 Điều 46 Luật Tổ chức Tòa án nhân dân và Điều 18 Bộ luật Tố tụng dân sự;";

                if (IsMuonHS_VKS == 0)
                    txtToaAnThuLy = ToaAnThuLy;//mhs_v3.Parameters["ToaAnThuLy"].Value = "Đồng chí Chánh án " + ToaAnThuLy;
                else
                    txtToaAnThuLy = "Đồng chí Viện trưởng " + Str_ToaAnThuLyBody;

                Noidung_2 = "Do " + StrToaXuDenghi + " xét xử phúc thẩm tại Bản án phúc thẩm số " + sobanan + " ngày " + ngaybanan + ".";

                DCGuiHS = "(Hồ sơ gửi chuyển phát nhanh đến Vụ Giám đốc kiểm tra III Toà án nhân dân tối cao; Địa chỉ: Ngõ 1, đường Phạm Văn Bạch, phường Cầu Giấy, Tp. Hà Nội).";
                Noidung_3 = "Trường hợp hồ sơ vụ án đã được chuyển cho cơ quan, đơn vị khác thì đề nghị " + Str_ToaAnThuLyBody + " thông báo cho Vụ Giám đốc, kiểm tra III Tòa án nhân dân tối cao để theo dõi.";

                if (Str_LoaiVuAn != ENUM_LOAIVUVIEC.AN_HANHCHINH)
                {
                    txtNguyenDon = "- Nguyên đơn: " + Nguyendon;
                    txtBiDon = "- Bị đơn: " + bidon;
                }
                else
                {
                    txtNguyenDon = "- Người khởi kiện: " + Nguyendon;
                    txtBiDon = "- Người bị kiện: " + bidon;
                }
                txtNoiDung2 = Noidung_2;
                txtNoiDung3 = Noidung_3;
                txtDiaChiGuiHS = DCGuiHS;
                
                var objCBs = dt.DM_CANBO.Where(x => x.PHONGBANID == PhongBanID).ToArray();
                if (objCBs.Length > 0)
                {
                    DM_CANBO objCB = objCBs.Where(x => x.CHUCVUID == 432).FirstOrDefault();
                    if (objCB != null)
                    {
                        txtTENNGUOIKY = objCB.HOTEN;
                    }
                    //nếu là tp bậc 3 thì thêm 1 dòng
                    objCB = objCBs.Where(x => x.ID == thamphanid && x.CHUCDANHID == 2318).FirstOrDefault();//thẩm phán bậc 3
                    if (objCB != null)
                    {
                        txtTPTC += "\r\n" + "- TP " + objCB.HOTEN + " (để biết);";
                    }
                }
                //nếu được phân cho thẩm phán tối cao thì thêm 1 dòng ở trên thẩm phán bậc 3
                if (thamphanid != null)
                {
                    DM_CANBO objCB = objCBs.Where(x => x.CHUCDANHID == 486).FirstOrDefault();//thẩm phán tối cao
                    if (objCB != null)
                    {
                        txtTPTC = "\r\n" + "- TP TANDTC " + objCB.HOTEN + " (để bc);";

                        objCB = objCBs.Where(x => x.ID == thamphanid && x.CHUCDANHID == 2318).FirstOrDefault();//thẩm phán bậc 3
                        if (objCB != null)
                        {
                            txtTPTC += "\r\n" + "- TP " + objCB.HOTEN + " (để biết);";
                        }
                    }
                }
            }
            else if (PhongBanID == 361)
            {
                txtTenDonVi = " VỤ GIÁM ĐỐC, KIỂM TRA IV";
                if (objHS.NGUOIKYID != null)
                {
                    DM_CANBO objCB = DataExtensions.FindById<DM_CANBO>(objHS.NGUOIKYID.Value);
                    if (objCB != null)
                    {
                        DM_DATAITEM OChucVu = DataExtensions.FindById<DM_DATAITEM>(objHS.CHUCVUID.Value);
                        if (OChucVu.ID == 432)
                        {
                            txtChucVu = "VỤ TRƯỞNG";
                            txtTENNGUOIKY = objCB.HOTEN;
                        }
                        else
                        {
                            txtChucVu = "KT. VỤ TRƯỞNG";
                            txtTenChucVu = "PHÓ VỤ TRƯỞNG";
                            txtTENNGUOIKY = objCB.HOTEN;
                        }
                    }
                }
                
                if (loai_vu_an == 2)
                {
                    XmlFile = Server.MapPath("~/TempUpload/mToTrinhV4_Dansu.docx");
                    //-------------vu 4 án dân sự---------------
                    //txtTenDonVi = TenPhongBan.ToUpper();
                    txtSoThongBao = (string.IsNullOrEmpty(SoHieu) ? "....." : SoHieu) + " /TANDTC-GĐKTIV";
                    if (thamphanid != null)
                    {
                        DM_CANBO objTP = dt.DM_CANBO.Where(x => x.ID == thamphanid).FirstOrDefault();//thẩm phán tối cao
                        if (objTP != null)
                        {
                            if (objTP.CHUCDANHID == 486)
                            {
                                txtTPTC = "\r\n" + "- TP TANDTC " + objTP.HOTEN + " (để bc);";
                            }
                            else if (objTP.CHUCDANHID == 2318)
                            {
                                txtTPTC += "\r\n" + "- TP " + objTP.HOTEN + " (để biết);";
                            }
                        }
                    }
                    txtQHPL = V_QHPL_TEXT;
                    if (isToaPhucTham == 0)
                    {
                        Str_ToaAnThuLyBody = "Chánh án " + Str_ToaAnThuLyBody;
                        Str_ToaAnThuLy = "Chánh án " + Str_ToaAnThuLy;
                    }
                    else
                    {
                        Str_ToaAnThuLyBody = "Chánh " + Str_ToaAnThuLyBody;
                        Str_ToaAnThuLy = "Chánh " + Str_ToaAnThuLy;
                    }
                    txtToaAnThuLy = Str_ToaAnThuLyBody;
                    Noidung_2 = "Tòa án nhân dân tối cao nhận được đơn của đương sự đề nghị xem xét theo thủ tục " + txtLoaidenghi + " đối với Bản án/Quyết định dân sự " + txtCapxetxu + " số " + sobanan + " ngày " + ngaybanan + " của " + StrToaXuDenghi + " về vụ án “" + txtQHPL + "” giữa:";
                    txtNoiDung2 = Noidung_2;
                    txtNguyenDon = "Nguyên đơn: " + Nguyendon;
                    txtBiDon = "Bị đơn: " + bidon;
                    txtCanCuBoLuatTT = "Căn cứ vào khoản 1 Điều 46 Luật Tổ chức Tòa án nhân dân, Điều 18 Bộ luật Tố tụng dân sự, Tòa án nhân dân tối cao đề nghị " + txtToaAnThuLy + " chỉ đạo chuyển hồ sơ vụ án nêu trên cho Tòa án nhân dân tối cao trong thời hạn 07 ngày, kể từ ngày nhận được công văn này. ";
                    DCGuiHS = "(Hồ sơ gửi phát nhanh theo địa chỉ: Vụ Giám đốc, kiểm tra IV, Tòa án nhân dân tối cao, số 01 Phạm Văn Bạch, phường Yên Hoà, thành phố Hà Nội; bên ngoài bao bì ghi rõ tên người khởi kiện, người bị kiện, số bản án và ngày xét xử để Vụ Giám đốc, kiểm tra IV theo dõi khi nhận hồ sơ).";
                    txtDiaChiGuiHS = DCGuiHS;
                }
                else if (loai_vu_an == 6)
                {
                    if (isToaPhucTham == 0)
                    {
                        Str_ToaAnThuLyBody = "Chánh án " + Str_ToaAnThuLyBody;
                        Str_ToaAnThuLy = "Chánh án " + Str_ToaAnThuLy;
                    }    
                    else
                    {
                        Str_ToaAnThuLyBody = "Chánh " + Str_ToaAnThuLyBody;
                        Str_ToaAnThuLy = "Chánh " + Str_ToaAnThuLy;
                    }    
                    

                    XmlFile = Server.MapPath("~/TempUpload/mToTrinhV4_HanhChinh.docx");
                    //-------------vu 4 án dân sự---------------
                    txtSoThongBao = (string.IsNullOrEmpty(SoHieu) ? "....." : SoHieu) + " /TANDTC-GĐKTIV";
                    if (thamphanid != null)
                    {
                        DM_CANBO objTP = dt.DM_CANBO.Where(x => x.ID == thamphanid).FirstOrDefault();//thẩm phán tối cao
                        if (objTP != null)
                        {
                            if (objTP.CHUCDANHID == 486)
                            {
                                txtTPTC = "\r\n" + "- TP TANDTC " + objTP.HOTEN + " (để bc);";
                            }
                            else if (objTP.CHUCDANHID == 2318)
                            {
                                txtTPTC += "\r\n" + "- TP " + objTP.HOTEN + " (để biết);";
                            }
                        }
                    }
                    //-------------vu 4 án hành chính---------------
                    //txtTenDonVi = TenPhongBan.ToUpper();
                    txtSoThongBao = (string.IsNullOrEmpty(SoHieu) ? "....." : SoHieu) + " /TANDTC-GĐKTIV";
                    txtQHPL = V_QHPL_TEXT;
                    //txtToaAnThuLy = Str_ToaAnThuLyBody;
                    Noidung_2 = "Tòa án nhân dân tối cao nhận được đơn của đương sự đề nghị xem xét theo thủ tục " + txtLoaidenghi + " đối với Bản án dân sự " + txtCapxetxu + " số " + sobanan + " ngày " + ngaybanan + " của " + StrToaXuDenghi + " về vụ án “" + txtQHPL + "” giữa:";
                    txtNoiDung2 = Noidung_2;
                    txtNguyenDon = " Người khởi kiện: " + Nguyendon;
                    txtBiDon = " Người bị kiện: " + bidon;
                    txtCanCuBoLuatTT = "Căn cứ vào khoản 1 Điều 46 Luật Tổ chức Tòa án nhân dân, Điều 18 Bộ luật Tố tụng dân sự, Tòa án nhân dân tối cao đề nghị " + txtToaAnThuLy + " chỉ đạo chuyển hồ sơ vụ án nêu trên cho Tòa án nhân dân tối cao trong thời hạn 07 ngày, kể từ ngày nhận được công văn này. ";
                    DCGuiHS = "(Hồ sơ gửi phát nhanh theo địa chỉ: Vụ Giám đốc, kiểm tra IV, Tòa án nhân dân tối cao, số 01 Phạm Văn Bạch, phường Yên Hoà, thành phố Hà Nội; bên ngoài bao bì ghi rõ tên người khởi kiện, người bị kiện, số bản án và ngày xét xử để Vụ Giám đốc, kiểm tra IV theo dõi khi nhận hồ sơ).";
                    txtDiaChiGuiHS = DCGuiHS + ((!String.IsNullOrEmpty(DiaChiGuiHS)) ? " tại địa chỉ:" + DiaChiGuiHS : "") + ")";
                }
            }
            else
            {
                XmlFile = Server.MapPath("~/TempUpload/mToTrinhV3.docx");
                //-------------vu 2---------------
                txtTenDonVi = TenPhongBan.ToUpper();
                txtDonViLuu = "Vụ " + tenviettat + "-TANDTC";
                txtSoThongBao = (string.IsNullOrEmpty(SoHieu) ? "....." : SoHieu) + "/ CV-" + tenviettat;
                txtDiaDiem = StrThoiGian_DiaDiem;
                txtCanCuBoLuatTT = "Căn cứ vào khoản 1 Điều 46 Luật Tổ chức Tòa án nhân dân và Điều 18 Bộ luật Tố tụng dân sự;";

                Noidung_2 = "Do " + Str_ToaAnThuLyBody + " xét xử phúc thẩm tại Bản án phúc thẩm số " + sobanan + " ngày " + ngaybanan + ".";
                DCGuiHS = "(Hồ sơ gửi phát nhanh theo địa chỉ: " + TenPhongBan
                            + " Tòa án nhân dân tối cao ";

                txtToaAnThuLy = Str_ToaAnThuLyBody;
                txtNoiDung1 = Noidung;
                txtNguyenDon = "- Nguyên đơn: " + Nguyendon;
                txtBiDon = "- Bị đơn: " + bidon;
                txtNoiDung2 = Noidung_2;
                txtDiaChiGuiHS = DCGuiHS + ((!String.IsNullOrEmpty(DiaChiGuiHS)) ? " tại địa chỉ:" + DiaChiGuiHS : "") + ")";
            }
            //--------HÀM GEN RA FILE DOCX-----------------------------
            Document reportDocument = new Document(XmlFile);

            foreach (var fieldname in reportDocument.MailMerge.GetFieldNames())
            {
                var valIndex = fieldname.IndexOf(':');
                if (valIndex > 0)
                    reportDocument.MailMerge.MappedDataFields.Add(fieldname, fieldname.Substring(valIndex + 1));
            }

            var data = new Dictionary<string, object>
            {
                { "NgayNhap", StrThoiGian_DiaDiem },
                { "LOAI_GDTTTT", txtLOAI_GDTTTT },
                { "SOBA", txtSOBA},
                { "NGAYBA", txtNGAYBA },
                { "SoThongBao", txtSoThongBao },
                { "ToaAnThuLy", Str_ToaAnThuLy },
                { "DiaDiem", Str_ToaAnThuLyBody },
                { "CanCuBoLuatTT", txtCanCuBoLuatTT },
                { "TenPhongBan", txtTenPhongBan },
                { "LoaiVuAn", Str_TenLoaiVuAn  },
                { "TenVuAn", tenvuan},
                { "QHPL", txtQHPL  },
                { "NoiDung1", txtNoiDung1 },
                { "NguyenDon", txtNguyenDon },
                { "BiDon", txtBiDon },
                { "NoiDung2", txtNoiDung2 },
                { "DiaChiGuiHS", txtDiaChiGuiHS },
                { "NoiDung3", txtNoiDung3 },
                { "TPTC", txtTPTC },
                { "DonViLuu", txtDonViLuu },
                { "TenDonVi", txtTenDonVi },
                { "TenNguoiKy", txtTENNGUOIKY },
                { "ChucVu", txtChucVu },
                { "TenChucVu", txtTenChucVu }
            };


            reportDocument.MailMerge.Execute(
                data.Keys.ToArray(),
                data.Values.ToArray()
            );

            using (MemoryStream ms = new MemoryStream())
            {
                reportDocument.Save(ms, SaveFormat.Docx);
                byte[] bytes = ms.ToArray();

                Response.Clear();
                Response.ContentType =
                    "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
                Response.AddHeader(
                    "Content-Disposition", "attachment; filename=KetQua.docx");
                Response.BinaryWrite(bytes);
                Response.Flush();
                HttpContext.Current.ApplicationInstance.CompleteRequest();
            }
        }
        void InPhieuMuon_NhieuVuAn()
        {
            String Tab_Character = "     ", NgayTaoHS = "";
            String KyTuXuongDong = "\r\n";
            decimal temp_id = 0;
            string TenPhongBan = "", DiaChiGuiHS = "";

            int PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToInt32(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");
            DM_PHONGBAN objPB = dt.DM_PHONGBAN.Where(x => x.ID == PhongBanID).Single();
            if (objPB != null)
            {
                TenPhongBan = objPB.TENPHONGBAN;
                DiaChiGuiHS = objPB.HAUTOCV;
            }
            //-----------------------------------
            string tenviettat = "";
            switch (PhongBanID)
            {
                case 381://2:
                    tenviettat = "GĐKTI";
                    break;
                case 401:// 3:
                    tenviettat = "GĐKTII";
                    break;
                case 382://4
                    tenviettat = "GĐKTIII";
                    break;
                case 361:
                    tenviettat = "GĐKTIV";
                    break;
                default:
                    tenviettat = TenPhongBan;
                    break;
            }
            //--------------------------------
            HoSo.mMuonHoSoV3 mhs_v3 = new HoSo.mMuonHoSoV3();

            //--------------------------------
            String NoiDung1 = "Tòa án nhân dân tối cao nhận được đơn của các đương sự đề nghị xem xét theo thủ tục giám đốc thẩm đối với các bản án phúc thẩm sau:";
            mhs_v3.Parameters["NoiDung1"].Value = Tab_Character + NoiDung1;

            //--------------------------------
            String SoHieu = "";
            String DSVuAn = "";
            String GroupID = Request["gID" + ""] + "";
            GDTTT_QUANLYHS_BL objBL = new GDTTT_QUANLYHS_BL();
            DataTable tblVuAn = objBL.GetByGroupID(GroupID);
            Decimal ToanAnId = 0;
            string TenToaAn = "";

            Decimal LoaiAnID = 0;
            string BoLuatCanCu_TheoLoaiAn = "";

            if (tblVuAn != null && tblVuAn.Rows.Count > 0)
            {
                int count_item = 0;
                temp_id = 0;
                NgayTaoHS = "ngày " + tblVuAn.Rows[0]["Ngay"] + " tháng " + tblVuAn.Rows[0]["Thang"] + " năm " + tblVuAn.Rows[0]["Nam"];
                //---------------------------------
                foreach (DataRow row in tblVuAn.Rows)
                {
                    SoHieu = row["SoHieu"] + "";
                    temp_id = Convert.ToDecimal(row["TOAPHUCTHAMID"] + "");
                    if (temp_id != ToanAnId)
                    {
                        if (TenToaAn.Length > 0)
                            TenToaAn += ", ";
                        TenToaAn += row["ToaXX"] + "";
                        ToanAnId = temp_id;
                    }

                    //-------------------------
                    temp_id = Convert.ToDecimal(row["LoaiAn"] + "");
                    if (temp_id != LoaiAnID)
                    {
                        if (temp_id == Convert.ToDecimal(ENUM_LOAIVUVIEC.AN_HANHCHINH))
                            BoLuatCanCu_TheoLoaiAn += "Điều 24, khoản 1 Điều 260 Luật tố tụng hành chính; ";
                        else
                            BoLuatCanCu_TheoLoaiAn += "Điều 18, khoản 1 Điều 331 Bộ luật tố tụng dân sự;";

                        LoaiAnID = temp_id;
                    }

                    //------------------------------
                    count_item++;
                    if (count_item > 1)
                        DSVuAn += KyTuXuongDong;

                    DSVuAn += Tab_Character;
                    DSVuAn += count_item.ToString() + ". " + "Bản án " + row["TenLoaiAn"].ToString();
                    DSVuAn += " số " + row["SOANPHUCTHAM"].ToString();
                    DSVuAn += " ngày " + row["NgayXuPhucTham"].ToString();
                    DSVuAn += " của " + row["TOAXX"].ToString();
                    DSVuAn += " giữa:" + KyTuXuongDong;
                    DSVuAn += Tab_Character + "- Người khởi kiện: " + row["NguyenDon"].ToString();
                    DSVuAn += KyTuXuongDong;
                    DSVuAn += Tab_Character + "- Người bị kiện: " + row["BiDon"].ToString();
                }
            }
            mhs_v3.Parameters["ToaAnThuLy"].Value = "Đồng chí Chánh án " + TenToaAn;
            mhs_v3.Parameters["DSVuAn"].Value = DSVuAn;

            //------------------------
            String CanCuBoLuatTT = Tab_Character + "Căn cứ vào khoản 1 Điều 46 Luật tổ chức Tòa án nhân dân; ";
            CanCuBoLuatTT += BoLuatCanCu_TheoLoaiAn;
            CanCuBoLuatTT += "Tòa án nhân dân tối cao đề nghị " + TenToaAn
                             + " chuyển hồ sơ các vụ án trên cho Tòa án nhân dân tối cao trong thời hạn 07 ngày, kể từ ngày nhận được công văn này.";
            mhs_v3.Parameters["CanCuBoLuatTT"].Value = CanCuBoLuatTT;

            //---------------------------------
            String DCGuiHS = "(Hồ sơ xin gửi chuyển phát nhanh về "
                       + "Vụ Giám đốc, kiểm tra III Tòa án nhân dân tối cao số 262 Đội Cấn, quận Ba Đình, TP. Hà Nội; "
                       + "bên ngoài bao bì ghi rõ họ tên nguyên đơn (người khởi kiện), bị đơn (người bị kiện), số bản án và ngày xét xử để "
                           + TenPhongBan + " tiện theo dõi khi nhận hồ sơ);";
            mhs_v3.Parameters["DiaChiGuiHS"].Value = Tab_Character + DCGuiHS;

            //----------------------------
            String NoiDung3 = "Trường hợp hồ sơ vụ án đã được chuyển cho cơ quan, đơn vị khác thì đề nghị Quý Tòa ghi rõ vào phiếu mượn này và gửi lại Vụ Giám đốc, kiểm tra III để theo dõi.";
            mhs_v3.Parameters["NoiDung3"].Value = NoiDung3;

            //----------------------------------------------
            mhs_v3.Parameters["TenDonVi"].Value = TenPhongBan.ToUpper();
            mhs_v3.Parameters["DonViLuu"].Value = "Vụ " + tenviettat + "-TANDTC";

            mhs_v3.Parameters["SoThongBao"].Value = (string.IsNullOrEmpty(SoHieu) ? "....." : SoHieu) + "/ PM/TANDTC-" + tenviettat;
            mhs_v3.Parameters["DiaDiem"].Value = "Hà Nội, " + NgayTaoHS;
            reportcontrol.OpenReport(mhs_v3);
        }
        void InHoSo_MotVuAn()
        {
            String Tab_Character = "       ";
            decimal temp_id = 0;
            string TenPhongBan = "", DiaChiGuiHS = "", Nguyendon = "", bidon = "";
            DateTime now = DateTime.Now;
            string quanhephapluat = "", V_QHPL_TEXT = "";
            String ToaAnThuLy = "", tenvuan = "", sobanan = "", ngaybanan = "";
            int PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToInt32(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");
            DM_PHONGBAN objPB = dt.DM_PHONGBAN.Where(x => x.ID == PhongBanID).Single();
            if (objPB != null)
            {
                TenPhongBan = objPB.TENPHONGBAN;
                DiaChiGuiHS = objPB.HAUTOCV;
            }
            //-----------------------------------
            string tenviettat = "";
            switch (PhongBanID)
            {
                case 381://2:
                    tenviettat = "GĐKTI";
                    break;
                case 401:// 3:
                    tenviettat = "GĐKTII";
                    break;
                case 382://4
                    tenviettat = "GĐKTIII";
                    break;
                case 361:
                    tenviettat = "GĐKTIV";
                    break;
                default:
                    tenviettat = TenPhongBan;
                    break;
            }
            //--------------------------------
            int loai_vu_an = 0;
            String Str_LoaiVuAn = "";
            String Str_TenLoaiVuAn = "";
            String Str_ToaAnThuLy = "";
            String Str_ToaAnThuLyBody = "";
            String StrToaXuDenghi = "";
            decimal? thamphanid = null;
            Decimal hsId = String.IsNullOrEmpty(Request["hsID"] + "") ? 0 : Convert.ToDecimal(Request["hsID"] + "");
            Decimal VuAnId = String.IsNullOrEmpty(Request["vid"] + "") ? 0 : Convert.ToDecimal(Request["vID"] + "");
            if (VuAnId > 0)
            {
                GDTTT_VUAN objVA = dt.GDTTT_VUAN.Where(x => x.ID == VuAnId).Single();
                if (objVA != null)
                {
                    thamphanid = objVA.THAMPHANID;
                    loai_vu_an = (int)objVA.LOAIAN;
                    switch (loai_vu_an)
                    {
                        case 1:
                            Str_TenLoaiVuAn = ENUM_STR_LOAIVUVIEC.AN_HINHSU;
                            break;
                        case 2:
                            Str_TenLoaiVuAn = ENUM_STR_LOAIVUVIEC.AN_DANSU;
                            break;
                        case 3:
                            Str_TenLoaiVuAn = ENUM_STR_LOAIVUVIEC.AN_HONNHAN_GIADINH;
                            break;
                        case 4:
                            Str_TenLoaiVuAn = ENUM_STR_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI;
                            break;
                        case 5:
                            Str_TenLoaiVuAn = ENUM_STR_LOAIVUVIEC.AN_LAODONG;
                            break;
                        case 6:
                            Str_TenLoaiVuAn = ENUM_STR_LOAIVUVIEC.AN_HANHCHINH;
                            break;
                        case 7:
                            Str_TenLoaiVuAn = ENUM_STR_LOAIVUVIEC.AN_PHASAN;
                            break;
                        default:
                            Str_TenLoaiVuAn = loai_vu_an.ToString();
                            break;
                    }
                    if (loai_vu_an < 10)
                        Str_LoaiVuAn = "0" + loai_vu_an.ToString();

                    tenvuan = objVA.TENVUAN;
                    temp_id = (string.IsNullOrEmpty(objVA.QHPL_DINHNGHIAID + "")) ? 0 : (decimal)objVA.QHPL_DINHNGHIAID;
                    try
                    {
                        if (temp_id > 0)
                            quanhephapluat = dt.GDTTT_DM_QHPL.Where(x => x.ID == temp_id).Single().TENQHPL;
                    }
                    catch (Exception ex) { }

                    V_QHPL_TEXT = objVA.QHPL_TEXT;
                    DM_TOAAN objTA;
                    DM_TOAAN_TACH_NHAP_MAPPING_BL bl = new DM_TOAAN_TACH_NHAP_MAPPING_BL();
                    decimal V_TOTOAANID = 0;
                    if (objVA.BAQD_CAPXETXU == 2)
                    {
                        sobanan = objVA.SOANSOTHAM;
                        ngaybanan = ((DateTime)objVA.NGAYXUSOTHAM).ToString("dd/MM/yyyy", cul);
                        // Lấy dữ liệu từ BL
                        DataTable v_tb = bl.GETS_BY_TOAAN_ID(Convert.ToDecimal(objVA.TOAANSOTHAM));
                        if (v_tb != null && v_tb.Rows.Count != 0)
                        {
                            V_TOTOAANID = Convert.ToDecimal(v_tb.Rows[0]["TOTOAANID"].ToString());
                            objTA = dt.DM_TOAAN.Where(x => x.ID == V_TOTOAANID).FirstOrDefault();
                        }
                        else
                        {
                            objTA = dt.DM_TOAAN.Where(x => x.ID == objVA.TOAANSOTHAM).FirstOrDefault();
                        }
                        //--------------------
                    }
                    else if (objVA.BAQD_CAPXETXU == 3)
                    {
                        sobanan = objVA.SOANPHUCTHAM;
                        ngaybanan = ((DateTime)objVA.NGAYXUPHUCTHAM).ToString("dd/MM/yyyy", cul);
                        DataTable v_tb = bl.GETS_BY_TOAAN_ID(Convert.ToDecimal(objVA.TOAPHUCTHAMID));
                        if (v_tb != null && v_tb.Rows.Count != 0)
                        {
                            V_TOTOAANID = Convert.ToDecimal(v_tb.Rows[0]["TOTOAANID"].ToString());
                            objTA = dt.DM_TOAAN.Where(x => x.ID == V_TOTOAANID).FirstOrDefault();
                        }
                        else
                        {
                            objTA = dt.DM_TOAAN.Where(x => x.ID == objVA.TOAPHUCTHAMID).FirstOrDefault();
                        }
                        //-------------------------
                    }
                    else
                    {
                        sobanan = objVA.SO_QDGDT;
                        ngaybanan = ((DateTime)objVA.NGAYQD).ToString("dd/MM/yyyy", cul);
                        DataTable v_tb = bl.GETS_BY_TOAAN_ID(Convert.ToDecimal(objVA.TOAQDID));
                        if (v_tb != null && v_tb.Rows.Count != 0)
                        {
                            V_TOTOAANID = Convert.ToDecimal(v_tb.Rows[0]["TOTOAANID"].ToString());
                            objTA = dt.DM_TOAAN.Where(x => x.ID == V_TOTOAANID).FirstOrDefault();
                        }
                        else
                        {
                            objTA = dt.DM_TOAAN.Where(x => x.ID == objVA.TOAQDID).FirstOrDefault();
                        }

                    }

                    Nguyendon = objVA.NGUYENDON;
                    bidon = objVA.BIDON;


                    Str_ToaAnThuLyBody = objTA.MA_TEN;
                    if (objTA.LOAITOA == "CAPCAO")
                    {
                        var result = objTA.MA_TEN.Split(new[] { "tại" }, StringSplitOptions.None);
                        Str_ToaAnThuLy = result[0] + "\r\n" + "tại" + result[1];
                    }
                    else
                    {
                        Str_ToaAnThuLy = Str_ToaAnThuLyBody;
                    }
                    //ToaAnThuLy = "<i>Kính gửi: </i>" + "<b>" + Str_ToaAnThuLy + "</b>";
                    ToaAnThuLy = Str_ToaAnThuLy;
                    if (objVA.BAQD_CAPXETXU == 4)
                    {
                        objTA = dt.DM_TOAAN.Where(x => x.ID == objVA.TOAQDID).Single();
                        StrToaXuDenghi = objTA.MA_TEN;
                    }
                    else if (objVA.BAQD_CAPXETXU == 2)
                    {
                        objTA = dt.DM_TOAAN.Where(x => x.ID == objVA.TOAANSOTHAM).Single();
                        StrToaXuDenghi = objTA.MA_TEN;
                    }
                    else
                    {
                        objTA = dt.DM_TOAAN.Where(x => x.ID == objVA.TOAPHUCTHAMID).Single();
                        StrToaXuDenghi = objTA.MA_TEN;
                    }
                }
            }
            //----------------------------------
            GDTTT_QUANLYHS objHS = dt.GDTTT_QUANLYHS.Where(x => x.ID == hsId).Single();

            String SoHieu = objHS.SOPHIEU + "";
            DateTime ngay_hs = Convert.ToDateTime(objHS.NGAYTAO + "");
            String StrThoiGian_DiaDiem = "Hà Nội, ngày " + ngay_hs.Day.ToString() + " tháng " + ngay_hs.Month.ToString("D2") + " năm " + ngay_hs.Year.ToString();

            HoSo.mHoSoV3 mhs_v3 = null;
            HoSo.mHoSo mhs = null;
            if (PhongBanID == 382)
            {
                mhs_v3 = new HoSo.mHoSoV3();
                mhs_v3.Parameters["TenDonVi"].Value = " VỤ GIÁM ĐỐC, KIỂM TRA III";//TenPhongBan.ToUpper();
                mhs_v3.Parameters["DonViLuu"].Value = "Vụ " + tenviettat + "-TANDTC";

                mhs_v3.Parameters["SoThongBao"].Value = SoHieu + "/RHS-" + tenviettat;///PM/TANDTC-
                mhs_v3.Parameters["DiaDiem"].Value = StrThoiGian_DiaDiem;

                mhs_v3.Parameters["CanCuBoLuatTT"].Value = Tab_Character + "Căn cứ vào khoản 1 Điều 46 Luật Tổ chức Tòa án nhân dân và Điều 18 Bộ luật Tố tụng dân sự;";
            }
            else
            {
                mhs = new HoSo.mHoSo();
                mhs.Parameters["TenDonVi"].Value = TenPhongBan.ToUpper();
                mhs.Parameters["DonViLuu"].Value = "Vụ " + tenviettat + "-TANDTC";

                mhs.Parameters["SoThongBao"].Value = (string.IsNullOrEmpty(SoHieu) ? "....." : SoHieu) + "/ CV-" + tenviettat;
                mhs.Parameters["DiaDiem"].Value = StrThoiGian_DiaDiem;

                mhs.Parameters["CanCuBoLuatTT"].Value = Tab_Character + "Căn cứ vào khoản 1 Điều 46 Luật Tổ chức Tòa án nhân dân và Điều 18 Bộ luật Tố tụng dân sự;";
            }

            //-----------------------------------------
            String CanCuBoLuatTT = "";
            string Noidung_2 = "";
            String Noidung_3 = "";


            int LoaiHs = Convert.ToInt16(objHS.LOAI);
            int IsMuonHS_VKS = (string.IsNullOrEmpty(objHS.ISMUONHOSOVKS + "")) ? 0 : Convert.ToInt16(objHS.ISMUONHOSOVKS);
            string Noidung = "";
            if (LoaiHs == 0)
            {
                if (PhongBanID == 382)//4
                {
                    ////-------------vu 3---------------
                    //Noidung = "Tòa án nhân dân tối cao nhận được " + "Đơn đề nghị ";/// Văn bản kiến nghị ";
                    //Noidung += "xem xét theo thủ tục Giám đốc thẩm/tái thẩm đối với Bản án ";
                    //Noidung += "số " + sobanan + " ngày " + ngaybanan + " ";
                    //Noidung += "của " + ToaAnThuLy + " ";
                    //Noidung += "về việc " + quanhephapluat + " giữa:";

                    Noidung = "Để có cơ sở giải quyết đơn đề nghị xem xét theo thủ tục giám đốc thẩm, tái thẩm của đương sự,";
                    // Noidung += " đề nghị " + ToaAnThuLy + " chỉ đạo chuyển cho " + TenPhongBan
                    Noidung += " đề nghị " + Str_ToaAnThuLyBody + " chuyển cho Vụ Giám đốc, kiểm tra III"
                            + " hồ sơ vụ án " + Str_TenLoaiVuAn + " về việc \""
                            + V_QHPL_TEXT
                            + "\" giữa các đương sự là:";
                    //Noidung += @"{\rtf1\ansi\deff0 "
                    //        + " đề nghị " + ToaAnThuLy + " chuyển cho Vụ Giám đốc, kiểm tra III"
                    //        + " hồ sơ vụ án " + Str_TenLoaiVuAn + " về việc \""
                    //        + @"\i " + V_QHPL_TEXT + @"\i0 "
                    //        + "\" giữa các đương sự là:"
                    //        + "}";
                }
                else
                {
                    //-------------vu 2---------------
                    Noidung = "Để có cơ sở giải quyết đơn đề nghị xem xét theo thủ tục giám đốc thẩm, tái thẩm của đương sự,";
                    Noidung += " đề nghị " + Str_ToaAnThuLyBody + " chỉ đạo chuyển cho " + TenPhongBan
                        + " - Tòa án nhân dân tối cao hồ sơ vụ án \"" + quanhephapluat + "\" giữa các đương sự là:";
                    //Noidung = @"{\rtf1\ansi\deff0 "
                    //+ " đề nghị " + ToaAnThuLy + " chỉ đạo chuyển cho " + TenPhongBan
                    //+ " - Tòa án nhân dân tối cao hồ sơ vụ án \""
                    //+ @"\i " + quanhephapluat + @"\i0 "
                    //+ "\" giữa các đương sự là:"
                    //+ "}";
                }
            }

            //--------------------------------------------
            String DCGuiHS = "";
            if (PhongBanID == 382)
            {
                if (IsMuonHS_VKS == 0)
                    mhs_v3.Parameters["ToaAnThuLy"].Value = ToaAnThuLy;//mhs_v3.Parameters["ToaAnThuLy"].Value = "Đồng chí Chánh án " + ToaAnThuLy;
                else
                    mhs_v3.Parameters["ToaAnThuLy"].Value = "Đồng chí Viện trưởng " + Str_ToaAnThuLyBody;
                //-------------vu 3---------------
                CanCuBoLuatTT = "Căn cứ vào khoản 1 Điều 46 Luật Tổ chức Tòa án nhân dân; ";
                if (Str_LoaiVuAn == ENUM_LOAIVUVIEC.AN_HANHCHINH)
                {
                    if (IsMuonHS_VKS == 0)
                        CanCuBoLuatTT += "Điều 24, khoản 1 Điều 260 Luật tố tụng hành chính; ";
                    else
                        CanCuBoLuatTT += "Điều 24, khoản 1 Điều 260 Luật tố tụng hành chính"
                                         + " và Thông tư liên tịch số 03/2016/TTLT-VKSNDTC-TANDTC ngày 31/8/2016 của Viện kiểm sát nhân dân tối cao, Tòa án nhân dân tối cao; ";
                }
                else
                {
                    //if (IsMuonHS_VKS == 0)
                    //    CanCuBoLuatTT += "Điều 18, khoản 1 Điều 331 Bộ luật tố tụng dân sự;";
                    //else
                    //    CanCuBoLuatTT += "Điều 18, khoản 1 Điều 331 Bộ luật tố tụng dân sự"
                    //                     + " và Thông tư liên tịch số 02/2016/TTLT-VKSNDTC-TANDTC ngày 31/8/2016 của Viện kiểm sát nhân dân tối cao, Tòa án nhân dân tối cao; ";
                }
                CanCuBoLuatTT += " Tòa án nhân dân tối cao đề nghị " + Str_ToaAnThuLyBody
                               + " chuyển hồ sơ vụ án nêu trên cho Tòa án nhân dân tối cao trong thời hạn 07 ngày, kể từ ngày nhận được công văn này.";

                //DCGuiHS = "(Hồ sơ xin gửi chuyển phát nhanh về "
                //        + "Vụ Giám đốc, kiểm tra III Tòa án nhân dân tối cao số 262 Đội Cấn, quận Ba Đình, TP. Hà Nội; "
                //        + "bên ngoài bao bì ghi rõ họ tên nguyên đơn, bị đơn, số bản án và ngày xét xử để "
                //            + TenPhongBan + " tiện theo dõi khi nhận hồ sơ);";
                Noidung_2 = "Do " + StrToaXuDenghi + " xét xử phúc thẩm tại Bản án phúc thẩm số " + sobanan + " ngày " + ngaybanan + ".";

                DCGuiHS = "(Hồ sơ gửi chuyển phát nhanh đến Vụ Giám đốc kiểm tra III Toà án nhân dân tối cao; Địa chỉ: Ngõ 1, đường Phạm Văn Bạch, phường Cầu Giấy, Tp. Hà Nội).";
                Noidung_3 = "Trường hợp hồ sơ vụ án đã được chuyển cho cơ quan, đơn vị khác thì đề nghị " + Str_ToaAnThuLyBody + " thông báo lại cho Vụ Giám đốc, kiểm tra III Tòa án nhân dân tối cao để theo dõi.";
            }
            else
            {
                //-------------vu 2---------------
                Noidung_2 = "Do " + Str_ToaAnThuLyBody + " xét xử phúc thẩm tại Bản án phúc thẩm số " + sobanan + " ngày " + ngaybanan + ".";
                DCGuiHS = "(Hồ sơ xin gửi phát nhanh theo địa chỉ: " + TenPhongBan
                            + " Tòa án nhân dân tối cao ";
            }

            if (PhongBanID == 382)//4
            {
                mhs_v3.Parameters["NoiDung1"].Value = Tab_Character + Noidung;
                if (Str_LoaiVuAn != ENUM_LOAIVUVIEC.AN_HANHCHINH)
                {
                    mhs_v3.Parameters["NguyenDon"].Value = Tab_Character + "- Nguyên đơn: " + Nguyendon;
                    mhs_v3.Parameters["BiDon"].Value = Tab_Character + "- Bị đơn: " + bidon;
                }
                else
                {
                    mhs_v3.Parameters["NguyenDon"].Value = Tab_Character + "- Người khởi kiện: " + Nguyendon;
                    mhs_v3.Parameters["BiDon"].Value = Tab_Character + "- Người bị kiện: " + bidon;
                }
                //mhs_v3.Parameters["CanCuBoLuatTT"].Value = Tab_Character + CanCuBoLuatTT;
                mhs_v3.Parameters["NoiDung2"].Value = Tab_Character + Noidung_2;
                mhs_v3.Parameters["NoiDung3"].Value = Tab_Character + Noidung_3;

                mhs_v3.Parameters["DiaChiGuiHS"].Value = Tab_Character + DCGuiHS;// + ((!String.IsNullOrEmpty(DiaChiGuiHS)) ? " tại địa chỉ:" + DiaChiGuiHS : "") + ")";

                //DM_CANBO objCB = dt.DM_CANBO.Where(x => x.PHONGBANID == 382 && x.CHUCVUID== 432).SingleOrDefault();
                //mhs_v3.Parameters["TENNGUOIKY"].Value = "";
                //if (objCB != null)
                //{
                //    mhs_v3.Parameters["TENNGUOIKY"].Value = Tab_Character + objCB.HOTEN;
                //}
                var objCBs = dt.DM_CANBO.Where(x => x.PHONGBANID == 382).ToArray();
                if (objCBs.Length > 0)
                {
                    DM_CANBO objCB = objCBs.Where(x => x.CHUCVUID == 432).SingleOrDefault();
                    mhs_v3.Parameters["TENNGUOIKY"].Value = "";
                    if (objCB != null)
                    {
                        mhs_v3.Parameters["TENNGUOIKY"].Value = Tab_Character + objCB.HOTEN;
                    }
                    //nếu là tp bậc 3 thì thêm 1 dòng
                    objCB = objCBs.Where(x => x.CHUCDANHID == 2318).SingleOrDefault();//thẩm phán bậc 3
                    if (objCB != null)
                    {
                        mhs_v3.Parameters["TPTC"].Value += "\r\n" + "- TP " + objCB.HOTEN + " (để biết)";
                    }

                    //objCB = objCBs.Where(x => x.CHUCDANHID == 2318).SingleOrDefault();//thẩm phán bậc 3
                    //mhs_v3.Parameters["TPB3"].Value = "";
                    //if (objCB != null)
                    //{
                    //    mhs_v3.Parameters["TPB3"].Value = "- " +objCB.HOTEN + " (để biết)";
                    //}
                }
                //nếu được phân cho thẩm phán tối cao thì thêm 1 dòng ở trên thẩm phán bậc 3
                if (thamphanid != null)
                {
                    DM_CANBO objCB = dt.DM_CANBO.Where(x => x.ID == thamphanid && x.CHUCDANHID == 486).SingleOrDefault();//thẩm phán tối cao
                    if (objCB != null)
                    {
                        mhs_v3.Parameters["TPTC"].Value = "\r\n" + "- TP TANDTC " + objCB.HOTEN + " (để bc)";

                        objCB = objCBs.Where(x => x.CHUCDANHID == 2318).SingleOrDefault();//thẩm phán bậc 3
                        if (objCB != null)
                        {
                            mhs_v3.Parameters["TPTC"].Value += "\r\n" + "- TP " + objCB.HOTEN + " (để biết)";
                        }
                    }
                }

                reportcontrol.OpenReport(mhs_v3);
            }
            else
            {
                mhs.Parameters["ToaAnThuLy"].Value = Str_ToaAnThuLyBody;
                mhs.Parameters["NoiDung1"].Value = Tab_Character + Noidung;
                mhs.Parameters["NguyenDon"].Value = Tab_Character + "- Nguyên đơn: " + Nguyendon;
                mhs.Parameters["BiDon"].Value = Tab_Character + "- Bị đơn: " + bidon;
                mhs.Parameters["NoiDung2"].Value = Tab_Character + Noidung_2;
                mhs.Parameters["DiaChiGuiHS"].Value = Tab_Character + DCGuiHS + ((!String.IsNullOrEmpty(DiaChiGuiHS)) ? " tại địa chỉ:" + DiaChiGuiHS : "") + ")";
                reportcontrol.OpenReport(mhs);
            }
        }
    }
}