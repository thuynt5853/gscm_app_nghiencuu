--------------------------------------------------------
--  DDL for Package Body PKG_STPT_APP
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_STPT_APP" AS
PROCEDURE CANHBAO_TDC_THOIHAN
(
    V_CAPXX in varchar2,
    V_TOAAN_ID in varchar2,
    curReturn OUT sys_refcursor
)
AS
      type NumberVarray is varray(11) of NUMERIC(20);
      bc_array NumberVarray;
      v_table T_TDC_THOIHAN_GQ; V_COUNTS NUMBER;V_TEN_BC VARCHAR2(500);
BEGIN	
        v_table := T_TDC_THOIHAN_GQ();
       IF(V_CAPXX IS NULL)THEN
          bc_array := NumberVarray(1,2,3,4,5,6,7,8,9,10,11);
        ELSIF(V_CAPXX='2')THEN
          bc_array := NumberVarray(1,2,3,4,5,6,7,8,9,10,11);
        ELSIF(V_CAPXX='3')THEN
          bc_array := NumberVarray(1,2,3,4,5,6,7,8);
       END IF;
        -- bc_array(1) = 2; gán giá trị trong mảng
     FOR item_bc IN bc_array.first..bc_array.last
     LOOP
         CASE item_bc
                WHEN 1 THEN V_TEN_BC:='Án chưa giải quyết xong';
                WHEN 2 THEN V_TEN_BC:='Án quá hạn (chưa giải quyết xong)';   
                WHEN 3 THEN V_TEN_BC:='Án còn thời hạn giải quyết dưới 20 ngày';   
                WHEN 4 THEN V_TEN_BC:='Số vụ án đang tạm đình chỉ';
                WHEN 5 THEN V_TEN_BC:='Án chờ thụ lý';
                WHEN 6 THEN V_TEN_BC:='Án đã thụ lý chưa phân công Thẩm phán'; 
                WHEN 7 THEN V_TEN_BC:='Án đã lên lịch xét xử trong tháng';
                WHEN 8 THEN V_TEN_BC:='Án đã giải quyết xong trong tháng';
                WHEN 9 THEN V_TEN_BC:='Đơn chưa giải quyết';
                WHEN 10 THEN V_TEN_BC:='Đơn quá hạn chưa giải quyết';
                WHEN 11 THEN V_TEN_BC:='Đơn chưa phân công TP giải quyết'; 
         END CASE;
         -----hinhsu-------
        SELECT COUNT(*) INTO V_COUNTS FROM  AHS_VUAN A
        INNER JOIN AHS_VUAN_GIAIDOAN GD ON A.ID=GD.VUANID
        -- LEFT JOIN DM_TOAAN B ON A.TOAANID = B.ID
        WHERE    (GD.TOAANID =v_toaan_id  OR GD.TOAPHUCTHAMID=v_toaan_id)  
        AND (V_CAPXX IS NULL OR (GD.MAGIAIDOAN=V_CAPXX AND V_CAPXX IS NOT NULL) )
        AND(  
            (item_bc=1 --Án chưa giải quyết xong              
             AND ( EXISTS (
                                SELECT 'X' FROM  AHS_SOTHAM_THULY TL
                                 WHERE
                                 (NOT EXISTS ( SELECT 'X' FROM AHS_SOTHAM_BANAN BA WHERE BA.VUANID= TL.VUANID)
                                  AND NOT EXISTS ( SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN T1 
                                                INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                WHERE INSTR(',DC,CVA,',','||T2.MA||',')>0 AND TL.VUANID =T1.VUANID )
                                  )
                                 AND TL.VUANID=a.id  AND GD.MAGIAIDOAN=2
                               )
                        OR  EXISTS (
                                SELECT 'X' FROM AHS_PHUCTHAM_THULY PTTL 
                                WHERE 
                                (NOT EXISTS ( SELECT 'X' FROM AHS_PHUCTHAM_BANAN BA WHERE BA.VUANID= PTTL.VUANID)
                                  AND NOT EXISTS ( SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN T1 
                                                INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                WHERE INSTR(',DC,CVA,',','||T2.MA||',')>0 AND PTTL.VUANID =T1.VUANID )
                                  )                                
                                 AND PTTL.VUANID=a.id  AND GD.MAGIAIDOAN=3
                                )
                       )
            )
        OR(item_bc=2 --Án quá hạn (chưa giải quyết xong)
                      AND(
                           --dùng ngày bản án hoặc dùng ngày hiện tại và chưa có quyết định gây kết thúc vụ án
                            EXISTS( SELECT 'X' FROM  AHS_VUAN VA
                                    INNER JOIN AHS_SOTHAM_THULY TL ON VA.ID=TL.VUANID 
                                    LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QSV ON VA.ID=QSV.VUANID 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.VUANID =TL.VUANID
                                    WHERE
                                    (
                                        ( BA.ID IS NOT NULL
                                           AND (   ( (BA.NGAYBANAN-TL.NGAYTHULY)>45 AND VA.LOAITOIPHAMID=89 )
                                                    OR ( (BA.NGAYBANAN-TL.NGAYTHULY)>60 AND VA.LOAITOIPHAMID=90)
                                                    OR ( (BA.NGAYBANAN-TL.NGAYTHULY)>90 AND VA.LOAITOIPHAMID=91)
                                                    OR ( (BA.NGAYBANAN-TL.NGAYTHULY)>120 AND VA.LOAITOIPHAMID=92)
                                                  )
                                        )
                                        OR( (BA.ID IS NULL AND instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0)
                                          AND (        ( (SYSDATE-TL.NGAYTHULY)>45 AND VA.LOAITOIPHAMID=89 )
                                                    OR ( (SYSDATE-TL.NGAYTHULY)>60 AND VA.LOAITOIPHAMID=90)
                                                    OR ( (SYSDATE-TL.NGAYTHULY)>90 AND VA.LOAITOIPHAMID=91)
                                                    OR ( (SYSDATE-TL.NGAYTHULY)>120 AND VA.LOAITOIPHAMID=92)
                                             )
                                         )
                                    )
                                    --AND TL.ID IS NOT NULL 
                                    AND VA.ID =a.id AND GD.MAGIAIDOAN=2
                                  )
                             --dùng ngày quyết định đình chỉ vụ án     
                            OR  EXISTS (
                                        SELECT 'X' FROM  AHS_VUAN VA
                                        INNER JOIN AHS_SOTHAM_THULY TL ON VA.ID=TL.VUANID 
                                        LEFT JOIN AHS_SOTHAM_CAOTRANG_DIEULUAT CT ON VA.ID=CT.VUANID
                                        LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QSV ON VA.ID=QSV.VUANID 
                                        LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                        LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE 
                                     (
                                       (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')>0--'CVA' QĐ chuyển vụ án,'HPT' Hoãn phiên tòa, 'GHTHXX' QĐ gia hạn thời hạn chuẩn bị xét xử
                                        AND  (   ( (QSV.NGAYQD-TL.NGAYTHULY)>45 AND VA.LOAITOIPHAMID=89  )
                                                OR ( (QSV.NGAYQD-TL.NGAYTHULY)>60 AND VA.LOAITOIPHAMID=90)
                                                OR ( (QSV.NGAYQD-TL.NGAYTHULY)>90 AND VA.LOAITOIPHAMID=91)
                                                OR ( (QSV.NGAYQD-TL.NGAYTHULY)>120 AND VA.LOAITOIPHAMID=92)
                                          )
                                       )
                                       OR
                                        (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0
                                      AND  (   ( (SYSDATE-TL.NGAYTHULY)>45 AND VA.LOAITOIPHAMID=89 )
                                            OR ( (SYSDATE-TL.NGAYTHULY)>60 AND VA.LOAITOIPHAMID=90)
                                            OR ( (SYSDATE-TL.NGAYTHULY)>90 AND VA.LOAITOIPHAMID=91)
                                            OR ( (SYSDATE-TL.NGAYTHULY)>120 AND VA.LOAITOIPHAMID=92)
                                         )
                                       )
                                    )
                                  --AND TL.ID IS NOT NULL 
                                  AND VA.ID=a.id AND GD.MAGIAIDOAN=2
                                 )
                              --dùng ngày bản án phúc thẩm hoặc dùng ngày hiện tại và chưa có quyết định gây kết thúc vụ án   
                            OR EXISTS (
                                    SELECT 'X' FROM  AHS_VUAN VA
                                    INNER JOIN AHS_PHUCTHAM_THULY TL ON TL.VUANID=VA.ID 
                                    LEFT JOIN AHS_PHUCTHAM_BANAN PTBA ON PTBA.VUANID=TL.VUANID 
                                    LEFT JOIN AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA ON PTQDVA.VUANID=TL.VUANID 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE 
                                     (
                                        (PTBA.ID IS NOT NULL  AND  (PTBA.NGAYBANAN-TL.NGAYTHULY)>90 )
                                     OR (PTBA.ID IS  NULL AND instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0  AND  (SYSDATE-TL.NGAYTHULY)>90 )
                                     )
--                                     AND TL.ID IS NOT NULL 
                                    AND VA.ID=a.id AND GD.MAGIAIDOAN=3
                                    ) 
                             --dùng ngày QĐ phúc thẩm   
                            OR EXISTS (
                                    SELECT 'X' FROM  AHS_VUAN VA
                                    INNER JOIN AHS_PHUCTHAM_THULY TL ON TL.VUANID=VA.ID 
                                    INNER JOIN AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA ON PTQDVA.VUANID=TL.VUANID 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE
                                     --QĐ Đình chỉ hoặc QĐ hoãn hoặc QĐ gia hạn thời hạn chuẩn bị xét xử, QĐ chuyển vụ án
                                    (
                                          ( instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')>0  AND(PTQDVA.NGAYQD-TL.NGAYTHULY)>90 )
                                      OR (  instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0  AND(SYSDATE-TL.NGAYTHULY)>90)
                                    )
--                                     AND TL.ID IS NOT NULL 
                                    AND VA.ID=a.id  AND GD.MAGIAIDOAN=3
                                    )               
                        )
                       ---------Án chưa giải quyết xong     
                         AND  ( EXISTS (
                                SELECT 'X' FROM  AHS_SOTHAM_THULY TL
                                 WHERE
                                 (NOT EXISTS ( SELECT 'X' FROM AHS_SOTHAM_BANAN BA WHERE BA.VUANID= TL.VUANID)
                                  AND NOT EXISTS ( SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN T1 
                                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=T1.QUYETDINHID     
                                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                                WHERE INSTR(',DC,CVA,',','||QDL.MA||',')>0 AND TL.VUANID =T1.VUANID )
                                  )
                                 AND TL.VUANID=a.id  AND GD.MAGIAIDOAN=2
                               )
                        OR  EXISTS (
                                SELECT 'X' FROM AHS_PHUCTHAM_THULY PTTL 
                                WHERE 
                                (NOT EXISTS ( SELECT 'X' FROM AHS_PHUCTHAM_BANAN BA WHERE BA.VUANID= PTTL.VUANID)
                                  AND NOT EXISTS ( SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN T1 
                                                 LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=T1.QUYETDINHID     
                                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                                WHERE INSTR(',DC,CVA,',','||QDL.MA||',')>0 AND PTTL.VUANID =T1.VUANID )
                                  )
                                 AND PTTL.VUANID=a.id  AND GD.MAGIAIDOAN=3
                                )
                       )
        )
        OR(item_bc=3   AND(--Còn thời hạn dưới 20 ngày
                           --Sơ thẩm
                            EXISTS(SELECT 'X' FROM  AHS_VUAN VA
                                    INNER JOIN AHS_SOTHAM_THULY TL ON VA.ID=TL.VUANID 
                                    LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.VUANID =VA.ID
                                    --LEFT JOIN AHS_SOTHAM_CAOTRANG_DIEULUAT CT ON VA.ID=CT.VUANID
                                    LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QSV ON VA.ID=QSV.VUANID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                    WHERE (   ( (SYSDATE-TL.NGAYTHULY)>=25 AND (SYSDATE-TL.NGAYTHULY)<45  AND VA.LOAITOIPHAMID=89  )
                                            OR ( (SYSDATE-TL.NGAYTHULY)>=40 AND (SYSDATE-TL.NGAYTHULY)<60 AND VA.LOAITOIPHAMID=90)
                                            OR ( (SYSDATE-TL.NGAYTHULY)>=70 AND (SYSDATE-TL.NGAYTHULY)<90 AND VA.LOAITOIPHAMID=91)
                                            OR ( (SYSDATE-TL.NGAYTHULY)>=100 AND (SYSDATE-TL.NGAYTHULY)<120 AND VA.LOAITOIPHAMID=92)
                                          )
                                    AND BA.ID IS NULL
                                    AND( instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',') IS NULL)
                                    AND VA.ID=a.id AND GD.MAGIAIDOAN=2
                                  )
                              --phúc thẩm   
                            OR EXISTS (
                                    SELECT 'X' FROM  AHS_VUAN VA
                                    INNER JOIN AHS_PHUCTHAM_THULY TL ON TL.VUANID=VA.ID 
                                    LEFT JOIN AHS_PHUCTHAM_BANAN PTBA ON PTBA.VUANID=TL.VUANID 
                                    LEFT JOIN AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA ON PTQDVA.VUANID=TL.VUANID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=70 AND (SYSDATE-TL.NGAYTHULY)<90 
                                    AND PTBA.ID IS NULL
                                    AND( instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',') IS NULL)
                                    AND VA.ID=a.id  AND GD.MAGIAIDOAN=3
                                    ) 
                           )
              )   
              OR
              ( item_bc=4 AND  ( EXISTS (
                                        SELECT 'X' FROM  AHS_SOTHAM_THULY TL
                                         WHERE
                                         (NOT EXISTS ( SELECT 'X' FROM AHS_SOTHAM_BANAN BA WHERE BA.VUANID= TL.VUANID)
                                          AND NOT EXISTS ( SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN T1 
                                                        INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                        WHERE INSTR(',DC,CVA,',','||T2.MA||',')>0 AND TL.VUANID =T1.VUANID )
                                          )
                                         AND TL.VUANID=a.id  AND GD.MAGIAIDOAN=2
                                       )
                                OR  EXISTS (
                                        SELECT 'X' FROM AHS_PHUCTHAM_THULY PTTL 
                                        WHERE 
                                        (NOT EXISTS ( SELECT 'X' FROM AHS_PHUCTHAM_BANAN BA WHERE BA.VUANID= PTTL.VUANID)
                                          AND NOT EXISTS ( SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN T1 
                                                        INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                        WHERE INSTR(',DC,CVA,',','||T2.MA||',')>0 AND PTTL.VUANID =T1.VUANID )
                                          )
                                         AND PTTL.VUANID=a.id  AND GD.MAGIAIDOAN=3
                                        )
                            )  
                           AND--so tham Đang tạm đình chỉ 
                            ( EXISTS (
                                    SELECT 'X' FROM  AHS_SOTHAM_QUYETDINH_VUAN QSV
                                    INNER JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID 
                                    WHERE INSTR(',TDC,',','||QDL.MA||',')>0 -- 'TDC' Tam dinh chi
                                    AND QSV.VUANID =A.ID  AND GD.MAGIAIDOAN=2
                                     )
                             --phuc tham Đang tạm đình chỉ                
                                OR EXISTS (
                                    SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA --QUYẾT ĐỊNH 
                                    INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                    WHERE INSTR(',TDC,',','||QDL.MA||',')>0 --Tạm đình chỉ
                                    AND PTQDVA.VUANID=A.ID  AND GD.MAGIAIDOAN=3
                                )
                            )
             )
            OR(item_bc=5  --Án chờ thụ lý
            -- khong ton tai thong tin thu ly va chua co ket qua giai quyet
                   AND ( NOT EXISTS(SELECT 'x' from AHS_SOTHAM_THULY TL where TL.VUANID=a.id and GD.MAGIAIDOAN=2)
                           AND NOT EXISTS(SELECT 'x' from AHS_PHUCTHAM_THULY TL where TL.VUANID=a.id and GD.MAGIAIDOAN=3) 
                        ) 
                    AND (NOT EXISTS ( SELECT 'X' FROM AHS_SOTHAM_BANAN BA WHERE BA.VUANID= a.ID)
                    AND NOT EXISTS ( SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN T1 
                                                        INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                        WHERE INSTR(',DC,CVA,',','||T2.MA||',')>0 AND T1.VUANID =a.ID )
                                          )
             )
            OR(item_bc=6
                     AND ( EXISTS(SELECT 'x' from AHS_SOTHAM_THULY TL where TL.VUANID=a.id and GD.MAGIAIDOAN=2) 
                          OR EXISTS(SELECT 'x' from AHS_PHUCTHAM_THULY TL where TL.VUANID=a.id and GD.MAGIAIDOAN=3)
                        )
                     AND NOT EXISTS (
                                SELECT 'x' FROM AHS_THAMPHANGIAIQUYET PC 
                                WHERE PC.VUANID=A.ID
                                AND ((PC.MAVAITRO='VTTP_GIAIQUYETSOTHAM' AND GD.MAGIAIDOAN=2)--sơ thẩm
                                     OR(PC.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND GD.MAGIAIDOAN=3)--phuc thẩm
                                     )
                               )   
            )
           -- OR(item_bc=7) 
            OR(item_bc=8
                AND (   
                     EXISTS (
                                SELECT 'X' FROM  AHS_SOTHAM_BANAN BA 
                                WHERE BA.ID IS NOT NULL
                                    AND (BA.NGAYBANAN>=to_date('01/'||to_char(sysdate,'MM/yyyy'),'dd/MM/yyyy') )
                                    AND BA.VUANID=A.ID AND GD.MAGIAIDOAN=2
                                 )
                            OR  EXISTS (
                                     SELECT 'X' FROM  AHS_SOTHAM_QUYETDINH_VUAN QSV 
                                        INNER JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                    WHERE    instr(',DC,CVA,',','||QDL.MA||',')>0
                                          AND (QSV.NGAYQD>=to_date('01/'||to_char(sysdate,'MM/yyyy'),'dd/MM/yyyy'))
                                          AND QSV.VUANID=A.ID AND GD.MAGIAIDOAN=2
                                )
                            OR EXISTS (
                                    SELECT 'X' FROM AHS_PHUCTHAM_BANAN PTBA
                                    WHERE  PTBA.ID IS NOT NULL
                                    AND (PTBA.NGAYBANAN>=to_date('01/'||to_char(sysdate,'MM/yyyy'),'dd/MM/yyyy'))
                                    AND PTBA.VUANID=A.ID  AND GD.MAGIAIDOAN=3
                                    )
                             OR EXISTS (
                                    SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                    WHERE (QDL.MA='DC') --Đình chỉ
                                    AND ( PTQDVA.NGAYQD>=to_date('01/'||to_char(sysdate,'MM/yyyy'),'dd/MM/yyyy'))
                                    AND PTQDVA.VUANID=A.ID  AND GD.MAGIAIDOAN=3
                                    )         
                        )
                ) 
           -----------------  
            )   
          ;
        v_table.extend;
        v_table(v_table.count) := R_TDC_THOIHAN_GQ(item_bc,V_TEN_BC,item_bc
        ,V_COUNTS,0,0,0,0,0,
        0,0,0);
        -----ADS_-------
         SELECT COUNT(*) INTO V_COUNTS FROM  ADS_DON A
         INNER JOIN ADS_DON_GIAIDOAN GD ON A.ID=GD.DONID
         WHERE  (GD.TOAANID =v_toaan_id  OR GD.TOAPHUCTHAMID=v_toaan_id)   
         AND (V_CAPXX IS NULL OR (GD.MAGIAIDOAN=V_CAPXX AND V_CAPXX IS NOT NULL) )
          AND( 
          (item_bc=1
             AND (EXISTS (
                                SELECT 'X' FROM ADS_SOTHAM_THULY TL
                                  WHERE (NOT EXISTS(SELECT 'X' FROM ADS_SOTHAM_BANAN BA WHERE TL.DONID =BA.DONID)
                                        AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM ADS_SOTHAM_QUYETDINH T1 
                                                   INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND TL.DONID=T1.DONID) )
                                        )
                                 AND TL.DONID=a.id  AND GD.MAGIAIDOAN=2
                               )
                     OR EXISTS (
                                SELECT 'X' FROM ADS_PHUCTHAM_THULY PTTL 
                                 WHERE (NOT EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
                                        AND NOT EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                                       INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                                       WHERE instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0 AND  PTTL.DONID=PTQDVA.DONID 
                                                       )
                                 )
                                 AND PTTL.DONID=a.id  AND GD.MAGIAIDOAN=3
                               )
                )
           )
         OR(item_bc=2 --Án quá hạn (chưa giải quyết xong)
                     AND (   --dùng ngày bản án hoặc dùng ngày hiện tại và chưa có quyết định gây kết thúc vụ án
                            EXISTS(SELECT 'X' FROM ADS_SOTHAM_THULY TL
                                    LEFT JOIN ADS_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                    LEFT JOIN ADS_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    WHERE
                                      (   ( BA.ID IS NOT NULL AND (BA.NGAYMOPHIENTOA-TL.NGAYTHULY)>180 )
                                          OR( BA.ID IS NULL AND instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 AND (SYSDATE-TL.NGAYTHULY)>180)
                                      )
                                   AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                  )
                           --dùng ngày quyết định và đình chỉ vụ án   
                            OR  EXISTS (SELECT 'X' FROM ADS_SOTHAM_THULY TL
                                        LEFT JOIN ADS_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                        LEFT JOIN ADS_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                        LEFT JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                        WHERE 
                                         (
                                            ( instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')>0 AND  (QSV.NGAYQD-TL.NGAYTHULY)>180  )--'CVA' QĐ chuyển vụ án,'HPT' Hoãn phiên tòa, 'GHTHXX' QĐ gia hạn thời hạn chuẩn bị xét xử
                                           OR
                                            (  instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 AND  BA.ID IS NULL AND (SYSDATE-TL.NGAYTHULY)>180 )
                                         )
                                        AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                     )
                              --dùng ngày bản án phúc thẩm hoặc dùng ngày hiện tại và chưa có quyết định gây kết thúc vụ án  
                            OR EXISTS (
                                    SELECT 'X' FROM ADS_PHUCTHAM_THULY TL 
                                    LEFT JOIN ADS_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN ADS_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                    WHERE 
                                     (
                                        (BA.ID IS NOT NULL  AND  (BA.NGAYMOPHIENTOA-TL.NGAYTHULY)>90 )
                                     OR (BA.ID IS  NULL AND instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 AND  (SYSDATE-TL.NGAYTHULY)>90 )
                                     )
                                 AND TL.DONID =a.id AND GD.MAGIAIDOAN=3
                             )
                            --dùng ngày QĐ phúc thẩm  
                              OR EXISTS (
                                    SELECT 'X' FROM ADS_PHUCTHAM_THULY TL 
                                    LEFT JOIN ADS_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QSV.LOAIQDID 
                                    WHERE
                                    (
                                          ( instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')>0  AND(QSV.NGAYQD-TL.NGAYTHULY)>90 ) --QĐ Đình chỉ hoặc QĐ hoãn hoặc QĐ gia hạn thời hạn chuẩn bị xét xử, QĐ chuyển vụ án
                                      OR (  instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0  AND(SYSDATE-TL.NGAYTHULY)>90)
                                    )
                                     AND TL.DONID =a.id AND GD.MAGIAIDOAN=3
                                 ) 
                         )
                   AND --Án chưa giải quyết xong
                   (EXISTS ( 
                                SELECT 'X' FROM ADS_SOTHAM_THULY TL
                                  WHERE (NOT EXISTS(SELECT 'X' FROM ADS_SOTHAM_BANAN BA WHERE TL.DONID =BA.DONID)
                                        AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM ADS_SOTHAM_QUYETDINH T1 
                                                   INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND TL.DONID=T1.DONID) )
                                        )
                                 AND TL.DONID=a.id  AND GD.MAGIAIDOAN=2
                               )
                     OR EXISTS (
                                SELECT 'X' FROM ADS_PHUCTHAM_THULY PTTL 
                                 WHERE (NOT EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
                                        AND NOT EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                                       INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                                       WHERE instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0 AND  PTTL.DONID=PTQDVA.DONID 
                                                       )
                                 )
                                 AND PTTL.DONID=a.id  AND GD.MAGIAIDOAN=3
                               )
                   )
         )
         OR (item_bc=3  AND (
                      --Sơ thẩm chưa có quyết định và chưa có bản án
                            EXISTS(SELECT 'X' FROM ADS_SOTHAM_THULY TL
                                    LEFT JOIN ADS_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    LEFT JOIN ADS_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=160 AND (SYSDATE-TL.NGAYTHULY)<180 
                                    AND BA.ID IS NULL
                                    AND (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',') IS NULL)
                                    AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                  )
                          --phúc thẩm   
                            OR EXISTS (
                                    SELECT 'X' FROM ADS_PHUCTHAM_THULY TL 
                                    LEFT JOIN ADS_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN ADS_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=70 AND (SYSDATE-TL.NGAYTHULY)<90 
                                    AND BA.ID IS NULL
                                    AND  (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')IS NULL)
                                    AND TL.DONID =a.id AND GD.MAGIAIDOAN=3
                                    ) 
                           )          
                )   
              OR  (item_bc=4 AND (EXISTS (
                                SELECT 'X' FROM ADS_SOTHAM_THULY TL
                                  WHERE (NOT EXISTS(SELECT 'X' FROM ADS_SOTHAM_BANAN BA WHERE TL.DONID =BA.DONID)
                                        AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM ADS_SOTHAM_QUYETDINH T1 
                                                   INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND TL.DONID=T1.DONID) )
                                        )
                                 AND TL.DONID=a.id  AND GD.MAGIAIDOAN=2
                               )
                     OR EXISTS (
                                SELECT 'X' FROM ADS_PHUCTHAM_THULY PTTL 
                                 WHERE (NOT EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
                                        AND NOT EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                                       INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                                       WHERE instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0 AND  PTTL.DONID=PTQDVA.DONID 
                                                       )
                                 )
                                 AND PTTL.DONID=a.id  AND GD.MAGIAIDOAN=3
                               )
                      )
                   AND 
                   ( --so tham Đang tạm đình chỉ 
                      EXISTS (
                            SELECT 'X' FROM ADS_SOTHAM_QUYETDINH QSV
                            INNER JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID 
                            LEFT JOIN ADS_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                            WHERE QDL.MA ='TDC'   -- QDL.MA ='TDC' Tam dinh chi
                            AND BA.DONID IS NULL  -- chưa có bản án
                            AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                         )
                     --phuc tham Đang tạm đình chỉ                
                        OR EXISTS (
                            SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                            LEFT JOIN ADS_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTQDVA.DONID --BẢN ÁN 
                            WHERE PTBA.DONID IS NULL --Vụ án chưa có bản án 
                            AND QDL.MA='TDC' --Tạm đình chỉ
                            AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                            )
                    ) 
                  ) 
               OR(item_bc=5 --Án chờ thụ lý
            -- khong ton tai thong tin thu ly va chua co ket qua giai quyet
                   AND ( NOT EXISTS(SELECT 'x' from ADS_SOTHAM_THULY TL where TL.DONID=a.id and GD.MAGIAIDOAN=2) 
                           AND NOT EXISTS(SELECT 'x' from ADS_PHUCTHAM_THULY TL where TL.DONID=a.id and GD.MAGIAIDOAN=3) 
                        ) 
                    AND (NOT EXISTS(SELECT 'X' FROM ADS_SOTHAM_BANAN BA WHERE BA.DONID = A.ID)
                                        AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM ADS_SOTHAM_QUYETDINH T1 
                                                   INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND T1.DONID=A.ID) )
                                        )
                ) 
                OR(item_bc=6
                     AND ( EXISTS(SELECT 'x' from ADS_SOTHAM_THULY TL where TL.DONID=a.id and GD.MAGIAIDOAN=2) 
                           OR EXISTS(SELECT 'x' from ADS_PHUCTHAM_THULY TL where TL.DONID=a.id and GD.MAGIAIDOAN=3) 
                        ) 
                     AND NOT EXISTS (
                                SELECT 'x' FROM ADS_DON_THAMPHAN PC 
                                WHERE PC.DONID=A.ID
                                AND ((PC.MAVAITRO='VTTP_GIAIQUYETSOTHAM' AND GD.MAGIAIDOAN=2)--sơ thẩm
                                     OR(PC.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND GD.MAGIAIDOAN=3)--phuc thẩm
                                     )
                               )   
            )
             -- OR(item_bc=7) 
            OR(item_bc=8
            AND (   
                     EXISTS (       
                                    SELECT 'X' FROM ADS_SOTHAM_BANAN BA
                                    WHERE  BA.SOBANAN IS NOT NULL
                                    AND (BA.NGAYTUYENAN>=to_date('01/'||to_char(sysdate,'MM/yyyy'),'dd/MM/yyyy'))
                                    AND BA.DONID=a.id  AND GD.MAGIAIDOAN=2
                                 )
                            OR  EXISTS (
                                    SELECT 'X' FROM ADS_SOTHAM_QUYETDINH QSV 
                                    INNER JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                    WHERE instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0
                                    AND (QSV.NGAYQD>=to_date('01/'||to_char(sysdate,'MM/yyyy'),'dd/MM/yyyy'))
                                    AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                                )
                            OR EXISTS (
                                    SELECT 'X' FROM ADS_PHUCTHAM_BANAN PTBA 
                                    WHERE  PTBA.SOBANAN IS NOT NULL
                                    AND (PTBA.NGAYTUYENAN>=to_date('01/'||to_char(sysdate,'MM/yyyy'),'dd/MM/yyyy'))
                                    AND PTBA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )
                             OR EXISTS (
                                    SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                    WHERE  instr('DC',QDL.MA)>0
                                    AND (PTQDVA.NGAYQD>=to_date('01/'||to_char(sysdate,'MM/yyyy'),'dd/MM/yyyy'))
                                    AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )         
                        )
            )
            OR(item_bc=9  --Đơn chưa giải quyết
                -- khong ton tai thong tin XU LY DON va chua co ket qua giai quyet
                  AND NOT EXISTS ( SELECT 'X' FROM ADS_DON_XULY XL WHERE XL.DONID=A.ID) 
                   -- CHUA CO KET QUA XET XU
                    AND (NOT EXISTS(SELECT 'X' FROM ADS_SOTHAM_BANAN BA WHERE BA.DONID = A.ID)
                                        AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM ADS_SOTHAM_QUYETDINH T1 
                                                   INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND T1.DONID=A.ID) )
                                        )
              )
            OR(item_bc=10       -- Đơn chưa giải quyết
                    AND NOT EXISTS ( SELECT 'X' FROM ADS_DON_XULY XL WHERE XL.DONID=A.ID) 
                          AND (SYSDATE-a.NGAYNHANDON)>8
                    -- CHUA CO KET QUA XET XU
                    AND (NOT EXISTS(SELECT 'X' FROM ADS_SOTHAM_BANAN BA WHERE BA.DONID = A.ID)
                                        AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM ADS_SOTHAM_QUYETDINH T1 
                                                   INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND T1.DONID=A.ID) )
                            )
              )
             OR(item_bc=11 --Đơn chưa phân công TP giải quyết
                    AND NOT EXISTS ( SELECT 'X' FROM ADS_DON_XULY XL WHERE XL.DONID=A.ID)  
                            AND NOT EXISTS(SELECT 'X' FROM ADS_DON_THAMPHAN TP WHERE TP.DONID=A.ID)    
                   -- CHUA CO KET QUA XET XU
                    AND (NOT EXISTS(SELECT 'X' FROM ADS_SOTHAM_BANAN BA WHERE BA.DONID = A.ID)
                                        AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM ADS_SOTHAM_QUYETDINH T1 
                                                   INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND T1.DONID=A.ID) )
                                )
              )   
          )     
        ;  
        v_table.extend;
        v_table(v_table.count) := R_TDC_THOIHAN_GQ(item_bc,V_TEN_BC,item_bc
        ,0,V_COUNTS,0,0,0,0,
        0,0,0);
        -----AHN_-------
         SELECT COUNT(*) INTO V_COUNTS FROM  AHN_DON A
         INNER JOIN AHN_DON_GIAIDOAN GD ON A.ID=GD.DONID
         WHERE  (GD.TOAANID =v_toaan_id  OR GD.TOAPHUCTHAMID=v_toaan_id)   
         AND (V_CAPXX IS NULL OR (GD.MAGIAIDOAN=V_CAPXX AND V_CAPXX IS NOT NULL) )
           AND(
               (item_bc=1
                      AND (EXISTS (
                                SELECT 'X' FROM AHN_SOTHAM_THULY TL
                                  WHERE (NOT EXISTS(SELECT 'X' FROM AHN_SOTHAM_BANAN BA WHERE TL.DONID =BA.DONID)
                                        AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM AHN_SOTHAM_QUYETDINH T1 
                                                   INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND TL.DONID=T1.DONID) )
                                        )
                                 AND TL.DONID=a.id  AND GD.MAGIAIDOAN=2
                               )
                      OR EXISTS (
                                SELECT 'X' FROM AHN_PHUCTHAM_THULY PTTL 
                                 WHERE (NOT EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
                                        AND NOT EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                                       INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                                       WHERE instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0 AND  PTTL.DONID=PTQDVA.DONID 
                                                       )
                                 )
                                 AND PTTL.DONID=a.id  AND GD.MAGIAIDOAN=3
                               )
                    )
                )
                OR(item_bc=2 --Án quá hạn (chưa giải quyết xong)
                         AND (   --dùng ngày bản án hoặc dùng ngày hiện tại và chưa có quyết định gây kết thúc vụ án
                                EXISTS(SELECT 'X' FROM AHN_SOTHAM_THULY TL
                                        LEFT JOIN AHN_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                        LEFT JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                        LEFT JOIN AHN_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                        WHERE
                                          (   ( BA.ID IS NOT NULL AND (BA.NGAYMOPHIENTOA-TL.NGAYTHULY)>180 )
                                              OR( BA.ID IS NULL AND instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 AND (SYSDATE-TL.NGAYTHULY)>180)
                                          )
                                       AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                      )
                               --dùng ngày quyết định và đình chỉ vụ án   
                                OR  EXISTS (SELECT 'X' FROM AHN_SOTHAM_THULY TL
                                            LEFT JOIN AHN_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                            LEFT JOIN AHN_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                            LEFT JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                            WHERE 
                                             (
                                                ( instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')>0 AND  (QSV.NGAYQD-TL.NGAYTHULY)>180  )--'CVA' QĐ chuyển vụ án,'HPT' Hoãn phiên tòa, 'GHTHXX' QĐ gia hạn thời hạn chuẩn bị xét xử
                                               OR
                                                (  instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 AND  BA.ID IS NULL AND (SYSDATE-TL.NGAYTHULY)>180 )
                                             )
                                            AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                         )
                                  --dùng ngày bản án phúc thẩm hoặc dùng ngày hiện tại và chưa có quyết định gây kết thúc vụ án  
                                OR EXISTS (
                                        SELECT 'X' FROM AHN_PHUCTHAM_THULY TL 
                                        LEFT JOIN AHN_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                        LEFT JOIN AHN_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                        LEFT JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                        WHERE 
                                         (
                                            (BA.ID IS NOT NULL  AND  (BA.NGAYMOPHIENTOA-TL.NGAYTHULY)>90 )
                                         OR (BA.ID IS  NULL AND instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 AND  (SYSDATE-TL.NGAYTHULY)>90 )
                                         )
                                     AND TL.DONID =a.id AND GD.MAGIAIDOAN=3
                                 )
                                --dùng ngày QĐ phúc thẩm  
                                  OR EXISTS (
                                        SELECT 'X' FROM AHN_PHUCTHAM_THULY TL 
                                        LEFT JOIN AHN_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID 
                                        LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QSV.LOAIQDID 
                                        WHERE
                                        (
                                              ( instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')>0  AND(QSV.NGAYQD-TL.NGAYTHULY)>90 ) --QĐ Đình chỉ hoặc QĐ hoãn hoặc QĐ gia hạn thời hạn chuẩn bị xét xử, QĐ chuyển vụ án
                                          OR (  instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0  AND(SYSDATE-TL.NGAYTHULY)>90)
                                        )
                                         AND TL.DONID =a.id AND GD.MAGIAIDOAN=3
                                     ) 
                             )
                       AND --Án chưa giải quyết xong
                       (EXISTS ( 
                                    SELECT 'X' FROM AHN_SOTHAM_THULY TL
                                      WHERE (NOT EXISTS(SELECT 'X' FROM AHN_SOTHAM_BANAN BA WHERE TL.DONID =BA.DONID)
                                            AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM AHN_SOTHAM_QUYETDINH T1 
                                                       INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                       WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND TL.DONID=T1.DONID) )
                                            )
                                     AND TL.DONID=a.id  AND GD.MAGIAIDOAN=2
                                   )
                         OR EXISTS (
                                    SELECT 'X' FROM AHN_PHUCTHAM_THULY PTTL 
                                     WHERE (NOT EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
                                            AND NOT EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                                           INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                                           WHERE instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0 AND  PTTL.DONID=PTQDVA.DONID 
                                                           )
                                     )
                                     AND PTTL.DONID=a.id  AND GD.MAGIAIDOAN=3
                                   )
                       )
             )    
            OR (item_bc=3  AND (
                      --Sơ thẩm chưa có quyết định và chưa có bản án
                            EXISTS(SELECT 'X' FROM AHN_SOTHAM_THULY TL
                                    LEFT JOIN AHN_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AHN_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=160 AND (SYSDATE-TL.NGAYTHULY)<180 
                                    AND BA.ID IS NULL
                                    AND (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',') IS NULL)
                                    AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                  )
                          --phúc thẩm   
                            OR EXISTS (
                                    SELECT 'X' FROM AHN_PHUCTHAM_THULY TL 
                                    LEFT JOIN AHN_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AHN_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=70 AND (SYSDATE-TL.NGAYTHULY)<90 
                                    AND BA.ID IS NULL
                                    AND  (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')IS NULL)
                                    AND TL.DONID =a.id AND GD.MAGIAIDOAN=3
                                    ) 
                           )          
                )
                OR
                (item_bc=4 AND (EXISTS (
                                SELECT 'X' FROM AHN_SOTHAM_THULY TL
                                  WHERE (NOT EXISTS(SELECT 'X' FROM AHN_SOTHAM_BANAN BA WHERE TL.DONID =BA.DONID)
                                        AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM AHN_SOTHAM_QUYETDINH T1 
                                                   INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND TL.DONID=T1.DONID) )
                                        )
                                 AND TL.DONID=a.id  AND GD.MAGIAIDOAN=2
                               )
                     OR EXISTS (
                                SELECT 'X' FROM AHN_PHUCTHAM_THULY PTTL 
                                 WHERE (NOT EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
                                        AND NOT EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                                       INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                                       WHERE instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0 AND  PTTL.DONID=PTQDVA.DONID 
                                                       )
                                 )
                                 AND PTTL.DONID=a.id  AND GD.MAGIAIDOAN=3
                               )
                      )
                   AND 
                   ( --so tham Đang tạm đình chỉ 
                      EXISTS (
                            SELECT 'X' FROM AHN_SOTHAM_QUYETDINH QSV
                            INNER JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID 
                            LEFT JOIN AHN_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                            WHERE QDL.MA ='TDC'   -- QDL.MA ='TDC' Tam dinh chi
                            AND BA.DONID IS NULL  -- chưa có bản án
                            AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                         )
                     --phuc tham Đang tạm đình chỉ                
                        OR EXISTS (
                            SELECT 'X' FROM AHN_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                            LEFT JOIN AHN_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTQDVA.DONID --BẢN ÁN 
                            WHERE PTBA.DONID IS NULL --Vụ án chưa có bản án 
                            AND QDL.MA='TDC' --Tạm đình chỉ
                            AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                            )
                    )  
                )
              OR(item_bc=5 --An cho Thu ly
                   AND ( NOT EXISTS(SELECT 'x' from AHN_SOTHAM_THULY TL where TL.DONID=a.id and GD.MAGIAIDOAN=2) 
                           AND NOT EXISTS(SELECT 'x' from AHN_PHUCTHAM_THULY TL where TL.DONID=a.id and GD.MAGIAIDOAN=3) 
                        ) 
                    -- CHUA CO KET QUA XET XU
                    AND (NOT EXISTS(SELECT 'X' FROM AHN_SOTHAM_BANAN BA WHERE BA.DONID = A.ID)
                    AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM AHN_SOTHAM_QUYETDINH T1 
                                                   INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND T1.DONID=A.ID) )
                                        )
                )
               OR(item_bc=6
                     AND ( EXISTS(SELECT 'x' from AHN_SOTHAM_THULY TL where TL.DONID=a.id and GD.MAGIAIDOAN=2) 
                           OR EXISTS(SELECT 'x' from AHN_PHUCTHAM_THULY TL where TL.DONID=a.id and GD.MAGIAIDOAN=3) 
                        ) 
                     AND NOT EXISTS (
                                SELECT 'x' FROM AHN_DON_THAMPHAN PC 
                                WHERE PC.DONID=A.ID
                                AND ((PC.MAVAITRO='VTTP_GIAIQUYETSOTHAM' AND GD.MAGIAIDOAN=2)--sơ thẩm
                                     OR(PC.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND GD.MAGIAIDOAN=3)--phuc thẩm
                                     )
                               )   
            )
             -- OR(item_bc=7) 
            OR(item_bc=8
               AND (   
                     EXISTS (       
                                    SELECT 'X' FROM AHN_SOTHAM_BANAN BA
                                    WHERE  BA.SOBANAN IS NOT NULL
                                    AND (BA.NGAYTUYENAN>=to_date('01/'||to_char(sysdate,'MM/yyyy'),'dd/MM/yyyy'))
                                    AND BA.DONID=a.id  AND GD.MAGIAIDOAN=2
                                 )
                            OR  EXISTS (
                                    SELECT 'X' FROM AHN_SOTHAM_QUYETDINH QSV 
                                    INNER JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                    WHERE instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0
                                    AND (QSV.NGAYQD>=to_date('01/'||to_char(sysdate,'MM/yyyy'),'dd/MM/yyyy'))
                                    AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                                )
                            OR EXISTS (
                                    SELECT 'X' FROM AHN_PHUCTHAM_BANAN PTBA 
                                    WHERE  PTBA.SOBANAN IS NOT NULL
                                    AND (PTBA.NGAYTUYENAN>=to_date('01/'||to_char(sysdate,'MM/yyyy'),'dd/MM/yyyy'))
                                    AND PTBA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )
                             OR EXISTS (
                                    SELECT 'X' FROM AHN_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                    WHERE  instr('DC',QDL.MA)>0
                                    AND (PTQDVA.NGAYQD>=to_date('01/'||to_char(sysdate,'MM/yyyy'),'dd/MM/yyyy'))
                                    AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )         
                        )
            )
            OR(item_bc=9 --Đơn chưa giải quyết
                    AND NOT EXISTS ( SELECT 'X' FROM AHN_DON_XULY XL WHERE XL.DONID=A.ID)  
                         -- CHUA CO KET QUA XET XU
                    AND (NOT EXISTS(SELECT 'X' FROM AHN_SOTHAM_BANAN BA WHERE BA.DONID = A.ID)
                    AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM AHN_SOTHAM_QUYETDINH T1 
                                                   INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND T1.DONID=A.ID) )
                                        )
              )
            OR(item_bc=10 
                    AND NOT EXISTS ( SELECT 'X' FROM AHN_DON_XULY XL WHERE XL.DONID=A.ID) 
                    AND (SYSDATE-a.NGAYNHANDON)>8  
                    -- CHUA CO KET QUA XET XU
                    AND (NOT EXISTS(SELECT 'X' FROM AHN_SOTHAM_BANAN BA WHERE BA.DONID = A.ID)
                    AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM AHN_SOTHAM_QUYETDINH T1 
                                                   INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND T1.DONID=A.ID) )
                                        )
              )
             OR(item_bc=11 
                    AND NOT EXISTS ( SELECT 'X' FROM AHN_DON_XULY XL WHERE XL.DONID=A.ID)  
                    AND NOT EXISTS(SELECT 'X' FROM AHN_DON_THAMPHAN TP WHERE TP.DONID=A.ID) 
                    -- CHUA CO KET QUA XET XU
                    AND (NOT EXISTS(SELECT 'X' FROM AHN_SOTHAM_BANAN BA WHERE BA.DONID = A.ID)
                    AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM AHN_SOTHAM_QUYETDINH T1 
                                                   INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND T1.DONID=A.ID) )
                                        )
              )   
          )     
        ; 
        v_table.extend;
        v_table(v_table.count) := R_TDC_THOIHAN_GQ(item_bc,V_TEN_BC,item_bc
        ,0,0,V_COUNTS,0,0,0,
        0,0,0);
        -----AKT_-------
         SELECT COUNT(*) INTO V_COUNTS FROM  AKT_DON A
         INNER JOIN AKT_DON_GIAIDOAN GD ON A.ID=GD.DONID
         WHERE  (GD.TOAANID =v_toaan_id  OR GD.TOAPHUCTHAMID=v_toaan_id)   
         AND (V_CAPXX IS NULL OR (GD.MAGIAIDOAN=V_CAPXX AND V_CAPXX IS NOT NULL) )
                AND( 
                (item_bc=1
                     AND (EXISTS (
                                SELECT 'X' FROM AKT_SOTHAM_THULY TL
                                  WHERE (NOT EXISTS(SELECT 'X' FROM AKT_SOTHAM_BANAN BA WHERE TL.DONID =BA.DONID)
                                        AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM AKT_SOTHAM_QUYETDINH T1 
                                                   INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND TL.DONID=T1.DONID) )
                                        )
                                 AND TL.DONID=a.id  AND GD.MAGIAIDOAN=2
                               )
                      OR EXISTS (
                                SELECT 'X' FROM AKT_PHUCTHAM_THULY PTTL 
                                 WHERE (NOT EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
                                        AND NOT EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                                       INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                                       WHERE instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0 AND  PTTL.DONID=PTQDVA.DONID 
                                                       )
                                 )
                                 AND PTTL.DONID=a.id  AND GD.MAGIAIDOAN=3
                               )
                 )
              )
              OR(item_bc=2 --Án quá hạn (chưa giải quyết xong)
                     AND (   --dùng ngày bản án hoặc dùng ngày hiện tại và chưa có quyết định gây kết thúc vụ án
                            EXISTS(SELECT 'X' FROM AKT_SOTHAM_THULY TL
                                    LEFT JOIN AKT_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                    LEFT JOIN AKT_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    WHERE
                                      (   ( BA.ID IS NOT NULL AND (BA.NGAYMOPHIENTOA-TL.NGAYTHULY)>180 )
                                          OR( BA.ID IS NULL AND instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 AND (SYSDATE-TL.NGAYTHULY)>180)
                                      )
                                   AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                  )
                           --dùng ngày quyết định và đình chỉ vụ án   
                            OR  EXISTS (SELECT 'X' FROM AKT_SOTHAM_THULY TL
                                        LEFT JOIN AKT_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                        LEFT JOIN AKT_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                        LEFT JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                        WHERE 
                                         (
                                            ( instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')>0 AND  (QSV.NGAYQD-TL.NGAYTHULY)>180  )--'CVA' QĐ chuyển vụ án,'HPT' Hoãn phiên tòa, 'GHTHXX' QĐ gia hạn thời hạn chuẩn bị xét xử
                                           OR
                                            (  instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 AND  BA.ID IS NULL AND (SYSDATE-TL.NGAYTHULY)>180 )
                                         )
                                        AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                     )
                              --dùng ngày bản án phúc thẩm hoặc dùng ngày hiện tại và chưa có quyết định gây kết thúc vụ án  
                            OR EXISTS (
                                    SELECT 'X' FROM AKT_PHUCTHAM_THULY TL 
                                    LEFT JOIN AKT_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AKT_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                    WHERE 
                                     (
                                        (BA.ID IS NOT NULL  AND  (BA.NGAYMOPHIENTOA-TL.NGAYTHULY)>90 )
                                     OR (BA.ID IS  NULL AND instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 AND  (SYSDATE-TL.NGAYTHULY)>90 )
                                     )
                                 AND TL.DONID =a.id AND GD.MAGIAIDOAN=3
                             )
                            --dùng ngày QĐ phúc thẩm  
                              OR EXISTS (
                                    SELECT 'X' FROM AKT_PHUCTHAM_THULY TL 
                                    LEFT JOIN AKT_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QSV.LOAIQDID 
                                    WHERE
                                    (
                                          ( instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')>0  AND(QSV.NGAYQD-TL.NGAYTHULY)>90 ) --QĐ Đình chỉ hoặc QĐ hoãn hoặc QĐ gia hạn thời hạn chuẩn bị xét xử, QĐ chuyển vụ án
                                      OR (  instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0  AND(SYSDATE-TL.NGAYTHULY)>90)
                                    )
                                     AND TL.DONID =a.id AND GD.MAGIAIDOAN=3
                                 ) 
                         )
                   AND --Án chưa giải quyết xong
                   (EXISTS ( 
                                SELECT 'X' FROM AKT_SOTHAM_THULY TL
                                  WHERE (NOT EXISTS(SELECT 'X' FROM AKT_SOTHAM_BANAN BA WHERE TL.DONID =BA.DONID)
                                        AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM AKT_SOTHAM_QUYETDINH T1 
                                                   INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND TL.DONID=T1.DONID) )
                                        )
                                 AND TL.DONID=a.id  AND GD.MAGIAIDOAN=2
                               )
                     OR EXISTS (
                                SELECT 'X' FROM AKT_PHUCTHAM_THULY PTTL 
                                 WHERE (NOT EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
                                        AND NOT EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                                       INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                                       WHERE instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0 AND  PTTL.DONID=PTQDVA.DONID 
                                                       )
                                 )
                                 AND PTTL.DONID=a.id  AND GD.MAGIAIDOAN=3
                               )
                   )
                )
              OR  (item_bc=3  AND (
                      --Sơ thẩm chưa có quyết định và chưa có bản án
                            EXISTS(SELECT 'X' FROM AKT_SOTHAM_THULY TL
                                    LEFT JOIN AKT_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AKT_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=160 AND (SYSDATE-TL.NGAYTHULY)<180 
                                    AND BA.ID IS NULL
                                    AND (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')IS NULL)
                                    AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                  )
                          --phúc thẩm   
                            OR EXISTS (
                                    SELECT 'X' FROM AKT_PHUCTHAM_THULY TL 
                                    LEFT JOIN AKT_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AKT_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=70 AND (SYSDATE-TL.NGAYTHULY)<90 
                                    AND BA.ID IS NULL
                                    AND  (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',') IS NULL)
                                    AND TL.DONID =a.id AND GD.MAGIAIDOAN=3
                                    ) 
                           )          
                )    
              OR (item_bc=4 AND (EXISTS (
                                SELECT 'X' FROM AKT_SOTHAM_THULY TL
                                  WHERE (NOT EXISTS(SELECT 'X' FROM AKT_SOTHAM_BANAN BA WHERE TL.DONID =BA.DONID)
                                        AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM AKT_SOTHAM_QUYETDINH T1 
                                                   INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND TL.DONID=T1.DONID) )
                                        )
                                 AND TL.DONID=a.id  AND GD.MAGIAIDOAN=2
                               )
                     OR EXISTS (
                                SELECT 'X' FROM AKT_PHUCTHAM_THULY PTTL 
                                 WHERE (NOT EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
                                        AND NOT EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                                       INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                                       WHERE instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0 AND  PTTL.DONID=PTQDVA.DONID 
                                                       )
                                 )
                                 AND PTTL.DONID=a.id  AND GD.MAGIAIDOAN=3
                               )
                      )
                   AND 
                   ( --so tham Đang tạm đình chỉ 
                      EXISTS (
                            SELECT 'X' FROM AKT_SOTHAM_QUYETDINH QSV
                            INNER JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID 
                            LEFT JOIN AKT_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                            WHERE QDL.MA ='TDC'   -- QDL.MA ='TDC' Tam dinh chi
                            AND BA.DONID IS NULL  -- chưa có bản án
                            AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                         )
                     --phuc tham Đang tạm đình chỉ                
                        OR EXISTS (
                            SELECT 'X' FROM AKT_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                            LEFT JOIN AKT_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTQDVA.DONID --BẢN ÁN 
                            WHERE PTBA.DONID IS NULL --Vụ án chưa có bản án 
                            AND QDL.MA='TDC' --Tạm đình chỉ
                            AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                            )
                    ) 
                ) 
            OR(item_bc=5 --Án chờ thụ lý
                   AND ( NOT EXISTS(SELECT 'x' from AKT_SOTHAM_THULY TL where TL.DONID=a.id and GD.MAGIAIDOAN=2) 
                           AND NOT EXISTS(SELECT 'x' from AKT_PHUCTHAM_THULY TL where TL.DONID=a.id and GD.MAGIAIDOAN=3) 
                        )
                    -- CHUA CO KET QUA XET XU
                    AND (NOT EXISTS(SELECT 'X' FROM AKT_SOTHAM_BANAN BA WHERE BA.DONID = A.ID)
                    AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM AKT_SOTHAM_QUYETDINH T1 
                                                   INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND T1.DONID=A.ID) )
                                        )
                ) 
             OR(item_bc=6
                     AND ( EXISTS(SELECT 'x' from AKT_SOTHAM_THULY TL where TL.DONID=a.id and GD.MAGIAIDOAN=2) 
                           OR EXISTS(SELECT 'x' from AKT_PHUCTHAM_THULY TL where TL.DONID=a.id and GD.MAGIAIDOAN=3) 
                        ) 
                     AND NOT EXISTS (
                                SELECT 'x' FROM AKT_DON_THAMPHAN PC 
                                WHERE PC.DONID=A.ID
                                AND ((PC.MAVAITRO='VTTP_GIAIQUYETSOTHAM' AND GD.MAGIAIDOAN=2)--sơ thẩm
                                     OR(PC.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND GD.MAGIAIDOAN=3)--phuc thẩm
                                     )
                               )   
            )  
            -- OR(item_bc=7) 
            OR(item_bc=8
            AND (   
                     EXISTS (       
                                    SELECT 'X' FROM AKT_SOTHAM_BANAN BA
                                    WHERE  BA.SOBANAN IS NOT NULL
                                    AND (BA.NGAYTUYENAN>=to_date('01/'||to_char(sysdate,'MM/yyyy'),'dd/MM/yyyy'))
                                    AND BA.DONID=a.id  AND GD.MAGIAIDOAN=2
                                 )
                            OR  EXISTS (
                                    SELECT 'X' FROM AKT_SOTHAM_QUYETDINH QSV 
                                    INNER JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                    WHERE instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0
                                    AND (QSV.NGAYQD>=to_date('01/'||to_char(sysdate,'MM/yyyy'),'dd/MM/yyyy'))
                                    AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                                )
                            OR EXISTS (
                                    SELECT 'X' FROM AKT_PHUCTHAM_BANAN PTBA 
                                    WHERE  PTBA.SOBANAN IS NOT NULL
                                    AND (PTBA.NGAYTUYENAN>=to_date('01/'||to_char(sysdate,'MM/yyyy'),'dd/MM/yyyy'))
                                    AND PTBA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )
                             OR EXISTS (
                                    SELECT 'X' FROM AKT_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                    WHERE  instr('DC',QDL.MA)>0
                                    AND (PTQDVA.NGAYQD>=to_date('01/'||to_char(sysdate,'MM/yyyy'),'dd/MM/yyyy'))
                                    AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )         
                        )
            ) 
            OR(item_bc=9 
                    AND NOT EXISTS ( SELECT 'X' FROM AKT_DON_XULY XL WHERE XL.DONID=A.ID) 
                      -- CHUA CO KET QUA XET XU
                    AND (NOT EXISTS(SELECT 'X' FROM AKT_SOTHAM_BANAN BA WHERE BA.DONID = A.ID)
                    AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM AKT_SOTHAM_QUYETDINH T1 
                                                   INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND T1.DONID=A.ID) )
                                        )
              )
            OR(item_bc=10 
                    AND NOT EXISTS ( SELECT 'X' FROM AKT_DON_XULY XL WHERE XL.DONID=A.ID) 
                    AND (SYSDATE-a.NGAYNHANDON)>8  
                      -- CHUA CO KET QUA XET XU
                    AND (NOT EXISTS(SELECT 'X' FROM AKT_SOTHAM_BANAN BA WHERE BA.DONID = A.ID)
                    AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM AKT_SOTHAM_QUYETDINH T1 
                                                   INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND T1.DONID=A.ID) )
                                        )
              )
             OR(item_bc=11 
                    AND NOT EXISTS ( SELECT 'X' FROM AKT_DON_XULY XL WHERE XL.DONID=A.ID)  
                    AND NOT EXISTS(SELECT 'X' FROM AKT_DON_THAMPHAN TP WHERE TP.DONID=A.ID)  
                      -- CHUA CO KET QUA XET XU
                    AND (NOT EXISTS(SELECT 'X' FROM AKT_SOTHAM_BANAN BA WHERE BA.DONID = A.ID)
                    AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM AKT_SOTHAM_QUYETDINH T1 
                                                   INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND T1.DONID=A.ID) )
                                        )
              )   
          )     
        ; 
        v_table.extend;
        v_table(v_table.count) := R_TDC_THOIHAN_GQ(item_bc,V_TEN_BC,item_bc
        ,0,0,0,V_COUNTS,0,0,
        0,0,0);
        -----ALD_-------
         SELECT COUNT(*) INTO V_COUNTS FROM  ALD_DON A
         INNER JOIN ALD_DON_GIAIDOAN GD ON A.ID=GD.DONID
         WHERE  (GD.TOAANID =v_toaan_id  OR GD.TOAPHUCTHAMID=v_toaan_id)  
         AND (V_CAPXX IS NULL OR (GD.MAGIAIDOAN=V_CAPXX AND V_CAPXX IS NOT NULL) )
            AND(
                    (item_bc=1
                          AND (EXISTS (
                                    SELECT 'X' FROM ALD_SOTHAM_THULY TL
                                      WHERE (NOT EXISTS(SELECT 'X' FROM ALD_SOTHAM_BANAN BA WHERE TL.DONID =BA.DONID)
                                            AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM ALD_SOTHAM_QUYETDINH T1 
                                                       INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                       WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND TL.DONID=T1.DONID) )
                                            )
                                     AND TL.DONID=a.id  AND GD.MAGIAIDOAN=2
                                   )
                         OR EXISTS (
                                    SELECT 'X' FROM ALD_PHUCTHAM_THULY PTTL 
                                     WHERE (NOT EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
                                            AND NOT EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                                           INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                                           WHERE instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0 AND  PTTL.DONID=PTQDVA.DONID 
                                                           )
                                     )
                                     AND PTTL.DONID=a.id  AND GD.MAGIAIDOAN=3
                                   )
                     )
                )
              OR(item_bc=2 --Án quá hạn (chưa giải quyết xong)
                     AND (   --dùng ngày bản án hoặc dùng ngày hiện tại và chưa có quyết định gây kết thúc vụ án
                            EXISTS(SELECT 'X' FROM ALD_SOTHAM_THULY TL
                                    LEFT JOIN ALD_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                    LEFT JOIN ALD_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    WHERE
                                      (   ( BA.ID IS NOT NULL AND (BA.NGAYMOPHIENTOA-TL.NGAYTHULY)>180 )
                                          OR( BA.ID IS NULL AND instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 AND (SYSDATE-TL.NGAYTHULY)>180)
                                      )
                                   AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                  )
                           --dùng ngày quyết định và đình chỉ vụ án   
                            OR  EXISTS (SELECT 'X' FROM ALD_SOTHAM_THULY TL
                                        LEFT JOIN ALD_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                        LEFT JOIN ALD_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                        LEFT JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                        WHERE 
                                         (
                                            ( instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')>0 AND  (QSV.NGAYQD-TL.NGAYTHULY)>180  )--'CVA' QĐ chuyển vụ án,'HPT' Hoãn phiên tòa, 'GHTHXX' QĐ gia hạn thời hạn chuẩn bị xét xử
                                           OR
                                            (  instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 AND  BA.ID IS NULL AND (SYSDATE-TL.NGAYTHULY)>180 )
                                         )
                                        AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                     )
                              --dùng ngày bản án phúc thẩm hoặc dùng ngày hiện tại và chưa có quyết định gây kết thúc vụ án  
                            OR EXISTS (
                                    SELECT 'X' FROM ALD_PHUCTHAM_THULY TL 
                                    LEFT JOIN ALD_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN ALD_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                    WHERE 
                                     (
                                        (BA.ID IS NOT NULL  AND  (BA.NGAYMOPHIENTOA-TL.NGAYTHULY)>90 )
                                     OR (BA.ID IS  NULL AND instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 AND  (SYSDATE-TL.NGAYTHULY)>90 )
                                     )
                                 AND TL.DONID =a.id AND GD.MAGIAIDOAN=3
                             )
                            --dùng ngày QĐ phúc thẩm  
                              OR EXISTS (
                                    SELECT 'X' FROM ALD_PHUCTHAM_THULY TL 
                                    LEFT JOIN ALD_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QSV.LOAIQDID 
                                    WHERE
                                    (
                                          ( instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')>0  AND(QSV.NGAYQD-TL.NGAYTHULY)>90 ) --QĐ Đình chỉ hoặc QĐ hoãn hoặc QĐ gia hạn thời hạn chuẩn bị xét xử, QĐ chuyển vụ án
                                      OR (  instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0  AND(SYSDATE-TL.NGAYTHULY)>90)
                                    )
                                     AND TL.DONID =a.id AND GD.MAGIAIDOAN=3
                                 ) 
                         )
                   AND --Án chưa giải quyết xong
                   (EXISTS ( 
                                SELECT 'X' FROM ALD_SOTHAM_THULY TL
                                  WHERE (NOT EXISTS(SELECT 'X' FROM ALD_SOTHAM_BANAN BA WHERE TL.DONID =BA.DONID)
                                        AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM ALD_SOTHAM_QUYETDINH T1 
                                                   INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND TL.DONID=T1.DONID) )
                                        )
                                 AND TL.DONID=a.id  AND GD.MAGIAIDOAN=2
                               )
                     OR EXISTS (
                                SELECT 'X' FROM ALD_PHUCTHAM_THULY PTTL 
                                 WHERE (NOT EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
                                        AND NOT EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                                       INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                                       WHERE instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0 AND  PTTL.DONID=PTQDVA.DONID 
                                                       )
                                 )
                                 AND PTTL.DONID=a.id  AND GD.MAGIAIDOAN=3
                               )
                   )
                 )
               OR (item_bc=3  AND (
                      --Sơ thẩm chưa có quyết định và chưa có bản án
                            EXISTS(SELECT 'X' FROM ALD_SOTHAM_THULY TL
                                    LEFT JOIN ALD_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    LEFT JOIN ALD_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=160 AND (SYSDATE-TL.NGAYTHULY)<180 
                                    AND BA.ID IS NULL
                                    AND (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',') IS NULL)
                                    AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                  )
                          --phúc thẩm   
                            OR EXISTS (
                                    SELECT 'X' FROM ALD_PHUCTHAM_THULY TL 
                                    LEFT JOIN ALD_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN ALD_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=70 AND (SYSDATE-TL.NGAYTHULY)<90 
                                    AND BA.ID IS NULL
                                    AND  (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')IS NULL)
                                    AND TL.DONID =a.id AND GD.MAGIAIDOAN=3
                                    ) 
                           )          
                ) 
                OR
                (item_bc=4 AND (EXISTS (
                                SELECT 'X' FROM ALD_SOTHAM_THULY TL
                                  WHERE (NOT EXISTS(SELECT 'X' FROM ALD_SOTHAM_BANAN BA WHERE TL.DONID =BA.DONID)
                                        AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM ALD_SOTHAM_QUYETDINH T1 
                                                   INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND TL.DONID=T1.DONID) )
                                        )
                                 AND TL.DONID=a.id  AND GD.MAGIAIDOAN=2
                               )
                     OR EXISTS (
                                SELECT 'X' FROM ALD_PHUCTHAM_THULY PTTL 
                                 WHERE (NOT EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
                                        AND NOT EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                                       INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                                       WHERE instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0 AND  PTTL.DONID=PTQDVA.DONID 
                                                       )
                                 )
                                 AND PTTL.DONID=a.id  AND GD.MAGIAIDOAN=3
                               )
                      )
                   AND 
                   ( --so tham Đang tạm đình chỉ 
                      EXISTS (
                            SELECT 'X' FROM ALD_SOTHAM_QUYETDINH QSV
                            INNER JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID 
                            LEFT JOIN ALD_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                            WHERE QDL.MA ='TDC'   -- QDL.MA ='TDC' Tam dinh chi
                            AND BA.DONID IS NULL  -- chưa có bản án
                            AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                         )
                     --phuc tham Đang tạm đình chỉ                
                        OR EXISTS (
                            SELECT 'X' FROM ALD_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                            LEFT JOIN ALD_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTQDVA.DONID --BẢN ÁN 
                            WHERE PTBA.DONID IS NULL --Vụ án chưa có bản án 
                            AND QDL.MA='TDC' --Tạm đình chỉ
                            AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                            )
                    )  
                )
            OR(item_bc=5 -- Án chờ thụ lý
                   AND ( NOT EXISTS(SELECT 'x' from ALD_SOTHAM_THULY TL where TL.DONID=a.id and GD.MAGIAIDOAN=2) 
                           AND NOT EXISTS(SELECT 'x' from ALD_PHUCTHAM_THULY TL where TL.DONID=a.id and GD.MAGIAIDOAN=3) 
                        ) 
                  -- CHUA CO KET QUA XET XU
                    AND (NOT EXISTS(SELECT 'X' FROM ALD_SOTHAM_BANAN BA WHERE BA.DONID = A.ID)
                    AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM ALD_SOTHAM_QUYETDINH T1 
                                                   INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND T1.DONID=A.ID) )
                                        )
              )
             OR(item_bc=6
                     AND ( EXISTS(SELECT 'x' from ALD_SOTHAM_THULY TL where TL.DONID=a.id and GD.MAGIAIDOAN=2) 
                           OR EXISTS(SELECT 'x' from ALD_PHUCTHAM_THULY TL where TL.DONID=a.id and GD.MAGIAIDOAN=3) 
                        ) 
                     AND NOT EXISTS (
                                SELECT 'x' FROM ALD_DON_THAMPHAN PC 
                                WHERE PC.DONID=A.ID
                                AND ((PC.MAVAITRO='VTTP_GIAIQUYETSOTHAM' AND GD.MAGIAIDOAN=2)--sơ thẩm
                                     OR(PC.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND GD.MAGIAIDOAN=3)--phuc thẩm
                                     )
                               )   
            )  
            -- OR(item_bc=7) 
            OR(item_bc=8
              AND (   
                     EXISTS (       
                                    SELECT 'X' FROM ALD_SOTHAM_BANAN BA
                                    WHERE  BA.SOBANAN IS NOT NULL
                                    AND (BA.NGAYTUYENAN>=to_date('01/'||to_char(sysdate,'MM/yyyy'),'dd/MM/yyyy'))
                                    AND BA.DONID=a.id  AND GD.MAGIAIDOAN=2
                                 )
                            OR  EXISTS (
                                    SELECT 'X' FROM ALD_SOTHAM_QUYETDINH QSV 
                                    INNER JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                    WHERE instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0
                                    AND (QSV.NGAYQD>=to_date('01/'||to_char(sysdate,'MM/yyyy'),'dd/MM/yyyy'))
                                    AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                                )
                            OR EXISTS (
                                    SELECT 'X' FROM ALD_PHUCTHAM_BANAN PTBA 
                                    WHERE  PTBA.SOBANAN IS NOT NULL
                                    AND (PTBA.NGAYTUYENAN>=to_date('01/'||to_char(sysdate,'MM/yyyy'),'dd/MM/yyyy'))
                                    AND PTBA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )
                             OR EXISTS (
                                    SELECT 'X' FROM ALD_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                    WHERE  instr('DC',QDL.MA)>0
                                    AND (PTQDVA.NGAYQD>=to_date('01/'||to_char(sysdate,'MM/yyyy'),'dd/MM/yyyy'))
                                    AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )         
                        )
            ) 
            OR(item_bc=9 
                    AND NOT EXISTS ( SELECT 'X' FROM ALD_DON_XULY XL WHERE XL.DONID=A.ID)  
                -- CHUA CO KET QUA XET XU
                    AND (NOT EXISTS(SELECT 'X' FROM ALD_SOTHAM_BANAN BA WHERE BA.DONID = A.ID)
                    AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM ALD_SOTHAM_QUYETDINH T1 
                                                   INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND T1.DONID=A.ID) )
                                        )
              )
            OR(item_bc=10 
                    AND NOT EXISTS ( SELECT 'X' FROM ALD_DON_XULY XL WHERE XL.DONID=A.ID) 
                          AND (SYSDATE-a.NGAYNHANDON)>8   
                    -- CHUA CO KET QUA XET XU
                    AND (NOT EXISTS(SELECT 'X' FROM ALD_SOTHAM_BANAN BA WHERE BA.DONID = A.ID)
                    AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM ALD_SOTHAM_QUYETDINH T1 
                                                   INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND T1.DONID=A.ID) )
                                        )
              )
             OR(item_bc=11 
                    AND NOT EXISTS ( SELECT 'X' FROM ALD_DON_XULY XL WHERE XL.DONID=A.ID)  
                    AND NOT EXISTS(SELECT 'X' FROM ALD_DON_THAMPHAN TP WHERE TP.DONID=A.ID)  
                    -- CHUA CO KET QUA XET XU
                    AND (NOT EXISTS(SELECT 'X' FROM ALD_SOTHAM_BANAN BA WHERE BA.DONID = A.ID)
                    AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM ALD_SOTHAM_QUYETDINH T1 
                                                   INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND T1.DONID=A.ID) )
                                        )
              )  
          )     
        ; 
        v_table.extend;
        v_table(v_table.count) := R_TDC_THOIHAN_GQ(item_bc,V_TEN_BC,item_bc
        ,0,0,0,0,V_COUNTS,0,
        0,0,0);
        -----AHC_-------
         SELECT COUNT(*) INTO V_COUNTS FROM  AHC_DON A
         INNER JOIN AHC_DON_GIAIDOAN GD ON A.ID=GD.DONID
         WHERE  (GD.TOAANID =v_toaan_id  OR GD.TOAPHUCTHAMID=v_toaan_id)
         AND (V_CAPXX IS NULL OR (GD.MAGIAIDOAN=V_CAPXX AND V_CAPXX IS NOT NULL) )
            AND(
               (item_bc=1
                     AND (EXISTS (
                                        SELECT 'X' FROM AHC_SOTHAM_THULY TL
                                          WHERE (NOT EXISTS(SELECT 'X' FROM AHC_SOTHAM_BANAN BA WHERE TL.DONID =BA.DONID)
                                                AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM AHC_SOTHAM_QUYETDINH T1 
                                                           INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                           WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND TL.DONID=T1.DONID) )
                                                )
                                         AND TL.DONID=a.id  AND GD.MAGIAIDOAN=2
                                       )
                             OR EXISTS (
                                        SELECT 'X' FROM AHC_PHUCTHAM_THULY PTTL 
                                         WHERE (NOT EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
                                                AND NOT EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                                               INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                                               WHERE instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0 AND  PTTL.DONID=PTQDVA.DONID 
                                                               )
                                         )
                                         AND PTTL.DONID=a.id  AND GD.MAGIAIDOAN=3
                                       )
                        )
                 )
               OR(item_bc=2 --Án quá hạn (chưa giải quyết xong)
                     AND (   --dùng ngày bản án hoặc dùng ngày hiện tại và chưa có quyết định gây kết thúc vụ án
                            EXISTS(SELECT 'X' FROM AHC_SOTHAM_THULY TL
                                    LEFT JOIN AHC_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                    LEFT JOIN AHC_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    WHERE
                                      (   ( BA.ID IS NOT NULL AND (BA.NGAYMOPHIENTOA-TL.NGAYTHULY)>180 )
                                          OR( BA.ID IS NULL AND instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 AND (SYSDATE-TL.NGAYTHULY)>180)
                                      )
                                   AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                  )
                           --dùng ngày quyết định và đình chỉ vụ án   
                            OR  EXISTS (SELECT 'X' FROM AHC_SOTHAM_THULY TL
                                        LEFT JOIN AHC_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                        LEFT JOIN AHC_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                        LEFT JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                        WHERE 
                                         (
                                            ( instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')>0 AND  (QSV.NGAYQD-TL.NGAYTHULY)>180  )--'CVA' QĐ chuyển vụ án,'HPT' Hoãn phiên tòa, 'GHTHXX' QĐ gia hạn thời hạn chuẩn bị xét xử
                                           OR
                                            (  instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 AND  BA.ID IS NULL AND (SYSDATE-TL.NGAYTHULY)>180 )
                                         )
                                        AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                     )
                              --dùng ngày bản án phúc thẩm hoặc dùng ngày hiện tại và chưa có quyết định gây kết thúc vụ án  
                            OR EXISTS (
                                    SELECT 'X' FROM AHC_PHUCTHAM_THULY TL 
                                    LEFT JOIN AHC_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AHC_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                    WHERE 
                                     (
                                        (BA.ID IS NOT NULL  AND  (BA.NGAYMOPHIENTOA-TL.NGAYTHULY)>90 )
                                     OR (BA.ID IS  NULL AND instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 AND  (SYSDATE-TL.NGAYTHULY)>90 )
                                     )
                                 AND TL.DONID =a.id AND GD.MAGIAIDOAN=3
                             )
                            --dùng ngày QĐ phúc thẩm  
                              OR EXISTS (
                                    SELECT 'X' FROM AHC_PHUCTHAM_THULY TL 
                                    LEFT JOIN AHC_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QSV.LOAIQDID 
                                    WHERE
                                    (
                                          ( instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')>0  AND(QSV.NGAYQD-TL.NGAYTHULY)>90 ) --QĐ Đình chỉ hoặc QĐ hoãn hoặc QĐ gia hạn thời hạn chuẩn bị xét xử, QĐ chuyển vụ án
                                      OR (  instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0  AND(SYSDATE-TL.NGAYTHULY)>90)
                                    )
                                     AND TL.DONID =a.id AND GD.MAGIAIDOAN=3
                                 ) 
                         )
                   AND --Án chưa giải quyết xong
                   (EXISTS ( 
                                SELECT 'X' FROM AHC_SOTHAM_THULY TL
                                  WHERE (NOT EXISTS(SELECT 'X' FROM AHC_SOTHAM_BANAN BA WHERE TL.DONID =BA.DONID)
                                        AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM AHC_SOTHAM_QUYETDINH T1 
                                                   INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND TL.DONID=T1.DONID) )
                                        )
                                 AND TL.DONID=a.id  AND GD.MAGIAIDOAN=2
                               )
                     OR EXISTS (
                                SELECT 'X' FROM AHC_PHUCTHAM_THULY PTTL 
                                 WHERE (NOT EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
                                        AND NOT EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                                       INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                                       WHERE instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0 AND  PTTL.DONID=PTQDVA.DONID 
                                                       )
                                 )
                                 AND PTTL.DONID=a.id  AND GD.MAGIAIDOAN=3
                               )
                   )
                 )  
              OR (item_bc=3  AND (
                      --Sơ thẩm chưa có quyết định và chưa có bản án
                            EXISTS(SELECT 'X' FROM AHC_SOTHAM_THULY TL
                                    LEFT JOIN AHC_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AHC_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=160 AND (SYSDATE-TL.NGAYTHULY)<180 
                                    AND BA.ID IS NULL
                                    AND (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')IS NULL)
                                    AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                  )
                          --phúc thẩm   
                            OR EXISTS (
                                    SELECT 'X' FROM AHC_PHUCTHAM_THULY TL 
                                    LEFT JOIN AHC_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AHC_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=70 AND (SYSDATE-TL.NGAYTHULY)<90 
                                    AND BA.ID IS NULL
                                    AND  (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')IS NULL)
                                    AND TL.DONID =a.id AND GD.MAGIAIDOAN=3
                                    ) 
                           )          
                ) 
                OR
                (item_bc=4 AND (EXISTS (
                                SELECT 'X' FROM AHC_SOTHAM_THULY TL
                                  WHERE (NOT EXISTS(SELECT 'X' FROM AHC_SOTHAM_BANAN BA WHERE TL.DONID =BA.DONID)
                                        AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM AHC_SOTHAM_QUYETDINH T1 
                                                   INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND TL.DONID=T1.DONID) )
                                        )
                                 AND TL.DONID=a.id  AND GD.MAGIAIDOAN=2
                               )
                     OR EXISTS (
                                SELECT 'X' FROM AHC_PHUCTHAM_THULY PTTL 
                                 WHERE (NOT EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
                                        AND NOT EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                                       INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                                       WHERE instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0 AND  PTTL.DONID=PTQDVA.DONID 
                                                       )
                                 )
                                 AND PTTL.DONID=a.id  AND GD.MAGIAIDOAN=3
                               )
                      )
                   AND 
                   ( --so tham Đang tạm đình chỉ 
                      EXISTS (
                            SELECT 'X' FROM AHC_SOTHAM_QUYETDINH QSV
                            INNER JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID 
                            LEFT JOIN AHC_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                            WHERE QDL.MA ='TDC'   -- QDL.MA ='TDC' Tam dinh chi
                            AND BA.DONID IS NULL  -- chưa có bản án
                            AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                         )
                     --phuc tham Đang tạm đình chỉ                
                        OR EXISTS (
                            SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                            LEFT JOIN AHC_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTQDVA.DONID --BẢN ÁN 
                            WHERE PTBA.DONID IS NULL --Vụ án chưa có bản án 
                            AND QDL.MA='TDC' --Tạm đình chỉ
                            AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                            )
                    ) 
                )
                OR(item_bc=5
                       AND ( NOT EXISTS(SELECT 'x' from AHC_SOTHAM_THULY TL where TL.DONID=a.id and GD.MAGIAIDOAN=2) 
                               AND NOT EXISTS(SELECT 'x' from AHC_PHUCTHAM_THULY TL where TL.DONID=a.id and GD.MAGIAIDOAN=3) 
                            )
                        -- CHUA CO KET QUA XET XU
                        AND (NOT EXISTS(SELECT 'X' FROM AHC_SOTHAM_BANAN BA WHERE BA.DONID = A.ID)
                        AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM AHC_SOTHAM_QUYETDINH T1 
                                                       INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                       WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND T1.DONID=A.ID) )
                                            )
                 ) 
              OR(item_bc=6
                     AND ( EXISTS(SELECT 'x' from AHC_SOTHAM_THULY TL where TL.DONID=a.id and GD.MAGIAIDOAN=2) 
                           OR EXISTS(SELECT 'x' from AHC_PHUCTHAM_THULY TL where TL.DONID=a.id and GD.MAGIAIDOAN=3) 
                        ) 
                     AND NOT EXISTS (
                                SELECT 'x' FROM AHC_DON_THAMPHAN PC 
                                WHERE PC.DONID=A.ID
                                AND ((PC.MAVAITRO='VTTP_GIAIQUYETSOTHAM' AND GD.MAGIAIDOAN=2)--sơ thẩm
                                     OR(PC.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND GD.MAGIAIDOAN=3)--phuc thẩm
                                     )
                               )   
            )   
             -- OR(item_bc=7) 
            OR(item_bc=8
                 AND (   
                     EXISTS (       
                                    SELECT 'X' FROM AHC_SOTHAM_BANAN BA
                                    WHERE  BA.SOBANAN IS NOT NULL
                                    AND (BA.NGAYTUYENAN>=to_date('01/'||to_char(sysdate,'MM/yyyy'),'dd/MM/yyyy'))
                                    AND BA.DONID=a.id  AND GD.MAGIAIDOAN=2
                                 )
                            OR  EXISTS (
                                    SELECT 'X' FROM AHC_SOTHAM_QUYETDINH QSV 
                                    INNER JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                    WHERE instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0
                                    AND (QSV.NGAYQD>=to_date('01/'||to_char(sysdate,'MM/yyyy'),'dd/MM/yyyy'))
                                    AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                                )
                            OR EXISTS (
                                    SELECT 'X' FROM AHC_PHUCTHAM_BANAN PTBA 
                                    WHERE  PTBA.SOBANAN IS NOT NULL
                                    AND (PTBA.NGAYTUYENAN>=to_date('01/'||to_char(sysdate,'MM/yyyy'),'dd/MM/yyyy'))
                                    AND PTBA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )
                             OR EXISTS (
                                    SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                    WHERE  instr('DC',QDL.MA)>0
                                    AND (PTQDVA.NGAYQD>=to_date('01/'||to_char(sysdate,'MM/yyyy'),'dd/MM/yyyy'))
                                    AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )         
                        )
            )
            OR(item_bc=9 
                    AND NOT EXISTS ( SELECT 'X' FROM AHC_DON_XULY XL WHERE XL.DONID=A.ID) 
                     -- CHUA CO KET QUA XET XU
                        AND (NOT EXISTS(SELECT 'X' FROM AHC_SOTHAM_BANAN BA WHERE BA.DONID = A.ID)
                        AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM AHC_SOTHAM_QUYETDINH T1 
                                                       INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                       WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND T1.DONID=A.ID) )
                                            )
              )
            OR(item_bc=10 
                    AND NOT EXISTS ( SELECT 'X' FROM AHC_DON_XULY XL WHERE XL.DONID=A.ID) 
                          AND (SYSDATE-a.NGAYNHANDON)>8  
                     -- CHUA CO KET QUA XET XU
                        AND (NOT EXISTS(SELECT 'X' FROM AHC_SOTHAM_BANAN BA WHERE BA.DONID = A.ID)
                        AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM AHC_SOTHAM_QUYETDINH T1 
                                                       INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                       WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND T1.DONID=A.ID) )
                                            )
              )
             OR(item_bc=11 
                    AND NOT EXISTS ( SELECT 'X' FROM AHC_DON_XULY XL WHERE XL.DONID=A.ID)  
                            AND NOT EXISTS(SELECT 'X' FROM AHC_DON_THAMPHAN TP WHERE TP.DONID=A.ID)   
                     -- CHUA CO KET QUA XET XU
                        AND (NOT EXISTS(SELECT 'X' FROM AHC_SOTHAM_BANAN BA WHERE BA.DONID = A.ID)
                        AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM AHC_SOTHAM_QUYETDINH T1 
                                                       INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                       WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND T1.DONID=A.ID) )
                                            )
              )    
          )     
        ;  
        v_table.extend;
        v_table(v_table.count) := R_TDC_THOIHAN_GQ(item_bc,V_TEN_BC,item_bc
        ,0,0,0,0,0,V_COUNTS,
        0,0,0);
        ------------------
        END LOOP;
        OPEN curReturn FOR
        SELECT PA.STT,PA.LOAI_BC,PA.TEN_BC,DECODE(PA.LOAI_BC,7,null,9,NULL,10,NULL,11,NULL,SUM(PA.COLUMN_1)) COLUMN_1,
         decode(PA.LOAI_BC,7,null,SUM(PA.COLUMN_2)) COLUMN_2,decode(PA.LOAI_BC,7,null,SUM(PA.COLUMN_3)) COLUMN_3 
        ,decode(PA.LOAI_BC,7,null,SUM(PA.COLUMN_4)) COLUMN_4,decode(PA.LOAI_BC,7,null,SUM(PA.COLUMN_5)) COLUMN_5,
         decode(PA.LOAI_BC,7,null,SUM(PA.COLUMN_6)) COLUMN_6 ,NULL COLUMN_7,NULL COLUMN_8,NULL COLUMN_9
        ,decode(PA.LOAI_BC,7,null,SUM(PA.COLUMN_1+PA.COLUMN_2+PA.COLUMN_3+PA.COLUMN_4+PA.COLUMN_5+PA.COLUMN_6))TONG_CONG
        FROM TABLE(v_table) PA 
        GROUP BY PA.STT,PA.LOAI_BC,PA.TEN_BC,NULL
        ORDER BY PA.STT;
END CANHBAO_TDC_THOIHAN;
END PKG_STPT_APP;

/
