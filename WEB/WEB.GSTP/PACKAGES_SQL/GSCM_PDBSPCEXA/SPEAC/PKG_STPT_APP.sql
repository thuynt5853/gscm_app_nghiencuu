--------------------------------------------------------
--  DDL for Package PKG_STPT_APP
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_STPT_APP" AS
PROCEDURE CANHBAO_TDC_THOIHAN
(
    V_CAPXX in varchar2,
    V_TOAAN_ID in varchar2,
    curReturn OUT sys_refcursor
);
END PKG_STPT_APP;
