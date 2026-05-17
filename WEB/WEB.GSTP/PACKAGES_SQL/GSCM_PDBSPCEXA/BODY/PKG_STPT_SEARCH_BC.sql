--------------------------------------------------------
--  DDL for Package Body PKG_STPT_SEARCH_BC
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_STPT_SEARCH_BC" AS
FUNCTION THSL_XX
(
    V_CANBO_TK_ID  IN VARCHAR2,
    V_LANHDAO_TK_ID  IN VARCHAR2,
    V_CAP_XET_XU_LOGIN  IN VARCHAR2,
    V_TOAAN_ID in varchar2, 
    V_TUNGAY IN VARCHAR2,
    V_DENNGAY IN VARCHAR2,
    V_LOAIAN_ID IN VARCHAR2
)RETURN SYS_REFCURSOR
AS  
    V_CURSOR sys_refcursor;VV_TUNGAY DATE;VV_DENNGAY DATE;
    V_TABLE T_STPT_THSL_XX;V_TABLE_TOTAL T_STPT_THSL_XX;V_COUNT_XX NUMBER;
    V_EXPORT_TEXT CLOB;V_EXPORT_TEXT_ITEM CLOB;V_CANBO_TK_NAME VARCHAR2(255);V_LANHDAO_TK_NAME VARCHAR2(255);
