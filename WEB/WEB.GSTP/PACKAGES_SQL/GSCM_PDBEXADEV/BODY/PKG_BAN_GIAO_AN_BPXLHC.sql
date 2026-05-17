CREATE OR REPLACE PACKAGE BODY GSCM.PKG_BAN_GIAO_AN_BPXLHC 
  AS

-- LẤY DANH SÁCH CÓ THỂ BÀN GIAO
    PROCEDURE GET_AN_BAN_GIAO (
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
        FETCH_CQDN_TEN          VARCHAR2(1000 CHAR);
        
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
                        -- FETCH cho DON_SEARCH_PTQDK (23 cột, thứ tự: STT, COUNTALL, ID, MAVUVIEC...)
                        FETCH P_CUR INTO FETCH_STT, FETCH_ID, FETCH_MAVUVIEC, 
                          FETCH_TENVUVIEC, FETCH_SOTHUTU, FETCH_CQDN_TEN, FETCH_NGAYNHANDON, FETCH_NGUOITAO, 
                          FETCH_NGAYTAO, FETCH_QUANHEPL, FETCH_MAGIAIDOAN, FETCH_TENTOASOTHAM,
                          FETCH_HINHTHUCNHANDON, FETCH_TENTOASOTHAM, FETCH_GIAIDOANVUVIEC,
                          FETCH_TRUONGHOPGIAONHAN, FETCH_BANAN_QD_ST, FETCH_KHANGNGHI_ST,
                          FETCH_MAGIAIDOAN, FETCH_HOTENBICAN, FETCH_TINHTRANG_GQ, FETCH_CHECK_THULY,
                          FETCH_THULYXXLAI, FETCH_COUNTALL;
                    
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
                        -- FETCH cho XLHC_DON_SEARCH_TURNING (26 cột, thứ tự: ID, MAVUVIEC...)
                        FETCH P_CUR INTO FETCH_STT, FETCH_ID, FETCH_MAVUVIEC, 
                          FETCH_TENVUVIEC, FETCH_SOTHUTU, FETCH_CQDN_TEN, FETCH_NGAYNHANDON, FETCH_NGUOITAO, 
                          FETCH_NGAYTAO, FETCH_QUANHEPL, FETCH_MAGIAIDOAN, FETCH_TENTOASOTHAM,
                          FETCH_HINHTHUCNHANDON, FETCH_GIAIDOANVUVIEC, FETCH_TRUONGHOPGIAONHAN, 
                          FETCH_TENTOASOTHAM, FETCH_HINHTHUCNHANDON,
                          FETCH_BANAN_QD_ST ,FETCH_HOTENBICAN, FETCH_KHANGNGHI_ST, FETCH_CHECK_THULY, 
                          FETCH_TINHTRANG_GQ, FETCH_THULYXXLAI, FETCH_COUNTALL;
                    
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
        
                --SELECT LOAITOA INTO V_CAP_XET_XU_LOGIN FROM DM_TOAAN WHERE 1=1 AND ID = p_TOAANID;
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
                PKG_STPT_XLHC.XLHC_DON_SEARCH(
                  V_CURRENT_TOAANID,    -- vDonViID
                  p_TENVUAN,            -- vTenViec
                  NULL,                 -- vQuanHePhapLuat
                  p_MAVUVIEC,           -- vMaViec
                  NULL,                 -- vDoiTuongApDungBPXLHC
                  p_CAPXETXU,           -- vCapXetXu
                  V_CURRENT_TOAANID,    -- vToaXetXu
                  p_TINHTRANGTHULY,     -- vTinhTrangThuLy
                  V_THULYTUNGAY,        -- vTuNgayThuLy
                  V_THULYDENNGAY,       -- vDenNgayThuLy
                  NULL,                 -- vSoThuLy
                  V_TRANGTHAIGIAIQUYET, -- vTinhTrangGQ
                  NULL,                 -- vTuNgayGQ
                  NULL,                 -- vDenNgayGQ
                  p_THAMPHANGIAIQUYET,  -- vThamPhan
                  NULL,                 -- vVaiTroThamPhan
                  NULL,                 -- vThoiHanGQ
                  NULL,                 -- vSoQD
                  NULL,                 -- vNgayQD
                  NULL,                 -- vThuKy
                  NULL,                 -- vPTRutKinhNghiem
                  NULL,					-- V_AN_KET_THUC
                  1,                    -- Page_Index
                  V_PROCEDURE_PAGESIZE, -- Page_Size
                  CURSOR_RETURN         -- curReturn
                );
                IF CURSOR_RETURN IS NOT NULL THEN
                    PROCESS_CURSOR(CURSOR_RETURN, '8', 0, V_CURRENT_TOAANID);
                    CLOSE CURSOR_RETURN;
                END IF;

                -- Không lấy án TĐC với cấp sơ thẩm
                IF P_CAPXETXU IS NULL OR p_CAPXETXU <> 2 THEN
                
                  -- BƯỚC 2: Lấy dữ liệu từ procedure 2 với TOTOAANDI
                  PKG_STPT_XLHC.XLHC_DON_SEARCH_PTQDK(
                    V_CURRENT_TOAANID,    -- vDonViID
                    p_TENVUAN,            -- vTenViec
                    NULL,                 -- vQuanHePhapLuat
                    p_MAVUVIEC,           -- vMaViec
                    NULL,                 -- vDoiTuongApDungBPXLHC
                    3,                    -- vCapXetXu
                    V_CURRENT_TOAANID,    -- vToaXetXu
                    p_TINHTRANGTHULY,     -- vTinhTrangThuLy
                    V_THULYTUNGAY,        -- vTuNgayThuLy
                    V_THULYDENNGAY,       -- vDenNgayThuLy,
                    NULL,                 -- vSoThuLy,
                    V_TRANGTHAIGIAIQUYET, -- vTinhTrangGQ
                    NULL,                 -- vTuNgayGQ
                    NULL,                 -- vDenNgayGQ
                    p_THAMPHANGIAIQUYET,  -- vThamPhan
                    NULL,                 -- vVaiTroThamPhan
                    NULL,                 -- vThoiHanGQ
                    NULL,                 -- vSoQD
                    NULL,                 -- vNgayQD
                    NULL,                 -- vThuKy
                    NULL,                 -- vPTRutKinhNghiem
                    NULL,				  -- V_AN_KET_THUC
                    1,                    -- Page_Index
                    V_PROCEDURE_PAGESIZE, -- Page_Size
                    CURSOR_RETURN2        -- curReturn
                  );
                                                             
                  IF CURSOR_RETURN2 IS NOT NULL THEN
                      PROCESS_CURSOR(CURSOR_RETURN2, '8', 1, V_CURRENT_TOAANID);
                      CLOSE CURSOR_RETURN2;
                  END IF;
                END IF;
            END LOOP;
        ELSE
            -- TRANGTHAI = 0 hoặc NULL: Logic cũ với p_TOAANID
            -- BƯỚC 1: Lấy dữ liệu + COUNTALL từ procedure 1 (chỉ 1 lần gọi)
            PKG_STPT_XLHC.XLHC_DON_SEARCH(
              P_TOAANID,            -- vDonViID
              p_TENVUAN,            -- vTenViec
              NULL,                 -- vQuanHePhapLuat
              p_MAVUVIEC,           -- vMaViec
              NULL,                 -- vDoiTuongApDungBPXLHC
              p_CAPXETXU,           -- vCapXetXu
              P_TOAANID,            -- vToaXetXu
              p_TINHTRANGTHULY,     -- vTinhTrangThuLy
              V_THULYTUNGAY,        -- vTuNgayThuLy
              V_THULYDENNGAY,       -- vDenNgayThuLy
              NULL,                 -- vSoThuLy
              P_TRANGTHAIGIAIQUYET, -- vTinhTrangGQ
              NULL,                 -- vTuNgayGQ
              NULL,                 -- vDenNgayGQ
              p_THAMPHANGIAIQUYET,  -- vThamPhan
              NULL,                 -- vVaiTroThamPhan
              NULL,                 -- vThoiHanGQ
              NULL,                 -- vSoQD
              NULL,                 -- vNgayQD
              NULL,                 -- vThuKy
              NULL,                 -- vPTRutKinhNghiem
              NULL,				  -- V_AN_KET_THUC
              1,                    -- Page_Index
              V_PROCEDURE_PAGESIZE, -- Page_Size
              CURSOR_RETURN         -- curReturn
            );
            IF CURSOR_RETURN IS NOT NULL THEN
                PROCESS_CURSOR(CURSOR_RETURN, '8', 0, p_TOAANID);
                CLOSE CURSOR_RETURN;
            END IF;

            -- Không lấy án TĐC với cấp sơ thẩm
            IF (P_CAPXETXU IS NULL OR p_CAPXETXU <> 2) THEN
            
              -- BƯỚC 2: Lấy dữ liệu + COUNTALL từ procedure 2 (chỉ 1 lần gọi)
              PKG_STPT_XLHC.XLHC_DON_SEARCH_PTQDK(
                p_TOAANID,            -- vDonViID
                p_TENVUAN,            -- vTenViec
                NULL,                 -- vQuanHePhapLuat
                p_MAVUVIEC,           -- vMaViec
                NULL,                 -- vDoiTuongApDungBPXLHC
                3,                    -- vCapXetXu
                P_TOAANID,            -- vToaXetXu
                p_TINHTRANGTHULY,     -- vTinhTrangThuLy
                V_THULYTUNGAY,        -- vTuNgayThuLy
                V_THULYDENNGAY,       -- vDenNgayThuLy,
                NULL,                 -- vSoThuLy,
                V_TRANGTHAIGIAIQUYET, -- vTinhTrangGQ
                NULL,                 -- vTuNgayGQ
                NULL,                 -- vDenNgayGQ
                p_THAMPHANGIAIQUYET,  -- vThamPhan
                NULL,                 -- vVaiTroThamPhan
                NULL,                 -- vThoiHanGQ
                NULL,                 -- vSoQD
                NULL,                 -- vNgayQD
                NULL,                 -- vThuKy
                NULL,                 -- vPTRutKinhNghiem
                NULL,				  -- V_AN_KET_THUC
                1,                    -- Page_Index
                V_PROCEDURE_PAGESIZE, -- Page_Size
                CURSOR_RETURN2        -- curReturn
                );
                                                         
              IF CURSOR_RETURN2 IS NOT NULL THEN
                  PROCESS_CURSOR(CURSOR_RETURN2, '8', 1, p_TOAANID);
                  CLOSE CURSOR_RETURN2;
              END IF;
              
              -- Bước 3: lấy dữ liệu chưa thụ lý với TRANGTHAIGIAIQUYET = ''
              IF (NVL(LENGTH(p_TINHTRANGTHULY),0) = 0) OR p_TINHTRANGTHULY = '2' THEN
                  V_TRANGTHAIGIAIQUYET := '';
                  V_TINHTRANGTHULY := '2';
                  PKG_STPT_XLHC.XLHC_DON_SEARCH_PTQDK(
                    p_TOAANID,            -- vDonViID
                    p_TENVUAN,            -- vTenViec
                    NULL,                 -- vQuanHePhapLuat
                    p_MAVUVIEC,           -- vMaViec
                    NULL,                 -- vDoiTuongApDungBPXLHC
                    3,                    -- vCapXetXu
                    P_TOAANID,            -- vToaXetXu
                    V_TINHTRANGTHULY,     -- vTinhTrangThuLy
                    V_THULYTUNGAY,        -- vTuNgayThuLy
                    V_THULYDENNGAY,       -- vDenNgayThuLy,
                    NULL,                 -- vSoThuLy,
                    V_TRANGTHAIGIAIQUYET, -- vTinhTrangGQ
                    NULL,                 -- vTuNgayGQ
                    NULL,                 -- vDenNgayGQ
                    p_THAMPHANGIAIQUYET,  -- vThamPhan
                    NULL,                 -- vVaiTroThamPhan
                    NULL,                 -- vThoiHanGQ
                    NULL,                 -- vSoQD
                    NULL,                 -- vNgayQD
                    NULL,                 -- vThuKy
                    NULL,                 -- vPTRutKinhNghiem
                    NULL,				  -- V_AN_KET_THUC
                    1,                    -- Page_Index
                    V_PROCEDURE_PAGESIZE, -- Page_Size
                    CURSOR_RETURN2        -- curReturn
                    );                      
                  IF CURSOR_RETURN2 IS NOT NULL THEN
                      PROCESS_CURSOR(CURSOR_RETURN2, '8', 1, p_TOAANID);
                      CLOSE CURSOR_RETURN2;
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
                                    AND b.VUVIECLOAI = 'BPXLHC'
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
                                          AND vm.VUVIECLOAI = 'BPXLHC'
                                    ) THEN 1 ELSE 0 END
                                -- TRANGTHAI = 1: Chỉ lấy những bản ghi có mapping 
                                WHEN p_TRANGTHAI = 1 AND B.TRANGTHAI IS NOT NULL THEN 1
                                -- TRANGTHAI = NULL hoặc khác: Lấy tất cả
                                WHEN p_TRANGTHAI IS NULL THEN 1
                                WHEN p_TRANGTHAI NOT IN (0, 1) THEN 1 
                                ELSE 0 END))
                            ORDER BY A.ID DESC, B.ID DESC;
    END GET_AN_BAN_GIAO;

    -- LẤY DANH SÁCH CHỜ DUYỆT
    PROCEDURE GETS_CHONHAN (
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
                from XLHC_DON don 
                JOIN VUAN_BANGIAO_MAPPING mapping ON don.ID = mapping.VUVIECID AND MAPPING.VUVIECLOAI = 'BPXLHC'
                JOIN DM_TOAAN taGiao ON case when mapping.TOAANGIAOID is null then 0 else mapping.TOAANGIAOID end = taGiao.ID
                JOIN DM_TOAAN taNhan ON case when mapping.TOAANNHANID is null then 0 else mapping.TOAANNHANID end = taNhan.ID
                JOIN DM_DATAITEM lyDo ON mapping.LYDOMA = lyDo.MA
                LEFT JOIN XLHC_SOTHAM_THULY thuLy ON don.ID = thuLy.DONID
                LEFT JOIN XLHC_PHUCTHAM_THULY E ON don.ID = e.DONID
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
                --Thẩm phán
                AND (P_THAMPHANGIAIQUYET IS NULL
                      OR( EXISTS(SELECT 'x' FROM XLHC_DON_THAMPHAN PC 
                                 INNER JOIN DM_CANBO dc ON pc.CANBOID = dc.ID 
                                 WHERE UPPER(TRIM(dc.HOTEN)) = UPPER(TRIM(P_THAMPHANGIAIQUYET))
                                      AND PC.DONID=don.ID ))
                    )
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
    END GETS_CHONHAN;

    -- NHẬN BÀN GIAO
    PROCEDURE NHAN (
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
        FROM XLHC_DON don 
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
        UPDATE XLHC_DON_GIAIDOAN
        SET AN_DA_KET_THUC = CASE 
                WHEN v_TRANGTHAIGIAIQUYET = 7 THEN 1 
                ELSE AN_DA_KET_THUC 
            END
        WHERE DONID = p_VUVIECID AND MAGIAIDOAN = v_MAGIAIDOAN;

        -- Update XLHC_DONXIN_HOAN_MIEN
        -- backup
        UPDATE XLHC_DONXIN_HOAN_MIEN
        SET TOA_GIAIQUYET_ID = TOAANID
        WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID AND (TOA_GIAIQUYET_ID IS NULL OR TOA_GIAIQUYET_ID = 0);

        UPDATE XLHC_DONXIN_HOAN_MIEN
        SET TOAANID = p_TOAANNHANID
        WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID;

        -- Xử lý cập nhật theo giai đoạn
        IF v_MAGIAIDOAN = 2 THEN
            -- SƠ THẨM
            -- Update XLHC_DON
            -- backup
            UPDATE XLHC_DON
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE ID = p_VUVIECID AND TOAANID = v_TOAANID AND (TOA_GIAIQUYET_ID IS NULL OR TOA_GIAIQUYET_ID = 0);

            UPDATE XLHC_DON
            SET TOAANID = p_TOAANNHANID
            WHERE ID = p_VUVIECID AND TOAANID = v_TOAANID;

            -- Kiểm tra xem có update được chính xác 1 bản ghi ADS_DON hay không
--            IF SQL%ROWCOUNT != 1 THEN
--                ROLLBACK;
--                RAISE_APPLICATION_ERROR(-20002, 'Lỗi cập nhật ADS_DON (Sơ thẩm)');
--            END IF;

            -- Update XLHC_SOTHAM_THULY
            -- backup
            UPDATE XLHC_SOTHAM_THULY
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID AND (TOA_GIAIQUYET_ID IS NULL OR TOA_GIAIQUYET_ID = 0);

            UPDATE XLHC_SOTHAM_THULY
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID;

            -- Update XLHC_DON_GIAIDOAN
            -- backup
            UPDATE XLHC_DON_GIAIDOAN
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID AND (TOA_GIAIQUYET_ID IS NULL OR TOA_GIAIQUYET_ID = 0) AND MAGIAIDOAN = v_MAGIAIDOAN;

            UPDATE XLHC_DON_GIAIDOAN
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID AND MAGIAIDOAN = v_MAGIAIDOAN;

            -- Update DON_CHITIET
            -- backup
            UPDATE DON_CHITIET
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND LOAIANID = 8 AND TOAANID = v_TOAANID AND (TOA_GIAIQUYET_ID IS NULL OR TOA_GIAIQUYET_ID = 0);

            UPDATE DON_CHITIET
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND LOAIANID = 8 AND TOAANID = v_TOAANID;

            -- Update XLHC_TONGDAT
            -- backup
            UPDATE XLHC_TONGDAT
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID AND (TOA_GIAIQUYET_ID IS NULL OR TOA_GIAIQUYET_ID = 0);

            UPDATE XLHC_TONGDAT
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID;

            -- Update DON_KHAC
            -- backup
            UPDATE DON_KHAC
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND LOAIANID = 8 AND TOAANID = v_TOAANID AND (TOA_GIAIQUYET_ID IS NULL OR TOA_GIAIQUYET_ID = 0);

            UPDATE DON_KHAC
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND LOAIANID = 8 AND TOAANID = v_TOAANID;

            -- Update XLHC_DON_XULY
            -- backup
            UPDATE XLHC_DON_XULY
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID AND (TOA_GIAIQUYET_ID IS NULL OR TOA_GIAIQUYET_ID = 0);

            UPDATE XLHC_DON_XULY
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID;

            -- Update XLHC_SOTHAM_BANAN
            -- backup
            UPDATE XLHC_SOTHAM_BANAN
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID AND (TOA_GIAIQUYET_ID IS NULL OR TOA_GIAIQUYET_ID = 0);

            UPDATE XLHC_SOTHAM_BANAN
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID; 

            -- Update XLHC_SOTHAM_QUYETDINH
            -- backup
            UPDATE XLHC_SOTHAM_QUYETDINH
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID AND (TOA_GIAIQUYET_ID IS NULL OR TOA_GIAIQUYET_ID = 0);

            UPDATE XLHC_SOTHAM_QUYETDINH
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID;  

            -- Update DONXINHOANMIEN_THULY
            -- backup
            UPDATE DONXINHOANMIEN_THULY
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID AND (TOA_GIAIQUYET_ID IS NULL OR TOA_GIAIQUYET_ID = 0);

            UPDATE DONXINHOANMIEN_THULY
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAANID;  

            -- Update XLHC_CHUYEN_NHAN_AN
            -- Theo TOACHUYENID 
             -- backup
            UPDATE XLHC_CHUYEN_NHAN_AN
            SET TOA_GIAIQUYET_ID = TOACHUYENID
            WHERE VUANID = p_VUVIECID AND TOACHUYENID = v_TOAANID AND TOA_GIAIQUYET_ID IS NULL;

            UPDATE XLHC_CHUYEN_NHAN_AN 
            SET TOACHUYENID = p_TOAANNHANID 
            WHERE VUANID = p_VUVIECID AND TOACHUYENID = v_TOAANID;

            -- Theo TOANHANID
            -- backup
            UPDATE XLHC_CHUYEN_NHAN_AN
            SET TOA_GIAIQUYET_NHAN_ID = TOANHANID
            WHERE VUANID = p_VUVIECID AND TOANHANID = v_TOAANID AND (TOA_GIAIQUYET_NHAN_ID IS NULL OR TOA_GIAIQUYET_NHAN_ID = 0);

            UPDATE XLHC_CHUYEN_NHAN_AN
            SET TOANHANID = p_TOAANNHANID
            WHERE VUANID = p_VUVIECID AND TOANHANID = v_TOAANID;

            -- Với trường hợp chuyển ST -> ST, sau khi chuyển án tạm đình chỉ
            UPDATE XLHC_CHUYEN_NHAN_AN
      			SET
      				TOA_GIAIQUYET_NHAN_ID = TOANHANID,
      				TOANHANID = p_TOAANNHANID
      			WHERE
      				VUANID in (
        				SELECT CNA.MAP_VUANID_NEW
        				FROM XLHC_CHUYEN_NHAN_AN CNA
        				WHERE CNA.VUANID = p_VUVIECID AND CNA.MAP_VUANID_NEW IS NOT NULL
              );

            -- Với trường hợp chuyển ST -> ST, sau khi chuyển án không đủ thẩm quyền xét xử
            UPDATE XLHC_CHUYEN_NHAN_AN
      			SET
      				TOA_GIAIQUYET_NHAN_ID = TOANHANID,
      				TOANHANID = p_TOAANNHANID
      			WHERE
      				MAP_VUANID_NEW = p_VUVIECID AND MAP_VUANID_NEW IS NOT NULL;

        ELSIF v_MAGIAIDOAN IN (3,7) THEN
            -- PHÚC THẨM

            -- Update XLHC_DON
            -- backup
            UPDATE XLHC_DON
            SET TOA_PHUCTHAM_GIAIQUYET_ID = TOAPHUCTHAMID
            WHERE ID = p_VUVIECID AND TOAPHUCTHAMID = v_TOAPHUCTHAMID AND (TOA_PHUCTHAM_GIAIQUYET_ID IS NULL OR TOA_PHUCTHAM_GIAIQUYET_ID = 0);

            UPDATE XLHC_DON
            SET TOAPHUCTHAMID = p_TOAANNHANID
            WHERE ID = p_VUVIECID AND TOAPHUCTHAMID = v_TOAPHUCTHAMID;

            -- backup
            UPDATE XLHC_DON
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE ID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID AND (TOA_GIAIQUYET_ID IS NULL OR TOA_GIAIQUYET_ID = 0);

            UPDATE XLHC_DON
            SET TOAANID = p_TOAANNHANID
            WHERE ID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID;

            -- Update XLHC_PHUCTHAM_THULY
            -- backup
            UPDATE XLHC_PHUCTHAM_THULY
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID AND (TOA_GIAIQUYET_ID IS NULL OR TOA_GIAIQUYET_ID = 0);

            UPDATE XLHC_PHUCTHAM_THULY
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID;

            -- Update XLHC_DON_GIAIDOAN
            -- backup
            UPDATE XLHC_DON_GIAIDOAN
            SET TOA_PHUCTHAM_GIAIQUYET_ID = TOAPHUCTHAMID
            WHERE DONID = p_VUVIECID AND TOAPHUCTHAMID = v_TOAPHUCTHAMID AND (TOA_PHUCTHAM_GIAIQUYET_ID IS NULL OR TOA_PHUCTHAM_GIAIQUYET_ID = 0) AND MAGIAIDOAN = v_MAGIAIDOAN;

            UPDATE XLHC_DON_GIAIDOAN
            SET TOAPHUCTHAMID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAPHUCTHAMID = v_TOAPHUCTHAMID AND MAGIAIDOAN = v_MAGIAIDOAN;

            -- backup
            UPDATE XLHC_DON_GIAIDOAN
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID AND (TOA_GIAIQUYET_ID IS NULL OR TOA_GIAIQUYET_ID = 0);

            UPDATE XLHC_DON_GIAIDOAN
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID;

            -- UPDATE XLHC_KCKNQDK_PHUCTHAM_QUYETDINH
            -- backup
            UPDATE XLHC_KCKNQDK_PHUCTHAM_QUYETDINH
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID AND (TOA_GIAIQUYET_ID IS NULL OR TOA_GIAIQUYET_ID = 0);

            UPDATE XLHC_KCKNQDK_PHUCTHAM_QUYETDINH
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID;

            -- UPDATE XLHC_KCKNQDK_PHUCTHAM_THULY
            -- backup
            UPDATE XLHC_KCKNQDK_PHUCTHAM_THULY
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID  AND TOAANID = v_TOAPHUCTHAMID AND (TOA_GIAIQUYET_ID IS NULL OR TOA_GIAIQUYET_ID = 0);

            UPDATE XLHC_KCKNQDK_PHUCTHAM_THULY
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID;

            -- UPDATE XLHC_PHUCTHAM_BANAN
            -- backup
            UPDATE XLHC_PHUCTHAM_BANAN
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID  AND TOAANID = v_TOAPHUCTHAMID AND (TOA_GIAIQUYET_ID IS NULL OR TOA_GIAIQUYET_ID = 0);

            UPDATE XLHC_PHUCTHAM_BANAN
            SET TOAANID = P_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID;

            -- UPDATE XLHC_PHUCTHAM_QUYETDINH
            -- backup
            UPDATE XLHC_PHUCTHAM_QUYETDINH
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID  AND TOAANID = v_TOAPHUCTHAMID AND (TOA_GIAIQUYET_ID IS NULL OR TOA_GIAIQUYET_ID = 0);

            UPDATE XLHC_PHUCTHAM_QUYETDINH
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID;

            -- Update XLHC_TONGDAT
            -- backup
            UPDATE XLHC_TONGDAT
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID  AND TOAANID = v_TOAPHUCTHAMID AND (TOA_GIAIQUYET_ID IS NULL OR TOA_GIAIQUYET_ID = 0);

            UPDATE XLHC_TONGDAT
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND TOAANID = v_TOAPHUCTHAMID;

            -- Update DON_CHITIET
            -- backup
            UPDATE DON_CHITIET
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND LOAIANID = 8 AND TOAANID = v_TOAPHUCTHAMID AND (TOA_GIAIQUYET_ID IS NULL OR TOA_GIAIQUYET_ID = 0);

            UPDATE DON_CHITIET
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND LOAIANID = 8 AND TOAANID = v_TOAPHUCTHAMID;

            -- Update DON_KHAC
            -- backup
            UPDATE DON_KHAC
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE DONID = p_VUVIECID AND LOAIANID = 8 AND TOAANID = v_TOAPHUCTHAMID AND (TOA_GIAIQUYET_ID IS NULL OR TOA_GIAIQUYET_ID = 0);

            UPDATE DON_KHAC
            SET TOAANID = p_TOAANNHANID
            WHERE DONID = p_VUVIECID AND LOAIANID = 8 AND TOAANID = v_TOAPHUCTHAMID;

            -- Update HOSO_PT
            -- backup
            UPDATE HOSO_PT
            SET TOA_GIAIQUYET_ID = TOAANID
            WHERE VUANID = p_VUVIECID AND LOAIAN = 8 AND TOAANID = v_TOAPHUCTHAMID AND (TOA_GIAIQUYET_ID IS NULL OR TOA_GIAIQUYET_ID = 0);

            UPDATE HOSO_PT
            SET TOAANID = p_TOAANNHANID
            WHERE VUANID = p_VUVIECID AND LOAIAN = 8 AND TOAANID = v_TOAPHUCTHAMID;

            -- Update XLHC_CHUYEN_NHAN_AN
              -- Theo TOACHUYENID 
              -- backup
	           	UPDATE XLHC_CHUYEN_NHAN_AN 
	            SET TOA_GIAIQUYET_ID = TOACHUYENID
	            WHERE VUANID = p_VUVIECID AND TOACHUYENID = v_TOAPHUCTHAMID AND (TOA_GIAIQUYET_ID IS NULL OR TOA_GIAIQUYET_ID = 0);

              UPDATE XLHC_CHUYEN_NHAN_AN 
	            SET TOACHUYENID = p_TOAANNHANID 
	            WHERE VUANID = p_VUVIECID AND TOACHUYENID = v_TOAPHUCTHAMID;

              -- Theo TOANHANID 
              -- backup
	           	UPDATE XLHC_CHUYEN_NHAN_AN 
	            SET TOA_GIAIQUYET_NHAN_ID = TOANHANID
	            WHERE VUANID = p_VUVIECID AND TOANHANID = v_TOAPHUCTHAMID AND (TOA_GIAIQUYET_NHAN_ID IS NULL OR TOA_GIAIQUYET_NHAN_ID = 0);

	            UPDATE XLHC_CHUYEN_NHAN_AN
	            SET TOANHANID = p_TOAANNHANID
	            WHERE VUANID = p_VUVIECID AND TOANHANID = v_TOAPHUCTHAMID;

            IF (v_MAGIAIDOAN = 7) THEN
              -- Update XLHC_CHUYEN_NHAN_AN
              -- Theo TOACHUYENID 
              -- backup
	           	UPDATE XLHC_CHUYEN_NHAN_AN 
	            SET TOA_GIAIQUYET_ID = TOACHUYENID
	            WHERE MAP_VUANID_NEW = p_VUVIECID AND TOACHUYENID = v_TOAPHUCTHAMID AND (TOA_GIAIQUYET_ID IS NULL OR TOA_GIAIQUYET_ID = 0);

              UPDATE XLHC_CHUYEN_NHAN_AN 
	            SET TOACHUYENID = p_TOAANNHANID 
	            WHERE MAP_VUANID_NEW = p_VUVIECID AND TOACHUYENID = v_TOAPHUCTHAMID;

              -- Theo TOANHANID 
              -- backup
	           	UPDATE XLHC_CHUYEN_NHAN_AN 
	            SET TOA_GIAIQUYET_NHAN_ID = TOANHANID
	            WHERE MAP_VUANID_NEW = p_VUVIECID AND TOANHANID = v_TOAPHUCTHAMID AND (TOA_GIAIQUYET_NHAN_ID IS NULL OR TOA_GIAIQUYET_NHAN_ID = 0);

	            UPDATE XLHC_CHUYEN_NHAN_AN
	            SET TOANHANID = p_TOAANNHANID
	            WHERE MAP_VUANID_NEW = p_VUVIECID AND TOANHANID = v_TOAPHUCTHAMID;
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
--		            p_functionname => 'PKG_BAN_GIAO_AN_BPXLHC.NHAN',
--		            p_description => v_output,
--		            p_notes => v_tracedata
--		        );

    EXCEPTION
      WHEN OTHERS THEN
          -- Rollback in case of any exception
          ROLLBACK;

          v_output := 'Finish procedure Due to Exception: Error:' || SQLCODE || ',' || SQLERRM;
		        PKG_TRACELOG.SP_INSERT_LOG_ERROR(
		            p_functionname => 'PKG_BAN_GIAO_AN_BPXLHC.NHAN',
		            p_description => v_output,
		            p_notes => v_tracedata
		        );

          -- Re-raise the exception
          RAISE;
    END NHAN;

    -- KIỂM TRA THAY ĐỔI
    PROCEDURE KTTHAYDOI (
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

        -- Kiểm tra XLHC_CHUYEN_NHAN_AN
        SELECT COUNT(*) INTO v_count 
        FROM XLHC_CHUYEN_NHAN_AN 
        WHERE VUANID = v_VUVIECID AND (NGAYTAO >= v_NGANHAN);

        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin chuyển nhận án đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra XLHC_DONXIN_HOAN_MIEN
        SELECT COUNT(*) INTO v_count 
        FROM XLHC_DONXIN_HOAN_MIEN 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);

        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin đơn xin hoãn miễn đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

      -- Kiểm tra HOANMIEN_SOTHAM_HDXX
        SELECT COUNT(*) INTO v_count 
        FROM HOANMIEN_SOTHAM_HDXX 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);

        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin đơn xin hoãn miễn đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

         -- Kiểm tra DONXINHOANMIEN_THULY 
        SELECT COUNT(*) INTO v_count 
        FROM DONXINHOANMIEN_THULY 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);

        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin đơn xin hoãn miễn đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra XLHC_DON_BANGIAO_TAILIEU
        SELECT COUNT(*) INTO v_count 
        FROM XLHC_DON_BANGIAO_TAILIEU 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);

        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin bàn giao tài liệu đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra XLHC_DON_GIAIDOAN
        SELECT COUNT(*) INTO v_count 
        FROM XLHC_DON_GIAIDOAN 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);

        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin giai đoạn đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra XLHC_DON_TAILIEU
        SELECT COUNT(*) INTO v_count 
        FROM XLHC_DON_TAILIEU 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);

        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin tài liệu đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra XLHC_DON_THAMGIATOTUNG
        SELECT COUNT(*) INTO v_count 
        FROM XLHC_DON_THAMGIATOTUNG 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);

        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin tham gia tố tụng đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra XLHC_DON_THAMPHAN
        SELECT COUNT(*) INTO v_count 
        FROM XLHC_DON_THAMPHAN 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);

        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin thẩm phán đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra XLHC_DON_XULY
        SELECT COUNT(*) INTO v_count 
        FROM XLHC_DON_XULY 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);

        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin xử lý đơn đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra XLHC_DUONGSU
        SELECT COUNT(*) INTO v_count 
        FROM XLHC_DUONGSU 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);

        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin đương sự đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;


        -- Kiểm tra XLHC_KCKNQDK_PHUCTHAM_HDXX
        SELECT COUNT(*) INTO v_count 
        FROM XLHC_KCKNQDK_PHUCTHAM_HDXX 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);

        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin HĐXX KCKNQDK phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra XLHC_KCKNQDK_PHUCTHAM_QUYETDINH
        SELECT COUNT(*) INTO v_count 
        FROM XLHC_KCKNQDK_PHUCTHAM_QUYETDINH 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);

        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin quyết định KCKNQDK phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra XLHC_KCKNQDK_PHUCTHAM_THAMGIATOTUNG
        SELECT COUNT(*) INTO v_count 
        FROM XLHC_KCKNQDK_PHUCTHAM_THAMGIATOTUNG 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);

        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin tham gia tố tụng KCKNQDK phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra XLHC_KCKNQDK_PHUCTHAM_THULY
        SELECT COUNT(*) INTO v_count 
        FROM XLHC_KCKNQDK_PHUCTHAM_THULY 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);

        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin thụ lý KCKNQDK phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra XLHC_PHUCTHAM_BANAN
        SELECT COUNT(*) INTO v_count 
        FROM XLHC_PHUCTHAM_BANAN 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);

        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin bản án phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra XLHC_PHUCTHAM_BANAN_FILE
        SELECT COUNT(*) INTO v_count 
        FROM XLHC_PHUCTHAM_BANAN_FILE f
        WHERE EXISTS (
            SELECT 1 FROM XLHC_PHUCTHAM_BANAN b 
            WHERE b.DONID = v_VUVIECID AND b.ID = f.BANANID
        ) AND f.NGAYTAO >= v_NGANHAN;

        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin bản án phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

         -- Kiểm tra XLHC_PHUCTHAM_DUONGSU
