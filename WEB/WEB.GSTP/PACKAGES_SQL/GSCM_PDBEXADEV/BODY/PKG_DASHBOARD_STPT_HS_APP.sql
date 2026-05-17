--------------------------------------------------------
--  DDL for Package Body PKG_DASHBOARD_STPT_HS_APP
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_DASHBOARD_STPT_HS_APP" AS
PROCEDURE DASHBOARD_CREATE_DATA_AHS_ST
 AS    
    V_SYSDATE DATE;V_COUNTS NUMBER;
    V_KQLOAI NUMBER; V_SOTHULYXX VARCHAR2(512);V_NGAYTHULYXX DATE;
BEGIN
    DELETE DASHBOARD_STPT WHERE LOAIAN=1 AND CAPXX=2;COMMIT;  
    SELECT SYSDATE INTO V_SYSDATE FROM DUAL; 
    ------
      FOR item in (
        SELECT VA.TOAANID
        ,TL.SOTHULY
        ,TL.NGAYTHULY
        ,'2' CAPXX 
        ,VA.MAVUAN MAVUVIEC
         ,CASE WHEN QDBA.NGAYQD IS NULL AND STBA.NGAYBANAN IS NULL  THEN NULL
          WHEN QDBA.NGAYQD IS NOT NULL THEN 1
          WHEN STBA.NGAYBANAN IS NOT NULL  THEN 0
         END  KQLOAI
        ,DECODE (QDBA.SOQD,NULL,STBA.SOBANAN,QDBA.SOQD) KQSO
        ,DECODE (QDBA.NGAYQD, NULL,STBA.NGAYBANAN,QDBA.NGAYQD) KQNGAY
        ,DECODE (QDBA.NGAYQD, NULL,NULL,QDBA.TEN) KQNOIDUNG
        ,NGUOIKC.NGUOIKHANGCAO
        ,NGAYKC.NGAYKHANGCAO
        ,BICAO.NGUYENDON
        ,null BIDON 
        ,TP.THAMPHANID
        ,NKN.NGAYKN NGAYKHANGNGHI
        ,QLPL.TENTOIDANH QHPL
        ,1 LOAIAN
        ,null NGAYDONGBO    
        ,VA.TENVUAN TENVUVIEC
        ,SLKC.SL_KHANGCAO
        ,SLKN.SL_KHANGNGHI
        ,TL.VUANID DONID
        ,TL.ID THULYID
        FROM AHS_SOTHAM_THULY TL        
        LEFT JOIN AHS_VUAN VA ON VA.ID = TL.VUANID
        LEFT JOIN (
                      SELECT COUNT(*) SL_KHANGCAO,KC.VUANID FROM AHS_SOTHAM_KHANGCAO KC  GROUP BY KC.VUANID
                     )SLKC ON SLKC.VUANID=TL.VUANID
         LEFT JOIN (
                      SELECT COUNT(*) SL_KHANGNGHI,KN.VUANID FROM AHS_SOTHAM_KHANGNGHI KN  GROUP BY KN.VUANID
                     )SLKN ON SLKN.VUANID=TL.VUANID             
        LEFT JOIN (
                    SELECT BC.VUANID,LISTAGG(C.TENTOIDANH,',')WITHIN GROUP (ORDER BY BC.BICANDAUVU DESC,BC.NGAYTHAMGIA DESC)TENTOIDANH
                    FROM ( SELECT ID,VUANID,HOTEN,BICANDAUVU,NGAYTHAMGIA, ROW_NUMBER()  OVER (PARTITION BY VUANID ORDER BY BICANDAUVU DESC,NGAYTHAMGIA DESC) ROWNUMBER
                           FROM  AHS_BICANBICAO 
                         )BC 
                LEFT JOIN (SELECT CD.BICANID,CD.TENTOIDANH,CD.ISMAIN FROM AHS_SOTHAM_CAOTRANG_DIEULUAT CD WHERE ISMAIN=1) C ON BC.ID = C.BICANID
                WHERE BC.ROWNUMBER =1
                GROUP BY BC.VUANID
        )QLPL ON QLPL.VUANID=TL.VUANID
        LEFT JOIN (
                   SELECT TT.VUANID
                    ,DECODE(instr(TT.NGAYKN,','),0,TT.NGAYKN,SUBSTR(TT.NGAYKN,0,instr(TT.NGAYKN,',') - 1))NGAYKN    
                    FROM ( 
                    SELECT KN.VUANID
                    ,LISTAGG(KN.NGAYKN,',')WITHIN GROUP (ORDER BY KN.NGAYKN DESC)NGAYKN      
                    FROM AHS_SOTHAM_KHANGNGHI KN 
                    WHERE KN.TINHTRANG_GIAIQUYET != 3 
                    group by KN.VUANID
                    )TT
              )NKN ON NKN.VUANID=TL.VUANID
         LEFT JOIN (
                     SELECT TT.VUANID
                    ,DECODE(instr(TT.THAMPHANID,','),0,TT.THAMPHANID,SUBSTR(TT.THAMPHANID,0,instr(TT.THAMPHANID,',') - 1))THAMPHANID    
                     FROM ( SELECT hd.VUANID                            
                           ,LISTAGG(hd.CANBOID,',')WITHIN GROUP (ORDER BY hd.NGAYPHANCONG DESC)THAMPHANID      
                            FROM AHS_SOTHAM_HDXX hd 
                            WHERE hd.mavaitro='THAMPHAN' and hd.VUANID!=0
                            group by hd.VUANID
                       )TT
                )TP ON TP.VUANID=TL.VUANID
        LEFT JOIN (
                   SELECT BC.VUANID,LISTAGG(BC.HOTEN,', ')WITHIN GROUP (ORDER BY BC.BICANDAUVU DESC,BC.NGAYTHAMGIA DESC)NGUYENDON
                    FROM (SELECT ID,VUANID,HOTEN,BICANDAUVU,NGAYTHAMGIA, ROW_NUMBER()  OVER (PARTITION BY VUANID ORDER BY BICANDAUVU DESC,NGAYTHAMGIA DESC) ROWNUMBER
                    FROM  AHS_BICANBICAO 
                    )BC 
                    LEFT JOIN (SELECT CD.BICANID,CD.TENTOIDANH,CD.ISMAIN FROM AHS_SOTHAM_CAOTRANG_DIEULUAT CD WHERE ISMAIN=1) C ON BC.ID = C.BICANID
                    WHERE BC.ROWNUMBER <=3
                    GROUP BY BC.VUANID
            )BICAO ON BICAO.VUANID=TL.VUANID
        LEFT JOIN (
                    SELECT BC.VUANID,LISTAGG(BC.HOTEN,', ')WITHIN GROUP (ORDER BY BC.BICANDAUVU DESC,BC.NGAYTHAMGIA DESC)NGUOIKHANGCAO
                    FROM (SELECT B.ID,B.VUANID,B.HOTEN,B.BICANDAUVU,B.NGAYTHAMGIA, ROW_NUMBER()  OVER (PARTITION BY B.VUANID ORDER BY B.BICANDAUVU DESC,B.NGAYTHAMGIA DESC) ROWNUMBER
                          FROM  AHS_BICANBICAO B
                          WHERE EXISTS( SELECT 1 FROM AHS_SOTHAM_KHANGCAO KC  WHERE KC.NGUOIKCID=B.ID AND KC.VUANID=B.VUANID)
                          )BC 
                        LEFT JOIN (SELECT CD.BICANID,CD.TENTOIDANH,CD.ISMAIN FROM AHS_SOTHAM_CAOTRANG_DIEULUAT CD WHERE ISMAIN=1) C ON BC.ID = C.BICANID
                    WHERE BC.ROWNUMBER <=3
                    GROUP BY BC.VUANID
                )NGUOIKC ON NGUOIKC.VUANID=TL.VUANID
        LEFT JOIN (
                    SELECT TT.VUANID
                    ,DECODE(instr(TT.NGAYKHANGCAO,','),0,TT.NGAYKHANGCAO,SUBSTR(TT.NGAYKHANGCAO,0,instr(TT.NGAYKHANGCAO,',') - 1))NGAYKHANGCAO    
                    FROM ( 
                    SELECT KC.VUANID
                    ,LISTAGG(KC.NGAYKHANGCAO,',')WITHIN GROUP (ORDER BY KC.NGAYKHANGCAO DESC)NGAYKHANGCAO      
                    FROM AHS_SOTHAM_KHANGCAO KC                                                
                    group by KC.VUANID
                    )TT
          ) NGAYKC ON NGAYKC.VUANID = TL.VUANID       
        LEFT JOIN(SELECT BA.VUANID,BA.SOBANAN,BA.NGAYBANAN
                                FROM AHS_SOTHAM_BANAN BA)STBA ON STBA.VUANID=TL.VUANID  
         LEFT JOIN(SELECT TT.VUANID
                        ,DECODE(instr(TT.SOQD,','),0,TT.SOQD,SUBSTR(TT.SOQD,0,instr(TT.SOQD,',') - 1))SOQD 
                        ,DECODE(instr(TT.NGAYQD,','),0,TT.NGAYQD,SUBSTR(TT.NGAYQD,0,instr(TT.NGAYQD,',') - 1))NGAYQD 
                        ,DECODE(instr(TT.ten,','),0,TT.ten,SUBSTR(TT.ten,0,instr(TT.ten,',') - 1))TEN 
                        FROM ( 
                             SELECT QD.VUANID
                            ,LISTAGG(QD.SOQUYETDINH,',')WITHIN GROUP (ORDER BY QD.NGAYQD DESC)SOQD
                            ,LISTAGG(QD.NGAYQD,',')WITHIN GROUP (ORDER BY QD.NGAYQD DESC)NGAYQD
                            ,LISTAGG(dqd.TEN,',')WITHIN GROUP (ORDER BY QD.NGAYQD DESC)TEN
                                        FROM AHS_SOTHAM_QUYETDINH_VUAN QD
                                        LEFT JOIN DM_QD_QUYETDINH DQD ON DQD.ID=QD.QUYETDINHID 
                                        LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=DQD.LOAIID
                                        WHERE dqd.ket_thuc = 1
                              group by QD.VUANID
                              )TT
                        )QDBA ON QDBA.VUANID=TL.VUANID   
        WHERE 
         VA.MAVUAN IS NOT NULL  AND TL.SOTHULY IS NOT NULL  AND TL.NGAYTHULY IS NOT NULL
      )
      LOOP
          insert into DASHBOARD_STPT
                        (TOAANID,SOTHULY,NGAYTHULY,CAPXX,MAVUVIEC,KQLOAI,KQSO,KQNGAY,KQNOIDUNG,NGUOIKHANGCAO,NGAYKHANGCAO,NGUYENDON,BIDON,THAMPHANID,NGAYKHANGNGHI,QHPL,LOAIAN
                        ,NGAYDONGBO,TENVUVIEC,SL_KHANGCAO,SL_KHANGNGHI)
                        values 
                        (item.TOAANID,item.SOTHULY,item.NGAYTHULY,item.CAPXX,item.MAVUVIEC,item.KQLOAI,item.KQSO,item.KQNGAY,item.KQNOIDUNG,item.NGUOIKHANGCAO,item.NGAYKHANGCAO,item.NGUYENDON,item.BIDON,item.THAMPHANID,item.NGAYKHANGNGHI,item.QHPL,item.LOAIAN
                        ,V_SYSDATE,item.TENVUVIEC,item.SL_KHANGCAO,item.SL_KHANGNGHI);
             COMMIT;          
      END LOOP;
