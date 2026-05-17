--------------------------------------------------------
--  DDL for Package Body PKG_BAN_GIAO_THI_HANH_AN
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_BAN_GIAO_THI_HANH_AN" AS

    -- [ADS] LẤY DANH SÁCH CÓ THỂ BÀN GIAO
    PROCEDURE THI_HANH_AN_BANGIAO_MAPPING_GET_AN_BAN_GIAO (
        p_LOAIAN IN NUMBER
      , p_TRANGTHAI IN NVARCHAR2
      , TOA_AN_ID   IN NUMBER
      , MA_BI_AN    IN NVARCHAR2
      , TEN_BI_AN   IN NVARCHAR2
      , MA_VU_AN    IN NVARCHAR2
      , TEN_VU_AN   IN NVARCHAR2
      , SO_BAN_AN   IN VARCHAR2
      , NGAY_BAN_AN IN DATE
      , TRANGTHAI   IN NUMBER
      , TRANGTHAIGQ   IN NUMBER
      , V_SOCMND    IN NVARCHAR2
      , V_TUNGAY    IN NVARCHAR2
      , V_DENNGAY   IN NVARCHAR2
      , p_CURSOR OUT SYS_REFCURSOR
        
    ) AS
        /*
        ================================================================================
        OPTIMIZED VERSION WITH TRANGTHAI LOGIC:

        APPROACH: High-performance với logic xử lý theo TRANGTHAI

        FEATURES:
        - Cố định 300 records per procedure call → performance ổn định
        - DISTINCT query để tránh duplicate records
        - Logic xử lý khác nhau theo p_TRANGTHAI:
          + TRANGTHAI = 0: Loại bỏ bản ghi đã có mapping với toaangiaoid = p_toaanid
          + TRANGTHAI = 1: Gọi procedures với p_TOAANID + TOTOAANID từ DM_TOAAN_TACH_NHAP_MAPPING
        - Loại trừ bản ghi mapping mà TOAANNHANID = p_TOAANID (toà hiện tại đã nhận)
        - COUNTALL chính xác từ data calls

        EXECUTION FLOW:
        - CHECK p_TRANGTHAI value
        - IF TRANGTHAI = 1: Loop qua p_TOAANID + các TOTOAANID và gọi procedures
        - IF TRANGTHAI = 0/NULL: Gọi procedures với p_TOAANID thông thường  
        - DISTINCT final query để unique results
        ================================================================================
        */

        TOTALITEM                   NUMBER;  
        MININDEX                    NUMBER; 
        MAXINDEX                    NUMBER; 
        V_TABLE_TIMKIEM             T_TIMKIEM_THA_DS;

        -- Performance optimization variables (simplified)
        V_OPTIMIZED_PAGESIZE        NUMBER DEFAULT 300; -- Fixed limit for optimal performance
        V_PROCEDURE_PAGESIZE        NUMBER;

        -- COUNTALL handling variables
        V_REAL_COUNTALL             NUMBER DEFAULT 0;
        V_COUNTALL_PROC1            NUMBER DEFAULT 0;
        V_COUNTALL_PROC2            NUMBER DEFAULT 0;

        V_THULYTUNGAY                VARCHAR2(255 CHAR);
        V_THULYDENNGAY                VARCHAR2(255 CHAR);
        V_TINHTRANGTHULY                VARCHAR2(255 CHAR);
        V_TRANGTHAIGIAIQUYET                VARCHAR2(255 CHAR);
        V_CAP_XET_XU_LOGIN                VARCHAR2(255 CHAR);

        -- Variables for p_TRANGTHAI logic
        V_TOAAN_LIST                     VARCHAR2(4000);  -- List of TOTOAANDIs for trangthai=1
        V_CURRENT_TOAANID               NUMBER;

        FETCH_IDVuAnHeThong             VARCHAR2(4000 CHAR);
        FETCH_MAVUAN	                VARCHAR2(4000 CHAR);
        FETCH_TENVUAN	                VARCHAR2(4000 CHAR);
        FETCH_STT                     VARCHAR2(4000 CHAR);
        FETCH_COUNTALL                VARCHAR2(4000 CHAR);
        FETCH_BIANID                         VARCHAR2(4000 CHAR);
        FETCH_MABIAN                    VARCHAR2(4000 CHAR);
        FETCH_TENBIAN                    VARCHAR2(4000 CHAR);
        FETCH_MAGIAIDOAN                     VARCHAR2(4000 CHAR);
        FETCH_GIAIDOANVUVIEC              VARCHAR2(4000 CHAR);
        FETCH_SOBANAN           VARCHAR2(4000 CHAR);
        FETCH_NGAYBANAN                 VARCHAR2(4000 CHAR);
        FETCH_NGAYHIEULUC                VARCHAR2(4000 CHAR);
        FETCH_VUANID                  VARCHAR2(4000 CHAR);
        FETCH_TINHTRANGGQ                   VARCHAR2(4000 CHAR);
        FETCH_NGAYVUAN                   VARCHAR2(4000 CHAR);

        SUM_COUNTALL            NUMBER DEFAULT 0;
        CURSOR_RETURN           SYS_REFCURSOR;
        CURSOR_RETURN2           SYS_REFCURSOR;
        CURSOR_RETURN3           SYS_REFCURSOR;

        PAGE_INDEX        NUMBER DEFAULT 1;


        -- PROCESS_CURSOR: Xử lý cursor và capture COUNTALL từ record đầu tiên
        PROCEDURE PROCESS_CURSOR(P_CUR IN SYS_REFCURSOR, P_TYPE VARCHAR2, P_VAR NUMBER, P_TOAANID VARCHAR2) IS
            V_IS_FIRST_RECORD BOOLEAN := TRUE;
        BEGIN
            LOOP
                BEGIN

                    IF P_VAR = 1 THEN

                         -- FETCH cho ( cột, thứ tự: STT, COUNTALL, ID, MAVUVIEC...)
                        FETCH P_CUR INTO FETCH_STT, FETCH_COUNTALL, FETCH_VUANID, FETCH_IDVuAnHeThong, FETCH_MAVUAN, 
                          FETCH_TENVUAN, FETCH_NGAYVUAN, FETCH_BIANID, FETCH_MABIAN, FETCH_TENBIAN, 
                          FETCH_MAGIAIDOAN, FETCH_GIAIDOANVUVIEC, FETCH_SOBANAN, FETCH_NGAYBANAN,
                          FETCH_NGAYHIEULUC, FETCH_TINHTRANGGQ;

                        EXIT WHEN P_CUR%NOTFOUND;

                        -- Capture COUNTALL từ record đầu tiên của procedure 2
                        IF V_IS_FIRST_RECORD THEN
                            V_COUNTALL_PROC2 := TO_NUMBER(FETCH_COUNTALL);
                            V_IS_FIRST_RECORD := FALSE;
                        END IF;

                        -- Gán giá trị cho các trường bị thiếu
--                            FETCH_NGAYVUAN := '';
--                        FETCH_TOAANID := P_TOAANID;
--                        FETCH_NGAY_TAO := FETCH_NGAYTAO;

                    ELSE
                        -- FETCH cho  (, thứ tự: ID, MAVUVIEC...)
                        FETCH P_CUR INTO FETCH_STT, FETCH_COUNTALL, FETCH_VUANID, FETCH_IDVuAnHeThong, FETCH_MAVUAN, 
                          FETCH_TENVUAN, FETCH_NGAYVUAN, FETCH_BIANID, FETCH_MABIAN, FETCH_TENBIAN, 
                          FETCH_MAGIAIDOAN, FETCH_GIAIDOANVUVIEC, FETCH_SOBANAN, FETCH_NGAYBANAN,
                          FETCH_NGAYHIEULUC, FETCH_TINHTRANGGQ;

                        EXIT WHEN P_CUR%NOTFOUND;

                        -- Capture COUNTALL từ record đầu tiên của procedure 1
                        IF V_IS_FIRST_RECORD THEN
                            V_COUNTALL_PROC1 := TO_NUMBER(FETCH_COUNTALL);
                            V_IS_FIRST_RECORD := FALSE;
                        END IF;


                    END IF;


                        -- Gán giá trị cho các trường bị thiếu
--                        FETCH_QHPLTKID := '';
--                        FETCH_TOAANID := P_TOAANID;
--                        FETCH_NGAY_TAO := FETCH_NGAYTAO;
                     -- Phần xử lý chung vẫn giữ nguyên
                    V_TABLE_TIMKIEM.EXTEND;
                    V_TABLE_TIMKIEM(V_TABLE_TIMKIEM.COUNT) := R_TIMKIEM_THA_DS(
                        FETCH_STT, FETCH_COUNTALL, FETCH_VUANID, FETCH_IDVuAnHeThong, FETCH_MAVUAN, 
                          FETCH_TENVUAN, FETCH_NGAYVUAN, FETCH_BIANID, FETCH_MABIAN, FETCH_TENBIAN, 
                          FETCH_MAGIAIDOAN, FETCH_GIAIDOANVUVIEC, FETCH_SOBANAN, FETCH_NGAYBANAN,
                          FETCH_NGAYHIEULUC, FETCH_TINHTRANGGQ
                    );


                END;
            END LOOP;
        END PROCESS_CURSOR;
    BEGIN
        IF(PAGE_INDEX > 0 AND V_OPTIMIZED_PAGESIZE > 0) THEN
         	MININDEX := V_OPTIMIZED_PAGESIZE*(PAGE_INDEX - 1) + 1;
         	MAXINDEX := PAGE_INDEX*V_OPTIMIZED_PAGESIZE ;
     	END IF;
        -- Set fixed pagesize for optimal performance
        V_PROCEDURE_PAGESIZE := V_OPTIMIZED_PAGESIZE;

--        IF p_THULYTUNGAY IS NOT NULL THEN 
--            V_THULYTUNGAY := TO_CHAR(p_THULYTUNGAY, 'DD/MM/YYYY');
--        ELSE
--            V_THULYTUNGAY := '';
--        END IF;  
--    
--        IF p_THULYDENNGAY IS NOT NULL THEN  
--            V_THULYDENNGAY := TO_CHAR(p_THULYDENNGAY, 'DD/MM/YYYY'); 
--        ELSE
--            V_THULYDENNGAY := '';
--        END IF;
--        
                SELECT LOAITOA INTO V_CAP_XET_XU_LOGIN FROM DM_TOAAN WHERE 1=1 AND ID = TOA_AN_ID;
        V_TABLE_TIMKIEM := T_TIMKIEM_THA_DS();

        -- LOGIC XỬ LÝ THEO p_TRANGTHAI
        IF p_TRANGTHAI = 1 THEN
            -- TRANGTHAI = 1: Lấy dữ liệu từ các toà được bàn giao (bao gồm cả p_TOAANID gốc)
            FOR toaan_rec IN (
                SELECT TOA_AN_ID AS TOTOAANID FROM DUAL
                UNION ALL
                SELECT TOTOAANID FROM DM_TOAAN_TACH_NHAP_MAPPING WHERE TOAANID = TOA_AN_ID
            ) LOOP
                V_CURRENT_TOAANID := toaan_rec.TOTOAANID;

