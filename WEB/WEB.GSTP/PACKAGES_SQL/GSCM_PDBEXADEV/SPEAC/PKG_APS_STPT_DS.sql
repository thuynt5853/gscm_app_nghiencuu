--------------------------------------------------------
--  DDL for Package PKG_APS_STPT_DS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "GSCM"."PKG_APS_STPT_DS" AS 

PROCEDURE APS_DON_SEARCH 
( v_CapXetXuLogin in varchar2,
  vdonviID in varchar2,
  vTenViec in varchar2,
  vLoaiHinhDoanhNghiep in varchar2,
  vMaViec in varchar2,
  vDuongSu_NguoiThamGiaToTung in varchar2,
  vCapXetXu in varchar2,
  vToaXetXu in varchar2,
  vTinhTrangThuLy in varchar2,
  vTuNgayThuLy in varchar2,
  vDenNgayThuLy in varchar2,
  vSoThuLy in varchar2,
  vTinhTrangGQ in varchar2,
  vTuNgayTinhTrangGQ in varchar2,
  vDenNgayTinhTrangGQ in varchar2,
  vThamPhan IN varchar2,
  vThoiHanGQ in varchar2,
  vSoQD in varchar2,
  vNgayQD in varchar2,
  vThuKy in varchar2,
  vGQDon in varchar2,
  vUyThacTuPhap in varchar2,
  vPTRutKinhNghiem in varchar2,
  vchecktk in number,
	V_VAITRO_THAMPHAN IN VARCHAR2,
    V_CHECK_HOAGIAI          IN NUMBER, 
    V_MA_THONG_BAO          IN NUMBER,
  Page_Index in	int,
  Page_Size	in int,
  curReturn OUT sys_refcursor
);

PROCEDURE APS_DON_CON_SEARCH
(
    V_DONID_GOC NUMBER,
    v_CapXetXuLogin in varchar2,
  vdonviID in varchar2,
  vTenViec in varchar2,
  vLoaiHinhDoanhNghiep in varchar2,
  vMaViec in varchar2,
  vDuongSu_NguoiThamGiaToTung in varchar2,
  vCapXetXu in varchar2,
  vToaXetXu in varchar2,
  vTinhTrangThuLy in varchar2,
  vTuNgayThuLy in varchar2,
  vDenNgayThuLy in varchar2,
  vSoThuLy in varchar2,
  vTinhTrangGQ in varchar2,
  vTuNgayTinhTrangGQ in varchar2,
  vDenNgayTinhTrangGQ in varchar2,
  vThamPhan IN varchar2,
  vThoiHanGQ in varchar2,
  vSoQD in varchar2,
  vNgayQD in varchar2,
  vThuKy in varchar2,
  vGQDon in varchar2,
  vUyThacTuPhap in varchar2,
  vPTRutKinhNghiem in varchar2,
  vchecktk in number,
  Page_Index in	int,
  Page_Size	in int,
  curReturn OUT sys_refcursor
);

PROCEDURE APS_DON_SEARCH_V2 
( v_CapXetXuLogin in varchar2, 
  vdonviID in varchar2, 
  vTenViec in varchar2, 
  vLoaiHinhDoanhNghiep in varchar2, 
  vMaViec in varchar2, 
  vDuongSu_NguoiThamGiaToTung in varchar2, 
  vCapXetXu in varchar2, 
  vToaXetXu in varchar2, 
  vTinhTrangThuLy in varchar2, 
  vTuNgayThuLy in varchar2, 
  vDenNgayThuLy in varchar2, 
  vSoThuLy in varchar2, 
  vTinhTrangGQ in varchar2, 
  vTuNgayTinhTrangGQ in varchar2, 
  vDenNgayTinhTrangGQ in varchar2, 
  vThamPhan IN varchar2, 
  vThoiHanGQ in varchar2, 
  vSoQD in varchar2, 
  vNgayQD in varchar2, 
  vThuKy in varchar2,
  vGQDon in varchar2, 
  vUyThacTuPhap in varchar2, 
  vPTRutKinhNghiem in varchar2,
  vchecktk in number,
	V_VAITRO_THAMPHAN IN VARCHAR2,
    V_CHECK_HOAGIAI          IN NUMBER, 
    V_MA_THONG_BAO          IN NUMBER,
  Page_Index in int,
  Page_Size in int,
  curReturn OUT sys_refcursor
);


END PKG_APS_STPT_DS;

/
