create or replace PACKAGE BODY PKG_TUPHAP_ANPHI_DVCQG AS
PROCEDURE GET_THANH_TOAN_BY_MA
  (
     V_MA_THONGBAO IN VARCHAR2 DEFAULT NULL ,    
     ITEMS_CURSOR OUT SYS_REFCURSOR
  )    
    AS
 BEGIN
     OPEN ITEMS_CURSOR FOR
         SELECT TT.* FROM DVCQG_THANH_TOAN TT WHERE TT.MA_THONGBAO=V_MA_THONGBAO;
END GET_THANH_TOAN_BY_MA;
PROCEDURE GET_FILE_ATTACH
  (

     V_MA_THONGBAO IN VARCHAR2 DEFAULT NULL ,
     V_FILE_NAME OUT VARCHAR2,
     ITEMS_CURSOR OUT SYS_REFCURSOR
  )    
    AS
    V_COUNT_CHECK NUMBER(10,0);V_TP_THANH_TOAN_ID NUMBER(10,0);
 BEGIN
    SELECT ID INTO V_TP_THANH_TOAN_ID  FROM DVCQG_THANH_TOAN DVC WHERE  DVC.MA_THONGBAO = V_MA_THONGBAO;
    SELECT COUNT(*) INTO V_COUNT_CHECK FROM DVCQG_FILE_BIENLAI PF WHERE PF.TP_THANH_TOAN_ID=V_TP_THANH_TOAN_ID;
    IF(V_COUNT_CHECK>0) THEN
    SELECT PF.FILE_NAME INTO V_FILE_NAME FROM DVCQG_FILE_BIENLAI PF WHERE PF.TP_THANH_TOAN_ID=V_TP_THANH_TOAN_ID;
    END IF;
    ----
     OPEN ITEMS_CURSOR FOR
         SELECT PF.FILE_ATTACH FROM DVCQG_FILE_BIENLAI PF WHERE PF.TP_THANH_TOAN_ID=V_TP_THANH_TOAN_ID;
END GET_FILE_ATTACH;
PROCEDURE  INSERT_DUONGSU_AHN_ALL
IS 
            V_COUNT NUMBER;
BEGIN
    FOR REC IN (
           SELECT AI.ID,AI.duongsu_ids FROM ahn_anphi AI --WHERE AI.DONID=292181 bỏ đi để chạy đồng bộ
           )
         LOOP
              FOR item IN 
                      (  select REGEXP_SUBSTR (REC.duongsu_ids, '[^,]+', 1, level) as DUONGSU_ID from dual        
                              connect by level <= length(regexp_replace(REC.duongsu_ids,'[^,]*'))+1 )
                LOOP
                  IF(item.DUONGSU_ID IS NOT NULL) THEN
                  SELECT COUNT(*) INTO V_COUNT FROM AHN_ANPHI_DUONGSU AN WHERE item.DUONGSU_ID=AN.DUONGSU_ID AND REC.ID=AN.ANPHI_ID;
                     IF( V_COUNT=0)THEN
                       INSERT INTO AHN_ANPHI_DUONGSU
                       (ANPHI_ID,DUONGSU_ID)
                       VALUES (REC.ID,item.DUONGSU_ID);
                        COMMIT;   
                    END IF;
                  END IF;
                END LOOP;
        END LOOP;
END INSERT_DUONGSU_AHN_ALL;
PROCEDURE  INSERT_DATA_DUONGSU_AHN
(
  V_ANPHI_ID NUMBER
)
IS 
            V_COUNT NUMBER;
