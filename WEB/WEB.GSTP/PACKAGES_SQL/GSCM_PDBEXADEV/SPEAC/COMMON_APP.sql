--------------------------------------------------------
--  DDL for Package COMMON_APP
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."COMMON_APP" AS
FUNCTION GET_NGAY_LAMVIEC
(
   V_DATE_FROM DATE,
   V_DATE_TO  DATE
)
RETURN NUMBER;
END COMMON_APP;

/