END DASHBOARD_CREATE_DATA_AHS_ST;
PROCEDURE DASHBOARD_CREATE_DATA_AHS_PT
 AS    
    V_SYSDATE DATE;V_COUNTS NUMBER;
    V_KQLOAI NUMBER; V_SOTHULYXX VARCHAR2(512);V_NGAYTHULYXX DATE;
BEGIN
    DELETE DASHBOARD_STPT WHERE LOAIAN=1 AND CAPXX=3;COMMIT;  
    SELECT SYSDATE INTO V_SYSDATE FROM DUAL; 
    ------
      FOR item in (
        SELECT TL.TOAANID
        ,TL.SOTHULY
        ,TL.NGAYTHULY
        ,'3' CAPXX 
        ,VA.MAVUAN MAVUVIEC
         ,CASE WHEN QDBA.NGAYQD IS NULL AND STBA.NGAYBANAN IS NULL  THEN NULL
          WHEN QDBA.NGAYQD IS NOT NULL THEN 1
          WHEN STBA.NGAYBANAN IS NOT NULL  THEN 0
         END  KQLOAI
        ,DECODE (QDBA.SOQD,NULL,STBA.SOBANAN,QDBA.SOQD) KQSO
        ,DECODE (QDBA.NGAYQD, NULL,STBA.NGAYBANAN,QDBA.NGAYQD) KQNGAY
        ,DECODE (QDBA.NGAYQD, NULL,NULL,QDBA.TEN) KQNOIDUNG
        ,null NGUOIKHANGCAO
        ,null NGAYKHANGCAO
        ,NULL NGUYENDON
        ,null BIDON 
        ,TP.THAMPHANID
        ,NULL NGAYKHANGNGHI
        ,NULL QHPL
        ,1 LOAIAN
        ,null NGAYDONGBO    
        ,NULL TENVUVIEC
        ,NULL SL_KHANGCAO
        ,NULL SL_KHANGNGHI
        ,TL.VUANID DONID
        ,TL.ID THULYID
        FROM AHS_PHUCTHAM_THULY TL        
        LEFT JOIN AHS_VUAN VA ON VA.ID = TL.VUANID
        LEFT JOIN(SELECT BA.VUANID,BA.SOBANAN,BA.NGAYBANAN
                                FROM AHS_PHUCTHAM_BANAN BA)STBA ON STBA.VUANID=TL.VUANID  
         LEFT JOIN (
                     SELECT TT.VUANID
                    ,DECODE(instr(TT.THAMPHANID,','),0,TT.THAMPHANID,SUBSTR(TT.THAMPHANID,0,instr(TT.THAMPHANID,',') - 1))THAMPHANID    
                     FROM ( SELECT hd.VUANID                            
                           ,LISTAGG(hd.CANBOID,',')WITHIN GROUP (ORDER BY hd.NGAYPHANCONG DESC)THAMPHANID      
                            FROM AHS_PHUCTHAM_HDXX hd 
                            WHERE hd.mavaitro='THAMPHAN' and hd.VUANID!=0
                            group by hd.VUANID
                       )TT
                )TP ON TP.VUANID=TL.VUANID
         LEFT JOIN(SELECT TT.VUANID
                        ,DECODE(instr(TT.SOQD,','),0,TT.SOQD,SUBSTR(TT.SOQD,0,instr(TT.SOQD,',') - 1))SOQD 
                        ,DECODE(instr(TT.NGAYQD,','),0,TT.NGAYQD,SUBSTR(TT.NGAYQD,0,instr(TT.NGAYQD,',') - 1))NGAYQD 
                        ,DECODE(instr(TT.ten,','),0,TT.ten,SUBSTR(TT.ten,0,instr(TT.ten,',') - 1))TEN 
                        FROM ( 
                             SELECT QD.VUANID
                            ,LISTAGG(QD.SOQUYETDINH,',')WITHIN GROUP (ORDER BY QD.NGAYQD DESC)SOQD
                            ,LISTAGG(QD.NGAYQD,',')WITHIN GROUP (ORDER BY QD.NGAYQD DESC)NGAYQD
                            ,LISTAGG(dqd.TEN,',')WITHIN GROUP (ORDER BY QD.NGAYQD DESC)TEN
                                        FROM AHS_PHUCTHAM_QUYETDINH_VUAN QD
                                        LEFT JOIN DM_QD_QUYETDINH DQD ON DQD.ID=QD.QUYETDINHID 
                                        LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=DQD.LOAIID
                                        WHERE dqd.ket_thuc = 1
                              group by QD.VUANID
                              )TT
                        )QDBA ON QDBA.VUANID=TL.VUANID   
        WHERE 
         VA.MAVUAN IS NOT NULL  AND TL.SOTHULY IS NOT NULL  AND TL.NGAYTHULY IS NOT NULL
         AND TL.TOAANID IS NOT NULL
      )
      LOOP
          insert into DASHBOARD_STPT
                        (TOAANID,SOTHULY,NGAYTHULY,CAPXX,MAVUVIEC,KQLOAI,KQSO,KQNGAY,KQNOIDUNG,NGUOIKHANGCAO,NGAYKHANGCAO,NGUYENDON,BIDON,THAMPHANID,NGAYKHANGNGHI,QHPL,LOAIAN
                        ,NGAYDONGBO,TENVUVIEC,SL_KHANGCAO,SL_KHANGNGHI)
                        values 
                        (item.TOAANID,item.SOTHULY,item.NGAYTHULY,item.CAPXX,item.MAVUVIEC,item.KQLOAI,item.KQSO,item.KQNGAY,item.KQNOIDUNG,item.NGUOIKHANGCAO,item.NGAYKHANGCAO,item.NGUYENDON,item.BIDON,item.THAMPHANID,item.NGAYKHANGNGHI,item.QHPL,item.LOAIAN
                        ,V_SYSDATE,item.TENVUVIEC,item.SL_KHANGCAO,item.SL_KHANGNGHI);
             COMMIT;          
      END LOOP;
END DASHBOARD_CREATE_DATA_AHS_PT;

END PKG_DASHBOARD_STPT_HS_APP;

/