--        SELECT COUNT(*) INTO v_count 
--        FROM XLHC_PHUCTHAM_DUONGSU 
--        WHERE DONID = v_VUVIECID 
--          AND (NGAYTAO >= v_NGANHAN);
--        
--        IF v_count > 0 THEN
--            p_result := 1;
--            p_message := 'Thông tin HĐXX phúc thẩm đã có thay đổi, không thể trả án.';
--            RETURN;
--        END IF;

        -- Kiểm tra XLHC_PHUCTHAM_HDXX
        SELECT COUNT(*) INTO v_count 
        FROM XLHC_PHUCTHAM_HDXX 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);

        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin HĐXX phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra XLHC_PHUCTHAM_QUYETDINH
        SELECT COUNT(*) INTO v_count 
        FROM XLHC_PHUCTHAM_QUYETDINH 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);

        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin quyết định phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra XLHC_PHUCTHAM_THAMGIATOTUNG
        SELECT COUNT(*) INTO v_count 
        FROM XLHC_PHUCTHAM_THAMGIATOTUNG 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);

        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin tham gia tố tụng phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra XLHC_PHUCTHAM_THULY
        SELECT COUNT(*) INTO v_count 
        FROM XLHC_PHUCTHAM_THULY 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);

        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin thụ lý phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra XLHC_SAUXETXU
        SELECT COUNT(*) INTO v_count 
        FROM XLHC_SAUXETXU 
        WHERE VUANID = v_VUVIECID 
          --  
          AND (NGAYTAO >= v_NGANHAN);

        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin sau xét xử đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra XLHC_SOTHAM_BANAN
        SELECT COUNT(*) INTO v_count 
        FROM XLHC_SOTHAM_BANAN 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);

        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin bản án sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra XLHC_SOTHAM_BANAN_FILE
        SELECT COUNT(*) INTO v_count 
        FROM XLHC_SOTHAM_BANAN_FILE 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);

        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin đơn bản án sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra XLHC_SOTHAM_HDXX
        SELECT COUNT(*) INTO v_count 
        FROM XLHC_SOTHAM_HDXX 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);

        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin HĐXX sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra XLHC_SOTHAM_KHANGCAO
        SELECT COUNT(*) INTO v_count 
        FROM XLHC_SOTHAM_KHANGCAO 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);

        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin kháng cáo sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

         -- Kiểm tra XLHC_SOTHAM_KHANGNGHI
        SELECT COUNT(*) INTO v_count 
        FROM XLHC_SOTHAM_KHANGNGHI 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);

        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin kháng nghị sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

         -- Kiểm tra XLHC_SOTHAM_QUYETDINH
        SELECT COUNT(*) INTO v_count 
        FROM XLHC_SOTHAM_QUYETDINH 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);

        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin quyết định sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

         -- Kiểm tra XLHC_SOTHAM_RUTKCKN
        SELECT COUNT(*) INTO v_count 
        FROM XLHC_SOTHAM_RUTKCKN 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);

        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin rút KCKN sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

          -- Kiểm tra XLHC_SOTHAM_THULY
        SELECT COUNT(*) INTO v_count 
        FROM XLHC_SOTHAM_THULY 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);

        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin thụ lý sơ thẩm có thay đổi, không thể trả án.';
            RETURN;
        END IF;

          -- Kiểm tra XLHC_TONGDAT
        SELECT COUNT(*) INTO v_count 
        FROM XLHC_TONGDAT 
        WHERE DONID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);

        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin tống đạt có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra XLHC_TONGDAT_DOITUONG
