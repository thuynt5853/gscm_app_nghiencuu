--------------------------------------------------------
--  DDL for Package PKG_STPT_APS_GS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "GSCM"."PKG_STPT_APS_GS" AS
    PROCEDURE APS_DON_SEARCH (
        V_CAPXETXULOGIN             IN VARCHAR2,
        VDONVIID                    IN VARCHAR2,
        VTENVIEC                    IN VARCHAR2,
        VLOAIHINHDOANHNGHIEP        IN VARCHAR2,
        VMAVIEC                     IN VARCHAR2,
        VDUONGSU_NGUOITHAMGIATOTUNG IN VARCHAR2,
        VCAPXETXU                   IN VARCHAR2,
        VTOAXETXU                   IN VARCHAR2,
        VTINHTRANGTHULY             IN VARCHAR2,
        VTUNGAYTHULY                IN VARCHAR2,
        VDENNGAYTHULY               IN VARCHAR2,
        VSOTHULY                    IN VARCHAR2,
        VTINHTRANGGQ                IN VARCHAR2,
        VTUNGAYTINHTRANGGQ          IN VARCHAR2,
        VDENNGAYTINHTRANGGQ         IN VARCHAR2,
        VTHAMPHAN                   IN VARCHAR2,
        VTHOIHANGQ                  IN VARCHAR2,
        VSOQD                       IN VARCHAR2,
        VNGAYQD                     IN VARCHAR2,
        VTHUKY                      IN VARCHAR2,
        VGQDON                      IN VARCHAR2,
        VUYTHACTUPHAP               IN VARCHAR2,
        VPTRUTKINHNGHIEM            IN VARCHAR2,
        VCHECKTK                    IN NUMBER,
        V_TRANGTHAIVUAN             IN NUMBER,
        V_VAITRO_THAMPHAN           IN VARCHAR2,
        V_CHECK_HOAGIAI             IN NUMBER,
        PAGE_INDEX                  IN INT,
        PAGE_SIZE                   IN INT,
        CURRETURN                   OUT SYS_REFCURSOR
    );


    -----------------------
    PROCEDURE APS_PHUCTHAM_KCKN_TGTT_GETLIST (
        VDONID    IN NUMBER,
        CURRETURN OUT SYS_REFCURSOR
    );  
   ---------------------------
    PROCEDURE APS_KCKNQDK_PHUCTHAM_HDXX_GETLIST (
        VDONID    IN NUMBER,
        CURRETURN OUT SYS_REFCURSOR
    );


    -------------------------
    PROCEDURE APS_KCKNQDK_PHUCTHAM_QUYETDINH_GETLIST (
        VDONID    IN NUMBER,
        CURRETURN OUT SYS_REFCURSOR
    );
    ----------------------------------
    PROCEDURE APS_PHUCTHAMQDK_BANANQUYETDINH_GETLIST (
        VDONID    IN NUMBER,
        CURRETURN OUT SYS_REFCURSOR
    );

    ------------------------------
    PROCEDURE APS_DM_QUYETDINH_VUAN_PTQDK (
        CURRETURN OUT SYS_REFCURSOR
    );

------------------------------------
    PROCEDURE APS_PHUCTHAMQDK_THULY_GETMAXTT (
        VDONVIID  IN NUMBER,
        VFROMDATE IN DATE,
        VTODATE   IN DATE,
        CURRETURN OUT SYS_REFCURSOR
    );

/*
    PROCEDURE SO_DK_KCKN_PS (
        V_DK_PS  OUT NUMBER,
        VTOAANID IN VARCHAR2,
        V_CXX    IN VARCHAR2
    );
*/
    PROCEDURE UPDATE_NOIDUNG_CHUYENNHANAN (
        VNHANANID IN NUMBER,
        VNOIDUNG  IN VARCHAR2,
        V_VUANID  IN NUMBER
    );

    PROCEDURE COUNT_KCKN_TDC (
        VDONID IN NUMBER,
        VOUT   OUT NUMBER
    );

    PROCEDURE PS_CHUYENDON (
        VTOAANID       NUMBER,
        VTOAANNHAN_TEN IN VARCHAR2,
        VMAVUVIEC      IN NVARCHAR2,
        VTENVUVIEC     IN NVARCHAR2,
        VSOQD          IN NVARCHAR2,
        VSOBA          IN NVARCHAR2,
        VTUNGAY        IN DATE,
        VDENNGAY       IN DATE,
        VDUONGSU       IN NVARCHAR2,
        VTRANGTHAI     IN NUMBER,
        CURRETURN      OUT SYS_REFCURSOR
    );

    PROCEDURE PS_NHANDON (
        V_NG_KC            IN VARCHAR2,
        VTOAANID           NUMBER,
        VMAVUVIEC          IN NVARCHAR2,
        VTENVUVIEC         IN NVARCHAR2,
        VTOACHUYEN         IN NVARCHAR2,
        VTRUONGHOPGIAONHAN IN NUMBER,
        VTUNGAY            IN DATE,
        VDENNGAY           IN DATE,
        VTRANGTHAI         IN NUMBER,
        V_SO_QD            IN VARCHAR2,
        V_NGAY_QD          IN VARCHAR2,
        CURRETURN          OUT SYS_REFCURSOR
    );

        PROCEDURE APS_KCKNQDK_PHUCTHAM_THULY_GETLIST (
        VDONID    IN NUMBER,
        CURRETURN OUT SYS_REFCURSOR
    );


    PROCEDURE SO_DK_KCKN_PS (
        V_DK_PS  OUT NUMBER,
        VTOAANID IN VARCHAR2,
        V_CXX    IN VARCHAR2
    );

    PROCEDURE APS_DON_SEARCH_V2 (
        V_CAPXETXULOGIN             IN VARCHAR2,
        VDONVIID                    IN VARCHAR2,
        VTENVIEC                    IN VARCHAR2,
        VLOAIHINHDOANHNGHIEP        IN VARCHAR2,
        VMAVIEC                     IN VARCHAR2,
        VDUONGSU_NGUOITHAMGIATOTUNG IN VARCHAR2,
        VCAPXETXU                   IN VARCHAR2,
        VTOAXETXU                   IN VARCHAR2,
        VTINHTRANGTHULY             IN VARCHAR2,
        VTUNGAYTHULY                IN VARCHAR2,
        VDENNGAYTHULY               IN VARCHAR2,
        VSOTHULY                    IN VARCHAR2,
        VTINHTRANGGQ                IN VARCHAR2,
        VTUNGAYTINHTRANGGQ          IN VARCHAR2,
        VDENNGAYTINHTRANGGQ         IN VARCHAR2,
        VTHAMPHAN                   IN VARCHAR2,
        VTHOIHANGQ                  IN VARCHAR2,
        VSOQD                       IN VARCHAR2,
        VNGAYQD                     IN VARCHAR2,
        VTHUKY                      IN VARCHAR2,
        VGQDON                      IN VARCHAR2,
        VUYTHACTUPHAP               IN VARCHAR2,
        VPTRUTKINHNGHIEM            IN VARCHAR2,
        VCHECKTK                    IN NUMBER,
        V_TRANGTHAIVUAN             IN NUMBER,
        V_VAITRO_THAMPHAN           IN VARCHAR2,
        V_CHECK_HOAGIAI             IN NUMBER, 
        PAGE_INDEX                  IN INT,
        PAGE_SIZE                   IN INT,
        CURRETURN                   OUT SYS_REFCURSOR
    );


END PKG_STPT_APS_GS;

/
