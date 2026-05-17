CREATE OR REPLACE PACKAGE GSCM.PKG_STPT_TONGDAT AS 
PROCEDURE TONGDAT_DELETE_ERROR
(
    V_DONID in VARCHAR2,
    V_LOAIAN in VARCHAR2
);

PROCEDURE ADS_TONGDAT_DEL(
        vID in number
    );

PROCEDURE  ADS_TONGDAT_UP_IN
( 
    v_id  in number DEFAULT 0,
    v_DONID in NUMBER, 
    v_BIEUMAUID in NUMBER,
    v_TOAANID in NUMBER, 
    v_IS_TD_VKS in NUMBER, 
    v_IS_TD_VKS_NGAY in date,
    v_NGAYTAO in date, 
    v_NGUOITAO in VARCHAR2,
    v_NGAYSUA in DATE,
    v_NGUOISUA in VARCHAR2,
    v_TENFILE in VARCHAR2 ,
    v_KIEUFILE in VARCHAR2 ,
    v_NOIDUNGFILE in BLOB, 
    v_FILEID in number, 
    v_NGAYDANG_CTTDT in date,
    v_NGAYNHANTONGDAT in DATE,    
    v_TRANGTHAI in NUMBER, 
    v_NGAYTHUHOI in date,
    v_LYDOTHUHOI in varchar2,
    v_URL_FILE in varchar2,
    v_MAPID IN NUMBER,
    v_MAP_TABLE IN varchar2,
    v_TOA_GIAIQUYET_ID in NUMBER,
    vID out number
);

PROCEDURE  ADS_TONGDATNOINHAN_UP_IN
( 
    v_id  in number DEFAULT 0,
    v_TONGDATID in NUMBER , 
    v_MATUCACH in VARCHAR2 , 
    v_NGAYGUI in DATE,
    v_TRANGTHAI in NUMBER ,
    v_HINHTHUCGUI in NUMBER , 
    V_DUONGSUID in NUMBER,
    v_NGAYNHANTONGDAT in DATE,
    v_QUOCGIA in NUMBER,
    v_COQUAN in VARCHAR2,
    v_NOIDUNG in CLOB ,
    v_KETQUAUTTP in NUMBER ,
    v_NGAYPHATHANH in DATE ,
    v_NGAYTAO in DATE,
    v_NGUOITAO in VARCHAR2 ,
    v_IS_UTTP in NUMBER,
    v_UTTP in NUMBER ,
    v_NOINHAN in VARCHAR2 , 
    v_DIACHI in VARCHAR2,
    v_TOA_GIAIQUYET_ID in NUMBER,
    vID out NUMBER 
);

 PROCEDURE ADS_GETTENBM_BYTONGDATID(
    vTONGDATID in NUMBER , 
    curReturn out SYS_REFCURSOR 
);

 PROCEDURE ADS_TONGDATDOITUONG_GETBYID(
    vID in NUMBER , 
    curReturn out SYS_REFCURSOR 
);

PROCEDURE ADS_TONGDATDOITUONG_GETBY(
    vDonID in Decimal,
    vToaAnID in Decimal, 
    vBieuMauID in Decimal,
    vIsOnLyNKK in Decimal,
    vFileID in Decimal,
    curReturn out SYS_REFCURSOR);

PROCEDURE ADS_TONGDAT_THUHOI(
       v_id  in number,
    vNgayThuHoi  in date,
    vLyDo  in varchar2,
    vNguoiSua in varchar2 
);

PROCEDURE ADS_TONGDAT_THUHOI_DOITUONG(
    v_DoiTuongTongDatId in number,
    v_tongDatID in number,
    v_lyDoThuHoi in nvarchar2,
    v_ngayThuHoi in date,
    v_nguoiSua in nvarchar2
);

