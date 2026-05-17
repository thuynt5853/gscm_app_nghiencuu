create or replace PACKAGE      PKG_AHN
AS
-- Package header
PROCEDURE AHN_DON_ANPHI_GETBYDONID_V2
(
   CurrDonID in int,   
   V_TINHTRANG in int,   
	 PageIndex	in	int,
	 PageSize	in	int,
	 curReturn    OUT   sys_refcursor
);
PROCEDURE AHN_DON_ANPHI_LICHSU_GETBYDONID
(
   CurrDonID in int,   
   anPhiId IN int,
   V_TINHTRANG in int,   
	 PageIndex	in	int,
	 PageSize	in	int,
	 curReturn    OUT   sys_refcursor
);






END PKG_AHN;