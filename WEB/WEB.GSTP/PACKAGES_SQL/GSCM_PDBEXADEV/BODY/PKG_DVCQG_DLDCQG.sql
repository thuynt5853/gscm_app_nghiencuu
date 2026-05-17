--------------------------------------------------------
--  DDL for Package Body PKG_DVCQG_DLDCQG
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_DVCQG_DLDCQG" AS

FUNCTION CREATE_MA_DONGBO_RANDOM
RETURN VARCHAR2
AS
    V_COUNTS_MADB NUMBER;
    V_MA_DB VARCHAR2(255);
    V_TEMP VARCHAR2(255);
BEGIN
    -- Sinh mã ngẫu nhiên
    SELECT DBMS_RANDOM.STRING('x', 10) INTO V_MA_DB FROM DUAL;

    -- Kiểm tra trùng trong DB
    SELECT CASE  
             WHEN EXISTS (
               SELECT 1 
               FROM C06_TOAAN_TINHTRANGHONNHAN 
               WHERE maDinhDanhBanAn = V_MA_DB
             ) THEN 1 
             ELSE 0 
           END 
    INTO V_COUNTS_MADB 
    FROM DUAL;

    IF V_COUNTS_MADB = 1 THEN
        -- Đệ quy gọi lại chính hàm này để tạo mã mới
        V_TEMP := CREATE_MA_DONGBO_RANDOM();  -- Gọi lại chính nó
        RETURN V_TEMP;
    ELSE
        RETURN V_MA_DB;
    END IF;
END CREATE_MA_DONGBO_RANDOM; 

PROCEDURE GetDulieuChon_ThuHoiGanNhat
(   v_LoaiAn in varchar2, 
    v_LoaiBAQD in varchar2, 
    v_IdBAQD in varchar2, 
    curReturn OUT sys_refcursor
)
AS
   
BEGIN	
     
    ---------------------------------------
   OPEN CURRETURN FOR
                --TH1: Bản án không có kháng cao kháng nghi
           SELECT 
                             b.id,
                             b.DONID,
                             b.status
                        FROM 
                            C06_TOAAN_TINHTRANGHONNHAN B
                        WHERE 
                             B.LOAIAN_ID = v_LoaiAn
                             AND B.LOAI_BAQD = v_LoaiBAQD
                             AND B.BAQD_ID = v_IdBAQD
                             AND b.status = 0
                             AND b.TRANGTHAIBANGHI =  3
                             AND b.ID = (SELECT MAX(ID)
                                            FROM C06_TOAAN_TINHTRANGHONNHAN
                                            WHERE 
                                                LOAIAN_ID = v_LoaiAn
                                                AND LOAI_BAQD = v_LoaiBAQD
                                                AND BAQD_ID = v_IdBAQD
                                                AND status = 0
                                                AND TRANGTHAIBANGHI = 3
                                        )
    ;

  
END GetDulieuChon_ThuHoiGanNhat;

PROCEDURE GET_BAQD_DaDongBo_BY_ID
(  V_DonBoID in varchar2,   
    curReturn OUT sys_refcursor
)
AS
   
BEGIN	
     
    ---------------------------------------
   OPEN CURRETURN FOR
            SELECT  ROW_NUMBER() OVER (ORDER BY A.NGAY_RA_BAN_AN desc) STT
                ,COUNT(*) OVER () as CountAll
                ,A.* FROM (
                      SELECT 
                             b.DONID,
                            --Loai An
                            b.LOAIAN_ID,
                            'Hôn nhân gia đình' as LOAI_AN_TEN,
                            b.LOAI_BAQD AS LOAIBAQD,
                            b.BAQD_ID as BAQD_ID,
                            b.MAVUVIEC AS MavuAn,
                            b.TenVuAn, 
                            b.CAPXX,
                            b.SO_BAN_AN,
                            B.NGAY_RA_BAN_AN AS NGAY_RA_BAN_AN,
                            b.NGAY_HIEU_LUC_BA,
                            B.DON_VI_RA_BAN_AN_ID,
                            b.DON_VI_RA_BAN_AN_TEN AS DON_VI_RA_BAN_AN_TEN,
                            b.NGAY_NHAN_NGUYEN_DON,
                            b.NGAY_NHAN_BI_DON,
                            b.HO_TEN_NGUYEN_DON AS HO_TEN_NGUYEN_DON,
                            b.SO_GIAY_TO_NGUYEN_DON AS SO_GIAY_TO_NGUYEN_DON,
                            b.NGAY_SINH_NGUYEN_DON,
                            b.QUOC_TICH_NGUYEN_DON AS QUOC_TICH_NGUYEN_DON,
                            b.HO_TEN_BI_DON AS HO_TEN_BI_DON,            
                            b.SO_GIAY_TO_BI_DON AS SO_GIAY_TO_BI_DON,
                            b.NGAY_SINH_BI_DON,
                            b.QUOC_TICH_BI_DON AS QUOC_TICH_BI_DON,
                            b.TRANG_THAI_TTHN,                            
                            b.trangThaiBanGhi,
                            b.GhiChu,
                            b.KHANGCAOQH,
                            b.TRANG_THAI_DONGBO,
                            b.NGAYGUI,
                             b.TAIKHOANGUI,
                             DECODE(b.NGAYDONGBO, NULL, NULL,TO_CHAR(b.NGAYDONGBO,'dd/MM/yyyy'))  AS NGAYDONGBO,
                             b.status,
                            B.NGUYENDON_ID,
                            B.BIDON_ID,
                            b.thuly,
                             B.trangThaiXacThucNguyenDon,
                             B.trangThaiXacThucBiDon,
                             B.maDinhDanhBanAn,
                             B.GIOI_TINH_NGUYEN_DON,
                             B.SO_CMND_NGUYEN_DON,
                             B.GIOI_TINH_BI_DON,
                             B.SO_CMND_BI_DON,
                             B.MADONVINHANBANAN,
                             B.TENDONVINHANBANAN,
                             B.SOGIAYCNKH,
                             B.loaiViec
                             
                        FROM 
                            C06_TOAAN_TINHTRANGHONNHAN B
                        WHERE 
                             B.ID = V_DonBoID
                             -- Đã đồng bộ mới thu hồi, còn chưa đông bộ thì hủy chuyển
                             --AND b.TRANG_THAI_DONGBO = 1
                        )A

    ;

  
END GET_BAQD_DaDongBo_BY_ID;

PROCEDURE GET_BAQD_LichSuChuyen
(  V_DongBoID in varchar2,   
    curReturn OUT sys_refcursor
)
AS
    vLOAIAN_ID number;
    vLOAI_BAQD number;
    vBAQD_ID number;
    
BEGIN	
    select LOAIAN_ID,LOAI_BAQD,BAQD_ID into  vLOAIAN_ID,vLOAI_BAQD,vBAQD_ID from C06_TOAAN_TINHTRANGHONNHAN where id = V_DongBoID;
    ---------------------------------------
   OPEN CURRETURN FOR
            SELECT  ROW_NUMBER() OVER (ORDER BY A.ID desc) STT
                ,COUNT(*) OVER () as CountAll
                ,A.* FROM (
                --TH1: Bản án không có kháng cao kháng nghi
                      SELECT 
                            b.id,
                            b.DONID,
                            --Loai An
                            b.LOAIAN_ID,
                            'Hôn nhân gia đình' as LOAI_AN_TEN,
                            b.LOAI_BAQD AS LOAIBAQD,
                            b.BAQD_ID,
                            b.MAVUVIEC AS MavuAn,
                            b.TenVuAn, 
                            b.CAPXX,
                            b.SO_BAN_AN,
                            B.NGAY_RA_BAN_AN AS NGAY_RA_BAN_AN,
                            b.NGAY_HIEU_LUC_BA,
                            DECODE(TL.TRUONGHOPTHULY,3,'Thụ lý xét xử lại do GDT hủy',2,'Thụ lý xét xử lại do PT hủy','Thụ lý mới')
                                        ||' - số'|| TL.SOTHULY ||' ngày '|| TO_CHAR(TL.NGAYTHULY,'dd/MM/yyyy')  AS THULY,
                            B.DON_VI_RA_BAN_AN_ID,
                            b.DON_VI_RA_BAN_AN_TEN AS DON_VI_RA_BAN_AN_TEN,
                            b.NGAY_NHAN_NGUYEN_DON,
                            b.NGAY_NHAN_BI_DON,
                            b.HO_TEN_NGUYEN_DON AS HO_TEN_NGUYEN_DON,
                            b.SO_GIAY_TO_NGUYEN_DON AS SO_GIAY_TO_NGUYEN_DON,
                            b.NGAY_SINH_NGUYEN_DON,
                            b.QUOC_TICH_NGUYEN_DON AS QUOC_TICH_NGUYEN_DON,
                            b.HO_TEN_BI_DON AS HO_TEN_BI_DON,            
                            b.SO_GIAY_TO_BI_DON AS SO_GIAY_TO_BI_DON,
                            b.NGAY_SINH_BI_DON,
                            b.QUOC_TICH_BI_DON AS QUOC_TICH_BI_DON,
                            b.TRANG_THAI_TTHN,  
                            b.trangThaiBanGhi,
                            b.GhiChu,
                            DECODE(b.TRANG_THAI_DONGBO,'0','Chưa đồng bộ','Đã đồng bộ') AS TRANGTHAIGUI,
                            TO_CHAR(b.NGAYGUI,'dd/MM/yyyy') AS NGAYGUI,
                             b.TAIKHOANGUI,
                             DECODE(b.NGAYDONGBO, NULL, NULL,TO_CHAR(b.NGAYDONGBO,'dd/MM/yyyy'))  AS NGAYDONGBO,
                             b.KHANGCAOQH,
                             h1.MA_TEN AS DIACHI_NGUYEN_DON,
                             h2.MA_TEN AS DIACHI_BI_DON,
                             B.trangThaiXacThucNguyenDon,
                             B.trangThaiXacThucBiDon,
                             B.maDinhDanhBanAn,
                             B.GIOI_TINH_NGUYEN_DON,
                             B.SO_CMND_NGUYEN_DON,
                             B.GIOI_TINH_BI_DON,
                             B.SO_CMND_BI_DON,
                             B.MADONVINHANBANAN,
                             B.TENDONVINHANBANAN,
                             B.SOGIAYCNKH,
                             B.loaiViec
                             
                        FROM 
                            C06_TOAAN_TINHTRANGHONNHAN B
                                LEFT JOIN AHN_SOTHAM_THULY TL ON TL.DONID = B.DONID
                                left join DM_HANHCHINH h1 on h1.ID=B.NGUYENDON_ID
                                left join DM_HANHCHINH h2 on h2.ID=B.BIDON_ID
                        WHERE 
                             B.LOAIAN_ID = vLOAIAN_ID
                             AND B.LOAI_BAQD = vLOAI_BAQD
                             AND B.BAQD_ID = vBAQD_ID
                         
                        )A

    ;

  
END GET_BAQD_LichSuChuyen;

PROCEDURE EXT_SEARCH_ALL_ThuHoi
(  
    V_LOAIAN_ID IN VARCHAR2,
    v_LOAIBAQD in varchar2,
    v_BAQD_id in varchar2,
    v_KHANGCAOQH in varchar2,
    v_toaan_id in varchar2,
    v_Capxx in varchar2,
    
    v_ten_vu_an in varchar2, 
    v_toidanh in varchar2, 
    v_ma_vu_an in varchar2, 
    v_bi_can in varchar2,
    v_cccd  in varchar2,     
    v_so_qd in varchar2,
    V_TUNGAY IN VARCHAR2,
    V_DENNGAY IN VARCHAR2,
    v_thamphan_id in varchar2, 
    v_thuky_id in varchar2,
    V_TRANGTHAI_GUI IN DECIMAL,
    V_NGAYGUI_TU in varchar2,
    V_NGAYGUI_DEN in varchar2,
    
    Page_Index in	int,
    Page_Size	in	int,
    curReturn OUT sys_refcursor
)
AS
     MinIndex number; MaxIndex number;
     
