--------------------------------------------------------
--  DDL for Package Body PKG_TACH_NHAP
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_TACH_NHAP" AS

  PROCEDURE DM_TOAAN_MAPPING_GETS_BY_TOTOAANID (
    P_TOTOAANID IN NUMBER,
    P_CURSOR OUT SYS_REFCURSOR
) AS
  BEGIN
    OPEN P_CURSOR FOR
        SELECT 
            m.ID,
            m.NGAYHIEULUC,
            m.NGAYTAO,
            -- Đơn vị cũ
            m.TOAANID,
            toa.TEN AS TOAANTEN,
            0 AS HIEULUC,
            m.GHICHU
        FROM DM_TOAAN_TACH_NHAP_MAPPING m
          INNER JOIN DM_TOAAN toa ON m.TOAANID = toa.ID
        WHERE m.TOTOAANID = P_TOTOAANID
        ORDER BY m.NGAYTAO;    
  END DM_TOAAN_MAPPING_GETS_BY_TOTOAANID;    

PROCEDURE DM_TOAAN_MAPPING_GET_BY_ID (
    P_ID IN NUMBER,
    P_CURSOR OUT SYS_REFCURSOR
) AS
  BEGIN
    OPEN P_CURSOR FOR
        SELECT *
        FROM DM_TOAAN_TACH_NHAP_MAPPING m
        WHERE m.ID = P_ID;    
  END DM_TOAAN_MAPPING_GET_BY_ID;    

PROCEDURE DM_TOAAN_MAPPING_GETS_BY_TOAANID (
    P_TOAANID IN NUMBER,
    P_CURSOR OUT SYS_REFCURSOR
) AS
  BEGIN
    OPEN P_CURSOR FOR
        SELECT 
            m.ID,
            m.NGAYHIEULUC,
            m.NGAYTAO,
            -- Loại
            m.LOAI,
            loai.TEN AS LOAITEN,
            -- Đơn vị cũ
            m.TOAANID,
            toa.TEN AS TOAANTEN,
            -- Đơn vị mới
            m.TOTOAANID,
            toToa.TEN AS TOTOAANTEN,
            toToa.HIEULUC AS HIEULUC,
            m.GHICHU
        FROM DM_TOAAN_TACH_NHAP_MAPPING m
          INNER JOIN DM_TOAAN toa ON m.TOAANID = toa.ID
          INNER JOIN DM_TOAAN toToa ON m.TOTOAANID = toToa.ID
          INNER JOIN DM_DATAITEM loai ON m.LOAI = loai.MA
        WHERE m.TOAANID = P_TOAANID OR m.TOTOAANID = P_TOAANID
        ORDER BY m.NGAYTAO;    
  END DM_TOAAN_MAPPING_GETS_BY_TOAANID;    

PROCEDURE DM_TOAAN_MAPPING_GETS_SAME_LEVEL (
    P_TOAANID IN NUMBER,
    P_CURSOR OUT SYS_REFCURSOR
) AS
  BEGIN
    OPEN P_CURSOR FOR
