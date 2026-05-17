--------------------------------------------------------
--  DDL for Package PKG_VGDKT_BAOCAO
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_VGDKT_BAOCAO" AS 


PROCEDURE TONGHOPSOLIEU_8A_EXP
(  
    V_ToaAnID	in	VARCHAR2,
    vTuNgay	in VARCHAR2,
    vDenNgay	in VARCHAR2,
    curReturn OUT sys_refcursor 
);


PROCEDURE GDT13_Export
(    V_ToaAnID	in	VARCHAR2,
    V_PhongbanID	in	VARCHAR2,
    V_LOAIAN_ID in  VARCHAR2,
    vTuNgay	in VARCHAR2,
    vDenNgay	in VARCHAR2,
    curReturn OUT sys_refcursor
);

PROCEDURE GDT12_Export
(   V_ToaAnID	in	VARCHAR2,
    V_PhongbanID	in	VARCHAR2,
    V_LOAIAN_ID in  VARCHAR2,
    v_LOAIXULY in	VARCHAR2,
    vTuNgay	in VARCHAR2,
    vDenNgay	in VARCHAR2,
    curReturn OUT sys_refcursor
);
PROCEDURE GDT11_Export
(   V_ToaAnID	in	VARCHAR2,
    V_PHONGBANID	in	VARCHAR2,
    V_LOAIAN_ID in  VARCHAR2,
    v_THAMTRAVIEN_ID in	VARCHAR2,
    VTUNGAY in VARCHAR2,
    VDENNGAY in VARCHAR2,
    curReturn OUT sys_refcursor
);
PROCEDURE GDT11_Export_NEW
(   V_ToaAnID	in	VARCHAR2,
    V_PHONGBANID	in	VARCHAR2,
    V_LOAIAN_ID in  VARCHAR2,
    v_THAMTRAVIEN_ID in	VARCHAR2,
    VTUNGAY in VARCHAR2,
    VDENNGAY in VARCHAR2,
    curReturn OUT sys_refcursor
);
PROCEDURE GDT10_Export
(   V_ToaAnID	in	VARCHAR2,
    V_PHONGBANID	in	VARCHAR2,
    V_LOAIAN_ID in  VARCHAR2,
    v_THAMPHAN_ID in	VARCHAR2,
    VTUNGAY in VARCHAR2,
    VDENNGAY in VARCHAR2,
    curReturn OUT sys_refcursor
);

PROCEDURE GDT10_Export_NEW
(   V_ToaAnID	in	VARCHAR2,
    V_PHONGBANID	in	VARCHAR2,
    V_LOAIAN_ID in  VARCHAR2,
    v_THAMPHAN_ID in	VARCHAR2,
    VTUNGAY in VARCHAR2,
    VDENNGAY in VARCHAR2,
    curReturn OUT sys_refcursor
);

PROCEDURE GDT09_Export
(   V_ToaAnID	in	VARCHAR2,
    V_Donvi_KNID	in	VARCHAR2,
    V_LOAIAN_ID in  VARCHAR2,
    v_LOAIXULY in	VARCHAR2,
    VTUNGAY in VARCHAR2,
    VDENNGAY in VARCHAR2,
    curReturn OUT sys_refcursor
);
PROCEDURE GDT08_Export
(   V_ToaAnID	in	VARCHAR2,
    V_PhongbanID	in	VARCHAR2,
    V_LOAIAN_ID in  VARCHAR2,
    v_LOAIXULY in	VARCHAR2,
    V_NGAY_FROM	in date,
    V_NGAY_TO	in date,
    curReturn OUT sys_refcursor
);
PROCEDURE GDT07_Export
(   V_ToaAnID	in	VARCHAR2,
    V_PhongbanID	in	VARCHAR2,
    V_LOAIAN_ID in  VARCHAR2,
    v_LOAIXULY in	VARCHAR2,
    V_NGAY_FROM	in date,
    V_NGAY_TO	in date,
    curReturn OUT sys_refcursor
);
PROCEDURE GDT06_Export
(   V_ToaAnID	in	VARCHAR2,
    V_Donvi_KNID	in	VARCHAR2,
    V_LOAIAN_ID in  VARCHAR2,
    v_LOAIXULY in	VARCHAR2,
    V_NGAY_FROM	in date,
    V_NGAY_TO	in date,
    curReturn OUT sys_refcursor
);
PROCEDURE GDT05_Export
(   V_ToaAnID	in	VARCHAR2,
    V_PhongbanID	in	VARCHAR2,
    V_LOAIAN_ID in  VARCHAR2,
    v_LOAIXULY in	VARCHAR2,
    V_NGAY_FROM	in date,
    V_NGAY_TO	in date,
    curReturn OUT sys_refcursor
);
PROCEDURE GDT04_Export
(   V_ToaAnID	in	VARCHAR2,
    V_PhongbanID	in	VARCHAR2,
    V_LOAIAN_ID in  VARCHAR2,
    v_LOAIXULY in	VARCHAR2,
    V_NGAY_FROM	in date,
    V_NGAY_TO	in date,
    curReturn OUT sys_refcursor
);
PROCEDURE GDT03_Export
(   V_ToaAnID	in	VARCHAR2,
    V_PhongbanID	in	VARCHAR2,
    V_LOAIAN_ID in  VARCHAR2,
    v_LOAIXULY in	VARCHAR2,
    V_NGAY_FROM	in date,
    V_NGAY_TO	in date,
    curReturn OUT sys_refcursor
);
PROCEDURE GDT02_Export
(   V_ToaAnID	in	VARCHAR2,
    V_PhongbanID	in	VARCHAR2,
    V_LOAIGDT	in	VARCHAR2,
    V_LOAIAN_ID in  VARCHAR2,
    v_LOAIXULY in	VARCHAR2,
    V_NGAY_FROM	in date,
    V_NGAY_TO	in date,
    curReturn OUT sys_refcursor
);