BEGIN	
     
    ---------------------------------------
    MinIndex := Page_Size*(Page_Index - 1) + 1;
    MaxIndex := Page_Index*Page_Size;
    
   OPEN CURRETURN FOR
    SELECT tt.* FROM(
            SELECT  ROW_NUMBER() OVER (ORDER BY A.NGAY_RA_BAN_AN desc) STT
                ,COUNT(*) OVER () as CountAll
                ,A.* FROM (
                --TH1: Bản án không có kháng cao kháng nghi
                      SELECT 
                            b.id,
                            b.DONID,
                            --Loai An
                            b.LOAIAN_ID,
                            'Hôn nhân gia đình' as LOAI_AN_TEN,
                            b.LOAI_BAQD AS LOAIBAQD,
                            b.BAQD_ID,
                            b.MAVUVIEC AS MavuAn,
                            b.TenVuAn, 
                            b.CAPXX,
                            b.SO_BAN_AN,
                            B.NGAY_RA_BAN_AN AS NGAY_RA_BAN_AN,
                            b.NGAY_HIEU_LUC_BA,
                            DECODE(TL.TRUONGHOPTHULY,3,'Thụ lý xét xử lại do GDT hủy',2,'Thụ lý xét xử lại do PT hủy','Thụ lý mới')
                                        ||' - số'|| TL.SOTHULY ||' ngày '|| TO_CHAR(TL.NGAYTHULY,'dd/MM/yyyy')  AS THULY,
                            B.DON_VI_RA_BAN_AN_ID,
                            b.DON_VI_RA_BAN_AN_TEN AS DON_VI_RA_BAN_AN_TEN,
                            b.NGAY_NHAN_NGUYEN_DON,
                            b.NGAY_NHAN_BI_DON,
                            b.HO_TEN_NGUYEN_DON AS HO_TEN_NGUYEN_DON,
                            b.SO_GIAY_TO_NGUYEN_DON AS SO_GIAY_TO_NGUYEN_DON,
                            b.NGAY_SINH_NGUYEN_DON,
                            b.QUOC_TICH_NGUYEN_DON AS QUOC_TICH_NGUYEN_DON,
                            b.HO_TEN_BI_DON AS HO_TEN_BI_DON,            
                            b.SO_GIAY_TO_BI_DON AS SO_GIAY_TO_BI_DON,
                            b.NGAY_SINH_BI_DON,
                            b.QUOC_TICH_BI_DON AS QUOC_TICH_BI_DON,
                            b.TRANG_THAI_TTHN,  
                            '1' AS trangThaiBanGhi,-- 1.Thêm mới;2.	Thu hồi
                             b.GhiChu,
                            'Bị thu hồi' AS TRANGTHAIGUI,
                             TO_CHAR(b.NGAYGUI,'dd/MM/yyyy') AS NGAYGUI,
                             b.TAIKHOANGUI,
                             DECODE(b.NGAYDONGBO, NULL, NULL,TO_CHAR(b.NGAYDONGBO,'dd/MM/yyyy'))  AS NGAYDONGBO,
                             b.KHANGCAOQH,
                             h1.MA_TEN AS DIACHI_NGUYEN_DON,
                             h2.MA_TEN AS DIACHI_BI_DON,
                             B.trangThaiXacThucNguyenDon,
                             B.trangThaiXacThucBiDon,
                             B.maDinhDanhBanAn,
                             B.GIOI_TINH_NGUYEN_DON,
                             B.SO_CMND_NGUYEN_DON,
                             B.GIOI_TINH_BI_DON,
                             B.SO_CMND_BI_DON,
                             B.MADONVINHANBANAN,
                             B.TENDONVINHANBANAN,
                             B.SOGIAYCNKH,
                             B.loaiViec
                        FROM 
                            C06_TOAAN_TINHTRANGHONNHAN B
                                LEFT JOIN AHN_SOTHAM_THULY TL ON TL.DONID = B.DONID
                                left join DM_HANHCHINH h1 on h1.ID=B.NGUYENDON_ID
                                left join DM_HANHCHINH h2 on h2.ID=B.BIDON_ID
                           where B.DON_VI_RA_BAN_AN_ID = v_toaan_id
                            AND (v_KHANGCAOQH is null OR  b.KHANGCAOQH = v_KHANGCAOQH)
                            AND (v_LOAIBAQD is null OR b.LOAI_BAQD = v_LOAIBAQD)
                            AND (v_BAQD_id is null  OR b.BAQD_id=v_BAQD_id)
                            AND (V_LOAIAN_ID is null OR b.LOAIAN_ID = V_LOAIAN_ID)
                            AND (v_Capxx is null OR (v_Capxx = 2 and  b.CAPXX = 'Sơ Thẩm') OR (v_Capxx = 3 and  b.CAPXX = 'Phúc Thẩm') )
                            AND (v_ten_vu_an IS NULL OR FN_CONVERT_TO_VN(UPPER(b.TenVuAn)) LIKE '%'||FN_CONVERT_TO_VN(UPPER(v_ten_vu_an))||'%')
                            AND (v_ma_vu_an IS NULL OR b.MAVUVIEC = v_ma_vu_an)
                            AND (v_bi_can IS NULL --Đương sự
                                      OR FN_CONVERT_TO_VN(UPPER(b.HO_TEN_NGUYEN_DON)) LIKE '%'||FN_CONVERT_TO_VN(UPPER(v_bi_can))||'%'
                                      OR FN_CONVERT_TO_VN(UPPER(b.HO_TEN_BI_DON)) LIKE '%'||FN_CONVERT_TO_VN(UPPER(v_bi_can))||'%'
                                      )
                            AND (v_cccd  IS NULL OR b.SO_GIAY_TO_NGUYEN_DON  = v_cccd OR b.SO_GIAY_TO_BI_DON  = v_cccd)
                            AND (v_so_qd  IS NULL OR b.SO_BAN_AN  = SO_BAN_AN)
                            AND (V_TUNGAY IS NULL OR b.NGAY_RA_BAN_AN  >= V_TUNGAY)
                            AND (V_DENNGAY IS NULL OR b.NGAY_RA_BAN_AN  <= V_DENNGAY)
                            AND (v_toidanh IS NULL  OR ( FN_CONVERT_TO_VN(LOWER(b.TenVuAn)) LIKE  '%'||FN_CONVERT_TO_VN(LOWER(v_toidanh))||'%' ) )--Quan hệ pháp luật tìm quan hệ pháp luật đã được gắn vào tên vụ án
                            AND (v_thuky_id IS NULL 
                                        OR EXISTS(select 'X' from AHN_SoTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=b.DONID) 
                                       OR EXISTS(select 'X' from AHN_PhucTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=b.DONID)
                                        OR EXISTS(SELECT 'X' FROM AHN_DON_THAMPHAN TP WHERE  TP.THUKYID=v_thuky_id and TP.DONID=b.DONID)
                                    )
                    
                           ----Kiem tra cu dung cua tham phan đa day khong
                           AND ( v_thamphan_id is null 
                                OR (B.CAPXX ='Sơ Thẩm' AND  EXISTS(SELECT 'x' FROM AHN_SOTHAM_HDXX TP 
                                        WHERE TP.DONID = B.DONID AND TP.MAVAITRO='THAMPHAN' AND TP.CANBOID = v_thamphan_id ))
                                 OR (B.CAPXX ='Phúc Thẩm' AND  EXISTS(SELECT 'x' FROM AHN_PHUCTHAM_HDXX TP 
                                        WHERE TP.DONID = B.DONID AND TP.MAVAITRO='THAMPHAN' AND TP.CANBOID = v_thamphan_id ))        
                                        )
                           ---Trạng thái đã gửi và bị thu hồi ----
                            AND B.STATUS = 1
                            AND B.trangThaiBanGhi = 2
                            
                            ORDER by B.id              
                        )A
                )tt where tt.stt>=MinIndex and tt.stt<=MaxIndex

    ;

END EXT_SEARCH_ALL_ThuHoi;

PROCEDURE EXT_SEARCH_ALL_DaDongBo
(  
    V_LOAIAN_ID IN VARCHAR2,
    v_LOAIBAQD in varchar2,
    v_BAQD_id in varchar2,
    v_KHANGCAOQH in varchar2,
    v_toaan_id in varchar2,
    v_Capxx in varchar2,
    
    v_ten_vu_an in varchar2, 
    v_toidanh in varchar2, 
    v_ma_vu_an in varchar2, 
    v_bi_can in varchar2,
    v_cccd  in varchar2,     
    v_so_qd in varchar2,
    V_TUNGAY IN VARCHAR2,
    V_DENNGAY IN VARCHAR2,
    v_thamphan_id in varchar2, 
    v_thuky_id in varchar2,
    V_TRANGTHAI_GUI IN DECIMAL,
    V_NGAYGUI_TU in varchar2,
    V_NGAYGUI_DEN in varchar2,
    
    Page_Index in	int,
    Page_Size	in	int,
    curReturn OUT sys_refcursor
)
AS
     MinIndex number; MaxIndex number;
     
