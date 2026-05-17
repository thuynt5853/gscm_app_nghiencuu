--------------------------------------------------------
--  DDL for Package PKG_STPT_AHS_GS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "GSCM"."PKG_STPT_AHS_GS" AS
    PROCEDURE AHS_VUAN_GETALLPAGING (
        V_CAP_XET_XU_LOGIN      IN    VARCHAR2,
        V_TEN_VU_AN             IN    VARCHAR2,
        V_TOIDANH               IN    VARCHAR2,
        V_MA_VU_AN              IN    VARCHAR2,
        V_BI_CAN                IN    VARCHAR2,
        V_CAPXX                 IN    VARCHAR2,
        V_TOAAN_ID              IN    VARCHAR2,
        V_TINHTRANG_THULY       IN    VARCHAR2,
        V_NGAYTHULY_TU          IN    VARCHAR2,
        V_NGAYTHULY_DEN         IN    VARCHAR2,
        V_SOTHULY               IN    VARCHAR2,
        V_TINHTRANG_GIAIQUYET   IN    VARCHAR2,
        V_TUNGAY                IN    VARCHAR2,
        V_DENNGAY               IN    VARCHAR2,
        V_KETQUA                IN    VARCHAR2,
        V_SO_QD                 IN    VARCHAR2,
        V_NGAY_QD               IN    VARCHAR2,
        V_THAMPHAN_ID           IN    VARCHAR2,
        V_THUKY_ID              IN    VARCHAR2,
        V_THOIHAN_GQ            IN    VARCHAR2,
        V_QD_TAMGIAM            IN    VARCHAR2,
        V_UTTP                  IN    VARCHAR2,
        VCHECKTK                IN    NUMBER,
        V_THANHNIEN             IN    NUMBER,
        V_HINHTHUCXX            IN    NUMBER,
        V_GDTAOHS               IN    NUMBER,
        V_VAITRO_THAMPHAN       IN VARCHAR2,
        PAGE_INDEX              IN    INT,
        PAGE_SIZE               IN    INT,
        CURRETURN               OUT   SYS_REFCURSOR
    );
  -- TODO enter package declarations (types, exceptions, methods etc) here 

    PROCEDURE DANHSACH_KHANGCAO_QUYETDINHTDC_BICAN (
        VLOAIAN     VARCHAR2,
        VDONID      NUMBER,
        VBICANID    VARCHAR2,
        CURRETURN   OUT SYS_REFCURSOR
    );

    PROCEDURE COUNT_KCKN_TDC (
        VDONID   IN    NUMBER,
        VOUT     OUT   NUMBER
    );

    PROCEDURE AHS_PHUCTHAM_THULY_GETBYVUAN (
        VU_AN_ID    IN    NUMBER,
        CURRETURN   OUT   SYS_REFCURSOR
    );

    PROCEDURE AHS_PHUCTHAM_THULY_GETMAXTT (
        TOA_AN_ID   IN    NUMBER,
        TU_NGAY     DATE,
        DEN_NGAY    DATE,
        CURRETURN   OUT   SYS_REFCURSOR
    );

    PROCEDURE AHS_PHUCTHAM_HDXX_GETLIST (
        VVUANID     IN    NUMBER,
        CURRETURN   OUT   SYS_REFCURSOR
    );

    PROCEDURE AHS_PT_BICAO_GETALL (
        VU_AN_ID    IN    NUMBER,
        CURRETURN   OUT   SYS_REFCURSOR
    );

    PROCEDURE AHS_BICAN_GETALLBYVUAN (
        VU_AN_ID    IN    NUMBER,
        CURRETURN   OUT   SYS_REFCURSOR
    );

    PROCEDURE GET_CT_TAMGIAM (
        VVUAN_ID         IN    VARCHAR2,
        VHIEULUCTUNGAY   IN    VARCHAR2,
        CURRETURN        OUT   SYS_REFCURSOR
    );

    PROCEDURE AHS_GETKCSOTHAM_XULY (
        VVUANID     IN    NUMBER,
        CURRETURN   OUT   SYS_REFCURSOR
    );

    PROCEDURE AHS_GETKNSOTHAM_XULY (
        VVUANID     IN    NUMBER,
        CURRETURN   OUT   SYS_REFCURSOR
    );

    PROCEDURE DGLIST_QUYETDINH_BICAN_PTDC (
        VLOAIAN     VARCHAR2,
        VDONID      NUMBER,
        CURRETURN   OUT SYS_REFCURSOR
    );

    PROCEDURE AHS_DM_QUYETDINH_VUAN_PTTDC (
        CURRETURN OUT SYS_REFCURSOR
    );

    PROCEDURE DGLIST_QUYETDINH_PTTDC (
        VLOAIAN     VARCHAR2,
        VDONID      NUMBER,
        CURRETURN   OUT SYS_REFCURSOR
    );

    PROCEDURE AHS_DM_QUYETDINHKETQUA_VUAN_PTTDC (
        CURRETURN OUT SYS_REFCURSOR
    );

    PROCEDURE DGLIST_BAQD_QUYETDINH_KETTHUC_PTTDC (
        VLOAIAN     VARCHAR2,
        VDONID      NUMBER,
        CURRETURN   OUT SYS_REFCURSOR
    );

    PROCEDURE AHS_SOTHAM_KCAOKNGHI_GETLIST (
        VVUANID     IN    NUMBER,
        CURRETURN   OUT   SYS_REFCURSOR
    );

END PKG_STPT_AHS_GS;
