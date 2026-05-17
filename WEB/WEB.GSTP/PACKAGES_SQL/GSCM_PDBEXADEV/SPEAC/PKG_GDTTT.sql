--------------------------------------------------------
--  DDL for Package PKG_GDTTT
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_GDTTT" AS 


PROCEDURE QHPL_DINHNGHIA_LIST
(   vPhongbanID in number,  
	curReturn    OUT       sys_refcursor
);
PROCEDURE CANBO_GETBYDONVI_2CHUCVU
( vDonViID in number,
  vPhongbanID in number,
  vChucVu1 in varchar2,
  vChucVu2 in varchar2,
	curReturn    OUT       sys_refcursor
);
PROCEDURE CANBO_GETBYDONVI
( donviID in number,
  vChucDanh in varchar2,
	curReturn    OUT       sys_refcursor
);
PROCEDURE CANBO_GETBYPHONGBAN
( donviID in number,
vPhongbanID in number,
  vChucDanh in varchar2,
	curReturn    OUT       sys_refcursor
);
FUNCTION PHANCONGNGAUNHIEN
( vToaAnID in number,
  vTuNgay in date,
  vDenNgay in date,
  vNguoiNhap in varchar2,
  varrLoaiAn in varchar2,  
  vNguoithuchien number
)RETURN number;
 PROCEDURE DON_GETCHUAPCTP 
    (
      vToaAnID in number,
      vTuNgay in date,
      vDenNgay in date,
      vNoiChuyen in number,
      vTrangthai in number,  
      vIsThuLy in number,
      vNguoiNhap in varchar2,
      varrLoaiAn in varchar2,
      vHinhThuc in number,
      vNgayTL in date,      
      vSoThuLy in varchar2,
      vSoBAQD in varchar2,
        curReturn OUT sys_refcursor
    );
 PROCEDURE DON_GETTHEOKETQUAID
(
  vToaAnID in number,  
  vKetQuaID in number,
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in varchar2,
  vNguoiGui in varchar2,
 vNgayThuly in varchar2,
  vSoThuly in varchar2,
vThamphanID in number,
	curReturn OUT sys_refcursor
);
PROCEDURE DON_LICHSUPHANCONG
(   vToaAnID in number,  
    vSoToTrinh in varchar2,
    vNgayToTrinh in varchar2,
    vPC_TuNgay in varchar2,
    vPC_DenNgay in varchar2,
    vToaRaBAQD in number,
    vSoBAQD in varchar2,
    vNgayBAQD in varchar2,
    vNguoiGui in varchar2,
    vNgayThuly in varchar2,
    vSoThuly in varchar2,
    vThamphanID in number,  
    vLoaiPhanCong in number,
	curReturn OUT sys_refcursor
);

FUNCTION CHECK_DON_XOA_PHANCONG_NGAUNHIEN
(
    vKetQuaId in number
) RETURN NUMBER;

FUNCTION CHECK_DON_XOA_PHANCONG_CHIDINH
(
    vKetQuaId in number
) RETURN NUMBER;

