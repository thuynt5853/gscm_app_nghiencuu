--------------------------------------------------------
--  DDL for Package PKG_GDTTT_BAOCAO_APP
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_GDTTT_BAOCAO_APP" AS 
FUNCTION GDTTT_QLTOTRINH_CHECKFIRSTTT
( 
  vVuAnID in number, 
  vTuNgay in date,
  vDenNgay in date
)RETURN number;
FUNCTION GDTTT_QLTOTRINH_CHECKTT
( 
  vVuAnID in number,
  vDenNgay in date
)RETURN number;

FUNCTION GDTTT_QLTOTRINH_SEAR_CHUATRINH
( 
  VVUANID IN NUMBER,
  VTUNGAY IN DATE,
  VDENNGAY IN DATE,
  VKETQUAYN IN NUMBER
)
RETURN NUMBER;
FUNCTION GDTTT_DON_GETTHULYBYVUAN
( 
VVUANID IN NUMBER
)
RETURN VARCHAR2;

FUNCTION GDTTT_SODEN_DON_GETTHULYBYVUAN
( 
VVUANID IN NUMBER
)
RETURN VARCHAR2;

FUNCTION  GDTTT_TOTRINH_GETLASTBYDK
(  VVUANID IN NUMBER
  , VTRANGTHAI IN NUMBER
  , TYPE_NGAY VARCHAR2
)
RETURN VARCHAR2;
FUNCTION  GDTTT_XXGDTTT_GETLASTXX
(  VVUANID IN NUMBER, VISHOAN IN NUMBER
)
RETURN NUMBER;
FUNCTION CHECK_TLM_TRUNG
( 
    vDonID in number
)
RETURN NUMBER;
FUNCTION CHECK_ANTHOIHIEU
(
    vLoaiAn in number,
    vNgayXuPT in date,
    vNgayXuST in date,
    vIsThuLyLai in number,
    vNgaythuly in date
)
RETURN NUMBER;

FUNCTION CHECK_ANTHOIHIEU_BY_YEAR
( 
  vLoaiAn in number,
  vNgayXu in date,
  vNgaythuly in date,
  vIsThuLyLai in number,
  vLoaithoihieu in number,
  vKeoOan in number
)
RETURN NUMBER;

PROCEDURE GDTTTT_QLTOTRINH_ALL
( 
  vToaAnID in number,
  vPhongBanID  in number,
  vLoaiAn in number,
  tt_tungay in date,
  tt_denngay in date,
  curReturn OUT sys_refcursor
);
PROCEDURE GDTTTT_QLTOTRINH
( 
  vToaAnID in number,
  vPhongBanID  in number,
  vLoaiAn in number,
  tt_tungay in date,
  tt_denngay in date,
  curReturn OUT sys_refcursor
);
PROCEDURE GDTTTT_QLTOTRINH_TP
( 
  vThamphanID in number,
  vToaAnID in number,
  vPhongBanID  in number,
  vLoaiAn in number,
  tt_tungay in date,
  tt_denngay in date,
  curReturn OUT sys_refcursor
);
END PKG_GDTTT_BAOCAO_APP;
