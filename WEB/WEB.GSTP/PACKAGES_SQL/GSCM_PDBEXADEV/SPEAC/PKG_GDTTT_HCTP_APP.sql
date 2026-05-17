--------------------------------------------------------
--  DDL for Package PKG_GDTTT_HCTP_APP
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_GDTTT_HCTP_APP" AS

FUNCTION DELETE_XULYLAI_DONTLM
(  
    vDON_ID in number,
    vNguoiXoa  IN VARCHAR2
)RETURN NUMBER;

FUNCTION DELETE_SOTHULY_DON
(  
    vDON_ID in number,
    vLydo  IN VARCHAR2,
    vNguoiXoa  IN VARCHAR2,
    in_OBJECT     IN CLOB
)RETURN NUMBER;

FUNCTION TLXXGDT_GETMAXTT
(   vToaanid in number,
    vYear in number,
    vLoaian in number
)RETURN NUMBER;

PROCEDURE QLSOVB_GETMAXTT
(   vdonviID in number,    
    vPhongbanid in number,
    vYear in number,
    vLoaiso in varchar2,
	curReturn    OUT       sys_refcursor
);

FUNCTION CHECK_DON_LUUSO
(  
    vToaAnID in number,
    vPhongbanID in number,
    vLoaiSO  in varchar2,
    vDONID in number
)RETURN NUMBER;
FUNCTION CHECK_DON_LUUSO_CANHAN
(  
    vToaAnID in number,
    vPhongbanID in number,
    vUSERID  in number,
    vLoaiSO  in varchar2,
    vDONID in number
)RETURN NUMBER;

FUNCTION CHECK_SOVANBAN_CANHAN
(  
    vToaAnID in number,
    vPhongbanID in number,
    vUSERID  in number,
    vLoaiSO  in varchar2,
    vSoVB in varchar2,
    vNgayVB in varchar2
)RETURN NUMBER;

FUNCTION CHECK_SOVANBAN
(  
    vToaAnID in number,
    vPhongbanID in number,
    vLoaiSO  in varchar2,
    vSoVB in varchar2,
    vNgayVB in varchar2
)RETURN NUMBER;

PROCEDURE GET_THAMPHAN
( 
    vToaAnID in number,
    vPhongbanID in number,
    vLoaiSO  in varchar2,
    arrDonid  in varchar2,
    v_SOTOTRINH in varchar2,
    v_NGAYTOTRINH in varchar2,
	curReturn OUT sys_refcursor
);

FUNCTION CHECK_SOTOTRINH_DON
( 
    vToaAnID in number,
    vPhongbanID in number,
    vDonid in varchar2,
    vMASO in varchar2
)RETURN NUMBER;
FUNCTION CHECK_SOTOTRINH_DON_TLL
( 
    vToaAnID in number,
    vPhongbanID in number,
    vDonid in varchar2
)RETURN NUMBER;
FUNCTION CHECK_SOVB_DON
(  
    V_MASO in varchar2,
    vToaAnID in number,
    vPhongbanID in number,
    vDonid in varchar2
)RETURN NUMBER;

PROCEDURE GET_SOTOTRINH_SOVB
(  
   vToaAnID in number,
    vPhongbanID in number,
    vLoaiso   in varchar2,
    vSOVB in varchar2,
    vYear in number,
    curReturn OUT sys_refcursor
);

PROCEDURE GET_SOTOTRINH_DON
(  
    vToaAnID in number,
    vPhongbanID in number,
    arrDonid in varchar2,
    curReturn OUT sys_refcursor
);
PROCEDURE GET_TBTP_SOVANBAN
(  
   vToaAnID in number,
    vPhongbanID in number,
    vMASO in varchar2,
    vThamphanid in number,
    vDonid in varchar2,
    curReturn OUT sys_refcursor
);

PROCEDURE GET_DON_SOVANBAN
(  
   vToaAnID in number,
    vPhongbanID in number,
    vMASO in varchar2,
    vDonid in varchar2,
    curReturn OUT sys_refcursor
);

PROCEDURE QUANLYSOVB_HCTP
( 
    vToaAnID in number,
    vPhongbanID in number,
    vISDONVI in number,
    vUSERID in varchar2,
    vLoaiSO  in varchar2,
    vSoVB in varchar2,
    vNgayVB in varchar2,
    vNgayVB_den in varchar2,
    vLoaiAn in number,
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
    v_ISDONVI in number,
    v_ThamphanID IN VARCHAR2,
    v_MASO   IN VARCHAR2,
    v_SOVB     IN VARCHAR2,
    v_NGAYVB    IN VARCHAR2,
    v_NGUOIKY  IN VARCHAR2,
    v_CHUCVU  IN VARCHAR2,
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
    --v_SOVB     IN VARCHAR2,
    v_NGAYVB    IN VARCHAR2,
    v_NGUOIKY  IN VARCHAR2,
    v_CHUCVU  IN VARCHAR2,
    V_NGUOISUA IN VARCHAR2
)RETURN NUMBER;


FUNCTION SOVANBAN_DEL_ALL
(  
    v_SOPHATHANH_ID in number
)RETURN NUMBER;

FUNCTION SOVANBAN_DEL_ONE
(   v_DON_ID  in number,
    v_SOPHATHANH_ID in number
)RETURN NUMBER;
FUNCTION SOVANBAN_XOATHEO_MA
(   V_DON_ID  in number,
    V_MASO in varchar2
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

PROCEDURE  DM_CANBO_GETBYDONVI_ARR_CHUCVU 
(
  vDonViID in number,
  vArrChucVu in varchar2, 
   vLoaiso  in varchar2, 
  CurReturn OUT sys_refcursor 
);

PROCEDURE CHECK_DONTRUNGID
( 
    V_ID in number,
    V_IS_DONTRUNG OUT number
);
PROCEDURE CHECK_DONTRUNGID_ARR
( 
    V_ID in number,
    V_IS_ARR_DON_ID OUT number
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


PROCEDURE CANBO_GETBYDONVI_HDTP
    (   donviID in number,
        vGroupChucDanhID in number,
        curReturn    OUT    sys_refcursor
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
END PKG_GDTTT_HCTP_APP;

/