PROCEDURE ADS_TONGDAT_VBDH_DOITUONG(
    v_DoiTuongTongDatId in number
);

 PROCEDURE ADS_TONGDATNOINHAN_DEL(
        vID in NUMBER
    );

PROCEDURE ADS_TONGDAT_GETBYID(
    vID in Number , 
    curReturn out SYS_REFCURSOR 
  );

 PROCEDURE ADS_TONGDATDOITUONG_REMOVEBYID(
    vID in Number ,
    returnID out Number 
 );

 PROCEDURE GetTENTCTT_BYMA(
    vID in varchar2,
   curReturn out SYS_REFCURSOR 
);

 PROCEDURE ADS_TONGDATDOITUONG_GETBYTONGDATDUONGSUID(
    vTONGDATID in number ,
    vDUONGSUID in number , 
    curReturn out SYS_REFCURSOR 
 );

 PROCEDURE ADS_TONGDATDOITUONG_GETBYTONGDATID(
    vTONGDATID in number , 
    curReturn out SYS_REFCURSOR
 );

 PROCEDURE ADS_TONGDATDOITUONG_GETNAME(
    vID in Number  ,
    vDUONGSUID in Number , 
    curReturn out SYS_REFCURSOR 
 );

  PROCEDURE ADS_TONGDATDOITUONG_GETTENDUONGSU(
    vID in Number , 
    curReturn out SYS_REFCURSOR
 );

PROCEDURE AHN_TONGDATDOITUONG_GETBYTONGDATID(
    vTONGDATID in number,
    curReturn out SYS_REFCURSOR
);

PROCEDURE AHN_TONGDAT_THUHOI(
    v_id in number,
    vNgayThuHoi in date,
    vLyDo in varchar2,
    vNguoiSua in varchar2
);

PROCEDURE AHN_TONGDAT_THUHOI_DOITUONG(
    v_DoiTuongTongDatId in number,
    v_tongDatID in number,
    v_lyDoThuHoi in nvarchar2,
    v_ngayThuHoi in date,
    v_nguoiSua in nvarchar2
);

PROCEDURE AHN_TONGDAT_VBDH_DOITUONG(
    v_DoiTuongTongDatId in number
);

PROCEDURE AHN_TONGDAT_GETBYID(
    vID in number,
    curReturn out SYS_REFCURSOR
);

PROCEDURE AHN_TONGDATDOITUONG_GETTENDUONGSU(
    vID in number,
    curReturn out SYS_REFCURSOR
);

PROCEDURE AHN_TONGDATDOITUONG_GETBYID(
    vID in NUMBER,
    curReturn out SYS_REFCURSOR
);

-- Án hôn nhân gia đình
PROCEDURE AHN_TONGDATDOITUONG_GETBY(
    vDonID in Decimal ,
    vToaAnID in Decimal , 
    vBieuMauID in Decimal ,
    vIsOnLyNKK in Decimal ,
    vFileID in Decimal,
    curReturn out SYS_REFCURSOR
);

PROCEDURE AHN_TONGDATDOITUONG_REMOVEBYID(
    vID in number,
    returnID out number
);

PROCEDURE AHN_TONGDATNOINHAN_UP_IN
(
    v_id in number DEFAULT 0,
    v_TONGDATID in NUMBER , 
    v_MATUCACH in VARCHAR2 , 
    v_NGAYGUI in DATE,
    v_TRANGTHAI in NUMBER ,
    v_HINHTHUCGUI in NUMBER , 
    V_DUONGSUID in NUMBER,
    v_NGAYNHANTONGDAT in DATE,
    v_QUOCGIA in NUMBER,
    v_COQUAN in VARCHAR2,
    v_NOIDUNG in CLOB ,
    v_KETQUAUTTP in NUMBER ,
    v_NGAYPHATHANH in DATE ,
    v_NGAYTAO in DATE,
    v_NGUOITAO in VARCHAR2 ,
    v_IS_UTTP in NUMBER,
    v_UTTP in NUMBER ,
    v_NOINHAN in VARCHAR2 , 
    v_DIACHI in VARCHAR2,
    v_TOA_GIAIQUYET_ID in NUMBER,
    vID out NUMBER
) ;