BEGIN
    FOR REC IN (
           SELECT AI.ID,AI.duongsu_ids FROM ahn_anphi AI WHERE AI.ID=V_ANPHI_ID 
           )
         LOOP
              FOR item IN 
                      (  select REGEXP_SUBSTR (REC.duongsu_ids, '[^,]+', 1, level) as DUONGSU_ID from dual        
                              connect by level <= length(regexp_replace(REC.duongsu_ids,'[^,]*'))+1 )
                LOOP
                  IF(item.DUONGSU_ID IS NOT NULL) THEN
                  SELECT COUNT(*) INTO V_COUNT FROM AHN_ANPHI_DUONGSU AN WHERE item.DUONGSU_ID=AN.DUONGSU_ID AND REC.ID=AN.ANPHI_ID;
                     IF( V_COUNT=0)THEN
                       INSERT INTO AHN_ANPHI_DUONGSU
                       (ANPHI_ID,DUONGSU_ID)
                       VALUES (REC.ID,item.DUONGSU_ID);
                       COMMIT;   
                    END IF;
                  END IF;
                END LOOP;
        END LOOP;
END INSERT_DATA_DUONGSU_AHN;
PROCEDURE DELETE_DATA_DUONGSU_AHN
( 
  V_ANPHI_ID IN NUMBER
)
IS  
BEGIN
         DELETE AHN_ANPHI_DUONGSU TT
         WHERE TT.ANPHI_ID=V_ANPHI_ID;
END DELETE_DATA_DUONGSU_AHN;
PROCEDURE  INSERT_DUONGSU_AHC_ALL 
IS 
            V_COUNT NUMBER;
BEGIN
    FOR REC IN (
           SELECT AI.ID,AI.duongsu_ids FROM AHC_anphi AI --WHERE AI.DONID=292181 bỏ đi để chạy đồng bộ
           )
         LOOP
              FOR item IN 
                      (  select REGEXP_SUBSTR (REC.duongsu_ids, '[^,]+', 1, level) as DUONGSU_ID from dual        
                              connect by level <= length(regexp_replace(REC.duongsu_ids,'[^,]*'))+1 )
                LOOP
                  IF(item.DUONGSU_ID IS NOT NULL) THEN
                  SELECT COUNT(*) INTO V_COUNT FROM AHC_ANPHI_DUONGSU AN WHERE item.DUONGSU_ID=AN.DUONGSU_ID AND REC.ID=AN.ANPHI_ID;
                     IF( V_COUNT=0)THEN
                       INSERT INTO AHC_ANPHI_DUONGSU
                       (ANPHI_ID,DUONGSU_ID)
                       VALUES (REC.ID,item.DUONGSU_ID);
                        COMMIT;   
                    END IF;
                  END IF;
                END LOOP;
        END LOOP;
END INSERT_DUONGSU_AHC_ALL;
PROCEDURE  INSERT_DATA_DUONGSU_AHC
(
  V_ANPHI_ID NUMBER
)
IS 
            V_COUNT NUMBER;
BEGIN
    FOR REC IN (
           SELECT AI.ID,AI.duongsu_ids FROM ahc_anphi AI WHERE AI.ID=V_ANPHI_ID 
           )
         LOOP
              FOR item IN 
                      (  select REGEXP_SUBSTR (REC.duongsu_ids, '[^,]+', 1, level) as DUONGSU_ID from dual        
                              connect by level <= length(regexp_replace(REC.duongsu_ids,'[^,]*'))+1 )
                LOOP
                  IF(item.DUONGSU_ID IS NOT NULL) THEN
                  SELECT COUNT(*) INTO V_COUNT FROM AHC_ANPHI_DUONGSU AN WHERE item.DUONGSU_ID=AN.DUONGSU_ID AND REC.ID=AN.ANPHI_ID;
                     IF( V_COUNT=0)THEN
                       INSERT INTO AHC_ANPHI_DUONGSU
                       (ANPHI_ID,DUONGSU_ID)
                       VALUES (REC.ID,item.DUONGSU_ID);
                       COMMIT;   
                    END IF;
                  END IF;
                END LOOP;
        END LOOP;
END INSERT_DATA_DUONGSU_AHC;
PROCEDURE DELETE_DATA_DUONGSU_AHC
( 
  V_ANPHI_ID IN NUMBER
)
IS  
BEGIN
         DELETE AHC_ANPHI_DUONGSU TT
         WHERE TT.ANPHI_ID=V_ANPHI_ID;
