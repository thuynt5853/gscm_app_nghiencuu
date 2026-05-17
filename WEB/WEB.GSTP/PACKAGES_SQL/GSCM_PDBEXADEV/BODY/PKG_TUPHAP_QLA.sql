--------------------------------------------------------
--  DDL for Package Body PKG_TUPHAP_QLA
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_TUPHAP_QLA" AS
PROCEDURE CHECK_ENABLE
(
  V_ID IN NUMBER,
  V_LOAI_AN IN VARCHAR2 DEFAULT NULL
)
AS  
   V_VALUE VARCHAR2(50);
   V_ENABLE VARCHAR2(50);

BEGIN
       IF(V_LOAI_AN='2') THEN
          SELECT ENABLE  INTO V_ENABLE FROM ADS_ANPHI  WHERE ID = V_ID;   
          -----
           IF (V_ENABLE = 0 ) THEN
              V_VALUE := 1 ;
           ELSE
              V_VALUE := 0 ;
           END IF;  
           BEGIN
              UPDATE ADS_ANPHI
                 SET ENABLE = V_VALUE
                 WHERE ID = V_ID; 
           END;  
         ELSIF(V_LOAI_AN='3') THEN
          SELECT ENABLE  INTO V_ENABLE FROM AHN_ANPHI  WHERE ID = V_ID;   
          -----
           IF (V_ENABLE = 0 ) THEN
              V_VALUE := 1 ;
           ELSE
              V_VALUE := 0 ;
           END IF;  
           BEGIN
              UPDATE AHN_ANPHI
                 SET ENABLE = V_VALUE
                 WHERE ID = V_ID; 
           END;  
          ELSIF(V_LOAI_AN='4') THEN
           SELECT ENABLE  INTO V_ENABLE FROM AKT_ANPHI  WHERE ID = V_ID;   
           IF (V_ENABLE = 0 ) THEN
              V_VALUE := 1 ;
           ELSE
              V_VALUE := 0 ;
           END IF;  
           BEGIN
              UPDATE AKT_ANPHI
                 SET ENABLE = V_VALUE
                 WHERE ID = V_ID; 
           END;  
          ELSIF(V_LOAI_AN='5') THEN
           SELECT ENABLE  INTO V_ENABLE FROM ALD_ANPHI  WHERE ID = V_ID;   
           IF (V_ENABLE = 0 ) THEN
              V_VALUE := 1 ;
           ELSE
              V_VALUE := 0 ;
           END IF;  
           BEGIN
              UPDATE ALD_ANPHI
                 SET ENABLE = V_VALUE
                 WHERE ID = V_ID; 
           END;    
         ELSIF(V_LOAI_AN='6') THEN
           SELECT ENABLE  INTO V_ENABLE FROM AHC_ANPHI  WHERE ID = V_ID;   
           IF (V_ENABLE = 0 ) THEN
              V_VALUE := 1 ;
           ELSE
              V_VALUE := 0 ;
           END IF;  
           BEGIN
              UPDATE AHC_ANPHI
                 SET ENABLE = V_VALUE
                 WHERE ID = V_ID; 
           END;      
          ELSIF(V_LOAI_AN='7') THEN
           SELECT ENABLE  INTO V_ENABLE FROM APS_ANPHI  WHERE ID = V_ID;   
           IF (V_ENABLE = 0 ) THEN
              V_VALUE := 1 ;
           ELSE
              V_VALUE := 0 ;
           END IF;  
           BEGIN
              UPDATE APS_ANPHI
                 SET ENABLE = V_VALUE
                 WHERE ID = V_ID; 
           END;      
       END IF; 
END CHECK_ENABLE;
PROCEDURE CHECK_ENABLE_THULY
(
  V_DONID IN NUMBER,
  V_LOAI_AN IN VARCHAR2 DEFAULT NULL
)
AS  
   V_VALUE VARCHAR2(50);
   V_COUNT VARCHAR2(50);