PROCEDURE AHN_GETTENBM_BYTONGDATID(
    vTONGDATID in NUMBER,
    curReturn out SYS_REFCURSOR
);

PROCEDURE AHN_TONGDAT_UP_IN
(
    v_id in number DEFAULT 0,
    v_DONID in NUMBER, 
    v_BIEUMAUID in NUMBER,
    v_TOAANID in NUMBER, 
    v_IS_TD_VKS in NUMBER, 
    v_IS_TD_VKS_NGAY in date,
    v_NGAYTAO in date, 
    v_NGUOITAO in VARCHAR2,
    v_NGAYSUA in DATE,
    v_NGUOISUA in VARCHAR2,
    v_TENFILE in VARCHAR2 ,
    v_KIEUFILE in VARCHAR2 ,
    v_NOIDUNGFILE in BLOB, 
    v_FILEID in number, 
    v_NGAYDANG_CTTDT in date,
    v_NGAYNHANTONGDAT in DATE,
    v_TRANGTHAI in NUMBER, 
    v_NGAYTHUHOI in date,
    v_LYDOTHUHOI in varchar2,
    v_URL_FILE in varchar2,
    v_MAPID IN NUMBER, -- VNPT 25/06/2025 thêm tham số INSERT tống đạt miễn án phí
    v_MAP_TABLE IN varchar2, -- VNPT 25/06/2025 thêm tham số INSERT tống đạt miễn án phí
    v_TOA_GIAIQUYET_ID in NUMBER,
    vID out number
);

-- Án kinh doanh thương mại
PROCEDURE AKT_TONGDATDOITUONG_GETBY(
    vDonID in Decimal ,
    vToaAnID in Decimal , 
    vBieuMauID in Decimal ,
    vIsOnLyNKK in Decimal ,
    vFileID in Decimal,
    curReturn out SYS_REFCURSOR);

PROCEDURE AKT_TONGDATDOITUONG_GETBYTONGDATID(
    vTONGDATID in number,
    curReturn out SYS_REFCURSOR
);

PROCEDURE AKT_TONGDAT_THUHOI(
    v_id in number,
    vNgayThuHoi in date,
    vLyDo in varchar2,
    vNguoiSua in varchar2
);

PROCEDURE AKT_TONGDAT_THUHOI_DOITUONG(
    v_DoiTuongTongDatId in number,
    v_tongDatID in number,
    v_lyDoThuHoi in nvarchar2,
    v_ngayThuHoi in date,
    v_nguoiSua in nvarchar2
);

PROCEDURE AKT_TONGDAT_VBDH_DOITUONG(
    v_DoiTuongTongDatId in number
);

PROCEDURE AKT_TONGDAT_GETBYID(
    vID in number,
    curReturn out SYS_REFCURSOR
);

PROCEDURE AKT_TONGDATDOITUONG_GETTENDUONGSU(
    vID in number,
    curReturn out SYS_REFCURSOR
);

PROCEDURE AKT_TONGDATDOITUONG_GETBYID(
    vID in NUMBER,
    curReturn out SYS_REFCURSOR
);

PROCEDURE AKT_TONGDATDOITUONG_REMOVEBYID(
    vID in number,
    returnID out number
);

