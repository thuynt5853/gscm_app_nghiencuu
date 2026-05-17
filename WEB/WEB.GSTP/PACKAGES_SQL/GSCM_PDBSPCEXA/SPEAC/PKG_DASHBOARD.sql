create or replace NONEDITIONABLE PACKAGE        "PKG_DASHBOARD" AS 

FUNCTION BAOCAO_TK_TP_GET
(
  VTOAANID IN NUMBER,
  VTHAMPHANID  IN NUMBER,
  VTUNGAY IN DATE,
  VDENNGAY IN DATE
)
RETURN SYS_REFCURSOR;
--FUNCTION BAOCAO_TK_TAND_GET
--(
--  VTOAANID IN NUMBER,
--  VTHAMPHANID  IN NUMBER,
--  VTUNGAY IN DATE,
--  VDENNGAY IN DATE
--)
--RETURN SYS_REFCURSOR;

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


END PKG_DASHBOARD;