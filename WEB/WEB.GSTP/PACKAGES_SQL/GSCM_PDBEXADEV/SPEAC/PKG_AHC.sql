create or replace PACKAGE          PKG_AHC
AS
-- Package header
PROCEDURE AHC_DON_ANPHI_GETBYDONID_V2
(
   CurrDonID in int,   
   V_TINHTRANG in int,   
	 PageIndex	in	int,
	 PageSize	in	int,
	 curReturn    OUT   sys_refcursor
);

PROCEDURE AHC_DON_ANPHI_GETBYDONID_KCKN
(
   CurrDonID in int,   
   V_TINHTRANG in int,   
	 PageIndex	in	int,
     P_GIAIDOAN in int,--08/12/2025 vnpt le ba tho sua de luu an phi KCKN
	 PageSize	in	int,
	 curReturn    OUT   sys_refcursor
);

PROCEDURE AHC_DON_ANPHI_LICHSU_GETBYDONID
(
   CurrDonID in int,   
   anPhiId IN int,
   V_TINHTRANG in int,   
	 PageIndex	in	int,
	 PageSize	in	int,
	 curReturn    OUT   sys_refcursor
);


END PKG_AHC;