--        SELECT COUNT(*) INTO v_count 
--        FROM XLHC_TONGDAT_DOITUONG f
--        WHERE EXISTS (
--            SELECT 1 FROM XLHC_TONGDAT b 
--            WHERE b.DONID = v_VUVIECID AND b.ID = f.TONGDATID
--        ) 
--          AND (f.NGAYTAO >= v_NGANHAN);
--        
--        IF v_count > 0 THEN
--            p_result := 1;
--            p_message := 'Thông tin đối tượng tống đạt đã có thay đổi, không thể trả án.';
--            RETURN;
--        END IF;

        -- Kiểm tra XLHC_TRUNGCAU_GIAMDINH
        SELECT COUNT(*) INTO v_count 
        FROM XLHC_TRUNGCAU_GIAMDINH 
        WHERE VUANID = v_VUVIECID 
          AND (NGAYTAO >= v_NGANHAN);

        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin trưng cầu giám định có thay đổi, không thể trả án.';
            RETURN;
        END IF;

        -- Kiểm tra XLHC_XULY_VIPHAMHC
        SELECT COUNT(*) INTO v_count 
        FROM XLHC_XULY_VIPHAMHC 
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
          AND LOAIANID = 8;

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
          AND LOAIANID = 8;

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
          AND LOAIAN = 8;

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
          AND LOAIAN = 8;

        IF v_count > 0 THEN
            p_result := 1;
            p_message := 'Thông tin hồ sơ phúc thẩm đã có thay đổi, không thể trả án.';
            RETURN;
        END IF;

      EXCEPTION
          WHEN OTHERS THEN
              p_result := 1;
              p_message := 'Lỗi khi kiểm tra: ' || SQLERRM;
  END KTTHAYDOI;

    -- TRẢ LẠI
    PROCEDURE TRALAI (
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
        UPDATE XLHC_DON_GIAIDOAN
        SET AN_DA_KET_THUC = NULL
        WHERE DONID = v_VUVIECID AND MAGIAIDOAN = v_MAGIAIDOAN AND (TOA_GIAIQUYET_ID = v_TOAANGIAOID OR TOA_PHUCTHAM_GIAIQUYET_ID = v_TOAANGIAOID);

        -- Update XLHC_DONXIN_HOAN_MIEN
        UPDATE XLHC_DONXIN_HOAN_MIEN
        SET TOAANID = TOA_GIAIQUYET_ID
        WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

        -- Xử lý cập nhật theo giai đoạn
        IF v_MAGIAIDOAN = 2 THEN
            -- SƠ THẨM
            -- Update XLHC_DON
            UPDATE XLHC_DON
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE ID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update XLHC_SOTHAM_THULY
            UPDATE XLHC_SOTHAM_THULY
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update XLHC_DON_GIAIDOAN
            UPDATE XLHC_DON_GIAIDOAN
            SET TOAANID = TOA_GIAIQUYET_ID,
                AN_DA_KET_THUC = NULL
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update DON_CHITIET
            UPDATE DON_CHITIET
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND LOAIANID = 8 AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update XLHC_TONGDAT
            UPDATE XLHC_TONGDAT
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update DON_KHAC
            UPDATE DON_KHAC
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND LOAIANID = 8 AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update XLHC_DON_XULY
            UPDATE XLHC_DON_XULY
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update XLHC_SOTHAM_BANAN
            UPDATE XLHC_SOTHAM_BANAN
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update XLHC_SOTHAM_QUYETDINH
            UPDATE XLHC_SOTHAM_QUYETDINH
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update DONXINHOANMIEN_THULY
            UPDATE DONXINHOANMIEN_THULY
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update XLHC_CHUYEN_NHAN_AN
            -- Theo TOACHUYENID 
            UPDATE XLHC_CHUYEN_NHAN_AN 
            SET TOACHUYENID = TOA_GIAIQUYET_ID 
            WHERE VUANID = v_VUVIECID AND TOACHUYENID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Theo TOANHANID
            UPDATE XLHC_CHUYEN_NHAN_AN
            SET TOANHANID = TOA_GIAIQUYET_NHAN_ID
            WHERE VUANID = v_VUVIECID AND TOANHANID = v_TOAANNHANID AND TOA_GIAIQUYET_NHAN_ID = v_TOAANGIAOID;

            -- Với trường hợp chuyển ST -> ST, sau khi chuyển án tạm đình chỉ
          	UPDATE XLHC_CHUYEN_NHAN_AN
            SET TOANHANID = TOA_GIAIQUYET_NHAN_ID
			      WHERE VUANID in (SELECT CNA.MAP_VUANID_NEW
				                     FROM XLHC_CHUYEN_NHAN_AN CNA
                             WHERE CNA.VUANID = v_VUVIECID AND CNA.MAP_VUANID_NEW IS NOT NULL);

            -- Với trường hợp chuyển ST -> ST, sau khi chuyển án không đủ thẩm quyền xét xử
            UPDATE XLHC_CHUYEN_NHAN_AN
      			SET
      				TOANHANID = TOA_GIAIQUYET_NHAN_ID
      			WHERE
      				MAP_VUANID_NEW = v_VUVIECID AND MAP_VUANID_NEW IS NOT NULL;

        ELSIF v_MAGIAIDOAN IN (3,7) THEN
            -- PHÚC THẨM

            -- Update XLHC_DON
            UPDATE XLHC_DON
            SET TOAPHUCTHAMID = TOA_PHUCTHAM_GIAIQUYET_ID
            WHERE ID = v_VUVIECID AND TOAPHUCTHAMID = v_TOAANNHANID AND TOA_PHUCTHAM_GIAIQUYET_ID = v_TOAANGIAOID;

            UPDATE XLHC_DON
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE ID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update XLHC_PHUCTHAM_THULY

            UPDATE XLHC_PHUCTHAM_THULY
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update XLHC_DON_GIAIDOAN
            UPDATE XLHC_DON_GIAIDOAN
            SET TOAPHUCTHAMID = TOA_PHUCTHAM_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAPHUCTHAMID = v_TOAANNHANID AND TOA_PHUCTHAM_GIAIQUYET_ID = v_TOAANGIAOID;

            UPDATE XLHC_DON_GIAIDOAN
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- UPDATE XLHC_KCKNQDK_PHUCTHAM_QUYETDINH
            UPDATE XLHC_KCKNQDK_PHUCTHAM_QUYETDINH
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- UPDATE XLHC_KCKNQDK_PHUCTHAM_THULY
            UPDATE XLHC_KCKNQDK_PHUCTHAM_THULY
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- UPDATE XLHC_PHUCTHAM_BANAN
            UPDATE XLHC_PHUCTHAM_BANAN
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- UPDATE XLHC_PHUCTHAM_QUYETDINH
            UPDATE XLHC_PHUCTHAM_QUYETDINH
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update XLHC_TONGDAT
            UPDATE XLHC_TONGDAT
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update DON_CHITIET
            UPDATE DON_CHITIET
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND LOAIANID = 8 AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update DON_KHAC
            UPDATE DON_KHAC
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE DONID = v_VUVIECID AND LOAIANID = 8 AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update HOSO_PT
            UPDATE HOSO_PT
            SET TOAANID = TOA_GIAIQUYET_ID
            WHERE VUANID = v_VUVIECID AND LOAIAN = 8 AND TOAANID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

            -- Update XLHC_CHUYEN_NHAN_AN
              -- Theo TOACHUYENID 
              UPDATE XLHC_CHUYEN_NHAN_AN 
	            SET TOACHUYENID = TOA_GIAIQUYET_ID 
	            WHERE VUANID = v_VUVIECID AND TOACHUYENID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

              -- Theo TOANHANID 
	            UPDATE XLHC_CHUYEN_NHAN_AN
	            SET TOANHANID = TOA_GIAIQUYET_NHAN_ID
	            WHERE VUANID = v_VUVIECID AND TOANHANID = v_TOAANNHANID AND TOA_GIAIQUYET_NHAN_ID = v_TOAANGIAOID;

            IF (v_MAGIAIDOAN = 7) THEN
              -- Update XLHC_CHUYEN_NHAN_AN
              -- Theo TOACHUYENID 
              UPDATE XLHC_CHUYEN_NHAN_AN 
	            SET TOACHUYENID = TOA_GIAIQUYET_ID 
	            WHERE MAP_VUANID_NEW = v_VUVIECID AND TOACHUYENID = v_TOAANNHANID AND TOA_GIAIQUYET_ID = v_TOAANGIAOID;

              -- Theo TOANHANID 
	            UPDATE XLHC_CHUYEN_NHAN_AN
	            SET TOANHANID = TOA_GIAIQUYET_NHAN_ID
	            WHERE MAP_VUANID_NEW = v_VUVIECID AND TOANHANID = v_TOAANNHANID AND TOA_GIAIQUYET_NHAN_ID = v_TOAANGIAOID;	            
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
              p_functionname => 'PKG_BAN_GIAO_AN_BPXLHC.TRALAI',
              p_description => v_output,
              p_notes => v_tracedata
          );

          -- Re-raise the exception
          RAISE;
    END TRALAI;

END PKG_BAN_GIAO_AN_BPXLHC;