PROCEDURE AKT_TONGDATNOINHAN_UP_IN
(
    v_id in number DEFAULT 0,
    v_TONGDATID in NUMBER , 
    v_MATUCACH in VARCHAR2 , 
    v_NGAYGUI in DATE,
    v_TRANGTHAI in NUMBER ,
    v_HINHTHUCGUI in NUMBER , 
    V_DUONGSUID in NUMBER,
    v_NGAYNHANTONGDAT in DATE,
    v_QUOCGIA in NUMBER,
    v_COQUAN in VARCHAR2,
    v_NOIDUNG in CLOB ,
    v_KETQUAUTTP in NUMBER ,
    v_NGAYPHATHANH in DATE ,
    v_NGAYTAO in DATE,
    v_NGUOITAO in VARCHAR2 ,
    v_IS_UTTP in NUMBER,
    v_UTTP in NUMBER ,
    v_NOINHAN in VARCHAR2 , 
    v_DIACHI in VARCHAR2,
    v_TOA_GIAIQUYET_ID in NUMBER,
    vID out NUMBER
);

PROCEDURE AKT_GETTENBM_BYTONGDATID(
    vTONGDATID in NUMBER,
    curReturn out SYS_REFCURSOR
);

PROCEDURE AKT_TONGDAT_UP_IN
( 
    v_id in number DEFAULT 0,
    v_DONID in NUMBER, 
    v_BIEUMAUID in NUMBER,
    v_TOAANID in NUMBER, 
    v_IS_TD_VKS in NUMBER, 
    v_IS_TD_VKS_NGAY in date,
    v_NGAYTAO in date, 
    v_NGUOITAO in VARCHAR2,
    v_NGAYSUA in DATE,
    v_NGUOISUA in VARCHAR2,
    v_TENFILE in VARCHAR2 ,
    v_KIEUFILE in VARCHAR2 ,
    v_NOIDUNGFILE in BLOB, 
    v_FILEID in number, 
    v_NGAYDANG_CTTDT in date,
    v_NGAYNHANTONGDAT in DATE,
    v_TRANGTHAI in NUMBER, 
    v_NGAYTHUHOI in date,
    v_LYDOTHUHOI in varchar2,
    v_URL_FILE in varchar2,
    v_MAPID IN NUMBER, -- VNPT 25/06/2025 thêm tham số INSERT tống đạt miễn án phí
    v_MAP_TABLE IN varchar2, -- VNPT 25/06/2025 thêm tham số INSERT tống đạt miễn án phí
    v_TOA_GIAIQUYET_ID in NUMBER,
    vID out number
);

-- Án lao động
PROCEDURE ALD_TONGDATDOITUONG_GETBY(
    vDonID in Decimal , 
    vToaAnID in Decimal , 
    vBieuMauID in Decimal ,
    vIsOnLyNKK in Decimal ,
    vFileID in Decimal,
    curReturn out SYS_REFCURSOR
);

PROCEDURE ALD_TONGDATDOITUONG_GETBYTONGDATID(
    vTONGDATID in number,
    curReturn out SYS_REFCURSOR
);

PROCEDURE ALD_TONGDAT_THUHOI(
    v_id in number,
    vNgayThuHoi in date,
    vLyDo in varchar2,
    vNguoiSua in varchar2
);

PROCEDURE ALD_TONGDAT_THUHOI_DOITUONG(
    v_DoiTuongTongDatId in number,
    v_tongDatID in number,
    v_lyDoThuHoi in nvarchar2,
    v_ngayThuHoi in date,
    v_nguoiSua in nvarchar2
);

PROCEDURE ALD_TONGDAT_VBDH_DOITUONG(
    v_DoiTuongTongDatId in number
);

PROCEDURE ALD_TONGDAT_GETBYID(
    vID in number,
    curReturn out SYS_REFCURSOR
);

PROCEDURE ALD_TONGDATDOITUONG_GETTENDUONGSU(
    vID in number,
    curReturn out SYS_REFCURSOR
);

PROCEDURE ALD_TONGDATDOITUONG_GETBYID(
    vID in NUMBER,
    curReturn out SYS_REFCURSOR
);

PROCEDURE ALD_TONGDATDOITUONG_REMOVEBYID(
    vID in number,
    returnID out number
);

