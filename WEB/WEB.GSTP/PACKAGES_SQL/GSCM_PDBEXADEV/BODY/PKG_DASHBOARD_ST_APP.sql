--------------------------------------------------------
--  DDL for Package Body PKG_DASHBOARD_ST_APP
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_DASHBOARD_ST_APP" AS
PROCEDURE DASHBOARD_CREATE_DATA_ADS_ST
 AS    
    V_SYSDATE DATE;V_COUNTS NUMBER;
    V_KQLOAI NUMBER; V_SOTHULYXX VARCHAR2(512);V_NGAYTHULYXX DATE;
BEGIN
    DELETE DASHBOARD_STPT WHERE LOAIAN=2 AND CAPXX=2;COMMIT;  
    SELECT SYSDATE INTO V_SYSDATE FROM DUAL; 
    ------
      FOR item in (
                    SELECT TL.TOAANID
                    ,TL.SOTHULY
                    ,TL.NGAYTHULY
                    ,'2' CAPXX 
                    ,D.MAVUVIEC
                    ,CASE WHEN QDBA.SOQD IS NULL AND STBA.SOBANAN IS NULL  THEN NULL
                        WHEN QDBA.SOQD IS NOT NULL THEN 1
                        WHEN STBA.SOBANAN IS NOT NULL  THEN 0
                     END  KQLOAI
                    ,DECODE (QDBA.SOQD,NULL,STBA.SOBANAN,QDBA.SOQD) KQSO
                    ,DECODE (QDBA.NGAYQD, NULL,STBA.NGAYTUYENAN,QDBA.NGAYQD) KQNGAY
                    ,DECODE (QDBA.NGAYQD, NULL,NULL,QDBA.TEN) KQNOIDUNG
                    ,NKC.NGUOIKHANGCAO
                    ,NGAYKC.NGAYKHANGCAO
                    ,ND.TENDUONGSU NGUYENDON
                    ,BD.TENDUONGSU BIDON 
                    ,TP.THAMPHANID
                    ,NKN.NGAYKN NGAYKHANGNGHI
                    ,D.QUANHEPHAPLUAT_NAME QHPL
                    ,2 LOAIAN
                    ,null NGAYDONGBO    
                    ,D.TENVUVIEC
                    ,SLKC.SL_KHANGCAO
                    ,SLKN.SL_KHANGNGHI
                    ,TL.DONID 
                    ,TL.ID THULYID
                    FROM ADS_SOTHAM_THULY TL 
                    LEFT JOIN ADS_DON D ON D.ID=TL.DONID
                    LEFT JOIN(SELECT BA.DONID,BA.SOBANAN,BA.NGAYTUYENAN
                                            FROM ADS_SOTHAM_BANAN BA)STBA ON STBA.DONID=TL.DONID  
                    LEFT JOIN (
                             SELECT TT.DONID
                            ,DECODE(instr(TT.THAMPHANID,','),0,TT.THAMPHANID,SUBSTR(TT.THAMPHANID,0,instr(TT.THAMPHANID,',') - 1))THAMPHANID    
                             FROM ( SELECT hd.DONID                            
                                   ,LISTAGG(hd.CANBOID,',')WITHIN GROUP (ORDER BY hd.NGAYPHANCONG DESC)THAMPHANID      
                                    FROM ADS_SOTHAM_HDXX hd 
                                    WHERE hd.mavaitro='THAMPHAN' and hd.DONID!=0
                                    group by hd.DONID
                               )TT
                    )TP ON TP.DONID=TL.DONID
                     LEFT JOIN (
                             SELECT COUNT(*) SL_KHANGCAO,KC.DONID FROM ADS_SOTHAM_KHANGCAO KC  GROUP BY KC.DONID
                     )SLKC ON SLKC.DONID=TL.DONID
                     LEFT JOIN (
                             SELECT COUNT(*) SL_KHANGNGHI,KN.DONID FROM ADS_SOTHAM_KHANGNGHI KN  GROUP BY KN.DONID
                     )SLKN ON SLKN.DONID=TL.DONID
                     LEFT JOIN (
                       SELECT TT.DONID,TT.TENDUONGSU  
                        FROM(SELECT COUNT(*), TS.DONID
                          ,LISTAGG(TS.TENDUONGSU,', ')WITHIN GROUP (ORDER BY TS.ISDAIDIEN DESC,TS.TENDUONGSU)TENDUONGSU
                             FROM (
                                       SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER,BC.ISDAIDIEN
                                        FROM (SELECT ID,DONID,TENDUONGSU,TUCACHTOTUNG_MA,ISDAIDIEN,ROW_NUMBER()  OVER (PARTITION BY DONID ORDER BY ISDAIDIEN DESC,TENDUONGSU) ROWNUMBER
                                        FROM ADS_DON_DUONGSU WHERE TUCACHTOTUNG_MA='BIDON'--ISDAIDIEN=1                              
                                        ) BC 
                                       -- WHERE BC.ROWNUMBER <= 3
                                ) TS GROUP BY TS.DONID    
                         )TT
                    )BD ON BD.DONID=TL.DONID  
                    LEFT JOIN (
                         SELECT TT.DONID,TT.TENDUONGSU  
                          FROM(SELECT TS.DONID
                              ,LISTAGG(TS.TENDUONGSU,', ')WITHIN GROUP (ORDER BY TS.ISDAIDIEN DESC,TS.TENDUONGSU)TENDUONGSU
                                 FROM (  SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER,BC.ISDAIDIEN
                                            FROM (SELECT ID,DONID,TENDUONGSU,TUCACHTOTUNG_MA,ISDAIDIEN,ROW_NUMBER()  OVER (PARTITION BY DONID ORDER BY ISDAIDIEN DESC,TENDUONGSU) ROWNUMBER
                                            FROM ADS_DON_DUONGSU WHERE TUCACHTOTUNG_MA='NGUYENDON'--ISDAIDIEN=1                              
                                            ) BC 
                                          --  WHERE BC.ROWNUMBER <= 3
                                    ) TS GROUP BY TS.DONID    
                           )TT
                      )ND ON ND.DONID=TL.DONID                  
                    LEFT JOIN(SELECT TT.DONID
                                ,DECODE(instr(TT.SOQD,','),0,TT.SOQD,SUBSTR(TT.SOQD,0,instr(TT.SOQD,',') - 1))SOQD 
                                ,DECODE(instr(TT.NGAYQD,','),0,TT.NGAYQD,SUBSTR(TT.NGAYQD,0,instr(TT.NGAYQD,',') - 1))NGAYQD 
                                ,DECODE(instr(TT.ten,','),0,TT.ten,SUBSTR(TT.ten,0,instr(TT.ten,',') - 1))TEN 
                                FROM ( 
                                     SELECT QD.DONID
                                    ,LISTAGG(QD.SOQD,',')WITHIN GROUP (ORDER BY QD.NGAYQD DESC)SOQD
                                    ,LISTAGG(QD.NGAYQD,',')WITHIN GROUP (ORDER BY QD.NGAYQD DESC)NGAYQD
                                    ,LISTAGG(dqd.TEN,',')WITHIN GROUP (ORDER BY QD.NGAYQD DESC)TEN
                                                FROM ADS_SOTHAM_QUYETDINH QD
                                                LEFT JOIN DM_QD_QUYETDINH DQD ON DQD.ID=QD.QUYETDINHID 
                                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=DQD.LOAIID
                                                WHERE dqd.ket_thuc = 1
                                      group by QD.DONID
                                      )TT
                                )QDBA ON QDBA.DONID=TL.DONID  
                    LEFT JOIN (
                          SELECT TT.DONID,TT.NGUOIKHANGCAO  
                          FROM(SELECT TS.DONID                               
                              ,LISTAGG(TS.TENDUONGSU,', ')WITHIN GROUP (ORDER BY TS.ISDAIDIEN DESC,TS.TENDUONGSU)NGUOIKHANGCAO
                               FROM (SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER,BC.ISDAIDIEN 
                                                  FROM (SELECT DS.ID,DS.DONID,DS.TENDUONGSU,DS.TUCACHTOTUNG_MA,DS.ISDAIDIEN ,ROW_NUMBER() OVER (PARTITION BY DS.DONID ORDER BY DS.ISDAIDIEN DESC,DS.TENDUONGSU) ROWNUMBER
                                                        FROM ADS_DON_DUONGSU DS
                                                        WHERE EXISTS(SELECT 1 FROM ADS_SOTHAM_KHANGCAO KC WHERE KC.DUONGSUID=DS.ID AND KC.LOAIKHANGCAO !=2 AND KC.DONID=DS.DONID)
                                                        )BC                                       
                                                  WHERE BC.ROWNUMBER <=3
                                    ) TS GROUP BY TS.DONID    
                             )TT
                    )NKC ON NKC.DONID=TL.DONID 
                    LEFT JOIN (  SELECT TT.DONID
                                ,DECODE(instr(TT.NGAYKHANGCAO,','),0,TT.NGAYKHANGCAO,SUBSTR(TT.NGAYKHANGCAO,0,instr(TT.NGAYKHANGCAO,',') - 1))NGAYKHANGCAO    
                                FROM ( 
                                     SELECT KC.DONID
                                            ,LISTAGG(KC.NGAYKHANGCAO,',')WITHIN GROUP (ORDER BY KC.NGAYKHANGCAO DESC)NGAYKHANGCAO      
                                                FROM ADS_SOTHAM_KHANGCAO KC 
                                                WHERE KC.LOAIKHANGCAO !=2 
                                      group by KC.DONID
                                      )TT
                      )NGAYKC ON NGAYKC.DONID=TL.DONID 
                   LEFT JOIN (
                           SELECT TT.DONID
                            ,DECODE(instr(TT.NGAYKN,','),0,TT.NGAYKN,SUBSTR(TT.NGAYKN,0,instr(TT.NGAYKN,',') - 1))NGAYKN    
                            FROM ( 
                            SELECT KN.DONID
                            ,LISTAGG(KN.NGAYKN,',')WITHIN GROUP (ORDER BY KN.NGAYKN DESC)NGAYKN      
                            FROM ADS_SOTHAM_KHANGNGHI KN 
                            WHERE KN.TINHTRANG_GIAIQUYET != 3 
                            group by KN.DONID
                            )TT
                      )NKN ON NKN.DONID=TL.DONID
                    WHERE TL.NGAYTHULY IS NOT NULL AND TL.truonghopthuly IN (1)
                    AND d.MAVUVIEC IS NOT NULL  AND TL.SOTHULY IS NOT NULL  AND TL.NGAYTHULY IS NOT NULL
      )
      LOOP
          insert into DASHBOARD_STPT
                        (TOAANID,SOTHULY,NGAYTHULY,CAPXX,MAVUVIEC,KQLOAI,KQSO,KQNGAY,KQNOIDUNG,NGUOIKHANGCAO,NGAYKHANGCAO,NGUYENDON,BIDON,THAMPHANID,NGAYKHANGNGHI,QHPL,LOAIAN
                        ,NGAYDONGBO,TENVUVIEC,SL_KHANGCAO,SL_KHANGNGHI
                        ,DONID,THULYID)
                        values 
                        (item.TOAANID,item.SOTHULY,item.NGAYTHULY,item.CAPXX,item.MAVUVIEC,item.KQLOAI,item.KQSO,item.KQNGAY,item.KQNOIDUNG,item.NGUOIKHANGCAO,item.NGAYKHANGCAO,item.NGUYENDON,item.BIDON,item.THAMPHANID,item.NGAYKHANGNGHI,item.QHPL,item.LOAIAN
                        ,V_SYSDATE,item.TENVUVIEC,item.SL_KHANGCAO,item.SL_KHANGNGHI
                        ,item.DONID,item.THULYID);
             COMMIT;          
      END LOOP;
