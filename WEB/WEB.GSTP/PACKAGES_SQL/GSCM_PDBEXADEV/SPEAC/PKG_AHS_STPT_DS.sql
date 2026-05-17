CREATE OR REPLACE PACKAGE GSCM.PKG_AHS_STPT_DS AS 

PROCEDURE AHS_VUAN_SEARCH_TURNING
(
    V_CAP_XET_XU_LOGIN          IN VARCHAR2,
    V_TEN_VU_AN                 IN VARCHAR2, 
    V_TOIDANH                   IN VARCHAR2, 
    V_MA_VU_AN                  IN VARCHAR2, 
    V_BI_CAN                    IN VARCHAR2,
    V_CAPXX                     IN VARCHAR2,
    V_TOAAN_ID                  IN VARCHAR2, 
    V_TINHTRANG_THULY           IN VARCHAR2,
    V_NGAYTHULY_TU              IN VARCHAR2,
    V_NGAYTHULY_DEN             IN VARCHAR2,
    V_SOTHULY                   IN VARCHAR2,
    V_TINHTRANG_GIAIQUYET       IN VARCHAR2,
    V_TUNGAY                    IN VARCHAR2,
    V_DENNGAY                   IN VARCHAR2,
    V_KETQUA                    IN VARCHAR2,
    V_SO_QD                     IN VARCHAR2,
    V_NGAY_QD                   IN VARCHAR2,
    V_THAMPHAN_ID               IN VARCHAR2, 
    V_THUKY_ID                  IN VARCHAR2, 
    V_THOIHAN_GQ                IN VARCHAR2, 
    V_QD_TAMGIAM                IN VARCHAR2,
    V_UTTP                      IN VARCHAR2,
    VCHECKTK                    IN NUMBER,
    V_THANHNIEN                 IN NUMBER,
    V_HINHTHUCXX                IN NUMBER,
    V_GDTAOHS                   IN NUMBER,
	V_VAITRO_THAMPHAN           IN VARCHAR2,
    V_AN_KET_THUC               IN NUMBER,
    PAGE_INDEX                  IN INT,
    PAGE_SIZE	                IN INT, 
    CURRETURN                   OUT SYS_REFCURSOR
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

END PKG_AHS_STPT_DS;