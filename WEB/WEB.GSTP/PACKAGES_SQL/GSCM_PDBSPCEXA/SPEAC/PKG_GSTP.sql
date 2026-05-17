--------------------------------------------------------
--  DDL for Package PKG_GSTP
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_GSTP" AS
PROCEDURE GSTP_HOME_MAP(
  in_DonViLogin IN NUMBER,
  inHienTai_TuNgay IN DATE,
  inHienTai_DenNgay IN DATE,
  inTruoc_TuNgay IN DATE,
  inTruoc_DenNgay IN DATE,
  curReturn OUT sys_refcursor
);
PROCEDURE GSTP_HOME_ST(
  inToaAnID IN NUMBER,
  inCapToa IN VARCHAR2,
  vHienTai_TuNgay IN DATE,
  vHienTai_DenNgay IN DATE,
  vTruoc_TuNgay IN DATE,
  vTruoc_DenNgay IN DATE,
  CurReturn OUT sys_refcursor
);
PROCEDURE GSTP_HOME_PT(
  inToaAnID IN NUMBER,
  inCapToa IN VARCHAR2,
  vHienTai_TuNgay IN DATE,
  vHienTai_DenNgay IN DATE,
  vTruoc_TuNgay IN DATE,
  vTruoc_DenNgay IN DATE,
  CurReturn OUT sys_refcursor
);
PROCEDURE GSTP_HOME_GDT 
(
  inToaAnID IN NUMBER,
  vHienTai_TuNgay IN DATE,
  vHienTai_DenNgay IN DATE,
  CurReturn OUT sys_refcursor
);
PROCEDURE GSTP_HOME_THAMPHAN(
  inToaAnID IN NUMBER,
  inCapToa IN VARCHAR2,
  vTuNgay IN DATE,
  vDenNgay IN DATE,
  CurReturn OUT sys_refcursor
);
PROCEDURE GSTP_HOME_CONGBOBAQD(
  inToaAnID IN NUMBER,
  inCapToa IN VARCHAR2,
  CurReturn OUT sys_refcursor
);
PROCEDURE GSTP_PAGE2_SOTHAM_HINHSU(
  inToaAnID IN NUMBER,
  CurReturn OUT sys_refcursor
);
PROCEDURE GSTP_PAGE2_SOTHAM_DANSU(
  inToaAnID IN NUMBER,
  CurReturn OUT sys_refcursor
);
PROCEDURE GSTP_PAGE2_SOTHAM_HNGD(
  inToaAnID IN NUMBER,
  CurReturn OUT sys_refcursor
);
PROCEDURE GSTP_PAGE2_SOTHAM_KINHTE(
  inToaAnID IN NUMBER,
  CurReturn OUT sys_refcursor
);
PROCEDURE GSTP_PAGE2_SOTHAM_HANHCHINH(
  inToaAnID IN NUMBER,
  CurReturn OUT sys_refcursor
);
PROCEDURE GSTP_PAGE2_SOTHAM_LAODONG(
  inToaAnID IN NUMBER,
  CurReturn OUT sys_refcursor
);
PROCEDURE GSTP_PAGE2_PHUCTHAM_HINHSU(
  inToaAnID IN NUMBER,
  CurReturn OUT sys_refcursor
);
PROCEDURE GSTP_PAGE2_PHUCTHAM_DANSU(
  inToaAnID IN NUMBER,
  CurReturn OUT sys_refcursor
);
PROCEDURE GSTP_PAGE2_PHUCTHAM_HNGD(
  inToaAnID IN NUMBER,
  CurReturn OUT sys_refcursor
);
PROCEDURE GSTP_PAGE2_PHUCTHAM_KINHTE(
  inToaAnID IN NUMBER,
  CurReturn OUT sys_refcursor
);
PROCEDURE GSTP_PAGE2_PHUCTHAM_HANHCHINH(
  inToaAnID IN NUMBER,
  CurReturn OUT sys_refcursor
);
PROCEDURE GSTP_PAGE2_PHUCTHAM_LAODONG(
  inToaAnID IN NUMBER,
  CurReturn OUT sys_refcursor
);
PROCEDURE GSTP_THONGTIN_CHITIET_TP
(
  in_THAMPHANID NUMBER,
  CurReturn OUT sys_refcursor
);
PROCEDURE REPORT_SOLUONG_TP 
(
  vToaAnID IN NUMBER,
	vMaTP IN VARCHAR2,
	vTenTP IN VARCHAR2,
	vDiaChi IN VARCHAR2,
	vGioiTinh IN NUMBER,
	vSoCMND IN VARCHAR2,
	vNgaySinh IN VARCHAR2,
	vSoDienThoai IN VARCHAR2,
	vChucDanh IN NUMBER,
	vChucVu IN NUMBER,
	vNgayNhanCT IN VARCHAR2,
	vNgayBoNhiem IN VARCHAR2,
	vNgayKetThuc IN VARCHAR2,
	vNgayBaiNhiem IN VARCHAR2,
	vLoaiAn IN VARCHAR2,
	vTinhTrang IN NUMBER,
	vGomDonViCapDuoi IN NUMBER,
	CurReturn OUT sys_refcursor
);

