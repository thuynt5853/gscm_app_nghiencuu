--------------------------------------------------------
--  DDL for Package Body PKG_DVCQG_DLDCQG_AHS
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_DVCQG_DLDCQG_AHS" AS

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
    v_VUANID in NUMBER,
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
                ROW_NUMBER() OVER (ORDER BY A.banan_ngay_ba desc) STT, COUNT(*) OVER () as CountAll,
                A.* FROM (
                            -------- TH1: Lay ban an so tham có ít nhat 1 bị cao có ngay hiệu lực (hieu lực theo bị cáo)
                            SELECT DISTINCT
                                va.id        AS vuanid,
                                va.id        AS DONID,
                                ba.sobanan   AS SO_BAN_AN,
                                to_char(ba.ngaybanan, 'dd/MM/yyyy') AS banan_ngay_ba,
                                dm.ma        AS macq,
                                dm.ten       AS tencq,
                                dm.id        AS toaanId,
                                dc.id        AS thamphanid,
                                dc.hoten     AS thamphan_ten,
                                '1' AS LOAIAN_ID,
                                'Hình Sự' AS loai_an_ten,
                                '0' AS loaibaqd,  --Ban an = 
                                ba.id        AS baqd_id,
                                to_char(va.mavuan) AS mavuan,
                                va.tenvuan,
                                decode(ast.truonghopthuly, 1777, 'Thụ lý xét xử lại do GDT hủy', 236, 'Thụ lý xét xử lại do PT hủy',
                                       235, 'Thụ lý từ tòa án khác chuyển đến', 234, 'Tóa án trả hồ sơ -VKS không chấp nhận điều tra bổ sung', 233,
                                       'Viện kiểm sát truy tố lần đầu', 'Thụ lý mới')
                                || ' - số '
                                || ast.sothuly
                                || ' ngày '
                                || to_char(ast.ngaythuly, 'dd/MM/yyyy') AS thuly,
                                '2' AS capxx_ma, -- 2 sơ thẩm, 3 phúc thẩm
                                'Sơ Thẩm' AS capxx,
                                to_char(va.ngaytao, 'dd/MM/yyyy') AS ngaytao,
                                ba.nguoitao,
                                bicao.ID AS BICAODAUVU_ID,
                                bicao.HOTEN AS BICAODAUVU_HOTEN,
                                to_char(bicao.NGAYSINH, 'dd/MM/yyyy') AS BICAODAUVU_NGAYSINH,
                                bicao.SO_CCCD AS BICAODAUVU_SO_CCCD,
                                bicao.tentoidanh,
                                bicao.tenhinhphat,
                                bicao.bican_ngayhieuluc,
                                '' as GHICHU,
                                TO_CHAR(K.NGAYTAO,'dd/MM/yyyy') AS NGAYGUI,
                                K.TAIKHOANTAO AS NGUOIGUI,
                                'Chưa đồng bộ' AS TRANGTHAIBAQDNAME,
                                K.id as KHOBAQDID,
                                0 as SO_DUONGSU_DONGBO,
                                FN_GET_BICAO_COUNT(ba.id, '2', '0') AS SO_DUONGSU,
                                 null as SO_DUONGSU_CHUADONGBO,
                                 '-1' as TRANGTHAIBAQD
                            FROM ahs_sotham_banan  ba
                            INNER JOIN ahs_vuan                va ON ba.vuanid = va.id
                            INNER JOIN dm_toaan                dm ON dm.id = va.toaanid
                            INNER JOIN ahs_sotham_thuly        ast ON va.id = ast.vuanid    
                            LEFT JOIN (SELECT atp.*
                                        FROM ahs_thamphangiaiquyet atp
                                        WHERE atp.mavaitro = 'VTTP_GIAIQUYETSOTHAM' 
                                                AND atp.id = (SELECT MAX(id) FROM ahs_thamphangiaiquyet WHERE vuanid = atp.vuanid AND mavaitro = 'VTTP_GIAIQUYETSOTHAM')
                                        ) atpgq ON atpgq.vuanid = va.id
                            LEFT JOIN dm_canbo dc ON dc.id = atpgq.canboid
                            LEFT JOIN (SELECT KH.ID, KH.IDBAQD, KH.TAIKHOANTAO, KH.NGAYTAO, KH.DONID
                                FROM KHOBAQD KH 
                                WHERE KH.CAPXX = 2 -- 2: sơ thẩm
                                AND KH.LINHVUC = 'AHS' AND KH.STATUS = 1) K ON ba.VUANID = K.DONID
                            LEFT JOIN (SELECT bcbc.ID, stbc.BANANID, bcbc.HOTEN, bcbc.NGAYSINH, bcbc.SO_CCCD, bcbc.vuanid, thhp.tentoidanh_st tentoidanh, 
                                            to_char(thhp.hinhphat_st) AS tenhinhphat, to_char(stbc.ngayhieulucbanan, 'dd/MM/yyyy') AS bican_ngayhieuluc
                                        FROM AHS_SOTHAM_BANAN_BICAO stbc
                                        JOIN AHS_BICANBICAO bcbc ON stbc.BICAOID = bcbc.ID
                                        LEFT JOIN ahs_tonghophinhphat thhp ON thhp.bicaoid = bcbc.id 
                                        WHERE bcbc.BICANDAUVU = 1
                                        and ((bcbc.LOAIDOITUONG = 0 AND bcbc.QUOCTICHID = 2 AND bcbc.XACTHUC_DLDCQG = 1)
                                     OR
                                     (bcbc.LOAIDOITUONG in (1,2) AND bcbc.XACTHUC_DLDCQG = 1)
                                    )
                                      ) bicao ON ba.ID = bicao.BANANID AND bicao.vuanid = va.id
                            WHERE EXISTS (SELECT 'X' FROM ahs_sotham_banan_bicao WHERE bananid = ba.id AND ngayhieulucbanan IS NOT NULL) -- Ngày hiệu lực của BA hoặc QĐ
                                AND 
                                ba.toaanid = v_toaan_id AND (v_CheckNullKHOBAQD = 0 or K.id is null) -- Chua dong bo
                                AND bicao.ID is not null
                                AND (v_VUANID is null or ba.VUANID = v_VUANID)
                            UNION 
                            -------- TH2: Lay ban an phúc tham 
                            SELECT DISTINCT
                                va.id          AS vuanid,
                                va.id        AS DONID,
                                ptba.sobanan   AS SO_BAN_AN,
                                to_char(ptba.ngaybanan, 'dd/MM/yyyy') AS banan_ngay_ba,
                                dm.ma          AS macq,
                                dm.ten         AS tencq,
                                dm.id          AS toaanId,
                                dc.id          AS thamphanid,
                                dc.hoten       AS thamphan_ten,
                                '1' AS LOAIAN_ID,
                                'Hình Sự' AS loai_an_ten,
                                '0' AS loaibaqd,  --Ban an = 0
                                ptba.id        AS baqd_id,
                                to_char(va.mavuan) AS mavuan,
                                va.tenvuan,
                                decode(ast.truonghopthuly, 1079, 'Do có kháng cáo và kháng nghị phúc thẩm', 1078, 'Do có kháng nghị phúc thẩm',
                                       998, 'Giám đốc thẩm hủy để xét xử lại phúc thẩm', 1058, 'Do có kháng cáo phúc thẩm', 'Thụ lý mới')
                                || ' - số '
                                || ast.sothuly
                                || ' ngày '
                                || to_char(ast.ngaythuly, 'dd/MM/yyyy') AS thuly,
                                '3' AS capxx_ma, -- 2 sơ thẩm, 3 phúc thẩm
                                'Phúc Thẩm' AS capxx,
                                to_char(va.ngaytao, 'dd/MM/yyyy') AS ngaytao,
                                ptba.nguoitao,
                                bicao.ID AS BICAODAUVU_ID,
                                bicao.HOTEN AS BICAODAUVU_HOTEN,
                                to_char(bicao.NGAYSINH, 'dd/MM/yyyy') AS BICAODAUVU_NGAYSINH,
                                bicao.SO_CCCD AS BICAODAUVU_SO_CCCD,
                                bicao.tentoidanh,
                                bicao.tenhinhphat,
                                '' as GHICHU,
                                TO_CHAR(K.NGAYTAO,'dd/MM/yyyy') AS NGAYGUI,
                                K.TAIKHOANTAO AS NGUOIGUI,
                                to_char(ptba.ngaybanan, 'dd/MM/yyyy') AS bican_ngayhieuluc,
                                'Chưa đồng bộ' AS TRANGTHAIBAQDNAME,
                                K.id as KHOBAQDID,
                                0 as SO_DUONGSU_DONGBO,
                                FN_GET_BICAO_COUNT(ptba.id, '3', '0') AS SO_DUONGSU,
                                 null as SO_DUONGSU_CHUADONGBO,
                                 '-1' as TRANGTHAIBAQD
                            FROM ahs_phuctham_banan      ptba
                            INNER JOIN ahs_vuan                va ON ptba.vuanid = va.id
                            INNER JOIN dm_toaan                dm ON dm.id = va.toaanid
                            INNER JOIN ahs_phuctham_thuly      ast ON va.id = ast.vuanid    
                            LEFT JOIN (SELECT atp.*
                                        FROM ahs_thamphangiaiquyet atp
                                        WHERE atp.mavaitro = 'VTTP_GIAIQUYETPHUCTHAM' 
                                                AND atp.id = (SELECT MAX(id) FROM ahs_thamphangiaiquyet WHERE vuanid = atp.vuanid AND mavaitro = 'VTTP_GIAIQUYETPHUCTHAM')
                                        ) atpgq ON atpgq.vuanid = va.id
                            LEFT JOIN dm_canbo                dc ON dc.id = atpgq.canboid
                            LEFT JOIN (SELECT KH.ID, KH.IDBAQD, KH.TAIKHOANTAO, KH.NGAYTAO, KH.DONID
                                FROM KHOBAQD KH 
                                WHERE KH.CAPXX = 3 -- 2: sơ thẩm
                                AND KH.LINHVUC = 'AHS' AND KH.STATUS = 1) K ON ptba.VUANID = K.DONID
                            LEFT JOIN (SELECT bcbc.ID, ptbc.BANANID, bcbc.HOTEN, bcbc.NGAYSINH, bcbc.SO_CCCD, thhp.vuanid, thhp.tentoidanh_pt tentoidanh, to_char(thhp.hinhphat_pt) AS tenhinhphat
                                        FROM AHS_PHUCTHAM_BANAN_BICAO ptbc
                                        JOIN AHS_BICANBICAO bcbc ON ptbc.BICAOID = bcbc.ID
                                        LEFT JOIN ahs_tonghophinhphat thhp ON thhp.bicaoid = bcbc.id 
                                        WHERE bcbc.BICANDAUVU = 1
                                        and ((bcbc.LOAIDOITUONG = 0 AND bcbc.QUOCTICHID = 2 AND bcbc.XACTHUC_DLDCQG = 1)
                                     OR
                                     (bcbc.LOAIDOITUONG in (1,2) AND bcbc.XACTHUC_DLDCQG = 1)
                                     )
                                      ) bicao ON ptba.ID = bicao.BANANID AND bicao.vuanid = va.id
                            WHERE ptba.toaanid = v_toaan_id AND (v_CheckNullKHOBAQD = 0 or K.id is null) -- Chua dong bo
                            AND bicao.vuanid is not null
                            AND (v_VUANID is null or ptba.VUANID = v_VUANID)
                            ----------- TH3: Lay QUYẾT ĐỊNH PT
                            UNION
                            SELECT DISTINCT
                                va.id              AS vuanid,
                                va.id        AS DONID,
                                ptqd.soquyetdinh   AS SO_BAN_AN,
                                to_char(ptqd.ngayqd, 'dd/MM/yyyy') AS banan_ngay_ba,
                                dm.ma              AS macq,
                                dm.ten             AS tencq,
                                dm.id              AS toaanId,
                                dc.id              AS thamphanid,
                                dc.hoten           AS thamphan_ten,
                                '1' AS LOAIAN_ID,
                                'Hình Sự' AS loai_an_ten,
                                '1' AS loaibaqd,  --Ban an = 0, 1 Quyet dinh
                                ptqd.id            AS baqd_id,
                                to_char(va.mavuan) AS mavuan,
                                va.tenvuan,
                                decode(ast.truonghopthuly, 1079, 'Do có kháng cáo và kháng nghị phúc thẩm', 1078, 'Do có kháng nghị phúc thẩm',
                                       998, 'Giám đốc thẩm hủy để xét xử lại phúc thẩm', 1058, 'Do có kháng cáo phúc thẩm', 'Thụ lý mới')
                                || ' - số '
                                || ast.sothuly
                                || ' ngày '
                                || to_char(ast.ngaythuly, 'dd/MM/yyyy') AS thuly,
                                '3' AS capxx_ma, -- 2 sơ thẩm, 3 phúc thẩm
                                'Phúc Thẩm' AS capxx,
                                to_char(va.ngaytao, 'dd/MM/yyyy') AS ngaytao,
                                ptqd.nguoitao,
                                bicao.ID AS BICAODAUVU_ID,
                                bicao.HOTEN AS BICAODAUVU_HOTEN,
                                to_char(bicao.NGAYSINH, 'dd/MM/yyyy') AS BICAODAUVU_NGAYSINH,
                                bicao.SO_CCCD AS BICAODAUVU_SO_CCCD,
                                bicao.tentoidanh,
                                bicao.tenhinhphat,
                                '' as GHICHU,
                                TO_CHAR(K.NGAYTAO,'dd/MM/yyyy') AS NGAYGUI,
                                K.TAIKHOANTAO AS NGUOIGUI,
                                to_char(ptqd.ngayqd, 'dd/MM/yyyy') AS bican_ngayhieuluc,
                                'Chưa đồng bộ' AS TRANGTHAIBAQDNAME,
                                K.id as KHOBAQDID,
                                0 as SO_DUONGSU_DONGBO,
                                FN_GET_BICAO_COUNT(ptqd.id, '3', '1') AS SO_DUONGSU,
                                 null as SO_DUONGSU_CHUADONGBO,
                                 '-1' as TRANGTHAIBAQD
                            FROM ahs_phuctham_quyetdinh_vuan   ptqd
                            INNER JOIN ahs_vuan                      va ON ptqd.vuanid = va.id
                            INNER JOIN dm_toaan                      dm ON dm.id = va.toaanid
                            INNER JOIN ahs_phuctham_thuly           ast ON va.id = ast.vuanid  
                            INNER JOIN (select a.id, ROW_NUMBER() OVER (PARTITION BY a.vuanid ORDER BY a.id DESC ) AS rn
                                        from ahs_phuctham_quyetdinh_vuan a
                                        join DM_QD_QUYETDINH d on a.QUYETDINHID = d.id 
                                       ) qd on ptqd.id = qd.id and qd.rn = 1 --lấy quyết định mới nhất
                            LEFT JOIN (SELECT atp.*
                                        FROM ahs_thamphangiaiquyet atp
                                        WHERE atp.mavaitro = 'VTTP_GIAIQUYETPHUCTHAM' 
                                                AND atp.id = (SELECT MAX(id) FROM ahs_thamphangiaiquyet WHERE vuanid = atp.vuanid AND mavaitro = 'VTTP_GIAIQUYETPHUCTHAM')
                                        ) atpgq ON atpgq.vuanid = va.id
                            LEFT JOIN dm_canbo                      dc ON dc.id = atpgq.canboid
                            LEFT JOIN (SELECT KH.ID, KH.IDBAQD, KH.TAIKHOANTAO, KH.NGAYTAO, KH.DONID
                                FROM KHOBAQD KH 
                                WHERE KH.CAPXX = 3 -- 2: sơ thẩm
                                AND KH.LINHVUC = 'AHS' AND KH.STATUS = 1) K ON ptqd.VUANID = K.DONID
                            LEFT JOIN (SELECT bcbc.ID, ptbc.VUANID, bcbc.HOTEN, bcbc.NGAYSINH, bcbc.SO_CCCD, thhp.tentoidanh_pt tentoidanh, to_char(thhp.hinhphat_pt) AS tenhinhphat
                                        FROM AHS_PHUCTHAM_BICANBICAO ptbc
                                        JOIN AHS_BICANBICAO bcbc ON ptbc.BICANID = bcbc.ID
                                        LEFT JOIN ahs_tonghophinhphat thhp ON thhp.bicaoid = bcbc.id 
                                        WHERE bcbc.BICANDAUVU = 1
                                        and ((bcbc.LOAIDOITUONG = 0 AND bcbc.QUOCTICHID = 2 AND bcbc.XACTHUC_DLDCQG = 1)
                                     OR
                                     (bcbc.LOAIDOITUONG in (1,2) AND bcbc.XACTHUC_DLDCQG = 1)
                                     )
                                      ) bicao ON ptqd.VUANID = bicao.VUANID
                            WHERE va.toaanid = v_toaan_id AND (v_CheckNullKHOBAQD = 0 or K.id is null) -- Chua dong bo
                            AND bicao.vuanid is not null
                            AND (v_VUANID is null or ptqd.VUANID = v_VUANID)
                     ) A
                     where (v_LOAIBAQD is null OR A.LOAIBAQD = v_LOAIBAQD)
                        AND (v_BAQD_id is null OR A.BAQD_id=v_BAQD_id)
                        AND (v_Capxx is null OR (v_Capxx = 2 and  A.CAPXX = 'Sơ Thẩm') OR (v_Capxx = 3 and  A.CAPXX = 'Phúc Thẩm') )
                        AND (v_ten_vu_an IS NULL OR FN_CONVERT_TO_VN(UPPER(A.TenVuAn)) LIKE '%'||FN_CONVERT_TO_VN(UPPER(v_ten_vu_an))||'%')
                        AND (v_ma_vu_an IS NULL OR A.MavuAn = v_ma_vu_an)
                        AND (v_bi_can IS NULL OR FN_CONVERT_TO_VN(UPPER(A.BICAODAUVU_HOTEN)) LIKE '%'||FN_CONVERT_TO_VN(UPPER(v_bi_can))||'%')
                        AND (v_cccd  IS NULL OR A.BICAODAUVU_SO_CCCD = v_cccd)
                        AND (v_so_qd  IS NULL OR A.SO_BAN_AN = v_so_qd)
                        AND (V_TUNGAY IS NULL OR A.banan_ngay_ba >= V_TUNGAY)
                        AND (V_DENNGAY IS NULL OR A.banan_ngay_ba <= V_DENNGAY)
                        AND (v_toidanh IS NULL OR (FN_CONVERT_TO_VN(LOWER(A.TenVuAn)) LIKE '%'||FN_CONVERT_TO_VN(LOWER(v_toidanh))||'%' ) )--Quan hệ pháp luật tìm quan hệ pháp luật đã được gắn vào tên vụ án
                        AND (v_thamphan_id is null OR A.thamphanid = v_thamphan_id)
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
                
                      SELECT    va.id AS DONID,
                                COALESCE(bicao.SO_BAN_AN, B.SOBAQD) AS SO_BAN_AN,
                                COALESCE(bicao.banan_ngay_ba, to_char(B.NGAYBAQD, 'dd/MM/yyyy')) AS banan_ngay_ba,
                                COALESCE(bicao.BANANID, B.IDBAQD) AS baqd_id,
                                dm.ma              AS macq,
                                dm.ten             AS tencq,
                                dm.id              AS toaanId,
                                '1' AS loaian_id,
                                'Hình Sự' AS loai_an_ten,
                                B.LOAIBAQD,  --Ban an = 0, 1 Quyet dinh
                                B.CAPXX AS capxx_ma, -- 2 sơ thẩm, 3 phúc thẩm
                                DECODE(B.CAPXX, '2', 'Sơ Thẩm', '3', 'Phúc Thẩm') AS capxx,
                                to_char(va.mavuan) AS mavuan,
                                va.tenvuan,
                                to_char(va.ngaytao, 'dd/MM/yyyy') AS ngaytao,
                                va.NGUOITAO,                                
                                decode(tl.truonghopthuly, 1079, 'Do có kháng cáo và kháng nghị phúc thẩm', 1078, 'Do có kháng nghị phúc thẩm',
                                       998, 'Giám đốc thẩm hủy để xét xử lại phúc thẩm', 1058, 'Do có kháng cáo phúc thẩm', 'Thụ lý mới')
                                || ' - số ' || tl.sothuly || ' ngày ' || to_char(tl.ngaythuly, 'dd/MM/yyyy') AS thuly,
                                dc.id              AS thamphanid,
                                dc.hoten           AS thamphan_ten,                                
                                bicao.ID AS BICAODAUVU_ID,
                                bicao.HOTEN AS BICAODAUVU_HOTEN,
                                to_char(bicao.NGAYSINH, 'dd/MM/yyyy') AS BICAODAUVU_NGAYSINH,
                                bicao.SO_CCCD AS BICAODAUVU_SO_CCCD,
                                bicao.tentoidanh,
                                bicao.tenhinhphat,
                                bicao.bican_ngayhieuluc,
                                B.GHICHU,
                                B.STATUS AS trangThaiBanGhi,
                                TO_CHAR(B.NGAYTAO,'dd/MM/yyyy') AS NGAYGUI,
                                B.TAIKHOANTAO AS NGUOIGUI,
                                B.TRANGTHAIBAQD,
                            CASE 
                                WHEN B.TRANGTHAIBAQD = 0 THEN 'Đang đồng bộ'
                                WHEN B.TRANGTHAIBAQD IN (1,2) THEN 'Đã đồng bộ'
                                WHEN B.TRANGTHAIBAQD IN (3, 4, 5) THEN 'Đã thu hồi'
                                ELSE 'Không xác định'
                            END AS TRANGTHAIBAQDNAME,
                                B.ID as KHOBAQDID,
                                (SELECT COUNT(*)
                             FROM KHOBAQD_DUONGSU DS
                             WHERE DS.KHOBAQDID = B.ID and STATUS = 1) AS SO_DUONGSU_DONGBO,
                             FN_GET_BICAO_COUNT(COALESCE(bicao.BANANID, B.IDBAQD), B.CAPXX, COALESCE(bicao.LOAIBAQD, B.LOAIBAQD)) AS SO_DUONGSU,
                             FN_GET_BICAO_COUNT(COALESCE(bicao.BANANID, B.IDBAQD), B.CAPXX, COALESCE(bicao.LOAIBAQD, B.LOAIBAQD))
                              - (SELECT COUNT(*)
                                 FROM KHOBAQD_DUONGSU DS
                                 WHERE DS.KHOBAQDID = B.ID AND STATUS = 1) AS SO_DUONGSU_CHUADONGBO
                        FROM KHOBAQD B
                        LEFT JOIN AHS_VUAN va ON B.DONID = va.id
                        LEFT JOIN dm_toaan dm ON dm.id = va.toaanid
                        --lay thong tin thu ly
                        LEFT JOIN (SELECT truonghopthuly, sothuly, ngaythuly, VUANID, 2 AS CAPXX --SƠ THẨM 
                                    FROM ahs_sotham_thuly 
                                    UNION
                                    SELECT truonghopthuly, sothuly, ngaythuly, VUANID, 3 AS CAPXX --PHÚC THẨM
                                    FROM ahs_phuctham_thuly                                     
                                  ) tl ON tl.VUANID = B.DONID AND tl.CAPXX = B.CAPXX
                        --lay thong tin can bo
                        LEFT JOIN (SELECT canboid, VUANID, 2 AS CAPXX --SƠ THẨM 
                                    FROM ahs_thamphangiaiquyet atp
                                    WHERE atp.mavaitro = 'VTTP_GIAIQUYETSOTHAM' AND atp.id = (SELECT MAX(id) FROM ahs_thamphangiaiquyet WHERE vuanid = atp.vuanid AND mavaitro = 'VTTP_GIAIQUYETSOTHAM')
                                    UNION
                                    SELECT canboid, VUANID, 3 AS CAPXX --PHÚC THẨM 
                                    FROM ahs_thamphangiaiquyet atp
                                    WHERE atp.mavaitro = 'VTTP_GIAIQUYETPHUCTHAM' AND atp.id = (SELECT MAX(id) FROM ahs_thamphangiaiquyet WHERE vuanid = atp.vuanid AND mavaitro = 'VTTP_GIAIQUYETPHUCTHAM')
                                  ) tpgq ON tpgq.VUANID = B.DONID AND tpgq.CAPXX = B.CAPXX
                        LEFT JOIN dm_canbo dc ON dc.id = tpgq.canboid
                        --lay thong tin bi can bi cao
                        LEFT JOIN (
                                    SELECT *
                                    FROM (SELECT bicao.ID,
                                            bicao.SO_BAN_AN,
                                            bicao.banan_ngay_ba,
                                            bicao.BANANID,
                                            bicao.HOTEN,
                                            bicao.NGAYSINH,
                                            bicao.SO_CCCD,
                                            bicao.VUANID,
                                            bicao.tentoidanh,
                                            bicao.CAPXX,
                                            bicao.tenhinhphat,
                                            bicao.bican_ngayhieuluc,
                                            bicao.LOAIBAQD,
                                            ROW_NUMBER() OVER (PARTITION BY NVL(bicao.BANANID, bicao.VUANID), bicao.CAPXX, bicao.LOAIBAQD ORDER BY TO_DATE(bicao.bican_ngayhieuluc, 'dd/MM/yyyy') DESC) rn
                                        FROM (
                                            /* ================== SƠ THẨM ================== */
                                            SELECT bcbc.ID,
                                                stba.sobanan AS SO_BAN_AN,
                                                to_char(stba.ngaybanan, 'dd/MM/yyyy') AS banan_ngay_ba,
                                                stbc.BANANID,
                                                bcbc.HOTEN,
                                                bcbc.NGAYSINH,
                                                bcbc.SO_CCCD,
                                                thhp.VUANID,
                                                thhp.tentoidanh_st AS tentoidanh,
                                                2 AS CAPXX, -- SƠ THẨM
                                                TO_CHAR(thhp.hinhphat_st) AS tenhinhphat,
                                                TO_CHAR(stbc.ngayhieulucbanan, 'dd/MM/yyyy') AS bican_ngayhieuluc,
                                                0 AS LOAIBAQD -- BẢN ÁN
                                            FROM AHS_SOTHAM_BANAN_BICAO stbc 
                                            JOIN AHS_SOTHAM_BANAN stba ON stbc.BANANID = stba.ID
                                            JOIN AHS_BICANBICAO bcbc ON stbc.BICAOID = bcbc.ID
                                            LEFT JOIN ahs_tonghophinhphat thhp ON thhp.bicaoid = bcbc.ID
                                            WHERE bcbc.BICANDAUVU = 1 and stbc.ngayhieulucbanan IS NOT NULL
                                
                                            UNION ALL
                                
                                            /* ================== PHÚC THẨM - BẢN ÁN ================== */
                                            SELECT bcbc.ID,
                                                ptba.SOBANAN AS SO_BAN_AN,
                                                to_char(ptba.ngaybanan, 'dd/MM/yyyy') AS banan_ngay_ba,
                                                ptbc.BANANID,
                                                bcbc.HOTEN,
                                                bcbc.NGAYSINH,
                                                bcbc.SO_CCCD,
                                                thhp.VUANID,
                                                thhp.tentoidanh_pt AS tentoidanh,
                                                3 AS CAPXX, -- PHÚC THẨM
                                                TO_CHAR(thhp.hinhphat_pt) AS tenhinhphat,
                                                TO_CHAR(ptbc.NGAYNHANBANAN, 'dd/MM/yyyy') AS bican_ngayhieuluc,
                                                0 AS LOAIBAQD -- BẢN ÁN
                                            FROM AHS_PHUCTHAM_BANAN_BICAO ptbc
                                            JOIN ahs_phuctham_banan ptba ON ptbc.BANANID = ptba.ID
                                            JOIN AHS_BICANBICAO bcbc  ON ptbc.BICAOID = bcbc.ID
                                            LEFT JOIN ahs_tonghophinhphat thhp  ON thhp.bicaoid = bcbc.ID
                                            WHERE bcbc.BICANDAUVU = 1 and ptbc.NGAYNHANBANAN IS NOT NULL
                                
                                            UNION ALL
                                
                                            /* ================== PHÚC THẨM - QUYẾT ĐỊNH ================== */
                                            SELECT 
                                                bcbc.ID,
                                                ptqdva.soquyetdinh AS SO_BAN_AN,
                                                to_char(ptqdva.ngayqd, 'dd/MM/yyyy') AS banan_ngay_ba,
                                                ptqdva.ID AS BANANID,
                                                bcbc.HOTEN,
                                                bcbc.NGAYSINH,
                                                bcbc.SO_CCCD,
                                                ptqdva.VUANID,
                                                thhp.tentoidanh_pt AS tentoidanh,
                                                3 AS CAPXX, -- PHÚC THẨM
                                                TO_CHAR(thhp.hinhphat_pt) AS tenhinhphat,
                                                TO_CHAR(ptqdva.ngayqd, 'dd/MM/yyyy') AS bican_ngayhieuluc,
                                                1 AS LOAIBAQD -- QUYẾT ĐỊNH
                                            FROM ahs_phuctham_quyetdinh_vuan ptqdva
                                            JOIN AHS_PHUCTHAM_BICANBICAO ptbcbc ON ptqdva.VUANID = ptbcbc.VUANID
                                            JOIN AHS_BICANBICAO bcbc ON ptbcbc.BICANID = bcbc.ID
                                            LEFT JOIN ahs_tonghophinhphat thhp ON thhp.bicaoid = bcbc.ID
                                            WHERE bcbc.BICANDAUVU = 1 and ptqdva.HIEULUCTU is not null
                                        ) bicao
                                    )
                                    WHERE rn = 1
                                ) bicao ON (B.IDBAQD = bicao.BANANID OR B.DONID = bicao.VUANID) AND B.CAPXX = bicao.CAPXX
                    where B.LINHVUC = 'AHS'  and
                        (V_TRANGTHAIDONGBO = 2 AND TRANGTHAIBAQD IN (0,1,2))
                        OR
                        (V_TRANGTHAIDONGBO = 3 AND TRANGTHAIBAQD IN (3,4,5)) and b.STATUS = 1
                            AND dm.id = v_toaan_id
                            AND (v_LOAIBAQD is null OR B.LOAIBAQD = v_LOAIBAQD)
                            AND (v_BAQD_id is null  OR B.IDBAQD=v_BAQD_id)
                            AND (v_Capxx is null OR  b.CAPXX = v_Capxx)
                            AND (v_ten_vu_an IS NULL OR FN_CONVERT_TO_VN(UPPER(va.tenvuan)) LIKE '%'||FN_CONVERT_TO_VN(UPPER(v_ten_vu_an))||'%')                            
                            AND (v_ma_vu_an IS NULL OR va.mavuan = v_ma_vu_an)
                            AND (v_bi_can IS NULL OR FN_CONVERT_TO_VN(UPPER(bicao.HOTEN)) LIKE '%'||FN_CONVERT_TO_VN(UPPER(v_bi_can))||'%')
                            AND (v_cccd  IS NULL OR bicao.SO_CCCD = v_cccd)
                            AND (v_so_qd  IS NULL OR b.SOBAQD = v_so_qd)
                            AND (V_TUNGAY IS NULL OR B.NGAYBAQD >= V_TUNGAY)
                            AND (V_DENNGAY IS NULL OR B.NGAYBAQD <= V_DENNGAY)
                            AND (v_toidanh IS NULL  OR (FN_CONVERT_TO_VN(LOWER(va.tenvuan)) LIKE  '%'||FN_CONVERT_TO_VN(LOWER(v_toidanh))||'%' ) )--Quan hệ pháp luật tìm quan hệ pháp luật đã được gắn vào tên vụ án
                            AND (v_thuky_id IS NULL 
                                    OR EXISTS(select 'X' from AHS_SoTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.VUANID=b.DONID) 
                                    OR EXISTS(select 'X' from AHS_PhucTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.VUANID=b.DONID)
                                )
                        AND (v_thamphan_id is null OR dc.id = v_thamphan_id)
                        
                        ORDER by B.id
                        )A
                )tt where tt.stt>=MinIndex and tt.stt<=MaxIndex
    ;
