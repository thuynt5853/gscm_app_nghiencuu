create or replace PACKAGE      PKG_ALD
AS
-- Package header

PROCEDURE ALD_DON_ANPHI_GETBYDONID_V2
(
   CurrDonID in int,   
   V_TINHTRANG in int,   
	 PageIndex	in	int,
	 PageSize	in	int,
	 curReturn    OUT   sys_refcursor
);

PROCEDURE ALD_ANPHI_LICHSU_GETBYDONID
(
   CurrDonID IN int,   
   anPhiId IN int,
   V_TINHTRANG IN int,   
	 PageIndex IN int,
	 PageSize IN int,
	 curReturn OUT sys_refcursor
);

PROCEDURE ALD_DON_DUONGSU_BIENLAI_V2
(
  vDONID IN VARCHAR2,
  CurReturn OUT sys_refcursor 
);


END PKG_ALD;