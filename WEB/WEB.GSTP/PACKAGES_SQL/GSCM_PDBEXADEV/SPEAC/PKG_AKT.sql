create or replace PACKAGE          PKG_AKT
AS
-- Package header


 PROCEDURE AKT_DON_ANPHI_GETBYDONID_V2
(
   CurrDonID in int,   
   V_TINHTRANG in int,   
	 PageIndex	in	int,
	 PageSize	in	int,
	 curReturn    OUT   sys_refcursor
);


PROCEDURE AKT_ANPHI_LICHSU_GETBYDONID
(
   	CurrDonID in int,   
   	anPhiId IN int,
   	V_TINHTRANG in int,   
	PageIndex	in	int,
	PageSize	in	int,
	curReturn    OUT   sys_refcursor
);

PROCEDURE AKT_DON_DUONGSU_BIENLAI_V2
(
  vDONID IN VARCHAR2,
  CurReturn OUT sys_refcursor 
);

END PKG_AKT;