--        SELECT DISTINCT
--            A.ID, 
--            A.CAPCHAID, 
--            A.LOAITOA, 
--            A.TEN, 
--            CASE WHEN B.TOTOAANID IS NOT NULL THEN 0 ELSE 1 END AS HIEULUC, 
--            B.LOAI AS LOAISAPNHAP,
--            B.TOTOAANID,
--            B.NGAYTAO,
--            B.NGUOITAO,
--            B.NGAYHIEULUC,
--            B.TEN as TOTOAANTEN
--        FROM (
--        SELECT DISTINCT ID,CAPCHAID,LOAITOA,TEN,HIEULUC FROM DM_TOAAN where CAPCHAID IN (SELECT CAPCHAID FROM DM_TOAAN WHere ID = P_TOAANID) and ID <> P_TOAANID
--        UNION ALL
--        SELECT DISTINCT ID,CAPCHAID,LOAITOA,TEN,HIEULUC FROM DM_TOAAN where CAPCHAID IN (SELECT TOAANID FROM DM_TOAAN_TACH_NHAP_MAPPING WHERE TOTOAANID = (SELECT CAPCHAID FROM DM_TOAAN WHere ID = P_TOAANID))
--        )A LEFT JOIN 
--        (SELECT dmtn.*, dm.TEN FROM DM_TOAAN_TACH_NHAP_MAPPING dmtn, DM_TOAAN dm WHERE dmtn.TOTOAANID = dm.ID)B ON A.ID = B.TOAANID;    /

        SELECT DISTINCT
            A.ID, 
            A.CAPCHAID, 
            A.LOAITOA, 
            A.TEN, 
            CASE 
                WHEN B.TOTOAANID IS NOT NULL THEN 0 
                -- Đặt HIEULUC = 0 cho những toà đã bị nhập vào toà khác (không phải toà hiện tại)
                WHEN A.ID IN (
                    SELECT TOAANID 
                    FROM DM_TOAAN_TACH_NHAP_MAPPING 
                    WHERE LOAI = 'NHAP' AND TOTOAANID <> P_TOAANID
                ) THEN 0
                -- Đặt HIEULUC = 0 cho những toà bị tách (không phải bởi toà hiện tại)
                WHEN A.ID IN (
                    SELECT TOAANID 
                    FROM DM_TOAAN_TACH_NHAP_MAPPING 
                    WHERE LOAI = 'TACH' AND TOTOAANID <> P_TOAANID
                ) THEN 0
                -- Đặt HIEULUC = 0 cho những toà được toà hiện tại nhập vào hoặc tách ra
                WHEN A.ID IN (
                    SELECT TOTOAANID 
                    FROM DM_TOAAN_TACH_NHAP_MAPPING 
                    WHERE TOAANID = P_TOAANID
                ) THEN 0
                ELSE 1 
            END AS HIEULUC, 
            B.LOAI AS LOAISAPNHAP,
            B.TOTOAANID,
            B.NGAYTAO,
            B.NGUOITAO,
            B.NGAYHIEULUC,
            B.TEN as TOTOAANTEN
        FROM (
            -- Lấy tất cả các toà cùng cấp, bao gồm cả những toà không hợp lệ
            SELECT DISTINCT ID, CAPCHAID, LOAITOA, TEN, HIEULUC 
            FROM DM_TOAAN 
            WHERE (
                -- Các toà cùng cấp cha với toà hiện tại
                CAPCHAID IN (
                    SELECT CAPCHAID 
                    FROM DM_TOAAN 
                    WHERE ID = P_TOAANID
                ) 
                OR
                -- Các toà cùng cấp với toà được nhập/tách từ toà cha của toà hiện tại
                CAPCHAID IN (
                    SELECT TOAANID 
                    FROM DM_TOAAN_TACH_NHAP_MAPPING 
                    WHERE TOTOAANID = (
                        SELECT CAPCHAID 
                        FROM DM_TOAAN 
                        WHERE ID = P_TOAANID
                    )
                )
            )
            AND ID <> P_TOAANID  -- Loại bỏ toà hiện tại
        ) A 
        LEFT JOIN (
            SELECT dmtn.*, dm.TEN 
            FROM DM_TOAAN_TACH_NHAP_MAPPING dmtn, DM_TOAAN dm 
            WHERE dmtn.TOTOAANID = dm.ID
        ) B ON A.ID = B.TOAANID;    
  END DM_TOAAN_MAPPING_GETS_SAME_LEVEL;    

  PROCEDURE DM_TOAAN_MAPPING_ADD (
    v_toaanid           IN NUMBER,
    v_loai              IN VARCHAR2,
    v_totoaanid         IN NUMBER,
    v_ngayhieuluc       IN DATE,
    v_ghichu            IN VARCHAR2,
    v_ngaytao           IN DATE,
    v_nguoitao          IN VARCHAR2
) AS
    v_count NUMBER;    
  BEGIN
    IF v_loai = 'TACH' THEN
        INSERT INTO DM_TOAAN_TACH_NHAP_MAPPING (
            TOAANID,
            LOAI,
            TOTOAANID,
            NGAYHIEULUC,
            GHICHU,
            NGAYTAO,
            NGUOITAO
        ) VALUES (
            v_toaanid,
            v_loai,
            v_totoaanid,
            v_ngayhieuluc,
            v_ghichu,
            v_ngaytao,
            v_nguoitao
        );    
    ELSIF v_loai = 'NHAP' THEN
        SELECT COUNT(*) INTO v_count FROM DM_TOAAN_TACH_NHAP_MAPPING WHERE TOAANID = v_toaanid;    
        IF v_count = 0 THEN
            INSERT INTO DM_TOAAN_TACH_NHAP_MAPPING (
                TOAANID,
                LOAI,
                TOTOAANID,
                NGAYHIEULUC,
                GHICHU,
                NGAYTAO,
                NGUOITAO
            ) VALUES (
                v_toaanid,
                v_loai,
                v_totoaanid,
                v_ngayhieuluc,
                v_ghichu,
                v_ngaytao,
                v_nguoitao
            );    
        END IF;    
        --update hieuluc = 0 in DM_TOAAN
        -- UPDATE DM_TOAAN SET HIENTHI = 0 WHERE ID = v_toaanid;    
    END IF;    

    -- Commit the transaction
    COMMIT;    
    EXCEPTION
    WHEN OTHERS THEN
        -- Rollback in case of any exception
        ROLLBACK;    
        -- Re-raise the exception
        RAISE;    
  END DM_TOAAN_MAPPING_ADD;    

    PROCEDURE DM_TOAAN_MAPPING_EDIT (
        p_ID             IN NUMBER,
        p_TOAANID      IN NUMBER,
        p_TOTOAANID      IN NUMBER,
        p_NGAYHIEULUC    IN DATE,
        p_GHICHU         IN VARCHAR2
    ) AS
    BEGIN
        -- select LOAI,TOAANID INTO p_loai, p_toaanid from DM_TOAAN_TACH_NHAP_MAPPING WHERE ID = v_id;    

        UPDATE DM_TOAAN_TACH_NHAP_MAPPING SET
        TOAANID = p_TOAANID,
        TOTOAANID = p_TOTOAANID,
        NGAYHIEULUC = p_NGAYHIEULUC,
        GHICHU = p_GHICHU
        WHERE ID = p_ID;    

        -- Commit the transaction
        COMMIT;    
        EXCEPTION
        WHEN OTHERS THEN
            -- Rollback in case of any exception
            ROLLBACK;    
            -- Re-raise the exception
            RAISE;    
    END DM_TOAAN_MAPPING_EDIT;    

    PROCEDURE DM_TOAAN_MAPPING_DELETE (
        v_id IN NUMBER
    ) AS
    BEGIN
        --update hieuluc = 1 in DM_TOAAN
        -- UPDATE DM_TOAAN SET HIENTHI = 1 WHERE ID = (SELECT TOAANID FROM DM_TOAAN_TACH_NHAP_MAPPING WHERE ID = v_id);    

        DELETE FROM DM_TOAAN_TACH_NHAP_MAPPING
        WHERE ID = v_id;    

        -- Commit the transaction
        COMMIT;    
        EXCEPTION
        WHEN OTHERS THEN
            -- Rollback in case of any exception
            ROLLBACK;    
            -- Re-raise the exception
            RAISE;    
    END DM_TOAAN_MAPPING_DELETE;    

    PROCEDURE DM_TOAAN_HISTORY_ADD (
        v_toaanid           IN NUMBER,
        v_totoaanid         IN NUMBER,
        v_hieuluc           IN NUMBER,
        v_ngayhieuluc       IN DATE,
        v_ngayhethieuluc    IN DATE,
        v_loai              IN VARCHAR2,
        v_ngaytao           IN DATE,
        v_nguoitao          IN VARCHAR2,
        v_hanhdong          IN VARCHAR2
    ) AS
      BEGIN
        INSERT INTO DM_TOAAN_TACH_NHAP_HISTORY (
            TOAANID,
            TOTOAANID,
            HIEULUC,
            NGAYHIEULUC,
            NGAYHETHIEULUC,
            LOAI,
            NGAYTAO,
            NGUOITAO,
            HANHDONG
        ) VALUES (
            v_toaanid,
            v_totoaanid,
            v_hieuluc,
            v_ngayhieuluc,
            v_ngayhethieuluc,
            v_loai,
            v_ngaytao,
            v_nguoitao,
            v_hanhdong
        );    

        -- Commit the transaction
        COMMIT;    
        EXCEPTION
        WHEN OTHERS THEN
            -- Rollback in case of any exception
            ROLLBACK;    
            -- Re-raise the exception
            RAISE;    
    END DM_TOAAN_HISTORY_ADD;    
END PKG_TACH_NHAP;

/