PROCEDURE DON_CHECKDONTRUNG 
(
  vToaXetXu IN VARCHAR2,
  vNgayXetXu IN VARCHAR2,
  vSoBAQD IN VARCHAR2,
  vNguoiGui IN VARCHAR2,
  vIsBanAn IN VARCHAR2,
  curReturn OUT sys_refcursor
);
PROCEDURE DON_NHAN_SEARCH
( 
  vToaAnID in number,
  vToaChuyenID in number,
  vLoaiAn in number,
  vNguoiGui in varchar2,
  vSoCMND in varchar2,
  vTuNgay in date,
  vDenNgay in date,
  vHinhThucDon in number,
  vMaDon in varchar2,  
  vSoCongVan in varchar2,  
  vTrangthai in number,
	curReturn OUT sys_refcursor
);
PROCEDURE CONGVAN_SEARCH
( 
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in varchar2, 
  vTuNgay in date,
  vDenNgay in date,  
  vSoHieuDon in varchar2, 
  vDonViGui in varchar2,
  vSoCongVan in varchar2,
  vNgayCongVan in varchar2,
  vTraLoi in number,
  vNguoiNhap in varchar2,
  vLoaiVuviec in varchar2,
	curReturn OUT sys_refcursor
);
PROCEDURE LICHSUDON
( 
  vID in number,
	curReturn OUT sys_refcursor
);
PROCEDURE DANHSACHDONTRUNG
( 
  vID in number,
	curReturn OUT sys_refcursor
);
PROCEDURE DANHSACHDON_KEMTHE0
( 
  vID in number,
	curReturn OUT sys_refcursor
);
PROCEDURE DANHSACHDONTHEOVuAnID
( 
  vVuAnID in number,
	curReturn OUT sys_refcursor
);
PROCEDURE DANHSACHDONTHEOID
( 
  varrID in varchar2,
	curReturn OUT sys_refcursor
);
PROCEDURE DON_GETMAXTT
( vdonviID in number,
	curReturn    OUT       sys_refcursor
);
PROCEDURE DON_UPDATESOLUONGDON
( vDonID in number,
	curReturn    OUT       sys_refcursor
);
PROCEDURE DON_TL_GETMAXTT
( vdonviID in number,
  vYear in number,
  vLoaiAn in number,
	curReturn    OUT       sys_refcursor
);
PROCEDURE DON_TL_CHECK
( vdonviID in number,
  vYear in number,
  vLoaiAn in number,
  vTL_SO IN VARCHAR2,
  vHinhThucDon in number,
  vDonID in number,
  curReturn    OUT       sys_refcursor
);

PROCEDURE DON_CV_GETMAXTT
(   vdonviID in number,
    vYear in number,
    vNoiChuyen in number,   
    vTrangthaidon in number,
    curReturn    OUT       sys_refcursor
);

PROCEDURE DON_CV_CHECK
(   vdonviID in number,
    vNoiChuyen in number,   
    vTrangthaidon in number,
    vSO_CV in number,
    vYear in number,
	curReturn    OUT       sys_refcursor
);
--PROCEDURE DON_GETDONTRUNG 
--(
--  vCurrDonID in number,
--  vNguoiGui IN VARCHAR2,
--  vSoBAQD IN VARCHAR2,
--  vNgayBAQD IN VARCHAR2,
--  vToaXetXu IN VARCHAR2,
--  curReturn OUT sys_refcursor
--);
PROCEDURE DON_GETDONTRUNG 
(
  V_LOAIDON  in number,
  v_toaanid in number,
  vCurrDonID in number,
  vNguoiGui IN VARCHAR2,
  vSoBAQD IN VARCHAR2,
  vNgayBAQD IN VARCHAR2,
  vToaXetXu IN VARCHAR2,
  vCapXetXu IN VARCHAR2,
  vIsBanAn IN VARCHAR2,
  curReturn OUT sys_refcursor
);
PROCEDURE DON_GETCONGVAN 
(
  vTenDonVi IN VARCHAR2,
  vToaAn IN VARCHAR2,
  vSoCongVan IN VARCHAR2,
  vNgayCongVan IN VARCHAR2,
  vIsDVTrongNganh IN NUMBER,
  curReturn OUT sys_refcursor
);


PROCEDURE DON_GIAIQUYET_SEARCH
( 
  vToaAnID in number,
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in varchar2,
  vNguoiGui in varchar2,
  vSoCMND in varchar2,
  vTuNgay in date,
  vDenNgay in date,
  vHinhThucDon in number,
  vSoHieuDon in varchar2,
  vDiaChiTinh in number,
  vDiaChiHuyen in number,
  vDiaChiCT in varchar2,
  vSoCongVan in varchar2,
  vNgayCongVan in varchar2,
  vTraLoi in number,
  vNguoiNhap in varchar2,
  vNoiChuyen in number,
  vTrangthai in number,
  vCD_DONVIID in number,
  vNgaychuyenTu in date,
  vNgaychuyenDen in date,
  vArrSelectID in varchar2,
  vIsThuLy in number,
  vPhanloaixuly in number,
  vNgayThulyTu in date,
  vNgayThulyDen in date,
  vSoThuly in varchar2,
  vPhancongTTV in number,
  vloaian in number,-- them loai an
  IsGhepVuAn in number,
  PageIndex	in	int,
  PageSize	in	int,  
	curReturn OUT sys_refcursor
);
PROCEDURE BOSUNGTAILIEU
( 
  vID in number,
	curReturn OUT sys_refcursor
);

