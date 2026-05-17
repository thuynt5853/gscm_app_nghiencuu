--------------------------------------------------------
--  DDL for Package PKG_TUPHAP_ANPHI_CN
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_TUPHAP_ANPHI_CN" AS
PROCEDURE TUPHAP_ANPHI_CN_INS_UP
    (
        V_TUPHAP_ANPHI_ID  in  NUMBER,
        V_NGUOI_TAO IN VARCHAR2,
        V_TRANG_THAI IN VARCHAR2
    );
 PROCEDURE TUPHAP_ANPHI_CN_GET_ID
    (
        V_TUPHAP_ANPHI_ID  in  NUMBER,
        ITEMS_CURSOR OUT SYS_REFCURSOR
    );   
END PKG_TUPHAP_ANPHI_CN;

/
