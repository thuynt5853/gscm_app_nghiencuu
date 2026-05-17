--------------------------------------------------------
--  DDL for Package Body PKG_BAN_GIAO_AN
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_BAN_GIAO_AN" AS

    -- [ADS] LẤY DANH SÁCH CÓ THỂ BÀN GIAO
    PROCEDURE ADS_VUAN_BANGIAO_MAPPING_GET_AN_BAN_GIAO (
        p_LOAIANID IN varchar2,
        p_TOAANID IN NUMBER,
        p_MAVUVIEC IN varchar2,
        p_THULYTUNGAY IN date,
        p_THULYDENNGAY IN date,
        p_TINHTRANGTHULY IN nvarchar2,
        p_THAMPHANGIAIQUYET IN nvarchar2,
        p_TENVUAN IN nvarchar2,    
        p_TRANGTHAIGIAIQUYET IN nvarchar2,    
        p_CAPXETXU IN nvarchar2,  
        p_TRANGTHAI IN NVARCHAR2,
        p_CURSOR OUT SYS_REFCURSOR
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
        V_TABLE_TIMKIEM             T_TIMKIEM_STPT_DS;
        
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
        
        FETCH_ID                VARCHAR2(255 CHAR);
        FETCH_MAVUVIEC          VARCHAR2(255 CHAR);
        FETCH_TENVUVIEC         VARCHAR2(4000 CHAR);
        FETCH_SOTHUTU           VARCHAR2(255 CHAR); 
        FETCH_NGAYNHANDON       VARCHAR2(255 CHAR);
        FETCH_HINHTHUCNHANDON   VARCHAR2(255 CHAR);
        FETCH_MAGIAIDOAN        VARCHAR2(255 CHAR);  
        FETCH_QHPLTKID          VARCHAR2(255 CHAR);
        FETCH_TOAANID           VARCHAR2(25 CHAR);
        FETCH_QUANHEPL          VARCHAR2(4000 CHAR);
        FETCH_BANAN_QD_ST       VARCHAR2(4000 CHAR);
        FETCH_QD_PT             VARCHAR2(4000 CHAR);
        FETCH_KHANGNGHI_ST      VARCHAR2(4000 CHAR);
        FETCH_CHECK_THULY       VARCHAR2(1000 CHAR);
        FETCH_HOTENBICAN        VARCHAR2(4000 CHAR);
        FETCH_COUNTALL          VARCHAR2(255 CHAR);
        FETCH_STT               VARCHAR2(1000 CHAR);
        FETCH_NGUOITAO          VARCHAR2(255 CHAR);
        FETCH_NGAY_TAO          VARCHAR2(255 CHAR);
        FETCH_NGAYTAO           VARCHAR2(255 CHAR);
        FETCH_TENTOASOTHAM      VARCHAR2(1000 CHAR);
        FETCH_GIAIDOANVUVIEC    VARCHAR2(255 CHAR);
        FETCH_TRUONGHOPGIAONHAN VARCHAR2(4000 CHAR);
        FETCH_KHANGCAO_ST       VARCHAR2(4000 CHAR);
        FETCH_TINHTRANG_GQ      VARCHAR2(4000 CHAR);
        FETCH_THULYXXLAI        VARCHAR2(1000 CHAR);
        
        SUM_COUNTALL            NUMBER DEFAULT 0;
        CURSOR_RETURN           SYS_REFCURSOR;
        CURSOR_RETURN2           SYS_REFCURSOR;
        CURSOR_RETURN3           SYS_REFCURSOR;
        
        -- PROCESS_CURSOR: Xử lý cursor và capture COUNTALL từ record đầu tiên
        PROCEDURE PROCESS_CURSOR(P_CUR IN SYS_REFCURSOR, P_TYPE VARCHAR2, P_VAR NUMBER, P_TOAANID VARCHAR2) IS
            V_IS_FIRST_RECORD BOOLEAN := TRUE;
        BEGIN
            LOOP
                BEGIN
                    IF P_VAR = 1 THEN
                        -- FETCH cho DON_SEARCH_PTQDK (23 cột, thứ tự: STT, COUNTALL, ID, MAVUVIEC...)
                        FETCH P_CUR INTO FETCH_STT, FETCH_COUNTALL, FETCH_ID, FETCH_MAVUVIEC, 
                          FETCH_TENVUVIEC, FETCH_SOTHUTU, FETCH_NGAYNHANDON, FETCH_NGUOITAO, 
                          FETCH_NGAYTAO, FETCH_QUANHEPL, FETCH_TENTOASOTHAM, FETCH_GIAIDOANVUVIEC,
                          FETCH_HINHTHUCNHANDON, FETCH_TRUONGHOPGIAONHAN, FETCH_BANAN_QD_ST, 
                          FETCH_QD_PT, FETCH_KHANGNGHI_ST, FETCH_KHANGCAO_ST, FETCH_MAGIAIDOAN,
                          FETCH_HOTENBICAN, FETCH_TINHTRANG_GQ, FETCH_CHECK_THULY, FETCH_THULYXXLAI;
                    
                        EXIT WHEN P_CUR%NOTFOUND;
                        
                        -- Capture COUNTALL từ record đầu tiên của procedure 2
                        IF V_IS_FIRST_RECORD THEN
                            V_COUNTALL_PROC2 := TO_NUMBER(FETCH_COUNTALL);
                            V_IS_FIRST_RECORD := FALSE;
                        END IF;
                        
                        -- Gán giá trị cho các trường bị thiếu
                        FETCH_QHPLTKID := '';
                        FETCH_TOAANID := P_TOAANID;
                        FETCH_NGAY_TAO := FETCH_NGAYTAO;
                    ELSE
                        -- FETCH cho ADS_DON_SEARCH_TURNING (26 cột, thứ tự: ID, MAVUVIEC...)
                        FETCH P_CUR INTO FETCH_ID, FETCH_MAVUVIEC, FETCH_TENVUVIEC, FETCH_SOTHUTU, 
                          FETCH_NGAYNHANDON, FETCH_HINHTHUCNHANDON, FETCH_MAGIAIDOAN, FETCH_QHPLTKID,
                          FETCH_TOAANID, FETCH_QUANHEPL, FETCH_BANAN_QD_ST, FETCH_QD_PT,
                          FETCH_KHANGNGHI_ST, FETCH_CHECK_THULY, FETCH_HOTENBICAN, FETCH_COUNTALL, 
                          FETCH_STT, FETCH_NGAY_TAO, FETCH_NGUOITAO, FETCH_NGAYTAO, FETCH_TENTOASOTHAM, 
                          FETCH_GIAIDOANVUVIEC, FETCH_TRUONGHOPGIAONHAN, FETCH_KHANGCAO_ST,
                          FETCH_TINHTRANG_GQ, FETCH_THULYXXLAI;
                    
                        EXIT WHEN P_CUR%NOTFOUND;
                        
                        -- Capture COUNTALL từ record đầu tiên của procedure 1
                        IF V_IS_FIRST_RECORD THEN
                            V_COUNTALL_PROC1 := TO_NUMBER(FETCH_COUNTALL);
                            V_IS_FIRST_RECORD := FALSE;
                        END IF;
                    END IF;
                    
                    -- Phần xử lý chung vẫn giữ nguyên
                    V_TABLE_TIMKIEM.EXTEND;
                    V_TABLE_TIMKIEM(V_TABLE_TIMKIEM.COUNT) := R_TIMKIEM_STPT_DS(
                        FETCH_ID, FETCH_MAVUVIEC, FETCH_TENVUVIEC, FETCH_SOTHUTU, FETCH_NGAYNHANDON, 
                        FETCH_HINHTHUCNHANDON, FETCH_MAGIAIDOAN, FETCH_QHPLTKID, FETCH_TOAANID, 
                        FETCH_QUANHEPL, FETCH_BANAN_QD_ST, FETCH_QD_PT, FETCH_KHANGNGHI_ST, 
                        FETCH_CHECK_THULY, FETCH_HOTENBICAN, FETCH_COUNTALL, FETCH_STT, FETCH_NGAY_TAO,
                        FETCH_NGUOITAO, FETCH_NGAYTAO, FETCH_TENTOASOTHAM, FETCH_GIAIDOANVUVIEC,
                        FETCH_TRUONGHOPGIAONHAN, FETCH_KHANGCAO_ST, FETCH_TINHTRANG_GQ, FETCH_THULYXXLAI, P_TYPE
                    );
                END;
            END LOOP;
        END PROCESS_CURSOR;
       
    BEGIN
	    
        -- Set fixed pagesize for optimal performance
        V_PROCEDURE_PAGESIZE := V_OPTIMIZED_PAGESIZE;
        
        IF p_THULYTUNGAY IS NOT NULL THEN 
            V_THULYTUNGAY := TO_CHAR(p_THULYTUNGAY, 'DD/MM/YYYY');
        ELSE
            V_THULYTUNGAY := '';
        END IF;  
    
        IF p_THULYDENNGAY IS NOT NULL THEN  
            V_THULYDENNGAY := TO_CHAR(p_THULYDENNGAY, 'DD/MM/YYYY'); 
        ELSE
            V_THULYDENNGAY := '';
        END IF;
        
                SELECT LOAITOA INTO V_CAP_XET_XU_LOGIN FROM DM_TOAAN WHERE 1=1 AND ID = p_TOAANID;
        V_TABLE_TIMKIEM := T_TIMKIEM_STPT_DS();
        
        -- LOGIC XỬ LÝ THEO p_TRANGTHAI
        IF p_TRANGTHAI = 1 THEN
            -- TRANGTHAI = 1: Lấy dữ liệu từ các toà được bàn giao (bao gồm cả p_TOAANID gốc)
            FOR toaan_rec IN (
                SELECT p_TOAANID AS TOTOAANID FROM DUAL
                UNION ALL
                SELECT TOTOAANID FROM DM_TOAAN_TACH_NHAP_MAPPING WHERE TOAANID = p_TOAANID
            ) LOOP
                V_CURRENT_TOAANID := toaan_rec.TOTOAANID;
                V_TRANGTHAIGIAIQUYET := '';
                
                -- BƯỚC 1: Lấy dữ liệu từ procedure 1 với TOTOAANDI
                PKG_ADS_STPT_DS.ADS_DON_SEARCH_TURNING(
                  V_CAP_XET_XU_LOGIN,
                  p_TENVUAN,
                  NULL,
                  p_MAVUVIEC,
                  NULL,
                  p_CAPXETXU,
                  V_CURRENT_TOAANID,
                  p_TINHTRANGTHULY,
                  V_THULYTUNGAY,
                  V_THULYDENNGAY,
                  NULL,
                  p_THAMPHANGIAIQUYET,
                  V_TRANGTHAIGIAIQUYET,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  0,
                  NULL,
                  NULL,
                  1,
                  1,
                  0,
                  0,
                  NULL,
                  NULL,
                  NULL, --V_AN_KET_THUC
                  1,
                  V_PROCEDURE_PAGESIZE,
                  CURSOR_RETURN
                );
                IF CURSOR_RETURN IS NOT NULL THEN
                    PROCESS_CURSOR(CURSOR_RETURN, '2', 0, V_CURRENT_TOAANID);
                    CLOSE CURSOR_RETURN;
                END IF;

                -- Không lấy án TĐC với cấp sơ thẩm
                IF P_CAPXETXU IS NULL OR p_CAPXETXU <> 2 THEN
                
                  -- BƯỚC 2: Lấy dữ liệu từ procedure 2 với TOTOAANDI
                  PKG_STPT_ADS_GS.DON_SEARCH_PTQDK(
                    V_CAP_XET_XU_LOGIN,
                    p_TENVUAN,
                    NULL,
                    p_MAVUVIEC,
                    NULL,
                    3,
                    V_CURRENT_TOAANID,
                    p_TINHTRANGTHULY,
                    V_THULYTUNGAY,
                    V_THULYDENNGAY,
                    NULL,
                    p_THAMPHANGIAIQUYET,
                    V_TRANGTHAIGIAIQUYET,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    0,
                    1,
                    NULL,
                    0,
                    0,
                    NULL,
                    NULL,
                    NULL, --V_AN_KET_THUC
                    1,
                    V_PROCEDURE_PAGESIZE,
                    CURSOR_RETURN2
                  );
                                                             
                  IF CURSOR_RETURN2 IS NOT NULL THEN
                      PROCESS_CURSOR(CURSOR_RETURN2, '2', 1, V_CURRENT_TOAANID);
                      CLOSE CURSOR_RETURN2;
                  END IF;
                  
                  -- Bước 3: lấy dữ liệu chưa thụ lý với TRANGTHAIGIAIQUYET = ''
--                  IF (NVL(LENGTH(p_TINHTRANGTHULY),0) = 0) OR p_TINHTRANGTHULY = '2' THEN
--                      V_TRANGTHAIGIAIQUYET := '';
--                      V_TINHTRANGTHULY := '2';
--                      PKG_STPT_ADS_GS.DON_SEARCH_PTQDK(V_CAP_XET_XU_LOGIN,p_TENVUAN,NULL,p_MAVUVIEC,NULL,3,V_CURRENT_TOAANID,V_TINHTRANGTHULY,
--                                                             V_THULYTUNGAY,V_THULYDENNGAY,NULL,p_THAMPHANGIAIQUYET,V_TRANGTHAIGIAIQUYET,NULL,NULL,NULL,
--                                                             NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,1,NULL,0,0,NULL,NULL,
--                                                             1, V_PROCEDURE_PAGESIZE, CURSOR_RETURN3);               
--                      IF CURSOR_RETURN3 IS NOT NULL THEN
--                          PROCESS_CURSOR(CURSOR_RETURN3, '2', 1, p_TOAANID);
--                          CLOSE CURSOR_RETURN3;
--                      END IF;
--                  END IF;

                END IF;
            END LOOP;
        ELSE
            -- TRANGTHAI = 0 hoặc NULL: Logic cũ với p_TOAANID
            -- BƯỚC 1: Lấy dữ liệu + COUNTALL từ procedure 1 (chỉ 1 lần gọi)
            PKG_ADS_STPT_DS.ADS_DON_SEARCH_TURNING(
              V_CAP_XET_XU_LOGIN,
              p_TENVUAN,
              NULL,
              p_MAVUVIEC,
              NULL,
              p_CAPXETXU,
              p_TOAANID,
              p_TINHTRANGTHULY,
              V_THULYTUNGAY,
              V_THULYDENNGAY,
              NULL,
              p_THAMPHANGIAIQUYET,
              p_TRANGTHAIGIAIQUYET,
              NULL,
              NULL,
              NULL,
              NULL,
              NULL,
              NULL,
              NULL,
              NULL,
              NULL,
              NULL,
              NULL,
              0,
              NULL,
              NULL,
              1,
              1,
              0,
              0,
              NULL,
              NULL,
              NULL, --V_AN_KET_THUC
              1,
              V_PROCEDURE_PAGESIZE,
              CURSOR_RETURN
            );
            IF CURSOR_RETURN IS NOT NULL THEN
                PROCESS_CURSOR(CURSOR_RETURN, '2', 0, p_TOAANID);
                CLOSE CURSOR_RETURN;
            END IF;

            -- Không lấy án TĐC với cấp sơ thẩm
            IF (P_CAPXETXU IS NULL OR p_CAPXETXU <> 2) THEN
            
              -- BƯỚC 2: Lấy dữ liệu + COUNTALL từ procedure 2 (chỉ 1 lần gọi)
              PKG_STPT_ADS_GS.DON_SEARCH_PTQDK(
                V_CAP_XET_XU_LOGIN,
                p_TENVUAN,
                NULL,p_MAVUVIEC,NULL,3,p_TOAANID,p_TINHTRANGTHULY,
                                                         V_THULYTUNGAY,V_THULYDENNGAY,NULL,p_THAMPHANGIAIQUYET,p_TRANGTHAIGIAIQUYET,NULL,NULL,NULL,
                                                         NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,1,NULL,0,0,NULL,NULL,
                                                         NULL,1, V_PROCEDURE_PAGESIZE, CURSOR_RETURN2);
                                                         
              IF CURSOR_RETURN2 IS NOT NULL THEN
                  PROCESS_CURSOR(CURSOR_RETURN2, '2', 1, p_TOAANID);
                  CLOSE CURSOR_RETURN2;
              END IF;
              
              -- Bước 3: lấy dữ liệu chưa thụ lý với TRANGTHAIGIAIQUYET = ''
              IF (NVL(LENGTH(p_TINHTRANGTHULY),0) = 0) OR p_TINHTRANGTHULY = '2' THEN
                  V_TRANGTHAIGIAIQUYET := '';
                  V_TINHTRANGTHULY := '2';
                  PKG_STPT_ADS_GS.DON_SEARCH_PTQDK(V_CAP_XET_XU_LOGIN,p_TENVUAN,NULL,p_MAVUVIEC,NULL,3,p_TOAANID,V_TINHTRANGTHULY,
                                                             V_THULYTUNGAY,V_THULYDENNGAY,NULL,p_THAMPHANGIAIQUYET,V_TRANGTHAIGIAIQUYET,NULL,NULL,NULL,
                                                             NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,1,NULL,0,0,NULL,NULL,
                                                             NULL,1, V_PROCEDURE_PAGESIZE, CURSOR_RETURN3);                      
                  IF CURSOR_RETURN3 IS NOT NULL THEN
                      PROCESS_CURSOR(CURSOR_RETURN3, '2', 1, p_TOAANID);
                      CLOSE CURSOR_RETURN3;
                  END IF;
              END IF;

            END IF;
        END IF;
        
        -- BƯỚC 3: Tính tổng COUNTALL thực tế
        V_REAL_COUNTALL := V_COUNTALL_PROC1 + V_COUNTALL_PROC2;
            
        -- BƯỚC 4: Final query với DISTINCT để loại bỏ duplicate (bỏ STT)
        OPEN p_CURSOR FOR
                        SELECT DISTINCT V_REAL_COUNTALL AS COUNTALL,
                                               A.ID,
                                               A.MAVUVIEC,
                                               A.TENVUVIEC,
                                               A.SOTHUTU,
                                               A.NGAYNHANDON,
                                               A.HINHTHUCNHANDON,
                                               A.MAGIAIDOAN,
                                               A.QHPLTKID,
                                               A.TOAANID ,
                                               A.QUANHEPL,
                                               A.BANAN_QD_ST,
                                               A.QD_PT,
                                               A.KHANGNGHI_ST,
                                               A.CHECK_THULY,
                                               A.HOTENBICAN,
                                               A.NGUOITAO,
                                               A.NGAY_TAO as NGAYTHULY,
                                               A.NGAYTAO,
                                               A.TENTOASOTHAM,
                                               A.GIAIDOANVUVIEC,
                                               A.TRUONGHOPGIAONHAN,
                                               A.KHANGCAO_ST,
                                               A.TINHTRANG_GQ,
                                               A.THULYXXLAI,
                                               A.LOAIAN_ID,
                                               LA.LOAI_AN_TEN,
                                               B.ID as MAPPINGID,
                                               B.LYDOMA as LYDO,
                                               B.NGAYGIAO as THOIGIANBANGIAO,
                                               B.TRANGTHAI,
                                               C.TEN as TOANHAN,
                                               LD.TEN as LYDOTEN
                               FROM TABLE(V_TABLE_TIMKIEM)A
                                 LEFT JOIN DM_LOAIAN LA ON LA.ID = A.LOAIAN_ID
                                 LEFT JOIN vuan_bangiao_mapping B 
                                    ON A.ID = B.VUVIECID 
                                    AND b.TOAANGIAOID = P_TOAANID 
                                    AND b.VUVIECLOAI = 'AN_DANSU'
                                    AND (1 = (CASE 
                                                  WHEN P_TRANGTHAI = 0 THEN 1
                                                  WHEN P_TRANGTHAIGIAIQUYET IS NULL THEN 1
                                                  WHEN P_TRANGTHAIGIAIQUYET = 1 THEN 
                                                      CASE WHEN B.TRANGTHAIGIAIQUYET = 1 OR B.TRANGTHAIGIAIQUYET IS NULL THEN 1 ELSE 0 END
                                                  WHEN P_TRANGTHAIGIAIQUYET = 7 THEN 
                                                      CASE WHEN B.TRANGTHAIGIAIQUYET = 7 THEN 1 ELSE 0 END
                                                  ELSE 0
                                              END))
                                 LEFT JOIN dm_toaan C ON  case when b.toaannhanid is null then 0 else b.toaannhanid end = c.id
                                 LEFT JOIN DM_DATAITEM ld ON b.LYDOMA = ld.MA
                            WHERE 1=1
                            -- Loại trừ những bản ghi mapping mà toà hiện tại đã nhận (TOAANNHANID = p_TOAANID)
                            AND (B.TOAANNHANID IS NULL OR B.TOAANNHANID != p_TOAANID)
                            AND (1 = (CASE 
                                -- TRANGTHAI = 0: Loại bỏ những bản ghi đã có mapping với toaangiaoid = p_toaanid
                                WHEN p_TRANGTHAI = 0 THEN 
                                    CASE WHEN NOT EXISTS (
                                        SELECT 1 FROM vuan_bangiao_mapping vm 
                                        WHERE vm.VUVIECID = A.ID 
                                          AND vm.TOAANGIAOID = p_TOAANID 
                                          AND vm.VUVIECLOAI = 'AN_DANSU'
                                    ) THEN 1 ELSE 0 END
                                -- TRANGTHAI = 1: Chỉ lấy những bản ghi có mapping 
                                WHEN p_TRANGTHAI = 1 AND B.TRANGTHAI IS NOT NULL THEN 1
                                -- TRANGTHAI = NULL hoặc khác: Lấy tất cả
                                WHEN p_TRANGTHAI IS NULL THEN 1
                                WHEN p_TRANGTHAI NOT IN (0, 1) THEN 1 
                                ELSE 0 END))
                            ORDER BY A.ID DESC, B.ID DESC;
    END ADS_VUAN_BANGIAO_MAPPING_GET_AN_BAN_GIAO;

    -- [ADS] LẤY DANH SÁCH CHỜ DUYỆT
    PROCEDURE ADS_VUAN_BANGIAO_MAPPING_GETS_CHONHAN (
      p_LOAIANID IN varchar2,
	    p_TOAANID IN NUMBER,
	    p_MAVUVIEC IN varchar2,
	    p_THULYTUNGAY IN date,
	    p_THULYDENNGAY IN date,
	    p_TINHTRANGTHULY IN nvarchar2,
	    p_THAMPHANGIAIQUYET IN nvarchar2,
	    p_TENVUAN IN nvarchar2,    
	    p_TRANGTHAIGIAIQUYET IN nvarchar2,    
	    p_CAPXETXU IN nvarchar2,  
	    p_TRANGTHAI IN NVARCHAR2,
	    p_CURSOR OUT SYS_REFCURSOR
    ) AS
        BEGIN
            OPEN p_CURSOR FOR
                SELECT  
                    DISTINCT
                    -- Mapping
                    mapping.ID as MAPPINGID,
                    mapping.NGAYGIAO,
                    mapping.NGAYNHAN,
                    mapping.TRANGTHAI,
                    mapping.GHICHU,
                    -- Vụ việc
                    don.ID AS VUVIECID,
                    don.MAVUVIEC AS VUVIECMA,
                    don.TENVUVIEC AS VUVIECTEN, 
                    -- Toà giao
                    mapping.TOAANGIAOID,
                    taGiao.TEN AS TOAANGIAOTEN,
                    -- Toà nhận
                    mapping.TOAANNHANID,
                    -- Lý do
                    mapping.LYDOMA,
                    lyDo.TEN AS LYDOTEN
                from ADS_DON don 
                JOIN VUAN_BANGIAO_MAPPING mapping ON don.ID = mapping.VUVIECID AND MAPPING.VUVIECLOAI = 'AN_DANSU'
                JOIN DM_TOAAN taGiao ON case when mapping.TOAANGIAOID is null then 0 else mapping.TOAANGIAOID end = taGiao.ID
                JOIN DM_TOAAN taNhan ON case when mapping.TOAANNHANID is null then 0 else mapping.TOAANNHANID end = taNhan.ID
                JOIN DM_DATAITEM lyDo ON mapping.LYDOMA = lyDo.MA
                LEFT JOIN ADS_SOTHAM_THULY thuLy ON don.ID = thuLy.DONID
                LEFT JOIN ads_phuctham_thuly E ON don.ID = e.DONID
                LEFT JOIN DM_CANBO cb ON cb.ID = don.THAMPHANKYNHANDON
                WHERE mapping.TOAANNHANID = P_TOAANID 
                AND  (1=(CASE WHEN (p_MAVUVIEC || ' ')=' '  THEN 1 WHEN LOWER(don.MAVUVIEC) LIKE  ('%' || LOWER(p_MAVUVIEC) || '%') THEN 1 Else 0 END))
                AND  (1=(CASE WHEN (p_TENVUAN|| ' ')=' '  THEN 1 WHEN LOWER(don.TENVUVIEC) LIKE  ('%' || LOWER(p_TENVUAN) || '%') THEN 1 Else 0 END))
                And (1=(CASE WHEN p_THULYTUNGAY is NULL THEN 1 WHEN thuLy.NGAYTHULY >= p_THULYTUNGAY  THEN 1 Else 0 END))
                And (1=(CASE WHEN p_THULYDENNGAY is NULL THEN 1 WHEN thuLy.NGAYTHULY <= p_THULYDENNGAY  THEN 1 Else 0 END)) 
                AND  (1=(CASE WHEN p_TINHTRANGTHULY IS NULL THEN 1
                            WHEN p_TINHTRANGTHULY = 1 AND 
                                 (CASE WHEN don.MAGIAIDOAN = 2 THEN thuLy.truonghopthuly  -- Cap So Tham
                                       WHEN don.MAGIAIDOAN IN (3,7) THEN E.truonghopthuly  -- Cap Phuc Tham
                                       ELSE thuLy.truonghopthuly END) IS NOT NULL THEN 1 -- Da thu ly
                            WHEN p_TINHTRANGTHULY = 2 AND 
                                 (CASE WHEN don.MAGIAIDOAN = 2 THEN thuLy.truonghopthuly -- Cap So Tham
                                       WHEN don.MAGIAIDOAN IN (3,7) THEN E.truonghopthuly -- Cap Phuc Tham
                                       ELSE thuLy.truonghopthuly END) IS NULL THEN 1 -- Chua thu ly
                        WHEN p_TINHTRANGTHULY NOT IN (1, 2) THEN 1 ELSE 0 END))
                AND  (1=(CASE WHEN (p_THAMPHANGIAIQUYET|| ' ')=' '  THEN 1 WHEN LOWER(cb.HOTEN) LIKE  ('%' || LOWER(p_THAMPHANGIAIQUYET) || '%') THEN 1 
                            WHEN LOWER(cb.MACANBO) LIKE  ('%' || LOWER(p_THAMPHANGIAIQUYET) || '%') THEN 1 Else 0 END))
--                AND  (1=(CASE WHEN (p_TRANGTHAIGIAIQUYET|| ' ')=' ' THEN 1 WHEN don.TRANGTHAI LIKE P_TRANGTHAIGIAIQUYET THEN 1 Else 0 END))
                -- Trạng thái giải quyết
                AND (1 = (CASE 
                              WHEN P_TRANGTHAIGIAIQUYET IS NULL THEN 1
                              WHEN P_TRANGTHAIGIAIQUYET = '1' THEN 
                                  CASE WHEN MAPPING.TRANGTHAIGIAIQUYET = '1' OR MAPPING.TRANGTHAIGIAIQUYET IS NULL THEN 1 ELSE 0 END
                              WHEN P_TRANGTHAIGIAIQUYET = '7' THEN 
                                  CASE WHEN MAPPING.TRANGTHAIGIAIQUYET = '7' THEN 1 ELSE 0 END
                              ELSE 0
                          END))
                -- Cấp xét xử
                AND (1 = (CASE WHEN p_CAPXETXU IS NULL THEN 1
                            WHEN p_CAPXETXU = 2 AND mapping.MAGIAIDOAN = 2 THEN 1 -- Cap So Tham
                            WHEN p_CAPXETXU = 3 AND mapping.MAGIAIDOAN IN (3,7) THEN 1 -- Cap Phuc Tham
                            WHEN p_CAPXETXU NOT IN (2, 3) THEN 1
                            ELSE 0 END))
                AND  (1=(CASE WHEN (p_TRANGTHAI|| ' ')=' '  THEN 1 WHEN LOWER(mapping.TRANGTHAI) = LOWER(p_TRANGTHAI) THEN 1 Else 0 END))
                ORDER BY mapping.ID DESC;
    END ADS_VUAN_BANGIAO_MAPPING_GETS_CHONHAN;

    -- [ADS] NHẬN BÀN GIAO
    PROCEDURE ADS_VUAN_BANGIAO_MAPPING_NHAN (
        p_ID IN NUMBER,
        p_VUVIECID IN NUMBER,
        p_TOAANNHANID IN NUMBER,
        p_NGAYNHAN IN DATE
    ) AS
        v_MAGIAIDOAN NUMBER;
        v_TOAANID NUMBER;
        v_TOAPHUCTHAMID NUMBER;
        v_TRANGTHAIGIAIQUYET VARCHAR2(20);

        v_tracedata VARCHAR2(1024);
	      v_output VARCHAR2(512);
    BEGIN
	    v_tracedata := '(' || 
	    'p_ID => ' || p_ID || ',' ||
	    'p_VUVIECID => ' || p_VUVIECID || ',' ||
	    'p_TOAANNHANID => ' || p_TOAANNHANID || ',' ||
	    'p_NGAYNHAN => ' || p_NGAYNHAN || ',' ||
	    ' );';
	    
        -- Lấy giai đoạn hiện tại của án
        SELECT don.TOAANID, don.TOAPHUCTHAMID
        INTO v_TOAANID, v_TOAPHUCTHAMID
        FROM ADS_DON don 
        WHERE don.ID = p_VUVIECID;

        -- Lấy thông tin mapping
        SELECT vbm.MAGIAIDOAN, vbm.TRANGTHAIGIAIQUYET
        INTO v_MAGIAIDOAN, v_TRANGTHAIGIAIQUYET
        FROM VUAN_BANGIAO_MAPPING vbm
        WHERE vbm.ID = p_ID AND vbm.TRANGTHAI = 'TTBG_CHONHAN';

        -- Kiểm tra giai đoạn hợp lệ
        IF v_MAGIAIDOAN NOT IN (2, 3, 7) THEN
            RAISE_APPLICATION_ERROR(-20001, 'Giai đoạn không hợp lệ.');
        END IF;

        -- Cập nhật án đã kết thúc với trạng thái giải quyết = 7
        UPDATE ADS_DON_GIAIDOAN
        SET AN_DA_KET_THUC = CASE 
                WHEN v_TRANGTHAIGIAIQUYET = 7 THEN 1 
                ELSE AN_DA_KET_THUC 
            END
        WHERE DONID = p_VUVIECID AND MAGIAIDOAN = v_MAGIAIDOAN;

        -- Xử lý cập nhật theo giai đoạn
        IF v_MAGIAIDOAN = 2 THEN
            -- SƠ THẨM
            -- Update ADS_DON
            -- backup
            UPDATE ADS_DON
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE ID = p_VUVIECID AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE ADS_DON
            SET TOAANID = p_TOAANNHANID
            WHERE ID = p_VUVIECID AND TOAANID = v_TOAANID;

            -- Kiểm tra xem có update được chính xác 1 bản ghi ADS_DON hay không
--            IF SQL%ROWCOUNT != 1 THEN
--                ROLLBACK;
--                RAISE_APPLICATION_ERROR(-20002, 'Lỗi cập nhật ADS_DON (Sơ thẩm)');
--            END IF;

            -- Update ADS_SOTHAM_THULY
            -- backup
            UPDATE ADS_SOTHAM_THULY
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE ADS_SOTHAM_THULY
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID;
            
            -- Update ADS_DON_GIAIDOAN
            -- backup
            UPDATE ADS_DON_GIAIDOAN
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL AND MAGIAIDOAN = v_MAGIAIDOAN;

            UPDATE ADS_DON_GIAIDOAN
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID AND MAGIAIDOAN = v_MAGIAIDOAN;

            -- Update DON_CHITIET
            -- backup
            UPDATE DON_CHITIET
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND LOAIANID = 2 AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE DON_CHITIET
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND LOAIANID = 2 AND TOAANID = v_TOAANID;

            -- Update ADS_TONGDAT
            -- backup
            UPDATE ADS_TONGDAT
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE ADS_TONGDAT
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID;

            -- Update DON_KHAC
            -- backup
            UPDATE DON_KHAC
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND LOAIANID = 2 AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE DON_KHAC
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND LOAIANID = 2 AND TOAANID = v_TOAANID;

            -- Update ADS_DON_XULY
            -- backup
            UPDATE ADS_DON_XULY
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE ADS_DON_XULY
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID;

            -- Update ADS_SOTHAM_BANAN
            -- backup
            UPDATE ADS_SOTHAM_BANAN
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE ADS_SOTHAM_BANAN
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID; 

            -- Update ADS_SOTHAM_QUYETDINH
            -- backup
            UPDATE ADS_SOTHAM_QUYETDINH
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE ADS_SOTHAM_QUYETDINH
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID;  

            -- Update ADS_CHUYEN_NHAN_AN
            -- Theo TOACHUYENID 
             -- backup
            UPDATE ADS_CHUYEN_NHAN_AN
            SET TOA_GIAIQUYET_ID = TOACHUYENID
            WHERE VUANID = p_VUVIECID AND TOACHUYENID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE ADS_CHUYEN_NHAN_AN 
            SET TOACHUYENID = p_TOAANNHANID 
            WHERE VUANID = p_VUVIECID AND TOACHUYENID = v_TOAANID;
            
            -- Theo TOANHANID
            -- backup
            UPDATE ADS_CHUYEN_NHAN_AN
            SET TOA_GIAIQUYET_NHAN_ID = TOANHANID
            WHERE VUANID = p_VUVIECID AND TOANHANID = v_TOAANID AND TOA_GIAIQUYET_NHAN_ID IS NULL;

            UPDATE ADS_CHUYEN_NHAN_AN
            SET TOANHANID = p_TOAANNHANID
            WHERE VUANID = p_VUVIECID AND TOANHANID = v_TOAANID;

            -- Với trường hợp chuyển ST -> ST, sau khi chuyển án tạm đình chỉ
            UPDATE ADS_CHUYEN_NHAN_AN
      			SET
      				TOA_GIAIQUYET_NHAN_ID = TOANHANID,
      				TOANHANID = p_TOAANNHANID
      			WHERE
      				VUANID in (
        				SELECT CNA.MAP_VUANID_NEW
        				FROM ADS_CHUYEN_NHAN_AN CNA
        				WHERE CNA.VUANID = p_VUVIECID AND CNA.MAP_VUANID_NEW IS NOT NULL
              );

            -- Với trường hợp chuyển ST -> ST, sau khi chuyển án không đủ thẩm quyền xét xử
            UPDATE ADS_CHUYEN_NHAN_AN
      			SET
      				TOA_GIAIQUYET_NHAN_ID = TOANHANID,
      				TOANHANID = p_TOAANNHANID
      			WHERE
      				MAP_VUANID_NEW = p_VUVIECID AND MAP_VUANID_NEW IS NOT NULL;

        ELSIF v_MAGIAIDOAN IN (3,7) THEN
            -- PHÚC THẨM

            -- Update ADS_DON
            -- backup
            UPDATE ADS_DON
            SET TOA_PHUCTHAM_GIAIQUYET_ID = TOAPHUCTHAMID
            WHERE ID = p_VUVIECID AND TOAPHUCTHAMID = v_TOAPHUCTHAMID AND TOA_PHUCTHAM_GIAIQUYET_ID IS NULL;

            UPDATE ADS_DON
            SET TOAPHUCTHAMID = p_TOAANNHANID
            WHERE ID = p_VUVIECID AND TOAPHUCTHAMID = v_TOAPHUCTHAMID;

            -- backup
            UPDATE ADS_DON
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE ID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE ADS_DON
            SET TOAANID = p_TOAANNHANID
            WHERE ID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID;

            -- Kiểm tra xem có update được chính xác 1 bản ghi ADS_DON hay không
--            IF SQL%ROWCOUNT != 1 THEN
--                ROLLBACK;
--                RAISE_APPLICATION_ERROR(-20003, 'Lỗi cập nhật ADS_DON (Phúc thẩm)');
--            END IF;

            -- Update ADS_PHUCTHAM_THULY
            -- backup
            UPDATE ADS_PHUCTHAM_THULY
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE ADS_PHUCTHAM_THULY
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID;

            -- Update ADS_DON_GIAIDOAN
            -- backup
            UPDATE ADS_DON_GIAIDOAN
            SET TOA_PHUCTHAM_GIAIQUYET_ID = TOAPHUCTHAMID
            WHERE DONID = p_VUVIECID AND TOAPHUCTHAMID = v_TOAPHUCTHAMID AND TOA_PHUCTHAM_GIAIQUYET_ID IS NULL AND MAGIAIDOAN = v_MAGIAIDOAN;

            UPDATE ADS_DON_GIAIDOAN
            SET TOAPHUCTHAMID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAPHUCTHAMID = v_TOAPHUCTHAMID AND MAGIAIDOAN = v_MAGIAIDOAN;

            -- backup
            UPDATE ADS_DON_GIAIDOAN
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE ADS_DON_GIAIDOAN
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID;

            -- UPDATE ADS_KCKNQDK_PHUCTHAM_QUYETDINH
            -- backup
            UPDATE ADS_KCKNQDK_PHUCTHAM_QUYETDINH
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE ADS_KCKNQDK_PHUCTHAM_QUYETDINH
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID;
            
            -- UPDATE ADS_KCKNQDK_PHUCTHAM_THULY
            -- backup
            UPDATE ADS_KCKNQDK_PHUCTHAM_THULY
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID  AND TOAANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE ADS_KCKNQDK_PHUCTHAM_THULY
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID;
            
            -- UPDATE ADS_PHUCTHAM_BANAN
            -- backup
            UPDATE ADS_PHUCTHAM_BANAN
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID  AND TOAANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE ADS_PHUCTHAM_BANAN
            SET TOAANID = P_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID;
            
            -- UPDATE ADS_PHUCTHAM_QUYETDINH
            -- backup
            UPDATE ADS_PHUCTHAM_QUYETDINH
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID  AND TOAANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE ADS_PHUCTHAM_QUYETDINH
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID;

            -- Update ADS_TONGDAT
            -- backup
            UPDATE ADS_TONGDAT
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID  AND TOAANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE ADS_TONGDAT
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID;

            -- Update DON_CHITIET
            -- backup
            UPDATE DON_CHITIET
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND LOAIANID = 2 AND TOAANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE DON_CHITIET
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND LOAIANID = 2 AND TOAANID = v_TOAPHUCTHAMID;

            -- Update DON_KHAC
            -- backup
            UPDATE DON_KHAC
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND LOAIANID = 2 AND TOAANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE DON_KHAC
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND LOAIANID = 2 AND TOAANID = v_TOAPHUCTHAMID;

            -- Update HOSO_PT
            -- backup
            UPDATE HOSO_PT
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE VUANID = p_VUVIECID AND LOAIAN = 2 AND TOAANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE HOSO_PT
            SET TOAANID = p_TOAANNHANID
            WHERE VUANID = p_VUVIECID AND LOAIAN = 2 AND TOAANID = v_TOAPHUCTHAMID;
            
            IF (v_MAGIAIDOAN = 7) THEN
              -- Update ADS_CHUYEN_NHAN_AN
              -- Theo TOACHUYENID 
              -- backup
	           	UPDATE ADS_CHUYEN_NHAN_AN 
	            SET TOA_GIAIQUYET_ID = TOACHUYENID
	            WHERE MAP_VUANID_NEW = p_VUVIECID AND TOACHUYENID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

              UPDATE ADS_CHUYEN_NHAN_AN 
	            SET TOACHUYENID = p_TOAANNHANID 
	            WHERE MAP_VUANID_NEW = p_VUVIECID AND TOACHUYENID = v_TOAPHUCTHAMID;
	            
              -- Theo TOANHANID 
              -- backup
	           	UPDATE ADS_CHUYEN_NHAN_AN 
	            SET TOA_GIAIQUYET_NHAN_ID = TOANHANID
	            WHERE MAP_VUANID_NEW = p_VUVIECID AND TOANHANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_NHAN_ID IS NULL;

	            UPDATE ADS_CHUYEN_NHAN_AN
	            SET TOANHANID = p_TOAANNHANID
	            WHERE MAP_VUANID_NEW = p_VUVIECID AND TOANHANID = v_TOAPHUCTHAMID;
           ELSE
	            -- Update ADS_CHUYEN_NHAN_AN
              -- Theo TOACHUYENID 
              -- backup
	           	UPDATE ADS_CHUYEN_NHAN_AN 
	            SET TOA_GIAIQUYET_ID = TOACHUYENID
	            WHERE VUANID = p_VUVIECID AND TOACHUYENID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

              UPDATE ADS_CHUYEN_NHAN_AN 
	            SET TOACHUYENID = p_TOAANNHANID 
	            WHERE VUANID = p_VUVIECID AND TOACHUYENID = v_TOAPHUCTHAMID;
	            
              -- Theo TOANHANID 
              -- backup
	           	UPDATE ADS_CHUYEN_NHAN_AN 
	            SET TOA_GIAIQUYET_NHAN_ID = TOANHANID
	            WHERE VUANID = p_VUVIECID AND TOANHANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_NHAN_ID IS NULL;

	            UPDATE ADS_CHUYEN_NHAN_AN
	            SET TOANHANID = p_TOAANNHANID
	            WHERE VUANID = p_VUVIECID AND TOANHANID = v_TOAPHUCTHAMID;
           END IF;
        END IF;
        
        -- Update TRANGTHAI cho VUAN_BANGIAO_MAPPING
        UPDATE VUAN_BANGIAO_MAPPING
        SET TRANGTHAI = 'TTBG_DANHAN',
            NGAYNHAN = p_NGAYNHAN
        WHERE ID = p_ID;
       
        COMMIT;
       
--       	v_output := 'Finish procedure success';
--		PKG_TRACELOG.SP_INSERT_LOG_INFO (
--		            p_functionname => 'PKG_BAN_GIAO_AN.ADS_VUAN_BANGIAO_MAPPING_NHAN',
--		            p_description => v_output,
--		            p_notes => v_tracedata
--		        );
        
    EXCEPTION
      WHEN OTHERS THEN
          -- Rollback in case of any exception
          ROLLBACK;
          
          v_output := 'Finish procedure Due to Exception: Error:' || SQLCODE || ',' || SQLERRM;
		        PKG_TRACELOG.SP_INSERT_LOG_ERROR(
		            p_functionname => 'PKG_BAN_GIAO_AN.ADS_VUAN_BANGIAO_MAPPING_NHAN',
		            p_description => v_output,
		            p_notes => v_tracedata
		        );
         
          -- Re-raise the exception
          RAISE;
    END ADS_VUAN_BANGIAO_MAPPING_NHAN;

    -- [ADS] KIỂM TRA THAY ĐỔI
    PROCEDURE ADS_VUAN_BANGIAO_MAPPING_KTTHAYDOI (
        p_ID IN NUMBER,
        p_result OUT NUMBER,
        p_message OUT VARCHAR2
    )
    AS
        v_VUVIECID NUMBER;
        v_TOAANNHANID NUMBER;
        v_NGANHAN DATE;
        v_count NUMBER;
    BEGIN
        -- Khởi tạo giá trị mặc định
        p_result := 0;
        p_message := '';

        -- Lấy thông tin Mapping
        SELECT VUVIECID, TOAANNHANID, NGAYNHAN
        INTO  v_VUVIECID, v_TOAANNHANID, v_NGANHAN
        FROM VUAN_BANGIAO_MAPPING
        WHERE ID = p_ID AND TRANGTHAI = 'TTBG_DANHAN';
        
        -- Kiểm tra các bảng có thay đổi sau ngày nhận án
        
        -- Kiểm tra ADS_ANPHI
        SELECT COUNT(*) INTO v_count 
        FROM ADS_ANPHI 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN)
          AND SOBIENLAI IS NOT NULL AND TAMUNGANPHI IS NOT NULL AND NGUOINHANID IS NOT NULL;
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin án phí đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra ADS_CHUYEN_NHAN_AN
        SELECT COUNT(*) INTO v_count 
        FROM ADS_CHUYEN_NHAN_AN 
        WHERE VUANID = v_VUVIECID AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin chuyển nhận án đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra ADS_DON_DUONGSU
        SELECT COUNT(*) INTO v_count 
        FROM ADS_DON_DUONGSU 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin đương sự đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra ADS_DON_GIAIDOAN
        SELECT COUNT(*) INTO v_count 
        FROM ADS_DON_GIAIDOAN 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin giai đoạn đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra ADS_DON_TAILIEU
        SELECT COUNT(*) INTO v_count 
        FROM ADS_DON_TAILIEU 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin tài liệu đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra ADS_DON_THAMGIATOTUNG
        SELECT COUNT(*) INTO v_count 
        FROM ADS_DON_THAMGIATOTUNG 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin tham gia tố tụng đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra ADS_DON_THAMPHAN
        SELECT COUNT(*) INTO v_count 
        FROM ADS_DON_THAMPHAN 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin thẩm phán đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra ADS_DON_XULY
        SELECT COUNT(*) INTO v_count 
        FROM ADS_DON_XULY 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin xử lý đơn đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra ADS_FILE
     --   SELECT COUNT(*) INTO v_count 
     --   FROM ADS_FILE 
     --   WHERE DONID = v_VUVIECID 
     --    AND (NGAYTAO >= v_NGANHAN);
        
     --   IF v_count > 0 THEN
     --       p_result := 1;
     --       p_message := 'Thông tin đơn đã có thay đổi, không thể trả án.';
     --       RETURN;
     --   END IF;

        -- Kiểm tra ADS_KCKNQDK_PHUCTHAM_HDXX
        SELECT COUNT(*) INTO v_count 
        FROM ADS_KCKNQDK_PHUCTHAM_HDXX 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin HĐXX KCKNQDK phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra ADS_KCKNQDK_PHUCTHAM_QUYETDINH
        SELECT COUNT(*) INTO v_count 
        FROM ADS_KCKNQDK_PHUCTHAM_QUYETDINH 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin quyết định KCKNQDK phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra ADS_KCKNQDK_PHUCTHAM_THAMGIATOTUNG
        SELECT COUNT(*) INTO v_count 
        FROM ADS_KCKNQDK_PHUCTHAM_THAMGIATOTUNG 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin tham gia tố tụng KCKNQDK phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra ADS_KCKNQDK_PHUCTHAM_THULY
        SELECT COUNT(*) INTO v_count 
        FROM ADS_KCKNQDK_PHUCTHAM_THULY 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin thụ lý KCKNQDK phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra ADS_PHUCTHAM_BANAN
        SELECT COUNT(*) INTO v_count 
        FROM ADS_PHUCTHAM_BANAN 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin bản án phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra ADS_PHUCTHAM_BANAN_FILE
        SELECT COUNT(*) INTO v_count 
        FROM ADS_PHUCTHAM_BANAN_FILE f
        WHERE EXISTS (
            SELECT 1 FROM ADS_PHUCTHAM_BANAN b 
            WHERE b.DONID = v_VUVIECID AND b.ID = f.BANANID
        ) AND f.NGAYTAO >= v_NGANHAN;
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin bản án phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra ADS_PHUCTHAM_BANAN_TGTT
--        SELECT COUNT(*) INTO v_count 
--        FROM ADS_PHUCTHAM_BANAN_TGTT 
--        WHERE DONID = v_VUVIECID AND NGAYNHANBANAN >= v_NGANHAN;
--        
--        IF v_count > 0 THEN
--            p_result := 1;
--            p_message := 'Thông tin bản án phúc thẩm đã có thay đổi, không thể trả án.';
--            RETURN;
--        END IF;

         -- Kiểm tra ADS_PHUCTHAM_DUONGSU
--        SELECT COUNT(*) INTO v_count 
--        FROM ADS_PHUCTHAM_DUONGSU 
--        WHERE DONID = v_VUVIECID 
--          AND (NGAYTAO >= v_NGANHAN);
        
--        IF v_count > 0 THEN
--            p_result := 1;
--            p_message := 'Thông tin HĐXX phúc thẩm đã có thay đổi, không thể trả án.';
--            RETURN;
--        END IF;
        
        -- Kiểm tra ADS_PHUCTHAM_HDXX
        SELECT COUNT(*) INTO v_count 
        FROM ADS_PHUCTHAM_HDXX 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin HĐXX phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra ADS_PHUCTHAM_HOAGIAI
        SELECT COUNT(*) INTO v_count 
        FROM ADS_PHUCTHAM_HOAGIAI 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin hoà giải phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra ADS_PHUCTHAM_QUYETDINH
        SELECT COUNT(*) INTO v_count 
        FROM ADS_PHUCTHAM_QUYETDINH 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin quyết định phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra ADS_PHUCTHAM_THAMGIATOTUNG
        SELECT COUNT(*) INTO v_count 
        FROM ADS_PHUCTHAM_THAMGIATOTUNG 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin tham gia tố tụng phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra ADS_PHUCTHAM_THULY
        SELECT COUNT(*) INTO v_count 
        FROM ADS_PHUCTHAM_THULY 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin thụ lý phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra ADS_SAUXETXU
--        SELECT COUNT(*) INTO v_count 
--        FROM ADS_SAUXETXU 
--        WHERE VUANID = v_VUVIECID 
--          --  
--          AND (NGAYTAO >= v_NGANHAN);
--        
--        IF v_count > 0 THEN
--            p_result := 1;
--            p_message := 'Thông tin sau xét xử đã có thay đổi, không thể trả án.';
--            RETURN;
--        END IF;

        -- Kiểm tra ADS_SOTHAM_BANAN
        SELECT COUNT(*) INTO v_count 
        FROM ADS_SOTHAM_BANAN 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin bản án sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra ADS_SOTHAM_BANAN_ANPHI
        SELECT COUNT(*) INTO v_count 
        FROM ADS_SOTHAM_BANAN_ANPHI 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin án phí bản án sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra ADS_SOTHAM_BANAN_DIEULUAT
        SELECT COUNT(*) INTO v_count 
        FROM ADS_SOTHAM_BANAN_DIEULUAT 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin điều luật bản án sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra ADS_SOTHAM_BANAN_FILE
        SELECT COUNT(*) INTO v_count 
        FROM ADS_SOTHAM_BANAN_FILE 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin đơn bản án sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra ADS_SOTHAM_BANAN_TGTT
--        SELECT COUNT(*) INTO v_count 
--        FROM ADS_SOTHAM_BANAN_TGTT 
--        WHERE DONID = v_VUVIECID 
--          AND (NGAYTAO >= v_NGANHAN);
--        
--        IF v_count > 0 THEN
--            p_result := 1;
--            p_message := 'Thông tin đơn bản án sơ thẩm có thay đổi, không thể trả án.';
--            RETURN;
--        END IF;

        -- Kiểm tra ADS_SOTHAM_HDXX
        SELECT COUNT(*) INTO v_count 
        FROM ADS_SOTHAM_HDXX 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin HĐXX sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra ADS_SOTHAM_HOAGIAI
        SELECT COUNT(*) INTO v_count 
        FROM ADS_SOTHAM_HOAGIAI 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin hoà giải sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra ADS_SOTHAM_KHANGCAO
        SELECT COUNT(*) INTO v_count 
        FROM ADS_SOTHAM_KHANGCAO 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin kháng cáo sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

         -- Kiểm tra ADS_SOTHAM_KHANGNGHI
        SELECT COUNT(*) INTO v_count 
        FROM ADS_SOTHAM_KHANGNGHI 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin kháng nghị sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

         -- Kiểm tra ADS_SOTHAM_QUYETDINH
        SELECT COUNT(*) INTO v_count 
        FROM ADS_SOTHAM_QUYETDINH 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin quyết định sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

         -- Kiểm tra ADS_SOTHAM_RUTKCKN
        SELECT COUNT(*) INTO v_count 
        FROM ADS_SOTHAM_RUTKCKN 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin rút KCKN sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra ADS_SOTHAM_THAMGIATOTUNG
        SELECT COUNT(*) INTO v_count 
        FROM ADS_SOTHAM_THAMGIATOTUNG 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin tham gia TT sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

          -- Kiểm tra ADS_SOTHAM_THULY
        SELECT COUNT(*) INTO v_count 
        FROM ADS_SOTHAM_THULY 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin thụ lý sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

          -- Kiểm tra ADS_TONGDAT
        SELECT COUNT(*) INTO v_count 
        FROM ADS_TONGDAT 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin tống đạt có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra ADS_TONGDAT_DOITUONG
        SELECT COUNT(*) INTO v_count 
        FROM ADS_TONGDAT_DOITUONG f
        WHERE EXISTS (
            SELECT 1 FROM ADS_TONGDAT b 
            WHERE b.DONID = v_VUVIECID AND b.ID = f.TONGDATID
        ) 
          AND (f.NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin đối tượng tống đạt đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra ADS_TRUNGCAU_GIAMDINH
        SELECT COUNT(*) INTO v_count 
        FROM ADS_TRUNGCAU_GIAMDINH 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin trưng cầu giám định có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra ADS_XULY_VIPHAMHC
        SELECT COUNT(*) INTO v_count 
        FROM ADS_XULY_VIPHAMHC 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin xử lý vi phạm HC có thay đổi, không thể trả án.';
            RETURN;
        END IF;
                
        -- Kiểm tra DON_KHAC
        SELECT COUNT(*) INTO v_count 
        FROM DON_KHAC 
        WHERE DONID = v_VUVIECID  
          AND (NGAYNHANDON >= v_NGANHAN OR NGAYKHANGCAO >= v_NGANHAN) 
          AND LOAIANID = 2;
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin đơn đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra DON_KHAC_YEUCAU
        SELECT COUNT(*) INTO v_count 
        FROM DON_KHAC_YEUCAU y
        WHERE EXISTS (
            SELECT 1 FROM DON_KHAC d 
            WHERE d.DONID = v_VUVIECID 
              AND d.ID = y.DONKHACID
        ) AND (y.NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin đơn đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra DON_CHITIET
        SELECT COUNT(*) INTO v_count 
        FROM DON_CHITIET 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN) 
          AND LOAIANID = 2;
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin đơn đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra DON_DUONGSU_CHITIET
        SELECT COUNT(*) INTO v_count 
        FROM DON_DUONGSU_CHITIET 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN)
          AND LOAIAN = 2;
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin đương sự đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra HOSO_PT
        SELECT COUNT(*) INTO v_count 
        FROM HOSO_PT 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN)
          AND LOAIAN = 2;
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin hồ sơ phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
      EXCEPTION
          WHEN OTHERS THEN
              p_result := 1;
              p_message := 'Lỗi khi kiểm tra: ' || SQLERRM;
  END ADS_VUAN_BANGIAO_MAPPING_KTTHAYDOI;

    -- [ADS] TRẢ LẠI
    PROCEDURE ADS_VUAN_BANGIAO_MAPPING_TRALAI (
        p_ID IN NUMBER
    ) AS
        v_VUVIECID NUMBER;
        v_MAGIAIDOAN NUMBER;
        v_TOAANGIAOID NUMBER;
        v_TOAANNHANID NUMBER;

        v_tracedata VARCHAR2(1024);
        v_output VARCHAR2(512);
    BEGIN
        v_tracedata := '(' || 
         'p_ID => ' || p_ID || ',' ||
         ' );';

        -- Lấy thông tin Mapping
        SELECT VUVIECID, TOAANGIAOID, TOAANNHANID, MAGIAIDOAN
        INTO  v_VUVIECID, v_TOAANGIAOID, v_TOAANNHANID, v_MAGIAIDOAN
        FROM VUAN_BANGIAO_MAPPING
        WHERE ID = p_ID AND TRANGTHAI = 'TTBG_DANHAN';

        -- Xoá thông tin AN_DA_KET_THUC cho giai đoạn
        UPDATE ADS_DON_GIAIDOAN
        SET AN_DA_KET_THUC = NULL
        WHERE DONID = v_VUVIECID AND MAGIAIDOAN = v_MAGIAIDOAN AND (TOA_GIAIQUYET_ID = v_TOAANGIAOID OR TOA_PHUCTHAM_GIAIQUYET_ID = v_TOAANGIAOID);

        -- Xử lý cập nhật theo giai đoạn
        IF v_MAGIAIDOAN = 2 THEN
            -- SƠ THẨM
            -- Update ADS_DON
            UPDATE ADS_DON
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE ID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update ADS_SOTHAM_THULY
            UPDATE ADS_SOTHAM_THULY
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
            
            -- Update ADS_DON_GIAIDOAN
            UPDATE ADS_DON_GIAIDOAN
            SET TOAANID = TOA_GIAIQUYET_ID,
                AN_DA_KET_THUC = NULL
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update DON_CHITIET
            UPDATE DON_CHITIET
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND LOAIANID = 2 AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update ADS_TONGDAT
            UPDATE ADS_TONGDAT
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update DON_KHAC
            UPDATE DON_KHAC
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND LOAIANID = 2 AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update ADS_DON_XULY
            UPDATE ADS_DON_XULY
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update ADS_SOTHAM_BANAN
            UPDATE ADS_SOTHAM_BANAN
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update ADS_SOTHAM_QUYETDINH
            UPDATE ADS_SOTHAM_QUYETDINH
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update ADS_CHUYEN_NHAN_AN
            -- Theo TOACHUYENID 
            UPDATE ADS_CHUYEN_NHAN_AN 
            SET TOACHUYENID = TOA_GIAIQUYET_ID 
            WHERE VUANID = v_VUVIECID AND TOACHUYENID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
            
            -- Theo TOANHANID
            UPDATE ADS_CHUYEN_NHAN_AN
            SET TOANHANID = TOA_GIAIQUYET_NHAN_ID
            WHERE VUANID = v_VUVIECID AND TOANHANID = v_TOAANNHANID AND TOA_GIAIQUYET_NHAN_ID = v_TOAANGIAOID;

            -- Với trường hợp chuyển ST -> ST, sau khi chuyển án tạm đình chỉ
          	UPDATE ADS_CHUYEN_NHAN_AN
            SET TOANHANID = TOA_GIAIQUYET_NHAN_ID
			      WHERE VUANID in (SELECT CNA.MAP_VUANID_NEW
				                     FROM ADS_CHUYEN_NHAN_AN CNA
                             WHERE CNA.VUANID = v_VUVIECID AND CNA.MAP_VUANID_NEW IS NOT NULL);

            -- Với trường hợp chuyển ST -> ST, sau khi chuyển án không đủ thẩm quyền xét xử
            UPDATE ADS_CHUYEN_NHAN_AN
      			SET
      				TOANHANID = TOA_GIAIQUYET_NHAN_ID
      			WHERE
      				MAP_VUANID_NEW = v_VUVIECID AND MAP_VUANID_NEW IS NOT NULL;

        ELSIF v_MAGIAIDOAN IN (3,7) THEN
            -- PHÚC THẨM

            -- Update ADS_DON
            UPDATE ADS_DON
            SET TOAPHUCTHAMID = TOA_PHUCTHAM_GIAIQUYET_ID
            WHERE ID = v_VUVIECID AND TOAPHUCTHAMID = v_TOAANNHANID AND TOA_PHUCTHAM_GIAIQUYET_ID = v_TOAANGIAOID;

            UPDATE ADS_DON
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE ID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update ADS_PHUCTHAM_THULY

            UPDATE ADS_PHUCTHAM_THULY
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update ADS_DON_GIAIDOAN
            UPDATE ADS_DON_GIAIDOAN
            SET TOAPHUCTHAMID = TOA_PHUCTHAM_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAPHUCTHAMID = v_TOAANNHANID AND TOA_PHUCTHAM_GIAIQUYET_ID = v_TOAANGIAOID;

            UPDATE ADS_DON_GIAIDOAN
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- UPDATE ADS_KCKNQDK_PHUCTHAM_QUYETDINH
            UPDATE ADS_KCKNQDK_PHUCTHAM_QUYETDINH
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
            
            -- UPDATE ADS_KCKNQDK_PHUCTHAM_THULY
            UPDATE ADS_KCKNQDK_PHUCTHAM_THULY
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
            
            -- UPDATE ADS_PHUCTHAM_BANAN
            UPDATE ADS_PHUCTHAM_BANAN
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
            
            -- UPDATE ADS_PHUCTHAM_QUYETDINH
            UPDATE ADS_PHUCTHAM_QUYETDINH
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update ADS_TONGDAT
            UPDATE ADS_TONGDAT
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update DON_CHITIET
            UPDATE DON_CHITIET
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND LOAIANID = 2 AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update DON_KHAC
            UPDATE DON_KHAC
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND LOAIANID = 2 AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update HOSO_PT
            UPDATE HOSO_PT
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE VUANID = v_VUVIECID AND LOAIAN = 2 AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
            
            IF (v_MAGIAIDOAN = 7) THEN
              -- Update ADS_CHUYEN_NHAN_AN
              -- Theo TOACHUYENID 
              UPDATE ADS_CHUYEN_NHAN_AN 
	            SET TOACHUYENID = TOA_GIAIQUYET_ID 
	            WHERE MAP_VUANID_NEW = v_VUVIECID AND TOACHUYENID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
	            
              -- Theo TOANHANID 
	            UPDATE ADS_CHUYEN_NHAN_AN
	            SET TOANHANID = TOA_GIAIQUYET_NHAN_ID
	            WHERE MAP_VUANID_NEW = v_VUVIECID AND TOANHANID = v_TOAANNHANID AND TOA_GIAIQUYET_NHAN_ID = v_TOAANGIAOID;
           ELSE
	            -- Update ADS_CHUYEN_NHAN_AN
              -- Theo TOACHUYENID 
              UPDATE ADS_CHUYEN_NHAN_AN 
	            SET TOACHUYENID = TOA_GIAIQUYET_ID 
	            WHERE VUANID = v_VUVIECID AND TOACHUYENID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
	            
              -- Theo TOANHANID 
	            UPDATE ADS_CHUYEN_NHAN_AN
	            SET TOANHANID = TOA_GIAIQUYET_NHAN_ID
	            WHERE VUANID = v_VUVIECID AND TOANHANID = v_TOAANNHANID AND TOA_GIAIQUYET_NHAN_ID = v_TOAANGIAOID;
           END IF;
        END IF;
        
        -- Update TRANGTHAI cho VUAN_BANGIAO_MAPPING
        update VUAN_BANGIAO_MAPPING 
        SET TRANGTHAI = 'TTBG_CHONHAN'
        WHERE ID = p_ID;
        
        COMMIT;
        
    EXCEPTION
      WHEN OTHERS THEN
          -- Rollback in case of any exception
          ROLLBACK;

          v_output := 'Finish procedure Due to Exception: Error:' || SQLCODE || ',' || SQLERRM;
          PKG_TRACELOG.SP_INSERT_LOG_ERROR(
              p_functionname => 'PKG_BAN_GIAO_AN.ADS_VUAN_BANGIAO_MAPPING_TRALAI',
              p_description => v_output,
              p_notes => v_tracedata
          );

          -- Re-raise the exception
          RAISE;
    END ADS_VUAN_BANGIAO_MAPPING_TRALAI;
    
    -- [AHS] LẤY DANH SÁCH CÓ THỂ BÀN GIAO
    PROCEDURE AHS_VUAN_BANGIAO_MAPPING_GET_AN_BAN_GIAO (
         p_LOAIANID IN varchar2,
        p_TOAANID IN NUMBER,
        p_MAVUVIEC IN varchar2,
        p_THULYTUNGAY IN date,
        p_THULYDENNGAY IN date,
        p_TINHTRANGTHULY IN nvarchar2,
        p_THAMPHANGIAIQUYET IN nvarchar2,
        p_TENVUAN IN nvarchar2,    
        p_TRANGTHAIGIAIQUYET IN nvarchar2,    
        p_CAPXETXU IN nvarchar2,  
        p_TRANGTHAI IN NVARCHAR2,
        p_CURSOR OUT SYS_REFCURSOR
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
        V_TABLE_TIMKIEM             T_TIMKIEM_STPT_DS;
        
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
        
        FETCH_ID                VARCHAR2(255 CHAR);
        FETCH_MAVUVIEC          VARCHAR2(255 CHAR);
        FETCH_TENVUVIEC         VARCHAR2(4000 CHAR);
        FETCH_SOTHUTU           VARCHAR2(255 CHAR); 
        FETCH_NGAYNHANDON       VARCHAR2(255 CHAR);
        FETCH_HINHTHUCNHANDON   VARCHAR2(255 CHAR);
        FETCH_MAGIAIDOAN        VARCHAR2(255 CHAR);  
        FETCH_QHPLTKID          VARCHAR2(255 CHAR);
        FETCH_TOAANID           VARCHAR2(25 CHAR);
        FETCH_QUANHEPL          VARCHAR2(4000 CHAR);
        FETCH_BANAN_QD_ST       VARCHAR2(4000 CHAR);
        FETCH_QD_PT             VARCHAR2(4000 CHAR);
        FETCH_KHANGNGHI_ST      VARCHAR2(4000 CHAR);
        FETCH_CHECK_THULY       VARCHAR2(1000 CHAR);
        FETCH_HOTENBICAN        VARCHAR2(4000 CHAR);
        FETCH_COUNTALL          VARCHAR2(255 CHAR);
        FETCH_STT               VARCHAR2(1000 CHAR);
        FETCH_NGUOITAO          VARCHAR2(255 CHAR);
        FETCH_NGAY_TAO          VARCHAR2(255 CHAR);
        FETCH_NGAYTAO           VARCHAR2(255 CHAR);
        FETCH_TENTOASOTHAM      VARCHAR2(1000 CHAR);
        FETCH_GIAIDOANVUVIEC    VARCHAR2(255 CHAR);
        FETCH_TRUONGHOPGIAONHAN VARCHAR2(4000 CHAR);
        FETCH_KHANGCAO_ST       VARCHAR2(4000 CHAR);
        FETCH_TINHTRANG_GQ      VARCHAR2(4000 CHAR);
        FETCH_THULYXXLAI        VARCHAR2(1000 CHAR);
        FETCH_NGAYBANCAOTRANG        VARCHAR2(1000 CHAR); -- thêm cột 1 AHS
        FETCH_GIAIDOANTAOHOSO        VARCHAR2(1000 CHAR); -- thêm cột 2 AHS
        
        SUM_COUNTALL            NUMBER DEFAULT 0;
        CURSOR_RETURN           SYS_REFCURSOR;
        CURSOR_RETURN2           SYS_REFCURSOR;
        CURSOR_RETURN3           SYS_REFCURSOR;
        
        -- PROCESS_CURSOR: Xử lý cursor và capture COUNTALL từ record đầu tiên
        PROCEDURE PROCESS_CURSOR(P_CUR IN SYS_REFCURSOR, P_TYPE VARCHAR2, P_VAR NUMBER, P_TOAANID VARCHAR2) IS
            V_IS_FIRST_RECORD BOOLEAN := TRUE;
        BEGIN
            LOOP
                BEGIN
                    IF P_VAR = 1 THEN
                        -- FETCH cho PKG_STPT_AHS_GS.AHS_VUAN_GETALLPAGING (23 cột: STT, COUNTALL, ID, MAVUAN, TENVUAN, TT, NGAYBANCAOTRANG, NGAYTAO, NGUOITAO, MAGIAIDOAN, HOTENBICAN, TENTOASOTHAM, TRUONGHOPGIAONHAN, HINHTHUCNHANDON, GIAIDOANVUVIEC, GIAIDOANTAOHOSO, BANAN_QD_ST, KHANGNGHI_ST, KHANGCAO_ST, QD_PT, TINHTRANG_GQ, CHECK_THULY, THULYXXLAI)
                        FETCH P_CUR INTO FETCH_STT, FETCH_COUNTALL, FETCH_ID, FETCH_MAVUVIEC, 
                          FETCH_TENVUVIEC, FETCH_SOTHUTU, FETCH_NGAYBANCAOTRANG, FETCH_NGAYTAO, FETCH_NGUOITAO,
                          FETCH_MAGIAIDOAN, FETCH_HOTENBICAN, FETCH_TENTOASOTHAM, FETCH_TRUONGHOPGIAONHAN,
                          FETCH_HINHTHUCNHANDON, FETCH_GIAIDOANVUVIEC, FETCH_GIAIDOANTAOHOSO, FETCH_BANAN_QD_ST, 
                          FETCH_KHANGNGHI_ST, FETCH_KHANGCAO_ST, FETCH_QD_PT,
                          FETCH_TINHTRANG_GQ, FETCH_CHECK_THULY, FETCH_THULYXXLAI;
                    
                        EXIT WHEN P_CUR%NOTFOUND;
                        
                        -- Capture COUNTALL từ record đầu tiên của procedure 2
                        IF V_IS_FIRST_RECORD THEN
                            V_COUNTALL_PROC2 := TO_NUMBER(FETCH_COUNTALL);
                            V_IS_FIRST_RECORD := FALSE;
                        END IF;
                        
                        -- Gán giá trị cho các trường bị thiếu
                        FETCH_QHPLTKID := '';
                        FETCH_QUANHEPL := '';
                        FETCH_TOAANID := P_TOAANID;
                        FETCH_NGAY_TAO := FETCH_NGAYTAO;
                        FETCH_NGAYNHANDON := '';
                    ELSE
                        -- FETCH cho ADS_DON_SEARCH_TURNING (26 cột, thứ tự: ID, MAVUVIEC...)
                        FETCH P_CUR INTO FETCH_NGAYBANCAOTRANG, FETCH_GIAIDOANTAOHOSO,
                             FETCH_ID, FETCH_MAVUVIEC, FETCH_TENVUVIEC, FETCH_SOTHUTU, FETCH_NGAYNHANDON, FETCH_HINHTHUCNHANDON, FETCH_MAGIAIDOAN, FETCH_QHPLTKID,
                             FETCH_TOAANID, FETCH_QUANHEPL, FETCH_BANAN_QD_ST, FETCH_QD_PT,
                             FETCH_KHANGNGHI_ST, FETCH_CHECK_THULY, FETCH_HOTENBICAN, FETCH_COUNTALL, FETCH_STT,    
                             FETCH_NGAY_TAO,FETCH_NGUOITAO, FETCH_NGAYTAO, FETCH_TENTOASOTHAM, FETCH_GIAIDOANVUVIEC,
                             FETCH_TRUONGHOPGIAONHAN, FETCH_KHANGCAO_ST,
                             FETCH_TINHTRANG_GQ, FETCH_THULYXXLAI;
                    
                        EXIT WHEN P_CUR%NOTFOUND;
                        
                        -- Capture COUNTALL từ record đầu tiên của procedure 1
                        IF V_IS_FIRST_RECORD THEN
                            V_COUNTALL_PROC1 := TO_NUMBER(FETCH_COUNTALL);
                            V_IS_FIRST_RECORD := FALSE;
                        END IF;
                    END IF;
                    
                    -- Phần xử lý chung vẫn giữ nguyên
                    V_TABLE_TIMKIEM.EXTEND;
                    V_TABLE_TIMKIEM(V_TABLE_TIMKIEM.COUNT) := R_TIMKIEM_STPT_DS(FETCH_ID, FETCH_MAVUVIEC, FETCH_TENVUVIEC, FETCH_SOTHUTU, FETCH_NGAYNHANDON, FETCH_HINHTHUCNHANDON, FETCH_MAGIAIDOAN, FETCH_QHPLTKID,
                                                                             FETCH_TOAANID, FETCH_QUANHEPL, FETCH_BANAN_QD_ST, FETCH_QD_PT,
                                                                             FETCH_KHANGNGHI_ST, FETCH_CHECK_THULY, FETCH_HOTENBICAN, FETCH_COUNTALL, FETCH_STT,    
                                                                             FETCH_NGAY_TAO,FETCH_NGUOITAO, FETCH_NGAYTAO, FETCH_TENTOASOTHAM, FETCH_GIAIDOANVUVIEC,
                                                                             FETCH_TRUONGHOPGIAONHAN, FETCH_KHANGCAO_ST,
                                                                             FETCH_TINHTRANG_GQ, FETCH_THULYXXLAI, P_TYPE
                                                                            );
                END;
            END LOOP;
        END PROCESS_CURSOR;
    BEGIN
        
        -- Set fixed pagesize for optimal performance
        V_PROCEDURE_PAGESIZE := V_OPTIMIZED_PAGESIZE;
        
        IF p_THULYTUNGAY IS NOT NULL THEN 
            V_THULYTUNGAY := TO_CHAR(p_THULYTUNGAY, 'DD/MM/YYYY');
        ELSE
            V_THULYTUNGAY := '';
        END IF;  
    
        IF p_THULYDENNGAY IS NOT NULL THEN  
            V_THULYDENNGAY := TO_CHAR(p_THULYDENNGAY, 'DD/MM/YYYY'); 
        ELSE
            V_THULYDENNGAY := '';
        END IF;

SELECT LOAITOA
  INTO V_CAP_XET_XU_LOGIN
  FROM DM_TOAAN
  WHERE 1 = 1
    AND ID = P_TOAANID;
        V_TABLE_TIMKIEM := T_TIMKIEM_STPT_DS();
        
        -- LOGIC XỬ LÝ THEO p_TRANGTHAI
        IF p_TRANGTHAI = 1 THEN
            -- TRANGTHAI = 1: Lấy dữ liệu từ các toà được bàn giao (bao gồm cả p_TOAANID gốc)
            FOR toaan_rec IN (
                SELECT p_TOAANID AS TOTOAANID FROM DUAL
                UNION ALL
                SELECT TOTOAANID FROM DM_TOAAN_TACH_NHAP_MAPPING WHERE TOAANID = p_TOAANID
            ) LOOP
                V_CURRENT_TOAANID := toaan_rec.TOTOAANID;
                V_TRANGTHAIGIAIQUYET := '';

                -- BƯỚC 1: Lấy dữ liệu từ procedure 1 với TOTOAANDI
                PKG_AHS_STPT_DS.AHS_VUAN_SEARCH_TURNING(
                    V_CAP_XET_XU_LOGIN, -- V_CAP_XET_XU_LOGIN
                    p_TENVUAN, -- V_TEN_VU_AN
                    NULL, -- V_TOIDANH
                    p_MAVUVIEC, -- V_MA_VU_AN
                    NULL, -- V_BI_CAN
                    p_CAPXETXU, -- V_CAPXX
                    V_CURRENT_TOAANID, -- V_TOAAN_ID
                    p_TINHTRANGTHULY, -- V_TINHTRANG_THULY
                    V_THULYTUNGAY, -- V_NGAYTHULY_TU
                    V_THULYDENNGAY, -- V_NGAYTHULY_DEN
                    NULL, -- V_SOTHULY
                    V_TRANGTHAIGIAIQUYET, -- V_TINHTRANG_GIAIQUYET
                    NULL, -- V_TUNGAY
                    NULL, -- V_DENNGAY
                    NULL, -- V_KETQUA
                    NULL, -- V_SO_QD
                    NULL, -- V_NGAY_QD
                    p_THAMPHANGIAIQUYET, -- V_THAMPHAN_ID
                    NULL, -- V_THUKY_ID
                    NULL, -- V_THOIHAN_GQ
                    NULL, -- V_QD_TAMGIAM
                    NULL, -- V_UTTP
                    0, -- VCHECKTK
                    0, -- V_THANHNIEN
                    0, -- V_HINHTHUCXX
                    0, -- V_GDTAOHS
                    NULL, -- V_VAITRO_THAMPHAN,
                    NULL, -- AN_DA_KET_THUC
                    1, -- PAGE_INDEX
                    V_PROCEDURE_PAGESIZE, -- PAGE_SIZE
                    CURSOR_RETURN -- CURRETURN
                );
                IF CURSOR_RETURN IS NOT NULL THEN
                    PROCESS_CURSOR(CURSOR_RETURN, '1', 0, V_CURRENT_TOAANID);
                    CLOSE CURSOR_RETURN;
                END IF;
                    
                -- Không lấy án TĐC với cấp sơ thẩm và đã giải quyết xong
                IF P_CAPXETXU IS NULL OR p_CAPXETXU <> 2 THEN
                                                        
                  -- BƯỚC 2: Lấy dữ liệu từ procedure 2 với TOTOAANDI
                  PKG_STPT_AHS_GS.AHS_VUAN_GETALLPAGING(
                      V_CAP_XET_XU_LOGIN, -- V_CAP_XET_XU_LOGIN
                      p_TENVUAN, -- V_TEN_VU_AN
                      NULL, -- V_TOIDANH
                      p_MAVUVIEC, -- V_MA_VU_AN
                      NULL, -- V_BI_CAN
                      3, -- V_CAPXX
                      V_CURRENT_TOAANID, -- V_TOAAN_ID
                      p_TINHTRANGTHULY, -- V_TINHTRANG_THULY
                      V_THULYTUNGAY, -- V_NGAYTHULY_TU
                      V_THULYDENNGAY, -- V_NGAYTHULY_DEN
                      NULL, -- V_SOTHULY
                      P_TRANGTHAIGIAIQUYET, -- V_TINHTRANG_GIAIQUYET
                      NULL, -- V_TUNGAY
                      NULL, -- V_DENNGAY
                      NULL, -- V_KETQUA
                      NULL, -- V_SO_QD
                      NULL, -- V_NGAY_QD
                      p_THAMPHANGIAIQUYET, -- V_THAMPHAN_ID
                      NULL, -- V_THUKY_ID
                      NULL, -- V_THOIHAN_GQ
                      NULL, -- V_QD_TAMGIAM
                      NULL, -- V_UTTP
                      0, -- VCHECKTK
                      0, -- V_THANHNIEN
                      0, -- V_HINHTHUCXX
                      0, -- V_GDTAOHS
                      NULL, -- V_VAITRO_THAMPHAN
                      NULL, -- VU_AN_KET_THUC
                      1, -- PAGE_INDEX
                      V_PROCEDURE_PAGESIZE, -- PAGE_SIZE
                      CURSOR_RETURN2 -- CURRETURN
                  );
                                                             
                  IF CURSOR_RETURN2 IS NOT NULL THEN
                      PROCESS_CURSOR(CURSOR_RETURN2, '1', 1, V_CURRENT_TOAANID);
                      CLOSE CURSOR_RETURN2;
                  END IF;
                  
                  -- Bước 3: lấy dữ liệu chưa thụ lý với TRANGTHAIGIAIQUYET = ''
--                  IF (NVL(LENGTH(p_TINHTRANGTHULY),0) = 0) OR p_TINHTRANGTHULY = '2' THEN
--                      V_TRANGTHAIGIAIQUYET := '';
--                      V_TINHTRANGTHULY := '2';
--                      
--                      PKG_STPT_AHS_GS.AHS_VUAN_GETALLPAGING(
--                          V_CAP_XET_XU_LOGIN, -- V_CAP_XET_XU_LOGIN
--                          p_TENVUAN, -- V_TEN_VU_AN
--                          NULL, -- V_TOIDANH
--                          p_MAVUVIEC, -- V_MA_VU_AN
--                          NULL, -- V_BI_CAN
--                          3, -- V_CAPXX
--                          V_CURRENT_TOAANID, -- V_TOAAN_ID
--                          V_TINHTRANGTHULY, -- V_TINHTRANG_THULY
--                          V_THULYTUNGAY, -- V_NGAYTHULY_TU
--                          V_THULYDENNGAY, -- V_NGAYTHULY_DEN
--                          NULL, -- V_SOTHULY
--                          V_TRANGTHAIGIAIQUYET, -- V_TINHTRANG_GIAIQUYET
--                          NULL, -- V_TUNGAY
--                          NULL, -- V_DENNGAY
--                          NULL, -- V_KETQUA
--                          NULL, -- V_SO_QD
--                          NULL, -- V_NGAY_QD
--                          p_THAMPHANGIAIQUYET, -- V_THAMPHAN_ID
--                          NULL, -- V_THUKY_ID
--                          NULL, -- V_THOIHAN_GQ
--                          NULL, -- V_QD_TAMGIAM
--                          NULL, -- V_UTTP
--                          0, -- VCHECKTK
--                          0, -- V_THANHNIEN
--                          0, -- V_HINHTHUCXX
--                          0, -- V_GDTAOHS
--                          NULL, -- V_VAITRO_THAMPHAN
--                          1, -- PAGE_INDEX
--                          V_PROCEDURE_PAGESIZE, -- PAGE_SIZE
--                          CURSOR_RETURN3 -- CURRETURN
--                      );           
--                                                             
--                      IF CURSOR_RETURN3 IS NOT NULL THEN
--                          PROCESS_CURSOR(CURSOR_RETURN3, '1', 1, V_CURRENT_TOAANID);
--                          CLOSE CURSOR_RETURN3;
--                      END IF;
--                  END IF;

                END IF;
            END LOOP;
        ELSE
            -- TRANGTHAI = 0 hoặc NULL: Logic cũ với p_TOAANID
            -- BƯỚC 1: Lấy dữ liệu + COUNTALL từ procedure 1 (chỉ 1 lần gọi)
--            PKG_AHS_STPT_DS.AHS_VUAN_SEARCH_TURNING(V_CAP_XET_XU_LOGIN,p_TENVUAN,NULL,p_MAVUVIEC,NULL,p_CAPXETXU,p_TOAANID,p_TINHTRANGTHULY,
--                                                    V_THULYTUNGAY,V_THULYDENNGAY,NULL,p_THAMPHANGIAIQUYET,p_TRANGTHAIGIAIQUYET,NULL,NULL,NULL,
--                                                    NULL,NULL,NULL,NULL, NULL,NULL,NULL,NULL,0,NULL,NULL,1, 1,0,0,NULL,NULL,
--                                                    1, V_PROCEDURE_PAGESIZE, CURSOR_RETURN);
            PKG_AHS_STPT_DS.AHS_VUAN_SEARCH_TURNING(
                V_CAP_XET_XU_LOGIN, -- V_CAP_XET_XU_LOGIN
                p_TENVUAN, -- V_TEN_VU_AN
                NULL, -- V_TOIDANH
                p_MAVUVIEC, -- V_MA_VU_AN
                NULL, -- V_BI_CAN
                p_CAPXETXU, -- V_CAPXX
                p_TOAANID, -- V_TOAAN_ID
                p_TINHTRANGTHULY, -- V_TINHTRANG_THULY
                V_THULYTUNGAY, -- V_NGAYTHULY_TU
                V_THULYDENNGAY, -- V_NGAYTHULY_DEN
                NULL, -- V_SOTHULY
                p_TRANGTHAIGIAIQUYET, -- V_TINHTRANG_GIAIQUYET
                NULL, -- V_TUNGAY
                NULL, -- V_DENNGAY
                NULL, -- V_KETQUA
                NULL, -- V_SO_QD
                NULL, -- V_NGAY_QD
                p_THAMPHANGIAIQUYET, -- V_THAMPHAN_ID
                NULL, -- V_THUKY_ID
                NULL, -- V_THOIHAN_GQ
                NULL, -- V_QD_TAMGIAM
                NULL, -- V_UTTP
                0, -- VCHECKTK
                0, -- V_THANHNIEN
                0, -- V_HINHTHUCXX
                0, -- V_GDTAOHS
                NULL, -- V_VAITRO_THAMPHAN
                NULL, -- AN_DA_KET_THUC
                1, -- PAGE_INDEX
                V_PROCEDURE_PAGESIZE, -- PAGE_SIZE
                CURSOR_RETURN -- CURRETURN
            );
            IF CURSOR_RETURN IS NOT NULL THEN
                PROCESS_CURSOR(CURSOR_RETURN, '1', 0, p_TOAANID);
                CLOSE CURSOR_RETURN;
            END IF;

            -- Không lấy án TĐC với cấp sơ thẩm và đã giải quyết xong
            IF (P_CAPXETXU IS NULL OR p_CAPXETXU <> 2) THEN
                                                    
              -- BƯỚC 2: Lấy dữ liệu + COUNTALL từ procedure 2 (chỉ 1 lần gọi)
              PKG_STPT_AHS_GS.AHS_VUAN_GETALLPAGING(
                  V_CAP_XET_XU_LOGIN, -- V_CAP_XET_XU_LOGIN
                  p_TENVUAN, -- V_TEN_VU_AN
                  NULL, -- V_TOIDANH
                  p_MAVUVIEC, -- V_MA_VU_AN
                  NULL, -- V_BI_CAN
                  3, -- V_CAPXX
                  p_TOAANID, -- V_TOAAN_ID
                  p_TINHTRANGTHULY, -- V_TINHTRANG_THULY
                  V_THULYTUNGAY, -- V_NGAYTHULY_TU
                  V_THULYDENNGAY, -- V_NGAYTHULY_DEN
                  NULL, -- V_SOTHULY
                  p_TRANGTHAIGIAIQUYET, -- V_TINHTRANG_GIAIQUYET
                  NULL, -- V_TUNGAY
                  NULL, -- V_DENNGAY
                  NULL, -- V_KETQUA
                  NULL, -- V_SO_QD
                  NULL, -- V_NGAY_QD
                  p_THAMPHANGIAIQUYET, -- V_THAMPHAN_ID
                  NULL, -- V_THUKY_ID
                  NULL, -- V_THOIHAN_GQ
                  NULL, -- V_QD_TAMGIAM
                  NULL, -- V_UTTP
                  0, -- VCHECKTK
                  0, -- V_THANHNIEN
                  0, -- V_HINHTHUCXX
                  0, -- V_GDTAOHS
                  NULL, -- V_VAITRO_THAMPHAN
                  NULL, -- VU_AN_KET_THUC
                  1, -- PAGE_INDEX
                  V_PROCEDURE_PAGESIZE, -- PAGE_SIZE
                  CURSOR_RETURN2 -- CURRETURN
              );
  --                                                       
              IF CURSOR_RETURN2 IS NOT NULL THEN
                  PROCESS_CURSOR(CURSOR_RETURN2, '1', 1, p_TOAANID);
                  CLOSE CURSOR_RETURN2;
              END IF;
              
              -- Bước 3: lấy dữ liệu chưa thụ lý với TRANGTHAIGIAIQUYET = ''
              IF (NVL(LENGTH(p_TINHTRANGTHULY),0) = 0) OR p_TINHTRANGTHULY = '2' THEN
                  V_TRANGTHAIGIAIQUYET := '';
                  V_TINHTRANGTHULY := '2';
                  
                  PKG_STPT_AHS_GS.AHS_VUAN_GETALLPAGING(
                      V_CAP_XET_XU_LOGIN, -- V_CAP_XET_XU_LOGIN
                      p_TENVUAN, -- V_TEN_VU_AN
                      NULL, -- V_TOIDANH
                      p_MAVUVIEC, -- V_MA_VU_AN
                      NULL, -- V_BI_CAN
                      3, -- V_CAPXX
                      p_TOAANID, -- V_TOAAN_ID
                      V_TINHTRANGTHULY, -- V_TINHTRANG_THULY
                      V_THULYTUNGAY, -- V_NGAYTHULY_TU
                      V_THULYDENNGAY, -- V_NGAYTHULY_DEN
                      NULL, -- V_SOTHULY
                      V_TRANGTHAIGIAIQUYET, -- V_TINHTRANG_GIAIQUYET
                      NULL, -- V_TUNGAY
                      NULL, -- V_DENNGAY
                      NULL, -- V_KETQUA
                      NULL, -- V_SO_QD
                      NULL, -- V_NGAY_QD
                      p_THAMPHANGIAIQUYET, -- V_THAMPHAN_ID
                      NULL, -- V_THUKY_ID
                      NULL, -- V_THOIHAN_GQ
                      NULL, -- V_QD_TAMGIAM
                      NULL, -- V_UTTP
                      0, -- VCHECKTK
                      0, -- V_THANHNIEN
                      0, -- V_HINHTHUCXX
                      0, -- V_GDTAOHS
                      NULL, -- V_VAITRO_THAMPHAN
                      NULL, -- VU_AN_KET_THUC
                      1, -- PAGE_INDEX
                      V_PROCEDURE_PAGESIZE, -- PAGE_SIZE
                      CURSOR_RETURN3 -- CURRETURN
                  );
      --                                                       
                  IF CURSOR_RETURN3 IS NOT NULL THEN
                      PROCESS_CURSOR(CURSOR_RETURN3, '1', 1, p_TOAANID);
                      CLOSE CURSOR_RETURN3;
                  END IF;
              END IF;

            END IF;
        END IF;
        
        -- BƯỚC 3: Tính tổng COUNTALL thực tế
        V_REAL_COUNTALL := V_COUNTALL_PROC1 + V_COUNTALL_PROC2;
            
        -- BƯỚC 4: Final query với DISTINCT để loại bỏ duplicate (bỏ STT)
        OPEN p_CURSOR FOR
SELECT DISTINCT V_REAL_COUNTALL AS COUNTALL,
                A.ID,
                A.MAVUVIEC,
                A.TENVUVIEC,
                A.SOTHUTU,
                A.NGAYNHANDON,
                A.HINHTHUCNHANDON,
                A.MAGIAIDOAN,
                A.QHPLTKID,
                A.TOAANID,
                A.QUANHEPL,
                A.BANAN_QD_ST,
                A.QD_PT,
                A.KHANGNGHI_ST,
                A.CHECK_THULY,
                A.HOTENBICAN,
                A.NGUOITAO,
                A.NGAY_TAO AS NGAYTHULY,
                A.NGAYTAO,
                A.TENTOASOTHAM,
                A.GIAIDOANVUVIEC,
                A.TRUONGHOPGIAONHAN,
                A.KHANGCAO_ST,
                A.TINHTRANG_GQ,
                A.THULYXXLAI,
                A.LOAIAN_ID,
                LA.LOAI_AN_TEN,
                B.ID AS MAPPINGID,
                B.LYDOMA AS LYDO,
                B.NGAYGIAO AS THOIGIANBANGIAO,
                B.TRANGTHAI,
                C.TEN AS TOANHAN,
                LD.TEN AS LYDOTEN
  FROM TABLE (V_TABLE_TIMKIEM) A
    LEFT JOIN DM_LOAIAN LA
      ON LA.ID = A.LOAIAN_ID
    LEFT JOIN VUAN_BANGIAO_MAPPING B
      ON A.ID = B.VUVIECID
      AND B.TOAANGIAOID = P_TOAANID
      AND B.VUVIECLOAI = 'AN_HINHSU'
      AND (1 = (CASE 
                    WHEN P_TRANGTHAI = 0 THEN 1
                    WHEN P_TRANGTHAIGIAIQUYET IS NULL THEN 1
                    WHEN P_TRANGTHAIGIAIQUYET = 1 THEN 
                        CASE WHEN B.TRANGTHAIGIAIQUYET = 1 OR B.TRANGTHAIGIAIQUYET IS NULL THEN 1 ELSE 0 END
                    WHEN P_TRANGTHAIGIAIQUYET = 7 THEN 
                        CASE WHEN B.TRANGTHAIGIAIQUYET = 7 THEN 1 ELSE 0 END
                    ELSE 0
                END))
    LEFT JOIN DM_TOAAN C
      ON CASE WHEN B.TOAANNHANID IS NULL THEN 0 ELSE B.TOAANNHANID END = C.ID
    LEFT JOIN DM_DATAITEM LD
      ON B.LYDOMA = LD.MA
  WHERE 1 = 1
    -- Loại trừ những bản ghi mapping mà toà hiện tại đã nhận (TOAANNHANID = p_TOAANID)
    AND (B.TOAANNHANID IS NULL
    OR B.TOAANNHANID != P_TOAANID)
    AND (1 = (CASE
      -- TRANGTHAI = 0: Loại bỏ những bản ghi đã có mapping với toaangiaoid = p_toaanid
      WHEN P_TRANGTHAI = 0 THEN CASE WHEN NOT EXISTS (SELECT 1
                  FROM VUAN_BANGIAO_MAPPING VM
                  WHERE VM.VUVIECID = A.ID
                    AND VM.TOAANGIAOID = P_TOAANID
                    AND VM.VUVIECLOAI = 'AN_HINHSU') THEN 1 ELSE 0 END
      -- TRANGTHAI = 1: Chỉ lấy những bản ghi có mapping 
      WHEN P_TRANGTHAI = 1 AND
        B.TRANGTHAI IS NOT NULL THEN 1
      -- TRANGTHAI = NULL hoặc khác: Lấy tất cả
      WHEN P_TRANGTHAI IS NULL THEN 1 WHEN P_TRANGTHAI NOT IN (0, 1) THEN 1 ELSE 0 END))
  ORDER BY A.ID DESC,
           B.ID DESC;
    END AHS_VUAN_BANGIAO_MAPPING_GET_AN_BAN_GIAO;

    -- [AHS] LẤY DANH SÁCH CHỜ DUYỆT
    PROCEDURE AHS_VUAN_BANGIAO_MAPPING_GETS_CHONHAN (
        p_LOAIANID IN varchar2,
        p_TOAANID IN NUMBER,
        p_MAVUVIEC IN varchar2,
        p_THULYTUNGAY IN date,
        p_THULYDENNGAY IN date,
        p_TINHTRANGTHULY IN nvarchar2,
        p_THAMPHANGIAIQUYET IN nvarchar2,
        p_TENVUAN IN nvarchar2,    
        p_TRANGTHAIGIAIQUYET IN nvarchar2,    
        p_CAPXETXU IN nvarchar2,  
        p_TRANGTHAI IN NVARCHAR2,
        p_CURSOR OUT SYS_REFCURSOR
    ) AS
        BEGIN
            OPEN p_CURSOR FOR
                SELECT  
                    DISTINCT
                    -- Mapping
                    mapping.ID as MAPPINGID,
                    mapping.NGAYGIAO,
                    mapping.NGAYNHAN,
                    mapping.TRANGTHAI,
                    mapping.GHICHU,
                    -- Vụ việc
                    don.ID AS VUVIECID,
                    don.MAVUAN AS VUVIECMA,
                    don.TENVUAN AS VUVIECTEN, 
                    -- Toà giao
                    mapping.TOAANGIAOID,
                    taGiao.TEN AS TOAANGIAOTEN,
                    -- Toà nhận
                    mapping.TOAANNHANID,
                    -- Lý do
                    mapping.LYDOMA,
                    lyDo.TEN AS LYDOTEN
                from AHS_VUAN don 
                JOIN VUAN_BANGIAO_MAPPING mapping ON don.ID = mapping.VUVIECID AND MAPPING.VUVIECLOAI = 'AN_HINHSU'
                JOIN DM_TOAAN taGiao ON case when mapping.TOAANGIAOID is null then 0 else mapping.TOAANGIAOID end = taGiao.ID
                JOIN DM_TOAAN taNhan ON case when mapping.TOAANNHANID is null then 0 else mapping.TOAANNHANID end = taNhan.ID
                JOIN DM_DATAITEM lyDo ON mapping.LYDOMA = lyDo.MA
                LEFT JOIN AHS_SOTHAM_THULY thuLy ON don.ID = thuLy.VUANID
                LEFT JOIN AHS_phuctham_thuly E ON don.ID = e.VUANID
                WHERE mapping.TOAANNHANID = P_TOAANID 
                AND  (1=(CASE WHEN (p_MAVUVIEC || ' ')=' '  THEN 1 WHEN LOWER(don.MAVUAN) LIKE  ('%' || LOWER(p_MAVUVIEC) || '%') THEN 1 Else 0 END))
                AND  (1=(CASE WHEN (p_TENVUAN|| ' ')=' '  THEN 1 WHEN LOWER(don.TENVUAN) LIKE  ('%' || LOWER(p_TENVUAN) || '%') THEN 1 Else 0 END))
                And (1=(CASE WHEN p_THULYTUNGAY is NULL THEN 1 WHEN thuLy.NGAYTHULY >= p_THULYTUNGAY  THEN 1 Else 0 END))
                And (1=(CASE WHEN p_THULYDENNGAY is NULL THEN 1 WHEN thuLy.NGAYTHULY <= p_THULYDENNGAY  THEN 1 Else 0 END))  
                AND  (1=(CASE WHEN p_TINHTRANGTHULY IS NULL THEN 1
                            WHEN p_TINHTRANGTHULY = 1 AND 
                                 (CASE WHEN don.MAGIAIDOAN = 2 THEN thuLy.truonghopthuly  -- Cap So Tham
                                       WHEN don.MAGIAIDOAN IN (3,7) THEN E.truonghopthuly  -- Cap Phuc Tham
                                       ELSE thuLy.truonghopthuly END) IS NOT NULL THEN 1 -- Da thu ly
                            WHEN p_TINHTRANGTHULY = 2 AND 
                                 (CASE WHEN don.MAGIAIDOAN = 2 THEN thuLy.truonghopthuly -- Cap So Tham
                                       WHEN don.MAGIAIDOAN IN (3,7) THEN E.truonghopthuly -- Cap Phuc Tham
                                       ELSE thuLy.truonghopthuly END) IS NULL THEN 1 -- Chua thu ly
                        WHEN p_TINHTRANGTHULY NOT IN (1, 2) THEN 1 ELSE 0 END))
--                AND  (1=(CASE WHEN (p_THAMPHANGIAIQUYET|| ' ')=' '  THEN 1 WHEN LOWER(cb.HOTEN) LIKE  ('%' || LOWER(p_THAMPHANGIAIQUYET) || '%') THEN 1 
--                            WHEN LOWER(cb.MACANBO) LIKE  ('%' || LOWER(p_THAMPHANGIAIQUYET) || '%') THEN 1 Else 0 END))
                --AND  (1=(CASE WHEN (p_TRANGTHAIGIAIQUYET|| ' ')=' ' THEN 1 WHEN don.TRANGTHAI LIKE P_TRANGTHAIGIAIQUYET THEN 1 Else 0 END))
                -- Trạng thái giải quyết
                AND (1 = (CASE 
                              WHEN P_TRANGTHAIGIAIQUYET IS NULL THEN 1
                              WHEN P_TRANGTHAIGIAIQUYET = '1' THEN 
                                  CASE WHEN MAPPING.TRANGTHAIGIAIQUYET = '1' OR MAPPING.TRANGTHAIGIAIQUYET IS NULL THEN 1 ELSE 0 END
                              WHEN P_TRANGTHAIGIAIQUYET = '7' THEN 
                                  CASE WHEN MAPPING.TRANGTHAIGIAIQUYET = '7' THEN 1 ELSE 0 END
                              ELSE 0
                          END))
                -- Cấp xét xử
                AND (1 = (CASE WHEN p_CAPXETXU IS NULL THEN 1
                            WHEN p_CAPXETXU = 2 AND mapping.MAGIAIDOAN = 2 THEN 1 -- Cap So Tham
                            WHEN p_CAPXETXU = 3 AND mapping.MAGIAIDOAN IN (3,7) THEN 1 -- Cap Phuc Tham
                            WHEN p_CAPXETXU NOT IN (2, 3) THEN 1
                            ELSE 0 END))
                AND  (1=(CASE WHEN (p_TRANGTHAI|| ' ')=' '  THEN 1 WHEN LOWER(mapping.TRANGTHAI) = LOWER(p_TRANGTHAI) THEN 1 Else 0 END))
                ORDER BY mapping.ID DESC;
    END AHS_VUAN_BANGIAO_MAPPING_GETS_CHONHAN;

    -- [AHS] NHẬN BÀN GIAO
    PROCEDURE AHS_VUAN_BANGIAO_MAPPING_NHAN (
        p_ID IN NUMBER,
        p_VUVIECID IN NUMBER,
        p_TOAANNHANID IN NUMBER,
        p_NGAYNHAN IN DATE
    ) AS
        v_MAGIAIDOAN NUMBER;
        v_TOAANID NUMBER;
        v_TOAPHUCTHAMID NUMBER;
        v_TRANGTHAIGIAIQUYET VARCHAR2(20);

        v_THAVUANID NUMBER;

        v_tracedata VARCHAR2(1024);
        v_output VARCHAR2(512);
    BEGIN
        v_tracedata := '(' || 
         'p_ID => ' || p_ID || ',' ||
         'p_VUVIECID => ' || p_VUVIECID || ',' ||
         'p_TOAANNHANID => ' || p_TOAANNHANID || ',' ||
         'p_NGAYNHAN => ' || p_NGAYNHAN || ',' ||
         ' );';

        -- Lấy giai đoạn hiện tại của án
        SELECT don.TOAANID, don.TOAPHUCTHAMID
        INTO v_TOAANID, v_TOAPHUCTHAMID
        FROM AHS_VUAN don 
        WHERE don.ID = p_VUVIECID;

        -- Lấy thông tin mapping
        SELECT vbm.MAGIAIDOAN, vbm.TRANGTHAIGIAIQUYET
        INTO v_MAGIAIDOAN, v_TRANGTHAIGIAIQUYET
        FROM VUAN_BANGIAO_MAPPING vbm
        WHERE vbm.ID = p_ID AND vbm.TRANGTHAI = 'TTBG_CHONHAN';

        -- Kiểm tra giai đoạn hợp lệ
        IF v_MAGIAIDOAN NOT IN (2, 3, 7) THEN
            RAISE_APPLICATION_ERROR(-20001, 'Giai đoạn không hợp lệ.');
        END IF;

        -- Cập nhật án đã kết thúc với trạng thái giải quyết = 7
        UPDATE AHS_VUAN_GIAIDOAN
        SET AN_DA_KET_THUC = CASE 
                -- Logic gốc
                WHEN v_TRANGTHAIGIAIQUYET = 7 AND 
                    NOT EXISTS ( -- Kiểm tra nếu bản ghi gần nhất có LOAIID in (221, 222) thì set NULL - VKS trả lại
                      SELECT 1 
                      FROM AHS_SOTHAM_QUYETDINH_VUAN sq
                      WHERE sq.VUANID = p_VUVIECID
                      AND sq.NGAYTAO = (
                          SELECT MAX(sq2.NGAYTAO) 
                          FROM AHS_SOTHAM_QUYETDINH_VUAN sq2 
                          WHERE sq2.VUANID = p_VUVIECID
                      )
                      AND sq.QUYETDINHID IN (221, 222)
                  ) 
                THEN 1 
                ELSE AN_DA_KET_THUC 
            END
        WHERE VUANID = p_VUVIECID AND MAGIAIDOAN = v_MAGIAIDOAN;

        -- Xử lý cập nhật theo giai đoạn
        IF v_MAGIAIDOAN = 2 THEN
            -- SƠ THẨM
            -- Update AHS_VUAN
            -- backup
            UPDATE AHS_VUAN
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE ID = p_VUVIECID AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE AHS_VUAN
            SET TOAANID = p_TOAANNHANID
            WHERE ID = P_VUVIECID AND TOAANID = v_TOAANID;

            -- Kiểm tra xem có update được chính xác 1 bản ghi AHS_VUAN hay không
--            IF SQL%ROWCOUNT != 1 THEN
--                ROLLBACK;
--                RAISE_APPLICATION_ERROR(-20002, 'Lỗi cập nhật AHS_VUAN (Sơ thẩm)');
--            END IF;
--            
            -- Update TOAID cho AHS_SOTHAM_THULY
--            UPDATE AHS_SOTHAM_THULY
--            SET TOA_GIAIQUYET_ID = v_TOAANID,
--                TOAANID = p_TOAANNHANID
--            WHERE VUANID = p_VUVIECID;
            
            -- Update AHS_DON_GIAIDOAN
            -- backup
            UPDATE AHS_VUAN_GIAIDOAN
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE VUANID = p_VUVIECID AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL AND MAGIAIDOAN = v_MAGIAIDOAN;

            UPDATE AHS_VUAN_GIAIDOAN
            SET TOAANID = p_TOAANNHANID
            WHERE VUANID = p_VUVIECID AND TOAANID = v_TOAANID AND MAGIAIDOAN = v_MAGIAIDOAN;

            -- Update DON_CHITIET
            -- backup
            UPDATE DON_CHITIET
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND LOAIANID = 1 AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE DON_CHITIET
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND LOAIANID = 1 AND TOAANID = v_TOAANID;

            -- Update AHS_TONGDAT
            -- backup
            UPDATE AHS_TONGDAT
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE VUANID = p_VUVIECID AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE AHS_TONGDAT
            SET TOAANID = p_TOAANNHANID
            WHERE VUANID = p_VUVIECID AND TOAANID = v_TOAANID;

          -- Update DON_KHAC
          -- backup
            UPDATE DON_KHAC
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND LOAIANID = 1 AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE DON_KHAC
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND LOAIANID = 1 AND TOAANID = v_TOAANID;

            -- Update AHS_DON_XULY
            -- backup
--            UPDATE AHS_DON_XULY
--            SET TOA_GIAIQUYET_ID = TOAANID
--            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;
--
--            UPDATE AHS_DON_XULY
--            SET TOAANID = p_TOAANNHANID
--            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID;

            -- Update AHS_SOTHAM_BANAN
            -- backup
            UPDATE AHS_SOTHAM_BANAN
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE VUANID = p_VUVIECID AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE AHS_SOTHAM_BANAN
            SET TOAANID = p_TOAANNHANID
            WHERE VUANID = p_VUVIECID AND TOAANID = v_TOAANID; 

            -- Update AHS_SOTHAM_QUYETDINH_BICAN
            -- backup
            UPDATE AHS_SOTHAM_QUYETDINH_BICAN
            SET TOA_GIAIQUYET_ID = DONVIID
            WHERE VUANID = p_VUVIECID AND DONVIID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE AHS_SOTHAM_QUYETDINH_BICAN
            SET DONVIID = p_TOAANNHANID
            WHERE VUANID = p_VUVIECID AND DONVIID = v_TOAANID; 

            -- Update AHS_SOTHAM_QUYETDINH_VUAN
            -- backup
            UPDATE AHS_SOTHAM_QUYETDINH_VUAN
            SET TOA_GIAIQUYET_ID = DONVIID
            WHERE VUANID = p_VUVIECID AND DONVIID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE AHS_SOTHAM_QUYETDINH_VUAN
            SET DONVIID = p_TOAANNHANID
            WHERE VUANID = p_VUVIECID AND DONVIID = v_TOAANID; 

            -- Update AHS_CHUYEN_NHAN_AN
            -- Theo TOACHUYENID 
             -- backup
            UPDATE AHS_CHUYEN_NHAN_AN
            SET TOA_GIAIQUYET_ID = TOACHUYENID
            WHERE VUANID = p_VUVIECID AND TOACHUYENID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE AHS_CHUYEN_NHAN_AN 
            SET TOACHUYENID = p_TOAANNHANID 
            WHERE VUANID = p_VUVIECID AND TOACHUYENID = v_TOAANID;
            
            -- Theo TOANHANID
            -- backup
            UPDATE AHS_CHUYEN_NHAN_AN
            SET TOA_GIAIQUYET_NHAN_ID = TOANHANID
            WHERE VUANID = p_VUVIECID AND TOANHANID = v_TOAANID AND TOA_GIAIQUYET_NHAN_ID IS NULL;

            UPDATE AHS_CHUYEN_NHAN_AN
            SET TOANHANID = p_TOAANNHANID
            WHERE VUANID = p_VUVIECID AND TOANHANID = v_TOAANID;

            -- Với trường hợp chuyển ST -> ST, sau khi chuyển án tạm đình chỉ
            UPDATE AHS_CHUYEN_NHAN_AN
      			SET
      				TOA_GIAIQUYET_NHAN_ID = TOANHANID,
      				TOANHANID = p_TOAANNHANID
      			WHERE
      				VUANID in (
        				SELECT CNA.MAP_VUANID_NEW
        				FROM AHS_CHUYEN_NHAN_AN CNA
        				WHERE CNA.VUANID = p_VUVIECID AND CNA.MAP_VUANID_NEW IS NOT NULL
              );

            -- Với trường hợp chuyển ST -> ST, sau khi chuyển án không đủ thẩm quyền xét xử
            UPDATE AHS_CHUYEN_NHAN_AN
      			SET
      				TOA_GIAIQUYET_NHAN_ID = TOANHANID,
      				TOANHANID = p_TOAANNHANID
      			WHERE
      				MAP_VUANID_NEW = p_VUVIECID AND MAP_VUANID_NEW IS NOT NULL;
            
        ELSIF v_MAGIAIDOAN IN(3,7) THEN
            -- PHÚC THẨM

            -- Update AHS_VUAN
            -- backup
            UPDATE AHS_VUAN
            SET TOA_PHUCTHAM_GIAIQUYET_ID = TOAPHUCTHAMID
            WHERE ID = p_VUVIECID AND TOAPHUCTHAMID = v_TOAPHUCTHAMID AND TOA_PHUCTHAM_GIAIQUYET_ID IS NULL;

            UPDATE AHS_VUAN
            SET TOAPHUCTHAMID = p_TOAANNHANID
            WHERE ID = p_VUVIECID AND TOAPHUCTHAMID = v_TOAPHUCTHAMID;

            -- backup
            UPDATE AHS_VUAN
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE ID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE AHS_VUAN
            SET TOAANID = p_TOAANNHANID
            WHERE ID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID;

            -- Kiểm tra xem có update được chính xác 1 bản ghi AHS_VUAN hay không
--            IF SQL%ROWCOUNT != 1 THEN
--                ROLLBACK;
--                RAISE_APPLICATION_ERROR(-20003, 'Lỗi cập nhật AHS_VUAN (Phúc thẩm)');
--            END IF;
            
            -- Update AHS_PHUCTHAM_THULY
            -- backup
            UPDATE AHS_PHUCTHAM_THULY
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE VUANID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE AHS_PHUCTHAM_THULY
            SET TOAANID = p_TOAANNHANID
            WHERE VUANID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID;
            
            -- Update TOAID AHS_DON_GIAIDOAN
            -- backup
            UPDATE AHS_VUAN_GIAIDOAN
            SET TOA_PHUCTHAM_GIAIQUYET_ID = TOAPHUCTHAMID
            WHERE VUANID = p_VUVIECID AND TOAPHUCTHAMID = v_TOAPHUCTHAMID AND TOA_PHUCTHAM_GIAIQUYET_ID IS NULL AND MAGIAIDOAN = v_MAGIAIDOAN;

            UPDATE AHS_VUAN_GIAIDOAN
            SET TOAPHUCTHAMID = p_TOAANNHANID
            WHERE VUANID = p_VUVIECID AND TOAPHUCTHAMID = v_TOAPHUCTHAMID AND MAGIAIDOAN = v_MAGIAIDOAN;

            -- backup
            UPDATE AHS_VUAN_GIAIDOAN
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE VUANID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE AHS_VUAN_GIAIDOAN
            SET TOAANID = p_TOAANNHANID
            WHERE VUANID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID;
            
            -- UPDATE AHS_KCKNQDK_PHUCTHAM_QUYETDINH_BICAN
            -- backup
            UPDATE AHS_KCKNQDK_PHUCTHAM_QUYETDINH_BICAN
            SET TOA_GIAIQUYET_ID = DONVIID
            WHERE VUANID = p_VUVIECID AND DONVIID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE AHS_KCKNQDK_PHUCTHAM_QUYETDINH_BICAN
            SET DONVIID = p_TOAANNHANID
            WHERE VUANID = p_VUVIECID AND DONVIID = v_TOAPHUCTHAMID;

            -- UPDATE AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN
            -- backup
            UPDATE AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN
            SET TOA_GIAIQUYET_ID = DONVIID
            WHERE VUANID = p_VUVIECID AND DONVIID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN
            SET DONVIID = p_TOAANNHANID
            WHERE VUANID = p_VUVIECID AND DONVIID = v_TOAPHUCTHAMID;

            -- UPDATE AHS_KCKNQDK_PHUCTHAM_THULY
            -- backup
            UPDATE AHS_KCKNQDK_PHUCTHAM_THULY
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE VUANID = p_VUVIECID  AND TOAANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE AHS_KCKNQDK_PHUCTHAM_THULY
            SET TOAANID = p_TOAANNHANID
            WHERE VUANID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID;
            
            -- UPDATE AHS_PHUCTHAM_BANAN
            -- backup
            UPDATE AHS_PHUCTHAM_BANAN
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE VUANID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE AHS_PHUCTHAM_BANAN
            SET TOAANID = p_TOAANNHANID
            WHERE VUANID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID;

            -- UPDATE AHS_PHUCTHAM_QUYETDINH_BICAN
            -- backup
            UPDATE AHS_PHUCTHAM_QUYETDINH_BICAN
            SET TOA_GIAIQUYET_ID = DONVIID
            WHERE VUANID = p_VUVIECID  AND DONVIID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE AHS_PHUCTHAM_QUYETDINH_BICAN
            SET DONVIID = p_TOAANNHANID
            WHERE VUANID = p_VUVIECID AND DONVIID = v_TOAPHUCTHAMID;

            -- UPDATE AHS_PHUCTHAM_QUYETDINH_VUAN
            -- backup
            UPDATE AHS_PHUCTHAM_QUYETDINH_VUAN
            SET TOA_GIAIQUYET_ID = DONVIID
            WHERE VUANID = p_VUVIECID  AND DONVIID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE AHS_PHUCTHAM_QUYETDINH_VUAN
            SET DONVIID = p_TOAANNHANID
            WHERE VUANID = p_VUVIECID AND DONVIID = v_TOAPHUCTHAMID;

            -- Update AHS_TONGDAT
            -- backup
            UPDATE AHS_TONGDAT
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE VUANID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE AHS_TONGDAT
            SET TOAANID = p_TOAANNHANID
            WHERE VUANID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID;

            -- Update DON_KHAC
            -- backup
            UPDATE DON_KHAC
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND LOAIANID = 1 AND TOAANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE DON_KHAC
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND LOAIANID = 1 AND TOAANID = v_TOAPHUCTHAMID;

            -- Update HOSO_PT
            -- backup
            UPDATE HOSO_PT
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE VUANID = p_VUVIECID AND LOAIAN = 1 AND TOAANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE HOSO_PT
            SET TOAANID = p_TOAANNHANID
            WHERE VUANID = p_VUVIECID AND LOAIAN = 1 AND TOAANID = v_TOAPHUCTHAMID;

            -- Update HOSO_PT
            -- backup
            UPDATE HOSO_PT
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE VUANID = p_VUVIECID AND LOAIAN = 1 AND TOAANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE HOSO_PT
            SET TOAANID = p_TOAANNHANID
            WHERE VUANID = p_VUVIECID AND LOAIAN = 1 AND TOAANID = v_TOAPHUCTHAMID;
            
            IF (v_MAGIAIDOAN = 7) THEN
              -- Update AHS_CHUYEN_NHAN_AN
              -- Theo TOACHUYENID 
              -- backup
	           	UPDATE AHS_CHUYEN_NHAN_AN 
	            SET TOA_GIAIQUYET_ID = TOACHUYENID
	            WHERE MAP_VUANID_NEW = p_VUVIECID AND TOACHUYENID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

              UPDATE AHS_CHUYEN_NHAN_AN 
	            SET TOACHUYENID = p_TOAANNHANID 
	            WHERE MAP_VUANID_NEW = p_VUVIECID AND TOACHUYENID = v_TOAPHUCTHAMID;
	            
              -- Theo TOANHANID 
              -- backup
	           	UPDATE AHS_CHUYEN_NHAN_AN 
	            SET TOA_GIAIQUYET_NHAN_ID = TOANHANID
	            WHERE MAP_VUANID_NEW = p_VUVIECID AND TOANHANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_NHAN_ID IS NULL;

	            UPDATE AHS_CHUYEN_NHAN_AN
	            SET TOANHANID = p_TOAANNHANID
	            WHERE MAP_VUANID_NEW = p_VUVIECID AND TOANHANID = v_TOAPHUCTHAMID;
           ELSE
	            -- Update AHS_CHUYEN_NHAN_AN
              -- Theo TOACHUYENID 
              -- backup
	           	UPDATE AHS_CHUYEN_NHAN_AN 
	            SET TOA_GIAIQUYET_ID = TOACHUYENID
	            WHERE VUANID = p_VUVIECID AND TOACHUYENID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

              UPDATE AHS_CHUYEN_NHAN_AN 
	            SET TOACHUYENID = p_TOAANNHANID 
	            WHERE VUANID = p_VUVIECID AND TOACHUYENID = v_TOAPHUCTHAMID;
	            
              -- Theo TOANHANID 
              -- backup
	           	UPDATE AHS_CHUYEN_NHAN_AN 
	            SET TOA_GIAIQUYET_NHAN_ID = TOANHANID
	            WHERE VUANID = p_VUVIECID AND TOANHANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_NHAN_ID IS NULL;

	            UPDATE AHS_CHUYEN_NHAN_AN
	            SET TOANHANID = p_TOAANNHANID
	            WHERE VUANID = p_VUVIECID AND TOANHANID = v_TOAPHUCTHAMID;
           END IF;
            
        END IF;
        
        -- THI HÀNH ÁN
        -- nếu vụ án đã kết thúc thì bàn giao đồng thời dữ liệu trong phần thi hành án mục "thuộc hệ thống quản lý án" đi kèm.
        IF v_TRANGTHAIGIAIQUYET = '7' THEN
          BEGIN
            -- Lấy thông tin THA
            SELECT ID
            INTO v_THAVUANID
            FROM THA_VUAN tv
            WHERE TV.ISHETHONG = 1 AND TV.IDVUANHETHONG = P_VUVIECID;
  
            IF v_THAVUANID IS NOT NULL THEN
              -- Nếu tồn tại THA thì bàn giao luôn
  
              -- Update THA_VUAN
              -- backup
              UPDATE THA_VUAN
              SET TOA_GIAIQUYET_ID = p_TOAANNHANID
              WHERE ID = v_THAVUANID AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;
      
              UPDATE THA_VUAN
              SET TOAANID = p_TOAANNHANID
              WHERE ID = v_THAVUANID AND TOAANID = v_TOAANID;
  
              -- Update THA_ANTICH_DON
              -- backup
              UPDATE THA_ANTICH_DON
              SET TOA_GIAIQUYET_ID = p_TOAANNHANID
              WHERE VUANID = v_THAVUANID AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;
      
              UPDATE THA_ANTICH_DON
              SET TOAANID = p_TOAANNHANID
              WHERE VUANID = v_THAVUANID AND TOAANID = v_TOAANID;
  
              -- Update THA_ANTICH_FILE
              -- backup
  --            UPDATE THA_ANTICH_FILE
  --            SET TOA_GIAIQUYET_ID = p_TOAANNHANID
  --            WHERE VUANID = v_THAVUANID AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;
      
              -- Update THA_BIAN
              -- backup
              UPDATE THA_BIAN
              SET TOA_GIAIQUYET_ID = p_TOAANNHANID
              WHERE VUANID = v_THAVUANID AND TOA_GIAIQUYET_ID IS NULL;
  
              -- Update THA_BIAN_QUYETDINH
              -- backup
              UPDATE THA_BIAN_QUYETDINH
              SET TOA_GIAIQUYET_ID = p_TOAANNHANID
              WHERE VUANID = v_THAVUANID AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;
      
              UPDATE THA_BIAN_QUYETDINH
              SET TOAANID = p_TOAANNHANID
              WHERE VUANID = v_THAVUANID AND TOAANID = v_TOAANID;
  
              -- Update THA_BIAN_QUYETDINH_BS
              -- backup
  --            UPDATE THA_BIAN_QUYETDINH_BS
  --            SET TOA_GIAIQUYET_ID = p_TOAANNHANID
  --            WHERE VUANID = v_THAVUANID AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;
  
              -- Update THA_CACQDKHAC
              -- backup
              UPDATE THA_CACQDKHAC
              SET TOA_GIAIQUYET_ID = p_TOAANNHANID
              WHERE VUANID = v_THAVUANID AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;
      
              UPDATE THA_CACQDKHAC
              SET TOAANID = p_TOAANNHANID
              WHERE VUANID = v_THAVUANID AND TOAANID = v_TOAANID;
  
              -- Update THA_CVDON_GIAMAN
              -- backup
              UPDATE THA_CVDON_GIAMAN
              SET TOA_GIAIQUYET_ID = p_TOAANNHANID
              WHERE VUANID = v_THAVUANID AND TOA_GIAIQUYET_ID IS NULL;
  
              -- Update THA_CVDON_KQGQ
              -- backup
              UPDATE THA_CVDON_KQGQ
              SET TOA_GIAIQUYET_ID = p_TOAANNHANID
              WHERE VUANID = v_THAVUANID AND TOA_GIAIQUYET_ID IS NULL;
  
              -- Update THA_CVDON_QD
              -- backup
              UPDATE THA_CVDON_QD
              SET TOA_GIAIQUYET_ID = p_TOAANNHANID
              WHERE VUANID = v_THAVUANID AND TOA_GIAIQUYET_ID IS NULL;
  
              -- Update THA_CVDON_THULY
              -- backup
              UPDATE THA_CVDON_THULY
              SET TOA_GIAIQUYET_ID = p_TOAANNHANID
              WHERE VUANID = v_THAVUANID AND TOA_GIAIQUYET_ID IS NULL;
  
              -- Update THA_DACXA
              -- backup
              UPDATE THA_DACXA
              SET TOA_GIAIQUYET_ID = p_TOAANNHANID
              WHERE VUANID = v_THAVUANID AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;
      
              UPDATE THA_DACXA
              SET TOAANID = p_TOAANNHANID
              WHERE VUANID = v_THAVUANID AND TOAANID = v_TOAANID;
  
              -- Update THA_SOTHAM_CAOTRANG_DIEULUAT
              -- backup
              UPDATE THA_SOTHAM_CAOTRANG_DIEULUAT
              SET TOA_GIAIQUYET_ID = p_TOAANNHANID
              WHERE VUANID = v_THAVUANID AND TOA_GIAIQUYET_ID IS NULL;
  
              -- Update THA_THULY
              -- backup
              UPDATE THA_THULY
              SET TOA_GIAIQUYET_ID = p_TOAANNHANID
              WHERE VUANID = v_THAVUANID AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;
      
              UPDATE THA_THULY
              SET TOAANID = p_TOAANNHANID
              WHERE VUANID = v_THAVUANID AND TOAANID = v_TOAANID;
  
              -- Update THA_UYTHAC_DETAIL
              -- backup
  --            UPDATE THA_UYTHAC_DETAIL
  --            SET TOA_GIAIQUYET_ID = p_TOAANNHANID
  --            WHERE VUANID = v_THAVUANID AND TOA_GIAIQUYET_ID IS NULL;
  
              -- Update THA_UYTHAC_QUYETDINH
              -- backup
              UPDATE THA_UYTHAC_QUYETDINH
              SET TOA_GIAIQUYET_ID = p_TOAANNHANID
              WHERE VUANID = v_THAVUANID AND TOAANUYTHACID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;
      
              UPDATE THA_UYTHAC_QUYETDINH
              SET TOAANUYTHACID = p_TOAANNHANID
              WHERE VUANID = v_THAVUANID AND TOAANUYTHACID = v_TOAANID;
              
            END IF;
  
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                -- Không tìm thấy THA_VUAN, bỏ qua và tiếp tục
                NULL; 
          END;
        END IF;

        -- Update TRANGTHAI cho VUAN_BANGIAO_MAPPING
        UPDATE VUAN_BANGIAO_MAPPING
        SET TRANGTHAI = 'TTBG_DANHAN',
            NGAYNHAN = p_NGAYNHAN
        WHERE ID = p_ID;
        
        COMMIT;
        
    EXCEPTION
      WHEN OTHERS THEN
          -- Rollback in case of any exception
          ROLLBACK;

          v_output := 'Finish procedure Due to Exception: Error:' || SQLCODE || ',' || SQLERRM;
          PKG_TRACELOG.SP_INSERT_LOG_ERROR(
              p_functionname => 'PKG_BAN_GIAO_AN.AHS_VUAN_BANGIAO_MAPPING_NHAN',
              p_description => v_output,
              p_notes => v_tracedata
          );

          -- Re-raise the exception
          RAISE;
    END AHS_VUAN_BANGIAO_MAPPING_NHAN;

    -- [AHS] KIỂM TRA THAY ĐỔI
     PROCEDURE AHS_VUAN_BANGIAO_MAPPING_KTTHAYDOI (
        p_ID IN NUMBER,
        p_result OUT NUMBER,
        p_message OUT VARCHAR2
    )
    AS
        v_VUVIECID NUMBER;
        v_TOAANNHANID NUMBER;
        v_NGANHAN DATE;
        v_TRANGTHAIGIAIQUYET VARCHAR2(20);

        v_THAVUANID NUMBER;
        v_count NUMBER;
    BEGIN
        -- Khởi tạo giá trị mặc định
        p_result := 0;
        p_message := '';

        -- Lấy thông tin Mapping
        SELECT VUVIECID, TOAANNHANID, NGAYNHAN, TRANGTHAIGIAIQUYET
        INTO  v_VUVIECID, v_TOAANNHANID, v_NGANHAN, v_TRANGTHAIGIAIQUYET
        FROM VUAN_BANGIAO_MAPPING
        WHERE ID = p_ID AND TRANGTHAI = 'TTBG_DANHAN';
        
        -- Kiểm tra các bảng có thay đổi sau ngày nhận án
        
        -- Kiểm tra AHS_BICANBICAO
        SELECT COUNT(*) INTO v_count 
        FROM AHS_BICANBICAO 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin bị can, bị cáo đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHS_BICAN_NHANTHAN
        SELECT COUNT(*) INTO v_count 
        FROM AHS_BICAN_NHANTHAN 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin nhân thân bị can đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHS_BIENPHAPNGANCHAN
        SELECT COUNT(*) INTO v_count 
        FROM AHS_BIENPHAPNGANCHAN 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin biện pháp ngăn chặn đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra AHS_CHUYEN_NHAN_AN
        SELECT COUNT(*) INTO v_count 
        FROM AHS_CHUYEN_NHAN_AN 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin chuyển nhận án đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHS_FILE
        --SELECT COUNT(*) INTO v_count 
        --FROM AHS_FILE 
        --WHERE VUANID = v_VUVIECID 
          --AND (NGAYTAO >= v_NGANHAN);
        
        --IF v_count > 0 THEN
            --p_result := 1;
          --  p_message := 'Thông tin đơn đã có thay đổi, không thể trả án.';
        --    RETURN;
        --END IF;

        -- Kiểm tra AHS_KCKNQDK_PHUCTHAM_BICANBICAO
        SELECT COUNT(*) INTO v_count 
        FROM AHS_KCKNQDK_PHUCTHAM_BICANBICAO 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin KCKNQDK phúc thẩm bị can, bị cáo đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra AHS_KCKNQDK_PHUCTHAM_HDXX
        SELECT COUNT(*) INTO v_count 
        FROM AHS_KCKNQDK_PHUCTHAM_HDXX 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin KCKNQDK phúc thẩm HĐXX đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHS_KCKNQDK_PHUCTHAM_QUYETDINH_BICAN
        SELECT COUNT(*) INTO v_count 
        FROM AHS_KCKNQDK_PHUCTHAM_QUYETDINH_BICAN 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin KCKNQDK phúc thẩm quyết định bị can đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN
        SELECT COUNT(*) INTO v_count 
        FROM AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin KCKNQDK phúc thẩm quyết định vụ án đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHS_KCKNQDK_PHUCTHAM_THULY
        SELECT COUNT(*) INTO v_count 
        FROM AHS_KCKNQDK_PHUCTHAM_THULY 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin KCKNQDK phúc thẩm thụ lý đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHS_KCKNQDK_PHUCTHAM_XULY_KCKNST
        SELECT COUNT(*) INTO v_count 
        FROM AHS_KCKNQDK_PHUCTHAM_XULY_KCKNST 
        WHERE (VUANPT_ID = v_VUVIECID OR VUANST_ID = v_VUVIECID) 
          AND NGAY_TAO >= v_NGANHAN;
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin KCKNQDK phúc thẩm xử lý KCKNST đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHS_NGUOITHAMGIATOTUNG
 --       SELECT COUNT(*) INTO v_count 
 --       FROM AHS_NGUOITHAMGIATOTUNG 
 --      WHERE VUANID = v_VUVIECID 
 --         AND NGAYSUA >= v_NGANHAN;
        
 --       IF v_count > 0 THEN
 --           p_result := 1;
 --           p_message := 'Thông tin người tham gia tố tụng đã có thay đổi, không thể trả án.';
 --           RETURN;
 --       END IF;

        -- Kiểm tra AHS_NGUOITHAMGIATOTUNG_TUCACH
--        SELECT COUNT(*) INTO v_count 
--        FROM AHS_NGUOITHAMGIATOTUNG_TUCACH 
--        WHERE VUANID = v_VUVIECID 
--          AND NGAYSUA >= v_NGANHAN;
--        
--        IF v_count > 0 THEN
--            p_result := 1;
--            p_message := 'Thông tin người tham gia tố tụng đã có thay đổi, không thể trả án.';
--            RETURN;
--        END IF;

        -- Kiểm tra AHS_NGUOI_DAIDIEN
--        SELECT COUNT(*) INTO v_count 
--        FROM AHS_NGUOI_DAIDIEN 
--        WHERE VUANID = v_VUVIECID 
--          AND (NGAYTAO >= v_NGANHAN);
--        
--        IF v_count > 0 THEN
--            p_result := 1;
--            p_message := 'Thông tin KCKNQDK phúc thẩm thụ lý đã có thay đổi, không thể trả án.';
--            RETURN;
--        END IF;

        -- Kiểm tra AHS_PHUCTHAM_BANAN
        SELECT COUNT(*) INTO v_count 
        FROM AHS_PHUCTHAM_BANAN 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin bản án phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHS_PHUCTHAM_BANAN
        SELECT COUNT(*) INTO v_count 
        FROM AHS_PHUCTHAM_BANAN 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin bản án phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHS_PHUCTHAM_BANAN_BICAO
--        SELECT COUNT(*) INTO v_count 
--        FROM AHS_PHUCTHAM_BANAN_BICAO 
--        WHERE VUANID = v_VUVIECID 
--          AND (NGAYTAO >= v_NGANHAN);
--        
--        IF v_count > 0 THEN
--            p_result := 1;
--            p_message := 'Thông tin bản án phúc thẩm đã có thay đổi, không thể trả án.';
--            RETURN;
--        END IF;

        -- Kiểm tra AHS_PHUCTHAM_BANAN_DIEU_CT
--        SELECT COUNT(*) INTO v_count 
--        FROM AHS_PHUCTHAM_BANAN_DIEU_CT 
--        WHERE VUANID = v_VUVIECID 
--          AND (NGAYTAO >= v_NGANHAN);
--        
--        IF v_count > 0 THEN
--            p_result := 1;
--            p_message := 'Thông tin bản án phúc thẩm đã có thay đổi, không thể trả án.';
--            RETURN;
--        END IF;

        -- Kiểm tra AHS_PHUCTHAM_BANAN_FILE
--        SELECT COUNT(*) INTO v_count 
--        FROM AHS_PHUCTHAM_BANAN_FILE 
--        WHERE VUANID = v_VUVIECID 
--          AND (NGAYTAO >= v_NGANHAN);
--        
--        IF v_count > 0 THEN
--            p_result := 1;
--            p_message := 'Thông tin bản án phúc thẩm đã có thay đổi, không thể trả án.';
--            RETURN;
--        END IF;
        
        -- Kiểm tra AHS_PHUCTHAM_BICANBICAO
        SELECT COUNT(*) INTO v_count 
        FROM AHS_PHUCTHAM_BICANBICAO 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin bị can, bị cáo phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHS_PHUCTHAM_HDXX
        SELECT COUNT(*) INTO v_count 
        FROM AHS_PHUCTHAM_HDXX 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin HĐXX phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHS_PHUCTHAM_QUYETDINH_BICAN
        SELECT COUNT(*) INTO v_count 
        FROM AHS_PHUCTHAM_QUYETDINH_BICAN 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin quyết định bị can phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHS_PHUCTHAM_QUYETDINH_VUAN
        SELECT COUNT(*) INTO v_count 
        FROM AHS_PHUCTHAM_QUYETDINH_VUAN 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin quyết định vụ án phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHS_PHUCTHAM_THULY
        SELECT COUNT(*) INTO v_count 
        FROM AHS_PHUCTHAM_THULY 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin thụ lý phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

--        -- Kiểm tra AHS_SAUXETXU
--        SELECT COUNT(*) INTO v_count 
--        FROM AHS_SAUXETXU 
--        WHERE VUANID = v_VUVIECID 
--          AND (NGAYTAO >= v_NGANHAN);
--        
--        IF v_count > 0 THEN
--            p_result := 1;
--            p_message := 'Thông tin sau xét xử đã có thay đổi, không thể trả án.';
--            RETURN;
--        END IF;

        -- Kiểm tra AHS_SOTHAM_BANAN
        SELECT COUNT(*) INTO v_count 
        FROM AHS_SOTHAM_BANAN 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin bản án sơ thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHS_SOTHAM_BANAN_BICAO
--        SELECT COUNT(*) INTO v_count 
--        FROM AHS_SOTHAM_BANAN_BICAO 
--        WHERE VUANID = v_VUVIECID 
--          AND (NGAYTAO >= v_NGANHAN);
--        
--        IF v_count > 0 THEN
--            p_result := 1;
--            p_message := 'Thông tin bản án sơ thẩm đã có thay đổi, không thể trả án.';
--            RETURN;
--        END IF;

--        -- Kiểm tra AHS_SOTHAM_BANAN_DIEU_CHITIET
--        SELECT COUNT(*) INTO v_count 
--        FROM AHS_SOTHAM_BANAN_DIEU_CHITIET 
--        WHERE VUANID = v_VUVIECID 
--          AND (NGAYTAO >= v_NGANHAN);
--        
--        IF v_count > 0 THEN
--            p_result := 1;
--            p_message := 'Thông tin bản án sơ thẩm đã có thay đổi, không thể trả án.';
--            RETURN;
--        END IF;

--        -- Kiểm tra AHS_SOTHAM_BANAN_DIEU_TONGHOP
--        SELECT COUNT(*) INTO v_count 
--        FROM AHS_SOTHAM_BANAN_DIEU_TONGHOP 
--        WHERE VUANID = v_VUVIECID 
--          AND (NGAYTAO >= v_NGANHAN);
--        
--        IF v_count > 0 THEN
--            p_result := 1;
--            p_message := 'Thông tin bản án sơ thẩm đã có thay đổi, không thể trả án.';
--            RETURN;
--        END IF;

        -- Kiểm tra AHS_SOTHAM_BIENPHAPNGANCHAN
        SELECT COUNT(*) INTO v_count 
        FROM AHS_SOTHAM_BIENPHAPNGANCHAN 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin biện pháp ngăn chặn sơ thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHS_SOTHAM_CAOTRANG_DIEULUAT
        SELECT COUNT(*) INTO v_count 
        FROM AHS_SOTHAM_CAOTRANG_DIEULUAT 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin điều luật cáo trạng sơ thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHS_SOTHAM_HDXX
        SELECT COUNT(*) INTO v_count 
        FROM AHS_SOTHAM_HDXX 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin HĐXX sơ thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHS_SOTHAM_KHANGCAO
        SELECT COUNT(*) INTO v_count 
        FROM AHS_SOTHAM_KHANGCAO 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin kháng cáo sơ thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHS_SOTHAM_KHANGCAO_YEUCAU
--        SELECT COUNT(*) INTO v_count 
--        FROM AHS_SOTHAM_KHANGCAO_YEUCAU 
--        WHERE VUANID = v_VUVIECID 
--          AND (NGAYTAO >= v_NGANHAN);
--        
--        IF v_count > 0 THEN
--            p_result := 1;
--            p_message := 'Thông tin kháng cáo sơ thẩm đã có thay đổi, không thể trả án.';
--            RETURN;
--        END IF;

        -- Kiểm tra AHS_SOTHAM_KHANGNGHI
        SELECT COUNT(*) INTO v_count 
        FROM AHS_SOTHAM_KHANGNGHI 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin kháng nghị sơ thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHS_SOTHAM_KHANGNGHI_YEUCAU
--        SELECT COUNT(*) INTO v_count 
--        FROM AHS_SOTHAM_KHANGNGHI_YEUCAU 
--        WHERE VUANID = v_VUVIECID 
--          AND (NGAYTAO >= v_NGANHAN);
--        
--        IF v_count > 0 THEN
--            p_result := 1;
--            p_message := 'Thông tin kháng nghị sơ thẩm đã có thay đổi, không thể trả án.';
--            RETURN;
--        END IF;

        -- Kiểm tra AHS_SOTHAM_QUYETDINH_BICAN
        SELECT COUNT(*) INTO v_count 
        FROM AHS_SOTHAM_QUYETDINH_BICAN 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin quyết định bị can sơ thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHS_SOTHAM_QUYETDINH_VUAN
        SELECT COUNT(*) INTO v_count 
        FROM AHS_SOTHAM_QUYETDINH_VUAN 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin quyết định vụ án sơ thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHS_SOTHAM_RUTKHANGCAO
--        SELECT COUNT(*) INTO v_count 
--        FROM AHS_SOTHAM_RUTKHANGCAO 
--        WHERE VUANID = v_VUVIECID 
--          AND (NGAYTAO >= v_NGANHAN);
--        
--        IF v_count > 0 THEN
--            p_result := 1;
--            p_message := 'Thông tin quyết định vụ án sơ thẩm đã có thay đổi, không thể trả án.';
--            RETURN;
--        END IF;

--        -- Kiểm tra AHS_SOTHAM_RUTKHANGNGHI
--        SELECT COUNT(*) INTO v_count 
--        FROM AHS_SOTHAM_RUTKHANGNGHI 
--        WHERE VUANID = v_VUVIECID 
--          AND (NGAYTAO >= v_NGANHAN);
--        
--        IF v_count > 0 THEN
--            p_result := 1;
--            p_message := 'Thông tin quyết định vụ án sơ thẩm đã có thay đổi, không thể trả án.';
--            RETURN;
--        END IF;

        -- Kiểm tra AHS_SOTHAM_THULY
        SELECT COUNT(*) INTO v_count 
        FROM AHS_SOTHAM_THULY 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin thụ lý sơ thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHS_THAMPHANGIAIQUYET
        SELECT COUNT(*) INTO v_count 
        FROM AHS_THAMPHANGIAIQUYET 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin thẩm phán giải quyết đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHS_TONGDAT
        SELECT COUNT(*) INTO v_count 
        FROM AHS_TONGDAT 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin tống đạt đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHS_TONGDAT_DOITUONG
--        SELECT COUNT(*) INTO v_count 
--        FROM AHS_TONGDAT_DOITUONG 
--        WHERE VUANID = v_VUVIECID 
--          AND (NGAYTAO >= v_NGANHAN);
--        
--        IF v_count > 0 THEN
--            p_result := 1;
--            p_message := 'Thông tin tống đạt đã có thay đổi, không thể trả án.';
--            RETURN;
--        END IF;

         -- Kiểm tra AHS_TONGHOPHINHPHAT
--        SELECT COUNT(*) INTO v_count 
--        FROM AHS_TONGHOPHINHPHAT 
--        WHERE VUANID = v_VUVIECID 
--          AND (NGAYTAO >= v_NGANHAN);
--        
--        IF v_count > 0 THEN
--            p_result := 1;
--            p_message := 'Thông tin tổng hợp hình phạt đã có thay đổi, không thể trả án.';
--            RETURN;
--        END IF;

        -- Kiểm tra AHS_TRUNGCAU_GIAMDINH
        SELECT COUNT(*) INTO v_count 
        FROM AHS_TRUNGCAU_GIAMDINH 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin trưng cầu giám định đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHS_VUAN_GIAIDOAN
        SELECT COUNT(*) INTO v_count 
        FROM AHS_VUAN_GIAIDOAN 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin giai đoạn vụ án đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

         -- Kiểm tra AHS_XULY_VIPHAMHC
        SELECT COUNT(*) INTO v_count 
        FROM AHS_XULY_VIPHAMHC 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin xử lý vi phạm HC đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
                
        -- Kiểm tra DON_KHAC
        SELECT COUNT(*) INTO v_count 
        FROM DON_KHAC 
        WHERE DONID = v_VUVIECID 
          AND (NGAYNHANDON >= v_NGANHAN OR NGAYKHANGCAO >= v_NGANHAN) 
          AND LOAIANID = 1;
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin đơn đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra DON_KHAC_YEUCAU
        SELECT COUNT(*) INTO v_count 
        FROM DON_KHAC_YEUCAU y
        WHERE EXISTS (
            SELECT 1 FROM DON_KHAC d 
            WHERE d.DONID = v_VUVIECID 
              AND d.ID = y.DONKHACID
        ) AND (y.NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin đơn đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra DON_CHITIET
        SELECT COUNT(*) INTO v_count 
        FROM DON_CHITIET 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN) 
          AND LOAIANID = 1;
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin đơn đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra DON_DUONGSU_CHITIET
        SELECT COUNT(*) INTO v_count 
        FROM DON_DUONGSU_CHITIET 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN)
          AND LOAIAN = 1;
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin đương sự đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra HOSO_PT
        SELECT COUNT(*) INTO v_count 
        FROM HOSO_PT 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN)
          AND LOAIAN = 1;
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin hồ sơ phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- THI HÀNH ÁN

        -- Nếu án đã kết thúc thì kiểm tra cả THA
        IF v_TRANGTHAIGIAIQUYET = '7' THEN
          BEGIN
            -- Lấy thông tin THA
            SELECT ID
            INTO v_THAVUANID
            FROM THA_VUAN tv
            WHERE TV.ISHETHONG = 1 AND TV.IDVUANHETHONG = v_VUVIECID;
  
            -- Nếu có THA thì kiểm tra thay đổi
            IF v_THAVUANID IS NOT NULL THEN
  
              -- Kiểm tra THA_ANTICH_DON
  --            SELECT COUNT(*) INTO v_count 
  --            FROM THA_ANTICH_DON 
  --            WHERE VUANID = v_THAVUANID 
  --              AND (NGAYTAO >= v_NGANHAN);
  --            
  --            IF v_count > 0 THEN
  --                p_result := 1;
  --                p_message := 'Thông tin án tích đơn THA đã có thay đổi, không thể trả án.';
  --                RETURN;
  --            END IF;
  
              -- Kiểm tra THA_BIAN
  --            SELECT COUNT(*) INTO v_count 
  --            FROM THA_BIAN 
  --            WHERE VUANID = v_THAVUANID 
  --              AND (NGAYTAO >= v_NGANHAN);
  --            
  --            IF v_count > 0 THEN
  --                p_result := 1;
  --                p_message := 'Thông tin bị án THA đã có thay đổi, không thể trả án.';
  --                RETURN;
  --            END IF;
  
              -- Kiểm tra THA_BIAN_QUYETDINH
              SELECT COUNT(*) INTO v_count 
              FROM THA_BIAN_QUYETDINH 
              WHERE VUANID = v_THAVUANID 
                AND (NGAYTAO >= v_NGANHAN);
              
              IF v_count > 0 THEN
                  p_result := 1;
                  p_message := 'Thông tin quyết định bị án THA đã có thay đổi, không thể trả án.';
                  RETURN;
              END IF;
  
              -- Kiểm tra THA_BIAN_QUYETDINH_BS
  --            SELECT COUNT(*) INTO v_count 
  --            FROM THA_BIAN_QUYETDINH_BS 
  --            WHERE VUANID = v_THAVUANID 
  --              AND (NGAYTAO >= v_NGANHAN);
  --            
  --            IF v_count > 0 THEN
  --                p_result := 1;
  --                p_message := 'Thông tin quyết định bị án THA đã có thay đổi, không thể trả án.';
  --                RETURN;
  --            END IF;
  
              -- Kiểm tra THA_CACQDKHAC
              SELECT COUNT(*) INTO v_count 
              FROM THA_CACQDKHAC 
              WHERE VUANID = v_THAVUANID 
                AND (NGAYTAO >= v_NGANHAN);
              
              IF v_count > 0 THEN
                  p_result := 1;
                  p_message := 'Thông tin các quyết định khác THA đã có thay đổi, không thể trả án.';
                  RETURN;
              END IF;
  
              -- Kiểm tra THA_CVDON_GIAMAN
              SELECT COUNT(*) INTO v_count 
              FROM THA_CVDON_GIAMAN 
              WHERE VUANID = v_THAVUANID 
                AND (NGAYTAO >= v_NGANHAN);
              
              IF v_count > 0 THEN
                  p_result := 1;
                  p_message := 'Thông tin giảm án THA đã có thay đổi, không thể trả án.';
                  RETURN;
              END IF;
  
              -- Kiểm tra THA_CVDON_KQGQ
              SELECT COUNT(*) INTO v_count 
              FROM THA_CVDON_KQGQ 
              WHERE VUANID = v_THAVUANID 
                AND (NGAYTAO >= v_NGANHAN);
              
              IF v_count > 0 THEN
                  p_result := 1;
                  p_message := 'Thông tin KQGQ THA đã có thay đổi, không thể trả án.';
                  RETURN;
              END IF;
  
              -- Kiểm tra THA_CVDON_QD
              SELECT COUNT(*) INTO v_count 
              FROM THA_CVDON_QD 
              WHERE VUANID = v_THAVUANID 
                AND (NGAYTAO >= v_NGANHAN);
              
              IF v_count > 0 THEN
                  p_result := 1;
                  p_message := 'Thông tin quyết định THA đã có thay đổi, không thể trả án.';
                  RETURN;
              END IF;
  
              -- Kiểm tra THA_CVDON_THULY
              SELECT COUNT(*) INTO v_count 
              FROM THA_CVDON_THULY 
              WHERE VUANID = v_THAVUANID 
                AND (NGAYTAO >= v_NGANHAN);
              
              IF v_count > 0 THEN
                  p_result := 1;
                  p_message := 'Thông tin thụ lý THA đã có thay đổi, không thể trả án.';
                  RETURN;
              END IF;
  
              -- Kiểm tra THA_DACXA
              SELECT COUNT(*) INTO v_count 
              FROM THA_DACXA 
              WHERE VUANID = v_THAVUANID 
                AND (NGAYTAO >= v_NGANHAN);
              
              IF v_count > 0 THEN
                  p_result := 1;
                  p_message := 'Thông tin đặc xá THA đã có thay đổi, không thể trả án.';
                  RETURN;
              END IF;
  
              -- Kiểm tra THA_SOTHAM_CAOTRANG_DIEULUAT
--              SELECT COUNT(*) INTO v_count 
--              FROM THA_SOTHAM_CAOTRANG_DIEULUAT 
--              WHERE VUANID = v_THAVUANID 
--                AND (NGAYTAO >= v_NGANHAN);
--              
--              IF v_count > 0 THEN
--                  p_result := 1;
--                  p_message := 'Thông tin điều luật cáo trạng THA đã có thay đổi, không thể trả án.';
--                  RETURN;
--              END IF;
  
              -- Kiểm tra THA_THULY
              SELECT COUNT(*) INTO v_count 
              FROM THA_THULY 
              WHERE VUANID = v_THAVUANID 
                AND (NGAYTAO >= v_NGANHAN);
              
              IF v_count > 0 THEN
                  p_result := 1;
                  p_message := 'Thông tin thụ lý THA đã có thay đổi, không thể trả án.';
                  RETURN;
              END IF;
  
              -- Kiểm tra THA_UYTHAC_DETAIL
  --            SELECT COUNT(*) INTO v_count 
  --            FROM THA_UYTHAC_DETAIL 
  --            WHERE VUANID = v_THAVUANID 
  --              AND (NGAYTAO >= v_NGANHAN);
  --            
  --            IF v_count > 0 THEN
  --                p_result := 1;
  --                p_message := 'Thông tin thụ lý THA đã có thay đổi, không thể trả án.';
  --                RETURN;
  --            END IF;
  
              -- Kiểm tra THA_UYTHAC_QUYETDINH
              SELECT COUNT(*) INTO v_count 
              FROM THA_UYTHAC_QUYETDINH 
              WHERE VUANID = v_THAVUANID 
                AND (NGAYTAO >= v_NGANHAN);
              
              IF v_count > 0 THEN
                  p_result := 1;
                  p_message := 'Thông tin QĐ uỷ thác THA đã có thay đổi, không thể trả án.';
                  RETURN;
              END IF;
  
            END IF;
          
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                -- Không tìm thấy THA_VUAN, bỏ qua và tiếp tục
                NULL; 
          END;
        END IF;


        
      EXCEPTION
          WHEN OTHERS THEN
              p_result := 1;
              p_message := 'Lỗi khi kiểm tra: ' || SQLERRM;
  END AHS_VUAN_BANGIAO_MAPPING_KTTHAYDOI;

    -- [AHS] TRẢ LẠI
    PROCEDURE AHS_VUAN_BANGIAO_MAPPING_TRALAI (
        p_ID IN NUMBER
    ) AS
        v_VUVIECID NUMBER;
        v_MAGIAIDOAN NUMBER;
        v_TOAANGIAOID NUMBER;
        v_TOAANNHANID NUMBER;
        v_TRANGTHAIGIAIQUYET VARCHAR2(20);

        v_THAVUANID NUMBER;

        v_tracedata VARCHAR2(1024);
        v_output VARCHAR2(512);
    BEGIN
        v_tracedata := '(' || 
         'p_ID => ' || p_ID || ',' ||
         ' );';

        -- Lấy thông tin Mapping
        SELECT VUVIECID, TOAANGIAOID, TOAANNHANID, MAGIAIDOAN, TRANGTHAIGIAIQUYET
        INTO  v_VUVIECID, v_TOAANGIAOID, v_TOAANNHANID, v_MAGIAIDOAN, v_TRANGTHAIGIAIQUYET
        FROM VUAN_BANGIAO_MAPPING
        WHERE ID = p_ID AND TRANGTHAI = 'TTBG_DANHAN';

        -- Xoá thông tin AN_DA_KET_THUC cho giai đoạn
        UPDATE AHS_VUAN_GIAIDOAN
        SET AN_DA_KET_THUC = NULL
        WHERE VUANID = v_VUVIECID AND MAGIAIDOAN = v_MAGIAIDOAN AND (TOA_GIAIQUYET_ID = v_TOAANGIAOID OR TOA_PHUCTHAM_GIAIQUYET_ID = v_TOAANGIAOID);

        -- Xử lý cập nhật theo giai đoạn
        IF v_MAGIAIDOAN = 2 THEN
            -- SƠ THẨM
            -- Update AHS_VUAN
            UPDATE AHS_VUAN
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE ID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
            
            -- Update AHS_DON_GIAIDOAN
            UPDATE AHS_VUAN_GIAIDOAN
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE VUANID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update DON_CHITIET
            UPDATE DON_CHITIET
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND LOAIANID = 1 AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update AHS_TONGDAT
            UPDATE AHS_TONGDAT
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE VUANID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

          -- Update DON_KHAC
            UPDATE DON_KHAC
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND LOAIANID = 1 AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update AHS_SOTHAM_BANAN
            UPDATE AHS_SOTHAM_BANAN
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE VUANID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update AHS_SOTHAM_QUYETDINH_BICAN
            UPDATE AHS_SOTHAM_QUYETDINH_BICAN
            SET DONVIID = TOA_GIAIQUYET_ID
            WHERE VUANID = v_VUVIECID AND DONVIID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update AHS_SOTHAM_QUYETDINH_VUAN
            UPDATE AHS_SOTHAM_QUYETDINH_VUAN
            SET DONVIID = TOA_GIAIQUYET_ID
            WHERE VUANID = v_VUVIECID AND DONVIID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update AHS_CHUYEN_NHAN_AN
            -- Theo TOACHUYENID 
            UPDATE AHS_CHUYEN_NHAN_AN 
            SET TOACHUYENID = TOA_GIAIQUYET_ID 
            WHERE VUANID = v_VUVIECID AND TOACHUYENID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
            
            -- Theo TOANHANID
            UPDATE AHS_CHUYEN_NHAN_AN
            SET TOANHANID = TOA_GIAIQUYET_NHAN_ID
            WHERE VUANID = v_VUVIECID AND TOANHANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Với trường hợp chuyển ST -> ST, sau khi chuyển án tạm đình chỉ
          	UPDATE AHS_CHUYEN_NHAN_AN
            SET TOANHANID = TOA_GIAIQUYET_NHAN_ID
			      WHERE VUANID in (SELECT CNA.MAP_VUANID_NEW
				                     FROM AHS_CHUYEN_NHAN_AN CNA
                             WHERE CNA.VUANID = v_VUVIECID AND CNA.MAP_VUANID_NEW IS NOT NULL);

            -- Với trường hợp chuyển ST -> ST, sau khi chuyển án không đủ thẩm quyền xét xử
            UPDATE AHS_CHUYEN_NHAN_AN
      			SET
      				TOANHANID = TOA_GIAIQUYET_NHAN_ID
      			WHERE
      				MAP_VUANID_NEW = v_VUVIECID AND MAP_VUANID_NEW IS NOT NULL;
            
        ELSIF v_MAGIAIDOAN IN(3,7) THEN
            -- PHÚC THẨM

            -- Update AHS_VUAN
            UPDATE AHS_VUAN
            SET TOAPHUCTHAMID = TOA_PHUCTHAM_GIAIQUYET_ID
            WHERE ID = v_VUVIECID AND TOAPHUCTHAMID = v_TOAANNHANID AND TOA_PHUCTHAM_GIAIQUYET_ID = v_TOAANGIAOID;

            -- backup
            UPDATE AHS_VUAN
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE ID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
            
            -- Update AHS_PHUCTHAM_THULY
            UPDATE AHS_PHUCTHAM_THULY
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE VUANID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
            
            -- Update TOAID AHS_DON_GIAIDOAN
            UPDATE AHS_VUAN_GIAIDOAN
            SET TOAPHUCTHAMID = TOA_PHUCTHAM_GIAIQUYET_ID
            WHERE VUANID = v_VUVIECID AND TOAPHUCTHAMID = v_TOAANNHANID AND TOA_PHUCTHAM_GIAIQUYET_ID = v_TOAANGIAOID;

            -- backup
            UPDATE AHS_VUAN_GIAIDOAN
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE VUANID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
            
            -- UPDATE AHS_KCKNQDK_PHUCTHAM_QUYETDINH_BICAN
            UPDATE AHS_KCKNQDK_PHUCTHAM_QUYETDINH_BICAN
            SET DONVIID = TOA_GIAIQUYET_ID
            WHERE VUANID = v_VUVIECID AND DONVIID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- UPDATE AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN
            UPDATE AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN
            SET DONVIID = TOA_GIAIQUYET_ID
            WHERE VUANID = v_VUVIECID AND DONVIID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- UPDATE AHS_KCKNQDK_PHUCTHAM_THULY
            UPDATE AHS_KCKNQDK_PHUCTHAM_THULY
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE VUANID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
            
            -- UPDATE AHS_PHUCTHAM_BANAN
            UPDATE AHS_PHUCTHAM_BANAN
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE VUANID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- UPDATE AHS_PHUCTHAM_QUYETDINH_BICAN
            UPDATE AHS_PHUCTHAM_QUYETDINH_BICAN
            SET DONVIID = TOA_GIAIQUYET_ID
            WHERE VUANID = v_VUVIECID AND DONVIID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- UPDATE AHS_PHUCTHAM_QUYETDINH_VUAN
            UPDATE AHS_PHUCTHAM_QUYETDINH_VUAN
            SET DONVIID = TOA_GIAIQUYET_ID
            WHERE VUANID = v_VUVIECID AND DONVIID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update AHS_TONGDAT
            UPDATE AHS_TONGDAT
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE VUANID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update DON_CHITIET
            UPDATE DON_CHITIET
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND LOAIANID = 1 AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update DON_KHAC
            UPDATE DON_KHAC
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND LOAIANID = 1 AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;


            -- Update HOSO_PT
            UPDATE HOSO_PT
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE VUANID = v_VUVIECID AND LOAIAN = 1 AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
            
            IF (v_MAGIAIDOAN = 7) THEN
              -- Update AHS_CHUYEN_NHAN_AN
              -- Theo TOACHUYENID 
              UPDATE AHS_CHUYEN_NHAN_AN 
	            SET TOACHUYENID = TOA_GIAIQUYET_ID 
	            WHERE MAP_VUANID_NEW = v_VUVIECID AND TOACHUYENID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
	            
              -- Theo TOANHANID 
	            UPDATE AHS_CHUYEN_NHAN_AN
	            SET TOANHANID = TOA_GIAIQUYET_NHAN_ID
	            WHERE MAP_VUANID_NEW = v_VUVIECID AND TOANHANID = v_TOAANNHANID AND TOA_GIAIQUYET_NHAN_ID = v_TOAANGIAOID;
           ELSE
	            -- Update AHS_CHUYEN_NHAN_AN
              -- Theo TOACHUYENID 
              UPDATE AHS_CHUYEN_NHAN_AN 
	            SET TOACHUYENID = TOA_GIAIQUYET_ID 
	            WHERE VUANID = v_VUVIECID AND TOACHUYENID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
	            
              -- Theo TOANHANID 
	            UPDATE AHS_CHUYEN_NHAN_AN
	            SET TOANHANID = TOA_GIAIQUYET_NHAN_ID
	            WHERE VUANID = v_VUVIECID AND TOANHANID = v_TOAANNHANID AND TOA_GIAIQUYET_NHAN_ID = v_TOAANGIAOID;
           END IF;
            
        END IF;
        

        -- THI HÀNH ÁN
        -- Kiểm tra điều kiện trả lại án đã kết thúc: Nếu trong Phân hệ thi hành án Mục “Thuộc hệ thống quản lý án” của án đó tại tòa mới đã phát sinh dữ liệu, hệ thống không cho phép trả lại án.
        IF v_TRANGTHAIGIAIQUYET = '7' THEN
          BEGIN
            -- Lấy thông tin THA
            SELECT ID
            INTO v_THAVUANID
            FROM THA_VUAN tv
            WHERE TV.ISHETHONG = 1 AND TV.IDVUANHETHONG = v_VUVIECID;
  
            -- Nếu có thi hành án thì thực hiện trả lại thông tin
            IF v_THAVUANID IS NOT NULL THEN
              -- Update THA_VUAN
              UPDATE THA_VUAN
              SET TOAANID = TOA_GIAIQUYET_ID
              WHERE ID = v_THAVUANID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
    
              -- Update THA_ANTICH_DON
              UPDATE THA_ANTICH_DON
              SET TOAANID = TOA_GIAIQUYET_ID
              WHERE VUANID = v_THAVUANID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
    
              -- Update THA_BIAN_QUYETDINH
              UPDATE THA_BIAN_QUYETDINH
              SET TOAANID = TOA_GIAIQUYET_ID
              WHERE VUANID = v_THAVUANID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
    
              -- Update THA_CACQDKHAC
              UPDATE THA_CACQDKHAC
              SET TOAANID = TOA_GIAIQUYET_ID
              WHERE VUANID = v_THAVUANID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
  
              -- Update THA_DACXA
              UPDATE THA_DACXA
              SET TOAANID = TOA_GIAIQUYET_ID
              WHERE VUANID = v_THAVUANID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
  
              -- Update THA_THULY
              UPDATE THA_THULY
              SET TOAANID = TOA_GIAIQUYET_ID
              WHERE VUANID = v_THAVUANID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
  
              -- Update THA_UYTHAC_QUYETDINH
              UPDATE THA_UYTHAC_QUYETDINH
              SET TOAANUYTHACID = TOA_GIAIQUYET_ID
              WHERE VUANID = v_THAVUANID AND TOAANUYTHACID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
              
            END IF;
          
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                -- Không tìm thấy THA_VUAN, bỏ qua và tiếp tục
                NULL; 
          END;
        END IF;


        -- Update TRANGTHAI cho VUAN_BANGIAO_MAPPING
        update VUAN_BANGIAO_MAPPING 
        SET TRANGTHAI = 'TTBG_CHONHAN'
        WHERE ID = p_ID;
        
        COMMIT;
        
    EXCEPTION
      WHEN OTHERS THEN
          -- Rollback in case of any exception
          ROLLBACK;

          v_output := 'Finish procedure Due to Exception: Error:' || SQLCODE || ',' || SQLERRM;
          PKG_TRACELOG.SP_INSERT_LOG_ERROR(
              p_functionname => 'PKG_BAN_GIAO_AN.AHS_VUAN_BANGIAO_MAPPING_TRALAI',
              p_description => v_output,
              p_notes => v_tracedata
          );

          -- Re-raise the exception
          RAISE;
    END AHS_VUAN_BANGIAO_MAPPING_TRALAI;



    -- [AHN] LẤY DANH SÁCH CÓ THỂ BÀN GIAO
    PROCEDURE AHN_VUAN_BANGIAO_MAPPING_GET_AN_BAN_GIAO (
        p_LOAIANID IN varchar2,
        p_TOAANID IN NUMBER,
        p_MAVUVIEC IN varchar2,
        p_THULYTUNGAY IN date,
        p_THULYDENNGAY IN date,
        p_TINHTRANGTHULY IN nvarchar2,
        p_THAMPHANGIAIQUYET IN nvarchar2,
        p_TENVUAN IN nvarchar2,    
        p_TRANGTHAIGIAIQUYET IN nvarchar2,    
        p_CAPXETXU IN nvarchar2,  
        p_TRANGTHAI IN NVARCHAR2,
        p_CURSOR OUT SYS_REFCURSOR
    ) AS
        /*
        ================================================================================
        AHN VERSION WITH DUAL PROCEDURES ENABLED - COMPLETE DATASET:
        
        APPROACH: Sử dụng cả PKG_AHN_STPT_DS.AHN_DON_SEARCH_TURNING và PKG_STPT_AHN_GS.DON_SEARCH
        
        FEATURES:
        - PKG_AHN_STPT_DS.AHN_DON_SEARCH_TURNING: 27 columns, comprehensive AHN data
        - PKG_STPT_AHN_GS.DON_SEARCH: 33 parameters, validated mapping theo AHN_DON_BL.cs
        - Combined COUNTALL từ cả 2 procedures để có tổng số record chính xác
        - DISTINCT query để tránh duplicate records
        - Logic xử lý khác nhau theo p_TRANGTHAI:
          + TRANGTHAI = 0: Loại bỏ bản ghi đã có mapping với toaangiaoid = p_toaanid
          + TRANGTHAI = 1: Gọi procedures với p_TOAANID + TOTOAANID từ DM_TOAAN_TACH_NHAP_MAPPING
        
        EXECUTION FLOW:
        - CHECK p_TRANGTHAI value
        - IF TRANGTHAI = 1: Loop qua p_TOAANID + các TOTOAANID và gọi CẢ 2 procedures
        - IF TRANGTHAI = 0/NULL: Gọi CẢ 2 procedures với p_TOAANID thông thường  
        - Final: Combine và return complete dataset với accurate COUNTALL
        - Note: Procedure này trả về vụ án phúc thẩm (MAGIAIDOAN=7) từ nhiều nguồn
        ================================================================================
        */
        
        TOTALITEM                   NUMBER;  
        MININDEX                    NUMBER; 
        MAXINDEX                    NUMBER; 
        V_TABLE_TIMKIEM             T_TIMKIEM_STPT_DS;
        
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
        
        FETCH_ID                VARCHAR2(255 CHAR);
        FETCH_MAVUVIEC          VARCHAR2(255 CHAR);
        FETCH_TENVUVIEC         VARCHAR2(4000 CHAR);
        FETCH_SOTHUTU           VARCHAR2(255 CHAR); 
        FETCH_NGAYNHANDON       VARCHAR2(255 CHAR);
        FETCH_HINHTHUCNHANDON   VARCHAR2(255 CHAR);
        FETCH_MAGIAIDOAN        VARCHAR2(255 CHAR);  
        FETCH_QHPLTKID          VARCHAR2(255 CHAR);
        FETCH_TOAANID           VARCHAR2(25 CHAR);
        FETCH_QUANHEPL          VARCHAR2(4000 CHAR);
        FETCH_BANAN_QD_ST       VARCHAR2(4000 CHAR);
        FETCH_QD_PT             VARCHAR2(4000 CHAR);
        FETCH_KHANGNGHI_ST      VARCHAR2(4000 CHAR);
        FETCH_CHECK_THULY       VARCHAR2(1000 CHAR);
        FETCH_HOTENBICAN        VARCHAR2(4000 CHAR);
        FETCH_COUNTALL          VARCHAR2(255 CHAR);
        FETCH_STT               VARCHAR2(1000 CHAR);
        FETCH_NGUOITAO          VARCHAR2(255 CHAR);
        FETCH_NGAY_TAO          VARCHAR2(255 CHAR);
        FETCH_NGAYTAO           VARCHAR2(255 CHAR);
        FETCH_TENTOASOTHAM      VARCHAR2(1000 CHAR);
        FETCH_GIAIDOANVUVIEC    VARCHAR2(255 CHAR);
        FETCH_TRUONGHOPGIAONHAN VARCHAR2(4000 CHAR);
        FETCH_KHANGCAO_ST       VARCHAR2(4000 CHAR);
        FETCH_TINHTRANG_GQ      VARCHAR2(4000 CHAR);
        FETCH_THULYXXLAI        VARCHAR2(1000 CHAR);
        FETCH_THAMPHANHG        VARCHAR2(4000 CHAR);  -- Cột thứ 27 cho AHN procedure
        
        SUM_COUNTALL            NUMBER DEFAULT 0;
        CURSOR_RETURN           SYS_REFCURSOR;
        CURSOR_RETURN2           SYS_REFCURSOR;
        
        -- PROCESS_CURSOR: Xử lý cursor và capture COUNTALL từ record đầu tiên
        PROCEDURE PROCESS_CURSOR(P_CUR IN SYS_REFCURSOR, P_TYPE VARCHAR2, P_VAR NUMBER, P_TOAANID VARCHAR2) IS
            V_IS_FIRST_RECORD BOOLEAN := TRUE;
        BEGIN
            LOOP
                BEGIN
                    IF P_VAR = 1 THEN
                        -- FETCH cho PKG_STPT_AHN_GS.DON_SEARCH (23 cột) - Fixed với đúng 33 parameters
                        FETCH P_CUR INTO FETCH_STT, FETCH_COUNTALL, FETCH_ID, FETCH_MAVUVIEC, 
                          FETCH_TENVUVIEC, FETCH_SOTHUTU, FETCH_NGAYNHANDON, FETCH_NGUOITAO, 
                          FETCH_NGAYTAO, FETCH_QUANHEPL, FETCH_TENTOASOTHAM, FETCH_GIAIDOANVUVIEC,
                          FETCH_HINHTHUCNHANDON, FETCH_TRUONGHOPGIAONHAN, FETCH_BANAN_QD_ST, 
                          FETCH_QD_PT, FETCH_KHANGNGHI_ST, FETCH_KHANGCAO_ST, FETCH_MAGIAIDOAN,
                          FETCH_HOTENBICAN, FETCH_TINHTRANG_GQ, FETCH_CHECK_THULY, FETCH_THULYXXLAI;
                    
                        EXIT WHEN P_CUR%NOTFOUND;
                        
                        -- Capture COUNTALL từ record đầu tiên của procedure 2
                        IF V_IS_FIRST_RECORD THEN
                            V_COUNTALL_PROC2 := TO_NUMBER(FETCH_COUNTALL);
                            V_IS_FIRST_RECORD := FALSE;
                        END IF;
                        
                        -- Gán giá trị cho các trường bị thiếu
                        FETCH_QHPLTKID := '';
                        FETCH_TOAANID := P_TOAANID;
                        FETCH_NGAY_TAO := FETCH_NGAYTAO;
                    ELSE
                        -- FETCH cho PKG_AHN_STPT_DS.AHN_DON_SEARCH_TURNING (27 cột, thứ tự: ID, MAVUVIEC...)
                        FETCH P_CUR INTO FETCH_ID, FETCH_MAVUVIEC, FETCH_TENVUVIEC, FETCH_SOTHUTU, 
                          FETCH_NGAYNHANDON, FETCH_HINHTHUCNHANDON, FETCH_MAGIAIDOAN, FETCH_QHPLTKID,
                          FETCH_TOAANID, FETCH_QUANHEPL, FETCH_BANAN_QD_ST, FETCH_QD_PT,
                          FETCH_KHANGNGHI_ST, FETCH_CHECK_THULY, FETCH_HOTENBICAN, FETCH_COUNTALL, 
                          FETCH_STT, FETCH_NGAY_TAO, FETCH_NGUOITAO, FETCH_NGAYTAO, FETCH_TENTOASOTHAM, 
                          FETCH_GIAIDOANVUVIEC, FETCH_TRUONGHOPGIAONHAN, FETCH_KHANGCAO_ST,
                          FETCH_TINHTRANG_GQ, FETCH_THULYXXLAI, FETCH_THAMPHANHG;
                    
                        EXIT WHEN P_CUR%NOTFOUND;
                        
                        -- Capture COUNTALL từ record đầu tiên của procedure 1
                        IF V_IS_FIRST_RECORD THEN
                            V_COUNTALL_PROC1 := TO_NUMBER(FETCH_COUNTALL);
                            V_IS_FIRST_RECORD := FALSE;
                        END IF;
                    END IF;
                    
                    -- Phần xử lý chung vẫn giữ nguyên
                    V_TABLE_TIMKIEM.EXTEND;
                    V_TABLE_TIMKIEM(V_TABLE_TIMKIEM.COUNT) := R_TIMKIEM_STPT_DS(
                        FETCH_ID, FETCH_MAVUVIEC, FETCH_TENVUVIEC, FETCH_SOTHUTU, FETCH_NGAYNHANDON, 
                        FETCH_HINHTHUCNHANDON, FETCH_MAGIAIDOAN, FETCH_QHPLTKID, FETCH_TOAANID, 
                        FETCH_QUANHEPL, FETCH_BANAN_QD_ST, FETCH_QD_PT, FETCH_KHANGNGHI_ST, 
                        FETCH_CHECK_THULY, FETCH_HOTENBICAN, FETCH_COUNTALL, FETCH_STT, FETCH_NGAY_TAO,
                        FETCH_NGUOITAO, FETCH_NGAYTAO, FETCH_TENTOASOTHAM, FETCH_GIAIDOANVUVIEC,
                        FETCH_TRUONGHOPGIAONHAN, FETCH_KHANGCAO_ST, FETCH_TINHTRANG_GQ, FETCH_THULYXXLAI, P_TYPE
                    );
                END;
            END LOOP;
        END PROCESS_CURSOR;
    BEGIN
        
        -- Set fixed pagesize for optimal performance
        V_PROCEDURE_PAGESIZE := V_OPTIMIZED_PAGESIZE;
        
        IF p_THULYTUNGAY IS NOT NULL THEN 
            V_THULYTUNGAY := TO_CHAR(p_THULYTUNGAY, 'DD/MM/YYYY');
        ELSE
            V_THULYTUNGAY := '';
        END IF;  
    
        IF p_THULYDENNGAY IS NOT NULL THEN  
            V_THULYDENNGAY := TO_CHAR(p_THULYDENNGAY, 'DD/MM/YYYY'); 
        ELSE
            V_THULYDENNGAY := '';
        END IF;

SELECT LOAITOA
  INTO V_CAP_XET_XU_LOGIN
  FROM DM_TOAAN
  WHERE 1 = 1
    AND ID = P_TOAANID;
        V_TABLE_TIMKIEM := T_TIMKIEM_STPT_DS();
        
        -- LOGIC XỬ LÝ THEO p_TRANGTHAI
        IF p_TRANGTHAI = 1 THEN
            -- TRANGTHAI = 1: Lấy dữ liệu từ các toà được bàn giao (bao gồm cả p_TOAANID gốc)
            FOR toaan_rec IN (
                SELECT p_TOAANID AS TOTOAANID FROM DUAL
                UNION ALL
                SELECT TOTOAANID FROM DM_TOAAN_TACH_NHAP_MAPPING WHERE TOAANID = p_TOAANID
            ) LOOP
                V_CURRENT_TOAANID := toaan_rec.TOTOAANID;
                V_TRANGTHAIGIAIQUYET := '';
                
                -- BƯỚC 1: PKG_AHN_STPT_DS.AHN_DON_SEARCH_TURNING procedure call
                PKG_AHN_STPT_DS.AHN_DON_SEARCH_TURNING(
                  V_CAP_XET_XU_LOGIN,
                  p_TENVUAN,
                  NULL,
                  p_MAVUVIEC,
                  NULL,
                  p_CAPXETXU,
                  V_CURRENT_TOAANID,
                  p_TINHTRANGTHULY,
                  V_THULYTUNGAY,
                  V_THULYDENNGAY,
                  NULL,
                  p_THAMPHANGIAIQUYET,
                  V_TRANGTHAIGIAIQUYET,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  0,
                  NULL,
                  NULL,
                  1,
                  1,
                  0,
                  0,
                  NULL,
                  NULL,
                  null, -- AN_DA_KET_THUC
                  1, 
                  V_PROCEDURE_PAGESIZE, 
                  CURSOR_RETURN);
                IF CURSOR_RETURN IS NOT NULL THEN
                    PROCESS_CURSOR(CURSOR_RETURN, '3', 0, V_CURRENT_TOAANID);
                    CLOSE CURSOR_RETURN;
                END IF;

                -- Không lấy án TĐC với cấp sơ thẩm
                IF P_CAPXETXU IS NULL OR p_CAPXETXU <> 2 THEN
                                                        
                  -- BƯỚC 2: PKG_STPT_AHN_GS.DON_SEARCH với đúng 33 parameters theo AHN_DON_BL.cs
                  PKG_STPT_AHN_GS.DON_SEARCH(
                      V_CAP_XET_XU_LOGIN,       -- 1. V_CAP_XET_XU_LOGIN
                      p_TENVUAN,                -- 2. V_TEN_VU_AN  
                      NULL,                     -- 3. V_QHPL
                      p_MAVUVIEC,              -- 4. V_MA_VU_AN
                      NULL,                     -- 5. V_TENDUONGSU
                      3,                        -- 6. V_CAPXX
                      V_CURRENT_TOAANID,       -- 7. V_TOAAN_ID
                      p_TINHTRANGTHULY,        -- 8. V_TINHTRANG_THULY
                      V_THULYTUNGAY,           -- 9. V_NGAYTHULY_TU
                      V_THULYDENNGAY,          -- 10. V_NGAYTHULY_DEN
                      NULL,                     -- 11. V_SOTHULY
                      p_THAMPHANGIAIQUYET,     -- 12. V_THAMPHAN_ID
                      p_TRANGTHAIGIAIQUYET,    -- 13. V_TINHTRANG_GIAIQUYET
                      NULL,                     -- 14. V_TUNGAY
                      NULL,                     -- 15. V_DENNGAY
                      NULL,                     -- 16. V_KETQUA
                      NULL,                     -- 17. V_SO_QD
                      NULL,                     -- 18. V_NGAY_QD
                      NULL,                     -- 19. V_THUKY_ID
                      NULL,                     -- 20. V_THOIHAN_GQ
                      NULL,                     -- 21. V_LOAIDON
                      NULL,                     -- 22. V_PT_RKINHNGHIEM
                      NULL,                     -- 23. V_GQDON
                      NULL,                     -- 24. V_UTTP
                      0,                        -- 25. VCHECKTK
                      0,                        -- 26. V_TRANGTHAIVUAN
                      NULL,                     -- 27. V_VAITRO_THAMPHAN
                      0,                        -- 28. V_CHECK_HOAGIAI
                      0,                        -- 29. V_HOAGIAI_TRANGTHAI
                      NULL,                     -- 30. V_HOAGIAI_TUNGAY
                      NULL,                     -- 31. V_HOAGIAI_DENNGAY
                      null, -- AN_DA_KET_THUC
                      1,                        -- 32. PAGE_INDEX
                      V_PROCEDURE_PAGESIZE,     -- 33. PAGE_SIZE
                      CURSOR_RETURN2            -- 34. CURRETURN (OUT)
                  );
                                                             
                  IF CURSOR_RETURN2 IS NOT NULL THEN
                      PROCESS_CURSOR(CURSOR_RETURN2, '3', 1, V_CURRENT_TOAANID);
                      CLOSE CURSOR_RETURN2;
                  END IF;

  
                  -- Bước 3: lấy dữ liệu chưa thụ lý với TRANGTHAIGIAIQUYET = ''
--                  IF (NVL(LENGTH(p_TINHTRANGTHULY),0) = 0) OR p_TINHTRANGTHULY = '2' THEN
--                      V_TRANGTHAIGIAIQUYET := '';
--                      V_TINHTRANGTHULY := '2';
--                      PKG_STPT_AHN_GS.DON_SEARCH(
--                        V_CAP_XET_XU_LOGIN,       -- 1. V_CAP_XET_XU_LOGIN
--                        p_TENVUAN,                -- 2. V_TEN_VU_AN  
--                        NULL,                     -- 3. V_QHPL
--                        p_MAVUVIEC,              -- 4. V_MA_VU_AN
--                        NULL,                     -- 5. V_TENDUONGSU
--                        3,                        -- 6. V_CAPXX
--                        V_CURRENT_TOAANID,       -- 7. V_TOAAN_ID
--                        V_TINHTRANGTHULY,        -- 8. V_TINHTRANG_THULY
--                        V_THULYTUNGAY,           -- 9. V_NGAYTHULY_TU
--                        V_THULYDENNGAY,          -- 10. V_NGAYTHULY_DEN
--                        NULL,                     -- 11. V_SOTHULY
--                        p_THAMPHANGIAIQUYET,     -- 12. V_THAMPHAN_ID
--                        V_TRANGTHAIGIAIQUYET,    -- 13. V_TINHTRANG_GIAIQUYET
--                        NULL,                     -- 14. V_TUNGAY
--                        NULL,                     -- 15. V_DENNGAY
--                        NULL,                     -- 16. V_KETQUA
--                        NULL,                     -- 17. V_SO_QD
--                        NULL,                     -- 18. V_NGAY_QD
--                        NULL,                     -- 19. V_THUKY_ID
--                        NULL,                     -- 20. V_THOIHAN_GQ
--                        NULL,                     -- 21. V_LOAIDON
--                        NULL,                     -- 22. V_PT_RKINHNGHIEM
--                        NULL,                     -- 23. V_GQDON
--                        NULL,                     -- 24. V_UTTP
--                        0,                        -- 25. VCHECKTK
--                        0,                        -- 26. V_TRANGTHAIVUAN
--                        NULL,                     -- 27. V_VAITRO_THAMPHAN
--                        0,                        -- 28. V_CHECK_HOAGIAI
--                        0,                        -- 29. V_HOAGIAI_TRANGTHAI
--                        NULL,                     -- 30. V_HOAGIAI_TUNGAY
--                        NULL,                     -- 31. V_HOAGIAI_DENNGAY
--                        1,                        -- 32. PAGE_INDEX
--                        V_PROCEDURE_PAGESIZE,     -- 33. PAGE_SIZE
--                        CURSOR_RETURN2            -- 34. CURRETURN (OUT)
--                    );
--                                                               
--                    IF CURSOR_RETURN2 IS NOT NULL THEN
--                        PROCESS_CURSOR(CURSOR_RETURN2, '3', 1, V_CURRENT_TOAANID);
--                        CLOSE CURSOR_RETURN2;
--                    END IF;
--                  END IF;

                END IF;
            END LOOP;
        ELSE
            -- TRANGTHAI = 0 hoặc NULL: Logic cũ với p_TOAANID
            -- BƯỚC 1: PKG_AHN_STPT_DS.AHN_DON_SEARCH_TURNING procedure call
            PKG_AHN_STPT_DS.AHN_DON_SEARCH_TURNING(
              V_CAP_XET_XU_LOGIN,
              p_TENVUAN,
              NULL,
              p_MAVUVIEC,
              NULL,
              p_CAPXETXU,
              p_TOAANID,
              p_TINHTRANGTHULY,
              V_THULYTUNGAY,
              V_THULYDENNGAY,
              NULL,
              p_THAMPHANGIAIQUYET,
              p_TRANGTHAIGIAIQUYET,
              NULL,
              NULL,
              NULL,
              NULL,
              NULL,
              NULL,
              NULL,
              NULL,
              NULL,
              NULL,
              NULL,
              0,
              NULL,
              NULL,
              1,
              1,
              0,
              0,
              NULL,
              NULL,
              NULL, -- AN_DA_KET_THUC
              1,
              V_PROCEDURE_PAGESIZE,
              CURSOR_RETURN
             );
            IF CURSOR_RETURN IS NOT NULL THEN
                PROCESS_CURSOR(CURSOR_RETURN, '3', 0, p_TOAANID);
                CLOSE CURSOR_RETURN;
            END IF;

            -- Không lấy án TĐC với cấp sơ thẩm
            IF (P_CAPXETXU IS NULL OR p_CAPXETXU <> 2) THEN
                                                    
              -- BƯỚC 2: PKG_STPT_AHN_GS.DON_SEARCH với đúng 33 parameters theo AHN_DON_BL.cs
              PKG_STPT_AHN_GS.DON_SEARCH(
                  V_CAP_XET_XU_LOGIN,       -- 1. V_CAP_XET_XU_LOGIN
                  p_TENVUAN,                -- 2. V_TEN_VU_AN  
                  NULL,                     -- 3. V_QHPL
                  p_MAVUVIEC,              -- 4. V_MA_VU_AN
                  NULL,                     -- 5. V_TENDUONGSU
                  3,                        -- 6. V_CAPXX
                  p_TOAANID,               -- 7. V_TOAAN_ID
                  p_TINHTRANGTHULY,        -- 8. V_TINHTRANG_THULY
                  V_THULYTUNGAY,           -- 9. V_NGAYTHULY_TU
                  V_THULYDENNGAY,          -- 10. V_NGAYTHULY_DEN
                  NULL,                     -- 11. V_SOTHULY
                  p_THAMPHANGIAIQUYET,     -- 12. V_THAMPHAN_ID
                  p_TRANGTHAIGIAIQUYET,    -- 13. V_TINHTRANG_GIAIQUYET
                  NULL,                     -- 14. V_TUNGAY
                  NULL,                     -- 15. V_DENNGAY
                  NULL,                     -- 16. V_KETQUA
                  NULL,                     -- 17. V_SO_QD
                  NULL,                     -- 18. V_NGAY_QD
                  NULL,                     -- 19. V_THUKY_ID
                  NULL,                     -- 20. V_THOIHAN_GQ
                  NULL,                     -- 21. V_LOAIDON
                  NULL,                     -- 22. V_PT_RKINHNGHIEM
                  NULL,                     -- 23. V_GQDON
                  NULL,                     -- 24. V_UTTP
                  0,                        -- 25. VCHECKTK
                  0,                        -- 26. V_TRANGTHAIVUAN
                  NULL,                     -- 27. V_VAITRO_THAMPHAN
                  0,                        -- 28. V_CHECK_HOAGIAI
                  0,                        -- 29. V_HOAGIAI_TRANGTHAI
                  NULL,                     -- 30. V_HOAGIAI_TUNGAY
                  NULL,                     -- 31. V_HOAGIAI_DENNGAY
                  NULL, -- AN_DA_KET_THUC
                  1,                        -- 32. PAGE_INDEX
                  V_PROCEDURE_PAGESIZE,     -- 33. PAGE_SIZE
                  CURSOR_RETURN2            -- 34. CURRETURN (OUT)
              );
                                                         
              IF CURSOR_RETURN2 IS NOT NULL THEN
                  PROCESS_CURSOR(CURSOR_RETURN2, '3', 1, p_TOAANID);
                  CLOSE CURSOR_RETURN2;
              END IF;
  
              -- Bước 3: lấy dữ liệu chưa thụ lý với TRANGTHAIGIAIQUYET = ''
              IF (NVL(LENGTH(p_TINHTRANGTHULY),0) = 0) OR p_TINHTRANGTHULY = '2' THEN
                  V_TRANGTHAIGIAIQUYET := '';
                  V_TINHTRANGTHULY := '2';

                  PKG_STPT_AHN_GS.DON_SEARCH(
                      V_CAP_XET_XU_LOGIN,       -- 1. V_CAP_XET_XU_LOGIN
                      p_TENVUAN,                -- 2. V_TEN_VU_AN  
                      NULL,                     -- 3. V_QHPL
                      p_MAVUVIEC,              -- 4. V_MA_VU_AN
                      NULL,                     -- 5. V_TENDUONGSU
                      3,                        -- 6. V_CAPXX
                      p_TOAANID,               -- 7. V_TOAAN_ID
                      V_TINHTRANGTHULY,        -- 8. V_TINHTRANG_THULY
                      V_THULYTUNGAY,           -- 9. V_NGAYTHULY_TU
                      V_THULYDENNGAY,          -- 10. V_NGAYTHULY_DEN
                      NULL,                     -- 11. V_SOTHULY
                      p_THAMPHANGIAIQUYET,     -- 12. V_THAMPHAN_ID
                      V_TRANGTHAIGIAIQUYET,    -- 13. V_TINHTRANG_GIAIQUYET
                      NULL,                     -- 14. V_TUNGAY
                      NULL,                     -- 15. V_DENNGAY
                      NULL,                     -- 16. V_KETQUA
                      NULL,                     -- 17. V_SO_QD
                      NULL,                     -- 18. V_NGAY_QD
                      NULL,                     -- 19. V_THUKY_ID
                      NULL,                     -- 20. V_THOIHAN_GQ
                      NULL,                     -- 21. V_LOAIDON
                      NULL,                     -- 22. V_PT_RKINHNGHIEM
                      NULL,                     -- 23. V_GQDON
                      NULL,                     -- 24. V_UTTP
                      0,                        -- 25. VCHECKTK
                      0,                        -- 26. V_TRANGTHAIVUAN
                      NULL,                     -- 27. V_VAITRO_THAMPHAN
                      0,                        -- 28. V_CHECK_HOAGIAI
                      0,                        -- 29. V_HOAGIAI_TRANGTHAI
                      NULL,                     -- 30. V_HOAGIAI_TUNGAY
                      NULL,                     -- 31. V_HOAGIAI_DENNGAY
                      NULL, -- AN_DA_KET_THUC
                      1,                        -- 32. PAGE_INDEX
                      V_PROCEDURE_PAGESIZE,     -- 33. PAGE_SIZE
                      CURSOR_RETURN2            -- 34. CURRETURN (OUT)
                  );
                                                             
                  IF CURSOR_RETURN2 IS NOT NULL THEN
                      PROCESS_CURSOR(CURSOR_RETURN2, '3', 1, p_TOAANID);
                      CLOSE CURSOR_RETURN2;
                  END IF;
              END IF;

            END IF;
        END IF;
        
        -- BƯỚC 3: Tính tổng COUNTALL thực tế từ cả 2 procedures
        V_REAL_COUNTALL := V_COUNTALL_PROC1 + V_COUNTALL_PROC2;
            
        -- BƯỚC 4: Final query với DISTINCT để loại bỏ duplicate (bỏ STT)
        OPEN p_CURSOR FOR
SELECT DISTINCT V_REAL_COUNTALL AS COUNTALL,
                A.ID,
                A.MAVUVIEC,
                A.TENVUVIEC,
                A.SOTHUTU,
                A.NGAYNHANDON,
                A.HINHTHUCNHANDON,
                A.MAGIAIDOAN,
                A.QHPLTKID,
                A.TOAANID,
                A.QUANHEPL,
                A.BANAN_QD_ST,
                A.QD_PT,
                A.KHANGNGHI_ST,
                A.CHECK_THULY,
                A.HOTENBICAN,
                A.NGUOITAO,
                A.NGAY_TAO AS NGAYTHULY,
                A.NGAYTAO,
                A.TENTOASOTHAM,
                A.GIAIDOANVUVIEC,
                A.TRUONGHOPGIAONHAN,
                A.KHANGCAO_ST,
                A.TINHTRANG_GQ,
                A.THULYXXLAI,
                A.LOAIAN_ID,
                LA.LOAI_AN_TEN,
                B.ID AS MAPPINGID,
                B.LYDOMA AS LYDO,
                B.NGAYGIAO AS THOIGIANBANGIAO,
                B.TRANGTHAI,
                C.TEN AS TOANHAN,
                LD.TEN AS LYDOTEN
  FROM TABLE (V_TABLE_TIMKIEM) A
    LEFT JOIN DM_LOAIAN LA
      ON LA.ID = A.LOAIAN_ID
    LEFT JOIN VUAN_BANGIAO_MAPPING B
      ON A.ID = B.VUVIECID
      AND b.TOAANGIAOID = P_TOAANID
      AND b.VUVIECLOAI = 'AN_HNGD'
      AND (1 = (CASE 
                    WHEN P_TRANGTHAI = 0 THEN 1
                    WHEN P_TRANGTHAIGIAIQUYET IS NULL THEN 1
                    WHEN P_TRANGTHAIGIAIQUYET = 1 THEN 
                        CASE WHEN B.TRANGTHAIGIAIQUYET = 1 OR B.TRANGTHAIGIAIQUYET IS NULL THEN 1 ELSE 0 END
                    WHEN P_TRANGTHAIGIAIQUYET = 7 THEN 
                        CASE WHEN B.TRANGTHAIGIAIQUYET = 7 THEN 1 ELSE 0 END
                    ELSE 0
                END))
    LEFT JOIN DM_TOAAN C
      ON CASE WHEN b.TOAANNHANID IS NULL THEN 0 ELSE b.TOAANNHANID END = C.ID
    LEFT JOIN DM_DATAITEM ld
      ON b.LYDOMA = ld.MA
  WHERE 1 = 1
    -- Loại trừ những bản ghi mapping mà toà hiện tại đã nhận (TOAANNHANID = p_TOAANID)
    AND (B.TOAANNHANID IS NULL
    OR B.TOAANNHANID != P_TOAANID)
    AND (1 = (CASE
      -- TRANGTHAI = 0: Loại bỏ những bản ghi đã có mapping với toaangiaoid = p_toaanid
      WHEN P_TRANGTHAI = 0 THEN CASE WHEN NOT EXISTS (SELECT 1
                  FROM VUAN_BANGIAO_MAPPING vm
                  WHERE vm.VUVIECID = A.ID
                    AND vm.TOAANGIAOID = P_TOAANID
                    AND vm.VUVIECLOAI = 'AN_HNGD') THEN 1 ELSE 0 END
      -- TRANGTHAI = 1: Chỉ lấy những bản ghi có mapping 
      WHEN P_TRANGTHAI = 1 AND
        B.TRANGTHAI IS NOT NULL THEN 1
      -- TRANGTHAI = NULL hoặc khác: Lấy tất cả
      WHEN P_TRANGTHAI IS NULL THEN 1 WHEN P_TRANGTHAI NOT IN (0, 1) THEN 1 ELSE 0 END))
  ORDER BY A.ID DESC,
           B.ID DESC;
    END AHN_VUAN_BANGIAO_MAPPING_GET_AN_BAN_GIAO;

    -- [AHN] LẤY DANH SÁCH CHỜ DUYỆT
    PROCEDURE AHN_VUAN_BANGIAO_MAPPING_GETS_CHONHAN (
      p_LOAIANID IN varchar2,
	    p_TOAANID IN NUMBER,
	    p_MAVUVIEC IN varchar2,
	    p_THULYTUNGAY IN date,
	    p_THULYDENNGAY IN date,
	    p_TINHTRANGTHULY IN nvarchar2,
	    p_THAMPHANGIAIQUYET IN nvarchar2,
	    p_TENVUAN IN nvarchar2,    
	    p_TRANGTHAIGIAIQUYET IN nvarchar2,    
	    p_CAPXETXU IN nvarchar2,  
	    p_TRANGTHAI IN NVARCHAR2,
	    p_CURSOR OUT SYS_REFCURSOR
    ) AS
        BEGIN
            OPEN p_CURSOR FOR
                SELECT  
                    DISTINCT
  
                    -- Mapping
                    mapping.ID as MAPPINGID,
                    mapping.NGAYGIAO,
                    mapping.NGAYNHAN,
                    mapping.TRANGTHAI,
                    mapping.GHICHU,
                    -- Vụ việc
                    don.ID AS VUVIECID,
                    don.MAVUVIEC AS VUVIECMA,
                    don.TENVUVIEC AS VUVIECTEN, 
                    -- Toà giao
                    mapping.TOAANGIAOID,
                    taGiao.TEN AS TOAANGIAOTEN,
                    -- Toà nhận
                    mapping.TOAANNHANID,
                    -- Lý do
                    mapping.LYDOMA,
                    lyDo.TEN AS LYDOTEN
                from AHN_DON don 
                JOIN VUAN_BANGIAO_MAPPING mapping ON don.ID = mapping.VUVIECID AND MAPPING.VUVIECLOAI = 'AN_HNGD'
                JOIN DM_TOAAN taGiao ON case when mapping.TOAANGIAOID is null then 0 else mapping.TOAANGIAOID end = taGiao.ID
                JOIN DM_TOAAN taNhan ON case when mapping.TOAANNHANID is null then 0 else mapping.TOAANNHANID end = taNhan.ID
                JOIN DM_DATAITEM lyDo ON mapping.LYDOMA = lyDo.MA
                LEFT JOIN AHN_SOTHAM_THULY thuLy ON don.ID = thuLy.DONID
                LEFT JOIN AHN_PHUCTHAM_THULY E ON don.ID = E.DONID
                LEFT JOIN DM_CANBO cb ON cb.ID = don.THAMPHANKYNHANDON
                WHERE mapping.TOAANNHANID = P_TOAANID 
                AND  (1=(CASE WHEN (p_MAVUVIEC || ' ')=' '  THEN 1 WHEN LOWER(don.MAVUVIEC) LIKE  ('%' || LOWER(p_MAVUVIEC) || '%') THEN 1 Else 0 END))
                And (1=(CASE WHEN p_THULYTUNGAY is NULL THEN 1 WHEN thuLy.NGAYTHULY >= p_THULYTUNGAY  THEN 1 Else 0 END))
                And (1=(CASE WHEN p_THULYDENNGAY is NULL THEN 1 WHEN thuLy.NGAYTHULY <= p_THULYDENNGAY  THEN 1 Else 0 END))  
                AND  (1=(CASE WHEN p_TINHTRANGTHULY IS NULL THEN 1
                            WHEN p_TINHTRANGTHULY = 1 AND 
                                 (CASE WHEN don.MAGIAIDOAN = 2 THEN thuLy.truonghopthuly  -- Cap So Tham
                                       WHEN don.MAGIAIDOAN IN (3,7) THEN E.truonghopthuly  -- Cap Phuc Tham
                                       ELSE thuLy.truonghopthuly END) IS NOT NULL THEN 1 -- Da thu ly
                            WHEN p_TINHTRANGTHULY = 2 AND 
                                 (CASE WHEN don.MAGIAIDOAN = 2 THEN thuLy.truonghopthuly -- Cap So Tham
                                       WHEN don.MAGIAIDOAN IN (3,7) THEN E.truonghopthuly -- Cap Phuc Tham
                                       ELSE thuLy.truonghopthuly END) IS NULL THEN 1 -- Chua thu ly
                        WHEN p_TINHTRANGTHULY NOT IN (1, 2) THEN 1 ELSE 0 END))
                AND  (1=(CASE WHEN (p_THAMPHANGIAIQUYET|| ' ')=' '  THEN 1 WHEN LOWER(cb.HOTEN) LIKE  ('%' || LOWER(p_THAMPHANGIAIQUYET) || '%') THEN 1 
                            WHEN LOWER(cb.MACANBO) LIKE  ('%' || LOWER(p_THAMPHANGIAIQUYET) || '%') THEN 1 Else 0 END))
                AND  (1=(CASE WHEN (p_TENVUAN|| ' ')=' '  THEN 1 WHEN LOWER(don.TENVUVIEC) LIKE  ('%' || LOWER(p_TENVUAN) || '%') THEN 1 Else 0 END))
--                AND  (1=(CASE WHEN (p_TRANGTHAIGIAIQUYET|| ' ')=' ' THEN 1 WHEN don.TRANGTHAI LIKE P_TRANGTHAIGIAIQUYET THEN 1 Else 0 END))
                -- Trạng thái giải quyết
                AND (1 = (CASE 
                              WHEN P_TRANGTHAIGIAIQUYET IS NULL THEN 1
                              WHEN P_TRANGTHAIGIAIQUYET = '1' THEN 
                                  CASE WHEN MAPPING.TRANGTHAIGIAIQUYET = '1' OR MAPPING.TRANGTHAIGIAIQUYET IS NULL THEN 1 ELSE 0 END
                              WHEN P_TRANGTHAIGIAIQUYET = '7' THEN 
                                  CASE WHEN MAPPING.TRANGTHAIGIAIQUYET = '7' THEN 1 ELSE 0 END
                              ELSE 0
                          END))
                -- Cấp xét xử
                AND (1 = (CASE WHEN p_CAPXETXU IS NULL THEN 1
                            WHEN p_CAPXETXU = 2 AND mapping.MAGIAIDOAN = 2 THEN 1 -- Cap So Tham
                            WHEN p_CAPXETXU = 3 AND mapping.MAGIAIDOAN IN (3,7) THEN 1 -- Cap Phuc Tham
                            WHEN p_CAPXETXU NOT IN (2, 3) THEN 1
                            ELSE 0 END))
                AND  (1=(CASE WHEN (p_TRANGTHAI|| ' ')=' '  THEN 1 WHEN LOWER(mapping.TRANGTHAI) = LOWER(p_TRANGTHAI) THEN 1 Else 0 END))
                ORDER BY mapping.ID DESC;
    END AHN_VUAN_BANGIAO_MAPPING_GETS_CHONHAN;

    -- [AHN] NHẬN BÀN GIAO
    PROCEDURE AHN_VUAN_BANGIAO_MAPPING_NHAN (
        p_ID IN NUMBER,
        p_VUVIECID IN NUMBER,
        p_TOAANNHANID IN NUMBER,
        p_NGAYNHAN IN DATE
    ) AS
        v_MAGIAIDOAN NUMBER;
        v_TOAANID NUMBER;
        v_TOAPHUCTHAMID NUMBER;
        v_TRANGTHAIGIAIQUYET VARCHAR2(20);

        v_tracedata VARCHAR2(1024);
        v_output VARCHAR2(512);
    BEGIN
        v_tracedata := '(' || 
         'p_ID => ' || p_ID || ',' ||
         'p_VUVIECID => ' || p_VUVIECID || ',' ||
         'p_TOAANNHANID => ' || p_TOAANNHANID || ',' ||
         'p_NGAYNHAN => ' || p_NGAYNHAN || ',' ||
         ' );';

        -- Lấy giai đoạn hiện tại của án
        SELECT don.TOAANID, don.TOAPHUCTHAMID
        INTO v_TOAANID, v_TOAPHUCTHAMID
        FROM AHN_DON don 
        WHERE don.ID = p_VUVIECID;

        -- Lấy thông tin mapping
        SELECT vbm.MAGIAIDOAN, vbm.TRANGTHAIGIAIQUYET
        INTO v_MAGIAIDOAN, v_TRANGTHAIGIAIQUYET
        FROM VUAN_BANGIAO_MAPPING vbm
        WHERE vbm.ID = p_ID AND vbm.TRANGTHAI = 'TTBG_CHONHAN';

        -- Kiểm tra giai đoạn hợp lệ
        IF v_MAGIAIDOAN NOT IN (2, 3, 7) THEN
            RAISE_APPLICATION_ERROR(-20001, 'Giai đoạn không hợp lệ.');
        END IF;

        -- Cập nhật án đã kết thúc với trạng thái giải quyết = 7
        UPDATE AHN_DON_GIAIDOAN
        SET AN_DA_KET_THUC = CASE 
                WHEN v_TRANGTHAIGIAIQUYET = 7 THEN 1 
                ELSE AN_DA_KET_THUC 
            END
        WHERE DONID = p_VUVIECID AND MAGIAIDOAN = v_MAGIAIDOAN;

        -- Xử lý cập nhật theo giai đoạn
        IF v_MAGIAIDOAN = 2 THEN
            -- SƠ THẨM
            -- AHN_DON
            UPDATE AHN_DON
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE ID = p_VUVIECID AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE AHN_DON
            SET TOAANID = p_TOAANNHANID
            WHERE ID = p_VUVIECID AND TOAANID = v_TOAANID;

            -- Kiểm tra xem có update được chính xác 1 bản ghi AHN_DON hay không
--            IF SQL%ROWCOUNT != 1 THEN
--                ROLLBACK;
--                RAISE_APPLICATION_ERROR(-20002, 'Lỗi cập nhật AHN_DON (Sơ thẩm)');
--            END IF;
            
            -- AHN_SOTHAM_THULY
            -- backup
            UPDATE AHN_SOTHAM_THULY
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE AHN_SOTHAM_THULY
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID;
            
            -- Update AHN_DON_GIAIDOAN
            -- backup
            UPDATE AHN_DON_GIAIDOAN
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL AND MAGIAIDOAN = v_MAGIAIDOAN;

            UPDATE AHN_DON_GIAIDOAN
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID AND MAGIAIDOAN = v_MAGIAIDOAN;

            -- Update DON_CHITIET
            -- backup
            UPDATE DON_CHITIET
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND LOAIANID = 3 AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE DON_CHITIET
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND LOAIANID = 3 AND TOAANID = v_TOAANID;

            -- Update AHN_TONGDAT
            -- backup
            UPDATE AHN_TONGDAT
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE AHN_TONGDAT
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID;

            -- Update DON_KHAC
            -- backup
            UPDATE DON_KHAC
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND LOAIANID = 3 AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE DON_KHAC
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND LOAIANID = 3 AND TOAANID = v_TOAANID;

            -- Update AHN_DON_XULY
            -- backup
            UPDATE AHN_DON_XULY
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE AHN_DON_XULY
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID;  

            -- Update AHN_SOTHAM_BANAN
            -- backup
            UPDATE AHN_SOTHAM_BANAN
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE AHN_SOTHAM_BANAN
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID; 

            -- Update AHN_SOTHAM_QUYETDINH
            -- backup
            UPDATE AHN_SOTHAM_QUYETDINH
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE AHN_SOTHAM_QUYETDINH
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID;  
            
            -- Update AHN_SOTHAM_QUYETDINH
            -- Theo TOACHUYENID 
            -- backup
            UPDATE AHN_CHUYEN_NHAN_AN
            SET TOA_GIAIQUYET_ID = TOACHUYENID
            WHERE VUANID = p_VUVIECID AND TOACHUYENID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE AHN_CHUYEN_NHAN_AN 
            SET TOACHUYENID = p_TOAANNHANID 
            WHERE VUANID = p_VUVIECID AND TOACHUYENID = v_TOAANID;
            
            -- Theo TOANHANID
            -- backup
            UPDATE AHN_CHUYEN_NHAN_AN
            SET TOA_GIAIQUYET_NHAN_ID = TOANHANID
            WHERE VUANID = p_VUVIECID AND TOANHANID = v_TOAANID AND TOA_GIAIQUYET_NHAN_ID IS NULL;

            UPDATE AHN_CHUYEN_NHAN_AN
            SET TOANHANID = p_TOAANNHANID
            WHERE VUANID = p_VUVIECID AND TOANHANID = v_TOAANID;

            -- Với trường hợp chuyển ST -> ST, sau khi chuyển án tạm đình chỉ
            UPDATE AHN_CHUYEN_NHAN_AN
      			SET
      				TOA_GIAIQUYET_NHAN_ID = TOANHANID,
      				TOANHANID = p_TOAANNHANID
      			WHERE
      				VUANID in (
        				SELECT CNA.MAP_VUANID_NEW
        				FROM AHN_CHUYEN_NHAN_AN CNA
        				WHERE CNA.VUANID = p_VUVIECID AND CNA.MAP_VUANID_NEW IS NOT NULL
              );

            -- Với trường hợp chuyển ST -> ST, sau khi chuyển án không đủ thẩm quyền xét xử
            UPDATE AHN_CHUYEN_NHAN_AN
      			SET
      				TOA_GIAIQUYET_NHAN_ID = TOANHANID,
      				TOANHANID = p_TOAANNHANID
      			WHERE
      				MAP_VUANID_NEW = p_VUVIECID AND MAP_VUANID_NEW IS NOT NULL;
            
        ELSIF v_MAGIAIDOAN IN (3,7) THEN
            -- PHÚC THẨM

            -- Update AHN_DON
            -- backup
            UPDATE AHN_DON
            SET TOA_PHUCTHAM_GIAIQUYET_ID = TOAPHUCTHAMID
            WHERE ID = p_VUVIECID AND TOAPHUCTHAMID = v_TOAPHUCTHAMID AND TOA_PHUCTHAM_GIAIQUYET_ID IS NULL;

            UPDATE AHN_DON
            SET TOAPHUCTHAMID = p_TOAANNHANID
            WHERE ID = p_VUVIECID AND TOAPHUCTHAMID = v_TOAPHUCTHAMID;

            -- backup
            UPDATE AHN_DON
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE ID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE AHN_DON
            SET TOAANID = p_TOAANNHANID
            WHERE ID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID;

            -- Kiểm tra xem có update được chính xác 1 bản ghi AHN_DON hay không
--            IF SQL%ROWCOUNT != 1 THEN
--                ROLLBACK;
--                RAISE_APPLICATION_ERROR(-20003, 'Lỗi cập nhật AHN_DON (Phúc thẩm)');
--            END IF;
            
            -- Update AHN_PHUCTHAM_THULY
            -- backup
            UPDATE AHN_PHUCTHAM_THULY
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE AHN_PHUCTHAM_THULY
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID  AND TOAANID = v_TOAPHUCTHAMID;
            
            -- Update AHN_DON_GIAIDOAN
            -- backup
            UPDATE AHN_DON_GIAIDOAN
            SET TOA_PHUCTHAM_GIAIQUYET_ID = TOAPHUCTHAMID
            WHERE DONID = p_VUVIECID AND TOAPHUCTHAMID = v_TOAPHUCTHAMID AND TOA_PHUCTHAM_GIAIQUYET_ID IS NULL AND MAGIAIDOAN = v_MAGIAIDOAN;

            UPDATE AHN_DON_GIAIDOAN
            SET TOAPHUCTHAMID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAPHUCTHAMID = v_TOAPHUCTHAMID AND MAGIAIDOAN = v_MAGIAIDOAN;

            -- backup
            UPDATE AHN_DON_GIAIDOAN
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE AHN_DON_GIAIDOAN
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID;
            
            -- UPDATE AHN_KCKNQDK_PHUCTHAM_QUYETDINH
            -- backup
            UPDATE AHN_KCKNQDK_PHUCTHAM_QUYETDINH
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE AHN_KCKNQDK_PHUCTHAM_QUYETDINH
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID;
            
            -- UPDATE AHN_KCKNQDK_PHUCTHAM_THULY
            -- backup
            UPDATE AHN_KCKNQDK_PHUCTHAM_THULY
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE AHN_KCKNQDK_PHUCTHAM_THULY
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID;
            
            -- UPDATE AHN_PHUCTHAM_BANAN
            -- backup
            UPDATE AHN_PHUCTHAM_BANAN
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE AHN_PHUCTHAM_BANAN
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID;
            
            -- UPDATE AHN_PHUCTHAM_QUYETDINH
            -- backup
            UPDATE AHN_PHUCTHAM_QUYETDINH
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE AHN_PHUCTHAM_QUYETDINH
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID;

            -- Update AHN_TONGDAT
            -- backup
            UPDATE AHN_TONGDAT
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE AHN_TONGDAT
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID;

            -- Update DON_KHAC
            -- backup
            UPDATE DON_KHAC
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND LOAIANID = 3 AND TOAANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE DON_KHAC
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND LOAIANID = 3 AND TOAANID = v_TOAPHUCTHAMID;

            -- Update HOSO_PT
            -- backup
            UPDATE HOSO_PT
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE VUANID = p_VUVIECID AND LOAIAN = 3 AND TOAANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE HOSO_PT
            SET TOAANID = p_TOAANNHANID
            WHERE VUANID = p_VUVIECID AND LOAIAN = 3 AND TOAANID = v_TOAPHUCTHAMID;

            -- Update HOSO_PT
            -- backup
            UPDATE HOSO_PT
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE VUANID = p_VUVIECID AND LOAIAN = 3 AND TOAANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE HOSO_PT
            SET TOAANID = p_TOAANNHANID
            WHERE VUANID = p_VUVIECID AND LOAIAN = 3 AND TOAANID = v_TOAPHUCTHAMID;
            
            IF (v_MAGIAIDOAN = 7) THEN
              -- Update AHN_CHUYEN_NHAN_AN
              -- Theo TOACHUYENID 
              -- backup
	           	UPDATE AHN_CHUYEN_NHAN_AN 
	            SET TOA_GIAIQUYET_ID = TOACHUYENID
	            WHERE MAP_VUANID_NEW = p_VUVIECID AND TOACHUYENID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

              UPDATE AHN_CHUYEN_NHAN_AN 
	            SET TOACHUYENID = p_TOAANNHANID 
	            WHERE MAP_VUANID_NEW = p_VUVIECID AND TOACHUYENID = v_TOAPHUCTHAMID;
	            
              -- Theo TOANHANID 
              -- backup
	           	UPDATE AHN_CHUYEN_NHAN_AN 
	            SET TOA_GIAIQUYET_NHAN_ID = TOANHANID
	            WHERE MAP_VUANID_NEW = p_VUVIECID AND TOANHANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_NHAN_ID IS NULL;

	            UPDATE AHN_CHUYEN_NHAN_AN
	            SET TOANHANID = p_TOAANNHANID
	            WHERE MAP_VUANID_NEW = p_VUVIECID AND TOANHANID = v_TOAPHUCTHAMID;
           ELSE
	            -- Update AHN_CHUYEN_NHAN_AN
              -- Theo TOACHUYENID 
              -- backup
	           	UPDATE AHN_CHUYEN_NHAN_AN 
	            SET TOA_GIAIQUYET_ID = TOACHUYENID
	            WHERE VUANID = p_VUVIECID AND TOACHUYENID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

              UPDATE AHN_CHUYEN_NHAN_AN 
	            SET TOACHUYENID = p_TOAANNHANID 
	            WHERE VUANID = p_VUVIECID AND TOACHUYENID = v_TOAPHUCTHAMID;
	            
              -- Theo TOANHANID 
              -- backup
	           	UPDATE AHN_CHUYEN_NHAN_AN 
	            SET TOA_GIAIQUYET_NHAN_ID = TOANHANID
	            WHERE VUANID = p_VUVIECID AND TOANHANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_NHAN_ID IS NULL;

	            UPDATE AHN_CHUYEN_NHAN_AN
	            SET TOANHANID = p_TOAANNHANID
	            WHERE VUANID = p_VUVIECID AND TOANHANID = v_TOAPHUCTHAMID;
           END IF;
            
        END IF;
        
        -- Update TRANGTHAI cho VUAN_BANGIAO_MAPPING
        UPDATE VUAN_BANGIAO_MAPPING
        SET TRANGTHAI = 'TTBG_DANHAN',
            NGAYNHAN = p_NGAYNHAN
        WHERE ID = p_ID;
        
        COMMIT;
        
    EXCEPTION
      WHEN OTHERS THEN
          -- Rollback in case of any exception
          ROLLBACK;

          v_output := 'Finish procedure Due to Exception: Error:' || SQLCODE || ',' || SQLERRM;
          PKG_TRACELOG.SP_INSERT_LOG_ERROR(
              p_functionname => 'PKG_BAN_GIAO_AN.AHN_VUAN_BANGIAO_MAPPING_NHAN',
              p_description => v_output,
              p_notes => v_tracedata
          );

          -- Re-raise the exception
          RAISE;
    END AHN_VUAN_BANGIAO_MAPPING_NHAN;

    -- [AHN] KIỂM TRA THAY ĐỔI
    PROCEDURE AHN_VUAN_BANGIAO_MAPPING_KTTHAYDOI (
        p_ID IN NUMBER,
        p_result OUT NUMBER,
        p_message OUT VARCHAR2
    )
    AS
        v_VUVIECID NUMBER;
        v_TOAANNHANID NUMBER;
        v_NGANHAN DATE;
        v_count NUMBER;
    BEGIN
        -- Khởi tạo giá trị mặc định
        p_result := 0;
        p_message := '';

        -- Lấy thông tin Mapping
        SELECT VUVIECID, TOAANNHANID, NGAYNHAN
        INTO  v_VUVIECID, v_TOAANNHANID, v_NGANHAN
        FROM VUAN_BANGIAO_MAPPING
        WHERE ID = p_ID AND TRANGTHAI = 'TTBG_DANHAN';
        
        -- Kiểm tra các bảng có thay đổi sau ngày nhận án
        
        -- Kiểm tra AHN_ANPHI
        SELECT COUNT(*) INTO v_count 
        FROM AHN_ANPHI 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN)
          AND SOBIENLAI IS NOT NULL AND TAMUNGANPHI IS NOT NULL AND NGUOINHANID IS NOT NULL;
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin án phí đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra AHN_CHUYEN_NHAN_AN
        SELECT COUNT(*) INTO v_count 
        FROM AHN_CHUYEN_NHAN_AN 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin chuyển nhận án đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra AHN_DON_DUONGSU
        SELECT COUNT(*) INTO v_count 
        FROM AHN_DON_DUONGSU 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin đương sự đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra AHN_DON_GIAIDOAN
        SELECT COUNT(*) INTO v_count 
        FROM AHN_DON_GIAIDOAN 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin giai đoạn đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra AHN_DON_TAILIEU
        SELECT COUNT(*) INTO v_count 
        FROM AHN_DON_TAILIEU 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin tài liệu đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra AHN_DON_THAMGIATOTUNG
        SELECT COUNT(*) INTO v_count 
        FROM AHN_DON_THAMGIATOTUNG 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin tham gia tố tụng đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra AHN_DON_THAMPHAN
        SELECT COUNT(*) INTO v_count 
        FROM AHN_DON_THAMPHAN 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin thẩm phán đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra AHN_DON_XULY
        SELECT COUNT(*) INTO v_count 
        FROM AHN_DON_XULY 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin xử lý đơn đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHN_FILE
--        SELECT COUNT(*) INTO v_count 
--        FROM AHN_FILE 
--        WHERE DONID = v_VUVIECID 
--          AND (NGAYTAO >= v_NGANHAN);
--        
--        IF v_count > 0 THEN
--            p_result := 1;
--            p_message := 'Thông tin đơn đã có thay đổi, không thể trả án.';
--            RETURN;
--        END IF;

        -- Kiểm tra AHN_KCKNQDK_PHUCTHAM_HDXX
        SELECT COUNT(*) INTO v_count 
        FROM AHN_KCKNQDK_PHUCTHAM_HDXX 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin HĐXX KCKNQDK phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHN_KCKNQDK_PHUCTHAM_QUYETDINH
        SELECT COUNT(*) INTO v_count 
        FROM AHN_KCKNQDK_PHUCTHAM_QUYETDINH 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin quyết định KCKNQDK phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHN_KCKNQDK_PHUCTHAM_THAMGIATOTUNG
        SELECT COUNT(*) INTO v_count 
        FROM AHN_KCKNQDK_PHUCTHAM_THAMGIATOTUNG 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin tham gia tố tụng KCKNQDK phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHN_KCKNQDK_PHUCTHAM_THULY
        SELECT COUNT(*) INTO v_count 
        FROM AHN_KCKNQDK_PHUCTHAM_THULY 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin thụ lý KCKNQDK phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra AHN_PHUCTHAM_BANAN
        SELECT COUNT(*) INTO v_count 
        FROM AHN_PHUCTHAM_BANAN 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin bản án phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra AHN_PHUCTHAM_BANAN_FILE
        SELECT COUNT(*) INTO v_count 
        FROM AHN_PHUCTHAM_BANAN_FILE f
        WHERE EXISTS (
            SELECT 1 FROM AHN_PHUCTHAM_BANAN b 
            WHERE b.DONID = v_VUVIECID AND b.ID = f.BANANID
        ) AND f.NGAYTAO >= v_NGANHAN;
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin bản án phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra AHN_PHUCTHAM_BANAN_TGTT
--        SELECT COUNT(*) INTO v_count 
--        FROM AHN_PHUCTHAM_BANAN_TGTT 
--        WHERE DONID = v_VUVIECID AND NGAYNHANBANAN >= v_NGANHAN;
--        
--        IF v_count > 0 THEN
--            p_result := 1;
--            p_message := 'Thông tin bản án phúc thẩm đã có thay đổi, không thể trả án.';
--            RETURN;
--        END IF;

         -- Kiểm tra AHN_PHUCTHAM_DUONGSU
--        SELECT COUNT(*) INTO v_count 
--        FROM AHN_PHUCTHAM_DUONGSU 
--        WHERE DONID = v_VUVIECID 
--          AND (NGAYTAO >= v_NGANHAN);
        
--        IF v_count > 0 THEN
--            p_result := 1;
--            p_message := 'Thông tin HĐXX phúc thẩm đã có thay đổi, không thể trả án.';
--            RETURN;
--        END IF;
        
        -- Kiểm tra AHN_PHUCTHAM_HDXX
        SELECT COUNT(*) INTO v_count 
        FROM AHN_PHUCTHAM_HDXX 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin HĐXX phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra AHN_PHUCTHAM_HOAGIAI
        SELECT COUNT(*) INTO v_count 
        FROM AHN_PHUCTHAM_HOAGIAI 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin hoà giải phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHN_PHUCTHAM_QUYETDINH
        SELECT COUNT(*) INTO v_count 
        FROM AHN_PHUCTHAM_QUYETDINH 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin quyết định phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHN_PHUCTHAM_THAMGIATOTUNG
        SELECT COUNT(*) INTO v_count 
        FROM AHN_PHUCTHAM_THAMGIATOTUNG 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin tham gia tố tụng phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHN_PHUCTHAM_THULY
        SELECT COUNT(*) INTO v_count 
        FROM AHN_PHUCTHAM_THULY 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin thụ lý phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHN_SAUXETXU
--        SELECT COUNT(*) INTO v_count 
--        FROM AHN_SAUXETXU 
--        WHERE VUANID = v_VUVIECID 
--          AND (NGAYTAO >= v_NGANHAN);
--        
--        IF v_count > 0 THEN
--            p_result := 1;
--            p_message := 'Thông tin sau xét xử đã có thay đổi, không thể trả án.';
--            RETURN;
--        END IF;

        -- Kiểm tra AHN_SOTHAM_BANAN
        SELECT COUNT(*) INTO v_count 
        FROM AHN_SOTHAM_BANAN 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin bản án sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHN_SOTHAM_BANAN_ANPHI
        SELECT COUNT(*) INTO v_count 
        FROM AHN_SOTHAM_BANAN_ANPHI 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin án phí bản án sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHN_SOTHAM_BANAN_DIEULUAT
        SELECT COUNT(*) INTO v_count 
        FROM AHN_SOTHAM_BANAN_DIEULUAT 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin điều luật bản án sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHN_SOTHAM_BANAN_FILE
        SELECT COUNT(*) INTO v_count 
        FROM AHN_SOTHAM_BANAN_FILE 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin đơn bản án sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHN_SOTHAM_BANAN_TGTT
--        SELECT COUNT(*) INTO v_count 
--        FROM AHN_SOTHAM_BANAN_TGTT 
--        WHERE DONID = v_VUVIECID 
--          AND (NGAYTAO >= v_NGANHAN);
--        
--        IF v_count > 0 THEN
--            p_result := 1;
--            p_message := 'Thông tin đơn bản án sơ thẩm có thay đổi, không thể trả án.';
--            RETURN;
--        END IF;

        -- Kiểm tra AHN_SOTHAM_HDXX
        SELECT COUNT(*) INTO v_count 
        FROM AHN_SOTHAM_HDXX 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin HĐXX sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHN_SOTHAM_HOAGIAI
        SELECT COUNT(*) INTO v_count 
        FROM AHN_SOTHAM_HOAGIAI 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin hoà giải sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHN_SOTHAM_KHANGCAO
        SELECT COUNT(*) INTO v_count 
        FROM AHN_SOTHAM_KHANGCAO 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin kháng cáo sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

         -- Kiểm tra AHN_SOTHAM_KHANGNGHI
        SELECT COUNT(*) INTO v_count 
        FROM AHN_SOTHAM_KHANGNGHI 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin kháng nghị sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

         -- Kiểm tra AHN_SOTHAM_QUYETDINH
        SELECT COUNT(*) INTO v_count 
        FROM AHN_SOTHAM_QUYETDINH 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin quyết định sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

         -- Kiểm tra AHN_SOTHAM_RUTKCKN
        SELECT COUNT(*) INTO v_count 
        FROM AHN_SOTHAM_RUTKCKN 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin rút KCKN sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

--        -- Kiểm tra AHN_SOTHAM_THAMGIATOTUNG
--        SELECT COUNT(*) INTO v_count 
--        FROM AHN_SOTHAM_THAMGIATOTUNG 
--        WHERE DONID = v_VUVIECID 
--          AND (NGAYTAO >= v_NGANHAN);
--        
--        IF v_count > 0 THEN
--            p_result := 1;
--            p_message := 'Thông tin tham gia TT sơ thẩm có thay đổi, không thể trả án.';
--            RETURN;
--        END IF;

          -- Kiểm tra AHN_SOTHAM_THULY
        SELECT COUNT(*) INTO v_count 
        FROM AHN_SOTHAM_THULY 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin thụ lý sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

          -- Kiểm tra AHN_TONGDAT
        SELECT COUNT(*) INTO v_count 
        FROM AHN_TONGDAT 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin tống đạt có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHN_TONGDAT_DOITUONG
        SELECT COUNT(*) INTO v_count 
        FROM AHN_TONGDAT_DOITUONG f
        WHERE EXISTS (
            SELECT 1 FROM AHN_TONGDAT b 
            WHERE b.DONID = v_VUVIECID AND b.ID = f.TONGDATID
        ) 
          AND f.NGAYTAO >= v_NGANHAN;
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin đối tượng tống đạt đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHN_TRUNGCAU_GIAMDINH
        SELECT COUNT(*) INTO v_count 
        FROM AHN_TRUNGCAU_GIAMDINH 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin trưng cầu giám định có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHN_XULY_VIPHAMHC
        SELECT COUNT(*) INTO v_count 
        FROM AHN_XULY_VIPHAMHC 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin xử lý vi phạm HC có thay đổi, không thể trả án.';
            RETURN;
        END IF;
                
        -- Kiểm tra DON_KHAC
        SELECT COUNT(*) INTO v_count 
        FROM DON_KHAC 
        WHERE DONID = v_VUVIECID 
          AND (NGAYNHANDON >= v_NGANHAN OR NGAYKHANGCAO >= v_NGANHAN) 
          AND LOAIANID = 3;
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin đơn đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra DON_KHAC_YEUCAU
        SELECT COUNT(*) INTO v_count 
        FROM DON_KHAC_YEUCAU y
        WHERE EXISTS (
            SELECT 1 FROM DON_KHAC d 
            WHERE d.DONID = v_VUVIECID 
              AND d.ID = y.DONKHACID
        ) AND (y.NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin đơn đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra DON_CHITIET
        SELECT COUNT(*) INTO v_count 
        FROM DON_CHITIET 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN) 
          AND LOAIANID = 3;
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin đơn đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra DON_DUONGSU_CHITIET
        SELECT COUNT(*) INTO v_count 
        FROM DON_DUONGSU_CHITIET 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN)
          AND LOAIAN = 3;
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin đương sự đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra HOSO_PT
        SELECT COUNT(*) INTO v_count 
        FROM HOSO_PT 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN)
          AND LOAIAN = 3;
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin hồ sơ phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
      EXCEPTION
          WHEN OTHERS THEN
              p_result := 1;
              p_message := 'Lỗi khi kiểm tra: ' || SQLERRM;
  END AHN_VUAN_BANGIAO_MAPPING_KTTHAYDOI;

    -- [AHN] TRẢ LẠI
    PROCEDURE AHN_VUAN_BANGIAO_MAPPING_TRALAI (
        p_ID IN NUMBER
    ) AS
        v_VUVIECID NUMBER;
        v_MAGIAIDOAN NUMBER;
        v_TOAANGIAOID NUMBER;
        v_TOAANNHANID NUMBER;

        v_tracedata VARCHAR2(1024);
        v_output VARCHAR2(512);
    BEGIN
        v_tracedata := '(' || 
         'p_ID => ' || p_ID || ',' ||
         ' );';

        -- Lấy thông tin Mapping
        SELECT VUVIECID, TOAANGIAOID, TOAANNHANID, MAGIAIDOAN
        INTO  v_VUVIECID, v_TOAANGIAOID, v_TOAANNHANID, v_MAGIAIDOAN
        FROM VUAN_BANGIAO_MAPPING
        WHERE ID = p_ID AND TRANGTHAI = 'TTBG_DANHAN';

        -- Xoá thông tin AN_DA_KET_THUC cho giai đoạn
        UPDATE AHN_DON_GIAIDOAN
        SET AN_DA_KET_THUC = NULL
        WHERE DONID = v_VUVIECID AND MAGIAIDOAN = v_MAGIAIDOAN AND (TOA_GIAIQUYET_ID = v_TOAANGIAOID OR TOA_PHUCTHAM_GIAIQUYET_ID = v_TOAANGIAOID);

        -- Xử lý cập nhật theo giai đoạn
        IF v_MAGIAIDOAN = 2 THEN
            -- SƠ THẨM
            -- Update AHN_DON
            UPDATE AHN_DON
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE ID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update AHN_SOTHAM_THULY
            UPDATE AHN_SOTHAM_THULY
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
            
            -- Update AHN_DON_GIAIDOAN
            UPDATE AHN_DON_GIAIDOAN
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update DON_CHITIET
            UPDATE DON_CHITIET
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND LOAIANID = 3 AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update AHN_TONGDAT
            UPDATE AHN_TONGDAT
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update DON_KHAC
            UPDATE DON_KHAC
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND LOAIANID = 3 AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update AHN_DON_XULY
            UPDATE AHN_DON_XULY
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update AHN_SOTHAM_BANAN
            UPDATE AHN_SOTHAM_BANAN
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update AHN_SOTHAM_QUYETDINH
            UPDATE AHN_SOTHAM_QUYETDINH
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update AHN_CHUYEN_NHAN_AN
            -- Theo TOACHUYENID 
            UPDATE AHN_CHUYEN_NHAN_AN 
            SET TOACHUYENID = TOA_GIAIQUYET_ID 
            WHERE VUANID = v_VUVIECID AND TOACHUYENID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
            
            -- Theo TOANHANID
            UPDATE AHN_CHUYEN_NHAN_AN
            SET TOANHANID = TOA_GIAIQUYET_NHAN_ID
            WHERE VUANID = v_VUVIECID AND TOANHANID = v_TOAANNHANID AND TOA_GIAIQUYET_NHAN_ID = v_TOAANGIAOID;

            -- Với trường hợp chuyển ST -> ST, sau khi chuyển án tạm đình chỉ
          	UPDATE AHN_CHUYEN_NHAN_AN
            SET TOANHANID = TOA_GIAIQUYET_NHAN_ID
			      WHERE VUANID in (SELECT CNA.MAP_VUANID_NEW
				                     FROM AHN_CHUYEN_NHAN_AN CNA
                             WHERE CNA.VUANID = v_VUVIECID AND CNA.MAP_VUANID_NEW IS NOT NULL);

            -- Với trường hợp chuyển ST -> ST, sau khi chuyển án không đủ thẩm quyền xét xử
            UPDATE AHN_CHUYEN_NHAN_AN
      			SET
      				TOANHANID = TOA_GIAIQUYET_NHAN_ID
      			WHERE
      				MAP_VUANID_NEW = v_VUVIECID AND MAP_VUANID_NEW IS NOT NULL;

        ELSIF v_MAGIAIDOAN IN (3,7) THEN
            -- PHÚC THẨM

            -- Update AHN_DON
            UPDATE AHN_DON
            SET TOAPHUCTHAMID = TOA_PHUCTHAM_GIAIQUYET_ID
            WHERE ID = v_VUVIECID AND TOAPHUCTHAMID = v_TOAANNHANID AND TOA_PHUCTHAM_GIAIQUYET_ID = v_TOAANGIAOID;

            UPDATE AHN_DON
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE ID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update AHN_PHUCTHAM_THULY
            UPDATE AHN_PHUCTHAM_THULY
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update AHN_DON_GIAIDOAN
            UPDATE AHN_DON_GIAIDOAN
            SET TOAPHUCTHAMID = TOA_PHUCTHAM_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAPHUCTHAMID = v_TOAANNHANID AND TOA_PHUCTHAM_GIAIQUYET_ID = v_TOAANGIAOID;

            UPDATE AHN_DON_GIAIDOAN
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- UPDATE AHN_KCKNQDK_PHUCTHAM_QUYETDINH
            UPDATE AHN_KCKNQDK_PHUCTHAM_QUYETDINH
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
            
            -- UPDATE AHN_KCKNQDK_PHUCTHAM_THULY
            UPDATE AHN_KCKNQDK_PHUCTHAM_THULY
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
            
            -- UPDATE AHN_PHUCTHAM_BANAN
            UPDATE AHN_PHUCTHAM_BANAN
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
            
            -- UPDATE AHN_PHUCTHAM_QUYETDINH
            UPDATE AHN_PHUCTHAM_QUYETDINH
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update AHN_TONGDAT
            UPDATE AHN_TONGDAT
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update DON_CHITIET
            UPDATE DON_CHITIET
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND LOAIANID = 3 AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update DON_KHAC
            UPDATE DON_KHAC
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND LOAIANID = 3 AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update HOSO_PT
            UPDATE HOSO_PT
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE VUANID = v_VUVIECID AND LOAIAN = 3 AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
            
            IF (v_MAGIAIDOAN = 7) THEN
              -- Update ADS_CHUYEN_NHAN_AN
              -- Theo TOACHUYENID 
              UPDATE AHN_CHUYEN_NHAN_AN 
	            SET TOACHUYENID = TOA_GIAIQUYET_ID 
	            WHERE MAP_VUANID_NEW = v_VUVIECID AND TOACHUYENID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
	            
              -- Theo TOANHANID 
	            UPDATE AHN_CHUYEN_NHAN_AN
	            SET TOANHANID = TOA_GIAIQUYET_NHAN_ID
	            WHERE MAP_VUANID_NEW = v_VUVIECID AND TOANHANID = v_TOAANNHANID AND TOA_GIAIQUYET_NHAN_ID = v_TOAANGIAOID;
           ELSE
	            -- Update ADS_CHUYEN_NHAN_AN
              -- Theo TOACHUYENID 
              UPDATE AHN_CHUYEN_NHAN_AN 
	            SET TOACHUYENID = TOA_GIAIQUYET_ID 
	            WHERE VUANID = v_VUVIECID AND TOACHUYENID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
	            
              -- Theo TOANHANID 
	            UPDATE AHN_CHUYEN_NHAN_AN
	            SET TOANHANID = TOA_GIAIQUYET_NHAN_ID
	            WHERE VUANID = v_VUVIECID AND TOANHANID = v_TOAANNHANID AND TOA_GIAIQUYET_NHAN_ID = v_TOAANGIAOID;
           END IF;
        END IF;
        
        -- Update TRANGTHAI cho VUAN_BANGIAO_MAPPING
        update VUAN_BANGIAO_MAPPING 
        SET TRANGTHAI = 'TTBG_CHONHAN'
        WHERE ID = p_ID;
        
        COMMIT;
        
    EXCEPTION
      WHEN OTHERS THEN
          -- Rollback in case of any exception
          ROLLBACK;

          v_output := 'Finish procedure Due to Exception: Error:' || SQLCODE || ',' || SQLERRM;
          PKG_TRACELOG.SP_INSERT_LOG_ERROR(
              p_functionname => 'PKG_BAN_GIAO_AN.AHN_VUAN_BANGIAO_MAPPING_TRALAI',
              p_description => v_output,
              p_notes => v_tracedata
          );

          -- Re-raise the exception
          RAISE;
    END AHN_VUAN_BANGIAO_MAPPING_TRALAI;
    

    -- [KDTM] LẤY DANH SÁCH CÓ THỂ BÀN GIAO
    PROCEDURE KDTM_VUAN_BANGIAO_MAPPING_GET_AN_BAN_GIAO (
         p_LOAIANID IN varchar2,
        p_TOAANID IN NUMBER,
        p_MAVUVIEC IN varchar2,
        p_THULYTUNGAY IN date,
        p_THULYDENNGAY IN date,
        p_TINHTRANGTHULY IN nvarchar2,
        p_THAMPHANGIAIQUYET IN nvarchar2,
        p_TENVUAN IN nvarchar2,    
        p_TRANGTHAIGIAIQUYET IN nvarchar2,    
        p_CAPXETXU IN nvarchar2,  
        p_TRANGTHAI IN NVARCHAR2,
        p_CURSOR OUT SYS_REFCURSOR
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
        V_TABLE_TIMKIEM             T_TIMKIEM_STPT_DS;
        
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
        
        FETCH_ID                VARCHAR2(255 CHAR);
        FETCH_MAVUVIEC          VARCHAR2(255 CHAR);
        FETCH_TENVUVIEC         VARCHAR2(4000 CHAR);
        FETCH_SOTHUTU           VARCHAR2(255 CHAR); 
        FETCH_NGAYNHANDON       VARCHAR2(255 CHAR);
        FETCH_HINHTHUCNHANDON   VARCHAR2(255 CHAR);
        FETCH_MAGIAIDOAN        VARCHAR2(255 CHAR);  
        FETCH_QHPLTKID          VARCHAR2(255 CHAR);
        FETCH_TOAANID           VARCHAR2(25 CHAR);
        FETCH_QUANHEPL          VARCHAR2(4000 CHAR);
        FETCH_BANAN_QD_ST       VARCHAR2(4000 CHAR);
        FETCH_QD_PT             VARCHAR2(4000 CHAR);
        FETCH_KHANGNGHI_ST      VARCHAR2(4000 CHAR);
        FETCH_CHECK_THULY       VARCHAR2(1000 CHAR);
        FETCH_HOTENBICAN        VARCHAR2(4000 CHAR);
        FETCH_COUNTALL          VARCHAR2(255 CHAR);
        FETCH_STT               VARCHAR2(1000 CHAR);
        FETCH_NGUOITAO          VARCHAR2(255 CHAR);
        FETCH_NGAY_TAO          VARCHAR2(255 CHAR);
        FETCH_NGAYTAO           VARCHAR2(255 CHAR);
        FETCH_TENTOASOTHAM      VARCHAR2(1000 CHAR);
        FETCH_GIAIDOANVUVIEC    VARCHAR2(255 CHAR);
        FETCH_TRUONGHOPGIAONHAN VARCHAR2(4000 CHAR);
        FETCH_KHANGCAO_ST       VARCHAR2(4000 CHAR);
        FETCH_TINHTRANG_GQ      VARCHAR2(4000 CHAR);
        FETCH_THULYXXLAI        VARCHAR2(1000 CHAR);
        FETCH_THAMPHANHG        VARCHAR2(4000 CHAR);  -- Cột thứ 27 cho AHN procedure
        FETCH_BAPT              VARCHAR2(1000 CHAR);  -- Cột thứ 18 cho AHN procedure TDC, QDK
        
        SUM_COUNTALL            NUMBER DEFAULT 0;
        CURSOR_RETURN           SYS_REFCURSOR;
        CURSOR_RETURN2           SYS_REFCURSOR;
        CURSOR_RETURN3           SYS_REFCURSOR;
        
        -- PROCESS_CURSOR: Xử lý cursor và capture COUNTALL từ record đầu tiên
        PROCEDURE PROCESS_CURSOR(P_CUR IN SYS_REFCURSOR, P_TYPE VARCHAR2, P_VAR NUMBER, P_TOAANID VARCHAR2) IS
            V_IS_FIRST_RECORD BOOLEAN := TRUE;
        BEGIN
            LOOP
                BEGIN
                    IF P_VAR = 1 THEN
                        -- FETCH cho DON_SEARCH_PTQDK (23 cột, thứ tự: STT, COUNTALL, ID, MAVUVIEC...)
                        FETCH P_CUR INTO FETCH_STT, FETCH_COUNTALL, FETCH_ID, FETCH_MAVUVIEC, 
                          FETCH_TENVUVIEC, FETCH_SOTHUTU, FETCH_NGAYNHANDON, FETCH_NGUOITAO, 
                          FETCH_NGAYTAO, FETCH_QUANHEPL, FETCH_TENTOASOTHAM, FETCH_GIAIDOANVUVIEC,
                          FETCH_HINHTHUCNHANDON, FETCH_TRUONGHOPGIAONHAN, FETCH_BANAN_QD_ST, 
                          FETCH_KHANGNGHI_ST, FETCH_KHANGCAO_ST, FETCH_BAPT, FETCH_QD_PT, FETCH_MAGIAIDOAN,
                          FETCH_HOTENBICAN, FETCH_TINHTRANG_GQ, FETCH_CHECK_THULY, FETCH_THULYXXLAI;
                    
                        EXIT WHEN P_CUR%NOTFOUND;
                        
                        -- Capture COUNTALL từ record đầu tiên của procedure 2
                        IF V_IS_FIRST_RECORD THEN
                            V_COUNTALL_PROC2 := TO_NUMBER(FETCH_COUNTALL);
                            V_IS_FIRST_RECORD := FALSE;
                        END IF;
                        
                        -- Gán giá trị cho các trường bị thiếu
                        FETCH_QHPLTKID := '';
                        FETCH_TOAANID := P_TOAANID;
                        FETCH_NGAY_TAO := FETCH_NGAYTAO;
                    ELSE
                        -- FETCH cho ADS_DON_SEARCH_TURNING (26 cột, thứ tự: ID, MAVUVIEC...)
                        FETCH P_CUR INTO FETCH_ID, FETCH_MAVUVIEC, FETCH_TENVUVIEC, FETCH_SOTHUTU, 
                          FETCH_NGAYNHANDON, FETCH_HINHTHUCNHANDON, FETCH_MAGIAIDOAN, FETCH_QHPLTKID,
                          FETCH_TOAANID, FETCH_QUANHEPL, FETCH_BANAN_QD_ST, FETCH_QD_PT,
                          FETCH_KHANGNGHI_ST, FETCH_CHECK_THULY, FETCH_HOTENBICAN, FETCH_COUNTALL, 
                          FETCH_STT, FETCH_NGAY_TAO, FETCH_NGUOITAO, FETCH_NGAYTAO, FETCH_TENTOASOTHAM, 
                          FETCH_GIAIDOANVUVIEC, FETCH_TRUONGHOPGIAONHAN, FETCH_KHANGCAO_ST,
                          FETCH_TINHTRANG_GQ, FETCH_THULYXXLAI, FETCH_THAMPHANHG;
                    
                        EXIT WHEN P_CUR%NOTFOUND;
                        
                        -- Capture COUNTALL từ record đầu tiên của procedure 1
                        IF V_IS_FIRST_RECORD THEN
                            V_COUNTALL_PROC1 := TO_NUMBER(FETCH_COUNTALL);
                            V_IS_FIRST_RECORD := FALSE;
                        END IF;
                    END IF;
                    
                    -- Phần xử lý chung vẫn giữ nguyên
                    V_TABLE_TIMKIEM.EXTEND;
                    V_TABLE_TIMKIEM(V_TABLE_TIMKIEM.COUNT) := R_TIMKIEM_STPT_DS(
                        FETCH_ID, FETCH_MAVUVIEC, FETCH_TENVUVIEC, FETCH_SOTHUTU, FETCH_NGAYNHANDON, 
                        FETCH_HINHTHUCNHANDON, FETCH_MAGIAIDOAN, FETCH_QHPLTKID, FETCH_TOAANID, 
                        FETCH_QUANHEPL, FETCH_BANAN_QD_ST, FETCH_QD_PT, FETCH_KHANGNGHI_ST, 
                        FETCH_CHECK_THULY, FETCH_HOTENBICAN, FETCH_COUNTALL, FETCH_STT, FETCH_NGAY_TAO,
                        FETCH_NGUOITAO, FETCH_NGAYTAO, FETCH_TENTOASOTHAM, FETCH_GIAIDOANVUVIEC,
                        FETCH_TRUONGHOPGIAONHAN, FETCH_KHANGCAO_ST, FETCH_TINHTRANG_GQ, FETCH_THULYXXLAI, P_TYPE
                    );
                END;
            END LOOP;
        END PROCESS_CURSOR;
    BEGIN
        
        -- Set fixed pagesize for optimal performance
        V_PROCEDURE_PAGESIZE := V_OPTIMIZED_PAGESIZE;
        
        IF p_THULYTUNGAY IS NOT NULL THEN 
            V_THULYTUNGAY := TO_CHAR(p_THULYTUNGAY, 'DD/MM/YYYY');
        ELSE
            V_THULYTUNGAY := '';
        END IF;  
    
        IF p_THULYDENNGAY IS NOT NULL THEN  
            V_THULYDENNGAY := TO_CHAR(p_THULYDENNGAY, 'DD/MM/YYYY'); 
        ELSE
            V_THULYDENNGAY := '';
        END IF;

SELECT LOAITOA
  INTO V_CAP_XET_XU_LOGIN
  FROM DM_TOAAN
  WHERE 1 = 1
    AND ID = P_TOAANID;
        V_TABLE_TIMKIEM := T_TIMKIEM_STPT_DS();
        
        -- LOGIC XỬ LÝ THEO p_TRANGTHAI
        IF p_TRANGTHAI = 1 THEN
            -- TRANGTHAI = 1: Lấy dữ liệu từ các toà được bàn giao (bao gồm cả p_TOAANID gốc)
            FOR toaan_rec IN (
                SELECT p_TOAANID AS TOTOAANID FROM DUAL
                UNION ALL
                SELECT TOTOAANID FROM DM_TOAAN_TACH_NHAP_MAPPING WHERE TOAANID = p_TOAANID
            ) LOOP
                V_CURRENT_TOAANID := toaan_rec.TOTOAANID;
                V_TRANGTHAIGIAIQUYET := '';
                
                -- BƯỚC 1: Lấy dữ liệu từ procedure 1 với TOTOAANDI
                PKG_AKT_STPT_DS.AKT_DON_SEARCH_TURNING(
                    V_CAP_XET_XU_LOGIN, -- V_CAP_XET_XU_LOGIN
                    p_TENVUAN, -- V_TEN_VU_AN
                    NULL, -- V_QHPL
                    p_MAVUVIEC, -- V_MA_VU_AN
                    NULL, -- V_TENDUONGSU
                    p_CAPXETXU, -- V_CAPXX
                    V_CURRENT_TOAANID, -- V_TOAAN_ID
                    p_TINHTRANGTHULY, -- V_TINHTRANG_THULY
                    V_THULYTUNGAY, -- V_NGAYTHULY_TU
                    V_THULYDENNGAY, -- V_NGAYTHULY_DEN
                    NULL, -- V_SOTHULY
                    p_THAMPHANGIAIQUYET, -- V_THAMPHAN_ID
                    V_TRANGTHAIGIAIQUYET, -- V_TINHTRANG_GIAIQUYET
                    NULL, -- V_TUNGAY
                    NULL, -- V_DENNGAY
                    NULL, -- V_KETQUA
                    NULL, -- V_SO_QD
                    NULL, -- V_NGAY_QD
                    NULL, -- V_THUKY_ID
                    NULL, -- V_THOIHAN_GQ
                    NULL, -- V_LOAIDON
                    NULL, -- V_PT_RKINHNGHIEM
                    NULL, -- V_GQDON
                    NULL, -- V_UTTP
                    0, -- VCHECKTK
                    0, -- V_TRANGTHAIVUAN
                    NULL, -- V_VAITRO_THAMPHAN
                    1, -- V_LOAI_TBTL
                    1, -- V_MA_THONG_BAO
                    0, -- V_CHECK_HOAGIAI
                    0, -- V_HOAGIAI_TRANGTHAI
                    NULL, -- V_HOAGIAI_TUNGAY
                    NULL, -- V_HOAGIAI_DENNGAY
                    NULL, -- AN_DA_KET_THUC
                    1, -- PAGE_INDEX
                    V_PROCEDURE_PAGESIZE, -- PAGE_SIZE
                    CURSOR_RETURN -- CURRETURN
                );
                IF CURSOR_RETURN IS NOT NULL THEN
                    PROCESS_CURSOR(CURSOR_RETURN, '4', 0, V_CURRENT_TOAANID);
                    CLOSE CURSOR_RETURN;
                END IF;

                -- Không lấy án TĐC với cấp sơ thẩm
                IF p_CAPXETXU <> 2 THEN
                                                        
                  -- BƯỚC 2: Lấy dữ liệu từ procedure 2 với TOTOAANDI
  --                PKG_STPT_AKT_GS.DON_SEARCH(V_CAP_XET_XU_LOGIN,p_TENVUAN,NULL,p_MAVUVIEC,NULL,3,V_CURRENT_TOAANID,p_TINHTRANGTHULY,
  --                                                           V_THULYTUNGAY,V_THULYDENNGAY,NULL,p_THAMPHANGIAIQUYET,p_TRANGTHAIGIAIQUYET,NULL,NULL,NULL,
  --                                                           NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,1,NULL,0,0,NULL,NULL,
  --                                                           1, V_PROCEDURE_PAGESIZE, CURSOR_RETURN2);
                  PKG_STPT_AKT_GS.DON_SEARCH(
                      V_CAP_XET_XU_LOGIN,       -- 1. V_CAP_XET_XU_LOGIN
                      p_TENVUAN,                -- 2. V_TEN_VU_AN  
                      NULL,                     -- 3. V_QHPL
                      p_MAVUVIEC,              -- 4. V_MA_VU_AN
                      NULL,                     -- 5. V_TENDUONGSU
                      3,                        -- 6. V_CAPXX
                      V_CURRENT_TOAANID,       -- 7. V_TOAAN_ID
                      p_TINHTRANGTHULY,        -- 8. V_TINHTRANG_THULY
                      V_THULYTUNGAY,           -- 9. V_NGAYTHULY_TU
                      V_THULYDENNGAY,          -- 10. V_NGAYTHULY_DEN
                      NULL,                     -- 11. V_SOTHULY
                      p_THAMPHANGIAIQUYET,     -- 12. V_THAMPHAN_ID
                      p_TRANGTHAIGIAIQUYET,    -- 13. V_TINHTRANG_GIAIQUYET
                      NULL,                     -- 14. V_TUNGAY
                      NULL,                     -- 15. V_DENNGAY
                      NULL,                     -- 16. V_KETQUA
                      NULL,                     -- 17. V_SO_QD
                      NULL,                     -- 18. V_NGAY_QD
                      NULL,                     -- 19. V_THUKY_ID
                      NULL,                     -- 20. V_THOIHAN_GQ
                      NULL,                     -- 21. V_LOAIDON
                      NULL,                     -- 22. V_PT_RKINHNGHIEM
                      NULL,                     -- 23. V_GQDON
                      NULL,                     -- 24. V_UTTP
                      0,                        -- 25. VCHECKTK
                      0,                        -- 26. V_TRANGTHAIVUAN
                      NULL,                     -- 27. V_VAITRO_THAMPHAN
                      0,                        -- 28. V_CHECK_HOAGIAI
                      0,                        -- 29. V_HOAGIAI_TRANGTHAI
                      NULL,                     -- 30. V_HOAGIAI_TUNGAY
                      NULL,                     -- 31. V_HOAGIAI_DENNGAY
                      NULL, -- AN_DA_KET_THUC
                      1,                        -- 32. PAGE_INDEX
                      V_PROCEDURE_PAGESIZE,     -- 33. PAGE_SIZE
                      CURSOR_RETURN2            -- 34. CURRETURN (OUT)
                  );
                  
                  IF CURSOR_RETURN2 IS NOT NULL THEN
                      PROCESS_CURSOR(CURSOR_RETURN2, '4', 1, V_CURRENT_TOAANID);
                      CLOSE CURSOR_RETURN2;
                  END IF;
                  
                  -- Bước 3: lấy dữ liệu chưa thụ lý với TRANGTHAIGIAIQUYET = ''
--                  IF (NVL(LENGTH(p_TINHTRANGTHULY),0) = 0) OR p_TINHTRANGTHULY = '2' THEN
--                      V_TRANGTHAIGIAIQUYET := '';
--                      V_TINHTRANGTHULY := '2';
--                      
--                      PKG_STPT_AKT_GS.DON_SEARCH(
--                          V_CAP_XET_XU_LOGIN,       -- 1. V_CAP_XET_XU_LOGIN
--                          p_TENVUAN,                -- 2. V_TEN_VU_AN  
--                          NULL,                     -- 3. V_QHPL
--                          p_MAVUVIEC,              -- 4. V_MA_VU_AN
--                          NULL,                     -- 5. V_TENDUONGSU
--                          3,                        -- 6. V_CAPXX
--                          V_CURRENT_TOAANID,       -- 7. V_TOAAN_ID
--                          V_TINHTRANGTHULY,        -- 8. V_TINHTRANG_THULY
--                          V_THULYTUNGAY,           -- 9. V_NGAYTHULY_TU
--                          V_THULYDENNGAY,          -- 10. V_NGAYTHULY_DEN
--                          NULL,                     -- 11. V_SOTHULY
--                          p_THAMPHANGIAIQUYET,     -- 12. V_THAMPHAN_ID
--                          V_TRANGTHAIGIAIQUYET,    -- 13. V_TINHTRANG_GIAIQUYET
--                          NULL,                     -- 14. V_TUNGAY
--                          NULL,                     -- 15. V_DENNGAY
--                          NULL,                     -- 16. V_KETQUA
--                          NULL,                     -- 17. V_SO_QD
--                          NULL,                     -- 18. V_NGAY_QD
--                          NULL,                     -- 19. V_THUKY_ID
--                          NULL,                     -- 20. V_THOIHAN_GQ
--                          NULL,                     -- 21. V_LOAIDON
--                          NULL,                     -- 22. V_PT_RKINHNGHIEM
--                          NULL,                     -- 23. V_GQDON
--                          NULL,                     -- 24. V_UTTP
--                          0,                        -- 25. VCHECKTK
--                          0,                        -- 26. V_TRANGTHAIVUAN
--                          NULL,                     -- 27. V_VAITRO_THAMPHAN
--                          0,                        -- 28. V_CHECK_HOAGIAI
--                          0,                        -- 29. V_HOAGIAI_TRANGTHAI
--                          NULL,                     -- 30. V_HOAGIAI_TUNGAY
--                          NULL,                     -- 31. V_HOAGIAI_DENNGAY
--                          1,                        -- 32. PAGE_INDEX
--                          V_PROCEDURE_PAGESIZE,     -- 33. PAGE_SIZE
--                          CURSOR_RETURN3            -- 34. CURRETURN (OUT)
--                      );
--                      
--                      IF CURSOR_RETURN3 IS NOT NULL THEN
--                          PROCESS_CURSOR(CURSOR_RETURN3, '4', 1, V_CURRENT_TOAANID);
--                          CLOSE CURSOR_RETURN3;
--                      END IF;
--                  END IF;

                END IF;
            END LOOP;
        ELSE
            -- TRANGTHAI = 0 hoặc NULL: Logic cũ với p_TOAANID
            -- BƯỚC 1: Lấy dữ liệu + COUNTALL từ procedure 1 (chỉ 1 lần gọi)
            PKG_AKT_STPT_DS.AKT_DON_SEARCH_TURNING(
                V_CAP_XET_XU_LOGIN, -- V_CAP_XET_XU_LOGIN
                p_TENVUAN, -- V_TEN_VU_AN
                NULL, -- V_QHPL
                p_MAVUVIEC, -- V_MA_VU_AN
                NULL, -- V_TENDUONGSU
                p_CAPXETXU, -- V_CAPXX
                p_TOAANID, -- V_TOAAN_ID
                p_TINHTRANGTHULY, -- V_TINHTRANG_THULY
                V_THULYTUNGAY, -- V_NGAYTHULY_TU
                V_THULYDENNGAY, -- V_NGAYTHULY_DEN
                NULL, -- V_SOTHULY
                p_THAMPHANGIAIQUYET, -- V_THAMPHAN_ID
                p_TRANGTHAIGIAIQUYET, -- V_TINHTRANG_GIAIQUYET
                NULL, -- V_TUNGAY
                NULL, -- V_DENNGAY
                NULL, -- V_KETQUA
                NULL, -- V_SO_QD
                NULL, -- V_NGAY_QD
                NULL, -- V_THUKY_ID
                NULL, -- V_THOIHAN_GQ
                NULL, -- V_LOAIDON
                NULL, -- V_PT_RKINHNGHIEM
                NULL, -- V_GQDON
                NULL, -- V_UTTP
                0, -- VCHECKTK
                0, -- V_TRANGTHAIVUAN
                NULL, -- V_VAITRO_THAMPHAN
                1, -- V_LOAI_TBTL
                1, -- V_MA_THONG_BAO
                0, -- V_CHECK_HOAGIAI
                0, -- V_HOAGIAI_TRANGTHAI
                NULL, -- V_HOAGIAI_TUNGAY
                NULL, -- V_HOAGIAI_DENNGAY
                NULL, -- AN_DA_KET_THUC
                1, -- PAGE_INDEX
                V_PROCEDURE_PAGESIZE, -- PAGE_SIZE
                CURSOR_RETURN -- CURRETURN
            );
            
            IF CURSOR_RETURN IS NOT NULL THEN
                PROCESS_CURSOR(CURSOR_RETURN, '4', 0, p_TOAANID);
                CLOSE CURSOR_RETURN;
            END IF;

            -- Không lấy án TĐC với cấp sơ thẩm
            IF (P_CAPXETXU IS NULL OR p_CAPXETXU <> 2) THEN
                                                    
              -- BƯỚC 2: Lấy dữ liệu + COUNTALL từ procedure 2 (chỉ 1 lần gọi)
  --            PKG_STPT_AKT_GS.DON_SEARCH(V_CAP_XET_XU_LOGIN,p_TENVUAN,NULL,p_MAVUVIEC,NULL,3,p_TOAANID,p_TINHTRANGTHULY,
  --                                                       V_THULYTUNGAY,V_THULYDENNGAY,NULL,p_THAMPHANGIAIQUYET,p_TRANGTHAIGIAIQUYET,NULL,NULL,NULL,
  --                                                       NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,1,NULL,0,0,NULL,NULL,
  --                                                       1, V_PROCEDURE_PAGESIZE, CURSOR_RETURN2);
              PKG_STPT_AKT_GS.DON_SEARCH(
                  V_CAP_XET_XU_LOGIN,       -- 1. V_CAP_XET_XU_LOGIN
                  p_TENVUAN,                -- 2. V_TEN_VU_AN  
                  NULL,                     -- 3. V_QHPL
                  p_MAVUVIEC,              -- 4. V_MA_VU_AN
                  NULL,                     -- 5. V_TENDUONGSU
                  3,                        -- 6. V_CAPXX
                  p_TOAANID,       -- 7. V_TOAAN_ID
                  p_TINHTRANGTHULY,        -- 8. V_TINHTRANG_THULY
                  V_THULYTUNGAY,           -- 9. V_NGAYTHULY_TU
                  V_THULYDENNGAY,          -- 10. V_NGAYTHULY_DEN
                  NULL,                     -- 11. V_SOTHULY
                  p_THAMPHANGIAIQUYET,     -- 12. V_THAMPHAN_ID
                  p_TRANGTHAIGIAIQUYET,    -- 13. V_TINHTRANG_GIAIQUYET
                  NULL,                     -- 14. V_TUNGAY
                  NULL,                     -- 15. V_DENNGAY
                  NULL,                     -- 16. V_KETQUA
                  NULL,                     -- 17. V_SO_QD
                  NULL,                     -- 18. V_NGAY_QD
                  NULL,                     -- 19. V_THUKY_ID
                  NULL,                     -- 20. V_THOIHAN_GQ
                  NULL,                     -- 21. V_LOAIDON
                  NULL,                     -- 22. V_PT_RKINHNGHIEM
                  NULL,                     -- 23. V_GQDON
                  NULL,                     -- 24. V_UTTP
                  0,                        -- 25. VCHECKTK
                  0,                        -- 26. V_TRANGTHAIVUAN
                  NULL,                     -- 27. V_VAITRO_THAMPHAN
                  0,                        -- 28. V_CHECK_HOAGIAI
                  0,                        -- 29. V_HOAGIAI_TRANGTHAI
                  NULL,                     -- 30. V_HOAGIAI_TUNGAY
                  NULL,                     -- 31. V_HOAGIAI_DENNGAY
                  NULL, -- AN_DA_KET_THUC
                  1,                        -- 32. PAGE_INDEX
                  V_PROCEDURE_PAGESIZE,     -- 33. PAGE_SIZE
                  CURSOR_RETURN2            -- 34. CURRETURN (OUT)
              );
              
              IF CURSOR_RETURN2 IS NOT NULL THEN
                  PROCESS_CURSOR(CURSOR_RETURN2, '4', 1, p_TOAANID);
                  CLOSE CURSOR_RETURN2;
              END IF;
              
              -- Bước 3: lấy dữ liệu chưa thụ lý với TRANGTHAIGIAIQUYET = ''
              IF (NVL(LENGTH(p_TINHTRANGTHULY),0) = 0) OR p_TINHTRANGTHULY = '2' THEN
                  V_TRANGTHAIGIAIQUYET := '';
                  V_TINHTRANGTHULY := '2';
                  
                  PKG_STPT_AKT_GS.DON_SEARCH(
                      V_CAP_XET_XU_LOGIN,       -- 1. V_CAP_XET_XU_LOGIN
                      p_TENVUAN,                -- 2. V_TEN_VU_AN  
                      NULL,                     -- 3. V_QHPL
                      p_MAVUVIEC,              -- 4. V_MA_VU_AN
                      NULL,                     -- 5. V_TENDUONGSU
                      3,                        -- 6. V_CAPXX
                      p_TOAANID,       -- 7. V_TOAAN_ID
                      V_TINHTRANGTHULY,        -- 8. V_TINHTRANG_THULY
                      V_THULYTUNGAY,           -- 9. V_NGAYTHULY_TU
                      V_THULYDENNGAY,          -- 10. V_NGAYTHULY_DEN
                      NULL,                     -- 11. V_SOTHULY
                      p_THAMPHANGIAIQUYET,     -- 12. V_THAMPHAN_ID
                      V_TRANGTHAIGIAIQUYET,    -- 13. V_TINHTRANG_GIAIQUYET
                      NULL,                     -- 14. V_TUNGAY
                      NULL,                     -- 15. V_DENNGAY
                      NULL,                     -- 16. V_KETQUA
                      NULL,                     -- 17. V_SO_QD
                      NULL,                     -- 18. V_NGAY_QD
                      NULL,                     -- 19. V_THUKY_ID
                      NULL,                     -- 20. V_THOIHAN_GQ
                      NULL,                     -- 21. V_LOAIDON
                      NULL,                     -- 22. V_PT_RKINHNGHIEM
                      NULL,                     -- 23. V_GQDON
                      NULL,                     -- 24. V_UTTP
                      0,                        -- 25. VCHECKTK
                      0,                        -- 26. V_TRANGTHAIVUAN
                      NULL,                     -- 27. V_VAITRO_THAMPHAN
                      0,                        -- 28. V_CHECK_HOAGIAI
                      0,                        -- 29. V_HOAGIAI_TRANGTHAI
                      NULL,                     -- 30. V_HOAGIAI_TUNGAY
                      NULL,                     -- 31. V_HOAGIAI_DENNGAY
                      NULL, -- AN_DA_KET_THUC
                      1,                        -- 32. PAGE_INDEX
                      V_PROCEDURE_PAGESIZE,     -- 33. PAGE_SIZE
                      CURSOR_RETURN3            -- 34. CURRETURN (OUT)
                  );
                  
                  IF CURSOR_RETURN3 IS NOT NULL THEN
                      PROCESS_CURSOR(CURSOR_RETURN3, '4', 1, p_TOAANID);
                      CLOSE CURSOR_RETURN3;
                  END IF;
              END IF;

            END IF;
        END IF;
        
        -- BƯỚC 3: Tính tổng COUNTALL thực tế
        V_REAL_COUNTALL := V_COUNTALL_PROC1 + V_COUNTALL_PROC2;
            
        -- BƯỚC 4: Final query với DISTINCT để loại bỏ duplicate (bỏ STT)
        OPEN p_CURSOR FOR
SELECT DISTINCT V_REAL_COUNTALL AS COUNTALL,
                A.ID,
                A.MAVUVIEC,
                A.TENVUVIEC,
                A.SOTHUTU,
                A.NGAYNHANDON,
                A.HINHTHUCNHANDON,
                A.MAGIAIDOAN,
                A.QHPLTKID,
                A.TOAANID,
                A.QUANHEPL,
                A.BANAN_QD_ST,
                A.QD_PT,
                A.KHANGNGHI_ST,
                A.CHECK_THULY,
                A.HOTENBICAN,
                A.NGUOITAO,
                A.NGAY_TAO AS NGAYTHULY,
                A.NGAYTAO,
                A.TENTOASOTHAM,
                A.GIAIDOANVUVIEC,
                A.TRUONGHOPGIAONHAN,
                A.KHANGCAO_ST,
                A.TINHTRANG_GQ,
                A.THULYXXLAI,
                A.LOAIAN_ID,
                LA.LOAI_AN_TEN,
                B.ID AS MAPPINGID,
                B.LYDOMA AS LYDO,
                B.NGAYGIAO AS THOIGIANBANGIAO,
                B.TRANGTHAI,
                C.TEN AS TOANHAN,
                LD.TEN AS LYDOTEN
  FROM TABLE (V_TABLE_TIMKIEM) A
    LEFT JOIN DM_LOAIAN LA
      ON LA.ID = A.LOAIAN_ID
    LEFT JOIN VUAN_BANGIAO_MAPPING B
      ON A.ID = B.VUVIECID
      AND b.TOAANGIAOID = P_TOAANID
      AND b.VUVIECLOAI = 'AN_KDTM'
      AND (1 = (CASE 
                    WHEN P_TRANGTHAI = 0 THEN 1
                    WHEN P_TRANGTHAIGIAIQUYET IS NULL THEN 1
                    WHEN P_TRANGTHAIGIAIQUYET = 1 THEN 
                        CASE WHEN B.TRANGTHAIGIAIQUYET = 1 OR B.TRANGTHAIGIAIQUYET IS NULL THEN 1 ELSE 0 END
                    WHEN P_TRANGTHAIGIAIQUYET = 7 THEN 
                        CASE WHEN B.TRANGTHAIGIAIQUYET = 7 THEN 1 ELSE 0 END
                    ELSE 0
                END))
    LEFT JOIN DM_TOAAN C
      ON CASE WHEN b.TOAANNHANID IS NULL THEN 0 ELSE b.TOAANNHANID END = C.ID
    LEFT JOIN DM_DATAITEM ld
      ON b.LYDOMA = ld.MA
  WHERE 1 = 1
    -- Loại trừ những bản ghi mapping mà toà hiện tại đã nhận (TOAANNHANID = p_TOAANID)
    AND (B.TOAANNHANID IS NULL
    OR B.TOAANNHANID != P_TOAANID)
    AND (1 = (CASE
      -- TRANGTHAI = 0: Loại bỏ những bản ghi đã có mapping với toaangiaoid = p_toaanid
      WHEN P_TRANGTHAI = 0 THEN CASE WHEN NOT EXISTS (SELECT 1
                  FROM VUAN_BANGIAO_MAPPING vm
                  WHERE vm.VUVIECID = A.ID
                    AND vm.TOAANGIAOID = P_TOAANID
                    AND vm.VUVIECLOAI = 'AN_KDTM') THEN 1 ELSE 0 END
      -- TRANGTHAI = 1: Chỉ lấy những bản ghi có mapping 
      WHEN P_TRANGTHAI = 1 AND
        B.TRANGTHAI IS NOT NULL THEN 1
      -- TRANGTHAI = NULL hoặc khác: Lấy tất cả
      WHEN P_TRANGTHAI IS NULL THEN 1 WHEN P_TRANGTHAI NOT IN (0, 1) THEN 1 ELSE 0 END))
  ORDER BY A.ID DESC,
           B.ID DESC;
    END KDTM_VUAN_BANGIAO_MAPPING_GET_AN_BAN_GIAO;
    
    -- [KDTM] LẤY DANH SÁCH CHỜ DUYỆT
    PROCEDURE KDTM_VUAN_BANGIAO_MAPPING_GETS_CHONHAN (
      p_LOAIANID IN varchar2,
	    p_TOAANID IN NUMBER,
	    p_MAVUVIEC IN varchar2,
	    p_THULYTUNGAY IN date,
	    p_THULYDENNGAY IN date,
	    p_TINHTRANGTHULY IN nvarchar2,
	    p_THAMPHANGIAIQUYET IN nvarchar2,
	    p_TENVUAN IN nvarchar2,    
	    p_TRANGTHAIGIAIQUYET IN nvarchar2,    
	    p_CAPXETXU IN nvarchar2,  
	    p_TRANGTHAI IN NVARCHAR2,
	    p_CURSOR OUT SYS_REFCURSOR
    ) AS
        BEGIN
            OPEN p_CURSOR FOR
                SELECT  
                    DISTINCT
  
                    -- Mapping
                    mapping.ID as MAPPINGID,
                    mapping.NGAYGIAO,
                    mapping.NGAYNHAN,
                    mapping.TRANGTHAI,
                    mapping.GHICHU,
                    -- Vụ việc
                    don.ID AS VUVIECID,
                    don.MAVUVIEC AS VUVIECMA,
                    don.TENVUVIEC AS VUVIECTEN, 
                    -- Toà giao
                    mapping.TOAANGIAOID,
                    taGiao.TEN AS TOAANGIAOTEN,
                    -- Toà nhận
                    mapping.TOAANNHANID,
                    -- Lý do
                    mapping.LYDOMA,
                    lyDo.TEN AS LYDOTEN
                from AKT_DON don 
                JOIN VUAN_BANGIAO_MAPPING mapping ON don.ID = mapping.VUVIECID AND MAPPING.VUVIECLOAI = 'AN_KDTM'
                JOIN DM_TOAAN taGiao ON case when mapping.TOAANGIAOID is null then 0 else mapping.TOAANGIAOID end = taGiao.ID
                JOIN DM_TOAAN taNhan ON case when mapping.TOAANNHANID is null then 0 else mapping.TOAANNHANID end = taNhan.ID
                JOIN DM_DATAITEM lyDo ON mapping.LYDOMA = lyDo.MA
                LEFT JOIN AKT_SOTHAM_THULY thuLy ON don.ID = thuLy.DONID
                LEFT JOIN AKT_PHUCTHAM_THULY E ON don.ID = E.DONID
                LEFT JOIN DM_CANBO cb ON cb.ID = don.THAMPHANKYNHANDON
                WHERE mapping.TOAANNHANID = P_TOAANID 
                AND  (1=(CASE WHEN (p_MAVUVIEC || ' ')=' '  THEN 1 WHEN LOWER(don.MAVUVIEC) LIKE  ('%' || LOWER(p_MAVUVIEC) || '%') THEN 1 Else 0 END))
                AND  (1=(CASE WHEN (p_TENVUAN|| ' ')=' '  THEN 1 WHEN LOWER(don.TENVUVIEC) LIKE  ('%' || LOWER(p_TENVUAN) || '%') THEN 1 Else 0 END))
                And (1=(CASE WHEN p_THULYTUNGAY is NULL THEN 1 WHEN thuLy.NGAYTHULY >= p_THULYTUNGAY  THEN 1 Else 0 END))
                And (1=(CASE WHEN p_THULYDENNGAY is NULL THEN 1 WHEN thuLy.NGAYTHULY <= p_THULYDENNGAY  THEN 1 Else 0 END))  
--                AND  (1=(CASE WHEN (p_TINHTRANGTHULY|| ' ')=' '  THEN 1 WHEN LOWER(don.MAVUVIEC) LIKE  ('%' || LOWER(p_MAVUVIEC) || '%') THEN 1 Else 0 END))
--                AND  (1=(CASE WHEN (p_THAMPHANGIAIQUYET|| ' ')=' '  THEN 1 WHEN LOWER(don.THAMPHANKYNHANDON) LIKE  ('%' || LOWER(p_THAMPHANGIAIQUYET) || '%') THEN 1 Else 0 END))
                AND  (1=(CASE WHEN p_TINHTRANGTHULY IS NULL THEN 1
                            WHEN p_TINHTRANGTHULY = 1 AND 
                                 (CASE WHEN don.MAGIAIDOAN = 2 THEN thuLy.truonghopthuly  -- Cap So Tham
                                       WHEN don.MAGIAIDOAN IN (3,7) THEN E.truonghopthuly  -- Cap Phuc Tham
                                       ELSE thuLy.truonghopthuly END) IS NOT NULL THEN 1 -- Da thu ly
                            WHEN p_TINHTRANGTHULY = 2 AND 
                                 (CASE WHEN don.MAGIAIDOAN = 2 THEN thuLy.truonghopthuly -- Cap So Tham
                                       WHEN don.MAGIAIDOAN IN (3,7) THEN E.truonghopthuly -- Cap Phuc Tham
                                       ELSE thuLy.truonghopthuly END) IS NULL THEN 1 -- Chua thu ly
                        WHEN p_TINHTRANGTHULY NOT IN (1, 2) THEN 1 ELSE 0 END))
                AND  (1=(CASE WHEN (p_THAMPHANGIAIQUYET|| ' ')=' '  THEN 1 WHEN LOWER(cb.HOTEN) LIKE  ('%' || LOWER(p_THAMPHANGIAIQUYET) || '%') THEN 1 
                            WHEN LOWER(cb.MACANBO) LIKE  ('%' || LOWER(p_THAMPHANGIAIQUYET) || '%') THEN 1 Else 0 END))
                --AND  (1=(CASE WHEN (p_TRANGTHAIGIAIQUYET|| ' ')=' ' THEN 1 WHEN don.TRANGTHAI LIKE P_TRANGTHAIGIAIQUYET THEN 1 Else 0 END))
                -- Trạng thái giải quyết
                AND (1 = (CASE 
                              WHEN P_TRANGTHAIGIAIQUYET IS NULL THEN 1
                              WHEN P_TRANGTHAIGIAIQUYET = '1' THEN 
                                  CASE WHEN MAPPING.TRANGTHAIGIAIQUYET = '1' OR MAPPING.TRANGTHAIGIAIQUYET IS NULL THEN 1 ELSE 0 END
                              WHEN P_TRANGTHAIGIAIQUYET = '7' THEN 
                                  CASE WHEN MAPPING.TRANGTHAIGIAIQUYET = '7' THEN 1 ELSE 0 END
                              ELSE 0
                          END))
                -- Cấp xét xử
                AND (1 = (CASE WHEN p_CAPXETXU IS NULL THEN 1
                            WHEN p_CAPXETXU = 2 AND mapping.MAGIAIDOAN = 2 THEN 1 -- Cap So Tham
                            WHEN p_CAPXETXU = 3 AND mapping.MAGIAIDOAN IN (3,7) THEN 1 -- Cap Phuc Tham
                            WHEN p_CAPXETXU NOT IN (2, 3) THEN 1
                            ELSE 0 END))
                AND  (1=(CASE WHEN (p_TRANGTHAI|| ' ')=' '  THEN 1 WHEN LOWER(mapping.TRANGTHAI) = LOWER(p_TRANGTHAI) THEN 1 Else 0 END))
                ORDER BY mapping.ID DESC;
    END KDTM_VUAN_BANGIAO_MAPPING_GETS_CHONHAN;

    -- [KDTM] NHẬN BÀN GIAO
    PROCEDURE AKDTM_VUAN_BANGIAO_MAPPING_NHAN (
        p_ID IN NUMBER,
        p_VUVIECID IN NUMBER,
        p_TOAANNHANID IN NUMBER,
        p_NGAYNHAN IN DATE
    ) AS
        v_MAGIAIDOAN NUMBER;
        v_TOAANID NUMBER;
        v_TOAPHUCTHAMID NUMBER;
        v_TRANGTHAIGIAIQUYET VARCHAR2(20);

        v_tracedata VARCHAR2(1024);
        v_output VARCHAR2(512);
    BEGIN
        v_tracedata := '(' || 
         'p_ID => ' || p_ID || ',' ||
         'p_VUVIECID => ' || p_VUVIECID || ',' ||
         'p_TOAANNHANID => ' || p_TOAANNHANID || ',' ||
         'p_NGAYNHAN => ' || p_NGAYNHAN || ',' ||
         ' );';

        -- Lấy giai đoạn hiện tại của án
        SELECT don.TOAANID, don.TOAPHUCTHAMID
        INTO v_TOAANID, v_TOAPHUCTHAMID
        FROM AKT_DON don 
        WHERE don.ID = p_VUVIECID;

        -- Lấy thông tin mapping
        SELECT vbm.MAGIAIDOAN, vbm.TRANGTHAIGIAIQUYET
        INTO v_MAGIAIDOAN, v_TRANGTHAIGIAIQUYET
        FROM VUAN_BANGIAO_MAPPING vbm
        WHERE vbm.ID = p_ID AND vbm.TRANGTHAI = 'TTBG_CHONHAN';

        -- Kiểm tra giai đoạn hợp lệ
        IF v_MAGIAIDOAN NOT IN (2, 3, 7) THEN
            RAISE_APPLICATION_ERROR(-20001, 'Giai đoạn không hợp lệ.');
        END IF;

        -- Cập nhật án đã kết thúc với trạng thái giải quyết = 7
        UPDATE AKT_DON_GIAIDOAN
        SET AN_DA_KET_THUC = CASE 
                WHEN v_TRANGTHAIGIAIQUYET = 7 THEN 1 
                ELSE AN_DA_KET_THUC 
            END
        WHERE DONID = p_VUVIECID AND MAGIAIDOAN = v_MAGIAIDOAN;

        -- Xử lý cập nhật theo giai đoạn
        IF v_MAGIAIDOAN = 2 THEN
            -- SƠ THẨM
            -- Update AKT_DON
            -- backup
            UPDATE AKT_DON
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE ID = p_VUVIECID AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE AKT_DON
            SET TOAANID = p_TOAANNHANID
            WHERE ID = p_VUVIECID AND TOAANID = v_TOAANID;

            -- Kiểm tra xem có update được chính xác 1 bản ghi AKT_DON hay không
--            IF SQL%ROWCOUNT != 1 THEN
--                ROLLBACK;
--                RAISE_APPLICATION_ERROR(-20002, 'Lỗi cập nhật AKT_DON (Sơ thẩm)');
--            END IF;
            
            -- Update AKT_SOTHAM_THULY
            -- backup
            UPDATE AKT_SOTHAM_THULY
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE AKT_SOTHAM_THULY
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID;
            
            -- Update AKT_DON_GIAIDOAN
            -- backup
            UPDATE AKT_DON_GIAIDOAN
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL AND MAGIAIDOAN = v_MAGIAIDOAN;

            UPDATE AKT_DON_GIAIDOAN
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID AND MAGIAIDOAN = v_MAGIAIDOAN;

            -- Update DON_CHITIET
            -- backup
            UPDATE DON_CHITIET
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND LOAIANID = 4 AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE DON_CHITIET
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND LOAIANID = 4 AND TOAANID = v_TOAANID;

            -- Update AKT_TONGDAT
            -- backup
            UPDATE AKT_TONGDAT
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE AKT_TONGDAT
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID;
            
            -- Update DON_KHAC
            -- backup
            UPDATE DON_KHAC
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND LOAIANID = 4 AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE DON_KHAC
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND LOAIANID = 4 AND TOAANID = v_TOAANID;

            -- Update AKT_DON_XULY
            -- backup
            UPDATE AKT_DON_XULY
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE AKT_DON_XULY
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID;

            -- Update AKT_SOTHAM_BANAN
            -- backup
            UPDATE AKT_SOTHAM_BANAN
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE AKT_SOTHAM_BANAN
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID; 

            -- Update AKT_SOTHAM_QUYETDINH
            -- backup
            UPDATE AKT_SOTHAM_QUYETDINH
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE AKT_SOTHAM_QUYETDINH
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID;  
            
            -- Update AKT_CHUYEN_NHAN_AN
            -- Theo TOACHUYENID 
            -- backup
            UPDATE AKT_CHUYEN_NHAN_AN
            SET TOA_GIAIQUYET_ID = TOACHUYENID
            WHERE VUANID = p_VUVIECID AND TOACHUYENID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE AKT_CHUYEN_NHAN_AN 
            SET TOACHUYENID = p_TOAANNHANID 
            WHERE VUANID = p_VUVIECID AND TOACHUYENID = v_TOAANID;
            
            -- Theo TOANHANID
            -- backup
            UPDATE AKT_CHUYEN_NHAN_AN
            SET TOA_GIAIQUYET_NHAN_ID = TOANHANID
            WHERE VUANID = p_VUVIECID AND TOANHANID = v_TOAANID AND TOA_GIAIQUYET_NHAN_ID IS NULL;

            UPDATE AKT_CHUYEN_NHAN_AN
            SET TOANHANID = p_TOAANNHANID
            WHERE VUANID = p_VUVIECID AND TOANHANID = v_TOAANID;

            -- Với trường hợp chuyển ST -> ST, sau khi chuyển án tạm đình chỉ
            UPDATE AKT_CHUYEN_NHAN_AN
      			SET
      				TOA_GIAIQUYET_NHAN_ID = TOANHANID,
      				TOANHANID = p_TOAANNHANID
      			WHERE
      				VUANID in (
        				SELECT CNA.MAP_VUANID_NEW
        				FROM AKT_CHUYEN_NHAN_AN CNA
        				WHERE CNA.VUANID = p_VUVIECID AND CNA.MAP_VUANID_NEW IS NOT NULL
              );

            -- Với trường hợp chuyển ST -> ST, sau khi chuyển án không đủ thẩm quyền xét xử
            UPDATE AKT_CHUYEN_NHAN_AN
      			SET
      				TOA_GIAIQUYET_NHAN_ID = TOANHANID,
      				TOANHANID = p_TOAANNHANID
      			WHERE
      				MAP_VUANID_NEW = p_VUVIECID AND MAP_VUANID_NEW IS NOT NULL;

        ELSIF v_MAGIAIDOAN IN(3,7) THEN
            -- PHÚC THẨM

            -- Update AKT_DON
            -- backup
            UPDATE AKT_DON
            SET TOA_PHUCTHAM_GIAIQUYET_ID = TOAPHUCTHAMID
            WHERE ID = p_VUVIECID AND TOAPHUCTHAMID = v_TOAPHUCTHAMID AND TOA_PHUCTHAM_GIAIQUYET_ID IS NULL;

            UPDATE AKT_DON
            SET TOAPHUCTHAMID = p_TOAANNHANID
            WHERE ID = p_VUVIECID AND TOAPHUCTHAMID = v_TOAPHUCTHAMID;

            -- backup
            UPDATE AKT_DON
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE ID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE AKT_DON
            SET TOAANID = p_TOAANNHANID
            WHERE ID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID;

            -- Kiểm tra xem có update được chính xác 1 bản ghi AKT_DON hay không
--            IF SQL%ROWCOUNT != 1 THEN
--                ROLLBACK;
--                RAISE_APPLICATION_ERROR(-20003, 'Lỗi cập nhật AKT_DON (Phúc thẩm)');
--            END IF;
            
            -- Update AKT_PHUCTHAM_THULY
            -- backup
            UPDATE AKT_PHUCTHAM_THULY
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE AKT_PHUCTHAM_THULY
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID;
            
            -- Update AKT_DON_GIAIDOAN
            -- backup
            UPDATE AKT_DON_GIAIDOAN
            SET TOA_PHUCTHAM_GIAIQUYET_ID = TOAPHUCTHAMID
            WHERE DONID = p_VUVIECID AND TOAPHUCTHAMID = v_TOAPHUCTHAMID AND TOA_PHUCTHAM_GIAIQUYET_ID IS NULL AND MAGIAIDOAN = v_MAGIAIDOAN;

            UPDATE AKT_DON_GIAIDOAN
            SET TOAPHUCTHAMID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAPHUCTHAMID = v_TOAPHUCTHAMID AND MAGIAIDOAN = v_MAGIAIDOAN;

            -- backup
            UPDATE AKT_DON_GIAIDOAN
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE AKT_DON_GIAIDOAN
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID;
            
            -- UPDATE AKT_KCKNQDK_PHUCTHAM_QUYETDINH
            -- backup
            UPDATE AKT_KCKNQDK_PHUCTHAM_QUYETDINH
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE AKT_KCKNQDK_PHUCTHAM_QUYETDINH
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID;
            
            -- UPDATE AKT_KCKNQDK_PHUCTHAM_THULY
            -- backup
            UPDATE AKT_KCKNQDK_PHUCTHAM_THULY
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE AKT_KCKNQDK_PHUCTHAM_THULY
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID;
            
            -- UPDATE AKT_PHUCTHAM_BANAN
            -- backup
            UPDATE AKT_PHUCTHAM_BANAN
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE AKT_PHUCTHAM_BANAN
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID;
            
            -- UPDATE AKT_PHUCTHAM_QUYETDINH
            -- backup
            UPDATE AKT_PHUCTHAM_QUYETDINH
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE AKT_PHUCTHAM_QUYETDINH
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID;

            -- Update AKT_TONGDAT
            -- backup
            UPDATE AKT_TONGDAT
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE AKT_TONGDAT
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID;

            -- Update DON_KHAC
            -- backup
            UPDATE DON_KHAC
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND LOAIANID = 4 AND TOAANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE DON_KHAC
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND LOAIANID = 4 AND TOAANID = v_TOAPHUCTHAMID;

            -- Update HOSO_PT
            -- backup
            UPDATE HOSO_PT
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE VUANID = p_VUVIECID AND LOAIAN = 4 AND TOAANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE HOSO_PT
            SET TOAANID = p_TOAANNHANID
            WHERE VUANID = p_VUVIECID AND LOAIAN = 4 AND TOAANID = v_TOAPHUCTHAMID;

            -- Update HOSO_PT
            -- backup
            UPDATE HOSO_PT
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE VUANID = p_VUVIECID AND LOAIAN = 4 AND TOAANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE HOSO_PT
            SET TOAANID = p_TOAANNHANID
            WHERE VUANID = p_VUVIECID AND LOAIAN = 4 AND TOAANID = v_TOAPHUCTHAMID;
            
            IF (v_MAGIAIDOAN = 7) THEN
              -- Update AKT_CHUYEN_NHAN_AN
              -- Theo TOACHUYENID 
              -- backup
	           	UPDATE AKT_CHUYEN_NHAN_AN 
	            SET TOA_GIAIQUYET_ID = TOACHUYENID
	            WHERE MAP_VUANID_NEW = p_VUVIECID AND TOACHUYENID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

              UPDATE AKT_CHUYEN_NHAN_AN 
	            SET TOACHUYENID = p_TOAANNHANID 
	            WHERE MAP_VUANID_NEW = p_VUVIECID AND TOACHUYENID = v_TOAPHUCTHAMID;
	            
              -- Theo TOANHANID 
              -- backup
	           	UPDATE AKT_CHUYEN_NHAN_AN 
	            SET TOA_GIAIQUYET_NHAN_ID = TOANHANID
	            WHERE MAP_VUANID_NEW = p_VUVIECID AND TOANHANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_NHAN_ID IS NULL;

	            UPDATE AKT_CHUYEN_NHAN_AN
	            SET TOANHANID = p_TOAANNHANID
	            WHERE MAP_VUANID_NEW = p_VUVIECID AND TOANHANID = v_TOAPHUCTHAMID;
           ELSE
	            -- Update AKT_CHUYEN_NHAN_AN
              -- Theo TOACHUYENID 
              -- backup
	           	UPDATE AKT_CHUYEN_NHAN_AN 
	            SET TOA_GIAIQUYET_ID = TOACHUYENID
	            WHERE VUANID = p_VUVIECID AND TOACHUYENID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;

              UPDATE AKT_CHUYEN_NHAN_AN 
	            SET TOACHUYENID = p_TOAANNHANID 
	            WHERE VUANID = p_VUVIECID AND TOACHUYENID = v_TOAPHUCTHAMID;
	            
              -- Theo TOANHANID 
              -- backup
	           	UPDATE AKT_CHUYEN_NHAN_AN 
	            SET TOA_GIAIQUYET_NHAN_ID = TOANHANID
	            WHERE VUANID = p_VUVIECID AND TOANHANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_NHAN_ID IS NULL;

	            UPDATE AKT_CHUYEN_NHAN_AN
	            SET TOANHANID = p_TOAANNHANID
	            WHERE VUANID = p_VUVIECID AND TOANHANID = v_TOAPHUCTHAMID;
           END IF;
            
        END IF;
        
        -- Update TRANGTHAI cho VUAN_BANGIAO_MAPPING
        UPDATE VUAN_BANGIAO_MAPPING
        SET TRANGTHAI = 'TTBG_DANHAN',
            NGAYNHAN = p_NGAYNHAN
        WHERE ID = p_ID;
        
        COMMIT;
        
    EXCEPTION
      WHEN OTHERS THEN
          -- Rollback in case of any exception
          ROLLBACK;

          v_output := 'Finish procedure Due to Exception: Error:' || SQLCODE || ',' || SQLERRM;
          PKG_TRACELOG.SP_INSERT_LOG_ERROR(
              p_functionname => 'PKG_BAN_GIAO_AN.AKDTM_VUAN_BANGIAO_MAPPING_NHAN',
              p_description => v_output,
              p_notes => v_tracedata
          );

          -- Re-raise the exception
          RAISE;
    END AKDTM_VUAN_BANGIAO_MAPPING_NHAN;

    -- [KDTM] KIỂM TRA THAY ĐỔI
    PROCEDURE KDTM_VUAN_BANGIAO_MAPPING_KTTHAYDOI (
        p_ID IN NUMBER,
        p_result OUT NUMBER,
        p_message OUT VARCHAR2
    )
    AS
        v_VUVIECID NUMBER;
        v_TOAANNHANID NUMBER;
        v_NGANHAN DATE;
        v_count NUMBER;
    BEGIN
        -- Khởi tạo giá trị mặc định
        p_result := 0;
        p_message := '';

        -- Lấy thông tin Mapping
        SELECT VUVIECID, TOAANNHANID, NGAYNHAN
        INTO  v_VUVIECID, v_TOAANNHANID, v_NGANHAN
        FROM VUAN_BANGIAO_MAPPING
        WHERE ID = p_ID AND TRANGTHAI = 'TTBG_DANHAN';
        
        -- Kiểm tra các bảng có thay đổi sau ngày nhận án
        
        -- Kiểm tra AKT_ANPHI
        SELECT COUNT(*) INTO v_count 
        FROM AKT_ANPHI 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN)
          AND SOBIENLAI IS NOT NULL AND TAMUNGANPHI IS NOT NULL AND NGUOINHANID IS NOT NULL;
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin án phí đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra AKT_CHUYEN_NHAN_AN
        SELECT COUNT(*) INTO v_count 
        FROM AKT_CHUYEN_NHAN_AN 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin chuyển nhận án đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra AKT_DON_DUONGSU
        SELECT COUNT(*) INTO v_count 
        FROM AKT_DON_DUONGSU 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin đương sự đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra AKT_DON_GIAIDOAN
        SELECT COUNT(*) INTO v_count 
        FROM AKT_DON_GIAIDOAN 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin giai đoạn đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra AKT_DON_TAILIEU
        SELECT COUNT(*) INTO v_count 
        FROM AKT_DON_TAILIEU 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin tài liệu đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra AKT_DON_THAMGIATOTUNG
        SELECT COUNT(*) INTO v_count 
        FROM AKT_DON_THAMGIATOTUNG 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin tham gia tố tụng đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra AKT_DON_THAMPHAN
        SELECT COUNT(*) INTO v_count 
        FROM AKT_DON_THAMPHAN 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin thẩm phán đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra AKT_DON_XULY
        SELECT COUNT(*) INTO v_count 
        FROM AKT_DON_XULY 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin xử lý đơn đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AKT_FILE
--        SELECT COUNT(*) INTO v_count 
--        FROM AKT_FILE 
--        WHERE DONID = v_VUVIECID 
--          AND (NGAYTAO >= v_NGANHAN);
--        
--        IF v_count > 0 THEN
--            p_result := 1;
--            p_message := 'Thông tin đơn đã có thay đổi, không thể trả án.';
--            RETURN;
--        END IF;

        -- Kiểm tra AKT_KCKNQDK_PHUCTHAM_HDXX
        SELECT COUNT(*) INTO v_count 
        FROM AKT_KCKNQDK_PHUCTHAM_HDXX 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin HĐXX KCKNQDK phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AKT_KCKNQDK_PHUCTHAM_QUYETDINH
        SELECT COUNT(*) INTO v_count 
        FROM AKT_KCKNQDK_PHUCTHAM_QUYETDINH 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin quyết định KCKNQDK phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AKT_KCKNQDK_PHUCTHAM_THAMGIATOTUNG
        SELECT COUNT(*) INTO v_count 
        FROM AKT_KCKNQDK_PHUCTHAM_THAMGIATOTUNG 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin tham gia tố tụng KCKNQDK phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AKT_KCKNQDK_PHUCTHAM_THULY
        SELECT COUNT(*) INTO v_count 
        FROM AKT_KCKNQDK_PHUCTHAM_THULY 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin thụ lý KCKNQDK phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra AKT_PHUCTHAM_BANAN
        SELECT COUNT(*) INTO v_count 
        FROM AKT_PHUCTHAM_BANAN 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin bản án phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra AKT_PHUCTHAM_BANAN_FILE
        SELECT COUNT(*) INTO v_count 
        FROM AKT_PHUCTHAM_BANAN_FILE f
        WHERE EXISTS (
            SELECT 1 FROM AKT_PHUCTHAM_BANAN b 
            WHERE b.DONID = v_VUVIECID AND b.ID = f.BANANID
        ) AND f.NGAYTAO >= v_NGANHAN;
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin bản án phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra AKT_PHUCTHAM_BANAN_TGTT
--        SELECT COUNT(*) INTO v_count 
--        FROM AKT_PHUCTHAM_BANAN_TGTT 
--        WHERE DONID = v_VUVIECID AND NGAYNHANBANAN >= v_NGANHAN;
--        
--        IF v_count > 0 THEN
--            p_result := 1;
--            p_message := 'Thông tin bản án phúc thẩm đã có thay đổi, không thể trả án.';
--            RETURN;
--        END IF;

         -- Kiểm tra AKT_PHUCTHAM_DUONGSU
--        SELECT COUNT(*) INTO v_count 
--        FROM AKT_PHUCTHAM_DUONGSU 
--        WHERE DONID = v_VUVIECID 
--          AND (NGAYTAO >= v_NGANHAN);
        
--        IF v_count > 0 THEN
--            p_result := 1;
--            p_message := 'Thông tin HĐXX phúc thẩm đã có thay đổi, không thể trả án.';
--            RETURN;
--        END IF;
        
        -- Kiểm tra AKT_PHUCTHAM_HDXX
        SELECT COUNT(*) INTO v_count 
        FROM AKT_PHUCTHAM_HDXX 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin HĐXX phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra AKT_PHUCTHAM_HOAGIAI
        SELECT COUNT(*) INTO v_count 
        FROM AKT_PHUCTHAM_HOAGIAI 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin hoà giải phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AKT_PHUCTHAM_QUYETDINH
        SELECT COUNT(*) INTO v_count 
        FROM AKT_PHUCTHAM_QUYETDINH 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin quyết định phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AKT_PHUCTHAM_THAMGIATOTUNG
        SELECT COUNT(*) INTO v_count 
        FROM AKT_PHUCTHAM_THAMGIATOTUNG 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin tham gia tố tụng phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AKT_PHUCTHAM_THULY
        SELECT COUNT(*) INTO v_count 
        FROM AKT_PHUCTHAM_THULY 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin thụ lý phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AKT_SAUXETXU
--        SELECT COUNT(*) INTO v_count 
--        FROM AKT_SAUXETXU 
--        WHERE VUANID = v_VUVIECID 
--          AND (NGAYTAO >= v_NGANHAN);
--        
--        IF v_count > 0 THEN
--            p_result := 1;
--            p_message := 'Thông tin sau xét xử đã có thay đổi, không thể trả án.';
--            RETURN;
--        END IF;

        -- Kiểm tra AKT_SOTHAM_BANAN
        SELECT COUNT(*) INTO v_count 
        FROM AKT_SOTHAM_BANAN 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin bản án sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AKT_SOTHAM_BANAN_ANPHI
        SELECT COUNT(*) INTO v_count 
        FROM AKT_SOTHAM_BANAN_ANPHI 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin án phí bản án sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AKT_SOTHAM_BANAN_DIEULUAT
        SELECT COUNT(*) INTO v_count 
        FROM AKT_SOTHAM_BANAN_DIEULUAT 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin điều luật bản án sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AKT_SOTHAM_BANAN_FILE
        SELECT COUNT(*) INTO v_count 
        FROM AKT_SOTHAM_BANAN_FILE 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin đơn bản án sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AKT_SOTHAM_BANAN_TGTT
--        SELECT COUNT(*) INTO v_count 
--        FROM AKT_SOTHAM_BANAN_TGTT 
--        WHERE DONID = v_VUVIECID 
--          AND (NGAYTAO >= v_NGANHAN);
--        
--        IF v_count > 0 THEN
--            p_result := 1;
--            p_message := 'Thông tin đơn bản án sơ thẩm có thay đổi, không thể trả án.';
--            RETURN;
--        END IF;

        -- Kiểm tra AKT_SOTHAM_HDXX
        SELECT COUNT(*) INTO v_count 
        FROM AKT_SOTHAM_HDXX 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin HĐXX sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AKT_SOTHAM_HOAGIAI
        SELECT COUNT(*) INTO v_count 
        FROM AKT_SOTHAM_HOAGIAI 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin hoà giải sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AKT_SOTHAM_KHANGCAO
        SELECT COUNT(*) INTO v_count 
        FROM AKT_SOTHAM_KHANGCAO 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin kháng cáo sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

         -- Kiểm tra AKT_SOTHAM_KHANGNGHI
        SELECT COUNT(*) INTO v_count 
        FROM AKT_SOTHAM_KHANGNGHI 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin kháng nghị sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

         -- Kiểm tra AKT_SOTHAM_QUYETDINH
        SELECT COUNT(*) INTO v_count 
        FROM AKT_SOTHAM_QUYETDINH 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin quyết định sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

         -- Kiểm tra AKT_SOTHAM_RUTKCKN
        SELECT COUNT(*) INTO v_count 
        FROM AKT_SOTHAM_RUTKCKN 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin rút KCKN sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

--        -- Kiểm tra AKT_SOTHAM_THAMGIATOTUNG
--        SELECT COUNT(*) INTO v_count 
--        FROM AKT_SOTHAM_THAMGIATOTUNG 
--        WHERE DONID = v_VUVIECID 
--          AND (NGAYTAO >= v_NGANHAN);
--        
--        IF v_count > 0 THEN
--            p_result := 1;
--            p_message := 'Thông tin tham gia TT sơ thẩm có thay đổi, không thể trả án.';
--            RETURN;
--        END IF;

          -- Kiểm tra AKT_SOTHAM_THULY
        SELECT COUNT(*) INTO v_count 
        FROM AKT_SOTHAM_THULY 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin thụ lý sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

          -- Kiểm tra AKT_TONGDAT
        SELECT COUNT(*) INTO v_count 
        FROM AKT_TONGDAT 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin tống đạt có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AKT_TONGDAT_DOITUONG
        SELECT COUNT(*) INTO v_count 
        FROM AKT_TONGDAT_DOITUONG f
        WHERE EXISTS (
            SELECT 1 FROM AKT_TONGDAT b 
            WHERE b.DONID = v_VUVIECID AND b.ID = f.TONGDATID
        ) 
          AND f.NGAYTAO >= v_NGANHAN;
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin đối tượng tống đạt đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AKT_TRUNGCAU_GIAMDINH
        SELECT COUNT(*) INTO v_count 
        FROM AKT_TRUNGCAU_GIAMDINH 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin trưng cầu giám định có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AKT_XULY_VIPHAMHC
        SELECT COUNT(*) INTO v_count 
        FROM AKT_XULY_VIPHAMHC 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin xử lý vi phạm HC có thay đổi, không thể trả án.';
            RETURN;
        END IF;
                
        -- Kiểm tra DON_KHAC
        SELECT COUNT(*) INTO v_count 
        FROM DON_KHAC 
        WHERE DONID = v_VUVIECID 
          AND (NGAYNHANDON >= v_NGANHAN OR NGAYKHANGCAO >= v_NGANHAN) 
          AND LOAIANID = 4;
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin đơn đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra DON_KHAC_YEUCAU
        SELECT COUNT(*) INTO v_count 
        FROM DON_KHAC_YEUCAU y
        WHERE EXISTS (
            SELECT 1 FROM DON_KHAC d 
            WHERE d.DONID = v_VUVIECID 
              AND d.ID = y.DONKHACID
        ) AND (y.NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin đơn đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra DON_CHITIET
        SELECT COUNT(*) INTO v_count 
        FROM DON_CHITIET 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN) 
          AND LOAIANID = 4;
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin đơn đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra DON_DUONGSU_CHITIET
        SELECT COUNT(*) INTO v_count 
        FROM DON_DUONGSU_CHITIET 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN)
          AND LOAIAN = 4;
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin đương sự đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra HOSO_PT
        SELECT COUNT(*) INTO v_count 
        FROM HOSO_PT 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN)
          AND LOAIAN = 4;
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin hồ sơ phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
      EXCEPTION
          WHEN OTHERS THEN
              p_result := 1;
              p_message := 'Lỗi khi kiểm tra: ' || SQLERRM;
  END KDTM_VUAN_BANGIAO_MAPPING_KTTHAYDOI;

    -- [KDTM] TRẢ LẠI
    PROCEDURE KDTM_VUAN_BANGIAO_MAPPING_TRALAI (
        p_ID IN NUMBER
    ) AS
        v_VUVIECID NUMBER;
        v_MAGIAIDOAN NUMBER;
        v_TOAANGIAOID NUMBER;
        v_TOAANNHANID NUMBER;

        v_tracedata VARCHAR2(1024);
        v_output VARCHAR2(512);
    BEGIN
        v_tracedata := '(' || 
         'p_ID => ' || p_ID || ',' ||
         ' );';

        -- Lấy thông tin Mapping
        SELECT VUVIECID, TOAANGIAOID, TOAANNHANID, MAGIAIDOAN
        INTO  v_VUVIECID, v_TOAANGIAOID, v_TOAANNHANID, v_MAGIAIDOAN
        FROM VUAN_BANGIAO_MAPPING
        WHERE ID = p_ID AND TRANGTHAI = 'TTBG_DANHAN';

        -- Xoá thông tin AN_DA_KET_THUC cho giai đoạn
        UPDATE AKT_DON_GIAIDOAN
        SET AN_DA_KET_THUC = NULL
        WHERE DONID = v_VUVIECID AND MAGIAIDOAN = v_MAGIAIDOAN AND (TOA_GIAIQUYET_ID = v_TOAANGIAOID OR TOA_PHUCTHAM_GIAIQUYET_ID = v_TOAANGIAOID);
        
        -- Xử lý cập nhật theo giai đoạn
        IF v_MAGIAIDOAN = 2 THEN
            -- SƠ THẨM
            -- Update AKT_DON
            UPDATE AKT_DON
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE ID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update AKT_SOTHAM_THULY
            UPDATE AKT_SOTHAM_THULY
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
            
            -- Update AKT_DON_GIAIDOAN
            UPDATE AKT_DON_GIAIDOAN
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update DON_CHITIET
            UPDATE DON_CHITIET
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND LOAIANID = 4 AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update AKT_TONGDAT
            UPDATE AKT_TONGDAT
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update DON_KHAC
            UPDATE DON_KHAC
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND LOAIANID = 4 AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update AKT_DON_XULY
            UPDATE AKT_DON_XULY
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update AKT_SOTHAM_BANAN
            UPDATE AKT_SOTHAM_BANAN
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update AKT_SOTHAM_QUYETDINH
            UPDATE AKT_SOTHAM_QUYETDINH
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update AKT_CHUYEN_NHAN_AN
            -- Theo TOACHUYENID 
            UPDATE AKT_CHUYEN_NHAN_AN 
            SET TOACHUYENID = TOA_GIAIQUYET_ID 
            WHERE VUANID = v_VUVIECID AND TOACHUYENID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
            
            -- Theo TOANHANID
            UPDATE AKT_CHUYEN_NHAN_AN
            SET TOANHANID = TOA_GIAIQUYET_NHAN_ID
            WHERE VUANID = v_VUVIECID AND TOANHANID = v_TOAANNHANID AND TOA_GIAIQUYET_NHAN_ID = v_TOAANGIAOID;

            -- Với trường hợp chuyển ST -> ST, sau khi chuyển án tạm đình chỉ
          	UPDATE AKT_CHUYEN_NHAN_AN
            SET TOANHANID = TOA_GIAIQUYET_NHAN_ID
			      WHERE VUANID in (SELECT CNA.MAP_VUANID_NEW
				                     FROM AKT_CHUYEN_NHAN_AN CNA
                             WHERE CNA.VUANID = v_VUVIECID AND CNA.MAP_VUANID_NEW IS NOT NULL);

            -- Với trường hợp chuyển ST -> ST, sau khi chuyển án không đủ thẩm quyền xét xử
            UPDATE AKT_CHUYEN_NHAN_AN
      			SET
      				TOANHANID = TOA_GIAIQUYET_NHAN_ID
      			WHERE
      				MAP_VUANID_NEW = v_VUVIECID AND MAP_VUANID_NEW IS NOT NULL;

        ELSIF v_MAGIAIDOAN IN (3,7) THEN
            -- PHÚC THẨM

            -- Update AKT_DON
            UPDATE AKT_DON
            SET TOAPHUCTHAMID = TOA_PHUCTHAM_GIAIQUYET_ID
            WHERE ID = v_VUVIECID AND TOAPHUCTHAMID = v_TOAANNHANID AND TOA_PHUCTHAM_GIAIQUYET_ID = v_TOAANGIAOID;

            UPDATE AKT_DON
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE ID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update AKT_PHUCTHAM_THULY

            UPDATE AKT_PHUCTHAM_THULY
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update AKT_DON_GIAIDOAN
            UPDATE AKT_DON_GIAIDOAN
            SET TOAPHUCTHAMID = TOA_PHUCTHAM_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAPHUCTHAMID = v_TOAANNHANID AND TOA_PHUCTHAM_GIAIQUYET_ID = v_TOAANGIAOID;

            UPDATE AKT_DON_GIAIDOAN
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- UPDATE AKT_KCKNQDK_PHUCTHAM_QUYETDINH
            UPDATE AKT_KCKNQDK_PHUCTHAM_QUYETDINH
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
            
            -- UPDATE AKT_KCKNQDK_PHUCTHAM_THULY
            UPDATE AKT_KCKNQDK_PHUCTHAM_THULY
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
            
            -- UPDATE AKT_PHUCTHAM_BANAN
            UPDATE AKT_PHUCTHAM_BANAN
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
            
            -- UPDATE AKT_PHUCTHAM_QUYETDINH
            UPDATE AKT_PHUCTHAM_QUYETDINH
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update AKT_TONGDAT
            UPDATE AKT_TONGDAT
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update DON_CHITIET
            UPDATE DON_CHITIET
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND LOAIANID = 4 AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update DON_KHAC
            UPDATE DON_KHAC
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND LOAIANID = 4 AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update HOSO_PT
            UPDATE HOSO_PT
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE VUANID = v_VUVIECID AND LOAIAN = 4 AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
            
            IF (v_MAGIAIDOAN = 7) THEN
              -- Update AKT_CHUYEN_NHAN_AN
              -- Theo TOACHUYENID 
              UPDATE AKT_CHUYEN_NHAN_AN 
	            SET TOACHUYENID = TOA_GIAIQUYET_ID 
	            WHERE MAP_VUANID_NEW = v_VUVIECID AND TOACHUYENID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
	            
              -- Theo TOANHANID 
	            UPDATE AKT_CHUYEN_NHAN_AN
	            SET TOANHANID = TOA_GIAIQUYET_NHAN_ID
	            WHERE MAP_VUANID_NEW = v_VUVIECID AND TOANHANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
           ELSE
	            -- Update AKT_CHUYEN_NHAN_AN
              -- Theo TOACHUYENID 
              UPDATE AKT_CHUYEN_NHAN_AN 
	            SET TOACHUYENID = TOA_GIAIQUYET_ID 
	            WHERE VUANID = v_VUVIECID AND TOACHUYENID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
	            
              -- Theo TOANHANID 
	            UPDATE AKT_CHUYEN_NHAN_AN
	            SET TOANHANID = TOA_GIAIQUYET_ID
	            WHERE VUANID = v_VUVIECID AND TOANHANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
           END IF;
        END IF;
        
        -- Update TRANGTHAI cho VUAN_BANGIAO_MAPPING
        update VUAN_BANGIAO_MAPPING 
        SET TRANGTHAI = 'TTBG_CHONHAN'
        WHERE ID = p_ID;
        
        COMMIT;
        
    EXCEPTION
      WHEN OTHERS THEN
          -- Rollback in case of any exception
          ROLLBACK;

          v_output := 'Finish procedure Due to Exception: Error:' || SQLCODE || ',' || SQLERRM;
          PKG_TRACELOG.SP_INSERT_LOG_ERROR(
              p_functionname => 'PKG_BAN_GIAO_AN.KDTM_VUAN_BANGIAO_MAPPING_TRALAI',
              p_description => v_output,
              p_notes => v_tracedata
          );

          -- Re-raise the exception
          RAISE;
    END KDTM_VUAN_BANGIAO_MAPPING_TRALAI;
    
    PROCEDURE VUAN_BANGIAO_MAPPING_ADD (
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
        p_GHICHU                 IN VARCHAR2,
        p_TRANGTHAIGIAIQUYET     IN VARCHAR2
    ) AS
        v_maGiaiDoan NUMBER;
        v_trangThaiGiaiQuyet NUMBER;
        v_tracedata VARCHAR2(1024);
        v_output VARCHAR2(512);
      BEGIN
        v_tracedata := '(' || 
         'p_TOAANGIAOID => ' || p_TOAANGIAOID || ',' ||
         'p_TOAANGIAOTEN => ' || p_TOAANGIAOTEN || ',' ||
         'p_TOAANNHANID => ' || p_TOAANNHANID || ',' ||
         'p_TOAANNHANTEN => ' || p_TOAANNHANTEN || ',' ||
         'p_VUVIECID => ' || p_VUVIECID || ',' ||
         'p_VUVIECLOAI => ' || p_VUVIECLOAI || ',' ||
         'p_VUVIECMA => ' || p_VUVIECMA || ',' ||
         'p_VUVIECTEN => ' || p_VUVIECTEN || ',' ||
         'p_NGUOIGIAOID => ' || p_NGUOIGIAOID || ',' ||
         'p_NGUOIGIAOTEN => ' || p_NGUOIGIAOTEN || ',' ||
         'p_NGUOINHANID => ' || p_NGUOINHANID || ',' ||
         'p_NGUOINHANTEN => ' || p_NGUOINHANTEN || ',' ||
         'p_LYDOMA => ' || p_LYDOMA || ',' ||
         'p_ISQUYETDINHCHUYEN => ' || p_ISQUYETDINHCHUYEN || ',' ||
         'p_SOQUYETDINH => ' || p_SOQUYETDINH || ',' ||
         'p_NGAYQUYETDINH => ' || p_NGAYQUYETDINH || ',' ||
         'p_NGUOIKY => ' || p_NGUOIKY || ',' ||
         'p_TRANGTHAI => ' || p_TRANGTHAI || ',' ||
         'p_GHICHU => ' || p_GHICHU || ',' ||
         'p_TRANGTHAIGIAIQUYET => ' || p_TRANGTHAIGIAIQUYET || ',' ||
         ' );';

         -- Mã giai đoạn
         IF p_VUVIECLOAI = 'AN_HINHSU' THEN
            SELECT MAGIAIDOAN INTO v_maGiaiDoan
            FROM AHS_VUAN_GIAIDOAN 
            WHERE VUANID = P_VUVIECID 
              AND ((TOAANID = p_TOAANGIAOID AND MAGIAIDOAN = 2) 
                   OR (TOAPHUCTHAMID = p_TOAANGIAOID AND MAGIAIDOAN IN (3, 7)));
        
        ELSIF p_VUVIECLOAI = 'AN_DANSU' THEN
            SELECT MAGIAIDOAN INTO v_maGiaiDoan
            FROM ADS_DON_GIAIDOAN 
            WHERE DONID = P_VUVIECID 
              AND ((TOAANID = p_TOAANGIAOID AND MAGIAIDOAN = 2) 
                   OR (TOAPHUCTHAMID = p_TOAANGIAOID AND MAGIAIDOAN IN (3, 7)));
        
        ELSIF p_VUVIECLOAI = 'AN_HNGD' THEN
            SELECT MAGIAIDOAN INTO v_maGiaiDoan
            FROM AHN_DON_GIAIDOAN 
            WHERE DONID = P_VUVIECID 
              AND ((TOAANID = p_TOAANGIAOID AND MAGIAIDOAN = 2) 
                   OR (TOAPHUCTHAMID = p_TOAANGIAOID AND MAGIAIDOAN IN (3, 7)));
        
        ELSIF p_VUVIECLOAI = 'AN_KDTM' THEN
            SELECT MAGIAIDOAN INTO v_maGiaiDoan
            FROM AKT_DON_GIAIDOAN 
            WHERE DONID = P_VUVIECID 
              AND ((TOAANID = p_TOAANGIAOID AND MAGIAIDOAN = 2) 
                   OR (TOAPHUCTHAMID = p_TOAANGIAOID AND MAGIAIDOAN IN (3, 7)));
        
        ELSIF p_VUVIECLOAI = 'AN_LAODONG' THEN
            SELECT MAGIAIDOAN INTO v_maGiaiDoan
            FROM ALD_DON_GIAIDOAN 
            WHERE DONID = P_VUVIECID 
              AND ((TOAANID = p_TOAANGIAOID AND MAGIAIDOAN = 2) 
                   OR (TOAPHUCTHAMID = p_TOAANGIAOID AND MAGIAIDOAN IN (3, 7)));
        
        ELSIF p_VUVIECLOAI = 'AN_HANHCHINH' THEN
            SELECT MAGIAIDOAN INTO v_maGiaiDoan
            FROM AHC_DON_GIAIDOAN 
            WHERE DONID = P_VUVIECID 
              AND ((TOAANID = p_TOAANGIAOID AND MAGIAIDOAN = 2) 
                   OR (TOAPHUCTHAMID = p_TOAANGIAOID AND MAGIAIDOAN IN (3, 7)));

        ELSIF p_VUVIECLOAI = 'BPXLHC' THEN
            SELECT MAGIAIDOAN INTO v_maGiaiDoan
            FROM XLHC_DON_GIAIDOAN 
            WHERE DONID = P_VUVIECID 
              AND ((TOAANID = p_TOAANGIAOID AND MAGIAIDOAN = 2) 
                   OR (TOAPHUCTHAMID = p_TOAANGIAOID AND MAGIAIDOAN IN (3, 7)));
        
        ELSE
            v_maGiaiDoan := NULL; -- Hoặc giá trị mặc định khác
        END IF;

          INSERT INTO VUAN_BANGIAO_MAPPING (
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
              GHICHU,
              TRANGTHAIGIAIQUYET,
              MAGIAIDOAN
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
              p_GHICHU,
              -- trạng thái giải quyết
              (
                CASE 
                  WHEN p_VUVIECLOAI = 'AN_HINHSU' THEN 
                      CASE 
                          WHEN (EXISTS (
                                  SELECT 1 FROM AHS_SOTHAM_BANAN BA 
                                  WHERE BA.ID IS NOT NULL AND BA.VUANID = P_VUVIECID AND v_maGiaiDoan = 2
                               )
                               OR EXISTS (
                                   SELECT 1 FROM AHS_SOTHAM_QUYETDINH_VUAN QSV 
                                      LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID 
                                   WHERE QD.KET_THUC = 1 AND QD.ISSOTHAM = 1 AND QD.ISHINHSU = 1 
                                     AND QSV.VUANID = P_VUVIECID AND v_maGiaiDoan = 2
                               )
                               OR EXISTS (
                                   SELECT 1 FROM AHS_PHUCTHAM_BANAN PTBA
                                   WHERE PTBA.ID IS NOT NULL AND PTBA.VUANID = P_VUVIECID AND v_maGiaiDoan = 3
                               )
                               OR EXISTS (
                                   SELECT 1 FROM AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA 
                                      LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID
                                   WHERE QD.KET_THUC = 1 AND QD.ISPHUCTHAM = 1 AND QD.ISHINHSU = 1 
                                     AND PTQDVA.VUANID = P_VUVIECID AND v_maGiaiDoan = 3
                               )
                               OR EXISTS ( 
                                  SELECT 'X' FROM AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN PTQDVA
                                      LEFT JOIN DM_QD_QUYETDINH                     QD ON QD.ID = PTQDVA.QUYETDINHID
                                      LEFT JOIN DM_QD_LOAI                          QDL ON QDL.ID = QD.LOAIID
                                  WHERE QD.MA IN ( '46-HS', '51-HS', '52-HS' )
                                    AND PTQDVA.VUANID = P_VUVIECID
                                    AND v_maGiaiDoan = 7
                                    OR INSTR(',CNTT,', ',' || QDL.MA || ',') > 0 )
                              OR EXISTS ( SELECT 'X'
                                           FROM AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN PTQDVA --QUYẾT ĐỊNH 
                                           LEFT JOIN AHS_KCKNQDK_PHUCTHAM_THULY          PTTL ON PTTL.VUANID = PTQDVA.VUANID
                                           LEFT JOIN AHS_PHUCTHAM_BANAN                  PTBA ON PTBA.VUANID = PTTL.VUANID --BẢN ÁN 
                                           LEFT JOIN DM_QD_QUYETDINH                     QD ON QD.ID = PTQDVA.QUYETDINHID
                                           LEFT JOIN DM_QD_LOAI                          QDL ON QDL.ID = QD.LOAIID
                                           WHERE PTBA.VUANID IS NULL
                                                 AND PTQDVA.VUANID = P_VUVIECID
                                                 AND QD.KET_THUC = 1 
                                                 AND v_maGiaiDoan = 7
                              )
                              OR EXISTS ( SELECT 'X'
                                           FROM AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN PTQDVA
                                           LEFT JOIN DM_QD_QUYETDINH                     QD ON QD.ID = PTQDVA.QUYETDINHID
                                           LEFT JOIN DM_QD_LOAI                          QDL ON QDL.ID = QD.LOAIID
                                           WHERE QDL.MA in ('DC','CVA','TRAHS')
                                                 AND PTQDVA.VUANID = P_VUVIECID 
                                                 AND v_maGiaiDoan = 7
                              )
                               ) THEN 7
                          ELSE NULL
                      END
                  WHEN p_VUVIECLOAI = 'AN_DANSU' THEN 
                      CASE 
                          WHEN (EXISTS (
                                  SELECT 1 FROM ADS_SOTHAM_BANAN BA
                                  WHERE BA.SOBANAN IS NOT NULL AND BA.DONID = P_VUVIECID  AND v_maGiaiDoan = 2
                                )
                                OR EXISTS (
                                  SELECT 1 FROM ADS_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID 
                                  WHERE QD.KET_THUC = 1 AND QD.ISSOTHAM = 1 AND QD.ISDANSU = 1 AND QSV.DONID = P_VUVIECID  AND v_maGiaiDoan = 2
                                )
                                OR EXISTS ( 
                                  SELECT 1 FROM ADS_PHUCTHAM_BANAN PTBA 
                                  WHERE PTBA.SOBANAN IS NOT NULL AND PTBA.DONID = P_VUVIECID AND v_maGiaiDoan = 3
                                )
                                OR EXISTS ( 
                                  SELECT 1 FROM ADS_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID 
                                  WHERE QD.KET_THUC = 1 AND QD.ISPHUCTHAM = 1 AND QD.ISDANSU = 1 AND PTQDVA.DONID = P_VUVIECID AND v_maGiaiDoan = 3
                                )
            					          OR EXISTS ( 
                                  SELECT 1 FROM ADS_DON_XULY ADX 
                                  WHERE ADX.LOAIGIAIQUYET IN (1, 3) AND ADX.DONID = P_VUVIECID AND v_maGiaiDoan = 2
                                )
                                OR EXISTS (
                                   SELECT 'X' FROM ADS_KCKNQDK_PHUCTHAM_QUYETDINH   PTQDVA
                                              LEFT JOIN DM_QD_QUYETDINH                  QD ON QD.ID = PTQDVA.QUYETDINHID
                                              LEFT JOIN DM_QD_LOAI                       QDL ON QDL.ID = QD.LOAIID
                                   WHERE
                                      QD.MA IN (
                                          '69-DS',
                                          '70-DS',
                                          '72-DS'
                                      )
                                      AND PTQDVA.DONID = P_VUVIECID
                                      AND v_maGiaiDoan = 7
                                      OR instr(',CNTT,',','||QDL.MA||',')>0
                               )
                               OR EXISTS(
                                    SELECT 'X' FROM ADS_KCKNQDK_PHUCTHAM_QUYETDINH   PTQDVA --QUYẾT ĐỊNH 
                                      LEFT JOIN ADS_KCKNQDK_PHUCTHAM_THULY       PTTL ON PTTL.DONID = PTQDVA.DONID
                                      LEFT JOIN ADS_PHUCTHAM_BANAN               PTBA ON PTBA.DONID = PTTL.DONID --BẢN ÁN 
                                      LEFT JOIN DM_QD_QUYETDINH                  QD ON QD.ID = PTQDVA.QUYETDINHID
                                      LEFT JOIN DM_QD_LOAI                       QDL ON QDL.ID = QD.LOAIID
                                  WHERE
                                      PTBA.DONID IS NULL
                                      AND PTQDVA.DONID = P_VUVIECID
                                      AND v_maGiaiDoan = 7
                                      AND QD.KET_THUC = 1
                                )
                               OR EXISTS(
                                    SELECT 'X' FROM ADS_KCKNQDK_PHUCTHAM_QUYETDINH   PTQDVA
                                      LEFT JOIN DM_QD_QUYETDINH                  QD ON QD.ID = PTQDVA.QUYETDINHID
                                      LEFT JOIN DM_QD_LOAI                       QDL ON QDL.ID = QD.LOAIID
                                    WHERE
                                        INSTR(',DC,', ',' || QDL.MA || ',') > 0
                                        AND PTQDVA.DONID = P_VUVIECID
                                        AND v_maGiaiDoan = 7
                               )
                               OR EXISTS ( 
                                   SELECT 1 FROM ADS_DON_XULY ADX 
                                   WHERE ADX.LOAIGIAIQUYET IN (1, 3)
                                      AND ADX.DONID = P_VUVIECID AND v_maGiaiDoan = 7
                               )
                                ) THEN 7
                          ELSE NULL
                      END
                  WHEN p_VUVIECLOAI = 'AN_HNGD' THEN 
                      CASE 
                          WHEN (EXISTS (
                                  SELECT 1 FROM AHN_SOTHAM_BANAN BA
                                  WHERE BA.SOBANAN IS NOT NULL AND BA.DONID = P_VUVIECID AND v_maGiaiDoan = 2
                                )
                                OR EXISTS ( 
                                  SELECT 1 FROM AHN_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID 
                                  WHERE QD.KET_THUC = 1 AND QD.ISSOTHAM = 1 AND QD.ISHNGD = 1 AND QSV.DONID = P_VUVIECID AND v_maGiaiDoan = 2
                                )
                                OR EXISTS ( 
                                  SELECT 1 FROM AHN_PHUCTHAM_BANAN PTBA 
                                  WHERE PTBA.SOBANAN IS NOT NULL AND PTBA.DONID = P_VUVIECID AND v_maGiaiDoan = 3
                                )
                                OR EXISTS ( 
                                  SELECT 1 FROM AHN_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID 
                                  WHERE QD.KET_THUC = 1 AND QD.ISPHUCTHAM = 1 AND QD.ISHNGD = 1 AND PTQDVA.DONID = P_VUVIECID AND v_maGiaiDoan = 3
                                )       
                                OR EXISTS ( 
                                  SELECT 1 FROM AHN_DON_XULY ADX 
                                  WHERE ADX.LOAIGIAIQUYET IN (1, 3) AND ADX.DONID = P_VUVIECID AND v_maGiaiDoan = 2 
                                )
                                OR EXISTS (
                                  SELECT 'X' FROM AHN_KCKNQDK_PHUCTHAM_QUYETDINH   PTQDVA
                                             LEFT JOIN DM_QD_QUYETDINH                  QD ON QD.ID = PTQDVA.QUYETDINHID
                                             LEFT JOIN DM_QD_LOAI                       QDL ON QDL.ID = QD.LOAIID
                                  WHERE
                                    INSTR(',DC,', ',' || QDL.MA || ',') > 0
                                    AND QD.MA IN ('69-DS',
                                                  '70-DS',
                                                  '72-DS')
                                    AND PTQDVA.DONID = P_VUVIECID
                                    AND v_maGiaiDoan = 7
                                )
                                OR EXISTS(
                                  SELECT 'X' FROM AHN_KCKNQDK_PHUCTHAM_QUYETDINH   PTQDVA --QUYẾT ĐỊNH 
                                             LEFT JOIN AHN_KCKNQDK_PHUCTHAM_THULY       PTTL ON PTTL.DONID = PTQDVA.DONID
                                             LEFT JOIN AHN_PHUCTHAM_BANAN               PTBA ON PTBA.DONID = PTTL.DONID --BẢN ÁN 
                                             LEFT JOIN DM_QD_QUYETDINH                  QD ON QD.ID = PTQDVA.QUYETDINHID
                                             LEFT JOIN DM_QD_LOAI                       QDL ON QDL.ID = QD.LOAIID
                                  WHERE
                                      PTBA.DONID IS NULL
                                      AND PTQDVA.DONID = P_VUVIECID
                                      AND v_maGiaiDoan = 7
                                )
                                OR EXISTS(
                                  SELECT 'X' FROM AHN_KCKNQDK_PHUCTHAM_QUYETDINH   PTQDVA
                                        LEFT JOIN DM_QD_QUYETDINH                  QD ON QD.ID = PTQDVA.QUYETDINHID
                                        LEFT JOIN DM_QD_LOAI                       QDL ON QDL.ID = QD.LOAIID
                                  WHERE
                                      INSTR(',DC,', ',' || QDL.MA || ',') > 0
                                      AND PTQDVA.DONID = P_VUVIECID
                                      AND v_maGiaiDoan = 7
                                )
                            ) THEN 7
                          ELSE NULL
                      END
                  WHEN p_VUVIECLOAI = 'AN_KDTM' THEN 
                      CASE 
                          WHEN (EXISTS (
                                  SELECT 1 FROM AKT_SOTHAM_BANAN BA
                                  WHERE BA.SOBANAN IS NOT NULL AND BA.DONID = P_VUVIECID AND v_maGiaiDoan = 2
                                )
                                OR EXISTS ( 
                                  SELECT 1 FROM AKT_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID 
                                  WHERE QD.KET_THUC = 1 AND QD.ISSOTHAM = 1 AND QD.ISKDTM = 1 AND QSV.DONID = P_VUVIECID AND v_maGiaiDoan = 2
                                )
                                OR EXISTS ( 
                                  SELECT 1 FROM AKT_PHUCTHAM_BANAN PTBA 
                                  WHERE PTBA.SOBANAN IS NOT NULL AND PTBA.DONID = P_VUVIECID AND v_maGiaiDoan = 3
                                )
                                OR EXISTS ( 
                                  SELECT 1 FROM AKT_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID 
                                  WHERE QD.KET_THUC = 1 AND QD.ISPHUCTHAM = 1 AND QD.ISKDTM = 1 AND PTQDVA.DONID = P_VUVIECID AND v_maGiaiDoan = 3
                                )       
                                OR EXISTS ( 
                                  SELECT 1 FROM AKT_DON_XULY ADX 
                                  WHERE ADX.LOAIGIAIQUYET IN (1, 3) AND ADX.DONID = P_VUVIECID AND v_maGiaiDoan = 2 
                                )
                                OR EXISTS (
                                  SELECT 'X' FROM AKT_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
                                        LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                    WHERE
                                        QD.MA IN ('69-DS','70-DS','72-DS')
                                        AND PTQDVA.DONID = P_VUVIECID
                                        AND v_maGiaiDoan = 7
                                )
                                OR EXISTS(
                                  SELECT 'X' FROM AKT_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
                                        LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                        LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                  WHERE
                                      INSTR(',DC,', ',' || QDL.MA || ',') > 0
                                      AND PTQDVA.DONID = P_VUVIECID
                                      AND v_maGiaiDoan = 7
                                )
                                OR EXISTS(
                                  SELECT 'X' FROM AKT_KCKNQDK_PHUCTHAM_QUYETDINH   PTQDVA --QUYẾT ĐỊNH 
                                          LEFT JOIN AKT_KCKNQDK_PHUCTHAM_THULY       PTTL ON PTTL.DONID = PTQDVA.DONID
                                          LEFT JOIN AKT_PHUCTHAM_BANAN               PTBA ON PTBA.DONID = PTTL.DONID --BẢN ÁN 
                                          LEFT JOIN DM_QD_QUYETDINH                  QD ON QD.ID = PTQDVA.QUYETDINHID
                                          LEFT JOIN DM_QD_LOAI                       QDL ON QDL.ID = QD.LOAIID
                                      WHERE
                                          PTBA.DONID IS NULL
                                          AND PTQDVA.DONID = P_VUVIECID
                                          AND v_maGiaiDoan = 7
                                          AND QD.KET_THUC = 1
                               )
                               OR EXISTS ( 
                                SELECT 1 
        												FROM AKT_DON_XULY ADX 
        												WHERE ADX.LOAIGIAIQUYET IN (1, 3)
        													AND ADX.DONID = P_VUVIECID AND v_maGiaiDoan = 7  
                              )
                            ) THEN 7
                          ELSE NULL
                      END
                  WHEN p_VUVIECLOAI = 'AN_LAODONG' THEN 
                      CASE 
                          WHEN (EXISTS (
                                  SELECT 1 FROM ALD_SOTHAM_BANAN BA
                                  WHERE BA.SOBANAN IS NOT NULL AND BA.DONID = P_VUVIECID AND v_maGiaiDoan = 2
                                )
                                OR EXISTS ( 
                                  SELECT 1 FROM ALD_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID 
                                  WHERE QD.KET_THUC = 1 AND QD.ISSOTHAM = 1 AND QD.ISLAODONG = 1 AND QSV.DONID = P_VUVIECID AND v_maGiaiDoan = 2
                                )
                                OR EXISTS ( 
                                  SELECT 1 FROM ALD_PHUCTHAM_BANAN PTBA 
                                  WHERE PTBA.SOBANAN IS NOT NULL AND PTBA.DONID = P_VUVIECID AND v_maGiaiDoan = 3
                                )
                                OR EXISTS ( 
                                  SELECT 1 FROM ALD_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID 
                                  WHERE QD.KET_THUC = 1 AND QD.ISPHUCTHAM = 1 AND QD.ISLAODONG = 1 AND PTQDVA.DONID = P_VUVIECID AND v_maGiaiDoan = 3
                                )       
                                OR EXISTS ( 
                                  SELECT 1 FROM ALD_DON_XULY ADX 
                                  WHERE ADX.LOAIGIAIQUYET IN (1, 3) AND ADX.DONID = P_VUVIECID AND v_maGiaiDoan = 2 
                                )
                                OR EXISTS (
                                    SELECT 'X'
                                    FROM
                                        ALD_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
                                        LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                    WHERE
                                        QD.MA IN ('69-DS','70-DS','72-DS')
                                        AND PTQDVA.DONID = P_VUVIECID
                                        AND v_maGiaiDoan = 7
                                )
                                OR EXISTS(
                                    SELECT 'X' FROM ALD_KCKNQDK_PHUCTHAM_QUYETDINH   PTQDVA --QUYẾT ĐỊNH 
                                      LEFT JOIN ALD_KCKNQDK_PHUCTHAM_THULY       PTTL ON PTTL.DONID = PTQDVA.DONID
                                      LEFT JOIN ALD_PHUCTHAM_BANAN               PTBA ON PTBA.DONID = PTTL.DONID --BẢN ÁN 
                                      LEFT JOIN DM_QD_QUYETDINH                  QD ON QD.ID = PTQDVA.QUYETDINHID
                                      LEFT JOIN DM_QD_LOAI                       QDL ON QDL.ID = QD.LOAIID
                                  WHERE
                                      PTBA.DONID IS NULL
                                      AND PTQDVA.DONID = P_VUVIECID
                                      AND v_maGiaiDoan = 7
                                      AND QD.KET_THUC = 1
                                )
                                OR EXISTS(
                                    SELECT 'X'
                                    FROM
                                        ALD_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
                                        LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                        LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                    WHERE
                                        INSTR(',DC,', ',' || QDL.MA || ',') > 0
                                        AND PTQDVA.DONID = P_VUVIECID
                                        AND v_maGiaiDoan = 7
                                )
                                OR EXISTS ( 
                                    SELECT 1 
              											FROM ALD_DON_XULY ADX 
              											WHERE ADX.LOAIGIAIQUYET IN (1, 3)
              												AND ADX.DONID = P_VUVIECID 
                                      AND v_maGiaiDoan = 7
                                )
                            ) THEN 7
                          ELSE NULL
                      END
                  WHEN p_VUVIECLOAI = 'AN_HANHCHINH' THEN 
                      CASE 
                          WHEN (EXISTS (
                                  SELECT 1 FROM AHC_SOTHAM_BANAN BA
                                  WHERE BA.SOBANAN IS NOT NULL AND BA.DONID = P_VUVIECID AND v_maGiaiDoan = 2
                                )
                                OR EXISTS ( 
                                  SELECT 1 FROM AHC_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID 
                                  WHERE QD.KET_THUC = 1 AND QD.ISSOTHAM = 1 AND QD.ISHANHCHINH = 1 AND QSV.DONID = P_VUVIECID AND v_maGiaiDoan = 2
                                )
                                OR EXISTS ( 
                                  SELECT 1 FROM AHC_PHUCTHAM_BANAN PTBA 
                                  WHERE PTBA.SOBANAN IS NOT NULL AND PTBA.DONID = P_VUVIECID AND v_maGiaiDoan = 3
                                )
                                OR EXISTS ( 
                                  SELECT 1 FROM AHC_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID 
                                  WHERE QD.KET_THUC = 1 AND QD.ISPHUCTHAM = 1 AND QD.ISHANHCHINH = 1 AND PTQDVA.DONID = P_VUVIECID AND v_maGiaiDoan = 3
                                )       
                                OR EXISTS ( 
                                  SELECT 1 FROM AHC_DON_XULY ADX 
                                  WHERE ADX.LOAIGIAIQUYET IN (1, 3) AND ADX.DONID = P_VUVIECID AND v_maGiaiDoan = 2 
                                )
                                OR EXISTS ( 
                                  SELECT 'X' FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
                                             LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID
                                  WHERE QD.MA IN ( '14-HC', '15-HC', '40-HC', '41-HC', '43-HC' ) AND
                                        PTQDVA.DONID = P_VUVIECID
                                )
                            ) THEN 7
                          ELSE NULL
                      END
                    WHEN p_VUVIECLOAI = 'BPXLHC' THEN 
                       CASE 
                          WHEN (EXISTS (
                                  SELECT 1 FROM XLHC_SOTHAM_BANAN BA
                                  WHERE BA.SOBANAN IS NOT NULL AND BA.DONID = P_VUVIECID AND v_maGiaiDoan = 2
                                )
                                OR EXISTS ( 
                                  SELECT 1 FROM XLHC_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID 
                                  WHERE QD.KET_THUC = 1 AND QD.ISSOTHAM = 1 AND QD.ISXLHC = 1 AND QSV.DONID = P_VUVIECID AND v_maGiaiDoan = 2
                                )
                                OR EXISTS ( 
                                  SELECT 1 FROM XLHC_PHUCTHAM_BANAN PTBA 
                                  WHERE PTBA.SOBANAN IS NOT NULL AND PTBA.DONID = P_VUVIECID AND v_maGiaiDoan = 3
                                )
                                OR EXISTS ( 
                                  SELECT 1 FROM XLHC_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID 
                                  WHERE QD.KET_THUC = 1 AND QD.ISPHUCTHAM = 1 AND QD.ISXLHC = 1 AND PTQDVA.DONID = P_VUVIECID AND v_maGiaiDoan = 3
                                )       
                                OR EXISTS ( 
                                  SELECT 1 FROM XLHC_DON_XULY ADX 
                                  WHERE ADX.LOAIGIAIQUYET IN (1, 3) AND ADX.DONID = P_VUVIECID AND v_maGiaiDoan = 2 
                                )
                                OR EXISTS ( SELECT 1 
                                  FROM XLHC_SOTHAM_BANAN STBA
                                  WHERE STBA.DONID = P_VUVIECID AND v_maGiaiDoan = 2
                                 )
                                 OR EXISTS ( SELECT 1 
                                  FROM XLHC_PHUCTHAM_BANAN PTBA
                                  WHERE PTBA.DONID = P_VUVIECID AND v_maGiaiDoan = 3
                                 )
                                 OR EXISTS ( SELECT 'X'
                                   FROM XLHC_KCKNQDK_PHUCTHAM_QUYETDINH   PTQDVA
                                   LEFT JOIN DM_QD_QUYETDINH                  QD ON QD.ID = PTQDVA.QUYETDINHID
                                   LEFT JOIN DM_QD_LOAI                       QDL ON QDL.ID = QD.LOAIID
                                   WHERE
                                        QD.MA IN (
                                            '69-DS',
                                            '70-DS',
                                            '72-DS'
                                        )
                                        AND PTQDVA.DONID = P_VUVIECID
                                        AND v_maGiaiDoan = 7
                                        OR instr(',CNTT,',','||QDL.MA||',')>0
                                  )
                                  OR EXISTS( SELECT 'X' 
                                    FROM XLHC_KCKNQDK_PHUCTHAM_QUYETDINH   PTQDVA --QUYẾT ĐỊNH 
                                    LEFT JOIN XLHC_KCKNQDK_PHUCTHAM_THULY       PTTL ON PTTL.DONID = PTQDVA.DONID
                                    LEFT JOIN XLHC_PHUCTHAM_BANAN               PTBA ON PTBA.DONID = PTTL.DONID --BẢN ÁN 
                                    LEFT JOIN DM_QD_QUYETDINH                  QD ON QD.ID = PTQDVA.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI                       QDL ON QDL.ID = QD.LOAIID
                                    WHERE
                                      PTBA.DONID IS NULL
                                      AND PTQDVA.DONID = P_VUVIECID
                                      AND v_maGiaiDoan = 7
                                      AND QD.KET_THUC = 1
                                  )
                                  OR EXISTS( SELECT 'X'
                                    FROM XLHC_KCKNQDK_PHUCTHAM_QUYETDINH   PTQDVA
                                    LEFT JOIN DM_QD_QUYETDINH                  QD ON QD.ID = PTQDVA.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI                       QDL ON QDL.ID = QD.LOAIID
                                    WHERE
                                      INSTR(',DC,', ',' || QDL.MA || ',') > 0
                                      AND PTQDVA.DONID = P_VUVIECID
                                      AND v_maGiaiDoan = 7
                                   )
                                   OR EXISTS ( SELECT 1 
                                    FROM XLHC_DON_XULY ADX 
                                    WHERE ADX.LOAIGIAIQUYET IN (1, 3)
                  												AND ADX.DONID = P_VUVIECID  AND v_maGiaiDoan = 7
                  								 )
                                   OR EXISTS ( SELECT 1 
                                    FROM XLHC_PHUCTHAM_BANAN PTBA
                                    WHERE PTBA.DONID = P_VUVIECID AND v_maGiaiDoan = 7
                                   )
                            ) THEN 7
                          ELSE NULL
                      END
                  ELSE NULL
              END 
              ),
              v_maGiaiDoan
          );
          
          COMMIT;
          EXCEPTION
          WHEN OTHERS THEN
              -- Rollback in case of any exception
              ROLLBACK;

              v_output := 'Finish procedure Due to Exception: Error:' || SQLCODE || ',' || SQLERRM;
              PKG_TRACELOG.SP_INSERT_LOG_ERROR(
                  p_functionname => 'PKG_BAN_GIAO_AN.VUAN_BANGIAO_MAPPING_ADD',
                  p_description => v_output,
                  p_notes => v_tracedata
              );

              -- Re-raise the exception
              RAISE;
      END VUAN_BANGIAO_MAPPING_ADD;
        
    PROCEDURE VUAN_BANGIAO_MAPPING_EDIT (
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
        v_tracedata VARCHAR2(1024);
        v_output VARCHAR2(512);
      BEGIN
        v_tracedata := '(' || 
         'p_ID => ' || p_ID || ',' ||
         'p_TOAANGIAOID => ' || p_TOAANGIAOID || ',' ||
         'p_TOAANGIAOTEN => ' || p_TOAANGIAOTEN || ',' ||
         'p_TOAANNHANID => ' || p_TOAANNHANID || ',' ||
         'p_TOAANNHANTEN => ' || p_TOAANNHANTEN || ',' ||
         'p_VUVIECID => ' || p_VUVIECID || ',' ||
         'p_VUVIECMA => ' || p_VUVIECMA || ',' ||
         'p_VUVIECTEN => ' || p_VUVIECTEN || ',' ||
         'p_NGUOIGIAOID => ' || p_NGUOIGIAOID || ',' ||
         'p_NGUOIGIAOTEN => ' || p_NGUOIGIAOTEN || ',' ||
         'p_NGUOINHANID => ' || p_NGUOINHANID || ',' ||
         'p_NGUOINHANTEN => ' || p_NGUOINHANTEN || ',' ||
         'p_LYDOMA => ' || p_LYDOMA || ',' ||
         'p_NGAYGIAO => ' || p_NGAYGIAO || ',' ||
         'p_ISQUYETDINHCHUYEN => ' || p_ISQUYETDINHCHUYEN || ',' ||
         'p_SOQUYETDINH => ' || p_SOQUYETDINH || ',' ||
         'p_NGAYQUYETDINH => ' || p_NGAYQUYETDINH || ',' ||
         'p_NGUOIKY => ' || p_NGUOIKY || ',' ||
         'p_TRANGTHAI => ' || p_TRANGTHAI || ',' ||
         'p_GHICHU => ' || p_GHICHU || ',' ||
         ' );';

          UPDATE VUAN_BANGIAO_MAPPING
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

              v_output := 'Finish procedure Due to Exception: Error:' || SQLCODE || ',' || SQLERRM;
              PKG_TRACELOG.SP_INSERT_LOG_ERROR(
                  p_functionname => 'PKG_BAN_GIAO_AN.VUAN_BANGIAO_MAPPING_EDIT',
                  p_description => v_output,
                  p_notes => v_tracedata
              );

              -- Re-raise the exception
              RAISE;
      END VUAN_BANGIAO_MAPPING_EDIT;
        
    PROCEDURE VUAN_BANGIAO_MAPPING_CHANGE_STATUS (
        p_ID        IN NUMBER,
        p_TRANGTHAI IN VARCHAR2
    ) AS
        v_tracedata VARCHAR2(1024);
        v_output VARCHAR2(512);
      BEGIN
        v_tracedata := '(' || 
         'p_ID => ' || p_ID || ',' ||
         'p_TRANGTHAI => ' || p_TRANGTHAI || ',' ||
         ' );';

          UPDATE VUAN_BANGIAO_MAPPING
          SET TRANGTHAI = p_TRANGTHAI
          WHERE ID = p_ID;
          
          COMMIT;
          EXCEPTION
          WHEN OTHERS THEN
              -- Rollback in case of any exception
              ROLLBACK;
              
              v_output := 'Finish procedure Due to Exception: Error:' || SQLCODE || ',' || SQLERRM;
              PKG_TRACELOG.SP_INSERT_LOG_ERROR(
                  p_functionname => 'PKG_BAN_GIAO_AN.VUAN_BANGIAO_MAPPING_CHANGE_STATUS',
                  p_description => v_output,
                  p_notes => v_tracedata
              );

              -- Re-raise the exception
              RAISE;
      END VUAN_BANGIAO_MAPPING_CHANGE_STATUS;
        
    PROCEDURE VUAN_BANGIAO_MAPPING_DELETE (
        p_ID  IN NUMBER
    ) AS
        v_tracedata VARCHAR2(1024);
        v_output VARCHAR2(512);
      BEGIN
        v_tracedata := '(' || 
         'p_ID => ' || p_ID || ',' ||
         ' );';

        DELETE FROM VUAN_BANGIAO_MAPPING
        WHERE ID = p_ID AND TRANGTHAI <> 'TTBG_DANHAN' ;
        
        COMMIT;
        EXCEPTION
        WHEN OTHERS THEN
          -- Rollback in case of any exception
          ROLLBACK;

          v_output := 'Finish procedure Due to Exception: Error:' || SQLCODE || ',' || SQLERRM;
          PKG_TRACELOG.SP_INSERT_LOG_ERROR(
              p_functionname => 'PKG_BAN_GIAO_AN.VUAN_BANGIAO_MAPPING_DELETE',
              p_description => v_output,
              p_notes => v_tracedata
          );

          -- Re-raise the exception
          RAISE;
      END VUAN_BANGIAO_MAPPING_DELETE;
        
   -- [AHC] LẤY DANH SÁCH CÓ THỂ BÀN GIAO
    PROCEDURE AHC_VUAN_BANGIAO_MAPPING_GET_AN_BAN_GIAO (
        p_LOAIANID IN varchar2,
        p_TOAANID IN NUMBER,
        p_MAVUVIEC IN varchar2,
        p_THULYTUNGAY IN date,
        p_THULYDENNGAY IN date,
        p_TINHTRANGTHULY IN nvarchar2,
        p_THAMPHANGIAIQUYET IN nvarchar2,
        p_TENVUAN IN nvarchar2,    
        p_TRANGTHAIGIAIQUYET IN nvarchar2,    
        p_CAPXETXU IN nvarchar2,  
        p_TRANGTHAI IN NVARCHAR2,
        p_CURSOR OUT SYS_REFCURSOR
    ) AS
        /*
        ================================================================================
        AHC VERSION WITH DUAL PROCEDURES ENABLED - COMPLETE DATASET:
        
        APPROACH: Sử dụng cả PKG_AHC_STPT_DS.AHC_DON_SEARCH_TURNING và PKG_STPT_AHC_GS.DON_SEARCH
        
        FEATURES:
        - PKG_AHC_STPT_DS.AHC_DON_SEARCH_TURNING: 27 columns, comprehensive AHC data
        - PKG_STPT_AHC_GS.DON_SEARCH: 33 parameters, validated mapping theo AHC_DON_BL.cs
        - Combined COUNTALL từ cả 2 procedures để có tổng số record chính xác
        - DISTINCT query để tránh duplicate records
        - Logic xử lý khác nhau theo p_TRANGTHAI:
          + TRANGTHAI = 0: Loại bỏ bản ghi đã có mapping với toaangiaoid = p_toaanid
          + TRANGTHAI = 1: Gọi procedures với p_TOAANID + TOTOAANID từ DM_TOAAN_TACH_NHAP_MAPPING
        
        EXECUTION FLOW:
        - CHECK p_TRANGTHAI value
        - IF TRANGTHAI = 1: Loop qua p_TOAANID + các TOTOAANID và gọi CẢ 2 procedures
        - IF TRANGTHAI = 0/NULL: Gọi CẢ 2 procedures với p_TOAANID thông thường  
        - Final: Combine và return complete dataset với accurate COUNTALL
        - Note: Procedure này trả về vụ án phúc thẩm (MAGIAIDOAN=7) từ nhiều nguồn
        ================================================================================
        */
        
        TOTALITEM                   NUMBER;  
        MININDEX                    NUMBER; 
        MAXINDEX                    NUMBER; 
        V_TABLE_TIMKIEM             T_TIMKIEM_STPT_DS;
        
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
        
        FETCH_ID                VARCHAR2(255 CHAR);
        FETCH_MAVUVIEC          VARCHAR2(255 CHAR);
        FETCH_TENVUVIEC         VARCHAR2(4000 CHAR);
        FETCH_SOTHUTU           VARCHAR2(255 CHAR); 
        FETCH_NGAYNHANDON       VARCHAR2(255 CHAR);
        FETCH_HINHTHUCNHANDON   VARCHAR2(255 CHAR);
        FETCH_MAGIAIDOAN        VARCHAR2(255 CHAR);  
        FETCH_QHPLTKID          VARCHAR2(255 CHAR);
        FETCH_TOAANID           VARCHAR2(25 CHAR);
        FETCH_QUANHEPL          VARCHAR2(4000 CHAR);
        FETCH_BANAN_QD_ST       VARCHAR2(4000 CHAR);
        FETCH_QD_PT             VARCHAR2(4000 CHAR);
        FETCH_KHANGNGHI_ST      VARCHAR2(4000 CHAR);
        FETCH_CHECK_THULY       VARCHAR2(1000 CHAR);
        FETCH_HOTENBICAN        VARCHAR2(4000 CHAR);
        FETCH_COUNTALL          VARCHAR2(255 CHAR);
        FETCH_STT               VARCHAR2(1000 CHAR);
        FETCH_NGUOITAO          VARCHAR2(255 CHAR);
        FETCH_NGAY_TAO          VARCHAR2(255 CHAR);
        FETCH_NGAYTAO           VARCHAR2(255 CHAR);
        FETCH_TENTOASOTHAM      VARCHAR2(1000 CHAR);
        FETCH_GIAIDOANVUVIEC    VARCHAR2(255 CHAR);
        FETCH_TRUONGHOPGIAONHAN VARCHAR2(4000 CHAR);
        FETCH_KHANGCAO_ST       VARCHAR2(4000 CHAR);
        FETCH_TINHTRANG_GQ      VARCHAR2(4000 CHAR);
        FETCH_THULYXXLAI        VARCHAR2(1000 CHAR);
        FETCH_THAMPHANHG        VARCHAR2(4000 CHAR);  -- Cột thứ 27 cho AHC procedure
        
        SUM_COUNTALL            NUMBER DEFAULT 0;
        CURSOR_RETURN           SYS_REFCURSOR;
        CURSOR_RETURN2           SYS_REFCURSOR;
        
        -- PROCESS_CURSOR: Xử lý cursor và capture COUNTALL từ record đầu tiên
        PROCEDURE PROCESS_CURSOR(P_CUR IN SYS_REFCURSOR, P_TYPE VARCHAR2, P_VAR NUMBER, P_TOAANID VARCHAR2) IS
            V_IS_FIRST_RECORD BOOLEAN := TRUE;
        BEGIN
            LOOP
                BEGIN
                    IF P_VAR = 1 THEN
                        -- FETCH cho PKG_STPT_AHC_GS.DON_SEARCH (23 cột) - Fixed với đúng 33 parameters
                        FETCH P_CUR INTO FETCH_STT, FETCH_COUNTALL, FETCH_ID, FETCH_MAVUVIEC, 
                          FETCH_TENVUVIEC, FETCH_SOTHUTU, FETCH_NGAYNHANDON, FETCH_NGUOITAO, 
                          FETCH_NGAYTAO, FETCH_QUANHEPL, FETCH_TENTOASOTHAM, FETCH_GIAIDOANVUVIEC,
                          FETCH_HINHTHUCNHANDON, FETCH_TRUONGHOPGIAONHAN, FETCH_BANAN_QD_ST, 
                          FETCH_QD_PT, FETCH_KHANGNGHI_ST, FETCH_KHANGCAO_ST, FETCH_MAGIAIDOAN,
                          FETCH_HOTENBICAN, FETCH_TINHTRANG_GQ, FETCH_CHECK_THULY, FETCH_THULYXXLAI;
                    
                        EXIT WHEN P_CUR%NOTFOUND;
                        
                        -- Capture COUNTALL từ record đầu tiên của procedure 2
                        IF V_IS_FIRST_RECORD THEN
                            V_COUNTALL_PROC2 := TO_NUMBER(FETCH_COUNTALL);
                            V_IS_FIRST_RECORD := FALSE;
                        END IF;
                        
                        -- Gán giá trị cho các trường bị thiếu
                        FETCH_QHPLTKID := '';
                        FETCH_TOAANID := P_TOAANID;
                        FETCH_NGAY_TAO := FETCH_NGAYTAO;
                    ELSE
                        -- FETCH cho PKG_AHC_STPT_DS.AHC_DON_SEARCH_TURNING (27 cột, thứ tự: ID, MAVUVIEC...)
                        FETCH P_CUR INTO FETCH_ID, FETCH_MAVUVIEC, FETCH_TENVUVIEC, FETCH_SOTHUTU, 
                          FETCH_NGAYNHANDON, FETCH_HINHTHUCNHANDON, FETCH_MAGIAIDOAN, FETCH_QHPLTKID,
                          FETCH_TOAANID, FETCH_QUANHEPL, FETCH_BANAN_QD_ST, FETCH_QD_PT,
                          FETCH_KHANGNGHI_ST, FETCH_CHECK_THULY, FETCH_HOTENBICAN, FETCH_COUNTALL, 
                          FETCH_STT, FETCH_NGAY_TAO, FETCH_NGUOITAO, FETCH_NGAYTAO, FETCH_TENTOASOTHAM, 
                          FETCH_GIAIDOANVUVIEC, FETCH_TRUONGHOPGIAONHAN, FETCH_KHANGCAO_ST,
                          FETCH_TINHTRANG_GQ, FETCH_THULYXXLAI, FETCH_THAMPHANHG;
                    
                        EXIT WHEN P_CUR%NOTFOUND;
                        
                        -- Capture COUNTALL từ record đầu tiên của procedure 1
                        IF V_IS_FIRST_RECORD THEN
                            V_COUNTALL_PROC1 := TO_NUMBER(FETCH_COUNTALL);
                            V_IS_FIRST_RECORD := FALSE;
                        END IF;
                    END IF;
                    
                    -- Phần xử lý chung vẫn giữ nguyên
                    V_TABLE_TIMKIEM.EXTEND;
                    V_TABLE_TIMKIEM(V_TABLE_TIMKIEM.COUNT) := R_TIMKIEM_STPT_DS(
                        FETCH_ID, FETCH_MAVUVIEC, FETCH_TENVUVIEC, FETCH_SOTHUTU, FETCH_NGAYNHANDON, 
                        FETCH_HINHTHUCNHANDON, FETCH_MAGIAIDOAN, FETCH_QHPLTKID, FETCH_TOAANID, 
                        FETCH_QUANHEPL, FETCH_BANAN_QD_ST, FETCH_QD_PT, FETCH_KHANGNGHI_ST, 
                        FETCH_CHECK_THULY, FETCH_HOTENBICAN, FETCH_COUNTALL, FETCH_STT, FETCH_NGAY_TAO,
                        FETCH_NGUOITAO, FETCH_NGAYTAO, FETCH_TENTOASOTHAM, FETCH_GIAIDOANVUVIEC,
                        FETCH_TRUONGHOPGIAONHAN, FETCH_KHANGCAO_ST, FETCH_TINHTRANG_GQ, FETCH_THULYXXLAI, P_TYPE
                    );
                END;
            END LOOP;
        END PROCESS_CURSOR;
    BEGIN
        
        -- Set fixed pagesize for optimal performance
        V_PROCEDURE_PAGESIZE := V_OPTIMIZED_PAGESIZE;
        
        IF p_THULYTUNGAY IS NOT NULL THEN 
            V_THULYTUNGAY := TO_CHAR(p_THULYTUNGAY, 'DD/MM/YYYY');
        ELSE
            V_THULYTUNGAY := '';
        END IF;  
    
        IF p_THULYDENNGAY IS NOT NULL THEN  
            V_THULYDENNGAY := TO_CHAR(p_THULYDENNGAY, 'DD/MM/YYYY'); 
        ELSE
            V_THULYDENNGAY := '';
        END IF;

SELECT LOAITOA
  INTO V_CAP_XET_XU_LOGIN
  FROM DM_TOAAN
  WHERE 1 = 1
    AND ID = P_TOAANID;
        V_TABLE_TIMKIEM := T_TIMKIEM_STPT_DS();
        
        -- LOGIC XỬ LÝ THEO p_TRANGTHAI
        IF p_TRANGTHAI = 1 THEN
            -- TRANGTHAI = 1: Lấy dữ liệu từ các toà được bàn giao (bao gồm cả p_TOAANID gốc)
            FOR toaan_rec IN (
                SELECT p_TOAANID AS TOTOAANID FROM DUAL
                UNION ALL
                SELECT TOTOAANID FROM DM_TOAAN_TACH_NHAP_MAPPING WHERE TOAANID = p_TOAANID
            ) LOOP
                V_CURRENT_TOAANID := toaan_rec.TOTOAANID;
                V_TRANGTHAIGIAIQUYET := '';
                
                -- BƯỚC 1: PKG_AHC_STPT_DS.AHC_DON_SEARCH_TURNING procedure call
                PKG_AHC_STPT_DS.AHC_DON_SEARCH_TURNING(
                  V_CAP_XET_XU_LOGIN,
                  p_TENVUAN,
                  NULL,
                  p_MAVUVIEC,
                  NULL,
                  p_CAPXETXU,
                  V_CURRENT_TOAANID,
                  p_TINHTRANGTHULY,
                  V_THULYTUNGAY,
                  V_THULYDENNGAY,
                  NULL,
                  p_THAMPHANGIAIQUYET,
                  V_TRANGTHAIGIAIQUYET,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  0,
                  NULL,
                  NULL,
                  1,
                  1,
                  0,
                  0,
                  NULL,
                  NULL,
                  NULL, -- AN_DA_KET_THUC
                  1,
                  V_PROCEDURE_PAGESIZE,
                  CURSOR_RETURN
                );
                IF CURSOR_RETURN IS NOT NULL THEN
                    PROCESS_CURSOR(CURSOR_RETURN, '6', 0, V_CURRENT_TOAANID);
                    CLOSE CURSOR_RETURN;
                END IF;

                -- Không lấy án TĐC với cấp sơ thẩm
                IF P_CAPXETXU IS NULL OR p_CAPXETXU <> 2 THEN
                                                        
                  -- BƯỚC 2: PKG_STPT_AHC_GS.DON_SEARCH với đúng 33 parameters theo AHC_DON_BL.cs
                  PKG_STPT_AHC_GS.DON_SEARCH(
                      V_CAP_XET_XU_LOGIN,       -- 1. V_CAP_XET_XU_LOGIN
                      p_TENVUAN,                -- 2. V_TEN_VU_AN  
                      NULL,                     -- 3. V_QHPL
                      p_MAVUVIEC,              -- 4. V_MA_VU_AN
                      NULL,                     -- 5. V_TENDUONGSU
                      3,                        -- 6. V_CAPXX
                      V_CURRENT_TOAANID,       -- 7. V_TOAAN_ID
                      p_TINHTRANGTHULY,        -- 8. V_TINHTRANG_THULY
                      V_THULYTUNGAY,           -- 9. V_NGAYTHULY_TU
                      V_THULYDENNGAY,          -- 10. V_NGAYTHULY_DEN
                      NULL,                     -- 11. V_SOTHULY
                      p_THAMPHANGIAIQUYET,     -- 12. V_THAMPHAN_ID
                      P_TRANGTHAIGIAIQUYET,    -- 13. V_TINHTRANG_GIAIQUYET
                      NULL,                     -- 14. V_TUNGAY
                      NULL,                     -- 15. V_DENNGAY
                      NULL,                     -- 16. V_KETQUA
                      NULL,                     -- 17. V_SO_QD
                      NULL,                     -- 18. V_NGAY_QD
                      NULL,                     -- 19. V_THUKY_ID
                      NULL,                     -- 20. V_THOIHAN_GQ
                      NULL,                     -- 21. V_LOAIDON
                      NULL,                     -- 22. V_PT_RKINHNGHIEM
                      NULL,                     -- 23. V_GQDON
                      NULL,                     -- 24. V_UTTP
                      0,                        -- 25. VCHECKTK
                      0,                        -- 26. V_TRANGTHAIVUAN
                      NULL,                     -- 27. V_VAITRO_THAMPHAN
                      0,                        -- 28. V_CHECK_HOAGIAI
                      0,                        -- 29. V_HOAGIAI_TRANGTHAI
                      NULL,                     -- 30. V_HOAGIAI_TUNGAY
                      NULL,                     -- 31. V_HOAGIAI_DENNGAY
                      NULL, -- AN_DA_KET_THUC
                      1,                        -- 32. PAGE_INDEX
                      V_PROCEDURE_PAGESIZE,     -- 33. PAGE_SIZE
                      CURSOR_RETURN2            -- 34. CURRETURN (OUT)
                  );
                                                             
                  IF CURSOR_RETURN2 IS NOT NULL THEN
                      PROCESS_CURSOR(CURSOR_RETURN2, '6', 1, V_CURRENT_TOAANID);
                      CLOSE CURSOR_RETURN2;
                  END IF;
  
                  -- Bước 3: lấy dữ liệu chưa thụ lý với TRANGTHAIGIAIQUYET = ''
--                  IF (NVL(LENGTH(p_TINHTRANGTHULY),0) = 0) OR p_TINHTRANGTHULY = '2' THEN
--                      V_TRANGTHAIGIAIQUYET := '';
--                      V_TINHTRANGTHULY := '2';
--                      PKG_STPT_AHC_GS.DON_SEARCH(
--                        V_CAP_XET_XU_LOGIN,       -- 1. V_CAP_XET_XU_LOGIN
--                        p_TENVUAN,                -- 2. V_TEN_VU_AN  
--                        NULL,                     -- 3. V_QHPL
--                        p_MAVUVIEC,              -- 4. V_MA_VU_AN
--                        NULL,                     -- 5. V_TENDUONGSU
--                        3,                        -- 6. V_CAPXX
--                        V_CURRENT_TOAANID,       -- 7. V_TOAAN_ID
--                        V_TINHTRANGTHULY,        -- 8. V_TINHTRANG_THULY
--                        V_THULYTUNGAY,           -- 9. V_NGAYTHULY_TU
--                        V_THULYDENNGAY,          -- 10. V_NGAYTHULY_DEN
--                        NULL,                     -- 11. V_SOTHULY
--                        p_THAMPHANGIAIQUYET,     -- 12. V_THAMPHAN_ID
--                        V_TRANGTHAIGIAIQUYET,    -- 13. V_TINHTRANG_GIAIQUYET
--                        NULL,                     -- 14. V_TUNGAY
--                        NULL,                     -- 15. V_DENNGAY
--                        NULL,                     -- 16. V_KETQUA
--                        NULL,                     -- 17. V_SO_QD
--                        NULL,                     -- 18. V_NGAY_QD
--                        NULL,                     -- 19. V_THUKY_ID
--                        NULL,                     -- 20. V_THOIHAN_GQ
--                        NULL,                     -- 21. V_LOAIDON
--                        NULL,                     -- 22. V_PT_RKINHNGHIEM
--                        NULL,                     -- 23. V_GQDON
--                        NULL,                     -- 24. V_UTTP
--                        0,                        -- 25. VCHECKTK
--                        0,                        -- 26. V_TRANGTHAIVUAN
--                        NULL,                     -- 27. V_VAITRO_THAMPHAN
--                        0,                        -- 28. V_CHECK_HOAGIAI
--                        0,                        -- 29. V_HOAGIAI_TRANGTHAI
--                        NULL,                     -- 30. V_HOAGIAI_TUNGAY
--                        NULL,                     -- 31. V_HOAGIAI_DENNGAY
--                        1,                        -- 32. PAGE_INDEX
--                        V_PROCEDURE_PAGESIZE,     -- 33. PAGE_SIZE
--                        CURSOR_RETURN2            -- 34. CURRETURN (OUT)
--                    );
--                                                               
--                    IF CURSOR_RETURN2 IS NOT NULL THEN
--                        PROCESS_CURSOR(CURSOR_RETURN2, '6', 1, V_CURRENT_TOAANID);
--                        CLOSE CURSOR_RETURN2;
--                    END IF;
--                  END IF;

                END IF;
            END LOOP;
        ELSE
            -- TRANGTHAI = 0 hoặc NULL: Logic cũ với p_TOAANID
            -- BƯỚC 1: PKG_AHC_STPT_DS.AHC_DON_SEARCH_TURNING procedure call
            PKG_AHC_STPT_DS.AHC_DON_SEARCH_TURNING(
              V_CAP_XET_XU_LOGIN,
              p_TENVUAN,
              NULL,
              p_MAVUVIEC,
              NULL,
              p_CAPXETXU,
              p_TOAANID,
              p_TINHTRANGTHULY,
              V_THULYTUNGAY,
              V_THULYDENNGAY,
              NULL,
              p_THAMPHANGIAIQUYET,
              p_TRANGTHAIGIAIQUYET,
              NULL,
              NULL,
              NULL,
              NULL,
              NULL,
              NULL,
              NULL,
              NULL,
              NULL,
              NULL,
              NULL,
              0,
              NULL,
              NULL,
              1,
              1,
              0,
              0,
              NULL,
              NULL,
              NULL, -- AN_DA_KET_THUC
              1,
              V_PROCEDURE_PAGESIZE,
              CURSOR_RETURN
            );
            IF CURSOR_RETURN IS NOT NULL THEN
                PROCESS_CURSOR(CURSOR_RETURN, '6', 0, p_TOAANID);
                CLOSE CURSOR_RETURN;
            END IF;

            -- Không lấy án TĐC với cấp sơ thẩm
            IF (P_CAPXETXU IS NULL OR p_CAPXETXU <> 2) THEN
                                                    
              -- BƯỚC 2: PKG_STPT_AHC_GS.DON_SEARCH với đúng 33 parameters theo AHC_DON_BL.cs
              PKG_STPT_AHC_GS.DON_SEARCH(
                  V_CAP_XET_XU_LOGIN,       -- 1. V_CAP_XET_XU_LOGIN
                  p_TENVUAN,                -- 2. V_TEN_VU_AN  
                  NULL,                     -- 3. V_QHPL
                  p_MAVUVIEC,              -- 4. V_MA_VU_AN
                  NULL,                     -- 5. V_TENDUONGSU
                  3,                        -- 6. V_CAPXX
                  p_TOAANID,               -- 7. V_TOAAN_ID
                  p_TINHTRANGTHULY,        -- 8. V_TINHTRANG_THULY
                  V_THULYTUNGAY,           -- 9. V_NGAYTHULY_TU
                  V_THULYDENNGAY,          -- 10. V_NGAYTHULY_DEN
                  NULL,                     -- 11. V_SOTHULY
                  p_THAMPHANGIAIQUYET,     -- 12. V_THAMPHAN_ID
                  p_TRANGTHAIGIAIQUYET,    -- 13. V_TINHTRANG_GIAIQUYET
                  NULL,                     -- 14. V_TUNGAY
                  NULL,                     -- 15. V_DENNGAY
                  NULL,                     -- 16. V_KETQUA
                  NULL,                     -- 17. V_SO_QD
                  NULL,                     -- 18. V_NGAY_QD
                  NULL,                     -- 19. V_THUKY_ID
                  NULL,                     -- 20. V_THOIHAN_GQ
                  NULL,                     -- 21. V_LOAIDON
                  NULL,                     -- 22. V_PT_RKINHNGHIEM
                  NULL,                     -- 23. V_GQDON
                  NULL,                     -- 24. V_UTTP
                  0,                        -- 25. VCHECKTK
                  0,                        -- 26. V_TRANGTHAIVUAN
                  NULL,                     -- 27. V_VAITRO_THAMPHAN
                  0,                        -- 28. V_CHECK_HOAGIAI
                  0,                        -- 29. V_HOAGIAI_TRANGTHAI
                  NULL,                     -- 30. V_HOAGIAI_TUNGAY
                  NULL,                     -- 31. V_HOAGIAI_DENNGAY
                  NULL, -- AN_DA_KET_THUC
                  1,                        -- 32. PAGE_INDEX
                  V_PROCEDURE_PAGESIZE,     -- 33. PAGE_SIZE
                  CURSOR_RETURN2            -- 34. CURRETURN (OUT)
              );
                                                         
              IF CURSOR_RETURN2 IS NOT NULL THEN
                  PROCESS_CURSOR(CURSOR_RETURN2, '6', 1, p_TOAANID);
                  CLOSE CURSOR_RETURN2;
              END IF;
  
              -- Bước 3: lấy dữ liệu chưa thụ lý với TRANGTHAIGIAIQUYET = ''
              IF (NVL(LENGTH(p_TINHTRANGTHULY),0) = 0) OR p_TINHTRANGTHULY = '2' THEN
                  V_TRANGTHAIGIAIQUYET := '';
                  V_TINHTRANGTHULY := '2';

                  PKG_STPT_AHC_GS.DON_SEARCH(
                      V_CAP_XET_XU_LOGIN,       -- 1. V_CAP_XET_XU_LOGIN
                      p_TENVUAN,                -- 2. V_TEN_VU_AN  
                      NULL,                     -- 3. V_QHPL
                      p_MAVUVIEC,              -- 4. V_MA_VU_AN
                      NULL,                     -- 5. V_TENDUONGSU
                      3,                        -- 6. V_CAPXX
                      p_TOAANID,               -- 7. V_TOAAN_ID
                      V_TINHTRANGTHULY,        -- 8. V_TINHTRANG_THULY
                      V_THULYTUNGAY,           -- 9. V_NGAYTHULY_TU
                      V_THULYDENNGAY,          -- 10. V_NGAYTHULY_DEN
                      NULL,                     -- 11. V_SOTHULY
                      p_THAMPHANGIAIQUYET,     -- 12. V_THAMPHAN_ID
                      V_TRANGTHAIGIAIQUYET,    -- 13. V_TINHTRANG_GIAIQUYET
                      NULL,                     -- 14. V_TUNGAY
                      NULL,                     -- 15. V_DENNGAY
                      NULL,                     -- 16. V_KETQUA
                      NULL,                     -- 17. V_SO_QD
                      NULL,                     -- 18. V_NGAY_QD
                      NULL,                     -- 19. V_THUKY_ID
                      NULL,                     -- 20. V_THOIHAN_GQ
                      NULL,                     -- 21. V_LOAIDON
                      NULL,                     -- 22. V_PT_RKINHNGHIEM
                      NULL,                     -- 23. V_GQDON
                      NULL,                     -- 24. V_UTTP
                      0,                        -- 25. VCHECKTK
                      0,                        -- 26. V_TRANGTHAIVUAN
                      NULL,                     -- 27. V_VAITRO_THAMPHAN
                      0,                        -- 28. V_CHECK_HOAGIAI
                      0,                        -- 29. V_HOAGIAI_TRANGTHAI
                      NULL,                     -- 30. V_HOAGIAI_TUNGAY
                      NULL,                     -- 31. V_HOAGIAI_DENNGAY
                      NULL, -- AN_DA_KET_THUC
                      1,                        -- 32. PAGE_INDEX
                      V_PROCEDURE_PAGESIZE,     -- 33. PAGE_SIZE
                      CURSOR_RETURN2            -- 34. CURRETURN (OUT)
                  );
                                                             
                  IF CURSOR_RETURN2 IS NOT NULL THEN
                      PROCESS_CURSOR(CURSOR_RETURN2, '6', 1, p_TOAANID);
                      CLOSE CURSOR_RETURN2;
                  END IF;
              END IF;

            END IF;
        END IF;
        
        -- BƯỚC 3: Tính tổng COUNTALL thực tế từ cả 2 procedures
        V_REAL_COUNTALL := V_COUNTALL_PROC1 + V_COUNTALL_PROC2;
            
        -- BƯỚC 4: Final query với DISTINCT để loại bỏ duplicate (bỏ STT)
        OPEN p_CURSOR FOR
SELECT DISTINCT V_REAL_COUNTALL AS COUNTALL,
                A.ID,
                A.MAVUVIEC,
                A.TENVUVIEC,
                A.SOTHUTU,
                A.NGAYNHANDON,
                A.HINHTHUCNHANDON,
                A.MAGIAIDOAN,
                A.QHPLTKID,
                A.TOAANID,
                A.QUANHEPL,
                A.BANAN_QD_ST,
                A.QD_PT,
                A.KHANGNGHI_ST,
                A.CHECK_THULY,
                A.HOTENBICAN,
                A.NGUOITAO,
                A.NGAY_TAO AS NGAYTHULY,
                A.NGAYTAO,
                A.TENTOASOTHAM,
                A.GIAIDOANVUVIEC,
                A.TRUONGHOPGIAONHAN,
                A.KHANGCAO_ST,
                A.TINHTRANG_GQ,
                A.THULYXXLAI,
                A.LOAIAN_ID,
                LA.LOAI_AN_TEN,
                B.ID AS MAPPINGID,
                B.LYDOMA AS LYDO,
                B.NGAYGIAO AS THOIGIANBANGIAO,
                B.TRANGTHAI,
                C.TEN AS TOANHAN,
                LD.TEN AS LYDOTEN
  FROM TABLE (V_TABLE_TIMKIEM) A
    LEFT JOIN DM_LOAIAN LA
      ON LA.ID = A.LOAIAN_ID
    LEFT JOIN VUAN_BANGIAO_MAPPING B
      ON A.ID = B.VUVIECID
      AND b.TOAANGIAOID = P_TOAANID
      AND b.VUVIECLOAI = 'AN_HANHCHINH'
      AND (1 = (CASE 
                    WHEN P_TRANGTHAI = 0 THEN 1
                    WHEN P_TRANGTHAIGIAIQUYET IS NULL THEN 1
                    WHEN P_TRANGTHAIGIAIQUYET = 1 THEN 
                        CASE WHEN B.TRANGTHAIGIAIQUYET = 1 OR B.TRANGTHAIGIAIQUYET IS NULL THEN 1 ELSE 0 END
                    WHEN P_TRANGTHAIGIAIQUYET = 7 THEN 
                        CASE WHEN B.TRANGTHAIGIAIQUYET = 7 THEN 1 ELSE 0 END
                    ELSE 0
                END))
    LEFT JOIN DM_TOAAN C
      ON CASE WHEN b.TOAANNHANID IS NULL THEN 0 ELSE b.TOAANNHANID END = C.ID
    LEFT JOIN DM_DATAITEM ld
      ON b.LYDOMA = ld.MA
  WHERE 1 = 1
    -- Loại trừ những bản ghi mapping mà toà hiện tại đã nhận (TOAANNHANID = p_TOAANID)
    AND (B.TOAANNHANID IS NULL
    OR B.TOAANNHANID != P_TOAANID)
    AND (1 = (CASE
      -- TRANGTHAI = 0: Loại bỏ những bản ghi đã có mapping với toaangiaoid = p_toaanid
      WHEN P_TRANGTHAI = 0 THEN CASE WHEN NOT EXISTS (SELECT 1
                  FROM VUAN_BANGIAO_MAPPING vm
                  WHERE vm.VUVIECID = A.ID
                    AND vm.TOAANGIAOID = P_TOAANID
                    AND vm.VUVIECLOAI = 'AN_HANHCHINH') THEN 1 ELSE 0 END
      -- TRANGTHAI = 1: Chỉ lấy những bản ghi có mapping 
      WHEN P_TRANGTHAI = 1 AND
        B.TRANGTHAI IS NOT NULL THEN 1
      -- TRANGTHAI = NULL hoặc khác: Lấy tất cả
      WHEN P_TRANGTHAI IS NULL THEN 1 WHEN P_TRANGTHAI NOT IN (0, 1) THEN 1 ELSE 0 END))
  ORDER BY A.ID DESC,
           B.ID DESC;
    END AHC_VUAN_BANGIAO_MAPPING_GET_AN_BAN_GIAO;

   
   -- [AHC] LẤY DANH SÁCH CHỜ DUYỆT
    PROCEDURE AHC_VUAN_BANGIAO_MAPPING_GETS_CHONHAN (
        p_LOAIANID IN varchar2,
        p_TOAANID IN NUMBER,
        p_MAVUVIEC IN varchar2,
        p_THULYTUNGAY IN date,
        p_THULYDENNGAY IN date,
        p_TINHTRANGTHULY IN nvarchar2,
        p_THAMPHANGIAIQUYET IN nvarchar2,
        p_TENVUAN IN nvarchar2,    
        p_TRANGTHAIGIAIQUYET IN nvarchar2,    
        p_CAPXETXU IN nvarchar2,  
        p_TRANGTHAI IN NVARCHAR2,
        p_CURSOR OUT SYS_REFCURSOR
    ) AS
        BEGIN
            OPEN p_CURSOR FOR
                SELECT  
                    DISTINCT
                    -- Mapping
                    mapping.ID as MAPPINGID,
                    mapping.NGAYGIAO,
                    mapping.NGAYNHAN,
                    mapping.TRANGTHAI,
                    mapping.GHICHU,
                    -- Vụ việc
                    don.ID AS VUVIECID,
                    don.MAVUVIEC AS VUVIECMA,
                    don.TENVUVIEC AS VUVIECTEN, 
                    -- Toà giao
                    mapping.TOAANGIAOID,
                    taGiao.TEN AS TOAANGIAOTEN,
                    -- Toà nhận
                    mapping.TOAANNHANID,
                    -- Lý do
                    mapping.LYDOMA,
                    lyDo.TEN AS LYDOTEN
                from AHC_DON don 
                JOIN VUAN_BANGIAO_MAPPING mapping ON don.ID = mapping.VUVIECID AND MAPPING.VUVIECLOAI = 'AN_HANHCHINH'
                JOIN DM_TOAAN taGiao ON case when mapping.TOAANGIAOID is null then 0 else mapping.TOAANGIAOID end = taGiao.ID
                JOIN DM_TOAAN taNhan ON case when mapping.TOAANNHANID is null then 0 else mapping.TOAANNHANID end = taNhan.ID
                JOIN DM_DATAITEM lyDo ON mapping.LYDOMA = lyDo.MA
                LEFT JOIN AHC_SOTHAM_THULY thuLy ON don.ID = thuLy.DONID
                WHERE mapping.TOAANNHANID = P_TOAANID 
                AND  (1=(CASE WHEN (p_MAVUVIEC || ' ')=' '  THEN 1 WHEN LOWER(don.MAVUVIEC) LIKE  ('%' || LOWER(p_MAVUVIEC) || '%') THEN 1 Else 0 END))
                And (1=(CASE WHEN p_THULYTUNGAY is NULL THEN 1 WHEN thuLy.NGAYTHULY >= p_THULYTUNGAY  THEN 1 Else 0 END))
                And (1=(CASE WHEN p_THULYDENNGAY is NULL THEN 1 WHEN thuLy.NGAYTHULY <= p_THULYDENNGAY  THEN 1 Else 0 END))  
                AND  (1=(CASE WHEN (p_TINHTRANGTHULY|| ' ')=' '  THEN 1 WHEN LOWER(don.MAVUVIEC) LIKE  ('%' || LOWER(p_MAVUVIEC) || '%') THEN 1 Else 0 END))
                AND  (1=(CASE WHEN (p_THAMPHANGIAIQUYET|| ' ')=' '  THEN 1 WHEN LOWER(don.THAMPHANKYNHANDON) LIKE  ('%' || LOWER(p_THAMPHANGIAIQUYET) || '%') THEN 1 Else 0 END))
                AND  (1=(CASE WHEN (p_TENVUAN|| ' ')=' '  THEN 1 WHEN LOWER(don.TENVUVIEC) LIKE  ('%' || LOWER(p_TENVUAN) || '%') THEN 1 Else 0 END))
                --AND  (1=(CASE WHEN (p_TRANGTHAIGIAIQUYET|| ' ')=' ' THEN 1 WHEN don.TRANGTHAI LIKE P_TRANGTHAIGIAIQUYET THEN 1 Else 0 END))
                --AND  (1=(CASE WHEN (p_CAPXETXU|| ' ')=' '  THEN 1 WHEN don.MAGIAIDOAN = p_CAPXETXU THEN 1 Else 0 END))
                -- Trạng thái giải quyết
                AND (1 = (CASE 
                              WHEN P_TRANGTHAIGIAIQUYET IS NULL THEN 1
                              WHEN P_TRANGTHAIGIAIQUYET = '1' THEN 
                                  CASE WHEN MAPPING.TRANGTHAIGIAIQUYET = '1' OR MAPPING.TRANGTHAIGIAIQUYET IS NULL THEN 1 ELSE 0 END
                              WHEN P_TRANGTHAIGIAIQUYET = '7' THEN 
                                  CASE WHEN MAPPING.TRANGTHAIGIAIQUYET = '7' THEN 1 ELSE 0 END
                              ELSE 0
                          END))
                -- Cấp xét xử
                AND (1 = (CASE WHEN p_CAPXETXU IS NULL THEN 1
                            WHEN p_CAPXETXU = 2 AND mapping.MAGIAIDOAN = 2 THEN 1 -- Cap So Tham
                            WHEN p_CAPXETXU = 3 AND mapping.MAGIAIDOAN IN (3,7) THEN 1 -- Cap Phuc Tham
                            WHEN p_CAPXETXU NOT IN (2, 3) THEN 1
                            ELSE 0 END))
                AND  (1=(CASE WHEN (p_TRANGTHAI|| ' ')=' '  THEN 1 WHEN LOWER(mapping.TRANGTHAI) = LOWER(p_TRANGTHAI) THEN 1 Else 0 END))
                ORDER BY mapping.ID DESC;
    END AHC_VUAN_BANGIAO_MAPPING_GETS_CHONHAN;

    -- [AHC] NHẬN BÀN GIAO
    PROCEDURE AHC_VUAN_BANGIAO_MAPPING_NHAN (
        p_ID IN NUMBER,
        p_VUVIECID IN NUMBER,
        p_TOAANNHANID IN NUMBER,
        p_NGAYNHAN IN DATE
    ) AS
        v_MAGIAIDOAN NUMBER;
        v_TOAANID NUMBER;
        v_TOAPHUCTHAMID NUMBER;
        v_TRANGTHAIGIAIQUYET VARCHAR2(20);

        v_tracedata VARCHAR2(1024);
        v_output VARCHAR2(512);
    BEGIN
        -- Logs
        v_tracedata := '(' || 
         'p_ID => ' || p_ID || ',' ||
         'p_VUVIECID => ' || p_VUVIECID || ',' ||
         'p_TOAANNHANID => ' || p_TOAANNHANID || ',' ||
         'p_NGAYNHAN => ' || p_NGAYNHAN || ',' ||
         ' );';

        -- Lấy giai đoạn hiện tại của án
        SELECT don.TOAANID, don.TOAPHUCTHAMID
        INTO v_TOAANID, v_TOAPHUCTHAMID
        FROM AHC_DON don 
        WHERE don.ID = p_VUVIECID;

        -- Lấy thông tin mapping
        SELECT vbm.MAGIAIDOAN, vbm.TRANGTHAIGIAIQUYET
        INTO  v_MAGIAIDOAN, v_TRANGTHAIGIAIQUYET
        FROM VUAN_BANGIAO_MAPPING vbm
        WHERE vbm.ID = p_ID AND vbm.TRANGTHAI = 'TTBG_CHONHAN';

        -- Kiểm tra giai đoạn hợp lệ
        IF v_MAGIAIDOAN NOT IN (2, 3, 7) THEN
            RAISE_APPLICATION_ERROR(-20001, 'Giai đoạn không hợp lệ.');
        END IF;

        -- Cập nhật án đã kết thúc với trạng thái giải quyết = 7
        UPDATE AHC_DON_GIAIDOAN
        SET AN_DA_KET_THUC = CASE 
                WHEN v_TRANGTHAIGIAIQUYET = 7 THEN 1 
                ELSE AN_DA_KET_THUC 
            END
        WHERE DONID = p_VUVIECID AND MAGIAIDOAN = v_MAGIAIDOAN;

        -- Xử lý cập nhật theo giai đoạn
        IF v_MAGIAIDOAN = 2 THEN
            -- SƠ THẨM
            -- Update TOAID cho AHC_DON
            UPDATE AHC_DON
            SET TOAANID = p_TOAANNHANID
            WHERE ID = p_VUVIECID;

            -- Kiểm tra xem có update được chính xác 1 bản ghi AHC_DON hay không
            IF SQL%ROWCOUNT != 1 THEN
                ROLLBACK;
                RAISE_APPLICATION_ERROR(-20002, 'Lỗi cập nhật AHC_DON (Sơ thẩm)');
            END IF;
            
            -- Update TOAID cho AHC_SOTHAM_THULY
            UPDATE AHC_SOTHAM_THULY
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID;
            
            -- Update TOAID AHC_DON_GIAIDOAN
            UPDATE AHC_DON_GIAIDOAN
            SET TOA_GIAIQUYET_ID = v_TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL AND MAGIAIDOAN = v_MAGIAIDOAN;
            
            UPDATE AHC_DON_GIAIDOAN
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID AND MAGIAIDOAN = v_MAGIAIDOAN;

            -- Update DON_CHITIET
            UPDATE DON_CHITIET
            SET TOA_GIAIQUYET_ID = v_TOAANID
            WHERE DONID = p_VUVIECID AND LOAIANID = 6 AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;
                    
            UPDATE DON_CHITIET
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND LOAIANID = 6 AND TOAANID = v_TOAANID;

            -- Update AHC_TONGDAT
            UPDATE AHC_TONGDAT
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID;

            -- Update DON_KHAC
			UPDATE DON_KHAC
            SET TOA_GIAIQUYET_ID = v_TOAANID
            WHERE DONID = p_VUVIECID AND LOAIANID = 6 AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;
                    
            UPDATE DON_KHAC
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND LOAIANID = 6 AND TOAANID = v_TOAANID;

            -- Update TOAID AHC_DON_XULY
            UPDATE AHC_DON_XULY
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID;  

            -- Update TOAID cho AHC_SOTHAM_BANAN
--            UPDATE AHC_SOTHAM_BANAN
--            SET TOA_GIAIQUYET_ID = v_TOAANID,
--                TOAANID = p_TOAANNHANID
--            WHERE DONID = p_VUVIECID; 

            -- Update TOAID cho AHC_SOTHAM_QUYETDINH
            UPDATE AHC_SOTHAM_QUYETDINH
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID;  
           
           --Backup và cập nhật thông tin TOACHUYENID của trường hợp ST => PT 
            UPDATE AHC_CHUYEN_NHAN_AN 
            SET TOA_GIAIQUYET_ID = TOACHUYENID, 
            	TOACHUYENID = p_TOAANNHANID 
            WHERE VUANID = p_VUVIECID AND TOACHUYENID = v_TOAANID;
            
            UPDATE AHC_CHUYEN_NHAN_AN
            SET TOA_GIAIQUYET_NHAN_ID = TOANHANID, 
                TOANHANID = p_TOAANNHANID
            WHERE VUANID = p_VUVIECID AND TOANHANID = v_TOAANID;
           
           -- Với trường hợp chuyển ST -> ST, sau khi chuyển án tạm đình chỉ
            UPDATE AHC_CHUYEN_NHAN_AN
      			SET
      				TOA_GIAIQUYET_NHAN_ID = TOANHANID,
      				TOANHANID = p_TOAANNHANID
      			WHERE
      				VUANID in (
        				SELECT CNA.MAP_VUANID_NEW
        				FROM AHC_CHUYEN_NHAN_AN CNA
        				WHERE CNA.VUANID = p_VUVIECID AND CNA.MAP_VUANID_NEW IS NOT NULL
              );

            -- Với trường hợp chuyển ST -> ST, sau khi chuyển án không đủ thẩm quyền xét xử
            UPDATE AHC_CHUYEN_NHAN_AN
      			SET
      				TOA_GIAIQUYET_NHAN_ID = TOANHANID,
      				TOANHANID = p_TOAANNHANID
      			WHERE
      				MAP_VUANID_NEW = p_VUVIECID AND MAP_VUANID_NEW IS NOT NULL;
            
        ELSIF v_MAGIAIDOAN IN (3,7) THEN
            -- PHÚC THẨM
           -- Update TOAID cho AHC_DON
            UPDATE AHC_DON
            SET TOAPHUCTHAMID = p_TOAANNHANID
            WHERE ID = p_VUVIECID;

            -- Kiểm tra xem có update được chính xác 1 bản ghi AHC_DON hay không
            IF SQL%ROWCOUNT != 1 THEN
                ROLLBACK;
                RAISE_APPLICATION_ERROR(-20002, 'Lỗi cập nhật AHC_DON (Sơ thẩm)');
            END IF;
           
           	UPDATE AHC_DON
            SET TOA_PHUCTHAM_GIAIQUYET_ID = v_TOAPHUCTHAMID
            WHERE ID = p_VUVIECID AND TOA_PHUCTHAM_GIAIQUYET_ID IS NULL;
            
            -- Update ALD_PHUCTHAM_THULY
            UPDATE AHC_PHUCTHAM_THULY
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID;
           
           	UPDATE AHC_PHUCTHAM_THULY
            SET TOA_GIAIQUYET_ID = v_TOAPHUCTHAMID
            WHERE DONID = p_VUVIECID AND TOA_GIAIQUYET_ID IS NULL;
            
            -- Update TOAID ALD_DON_GIAIDOAN
           	UPDATE AHC_DON_GIAIDOAN
            SET TOA_PHUCTHAM_GIAIQUYET_ID = v_TOAPHUCTHAMID
            WHERE DONID = p_VUVIECID AND TOAPHUCTHAMID = v_TOAPHUCTHAMID AND TOA_PHUCTHAM_GIAIQUYET_ID IS NULL AND MAGIAIDOAN = v_MAGIAIDOAN;
            
            UPDATE AHC_DON_GIAIDOAN
            SET TOAPHUCTHAMID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAPHUCTHAMID = v_TOAPHUCTHAMID AND MAGIAIDOAN = v_MAGIAIDOAN;
			
			-- UPDATE TOAID DON_KHAC
			UPDATE DON_KHAC
            SET TOA_GIAIQUYET_ID = v_TOAPHUCTHAMID
            WHERE DONID = p_VUVIECID AND LOAIANID = 6 AND TOAANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;
			
			UPDATE DON_KHAC
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND LOAIANID = 6 AND TOAANID = v_TOAPHUCTHAMID;
           
           	-- update PT 11/07/2025
            -- UPDATE AHC_KCKNQDK_PHUCTHAM_QUYETDINH
            UPDATE AHC_KCKNQDK_PHUCTHAM_QUYETDINH
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID;
            
            -- UPDATE AHC_KCKNQDK_PHUCTHAM_THULY
            UPDATE AHC_KCKNQDK_PHUCTHAM_THULY
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID;
           
            -- Update AHC_TONGDAT
            UPDATE AHC_TONGDAT
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID;
            
            -- UPDATE AHC_PHUCTHAM_BANAN
--            UPDATE AHC_PHUCTHAM_BANAN
--            SET TOA_GIAIQUYET_ID = v_TOAPHUCTHAMID,
--                    TOAANID = p_TOAANNHANID
--            WHERE DONID = p_VUVIECID;
            
            -- UPDATE AHC_PHUCTHAM_QUYETDINH
            UPDATE AHC_PHUCTHAM_QUYETDINH
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID;
            
           IF (v_MAGIAIDOAN = 7) THEN
           		-- Backup và cập nhật thông tin TOACHUYENID của trường hợp PT => ST
	           	UPDATE AHC_CHUYEN_NHAN_AN 
	            SET TOA_GIAIQUYET_ID = TOACHUYENID, 
	                TOACHUYENID = p_TOAANNHANID 
	            WHERE MAP_VUANID_NEW = p_VUVIECID AND TOACHUYENID = v_TOAPHUCTHAMID;
	            
	            UPDATE AHC_CHUYEN_NHAN_AN
	            SET TOA_GIAIQUYET_NHAN_ID = TOANHANID, 
	                TOANHANID = p_TOAANNHANID
	            WHERE MAP_VUANID_NEW = p_VUVIECID AND TOANHANID = v_TOAPHUCTHAMID;
           ELSE
	            -- Backup và cập nhật thông tin TOACHUYENID của trường hợp PT => ST
	            UPDATE AHC_CHUYEN_NHAN_AN 
	            SET TOA_GIAIQUYET_ID = TOACHUYENID, 
	                TOACHUYENID = p_TOAANNHANID 
	            WHERE VUANID = p_VUVIECID AND TOACHUYENID = v_TOAPHUCTHAMID;
	            
	            UPDATE AHC_CHUYEN_NHAN_AN
	            SET TOA_GIAIQUYET_NHAN_ID = TOANHANID, 
	                TOANHANID = p_TOAANNHANID
	            WHERE VUANID = p_VUVIECID AND TOANHANID = v_TOAPHUCTHAMID;
           END IF;
        END IF;
        
        -- Update TRANGTHAI cho VUAN_BANGIAO_MAPPING
        UPDATE VUAN_BANGIAO_MAPPING
        SET TRANGTHAI = 'TTBG_DANHAN',
            NGAYNHAN = p_NGAYNHAN
        WHERE ID = p_ID;
        
        COMMIT;
        
    EXCEPTION
      WHEN OTHERS THEN
          -- Rollback in case of any exception
          ROLLBACK;

          v_output := 'Finish procedure Due to Exception: Error:' || SQLCODE || ',' || SQLERRM;
            PKG_TRACELOG.SP_INSERT_LOG_ERROR(
                p_functionname => 'PKG_BAN_GIAO_AN.AHC_VUAN_BANGIAO_MAPPING_NHAN',
                p_description => v_output,
                p_notes => v_tracedata
            );
          
          -- Re-raise the exception
          RAISE;
    END AHC_VUAN_BANGIAO_MAPPING_NHAN;
  
    -- [AHC] KIỂM TRA THAY ĐỔI
    PROCEDURE AHC_VUAN_BANGIAO_MAPPING_KTTHAYDOI (
        p_ID IN NUMBER,
        p_result OUT NUMBER,
        p_message OUT VARCHAR2
    )
    AS
        v_VUVIECID NUMBER;
        v_TOAANNHANID NUMBER;
        v_NGANHAN DATE;
        v_count NUMBER;
    BEGIN
        -- Khởi tạo giá trị mặc định
        p_result := 0;
        p_message := '';

        -- Lấy thông tin Mapping
        SELECT VUVIECID, TOAANNHANID, NGAYNHAN
        INTO  v_VUVIECID, v_TOAANNHANID, v_NGANHAN
        FROM VUAN_BANGIAO_MAPPING
        WHERE ID = p_ID AND TRANGTHAI = 'TTBG_DANHAN';
        
        -- Kiểm tra các bảng có thay đổi sau ngày nhận án
        
        -- Kiểm tra AHC_ANPHI
        SELECT COUNT(*) INTO v_count 
        FROM AHC_ANPHI 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN)
          AND SOBIENLAI IS NOT NULL AND TAMUNGANPHI IS NOT NULL AND NGUOINHANID IS NOT NULL;
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin án phí đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra AHC_CHUYEN_NHAN_AN
        SELECT COUNT(*) INTO v_count 
        FROM AHC_CHUYEN_NHAN_AN 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin chuyển nhận án đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra AHC_DON_DUONGSU
        SELECT COUNT(*) INTO v_count 
        FROM AHC_DON_DUONGSU 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin đương sự đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra AHC_DON_GIAIDOAN
        SELECT COUNT(*) INTO v_count 
        FROM AHC_DON_GIAIDOAN 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin giai đoạn đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra AHC_DON_TAILIEU
        SELECT COUNT(*) INTO v_count 
        FROM AHC_DON_TAILIEU 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin tài liệu đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra AHC_DON_THAMGIATOTUNG
        SELECT COUNT(*) INTO v_count 
        FROM AHC_DON_THAMGIATOTUNG 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin tham gia tố tụng đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra AHC_DON_THAMPHAN
        SELECT COUNT(*) INTO v_count 
        FROM AHC_DON_THAMPHAN 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin thẩm phán đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra AHC_DON_XULY
        SELECT COUNT(*) INTO v_count 
        FROM AHC_DON_XULY 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin xử lý đơn đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHC_FILE
      --  SELECT COUNT(*) INTO v_count 
      --  FROM AHC_FILE 
      --  WHERE DONID = v_VUVIECID 
      --    AND (NGAYTAO >= v_NGANHAN);
        
      --  IF v_count > 0 THEN
      --      p_result := 1;
      --      p_message := 'Thông tin đơn đã có thay đổi, không thể trả án.';
      --      RETURN;
      --  END IF;

        -- Kiểm tra AHC_KCKNQDK_PHUCTHAM_HDXX
        SELECT COUNT(*) INTO v_count 
        FROM AHC_KCKNQDK_PHUCTHAM_HDXX 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin HĐXX KCKNQDK phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHC_KCKNQDK_PHUCTHAM_QUYETDINH
        SELECT COUNT(*) INTO v_count 
        FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin quyết định KCKNQDK phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHC_KCKNQDK_PHUCTHAM_THAMGIATOTUNG
        SELECT COUNT(*) INTO v_count 
        FROM AHC_KCKNQDK_PHUCTHAM_THAMGIATOTUNG 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin tham gia tố tụng KCKNQDK phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHC_KCKNQDK_PHUCTHAM_THULY
        SELECT COUNT(*) INTO v_count 
        FROM AHC_KCKNQDK_PHUCTHAM_THULY 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin thụ lý KCKNQDK phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra AHC_PHUCTHAM_BANAN
        SELECT COUNT(*) INTO v_count 
        FROM AHC_PHUCTHAM_BANAN 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin bản án phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra AHC_PHUCTHAM_BANAN_FILE
        SELECT COUNT(*) INTO v_count 
        FROM AHC_PHUCTHAM_BANAN_FILE f
        WHERE EXISTS (
            SELECT 1 FROM AHC_PHUCTHAM_BANAN b 
            WHERE b.DONID = v_VUVIECID AND b.ID = f.BANANID
        ) AND f.NGAYTAO >= v_NGANHAN;
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin bản án phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra AHC_PHUCTHAM_BANAN_TGTT
--        SELECT COUNT(*) INTO v_count 
--        FROM AHC_PHUCTHAM_BANAN_TGTT 
--        WHERE DONID = v_VUVIECID AND NGAYNHANBANAN >= v_NGANHAN;
--        
--        IF v_count > 0 THEN
--            p_result := 1;
--            p_message := 'Thông tin bản án phúc thẩm đã có thay đổi, không thể trả án.';
--            RETURN;
--        END IF;

         -- Kiểm tra AHC_PHUCTHAM_DUONGSU
--        SELECT COUNT(*) INTO v_count 
--        FROM AHC_PHUCTHAM_DUONGSU 
--        WHERE DONID = v_VUVIECID 
--          AND (NGAYTAO >= v_NGANHAN);
        
--        IF v_count > 0 THEN
--            p_result := 1;
--            p_message := 'Thông tin HĐXX phúc thẩm đã có thay đổi, không thể trả án.';
--            RETURN;
--        END IF;
        
        -- Kiểm tra AHC_PHUCTHAM_HDXX
        SELECT COUNT(*) INTO v_count 
        FROM AHC_PHUCTHAM_HDXX 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin HĐXX phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra AHC_PHUCTHAM_HOAGIAI
        SELECT COUNT(*) INTO v_count 
        FROM AHC_PHUCTHAM_HOAGIAI 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin hoà giải phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHC_PHUCTHAM_QUYETDINH
        SELECT COUNT(*) INTO v_count 
        FROM AHC_PHUCTHAM_QUYETDINH 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin quyết định phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHC_PHUCTHAM_THAMGIATOTUNG
        SELECT COUNT(*) INTO v_count 
        FROM AHC_PHUCTHAM_THAMGIATOTUNG 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin tham gia tố tụng phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHC_PHUCTHAM_THULY
        SELECT COUNT(*) INTO v_count 
        FROM AHC_PHUCTHAM_THULY 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin thụ lý phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHC_SAUXETXU
--        SELECT COUNT(*) INTO v_count 
--        FROM AHC_SAUXETXU 
--        WHERE VUANID = v_VUVIECID 
--          AND (NGAYTAO >= v_NGANHAN);
--        
--        IF v_count > 0 THEN
--            p_result := 1;
--            p_message := 'Thông tin sau xét xử đã có thay đổi, không thể trả án.';
--            RETURN;
--        END IF;

        -- Kiểm tra AHC_SOTHAM_BANAN
        SELECT COUNT(*) INTO v_count 
        FROM AHC_SOTHAM_BANAN 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin bản án sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHC_SOTHAM_BANAN_ANPHI
        SELECT COUNT(*) INTO v_count 
        FROM AHC_SOTHAM_BANAN_ANPHI 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin án phí bản án sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHC_SOTHAM_BANAN_DIEULUAT
        SELECT COUNT(*) INTO v_count 
        FROM AHC_SOTHAM_BANAN_DIEULUAT 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin điều luật bản án sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHC_SOTHAM_BANAN_FILE
        SELECT COUNT(*) INTO v_count 
        FROM AHC_SOTHAM_BANAN_FILE 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin đơn bản án sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHC_SOTHAM_BANAN_TGTT
--        SELECT COUNT(*) INTO v_count 
--        FROM AHC_SOTHAM_BANAN_TGTT 
--        WHERE DONID = v_VUVIECID 
--          AND (NGAYTAO >= v_NGANHAN);
--        
--        IF v_count > 0 THEN
--            p_result := 1;
--            p_message := 'Thông tin đơn bản án sơ thẩm có thay đổi, không thể trả án.';
--            RETURN;
--        END IF;

        -- Kiểm tra AHC_SOTHAM_HDXX
        SELECT COUNT(*) INTO v_count 
        FROM AHC_SOTHAM_HDXX 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin HĐXX sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHC_SOTHAM_HOAGIAI
        SELECT COUNT(*) INTO v_count 
        FROM AHC_SOTHAM_HOAGIAI 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin hoà giải sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHC_SOTHAM_KHANGCAO
        SELECT COUNT(*) INTO v_count 
        FROM AHC_SOTHAM_KHANGCAO 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin kháng cáo sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

         -- Kiểm tra AHC_SOTHAM_KHANGNGHI
        SELECT COUNT(*) INTO v_count 
        FROM AHC_SOTHAM_KHANGNGHI 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin kháng nghị sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

         -- Kiểm tra AHC_SOTHAM_QUYETDINH
        SELECT COUNT(*) INTO v_count 
        FROM AHC_SOTHAM_QUYETDINH 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin quyết định sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

         -- Kiểm tra AHC_SOTHAM_RUTKCKN
        SELECT COUNT(*) INTO v_count 
        FROM AHC_SOTHAM_RUTKCKN 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin rút KCKN sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

--        -- Kiểm tra AHC_SOTHAM_THAMGIATOTUNG
--        SELECT COUNT(*) INTO v_count 
--        FROM AHC_SOTHAM_THAMGIATOTUNG 
--        WHERE DONID = v_VUVIECID 
--          AND (NGAYTAO >= v_NGANHAN);
--        
--        IF v_count > 0 THEN
--            p_result := 1;
--            p_message := 'Thông tin tham gia TT sơ thẩm có thay đổi, không thể trả án.';
--            RETURN;
--        END IF;

          -- Kiểm tra AHC_SOTHAM_THULY
        SELECT COUNT(*) INTO v_count 
        FROM AHC_SOTHAM_THULY 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin thụ lý sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

          -- Kiểm tra AHC_TONGDAT
        SELECT COUNT(*) INTO v_count 
        FROM AHC_TONGDAT 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin tống đạt có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHC_TONGDAT_DOITUONG
        SELECT COUNT(*) INTO v_count 
        FROM AHC_TONGDAT_DOITUONG f
        WHERE EXISTS (
            SELECT 1 FROM AHC_TONGDAT b 
            WHERE b.DONID = v_VUVIECID AND b.ID = f.TONGDATID
        ) 
          AND f.NGAYTAO >= v_NGANHAN;
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin đối tượng tống đạt đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHC_TRUNGCAU_GIAMDINH
        SELECT COUNT(*) INTO v_count 
        FROM AHC_TRUNGCAU_GIAMDINH 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin trưng cầu giám định có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra AHC_XULY_VIPHAMHC
        SELECT COUNT(*) INTO v_count 
        FROM AHC_XULY_VIPHAMHC 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin xử lý vi phạm HC có thay đổi, không thể trả án.';
            RETURN;
        END IF;
                
        -- Kiểm tra DON_KHAC
        SELECT COUNT(*) INTO v_count 
        FROM DON_KHAC 
        WHERE DONID = v_VUVIECID 
          AND (NGAYNHANDON >= v_NGANHAN OR NGAYKHANGCAO >= v_NGANHAN) 
          AND LOAIANID = 6;
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin đơn đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra DON_KHAC_YEUCAU
        SELECT COUNT(*) INTO v_count 
        FROM DON_KHAC_YEUCAU y
        WHERE EXISTS (
            SELECT 1 FROM DON_KHAC d 
            WHERE d.DONID = v_VUVIECID 
              AND d.ID = y.DONKHACID
        ) AND (y.NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin đơn đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra DON_CHITIET
        SELECT COUNT(*) INTO v_count 
        FROM DON_CHITIET 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN) 
          AND LOAIANID = 6;
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin đơn đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra DON_DUONGSU_CHITIET
        SELECT COUNT(*) INTO v_count 
        FROM DON_DUONGSU_CHITIET 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN)
          AND LOAIAN = 6;
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin đương sự đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra HOSO_PT
        SELECT COUNT(*) INTO v_count 
        FROM HOSO_PT 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN)
          AND LOAIAN = 6;
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin hồ sơ phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
      EXCEPTION
          WHEN OTHERS THEN
              p_result := 1;
              p_message := 'Lỗi khi kiểm tra: ' || SQLERRM;
  END AHC_VUAN_BANGIAO_MAPPING_KTTHAYDOI;

    -- [AHC] TRẢ LẠI
    PROCEDURE AHC_VUAN_BANGIAO_MAPPING_TRALAI (
        p_ID IN NUMBER
    ) AS
        v_VUVIECID NUMBER;
        v_MAGIAIDOAN NUMBER;
        v_TOAANGIAOID NUMBER;
        v_TOAANNHANID NUMBER;

        v_tracedata VARCHAR2(1024);
        v_output VARCHAR2(512);
    BEGIN
        v_tracedata := '(' || 
         'p_ID => ' || p_ID || ',' ||
         ' );';

        -- Lấy thông tin Mapping
        SELECT VUVIECID, TOAANGIAOID, TOAANNHANID, MAGIAIDOAN
        INTO  v_VUVIECID, v_TOAANGIAOID, v_TOAANNHANID, v_MAGIAIDOAN
        FROM VUAN_BANGIAO_MAPPING
        WHERE ID = p_ID AND TRANGTHAI = 'TTBG_DANHAN';

        -- Xoá thông tin AN_DA_KET_THUC cho giai đoạn
        UPDATE AHC_DON_GIAIDOAN
        SET AN_DA_KET_THUC = NULL
        WHERE DONID = v_VUVIECID AND MAGIAIDOAN = v_MAGIAIDOAN AND (TOA_GIAIQUYET_ID = v_TOAANGIAOID OR TOA_PHUCTHAM_GIAIQUYET_ID = v_TOAANGIAOID);
        
        -- Xử lý cập nhật theo giai đoạn
        IF v_MAGIAIDOAN = 2 THEN
            -- SƠ THẨM
            -- Update AHC_DON
            UPDATE AHC_DON
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE ID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update AHC_SOTHAM_THULY
            UPDATE AHC_SOTHAM_THULY
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
            
            -- Update AHC_DON_GIAIDOAN
            UPDATE AHC_DON_GIAIDOAN
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update DON_CHITIET
            UPDATE DON_CHITIET
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND LOAIANID = 6 AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update AHC_TONGDAT
            UPDATE AHC_TONGDAT
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update DON_KHAC
            UPDATE DON_KHAC
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND LOAIANID = 6 AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update AHC_DON_XULY
            UPDATE AHC_DON_XULY
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update AHC_SOTHAM_BANAN
--            UPDATE AHC_SOTHAM_BANAN
--            SET TOAANID = TOA_GIAIQUYET_ID
--            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update AHC_SOTHAM_QUYETDINH
            UPDATE AHC_SOTHAM_QUYETDINH
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update AHC_CHUYEN_NHAN_AN
            -- Theo TOACHUYENID 
            UPDATE AHC_CHUYEN_NHAN_AN 
            SET TOACHUYENID = TOA_GIAIQUYET_ID 
            WHERE VUANID = v_VUVIECID AND TOACHUYENID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
            
            -- Theo TOANHANID
            UPDATE AHC_CHUYEN_NHAN_AN
            SET TOANHANID = TOA_GIAIQUYET_NHAN_ID
            WHERE VUANID = v_VUVIECID AND TOANHANID = v_TOAANNHANID AND TOA_GIAIQUYET_NHAN_ID = v_TOAANGIAOID;

            -- Với trường hợp chuyển ST -> ST, sau khi chuyển án tạm đình chỉ
          	UPDATE AHC_CHUYEN_NHAN_AN
            SET TOANHANID = TOA_GIAIQUYET_NHAN_ID
			      WHERE VUANID in (SELECT CNA.MAP_VUANID_NEW
				                     FROM AHC_CHUYEN_NHAN_AN CNA
                             WHERE CNA.VUANID = v_VUVIECID AND CNA.MAP_VUANID_NEW IS NOT NULL);

            -- Với trường hợp chuyển ST -> ST, sau khi chuyển án không đủ thẩm quyền xét xử
            UPDATE AHC_CHUYEN_NHAN_AN
      			SET
      				TOANHANID = TOA_GIAIQUYET_NHAN_ID
      			WHERE
      				MAP_VUANID_NEW = v_VUVIECID AND MAP_VUANID_NEW IS NOT NULL;

        ELSIF v_MAGIAIDOAN IN (3,7) THEN
            -- PHÚC THẨM

            -- Update AHC_DON
            UPDATE AHC_DON
            SET TOAPHUCTHAMID = TOA_PHUCTHAM_GIAIQUYET_ID
            WHERE ID = v_VUVIECID AND TOAPHUCTHAMID = v_TOAANNHANID AND TOA_PHUCTHAM_GIAIQUYET_ID = v_TOAANGIAOID;

            UPDATE AHC_DON
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE ID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update AHC_PHUCTHAM_THULY

            UPDATE AHC_PHUCTHAM_THULY
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update AHC_DON_GIAIDOAN
            UPDATE AHC_DON_GIAIDOAN
            SET TOAPHUCTHAMID = TOA_PHUCTHAM_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAPHUCTHAMID = v_TOAANNHANID AND TOA_PHUCTHAM_GIAIQUYET_ID = v_TOAANGIAOID;

            UPDATE AHC_DON_GIAIDOAN
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- UPDATE AHC_KCKNQDK_PHUCTHAM_QUYETDINH
            UPDATE AHC_KCKNQDK_PHUCTHAM_QUYETDINH
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
            
            -- UPDATE AHC_KCKNQDK_PHUCTHAM_THULY
            UPDATE AHC_KCKNQDK_PHUCTHAM_THULY
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
            
            -- UPDATE AHC_PHUCTHAM_BANAN
--            UPDATE AHC_PHUCTHAM_BANAN
--            SET TOAANID = TOA_GIAIQUYET_ID
--            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
            
            -- UPDATE AHC_PHUCTHAM_QUYETDINH
            UPDATE AHC_PHUCTHAM_QUYETDINH
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update AHC_TONGDAT
            UPDATE AHC_TONGDAT
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update DON_CHITIET
            UPDATE DON_CHITIET
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND LOAIANID = 6 AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update DON_KHAC
            UPDATE DON_KHAC
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND LOAIANID = 6 AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;


            -- Update HOSO_PT
            UPDATE HOSO_PT
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE VUANID = v_VUVIECID AND LOAIAN = 6 AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
            
            IF (v_MAGIAIDOAN = 7) THEN
              -- Update AHC_CHUYEN_NHAN_AN
              -- Theo TOACHUYENID 
              UPDATE AHC_CHUYEN_NHAN_AN 
	            SET TOACHUYENID = TOA_GIAIQUYET_ID 
	            WHERE MAP_VUANID_NEW = v_VUVIECID AND TOACHUYENID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
	            
              -- Theo TOANHANID 
	            UPDATE AHC_CHUYEN_NHAN_AN
	            SET TOANHANID = TOA_GIAIQUYET_NHAN_ID
	            WHERE MAP_VUANID_NEW = v_VUVIECID AND TOANHANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
           ELSE
	            -- Update AHC_CHUYEN_NHAN_AN
              -- Theo TOACHUYENID 
              UPDATE AHC_CHUYEN_NHAN_AN 
	            SET TOACHUYENID = TOA_GIAIQUYET_ID 
	            WHERE VUANID = v_VUVIECID AND TOACHUYENID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
	            
              -- Theo TOANHANID 
	            UPDATE AHC_CHUYEN_NHAN_AN
	            SET TOANHANID = TOA_GIAIQUYET_ID
	            WHERE VUANID = v_VUVIECID AND TOANHANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
           END IF;
        END IF;
        
        -- Update TRANGTHAI cho VUAN_BANGIAO_MAPPING
        update VUAN_BANGIAO_MAPPING 
        SET TRANGTHAI = 'TTBG_CHONHAN'
        WHERE ID = p_ID;
        
        COMMIT;
        
    EXCEPTION
      WHEN OTHERS THEN
          -- Rollback in case of any exception
          ROLLBACK;

          v_output := 'Finish procedure Due to Exception: Error:' || SQLCODE || ',' || SQLERRM;
          PKG_TRACELOG.SP_INSERT_LOG_ERROR(
              p_functionname => 'PKG_BAN_GIAO_AN.AHC_VUAN_BANGIAO_MAPPING_TRALAI',
              p_description => v_output,
              p_notes => v_tracedata
          );

          -- Re-raise the exception
          RAISE;
    END AHC_VUAN_BANGIAO_MAPPING_TRALAI;



   --[ALD] LẤY DANH SÁCH CÓ THỂ BÀN GIAO
    PROCEDURE ALD_VUAN_BANGIAO_MAPPING_GET_AN_BAN_GIAO (
        p_LOAIANID IN varchar2,
        p_TOAANID IN NUMBER,
        p_MAVUVIEC IN varchar2,
        p_THULYTUNGAY IN date,
        p_THULYDENNGAY IN date,
        p_TINHTRANGTHULY IN nvarchar2,
        p_THAMPHANGIAIQUYET IN nvarchar2,
        p_TENVUAN IN nvarchar2,    
        p_TRANGTHAIGIAIQUYET IN nvarchar2,    
        p_CAPXETXU IN nvarchar2,  
        p_TRANGTHAI IN NVARCHAR2,
        p_CURSOR OUT SYS_REFCURSOR
    ) AS
        /*
        ================================================================================
        ALD VERSION WITH DUAL PROCEDURES ENABLED - COMPLETE DATASET:
        
        APPROACH: Sử dụng cả PKG_ALD_STPT_DS.ALD_DON_SEARCH_TURNING và PKG_STPT_ALD_GS.DON_SEARCH
        
        FEATURES:
        - PKG_ALD_STPT_DS.ALD_DON_SEARCH_TURNING: 27 columns, comprehensive ALD data
        - PKG_STPT_ALD_GS.DON_SEARCH: 33 parameters, validated mapping theo ALD_DON_BL.cs
        - Combined COUNTALL từ cả 2 procedures để có tổng số record chính xác
        - DISTINCT query để tránh duplicate records
        - Logic xử lý khác nhau theo p_TRANGTHAI:
          + TRANGTHAI = 0: Loại bỏ bản ghi đã có mapping với toaangiaoid = p_toaanid
          + TRANGTHAI = 1: Gọi procedures với p_TOAANID + TOTOAANID từ DM_TOAAN_TACH_NHAP_MAPPING
        
        EXECUTION FLOW:
        - CHECK p_TRANGTHAI value
        - IF TRANGTHAI = 1: Loop qua p_TOAANID + các TOTOAANID và gọi CẢ 2 procedures
        - IF TRANGTHAI = 0/NULL: Gọi CẢ 2 procedures với p_TOAANID thông thường  
        - Final: Combine và return complete dataset với accurate COUNTALL
        - Note: Procedure này trả về vụ án phúc thẩm (MAGIAIDOAN=7) từ nhiều nguồn
        ================================================================================
        */
        
        TOTALITEM                   NUMBER;  
        MININDEX                    NUMBER; 
        MAXINDEX                    NUMBER; 
        V_TABLE_TIMKIEM             T_TIMKIEM_STPT_DS;
        
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
        
        FETCH_ID                VARCHAR2(255 CHAR);
        FETCH_MAVUVIEC          VARCHAR2(255 CHAR);
        FETCH_TENVUVIEC         VARCHAR2(4000 CHAR);
        FETCH_SOTHUTU           VARCHAR2(255 CHAR); 
        FETCH_NGAYNHANDON       VARCHAR2(255 CHAR);
        FETCH_HINHTHUCNHANDON   VARCHAR2(255 CHAR);
        FETCH_MAGIAIDOAN        VARCHAR2(255 CHAR);  
        FETCH_QHPLTKID          VARCHAR2(255 CHAR);
        FETCH_TOAANID           VARCHAR2(25 CHAR);
        FETCH_QUANHEPL          VARCHAR2(4000 CHAR);
        FETCH_BANAN_QD_ST       VARCHAR2(4000 CHAR);
        FETCH_QD_PT             VARCHAR2(4000 CHAR);
        FETCH_KHANGNGHI_ST      VARCHAR2(4000 CHAR);
        FETCH_CHECK_THULY       VARCHAR2(1000 CHAR);
        FETCH_HOTENBICAN        VARCHAR2(4000 CHAR);
        FETCH_COUNTALL          VARCHAR2(255 CHAR);
        FETCH_STT               VARCHAR2(1000 CHAR);
        FETCH_NGUOITAO          VARCHAR2(255 CHAR);
        FETCH_NGAY_TAO          VARCHAR2(255 CHAR);
        FETCH_NGAYTAO           VARCHAR2(255 CHAR);
        FETCH_TENTOASOTHAM      VARCHAR2(1000 CHAR);
        FETCH_GIAIDOANVUVIEC    VARCHAR2(255 CHAR);
        FETCH_TRUONGHOPGIAONHAN VARCHAR2(4000 CHAR);
        FETCH_KHANGCAO_ST       VARCHAR2(4000 CHAR);
        FETCH_TINHTRANG_GQ      VARCHAR2(4000 CHAR);
        FETCH_THULYXXLAI        VARCHAR2(1000 CHAR);
        FETCH_THAMPHANHG        VARCHAR2(4000 CHAR);  -- Cột thứ 27 cho ALD procedure
        
        SUM_COUNTALL            NUMBER DEFAULT 0;
        CURSOR_RETURN           SYS_REFCURSOR;
        CURSOR_RETURN2           SYS_REFCURSOR;
        
        -- PROCESS_CURSOR: Xử lý cursor và capture COUNTALL từ record đầu tiên
        PROCEDURE PROCESS_CURSOR(P_CUR IN SYS_REFCURSOR, P_TYPE VARCHAR2, P_VAR NUMBER, P_TOAANID VARCHAR2) IS
            V_IS_FIRST_RECORD BOOLEAN := TRUE;
        BEGIN
            LOOP
                BEGIN
                    IF P_VAR = 1 THEN
                        -- FETCH cho PKG_STPT_ALD_GS.DON_SEARCH (23 cột) - Fixed với đúng 33 parameters
                        FETCH P_CUR INTO FETCH_STT, FETCH_COUNTALL, FETCH_ID, FETCH_MAVUVIEC, 
                          FETCH_TENVUVIEC, FETCH_SOTHUTU, FETCH_NGAYNHANDON, FETCH_NGUOITAO, 
                          FETCH_NGAYTAO, FETCH_QUANHEPL, FETCH_TENTOASOTHAM, FETCH_GIAIDOANVUVIEC,
                          FETCH_HINHTHUCNHANDON, FETCH_TRUONGHOPGIAONHAN, FETCH_BANAN_QD_ST, 
                          FETCH_QD_PT, FETCH_KHANGNGHI_ST, FETCH_KHANGCAO_ST, FETCH_MAGIAIDOAN,
                          FETCH_HOTENBICAN, FETCH_TINHTRANG_GQ, FETCH_CHECK_THULY, FETCH_THULYXXLAI;
                    
                        EXIT WHEN P_CUR%NOTFOUND;
                        
                        -- Capture COUNTALL từ record đầu tiên của procedure 2
                        IF V_IS_FIRST_RECORD THEN
                            V_COUNTALL_PROC2 := TO_NUMBER(FETCH_COUNTALL);
                            V_IS_FIRST_RECORD := FALSE;
                        END IF;
                        
                        -- Gán giá trị cho các trường bị thiếu
                        FETCH_QHPLTKID := '';
                        FETCH_TOAANID := P_TOAANID;
                        FETCH_NGAY_TAO := FETCH_NGAYTAO;
                    ELSE
                        -- FETCH cho PKG_ALD_STPT_DS.ALD_DON_SEARCH_TURNING (27 cột, thứ tự: ID, MAVUVIEC...)
                        FETCH P_CUR INTO FETCH_ID, FETCH_MAVUVIEC, FETCH_TENVUVIEC, FETCH_SOTHUTU, 
                          FETCH_NGAYNHANDON, FETCH_HINHTHUCNHANDON, FETCH_MAGIAIDOAN, FETCH_QHPLTKID,
                          FETCH_TOAANID, FETCH_QUANHEPL, FETCH_BANAN_QD_ST, FETCH_QD_PT,
                          FETCH_KHANGNGHI_ST, FETCH_CHECK_THULY, FETCH_HOTENBICAN, FETCH_COUNTALL, 
                          FETCH_STT, FETCH_NGAY_TAO, FETCH_NGUOITAO, FETCH_NGAYTAO, FETCH_TENTOASOTHAM, 
                          FETCH_GIAIDOANVUVIEC, FETCH_TRUONGHOPGIAONHAN, FETCH_KHANGCAO_ST,
                          FETCH_TINHTRANG_GQ, FETCH_THULYXXLAI, FETCH_THAMPHANHG;
                    
                        EXIT WHEN P_CUR%NOTFOUND;
                        
                        -- Capture COUNTALL từ record đầu tiên của procedure 1
                        IF V_IS_FIRST_RECORD THEN
                            V_COUNTALL_PROC1 := TO_NUMBER(FETCH_COUNTALL);
                            V_IS_FIRST_RECORD := FALSE;
                        END IF;
                    END IF;
                    
                    -- Phần xử lý chung vẫn giữ nguyên
                    V_TABLE_TIMKIEM.EXTEND;
                    V_TABLE_TIMKIEM(V_TABLE_TIMKIEM.COUNT) := R_TIMKIEM_STPT_DS(
                        FETCH_ID, FETCH_MAVUVIEC, FETCH_TENVUVIEC, FETCH_SOTHUTU, FETCH_NGAYNHANDON, 
                        FETCH_HINHTHUCNHANDON, FETCH_MAGIAIDOAN, FETCH_QHPLTKID, FETCH_TOAANID, 
                        FETCH_QUANHEPL, FETCH_BANAN_QD_ST, FETCH_QD_PT, FETCH_KHANGNGHI_ST, 
                        FETCH_CHECK_THULY, FETCH_HOTENBICAN, FETCH_COUNTALL, FETCH_STT, FETCH_NGAY_TAO,
                        FETCH_NGUOITAO, FETCH_NGAYTAO, FETCH_TENTOASOTHAM, FETCH_GIAIDOANVUVIEC,
                        FETCH_TRUONGHOPGIAONHAN, FETCH_KHANGCAO_ST, FETCH_TINHTRANG_GQ, FETCH_THULYXXLAI, P_TYPE
                    );
                END;
            END LOOP;
        END PROCESS_CURSOR;
    BEGIN
        
        -- Set fixed pagesize for optimal performance
        V_PROCEDURE_PAGESIZE := V_OPTIMIZED_PAGESIZE;
        
        IF p_THULYTUNGAY IS NOT NULL THEN 
            V_THULYTUNGAY := TO_CHAR(p_THULYTUNGAY, 'DD/MM/YYYY');
        ELSE
            V_THULYTUNGAY := '';
        END IF;  
    
        IF p_THULYDENNGAY IS NOT NULL THEN  
            V_THULYDENNGAY := TO_CHAR(p_THULYDENNGAY, 'DD/MM/YYYY'); 
        ELSE
            V_THULYDENNGAY := '';
        END IF;

SELECT LOAITOA
  INTO V_CAP_XET_XU_LOGIN
  FROM DM_TOAAN
  WHERE 1 = 1
    AND ID = P_TOAANID;
        V_TABLE_TIMKIEM := T_TIMKIEM_STPT_DS();
        
        -- LOGIC XỬ LÝ THEO p_TRANGTHAI
        IF p_TRANGTHAI = 1 THEN
            -- TRANGTHAI = 1: Lấy dữ liệu từ các toà được bàn giao (bao gồm cả p_TOAANID gốc)
            FOR toaan_rec IN (
                SELECT p_TOAANID AS TOTOAANID FROM DUAL
                UNION ALL
                SELECT TOTOAANID FROM DM_TOAAN_TACH_NHAP_MAPPING WHERE TOAANID = p_TOAANID
            ) LOOP
                V_CURRENT_TOAANID := toaan_rec.TOTOAANID;
                V_TRANGTHAIGIAIQUYET := '';
                
                -- BƯỚC 1: PKG_ALD_STPT_DS.ALD_DON_SEARCH_TURNING procedure call
                PKG_ALD_STPT_DS.ALD_DON_SEARCH_TURNING(V_CAP_XET_XU_LOGIN,p_TENVUAN,NULL,p_MAVUVIEC,NULL,p_CAPXETXU,V_CURRENT_TOAANID,p_TINHTRANGTHULY,
                                                        V_THULYTUNGAY,V_THULYDENNGAY,NULL,p_THAMPHANGIAIQUYET,V_TRANGTHAIGIAIQUYET,NULL,NULL,NULL,
                                                        NULL,NULL,NULL,NULL, NULL,NULL,NULL,NULL,0,NULL,NULL,1, 1,0,0,NULL,NULL,
                                                        NULL, 1, V_PROCEDURE_PAGESIZE, CURSOR_RETURN);
                IF CURSOR_RETURN IS NOT NULL THEN
                    PROCESS_CURSOR(CURSOR_RETURN, '5', 0, V_CURRENT_TOAANID);
                    CLOSE CURSOR_RETURN;
                END IF;

                -- Không lấy án TĐC với cấp sơ thẩm
                IF P_CAPXETXU IS NULL OR p_CAPXETXU <> 2 THEN
                                                        
                  -- BƯỚC 2: PKG_STPT_ALD_GS.DON_SEARCH với đúng 33 parameters theo ALD_DON_BL.cs
                  PKG_STPT_ALD_GS.ALD_DON_SEARCH(
                      V_CAP_XET_XU_LOGIN,       -- 1. V_CAP_XET_XU_LOGIN
                      p_TENVUAN,                -- 2. V_TEN_VU_AN  
                      NULL,                     -- 3. V_QHPL
                      p_MAVUVIEC,              -- 4. V_MA_VU_AN
                      NULL,                     -- 5. V_TENDUONGSU
                      3,                        -- 6. V_CAPXX
                      V_CURRENT_TOAANID,       -- 7. V_TOAAN_ID
                      p_TINHTRANGTHULY,        -- 8. V_TINHTRANG_THULY
                      V_THULYTUNGAY,           -- 9. V_NGAYTHULY_TU
                      V_THULYDENNGAY,          -- 10. V_NGAYTHULY_DEN
                      NULL,                     -- 11. V_SOTHULY
                      p_THAMPHANGIAIQUYET,     -- 12. V_THAMPHAN_ID
                      p_TRANGTHAIGIAIQUYET,    -- 13. V_TINHTRANG_GIAIQUYET
                      NULL,                     -- 14. V_TUNGAY
                      NULL,                     -- 15. V_DENNGAY
                      NULL,                     -- 16. V_KETQUA
                      NULL,                     -- 17. V_SO_QD
                      NULL,                     -- 18. V_NGAY_QD
                      NULL,                     -- 19. V_THUKY_ID
                      NULL,                     -- 20. V_THOIHAN_GQ
                      NULL,                     -- 21. V_LOAIDON
                      NULL,                     -- 22. V_PT_RKINHNGHIEM
                      NULL,                     -- 23. V_GQDON
                      NULL,                     -- 24. V_UTTP
                      0,                        -- 25. VCHECKTK
                      0,                        -- 26. V_TRANGTHAIVUAN
                      NULL,                     -- 27. V_VAITRO_THAMPHAN
                      0,                        -- 28. V_CHECK_HOAGIAI
                      0,                        -- 29. V_HOAGIAI_TRANGTHAI
                      NULL,                     -- 30. V_HOAGIAI_TUNGAY
                      NULL,                     -- 31. V_HOAGIAI_DENNGAY
                      NULL, -- AN_DA_KET_THUC
                      1,                        -- 32. PAGE_INDEX
                      V_PROCEDURE_PAGESIZE,     -- 33. PAGE_SIZE
                      CURSOR_RETURN2            -- 34. CURRETURN (OUT)
                  );
                                                             
                  IF CURSOR_RETURN2 IS NOT NULL THEN
                      PROCESS_CURSOR(CURSOR_RETURN2, '5', 1, V_CURRENT_TOAANID);
                      CLOSE CURSOR_RETURN2;
                  END IF;
  
                  -- Bước 3: lấy dữ liệu chưa thụ lý với TRANGTHAIGIAIQUYET = ''
--                  IF (NVL(LENGTH(p_TINHTRANGTHULY),0) = 0) OR p_TINHTRANGTHULY = '2' THEN
--                      V_TRANGTHAIGIAIQUYET := '';
--                      V_TINHTRANGTHULY := '2';
--                      PKG_STPT_ALD_GS.ALD_DON_SEARCH(
--                        V_CAP_XET_XU_LOGIN,       -- 1. V_CAP_XET_XU_LOGIN
--                        p_TENVUAN,                -- 2. V_TEN_VU_AN  
--                        NULL,                     -- 3. V_QHPL
--                        p_MAVUVIEC,              -- 4. V_MA_VU_AN
--                        NULL,                     -- 5. V_TENDUONGSU
--                        3,                        -- 6. V_CAPXX
--                        V_CURRENT_TOAANID,       -- 7. V_TOAAN_ID
--                        V_TINHTRANGTHULY,        -- 8. V_TINHTRANG_THULY
--                        V_THULYTUNGAY,           -- 9. V_NGAYTHULY_TU
--                        V_THULYDENNGAY,          -- 10. V_NGAYTHULY_DEN
--                        NULL,                     -- 11. V_SOTHULY
--                        p_THAMPHANGIAIQUYET,     -- 12. V_THAMPHAN_ID
--                        V_TRANGTHAIGIAIQUYET,    -- 13. V_TINHTRANG_GIAIQUYET
--                        NULL,                     -- 14. V_TUNGAY
--                        NULL,                     -- 15. V_DENNGAY
--                        NULL,                     -- 16. V_KETQUA
--                        NULL,                     -- 17. V_SO_QD
--                        NULL,                     -- 18. V_NGAY_QD
--                        NULL,                     -- 19. V_THUKY_ID
--                        NULL,                     -- 20. V_THOIHAN_GQ
--                        NULL,                     -- 21. V_LOAIDON
--                        NULL,                     -- 22. V_PT_RKINHNGHIEM
--                        NULL,                     -- 23. V_GQDON
--                        NULL,                     -- 24. V_UTTP
--                        0,                        -- 25. VCHECKTK
--                        0,                        -- 26. V_TRANGTHAIVUAN
--                        NULL,                     -- 27. V_VAITRO_THAMPHAN
--                        0,                        -- 28. V_CHECK_HOAGIAI
--                        0,                        -- 29. V_HOAGIAI_TRANGTHAI
--                        NULL,                     -- 30. V_HOAGIAI_TUNGAY
--                        NULL,                     -- 31. V_HOAGIAI_DENNGAY
--                        1,                        -- 32. PAGE_INDEX
--                        V_PROCEDURE_PAGESIZE,     -- 33. PAGE_SIZE
--                        CURSOR_RETURN2            -- 34. CURRETURN (OUT)
--                    );
--                                                               
--                    IF CURSOR_RETURN2 IS NOT NULL THEN
--                        PROCESS_CURSOR(CURSOR_RETURN2, '5', 1, V_CURRENT_TOAANID);
--                        CLOSE CURSOR_RETURN2;
--                    END IF;
--                  END IF;

                END IF;

            END LOOP;
        ELSE
            -- TRANGTHAI = 0 hoặc NULL: Logic cũ với p_TOAANID
            -- BƯỚC 1: PKG_ALD_STPT_DS.ALD_DON_SEARCH_TURNING procedure call
            PKG_ALD_STPT_DS.ALD_DON_SEARCH_TURNING(V_CAP_XET_XU_LOGIN,p_TENVUAN,NULL,p_MAVUVIEC,NULL,p_CAPXETXU,p_TOAANID,p_TINHTRANGTHULY,
                                                    V_THULYTUNGAY,V_THULYDENNGAY,NULL,p_THAMPHANGIAIQUYET,p_TRANGTHAIGIAIQUYET,NULL,NULL,NULL,
                                                    NULL,NULL,NULL,NULL, NULL,NULL,NULL,NULL,0,NULL,NULL,1, 1,0,0,NULL,NULL,
                                                    NULL, 1, V_PROCEDURE_PAGESIZE, CURSOR_RETURN);
            IF CURSOR_RETURN IS NOT NULL THEN
                PROCESS_CURSOR(CURSOR_RETURN, '5', 0, p_TOAANID);
                CLOSE CURSOR_RETURN;
            END IF;

            -- Không lấy án TĐC với cấp sơ thẩm
            IF p_CAPXETXU <> 2 THEN
                                                    
              -- BƯỚC 2: PKG_STPT_ALD_GS.DON_SEARCH với đúng 33 parameters theo ALD_DON_BL.cs
              PKG_STPT_ALD_GS.ALD_DON_SEARCH(
                  V_CAP_XET_XU_LOGIN,       -- 1. V_CAP_XET_XU_LOGIN
                  p_TENVUAN,                -- 2. V_TEN_VU_AN  
                  NULL,                     -- 3. V_QHPL
                  p_MAVUVIEC,              -- 4. V_MA_VU_AN
                  NULL,                     -- 5. V_TENDUONGSU
                  3,                        -- 6. V_CAPXX
                  p_TOAANID,               -- 7. V_TOAAN_ID
                  p_TINHTRANGTHULY,        -- 8. V_TINHTRANG_THULY
                  V_THULYTUNGAY,           -- 9. V_NGAYTHULY_TU
                  V_THULYDENNGAY,          -- 10. V_NGAYTHULY_DEN
                  NULL,                     -- 11. V_SOTHULY
                  p_THAMPHANGIAIQUYET,     -- 12. V_THAMPHAN_ID
                  p_TRANGTHAIGIAIQUYET,    -- 13. V_TINHTRANG_GIAIQUYET
                  NULL,                     -- 14. V_TUNGAY
                  NULL,                     -- 15. V_DENNGAY
                  NULL,                     -- 16. V_KETQUA
                  NULL,                     -- 17. V_SO_QD
                  NULL,                     -- 18. V_NGAY_QD
                  NULL,                     -- 19. V_THUKY_ID
                  NULL,                     -- 20. V_THOIHAN_GQ
                  NULL,                     -- 21. V_LOAIDON
                  NULL,                     -- 22. V_PT_RKINHNGHIEM
                  NULL,                     -- 23. V_GQDON
                  NULL,                     -- 24. V_UTTP
                  0,                        -- 25. VCHECKTK
                  0,                        -- 26. V_TRANGTHAIVUAN
                  NULL,                     -- 27. V_VAITRO_THAMPHAN
                  0,                        -- 28. V_CHECK_HOAGIAI
                  0,                        -- 29. V_HOAGIAI_TRANGTHAI
                  NULL,                     -- 30. V_HOAGIAI_TUNGAY
                  NULL,                     -- 31. V_HOAGIAI_DENNGAY
                  NULL, -- AN_DA_KET_THUC
                  1,                        -- 32. PAGE_INDEX
                  V_PROCEDURE_PAGESIZE,     -- 33. PAGE_SIZE
                  CURSOR_RETURN2            -- 34. CURRETURN (OUT)
              );
                                                         
              IF CURSOR_RETURN2 IS NOT NULL THEN
                  PROCESS_CURSOR(CURSOR_RETURN2, '5', 1, p_TOAANID);
                  CLOSE CURSOR_RETURN2;
              END IF;
  
              -- Bước 3: lấy dữ liệu chưa thụ lý với TRANGTHAIGIAIQUYET = ''
              IF (NVL(LENGTH(p_TINHTRANGTHULY),0) = 0) OR p_TINHTRANGTHULY = '2' THEN
                  V_TRANGTHAIGIAIQUYET := '';
                  V_TINHTRANGTHULY := '2';

                  PKG_STPT_ALD_GS.ALD_DON_SEARCH(
                      V_CAP_XET_XU_LOGIN,       -- 1. V_CAP_XET_XU_LOGIN
                      p_TENVUAN,                -- 2. V_TEN_VU_AN  
                      NULL,                     -- 3. V_QHPL
                      p_MAVUVIEC,              -- 4. V_MA_VU_AN
                      NULL,                     -- 5. V_TENDUONGSU
                      3,                        -- 6. V_CAPXX
                      p_TOAANID,               -- 7. V_TOAAN_ID
                      V_TINHTRANGTHULY,        -- 8. V_TINHTRANG_THULY
                      V_THULYTUNGAY,           -- 9. V_NGAYTHULY_TU
                      V_THULYDENNGAY,          -- 10. V_NGAYTHULY_DEN
                      NULL,                     -- 11. V_SOTHULY
                      p_THAMPHANGIAIQUYET,     -- 12. V_THAMPHAN_ID
                      V_TRANGTHAIGIAIQUYET,    -- 13. V_TINHTRANG_GIAIQUYET
                      NULL,                     -- 14. V_TUNGAY
                      NULL,                     -- 15. V_DENNGAY
                      NULL,                     -- 16. V_KETQUA
                      NULL,                     -- 17. V_SO_QD
                      NULL,                     -- 18. V_NGAY_QD
                      NULL,                     -- 19. V_THUKY_ID
                      NULL,                     -- 20. V_THOIHAN_GQ
                      NULL,                     -- 21. V_LOAIDON
                      NULL,                     -- 22. V_PT_RKINHNGHIEM
                      NULL,                     -- 23. V_GQDON
                      NULL,                     -- 24. V_UTTP
                      0,                        -- 25. VCHECKTK
                      0,                        -- 26. V_TRANGTHAIVUAN
                      NULL,                     -- 27. V_VAITRO_THAMPHAN
                      0,                        -- 28. V_CHECK_HOAGIAI
                      0,                        -- 29. V_HOAGIAI_TRANGTHAI
                      NULL,                     -- 30. V_HOAGIAI_TUNGAY
                      NULL,                     -- 31. V_HOAGIAI_DENNGAY
                      NULL, -- AN_DA_KET_THUC
                      1,                        -- 32. PAGE_INDEX
                      V_PROCEDURE_PAGESIZE,     -- 33. PAGE_SIZE
                      CURSOR_RETURN2            -- 34. CURRETURN (OUT)
                  );
                                                             
                  IF CURSOR_RETURN2 IS NOT NULL THEN
                      PROCESS_CURSOR(CURSOR_RETURN2, '5', 1, p_TOAANID);
                      CLOSE CURSOR_RETURN2;
                  END IF;
              END IF;

            END IF;
        END IF;
        
        -- BƯỚC 3: Tính tổng COUNTALL thực tế từ cả 2 procedures
        V_REAL_COUNTALL := V_COUNTALL_PROC1 + V_COUNTALL_PROC2;
            
        -- BƯỚC 4: Final query với DISTINCT để loại bỏ duplicate (bỏ STT)
        OPEN p_CURSOR FOR
SELECT DISTINCT V_REAL_COUNTALL AS COUNTALL,
                A.ID,
                A.MAVUVIEC,
                A.TENVUVIEC,
                A.SOTHUTU,
                A.NGAYNHANDON,
                A.HINHTHUCNHANDON,
                A.MAGIAIDOAN,
                A.QHPLTKID,
                A.TOAANID,
                A.QUANHEPL,
                A.BANAN_QD_ST,
                A.QD_PT,
                A.KHANGNGHI_ST,
                A.CHECK_THULY,
                A.HOTENBICAN,
                A.NGUOITAO,
                A.NGAY_TAO AS NGAYTHULY,
                A.NGAYTAO,
                A.TENTOASOTHAM,
                A.GIAIDOANVUVIEC,
                A.TRUONGHOPGIAONHAN,
                A.KHANGCAO_ST,
                A.TINHTRANG_GQ,
                A.THULYXXLAI,
                A.LOAIAN_ID,
                LA.LOAI_AN_TEN,
                B.ID AS MAPPINGID,
                B.LYDOMA AS LYDO,
                B.NGAYGIAO AS THOIGIANBANGIAO,
                B.TRANGTHAI,
                C.TEN AS TOANHAN,
                LD.TEN AS LYDOTEN
  FROM TABLE (V_TABLE_TIMKIEM) A
    LEFT JOIN DM_LOAIAN LA
      ON LA.ID = A.LOAIAN_ID
    LEFT JOIN VUAN_BANGIAO_MAPPING B
      ON A.ID = B.VUVIECID
      AND b.TOAANGIAOID = P_TOAANID
      AND b.VUVIECLOAI = 'AN_LAODONG'
      AND (1 = (CASE 
                    WHEN P_TRANGTHAI = 0 THEN 1
                    WHEN P_TRANGTHAIGIAIQUYET IS NULL THEN 1
                    WHEN P_TRANGTHAIGIAIQUYET = 1 THEN 
                        CASE WHEN B.TRANGTHAIGIAIQUYET = 1 OR B.TRANGTHAIGIAIQUYET IS NULL THEN 1 ELSE 0 END
                    WHEN P_TRANGTHAIGIAIQUYET = 7 THEN 
                        CASE WHEN B.TRANGTHAIGIAIQUYET = 7 THEN 1 ELSE 0 END
                    ELSE 0
                END))
    LEFT JOIN DM_TOAAN C
      ON CASE WHEN b.TOAANNHANID IS NULL THEN 0 ELSE b.TOAANNHANID END = C.ID
    LEFT JOIN DM_DATAITEM ld
      ON b.LYDOMA = ld.MA
  WHERE 1 = 1
    -- Loại trừ những bản ghi mapping mà toà hiện tại đã nhận (TOAANNHANID = p_TOAANID)
    AND (B.TOAANNHANID IS NULL
    OR B.TOAANNHANID != P_TOAANID)
    AND (1 = (CASE
      -- TRANGTHAI = 0: Loại bỏ những bản ghi đã có mapping với toaangiaoid = p_toaanid
      WHEN P_TRANGTHAI = 0 THEN CASE WHEN NOT EXISTS (SELECT 1
                  FROM VUAN_BANGIAO_MAPPING vm
                  WHERE vm.VUVIECID = A.ID
                    AND vm.TOAANGIAOID = P_TOAANID
                    AND vm.VUVIECLOAI = 'AN_LAODONG') THEN 1 ELSE 0 END
      -- TRANGTHAI = 1: Chỉ lấy những bản ghi có mapping 
      WHEN P_TRANGTHAI = 1 AND
        B.TRANGTHAI IS NOT NULL THEN 1
      -- TRANGTHAI = NULL hoặc khác: Lấy tất cả
      WHEN P_TRANGTHAI IS NULL THEN 1 WHEN P_TRANGTHAI NOT IN (0, 1) THEN 1 ELSE 0 END))
  ORDER BY A.ID DESC,
           B.ID DESC;
    END ALD_VUAN_BANGIAO_MAPPING_GET_AN_BAN_GIAO;
   
   PROCEDURE ALD_VUAN_BANGIAO_MAPPING_GETS_CHONHAN (
        p_LOAIANID IN varchar2,
        p_TOAANID IN NUMBER,
        p_MAVUVIEC IN varchar2,
        p_THULYTUNGAY IN date,
        p_THULYDENNGAY IN date,
        p_TINHTRANGTHULY IN nvarchar2,
        p_THAMPHANGIAIQUYET IN nvarchar2,
        p_TENVUAN IN nvarchar2,    
        p_TRANGTHAIGIAIQUYET IN nvarchar2,    
        p_CAPXETXU IN nvarchar2,  
        p_TRANGTHAI IN NVARCHAR2,
        p_CURSOR OUT SYS_REFCURSOR
    ) AS
        BEGIN
            OPEN p_CURSOR FOR
                SELECT  
                    DISTINCT
                    -- Mapping
                    mapping.ID as MAPPINGID,
                    mapping.NGAYGIAO,
                    mapping.NGAYNHAN,
                    mapping.TRANGTHAI,
                    mapping.GHICHU,
                    -- Vụ việc
                    don.ID AS VUVIECID,
                    don.MAVUVIEC AS VUVIECMA,
                    don.TENVUVIEC AS VUVIECTEN, 
                    -- Toà giao
                    mapping.TOAANGIAOID,
                    taGiao.TEN AS TOAANGIAOTEN,
                    -- Toà nhận
                    mapping.TOAANNHANID,
                    -- Lý do
                    mapping.LYDOMA,
                    lyDo.TEN AS LYDOTEN
                from ALD_DON don 
                JOIN VUAN_BANGIAO_MAPPING mapping ON don.ID = mapping.VUVIECID AND MAPPING.VUVIECLOAI = 'AN_LAODONG'
                JOIN DM_TOAAN taGiao ON case when mapping.TOAANGIAOID is null then 0 else mapping.TOAANGIAOID end = taGiao.ID
                JOIN DM_TOAAN taNhan ON case when mapping.TOAANNHANID is null then 0 else mapping.TOAANNHANID end = taNhan.ID
                JOIN DM_DATAITEM lyDo ON mapping.LYDOMA = lyDo.MA
                LEFT JOIN ALD_SOTHAM_THULY thuLy ON don.ID = thuLy.DONID
                WHERE mapping.TOAANNHANID = P_TOAANID 
                AND  (1=(CASE WHEN (p_MAVUVIEC || ' ')=' '  THEN 1 WHEN LOWER(don.MAVUVIEC) LIKE  ('%' || LOWER(p_MAVUVIEC) || '%') THEN 1 Else 0 END))
                And (1=(CASE WHEN p_THULYTUNGAY is NULL THEN 1 WHEN thuLy.NGAYTHULY >= p_THULYTUNGAY  THEN 1 Else 0 END))
                And (1=(CASE WHEN p_THULYDENNGAY is NULL THEN 1 WHEN thuLy.NGAYTHULY <= p_THULYDENNGAY  THEN 1 Else 0 END))  
                AND  (1=(CASE WHEN (p_TINHTRANGTHULY|| ' ')=' '  THEN 1 WHEN LOWER(don.MAVUVIEC) LIKE  ('%' || LOWER(p_MAVUVIEC) || '%') THEN 1 Else 0 END))
                AND  (1=(CASE WHEN (p_THAMPHANGIAIQUYET|| ' ')=' '  THEN 1 WHEN LOWER(don.THAMPHANKYNHANDON) LIKE  ('%' || LOWER(p_THAMPHANGIAIQUYET) || '%') THEN 1 Else 0 END))
                AND  (1=(CASE WHEN (p_TENVUAN|| ' ')=' '  THEN 1 WHEN LOWER(don.TENVUVIEC) LIKE  ('%' || LOWER(p_TENVUAN) || '%') THEN 1 Else 0 END))
--                AND  (1=(CASE WHEN (p_TRANGTHAIGIAIQUYET|| ' ')=' ' THEN 1 WHEN don.TRANGTHAI LIKE P_TRANGTHAIGIAIQUYET THEN 1 Else 0 END))
--                AND  (1=(CASE WHEN (p_CAPXETXU|| ' ')=' '  THEN 1 WHEN don.MAGIAIDOAN = p_CAPXETXU THEN 1 Else 0 END))
                -- Trạng thái giải quyết
                AND (1 = (CASE 
                              WHEN P_TRANGTHAIGIAIQUYET IS NULL THEN 1
                              WHEN P_TRANGTHAIGIAIQUYET = '1' THEN 
                                  CASE WHEN MAPPING.TRANGTHAIGIAIQUYET = '1' OR MAPPING.TRANGTHAIGIAIQUYET IS NULL THEN 1 ELSE 0 END
                              WHEN P_TRANGTHAIGIAIQUYET = '7' THEN 
                                  CASE WHEN MAPPING.TRANGTHAIGIAIQUYET = '7' THEN 1 ELSE 0 END
                              ELSE 0
                          END))
                -- Cấp xét xử
                AND (1 = (CASE WHEN p_CAPXETXU IS NULL THEN 1
                            WHEN p_CAPXETXU = 2 AND mapping.MAGIAIDOAN = 2 THEN 1 -- Cap So Tham
                            WHEN p_CAPXETXU = 3 AND mapping.MAGIAIDOAN IN (3,7) THEN 1 -- Cap Phuc Tham
                            WHEN p_CAPXETXU NOT IN (2, 3) THEN 1
                            ELSE 0 END))
                AND  (1=(CASE WHEN (p_TRANGTHAI|| ' ')=' '  THEN 1 WHEN LOWER(mapping.TRANGTHAI) = LOWER(p_TRANGTHAI) THEN 1 Else 0 END))
                ORDER BY mapping.ID DESC;
    END ALD_VUAN_BANGIAO_MAPPING_GETS_CHONHAN;
   
	PROCEDURE ALD_VUAN_BANGIAO_MAPPING_NHAN (
        p_ID IN NUMBER,
        p_VUVIECID IN NUMBER,
        p_TOAANNHANID IN NUMBER,
        p_NGAYNHAN IN DATE
    ) AS
        v_MAGIAIDOAN NUMBER;
        v_TOAANID NUMBER;
        v_TOAPHUCTHAMID NUMBER;
        v_TRANGTHAIGIAIQUYET VARCHAR2(20);

        v_tracedata VARCHAR2(1024);
        v_output VARCHAR2(512);
    BEGIN
        v_tracedata := '(' || 
         'p_ID => ' || p_ID || ',' ||
         'p_VUVIECID => ' || p_VUVIECID || ',' ||
         'p_TOAANNHANID => ' || p_TOAANNHANID || ',' ||
         'p_NGAYNHAN => ' || p_NGAYNHAN || ',' ||
         ' );';

        -- Lấy giai đoạn hiện tại của án
        SELECT don.TOAANID, don.TOAPHUCTHAMID
        INTO v_TOAANID, v_TOAPHUCTHAMID
        FROM ALD_DON don 
        WHERE don.ID = p_VUVIECID;

        -- Lấy thông tin mapping
        SELECT vbm.MAGIAIDOAN, vbm.TRANGTHAIGIAIQUYET
        INTO v_MAGIAIDOAN, v_TRANGTHAIGIAIQUYET
        FROM VUAN_BANGIAO_MAPPING vbm
        WHERE vbm.ID = p_ID AND vbm.TRANGTHAI = 'TTBG_CHONHAN';

        -- Kiểm tra giai đoạn hợp lệ
        IF v_MAGIAIDOAN NOT IN (2, 3, 7) THEN
            RAISE_APPLICATION_ERROR(-20001, 'Giai đoạn không hợp lệ.');
        END IF;

        -- Cập nhật án đã kết thúc với trạng thái giải quyết = 7
        UPDATE ALD_DON_GIAIDOAN
        SET AN_DA_KET_THUC = CASE 
                WHEN v_TRANGTHAIGIAIQUYET = 7 THEN 1 
                ELSE AN_DA_KET_THUC 
            END
        WHERE DONID = p_VUVIECID AND MAGIAIDOAN = v_MAGIAIDOAN;

        -- Xử lý cập nhật theo giai đoạn
        IF v_MAGIAIDOAN = 2 THEN
            -- SƠ THẨM
            -- Update TOAID cho ALD_DON
            UPDATE ALD_DON
            SET TOAANID = p_TOAANNHANID
            WHERE ID = p_VUVIECID;

            -- Kiểm tra xem có update được chính xác 1 bản ghi ALD_DON hay không
            IF SQL%ROWCOUNT != 1 THEN
                ROLLBACK;
                RAISE_APPLICATION_ERROR(-20002, 'Lỗi cập nhật ALD_DON (Sơ thẩm)');
            END IF;
            
            -- Update TOAID cho ALD_SOTHAM_THULY
            UPDATE ALD_SOTHAM_THULY
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID;
            
            -- Update TOAID ALD_DON_GIAIDOAN
            UPDATE ALD_DON_GIAIDOAN
            SET TOA_GIAIQUYET_ID = v_TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL AND MAGIAIDOAN = v_MAGIAIDOAN;
            
            UPDATE ALD_DON_GIAIDOAN
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID AND MAGIAIDOAN = v_MAGIAIDOAN;

            -- Update DON_CHITIET
            UPDATE DON_CHITIET
            SET TOA_GIAIQUYET_ID = v_TOAANID
            WHERE DONID = p_VUVIECID AND LOAIANID = 5 AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;
                    
            UPDATE DON_CHITIET
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND LOAIANID = 5 AND TOAANID = v_TOAANID;

            -- Update ALD_TONGDAT
            UPDATE ALD_TONGDAT
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID;

            -- Update DON_KHAC
			UPDATE DON_KHAC
            SET TOA_GIAIQUYET_ID = v_TOAANID
            WHERE DONID = p_VUVIECID AND LOAIANID = 5 AND TOAANID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;
                    
            UPDATE DON_KHAC
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND LOAIANID = 5 AND TOAANID = v_TOAANID;

            -- Update TOAID ALD_DON_XULY
            UPDATE ALD_DON_XULY
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID;  

            -- Update TOAID cho ALD_SOTHAM_BANAN
            -- UPDATE ALD_SOTHAM_BANAN
            -- SET TOA_GIAIQUYET_ID = v_TOAANID,
            --     TOAANID = p_TOAANNHANID
            -- WHERE DONID = p_VUVIECID; 

            -- Update TOAID cho ALD_SOTHAM_QUYETDINH
            UPDATE ALD_SOTHAM_QUYETDINH
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID;  
           
           	--Backup và cập nhật thông tin TOACHUYENID của trường hợp ST => PT 
            UPDATE ALD_CHUYEN_NHAN_AN 
            SET TOA_GIAIQUYET_ID = TOACHUYENID, 
                TOACHUYENID = p_TOAANNHANID 
            WHERE VUANID = p_VUVIECID AND TOACHUYENID = v_TOAANID;
            
            UPDATE ALD_CHUYEN_NHAN_AN
            SET TOA_GIAIQUYET_NHAN_ID = TOANHANID, 
                TOANHANID = p_TOAANNHANID
            WHERE VUANID = p_VUVIECID AND TOANHANID = v_TOAANID;
            
           	-- Với trường hợp chuyển ST -> ST, sau khi chuyển án tạm đình chỉ
            UPDATE ALD_CHUYEN_NHAN_AN
      			SET
      				TOA_GIAIQUYET_NHAN_ID = TOANHANID,
      				TOANHANID = p_TOAANNHANID
      			WHERE
      				VUANID in (
        				SELECT CNA.MAP_VUANID_NEW
        				FROM ALD_CHUYEN_NHAN_AN CNA
        				WHERE CNA.VUANID = p_VUVIECID AND CNA.MAP_VUANID_NEW IS NOT NULL
              );

            -- Với trường hợp chuyển ST -> ST, sau khi chuyển án không đủ thẩm quyền xét xử
            UPDATE ALD_CHUYEN_NHAN_AN
      			SET
      				TOA_GIAIQUYET_NHAN_ID = TOANHANID,
      				TOANHANID = p_TOAANNHANID
      			WHERE
      				MAP_VUANID_NEW = p_VUVIECID AND MAP_VUANID_NEW IS NOT NULL;
        ELSIF v_MAGIAIDOAN IN (3,7) THEN
            -- PHÚC THẨM
            -- Update TOAID cho ALD_DON
            UPDATE ALD_DON
            SET TOAPHUCTHAMID = p_TOAANNHANID
            WHERE ID = p_VUVIECID;

            -- Kiểm tra xem có update được chính xác 1 bản ghi ALD_DON hay không
            IF SQL%ROWCOUNT != 1 THEN
                ROLLBACK;
                RAISE_APPLICATION_ERROR(-20003, 'Lỗi cập nhật ALD_DON (Phúc thẩm)');
            END IF;
           
           	UPDATE ALD_DON
            SET TOA_PHUCTHAM_GIAIQUYET_ID = v_TOAPHUCTHAMID
            WHERE ID = p_VUVIECID AND TOA_PHUCTHAM_GIAIQUYET_ID IS NULL;
            
            -- Update ALD_PHUCTHAM_THULY
            UPDATE ALD_PHUCTHAM_THULY
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID;
           
           	UPDATE ALD_PHUCTHAM_THULY
            SET TOA_GIAIQUYET_ID = v_TOAPHUCTHAMID
            WHERE DONID = p_VUVIECID AND TOA_GIAIQUYET_ID IS NULL;
            
            -- Update TOAID ALD_DON_GIAIDOAN
            UPDATE ALD_DON_GIAIDOAN
            SET TOA_PHUCTHAM_GIAIQUYET_ID = v_TOAPHUCTHAMID
            WHERE DONID = p_VUVIECID AND TOAPHUCTHAMID = v_TOAPHUCTHAMID AND TOA_PHUCTHAM_GIAIQUYET_ID IS NULL AND MAGIAIDOAN = v_MAGIAIDOAN;
            
            UPDATE ALD_DON_GIAIDOAN
            SET TOAPHUCTHAMID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAPHUCTHAMID = v_TOAPHUCTHAMID AND MAGIAIDOAN = v_MAGIAIDOAN;
			
			-- UPDATE TOAID DON_KHAC
			UPDATE DON_KHAC
            SET TOA_GIAIQUYET_ID = v_TOAPHUCTHAMID
            WHERE DONID = p_VUVIECID AND LOAIANID = 5 AND TOAANID = v_TOAPHUCTHAMID AND TOA_GIAIQUYET_ID IS NULL;
			
			UPDATE DON_KHAC
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND LOAIANID = 5 AND TOAANID = v_TOAPHUCTHAMID;
			
           	-- update PT 11/07/2025
            -- UPDATE ALD_KCKNQDK_PHUCTHAM_QUYETDINH
            UPDATE ALD_KCKNQDK_PHUCTHAM_QUYETDINH
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID;
            
            -- UPDATE ALD_KCKNQDK_PHUCTHAM_THULY
            UPDATE ALD_KCKNQDK_PHUCTHAM_THULY
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID;
			
           	-- UPDATE ALD_TONGDAT
           	UPDATE ALD_TONGDAT
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID;

            
            -- UPDATE AHN_PHUCTHAM_BANAN
--            UPDATE ALD_PHUCTHAM_BANAN
--            SET TOA_GIAIQUYET_ID = v_TOAPHUCTHAMID,
--                    TOAANID = p_TOAANNHANID
--            WHERE DONID = p_VUVIECID;
--            
            -- UPDATE ALD_PHUCTHAM_QUYETDINH
            UPDATE ALD_PHUCTHAM_QUYETDINH
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID;
            
           IF (v_MAGIAIDOAN = 7) THEN
           		-- Backup và cập nhật thông tin TOACHUYENID của trường hợp PT => ST
	            UPDATE ALD_CHUYEN_NHAN_AN 
	            SET TOA_GIAIQUYET_ID = TOACHUYENID, 
	                TOACHUYENID = p_TOAANNHANID 
	            WHERE MAP_VUANID_NEW = p_VUVIECID AND TOACHUYENID = v_TOAPHUCTHAMID;
	            
	            UPDATE ALD_CHUYEN_NHAN_AN
	            SET TOA_GIAIQUYET_NHAN_ID = TOANHANID, 
	                TOANHANID = p_TOAANNHANID
	            WHERE MAP_VUANID_NEW = p_VUVIECID AND TOANHANID = v_TOAPHUCTHAMID;
           ELSE
	            -- Backup và cập nhật thông tin TOACHUYENID của trường hợp PT => ST
	            UPDATE ALD_CHUYEN_NHAN_AN 
	            SET TOA_GIAIQUYET_ID = TOACHUYENID, 
	                TOACHUYENID = p_TOAANNHANID 
	            WHERE VUANID = p_VUVIECID AND TOACHUYENID = v_TOAPHUCTHAMID;
	            
	            UPDATE ALD_CHUYEN_NHAN_AN
	            SET TOA_GIAIQUYET_NHAN_ID = TOANHANID, 
	                TOANHANID = p_TOAANNHANID
	            WHERE VUANID = p_VUVIECID AND TOANHANID = v_TOAPHUCTHAMID;
           END IF;
        END IF;
        
        -- Update TRANGTHAI cho VUAN_BANGIAO_MAPPING
        UPDATE VUAN_BANGIAO_MAPPING
        SET TRANGTHAI = 'TTBG_DANHAN',
            NGAYNHAN = p_NGAYNHAN
        WHERE ID = p_ID;
        
        COMMIT;
        
    EXCEPTION
      WHEN OTHERS THEN
          -- Rollback in case of any exception
          ROLLBACK;

          v_output := 'Finish procedure Due to Exception: Error:' || SQLCODE || ',' || SQLERRM;
          PKG_TRACELOG.SP_INSERT_LOG_ERROR(
              p_functionname => 'PKG_BAN_GIAO_AN.ALD_VUAN_BANGIAO_MAPPING_NHAN',
              p_description => v_output,
              p_notes => v_tracedata
          );

          -- Re-raise the exception
          RAISE;
    END ALD_VUAN_BANGIAO_MAPPING_NHAN;
        
  -- [ALD] KIỂM TRA THAY ĐỔI
    PROCEDURE ALD_VUAN_BANGIAO_MAPPING_KTTHAYDOI (
        p_ID IN NUMBER,
        p_result OUT NUMBER,
        p_message OUT VARCHAR2
    )
    AS
        v_VUVIECID NUMBER;
        v_TOAANNHANID NUMBER;
        v_NGANHAN DATE;
        v_count NUMBER;
    BEGIN
        -- Khởi tạo giá trị mặc định
        p_result := 0;
        p_message := '';

        -- Lấy thông tin Mapping
        SELECT VUVIECID, TOAANNHANID, NGAYNHAN
        INTO  v_VUVIECID, v_TOAANNHANID, v_NGANHAN
        FROM VUAN_BANGIAO_MAPPING
        WHERE ID = p_ID AND TRANGTHAI = 'TTBG_DANHAN';
        
        -- Kiểm tra các bảng có thay đổi sau ngày nhận án
        
        -- Kiểm tra ALD_ANPHI
        SELECT COUNT(*) INTO v_count 
        FROM ALD_ANPHI 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN)
          AND SOBIENLAI IS NOT NULL AND TAMUNGANPHI IS NOT NULL AND NGUOINHANID IS NOT NULL;
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin án phí đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra ALD_CHUYEN_NHAN_AN
        SELECT COUNT(*) INTO v_count 
        FROM ALD_CHUYEN_NHAN_AN 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin chuyển nhận án đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra ALD_DON_DUONGSU
        SELECT COUNT(*) INTO v_count 
        FROM ALD_DON_DUONGSU 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin đương sự đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra ALD_DON_GIAIDOAN
        SELECT COUNT(*) INTO v_count 
        FROM ALD_DON_GIAIDOAN 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin giai đoạn đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra ALD_DON_TAILIEU
        SELECT COUNT(*) INTO v_count 
        FROM ALD_DON_TAILIEU 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin tài liệu đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra ALD_DON_THAMGIATOTUNG
        SELECT COUNT(*) INTO v_count 
        FROM ALD_DON_THAMGIATOTUNG 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin tham gia tố tụng đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra ALD_DON_THAMPHAN
        SELECT COUNT(*) INTO v_count 
        FROM ALD_DON_THAMPHAN 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin thẩm phán đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra ALD_DON_XULY
        SELECT COUNT(*) INTO v_count 
        FROM ALD_DON_XULY 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin xử lý đơn đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra ALD_FILE
--        SELECT COUNT(*) INTO v_count 
--        FROM ALD_FILE 
--        WHERE DONID = v_VUVIECID 
--          AND (NGAYTAO >= v_NGANHAN);
--        
--        IF v_count > 0 THEN
--            p_result := 1;
--            p_message := 'Thông tin đơn đã có thay đổi, không thể trả án.';
--            RETURN;
--        END IF;

        -- Kiểm tra ALD_KCKNQDK_PHUCTHAM_HDXX
        SELECT COUNT(*) INTO v_count 
        FROM ALD_KCKNQDK_PHUCTHAM_HDXX 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin HĐXX KCKNQDK phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra ALD_KCKNQDK_PHUCTHAM_QUYETDINH
        SELECT COUNT(*) INTO v_count 
        FROM ALD_KCKNQDK_PHUCTHAM_QUYETDINH 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin quyết định KCKNQDK phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra ALD_KCKNQDK_PHUCTHAM_THAMGIATOTUNG
        SELECT COUNT(*) INTO v_count 
        FROM ALD_KCKNQDK_PHUCTHAM_THAMGIATOTUNG 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin tham gia tố tụng KCKNQDK phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra ALD_KCKNQDK_PHUCTHAM_THULY
        SELECT COUNT(*) INTO v_count 
        FROM ALD_KCKNQDK_PHUCTHAM_THULY 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin thụ lý KCKNQDK phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra ALD_PHUCTHAM_BANAN
        SELECT COUNT(*) INTO v_count 
        FROM ALD_PHUCTHAM_BANAN 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin bản án phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra ALD_PHUCTHAM_BANAN_FILE
        SELECT COUNT(*) INTO v_count 
        FROM ALD_PHUCTHAM_BANAN_FILE f
        WHERE EXISTS (
            SELECT 1 FROM ALD_PHUCTHAM_BANAN b 
            WHERE b.DONID = v_VUVIECID AND b.ID = f.BANANID
        ) AND f.NGAYTAO >= v_NGANHAN;
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin bản án phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra ALD_PHUCTHAM_BANAN_TGTT
--        SELECT COUNT(*) INTO v_count 
--        FROM ALD_PHUCTHAM_BANAN_TGTT 
--        WHERE DONID = v_VUVIECID AND NGAYNHANBANAN >= v_NGANHAN;
--        
--        IF v_count > 0 THEN
--            p_result := 1;
--            p_message := 'Thông tin bản án phúc thẩm đã có thay đổi, không thể trả án.';
--            RETURN;
--        END IF;

         -- Kiểm tra ALD_PHUCTHAM_DUONGSU
--        SELECT COUNT(*) INTO v_count 
--        FROM ALD_PHUCTHAM_DUONGSU 
--        WHERE DONID = v_VUVIECID 
--          AND (NGAYTAO >= v_NGANHAN);
        
--        IF v_count > 0 THEN
--            p_result := 1;
--            p_message := 'Thông tin HĐXX phúc thẩm đã có thay đổi, không thể trả án.';
--            RETURN;
--        END IF;
        
        -- Kiểm tra ALD_PHUCTHAM_HDXX
        SELECT COUNT(*) INTO v_count 
        FROM ALD_PHUCTHAM_HDXX 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin HĐXX phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra ALD_PHUCTHAM_HOAGIAI
        SELECT COUNT(*) INTO v_count 
        FROM ALD_PHUCTHAM_HOAGIAI 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin hoà giải phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra ALD_PHUCTHAM_QUYETDINH
        SELECT COUNT(*) INTO v_count 
        FROM ALD_PHUCTHAM_QUYETDINH 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin quyết định phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra ALD_PHUCTHAM_THAMGIATOTUNG
        SELECT COUNT(*) INTO v_count 
        FROM ALD_PHUCTHAM_THAMGIATOTUNG 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin tham gia tố tụng phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra ALD_PHUCTHAM_THULY
        SELECT COUNT(*) INTO v_count 
        FROM ALD_PHUCTHAM_THULY 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin thụ lý phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra ALD_SAUXETXU
--        SELECT COUNT(*) INTO v_count 
--        FROM ALD_SAUXETXU 
--        WHERE VUANID = v_VUVIECID 
--          AND (NGAYTAO >= v_NGANHAN);
--        
--        IF v_count > 0 THEN
--            p_result := 1;
--            p_message := 'Thông tin sau xét xử đã có thay đổi, không thể trả án.';
--            RETURN;
--        END IF;

        -- Kiểm tra ALD_SOTHAM_BANAN
        SELECT COUNT(*) INTO v_count 
        FROM ALD_SOTHAM_BANAN 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin bản án sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra ALD_SOTHAM_BANAN_ANPHI
        SELECT COUNT(*) INTO v_count 
        FROM ALD_SOTHAM_BANAN_ANPHI 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin án phí bản án sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra ALD_SOTHAM_BANAN_DIEULUAT
        SELECT COUNT(*) INTO v_count 
        FROM ALD_SOTHAM_BANAN_DIEULUAT 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin điều luật bản án sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra ALD_SOTHAM_BANAN_FILE
        SELECT COUNT(*) INTO v_count 
        FROM ALD_SOTHAM_BANAN_FILE 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin đơn bản án sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra ALD_SOTHAM_BANAN_TGTT
--        SELECT COUNT(*) INTO v_count 
--        FROM ALD_SOTHAM_BANAN_TGTT 
--        WHERE DONID = v_VUVIECID 
--          AND (NGAYTAO >= v_NGANHAN);
--        
--        IF v_count > 0 THEN
--            p_result := 1;
--            p_message := 'Thông tin đơn bản án sơ thẩm có thay đổi, không thể trả án.';
--            RETURN;
--        END IF;

        -- Kiểm tra ALD_SOTHAM_HDXX
        SELECT COUNT(*) INTO v_count 
        FROM ALD_SOTHAM_HDXX 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin HĐXX sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra ALD_SOTHAM_HOAGIAI
        SELECT COUNT(*) INTO v_count 
        FROM ALD_SOTHAM_HOAGIAI 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin hoà giải sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra ALD_SOTHAM_KHANGCAO
        SELECT COUNT(*) INTO v_count 
        FROM ALD_SOTHAM_KHANGCAO 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin kháng cáo sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

         -- Kiểm tra ALD_SOTHAM_KHANGNGHI
        SELECT COUNT(*) INTO v_count 
        FROM ALD_SOTHAM_KHANGNGHI 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin kháng nghị sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

         -- Kiểm tra ALD_SOTHAM_QUYETDINH
        SELECT COUNT(*) INTO v_count 
        FROM ALD_SOTHAM_QUYETDINH 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin quyết định sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

         -- Kiểm tra ALD_SOTHAM_RUTKCKN
        SELECT COUNT(*) INTO v_count 
        FROM ALD_SOTHAM_RUTKCKN 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin rút KCKN sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra ALD_SOTHAM_THAMGIATOTUNG
--        SELECT COUNT(*) INTO v_count 
--        FROM ALD_SOTHAM_THAMGIATOTUNG 
--        WHERE DONID = v_VUVIECID 
--          AND (NGAYTAO >= v_NGANHAN);
--        
--        IF v_count > 0 THEN
--            p_result := 1;
--            p_message := 'Thông tin tham gia TT sơ thẩm có thay đổi, không thể trả án.';
--            RETURN;
--        END IF;

          -- Kiểm tra ALD_SOTHAM_THULY
        SELECT COUNT(*) INTO v_count 
        FROM ALD_SOTHAM_THULY 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin thụ lý sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

          -- Kiểm tra ALD_TONGDAT
        SELECT COUNT(*) INTO v_count 
        FROM ALD_TONGDAT 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin tống đạt có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra ALD_TONGDAT_DOITUONG
        SELECT COUNT(*) INTO v_count 
        FROM ALD_TONGDAT_DOITUONG f
        WHERE EXISTS (
            SELECT 1 FROM ALD_TONGDAT b 
            WHERE b.DONID = v_VUVIECID AND b.ID = f.TONGDATID
        ) 
          AND f.NGAYTAO >= v_NGANHAN;
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin đối tượng tống đạt đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra ALD_TRUNGCAU_GIAMDINH
        SELECT COUNT(*) INTO v_count 
        FROM ALD_TRUNGCAU_GIAMDINH 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin trưng cầu giám định có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra ALD_XULY_VIPHAMHC
        SELECT COUNT(*) INTO v_count 
        FROM ALD_XULY_VIPHAMHC 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin xử lý vi phạm HC có thay đổi, không thể trả án.';
            RETURN;
        END IF;
                
        -- Kiểm tra DON_KHAC
        SELECT COUNT(*) INTO v_count 
        FROM DON_KHAC 
        WHERE DONID = v_VUVIECID 
          AND (NGAYNHANDON >= v_NGANHAN OR NGAYKHANGCAO >= v_NGANHAN) 
          AND LOAIANID = 5;
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin đơn đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra DON_KHAC_YEUCAU
        SELECT COUNT(*) INTO v_count 
        FROM DON_KHAC_YEUCAU y
        WHERE EXISTS (
            SELECT 1 FROM DON_KHAC d 
            WHERE d.DONID = v_VUVIECID 
              AND d.ID = y.DONKHACID
        ) AND (y.NGAYTAO >= v_NGANHAN);
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin đơn đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra DON_CHITIET
        SELECT COUNT(*) INTO v_count 
        FROM DON_CHITIET 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN) 
          AND LOAIANID = 5;
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin đơn đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
        -- Kiểm tra DON_DUONGSU_CHITIET
        SELECT COUNT(*) INTO v_count 
        FROM DON_DUONGSU_CHITIET 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN)
          AND LOAIAN = 5;
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin đương sự đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra HOSO_PT
        SELECT COUNT(*) INTO v_count 
        FROM HOSO_PT 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN)
          AND LOAIAN = 5;
        
        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin hồ sơ phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;
        
      EXCEPTION
          WHEN OTHERS THEN
              p_result := 1;
              p_message := 'Lỗi khi kiểm tra: ' || SQLERRM;
  END ALD_VUAN_BANGIAO_MAPPING_KTTHAYDOI;

  -- [ALD] TRẢ LẠI
    PROCEDURE ALD_VUAN_BANGIAO_MAPPING_TRALAI (
        p_ID IN NUMBER
    ) AS
        v_VUVIECID NUMBER;
        v_MAGIAIDOAN NUMBER;
        v_TOAANGIAOID NUMBER;
        v_TOAANNHANID NUMBER;

        v_tracedata VARCHAR2(1024);
        v_output VARCHAR2(512);
    BEGIN
        v_tracedata := '(' || 
         'p_ID => ' || p_ID || ',' ||
         ' );';

        -- Lấy thông tin Mapping
        SELECT VUVIECID, TOAANGIAOID, TOAANNHANID, MAGIAIDOAN
        INTO  v_VUVIECID, v_TOAANGIAOID, v_TOAANNHANID, v_MAGIAIDOAN
        FROM VUAN_BANGIAO_MAPPING
        WHERE ID = p_ID AND TRANGTHAI = 'TTBG_DANHAN';

        -- Xoá thông tin AN_DA_KET_THUC cho giai đoạn
        UPDATE ALD_DON_GIAIDOAN
        SET AN_DA_KET_THUC = NULL
        WHERE DONID = v_VUVIECID AND MAGIAIDOAN = v_MAGIAIDOAN AND (TOA_GIAIQUYET_ID = v_TOAANGIAOID OR TOA_PHUCTHAM_GIAIQUYET_ID = v_TOAANGIAOID);

        -- Xử lý cập nhật theo giai đoạn
        IF v_MAGIAIDOAN = 2 THEN
            -- SƠ THẨM
            -- Update ALD_DON
            UPDATE ALD_DON
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE ID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update ALD_SOTHAM_THULY
            UPDATE ALD_SOTHAM_THULY
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
            
            -- Update ALD_DON_GIAIDOAN
            UPDATE ALD_DON_GIAIDOAN
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update DON_CHITIET
            UPDATE DON_CHITIET
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND LOAIANID = 5 AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update ALD_TONGDAT
            UPDATE ALD_TONGDAT
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update DON_KHAC
            UPDATE DON_KHAC
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND LOAIANID = 5 AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update ALD_DON_XULY
            UPDATE ALD_DON_XULY
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update ALD_SOTHAM_BANAN
--            UPDATE ALD_SOTHAM_BANAN
--            SET TOAANID = TOA_GIAIQUYET_ID
--            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update ALD_SOTHAM_QUYETDINH
            UPDATE ALD_SOTHAM_QUYETDINH
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update ALD_CHUYEN_NHAN_AN
            -- Theo TOACHUYENID 
            UPDATE ALD_CHUYEN_NHAN_AN 
            SET TOACHUYENID = TOA_GIAIQUYET_ID 
            WHERE VUANID = v_VUVIECID AND TOACHUYENID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
            
            -- Theo TOANHANID
            UPDATE ALD_CHUYEN_NHAN_AN
            SET TOANHANID = TOA_GIAIQUYET_NHAN_ID
            WHERE VUANID = v_VUVIECID AND TOANHANID = v_TOAANNHANID AND TOA_GIAIQUYET_NHAN_ID = v_TOAANGIAOID;

            -- Với trường hợp chuyển ST -> ST, sau khi chuyển án tạm đình chỉ
          	UPDATE ALD_CHUYEN_NHAN_AN
            SET TOANHANID = TOA_GIAIQUYET_NHAN_ID
			      WHERE VUANID in (SELECT CNA.MAP_VUANID_NEW
				                     FROM ALD_CHUYEN_NHAN_AN CNA
                             WHERE CNA.VUANID = v_VUVIECID AND CNA.MAP_VUANID_NEW IS NOT NULL);

            -- Với trường hợp chuyển ST -> ST, sau khi chuyển án không đủ thẩm quyền xét xử
            UPDATE ALD_CHUYEN_NHAN_AN
      			SET
      				TOANHANID = TOA_GIAIQUYET_NHAN_ID
      			WHERE
      				MAP_VUANID_NEW = v_VUVIECID AND MAP_VUANID_NEW IS NOT NULL;

        ELSIF v_MAGIAIDOAN IN (3,7) THEN
            -- PHÚC THẨM

            -- Update ALD_DON
            UPDATE ALD_DON
            SET TOAPHUCTHAMID = TOA_PHUCTHAM_GIAIQUYET_ID
            WHERE ID = v_VUVIECID AND TOAPHUCTHAMID = v_TOAANNHANID AND TOA_PHUCTHAM_GIAIQUYET_ID = v_TOAANGIAOID;

            UPDATE ALD_DON
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE ID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update ALD_PHUCTHAM_THULY

            UPDATE ALD_PHUCTHAM_THULY
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update ALD_DON_GIAIDOAN
            UPDATE ALD_DON_GIAIDOAN
            SET TOAPHUCTHAMID = TOA_PHUCTHAM_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAPHUCTHAMID = v_TOAANNHANID AND TOA_PHUCTHAM_GIAIQUYET_ID = v_TOAANGIAOID;

            UPDATE ALD_DON_GIAIDOAN
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- UPDATE ALD_KCKNQDK_PHUCTHAM_QUYETDINH
            UPDATE ALD_KCKNQDK_PHUCTHAM_QUYETDINH
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
            
            -- UPDATE ALD_KCKNQDK_PHUCTHAM_THULY
            UPDATE ALD_KCKNQDK_PHUCTHAM_THULY
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
            
            -- UPDATE ALD_PHUCTHAM_BANAN
--            UPDATE ALD_PHUCTHAM_BANAN
--            SET TOAANID = TOA_GIAIQUYET_ID
--            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
            
            -- UPDATE ALD_PHUCTHAM_QUYETDINH
            UPDATE ALD_PHUCTHAM_QUYETDINH
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update ALD_TONGDAT
            UPDATE ALD_TONGDAT
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update DON_CHITIET
            UPDATE DON_CHITIET
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND LOAIANID = 5 AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update DON_KHAC
            UPDATE DON_KHAC
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND LOAIANID = 5 AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update HOSO_PT
            UPDATE HOSO_PT
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE VUANID = v_VUVIECID AND LOAIAN = 5 AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
            
            IF (v_MAGIAIDOAN = 7) THEN
              -- Update ALD_CHUYEN_NHAN_AN
              -- Theo TOACHUYENID 
              UPDATE ALD_CHUYEN_NHAN_AN 
	            SET TOACHUYENID = TOA_GIAIQUYET_ID 
	            WHERE MAP_VUANID_NEW = v_VUVIECID AND TOACHUYENID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
	            
              -- Theo TOANHANID 
	            UPDATE ALD_CHUYEN_NHAN_AN
	            SET TOANHANID = TOA_GIAIQUYET_NHAN_ID
	            WHERE MAP_VUANID_NEW = v_VUVIECID AND TOANHANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
           ELSE
	            -- Update ALD_CHUYEN_NHAN_AN
              -- Theo TOACHUYENID 
              UPDATE ALD_CHUYEN_NHAN_AN 
	            SET TOACHUYENID = TOA_GIAIQUYET_ID 
	            WHERE VUANID = v_VUVIECID AND TOACHUYENID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
	            
              -- Theo TOANHANID 
	            UPDATE ALD_CHUYEN_NHAN_AN
	            SET TOANHANID = TOA_GIAIQUYET_ID
	            WHERE VUANID = v_VUVIECID AND TOANHANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;
           END IF;
        END IF;
        
        -- Update TRANGTHAI cho VUAN_BANGIAO_MAPPING
        update VUAN_BANGIAO_MAPPING 
        SET TRANGTHAI = 'TTBG_CHONHAN'
        WHERE ID = p_ID;
        
        COMMIT;
        
    EXCEPTION
      WHEN OTHERS THEN
          -- Rollback in case of any exception
          ROLLBACK;

          v_output := 'Finish procedure Due to Exception: Error:' || SQLCODE || ',' || SQLERRM;
          PKG_TRACELOG.SP_INSERT_LOG_ERROR(
              p_functionname => 'PKG_BAN_GIAO_AN.ALD_VUAN_BANGIAO_MAPPING_TRALAI',
              p_description => v_output,
              p_notes => v_tracedata
          );

          -- Re-raise the exception
          RAISE;
    END ALD_VUAN_BANGIAO_MAPPING_TRALAI;

END PKG_BAN_GIAO_AN;

/