END DASHBOARD_CREATE_DATA_ADS_ST;
PROCEDURE DASHBOARD_CREATE_DATA_AHN_ST
 AS    
    V_SYSDATE DATE;V_COUNTS NUMBER;
    V_KQLOAI NUMBER; V_SOTHULYXX VARCHAR2(512);V_NGAYTHULYXX DATE;
BEGIN
    DELETE DASHBOARD_STPT WHERE LOAIAN=3 AND CAPXX=2;COMMIT;  
    SELECT SYSDATE INTO V_SYSDATE FROM DUAL; 
    ------
      FOR item in (
                    SELECT TL.TOAANID
                    ,TL.SOTHULY
                    ,TL.NGAYTHULY
                    ,'2' CAPXX 
                    ,D.MAVUVIEC
                    ,CASE WHEN QDBA.SOQD IS NULL AND STBA.SOBANAN IS NULL  THEN NULL
                        WHEN QDBA.SOQD IS NOT NULL THEN 1
                        WHEN STBA.SOBANAN IS NOT NULL  THEN 0
                     END  KQLOAI
                    ,DECODE (QDBA.SOQD,NULL,STBA.SOBANAN,QDBA.SOQD) KQSO
                    ,DECODE (QDBA.NGAYQD, NULL,STBA.NGAYTUYENAN,QDBA.NGAYQD) KQNGAY
                    ,DECODE (QDBA.NGAYQD, NULL,NULL,QDBA.TEN) KQNOIDUNG
                    ,NKC.NGUOIKHANGCAO
                    ,NGAYKC.NGAYKHANGCAO
                    ,ND.TENDUONGSU NGUYENDON
                    ,BD.TENDUONGSU BIDON 
                    ,TP.THAMPHANID
                    ,NKN.NGAYKN NGAYKHANGNGHI
                    ,D.QUANHEPHAPLUAT_NAME QHPL
                    ,3 LOAIAN
                    ,null NGAYDONGBO    
                    ,D.TENVUVIEC
                    ,SLKC.SL_KHANGCAO
                    ,SLKN.SL_KHANGNGHI
                    ,TL.DONID 
                    ,TL.ID THULYID
                    FROM AHN_SOTHAM_THULY TL 
                    LEFT JOIN AHN_DON D ON D.ID=TL.DONID
                    LEFT JOIN(SELECT BA.DONID,BA.SOBANAN,BA.NGAYTUYENAN
                                            FROM AHN_SOTHAM_BANAN BA)STBA ON STBA.DONID=TL.DONID  
                    LEFT JOIN (
                             SELECT TT.DONID
                            ,DECODE(instr(TT.THAMPHANID,','),0,TT.THAMPHANID,SUBSTR(TT.THAMPHANID,0,instr(TT.THAMPHANID,',') - 1))THAMPHANID    
                             FROM ( SELECT hd.DONID                            
                                   ,LISTAGG(hd.CANBOID,',')WITHIN GROUP (ORDER BY hd.NGAYPHANCONG DESC)THAMPHANID      
                                    FROM AHN_SOTHAM_HDXX hd 
                                    WHERE hd.mavaitro='THAMPHAN' and hd.DONID!=0
                                    group by hd.DONID
                               )TT
                    )TP ON TP.DONID=TL.DONID
                     LEFT JOIN (
                             SELECT COUNT(*) SL_KHANGCAO,KC.DONID FROM AHN_SOTHAM_KHANGCAO KC  GROUP BY KC.DONID
                     )SLKC ON SLKC.DONID=TL.DONID
                     LEFT JOIN (
                             SELECT COUNT(*) SL_KHANGNGHI,KN.DONID FROM AHN_SOTHAM_KHANGNGHI KN  GROUP BY KN.DONID
                     )SLKN ON SLKN.DONID=TL.DONID
                     LEFT JOIN (
                       SELECT TT.DONID,TT.TENDUONGSU  
                        FROM(SELECT COUNT(*), TS.DONID
                          ,LISTAGG(TS.TENDUONGSU,', ')WITHIN GROUP (ORDER BY TS.ISDAIDIEN DESC,TS.TENDUONGSU)TENDUONGSU
                             FROM (
                                       SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER,BC.ISDAIDIEN
                                        FROM (SELECT ID,DONID,TENDUONGSU,TUCACHTOTUNG_MA,ISDAIDIEN,ROW_NUMBER()  OVER (PARTITION BY DONID ORDER BY ISDAIDIEN DESC,TENDUONGSU) ROWNUMBER
                                        FROM AHN_DON_DUONGSU WHERE TUCACHTOTUNG_MA='BIDON'--ISDAIDIEN=1                              
                                        ) BC 
                                       -- WHERE BC.ROWNUMBER <= 3
                                ) TS GROUP BY TS.DONID    
                         )TT
                    )BD ON BD.DONID=TL.DONID  
                    LEFT JOIN (
                         SELECT TT.DONID,TT.TENDUONGSU  
                          FROM(SELECT TS.DONID
                              ,LISTAGG(TS.TENDUONGSU,', ')WITHIN GROUP (ORDER BY TS.ISDAIDIEN DESC,TS.TENDUONGSU)TENDUONGSU
                                 FROM (  SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER,BC.ISDAIDIEN
                                            FROM (SELECT ID,DONID,TENDUONGSU,TUCACHTOTUNG_MA,ISDAIDIEN,ROW_NUMBER()  OVER (PARTITION BY DONID ORDER BY ISDAIDIEN DESC,TENDUONGSU) ROWNUMBER
                                            FROM AHN_DON_DUONGSU WHERE TUCACHTOTUNG_MA='NGUYENDON'--ISDAIDIEN=1                              
                                            ) BC 
                                          --  WHERE BC.ROWNUMBER <= 3
                                    ) TS GROUP BY TS.DONID    
                           )TT
                      )ND ON ND.DONID=TL.DONID                  
                    LEFT JOIN(SELECT TT.DONID
                                ,DECODE(instr(TT.SOQD,','),0,TT.SOQD,SUBSTR(TT.SOQD,0,instr(TT.SOQD,',') - 1))SOQD 
                                ,DECODE(instr(TT.NGAYQD,','),0,TT.NGAYQD,SUBSTR(TT.NGAYQD,0,instr(TT.NGAYQD,',') - 1))NGAYQD 
                                ,DECODE(instr(TT.ten,','),0,TT.ten,SUBSTR(TT.ten,0,instr(TT.ten,',') - 1))TEN 
                                FROM ( 
                                     SELECT QD.DONID
                                    ,LISTAGG(QD.SOQD,',')WITHIN GROUP (ORDER BY QD.NGAYQD DESC)SOQD
                                    ,LISTAGG(QD.NGAYQD,',')WITHIN GROUP (ORDER BY QD.NGAYQD DESC)NGAYQD
                                    ,LISTAGG(dqd.TEN,',')WITHIN GROUP (ORDER BY QD.NGAYQD DESC)TEN
                                                FROM AHN_SOTHAM_QUYETDINH QD
                                                LEFT JOIN DM_QD_QUYETDINH DQD ON DQD.ID=QD.QUYETDINHID 
                                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=DQD.LOAIID
                                                WHERE dqd.ket_thuc = 1
                                      group by QD.DONID
                                      )TT
                                )QDBA ON QDBA.DONID=TL.DONID  
                    LEFT JOIN (
                          SELECT TT.DONID,TT.NGUOIKHANGCAO  
                          FROM(SELECT TS.DONID                               
                              ,LISTAGG(TS.TENDUONGSU,', ')WITHIN GROUP (ORDER BY TS.ISDAIDIEN DESC,TS.TENDUONGSU)NGUOIKHANGCAO
                               FROM (SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER,BC.ISDAIDIEN 
                                                  FROM (SELECT DS.ID,DS.DONID,DS.TENDUONGSU,DS.TUCACHTOTUNG_MA,DS.ISDAIDIEN ,ROW_NUMBER() OVER (PARTITION BY DS.DONID ORDER BY DS.ISDAIDIEN DESC,DS.TENDUONGSU) ROWNUMBER
                                                        FROM AHN_DON_DUONGSU DS
                                                        WHERE EXISTS(SELECT 1 FROM AHN_SOTHAM_KHANGCAO KC WHERE KC.DUONGSUID=DS.ID AND KC.LOAIKHANGCAO !=2 AND KC.DONID=DS.DONID)
                                                        )BC                                       
                                                  WHERE BC.ROWNUMBER <=3
                                    ) TS GROUP BY TS.DONID    
                             )TT
                    )NKC ON NKC.DONID=TL.DONID 
                    LEFT JOIN (  SELECT TT.DONID
                                ,DECODE(instr(TT.NGAYKHANGCAO,','),0,TT.NGAYKHANGCAO,SUBSTR(TT.NGAYKHANGCAO,0,instr(TT.NGAYKHANGCAO,',') - 1))NGAYKHANGCAO    
                                FROM ( 
                                     SELECT KC.DONID
                                            ,LISTAGG(KC.NGAYKHANGCAO,',')WITHIN GROUP (ORDER BY KC.NGAYKHANGCAO DESC)NGAYKHANGCAO      
                                                FROM AHN_SOTHAM_KHANGCAO KC 
                                                WHERE KC.LOAIKHANGCAO !=2 
                                      group by KC.DONID
                                      )TT
                      )NGAYKC ON NGAYKC.DONID=TL.DONID 
                   LEFT JOIN (
                           SELECT TT.DONID
                            ,DECODE(instr(TT.NGAYKN,','),0,TT.NGAYKN,SUBSTR(TT.NGAYKN,0,instr(TT.NGAYKN,',') - 1))NGAYKN    
                            FROM ( 
                            SELECT KN.DONID
                            ,LISTAGG(KN.NGAYKN,',')WITHIN GROUP (ORDER BY KN.NGAYKN DESC)NGAYKN      
                            FROM AHN_SOTHAM_KHANGNGHI KN 
                            WHERE KN.TINHTRANG_GIAIQUYET != 3 
                            group by KN.DONID
                            )TT
                      )NKN ON NKN.DONID=TL.DONID
                    WHERE TL.NGAYTHULY IS NOT NULL AND TL.truonghopthuly IN (1)
                    AND d.MAVUVIEC IS NOT NULL  AND TL.SOTHULY IS NOT NULL  AND TL.NGAYTHULY IS NOT NULL
      )
      LOOP
          insert into DASHBOARD_STPT
                        (TOAANID,SOTHULY,NGAYTHULY,CAPXX,MAVUVIEC,KQLOAI,KQSO,KQNGAY,KQNOIDUNG,NGUOIKHANGCAO,NGAYKHANGCAO,NGUYENDON,BIDON,THAMPHANID,NGAYKHANGNGHI,QHPL,LOAIAN
                        ,NGAYDONGBO,TENVUVIEC,SL_KHANGCAO,SL_KHANGNGHI
                        ,DONID,THULYID)
                        values 
                        (item.TOAANID,item.SOTHULY,item.NGAYTHULY,item.CAPXX,item.MAVUVIEC,item.KQLOAI,item.KQSO,item.KQNGAY,item.KQNOIDUNG,item.NGUOIKHANGCAO,item.NGAYKHANGCAO,item.NGUYENDON,item.BIDON,item.THAMPHANID,item.NGAYKHANGNGHI,item.QHPL,item.LOAIAN
                        ,V_SYSDATE,item.TENVUVIEC,item.SL_KHANGCAO,item.SL_KHANGNGHI
                        ,item.DONID,item.THULYID);
             COMMIT;          
      END LOOP;