PROCEDURE ALD_TONGDATNOINHAN_UP_IN
(
    v_id in number DEFAULT 0,
    v_TONGDATID in NUMBER , 
    v_MATUCACH in VARCHAR2 , 
    v_NGAYGUI in DATE,
    v_TRANGTHAI in NUMBER ,
    v_HINHTHUCGUI in NUMBER , 
    V_DUONGSUID in NUMBER,
    v_NGAYNHANTONGDAT in DATE,
    v_QUOCGIA in NUMBER,
    v_COQUAN in VARCHAR2,
    v_NOIDUNG in CLOB ,
    v_KETQUAUTTP in NUMBER ,
    v_NGAYPHATHANH in DATE ,
    v_NGAYTAO in DATE,
    v_NGUOITAO in VARCHAR2 ,
    v_IS_UTTP in NUMBER,
    v_UTTP in NUMBER ,
    v_NOINHAN in VARCHAR2 , 
    v_DIACHI in VARCHAR2,
    v_TOA_GIAIQUYET_ID in NUMBER,
    vID out NUMBER
);

PROCEDURE ALD_GETTENBM_BYTONGDATID(
    vTONGDATID in NUMBER,
    curReturn out SYS_REFCURSOR
);

PROCEDURE ALD_TONGDAT_UP_IN
(
    v_id in number DEFAULT 0,
    v_DONID in NUMBER, 
    v_BIEUMAUID in NUMBER,
    v_TOAANID in NUMBER, 
    v_IS_TD_VKS in NUMBER, 
    v_IS_TD_VKS_NGAY in date,
    v_NGAYTAO in date, 
    v_NGUOITAO in VARCHAR2,
    v_NGAYSUA in DATE,
    v_NGUOISUA in VARCHAR2,
    v_TENFILE in VARCHAR2 ,
    v_KIEUFILE in VARCHAR2 ,
    v_NOIDUNGFILE in BLOB, 
    v_FILEID in number, 
    v_NGAYDANG_CTTDT in date,
    v_NGAYNHANTONGDAT in DATE,
    v_TRANGTHAI in NUMBER, 
    v_NGAYTHUHOI in date,
    v_LYDOTHUHOI in varchar2,
    v_URL_FILE in varchar2,
    v_MAPID IN NUMBER, -- VNPT 25/06/2025 thêm tham số INSERT tống đạt miễn án phí
    v_MAP_TABLE IN varchar2, -- VNPT 25/06/2025 thêm tham số INSERT tống đạt miễn án phí
    v_TOA_GIAIQUYET_ID in NUMBER, -- vnpt 05/07/2025 thêm tham số INSERT tổng đạt miễn án phí
    vID out number
);

-- Án hành chính
PROCEDURE AHC_TONGDATDOITUONG_GETBY(
    vDonID in Decimal ,
    vToaAnID in Decimal , 
    vBieuMauID in Decimal ,
    vIsOnLyNKK in Decimal ,
    vFileID in Decimal,
    curReturn out SYS_REFCURSOR
);

PROCEDURE AHC_TONGDATDOITUONG_GETBYTONGDATID(
    vTONGDATID in number,
    curReturn out SYS_REFCURSOR
);

PROCEDURE AHC_TONGDAT_THUHOI(
    v_id in number,
    vNgayThuHoi in date,
    vLyDo in varchar2,
    vNguoiSua in varchar2
);

PROCEDURE AHC_TONGDAT_THUHOI_DOITUONG(
    v_DoiTuongTongDatId in number,
    v_tongDatID in number,
    v_lyDoThuHoi in nvarchar2,
    v_ngayThuHoi in date,
    v_nguoiSua in nvarchar2
);

PROCEDURE AHC_TONGDAT_VBDH_DOITUONG(
    v_DoiTuongTongDatId in number
);

PROCEDURE AHC_TONGDAT_GETBYID(
    vID in number,
    curReturn out SYS_REFCURSOR
);

