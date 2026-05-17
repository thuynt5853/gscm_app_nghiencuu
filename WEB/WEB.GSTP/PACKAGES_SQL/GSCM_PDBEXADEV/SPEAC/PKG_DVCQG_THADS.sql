--------------------------------------------------------
--  DDL for Package PKG_DVCQG_THADS
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_DVCQG_THADS" AS 
PROCEDURE SEARCH_SEND_MAIL 
(
  CurReturn OUT sys_refcursor
);
PROCEDURE UPDATE_DATE_SENDMAIL
(
   V_ID IN VARCHAR2
);
END PKG_DVCQG_THADS;

/
