--------------------------------------------------------
--  DDL for Package PKG_BC_GQ_DONDN_GDTTT_TEST
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_BC_GQ_DONDN_GDTTT_TEST" AS
PROCEDURE THONGKE_THEO_THAMPHAN_JOB;
FUNCTION GDTTTT_QLTOTRINH_TP
( 
  vThamphanID in number,
  vToaAnID in number,
  vPhongBanID  in number,
  vLoaiAn in number,
  tt_tungay in date,
  tt_denngay in date
)RETURN  T_TINHTRANG;
END PKG_BC_GQ_DONDN_GDTTT_TEST;

/
