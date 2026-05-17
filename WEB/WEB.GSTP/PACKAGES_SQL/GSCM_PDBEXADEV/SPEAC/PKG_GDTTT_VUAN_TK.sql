--------------------------------------------------------
--  DDL for Package PKG_GDTTT_VUAN_TK
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "GSCM"."PKG_GDTTT_VUAN_TK" AS 

  /* TODO enter package declarations (types, exceptions, methods etc) here */ 
    PROCEDURE GDKTTT_VUAN_TK_INS_UPD
        (
             V_TYPE_TK in VARCHAR2,
            V_VUAN_ID  in  NUMBER,
            V_GIATRI_TK in  NUMBER,
            V_NOIDUNG_TK in  VARCHAR2,
            V_GHICHU in  VARCHAR2,
            V_NGUOITAO IN VARCHAR2,
            V_NGAYTAO  IN DATE,
            V_NGUOISUA IN VARCHAR2,
            V_NGAYSUA  IN DATE
        );

    PROCEDURE  GDKTTT_VUAN_TK_GETBYID
    (
        V_TYPE_TK IN VARCHAR2
        ,V_VUAN_ID  in NUMBER,
        curReturn OUT sys_refcursor
    );

   PROCEDURE  GDKTTT_VUAN_TK_DEL
    ( 
        V_TYPE_TK IN VARCHAR2
        ,V_VUAN_ID IN NUMBER

    );

    PROCEDURE  GDKTTT_VUAN_GET_ALL_ANLE
    (  curReturn OUT sys_refcursor
    );


END PKG_GDTTT_VUAN_TK;

/