--                -- BƯỚC 1: Lấy dữ liệu từ procedure 1 với TOTOAANDI
                IF p_LOAIAN = 1 THEN
                PKG_BAN_GIAO_THI_HANH_AN.THA_BIAN_GETANHSTRONGHT_PAGING(
                    V_CURRENT_TOAANID, MA_BI_AN, TEN_BI_AN, MA_VU_AN, TEN_VU_AN, SO_BAN_AN, NGAY_BAN_AN, TRANGTHAI, TRANGTHAIGQ, V_SOCMND, V_TUNGAY, V_DENNGAY , CURSOR_RETURN 
                 );
                     IF CURSOR_RETURN IS NOT NULL THEN
                        PROCESS_CURSOR(CURSOR_RETURN, '2', 1, V_CURRENT_TOAANID);
                        CLOSE CURSOR_RETURN;
                        END IF;
                ELSE

               PKG_BAN_GIAO_THI_HANH_AN.THA_BIAN_GETANNGOAIHT(
                    V_CURRENT_TOAANID
                  , MA_BI_AN 
                  , TEN_BI_AN
                  , MA_VU_AN 
                  , TEN_VU_AN
                  , SO_BAN_AN
                  , NGAY_BAN_AN
                  , TRANGTHAI
                  , TRANGTHAIGQ
                  , V_SOCMND
                  , V_TUNGAY
                  , V_DENNGAY
                  , CURSOR_RETURN 
                );
                    IF CURSOR_RETURN IS NOT NULL THEN
                        PROCESS_CURSOR(CURSOR_RETURN, '2', 0, V_CURRENT_TOAANID);
                        CLOSE CURSOR_RETURN;
                    END IF;
                END IF;


            END LOOP;
        ELSE
            -- TRANGTHAI = 0 hoặc NULL: Logic cũ với p_TOAANID
            -- BƯỚC 1: Lấy dữ liệu + COUNTALL từ procedure 1 (chỉ 1 lần gọi)
                    IF p_LOAIAN = 1 THEN
            PKG_BAN_GIAO_THI_HANH_AN.THA_BIAN_GETANHSTRONGHT_PAGING(
                TOA_AN_ID, MA_BI_AN, TEN_BI_AN, MA_VU_AN, TEN_VU_AN, SO_BAN_AN, NGAY_BAN_AN, TRANGTHAI, TRANGTHAIGQ, V_SOCMND, V_TUNGAY, V_DENNGAY , CURSOR_RETURN 
             );
                    ELSE

            PKG_BAN_GIAO_THI_HANH_AN.THA_BIAN_GETANNGOAIHT(
                TOA_AN_ID 
              , MA_BI_AN 
              , TEN_BI_AN
              , MA_VU_AN 
              , TEN_VU_AN
              , SO_BAN_AN
              , NGAY_BAN_AN
              , TRANGTHAI
              , TRANGTHAIGQ
              , V_SOCMND
              , V_TUNGAY
              , V_DENNGAY

              , CURSOR_RETURN 
            );
                END IF;
           IF CURSOR_RETURN IS NOT NULL THEN
                    PROCESS_CURSOR(CURSOR_RETURN, '2', 0, V_CURRENT_TOAANID);
                    CLOSE CURSOR_RETURN;
                END IF;

        END IF;

        -- BƯỚC 3: Tính tổng COUNTALL thực tế
        V_REAL_COUNTALL := V_COUNTALL_PROC1 + V_COUNTALL_PROC2;

        -- BƯỚC 4: Final query với DISTINCT để loại bỏ duplicate (bỏ STT)
        OPEN p_CURSOR FOR
                    Select A.*, ROW_NUMBER()
                                                OVER(
                                                    ORDER BY A.VUANID DESC
                                                ) TT
                    from (
                        SELECT  
                                               A.STT,
                                               A.COUNTALL
                                               , A.VUANID
                                               , A.IDVUANHETHONG
                                               , A.MAVUAN
                                               , A.TENVUAN
                                               , A.NGAYVUAN
                                               , LISTAGG(A.BIANID, ',') WITHIN GROUP(ORDER BY A.BIANID) as BIANID
                                               , LISTAGG(A.MABIAN, ',') WITHIN GROUP(ORDER BY A.MABIAN) as MABIAN
                                               , LISTAGG(A.TENBIAN, ',') WITHIN GROUP(ORDER BY A.TENBIAN) as TENBIAN
                                               , A.MAGIAIDOAN
                                               , A.GIAIDOANVUVIEC
                                               , A.SOBANAN
                                               , A.NGAYBANAN
                                               , A.NGAYHIEULUC,
                                               A.TINHTRANGGQ,
                                               B.ID as MAPPINGID,
                                               B.LYDOMA as LYDO,
                                               B.NGAYGIAO as THOIGIANBANGIAO,
                                               B.TRANGTHAI,
                                               C.TEN as TOANHAN,
                                               LD.TEN as LYDOTEN
                               FROM 
                                 TABLE(V_TABLE_TIMKIEM) A

--                                 LEFT JOIN DM_LOAIAN LA ON LA.ID = A.LOAIAN_ID
                                 LEFT JOIN thi_hanh_an_bangiao_mapping B ON 
                                 A.VUANID = B.VUVIECID
                                 AND B.TOAANGIAOID = TOA_AN_ID
                                 LEFT JOIN dm_toaan C ON  case when b.toaannhanid is null then 0 else B.toaannhanid end = C.id
                                 LEFT JOIN DM_DATAITEM ld ON b.LYDOMA = ld.MA


                            WHERE 1=1
                            -- Loại trừ những bản ghi mapping mà toà hiện tại đã nhận (TOAANNHANID = p_TOAANID)
                            AND (B.TOAANNHANID IS NULL OR B.TOAANNHANID != TOA_AN_ID)
                            AND (1 = (CASE 
                                -- TRANGTHAI = 0: Loại bỏ những bản ghi đã có mapping với toaangiaoid = p_toaanid
                                WHEN p_TRANGTHAI = 0 THEN 
                                    CASE WHEN NOT EXISTS (
                                        SELECT 1 FROM thi_hanh_an_bangiao_mapping vm 
                                        WHERE vm.VUVIECID = A.VUANID AND vm.TOAANGIAOID = TOA_AN_ID 
                                    ) THEN 1 ELSE 0 END
                                -- TRANGTHAI = 1: Chỉ lấy những bản ghi có mapping 
                                WHEN p_TRANGTHAI = 1 AND B.TRANGTHAI IS NOT NULL THEN 1
                                -- TRANGTHAI = NULL hoặc khác: Lấy tất cả
                                WHEN p_TRANGTHAI IS NULL THEN 1
                                WHEN p_TRANGTHAI NOT IN (0, 1) THEN 1 
                                ELSE 0 END))

                            Group by A.STT,
                                               A.COUNTALL
                                                          , A.VUANID
                                                          , A.IDVUANHETHONG
                                                          , A.MAVUAN
                                                          , A.TENVUAN
                                                          , A.NGAYVUAN
--                                                          , A.BIANID
--                                                          , A.MABIAN
--                                                          , A.TENBIAN
                                                          , A.MAGIAIDOAN
                                                          , A.GIAIDOANVUVIEC
                                                          , A.SOBANAN
                                                          , A.NGAYBANAN
                                                          , A.NGAYHIEULUC
                                                          , A.TINHTRANGGQ
                                                          , B.ID, B.LYDOMA, B.NGAYGIAO, B.TRANGTHAI, C.TEN, LD.TEN
                    ) A
                    ORDER BY TT ASC;


    END THI_HANH_AN_BANGIAO_MAPPING_GET_AN_BAN_GIAO;

    -- [THA] LẤY DANH SÁCH CHỜ DUYỆT
    PROCEDURE THI_HANH_AN_BANGIAO_MAPPING_GETS_CHONHAN (
          p_TOAANID   IN NUMBER,
          p_MA_BI_AN    IN NVARCHAR2,
          p_TEN_BI_AN   IN NVARCHAR2,
          p_MA_VU_AN    IN NVARCHAR2,
          p_TEN_VU_AN   IN NVARCHAR2,
          p_SO_BAN_AN   IN VARCHAR2,
          p_NGAY_BAN_AN IN DATE,
          p_TRANGTHAI_GQ   IN NUMBER,
          p_SOCMND    IN NVARCHAR2,
          p_TUNGAY    IN NVARCHAR2,
          p_DENNGAY   IN NVARCHAR2,
          p_TRANGTHAI IN NVARCHAR2,
          CURRETURN   OUT SYS_REFCURSOR
    ) AS
          VV_TUNGAY  DATE;
          VV_DENNGAY DATE;
    BEGIN
          IF (p_TUNGAY IS NOT NULL) THEN
                VV_TUNGAY := TO_DATE(TRIM(p_TUNGAY) || ' 00:00:00', 'dd/MM/yyyy HH24:MI:SS');
          END IF;

          IF (p_DENNGAY IS NOT NULL) THEN
                VV_DENNGAY := TO_DATE(TRIM(p_DENNGAY) || ' 00:00:00', 'dd/MM/yyyy HH24:MI:SS');
          END IF;

          OPEN CURRETURN FOR
          SELECT A.*,
                      (CASE
                            -- Đã uỷ thác THA
                            WHEN EXISTS (
                                  SELECT 'x'
                                  FROM THA_UYTHAC_QUYETDINH UYTHAC
                                  INNER JOIN THA_BIAN BIAN ON BIAN.ID = UYTHAC.BIANID
                                  WHERE A.BIANID = BIAN.IDBICANHETHONG
                            ) THEN 'Đã có QĐ ủy thác thi hành án'

                            WHEN EXISTS (
                                  SELECT 'x'
                                  FROM THA_CVDON_KQGQ KQ
                                  INNER JOIN THA_BIAN BIAN ON BIAN.ID = KQ.BIANID
                                  WHERE A.BIANID = BIAN.IDBICANHETHONG
                            ) THEN 'Đã có GQ đơn/CV yêu cầu thi hành án'

                            -- Đã ra QĐ THA
                            WHEN EXISTS (
                                  SELECT 'x'
                                  FROM THA_BIAN_QUYETDINH UYTHAC
                                  INNER JOIN THA_BIAN BIAN ON BIAN.ID = UYTHAC.BIANID
                                  WHERE A.BIANID = BIAN.IDBICANHETHONG
                            ) THEN 'Đã có QĐ thi hành án'

                            -- Đã thụ lý
                            WHEN EXISTS (
                                  SELECT 'x'
                                  FROM THA_THULY THULY
                                  INNER JOIN THA_BIAN BIAN ON BIAN.ID = THULY.BIANID
                                  WHERE A.VUANID = THULY.VUANID
                                        AND A.BIANID = BIAN.IDBICANHETHONG
                            ) THEN 'Đã thụ lý'

                            ELSE 'Chưa giải quyết'
                      END) AS TINHTRANGGQ
          FROM (
                SELECT A.*
                FROM (
                      -- Lấy ds vụ án, bị can theo án sơ thẩm
                      SELECT DISTINCT
                            -- Vụ án
                            A.MAPPINGID,
                            A.ID IDVuAnHeThong,
                            A.MAVUAN,
                            A.TENVUAN,
                            -- Bị án
                            BC.ID BIANID,
                            BC.MABICAN MABIAN,
                            BC.HOTEN TENBIAN,

                            A.MAGIAIDOAN,
                            DECODE(A.MAGIAIDOAN, 1, 'Hồ sơ', 2, 'Sơ thẩm', 3, 'Phúc thẩm', 4, 'Thụ lý Giám đốc thẩm', '') GIAIDOANVUVIEC,
                            ST.SOBANAN,
                            ST.NGAYBANAN,
                            ST.NGAYHIEULUCST NGAYHIEULUC,
                            THAVUAN.ID VUANID,
                            TRANGTHAI,
                            -- Toà giao
                            TOAANGIAOID,
                            TOAANGIAOTEN,
                            -- Toà nhận
                            TOAANNHANID,
                            TOAANNHANTEN
                      FROM (
                            SELECT MAPPING.ID as MAPPINGID, VA.ID, VA.MAVUAN, VA.TENVUAN, VA.TOAPHUCTHAMID, VA.MAGIAIDOAN, MAPPING.TOAANGIAOID, MAPPING.TOAANNHANID, 
                            taGiao.TEN AS TOAANGIAOTEN, taNhan.TEN AS TOAANNHANTEN, MAPPING.TRANGTHAI
                            FROM AHS_VUAN VA

                            -- Lấy thông tin bản án chờ nhận
                            INNER JOIN THI_HANH_AN_BANGIAO_MAPPING MAPPING ON VA.ID = MAPPING.VUVIECID

                            -- Lấy thông tin toà giao/nhận
                            INNER JOIN DM_TOAAN taGiao ON case when MAPPING.TOAANGIAOID is null then 0 else MAPPING.TOAANGIAOID end = taGiao.ID
                            INNER JOIN DM_TOAAN taNhan ON case when MAPPING.TOAANNHANID is null then 0 else MAPPING.TOAANNHANID end = taNhan.ID

                            WHERE MAPPING.TOAANNHANID = p_TOAANID
                            AND (MAGIAIDOAN = '2' OR MAGIAIDOAN = '3')
--                                  AND TOAANID = p_TOAANID
                                  AND (p_MA_VU_AN = '' OR (LOWER(MAVUAN) LIKE ('%'||LOWER(p_MA_VU_AN)||'%')))
                                  AND (p_TEN_VU_AN = '' OR (LOWER(TENVUAN) LIKE ('%'||LOWER(p_TEN_VU_AN)||'%')))
                      ) A
                      INNER JOIN (
                            SELECT A.ID BANANID,
                                        A.VUANID,
                                        A.NGAYBANAN,
                                        (A.NGAYBANAN + 14) NGAYHIEULUCST,
                                        A.SOBANAN
                            FROM AHS_SOTHAM_BANAN A
                            LEFT JOIN AHS_PHUCTHAM_BANAN PTBA ON PTBA.VUANID = A.VUANID
                            LEFT JOIN AHS_PHUCTHAM_QUYETDINH_VUAN PTQD ON PTQD.VUANID = A.VUANID
                            WHERE (p_SO_BAN_AN = '' OR (LOWER(A.SOBANAN) LIKE ('%'||LOWER(p_SO_BAN_AN)||'%')))
                                  AND (p_NGAY_BAN_AN IS NULL OR p_NGAY_BAN_AN = '' OR p_NGAY_BAN_AN = A.NGAYBANAN)
                                  AND (A.NGAYBANAN <= CURRENT_DATE - 31 OR PTBA.ID IS NOT NULL OR PTQD.QUYETDINHID IN (79,80,127,128,203,205,324))
                      ) ST ON ST.VUANID = A.ID
                      LEFT JOIN THA_VUAN THAVUAN ON A.ID = THAVUAN.IDVUANHETHONG

                      INNER JOIN (
                            SELECT BANANID, BICAOID FROM AHS_SOTHAM_BANAN_BICAO
                      ) STBC ON STBC.BANANID = ST.BANANID
                      -- [Complex subquery for BCKCKN - formatted for readability]
--                      INNER JOIN (
--                            SELECT IDKCKN,
--                                        CONCAT(CONCAT(LISTAGG(KC1ID, ',') WITHIN GROUP(ORDER BY KC1ID),
--                                                          LISTAGG(KC2ID, ',') WITHIN GROUP(ORDER BY KC2ID)),
--                                                    LISTAGG(KNID, ',') WITHIN GROUP(ORDER BY KNID)) AS KCKN,
--                                        ','||LISTAGG(BAPT, ',') WITHIN GROUP(ORDER BY BAPT)|| ',' AS BAPT,
--                                        ','||LISTAGG(KETQUAPHUCTHAM, ',') WITHIN GROUP(ORDER BY BAPT)|| ',' AS KQPT,
--                                        ','||LISTAGG(RUTKC1TINHTRANG, ',') WITHIN GROUP(ORDER BY RUTKC1TINHTRANG)|| ',' AS RUTKC1TINHTRANG,
--                                        ','||LISTAGG(RUTKC2TINHTRANG, ',') WITHIN GROUP(ORDER BY RUTKC2TINHTRANG)|| ',' AS RUTKC2TINHTRANG,
--                                        ','||LISTAGG(RUTKNTINHTRANG, ',') WITHIN GROUP(ORDER BY RUTKNTINHTRANG)|| ',' AS RUTKNTINHTRANG,
--                                        ','||LISTAGG(NGAYKHANGCAO1, ',') WITHIN GROUP(ORDER BY NGAYKHANGCAO1)|| ',' AS NGAYKHANGCAO1,
--                                        ','||LISTAGG(NGAYKHANGCAO2, ',') WITHIN GROUP(ORDER BY NGAYKHANGCAO2)|| ',' AS NGAYKHANGCAO2,
--                                        ','||LISTAGG(NGAYKHANGNGHI, ',') WITHIN GROUP(ORDER BY NGAYKHANGNGHI)|| ',' AS NGAYKHANGNGHI,
--                                        ','||LISTAGG(ISQUAHAN1, ',') WITHIN GROUP(ORDER BY ISQUAHAN1)|| ',' AS ISQUAHAN1,
--                                        ','||LISTAGG(ISQUAHAN2, ',') WITHIN GROUP(ORDER BY ISQUAHAN2)|| ',' AS ISQUAHAN2,
--                                        ','||LISTAGG(GQ_ISCHAPNHAN1, ',') WITHIN GROUP(ORDER BY GQ_ISCHAPNHAN1)|| ',' AS GQ_ISCHAPNHAN1,
--                                        ','||LISTAGG(GQ_ISCHAPNHAN2, ',') WITHIN GROUP(ORDER BY GQ_ISCHAPNHAN2)|| ',' AS GQ_ISCHAPNHAN2,
--                                        ','||LISTAGG(QUYETDINHID, ',') WITHIN GROUP(ORDER BY QUYETDINHID)|| ',' AS QUYETDINHID
--                            FROM (
--                                  -- [Inner complex query for aggregation - keeping structure]
--                                  SELECT BC.ID AS IDKCKN,
--                                              KC1.ID AS KC1ID,
--                                              KC2.ID AS KC2ID,
--                                              KQPT.KETQUAPHUCTHAMID AS KETQUAPHUCTHAM,
--                                              KN.ID AS KNID,
--                                              BAPT.ID AS BAPT,
--                                              VUAN.TOAANID AS TOAANID,
--                                              RKCST1.TINHTRANG AS RUTKC1TINHTRANG,
--                                              RKCST2.TINHTRANG AS RUTKC2TINHTRANG,
--                                              RKNST.TINHTRANG AS RUTKNTINHTRANG,
--                                              KC1.NGAYKHANGCAO AS NGAYKHANGCAO1,
--                                              KC2.NGAYKHANGCAO AS NGAYKHANGCAO2,
--                                              KC1.ISQUAHAN AS ISQUAHAN1,
--                                              KC2.ISQUAHAN AS ISQUAHAN2,
--                                              KC1.GQ_ISCHAPNHAN AS GQ_ISCHAPNHAN1,
--                                              KC2.GQ_ISCHAPNHAN AS GQ_ISCHAPNHAN2,
--                                              KN.NGAYKN AS NGAYKHANGNGHI,
--                                              PTQD.QUYETDINHID AS QUYETDINHID
--                                  FROM AHS_BICANBICAO BC
--                                  LEFT JOIN AHS_SOTHAM_KHANGCAO KC1 ON KC1.NGUOIKCLOAI = 0 AND KC1.NGUOIKCID = BC.ID
--                                  LEFT JOIN AHS_SOTHAM_KHANGCAO KC2 ON KC1.NGUOIKCLOAI = 1 AND KC2.DSNGUOIBIKC LIKE '%'|| BC.ID|| ','|| '%'
--                                  LEFT JOIN AHS_SOTHAM_KHANGNGHI KN ON KN.DSNGUOIBIKN LIKE '%'||BC.ID||','||'%'
--                                  LEFT JOIN AHS_PHUCTHAM_BANAN_BICAO BAPT ON BAPT.BICAOID = BC.ID
--                                  LEFT JOIN AHS_SOTHAM_RUTKHANGCAO RKCST1 ON RKCST1.KHANGCAOID = KC1.ID
--                                  LEFT JOIN AHS_SOTHAM_RUTKHANGCAO RKCST2 ON RKCST2.KHANGCAOID = KC2.ID
--                                  LEFT JOIN AHS_SOTHAM_RUTKHANGNGHI RKNST ON RKNST.KHANGNGHIID = KN.ID
--                                  LEFT JOIN AHS_VUAN VUAN ON VUAN.ID = BC.VUANID
--                                  LEFT JOIN AHS_PHUCTHAM_QUYETDINH_VUAN PTQD ON PTQD.VUANID = BC.VUANID
--                                  LEFT JOIN (
--                                        SELECT PTBC.BICAOID AS BICAOID,
--                                                    PTBA.KETQUAPHUCTHAMID AS KETQUAPHUCTHAMID
--                                        FROM AHS_PHUCTHAM_BANAN_BICAO PTBC
--                                        LEFT JOIN AHS_PHUCTHAM_BANAN PTBA ON PTBA.ID = PTBC.BANANID
--                                  ) KQPT ON KQPT.BICAOID = BC.ID
--                                  WHERE VUAN.TOAANID = p_TOAANID
--                            )
--                            GROUP BY IDKCKN
--                      ) BCKCKN ON (
--                            (KCKN IS NULL)
--                            OR (BAPT IS NOT NULL AND BAPT NOT LIKE ('%,,%') AND KCKN IS NOT NULL AND NOT REGEXP_LIKE(KQPT,',3,|,4,|,22,|,46,|,47,|,48,|,49,'))
--                            OR (QUYETDINHID NOT LIKE ('%,,%') AND KCKN IS NOT NULL AND REGEXP_LIKE(QUYETDINHID ,',79,|,80,|,127,|,128,|,203,|,205,|,324,'))
--                            OR (KCKN IS NOT NULL AND REGEXP_LIKE(RUTKC1TINHTRANG,',2,|,1,'))
--                            OR (KCKN IS NOT NULL AND REGEXP_LIKE(RUTKC2TINHTRANG,',2,|,1,'))
--                            OR (KCKN IS NOT NULL AND REGEXP_LIKE(RUTKNTINHTRANG,',2,|,1,'))
--                            OR ((KCKN IS NOT NULL AND ISQUAHAN1 LIKE ('%,1,%') AND GQ_ISCHAPNHAN1 LIKE ('%,1,%'))
--                                  OR (KCKN IS NOT NULL AND ISQUAHAN2 LIKE ('%,1,%') AND GQ_ISCHAPNHAN2 LIKE ('%,1,%')))
--                      ) AND BCKCKN.IDKCKN = STBC.BICAOID
                      INNER JOIN (
                            SELECT ID, VUANID, MABICAN, HOTEN, SOCMND
                            FROM AHS_BICANBICAO BC
                            WHERE (p_TEN_BI_AN = '' OR p_TEN_BI_AN IS NULL OR (LOWER(BC.HOTEN) LIKE ('%' || LOWER(p_TEN_BI_AN) || '%')))
                                  AND (p_MA_BI_AN = '' OR p_MA_BI_AN IS NULL OR (LOWER(BC.MABICAN) LIKE ('%' || LOWER(p_MA_BI_AN) || '%')))
                                  AND (p_SOCMND = '' OR p_SOCMND IS NULL OR (LOWER(BC.SOCMND) LIKE ('%' || LOWER(p_SOCMND) || '%')))
                      ) BC ON BC.VUANID = A.ID AND STBC.BICAOID = BC.ID
                      LEFT JOIN (
                            SELECT BANANID, VUANID, NGAYKN FROM AHS_SOTHAM_KHANGNGHI
                      ) KN ON ST.BANANID = KN.BANANID
                      LEFT JOIN AHS_SOTHAM_QUYETDINH_BICAN QDBC ON QDBC.BICANID = BC.ID
                      LEFT JOIN (
                            SELECT ID, VUANID, NGAYKHANGCAO, NGUOIKCID, SOQDBA, GQ_ISCHAPNHAN, ISQUAHAN
                            FROM AHS_SOTHAM_KHANGCAO
                      ) KC ON A.ID = KC.VUANID AND KC.SOQDBA = ST.BANANID AND KC.NGUOIKCID = BC.ID
                      WHERE (QDBC.LOAIQDID IS NULL OR (QDBC.LOAIQDID != 3 AND QDBC.LOAIQDID != 4))
                ) A
                WHERE
                      -- Tình trạng giải quyết - tất cả
                      ((p_TRANGTHAI_GQ IS NULL OR p_TRANGTHAI_GQ = 0)
                            AND (p_TUNGAY IS NULL OR A.NGAYBANAN >= VV_TUNGAY)
                            AND (p_DENNGAY IS NULL OR A.NGAYBANAN <= VV_DENNGAY))
                      -- Chưa giải quyết
                      OR (p_TRANGTHAI_GQ = 1
                            AND NOT EXISTS (
                                  SELECT 'x'
                                  FROM THA_THULY THULY
                                  INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                                  WHERE A.VUANID = THULY.VUANID AND BIAN.ID = THULY.BIANID
                            )
                            AND (p_TUNGAY IS NULL OR A.NGAYBANAN >= VV_TUNGAY)
                            AND (p_DENNGAY IS NULL OR A.NGAYBANAN <= VV_DENNGAY))
                      -- Đã giải quyết - đã thụ lý
                      OR (p_TRANGTHAI_GQ = 2
                            AND EXISTS (
                                  SELECT 'x'
                                  FROM THA_THULY THULY
                                  INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                                  WHERE A.VUANID = THULY.VUANID
                                        AND BIAN.ID = THULY.BIANID
                                        AND (p_TUNGAY IS NULL OR THULY.NGAYTHULY >= VV_TUNGAY)
                                        AND (p_DENNGAY IS NULL OR THULY.NGAYTHULY <= VV_DENNGAY)
                            )
                            -- Không có qd THA detail
                            AND NOT EXISTS (
                                  SELECT 'x'
                                  FROM THA_UYTHAC_DETAIL UYTHAC
                                  INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                                  WHERE BIAN.ID = UYTHAC.BIANID
                            )
                            -- Không có gv cv/đơn yc THA
                            AND NOT EXISTS (
                                  SELECT 'x'
                                  FROM THA_CVDON_KQGQ KQ
                                  INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                                  WHERE A.VUANID = KQ.VUANID AND BIAN.ID = KQ.BIANID
                            ))
                      -- Đã có qd THA
                      OR (p_TRANGTHAI_GQ = 3
                            AND EXISTS (
                                  SELECT 'x'
                                  FROM THA_BIAN_QUYETDINH QD
                                  INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                                  WHERE A.VUANID = QD.VUANID
                                        AND BIAN.ID = QD.BIANID
                                        AND (p_TUNGAY IS NULL OR QD.QD_NGAY >= VV_TUNGAY)
                                        AND (p_DENNGAY IS NULL OR QD.QD_NGAY <= VV_DENNGAY)
                            ))
                      -- Đã có QĐ ủy thác THA
                      OR (p_TRANGTHAI_GQ = 4
                            AND EXISTS (
                                  SELECT 'x'
                                  FROM THA_UYTHAC_QUYETDINH UYTHAC
                                  INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                                  WHERE A.VUANID = UYTHAC.VUANID
                                        AND BIAN.ID = UYTHAC.BIANID
                                        AND (p_TUNGAY IS NULL OR UYTHAC.NGAYQD >= VV_TUNGAY)
                                        AND (p_DENNGAY IS NULL OR UYTHAC.NGAYQD <= VV_DENNGAY)
                            ))
                      -- Đã GV CV/đơn yc THA
                      OR (p_TRANGTHAI_GQ = 5
                            AND EXISTS (
                                  SELECT 'x'
                                  FROM THA_CVDON_KQGQ KQ
                                  INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                                  WHERE A.VUANID = KQ.VUANID
                                        AND BIAN.ID = KQ.BIANID
                                        AND (p_TUNGAY IS NULL OR KQ.NGAYVANBAN >= VV_TUNGAY)
                                        AND (p_DENNGAY IS NULL OR KQ.NGAYVANBAN <= VV_DENNGAY)
                            ))
                      -- Đã giải quyết bao gồm đã thụ lý or có qđ tha or có qd ủy thác THA
                      OR (p_TRANGTHAI_GQ = 6
                            AND (
                                  -- Đã có QĐ ủy thác THA
                                  EXISTS (
                                        SELECT 'x'
                                        FROM THA_UYTHAC_QUYETDINH UYTHAC
                                        INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                                        WHERE A.VUANID = UYTHAC.VUANID
                                              AND BIAN.ID = UYTHAC.BIANID
                                              AND (p_TUNGAY IS NULL OR UYTHAC.NGAYQD >= VV_TUNGAY)
                                              AND (p_DENNGAY IS NULL OR UYTHAC.NGAYQD <= VV_DENNGAY)
                                  )
                                  -- THULY
                                  OR EXISTS (
                                        SELECT 'x'
                                        FROM THA_THULY THULY
                                        INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                                        WHERE A.VUANID = THULY.VUANID
                                              AND BIAN.ID = THULY.BIANID
                                              AND (p_TUNGAY IS NULL OR THULY.NGAYTHULY >= VV_TUNGAY)
                                              AND (p_DENNGAY IS NULL OR THULY.NGAYTHULY <= VV_DENNGAY)
                                  )
                                  -- Đã GV CV/đơn yc THA
                                  OR EXISTS (
                                        SELECT 'x'
                                        FROM THA_CVDON_KQGQ KQ
                                        INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                                        WHERE A.VUANID = KQ.VUANID
                                              AND BIAN.ID = KQ.BIANID
                                              AND (p_TUNGAY IS NULL OR KQ.NGAYVANBAN >= VV_TUNGAY)
                                              AND (p_DENNGAY IS NULL OR KQ.NGAYVANBAN <= VV_DENNGAY)
                                  )
                                  -- QĐ tha
                                  OR EXISTS (
                                        SELECT 'x'
                                        FROM THA_BIAN_QUYETDINH QD
                                        INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                                        WHERE A.VUANID = QD.VUANID
                                              AND BIAN.ID = QD.BIANID
                                              AND (p_TUNGAY IS NULL OR QD.QD_NGAY >= VV_TUNGAY)
                                              AND (p_DENNGAY IS NULL OR QD.QD_NGAY <= VV_DENNGAY)
                                  )
                            ))
                -- Điều kiện đã nhận và chưa nhận
                AND (1=(CASE WHEN (p_TRANGTHAI|| ' ')=' ' THEN 1 WHEN LOWER(A.TRANGTHAI) = LOWER(p_TRANGTHAI) THEN 1 Else 0 END))
          ) A
          ORDER BY A.NGAYHIEULUC DESC;
    END THI_HANH_AN_BANGIAO_MAPPING_GETS_CHONHAN;

    -- [THA] LẤY DANH SÁCH CHỜ DUYỆT
    -- [THA] LẤY DANH SÁCH CHỜ DUYỆT
    PROCEDURE THI_HANH_AN_BANGIAO_MAPPING_GETS_CHONHAN_THA (
        p_TOAANID       IN NUMBER,
        p_MA_BI_AN      IN NVARCHAR2,
        p_TEN_BI_AN     IN NVARCHAR2,
        p_MA_VU_AN      IN NVARCHAR2,
        p_TEN_VU_AN     IN NVARCHAR2,
        p_SO_BAN_AN     IN VARCHAR2,
        p_NGAY_BAN_AN   IN DATE,
        p_TRANGTHAI_GQ  IN NUMBER,
        p_TINHTRANG_QD   IN NUMBER,
        p_SOCMND        IN NVARCHAR2,
        p_TUNGAY        IN NVARCHAR2,
        p_DENNGAY       IN NVARCHAR2,
        p_TRANGTHAI     IN NVARCHAR2,
        CURRETURN       OUT SYS_REFCURSOR
    ) AS
        VV_TUNGAY   DATE;
        VV_DENNGAY  DATE;
    BEGIN
        IF (p_TUNGAY IS NOT NULL) THEN
            VV_TUNGAY := TO_DATE(TRIM(p_TUNGAY) || ' 00:00:00', 'dd/MM/yyyy HH24:MI:SS');
        END IF;
    
        IF (p_DENNGAY IS NOT NULL) THEN
            VV_DENNGAY := TO_DATE(TRIM(p_DENNGAY) || ' 00:00:00', 'dd/MM/yyyy HH24:MI:SS');
        END IF;
    
        OPEN CURRETURN FOR
        SELECT A.*,
                (CASE
                    -- Đã uỷ thác THA
                    WHEN EXISTS (
                        SELECT 'x'
                        FROM THA_UYTHAC_QUYETDINH UYTHAC
                        INNER JOIN THA_BIAN BIAN ON BIAN.ID = UYTHAC.BIANID
                        WHERE A.VUANID = UYTHAC.VUANID
                    ) THEN 'Đã có QĐ ủy thác thi hành án'
    
                    WHEN EXISTS (
                        SELECT 'x'
                        FROM THA_CVDON_KQGQ KQ
                        INNER JOIN THA_BIAN BIAN ON BIAN.ID = KQ.BIANID
                        WHERE A.VUANID = KQ.VUANID
                    ) THEN 'Đã có GQ đơn/CV yêu cầu thi hành án'
    
                    -- Đã ra QĐ THA
                    WHEN EXISTS (
                        SELECT 'x'
                        FROM THA_BIAN_QUYETDINH UYTHAC
                        INNER JOIN THA_BIAN BIAN ON BIAN.ID = UYTHAC.BIANID
                        WHERE A.VUANID = UYTHAC.VUANID
                    ) THEN 'Đã có QĐ thi hành án'
    
                    -- Đã thụ lý
                    WHEN EXISTS (
                        SELECT 'x'
                        FROM THA_THULY THULY
                        INNER JOIN THA_BIAN BIAN ON BIAN.ID = THULY.BIANID
                        WHERE A.VUANID = THULY.VUANID
                    ) THEN 'Đã thụ lý'
    
                    ELSE 'Chưa giải quyết'
                END) AS TINHTRANGGQ
        FROM (
            SELECT A.ID AS VUANID,
                    A.IDVUANHETHONG,
                    A.BA_MAVUAN AS MAVUAN,
                    A.BA_TENVUAN AS TENVUAN,
                    A.BA_NGAYVUAN AS NGAYVUAN,                  
                    '0' AS MAGIAIDOAN,
                    '' AS GIAIDOANVUVIEC,
                    A.BA_ST_SO AS SOBANAN,
                    A.BA_ST_NGAYBANAN AS NGAYBANAN,
                    A.BA_ST_NGAYHIEULUC AS NGAYHIEULUC,
                    A.TRANGTHAI,
                    A.TOAANGIAOID,
                    A.TOAANNHANID,
                    A.TOAANGIAOTEN,
                    A.TOAANNHANTEN,
                    A.MAPPINGID,
                    A.NGAYGIAO,
                    A.NGAYNHAN
            FROM (
                SELECT  VA.ID,
                        VA.BA_MAVUAN,
                        VA.BA_TENVUAN,
                        VA.BA_ST_SO,
                        VA.BA_ST_NGAYBANAN,
                        VA.BA_ST_NGAYHIEULUC,
                        VA.BA_NGAYVUAN,
                        VA.IDVUANHETHONG,
                        MAPPING.TRANGTHAI,
                        MAPPING.TOAANGIAOID,
                        MAPPING.TOAANNHANID,
                        taGiao.TEN AS TOAANGIAOTEN,
                        taNhan.TEN AS TOAANNHANTEN,
                        MAPPING.ID AS MAPPINGID,
                        MAPPING.NGAYGIAO,
                        MAPPING.NGAYNHAN
                FROM THA_VUAN VA
    
                -- Lấy thông tin bản án chờ nhận
                INNER JOIN THI_HANH_AN_BANGIAO_MAPPING MAPPING ON MAPPING.VUVIECID = VA.ID
    
                -- Lấy thông tin toà giao/nhận
                INNER JOIN DM_TOAAN taGiao ON case when MAPPING.TOAANGIAOID is null then 0 else MAPPING.TOAANGIAOID end = taGiao.ID
                INNER JOIN DM_TOAAN taNhan ON case when MAPPING.TOAANNHANID is null then 0 else MAPPING.TOAANNHANID end = taNhan.ID
    
                WHERE ISHETHONG = 0
                AND MAPPING.TOAANNHANID = p_TOAANID
                -- AND TOAANID = p_TOAANID
                AND (p_MA_VU_AN = '' OR p_MA_VU_AN IS NULL OR LOWER(BA_MAVUAN) LIKE '%' || LOWER(p_MA_VU_AN) || '%')
                AND (p_TEN_VU_AN = '' OR p_TEN_VU_AN IS NULL OR LOWER(BA_TENVUAN) LIKE '%' || LOWER(p_TEN_VU_AN) || '%')
            ) A
            INNER JOIN (
                SELECT ID,
                        MABICAN,
                        B.HOTEN,
                        VUANID,
                        SOCMND
                FROM THA_BIAN B
                WHERE (p_MA_BI_AN = '' OR p_MA_BI_AN IS NULL OR LOWER(B.MABICAN) LIKE '%' || LOWER(p_MA_BI_AN) || '%')
                    AND (p_TEN_BI_AN = '' OR p_TEN_BI_AN IS NULL OR LOWER(B.HOTEN) LIKE '%' || LOWER(p_TEN_BI_AN) || '%')
                    AND (p_SOCMND = '' OR p_SOCMND IS NULL OR LOWER(B.SOCMND) LIKE '%' || LOWER(p_SOCMND) || '%')
            ) B ON A.ID = B.VUANID
            WHERE (
                (p_SO_BAN_AN = '' OR p_SO_BAN_AN IS NULL OR LOWER(A.BA_ST_SO) LIKE '%' || LOWER(p_SO_BAN_AN) || '%')
                OR (p_NGAY_BAN_AN IS NULL OR A.BA_ST_NGAYBANAN >= p_NGAY_BAN_AN)
            )
            AND (p_NGAY_BAN_AN IS NULL OR p_NGAY_BAN_AN = '' OR p_NGAY_BAN_AN = A.BA_ST_NGAYBANAN)
            AND (
                -- Trạng thái 0: Tất cả
                (p_TRANGTHAI_GQ IS NULL OR p_TRANGTHAI_GQ = 0)
                AND (p_TUNGAY IS NULL OR A.BA_ST_NGAYBANAN >= VV_TUNGAY)
                AND (p_DENNGAY IS NULL OR A.BA_ST_NGAYBANAN <= VV_DENNGAY)
    
                -- Trạng thái 1: Chưa giải quyết
                OR (p_TRANGTHAI_GQ = 1
                    AND NOT EXISTS (
                        SELECT 'x' FROM THA_THULY THULY
                        WHERE A.ID = THULY.VUANID AND B.ID = THULY.BIANID
                    )
                    AND (p_TUNGAY IS NULL OR A.BA_ST_NGAYBANAN >= VV_TUNGAY)
                    AND (p_DENNGAY IS NULL OR A.BA_ST_NGAYBANAN <= VV_DENNGAY)
                )
    
                -- Trạng thái 2: Đã thụ lý
                OR (p_TRANGTHAI_GQ = 2
                    AND EXISTS (
                        SELECT 'x' FROM THA_THULY THULY
                        WHERE A.ID = THULY.VUANID
                            AND B.ID = THULY.BIANID
                            AND (p_TUNGAY IS NULL OR THULY.NGAYTHULY >= VV_TUNGAY)
                            AND (p_DENNGAY IS NULL OR THULY.NGAYTHULY <= VV_DENNGAY)
                    )
                    AND NOT EXISTS (
                        SELECT 'x' FROM THA_UYTHAC_DETAIL UYTHAC
                        INNER JOIN THA_BIAN BIAN ON B.ID = BIAN.ID
                        WHERE BIAN.ID = UYTHAC.BIANID
                    )
                    AND NOT EXISTS (
                        SELECT 'x' FROM THA_CVDON_KQGQ KQ
                        WHERE A.ID = KQ.VUANID AND B.ID = KQ.BIANID
                    )
                )
    
                -- Trạng thái 3: Đã có QĐ THA
                OR (p_TRANGTHAI_GQ = 3
                    AND EXISTS (
                        SELECT 'x' FROM THA_BIAN_QUYETDINH QD
                        WHERE A.ID = QD.VUANID
                            AND B.ID = QD.BIANID
                            AND (p_TUNGAY IS NULL OR QD.QD_NGAY >= VV_TUNGAY)
                            AND (p_DENNGAY IS NULL OR QD.QD_NGAY <= VV_DENNGAY)
                    )
                )
    
                -- Trạng thái 4: Đã có QĐ ủy thác THA
                OR (p_TRANGTHAI_GQ = 4
                    AND EXISTS (
                        SELECT 'x' FROM THA_UYTHAC_QUYETDINH UYTHAC
                        WHERE A.ID = UYTHAC.VUANID
                            AND B.ID = UYTHAC.BIANID
                            AND (p_TUNGAY IS NULL OR UYTHAC.NGAYQD >= VV_TUNGAY)
                            AND (p_DENNGAY IS NULL OR UYTHAC.NGAYQD <= VV_DENNGAY)
                    )
                )
    
                -- Trạng thái 5: Đã GV CV/đơn yc THA
                OR (p_TRANGTHAI_GQ = 5
                    AND EXISTS (
                        SELECT 'x' FROM THA_CVDON_KQGQ KQ
                        WHERE A.ID = KQ.VUANID
                            AND B.ID = KQ.BIANID
                            AND (p_TUNGAY IS NULL OR KQ.NGAYVANBAN >= VV_TUNGAY)
                            AND (p_DENNGAY IS NULL OR KQ.NGAYVANBAN <= VV_DENNGAY)
                    )
                )
    
                -- Trạng thái 6: Đã giải quyết (tất cả các trường hợp)
                OR (p_TRANGTHAI_GQ = 6
                    AND (
                        -- Đã có QĐ ủy thác THA
                        EXISTS (
                            SELECT 'x' FROM THA_UYTHAC_QUYETDINH UYTHAC
                            INNER JOIN THA_BIAN BIAN ON B.ID = BIAN.ID
                            WHERE A.ID = UYTHAC.VUANID
                                AND BIAN.ID = UYTHAC.BIANID
                                AND (p_TUNGAY IS NULL OR UYTHAC.NGAYQD >= VV_TUNGAY)
                                AND (p_DENNGAY IS NULL OR UYTHAC.NGAYQD <= VV_DENNGAY)
                        )
                        -- Đã thụ lý
                        OR EXISTS (
                            SELECT 'x' FROM THA_THULY THULY
                            INNER JOIN THA_BIAN BIAN ON B.ID = BIAN.ID
                            WHERE A.ID = THULY.VUANID
                                AND BIAN.ID = THULY.BIANID
                                AND (p_TUNGAY IS NULL OR THULY.NGAYTHULY >= VV_TUNGAY)
                                AND (p_DENNGAY IS NULL OR THULY.NGAYTHULY <= VV_DENNGAY)
                        )
                        -- Đã GV CV/đơn yc THA
                        OR EXISTS (
                            SELECT 'x' FROM THA_CVDON_KQGQ KQ
                            INNER JOIN THA_BIAN BIAN ON B.ID = BIAN.ID
                            WHERE A.ID = KQ.VUANID
                                AND BIAN.ID = KQ.BIANID
                                AND (p_TUNGAY IS NULL OR KQ.NGAYVANBAN >= VV_TUNGAY)
                                AND (p_DENNGAY IS NULL OR KQ.NGAYVANBAN <= VV_DENNGAY)
                        )
                        -- Đã có QĐ THA
                        OR EXISTS (
                            SELECT 'x' FROM THA_BIAN_QUYETDINH QD
                            INNER JOIN THA_BIAN BIAN ON B.ID = BIAN.ID
                            WHERE A.ID = QD.VUANID
                                AND BIAN.ID = QD.BIANID
                                AND (p_TUNGAY IS NULL OR QD.QD_NGAY >= VV_TUNGAY)
                                AND (p_DENNGAY IS NULL OR QD.QD_NGAY <= VV_DENNGAY)
                        )
                    )
                )
            )
            -- Điều kiện đã nhận và chưa nhận
            AND (1=(CASE WHEN (p_TRANGTHAI|| ' ')=' ' THEN 1 WHEN LOWER(A.TRANGTHAI) = LOWER(p_TRANGTHAI) THEN 1 Else 0 END))
            And (
               ( p_TINHTRANG_QD = 1
                 AND (
                
                     ----đã có qd THA
                         EXISTS ( SELECT 'x'
                                FROM THA_BIAN_QUYETDINH QD
                                  WHERE A.ID = QD.VUANID
                                        AND B.ID = QD.BIANID
                                        AND ( p_TUNGAY IS NULL
                                              OR QD.QD_NGAY >= VV_TUNGAY )
                                        AND ( p_DENNGAY IS NULL
                                              OR QD.QD_NGAY <= VV_DENNGAY )
                       )
                         ----đã GV CV/đơn yc THA
                         OR EXISTS ( SELECT 'x'
                                           FROM THA_CVDON_KQGQ KQ
                              WHERE A.ID = KQ.VUANID
                                    AND B.ID = KQ.BIANID
                                    AND ( p_TUNGAY IS NULL
                                          OR KQ.NGAYVANBAN >= VV_TUNGAY )
                                    AND ( p_DENNGAY IS NULL
                                          OR KQ.NGAYVANBAN <= VV_DENNGAY )
                                       )
                    )
                )
                Or ( p_TINHTRANG_QD = 0
                 AND (
                
                     ----đã có qd THA
                     NOT EXISTS ( SELECT 'x'
                                FROM THA_BIAN_QUYETDINH QD
                                  WHERE A.ID = QD.VUANID
                                        AND B.ID = QD.BIANID
                       )
                     ----đã GV CV/đơn yc THA
                     AND NOT EXISTS ( SELECT 'x'
                                           FROM THA_CVDON_KQGQ KQ
                              WHERE A.ID = KQ.VUANID
                                    AND B.ID = KQ.BIANID
                                       )
                    )
                )

            )
        ) A
        GROUP BY VUANID,IDVUANHETHONG,MAVUAN,TENVUAN,NGAYVUAN,MAGIAIDOAN,GIAIDOANVUVIEC,SOBANAN,
                  NGAYBANAN,NGAYHIEULUC,TRANGTHAI,TOAANGIAOID,TOAANNHANID,TOAANGIAOTEN,TOAANNHANTEN,MAPPINGID,NGAYGIAO,NGAYNHAN
        ORDER BY A.NGAYHIEULUC DESC;
    END THI_HANH_AN_BANGIAO_MAPPING_GETS_CHONHAN_THA;

    -- [THA] NHẬN BÀN GIAO