END DELETE_DATA_DUONGSU_AHC;


--VNPT Lê Bá Thọ thêm Isert,Delete cho AKT
PROCEDURE  INSERT_DUONGSU_AKT_ALL 
IS 
            V_COUNT NUMBER;
BEGIN
    FOR REC IN (
           SELECT AI.ID,AI.duongsu_ids FROM AKT_anphi AI --WHERE AI.DONID=292181 bỏ đi để chạy đồng bộ
           )
         LOOP
              FOR item IN 
                      (  select REGEXP_SUBSTR (REC.duongsu_ids, '[^,]+', 1, level) as DUONGSU_ID from dual        
                              connect by level <= length(regexp_replace(REC.duongsu_ids,'[^,]*'))+1 )
                LOOP
                  IF(item.DUONGSU_ID IS NOT NULL) THEN
                  SELECT COUNT(*) INTO V_COUNT FROM AKT_ANPHI_DUONGSU AN WHERE item.DUONGSU_ID=AN.DUONGSU_ID AND REC.ID=AN.ANPHI_ID;
                     IF( V_COUNT=0)THEN
                       INSERT INTO AKT_ANPHI_DUONGSU
                       (ANPHI_ID,DUONGSU_ID)
                       VALUES (REC.ID,item.DUONGSU_ID);
                        COMMIT;   
                    END IF;
                  END IF;
                END LOOP;
        END LOOP;
END INSERT_DUONGSU_AKT_ALL;

PROCEDURE  INSERT_DATA_DUONGSU_AKT
(
  V_ANPHI_ID NUMBER
)
IS 
            V_COUNT NUMBER;
BEGIN
    FOR REC IN (
           SELECT AI.ID,AI.duongsu_ids FROM akt_anphi AI WHERE AI.ID=V_ANPHI_ID 
           )
         LOOP
              FOR item IN 
                      (  select REGEXP_SUBSTR (REC.duongsu_ids, '[^,]+', 1, level) as DUONGSU_ID from dual        
                              connect by level <= length(regexp_replace(REC.duongsu_ids,'[^,]*'))+1 )
                LOOP
                  IF(item.DUONGSU_ID IS NOT NULL) THEN
                  SELECT COUNT(*) INTO V_COUNT FROM AKT_ANPHI_DUONGSU AN WHERE item.DUONGSU_ID=AN.DUONGSU_ID AND REC.ID=AN.ANPHI_ID;
                     IF( V_COUNT=0)THEN
                       INSERT INTO AKT_ANPHI_DUONGSU
                       (ANPHI_ID,DUONGSU_ID)
                       VALUES (REC.ID,item.DUONGSU_ID);
                       COMMIT;   
                    END IF;
                  END IF;
                END LOOP;
        END LOOP;
END INSERT_DATA_DUONGSU_AKT;

PROCEDURE DELETE_DATA_DUONGSU_AKT
( 
  V_ANPHI_ID IN NUMBER
)
IS  
BEGIN
         DELETE AKT_ANPHI_DUONGSU TT
         WHERE TT.ANPHI_ID=V_ANPHI_ID;
END DELETE_DATA_DUONGSU_AKT;


--VNPT Lê Bá Thọ thêm Isert,Delete cho ADS
PROCEDURE  INSERT_DUONGSU_ADS_ALL
IS 
            V_COUNT NUMBER;
BEGIN
    FOR REC IN (
           SELECT AI.ID,AI.duongsu_ids FROM ADS_anphi AI --WHERE AI.DONID=292181 bỏ đi để chạy đồng bộ
           )
         LOOP
              FOR item IN 
                      (  select REGEXP_SUBSTR (REC.duongsu_ids, '[^,]+', 1, level) as DUONGSU_ID from dual        
                              connect by level <= length(regexp_replace(REC.duongsu_ids,'[^,]*'))+1 )
                LOOP
                  IF(item.DUONGSU_ID IS NOT NULL) THEN
                  SELECT COUNT(*) INTO V_COUNT FROM ADS_ANPHI_DUONGSU AN WHERE item.DUONGSU_ID=AN.DUONGSU_ID AND REC.ID=AN.ANPHI_ID;
                     IF( V_COUNT=0)THEN
                       INSERT INTO ADS_ANPHI_DUONGSU
                       (ANPHI_ID,DUONGSU_ID)
                       VALUES (REC.ID,item.DUONGSU_ID);
                        COMMIT;   
                    END IF;
                  END IF;
                END LOOP;
        END LOOP;
