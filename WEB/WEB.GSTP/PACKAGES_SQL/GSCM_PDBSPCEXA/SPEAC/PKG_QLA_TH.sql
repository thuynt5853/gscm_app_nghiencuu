--------------------------------------------------------
--  DDL for Package PKG_QLA_TH
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_QLA_TH" AS 

PROCEDURE GETVUVIEC_NHANAN
(
  vToaAnID number,
  curReturn OUT sys_refcursor
);

FUNCTION FUN_GDTTT_VUVIEC_CHECK_DON 
(
  vIDQLA IN NUMBER,
  vMaVuViec in varchar2
) RETURN NUMBER;

PROCEDURE DS_CHUYENAN
(
  vToaAnID number,
  vToaAnNhanID number,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vSoQD in nvarchar2,
  vSoBA in nvarchar2,  
  vTungay in date,
  vDenngay in date,
  vDuongsu in nvarchar2,  
  vTrangthai in number,
  curReturn OUT sys_refcursor
);

PROCEDURE DS_NHANAN
(
  vToaAnID number,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vToachuyen in nvarchar2,
  vTruongHopGiaoNhan in number,
  vTungay in date,
  vDenngay in date,
  vTrangthai in number,
  curReturn OUT sys_refcursor
);
PROCEDURE HC_CHUYENAN
(
  vToaAnID number,
  vToaAnNhanID number,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vSoQD in nvarchar2,
  vSoBA in nvarchar2,  
  vTungay in date,
  vDenngay in date,
  vDuongsu in nvarchar2,  
  vTrangthai in number,
  curReturn OUT sys_refcursor
);

PROCEDURE HC_NHANAN
(
  vToaAnID number,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vToachuyen in nvarchar2,
  vTruongHopGiaoNhan in number,
  vTungay in date,
  vDenngay in date,
  vTrangthai in number,
  curReturn OUT sys_refcursor
);

PROCEDURE HN_CHUYENAN
(
  vToaAnID number,
  vToaAnNhanID number,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vSoQD in nvarchar2,
  vSoBA in nvarchar2,  
  vTungay in date,
  vDenngay in date,
  vDuongsu in nvarchar2,  
  vTrangthai in number,
  curReturn OUT sys_refcursor
);

PROCEDURE HN_NHANAN
(
  vToaAnID number,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vToachuyen in nvarchar2,
  vTruongHopGiaoNhan in number,
  vTungay in date,
  vDenngay in date,
  vTrangthai in number,
  curReturn OUT sys_refcursor
);

PROCEDURE KT_CHUYENAN
(
  vToaAnID number,
  vToaAnNhanID number,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vSoQD in nvarchar2,
  vSoBA in nvarchar2,  
  vTungay in date,
  vDenngay in date,
  vDuongsu in nvarchar2,  
  vTrangthai in number,
  curReturn OUT sys_refcursor
);

PROCEDURE KT_NHANAN
(
  vToaAnID number,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vToachuyen in nvarchar2,
  vTruongHopGiaoNhan in number,
  vTungay in date,
  vDenngay in date,
  vTrangthai in number,
  curReturn OUT sys_refcursor
);
PROCEDURE LD_CHUYENAN
(
  vToaAnID number,
  vToaAnNhanID number,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vSoQD in nvarchar2,
  vSoBA in nvarchar2,  
  vTungay in date,
  vDenngay in date,
  vDuongsu in nvarchar2,  
  vTrangthai in number,
  curReturn OUT sys_refcursor
);

PROCEDURE LD_NHANAN
(
  vToaAnID number,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vToachuyen in nvarchar2,
  vTruongHopGiaoNhan in number,
  vTungay in date,
  vDenngay in date,
  vTrangthai in number,
  curReturn OUT sys_refcursor
);
PROCEDURE PS_CHUYENAN
(
  vToaAnID number,
  vToaAnNhanID number,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vSoQD in nvarchar2,
  vSoBA in nvarchar2,  
  vTungay in date,
  vDenngay in date,
  vDuongsu in nvarchar2,  
  vTrangthai in number,
  curReturn OUT sys_refcursor
);

PROCEDURE PS_NHANAN
(
  vToaAnID number,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vToachuyen in nvarchar2,
  vTruongHopGiaoNhan in number,
  vTungay in date,
  vDenngay in date,
  vTrangthai in number,
  curReturn OUT sys_refcursor
);
PROCEDURE XLHC_CHUYENAN
(
  vToaAnID number,
  vToaAnNhanID number,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vSoQD in nvarchar2,
  vSoBA in nvarchar2,  
  vTungay in date,
  vDenngay in date,
  vDuongsu in nvarchar2,  
  vTrangthai in number,
  curReturn OUT sys_refcursor
);