END EXT_SEARCH_ALL_DaDongBo_ThuHoi;

FUNCTION FN_GET_BICAO_COUNT(
    v_BAQD_id IN NUMBER,
    v_Capxx IN VARCHAR2,
    v_LOAIBAQD IN VARCHAR2
    
) RETURN NUMBER
IS
    v_count NUMBER := 0;
BEGIN
    IF v_Capxx = '2' AND v_LOAIBAQD = '0' THEN --SƠ THẨM BẢN ÁN
            SELECT count(*) into v_count
            FROM AHS_SOTHAM_BANAN_BICAO stbc
            JOIN AHS_BICANBICAO bcbc ON stbc.BICAOID = bcbc.ID
            WHERE stbc.BANANID = v_BAQD_id and stbc.ngayhieulucbanan IS NOT NULL
            and ((bcbc.LOAIDOITUONG = 0 AND bcbc.QUOCTICHID = 2 AND bcbc.XACTHUC_DLDCQG = 1)
                                     OR
                                     (bcbc.LOAIDOITUONG in (1,2) AND bcbc.XACTHUC_DLDCQG = 1)
                                    );
    ELSIF v_Capxx = '3' AND v_LOAIBAQD = '0' THEN --PHÚC THẨM BẢN ÁN
              SELECT count(*) into v_count
                FROM AHS_PHUCTHAM_BANAN_BICAO ptbc
                JOIN AHS_BICANBICAO bcbc ON ptbc.BICAOID = bcbc.ID	
                 WHERE ptbc.BANANID = v_BAQD_id and ptbc.NGAYNHANBANAN IS NOT NULL
                 and ((bcbc.LOAIDOITUONG = 0 AND bcbc.QUOCTICHID = 2 AND bcbc.XACTHUC_DLDCQG = 1)
                                     OR
                                     (bcbc.LOAIDOITUONG in (1,2) AND bcbc.XACTHUC_DLDCQG = 1)
                                     );
    ELSIF v_Capxx = '3' AND v_LOAIBAQD = '1' THEN --PHÚC THẨM QUYẾT ĐỊNH
            SELECT count(*) into v_count
            FROM ahs_phuctham_quyetdinh_vuan        ba 
            JOIN (SELECT ptbc.VUANID PT_VUANID
                    FROM AHS_PHUCTHAM_BICANBICAO ptbc
                   JOIN AHS_BICANBICAO bcbc ON ptbc.BICANID = bcbc.ID
                   where  ((bcbc.LOAIDOITUONG = 0 AND bcbc.QUOCTICHID = 2 AND bcbc.XACTHUC_DLDCQG = 1)
                                     OR
                                     (bcbc.LOAIDOITUONG in (1,2) AND bcbc.XACTHUC_DLDCQG = 1)
                                     )
                  ) bicao ON ba.VUANID = bicao.PT_VUANID
             WHERE ba.ID = v_BAQD_id and ba.HIEULUCTU is not null;
    END IF;  
    
    RETURN v_count;
