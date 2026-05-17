--------------------------------------------------------
--  DDL for Package PKG_DVCQG_DLDCQG
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_DVCQG_DLDCQG" AS 

FUNCTION CREATE_MA_DONGBO_RANDOM
RETURN VARCHAR2;

PROCEDURE GetDulieuChon_ThuHoiGanNhat
(   v_LoaiAn in varchar2, 
    v_LoaiBAQD in varchar2, 
    v_IdBAQD in varchar2, 
    curReturn OUT sys_refcursor
);

PROCEDURE GET_BAQD_DaDongBo_BY_ID
(  V_DonBoID in varchar2,   
    curReturn OUT sys_refcursor
);

PROCEDURE GET_BAQD_LichSuChuyen
(  V_DongBoID in varchar2,   
    curReturn OUT sys_refcursor
);

PROCEDURE EXT_SEARCH_ALL_ThuHoi
(  
    V_LOAIAN_ID IN VARCHAR2,
    v_LOAIBAQD in varchar2,
    v_BAQD_id in varchar2,
    v_KHANGCAOQH in varchar2,
    v_toaan_id in varchar2,
    v_Capxx in varchar2,
    
    v_ten_vu_an in varchar2, 
    v_toidanh in varchar2, 
    v_ma_vu_an in varchar2, 
    v_bi_can in varchar2,
    v_cccd  in varchar2,     
    v_so_qd in varchar2,
    V_TUNGAY IN VARCHAR2,
    V_DENNGAY IN VARCHAR2,
    v_thamphan_id in varchar2, 
    v_thuky_id in varchar2,
    V_TRANGTHAI_GUI IN DECIMAL,
    V_NGAYGUI_TU in varchar2,
    V_NGAYGUI_DEN in varchar2,
    
    Page_Index in	int,
    Page_Size	in	int,
    curReturn OUT sys_refcursor
);

PROCEDURE EXT_SEARCH_ALL_DaDongBo
(  
    V_LOAIAN_ID IN VARCHAR2,
    v_LOAIBAQD in varchar2,
    v_BAQD_id in varchar2,
    v_KHANGCAOQH in varchar2,
    
    v_toaan_id in varchar2,
    v_Capxx in varchar2,
    v_ten_vu_an in varchar2, 
    v_toidanh in varchar2, 
    v_ma_vu_an in varchar2, 
    v_bi_can in varchar2,
    v_cccd  in varchar2,     
    v_so_qd in varchar2,
    V_TUNGAY IN VARCHAR2,
    V_DENNGAY IN VARCHAR2,
    v_thamphan_id in varchar2, 
    v_thuky_id in varchar2,
    V_TRANGTHAI_GUI IN DECIMAL,
    V_NGAYGUI_TU in varchar2,
    V_NGAYGUI_DEN in varchar2,
    
    Page_Index in	int,
    Page_Size	in	int,
    curReturn OUT sys_refcursor
);

PROCEDURE EXT_SEARCH_ALL
(  
    V_LOAIAN_ID IN VARCHAR2,
    v_LOAIBAQD in varchar2,
    v_BAQD_id in varchar2,
    v_KHANGCAOQH in varchar2,
    
    v_toaan_id in varchar2,
    v_Capxx in varchar2,
    v_ten_vu_an in varchar2, 
    
    v_toidanh in varchar2, 
    v_ma_vu_an in varchar2, 
    v_bi_can in varchar2,
    v_cccd  in varchar2,     
    v_so_qd in varchar2,
    V_TUNGAY IN VARCHAR2,
    V_DENNGAY IN VARCHAR2,
    v_thamphan_id in varchar2, 
    v_thuky_id in varchar2,
    V_TRANGTHAI_GUI IN varchar2,
    V_NGAYGUI_TU in varchar2,
    V_NGAYGUI_DEN in varchar2,
    
    
    Page_Index in	int,
    Page_Size	in	int,
    curReturn OUT sys_refcursor
);

PROCEDURE AHN_TONGDAT_BA_TTHN
(
    V_TUNGAY IN DATE,
    V_DENNGAY IN DATE,
    curReturn OUT SYS_REFCURSOR
);

END PKG_DVCQG_DLDCQG;

/