BEGIN	
     
    ---------------------------------------
    MinIndex := Page_Size*(Page_Index - 1) + 1;
    MaxIndex := Page_Index*Page_Size;
    
   OPEN CURRETURN FOR
    SELECT tt.* FROM(
            SELECT  ROW_NUMBER() OVER (ORDER BY A.NGAYGUI desc) STT
                ,COUNT(*) OVER () as CountAll
                ,A.* FROM (
                --TH1: Bản án không có kháng cao kháng nghi
                      SELECT 
                            b.id,
                            b.DONID,
                            --Loai An
                            b.LOAIAN_ID,
                            'Hôn nhân gia đình' as LOAI_AN_TEN,
                            b.LOAI_BAQD AS LOAIBAQD,
                            b.BAQD_ID,
                            b.MAVUVIEC AS MavuAn,
                            b.TenVuAn, 
                            b.CAPXX,
                            b.SO_BAN_AN,
                            B.NGAY_RA_BAN_AN AS NGAY_RA_BAN_AN,
                            b.NGAY_HIEU_LUC_BA,
                            DECODE(TL.TRUONGHOPTHULY,3,'Thụ lý xét xử lại do GDT hủy',2,'Thụ lý xét xử lại do PT hủy','Thụ lý mới')
                                        ||' - số'|| TL.SOTHULY ||' ngày '|| TO_CHAR(TL.NGAYTHULY,'dd/MM/yyyy')  AS THULY,
                            B.DON_VI_RA_BAN_AN_ID,
                            b.DON_VI_RA_BAN_AN_TEN AS DON_VI_RA_BAN_AN_TEN,
                            b.NGAY_NHAN_NGUYEN_DON,
                            b.NGAY_NHAN_BI_DON,
                            b.HO_TEN_NGUYEN_DON AS HO_TEN_NGUYEN_DON,
                            b.SO_GIAY_TO_NGUYEN_DON AS SO_GIAY_TO_NGUYEN_DON,
                            b.NGAY_SINH_NGUYEN_DON,
                            b.QUOC_TICH_NGUYEN_DON AS QUOC_TICH_NGUYEN_DON,
                            b.HO_TEN_BI_DON AS HO_TEN_BI_DON,            
                            b.SO_GIAY_TO_BI_DON AS SO_GIAY_TO_BI_DON,
                            b.NGAY_SINH_BI_DON,
                            b.QUOC_TICH_BI_DON AS QUOC_TICH_BI_DON,
                            b.TRANG_THAI_TTHN,  
                            b.trangThaiBanGhi,
                            b.GhiChu,
                            DECODE(b.TRANG_THAI_DONGBO,'0','Chưa đồng bộ','Đã đồng bộ') AS TRANGTHAIGUI,
                            TO_CHAR(b.NGAYGUI,'dd/MM/yyyy') AS NGAYGUI,
                             b.TAIKHOANGUI,
                             DECODE(b.NGAYDONGBO, NULL, NULL,TO_CHAR(b.NGAYDONGBO,'dd/MM/yyyy'))  AS NGAYDONGBO,
                             b.KHANGCAOQH,
                             h1.MA_TEN AS DIACHI_NGUYEN_DON,
                             h2.MA_TEN AS DIACHI_BI_DON,
                             B.trangThaiXacThucNguyenDon,
                             B.trangThaiXacThucBiDon,
                             B.maDinhDanhBanAn,
                             B.GIOI_TINH_NGUYEN_DON,
                             B.SO_CMND_NGUYEN_DON,
                             B.GIOI_TINH_BI_DON,
                             B.SO_CMND_BI_DON,
                             B.MADONVINHANBANAN,
                             B.TENDONVINHANBANAN,
                             B.SOGIAYCNKH,
                             B.loaiViec
                        FROM 
                            C06_TOAAN_TINHTRANGHONNHAN B
                                LEFT JOIN AHN_SOTHAM_THULY TL ON TL.DONID = B.DONID
                                left join DM_HANHCHINH h1 on h1.ID=B.NGUYENDON_ID
                                left join DM_HANHCHINH h2 on h2.ID=B.BIDON_ID
                           where B.DON_VI_RA_BAN_AN_ID = v_toaan_id
                            AND (v_KHANGCAOQH is null OR  b.KHANGCAOQH = v_KHANGCAOQH)
                            AND (v_LOAIBAQD is null OR b.LOAI_BAQD = v_LOAIBAQD)
                            AND (v_BAQD_id is null  OR b.BAQD_id=v_BAQD_id)
                            AND (V_LOAIAN_ID is null OR b.LOAIAN_ID = V_LOAIAN_ID)
                            AND (v_Capxx is null OR (v_Capxx = 2 and  b.CAPXX = 'Sơ Thẩm') OR (v_Capxx = 3 and  b.CAPXX = 'Phúc Thẩm') )
                             AND (v_ten_vu_an IS NULL OR FN_CONVERT_TO_VN(UPPER(b.TenVuAn)) LIKE '%'||FN_CONVERT_TO_VN(UPPER(v_ten_vu_an))||'%')
                            AND (v_ma_vu_an IS NULL OR b.MAVUVIEC = v_ma_vu_an)
                            AND (v_bi_can IS NULL --Đương sự
                                      OR FN_CONVERT_TO_VN(UPPER(b.HO_TEN_NGUYEN_DON)) LIKE '%'||FN_CONVERT_TO_VN(UPPER(v_bi_can))||'%'
                                      OR FN_CONVERT_TO_VN(UPPER(b.HO_TEN_BI_DON)) LIKE '%'||FN_CONVERT_TO_VN(UPPER(v_bi_can))||'%'
                                      )
                            AND (v_cccd  IS NULL OR b.SO_GIAY_TO_NGUYEN_DON  = v_cccd OR b.SO_GIAY_TO_BI_DON  = v_cccd)
                            AND (v_so_qd  IS NULL OR b.SO_BAN_AN  = SO_BAN_AN)
                            AND (V_TUNGAY IS NULL OR b.NGAY_RA_BAN_AN  >= V_TUNGAY)
                            AND (V_DENNGAY IS NULL OR b.NGAY_RA_BAN_AN  <= V_DENNGAY)
                            AND (v_toidanh IS NULL  OR ( FN_CONVERT_TO_VN(LOWER(b.TenVuAn)) LIKE  '%'||FN_CONVERT_TO_VN(LOWER(v_toidanh))||'%' ) )--Quan hệ pháp luật tìm quan hệ pháp luật đã được gắn vào tên vụ án
                            AND (v_thuky_id IS NULL 
                                        OR EXISTS(select 'X' from AHN_SoTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=b.DONID) 
                                       OR EXISTS(select 'X' from AHN_PhucTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=b.DONID)
                                        OR EXISTS(SELECT 'X' FROM AHN_DON_THAMPHAN TP WHERE  TP.THUKYID=v_thuky_id and TP.DONID=b.DONID)
                                    )
                    
                           ----Kiem tra cu dung cua tham phan đa day khong
                           AND ( v_thamphan_id is null 
                                OR (B.CAPXX ='Sơ Thẩm' AND  EXISTS(SELECT 'x' FROM AHN_SOTHAM_HDXX TP 
                                        WHERE TP.DONID = B.DONID AND TP.MAVAITRO='THAMPHAN' AND TP.CANBOID = v_thamphan_id ))
                                 OR (B.CAPXX ='Phúc Thẩm' AND  EXISTS(SELECT 'x' FROM AHN_PHUCTHAM_HDXX TP 
                                        WHERE TP.DONID = B.DONID AND TP.MAVAITRO='THAMPHAN' AND TP.CANBOID = v_thamphan_id ))        
                                        )
                           ---Trạng thái đã gửi và chua bị thu hồi ----
                            AND B.STATUS = 1
                            AND B.trangThaiBanGhi != 2
                            
                            ORDER by B.id              
                        )A
                )tt where tt.stt>=MinIndex and tt.stt<=MaxIndex

    ;

END EXT_SEARCH_ALL_DaDongBo;

PROCEDURE EXT_SEARCH_ALL
(  
    V_LOAIAN_ID IN VARCHAR2,
    v_LOAIBAQD in varchar2,
    v_BAQD_id in varchar2,
    v_KHANGCAOQH in varchar2,
    
    v_toaan_id in varchar2,
    v_Capxx in varchar2,
    v_ten_vu_an in varchar2, 
    
    v_toidanh in varchar2, 
    v_ma_vu_an in varchar2, 
    v_bi_can in varchar2,
    v_cccd  in varchar2,     
    v_so_qd in varchar2,
    V_TUNGAY IN VARCHAR2,
    V_DENNGAY IN VARCHAR2,
    v_thamphan_id in varchar2, 
    v_thuky_id in varchar2,
    V_TRANGTHAI_GUI IN varchar2,
    V_NGAYGUI_TU in varchar2,
    V_NGAYGUI_DEN in varchar2,
    
    
    Page_Index in	int,
    Page_Size	in	int,
    curReturn OUT sys_refcursor
)
AS
    TotalItem number;  MinIndex number; MaxIndex number; V_TABLE T_STPT_6LOAIAN;
     
