--------------------------------------------------------
--  DDL for Package PKG_DM
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "GSCM"."PKG_DM" 
AS
-- Package header

PROCEDURE DM_CANBO_GETBYDONVI_V2
( donviID in number,
	curReturn    OUT       sys_refcursor
);
END PKG_DM;

/
