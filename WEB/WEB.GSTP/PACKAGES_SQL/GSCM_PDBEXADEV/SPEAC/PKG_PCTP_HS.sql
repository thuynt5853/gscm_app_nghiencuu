--------------------------------------------------------
--  DDL for Package PKG_PCTP_HS
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_PCTP_HS" AS
PROCEDURE PCTP_INS_UP
(
    V_TRANGTHAI IN VARCHAR2,
    V_THAMPHANGQ_ID IN VARCHAR2,
    V_VUANID	IN VARCHAR2,
    V_SOQD	IN VARCHAR2,
    V_NGAYQD	IN VARCHAR2,
    V_THULY	IN VARCHAR2,
    V_NGAYPHANCONGTP	IN VARCHAR2,
    V_THAM_PHAN_ID	IN VARCHAR2,
    V_NGAYPHANCONGLD	IN VARCHAR2,
    V_PHANCONGLD_ID	IN VARCHAR2,
    V_CAPXX	IN VARCHAR2,
    V_NGUOITAO IN VARCHAR2,
    V_TOA_GIAIQUYET_ID IN VARCHAR2,
    V_COUNTS OUT NUMBER,
    V_THONGBAO	OUT VARCHAR2
);
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
    Page_Index in	int,
    Page_Size	in	int, 
    curReturn OUT sys_refcursor
);
FUNCTION AHS_VUAN_GETALLPAGING_PRINT
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
    Page_Index in	int,
    Page_Size	in	int
)RETURN SYS_REFCURSOR;

--FUNCTION AHS_VUAN_GETALLPAGING_PRINT_ITEM
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
--    Page_Index in	int,
--    Page_Size	in	int
--)RETURN SYS_REFCURSOR;


END PKG_PCTP_HS;

/
