--------------------------------------------------------
--  DDL for Package PKG_GDTTT_VUAN_KHANGNGHI
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_GDTTT_VUAN_KHANGNGHI" AS

FUNCTION CHECK_VUAN_LUUSO
(
    vToaAnID in number,
    vPhongbanID in number,
    vLoaiSO  in varchar2,
    vVUANID in number,
    vDonVi in number
)RETURN NUMBER;

FUNCTION CHECK_VUAN_SOVANBAN
(  
    vToaAnID in number,
    vPhongbanID in number,
    vLoaiSO  in varchar2,
    vSoVB in varchar2,
    vNgayVB in varchar2
)RETURN NUMBER;

FUNCTION SOVANBAN_VUAN_INSERT
(  
    v_ToaAnID in number,
    v_PhongbanID in number,
    v_ISDONVI in number,
    v_ThamphanID IN VARCHAR2,
    v_MASO   IN VARCHAR2,
    v_SOVB     IN VARCHAR2,
    v_NGAYVB    IN VARCHAR2,
    v_NGUOIKY  IN VARCHAR2,
    v_CHUCVU  IN VARCHAR2,
    V_NGUOITAO IN VARCHAR2
)RETURN NUMBER;

FUNCTION SOPHATHANH_VUAN_INSERT
(  
    v_PHATHANHID IN NUMBER,
    v_VUANID     IN NUMBER,
    V_NGUOITAO IN VARCHAR2
)RETURN NUMBER;

FUNCTION CHECK_SOTOTRINH_VUAN
( 
    vToaAnID in number,
    vPhongbanID in number,
    vVuanID in varchar2,
    vMASO in varchar2
)RETURN NUMBER;

PROCEDURE GET_SOTOTRINH_SOVB_VUAN
(  
   vToaAnID in number,
    vPhongbanID in number,
    vLoaiso   in varchar2,
    vSOVB in varchar2,
    vYear in number,
    curReturn OUT sys_refcursor
);

FUNCTION CHECK_SOTOTRINH_VUAN_TLL
( 
    vToaAnID in number,
    vPhongbanID in number,
    vVuanid in varchar2
)RETURN NUMBER;

PROCEDURE GET_SOVB_VUAN
(   vMASO in varchar2,
    vToaAnID in number,
    vPhongbanID in number,
    vVuanID in number,
    curReturn OUT sys_refcursor
);

PROCEDURE GET_THAMPHAN_VUAN
( 
    vToaAnID in number,
    vPhongbanID in number,
    vLoaiSO  in varchar2,
    arrVuanID  in varchar2,
    v_SOTOTRINH in varchar2,
    v_NGAYTOTRINH in varchar2,
	curReturn OUT sys_refcursor
);

PROCEDURE QLSOVB_GETMAXTT_VUAN
(   vdonviID in number,    
    vPhongbanid in number,
    vYear in number,
    vLoaiso in varchar2,
	curReturn OUT sys_refcursor
);

FUNCTION CHECK_SOVB_VUAN
(  
    V_MASO in varchar2,
    vToaAnID in number,
    vPhongbanID in number,
    vVuanid in varchar2
)RETURN NUMBER;

FUNCTION GET_GDTTT_VUAN_THONGTIN_CHUYEN_NEXTVAL RETURN NUMBER;

FUNCTION GET_GDTTT_VUAN_CHITIET_CHUYEN_NEXTVAL RETURN NUMBER;

PROCEDURE GDTTTT_QLTOTRINH_VUAN_KHANG_NGHI_SEARCH
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
  
  vLoaiSoVB in varchar2,
  vSoVB in varchar2,
  vNgayVB in date,
  vTrangThaiChuyen in varchar2,

  PageIndex	in	int,
  PageSize	in	int,  
	curReturn OUT sys_refcursor
);

FUNCTION GDTTTT_QLTOTRINH_VUAN_KHANGNGHI_PRINT
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

  vLoaiSoVB in varchar2,
  vSoVB in varchar2,
  vNgayVB in date,
  vTrangThaiChuyen in varchar2,

  PageIndex	in	int,
  PageSize	in	int
)
RETURN SYS_REFCURSOR;

FUNCTION  GDTTTT_QLTOTRINH_VUAN_KHANGNGHI_BC_SEARCH
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

PROCEDURE QUANLYSOVB_VUANKN
( 
    vToaAnID in number,
    vPhongbanID in number,
    vISDONVI in number,
    vUSERID in varchar2,
    vLoaiSO  in varchar2,
    vSoVB in varchar2,
    vNgayVB in varchar2,
    vNgayVB_den in varchar2,
    vLoaiAn in number,
    PageIndex	in	int,
    PageSize	in	int,
	curReturn OUT sys_refcursor
);

PROCEDURE VAKN_CVCHUYEN_CHECK
(   vSOPHATHANH_ID in number,   
	curReturn OUT sys_refcursor
);

PROCEDURE SUAVANBANVAKN_SEARCH
( 
    vSOPHATHANH_ID in number,   
	curReturn OUT sys_refcursor 
);

