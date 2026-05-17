create or replace PACKAGE      PKG_ADS
AS
-- Package header

PROCEDURE ADS_DON_ANPHI_GETBYDONID_V2
(
   CurrDonID in int,   
   V_TINHTRANG in int,   
	 PageIndex	in	int,
	 PageSize	in	int,
	 curReturn    OUT   sys_refcursor
);
--08/12/2025 vnpt le ba tho sua de luu an phi KCKN
PROCEDURE ADS_DON_ANPHI_GETBYDONID_KCKN
(
   CurrDonID in int,   
   V_TINHTRANG in int,   
	 PageIndex	in	int,
     P_GIAIDOAN in int,--08/12/2025 vnpt le ba tho sua de luu an phi KCKN
	 PageSize	in	int,
	 curReturn    OUT   sys_refcursor
);

 PROCEDURE ADS_ANPHI_LICHSU_GETBYDONID
(
   CurrDonID in int,   
   anPhiId IN int,
   V_TINHTRANG in int,   
	 PageIndex	in	int,
	 PageSize	in	int,
	 curReturn    OUT   sys_refcursor
)

;

PROCEDURE ADS_DON_DUONGSU_BIENLAI_V2
(
  vDONID IN VARCHAR2,
  CurReturn OUT sys_refcursor 
);

END PKG_ADS;