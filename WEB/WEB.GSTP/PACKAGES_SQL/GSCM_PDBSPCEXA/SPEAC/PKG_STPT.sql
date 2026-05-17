--------------------------------------------------------
--  DDL for Package PKG_STPT
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_STPT" AS
PROCEDURE GET_TONG_SO_TOI
(
  VBANANID IN VARCHAR2,
  VBICANID IN VARCHAR2,
  CurReturn OUT sys_refcursor 
);
PROCEDURE GET_CT_TAMGIAM
(
  VVUAN_ID IN VARCHAR2,
  VHIEULUCTUNGAY IN VARCHAR2,
  CurReturn OUT sys_refcursor 
);
PROCEDURE DM_CANBO_GETALLTHUKY_TTV_CV
(
  VDONVIID IN VARCHAR2,
  CurReturn OUT sys_refcursor 
);
PROCEDURE  DM_CANBO_GETBYDONVI_byCHUCVU 
(
  vDonViID in number,
  v_VuAnID in number,
  CurReturn OUT sys_refcursor 
);
PROCEDURE    SOLUONGDONKK_TOAKHAC 
(
    v_toa_an_id IN VARCHAR2,
    curReturn    OUT   sys_refcursor
);
PROCEDURE  GAIDOAN_UP
( 
    V_LOAI_AN IN VARCHAR2,
    V_VUAN_DONID IN NUMBER,
    V_MAGIAIDOAN IN NUMBER,
    V_TOAANID IN NUMBER,
    V_TOAPHUCTHAMID IN NUMBER,
    V_TOACAPCAOID IN NUMBER,
    V_TOANTOICAOID IN NUMBER,
    V_PHONGBANID IN NUMBER
);
PROCEDURE  GAIDOAN_DELETE
( 
    V_LOAI_AN IN VARCHAR2,
    V_VUAN_DONID IN NUMBER,
    V_MAGIAIDOAN IN NUMBER
);
PROCEDURE  GAIDOAN_IN_UP
( 
    V_LOAI_AN IN VARCHAR2,
    V_VUAN_DONID IN NUMBER,
    V_MAGIAIDOAN IN NUMBER,
    V_TOAANID IN NUMBER,
    V_TOAPHUCTHAMID IN NUMBER,
    V_TOACAPCAOID IN NUMBER,
    V_TOANTOICAOID IN NUMBER,
    V_PHONGBANID IN NUMBER
);
PROCEDURE  GAIDOAN_IN_UP_XXLAI_PHUCTHAM
( 
    V_LOAI_AN IN VARCHAR2,
    V_VUAN_DONID IN NUMBER,
    V_MAGIAIDOAN IN NUMBER,
    V_TOAANID IN NUMBER,
    V_TOAPHUCTHAMID IN NUMBER,
    V_TOACAPCAOID IN NUMBER,
    V_TOANTOICAOID IN NUMBER,
    V_PHONGBANID IN NUMBER
);
PROCEDURE  DM_CANBO_GETBYDONVI_CHUCDANH
(
  vDonViID in number,
  vChucDanh in varchar2,
  CurReturn OUT sys_refcursor 
);
PROCEDURE  CHECK_CHUCDANH_THUKY_USER
(
  vDonViID in number,
  vChucDanh in varchar2,
  vCanBoID in number,
  CurReturn OUT sys_refcursor 
);
PROCEDURE  DM_CANBO_GETBYDONVI_2CHUCVU 
(
  vDonViID in number,
  vChucVu1 in varchar2,
  vChucVu2 in varchar2,
  CurReturn OUT sys_refcursor 
);
PROCEDURE  DM_CANBO_GETBYDONVI_3CHUCVU 
(
  vDonViID in number,
  vChucVu1 in varchar2,
  vChucVu2 in varchar2,
  vChucVu3 in varchar2,
  CurReturn OUT sys_refcursor 
);
PROCEDURE DM_CANBO_GETBYDONVI
(
  VDONVIID IN VARCHAR2,
  CurReturn OUT sys_refcursor 
);
PROCEDURE DM_TOAAN_GETBY_PARENT
( 
    V_CAPXX in VARCHAR2,
    V_DONVIID in VARCHAR2,
    V_LOAITOA in VARCHAR2,
	curReturn    OUT       sys_refcursor
);
PROCEDURE DM_TOAAN_GETBY_PARENT_HC
( 
    V_CAPXX in VARCHAR2,
    V_DONVIID in VARCHAR2,
    V_LOAITOA in VARCHAR2,
	curReturn    OUT       sys_refcursor
);
PROCEDURE   DM_CANBO_GETALLTHUKY_TTV
(
  VDONVIID IN VARCHAR2,
  VCHUCDANH IN VARCHAR2,
  CurReturn OUT sys_refcursor 
);
PROCEDURE DM_CANBO_GETALL
(
  VDONVIID IN VARCHAR2,
  CurReturn OUT sys_refcursor 
);
FUNCTION CHUYENAN_KTT_QUYEN_UPDATE
(
 V_ID VARCHAR2,
 V_LOAI_AN VARCHAR2
)
RETURN SYS_REFCURSOR;
PROCEDURE DM_TOAAN_GETBY_PARENT_CHECK
( 
    V_CANBOID in VARCHAR2,
    V_CAPXX in VARCHAR2,
    V_DONVIID in VARCHAR2,
    V_LOAITOA in VARCHAR2,
	curReturn    OUT       sys_refcursor
);
PROCEDURE DM_PCA_BYTOAAN
( 
    V_DONVIID in VARCHAR2,
	curReturn    OUT       sys_refcursor
);
PROCEDURE DM_TOAAN_DIABAN
( 
    V_CANBOID in VARCHAR2,
    V_DONVIID in VARCHAR2,
    curReturn    OUT       sys_refcursor
);
PROCEDURE PCA_AND_DIABAN
( 
    V_DONVIID in VARCHAR2,
    vCanboID  in VARCHAR2,
    vToaanID  in VARCHAR2,
    curReturn    OUT       sys_refcursor
);

PROCEDURE PCA_AND_DIABAN_IN_UP
( 
    V_DONVIID in NUMBER,
    vCurrCanboID  in NUMBER,
    vOLDCanboID  in NUMBER,
    vToaanID  in NUMBER,
    vNGAYPC    in DATE
);

 PROCEDURE GETBY_TAMGIAM_10NGAY
( 
    V_LOAITOA in VARCHAR2,
    V_DONVIID in VARCHAR2,
    PageIndex	in	int,
    PageSize	in	int,
	curReturn    OUT       sys_refcursor
);
PROCEDURE Get_VUAN_by_VUANID_NGUOITAO
( 
    vVuAnID in number,
    vNguoiTao  in NVARCHAR2,
    curReturn    OUT       sys_refcursor
);
PROCEDURE  ADS_FILE_GETBYDON
(
  vLoaiAn in number,
  vMaGiaiDoan number,
  vDonID number,
  curReturn    OUT       sys_refcursor
);
END PKG_STPT;
