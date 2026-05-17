--------------------------------------------------------
--  DDL for Package PKG_STPT_XLHC
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_STPT_XLHC" AS

PROCEDURE XLHC_DON_SEARCH
( 
  vDonViID in varchar2,
  vTenViec in varchar2,
  vQuanHePhapLuat in varchar2,
  vMaViec in varchar2,
  vDoiTuongApDungBPXLHC in varchar2,
  vCapXetXu in varchar2,
  vToaXetXu in varchar2,
  vTinhTrangThuLy in varchar2,
  vTuNgayThuLy in varchar2,
  vDenNgayThuLy in varchar2,
  vSoThuLy in varchar2,
  vTinhTrangGQ in varchar2,
  vTuNgayGQ in varchar2,
  vDenNgayGQ in varchar2,
  vThamPhan in varchar2,
  vThoiHanGQ in varchar2,
  vSoQD in varchar2,
  vNgayQD in varchar2,
  vThuKy in varchar2,
  vPTRutKinhNghiem in varchar2,
  Page_Index in	int,
  Page_Size	in	int,
  curReturn OUT sys_refcursor
);
END PKG_STPT_XLHC;
