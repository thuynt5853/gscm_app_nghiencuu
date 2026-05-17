--------------------------------------------------------
--  DDL for Package PKG_DONVI_REPORT
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_DONVI_REPORT" AS 
FUNCTION GET_DONVI_BC
(
 v_capxx in varchar2,
 v_object_select in varchar2
)
RETURN SYS_REFCURSOR;
FUNCTION GET_DONVI_TINH
(
 V_CAPCHAID in varchar2
)
RETURN SYS_REFCURSOR;

END PKG_DONVI_REPORT;

/