PROCEDURE THI_HANH_AN_BANGIAO_MAPPING_NHAN (
        p_ID IN NUMBER,
        p_VUVIECID IN NUMBER,
        p_TOAANNHANID IN NUMBER
    ) AS
        v_TOAANID NUMBER;
    BEGIN

        SELECT don.TOAANID
        INTO v_TOAANID
        FROM THA_VUAN don 
        WHERE don.ID = p_VUVIECID;

--        UPDATE AHS_VUAN
--        SET TOA_GIAIQUYET_ID = TOAANID
--        WHERE ID = p_VUVIECID AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;
--
--        UPDATE AHS_VUAN
--        SET TOAANID = p_TOAANNHANID
--        WHERE ID = p_VUVIECID AND TOAANID = v_TOAANID;

        UPDATE THA_VUAN
        SET TOA_GIAIQUYET_ID = p_TOAANNHANID
        WHERE ID = p_VUVIECID AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;

        UPDATE THA_VUAN
        SET TOAANID = p_TOAANNHANID
        WHERE ID = p_VUVIECID AND TOAANID = v_TOAANID;

        -- Update THA_THULY
        -- backup
       UPDATE THA_THULY
       SET TOA_GIAIQUYET_ID = p_TOAANNHANID
       WHERE VUANID = p_VUVIECID AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;

       UPDATE THA_THULY
       SET TOAANID = p_TOAANNHANID
       WHERE VUANID = p_VUVIECID AND TOAANID = v_TOAANID;

        -- Update THA_CVDON_THULY
        -- backup
       UPDATE THA_CVDON_THULY
       SET TOA_GIAIQUYET_ID = p_TOAANNHANID
       WHERE VUANID = p_VUVIECID AND TOA_GIAIQUYET_ID IS NULL;

       -- Update THA_CVDON_KQGQ
        -- backup
       UPDATE THA_CVDON_KQGQ
       SET TOA_GIAIQUYET_ID = p_TOAANNHANID
       WHERE VUANID = p_VUVIECID AND TOA_GIAIQUYET_ID IS NULL;

        -- Update THA_CVDON_QD
        -- backup
       UPDATE THA_CVDON_QD
       SET TOA_GIAIQUYET_ID = p_TOAANNHANID
       WHERE VUANID = p_VUVIECID AND TOA_GIAIQUYET_ID IS NULL;

       -- Update THA_CVDON_GIAMAN
        -- backup
       UPDATE THA_CVDON_GIAMAN
       SET TOA_GIAIQUYET_ID = p_TOAANNHANID
       WHERE VUANID = p_VUVIECID AND TOA_GIAIQUYET_ID IS NULL;

       -- Update THA_UYTHAC_QUYETDINH
        -- backup
       UPDATE THA_UYTHAC_QUYETDINH
       SET TOA_GIAIQUYET_ID = p_TOAANNHANID
       WHERE VUANID = p_VUVIECID AND TOA_GIAIQUYET_ID IS NULL;

       UPDATE THA_UYTHAC_QUYETDINH
       SET TOA_GIAIQUYET_ID = p_TOAANNHANID
       WHERE VUANID = p_VUVIECID AND TOA_GIAIQUYET_ID IS NULL;
       -- Update THA_BIAN_QUYETDINH
       -- backup
