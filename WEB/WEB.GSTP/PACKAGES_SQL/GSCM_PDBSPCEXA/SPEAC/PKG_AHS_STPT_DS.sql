--------------------------------------------------------
--  DDL for Package PKG_AHS_STPT_DS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "GSCM"."PKG_AHS_STPT_DS" AS 

PROCEDURE AHS_VUAN_GETALLPAGING
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
    vchecktk in number,
    V_THANHNIEN in number,
    v_HINHTHUCXX in number,
    v_GDTaoHS in number,
	V_VAITRO_THAMPHAN IN VARCHAR2,
    Page_Index in	int,
    Page_Size	in	int, 
    curReturn OUT sys_refcursor
);
FUNCTION AHS_VUAN_GETALLPAGING_ITEM
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
    Page_Index in	int,
    Page_Size	in	int
)RETURN T_STPT_6LOAIAN;

PROCEDURE   AHS_PT_KCKN_TINHTRANG_GETLIST
( 
    vVUANID in int,
	curReturn OUT sys_refcursor
);


--PROCEDURE AHS_VUAN_GETALLPAGING
--(
--    V_CAP_XET_XU_LOGIN  IN VARCHAR2,
--    v_ten_vu_an in varchar2, 
--    v_toidanh in varchar2, 
--    v_ma_vu_an in varchar2, 
--    v_bi_can in varchar2,
--    v_Capxx in varchar2,
--    v_toaan_id in varchar2, 
--    v_TINHTRANG_THULY in varchar2,
--    V_NGAYTHULY_TU in varchar2,
--    V_NGAYTHULY_DEN in varchar2,
--    v_SOTHULY in varchar2,
--    v_TINHTRANG_GIAIQUYET in varchar2,
--    V_TUNGAY IN VARCHAR2,
--    V_DENNGAY IN VARCHAR2,
--    v_KETQUA in varchar2,
--    v_so_qd in varchar2,
--    v_ngay_qd in varchar2,
--    v_thamphan_id in varchar2, 
--    v_thuky_id in varchar2, 
--    v_THOIHAN_GQ in varchar2, 
--    v_QD_TAMGIAM in varchar2,
--    V_UTTP IN VARCHAR2,
--    vchecktk in number,
--    V_THANHNIEN in number,
--    Page_Index in	int,
--    Page_Size	in	int, 
--    curReturn OUT sys_refcursor
--);


END PKG_AHS_STPT_DS;
