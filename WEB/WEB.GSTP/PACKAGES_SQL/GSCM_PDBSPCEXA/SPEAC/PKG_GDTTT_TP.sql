--------------------------------------------------------
--  File created - Thursday-March-21-2024   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package PKG_GDTTT_TP
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_GDTTT_TP" AS 
PROCEDURE DANHSACHDONTHEOID
( 
  varrID in varchar2,
  curReturn OUT sys_refcursor
);
PROCEDURE DANHSACHDONTRUNG
( 
  vID in number,
	curReturn OUT sys_refcursor
);
END PKG_GDTTT_TP;

/
