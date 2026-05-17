--------------------------------------------------------
--  DDL for Package PKG_BAN_GIAO_THI_HANH_AN
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "GSCM"."PKG_BAN_GIAO_THI_HANH_AN" AS 

  /* TODO enter package declarations (types, exceptions, methods etc) here */ 

-- [ADS] LẤY DANH SÁCH CÓ THỂ BÀN GIAO
PROCEDURE THI_HANH_AN_BANGIAO_MAPPING_GET_AN_BAN_GIAO (
        p_LOAIAN IN NUMBER
      , p_TRANGTHAI IN NVARCHAR2
      , TOA_AN_ID   IN NUMBER
      , MA_BI_AN    IN NVARCHAR2
      , TEN_BI_AN   IN NVARCHAR2
      , MA_VU_AN    IN NVARCHAR2
      , TEN_VU_AN   IN NVARCHAR2
      , SO_BAN_AN   IN VARCHAR2
      , NGAY_BAN_AN IN DATE
      , TRANGTHAI   IN NUMBER
      , TRANGTHAIGQ IN NUMBER
      , V_SOCMND    IN NVARCHAR2
      , V_TUNGAY    IN NVARCHAR2
      , V_DENNGAY   IN NVARCHAR2
      , p_CURSOR OUT SYS_REFCURSOR   
);

-- [THA] LẤY DANH SÁCH CHỜ DUYỆT
PROCEDURE THI_HANH_AN_BANGIAO_MAPPING_GETS_CHONHAN (
      p_TOAANID   IN NUMBER,
      p_MA_BI_AN    IN NVARCHAR2,
      p_TEN_BI_AN   IN NVARCHAR2,
      p_MA_VU_AN    IN NVARCHAR2,
      p_TEN_VU_AN   IN NVARCHAR2,
      p_SO_BAN_AN   IN VARCHAR2,
      p_NGAY_BAN_AN IN DATE,
      p_TRANGTHAI_GQ   IN NUMBER,
      p_SOCMND    IN NVARCHAR2,
      p_TUNGAY    IN NVARCHAR2,
      p_DENNGAY   IN NVARCHAR2,
      p_TRANGTHAI IN NVARCHAR2,
      CURRETURN   OUT SYS_REFCURSOR
);
-- [THA] LẤY DANH SÁCH CHỜ DUYỆT THA
PROCEDURE THI_HANH_AN_BANGIAO_MAPPING_GETS_CHONHAN_THA (
    p_TOAANID       IN NUMBER,
    p_MA_BI_AN      IN NVARCHAR2,
    p_TEN_BI_AN     IN NVARCHAR2,
    p_MA_VU_AN      IN NVARCHAR2,
    p_TEN_VU_AN     IN NVARCHAR2,
    p_SO_BAN_AN     IN VARCHAR2,
    p_NGAY_BAN_AN   IN DATE,
    p_TRANGTHAI_GQ  IN NUMBER,
    p_TINHTRANG_QD  IN NUMBER,
    p_SOCMND        IN NVARCHAR2,
    p_TUNGAY        IN NVARCHAR2,
    p_DENNGAY       IN NVARCHAR2,
    p_TRANGTHAI     IN NVARCHAR2,
    CURRETURN       OUT SYS_REFCURSOR
);
-- [THA] NHẬN BÀN GIAO
PROCEDURE THI_HANH_AN_BANGIAO_MAPPING_NHAN (
    p_ID IN NUMBER,
    p_VUVIECID IN NUMBER,
    p_TOAANNHANID IN NUMBER
);

PROCEDURE THI_HANH_AN_BANGIAO_MAPPING_GET_AN_NHAN_BAN_GIAO (
    vLoaian IN varchar2,
    vTOAANID IN NUMBER,
    vMAVUVIEC IN varchar2,
    vTHULYTUNGAY IN date,
    vTINHTRANGTHULY IN nvarchar2,
    vTHAMPHANGIAIQUYET IN nvarchar2,
    vTENVUAN IN nvarchar2,    
    vDENNGAY IN date,    
    vTRANGTHAIGIAIQUYET IN nvarchar2,    
    vCAPXETXU IN nvarchar2,  
    vCURSOR OUT SYS_REFCURSOR
);