--       UPDATE THA_BIAN_QUYETDINH
--       SET TOA_GIAIQUYET_ID = p_TOAANNHANID
--       WHERE VUANID = p_VUVIECID AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;

       UPDATE THA_BIAN_QUYETDINH
       SET TOAANID = p_TOAANNHANID
       WHERE VUANID = p_VUVIECID AND TOAANID = v_TOAANID;

       -- Update THA_CACQDKHAC
        -- backup
       UPDATE THA_CACQDKHAC
       SET TOA_GIAIQUYET_ID = p_TOAANNHANID
       WHERE VUANID = p_VUVIECID AND TOA_GIAIQUYET_ID IS NULL;

        -- Update TRANGTHAI cho THI_HANH_AN_BANGIAO_MAPPING
        UPDATE THI_HANH_AN_BANGIAO_MAPPING
        SET TRANGTHAI = 'TTBG_DANHAN',
            NGAYNHAN = SYSDATE
        WHERE ID = p_ID;

        COMMIT;

    EXCEPTION
      WHEN OTHERS THEN
          -- Rollback in case of any exception
          ROLLBACK;
          -- Re-raise the exception
          RAISE;
    END THI_HANH_AN_BANGIAO_MAPPING_NHAN;



    PROCEDURE THI_HANH_AN_BANGIAO_MAPPING_GET_AN_NHAN_BAN_GIAO (
        vLoaian IN varchar2,
        vToaAnID IN NUMBER,
        vMavuviec IN varchar2,
        vThulytungay IN date,
        vTinhtrangthuly IN nvarchar2,
        vThamphangiaiquyet IN nvarchar2,
        vTenvuan IN nvarchar2,    
        vDenngay IN date,    
        vTrangthaigiaiquyet IN nvarchar2,    
        vCapxetxu IN nvarchar2,  
        vCURSOR OUT SYS_REFCURSOR
    ) AS
        BEGIN
            OPEN vCURSOR FOR
                SELECT  DISTINCT
                    a.id,
                    a.mavuviec,
                    a.tenvuviec, 
                    case when  d.ngaythuly is null then '' else  cast(d.ngaythuly as VARCHAR2(250)) end as ngaythuly,
                    c.ten as toanhan,
                    b.lydoma  as lydo,
                    b.ngaygiao as thoigianbangiao,
                    b.trangthai as trangthai,
                    b.TOAANNHANID,
                    b.TOAANGIAOID,
                    b.ID as MAPPINGID
                from  ads_don A  JOIN thi_hanh_an_bangiao_mapping B ON B.VUVIECID = A.ID
                JOIN dm_toaan C ON  case when b.toaannhanid is null then 0 else b.toaannhanid end = c.id
                LEFT JOIN ads_sotham_thuly D ON A.id = d.donid
                WHERE b.toaannhanid = vToaAnID 
                AND  (1=(CASE WHEN (vMavuviec || ' ')=' '  THEN 1 WHEN LOWER(A.mavuviec) LIKE  ('%' || LOWER(vMavuviec) || '%') THEN 1 Else 0 END))
                And (1=(CASE WHEN vThulytungay is NULL THEN 1 WHEN d.ngaythuly >= vThulytungay  THEN 1 Else 0 END))
                And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN d.ngaythuly <= vDenngay  THEN 1 Else 0 END))  
                AND  (1=(CASE WHEN (vTinhtrangthuly|| ' ')=' '  THEN 1 WHEN LOWER(A.mavuviec) LIKE  ('%' || LOWER(vMavuviec) || '%') THEN 1 Else 0 END))
                AND  (1=(CASE WHEN (vThamphangiaiquyet|| ' ')=' '  THEN 1 WHEN LOWER(a.thamphankynhandon) LIKE  ('%' || LOWER(vThamphangiaiquyet) || '%') THEN 1 Else 0 END))
                AND  (1=(CASE WHEN (vTenvuan|| ' ')=' '  THEN 1 WHEN LOWER(a.tenvuviec) LIKE  ('%' || LOWER(vTenvuan) || '%') THEN 1 Else 0 END))
                AND  (1=(CASE WHEN (vTrangthaigiaiquyet|| ' ')=' '  THEN 1 WHEN LOWER(A.mavuviec) LIKE  ('%' || LOWER(vMavuviec) || '%') THEN 1 Else 0 END))
                AND  (1=(CASE WHEN (vCapxetxu|| ' ')=' '  THEN 1 WHEN LOWER(A.mavuviec) LIKE  ('%' || LOWER(vMavuviec) || '%') THEN 1 Else 0 END));
        END THI_HANH_AN_BANGIAO_MAPPING_GET_AN_NHAN_BAN_GIAO;


    PROCEDURE THI_HANH_AN_BANGIAO_MAPPING_ADD (
        p_TOAANGIAOID            IN NUMBER,
        p_TOAANGIAOTEN           IN VARCHAR2,
        p_TOAANNHANID            IN NUMBER,
        p_TOAANNHANTEN           IN VARCHAR2,
        p_VUVIECID               IN VARCHAR2,
        p_VUVIECLOAI             IN VARCHAR2,
        p_VUVIECMA               IN VARCHAR2,
        p_VUVIECTEN              IN VARCHAR2,
        p_NGUOIGIAOID            IN VARCHAR2,
        p_NGUOIGIAOTEN           IN VARCHAR2,
        p_NGUOINHANID            IN VARCHAR2,
        p_NGUOINHANTEN           IN VARCHAR2,
        p_LYDOMA                 IN VARCHAR2,
        p_NGAYGIAO               IN DATE,
        p_ISQUYETDINHCHUYEN      IN NUMBER,
        p_SOQUYETDINH            IN VARCHAR2,
        p_NGAYQUYETDINH          IN DATE,
        p_NGUOIKY                IN VARCHAR2,
        p_TRANGTHAI              IN VARCHAR2,
        p_GHICHU                 IN VARCHAR2
    ) AS
        BEGIN
            INSERT INTO THI_HANH_AN_BANGIAO_MAPPING (
                TOAANGIAOID,
                TOAANGIAOTEN,
                TOAANNHANID,
                TOAANNHANTEN,
                VUVIECID,
                VUVIECLOAI,
                VUVIECMA,
                VUVIECTEN,
                NGUOIGIAOID,
                NGUOIGIAOTEN,
                NGUOINHANID,
                NGUOINHANTEN,
                LYDOMA,
                NGAYGIAO,
                ISQUYETDINHCHUYEN,
                SOQUYETDINH,
                NGAYQUYETDINH,
                NGUOIKY,
                TRANGTHAI,
                GHICHU
            )
            VALUES (
                p_TOAANGIAOID,
                p_TOAANGIAOTEN,
                p_TOAANNHANID,
                p_TOAANNHANTEN,
                p_VUVIECID,
                p_VUVIECLOAI,
                p_VUVIECMA,
                p_VUVIECTEN,
                p_NGUOIGIAOID,
                p_NGUOIGIAOTEN,
                p_NGUOINHANID,
                p_NGUOINHANTEN,
                p_LYDOMA,
                p_NGAYGIAO,
                p_ISQUYETDINHCHUYEN,
                p_SOQUYETDINH,
                p_NGAYQUYETDINH,
                p_NGUOIKY,
                p_TRANGTHAI,
                p_GHICHU
            );

            COMMIT;
            EXCEPTION
            WHEN OTHERS THEN
                -- Rollback in case of any exception
                ROLLBACK;
                -- Re-raise the exception
                RAISE;
        END THI_HANH_AN_BANGIAO_MAPPING_ADD;

    PROCEDURE THI_HANH_AN_BANGIAO_MAPPING_EDIT (
        p_ID                      IN NUMBER,
        p_TOAANGIAOID            IN NUMBER,
        p_TOAANGIAOTEN           IN VARCHAR2,
        p_TOAANNHANID            IN NUMBER,
        p_TOAANNHANTEN           IN VARCHAR2,
        p_VUVIECID               IN VARCHAR2,
        p_VUVIECMA               IN VARCHAR2,
        p_VUVIECTEN              IN VARCHAR2,
        p_NGUOIGIAOID            IN VARCHAR2,
        p_NGUOIGIAOTEN           IN VARCHAR2,
        p_NGUOINHANID            IN VARCHAR2,
        p_NGUOINHANTEN           IN VARCHAR2,
        p_LYDOMA                 IN VARCHAR2,
        p_NGAYGIAO               IN DATE,
        p_ISQUYETDINHCHUYEN      IN NUMBER,
        p_SOQUYETDINH            IN VARCHAR2,
        p_NGAYQUYETDINH          IN DATE,
        p_NGUOIKY                IN VARCHAR2,
        p_TRANGTHAI              IN VARCHAR2,
        p_GHICHU                 IN VARCHAR2
    ) AS
        BEGIN
            UPDATE THI_HANH_AN_BANGIAO_MAPPING
            SET
                TOAANGIAOID         = p_TOAANGIAOID,
                TOAANGIAOTEN        = p_TOAANGIAOTEN,
                TOAANNHANID         = p_TOAANNHANID,
                TOAANNHANTEN        = p_TOAANNHANTEN,
                VUVIECID            = p_VUVIECID,
                VUVIECMA            = p_VUVIECMA,
                VUVIECTEN           = p_VUVIECTEN,
                NGUOIGIAOID         = p_NGUOIGIAOID,
                NGUOIGIAOTEN        = p_NGUOIGIAOTEN,
                NGUOINHANID         = p_NGUOINHANID,
                NGUOINHANTEN        = p_NGUOINHANTEN,
                LYDOMA              = p_LYDOMA,
                NGAYGIAO            = p_NGAYGIAO,
                ISQUYETDINHCHUYEN   = p_ISQUYETDINHCHUYEN,
                SOQUYETDINH         = p_SOQUYETDINH,
                NGAYQUYETDINH       = p_NGAYQUYETDINH,
                NGUOIKY             = p_NGUOIKY,
                TRANGTHAI           = p_TRANGTHAI,
                GHICHU              = p_GHICHU
            WHERE ID = p_ID;

            COMMIT;
            EXCEPTION
            WHEN OTHERS THEN
                -- Rollback in case of any exception
                ROLLBACK;
                -- Re-raise the exception
                RAISE;
        END THI_HANH_AN_BANGIAO_MAPPING_EDIT;

    PROCEDURE THI_HANH_AN_BANGIAO_MAPPING_CHANGE_STATUS (
        p_ID        IN NUMBER,
        p_TRANGTHAI IN VARCHAR2
    ) AS
        BEGIN
            UPDATE THI_HANH_AN_BANGIAO_MAPPING
            SET TRANGTHAI = p_TRANGTHAI
            WHERE ID = p_ID;

            COMMIT;
            EXCEPTION
            WHEN OTHERS THEN
                -- Rollback in case of any exception
                ROLLBACK;
                -- Re-raise the exception
                RAISE;
        END THI_HANH_AN_BANGIAO_MAPPING_CHANGE_STATUS;

    PROCEDURE THI_HANH_AN_BANGIAO_MAPPING_DELETE (
        p_ID  IN NUMBER
    ) AS
        BEGIN
            DELETE FROM THI_HANH_AN_BANGIAO_MAPPING
            WHERE ID = p_ID;

            COMMIT;
            EXCEPTION
            WHEN OTHERS THEN
                -- Rollback in case of any exception
                ROLLBACK;
                -- Re-raise the exception
                RAISE;
        END THI_HANH_AN_BANGIAO_MAPPING_DELETE;

    PROCEDURE THA_BIAN_GETANHSTRONGHT_PAGING (
        TOA_AN_ID   IN NUMBER
      , MA_BI_AN    IN NVARCHAR2
      , TEN_BI_AN   IN NVARCHAR2
      , MA_VU_AN    IN NVARCHAR2
      , TEN_VU_AN   IN NVARCHAR2
      , SO_BAN_AN   IN VARCHAR2
      , NGAY_BAN_AN IN DATE
      , TRANGTHAI   IN NUMBER
      , TRANGTHAIGQ   IN NUMBER
      , V_SOCMND    IN NVARCHAR2
      , V_TUNGAY    IN NVARCHAR2
      , V_DENNGAY   IN NVARCHAR2
      , CURRETURN   OUT SYS_REFCURSOR
    ) AS
        VV_TUNGAY  DATE;
        VV_DENNGAY DATE;
        MININDEX   NUMBER;
        MAXINDEX   NUMBER;
    BEGIN
        IF ( V_TUNGAY IS NOT NULL ) THEN VV_TUNGAY := TO_DATE ( TRIM(V_TUNGAY) || ' 00:00:00', 'dd/MM/yyyy HH24:MI:SS' );
        END IF;
        IF ( V_DENNGAY IS NOT NULL ) THEN VV_DENNGAY := TO_DATE ( TRIM(V_DENNGAY) || ' 00:00:00', 'dd/MM/yyyy HH24:MI:SS' );
        END IF;

        --1 :den tong so ban ghi trong bang tbltintuc va luu vao trog bien total    
   --------------------------------   
        OPEN CURRETURN FOR SELECT A.*
                                ,
                                 (CASE
                                    --Đã uỷ thác THA
                                    WHEN EXISTS (   SELECT 'x' FROM THA_UYTHAC_QUYETDINH UYTHAC
                                                    INNER JOIN THA_BIAN BIAN ON  BIAN.ID = UYTHAC.BIANID
                                                    WHERE A.BIANID = BIAN.IDBICANHETHONG
                                                  ) THEN 'Đã có QĐ ủy thác thi hành án'
                                    WHEN EXISTS (   SELECT 'x' FROM THA_CVDON_KQGQ KQ
                                                    INNER JOIN THA_BIAN BIAN ON BIAN.ID = KQ.BIANID
                                                    WHERE A.BIANID = BIAN.IDBICANHETHONG) THEN 'Đã có GQ đơn/CV yêu cầu thi hành án'
                                    --Đã ra QĐ THA
                                    WHEN EXISTS (   SELECT 'x' FROM THA_BIAN_QUYETDINH UYTHAC
                                                    INNER JOIN THA_BIAN BIAN ON BIAN.ID = UYTHAC.BIANID
                                                    WHERE A.BIANID = BIAN.IDBICANHETHONG) THEN 'Đã có QĐ thi hành án'
                                    --Đã thụ lý
                                      WHEN EXISTS ( SELECT 'x' FROM THA_THULY THULY
                                                    INNER JOIN THA_BIAN BIAN ON BIAN.ID = THULY.BIANID
                                                    WHERE A.VUANID = THULY.VUANID AND A.BIANID = BIAN.IDBICANHETHONG ) THEN 'Đã thụ lý'
                                      ELSE 'Chưa giải quyết'  END )      AS TINHTRANGGQ
                      FROM ( SELECT ROW_NUMBER()
                                    OVER(
                                        ORDER BY A.NGAYHIEULUC DESC
                                    ) STT
                                  , COUNT(*) OVER () AS COUNTALL
                                  , A.*
                                    FROM ( (
    ------lay ds vu an , bi can theo an so tham
                                     SELECT DISTINCT
                THAVUAN.ID                                            VUANID,
                A.ID IDVuAnHeThong,
                A.MAVUAN,
                A.TENVUAN,
                A.NGAYVUAN,
                BC.ID                                                 BIANID,
                BC.MABICAN                                            MABIAN,
                BC.HOTEN                                              TENBIAN,
                A.MAGIAIDOAN,
                DECODE(A.MAGIAIDOAN, 1, 'Hồ sơ', 2, 'Sơ thẩm',
                       3, 'Phúc thẩm', 4, 'Thụ lý Giám đốc thẩm', '') GIAIDOANVUVIEC
                       ,
                ST.SOBANAN,
                ST.NGAYBANAN,
                ST.NGAYHIEULUCST                                      NGAYHIEULUC


            FROM
                     (
                    SELECT
                        ID,
                        MAVUAN,
                        TENVUAN,
                        TOAPHUCTHAMID,
                        MAGIAIDOAN,
                        NGAYXAYRA AS NGAYVUAN
                    FROM
                        AHS_VUAN
                    WHERE
                        ( MAGIAIDOAN = '2'
                          OR MAGIAIDOAN = '3' )
                        AND TOAANID = TOA_AN_ID
                        AND ( MA_VU_AN = '' OR (LOWER(MAVUAN) LIKE ('%'||LOWER(MA_VU_AN)||'%')))
                        AND ( TEN_VU_AN = '' OR (LOWER(TENVUAN) LIKE ('%'||LOWER(TEN_VU_AN)||'%')))
                ) A
                INNER JOIN (
                    SELECT
                        A.ID                 BANANID,
                        A.VUANID,
                        A.NGAYBANAN,
                        ( A.NGAYBANAN + 14 ) NGAYHIEULUCST,
                        A.SOBANAN
                    FROM
                        AHS_SOTHAM_BANAN            A
                        LEFT JOIN AHS_PHUCTHAM_BANAN          PTBA ON PTBA.VUANID = A.VUANID
                        LEFT JOIN AHS_PHUCTHAM_QUYETDINH_VUAN PTQD ON PTQD.VUANID = A.VUANID
                    WHERE
                            (SO_BAN_AN = '' OR ( LOWER(A.SOBANAN) LIKE ( '%'||LOWER(SO_BAN_AN )||'%')))
                        AND (ngay_ban_an is null or ngay_ban_an ='' or ngay_ban_an= a.NgayBanAn) 
                        AND ( A.NGAYBANAN <= CURRENT_DATE - 31
                              OR PTBA.ID IS NOT NULL
                              OR PTQD.QUYETDINHID IN (79,80,127,128,203,205,324))
                )                          ST ON ST.VUANID = A.ID
                LEFT JOIN THA_VUAN                   THAVUAN ON A.ID = THAVUAN.IDVUANHETHONG
                INNER JOIN (
                    SELECT
                        BANANID,
                        BICAOID
                    FROM
                        AHS_SOTHAM_BANAN_BICAO
                )                          STBC ON STBC.BANANID = ST.BANANID
                INNER JOIN (
                    SELECT
                        IDKCKN,
                        CONCAT(CONCAT(  LISTAGG(KC1ID, ',') WITHIN GROUP(ORDER BY KC1ID),
                                        LISTAGG(KC2ID, ',') WITHIN GROUP(ORDER BY KC2ID)),
                               LISTAGG(KNID, ',') WITHIN GROUP(ORDER BY KNID))                          AS KCKN,
                        ','||LISTAGG(BAPT, ',') WITHIN GROUP(ORDER BY BAPT)|| ','                       AS BAPT,
                        ','||LISTAGG(KETQUAPHUCTHAM, ',') WITHIN GROUP(ORDER BY BAPT)|| ','             AS KQPT,
                        ','||LISTAGG(RUTKC1TINHTRANG, ',') WITHIN GROUP(ORDER BY RUTKC1TINHTRANG)|| ',' AS RUTKC1TINHTRANG,
                        ','||LISTAGG(RUTKC2TINHTRANG, ',') WITHIN GROUP(ORDER BY RUTKC2TINHTRANG)|| ',' AS RUTKC2TINHTRANG,
                        ','||LISTAGG(RUTKNTINHTRANG, ',') WITHIN GROUP(ORDER BY RUTKNTINHTRANG)|| ','   AS RUTKNTINHTRANG,
                        ','||LISTAGG(NGAYKHANGCAO1, ',') WITHIN GROUP(ORDER BY NGAYKHANGCAO1)|| ','     AS NGAYKHANGCAO1,
                        ','||LISTAGG(NGAYKHANGCAO2, ',') WITHIN GROUP(ORDER BY NGAYKHANGCAO2)|| ','     AS NGAYKHANGCAO2,
                        ','||LISTAGG(NGAYKHANGNGHI, ',') WITHIN GROUP(ORDER BY NGAYKHANGNGHI)|| ','     AS NGAYKHANGNGHI,
                        ','||LISTAGG(ISQUAHAN1, ',') WITHIN GROUP(ORDER BY ISQUAHAN1)|| ','             AS ISQUAHAN1,
                        ','||LISTAGG(ISQUAHAN2, ',') WITHIN GROUP(ORDER BY ISQUAHAN2)|| ','             AS ISQUAHAN2,
                        ','||LISTAGG(GQ_ISCHAPNHAN1, ',') WITHIN GROUP(ORDER BY GQ_ISCHAPNHAN1)|| ','   AS GQ_ISCHAPNHAN1,
                        ','||LISTAGG(GQ_ISCHAPNHAN2, ',') WITHIN GROUP(ORDER BY GQ_ISCHAPNHAN2)|| ','   AS GQ_ISCHAPNHAN2,
                        ','||LISTAGG(QUYETDINHID, ',') WITHIN GROUP(ORDER BY QUYETDINHID)|| ','         AS QUYETDINHID
                    FROM
                        (
                            SELECT
                                BC.ID                 AS IDKCKN,
                                KC1.ID                AS KC1ID,
                                KC2.ID                AS KC2ID,
                                KQPT.KETQUAPHUCTHAMID AS KETQUAPHUCTHAM,
                                KN.ID                 AS KNID,
                                BAPT.ID               AS BAPT,
                                VUAN.TOAANID          AS TOAANID,
                                RKCST1.TINHTRANG      AS RUTKC1TINHTRANG,
                                RKCST2.TINHTRANG      AS RUTKC2TINHTRANG,
                                RKNST.TINHTRANG       AS RUTKNTINHTRANG,
                                KC1.NGAYKHANGCAO      AS NGAYKHANGCAO1,
                                KC2.NGAYKHANGCAO      AS NGAYKHANGCAO2,
                                KC1.ISQUAHAN          AS ISQUAHAN1,
                                KC2.ISQUAHAN          AS ISQUAHAN2,
                                KC1.GQ_ISCHAPNHAN     AS GQ_ISCHAPNHAN1,
                                KC2.GQ_ISCHAPNHAN     AS GQ_ISCHAPNHAN2,
                                KN.NGAYKN             AS NGAYKHANGNGHI,
                                PTQD.QUYETDINHID      AS QUYETDINHID
                            FROM
                                AHS_BICANBICAO              BC
                                LEFT JOIN AHS_SOTHAM_KHANGCAO KC1 ON KC1.NGUOIKCLOAI = 0 AND KC1.NGUOIKCID = BC.ID
                                LEFT JOIN AHS_SOTHAM_KHANGCAO KC2 ON KC1.NGUOIKCLOAI = 1 AND KC2.DSNGUOIBIKC LIKE '%'|| BC.ID|| ','|| '%'
                                LEFT JOIN AHS_SOTHAM_KHANGNGHI KN ON KN.DSNGUOIBIKN LIKE '%'||BC.ID||','||'%'
                                LEFT JOIN AHS_PHUCTHAM_BANAN_BICAO    BAPT ON BAPT.BICAOID = BC.ID
                                LEFT JOIN AHS_SOTHAM_RUTKHANGCAO      RKCST1 ON RKCST1.KHANGCAOID = KC1.ID
                                LEFT JOIN AHS_SOTHAM_RUTKHANGCAO      RKCST2 ON RKCST2.KHANGCAOID = KC2.ID
                                LEFT JOIN AHS_SOTHAM_RUTKHANGNGHI     RKNST ON RKNST.KHANGNGHIID = KN.ID
                                LEFT JOIN AHS_VUAN                    VUAN ON VUAN.ID = BC.VUANID
                                LEFT JOIN AHS_PHUCTHAM_QUYETDINH_VUAN PTQD ON PTQD.VUANID = BC.VUANID
                                LEFT JOIN (
                                    SELECT
                                        PTBC.BICAOID          AS BICAOID,
                                        PTBA.KETQUAPHUCTHAMID AS KETQUAPHUCTHAMID
                                    FROM
                                        AHS_PHUCTHAM_BANAN_BICAO PTBC
                                        LEFT JOIN AHS_PHUCTHAM_BANAN       PTBA ON PTBA.ID = PTBC.BANANID
                                ) KQPT ON KQPT.BICAOID = BC.ID
                            WHERE
                                VUAN.TOAANID = TOA_AN_ID
                        )
                    GROUP BY
                        IDKCKN
                )                          BCKCKN ON ( ( KCKN IS NULL )
                              OR ( BAPT IS NOT NULL
                                   AND BAPT NOT LIKE ( '%,,%' )
                                   AND KCKN IS NOT NULL
                                   AND NOT REGEXP_LIKE (KQPT,',3,|,4,|,22,|,46,|,47,|,48,|,49,'))
                              OR ( QUYETDINHID NOT LIKE ( '%,,%' )
                                   AND KCKN IS NOT NULL
                                   AND REGEXP_LIKE (QUYETDINHID ,',79,|,80,|,127,|,128,|,203,|,205,|,324,' ))
                              OR ( KCKN IS NOT NULL
                                   AND REGEXP_LIKE (RUTKC1TINHTRANG,',2,|,1,' ) ) 
                              OR ( KCKN IS NOT NULL
                                   AND REGEXP_LIKE( RUTKC2TINHTRANG,',2,|,1,' ) ) 
                              OR ( KCKN IS NOT NULL
                                   AND REGEXP_LIKE( RUTKNTINHTRANG,',2,|,1,' ) ) 
                              OR ( ( KCKN IS NOT NULL
                                     AND ISQUAHAN1 LIKE ( '%,1,%' )
                                     AND GQ_ISCHAPNHAN1 LIKE ( '%,1,%' ) )
                                   OR ( KCKN IS NOT NULL
                                        AND ISQUAHAN2 LIKE ( '%,1,%' )
                                        AND GQ_ISCHAPNHAN2 LIKE ( '%,1,%' ) ) ) )
                            AND BCKCKN.IDKCKN = STBC.BICAOID
                INNER JOIN (
                    SELECT
                        ID,
                        VUANID,
                        MABICAN,
                        HOTEN,SOCMND
                    FROM
                        AHS_BICANBICAO BC
                    WHERE
             (TEN_BI_AN ='' or  TEN_BI_AN is null or (LOWER(bc.HOTEN) LIKE  ('%' || LOWER(TEN_BI_AN) || '%')))  
             and ( MA_BI_AN='' OR MA_BI_AN is null OR (LOWER(bc.MABICAN) LIKE  ('%' || LOWER(MA_BI_AN) || '%')) )
             and ( V_SOCMND='' OR V_SOCMND is null OR (LOWER(bc.SOCMND) LIKE  ('%' || LOWER(V_SOCMND) || '%')) )             
                )                          BC ON BC.VUANID = A.ID
                        AND STBC.BICAOID = BC.ID
                LEFT JOIN (
                    SELECT
                        BANANID,
                        VUANID,
                        NGAYKN
                    FROM
                        AHS_SOTHAM_KHANGNGHI
                )                          KN ON ST.BANANID = KN.BANANID
                LEFT JOIN AHS_SOTHAM_QUYETDINH_BICAN QDBC ON QDBC.BICANID = BC.ID
                LEFT JOIN (
                    SELECT
                        ID,
                        VUANID,
                        NGAYKHANGCAO,
                        NGUOIKCID,
                        SOQDBA,
                        GQ_ISCHAPNHAN,
                        ISQUAHAN
                    FROM
                        AHS_SOTHAM_KHANGCAO
                )                          KC ON A.ID = KC.VUANID
                        AND KC.SOQDBA = ST.BANANID
                        AND KC.NGUOIKCID = BC.ID
            WHERE
                ( QDBC.LOAIQDID IS NULL
                  OR ( QDBC.LOAIQDID != 3
                       AND QDBC.LOAIQDID != 4 ) )
           )
            ) A
                             WHERE
                                --tình trạng giải quyết  
  ---tất cả
                              ( 

                                ( TRANGTHAI IS NULL
                                       OR TRANGTHAI = 0 )
                                     AND ( V_TUNGAY IS NULL
                                           OR A.NGAYBANAN >= VV_TUNGAY )
                                     AND ( V_DENNGAY IS NULL
                                           OR A.NGAYBANAN <= VV_DENNGAY ) )

  ---chưa giải quyết
                                   OR ( TRANGTHAI = 1
                                        AND NOT EXISTS ( SELECT 'x'
                                                               FROM THA_THULY THULY
                                                               INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                                              WHERE A.VUANID = THULY.VUANID
                                                    AND BIAN.ID = THULY.BIANID
                                                       )
                                        AND ( V_TUNGAY IS NULL
                                              OR A.NGAYBANAN >= VV_TUNGAY )
                                        AND ( V_DENNGAY IS NULL
                                              OR A.NGAYBANAN <= VV_DENNGAY ) )
  ------not exists (select 'x' from tha_thuly where  vuanid = a.vuanid)
  ---đã giải quyết
        ----đã thụ lý
                                   OR ( TRANGTHAI = 2
                                        AND EXISTS ( SELECT 'x'
                                                       FROM THA_THULY THULY
                                                       INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                                          WHERE A.VUANID = THULY.VUANID
                                                AND BIAN.ID = THULY.BIANID
                                                AND ( V_TUNGAY IS NULL
                                                      OR THULY.NGAYTHULY >= VV_TUNGAY )
                                                AND ( V_DENNGAY IS NULL
                                                      OR THULY.NGAYTHULY <= VV_DENNGAY )
                                                   )

      --ko có qd THA detail
                                        AND NOT EXISTS ( SELECT 'x'
                                                               FROM THA_UYTHAC_DETAIL UYTHAC
                                                               INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                                              WHERE BIAN.ID = UYTHAC.BIANID
                                                       )
        -- ko có gv cv/đơn yc THA
                                        AND NOT EXISTS ( SELECT 'x'
                                                               FROM THA_CVDON_KQGQ KQ
                                                               INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                                              WHERE A.VUANID = KQ.VUANID
                                                    AND BIAN.ID = KQ.BIANID
                                                       ) )
        ----đã có qd THA
                                   OR ( TRANGTHAI = 3
                                        AND EXISTS ( SELECT 'x'
                                                       FROM THA_BIAN_QUYETDINH QD
                                                       INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                                          WHERE A.VUANID = QD.VUANID
                                                AND BIAN.ID = QD.BIANID
                                                AND ( V_TUNGAY IS NULL
                                                      OR QD.QD_NGAY >= VV_TUNGAY )
                                                AND ( V_DENNGAY IS NULL
                                                      OR QD.QD_NGAY <= VV_DENNGAY )
                                                   ) )
        ----đã có QĐ ủy thác THA
                                   OR ( TRANGTHAI = 4
                                        AND EXISTS ( SELECT 'x'
                                                       FROM THA_UYTHAC_QUYETDINH UYTHAC
                                                       INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                                          WHERE A.VUANID = UYTHAC.VUANID
                                                AND BIAN.ID = UYTHAC.BIANID
                                                AND ( V_TUNGAY IS NULL
                                                      OR UYTHAC.NGAYQD >= VV_TUNGAY )
                                                AND ( V_DENNGAY IS NULL
                                                      OR UYTHAC.NGAYQD <= VV_DENNGAY )
                                                   ) )
        ----đã GV CV/đơn yc THA
                                   OR ( TRANGTHAI = 5
                                        AND EXISTS ( SELECT 'x'
                                                       FROM THA_CVDON_KQGQ KQ
                                                       INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                                          WHERE A.VUANID = KQ.VUANID
                                                AND BIAN.ID = KQ.BIANID
                                                AND ( V_TUNGAY IS NULL
                                                      OR KQ.NGAYVANBAN >= VV_TUNGAY )
                                                AND ( V_DENNGAY IS NULL
                                                      OR KQ.NGAYVANBAN <= VV_DENNGAY )
                                                   ) )
---Đã giải quyết bao gồm đã thụ lý or có qđ tha or có qd ủy thác THA
                                   OR ( TRANGTHAI = 6
                                        AND (
--đã có QĐ ủy thác THA
                                         EXISTS ( SELECT 'x'
                                                           FROM THA_UYTHAC_QUYETDINH UYTHAC
                                                           INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                                            WHERE A.VUANID = UYTHAC.VUANID
                                                  AND BIAN.ID = UYTHAC.BIANID
                                                  AND ( V_TUNGAY IS NULL
                                                        OR UYTHAC.NGAYQD >= VV_TUNGAY )
                                                  AND ( V_DENNGAY IS NULL
                                                        OR UYTHAC.NGAYQD <= VV_DENNGAY )
                                                     )
         --THULY
                                              OR EXISTS ( SELECT 'x'
                                                     FROM THA_THULY THULY
                                                     INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                                         WHERE A.VUANID = THULY.VUANID
                                               AND BIAN.ID = THULY.BIANID
                                               AND ( V_TUNGAY IS NULL
                                                     OR THULY.NGAYTHULY >= VV_TUNGAY )
                                               AND ( V_DENNGAY IS NULL
                                                     OR THULY.NGAYTHULY <= VV_DENNGAY )
                                                        )   
    --đã GV CV/đơn yc THA
                                              OR EXISTS ( SELECT 'x'
                                                     FROM THA_CVDON_KQGQ KQ
                                                     INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                                         WHERE A.VUANID = KQ.VUANID
                                               AND BIAN.ID = KQ.BIANID
                                               AND ( V_TUNGAY IS NULL
                                                     OR KQ.NGAYVANBAN >= VV_TUNGAY )
                                               AND ( V_DENNGAY IS NULL
                                                     OR KQ.NGAYVANBAN <= VV_DENNGAY )
                                                        )
    --  QĐ tha
                                              OR EXISTS ( SELECT 'x'
                                                     FROM THA_BIAN_QUYETDINH QD
                                                     INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                                         WHERE A.VUANID = QD.VUANID
                                               AND BIAN.ID = QD.BIANID
                                               AND ( V_TUNGAY IS NULL
                                                     OR QD.QD_NGAY >= VV_TUNGAY )
                                               AND ( V_DENNGAY IS NULL
                                                     OR QD.QD_NGAY <= VV_DENNGAY )
                                                        ) ) )

                                    And (
                                                                   ( TRANGTHAIGQ = 1
                                                                     AND (

                                                                         ----đã có qd THA
                                                                             EXISTS ( SELECT 'x'
                                                                                       FROM THA_BIAN_QUYETDINH QD
                                                                                       INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                                                                          WHERE A.VUANID = QD.VUANID
                                                                                AND BIAN.ID = QD.BIANID
                                                                                AND ( V_TUNGAY IS NULL
                                                                                      OR QD.QD_NGAY >= VV_TUNGAY )
                                                                                AND ( V_DENNGAY IS NULL
                                                                                      OR QD.QD_NGAY <= VV_DENNGAY )
                                                                                   )
                                                                             ----đã GV CV/đơn yc THA
                                                                             OR EXISTS ( SELECT 'x'
                                                                                               FROM THA_CVDON_KQGQ KQ
                                                                                               INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                                                                                  WHERE A.VUANID = KQ.VUANID
                                                                                        AND BIAN.ID = KQ.BIANID
                                                                                        AND ( V_TUNGAY IS NULL
                                                                                              OR KQ.NGAYVANBAN >= VV_TUNGAY )
                                                                                        AND ( V_DENNGAY IS NULL
                                                                                              OR KQ.NGAYVANBAN <= VV_DENNGAY )
                                                                                           )
                                                                        )
                                                                    )
                                                                    Or ( TRANGTHAIGQ = 0
                                                                     AND (

                                                                         ----đã có qd THA
                                                                          NOT EXISTS ( SELECT 'x'
                                                                                       FROM THA_BIAN_QUYETDINH QD
                                                                                       INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                                                                                  WHERE A.VUANID = QD.VUANID
                                                                                        AND BIAN.ID = QD.BIANID
                                                                                        AND ( V_TUNGAY IS NULL
                                                                                              OR QD.QD_NGAY >= VV_TUNGAY )
                                                                                        AND ( V_DENNGAY IS NULL
                                                                                              OR QD.QD_NGAY <= VV_DENNGAY )
                                                                                   )
                                                                             ----đã GV CV/đơn yc THA
                                                                         OR NOT EXISTS ( SELECT 'x'
                                                                                               FROM THA_CVDON_KQGQ KQ
                                                                                               INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                                                                                  WHERE A.VUANID = KQ.VUANID
                                                                                        AND BIAN.ID = KQ.BIANID
                                                                                        AND ( V_TUNGAY IS NULL
                                                                                              OR KQ.NGAYVANBAN >= VV_TUNGAY )
                                                                                        AND ( V_DENNGAY IS NULL
                                                                                              OR KQ.NGAYVANBAN <= VV_DENNGAY )
                                                                                           )
                                                                        )
                                                                    )

                                                                )
                           ) A
                       ORDER BY A.STT;
    END THA_BIAN_GETANHSTRONGHT_PAGING;
