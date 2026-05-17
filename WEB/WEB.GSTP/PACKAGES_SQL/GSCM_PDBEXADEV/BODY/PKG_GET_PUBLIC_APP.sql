--------------------------------------------------------
--  DDL for Package Body PKG_GET_PUBLIC_APP
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_GET_PUBLIC_APP" AS
 FUNCTION PUBLIC_COURT_DETAIL
(
 V_COURT_ID	VARCHAR2 DEFAULT NULL,
 V_TYPE VARCHAR2 DEFAULT NULL,
  PageIndex	in	int,
  PageSize	in	int  
 ) RETURN SYS_REFCURSOR  
 AS
    v_cursor SYS_REFCURSOR; 
    TotalItem number;  MinIndex	number;  MaxIndex	number; V_ORDERS NUMBER:=0;
    v_table T_PUBLIC_COURT; v_table_tp T_PUBLIC_COURT_DETAIL;VV_ORDERS NUMBER:=0;VVV_ORDERS NUMBER:=0;
    --------------------------
    COLUMN_1 NUMBER;COLUMN_2 NUMBER;COLUMN_3 NUMBER;COLUMN_4 NUMBER;COLUMN_5 NUMBER;COLUMN_6 NUMBER;
    VV_COURT_ID VARCHAR2(100); VV_TYPE VARCHAR2(150):=NULL;
  BEGIN  
    v_table := T_PUBLIC_COURT(); v_table_tp := T_PUBLIC_COURT_DETAIL(); 
     MinIndex := PageSize*(PageIndex - 1) + 1;
     MaxIndex := PageIndex*PageSize ;
  -----------------------------------
  IF(V_TYPE IS NULL) THEN
           IF(V_COURT_ID IS NOT NULL AND V_COURT_ID!='0') THEN
               SELECT RC.ID,DECODE(RC.TYPE,'T','T,H','TW','TW,CW,T,H',RC.TYPE) INTO VV_COURT_ID,VV_TYPE FROM PUBLIC_APP.ROOM_COURTS@DBLINK_PUBLIC_TO_SOHOA RC  WHERE RC.MADONGBO=(SELECT RC.MADONGBO FROM DM_TOAAN RC WHERE RC.ID=V_COURT_ID);
                IF(VV_TYPE='TW,CW,T,H')THEN
                   VV_COURT_ID:=NULL;
                END IF;
           ELSIF(V_COURT_ID IS NULL OR V_COURT_ID=0) THEN
               VV_TYPE:='TW,CW,T,H';VV_COURT_ID:=NULL;
           END IF;
  ELSIF(V_TYPE IS NOT NULL) THEN
          IF(V_COURT_ID IS NOT NULL AND V_COURT_ID!='0') THEN
              SELECT RC.ID,RC.TYPE INTO VV_COURT_ID,VV_TYPE FROM PUBLIC_APP.ROOM_COURTS@DBLINK_PUBLIC_TO_SOHOA RC  WHERE RC.MADONGBO=(SELECT RC.MADONGBO FROM DM_TOAAN RC WHERE RC.ID=V_COURT_ID);      
              IF(V_TYPE='H' AND (VV_TYPE='T')) THEN
                VV_TYPE:='T,H';
                ELSIF(V_TYPE='H' AND (VV_TYPE='TW')) THEN
                VV_TYPE:='T,H';VV_COURT_ID:=NULL;
                    ELSIF(VV_TYPE='TW') THEN
                    VV_TYPE:=V_TYPE;VV_COURT_ID:=NULL;
              END IF;
            ELSIF(V_COURT_ID IS NULL OR V_COURT_ID=0) THEN
                  IF(V_TYPE='H') THEN
                      VV_TYPE:='T,H';VV_COURT_ID:=NULL;
                  ELSE
                   VV_TYPE:=V_TYPE;VV_COURT_ID:=NULL;
                  END IF;
           END IF;
  END IF;
  -----------------------------------
       IF (VV_TYPE ='TW,CW,T,H') THEN
             FOR rec IN
                    (
                       SELECT 4 PARENT_ID,RC.ID,'<b>'||RC.COURT_NAME ||'</b>' COURT_NAME FROM  PUBLIC_APP.ROOM_COURTS@DBLINK_PUBLIC_TO_SOHOA RC 
                                   WHERE RC.TYPE='TW' 
                                    AND ((instr(','||VV_COURT_ID||',',','||RC.ID||',')>0 AND VV_COURT_ID IS NOT NULL) OR (VV_COURT_ID IS NULL))
                                   GROUP BY RC.ID,RC.COURT_NAME,RC.PARENT_ID
                              UNION ALL -- cap cao
                                  SELECT 4 PARENT_ID,RC.ID,'<b>'||RC.COURT_NAME ||'</b>' COURT_NAME FROM PUBLIC_APP.ROOM_COURTS@DBLINK_PUBLIC_TO_SOHOA RC
                                   WHERE RC.TYPE='CW'
                                   AND  ((instr(','||VV_COURT_ID||',',','||RC.ID||',')>0 AND VV_COURT_ID IS NOT NULL) OR (VV_COURT_ID IS NULL))
                                   GROUP BY RC.ID,RC.COURT_NAME,RC.PARENT_ID
                             UNION ALL
                              SELECT CC.PARENT_ID,CC.ID,'<b>'||CC.COURT_NAME||'</b>' COURT_NAME FROM 
                                     (
                                  SELECT LPAD('   ', LEVEL*3) || FF.COURT_NAME COURT_NAME,FF.ID,FF.PARENT_ID FROM (    
                                    --cap tinh
                                       SELECT TT.PARENT_ID,TT.ID,TT.COURT_NAME
                                       FROM (                 
                                         SELECT RC1.PARENT_ID,RC1.ID,RC1.COURT_NAME FROM 
                                         ---tim cha 
                                          PUBLIC_APP.ROOM_COURTS@DBLINK_PUBLIC_TO_SOHOA RC
                                         LEFT JOIN PUBLIC_APP.ROOM_COURTS@DBLINK_PUBLIC_TO_SOHOA RC1 ON RC.PARENT_ID=RC1.ID
                                         WHERE RC.TYPE='H' 
                                         AND ((instr(','||VV_COURT_ID||',',','||RC.PARENT_ID||',')>0 AND VV_COURT_ID IS NOT NULL) OR (VV_COURT_ID IS NULL))
                                         GROUP BY RC1.ID,RC1.COURT_NAME,RC1.PARENT_ID
                                       UNION ALL
                                          SELECT RC.PARENT_ID,RC.ID,RC.COURT_NAME FROM 
                                         --tim id tinh  
                                        PUBLIC_APP.ROOM_COURTS@DBLINK_PUBLIC_TO_SOHOA RC 
                                         WHERE RC.TYPE='T' 
                                          AND ((instr(','||VV_COURT_ID||',',','||RC.ID||',')>0 AND VV_COURT_ID IS NOT NULL) OR (VV_COURT_ID IS NULL))
                                         GROUP BY RC.ID,RC.COURT_NAME,RC.PARENT_ID
                                       )TT
                                       GROUP BY TT.PARENT_ID,TT.ID,TT.COURT_NAME
                                  UNION ALL --lay them huyen
                                         SELECT RC.PARENT_ID,RC.ID,RC.COURT_NAME FROM PUBLIC_APP.ROOM_COURTS@DBLINK_PUBLIC_TO_SOHOA RC 
                                         WHERE RC.TYPE='H' 
                                         AND ((instr(','||VV_COURT_ID||',',','||RC.PARENT_ID||',')>0 AND VV_COURT_ID IS NOT NULL) OR (VV_COURT_ID IS NULL))
                                         GROUP BY RC.ID,RC.COURT_NAME,RC.PARENT_ID
                                       )FF
                         START WITH FF.PARENT_ID = 4
                        CONNECT BY PRIOR id= FF.PARENT_ID
                        ORDER SIBLINGS BY NLSSORT (FF.COURT_NAME, 'NLS_SORT=vietnamese')
                        )CC
               )
            LOOP--don vi do vao bang ao
                V_ORDERS:=V_ORDERS+1;
                v_table.extend;
                v_table(v_table.count) := R_PUBLIC_COURT(rec.ID,rec.COURT_NAME,V_ORDERS);     
            END LOOP; 
            ELSIF ( VV_TYPE ='T,H') THEN
             FOR rec IN
                    ( SELECT CC.PARENT_ID,CC.ID,'<b>'||CC.COURT_NAME||'</b>' COURT_NAME FROM 
                                     (
                                  SELECT LPAD('   ', LEVEL*3) || FF.COURT_NAME COURT_NAME,FF.ID,FF.PARENT_ID FROM (    
                                    --cap tinh
                                       SELECT TT.PARENT_ID,TT.ID,TT.COURT_NAME
                                       FROM (                 
                                         SELECT RC1.PARENT_ID,RC1.ID,RC1.COURT_NAME FROM 
                                         ---tim cha 
                                          PUBLIC_APP.ROOM_COURTS@DBLINK_PUBLIC_TO_SOHOA RC
                                         LEFT JOIN PUBLIC_APP.ROOM_COURTS@DBLINK_PUBLIC_TO_SOHOA RC1 ON RC.PARENT_ID=RC1.ID
                                         WHERE RC.TYPE='H' 
                                         AND ((instr(','||VV_COURT_ID||',',','||RC.PARENT_ID||',')>0 AND VV_COURT_ID IS NOT NULL) OR (VV_COURT_ID IS NULL))
                                         GROUP BY RC1.ID,RC1.COURT_NAME,RC1.PARENT_ID
                                       UNION ALL
                                          SELECT RC.PARENT_ID,RC.ID,RC.COURT_NAME FROM 
                                         --tim id tinh  
                                        PUBLIC_APP.ROOM_COURTS@DBLINK_PUBLIC_TO_SOHOA RC 
                                         WHERE RC.TYPE='T' 
                                          AND ((instr(','||VV_COURT_ID||',',','||RC.ID||',')>0 AND VV_COURT_ID IS NOT NULL) OR (VV_COURT_ID IS NULL))
                                         GROUP BY RC.ID,RC.COURT_NAME,RC.PARENT_ID
                                       )TT
                                       GROUP BY TT.PARENT_ID,TT.ID,TT.COURT_NAME
                                  UNION ALL --lay them huyen
                                         SELECT RC.PARENT_ID,RC.ID,RC.COURT_NAME FROM PUBLIC_APP.ROOM_COURTS@DBLINK_PUBLIC_TO_SOHOA RC 
                                         WHERE RC.TYPE='H' 
                                         AND ((instr(','||VV_COURT_ID||',',','||RC.PARENT_ID||',')>0 AND VV_COURT_ID IS NOT NULL) OR (VV_COURT_ID IS NULL))
                                         GROUP BY RC.ID,RC.COURT_NAME,RC.PARENT_ID
                                       )FF
                         START WITH FF.PARENT_ID = 4
                        CONNECT BY PRIOR id= FF.PARENT_ID
                        ORDER SIBLINGS BY NLSSORT (FF.COURT_NAME, 'NLS_SORT=vietnamese')
                        )CC
               )
            LOOP--don vi do vao bang ao
                V_ORDERS:=V_ORDERS+1;
                v_table.extend;
                v_table(v_table.count) := R_PUBLIC_COURT(rec.ID,rec.COURT_NAME,V_ORDERS);     
            END LOOP; 
            ELSE
            FOR rec IN
                    (
                        SELECT 4 PARENT_ID,RC.ID,'<b>'||RC.COURT_NAME ||'</b>' COURT_NAME FROM  PUBLIC_APP.ROOM_COURTS@DBLINK_PUBLIC_TO_SOHOA RC
                       WHERE RC.TYPE=VV_TYPE 
                       AND ((instr(','||VV_COURT_ID||',',','||RC.ID||',')>0 AND VV_COURT_ID IS NOT NULL) OR (VV_COURT_ID IS NULL))
                       GROUP BY RC.ID,RC.COURT_NAME,RC.PARENT_ID
                       ORDER  BY NLSSORT (RC.COURT_NAME, 'NLS_SORT=vietnamese')
                    )
            LOOP--don vi do vao bang ao
                 V_ORDERS:=V_ORDERS+1;
                v_table.extend;
                v_table(v_table.count) := R_PUBLIC_COURT(rec.ID,rec.COURT_NAME,V_ORDERS);       
            END LOOP; 
           END IF;
           ----------------------------------
           FOR item_pub IN (
                select AA.STT,AA.ID,AA.STT||'.'||AA.COURT_NAME COURT_NAME,AA.CountAll from (
                 SELECT   ROW_NUMBER() OVER (ORDER BY PA.ORDERS) STT ,COUNT(*) OVER () as CountAll,PA.ID,PA.COURT_NAME FROM  TABLE(v_table) PA
                  )AA where AA.stt>=MinIndex and AA.stt<=MaxIndex
           )
           LOOP
            VV_ORDERS:=0;
              -----------------insert tên đơn vi
                        v_table_tp.extend;
                        v_table_tp(v_table_tp.count) := R_PUBLIC_COURT_DETAIL(
                        item_pub.ID,item_pub.COURT_NAME,NULL,NULL,
                        NULL,NULL,NULL,NULL,NULL,NULL,item_pub.CountAll,NULL
                        );
             -------------------------------------        
                 FOR item_pub_staff IN (  
                       SELECT C1.ID,C1.NAME  FROM
                      (SELECT RS.ID,RS.NAME  FROM PUBLIC_APP.PUBLIC_JUDGMENT@DBLINK_PUBLIC_TO_SOHOA PJ --lay tham phan theo du lieu
                            INNER JOIN PUBLIC_APP.ROOM_STAFFS@DBLINK_PUBLIC_TO_SOHOA RS ON PJ.CREATE_USER_ID=RS.ID
                            INNER JOIN PUBLIC_APP.ROOM_COURTS@DBLINK_PUBLIC_TO_SOHOA RC ON RS.ID_COURT=RC.ID
                            WHERE  RC.ID=item_pub.ID 
                            AND RS.JOB_TITLE=4 
                            AND ((instr(','||V_TYPE||',',','||RC.TYPE||',')>0 AND V_TYPE IS NOT NULL) OR (V_TYPE IS NULL))
                            GROUP BY RS.ID,RS.NAME
                       UNION ALL--lay nhung tham phan khong nhap du lieu
                          SELECT RS1.ID,RS1.NAME FROM PUBLIC_APP.ROOM_COURTS@DBLINK_PUBLIC_TO_SOHOA RC1 
                          INNER JOIN PUBLIC_APP.ROOM_STAFFS@DBLINK_PUBLIC_TO_SOHOA RS1 ON RC1.ID=RS1.ID_COURT
                          WHERE   RC1.ID=item_pub.ID 
                          AND RS1.JOB_TITLE=4
                          AND ((instr(','||V_TYPE||',',','||RC1.TYPE||',')>0 AND V_TYPE IS NOT NULL) OR (V_TYPE IS NULL))
                           AND NOT EXISTS --nhung tham phan chua nhap du lieu
                                    (
                                      SELECT RS.ID,RS.NAME FROM PUBLIC_APP.PUBLIC_JUDGMENT@DBLINK_PUBLIC_TO_SOHOA PJ
                                      INNER JOIN PUBLIC_APP.ROOM_STAFFS@DBLINK_PUBLIC_TO_SOHOA RS ON PJ.CREATE_USER_ID=RS.ID
                                      INNER JOIN PUBLIC_APP.ROOM_COURTS@DBLINK_PUBLIC_TO_SOHOA RC ON RS.ID_COURT=RC.ID
                                      WHERE  RS.ID=RS1.ID 
                                      AND RC.ID=item_pub.ID
                                        AND ((instr(','||V_TYPE||',',','||RC.TYPE||',')>0 AND V_TYPE IS NOT NULL) OR (V_TYPE IS NULL))
                                      AND RS.JOB_TITLE=4
                                      GROUP BY RS.ID,RS.NAME--nhung tham phan da nhap du lieu
                                    )
                            )C1   INNER JOIN PUBLIC_APP.ROOM_STAFFS@DBLINK_PUBLIC_TO_SOHOA ss on ss.id=c1.id and ss.JOB_TITLE=4
                )
               LOOP
               -----------------------tinh tổng của từng thẩm phán
               SELECT COUNT(xx.ID)ID,COUNT(XX.VALUE_SLOW_DATE)VALUE_SLOW_DATE,COUNT(XX.COUNT_FILE_REP)COUNT_FILE_REP,COUNT(XX.VALUE_AN_LE)VALUE_AN_LE
               INTO COLUMN_1,COLUMN_2,COLUMN_3,COLUMN_5 from --đã công bố,công bố chậm,có đính chính,có áp dụng án lệ
                (
                 SELECT PJ.ID
                  ,DECODE(PA.NO_AN_LE,'khong','','X')VALUE_AN_LE
                  ,DECODE(PR.COUNT_FILE_REP,NULL,'','X')COUNT_FILE_REP
                  ,DECODE(PD.ID_JUDGMENT,NULL,'','X') VALUE_SLOW_DATE
                  FROM PUBLIC_APP.PUBLIC_JUDGMENT@DBLINK_PUBLIC_TO_SOHOA PJ
                   LEFT JOIN PUBLIC_APP.PUBLIC_SLOW_DATE@DBLINK_PUBLIC_TO_SOHOA PD ON PJ.ID=PD.ID_JUDGMENT
                   LEFT JOIN (SELECT COUNT(*) COUNT_FILE_REP,PA.ID_JUDGMENT FROM PUBLIC_APP.PUBLIC_REPAIR_ATTACH@DBLINK_PUBLIC_TO_SOHOA PA  GROUP BY PA.ID_JUDGMENT) PR ON PR.ID_JUDGMENT=PJ.ID
                   LEFT JOIN PUBLIC_APP.PUBLIC_AN_LE@DBLINK_PUBLIC_TO_SOHOA PA ON PJ.ID=PA.ID_JUDGMENT
                   WHERE   PJ.STATUS=1 AND PJ.CREATE_USER_ID=item_pub_staff.ID --AND PJ.COURT_ID=item_pub.ID nếu không truyền thì sẽ lấy tổng cả những đơn vị đã bị điều chuyển đi
               )XX;
                --Tổng số bản án/quyết định hạ xuống
                SELECT COUNT(PJ.ID)TONG_ INTO COLUMN_4  FROM PUBLIC_APP.PUBLIC_JUDGMENT@DBLINK_PUBLIC_TO_SOHOA PJ
                WHERE  PJ.STATUS=2 AND PJ.CREATE_USER_ID=item_pub_staff.ID;-- AND PJ.COURT_ID=item_pub.ID AND
                -----insert thẩm phán--------------------------
                  VV_ORDERS:=VV_ORDERS+1;
                v_table_tp.extend;
                v_table_tp(v_table_tp.count) := R_PUBLIC_COURT_DETAIL(
                item_pub.ID,NULL,item_pub_staff.ID,item_pub_staff.NAME,
                COLUMN_1,COLUMN_2,COLUMN_3,COLUMN_4,COLUMN_5,0,item_pub.CountAll,VV_ORDERS);--đã công bố,công bố chậm,có đính chính,hạ xuống,có áp dụng án lệ
               END LOOP;
           END LOOP;
           ----------------------------------
        OPEN v_cursor FOR
         SELECT  PA.DONVI_ID,PA.DONVI_TEN,PA.THAM_PHAN_ID,DECODE(PA.ORDERS,NULL,NULL,PA.ORDERS||'. ')||PA.THAM_PHAN_TEN THAM_PHAN_TEN,
                 PA.COLUMN_1,PA.COLUMN_2,PA.COLUMN_3,PA.COLUMN_4,PA.COLUMN_5,
                 PA.COUNTALL_COURT FROM TABLE(v_table_tp) PA;
        RETURN v_cursor;   
  END;
