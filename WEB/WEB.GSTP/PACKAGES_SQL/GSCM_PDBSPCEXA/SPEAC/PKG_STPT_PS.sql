--------------------------------------------------------
--  DDL for Package PKG_STPT_PS
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_STPT_PS" AS

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
  Page_Index in	int,
  Page_Size	in int,
  curReturn OUT sys_refcursor
);

PROCEDURE  APS_FILE_CHECKSTT
(   vdonviID in number,
    vMaGiaiDoan number,
    vNam number,
    vLoaiFile number,
    vSTT    number,
    vSTB_Phu IN VARCHAR2,
    vID number,
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
END PKG_STPT_PS;