PROCEDURE THA_BIAN_GETANNGOAIHT (
        TOA_AN_ID   IN NUMBER
      , MA_BI_AN    IN NVARCHAR2
      , TEN_BI_AN   IN NVARCHAR2
      , MA_VU_AN    IN NVARCHAR2
      , TEN_VU_AN   IN NVARCHAR2
      , SO_BAN_AN   IN VARCHAR2
      , NGAY_BAN_AN IN DATE
      , TRANGTHAI   IN NUMBER
      , TRANGTHAIGQ   IN NUMBER
      , V_SOCMND    IN NVARCHAR2
      , V_TUNGAY    IN NVARCHAR2
      , V_DENNGAY   IN NVARCHAR2
      , CURRETURN   OUT SYS_REFCURSOR
    ) AS
        VV_TUNGAY  DATE;
        VV_DENNGAY DATE;
        MININDEX   NUMBER;
        MAXINDEX   NUMBER;
    BEGIN

        IF ( V_TUNGAY IS NOT NULL ) THEN VV_TUNGAY := TO_DATE ( TRIM(V_TUNGAY) || ' 00:00:00', 'dd/MM/yyyy HH24:MI:SS' );
        END IF;
        IF ( V_DENNGAY IS NOT NULL ) THEN VV_DENNGAY := TO_DATE ( TRIM(V_DENNGAY) || ' 00:00:00', 'dd/MM/yyyy HH24:MI:SS' );
        END IF;

   ---------------------------------------------
       OPEN CURRETURN FOR SELECT A.*
                                ,(CASE
                                    --Đã uỷ thác THA
                                    WHEN EXISTS (   SELECT 'x' FROM THA_UYTHAC_QUYETDINH UYTHAC
                                                    INNER JOIN THA_BIAN BIAN ON  BIAN.ID = UYTHAC.BIANID
                                                    WHERE A.VUANID = UYTHAC.VUANID
                                                  ) THEN 'Đã có QĐ ủy thác thi hành án'
                                    WHEN EXISTS (   SELECT 'x' FROM THA_CVDON_KQGQ KQ
                                                    INNER JOIN THA_BIAN BIAN ON BIAN.ID = KQ.BIANID
                                                    WHERE A.VUANID = KQ.VUANID) THEN 'Đã có GQ đơn/CV yêu cầu thi hành án'
                                    --Đã ra QĐ THA
                                    WHEN EXISTS (   SELECT 'x' FROM THA_BIAN_QUYETDINH UYTHAC
                                                    INNER JOIN THA_BIAN BIAN ON BIAN.ID = UYTHAC.BIANID
                                                    WHERE A.VUANID = UYTHAC.VUANID) THEN 'Đã có QĐ thi hành án'
                                    --Đã thụ lý
                                      WHEN EXISTS ( SELECT 'x' FROM THA_THULY THULY
                                                    INNER JOIN THA_BIAN BIAN ON BIAN.ID = THULY.BIANID
                                                    WHERE A.VUANID = THULY.VUANID ) THEN 'Đã thụ lý'
                                      ELSE 'Chưa giải quyết'  END )      AS TINHTRANGGQ

                                              FROM ( SELECT '0'  as  STT
                                                             , '0' as  COUNTALL
                                                          , A.ID                VUANID
                                                          , A.IDVUANHETHONG
                                                          , A.BA_MAVUAN         MAVUAN
                                                          , A.BA_TENVUAN        TENVUAN
                                                          , A.BA_NGAYVUAN       NGAYVUAN
                                                          , B.ID               BIANID
                                                          , B.MABICAN           MABIAN
                                                          , B.HOTEN             TENBIAN
                                                          , '0'                 MAGIAIDOAN
                                                          , ''                  GIAIDOANVUVIEC
                                                          , A.BA_ST_SO          SOBANAN
                                                          , A.BA_ST_NGAYBANAN   NGAYBANAN
                                                          , A.BA_ST_NGAYHIEULUC NGAYHIEULUC
                                                            FROM ( SELECT ID
                                                                        , BA_MAVUAN
                                                                        , BA_TENVUAN
                                                                        , BA_ST_SO
                                                                        , BA_ST_NGAYBANAN
                                                                        , BA_ST_NGAYHIEULUC
                                                                        , BA_NGAYVUAN
                                                                        , IDVUANHETHONG
                                                                          FROM THA_VUAN
                                                                   WHERE ISHETHONG = 0
                                                                         AND TOAANID = TOA_AN_ID
                                                                         AND ( MA_VU_AN = '' OR MA_VU_AN IS NULL
                                                                               OR ( LOWER(BA_MAVUAN) LIKE ( '%' || LOWER(MA_VU_AN) ||'%' ) ) )
                                                                         AND ( TEN_VU_AN = ''OR TEN_VU_AN IS NULL
                                                                               OR ( LOWER(BA_TENVUAN) LIKE ( '%' || LOWER(TEN_VU_AN) || '%' ) ) )
                                                                 ) A
                                                            INNER JOIN ( SELECT ID
                                                                              , MABICAN
                                                                              , B.HOTEN
                                                                              , VUANID
                                                                              , SOCMND
                                                                                      FROM THA_BIAN B
                                                                         WHERE ( MA_BI_AN = ''
                                                                                 OR MA_BI_AN IS NULL
                                                                                 OR ( LOWER(B.MABICAN) LIKE ( '%' || LOWER(MA_BI_AN) || '%' ) ) )
                                                                               AND ( TEN_BI_AN = ''
                                                                                     OR TEN_BI_AN IS NULL
                                                                                     OR ( LOWER(B.HOTEN) LIKE ( '%' || LOWER(TEN_BI_AN) || '%' ) ) )
                                                        --SOCMND
                                                                               AND ( V_SOCMND = ''
                                                                                     OR V_SOCMND IS NULL
                                                                                     OR ( LOWER(B.SOCMND) LIKE ( '%' || LOWER(V_SOCMND) || '%' ) ) )
                                                                       ) B ON A.ID = B.VUANID
                                                     WHERE ( ( SO_BAN_AN = ''
                                                               OR SO_BAN_AN IS NULL
                                                               OR ( LOWER(A.BA_ST_SO) LIKE ( '%' || LOWER(SO_BAN_AN) || '%' ) ) )
                                                             OR ( NGAY_BAN_AN IS NULL
                                                                  OR A.BA_ST_NGAYBANAN >= NGAY_BAN_AN ) )
                                                           AND ( NGAY_BAN_AN IS NULL
                                                                 OR NGAY_BAN_AN = ''
                                                                 OR NGAY_BAN_AN = A.BA_ST_NGAYBANAN )

                                                          And (
                                                                   ( TRANGTHAIGQ = 1
                                                                     AND (

                                                                         ----đã có qd THA
                                                                             EXISTS ( SELECT 'x'
                                                                                    FROM THA_BIAN_QUYETDINH QD
                                                                                      WHERE A.ID = QD.VUANID
                                                                                            AND B.ID = QD.BIANID
                                                                                            AND ( V_TUNGAY IS NULL
                                                                                                  OR QD.QD_NGAY >= VV_TUNGAY )
                                                                                            AND ( V_DENNGAY IS NULL
                                                                                                  OR QD.QD_NGAY <= VV_DENNGAY )
                                                                           )
                                                                             ----đã GV CV/đơn yc THA
                                                                             OR EXISTS ( SELECT 'x'
                                                                                               FROM THA_CVDON_KQGQ KQ
                                                                                  WHERE A.ID = KQ.VUANID
                                                                                        AND B.ID = KQ.BIANID
                                                                                        AND ( V_TUNGAY IS NULL
                                                                                              OR KQ.NGAYVANBAN >= VV_TUNGAY )
                                                                                        AND ( V_DENNGAY IS NULL
                                                                                              OR KQ.NGAYVANBAN <= VV_DENNGAY )
                                                                                           )
                                                                        )
                                                                    )
                                                                    Or ( TRANGTHAIGQ = 0
                                                                     AND (

                                                                         ----đã có qd THA
                                                                         NOT EXISTS ( SELECT 'x'
                                                                                    FROM THA_BIAN_QUYETDINH QD
                                                                                      WHERE A.ID = QD.VUANID
                                                                                            AND B.ID = QD.BIANID
                                                                                            AND ( V_TUNGAY IS NULL
                                                                                                  OR QD.QD_NGAY >= VV_TUNGAY )
                                                                                            AND ( V_DENNGAY IS NULL
                                                                                                  OR QD.QD_NGAY <= VV_DENNGAY )
                                                                           )
                                                                         ----đã GV CV/đơn yc THA
                                                                         AND NOT EXISTS ( SELECT 'x'
                                                                                               FROM THA_CVDON_KQGQ KQ
                                                                                  WHERE A.ID = KQ.VUANID
                                                                                        AND B.ID = KQ.BIANID
                                                                                        AND ( V_TUNGAY IS NULL
                                                                                              OR KQ.NGAYVANBAN >= VV_TUNGAY )
                                                                                        AND ( V_DENNGAY IS NULL
                                                                                              OR KQ.NGAYVANBAN <= VV_DENNGAY )
                                                                                           )
                                                                        )
                                                                    )

                                                                )
                                                    AND  (
                                                    ( TRANGTHAI IS NULL
                                                                 OR TRANGTHAI = 0
                                                                 AND ( V_TUNGAY IS NULL
                                                                       OR A.BA_ST_NGAYBANAN >= VV_TUNGAY )
                                                                 AND ( V_DENNGAY IS NULL
                                                                       OR A.BA_ST_NGAYBANAN <= VV_DENNGAY ) )
                                                           OR ( TRANGTHAI = 1
                                                                AND NOT EXISTS ( SELECT 'x'
                                                                                       FROM THA_THULY THULY
                                                                      WHERE A.ID = THULY.VUANID
                                                                            AND B.ID = THULY.BIANID
                                                                               )
                                                                AND ( V_TUNGAY IS NULL
                                                                      OR A.BA_ST_NGAYBANAN >= VV_TUNGAY )
                                                                AND ( V_DENNGAY IS NULL
                                                                      OR A.BA_ST_NGAYBANAN <= VV_DENNGAY ) )
            ------not exists (select 'x' from tha_thuly where  vuanid = a.vuanid)
                          ---đã giải quyết
                                ----đã thụ lý
                                                           OR ( TRANGTHAI = 2
                                                                AND EXISTS ( SELECT 'x'
                                                                               FROM THA_THULY THULY
                                                                  WHERE A.ID = THULY.VUANID
                                                                        AND B.ID = THULY.BIANID
                                                                        AND ( V_TUNGAY IS NULL
                                                                              OR THULY.NGAYTHULY >= VV_TUNGAY )
                                                                        AND ( V_DENNGAY IS NULL
                                                                              OR THULY.NGAYTHULY <= VV_DENNGAY )
                                                                           )
                                 --ko có qd THA
                                                                AND NOT EXISTS ( SELECT 'x'
                                                                                       FROM THA_UYTHAC_DETAIL UYTHAC
                                                                                       INNER JOIN THA_BIAN BIAN ON B.ID = BIAN.ID
                                                                      WHERE BIAN.ID = UYTHAC.BIANID
                                                                               )

                                --ko có GV CV/đơn yc THA
                                                                AND NOT EXISTS ( SELECT 'x'
                                                                                       FROM THA_CVDON_KQGQ KQ
                                                                      WHERE A.ID = KQ.VUANID
                                                                            AND B.ID = KQ.BIANID
                                                                               ) )
                                 ----đã có qd THA
                                                           OR ( TRANGTHAI = 3
                                                                AND EXISTS ( SELECT 'x'
                                                                               FROM THA_BIAN_QUYETDINH QD
                                                                  WHERE A.ID = QD.VUANID
                                                                        AND B.ID = QD.BIANID
                                                                        AND ( V_TUNGAY IS NULL
                                                                              OR QD.QD_NGAY >= VV_TUNGAY )
                                                                        AND ( V_DENNGAY IS NULL
                                                                              OR QD.QD_NGAY <= VV_DENNGAY )
                                                                           ) )
                                ----đã có QĐ ủy thác THA
                                                           OR ( TRANGTHAI = 4
                                                                AND EXISTS ( SELECT 'x'
                                                                               FROM THA_UYTHAC_QUYETDINH UYTHAC
                                                                  WHERE A.ID = UYTHAC.VUANID
                                                                        AND B.ID = UYTHAC.BIANID
                                                                        AND ( V_TUNGAY IS NULL
                                                                              OR UYTHAC.NGAYQD >= VV_TUNGAY )
                                                                        AND ( V_DENNGAY IS NULL
                                                                              OR UYTHAC.NGAYQD <= VV_DENNGAY )
                                                                           ) )
                                ----đã GV CV/đơn yc THA
                                                           OR ( TRANGTHAI = 5
                                                                AND EXISTS ( SELECT 'x'
                                                                               FROM THA_CVDON_KQGQ KQ
                                                                  WHERE A.ID = KQ.VUANID
                                                                        AND B.ID = KQ.BIANID
                                                                        AND ( V_TUNGAY IS NULL
                                                                              OR KQ.NGAYVANBAN >= VV_TUNGAY )
                                                                        AND ( V_DENNGAY IS NULL
                                                                              OR KQ.NGAYVANBAN <= VV_DENNGAY )
                                                                           ) )
                                                           OR ( TRANGTHAI = 6
                                                                AND (
             --đã có QĐ ủy thác THA
                                                                 EXISTS ( SELECT 'x'
                                                                                   FROM THA_UYTHAC_QUYETDINH UYTHAC
                                                                                   INNER JOIN THA_BIAN BIAN ON B.ID = BIAN.ID
                                                                    WHERE A.ID = UYTHAC.VUANID
                                                                          AND BIAN.ID = UYTHAC.BIANID
                                                                          AND ( V_TUNGAY IS NULL
                                                                                OR UYTHAC.NGAYQD >= VV_TUNGAY )
                                                                          AND ( V_DENNGAY IS NULL
                                                                                OR UYTHAC.NGAYQD <= VV_DENNGAY )
                                                                             )
                                 --THULY
                                                                      OR EXISTS ( SELECT 'x'
                                                                             FROM THA_THULY THULY
                                                                             INNER JOIN THA_BIAN BIAN ON B.ID = BIAN.ID
                                                                 WHERE A.ID = THULY.VUANID
                                                                       AND BIAN.ID = THULY.BIANID
                                                                       AND ( V_TUNGAY IS NULL
                                                                             OR THULY.NGAYTHULY >= VV_TUNGAY )
                                                                       AND ( V_DENNGAY IS NULL
                                                                             OR THULY.NGAYTHULY <= VV_DENNGAY )
                                                                                )   
                            --đã GV CV/đơn yc THA
                                                                      OR EXISTS ( SELECT 'x'
                                                                             FROM THA_CVDON_KQGQ KQ
                                                                             INNER JOIN THA_BIAN BIAN ON B.ID = BIAN.ID
                                                                 WHERE A.ID = KQ.VUANID
                                                                       AND BIAN.ID = KQ.BIANID
                                                                       AND ( V_TUNGAY IS NULL
                                                                             OR KQ.NGAYVANBAN >= VV_TUNGAY )
                                                                       AND ( V_DENNGAY IS NULL
                                                                             OR KQ.NGAYVANBAN <= VV_DENNGAY )
                                                                                )
                            --  QĐ tha
                                                                      OR EXISTS ( SELECT 'x'
                                                                             FROM THA_BIAN_QUYETDINH QD
                                                                             INNER JOIN THA_BIAN BIAN ON B.ID = BIAN.ID
                                                                 WHERE A.ID = QD.VUANID
                                                                       AND BIAN.ID = QD.BIANID
                                                                       AND ( V_TUNGAY IS NULL
                                                                             OR QD.QD_NGAY >= VV_TUNGAY )
                                                                       AND ( V_DENNGAY IS NULL
                                                                             OR QD.QD_NGAY <= VV_DENNGAY )
                                                                                ) ) )
                                                              )

                                                   ) A


                                                   ORDER BY A.STT
                           ;
    END THA_BIAN_GETANNGOAIHT;

END PKG_BAN_GIAO_THI_HANH_AN;

/