PROCEDURE AHC_TONGDATDOITUONG_GETTENDUONGSU(
    vID in number,
    curReturn out SYS_REFCURSOR
);

PROCEDURE AHC_TONGDATDOITUONG_GETBYID(
    vID in NUMBER,
    curReturn out SYS_REFCURSOR
);

PROCEDURE AHC_TONGDATDOITUONG_REMOVEBYID(
    vID in number,
    returnID out number
);

PROCEDURE AHC_TONGDATNOINHAN_UP_IN
(
    v_id in number DEFAULT 0,
    v_TONGDATID in NUMBER , 
    v_MATUCACH in VARCHAR2 , 
    v_NGAYGUI in DATE,
    v_TRANGTHAI in NUMBER ,
    v_HINHTHUCGUI in NUMBER , 
    V_DUONGSUID in NUMBER,
    v_NGAYNHANTONGDAT in DATE,
    v_QUOCGIA in NUMBER,
    v_COQUAN in VARCHAR2,
    v_NOIDUNG in CLOB ,
    v_KETQUAUTTP in NUMBER ,
    v_NGAYPHATHANH in DATE ,
    v_NGAYTAO in DATE,
    v_NGUOITAO in VARCHAR2 ,
    v_IS_UTTP in NUMBER,
    v_UTTP in NUMBER ,
    v_NOINHAN in VARCHAR2 , 
    v_DIACHI in VARCHAR2,
    v_TOA_GIAIQUYET_ID in NUMBER,
    vID out NUMBER
);

PROCEDURE AHC_GETTENBM_BYTONGDATID(
    vTONGDATID in NUMBER,
    curReturn out SYS_REFCURSOR
);

PROCEDURE AHC_TONGDAT_UP_IN
(
    v_id in number DEFAULT 0,
    v_DONID in NUMBER, 
    v_BIEUMAUID in NUMBER,
    v_TOAANID in NUMBER, 
    v_IS_TD_VKS in NUMBER, 
    v_IS_TD_VKS_NGAY in date,
    v_NGAYTAO in date, 
    v_NGUOITAO in VARCHAR2,
    v_NGAYSUA in DATE,
    v_NGUOISUA in VARCHAR2,
    v_TENFILE in VARCHAR2 ,
    v_KIEUFILE in VARCHAR2 ,
    v_NOIDUNGFILE in BLOB, 
    v_FILEID in number, 
    v_NGAYDANG_CTTDT in date,
    v_NGAYNHANTONGDAT in DATE,
    v_TRANGTHAI in NUMBER, 
    v_NGAYTHUHOI in date,
    v_LYDOTHUHOI in varchar2,
    v_URL_FILE in varchar2,
    v_MAPID IN NUMBER, -- VNPT 25/06/2025 thêm tham số INSERT tống đạt miễn án phí
    v_MAP_TABLE IN varchar2, -- VNPT 25/06/2025 thêm tham số INSERT tống đạt miễn án phí
    v_TOA_GIAIQUYET_ID in NUMBER, -- VNPT 05/07/25 thêm tham số INSERT tổng đạt miễn án phí
    vID out number
);

-- Án phá sản
PROCEDURE APS_TONGDATDOITUONG_GETBY(
    vDonID in Decimal,
    vToaAnID in Decimal, 
    vBieuMauID in Decimal,
    vIsOnLyNKK in Decimal,
    curReturn out SYS_REFCURSOR
);

PROCEDURE APS_TONGDATDOITUONG_GETBYTONGDATID(
    vTONGDATID in number,
    curReturn out SYS_REFCURSOR
);

PROCEDURE APS_TONGDAT_THUHOI(
    v_id in number,
    vNgayThuHoi in date,
    vLyDo in varchar2,
    vNguoiSua in varchar2
);