PROCEDURE REPORT_SOLUONG_TP_ANHUY 
(
    vToaAnID in number,
    vMaTP in varchar2,
    vTenTP in varchar2,
    vDiaChi in varchar2,
    vGioiTinh in number,
    vSoCMND in varchar2,
    vNgaySinh in varchar2,
    vSoDienThoai in varchar2,
    vChucDanh in number,
    vChucVu in number,
    vNgayNhanCT in varchar2,
    vNgayBoNhiem in varchar2,
    vNgayKetThuc in varchar2,
    vLoaiAn_HS IN VARCHAR2,
    vLoaiAn_DS IN VARCHAR2,
    vLoaiAn_HC IN VARCHAR2,
    vLoaiAn_HN IN VARCHAR2,
    vLoaiAn_KT IN VARCHAR2,
    vLoaiAn_LD IN VARCHAR2,
    vLoaiAn_PS IN VARCHAR2,
    vLoaiAn_XLHC IN VARCHAR2,
    vGomDonViCapDuoi IN NUMBER,
	CurReturn OUT sys_refcursor
);
PROCEDURE REPORT_SOLUONG_TP_ANSUA 
(
  vToaAnID in number,vMaTP in varchar2,vTenTP in varchar2,vDiaChi in varchar2,vGioiTinh in varchar2,
  vSoCMND in varchar2,vNgaySinh in varchar2,vSoDienThoai in varchar2,vChucDanh in number,vChucVu in number,
  vNgayNhanCT in varchar2,vNgayBoNhiem in varchar2,vNgayKetThuc in varchar2,vLoaiAn in varchar2,
  CurReturn OUT sys_refcursor
);
PROCEDURE REPORT_SOLUONG_TP_ANQUAHAN 
(
  vToaAnID in number,vMaTP in varchar2,vTenTP in varchar2,vDiaChi in varchar2,vGioiTinh in varchar2,
  vSoCMND in varchar2,vNgaySinh in varchar2,vSoDienThoai in varchar2,vChucDanh in number,vChucVu in number,
  vNgayNhanCT in varchar2,vNgayBoNhiem in varchar2,vNgayKetThuc in varchar2,vLoaiAn in varchar2,
  CurReturn OUT sys_refcursor
);
PROCEDURE REPORT_SOLUONG_TP_ANTREO 
(
  vToaAnID in number,vMaTP in varchar2,vTenTP in varchar2,vDiaChi in varchar2,vGioiTinh in varchar2,
  vSoCMND in varchar2,vNgaySinh in varchar2,vSoDienThoai in varchar2,vChucDanh in number,vChucVu in number,
  vNgayNhanCT in varchar2,vNgayBoNhiem in varchar2,vNgayKetThuc in varchar2,
  CurReturn OUT sys_refcursor
);
PROCEDURE REPORT_SOLUONG_TP_ANBPTT 
(
  vToaAnID in number,vMaTP in varchar2,vTenTP in varchar2,vDiaChi in varchar2,vGioiTinh in varchar2,
  vSoCMND in varchar2,vNgaySinh in varchar2,vSoDienThoai in varchar2,vChucDanh in number,vChucVu in number,
  vNgayNhanCT in varchar2,vNgayBoNhiem in varchar2,vNgayKetThuc in varchar2,vLoaiAn in varchar2,
  CurReturn OUT sys_refcursor
);
PROCEDURE REPORT_SOLUONG_TP_ANTDC 
(
  vToaAnID in number,vMaTP in varchar2,vTenTP in varchar2,vDiaChi in varchar2,vGioiTinh in varchar2,
  vSoCMND in varchar2,vNgaySinh in varchar2,vSoDienThoai in varchar2,vChucDanh in number,vChucVu in number,
  vNgayNhanCT in varchar2,vNgayBoNhiem in varchar2,vNgayKetThuc in varchar2,vLoaiAn in varchar2,
  CurReturn OUT sys_refcursor
);
PROCEDURE REPORT_SOLUONG_TP_ANDC 
(
  vToaAnID in number,vMaTP in varchar2,vTenTP in varchar2,vDiaChi in varchar2,vGioiTinh in varchar2,
  vSoCMND in varchar2,vNgaySinh in varchar2,vSoDienThoai in varchar2,vChucDanh in number,vChucVu in number,
  vNgayNhanCT in varchar2,vNgayBoNhiem in varchar2,vNgayKetThuc in varchar2,vLoaiAn in varchar2,
  CurReturn OUT sys_refcursor
);
PROCEDURE DS_AN_OFTP_BY_VAITRO_PLUS 
(
  vThamPhanID IN number, 
  vVaiTro in varchar2,
  vTenVuAn in varchar2,
  vTuNgay in date,
  vDenNgay in date,
  vGetAll in int,
  CurReturn OUT sys_refcursor
);
PROCEDURE DS_AN_DAGIAIQUYET_BYTP 
(
	vThamPhanID IN number,
	vTenVuAn in varchar2,
	vSoQDBA in varchar2,
	vNgayQDBA in date,
	CurReturn OUT sys_refcursor
);
PROCEDURE DS_AN_KHANGCAO_KHANGNGHI_BYTP
(
  vThamPhanID IN number,
  vTenVuAn in varchar2,
  vSoQDBA in varchar2,
  vNgayQDBA in date,
  CurReturn OUT sys_refcursor
);
PROCEDURE DS_AN_APDUNGANLE_BYTP
(
  vThamPhanID IN NUMBER, 
	vTenVuAn IN VARCHAR2,
	vSoQDBA IN VARCHAR2,
	vNgayQDBA IN DATE,
  CurReturn OUT sys_refcursor
);
PROCEDURE DS_AN_HOAGIAI_DOITHOAI_BYTP
(
  vThamPhanID IN NUMBER, 
	vTenVuAn IN VARCHAR2,
	vSoQDBA IN VARCHAR2,
	vNgayQDBA IN DATE,
  CurReturn OUT sys_refcursor
);
PROCEDURE DANHGIA_ANSUAHUY_OFTP 
(
  vThamPhanID in number, 
  vTenVuAn in varchar2,
  vMaVuAn in varchar2,
  vAnSuaHuy in varchar2,
  vSoQDBA in varchar2,
  vNgayQDBA in varchar2,
  vLoaiAn in varchar2,
  vTrangThai in varchar2,
  CurReturn OUT sys_refcursor
);
PROCEDURE DS_ANHUY_BYTP
(
  vThamPhanID IN number,
  vTenVuAn in varchar2,
  vSoQDBA in varchar2,
  vNgayQDBA in date,
  CurReturn OUT sys_refcursor
);
PROCEDURE DS_ANHUY_CHUQUAN_BYTP 
(
	vThamPhanID IN number,
	vTenVuAn IN VARCHAR2,
	vSoQDBA IN VARCHAR2,
	vNgayQDBA IN DATE,
	CurReturn OUT sys_refcursor
);
PROCEDURE DS_ANTDC_BYTP
(
  vThamPhanID IN number,
  vTenVuAn in varchar2,
  vSoQDBA in varchar2,
  vNgayQDBA in date,
  CurReturn OUT sys_refcursor
);
PROCEDURE DS_ANDC_BYTP
(
  vThamPhanID IN number,
  vTenVuAn in varchar2,
  vSoQDBA in varchar2,
  vNgayQDBA in date,
  CurReturn OUT sys_refcursor
);
PROCEDURE DS_ANSUA_BYTP
(
  vThamPhanID IN number,
  vTenVuAn in varchar2,
  vSoQDBA in varchar2,
  vNgayQDBA in date,
  CurReturn OUT sys_refcursor
);
PROCEDURE DS_ANSUA_CHUQUAN_BYTP 
(
	vThamPhanID IN number,
	vTenVuAn in varchar2,
	vSoQDBA in varchar2,
	vNgayQDBA in date,
	CurReturn OUT sys_refcursor
);
PROCEDURE DS_ANQUAHAN_BYTP 
(
  vThamPhanID IN NUMBER, 
	vTenVuAn IN VARCHAR2,
	vSoQDBA IN VARCHAR2,
	vNgayQDBA IN DATE,
  CurReturn OUT sys_refcursor
);
PROCEDURE DS_ANBIENPHAPTAMTHOI_BYTP 
(
  vThamPhanID in number,
  vTenVuAn in varchar2,
  vSoQDBA in varchar2,
  vNgayQDBA date,
  CurReturn OUT sys_refcursor 
);
PROCEDURE DS_ANTREO_BYTP 
(
  vThamPhanID in number,
  vTenVuAn in varchar2,
  vSoQDBA in varchar2,
  vNgayQDBA date,
  CurReturn OUT sys_refcursor 
);
PROCEDURE DS_AN_TOCHUC_PTRKN_BYTP 
(
  vThamPhanID in number,
  vTenVuAn in varchar2,
  vSoQDBA in varchar2,
  vNgayQDBA date,
  CurReturn OUT sys_refcursor 
);
PROCEDURE DS_AN_VIPHAM_TAMGIAM_BYTP 
(
  vThamPhanID in number,
  vTenVuAn in varchar2,
  vSoQDBA in varchar2,
  vNgayQDBA date,
  CurReturn OUT sys_refcursor 
);
PROCEDURE GETTHAMPHAN_ANDINHCHI
(
  vDonViID in number,
  CurReturn OUT sys_refcursor
);
PROCEDURE THAMPHAN_TTTONGHOP 
(
  vThamPhanID IN NUMBER,
  CurReturn OUT sys_refcursor
);
PROCEDURE GETALLVUANTHAMGIA
(
  vThamPhanID IN number,
  vVaiTro in number,
  vTuNgay in date,
  vDenNgay in date,
  CurReturn OUT sys_refcursor
);
PROCEDURE DS_THAMPHAN_BYTOAAN 
(
  vDonViLogin in number,
  vDonViID in number,
  vTenThamPhan in varchar2,
  vNgaySinh in varchar2,
  vChucDanhID in number,
  vVaiTro in varchar2,
  vNgayPCTuNgay in date,
  vNgayPCDenNgay in date,
  vSapHetNhiemKy in varchar2,
  vKhieuNai in varchar2,
  vKyLuat in varchar2,
  vAnBiHuy in varchar2,
  vAnApDungBPTT in varchar2,
  vAnDinhChi in varchar2,
  vAnTamDinhChi in varchar2,
  vAnQuaHan in varchar2,
  vAnBiSua in varchar2,
  vAnTreo in varchar2,
  vPageIndex in number,
  vPageSize in number,
  curReturn OUT sys_refcursor
);
PROCEDURE THONGKE_TP_HOMEPAGE 
(
  in_DonViID in number,
  curReturn OUT sys_refcursor
);
PROCEDURE THONGKE_TP_3NAM_3TIEUCHI 
(
  in_DonViID in number,
  curReturn OUT sys_refcursor
);
PROCEDURE THONGKE_TP_HOMEPAGE_BPTT_NAM 
(
  v_ARRAY IN OUT T_ID,
  vDonViID IN NUMBER,
  v_Now_Nam IN NUMBER
);
PROCEDURE THONGKE_TP_HOMEPAGE_BPTT_THANG 
(
  v_ARRAY IN OUT T_ID,
  vDonViID IN NUMBER,
  v_Now_Nam IN NUMBER,
  v_Now_Thang IN NUMBER
);
PROCEDURE THONGKE_TP_HOMEPAGE_HUY_NAM 
(
  v_ARRAY IN OUT T_ID,
  vDonViID IN NUMBER,
  v_Now_Nam IN NUMBER
);
PROCEDURE THONGKE_TP_HOMEPAGE_HUY_THANG 
(
  v_ARRAY IN OUT T_ID,
  vDonViID IN NUMBER,
  v_Now_Nam IN NUMBER,
  v_Now_Thang IN NUMBER
);
PROCEDURE THONGKE_TP_HOMEPAGE_SUA_NAM 
(
  v_ARRAY IN OUT T_ID,
  vDonViID IN NUMBER,
  v_Now_Nam IN NUMBER
);
PROCEDURE THONGKE_TP_HOMEPAGE_SUA_THANG 
(
  v_ARRAY IN OUT T_ID,
  vDonViID IN NUMBER,
  v_Now_Nam IN NUMBER,
  v_Now_Thang IN NUMBER
);
PROCEDURE THONGKE_TP_HOMEPAGE_QHAN_NAM 
(
  v_ARRAY IN OUT T_ID,
  vDonViID IN NUMBER,
  v_Now_Nam IN NUMBER
);
PROCEDURE THONGKE_TP_HOMEPAGE_QHAN_THANG 
(
  v_ARRAY IN OUT T_ID,
  vDonViID IN NUMBER,
  v_Now_Nam IN NUMBER,
  v_Now_Thang IN NUMBER
);
PROCEDURE THONGKE_TP_HOMEPAGE_TREO_NAM 
(
  v_ARRAY IN OUT T_ID,
  vDonViID IN NUMBER,
  v_Now_Nam IN NUMBER
);
PROCEDURE THONGKE_TP_HOMEPAGE_TREO_THANG 
(
  v_ARRAY IN OUT T_ID,
  vDonViID IN NUMBER,
  v_Now_Nam IN NUMBER,
  v_Now_Thang IN NUMBER
);
PROCEDURE THONGKE_TP_HOMEPAGE_TDC_NAM 
(
  v_ARRAY IN OUT T_ID,
  vDonViID IN NUMBER,
  v_Now_Nam IN NUMBER
);
PROCEDURE THONGKE_TP_HOMEPAGE_TDC_THANG 
(
  v_ARRAY IN OUT T_ID,
  vDonViID IN NUMBER,
  v_Now_Nam IN NUMBER,
  v_Now_Thang IN NUMBER
);
PROCEDURE THONGKE_AN_HOMEPAGE 
(
  vDonViID in number,
  curReturn OUT sys_refcursor
);
PROCEDURE THONGKE_AN_HOMEPAGE_HUY_NAM
(
  v_ARRAY IN OUT T_ID,
  vDonViID IN NUMBER,
  v_Now_Nam IN NUMBER
);
PROCEDURE THONGKE_AN_HOMEPAGE_HUY_THANG 
(
  v_ARRAY IN OUT T_ID,
  vDonViID IN NUMBER,
  v_Now_Nam IN NUMBER,
  v_Now_Thang IN NUMBER
);
PROCEDURE THONGKE_AN_HOMEPAGE_SUA_NAM
(
  v_ARRAY IN OUT T_ID,
  vDonViID IN NUMBER,
  v_Now_Nam IN NUMBER
);
PROCEDURE THONGKE_AN_HOMEPAGE_SUA_THANG 
(
  v_ARRAY IN OUT T_ID,
  vDonViID IN NUMBER,
  v_Now_Nam IN NUMBER,
  v_Now_Thang IN NUMBER
);
PROCEDURE THONGKE_AN_HOMEPAGE_QHAN_NAM
(
  v_ARRAY IN OUT T_ID,
  vDonViID IN NUMBER,
  v_Now_Nam IN NUMBER
);
PROCEDURE THONGKE_AN_HOMEPAGE_QHAN_THANG 
(
  v_ARRAY IN OUT T_ID,
  vDonViID IN NUMBER,
  v_Now_Nam IN NUMBER,
  v_Now_Thang IN NUMBER
);
PROCEDURE THONGKE_AN_HOMEPAGE_TDC_NAM
(
  v_ARRAY IN OUT T_ID,
  vDonViID IN NUMBER,
  v_Now_Nam IN NUMBER
);
PROCEDURE THONGKE_AN_HOMEPAGE_TDC_THANG 
(
  v_ARRAY IN OUT T_ID,
  vDonViID IN NUMBER,
  v_Now_Nam IN NUMBER,
  v_Now_Thang IN NUMBER
);
PROCEDURE THONGKE_AN_HOMEPAGE_TREO_NAM
(
  v_ARRAY IN OUT T_ID,
  vDonViID IN NUMBER,
  v_Now_Nam IN NUMBER
);
PROCEDURE THONGKE_AN_HOMEPAGE_TREO_THANG 
(
  v_ARRAY IN OUT T_ID,
  vDonViID IN NUMBER,
  v_Now_Nam IN NUMBER,
  v_Now_Thang IN NUMBER
);
PROCEDURE THONGKE_AN_HOMEPAGE_BPTT_NAM
(
  v_ARRAY IN OUT T_ID,
  vDonViID IN NUMBER,
  v_Now_Nam IN NUMBER
);
PROCEDURE THONGKE_AN_HOMEPAGE_BPTT_THANG 
(
  v_ARRAY IN OUT T_ID,
  vDonViID IN NUMBER,
  v_Now_Nam IN NUMBER,
  v_Now_Thang IN NUMBER
);
PROCEDURE THONGKE_TP_DANGCONGTAC
(
  vDonViID in number,
  vIsTrongNam in number,
	vThang in number,
	vNam in number,
  vPageIndex in number,
  vPageSize in number,
  CurReturn OUT sys_refcursor
);
PROCEDURE THONGKE_TP_BONHIEMMOI
(
  vDonViID in number,
  vIsTrongNam in number,
	vThang in number,
	vNam in number,
  vPageIndex in number,
  vPageSize in number,
  CurReturn OUT sys_refcursor
);
PROCEDURE THONGKE_TP_SAPHETNHIEMKY
(
  vDonViID in number,
  vIsTrongNam in number,
	vThang in number,
	vNam in number,
  vPageIndex in number,
  vPageSize in number,
  CurReturn OUT sys_refcursor
);
PROCEDURE THONGKE_TP_DUNGXETXU
(
  vDonViID in number,
  vIsTrongNam in number,
	vThang in number,
	vNam in number,
  vPageIndex in number,
  vPageSize in number,
  CurReturn OUT sys_refcursor
);
PROCEDURE THONGKE_TP_ANHUY
(
  vDonViID in number,
  vIsTrongNam in number,
	vThang in number,
	vNam in number,
  vPageIndex in number,
  vPageSize in number,
  CurReturn OUT sys_refcursor
);
PROCEDURE THONGKE_TP_ANSUA
(
  vDonViID in number,
  vIsTrongNam in number,
	vThang in number,
	vNam in number,
  vPageIndex in number,
  vPageSize in number,
  CurReturn OUT sys_refcursor
);
PROCEDURE THONGKE_TP_ANQUAHAN
(
  vDonViID in number,
  vIsTrongNam in number,
	vThang in number,
	vNam in number,
  vPageIndex in number,
  vPageSize in number,
  CurReturn OUT sys_refcursor
);
PROCEDURE THONGKE_TP_ANTREO
(
  vDonViID in number,
  vIsTrongNam in number,
	vThang in number,
	vNam in number,
  vPageIndex in number,
  vPageSize in number,
  CurReturn OUT sys_refcursor
);
PROCEDURE THONGKE_TP_ANTAMDINHCHI
(
  vDonViID in number,
  vIsTrongNam in number,
	vThang in number,
	vNam in number,
  vPageIndex in number,
  vPageSize in number,
  CurReturn OUT sys_refcursor
);
PROCEDURE THONGKE_TP_ANBPTT
(
  vDonViID in number,
  vIsTrongNam in number,
	vThang in number,
	vNam in number,
  vPageIndex in number,
  vPageSize in number,
  CurReturn OUT sys_refcursor
);
PROCEDURE THONGKE_DS_ANHUY(
  vDonViID in number,
  vIsTrongNam in number,
  vThang in number,
  vNam in number,
  vPageIndex in number,
  vPageSize in number,
  curReturn OUT sys_refcursor
);
PROCEDURE THONGKE_DS_ANSUA(
  vDonViID in number,
  vIsTrongNam in number,
  vThang in number,
  vNam in number,
  vPageIndex in number,
  vPageSize in number,
  curReturn OUT sys_refcursor
);
PROCEDURE THONGKE_DS_ANQUAHAN(
  vDonViID in number,
  vIsTrongNam in number,
  vThang in number,
  vNam in number,
  vPageIndex in number,
  vPageSize in number,
  curReturn OUT sys_refcursor
);
PROCEDURE THONGKE_DS_ANTREO(
  vDonViID in number,
  vIsTrongNam in number,
  vThang in number,
  vNam in number,
  vPageIndex in number,
  vPageSize in number,
  curReturn OUT sys_refcursor
);
PROCEDURE THONGKE_DS_ANTAMDINHCHI(
  vDonViID in number,
  vIsTrongNam in number,
  vThang in number,
  vNam in number,
  vPageIndex in number,
  vPageSize in number,
  curReturn OUT sys_refcursor
);
PROCEDURE THONGKE_DS_ANBPTT(
  vDonViID in number,
  vIsTrongNam in number,
  vThang in number,
  vNam in number,
  vPageIndex in number,
  vPageSize in number,
  curReturn OUT sys_refcursor
);
PROCEDURE FILL_GSTP_HOME_ST
(
  v_ARRAY IN OUT GSTP_HOME_ST_PT_T,
  vHienTai_TuNgay IN DATE,
  vHienTai_DenNgay IN DATE,
  vTruoc_TuNgay IN DATE,
  vTruoc_DenNgay IN DATE
);
PROCEDURE FILL_GSTP_HOME_PT
(
  v_ARRAY IN OUT GSTP_HOME_ST_PT_T,
  vHienTai_TuNgay IN DATE,
  vHienTai_DenNgay IN DATE,
  vTruoc_TuNgay IN DATE,
  vTruoc_DenNgay IN DATE
);
PROCEDURE FILL_GSTP_HOME_THAMPHAN
(
  v_ARRAY IN OUT GSTP_HOME_THAMPHAN_T,
  vTuNgay IN DATE,
  vDenNgay IN DATE
);
PROCEDURE FILL_GSTP_HOME_CONGBOBAQD
(
  v_ARRAY IN OUT GSTP_HOME_BAQD_T,
  vDate_Nam_HienTai_DauKy IN DATE,
  vDate_Nam_HienTai_CuoiKy IN DATE,
  vDate_Nam_Truoc_DauKy IN DATE,
  vDate_Nam_Truoc_CuoiKy IN DATE
);
PROCEDURE FILL_GSTP_PAGE2_SOTHAM_HINHSU
(
  v_ARRAY IN OUT GSTP_PAGE2_SOTHAM_HS_T,
  vDate_Nam_HienTai_DauKy IN DATE,
  vDate_Nam_HienTai_CuoiKy IN DATE,
  vDate_Nam_Truoc_DauKy IN DATE,
  vDate_Nam_Truoc_CuoiKy IN DATE
);
PROCEDURE FILL_GSTP_PAGE2_SOTHAM_DANSU
(
  v_ARRAY IN OUT GSTP_PAGE2_SOTHAM_DS_T,
  vDate_Nam_HienTai_DauKy IN DATE,
  vDate_Nam_HienTai_CuoiKy IN DATE,
  vDate_Nam_Truoc_DauKy IN DATE,
  vDate_Nam_Truoc_CuoiKy IN DATE
);
PROCEDURE FILL_GSTP_PAGE2_SOTHAM_HNGD
(
  v_ARRAY IN OUT GSTP_PAGE2_SOTHAM_DS_T,
  vDate_Nam_HienTai_DauKy IN DATE,
  vDate_Nam_HienTai_CuoiKy IN DATE,
  vDate_Nam_Truoc_DauKy IN DATE,
  vDate_Nam_Truoc_CuoiKy IN DATE
);
PROCEDURE FILL_GSTP_PAGE2_SOTHAM_KINHTE
(
  v_ARRAY IN OUT GSTP_PAGE2_SOTHAM_DS_T,
  vDate_Nam_HienTai_DauKy IN DATE,
  vDate_Nam_HienTai_CuoiKy IN DATE,
  vDate_Nam_Truoc_DauKy IN DATE,
  vDate_Nam_Truoc_CuoiKy IN DATE
);
PROCEDURE FILL_GSTP_PAGE2_SOTHAM_HC
(
  v_ARRAY IN OUT GSTP_PAGE2_SOTHAM_DS_T,
  vDate_Nam_HienTai_DauKy IN DATE,
  vDate_Nam_HienTai_CuoiKy IN DATE,
  vDate_Nam_Truoc_DauKy IN DATE,
  vDate_Nam_Truoc_CuoiKy IN DATE
);
PROCEDURE FILL_GSTP_PAGE2_SOTHAM_LAODONG
(
  v_ARRAY IN OUT GSTP_PAGE2_SOTHAM_DS_T,
  vDate_Nam_HienTai_DauKy IN DATE,
  vDate_Nam_HienTai_CuoiKy IN DATE,
  vDate_Nam_Truoc_DauKy IN DATE,
  vDate_Nam_Truoc_CuoiKy IN DATE
);
PROCEDURE FILL_GSTP_PAGE2_PHUCTHAM_AHS
(
  v_ARRAY IN OUT GSTP_PAGE2_PHUCTHAM_HS_T,
  vDate_Nam_HienTai_DauKy IN DATE,
  vDate_Nam_HienTai_CuoiKy IN DATE,
  vDate_Nam_Truoc_DauKy IN DATE,
  vDate_Nam_Truoc_CuoiKy IN DATE
);
PROCEDURE FILL_GSTP_PAGE2_PHUCTHAM_ADS
(
  v_ARRAY IN OUT GSTP_PAGE2_PHUCTHAM_DS_T,
  vDate_Nam_HienTai_DauKy IN DATE,
  vDate_Nam_HienTai_CuoiKy IN DATE,
  vDate_Nam_Truoc_DauKy IN DATE,
  vDate_Nam_Truoc_CuoiKy IN DATE
);
PROCEDURE FILL_GSTP_PAGE2_PHUCTHAM_AHN
(
  v_ARRAY IN OUT GSTP_PAGE2_PHUCTHAM_DS_T,
  vDate_Nam_HienTai_DauKy IN DATE,
  vDate_Nam_HienTai_CuoiKy IN DATE,
  vDate_Nam_Truoc_DauKy IN DATE,
  vDate_Nam_Truoc_CuoiKy IN DATE
);
PROCEDURE FILL_GSTP_PAGE2_PHUCTHAM_AKT
(
  v_ARRAY IN OUT GSTP_PAGE2_PHUCTHAM_DS_T,
  vDate_Nam_HienTai_DauKy IN DATE,
  vDate_Nam_HienTai_CuoiKy IN DATE,
  vDate_Nam_Truoc_DauKy IN DATE,
  vDate_Nam_Truoc_CuoiKy IN DATE
);
PROCEDURE FILL_GSTP_PAGE2_PHUCTHAM_AHC
(
  v_ARRAY IN OUT GSTP_PAGE2_PHUCTHAM_DS_T,
  vDate_Nam_HienTai_DauKy IN DATE,
  vDate_Nam_HienTai_CuoiKy IN DATE,
  vDate_Nam_Truoc_DauKy IN DATE,
  vDate_Nam_Truoc_CuoiKy IN DATE
);
PROCEDURE FILL_GSTP_PAGE2_PHUCTHAM_ALD
(
  v_ARRAY IN OUT GSTP_PAGE2_PHUCTHAM_DS_T,
  vDate_Nam_HienTai_DauKy IN DATE,
  vDate_Nam_HienTai_CuoiKy IN DATE,
  vDate_Nam_Truoc_DauKy IN DATE,
  vDate_Nam_Truoc_CuoiKy IN DATE
);
PROCEDURE FILL_GSTP_THONGTIN_CT_TP_SL
(
  v_ARRAY IN OUT GSTP_THONGTIN_CHITIET_TP_T,
  in_THAMPHANID IN NUMBER
);
FUNCTION FUN_GSTP_HOME_ST 
(
  inToaAnID IN NUMBER,
  inCapToa IN VARCHAR2,
  vHienTai_TuNgay IN DATE,
  vHienTai_DenNgay IN DATE,
  vTruoc_TuNgay IN DATE,
  vTruoc_DenNgay IN DATE
) RETURN GSTP_HOME_ST_PT_T PIPELINED;
FUNCTION FUN_GSTP_HOME_PT 
(
  inToaAnID IN NUMBER,
  inCapToa IN VARCHAR2,
  vHienTai_TuNgay IN DATE,
  vHienTai_DenNgay IN DATE,
  vTruoc_TuNgay IN DATE,
  vTruoc_DenNgay IN DATE
) RETURN GSTP_HOME_ST_PT_T PIPELINED;
FUNCTION FUN_GSTP_HOME_GDT 
(
  inToaAn IN NUMBER,
  vHienTai_TuNgay IN DATE,
  vHienTai_DenNgay IN DATE
) RETURN GSTP_HOME_GDT_T PIPELINED;
FUNCTION FUN_GSTP_HOME_TP_DANGCT 
(
  inToaAn IN NUMBER,
  inCapToa IN VARCHAR2,
  vHienTai_TuNgay IN DATE,
  vHienTai_DenNgay IN DATE
) RETURN T_ID PIPELINED;
FUNCTION FUN_GETVUANBPTT_BY_TP
(
  vThamPhanID IN NUMBER,
  vNgayBoNhiem in date,
  vNgayKetThuc in date,
  vLoaiAn in varchar2
) RETURN NUMBER;
FUNCTION FUN_GETVUANHUY_BY_TP 
(
  vThamPhanID IN NUMBER,
  vLoaiAn in varchar2
) RETURN NUMBER;
FUNCTION FUN_GETVUANSUA_BY_TP
(
  vThamPhanID IN NUMBER,
  vNgayBoNhiem in date,
  vNgayKetThuc in date,
  vLoaiAn in varchar2
) RETURN NUMBER;
FUNCTION FUN_GETVUANTDC_BY_TP
(
  vThamPhanID IN NUMBER,
  vNgayBoNhiem in date,
  vNgayKetThuc in date,
  vLoaiAn in varchar2
) RETURN NUMBER;
FUNCTION FUN_GETVUANDC_BY_TP 
(
  vThamPhanID IN NUMBER,
  vNgayBoNhiem in date,
  vNgayKetThuc in date,
  vLoaiAn in varchar2
) RETURN NUMBER;
FUNCTION FUN_GETVUANTREO_BY_TP 
(
  vThamPhanID IN NUMBER,
  vNgayBoNhiem in date,
  vNgayKetThuc in date
) RETURN NUMBER;
FUNCTION FUN_GETVUANQH_BY_TP 
(
  vThamPhanID IN NUMBER,
  vNgayBoNhiem in date,
  vNgayKetThuc in date,
  vLoaiAn in varchar2
) RETURN NUMBER;
FUNCTION FUN_GETVUANCHUTOA_BY_TP 
(
  vThamPhanID IN number
) RETURN NUMBER;
FUNCTION FUN_GETVUANCANHGA_BY_TP 
(
  vThamPhanID IN number
) RETURN NUMBER;

