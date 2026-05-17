--------------------------------------------------------
--  DDL for Package PKG_HOSO_PT
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_HOSO_PT" AS
PROCEDURE DELETE_HOSO_PT_ID
(  
 V_LOAIAN  IN NUMBER,
  V_ID	IN	NUMBER  
);
PROCEDURE  HOSO_PT_LIST_ID
( 
  V_LOAIAN  IN NUMBER,
  V_ID IN VARCHAR2,
  curReturn OUT sys_refcursor
);
PROCEDURE   HOSO_PT_LIST 
(
    V_LOAIAN  IN NUMBER,
    V_VUANID IN NUMBER,
    PageIndex	in	int, 
    PageSize	in	int,
    CurReturn OUT sys_refcursor
);
PROCEDURE  HOSO_PT_INS_UP
( 
 V_ID IN NUMBER,
    V_LOAIAN IN NUMBER,
    V_VUANID IN NUMBER,
    V_LOAI_CN IN NUMBER,
    V_CANBOID IN NUMBER,
    V_NGAY_NC  in DATE,
    V_DV_GUI_NHAN IN NUMBER,
    V_NGUOI_NHAN_VKS IN VARCHAR2,
    V_GHICHU IN VARCHAR2,
    V_NGUOITAO IN VARCHAR2,
    V_LOAI_DV IN NUMBER,
    V_TOAANID IN NUMBER,
    V_TOA_GIAIQUYET_ID IN NUMBER
);
PROCEDURE  DM_CANBO_QLHS_PT
(
  vDonViID in VARCHAR2,
  CurReturn OUT sys_refcursor 
);
PROCEDURE   HOSO_PT_LIST_EXORT
(
    V_LOAIAN  IN NUMBER,
    V_VUANID IN NUMBER,
    CurReturn OUT sys_refcursor
) ;
PROCEDURE GETBY_COUNT_VKS
( 
    V_DONVIID in VARCHAR2,
	curReturn    OUT       sys_refcursor
);
PROCEDURE GETBY_COUNT_VKSS
( 
    V_DONVIID in VARCHAR2,
     V_CAPXX in VARCHAR2,
	curReturn    OUT       sys_refcursor
);
FUNCTION HOSO_PT_VKS_TABLE
( 
    V_SONGAY_QUAHAN in VARCHAR2,
    V_TINH_DEN_NGAY in VARCHAR2,
    V_LOAIAN in VARCHAR2,
    V_TUNGAY in VARCHAR2,
    V_DENNGAY in VARCHAR2,
    V_TENDUONGSU in VARCHAR2,
    V_CAPXX in VARCHAR2,
    V_DONVIID in VARCHAR2
)RETURN T_HOSOLUU_VKS;
 PROCEDURE HOSO_PT_LIST_VKS
( 
    V_SONGAY_QUAHAN in VARCHAR2,
    V_TINH_DEN_NGAY in VARCHAR2,
    V_LOAIAN in VARCHAR2,
    V_TUNGAY in VARCHAR2,
    V_DENNGAY in VARCHAR2,
    V_TENDUONGSU in VARCHAR2,
    V_CAPXX in VARCHAR2,
    V_DONVIID in VARCHAR2,
    PageIndex	in	int,
    PageSize	in	int,
	curReturn    OUT       sys_refcursor
);
PROCEDURE HOSO_PT_LIST_VKS_EXPORT
( 
    V_SONGAY_QUAHAN in VARCHAR2,
    V_TINH_DEN_NGAY in VARCHAR2,
    V_LOAIAN in VARCHAR2,
    V_TUNGAY in VARCHAR2,
    V_DENNGAY in VARCHAR2,
    V_TENDUONGSU in VARCHAR2,
    V_CAPXX in VARCHAR2,
    V_DONVIID in VARCHAR2,
    PageIndex	in	int,
    PageSize	in	int,
	curReturn    OUT       sys_refcursor
);

 PROCEDURE SP_CANBO_THULY_PT
(
  vDonViID in VARCHAR2,
  CurReturn OUT sys_refcursor 
);
PROCEDURE HOSO_PT_LIST_V2
(
    V_LOAIAN  IN NUMBER,
    V_VUANID IN NUMBER,
    PageIndex	in	int, 
    PageSize	in	int,
    CurReturn OUT sys_refcursor
);

END PKG_HOSO_PT;

/