FUNCTION SOVANBANVAKN_UPDATE
(   
    v_SOPHATHANH_ID in number,
    v_NGAYVB    IN VARCHAR2,
    v_NGUOIKY  IN VARCHAR2,
    v_CHUCVU  IN VARCHAR2,
    V_NGUOISUA IN VARCHAR2
)RETURN NUMBER;

FUNCTION SOVANBANVAKN_DEL_ONE
(   v_ID  in number,
    v_SOPHATHANH_VUGIAMDOC_ID in number
)RETURN NUMBER;

FUNCTION SOVANBANVAKN_DEL_ALL
(  
    v_SOPHATHANH_ID in number
)RETURN NUMBER;

PROCEDURE GDTTTT_QLTOTRINH_VAKN_INPHIEU_CHUYEN
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

  vLoaiSoVB in varchar2,
  vSoVB in varchar2,
  vNgayVB in date,
  vTrangThaiChuyen in varchar2,

  PageIndex	in	int,
  PageSize	in	int,  
	curReturn OUT sys_refcursor
);

PROCEDURE GDTTTT_QLTOTRINH_VUAN_KHANG_NGHI_BTP_SEARCH
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

  --huynt
  vLoaiSoVB in varchar2,
  vSoVB in varchar2,
  vNgayVB in date,
  vTrangThaiChuyen in number,
  vTrangThaiPC in number,
  
  PageIndex	in	int,
  PageSize	in	int,  
	curReturn OUT sys_refcursor
);

FUNCTION GDTTTT_QLTOTRINH_VUAN_KHANGNGHI_BTP_PRINT
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

  vLoaiSoVB in varchar2,
  vSoVB in varchar2,
  vNgayVB in date,
  vTrangThaiChuyen in varchar2,

  PageIndex	in	int,
  PageSize	in	int
)
RETURN SYS_REFCURSOR;

PROCEDURE GDTTTT_QLTOTRINH_VAKN_BTP_TTRINH_PHANCONG
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
  vPhongBanID in number,
  PageIndex	in	int,
  PageSize	in	int,
  curReturn OUT sys_refcursor
);

PROCEDURE VAKN_CHECK_CHUYEN_TPTC
(   vSOPHATHANH_ID in number,   
	curReturn OUT sys_refcursor
);

PROCEDURE SUAVANBANVAKN_HCTP_SEARCH
( 
    vSOPHATHANH_ID in number,   
	curReturn OUT sys_refcursor 
);

PROCEDURE VAKN_GETCHUAPCTP 
(
    vToaAnID in number,
    vTuNgay in date,
    vDenNgay in date,
    vNoiChuyen in number,
    vTrangthai in number,  
    vIsThuLy in number,
    vNguoiNhap in varchar2,
    varrLoaiAn in varchar2,
    vHinhThuc in number,
    curReturn OUT sys_refcursor
);

PROCEDURE VAKN_GET_THEO_KETQUA_CHIDINHID 
(
    vToaAnID in number,
    vTuNgay in date,
    vDenNgay in date,
    vNoiChuyen in number,
    vTrangthai in number,  
    vIsThuLy in number,
    vNguoiNhap in varchar2,
    varrLoaiAn in varchar2,
    vHinhThuc in number,
    vKetQuaID in number,
    curReturn OUT sys_refcursor
);

FUNCTION INSERT_GDTTT_PCTP_VAKN_CHIDINH
( vToaAnID in number,
    vTuNgay in date,
    vDenNgay in date,
    varrLoaiAn in varchar2,
    vNguoithuchien in varchar2,
    vNguoithuchienID in number,
    vLoaithamphan varchar2
)RETURN number;

FUNCTION INSERT_GDTTT_PCTP_VAKN_CHIDINH_CHITIET
( vToaAnID in number,
    vChiDinhID in number,
    vVuAnID in number,
    vCanBoID in number
)RETURN number;

FUNCTION PHANCONGNGAUNHIEN_VAKN
( vToaAnID in number,
  vTuNgay in date,
  vDenNgay in date,
  vNguoiNhap in varchar2,
  varrLoaiAn in varchar2,  
  vNguoithuchien number
)RETURN number;

 PROCEDURE GET_THEOKETQUAID_PHANCONGNGAUNHIEN_VAKN
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

FUNCTION CHECK_VAKN_XOA_PHANCONG_CHIDINH
(
    vKetQuaId in number
) RETURN NUMBER;

FUNCTION CHECK_VAKN_CHUYENTP_XOA_PHANCONG_CHIDINH
(
    vKetQuaId in number
) RETURN NUMBER;

FUNCTION CHECK_VAKN_XOA_PHANCONG_NGAUNHIEN
(
    vKetQuaId in number
) RETURN NUMBER;

FUNCTION CHECK_VAKN_CHUYENTP_XOA_PHANCONG_NGAUNHIEN
(
    vKetQuaId in number
) RETURN NUMBER;

END PKG_GDTTT_VUAN_KHANGNGHI;

/