PROCEDURE GDT01_Export
( 
    V_ToaAnID	in	VARCHAR2,
    V_LOAIAN_ID in  VARCHAR2,
    v_LOAIXULY in	VARCHAR2,
    V_NGAY_FROM	in date,
    V_NGAY_TO	in date,
    curReturn OUT sys_refcursor
);
FUNCTION  GDTTTT_VUAN_SEARCH_BC1
( 
  V_CONLAI_ in varchar2,
  v_colume  in varchar2,
  v_asc_desc in varchar2,
  vToaAnID in number,
  vPhongBanID  in number,
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in varchar2,
  vNguoiGui in varchar2,
  vCoquanchuyendon in varchar2,
  vNguyendon in varchar2,
  vBidon in varchar2,
  vLoaiAn in number,
  vThamtravien in number,
  vLanhdao in number,
  vThamphan in number,
  vQHPLID in number,
  vQHPLDNID in number,
  vTraloidon in varchar2,
  vLoaiCVID in number,
  vNgayThulyTu in date,
  vNgayThulyDen in date,
  vSoThuly in varchar2, 

  vTrangthai in number,
  vCapTrinhTiep in number,
  vIsDangKyBC in number,

  vKetquathuly in number,
  vKetquaxetxu in number,  

  isTTMuonHS in number,
  isTTToTrinh in number,
  isTTYKienKLTotrinh in number,
  isBuocTT in number,
  LoaiAnDB in number,
  vLoaiAnDB_TH in varchar2,
  IsHoanTHA in number,
  vTypeTB in number,
  vTypeHDTP in number,
  v_ISXINANGIAM in number,
  v_GDT_ISXINANGIAM in number,
  PageIndex	in	int,
  PageSize	in	int
)
RETURN SYS_REFCURSOR;
FUNCTION  GDTTTT_VUAN_SEARCH_BC2
( 
  V_CONLAI_ in varchar2,
  v_colume  in varchar2,
  v_asc_desc in varchar2,
  vToaAnID in number,
  vPhongBanID  in number,
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in varchar2,
  vNguoiGui in varchar2,
  vCoquanchuyendon in varchar2,
  vNguyendon in varchar2,
  vBidon in varchar2,
  vLoaiAn in number,
  vThamtravien in number,
  vLanhdao in number,
  vThamphan in number,
  vQHPLID in number,
  vQHPLDNID in number,
  vTraloidon in varchar2,
  vLoaiCVID in number,
  vNgayThulyTu in date,
  vNgayThulyDen in date,
  vSoThuly in varchar2, 

  vTrangthai in number,
  vCapTrinhTiep in number,
  vIsDangKyBC in number,

  vKetquathuly in number,
  vKetquaxetxu in number,  

  isTTMuonHS in number,
  isTTToTrinh in number,
  isTTYKienKLTotrinh in number,
  isBuocTT in number,
  LoaiAnDB in number,
  vLoaiAnDB_TH in varchar2,
  IsHoanTHA in number,
  vTypeTB in number,
  vTypeHDTP in number,
  v_ISXINANGIAM in number,
  v_GDT_ISXINANGIAM in number,
  PageIndex	in	int,
  PageSize	in	int
)
RETURN SYS_REFCURSOR;
FUNCTION  GDTTTT_VUAN_SEARCH_BC6
( 
  V_CONLAI_ in varchar2,
  v_colume  in varchar2,
  v_asc_desc in varchar2,
  vToaAnID in number,
  vPhongBanID  in number,
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in varchar2,
  vNguoiGui in varchar2,
  vCoquanchuyendon in varchar2,
  vNguyendon in varchar2,
  vBidon in varchar2,
  vLoaiAn in number,
  vThamtravien in number,
  vLanhdao in number,
  vThamphan in number,
  vQHPLID in number,
  vQHPLDNID in number,
  vTraloidon in varchar2,
  vLoaiCVID in number,
  vNgayThulyTu in date,
  vNgayThulyDen in date,
  vSoThuly in varchar2, 

  vTrangthai in number,
  vCapTrinhTiep in number,
  vIsDangKyBC in number,

  vKetquathuly in number,
  vKetquaxetxu in number,  

  isTTMuonHS in number,
  isTTToTrinh in number,
  isTTYKienKLTotrinh in number,
  isBuocTT in number,
  LoaiAnDB in number,
  vLoaiAnDB_TH in varchar2,
  IsHoanTHA in number,
  vTypeTB in number,
  vTypeHDTP in number,
  v_ISXINANGIAM in number,
  v_GDT_ISXINANGIAM in number,
  PageIndex	in	int,
  PageSize	in	int
)
RETURN SYS_REFCURSOR;
FUNCTION  GDTTTT_VUAN_SEARCH_BC8_GROUP
( 
  V_CONLAI_ in varchar2,
  v_colume  in varchar2,
  v_asc_desc in varchar2,
  vToaAnID in number,
  vPhongBanID  in number,
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in varchar2,
  vNguoiGui in varchar2,
  vCoquanchuyendon in varchar2,
  vNguyendon in varchar2,
  vBidon in varchar2,
  vLoaiAn in number,
  vThamtravien in number,
  vLanhdao in number,
  vThamphan in number,
  vQHPLID in number,
  vQHPLDNID in number,
  vTraloidon in varchar2,
  vLoaiCVID in number,
  vNgayThulyTu in date,
  vNgayThulyDen in date,
  vSoThuly in varchar2, 

  vTrangthai in number,
  vCapTrinhTiep in number,
  vIsDangKyBC in number,

  vKetquathuly in number,
  vKetquaxetxu in number,  

  isTTMuonHS in number,
  isTTToTrinh in number,
  isTTYKienKLTotrinh in number,
  isBuocTT in number,
  LoaiAnDB in number,
  vLoaiAnDB_TH in varchar2,
  IsHoanTHA in number,
  vTypeTB in number,
  vTypeHDTP in number,
  v_ISXINANGIAM in number,
  v_GDT_ISXINANGIAM in number,
  PageIndex	in	int,
  PageSize	in	int
)
RETURN SYS_REFCURSOR;
FUNCTION  GDTTTT_VUAN_SEARCH_BC8_ALL
( 
  V_CONLAI_ in varchar2,
  v_colume  in varchar2,
  v_asc_desc in varchar2,
  vToaAnID in number,
  vPhongBanID  in number,
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in varchar2,
  vNguoiGui in varchar2,
  vCoquanchuyendon in varchar2,
  vNguyendon in varchar2,
  vBidon in varchar2,
  vLoaiAn in number,
  vThamtravien in number,
  vLanhdao in number,
  vThamphan in number,
  vQHPLID in number,
  vQHPLDNID in number,
  vTraloidon in varchar2,
  vLoaiCVID in number,
  vNgayThulyTu in date,
  vNgayThulyDen in date,
  vSoThuly in varchar2, 

  vTrangthai in number,
  vCapTrinhTiep in number,
  vIsDangKyBC in number,

  vKetquathuly in number,
  vKetquaxetxu in number,  

  isTTMuonHS in number,
  isTTToTrinh in number,
  isTTYKienKLTotrinh in number,
  isBuocTT in number,
  LoaiAnDB in number,
  vLoaiAnDB_TH in varchar2,
  IsHoanTHA in number,
  vTypeTB in number,
  vTypeHDTP in number,
  v_ISXINANGIAM in number,
  v_GDT_ISXINANGIAM in number,
  PageIndex	in	int,
  PageSize	in	int
)
RETURN SYS_REFCURSOR;
END PKG_VGDKT_BAOCAO;

/
