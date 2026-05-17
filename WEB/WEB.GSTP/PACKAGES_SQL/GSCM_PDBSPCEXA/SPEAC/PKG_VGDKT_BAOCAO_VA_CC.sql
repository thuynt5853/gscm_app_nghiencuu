--------------------------------------------------------
--  DDL for Package PKG_VGDKT_BAOCAO_VA_CC
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_VGDKT_BAOCAO_VA_CC" AS 
FUNCTION GDTTTT_VUAN_SEARCH_BC17
( 
    V_CANBO_TK_ID  IN VARCHAR2,
    V_LANHDAO_TK_ID  IN VARCHAR2,
    vToaAnID in number,
    vPhongBanID  in number,
    vTuNgay in date,
    vDenNgay in date,
    vLanhDaoID number
)
RETURN SYS_REFCURSOR;
FUNCTION GDTTTT_VUAN_SEARCH_BC18
( 
    V_CANBO_TK_ID  IN VARCHAR2,
    V_LANHDAO_TK_ID  IN VARCHAR2,
    vToaAnID in number,
    vPhongBanID  in number,
    vTuNgay in date,
    vDenNgay in date,
    vLanhDaoID number
)
RETURN SYS_REFCURSOR;
FUNCTION GDTTTT_VUAN_SEARCH_BC19
( 
    V_CANBO_TK_ID  IN VARCHAR2,
    V_LANHDAO_TK_ID  IN VARCHAR2,
    vToaAnID in number,
    vPhongBanID  in number,
    vTuNgay in date,
    vDenNgay in date,
    vLanhDaoID number
)
RETURN SYS_REFCURSOR;
FUNCTION GDTTTT_VUAN_SEARCH_BC20
( 
    V_CANBO_TK_ID  IN VARCHAR2,
    V_LANHDAO_TK_ID  IN VARCHAR2,
    vToaAnID in number,
    vPhongBanID  in number,
    vTuNgay in date,
    vDenNgay in date,
    vLanhDaoID number
)
RETURN SYS_REFCURSOR;
FUNCTION GDTTTT_VUAN_SEARCH_BC21
( 
    V_CANBO_TK_ID  IN VARCHAR2,
    V_LANHDAO_TK_ID  IN VARCHAR2,
    vToaAnID in number,
    vPhongBanID  in number,
    vTuNgay in date,
    vDenNgay in date,
    vLanhDaoID number
)
RETURN SYS_REFCURSOR;
END PKG_VGDKT_BAOCAO_VA_CC;
