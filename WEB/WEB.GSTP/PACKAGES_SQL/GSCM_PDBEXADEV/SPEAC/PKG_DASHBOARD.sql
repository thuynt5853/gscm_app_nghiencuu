--------------------------------------------------------
--  DDL for Package PKG_DASHBOARD
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_DASHBOARD" AS 

PROCEDURE        DASHBOARD_GET_DANHSACH_TOAAN
( DONVIID IN NUMBER,
	CURRETURN    OUT       SYS_REFCURSOR
);

PROCEDURE DASHBOARD_M1_TPTATC
(  
    vToaAnID	in	VARCHAR2,
    vThamphanid in number,
    vTuNgay	in VARCHAR2,
    vDenNgay	in VARCHAR2,
    curReturn OUT sys_refcursor 
);

PROCEDURE  GET_THAMPHAN_TOICAO
(
  vToaAnID in VARCHAR2,
  vThamphan_id IN NUMBER,
  CurReturn OUT sys_refcursor 
);

PROCEDURE DASHBOARD_GDT_EXP
(  
    vToaAnID	in	VARCHAR2,
    vThamphanid in number,
    vTuNgay	in VARCHAR2,
    vDenNgay	in VARCHAR2,
    curReturn OUT sys_refcursor 
);

PROCEDURE DASHBOARD_GDT_QH_EXP
(  
    vToaAnID	in	VARCHAR2,
    vThamphanid in number,
    vTuNgay	in VARCHAR2,    
    vDenNgay	in VARCHAR2,
    curReturn OUT sys_refcursor 
);
PROCEDURE DASHBOARD_GDT_THOIHIEU_EXP
(  
    vToaAnID	in	VARCHAR2,
    vThamphanid in number,
    vTuNgay	in VARCHAR2,    
    vDenNgay	in VARCHAR2,
    curReturn OUT sys_refcursor 
);

PROCEDURE DASHBOARD_STPT_EXP
(  
    vToaAnID	in	VARCHAR2,
    vTuNgay	in VARCHAR2,
    vDenNgay	in VARCHAR2,
    vTuNgayTruoc	in VARCHAR2,
    vDenNgayTruoc	in VARCHAR2,
    curReturn OUT sys_refcursor 
);

PROCEDURE DASHBOARD_M2_STPT
(  
    VTOAANID	IN	VARCHAR2,
    VTUNGAY	IN VARCHAR2,
    VDENNGAY	IN VARCHAR2,
    VTUNGAYTRUOC	IN VARCHAR2,
    VDENNGAYTRUOC	IN VARCHAR2,
    VCOLUMN         IN VARCHAR2,
    CURRETURN OUT SYS_REFCURSOR 
);

END PKG_DASHBOARD;

/