END DASHBOARD_CREATE_DATA_AHN_ST;
PROCEDURE DASHBOARD_CREATE_DATA_AKT_ST
 AS    
    V_SYSDATE DATE;V_COUNTS NUMBER;
    V_KQLOAI NUMBER; V_SOTHULYXX VARCHAR2(512);V_NGAYTHULYXX DATE;
BEGIN
    DELETE DASHBOARD_STPT WHERE LOAIAN=4 AND CAPXX=2;COMMIT;  
    SELECT SYSDATE INTO V_SYSDATE FROM DUAL; 
    ------
      FOR item in (
                    SELECT TL.TOAANID
                    ,TL.SOTHULY
                    ,TL.NGAYTHULY
                    ,'2' CAPXX 
                    ,D.MAVUVIEC
                    ,CASE WHEN QDBA.SOQD IS NULL AND STBA.SOBANAN IS NULL  THEN NULL
                        WHEN QDBA.SOQD IS NOT NULL THEN 1
                        WHEN STBA.SOBANAN IS NOT NULL  THEN 0
                     END  KQLOAI
                    ,DECODE (QDBA.SOQD,NULL,STBA.SOBANAN,QDBA.SOQD) KQSO
                    ,DECODE (QDBA.NGAYQD, NULL,STBA.NGAYTUYENAN,QDBA.NGAYQD) KQNGAY
                    ,DECODE (QDBA.NGAYQD, NULL,NULL,QDBA.TEN) KQNOIDUNG
                    ,NKC.NGUOIKHANGCAO
                    ,NGAYKC.NGAYKHANGCAO
                    ,ND.TENDUONGSU NGUYENDON
                    ,BD.TENDUONGSU BIDON 
                    ,TP.THAMPHANID
                    ,NKN.NGAYKN NGAYKHANGNGHI
                    ,D.QUANHEPHAPLUAT_NAME QHPL
                    ,4 LOAIAN
                    ,null NGAYDONGBO    
                    ,D.TENVUVIEC
                    ,SLKC.SL_KHANGCAO
                    ,SLKN.SL_KHANGNGHI
                    ,TL.DONID 
                    ,TL.ID THULYID
                    FROM AKT_SOTHAM_THULY TL 
                    LEFT JOIN AKT_DON D ON D.ID=TL.DONID
                    LEFT JOIN(SELECT BA.DONID,BA.SOBANAN,BA.NGAYTUYENAN
                                            FROM AKT_SOTHAM_BANAN BA)STBA ON STBA.DONID=TL.DONID  
                    LEFT JOIN (
                             SELECT TT.DONID
                            ,DECODE(instr(TT.THAMPHANID,','),0,TT.THAMPHANID,SUBSTR(TT.THAMPHANID,0,instr(TT.THAMPHANID,',') - 1))THAMPHANID    
                             FROM ( SELECT hd.DONID                            
                                   ,LISTAGG(hd.CANBOID,',')WITHIN GROUP (ORDER BY hd.NGAYPHANCONG DESC)THAMPHANID      
                                    FROM AKT_SOTHAM_HDXX hd 
                                    WHERE hd.mavaitro='THAMPHAN' and hd.DONID!=0
                                    group by hd.DONID
                               )TT
                    )TP ON TP.DONID=TL.DONID
                     LEFT JOIN (
                             SELECT COUNT(*) SL_KHANGCAO,KC.DONID FROM AKT_SOTHAM_KHANGCAO KC  GROUP BY KC.DONID
                     )SLKC ON SLKC.DONID=TL.DONID
                     LEFT JOIN (
                             SELECT COUNT(*) SL_KHANGNGHI,KN.DONID FROM AKT_SOTHAM_KHANGNGHI KN  GROUP BY KN.DONID
                     )SLKN ON SLKN.DONID=TL.DONID
                     LEFT JOIN (
                       SELECT TT.DONID,TT.TENDUONGSU  
                        FROM(SELECT COUNT(*), TS.DONID
                          ,LISTAGG(TS.TENDUONGSU,', ')WITHIN GROUP (ORDER BY TS.ISDAIDIEN DESC,TS.TENDUONGSU)TENDUONGSU
                             FROM (
                                       SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER,BC.ISDAIDIEN
                                        FROM (SELECT ID,DONID,TENDUONGSU,TUCACHTOTUNG_MA,ISDAIDIEN,ROW_NUMBER()  OVER (PARTITION BY DONID ORDER BY ISDAIDIEN DESC,TENDUONGSU) ROWNUMBER
                                        FROM AKT_DON_DUONGSU WHERE TUCACHTOTUNG_MA='BIDON'--ISDAIDIEN=1                              
                                        ) BC 
                                       -- WHERE BC.ROWNUMBER <= 3
                                ) TS GROUP BY TS.DONID    
                         )TT
                    )BD ON BD.DONID=TL.DONID  
                    LEFT JOIN (
                         SELECT TT.DONID,TT.TENDUONGSU  
                          FROM(SELECT TS.DONID
                              ,LISTAGG(TS.TENDUONGSU,', ')WITHIN GROUP (ORDER BY TS.ISDAIDIEN DESC,TS.TENDUONGSU)TENDUONGSU
                                 FROM (  SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER,BC.ISDAIDIEN
                                            FROM (SELECT ID,DONID,TENDUONGSU,TUCACHTOTUNG_MA,ISDAIDIEN,ROW_NUMBER()  OVER (PARTITION BY DONID ORDER BY ISDAIDIEN DESC,TENDUONGSU) ROWNUMBER
                                            FROM AKT_DON_DUONGSU WHERE TUCACHTOTUNG_MA='NGUYENDON'--ISDAIDIEN=1                              
                                            ) BC 
                                          --  WHERE BC.ROWNUMBER <= 3
                                    ) TS GROUP BY TS.DONID    
                           )TT
                      )ND ON ND.DONID=TL.DONID                  
                    LEFT JOIN(SELECT TT.DONID
                                ,DECODE(instr(TT.SOQD,','),0,TT.SOQD,SUBSTR(TT.SOQD,0,instr(TT.SOQD,',') - 1))SOQD 
                                ,DECODE(instr(TT.NGAYQD,','),0,TT.NGAYQD,SUBSTR(TT.NGAYQD,0,instr(TT.NGAYQD,',') - 1))NGAYQD 
                                ,DECODE(instr(TT.ten,','),0,TT.ten,SUBSTR(TT.ten,0,instr(TT.ten,',') - 1))TEN 
                                FROM ( 
                                     SELECT QD.DONID
                                    ,LISTAGG(QD.SOQD,',')WITHIN GROUP (ORDER BY QD.NGAYQD DESC)SOQD
                                    ,LISTAGG(QD.NGAYQD,',')WITHIN GROUP (ORDER BY QD.NGAYQD DESC)NGAYQD
                                    ,LISTAGG(dqd.TEN,',')WITHIN GROUP (ORDER BY QD.NGAYQD DESC)TEN
                                                FROM AKT_SOTHAM_QUYETDINH QD
                                                LEFT JOIN DM_QD_QUYETDINH DQD ON DQD.ID=QD.QUYETDINHID 
                                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=DQD.LOAIID
                                                WHERE dqd.ket_thuc = 1
                                      group by QD.DONID
                                      )TT
                                )QDBA ON QDBA.DONID=TL.DONID  
                    LEFT JOIN (
                          SELECT TT.DONID,TT.NGUOIKHANGCAO  
                          FROM(SELECT TS.DONID                               
                              ,LISTAGG(TS.TENDUONGSU,', ')WITHIN GROUP (ORDER BY TS.ISDAIDIEN DESC,TS.TENDUONGSU)NGUOIKHANGCAO
                               FROM (SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER,BC.ISDAIDIEN 
                                                  FROM (SELECT DS.ID,DS.DONID,DS.TENDUONGSU,DS.TUCACHTOTUNG_MA,DS.ISDAIDIEN ,ROW_NUMBER() OVER (PARTITION BY DS.DONID ORDER BY DS.ISDAIDIEN DESC,DS.TENDUONGSU) ROWNUMBER
                                                        FROM AKT_DON_DUONGSU DS
                                                        WHERE EXISTS(SELECT 1 FROM AKT_SOTHAM_KHANGCAO KC WHERE KC.DUONGSUID=DS.ID AND KC.LOAIKHANGCAO !=2 AND KC.DONID=DS.DONID)
                                                        )BC                                       
                                                  WHERE BC.ROWNUMBER <=3
                                    ) TS GROUP BY TS.DONID    
                             )TT
                    )NKC ON NKC.DONID=TL.DONID 
                    LEFT JOIN (  SELECT TT.DONID
                                ,DECODE(instr(TT.NGAYKHANGCAO,','),0,TT.NGAYKHANGCAO,SUBSTR(TT.NGAYKHANGCAO,0,instr(TT.NGAYKHANGCAO,',') - 1))NGAYKHANGCAO    
                                FROM ( 
                                     SELECT KC.DONID
                                            ,LISTAGG(KC.NGAYKHANGCAO,',')WITHIN GROUP (ORDER BY KC.NGAYKHANGCAO DESC)NGAYKHANGCAO      
                                                FROM AKT_SOTHAM_KHANGCAO KC 
                                                WHERE KC.LOAIKHANGCAO !=2 
                                      group by KC.DONID
                                      )TT
                      )NGAYKC ON NGAYKC.DONID=TL.DONID 
                   LEFT JOIN (
                           SELECT TT.DONID
                            ,DECODE(instr(TT.NGAYKN,','),0,TT.NGAYKN,SUBSTR(TT.NGAYKN,0,instr(TT.NGAYKN,',') - 1))NGAYKN    
                            FROM ( 
                            SELECT KN.DONID
                            ,LISTAGG(KN.NGAYKN,',')WITHIN GROUP (ORDER BY KN.NGAYKN DESC)NGAYKN      
                            FROM AKT_SOTHAM_KHANGNGHI KN 
                            WHERE KN.TINHTRANG_GIAIQUYET != 3 
                            group by KN.DONID
                            )TT
                      )NKN ON NKN.DONID=TL.DONID
                    WHERE TL.NGAYTHULY IS NOT NULL AND TL.truonghopthuly IN (1)
                    AND d.MAVUVIEC IS NOT NULL  AND TL.SOTHULY IS NOT NULL  AND TL.NGAYTHULY IS NOT NULL
      )
      LOOP
          insert into DASHBOARD_STPT
                        (TOAANID,SOTHULY,NGAYTHULY,CAPXX,MAVUVIEC,KQLOAI,KQSO,KQNGAY,KQNOIDUNG,NGUOIKHANGCAO,NGAYKHANGCAO,NGUYENDON,BIDON,THAMPHANID,NGAYKHANGNGHI,QHPL,LOAIAN
                        ,NGAYDONGBO,TENVUVIEC,SL_KHANGCAO,SL_KHANGNGHI
                        ,DONID,THULYID)
                        values 
                        (item.TOAANID,item.SOTHULY,item.NGAYTHULY,item.CAPXX,item.MAVUVIEC,item.KQLOAI,item.KQSO,item.KQNGAY,item.KQNOIDUNG,item.NGUOIKHANGCAO,item.NGAYKHANGCAO,item.NGUYENDON,item.BIDON,item.THAMPHANID,item.NGAYKHANGNGHI,item.QHPL,item.LOAIAN
                        ,V_SYSDATE,item.TENVUVIEC,item.SL_KHANGCAO,item.SL_KHANGNGHI
                        ,item.DONID,item.THULYID);
             COMMIT;          
      END LOOP;
