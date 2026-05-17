--------------------------------------------------------
--  DDL for Package Body PKG_CHUYEN_NHAN_AN
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_CHUYEN_NHAN_AN" AS 

PROCEDURE INSERT_ANPHI_DUONGSUID
(   VLOAIAN IN NUMBER,
    VDONID_OLD IN NUMBER,
    VDONID_NEW IN NUMBER,
    curReturn OUT sys_refcursor)
IS
    VID_ANPHI_OLD NUMBER;
    VID_ANPHI_NEW NUMBER;
    VDUONGSU_ID_NUM NUMBER;
    VDUONGSU_ID_TEXT VARCHAR2(250);
    VDUONGSU_ISDAIDIEN NUMBER;

    VTENDUONGSU VARCHAR2(250);
    VTUCACHTOTUNG_MA VARCHAR2(20);
    VNAMSINH NUMBER;
BEGIN
IF (VLOAIAN = 2) THEN -- Dân sự
        -- Vòng lặp for lấy án phí (cũ)
        FOR ITEM IN (SELECT ROWNUM AS ROW_NUM,DUONGSU_ID FROM ADS_ANPHI WHERE DONID = VDONID_OLD AND MAGIAIDOAN = 2 ORDER BY ID)
        LOOP
            --Lấy Thông tin đương sự đóng án phí (cũ)
            SELECT ID, TENDUONGSU, TUCACHTOTUNG_MA, NAMSINH, ISDAIDIEN INTO VDUONGSU_ID_NUM, VTENDUONGSU, VTUCACHTOTUNG_MA, VNAMSINH, VDUONGSU_ISDAIDIEN
            FROM ADS_DON_DUONGSU 
            WHERE ID = ITEM.DUONGSU_ID;

            --Update DUONGSU_ID vào án phí (mới)
            UPDATE ADS_ANPHI SET DUONGSU_ID = (SELECT ID 
                                               FROM ADS_DON_DUONGSU 
                                               WHERE DONID = VDONID_NEW AND TENDUONGSU = VTENDUONGSU 
                                                                        AND TUCACHTOTUNG_MA = VTUCACHTOTUNG_MA 
                                                                        AND NAMSINH = VNAMSINH 
                                                                        AND ISDAIDIEN = VDUONGSU_ISDAIDIEN)
            WHERE DONID = VDONID_NEW AND ID = (SELECT ID FROM (SELECT ID,ROWNUM AS ROW_NUM FROM ADS_ANPHI WHERE DONID = VDONID_NEW) WHERE ROW_NUM = ITEM.ROW_NUM)
                                     AND DUONGSU_ID IS NULL;
        END LOOP;

    ELSIF (VLOAIAN = 3) THEN -- Hôn nhân và gia đình
        -- Vòng lặp for lấy án phí (cũ)
        FOR ITEM IN (SELECT ROWNUM AS ROW_NUM,DUONGSU_IDS FROM AHN_ANPHI WHERE DONID = VDONID_OLD AND MAGIAIDOAN = 2 ORDER BY ID)
        LOOP
            -- Tạo VDUONGSU_ID_TEXT chuẩn để lấy từng ID đương sự
            VDUONGSU_ID_TEXT := ITEM.DUONGSU_IDS;
            WHILE (INSTR(VDUONGSU_ID_TEXT, ',,') > 0) LOOP VDUONGSU_ID_TEXT := REPLACE(VDUONGSU_ID_TEXT, ',,', ','); END LOOP;                
            IF(INSTR(ITEM.DUONGSU_IDS, ',') = 1)         THEN   VDUONGSU_ID_TEXT := SUBSTR(VDUONGSU_ID_TEXT, 2, LENGTH(VDUONGSU_ID_TEXT));  END IF;                   
            IF(SUBSTR(ITEM.DUONGSU_IDS,-1) NOT LIKE ',') THEN   VDUONGSU_ID_TEXT := CONCAT(VDUONGSU_ID_TEXT, ',');                          END IF; 

            -- Đổi ID đương sự cũ sang mới trong VDUONGSU_ID_TEXT
            FOR ITEMS IN (SELECT REGEXP_SUBSTR(VDUONGSU_ID_TEXT, '[^,]+', 1, level) bcid FROM DUAL CONNECT BY LEVEL <= REGEXP_COUNT(VDUONGSU_ID_TEXT,  ',' ))
            LOOP
                SELECT ID, TENDUONGSU, TUCACHTOTUNG_MA, NAMSINH, ISDAIDIEN INTO VDUONGSU_ID_NUM, VTENDUONGSU, VTUCACHTOTUNG_MA, VNAMSINH, VDUONGSU_ISDAIDIEN
                FROM AHN_DON_DUONGSU 
                WHERE ID = TO_NUMBER(ITEMS.BCID);

                SELECT ID INTO VDUONGSU_ID_NUM 
                FROM AHN_DON_DUONGSU 
                WHERE DONID = VDONID_NEW AND TENDUONGSU = VTENDUONGSU 
                                         AND TUCACHTOTUNG_MA = VTUCACHTOTUNG_MA 
                                         AND NAMSINH = VNAMSINH
                                         AND ISDAIDIEN = VDUONGSU_ISDAIDIEN;

                VDUONGSU_ID_TEXT := REPLACE(VDUONGSU_ID_TEXT,TO_CHAR(ITEMS.BCID),TO_CHAR(VDUONGSU_ID_NUM));
            END LOOP;

            -- Xóa "," ở cuối dòng VDUONGSU_ID_TEXT và UPDATE DUONGSU_IDS mới
            WHILE (SUBSTR(VDUONGSU_ID_TEXT,-1) LIKE ',') LOOP VDUONGSU_ID_TEXT := SUBSTR(VDUONGSU_ID_TEXT, 1, LENGTH(VDUONGSU_ID_TEXT) - 1); END LOOP;

            UPDATE AHN_ANPHI SET DUONGSU_IDS = VDUONGSU_ID_TEXT --(SELECT ID FROM AHN_DON_DUONGSU WHERE DONID = VDONID_NEW AND TENDUONGSU = VTENDUONGSU AND TUCACHTOTUNG_MA = VTUCACHTOTUNG_MA AND NAMSINH = VNAMSINH)
            WHERE DONID = VDONID_NEW 
              AND ID = (SELECT ID FROM (SELECT ID,ROWNUM AS ROW_NUM FROM AHN_ANPHI WHERE DONID = VDONID_NEW) WHERE ROW_NUM = ITEM.ROW_NUM) 
              AND DUONGSU_IDS IS NULL AND MAGIAIDOAN = 2;

        END LOOP;

	ELSIF (VLOAIAN = 4) THEN -- Kinh doanh, thương mại
        -- Vòng lặp for lấy án phí (cũ)
        FOR ITEM IN (SELECT ROWNUM AS ROW_NUM,DUONGSU_ID FROM AKT_ANPHI WHERE DONID = VDONID_OLD AND MAGIAIDOAN = 2 ORDER BY ID)
        LOOP
            --Lấy Thông tin đương sự đóng án phí (cũ)
            SELECT ID, TENDUONGSU, TUCACHTOTUNG_MA, NAMSINH, ISDAIDIEN INTO VDUONGSU_ID_NUM, VTENDUONGSU, VTUCACHTOTUNG_MA, VNAMSINH, VDUONGSU_ISDAIDIEN 
            FROM AKT_DON_DUONGSU 
            WHERE ID = ITEM.DUONGSU_ID;

             --Update DUONGSU_ID vào án phí (mới)
            UPDATE AKT_ANPHI SET DUONGSU_ID = (SELECT ID 
                                               FROM AKT_DON_DUONGSU 
                                               WHERE DONID = VDONID_NEW AND TENDUONGSU = VTENDUONGSU 
                                                                        AND TUCACHTOTUNG_MA = VTUCACHTOTUNG_MA 
                                                                        AND NAMSINH = VNAMSINH
                                                                        AND ISDAIDIEN = VDUONGSU_ISDAIDIEN)
            WHERE DONID = VDONID_NEW 
            AND ID = (SELECT ID FROM (SELECT ID,ROWNUM AS ROW_NUM FROM AKT_ANPHI WHERE DONID = VDONID_NEW) WHERE ROW_NUM = ITEM.ROW_NUM)
            AND DUONGSU_ID IS NULL;
        END LOOP;
	ELSIF (VLOAIAN = 5) THEN -- Lao động
            -- Vòng lặp for lấy án phí (cũ)
        FOR ITEM IN (SELECT ROWNUM AS ROW_NUM,DUONGSU_ID FROM ALD_ANPHI WHERE DONID = VDONID_OLD AND MAGIAIDOAN = 2 ORDER BY ID)
        LOOP
            --Lấy Thông tin đương sự đóng án phí (cũ)
            SELECT ID, TENDUONGSU, TUCACHTOTUNG_MA, NAMSINH, ISDAIDIEN INTO VDUONGSU_ID_NUM, VTENDUONGSU, VTUCACHTOTUNG_MA, VNAMSINH, VDUONGSU_ISDAIDIEN 
            FROM ALD_DON_DUONGSU 
            WHERE ID = ITEM.DUONGSU_ID;

             --Update DUONGSU_ID vào án phí (mới)
            UPDATE ALD_ANPHI SET DUONGSU_ID = (SELECT ID 
                                               FROM ALD_DON_DUONGSU 
                                               WHERE DONID = VDONID_NEW AND TENDUONGSU = VTENDUONGSU 
                                                                        AND TUCACHTOTUNG_MA = VTUCACHTOTUNG_MA 
                                                                        AND NAMSINH = VNAMSINH
                                                                        AND ISDAIDIEN = VDUONGSU_ISDAIDIEN)
            WHERE DONID = VDONID_NEW 
            AND ID = (SELECT ID FROM (SELECT ID,ROWNUM AS ROW_NUM FROM ALD_ANPHI WHERE DONID = VDONID_NEW) WHERE ROW_NUM = ITEM.ROW_NUM)
            AND DUONGSU_ID IS NULL;
        END LOOP;
	ELSIF (VLOAIAN = 6) THEN -- Hành chính

        -- Vòng lặp for lấy án phí (cũ)
        FOR ITEM IN (SELECT ROWNUM AS ROW_NUM,DUONGSU_IDS FROM AHC_ANPHI WHERE DONID = VDONID_OLD AND MAGIAIDOAN = 2 ORDER BY ID)
        LOOP
            -- Tạo VDUONGSU_ID_TEXT chuẩn để lấy từng ID đương sự
            VDUONGSU_ID_TEXT := ITEM.DUONGSU_IDS;
            WHILE (INSTR(VDUONGSU_ID_TEXT, ',,') > 0) LOOP VDUONGSU_ID_TEXT := REPLACE(VDUONGSU_ID_TEXT, ',,', ','); END LOOP;                
            IF(INSTR(ITEM.DUONGSU_IDS, ',') = 1)         THEN   VDUONGSU_ID_TEXT := SUBSTR(VDUONGSU_ID_TEXT, 2, LENGTH(VDUONGSU_ID_TEXT));  END IF;                   
            IF(SUBSTR(ITEM.DUONGSU_IDS,-1) NOT LIKE ',') THEN   VDUONGSU_ID_TEXT := CONCAT(VDUONGSU_ID_TEXT, ',');                          END IF; 

            -- Đổi ID đương sự cũ sang mới trong VDUONGSU_ID_TEXT
            FOR ITEMS IN (SELECT REGEXP_SUBSTR(VDUONGSU_ID_TEXT, '[^,]+', 1, level) bcid FROM DUAL CONNECT BY LEVEL <= REGEXP_COUNT(VDUONGSU_ID_TEXT,  ',' ))
            LOOP
                SELECT ID, TENDUONGSU, TUCACHTOTUNG_MA, NAMSINH, ISDAIDIEN INTO VDUONGSU_ID_NUM, VTENDUONGSU, VTUCACHTOTUNG_MA, VNAMSINH, VDUONGSU_ISDAIDIEN 
                FROM AHC_DON_DUONGSU 
                WHERE ID = TO_NUMBER(ITEMS.BCID);

                SELECT ID INTO VDUONGSU_ID_NUM 
                FROM AHC_DON_DUONGSU 
                WHERE DONID = VDONID_NEW AND TENDUONGSU = VTENDUONGSU 
                                         AND TUCACHTOTUNG_MA = VTUCACHTOTUNG_MA 
                                         AND NAMSINH = VNAMSINH
                                         AND ISDAIDIEN = VDUONGSU_ISDAIDIEN;

                VDUONGSU_ID_TEXT := REPLACE(VDUONGSU_ID_TEXT,TO_CHAR(ITEMS.BCID),TO_CHAR(VDUONGSU_ID_NUM));
            END LOOP;

            -- Xóa "," ở cuối dòng VDUONGSU_ID_TEXT và UPDATE DUONGSU_IDS mới
            IF(SUBSTR(ITEM.DUONGSU_IDS,-1) LIKE ',') THEN VDUONGSU_ID_TEXT := SUBSTR(VDUONGSU_ID_TEXT, 1, LENGTH(VDUONGSU_ID_TEXT) - 1); END IF;

            UPDATE AHC_ANPHI SET DUONGSU_IDS = VDUONGSU_ID_TEXT --(SELECT ID FROM AHC_DON_DUONGSU WHERE DONID = VDONID_NEW AND TENDUONGSU = VTENDUONGSU AND TUCACHTOTUNG_MA = VTUCACHTOTUNG_MA AND NAMSINH = VNAMSINH)
            WHERE DONID = VDONID_NEW 
              AND ID = (SELECT ID FROM (SELECT ID,ROWNUM AS ROW_NUM FROM AHC_ANPHI WHERE DONID = VDONID_NEW) WHERE ROW_NUM = ITEM.ROW_NUM) 
              AND DUONGSU_IDS IS NULL;

        END LOOP;
	ELSIF (VLOAIAN = 7) THEN -- Phá sản    
            -- Vòng lặp for lấy án phí (cũ)
        FOR ITEM IN (SELECT ROWNUM AS ROW_NUM,DUONGSU_ID FROM APS_ANPHI WHERE DONID = VDONID_OLD AND MAGIAIDOAN = 2 ORDER BY ID)
        LOOP
            --Lấy Thông tin đương sự đóng án phí (cũ)
            SELECT ID, TENDUONGSU, TUCACHTOTUNG_MA, NAMSINH, ISDAIDIEN INTO VDUONGSU_ID_NUM, VTENDUONGSU, VTUCACHTOTUNG_MA, VNAMSINH, VDUONGSU_ISDAIDIEN 
            FROM APS_DON_DUONGSU 
            WHERE ID = ITEM.DUONGSU_ID;

             --Update DUONGSU_ID vào án phí (mới)
            UPDATE APS_ANPHI SET DUONGSU_ID = (SELECT ID 
                                               FROM APS_DON_DUONGSU 
                                               WHERE DONID = VDONID_NEW AND TENDUONGSU = VTENDUONGSU 
                                                                        AND TUCACHTOTUNG_MA = VTUCACHTOTUNG_MA 
                                                                        AND NAMSINH = VNAMSINH
                                                                        AND ISDAIDIEN = VDUONGSU_ISDAIDIEN)
            WHERE DONID = VDONID_NEW 
            AND ID = (SELECT ID FROM (SELECT ID,ROWNUM AS ROW_NUM FROM APS_ANPHI WHERE DONID = VDONID_NEW) WHERE ROW_NUM = ITEM.ROW_NUM)
            AND DUONGSU_ID IS NULL;
        END LOOP;
        
        COMMIT;
END IF;
END INSERT_ANPHI_DUONGSUID;

END PKG_CHUYEN_NHAN_AN;

/