PROCEDURE YEUCAUBOSUNG
( 
    vID in number,
	curReturn OUT sys_refcursor
);

PROCEDURE GDTTT_DON_YEUCAU_BOSUNG_GETBYID
( 
    vID in number,
	curReturn OUT sys_refcursor
);
PROCEDURE  GDTTT_DON_YEUCAU_BOSUNG_UP_IN
( 
    v_id  in number DEFAULT 0,
    v_DONID in number,
    v_LANTHU in number,
    v_NGUOIKY in varchar2,
    v_SOTHONGBAO in varchar2,
    v_NGAYTHONGBAO in date,
    v_CD_TA_LYDO_ISBAQD in number,
    v_CD_TA_LYDO_ISXACNHAN in number,
    v_CD_TA_LYDO_ISKHAC in number,
    v_NOIDUNG in varchar2,
    v_KETQUA in number,
    v_NOIDUNGKQ in varchar2,
    v_NGAYBOSUNG in date,
    v_NGAYTAO in date,
    v_NGUOITAO     in varchar2
);
PROCEDURE  GDTTT_DON_YEUCAU_BOSUNG_DEL
( 
    v_id  in number DEFAULT 0
);
PROCEDURE DON_YEUCAU_GETMAXTT
( vdonviID in number,
  vYear in number,
  vLoaiAn in number,
	curReturn    OUT       sys_refcursor
);
PROCEDURE DON_YEUCAU_GETMAXLANTHU
( 
    vdonID in number,
	curReturn    OUT       sys_refcursor
);

PROCEDURE CHECK_YEUCAU_LANTHUTRUNG
( 
    vID in number,
    vdonID in number,
    vLanThu in number,
	curReturn    OUT       sys_refcursor
);

PROCEDURE CHECK_YEUCAU_SOTHONGBAO_TRUNG
( 
    vID in number,
    vdonID in number,
    vSoThongBao in varchar2,
	curReturn    OUT       sys_refcursor
);

PROCEDURE CHECK_YEUCAU_NGAYTHONGBAO
( 
    vID in number,
    vdonID in number,
    vNgayThongBao in varchar2,
    vLanThu in number,
	curReturn    OUT       sys_refcursor
);

PROCEDURE CHECK_YEUCAU_SOTB_NGAYTB
( 
    vdonID in number,
    vSoThongBao in varchar2,
    vNgayThongBao in varchar2,
	curReturn    OUT       sys_refcursor
);

