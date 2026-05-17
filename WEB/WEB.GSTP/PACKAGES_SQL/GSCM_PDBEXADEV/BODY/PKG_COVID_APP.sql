--------------------------------------------------------
--  DDL for Package Body PKG_COVID_APP
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "PKG_COVID_APP" AS
FUNCTION COVID_BAOCAO
RETURN SYS_REFCURSOR
AS
      V_CURSOR sys_refcursor;V_EXPORT_TEXT CLOB;  v_table T_COVID_BAOCAO;v_table_s T_COVID_BAOCAO; TotalItem NUMBER;
       TYPE ARRAY_T IS VARRAY(6) OF NVARCHAR2(100);
       array array_t := array_t('F1','F2','F3','F4','FN','FF');  
begin
     DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true); v_table := T_COVID_BAOCAO(); v_table_s := T_COVID_BAOCAO();
     ------------
     --Insert số trang
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
              <div style="mso-element: footer" id="f1">
                <w:sdt sdtdocpart="t"
                docparttype="Page Numbers (Bottom of Page)" docpartunique="t" id="644013658">
                <p class=MsoFooter align=right style="text-align:right"><!--[if supportFields]><span
                style="mso-element:field-begin"></span><span
                style="mso-spacerun:yes"> </span>PAGE<span style="mso-spacerun:yes">  
                </span>\* MERGEFORMAT <span style="mso-element:field-separator"></span><![endif]--><span
                style="mso-no-proof:yes;display:none">2</span><!--[if supportFields]><span
                style="mso-no-proof:yes"><span style="mso-element:field-end"></span></span><![endif]--><w:sdtPr></w:sdtPr></p>
                </w:sdt>
                <p class="MsoFooter" align="right" style="text-align: right;"><o:p></o:p> </p>
             </div>');
              DBMS_LOB.APPEND(V_EXPORT_TEXT,'
             <table cellpadding="1" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
                <tr>
                    <td colspan="8" style="line-height: 100%; font-size: 14pt"><b>DANH SÁCH CÁN BỘ CÔNG CHỨC CÓ TIẾP XÚC GẦN VỚI NGƯỜI MẮC BỆNH HOẶC NGHI NGỜ MẮC BỆNH VIÊM ĐƯỜNG HÔ HẤP DO NCOV</b>
                    </td>
                </tr>
                <tr>
                    <td colspan="8" style="height: 15pt;"></td>
                </tr>
                <tr style="font-weight: bold;">
                    <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">STT</td>
                    <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Họ và tên</td>
                    <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Chức vụ, đơn vị công tác</td>
                    <td colspan="4" style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;height: 30pt;">Đối tượng thuộc diện</td>
                    <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ghi chú</td>
                </tr>
                <tr style="font-weight: bold;">
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; height: 40pt;">F1</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">F2</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">F3</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">F4</td>
                </tr>
                       ');
          FOR I IN 1..ARRAY.COUNT    
          LOOP
             ----------F1','F2','F3','F4','FN','FF'
                FOR item IN (
                 SELECT DK.CANBOID FROM COVID_DANGKY DK  
                 WHERE DK.XACDINH_F=ARRAY(I) AND (TO_CHAR(DK.CACHLY_TUNGAY,'dd/MM/yyyy') ='01/01/0001'  OR (SYSDATE>= DK.CACHLY_TUNGAY AND SYSDATE <=DK.CACHLY_DENGAY ))
                 AND DK.NGAYTAO>=TO_DATE('30/04/2021','dd/MM/yyyy') 
                 GROUP BY DK.CANBOID HAVING COUNT(*) > 1
                 )
                 LOOP
                       FOR items IN (
                                  SELECT DS.* FROM (
                                   SELECT DDK.* FROM COVID_DANGKY DDK WHERE DDK.CANBOID=item.CANBOID  AND DDK.NGAYTAO>=TO_DATE('30/04/2021','dd/MM/yyyy') 
                                   AND DDK.XACDINH_F=ARRAY(I) AND (TO_CHAR(DDK.CACHLY_TUNGAY,'dd/MM/yyyy') ='01/01/0001'  OR (SYSDATE>= DDK.CACHLY_TUNGAY AND SYSDATE <=DDK.CACHLY_DENGAY ))
                                   ORDER BY DDK.NGAYTAO DESC
                                   )DS WHERE ROWNUM=1
                                 )
                          LOOP
                             v_table_s.extend;
                             v_table_s(v_table_s.count) := R_COVID_BAOCAO(
                                         items.ID,items.CANBOID,NULL,NULL,NULL,NULL,NULL,NULL,NULL
                                        );
                         END LOOP;
                 END LOOP;
                 ---------
                 FOR item IN (
                 SELECT DK.CANBOID FROM COVID_DANGKY DK  
                 WHERE DK.XACDINH_F=ARRAY(I) AND (TO_CHAR(DK.CACHLY_TUNGAY,'dd/MM/yyyy') ='01/01/0001'  OR (SYSDATE>= DK.CACHLY_TUNGAY AND SYSDATE <=DK.CACHLY_DENGAY ))
                 AND DK.NGAYTAO>=TO_DATE('30/04/2021','dd/MM/yyyy') 
                 GROUP BY DK.CANBOID HAVING COUNT(*) = 1
                 )
                 LOOP
                       FOR items IN (
                                   SELECT DDK.* FROM COVID_DANGKY DDK WHERE DDK.CANBOID=item.CANBOID 
                                   AND DDK.XACDINH_F=ARRAY(I) AND (TO_CHAR(DDK.CACHLY_TUNGAY,'dd/MM/yyyy') ='01/01/0001'  OR (SYSDATE>= DDK.CACHLY_TUNGAY AND SYSDATE <=DDK.CACHLY_DENGAY ))
                                  )
                          LOOP
                             v_table_s.extend;
                             v_table_s(v_table_s.count) := R_COVID_BAOCAO(
                                         items.ID,items.CANBOID,NULL,NULL,NULL,NULL,NULL,NULL,NULL
                                        );
                         END LOOP;
                 END LOOP;
        END LOOP;
      FOR I IN 1..4    
          LOOP
              --------------------------   
             FOR item IN ( SELECT DK.ID,CB.ID CANBOID,CB.HOTEN,CD.TEN||CV.TEN||TT.TEN_ALIAS CHUCVU_DONVI,DK.GHICHU
                            ,TO_CHAR(DK.CACHLY_TUNGAY,'dd/MM/yyyy') CACHLY_TUNGAY
                            ,TO_CHAR(DK.CACHLY_DENGAY,'dd/MM/yyyy') CACHLY_DENGAY
                            ,TO_CHAR(DK.NGAYTAO,'dd/MM/yyyy') NGAYTAO
                        FROM COVID_DANGKY DK
                        LEFT JOIN COVID_DM_CANBO CB ON DK.CANBOID=CB.ID
                        LEFT JOIN COVID_DV_TRUCTHUOC TT ON TT.ID=CB.DV_TRUCTHUOC
                        LEFT JOIN COVID_PHONGBAN PB ON PB.ID=CB.PHONGBANID
                        LEFT JOIN (SELECT C.MA,C.ID,C.TEN||' 'TEN, C.THUTU FROM DM_DATAITEM C  WHERE C.GROUPID=13)CV ON CV.ID=CB.CHUCVUID
                        LEFT JOIN (SELECT C.MA,C.ID,C.TEN||' 'TEN, C.THUTU FROM DM_DATAITEM C  WHERE C.GROUPID=12)CD ON CD.ID=CB.CHUCDANHID
                        WHERE DK.XACDINH_F=ARRAY(I) AND (TO_CHAR(DK.CACHLY_TUNGAY,'dd/MM/yyyy') ='01/01/0001'  OR (SYSDATE>= DK.CACHLY_TUNGAY AND SYSDATE <=DK.CACHLY_DENGAY ))
                        AND DK.NGAYTAO>=TO_DATE('30/04/2021','dd/MM/yyyy') 
                        AND EXISTS (SELECT 'x' FROM TABLE(v_table_s)PA WHERE PA.ID=DK.ID)     
                     )
                     LOOP
                  IF(ARRAY(I)='F1') THEN
                         v_table.extend;
                         v_table(v_table.count) := R_COVID_BAOCAO(
                                     item.ID,item.CANBOID,item.HOTEN,item.CHUCVU_DONVI,'X',NULL,NULL,NULL,item.GHICHU
                                    );
                        ELSIF(ARRAY(I)='F2') THEN  
                        v_table.extend;
                         v_table(v_table.count) := R_COVID_BAOCAO(
                                     item.ID,item.CANBOID,item.HOTEN,item.CHUCVU_DONVI,NULL,'X',NULL,NULL,item.GHICHU
                                    );
                         ELSIF(ARRAY(I)='F3') THEN  
                        v_table.extend;
                         v_table(v_table.count) := R_COVID_BAOCAO(
                                     item.ID,item.CANBOID,item.HOTEN,item.CHUCVU_DONVI,NULL,NULL,'X',NULL,item.GHICHU
                                    ); 
                         ELSIF(ARRAY(I)='F4') THEN  
                        v_table.extend;
                         v_table(v_table.count) := R_COVID_BAOCAO(
                                     item.ID,item.CANBOID,item.HOTEN,item.CHUCVU_DONVI,NULL,NULL,NULL,'X',item.GHICHU
                                    );    
                  END IF;          
                  END LOOP;
       END LOOP;   
   -------
    FOR I IN 5..ARRAY.COUNT
       LOOP
             FOR item IN ( SELECT DK.ID,CB.ID CANBOID,CB.HOTEN,CD.TEN||CV.TEN||TT.TEN_ALIAS CHUCVU_DONVI,DK.GHICHU
                            ,TO_CHAR(DK.CACHLY_TUNGAY,'dd/MM/yyyy') CACHLY_TUNGAY
                            ,TO_CHAR(DK.CACHLY_DENGAY,'dd/MM/yyyy') CACHLY_DENGAY
                            ,TO_CHAR(DK.NGAYTAO,'dd/MM/yyyy') NGAYTAO
                        FROM COVID_DANGKY DK
                        LEFT JOIN COVID_DM_CANBO CB ON DK.CANBOID=CB.ID
                        LEFT JOIN COVID_DV_TRUCTHUOC TT ON TT.ID=CB.DV_TRUCTHUOC
                        LEFT JOIN COVID_PHONGBAN PB ON PB.ID=CB.PHONGBANID
                        LEFT JOIN (SELECT C.MA,C.ID,C.TEN||' 'TEN, C.THUTU FROM DM_DATAITEM C  WHERE C.GROUPID=13)CV ON CV.ID=CB.CHUCVUID
                        LEFT JOIN (SELECT C.MA,C.ID,C.TEN||' 'TEN, C.THUTU FROM DM_DATAITEM C  WHERE C.GROUPID=12)CD ON CD.ID=CB.CHUCDANHID
                        WHERE DK.XACDINH_F=ARRAY(I) AND (TO_CHAR(DK.CACHLY_TUNGAY,'dd/MM/yyyy') ='01/01/0001'  OR (SYSDATE>= DK.CACHLY_TUNGAY AND SYSDATE <=DK.CACHLY_DENGAY ))
                        AND NOT EXISTS (SELECT 'x' FROM TABLE(v_table)PA WHERE PA.CANBOID=DK.CANBOID)   
                        AND DK.NGAYTAO>=TO_DATE('30/04/2021','dd/MM/yyyy') 
                     )
                     LOOP
                    IF(ARRAY(I)='FN') THEN
                         v_table.extend;
                         v_table(v_table.count) := R_COVID_BAOCAO(
                                     item.ID,item.CANBOID,item.HOTEN,item.CHUCVU_DONVI,NULL,NULL,NULL,NULL,item.GHICHU
                                    );
                     ELSIF(ARRAY(I)='FF') THEN  
                     v_table.extend;
                     v_table(v_table.count) := R_COVID_BAOCAO(
                               item.ID,item.CANBOID,item.HOTEN,item.CHUCVU_DONVI,NULL,NULL,NULL,NULL,item.GHICHU
                                );  
                        END IF;
                     END LOOP;
        END LOOP;              

                ---------------------------------
               FOR item IN (
                   SELECT ROW_NUMBER() OVER (ORDER BY SUBSTR(PA.COLUMN_1 ,INSTR(PA.COLUMN_1 ,' ',-1)+ 1)) STT,PA.* FROM TABLE(v_table) PA
               )
               LOOP
               DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                       <tr>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;padding: 5px;">'||item.STT||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_1||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_2||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_3||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_4||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_5||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_6||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_7||'</td>
                      </tr>
                    '); 
                END LOOP;
             ----------
              DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
              <tr style="height: 1pt;">
                    <td style="width: 30px"></td>
                    <td style="width: 150px"></td>
                    <td style="width: 150px"></td>
                    <td style="width: 47px"></td>
                    <td style="width: 47px"></td>
                    <td style="width: 47px"></td>
                    <td style="width: 47px"></td>
                    <td style="width: 200px"></td>
                </tr>
               </table>
                ');

    OPEN V_CURSOR FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;
         dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;  
END COVID_BAOCAO;
FUNCTION COVID_DANGKY_DS_ALL
(
  V_DENNGAY IN VARCHAR2,
  v_TRANGTHAI in varchar2,
  vDV_TRUCTHUOC in varchar2,
  vPhongbanID in varchar2,
  vChucDanhID in varchar2,
  vChucVuID in varchar2,
  v_KeySearch in varchar2,
  V_CANBOID IN NVARCHAR2 DEFAULT NULL,
  PageIndex	in	NUMBER,
  PageSize	in	NUMBER
)
RETURN SYS_REFCURSOR
AS
      MININDEX	number;  MAXINDEX	number;V_TONG_DANGKY VARCHAR2(100):='';V_TONG_CANBO VARCHAR2(100):='';
      V_CURSOR sys_refcursor; VV_TUNGAY date;VV_DENNGAY date;
begin
  MININDEX := pagesize*(PAGEINDEX - 1) + 1;
  MAXINDEX := PAGEINDEX*pagesize ;
  --------------------
    if(V_DENNGAY IS NULL) THEN
       VV_TUNGAY:=to_date(TO_CHAR(SYSDATE,'dd/MM/yyyy')||' 00:00:00','dd/MM/yyyy HH24:MI:SS'); 
       VV_DENNGAY:=to_date(TO_CHAR(SYSDATE,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS');
     ELSE
      VV_TUNGAY:=to_date(trim(V_DENNGAY)||' 00:00:00','dd/MM/yyyy HH24:MI:SS'); 
      VV_DENNGAY:=to_date(trim(V_DENNGAY)||' 23:59:59','dd/MM/yyyy HH24:MI:SS');
    END IF;
 ---------------
  SELECT COUNT(*) INTO V_TONG_DANGKY FROM (
         SELECT DK.CANBOID FROM  COVID_DANGKY DK 
         LEFT JOIN COVID_DM_CANBO CB ON CB.ID=DK.CANBOID  
         LEFT JOIN COVID_DV_TRUCTHUOC TT ON TT.ID=CB.DV_TRUCTHUOC
         LEFT JOIN COVID_PHONGBAN PB ON PB.ID=CB.PHONGBANID
         LEFT JOIN (SELECT C.MA,C.ID,C.TEN||' 'TEN, C.THUTU FROM DM_DATAITEM C  WHERE C.GROUPID=13)CV ON CV.ID=CB.CHUCVUID
         LEFT JOIN (SELECT C.MA,C.ID,C.TEN||' 'TEN, C.THUTU FROM DM_DATAITEM C  WHERE C.GROUPID=12)CD ON CD.ID=CB.CHUCDANHID
                 WHERE (V_CANBOID IS NULL OR DK.CANBOID=V_CANBOID)
                 AND (vDV_TRUCTHUOC IS NULL OR CB.DV_TRUCTHUOC=vDV_TRUCTHUOC)
                 AND (vChucDanhID IS NULL OR CD.ID=vChucDanhID)
                 AND (vChucVuID IS NULL OR CV.ID=vChucVuID)
                 AND (vPhongbanID IS NULL OR CB.PHONGBANID=vPhongbanID)
                 AND (v_KeySearch IS NULL 
                   OR(UPPER(CB.HOTEN) LIKE '%'||UPPER(v_KeySearch)||'%')
                   OR(UPPER(CB.MACANBO) LIKE '%'||UPPER(v_KeySearch)||'%')
                   OR(UPPER(CB.DIACHI) LIKE '%'||UPPER(v_KeySearch)||'%')
                   OR(UPPER(DK.NGUOITAO) LIKE '%'||UPPER(v_KeySearch)||'%')
                 )
          AND  DK.NGAYTAO>=VV_TUNGAY AND DK.NGAYTAO<=VV_DENNGAY       
           AND DK.NGAYTAO>=TO_DATE('30/04/2021','dd/MM/yyyy') 
        GROUP BY DK.CANBOID
        );
        ----------------
       SELECT COUNT(CB.ID)INTO V_TONG_CANBO FROM COVID_DM_CANBO CB
        LEFT JOIN COVID_DV_TRUCTHUOC TT ON TT.ID=CB.DV_TRUCTHUOC
        LEFT JOIN COVID_PHONGBAN PB ON PB.ID=CB.PHONGBANID
        LEFT JOIN (SELECT C.MA,C.ID,C.TEN||' 'TEN, C.THUTU FROM DM_DATAITEM C  WHERE C.GROUPID=13)CV ON CV.ID=CB.CHUCVUID
        LEFT JOIN (SELECT C.MA,C.ID,C.TEN||' 'TEN, C.THUTU FROM DM_DATAITEM C  WHERE C.GROUPID=12)CD ON CD.ID=CB.CHUCDANHID
        WHERE (V_CANBOID IS NULL OR CB.ID=V_CANBOID)
        AND (vDV_TRUCTHUOC IS NULL OR CB.DV_TRUCTHUOC=vDV_TRUCTHUOC)
        AND (vChucDanhID IS NULL OR CD.ID=vChucDanhID)
        AND (vChucVuID IS NULL OR CV.ID=vChucVuID)
        AND (vPhongbanID IS NULL OR CB.PHONGBANID=vPhongbanID)        
        AND  CB.TOAANID=1 AND CB.HIEULUC=1;
 ---------------
       OPEN v_cursor FOR
        select '<b>('||DECODE(v_TRANGTHAI,1,V_TONG_DANGKY||'/'||V_TONG_CANBO
        ,2,COUNTALL||'/'||V_TONG_CANBO,NULL,V_TONG_CANBO)||' Cán bộ, công chức</b>)' DANGKY_TONG,
        DS.* from (
        SELECT COUNT(*) OVER()COUNTALL,ROW_NUMBER() OVER (ORDER BY TTS.NGAYTAOS DESC) STT,TTS.* FROM (
            SELECT TT.* FROM(
                SELECT
                CB.HOTEN,TO_CHAR(DK.NGAYTAO,'dd/MM/yyyy HH24:MI:SS') NGAYTAO,TO_CHAR(DK.NGAYSUA,'dd/MM/yyyy HH24:MI:SS') NGAYSUA,DK.NGUOITAO,DECODE(DK.TIEPXUCGAN_BN,0,NULL,'X')TIEPXUCGAN_BN
                ,DECODE(DK.SOT,0,null,'X')SOT,DK.GHICHU
                ,( DECODE(TO_CHAR(DK.CACHLY_TUNGAY,'dd/MM/yyyy'),'01/01/0001',NULL,'Từ ngày '||TO_CHAR(DK.CACHLY_TUNGAY,'dd/MM/yyyy'))
                ||DECODE(TO_CHAR(DK.CACHLY_DENGAY,'dd/MM/yyyy'),'01/01/0001',NULL,'<br/> Đến ngày '||TO_CHAR(DK.CACHLY_DENGAY,'dd/MM/yyyy')) )TIME_CACHLY
                ,CD.TEN||CV.TEN||TT.TEN_ALIAS TEN_ALIAS,DK.NGAYTAO NGAYTAOS 
                ,DECODE(DK.XACDINH_F,NULL,NULL,'F1','X')F1
                ,DECODE(DK.XACDINH_F,NULL,NULL,'F2','X')F2
                ,DECODE(DK.XACDINH_F,NULL,NULL,'F3','X')F3
                ,DECODE(DK.XACDINH_F,NULL,NULL,'F34','X')F4
                FROM COVID_DANGKY DK
                 LEFT JOIN COVID_DM_CANBO CB ON CB.ID=DK.CANBOID  
                 LEFT JOIN COVID_DV_TRUCTHUOC TT ON TT.ID=CB.DV_TRUCTHUOC
                 LEFT JOIN COVID_PHONGBAN PB ON PB.ID=CB.PHONGBANID
                 LEFT JOIN (SELECT C.MA,C.ID,C.TEN||' 'TEN, C.THUTU FROM DM_DATAITEM C  WHERE C.GROUPID=13)CV ON CV.ID=CB.CHUCVUID
                 LEFT JOIN (SELECT C.MA,C.ID,C.TEN||' 'TEN, C.THUTU FROM DM_DATAITEM C  WHERE C.GROUPID=12)CD ON CD.ID=CB.CHUCDANHID
                WHERE (V_CANBOID IS NULL OR DK.CANBOID=V_CANBOID)
                AND (vDV_TRUCTHUOC IS NULL OR CB.DV_TRUCTHUOC=vDV_TRUCTHUOC)
                AND (vChucDanhID IS NULL OR CD.ID=vChucDanhID)
                AND (vChucVuID IS NULL OR CV.ID=vChucVuID)
                AND (vPhongbanID IS NULL OR CB.PHONGBANID=vPhongbanID)
                AND (v_KeySearch IS NULL 
                   OR(UPPER(CB.HOTEN) LIKE '%'||UPPER(v_KeySearch)||'%')
                   OR(UPPER(CB.MACANBO) LIKE '%'||UPPER(v_KeySearch)||'%')
                   OR(UPPER(CB.DIACHI) LIKE '%'||UPPER(v_KeySearch)||'%')
                   OR(UPPER(DK.NGUOITAO) LIKE '%'||UPPER(v_KeySearch)||'%')
                 )
                AND (v_TRANGTHAI IS NULL
                  OR ( v_TRANGTHAI=1 AND( ( EXISTS (
                                                       SELECT 'X' FROM (
                                                            SELECT TT.* FROM (
                                                                SELECT DK.* FROM COVID_DANGKY DK 
                                                                LEFT JOIN COVID_DM_CANBO CB ON DK.CANBOID=CB.ID
                                                                WHERE  (SELECT COUNT(*) FROM COVID_DANGKY DS WHERE DS.CANBOID=DK.CANBOID AND  DS.NGAYTAO>=VV_TUNGAY AND DS.NGAYTAO<=VV_DENNGAY)>1 --lấy danh sách có số lần nhập >1 bản ghi trong ngày
                                                                AND  DK.NGAYTAO>=VV_TUNGAY AND DK.NGAYTAO<=VV_DENNGAY
                                                                AND CB.DV_TRUCTHUOC=vDV_TRUCTHUOC
                                                                ORDER BY DK.NGAYTAO DESC -- lấy gia trị nhập mới nhất
                                                            )TT WHERE ROWNUM=1 --chỉ lấy 1 bản ghi
                                                            UNION ALL 
                                                            SELECT DK.* FROM COVID_DANGKY DK 
                                                             LEFT JOIN COVID_DM_CANBO CB ON DK.CANBOID=CB.ID
                                                            WHERE  (SELECT COUNT(*) FROM COVID_DANGKY DS WHERE DS.CANBOID=DK.CANBOID AND  DS.NGAYTAO>=VV_TUNGAY AND DS.NGAYTAO<=VV_DENNGAY)=1 -- lấy danh sách có cố lần nhập 1 lần trong ngày
                                                             AND CB.DV_TRUCTHUOC=vDV_TRUCTHUOC
                                                            AND  DK.NGAYTAO>=VV_TUNGAY AND DK.NGAYTAO<=VV_DENNGAY
                                                    )TTS WHERE TTS.ID=DK.ID                            
                                                )
                                                AND vDV_TRUCTHUOC IS NOT NULL
                                            )
                                        OR  vDV_TRUCTHUOC IS NULL   
                                        )
                     )
                  )
                AND  DK.NGAYSUA>=VV_TUNGAY AND DK.NGAYSUA<=VV_DENNGAY
           )TT
         UNION ALL  --trường hợp chưa khai báo y tế v_TRANGTHAI=2
         SELECT TT.* FROM (
            SELECT 
                CB.HOTEN
                ,NULL NGAYTAO,NULL NGAYSUA,NULL NGUOITAO,NULL TIEPXUCGAN_BN
                ,NULL SOT,'Chưa khai báo y tế' GHICHU
                ,NULL TIME_CACHLY
                ,CD.TEN||CV.TEN||TT.TEN_ALIAS TEN_ALIAS,TO_DATE('01/01/2020','dd/MM/yyyy') NGAYTAOS
                ,NULL F1
                ,NULL F2
                ,NULL F3
                ,NULL F4
                 FROM COVID_DM_CANBO CB 
                 LEFT JOIN COVID_DV_TRUCTHUOC TT ON TT.ID=CB.DV_TRUCTHUOC
                 LEFT JOIN COVID_PHONGBAN PB ON PB.ID=CB.PHONGBANID
                 LEFT JOIN (SELECT C.MA,C.ID,C.TEN||' 'TEN, C.THUTU FROM DM_DATAITEM C  WHERE C.GROUPID=13)CV ON CV.ID=CB.CHUCVUID
                 LEFT JOIN (SELECT C.MA,C.ID,C.TEN||' 'TEN, C.THUTU FROM DM_DATAITEM C  WHERE C.GROUPID=12)CD ON CD.ID=CB.CHUCDANHID
                WHERE (V_CANBOID IS NULL OR CB.ID=V_CANBOID)
                AND (vDV_TRUCTHUOC IS NULL OR CB.DV_TRUCTHUOC=vDV_TRUCTHUOC)
                AND (vChucDanhID IS NULL OR CD.ID=vChucDanhID)
                AND (vChucVuID IS NULL OR CV.ID=vChucVuID)
                AND (vPhongbanID IS NULL OR CB.PHONGBANID=vPhongbanID)
                AND (v_KeySearch IS NULL 
                   OR(UPPER(CB.HOTEN) LIKE '%'||UPPER(v_KeySearch)||'%')
                   OR(UPPER(CB.MACANBO) LIKE '%'||UPPER(v_KeySearch)||'%')
                   OR(UPPER(CB.DIACHI) LIKE '%'||UPPER(v_KeySearch)||'%')
                 )
                AND ( (v_TRANGTHAI IS NULL AND  NOT EXISTS (SELECT 'X' FROM COVID_DANGKY DDK WHERE DDK.CANBOID=CB.ID  AND  DDK.NGAYTAO>=VV_TUNGAY AND DDK.NGAYTAO<=VV_DENNGAY) )
                  OR ( v_TRANGTHAI=2 AND NOT EXISTS (SELECT 'X' FROM COVID_DANGKY DDK WHERE DDK.CANBOID=CB.ID  AND  DDK.NGAYTAO>=VV_TUNGAY AND DDK.NGAYTAO<=VV_DENNGAY) 
                     )
                  )
                 AND CB.HIEULUC=1 
           ) TT
        )TTS
    ) DS WHERE DS.STT>=MININDEX AND DS.STT<=MAXINDEX;

    RETURN v_cursor;   
END COVID_DANGKY_DS_ALL;
FUNCTION GET_CHUCVU_CHECK
(
  V_CANBOID IN NVARCHAR2 DEFAULT NULL
)
RETURN SYS_REFCURSOR
AS
V_CURSOR sys_refcursor; 
BEGIN
    --45 Chánh án,426 Viện trưởng,432 Vụ trưởng,444 Chánh Văn phòng,451 Giám đốc,455 Cục trưởng,428 Tổng biên tập 
    OPEN V_CURSOR FOR
         SELECT CB.* FROM COVID_DM_CANBO CB 
         INNER JOIN (SELECT C.MA,C.ID,C.TEN, C.THUTU FROM DM_DATAITEM C 
                    WHERE C.GROUPID=13 AND ID IN(45,426,432,444,451,455,428)
                    )cc on cc.id=CB.CHUCVUID
        WHERE CB.ID=V_CANBOID;
     -------------------   
    RETURN V_CURSOR;  
END GET_CHUCVU_CHECK;
FUNCTION CANH_BAO_TK
(
  V_CANBOID IN NVARCHAR2 DEFAULT NULL
)
RETURN SYS_REFCURSOR
AS
V_CURSOR sys_refcursor; V_EXPORT_TEXT CLOB;  V_EXPORT_TEXT_ITEM CLOB;
COUNT_CHUCVU NUMBER;COUNT_RECORD NUMBER; V_NGAYTAO DATE;V_DV_TRUCTHUOC NUMBER;
V_COUNT_CHUADANGKY NUMBER;V_COUNT_DADANGKY NUMBER;
BEGIN
     DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);     DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT_ITEM,true);    
    ----------
    --45 Chánh án,426 Viện trưởng,432 Vụ trưởng,444 Chánh Văn phòng,451 Giám đốc,455 Cục trưởng,428 Tổng biên tập 
    ----------
    SELECT COUNT(*) INTO COUNT_CHUCVU FROM COVID_DM_CANBO CB 
    INNER JOIN (SELECT C.MA,C.ID,C.TEN, C.THUTU FROM DM_DATAITEM C 
                WHERE C.GROUPID=13 AND ID IN(45,426,432,444,451,455,428)
                )cc on cc.id=CB.CHUCVUID
    WHERE CB.ID=V_CANBOID;
    ----------

       SELECT COUNT(*) INTO COUNT_RECORD FROM COVID_DANGKY DK  WHERE DK.CANBOID=V_CANBOID
       AND DK.NGAYTAO>=to_date(to_char(sysdate,'dd/MM/yyyy')||' 00:00:00','dd/MM/yyyy HH24:MI:SS')
       AND DK.NGAYTAO<=to_date(to_char(sysdate,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy  HH24:MI:SS')
       AND DK.NGAYTAO>=TO_DATE('30/04/2021','dd/MM/yyyy') ;

             IF(COUNT_CHUCVU>0)THEN
                 SELECT CB.DV_TRUCTHUOC INTO V_DV_TRUCTHUOC FROM COVID_DM_CANBO CB WHERE CB.ID=V_CANBOID;
                  ---đã đăng ký
                   SELECT  COUNT(*) INTO V_COUNT_DADANGKY FROM (
                    SELECT DK.CANBOID FROM COVID_DANGKY DK 
                    WHERE DK.DV_TRUCTHUOC =V_DV_TRUCTHUOC
                     AND DK.NGAYTAO>=to_date(to_char(sysdate,'dd/MM/yyyy')||' 00:00:00','dd/MM/yyyy HH24:MI:SS')
                     AND DK.NGAYTAO<=to_date(to_char(sysdate,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy  HH24:MI:SS')
                    GROUP BY DK.CANBOID
                    )CO;
                  ----chưa đăng ký
                  SELECT COUNT(CB.ID) INTO V_COUNT_CHUADANGKY FROM COVID_DM_CANBO CB 
                  WHERE NOT EXISTS(SELECT 'X' FROM COVID_DANGKY DK WHERE DK.CANBOID=CB.ID
                                     AND DK.NGAYTAO>=to_date(to_char(sysdate,'dd/MM/yyyy')||' 00:00:00','dd/MM/yyyy HH24:MI:SS')
                                     AND DK.NGAYTAO<=to_date(to_char(sysdate,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy  HH24:MI:SS')
                                     )
                  AND CB.HIEULUC=1 AND CB.DV_TRUCTHUOC =V_DV_TRUCTHUOC;
--                  --------------
--                   DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
--                     <span style="color:#045982;font-size: 15px;">+ Ngày hôm nay đã có <b>'||V_COUNT_DADANGKY||' </b>người thực hiện khai báo y tế,
--                     <b> '||V_COUNT_CHUADANGKY||' </b>người chưa thực hiện khai báo y tế trong đơn vị của bạn.</span><br />
--                     ');  
             END IF;
             ------------------
         IF(COUNT_RECORD>0)THEN     
              -----------------    
                SELECT KK.NGAYTAO  INTO V_NGAYTAO FROM (
                     SELECT DD.NGAYTAO FROM COVID_DANGKY DD WHERE DD.CANBOID=V_CANBOID ORDER BY DD.NGAYTAO DESC
                  )KK WHERE ROWNUM=1;
             DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
             <span style="color:#cf2b0e;">+ Ngày hôm nay bạn đã thực hiện khai báo lúc '||TO_CHAR(V_NGAYTAO,'HH24:MI:SS')||'</span>
             ');
          ELSE
            DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
             <span style="color:#cf2b0e;">+ Ngày hôm nay bạn chưa thực hiện khai báo sức khỏe.</span>
             ');  
          END IF;
    ---------
    OPEN V_CURSOR FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT,V_COUNT_DADANGKY DADANGKY,V_COUNT_CHUADANGKY CHUADANGKY FROM dual;
         dbms_lob.freetemporary(V_EXPORT_TEXT);
        dbms_lob.freetemporary(V_EXPORT_TEXT_ITEM);
        RETURN V_CURSOR;  
END CANH_BAO_TK;
END PKG_COVID_APP;
