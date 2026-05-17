--------------------------------------------------------
--  DDL for Package UYTHACTUPHAP
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."UYTHACTUPHAP" AS 

  /* TODO enter package declarations (types, exceptions, methods etc) here */ 
  FUNCTION UYTHACTUPHAP_DEN_INDANHSACH
(
   vQuocGia NUMBER,
  vLoaiTimKiem number,
  vKetQuaUT number,
  vTuNgay varchar2,
  vDenNgay varchar2,
  vNguoiThucHienUT number
)RETURN SYS_REFCURSOR;

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
    vloaiTimKiem in number,
    vTuNgay in varchar2,
    vDenNgay in varchar2,
    vKetQuaUT in number,
    vDonVi in number,
    curReturn    OUT       sys_refcursor
);
  FUNCTION GETUTTP_DI_INDANHSACH
(
   vDuongSu in varchar2,
    vSoThuLy in varchar2,
    vNgayThuLy in varchar2,
    vCapXetXu number,
    vLoaiAn   in varchar2,
    vThuKy    number,
    vThamPhan    number,
    vVanBanUT number,
    vDonViUT number,
    vQuocGiaUT number,
    vloaiTimKiem in number,
    vTuNgay in varchar2,
    vDenNgay in varchar2,
    vKetQuaUT in number,
    vDonVi in number
)RETURN SYS_REFCURSOR;
PROCEDURE  GETTHAMPHANTONGDAT
(   
    vDonVi in number,
    curReturn    OUT       sys_refcursor
);
PROCEDURE  GETTHUKYTONGDAT
(   
    vDonVi in number,
    curReturn    OUT       sys_refcursor
);
END UYTHACTUPHAP;
