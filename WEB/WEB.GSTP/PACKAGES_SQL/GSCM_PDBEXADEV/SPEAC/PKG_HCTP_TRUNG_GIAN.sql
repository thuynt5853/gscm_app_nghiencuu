--------------------------------------------------------
--  DDL for Package PKG_HCTP_TRUNG_GIAN
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_HCTP_TRUNG_GIAN" AS
PROCEDURE SP_INSERT_GDTTT_DON
(
  V_GUID in varchar2,
  V_MA_HO_SO  in varchar2,  
  V_TOA_AN_CHUYEN in varchar2,
  V_NGUOI_CHUYEN in varchar2,
  V_TOA_AN_NHAN in varchar2,
  V_COUNT_RE OUT NUMBER
);


END PKG_HCTP_TRUNG_GIAN;

/
