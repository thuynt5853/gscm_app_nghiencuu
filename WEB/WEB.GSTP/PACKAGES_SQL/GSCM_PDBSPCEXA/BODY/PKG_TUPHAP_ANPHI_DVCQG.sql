--------------------------------------------------------
--  DDL for Package Body PKG_TUPHAP_ANPHI_DVCQG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_TUPHAP_ANPHI_DVCQG" AS
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
END PKG_TUPHAP_ANPHI_DVCQG;