END FN_GET_BICAO_COUNT;


PROCEDURE GET_BICANBICAO_BY_BAQDID
(
    v_BAQD_id in varchar2,
    v_LOAIBAQD in varchar2,
    v_Capxx in varchar2,
    curReturn OUT sys_refcursor
)
AS    
BEGIN
    IF v_Capxx = '2' AND v_LOAIBAQD = '0' THEN --SƠ THẨM BẢN ÁN
        OPEN CURRETURN FOR
             SELECT ba.sobanan AS SO_BAN_AN,
                    to_char(ba.ngaybanan, 'dd/MM/yyyy') AS banan_ngay_ba,
                    'AHS' AS loaian_id,
                    'Hình Sự' AS loai_an_ten,
                    '0' AS loaibaqd,  --Ban an = 
                    ba.id        AS baqd_id,
                    '2' AS capxx_ma,
                    'Sơ Thẩm' AS capxx,
                    'Chưa đồng bộ' AS trangthaibanghi,
                    'CDB' AS ma_trangthaibanghi,
                    bicao.*
            FROM ahs_sotham_banan        ba 
            JOIN (SELECT bcbc.*, stbc.BANANID, thhp.tentoidanh_st tentoidanh, to_char(thhp.hinhphat_st) AS tenhinhphat, to_char(stbc.ngayhieulucbanan, 'dd/MM/yyyy') AS bicao_ngayhieuluc
                    FROM AHS_SOTHAM_BANAN_BICAO stbc
                    JOIN AHS_BICANBICAO bcbc ON stbc.BICAOID = bcbc.ID
                    LEFT JOIN ahs_tonghophinhphat thhp ON thhp.bicaoid = bcbc.id
                    WHERE bcbc.XACTHUC_DLDCQG = '1' and stbc.ngayhieulucbanan IS NOT NULL
                 ) bicao ON ba.ID = bicao.BANANID
            LEFT JOIN KHOBAQD K ON ba.ID = K.IDBAQD AND K.CAPXX = 2 -- 2: sơ thẩm
                                    AND K.LOAIBAQD = 0 -- 0: bản án
                                    AND K.LINHVUC = 'AHS' AND K.STATUS = 1
            WHERE ba.ID = v_BAQD_id and bicao.bicao_ngayhieuluc is not null ;
    ELSIF v_Capxx = '3' AND v_LOAIBAQD = '0' THEN --PHÚC THẨM BẢN ÁN
        OPEN CURRETURN FOR
              SELECT ba.sobanan   AS SO_BAN_AN,
                     to_char(ba.ngaybanan, 'dd/MM/yyyy') AS banan_ngay_ba,
                     'AHS' AS loaian_id,
                     'Hình Sự' AS loai_an_ten,
                     '0' AS loaibaqd,  --Ban an = 
                     ba.id        AS baqd_id,
                     '3' AS capxx_ma, -- 2 sơ thẩm, 3 phúc thẩm
                     'Phúc Thẩm' AS capxx,
                     'Chưa đồng bộ' AS trangthaibanghi,
                     'CDB' AS ma_trangthaibanghi,																
                     bicao.*
                 FROM ahs_phuctham_banan        ba 
                 JOIN (SELECT bcbc.*, ptbc.BANANID, thhp.tentoidanh_pt tentoidanh, to_char(thhp.hinhphat_pt) AS tenhinhphat,ptbc.NGAYNHANBANAN
                       FROM AHS_PHUCTHAM_BANAN_BICAO ptbc
                       JOIN AHS_BICANBICAO bcbc ON ptbc.BICAOID = bcbc.ID
                       LEFT JOIN ahs_tonghophinhphat thhp ON thhp.bicaoid = bcbc.id 
                       WHERE bcbc.XACTHUC_DLDCQG = '1' and ptbc.NGAYNHANBANAN IS NOT NULL
                      ) bicao ON ba.ID = bicao.BANANID
                 LEFT JOIN KHOBAQD K ON ba.ID = K.IDBAQD AND K.CAPXX = 3 -- 3: phúc thẩm
                                 AND K.LOAIBAQD = 0 -- 0: bản án
                                 AND K.LINHVUC = 'AHS' AND K.STATUS = 1 								
                 WHERE ba.ID = v_BAQD_id and bicao.NGAYNHANBANAN is not null;
    ELSIF v_Capxx = '3' AND v_LOAIBAQD = '1' THEN --PHÚC THẨM QUYẾT ĐỊNH
        OPEN CURRETURN FOR
            SELECT ba.soquyetdinh   AS SO_BAN_AN,
                to_char(ba.ngayqd, 'dd/MM/yyyy') AS banan_ngay_ba,
                'AHS' AS loaian_id,
                'Hình Sự' AS loai_an_ten,
                '1' AS loaibaqd,  --quyết định 
                ba.id        AS baqd_id,
                '3' AS capxx_ma, -- 2 sơ thẩm, 3 phúc thẩm
                'Phúc Thẩm' AS capxx,
                'Chưa đồng bộ' AS trangthaibanghi,
                'CDB' AS ma_trangthaibanghi,																
                bicao.*
            FROM ahs_phuctham_quyetdinh_vuan        ba 
            JOIN (SELECT bcbc.*, ptbc.VUANID PT_VUANID, thhp.tentoidanh_pt tentoidanh, to_char(thhp.hinhphat_pt) AS tenhinhphat
                    FROM AHS_PHUCTHAM_BICANBICAO ptbc
                    JOIN AHS_BICANBICAO bcbc ON ptbc.BICANID = bcbc.ID
                    LEFT JOIN ahs_tonghophinhphat thhp ON thhp.bicaoid = bcbc.id
                    WHERE bcbc.XACTHUC_DLDCQG = '1'
                  ) bicao ON ba.VUANID = bicao.PT_VUANID
            LEFT JOIN KHOBAQD K ON ba.ID = K.IDBAQD AND K.CAPXX = 3 -- 3: phúc thẩm
                             AND K.LOAIBAQD = 1 -- 1: quyết định
                             AND K.LINHVUC = 'AHS' AND K.STATUS = 1 								
             WHERE ba.ID = v_BAQD_id and ba.HIEULUCTU is not null;
    END IF;    
