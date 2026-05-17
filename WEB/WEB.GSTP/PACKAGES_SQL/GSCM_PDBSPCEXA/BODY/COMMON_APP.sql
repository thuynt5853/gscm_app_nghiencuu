--------------------------------------------------------
--  DDL for Package Body COMMON_APP
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."COMMON_APP" AS
FUNCTION GET_NGAY_LAMVIEC
(
   V_DATE_FROM DATE,
   V_DATE_TO  DATE
)
RETURN NUMBER
AS
     v_cursor SYS_REFCURSOR;
     V_COUNT NUMBER; v_table T_NGAY_LAM_VIEC; holiday_count NUMBER;weekday_count NUMBER;
BEGIN
            --anhvh 28/08/2023
           v_table := T_NGAY_LAM_VIEC(); 
           ---------
           v_table.extend;
           v_table(v_table.count) := R_NGAY_LAM_VIEC(V_DATE_FROM,V_DATE_TO,NULL,1);  --bang chua 2 gia tri ngay
           --------
         FOR rec IN EXTRACT(YEAR FROM V_DATE_FROM)..EXTRACT(YEAR FROM V_DATE_TO)    --bang chua nhung nghay nghi le   
           LOOP        
                     FOR item IN (
                       SELECT To_date('01/01/'||rec, 'DD/MM/YYYY') holiday FROM   dual UNION ALL
                       SELECT To_date('30/04/'||rec, 'DD/MM/YYYY') holiday FROM   dual UNION ALL
                       SELECT To_date('01/05/'||rec, 'DD/MM/YYYY') holiday FROM   dual UNION ALL
                       SELECT To_date('01/09/'||rec, 'DD/MM/YYYY') holiday FROM   dual UNION ALL
                       SELECT To_date('02/09/'||rec, 'DD/MM/YYYY') holiday FROM   dual
                     )
                     LOOP
                       v_table.extend;
                       v_table(v_table.count) := R_NGAY_LAM_VIEC(NULL,NULL,item.holiday,2
                     );  
                     END LOOP;
         END LOOP;
        --------------tong ngay loai di ngay t7,chu nhat
      SELECT SUM(weekday) INTO  weekday_count
                       FROM   (SELECT CASE WHEN To_char(dates.V_DATE_FROM + LEVEL - 1, 'DY','NLS_DATE_LANGUAGE=AMERICAN') NOT IN ( 'SAT', 'SUN' ) THEN 1 ELSE 0  END weekday
                               FROM   (SELECT * FROM TABLE(v_table) WHERE V_STYLE=1)dates
                               CONNECT BY LEVEL <= dates.V_DATE_TO - dates.V_DATE_FROM + 1) ;

         ----------------lay tong so ngay le trong khoang tu ngay den ngay                      
                    SELECT Count(*)INTO holiday_count  FROM 
                         (SELECT * FROM TABLE(v_table) WHERE V_STYLE=2)holidays,
                         (SELECT * FROM TABLE(v_table) WHERE V_STYLE=1)dates 
                    WHERE holidays.V_NGAY >=dates.V_DATE_FROM  AND holidays.V_NGAY <=dates.V_DATE_TO ;

        ---------------tong ngay lam viec=tong ngay bo di ngay  t7,chu nhat - tong ngay le            
        V_COUNT:=(weekday_count - holiday_count);
     --  OPEN v_cursor FOR
     -- select V_COUNT V_COUNT from dual;
RETURN V_COUNT;
END GET_NGAY_LAMVIEC;
END COMMON_APP;
