--------------------------------------------------------
--  DDL for Package PKG_DVCQG_DLDCQG_LD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "GSCM"."PKG_DVCQG_DLDCQG_LD" AS 

PROCEDURE SEARCH_PAGING_CHUADONGBO
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
    v_CheckNullKHOBAQD in NUMBER,
    v_DONID in NUMBER,
    Page_Index in	int,
    Page_Size	in	int,
    curReturn OUT sys_refcursor
);

PROCEDURE SEARCH_PAGING_DADONGBO
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
    V_TRANGTHAIDONGBO in varchar2,
    
    Page_Index in	int,
    Page_Size	in	int,
    curReturn OUT sys_refcursor
);

END PKG_DVCQG_DLDCQG_LD;

/
