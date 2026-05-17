--------------------------------------------------------
--  DDL for Package PKG_GDTTT_VUAN_INBC
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_GDTTT_VUAN_INBC" AS 

FUNCTION GDTTTT_VUAN_GQD_SEARCH
( 
  vToaAnID in number,
  vPhongBanID  in number,
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in varchar2,
  vNguyendon in varchar2,
  vBidon in varchar2,
  vLoaiAn in number,
  vThamtravien in number,
  vLanhdao in number,
  vThamphan in number,

  vNgayThulyTu in date,
  vNgayThulyDen in date,
  vSoThuly in varchar2, 

  vLoaiNgay in number,
  vGQD_TuNgay in date,
  vGQD_DenNgay in date,

  vKetquathuly in number,
  vKetquaxetxu in number,  
  LoaiAnDB in number,
  vLoaiAnDB_TH in varchar2,
  vTypeTB in number,
  v_LoaiGDT in number,
  PageIndex	in	int,
  PageSize	in	int
)RETURN SYS_REFCURSOR;
FUNCTION  GDTTTT_QLTOTRINH_VUAN_SEARCH
( 
   vToaAnID in number,
  vPhongBanID  in number,
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in varchar2,
  vNguyendon in varchar2,
  vBidon in varchar2,
  vLoaiAn in number,

  vThamtravien in number,
  vLanhdao in number,
  vThamphan in number,

  tt_tungay in date,
  tt_denngay in date,
  vSoThuly in varchar2, 

  vTrangthai in number,
  vCapTrinhTiep in number,
  vIsDangKyBC in number,

  isTTMuonHS in number,
  isTTToTrinh in number,
  isTTYKienKLTotrinh in number,
  isBuocTT in number,

  vKetquathuly in number,
  LoaiAnDB in number,
  vLoaiAnDB_TH in varchar2,
  IsHoanTHA in number,

  PageIndex	in	int,
  PageSize	in	int
)
RETURN SYS_REFCURSOR;
FUNCTION  GDTTTT_VUAN_SEARCH
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

  v_SodonTLM        in number,
  v_LoaiGDT       in number,
  v_QHPL_TD      in varchar2,

  v_loaingaysearch in number,
  v_NgaySearch_Tu in date,
  v_NgaySearch_Den in date,

  PageIndex	in	int,
  PageSize	in	int  
) RETURN SYS_REFCURSOR;

FUNCTION  VUAN_TRACUU_SEARCH_PRINT
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

  v_SodonTLM        in number,
  v_LoaiGDT       in number,
  v_QHPL_TD      in varchar2,

  v_loaingaysearch in number,
  v_NgaySearch_Tu in date,
  v_NgaySearch_Den in date,

  PageIndex	in	int,
  PageSize	in	int  
) RETURN SYS_REFCURSOR;


FUNCTION  GDTTTT_DON_GIAONHAN_THS_PRINT
( 
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
  vSoCongVan in varchar2,
  vNgayCongVan in varchar2,
  vTraLoi in number,
  vNguoiNhap in varchar2,
  vNoiChuyen in number,
  vTrangthai in number,
  vCD_DONVIID in number,
  vNgaychuyenTu in date,
  vNgaychuyenDen in date,
  vArrSelectID in varchar2,
  vIsThuLy in number,
  vPhanloaixuly in number,
  vNgayThulyTu in date,
  vNgayThulyDen in date,
  vSoThuly in varchar2,
  vPhancongTTV in number,
  vloaian in number,-- them loai an
  IsGhepVuAn in number,
  v_ISXINANGIAM in number,
  v_GDT_ISXINANGIAM in number,
  PageIndex	in	int,
  PageSize	in	int
) RETURN SYS_REFCURSOR;

FUNCTION  GDTTTT_QLTOTRINH_BC_SEARCH
( 
   vToaAnID in number,
  vPhongBanID  in number,
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in varchar2,
  vNguyendon in varchar2,
  vBidon in varchar2,
  vLoaiAn in number,

  vThamtravien in number,
  vLanhdao in number,
  vThamphan in number,

  tt_tungay in date,
  tt_denngay in date,
  vSoThuly in varchar2, 

  vTrangthai in number,
  vCapTrinhTiep in number,
  vIsDangKyBC in number,

  isTTMuonHS in number,
  isTTToTrinh in number,
  isTTYKienKLTotrinh in number,
  isBuocTT in number,

  vKetquathuly in number,
  LoaiAnDB in number,
  vLoaiAnDB_TH in varchar2,
  IsHoanTHA in number,

  PageIndex	in	int,
  PageSize	in	int
)
RETURN SYS_REFCURSOR;

FUNCTION GDTTTT_VUAN_GQD_BC_SEARCH
( 
  vToaAnID in number,
  vPhongBanID  in number,
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in varchar2,
  vNguyendon in varchar2,
  vBidon in varchar2,
  vLoaiAn in number,
  vThamtravien in number,
  vLanhdao in number,
  vThamphan in number,

  vNgayThulyTu in date,
  vNgayThulyDen in date,
  vSoThuly in varchar2, 

  vLoaiNgay in number,
  vGQD_TuNgay in date,
  vGQD_DenNgay in date,

  vKetquathuly in number,
  vKetquaxetxu in number,  
  LoaiAnDB in number,
  vLoaiAnDB_TH in varchar2,
  vTypeTB in number,
  vThoihieu in number,
  PageIndex	in	int,
  PageSize	in	int
)RETURN SYS_REFCURSOR;


END PKG_GDTTT_VUAN_INBC;
