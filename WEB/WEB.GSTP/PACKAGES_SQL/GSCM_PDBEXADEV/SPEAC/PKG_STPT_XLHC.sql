CREATE OR REPLACE PACKAGE GSCM.PKG_STPT_XLHC AS

--PROCEDURE XLHC_DON_SEARCH
--(
--  vDonViID in varchar2,
--  vTenViec in varchar2,
--  vQuanHePhapLuat in varchar2,
--  vMaViec in varchar2,
--  vDoiTuongApDungBPXLHC in varchar2,
--  vCapXetXu in varchar2,
--  vToaXetXu in varchar2,
--  vTinhTrangThuLy in varchar2,
--  vTuNgayThuLy in varchar2,
--  vDenNgayThuLy in varchar2,
--  vSoThuLy in varchar2,
--  vTinhTrangGQ in varchar2,
--  vTuNgayGQ in varchar2,
--  vDenNgayGQ in varchar2, 
--  vThamPhan in varchar2,
--  vThoiHanGQ in varchar2,
--  vSoQD in varchar2,
--  vNgayQD in varchar2,
--  vThuKy in varchar2,
--  vPTRutKinhNghiem in varchar2,
--  Page_Index in	int,
--  Page_Size	in	int,
--  curReturn OUT sys_refcursor
--);

FUNCTION DON_SEARCH_ITEM
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
  Page_Size	in	int
)RETURN T_STPT_6LOAIAN;

--PROCEDURE XLHC_DON_SEARCH_V2
--(
--  vDonViID in varchar2,
--  vTenViec in varchar2,
--  vQuanHePhapLuat in varchar2,
--  vMaViec in varchar2,
--  vDoiTuongApDungBPXLHC in varchar2,
--  vCapXetXu in varchar2,
--  vToaXetXu in varchar2,
--  vTinhTrangThuLy in varchar2,
--  vTuNgayThuLy in varchar2,
--  vDenNgayThuLy in varchar2,
--  vSoThuLy in varchar2,
--  vTinhTrangGQ in varchar2,
--  vTuNgayGQ in varchar2,
--  vDenNgayGQ in varchar2,
--  vThamPhan in varchar2,
--  vThoiHanGQ in varchar2,
--  vSoQD in varchar2,
--  vNgayQD in varchar2,
--  vThuKy in varchar2,
--  vPTRutKinhNghiem in varchar2,
--  Page_Index in	int,
--  Page_Size	in	int,
--  curReturn OUT sys_refcursor
--);

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
  vVaiTroThamPhan in varchar2,
  vThoiHanGQ in varchar2,
  vSoQD in varchar2,
  vNgayQD in varchar2,
  vThuKy in varchar2,
  vPTRutKinhNghiem in varchar2,
  V_AN_KET_THUC IN NUMBER,
  Page_Index in	int,
  Page_Size	in	int,
  curReturn OUT sys_refcursor
);

PROCEDURE XLHC_DON_SEARCH_PTQDK
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
  vVaiTroThamPhan in varchar2,
  vThoiHanGQ in varchar2,
  vSoQD in varchar2,
  vNgayQD in varchar2,
  vThuKy in varchar2,
  vPTRutKinhNghiem in varchar2,
  V_AN_KET_THUC IN NUMBER,
  Page_Index in	int,
  Page_Size	in	int,
  curReturn OUT sys_refcursor
);


PROCEDURE XLHC_PHUCTHAM_KCKN_TGTT_GETLIST (
       VDONID      IN    NUMBER,
       CURRETURN   OUT   SYS_REFCURSOR
);

PROCEDURE XLHC_KCKNQDK_PHUCTHAM_HDXX_GETLIST (
        VDONID      IN    NUMBER,
        CURRETURN   OUT   SYS_REFCURSOR
);

PROCEDURE XLHC_KCKNQDK_PHUCTHAM_QUYETDINH_GETLIST (
        VDONID      IN    NUMBER,
        CURRETURN   OUT   SYS_REFCURSOR
    );

PROCEDURE XLHC_KCKN_PHUCTHAM_THULY_GETLIST (
       VDONID      IN    NUMBER,
       CURRETURN   OUT   SYS_REFCURSOR
);  
PROCEDURE XLHC_KCKN_DON_THAMPHAN_GETBY (
        VDONID      IN    NUMBER,
        VMAVAITRO   IN    NVARCHAR2,
        CURRETURN   OUT   SYS_REFCURSOR
);
PROCEDURE XLHC_PHUCTHAMQDK_BANANQUYETDINH_GETLIST (
        VDONID      IN    NUMBER,
        CURRETURN   OUT   SYS_REFCURSOR
);

END PKG_STPT_XLHC;