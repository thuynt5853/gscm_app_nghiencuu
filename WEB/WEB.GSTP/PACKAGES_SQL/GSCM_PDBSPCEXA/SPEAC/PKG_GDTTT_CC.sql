--------------------------------------------------------
--  DDL for Package PKG_GDTTT_CC
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_GDTTT_CC" AS
PROCEDURE INS_UP_TRUNG
(
 V_DON_TRUNG	IN VARCHAR2,
 V_DONID_MOI	IN VARCHAR2,
 V_LOAIAN IN VARCHAR2
);
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
PROCEDURE GDTTT_LOAD_DONVI
( 
  V_LOAIANID IN varchar2,
  V_TOAANID IN varchar2,
  curReturn OUT sys_refcursor
);
PROCEDURE GDTTT_AHS_GETALLBYLOAIDS
( 
  VDONID in number,
  type_ds in number, 
  curReturn OUT sys_refcursor
);
PROCEDURE GDTTT_DS_TOIDANH_GETALL
( 
   VDONID in number
  , vTucachtotung varchar2, isDauVu in number
  , curReturn OUT sys_refcursor
);
PROCEDURE GDTTT_AHS_GETBICAOKN_BYNGUOIKN
( 
  VDONID in number,
  vNguoiKhieuNaiID in number,
  curReturn OUT sys_refcursor
);
PROCEDURE  GDTTT_VUANDS_GETBYDON
(
  VDONID in number,
  vTucachtotung in nvarchar2,
  CurReturn OUT sys_refcursor 
);
FUNCTION GDTTT_DON_CC_REID
RETURN NUMBER;
FUNCTION GDTTT_VUAN_REID
RETURN NUMBER;
PROCEDURE SO_THU_LY
(
  V_TOAANID IN VARCHAR2,
  V_LOAI_VB IN VARCHAR2,
  V_BAQD_LOAIAN IN VARCHAR2,
  V_SOTL OUT NUMBER
);
PROCEDURE DON_TL_CHECK_CC
(   vdonviID in number,
    vYear in number,
    vLoaiAn in number,
    vTL_SO in varchar2,
    vHinhThucDon in number,
    vDonID in number,
	curReturn    OUT       sys_refcursor
);
PROCEDURE UP_VANTHU_V_NULL
(
    V_DON_ID IN VARCHAR2
);
PROCEDURE GDTTTT_HOSO_INPHIEU
( 
  vToaAnID in number,
  vPhieuID in number,
  curReturn OUT sys_refcursor
);
END PKG_GDTTT_CC;