PROCEDURE APS_TONGDAT_THUHOI_DOITUONG(
    v_DoiTuongTongDatId in number,
    v_tongDatID in number,
    v_lyDoThuHoi in nvarchar2,
    v_ngayThuHoi in date,
    v_nguoiSua in nvarchar2
);

PROCEDURE APS_TONGDAT_VBDH_DOITUONG(
    v_DoiTuongTongDatId in number
);

PROCEDURE APS_TONGDAT_GETBYID(
    vID in number,
    curReturn out SYS_REFCURSOR
);

PROCEDURE APS_TONGDATDOITUONG_GETTENDUONGSU(
    vID in number,
    curReturn out SYS_REFCURSOR
);

PROCEDURE APS_TONGDATDOITUONG_GETBYID(
    vID in NUMBER,
    curReturn out SYS_REFCURSOR
);

PROCEDURE APS_TONGDATDOITUONG_REMOVEBYID(
    vID in number,
    returnID out number
);

PROCEDURE APS_TONGDATNOINHAN_UP_IN
( 
    v_id in number DEFAULT 0,
    v_TONGDATID in NUMBER , 
    v_MATUCACH in VARCHAR2 , 
    v_NGAYGUI in DATE,
    v_TRANGTHAI in NUMBER ,
    v_HINHTHUCGUI in NUMBER , 
    V_DUONGSUID in NUMBER,
    v_NGAYNHANTONGDAT in DATE,
    v_QUOCGIA in NUMBER,
    v_COQUAN in VARCHAR2,
    v_NOIDUNG in CLOB ,
    v_KETQUAUTTP in NUMBER ,
    v_NGAYPHATHANH in DATE ,
    v_NGAYTAO in DATE,
    v_NGUOITAO in VARCHAR2 ,
    v_IS_UTTP in NUMBER,
    v_UTTP in NUMBER ,
    v_NOINHAN in VARCHAR2 , 
    v_DIACHI in VARCHAR2,
    vID out NUMBER
);

PROCEDURE APS_GETTENBM_BYTONGDATID(
    vTONGDATID in NUMBER,
    curReturn out SYS_REFCURSOR
);

PROCEDURE APS_TONGDAT_UP_IN
(
    v_id in number DEFAULT 0,
    v_DONID in NUMBER, 
    v_BIEUMAUID in NUMBER,
    v_TOAANID in NUMBER, 
    v_IS_TD_VKS in NUMBER, 
    v_IS_TD_VKS_NGAY in date,
    v_NGAYTAO in date, 
    v_NGUOITAO in VARCHAR2,
    v_NGAYSUA in DATE,
    v_NGUOISUA in VARCHAR2,
    v_TENFILE in VARCHAR2 ,
    v_KIEUFILE in VARCHAR2 ,
    v_NOIDUNGFILE in BLOB, 
    v_FILEID in number, 
    v_NGAYDANG_CTTDT in date,
    v_NGAYNHANTONGDAT in DATE,
    v_TRANGTHAI in NUMBER, 
    v_NGAYTHUHOI in date,
    v_LYDOTHUHOI in varchar2,
    v_URL_FILE in varchar2,
    v_MAPID IN NUMBER, -- VNPT 25/06/2025 thêm tham số INSERT tống đạt miễn án phí
    v_MAP_TABLE IN varchar2, -- VNPT 25/06/2025 thêm tham số INSERT tống đạt miễn án phí
    vID out number
);

-- Án hình sự
PROCEDURE AHS_TONGDATDOITUONG_GETBY(
    vVuAnID in Decimal ,
    vToaAnID in Decimal , 
    vBieuMauID in Decimal ,
    vIsOnLyNKK in Decimal ,
    vFileID in Decimal,
    curReturn out SYS_REFCURSOR
);

PROCEDURE AHS_TONGDATDOITUONG_GETBYTONGDATID(
    vTONGDATID in number,
    curReturn out SYS_REFCURSOR
);