END INSERT_DUONGSU_ADS_ALL;
PROCEDURE  INSERT_DATA_DUONGSU_ADS
(
  V_ANPHI_ID NUMBER
)
IS 
            V_COUNT NUMBER;
BEGIN
    FOR REC IN (
           SELECT AI.ID,AI.duongsu_ids FROM ads_anphi AI WHERE AI.ID=V_ANPHI_ID 
           )
         LOOP
              FOR item IN 
                      (  select REGEXP_SUBSTR (REC.duongsu_ids, '[^,]+', 1, level) as DUONGSU_ID from dual        
                              connect by level <= length(regexp_replace(REC.duongsu_ids,'[^,]*'))+1 )
                LOOP
                  IF(item.DUONGSU_ID IS NOT NULL) THEN
                  SELECT COUNT(*) INTO V_COUNT FROM ADS_ANPHI_DUONGSU AN WHERE item.DUONGSU_ID=AN.DUONGSU_ID AND REC.ID=AN.ANPHI_ID;
                     IF( V_COUNT=0)THEN
                       INSERT INTO ADS_ANPHI_DUONGSU
                       (ANPHI_ID,DUONGSU_ID)
                       VALUES (REC.ID,item.DUONGSU_ID);
                       COMMIT;   
                    END IF;
                  END IF;
                END LOOP;
        END LOOP;
END INSERT_DATA_DUONGSU_ADS;
PROCEDURE DELETE_DATA_DUONGSU_ADS
( 
  V_ANPHI_ID IN NUMBER
)
IS  
BEGIN
         DELETE ADS_ANPHI_DUONGSU TT
         WHERE TT.ANPHI_ID=V_ANPHI_ID;
END DELETE_DATA_DUONGSU_ADS;

--VNPT Lê Bá Thọ thêm Isert,Delete cho ALD
PROCEDURE  INSERT_DUONGSU_ALD_ALL
IS 
            V_COUNT NUMBER;
BEGIN
    FOR REC IN (
           SELECT AI.ID,AI.duongsu_ids FROM ALD_anphi AI --WHERE AI.DONID=292181 bỏ đi để chạy đồng bộ
           )
         LOOP
              FOR item IN 
                      (  select REGEXP_SUBSTR (REC.duongsu_ids, '[^,]+', 1, level) as DUONGSU_ID from dual        
                              connect by level <= length(regexp_replace(REC.duongsu_ids,'[^,]*'))+1 )
                LOOP
                  IF(item.DUONGSU_ID IS NOT NULL) THEN
                  SELECT COUNT(*) INTO V_COUNT FROM ALD_ANPHI_DUONGSU AN WHERE item.DUONGSU_ID=AN.DUONGSU_ID AND REC.ID=AN.ANPHI_ID;
                     IF( V_COUNT=0)THEN
                       INSERT INTO ALD_ANPHI_DUONGSU
                       (ANPHI_ID,DUONGSU_ID)
                       VALUES (REC.ID,item.DUONGSU_ID);
                        COMMIT; 
                    END IF;
                  END IF;
                END LOOP;
        END LOOP;
END INSERT_DUONGSU_ALD_ALL;
PROCEDURE  INSERT_DATA_DUONGSU_ALD
(
  V_ANPHI_ID NUMBER
)
IS 
            V_COUNT NUMBER;
