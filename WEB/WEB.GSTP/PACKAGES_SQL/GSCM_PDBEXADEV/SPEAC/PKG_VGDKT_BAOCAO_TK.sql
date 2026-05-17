--------------------------------------------------------
--  DDL for Package PKG_VGDKT_BAOCAO_TK
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_VGDKT_BAOCAO_TK" AS 
FUNCTION TC_LABO_DETAIL_DIS_CW
(  
    V_ToaAnID	in	VARCHAR2,
    V_PhongbanID	in	VARCHAR2,
    V_LOAIAN_ID in  VARCHAR2,
    v_LOAIXULY in	VARCHAR2,
    vTuNgay	in VARCHAR2,
    vDenNgay	in VARCHAR2
)RETURN SYS_REFCURSOR;
END PKG_VGDKT_BAOCAO_TK;

/