BEGIN
       IF(V_LOAI_AN='2') THEN
          SELECT COUNT(*) INTO V_COUNT FROM ADS_SOTHAM_THULY WHERE DONID = V_DONID;   
          -----
           IF (V_COUNT >0 ) THEN
              V_VALUE := 1;--đã thụ lý
           ELSE
              V_VALUE := 0;--chưa thụ lý
           END IF;  
           BEGIN
              UPDATE ADS_ANPHI
                 SET ENABLE = V_VALUE
                 WHERE DONID = V_DONID; 
           END;  
         ELSIF(V_LOAI_AN='3') THEN
          SELECT COUNT(*)  INTO V_COUNT FROM AHN_SOTHAM_THULY WHERE DONID = V_DONID;   
          -----
           IF (V_COUNT > 0 ) THEN
              V_VALUE := 1;
           ELSE
              V_VALUE := 0;
           END IF;  
           BEGIN
              UPDATE AHN_ANPHI
                 SET ENABLE = V_VALUE
                 WHERE DONID = V_DONID; 
           END;    
         ELSIF(V_LOAI_AN='4') THEN
          SELECT COUNT(*)  INTO V_COUNT FROM AKT_SOTHAM_THULY WHERE DONID = V_DONID;   
          -----
           IF (V_COUNT > 0 ) THEN
              V_VALUE := 1;
           ELSE
              V_VALUE := 0;
           END IF;  
           BEGIN
              UPDATE AKT_ANPHI
                 SET ENABLE = V_VALUE
                 WHERE DONID = V_DONID; 
           END;      
         ELSIF(V_LOAI_AN='5') THEN
          SELECT COUNT(*)  INTO V_COUNT FROM ALD_SOTHAM_THULY WHERE DONID = V_DONID;   
          -----
           IF (V_COUNT > 0 ) THEN
              V_VALUE := 1;
           ELSE
              V_VALUE := 0;
           END IF;  
           BEGIN
              UPDATE ALD_ANPHI
                 SET ENABLE = V_VALUE
                 WHERE DONID = V_DONID; 
           END;      
          ELSIF(V_LOAI_AN='6') THEN
          SELECT COUNT(*)  INTO V_COUNT FROM AHC_SOTHAM_THULY WHERE DONID = V_DONID;   
          -----
           IF (V_COUNT > 0 ) THEN
              V_VALUE := 1;
           ELSE
              V_VALUE := 0;
           END IF;  
           BEGIN
              UPDATE AHC_ANPHI
                 SET ENABLE = V_VALUE
                 WHERE DONID = V_DONID; 
           END;        
          ELSIF(V_LOAI_AN='7') THEN
          SELECT COUNT(*)  INTO V_COUNT FROM APS_SOTHAM_THULY WHERE DONID = V_DONID;   
          -----
           IF (V_COUNT > 0 ) THEN
              V_VALUE := 1;
           ELSE
              V_VALUE := 0;
           END IF;  
           BEGIN
              UPDATE APS_ANPHI
                 SET ENABLE = V_VALUE
                 WHERE DONID = V_DONID; 
           END;          
       END IF; 
END CHECK_ENABLE_THULY;
PROCEDURE GET_ENABLE_ANPHI
  (
     V_ANPHI_ID IN NUMBER,   
     V_LOAI_AN IN VARCHAR2 DEFAULT NULL ,  
     ITEMS_CURSOR OUT SYS_REFCURSOR
  )    
    AS
 BEGIN
        IF(V_LOAI_AN='2') THEN
             OPEN ITEMS_CURSOR FOR
             SELECT AP.* FROM ADS_ANPHI AP WHERE AP.ID=V_ANPHI_ID;
         ELSIF(V_LOAI_AN='3') THEN
             OPEN ITEMS_CURSOR FOR
             SELECT AP.* FROM AHN_ANPHI AP WHERE AP.ID=V_ANPHI_ID; 
           ELSIF(V_LOAI_AN='4') THEN
             OPEN ITEMS_CURSOR FOR
             SELECT AP.* FROM AKT_ANPHI AP WHERE AP.ID=V_ANPHI_ID;   
           ELSIF(V_LOAI_AN='5') THEN
             OPEN ITEMS_CURSOR FOR
             SELECT AP.* FROM ALD_ANPHI AP WHERE AP.ID=V_ANPHI_ID; 
          ELSIF(V_LOAI_AN='6') THEN
             OPEN ITEMS_CURSOR FOR
             SELECT AP.* FROM AHC_ANPHI AP WHERE AP.ID=V_ANPHI_ID;     
          ELSIF(V_LOAI_AN='7') THEN
             OPEN ITEMS_CURSOR FOR
             SELECT AP.* FROM APS_ANPHI AP WHERE AP.ID=V_ANPHI_ID;    
         END IF;
END GET_ENABLE_ANPHI;
END PKG_TUPHAP_QLA;

/