BEGIN
    FOR REC IN (
           SELECT AI.ID,AI.duongsu_ids FROM ALD_ANPHI AI WHERE AI.ID=V_ANPHI_ID 
           )
         LOOP
              FOR item IN 
                      (  select REGEXP_SUBSTR (REC.duongsu_ids, '[^,]+', 1, level) as DUONGSU_ID from dual        
                              connect by level <= length(regexp_replace(REC.duongsu_ids,'[^,]*'))+1 )
                LOOP
                  IF(item.DUONGSU_ID IS NOT NULL) THEN
                  SELECT COUNT(*) INTO V_COUNT FROM ALD_ANPHI_DUONGSU AN WHERE item.DUONGSU_ID=AN.DUONGSU_ID AND REC.ID=AN.ANPHI_ID;
                     IF( V_COUNT=0)THEN
                       INSERT INTO ALD_ANPHI_DUONGSU
                       (ANPHI_ID,DUONGSU_ID)
                       VALUES (REC.ID,item.DUONGSU_ID);
                       COMMIT;   
                    END IF;
                  END IF;
                END LOOP;
        END LOOP;
END INSERT_DATA_DUONGSU_ALD;
PROCEDURE DELETE_DATA_DUONGSU_ALD
( 
  V_ANPHI_ID IN NUMBER
)
IS  
BEGIN
         DELETE ALD_ANPHI_DUONGSU TT
         WHERE TT.ANPHI_ID=V_ANPHI_ID;
END DELETE_DATA_DUONGSU_ALD;
-----------------


PROCEDURE CHECK_DELETE_ANPHI
( 
  V_ANPHI_ID IN NUMBER,
  V_MALOAIVUVIEC IN VARCHAR2,
  V_VALUE OUT NUMBER
)
IS  
    V_COUNTS NUMBER;
    V_COUNT_TT NUMBER:=0;
    V_TONGDAT NUMBER;
BEGIN
    V_VALUE:=0;
    SELECT COUNT(*) INTO V_COUNT_TT FROM DVCQG_THANH_TOAN TT  WHERE TT.ANPHI_ID=V_ANPHI_ID AND MALOAIVUVIEC=V_MALOAIVUVIEC AND TRANGTHAITHANHTOAN=1
     and TT.TONGDATID IS NOT NULL;
    IF(V_COUNT_TT=0)THEN 
        V_VALUE:=1;
    END IF;
END CHECK_DELETE_ANPHI;
PROCEDURE DVCQG_FILE_BIENLAI_UP
( 
    V_DVCQG_TT_ID in number,
    V_FILE_ATTACH   IN   BLOB,
    V_ERROR_CODE OUT VARCHAR2,
    V_MESSAGE OUT VARCHAR2
)
IS     
         l_error_code           VARCHAR2 (250) DEFAULT '-1'; --0
         l_message              VARCHAR2 (250)  DEFAULT 'Chưa có thông tin update';
         V_LENGTH NUMBER;
BEGIN
     UPDATE DVCQG_FILE_BIENLAI
     SET FILE_ATTACH=V_FILE_ATTACH,CREATE_DATE=SYSDATE
     WHERE TP_THANH_TOAN_ID=V_DVCQG_TT_ID;
     ------------
     SELECT LENGTH(FILE_ATTACH) INTO V_LENGTH  FROM DVCQG_FILE_BIENLAI
         WHERE TP_THANH_TOAN_ID=V_DVCQG_TT_ID;
            IF(V_LENGTH>1000)THEN
                    l_error_code := '0';
                    l_message := 'đã update thành công';
             END IF;
        V_ERROR_CODE:=l_error_code;     
        V_MESSAGE:=l_message;
END DVCQG_FILE_BIENLAI_UP;
PROCEDURE GET_URL_DVC_THANHTOAN
  (
     V_DVCQG_TT_ID IN VARCHAR2,    
     ITEMS_CURSOR OUT SYS_REFCURSOR
  )    
    AS
 BEGIN
     OPEN ITEMS_CURSOR FOR
         SELECT TT.URLBIENLAI FROM DVCQG_THANH_TOAN TT WHERE TT.ID=V_DVCQG_TT_ID;
END GET_URL_DVC_THANHTOAN;
END PKG_TUPHAP_ANPHI_DVCQG;