END DASHBOARD_CREATE_DATA_AKT_ST;
PROCEDURE DASHBOARD_CREATE_DATA_ALD_ST
 AS    
    V_SYSDATE DATE;V_COUNTS NUMBER;
    V_KQLOAI NUMBER; V_SOTHULYXX VARCHAR2(512);V_NGAYTHULYXX DATE;
BEGIN
    DELETE DASHBOARD_STPT WHERE LOAIAN=5 AND CAPXX=2;COMMIT;  
    SELECT SYSDATE INTO V_SYSDATE FROM DUAL; 
    ------
      FOR item in (
                    SELECT TL.TOAANID
                    ,TL.SOTHULY
                    ,TL.NGAYTHULY
                    ,'2' CAPXX 
                    ,D.MAVUVIEC
                    ,CASE WHEN QDBA.SOQD IS NULL AND STBA.SOBANAN IS NULL  THEN NULL
                        WHEN QDBA.SOQD IS NOT NULL THEN 1
                        WHEN STBA.SOBANAN IS NOT NULL  THEN 0
                     END  KQLOAI
                    ,DECODE (QDBA.SOQD,NULL,STBA.SOBANAN,QDBA.SOQD) KQSO
                    ,DECODE (QDBA.NGAYQD, NULL,STBA.NGAYTUYENAN,QDBA.NGAYQD) KQNGAY
                    ,DECODE (QDBA.NGAYQD, NULL,NULL,QDBA.TEN) KQNOIDUNG
                    ,NKC.NGUOIKHANGCAO
                    ,NGAYKC.NGAYKHANGCAO
                    ,ND.TENDUONGSU NGUYENDON
                    ,BD.TENDUONGSU BIDON 
                    ,TP.THAMPHANID
                    ,NKN.NGAYKN NGAYKHANGNGHI
                    ,D.QUANHEPHAPLUAT_NAME QHPL
                    ,5 LOAIAN
                    ,null NGAYDONGBO    
                    ,D.TENVUVIEC
                    ,SLKC.SL_KHANGCAO
                    ,SLKN.SL_KHANGNGHI
                    ,TL.DONID 
                    ,TL.ID THULYID
                    FROM ALD_SOTHAM_THULY TL 
                    LEFT JOIN ALD_DON D ON D.ID=TL.DONID
                    LEFT JOIN(SELECT BA.DONID,BA.SOBANAN,BA.NGAYTUYENAN
                                            FROM ALD_SOTHAM_BANAN BA)STBA ON STBA.DONID=TL.DONID  
                    LEFT JOIN (
                             SELECT TT.DONID
                            ,DECODE(instr(TT.THAMPHANID,','),0,TT.THAMPHANID,SUBSTR(TT.THAMPHANID,0,instr(TT.THAMPHANID,',') - 1))THAMPHANID    
                             FROM ( SELECT hd.DONID                            
                                   ,LISTAGG(hd.CANBOID,',')WITHIN GROUP (ORDER BY hd.NGAYPHANCONG DESC)THAMPHANID      
                                    FROM ALD_SOTHAM_HDXX hd 
                                    WHERE hd.mavaitro='THAMPHAN' and hd.DONID!=0
                                    group by hd.DONID
                               )TT
                    )TP ON TP.DONID=TL.DONID
                     LEFT JOIN (
                             SELECT COUNT(*) SL_KHANGCAO,KC.DONID FROM ALD_SOTHAM_KHANGCAO KC  GROUP BY KC.DONID
                     )SLKC ON SLKC.DONID=TL.DONID
                     LEFT JOIN (
                             SELECT COUNT(*) SL_KHANGNGHI,KN.DONID FROM ALD_SOTHAM_KHANGNGHI KN  GROUP BY KN.DONID
                     )SLKN ON SLKN.DONID=TL.DONID
                     LEFT JOIN (
                       SELECT TT.DONID,TT.TENDUONGSU  
                        FROM(SELECT COUNT(*), TS.DONID
                          ,LISTAGG(TS.TENDUONGSU,', ')WITHIN GROUP (ORDER BY TS.ISDAIDIEN DESC,TS.TENDUONGSU)TENDUONGSU
                             FROM (
                                       SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER,BC.ISDAIDIEN
                                        FROM (SELECT ID,DONID,TENDUONGSU,TUCACHTOTUNG_MA,ISDAIDIEN,ROW_NUMBER()  OVER (PARTITION BY DONID ORDER BY ISDAIDIEN DESC,TENDUONGSU) ROWNUMBER
                                        FROM ALD_DON_DUONGSU WHERE TUCACHTOTUNG_MA='BIDON'--ISDAIDIEN=1                              
                                        ) BC 
                                       -- WHERE BC.ROWNUMBER <= 3
                                ) TS GROUP BY TS.DONID    
                         )TT
                    )BD ON BD.DONID=TL.DONID  
                    LEFT JOIN (
                         SELECT TT.DONID,TT.TENDUONGSU  
                          FROM(SELECT TS.DONID
                              ,LISTAGG(TS.TENDUONGSU,', ')WITHIN GROUP (ORDER BY TS.ISDAIDIEN DESC,TS.TENDUONGSU)TENDUONGSU
                                 FROM (  SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER,BC.ISDAIDIEN
                                            FROM (SELECT ID,DONID,TENDUONGSU,TUCACHTOTUNG_MA,ISDAIDIEN,ROW_NUMBER()  OVER (PARTITION BY DONID ORDER BY ISDAIDIEN DESC,TENDUONGSU) ROWNUMBER
                                            FROM ALD_DON_DUONGSU WHERE TUCACHTOTUNG_MA='NGUYENDON'--ISDAIDIEN=1                              
                                            ) BC 
                                          --  WHERE BC.ROWNUMBER <= 3
                                    ) TS GROUP BY TS.DONID    
                           )TT
                      )ND ON ND.DONID=TL.DONID                  
                    LEFT JOIN(SELECT TT.DONID
                                ,DECODE(instr(TT.SOQD,','),0,TT.SOQD,SUBSTR(TT.SOQD,0,instr(TT.SOQD,',') - 1))SOQD 
                                ,DECODE(instr(TT.NGAYQD,','),0,TT.NGAYQD,SUBSTR(TT.NGAYQD,0,instr(TT.NGAYQD,',') - 1))NGAYQD 
                                ,DECODE(instr(TT.ten,','),0,TT.ten,SUBSTR(TT.ten,0,instr(TT.ten,',') - 1))TEN 
                                FROM ( 
                                     SELECT QD.DONID
                                    ,LISTAGG(QD.SOQD,',')WITHIN GROUP (ORDER BY QD.NGAYQD DESC)SOQD
                                    ,LISTAGG(QD.NGAYQD,',')WITHIN GROUP (ORDER BY QD.NGAYQD DESC)NGAYQD
                                    ,LISTAGG(dqd.TEN,',')WITHIN GROUP (ORDER BY QD.NGAYQD DESC)TEN
                                                FROM ALD_SOTHAM_QUYETDINH QD
                                                LEFT JOIN DM_QD_QUYETDINH DQD ON DQD.ID=QD.QUYETDINHID 
                                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=DQD.LOAIID
                                                WHERE dqd.ket_thuc = 1
                                      group by QD.DONID
                                      )TT
                                )QDBA ON QDBA.DONID=TL.DONID  
                    LEFT JOIN (
                          SELECT TT.DONID,TT.NGUOIKHANGCAO  
                          FROM(SELECT TS.DONID                               
                              ,LISTAGG(TS.TENDUONGSU,', ')WITHIN GROUP (ORDER BY TS.ISDAIDIEN DESC,TS.TENDUONGSU)NGUOIKHANGCAO
                               FROM (SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER,BC.ISDAIDIEN 
                                                  FROM (SELECT DS.ID,DS.DONID,DS.TENDUONGSU,DS.TUCACHTOTUNG_MA,DS.ISDAIDIEN ,ROW_NUMBER() OVER (PARTITION BY DS.DONID ORDER BY DS.ISDAIDIEN DESC,DS.TENDUONGSU) ROWNUMBER
                                                        FROM ALD_DON_DUONGSU DS
                                                        WHERE EXISTS(SELECT 1 FROM ALD_SOTHAM_KHANGCAO KC WHERE KC.DUONGSUID=DS.ID AND KC.LOAIKHANGCAO !=2 AND KC.DONID=DS.DONID)
                                                        )BC                                       
                                                  WHERE BC.ROWNUMBER <=3
                                    ) TS GROUP BY TS.DONID    
                             )TT
                    )NKC ON NKC.DONID=TL.DONID 
                    LEFT JOIN (  SELECT TT.DONID
                                ,DECODE(instr(TT.NGAYKHANGCAO,','),0,TT.NGAYKHANGCAO,SUBSTR(TT.NGAYKHANGCAO,0,instr(TT.NGAYKHANGCAO,',') - 1))NGAYKHANGCAO    
                                FROM ( 
                                     SELECT KC.DONID
                                            ,LISTAGG(KC.NGAYKHANGCAO,',')WITHIN GROUP (ORDER BY KC.NGAYKHANGCAO DESC)NGAYKHANGCAO      
                                                FROM ALD_SOTHAM_KHANGCAO KC 
                                                WHERE KC.LOAIKHANGCAO !=2 
                                      group by KC.DONID
                                      )TT
                      )NGAYKC ON NGAYKC.DONID=TL.DONID 
                   LEFT JOIN (
                           SELECT TT.DONID
                            ,DECODE(instr(TT.NGAYKN,','),0,TT.NGAYKN,SUBSTR(TT.NGAYKN,0,instr(TT.NGAYKN,',') - 1))NGAYKN    
                            FROM ( 
                            SELECT KN.DONID
                            ,LISTAGG(KN.NGAYKN,',')WITHIN GROUP (ORDER BY KN.NGAYKN DESC)NGAYKN      
                            FROM ALD_SOTHAM_KHANGNGHI KN 
                            WHERE KN.TINHTRANG_GIAIQUYET != 3 
                            group by KN.DONID
                            )TT
                      )NKN ON NKN.DONID=TL.DONID
                    WHERE TL.NGAYTHULY IS NOT NULL AND TL.truonghopthuly IN (1)
                    AND d.MAVUVIEC IS NOT NULL  AND TL.SOTHULY IS NOT NULL  AND TL.NGAYTHULY IS NOT NULL
      )
      LOOP
          insert into DASHBOARD_STPT
                        (TOAANID,SOTHULY,NGAYTHULY,CAPXX,MAVUVIEC,KQLOAI,KQSO,KQNGAY,KQNOIDUNG,NGUOIKHANGCAO,NGAYKHANGCAO,NGUYENDON,BIDON,THAMPHANID,NGAYKHANGNGHI,QHPL,LOAIAN
                        ,NGAYDONGBO,TENVUVIEC,SL_KHANGCAO,SL_KHANGNGHI
                        ,DONID,THULYID)
                        values 
                        (item.TOAANID,item.SOTHULY,item.NGAYTHULY,item.CAPXX,item.MAVUVIEC,item.KQLOAI,item.KQSO,item.KQNGAY,item.KQNOIDUNG,item.NGUOIKHANGCAO,item.NGAYKHANGCAO,item.NGUYENDON,item.BIDON,item.THAMPHANID,item.NGAYKHANGNGHI,item.QHPL,item.LOAIAN
                        ,V_SYSDATE,item.TENVUVIEC,item.SL_KHANGCAO,item.SL_KHANGNGHI
                        ,item.DONID,item.THULYID);
             COMMIT;          
      END LOOP;
