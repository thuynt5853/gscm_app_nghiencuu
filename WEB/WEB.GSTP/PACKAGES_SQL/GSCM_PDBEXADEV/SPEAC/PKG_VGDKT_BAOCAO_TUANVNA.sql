--------------------------------------------------------
--  DDL for Package PKG_VGDKT_BAOCAO_TUANVNA
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_VGDKT_BAOCAO_TUANVNA" AS 

PROCEDURE GDT14_Export
(   V_ToaAnID	in	VARCHAR2,
    V_Donvi_KNID	in	VARCHAR2,
    V_LOAIAN_ID in  VARCHAR2,
    v_LOAIXULY in	VARCHAR2,
    VTUNGAY in VARCHAR2,
    VDENNGAY in VARCHAR2,
    curReturn OUT sys_refcursor
);

END PKG_VGDKT_BAOCAO_TUANVNA;

/