BEGIN	
    DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT_ITEM,true);
    v_table := T_STPT_THSL_XX();  V_TABLE_TOTAL := T_STPT_THSL_XX();
     --
     if(V_TUNGAY IS NOT NULL) then  VV_TUNGAY:=to_date(trim(V_TUNGAY)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(V_DENNGAY IS NOT NULL) then  VV_DENNGAY:=to_date(trim(V_DENNGAY)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if; 
     -------------
     if(V_CANBO_TK_ID is not null)then
        SELECT CB.HOTEN INTO V_CANBO_TK_NAME FROM DM_CANBO CB WHERE CB.ID=V_CANBO_TK_ID;
     else
        V_CANBO_TK_NAME:='';
     end if;
     if(V_LANHDAO_TK_ID is not null)then
         SELECT CB.HOTEN INTO V_LANHDAO_TK_NAME FROM DM_CANBO CB WHERE CB.ID=V_LANHDAO_TK_ID;
      else
        V_LANHDAO_TK_NAME:='';
     end if;
     -------------
     FOR item_bc IN 1..2 --1 án đã giải quyết, 2 án hoãn xử
     LOOP
     -----------------HS-St
     FOR item IN (
           SELECT TPPCPT.THAMPHAN_ID,NVL(CB.PHONGBANID,0)PHONGBANID FROM AHS_VUAN A 
           INNER JOIN AHS_VUAN_GIAIDOAN GD ON A.ID=GD.VUANID
           LEFT JOIN DM_TOAAN B ON A.TOAANID = B.ID
           LEFT JOIN ( SELECT TP.VUANID,DECODE(HD.COUNT_CHUTOA,NULL,CB.ID,HD.TPCHUTOA_ID) THAMPHAN_ID
                        FROM AHS_THAMPHANGIAIQUYET TP
                        LEFT JOIN (select x.VUANID,RTRIM(SUBSTR(x.ID,0,INSTR(x.ID,',',1,1)),',')TPCHUTOA_ID,x.COUNT_CHUTOA 
                                         from (
                                            SELECT XX.VUANID,listagg (CBB.ID,',') WITHIN GROUP (ORDER BY CBB.ID DESC)||','ID
                                                        ,COUNT(*)COUNT_CHUTOA FROM AHS_SOTHAM_HDXX XX
                                                        LEFT JOIN DM_CANBO CBB ON XX.CANBOID=CBB.ID 
                                                        WHERE XX.MAVAITRO='THAMPHAN'
                                                        GROUP BY XX.VUANID
                                           )x
                                   )HD ON HD.VUANID=TP.VUANID
                            ----anhvh add hàm lấy 1 bản ghi mới nhất trong bảng AHS_THAMPHANGIAIQUYET      
                         LEFT JOIN ( SELECT GG.* FROM AHS_THAMPHANGIAIQUYET GG
                                      INNER JOIN (
                                                    SELECT TT.VUANID,RTRIM(SUBSTR(TT.ID,0,INSTR(TT.ID,',',1,1)),',')ID --lấy 1 ID đầu tiên có ngày phân công mới nhất
                                                    FROM (
                                                    SELECT TP.VUANID ,
                                                    LISTAGG (TP.ID, ',') WITHIN GROUP (ORDER BY TP.NGAYNHANPHANCONG DESC)||','ID
                                                    FROM AHS_THAMPHANGIAIQUYET TP 
                                                    GROUP BY TP.VUANID)TT
                                             )TS ON TS.ID=GG.ID
                                    )PCTP_GQ ON PCTP_GQ.VUANID=TP.VUANID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
                        LEFT JOIN DM_CANBO CB ON CB.ID=PCTP_GQ.CANBOID   
                        WHERE TP.MAVAITRO='VTTP_GIAIQUYETSOTHAM'
                        GROUP BY TP.VUANID,DECODE(HD.COUNT_CHUTOA,NULL,CB.ID,HD.TPCHUTOA_ID)
                       )TPPCPT ON TPPCPT.VUANID=A.ID AND GD.MAGIAIDOAN=2
            LEFT JOIN DM_CANBO CB ON CB.ID=TPPCPT.THAMPHAN_ID           
           WHERE 
             (GD.TOAANID =V_TOAAN_ID)
            AND GD.MAGIAIDOAN=2
            AND ( ( item_bc=1   --1 án đã giải quyết
                    AND (   
                            EXISTS (
                                SELECT 'X' FROM  AHS_SOTHAM_BANAN BA 
                                WHERE BA.ID IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR  BA.NGAYBANAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR BA.NGAYBANAN<=VV_DENNGAY)
                                    AND BA.VUANID=A.ID AND GD.MAGIAIDOAN=2
                                 )
                            OR  EXISTS (
                                     SELECT 'X' FROM  AHS_SOTHAM_QUYETDINH_VUAN QSV 
                                         LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                         LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                          WHERE  instr(',DC,CVA,',','||QDL.MA||',')>0
                                          AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                                          AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                          AND QSV.VUANID=A.ID AND GD.MAGIAIDOAN=2
                                )
                         )
                    )
                  OR( item_bc=2 --2 án hoãn xử
                     AND  EXISTS (
                                SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN QSV
                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                WHERE QDL.MA='HPT'   -- QDL.MA ='HPT' --hoãn phiên tòa
                                AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                                AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                AND QSV.VUANID=a.id  AND GD.MAGIAIDOAN=2
                             )
                  ) 
            )
       )       
       LOOP
              IF(item_bc=1)THEN
                   v_table.extend;
                    v_table(v_table.count) := R_STPT_THSL_XX(
                    item.THAMPHAN_ID,item.PHONGBANID
                    ,1,0,0,0,0,0
                    ,0
                    ,0,0,0,0,0,0
                    ,0 ,0
                    );
              ELSE
              v_table.extend;
                    v_table(v_table.count) := R_STPT_THSL_XX(
                    item.THAMPHAN_ID,item.PHONGBANID
                    ,0,0,0,0,0,0
                    ,0
                    ,1,0,0,0,0,0
                    ,0,0
                    );   
              END IF;
       END LOOP;
     -----------------HS-pt
     FOR item IN (
           SELECT TPPCPT.THAMPHAN_ID,NVL(CB.PHONGBANID,0)PHONGBANID FROM AHS_VUAN A 
           INNER JOIN AHS_VUAN_GIAIDOAN GD ON A.ID=GD.VUANID
           LEFT JOIN DM_TOAAN B ON A.TOAANID = B.ID
           LEFT JOIN ( SELECT TP.VUANID,TO_CHAR(DECODE(HD.COUNT_CHUTOA,NULL,CB.ID,HD.TPCHUTOA_ID)) THAMPHAN_ID
                        FROM AHS_THAMPHANGIAIQUYET TP
                        LEFT JOIN (
                        select x.VUANID,RTRIM(SUBSTR(x.ID,0,INSTR(x.ID,',',1,1)),',')TPCHUTOA_ID,x.COUNT_CHUTOA 
                                         from (
                                            SELECT XX.VUANID,listagg (CBB.ID,',') WITHIN GROUP (ORDER BY CBB.ID DESC)||','ID
                                                        ,COUNT(*)COUNT_CHUTOA FROM AHS_PHUCTHAM_HDXX XX
                                                        LEFT JOIN DM_CANBO CBB ON XX.CANBOID=CBB.ID 
                                                        WHERE XX.MAVAITRO='THAMPHAN'
                                                        GROUP BY XX.VUANID
                                           )x
                                   )HD ON HD.VUANID=TP.VUANID
                            ----anhvh add hàm lấy 1 bản ghi mới nhất trong bảng AHS_THAMPHANGIAIQUYET      
                         LEFT JOIN ( SELECT GG.* FROM AHS_THAMPHANGIAIQUYET GG
                                      INNER JOIN (
                                                    SELECT TT.VUANID,RTRIM(SUBSTR(TT.ID,0,INSTR(TT.ID,',',1,1)),',')ID --lấy 1 ID đầu tiên có ngày phân công mới nhất
                                                    FROM (
                                                    SELECT TP.VUANID ,
                                                    LISTAGG (TP.ID, ',') WITHIN GROUP (ORDER BY TP.NGAYNHANPHANCONG DESC)||','ID
                                                    FROM AHS_THAMPHANGIAIQUYET TP 
                                                    GROUP BY TP.VUANID)TT
                                             )TS ON TS.ID=GG.ID
                                    )PCTP_GQ ON PCTP_GQ.VUANID=TP.VUANID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
                        LEFT JOIN DM_CANBO CB ON CB.ID=PCTP_GQ.CANBOID   
                        WHERE TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                        GROUP BY TP.VUANID,TO_CHAR(DECODE(HD.COUNT_CHUTOA,NULL,CB.ID,HD.TPCHUTOA_ID))
                       )TPPCPT ON TPPCPT.VUANID=A.ID AND GD.MAGIAIDOAN=3
              LEFT JOIN DM_CANBO CB ON CB.ID=TPPCPT.THAMPHAN_ID           
           WHERE 
             (GD.TOAPHUCTHAMID=V_TOAAN_ID)
             AND GD.MAGIAIDOAN=3
             AND( 
                     (
                             item_bc=1  
                             AND(       
                                             EXISTS (
                                                    SELECT 'X' FROM AHS_PHUCTHAM_BANAN PTBA
                                                    WHERE  PTBA.ID IS NOT NULL
                                                    AND (V_TUNGAY IS NULL OR  PTBA.NGAYBANAN>=VV_TUNGAY)
                                                    AND (V_DENNGAY IS NULL OR PTBA.NGAYBANAN<=VV_DENNGAY)
                                                    AND PTBA.VUANID=A.ID  AND GD.MAGIAIDOAN=3
                                                    )
                                             OR EXISTS (
                                                    SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA 
                                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID  
                                                    WHERE (QDL.MA='DC') --Đình chỉ
                                                    AND (V_TUNGAY IS NULL OR  PTQDVA.NGAYQD>=VV_TUNGAY)
                                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                                    AND PTQDVA.VUANID=A.ID  AND GD.MAGIAIDOAN=3
                                                    )
                                 )
                         )
                    OR(
                      item_bc=2 
                      AND EXISTS (
                            SELECT 'X' FROM  AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID  
                            WHERE INSTR('HPT',QDL.MA)>0 --hoãn phiên tòa
                            AND (V_TUNGAY IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                            AND PTQDVA.VUANID=a.id  AND GD.MAGIAIDOAN=3
                        )     
                    )
                 )
       )       
       LOOP
                  IF(item_bc=1)THEN
                   v_table.extend;
                    v_table(v_table.count) := R_STPT_THSL_XX(
                    item.THAMPHAN_ID,item.PHONGBANID
                    ,1,0,0,0,0,0
                    ,0
                    ,0,0,0,0,0,0
                    ,0,0
                    );
              ELSE
              v_table.extend;
                    v_table(v_table.count) := R_STPT_THSL_XX(
                    item.THAMPHAN_ID,item.PHONGBANID
                    ,0,0,0,0,0,0
                    ,0
                    ,1,0,0,0,0,0
                    ,0,0
                    );   
              END IF;
       END LOOP;
     -----------------DS-ST
     FOR item IN (
             SELECT TPPCPT.THAMPHAN_ID,NVL(CB.PHONGBANID,0)PHONGBANID
             FROM ADS_DON A
              INNER JOIN ADS_DON_GIAIDOAN GD ON A.ID=GD.DONID
              LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
               LEFT JOIN ( SELECT TP.DONID,DECODE(HD.COUNT_CHUTOA,NULL,CB.ID,HD.TPCHUTOA_ID) THAMPHAN_ID
                        FROM ADS_DON_THAMPHAN TP
                        LEFT JOIN (select x.DONID,RTRIM(SUBSTR(x.ID,0,INSTR(x.ID,',',1,1)),',')TPCHUTOA_ID,x.COUNT_CHUTOA 
                                         from (
                                            SELECT XX.DONID,listagg (CBB.ID,',') WITHIN GROUP (ORDER BY CBB.ID DESC)||','ID
                                                        ,COUNT(*)COUNT_CHUTOA FROM ADS_SOTHAM_HDXX XX
                                                        LEFT JOIN DM_CANBO CBB ON XX.CANBOID=CBB.ID 
                                                        WHERE XX.MAVAITRO='THAMPHAN'
                                                        GROUP BY XX.DONID
                                           )x
                                   )HD ON HD.DONID=TP.DONID
                            ----anhvh add hàm lấy 1 bản ghi mới nhất trong bảng AHS_THAMPHANGIAIQUYET      
                         LEFT JOIN ( SELECT GG.* FROM ADS_DON_THAMPHAN GG
                                      INNER JOIN (
                                                    SELECT TT.DONID,RTRIM(SUBSTR(TT.ID,0,INSTR(TT.ID,',',1,1)),',')ID --lấy 1 ID đầu tiên có ngày phân công mới nhất
                                                    FROM (
                                                    SELECT TP.DONID ,
                                                    LISTAGG (TP.ID, ',') WITHIN GROUP (ORDER BY TP.NGAYNHANPHANCONG DESC)||','ID
                                                    FROM ADS_DON_THAMPHAN TP 
                                                    GROUP BY TP.DONID)TT
                                             )TS ON TS.ID=GG.ID
                                    )PCTP_GQ ON PCTP_GQ.DONID=TP.DONID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
                        LEFT JOIN DM_CANBO CB ON CB.ID=PCTP_GQ.CANBOID   
                        WHERE TP.MAVAITRO='VTTP_GIAIQUYETSOTHAM'
                        GROUP BY TP.DONID,DECODE(HD.COUNT_CHUTOA,NULL,CB.ID,HD.TPCHUTOA_ID)
                       )TPPCPT ON TPPCPT.DONID=A.ID AND GD.MAGIAIDOAN=2
            LEFT JOIN DM_CANBO CB ON CB.ID=TPPCPT.THAMPHAN_ID         
            WHERE 
             (GD.TOAANID =V_TOAAN_ID)
             AND GD.MAGIAIDOAN=2 
             AND (
                   (item_bc=1  
                   AND (   
                           EXISTS (       
                                    SELECT 'X' FROM ADS_SOTHAM_BANAN BA
                                    WHERE  BA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR BA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR BA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND BA.DONID=a.id  AND GD.MAGIAIDOAN=2
                                 )
                            OR  EXISTS (
                                    SELECT 'X' FROM ADS_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    WHERE instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0
                                    AND (V_TUNGAY IS NULL OR QSV.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                    AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                                )
                        )
                    )
                 OR
                  (item_bc=2  
                   AND   EXISTS (
                            SELECT 'X' FROM ADS_SOTHAM_QUYETDINH QSV
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                            LEFT JOIN ADS_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                            WHERE QDL.MA ='HPT' AND BA.ID IS NULL   -- QDL.MA ='HPT' --hoãn phiên tòa
                            AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                            AND QSV.DONID=A.ID AND GD.MAGIAIDOAN=2
                         )
                    )
                )
        )
     LOOP
                   IF(item_bc=1)THEN
                   v_table.extend;
                    v_table(v_table.count) := R_STPT_THSL_XX(
                    item.THAMPHAN_ID,item.PHONGBANID
                    ,0,1,0,0,0,0
                    ,0
                    ,0,0,0,0,0,0
                    ,0,0
                    );
              ELSE
              v_table.extend;
                    v_table(v_table.count) := R_STPT_THSL_XX(
                    item.THAMPHAN_ID,item.PHONGBANID
                    ,0,0,0,0,0,0
                    ,0
                    ,0,1,0,0,0,0
                    ,0,0
                    );   
              END IF; 
     END LOOP;
     -----------------DS-PT
     FOR item IN (
             SELECT TPPCPT.THAMPHAN_ID,NVL(CB.PHONGBANID,0)PHONGBANID
             FROM ADS_DON A
              INNER JOIN ADS_DON_GIAIDOAN GD ON A.ID=GD.DONID
              LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
               LEFT JOIN ( SELECT TP.DONID,DECODE(HD.COUNT_CHUTOA,NULL,CB.ID,HD.TPCHUTOA_ID) THAMPHAN_ID
                        FROM ADS_DON_THAMPHAN TP
                        LEFT JOIN (select x.DONID,RTRIM(SUBSTR(x.ID,0,INSTR(x.ID,',',1,1)),',')TPCHUTOA_ID,x.COUNT_CHUTOA 
                                         from (
                                            SELECT XX.DONID,listagg (CBB.ID,',') WITHIN GROUP (ORDER BY CBB.ID DESC)||','ID
                                                        ,COUNT(*)COUNT_CHUTOA FROM ADS_PHUCTHAM_HDXX XX
                                                        LEFT JOIN DM_CANBO CBB ON XX.CANBOID=CBB.ID 
                                                        WHERE XX.MAVAITRO='THAMPHAN'
                                                        GROUP BY XX.DONID
                                           )x
                                   )HD ON HD.DONID=TP.DONID
                            ----anhvh add hàm lấy 1 bản ghi mới nhất trong bảng AHS_THAMPHANGIAIQUYET      
                         LEFT JOIN ( SELECT GG.* FROM ADS_DON_THAMPHAN GG
                                      INNER JOIN (
                                                    SELECT TT.DONID,RTRIM(SUBSTR(TT.ID,0,INSTR(TT.ID,',',1,1)),',')ID --lấy 1 ID đầu tiên có ngày phân công mới nhất
                                                    FROM (
                                                    SELECT TP.DONID ,
                                                    LISTAGG (TP.ID, ',') WITHIN GROUP (ORDER BY TP.NGAYNHANPHANCONG DESC)||','ID
                                                    FROM ADS_DON_THAMPHAN TP 
                                                    GROUP BY TP.DONID)TT
                                             )TS ON TS.ID=GG.ID
                                    )PCTP_GQ ON PCTP_GQ.DONID=TP.DONID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
                        LEFT JOIN DM_CANBO CB ON CB.ID=PCTP_GQ.CANBOID   
                        WHERE TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                        GROUP BY TP.DONID,DECODE(HD.COUNT_CHUTOA,NULL,CB.ID,HD.TPCHUTOA_ID)
                       )TPPCPT ON TPPCPT.DONID=A.ID AND GD.MAGIAIDOAN=3
                LEFT JOIN DM_CANBO CB ON CB.ID=TPPCPT.THAMPHAN_ID         
              WHERE 
              (GD.TOAPHUCTHAMID=V_TOAAN_ID)
             AND GD.MAGIAIDOAN=3    
             AND (       
                        (item_bc=1  
                          AND (  
                                EXISTS (
                                        SELECT 'X' FROM ADS_PHUCTHAM_BANAN PTBA 
                                        WHERE  PTBA.SOBANAN IS NOT NULL
                                        AND (V_TUNGAY IS NULL OR PTBA.NGAYTUYENAN>=VV_TUNGAY)
                                        AND (V_DENNGAY IS NULL OR PTBA.NGAYTUYENAN<=VV_DENNGAY)
                                        AND PTBA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                        )
                                 OR EXISTS (
                                        SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH PTQDVA 
                                        LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                                        LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID  
                                        WHERE  instr('DC',QDL.MA)>0
                                        AND (V_TUNGAY IS NULL OR PTQDVA.NGAYQD>=VV_TUNGAY)
                                        AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                        AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                        )         
                             )
                        )
                     OR(item_bc=2 
                      AND EXISTS (
                            SELECT  'X' FROM   ADS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN ADS_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                            LEFT JOIN ADS_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID  
                            WHERE PTBA.DONID IS NULL  AND QDL.MA='HPT' --Vụ án chưa có bản án  --hoãn phiên tòa 
                            AND (V_TUNGAY IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                            AND PTQDVA.DONID=A.ID AND GD.MAGIAIDOAN=3
                            )    
                     )
                )
        )
     LOOP
                    IF(item_bc=1)THEN
                   v_table.extend;
                    v_table(v_table.count) := R_STPT_THSL_XX(
                    item.THAMPHAN_ID,item.PHONGBANID
                    ,0,1,0,0,0,0
                    ,0
                    ,0,0,0,0,0,0
                    ,0,0
                    );
              ELSE
              v_table.extend;
                    v_table(v_table.count) := R_STPT_THSL_XX(
                    item.THAMPHAN_ID,item.PHONGBANID
                    ,0,0,0,0,0,0
                    ,0
                    ,0,1,0,0,0,0
                    ,0,0
                    );   
              END IF;  
     END LOOP;
     -----------------AHN-ST
     FOR item IN (
             SELECT TPPCPT.THAMPHAN_ID,NVL(CB.PHONGBANID,0)PHONGBANID
             FROM AHN_DON A
              INNER JOIN AHN_DON_GIAIDOAN GD ON A.ID=GD.DONID
              LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
               LEFT JOIN ( SELECT TP.DONID,DECODE(HD.COUNT_CHUTOA,NULL,CB.ID,HD.TPCHUTOA_ID) THAMPHAN_ID
                        FROM AHN_DON_THAMPHAN TP
                        LEFT JOIN (select x.DONID,RTRIM(SUBSTR(x.ID,0,INSTR(x.ID,',',1,1)),',')TPCHUTOA_ID,x.COUNT_CHUTOA 
                                         from (
                                            SELECT XX.DONID,listagg (CBB.ID,',') WITHIN GROUP (ORDER BY CBB.ID DESC)||','ID
                                                        ,COUNT(*)COUNT_CHUTOA FROM AHN_SOTHAM_HDXX XX
                                                        LEFT JOIN DM_CANBO CBB ON XX.CANBOID=CBB.ID 
                                                        WHERE XX.MAVAITRO='THAMPHAN'
                                                        GROUP BY XX.DONID
                                           )x
                                   )HD ON HD.DONID=TP.DONID
                            ----anhvh add hàm lấy 1 bản ghi mới nhất trong bảng AHS_THAMPHANGIAIQUYET      
                         LEFT JOIN ( SELECT GG.* FROM AHN_DON_THAMPHAN GG
                                      INNER JOIN (
                                                    SELECT TT.DONID,RTRIM(SUBSTR(TT.ID,0,INSTR(TT.ID,',',1,1)),',')ID --lấy 1 ID đầu tiên có ngày phân công mới nhất
                                                    FROM (
                                                    SELECT TP.DONID ,
                                                    LISTAGG (TP.ID, ',') WITHIN GROUP (ORDER BY TP.NGAYNHANPHANCONG DESC)||','ID
                                                    FROM AHN_DON_THAMPHAN TP 
                                                    GROUP BY TP.DONID)TT
                                             )TS ON TS.ID=GG.ID
                                    )PCTP_GQ ON PCTP_GQ.DONID=TP.DONID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
                        LEFT JOIN DM_CANBO CB ON CB.ID=PCTP_GQ.CANBOID   
                        WHERE TP.MAVAITRO='VTTP_GIAIQUYETSOTHAM'
                        GROUP BY TP.DONID,DECODE(HD.COUNT_CHUTOA,NULL,CB.ID,HD.TPCHUTOA_ID)
                       )TPPCPT ON TPPCPT.DONID=A.ID AND GD.MAGIAIDOAN=2
            LEFT JOIN DM_CANBO CB ON CB.ID=TPPCPT.THAMPHAN_ID         
            WHERE 
             (GD.TOAANID =V_TOAAN_ID)
             AND GD.MAGIAIDOAN=2 
             AND (
                   (item_bc=1  
                   AND (   
                           EXISTS (       
                                    SELECT 'X' FROM AHN_SOTHAM_BANAN BA
                                    WHERE  BA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR BA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR BA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND BA.DONID=a.id  AND GD.MAGIAIDOAN=2
                                 )
                            OR  EXISTS (
                                    SELECT 'X' FROM AHN_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    WHERE instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0
                                    AND (V_TUNGAY IS NULL OR QSV.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                    AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                                )
                        )
                    )
                 OR
                  (item_bc=2  
                   AND   EXISTS (
                            SELECT 'X' FROM AHN_SOTHAM_QUYETDINH QSV
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                            LEFT JOIN AHN_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                            WHERE QDL.MA ='HPT' AND BA.ID IS NULL   -- QDL.MA ='HPT' --hoãn phiên tòa
                            AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                            AND QSV.DONID=A.ID AND GD.MAGIAIDOAN=2
                         )
                    )
                )
        )
     LOOP
                   IF(item_bc=1)THEN
                   v_table.extend;
                    v_table(v_table.count) := R_STPT_THSL_XX(
                    item.THAMPHAN_ID,item.PHONGBANID
                    ,0,0,1,0,0,0
                    ,0
                    ,0,0,0,0,0,0
                    ,0,0
                    );
              ELSE
              v_table.extend;
                    v_table(v_table.count) := R_STPT_THSL_XX(
                    item.THAMPHAN_ID,item.PHONGBANID
                    ,0,0,0,0,0,0
                    ,0
                    ,0,0,1,0,0,0
                    ,0,0
                    );   
              END IF; 
     END LOOP;
     -----------------AHN-PT
     FOR item IN (
             SELECT TPPCPT.THAMPHAN_ID,NVL(CB.PHONGBANID,0)PHONGBANID
             FROM AHN_DON A
              INNER JOIN AHN_DON_GIAIDOAN GD ON A.ID=GD.DONID
              LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
               LEFT JOIN ( SELECT TP.DONID,DECODE(HD.COUNT_CHUTOA,NULL,CB.ID,HD.TPCHUTOA_ID) THAMPHAN_ID
                        FROM AHN_DON_THAMPHAN TP
                        LEFT JOIN (select x.DONID,RTRIM(SUBSTR(x.ID,0,INSTR(x.ID,',',1,1)),',')TPCHUTOA_ID,x.COUNT_CHUTOA 
                                         from (
                                            SELECT XX.DONID,listagg (CBB.ID,',') WITHIN GROUP (ORDER BY CBB.ID DESC)||','ID
                                                        ,COUNT(*)COUNT_CHUTOA FROM AHN_PHUCTHAM_HDXX XX
                                                        LEFT JOIN DM_CANBO CBB ON XX.CANBOID=CBB.ID 
                                                        WHERE XX.MAVAITRO='THAMPHAN'
                                                        GROUP BY XX.DONID
                                           )x
                                   )HD ON HD.DONID=TP.DONID
                            ----anhvh add hàm lấy 1 bản ghi mới nhất trong bảng AHS_THAMPHANGIAIQUYET      
                         LEFT JOIN ( SELECT GG.* FROM AHN_DON_THAMPHAN GG
                                      INNER JOIN (
                                                    SELECT TT.DONID,RTRIM(SUBSTR(TT.ID,0,INSTR(TT.ID,',',1,1)),',')ID --lấy 1 ID đầu tiên có ngày phân công mới nhất
                                                    FROM (
                                                    SELECT TP.DONID ,
                                                    LISTAGG (TP.ID, ',') WITHIN GROUP (ORDER BY TP.NGAYNHANPHANCONG DESC)||','ID
                                                    FROM AHN_DON_THAMPHAN TP 
                                                    GROUP BY TP.DONID)TT
                                             )TS ON TS.ID=GG.ID
                                    )PCTP_GQ ON PCTP_GQ.DONID=TP.DONID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
                        LEFT JOIN DM_CANBO CB ON CB.ID=PCTP_GQ.CANBOID   
                        WHERE TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                        GROUP BY TP.DONID,DECODE(HD.COUNT_CHUTOA,NULL,CB.ID,HD.TPCHUTOA_ID)
                       )TPPCPT ON TPPCPT.DONID=A.ID AND GD.MAGIAIDOAN=3
                LEFT JOIN DM_CANBO CB ON CB.ID=TPPCPT.THAMPHAN_ID         
              WHERE 
              (GD.TOAPHUCTHAMID=V_TOAAN_ID)
             AND GD.MAGIAIDOAN=3    
             AND (       
                        (item_bc=1  
                          AND (  
                                EXISTS (
                                        SELECT 'X' FROM AHN_PHUCTHAM_BANAN PTBA 
                                        WHERE  PTBA.SOBANAN IS NOT NULL
                                        AND (V_TUNGAY IS NULL OR PTBA.NGAYTUYENAN>=VV_TUNGAY)
                                        AND (V_DENNGAY IS NULL OR PTBA.NGAYTUYENAN<=VV_DENNGAY)
                                        AND PTBA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                        )
                                 OR EXISTS (
                                        SELECT 'X' FROM AHN_PHUCTHAM_QUYETDINH PTQDVA 
                                        LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                                        LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                                        LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID  
                                        WHERE  instr('DC',QDL.MA)>0
                                        AND (V_TUNGAY IS NULL OR PTQDVA.NGAYQD>=VV_TUNGAY)
                                        AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                        AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                        )         
                             )
                        )
                     OR(item_bc=2 
                      AND EXISTS (
                            SELECT  'X' FROM   AHN_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN AHN_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                            LEFT JOIN AHN_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID  
                            WHERE PTBA.DONID IS NULL  AND QDL.MA='HPT' --Vụ án chưa có bản án  --hoãn phiên tòa 
                            AND (V_TUNGAY IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                            AND PTQDVA.DONID=A.ID AND GD.MAGIAIDOAN=3
                            )    
                     )
                )
        )
     LOOP
                     IF(item_bc=1)THEN
                   v_table.extend;
                    v_table(v_table.count) := R_STPT_THSL_XX(
                    item.THAMPHAN_ID,item.PHONGBANID
                    ,0,0,1,0,0,0
                    ,0
                    ,0,0,0,0,0,0
                    ,0,0
                    );
              ELSE
              v_table.extend;
                    v_table(v_table.count) := R_STPT_THSL_XX(
                    item.THAMPHAN_ID,item.PHONGBANID
                    ,0,0,0,0,0,0
                    ,0
                    ,0,0,1,0,0,0
                    ,0,0
                    );   
              END IF; 
     END LOOP;
     -----------------AKT-ST
     FOR item IN (
             SELECT TPPCPT.THAMPHAN_ID,NVL(CB.PHONGBANID,0)PHONGBANID
             FROM AKT_DON A
              INNER JOIN AKT_DON_GIAIDOAN GD ON A.ID=GD.DONID
              LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
               LEFT JOIN ( SELECT TP.DONID,DECODE(HD.COUNT_CHUTOA,NULL,CB.ID,HD.TPCHUTOA_ID) THAMPHAN_ID
                        FROM AKT_DON_THAMPHAN TP
                        LEFT JOIN (select x.DONID,RTRIM(SUBSTR(x.ID,0,INSTR(x.ID,',',1,1)),',')TPCHUTOA_ID,x.COUNT_CHUTOA 
                                         from (
                                            SELECT XX.DONID,listagg (CBB.ID,',') WITHIN GROUP (ORDER BY CBB.ID DESC)||','ID
                                                        ,COUNT(*)COUNT_CHUTOA FROM AKT_SOTHAM_HDXX XX
                                                        LEFT JOIN DM_CANBO CBB ON XX.CANBOID=CBB.ID 
                                                        WHERE XX.MAVAITRO='THAMPHAN'
                                                        GROUP BY XX.DONID
                                           )x
                                   )HD ON HD.DONID=TP.DONID
                            ----anhvh add hàm lấy 1 bản ghi mới nhất trong bảng AHS_THAMPHANGIAIQUYET      
                         LEFT JOIN ( SELECT GG.* FROM AKT_DON_THAMPHAN GG
                                      INNER JOIN (
                                                    SELECT TT.DONID,RTRIM(SUBSTR(TT.ID,0,INSTR(TT.ID,',',1,1)),',')ID --lấy 1 ID đầu tiên có ngày phân công mới nhất
                                                    FROM (
                                                    SELECT TP.DONID ,
                                                    LISTAGG (TP.ID, ',') WITHIN GROUP (ORDER BY TP.NGAYNHANPHANCONG DESC)||','ID
                                                    FROM AKT_DON_THAMPHAN TP 
                                                    GROUP BY TP.DONID)TT
                                             )TS ON TS.ID=GG.ID
                                    )PCTP_GQ ON PCTP_GQ.DONID=TP.DONID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
                        LEFT JOIN DM_CANBO CB ON CB.ID=PCTP_GQ.CANBOID   
                        WHERE TP.MAVAITRO='VTTP_GIAIQUYETSOTHAM'
                        GROUP BY TP.DONID,DECODE(HD.COUNT_CHUTOA,NULL,CB.ID,HD.TPCHUTOA_ID)
                       )TPPCPT ON TPPCPT.DONID=A.ID AND GD.MAGIAIDOAN=2
            LEFT JOIN DM_CANBO CB ON CB.ID=TPPCPT.THAMPHAN_ID         
            WHERE 
             (GD.TOAANID =V_TOAAN_ID)
             AND GD.MAGIAIDOAN=2 
             AND (
                   (item_bc=1  
                   AND (   
                           EXISTS (       
                                    SELECT 'X' FROM AKT_SOTHAM_BANAN BA
                                    WHERE  BA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR BA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR BA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND BA.DONID=a.id  AND GD.MAGIAIDOAN=2
                                 )
                            OR  EXISTS (
                                    SELECT 'X' FROM AKT_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    WHERE instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0
                                    AND (V_TUNGAY IS NULL OR QSV.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                    AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                                )
                        )
                    )
                 OR
                  (item_bc=2  
                   AND   EXISTS (
                            SELECT 'X' FROM AKT_SOTHAM_QUYETDINH QSV
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                            LEFT JOIN AKT_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                            WHERE QDL.MA ='HPT' AND BA.ID IS NULL   -- QDL.MA ='HPT' --hoãn phiên tòa
                            AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                            AND QSV.DONID=A.ID AND GD.MAGIAIDOAN=2
                         )
                    )
                )
        )
     LOOP
                   IF(item_bc=1)THEN
                   v_table.extend;
                    v_table(v_table.count) := R_STPT_THSL_XX(
                    item.THAMPHAN_ID,item.PHONGBANID
                    ,0,0,0,1,0,0
                    ,0
                    ,0,0,0,0,0,0
                    ,0,0
                    );
              ELSE
              v_table.extend;
                    v_table(v_table.count) := R_STPT_THSL_XX(
                    item.THAMPHAN_ID,item.PHONGBANID
                    ,0,0,0,0,0,0
                    ,0
                    ,0,0,0,1,0,0
                    ,0,0
                    );   
              END IF; 
     END LOOP;
     -----------------AKT-PT
     FOR item IN (
             SELECT TPPCPT.THAMPHAN_ID,NVL(CB.PHONGBANID,0)PHONGBANID
             FROM AKT_DON A
              INNER JOIN AKT_DON_GIAIDOAN GD ON A.ID=GD.DONID
              LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
               LEFT JOIN ( SELECT TP.DONID,DECODE(HD.COUNT_CHUTOA,NULL,CB.ID,HD.TPCHUTOA_ID) THAMPHAN_ID
                        FROM AKT_DON_THAMPHAN TP
                        LEFT JOIN (select x.DONID,RTRIM(SUBSTR(x.ID,0,INSTR(x.ID,',',1,1)),',')TPCHUTOA_ID,x.COUNT_CHUTOA 
                                         from (
                                            SELECT XX.DONID,listagg (CBB.ID,',') WITHIN GROUP (ORDER BY CBB.ID DESC)||','ID
                                                        ,COUNT(*)COUNT_CHUTOA FROM AKT_PHUCTHAM_HDXX XX
                                                        LEFT JOIN DM_CANBO CBB ON XX.CANBOID=CBB.ID 
                                                        WHERE XX.MAVAITRO='THAMPHAN'
                                                        GROUP BY XX.DONID
                                           )x
                                   )HD ON HD.DONID=TP.DONID
                            ----anhvh add hàm lấy 1 bản ghi mới nhất trong bảng AHS_THAMPHANGIAIQUYET      
                         LEFT JOIN ( SELECT GG.* FROM AKT_DON_THAMPHAN GG
                                      INNER JOIN (
                                                    SELECT TT.DONID,RTRIM(SUBSTR(TT.ID,0,INSTR(TT.ID,',',1,1)),',')ID --lấy 1 ID đầu tiên có ngày phân công mới nhất
                                                    FROM (
                                                    SELECT TP.DONID ,
                                                    LISTAGG (TP.ID, ',') WITHIN GROUP (ORDER BY TP.NGAYNHANPHANCONG DESC)||','ID
                                                    FROM AKT_DON_THAMPHAN TP 
                                                    GROUP BY TP.DONID)TT
                                             )TS ON TS.ID=GG.ID
                                    )PCTP_GQ ON PCTP_GQ.DONID=TP.DONID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
                        LEFT JOIN DM_CANBO CB ON CB.ID=PCTP_GQ.CANBOID   
                        WHERE TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                        GROUP BY TP.DONID,DECODE(HD.COUNT_CHUTOA,NULL,CB.ID,HD.TPCHUTOA_ID)
                       )TPPCPT ON TPPCPT.DONID=A.ID AND GD.MAGIAIDOAN=3
                LEFT JOIN DM_CANBO CB ON CB.ID=TPPCPT.THAMPHAN_ID         
              WHERE 
              (GD.TOAPHUCTHAMID=V_TOAAN_ID)
             AND GD.MAGIAIDOAN=3    
             AND (       
                        (item_bc=1  
                          AND (  
                                EXISTS (
                                        SELECT 'X' FROM AKT_PHUCTHAM_BANAN PTBA 
                                        WHERE  PTBA.SOBANAN IS NOT NULL
                                        AND (V_TUNGAY IS NULL OR PTBA.NGAYTUYENAN>=VV_TUNGAY)
                                        AND (V_DENNGAY IS NULL OR PTBA.NGAYTUYENAN<=VV_DENNGAY)
                                        AND PTBA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                        )
                                 OR EXISTS (
                                        SELECT 'X' FROM AKT_PHUCTHAM_QUYETDINH PTQDVA 
                                        LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                                        LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                                        LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID  
                                        WHERE  instr('DC',QDL.MA)>0
                                        AND (V_TUNGAY IS NULL OR PTQDVA.NGAYQD>=VV_TUNGAY)
                                        AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                        AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                        )         
                             )
                        )
                     OR(item_bc=2 
                      AND EXISTS (
                            SELECT  'X' FROM   AKT_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN AKT_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                            LEFT JOIN AKT_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID  
                            WHERE PTBA.DONID IS NULL  AND QDL.MA='HPT' --Vụ án chưa có bản án  --hoãn phiên tòa 
                            AND (V_TUNGAY IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                            AND PTQDVA.DONID=A.ID AND GD.MAGIAIDOAN=3
                            )    
                     )
                )
        )
     LOOP
                 IF(item_bc=1)THEN
                   v_table.extend;
                    v_table(v_table.count) := R_STPT_THSL_XX(
                    item.THAMPHAN_ID,item.PHONGBANID
                    ,0,0,0,1,0,0
                    ,0
                    ,0,0,0,0,0,0
                    ,0,0
                    );
              ELSE
              v_table.extend;
                    v_table(v_table.count) := R_STPT_THSL_XX(
                    item.THAMPHAN_ID,item.PHONGBANID
                    ,0,0,0,0,0,0
                    ,0
                    ,0,0,0,1,0,0
                    ,0,0
                    );   
              END IF; 
     END LOOP;
          -----------------ALD-ST
     FOR item IN (
             SELECT TPPCPT.THAMPHAN_ID,NVL(CB.PHONGBANID,0)PHONGBANID
             FROM ALD_DON A
              INNER JOIN ALD_DON_GIAIDOAN GD ON A.ID=GD.DONID
              LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
               LEFT JOIN ( SELECT TP.DONID,DECODE(HD.COUNT_CHUTOA,NULL,CB.ID,HD.TPCHUTOA_ID) THAMPHAN_ID
                        FROM ALD_DON_THAMPHAN TP
                        LEFT JOIN (select x.DONID,RTRIM(SUBSTR(x.ID,0,INSTR(x.ID,',',1,1)),',')TPCHUTOA_ID,x.COUNT_CHUTOA 
                                         from (
                                            SELECT XX.DONID,listagg (CBB.ID,',') WITHIN GROUP (ORDER BY CBB.ID DESC)||','ID
                                                        ,COUNT(*)COUNT_CHUTOA FROM ALD_SOTHAM_HDXX XX
                                                        LEFT JOIN DM_CANBO CBB ON XX.CANBOID=CBB.ID 
                                                        WHERE XX.MAVAITRO='THAMPHAN'
                                                        GROUP BY XX.DONID
                                           )x
                                   )HD ON HD.DONID=TP.DONID
                            ----anhvh add hàm lấy 1 bản ghi mới nhất trong bảng AHS_THAMPHANGIAIQUYET      
                         LEFT JOIN ( SELECT GG.* FROM ALD_DON_THAMPHAN GG
                                      INNER JOIN (
                                                    SELECT TT.DONID,RTRIM(SUBSTR(TT.ID,0,INSTR(TT.ID,',',1,1)),',')ID --lấy 1 ID đầu tiên có ngày phân công mới nhất
                                                    FROM (
                                                    SELECT TP.DONID ,
                                                    LISTAGG (TP.ID, ',') WITHIN GROUP (ORDER BY TP.NGAYNHANPHANCONG DESC)||','ID
                                                    FROM ALD_DON_THAMPHAN TP 
                                                    GROUP BY TP.DONID)TT
                                             )TS ON TS.ID=GG.ID
                                    )PCTP_GQ ON PCTP_GQ.DONID=TP.DONID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
                        LEFT JOIN DM_CANBO CB ON CB.ID=PCTP_GQ.CANBOID   
                        WHERE TP.MAVAITRO='VTTP_GIAIQUYETSOTHAM'
                        GROUP BY TP.DONID,DECODE(HD.COUNT_CHUTOA,NULL,CB.ID,HD.TPCHUTOA_ID)
                       )TPPCPT ON TPPCPT.DONID=A.ID AND GD.MAGIAIDOAN=2
            LEFT JOIN DM_CANBO CB ON CB.ID=TPPCPT.THAMPHAN_ID         
            WHERE 
             (GD.TOAANID =V_TOAAN_ID)
             AND GD.MAGIAIDOAN=2 
             AND (
                   (item_bc=1  
                   AND (   
                           EXISTS (       
                                    SELECT 'X' FROM ALD_SOTHAM_BANAN BA
                                    WHERE  BA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR BA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR BA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND BA.DONID=a.id  AND GD.MAGIAIDOAN=2
                                 )
                            OR  EXISTS (
                                    SELECT 'X' FROM ALD_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    WHERE instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0
                                    AND (V_TUNGAY IS NULL OR QSV.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                    AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                                )
                        )
                    )
                 OR
                  (item_bc=2  
                   AND   EXISTS (
                            SELECT 'X' FROM ALD_SOTHAM_QUYETDINH QSV
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                            LEFT JOIN ALD_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                            WHERE QDL.MA ='HPT' AND BA.ID IS NULL   -- QDL.MA ='HPT' --hoãn phiên tòa
                            AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                            AND QSV.DONID=A.ID AND GD.MAGIAIDOAN=2
                         )
                    )
                )
        )
     LOOP
                   IF(item_bc=1)THEN
                   v_table.extend;
                    v_table(v_table.count) := R_STPT_THSL_XX(
                    item.THAMPHAN_ID,item.PHONGBANID
                    ,0,0,0,0,1,0
                    ,0
                    ,0,0,0,0,0,0
                    ,0,0
                    );
              ELSE
              v_table.extend;
                    v_table(v_table.count) := R_STPT_THSL_XX(
                    item.THAMPHAN_ID,item.PHONGBANID
                    ,0,0,0,0,0,0
                    ,0
                    ,0,0,0,0,1,0
                    ,0,0
                    );   
              END IF; 
     END LOOP;
     -----------------ALD-PT
     FOR item IN (
             SELECT TPPCPT.THAMPHAN_ID,NVL(CB.PHONGBANID,0)PHONGBANID
             FROM ALD_DON A
              INNER JOIN ALD_DON_GIAIDOAN GD ON A.ID=GD.DONID
              LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
               LEFT JOIN ( SELECT TP.DONID,DECODE(HD.COUNT_CHUTOA,NULL,CB.ID,HD.TPCHUTOA_ID) THAMPHAN_ID
                        FROM ALD_DON_THAMPHAN TP
                        LEFT JOIN (select x.DONID,RTRIM(SUBSTR(x.ID,0,INSTR(x.ID,',',1,1)),',')TPCHUTOA_ID,x.COUNT_CHUTOA 
                                         from (
                                            SELECT XX.DONID,listagg (CBB.ID,',') WITHIN GROUP (ORDER BY CBB.ID DESC)||','ID
                                                        ,COUNT(*)COUNT_CHUTOA FROM ALD_PHUCTHAM_HDXX XX
                                                        LEFT JOIN DM_CANBO CBB ON XX.CANBOID=CBB.ID 
                                                        WHERE XX.MAVAITRO='THAMPHAN'
                                                        GROUP BY XX.DONID
                                           )x
                                   )HD ON HD.DONID=TP.DONID
                            ----anhvh add hàm lấy 1 bản ghi mới nhất trong bảng AHS_THAMPHANGIAIQUYET      
                         LEFT JOIN ( SELECT GG.* FROM ALD_DON_THAMPHAN GG
                                      INNER JOIN (
                                                    SELECT TT.DONID,RTRIM(SUBSTR(TT.ID,0,INSTR(TT.ID,',',1,1)),',')ID --lấy 1 ID đầu tiên có ngày phân công mới nhất
                                                    FROM (
                                                    SELECT TP.DONID ,
                                                    LISTAGG (TP.ID, ',') WITHIN GROUP (ORDER BY TP.NGAYNHANPHANCONG DESC)||','ID
                                                    FROM ALD_DON_THAMPHAN TP 
                                                    GROUP BY TP.DONID)TT
                                             )TS ON TS.ID=GG.ID
                                    )PCTP_GQ ON PCTP_GQ.DONID=TP.DONID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
                        LEFT JOIN DM_CANBO CB ON CB.ID=PCTP_GQ.CANBOID   
                        WHERE TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                        GROUP BY TP.DONID,DECODE(HD.COUNT_CHUTOA,NULL,CB.ID,HD.TPCHUTOA_ID)
                       )TPPCPT ON TPPCPT.DONID=A.ID AND GD.MAGIAIDOAN=3
                LEFT JOIN DM_CANBO CB ON CB.ID=TPPCPT.THAMPHAN_ID         
              WHERE 
              (GD.TOAPHUCTHAMID=V_TOAAN_ID)
             AND GD.MAGIAIDOAN=3    
             AND (       
                        (item_bc=1  
                          AND (  
                                EXISTS (
                                        SELECT 'X' FROM ALD_PHUCTHAM_BANAN PTBA 
                                        WHERE  PTBA.SOBANAN IS NOT NULL
                                        AND (V_TUNGAY IS NULL OR PTBA.NGAYTUYENAN>=VV_TUNGAY)
                                        AND (V_DENNGAY IS NULL OR PTBA.NGAYTUYENAN<=VV_DENNGAY)
                                        AND PTBA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                        )
                                 OR EXISTS (
                                        SELECT 'X' FROM ALD_PHUCTHAM_QUYETDINH PTQDVA 
                                        LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                                        LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                                        LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID  
                                        WHERE  instr('DC',QDL.MA)>0
                                        AND (V_TUNGAY IS NULL OR PTQDVA.NGAYQD>=VV_TUNGAY)
                                        AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                        AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                        )         
                             )
                        )
                     OR(item_bc=2 
                      AND EXISTS (
                            SELECT  'X' FROM   ALD_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN ALD_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                            LEFT JOIN ALD_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID  
                            WHERE PTBA.DONID IS NULL  AND QDL.MA='HPT' --Vụ án chưa có bản án  --hoãn phiên tòa 
                            AND (V_TUNGAY IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                            AND PTQDVA.DONID=A.ID AND GD.MAGIAIDOAN=3
                            )    
                     )
                )
        )
     LOOP
                IF(item_bc=1)THEN
                   v_table.extend;
                    v_table(v_table.count) := R_STPT_THSL_XX(
                    item.THAMPHAN_ID,item.PHONGBANID
                    ,0,0,0,0,1,0
                    ,0
                    ,0,0,0,0,0,0
                    ,0,0
                    );
              ELSE
              v_table.extend;
                    v_table(v_table.count) := R_STPT_THSL_XX(
                    item.THAMPHAN_ID,item.PHONGBANID
                    ,0,0,0,0,0,0
                    ,0
                    ,0,0,0,0,1,0
                    ,0,0
                    );   
              END IF; 
     END LOOP;
          -----------------AHC-ST
     FOR item IN (
             SELECT TPPCPT.THAMPHAN_ID,NVL(CB.PHONGBANID,0)PHONGBANID
             FROM AHC_DON A
              INNER JOIN AHC_DON_GIAIDOAN GD ON A.ID=GD.DONID
              LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
               LEFT JOIN ( SELECT TP.DONID,DECODE(HD.COUNT_CHUTOA,NULL,CB.ID,HD.TPCHUTOA_ID) THAMPHAN_ID
                        FROM AHC_DON_THAMPHAN TP
                        LEFT JOIN (select x.DONID,RTRIM(SUBSTR(x.ID,0,INSTR(x.ID,',',1,1)),',')TPCHUTOA_ID,x.COUNT_CHUTOA 
                                         from (
                                            SELECT XX.DONID,listagg (CBB.ID,',') WITHIN GROUP (ORDER BY CBB.ID DESC)||','ID
                                                        ,COUNT(*)COUNT_CHUTOA FROM AHC_SOTHAM_HDXX XX
                                                        LEFT JOIN DM_CANBO CBB ON XX.CANBOID=CBB.ID 
                                                        WHERE XX.MAVAITRO='THAMPHAN'
                                                        GROUP BY XX.DONID
                                           )x
                                   )HD ON HD.DONID=TP.DONID
                            ----anhvh add hàm lấy 1 bản ghi mới nhất trong bảng AHS_THAMPHANGIAIQUYET      
                         LEFT JOIN ( SELECT GG.* FROM AHC_DON_THAMPHAN GG
                                      INNER JOIN (
                                                    SELECT TT.DONID,RTRIM(SUBSTR(TT.ID,0,INSTR(TT.ID,',',1,1)),',')ID --lấy 1 ID đầu tiên có ngày phân công mới nhất
                                                    FROM (
                                                    SELECT TP.DONID ,
                                                    LISTAGG (TP.ID, ',') WITHIN GROUP (ORDER BY TP.NGAYNHANPHANCONG DESC)||','ID
                                                    FROM AHC_DON_THAMPHAN TP 
                                                    GROUP BY TP.DONID)TT
                                             )TS ON TS.ID=GG.ID
                                    )PCTP_GQ ON PCTP_GQ.DONID=TP.DONID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
                        LEFT JOIN DM_CANBO CB ON CB.ID=PCTP_GQ.CANBOID   
                        WHERE TP.MAVAITRO='VTTP_GIAIQUYETSOTHAM'
                        GROUP BY TP.DONID,DECODE(HD.COUNT_CHUTOA,NULL,CB.ID,HD.TPCHUTOA_ID)
                       )TPPCPT ON TPPCPT.DONID=A.ID AND GD.MAGIAIDOAN=2
            LEFT JOIN DM_CANBO CB ON CB.ID=TPPCPT.THAMPHAN_ID         
            WHERE 
             (GD.TOAANID =V_TOAAN_ID)
             AND GD.MAGIAIDOAN=2 
             AND (
                   (item_bc=1  
                   AND (   
                           EXISTS (       
                                    SELECT 'X' FROM AHC_SOTHAM_BANAN BA
                                    WHERE  BA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR BA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR BA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND BA.DONID=a.id  AND GD.MAGIAIDOAN=2
                                 )
                            OR  EXISTS (
                                    SELECT 'X' FROM AHC_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    WHERE instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0
                                    AND (V_TUNGAY IS NULL OR QSV.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                    AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                                )
                        )
                    )
                 OR
                  (item_bc=2  
                   AND   EXISTS (
                            SELECT 'X' FROM AHC_SOTHAM_QUYETDINH QSV
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                            LEFT JOIN AHC_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                            WHERE QDL.MA ='HPT' AND BA.ID IS NULL   -- QDL.MA ='HPT' --hoãn phiên tòa
                            AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                            AND QSV.DONID=A.ID AND GD.MAGIAIDOAN=2
                         )
                    )
                )
        )
     LOOP
                   IF(item_bc=1)THEN
                   v_table.extend;
                    v_table(v_table.count) := R_STPT_THSL_XX(
                    item.THAMPHAN_ID,item.PHONGBANID
                    ,0,0,0,0,0,1
                    ,0
                    ,0,0,0,0,0,0
                    ,0,0
                    );
              ELSE
              v_table.extend;
                    v_table(v_table.count) := R_STPT_THSL_XX(
                    item.THAMPHAN_ID,item.PHONGBANID
                    ,0,0,0,0,0,0
                    ,0
                    ,0,0,0,0,0,1
                    ,0,0
                    );   
              END IF; 
     END LOOP;
     -----------------AHC-PT
     FOR item IN (
             SELECT TPPCPT.THAMPHAN_ID,NVL(CB.PHONGBANID,0)PHONGBANID
             FROM AHC_DON A
              INNER JOIN AHC_DON_GIAIDOAN GD ON A.ID=GD.DONID
              LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
               LEFT JOIN ( SELECT TP.DONID,DECODE(HD.COUNT_CHUTOA,NULL,CB.ID,HD.TPCHUTOA_ID) THAMPHAN_ID
                        FROM AHC_DON_THAMPHAN TP
                        LEFT JOIN (select x.DONID,RTRIM(SUBSTR(x.ID,0,INSTR(x.ID,',',1,1)),',')TPCHUTOA_ID,x.COUNT_CHUTOA 
                                         from (
                                            SELECT XX.DONID,listagg (CBB.ID,',') WITHIN GROUP (ORDER BY CBB.ID DESC)||','ID
                                                        ,COUNT(*)COUNT_CHUTOA FROM AHC_PHUCTHAM_HDXX XX
                                                        LEFT JOIN DM_CANBO CBB ON XX.CANBOID=CBB.ID 
                                                        WHERE XX.MAVAITRO='THAMPHAN'
                                                        GROUP BY XX.DONID
                                           )x
                                   )HD ON HD.DONID=TP.DONID
                            ----anhvh add hàm lấy 1 bản ghi mới nhất trong bảng AHS_THAMPHANGIAIQUYET      
                         LEFT JOIN ( SELECT GG.* FROM AHC_DON_THAMPHAN GG
                                      INNER JOIN (
                                                    SELECT TT.DONID,RTRIM(SUBSTR(TT.ID,0,INSTR(TT.ID,',',1,1)),',')ID --lấy 1 ID đầu tiên có ngày phân công mới nhất
                                                    FROM (
                                                    SELECT TP.DONID ,
                                                    LISTAGG (TP.ID, ',') WITHIN GROUP (ORDER BY TP.NGAYNHANPHANCONG DESC)||','ID
                                                    FROM AHC_DON_THAMPHAN TP 
                                                    GROUP BY TP.DONID)TT
                                             )TS ON TS.ID=GG.ID
                                    )PCTP_GQ ON PCTP_GQ.DONID=TP.DONID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
                        LEFT JOIN DM_CANBO CB ON CB.ID=PCTP_GQ.CANBOID   
                        WHERE TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                        GROUP BY TP.DONID,DECODE(HD.COUNT_CHUTOA,NULL,CB.ID,HD.TPCHUTOA_ID)
                       )TPPCPT ON TPPCPT.DONID=A.ID AND GD.MAGIAIDOAN=3
                LEFT JOIN DM_CANBO CB ON CB.ID=TPPCPT.THAMPHAN_ID         
              WHERE 
              (GD.TOAPHUCTHAMID=V_TOAAN_ID)
             AND GD.MAGIAIDOAN=3    
             AND (       
                        (item_bc=1  
                          AND (  
                                EXISTS (
                                        SELECT 'X' FROM AHC_PHUCTHAM_BANAN PTBA 
                                        WHERE  PTBA.SOBANAN IS NOT NULL
                                        AND (V_TUNGAY IS NULL OR PTBA.NGAYTUYENAN>=VV_TUNGAY)
                                        AND (V_DENNGAY IS NULL OR PTBA.NGAYTUYENAN<=VV_DENNGAY)
                                        AND PTBA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                        )
                                 OR EXISTS (
                                        SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH PTQDVA 
                                        LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                                        LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID  
                                        WHERE  instr('DC',QDL.MA)>0
                                        AND (V_TUNGAY IS NULL OR PTQDVA.NGAYQD>=VV_TUNGAY)
                                        AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                        AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                        )         
                             )
                        )
                     OR(item_bc=2 
                      AND EXISTS (
                            SELECT  'X' FROM   AHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN AHC_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                            LEFT JOIN AHC_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID  
                            WHERE PTBA.DONID IS NULL  AND QDL.MA='HPT' --Vụ án chưa có bản án  --hoãn phiên tòa 
                            AND (V_TUNGAY IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                            AND PTQDVA.DONID=A.ID AND GD.MAGIAIDOAN=3
                            )    
                     )
                )
        )
     LOOP
                   IF(item_bc=1)THEN
                   v_table.extend;
                    v_table(v_table.count) := R_STPT_THSL_XX(
                    item.THAMPHAN_ID,item.PHONGBANID
                    ,0,0,0,0,0,1
                    ,0
                    ,0,0,0,0,0,0
                    ,0,0
                    );
              ELSE
              v_table.extend;
                    v_table(v_table.count) := R_STPT_THSL_XX(
                    item.THAMPHAN_ID,item.PHONGBANID
                    ,0,0,0,0,0,0
                    ,0
                    ,0,0,0,0,0,1
                    ,0,0
                    );   
              END IF; 
     END LOOP;
     --------------
  END LOOP;
     ----------------------------------
    IF(V_CAP_XET_XU_LOGIN='CAPCAO') THEN
            FOR item IN (
                    SELECT 0 ID,TO_NUMBER(V_TOAAN_ID) TOAANID,'Ban lãnh đạo' TENPHONGBAN,0 ORDERS FROM DUAL
                    UNION ALL
                    SELECT PB.ID,PB.TOAANID,to_char(PB.TENPHONGBAN)TENPHONGBAN,1 ORDERS FROM DM_PHONGBAN PB WHERE PB.TOAANID=V_TOAAN_ID AND PB.MADONGBO='4CA834FAABA54D0FA3254B3C8478DFA9'
                    UNION ALL
                    SELECT PB.ID,PB.TOAANID,to_char(PB.TENPHONGBAN)TENPHONGBAN,2 ORDERS FROM DM_PHONGBAN PB WHERE PB.TOAANID=V_TOAAN_ID AND PB.MADONGBO='429729E86AFF4067A81E8871785DEAF9'
                    UNION ALL
                    SELECT PB.ID,PB.TOAANID,to_char(PB.TENPHONGBAN)TENPHONGBAN,3 ORDERS FROM DM_PHONGBAN PB WHERE PB.TOAANID=V_TOAAN_ID AND PB.MADONGBO='97DDF7DF293245F080DCBAC515960E0B'
                    UNION ALL
                    SELECT PB.ID,PB.TOAANID,to_char(PB.TENPHONGBAN)TENPHONGBAN,4 ORDERS FROM DM_PHONGBAN PB WHERE PB.TOAANID=V_TOAAN_ID AND PB.MADONGBO='EF439D01ABD04F62A4B150CC9A2EF436'
                    UNION ALL
                    SELECT PB.ID,PB.TOAANID,to_char(PB.TENPHONGBAN)TENPHONGBAN,5 ORDERS FROM DM_PHONGBAN PB WHERE PB.TOAANID=V_TOAAN_ID AND PB.MADONGBO='EA4DC68FE52444E098C8416A731C68A2'
                    UNION ALL
                    SELECT PB.ID,PB.TOAANID,to_char(PB.TENPHONGBAN)TENPHONGBAN,6 ORDERS FROM DM_PHONGBAN PB WHERE PB.TOAANID=V_TOAAN_ID AND PB.MADONGBO='84972F20EB8640B1826705973D1F6638'
               )
               LOOP
               DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'
                     <tr>
                        <th style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;background-color:#cecaca;">'||item.TENPHONGBAN||'</th>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;background-color:#cecaca;"></td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;background-color:#cecaca;"></td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;background-color:#cecaca;"></td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;background-color:#cecaca;"></td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;background-color:#cecaca;"></td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;background-color:#cecaca;"></td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;background-color:#cecaca;"></td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;background-color:#cecaca;"></td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;background-color:#cecaca;"></td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;background-color:#cecaca;"></td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;background-color:#cecaca;"></td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;background-color:#cecaca;"></td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;background-color:#cecaca;"></td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;background-color:#cecaca;"></td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;background-color:#cecaca;"></td>
                    </tr>
                       '); 
                     FOR item_cb IN (
                             SELECT B.* FROM (
                                SELECT CB.* FROM DM_CANBO CB WHERE NVL(CB.PHONGBANID,0)=item.ID 
                                AND CB.TOAANID=V_TOAAN_ID AND CB.HIEULUC=1
                                AND EXISTS(select 'X' from DM_DATAITEM cc where cc.GROUPID=13 and cc.MA in ('CA','PCA') and cc.id=CB.CHUCVUID)
                                ORDER BY SUBSTR(CB.HOTEN, instr(CB.HOTEN,' ', 1, 2)+1)
                                )B
                           UNION ALL 
                            SELECT B.* FROM (
                                 SELECT CB.* FROM DM_CANBO CB WHERE CB.PHONGBANID=item.ID 
                                  AND CB.TOAANID=V_TOAAN_ID AND CB.HIEULUC=1
                                  AND EXISTS(select 'X' from DM_DATAITEM c where c.GROUPID=12 and c.MA in ('TP','TPSC','TPTC','TPCC','TPTATC') and C.id=CB.CHUCDANHID)
                                  AND NOT EXISTS(select 'X' from DM_DATAITEM cc where cc.GROUPID=13 and cc.MA in ('CA','PCA') and cc.id=CB.CHUCVUID)
                             ORDER BY SUBSTR(CB.HOTEN, instr(CB.HOTEN,' ', 1, 2)+1)
                            )B  

                       )
                       LOOP
                           FOR item_tp IN (
                             SELECT  SUM(v_COLUMN_1)v_COLUMN_1,SUM(v_COLUMN_2)v_COLUMN_2,SUM(v_COLUMN_3)v_COLUMN_3,SUM(v_COLUMN_4)v_COLUMN_4,SUM(v_COLUMN_5)v_COLUMN_5,SUM(v_COLUMN_6)v_COLUMN_6
                             ,SUM(v_COLUMN_1+v_COLUMN_2+v_COLUMN_3+v_COLUMN_4+v_COLUMN_5+v_COLUMN_6)v_COLUMN_7,SUM(v_COLUMN_8)v_COLUMN_8,SUM(v_COLUMN_9)v_COLUMN_9,SUM(v_COLUMN_10)v_COLUMN_10
                             ,SUM(v_COLUMN_11)v_COLUMN_11,SUM(v_COLUMN_12)v_COLUMN_12,SUM(v_COLUMN_13)v_COLUMN_13,SUM(v_COLUMN_8+v_COLUMN_9+v_COLUMN_10+v_COLUMN_11+v_COLUMN_12+v_COLUMN_13)v_COLUMN_14
                             ,SUM(v_COLUMN_1+v_COLUMN_2+v_COLUMN_3+v_COLUMN_4+v_COLUMN_5+v_COLUMN_6+v_COLUMN_8+v_COLUMN_9+v_COLUMN_10+v_COLUMN_11+v_COLUMN_12+v_COLUMN_13)v_COLUMN_15 
                             FROM TABLE(v_table) PA WHERE PA.v_ID_CANBO=item_cb.ID
                           )
                           LOOP
                                  DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'
                                     <tr>
                                        <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item_cb.HOTEN||'</td>
                                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_tp.v_COLUMN_1||'</td>
                                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_tp.v_COLUMN_2||'</td>
                                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_tp.v_COLUMN_3||'</td>
                                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_tp.v_COLUMN_4||'</td>
                                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_tp.v_COLUMN_5||'</td>
                                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_tp.v_COLUMN_6||'</td>
                                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_tp.v_COLUMN_7||'</td>
                                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_tp.v_COLUMN_8||'</td>
                                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_tp.v_COLUMN_9||'</td>
                                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_tp.v_COLUMN_10||'</td>
                                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_tp.v_COLUMN_11||'</td>
                                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_tp.v_COLUMN_12||'</td>
                                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_tp.v_COLUMN_13||'</td>
                                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_tp.v_COLUMN_14||'</td>
                                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_tp.v_COLUMN_15||'</td>
                                    </tr>
                               '); 
                               V_TABLE_TOTAL.extend;
                                V_TABLE_TOTAL(V_TABLE_TOTAL.count) := R_STPT_THSL_XX(
                                item_cb.ID,item.ID,item_tp.v_COLUMN_1,item_tp.v_COLUMN_2,item_tp.v_COLUMN_3,item_tp.v_COLUMN_4
                                ,item_tp.v_COLUMN_5,item_tp.v_COLUMN_6,item_tp.v_COLUMN_7,item_tp.v_COLUMN_8,item_tp.v_COLUMN_9
                                ,item_tp.v_COLUMN_10,item_tp.v_COLUMN_11,item_tp.v_COLUMN_12,item_tp.v_COLUMN_13,item_tp.v_COLUMN_14,item_tp.v_COLUMN_15
                                );   
                           END LOOP;
                       END LOOP;
                  ------tổng theo đơn vị       
                  FOR item_count IN (
                         SELECT SUM(v_COLUMN_1)v_COLUMN_1,SUM(v_COLUMN_2)v_COLUMN_2,SUM(v_COLUMN_3)v_COLUMN_3,SUM(v_COLUMN_4)v_COLUMN_4,SUM(v_COLUMN_5)v_COLUMN_5,SUM(v_COLUMN_6)v_COLUMN_6
                         ,SUM(v_COLUMN_1+v_COLUMN_2+v_COLUMN_3+v_COLUMN_4+v_COLUMN_5+v_COLUMN_6)v_COLUMN_7,SUM(v_COLUMN_8)v_COLUMN_8,SUM(v_COLUMN_9)v_COLUMN_9,SUM(v_COLUMN_10)v_COLUMN_10
                         ,SUM(v_COLUMN_11)v_COLUMN_11,SUM(v_COLUMN_12)v_COLUMN_12,SUM(v_COLUMN_13)v_COLUMN_13,SUM(v_COLUMN_8+v_COLUMN_9+v_COLUMN_10+v_COLUMN_11+v_COLUMN_12+v_COLUMN_13)v_COLUMN_14
                         ,SUM(v_COLUMN_1+v_COLUMN_2+v_COLUMN_3+v_COLUMN_4+v_COLUMN_5+v_COLUMN_6+v_COLUMN_8+v_COLUMN_9+v_COLUMN_10+v_COLUMN_11+v_COLUMN_12+v_COLUMN_13)v_COLUMN_15 
                         FROM TABLE(V_TABLE_TOTAL) PA 
                         WHERE PA.v_ID_PHONGBAN=item.ID
                       )
                       LOOP
                              DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'
                              <tr>
                                 <th style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Cộng</th>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_count.v_COLUMN_1||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_count.v_COLUMN_2||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_count.v_COLUMN_3||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_count.v_COLUMN_4||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_count.v_COLUMN_5||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_count.v_COLUMN_6||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_count.v_COLUMN_7||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_count.v_COLUMN_8||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_count.v_COLUMN_9||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_count.v_COLUMN_10||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_count.v_COLUMN_11||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_count.v_COLUMN_12||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_count.v_COLUMN_13||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_count.v_COLUMN_14||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_count.v_COLUMN_15||'</td>
                               </tr>     
                           '); 
                       END LOOP;     
               END LOOP;
                ------tổng tất cả
                  FOR item_count IN (
                         SELECT SUM(v_COLUMN_1)v_COLUMN_1,SUM(v_COLUMN_2)v_COLUMN_2,SUM(v_COLUMN_3)v_COLUMN_3,SUM(v_COLUMN_4)v_COLUMN_4,SUM(v_COLUMN_5)v_COLUMN_5,SUM(v_COLUMN_6)v_COLUMN_6
                         ,SUM(v_COLUMN_1+v_COLUMN_2+v_COLUMN_3+v_COLUMN_4+v_COLUMN_5+v_COLUMN_6)v_COLUMN_7,SUM(v_COLUMN_8)v_COLUMN_8,SUM(v_COLUMN_9)v_COLUMN_9,SUM(v_COLUMN_10)v_COLUMN_10
                         ,SUM(v_COLUMN_11)v_COLUMN_11,SUM(v_COLUMN_12)v_COLUMN_12,SUM(v_COLUMN_13)v_COLUMN_13,SUM(v_COLUMN_8+v_COLUMN_9+v_COLUMN_10+v_COLUMN_11+v_COLUMN_12+v_COLUMN_13)v_COLUMN_14
                         ,SUM(v_COLUMN_1+v_COLUMN_2+v_COLUMN_3+v_COLUMN_4+v_COLUMN_5+v_COLUMN_6+v_COLUMN_8+v_COLUMN_9+v_COLUMN_10+v_COLUMN_11+v_COLUMN_12+v_COLUMN_13)v_COLUMN_15 
                         FROM TABLE(V_TABLE_TOTAL) PA 
                         )
                       LOOP
                              DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'
                              <tr>
                                 <th style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Tổng cộng</th>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_count.v_COLUMN_1||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_count.v_COLUMN_2||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_count.v_COLUMN_3||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_count.v_COLUMN_4||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_count.v_COLUMN_5||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_count.v_COLUMN_6||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_count.v_COLUMN_7||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_count.v_COLUMN_8||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_count.v_COLUMN_9||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_count.v_COLUMN_10||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_count.v_COLUMN_11||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_count.v_COLUMN_12||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_count.v_COLUMN_13||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_count.v_COLUMN_14||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_count.v_COLUMN_15||'</td>
                              </tr>      
                           '); 
                       END LOOP;  
         -------------------              
        ELSE--cấp tỉnh
        FOR item_cb IN (
                          SELECT CCB.* FROM (
                             SELECT 1 ORDERS,CB.* FROM DM_CANBO CB WHERE 
                                 CB.TOAANID=V_TOAAN_ID AND CB.HIEULUC=1
                                AND EXISTS(select 'X' from DM_DATAITEM cc where cc.GROUPID=13 and cc.MA in ('CA') and cc.id=CB.CHUCVUID)
                           UNION ALL 
                               SELECT 2 ORDERS,CB.* FROM DM_CANBO CB WHERE 
                                 CB.TOAANID=V_TOAAN_ID AND CB.HIEULUC=1
                                AND EXISTS(select 'X' from DM_DATAITEM cc where cc.GROUPID=13 and cc.MA in ('PCA') and cc.id=CB.CHUCVUID)
                           UNION ALL 
                                 SELECT 3 ORDERS, CB.* FROM DM_CANBO CB WHERE CB.TOAANID=V_TOAAN_ID AND CB.HIEULUC=1
                                  AND EXISTS(select 'X' from DM_DATAITEM c where c.GROUPID=12 and c.MA in ('TP','TPSC','TPTC','TPCC','TPTATC') and C.id=CB.CHUCDANHID)
                                  AND NOT EXISTS(select 'X' from DM_DATAITEM cc where cc.GROUPID=13 and cc.MA in ('CA','PCA') and cc.id=CB.CHUCVUID)
                          )CCB  ORDER BY CCB.ORDERS,SUBSTR(CCB.HOTEN, instr(CCB.HOTEN,' ', 1, 2)+1)--NLSSORT(CCB.HOTEN, 'NLS_SORT=vietnamese') 
                       )
                       LOOP
                       FOR item_tp IN (
                         SELECT SUM(v_COLUMN_1)v_COLUMN_1,SUM(v_COLUMN_2)v_COLUMN_2,SUM(v_COLUMN_3)v_COLUMN_3,SUM(v_COLUMN_4)v_COLUMN_4,SUM(v_COLUMN_5)v_COLUMN_5,SUM(v_COLUMN_6)v_COLUMN_6
                         ,SUM(v_COLUMN_1+v_COLUMN_2+v_COLUMN_3+v_COLUMN_4+v_COLUMN_5+v_COLUMN_6)v_COLUMN_7,SUM(v_COLUMN_8)v_COLUMN_8,SUM(v_COLUMN_9)v_COLUMN_9,SUM(v_COLUMN_10)v_COLUMN_10
                         ,SUM(v_COLUMN_11)v_COLUMN_11,SUM(v_COLUMN_12)v_COLUMN_12,SUM(v_COLUMN_13)v_COLUMN_13,SUM(v_COLUMN_8+v_COLUMN_9+v_COLUMN_10+v_COLUMN_11+v_COLUMN_12+v_COLUMN_13)v_COLUMN_14
                         ,SUM(v_COLUMN_1+v_COLUMN_2+v_COLUMN_3+v_COLUMN_4+v_COLUMN_5+v_COLUMN_6+v_COLUMN_8+v_COLUMN_9+v_COLUMN_10+v_COLUMN_11+v_COLUMN_12+v_COLUMN_13)v_COLUMN_15 
                         FROM TABLE(v_table) PA WHERE PA.v_ID_CANBO=item_cb.ID
                       )
                       LOOP
                              DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'
                                 <tr>
                                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item_cb.HOTEN||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_tp.v_COLUMN_1||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_tp.v_COLUMN_2||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_tp.v_COLUMN_3||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_tp.v_COLUMN_4||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_tp.v_COLUMN_5||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_tp.v_COLUMN_6||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_tp.v_COLUMN_7||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_tp.v_COLUMN_8||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_tp.v_COLUMN_9||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_tp.v_COLUMN_10||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_tp.v_COLUMN_11||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_tp.v_COLUMN_12||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_tp.v_COLUMN_13||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_tp.v_COLUMN_14||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_tp.v_COLUMN_15||'</td>
                                </tr>
                           '); 
                           V_TABLE_TOTAL.extend;
                                V_TABLE_TOTAL(V_TABLE_TOTAL.count) := R_STPT_THSL_XX(
                                0,0,item_tp.v_COLUMN_1,item_tp.v_COLUMN_2,item_tp.v_COLUMN_3,item_tp.v_COLUMN_4
                                ,item_tp.v_COLUMN_5,item_tp.v_COLUMN_6,item_tp.v_COLUMN_7,item_tp.v_COLUMN_8,item_tp.v_COLUMN_9
                                ,item_tp.v_COLUMN_10,item_tp.v_COLUMN_11,item_tp.v_COLUMN_12,item_tp.v_COLUMN_13,item_tp.v_COLUMN_14,item_tp.v_COLUMN_15
                                );   
                       END LOOP;
              END LOOP;     
               ------tổng theo đơn vị       
                  FOR item_count IN (
                         SELECT SUM(v_COLUMN_1)v_COLUMN_1,SUM(v_COLUMN_2)v_COLUMN_2,SUM(v_COLUMN_3)v_COLUMN_3,SUM(v_COLUMN_4)v_COLUMN_4,SUM(v_COLUMN_5)v_COLUMN_5,SUM(v_COLUMN_6)v_COLUMN_6
                         ,SUM(v_COLUMN_1+v_COLUMN_2+v_COLUMN_3+v_COLUMN_4+v_COLUMN_5+v_COLUMN_6)v_COLUMN_7,SUM(v_COLUMN_8)v_COLUMN_8,SUM(v_COLUMN_9)v_COLUMN_9,SUM(v_COLUMN_10)v_COLUMN_10
                         ,SUM(v_COLUMN_11)v_COLUMN_11,SUM(v_COLUMN_12)v_COLUMN_12,SUM(v_COLUMN_13)v_COLUMN_13,SUM(v_COLUMN_8+v_COLUMN_9+v_COLUMN_10+v_COLUMN_11+v_COLUMN_12+v_COLUMN_13)v_COLUMN_14
                         ,SUM(v_COLUMN_1+v_COLUMN_2+v_COLUMN_3+v_COLUMN_4+v_COLUMN_5+v_COLUMN_6+v_COLUMN_8+v_COLUMN_9+v_COLUMN_10+v_COLUMN_11+v_COLUMN_12+v_COLUMN_13)v_COLUMN_15 
                         FROM TABLE(V_TABLE_TOTAL) PA 
                       )
                       LOOP
                              DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'
                              <tr>
                                 <th style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Tổng cộng</th>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_count.v_COLUMN_1||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_count.v_COLUMN_2||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_count.v_COLUMN_3||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_count.v_COLUMN_4||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_count.v_COLUMN_5||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_count.v_COLUMN_6||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_count.v_COLUMN_7||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_count.v_COLUMN_8||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_count.v_COLUMN_9||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_count.v_COLUMN_10||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_count.v_COLUMN_11||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_count.v_COLUMN_12||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_count.v_COLUMN_13||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_count.v_COLUMN_14||'</td>
                                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item_count.v_COLUMN_15||'</td>
                              </tr>
                           '); 
                       END LOOP;     
       END IF;
     ---------------------------------------------------------------------------
     DBMS_LOB.APPEND(V_EXPORT_TEXT,'
         <table cellpadding="1" style="font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;">
            <tr>
                <td colspan="16" style="line-height: 100%; font-size: 13pt; text-align: center;height:33px;"><b>TỔNG HỢP SỐ LIỆU XÉT XỬ CỦA CÁC TÒA CHUYÊN TRÁCH</b></td>
            </tr>
             <tr>
                <td colspan="16" style="line-height: 100%; font-size: 13pt; text-align: center;height:24px;"><b>Tính từ ngày '||V_TUNGAY||' đến '||V_DENNGAY||'</b> </td>
            </tr>
            <tr style="font-weight: bold;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;" rowspan="2">Họ và tên</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;height:31px;" colspan="6">Án đã giải quyết</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;" rowspan="2">Cộng</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;" colspan="6">Án hoãn xử</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;" rowspan="2">Cộng</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;" rowspan="2">Tổng cộng</td>
            </tr>
            <tr>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">HS</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">DS</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">HN</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">KDTM</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">LĐ</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">HC</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">HS</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">DS</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">HN</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">KDTM</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">LĐ</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">HC</td>
            </tr>
            <tr>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic;"></td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic;color:#808080">1</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic;color:#808080">2</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic;color:#808080">3</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic;color:#808080">4</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic;color:#808080">5</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic;color:#808080">6</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic;color:#808080">7</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic;color:#808080">8</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic;color:#808080">9</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic;color:#808080">10</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic;color:#808080">11</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic;color:#808080">12</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic;color:#808080">13</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic;color:#808080">14</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic;color:#808080">15</td>
            </tr>
                 '); 
     ------ADD DỮ LIỆU VÀO THÂN BÁO CÁO
     DBMS_LOB.APPEND(V_EXPORT_TEXT,V_EXPORT_TEXT_ITEM );
      DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
           <tr>
            <td colspan="16"></td>
            </tr>
            <tr>
                <td colspan="3" style="height: 100px; vertical-align: top; text-align: center;font-weight:bold;">Cán bộ thống kê</td>
                <td colspan="5" style="height: 100px; vertical-align: top; text-align: center"></td>
                <td colspan="8" style="height: 100px; vertical-align: top; text-align: center;font-weight:bold;">TRƯỞNG PHÒNG - PHÒNG HÀNH CHÍNH TƯ PHÁP</td>
            </tr>
            <tr>
                <td colspan="3" style="vertical-align: top; text-align: center;font-weight:bold;">'||V_CANBO_TK_NAME||'</td>
                <td colspan="5" style="vertical-align: top; text-align: center"></td>
                <td colspan="8" style="vertical-align: top; text-align: center;font-weight:bold;">'||V_LANHDAO_TK_NAME||'</td>
            </tr>
       ');     
     -----------------------
    DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
          <tr style="height: 1px;">
                <td style="width: 170px"></td>
                <td style="width: 50px"></td>
                <td style="width: 50px"></td>
                <td style="width: 50px"></td>
                <td style="width: 50px"></td>
                <td style="width: 50px"></td>
                <td style="width: 50px"></td>
                <td style="width: 50px"></td>
                <td style="width: 50px"></td>
                <td style="width: 50px"></td>
                <td style="width: 50px"></td>
                <td style="width: 50px"></td>
                <td style="width: 50px"></td>
                <td style="width: 50px"></td>
                <td style="width: 50px"></td>
                <td style="width: 50px"></td>
            </tr>
        </table>
      ');
    ----------------------------
    OPEN V_CURSOR FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;       
 END THSL_XX;  
 FUNCTION TL_XX_TRINHTU_PT
(
    V_CANBO_TK_ID  IN VARCHAR2,
    V_LANHDAO_TK_ID  IN VARCHAR2,
    V_CAP_XET_XU_LOGIN  IN VARCHAR2,
    V_TOAAN_ID in varchar2, 
    V_TUNGAY IN VARCHAR2,
    V_DENNGAY IN VARCHAR2,
    V_LOAIAN_ID IN VARCHAR2
)RETURN SYS_REFCURSOR
AS  
    V_CURSOR sys_refcursor;VV_TUNGAY DATE;VV_DENNGAY DATE;v_COLUMNS NUMBER:=0;v_COLUMN_8_TYLE NUMBER:=0;
    V_TABLE T_TL_TRINHTUXX_PT;V_HANHCHINH_NAME VARCHAR2(255);V_TOAAN_NAME VARCHAR2(255);
    V_EXPORT_TEXT CLOB;V_EXPORT_TEXT_ITEM CLOB;V_CANBO_TK_NAME VARCHAR2(255);V_LANHDAO_TK_NAME VARCHAR2(255);
BEGIN	
    DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT_ITEM,true);
    v_table := T_TL_TRINHTUXX_PT();  
     --
     if(V_TUNGAY IS NOT NULL) then  VV_TUNGAY:=to_date(trim(V_TUNGAY)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(V_DENNGAY IS NOT NULL) then  VV_DENNGAY:=to_date(trim(V_DENNGAY)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;
     -------------
     SELECT HC.TEN INTO V_HANHCHINH_NAME FROM DM_HANHCHINH HC 
     WHERE EXISTS(SELECT 'X' FROM DM_TOAAN TA WHERE TA.ID=V_TOAAN_ID AND TA.HANHCHINHID=HC.ID);
     ----
     SELECT TA.TEN INTO V_TOAAN_NAME FROM DM_TOAAN TA WHERE TA.ID=V_TOAAN_ID;
     ----
     if(V_CANBO_TK_ID is not null)then
        SELECT CB.HOTEN INTO V_CANBO_TK_NAME FROM DM_CANBO CB WHERE CB.ID=V_CANBO_TK_ID;
     else
        V_CANBO_TK_NAME:='';
     end if;
     if(V_LANHDAO_TK_ID is not null)then
         SELECT CB.HOTEN INTO V_LANHDAO_TK_NAME FROM DM_CANBO CB WHERE CB.ID=V_LANHDAO_TK_ID;
      else
        V_LANHDAO_TK_NAME:='';
     end if;
        ---------cu con lai
        ---------AHS st--------------
		SELECT COUNT(DISTINCT VA.ID)into v_COLUMNS FROM GSCM.AHS_VUAN VA 
        INNER JOIN AHS_VUAN_GIAIDOAN GD ON VA.ID=GD.VUANID
        INNER JOIN GSCM.AHS_SOTHAM_THULY TL ON VA.ID=TL.VUANID 
		WHERE
            GD.TOAANID =V_TOAAN_ID
            AND GD.MAGIAIDOAN=2
			AND TL.NGAYTHULY<=VV_TUNGAY
            AND NOT EXISTS(  SELECT 'X' FROM  AHS_SOTHAM_QUYETDINH_VUAN QSV 
                                 LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                 LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                 WHERE  instr(',DC,CVA,',','||QDL.MA||',')>0
                                 AND QSV.VUANID=VA.ID  AND GD.MAGIAIDOAN=2
                            )
             AND NOT  EXISTS( SELECT 'X' FROM  AHS_SOTHAM_BANAN BA 
                              WHERE BA.VUANID=VA.ID AND GD.MAGIAIDOAN=2
                            );  

            v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(1 --hinh su
            ,v_COLUMNS,0,0,0,0,0,0,0
            );
            ---------AHS_ pt--------------   
            SELECT COUNT (DISTINCT VA.ID)INTO v_COLUMNS FROM AHS_VUAN VA
            INNER JOIN AHS_VUAN_GIAIDOAN GD ON VA.ID=GD.VUANID
			INNER JOIN GSCM.AHS_PHUCTHAM_THULY PTTL ON PTTL.VUANID=VA.ID 
		    WHERE GD.TOAPHUCTHAMID=V_TOAAN_ID
            AND GD.MAGIAIDOAN=3
			AND PTTL.NGAYTHULY<=VV_TUNGAY
            AND NOT EXISTS  (   SELECT 'X' FROM AHS_PHUCTHAM_BANAN PTBA
                                WHERE  PTBA.ID IS NOT NULL
                                AND PTBA.VUANID=VA.ID  AND GD.MAGIAIDOAN=3
                            )
             AND NOT EXISTS (
                                SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA 
                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID  
                                WHERE (QDL.MA='DC') --Đình chỉ
                                AND PTQDVA.VUANID=VA.ID AND GD.MAGIAIDOAN=3
                                );               

            v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(1--hinh su
            ,v_COLUMNS,0,0,0,0,0,0,0
            );
          ---------------------ADS_.st
          SELECT COUNT (DISTINCT A.ID) INTO v_COLUMNS FROM ADS_DON A
          INNER JOIN ADS_DON_GIAIDOAN GD ON A.ID=GD.DONID
          INNER JOIN (SELECT T2.DONID,T2.NGAYTHULY  FROM ADS_SOTHAM_THULY T2
                    INNER JOIN (
                                SELECT DISTINCT T1.DONID,MAX(T1.NGAYTHULY) OVER (PARTITION BY T1.DONID) NGAYTHULY
                                FROM ADS_SOTHAM_THULY T1 
                                ) T3 ON T2.DONID=T3.DONID AND T2.NGAYTHULY=T3.NGAYTHULY
                 ) ST ON ST.DONID=A.ID AND GD.MAGIAIDOAN=2--Lấy lần thụ lý mới nhất là trường hợp có 2 lần thụ lý trong 1 đơn
		 WHERE
          GD.TOAANID =V_TOAAN_ID
          AND GD.MAGIAIDOAN=2 
          AND ST.NGAYTHULY<=VV_TUNGAY
          AND NOT EXISTS (  SELECT 'X' FROM ADS_SOTHAM_QUYETDINH QSV 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                            WHERE instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0
                            AND QSV.DONID=A.id  AND GD.MAGIAIDOAN=2
                         )
           AND NOT EXISTS (  SELECT 'X' FROM ADS_SOTHAM_BANAN BA
                           WHERE  BA.DONID=A.id AND GD.MAGIAIDOAN=2
                        );   
            v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(2--dân sự
            ,v_COLUMNS,0,0,0,0,0,0,0
            );              
          ----------------------ADS_pt
          SELECT COUNT (DISTINCT PTT.DONID) INTO v_COLUMNS FROM ADS_DON A
           INNER JOIN ADS_DON_GIAIDOAN GD ON A.ID=GD.DONID
			INNER JOIN (SELECT T2.DONID,T2.NGAYTHULY,T2.TRUONGHOPTHULY
                  FROM GSCM.ADS_PHUCTHAM_THULY T2
                  INNER JOIN (
                        SELECT DISTINCT T1.DONID,MAX(T1.NGAYTHULY) OVER (PARTITION BY T1.DONID) NGAYTHULY
                        FROM GSCM.ADS_PHUCTHAM_THULY T1
                        ) T3 ON T2.DONID=T3.DONID AND T2.NGAYTHULY=T3.NGAYTHULY
                  ) PTT ON PTT.DONID=A.ID --> Lấy thụ lý mới nhất
		WHERE
            GD.TOAPHUCTHAMID=V_TOAAN_ID   
            AND GD.MAGIAIDOAN=3
			AND PTT.NGAYTHULY<=VV_TUNGAY --CŨ CÒN LẠI
             AND NOT EXISTS (
                            SELECT 'X' FROM ADS_PHUCTHAM_BANAN PTBA 
                            WHERE PTBA.DONID=A.id AND GD.MAGIAIDOAN=3
                            )               
             AND NOT EXISTS (
                            SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH PTQDVA 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID  
                            WHERE  instr(',DC,CVA,CNTT,',QDL.MA)>0
                            AND PTQDVA.DONID=A.id  AND GD.MAGIAIDOAN=3
                        )
           ;
            v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(2--dân sự
            ,v_COLUMNS,0,0,0,0,0,0,0
            );  
          ---------------------AHC_.st
          SELECT COUNT (DISTINCT A.ID) INTO v_COLUMNS FROM AHC_DON A
          INNER JOIN AHC_DON_GIAIDOAN GD ON A.ID=GD.DONID
          INNER JOIN (SELECT T2.DONID,T2.NGAYTHULY  FROM AHC_SOTHAM_THULY T2
                    INNER JOIN (
                                SELECT DISTINCT T1.DONID,MAX(T1.NGAYTHULY) OVER (PARTITION BY T1.DONID) NGAYTHULY
                                FROM AHC_SOTHAM_THULY T1 
                                ) T3 ON T2.DONID=T3.DONID AND T2.NGAYTHULY=T3.NGAYTHULY
                 ) ST ON ST.DONID=A.ID AND GD.MAGIAIDOAN=2--Lấy lần thụ lý mới nhất là trường hợp có 2 lần thụ lý trong 1 đơn
		 WHERE
          GD.TOAANID =V_TOAAN_ID
          AND GD.MAGIAIDOAN=2 
          AND ST.NGAYTHULY<=VV_TUNGAY
          AND NOT EXISTS (  SELECT 'X' FROM AHC_SOTHAM_QUYETDINH QSV 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                            WHERE instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0
                            AND QSV.DONID=A.id  AND GD.MAGIAIDOAN=2
                         )
           AND NOT EXISTS (  SELECT 'X' FROM AHC_SOTHAM_BANAN BA
                           WHERE  BA.DONID=A.id AND GD.MAGIAIDOAN=2
                        );   
            v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(6
            ,v_COLUMNS,0,0,0,0,0,0,0
            );              
          ----------------------AHC_pt
          SELECT COUNT (DISTINCT PTT.DONID) INTO v_COLUMNS FROM AHC_DON A
           INNER JOIN AHC_DON_GIAIDOAN GD ON A.ID=GD.DONID
			INNER JOIN (SELECT T2.DONID,T2.NGAYTHULY,T2.TRUONGHOPTHULY
                  FROM GSCM.AHC_PHUCTHAM_THULY T2
                  INNER JOIN (
                        SELECT DISTINCT T1.DONID,MAX(T1.NGAYTHULY) OVER (PARTITION BY T1.DONID) NGAYTHULY
                        FROM GSCM.AHC_PHUCTHAM_THULY T1
                        ) T3 ON T2.DONID=T3.DONID AND T2.NGAYTHULY=T3.NGAYTHULY
                  ) PTT ON PTT.DONID=A.ID --> Lấy thụ lý mới nhất
		WHERE
            GD.TOAPHUCTHAMID=V_TOAAN_ID   
            AND GD.MAGIAIDOAN=3
			AND PTT.NGAYTHULY<=VV_TUNGAY --CŨ CÒN LẠI
             AND NOT EXISTS (
                            SELECT 'X' FROM AHC_PHUCTHAM_BANAN PTBA 
                            WHERE PTBA.DONID=A.id AND GD.MAGIAIDOAN=3
                            )               
             AND NOT EXISTS (
                            SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH PTQDVA 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID  
                            WHERE  instr(',DC,CVA,CNTT,',QDL.MA)>0
                            AND PTQDVA.DONID=A.id  AND GD.MAGIAIDOAN=3
                        )
           ;
            v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(6
            ,v_COLUMNS,0,0,0,0,0,0,0
            );     
          ---------------------AKT_.st
          SELECT COUNT (DISTINCT A.ID) INTO v_COLUMNS FROM AKT_DON A
          INNER JOIN AKT_DON_GIAIDOAN GD ON A.ID=GD.DONID
          INNER JOIN (SELECT T2.DONID,T2.NGAYTHULY  FROM AKT_SOTHAM_THULY T2
                    INNER JOIN (
                                SELECT DISTINCT T1.DONID,MAX(T1.NGAYTHULY) OVER (PARTITION BY T1.DONID) NGAYTHULY
                                FROM AKT_SOTHAM_THULY T1 
                                ) T3 ON T2.DONID=T3.DONID AND T2.NGAYTHULY=T3.NGAYTHULY
                 ) ST ON ST.DONID=A.ID AND GD.MAGIAIDOAN=2--Lấy lần thụ lý mới nhất là trường hợp có 2 lần thụ lý trong 1 đơn
		 WHERE
          GD.TOAANID =V_TOAAN_ID
          AND GD.MAGIAIDOAN=2 
          AND ST.NGAYTHULY<=VV_TUNGAY
          AND NOT EXISTS (  SELECT 'X' FROM AKT_SOTHAM_QUYETDINH QSV 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                            WHERE instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0
                            AND QSV.DONID=A.id  AND GD.MAGIAIDOAN=2
                         )
           AND NOT EXISTS (  SELECT 'X' FROM AKT_SOTHAM_BANAN BA
                           WHERE  BA.DONID=A.id AND GD.MAGIAIDOAN=2
                        );   
            v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(4
            ,v_COLUMNS,0,0,0,0,0,0,0
            );              
          ----------------------AKT_pt_kc_kn
          SELECT COUNT (DISTINCT PTT.DONID) INTO v_COLUMNS FROM AKT_DON A
           INNER JOIN AKT_DON_GIAIDOAN GD ON A.ID=GD.DONID
			INNER JOIN (SELECT T2.DONID,T2.NGAYTHULY,T2.TRUONGHOPTHULY
                  FROM GSCM.AKT_PHUCTHAM_THULY T2
                  INNER JOIN (
                        SELECT DISTINCT T1.DONID,MAX(T1.NGAYTHULY) OVER (PARTITION BY T1.DONID) NGAYTHULY
                        FROM GSCM.AKT_PHUCTHAM_THULY T1
                        ) T3 ON T2.DONID=T3.DONID AND T2.NGAYTHULY=T3.NGAYTHULY
                  ) PTT ON PTT.DONID=A.ID --> Lấy thụ lý mới nhất
		WHERE
            GD.TOAPHUCTHAMID=V_TOAAN_ID   
            AND GD.MAGIAIDOAN=3
			AND PTT.NGAYTHULY<=VV_TUNGAY --CŨ CÒN LẠI
             AND NOT EXISTS (
                            SELECT 'X' FROM AKT_PHUCTHAM_BANAN PTBA 
                            WHERE PTBA.DONID=A.id AND GD.MAGIAIDOAN=3
                            )               
             AND NOT EXISTS (
                            SELECT 'X' FROM AKT_PHUCTHAM_QUYETDINH PTQDVA 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID  
                            WHERE  instr(',DC,CVA,CNTT,',QDL.MA)>0
                            AND PTQDVA.DONID=A.id  AND GD.MAGIAIDOAN=3
                        )
           ;
            v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(4
            ,v_COLUMNS,0,0,0,0,0,0,0
            );     
           ---------------------AHN_.st
          SELECT COUNT (DISTINCT A.ID) INTO v_COLUMNS FROM AHN_DON A
          INNER JOIN AHN_DON_GIAIDOAN GD ON A.ID=GD.DONID
          INNER JOIN (SELECT T2.DONID,T2.NGAYTHULY  FROM AHN_SOTHAM_THULY T2
                    INNER JOIN (
                                SELECT DISTINCT T1.DONID,MAX(T1.NGAYTHULY) OVER (PARTITION BY T1.DONID) NGAYTHULY
                                FROM AHN_SOTHAM_THULY T1 
                                ) T3 ON T2.DONID=T3.DONID AND T2.NGAYTHULY=T3.NGAYTHULY
                 ) ST ON ST.DONID=A.ID AND GD.MAGIAIDOAN=2--Lấy lần thụ lý mới nhất là trường hợp có 2 lần thụ lý trong 1 đơn
		 WHERE
          GD.TOAANID =V_TOAAN_ID
          AND GD.MAGIAIDOAN=2 
          AND ST.NGAYTHULY<=VV_TUNGAY
          AND NOT EXISTS (  SELECT 'X' FROM AHN_SOTHAM_QUYETDINH QSV 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                            WHERE instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0
                            AND QSV.DONID=A.id  AND GD.MAGIAIDOAN=2
                         )
           AND NOT EXISTS (  SELECT 'X' FROM AHN_SOTHAM_BANAN BA
                           WHERE  BA.DONID=A.id AND GD.MAGIAIDOAN=2
                        );   
            v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(3
            ,v_COLUMNS,0,0,0,0,0,0,0
            );              
          ----------------------AHN_pt
          SELECT COUNT (DISTINCT PTT.DONID) INTO v_COLUMNS FROM AHN_DON A
           INNER JOIN AHN_DON_GIAIDOAN GD ON A.ID=GD.DONID
			INNER JOIN (SELECT T2.DONID,T2.NGAYTHULY,T2.TRUONGHOPTHULY
                  FROM GSCM.AHN_PHUCTHAM_THULY T2
                  INNER JOIN (
                        SELECT DISTINCT T1.DONID,MAX(T1.NGAYTHULY) OVER (PARTITION BY T1.DONID) NGAYTHULY
                        FROM GSCM.AHN_PHUCTHAM_THULY T1
                        ) T3 ON T2.DONID=T3.DONID AND T2.NGAYTHULY=T3.NGAYTHULY
                  ) PTT ON PTT.DONID=A.ID --> Lấy thụ lý mới nhất
		WHERE
            GD.TOAPHUCTHAMID=V_TOAAN_ID   
            AND GD.MAGIAIDOAN=3
			AND PTT.NGAYTHULY<=VV_TUNGAY --CŨ CÒN LẠI
             AND NOT EXISTS (
                            SELECT 'X' FROM AHN_PHUCTHAM_BANAN PTBA 
                            WHERE PTBA.DONID=A.id AND GD.MAGIAIDOAN=3
                            )               
             AND NOT EXISTS (
                            SELECT 'X' FROM AHN_PHUCTHAM_QUYETDINH PTQDVA 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID  
                            WHERE  instr(',DC,CVA,CNTT,',QDL.MA)>0
                            AND PTQDVA.DONID=A.id  AND GD.MAGIAIDOAN=3
                        )
           ;
            v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(3
            ,v_COLUMNS,0,0,0,0,0,0,0
            );  
                      ---------------------ALD_.st
          SELECT COUNT (DISTINCT A.ID) INTO v_COLUMNS FROM ALD_DON A
          INNER JOIN ALD_DON_GIAIDOAN GD ON A.ID=GD.DONID
          INNER JOIN (SELECT T2.DONID,T2.NGAYTHULY  FROM ALD_SOTHAM_THULY T2
                    INNER JOIN (
                                SELECT DISTINCT T1.DONID,MAX(T1.NGAYTHULY) OVER (PARTITION BY T1.DONID) NGAYTHULY
                                FROM ALD_SOTHAM_THULY T1 
                                ) T3 ON T2.DONID=T3.DONID AND T2.NGAYTHULY=T3.NGAYTHULY
                 ) ST ON ST.DONID=A.ID AND GD.MAGIAIDOAN=2--Lấy lần thụ lý mới nhất là trường hợp có 2 lần thụ lý trong 1 đơn
		 WHERE
          GD.TOAANID =V_TOAAN_ID
          AND GD.MAGIAIDOAN=2 
          AND ST.NGAYTHULY<=VV_TUNGAY
          AND NOT EXISTS (  SELECT 'X' FROM ALD_SOTHAM_QUYETDINH QSV 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                            WHERE instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0
                            AND QSV.DONID=A.id  AND GD.MAGIAIDOAN=2
                         )
           AND NOT EXISTS (  SELECT 'X' FROM ALD_SOTHAM_BANAN BA
                           WHERE  BA.DONID=A.id AND GD.MAGIAIDOAN=2
                        );   
            v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(5
            ,v_COLUMNS,0,0,0,0,0,0,0
            );              
          ----------------------ALD_pt
          SELECT COUNT (DISTINCT PTT.DONID) INTO v_COLUMNS FROM ALD_DON A
           INNER JOIN ALD_DON_GIAIDOAN GD ON A.ID=GD.DONID
			INNER JOIN (SELECT T2.DONID,T2.NGAYTHULY,T2.TRUONGHOPTHULY
                  FROM GSCM.ALD_PHUCTHAM_THULY T2
                  INNER JOIN (
                        SELECT DISTINCT T1.DONID,MAX(T1.NGAYTHULY) OVER (PARTITION BY T1.DONID) NGAYTHULY
                        FROM GSCM.ALD_PHUCTHAM_THULY T1
                        ) T3 ON T2.DONID=T3.DONID AND T2.NGAYTHULY=T3.NGAYTHULY
                  ) PTT ON PTT.DONID=A.ID --> Lấy thụ lý mới nhất
		WHERE
            GD.TOAPHUCTHAMID=V_TOAAN_ID   
            AND GD.MAGIAIDOAN=3
			AND PTT.NGAYTHULY<=VV_TUNGAY --CŨ CÒN LẠI
             AND NOT EXISTS (
                            SELECT 'X' FROM ALD_PHUCTHAM_BANAN PTBA 
                            WHERE PTBA.DONID=A.id AND GD.MAGIAIDOAN=3
                            )               
             AND NOT EXISTS (
                            SELECT 'X' FROM ALD_PHUCTHAM_QUYETDINH PTQDVA 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID  
                            WHERE  instr(',DC,CVA,CNTT,',QDL.MA)>0
                            AND PTQDVA.DONID=A.id  AND GD.MAGIAIDOAN=3
                        )
           ;
            v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(5
            ,v_COLUMNS,0,0,0,0,0,0,0
            );    
          ----------------------
          ----------------------Mới thụ lý
          ----AHS_ST
          SELECT COUNT (DISTINCT VA.ID) INTO v_COLUMNS  FROM AHS_VUAN VA 
		  INNER JOIN AHS_VUAN_GIAIDOAN GD ON VA.ID=GD.VUANID
		  INNER JOIN AHS_SOTHAM_THULY TL ON VA.ID =TL.VUANID 
		  WHERE
             GD.TOAANID =V_TOAAN_ID
             AND GD.MAGIAIDOAN=2
			 AND TL.NGAYTHULY>=VV_TUNGAY --VU AN MOI THU LY
             AND TL.NGAYTHULY<=VV_DENNGAY
	      ;
		    v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(1
            ,0,v_COLUMNS,0,0,0,0,0,0
            );	
           ---------AHS_ pt--------------   
            SELECT COUNT (DISTINCT VA.ID)INTO v_COLUMNS FROM AHS_VUAN VA
            INNER JOIN AHS_VUAN_GIAIDOAN GD ON VA.ID=GD.VUANID
			INNER JOIN AHS_PHUCTHAM_THULY PTTL ON PTTL.VUANID=VA.ID 
		    WHERE GD.TOAPHUCTHAMID=V_TOAAN_ID
            AND GD.MAGIAIDOAN=3
			AND PTTL.NGAYTHULY>=VV_TUNGAY
            AND PTTL.NGAYTHULY<=VV_DENNGAY
            ;
             v_table.extend;
             v_table(v_table.count) := R_TL_TRINHTUXX_PT(1
             ,0,v_COLUMNS,0,0,0,0,0,0
             );	  
           ---------------------ADS_.st
          SELECT COUNT (DISTINCT A.ID) INTO v_COLUMNS FROM ADS_DON A
          INNER JOIN ADS_DON_GIAIDOAN GD ON A.ID=GD.DONID
          INNER JOIN (SELECT T2.DONID,T2.NGAYTHULY  FROM ADS_SOTHAM_THULY T2
                    INNER JOIN (
                                SELECT DISTINCT T1.DONID,MAX(T1.NGAYTHULY) OVER (PARTITION BY T1.DONID) NGAYTHULY
                                FROM ADS_SOTHAM_THULY T1 
                                ) T3 ON T2.DONID=T3.DONID AND T2.NGAYTHULY=T3.NGAYTHULY
                 ) ST ON ST.DONID=A.ID AND GD.MAGIAIDOAN=2--Lấy lần thụ lý mới nhất là trường hợp có 2 lần thụ lý trong 1 đơn
		 WHERE
          GD.TOAANID =V_TOAAN_ID
          AND GD.MAGIAIDOAN=2 
          AND ST.NGAYTHULY>=VV_TUNGAY
          AND ST.NGAYTHULY<=VV_DENNGAY;
            v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(2--dân sự
            ,0,v_COLUMNS,0,0,0,0,0,0
            ); 
           ----------------------ADS_pt
          SELECT COUNT (DISTINCT PTT.DONID) INTO v_COLUMNS FROM ADS_DON A
           INNER JOIN ADS_DON_GIAIDOAN GD ON A.ID=GD.DONID
			INNER JOIN (SELECT T2.DONID,T2.NGAYTHULY,T2.TRUONGHOPTHULY
                  FROM GSCM.ADS_PHUCTHAM_THULY T2
                  INNER JOIN (
                        SELECT DISTINCT T1.DONID,MAX(T1.NGAYTHULY) OVER (PARTITION BY T1.DONID) NGAYTHULY
                        FROM GSCM.ADS_PHUCTHAM_THULY T1
                        ) T3 ON T2.DONID=T3.DONID AND T2.NGAYTHULY=T3.NGAYTHULY
                  ) PTT ON PTT.DONID=A.ID --> Lấy thụ lý mới nhất
		WHERE
            GD.TOAPHUCTHAMID=V_TOAAN_ID   
            AND GD.MAGIAIDOAN=3
			AND PTT.NGAYTHULY>=VV_TUNGAY
            AND PTT.NGAYTHULY<=VV_DENNGAY
           ;
            v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(2--dân sự
            ,0,v_COLUMNS,0,0,0,0,0,0
            );  
                  ---------------------AHN_.st
          SELECT COUNT (DISTINCT A.ID) INTO v_COLUMNS FROM AHN_DON A
          INNER JOIN AHN_DON_GIAIDOAN GD ON A.ID=GD.DONID
          INNER JOIN (SELECT T2.DONID,T2.NGAYTHULY  FROM AHN_SOTHAM_THULY T2
                    INNER JOIN (
                                SELECT DISTINCT T1.DONID,MAX(T1.NGAYTHULY) OVER (PARTITION BY T1.DONID) NGAYTHULY
                                FROM AHN_SOTHAM_THULY T1 
                                ) T3 ON T2.DONID=T3.DONID AND T2.NGAYTHULY=T3.NGAYTHULY
                 ) ST ON ST.DONID=A.ID AND GD.MAGIAIDOAN=2--Lấy lần thụ lý mới nhất là trường hợp có 2 lần thụ lý trong 1 đơn
		 WHERE
          GD.TOAANID =V_TOAAN_ID
          AND GD.MAGIAIDOAN=2 
          AND ST.NGAYTHULY>=VV_TUNGAY
          AND ST.NGAYTHULY<=VV_DENNGAY;
            v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(3
            ,0,v_COLUMNS,0,0,0,0,0,0
            ); 
           ----------------------AHN_pt
          SELECT COUNT (DISTINCT PTT.DONID) INTO v_COLUMNS FROM AHN_DON A
           INNER JOIN AHN_DON_GIAIDOAN GD ON A.ID=GD.DONID
			INNER JOIN (SELECT T2.DONID,T2.NGAYTHULY,T2.TRUONGHOPTHULY
                  FROM GSCM.AHN_PHUCTHAM_THULY T2
                  INNER JOIN (
                        SELECT DISTINCT T1.DONID,MAX(T1.NGAYTHULY) OVER (PARTITION BY T1.DONID) NGAYTHULY
                        FROM GSCM.AHN_PHUCTHAM_THULY T1
                        ) T3 ON T2.DONID=T3.DONID AND T2.NGAYTHULY=T3.NGAYTHULY
                  ) PTT ON PTT.DONID=A.ID --> Lấy thụ lý mới nhất
		WHERE
            GD.TOAPHUCTHAMID=V_TOAAN_ID   
            AND GD.MAGIAIDOAN=3
			AND PTT.NGAYTHULY>=VV_TUNGAY
            AND PTT.NGAYTHULY<=VV_DENNGAY
           ;
            v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(3
            ,0,v_COLUMNS,0,0,0,0,0,0
            );    
                   ---------------------AKT_.st
          SELECT COUNT (DISTINCT A.ID) INTO v_COLUMNS FROM AKT_DON A
          INNER JOIN AKT_DON_GIAIDOAN GD ON A.ID=GD.DONID
          INNER JOIN (SELECT T2.DONID,T2.NGAYTHULY  FROM AKT_SOTHAM_THULY T2
                    INNER JOIN (
                                SELECT DISTINCT T1.DONID,MAX(T1.NGAYTHULY) OVER (PARTITION BY T1.DONID) NGAYTHULY
                                FROM AKT_SOTHAM_THULY T1 
                                ) T3 ON T2.DONID=T3.DONID AND T2.NGAYTHULY=T3.NGAYTHULY
                 ) ST ON ST.DONID=A.ID AND GD.MAGIAIDOAN=2--Lấy lần thụ lý mới nhất là trường hợp có 2 lần thụ lý trong 1 đơn
		 WHERE
          GD.TOAANID =V_TOAAN_ID
          AND GD.MAGIAIDOAN=2 
          AND ST.NGAYTHULY>=VV_TUNGAY
          AND ST.NGAYTHULY<=VV_DENNGAY;
            v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(4
            ,0,v_COLUMNS,0,0,0,0,0,0
            ); 
           ----------------------AKT_pt
          SELECT COUNT (DISTINCT PTT.DONID) INTO v_COLUMNS FROM AKT_DON A
           INNER JOIN AKT_DON_GIAIDOAN GD ON A.ID=GD.DONID
			INNER JOIN (SELECT T2.DONID,T2.NGAYTHULY,T2.TRUONGHOPTHULY
                  FROM GSCM.AKT_PHUCTHAM_THULY T2
                  INNER JOIN (
                        SELECT DISTINCT T1.DONID,MAX(T1.NGAYTHULY) OVER (PARTITION BY T1.DONID) NGAYTHULY
                        FROM GSCM.AKT_PHUCTHAM_THULY T1
                        ) T3 ON T2.DONID=T3.DONID AND T2.NGAYTHULY=T3.NGAYTHULY
                  ) PTT ON PTT.DONID=A.ID --> Lấy thụ lý mới nhất
		WHERE
            GD.TOAPHUCTHAMID=V_TOAAN_ID   
            AND GD.MAGIAIDOAN=3
			AND PTT.NGAYTHULY>=VV_TUNGAY
            AND PTT.NGAYTHULY<=VV_DENNGAY
           ;
            v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(4
            ,0,v_COLUMNS,0,0,0,0,0,0
            ); 
          ---------------------ALD_.st
          SELECT COUNT (DISTINCT A.ID) INTO v_COLUMNS FROM ALD_DON A
          INNER JOIN ALD_DON_GIAIDOAN GD ON A.ID=GD.DONID
          INNER JOIN (SELECT T2.DONID,T2.NGAYTHULY  FROM ALD_SOTHAM_THULY T2
                    INNER JOIN (
                                SELECT DISTINCT T1.DONID,MAX(T1.NGAYTHULY) OVER (PARTITION BY T1.DONID) NGAYTHULY
                                FROM ALD_SOTHAM_THULY T1 
                                ) T3 ON T2.DONID=T3.DONID AND T2.NGAYTHULY=T3.NGAYTHULY
                 ) ST ON ST.DONID=A.ID AND GD.MAGIAIDOAN=2--Lấy lần thụ lý mới nhất là trường hợp có 2 lần thụ lý trong 1 đơn
		 WHERE
          GD.TOAANID =V_TOAAN_ID
          AND GD.MAGIAIDOAN=2 
          AND ST.NGAYTHULY>=VV_TUNGAY
          AND ST.NGAYTHULY<=VV_DENNGAY;
            v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(5
            ,0,v_COLUMNS,0,0,0,0,0,0
            ); 
           ----------------------ALD_pt
          SELECT COUNT (DISTINCT PTT.DONID) INTO v_COLUMNS FROM ALD_DON A
           INNER JOIN ALD_DON_GIAIDOAN GD ON A.ID=GD.DONID
			INNER JOIN (SELECT T2.DONID,T2.NGAYTHULY,T2.TRUONGHOPTHULY
                  FROM GSCM.ALD_PHUCTHAM_THULY T2
                  INNER JOIN (
                        SELECT DISTINCT T1.DONID,MAX(T1.NGAYTHULY) OVER (PARTITION BY T1.DONID) NGAYTHULY
                        FROM GSCM.ALD_PHUCTHAM_THULY T1
                        ) T3 ON T2.DONID=T3.DONID AND T2.NGAYTHULY=T3.NGAYTHULY
                  ) PTT ON PTT.DONID=A.ID --> Lấy thụ lý mới nhất
		WHERE
            GD.TOAPHUCTHAMID=V_TOAAN_ID   
            AND GD.MAGIAIDOAN=3
			AND PTT.NGAYTHULY>=VV_TUNGAY
            AND PTT.NGAYTHULY<=VV_DENNGAY
           ;
            v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(5
            ,0,v_COLUMNS,0,0,0,0,0,0
            ); 
           ---------------------AHC_.st
          SELECT COUNT (DISTINCT A.ID) INTO v_COLUMNS FROM AHC_DON A
          INNER JOIN AHC_DON_GIAIDOAN GD ON A.ID=GD.DONID
          INNER JOIN (SELECT T2.DONID,T2.NGAYTHULY  FROM AHC_SOTHAM_THULY T2
                    INNER JOIN (
                                SELECT DISTINCT T1.DONID,MAX(T1.NGAYTHULY) OVER (PARTITION BY T1.DONID) NGAYTHULY
                                FROM AHC_SOTHAM_THULY T1 
                                ) T3 ON T2.DONID=T3.DONID AND T2.NGAYTHULY=T3.NGAYTHULY
                 ) ST ON ST.DONID=A.ID AND GD.MAGIAIDOAN=2--Lấy lần thụ lý mới nhất là trường hợp có 2 lần thụ lý trong 1 đơn
		 WHERE
          GD.TOAANID =V_TOAAN_ID
          AND GD.MAGIAIDOAN=2 
          AND ST.NGAYTHULY>=VV_TUNGAY
          AND ST.NGAYTHULY<=VV_DENNGAY;
            v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(6
            ,0,v_COLUMNS,0,0,0,0,0,0
            ); 
           ----------------------AHC_pt
          SELECT COUNT (DISTINCT PTT.DONID) INTO v_COLUMNS FROM AHC_DON A
           INNER JOIN AHC_DON_GIAIDOAN GD ON A.ID=GD.DONID
			INNER JOIN (SELECT T2.DONID,T2.NGAYTHULY,T2.TRUONGHOPTHULY
                  FROM GSCM.AHC_PHUCTHAM_THULY T2
                  INNER JOIN (
                        SELECT DISTINCT T1.DONID,MAX(T1.NGAYTHULY) OVER (PARTITION BY T1.DONID) NGAYTHULY
                        FROM GSCM.AHC_PHUCTHAM_THULY T1
                        ) T3 ON T2.DONID=T3.DONID AND T2.NGAYTHULY=T3.NGAYTHULY
                  ) PTT ON PTT.DONID=A.ID --> Lấy thụ lý mới nhất
		WHERE
            GD.TOAPHUCTHAMID=V_TOAAN_ID   
            AND GD.MAGIAIDOAN=3
			AND PTT.NGAYTHULY>=VV_TUNGAY
            AND PTT.NGAYTHULY<=VV_DENNGAY
           ;
            v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(6
            ,0,v_COLUMNS,0,0,0,0,0,0
            );    
          ------------------dinh chi
          ---------AHS st--------------
		SELECT COUNT(DISTINCT VA.ID)into v_COLUMNS FROM GSCM.AHS_VUAN VA 
        INNER JOIN AHS_VUAN_GIAIDOAN GD ON VA.ID=GD.VUANID
		WHERE
            GD.TOAANID =V_TOAAN_ID
            AND GD.MAGIAIDOAN=2
            AND EXISTS(SELECT 'X' FROM  AHS_SOTHAM_QUYETDINH_VUAN QSV 
                                 LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                 LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                 WHERE  instr(',DC,',','||QDL.MA||',')>0
                                 AND  QSV.NGAYQD>=VV_TUNGAY
                                 AND  QSV.NGAYQD<=VV_DENNGAY
                                 AND QSV.VUANID=VA.ID  AND GD.MAGIAIDOAN=2
                            )
            ;  
            v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(1 --hinh su
            ,0,0,0,v_COLUMNS,0,0,0,0
            );
            ---------AHS_ pt--------------   
            SELECT COUNT (DISTINCT VA.ID)INTO v_COLUMNS FROM AHS_VUAN VA
            INNER JOIN AHS_VUAN_GIAIDOAN GD ON VA.ID=GD.VUANID
			INNER JOIN GSCM.AHS_PHUCTHAM_THULY PTTL ON PTTL.VUANID=VA.ID 
		    WHERE GD.TOAPHUCTHAMID=V_TOAAN_ID
            AND GD.MAGIAIDOAN=3
             AND  EXISTS (
                                SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA 
                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID  
                                LEFT JOIN DM_QD_QUYETDINH_LYDO QDLD ON QDLD.ID=PTQDVA.LYDOID 
                                WHERE   instr(',DC,',','||QDL.MA||',')>0 --Đình chỉ
                                AND PTQDVA.VUANID=VA.ID AND GD.MAGIAIDOAN=3
                                AND  PTQDVA.NGAYQD>=VV_TUNGAY
                                AND  PTQDVA.NGAYQD<=VV_DENNGAY
                                );               

            v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(1
            ,0,0,0,v_COLUMNS,0,0,0,0
            );
           ---------------------ADS_.st
          SELECT COUNT (DISTINCT A.ID) INTO v_COLUMNS FROM ADS_DON A
          INNER JOIN ADS_DON_GIAIDOAN GD ON A.ID=GD.DONID
		 WHERE
          GD.TOAANID =V_TOAAN_ID
          AND GD.MAGIAIDOAN=2 
          AND  EXISTS (  SELECT 'X' FROM ADS_SOTHAM_QUYETDINH QSV 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                            WHERE instr(',DC,',','||QDL.MA||',')>0
                            AND  QSV.NGAYQD>=VV_TUNGAY
                            AND  QSV.NGAYQD<=VV_DENNGAY
                            AND QSV.DONID=A.id  AND GD.MAGIAIDOAN=2
                         );
            v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(2--dân sự
            ,0,0,0,v_COLUMNS,0,0,0,0
            );              
          ----------------------ADS_pt
          SELECT COUNT (DISTINCT A.ID) INTO v_COLUMNS FROM ADS_DON A
          INNER JOIN ADS_DON_GIAIDOAN GD ON A.ID=GD.DONID
		WHERE
            GD.TOAPHUCTHAMID=V_TOAAN_ID   
            AND GD.MAGIAIDOAN=3
             AND  EXISTS (
                            SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH PTQDVA 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID  
                            WHERE  instr(',DC,',QDL.MA)>0
                            AND PTQDVA.DONID=A.id  AND GD.MAGIAIDOAN=3
                            AND  PTQDVA.NGAYQD>=VV_TUNGAY
                            AND  PTQDVA.NGAYQD<=VV_DENNGAY
                        )
           ;
            v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(2--dân sự
            ,0,0,0,v_COLUMNS,0,0,0,0
            );   
                      ---------------------AHN_.st
          SELECT COUNT (DISTINCT A.ID) INTO v_COLUMNS FROM AHN_DON A
          INNER JOIN AHN_DON_GIAIDOAN GD ON A.ID=GD.DONID
		 WHERE
          GD.TOAANID =V_TOAAN_ID
          AND GD.MAGIAIDOAN=2 
          AND  EXISTS (  SELECT 'X' FROM AHN_SOTHAM_QUYETDINH QSV 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                            WHERE instr(',DC,',','||QDL.MA||',')>0
                            AND  QSV.NGAYQD>=VV_TUNGAY
                            AND  QSV.NGAYQD<=VV_DENNGAY
                            AND QSV.DONID=A.id  AND GD.MAGIAIDOAN=2
                         );
            v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(3
            ,0,0,0,v_COLUMNS,0,0,0,0
            );              
          ----------------------AHN_pt
          SELECT COUNT (DISTINCT A.ID) INTO v_COLUMNS FROM AHN_DON A
          INNER JOIN AHN_DON_GIAIDOAN GD ON A.ID=GD.DONID
		WHERE
            GD.TOAPHUCTHAMID=V_TOAAN_ID   
            AND GD.MAGIAIDOAN=3
             AND  EXISTS (
                            SELECT 'X' FROM AHN_PHUCTHAM_QUYETDINH PTQDVA 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID  
                            WHERE  instr(',DC,',QDL.MA)>0
                            AND PTQDVA.DONID=A.id  AND GD.MAGIAIDOAN=3
                            AND  PTQDVA.NGAYQD>=VV_TUNGAY
                            AND  PTQDVA.NGAYQD<=VV_DENNGAY
                        )
           ;
            v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(3
            ,0,0,0,v_COLUMNS,0,0,0,0
            );   
                    ---------------------AKT_.st
          SELECT COUNT (DISTINCT A.ID) INTO v_COLUMNS FROM AKT_DON A
          INNER JOIN AKT_DON_GIAIDOAN GD ON A.ID=GD.DONID
		 WHERE
          GD.TOAANID =V_TOAAN_ID
          AND GD.MAGIAIDOAN=2 
          AND  EXISTS (  SELECT 'X' FROM AKT_SOTHAM_QUYETDINH QSV 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                            WHERE instr(',DC,',','||QDL.MA||',')>0
                            AND  QSV.NGAYQD>=VV_TUNGAY
                            AND  QSV.NGAYQD<=VV_DENNGAY
                            AND QSV.DONID=A.id  AND GD.MAGIAIDOAN=2
                         );
            v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(4
            ,0,0,0,v_COLUMNS,0,0,0,0
            );              
          ----------------------AKT_pt
          SELECT COUNT (DISTINCT A.ID) INTO v_COLUMNS FROM AKT_DON A
          INNER JOIN AKT_DON_GIAIDOAN GD ON A.ID=GD.DONID
		WHERE
            GD.TOAPHUCTHAMID=V_TOAAN_ID   
            AND GD.MAGIAIDOAN=3
             AND  EXISTS (
                            SELECT 'X' FROM AKT_PHUCTHAM_QUYETDINH PTQDVA 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID  
                            WHERE  instr(',DC,',QDL.MA)>0
                            AND PTQDVA.DONID=A.id  AND GD.MAGIAIDOAN=3
                            AND  PTQDVA.NGAYQD>=VV_TUNGAY
                            AND  PTQDVA.NGAYQD<=VV_DENNGAY
                        )
           ;
            v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(4
            ,0,0,0,v_COLUMNS,0,0,0,0
            );   
           ---------------------ALD_.st
          SELECT COUNT (DISTINCT A.ID) INTO v_COLUMNS FROM ALD_DON A
          INNER JOIN ALD_DON_GIAIDOAN GD ON A.ID=GD.DONID
		 WHERE
          GD.TOAANID =V_TOAAN_ID
          AND GD.MAGIAIDOAN=2 
          AND  EXISTS (  SELECT 'X' FROM ALD_SOTHAM_QUYETDINH QSV 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                            WHERE instr(',DC,',','||QDL.MA||',')>0
                            AND  QSV.NGAYQD>=VV_TUNGAY
                            AND  QSV.NGAYQD<=VV_DENNGAY
                            AND QSV.DONID=A.id  AND GD.MAGIAIDOAN=2
                         );
            v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(5
            ,0,0,0,v_COLUMNS,0,0,0,0
            );              
          ----------------------ALD_pt
          SELECT COUNT (DISTINCT A.ID) INTO v_COLUMNS FROM ALD_DON A
          INNER JOIN ALD_DON_GIAIDOAN GD ON A.ID=GD.DONID
		WHERE
            GD.TOAPHUCTHAMID=V_TOAAN_ID   
            AND GD.MAGIAIDOAN=3
             AND  EXISTS (
                            SELECT 'X' FROM ALD_PHUCTHAM_QUYETDINH PTQDVA 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID  
                            WHERE  instr(',DC,',QDL.MA)>0
                            AND PTQDVA.DONID=A.id  AND GD.MAGIAIDOAN=3
                            AND  PTQDVA.NGAYQD>=VV_TUNGAY
                            AND  PTQDVA.NGAYQD<=VV_DENNGAY
                        )
           ;
            v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(5
            ,0,0,0,v_COLUMNS,0,0,0,0
            );   
           ---------------------AHC_.st
          SELECT COUNT (DISTINCT A.ID) INTO v_COLUMNS FROM AHC_DON A
          INNER JOIN AHC_DON_GIAIDOAN GD ON A.ID=GD.DONID
		 WHERE
          GD.TOAANID =V_TOAAN_ID
          AND GD.MAGIAIDOAN=2 
          AND  EXISTS (  SELECT 'X' FROM AHC_SOTHAM_QUYETDINH QSV 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                            WHERE instr(',DC,',','||QDL.MA||',')>0
                            AND  QSV.NGAYQD>=VV_TUNGAY
                            AND  QSV.NGAYQD<=VV_DENNGAY
                            AND QSV.DONID=A.id  AND GD.MAGIAIDOAN=2
                         );
            v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(6
            ,0,0,0,v_COLUMNS,0,0,0,0
            );              
          ----------------------AHC_pt
          SELECT COUNT (DISTINCT A.ID) INTO v_COLUMNS FROM AHC_DON A
          INNER JOIN AHC_DON_GIAIDOAN GD ON A.ID=GD.DONID
		WHERE
            GD.TOAPHUCTHAMID=V_TOAAN_ID   
            AND GD.MAGIAIDOAN=3
             AND  EXISTS (
                            SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH PTQDVA 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID  
                            WHERE  instr(',DC,',QDL.MA)>0
                            AND PTQDVA.DONID=A.id  AND GD.MAGIAIDOAN=3
                            AND  PTQDVA.NGAYQD>=VV_TUNGAY
                            AND  PTQDVA.NGAYQD<=VV_DENNGAY
                        )
           ;
            v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(6
            ,0,0,0,v_COLUMNS,0,0,0,0
            );     
         ------------------xet xu
         ---------AHS st--------------
		SELECT COUNT(DISTINCT VA.ID)into v_COLUMNS FROM GSCM.AHS_VUAN VA 
        INNER JOIN AHS_VUAN_GIAIDOAN GD ON VA.ID=GD.VUANID
		WHERE
            GD.TOAANID =V_TOAAN_ID
            AND GD.MAGIAIDOAN=2
             AND EXISTS( SELECT 'X' FROM  AHS_SOTHAM_BANAN BA 
                             WHERE BA.VUANID=VA.ID AND GD.MAGIAIDOAN=2
                              AND  BA.NGAYBANAN>=VV_TUNGAY
                              AND  BA.NGAYBANAN<=VV_DENNGAY
                            );  
            v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(1
            ,0,0,0,0,v_COLUMNS,0,0,0
            );
            ---------AHS_ pt--------------   
            SELECT COUNT (DISTINCT VA.ID)INTO v_COLUMNS FROM AHS_VUAN VA
            INNER JOIN AHS_VUAN_GIAIDOAN GD ON VA.ID=GD.VUANID
		    WHERE GD.TOAPHUCTHAMID=V_TOAAN_ID
            AND GD.MAGIAIDOAN=3
            AND EXISTS  ( SELECT 'X' FROM AHS_PHUCTHAM_BANAN PTBA
                              WHERE PTBA.VUANID=VA.ID  AND GD.MAGIAIDOAN=3
                              AND  PTBA.NGAYBANAN>=VV_TUNGAY
                              AND  PTBA.NGAYBANAN<=VV_DENNGAY
                            );
            v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(1
            ,0,0,0,v_COLUMNS,0,0,0,0
            );  
            ---------------------ADS_.st
          SELECT COUNT (DISTINCT A.ID) INTO v_COLUMNS FROM ADS_DON A
          INNER JOIN ADS_DON_GIAIDOAN GD ON A.ID=GD.DONID
		 WHERE
          GD.TOAANID =V_TOAAN_ID
          AND GD.MAGIAIDOAN=2 
          AND  EXISTS (  SELECT 'X' FROM ADS_SOTHAM_BANAN BA
                           WHERE  BA.DONID=A.id AND GD.MAGIAIDOAN=2
                            AND  BA.NGAYTUYENAN>=VV_TUNGAY
                            AND  BA.NGAYTUYENAN<=VV_DENNGAY
                        );   
            v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(2
            ,0,0,0,0,v_COLUMNS,0,0,0
            );              
          ----------------------ADS_pt
          SELECT COUNT (DISTINCT A.ID) INTO v_COLUMNS FROM ADS_DON A
          INNER JOIN ADS_DON_GIAIDOAN GD ON A.ID=GD.DONID
		WHERE
            GD.TOAPHUCTHAMID=V_TOAAN_ID   
            AND GD.MAGIAIDOAN=3
             AND  EXISTS (
                            SELECT 'X' FROM ADS_PHUCTHAM_BANAN PTBA 
                            WHERE PTBA.DONID=A.id AND GD.MAGIAIDOAN=3
                            AND  PTBA.NGAYTUYENAN>=VV_TUNGAY
                            AND  PTBA.NGAYTUYENAN<=VV_DENNGAY
                            ) 
           ;
           v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(2
            ,0,0,0,0,v_COLUMNS,0,0,0
            ); 
               ---------------------AHN_.st
          SELECT COUNT (DISTINCT A.ID) INTO v_COLUMNS FROM AHN_DON A
          INNER JOIN AHN_DON_GIAIDOAN GD ON A.ID=GD.DONID
		 WHERE
          GD.TOAANID =V_TOAAN_ID
          AND GD.MAGIAIDOAN=2 
          AND  EXISTS (  SELECT 'X' FROM AHN_SOTHAM_BANAN BA
                           WHERE  BA.DONID=A.id AND GD.MAGIAIDOAN=2
                            AND  BA.NGAYTUYENAN>=VV_TUNGAY
                            AND  BA.NGAYTUYENAN<=VV_DENNGAY
                        );   
            v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(3
            ,0,0,0,0,v_COLUMNS,0,0,0
            );              
          ----------------------AHN_pt
          SELECT COUNT (DISTINCT A.ID) INTO v_COLUMNS FROM AHN_DON A
          INNER JOIN AHN_DON_GIAIDOAN GD ON A.ID=GD.DONID
		WHERE
            GD.TOAPHUCTHAMID=V_TOAAN_ID   
            AND GD.MAGIAIDOAN=3
             AND  EXISTS (
                            SELECT 'X' FROM AHN_PHUCTHAM_BANAN PTBA 
                            WHERE PTBA.DONID=A.id AND GD.MAGIAIDOAN=3
                            AND  PTBA.NGAYTUYENAN>=VV_TUNGAY
                            AND  PTBA.NGAYTUYENAN<=VV_DENNGAY
                            ) 
           ;
           v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(3
            ,0,0,0,0,v_COLUMNS,0,0,0
            );    
              ---------------------AKT_.st
          SELECT COUNT (DISTINCT A.ID) INTO v_COLUMNS FROM AKT_DON A
          INNER JOIN AKT_DON_GIAIDOAN GD ON A.ID=GD.DONID
		 WHERE
          GD.TOAANID =V_TOAAN_ID
          AND GD.MAGIAIDOAN=2 
          AND  EXISTS (  SELECT 'X' FROM AKT_SOTHAM_BANAN BA
                           WHERE  BA.DONID=A.id AND GD.MAGIAIDOAN=2
                            AND  BA.NGAYTUYENAN>=VV_TUNGAY
                            AND  BA.NGAYTUYENAN<=VV_DENNGAY
                        );   
            v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(4
            ,0,0,0,0,v_COLUMNS,0,0,0
            );              
          ----------------------AKT_pt
          SELECT COUNT (DISTINCT A.ID) INTO v_COLUMNS FROM AKT_DON A
          INNER JOIN AKT_DON_GIAIDOAN GD ON A.ID=GD.DONID
		WHERE
            GD.TOAPHUCTHAMID=V_TOAAN_ID   
            AND GD.MAGIAIDOAN=3
             AND  EXISTS (
                            SELECT 'X' FROM AKT_PHUCTHAM_BANAN PTBA 
                            WHERE PTBA.DONID=A.id AND GD.MAGIAIDOAN=3
                            AND  PTBA.NGAYTUYENAN>=VV_TUNGAY
                            AND  PTBA.NGAYTUYENAN<=VV_DENNGAY
                            ) 
           ;
           v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(4
            ,0,0,0,0,v_COLUMNS,0,0,0
            );
             ---------------------ALD_.st
          SELECT COUNT (DISTINCT A.ID) INTO v_COLUMNS FROM ALD_DON A
          INNER JOIN ALD_DON_GIAIDOAN GD ON A.ID=GD.DONID
		 WHERE
          GD.TOAANID =V_TOAAN_ID
          AND GD.MAGIAIDOAN=2 
          AND  EXISTS (  SELECT 'X' FROM ALD_SOTHAM_BANAN BA
                           WHERE  BA.DONID=A.id AND GD.MAGIAIDOAN=2
                            AND  BA.NGAYTUYENAN>=VV_TUNGAY
                            AND  BA.NGAYTUYENAN<=VV_DENNGAY
                        );   
            v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(5
            ,0,0,0,0,v_COLUMNS,0,0,0
            );              
          ----------------------ALD_pt
          SELECT COUNT (DISTINCT A.ID) INTO v_COLUMNS FROM ALD_DON A
          INNER JOIN ALD_DON_GIAIDOAN GD ON A.ID=GD.DONID
		WHERE
            GD.TOAPHUCTHAMID=V_TOAAN_ID   
            AND GD.MAGIAIDOAN=3
             AND  EXISTS (
                            SELECT 'X' FROM ALD_PHUCTHAM_BANAN PTBA 
                            WHERE PTBA.DONID=A.id AND GD.MAGIAIDOAN=3
                            AND  PTBA.NGAYTUYENAN>=VV_TUNGAY
                            AND  PTBA.NGAYTUYENAN<=VV_DENNGAY
                            ) 
           ;
           v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(5
            ,0,0,0,0,v_COLUMNS,0,0,0
            );   
               ---------------------AHC_.st
          SELECT COUNT (DISTINCT A.ID) INTO v_COLUMNS FROM AHC_DON A
          INNER JOIN AHC_DON_GIAIDOAN GD ON A.ID=GD.DONID
		 WHERE
          GD.TOAANID =V_TOAAN_ID
          AND GD.MAGIAIDOAN=2 
          AND  EXISTS (  SELECT 'X' FROM AHC_SOTHAM_BANAN BA
                           WHERE  BA.DONID=A.id AND GD.MAGIAIDOAN=2
                            AND  BA.NGAYTUYENAN>=VV_TUNGAY
                            AND  BA.NGAYTUYENAN<=VV_DENNGAY
                        );   
            v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(6
            ,0,0,0,0,v_COLUMNS,0,0,0
            );              
          ----------------------AHC_pt
          SELECT COUNT (DISTINCT A.ID) INTO v_COLUMNS FROM AHC_DON A
          INNER JOIN AHC_DON_GIAIDOAN GD ON A.ID=GD.DONID
		WHERE
            GD.TOAPHUCTHAMID=V_TOAAN_ID   
            AND GD.MAGIAIDOAN=3
             AND  EXISTS (
                            SELECT 'X' FROM AHC_PHUCTHAM_BANAN PTBA 
                            WHERE PTBA.DONID=A.id AND GD.MAGIAIDOAN=3
                            AND  PTBA.NGAYTUYENAN>=VV_TUNGAY
                            AND  PTBA.NGAYTUYENAN<=VV_DENNGAY
                            ) 
           ;
           v_table.extend;
            v_table(v_table.count) := R_TL_TRINHTUXX_PT(6
            ,0,0,0,0,v_COLUMNS,0,0,0
            );    
          -----print dữ liệu----   
          FOR items IN (
                 SELECT ROW_NUMBER() OVER(ORDER BY LA.THUTU) AS TT,LA.LOAI_AN_TEN,PP.* FROM(
                      SELECT PA.v_LOAIANID,SUM(v_COLUMN_1)v_COLUMN_1,SUM(v_COLUMN_2)v_COLUMN_2,SUM(v_COLUMN_1+v_COLUMN_2)v_COLUMN_3,SUM(v_COLUMN_4)v_COLUMN_4
                     ,SUM(v_COLUMN_5)v_COLUMN_5,SUM(v_COLUMN_4+v_COLUMN_5)v_COLUMN_6,SUM((v_COLUMN_1+v_COLUMN_2)-(v_COLUMN_4+v_COLUMN_5))v_COLUMN_7
                     ,SUM(v_COLUMN_8)v_COLUMN_8
                      FROM TABLE(V_TABLE) PA
                 GROUP BY PA.v_LOAIANID
                 )PP
                 LEFT JOIN DM_LOAIAN LA ON LA.ID=PP.v_LOAIANID
               )
               LOOP
                SELECT DECODE(items.v_COLUMN_3,0,0,ROUND(items.v_COLUMN_6/items.v_COLUMN_3*100,2)) INTO v_COLUMN_8_TYLE FROM DUAL;
                      DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'
                      <tr>
                         <th style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.TT||'</th>
                            <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||items.LOAI_AN_TEN||'</td>
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.v_COLUMN_1||'</td>
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.v_COLUMN_2||'</td>
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.v_COLUMN_3||'</td>
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.v_COLUMN_4||'</td>
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.v_COLUMN_5||'</td>
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.v_COLUMN_6||'</td>
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.v_COLUMN_7||'</td>
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_COLUMN_8_TYLE||'</td>
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"></td>
                      </tr>
                   '); 
               END LOOP;   
        -----print TONG CONG----   
          FOR items IN (
                      SELECT SUM(v_COLUMN_1)v_COLUMN_1,SUM(v_COLUMN_2)v_COLUMN_2,SUM(v_COLUMN_1+v_COLUMN_2)v_COLUMN_3,SUM(v_COLUMN_4)v_COLUMN_4
                     ,SUM(v_COLUMN_5)v_COLUMN_5,SUM(v_COLUMN_4+v_COLUMN_5)v_COLUMN_6,SUM((v_COLUMN_1+v_COLUMN_2)-(v_COLUMN_4+v_COLUMN_5))v_COLUMN_7
                     ,SUM(v_COLUMN_8)v_COLUMN_8
                      FROM TABLE(V_TABLE) PA
               )
               LOOP
                SELECT DECODE(items.v_COLUMN_3,0,0,ROUND(items.v_COLUMN_6/items.v_COLUMN_3*100,2)) INTO v_COLUMN_8_TYLE FROM DUAL;
                      DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'
                      <tr>
                           <th colspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Tổng cộng</th>
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.v_COLUMN_1||'</td>
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.v_COLUMN_2||'</td>
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.v_COLUMN_3||'</td>
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.v_COLUMN_4||'</td>
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.v_COLUMN_5||'</td>
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.v_COLUMN_6||'</td>
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.v_COLUMN_7||'</td>
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_COLUMN_8_TYLE||'</td>
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"></td>
                      </tr>
                   '); 
               END LOOP;        
     ---------------------------khung bc
     DBMS_LOB.APPEND(V_EXPORT_TEXT,'
          <table cellpadding="1" style="font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;">
            <tr>
                <td colspan="4" style="text-align: center; vertical-align: top; font-size: 11pt">TÒA ÁN NHÂN DÂN TỐI CAO</td>
                <td colspan="2"></td>
                <th colspan="5" style="text-align: center; vertical-align: top; font-size: 11pt;">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</th>
            </tr>
            <tr style="text-align: center;">
                <th colspan="4" style="vertical-align: top; font-size: 11pt;">'||UPPER(V_TOAAN_NAME)||'</th>
                <td colspan="2"></td>
                <th colspan="5" style="vertical-align: top; font-size: 13pt;">Độc lập - Tự do - Hạnh phúc </th>
            </tr>
            <tr>
                <td colspan="11" style="line-height: 100%; font-size: 13pt; text-align: center; height: 26px;"><b>THỐNG KÊ TÌNH HÌNH THỤ LÝ, GIẢI QUYẾT XÉT XỬ</b></td>
            </tr>
            <tr>
                <td colspan="11" style="line-height: 100%; font-size: 13pt; text-align: center; height: 22px;"><b>THEO TRÌNH TỰ PHÚC THẨM CÁC LOẠI VỤ, VIỆC</b></td>
            </tr>
            <tr>
                <td colspan="11" style="line-height: 100%; font-size: 13pt; text-align: center; height: 24px; font-style: italic;">Tính từ ngày '||V_TUNGAY||' đến '||V_DENNGAY||'</td>
            </tr>
            <tr style="font-weight: bold;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;" rowspan="2">TT</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;" rowspan="2">Loại án</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; height: 31px;" colspan="3">SỐ VỤ VIỆC PHẢI GIẢI QUYẾT</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;" colspan="5">SỐ VỤ VIỆC ĐÃ GIẢI QUYẾT</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;" rowspan="2">GHI CHÚ</td>
            </tr>
            <tr style="font-weight: bold;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Cũ còn lại (vụ)</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới (vụ)</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Tổng số (vụ)</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đình chỉ (vụ)</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Xét xử (vụ)</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Tổng số (vụ)</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Còn lại (vụ)</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Tỷ lệ(%)</td>
            </tr>
            <tr>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic;"></td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic;"></td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">1</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">2</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">3</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">4</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">5</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">6</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">7</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">8</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">9</td>
            </tr>
                 '); 
      ------ADD DỮ LIỆU VÀO THÂN BÁO CÁO
      DBMS_LOB.APPEND(V_EXPORT_TEXT,V_EXPORT_TEXT_ITEM );
      DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
            <tr>
              <td colspan="11" style="height:13px;"></td>
            </tr>
            <tr>
                <td colspan="3" style="vertical-align: middle; text-align: center; font-weight: bold;"></td>
                <td colspan="3" style="vertical-align: middle; text-align: center"></td>
                <td colspan="5" style="vertical-align: middle; text-align: center; font-style: italic; font-size: 12pt;">'||REPLACE(REPLACE(V_HANHCHINH_NAME,'thành phố','TP.'),'tỉnh','')||', ngày '||TO_CHAR(sysdate, 'DD')||' tháng '||to_char(EXTRACT(month FROM sysdate))||' năm '||to_char(extract(year from sysdate))||'</td>
            </tr>
            <tr>
                <td colspan="3" style="vertical-align: middle; text-align: center; font-weight: bold;"></td>
                <td colspan="3" style="vertical-align: middle; text-align: center"></td>
                <td colspan="5" style="vertical-align: middle; text-align: center; font-weight: bold;">TL. CHÁNH ÁN</td>
            </tr>
            <tr>
                <td colspan="3" style="height: 100px; vertical-align: top; text-align: center; font-weight: bold;">NGƯỜI LẬP BIỂU</td>
                <td colspan="3" style="height: 100px; vertical-align: top; text-align: center"></td>
                <td colspan="5" style="height: 100px; vertical-align: top; text-align: center; font-weight: bold;">TRƯỞNG PHÒNG - PHÒNG HÀNH CHÍNH TƯ PHÁP</td>
            </tr>
            <tr>
                <td colspan="3" style="vertical-align: top; text-align: center; font-weight: bold;font-size: 12pt;">'||V_CANBO_TK_NAME||'</td>
                <td colspan="3" style="vertical-align: top; text-align: center"></td>
                <td colspan="5" style="vertical-align: top; text-align: center; font-weight: bold;font-size: 12pt;">'||V_LANHDAO_TK_NAME||'</td>
            </tr>
       ');     
     -----------------------
    DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
          <tr style="height: 1px;">
               <td style="width: 30px"></td>
                <td style="width: 150px"></td>
                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 120px"></td>
            </tr>
        </table>
      ');
    ----------------------------
    OPEN V_CURSOR FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;       
 END TL_XX_TRINHTU_PT;  
END PKG_STPT_SEARCH_BC;
