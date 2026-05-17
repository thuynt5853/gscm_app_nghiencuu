--------------------------------------------------------
--  DDL for Package PKG_GDTTT_APP_CACC
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_GDTTT_APP_CACC" AS
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
PROCEDURE THONGKE_THEO_THAMPHAN_JOB;
PROCEDURE TK_THAMPHAN_CREATE_DATA
    (
        vToaAnID in number,
        vThamphanID  in number,
        vTuNgay in date,
        vDenNgay in date,
        LoaiAnDB in number,--thuộc án
        vYears in varchar2,
        curReturn OUT SYS_REFCURSOR
    );
END PKG_GDTTT_APP_CACC;

/
