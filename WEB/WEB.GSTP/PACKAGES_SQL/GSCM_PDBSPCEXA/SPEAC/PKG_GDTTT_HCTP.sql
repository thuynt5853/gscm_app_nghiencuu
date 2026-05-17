--------------------------------------------------------
--  DDL for Package PKG_GDTTT_HCTP
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_GDTTT_HCTP" AS
PROCEDURE TK_HCTP_CREATE_DATA
    (
        vToaAnID in number,
        VstrUsername  in VARCHAR2,
        VstrNhomID  in VARCHAR2,
        vTuNgay in VARCHAR2,
        vDenNgay in VARCHAR2,
        curReturn OUT SYS_REFCURSOR
    );
PROCEDURE TK_NGUOIDUNG_CREATE_DATA
    (
        VTOAANID in number,
        VstrUsername  in VARCHAR2,
        VstrNhomID  in VARCHAR2,
        VTUNGAY in VARCHAR2,
        VDENNGAY in VARCHAR2,
        curReturn OUT SYS_REFCURSOR
    );
FUNCTION TK_HCTP_EXPORT
(
    VTOAANID in number,
    VstrUsername  in VARCHAR2,
    VstrNhomID  in VARCHAR2,
    VTUNGAY in VARCHAR2,
    VDENNGAY in VARCHAR2
)
 RETURN SYS_REFCURSOR;   
END PKG_GDTTT_HCTP;