END GET_BICANBICAO_BY_BAQDID;
    
PROCEDURE get_toidanh_by_bicao (
    vbicaoid    IN NUMBER,
    v_capxx     IN VARCHAR2,
    v_loaiba_qd IN VARCHAR2,
    curretun    OUT SYS_REFCURSOR
) AS
    v_quyetdinhid NUMBER;
    v_count       NUMBER;
BEGIN
    CASE
        WHEN v_capxx = '2' THEN -- nếu là sơ thẩm
            BEGIN
                OPEN curretun FOR 
                    SELECT DISTINCT dmbt.id, dmbt.tentoidanh
                    FROM ahs_sotham_banan_dieu_chitiet asbdc
                    LEFT JOIN dm_boluat_toidanh dmbt ON dmbt.id = asbdc.toidanhid
                    WHERE asbdc.bicanid = vbicaoid;
                END;
        ELSE
            IF (v_loaiba_qd = '1') THEN
                SELECT a.ketquaphucthamid INTO v_quyetdinhid
                FROM ahs_phuctham_banan a
                INNER JOIN ahs_phuctham_banan_bicao b ON b.bananid = a.id
                WHERE b.bicaoid = vbicaoid;

                IF (v_quyetdinhid = 1) THEN -- nếu giữ nguyên thì lấy ở sơ thẩm
                    OPEN curretun FOR 
                        SELECT DISTINCT dmbt.id, dmbt.tentoidanh
                        FROM ahs_sotham_banan_dieu_chitiet asbdc
                        LEFT JOIN dm_boluat_toidanh dmbt ON dmbt.id = asbdc.toidanhid
                        WHERE asbdc.bicanid = vbicaoid;
                ELSE -- không thì lấy ở phúc thẩm
                    --Kiểm tra thêm logic nếu không có kháng cáo thì lấy theo phúc thẩm, có kháng cáo thì lấy theo sơ thẩm
                    -- Lấy số lượng
                    SELECT COUNT(1) INTO v_count
                    FROM ahs_sotham_khangcao a
                    JOIN ahs_sotham_rutkhangcao b ON a.id = b.khangcaoid
                    WHERE a.nguoikcid = vbicaoid;

                    IF v_count > 0 THEN
                        OPEN curretun FOR 
                            SELECT DISTINCT dmbt.id, dmbt.tentoidanh
                            FROM ahs_sotham_banan_dieu_chitiet asbdc
                            LEFT JOIN dm_boluat_toidanh dmbt ON dmbt.id = asbdc.toidanhid
                            WHERE asbdc.bicanid = vbicaoid;
                    ELSE
                        OPEN curretun FOR 
                            SELECT DISTINCT dmbt.id, dmbt.tentoidanh
                            FROM ahs_phuctham_banan_dieu_ct asbdc
                            LEFT JOIN dm_boluat_toidanh dmbt ON dmbt.id = asbdc.toidanhid
                            WHERE asbdc.bicanid = vbicaoid;
                    END IF;
                END IF;
            ELSE -- nếu là quyết định lấy ở sơ thẩm
                OPEN curretun FOR 
                    SELECT DISTINCT dmbt.id, dmbt.tentoidanh
                    FROM ahs_sotham_banan_dieu_chitiet asbdc
                    LEFT JOIN dm_boluat_toidanh dmbt ON dmbt.id = asbdc.toidanhid
                    WHERE asbdc.bicanid = vbicaoid;
            END IF;
    END CASE;
