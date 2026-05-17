create or replace NONEDITIONABLE PACKAGE        "PKG_STPT_DS" AS

FUNCTION DON_SEARCH_ITEM
( 
    V_CAP_XET_XU_LOGIN  IN VARCHAR2,
    V_TEN_VU_AN IN VARCHAR2, 
    V_QHPL IN VARCHAR2, 
    V_MA_VU_AN IN VARCHAR2, 
    V_TENDUONGSU IN VARCHAR2,
    V_CAPXX IN VARCHAR2,
    V_TOAAN_ID IN VARCHAR2, 
    V_TINHTRANG_THULY IN VARCHAR2,
    V_NGAYTHULY_TU IN VARCHAR2,
    V_NGAYTHULY_DEN IN VARCHAR2,
    V_SOTHULY IN VARCHAR2,
    V_THAMPHAN_ID IN VARCHAR2, 
    V_TINHTRANG_GIAIQUYET IN VARCHAR2,
    V_TUNGAY IN VARCHAR2,
    V_DENNGAY IN VARCHAR2,
    V_KETQUA IN VARCHAR2,
    V_SO_QD IN VARCHAR2,
    V_NGAY_QD IN VARCHAR2,
    V_THUKY_ID IN VARCHAR2, 
    V_THOIHAN_GQ IN VARCHAR2, 
    V_LOAIDON IN VARCHAR2, 
    V_PT_RKINHNGHIEM IN VARCHAR2, 
    V_GQDON IN VARCHAR2, 
    V_UTTP IN VARCHAR2,
    Page_Index in	int,
    Page_Size	in	int
)RETURN T_STPT_6LOAIAN;
PROCEDURE  ADS_FILE_CHECKSTT
(   vdonviID in number,
    vMaGiaiDoan number,
    vNam number,
    vLoaiFile number,
    vSTT    number,
    curReturn    OUT       sys_refcursor
);
PROCEDURE  ADS_FILE_CHECKSTT_ANPHI
(   vdonviID in number,
    vMaGiaiDoan number,
    vNam number,
    vLoaiFile number,
    vSTT    number,
    vSTB_Phu IN VARCHAR2,
    vID number,
    curReturn    OUT       sys_refcursor
);
PROCEDURE  GETUTTP_DI
(   vDuongSu in varchar2,
    vSoThuLy in varchar2,
    vNgayThuLy in varchar2,
    vCapXetXu number,
    vLoaiAn   in varchar2,
    vThuKy    number,
    vThamPhan    number,
    vVanBanUT number,
    vDonViUT number,
    vQuocGiaUT number,
    vTuNgayNhanUTTP in varchar2,
    vDenNgayNhanUTTP in varchar2,
    vTuNgayThoiGianUT in varchar2,
    vDenNgayThoiGianUT in varchar2,
    vKetQuaUT in number,
    vTuNgayKetQuaUT varchar2,
    vDenNgayKetQuaUT varchar2,
    curReturn    OUT       sys_refcursor
);

PROCEDURE  GET_DUONGSU_NGUYENDON
(   
    vDONID in number,
    curReturn    OUT       sys_refcursor
);

PROCEDURE  GET_DUONGSU_KHANGCAO
(   
    vDONID in number,
    curReturn    OUT       sys_refcursor
);
END PKG_STPT_DS;