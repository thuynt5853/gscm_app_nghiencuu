--------------------------------------------------------
--  DDL for Package PKG_VGDKT_BAOCAO_TT
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_VGDKT_BAOCAO_TT" AS 
FUNCTION BAOCAO_TH_THULY_GDKT_13
(
  vToaAnID in VARCHAR2,
  vPhongBanID  in  VARCHAR2,
  vThamphanID  in  VARCHAR2,
  vTuNgay in date,
  vDenNgay in date
) RETURN SYS_REFCURSOR;
FUNCTION  GDTTTT_QLTOTRINH_BC4
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
FUNCTION  GDTTTT_QLTOTRINH_BC10
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
FUNCTION  GDTTTT_QLTOTRINH_BC11
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
END PKG_VGDKT_BAOCAO_TT;
