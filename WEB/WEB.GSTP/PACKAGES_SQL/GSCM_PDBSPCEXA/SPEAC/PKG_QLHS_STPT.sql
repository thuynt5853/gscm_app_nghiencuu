--------------------------------------------------------
--  DDL for Package PKG_QLHS_STPT
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_QLHS_STPT" AS 

 /* TODO enter package declarations (types, exceptions, methods etc) here */ 
PROCEDURE GETQUANLYHOSOAN_ADS
(
    vCapxx IN NUMBER,
    vLoaian IN NUMBER, 
    vNgayThuLy IN VARCHAR2,
    vSoBA IN VARCHAR2,
    vNgayBA IN VARCHAR2,
    vThamPhanChuToa IN VARCHAR2,
    vThuKy IN VARCHAR2,
    vNguyenDon IN VARCHAR2,
    vBiDon  IN VARCHAR2,
    vDonViID	IN NUMBER,
    vMaVuViec	IN VARCHAR2,
    vTenVuViec	IN VARCHAR2,
    vTuNgay	IN VARCHAR2,
    vDenNgay	IN VARCHAR2,
    vTrangThai	IN NUMBER,
    vPageIndex in	NUMBER,
    vPageSize	in	NUMBER, 
    curReturn OUT sys_refcursor
);

PROCEDURE GETQUANLYHOSOAN_AHN
(
    vCapxx IN NUMBER,
    vLoaian IN NUMBER, 
    vNgayThuLy IN VARCHAR2,
    vSoBA IN VARCHAR2,
    vNgayBA IN VARCHAR2,
    vThamPhanChuToa IN VARCHAR2,
    vThuKy IN VARCHAR2,
    vNguyenDon IN VARCHAR2,
    vBiDon  IN VARCHAR2,
    vDonViID	IN NUMBER,
    vMaVuViec	IN VARCHAR2,
    vTenVuViec	IN VARCHAR2,
    vTuNgay	IN VARCHAR2,
    vDenNgay	IN VARCHAR2,
    vTrangThai	IN NUMBER,
    vPageIndex in	NUMBER,
    vPageSize	in	NUMBER, 
    curReturn OUT sys_refcursor
);
PROCEDURE GETQUANLYHOSOAN_AKT
(
    vCapxx IN NUMBER,
    vLoaian IN NUMBER, 
    vNgayThuLy IN VARCHAR2,
    vSoBA IN VARCHAR2,
    vNgayBA IN VARCHAR2,
    vThamPhanChuToa IN VARCHAR2,
    vThuKy IN VARCHAR2,
    vNguyenDon IN VARCHAR2,
    vBiDon  IN VARCHAR2,
    vDonViID	IN NUMBER,
    vMaVuViec	IN VARCHAR2,
    vTenVuViec	IN VARCHAR2,
    vTuNgay	IN VARCHAR2,
    vDenNgay	IN VARCHAR2,
    vTrangThai	IN NUMBER,
    vPageIndex in	NUMBER,
    vPageSize	in	NUMBER, 
    curReturn OUT sys_refcursor
);

PROCEDURE GETQUANLYHOSOAN_ALD
(
    vCapxx IN NUMBER,
    vLoaian IN NUMBER, 
    vNgayThuLy IN VARCHAR2,
    vSoBA IN VARCHAR2,
    vNgayBA IN VARCHAR2,
    vThamPhanChuToa IN VARCHAR2,
    vThuKy IN VARCHAR2,
    vNguyenDon IN VARCHAR2,
    vBiDon  IN VARCHAR2,
    vDonViID	IN NUMBER,
    vMaVuViec	IN VARCHAR2,
    vTenVuViec	IN VARCHAR2,
    vTuNgay	IN VARCHAR2,
    vDenNgay	IN VARCHAR2,
    vTrangThai	IN NUMBER,
    vPageIndex in	NUMBER,
    vPageSize	in	NUMBER, 
    curReturn OUT sys_refcursor
);
PROCEDURE GETQUANLYHOSOAN_AHC
(
    vCapxx IN NUMBER,
    vLoaian IN NUMBER, 
    vNgayThuLy IN VARCHAR2,
    vSoBA IN VARCHAR2,
    vNgayBA IN VARCHAR2,
    vThamPhanChuToa IN VARCHAR2,
    vThuKy IN VARCHAR2,
    vNguyenDon IN VARCHAR2,
    vBiDon  IN VARCHAR2,
    vDonViID	IN NUMBER,
    vMaVuViec	IN VARCHAR2,
    vTenVuViec	IN VARCHAR2,
    vTuNgay	IN VARCHAR2,
    vDenNgay	IN VARCHAR2,
    vTrangThai	IN NUMBER,
    vPageIndex in	NUMBER,
    vPageSize	in	NUMBER, 
    curReturn OUT sys_refcursor
);
PROCEDURE GETQUANLYHOSOAN_APS
(
    vCapxx IN NUMBER,
    vLoaian IN NUMBER, 
    vNgayThuLy IN VARCHAR2,
    vSoBA IN VARCHAR2,
    vNgayBA IN VARCHAR2,
    vThamPhanChuToa IN VARCHAR2,
    vThuKy IN VARCHAR2,
    vNguyenDon IN VARCHAR2,
    vBiDon  IN VARCHAR2,
    vDonViID	IN NUMBER,
    vMaVuViec	IN VARCHAR2,
    vTenVuViec	IN VARCHAR2,
    vTuNgay	IN VARCHAR2,
    vDenNgay	IN VARCHAR2,
    vTrangThai	IN NUMBER,
    vPageIndex in	NUMBER,
    vPageSize	in	NUMBER, 
    curReturn OUT sys_refcursor
);
PROCEDURE GETQUANLYHOSOAN_AHS
(
    vCapxx IN NUMBER,
    vLoaian IN NUMBER, 
    vNgayThuLy IN VARCHAR2,
    vSoBA IN VARCHAR2,
    vNgayBA IN VARCHAR2,
    vThamPhanChuToa IN VARCHAR2,
    vThuKy IN VARCHAR2,
    vNguyenDon IN VARCHAR2,
    vBiDon  IN VARCHAR2,
    vDonViID	IN NUMBER,
    vMaVuViec	IN VARCHAR2,
    vTenVuViec	IN VARCHAR2,
    vTuNgay	IN VARCHAR2,
    vDenNgay	IN VARCHAR2,
    vTrangThai	IN NUMBER,
    vPageIndex in	NUMBER,
    vPageSize	in	NUMBER, 
    curReturn OUT sys_refcursor
);
PROCEDURE GETQUANLYCBBA_AHS
(   

    vMaVuViec	IN VARCHAR2,
    vTenVuViec	IN VARCHAR2,
    vLoaian IN NUMBER, 
    vSoBA IN VARCHAR2,
    vNgayBA IN VARCHAR2,
    vDonViID	IN NUMBER, 
    vTuNgay	IN VARCHAR2,
    vDenNgay	IN VARCHAR2,
    vTrangThai	IN NUMBER,
    vPageIndex in	NUMBER,
    vPageSize	in	NUMBER, 
    curReturn OUT sys_refcursor 
);

