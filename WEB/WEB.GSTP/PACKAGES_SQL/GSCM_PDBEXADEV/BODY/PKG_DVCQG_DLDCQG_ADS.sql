--------------------------------------------------------
--  DDL for Package Body PKG_DVCQG_DLDCQG_ADS
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_DVCQG_DLDCQG_ADS" AS

PROCEDURE EXT_SEARCH_ALL
(
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
    v_CheckNullKHOBAQD in NUMBER,
    v_DONID in NUMBER,
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
                ROW_NUMBER() OVER (ORDER BY A.LOAIBAQD desc) STT, COUNT(*) OVER () as CountAll,
                A.* FROM (
                    --TH1: Bản án co hieu luc                  
                        SELECT B.DONID,
                            '2' AS LOAIAN_ID, 
                            'Dân sự' AS LOAI_AN_TEN, 
                            '0' AS LOAIBAQD, --0 là bản án
                            B.id as BAQD_ID, 
                            TO_CHAR(d.mavuviec) AS MavuAn,
                            d.tenvuviec as TenVuAn, 
                            'Sơ Thẩm' as CAPXX, 
                            B.SOBANAN AS SO_BAN_AN, 
                            TO_CHAR(B.NGAYTUYENAN,'dd/MM/yyyy') AS NGAY_RA_BAN_AN,
                            DECODE(b.ngayhieuluc, NULL, NULL,TO_CHAR(b.ngayhieuluc,'dd/MM/yyyy'))  as NGAY_HIEU_LUC_BA,
                            DECODE(TL.TRUONGHOPTHULY,3,'Thụ lý xét xử lại do GDT hủy',2,'Thụ lý xét xử lại do PT hủy','Thụ lý mới')
                                        ||' - số '|| TL.SOTHULY ||' ngày '|| TO_CHAR(TL.NGAYTHULY,'dd/MM/yyyy')  AS THULY,
                            TO_CHAR(B.TOAANID) AS DON_VI_RA_BAN_AN_ID,
                            DM.MA_TEN AS DON_VI_RA_BAN_AN_TEN,
                            DM.MA AS MA_DON_VI_RA_BAN_AN_TEN,
                            null AS NGAY_NHAN_NGUYEN_DON,
                            null AS NGAY_NHAN_BI_DON,
                            NDS.TENDUONGSU AS HO_TEN_NGUYEN_DON,
                            trim(NDS.SO_CCCD) AS SO_GIAY_TO_NGUYEN_DON,
                            DECODE(TO_CHAR(NDS.NGAYSINH,'dd/MM/yyyy'), '01/01/0001','',TO_CHAR(NDS.NGAYSINH,'dd/MM/yyyy')) AS NGAY_SINH_NGUYEN_DON,
                            h1.MA_TEN AS DIACHI_NGUYEN_DON,
                            QTN.MA AS QUOC_TICH_NGUYEN_DON,
                            QTN.ID as ND_QUOCTICHID,
                            BDS.TENDUONGSU AS HO_TEN_BI_DON,            
                            trim(BDS.SO_CCCD) AS SO_GIAY_TO_BI_DON,
                            DECODE(TO_CHAR(BDS.NGAYSINH,'dd/MM/yyyy'), '01/01/0001','',TO_CHAR(BDS.NGAYSINH,'dd/MM/yyyy')) AS NGAY_SINH_BI_DON,
                            h2.MA_TEN AS DIACHI_BI_DON,
                            QTB.MA AS QUOC_TICH_BI_DON,
                            QTB.ID as BD_QUOCTICHID,
                            '' AS ghiChu,
                            '0' as TRANGTHAIDONGBO,
                            b.nguoitao as NGUOITAO,
                            TO_CHAR(B.ngaytao,'dd/MM/yyyy') as NgayTao,
                            'Chưa đồng bộ' AS TRANGTHAIBAQDNAME,
                            TO_CHAR(K.NGAYTAO,'dd/MM/yyyy') AS NGAYGUI,
                            K.TAIKHOANTAO,
                            '0' as KHANGCAOQH,
                            NDS.ID AS NGUYENDON_ID,
                            BDS.ID AS BIDON_ID,
                            K.id as KHOBAQDID,
                            NDS.XACTHUC_DLDCQG as ND_XACTHUC_DLDCQG,
                            NDS.LOAIDUONGSU as ND_LOAIDUONGSU,
                            BDS.XACTHUC_DLDCQG as BD_XACTHUC_DLDCQG,
                            BDS.LOAIDUONGSU as BD_LOAIDUONGSU,
                            NDS.GIOITINH as GIOI_TINH_NGUYENDON,--NDS.GIOITINH = 1 La Nam, = 2 là Nu
                            NDS.SOCMND as SO_CMND_NGUYEN_DON,
                            BDS.GIOITINH  as GIOI_TINH_BI_DON,
                            BDS.SOCMND as SO_CMND_BI_DON,
                            '' as maDonViNhanBanAn,
                            '' as tenDonViNhanBanAn,
                            '' as soGiayCNKH,
                            D.QUANHEPHAPLUATID,
                            '' as SO_DUONGSU_DONGBO,
                             (SELECT COUNT(*)
                             FROM ADS_DON_DUONGSU DS where DS.DONID = B.DONID AND (
                                   (
                                      (DS.LOAIDUONGSU = 1 
                                    AND (DS.QUOCTICHID <> 2 OR DS.XACTHUC_DLDCQG = 1))
    
                                   OR (DS.LOAIDUONGSU <> 1)
                                  )
                                )) AS SO_DUONGSU,
                                 '' as SO_DUONGSU_CHUADONGBO,
                                 null as TRANG_THAI_TTHN,
                                 '-1' as TRANGTHAIBAQD
                            FROM ADS_SOTHAM_BANAN B
                            INNER JOIN DM_TOAAN DM ON DM.ID = B.TOAANID
                            LEFT JOIN ADS_DON_DUONGSU NDS ON NDS.DONID = B.DONID AND NDS.TUCACHTOTUNG_MA = 'NGUYENDON' AND NDS.ISDAIDIEN = 1 
                            AND (
                                  (NDS.LOAIDUONGSU = 1 
                                AND (NDS.QUOCTICHID <> 2 OR NDS.XACTHUC_DLDCQG = 1))

                               OR (NDS.LOAIDUONGSU <> 1)
                              )
                            left join DM_HANHCHINH h1 on h1.ID = NDS.TAMTRUID
                            LEFT JOIN ADS_DON_DUONGSU BDS ON BDS.DONID = B.DONID AND BDS.TUCACHTOTUNG_MA = 'BIDON' AND BDS.ISDAIDIEN = 1 
                            AND (
                                  (BDS.LOAIDUONGSU = 1 
                                AND (BDS.QUOCTICHID <> 2 OR BDS.XACTHUC_DLDCQG = 1))

                               OR (BDS.LOAIDUONGSU <> 1)
                              )                   
                            left join DM_HANHCHINH h2 on h2.ID=BDS.TAMTRUID
                            LEFT JOIN DM_DATAITEM QTN ON QTN.ID = NDS.QUOCTICHID AND QTN.GROUPID = 2
                            LEFT JOIN DM_DATAITEM QTB ON QTB.ID = BDS.QUOCTICHID AND QTB.GROUPID = 2
                            LEFT JOIN ADS_DON D ON D.ID = B.DONID
                            LEFT JOIN ADS_PHUCTHAM_THULY TLPT ON TLPT.DONID = D.ID
                            LEFT JOIN (SELECT KH.ID, KH.IDBAQD, KH.TAIKHOANTAO, KH.NGAYTAO, KH.DONID
                            FROM KHOBAQD KH 
                            WHERE KH.CAPXX = 2 -- 2: sơ thẩm
                            AND KH.LINHVUC = 'ADS' AND KH.STATUS = 1) K ON B.DONID = K.DONID
                            LEFT JOIN ADS_SOTHAM_THULY TL ON TL.DONID = B.DONID
                            WHERE ((NDS.QUOCTICHID !=2 OR (NDS.QUOCTICHID = 2 AND LENGTH(trim(NDS.SO_CCCD))  = 12 )) OR (BDS.QUOCTICHID !=2 OR (BDS.QUOCTICHID = 2 AND LENGTH(trim(BDS.SO_CCCD))  = 12))) 
                                AND TLPT.ID IS NULL
                                -- Ngày hiệu lực của BA hoặc QĐ
                                AND B.ngayhieuluc is not null
                                -- Chua dong bo sang C06--
                                AND (v_CheckNullKHOBAQD = 0 or K.id is null) AND b.toaanid = v_toaan_id 
                                AND (NDS.DONID IS NOT NULL OR BDS.DONID IS NOT NULL)       
                                AND (v_DONID is null or B.DONID = v_DONID)
                    UNION
                    -- TH2: lấy thông tin bản án Phúc thẩm thỏa mãn điều kiện đẩy đi
                        SELECT 
                                B.DONID,
                                '2' AS LOAIAN_ID,
                                'Dân sự' AS LOAI_AN_TEN,
                                '0' AS LOAIBAQD, --0 là bản án
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
                                DM.MA AS MA_DON_VI_RA_BAN_AN_TEN,
                                null AS NGAY_NHAN_NGUYEN_DON,
                                null AS NGAY_NHAN_BI_DON,
                                NDS.TENDUONGSU AS HO_TEN_NGUYEN_DON,
                                --to_char(ngd.NGAYNHANTONGDAT,'dd/MM/yyyy')  AS NGAY_NHAN_NGUYEN_DON,
                                trim(NDS.SO_CCCD) AS SO_GIAY_TO_NGUYEN_DON,
                                DECODE(TO_CHAR(NDS.NGAYSINH,'dd/MM/yyyy'), '01/01/0001','',TO_CHAR(NDS.NGAYSINH,'dd/MM/yyyy')) AS NGAY_SINH_NGUYEN_DON,
                                h1.MA_TEN AS DIACHI_NGUYEN_DON,
                                QTN.MA AS QUOC_TICH_NGUYEN_DON,
                                QTN.ID as ND_QUOCTICHID,
                                --to_char(bd.NGAYNHANTONGDAT,'dd/MM/yyyy')  AS NGAY_NHAN_BI_DON
                                BDS.TENDUONGSU AS HO_TEN_BI_DON,            
                                trim(BDS.SO_CCCD) AS SO_GIAY_TO_BI_DON,
                                DECODE(TO_CHAR(BDS.NGAYSINH,'dd/MM/yyyy'), '01/01/0001','',TO_CHAR(BDS.NGAYSINH,'dd/MM/yyyy')) AS NGAY_SINH_BI_DON,
                                 h2.MA_TEN AS DIACHI_BI_DON,
                                QTB.MA AS QUOC_TICH_BI_DON,
                                QTB.ID as BD_QUOCTICHID,
                                '' AS ghiChu,
                                '0' as TRANGTHAIDONGBO,
                                 b.nguoitao as NGUOITAO,
                                 TO_CHAR(B.ngaytao,'dd/MM/yyyy') as NgayTao,
                                 'Chưa đồng bộ' AS TRANGTHAIBAQDNAME,
                                 TO_CHAR(K.NGAYTAO,'dd/MM/yyyy') AS NGAYGUI,
                                 K.TAIKHOANTAO,
                                 '0' as KHANGCAOQH,
                                 NDS.ID AS NGUYENDON_ID,
                                 BDS.ID AS BIDON_ID,
                                 K.id as KHOBAQDID,
                                 NDS.XACTHUC_DLDCQG as ND_XACTHUC_DLDCQG,
                                 NDS.LOAIDUONGSU as ND_LOAIDUONGSU,
                                 BDS.XACTHUC_DLDCQG as BD_XACTHUC_DLDCQG,
                                 BDS.LOAIDUONGSU as BD_LOAIDUONGSU,
                                 NDS.GIOITINH as GIOI_TINH_NGUYENDON,--NDS.GIOITINH = 1 La Nam, = 2 là Nu
                                 NDS.SOCMND as SO_CMND_NGUYEN_DON,
                                 BDS.GIOITINH  as GIOI_TINH_BI_DON,
                                 BDS.SOCMND as SO_CMND_BI_DON,
                                 '' as maDonViNhanBanAn,
                                 '' as tenDonViNhanBanAn,
                                 '' as soGiayCNKH,
                                 D.QUANHEPHAPLUATID,
                                 '' as SO_DUONGSU_DONGBO,
                             (SELECT COUNT(*)
                             FROM ADS_DON_DUONGSU DS where DS.DONID = B.DONID AND (
                                   (
                                      (DS.LOAIDUONGSU = 1 
                                    AND (DS.QUOCTICHID <> 2 OR DS.XACTHUC_DLDCQG = 1))
    
                                   OR (DS.LOAIDUONGSU <> 1)
                                  )
                                )) AS SO_DUONGSU,
                                 '' as SO_DUONGSU_CHUADONGBO,
                                 null as TRANG_THAI_TTHN,
                                 '-1' as TRANGTHAIBAQD
                            FROM ADS_PHUCTHAM_BANAN B
                            INNER JOIN DM_TOAAN DM ON DM.ID = B.TOAANID
                            LEFT JOIN ADS_DON_DUONGSU NDS ON NDS.DONID = B.DONID AND NDS.TUCACHTOTUNG_MA = 'NGUYENDON' AND NDS.ISDAIDIEN = 1 AND (
                                  (NDS.LOAIDUONGSU = 1 
                                AND (NDS.QUOCTICHID <> 2 OR NDS.XACTHUC_DLDCQG = 1))

                               OR (NDS.LOAIDUONGSU <> 1)
                              )                    
                            left join DM_HANHCHINH h1 on h1.ID=NDS.TAMTRUID
                            LEFT JOIN ADS_DON_DUONGSU BDS ON BDS.DONID = B.DONID AND BDS.TUCACHTOTUNG_MA = 'BIDON' AND BDS.ISDAIDIEN = 1 
                            AND (
                                  (BDS.LOAIDUONGSU = 1 
                                AND (BDS.QUOCTICHID <> 2 OR BDS.XACTHUC_DLDCQG = 1))

                               OR (BDS.LOAIDUONGSU <> 1)
                              )                 
                            left join DM_HANHCHINH h2 on h2.ID=BDS.TAMTRUID
                            LEFT JOIN DM_DATAITEM QTN ON QTN.ID = NDS.QUOCTICHID AND QTN.GROUPID = 2
                            LEFT JOIN DM_DATAITEM QTB ON QTB.ID = BDS.QUOCTICHID AND QTB.GROUPID = 2
                            LEFT JOIN ADS_DON D ON D.ID = B.DONID
                            LEFT JOIN (SELECT KH.ID, KH.IDBAQD, KH.TAIKHOANTAO, KH.NGAYTAO, KH.DONID
                            FROM KHOBAQD KH
                            WHERE KH.CAPXX = 3
                            AND KH.LINHVUC = 'ADS' AND KH.STATUS = 1) K ON B.DONID = K.DONID
                            LEFT JOIN ADS_PHUCTHAM_THULY TL ON TL.DONID = B.DONID
                            WHERE ((NDS.QUOCTICHID !=2 OR (NDS.QUOCTICHID = 2 AND LENGTH(trim(NDS.SO_CCCD))  = 12 )) OR (BDS.QUOCTICHID !=2 OR (BDS.QUOCTICHID = 2 AND LENGTH(trim(BDS.SO_CCCD))  = 12)))                             
                                -- Chua đồng bộ  
                                AND (v_CheckNullKHOBAQD = 0 or K.id is null) AND b.TOA_GIAIQUYET_ID = v_toaan_id 
                                AND (NDS.DONID IS NOT NULL OR BDS.DONID IS NOT NULL) 
                                AND (v_DONID is null or B.DONID = v_DONID)
               UNION
                    -- TH3:  Quyết định sơ thẩm về ly hôn  
                    SELECT 
                                Q.DONID,
                                '2' AS LOAIAN_ID,
                                'Dân sự' AS LOAI_AN_TEN,
                                '1' AS LOAIBAQD, --1 là quyết định
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
                                DM.MA AS MA_DON_VI_RA_BAN_AN_TEN,
                                Null  AS NGAY_NHAN_NGUYEN_DON,
                                Null  AS NGAY_NHAN_BI_DON,
                                NDS.TENDUONGSU AS HO_TEN_NGUYEN_DON,
                                --to_char(ngd.NGAYNHANTONGDAT,'dd/MM/yyyy')  AS NGAY_NHAN_NGUYEN_DON,
                                trim(NDS.SO_CCCD) AS SO_GIAY_TO_NGUYEN_DON,
                                DECODE(TO_CHAR(NDS.NGAYSINH,'dd/MM/yyyy'), '01/01/0001','',TO_CHAR(NDS.NGAYSINH,'dd/MM/yyyy')) AS NGAY_SINH_NGUYEN_DON,
                                h1.MA_TEN AS DIACHI_NGUYEN_DON,
                                QTN.MA AS QUOC_TICH_NGUYEN_DON,
                                QTN.ID as ND_QUOCTICHID,
                                
                                BDS.TENDUONGSU AS HO_TEN_BI_DON,            
                                trim(BDS.SO_CCCD) AS SO_GIAY_TO_BI_DON,
                                DECODE(TO_CHAR(BDS.NGAYSINH,'dd/MM/yyyy'), '01/01/0001','',TO_CHAR(BDS.NGAYSINH,'dd/MM/yyyy')) AS NGAY_SINH_BI_DON,
                                h2.MA_TEN AS DIACHI_BI_DON,
                                QTB.MA AS QUOC_TICH_BI_DON,
                                QTB.ID as BD_QUOCTICHID,
                                '' AS ghiChu,
                                '0' as TRANGTHAIDONGBO,
                                 Q.nguoitao as NGUOITAO,
                                 TO_CHAR(Q.ngaytao,'dd/MM/yyyy') as NgayTao,
                                 'Chưa đồng bộ' AS TRANGTHAIBAQDNAME,
                                 TO_CHAR(K.NGAYTAO,'dd/MM/yyyy') AS NGAYGUI,
                                 K.TAIKHOANTAO,
                                 '0' as KHANGCAOQH,
                                 NDS.ID AS NGUYENDON_ID,
                                 BDS.ID AS BIDON_ID,
                                 K.id as KHOBAQDID,
                                 NDS.XACTHUC_DLDCQG as ND_XACTHUC_DLDCQG,
                                 NDS.LOAIDUONGSU as ND_LOAIDUONGSU,
                                 BDS.XACTHUC_DLDCQG as BD_XACTHUC_DLDCQG,
                                 BDS.LOAIDUONGSU as BD_LOAIDUONGSU,
                                 NDS.GIOITINH as GIOI_TINH_NGUYENDON,--NDS.GIOITINH = 1 La Nam, = 2 là Nu
                                 NDS.SOCMND as SO_CMND_NGUYEN_DON,
                                 BDS.GIOITINH  as GIOI_TINH_BI_DON,
                                 BDS.SOCMND as SO_CMND_BI_DON,
                                 '' as maDonViNhanBanAn,
                                 '' as tenDonViNhanBanAn,
                                 '' as soGiayCNKH,
                                 D.QUANHEPHAPLUATID,
                                 '' as SO_DUONGSU_DONGBO,
                             (SELECT COUNT(*)
                             FROM ADS_DON_DUONGSU DS where DS.DONID = Q.DONID AND (
                                   (
                                      (DS.LOAIDUONGSU = 1 
                                    AND (DS.QUOCTICHID <> 2 OR DS.XACTHUC_DLDCQG = 1))
    
                                   OR (DS.LOAIDUONGSU <> 1)
                                  )
                                )) AS SO_DUONGSU,
                                 '' as SO_DUONGSU_CHUADONGBO,
                                 null as TRANG_THAI_TTHN,
                                 '-1' as TRANGTHAIBAQD
                            FROM ads_sotham_quyetdinh Q
                            INNER JOIN DM_TOAAN DM ON DM.ID = Q.TOAANID
                            LEFT JOIN ADS_DON_DUONGSU NDS ON NDS.DONID = q.DONID AND NDS.TUCACHTOTUNG_MA = 'NGUYENDON' AND NDS.ISDAIDIEN = 1 
                            AND (
                                  (NDS.LOAIDUONGSU = 1 
                                AND (NDS.QUOCTICHID <> 2 OR NDS.XACTHUC_DLDCQG = 1))

                               OR (NDS.LOAIDUONGSU <> 1)
                              )                    
                            left join DM_HANHCHINH h1 on h1.ID=NDS.TAMTRUID
                            LEFT JOIN ADS_DON_DUONGSU BDS ON BDS.DONID = q.DONID AND BDS.TUCACHTOTUNG_MA = 'BIDON' AND BDS.ISDAIDIEN = 1 
                            AND (
                                  (BDS.LOAIDUONGSU = 1 
                                AND (BDS.QUOCTICHID <> 2 OR BDS.XACTHUC_DLDCQG = 1))

                               OR (BDS.LOAIDUONGSU <> 1)
                              )                    
                            left join DM_HANHCHINH h2 on h2.ID=BDS.TAMTRUID
                            LEFT JOIN DM_DATAITEM QTN ON QTN.ID = NDS.QUOCTICHID AND QTN.GROUPID = 2
                            LEFT JOIN DM_DATAITEM QTB ON QTB.ID = BDS.QUOCTICHID AND QTB.GROUPID = 2
                            LEFT JOIN ADS_DON D ON D.ID = Q.DONID
                            LEFT JOIN ADS_PHUCTHAM_THULY TLPT ON TLPT.DONID = D.ID
                            LEFT JOIN (SELECT KH.ID, KH.IDBAQD, KH.TAIKHOANTAO, KH.NGAYTAO, KH.DONID
                            FROM KHOBAQD KH
                            WHERE KH.CAPXX = 2 
                            AND KH.LINHVUC = 'ADS' AND KH.STATUS = 1) K ON Q.DONID = K.DONID
                            LEFT JOIN ADS_SOTHAM_THULY TL ON TL.DONID = Q.DONID
                            left join DM_QD_QUYETDINH lqdkt on Q.QUYETDINHID = lqdkt.id
                            WHERE ((NDS.QUOCTICHID !=2 OR (NDS.QUOCTICHID = 2 AND LENGTH(trim(NDS.SO_CCCD))  = 12 )) OR (BDS.QUOCTICHID !=2 OR (BDS.QUOCTICHID = 2 AND LENGTH(trim(BDS.SO_CCCD))  = 12))) --Quoc tich la nguoi viet nam thi kiem tra cccd
                                -- Chưa đồng bộ  
                                AND (v_CheckNullKHOBAQD = 0 or K.id is null) AND TLPT.ID IS NULL AND Q.toaanid = v_toaan_id 
                                And Q.HIEULUCTU is not null and lqdkt.ket_thuc = 1
                                AND (NDS.DONID IS NOT NULL OR BDS.DONID IS NOT NULL) 
                                AND (v_DONID is null or Q.DONID = v_DONID)
                    UNION
                        -- TH4: lấy thông tin Quyết định Phúc thẩm
                        SELECT 
                                q.DONID,
                                '2' AS LOAIAN_ID,
                                'Dân sự' AS LOAI_AN_TEN,
                                '1' AS LOAIBAQD, --1 là quyết định
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
                                DM.MA AS MA_DON_VI_RA_BAN_AN_TEN,
                                NULL  AS NGAY_NHAN_NGUYEN_DON,
                                NULL  AS NGAY_NHAN_BI_DON,
                                NDS.TENDUONGSU AS HO_TEN_NGUYEN_DON,                                
                                trim(NDS.SO_CCCD) AS SO_GIAY_TO_NGUYEN_DON,
                                DECODE(TO_CHAR(NDS.NGAYSINH,'dd/MM/yyyy'), '01/01/0001','',TO_CHAR(NDS.NGAYSINH,'dd/MM/yyyy')) AS NGAY_SINH_NGUYEN_DON,
                                h1.MA_TEN AS DIACHI_NGUYEN_DON,
                                QTN.MA AS QUOC_TICH_NGUYEN_DON,
                                QTN.ID as ND_QUOCTICHID,
                                
                                BDS.TENDUONGSU AS HO_TEN_BI_DON,            
                                trim(BDS.SO_CCCD) AS SO_GIAY_TO_BI_DON,
                                DECODE(TO_CHAR(BDS.NGAYSINH,'dd/MM/yyyy'), '01/01/0001','',TO_CHAR(BDS.NGAYSINH,'dd/MM/yyyy')) AS NGAY_SINH_BI_DON,
                                h2.MA_TEN AS DIACHI_BI_DON,
                                QTB.MA AS QUOC_TICH_BI_DON,
                                QTB.ID as BD_QUOCTICHID,

                                '' AS ghiChu,
                                '0' as TRANGTHAIDONGBO,
                                 q.nguoitao as NGUOITAO,
                                 TO_CHAR(q.ngaytao,'dd/MM/yyyy') as NgayTao,
                                 'Chưa đồng bộ' AS TRANGTHAIBAQDNAME,
                                 TO_CHAR(K.NGAYTAO,'dd/MM/yyyy') AS NGAYGUI,
                                 K.TAIKHOANTAO,
                                 '0' as KHANGCAOQH,
                                 NDS.ID AS NGUYENDON_ID,
                                 BDS.ID AS BIDON_ID,
                                 K.id as KHOBAQDID,
                                 NDS.XACTHUC_DLDCQG as ND_XACTHUC_DLDCQG,
                                 NDS.LOAIDUONGSU as ND_LOAIDUONGSU,
                                 BDS.XACTHUC_DLDCQG as BD_XACTHUC_DLDCQG,
                                 BDS.LOAIDUONGSU as BD_LOAIDUONGSU,
                                 NDS.GIOITINH as GIOI_TINH_NGUYENDON,--NDS.GIOITINH = 1 La Nam, = 2 là Nu
                                 NDS.SOCMND as SO_CMND_NGUYEN_DON,
                                 BDS.GIOITINH  as GIOI_TINH_BI_DON,
                                 BDS.SOCMND as SO_CMND_BI_DON,
                                 '' as maDonViNhanBanAn,
                                 '' as tenDonViNhanBanAn,
                                 '' as soGiayCNKH,
                                 D.QUANHEPHAPLUATID,
                                 '' as SO_DUONGSU_DONGBO,
                             (SELECT COUNT(*)
                             FROM ADS_DON_DUONGSU DS where DS.DONID = Q.DONID AND (
                                   (
                                      (DS.LOAIDUONGSU = 1 
                                    AND (DS.QUOCTICHID <> 2 OR DS.XACTHUC_DLDCQG = 1))
    
                                   OR (DS.LOAIDUONGSU <> 1)
                                  )
                                )) AS SO_DUONGSU,
                                 '' as SO_DUONGSU_CHUADONGBO,
                                 null as TRANG_THAI_TTHN,
                                 '-1' as TRANGTHAIBAQD
                            FROM ADS_PHUCTHAM_QUYETDINH q
                            INNER JOIN DM_TOAAN DM ON DM.ID = q.TOAANID
                            LEFT JOIN ADS_DON_DUONGSU NDS ON NDS.DONID = q.DONID AND NDS.TUCACHTOTUNG_MA = 'NGUYENDON' AND NDS.ISDAIDIEN = 1 
                            AND (
                                  (NDS.LOAIDUONGSU = 1 
                                AND (NDS.QUOCTICHID <> 2 OR NDS.XACTHUC_DLDCQG = 1))

                               OR (NDS.LOAIDUONGSU <> 1)
                              )
                            left join DM_HANHCHINH h1 on h1.ID=NDS.TAMTRUID
                            LEFT JOIN ADS_DON_DUONGSU BDS ON BDS.DONID = q.DONID AND BDS.TUCACHTOTUNG_MA = 'BIDON' AND BDS.ISDAIDIEN = 1  
                            AND (
                                  (BDS.LOAIDUONGSU = 1 
                                AND (BDS.QUOCTICHID <> 2 OR BDS.XACTHUC_DLDCQG = 1))

                               OR (BDS.LOAIDUONGSU <> 1)
                              )
                            left join DM_HANHCHINH h2 on h2.ID=BDS.TAMTRUID
                            LEFT JOIN DM_DATAITEM QTN ON QTN.ID = NDS.QUOCTICHID AND QTN.GROUPID = 2
                            LEFT JOIN DM_DATAITEM QTB ON QTB.ID = BDS.QUOCTICHID AND QTB.GROUPID = 2
                            LEFT JOIN ADS_DON D ON D.ID = q.DONID
                            LEFT JOIN (SELECT KH.ID, KH.IDBAQD, KH.TAIKHOANTAO, KH.NGAYTAO, KH.DONID
                            FROM KHOBAQD KH 
                            WHERE KH.CAPXX = 3 
                            AND KH.LINHVUC = 'ADS' AND KH.STATUS = 1) K ON Q.DONID = K.DONID
                            LEFT JOIN ADS_PHUCTHAM_THULY TL ON TL.DONID = Q.DONID
                            left join DM_QD_QUYETDINH lqdkt on Q.QUYETDINHID = lqdkt.id
                            WHERE ((NDS.QUOCTICHID !=2 OR (NDS.QUOCTICHID = 2 AND LENGTH(trim(NDS.SO_CCCD))  = 12 )) OR (BDS.QUOCTICHID !=2 OR (BDS.QUOCTICHID = 2 AND LENGTH(trim(BDS.SO_CCCD))  = 12))) --Quoc tich la nguoi viet nam thi kiem tra cccd AND TK.TK_KETQUA_CHITIET in (1,3)
                                AND (v_CheckNullKHOBAQD = 0 or K.id is null) AND q.toaanid = v_toaan_id  and lqdkt.ket_thuc = 1    
                                AND (NDS.DONID IS NOT NULL OR BDS.DONID IS NOT NULL)
                                AND (v_DONID is null or Q.DONID = v_DONID)
                        )A
                     where (v_KHANGCAOQH is null OR  A.KHANGCAOQH = v_KHANGCAOQH)
                        AND (v_LOAIBAQD is null OR A.LOAIBAQD = v_LOAIBAQD)
                        AND (v_BAQD_id is null  OR A.BAQD_id=v_BAQD_id)
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
                                    OR EXISTS(select 'X' from ADS_SoTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=A.DONID) 
                                   OR EXISTS(select 'X' from ADS_PhucTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=A.DONID)
                                    OR EXISTS(SELECT 'X' FROM ADS_DON_THAMPHAN TP WHERE  TP.THUKYID=v_thuky_id and TP.DONID=A.DONID)
                                )                        
                        AND ( v_thamphan_id is null 
                                    OR (A.CAPXX ='Sơ Thẩm' AND  EXISTS(SELECT 'x' FROM ADS_SOTHAM_HDXX TP 
                                            WHERE TP.DONID = A.DONID AND TP.MAVAITRO='THAMPHAN' AND TP.CANBOID = v_thamphan_id ))
                                     OR (A.CAPXX ='Phúc Thẩm' AND  EXISTS(SELECT 'x' FROM ADS_PHUCTHAM_HDXX TP 
                                            WHERE TP.DONID = A.DONID AND TP.MAVAITRO='THAMPHAN' AND TP.CANBOID = v_thamphan_id ))        
                                            )
                )tt where tt.stt>=MinIndex and tt.stt<=MaxIndex
         ;