PROCEDURE VUAN_XETXU_SEARCH
( 
  vToaAnID in number,
  vPhongBanID  in number,
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in varchar2,
  vNguoiGui in varchar2,
  vCoquanchuyendon in varchar2,
  vNguyendon in varchar2,
  vBidon in varchar2,
  vLoaiAn in number,
  vThamtravien in number,
  vLanhdao in number,
  vThamphan in number,
  vQHPLID in number,
  vQHPLDNID in number,
  vTraloidon in varchar2,
  vLoaiCVID in number,
  vNgayThulyTu in date,
  vNgayThulyDen in date,
  vSoThuly in varchar2, 
  vTrangthai in number,  
  vKetquaxetxu in number,  
  PageIndex	in	int,
  PageSize	in	int,  
	curReturn OUT sys_refcursor
);
PROCEDURE VUAN_PHANCONGTTV
( 
  vToaAnID in number,
  vPhongBanID  in number,
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in varchar2, 
  vNguyendon in varchar2,
  vBidon in varchar2,
  vLoaiAn in number,
  vThamtravien in number,
  vLanhdao in number,
  vThamphan in number,
  vQHPLID in number,
  vQHPLDNID in number,
  vNgayThulyTu in date,
  vNgayThulyDen in date,
  vSoThuly in varchar2, 
  vTrangthai in number,  
  v_ISXINANGIAM in number,
  v_GDT_ISXINANGIAM in number,
  v_GIAIDOAN in number,
  PageIndex	in	int,
  PageSize	in	int,  
  curReturn OUT sys_refcursor
);
PROCEDURE TRALOIDON_DANHSACH
( 
  vVuAnID in number,
	curReturn OUT sys_refcursor
);
PROCEDURE THONGKE_TONGHOP
( 
  vToaAnID in number,
  vPhongBanID  in number,
  vLoaiAn number,
  vLanhdaoVu number,
  vThamTraVien number,
	curReturn OUT sys_refcursor
);
PROCEDURE THONGKE_ANQUOCHOI_THOIHIEU
( 
  vToaAnID in number,
  vPhongBanID  in number,
  vLoaiAn number,
  vLanhdaoVu number,
  vThamTraVien number,
  vAnQuocHoi number,
  vAnThoiHieu number,
	curReturn OUT sys_refcursor
);
PROCEDURE THONGKE_CHUNG
( 
  vToaAnID in number,
  vPhongBanID  in number,
  vLoaiAn number,
  vLanhdaoVu number,
  vThamTraVien number,
	curReturn OUT sys_refcursor
);
PROCEDURE BAOCAO_THONGKE_THULY
	(
  vToaAnID in number,
  vPhongBanID  in number,
  vTuNgay in date,
  vDenNgay in date,
  curReturn OUT SYS_REFCURSOR
	);

PROCEDURE FILL_BAOCAO_THONGKE_THULY
	(
  vToaAnID in number,
  vPhongBanID  in number,
  vTuNgay in date,
  vDenNgay in date,
  vLoaiAn number,
  vToaRaBA_ID number,
  v_TT number,
  v_TKTL IN OUT R_GDT_TKTLGQD
	);
PROCEDURE BAOCAO_THONGKE_CHITIEU
	(
  vToaAnID in number,
  vPhongBanID  in number,
  vTuNgay in date,
  vDenNgay in date,
  vLanhDaoID number,
  vThamtravienID number,
  curReturn OUT SYS_REFCURSOR
	);  
  PROCEDURE BAOCAO_THONGKE_THULY_QH
	(
  vToaAnID in number,
  vPhongBanID  in number,
  vTuNgay in date,
  vDenNgay in date,
  curReturn OUT SYS_REFCURSOR
	);
  PROCEDURE FILL_BAOCAO_THONGKE_THULY_QH
	(
  vToaAnID in number,
  vPhongBanID  in number,
  vTuNgay in date,
  vDenNgay in date,
  vLoaiAn number,
  vToaRaBA_ID number,
  v_TT number,
  v_TKTL IN OUT r_GDT_TKTLGQD_QH
	);
  PROCEDURE BAOCAO_THONGKE_XETXU
	(
  vToaAnID in number,
  vPhongBanID  in number,
  vTuNgay in date,
  vDenNgay in date,
  curReturn OUT SYS_REFCURSOR
	);
  PROCEDURE FILL_BAOCAO_THONGKE_XETXU
	(
  vToaAnID in number,
  vPhongBanID  in number,
  vTuNgay in date,
  vDenNgay in date,
  vLoaiAn number,
  v_TT number,
  v_TKTL IN OUT R_GDT_TKTLXX
	);
PROCEDURE THONGKE_THEO_THAMPHAN
	(
  vToaAnID in number,
  vThamphanID  in number,
  vTuNgay in date,
  vDenNgay in date,
  curReturn OUT SYS_REFCURSOR
	);  
    PROCEDURE FILL_THONGKE_THEO_THAMPHAN
	(
  vToaAnID in number,
  vThamphanID  in number,vThamPhan_ChuToa_HD5_TT in number,
  vTuNgay in date,
  vDenNgay in date,
  vLoaiAn number,
  v_TT number,
  v_TKTL IN OUT R_GDTTT_BCTHAMPHAN
	);
END PKG_GDTTT;

/