FUNCTION FUN_GETTYLE_ANBPTT_BYTP 
(
  vThamPhanID IN NUMBER,
  vNgayBoNhiem in date,
  vNgayKetThuc in date
) RETURN NUMBER;
FUNCTION FUN_GETTYLE_ANHUY_BYTP 
(
  vThamPhanID IN NUMBER,
  vNgayBoNhiem in date,
  vNgayKetThuc in date
) RETURN NUMBER;
FUNCTION FUN_GETTYLE_ANSUA_BYTP 
(
  vThamPhanID IN NUMBER,
  vNgayBoNhiem in date,
  vNgayKetThuc in date
) RETURN NUMBER;
FUNCTION FUN_GETTYLE_ANTDC_BYTP 
(
  vThamPhanID IN NUMBER,
  vNgayBoNhiem in date,
  vNgayKetThuc in date
) RETURN NUMBER;
FUNCTION FUN_GETTYLE_ANDC_BYTP 
(
  vThamPhanID IN NUMBER,
  vNgayBoNhiem in date,
  vNgayKetThuc in date
) RETURN NUMBER;
FUNCTION FUN_GETTYLE_ANTREO_BYTP 
(
  vThamPhanID IN NUMBER,
  vNgayBoNhiem in date,
  vNgayKetThuc in date
) RETURN NUMBER;
FUNCTION FUN_GETTYLE_ANQUAHAN_BYTP 
(
  vThamPhanID IN NUMBER,
  vNgayBoNhiem in date,
  vNgayKetThuc in date
) RETURN NUMBER;

END PKG_GSTP;