END;

PROCEDURE get_hinhphat_by_toidanh_bicao (
    vbicaoid    IN NUMBER,
    v_toidanhId in number,
    v_capxx     IN VARCHAR2,
    v_loaiba_qd IN VARCHAR2,
    curreturn   OUT SYS_REFCURSOR
) AS
    v_quyetdinhid NUMBER;
BEGIN
    CASE
        WHEN v_capxx = '2' THEN -- nếu là sơ thẩm
            OPEN curreturn FOR 
                SELECT dm.*, asbdc.*
                FROM ahs_sotham_banan_dieu_chitiet asbdc
                INNER JOIN dm_hinhphat dm ON asbdc.hinhphatid = dm.id
                WHERE asbdc.bicanid = vbicaoid AND asbdc.toidanhid = v_toidanhId;
        ELSE
            IF (v_loaiba_qd = '0') THEN -- 0 là bản án
                -- Kiểm tra quyetdinhid
                SELECT a.ketquaphucthamid INTO v_quyetdinhid
                FROM ahs_phuctham_banan a
                INNER JOIN ahs_phuctham_banan_bicao b ON b.bananid = a.id
                WHERE b.bicaoid = vbicaoid;
                
                IF (v_quyetdinhid = 1) THEN -- nếu giữ nguyên thì lấy ở sơ thẩm
                    OPEN curreturn FOR
                        SELECT dm.*, asbdc.*
                        FROM ahs_sotham_banan_dieu_chitiet asbdc
                        INNER JOIN dm_hinhphat dm ON asbdc.hinhphatid = dm.id
                        WHERE asbdc.bicanid = vbicaoid AND asbdc.toidanhid = v_toidanhId;
                ELSE -- không thì lấy ở phúc thẩm
                    OPEN curreturn FOR 
                        SELECT dm.*, asbdc.*
                        FROM ahs_phuctham_banan_dieu_ct asbdc
                        INNER JOIN dm_hinhphat dm ON asbdc.hinhphatid = dm.id
                        WHERE asbdc.bicanid = vbicaoid AND asbdc.toidanhid = v_toidanhId;
                END IF;
            ELSE -- nếu là quyết định lấy ở sơ thẩm
                OPEN curreturn FOR 
                    SELECT dm.*, asbdc.*
                    FROM ahs_sotham_banan_dieu_chitiet asbdc
                    INNER JOIN dm_hinhphat dm ON asbdc.hinhphatid = dm.id
                    WHERE asbdc.bicanid = vbicaoid AND asbdc.toidanhid = v_toidanhId;
            END IF;
    END CASE;