PROCEDURE XLHC_NHANAN
(
  vToaAnID number,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vToachuyen in nvarchar2,
  vTruongHopGiaoNhan in number,
  vTungay in date,
  vDenngay in date,
  vTrangthai in number,
  curReturn OUT sys_refcursor
);
PROCEDURE HS_CHUYENAN
(
  vToaAnID number,
  vToaAnNhanID number,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vSoQD in nvarchar2,
  vSoBA in nvarchar2,  
  vTungay in date,
  vDenngay in date,
  vDuongsu in nvarchar2,  
  vTrangthai in number,
  curReturn OUT sys_refcursor
);
PROCEDURE HS_NHANAN
(
  vToaAnID number,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vToachuyen in nvarchar2,
  vTruongHopGiaoNhan in number,
  vTungay in date,
  vDenngay in date,
  vTrangthai in number,
  curReturn OUT sys_refcursor
);
PROCEDURE FILL_HS_CHUYENAN
(
  v_ARRAY IN OUT T_CHUYENAN
);
PROCEDURE FILL_HS_NHANAN
(
  v_ARRAY IN OUT T_NHANAN
);
PROCEDURE FILL_DS_CHUYENAN
(
  v_ARRAY IN OUT T_CHUYENAN
);
PROCEDURE FILL_DS_NHANAN
(
  v_ARRAY IN OUT T_NHANAN
);
PROCEDURE FILL_HC_CHUYENAN
(
  v_ARRAY IN OUT T_CHUYENAN
);
PROCEDURE FILL_HC_NHANAN
(
  v_ARRAY IN OUT T_NHANAN
);
PROCEDURE FILL_HN_CHUYENAN
(
  v_ARRAY IN OUT T_CHUYENAN
);
PROCEDURE FILL_HN_NHANAN
(
  v_ARRAY IN OUT T_NHANAN
);
PROCEDURE FILL_KT_CHUYENAN
(
  v_ARRAY IN OUT T_CHUYENAN
);
PROCEDURE FILL_KT_NHANAN
(
  v_ARRAY IN OUT T_NHANAN
);
PROCEDURE FILL_LD_CHUYENAN
(
  v_ARRAY IN OUT T_CHUYENAN
);
PROCEDURE FILL_LD_NHANAN
(
  v_ARRAY IN OUT T_NHANAN
);
PROCEDURE FILL_PS_CHUYENAN
(
  v_ARRAY IN OUT T_CHUYENAN
);
PROCEDURE FILL_PS_NHANAN
(
  v_ARRAY IN OUT T_NHANAN
);
PROCEDURE FILL_XLHC_CHUYENAN
(
  v_ARRAY IN OUT T_CHUYENAN
);
PROCEDURE FILL_XLHC_NHANAN
(
  v_ARRAY IN OUT T_NHANAN
);
PROCEDURE QLA_CHANH_AN_TRANG_CHU
(
  vToaAnID in number, 
  vTungay in date,
  vDenngay in date,
  curReturn OUT sys_refcursor
);
PROCEDURE FILL_QLA_CHANH_AN_TRANG_CHU
(
    v_CAP_XET_XU IN VARCHAR2,
    v_LOAIAN IN VARCHAR2,
    v_TOAANID IN NUMBER,
    v_INDEX IN NUMBER,
    v_DATE_TUNGAY IN Date,
    v_DATE_DENNGAY IN Date,
    v_ARRAY IN OUT QLA_CHANH_AN_TRANG_CHU_T
);
PROCEDURE QLA_CHANH_AN_TRANG_CHU_TP
(
  vToaAnID in number, 
  vTungay in date,
  vDenngay in date,
  curReturn OUT sys_refcursor
);
PROCEDURE FILL_QLA_CHANH_AN_TRANG_CHU_TP
(
  v_ToaAnID IN number,
  v_DATE_TUNGAY IN Date,
  v_DATE_DENNGAY IN Date,
  v_ARRAY IN OUT QLA_THAM_PHAN_TRANG_CHU_T
);
PROCEDURE QLA_CA_TRANG_CHU_TP_CHITIET
(
  vToaAnID in number, 
  vThamPhanID in number,
  vTungay in date,
  vDenngay in date,
  curReturn OUT sys_refcursor
);
PROCEDURE FILL_QLA_CA_HOME_TP_CHITIET
(
    v_CAP_XET_XU IN VARCHAR2,
    v_LOAIAN IN VARCHAR2,
    v_TOAANID IN NUMBER,
    v_THAMPHANID IN NUMBER,
    v_INDEX IN NUMBER,
    v_DATE_TUNGAY IN Date,
    v_DATE_DENNGAY IN Date,
    v_ARRAY IN OUT QLA_TP_TRANG_CHU_CHI_TIET_T
);
END PKG_QLA_TH;
