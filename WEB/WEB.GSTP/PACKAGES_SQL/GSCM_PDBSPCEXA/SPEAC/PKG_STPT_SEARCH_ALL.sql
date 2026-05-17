--------------------------------------------------------
--  DDL for Package PKG_STPT_SEARCH_ALL
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_STPT_SEARCH_ALL" AS
PROCEDURE HS_DS_EXT_SEARCH_ALL
(
    V_CAP_XET_XU_LOGIN  IN VARCHAR2,
    v_ten_vu_an in varchar2, 
    v_toidanh in varchar2, 
    v_ma_vu_an in varchar2, 
    v_bi_can in varchar2,
    v_Capxx in varchar2,
    v_toaan_id in varchar2, 
    v_TINHTRANG_THULY in varchar2,
    V_NGAYTHULY_TU in varchar2,
    V_NGAYTHULY_DEN in varchar2,
    v_SOTHULY in varchar2,
    v_TINHTRANG_GIAIQUYET in varchar2,
    V_TUNGAY IN VARCHAR2,
    V_DENNGAY IN VARCHAR2,
    v_KETQUA in varchar2,
    v_so_qd in varchar2,
    v_ngay_qd in varchar2,
    v_thamphan_id in varchar2, 
    v_thuky_id in varchar2, 
    v_THOIHAN_GQ in varchar2, 
    v_QD_TAMGIAM in varchar2,
    V_UTTP IN VARCHAR2,
    V_LOAIAN_ID IN VARCHAR2,
    Page_Index in	int,
    Page_Size	in	int,
    curReturn OUT sys_refcursor
);
FUNCTION HS_DS_AN_DATHULY
(
    V_CAP_XET_XU_LOGIN  IN VARCHAR2,
    v_ten_vu_an in varchar2, 
    v_toidanh in varchar2, 
    v_ma_vu_an in varchar2, 
    v_bi_can in varchar2,
    v_Capxx in varchar2,
    v_toaan_id in varchar2, 
    v_TINHTRANG_THULY in varchar2,
    V_NGAYTHULY_TU in varchar2,
    V_NGAYTHULY_DEN in varchar2,
    v_SOTHULY in varchar2,
    v_TINHTRANG_GIAIQUYET in varchar2,
    V_TUNGAY IN VARCHAR2,
    V_DENNGAY IN VARCHAR2,
    v_KETQUA in varchar2,
    v_so_qd in varchar2,
    v_ngay_qd in varchar2,
    v_thamphan_id in varchar2, 
    v_thuky_id in varchar2, 
    v_THOIHAN_GQ in varchar2, 
    v_QD_TAMGIAM in varchar2,
    V_UTTP IN VARCHAR2,
    V_LOAIAN_ID IN VARCHAR2,
    Page_Index in	int,
    Page_Size	in	int
)RETURN SYS_REFCURSOR;

FUNCTION NHAPLIEU_HS_DS_EXT_ALL
(
    vDonViID  IN number,
    v_TINHTRANG_THULY IN VARCHAR2,
    v_TINHTRANG_GIAIQUYET IN VARCHAR2,
    V_TUNGAY IN VARCHAR2,
    V_DENNGAY IN VARCHAR2,
    v_TOAANID in VARCHAR2
)RETURN SYS_REFCURSOR;

FUNCTION HS_DS_AN_CHUYENVKS
(
    V_DON_ID  IN varchar2,
    V_DONVIID IN NUMBER
)RETURN SYS_REFCURSOR;
PROCEDURE HS_DS_GIAO_HOSO_VKS
(
    V_DON_ID  IN varchar2,
    curReturn OUT sys_refcursor
);

END PKG_STPT_SEARCH_ALL;