FUNCTION COUNT_OF_TYPE
(
  V_COURT_ID	VARCHAR2 DEFAULT NULL
 ) RETURN SYS_REFCURSOR  
 AS
          v_cursor SYS_REFCURSOR;VV_COURT_ID VARCHAR2(100);
          v_table T_COUNT_TYPE; VV_TYPE VARCHAR2(150):=NULL;
  BEGIN  
     v_table := T_COUNT_TYPE(); --dung bang dinh nghia
    ---------------------------
    IF(V_COURT_ID IS NOT NULL AND V_COURT_ID!='0') THEN
        SELECT RC.ID,RC.TYPE INTO VV_COURT_ID,VV_TYPE FROM PUBLIC_APP.ROOM_COURTS@DBLINK_PUBLIC_TO_SOHOA RC 
        WHERE RC.MADONGBO=(SELECT RC.MADONGBO FROM DM_TOAAN RC WHERE RC.ID=V_COURT_ID);
     ELSIF(V_COURT_ID='0') THEN
      VV_TYPE:=NULL;
     END IF;
            --Tổng số bản án/quyết định đã công bố
            FOR item IN (
                         SELECT XX.TYPE,XX.TYPE_NAME,COUNT(xx.ID)TONG_ FROM (
                           SELECT  PJ.ID,RC.TYPE,
                           DECODE(RC.TYPE,'TW','Tối cao','CW','Cấp cao','T','Cấp tỉnh','H','Cấp huyện')TYPE_NAME
                           FROM PUBLIC_APP.PUBLIC_JUDGMENT@DBLINK_PUBLIC_TO_SOHOA PJ
                           INNER JOIN PUBLIC_APP.ROOM_COURTS@DBLINK_PUBLIC_TO_SOHOA RC ON PJ.COURT_ID=RC.ID 
                           WHERE PJ.STATUS=1 AND                                           
                                ( (VV_TYPE ='T' AND (PJ.COURT_ID=VV_COURT_ID OR  RC.PARENT_ID=VV_COURT_ID))
                                 OR(VV_TYPE ='H' AND PJ.COURT_ID=VV_COURT_ID)
                                 OR(VV_TYPE ='CW' AND PJ.COURT_ID=VV_COURT_ID)
                                 OR(VV_TYPE ='TW' OR VV_TYPE IS NULL)
                                )
                          )XX GROUP BY XX.TYPE,XX.TYPE_NAME
                        )
              LOOP
               v_table.extend;
               v_table(v_table.count) := R_COUNT_TYPE(item.TYPE,item.TYPE_NAME,
               item.TONG_,0,0,0,0,0);
              END LOOP;     
            --Tổng số bản án/quyết định công bố chậm
            FOR item IN (
                         SELECT XX.TYPE,XX.TYPE_NAME,COUNT(xx.ID)TONG_ FROM (
                           SELECT  PJ.ID,RC.TYPE,
                           DECODE(RC.TYPE,'TW','Tối cao','CW','Cấp cao','T','Cấp tỉnh','H','Cấp huyện')TYPE_NAME
                           FROM PUBLIC_APP.PUBLIC_JUDGMENT@DBLINK_PUBLIC_TO_SOHOA PJ
                           INNER JOIN PUBLIC_APP.ROOM_COURTS@DBLINK_PUBLIC_TO_SOHOA RC ON PJ.COURT_ID=RC.ID 
                           INNER JOIN PUBLIC_APP.PUBLIC_SLOW_DATE@DBLINK_PUBLIC_TO_SOHOA PD ON PJ.ID=PD.ID_JUDGMENT
                           WHERE PJ.STATUS=1 AND                                           
                                ( (VV_TYPE ='T' AND (PJ.COURT_ID=VV_COURT_ID OR  RC.PARENT_ID=VV_COURT_ID))
                                 OR(VV_TYPE ='H' AND PJ.COURT_ID=VV_COURT_ID)
                                 OR(VV_TYPE ='CW' AND PJ.COURT_ID=VV_COURT_ID)
                                 OR(VV_TYPE ='TW' OR VV_TYPE IS NULL)
                                )
                          )XX GROUP BY XX.TYPE,XX.TYPE_NAME
                        )
              LOOP
               v_table.extend;
               v_table(v_table.count) := R_COUNT_TYPE(item.TYPE,item.TYPE_NAME,
               0,item.TONG_,0,0,0,0);
              END LOOP;      
              --Tổng số bản án/quyết định có đính chính
            FOR item IN (
                         SELECT XX.TYPE,XX.TYPE_NAME,SUM(XX.COUNT_FILE_REP)TONG_ FROM (
                           SELECT  PJ.ID,RC.TYPE,
                           DECODE(RC.TYPE,'TW','Tối cao','CW','Cấp cao','T','Cấp tỉnh','H','Cấp huyện')TYPE_NAME
                            ,DECODE(PR.COUNT_FILE_REP,NULL,0,PR.COUNT_FILE_REP)COUNT_FILE_REP
                           FROM PUBLIC_APP.PUBLIC_JUDGMENT@DBLINK_PUBLIC_TO_SOHOA PJ
                           INNER JOIN PUBLIC_APP.ROOM_COURTS@DBLINK_PUBLIC_TO_SOHOA RC ON PJ.COURT_ID=RC.ID 
                             LEFT JOIN (SELECT COUNT(*) COUNT_FILE_REP,PA.ID_JUDGMENT FROM PUBLIC_APP.PUBLIC_REPAIR_ATTACH@DBLINK_PUBLIC_TO_SOHOA PA  GROUP BY PA.ID_JUDGMENT) PR ON PR.ID_JUDGMENT=PJ.ID
                           WHERE PJ.STATUS=1 AND                                           
                                ( (VV_TYPE ='T' AND (PJ.COURT_ID=VV_COURT_ID OR  RC.PARENT_ID=VV_COURT_ID))
                                 OR(VV_TYPE ='H' AND PJ.COURT_ID=VV_COURT_ID)
                                 OR(VV_TYPE ='CW' AND PJ.COURT_ID=VV_COURT_ID)
                                 OR(VV_TYPE ='TW' OR VV_TYPE IS NULL)
                                )
                          )XX GROUP BY XX.TYPE,XX.TYPE_NAME
                        )
              LOOP
               v_table.extend;
               v_table(v_table.count) := R_COUNT_TYPE(item.TYPE,item.TYPE_NAME,
               0,0,item.TONG_,0,0,0);
              END LOOP;    
                --Tổng số bản án/quyết định hạ xuống
            FOR item IN (
                         SELECT XX.TYPE,XX.TYPE_NAME,COUNT(xx.ID)TONG_ FROM (
                           SELECT  PJ.ID,RC.TYPE,
                           DECODE(RC.TYPE,'TW','Tối cao','CW','Cấp cao','T','Cấp tỉnh','H','Cấp huyện')TYPE_NAME
                           FROM PUBLIC_APP.PUBLIC_JUDGMENT@DBLINK_PUBLIC_TO_SOHOA PJ
                           INNER JOIN PUBLIC_APP.ROOM_COURTS@DBLINK_PUBLIC_TO_SOHOA RC ON PJ.COURT_ID=RC.ID                            
                           WHERE PJ.STATUS=2 AND                                           
                                ( (VV_TYPE ='T' AND (PJ.COURT_ID=VV_COURT_ID OR  RC.PARENT_ID=VV_COURT_ID))
                                 OR(VV_TYPE ='H' AND PJ.COURT_ID=VV_COURT_ID)
                                 OR(VV_TYPE ='CW' AND PJ.COURT_ID=VV_COURT_ID)
                                 OR(VV_TYPE ='TW' OR VV_TYPE IS NULL)
                                )
                          )XX GROUP BY XX.TYPE,XX.TYPE_NAME
                        )
              LOOP
               v_table.extend;
               v_table(v_table.count) := R_COUNT_TYPE(item.TYPE,item.TYPE_NAME,
               0,0,0,item.TONG_,0,0);
              END LOOP;    
               --Tổng số bản án/quyết định có áp dụng án lệ
            FOR item IN (
                         SELECT XX.TYPE,XX.TYPE_NAME,COUNT(xx.VALUE_AN_LE)TONG_ FROM (
                           SELECT  PJ.ID,RC.TYPE,
                           DECODE(RC.TYPE,'TW','Tối cao','CW','Cấp cao','T','Cấp tỉnh','H','Cấp huyện')TYPE_NAME
                           ,DECODE(PA.NO_AN_LE,'khong','','X')VALUE_AN_LE
                           FROM PUBLIC_APP.PUBLIC_JUDGMENT@DBLINK_PUBLIC_TO_SOHOA PJ
                           INNER JOIN PUBLIC_APP.ROOM_COURTS@DBLINK_PUBLIC_TO_SOHOA RC ON PJ.COURT_ID=RC.ID 
                           INNER JOIN PUBLIC_APP.PUBLIC_AN_LE@DBLINK_PUBLIC_TO_SOHOA PA ON PJ.ID=PA.ID_JUDGMENT
                           WHERE PJ.STATUS=1 AND                                           
                                ( (VV_TYPE ='T' AND (PJ.COURT_ID=VV_COURT_ID OR  RC.PARENT_ID=VV_COURT_ID))
                                 OR(VV_TYPE ='H' AND PJ.COURT_ID=VV_COURT_ID)
                                 OR(VV_TYPE ='CW' AND PJ.COURT_ID=VV_COURT_ID)
                                 OR(VV_TYPE ='TW' OR VV_TYPE IS NULL)
                                )
                          )XX GROUP BY XX.TYPE,XX.TYPE_NAME
                        )
              LOOP
               v_table.extend;
               v_table(v_table.count) := R_COUNT_TYPE(item.TYPE,item.TYPE_NAME,
               0,0,0,0,item.TONG_,0);
              END LOOP;                 
                --Tổng số bản án/quyết định có ý kiến phản hồi
            FOR item IN (
                         SELECT XX.TYPE,XX.TYPE_NAME,SUM(XX.COUNT_PUBLIC_FEEDBACK)TONG_ FROM (
                           SELECT  PJ.ID,RC.TYPE,
                           DECODE(RC.TYPE,'TW','Tối cao','CW','Cấp cao','T','Cấp tỉnh','H','Cấp huyện')TYPE_NAME  
                           ,DECODE(PF.COUNT_PUBLIC_FEEDBACK,NULL,0,PF.COUNT_PUBLIC_FEEDBACK)COUNT_PUBLIC_FEEDBACK
                           FROM PUBLIC_APP.PUBLIC_JUDGMENT@DBLINK_PUBLIC_TO_SOHOA PJ
                           INNER JOIN PUBLIC_APP.ROOM_COURTS@DBLINK_PUBLIC_TO_SOHOA RC ON PJ.COURT_ID=RC.ID 
                           LEFT JOIN (SELECT COUNT(*) COUNT_PUBLIC_FEEDBACK,PF1.ID_JUDGMENT FROM PUBLIC_APP.PUBLIC_FEEDBACK@DBLINK_PUBLIC_TO_SOHOA PF1  GROUP BY PF1.ID_JUDGMENT) PF ON PF.ID_JUDGMENT=PJ.ID
                           WHERE PJ.STATUS=1 AND                                           
                                ( (VV_TYPE ='T' AND (PJ.COURT_ID=VV_COURT_ID OR  RC.PARENT_ID=VV_COURT_ID))
                                 OR(VV_TYPE ='H' AND PJ.COURT_ID=VV_COURT_ID)
                                 OR(VV_TYPE ='CW' AND PJ.COURT_ID=VV_COURT_ID)
                                 OR(VV_TYPE ='TW' OR VV_TYPE IS NULL)
                                )
                          )XX GROUP BY XX.TYPE,XX.TYPE_NAME
                        )
              LOOP
               v_table.extend;
               v_table(v_table.count) := R_COUNT_TYPE(item.TYPE,item.TYPE_NAME,
               0,0,0,0,0,item.TONG_);
              END LOOP;                      
        ------------------
        OPEN v_cursor FOR
            --PA.TYPE_ID,
         SELECT AA.TYPE_ID,AA.TYPE_NAME,AA.COLUMN_1,AA.COLUMN_2,AA.COLUMN_3,AA.COLUMN_4,AA.COLUMN_5,AA.COLUMN_6
              FROM (
                 SELECT X.COL_VALUE,PP.TYPE_ID,PP.TYPE_NAME,SUM(PP.COLUMN_1)COLUMN_1,SUM(PP.COLUMN_2)COLUMN_2,
                 SUM(PP.COLUMN_3)COLUMN_3,SUM(PP.COLUMN_4)COLUMN_4,SUM(PP.COLUMN_5)COLUMN_5,SUM(PP.COLUMN_6)COLUMN_6
                     FROM(SELECT PA.TYPE_ID,PA.TYPE_NAME,PA.COLUMN_1,PA.COLUMN_2,PA.COLUMN_3,PA.COLUMN_4,PA.COLUMN_5,PA.COLUMN_6 FROM  TABLE(v_table) PA)PP
                     INNER JOIN ( SELECT XX.COL_TYPE,XX.COL_VALUE FROM (SELECT 1 H,2 T,3 CW,4 TW FROM DUAL)
                                   UNPIVOT (COL_VALUE for COL_TYPE in (H, T, CW, TW) )XX --chuyển từ cột thành dòng
                                 )X ON X.COL_TYPE=PP.TYPE_ID
                GROUP BY PP.TYPE_NAME,PP.TYPE_ID,X.COL_VALUE ORDER BY X.COL_VALUE
                )AA
         UNION ALL
          SELECT NULL TYPE_ID,'Cộng' TYPE_NAME,SUM(PP.COLUMN_1)COLUMN_1,SUM(PP.COLUMN_2)COLUMN_2,
          SUM(PP.COLUMN_3)COLUMN_3,SUM(PP.COLUMN_4)COLUMN_4,SUM(PP.COLUMN_5)COLUMN_5,SUM(PP.COLUMN_6)COLUMN_6
          FROM  TABLE(v_table) PP GROUP BY NULL,'Cộng';
        RETURN v_cursor;   
 END;
