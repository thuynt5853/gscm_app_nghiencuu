--------------------------------------------------------
--  DDL for Package PKG_API_DASHBOARD
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_API_DASHBOARD" AS 

PROCEDURE  API_GET_THAMPHAN
(
--  V_TOAANID     IN NUMBER,
--  V_THAMPHANID  IN NUMBER,
  CURRETURN OUT sys_refcursor 
);

PROCEDURE  API_GET_DANHSACH_TOAAN
( 
    DONVIID IN NUMBER,
	CURRETURN    OUT       SYS_REFCURSOR
);

PROCEDURE API_DASHBOARD_GDT_EXP
(  
    vToaAnID	in	VARCHAR2,
    vThamphanid in number,
    vTuNgay	in VARCHAR2,
    vDenNgay	in VARCHAR2,
    curReturn OUT sys_refcursor 
);

PROCEDURE API_DASHBOARD_GDT_QH_EXP
(  
    vToaAnID	in	VARCHAR2,
    vThamphanid in number,
    vTuNgay	in VARCHAR2,    
    vDenNgay	in VARCHAR2,
    curReturn OUT sys_refcursor 
);
PROCEDURE API_DASHBOARD_GDT_THOIHIEU_EXP
(  
    vToaAnID	in	VARCHAR2,
    vThamphanid in number,
    vTuNgay	in VARCHAR2,    
    vDenNgay	in VARCHAR2,
    curReturn OUT sys_refcursor 
);

  PROCEDURE API_GET_DASHBOARD_M1_TPTATC
(  
    VTOAANID	IN	VARCHAR2,
    VTHAMPHANID IN NUMBER,
    VTUNGAY	IN VARCHAR2,
    VDENNGAY	IN VARCHAR2,
    CURRETURN OUT SYS_REFCURSOR 
);

  PROCEDURE API_GET_DASHBOARD_STPT_M1
(  
    vToaAnID	in	NUMBER,
    vTuNgay	in VARCHAR2,
    vDenNgay	in VARCHAR2,
    vTuNgayTruoc	in VARCHAR2,
    vDenNgayTruoc	in VARCHAR2,
    CURRETURN OUT SYS_REFCURSOR 
);

PROCEDURE API_GET_DASHBOARD_STPT_M2
(  
    VTOAANID	IN	VARCHAR2,
    VTUNGAY	IN VARCHAR2,
    VDENNGAY	IN VARCHAR2,
    VTUNGAYTRUOC	IN VARCHAR2,
    VDENNGAYTRUOC	IN VARCHAR2,
    VCOLUMN         IN VARCHAR2,
    CURRETURN OUT SYS_REFCURSOR 
);

END PKG_API_DASHBOARD;

/
