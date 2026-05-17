--------------------------------------------------------
--  DDL for Package PKG_GDTTT_APP_CACC_GET
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_GDTTT_APP_CACC_GET" AS
FUNCTION THONGKE_THEO_THAMPHAN_GET
    (
        VTHAMPHANID_PCA  IN NUMBER,
        VTOAANID IN NUMBER,
        VTHAMPHANID  IN NUMBER,
        VTUNGAY IN DATE,
        VDENNGAY IN DATE,
        VLOAIANDB IN NUMBER,
        VYEARS IN VARCHAR2
    ) 
RETURN SYS_REFCURSOR;
PROCEDURE SOTHAM_CA
(
    V_CAPXX in varchar2,
    V_TOAAN_ID in varchar2,
    curReturn OUT sys_refcursor
);
 PROCEDURE PHUCTHAM_CA
(
    V_CAPXX in varchar2,
    V_TOAAN_ID in varchar2,
    curReturn OUT sys_refcursor
);
END PKG_GDTTT_APP_CACC_GET;
