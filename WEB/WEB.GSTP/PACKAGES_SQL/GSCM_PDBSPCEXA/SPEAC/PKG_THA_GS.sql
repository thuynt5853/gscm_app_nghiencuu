--------------------------------------------------------
--  DDL for Package PKG_THA_GS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "GSCM"."PKG_THA_GS" AS
    PROCEDURE THA_NHANUYTHAC_GETALL (
        CURRTOAANID     IN NUMBER,
        CURRTRANGTHAI   IN NUMBER,
        V_TENBIAN       IN NVARCHAR2,
        V_TENVUAN       IN NVARCHAR2,
        V_NGAYUYTHAC    IN NVARCHAR2,
        V_TOAANUYTHACID IN NUMBER,
        V_SOQD          IN NVARCHAR2,
        V_NGAYQD        IN NVARCHAR2,
        V_NGAYQDFROM    IN NVARCHAR2,
        V_NGAYQDTO      IN NVARCHAR2,
        PAGE_INDEX      IN INT,
        PAGE_SIZE       IN INT,
        CURRETURN       OUT SYS_REFCURSOR
    );
PROCEDURE        THA_UYTHACDETAIL_GETINFO 
(  
  V_VUANID in number
  ,curReturn    OUT   sys_refcursor	 
) ;
   PROCEDURE        THA_BIAN_GETANNGOAIHT 
(
    toa_an_id in number
   ,  ma_bi_an in nvarchar2, ten_bi_an in nvarchar2
   , ma_vu_an in nvarchar2, ten_vu_an in nvarchar2
   , so_ban_an in varchar2, ngay_ban_an in date,
    TRANGTHAI   IN NUMBER,
     v_SOCMND in nvarchar2,
         V_TUNGAY    IN NVARCHAR2,
        V_DENNGAY      IN NVARCHAR2,
	  PageIndex	in	number
	 , PageSize	in	number
	 , curReturn    OUT   sys_refcursor
);
PROCEDURE        THA_UYTHAC_QD_GETALL
(
  Curr_BiAnID in number
  ,curReturn    OUT   sys_refcursor	 
); 
PROCEDURE        DM_LYDOUYTHAC_SEARCH
(
  SoLuong in number,
	TextKey IN VARCHAR2,
  	CurReturn OUT sys_refcursor 
  );
  
  PROCEDURE THA_BIAN_GETANHSTRONGHT_PAGING(
         TOA_AN_ID   IN NUMBER,
        MA_BI_AN    IN NVARCHAR2,
        TEN_BI_AN   IN NVARCHAR2,
        MA_VU_AN    IN NVARCHAR2,
        TEN_VU_AN   IN NVARCHAR2,
        SO_BAN_AN   IN VARCHAR2,
        NGAY_BAN_AN IN DATE,
        TRANGTHAI   IN NUMBER,
        V_SOCMND in nvarchar2,
         V_TUNGAY    IN NVARCHAR2,
        V_DENNGAY      IN NVARCHAR2,
        PAGEINDEX   IN NUMBER,
        PAGESIZE    IN NUMBER,
        CURRETURN   OUT SYS_REFCURSOR
    );
PROCEDURE THA_GET_MATHULY_TUSINH (
    curReturn OUT SYS_REFCURSOR
);
PROCEDURE THA_GET_MABIAN_TUSINH (
    curReturn OUT SYS_REFCURSOR
);
PROCEDURE THA_UYTHAC_DETAIL_GETALL 
(
  CurrBiAnID in number,	curReturn OUT sys_refcursor 
);
    
END PKG_THA_GS;
