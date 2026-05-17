--------------------------------------------------------
--  DDL for Package PKG_GDTTT_APP
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_GDTTT_APP" AS
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
PROCEDURE THONGKE_CHUNG
( 
  vToaAnID in number,
  vPhongBanID  in number,
  vLanhdaoVu number,
  vThamTraVien number,
  LoaiAnDB in number,--thuộc án
  curReturn OUT sys_refcursor
);
PROCEDURE THONGKE_TONGHOP
( 
  vToaAnID in number,
  vPhongBanID  in number,
  vLanhdaoVu number,
  vThamTraVien number,
  LoaiAnDB in number,--thuộc án
  curReturn OUT sys_refcursor
);
END PKG_GDTTT_APP;
