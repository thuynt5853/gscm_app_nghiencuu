using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Module.Common
{
    /// <summary>
    /// hoạt động người dùng đơn khởi kiện
    /// </summary>
    public class ENUM_HD_NGUOIDUNG_DKK
    {
        public const string DANGNHAP = "LOGIN";
        public const string DANGXUAT = "LOGOUT";
        public const string LOCK_ACCOUNT = "LOCK_ACCOUNT";
        public const string ACTIVE_ACCOUNT = "ACTIVE_ACCOUNT";

        public const string GUIDONKKMOI = "GUIDONKKMOI";
        public const string SAVEDONKK = "SAVEDONKK";
        public const string GUIBOSUNGDONKK = "GUIBOSUNGDONKK";
        public const string XOADONKK = "XOADONKK";

        public const string THEM = "THEM";
        public const string SUA = "SUA";
        public const string XOA = "XOA";

        public const string THEMDUONGSU = "THEMDUONGSU";
        public const string SUADUONGSU = "SUADUONGSU";
        public const string XOADUONGSU = "XOADUONGSU";

        public const string THEMTAILIEU = "THEMTAILIEU";
        public const string XOATAILIEU = "XOATAILIEU";

        public const string DKNHANVB = "DKNHANVB";
        public const string XOADKNHANVB = "XOADKNHANVB";
        public const string LOCKDKNHANVB = "LOCKDKNHANVB";
        public const string UNLOCKDKNHANVB = "UNLOCKDKNHANVB";
        public const string NHANVB = "NHANVB";
    }
    public class ENUM_CONNECTION
    {
        public const string DonKhoiKien = "DKKConnection";
        public const string ThongKe = "ThongKeConnection";
        public const string GSTP = "GSTPConnection";
    }
    public class ENUM_MAQUOCTICH
    {
        public const string VIETNAM = "VN";
    }
    public class ENUM_LOAITHONGBAO_QH
    {
        public const Decimal TBTINHTHE = 1;
        public const Decimal TBKQTRALOI = 2;
        public const Decimal TRALOIDON_AHS = 3;
        public const Decimal TRALOIDON_ADS = 4;
    }
    public class ENUM_QH_NHANTHAN
    {
        public const string BO = "BO";
        public const string ME = "ME";
        public const string ANH = "ANH";
        public const string CHI = "CHI";
        public const string EM = "EM";
        public const string VO_CHONG = "VO_CHONG";
        public const string CON = "CON";
    }
    public class ENUM_CHUCDANH
    {
        public const string CHUCDANH_THAMPHAN = "TP";
        public const string CHUCDANH_THAMPHANTOICAO = "TPTATC";
        public const string CHUCDANH_THUKY = "TK";
        public const string CHUCDANH_HTND = "HTND";
        public const string CHUCDANH_TTV = "TTV";
        public const string CHUCDANH_KSV = "KSV";
        public const string CHUCDANH_LTV = "LTV";
        public const string CHUCDANH_HGV = "HGV";
        public const string CHUCDANH_THAMPHAN_BAC3 = "TPBAC3";
    }
    public class ENUM_NHOMHINHPHAT
    {
        public const string NHOM_HPCHINH = "NHOMHINHPHAT_CHINH";
        public const string NHOM_HPBOSUNG = "NHOMHINHPHAT_BOSUNG";
        public const string NHOM_QDKHAC = "NHOMHINHPHAT_QDKHAC";
    }
    public class ENUM_LOAIHINHPHAT
    {
        public const int DANG_TRUE_FALSE_VALUE = 1;
        public const int DANG_THOI_GIAN_VALUE = 2;
        public const int DANG_SO_HOC_VALUE = 3;
        public const int DANG_KHAC_VALUE = 4;
        public const int DEFAULT_TRUE = 5;

        //public const String DANG_TRUE_FALSE_TEXT = "Có / Không";
        //public const String DANG_THOI_GIAN_TEXT = "Thời gian";
        //public const String DANG_SO_HOC_TEXT = "Số học";
        //public const String DANG_KHAC_TEXT = "Khác";
    }
    public class ENUM_HINHPHAT
    {
        public const String TU_HINH = "TUHINH";
        public const String TU_CHUNGTHAN = "TUCHUNGTHAN";
    }
    public class ENUM_TINHTRANGGIAMGIU
    {
        public const string TAMGIAM = "84";
        public const string DANGTAINGOAI = "85";
        public const string DANGBOTRON = "86";
        public const string DANGTAMGIAM_VUANKHAC = "87";
    }

    public class ENUM_AHS_BPNGANCHAN
    {
        public const string TAMGIAM = "BPNC_03";
    }


    public class ENUM_LOAI_QD_AHS
    {
        public const string BAT_TAMGIAM = "BTG";
    }
    public class ENUM_CHUCVU
    {
        public const string CHUCVU_CA = "CA";//Chánh án
        public const string CHUCVU_PCA = "PCA";//Phó chánh án
        public const string CHUCVU_VT = "VT";//Vụ trưởng
        public const string CHUCVU_PVT = "PVT";//Phó vụ trưởng
        public const string TP = "TP";//Thẩm phán
        public const string TPSC = "TPSC";//Thẩm phán sơ cấp
        public const string TPTC = "TPTC";//Thẩm phán trung cấp
        public const string TPCC = "TPCC";//Thẩm phán cao cấp 
        public const string TPTATC = "TPTATC";//Thẩm phán tòa án tối cao


    }
    public class ENUM_GIAIDOANVUAN
    {
        public const int HOSO = 1; //anhvh bỏ giai đoạn hồ sơ đi và add nó cùng = sơ thẩm; sua noi dung hien thanh: Tiếp nhận và xử lý (AHS:: Hồ sơ vụ án)
        public const int SOTHAM = 2;
        public const int PHUCTHAM = 3;
        public const int THULYGDT = 4;
        public const int DINHCHI = 5;
        public const int THULYTT = 6; //anhvh add vì hiện tại chưa dùng đến cấp này
        public const int PHUCTHAM_QDK = 7;
    }
    public class ENUM_AHS_TRANGTHAIGIAONHAN_HS
    {
        public const string VKSGiaoHSXuSoTham = "1";
        public const string VKSChapNhanDieuTraBoSung = "2";
        public const string VKSKoChapNhanDieuTraBoSung = "3";
    }

    public class ENUM_AHS_TUCACHTHAMGIATT
    {
        public const string BIHAI = "TGTTHS_01";
        public const string LUATSU = "TGTTHS_06";
        public const string BAOVEQUYENLOIDUONGSU = "TGTTHS_10";
        public const string BAOCHUAKHAC = "TGTTHS_17";
        public const string BICANDAUVU = "BICANDAUVU";
        public const string BICAN = "BICAN";
        // public const string VKSChapNhanDieuTraBoSung = "2";
        //public const string VKSKoChapNhanDieuTraBoSung = "3";
    }

    public class ENUM_AKT_BIENPHAPGQ
    {
        public const string AKT_ChuyenDonTrongNganh = "1";
        public const string AKT_ChuyenDonNgoaiNganh = "2";
        public const string AKT_TraLaiDon = "3";
        public const string AKT_YCBoSungDon = "4";
        public const string AKT_ThuLy = "5";
        public const string AKT_DonTrung = "6";
    }
    public class ENUM_ADS_BIENPHAPGQ
    {
        public const string ADS_ChuyenDonTrongNganh = "1";
        public const string ADS_ChuyenDonNgoaiNganh = "2";
        public const string ADS_TraLaiDon = "3";
        public const string ADS_YCBoSungDon = "4";
        public const string ADS_ThuLy = "5";
        public const string ADS_DonTrung = "6";
    }
    public class ENUM_ALD_BIENPHAPGQ
    {
        public const string ALD_ChuyenDonTrongNganh = "1";
        public const string ALD_ChuyenDonNgoaiNganh = "2";
        public const string ALD_TraLaiDon = "3";
        public const string ALD_YCBoSungDon = "4";
        public const string ALD_ThuLy = "5";
        public const string ALD_DonTrung = "6";
    }

    public class ENUM_LOAIVUVIEC
    {
        public const string AN_HINHSU = "01";
        public const string AN_DANSU = "02";
        public const string AN_HONNHAN_GIADINH = "03";
        public const string AN_KINHDOANH_THUONGMAI = "04";
        public const string AN_LAODONG = "05";
        public const string AN_HANHCHINH = "06";
        public const string AN_PHASAN = "07";
        public const string BPXLHC = "08";
        public const string AN_GDTTT = "09";
        public const string AN_THA = "10";
    }

    public class ENUM_STR_LOAIVUVIEC
    {
        public const string AN_HINHSU = "hình sự";
        public const string AN_DANSU = "dân sự";
        public const string AN_HONNHAN_GIADINH = "hôn nhân gia đình";
        public const string AN_KINHDOANH_THUONGMAI = "kinh doanh thương mại";
        public const string AN_LAODONG = "lao động";
        public const string AN_HANHCHINH = "hành chính";
        public const string AN_PHASAN = "phá sản";
        public const string BPXLHC = "biện pháp xử lý hành chính";
        public const string AN_GDTTT = "giám đốc thẩm, tái thẩm";
        public const string AN_THA = "thi hành án";
    }

    public class ENUM_BAOCAO_THONGKE
    {
        public const string BAOCAOCHITIEUVEDONTHEOKY_LOAIAN = "bctk_tla";
        public const string BAOCAOCHITIEUVEDONTHEOKY_THAMPHAN = "bctk_ttp";
    }
    public class ENUM_LOAIVUVIEC_NUMBER
    {
        public const string AN_HINHSU = "1";
        public const string AN_DANSU = "2";
        public const string AN_HONNHAN_GIADINH = "3";
        public const string AN_KINHDOANH_THUONGMAI = "4";
        public const string AN_LAODONG = "5";
        public const string AN_HANHCHINH = "6";
        public const string AN_PHASAN = "7";
        public const string BPXLHC = "8";
        public const string AN_GDTTT = "9";
        public const string AN_THA = "10";
    }

    public class ENUM_LOAIVUVIEC_TEXT
    {
        public const string AN_HINHSU = "AHS";
        public const string AN_DANSU = "ADS";
        public const string AN_HONNHAN_GIADINH = "AHN";
        public const string AN_KINHDOANH_THUONGMAI = "AKT";
        public const string AN_LAODONG = "ALD";
        public const string AN_HANHCHINH = "AHC";
    }

    public class ENUM_LOAIAN
    {
        public const string AN_HINHSU = "AN_HINHSU";
        public const string AN_DANSU = "AN_DANSU";
        public const string HG_AN_DANSU = "HG_AN_DANSU";
        public const string AN_HONNHAN_GIADINH = "AN_HNGD";
        public const string HG_AN_HONNHAN_GIADINH = "HG_AN_HNGD";
        public const string AN_KINHDOANH_THUONGMAI = "AN_KDTM";
        public const string HG_AN_KINHDOANH_THUONGMAI = "HG_AN_KDTM";
        public const string AN_LAODONG = "AN_LAODONG";
        public const string HG_AN_LAODONG = "HG_AN_LAODONG";
        public const string AN_HANHCHINH = "AN_HANHCHINH";
        public const string HG_AN_HANHCHINH = "HG_AN_HANHCHINH";
        public const string AN_GSTP = "GSTP";
        public const string AN_PHASAN = "AN_PHASAN";
        public const string BPXLHC = "BPXLHC";
        public const string PCTT = "PCTP";
        public const string AN_GDTTT = "AN_GDTTT";
        public const string AN_THA = "THA";
        public const string AN_DA_KET_THUC = "AN_DA_KET_THUC";
    }
    public class ENUM_AHS_LOAITOIPHAM
    {
        public const string CHUAXACDINH = "LTP00";
        public const string IT_NGHIEMTRONG = "LTP01";
        public const string NGHIEMTRONG = "LTP02";
        public const string RAT_NGHIEMTRONG = "LTP03";
        public const string DACBIET_NGHIEMTRONG = "LTP04";
    }

    public class ENUM_DANHMUC
    {
        public const string DANTOC = "DANTOC";
        public const string QUOCTICH = "QUOCTICH";
        public const string TONGIAO = "TONGIAO";
        public const string LOAITOIPHAM = "LOAITOIPHAM";
        public const string QUANHEPL_YEUCAU = "QHPLYEUCAU";
        public const string QUANHEPL_TRANHCHAP = "QHPLTRANHCHAP";
        public const string QUANHEPL_YEUCAU_HNGD = "QHPLYEUCAUHNGD";
        public const string QUANHEPL_TRANHCHAP_HNGD = "QHPLTRANHCHAPHNGD";
        public const string QUANHEPL_YEUCAU_KDTM = "QHPLYEUCAUKDTM";
        public const string QUANHEPL_TRANHCHAP_KDTM = "QHPLTRANHCHAPKDTM";
        public const string QUANHEPL_YEUCAU_LD = "QHPLYEUCAULD";
        public const string QUANHEPL_TRANHCHAP_LD = "QHPLTRANHCHAPLD";
        public const string QUANHEPL_KHIEUKIEN_HC = "QHPLKHIEUKIENHC";
        public const string QUANHEPL_YEUCAUPS = "QHPLYEUCAUPS";
        public const string QUANHEPL_DENGHI_XLHC = "QHPL_DENGHI_XLHC";
        public const string LYDOLYHON = "LYDOLYHON";
        public const string TUCACHTOTUNG_DS = "TUCACHTOTUNG";
        public const string TUCACHTOTUNGPS = "TUCACHTOTUNGPS";
        public const string CHUCDANH = "CHUCDANH";
        public const string CHUCVU = "CHUCVU";
        public const string CHUCVUVKS = "CHUCVUVKS";
        public const string VAITROTHAMPHAN = "VAITROTHAMPHAN";
        public const string VAITROTHAMPHAN_BP_XLHC = "VAITROTHAMPHAN_BP_XLHC";
        public const string LOAITOA = "LOAITOA";
        public const string LOAIVIENKIEMSOAT = "LOAIVIENKIEMSOAT";
        public const string TUCACHTGTTDS = "TUCACHTGTTDS";
        public const string TUCACHTGTTPS = "TUCACHTGTTPS";
        public const string TUCACHTGTTHS = "TUCACHTGTTHS";
        public const string TUCACHTGTTBPXLHC = "TUCACHTGTTBPXLHC";
        public const string BIENPHAPNGANCHAN = "BIENPHAPNGANCHAN";
        public const string KETLUANDONGDTTT = "KLGIAIQUYETDONGDTT";
        public const string LOAIAN = "LOAIAN";
        //---------chua lam quan ly dm--------------
        public const string TRINHDOVANHOA = "TRINHDOVANHOA";
        public const string QUYETDINHCAOTRANG = "QUYETDINHCAOTRANG";
        public const string TINHTRANGGIAMGIU = "TINHTRANGGIAMGIU";
        public const string NGHENGHIEP = "NGHENGHIEP";
        public const string CHUCVUDANG = "CHUCVUDANG";
        public const string NHOMHINHPHAT = "NHOMHINHPHAT";
        public const string LOAIDONVIQDNGANCHAN = "LOAIDONVIQDNGANCHAN";
        public const string TRUONGHOPTHULYAN = "TRUONGHOPTHULYAN";
        public const string NOIDUNGTHULYXXL = "NOIDUNGTHULYXXL";
        public const string TRUONGHOP_GIAONHAN = "TRUONGHOP_GIAONHAN";
        public const string YEUCAUKCHINHSU = "YEUCAUKCHINHSU";
        public const string YEUCAUKNHINHSU = "YEUCAUKNHINHSU";
        public const string LYDOTRADON = "LYDOTRADON";
        public const string LYDOTRADONHC = "LYDOTRADONHC";
        public const string CAPTHAMPHAN = "	CAPTHAMPHAN";
        public const string LOAIUYQUYEN = "LOAIUYQUYEN";
        public const string KETLUANGDTTT = "KETLUANGDTTT";
        public const string QH_NHAN_THAN = "QH_NHAN_THAN";
        public const string LOAIQD_HC = "LOAIQD_HC";
        public const string DMLOAITOIPHAMHS = "DMLOAITOIPHAMHS";
        public const string LOAITHULY_AHS_PT = "LOAITHULY_AHS_PT";

        //------------------DM dung trong thi hanh an---------------
        public const string THA_YEUCAUTHULY = "THA_YEUCAUTHULY";
        public const string THA_LYDOTHULY = "THA_LYDOTHULY";
        public const string DOITUONGNOPYCPS = "DOITUONGNOPYCPS";
        public const string QUYETDINH_TB_THA = "QUYETDINH_TB_THA";
        //---------------
        public const string UYTHACTHA_LyDo = "UYTHACTHA_LyDo";

        // --- DM dùng trong GDTTTT
        public const string LOAICVGDTTT = "LOAICVGDTTT";
        public const string DONVIUUTIEN = "DONVIUUTIEN";
        public const string PHANLOAIKNTC = "PHANLOAIKNTC";
        public const string NGUOIKHANGNGHI = "NGUOIKHANGNGHI";
        // --- DM dùng trong TĐKT
        public const string DM_HINHTHUC_KHENTHUONG = "DM_HINHTHUC_KHENTHUONG";
        public const string DM_HINHTHUC_KYLUAT = "DM_HINHTHUC_KYLUAT";
        public const string DM_DANHHIEU_THIDUA = "DM_DANHHIEU_THIDUA";
        public const string DM_LOAIHINH_KHENTHUONG = "DM_LOAIHINH_KHENTHUONG";
        public const string BIEU_MAU_TDKT = "BIEU_MAU_TDKT";
        //--- DM dùng trong hoà giải
        public const string LYDO_HOAGIAI_KHONGTHANH = "LYDO_HOAGIAI_KHONGTHANH";
        public const string HGDT_HGT = "HGDT-HGT";
        public const string HGDT_HGKT = "HGDT-HGKT";

        //--- DM dùng trong tách nhập
        public const string LOAISAPNHAP = "LOAISAPNHAP"; // Loại sáp nhập 

        //--- DM dùng trong bàn giao án
        public const string LYDOBANGIAOAN = "LYDOBANGIAOAN"; // Lý do bàn giao án
        public const string TRANGTHAIBANGIAOAN = "TRANGTHAIBANGIAOAN"; // Trạng thái bàn giao án

        //-- DM dùng cho bị án
        public const string AHS_TINHTRANGBIAN = "AHS_TINHTRANGBIAN";
    }
    public class ENUM_SESSION
    {
        public const string SESSION_USERID = "USERID";
        public const string SESSION_USERNAME = "USERNAME";
        public const string SESSION_USERTEN = "USERTEN";
        public const string SESSION_NHOMNSDID = "NHOMNSDID";
        public const string SESSION_DONVIID = "DONVIID";
        public const string SESSION_LOAIUSER = "LOAIUSER";
        public const string SESSION_MACANBO = "MACANBO";
        public const string SESSION_MADONVI = "DONVI_MA";
        public const string SESSION_TENDONVI = "DONVI_TEN";
        public const string SESSION_TINH_ID = "TINHID";
        public const string SESSION_QUAN_ID = "QUANID";
        public const string SESSION_CANBOID = "CANBO_ID";
        public const string SESSION_PHONGBANID = "PHONGBANID";
        //-----------dung trong DonKK--------------------
        public const string SESSION_MUCDICHSD = "MUCDICH_SD";
        public const string SESSION_ISPHANLOAIDON = "ISPHANLOAIDON";
        //---------------
        public const string SESSION_YEARS_TK = "YEARS_TK";
        /// <summary>
        /// Luu thong tin du lieu nguoi dung luc SSO ve
        /// </summary>
        public const string SESSION_DVCQG_USER_INFO = "DVCQG_USER_INFO";
        public const string SESSION_GIAI_DOAN = "GIAI_DOAN_VUAN";

        public const string RSA = "RSA";
        public const string TROLYAOINFOR = "TROLYAOINFOR";
    }

    public class ENUM_THA_VUAN
    {
        public const string SESSION_BA_ST_SO = "BA_ST_SO";
        public const string SESSION_BA_ST_NGAYBANAN = "BA_ST_NGAYBANAN";
        public const string SESSION_BA_ST_TOAANID = "BA_ST_TOAANID";
        public const string SESSION_BA_PT_SO = "BA_PT_SO";
        public const string SESSION_BA_PT_NGAYBANAN = "BA_PT_NGAYBANAN";
        public const string SESSION_BA_PT_TOAANID = "BA_PT_TOAANID";
        public const string SESSION_BA_TENVUAN = "BA_TENVUAN";
        public const string SESSION_BA_TINHCHAT = "BA_TINHCHAT";
        public const string SESSION_ISHETHONG = "ISHETHONG";
        public const string SESSION_IDVUANHETHONG = "IDVUANHETHONG";
        public const string SESSION_BA_NGAYVUAN = "BA_NGAYVUAN";
        public const string SESSION_BA_THANG = "BA_THANG";
        public const string SESSION_BA_NAM = "BA_NAM";
        public const string SESSION_TT = "TT";
        public const string SESSION_BA_MAVUAN = "BA_MAVUAN";
        public const string SESSION_DDLGDXX = "DDLGDXX";
        public const string SESSION_NGAYXAYRA = "NGAYXAYRA";
        public const string SESSION_IDVUANTHA = "IDVUANTHA";
    }

    public class ENUM_LOAI_TRIEUTAP
    {
        public const string DUONGSU = "DUONGSU";
        public const string NGUOITHAMGIATOTUNG = "NGUOITHAMGIATOTUNG";
        public const string BICANBICAO = "BICANBICAO";
    }


    public class ENUM_DANSU_TUCACHTOTUNG
    {

        public const string NGUYENDON = "NGUYENDON";
        public const string NGUOIYEUCAUPS = "NGUOIYEUCAUPS";
        public const string BIDON = "BIDON";
        public const string QUYENNVLQ = "QUYENNVLQ";
        public const string UYQUYEN = "UYQUYEN";
        public const string KHAC = "KHAC";
        public const string NGUOILAMCHUNG = "NGUOILAMCHUNG";
        public const string QUYENLOIICHDUOCBAOVE = "QUYENLOIICHDUOCBAOVE";

        //-------muc nay chi dung trong DonKK---------
        public const string NGUOIUYQUYEN = "NGUOIUYQUYEN";

        //án hình sự
        public const string BICAO = "BICAO";
    }
    public class ENUM_HANHCHINH_TUCACHTOTUNG
    {

        public const string NGUYENDON = "NGUYENDON";
        public const string NGUOIYEUCAUPS = "NGUOIYEUCAUPS";
        public const string BIDON = "BIDON";
        public const string QUYENNVLQ = "QUYENNVLQ";
        public const string UYQUYEN = "UYQUYEN";
        public const string KHAC = "KHAC";
        public const string NGUOILAMCHUNG = "NGUOILAMCHUNG";
        public const string QUYENLOIICHDUOCBAOVE = "QUYENLOIICHDUOCBAOVE";

        //-------muc nay chi dung trong DonKK---------
        public const string NGUOIUYQUYEN = "NGUOIUYQUYEN";
    }
    public class ENUM_LAODONG_TUCACHTOTUNG
    {

        public const string NGUYENDON = "NGUYENDON";
        public const string NGUOIYEUCAUPS = "NGUOIYEUCAUPS";
        public const string BIDON = "BIDON";
        public const string QUYENNVLQ = "QUYENNVLQ";
        public const string UYQUYEN = "UYQUYEN";
        public const string KHAC = "KHAC";
        public const string NGUOILAMCHUNG = "NGUOILAMCHUNG";
        public const string QUYENLOIICHDUOCBAOVE = "QUYENLOIICHDUOCBAOVE";

        //-------muc nay chi dung trong DonKK---------
        public const string NGUOIUYQUYEN = "NGUOIUYQUYEN";
    }
    public class ENUM_PHASAN_TUCACHTOTUNG
    {

        public const string NGUOIYEUCAUPS = "NGUOIYEUCAUPS";

        public const string NGUOICOQLNVLQPS = "NGUOICOQLNVLQPS";
        public const string DNHTXBITUYENBOPS = "DNHTXBITUYENBOPS";
    }
    public class ENUM_VAITROTHAMPHAN
    {
        public const string VTTP_GIAIQUYETDON = "VTTP_GIAIQUYETDON";
        public const string VTTP_GIAIQUYETSOTHAM = "VTTP_GIAIQUYETSOTHAM";
        public const string VTTP_GIAIQUYETPHUCTHAM = "VTTP_GIAIQUYETPHUCTHAM";
        public const string VTTP_CHUTOASOTHAM = "VTTP_CHUTOASOTHAM";
        public const string TP_GIAIQUYETHOAGIAI = "TP_GIAIQUYETHOAGIAI";
    }
    public class ENUM_VAITROTHAMPHAN_TIMKIEM
    {
        public const string VTTP_GIAIQUYETDON = "VTTP_GIAIQUYETDON";
        public const string VTTP_GIAIQUYETVUVIEC = "VTTP_GIAIQUYETVUVIEC";
        public const string CHUTOAPHIENTOA = "CHUTOAPHIENTOA";
        public const string THAMPHANHDXX = "THAMPHANHDXX";
        public const string THAMPHANDUKHUYET = "THAMPHANDUKHUYET";
        public const string VTTP_HOAGIAI = "VTTP_HOAGIAI";
        public const string VTTP_GIAIQUYETSOTHAM = "VTTP_GIAIQUYETSOTHAM";
    }
    public class ENUM_NGUOITIENHANHTOTUNG
    {
        public const string THAMPHAN = "THAMPHAN";
        public const string THAMPHANHDXX = "THAMPHANHDXX";
        public const string THAMPHANDUKHUYET = "THAMPHANDUKHUYET";
        public const string HTND = "HTND";
        public const string THUKY = "THUKY";
        public const string THUKYDUKHUYET = "THUKYDUKHUYET";
        public const string KIEMSOATVIEN = "KIEMSOATVIEN";
        public const string KIEMSATVIEN = "KSV";
        public const string THAMTRAVIEN = "THAMTRAVIEN";
    }
    public class ENUM_DS_TRANGTHAI
    {
        public const int TAOMOI = 1;
        public const int TRALAIDON = 2;
        public const int BOSUNGDON = 3;
        public const int NOPDUPHI = 4;
        public const int THULY = 5;
        public const int HOAGIAI = 6;
        public const int XETXUSOTHAM = 7;
    }

    public class ENUM_TRUONGHOP_GIAONHAN
    {
        public const string KHONGTHUOC_THAMQUYEN_XETXU = "01";
        public const string KHANGCAO_PHUCTHAM = "02";
        public const string KHANGCAO_KHANGNGHI_PHUCTHAM = "03";
        public const string KHANGNGHI_PHUCTHAM = "04";
        public const string XETXULAI_CAPSOTHAM = "05";
        public const string KHONGTHUOC_THAMQUYEN_GIAIQUYET = "06";
        public const string KHIEUNAI_PHUCTHAM = "07";
        public const string KHIEUNAI_KHANGNGHI_PHUCTHAM = "08";
        public const string CHUYENYEUCAU_VE_SOTHAM = "09";
        public const string GDT_CHUYEN_VE = "10";
        public const string TOA_CAPCAO_CHUYEN_VE = "11";
        public const string KHIEUNAI_KIENNGHI_KHANGNGHI = "12";
        public const string KHIEUNAI_KIENNGHI = "13";
        public const string KHIEUNAI_KHANGNGHI = "14";
        public const string KIENNGHI_KHANGNGHI = "15";
        public const string KHIEUNAI = "16";
        public const string KIENNGHI = "17";
        public const string KHANGNGHI = "18";
        public const string HUYQD_CHUYENHOSO = "19";
        public const string GDT_HUY_TRA_VE_PT = "998";
        public const string GDT_HUY_TRA_VE_ST = "2597";
    }
    public class ENUM_QHPLTK
    {
        public const int DANSU = 0;
        public const int HONNHAN_GIADINH = 1;
        public const int KINHDOANH_THUONGMAI = 2;
        public const int LAODONG = 3;
        public const int HANHCHINH = 4;
        public const int PHASAN = 5;
        public const int NGANHKINHTE = 15;
    }
    public class ENUM_DOITUONG_NOPYCPS
    {
        public const string CHUNO_COBAODAM = "01";
        public const string CHUNO_BAODAM1PHAN = "02";
        public const string CHUNO_TCTINDUNG = "03";
        public const string CHUNO_BAOHIEM = "04";
        public const string NGUOILAODONG = "05";
        public const string CONGDOAN = "06";
        public const string CHU_DN_HTX = "07";
        public const string CODONG = "08";
        public const string NHNN = "09";
    }
    public class ENUM_XLHC_DENGHI
    {
        public const string HOAN = "1";
        public const string MIEN = "2";
        public const string GIAM = "3";
        public const string TAM_DINHCHI = "4";
        public const string MIEN_CONLAI = "5";
    }

    public class ENUM_GDT_LOAICV
    {
        public const string DE_NGHI = "CVDN";
        public const string KIENNGHI = "CVKN";
        public const string NHACLAI = "CVNL";
        public const string CV6_1 = "CV6.1";
        public const string CV9_3 = "CV9.3";
        public const string CV8_1 = "CV8.1";
        public const string CV8_1_DDBQH = "CV8.1.DDBQH";
        public const string CV8_1_DBQH = "CV8.1.DBQH";
        public const string CV8_1_CQQH = "CV8.1.CQQH";
        public const string CHUYEN = "CVCHUYEN";
        public const string LOAIKHAC = "CVLOAIKHAC";
    }

    public class MenuPermission
    {
        public decimal MENUID { get; set; }
        public bool XEM { get; set; }
        public bool TAOMOI { get; set; }
        public bool CAPNHAT { get; set; }
        public bool XOA { get; set; }
        public bool DULIEU { get; set; }

        public bool ISXINANGIAM { get; set; }
        public bool GDT_ISXINANGIAM { get; set; }
        public decimal ISTHANHNIEN { get; set; }
    }

    //------------------------------------------
    public class ENUM_NHOMQUYEN
    {
        public const int QUANTRIHT = 1;
    }
    /*--------------SD Trong DKK-------------------------*/
    public class ENUM_DKNHANVBTONGDAT
    {
        public const int DANGKY = 1;
        public const int KHONGDK = 0;
    }
    public class ENUM_ISREAD
    {
        public const int CHUADOC = 0;
        public const int DADOC = 1;
        public const int TATCA = 2;
    }
    public class ENUM_THA
    {
        public const string QD_GIAMAN = "THA_QD_GIAMAN";
    }
    public class TK_CANHBAO
    {
        public const string TK_SET_DEFAULT_VALUE = "TK_SET_DEFAULT_VALUE";
        public const string TINHTRANG_GIAIQUYET = "TINHTRANG_GIAIQUYET";
        public const string THOIHAN_GQ_GIAIQUYET = "THOIHAN_GQ_GIAIQUYET";
        public const string CAPXX = "CAPXX";
        public const string TINHTRANG_THULY = "TINHTRANG_THULY";
        public const string TUNGAY = "TUNGAY";
        public const string DENNGAY = "DENNGAY";
        public const string GQDON = "GQDON";
        public const string TENVUVIEC = "TENVUVIEC";
        public const string MANVUVIEC = "MANVUVIEC";
        public const string TOIDANH = "TOIDANH";
        public const string BiCan = "BiCan";
        public const string TOAAN = "TOAAN";
        public const string SOTHULY = "SOTHULY";
        public const string NGAYTHULY_TU = "NGAYTHULY_TU";
        public const string NGAYTHULY_DEN = "NGAYTHULY_DEN";

        public const string KETQUA = "KETQUA";
        public const string SOQD = "SOQD";
        public const string NGAYQD = "NGAYQD";
        public const string THAMPHAN = "THAMPHAN";
        public const string THUKY = "THUKY";

        public const string TAMGIAM = "TAMGIAM";
        public const string UTTP = "UTTP";
        public const string LOAIAN = "LOAIAN";
        public const string ARRSELECTID = "ARRSELECTID";


    }

    public class SS_BAOCAO_CA
    {
        public const string LOAIAN = "SS_BAOCAO_CA_LOAIAN";
        public const string THAMPHAN = "SS_BAOCAO_CA_THAMPHAN";
        public const string TUNGAY = "SS_BAOCAO_CA_TUNGAY";
        public const string DENNGAY = "SS_BAOCAO_CA_DENNGAY";
        public const string COLUMN_SOLIEU = "SS_BAOCAO_CA_COLUMN_SOLIEU";
        //Bổ sung cho popup thông tin vụ án
        public const string VUANIDs = "SS_VUANIDS";
        //Bổ sung cho sơ thâm phúc thẩm
        public const string VALUE_TAB = "SS_BAOCAO_CA_VALUE_TAB";
        public const string VALUE_TIME = "SS_BAOCAO_CA_VALUE_VALUE_TIME";

        public const string VALUE_ANQUOCHOI = "SS_BAOCAO_CA_VALUE_ANQUOCHOI";
        public const string VALUE_ANTHOIHIEU = "SS_BAOCAO_CA_VALUE_ANTHOIHIEU";
    }
    public class SS_TK
    {
        public const string ISHOME = "SSTK_ISHOME";
        public const string ISTUHINH = "SSTK_ISTUHINH";
        public const string ISDONGOC = "SSTK_ISDONGOC";
        public const string NGUOIGUI = "SSTK_NGUOIGUI";
        public const string SOBAQD = "SSTK_SOBAQD";
        public const string NGAYBAQD = "SSTK_NGAYBAQD";
        public const string TOAANXX = "SSTK_TOAANXX";
        public const string NGAYNHANTU = "SSTK_NGAYNHANTU";
        public const string NGAYNHANDEN = "SSTK_NGAYNHANDEN";
        public const string LOAICHUYEN = "SSTK_LOAICHUYEN";
        public const string PHONGBANCHUYEN = "SSTK_PHONGBANCHUYEN";
        public const string DIEUKIENCHUYEN = "SSTK_DIEUKIENCHUYEN";
        public const string THULYDON = "SSTK_THULYDON";
        public const string TOAKHACID = "SSTK_TOAKHACID";
        public const string TENNGOAITOAAN = "SSTK_TENNGOAITOAAN";
        public const string NGAYCHUYENTU = "SSTK_NGAYCHUYENTU";
        public const string NGAYCHUYENDEN = "SSTK_NGAYCHUYENDEN";
        public const string HINHTHUCDON = "SSTK_HINHTHUCDON";
        public const string SOCMND = "SSTK_SOCMND";
        public const string MADON = "SSTK_MADON";
        public const string TINHID = "SSTK_TINHID";
        public const string HUYENID = "SSTK_HUYENID";
        public const string DIACHICHITIET = "SSTK_DIACHICHITIET";
        public const string TRALOIDON = "SSTK_TRALOIDON";
        public const string DONVICV = "SSTK_DONVICV";
        public const string SOCV = "SSTK_SOCV";
        public const string LOAICVPC = "SSTK_LOAICVPC";
        public const string NGAYCV = "SSTK_NGAYCV";
        public const string TRANGTHAICHUYEN = "SSTK_TRANGTHAICHUYEN";
        public const string CHANHANCHIDAO = "SSTK_CHIDAO";
        public const string TRAIGIAM = "SSTK_TRAIGIAM";
        public const string PHANCONGTTV = "SSTK_PHANCONGTTV";
        public const string THULY_TU = "SSTK_THULY_TU";
        public const string THULY_DEN = "SSTK_THULY_DEN";
        public const string SOTHULY = "SSTK_SOTHULY";
        public const string BC_SOCV = "BC_SOCV";
        public const string BC_NGAYCV = "BC_NGAYCV";
        public const string BC_NGUOIKY = "BC_NGUOIKY";
        public const string NGAYNHAPTU = "SSTK_NGAYNHAPTU";
        public const string NGAYNHAPDEN = "SSTK_NGAYNHAPDEN";
        public const string THAMPHAN = "SSTK_THAMPHAN";
        public const string LOAICV = "SSTK_LOAICV";
        public const string NGUOINHAP = "SSTK_NGUOINHAP";
        public const string ARRSELECTID = "SSTK_ARRSELECT";
        public const string MUONHOSO = "SSTK_MUONHOSO";
        public const string CHIDAO = "SSTK_CHIDAO";
        public const string NGUYENDON = "SSTK_NGUYENDON";
        public const string BIDON = "SSTK_BIDON";
        public const string LOAIAN = "SSTK_LOAIAN";
        public const string THAMTRAVIEN = "SSTK_THAMTRAVIEN";
        public const string LANHDAOPHUTRACH = "SSTK_LANHDAOPHUTRACH";
        public const string QHPKLT = "SSTK_QHPKLT";
        public const string QHPLDN = "SSTK_QHPLDN";
        public const string COQUANCHUYENDON = "SSTK_COQUANCHUYENDON";

        public const string TRANGTHAITHULY = "SSTK_TRANGTHAITHULY";
        public const string ISDANGKYBAOCAO = "SSTK_ISDANGKYBAOCAO";

        public const string TRANGTHAIYKIENTT = "SSTK_TRANGTHAIYKIENTT";
        public const string KETQUATHULY = "SSTK_KETQUATHULY";
        public const string KETQUAXETXU = "SSTK_KETQUAXETXU";
        public const string TENBAOCAO = "SSTK_TENBAOCAO";
        public const string TRANGTHAIXETXU = "SSTK_TRANGTHAIXETXU";

        public const string XXGDT_HDTP = "SSTK_XXGDT_HDTP";

        public const string TRANGTHAITOTRINH = "SSTK_TRANGTHAITOTRINH";

        public const string CVPC_TenCQ = "SSTK_CVPC_TenCQ";
        public const string CVPC_SO = "SSTK_CVPC_SO";
        public const string CVPC_NGAY = "SSTK_CVPC_NGAY";
        public const string GUITOI_CA_TA = "SSTK_GUITOI_CA_TA";
        public const string HOAN_THIHAHAN = "SSTK_HOAN_THIHAHAN";
        public const string ANQUOCHOI_THOIHIEU = "SSTK_ANQUOCHOI_THOIHIEU";
        public const string BUOCTT = "SSTK_BUOCTT";
        public const string ANTHOIHIEU = "SSTK_ANTHOIHIEU";
        public const string CHK_CONLAI_S = "SSTK_CHK_CONLAI";
        public const string PHANLOAIDON = "SSTK_PHANLOAIDON";
        public const string GhepDon_VuAn = "SSTK_GhepDon_VuAn";
        public const string GIAOTHS = "SSTK_GIAOTHS";
        public const string HCTP_GHICHU = "HCTP_GHICHU";
        //-----------------
        public const string TRANG_THAI_XLY_VT = "TRANG_THAI_XLY_VT";
        public const string TRANGTHAICHUYEN_VT = "TRANGTHAICHUYEN_VT";
        public const string NOI_NHAN_SEARCH = "NOI_NHAN_SEARCH";
        public const string LOAI_VB = "LOAI_VB";
        public const string SODEN = "SODEN";
        public const string SODEN_DEN = "SODEN_DEN";
        public const string NGAY_FROM = "NGAY_FROM";
        public const string NGAY_FROM_DEN = "NGAY_FROM_DEN";
        public const string NGUOI_GUI_BT = "NGUOI_GUI_BT";
        //-----------------
        public const string NDBD_VALUE = "NDBD_VALUE";
        public const string NDBD_TEXT = "NDBD_TEXT";
    }

    public class ENUM_GDTTT_TRANGTHAI
    {
        public const decimal THULY_MOI = 1;
        public const decimal PHANCONG_TTV = 2;
        public const decimal NGHIENCUU_HOSO = 3;
        public const decimal TRINH_PHOVT = 4;
        public const decimal TRINH_VUTRUONG = 5;
        public const decimal TRINH_THAMPHAN = 6;
        public const decimal TRINH_PHOCA = 7;
        public const decimal TRINH_CA = 8;
        public const decimal TRINH_TO_THAMPHAN = 9;
        public const decimal TRINH_HOIDONG_THAMPHAN = 17;
        public const decimal TRINH_NGHIENCUULAI = 10;
        public const decimal TRINH_DUTHAO_TRALOI_DON = 11;
        public const decimal TRINH_DUTHAO_KHANGNGHI = 12;
        public const decimal TRALOIDON = 13;
        public const decimal KHANGNGHI = 14;
        public const decimal THULY_XETXU_GDT = 15;
        public const decimal XEPDON = 16;
        public const decimal XUlY_KHAC = 18;
        public const decimal XEPDON_VKS_DANGGIAIQUYET = 19;
    }
    //
    #region hoà giải
    public enum ENUM_TRANGTHAI_HOAGIAI
    {
        NULL = 0,
        HOAGIAI = 1,
        HOAGIAI_THANH = 2,
        HOAGIAI_KHONGTHANH = 3,
        DUONGSU_RUTDON = 4,
        HOAN = 5,
        THONGBAO_KHONGHOAGIAI = 6,
        THONGBAO_KHONGTRALOI = 7
    }
    public enum ENUM_CONGNHAN_HOAGIAI
    {
        CONGNHAN = 2,
        KHONGCONGNHAN = 3,
    }
    public enum ENUM_LUACHON_HOAGIAI
    {
        HOAGIAI = 1,
        KHONG_HOAGIAI = 2,
        KHONG_TRALOI = 3
    }
    public enum ENUM_QD_CONGNHAN_HOAGIAI_THANH
    {
        DE_NGHI = 1,
        KHONG_DE_NGHI = 2
    }
    public enum ENUM_LYDO_HOAGIAI_KHONGTHANH
    {
        NULL = 0,
        KHONG_DAT_THOA_THUAN = 1,
        DAT_MOT_PHAN = 2,
        KHONG_TIEPTUC_HOAGIAI = 3,
        VANG_MAT_02_LAN = 4,
        KHONG_THUOC_DOI_TUONG_HOAGIAI = 5,
        AP_DUNG_BIEN_PHAP_KHAN_CAP = 6
    }
    #endregion hoà giải

    #region Công bố
    public enum ENUM_LOAI_FILE
    {
        //None = 0,
        FILE_GOC = 1,

        FILE_DA_MA_HOA = 2,
        FILE_DONG_DAU = 3,
        KHAC = 99
    }
    #endregion Công bố

    //phát hành
    public class ENUM_GDTTT_TONGDAT
    {
        public const string IS_PHBS = "0";
        public const string IS_PHATHANHLAI = "0";
    }
    public class ENUM_GDTTT_TONGDAT_HCTP
    {
        public const string IS_PHBS = "0";
        public const string IS_PHATHANHLAI = "0";
    }

    //Tư cách tham gia tố tụng BP XLCH
    public class ENUM_TCTT_BPXLHC
    {
        public const string CQDN = "TGTTBPXLHC-01";
        public const string NBDN = "TGTTBPXLHC-02";
    }

    public class ENUM_MAP_TABLE
    {
        public const string ADS_ANPHI = "ADS_ANPHI"; // Mã BM: 100-DS
        public const string AKT_ANPHI = "AKT_ANPHI"; // Mã BM: 100-DS
        public const string ALD_ANPHI = "ALD_ANPHI"; // Mã BM: 100-DS
        public const string APS_ANPHI = "APS_ANPHI"; // Mã BM: 100-DS
        public const string AHN_ANPHI = "AHN_ANPHI"; // Mã BM: 100-DS
        public const string AHC_ANPHI = "AHC_ANPHI"; // Mã BM: 100-DS
        public const string ADS_DON_XULY = "ADS_DON_XULY"; // 
        public const string ADS_SOTHAM_THULY = "ADS_SOTHAM_THULY"; // 
        public const string ADS_SOTHAM_QUYETDINH = "ADS_SOTHAM_QUYETDINH"; // 
        public const string ADS_PHUCTHAM_THULY = "ADS_PHUCTHAM_THULY"; // 
        public const string ADS_PHUCTHAM_QUYETDINH = "ADS_PHUCTHAM_QUYETDINH"; //
        public const string ADS_SOTHAM_BANAN = "ADS_SOTHAM_BANAN"; // 
        public const string ALD_SOTHAM_BANAN = "ALD_SOTHAM_BANAN"; // 
        public const string ALD_SOTHAM_THULY = "ALD_SOTHAM_THULY"; // 
        public const string ALD_DON_XULY = "ALD_DON_XULY"; // 
        public const string ADS_PHUCTHAM_BANAN = "ADS_PHUCTHAM_BANAN"; //
        public const string AHC_PHUCTHAM_QUYETDINH = "AHC_PHUCTHAM_QUYETDINH"; //
        public const string AHC_SOTHAM_QUYETDINH = "AHC_SOTHAM_QUYETDINH"; // 
        public const string AHC_KCKNQDK_PHUCTHAM_QUYETDINH = "AHC_KCKNQDK_PHUCTHAM_QUYETDINH"; // 
        public const string AKT_DON_XULY = "AKT_DON_XULY"; // 
        public const string AKT_SOTHAM_THULY = "AKT_SOTHAM_THULY"; // 
        public const string AKT_SOTHAM_BANAN = "AKT_SOTHAM_BANAN"; // 
        public const string AKT_SOTHAM_QUYETDINH = "AKT_SOTHAM_QUYETDINH"; // 
        public const string AKT_PHUCTHAM_THULY = "AKT_PHUCTHAM_THULY"; // 
        public const string AKT_PHUCTHAM_QUYETDINH = "AKT_PHUCTHAM_QUYETDINH"; //
        public const string AKT_PHUCTHAM_BANAN = "AKT_PHUCTHAM_BANAN"; //
        public const string ALD_PHUCTHAM_QUYETDINH = "ALD_PHUCTHAM_QUYETDINH"; //
        public const string ALD_SOTHAM_QUYETDINH = "ALD_SOTHAM_QUYETDINH"; // 
        public const string AHN_DON_XULY = "AHN_DON_XULY"; // 
        public const string AHN_SOTHAM_THULY = "AHN_SOTHAM_THULY"; // 
        public const string AHN_SOTHAM_QUYETDINH = "AHN_SOTHAM_QUYETDINH"; // 
        public const string AHN_PHUCTHAM_THULY = "AHN_PHUCTHAM_THULY"; // 
        public const string AHN_PHUCTHAM_QUYETDINH = "AHN_PHUCTHAM_QUYETDINH"; // 
        public const string AHN_SOTHAM_BANAN = "AHN_SOTHAM_BANAN"; // 
        public const string AHN_PHUCTHAM_BANAN = "AHN_PHUCTHAM_BANAN"; //
        public const string ALD_PHUCTHAM_BANAN = "ALD_PHUCTHAM_BANAN"; //
        public const string APS_SOTHAM_QUYETDINH = "APS_SOTHAM_QUYETDINH"; // 
        public const string AHC_PHUCTHAM_THULY = "AHC_PHUCTHAM_THULY"; //
        public const string ALD_PHUCTHAM_THULY = "ALD_PHUCTHAM_THULY"; // 
        public const string AHC_DON_XULY = "AHC_DON_XULY"; // 
        public const string AHC_SOTHAM_THULY = "AHC_SOTHAM_THULY"; // 
        public const string AHC_SOTHAM_BANAN = "AHC_SOTHAM_BANAN"; // 
        public const string AHC_PHUCTHAM_BANAN = "AHC_PHUCTHAM_BANAN"; //
        public const string AHS_SOTHAM_QUYETDINH_VUAN = "AHS_SOTHAM_QUYETDINH_VUAN"; //
        public const string AHS_PHUCTHAM_QUYETDINH_VUAN = "AHS_PHUCTHAM_QUYETDINH_VUAN"; //
        public const string AHS_SOTHAM_BANAN = "AHS_SOTHAM_BANAN"; //
        public const string AHS_PHUCTHAM_BANAN = "AHS_PHUCTHAM_BANAN"; //
    }

    //#region [ SÁP NHẬP ]

    /// <summary>
    /// Loại sáp nhập
    /// </summary>
    public class ENUM_LOAISAPNHAP_MA
    {
        /// <summary>
        /// Nhập
        /// </summary>
        public const string NHAP = "NHAP";

        /// <summary>
        /// Tách
        /// </summary>
        public const string TACH = "TACH";
    }

    /// <summary>
    /// Lý do bàn giao án
    /// </summary>
    public class ENUM_LYDOBANGIAOAN_MA
    {
        /// <summary>
        /// Sáp nhập đơn vị
        /// </summary>
        public const string SAPNHAP = "SAPNHAP";
    }

    /// <summary>
    /// Trạng thái bàn giao án
    /// </summary>
    public class ENUM_TRANGTHAIBANGIAOAN_MA
    {
        /// <summary>
        /// Chờ nhận
        /// </summary>
        public const string TTBG_CHONHAN = "TTBG_CHONHAN";

        /// <summary>
        /// Đã nhận
        /// </summary>
        public const string TTBG_DANHAN = "TTBG_DANHAN";

        /// <summary>
        /// Từ chối
        /// </summary>
        public const string TTBG_TUCHOI = "TTBG_TUCHOI";

        /// <summary>
        /// Chờ nhận
        /// </summary>
        public const string CHONHAN = "TTBG_CHONHAN";

        /// <summary>
        /// Đã nhận
        /// </summary>
        public const string DANHAN = "TTBG_DANHAN";

        /// <summary>
        /// Từ chối
        /// </summary>
        public const string TUCHOI = "TTBG_TUCHOI";
    }

    public class ENUM_MESSAGE
    {
        public const String SERVER_ERROR = "Có lỗi xảy ra. Vui lòng liên hệ ban quản trị!";
    }

    // VNPT Nguyễn Đăng Huy Hoàng 17:12:00 14/11/2025
    // danh sách BM màn màn quyết định vụ việc Sơ thẩm Dân sự
    public static class ENUM_PHATHANH_BIEUMAU_DS
    {
        #region Danh sách BM thông tin đơn
        public const string DS24 = "24-DS";


        #endregion

        #region Danh sách BM ADS_ST_GIAI_QUYET_DON
        public const string DS25 = "25-DS";
        public const string DS26 = "26-DS";
        public const string DS27 = "27-DS";
        public const string DS29 = "29-DS";
        public const string VDS05 = "05-VDS";
        #endregion

        #region Danh sách BM QDVUVIEC_ST_ADS
        public const string DS12 = "12-DS";
        public const string DS14 = "14-DS";
        public const string DS15 = "15-DS";
        public const string DS16 = "16-DS";
        public const string DS17 = "17-DS";
        public const string DS18 = "18-DS";
        public const string DS19 = "19-DS";
        public const string DS20 = "20-DS";
        public const string DS21 = "21-DS";
        public const string DS22 = "22-DS";
        public const string DS41 = "41-DS";
        public const string DS42 = "42-DS";
        public const string DS43 = "43-DS";
        public const string DS44 = "44-DS";
        public const string DS47 = "47-DS";
        public const string DS50 = "50-DS";

        public const string VDS10 = "10-VDS";
        public const string VDS12 = "12-VDS";
        public const string VDS14 = "14-VDS";
        public const string VDS15 = "15-VDS";
        public const string VDS16 = "16-VDS";
        public const string VDS17 = "17-VDS";
        public const string VDS18 = "18-VDS";
        public const string VDS28 = "28-VDS";
        public const string VDS29 = "29-VDS";
        public const string VDS30 = "30-VDS";

        public const string VDS22 = "22-VDS";

        public const string DS38 = "38-DS";
        public const string DS39 = "39-DS";
        public const string DS40 = "40-DS";
        public const string DS45 = "45-DS";
        public const string DS46 = "46-DS";
        public const string VDS19 = "19-VDS";
        public const string VDS20 = "20-VDS";
        public const string VDS26 = "26-VDS";
        #endregion

        #region Danh sách BM QDVUVIEC_PT_ADS
        public const string DS66 = "66-DS";
        public const string DS67 = "67-DS";
        public const string DS68 = "68-DS";
        public const string DS74 = "74-DS";
        public const string DS77 = "77-DS";

        public const string VDS23 = "23-VDS";
        public const string VDS27 = "27-VDS";

        public const string DS69 = "69-DS";
        public const string DS70 = "70-DS";
        #endregion

        #region Danh sách BM BANAN_PT_ADS

        public const string DS75 = "75-DS";
        #endregion

        #region Danh sách BM bản án

        public const string DS52 = "52-DS";



        #endregion

        #region Danh sách BM QDVUVIEC_ST_AHC
        public const string HC10 = "10-HC";
        public const string HC11 = "11-HC";
        public const string HC12 = "12-HC";
        public const string HC13 = "13-HC";
        public const string HC16 = "16-HC";
        public const string HC17 = "17-HC";
        public const string HC18 = "18-HC";
        public const string HC19 = "19-HC";
        public const string HC23 = "23-HC";
        public const string TTDS = "TTDS";

        public const string HC09 = "09-HC";
        public const string HC14 = "14-HC";
        public const string HC15 = "15-HC";
        #endregion

        #region Danh sách BM ThuLyPT_AHC án HC

        public const string HC35 = "35-HC";

        #endregion

        #region Danh sách BM QDVUVIEC_PT_AHC án HC

        public const string HC36 = "36-HC";
        public const string HC37 = "37-HC";
        public const string HC38 = "38-HC";
        public const string HC39 = "39-HC";
        public const string HC43 = "43-HC";
        public const string HC44 = "44-HC";
        public const string HC58 = "58-HC";
        public const string HC59 = "59-HC";
        public const string HC60 = "60-HC";
        public const string HC61 = "61-HC";
        public const string HC62 = "62-HC";

        public const string HC40 = "40-HC";
        public const string HC41 = "41-HC";
        public const string HC47 = "47-HC";

        #endregion

        #region Danh sách BM BANAN_PT_AHC án HC

        public const string HC46 = "46-HC";


        #endregion
        #region Danh sách biểu thông tin hồ sơ
        public const string HC02 = "02-HC";
        #endregion
        #region Danh sách biểu mẫu giải quyết đơn
        public const string HC03 = "03-HC";
        public const string HC04 = "04-HC";
        #endregion

        #region Danh sách biểu mẫu Bản án ST án Hành chính

        public const string HC22 = "22-HC";

        #endregion

        #region Danh sách BM QUYETDINH_ST_AHS án AHS

        public const string HS16 = "16-HS";
        public const string HS17 = "17-HS";
        public const string HS18 = "18-HS";
        public const string HS19 = "19-HS";
        public const string HS20 = "20-HS";
        public const string HS36 = "36-HS";
        public const string HS37 = "37-HS";
        public const string HS38 = "38-HS";
        public const string HS41 = "41-HS";
        public const string HS42 = "42-HS";
        public const string HS43 = "43-HS";
        public const string HS44 = "44-HS";


        public const string HS39 = "39-HS";
        public const string HS40 = "40-HS";

        #endregion

        #region Danh sách BM BANAN_ST_AHS án AHS


        public const string HS27 = "27-HS";


        #endregion



        #region Danh sách BM BANAN_PT_AHS án AHS
        public const string HS28 = "28-HS";

        #endregion


        #region Danh sách BM QDVUVIEC_PT_AHS án AHS

        public const string HS51 = "51-HS";
        public const string HS52 = "52-HS";
        public const string HS21 = "21-HS";

        #endregion


        // Danh sách BM ADS_ST_GIAI_QUYET_DON hợp lệ
        public static readonly HashSet<string> ADS_ST_GIAI_QUYET_DON = new HashSet<string>
        {
            DS25, DS26, DS27, DS29,
            VDS05
        };

        // hàm kiểm tra danh sách BM ADS_ST_GIAI_QUYET_DON hợp lệ
        public static bool IsValid_ADS_ST_GIAI_QUYET_DON(string value) =>
            ADS_ST_GIAI_QUYET_DON.Contains(value);

        // Danh sách BM QDVUVIEC_ST_ADS hợp lệ
        public static readonly HashSet<string> QDVUVIEC_ST_ADS = new HashSet<string>
        {
            DS12, DS14, DS15, DS16, DS17, DS18, DS19, DS20, DS21, DS22,
            DS41, DS42, DS43, DS44, DS47,DS46, DS50, DS46,
            VDS10, VDS12, VDS14, VDS15, VDS16, VDS17, VDS18, VDS28, VDS29, VDS30,
            VDS22, TTDS
        };

        // hàm kiểm tra danh sách BM QDVUVIEC_ST_ADS hợp lệ
        public static bool IsValid_QDVUVIEC_ST_ADS(string value) =>
            QDVUVIEC_ST_ADS.Contains(value);

        // BM cho màn Thụ lý phúc thẩm.
        public const string DS65 = "65-DS";

        public static readonly HashSet<string> BM_THULY_PT = new HashSet<string>
        {
            DS65
        };
        public static bool IsValidBMThuLyPT(string maBM)
        {
            return BM_THULY_PT.Contains(maBM);
        }
        // BM cho màn Thụ lý phúc thẩm.

        // Danh sách BM QDVUVIEC_PT_ADS hợp lệ
        public static readonly HashSet<string> QDVUVIEC_PT_ADS = new HashSet<string>
        {
            DS66, DS67, DS68, DS74, DS77, DS69, DS70,
            VDS23, VDS27, VDS26
        };

        // hàm kiểm tra danh sách BM QDVUVIEC_PT_ADS hợp lệ
        public static bool IsValid_QDVUVIEC_PT_ADS(string value) =>
            QDVUVIEC_PT_ADS.Contains(value);

        // Danh sách BM BANAN_PT_ADS hợp lệ
        public static readonly HashSet<string> BANAN_PT_ADS = new HashSet<string>
        {
            DS75
        };

        // hàm kiểm tra danh sách BM BANAN_PT_ADS hợp lệ
        public static bool IsValid_BANAN_PT_ADS(string value) =>
            BANAN_PT_ADS.Contains(value);

        // Danh sách BM THONGTINDON hợp lệ
        public static readonly HashSet<string> BM_THONGTINDONST_ADS = new HashSet<string>
        {
            DS24
        };

        // hàm kiểm tra danh sách BM QDVUVIEC_PT_ADS hợp lệ
        public static bool IsValid_BM_THONGTINDON_ADS(string value) =>
            BM_THONGTINDONST_ADS.Contains(value);

        // Danh sách BM bản án hợp lệ
        public static readonly HashSet<string> BM_QUYETDINH_ADS_ST = new HashSet<string>
        {
            DS38, DS39,DS40, DS45, DS46, VDS19, VDS20
        };

        public static bool IsValid_BM_QUYETDINH_ADS_ST(string value)
            => BM_QUYETDINH_ADS_ST.Contains(value);


        public static readonly HashSet<string> BM_BANAN_ADS_ST = new HashSet<string>
        {
           DS52
        };

        public static bool IsValid_BANAN_ADS_ST(string value)
            => BM_BANAN_ADS_ST.Contains(value);

        // Danh sách BM QDVUVIEC_ST_AHC hợp lệ
        public static readonly HashSet<string> QDVUVIEC_ST_AHC = new HashSet<string>
        {
            HC10, HC11, HC12, HC13, HC16, HC17, HC18, HC19, HC23, TTDS
            ,HC09, HC14, HC15,
        };

        // hàm kiểm tra danh sách BM QDVUVIEC_ST_AHC hợp lệ
        public static bool IsValid_QDVUVIEC_ST_AHC(string value) =>
            QDVUVIEC_ST_AHC.Contains(value);

        // Danh sách BM ThuLyPT_AHC hợp lệ
        public static readonly HashSet<string> BM_THULY_PT_AHC = new HashSet<string>
        {
            HC35
        };

        // hàm kiểm tra danh sách BM ThuLyPT_AHC hợp lệ
        public static bool IsValid_BMThuLyPT_AHC(string value) =>
            BM_THULY_PT_AHC.Contains(value);

        // Danh sách BM QDVUVIEC_PT_AHC hợp lệ
        public static readonly HashSet<string> QDVUVIEC_PT_AHC = new HashSet<string>
        {
            HC36, HC37, HC38, HC39, HC43, HC44,
            HC58, HC59, HC60, HC61, HC62
            , HC40, HC41, HC47
        };

        // hàm kiểm tra danh sách BM QDVUVIEC_PT_AHC hợp lệ
        public static bool IsValid_QDVUVIEC_PT_AHC(string value) =>
            QDVUVIEC_PT_AHC.Contains(value);

        // Danh sách BM BANAN_PT_AHC hợp lệ
        public static readonly HashSet<string> BANAN_PT_AHC = new HashSet<string>
        {
             HC46
        };

        // hàm kiểm tra danh sách BM BANAN_PT_AHC hợp lệ
        public static bool IsValid_BANAN_PT_AHC(string value) =>
            BANAN_PT_AHC.Contains(value);

        // Danh sách BM QUYETDINH_ST_AHS án AHS
        public static readonly HashSet<string> QUYETDINH_ST_AHS = new HashSet<string>
        {
            HS16, HS17, HS18, HS19, HS20, 
            HS36, HS37, HS38, HS41, 
            HS42, HS43, HS44
            , HS39, HS40
        };

        // hàm kiểm tra danh sách BM QUYETDINH_ST_AHS hợp lệ
        public static bool IsValid_QUYETDINH_ST_AHS(string value) =>
            QUYETDINH_ST_AHS.Contains(value);

        // Danh sách BM BANAN_ST_AHS hợp lệ
        public static readonly HashSet<string> BANAN_ST_AHS = new HashSet<string>
        {
            HS27
        };

        // hàm kiểm tra danh sách BM BANAN_ST_AHS hợp lệ
        public static bool IsValid_BANAN_ST_AHS(string value) =>
            BANAN_ST_AHS.Contains(value);

        // Danh sách BM BANAN_PT_AHS hợp lệ
        public static readonly HashSet<string> BANAN_PT_AHS = new HashSet<string>
        {
            HS28
        };

        public static bool IsValid_BANAN_PT_AHS(string value) =>
            BANAN_PT_AHS.Contains(value);

        // Danh sách BM QUYETDINH_PT_AHS hợp lệ
        public static readonly HashSet<string> QUYETDINH_PT_AHS = new HashSet<string>
        {
            HS21, HS51, HS52
        };

        public static bool IsValid_QUYETDINH_PT_AHS(string value) =>
            QUYETDINH_PT_AHS.Contains(value);

        public static readonly HashSet<string> BM_Thongtindon_AHC= new HashSet<string>
        {
            HC02
        };

        // Hàm kiểm tra danh sách biểu mẫu thông tin đơn hợp lệ
        public static bool IsValid_BM_Thongtindon_AHC(string value) =>
            BM_Thongtindon_AHC.Contains(value);

        public static readonly HashSet<string> BM_BANAN_AHC = new HashSet<string>
        {
            HC22
        };
        public static bool IsValid_BM_BANAN_AHC(string value) =>
            BM_BANAN_AHC.Contains(value);

        public static readonly HashSet<string> BM_GIAIQUYETDON_AHC = new HashSet<string>
        {
            HC03, HC04
        };
        public static bool IsValid_BM_GIAIQUYETDON_AHC(string value) =>
            BM_GIAIQUYETDON_AHC.Contains(value);
    }
    public class ENUM_TINHTRANG_BIAN
    {
        public const String TAI_NGOAI = "TTBA_TAI_NGOAI";
        public const String BO_TRON = "TTBA_BO_TRON";
        public const String TAM_GIAM = "TTBA_TAM_GIAM";
    }

    public class ENUM_MA_BIEUMAU
    {
        // Thi hành án
        public const String THA_ANTREO = "THA-01";
        public const String THA_TAINGOAI = "THA-02";
        public const String THA_TAMGIAM = "THA-03";
    }

    //#endregion
    public class ENUM_TRANGTHAI_DONGBO
    {
        public const int CHUA_DONGBO = 0;
        public const int DA_DONGBO = 1;
    }

    public class TYPE_SOVB_DONVI {
        public const int VUGIAMDOC = 0;
        public const int HCTP = 1;
    }

    public class TYPE_THAMPHAN
    {
        public const string TPTC = "TPTC";
        public const string TPB3 = "TPB3";
    }

}