END EXT_SEARCH_ALL;

PROCEDURE EXT_SEARCH_ALL_DaDongBo_ThuHoi
(
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
    V_TRANGTHAIDONGBO in varchar2, 
    
    Page_Index in	int,
    Page_Size	in	int,
    curReturn OUT sys_refcursor
)
AS
     MinIndex number; MaxIndex number;     
BEGIN
    MinIndex := Page_Size*(Page_Index - 1) + 1;
    MaxIndex := Page_Index*Page_Size;
    
   OPEN CURRETURN FOR
    SELECT tt.* FROM(
            SELECT  ROW_NUMBER() OVER (ORDER BY A.NGAYGUI desc) STT, COUNT(*) OVER () as CountAll
                ,A.* FROM (
                --TH1: Bản án không có kháng cao kháng nghi
                      SELECT b.id,
                            b.DONID,
                            '2' AS LOAIAN_ID,
                            'Dân sự' as LOAI_AN_TEN,
                            b.LOAIBAQD,
                            b.IDBAQD AS BAQD_ID,
                            D.MAVUVIEC AS MavuAn,
                            D.TenVuViec AS TenVuAn, 
                            DECODE(B.CAPXX, 2, 'Sơ thẩm', 3, 'Phúc thẩm', '') AS CAPXX,
                            b.SOBAQD AS SO_BAN_AN,
                            TO_CHAR(B.NGAYBAQD,'dd/MM/yyyy') AS NGAY_RA_BAN_AN,
                            TO_CHAR(b.NGAYHIEULUCBAQD,'dd/MM/yyyy') AS NGAY_HIEU_LUC_BA,
                            DECODE(TL.TRUONGHOPTHULY,3,'Thụ lý xét xử lại do GDT hủy',2,'Thụ lý xét xử lại do PT hủy','Thụ lý mới')
                                        ||' - số'|| TL.SOTHULY ||' ngày '|| TO_CHAR(TL.NGAYTHULY,'dd/MM/yyyy')  AS THULY,
                            B.COQUANQD AS DON_VI_RA_BAN_AN_TEN,
                            B.MACQ AS MA_DON_VI_RA_BAN_AN_TEN,                        
                            NDS.NGAYTAO AS NGAY_NHAN_NGUYEN_DON,
                            BDS.NGAYTAO AS NGAY_NHAN_BI_DON,
                            -- nguyên đơn
                            NDS.ID AS NGUYENDON_ID,
                            NDS.LOAIDUONGSU as ND_LOAIDUONGSU,
                            NDS.TENDUONGSU AS HO_TEN_NGUYEN_DON,
                            NDS.SO_CCCD AS SO_GIAY_TO_NGUYEN_DON,
                            NDS.NGAYSINH AS NGAY_SINH_NGUYEN_DON,
                            NDS.GIOITINH AS GIOI_TINH_NGUYEN_DON,
                            NDS.SOCMND AS SO_CMND_NGUYEN_DON,
                            NDS.XACTHUC_DLDCQG as ND_XACTHUC_DLDCQG, --trạng thái xác thực 
                            QTN.MA AS QUOC_TICH_NGUYEN_DON,
                            QTN.ID as ND_QUOCTICHID,
                            DCN.MA_TEN AS DIACHI_NGUYEN_DON,
                            --bị đơn
                            BDS.ID AS BIDON_ID,
                            BDS.LOAIDUONGSU as BD_LOAIDUONGSU,
                            BDS.TENDUONGSU AS HO_TEN_BI_DON,            
                            BDS.SO_CCCD AS SO_GIAY_TO_BI_DON,
                            BDS.NGAYSINH AS NGAY_SINH_BI_DON,
                            BDS.GIOITINH  as GIOI_TINH_BI_DON,
                            BDS.SOCMND as SO_CMND_BI_DON,
                            QTB.MA AS QUOC_TICH_BI_DON,
                            QTB.ID as BD_QUOCTICHID,
                            DCB.MA_TEN AS DIACHI_BI_DON,
                            BDS.XACTHUC_DLDCQG as BD_XACTHUC_DLDCQG, --trạng thái xác thực 
                            
                            B.STATUS AS trangThaiBanGhi,
                            B.GHICHU AS GhiChu,
                            B.TRANGTHAIBAQD,
                            CASE 
                                WHEN B.TRANGTHAIBAQD = 0 THEN 'Đang đồng bộ'
                                WHEN B.TRANGTHAIBAQD IN (1,2) THEN 'Đã đồng bộ'
                                WHEN B.TRANGTHAIBAQD IN (3, 4, 5) THEN 'Đã thu hồi'
                                ELSE 'Không xác định'
                            END AS TRANGTHAIBAQDNAME,
                            TO_CHAR(B.NGAYTAO,'dd/MM/yyyy') AS NGAYGUI,
                            B.TAIKHOANTAO,
                            B.MAVANBAN maDinhDanhBanAn,
                            '0' AS KHANGCAOQH,
                            '' AS MADONVINHANBANAN,
                            '' AS TENDONVINHANBANAN,
                            '' AS SOGIAYCNKH,
                            D.QUANHEPHAPLUATID,
                            (SELECT COUNT(*)
                             FROM KHOBAQD_DUONGSU DS
                             WHERE DS.KHOBAQDID = B.ID and STATUS = 1) AS SO_DUONGSU_DONGBO,
                             (SELECT COUNT(*)
                             FROM ADS_DON_DUONGSU DS
                             left join KHOBAQD_DUONGSU A on DS.ID = A.DUONGSUID
                             WHERE DS.DONID = B.DONID and A.ID is null AND (
                                   (
                                      (DS.LOAIDUONGSU = 1 
                                    AND (DS.QUOCTICHID <> 2 OR DS.XACTHUC_DLDCQG = 1))
    
                                   OR (DS.LOAIDUONGSU <> 1)
                                  )
                                )) AS SO_DUONGSU_CHUADONGBO,
                             (SELECT COUNT(*)
                             FROM ADS_DON_DUONGSU DS where DS.DONID = B.DONID AND (
                                   (
                                      (DS.LOAIDUONGSU = 1 
                                    AND (DS.QUOCTICHID <> 2 OR DS.XACTHUC_DLDCQG = 1))
    
                                   OR (DS.LOAIDUONGSU <> 1)
                                  )
                                )) AS SO_DUONGSU,
                             B.TOAANID as DON_VI_RA_BAN_AN_ID,
                             B.id as KHOBAQDID,
                             '' AS NGAYTAO,
                             '' AS NGUOITAO
                        FROM KHOBAQD B
                        LEFT JOIN ADS_DON D ON B.DONID = D.ID                        
                        LEFT JOIN ADS_DON_DUONGSU NDS ON NDS.DONID = D.ID AND NDS.TUCACHTOTUNG_MA = 'NGUYENDON' AND NDS.ISDAIDIEN = 1  
                        AND (
                                  (NDS.LOAIDUONGSU = 1 
                                AND (NDS.QUOCTICHID <> 2 OR NDS.XACTHUC_DLDCQG = 1))

                               OR (NDS.LOAIDUONGSU <> 1)
                              )
                        LEFT JOIN DM_DATAITEM QTN ON QTN.ID = NDS.QUOCTICHID AND QTN.GROUPID = 2
                        LEFT JOIN DM_HANHCHINH DCN on DCN.ID=NDS.TAMTRUID
                        LEFT JOIN ADS_DON_DUONGSU BDS ON BDS.DONID = D.ID AND BDS.TUCACHTOTUNG_MA = 'BIDON' AND BDS.ISDAIDIEN = 1    
                        AND (
                                  (BDS.LOAIDUONGSU = 1 
                                AND (BDS.QUOCTICHID <> 2 OR BDS.XACTHUC_DLDCQG = 1))

                               OR (BDS.LOAIDUONGSU <> 1)
                              )
                        LEFT JOIN DM_DATAITEM QTB ON QTB.ID = BDS.QUOCTICHID AND QTN.GROUPID = 2
                        LEFT JOIN DM_HANHCHINH DCB on DCB.ID=BDS.TAMTRUID
                        LEFT JOIN ADS_SOTHAM_THULY TL ON TL.DONID = B.DONID
                        where B.LINHVUC = 'ADS' and
                        (V_TRANGTHAIDONGBO = 2 AND TRANGTHAIBAQD IN (0,1,2))
                        OR
                        (V_TRANGTHAIDONGBO = 3 AND TRANGTHAIBAQD IN (3,4,5))
                            AND B.TOAANID = v_toaan_id
                            AND (v_LOAIBAQD is null OR B.LOAIBAQD = v_LOAIBAQD)
                            AND (v_BAQD_id is null  OR B.IDBAQD=v_BAQD_id)
                            AND (v_Capxx is null OR  b.CAPXX = v_Capxx)
                            AND (v_ten_vu_an IS NULL OR FN_CONVERT_TO_VN(UPPER(D.TenVuViec)) LIKE '%'||FN_CONVERT_TO_VN(UPPER(v_ten_vu_an))||'%')                            
                            AND (v_ma_vu_an IS NULL OR D.MAVUVIEC = v_ma_vu_an)
                            AND (v_bi_can IS NULL --Đương sự
                                      OR FN_CONVERT_TO_VN(UPPER(NDS.TENDUONGSU)) LIKE '%'||FN_CONVERT_TO_VN(UPPER(v_bi_can))||'%'
                                      OR FN_CONVERT_TO_VN(UPPER(BDS.TENDUONGSU)) LIKE '%'||FN_CONVERT_TO_VN(UPPER(v_bi_can))||'%'
                                      )
                            AND (v_cccd  IS NULL OR NDS.SO_CCCD = v_cccd OR BDS.SO_CCCD  = v_cccd)
                            AND (v_so_qd  IS NULL OR b.SOBAQD = v_so_qd)
                            AND (V_TUNGAY IS NULL OR B.NGAYBAQD >= V_TUNGAY)
                            AND (V_DENNGAY IS NULL OR B.NGAYBAQD <= V_DENNGAY)
                            AND (v_toidanh IS NULL  OR ( FN_CONVERT_TO_VN(LOWER(D.TenVuViec)) LIKE  '%'||FN_CONVERT_TO_VN(LOWER(v_toidanh))||'%' ) )--Quan hệ pháp luật tìm quan hệ pháp luật đã được gắn vào tên vụ án
                            AND (v_thuky_id IS NULL 
                                        OR EXISTS(select 'X' from AHN_SoTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=b.DONID) 
                                       OR EXISTS(select 'X' from AHN_PhucTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=b.DONID)
                                        OR EXISTS(SELECT 'X' FROM AHN_DON_THAMPHAN TP WHERE  TP.THUKYID=v_thuky_id and TP.DONID=b.DONID)
                                    )                    
                           ----Kiem tra cu dung cua tham phan đa day khong
                           AND ( v_thamphan_id is null 
                                OR (B.CAPXX = 2 AND  EXISTS(SELECT 'x' FROM AHN_SOTHAM_HDXX TP --CAPXX = 2 LÀ SƠ THẨM
                                        WHERE TP.DONID = B.DONID AND TP.MAVAITRO='THAMPHAN' AND TP.CANBOID = v_thamphan_id ))
                                 OR (B.CAPXX = 3 AND  EXISTS(SELECT 'x' FROM AHN_PHUCTHAM_HDXX TP  --CAPXX = 3 LÀ PHÚC THẨM
                                        WHERE TP.DONID = B.DONID AND TP.MAVAITRO='THAMPHAN' AND TP.CANBOID = v_thamphan_id ))        
                                        )
                           ---Trạng thái đã gửi và chua bị thu hồi ----
                            AND B.STATUS = 1                  
                            ORDER by B.id
                        )A
                )tt where tt.stt>=MinIndex and tt.stt<=MaxIndex
    ;

END EXT_SEARCH_ALL_DaDongBo_ThuHoi;


END PKG_DVCQG_DLDCQG_ADS;

/