FUNCTION PUBLIC_GSTP_HOME
(
 V_COURT_ID	VARCHAR2 DEFAULT NULL,--ma dong bo
 V_STAFFS  VARCHAR2 DEFAULT NULL--ma dong bo
 ) RETURN SYS_REFCURSOR  
 AS
          v_cursor SYS_REFCURSOR;VV_STAFFS VARCHAR2(100);  VV_COURT_ID VARCHAR2(100):=NULL;v_CAPTOA VARCHAR2(100);
          v_table T_PUBLIC_GSTP_HOME; V_COLUMN_4 NUMBER;V_COLUMN_6 NUMBER; V_COLUMN_10 NUMBER;V_COLUMN_12 NUMBER;
  BEGIN  
     v_table := T_PUBLIC_GSTP_HOME(); --dung bang dinh nghia
    ---------------------------
     IF(V_STAFFS IS NOT NULL) THEN
       SELECT RS.ID INTO VV_STAFFS FROM PUBLIC_APP.ROOM_STAFFS@DBLINK_PUBLIC_TO_SOHOA RS WHERE RS.MADONGBO=(SELECT RS.MADONGBO FROM DM_CANBO RS WHERE RS.ID=V_STAFFS);
     END IF;
         IF(V_COURT_ID IS NOT NULL AND V_COURT_ID!='0') THEN
                SELECT RC.ID INTO VV_COURT_ID FROM PUBLIC_APP.ROOM_COURTS@DBLINK_PUBLIC_TO_SOHOA RC WHERE RC.MADONGBO=(SELECT RC.MADONGBO FROM DM_TOAAN RC WHERE RC.ID=V_COURT_ID);
                SELECT LOAITOA INTO v_CAPTOA FROM DM_TOAAN WHERE ID=V_COURT_ID;
                IF(v_CAPTOA='TOICAO') THEN
                 VV_COURT_ID:=NULL;
                END IF;
        ELSIF(V_COURT_ID='0') THEN 
          VV_COURT_ID:=NULL;          
     END IF;
     ------------
     FOR i IN 0..1 --0 là năm hiện tại, 1 là năm trước
          LOOP
              FOR item IN (   
                        SELECT COUNT(xx.CASES_NAME)TONG_CB,COUNT(XX.VALUE_SLOW_DATE)CB_CHAM,COUNT(XX.COUNT_FILE_REP)DINH_CHINH
                        from
                        (
                          SELECT PJ.ID,PJ.NUMBER_JUDGMENT,TO_CHAR(PJ.DAY_JUDGMENT, 'dd/MM/yyyy') DAY_JUDGMENT
                          ,DECODE(PR.COUNT_FILE_REP,NULL,'','X')COUNT_FILE_REP
                          ,DECODE(PD.ID_JUDGMENT,NULL,'','X') VALUE_SLOW_DATE
                          ,PJ.SUMMARY_CONTENT,DECODE(PJ.STATUS_JUDGMENT,0,'Bản án',1,'Quyết định') NAME_STATUS_JUDGMENT
                          ,DECODE(PJ.CASES_STYLES,50,DECODE(PJ.DELICT,0,'phạm tội',1,'Bị truy tố tội ',2,'không phạm tội')||SUBSTR(TRIM(' ' FROM CR.CRIMINAL_NAME),4),CA.CASE_NAME)CASES_NAME
                          FROM PUBLIC_APP.PUBLIC_JUDGMENT@DBLINK_PUBLIC_TO_SOHOA PJ
                           INNER JOIN PUBLIC_APP.ROOM_STAFFS@DBLINK_PUBLIC_TO_SOHOA RS ON PJ.CREATE_USER_ID=RS.ID
                           INNER JOIN PUBLIC_APP.ROOM_COURTS@DBLINK_PUBLIC_TO_SOHOA RC ON RS.ID_COURT=RC.ID
                           LEFT JOIN PUBLIC_APP.TC_CASES@DBLINK_PUBLIC_TO_SOHOA CA ON CA.ID=PJ.CASES_ID
                           LEFT JOIN PUBLIC_APP.TC_CRIMINALS@DBLINK_PUBLIC_TO_SOHOA CR ON CR.ID=PJ.CASES_ID
                           LEFT JOIN PUBLIC_APP.PUBLIC_SLOW_DATE@DBLINK_PUBLIC_TO_SOHOA PD ON PJ.ID=PD.ID_JUDGMENT
                           LEFT JOIN (SELECT COUNT(*) COUNT_FILE_REP,PA.ID_JUDGMENT FROM PUBLIC_APP.PUBLIC_REPAIR_ATTACH@DBLINK_PUBLIC_TO_SOHOA PA  GROUP BY PA.ID_JUDGMENT) PR ON PR.ID_JUDGMENT=PJ.ID
                           WHERE  ( (RS.ID=VV_STAFFS AND V_STAFFS IS NOT NULL) OR (V_STAFFS IS NULL))
                           AND ((PJ.COURT_ID=VV_COURT_ID AND VV_COURT_ID IS NOT NULL) OR VV_COURT_ID IS NULL)
                           AND(  (i=0 and (PJ.DATE_PUBLIC>=to_date('01/01/'||to_char(sysdate, 'YYYY')||'00:00:00','dd/MM/yyyy hh24:mi:ss') and PJ.DATE_PUBLIC<=to_date('31/12/'||to_char(sysdate, 'YYYY')||'23:59:59','dd/MM/yyyy hh24:mi:ss')  ) )
                                OR (i=1 and (PJ.DATE_PUBLIC>=to_date('01/01/'||(to_char(sysdate, 'YYYY')-1)||'00:00:00','dd/MM/yyyy hh24:mi:ss') and PJ.DATE_PUBLIC<=to_date('31/12/'||(to_char(sysdate, 'YYYY')-1)||'23:59:59','dd/MM/yyyy hh24:mi:ss')  ) )
                              )
                           AND PJ.STATUS=1 --đã công bố
                       )XX
               )
               LOOP
              IF(i=0)THEN
                  v_table.extend;
                  v_table(v_table.count) := R_PUBLIC_GSTP_HOME(i,
                  item.TONG_CB,0,item.CB_CHAM,0,item.DINH_CHINH,0,
                  0,0,0,0,0,0);
                ELSE
                 v_table.extend;
                 v_table(v_table.count) := R_PUBLIC_GSTP_HOME(i,
                  0,0,0,0,0,0,
                  item.TONG_CB,0,item.CB_CHAM,0,item.DINH_CHINH,0);
                END IF;
               END LOOP;
    END LOOP;       
        ------------------
        OPEN v_cursor FOR
         SELECT rtrim(to_char(P.COLUMN_1, 'FM9G999G999D999', 'NLS_NUMERIC_CHARACTERS='',.'''),',')COLUMN_1,P.COLUMN_2,rtrim(to_char(P.COLUMN_3, 'FM9G999G999D999', 'NLS_NUMERIC_CHARACTERS='',.'''),',')COLUMN_3,
            DECODE(P.COLUMN_1,0,0,ROUND((P.COLUMN_3/P.COLUMN_1)*100,1))COLUMN_4,
            rtrim(to_char(P.COLUMN_5, 'FM9G999G999D999', 'NLS_NUMERIC_CHARACTERS='',.'''),',')COLUMN_5,
            DECODE(P.COLUMN_1,0,0,ROUND((P.COLUMN_5/P.COLUMN_1)*100,1))COLUMN_6,
            rtrim(to_char(P.COLUMN_7, 'FM9G999G999D999', 'NLS_NUMERIC_CHARACTERS='',.'''),',')COLUMN_7,P.COLUMN_8,rtrim(to_char(P.COLUMN_9, 'FM9G999G999D999', 'NLS_NUMERIC_CHARACTERS='',.'''),',')COLUMN_9,
            DECODE(P.COLUMN_7,0,0,ROUND((P.COLUMN_9/P.COLUMN_7)*100,1))COLUMN_10,
            rtrim(to_char(P.COLUMN_11, 'FM9G999G999D999', 'NLS_NUMERIC_CHARACTERS='',.'''),',')COLUMN_11,
            DECODE(P.COLUMN_7,0,0,ROUND((P.COLUMN_11/P.COLUMN_7)*100,1))COLUMN_12 
            FROM (
            SELECT SUM(PA.COLUMN_1)COLUMN_1,SUM(PA.COLUMN_2)COLUMN_2,SUM(PA.COLUMN_3)COLUMN_3,SUM(PA.COLUMN_4)COLUMN_4,SUM(PA.COLUMN_5)COLUMN_5,SUM(PA.COLUMN_6)COLUMN_6,
                   SUM(PA.COLUMN_7)COLUMN_7,SUM(PA.COLUMN_8)COLUMN_8,SUM(PA.COLUMN_9)COLUMN_9,SUM(PA.COLUMN_10)COLUMN_10,SUM(PA.COLUMN_11)COLUMN_11,SUM(PA.COLUMN_12)COLUMN_12
            FROM TABLE(v_table) PA
           )P ;
        RETURN v_cursor;   
 END;
 FUNCTION PUBLIC_JUDGE_COUNT_FOUR
