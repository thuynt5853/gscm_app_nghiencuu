--------------------------------------------------------
--  DDL for Package PKG_GDTTT_APP_CACC_DN
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_GDTTT_APP_CACC_DN" AS
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
END PKG_GDTTT_APP_CACC_DN;

/