PROCEDURE GETQUANLYCBBA_ADS
(   

    vMaVuViec	IN VARCHAR2,
    vTenVuViec	IN VARCHAR2,
    vLoaian IN NUMBER, 
    vSoBA IN VARCHAR2,
    vNgayBA IN VARCHAR2,
    vDonViID	IN NUMBER, 
    vTuNgay	IN VARCHAR2,
    vDenNgay	IN VARCHAR2,
    vTrangThai	IN NUMBER,
    vPageIndex in	NUMBER,
    vPageSize	in	NUMBER, 
    curReturn OUT sys_refcursor 
);
PROCEDURE GETQUANLYCBBA_AHC
(   

    vMaVuViec	IN VARCHAR2,
    vTenVuViec	IN VARCHAR2,
    vLoaian IN NUMBER, 
    vSoBA IN VARCHAR2,
    vNgayBA IN VARCHAR2,
    vDonViID	IN NUMBER, 
    vTuNgay	IN VARCHAR2,
    vDenNgay	IN VARCHAR2,
    vTrangThai	IN NUMBER,
    vPageIndex in	NUMBER,
    vPageSize	in	NUMBER, 
    curReturn OUT sys_refcursor 
);
PROCEDURE GETQUANLYCBBA_AHN
(   

    vMaVuViec	IN VARCHAR2,
    vTenVuViec	IN VARCHAR2,
    vLoaian IN NUMBER, 
    vSoBA IN VARCHAR2,
    vNgayBA IN VARCHAR2,
    vDonViID	IN NUMBER, 
    vTuNgay	IN VARCHAR2,
    vDenNgay	IN VARCHAR2,
    vTrangThai	IN NUMBER,
    vPageIndex in	NUMBER,
    vPageSize	in	NUMBER, 
    curReturn OUT sys_refcursor 
);
PROCEDURE GETQUANLYCBBA_AKT
(   

    vMaVuViec	IN VARCHAR2,
    vTenVuViec	IN VARCHAR2,
    vLoaian IN NUMBER, 
    vSoBA IN VARCHAR2,
    vNgayBA IN VARCHAR2,
    vDonViID	IN NUMBER, 
    vTuNgay	IN VARCHAR2,
    vDenNgay	IN VARCHAR2,
    vTrangThai	IN NUMBER,
    vPageIndex in	NUMBER,
    vPageSize	in	NUMBER, 
    curReturn OUT sys_refcursor 
);
PROCEDURE GETQUANLYCBBA_ALD
(   

    vMaVuViec	IN VARCHAR2,
    vTenVuViec	IN VARCHAR2,
    vLoaian IN NUMBER, 
    vSoBA IN VARCHAR2,
    vNgayBA IN VARCHAR2,
    vDonViID	IN NUMBER, 
    vTuNgay	IN VARCHAR2,
    vDenNgay	IN VARCHAR2,
    vTrangThai	IN NUMBER,
    vPageIndex in	NUMBER,
    vPageSize	in	NUMBER, 
    curReturn OUT sys_refcursor 
);
PROCEDURE GETQUANLYCBBA_APS
(   

    vMaVuViec	IN VARCHAR2,
    vTenVuViec	IN VARCHAR2,
    vLoaian IN NUMBER, 
    vSoBA IN VARCHAR2,
    vNgayBA IN VARCHAR2,
    vDonViID	IN NUMBER, 
    vTuNgay	IN VARCHAR2,
    vDenNgay	IN VARCHAR2,
    vTrangThai	IN NUMBER,
    vPageIndex in	NUMBER,
    vPageSize	in	NUMBER, 
    curReturn OUT sys_refcursor 
);


END PKG_QLHS_STPT;