PROCEDURE THI_HANH_AN_BANGIAO_MAPPING_ADD (
    p_TOAANGIAOID            IN NUMBER,
    p_TOAANGIAOTEN           IN VARCHAR2,
    p_TOAANNHANID            IN NUMBER,
    p_TOAANNHANTEN           IN VARCHAR2,
    p_VUVIECID               IN VARCHAR2,
    p_VUVIECLOAI             IN VARCHAR2,
    p_VUVIECMA               IN VARCHAR2,
    p_VUVIECTEN              IN VARCHAR2,
    p_NGUOIGIAOID            IN VARCHAR2,
    p_NGUOIGIAOTEN           IN VARCHAR2,
    p_NGUOINHANID            IN VARCHAR2,
    p_NGUOINHANTEN           IN VARCHAR2,
    p_LYDOMA                 IN VARCHAR2,
    p_NGAYGIAO               IN DATE,
    p_ISQUYETDINHCHUYEN      IN NUMBER,
    p_SOQUYETDINH            IN VARCHAR2,
    p_NGAYQUYETDINH          IN DATE,
    p_NGUOIKY                IN VARCHAR2,
    p_TRANGTHAI              IN VARCHAR2,
    p_GHICHU                 IN VARCHAR2
);

PROCEDURE THI_HANH_AN_BANGIAO_MAPPING_EDIT (
    p_ID                      IN NUMBER,
    p_TOAANGIAOID            IN NUMBER,
    p_TOAANGIAOTEN           IN VARCHAR2,
    p_TOAANNHANID            IN NUMBER,
    p_TOAANNHANTEN           IN VARCHAR2,
    p_VUVIECID               IN VARCHAR2,
    p_VUVIECMA               IN VARCHAR2,
    p_VUVIECTEN              IN VARCHAR2,
    p_NGUOIGIAOID            IN VARCHAR2,
    p_NGUOIGIAOTEN           IN VARCHAR2,
    p_NGUOINHANID            IN VARCHAR2,
    p_NGUOINHANTEN           IN VARCHAR2,
    p_LYDOMA                 IN VARCHAR2,
    p_NGAYGIAO               IN DATE,
    p_ISQUYETDINHCHUYEN      IN NUMBER,
    p_SOQUYETDINH            IN VARCHAR2,
    p_NGAYQUYETDINH          IN DATE,
    p_NGUOIKY                IN VARCHAR2,
    p_TRANGTHAI              IN VARCHAR2,
    p_GHICHU                 IN VARCHAR2
);

PROCEDURE THI_HANH_AN_BANGIAO_MAPPING_DELETE (
    p_ID               IN NUMBER
);

PROCEDURE THI_HANH_AN_BANGIAO_MAPPING_CHANGE_STATUS (
    p_ID IN NUMBER,
    p_TRANGTHAI IN VARCHAR2
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
        TRANGTHAIGQ   IN NUMBER,
        V_SOCMND in nvarchar2,
         V_TUNGAY    IN NVARCHAR2,
        V_DENNGAY      IN NVARCHAR2,

        CURRETURN   OUT SYS_REFCURSOR
    );

PROCEDURE        THA_BIAN_GETANNGOAIHT 
(
    toa_an_id in number
   ,  ma_bi_an in nvarchar2, ten_bi_an in nvarchar2
   , ma_vu_an in nvarchar2, ten_vu_an in nvarchar2
   , so_ban_an in varchar2, ngay_ban_an in date,
    TRANGTHAI   IN NUMBER,TRANGTHAIGQ   IN NUMBER,
     v_SOCMND in nvarchar2,
         V_TUNGAY    IN NVARCHAR2,
        V_DENNGAY      IN NVARCHAR2,
   curReturn    OUT   sys_refcursor
);
END PKG_BAN_GIAO_THI_HANH_AN;

/
