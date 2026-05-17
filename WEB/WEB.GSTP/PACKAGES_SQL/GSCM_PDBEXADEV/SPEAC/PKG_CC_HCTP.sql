--------------------------------------------------------
--  DDL for Package PKG_CC_HCTP
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_CC_HCTP" AS
FUNCTION TK_HCTP_EXPORT
(
    VTOAANID in number,
    VstrUsername  in VARCHAR2,
    VstrNhomID  in VARCHAR2,
    VTUNGAY in VARCHAR2,
    VDENNGAY in VARCHAR2
)
 RETURN SYS_REFCURSOR; 
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
    ) ;
END PKG_CC_HCTP;

/