END DASHBOARD_CREATE_DATA_ALD_ST;
PROCEDURE DASHBOARD_CREATE_DATA_AHC_ST
 AS    
    V_SYSDATE DATE;V_COUNTS NUMBER;
    V_KQLOAI NUMBER; V_SOTHULYXX VARCHAR2(512);V_NGAYTHULYXX DATE;
BEGIN
    DELETE DASHBOARD_STPT WHERE LOAIAN=6 AND CAPXX=2;COMMIT;  
    SELECT SYSDATE INTO V_SYSDATE FROM DUAL; 
    ------
      FOR item in (
                    SELECT D.TOAANID
                    ,TL.SOTHULY
                    ,TL.NGAYTHULY
                    ,'2' CAPXX 
                    ,D.MAVUVIEC
                    ,CASE WHEN QDBA.SOQD IS NULL AND STBA.SOBANAN IS NULL  THEN NULL
                        WHEN QDBA.SOQD IS NOT NULL THEN 1
                        WHEN STBA.SOBANAN IS NOT NULL  THEN 0
                     END  KQLOAI
                    ,DECODE (QDBA.SOQD,NULL,STBA.SOBANAN,QDBA.SOQD) KQSO
                    ,DECODE (QDBA.NGAYQD, NULL,STBA.NGAYTUYENAN,QDBA.NGAYQD) KQNGAY
                    ,DECODE (QDBA.NGAYQD, NULL,NULL,QDBA.TEN) KQNOIDUNG
                    ,NKC.NGUOIKHANGCAO
                    ,NGAYKC.NGAYKHANGCAO
                    ,ND.TENDUONGSU NGUYENDON
                    ,BD.TENDUONGSU BIDON 
                    ,TP.THAMPHANID
                    ,NKN.NGAYKN NGAYKHANGNGHI
                    ,D.QUANHEPHAPLUAT_NAME QHPL
                    ,6 LOAIAN
                    ,null NGAYDONGBO    
                    ,D.TENVUVIEC
                    ,SLKC.SL_KHANGCAO
                    ,SLKN.SL_KHANGNGHI
                    ,TL.DONID 
                    ,TL.ID THULYID
                    FROM AHC_SOTHAM_THULY TL 
                    LEFT JOIN AHC_DON D ON D.ID=TL.DONID
                    LEFT JOIN(SELECT BA.DONID,BA.SOBANAN,BA.NGAYTUYENAN
                                            FROM AHC_SOTHAM_BANAN BA)STBA ON STBA.DONID=TL.DONID  
                    LEFT JOIN (
                             SELECT TT.DONID
                            ,DECODE(instr(TT.THAMPHANID,','),0,TT.THAMPHANID,SUBSTR(TT.THAMPHANID,0,instr(TT.THAMPHANID,',') - 1))THAMPHANID    
                             FROM ( SELECT hd.DONID                            
                                   ,LISTAGG(hd.CANBOID,',')WITHIN GROUP (ORDER BY hd.NGAYPHANCONG DESC)THAMPHANID      
                                    FROM AHC_SOTHAM_HDXX hd 
                                    WHERE hd.mavaitro='THAMPHAN' and hd.DONID!=0
                                    group by hd.DONID
                               )TT
                    )TP ON TP.DONID=TL.DONID
                     LEFT JOIN (
                             SELECT COUNT(*) SL_KHANGCAO,KC.DONID FROM AHC_SOTHAM_KHANGCAO KC  GROUP BY KC.DONID
                     )SLKC ON SLKC.DONID=TL.DONID
                     LEFT JOIN (
                             SELECT COUNT(*) SL_KHANGNGHI,KN.DONID FROM AHC_SOTHAM_KHANGNGHI KN  GROUP BY KN.DONID
                     )SLKN ON SLKN.DONID=TL.DONID
                     LEFT JOIN (
                       SELECT TT.DONID,TT.TENDUONGSU  
                        FROM(SELECT COUNT(*), TS.DONID
                          ,LISTAGG(TS.TENDUONGSU,', ')WITHIN GROUP (ORDER BY TS.ISDAIDIEN DESC,TS.TENDUONGSU)TENDUONGSU
                             FROM (
                                       SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER,BC.ISDAIDIEN
                                        FROM (SELECT ID,DONID,TENDUONGSU,TUCACHTOTUNG_MA,ISDAIDIEN,ROW_NUMBER()  OVER (PARTITION BY DONID ORDER BY ISDAIDIEN DESC,TENDUONGSU) ROWNUMBER
                                        FROM AHC_DON_DUONGSU WHERE TUCACHTOTUNG_MA='BIDON'--ISDAIDIEN=1                              
                                        ) BC 
                                       -- WHERE BC.ROWNUMBER <= 3
                                ) TS GROUP BY TS.DONID    
                         )TT
                    )BD ON BD.DONID=TL.DONID  
                    LEFT JOIN (
                         SELECT TT.DONID,TT.TENDUONGSU  
                          FROM(SELECT TS.DONID
                              ,LISTAGG(TS.TENDUONGSU,', ')WITHIN GROUP (ORDER BY TS.ISDAIDIEN DESC,TS.TENDUONGSU)TENDUONGSU
                                 FROM (  SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER,BC.ISDAIDIEN
                                            FROM (SELECT ID,DONID,TENDUONGSU,TUCACHTOTUNG_MA,ISDAIDIEN,ROW_NUMBER()  OVER (PARTITION BY DONID ORDER BY ISDAIDIEN DESC,TENDUONGSU) ROWNUMBER
                                            FROM AHC_DON_DUONGSU WHERE TUCACHTOTUNG_MA='NGUYENDON'--ISDAIDIEN=1                              
                                            ) BC 
                                          --  WHERE BC.ROWNUMBER <= 3
                                    ) TS GROUP BY TS.DONID    
                           )TT
                      )ND ON ND.DONID=TL.DONID                  
                    LEFT JOIN(SELECT TT.DONID
                                ,DECODE(instr(TT.SOQD,','),0,TT.SOQD,SUBSTR(TT.SOQD,0,instr(TT.SOQD,',') - 1))SOQD 
                                ,DECODE(instr(TT.NGAYQD,','),0,TT.NGAYQD,SUBSTR(TT.NGAYQD,0,instr(TT.NGAYQD,',') - 1))NGAYQD 
                                ,DECODE(instr(TT.ten,','),0,TT.ten,SUBSTR(TT.ten,0,instr(TT.ten,',') - 1))TEN 
                                FROM ( 
                                     SELECT QD.DONID
                                    ,LISTAGG(QD.SOQD,',')WITHIN GROUP (ORDER BY QD.NGAYQD DESC)SOQD
                                    ,LISTAGG(QD.NGAYQD,',')WITHIN GROUP (ORDER BY QD.NGAYQD DESC)NGAYQD
                                    ,LISTAGG(dqd.TEN,',')WITHIN GROUP (ORDER BY QD.NGAYQD DESC)TEN
                                                FROM AHC_SOTHAM_QUYETDINH QD
                                                LEFT JOIN DM_QD_QUYETDINH DQD ON DQD.ID=QD.QUYETDINHID 
                                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=DQD.LOAIID
                                                WHERE dqd.ket_thuc = 1
                                      group by QD.DONID
                                      )TT
                                )QDBA ON QDBA.DONID=TL.DONID  
                    LEFT JOIN (
                          SELECT TT.DONID,TT.NGUOIKHANGCAO  
                          FROM(SELECT TS.DONID                               
                              ,LISTAGG(TS.TENDUONGSU,', ')WITHIN GROUP (ORDER BY TS.ISDAIDIEN DESC,TS.TENDUONGSU)NGUOIKHANGCAO
                               FROM (SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER,BC.ISDAIDIEN 
                                                  FROM (SELECT DS.ID,DS.DONID,DS.TENDUONGSU,DS.TUCACHTOTUNG_MA,DS.ISDAIDIEN ,ROW_NUMBER() OVER (PARTITION BY DS.DONID ORDER BY DS.ISDAIDIEN DESC,DS.TENDUONGSU) ROWNUMBER
                                                        FROM AHC_DON_DUONGSU DS
                                                        WHERE EXISTS(SELECT 1 FROM AHC_SOTHAM_KHANGCAO KC WHERE KC.DUONGSUID=DS.ID AND KC.LOAIKHANGCAO !=2 AND KC.DONID=DS.DONID)
                                                        )BC                                       
                                                  WHERE BC.ROWNUMBER <=3
                                    ) TS GROUP BY TS.DONID    
                             )TT
                    )NKC ON NKC.DONID=TL.DONID 
                    LEFT JOIN (  SELECT TT.DONID
                                ,DECODE(instr(TT.NGAYKHANGCAO,','),0,TT.NGAYKHANGCAO,SUBSTR(TT.NGAYKHANGCAO,0,instr(TT.NGAYKHANGCAO,',') - 1))NGAYKHANGCAO    
                                FROM ( 
                                     SELECT KC.DONID
                                            ,LISTAGG(KC.NGAYKHANGCAO,',')WITHIN GROUP (ORDER BY KC.NGAYKHANGCAO DESC)NGAYKHANGCAO      
                                                FROM AHC_SOTHAM_KHANGCAO KC 
                                                WHERE KC.LOAIKHANGCAO !=2 
                                      group by KC.DONID
                                      )TT
                      )NGAYKC ON NGAYKC.DONID=TL.DONID 
                   LEFT JOIN (
                           SELECT TT.DONID
                            ,DECODE(instr(TT.NGAYKN,','),0,TT.NGAYKN,SUBSTR(TT.NGAYKN,0,instr(TT.NGAYKN,',') - 1))NGAYKN    
                            FROM ( 
                            SELECT KN.DONID
                            ,LISTAGG(KN.NGAYKN,',')WITHIN GROUP (ORDER BY KN.NGAYKN DESC)NGAYKN      
                            FROM AHC_SOTHAM_KHANGNGHI KN 
                            WHERE KN.TINHTRANG_GIAIQUYET != 3 
                            group by KN.DONID
                            )TT
                      )NKN ON NKN.DONID=TL.DONID
                    WHERE TL.NGAYTHULY IS NOT NULL AND TL.truonghopthuly IN (1)
                    AND d.MAVUVIEC IS NOT NULL  AND TL.SOTHULY IS NOT NULL  AND TL.NGAYTHULY IS NOT NULL
      )
      LOOP
          insert into DASHBOARD_STPT
                        (TOAANID,SOTHULY,NGAYTHULY,CAPXX,MAVUVIEC,KQLOAI,KQSO,KQNGAY,KQNOIDUNG,NGUOIKHANGCAO,NGAYKHANGCAO,NGUYENDON,BIDON,THAMPHANID,NGAYKHANGNGHI,QHPL,LOAIAN
                        ,NGAYDONGBO,TENVUVIEC,SL_KHANGCAO,SL_KHANGNGHI
                        ,DONID,THULYID)
                        values 
                        (item.TOAANID,item.SOTHULY,item.NGAYTHULY,item.CAPXX,item.MAVUVIEC,item.KQLOAI,item.KQSO,item.KQNGAY,item.KQNOIDUNG,item.NGUOIKHANGCAO,item.NGAYKHANGCAO,item.NGUYENDON,item.BIDON,item.THAMPHANID,item.NGAYKHANGNGHI,item.QHPL,item.LOAIAN
                        ,V_SYSDATE,item.TENVUVIEC,item.SL_KHANGCAO,item.SL_KHANGNGHI
                        ,item.DONID,item.THULYID);
             COMMIT;          
      END LOOP;