BEGIN	
     
    ---------------------------------------
    MinIndex := Page_Size*(Page_Index - 1) + 1;
    MaxIndex := Page_Index*Page_Size;
    
   OPEN CURRETURN FOR
    SELECT tt.* FROM(
            SELECT  
                ROW_NUMBER() OVER (ORDER BY A.NGAY_RA_BAN_AN desc) STT,
                COUNT(*) OVER () as CountAll,
                A.* FROM (
                    --TH1: Bản án co hieu luc 
                  
                          SELECT 
                                B.DONID,
                                '3' AS LOAIAN_ID,
                                'Hôn nhân gia đình' AS LOAI_AN_TEN,
                                '1' AS LOAIBAQD,
                                B.id as BAQD_ID,
                                TO_CHAR(d.mavuviec)  AS MavuAn,
                                d.tenvuviec as TenVuAn,                            
                                'Sơ Thẩm' as CAPXX,
                                B.SOBANAN AS SO_BAN_AN,
                                TO_CHAR(B.NGAYTUYENAN,'dd/MM/yyyy') AS NGAY_RA_BAN_AN,
                                DECODE(b.ngayhieuluc, NULL, NULL,TO_CHAR(b.ngayhieuluc,'dd/MM/yyyy'))  as NGAY_HIEU_LUC_BA,
                                DECODE(TL.TRUONGHOPTHULY,3,'Thụ lý xét xử lại do GDT hủy',2,'Thụ lý xét xử lại do PT hủy','Thụ lý mới')
                                        ||' - số '|| TL.SOTHULY ||' ngày '|| TO_CHAR(TL.NGAYTHULY,'dd/MM/yyyy')  AS THULY,                                
                                TO_CHAR(B.TOAANID) AS DON_VI_RA_BAN_AN_ID,
                                DM.MA_TEN AS DON_VI_RA_BAN_AN_TEN,
                                null AS NGAY_NHAN_NGUYEN_DON,
                                null AS NGAY_NHAN_BI_DON,
                                NDS.TENDUONGSU AS HO_TEN_NGUYEN_DON,
                                --to_char(ngd.NGAYNHANTONGDAT,'dd/MM/yyyy')  AS NGAY_NHAN_NGUYEN_DON,
                                trim(NDS.SO_CCCD) AS SO_GIAY_TO_NGUYEN_DON,
                                DECODE(TO_CHAR(NDS.NGAYSINH,'dd/MM/yyyy'), '01/01/0001','',TO_CHAR(NDS.NGAYSINH,'dd/MM/yyyy')) AS NGAY_SINH_NGUYEN_DON,
                                h1.MA_TEN AS DIACHI_NGUYEN_DON,
                                QTN.MA AS QUOC_TICH_NGUYEN_DON,
                                --to_char(bd.NGAYNHANTONGDAT,'dd/MM/yyyy')  AS NGAY_NHAN_BI_DON
                                BDS.TENDUONGSU AS HO_TEN_BI_DON,            
                                trim(BDS.SO_CCCD) AS SO_GIAY_TO_BI_DON,
                                DECODE(TO_CHAR(BDS.NGAYSINH,'dd/MM/yyyy'), '01/01/0001','',TO_CHAR(BDS.NGAYSINH,'dd/MM/yyyy')) AS NGAY_SINH_BI_DON,
                                h2.MA_TEN AS DIACHI_BI_DON,
                                QTB.MA AS QUOC_TICH_BI_DON,
                                Decode(B.TK_CHOLYHON,1,'1','3') AS TRANG_THAI_TTHN,  
                                '1' AS trangThaiBanGhi,-- 1.Thêm mới;2.Thu hồi
                                'Thêm mới' AS ghiChu,
                                 b.nguoitao as NGUOITAO,
                                 TO_CHAR(B.ngaytao,'dd/MM/yyyy') as NgayTao,
                                 DECODE(NVL(c.TRANG_THAI_DONGBO,0),'0','Chưa đồng bộ','Đã đồng bộ') AS TRANGTHAIGUI,
                                 TO_CHAR(c.NGAYGUI,'dd/MM/yyyy') AS NGAYGUI,
                                 c.TAIKHOANGUI,
                                 TO_CHAR(c.NGAYDONGBO,'dd/MM/yyyy') AS NGAYDONGBO,
                                 '0' as KHANGCAOQH,
                                 NDS.ID AS NGUYENDON_ID,
                                 BDS.ID AS BIDON_ID,
                                 c.id as C06ID,
                                 NDS.XACTHUC_DLDCQG as ND_XACTHUC_DLDCQG,
                                 BDS.XACTHUC_DLDCQG as BD_XACTHUC_DLDCQG,
                                 NDS.GIOITINH as GIOI_TINH_NGUYENDON,--NDS.GIOITINH = 1 La Nam, = 2 là Nu
                                 NDS.SOCMND as SO_CMND_NGUYEN_DON,
                                 BDS.GIOITINH  as GIOI_TINH_BI_DON,
                                 BDS.SOCMND as SO_CMND_BI_DON,
                                 '' as maDonViNhanBanAn,
                                 '' as tenDonViNhanBanAn,
                                 '' as soGiayCNKH                                 
                            FROM 
                                AHN_SOTHAM_BANAN B
                                INNER JOIN DM_TOAAN DM ON DM.ID = B.TOAANID
                                LEFT JOIN AHN_DON_DUONGSU NDS ON NDS.DONID = B.DONID AND NDS.TUCACHTOTUNG_MA = 'NGUYENDON' AND NDS.ISDAIDIEN = 1                         
                                left join DM_HANHCHINH h1 on h1.ID=NDS.TAMTRUID
                                LEFT JOIN AHN_DON_DUONGSU BDS ON BDS.DONID = B.DONID AND BDS.TUCACHTOTUNG_MA = 'BIDON' AND BDS.ISDAIDIEN = 1                        
                                left join DM_HANHCHINH h2 on h2.ID=BDS.TAMTRUID
                                LEFT JOIN DM_DATAITEM QTN ON QTN.ID = NDS.QUOCTICHID AND QTN.GROUPID = 2
                                LEFT JOIN DM_DATAITEM QTB ON QTB.ID = BDS.QUOCTICHID AND QTB.GROUPID = 2
                                LEFT JOIN AHN_DON D ON D.ID = B.DONID
                                LEFT JOIN AHN_PHUCTHAM_THULY TLPT ON TLPT.DONID = D.ID
                                LEFT JOIN C06_TOAAN_TINHTRANGHONNHAN C ON C.LOAIAN_ID =3 AND C.BAQD_ID = B.ID AND C.LOAI_BAQD = 1 AND c.STATUS = 1 AND c.CAPXX = 'Sơ Thẩm'
                                LEFT JOIN AHN_SOTHAM_THULY TL ON TL.DONID = B.DONID
                            WHERE ( (B.TK_ISCHAPNHAN = 1  AND  B.TK_CHOLYHON = 1) or ( b.tk_iskhongchapnhan =1 and  b.tk_iskhongcongnhanvc =1))
                               --Quoc tich la nguoi viet nam thi kiem tra cccd
                                 AND (NDS.QUOCTICHID !=2 OR (NDS.QUOCTICHID = 2 AND LENGTH(trim(NDS.SO_CCCD))  = 12 ))
                                AND (BDS.QUOCTICHID !=2 OR (BDS.QUOCTICHID = 2 AND LENGTH(trim(BDS.SO_CCCD))  = 12)) 
                                AND TLPT.ID IS NULL
                                -- Ngày hiệu lực của BA hoặc QĐ
                                AND B.ngayhieuluc is not null
                                -- Chua dong bo sang C06--
                                AND  c.id is null AND b.toaanid = v_toaan_id                              
                    UNION   
--               TH2: lấy thông tin bản án Phúc thẩm thỏa mãn điều kiện đẩy đi               
                        SELECT 
                                B.DONID,
                                '3' AS LOAIAN_ID,
                                'Hôn nhân gia đình' AS LOAI_AN_TEN,
                                '1' AS LOAIBAQD,
                                B.id as BAQD_ID,
                                TO_CHAR(d.mavuviec)  AS MavuAn,
                                d.tenvuviec as TenVuAn,                            
                                'Phúc Thẩm' as CAPXX,
                                B.SOBANAN AS SO_BAN_AN,
                                TO_CHAR(B.NGAYTUYENAN,'dd/MM/yyyy') AS NGAY_RA_BAN_AN,
                                DECODE(b.ngayhieuluc, NULL, NULL,TO_CHAR(b.ngayhieuluc,'dd/MM/yyyy'))  as NGAY_HIEU_LUC_BA,
                                DECODE(TL.TRUONGHOPTHULY,3,'Thụ lý xét xử lại do GDT hủy',2,'Thụ lý xét xử lại do PT hủy','Thụ lý mới')
                                        ||' - số '|| TL.SOTHULY ||' ngày '|| TO_CHAR(TL.NGAYTHULY,'dd/MM/yyyy')  AS THULY,
                                TO_CHAR(B.TOAANID) AS DON_VI_RA_BAN_AN_ID,
                                DM.MA_TEN AS DON_VI_RA_BAN_AN_TEN,
                                null AS NGAY_NHAN_NGUYEN_DON,
                                null AS NGAY_NHAN_BI_DON,
                                NDS.TENDUONGSU AS HO_TEN_NGUYEN_DON,
                                --to_char(ngd.NGAYNHANTONGDAT,'dd/MM/yyyy')  AS NGAY_NHAN_NGUYEN_DON,
                                trim(NDS.SO_CCCD) AS SO_GIAY_TO_NGUYEN_DON,
                                DECODE(TO_CHAR(NDS.NGAYSINH,'dd/MM/yyyy'), '01/01/0001','',TO_CHAR(NDS.NGAYSINH,'dd/MM/yyyy')) AS NGAY_SINH_NGUYEN_DON,
                                h1.MA_TEN AS DIACHI_NGUYEN_DON,
                                QTN.MA AS QUOC_TICH_NGUYEN_DON,
                                --to_char(bd.NGAYNHANTONGDAT,'dd/MM/yyyy')  AS NGAY_NHAN_BI_DON
                                BDS.TENDUONGSU AS HO_TEN_BI_DON,            
                                trim(BDS.SO_CCCD) AS SO_GIAY_TO_BI_DON,
                                DECODE(TO_CHAR(BDS.NGAYSINH,'dd/MM/yyyy'), '01/01/0001','',TO_CHAR(BDS.NGAYSINH,'dd/MM/yyyy')) AS NGAY_SINH_BI_DON,
                                 h2.MA_TEN AS DIACHI_BI_DON,
                                QTB.MA AS QUOC_TICH_BI_DON,
                                Decode(B.TK_KETQUA_CHITIET,1,'1','3') AS TRANG_THAI_TTHN,                            
                                '1' AS trangThaiBanGhi,-- 1.Thêm mới;2.Thu hồi
                                'Thêm mới' AS ghiChu,
                                 b.nguoitao as NGUOITAO,
                                 TO_CHAR(B.ngaytao,'dd/MM/yyyy') as NgayTao,
                                 DECODE(NVL(c.TRANG_THAI_DONGBO,0),'0','Chưa đồng bộ','Đã đồng bộ') AS TRANGTHAIGUI,
                                 TO_CHAR(c.NGAYGUI,'dd/MM/yyyy') AS NGAYGUI,
                                 c.TAIKHOANGUI,
                                 TO_CHAR(c.NGAYDONGBO,'dd/MM/yyyy') AS NGAYDONGBO,
                                 '0' as KHANGCAOQH,
                                 NDS.ID AS NGUYENDON_ID,
                                 BDS.ID AS BIDON_ID,
                                 c.id as C06ID,
                                 NDS.XACTHUC_DLDCQG as ND_XACTHUC_DLDCQG,
                                 BDS.XACTHUC_DLDCQG as BD_XACTHUC_DLDCQG,
                                 NDS.GIOITINH as GIOI_TINH_NGUYENDON,--NDS.GIOITINH = 1 La Nam, = 2 là Nu
                                 NDS.SOCMND as SO_CMND_NGUYEN_DON,
                                 BDS.GIOITINH  as GIOI_TINH_BI_DON,
                                 BDS.SOCMND as SO_CMND_BI_DON,
                                 '' as maDonViNhanBanAn,
                                 '' as tenDonViNhanBanAn,
                                 '' as soGiayCNKH
                            FROM 
                                AHN_PHUCTHAM_BANAN B
                                INNER JOIN DM_TOAAN DM ON DM.ID = B.TOAANID
                                LEFT JOIN AHN_DON_DUONGSU NDS ON NDS.DONID = B.DONID AND NDS.TUCACHTOTUNG_MA = 'NGUYENDON' AND NDS.ISDAIDIEN = 1                         
                                left join DM_HANHCHINH h1 on h1.ID=NDS.TAMTRUID
                                LEFT JOIN AHN_DON_DUONGSU BDS ON BDS.DONID = B.DONID AND BDS.TUCACHTOTUNG_MA = 'BIDON' AND BDS.ISDAIDIEN = 1                        
                                left join DM_HANHCHINH h2 on h2.ID=BDS.TAMTRUID
                                LEFT JOIN DM_DATAITEM QTN ON QTN.ID = NDS.QUOCTICHID AND QTN.GROUPID = 2
                                LEFT JOIN DM_DATAITEM QTB ON QTB.ID = BDS.QUOCTICHID AND QTB.GROUPID = 2
                                LEFT JOIN AHN_DON D ON D.ID = B.DONID
                                LEFT JOIN C06_TOAAN_TINHTRANGHONNHAN C ON C.LOAIAN_ID =3 AND C.BAQD_ID = B.ID AND C.LOAI_BAQD = 1 AND c.STATUS = 1 AND c.CAPXX = 'Phúc Thẩm'
                                LEFT JOIN AHN_PHUCTHAM_THULY TL ON TL.DONID = B.DONID
                            WHERE B.TK_KETQUA_CHITIET in (1,3)
                                --Quoc tich la nguoi viet nam thi kiem tra cccd
                                AND (NDS.QUOCTICHID !=2 OR (NDS.QUOCTICHID = 2 AND LENGTH(trim(NDS.SO_CCCD))  = 12 ))
                                AND (BDS.QUOCTICHID !=2 OR (BDS.QUOCTICHID = 2 AND LENGTH(trim(BDS.SO_CCCD))  = 12)) 
    --                          Chua đồng bộ  
                                AND  c.id is null
                                AND b.TOA_GIAIQUYET_ID = v_toaan_id                               
               UNION
--               TH3:  Quyết định sơ thẩm về ly hôn  
                  SELECT 
                                Q.DONID,
                                '3' AS LOAIAN_ID,
                                'Hôn nhân gia đình' AS LOAI_AN_TEN,
                                '2' AS LOAIBAQD,
                                Q.id as BAQD_ID,
                                TO_CHAR(d.mavuviec)  AS MavuAn,
                                d.tenvuviec as TenVuAn,                            
                                'Sơ Thẩm' as CAPXX,
                                Q.SOQD AS SO_BAN_AN,
                                TO_CHAR(Q.NGAYQD,'dd/MM/yyyy') AS NGAY_RA_BAN_AN,
                                DECODE(Q.HIEULUCTU, NULL, NULL,TO_CHAR(Q.HIEULUCTU,'dd/MM/yyyy'))  as NGAY_HIEU_LUC_BA,
                                DECODE(TL.TRUONGHOPTHULY,3,'Thụ lý xét xử lại do GDT hủy',2,'Thụ lý xét xử lại do PT hủy','Thụ lý mới')
                                        ||' - số '|| TL.SOTHULY ||' ngày '|| TO_CHAR(TL.NGAYTHULY,'dd/MM/yyyy')  AS THULY,
                                TO_CHAR(Q.TOAANID) AS DON_VI_RA_BAN_AN_ID,
                                DM.MA_TEN AS DON_VI_RA_BAN_AN_TEN,
                                Null  AS NGAY_NHAN_NGUYEN_DON,
                                Null  AS NGAY_NHAN_BI_DON,
                                NDS.TENDUONGSU AS HO_TEN_NGUYEN_DON,
                                --to_char(ngd.NGAYNHANTONGDAT,'dd/MM/yyyy')  AS NGAY_NHAN_NGUYEN_DON,
                                trim(NDS.SO_CCCD) AS SO_GIAY_TO_NGUYEN_DON,
                                DECODE(TO_CHAR(NDS.NGAYSINH,'dd/MM/yyyy'), '01/01/0001','',TO_CHAR(NDS.NGAYSINH,'dd/MM/yyyy')) AS NGAY_SINH_NGUYEN_DON,
                                h1.MA_TEN AS DIACHI_NGUYEN_DON,
                                QTN.MA AS QUOC_TICH_NGUYEN_DON,
                                
                                BDS.TENDUONGSU AS HO_TEN_BI_DON,            
                                trim(BDS.SO_CCCD) AS SO_GIAY_TO_BI_DON,
                                DECODE(TO_CHAR(BDS.NGAYSINH,'dd/MM/yyyy'), '01/01/0001','',TO_CHAR(BDS.NGAYSINH,'dd/MM/yyyy')) AS NGAY_SINH_BI_DON,
                                h2.MA_TEN AS DIACHI_BI_DON,
                                QTB.MA AS QUOC_TICH_BI_DON,
                                Decode(TK.TK_CHOLYHON,1,'1','3') AS TRANG_THAI_TTHN,                            
                                 '1' AS trangThaiBanGhi,-- 1.Thêm mới;2. Thu hồi
                                'Thêm mới QD' AS ghiChu,
                                 Q.nguoitao as NGUOITAO,
                                 TO_CHAR(Q.ngaytao,'dd/MM/yyyy') as NgayTao,
                                 DECODE(NVL(c.TRANG_THAI_DONGBO,0),'0','Chưa đồng bộ','Đã đồng bộ') AS TRANGTHAIGUI,
                                 TO_CHAR(c.NGAYGUI,'dd/MM/yyyy') AS NGAYGUI,
                                 c.TAIKHOANGUI,
                                 TO_CHAR(c.NGAYDONGBO,'dd/MM/yyyy') AS NGAYDONGBO,
                                 '0' as KHANGCAOQH,
                                 NDS.ID AS NGUYENDON_ID,
                                 BDS.ID AS BIDON_ID,
                                 c.id as C06ID,
                                 NDS.XACTHUC_DLDCQG as ND_XACTHUC_DLDCQG,
                                 BDS.XACTHUC_DLDCQG as BD_XACTHUC_DLDCQG,
                                 NDS.GIOITINH as GIOI_TINH_NGUYENDON,--NDS.GIOITINH = 1 La Nam, = 2 là Nu
                                 NDS.SOCMND as SO_CMND_NGUYEN_DON,
                                 BDS.GIOITINH  as GIOI_TINH_BI_DON,
                                 BDS.SOCMND as SO_CMND_BI_DON,
                                 '' as maDonViNhanBanAn,
                                 '' as tenDonViNhanBanAn,
                                 '' as soGiayCNKH
                            FROM 
                                ahn_sotham_quyetdinh Q
                                INNER JOIN DM_TOAAN DM ON DM.ID = Q.TOAANID
                                LEFT JOIN AHN_DON_DUONGSU NDS ON NDS.DONID = q.DONID AND NDS.TUCACHTOTUNG_MA = 'NGUYENDON' AND NDS.ISDAIDIEN = 1                         
                                left join DM_HANHCHINH h1 on h1.ID=NDS.TAMTRUID
                                LEFT JOIN AHN_DON_DUONGSU BDS ON BDS.DONID = q.DONID AND BDS.TUCACHTOTUNG_MA = 'BIDON' AND BDS.ISDAIDIEN = 1                        
                                left join DM_HANHCHINH h2 on h2.ID=BDS.TAMTRUID
                                LEFT JOIN DM_DATAITEM QTN ON QTN.ID = NDS.QUOCTICHID AND QTN.GROUPID = 2
                                LEFT JOIN DM_DATAITEM QTB ON QTB.ID = BDS.QUOCTICHID AND QTB.GROUPID = 2
                                LEFT JOIN AHN_DON D ON D.ID = Q.DONID
                                LEFT JOIN AHN_PHUCTHAM_THULY TLPT ON TLPT.DONID = D.ID
                                LEFT JOIN C06_TOAAN_TINHTRANGHONNHAN C ON C.LOAIAN_ID =3 AND C.BAQD_ID = Q.ID AND C.LOAI_BAQD = 2 AND c.STATUS = 1  AND c.CAPXX = 'Sơ Thẩm'
                                LEFT JOIN TK_SOTHAM_QUYETDINH TK ON TK.QUYETDINHID = Q.ID AND TK.LOAIAN = 3
                                 LEFT JOIN AHN_SOTHAM_THULY TL ON TL.DONID = Q.DONID
                            WHERE ((TK.TK_ISCHAPNHAN = 1  AND  TK.TK_CHOLYHON = 1)  or ( TK.tk_iskhongchapnhan =1 and  TK.tk_iskhongcongnhanvc =1))                               
                                --Quoc tich la nguoi viet nam thi kiem tra cccd
                                AND (NDS.QUOCTICHID !=2 OR (NDS.QUOCTICHID = 2 AND LENGTH(trim(NDS.SO_CCCD))  = 12 ))
                                AND (BDS.QUOCTICHID !=2 OR (BDS.QUOCTICHID = 2 AND LENGTH(trim(BDS.SO_CCCD))  = 12)) 
                                And Q.HIEULUCTU is not null
    --                          Chưa đồng bộ  
                                AND  c.id is null
                                AND TLPT.ID IS NULL
                                AND Q.toaanid = v_toaan_id  
                    UNION    
  --               TH4: lấy thông tin Quyết định Phúc thẩm
                        SELECT q.DONID,
                                '3' AS LOAIAN_ID,
                                'Hôn nhân gia đình' AS LOAI_AN_TEN,
                                '2' AS LOAIBAQD,
                                q.id as BAQD_ID,
                                TO_CHAR(d.mavuviec)  AS MavuAn,
                                d.tenvuviec as TenVuAn,                            
                                'Phúc Thẩm' as CAPXX,
                                q.SOQD AS SO_BAN_AN,
                                TO_CHAR(q.NGAYQD,'dd/MM/yyyy') AS NGAY_RA_BAN_AN,
                                DECODE(q.NGAYQD, NULL, NULL,TO_CHAR(q.NGAYQD,'dd/MM/yyyy'))  as NGAY_HIEU_LUC_BA,
                                DECODE(TL.TRUONGHOPTHULY,998,'Giám đốc thẩm hủy để xét xử lại phúc thẩm'
                                                        ,269,'Do có kháng nghị phúc thẩm'
                                                        ,268,'Do có kháng cáo và kháng nghị phúc thẩm'
                                                        ,'Do có kháng cáo phúc thẩm')
                                        ||' - số '|| TL.SOTHULY ||' ngày '|| TO_CHAR(TL.NGAYTHULY,'dd/MM/yyyy')  AS THULY,
                                TO_CHAR(q.TOAANID) AS DON_VI_RA_BAN_AN_ID,
                                DM.MA_TEN AS DON_VI_RA_BAN_AN_TEN,
                                NULL  AS NGAY_NHAN_NGUYEN_DON,
                                NULL  AS NGAY_NHAN_BI_DON,
                                NDS.TENDUONGSU AS HO_TEN_NGUYEN_DON,                                
                                trim(NDS.SO_CCCD) AS SO_GIAY_TO_NGUYEN_DON,
                                DECODE(TO_CHAR(NDS.NGAYSINH,'dd/MM/yyyy'), '01/01/0001','',TO_CHAR(NDS.NGAYSINH,'dd/MM/yyyy')) AS NGAY_SINH_NGUYEN_DON,
                                h1.MA_TEN AS DIACHI_NGUYEN_DON,
                                QTN.MA AS QUOC_TICH_NGUYEN_DON,
                                BDS.TENDUONGSU AS HO_TEN_BI_DON,            
                                trim(BDS.SO_CCCD) AS SO_GIAY_TO_BI_DON,
                                DECODE(TO_CHAR(BDS.NGAYSINH,'dd/MM/yyyy'), '01/01/0001','',TO_CHAR(BDS.NGAYSINH,'dd/MM/yyyy')) AS NGAY_SINH_BI_DON,
                                h2.MA_TEN AS DIACHI_BI_DON,
                                QTB.MA AS QUOC_TICH_BI_DON,
                                Decode(TK.TK_KETQUA_CHITIET,1,'1','3') AS TRANG_THAI_TTHN,                            
                                '1' AS trangThaiBanGhi,-- 1.Thêm mới;2.	Thu hồi
                                'Thêm mới' AS ghiChu,
                                 q.nguoitao as NGUOITAO,
                                 TO_CHAR(q.ngaytao,'dd/MM/yyyy') as NgayTao,
                                 DECODE(NVL(c.TRANG_THAI_DONGBO,0),'0','Chưa đồng bộ','Đã đồng bộ') AS TRANGTHAIGUI,
                                 TO_CHAR(c.NGAYGUI,'dd/MM/yyyy') AS NGAYGUI,
                                 c.TAIKHOANGUI,
                                 TO_CHAR(c.NGAYDONGBO,'dd/MM/yyyy') AS NGAYDONGBO,
                                 '0' as KHANGCAOQH,
                                 NDS.ID AS NGUYENDON_ID,
                                 BDS.ID AS BIDON_ID,
                                 c.id as C06ID,
                                 NDS.XACTHUC_DLDCQG as ND_XACTHUC_DLDCQG,
                                 BDS.XACTHUC_DLDCQG as BD_XACTHUC_DLDCQG,
                                 NDS.GIOITINH as GIOI_TINH_NGUYENDON,--NDS.GIOITINH = 1 La Nam, = 2 là Nu
                                 NDS.SOCMND as SO_CMND_NGUYEN_DON,
                                 BDS.GIOITINH  as GIOI_TINH_BI_DON,
                                 BDS.SOCMND as SO_CMND_BI_DON,
                                 '' as maDonViNhanBanAn,
                                 '' as tenDonViNhanBanAn,
                                 '' as soGiayCNKH
                            FROM 
                                 AHN_PHUCTHAM_QUYETDINH q
                                LEFT JOIN TK_PHUCTHAM_QUYETDINH TK ON TK.QUYETDINHID = q.ID
                                INNER JOIN DM_TOAAN DM ON DM.ID = q.TOAANID
                                 LEFT JOIN AHN_DON_DUONGSU NDS ON NDS.DONID = q.DONID AND NDS.TUCACHTOTUNG_MA = 'NGUYENDON' AND NDS.ISDAIDIEN = 1                         
                                left join DM_HANHCHINH h1 on h1.ID=NDS.TAMTRUID
                                LEFT JOIN AHN_DON_DUONGSU BDS ON BDS.DONID = q.DONID AND BDS.TUCACHTOTUNG_MA = 'BIDON' AND BDS.ISDAIDIEN = 1                        
                                left join DM_HANHCHINH h2 on h2.ID=BDS.TAMTRUID
                                LEFT JOIN DM_DATAITEM QTN ON QTN.ID = NDS.QUOCTICHID AND QTN.GROUPID = 2
                                LEFT JOIN DM_DATAITEM QTB ON QTB.ID = BDS.QUOCTICHID AND QTB.GROUPID = 2
                                LEFT JOIN AHN_DON D ON D.ID = q.DONID
                                LEFT JOIN C06_TOAAN_TINHTRANGHONNHAN C ON C.LOAIAN_ID =3 AND C.BAQD_ID = q.ID AND C.LOAI_BAQD = 2 AND c.STATUS = 1 AND c.CAPXX = 'Phúc Thẩm'
                                LEFT JOIN AHN_SOTHAM_THULY TL ON TL.DONID = Q.DONID
                            WHERE TK.TK_KETQUA_CHITIET in (1,3)
                                --Quoc tich la nguoi viet nam thi kiem tra cccd
                                AND (NDS.QUOCTICHID !=2 OR (NDS.QUOCTICHID = 2 AND LENGTH(trim(NDS.SO_CCCD))  = 12 ))
                                AND (BDS.QUOCTICHID !=2 OR (BDS.QUOCTICHID = 2 AND LENGTH(trim(BDS.SO_CCCD))  = 12))                              
                                -- Đã đồng bộ  
                                AND  c.id is null AND q.toaanid = v_toaan_id                                
                        )A
                     where (v_KHANGCAOQH is null OR  A.KHANGCAOQH = v_KHANGCAOQH)
                        AND (v_LOAIBAQD is null OR A.LOAIBAQD = v_LOAIBAQD)
                        AND (v_BAQD_id is null  OR A.BAQD_id=v_BAQD_id)
                        AND (V_LOAIAN_ID is null OR A.LOAIAN_ID = V_LOAIAN_ID)
                        AND (v_Capxx is null OR (v_Capxx = 2 and  A.CAPXX = 'Sơ Thẩm') OR (v_Capxx = 3 and  A.CAPXX = 'Phúc Thẩm') )
                        AND (v_ten_vu_an IS NULL OR FN_CONVERT_TO_VN(UPPER(A.TenVuAn)) LIKE '%'||FN_CONVERT_TO_VN(UPPER(v_ten_vu_an))||'%')
                        AND (v_ma_vu_an IS NULL OR A.MavuAn = v_ma_vu_an)
                         AND (v_bi_can IS NULL --Đương sự
                                          OR FN_CONVERT_TO_VN(UPPER(A.HO_TEN_NGUYEN_DON)) LIKE '%'||FN_CONVERT_TO_VN(UPPER(v_bi_can))||'%'
                                          OR FN_CONVERT_TO_VN(UPPER(A.HO_TEN_BI_DON)) LIKE '%'||FN_CONVERT_TO_VN(UPPER(v_bi_can))||'%'
                                          )
                        AND (v_cccd  IS NULL OR A.SO_GIAY_TO_NGUYEN_DON  = v_cccd OR A.SO_GIAY_TO_BI_DON  = v_cccd)
                        AND (v_so_qd  IS NULL OR A.SO_BAN_AN  = v_so_qd)
                        AND (V_TUNGAY IS NULL OR A.NGAY_RA_BAN_AN  >= V_TUNGAY)
                        AND (V_DENNGAY IS NULL OR A.NGAY_RA_BAN_AN  <= V_DENNGAY)
                        AND (v_toidanh IS NULL  OR ( FN_CONVERT_TO_VN(LOWER(A.TenVuAn)) LIKE  '%'||FN_CONVERT_TO_VN(LOWER(v_toidanh))||'%' ) )--Quan hệ pháp luật tìm quan hệ pháp luật đã được gắn vào tên vụ án
                        AND (v_thuky_id IS NULL 
                                    OR EXISTS(select 'X' from AHN_SoTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=A.DONID) 
                                   OR EXISTS(select 'X' from AHN_PhucTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=A.DONID)
                                    OR EXISTS(SELECT 'X' FROM AHN_DON_THAMPHAN TP WHERE  TP.THUKYID=v_thuky_id and TP.DONID=A.DONID)
                                )
                        
                        AND ( v_thamphan_id is null 
                                    OR (A.CAPXX ='Sơ Thẩm' AND  EXISTS(SELECT 'x' FROM AHN_SOTHAM_HDXX TP 
                                            WHERE TP.DONID = A.DONID AND TP.MAVAITRO='THAMPHAN' AND TP.CANBOID = v_thamphan_id ))
                                     OR (A.CAPXX ='Phúc Thẩm' AND  EXISTS(SELECT 'x' FROM AHN_PHUCTHAM_HDXX TP 
                                            WHERE TP.DONID = A.DONID AND TP.MAVAITRO='THAMPHAN' AND TP.CANBOID = v_thamphan_id ))        
                                            )
                )tt where tt.stt>=MinIndex and tt.stt<=MaxIndex
         ;
