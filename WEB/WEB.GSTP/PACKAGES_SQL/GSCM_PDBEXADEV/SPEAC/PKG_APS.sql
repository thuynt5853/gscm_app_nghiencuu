--------------------------------------------------------
--  DDL for Package PKG_APS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "GSCM"."PKG_APS" 
AS
-- Package header
PROCEDURE APS_DON_ANPHI_GETBYDONID_V2 (
   CurrDonID in int,   
   V_TINHTRANG in int,   
	 PageIndex	in	int,
	 PageSize	in	int,
	 curReturn    OUT   sys_refcursor
);
PROCEDURE APS_ANPHI_LICHSU_GETBYDONID (
   CurrDonID in int,   
   anPhiId IN int,
   V_TINHTRANG in int,   
	 PageIndex	in	int,
	 PageSize	in	int,
	 curReturn    OUT   sys_refcursor
);
 PROCEDURE APS_DON_DSDUONGSU_GETBY_V2
( vDONID in number,
	curReturn OUT sys_refcursor
);

 PROCEDURE APS_DON_DUONGSU_BIENLAI_V2
(
  vDONID IN VARCHAR2,
  CurReturn OUT sys_refcursor 
) ;


END PKG_APS;

/
