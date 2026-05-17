--------------------------------------------------------
--  DDL for Package PKG_TUPHAP_QUANTRI
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_TUPHAP_QUANTRI" AS
FUNCTION TUPHAP_INFOR_HIS_DS
(
  vGet_chil number,
  V_DONVI_THA_ID in nvarchar2,
  PageIndex	in	int,
  PageSize	in	int
  )
RETURN SYS_REFCURSOR;
FUNCTION QT_DONVI_DS
(
 vGet_chil number,
  vdonviID in number,
  PageIndex	in	int,
  PageSize	in	int
  )
RETURN SYS_REFCURSOR;
PROCEDURE QT_NGUOIDUNG_MENU_CHECK
( vMenuPath in nvarchar2,
  vUserID number,
	curReturn    OUT       sys_refcursor
);
PROCEDURE        QT_CHUONGTRINH_GETBYUSER
( 
    vUSERID in number,
	curReturn    OUT       sys_refcursor
);
PROCEDURE QT_NHOMNGUOIDUNG_MENU_GETBY
(
    vNhomID in number,
	curReturn    OUT       sys_refcursor
);
PROCEDURE QT_NHOMNGUOIDUNG_SEARCHBY
( vLOAITOA in varchar2,
  tennhom in nvarchar2,
  curReturn    OUT       sys_refcursor
);
PROCEDURE        QT_NGUOIDUNG_SEARCH
( vdonviID in number,
  vDonvi nvarchar2,
  vLoaiUser number,
  vUserName nvarchar2,
  vHoten nvarchar2,
  curReturn    OUT       sys_refcursor
);
PROCEDURE  QT_NGUOIDUNG_SEARCH_CLIENT
( vdonviID in number,
  vDonvi nvarchar2,
  vLoaiUser number,
  vUserName nvarchar2,
  vHoten nvarchar2,
  curReturn    OUT       sys_refcursor
);
PROCEDURE  DM_TOAAN_GETBY 
(    donviID in number,
	curReturn    OUT       sys_refcursor
);
PROCEDURE  DM_DATAITEM_GETBYGROUPNAME
( vGroupName in nvarchar2,
	curReturn    OUT       sys_refcursor
);
PROCEDURE  TUPHAP_NGUOIDUNG_CHECKLOGIN
(   
   V_USER_NAME IN NVARCHAR2,
   V_PASSWORD IN NVARCHAR2,
   CURRETURN  OUT SYS_REFCURSOR
);
PROCEDURE  SYN_CHECK_INS_AUTO;
PROCEDURE TUPHAP_INFOR_HIS_INS
    (
    V_DONVI_THA_ID	in	NUMBER,
    V_USERID	in	NUMBER,
    V_TEN_TK_THU_HUONG	in	VARCHAR2,
    V_TEN_DONVI	in	VARCHAR2,
    V_DIA_CHI	in	VARCHAR2,
    V_DIEN_THOAI	in	VARCHAR2,
    V_EMAIL	in	VARCHAR2,
    V_MA_DINH_DANH	in	VARCHAR2,
    V_SO_TK	in	VARCHAR2,
    V_TEN_KHO_BAC	in	VARCHAR2,
    V_MA_KHO_BAC	in	VARCHAR2,
    V_MA_LH_THU	in	VARCHAR2,
    V_TEN_LH_THU	in	VARCHAR2,
    V_NGUOI_SUA	in	VARCHAR2
    );
END PKG_TUPHAP_QUANTRI;

/