END;

PROCEDURE GET_PAGING_BICANBICAO_BY_BAQDID
(
    v_BAQD_id in varchar2,
    v_LOAIBAQD in varchar2,
    v_Capxx in varchar2,
    v_trangthai in varchar2,
    
    Page_Index in	int,
    Page_Size	in	int,
    curReturn OUT sys_refcursor
)
AS
     MinIndex number; MaxIndex number;
BEGIN
    MinIndex := Page_Size*(Page_Index - 1) + 1;
    MaxIndex := Page_Index*Page_Size;
    
    IF v_Capxx = '2' AND v_LOAIBAQD = '0' THEN --SƠ THẨM BẢN ÁN
        OPEN CURRETURN FOR
            SELECT * 
            FROM (SELECT ROW_NUMBER() OVER (ORDER BY ba.ngaybanan desc) STT, COUNT(*) OVER () as CountAll,
                            ba.sobanan AS SO_BAN_AN,
                            to_char(ba.ngaybanan, 'dd/MM/yyyy') AS banan_ngay_ba,
                            'AHS' AS loaian_id,
                            'Hình Sự' AS loai_an_ten,
                            '0' AS loaibaqd,  --Ban an = 
                            ba.id        AS baqd_id,
                            '2' AS capxx_ma,
                            'Sơ Thẩm' AS capxx,
                            'Chưa đồng bộ' AS trangthaibanghi,
                            'CDB' AS ma_trangthaibanghi,
                            bicao.*
                    FROM ahs_sotham_banan        ba 
                    JOIN (SELECT bcbc.*, stbc.BANANID, thhp.tentoidanh_pt tentoidanh, 
                    to_char(thhp.hinhphat_pt) AS tenhinhphat
                            FROM AHS_SOTHAM_BANAN_BICAO stbc
                            JOIN AHS_BICANBICAO bcbc ON stbc.BICAOID = bcbc.ID
                            LEFT JOIN ahs_tonghophinhphat thhp ON thhp.bicaoid = bcbc.id 
                            WHERE stbc.ngayhieulucbanan IS NOT NULL
                         ) bicao ON ba.ID = bicao.BANANID
                    LEFT JOIN KHOBAQD K ON ba.ID = K.IDBAQD AND K.CAPXX = 2 -- 2: sơ thẩm
                                            AND K.LOAIBAQD = 0 -- 0: bản án
                                            AND K.LINHVUC = 'AHS' AND K.STATUS = 1
                    WHERE ba.ID = v_BAQD_id 
                    AND (v_trangthai IS NULL OR (v_trangthai = 0 AND K.id IS NULL) OR v_trangthai = 1 AND K.id IS NOT NULL) --tất cả|chưa đồng bộ|đã đồng bộ
                  ) tt WHERE tt.stt>=MinIndex and tt.stt<=MaxIndex;
    ELSIF v_Capxx = '3' AND v_LOAIBAQD = '0' THEN --PHÚC THẨM BẢN ÁN
        OPEN CURRETURN FOR
            SELECT * 
            FROM (SELECT ROW_NUMBER() OVER (ORDER BY ba.ngaybanan desc) STT, COUNT(*) OVER () as CountAll,
                        ba.sobanan   AS SO_BAN_AN,
                        to_char(ba.ngaybanan, 'dd/MM/yyyy') AS banan_ngay_ba,
                        'AHS' AS loaian_id,
                        'Hình Sự' AS loai_an_ten,
                        '0' AS loaibaqd,  --Ban an = 
                        ba.id        AS baqd_id,
                        '3' AS capxx_ma, -- 2 sơ thẩm, 3 phúc thẩm
                        'Phúc Thẩm' AS capxx,
                        'Chưa đồng bộ' AS trangthaibanghi,
                        'CDB' AS ma_trangthaibanghi,																
                        bicao.*
                    FROM ahs_phuctham_banan        ba 
                    JOIN (SELECT bcbc.*, ptbc.BANANID, thhp.tentoidanh_pt tentoidanh, 
                    to_char(thhp.hinhphat_pt) AS tenhinhphat
                           FROM AHS_PHUCTHAM_BANAN_BICAO ptbc
                           JOIN AHS_BICANBICAO bcbc ON ptbc.BICAOID = bcbc.ID
                           LEFT JOIN ahs_tonghophinhphat thhp ON thhp.bicaoid = bcbc.id 
                          ) bicao ON ba.ID = bicao.BANANID
                    LEFT JOIN KHOBAQD K ON ba.ID = K.IDBAQD AND K.CAPXX = 3 -- 3: phúc thẩm
                                     AND K.LOAIBAQD = 0 -- 0: bản án
                                     AND K.LINHVUC = 'AHS' AND K.STATUS = 1 								
                    WHERE ba.ID = v_BAQD_id 
                    AND (v_trangthai IS NULL OR (v_trangthai = 0 AND K.id IS NULL) OR v_trangthai = 1 AND K.id IS NOT NULL) --tất cả|chưa đồng bộ|đã đồng bộ
                  ) tt WHERE tt.stt>=MinIndex and tt.stt<=MaxIndex;
    ELSIF v_Capxx = '3' AND v_LOAIBAQD = '1' THEN --PHÚC THẨM QUYẾT ĐỊNH
        OPEN CURRETURN FOR
            SELECT * 
            FROM (SELECT ROW_NUMBER() OVER (ORDER BY ba.ngayqd desc) STT, COUNT(*) OVER () as CountAll,
                        ba.soquyetdinh   AS SO_BAN_AN,
                        to_char(ba.ngayqd, 'dd/MM/yyyy') AS banan_ngay_ba,
                        'AHS' AS loaian_id,
                        'Hình Sự' AS loai_an_ten,
                        '1' AS loaibaqd,  --quyết định 
                        ba.id        AS baqd_id,
                        '3' AS capxx_ma, -- 2 sơ thẩm, 3 phúc thẩm
                        'Phúc Thẩm' AS capxx,
                        'Chưa đồng bộ' AS trangthaibanghi,
                        'CDB' AS ma_trangthaibanghi,																
                        bicao.*
                    FROM ahs_phuctham_quyetdinh_vuan        ba 
                    JOIN (SELECT bcbc.*, ptbc.VUANID PT_VUANID, thhp.tentoidanh_pt tentoidanh, 
                    to_char(thhp.hinhphat_pt) AS tenhinhphat
                            FROM AHS_PHUCTHAM_BICANBICAO ptbc
                           JOIN AHS_BICANBICAO bcbc ON ptbc.BICANID = bcbc.ID
                           LEFT JOIN ahs_tonghophinhphat thhp ON thhp.bicaoid = bcbc.id 
                          ) bicao ON ba.VUANID = bicao.PT_VUANID
                    LEFT JOIN KHOBAQD K ON ba.ID = K.IDBAQD AND K.CAPXX = 3 -- 3: phúc thẩm
                                     AND K.LOAIBAQD = 1 -- 1: quyết định
                                     AND K.LINHVUC = 'AHS' AND K.STATUS = 1 								
                    WHERE ba.ID = v_BAQD_id
                    AND (v_trangthai IS NULL OR (v_trangthai = 0 AND K.id IS NULL) OR v_trangthai = 1 AND K.id IS NOT NULL) --tất cả|chưa đồng bộ|đã đồng bộ
                  ) tt WHERE tt.stt>=MinIndex and tt.stt<=MaxIndex;
    END IF;
END GET_PAGING_BICANBICAO_BY_BAQDID;

END PKG_DVCQG_DLDCQG_AHS;

/
