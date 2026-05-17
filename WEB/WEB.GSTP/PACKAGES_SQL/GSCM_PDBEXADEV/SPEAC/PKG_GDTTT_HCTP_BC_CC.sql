--------------------------------------------------------
--  DDL for Package PKG_GDTTT_HCTP_BC_CC
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_GDTTT_HCTP_BC_CC" AS
PROCEDURE DON_GETTHEOKETQUAID
( 
    vToaAnID in number,  
    vKetQuaID in number,
    vToaRaBAQD in number,
    vSoBAQD in varchar2,
    vNgayBAQD in varchar2,
    vNguoiGui in varchar2,
    vNgayThuly in varchar2,
    vSoThuly in varchar2,
    vThamphanID in number,
    curReturn OUT sys_refcursor
);
PROCEDURE DON_SEARCH_DS_VB_CC
( 
  vArrSelectID in varchar2,
  v_ID_USER in NUMBER,
  curReturn OUT sys_refcursor
);
PROCEDURE DON_SEARCH_DS_TL_MOI_CC
( 
  V_BC_NGAYDK VARCHAR2,
  V_BC_Nguoiky VARCHAR2,
  V_BC_SoCV VARCHAR2,
  v_ID_USER VARCHAR2,
  ----------------
  vToaAnID in number,
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in varchar2,
  vNguoiGui in varchar2,
  vSoCMND in varchar2,
  vTuNgay in date,
  vDenNgay in date,
  vHinhThucDon in number,
  vSoHieuDon in varchar2,
  vDiaChiTinh in number,
  vDiaChiHuyen in number,
  vDiaChiCT in varchar2,
  VLOAISOVB in varchar2,
  vSoCongVan in varchar2,
  vNgayCongVan in varchar2,
  vTraLoi in number,
  vNguoiNhap in varchar2,
  vNoiChuyen in number,
  vTrangthai in number,
  vCD_DONVIID in number,
  vCD_TA_TRANGTHAI in number,
  vCD_TENDONVI in varchar2,
  vNgaychuyenTu in date,
  vNgaychuyenDen in date,
  vArrSelectID in varchar2,
  vIsThuLy in number,
  vPhanloaixuly in number,
  vNgayThulyTu in date,
  vNgayThulyDen in date,
  vSoThuly in varchar2,
  vChidao in number,
  vTraigiam in number,
  vTBQuahan in number,
  vNgayQuahan in date,
  vThamphanID in number,
  vThamtravienID in number,
  vLoaiCVID in number,
  vNgayNhapTu in date,
  vNgayNhapDen in date,
  vIsDonGoc in number,
  vIsTuHinh in number,
  vLoaiAn in number,
  vCVPC_So in varchar2,
  vCVPC_Ngay in varchar2,
  vCVPC_TenCQ in varchar2,
  vGuitoiCA_TA in number,
  PageIndex	in	int,
  PageSize	in	int,
  curReturn OUT sys_refcursor
);
PROCEDURE REPORT_TIEUHOSO_CC
(
  vArrSelectID in varchar2,
  v_ID_USER in NUMBER,
  curReturn OUT sys_refcursor
);
--PROCEDURE DON_SEARCH_DS_
--(
--  vArrSelectID in varchar2,
--  curReturn OUT sys_refcursor
--);
PROCEDURE REPORT_QDRUT_HOSO_CC
( 
    vArrSelectID in varchar2,
    v_ID_USER in NUMBER,
    V_BC_SoCV in varchar2,
    V_BC_NGAYDK in varchar2,
    V_BC_Nguoiky  in varchar2,
    curReturn OUT sys_refcursor
);

END PKG_GDTTT_HCTP_BC_CC;

/