PROCEDURE AHS_TONGDAT_THUHOI(
    v_id in number,
    vNgayThuHoi in date,
    vLyDo in varchar2,
    vNguoiSua in varchar2
);

PROCEDURE AHS_TONGDAT_THUHOI_DOITUONG(
    v_DoiTuongTongDatId in number,
    v_tongDatID in number,
    v_lyDoThuHoi in nvarchar2,
    v_ngayThuHoi in date,
    v_nguoiSua in nvarchar2
);

PROCEDURE AHS_TONGDAT_VBDH_DOITUONG(
    v_DoiTuongTongDatId in number
);

PROCEDURE AHS_TONGDAT_GETBYID(
    vID in number,
    curReturn out SYS_REFCURSOR
);

PROCEDURE AHS_TONGDATDOITUONG_GETTENDUONGSU(
    vID in number,
    curReturn out SYS_REFCURSOR
);

PROCEDURE AHS_TONGDATDOITUONG_GETBYID(
    vID in NUMBER,
    curReturn out SYS_REFCURSOR
);

PROCEDURE AHS_TONGDATDOITUONG_REMOVEBYID(
    vID in number,
    returnID out number
);

PROCEDURE AHS_TONGDATNOINHAN_UP_IN
( 
    v_id in number DEFAULT 0,
    v_TONGDATID in NUMBER , 
    v_MATUCACH in VARCHAR2 , 
    v_NGAYGUI in DATE,
    v_TRANGTHAI in NUMBER ,
    v_HINHTHUCGUI in NUMBER , 
    V_DUONGSUID in NUMBER,
    v_NGAYNHANTONGDAT in DATE,
    v_QUOCGIA in NUMBER,
    v_COQUAN in VARCHAR2,
    v_NOIDUNG in CLOB ,
    v_KETQUAUTTP in NUMBER ,
    v_NGAYPHATHANH in DATE ,
    v_NGAYTAO in DATE,
    v_NGUOITAO in VARCHAR2 ,
    v_IS_UTTP in NUMBER,
    v_UTTP in NUMBER ,
    v_NOINHAN in VARCHAR2 , 
    v_DIACHI in VARCHAR2,
    v_TOA_GIAIQUYET_ID in NUMBER,
    vID out NUMBER
);

PROCEDURE AHS_GETTENBM_BYTONGDATID(
    vTONGDATID in NUMBER,
    curReturn out SYS_REFCURSOR
);


PROCEDURE AHS_TONGDAT_UP_IN
(
    v_id in number DEFAULT 0,
    v_DONID in NUMBER, 
    v_BIEUMAUID in NUMBER,
    v_TOAANID in NUMBER, 
    v_IS_TD_VKS in NUMBER, 
    v_IS_TD_VKS_NGAY in date,
    v_NGAYTAO in date, 
    v_NGUOITAO in VARCHAR2,
    v_NGAYSUA in DATE,
    v_NGUOISUA in VARCHAR2,
    v_TENFILE in VARCHAR2 ,
    v_KIEUFILE in VARCHAR2 ,
    v_NOIDUNGFILE in BLOB, 
    v_FILEID in number, 
    v_NGAYDANG_CTTDT in date,
    v_NGAYNHANTONGDAT in DATE,
    v_TRANGTHAI in NUMBER, 
    v_NGAYTHUHOI in date,
    v_LYDOTHUHOI in varchar2,
    v_URL_FILE in varchar2,
    v_MAPID IN NUMBER,
    v_MAP_TABLE IN varchar2,
    v_TOA_GIAIQUYET_ID in NUMBER,
    vID out number
);

PROCEDURE GET_BM_TONGDAT
(
    vLoaiAn in number,
	vMaGiaiDoan number,
	vDonID number,
	curReturn out sys_refcursor
);

PROCEDURE GET_LYDO_THUHOI
(
    vLoaiAn in number,
	vTongDatID number,
	curReturn out sys_refcursor
);

END PKG_STPT_TONGDAT;