( 
  VV_STAFFS  VARCHAR2 DEFAULT NULL,
  V_DATE_FROM VARCHAR2 DEFAULT NULL, 
  V_DATE_TO VARCHAR2 DEFAULT NULL
 ) RETURN SYS_REFCURSOR  
  AS
          v_cursor SYS_REFCURSOR;   
          V_EXPORT_TEXT CLOB;  
          -----
          VV_DATE_FROM VARCHAR2(50); VV_DATE_TO VARCHAR2(50);V_STAFFS VARCHAR2(150):=NULL;V_STAFFS_TEMP VARCHAR2(150):=NULL;
          V_I NUMBER:=0;V_I1 NUMBER:=0; VV_TYPE NVARCHAR2(100);COUNT_STAFF NUMBER;
  BEGIN  
          -----------------------
          DBMS_LOB.createtemporary(V_EXPORT_TEXT,TRUE);
          ------
          SELECT DECODE(V_DATE_FROM,NULL,'01/07/2017',V_DATE_FROM) INTO VV_DATE_FROM FROM DUAL;
          SELECT DECODE(V_DATE_TO,NULL,' ... ',V_DATE_TO) INTO VV_DATE_TO FROM DUAL;
          SELECT COUNT(*) INTO COUNT_STAFF FROM PUBLIC_APP.ROOM_STAFFS@DBLINK_PUBLIC_TO_SOHOA RS WHERE RS.MADONGBO=(SELECT CB.MADONGBO FROM DM_CANBO CB WHERE CB.ID=VV_STAFFS);
          -----
          DBMS_LOB.APPEND(V_EXPORT_TEXT,'
               <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 10pt; border:0px;"  border-collapse: collapse;>
                <tr>
                    <th colspan="2" style="text-align: center; vertical-align: middle; font-size: 10pt; padding: unset;"></th>
                    <th colspan="5" style="text-align: center; vertical-align: bottom; font-size: 10pt; padding: unset;"></th>
                    <th colspan="2" style="text-align: center; vertical-align: middle; font-size: 10pt; padding: unset;"></th>
                </tr>
                <tr>
                    <td colspan="2" style="vertical-align: middle; text-align: center; font-size: 9pt;"><b></b></td>
                    <td colspan="5" style="text-align: center; vertical-align: bottom; font-size: 14px; padding: unset;font-style:italic">Từ ngày ' ||VV_DATE_FROM||' đến ngày '||to_char(sysdate,'dd/MM/yyyy')||'</td>
                    <td colspan="2" rowspan="2" style="text-align: center; vertical-align: middle; font-size: 9pt;"></td>
                </tr>
                <tr>
                    <td colspan="2" style="text-align: center; vertical-align: middle; font-size: 10pt; font-weight: bold; height: 20px;"></td>
                    <td colspan="5" style="text-align: center; vertical-align: bottom; font-size: 11pt; font-style: italic;"></td>
                </tr>
                <tr>
                    <th rowspan="2" style="border: 1px  solid Black; vertical-align: middle; text-align: center;">STT</th>
                    <th rowspan="2" colspan="1" style="border: 1px  solid Black; font-size: 10pt; vertical-align: middle; text-align: center;padding:5px;">LOẠI VỤ VIỆC</th>
                    <th rowspan="2" style="border: 1px  solid Black; font-size: 10pt; vertical-align: middle; text-align: center;padding:5px;">SỐ, NGÀY BẢN ÁN, QUYẾT ĐỊNH</th>
                    <th rowspan="2" style="border: 1px  solid Black; font-size: 10pt; vertical-align: middle; text-align: center;padding:5px;">TỘI DANH/QHPL/BIỆN PHÁP XỬ LÝ HÀNH CHÍNH</th>
                    <th colspan="5" style="border: 1px  solid Black; vertical-align: middle; text-align: center; height: 30px;padding:5px;">GHI CHÚ</th>
                </tr>
                <tr>
                    <th style="border: 1px  solid Black;vertical-align: middle; text-align: center; height: 60px;padding:5px;">Công bố chậm</th>
                    <th style="border: 1px  solid Black;vertical-align: middle; text-align: center;padding:5px;">Có đính chính</th>
                    <th style="border: 1px  solid Black;vertical-align: middle; text-align: center;padding:5px;">Đã gỡ xuống</th>
                     <th style="border: 1px  solid Black; vertical-align: middle; text-align: center;padding:5px;">Có áp dụng án lệ</th>
                    <th style="border: 1px  solid Black; vertical-align: middle; text-align: center;padding:5px;">Số ý kiến phản hồi</th>
                </tr>
             ');
         IF(COUNT_STAFF>0) THEN
           SELECT RS.ID INTO V_STAFFS FROM PUBLIC_APP.ROOM_STAFFS@DBLINK_PUBLIC_TO_SOHOA RS WHERE RS.MADONGBO=(SELECT CB.MADONGBO FROM DM_CANBO CB WHERE CB.ID=VV_STAFFS);
             --Tổng cộng
               FOR item_pub_count IN(
                          SELECT COUNT(xx.CASES_NAME)CASES_NAME,COUNT(XX.VALUE_SLOW_DATE)VALUE_SLOW_DATE,COUNT(XX.COUNT_FILE_REP)COUNT_FILE_REP,COUNT(XX.STATUS)STATUS,COUNT(XX.VALUE_AN_LE)VALUE_AN_LE
                          ,SUM(XX.COUNT_PUBLIC_FEEDBACK)COUNT_PUBLIC_FEEDBACK from
                            (
                             SELECT PJ.ID,PJ.NUMBER_JUDGMENT,TO_CHAR(PJ.DAY_JUDGMENT, 'dd/MM/yyyy') DAY_JUDGMENT
                              ,DECODE(PF.COUNT_PUBLIC_FEEDBACK,NULL,0,PF.COUNT_PUBLIC_FEEDBACK)COUNT_PUBLIC_FEEDBACK
                              ,DECODE(PA.NO_AN_LE,'khong','','X')VALUE_AN_LE
                              ,DECODE(PJ.STATUS,2,'X','')STATUS
                              ,DECODE(PR.COUNT_FILE_REP,NULL,'','X')COUNT_FILE_REP
                              ,DECODE(PD.ID_JUDGMENT,NULL,'','X') VALUE_SLOW_DATE
                              ,PJ.SUMMARY_CONTENT,DECODE(PJ.STATUS_JUDGMENT,0,'Bản án',1,'Quyết định') NAME_STATUS_JUDGMENT
                              ,DECODE(PJ.CASES_STYLES,50,DECODE(PJ.DELICT,0,'phạm tội',1,'Bị truy tố tội ',2,'không phạm tội')||SUBSTR(TRIM(' ' FROM CR.CRIMINAL_NAME),4),CA.CASE_NAME)CASES_NAME
                              FROM PUBLIC_APP.PUBLIC_JUDGMENT@DBLINK_PUBLIC_TO_SOHOA PJ
                               INNER JOIN PUBLIC_APP.ROOM_STAFFS@DBLINK_PUBLIC_TO_SOHOA RS ON PJ.CREATE_USER_ID=RS.ID
                               INNER JOIN PUBLIC_APP.ROOM_COURTS@DBLINK_PUBLIC_TO_SOHOA RC ON RS.ID_COURT=RC.ID
                               LEFT JOIN PUBLIC_APP.TC_CASES@DBLINK_PUBLIC_TO_SOHOA CA ON CA.ID=PJ.CASES_ID
                               LEFT JOIN PUBLIC_APP.TC_CRIMINALS@DBLINK_PUBLIC_TO_SOHOA CR ON CR.ID=PJ.CASES_ID
                               LEFT JOIN PUBLIC_APP.PUBLIC_SLOW_DATE@DBLINK_PUBLIC_TO_SOHOA PD ON PJ.ID=PD.ID_JUDGMENT
                               LEFT JOIN (SELECT COUNT(*) COUNT_FILE_REP,PA.ID_JUDGMENT FROM PUBLIC_APP.PUBLIC_REPAIR_ATTACH@DBLINK_PUBLIC_TO_SOHOA PA  GROUP BY PA.ID_JUDGMENT) PR ON PR.ID_JUDGMENT=PJ.ID
                               LEFT JOIN PUBLIC_APP.PUBLIC_AN_LE@DBLINK_PUBLIC_TO_SOHOA PA ON PJ.ID=PA.ID_JUDGMENT
                               LEFT JOIN (SELECT COUNT(*) COUNT_PUBLIC_FEEDBACK,PF1.ID_JUDGMENT FROM PUBLIC_APP.PUBLIC_FEEDBACK@DBLINK_PUBLIC_TO_SOHOA PF1  GROUP BY PF1.ID_JUDGMENT) PF ON PF.ID_JUDGMENT=PJ.ID
                               WHERE  RS.ID=V_STAFFS
                               --AND ((RC.TYPE=V_TYPE AND V_TYPE IS NOT NULL) OR V_TYPE IS NULL)
                               --AND ((PJ.COURT_ID=V_COURT_ID AND V_COURT_ID IS NOT NULL) OR V_COURT_ID IS NULL)
                              AND (((PJ.DATE_PUBLIC> TO_DATE(V_DATE_FROM ||'23:59:59', 'dd/MM/yyyy hh24:mi:ss')-1 AND V_DATE_FROM IS NOT NULL) OR V_DATE_FROM IS NULL) AND ((PJ.DATE_PUBLIC < TO_DATE(V_DATE_TO ||'00:00:00', 'dd/MM/yyyy  hh24:mi:ss')+1 AND V_DATE_TO IS NOT NULL) OR V_DATE_TO IS NULL))
                           )XX
                      )
                      LOOP
                       DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                      <tr style="background-color: #f4c27d; font-weight: bold;">
                            <td colspan="2" style="border: 1px  solid Black; vertical-align: middle; font-size: 12px; text-align: left;height:25px;">TỔNG CỘNG</td>               
                            <td style="border: 1px  solid Black; vertical-align: middle;text-align:center;">'||item_pub_count.CASES_NAME||' (bản án, quyết định)</td>
                            <td style="border: 1px  solid Black; vertical-align: middle;text-align:center;"></td>
                            <td style="border: 1px  solid Black; vertical-align: middle;text-align:center;">'||item_pub_count.VALUE_SLOW_DATE||'</td>
                            <td style="border: 1px  solid Black; vertical-align: middle;text-align:center;">'||item_pub_count.COUNT_FILE_REP||'</td>
                            <td style="border: 1px  solid Black; vertical-align: middle;text-align:center;">'||item_pub_count.STATUS||'</td>
                            <td style="border: 1px  solid Black; vertical-align: middle;text-align:center;">'||item_pub_count.VALUE_AN_LE||'</td>
                            <td style="border: 1px  solid Black; vertical-align: middle;text-align:center;">'||item_pub_count.COUNT_PUBLIC_FEEDBACK||'</td>
                        </tr>');
                END LOOP;
             --------truyen tham so tham phan lay cac noi dung chi tiet cua tham phan
                        FOR item_pub IN(
                         SELECT TC.ID,TC.NAME_SORT,TC.NAME FROM PUBLIC_APP.TYPE_CASE@DBLINK_PUBLIC_TO_SOHOA TC
                                      INNER JOIN PUBLIC_APP.PUBLIC_JUDGMENT@DBLINK_PUBLIC_TO_SOHOA PJ ON PJ.CASES_STYLES=TC.ID
                                      INNER JOIN PUBLIC_APP.ROOM_STAFFS@DBLINK_PUBLIC_TO_SOHOA RS ON PJ.CREATE_USER_ID=RS.ID
                                      INNER JOIN PUBLIC_APP.ROOM_COURTS@DBLINK_PUBLIC_TO_SOHOA RC ON RS.ID_COURT=RC.ID
                                      WHERE TC.ENABLE=1
                                       AND instr(','||V_STAFFS||',',','||RS.ID||',')>0
                                     -- AND ((RC.TYPE=V_TYPE AND V_TYPE IS NOT NULL) OR V_TYPE IS NULL)
                                     -- AND ((PJ.COURT_ID=V_COURT_ID AND V_COURT_ID IS NOT NULL) OR V_COURT_ID IS NULL)
                                      AND (((PJ.DATE_PUBLIC> TO_DATE(V_DATE_FROM ||'23:59:59', 'dd/MM/yyyy hh24:mi:ss')-1 AND V_DATE_FROM IS NOT NULL) OR V_DATE_FROM IS NULL) AND ((PJ.DATE_PUBLIC < TO_DATE(V_DATE_TO ||'00:00:00', 'dd/MM/yyyy  hh24:mi:ss')+1 AND V_DATE_TO IS NOT NULL) OR V_DATE_TO IS NULL))
                                      GROUP BY TC.ID,TC.NAME_SORT,TC.NAME,TC.ORDERS
                                      ORDER BY TC.ORDERS
                        )
                         LOOP  
                          V_I:=V_I+1;
                            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                             <tr style="background-color: #f2f7d4;">
                                  <td style="border: 1px solid Black; vertical-align: middle; text-align: center;font-size: 14px">'||V_I||'</td>
                                  <td colspan="1" style="border: 1px  solid Black; text-align: left; font-size: 14px; padding:5px">'||item_pub.NAME||'</td>
                                  <td style="border: 1px  solid Black;"></td>
                                  <td style="border: 1px  solid Black;"></td>
                                  <td style="border: 1px  solid Black;"></td>
                                  <td style="border: 1px  solid Black;"></td>
                                  <td style="border: 1px  solid Black;"></td>
                                  <td style="border: 1px  solid Black;"></td>
                                  <td style="border: 1px  solid Black;"></td>
                              </tr>
                            ');
                             V_I1:=0;
                          FOR item_pub_staff IN(
                              SELECT 
                              PJ.ID,PJ.NUMBER_JUDGMENT,TO_CHAR(PJ.DAY_JUDGMENT, 'dd/MM/yyyy') DAY_JUDGMENT
                              ,DECODE(PF.COUNT_PUBLIC_FEEDBACK,NULL,0,PF.COUNT_PUBLIC_FEEDBACK)COUNT_PUBLIC_FEEDBACK
                              ,DECODE(PA.NO_AN_LE,'khong','','X')VALUE_AN_LE
                              ,DECODE(PJ.STATUS,2,'X','')STATUS
                              ,DECODE(PR.COUNT_FILE_REP,NULL,'','X')COUNT_FILE_REP
                              ,DECODE(PD.ID_JUDGMENT,NULL,'','X') VALUE_SLOW_DATE
                              ,PJ.SUMMARY_CONTENT,DECODE(PJ.STATUS_JUDGMENT,0,'Bản án',1,'Quyết định') NAME_STATUS_JUDGMENT
                              ,DECODE(PJ.CASES_STYLES,50,DECODE(PJ.DELICT,0,'phạm tội',1,'Bị truy tố tội ',2,'không phạm tội')||SUBSTR(TRIM(' ' FROM CR.CRIMINAL_NAME),4),CA.CASE_NAME)CASES_NAME
                               FROM PUBLIC_APP.PUBLIC_JUDGMENT@DBLINK_PUBLIC_TO_SOHOA PJ
                               INNER JOIN PUBLIC_APP.ROOM_STAFFS@DBLINK_PUBLIC_TO_SOHOA RS ON PJ.CREATE_USER_ID=RS.ID
                               INNER JOIN PUBLIC_APP.ROOM_COURTS@DBLINK_PUBLIC_TO_SOHOA RC ON RS.ID_COURT=RC.ID
                               LEFT JOIN PUBLIC_APP.TC_CASES@DBLINK_PUBLIC_TO_SOHOA CA ON CA.ID=PJ.CASES_ID
                               LEFT JOIN PUBLIC_APP.TC_CRIMINALS@DBLINK_PUBLIC_TO_SOHOA CR ON CR.ID=PJ.CASES_ID
                               LEFT JOIN PUBLIC_APP.PUBLIC_SLOW_DATE@DBLINK_PUBLIC_TO_SOHOA PD ON PJ.ID=PD.ID_JUDGMENT
                               LEFT JOIN (SELECT COUNT(*) COUNT_FILE_REP,PA.ID_JUDGMENT FROM PUBLIC_APP.PUBLIC_REPAIR_ATTACH@DBLINK_PUBLIC_TO_SOHOA PA  GROUP BY PA.ID_JUDGMENT) PR ON PR.ID_JUDGMENT=PJ.ID
                               LEFT JOIN PUBLIC_APP.PUBLIC_AN_LE@DBLINK_PUBLIC_TO_SOHOA PA ON PJ.ID=PA.ID_JUDGMENT
                               LEFT JOIN (SELECT COUNT(*) COUNT_PUBLIC_FEEDBACK,PF1.ID_JUDGMENT FROM PUBLIC_APP.PUBLIC_FEEDBACK@DBLINK_PUBLIC_TO_SOHOA PF1  GROUP BY PF1.ID_JUDGMENT) PF ON PF.ID_JUDGMENT=PJ.ID
                               WHERE PJ.CASES_STYLES=item_pub.ID AND instr(','||V_STAFFS||',',','||RS.ID||',')>0
                               --AND ((RC.TYPE=V_TYPE AND V_TYPE IS NOT NULL) OR V_TYPE IS NULL)
                               -- AND ((PJ.COURT_ID=V_COURT_ID AND V_COURT_ID IS NOT NULL) OR V_COURT_ID IS NULL)
                              AND (((PJ.DATE_PUBLIC> TO_DATE(V_DATE_FROM ||'23:59:59', 'dd/MM/yyyy hh24:mi:ss')-1 AND V_DATE_FROM IS NOT NULL) OR V_DATE_FROM IS NULL) AND ((PJ.DATE_PUBLIC < TO_DATE(V_DATE_TO ||'00:00:00', 'dd/MM/yyyy  hh24:mi:ss')+1 AND V_DATE_TO IS NOT NULL) OR V_DATE_TO IS NULL))
                           )
                           LOOP
                             V_I1:=V_I1+1;
                              DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                             <tr>
                                  <td style="border: 1px  solid Black; vertical-align: middle; text-align: center;"></td>
                                  <td colspan="1" style="border: 1px  solid Black; text-align: left;font-size: 14px; padding-left:5px">'||V_I1||'</td>
                                  <td style="border: 1px  solid Black;padding:5px;"><a target="_blank" style="color:#b90c0c;font-weight:bold;" href="http://congbobanan.toaan.gov.vn/2ta'||item_pub_staff.ID||'t1cvn/chi-tiet-ban-an">'||item_pub_staff.NAME_STATUS_JUDGMENT||' Số: '||item_pub_staff.NUMBER_JUDGMENT||', Ngày: '||item_pub_staff.DAY_JUDGMENT||'</a></td>
                                  <td style="border: 1px  solid Black; padding:5px;">'||item_pub_staff.CASES_NAME||'</td>
                                  <td style="border: 1px  solid Black;text-align:center; padding:5px">'||item_pub_staff.VALUE_SLOW_DATE||'</td>
                                  <td style="border: 1px  solid Black;text-align:center; padding:5px">'||item_pub_staff.COUNT_FILE_REP||'</td>
                                  <td style="border: 1px  solid Black;text-align:center; padding:5px">'||item_pub_staff.STATUS||'</td>
                                  <td style="border: 1px  solid Black;text-align:center; padding:5px">'||item_pub_staff.VALUE_AN_LE||'</td>
                                  <td style="border: 1px  solid Black;text-align:center; padding:5px">'||item_pub_staff.COUNT_PUBLIC_FEEDBACK||'</td>
                              </tr>
                            ');
                           END LOOP;                            
                      END LOOP; 
            END IF;
              ---------

                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                  <tr style="height: 0px;">
                      <td style="width: 40px"></td>
                      <td style="width: 200px"></td>
                      <td style="width: 250px"></td>
                      <td style="width: 250px"></td>
                      <td style="width: 80px"></td>
                      <td style="width: 80px"></td>
                      <td style="width: 80px"></td>
                      <td style="width: 80px"></td>
                      <td style="width: 80px"></td>
                  </tr>
            </table>
                      ');   
          -------
        OPEN v_cursor FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN v_cursor;   
 END;
END PKG_GET_PUBLIC_APP;

/
