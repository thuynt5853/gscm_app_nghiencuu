--------------------------------------------------------
--  DDL for Package PKG_GDTTT_GET
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_GDTTT_GET" AS 

FUNCTION GET_DONVI_TINH
(
 V_CAPCHAID in varchar2
)
RETURN SYS_REFCURSOR;
FUNCTION GET_DONVI_HUYEN
(
 V_TOAANID in varchar2
)
RETURN SYS_REFCURSOR;
PROCEDURE DM_TOAAN_GET_DonViBYCC
(
     vID in number
    , CurReturn OUT sys_refcursor 
); 
procedure CANBO_GETBYDONVI_LANHDAO
( vDonViID in number,
  vPhongbanID in number,
  vChucVu in varchar2,
  curReturn    OUT       sys_refcursor
);
PROCEDURE   PERMI_MENU_BAOCAO
( vMenuPath in varchar2,
  vUserID number,
  curReturn    OUT       sys_refcursor
);
PROCEDURE  GET_TP_VU_GDKT
(
  V_TOAANID in VARCHAR2,
  V_PHONGBANID in VARCHAR2,
  CurReturn OUT sys_refcursor 
);
PROCEDURE  GET_PHUTRACH_TP_BC
(
  vThamphan_id IN NUMBER,
  CurReturn OUT sys_refcursor 
);
PROCEDURE PHONGBANID_GET
(
  V_TOAANID in VARCHAR2,
  V_PHONGBANID in VARCHAR2,
  curReturn    OUT       sys_refcursor
);
PROCEDURE DM_TOAAN_GETBYNOTCUR_ST
(
  curReturn    OUT       sys_refcursor
);
PROCEDURE  GDTTT_XXGDTTT_SEARCHBYTP
( 
  vToaAnID in number,
  vPhongBanID  in number,
  vLoaiAn in number,
  vThamphan in number,
  vTuNgay in date,
  vDenNgay in date,
  vTrangthai in number,
  vKetquaxetxu in number,  
  curReturn OUT sys_refcursor
);
PROCEDURE GDTTTT_VUAN_GQD_SEARCH_BYTP
( 
  vToaAnID in number,
  vPhongBanID  in number,
  vLoaiAn in number,
  vThamphan in number,
  vGQD_TuNgay in date,
  vGQD_DenNgay in date,
  vKetquathuly in number,
  curReturn OUT sys_refcursor
);
PROCEDURE DM_TOAAN_GETBYCAPCHAID
(
     vCapChaID in number
    , CurReturn OUT sys_refcursor 
);
PROCEDURE GDTTT_AHS_GETALLBYLOAIDS
( 
    VVUANID IN NUMBER,
    TYPE_DS IN NUMBER, 
    CURRETURN OUT SYS_REFCURSOR
);
PROCEDURE GET_YEAR_THEO_TP 
(  
 vThamPhanID in number,
 vToaAnID in number,
 curReturn    OUT       sys_refcursor
);
PROCEDURE DM_CANBO_PB_CHUCDANH 
(  
 vThamPhanID in number,
 vToaAnID in number,
 curReturn    OUT       sys_refcursor
);
PROCEDURE   GDTTT_GETTTT_THEOTP
(  
 vThamPhanID in number,
 vToaAnID in number,
 curReturn    OUT       sys_refcursor
);
PROCEDURE  GDTTT_VUAN_LOAD_TT
( 
  vThamPhanID in number,
  vVuAnID in number,
  curReturn OUT sys_refcursor
);
PROCEDURE  GET_PHUTRACH_TP
(
  vToaAnID in VARCHAR2,
  vThamphan_id IN NUMBER,
  CurReturn OUT sys_refcursor 
);
FUNCTION GET_SELECT_TP5
(
      v_VuAnID in number,
      v_Loai_hd in number,
      vPhongBanID in number,--hoi dong 5
      vToaAnID in number, --hoi dong 5
      vLoaiAn in number--hoi dong 5
)
RETURN SYS_REFCURSOR;
FUNCTION GET_SELECT_TP
(
     v_VuAnID in number,
      v_Loai_hd in number,
      vPhongBanID in number,
      vToaAnID in number, 
      vLoaiAn in number
)
RETURN SYS_REFCURSOR;
 PROCEDURE GET_BOLUAT_TOIDANH
(
 curReturn OUT SYS_REFCURSOR
);
END PKG_GDTTT_GET;

/
