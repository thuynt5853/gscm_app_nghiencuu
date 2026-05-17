using BL.GSTP;
using BL.GSTP.AHS;
using DAL.GSTP;
using DevExpress.XtraReports.UI;
using Microsoft.Reporting.WebForms;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Reflection;
using System.IO;
using System.Text.RegularExpressions;
using BL.GSTP.BANGSETGET;

namespace WEB.GSTP.BaoCao.AHS
{
    public partial class ViewReport : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        AHS_REPORT_BL report_BL = new AHS_REPORT_BL();
        CultureInfo cul = new CultureInfo("vi-VN");
        private const string TOASOTHAM = "TOASOTHAM", VKS = "VKS", TOAPHUCTHAM = "TOAPHUCTHAM";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                decimal vDonID = 0;
                string strMaCT = Session["MaChuongTrinh"] + "";
                if (strMaCT == ENUM_LOAIAN.AN_HINHSU)
                {
                    if (Session[ENUM_LOAIAN.AN_HINHSU] != null)
                        vDonID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);
                    AHS_VUAN oVUAN = dt.AHS_VUAN.Where(x => x.ID == vDonID).FirstOrDefault();
                    if (oVUAN.MAGIAIDOAN == ENUM_GIAIDOANVUAN.HOSO || oVUAN.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
                        LoadReportAHS_ST(vDonID, oVUAN);
                    else
                        LoadReportAHS_PT(vDonID, oVUAN);
                }
            }
        }
        private string GetDiaDiem(decimal ToaAnID)
        {
            try
            {
                string strDiadiem = "";
                DM_TOAAN oT = dt.DM_TOAAN.Where(x => x.ID == ToaAnID).FirstOrDefault();
                strDiadiem = oT.TEN.Replace("Tòa án nhân dân ", "");
                switch (oT.LOAITOA)
                {
                    case "CAPHUYEN":
                        DM_TOAAN opT = dt.DM_TOAAN.Where(x => x.ID == oT.CAPCHAID).FirstOrDefault();
                        strDiadiem = opT.TEN.Replace("Tòa án nhân dân ", "");
                        strDiadiem = strDiadiem.Replace("tỉnh", "");
                        strDiadiem = strDiadiem.Replace("Tỉnh", "");
                        strDiadiem = strDiadiem.Replace("thành phố", "");
                        strDiadiem = strDiadiem.Replace("Thành phố", "");
                        strDiadiem = strDiadiem.Replace("tại", "");
                        strDiadiem = strDiadiem.Replace("Tại", "");
                        if (strDiadiem.Contains("Hồ Chí Minh"))
                            strDiadiem = "Tp. " + strDiadiem.Trim();
                        break;
                    case "CAPTINH":
                        strDiadiem = strDiadiem.Replace("tỉnh", "");
                        strDiadiem = strDiadiem.Replace("Tỉnh", "");
                        strDiadiem = strDiadiem.Replace("thành phố", "");
                        strDiadiem = strDiadiem.Replace("Thành phố", "");
                        strDiadiem = strDiadiem.Replace("tại", "");
                        strDiadiem = strDiadiem.Replace("Tại", "");
                        if (strDiadiem.Contains("Hồ Chí Minh"))
                            strDiadiem = "Tp. " + strDiadiem.Trim();
                        break;
                    case "CAPCAO":
                        strDiadiem = strDiadiem.Replace("cấp cao", "");
                        strDiadiem = strDiadiem.Replace("tỉnh", "");
                        strDiadiem = strDiadiem.Replace("Tỉnh", "");
                        strDiadiem = strDiadiem.Replace("thành phố", "");
                        strDiadiem = strDiadiem.Replace("Thành phố", "");
                        strDiadiem = strDiadiem.Replace("tại", "");
                        strDiadiem = strDiadiem.Replace("Tại", "");
                        if (strDiadiem.Contains("Hồ Chí Minh"))
                            strDiadiem = "Tp. " + strDiadiem.Trim();
                        break;
                }
                return strDiadiem;
            }
            catch { return ""; }
        }
        private string GetTenToa(decimal TOAANID, bool IsShowToaCapTren)
        {
            try
            {
                string strTenToa = "";
                DM_TOAAN oT = dt.DM_TOAAN.Where(x => x.ID == TOAANID).FirstOrDefault();
                if (oT != null)
                {
                    if (IsShowToaCapTren)
                        strTenToa = oT.MA_TEN;
                    else strTenToa = oT.TEN;
                }
                if (strTenToa.Contains("cấp cao"))
                {
                    strTenToa = strTenToa.Replace("cấp cao", "cấp cao\n");
                }
                else if (!strTenToa.Contains("tối cao"))
                {
                    strTenToa = strTenToa.Replace("Tòa án nhân dân", "TAND").Replace(",", "");
                }
                return strTenToa;
            }
            catch { return ""; }
        }
        private string GetVKS(decimal VKSID)
        {
            try
            {
                string strTenVKS = "";
                DM_VKS oT = dt.DM_VKS.Where(x => x.ID == VKSID).FirstOrDefault();
                strTenVKS = oT.TEN;
                return strTenVKS;
            }
            catch { return ""; }
        }
        private string GetCanBo(decimal CanboID)
        {
            try
            {
                string strTenCanBo = "";
                DM_CANBO oT = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault();
                strTenCanBo = oT.HOTEN;
                return strTenCanBo;
            }
            catch { return ""; }
        }
        private string GetCanBoGioiTinh(decimal TPID)
        {
            try
            {
                string strTenCanBo = "";
                DM_CANBO oCanbo = dt.DM_CANBO.Where(x => x.ID == TPID).FirstOrDefault();
                if (oCanbo != null)
                {
                    if (oCanbo.GIOITINH == 1)
                        strTenCanBo = "Ông " + oCanbo.HOTEN;
                    else
                        strTenCanBo = "Bà " + oCanbo.HOTEN;
                }
                return strTenCanBo;
            }
            catch { return ""; }
        }
        private string GetChucDanh_CanBo(decimal CanBoID)
        {
            string StrChucDanh = "";
            DM_CANBO cbo = dt.DM_CANBO.Where(x => x.ID == CanBoID).FirstOrDefault();
            if (cbo != null)
            {
                DM_DATAITEM ChucDanh = dt.DM_DATAITEM.Where(x => x.ID == cbo.CHUCDANHID).FirstOrDefault();
                if (ChucDanh != null)
                {
                    StrChucDanh = ChucDanh.TEN;
                }
            }
            return StrChucDanh;
        }
        private string GetDiachi(decimal HuyenID)
        {
            try
            {
                string strDiaChi = "";
                DM_HANHCHINH oT = dt.DM_HANHCHINH.Where(x => x.ID == HuyenID).FirstOrDefault();
                strDiaChi = oT.MA_TEN;
                return strDiaChi;
            }
            catch { return ""; }
        }
        private string getChanhAnByToaAn(decimal ToaAnID)
        {
            string TenChanhAn = ""; decimal cvChanhAnID = 0;
            DM_DATAGROUP gChucVu = dt.DM_DATAGROUP.Where(x => x.MA == ENUM_DANHMUC.CHUCVU).FirstOrDefault();
            if (gChucVu != null)
            {
                DM_DATAITEM cvChanhAn = dt.DM_DATAITEM.Where(x => x.MA == ENUM_CHUCVU.CHUCVU_CA && x.GROUPID == gChucVu.ID).FirstOrDefault();
                if (cvChanhAn != null)
                {
                    cvChanhAnID = cvChanhAn.ID;
                }
            }
            DM_CANBO cbChanhAn = dt.DM_CANBO.Where(x => x.TOAANID == ToaAnID && x.CHUCVUID == cvChanhAnID).FirstOrDefault();
            if (cbChanhAn != null)
            {
                TenChanhAn = cbChanhAn.HOTEN;
            }
            return TenChanhAn;
        }
        private bool VuAnIsQuyetDinhXetXu(decimal vVuAnID)
        {
            DM_QD_LOAI LQD = dt.DM_QD_LOAI.Where(x => x.HIEULUC == 1 && x.ISHINHSU == 1 && x.MA == "DVARXX").FirstOrDefault();
            if (LQD != null)
            {
                AHS_SOTHAM_QUYETDINH_VUAN QDVA = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.VUANID == vVuAnID && x.LOAIQDID == LQD.ID).FirstOrDefault();
                if (QDVA != null)
                {
                    return true;
                }
            }
            return false;
        }
        private void LoadReportAHS_ST(decimal vVuAnID, AHS_VUAN oVuAN)
        {
            try
            {
                rptView.Visible = true;
                string strDiadiem = GetDiaDiem((decimal)oVuAN.TOAANID), vMaBC = "", strTenToaAn = GetTenToa((decimal)oVuAN.TOAANID, true),
                    strDiaChiTamTru = "", strDiaChiThuongTru = "", strTenChanhAn = "", strChucVuChanhAn = "", strTitleDVThiHanh = "", strTenNguoiKy = "", strChucVuNguoiKy = "",
                    strTPChuToa = "";
                bool IsToaQuanSu = false;
                decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), BieuMauID = 0, IDLQD = 0,
                    IDQD = 0, BanAnID = 0;
                if (Request["BM"] != null)
                    vMaBC = Request["BM"] + "";
                DM_BIEUMAU bm = dt.DM_BIEUMAU.Where(x => x.MABM == vMaBC).FirstOrDefault();
                if (bm != null)
                {
                    BieuMauID = bm.ID;
                }
                AHS_SOTHAM_BANAN STBA = dt.AHS_SOTHAM_BANAN.Where(x => x.VUANID == vVuAnID && x.TOAANID == oVuAN.TOAANID).OrderByDescending(x => x.NGAYBANAN).FirstOrDefault();
                if (STBA != null)
                {
                    BanAnID = STBA.ID;
                }
                DM_QD_LOAI oLQD = dt.DM_QD_LOAI.Where(x => x.MA == "BTG").FirstOrDefault();
                if (oLQD != null) IDLQD = oLQD.ID;
                DM_TOAAN ToaAn = dt.DM_TOAAN.Where(x => x.ID == oVuAN.TOAANID).FirstOrDefault();
                if (ToaAn != null)
                {
                    if (ToaAn.LOAITOA.Contains("QS"))// các tòa quân sự
                    {
                        strTitleDVThiHanh = "Đơn vị Cảnh vệ";
                        IsToaQuanSu = true;
                    }
                    else
                    {
                        strTitleDVThiHanh = "Công an";
                        IsToaQuanSu = false;
                    }
                }
                AHS_SOTHAM_THULY oThuLy = dt.AHS_SOTHAM_THULY.Where(x => x.VUANID == vVuAnID).OrderByDescending(x => x.NGAYTHULY).FirstOrDefault();              
                //Hội đồng xét xử
                List<AHS_SOTHAM_HDXX> lstHD = dt.AHS_SOTHAM_HDXX.Where(x => x.VUANID == vVuAnID).ToList();
                AHS_SOTHAM_HDXX TPChuToa = lstHD.Where(x => x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN).FirstOrDefault();
                if (TPChuToa != null)
                {
                    strTPChuToa = GetCanBoGioiTinh((decimal)TPChuToa.CANBOID);
                    DM_CANBO cboNguoiPhanCong = dt.DM_CANBO.Where(x => x.ID == TPChuToa.NGUOIPHANCONGID).FirstOrDefault();
                    if (cboNguoiPhanCong != null)
                    {
                        strTenChanhAn = cboNguoiPhanCong.HOTEN;
                        decimal ChucVuID = cboNguoiPhanCong.CHUCVUID + "" == "" ? 0 : (decimal)cboNguoiPhanCong.CHUCVUID;
                        DM_DATAITEM ChucVu = dt.DM_DATAITEM.Where(x => x.ID == ChucVuID).FirstOrDefault();
                        if (ChucVu != null)
                        {
                            strChucVuChanhAn = ChucVu.TEN;
                        }
                    }
                }
                DTBIEUMAU objDTBieuMau = new DTBIEUMAU();
                if (vMaBC == "01-HS")
                {
                    DataTable tbl = report_BL.DTReport_AHS_By_VuAnID_GiaiDoan(vVuAnID, ENUM_GIAIDOANVUAN.SOTHAM, "AHS_01");
                    if (tbl.Rows.Count > 0)
                    {   
                        idTitle.Text = "01-HS. Phân công Phó Chánh án Tòa án, Thẩm phán, Hội thẩm giải quyết, xét xử vụ án hình sự";
                        for (int i = 0; i < tbl.Rows.Count; i++)
                        {
                            tbl.Rows[i]["v_TENTOAAN"] = strTenToaAn.ToUpper();
                        }
                        rpt01HS rpt = new rpt01HS();
                        rpt.DataSource = tbl;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không có dữ liệu";
                    }
                }
                else if (vMaBC == "02-HS")
                {
                    DataTable tbl = report_BL.DTReport_AHS_By_VuAnID_GiaiDoan(vVuAnID, ENUM_GIAIDOANVUAN.SOTHAM, "AHS_02");
                    if (tbl.Rows.Count > 0)
                    {
                        idTitle.Text = "02-HS. Phân công Thư ký Tòa án tiến hành tố tụng đối với vụ án hình sự; quyết định phân công Thẩm tra viên thẩm tra hồ sơ vụ án hình sự";
                        for (int i = 0; i < tbl.Rows.Count; i++)
                        {
                            tbl.Rows[i]["v_TENTOAAN"] = strTenToaAn.ToUpper();
                        }
                        rpt02HS rpt = new rpt02HS();
                        rpt.DataSource = tbl;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không có dữ liệu";
                    }
                }
                else if (vMaBC == "03-HS")
                {
                    DataTable tbl = report_BL.DTReport_AHS_By_VuAnID_GiaiDoan(vVuAnID, ENUM_GIAIDOANVUAN.SOTHAM, "AHS_03");
                    if (tbl.Rows.Count > 0)
                    {
                        idTitle.Text = "03-HS. Thay đổi Thẩm phán, Hội thẩm, Thư ký trước khi mở phiên tòa";
                        for (int i = 0; i < tbl.Rows.Count; i++)
                        {
                            tbl.Rows[i]["v_TENTOAAN"] = strTenToaAn.ToUpper();
                        }
                        rpt03HS rpt = new rpt03HS();
                        rpt.DataSource = tbl;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không có dữ liệu";
                    }
                }
                else if (vMaBC == "04-HS")
                {
                    // Biểu mẫu sẽ nhân bản theo danh sách bị can áp dụng biểu mẫu
                    idTitle.Text = "04-HS. Quyết định tạm giam";
                    IDQD = 0;
                    AHS_SOTHAM_QUYETDINH_BICAN QDBC = null;
                    AHS_BICANBICAO BiCan = null; DTBIEUMAU.DTBM04HSRow r04HS;
                    DM_HANHCHINH hc = null; DM_DATAITEM NgheNghiep = null;
                    DM_QD_QUYETDINH oDMQD = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == IDLQD && x.MA == "04-HS").FirstOrDefault();
                    if (oDMQD != null) IDQD = oDMQD.ID;
                    List<AHS_FILE> lstBiCan_BM = dt.AHS_FILE.Where(x => x.BIEUMAUID == BieuMauID && x.VUANID == vVuAnID && x.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM && x.BICAOID != null).ToList();
                    if (lstBiCan_BM.Count > 0)
                    {
                        foreach (AHS_FILE item in lstBiCan_BM)
                        {
                            QDBC = dt.AHS_SOTHAM_QUYETDINH_BICAN.Where(x => x.BICANID == item.BICAOID && x.VUANID == vVuAnID && x.QUYETDINHID == IDQD).FirstOrDefault();
                            r04HS = objDTBieuMau.DTBM04HS.NewDTBM04HSRow();
                            r04HS.TENTOAAN = strTenToaAn;
                            if (QDBC != null)
                            {
                                DateTime? oNgayQD = QDBC.NGAYQD + "" == "" ? (DateTime?)null : (DateTime)QDBC.NGAYQD;
                                if (oNgayQD != null)
                                {
                                    DateTime NgayQD = (DateTime)oNgayQD;
                                    r04HS.NGAYQD = string.Format("{0:00}", NgayQD.Day);
                                    r04HS.THANGQD = string.Format("{0:00}", NgayQD.Month);
                                    r04HS.NAMQD = NgayQD.Year.ToString();
                                    r04HS.SOQD = QDBC.SOQUYETDINH + "/" + NgayQD.Year.ToString();
                                }
                                if (QDBC.HIEULUCTU != null && QDBC.HIEULUCDEN != null)
                                {
                                    int TotalNgay = ((DateTime)QDBC.HIEULUCDEN).Subtract((DateTime)QDBC.HIEULUCTU).Days;
                                    r04HS.THOIHANTAMGIAM = TotalNgay + " ngày (" + Cls_Comon.NumberToTextVN(TotalNgay).Replace(" đồng", "").Replace(",", "") + " ngày)";
                                }
                                else
                                {
                                    r04HS.THOIHANTAMGIAM = "0 ngày (Không ngày)";
                                }
                                r04HS.TUNGAY = QDBC.HIEULUCTU + "" == "" ? "" : ((DateTime)QDBC.HIEULUCTU).ToString("dd/MM/yyyy");
                                r04HS.NOIGIAMGIU = QDBC.NOIGIAMGIU;
                                DM_CANBO oCanBo = dt.DM_CANBO.Where(x => x.ID == QDBC.NGUOIKYID).FirstOrDefault();
                                if (oCanBo != null)
                                {
                                    strTenNguoiKy = oCanBo.HOTEN;
                                    AHS_SOTHAM_HDXX oMaVaiTro = dt.AHS_SOTHAM_HDXX.Where(x => x.VUANID == vVuAnID && x.CANBOID == oCanBo.ID && x.MAVAITRO == "THAMPHAN").FirstOrDefault();
                                    if (oMaVaiTro != null)
                                    {
                                        strChucVuNguoiKy = "Thẩm Phán Chủ Tọa";
                                    }
                                    else
                                    {
                                        AHS_THAMPHANGIAIQUYET oMaVaiTro2 = dt.AHS_THAMPHANGIAIQUYET.Where(x => x.VUANID == vVuAnID && x.CANBOID == oCanBo.ID && x.MAVAITRO == "VTTP_GIAIQUYETSOTHAM").FirstOrDefault();
                                        if (oMaVaiTro2 != null)
                                        {
                                            strChucVuNguoiKy = "Thẩm Phán Chủ Tọa";
                                        }
                                        else
                                        {
                                            DM_DATAITEM oChucVu = dt.DM_DATAITEM.Where(x => x.ID == oCanBo.CHUCVUID).FirstOrDefault();
                                            if (oChucVu != null)
                                            {
                                                strChucVuNguoiKy = oChucVu.TEN;
                                            }
                                        }
                                    }
                                }
                            }
                            r04HS.DIADIEM = strDiadiem;
                            if (oThuLy != null)
                            {
                                DateTime? oNgayTL = oThuLy.NGAYTHULY + "" == "" ? (DateTime?)null : (DateTime)oThuLy.NGAYTHULY;
                                if (oNgayTL != null)
                                {
                                    DateTime NgayTL = (DateTime)oNgayTL;
                                    r04HS.NGAYTHULY = string.Format("{0:00}", NgayTL.Day);
                                    r04HS.THANGTHULY = string.Format("{0:00}", NgayTL.Month);
                                    r04HS.NAMTHULY = NgayTL.Year.ToString();
                                    r04HS.SOTHULY = oThuLy.SOTHULY + "/" + NgayTL.Year.ToString();
                                }
                            }
                            if (VuAnIsQuyetDinhXetXu(vVuAnID))// Nếu vụ án có quyết định đưa ra xét xử
                            {
                                r04HS.ISBICAN = "bị cáo";
                            }
                            else
                            {
                                r04HS.ISBICAN = "bị can";
                            }
                            BiCan = dt.AHS_BICANBICAO.Where(x => x.ID == item.BICAOID).FirstOrDefault();
                            if (BiCan != null)
                            {
                                hc = dt.DM_HANHCHINH.Where(x => x.ID == BiCan.TAMTRU_HUYEN).FirstOrDefault();
                                if (hc != null)
                                {
                                    strDiaChiTamTru = hc.MA_TEN;
                                }
                                hc = dt.DM_HANHCHINH.Where(x => x.ID == BiCan.HKTT_HUYEN).FirstOrDefault();
                                if (hc != null)
                                {
                                    strDiaChiThuongTru = hc.MA_TEN;
                                }
                                r04HS.LOAIDOITUONG = BiCan.LOAIDOITUONG.ToString();
                                if (BiCan.LOAIDOITUONG == 0)// cá nhân
                                {
                                    r04HS.BICAN_HOTEN = BiCan.HOTEN;
                                    r04HS.BICAN_TENKHAC = "";
                                    r04HS.BICAN_DC_TAMTRU = BiCan.TAMTRUCHITIET + "" == "" ? strDiaChiTamTru : BiCan.TAMTRUCHITIET + ", " + strDiaChiTamTru;
                                    r04HS.BICAN_DC_THUONGTRU = BiCan.KHTTCHITIET + "" == "" ? strDiaChiThuongTru : BiCan.KHTTCHITIET + ", " + strDiaChiThuongTru;
                                    r04HS.BICAN_NGAYSINH = BiCan.NGAYSINH + "" == "" ? "" : (((DateTime)BiCan.NGAYSINH).ToString("dd/MM/yyyy") == DateTime.MinValue.ToString("dd/MM/yyyy") ? BiCan.NAMSINH.ToString() : ((DateTime)BiCan.NGAYSINH).ToString("dd/MM/yyyy"));
                                    NgheNghiep = dt.DM_DATAITEM.Where(x => x.ID == BiCan.NGHENGHIEPID).FirstOrDefault();
                                    if (NgheNghiep != null)
                                    { r04HS.BICAN_NGHENGHIEP = NgheNghiep.TEN; }
                                }
                                else
                                {
                                    r04HS.BICAN_HOTEN = BiCan.HOTEN;// Tên pháp nhân thương mại
                                    r04HS.BICAN_TENKHAC = BiCan.TENKHAC;// Tên người đại diện
                                    r04HS.BICAN_DC_TAMTRU = "";
                                    r04HS.BICAN_DC_THUONGTRU = BiCan.KHTTCHITIET + "" == "" ? strDiaChiThuongTru : BiCan.KHTTCHITIET + ", " + strDiaChiThuongTru;
                                    r04HS.BICAN_NGAYSINH = "";
                                    r04HS.BICAN_NGHENGHIEP = "";
                                }
                            }
                            r04HS.TENVKS = strTenToaAn.Replace("Tòa án nhân dân", "Viện kiểm sát nhân dân");
                            r04HS.TOIDANH = GetToiDanhBiCao(BanAnID, (decimal)item.BICAOID, VKS);
                            //Khai sua
                            string Temp = GetDieuKhoan04HS(BanAnID, vVuAnID, (decimal)item.BICAOID, VKS);
                            string subTemp = Temp.Substring(0, 1).ToUpper();
                            Temp = Temp.Remove(0, 1);
                            Temp = subTemp + Temp;
                            r04HS.DIEUKHOAN = Temp;

                            r04HS.ISCHANHAN = strChucVuNguoiKy;
                            r04HS.TENCHANHAN = strTenNguoiKy;
                            objDTBieuMau.DTBM04HS.AddDTBM04HSRow(r04HS);
                            objDTBieuMau.AcceptChanges();
                        }
                        rpt04HS rpt = new rpt04HS
                        {
                            DataSource = objDTBieuMau
                        };
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không có dữ liệu";
                    }
                    
                }
                else if (vMaBC == "05-HS")
                {
                    // Biểu mẫu sẽ nhân bản theo danh sách bị can áp dụng biểu mẫu
                    idTitle.Text = "Quyết định tạm giam";
                    IDQD = 0;
                    AHS_SOTHAM_QUYETDINH_BICAN QDBC = null; AHS_BICANBICAO BiCan = null; DTBIEUMAU.DTBM04HSRow r05HS;
                    DM_HANHCHINH hc = null; DM_DATAITEM NgheNghiep = null;
                    DM_QD_QUYETDINH oDMQD = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == IDLQD && x.MA == "05-HS").FirstOrDefault();
                    if (oDMQD != null) IDQD = oDMQD.ID;
                    List<AHS_FILE> lstBiCan_BM = dt.AHS_FILE.Where(x => x.BIEUMAUID == BieuMauID && x.VUANID == vVuAnID && x.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM && x.BICAOID != null).ToList();
                    if (lstBiCan_BM.Count > 0)
                    {
                        foreach (AHS_FILE item in lstBiCan_BM)
                        {
                            QDBC = dt.AHS_SOTHAM_QUYETDINH_BICAN.Where(x => x.BICANID == item.BICAOID && x.VUANID == vVuAnID && x.QUYETDINHID == IDQD).FirstOrDefault();
                            r05HS = objDTBieuMau.DTBM04HS.NewDTBM04HSRow();
                            r05HS.TENTOAAN = strTenToaAn;
                            if (QDBC != null)
                            {
                                DateTime? oNgayQD = QDBC.NGAYQD + "" == "" ? (DateTime?)null : (DateTime)QDBC.NGAYQD;
                                if (oNgayQD != null)
                                {
                                    DateTime NgayQD = (DateTime)oNgayQD;
                                    r05HS.NGAYQD = string.Format("{0:00}", NgayQD.Day);
                                    r05HS.THANGQD = string.Format("{0:00}", NgayQD.Month);
                                    r05HS.NAMQD = NgayQD.Year.ToString();
                                    r05HS.SOQD = QDBC.SOQUYETDINH + "/" + NgayQD.Year.ToString();
                                }
                                if (QDBC.HIEULUCTU != null && QDBC.HIEULUCDEN != null)
                                {
                                    int TotalNgay = ((DateTime)QDBC.HIEULUCDEN).Subtract((DateTime)QDBC.HIEULUCTU).Days;
                                    r05HS.THOIHANTAMGIAM = TotalNgay + " ngày (" + Cls_Comon.NumberToTextVN(TotalNgay).Replace(" đồng", "").Replace(",", "") + " ngày)";
                                }
                                else
                                {
                                    r05HS.THOIHANTAMGIAM = "0 ngày (Không ngày)";
                                }
                                r05HS.TUNGAY = QDBC.HIEULUCTU + "" == "" ? "" : ((DateTime)QDBC.HIEULUCTU).ToString("dd/MM/yyyy");
                                r05HS.NOIGIAMGIU = QDBC.NOIGIAMGIU;
                                DM_CANBO oCanBo = dt.DM_CANBO.Where(x => x.ID == QDBC.NGUOIKYID).FirstOrDefault();
                                if (oCanBo != null)
                                {
                                    strTenNguoiKy = oCanBo.HOTEN;
                                    AHS_SOTHAM_HDXX oMaVaiTro = dt.AHS_SOTHAM_HDXX.Where(x => x.VUANID == vVuAnID && x.CANBOID == oCanBo.ID && x.MAVAITRO == "THAMPHAN").FirstOrDefault();
                                    if (oMaVaiTro != null)
                                    {
                                        strChucVuNguoiKy = "Thẩm Phán Chủ Tọa";
                                    }
                                    else
                                    {
                                        AHS_THAMPHANGIAIQUYET oMaVaiTro2 = dt.AHS_THAMPHANGIAIQUYET.Where(x => x.VUANID == vVuAnID && x.CANBOID == oCanBo.ID && x.MAVAITRO == "VTTP_GIAIQUYETSOTHAM").FirstOrDefault();
                                        if (oMaVaiTro2 != null)
                                        {
                                            strChucVuNguoiKy = "Thẩm Phán Chủ Tọa";
                                        }
                                        else
                                        {
                                            DM_DATAITEM oChucVu = dt.DM_DATAITEM.Where(x => x.ID == oCanBo.CHUCVUID).FirstOrDefault();
                                            if (oChucVu != null)
                                            {
                                                strChucVuNguoiKy = oChucVu.TEN;
                                            }
                                        }
                                    }
                                }
                            }
                            r05HS.DIADIEM = strDiadiem;
                            if (oThuLy != null)
                            {
                                DateTime? oNgayTL = oThuLy.NGAYTHULY + "" == "" ? (DateTime?)null : (DateTime)oThuLy.NGAYTHULY;
                                if (oNgayTL != null)
                                {
                                    DateTime NgayTL = (DateTime)oNgayTL;
                                    r05HS.NGAYTHULY = string.Format("{0:00}", NgayTL.Day);
                                    r05HS.THANGTHULY = string.Format("{0:00}", NgayTL.Month);
                                    r05HS.NAMTHULY = NgayTL.Year.ToString();
                                    r05HS.SOTHULY = oThuLy.SOTHULY + "/" + NgayTL.Year.ToString();
                                }
                            }
                            if (VuAnIsQuyetDinhXetXu(vVuAnID))// Nếu vụ án có quyết định đưa ra xét xử
                            {
                                r05HS.ISBICAN = "bị cáo";
                            }
                            else
                            {
                                r05HS.ISBICAN = "bị can";
                            }
                            BiCan = dt.AHS_BICANBICAO.Where(x => x.ID == item.BICAOID).FirstOrDefault();
                            if (BiCan != null)
                            {
                                hc = dt.DM_HANHCHINH.Where(x => x.ID == BiCan.TAMTRU_HUYEN).FirstOrDefault();
                                if (hc != null)
                                {
                                    strDiaChiTamTru = hc.MA_TEN;
                                }
                                hc = dt.DM_HANHCHINH.Where(x => x.ID == BiCan.HKTT_HUYEN).FirstOrDefault();
                                if (hc != null)
                                {
                                    strDiaChiThuongTru = hc.MA_TEN;
                                }
                                r05HS.LOAIDOITUONG = BiCan.LOAIDOITUONG.ToString();
                                if (BiCan.LOAIDOITUONG == 0)// cá nhân
                                {
                                    r05HS.BICAN_HOTEN = BiCan.HOTEN;
                                    r05HS.BICAN_TENKHAC = "";
                                    r05HS.BICAN_DC_TAMTRU = BiCan.TAMTRUCHITIET + "" == "" ? strDiaChiTamTru : BiCan.TAMTRUCHITIET + ", " + strDiaChiTamTru;
                                    r05HS.BICAN_DC_THUONGTRU = BiCan.KHTTCHITIET + "" == "" ? strDiaChiThuongTru : BiCan.KHTTCHITIET + ", " + strDiaChiThuongTru;
                                    r05HS.BICAN_NGAYSINH = BiCan.NGAYSINH + "" == "" ? "" : (((DateTime)BiCan.NGAYSINH).ToString("dd/MM/yyyy") == DateTime.MinValue.ToString("dd/MM/yyyy") ? BiCan.NAMSINH.ToString() : ((DateTime)BiCan.NGAYSINH).ToString("dd/MM/yyyy"));
                                    NgheNghiep = dt.DM_DATAITEM.Where(x => x.ID == BiCan.NGHENGHIEPID).FirstOrDefault();
                                    if (NgheNghiep != null)
                                    { r05HS.BICAN_NGHENGHIEP = NgheNghiep.TEN; }
                                }
                                else
                                {
                                    r05HS.BICAN_HOTEN = BiCan.HOTEN;// Tên pháp nhân thương mại
                                    r05HS.BICAN_TENKHAC = BiCan.TENKHAC;// Tên người đại diện
                                    r05HS.BICAN_DC_TAMTRU = "";
                                    r05HS.BICAN_DC_THUONGTRU = BiCan.KHTTCHITIET + "" == "" ? strDiaChiThuongTru : BiCan.KHTTCHITIET + ", " + strDiaChiThuongTru;
                                    r05HS.BICAN_NGAYSINH = "";
                                    r05HS.BICAN_NGHENGHIEP = "";
                                }
                            }
                            r05HS.TENVKS = strTenToaAn.Replace("Tòa án nhân dân", "Viện kiểm sát nhân dân");
                            r05HS.TOIDANH = GetToiDanhBiCao(BanAnID, (decimal)item.BICAOID, VKS);
                            r05HS.DIEUKHOAN = GetDieuKhoan(BanAnID, vVuAnID, (decimal)item.BICAOID, VKS);
                            r05HS.ISCHANHAN = strChucVuNguoiKy;
                            r05HS.TENCHANHAN = strTenNguoiKy;
                            objDTBieuMau.DTBM04HS.AddDTBM04HSRow(r05HS);
                            objDTBieuMau.AcceptChanges();
                        }
                        rpt05HS rpt = new rpt05HS
                        {
                            DataSource = objDTBieuMau
                        };
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không có dữ liệu";
                    }
                }
                else if (vMaBC == "06-HS")
                {
                    // Biểu mẫu sẽ nhân bản theo danh sách bị can áp dụng biểu mẫu
                    idTitle.Text = "Quyết định bắt, tạm giam";
                    IDQD = 0;
                    AHS_SOTHAM_QUYETDINH_BICAN QDBC = null; AHS_BICANBICAO BiCan = null; DTBIEUMAU.DTBM04HSRow r06HS;
                    DM_HANHCHINH hc = null; DM_DATAITEM NgheNghiep = null;
                    DM_QD_QUYETDINH oDMQD = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == IDLQD && x.MA == "06-HS").FirstOrDefault();
                    if (oDMQD != null) IDQD = oDMQD.ID;
                    List<AHS_FILE> lstBiCan_BM = dt.AHS_FILE.Where(x => x.BIEUMAUID == BieuMauID && x.VUANID == vVuAnID && x.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM && x.BICAOID != null).ToList();
                    if (lstBiCan_BM.Count > 0)
                    {
                        foreach (AHS_FILE item in lstBiCan_BM)
                        {
                            QDBC = dt.AHS_SOTHAM_QUYETDINH_BICAN.Where(x => x.BICANID == item.BICAOID && x.VUANID == vVuAnID && x.QUYETDINHID == IDQD).FirstOrDefault();
                            r06HS = objDTBieuMau.DTBM04HS.NewDTBM04HSRow();
                            r06HS.TENTOAAN = strTenToaAn;
                            if (QDBC != null)
                            {
                                DateTime? oNgayQD = QDBC.NGAYQD + "" == "" ? (DateTime?)null : (DateTime)QDBC.NGAYQD;
                                if (oNgayQD != null)
                                {
                                    DateTime NgayQD = (DateTime)oNgayQD;
                                    r06HS.NGAYQD = string.Format("{0:00}", NgayQD.Day);
                                    r06HS.THANGQD = string.Format("{0:00}", NgayQD.Month);
                                    r06HS.NAMQD = NgayQD.Year.ToString();
                                    r06HS.SOQD = QDBC.SOQUYETDINH + "/" + NgayQD.Year.ToString();
                                }
                                r06HS.NOIGIAMGIU = QDBC.NOIGIAMGIU;
                                r06HS.DENNGAY = QDBC.HIEULUCDEN + "" == "" ? "" : ((DateTime)QDBC.HIEULUCDEN).ToString("dd/MM/yyyy");
                                DM_CANBO oCanBo = dt.DM_CANBO.Where(x => x.ID == QDBC.NGUOIKYID).FirstOrDefault();
                                if (oCanBo != null)
                                {
                                    strTenNguoiKy = oCanBo.HOTEN;
                                    AHS_SOTHAM_HDXX oMaVaiTro = dt.AHS_SOTHAM_HDXX.Where(x => x.VUANID == vVuAnID && x.CANBOID == oCanBo.ID && x.MAVAITRO == "THAMPHAN").FirstOrDefault();
                                    if (oMaVaiTro != null)
                                    {
                                        strChucVuNguoiKy = "Thẩm Phán Chủ Tọa";
                                    }
                                    else
                                    {
                                        AHS_THAMPHANGIAIQUYET oMaVaiTro2 = dt.AHS_THAMPHANGIAIQUYET.Where(x => x.VUANID == vVuAnID && x.CANBOID == oCanBo.ID && x.MAVAITRO == "VTTP_GIAIQUYETSOTHAM").FirstOrDefault();
                                        if (oMaVaiTro2 != null)
                                        {
                                            strChucVuNguoiKy = "Thẩm Phán Chủ Tọa";
                                        }
                                        else
                                        {
                                            DM_DATAITEM oChucVu = dt.DM_DATAITEM.Where(x => x.ID == oCanBo.CHUCVUID).FirstOrDefault();
                                            if (oChucVu != null)
                                            {
                                                strChucVuNguoiKy = oChucVu.TEN;
                                            }
                                        }
                                    }
                                }
                            }
                            r06HS.DIADIEM = strDiadiem;
                            if (oThuLy != null)
                            {
                                DateTime? oNgayTL = oThuLy.NGAYTHULY + "" == "" ? (DateTime?)null : (DateTime)oThuLy.NGAYTHULY;
                                if (oNgayTL != null)
                                {
                                    DateTime NgayTL = (DateTime)oNgayTL;
                                    r06HS.NGAYTHULY = string.Format("{0:00}", NgayTL.Day);
                                    r06HS.THANGTHULY = string.Format("{0:00}", NgayTL.Month);
                                    r06HS.NAMTHULY = NgayTL.Year.ToString();
                                    r06HS.SOTHULY = oThuLy.SOTHULY + "/" + NgayTL.Year.ToString();
                                }
                            }
                            if (VuAnIsQuyetDinhXetXu(vVuAnID))// Nếu vụ án có quyết định đưa ra xét xử
                            {
                                r06HS.ISBICAN = "bị cáo";
                            }
                            else
                            {
                                r06HS.ISBICAN = "bị can";
                            }
                            BiCan = dt.AHS_BICANBICAO.Where(x => x.ID == item.BICAOID).FirstOrDefault();
                            if (BiCan != null)
                            {
                                hc = dt.DM_HANHCHINH.Where(x => x.ID == BiCan.TAMTRU_HUYEN).FirstOrDefault();
                                if (hc != null)
                                {
                                    strDiaChiTamTru = hc.MA_TEN;
                                }
                                hc = dt.DM_HANHCHINH.Where(x => x.ID == BiCan.HKTT_HUYEN).FirstOrDefault();
                                if (hc != null)
                                {
                                    strDiaChiThuongTru = hc.MA_TEN;
                                }
                                r06HS.LOAIDOITUONG = BiCan.LOAIDOITUONG.ToString();
                                if (BiCan.LOAIDOITUONG == 0)// cá nhân
                                {
                                    r06HS.BICAN_HOTEN = BiCan.HOTEN;
                                    r06HS.BICAN_TENKHAC = "";
                                    r06HS.BICAN_DC_TAMTRU = BiCan.TAMTRUCHITIET + "" == "" ? strDiaChiTamTru : BiCan.TAMTRUCHITIET + ", " + strDiaChiTamTru;
                                    r06HS.BICAN_DC_THUONGTRU = BiCan.KHTTCHITIET + "" == "" ? strDiaChiThuongTru : BiCan.KHTTCHITIET + ", " + strDiaChiThuongTru;
                                    r06HS.BICAN_NGAYSINH = BiCan.NGAYSINH + "" == "" ? "" : (((DateTime)BiCan.NGAYSINH).ToString("dd/MM/yyyy") == DateTime.MinValue.ToString("dd/MM/yyyy") ? BiCan.NAMSINH.ToString() : ((DateTime)BiCan.NGAYSINH).ToString("dd/MM/yyyy"));
                                    NgheNghiep = dt.DM_DATAITEM.Where(x => x.ID == BiCan.NGHENGHIEPID).FirstOrDefault();
                                    if (NgheNghiep != null)
                                    { r06HS.BICAN_NGHENGHIEP = NgheNghiep.TEN; }
                                }
                                else
                                {
                                    r06HS.BICAN_HOTEN = BiCan.HOTEN;// Tên pháp nhân thương mại
                                    r06HS.BICAN_TENKHAC = BiCan.TENKHAC;// Tên người đại diện
                                    r06HS.BICAN_DC_TAMTRU = "";
                                    r06HS.BICAN_DC_THUONGTRU = BiCan.KHTTCHITIET + "" == "" ? strDiaChiThuongTru : BiCan.KHTTCHITIET + ", " + strDiaChiThuongTru;
                                    r06HS.BICAN_NGAYSINH = "";
                                    r06HS.BICAN_NGHENGHIEP = "";
                                }
                            }
                            r06HS.TENVKS = strTenToaAn.Replace("Tòa án nhân dân", "Viện kiểm sát nhân dân");
                            r06HS.TOIDANH = GetToiDanhBiCao(BanAnID, (decimal)item.BICAOID, VKS);
                            r06HS.DIEUKHOAN = GetDieuKhoan(BanAnID, vVuAnID, (decimal)item.BICAOID, VKS);
                            r06HS.TITLE_DONVITHIHANH = strTitleDVThiHanh;
                            r06HS.ISCHANHAN = strChucVuNguoiKy;
                            r06HS.TENCHANHAN = strTenNguoiKy;
                            objDTBieuMau.DTBM04HS.AddDTBM04HSRow(r06HS);
                            objDTBieuMau.AcceptChanges();
                        }
                        rpt06HS rpt = new rpt06HS
                        {
                            DataSource = objDTBieuMau
                        };
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không có dữ liệu";
                    }
                    
                }
                else if (vMaBC == "07-HS")
                {
                    // Biểu mẫu sẽ nhân bản theo danh sách bị can áp dụng biểu mẫu
                    idTitle.Text = "Quyết định tạm giam";
                    IDQD = 0;
                    AHS_SOTHAM_QUYETDINH_BICAN QDBC = null; AHS_BICANBICAO BiCan = null; DTBIEUMAU.DTBM04HSRow r07HS;
                    DM_HANHCHINH hc = null; DM_DATAITEM NgheNghiep = null;
                    DM_QD_QUYETDINH oDMQD = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == IDLQD && x.MA == "07-HS").FirstOrDefault();
                    if (oDMQD != null) IDQD = oDMQD.ID;
                    List<AHS_FILE> lstBiCan_BM = dt.AHS_FILE.Where(x => x.BIEUMAUID == BieuMauID && x.VUANID == vVuAnID && x.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM).ToList();
                    foreach (AHS_FILE item in lstBiCan_BM)
                    {
                        QDBC = dt.AHS_SOTHAM_QUYETDINH_BICAN.Where(x => x.BICANID == item.BICAOID && x.VUANID == vVuAnID && x.QUYETDINHID == IDQD).FirstOrDefault();
                        r07HS = objDTBieuMau.DTBM04HS.NewDTBM04HSRow();
                        r07HS.TENTOAAN = strTenToaAn;
                        r07HS.TP_CHUTOA = strTPChuToa;
                        r07HS.TP_THANHVIEN = FillDSThamPhanThanhVien_AHS_ST(lstHD, IsToaQuanSu);
                        string nhandan = "nhân dân: ";
                        if (IsToaQuanSu) { nhandan = "quân nhân: "; }
                        r07HS.TP_HDND = nhandan + FillDSThamPhanHTND_AHS_ST(lstHD, IsToaQuanSu);
                        r07HS.LOAITOAAN = IsToaQuanSu ? "QS" : "DS";
                        r07HS.DIEULUATBOSUNG = QDBC.DIEULUATAPDUNGTHEM;
                        if (QDBC != null)
                        {
                            DateTime? oNgayBBNA = QDBC.BIENBANNGHIAN_NGAY + "" == "" ? (DateTime?)null : (DateTime)QDBC.BIENBANNGHIAN_NGAY;
                            if (oNgayBBNA != null)
                            {
                                DateTime BBNghiAnNgay = (DateTime)oNgayBBNA;
                                r07HS.BBNGHIAN_NGAY = string.Format("{0:00}", BBNghiAnNgay.Day);
                                r07HS.BBNGHIAN_THANG = string.Format("{0:00}", BBNghiAnNgay.Month);
                                r07HS.BBNGHIAN_NAM = BBNghiAnNgay.Year.ToString();
                            }
                            DateTime? oNgayQD = QDBC.NGAYQD + "" == "" ? (DateTime?)null : (DateTime)QDBC.NGAYQD;
                            if (oNgayQD != null)
                            {
                                DateTime NgayQD = (DateTime)oNgayQD;
                                r07HS.NGAYQD = string.Format("{0:00}", NgayQD.Day);
                                r07HS.THANGQD = string.Format("{0:00}", NgayQD.Month);
                                r07HS.NAMQD = NgayQD.Year.ToString();
                                r07HS.SOQD = QDBC.SOQUYETDINH + "/" + NgayQD.Year.ToString();
                            }
                            int ThoiHanPhatTu = QDBC.HIEULUCDEN + "" == "" ? 0 : ((DateTime)QDBC.HIEULUCDEN).Subtract((DateTime)QDBC.HIEULUCTU).Days;
                            if (ThoiHanPhatTu >= 45)
                            {
                                r07HS.THOIHANTAMGIAM = "45 ngày (Bốn mươi lăm ngày)";
                            }
                            else
                            {
                                r07HS.THOIHANTAMGIAM = ThoiHanPhatTu + " ngày (" + Cls_Comon.NumberToTextVN(ThoiHanPhatTu).Replace(" đồng", "") + " ngày)";
                            }
                            r07HS.TUNGAY = QDBC.HIEULUCTU + "" == "" ? "" : ((DateTime)QDBC.HIEULUCTU).ToString("dd/MM/yyyy");
                            r07HS.NOIGIAMGIU = QDBC.NOIGIAMGIU;
                        }
                        r07HS.DIADIEM = strDiadiem;
                        BiCan = dt.AHS_BICANBICAO.Where(x => x.ID == item.BICAOID).FirstOrDefault();
                        if (BiCan != null)
                        {
                            hc = dt.DM_HANHCHINH.Where(x => x.ID == BiCan.TAMTRU_HUYEN).FirstOrDefault();
                            if (hc != null)
                            {
                                strDiaChiTamTru = hc.MA_TEN;
                            }
                            hc = dt.DM_HANHCHINH.Where(x => x.ID == BiCan.HKTT_HUYEN).FirstOrDefault();
                            if (hc != null)
                            {
                                strDiaChiThuongTru = hc.MA_TEN;
                            }
                            r07HS.LOAIDOITUONG = BiCan.LOAIDOITUONG.ToString();
                            if (BiCan.LOAIDOITUONG == 0)// cá nhân
                            {
                                r07HS.BICAN_HOTEN = BiCan.HOTEN;
                                r07HS.BICAN_TENKHAC = "";
                                r07HS.BICAN_DC_TAMTRU = BiCan.TAMTRUCHITIET + "" == "" ? strDiaChiTamTru : BiCan.TAMTRUCHITIET + ", " + strDiaChiTamTru;
                                r07HS.BICAN_DC_THUONGTRU = BiCan.KHTTCHITIET + "" == "" ? strDiaChiThuongTru : BiCan.KHTTCHITIET + ", " + strDiaChiThuongTru;
                                r07HS.BICAN_NGAYSINH = BiCan.NGAYSINH + "" == "" ? "" : (((DateTime)BiCan.NGAYSINH).ToString("dd/MM/yyyy") == DateTime.MinValue.ToString("dd/MM/yyyy") ? BiCan.NAMSINH.ToString() : ((DateTime)BiCan.NGAYSINH).ToString("dd/MM/yyyy"));
                                NgheNghiep = dt.DM_DATAITEM.Where(x => x.ID == BiCan.NGHENGHIEPID).FirstOrDefault();
                                if (NgheNghiep != null)
                                { r07HS.BICAN_NGHENGHIEP = NgheNghiep.TEN; }
                            }
                            else
                            {
                                r07HS.BICAN_HOTEN = BiCan.HOTEN;// Tên pháp nhân thương mại
                                r07HS.BICAN_TENKHAC = BiCan.TENKHAC;// Tên người đại diện
                                r07HS.BICAN_DC_TAMTRU = "";
                                r07HS.BICAN_DC_THUONGTRU = BiCan.KHTTCHITIET + "" == "" ? strDiaChiThuongTru : BiCan.KHTTCHITIET + ", " + strDiaChiThuongTru;
                                r07HS.BICAN_NGAYSINH = "";
                                r07HS.BICAN_NGHENGHIEP = "";
                            }
                        }
                        r07HS.TENVKS = strTenToaAn.Replace("Tòa án nhân dân", "Viện kiểm sát nhân dân");
                        r07HS.MUCXUPHAT = GetHinhPhatBiCao(BanAnID, (decimal)item.BICAOID, false, TOASOTHAM);
                        r07HS.TOIDANH = GetToiDanhBiCao(BanAnID, (decimal)item.BICAOID, TOASOTHAM);
                        r07HS.DIEUKHOAN = GetDieuKhoan(BanAnID, vVuAnID, (decimal)item.BICAOID, TOASOTHAM);
                        r07HS.ISCHANHAN = strChucVuChanhAn;
                        r07HS.TENCHANHAN = strTenChanhAn;
                        objDTBieuMau.DTBM04HS.AddDTBM04HSRow(r07HS);
                        objDTBieuMau.AcceptChanges();
                    }
                    rpt07HS rpt = new rpt07HS
                    {
                        DataSource = objDTBieuMau
                    };
                    rptView.OpenReport(rpt);
                }
                else if (vMaBC == "08-HS")
                {
                    // Biểu mẫu sẽ nhân bản theo danh sách bị can áp dụng biểu mẫu
                    idTitle.Text = "Quyết định bắt, tạm giam";
                    IDQD = 0;
                    AHS_SOTHAM_QUYETDINH_BICAN QDBC = null; AHS_BICANBICAO BiCan = null; DTBIEUMAU.DTBM04HSRow r08HS;
                    DM_HANHCHINH hc = null; DM_DATAITEM NgheNghiep = null;
                    DM_QD_QUYETDINH oDMQD = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == IDLQD && x.MA == "08-HS").FirstOrDefault();
                    if (oDMQD != null) IDQD = oDMQD.ID;
                    List<AHS_FILE> lstBiCan_BM = dt.AHS_FILE.Where(x => x.BIEUMAUID == BieuMauID && x.VUANID == vVuAnID && x.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM).ToList();
                    foreach (AHS_FILE item in lstBiCan_BM)
                    {
                        QDBC = dt.AHS_SOTHAM_QUYETDINH_BICAN.Where(x => x.BICANID == item.BICAOID && x.VUANID == vVuAnID && x.QUYETDINHID == IDQD).FirstOrDefault();
                        r08HS = objDTBieuMau.DTBM04HS.NewDTBM04HSRow();
                        r08HS.TENTOAAN = strTenToaAn;
                        r08HS.TP_CHUTOA = strTPChuToa;
                        r08HS.TP_THANHVIEN = FillDSThamPhanThanhVien_AHS_ST(lstHD, IsToaQuanSu);
                        string nhandan = "nhân dân: ";
                        if (IsToaQuanSu) { nhandan = "quân nhân: "; }
                        r08HS.TP_HDND = nhandan + FillDSThamPhanHTND_AHS_ST(lstHD, IsToaQuanSu);
                        r08HS.LOAITOAAN = IsToaQuanSu ? "QS" : "DS";
                        r08HS.DIEULUATBOSUNG = QDBC.DIEULUATAPDUNGTHEM;
                        if (QDBC != null)
                        {
                            DateTime? oNgayBBNA = QDBC.BIENBANNGHIAN_NGAY + "" == "" ? (DateTime?)null : (DateTime)QDBC.BIENBANNGHIAN_NGAY;
                            if (oNgayBBNA != null)
                            {
                                DateTime BBNghiAnNgay = (DateTime)oNgayBBNA;
                                r08HS.BBNGHIAN_NGAY = string.Format("{0:00}", BBNghiAnNgay.Day);
                                r08HS.BBNGHIAN_THANG = string.Format("{0:00}", BBNghiAnNgay.Month);
                                r08HS.BBNGHIAN_NAM = BBNghiAnNgay.Year.ToString();
                            }
                            DateTime? oNgayQD = QDBC.NGAYQD + "" == "" ? (DateTime?)null : (DateTime)QDBC.NGAYQD;
                            if (oNgayQD != null)
                            {
                                DateTime NgayQD = (DateTime)oNgayQD;
                                r08HS.NGAYQD = string.Format("{0:00}", NgayQD.Day);
                                r08HS.THANGQD = string.Format("{0:00}", NgayQD.Month);
                                r08HS.NAMQD = NgayQD.Year.ToString();
                                r08HS.SOQD = QDBC.SOQUYETDINH + "/" + NgayQD.Year.ToString();
                            }
                            int ThoiGianTamGiam = QDBC.HIEULUCDEN + "" == "" ? 0 : ((DateTime)QDBC.HIEULUCDEN).Subtract((DateTime)QDBC.HIEULUCTU).Days;
                            if (ThoiGianTamGiam >= 45)
                            {
                                r08HS.THOIHANTAMGIAM = "45 ngày (Bốn mươi lăm ngày), kể từ ngày tuyên án.";
                            }
                            else
                            {
                                r08HS.THOIHANTAMGIAM = ThoiGianTamGiam + " ngày (" + Cls_Comon.NumberToTextVN(ThoiGianTamGiam).Replace("đồng", "") + "ngày), hết thời hạn tạm giam ngày " + ((DateTime)QDBC.HIEULUCDEN).ToString("dd/MM/yyyy");
                            }
                            r08HS.TUNGAY = QDBC.HIEULUCTU + "" == "" ? "" : ((DateTime)QDBC.HIEULUCTU).ToString("dd/MM/yyyy");
                            r08HS.NOIGIAMGIU = QDBC.NOIGIAMGIU;
                        }
                        r08HS.DIADIEM = strDiadiem;
                        BiCan = dt.AHS_BICANBICAO.Where(x => x.ID == item.BICAOID).FirstOrDefault();
                        if (BiCan != null)
                        {
                            hc = dt.DM_HANHCHINH.Where(x => x.ID == BiCan.TAMTRU_HUYEN).FirstOrDefault();
                            if (hc != null)
                            {
                                strDiaChiTamTru = hc.MA_TEN;
                            }
                            hc = dt.DM_HANHCHINH.Where(x => x.ID == BiCan.HKTT_HUYEN).FirstOrDefault();
                            if (hc != null)
                            {
                                strDiaChiThuongTru = hc.MA_TEN;
                            }
                            r08HS.LOAIDOITUONG = BiCan.LOAIDOITUONG.ToString();
                            if (BiCan.LOAIDOITUONG == 0)// cá nhân
                            {
                                r08HS.BICAN_HOTEN = BiCan.HOTEN;
                                r08HS.BICAN_TENKHAC = "";
                                r08HS.BICAN_DC_TAMTRU = BiCan.TAMTRUCHITIET + "" == "" ? strDiaChiTamTru : BiCan.TAMTRUCHITIET + ", " + strDiaChiTamTru;
                                r08HS.BICAN_DC_THUONGTRU = BiCan.KHTTCHITIET + "" == "" ? strDiaChiThuongTru : BiCan.KHTTCHITIET + ", " + strDiaChiThuongTru;
                                r08HS.BICAN_NGAYSINH = BiCan.NGAYSINH + "" == "" ? "" : (((DateTime)BiCan.NGAYSINH).ToString("dd/MM/yyyy") == DateTime.MinValue.ToString("dd/MM/yyyy") ? BiCan.NAMSINH.ToString() : ((DateTime)BiCan.NGAYSINH).ToString("dd/MM/yyyy"));
                                NgheNghiep = dt.DM_DATAITEM.Where(x => x.ID == BiCan.NGHENGHIEPID).FirstOrDefault();
                                if (NgheNghiep != null)
                                { r08HS.BICAN_NGHENGHIEP = NgheNghiep.TEN; }
                            }
                            else
                            {
                                r08HS.BICAN_HOTEN = BiCan.HOTEN;// Tên pháp nhân thương mại
                                r08HS.BICAN_TENKHAC = BiCan.TENKHAC;// Tên người đại diện
                                r08HS.BICAN_DC_TAMTRU = "";
                                r08HS.BICAN_DC_THUONGTRU = BiCan.KHTTCHITIET + "" == "" ? strDiaChiThuongTru : BiCan.KHTTCHITIET + ", " + strDiaChiThuongTru;
                                r08HS.BICAN_NGAYSINH = "";
                                r08HS.BICAN_NGHENGHIEP = "";
                            }
                        }
                        r08HS.TENVKS = strTenToaAn.Replace("Tòa án nhân dân", "Viện kiểm sát nhân dân");
                        r08HS.MUCXUPHAT = GetHinhPhatBiCao(BanAnID, (decimal)item.BICAOID, false, TOASOTHAM);
                        r08HS.TOIDANH = GetToiDanhBiCao(BanAnID, (decimal)item.BICAOID, TOASOTHAM);
                        r08HS.DIEUKHOAN = GetDieuKhoan(BanAnID, vVuAnID, (decimal)item.BICAOID, TOASOTHAM);
                        r08HS.TITLE_DONVITHIHANH = strTitleDVThiHanh;
                        r08HS.ISCHANHAN = strChucVuChanhAn;
                        r08HS.TENCHANHAN = strTenChanhAn;
                        objDTBieuMau.DTBM04HS.AddDTBM04HSRow(r08HS);
                        objDTBieuMau.AcceptChanges();
                    }
                    rpt08HS rpt = new rpt08HS
                    {
                        DataSource = objDTBieuMau
                    };
                    rptView.OpenReport(rpt);
                }
                else if (vMaBC == "13-HS")
                {
                    DataTable tbl = report_BL.DTReport_AHS_By_VuAnID_GiaiDoan(vVuAnID, ENUM_GIAIDOANVUAN.HOSO, "AHS_13");
                    if (tbl.Rows.Count > 0)
                    {
                        idTitle.Text = "13-HS. Thông báo về việc người bào chữa tham gia tố tụng";
                        for (int i = 0; i < tbl.Rows.Count; i++)
                        {
                            tbl.Rows[i]["v_TENTOAAN_Up"] = strTenToaAn.ToUpper();
                        }
                        rpt13HS rpt = new rpt13HS();
                        rpt.DataSource = tbl;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không có dữ liệu";
                    }
                }
                else if (vMaBC == "16-HS")
                {
                    DataTable tbl = report_BL.DTReport_AHS_By_VuAnID_GiaiDoan(vVuAnID, ENUM_GIAIDOANVUAN.SOTHAM, "AHS_16");
                    if (tbl.Rows.Count > 0)
                    {
                        idTitle.Text = "16-HS. Quyết định áp dụng thủ tục rút gọn";
                        for (int i = 0; i < tbl.Rows.Count; i++)
                        {
                            tbl.Rows[i]["v_TENTOAAN_1_3"] = strTenToaAn.ToUpper();
                        }
                        rpt16HS rpt = new rpt16HS();
                        rpt.DataSource = tbl;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không có dữ liệu";
                    }
                }
                else if (vMaBC == "17-HS")
                {
                    DataTable tbl = report_BL.DTReport_AHS_By_VuAnID_GiaiDoan(vVuAnID, ENUM_GIAIDOANVUAN.SOTHAM, "AHS_17");
                    if (tbl.Rows.Count > 0)
                    {
                        idTitle.Text = "17-HS. Quyết định hủy bỏ Quyết định áp dụng thủ tục rút gọn";
                        for (int i = 0; i < tbl.Rows.Count; i++)
                        {
                            tbl.Rows[i]["v_TENTOAAN_1_3"] = strTenToaAn.ToUpper();
                        }
                        rpt17HS rpt = new rpt17HS();
                        rpt.DataSource = tbl;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không có dữ liệu";
                    }
                }
                else if (vMaBC == "20-HS")
                {
                    DataTable tbl = report_BL.DTReport_AHS_By_VuAnID(vVuAnID, "AHS_20");
                    if (tbl.Rows.Count > 0)
                    {
                        idTitle.Text = "20-HS. Quyết định đưa vụ án ra xét xử sơ thẩm";
                        DataRow row = tbl.Rows[0];
                        rpt20HS rpt = new rpt20HS();
                        string Temp = row["v_TP_HDXX"] + "";
                        int Length = Temp.Length;
                        if (Length >= 2)
                        {
                            Temp = Temp.Substring(0, Length - 2);
                        }
                        rpt.Parameters["prm_HDXX"].Value = row["v_TP_HDXX"] = Temp;

                        Temp = row["v_TP_DUKHUYET"] + "";
                        Length = Temp.Length;
                        if (Length >= 2)
                        {
                            Temp = Temp.Substring(0, Length - 2);
                        }
                        rpt.Parameters["prm_TP_DuKhuyet"].Value = row["v_TP_DUKHUYET"] = Temp;

                        Temp = row["v_HTND"] + "";
                        Length = Temp.Length;
                        if (Length >= 2)
                        {
                            Temp = Temp.Substring(0, Length - 2);
                        }
                        rpt.Parameters["prm_HTND"].Value = row["v_HTND"] = Temp;

                        Temp = row["v_HTND_DUKHUYET"] + "";
                        Length = Temp.Length;
                        if (Length >= 2)
                        {
                            Temp = Temp.Substring(0, Length - 2);
                        }
                        rpt.Parameters["prm_HTND_DK"].Value = row["v_HTND_DUKHUYET"] = Temp;

                        Temp = row["v_THUKY"] + "";
                        Length = Temp.Length;
                        if (Length >= 2)
                        {
                            Temp = Temp.Substring(0, Length - 2);
                        }
                        rpt.Parameters["prm_ThuKy"].Value = row["v_THUKY"] = Temp;

                        Temp = row["v_THUKY_DUKHUYET"] + "";
                        Length = Temp.Length;
                        if (Length >= 2)
                        {
                            Temp = Temp.Substring(0, Length - 2);
                        }
                        rpt.Parameters["prm_ThuKy_DK"].Value = row["v_THUKY_DUKHUYET"] = Temp;

                        rpt.Parameters["prm_KSV"].Value = row["v_KIEMSATVIEN"] + "";
                        rpt.Parameters["prm_KSV_DK"].Value = row["v_KIEMSATVIEN_DUKHUYET"] + "";

                        Temp = row["v_NGUOITGTT"] + "";
                        Length = Temp.Length;
                        if (Length >= 2)
                        {
                            Temp = Temp.Substring(0, Length - 2);
                        }
                        row["v_NGUOITGTT"] = Temp;
                        for (int i = 0; i < tbl.Rows.Count; i++)
                        {
                            tbl.Rows[i]["v_TENTOAAN_1_3"] = strTenToaAn.ToUpper();
                        }
                        rpt.DataSource = tbl;
                        rptView.OpenReport(rpt);
                    }
                    else { ltlmsg.InnerText = "Không có dữ liệu"; }
                }
                else if (vMaBC == "36-HS")
                {
                    DataTable tbl = report_BL.DTReport_AHS_By_VuAnID(vVuAnID, "AHS_36");
                    if (tbl.Rows.Count > 0)
                    {
                        idTitle.Text = "36-HS. Quyết định tạm đình chỉ vụ án";
                        string Temp = tbl.Rows[0]["v_DIEU_KHOAN"] + "";
                        int Length = Temp.Length;
                        if (Length >= 2)
                            tbl.Rows[0]["v_DIEU_KHOAN"] = Temp.Substring(0, Length - 2);
                        tbl.Rows[0]["v_TENTOAAN_1_3"] = strTenToaAn.ToUpper();
                        rpt36HS rpt = new rpt36HS();
                        rpt.DataSource = tbl;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không có dữ liệu";
                    }
                }
                else if (vMaBC == "37-HS")
                {
                    DataTable tbl = report_BL.DTReport_AHS_By_VuAnID(vVuAnID, "AHS_37");
                    if (tbl.Rows.Count > 0)
                    {
                        idTitle.Text = "37-HS. Quyết định tạm đình chỉ vụ án";
                        rpt37HS rpt = new rpt37HS();
                        string Temp = tbl.Rows[0]["v_DIEU_KHOAN"] + "";
                        int Length = Temp.Length;
                        if (Length >= 2)
                            tbl.Rows[0]["v_DIEU_KHOAN"] = Temp.Substring(0, Length - 2);

                        Temp = tbl.Rows[0]["v_TP_HDXX"] + "";
                        Length = Temp.Length;
                        if (Length >= 2)
                        {
                            Temp = Temp.Substring(0, Length - 2);
                        }
                        rpt.Parameters["prm_HDXX"].Value = tbl.Rows[0]["v_TP_HDXX"] = Temp;

                        Temp = tbl.Rows[0]["v_HTND"] + "";
                        Length = Temp.Length;
                        if (Length >= 2)
                        {
                            Temp = Temp.Substring(0, Length - 2);
                        }
                        rpt.Parameters["prm_HTND"].Value = tbl.Rows[0]["v_HTND"] = Temp;

                        tbl.Rows[0]["v_TENTOAAN_1_3"] = strTenToaAn.ToUpper();
                        rpt.DataSource = tbl;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không có dữ liệu";
                    }
                }
                else if (vMaBC == "42-HS")
                {
                    DataTable tbl = report_BL.DTReport_AHS_By_VuAnID(vVuAnID, "AHS_42");
                    if (tbl.Rows.Count > 0)
                    {
                        idTitle.Text = "42-HS. Quyết định gia hạn thời hạn chuẩn bị xét xử";
                        string Temp = tbl.Rows[0]["v_DIEU_KHOAN"] + "";
                        int Length = Temp.Length;
                        if (Length >= 2)
                            tbl.Rows[0]["v_DIEU_KHOAN"] = Temp.Substring(0, Length - 2);

                        rpt42HS rpt = new rpt42HS();
                        rpt.Parameters["prmThoiGianGiaHan"].Value = tbl.Rows[0]["v_THOIGIANGIAHAN"] + "";
                        rpt.Parameters["prmSoThuLy"].Value = tbl.Rows[0]["v_SOTHULY"] + "";
                        rpt.Parameters["prmNgayHieuLuc"].Value = tbl.Rows[0]["v_NGAYHIEULUC"] + "";
                        tbl.Rows[0]["v_TENTOAAN_1_3"] = strTenToaAn.ToUpper();
                        rpt.DataSource = tbl;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không có dữ liệu";
                    }
                }
                else if (vMaBC == "48-HS")
                {
                    DataTable tbl = report_BL.DTReport_AHS_By_VuAnID_GiaiDoan(vVuAnID, ENUM_GIAIDOANVUAN.SOTHAM, "AHS_01");
                    if (tbl.Rows.Count >= 0)
                    {
                        idTitle.Text = "48-HS. Thông báo về việc kháng cáo.";
                        tbl.Rows[0]["v_TENTOAAN"] = strTenToaAn.ToUpper();
                        rpt48HS rpt = new rpt48HS();
                        rpt.DataSource = tbl;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không có dữ liệu";
                    }
                }
                //K: Biểu mẫu 39-HS và 40-HS
                else if (vMaBC == "39-HS")
                {
                    DataTable tbl = report_BL.DTReport_AHS_By_VuAnID(vVuAnID, "AHS_20");
                    if (tbl.Rows.Count > 0)
                    {
                        idTitle.Text = "39-HS. Quyết định đình chỉ vụ án (dùng cho Thẩm phán)";
                        string Temp = tbl.Rows[0]["v_DIEU_KHOAN"] + "";
                        int Length = Temp.Length;
                        if (Length >= 2)
                        {
                            tbl.Rows[0]["v_DIEU_KHOAN"] = Temp.Substring(0, Length - 2);
                        }
                        DM_QD_QUYETDINH idQD = dt.DM_QD_QUYETDINH.Where(x => x.MA.Equals("39-HS")).FirstOrDefault();
                        AHS_SOTHAM_QUYETDINH_VUAN checkQD = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.VUANID == vVuAnID && x.QUYETDINHID == idQD.ID).FirstOrDefault();
                        DateTime ngayQD = checkQD.NGAYQD == null ? DateTime.Now : Convert.ToDateTime(checkQD.NGAYQD);
                        tbl.Rows[0]["v_SOQD_2"] = checkQD.SOQUYETDINH + "/" + ngayQD.Year;
                        rpt39HS rpt = new rpt39HS
                        {
                            DataSource = tbl
                        };
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không có dữ liệu";
                    }
                }
                else if (vMaBC == "40-HS")
                {
                    DataTable tbl = report_BL.DTReport_AHS_By_VuAnID(vVuAnID, "AHS_20");
                    if (tbl.Rows.Count > 0)
                    {
                        idTitle.Text = "40-HS. Quyết định đình chỉ vụ án (dùng cho Hội đồng xét xử Sơ thẩm)";
                        DM_QD_QUYETDINH idQD = dt.DM_QD_QUYETDINH.Where(x => x.MA.Equals("40-HS")).FirstOrDefault();
                        AHS_SOTHAM_QUYETDINH_VUAN checkQD = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.VUANID == vVuAnID && x.QUYETDINHID == idQD.ID).FirstOrDefault();
                        DateTime ngayQD = checkQD.NGAYQD == null ? DateTime.Now : Convert.ToDateTime(checkQD.NGAYQD);
                        tbl.Rows[0]["v_SOQD_2"] = checkQD.SOQUYETDINH + "/" + ngayQD.Year;
                        rpt40HS rpt = new rpt40HS
                        {
                            DataSource = tbl
                        };
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không có dữ liệu";
                    }
                }
                else
                {
                    ltlmsg.InnerText = "Hệ thống chưa tự động tạo biểu mẫu " + vMaBC + ". Hãy tải lên \"File đính kèm\" (nếu có) của quyết định.";
                }
            }
            catch (Exception ex) { ltlmsg.InnerText = ex.Message; }
        }
        private void LoadReportAHS_PT(decimal vVuAnID, AHS_VUAN oVuAN)
        {
            try
            {
                rptView.Visible = true;
                string strDiadiem = GetDiaDiem((decimal)oVuAN.TOAPHUCTHAMID), vMaBC = "", strTenToaAn = GetTenToa((decimal)oVuAN.TOAPHUCTHAMID, true),
                    strDiaChiTamTru = "", strDiaChiThuongTru = "", strTenChanhAn = "", strChucVuChanhAn = "", str_P_ChanhAn = "",
                    strTitleDVThiHanh = "", strTPChuToa = "";
                bool IsToaQuanSu = false;
                decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), BieuMauID = 0, IDLQD = 0,
                    IDQD = 0, BanAnID = 0;
                if (Request["BM"] != null)
                    vMaBC = Request["BM"] + "";
                DM_BIEUMAU bm = dt.DM_BIEUMAU.Where(x => x.MABM == vMaBC).FirstOrDefault();
                if (bm != null)
                {
                    BieuMauID = bm.ID;
                }
                AHS_PHUCTHAM_BANAN PTBA = dt.AHS_PHUCTHAM_BANAN.Where(x => x.VUANID == vVuAnID && x.TOAANID == oVuAN.TOAPHUCTHAMID).OrderByDescending(x => x.NGAYBANAN).FirstOrDefault();
                if (PTBA != null)
                {
                    BanAnID = PTBA.ID;
                }
                DM_QD_LOAI oLQD = dt.DM_QD_LOAI.Where(x => x.MA == "BTG").FirstOrDefault();
                if (oLQD != null) IDLQD = oLQD.ID;
                DM_TOAAN ToaAn = dt.DM_TOAAN.Where(x => x.ID == oVuAN.TOAANID).FirstOrDefault();
                if (ToaAn != null)
                {
                    if (ToaAn.LOAITOA.Contains("QS"))// các tòa quân sự
                    {
                        strTitleDVThiHanh = "Đơn vị Cảnh vệ";
                        IsToaQuanSu = true;
                    }
                    else
                    {
                        strTitleDVThiHanh = "Công an";
                        IsToaQuanSu = false;
                    }
                }
                AHS_PHUCTHAM_THULY oThuLy = dt.AHS_PHUCTHAM_THULY.Where(x => x.VUANID == vVuAnID).OrderByDescending(x => x.NGAYTHULY).FirstOrDefault();
                //Hội đồng xét xử
                List<AHS_PHUCTHAM_HDXX> lstHD = dt.AHS_PHUCTHAM_HDXX.Where(x => x.VUANID == vVuAnID).ToList();
                AHS_PHUCTHAM_HDXX TPChuToa = lstHD.Where(x => x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN).FirstOrDefault();
                if (TPChuToa != null)
                {
                    strTPChuToa = GetCanBoGioiTinh((decimal)TPChuToa.CANBOID);
                    DM_CANBO cboNguoiPhanCong = dt.DM_CANBO.Where(x => x.ID == TPChuToa.NGUOIPHANCONGID).FirstOrDefault();
                    if (cboNguoiPhanCong != null)
                    {
                        strTenChanhAn = cboNguoiPhanCong.HOTEN;
                        decimal ChucVuID = cboNguoiPhanCong.CHUCVUID + "" == "" ? 0 : (decimal)cboNguoiPhanCong.CHUCVUID;
                        DM_DATAITEM ChucVu = dt.DM_DATAITEM.Where(x => x.ID == ChucVuID).FirstOrDefault();
                        if (ChucVu != null)
                        {
                            strChucVuChanhAn = ChucVu.TEN;
                        }
                    }
                }
                DTBIEUMAU objDTBieuMau = new DTBIEUMAU();
                if (vMaBC == "01-HS")
                {
                    rpt01HS rpt = new rpt01HS();
                    DataTable tbl = report_BL.DTReport_AHS_By_VuAnID_GiaiDoan(vVuAnID, ENUM_GIAIDOANVUAN.PHUCTHAM, "AHS_01");
                    if (tbl.Rows.Count > 0)
                    {
                        for (int i = 0; i < tbl.Rows.Count; i++)
                        {
                            tbl.Rows[i]["v_TENTOAAN"] = strTenToaAn.ToUpper();
                        }
                        rpt.DataSource = tbl;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không có dữ liệu.";
                    }
                }
                else if (vMaBC == "02-HS")
                {
                    rpt02HS rpt = new rpt02HS();
                    DataTable tbl = report_BL.DTReport_AHS_By_VuAnID_GiaiDoan(vVuAnID, ENUM_GIAIDOANVUAN.PHUCTHAM, "AHS_02");
                    if (tbl.Rows.Count > 0)
                    {
                        for (int i = 0; i < tbl.Rows.Count; i++)
                        {
                            tbl.Rows[i]["v_TENTOAAN"] = strTenToaAn.ToUpper();
                        }
                        rpt.DataSource = tbl;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không có dữ liệu.";
                    }
                }
                else if (vMaBC == "03-HS")
                {
                    rpt03HS rpt = new rpt03HS();
                    DataTable tbl = report_BL.DTReport_AHS_By_VuAnID_GiaiDoan(vVuAnID, ENUM_GIAIDOANVUAN.PHUCTHAM, "AHS_03");
                    if (tbl.Rows.Count > 0)
                    {
                        for (int i = 0; i < tbl.Rows.Count; i++)
                        {
                            tbl.Rows[i]["v_TENTOAAN"] = strTenToaAn.ToUpper();
                        }
                        rpt.DataSource = tbl;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không có dữ liệu.";
                    }
                }
                else if (vMaBC == "09-HS")
                {
                    // Biểu mẫu sẽ nhân bản theo danh sách bị can áp dụng biểu mẫu
                    IDQD = 0;
                    AHS_PHUCTHAM_QUYETDINH_BICAN QDBC = null; AHS_BICANBICAO BiCan = null; DTBIEUMAU.DTBM04HSRow r09HS;
                    DM_HANHCHINH hc = null; DM_DATAITEM NgheNghiep = null;
                    DM_QD_QUYETDINH oDMQD = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == IDLQD && x.MA == "09-HS").FirstOrDefault();
                    if (oDMQD != null) IDQD = oDMQD.ID;
                    List<AHS_FILE> lstBiCan_BM = dt.AHS_FILE.Where(x => x.BIEUMAUID == BieuMauID && x.VUANID == vVuAnID && x.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM).ToList();
                    foreach (AHS_FILE item in lstBiCan_BM)
                    {
                        QDBC = dt.AHS_PHUCTHAM_QUYETDINH_BICAN.Where(x => x.BICANID == item.BICAOID && x.VUANID == vVuAnID && x.QUYETDINHID == IDQD).FirstOrDefault();
                        DM_CANBO cbo = dt.DM_CANBO.Where(x => x.ID == QDBC.NGUOIKYID).FirstOrDefault<DM_CANBO>();
                        if (cbo != null)
                        {
                            if (cbo.CHUCVUID == 45)
                            {
                                strChucVuChanhAn = "CHÁNH ÁN";
                                str_P_ChanhAn = "";
                            }
                            else
                            {
                                strChucVuChanhAn = "KT. CHÁNH ÁN";
                                str_P_ChanhAn = "PHÓ CHÁNH ÁN";
                            }
                            strTenChanhAn = cbo.HOTEN;
                        }
                        r09HS = objDTBieuMau.DTBM04HS.NewDTBM04HSRow();
                        r09HS.TENTOAAN = strTenToaAn;
                        r09HS.TOASOTHAM = GetTenToa((decimal)oVuAN.TOAANID, false);
                        if (QDBC != null)
                        {
                            DateTime? oNgayQD = QDBC.NGAYQD + "" == "" ? (DateTime?)null : (DateTime)QDBC.NGAYQD;
                            if (oNgayQD != null)
                            {
                                DateTime NgayQD = (DateTime)oNgayQD;
                                r09HS.NGAYQD = string.Format("{0:00}", NgayQD.Day);
                                r09HS.THANGQD = string.Format("{0:00}", NgayQD.Month);
                                r09HS.NAMQD = NgayQD.Year.ToString();
                                r09HS.SOQD = QDBC.SOQUYETDINH + "/" + NgayQD.Year.ToString();
                            }
                            r09HS.TUNGAY = QDBC.HIEULUCTU + "" == "" ? "" : ((DateTime)QDBC.HIEULUCTU).ToString("dd/MM/yyyy");
                            r09HS.NOIGIAMGIU = QDBC.NOIGIAMGIU;
                        }
                        r09HS.DIADIEM = strDiadiem;
                        if (oThuLy != null)
                        {
                            DateTime? oNgayTL = oThuLy.NGAYTHULY + "" == "" ? (DateTime?)null : (DateTime)oThuLy.NGAYTHULY;
                            if (oNgayTL != null)
                            {
                                DateTime NgayTL = (DateTime)oNgayTL;
                                r09HS.NGAYTHULY = string.Format("{0:00}", NgayTL.Day);
                                r09HS.THANGTHULY = string.Format("{0:00}", NgayTL.Month);
                                r09HS.NAMTHULY = NgayTL.Year.ToString();
                                r09HS.SOTHULY = oThuLy.SOTHULY + "/" + NgayTL.Year.ToString();
                            }
                        }
                        BiCan = dt.AHS_BICANBICAO.Where(x => x.ID == item.BICAOID).FirstOrDefault();
                        if (BiCan != null)
                        {
                            hc = dt.DM_HANHCHINH.Where(x => x.ID == BiCan.TAMTRU_HUYEN).FirstOrDefault();
                            if (hc != null)
                            {
                                strDiaChiTamTru = hc.MA_TEN;
                            }
                            hc = dt.DM_HANHCHINH.Where(x => x.ID == BiCan.HKTT_HUYEN).FirstOrDefault();
                            if (hc != null)
                            {
                                strDiaChiThuongTru = hc.MA_TEN;
                            }
                            r09HS.LOAIDOITUONG = BiCan.LOAIDOITUONG.ToString();
                            if (BiCan.LOAIDOITUONG == 0)// cá nhân
                            {
                                r09HS.BICAN_HOTEN = BiCan.HOTEN;
                                r09HS.BICAN_TENKHAC = "";
                                r09HS.BICAN_DC_TAMTRU = BiCan.TAMTRUCHITIET + "" == "" ? strDiaChiTamTru : BiCan.TAMTRUCHITIET + ", " + strDiaChiTamTru;
                                r09HS.BICAN_DC_THUONGTRU = BiCan.KHTTCHITIET + "" == "" ? strDiaChiThuongTru : BiCan.KHTTCHITIET + ", " + strDiaChiThuongTru;
                                DM_HANHCHINH noiSinh = dt.DM_HANHCHINH.Where(x => x.ID == BiCan.HKTT).FirstOrDefault();
                                r09HS.BICAN_NGAYSINH = BiCan.NGAYSINH + "" == "" ? "" : (((DateTime)BiCan.NGAYSINH).ToString("dd/MM/yyyy") == DateTime.MinValue.ToString("dd/MM/yyyy") ? BiCan.NAMSINH.ToString() : ((DateTime)BiCan.NGAYSINH).ToString("dd/MM/yyyy"));
                                r09HS.BICAN_ADDRESS = "Nơi sinh: " + noiSinh.TEN.Replace("tỉnh", "").Replace("thành phố", "");
                                NgheNghiep = dt.DM_DATAITEM.Where(x => x.ID == BiCan.NGHENGHIEPID).FirstOrDefault();
                                if (NgheNghiep != null)
                                { r09HS.BICAN_NGHENGHIEP = NgheNghiep.TEN; }
                            }
                            else
                            {
                                r09HS.BICAN_HOTEN = BiCan.HOTEN;// Tên pháp nhân thương mại
                                r09HS.BICAN_TENKHAC = BiCan.TENKHAC;// Tên người đại diện
                                r09HS.BICAN_DC_TAMTRU = "";
                                r09HS.BICAN_DC_THUONGTRU = BiCan.KHTTCHITIET + "" == "" ? strDiaChiThuongTru : BiCan.KHTTCHITIET + ", " + strDiaChiThuongTru;

                                r09HS.BICAN_NGAYSINH = "";
                                r09HS.BICAN_NGHENGHIEP = "";
                            }
                        }
                        AHS_SOTHAM_BANAN STBA = dt.AHS_SOTHAM_BANAN.Where(x => x.VUANID == vVuAnID && x.TOAANID == oVuAN.TOAANID).OrderByDescending(x => x.NGAYBANAN).FirstOrDefault();
                        if (STBA != null)
                        {
                            r09HS.MUCXUPHAT = GetHinhPhatBiCao(STBA.ID, (decimal)item.BICAOID, false, TOASOTHAM);
                            r09HS.TOIDANH = GetToiDanhBiCao(STBA.ID, (decimal)item.BICAOID, TOASOTHAM);
                            r09HS.DIEUKHOAN = GetDieuKhoan(STBA.ID, vVuAnID, (decimal)item.BICAOID, TOASOTHAM);

                            //AHS_SOTHAM_BANAN_DIEU_CHITIET_BL ahs_tonghop = new AHS_SOTHAM_BANAN_DIEU_CHITIET_BL();
                            //decimal vBiCaoID = Convert.ToDecimal(item.BICAOID);

                            //List<AHS_SOTHAM_BANAN_DIEU_CHITIET> dsToiDanh = dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Where(x => x.BANANID == STBA.ID && x.BICANID == vBiCaoID).ToList();
                            //int soToi = 0;
                            //foreach (var td in dsToiDanh)
                            //{
                            //    DM_BOLUAT_TOIDANH dmToiDanh = dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == td.TOIDANHID).FirstOrDefault();
                            //    if(dmToiDanh.DIEM == null && dmToiDanh.KHOAN == null)
                            //    {
                            //        soToi++;
                            //    }
                            //}

                            //r09HS.CANCU_DIEULUAT = ", tổng hợp hình phạt chung của " + soToi + " tội là " + ahs_tonghop.Tonghophinhphat_ST(vVuAnID, vBiCaoID);
                        }
                        int ThoiGianTamGiam = QDBC.HIEULUCDEN + "" == "" ? 0 : ((DateTime)QDBC.HIEULUCDEN).Subtract((DateTime)QDBC.HIEULUCTU).Days;
                        //if (ThoiGianTamGiam <= 45)
                        //{
                        //    r09HS.THOIHANTAMGIAM = "45 ngày (Bốn mươi lăm ngày), kể từ ngày tuyên án.";
                        //}
                        //else
                        //{
                        //    r09HS.THOIHANTAMGIAM = ThoiGianTamGiam + " ngày (" + Cls_Comon.NumberToTextVN(ThoiGianTamGiam).Replace("đồng", "") + "ngày), kể từ ngày " + string.Format("{0:00}", ((DateTime)QDBC.HIEULUCTU).Day) + " tháng " + string.Format("{0:00}", ((DateTime)QDBC.HIEULUCTU).Month) + " năm " + string.Format("{0:00}", ((DateTime)QDBC.HIEULUCTU).Year);
                        //}

                        //if (ThoiGianTamGiam >= 45) đang nhẩm sơ thẩm, phúc thẩm phải 90 ngày
                        //{
                        //    r09HS.THOIHANTAMGIAM = "45 ngày (Bốn mươi lăm ngày), kể từ ngày tuyên án.";
                        //}
                        //else
                        //{
                        //r09HS.THOIHANTAMGIAM = ThoiGianTamGiam + " ngày (" + Cls_Comon.NumberToTextVN(ThoiGianTamGiam).Replace("đồng", "") + "ngày), hết thời hạn tạm giam ngày " + ((DateTime)QDBC.HIEULUCDEN).ToString("dd/MM/yyyy");
                        r09HS.THOIHANTAMGIAM = ThoiGianTamGiam + " (" + Cls_Comon.NumberToTextVN(ThoiGianTamGiam).Replace("đồng", "") + ") ngày, kể từ ngày " + string.Format("{0:00}", ((DateTime)QDBC.HIEULUCTU).Day) + " tháng " + string.Format("{0:00}", ((DateTime)QDBC.HIEULUCTU).Month) + " năm " + string.Format("{0:00}", ((DateTime)QDBC.HIEULUCTU).Year);
                        r09HS.THOIHANTAMGIAM = r09HS.THOIHANTAMGIAM.Replace(" )", ")").ToLower();
                        // }
                        AHS_TONGHOPHINHPHAT ahs_tonghop = new AHS_TONGHOPHINHPHAT();
                        string tbla = ahs_tonghop.Tonghophinhphat_ST(vVuAnID, (decimal)item.BICAOID);

                        AHS_SOTHAM_BANAN_DIEU_CHITIET_BL ahs_GET_TONG_SO_TOI = new AHS_SOTHAM_BANAN_DIEU_CHITIET_BL();
                        DataTable tbl = ahs_GET_TONG_SO_TOI.GET_TONG_SO_TOI(Convert.ToString(STBA.ID), Convert.ToString(item.BICAOID));

                        Decimal tong_dieu = 0;
                        if (tbl != null && tbl.Rows.Count > 0)
                        {
                            tong_dieu = Convert.ToDecimal(tbl.Rows[0]["KETQUAS"].ToString());
                        }
                        String VCANCU_DIEULUAT = "";
                        if (tong_dieu > 1)
                        {
                            String dieu = "";
                            if (tong_dieu < 10)
                            {
                                dieu = "0" + tong_dieu;
                            }
                            if (QDBC.HINHPHAT_VUAN_KHAC == 0)
                            {
                                VCANCU_DIEULUAT = "Căn cứ Điều 55 Bộ luật hình sự, tổng hợp hình phạt chung của cả " + dieu + " tội là " + tbla;
                            }
                            else
                            {
                                VCANCU_DIEULUAT = "Căn cứ Điều 56 Bộ luật hình sự, tổng hợp hình phạt chung của cả " + dieu + " tội là " + tbla;
                            }
                            if (VCANCU_DIEULUAT != "")
                            {
                                if(VCANCU_DIEULUAT.Length > 2)
                                {
                                    VCANCU_DIEULUAT = VCANCU_DIEULUAT.Remove(VCANCU_DIEULUAT.Length - 2, 2).TrimEnd() + ";";
                                }
                            }
                            r09HS.CANCU_DIEULUAT = VCANCU_DIEULUAT;
                        }

                        r09HS.ISCHANHAN = strChucVuChanhAn;
                        r09HS.TENCHANHAN = strTenChanhAn;
                        r09HS.IS_P_CHANHAN = str_P_ChanhAn;
                        r09HS.TENVKS = strTenToaAn.Replace("Tòa án nhân dân cấp cao", "VKSNDCC").Replace("TAND", "VKSND").Replace("\n", "");

                        string firstCharacter = r09HS.BICAN_DC_THUONGTRU;
                        if(firstCharacter.Length > 1)
                        {
                            firstCharacter = firstCharacter.Substring(0, 1);
                        }
                        firstCharacter = firstCharacter.ToUpper();
                        string strContent = r09HS.BICAN_DC_THUONGTRU;
                        if(strContent.Length > 1)
                        {
                            strContent = strContent.Remove(0, 1);
                        }
                        strContent = firstCharacter + strContent;
                        r09HS.BICAN_DC_THUONGTRU = strContent;

                        string firstCharacter2 = r09HS.BICAN_DC_TAMTRU;
                        if(firstCharacter2.Length > 1)
                        {
                            firstCharacter2 = firstCharacter2.Substring(0, 1);
                        }
                        firstCharacter2 = firstCharacter2.ToUpper();
                        string strContent2 = r09HS.BICAN_DC_TAMTRU;
                        if(strContent2.Length > 1)
                        {
                            strContent2 = strContent2.Remove(0, 1);
                        }
                        strContent2 = firstCharacter2 + strContent2;
                        r09HS.BICAN_DC_TAMTRU = strContent2;

                        objDTBieuMau.DTBM04HS.AddDTBM04HSRow(r09HS);
                        objDTBieuMau.AcceptChanges();
                    }
                    rpt09HS rpt = new rpt09HS
                    {
                        DataSource = objDTBieuMau
                    };
                    rptView.OpenReport(rpt);
                }
                else if (vMaBC == "10-HS")
                {
                    // Biểu mẫu sẽ nhân bản theo danh sách bị can áp dụng biểu mẫu
                    IDQD = 0;
                    AHS_PHUCTHAM_QUYETDINH_BICAN QDBC = null; AHS_BICANBICAO BiCan = null; DTBIEUMAU.DTBM04HSRow r10HS;
                    DM_HANHCHINH hc = null; DM_DATAITEM NgheNghiep = null;
                    DM_QD_QUYETDINH oDMQD = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == IDLQD && x.MA == "10-HS").FirstOrDefault();
                    if (oDMQD != null) IDQD = oDMQD.ID;
                    List<AHS_FILE> lstBiCan_BM = dt.AHS_FILE.Where(x => x.BIEUMAUID == BieuMauID && x.VUANID == vVuAnID && x.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM).ToList();
                    foreach (AHS_FILE item in lstBiCan_BM)
                    {
                        QDBC = dt.AHS_PHUCTHAM_QUYETDINH_BICAN.Where(x => x.BICANID == item.BICAOID && x.VUANID == vVuAnID && x.QUYETDINHID == IDQD).FirstOrDefault();
                        r10HS = objDTBieuMau.DTBM04HS.NewDTBM04HSRow();
                        r10HS.TOASOTHAM = GetTenToa((decimal)oVuAN.TOAANID, false);
                        r10HS.TENTOAAN = strTenToaAn;
                        r10HS.LOAITOAAN = IsToaQuanSu ? "QS" : "DS";
                        if (QDBC != null)
                        {
                            DateTime? oNgayQD = QDBC.NGAYQD + "" == "" ? (DateTime?)null : (DateTime)QDBC.NGAYQD;
                            if (oNgayQD != null)
                            {
                                DateTime NgayQD = (DateTime)oNgayQD;
                                r10HS.NGAYQD = NgayQD.Day.ToString();
                                r10HS.THANGQD = NgayQD.Month.ToString();
                                r10HS.NAMQD = NgayQD.Year.ToString();
                                r10HS.SOQD = QDBC.SOQUYETDINH + "/" + NgayQD.Year.ToString();
                            }
                            r10HS.DENNGAY = QDBC.HIEULUCDEN + "" == "" ? "" : ((DateTime)QDBC.HIEULUCDEN).ToString("dd/MM/yyyy");
                            r10HS.NOIGIAMGIU = QDBC.NOIGIAMGIU;
                        }
                        r10HS.DIADIEM = strDiadiem;
                        if (oThuLy != null)
                        {
                            DateTime? oNgayTL = oThuLy.NGAYTHULY + "" == "" ? (DateTime?)null : (DateTime)oThuLy.NGAYTHULY;
                            if (oNgayTL != null)
                            {
                                DateTime NgayTL = (DateTime)oNgayTL;
                                r10HS.NGAYTHULY = string.Format("{0:00}", NgayTL.Day);
                                r10HS.THANGTHULY = string.Format("{0:00}", NgayTL.Month);
                                r10HS.NAMTHULY = NgayTL.Year.ToString();
                                r10HS.SOTHULY = oThuLy.SOTHULY + "/" + NgayTL.Year.ToString();
                            }
                        }
                        r10HS.BICANID = item.BICAOID + "" == "" ? "0" : item.BICAOID.ToString();
                        BiCan = dt.AHS_BICANBICAO.Where(x => x.ID == item.BICAOID).FirstOrDefault();
                        if (BiCan != null)
                        {
                            hc = dt.DM_HANHCHINH.Where(x => x.ID == BiCan.TAMTRU_HUYEN).FirstOrDefault();
                            if (hc != null)
                            {
                                strDiaChiTamTru = hc.MA_TEN;
                            }
                            hc = dt.DM_HANHCHINH.Where(x => x.ID == BiCan.HKTT_HUYEN).FirstOrDefault();
                            if (hc != null)
                            {
                                strDiaChiThuongTru = hc.MA_TEN;
                            }
                            r10HS.LOAIDOITUONG = BiCan.LOAIDOITUONG.ToString();
                            if (BiCan.LOAIDOITUONG == 0)// cá nhân
                            {
                                r10HS.BICAN_HOTEN = BiCan.HOTEN;
                                r10HS.BICAN_TENKHAC = "";
                                r10HS.BICAN_DC_TAMTRU = BiCan.TAMTRUCHITIET + "" == "" ? strDiaChiTamTru : BiCan.TAMTRUCHITIET + ", " + strDiaChiTamTru;
                                r10HS.BICAN_DC_THUONGTRU = BiCan.KHTTCHITIET + "" == "" ? strDiaChiThuongTru : BiCan.KHTTCHITIET + ", " + strDiaChiThuongTru;
                                r10HS.BICAN_NGAYSINH = BiCan.NGAYSINH + "" == "" ? "" : (((DateTime)BiCan.NGAYSINH).ToString("dd/MM/yyyy") == DateTime.MinValue.ToString("dd/MM/yyyy") ? BiCan.NAMSINH.ToString() : ((DateTime)BiCan.NGAYSINH).ToString("dd/MM/yyyy"));
                                NgheNghiep = dt.DM_DATAITEM.Where(x => x.ID == BiCan.NGHENGHIEPID).FirstOrDefault();
                                if (NgheNghiep != null)
                                { r10HS.BICAN_NGHENGHIEP = NgheNghiep.TEN; }
                            }
                            else
                            {
                                r10HS.BICAN_HOTEN = BiCan.HOTEN;// Tên pháp nhân thương mại
                                r10HS.BICAN_TENKHAC = BiCan.TENKHAC;// Tên người đại diện
                                r10HS.BICAN_DC_TAMTRU = "";
                                r10HS.BICAN_DC_THUONGTRU = BiCan.KHTTCHITIET + "" == "" ? strDiaChiThuongTru : BiCan.KHTTCHITIET + ", " + strDiaChiThuongTru;
                                r10HS.BICAN_NGAYSINH = "";
                                r10HS.BICAN_NGHENGHIEP = "";
                            }
                        }
                        AHS_SOTHAM_BANAN STBA = dt.AHS_SOTHAM_BANAN.Where(x => x.VUANID == vVuAnID && x.TOAANID == oVuAN.TOAANID).OrderByDescending(x => x.NGAYBANAN).FirstOrDefault();
                        if (STBA != null)
                        {
                            r10HS.MUCXUPHAT = GetHinhPhatBiCao(STBA.ID, (decimal)item.BICAOID, false, TOASOTHAM);
                            r10HS.TOIDANH = GetToiDanhBiCao(STBA.ID, (decimal)item.BICAOID, TOASOTHAM);
                            r10HS.DIEUKHOAN = GetDieuKhoan(STBA.ID, vVuAnID, (decimal)item.BICAOID, TOASOTHAM);
                        }
                        r10HS.TITLE_DONVITHIHANH = strTitleDVThiHanh;
                        r10HS.ISCHANHAN = strChucVuChanhAn;
                        r10HS.TENCHANHAN = strTenChanhAn;
                        objDTBieuMau.DTBM04HS.AddDTBM04HSRow(r10HS);
                        objDTBieuMau.AcceptChanges();
                    }
                    rpt10HS rpt = new rpt10HS
                    {
                        DataSource = objDTBieuMau
                    };
                    rptView.OpenReport(rpt);
                }
                else if (vMaBC == "11-HS")
                {
                    // Biểu mẫu sẽ nhân bản theo danh sách bị can áp dụng biểu mẫu
                    IDQD = 0;
                    AHS_PHUCTHAM_QUYETDINH_BICAN QDBC = null; AHS_BICANBICAO BiCan = null; DTBIEUMAU.DTBM04HSRow r11HS;
                    DM_HANHCHINH hc = null; DM_DATAITEM NgheNghiep = null;
                    DM_QD_QUYETDINH oDMQD = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == IDLQD && x.MA == "11-HS").FirstOrDefault();
                    if (oDMQD != null) IDQD = oDMQD.ID;
                    List<AHS_FILE> lstBiCan_BM = dt.AHS_FILE.Where(x => x.BIEUMAUID == BieuMauID && x.VUANID == vVuAnID && x.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM).ToList();
                    foreach (AHS_FILE item in lstBiCan_BM)
                    {
                        QDBC = dt.AHS_PHUCTHAM_QUYETDINH_BICAN.Where(x => x.BICANID == item.BICAOID && x.VUANID == vVuAnID && x.QUYETDINHID == IDQD).FirstOrDefault();
                        r11HS = objDTBieuMau.DTBM04HS.NewDTBM04HSRow();
                        r11HS.TENTOAAN = strTenToaAn;
                        r11HS.TP_CHUTOA = strTPChuToa;
                        r11HS.TP_THANHVIEN = FillDSThamPhanThanhVien_AHS_PT(lstHD, IsToaQuanSu);
                        r11HS.TP_HDND = FillDSThamPhanHTND_AHS_PT(lstHD, IsToaQuanSu);
                        r11HS.LOAITOAAN = IsToaQuanSu ? "QS" : "DS";
                        // Lấy kết quả phúc thẩm nếu là cấp phúc thẩm hủy án để điều tra hoặc xét xử lại theo thủ tục sơ thẩm
                        // để xác định VKS hay tòa án sẽ thụ lý lại
                        // Nếu Mã kết quả là (04,06) xét xử lại: tòa án cấp sơ thẩm thụ lý lại,(14) điều tra lại: VKS cấp sơ thẩm
                        string MaKQPT = "";
                        if (PTBA != null)// bản án phúc thẩm
                        {
                            DM_KETQUA_PHUCTHAM KQPT = dt.DM_KETQUA_PHUCTHAM.Where(x => x.ID == (decimal)PTBA.KETQUAPHUCTHAMID).FirstOrDefault();
                            if (KQPT != null)
                            {
                                MaKQPT = KQPT.MA;
                            }
                        }
                        r11HS.DIEULUATBOSUNG = QDBC.DIEULUATAPDUNGTHEM + ";" + MaKQPT;
                        if (QDBC != null)
                        {
                            DateTime? BBNghiAnNgay = QDBC.BIENBANNGHIAN_NGAY + "" == "" ? (DateTime?)null : (DateTime)QDBC.BIENBANNGHIAN_NGAY;
                            if (BBNghiAnNgay != null)
                            {
                                DateTime NgayBBNA = (DateTime)BBNghiAnNgay;
                                r11HS.BBNGHIAN_NGAY = NgayBBNA.Day.ToString();
                                r11HS.BBNGHIAN_THANG = NgayBBNA.Month.ToString();
                                r11HS.BBNGHIAN_NAM = NgayBBNA.Year.ToString();
                            }
                            DateTime? oNgayQD = QDBC.NGAYQD + "" == "" ? (DateTime?)null : (DateTime)QDBC.NGAYQD;
                            if (oNgayQD != null)
                            {
                                DateTime NGAYQD = (DateTime)oNgayQD;
                                r11HS.NGAYQD = NGAYQD.Day.ToString();
                                r11HS.THANGQD = NGAYQD.Month.ToString();
                                r11HS.NAMQD = NGAYQD.Year.ToString();
                                r11HS.SOQD = QDBC.SOQUYETDINH + "/" + NGAYQD.Year.ToString();
                            }
                            r11HS.TUNGAY = QDBC.HIEULUCTU + "" == "" ? "" : ((DateTime)QDBC.HIEULUCTU).ToString("dd/MM/yyyy");
                            r11HS.NOIGIAMGIU = QDBC.NOIGIAMGIU;
                        }
                        r11HS.DIADIEM = strDiadiem;
                        r11HS.BICANID = item.BICAOID + "" == "" ? "0" : item.BICAOID.ToString();
                        BiCan = dt.AHS_BICANBICAO.Where(x => x.ID == item.BICAOID).FirstOrDefault();
                        if (BiCan != null)
                        {
                            hc = dt.DM_HANHCHINH.Where(x => x.ID == BiCan.TAMTRU_HUYEN).FirstOrDefault();
                            if (hc != null)
                            {
                                strDiaChiTamTru = hc.MA_TEN;
                            }
                            hc = dt.DM_HANHCHINH.Where(x => x.ID == BiCan.HKTT_HUYEN).FirstOrDefault();
                            if (hc != null)
                            {
                                strDiaChiThuongTru = hc.MA_TEN;
                            }
                            r11HS.LOAIDOITUONG = BiCan.LOAIDOITUONG.ToString();
                            if (BiCan.LOAIDOITUONG == 0)// cá nhân
                            {
                                r11HS.BICAN_HOTEN = BiCan.HOTEN;
                                r11HS.BICAN_TENKHAC = "";
                                r11HS.BICAN_DC_TAMTRU = BiCan.TAMTRUCHITIET + "" == "" ? strDiaChiTamTru : BiCan.TAMTRUCHITIET + ", " + strDiaChiTamTru;
                                r11HS.BICAN_DC_THUONGTRU = BiCan.KHTTCHITIET + "" == "" ? strDiaChiThuongTru : BiCan.KHTTCHITIET + ", " + strDiaChiThuongTru;
                                r11HS.BICAN_NGAYSINH = BiCan.NGAYSINH + "" == "" ? "" : (((DateTime)BiCan.NGAYSINH).ToString("dd/MM/yyyy") == DateTime.MinValue.ToString("dd/MM/yyyy") ? BiCan.NAMSINH.ToString() : ((DateTime)BiCan.NGAYSINH).ToString("dd/MM/yyyy"));
                                NgheNghiep = dt.DM_DATAITEM.Where(x => x.ID == BiCan.NGHENGHIEPID).FirstOrDefault();
                                if (NgheNghiep != null)
                                { r11HS.BICAN_NGHENGHIEP = NgheNghiep.TEN; }
                            }
                            else
                            {
                                r11HS.BICAN_HOTEN = BiCan.HOTEN;// Tên pháp nhân thương mại
                                r11HS.BICAN_TENKHAC = BiCan.TENKHAC;// Tên người đại diện
                                r11HS.BICAN_DC_TAMTRU = "";
                                r11HS.BICAN_DC_THUONGTRU = BiCan.KHTTCHITIET + "" == "" ? strDiaChiThuongTru : BiCan.KHTTCHITIET + ", " + strDiaChiThuongTru;
                                r11HS.BICAN_NGAYSINH = "";
                                r11HS.BICAN_NGHENGHIEP = "";
                            }
                        }
                        r11HS.TENVKS = strTenToaAn.Replace("Tòa án nhân dân", "Viện kiểm sát nhân dân");
                        r11HS.MUCXUPHAT = GetHinhPhatBiCao(BanAnID, (decimal)item.BICAOID, false, TOAPHUCTHAM);
                        r11HS.TOIDANH = GetToiDanhBiCao(BanAnID, (decimal)item.BICAOID, TOAPHUCTHAM);
                        r11HS.DIEUKHOAN = GetDieuKhoan(BanAnID, vVuAnID, (decimal)item.BICAOID, TOAPHUCTHAM);
                        r11HS.ISCHANHAN = strChucVuChanhAn;
                        r11HS.TENCHANHAN = strTenChanhAn;
                        objDTBieuMau.DTBM04HS.AddDTBM04HSRow(r11HS);
                        objDTBieuMau.AcceptChanges();
                    }
                    rpt11HS rpt = new rpt11HS
                    {
                        DataSource = objDTBieuMau
                    };
                    rptView.OpenReport(rpt);
                }
                else if (vMaBC == "12-HS")
                {
                    // Biểu mẫu sẽ nhân bản theo danh sách bị can áp dụng biểu mẫu
                    IDQD = 0;
                    AHS_PHUCTHAM_QUYETDINH_BICAN QDBC = null; AHS_BICANBICAO BiCan = null; DTBIEUMAU.DTBM04HSRow r12HS;
                    DM_HANHCHINH hc = null; DM_DATAITEM NgheNghiep = null;
                    DM_QD_QUYETDINH oDMQD = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == IDLQD && x.MA == "12-HS").FirstOrDefault();
                    if (oDMQD != null) IDQD = oDMQD.ID;
                    List<AHS_FILE> lstBiCan_BM = dt.AHS_FILE.Where(x => x.BIEUMAUID == BieuMauID && x.VUANID == vVuAnID && x.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM).ToList();
                    foreach (AHS_FILE item in lstBiCan_BM)
                    {
                        QDBC = dt.AHS_PHUCTHAM_QUYETDINH_BICAN.Where(x => x.BICANID == item.BICAOID && x.VUANID == vVuAnID && x.QUYETDINHID == IDQD).FirstOrDefault();
                        r12HS = objDTBieuMau.DTBM04HS.NewDTBM04HSRow();
                        r12HS.TENTOAAN = strTenToaAn;
                        r12HS.TP_CHUTOA = strTPChuToa;
                        r12HS.TP_THANHVIEN = FillDSThamPhanThanhVien_AHS_PT(lstHD, IsToaQuanSu);
                        r12HS.LOAITOAAN = IsToaQuanSu ? "QS" : "DS";
                        r12HS.MUCXUPHAT = GetHinhPhatBiCao(BanAnID, (decimal)item.BICAOID, false, TOAPHUCTHAM);
                        if (QDBC != null)
                        {
                            DateTime? BBNghiAnNgay = QDBC.BIENBANNGHIAN_NGAY + "" == "" ? (DateTime?)null : (DateTime)QDBC.BIENBANNGHIAN_NGAY;
                            if (BBNghiAnNgay != null)
                            {
                                DateTime NgayBBNA = (DateTime)BBNghiAnNgay;
                                r12HS.BBNGHIAN_NGAY = NgayBBNA.Day.ToString();
                                r12HS.BBNGHIAN_THANG = NgayBBNA.Month.ToString();
                                r12HS.BBNGHIAN_NAM = NgayBBNA.Year.ToString();
                            }
                            DateTime oNgayQD = (DateTime)QDBC.NGAYQD;
                            r12HS.NGAYQD = oNgayQD.Day.ToString();
                            r12HS.THANGQD = oNgayQD.Month.ToString();
                            r12HS.NAMQD = oNgayQD.Year.ToString();
                            r12HS.SOQD = QDBC.SOQUYETDINH + "/" + oNgayQD.Year.ToString();
                            int ThoiHanPhatTu = QDBC.HIEULUCDEN + "" == "" ? 0 : ((DateTime)QDBC.HIEULUCDEN).Subtract((DateTime)QDBC.HIEULUCTU).Days;
                            if (ThoiHanPhatTu >= 45)
                            {
                                r12HS.THOIHANTAMGIAM = "45 ngày(Bốn mươi lăm ngày)";
                            }
                            else
                            {
                                r12HS.THOIHANTAMGIAM = r12HS.MUCXUPHAT;
                            }
                            r12HS.NOIGIAMGIU = QDBC.NOIGIAMGIU;
                        }
                        r12HS.DIADIEM = strDiadiem;
                        BiCan = dt.AHS_BICANBICAO.Where(x => x.ID == item.BICAOID).FirstOrDefault();
                        if (BiCan != null)
                        {
                            hc = dt.DM_HANHCHINH.Where(x => x.ID == BiCan.TAMTRU_HUYEN).FirstOrDefault();
                            if (hc != null)
                            {
                                strDiaChiTamTru = hc.MA_TEN;
                            }
                            hc = dt.DM_HANHCHINH.Where(x => x.ID == BiCan.HKTT_HUYEN).FirstOrDefault();
                            if (hc != null)
                            {
                                strDiaChiThuongTru = hc.MA_TEN;
                            }
                            r12HS.LOAIDOITUONG = BiCan.LOAIDOITUONG.ToString();
                            if (BiCan.LOAIDOITUONG == 0)// cá nhân
                            {
                                r12HS.BICAN_HOTEN = BiCan.HOTEN;
                                r12HS.BICAN_TENKHAC = "";
                                r12HS.BICAN_DC_TAMTRU = BiCan.TAMTRUCHITIET + "" == "" ? strDiaChiTamTru : BiCan.TAMTRUCHITIET + ", " + strDiaChiTamTru;
                                r12HS.BICAN_DC_THUONGTRU = BiCan.KHTTCHITIET + "" == "" ? strDiaChiThuongTru : BiCan.KHTTCHITIET + ", " + strDiaChiThuongTru;
                                r12HS.BICAN_NGAYSINH = BiCan.NGAYSINH + "" == "" ? "" : (((DateTime)BiCan.NGAYSINH).ToString("dd/MM/yyyy") == DateTime.MinValue.ToString("dd/MM/yyyy") ? BiCan.NAMSINH.ToString() : ((DateTime)BiCan.NGAYSINH).ToString("dd/MM/yyyy"));
                                NgheNghiep = dt.DM_DATAITEM.Where(x => x.ID == BiCan.NGHENGHIEPID).FirstOrDefault();
                                if (NgheNghiep != null)
                                { r12HS.BICAN_NGHENGHIEP = NgheNghiep.TEN; }
                            }
                            else
                            {
                                r12HS.BICAN_HOTEN = BiCan.HOTEN;// Tên pháp nhân thương mại
                                r12HS.BICAN_TENKHAC = BiCan.TENKHAC;// Tên người đại diện
                                r12HS.BICAN_DC_TAMTRU = "";
                                r12HS.BICAN_DC_THUONGTRU = BiCan.KHTTCHITIET + "" == "" ? strDiaChiThuongTru : BiCan.KHTTCHITIET + ", " + strDiaChiThuongTru;
                                r12HS.BICAN_NGAYSINH = "";
                                r12HS.BICAN_NGHENGHIEP = "";
                            }
                        }
                        r12HS.TOIDANH = GetToiDanhBiCao(BanAnID, (decimal)item.BICAOID, TOAPHUCTHAM);
                        r12HS.DIEUKHOAN = GetDieuKhoan(BanAnID, vVuAnID, (decimal)item.BICAOID, TOAPHUCTHAM);
                        r12HS.TITLE_DONVITHIHANH = strTitleDVThiHanh;
                        r12HS.ISCHANHAN = strChucVuChanhAn;
                        r12HS.TENCHANHAN = strTenChanhAn;
                        objDTBieuMau.DTBM04HS.AddDTBM04HSRow(r12HS);
                        objDTBieuMau.AcceptChanges();
                    }
                    rpt12HS rpt = new rpt12HS
                    {
                        DataSource = objDTBieuMau
                    };
                    rptView.OpenReport(rpt);
                }
                else if (vMaBC == "16-HS")
                {
                    DataTable tbl = report_BL.DTReport_AHS_By_VuAnID_GiaiDoan(vVuAnID, ENUM_GIAIDOANVUAN.PHUCTHAM, "AHS_16");
                    if (tbl.Rows.Count > 0)
                    {
                        idTitle.Text = "16-HS. Quyết định áp dụng thủ tục rút gọn";
                        rpt16HS rpt = new rpt16HS();
                        for (int i = 0; i < tbl.Rows.Count; i++)
                        {
                            tbl.Rows[i]["v_TENTOAAN_1_3"] = strTenToaAn.ToUpper();
                        }
                        rpt.DataSource = tbl;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không có dữ liệu";
                    }
                }
                else if (vMaBC == "17-HS")
                {
                    DataTable tbl = report_BL.DTReport_AHS_By_VuAnID_GiaiDoan(vVuAnID, ENUM_GIAIDOANVUAN.PHUCTHAM, "AHS_17");
                    if (tbl.Rows.Count > 0)
                    {
                        idTitle.Text = "17-HS. Quyết định hủy bỏ Quyết định áp dụng thủ tục rút gọn";
                        rpt17HS rpt = new rpt17HS();
                        for (int i = 0; i < tbl.Rows.Count; i++)
                        {
                            tbl.Rows[i]["v_TENTOAAN_1_3"] = strTenToaAn.ToUpper();
                        }
                        rpt.DataSource = tbl;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không có dữ liệu";
                    }
                }
                else if (vMaBC == "21-HS")
                {
                    DataTable tbl = report_BL.DTReport_AHS_By_VuAnID(vVuAnID, "AHS_21");
                    if (tbl.Rows.Count > 0)
                    {
                        DataRow row = tbl.Rows[0];
                        rpt21HS rpt = new rpt21HS();
                        string Temp = row["v_TP_HDXX"] + "";
                        int Length = Temp.Length;
                        if (Length >= 2)
                        {
                            Temp = Temp.Substring(0, Length - 2);
                        }
                        rpt.Parameters["prm_HDXX"].Value = row["v_TP_HDXX"] = Temp;

                        Temp = row["v_TP_DUKHUYET"] + "";
                        Length = Temp.Length;
                        if (Length >= 2)
                        {
                            Temp = Temp.Substring(0, Length - 2);
                        }
                        rpt.Parameters["prm_TP_DuKhuyet"].Value = row["v_TP_DUKHUYET"] = Temp;

                        Temp = row["v_HTND"] + "";
                        Length = Temp.Length;
                        if (Length >= 2)
                        {
                            Temp = Temp.Substring(0, Length - 2);
                        }
                        rpt.Parameters["prm_HTND"].Value = row["v_HTND"] = Temp;

                        Temp = row["v_HTND_DUKHUYET"] + "";
                        Length = Temp.Length;
                        if (Length >= 2)
                        {
                            Temp = Temp.Substring(0, Length - 2);
                        }
                        rpt.Parameters["prm_HTND_DK"].Value = row["v_HTND_DUKHUYET"] = Temp;

                        Temp = row["v_THUKY"] + "";
                        Length = Temp.Length;
                        if (Length >= 2)
                        {
                            Temp = Temp.Substring(0, Length - 2);
                        }
                        rpt.Parameters["prm_ThuKy"].Value = row["v_THUKY"] = Temp;

                        Temp = row["v_THUKY_DUKHUYET"] + "";
                        Length = Temp.Length;
                        if (Length >= 2)
                        {
                            Temp = Temp.Substring(0, Length - 2);
                        }
                        rpt.Parameters["prm_ThuKy_DK"].Value = row["v_THUKY_DUKHUYET"] = Temp;

                        rpt.Parameters["prm_KSV"].Value = row["v_KIEMSATVIEN"] + "";
                        rpt.Parameters["prm_KSV_DK"].Value = row["v_KIEMSATVIEN_DUKHUYET"] + "";

                        Temp = row["v_NGUOITGTT"] + "";
                        Length = Temp.Length;
                        if (Length >= 2)
                        {
                            Temp = Temp.Substring(0, Length - 2);
                        }
                        row["v_NGUOITGTT"] = Temp;

                        for (int i = 0; i < tbl.Rows.Count; i++)
                        {
                            tbl.Rows[i]["v_TENTOAAN_1_3"] = strTenToaAn.ToUpper();
                        }
                        rpt.DataSource = tbl;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không có dữ liệu.";
                    }
                }
                else if (vMaBC == "51-HS")
                {
                    //K: Thay đổi AHS_21
                    DataTable tbl = report_BL.DTReport_AHS_By_VuAnID(vVuAnID, "AHS_21");
                    if (tbl.Rows.Count > 0)
                    {
                        idTitle.Text = "51-HS. Quyết định đình chỉ việc xét xử phúc thẩm (dùng cho Thẩm phán chủ tọa phiên tòa)";
                        DM_QD_QUYETDINH idQD = dt.DM_QD_QUYETDINH.Where(x => x.MA.Equals("51-HS")).FirstOrDefault();
                        AHS_PHUCTHAM_QUYETDINH_VUAN checkQD = dt.AHS_PHUCTHAM_QUYETDINH_VUAN.Where(x => x.VUANID == vVuAnID && x.QUYETDINHID == idQD.ID).FirstOrDefault();
                        DateTime ngayQD = checkQD.NGAYQD == null ? DateTime.Now : Convert.ToDateTime(checkQD.NGAYQD);
                        tbl.Rows[0]["v_SOQD_2"] = checkQD.SOQUYETDINH + "/" + ngayQD.Year;
                        rpt51HS rpt = new rpt51HS
                        {
                            DataSource = tbl
                        };
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không có dữ liệu";
                    }
                }
                else if (vMaBC == "52-HS")
                {
                    //K: Thay đổi AHS_21
                    DataTable tbl = report_BL.DTReport_AHS_By_VuAnID(vVuAnID, "AHS_21");
                    if (tbl.Rows.Count > 0)
                    {
                        idTitle.Text = "52-HS. Quyết định đình chỉ việc xét xử phúc thẩm (dùng cho Thẩm phán chủ tọa phiên tòa)";
                        DM_QD_QUYETDINH idQD = dt.DM_QD_QUYETDINH.Where(x => x.MA.Equals("52-HS")).FirstOrDefault();
                        AHS_PHUCTHAM_QUYETDINH_VUAN checkQD = dt.AHS_PHUCTHAM_QUYETDINH_VUAN.Where(x => x.VUANID == vVuAnID && x.QUYETDINHID == idQD.ID).FirstOrDefault();
                        DateTime ngayQD = checkQD.NGAYQD == null ? DateTime.Now : Convert.ToDateTime(checkQD.NGAYQD);
                        tbl.Rows[0]["v_SOQD_2"] = checkQD.SOQUYETDINH + "/" + ngayQD.Year;
                        rpt52HS rpt = new rpt52HS
                        {
                            DataSource = tbl
                        };
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không có dữ liệu";
                    }
                }
                else
                {
                    ltlmsg.InnerText = "Hệ thống chưa tự động tạo biểu mẫu "+ vMaBC + ". Hãy tải lên \"File đính kèm\" (nếu có) của quyết định.";
                }
            }
            catch (Exception ex) { ltlmsg.InnerText = ex.Message; }
        }
        //private DTBIEUMAU FillDSBiCanDauVu_ADS(AHS_VUAN oVuAn, DTBIEUMAU objds, List<ADS_DON_DUONGSU> lstND)
        //{
        //    DTBIEUMAU.DTNGUYENDONRow nd;
        //    foreach (ADS_DON_DUONGSU ods in lstND)
        //    {
        //        nd = objds.DTNGUYENDON.NewDTNGUYENDONRow();
        //        nd.DONID = oDon.ID.ToString();
        //        nd.DUONGSUID = ods.ID.ToString();
        //        nd.TENDUONGSU = ods.TENDUONGSU;
        //        if (ods.LOAIDUONGSU == 1)
        //        {
        //            if (ods.GIOITINH == 1)
        //                nd.TENGIOITINH = "Ông";
        //            else nd.TENGIOITINH = "Bà";
        //        }
        //        nd.DIENTHOAI = ods.DIENTHOAI;
        //        nd.EMAIL = ods.EMAIL;
        //        nd.NOILAMVIEC = ods.DIACHICOQUAN;
        //        if (ods.TAMTRUID != null) nd.DIACHI = getDiachi((decimal)ods.TAMTRUID);
        //        nd.DIACHI = ods.TAMTRUCHITIET + " " + nd.DIACHI;
        //        objds.DTNGUYENDON.AddDTNGUYENDONRow(nd);
        //    }
        //    objds.AcceptChanges();
        //    return objds;
        //}
        //private DTBIEUMAU FillDSDongPham_AHN(AHS_VUAN oVuAn, DTBIEUMAU objds, List<AHN_DON_DUONGSU> lstND)
        //{
        //    DTBIEUMAU.DTNGUYENDONRow nd;
        //    foreach (AHN_DON_DUONGSU ods in lstND)
        //    {
        //        nd = objds.DTNGUYENDON.NewDTNGUYENDONRow();
        //        nd.DONID = oDon.ID.ToString();
        //        nd.DUONGSUID = ods.ID.ToString();
        //        nd.TENDUONGSU = ods.TENDUONGSU;
        //        if (ods.LOAIDUONGSU == 1)
        //        {
        //            if (ods.GIOITINH == 1)
        //                nd.TENGIOITINH = "Ông";
        //            else nd.TENGIOITINH = "Bà";
        //        }
        //        nd.DIENTHOAI = ods.DIENTHOAI;
        //        nd.EMAIL = ods.EMAIL;
        //        if (ods.TAMTRUID != null) nd.DIACHI = getDiachi((decimal)ods.TAMTRUID);
        //        nd.DIACHI = ods.TAMTRUCHITIET + " " + nd.DIACHI;
        //        objds.DTNGUYENDON.AddDTNGUYENDONRow(nd);
        //    }
        //    objds.AcceptChanges();
        //    return objds;
        //}
        private string GetToiDanhBiCao(decimal BanAnID, decimal BiCaoID, string DonVi_XuPhat)
        {
            string strResult = "";
            DataTable tblHinhPhat = null;
            if (DonVi_XuPhat == VKS)
            {
                AHS_SOTHAM_CAOTRANG_DIEULUAT DLuat = dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.BICANID == BiCaoID).FirstOrDefault();
                if (DLuat != null)
                {
                    AHS_REPORT_BL bl = new AHS_REPORT_BL();
                    tblHinhPhat = bl.AHS_GETTOIDANH_BICAO_VKS((decimal)DLuat.DIEULUATID, BiCaoID);
                }
            }
            else if (DonVi_XuPhat == TOASOTHAM)
            {
                AHS_SOTHAM_BANAN_DIEU_CHITIET STDieuCT = dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Where(x => x.BANANID == BanAnID && x.BICANID == BiCaoID).FirstOrDefault();
                if (STDieuCT != null)// Lấy bộ luật ID
                {
                    AHS_REPORT_BL bl = new AHS_REPORT_BL();
                    tblHinhPhat = bl.AHS_GETTOIDANH_BICAO_ST((decimal)STDieuCT.DIEULUATID, BanAnID, BiCaoID);
                }
            }
            else
            {
                AHS_PHUCTHAM_BANAN_DIEU_CT STDieuCT = dt.AHS_PHUCTHAM_BANAN_DIEU_CT.Where(x => x.BANANID == BanAnID && x.BICANID == BiCaoID).FirstOrDefault();
                if (STDieuCT != null)// Lấy bộ luật ID
                {
                    AHS_REPORT_BL bl = new AHS_REPORT_BL();
                    tblHinhPhat = bl.AHS_GETTOIDANH_BICAO_ST((decimal)STDieuCT.DIEULUATID, BanAnID, BiCaoID);
                }
            }
            if (tblHinhPhat != null && tblHinhPhat.Rows.Count > 0)
            {
                foreach (DataRow r in tblHinhPhat.Rows)
                {
                    if (strResult == "")
                    {
                        strResult = r["TENTOIDANH"] + "";
                    }
                    else { strResult += "; " + r["TENTOIDANH"] + ""; }
                }
            }
            return strResult;
        }
        private string GetHinhPhatBiCao(decimal BanAnID, decimal BiCaoID, bool IsQuyDoiThoiGian, string DonVi_XuPhat)
        {
            string strResult = "";
            AHS_REPORT_BL bl = new AHS_REPORT_BL();
            DataTable tblHinhPhat = null;
            if (DonVi_XuPhat == TOASOTHAM)
            {
                tblHinhPhat = bl.AHS_GETHINHPHAT_BICAO_ST(BanAnID, BiCaoID);
            }
            else
            {
                tblHinhPhat = bl.AHS_GETHINHPHAT_BICAO_PT(BanAnID, BiCaoID);
            }
            if (tblHinhPhat != null && tblHinhPhat.Rows.Count > 0)
            {
                foreach (DataRow r in tblHinhPhat.Rows)
                {
                    if (r["MAHINHPHAT"] + "" == "TUHINH")
                    {
                        strResult = "tử hình";
                        if (IsQuyDoiThoiGian)
                        { strResult = "46"; }
                        break;
                    }
                    else if (r["MAHINHPHAT"] + "" == "TUCHUNGTHAN")
                    {
                        strResult = "tù chung thân";
                        if (IsQuyDoiThoiGian)
                        { strResult = "46"; }
                        break;
                    }
                    else if (r["MAHINHPHAT"] + "" == "TUCOTHOIHAN")
                    {
                        decimal Ngay = r["TG_NGAY"] + "" == "" ? 0 : Convert.ToDecimal(r["TG_NGAY"] + ""),
                            Thang = r["TG_THANG"] + "" == "" ? 0 : Convert.ToDecimal(r["TG_THANG"] + ""),
                            Nam = r["TG_NAM"] + "" == "" ? 0 : Convert.ToDecimal(r["TG_NAM"] + "");

                        if (Ngay >= 30)
                        {
                            Thang = Thang + 1;
                            Ngay = Ngay - 30;
                        }
                        if (Thang >= 12)
                        {
                            Nam = Nam + 1;
                            Thang = Thang - 12;
                        }

                        if (Thang == 0 && Ngay == 0 && Nam != 0) //Trường hợp phạt tù chỉ có năm
                        {
                            //string strNgay = Ngay == 0 ? "" : Ngay + " ngày", strNgayNumber = Ngay == 0 ? "" : Cls_Comon.NumberToTextVN(Ngay) + " ngày",
                            //    strThang = Thang == 0 ? "" : Thang + " tháng", strThangNumber = Thang == 0 ? "" : Cls_Comon.NumberToTextVN(Thang) + " tháng",
                            //    strNam = Nam == 0 ? "" : Nam + "", strNamNumber = Nam == 0 ? "" : Cls_Comon.NumberToTextVN(Nam) + "";
                            //if (strThangNumber != "")
                            //{
                            //    strNamNumber += " ";
                            //}
                            //if (strNgayNumber != "")
                            //{
                            //    strThangNumber += " ";
                            //}
                            //strResult = strNam + " " + strThang + " " + strNgay + " (" + strNamNumber + strThangNumber + strNgayNumber + ") năm";
                            //strResult = strResult.Replace("đồng", "").Replace(",", "").Replace("0 năm 0 tháng ", "").Replace("0 năm ", "").Replace(" )", ")");
                            //if (IsQuyDoiThoiGian)
                            //{
                            //    strResult = (Nam * 12 * 360 + Thang * 30 + Ngay).ToString();
                            //}
                            //strResult = strResult + " tù";

                            string strNgay = Ngay == 0 ? "" : Ngay + "", strNgayNumber = Ngay == 0 ? "" : Cls_Comon.NumberToTextVN(Ngay) + "",
                                strThang = Thang == 0 ? "" : Thang + "", strThangNumber = Thang == 0 ? "" : Cls_Comon.NumberToTextVN(Thang) + "",
                                strNam = Nam == 0 ? "" : Nam + "", strNamNumber = Nam == 0 ? "" : Cls_Comon.NumberToTextVN(Nam) + "";

                            strResult = strNam + " (" + strNamNumber + ") năm";
                            strResult = strResult.Replace("đồng", "").Replace(",", "").Replace("0 năm 0 tháng ", "").Replace("0 năm ", "").Replace(" )", ")");
                            if (IsQuyDoiThoiGian)
                            {
                                strResult = (Nam * 12 * 360 + Thang * 30 + Ngay).ToString();
                            }
                            strResult = strResult + " tù";
                        }
                        else if(Ngay != 0 && Thang != 0 && Nam != 0) //Trường hợp phạt tù có ngày tháng năm
                        {
                            string strNgay = Ngay == 0 ? "" : Ngay + "", strNgayNumber = Ngay == 0 ? "" : Cls_Comon.NumberToTextVN(Ngay) + "",
                                strThang = Thang == 0 ? "" : Thang + "", strThangNumber = Thang == 0 ? "" : Cls_Comon.NumberToTextVN(Thang) + "",
                                strNam = Nam == 0 ? "" : Nam + "", strNamNumber = Nam == 0 ? "" : Cls_Comon.NumberToTextVN(Nam) + "";

                            strResult = strNam + " (" + strNamNumber + ") năm " + strThang + " (" + strThangNumber + ") tháng " + strNgay + " (" + strNgayNumber + ") ngày";
                            strResult = strResult.Replace("đồng", "").Replace(",", "").Replace("0 năm 0 tháng ", "").Replace("0 năm ", "").Replace(" )", ")");
                            if (IsQuyDoiThoiGian)
                            {
                                strResult = (Nam * 12 * 360 + Thang * 30 + Ngay).ToString();
                            }
                            strResult = strResult + " tù";
                        }
                        else if(Ngay == 0 && Thang != 0 && Nam != 0) //Trường hợp phạt tù có tháng và năm
                        {
                            string strNgay = Ngay == 0 ? "" : Ngay + "", strNgayNumber = Ngay == 0 ? "" : Cls_Comon.NumberToTextVN(Ngay) + "",
                                strThang = Thang == 0 ? "" : Thang + "", strThangNumber = Thang == 0 ? "" : Cls_Comon.NumberToTextVN(Thang) + "",
                                strNam = Nam == 0 ? "" : Nam + "", strNamNumber = Nam == 0 ? "" : Cls_Comon.NumberToTextVN(Nam) + "";

                            strResult = strNam + " (" + strNamNumber + ") năm " + strThang + " (" + strThangNumber + ") tháng";
                            strResult = strResult.Replace("đồng", "").Replace(",", "").Replace("0 năm 0 tháng ", "").Replace("0 năm ", "").Replace(" )", ")");
                            if (IsQuyDoiThoiGian)
                            {
                                strResult = (Nam * 12 * 360 + Thang * 30 + Ngay).ToString();
                            }
                            strResult = strResult + " tù";
                        }
                        else if (Ngay == 0 && Thang != 0 && Nam == 0) //Trường hợp phạt tù chỉ có tháng
                        {
                            string strNgay = Ngay == 0 ? "" : Ngay + "", strNgayNumber = Ngay == 0 ? "" : Cls_Comon.NumberToTextVN(Ngay) + "",
                                strThang = Thang == 0 ? "" : Thang + "", strThangNumber = Thang == 0 ? "" : Cls_Comon.NumberToTextVN(Thang) + "",
                                strNam = Nam == 0 ? "" : Nam + "", strNamNumber = Nam == 0 ? "" : Cls_Comon.NumberToTextVN(Nam) + "";

                            strResult = strThang + " (" + strThangNumber + ") tháng";
                            strResult = strResult.Replace("đồng", "").Replace(",", "").Replace("0 năm 0 tháng ", "").Replace("0 năm ", "").Replace(" )", ")");
                            if (IsQuyDoiThoiGian)
                            {
                                strResult = (Nam * 12 * 360 + Thang * 30 + Ngay).ToString();
                            }
                            strResult = strResult + " tù";
                        }
                        else if (Ngay != 0 && Thang == 0 && Nam == 0) //Trường hợp phạt tù chỉ có ngày
                        {
                            string strNgay = Ngay == 0 ? "" : Ngay + "", strNgayNumber = Ngay == 0 ? "" : Cls_Comon.NumberToTextVN(Ngay) + "",
                                strThang = Thang == 0 ? "" : Thang + "", strThangNumber = Thang == 0 ? "" : Cls_Comon.NumberToTextVN(Thang) + "",
                                strNam = Nam == 0 ? "" : Nam + "", strNamNumber = Nam == 0 ? "" : Cls_Comon.NumberToTextVN(Nam) + "";

                            strResult = strNgay + " (" + strNgayNumber + ") ngày";
                            strResult = strResult.Replace("đồng", "").Replace(",", "").Replace("0 năm 0 tháng ", "").Replace("0 năm ", "").Replace(" )", ")");
                            if (IsQuyDoiThoiGian)
                            {
                                strResult = (Nam * 12 * 360 + Thang * 30 + Ngay).ToString();
                            }
                            strResult = strResult + " tù";
                        }
                        else if (Ngay != 0 && Thang != 0 && Nam == 0) //Trường hợp phạt tù có ngày tháng
                        {
                            string strNgay = Ngay == 0 ? "" : Ngay + "", strNgayNumber = Ngay == 0 ? "" : Cls_Comon.NumberToTextVN(Ngay) + "",
                                strThang = Thang == 0 ? "" : Thang + "", strThangNumber = Thang == 0 ? "" : Cls_Comon.NumberToTextVN(Thang) + "",
                                strNam = Nam == 0 ? "" : Nam + "", strNamNumber = Nam == 0 ? "" : Cls_Comon.NumberToTextVN(Nam) + "";

                            strResult = strThang + " (" + strThangNumber + ") tháng " + strNgay + " (" + strNgayNumber + ") ngày";
                            strResult = strResult.Replace("đồng", "").Replace(",", "").Replace("0 năm 0 tháng ", "").Replace("0 năm ", "").Replace(" )", ")");
                            if (IsQuyDoiThoiGian)
                            {
                                strResult = (Nam * 12 * 360 + Thang * 30 + Ngay).ToString();
                            }
                            strResult = strResult + " tù";
                        }
                        else if (Ngay != 0 && Thang == 0 && Nam != 0) //Trường hợp phạt tù có ngày và năm
                        {
                            string strNgay = Ngay == 0 ? "" : Ngay + "", strNgayNumber = Ngay == 0 ? "" : Cls_Comon.NumberToTextVN(Ngay) + "",
                                strThang = Thang == 0 ? "" : Thang + "", strThangNumber = Thang == 0 ? "" : Cls_Comon.NumberToTextVN(Thang) + "",
                                strNam = Nam == 0 ? "" : Nam + "", strNamNumber = Nam == 0 ? "" : Cls_Comon.NumberToTextVN(Nam) + "";

                            strResult = strNam + " (" + strNamNumber + ") năm " + strNgay + " (" + strNgayNumber + ") ngày";
                            strResult = strResult.Replace("đồng", "").Replace(",", "").Replace("0 năm 0 tháng ", "").Replace("0 năm ", "").Replace(" )", ")");
                            if (IsQuyDoiThoiGian)
                            {
                                strResult = (Nam * 12 * 360 + Thang * 30 + Ngay).ToString();
                            }
                            strResult = strResult + " tù";
                        }
                    }
                }
            }
            if (strResult == "" && IsQuyDoiThoiGian)
            {
                strResult = "0";
            }
            return strResult.ToLower();
        }
        private string GetDieuKhoan(decimal BanAnID, decimal vVuAnID, decimal BiCaoID, string DonVi_TruyTo_XetXu)
        {
            string Temp = "";
            DataTable TblDieuKhoanToiDanh = null;
            if (DonVi_TruyTo_XetXu == VKS)
            {
                AHS_SOTHAM_CAOTRANG_DIEULUAT_BL CaoTrangDieuLuatBL = new AHS_SOTHAM_CAOTRANG_DIEULUAT_BL();
                TblDieuKhoanToiDanh = CaoTrangDieuLuatBL.GetAllToiDanhByBiCan(BiCaoID, vVuAnID);
            }
            else if (DonVi_TruyTo_XetXu == TOASOTHAM)
            {
                AHS_REPORT_BL oBL = new AHS_REPORT_BL();
                AHS_SOTHAM_BANAN_DIEU_CHITIET STDieuCT = dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Where(x => x.BANANID == BanAnID && x.BICANID == BiCaoID).FirstOrDefault();
                if (STDieuCT != null)// Lấy bộ luật ID
                {
                    TblDieuKhoanToiDanh = oBL.AHS_GETDIEUKHOAN_BICAO_ST((decimal)STDieuCT.DIEULUATID, BanAnID, BiCaoID);
                }
            }
            else
            {
                AHS_REPORT_BL oBL = new AHS_REPORT_BL();
                AHS_PHUCTHAM_BANAN_DIEU_CT STDieuCT = dt.AHS_PHUCTHAM_BANAN_DIEU_CT.Where(x => x.BANANID == BanAnID && x.BICANID == BiCaoID).FirstOrDefault();
                if (STDieuCT != null)// Lấy bộ luật ID
                {
                    TblDieuKhoanToiDanh = oBL.AHS_GETDIEUKHOAN_BICAO_PT((decimal)STDieuCT.DIEULUATID, BanAnID, BiCaoID);
                }
            }
            if (TblDieuKhoanToiDanh != null && TblDieuKhoanToiDanh.Rows.Count > 0)
            {
                string TempDiem = "", TempKhoan = "", TempDieu = "", sqlFilter = "";
                // Lấy danh sách các điều
                DataView viewToiDanh = new DataView(TblDieuKhoanToiDanh);
                DataTable distDieu = viewToiDanh.ToTable(true, "Dieu");
                foreach (DataRow r in distDieu.Rows)
                {
                    if (r["Dieu"] + "" != "")
                    {
                        sqlFilter = "Dieu='" + r["DIEU"] + "'"; TempKhoan = ""; TempDieu = "";
                        DataRow[] dtRow = TblDieuKhoanToiDanh.Select(sqlFilter);
                        DataTable dtTable = dtRow.CopyToDataTable();
                        DataView viewKhoan = dtTable.AsDataView();
                        DataTable distKhoan = viewKhoan.ToTable(true, "Khoan");
                        foreach (DataRow rKhoan in distKhoan.Rows)
                        {
                            if (rKhoan["Khoan"] + "" != "")
                            {
                                TempDiem = "";
                                sqlFilter = "Dieu='" + r["DIEU"] + "' and Khoan='" + rKhoan["Khoan"] + "'";
                                DataRow[] Diems = TblDieuKhoanToiDanh.Select(sqlFilter);
                                foreach (DataRow rDiem in Diems)
                                {
                                    if (rDiem["Diem"] + "" != "")
                                    {
                                        if (TempDiem == "")
                                        {
                                            TempDiem = rDiem["Diem"] + "";
                                        }
                                        else
                                        {
                                            TempDiem += ", " + rDiem["Diem"];
                                        }
                                    }
                                }
                                if (TempDiem == "")
                                {
                                    TempKhoan = "Khoản " + rKhoan["Khoan"];
                                }
                                else
                                {
                                    TempKhoan = "Điểm " + TempDiem + " Khoản " + rKhoan["Khoan"];
                                }
                            }
                            if (TempKhoan != "")
                            {
                                TempDieu = TempKhoan + " Điều " + r["Dieu"];
                            }
                        }
                        if (Temp == "")
                        { Temp = TempDieu; }
                        else { Temp += "; " + TempDieu; }
                    }
                }
            }
            return Temp;
        }
        //Khai them
        private string GetDieuKhoan04HS(decimal BanAnID, decimal vVuAnID, decimal BiCaoID, string DonVi_TruyTo_XetXu)
        {
            string Temp = "";
            DataTable TblDieuKhoanToiDanh = null;
            if (DonVi_TruyTo_XetXu == VKS)
            {
                AHS_SOTHAM_CAOTRANG_DIEULUAT_BL CaoTrangDieuLuatBL = new AHS_SOTHAM_CAOTRANG_DIEULUAT_BL();
                TblDieuKhoanToiDanh = CaoTrangDieuLuatBL.GetAllToiDanhByBiCan(BiCaoID, vVuAnID);
            }
            else if (DonVi_TruyTo_XetXu == TOASOTHAM)
            {
                AHS_REPORT_BL oBL = new AHS_REPORT_BL();
                AHS_SOTHAM_BANAN_DIEU_CHITIET STDieuCT = dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Where(x => x.BANANID == BanAnID && x.BICANID == BiCaoID).FirstOrDefault();
                if (STDieuCT != null)// Lấy bộ luật ID
                {
                    TblDieuKhoanToiDanh = oBL.AHS_GETDIEUKHOAN_BICAO_ST((decimal)STDieuCT.DIEULUATID, BanAnID, BiCaoID);
                }
            }
            else
            {
                AHS_REPORT_BL oBL = new AHS_REPORT_BL();
                AHS_PHUCTHAM_BANAN_DIEU_CT STDieuCT = dt.AHS_PHUCTHAM_BANAN_DIEU_CT.Where(x => x.BANANID == BanAnID && x.BICANID == BiCaoID).FirstOrDefault();
                if (STDieuCT != null)// Lấy bộ luật ID
                {
                    TblDieuKhoanToiDanh = oBL.AHS_GETDIEUKHOAN_BICAO_PT((decimal)STDieuCT.DIEULUATID, BanAnID, BiCaoID);
                }
            }
            if (TblDieuKhoanToiDanh != null && TblDieuKhoanToiDanh.Rows.Count > 0)
            {
                string TempDiem = "", TempKhoan = "", TempDieu = "", sqlFilter = "";
                // Lấy danh sách các điều
                DataView viewToiDanh = new DataView(TblDieuKhoanToiDanh);
                DataTable distDieu = viewToiDanh.ToTable(true, "Dieu");
                foreach (DataRow r in distDieu.Rows)
                {
                    if (r["Dieu"] + "" != "")
                    {
                        sqlFilter = "Dieu='" + r["DIEU"] + "'"; TempKhoan = ""; TempDieu = "";
                        DataRow[] dtRow = TblDieuKhoanToiDanh.Select(sqlFilter);
                        DataTable dtTable = dtRow.CopyToDataTable();
                        DataView viewKhoan = dtTable.AsDataView();
                        DataTable distKhoan = viewKhoan.ToTable(true, "Khoan");
                        foreach (DataRow rKhoan in distKhoan.Rows)
                        {
                            if (rKhoan["Khoan"] + "" != "")
                            {
                                TempDiem = "";
                                sqlFilter = "Dieu='" + r["DIEU"] + "' and Khoan='" + rKhoan["Khoan"] + "'";
                                DataRow[] Diems = TblDieuKhoanToiDanh.Select(sqlFilter);
                                foreach (DataRow rDiem in Diems)
                                {
                                    if (rDiem["Diem"] + "" != "")
                                    {
                                        if (TempDiem == "")
                                        {
                                            TempDiem = rDiem["Diem"] + "";
                                        }
                                        else
                                        {
                                            TempDiem += ", " + "điểm " + rDiem["Diem"];
                                        }
                                    }
                                }
                                if (TempDiem == "")
                                {
                                    TempKhoan = "khoản " + rKhoan["Khoan"];
                                }
                                else
                                {
                                    TempKhoan = "điểm " + TempDiem + " khoản " + rKhoan["Khoan"];
                                }
                            }
                            if (TempKhoan != "")
                            {
                                TempDieu += TempKhoan + ", ";
                            }
                        }
                        
                        if (TempKhoan != "")
                        {
                            TempDieu = TempDieu.Remove(TempDieu.Length - 2, 2);
                            TempDieu = TempDieu + " Điều " + r["Dieu"];
                        }

                        if (Temp == "")
                        {
                            Temp = TempDieu;
                        }
                        else
                        {
                            Temp += "; " + TempDieu;
                        }
                    }
                }
            }
            return Temp;
        }
        private String FillDSThamPhanThanhVien_AHS_ST(List<AHS_SOTHAM_HDXX> lstHD, bool IsQuanSu)
        {
            string strResult = "", strGioiTinh = "";
            List<AHS_SOTHAM_HDXX> lst = lstHD.Where(x => x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHANHDXX).ToList();
            DM_CANBO oCanbo; DM_DATAITEM oChucVu;
            foreach (AHS_SOTHAM_HDXX oT in lst)
            {
                oCanbo = dt.DM_CANBO.Where(x => x.ID == oT.CANBOID).FirstOrDefault();
                if (oCanbo != null)
                {
                    if (IsQuanSu)
                    {
                        oChucVu = dt.DM_DATAITEM.Where(x => x.ID == oCanbo.CHUCVUID).FirstOrDefault();
                        if (oChucVu != null)
                        {
                            if (strResult == "")
                            {
                                strResult = oChucVu.TEN + " " + oCanbo.HOTEN;
                            }
                            else { strResult += "; " + oChucVu.TEN + " " + oCanbo.HOTEN; }
                        }
                    }
                    else
                    {
                        if (oCanbo.GIOITINH == 1)
                            strGioiTinh = "Ông ";
                        else
                            strGioiTinh = "Bà ";
                        if (strResult == "")
                        {
                            strResult = strGioiTinh + oCanbo.HOTEN;
                        }
                        else { strResult += "; " + strGioiTinh + oCanbo.HOTEN; }
                    }
                }
            }
            return strResult;
        }
        private String FillDSThamPhanThanhVien_AHS_PT(List<AHS_PHUCTHAM_HDXX> lstHD, bool IsQuanSu)
        {
            string strResult = "", strGioiTinh = "";
            List<AHS_PHUCTHAM_HDXX> lst = lstHD.Where(x => x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHANHDXX).ToList();
            DM_CANBO oCanbo; DM_DATAITEM oChucVu;
            foreach (AHS_PHUCTHAM_HDXX oT in lst)
            {
                oCanbo = dt.DM_CANBO.Where(x => x.ID == oT.CANBOID).FirstOrDefault();
                if (oCanbo != null)
                {
                    if (IsQuanSu)
                    {
                        oChucVu = dt.DM_DATAITEM.Where(x => x.ID == oCanbo.CHUCVUID).FirstOrDefault();
                        if (oChucVu != null)
                        {
                            if (strResult == "")
                            {
                                strResult = oChucVu.TEN + " " + oCanbo.HOTEN;
                            }
                            else { strResult += "; " + oChucVu.TEN + " " + oCanbo.HOTEN; }
                        }
                    }
                    else
                    {
                        if (oCanbo.GIOITINH == 1)
                            strGioiTinh = "Ông ";
                        else
                            strGioiTinh = "Bà ";
                        if (strResult == "")
                        {
                            strResult = strGioiTinh + oCanbo.HOTEN;
                        }
                        else { strResult += "; " + strGioiTinh + oCanbo.HOTEN; }
                    }
                }
            }
            return strResult;
        }
        private String FillDSThamPhanHTND_AHS_ST(List<AHS_SOTHAM_HDXX> lstHD, bool IsQuanSu)
        {
            string strResult = "", strGioiTinh = "";
            List<AHS_SOTHAM_HDXX> lst = lstHD.Where(x => x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.HTND).ToList();
            DM_CANBO oCanbo; DM_DATAITEM oChucVu;
            foreach (AHS_SOTHAM_HDXX oT in lst)
            {
                oCanbo = dt.DM_CANBO.Where(x => x.ID == oT.CANBOID).FirstOrDefault();
                if (oCanbo != null)
                {
                    if (IsQuanSu)
                    {
                        oChucVu = dt.DM_DATAITEM.Where(x => x.ID == oCanbo.CHUCVUID).FirstOrDefault();
                        if (oChucVu != null)
                        {
                            if (strResult == "")
                            {
                                strResult = oChucVu.TEN + " " + oCanbo.HOTEN;
                            }
                            else { strResult += "; " + oChucVu.TEN + " " + oCanbo.HOTEN; }
                        }
                    }
                    else
                    {
                        if (oCanbo.GIOITINH == 1)
                            strGioiTinh = "Ông ";
                        else
                            strGioiTinh = "Bà ";
                        if (strResult == "")
                        {
                            strResult = strGioiTinh + oCanbo.HOTEN;
                        }
                        else { strResult += "; " + strGioiTinh + oCanbo.HOTEN; }
                    }
                }
            }
            return strResult;
        }
        private String FillDSThamPhanHTND_AHS_PT(List<AHS_PHUCTHAM_HDXX> lstHD, bool IsQuanSu)
        {
            string strResult = "", strGioiTinh = "";
            List<AHS_PHUCTHAM_HDXX> lst = lstHD.Where(x => x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.HTND).ToList();
            DM_CANBO oCanbo; DM_DATAITEM oChucVu;
            foreach (AHS_PHUCTHAM_HDXX oT in lst)
            {
                oCanbo = dt.DM_CANBO.Where(x => x.ID == oT.CANBOID).FirstOrDefault();
                if (oCanbo != null)
                {
                    if (IsQuanSu)
                    {
                        oChucVu = dt.DM_DATAITEM.Where(x => x.ID == oCanbo.CHUCVUID).FirstOrDefault();
                        if (oChucVu != null)
                        {
                            if (strResult == "")
                            {
                                strResult = oChucVu.TEN + " " + oCanbo.HOTEN;
                            }
                            else { strResult += "; " + oChucVu.TEN + " " + oCanbo.HOTEN; }
                        }
                    }
                    else
                    {
                        if (oCanbo.GIOITINH == 1)
                            strGioiTinh = "Ông ";
                        else
                            strGioiTinh = "Bà ";
                        if (strResult == "")
                        {
                            strResult = strGioiTinh + oCanbo.HOTEN;
                        }
                        else { strResult += "; " + strGioiTinh + oCanbo.HOTEN; }
                    }
                }
            }
            return strResult;
        }

        
    }
}