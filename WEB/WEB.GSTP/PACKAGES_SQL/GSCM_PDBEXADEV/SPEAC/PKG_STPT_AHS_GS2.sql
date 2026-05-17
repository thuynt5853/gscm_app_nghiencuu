--------------------------------------------------------
--  DDL for Package PKG_STPT_AHS_GS2
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_STPT_AHS_GS2" AS 

  -- TODO enter package declarations (types, exceptions, methods etc) here 
    FUNCTION AHS_CHECK_NHAN_AN (
        V_VUANID    NUMBER,
        V_TOAANID   NUMBER,
        V_MESSAGE   VARCHAR2
    ) RETURN VARCHAR2;

    FUNCTION GET_VUANID_DANG_XULY_TDC (
        V_VUANID    NUMBER,
        V_TOAANID   NUMBER
    ) RETURN NUMBER;

    FUNCTION CHECK_CHUYEN_AN (
        V_VUANID    NUMBER,
        V_TOAANID   NUMBER
    ) RETURN NUMBER;

    PROCEDURE GET_CT_TAMGIAM (
        VVUAN_ID         IN    VARCHAR2,
        VHIEULUCTUNGAY   IN    VARCHAR2,
        CURRETURN        OUT   SYS_REFCURSOR
    );

    PROCEDURE AHS_PT_KCKN_TINHTRANG_GETLIST (
        VVUANID     IN    INT,
        CURRETURN   OUT   SYS_REFCURSOR
    );

    FUNCTION CHUYENAN_NOIDUNG (
        V_VUANID        NUMBER,
        V_MAGIAIDOAN    NUMBER,
        V_CHUYENANID    NUMBER,
        V_TRANGTHAIID   NUMBER,
        V_MESSAGE       VARCHAR2
    ) RETURN CLOB;

    FUNCTION NHANAN_NOIDUNG (
        V_VUANID        NUMBER,
        V_MAGIAIDOAN    NUMBER,
        V_CHUYENANID    NUMBER,
        V_TRANGTHAIID   NUMBER,
        V_MESSAGE       VARCHAR2
    ) RETURN CLOB;

    PROCEDURE AHS_NTGTT_GETBYVUANID (
        VU_AN_ID    IN    NUMBER,
        PAGEINDEX   IN    INT,
        PAGESIZE    IN    INT,
        CURRETURN   OUT   SYS_REFCURSOR
    );

END PKG_STPT_AHS_GS2;

/