END EXT_SEARCH_ALL;

PROCEDURE AHN_TONGDAT_BA_TTHN
(
    V_TUNGAY IN DATE,
    V_DENNGAY IN DATE,
    CURRETURN OUT SYS_REFCURSOR
) IS
    L_COUNT NUMBER;
    L_BLOB       BLOB;
    L_FILENAME   VARCHAR2 (200);

     MININDEX	NUMBER;V_LOAITOA VARCHAR2(150):=NULL; VV_DATE_FROM VARCHAR2(150):=NULL;VV_DATE_TO VARCHAR2(150):=NULL;
      MAXINDEX	NUMBER;VAR_ARRSX  VARCHAR2(250); V_EXPORT_TEXT CLOB; 
      V_CURSOR SYS_REFCURSOR;V_STT NUMBER:=0;

      L_DATE_FROM  DATE;
    L_MALOAITB VARCHAR2(100);
    V_CURSOR_PDF SYS_REFCURSOR;
BEGIN  

  OPEN CURRETURN FOR
    SELECT A.* FROM (
        --TH1: Bản án không có kháng cao kháng nghi
              SELECT 
                    TO_CHAR(B.ID)  AS ID_REF,
                    B.SOBANAN AS SO_BAN_AN,
                    TO_CHAR(B.NGAYTUYENAN,'dd/MM/yyyy') AS NGAY_RA_BAN_AN,
                   Decode(b.NGAYHIEULUC,null,null, TO_CHAR(b.NGAYHIEULUC,'dd/MM/yyyy') ) AS NGAY_HIEU_LUC_BA,
                    TO_CHAR(B.TOAANID) AS DON_VI_RA_BAN_AN_ID,
                    DM.MA_TEN AS DON_VI_RA_BAN_AN_TEN,
                    TO_CHAR(NGD.NGAYNHANTONGDAT,'dd/MM/yyyy')  AS NGAY_NHAN_NGUYEN_DON,
                    TO_CHAR(BD.NGAYNHANTONGDAT,'dd/MM/yyyy')  AS NGAY_NHAN_BI_DON,
                    NDS.TENDUONGSU AS HO_TEN_NGUYEN_DON,
                    --to_char(ngd.NGAYNHANTONGDAT,'dd/MM/yyyy')  AS NGAY_NHAN_NGUYEN_DON,
                    NDS.SO_CCCD AS SO_GIAY_TO_NGUYEN_DON,
                    DECODE(TO_CHAR(NDS.NGAYSINH,'dd/MM/yyyy'), '01/01/0001','',TO_CHAR(NDS.NGAYSINH,'dd/MM/yyyy')) AS NGAY_SINH_NGUYEN_DON,
                    QTN.TEN AS QUOC_TICH_NGUYEN_DON,
                    --to_char(bd.NGAYNHANTONGDAT,'dd/MM/yyyy')  AS NGAY_NHAN_BI_DON
                    BDS.TENDUONGSU AS HO_TEN_BI_DON,            
                    BDS.SO_CCCD AS SO_GIAY_TO_BI_DON,
                    DECODE(TO_CHAR(BDS.NGAYSINH,'dd/MM/yyyy'), '01/01/0001','',TO_CHAR(BDS.NGAYSINH,'dd/MM/yyyy')) AS NGAY_SINH_BI_DON,
                    QTB.TEN AS QUOC_TICH_BI_DON,
                    --1.Ly hôn;2.Huỷ BA/QĐ ly hôn (sử dụng cho trường hợp cập nhật thông tin); 3.Không là vợ chồng;
                    CASE 
                       WHEN B.TK_ISCHAPNHAN = 1  AND  B.TK_CHOLYHON = 1 THEN '1' --1.Ly hôn;
                       WHEN b.tk_iskhongchapnhan =1 and  b.tk_iskhongcongnhanvc =1 THEN '3' --3.Không là vợ chồng
                    END AS TRANG_THAI_TTHN,
                    '1' AS trangThaiBanGhi,-- 1.Thêm mới;2.	Thu hồi
                    'Thêm mới' AS ghiChu,
                    --Loai An
                    '3' AS PHAN_LOAI
                FROM 
                    AHN_SOTHAM_BANAN B
                    INNER JOIN DM_TOAAN DM ON DM.ID = B.TOAANID
                    INNER JOIN AHN_TONGDAT TD ON TD.DONID = B.DONID
                    INNER JOIN AHN_TONGDAT_DOITUONG NGD ON TD.ID = NGD.TONGDATID
                    INNER JOIN AHN_TONGDAT_DOITUONG BD ON TD.ID = BD.TONGDATID
                    INNER JOIN AHN_DON_DUONGSU NDS ON NGD.DUONGSUID = NDS.ID
                    INNER JOIN AHN_DON_DUONGSU BDS ON BD.DUONGSUID = BDS.ID
                    LEFT JOIN DM_DATAITEM QTN ON QTN.ID = NDS.QUOCTICHID AND QTN.GROUPID = 2
                    LEFT JOIN DM_DATAITEM QTB ON QTB.ID = BDS.QUOCTICHID AND QTB.GROUPID = 2
                WHERE 
                    ( (B.TK_ISCHAPNHAN = 1  AND  B.TK_CHOLYHON = 1) or ( b.tk_iskhongchapnhan =1 and  b.tk_iskhongcongnhanvc =1))
                    AND NDS.TUCACHTOTUNG_MA = 'NGUYENDON'
                    AND NDS.ISDAIDIEN = 1
                    AND BDS.TUCACHTOTUNG_MA = 'BIDON'
                    AND BDS.ISDAIDIEN =  1
                    --Quoc tich la nguoi viet nam thi kiem tra cccd
                    AND (NDS.QUOCTICHID !=2 OR (NDS.QUOCTICHID = 2 AND LENGTH(NDS.SO_CCCD)  = 12 ))
                    AND (BDS.QUOCTICHID !=2 OR (BDS.QUOCTICHID = 2 AND LENGTH(BDS.SO_CCCD)  = 12)) 
                     -- Cả nguyên đơn và bị đơn đã nhận tống đạt
                    AND NGD.NGAYNHANTONGDAT IS NOT NULL
                    AND BD.NGAYNHANTONGDAT IS NOT NULL
                      -- So sánh ngày nhận tống đạt
                    AND GREATEST(NGD.NGAYNHANTONGDAT, BD.NGAYNHANTONGDAT) + 30 < SYSDATE
                     AND GREATEST(NGD.NGAYNHANTONGDAT_SYS, BD.NGAYNHANTONGDAT_SYS) BETWEEN V_TUNGAY AND V_DENNGAY

            -- Không có kháng cáo OR kháng nghị 
                    AND (
                        --KHong co khang cao va khang nghi
                            NOT EXISTS (
                                SELECT 1
                                FROM AHN_SOTHAM_KHANGCAO KC
                                WHERE (KC.DUONGSUID = NDS.ID OR KC.DUONGSUID = BDS.ID)
                            )
                            OR NOT EXISTS (
                                SELECT 1
                                FROM AHN_SOTHAM_KHANGNGHI KN
                                WHERE KN.DONID = B.DONID
                            )
                        )
                -- TH2: Các bản án có kháng cáo kháng nghị và có ban an phuc tham co tieu chi thong ke la ly hon
                -- Khong can quan tam den nhan tong dat hay chua 
                UNION
                        SELECT 
                            TO_CHAR(B.ID) AS ID_REF,
                            B.SOBANAN AS SO_BAN_AN,
                            TO_CHAR(B.NGAYTUYENAN,'dd/MM/yyyy') AS NGAY_RA_BAN_AN,
                            Decode(b.NGAYHIEULUC,null,null, TO_CHAR(b.NGAYHIEULUC,'dd/MM/yyyy') ) AS NGAY_HIEU_LUC_BA,
                            TO_CHAR(B.TOAANID) AS DON_VI_RA_BAN_AN_ID,
                            DM.MA_TEN AS DON_VI_RA_BAN_AN_TEN,
                            TO_CHAR(NGD.NGAYNHANTONGDAT,'dd/MM/yyyy')  AS NGAY_NHAN_NGUYEN_DON,
                            TO_CHAR(BD.NGAYNHANTONGDAT,'dd/MM/yyyy')  AS NGAY_NHAN_BI_DON,
                            NDS.TENDUONGSU AS HO_TEN_NGUYEN_DON,
                            --to_char(ngd.NGAYNHANTONGDAT,'dd/MM/yyyy')  AS NGAY_NHAN_NGUYEN_DON,
                            NDS.SO_CCCD AS SO_GIAY_TO_NGUYEN_DON,
                            DECODE(TO_CHAR(NDS.NGAYSINH,'dd/MM/yyyy'), '01/01/0001','',TO_CHAR(NDS.NGAYSINH,'dd/MM/yyyy')) AS NGAY_SINH_NGUYEN_DON,
                            QTN.TEN AS QUOC_TICH_NGUYEN_DON,
                            --to_char(bd.NGAYNHANTONGDAT,'dd/MM/yyyy')  AS NGAY_NHAN_BI_DON
                            BDS.TENDUONGSU AS HO_TEN_BI_DON,            
                            BDS.SO_CCCD AS SO_GIAY_TO_BI_DON,
                            DECODE(TO_CHAR(BDS.NGAYSINH,'dd/MM/yyyy'), '01/01/0001','',TO_CHAR(BDS.NGAYSINH,'dd/MM/yyyy')) AS NGAY_SINH_BI_DON,
                            QTB.TEN AS QUOC_TICH_BI_DON,
                            --1.Ly hôn;2.Huỷ BA/QĐ ly hôn (sử dụng cho trường hợp cập nhật thông tin); 3.Không là vợ chồng;
                            CASE 
                               WHEN B.TK_ISCHAPNHAN = 1  AND  B.TK_CHOLYHON = 1 THEN '1' --1.Ly hôn;
                               WHEN b.tk_iskhongchapnhan =1 and  b.tk_iskhongcongnhanvc =1 THEN '3' --3.Không là vợ chồng
                            END AS TRANG_THAI_TTHN,
                            '1' AS trangThaiBanGhi,-- 1.Thêm mới;2.	Thu hồi
                            'Thêm mới' AS ghiChu,
                            --Loai An
                            '3' AS PHAN_LOAI

                        FROM 
                            AHN_SOTHAM_BANAN B
                            INNER JOIN DM_TOAAN DM ON DM.ID = B.TOAANID
                            INNER JOIN AHN_TONGDAT TD ON TD.DONID = B.DONID
                            INNER JOIN AHN_TONGDAT_DOITUONG NGD ON TD.ID = NGD.TONGDATID
                            INNER JOIN AHN_DON_DUONGSU NDS ON NGD.DUONGSUID = NDS.ID
                            INNER JOIN AHN_TONGDAT_DOITUONG BD ON TD.ID = BD.TONGDATID
                            INNER JOIN AHN_DON_DUONGSU BDS ON BD.DUONGSUID = BDS.ID
                            LEFT JOIN DM_DATAITEM QTN ON QTN.ID = NDS.QUOCTICHID AND QTN.GROUPID = 2
                            LEFT JOIN DM_DATAITEM QTB ON QTB.ID = BDS.QUOCTICHID AND QTB.GROUPID = 2
                        WHERE 
                            ( (B.TK_ISCHAPNHAN = 1  AND  B.TK_CHOLYHON = 1) or ( b.tk_iskhongchapnhan =1 and  b.tk_iskhongcongnhanvc =1))
                            AND NDS.TUCACHTOTUNG_MA = 'NGUYENDON'
                            AND NDS.ISDAIDIEN = 1
                            AND BDS.TUCACHTOTUNG_MA = 'BIDON'
                            AND BDS.ISDAIDIEN =  1
                            --Quoc tich la nguoi viet nam thi kiem tra cccd
                            AND (NDS.QUOCTICHID !=2 OR (NDS.QUOCTICHID = 2 AND LENGTH(NDS.SO_CCCD)  = 12 ))
                            AND (BDS.QUOCTICHID !=2 OR (BDS.QUOCTICHID = 2 AND LENGTH(BDS.SO_CCCD)  = 12)) 

             -- có BA/QD phúc thẩm thi khong quan tam den ket qua chi quan tam den tk ly hôn hoạc khong cong nhan vo chong
                            AND (
                                    EXISTS (
                                        SELECT 1
                                        FROM AHN_PHUCTHAM_BANAN PB
                                        WHERE PB.DONID = B.DONID
                                           AND  PB.TK_KETQUA_CHITIET in (1,3)
                                          --AND PB.KETQUAPHUCTHAMID IN (1, 81)
                                    )
                                    OR EXISTS (
                                        SELECT 1
                                        FROM AHN_PHUCTHAM_QUYETDINH PQ
                                            LEFT JOIN TK_PHUCTHAM_QUYETDINH TK ON TK.QUYETDINHID = PQ.ID
                                        WHERE PQ.DONID = B.DONID
                                        AND  TK.TK_KETQUA_CHITIET in (1,3)
                                         -- AND PQ.QUYETDINHID IN (145, 146)
                                    )
                                 )

                UNION
                -- TH3: Quyet dinh Có Cong nhan của dung su Cho Ly Hon
                    SELECT 
                        TO_CHAR(Q.ID)  AS ID_REF,
                        Q.SOQD AS SO_BAN_AN,
                        TO_CHAR(Q.NGAYQD,'dd/MM/yyyy') AS NGAY_RA_BAN_AN,
                        Decode(q.HIEULUCTU,null,null, TO_CHAR(q.HIEULUCTU,'dd/MM/yyyy') )  AS NGAY_HIEU_LUC_BA,
                        TO_CHAR(Q.TOAANID) AS DON_VI_RA_BAN_AN_ID,
                        DM.MA_TEN AS DON_VI_RA_BAN_AN_TEN,
                        TO_CHAR(NGD.NGAYNHANTONGDAT,'dd/MM/yyyy')  AS NGAY_NHAN_NGUYEN_DON,
                        TO_CHAR(BD.NGAYNHANTONGDAT,'dd/MM/yyyy')  AS NGAY_NHAN_BI_DON,
                        NDS.TENDUONGSU AS HO_TEN_NGUYEN_DON,
                        --to_char(ngd.NGAYNHANTONGDAT,'dd/MM/yyyy')  AS NGAY_NHAN_NGUYEN_DON,
                        NDS.SO_CCCD AS SO_GIAY_TO_NGUYEN_DON,
                         DECODE(TO_CHAR(NDS.NGAYSINH,'dd/MM/yyyy'), '01/01/0001','',TO_CHAR(NDS.NGAYSINH,'dd/MM/yyyy')) AS NGAY_SINH_NGUYEN_DON,
                        QTN.TEN AS QUOC_TICH_NGUYEN_DON,
                        --to_char(bd.NGAYNHANTONGDAT,'dd/MM/yyyy')  AS NGAY_NHAN_BI_DON
                        BDS.TENDUONGSU AS HO_TEN_BI_DON,            
                        BDS.SO_CCCD AS SO_GIAY_TO_BI_DON,
                        DECODE(TO_CHAR(BDS.NGAYSINH,'dd/MM/yyyy'), '01/01/0001','',TO_CHAR(BDS.NGAYSINH,'dd/MM/yyyy')) AS NGAY_SINH_BI_DON,
                        QTB.TEN AS QUOC_TICH_BI_DON,
                         --1.Ly hôn;2.Huỷ BA/QĐ ly hôn (sử dụng cho trường hợp cập nhật thông tin); 3.Không là vợ chồng;
                        '1' AS TRANG_THAI_TTHN,
                        '1' AS trangThaiBanGhi,-- 1.Thêm mới;2.	Thu hồi
                        'Thêm mới' AS ghiChu,
                        --Loai An
                        '3' AS PHAN_LOAI
                    FROM 
                        AHN_SOTHAM_QUYETDINH Q
                        INNER JOIN DM_TOAAN DM ON DM.ID = Q.TOAANID
                        INNER JOIN AHN_TONGDAT TD ON TD.DONID = Q.DONID
                        INNER JOIN AHN_TONGDAT_DOITUONG NGD ON TD.ID = NGD.TONGDATID
                        INNER JOIN AHN_DON_DUONGSU NDS ON NGD.DUONGSUID = NDS.ID
                        INNER JOIN AHN_TONGDAT_DOITUONG BD ON TD.ID = BD.TONGDATID
                        INNER JOIN AHN_DON_DUONGSU BDS ON BD.DUONGSUID = BDS.ID
                        LEFT JOIN DM_DATAITEM QTN ON QTN.ID = NDS.QUOCTICHID AND QTN.GROUPID = 2
                        LEFT JOIN DM_DATAITEM QTB ON QTB.ID = BDS.QUOCTICHID AND QTB.GROUPID = 2
                    WHERE 
                        EXISTS(SELECT 'x' FROM TK_SOTHAM_QUYETDINH 
                                    WHERE  (TK_ISCHAPNHAN = 1  AND  TK_CHOLYHON = 1) 
                                        AND QUYETDINHID = Q.ID AND LOAIAN = 3)
                        AND NDS.TUCACHTOTUNG_MA = 'NGUYENDON'
                        AND NDS.ISDAIDIEN = 1
                        AND BDS.TUCACHTOTUNG_MA = 'BIDON'
                        AND BDS.ISDAIDIEN =  1
                        --41 40-DS. Quyết định công nhận thuận tình ly hôn và sự thỏa thuận của các đương sự
                        --434 31-VDS. Quyết định công nhận thuận tình ly hôn và sự thỏa thuận của các đương sự
--                        AND Q.QUYETDINHID IN (434,41) Khong quan tam loại quyet dinh chỉ quan tam den thong ke Phuong bao
                        --Quoc tich la nguoi viet nam thi kiem tra cccd
                        AND (NDS.QUOCTICHID !=2 OR (NDS.QUOCTICHID = 2 AND LENGTH(NDS.SO_CCCD)  = 12 ))
                        AND (BDS.QUOCTICHID !=2 OR (BDS.QUOCTICHID = 2 AND LENGTH(BDS.SO_CCCD)  = 12)) 
                         -- Cả nguyên đơn và bị đơn đã nhận tống đạt
                        AND NGD.NGAYNHANTONGDAT IS NOT NULL
                        AND BD.NGAYNHANTONGDAT IS NOT NULL
                          -- So sánh ngày nhận tống đạt
                        AND GREATEST(NGD.NGAYNHANTONGDAT, BD.NGAYNHANTONGDAT) + 30 < SYSDATE
                        AND GREATEST(NGD.NGAYNHANTONGDAT_SYS, BD.NGAYNHANTONGDAT_SYS) BETWEEN V_TUNGAY AND V_DENNGAY
                 UNION
                -- TH3: Quyet dinh Có Cong nhan của dung su Khong cong nhan vo chong
                    SELECT 
                        TO_CHAR(Q.ID)  AS ID_REF,
                        Q.SOQD AS SO_BAN_AN,
                        TO_CHAR(Q.NGAYQD,'dd/MM/yyyy') AS NGAY_RA_BAN_AN,
                        Decode(q.HIEULUCTU,null,null, TO_CHAR(q.HIEULUCTU,'dd/MM/yyyy') ) AS NGAY_HIEU_LUC_BA,
                        TO_CHAR(Q.TOAANID) AS DON_VI_RA_BAN_AN_ID,
                        DM.MA_TEN AS DON_VI_RA_BAN_AN_TEN,
                        TO_CHAR(NGD.NGAYNHANTONGDAT,'dd/MM/yyyy')  AS NGAY_NHAN_NGUYEN_DON,
                        TO_CHAR(BD.NGAYNHANTONGDAT,'dd/MM/yyyy')  AS NGAY_NHAN_BI_DON,
                        NDS.TENDUONGSU AS HO_TEN_NGUYEN_DON,
                        --to_char(ngd.NGAYNHANTONGDAT,'dd/MM/yyyy')  AS NGAY_NHAN_NGUYEN_DON,
                        NDS.SO_CCCD AS SO_GIAY_TO_NGUYEN_DON,
                         DECODE(TO_CHAR(NDS.NGAYSINH,'dd/MM/yyyy'), '01/01/0001','',TO_CHAR(NDS.NGAYSINH,'dd/MM/yyyy')) AS NGAY_SINH_NGUYEN_DON,
                        QTN.TEN AS QUOC_TICH_NGUYEN_DON,
                        --to_char(bd.NGAYNHANTONGDAT,'dd/MM/yyyy')  AS NGAY_NHAN_BI_DON
                        BDS.TENDUONGSU AS HO_TEN_BI_DON,            
                        BDS.SO_CCCD AS SO_GIAY_TO_BI_DON,
                        DECODE(TO_CHAR(BDS.NGAYSINH,'dd/MM/yyyy'), '01/01/0001','',TO_CHAR(BDS.NGAYSINH,'dd/MM/yyyy')) AS NGAY_SINH_BI_DON,
                        QTB.TEN AS QUOC_TICH_BI_DON,
                         --1.Ly hôn;2.Huỷ BA/QĐ ly hôn (sử dụng cho trường hợp cập nhật thông tin); 3.Không là vợ chồng;
                        '3' AS TRANG_THAI_TTHN,
                        '1' AS trangThaiBanGhi,-- 1.Thêm mới;2.	Thu hồi
                        'Thêm mới' AS ghiChu,
                        --Loai An
                        '3' AS PHAN_LOAI
                    FROM 
                        AHN_SOTHAM_QUYETDINH Q
                        INNER JOIN DM_TOAAN DM ON DM.ID = Q.TOAANID
                        INNER JOIN AHN_TONGDAT TD ON TD.DONID = Q.DONID
                        INNER JOIN AHN_TONGDAT_DOITUONG NGD ON TD.ID = NGD.TONGDATID
                        INNER JOIN AHN_DON_DUONGSU NDS ON NGD.DUONGSUID = NDS.ID
                        INNER JOIN AHN_TONGDAT_DOITUONG BD ON TD.ID = BD.TONGDATID
                        INNER JOIN AHN_DON_DUONGSU BDS ON BD.DUONGSUID = BDS.ID
                        LEFT JOIN DM_DATAITEM QTN ON QTN.ID = NDS.QUOCTICHID AND QTN.GROUPID = 2
                        LEFT JOIN DM_DATAITEM QTB ON QTB.ID = BDS.QUOCTICHID AND QTB.GROUPID = 2
                    WHERE 
                        EXISTS(SELECT 'x' FROM TK_SOTHAM_QUYETDINH 
                                    WHERE  ( tk_iskhongchapnhan =1 and  tk_iskhongcongnhanvc =1)
                                        AND QUYETDINHID = Q.ID AND LOAIAN = 3)
                        AND NDS.TUCACHTOTUNG_MA = 'NGUYENDON'
                        AND NDS.ISDAIDIEN = 1
                        AND BDS.TUCACHTOTUNG_MA = 'BIDON'
                        AND BDS.ISDAIDIEN =  1
                        --41 40-DS. Quyết định công nhận thuận tình ly hôn và sự thỏa thuận của các đương sự
                        --434 31-VDS. Quyết định công nhận thuận tình ly hôn và sự thỏa thuận của các đương sự
--                        AND Q.QUYETDINHID IN (434,41) Khong quan tam loại quyet dinh chỉ quan tam den thong ke Phuong bao
                        --Quoc tich la nguoi viet nam thi kiem tra cccd
                        AND (NDS.QUOCTICHID !=2 OR (NDS.QUOCTICHID = 2 AND LENGTH(NDS.SO_CCCD)  = 12 ))
                        AND (BDS.QUOCTICHID !=2 OR (BDS.QUOCTICHID = 2 AND LENGTH(BDS.SO_CCCD)  = 12)) 
                         -- Cả nguyên đơn và bị đơn đã nhận tống đạt
                        AND NGD.NGAYNHANTONGDAT IS NOT NULL
                        AND BD.NGAYNHANTONGDAT IS NOT NULL
                          -- So sánh ngày nhận tống đạt
                        AND GREATEST(NGD.NGAYNHANTONGDAT, BD.NGAYNHANTONGDAT) + 30 < SYSDATE
                        AND GREATEST(NGD.NGAYNHANTONGDAT_SYS, BD.NGAYNHANTONGDAT_SYS) BETWEEN V_TUNGAY AND V_DENNGAY
                UNION 
                  ---TH4: Có bản án quyết định sơ thẩm và bị kháng cáo kháng nghị nhưng lại Rút kc/kn trước khi thụ lý xét xử 
                   SELECT 
                        TO_CHAR(B.ID) AS ID_REF,
                        B.SOBANAN AS SO_BAN_AN,
                        TO_CHAR(B.NGAYTUYENAN,'dd/MM/yyyy') AS NGAY_RA_BAN_AN,
                        Decode(b.NGAYHIEULUC,null,null, TO_CHAR(B.NGAYHIEULUC,'dd/MM/yyyy') ) AS NGAY_HIEU_LUC_BA,
                        TO_CHAR(B.TOAANID) AS DON_VI_RA_BAN_AN_ID,
                        DM.MA_TEN AS DON_VI_RA_BAN_AN_TEN,
                        TO_CHAR(NGD.NGAYNHANTONGDAT,'dd/MM/yyyy') AS NGAY_NHAN_NGUYEN_DON,
                        TO_CHAR(BD.NGAYNHANTONGDAT,'dd/MM/yyyy') AS NGAY_NHAN_BI_DON,
                        NDS.TENDUONGSU AS HO_TEN_NGUYEN_DON,
                        NDS.SO_CCCD AS SO_GIAY_TO_NGUYEN_DON,
                        DECODE(TO_CHAR(NDS.NGAYSINH,'dd/MM/yyyy'), '01/01/0001','', TO_CHAR(NDS.NGAYSINH,'dd/MM/yyyy')) AS NGAY_SINH_NGUYEN_DON,
                        QTN.TEN AS QUOC_TICH_NGUYEN_DON,
                        BDS.TENDUONGSU AS HO_TEN_BI_DON,            
                        BDS.SO_CCCD AS SO_GIAY_TO_BI_DON,
                        DECODE(TO_CHAR(BDS.NGAYSINH,'dd/MM/yyyy'), '01/01/0001','', TO_CHAR(BDS.NGAYSINH,'dd/MM/yyyy')) AS NGAY_SINH_BI_DON,
                        QTB.TEN AS QUOC_TICH_BI_DON,
                     --1.Ly hôn;2.Huỷ BA/QĐ ly hôn (sử dụng cho trường hợp cập nhật thông tin); 3.Không là vợ chồng;
                        CASE 
                           WHEN B.TK_ISCHAPNHAN = 1  AND  B.TK_CHOLYHON = 1 THEN '1' --1.Ly hôn;
                           WHEN b.tk_iskhongchapnhan =1 and  b.tk_iskhongcongnhanvc =1 THEN '3' --3.Không là vợ chồng
                        END AS TRANG_THAI_TTHN,
                        '1' AS trangThaiBanGhi,-- 1.Thêm mới;2.	Thu hồi
                        'Thêm mới' AS ghiChu,
                        --Loai An
                        '3' AS PHAN_LOAI
                    FROM 
                        AHN_SOTHAM_BANAN B
                        INNER JOIN DM_TOAAN DM ON DM.ID = B.TOAANID
                        INNER JOIN AHN_TONGDAT TD ON TD.DONID = B.DONID
                        INNER JOIN AHN_TONGDAT_DOITUONG NGD ON TD.ID = NGD.TONGDATID
                        INNER JOIN AHN_DON_DUONGSU NDS ON NGD.DUONGSUID = NDS.ID
                        INNER JOIN AHN_TONGDAT_DOITUONG BD ON TD.ID = BD.TONGDATID
                        INNER JOIN AHN_DON_DUONGSU BDS ON BD.DUONGSUID = BDS.ID
                        LEFT JOIN DM_DATAITEM QTN ON QTN.ID = NDS.QUOCTICHID AND QTN.GROUPID = 2
                        LEFT JOIN DM_DATAITEM QTB ON QTB.ID = BDS.QUOCTICHID AND QTB.GROUPID = 2
                    WHERE 
                        (
                            (B.TK_ISCHAPNHAN = 1 AND B.TK_CHOLYHON = 1) 
                            OR 
                            (B.TK_ISKHONGCHAPNHAN = 1 AND B.TK_ISKHONGCONGNHANVC = 1)
                        )
                        AND NDS.TUCACHTOTUNG_MA = 'NGUYENDON'
                        AND NDS.ISDAIDIEN = 1
                        AND BDS.TUCACHTOTUNG_MA = 'BIDON'
                        AND BDS.ISDAIDIEN = 1
                        AND NGD.NGAYNHANTONGDAT IS NOT NULL
                        AND BD.NGAYNHANTONGDAT IS NOT NULL
                        AND GREATEST(NGD.NGAYNHANTONGDAT, BD.NGAYNHANTONGDAT) + 30 < SYSDATE
                        AND GREATEST(NGD.NGAYNHANTONGDAT_SYS, BD.NGAYNHANTONGDAT_SYS) BETWEEN V_TUNGAY AND V_DENNGAY
                        AND (
                            EXISTS (
                                SELECT 1
                                FROM AHN_SOTHAM_KHANGCAO KC
                                WHERE (KC.DUONGSUID = NDS.ID OR KC.DUONGSUID = BDS.ID)
                                  AND EXISTS (
                                      SELECT 1
                                      FROM AHN_SOTHAM_RUTKCKN RK
                                      WHERE RK.ISKCKN = 1 AND RK.IDKCKN = KC.ID
                                  )
                            )
                            OR
                            EXISTS (
                                SELECT 1
                                FROM AHN_SOTHAM_KHANGNGHI KN
                                WHERE KN.DONID = B.DONID
                                  AND EXISTS (
                                      SELECT 1
                                      FROM AHN_SOTHAM_RUTKCKN RK
                                      WHERE RK.ISKCKN = 2 AND RK.IDKCKN = KN.ID
                                  )
                            )
                        )
                      

                )A

    ;


END AHN_TONGDAT_BA_TTHN;

END PKG_DVCQG_DLDCQG;

/
