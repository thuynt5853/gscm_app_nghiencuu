--------------------------------------------------------
--  DDL for Package PKG_BC_GQ_DONDN_GDTTT
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_BC_GQ_DONDN_GDTTT" AS
FUNCTION BC_GQ_DONDN_GDTTT
(
    vToaAnID in number,
    vPhongBanID  in number,
    vTuNgay in date,
    vDenNgay in date
)
RETURN SYS_REFCURSOR;
 FUNCTION BC_GET
(
    vPhongBanID  in number,
    vTuNgay in VARCHAR2
)
RETURN SYS_REFCURSOR;
END PKG_BC_GQ_DONDN_GDTTT;
