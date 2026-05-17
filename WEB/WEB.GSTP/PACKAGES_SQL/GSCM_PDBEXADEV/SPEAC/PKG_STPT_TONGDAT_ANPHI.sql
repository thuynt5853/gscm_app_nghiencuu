--------------------------------------------------------
--  DDL for Package PKG_STPT_TONGDAT_ANPHI
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "GSCM"."PKG_STPT_TONGDAT_ANPHI" 
AS

PROCEDURE ADS_TONGDATDOITUONG_ANPHI_GETBY(
    vDonID in Decimal,
    vToaAnID in Decimal, 
    vBieuMauID in Decimal,
    vIsOnLyNKK in Decimal,
    vANPHIID in Decimal,
    curReturn out SYS_REFCURSOR);

 PROCEDURE ADS_TONGDATDOITUONG_ANPHI_GETBYTONGDATID(
    vTONGDATID in number , 
    curReturn out SYS_REFCURSOR
 );

 PROCEDURE ADS_TONGDATDOITUONG_ANPHI_GETBYANPHIID_TONGDATID(
    vDONID in number , 
    vANPHIID IN NUMBER,
    curReturn out SYS_REFCURSOR
 );


   -- Án hôn nhân gia đình
PROCEDURE AHN_TONGDATDOITUONG_GETBY(
    vDonID in Decimal ,
    vToaAnID in Decimal , 
    vBieuMauID in Decimal ,
    vIsOnLyNKK in Decimal ,
    vANPHIID in Decimal,
    curReturn out SYS_REFCURSOR);

PROCEDURE AHN_TONGDATDOITUONG_ANPHI_GETBYTONGDATID(
    vTONGDATID in number,
    curReturn out SYS_REFCURSOR
);

PROCEDURE AHN_TONGDATDOITUONG_ANPHI_GETBYANPHIID_TONGDATID(
    vDONID in number , 
    vANPHIID IN NUMBER,
    curReturn out SYS_REFCURSOR
 );

-- Án lao động

PROCEDURE ALD_TONGDATDOITUONG_GETBY(
    vDonID in Decimal,
    vToaAnID in Decimal, 
    vBieuMauID in Decimal,
    vIsOnLyNKK in Decimal,
    vANPHIID in Decimal,
    curReturn out SYS_REFCURSOR);

PROCEDURE ALD_TONGDATDOITUONG_ANPHI_GETBYTONGDATID(
    vTONGDATID in NUMBER, 
    curReturn out SYS_REFCURSOR
);

PROCEDURE ALD_TONGDATDOITUONG_ANPHI_GETBYANPHIID_TONGDATID(
    vDONID in NUMBER, 
    vANPHIID IN NUMBER,
    curReturn out SYS_REFCURSOR
);

-- Án Kinh tế
PROCEDURE AKT_TONGDATDOITUONG_GETBY(
    vDonID in Decimal,
    vToaAnID in Decimal, 
    vBieuMauID in Decimal,
    vIsOnLyNKK in Decimal,
    vANPHIID in Decimal,
    curReturn out SYS_REFCURSOR);

PROCEDURE AKT_TONGDATDOITUONG_ANPHI_GETBYTONGDATID(
    vTONGDATID in number , 
    curReturn out SYS_REFCURSOR
 );

PROCEDURE AKT_TONGDATDOITUONG_ANPHI_GETBYANPHIID_TONGDATID(
    vDONID in number , 
    vANPHIID IN NUMBER,
    curReturn out SYS_REFCURSOR
 );

-- Án hành chính
PROCEDURE AHC_TONGDATDOITUONG_ANPHI_GETBY(
    vDonID in Decimal ,
    vToaAnID in Decimal , 
    vBieuMauID in Decimal ,
    vIsOnLyNKK in Decimal ,
     vANPHIID in Decimal,
    curReturn out SYS_REFCURSOR);

PROCEDURE AHC_TONGDATDOITUONG_ANPHI_GETBYTONGDATID(
    vTONGDATID in number,
    curReturn out SYS_REFCURSOR
);

PROCEDURE AHC_TONGDATDOITUONG_ANPHI_GETBYANPHIID_TONGDATID(
    vDONID in number , 
    vANPHIID IN NUMBER,
    curReturn out SYS_REFCURSOR
 );

-- án phá sản

PROCEDURE APS_TONGDATDOITUONG_GETBY(
    vDonID in Decimal,
    vToaAnID in Decimal, 
    vBieuMauID in Decimal,
    vIsOnLyNKK in Decimal,
    vANPHIID in Decimal,
    curReturn out SYS_REFCURSOR);

 PROCEDURE APS_TONGDATDOITUONG_ANPHI_GETBYTONGDATID(
    vTONGDATID in NUMBER, 
    curReturn out SYS_REFCURSOR
);

PROCEDURE APS_TONGDATDOITUONG_ANPHI_GETBYANPHIID_TONGDATID(
    vDONID in NUMBER, 
    vANPHIID IN NUMBER,
    curReturn out SYS_REFCURSOR
);

-- Package header
END PKG_STPT_TONGDAT_ANPHI;

/
