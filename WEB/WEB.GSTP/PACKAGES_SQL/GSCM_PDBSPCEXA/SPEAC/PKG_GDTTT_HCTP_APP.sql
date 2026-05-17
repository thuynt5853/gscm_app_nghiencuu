--------------------------------------------------------
--  DDL for Package PKG_GDTTT_HCTP_APP
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_GDTTT_HCTP_APP" AS

FUNCTION TLXXGDT_GETMAXTT
(   vToaanid in number,
    vYear in number,
    vLoaian in number
)RETURN NUMBER;

FUNCTION CHECK_SOVANBAN
(  
    vToaAnID in number,
    vPhongbanID in number,
    vLoaiSO  in varchar2,
    vSoVB in varchar2,
    vNgayVB in varchar2
)RETURN NUMBER;

PROCEDURE QUANLYSOVB_HCTP
( 
    vToaAnID in number,
    vPhongbanID in number,
    vLoaiSO  in varchar2,
    vSoVB in varchar2,
    vNgayVB in varchar2,
    vNgayVB_den in varchar2,
    PageIndex	in	int,
    PageSize	in	int,
	curReturn OUT sys_refcursor
);

PROCEDURE DON_CVCHUYEN_CHECK
(   vSOPHATHANH_ID in number,   
	curReturn OUT sys_refcursor
);

FUNCTION SOVANBAN_INSERT
(  
    v_ToaAnID in number,
    v_PhongbanID in number,
    v_MASO   IN VARCHAR2,
    v_SOVB     IN VARCHAR2,
    v_NGAYVB    IN VARCHAR2,
    v_NGUOIKY  IN VARCHAR2,
    V_NGUOITAO IN VARCHAR2
)RETURN NUMBER;

FUNCTION SOPHATHANH_DON_INSERT
(  
    v_PHATHANHID IN NUMBER,
    v_DONID     IN NUMBER,
    V_NGUOITAO IN VARCHAR2
)RETURN NUMBER;

FUNCTION SOVANBAN_UPDATE
(   
    v_SOPHATHANH_ID in number, 
    v_SOVB     IN VARCHAR2,
    v_NGAYVB    IN VARCHAR2,
    v_NGUOIKY  IN VARCHAR2,
    V_NGUOISUA IN VARCHAR2
)RETURN NUMBER;

FUNCTION SOVANBAN_DEL_ALL
(  
    v_SOPHATHANH_ID in number
)RETURN NUMBER;

FUNCTION SOVANBAN_DEL_ONE
(  
    v_SOVB_DONID in number
)RETURN NUMBER;

PROCEDURE SUAVANBAN_SEARCH
( 
    vSOPHATHANH_ID in number,   
	curReturn OUT sys_refcursor 
);



PROCEDURE  DM_CANBO_GETBYDONVI_2CHUCVU 
(
  vDonViID in number,
  vChucVu1 in varchar2,
  vChucVu2 in varchar2,
  CurReturn OUT sys_refcursor 
);
PROCEDURE CHECK_DONTRUNGID
( 
    V_ID in number,
    V_IS_DONTRUNG OUT number
);
PROCEDURE CANBO_GETBYDONVI
( 
   v_CANBO_ID in varchar2,
   donviID in number,
   vChucDanh in varchar2,
   curReturn    OUT       sys_refcursor
);
PROCEDURE SUACONGVAN_SEARCH
( 
   vToaAnID in number,
    vSoCongVan in varchar2,
    vNgayCongVan in varchar2,
	curReturn OUT sys_refcursor
);
PROCEDURE CANBO_GETBYDONVI_XX
( donviID in number,
  vChucDanh in varchar2,
	curReturn    OUT       sys_refcursor
);
PROCEDURE  GDTTT_VUAN_GETALLCBTHEOPB
(  vPhongBanID in number
, vToaAnID in number, vChucDanh in varchar2
,	curReturn    OUT       sys_refcursor
);
PROCEDURE DON_SEARCH
( 
    V_NDBD_VALUE VARCHAR2,
    V_NDBD_TEXT VARCHAR2,
    --van thu don den----
    V_DONVI_CHUYEN_ID in  VARCHAR2,
    V_TRANGTHAICHUYEN in	VARCHAR2,
    V_LOAI_VB	in	VARCHAR2,
    V_SODEN_TU	in	VARCHAR2,
    V_SODEN_DEN	in	VARCHAR2,
    V_NGAY_FROM	in VARCHAR2,
    V_NGAY_TO	in VARCHAR2,
    V_NGUOI_GUI_BT	in	VARCHAR2,
    --van thu don den end----
    v_ID_USER VARCHAR2,
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
    vCD_TA_TRANGTHAI in number,
    vCD_TENDONVI in varchar2,
    vNgaychuyenTu in date,
    vNgaychuyenDen in date,
    vArrSelectID in varchar2,
    vIsThuLy in number,
    vPhanloaixuly in number,
    vNgayThulyTu in date,
    vNgayThulyDen in date,
    vSoThuly in varchar2,
    vChidao in number,
    vTraigiam in number,
    vTBQuahan in number,
    vNgayQuahan in date,
    vThamphanID in number,
    vThamtravienID in number,
    vLoaiCVID in number,
    vNgayNhapTu in date,
    vNgayNhapDen in date,
    vIsDonGoc in number,
    vIsTuHinh in number,
    vLoaiAn in number,
    vCVPC_So in varchar2,
    vCVPC_Ngay in varchar2,
    vCVPC_TenCQ in varchar2,
    vGuitoiCA_TA in number,
    vLOAI_GDTTT in number,

    PageIndex	in	int,
    PageSize	in	int,
    curReturn OUT sys_refcursor
);
PROCEDURE DON_SEARCH_TOTAL
( 
    V_NDBD_VALUE VARCHAR2,
    V_NDBD_TEXT VARCHAR2,
    --van thu don den----
    V_DONVI_CHUYEN_ID in  VARCHAR2,
    V_TRANGTHAICHUYEN in	VARCHAR2,
    V_LOAI_VB	in	VARCHAR2,
    V_SODEN_TU	in	VARCHAR2,
    V_SODEN_DEN	in	VARCHAR2,
    V_NGAY_FROM	in VARCHAR2,
    V_NGAY_TO	in VARCHAR2,
    V_NGUOI_GUI_BT	in	VARCHAR2,
    --van thu don den end----
    v_ID_USER VARCHAR2,
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
    vCD_TA_TRANGTHAI in number,
    vCD_TENDONVI in varchar2,
    vNgaychuyenTu in date,
    vNgaychuyenDen in date,
    vArrSelectID in varchar2,
    vIsThuLy in number,
    vPhanloaixuly in number,
    vNgayThulyTu in date,
    vNgayThulyDen in date,
    vSoThuly in varchar2,
    vChidao in number,
    vTraigiam in number,
    vTBQuahan in number,
    vNgayQuahan in date,
    vThamphanID in number,
    vThamtravienID in number,
    vLoaiCVID in number,
    vNgayNhapTu in date,
    vNgayNhapDen in date,
    vIsDonGoc in number,
    vIsTuHinh in number,
    vLoaiAn in number,
    vCVPC_So in varchar2,
    vCVPC_Ngay in varchar2,
    vCVPC_TenCQ in varchar2,
    vGuitoiCA_TA in number,
    vLOAI_GDTTT in number,
    PageIndex	in	int,
    PageSize	in	int,
    curReturn OUT sys_refcursor
);
END PKG_GDTTT_HCTP_APP;