END DASHBOARD_CREATE_DATA_AHC_ST;
PROCEDURE DASHBOARD_CREATE_DATA_APS_ST
 AS    
    V_SYSDATE DATE;V_COUNTS NUMBER;
    V_KQLOAI NUMBER; V_SOTHULYXX VARCHAR2(512);V_NGAYTHULYXX DATE;
BEGIN
    DELETE DASHBOARD_STPT WHERE LOAIAN=7 AND CAPXX=2;COMMIT;  
    SELECT SYSDATE INTO V_SYSDATE FROM DUAL; 
    ------
      FOR item in (
                    SELECT d.TOAANID
                    ,TL.SOTHULY
                    ,TL.NGAYTHULY
                    ,'2' CAPXX 
                    ,D.MAVUVIEC
                    ,CASE WHEN QDBA.SOQD IS NULL AND STBA.SOBANAN IS NULL  THEN NULL
                        WHEN QDBA.SOQD IS NOT NULL THEN 1
                        WHEN STBA.SOBANAN IS NOT NULL  THEN 0
                     END  KQLOAI
                    ,DECODE (QDBA.SOQD,NULL,STBA.SOBANAN,QDBA.SOQD) KQSO
                    ,DECODE (QDBA.NGAYQD, NULL,STBA.NGAYTUYENAN,QDBA.NGAYQD) KQNGAY
                    ,DECODE (QDBA.NGAYQD, NULL,NULL,QDBA.TEN) KQNOIDUNG
                    ,NKC.NGUOIKHANGCAO
                    ,NGAYKC.NGAYKHANGCAO
                    ,ND.TENDUONGSU NGUYENDON
                    ,BD.TENDUONGSU BIDON 
                    ,TP.THAMPHANID
                    ,NKN.NGAYKN NGAYKHANGNGHI
                    ,D.QUANHEPHAPLUAT_NAME QHPL
                    ,7 LOAIAN
                    ,null NGAYDONGBO    
                    ,D.TENVUVIEC
                    ,SLKC.SL_KHANGCAO
                    ,SLKN.SL_KHANGNGHI
                    ,TL.DONID 
                    ,TL.ID THULYID
                    FROM APS_SOTHAM_THULY TL 
                    LEFT JOIN APS_DON D ON D.ID=TL.DONID
                    LEFT JOIN(SELECT BA.DONID,BA.SOBANAN,BA.NGAYTUYENAN
                                            FROM APS_SOTHAM_BANAN BA)STBA ON STBA.DONID=TL.DONID  
                    LEFT JOIN (
                             SELECT TT.DONID
                            ,DECODE(instr(TT.THAMPHANID,','),0,TT.THAMPHANID,SUBSTR(TT.THAMPHANID,0,instr(TT.THAMPHANID,',') - 1))THAMPHANID    
                             FROM ( SELECT hd.DONID                            
                                   ,LISTAGG(hd.CANBOID,',')WITHIN GROUP (ORDER BY hd.NGAYPHANCONG DESC)THAMPHANID      
                                    FROM APS_SOTHAM_HDXX hd 
                                    WHERE hd.mavaitro='THAMPHAN' and hd.DONID!=0
                                    group by hd.DONID
                               )TT
                    )TP ON TP.DONID=TL.DONID
                     LEFT JOIN (
                             SELECT COUNT(*) SL_KHANGCAO,KC.DONID FROM APS_SOTHAM_KHANGCAO KC  GROUP BY KC.DONID
                     )SLKC ON SLKC.DONID=TL.DONID
                     LEFT JOIN (
                             SELECT COUNT(*) SL_KHANGNGHI,KN.DONID FROM APS_SOTHAM_KHANGNGHI KN  GROUP BY KN.DONID
                     )SLKN ON SLKN.DONID=TL.DONID
                     LEFT JOIN (
                       SELECT TT.DONID,TT.TENDUONGSU  
                        FROM(SELECT COUNT(*), TS.DONID
                          ,LISTAGG(TS.TENDUONGSU,', ')WITHIN GROUP (ORDER BY TS.ISDAIDIEN DESC,TS.TENDUONGSU)TENDUONGSU
                             FROM (
                                       SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER,BC.ISDAIDIEN
                                        FROM (SELECT ID,DONID,TENDUONGSU,TUCACHTOTUNG_MA,ISDAIDIEN,ROW_NUMBER()  OVER (PARTITION BY DONID ORDER BY ISDAIDIEN DESC,TENDUONGSU) ROWNUMBER
                                        FROM APS_DON_DUONGSU WHERE TUCACHTOTUNG_MA='BIDON'--ISDAIDIEN=1                              
                                        ) BC 
                                       -- WHERE BC.ROWNUMBER <= 3
                                ) TS GROUP BY TS.DONID    
                         )TT
                    )BD ON BD.DONID=TL.DONID  
                    LEFT JOIN (
                         SELECT TT.DONID,TT.TENDUONGSU  
                          FROM(SELECT TS.DONID
                              ,LISTAGG(TS.TENDUONGSU,', ')WITHIN GROUP (ORDER BY TS.ISDAIDIEN DESC,TS.TENDUONGSU)TENDUONGSU
                                 FROM (  SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER,BC.ISDAIDIEN
                                            FROM (SELECT ID,DONID,TENDUONGSU,TUCACHTOTUNG_MA,ISDAIDIEN,ROW_NUMBER()  OVER (PARTITION BY DONID ORDER BY ISDAIDIEN DESC,TENDUONGSU) ROWNUMBER
                                            FROM APS_DON_DUONGSU WHERE TUCACHTOTUNG_MA='NGUYENDON'--ISDAIDIEN=1                              
                                            ) BC 
                                          --  WHERE BC.ROWNUMBER <= 3
                                    ) TS GROUP BY TS.DONID    
                           )TT
                      )ND ON ND.DONID=TL.DONID                  
                    LEFT JOIN(SELECT TT.DONID
                                ,DECODE(instr(TT.SOQD,','),0,TT.SOQD,SUBSTR(TT.SOQD,0,instr(TT.SOQD,',') - 1))SOQD 
                                ,DECODE(instr(TT.NGAYQD,','),0,TT.NGAYQD,SUBSTR(TT.NGAYQD,0,instr(TT.NGAYQD,',') - 1))NGAYQD 
                                ,DECODE(instr(TT.ten,','),0,TT.ten,SUBSTR(TT.ten,0,instr(TT.ten,',') - 1))TEN 
                                FROM ( 
                                     SELECT QD.DONID
                                    ,LISTAGG(QD.SOQD,',')WITHIN GROUP (ORDER BY QD.NGAYQD DESC)SOQD
                                    ,LISTAGG(QD.NGAYQD,',')WITHIN GROUP (ORDER BY QD.NGAYQD DESC)NGAYQD
                                    ,LISTAGG(dqd.TEN,',')WITHIN GROUP (ORDER BY QD.NGAYQD DESC)TEN
                                                FROM APS_SOTHAM_QUYETDINH QD
                                                LEFT JOIN DM_QD_QUYETDINH DQD ON DQD.ID=QD.QUYETDINHID 
                                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=DQD.LOAIID
                                                WHERE dqd.ket_thuc = 1
                                      group by QD.DONID
                                      )TT
                                )QDBA ON QDBA.DONID=TL.DONID  
                    LEFT JOIN (
                          SELECT TT.DONID,TT.NGUOIKHANGCAO  
                          FROM(SELECT TS.DONID                               
                              ,LISTAGG(TS.TENDUONGSU,', ')WITHIN GROUP (ORDER BY TS.ISDAIDIEN DESC,TS.TENDUONGSU)NGUOIKHANGCAO
                               FROM (SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER,BC.ISDAIDIEN 
                                                  FROM (SELECT DS.ID,DS.DONID,DS.TENDUONGSU,DS.TUCACHTOTUNG_MA,DS.ISDAIDIEN ,ROW_NUMBER() OVER (PARTITION BY DS.DONID ORDER BY DS.ISDAIDIEN DESC,DS.TENDUONGSU) ROWNUMBER
                                                        FROM APS_DON_DUONGSU DS
                                                        WHERE EXISTS(SELECT 1 FROM APS_SOTHAM_KHANGCAO KC WHERE KC.DUONGSUID=DS.ID AND KC.LOAIKHANGCAO !=2 AND KC.DONID=DS.DONID)
                                                        )BC                                       
                                                  WHERE BC.ROWNUMBER <=3
                                    ) TS GROUP BY TS.DONID    
                             )TT
                    )NKC ON NKC.DONID=TL.DONID 
                    LEFT JOIN (  SELECT TT.DONID
                                ,DECODE(instr(TT.NGAYKHANGCAO,','),0,TT.NGAYKHANGCAO,SUBSTR(TT.NGAYKHANGCAO,0,instr(TT.NGAYKHANGCAO,',') - 1))NGAYKHANGCAO    
                                FROM ( 
                                     SELECT KC.DONID
                                            ,LISTAGG(KC.NGAYKHANGCAO,',')WITHIN GROUP (ORDER BY KC.NGAYKHANGCAO DESC)NGAYKHANGCAO      
                                                FROM APS_SOTHAM_KHANGCAO KC 
                                                WHERE KC.LOAIKHANGCAO !=2 
                                      group by KC.DONID
                                      )TT
                      )NGAYKC ON NGAYKC.DONID=TL.DONID 
                   LEFT JOIN (
                           SELECT TT.DONID
                            ,DECODE(instr(TT.NGAYKN,','),0,TT.NGAYKN,SUBSTR(TT.NGAYKN,0,instr(TT.NGAYKN,',') - 1))NGAYKN    
                            FROM ( 
                            SELECT KN.DONID
                            ,LISTAGG(KN.NGAYKN,',')WITHIN GROUP (ORDER BY KN.NGAYKN DESC)NGAYKN      
                            FROM APS_SOTHAM_KHANGNGHI KN 
                            WHERE KN.TINHTRANG_GIAIQUYET != 3 
                            group by KN.DONID
                            )TT
                      )NKN ON NKN.DONID=TL.DONID
                    WHERE TL.NGAYTHULY IS NOT NULL AND TL.truonghopthuly IN (1)
                    AND d.MAVUVIEC IS NOT NULL  AND TL.SOTHULY IS NOT NULL  AND TL.NGAYTHULY IS NOT NULL
      )
      LOOP
          insert into DASHBOARD_STPT
                        (TOAANID,SOTHULY,NGAYTHULY,CAPXX,MAVUVIEC,KQLOAI,KQSO,KQNGAY,KQNOIDUNG,NGUOIKHANGCAO,NGAYKHANGCAO,NGUYENDON,BIDON,THAMPHANID,NGAYKHANGNGHI,QHPL,LOAIAN
                        ,NGAYDONGBO,TENVUVIEC,SL_KHANGCAO,SL_KHANGNGHI
                        ,DONID,THULYID)
                        values 
                        (item.TOAANID,item.SOTHULY,item.NGAYTHULY,item.CAPXX,item.MAVUVIEC,item.KQLOAI,item.KQSO,item.KQNGAY,item.KQNOIDUNG,item.NGUOIKHANGCAO,item.NGAYKHANGCAO,item.NGUYENDON,item.BIDON,item.THAMPHANID,item.NGAYKHANGNGHI,item.QHPL,item.LOAIAN
                        ,V_SYSDATE,item.TENVUVIEC,item.SL_KHANGCAO,item.SL_KHANGNGHI
                        ,item.DONID,item.THULYID);
             COMMIT;          
      END LOOP;
END DASHBOARD_CREATE_DATA_APS_ST;

END PKG_DASHBOARD_ST_APP;

/
