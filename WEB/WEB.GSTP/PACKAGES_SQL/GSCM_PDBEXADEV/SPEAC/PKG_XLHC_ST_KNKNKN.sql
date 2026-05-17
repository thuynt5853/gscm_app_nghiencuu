--------------------------------------------------------
--  DDL for Package PKG_XLHC_ST_KNKNKN
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "GSCM"."PKG_XLHC_ST_KNKNKN" 
  IS
--
-- To modify this template, edit file PKGSPEC.TXT in TEMPLATE
-- directory of SQL Navigator
--
-- Purpose: Briefly explain the functionality of the package
--
-- MODIFICATION HISTORY
-- Person      Date    Comments
-- ---------   ------  ------------------------------------------
   -- Enter package declarations as shown below

   PROCEDURE SP_GET_QUYETDINH
    ( vDonID in NUMBER,
      vType in number, --1 Khieu nai, 2 Kien nghi, 3 Khang nghi
      curReturn    OUT       sys_refcursor
    );

END; -- Package spec

/
