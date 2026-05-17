--------------------------------------------------------
--  DDL for Package PKG_GSTP_DONTHULY
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_GSTP_DONTHULY" AS
PROCEDURE GSTP_HOME_ST_DON(
  inToaAnID IN NUMBER,
  inCapToa IN VARCHAR2,
  vHienTai_TuNgay IN DATE,
  vHienTai_DenNgay IN DATE,
  vTruoc_TuNgay IN DATE,
  vTruoc_DenNgay IN DATE,
  CurReturn OUT sys_refcursor
);
FUNCTION FUN_GSTP_HOME_ST_DON  
(
  inToaAnID IN NUMBER,
  inCapToa IN VARCHAR2,
  vHienTai_TuNgay IN DATE,
  vHienTai_DenNgay IN DATE,
  vTruoc_TuNgay IN DATE,
  vTruoc_DenNgay IN DATE
) RETURN GSTP_HOME_ST_DON_T PIPELINED;
PROCEDURE FILL_GSTP_HOME_ST_DON
(
  v_ARRAY IN OUT GSTP_HOME_ST_DON_T,
  vHienTai_TuNgay IN DATE,
  vHienTai_DenNgay IN DATE,
  vTruoc_TuNgay IN DATE,
  vTruoc_DenNgay IN DATE
);
END PKG_GSTP_DONTHULY;
