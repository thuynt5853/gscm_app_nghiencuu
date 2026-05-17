--------------------------------------------------------
--  DDL for Package PKG_STPT_DS_GS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "GSCM"."PKG_STPT_DS_GS" AS 

  -- TODO enter package declarations (types, exceptions, methods etc) here 

    PROCEDURE DON_SEARCH_PTQDK (
        V_CAP_XET_XU_LOGIN      IN    VARCHAR2,
        V_TEN_VU_AN             IN    VARCHAR2,
        V_QHPL                  IN    VARCHAR2,
        V_MA_VU_AN              IN    VARCHAR2,
        V_TENDUONGSU            IN    VARCHAR2,
        V_CAPXX                 IN    VARCHAR2,
        V_TOAAN_ID              IN    VARCHAR2,
        V_TINHTRANG_THULY       IN    VARCHAR2,
        V_NGAYTHULY_TU          IN    VARCHAR2,
        V_NGAYTHULY_DEN         IN    VARCHAR2,
        V_SOTHULY               IN    VARCHAR2,
        V_THAMPHAN_ID           IN    VARCHAR2,
        V_TINHTRANG_GIAIQUYET   IN    VARCHAR2,
        V_TUNGAY                IN    VARCHAR2,
        V_DENNGAY               IN    VARCHAR2,
        V_KETQUA                IN    VARCHAR2,
        V_SO_QD                 IN    VARCHAR2,
        V_NGAY_QD               IN    VARCHAR2,
        V_THUKY_ID              IN    VARCHAR2,
        V_THOIHAN_GQ            IN    VARCHAR2,
        V_LOAIDON               IN    VARCHAR2,
        V_PT_RKINHNGHIEM        IN    VARCHAR2,
        V_GQDON                 IN    VARCHAR2,
        V_UTTP                  IN    VARCHAR2,
        VCHECKTK                IN    NUMBER,
        V_CHECK_PTQDK           IN    NUMBER,--toancau-anhnt cột check phúc thẩm quyết định khác

        PAGE_INDEX              IN    INT,
        PAGE_SIZE               IN    INT,
        CURRETURN               OUT   SYS_REFCURSOR
    );

    PROCEDURE ADS_KCKN_PHUCTHAM_THULY_GETMAXTT (
        VDONVIID    IN    NUMBER,
        VFROMDATE   IN    DATE,
        VTODATE     IN    DATE,
        CURRETURN   OUT   SYS_REFCURSOR
    );

    PROCEDURE ADS_KCKN_PHUCTHAM_THULY_GETLIST (
        VDONID      IN    NUMBER,
        CURRETURN   OUT   SYS_REFCURSOR
    );

    PROCEDURE ADS_DM_QUYETDINH_VUAN_PTQDK (
        CURRETURN OUT SYS_REFCURSOR
    );

    PROCEDURE ADS_PHUCTHAMQDK_BANANQUYETDINH_GETLIST (
        VDONID      IN    NUMBER,
        CURRETURN   OUT   SYS_REFCURSOR
    );

    PROCEDURE ADS_KCKNQDK_PHUCTHAM_HDXX_GETLIST (
        VDONID      IN    NUMBER,
        CURRETURN   OUT   SYS_REFCURSOR
    );

    PROCEDURE ADS_KCKNQDK_PHUCTHAM_QUYETDINH_GETLIST (
        VDONID      IN    NUMBER,
        CURRETURN   OUT   SYS_REFCURSOR
    );

    PROCEDURE ADS_KCKN_DON_THAMPHAN_GETBY (
        VDONID      IN    NUMBER,
        VMAVAITRO   IN    NVARCHAR2,
        CURRETURN   OUT   SYS_REFCURSOR
    );

    PROCEDURE ADS_PHUCTHAM_KCKN_TGTT_GETLIST (
        VDONID      IN    NUMBER,
        CURRETURN   OUT   SYS_REFCURSOR
    );

    PROCEDURE SO_DK_KCKN_DS (
        V_DK_DS    OUT   NUMBER,
        VTOAANID   IN    VARCHAR2,
        V_CXX      IN    VARCHAR2
    );

    PROCEDURE UPDATE_NOIDUNG_CHUYENNHANAN (
        VNHANANID   IN   NUMBER,
        VNOIDUNG    IN   VARCHAR2,
        V_VUANID    IN   NUMBER
    );

    PROCEDURE COUNT_KCKN_TDC (
        VDONID   IN    NUMBER,
        VOUT     OUT   NUMBER
    );

END PKG_STPT_DS_GS;
