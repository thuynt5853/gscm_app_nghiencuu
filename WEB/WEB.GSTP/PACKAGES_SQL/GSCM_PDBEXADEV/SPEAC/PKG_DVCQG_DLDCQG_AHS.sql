--------------------------------------------------------
--  DDL for Package PKG_DVCQG_DLDCQG_AHS
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_DVCQG_DLDCQG_AHS" AS 

PROCEDURE EXT_SEARCH_ALL
(
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
    v_VUANID in NUMBER,
    Page_Index in	int,
    Page_Size	in	int,
    curReturn OUT sys_refcursor
);

PROCEDURE EXT_SEARCH_ALL_DaDongBo_ThuHoi
(
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
    V_TRANGTHAIDONGBO in varchar2,  

    Page_Index in	int,
    Page_Size	in	int,
    curReturn OUT sys_refcursor
);

FUNCTION FN_GET_BICAO_COUNT(
    v_BAQD_id IN NUMBER,
    v_Capxx IN VARCHAR2,
    v_LOAIBAQD IN VARCHAR2
    
) RETURN NUMBER;

PROCEDURE GET_BICANBICAO_BY_BAQDID
(
    v_BAQD_id in varchar2,
    v_LOAIBAQD in varchar2,
    v_Capxx in varchar2,
    curReturn OUT sys_refcursor
);

PROCEDURE get_toidanh_by_bicao (
    vbicaoid      IN    NUMBER,
    v_capxx       IN    VARCHAR2,
    v_loaiba_qd   IN    VARCHAR2,
    curretun      OUT   SYS_REFCURSOR
);

PROCEDURE get_hinhphat_by_toidanh_bicao (
    vbicaoid      IN    NUMBER,
    v_toidanhid   IN    NUMBER,
    v_capxx       IN    VARCHAR2,
    v_loaiba_qd   IN    VARCHAR2,
    curreturn     OUT   SYS_REFCURSOR
);

PROCEDURE GET_PAGING_BICANBICAO_BY_BAQDID
(
    v_BAQD_id in varchar2,
    v_LOAIBAQD in varchar2,
    v_Capxx in varchar2,
    v_trangthai in varchar2,
    
    Page_Index in	int,
    Page_Size	in	int,
    curReturn OUT sys_refcursor
);

END PKG_DVCQG_DLDCQG_AHS;

/
