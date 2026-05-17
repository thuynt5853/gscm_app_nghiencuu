CREATE OR REPLACE PACKAGE BODY GSCM.PKG_DVCQG_VNEID_HS
AS
-- Package body
-- vnpt: hoangndh, sua tong dat quyet dinh so tham vneid an HS, 20/11/2025 10:30:00
PROCEDURE THONGBAO_TONGDAT_VNEID_QD_ST
(
    V_LOAIVUVIEC IN NUMBER,
    V_TONGDAT IN NUMBER,
    V_DOITUONGID IN NUMBER,
    V_FILENAME IN VARCHAR2,
    curReturn OUT SYS_REFCURSOR
) IS
    l_count number;
    l_blob       BLOB;
    l_filename   VARCHAR2 (200);

     MinIndex	number;V_LOAITOA VARCHAR2(150):=NULL; VV_DATE_FROM VARCHAR2(150):=NULL;VV_DATE_TO VARCHAR2(150):=NULL;
      MaxIndex	number;var_arrsx  varchar2(250); V_EXPORT_TEXT CLOB; 
      v_cursor SYS_REFCURSOR;v_table T_DVCQG_VNEID;V_STT number:=0;

      l_date_from  DATE;
    l_MaLoaiTB varchar2(100);
    v_cursor_pdf SYS_REFCURSOR;
BEGIN  

    DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
    v_table := T_DVCQG_VNEID(); --dung bang ding nghia

  -----------------------

     l_MaLoaiTB := 'TBTA';
 IF (V_LOAIVUVIEC = 1) THEN
     FOR item_tp IN 
            (
                    SELECT 
                        TD.ID
                        ,TD.NGAYTAO
                        ,QD.SOQUYETDINH||'/TB-TA' as SOTHONGBAO
                        ,TD.URL_FILE
                        ,BM.MABM||'.'||BM.TENBM as TENTHONGBAO
                    ,VA.TOAANID as MACOQUANGUI,TN.MA_TEN as TENTOAAN,PKG_NOTINUMBER_VIEID.GEN_NOTINUMBER_CODE('HS') AS MATHONGBAO
                    ,QD.NGAYQD as NGAYBANHANHTHONGBAO
                    ,DTA.SO_CCCD as SODINHDANHCONGDAN,DTA.TENDUONGSU,'Hình sự' as LOAIAN,'HS.'||DTA.ID as MaTB_VNEID
                     FROM AHS_TONGDAT TD 
                     INNER JOIN (SELECT DT.id,DT.tongdatid,BCBC.SO_CCCD, BCBC.HOTEN TENDUONGSU
                            ,BCBC.ID AS DUONGSUID,BCBC.TAMTRU,DT.NGAYPHATHANH_HETHONG FROM AHS_TONGDAT_DOITUONG DT 
                                                    LEFT JOIN AHS_BICANBICAO BCBC ON DT.DUONGSUID = BCBC.ID
                                                    where DT.TRANGTHAI = 1 and NVL(DT.DUONGSUID,0) >0 )DTA ON dta.tongdatid =td.id
                    INNER JOIN AHS_VUAN VA ON TD.VUANID=VA.ID     
                    INNER JOIN DM_TOAAN TN ON TN.ID=VA.TOAANID
                    INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
--                    LEFT JOIN AHS_ANPHI AI ON DTA.DUONGSUID=AI.DUONGSU_ID

                    LEFT JOIN DM_HANHCHINH HC ON DTA.TAMTRU=HC.ID
--                    LEFT JOIN AHS_FILE FL ON FL.id=TD.FILEID --AND FL.BIEUMAUID=67
                    INNER JOIN AHS_SOTHAM_QUYETDINH_VUAN QD ON QD.ID = TD.MAPID
/*                    LEFT JOIN DVCQG_THANH_TOAN TT ON tt.DUONGSU_ID=AI.DUONGSU_ID AND TT.ANPHI_ID=AI.ID AND TT.MALOAIVUVIEC='2'
                    LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID*/
--                    WHERE DTA.TUCACHTOTUNG_MA IN('NGUYENDON', 'BIDON') 
                    AND TD.URL_FILE is not NULL
                    --AND TD.BIEUMAUID IN(67,381) --Thông báo nộp tiền tạm ứng án phí    
                    AND DTA.ID = V_DOITUONGID 
                    AND TD.id = V_TONGDAT
                )
            LOOP
                v_table.extend;
                v_table(v_table.count) := R_DVCQG_VNEID(
                 item_tp.id,item_tp.NGAYTAO,l_MaLoaiTB,item_tp.MaTB_VNEID, item_tp.URL_FILE,item_tp.TENTHONGBAO
                ,item_tp.MACOQUANGUI,item_tp.TENTOAAN,item_tp.SOTHONGBAO,item_tp.NGAYBANHANHTHONGBAO,item_tp.SODINHDANHCONGDAN
                ,item_tp.TENDUONGSU,item_tp.LOAIAN,item_tp.MATHONGBAO);
            END LOOP;

 END IF;


     OPEN curReturn FOR
            select DS.* from (

                SELECT 
                    TP.TONGDAT_ID as "tongdatId"
                    ,'TBTA' as "notiTypeCode"
                    ,TP.TENTHONGBAO as "notiName"
                    ,TP.MATHONGBAO as "notiNumber"
                    ,TP.MACOQUANGUI as "sendPlaceCode"
                    ,TP.TENTOAAN as "sendPlaceName"
                    ,TP.SODINHDANHCONGDAN  as "citizenNumber"
                    ,TP.TENDUONGSU AS "citizenName"
                    ,TP.LOAIAN as "area"
                    -- vnpt 291025 update gui thong tin documentNumber
                    ,TP.SOTHONGBAO as "documentNumber"
                    ,TO_CHAR(TP.NGAYBANHANHTHONGBAO, 'yyyy-MM-dd') as "publishDate"  
                    ,TP.FILEID as "fileId"
                    ,V_FILENAME as "fileName"
                    ,'["'|| TP.LOAIAN || '", ""]' AS  "note"
                    FROM TABLE(v_table) TP 
                    WHERE 
                         LENGTH(trim(TP.SODINHDANHCONGDAN))  = 12 
                         -- AND TP.MATHONGBAO = '9TN7RG3H66'
            ) DS 
            --WHERE DS.STT>=MININDEX AND DS.STT<=MAXINDEX
            ;


END THONGBAO_TONGDAT_VNEID_QD_ST;

-- vnpt: hoangndh, sua tong dat quyet dinh ban an vneid an HS, 20/11/2025 10:30:00
PROCEDURE THONGBAO_TONGDAT_VNEID_BANAN_ST
(
    V_LOAIVUVIEC IN NUMBER,
    V_TONGDAT IN NUMBER,
    V_DOITUONGID IN NUMBER,
    V_FILENAME IN VARCHAR2,
    curReturn OUT SYS_REFCURSOR
) IS
    l_count number;
    l_blob       BLOB;
    l_filename   VARCHAR2 (200);

     MinIndex	number;V_LOAITOA VARCHAR2(150):=NULL; VV_DATE_FROM VARCHAR2(150):=NULL;VV_DATE_TO VARCHAR2(150):=NULL;
      MaxIndex	number;var_arrsx  varchar2(250); V_EXPORT_TEXT CLOB; 
      v_cursor SYS_REFCURSOR;v_table T_DVCQG_VNEID;V_STT number:=0;

      l_date_from  DATE;
    l_MaLoaiTB varchar2(100);
    v_cursor_pdf SYS_REFCURSOR;
BEGIN  

    DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
    v_table := T_DVCQG_VNEID(); --dung bang ding nghia

  -----------------------

     l_MaLoaiTB := 'TBTA';
 IF (V_LOAIVUVIEC = 1) THEN
     FOR item_tp IN 
            (
                    SELECT 
                        TD.ID
                        ,TD.NGAYTAO
                        ,BA.SOBANAN||'/TB-TA' as SOTHONGBAO
                        ,TD.URL_FILE
                        ,BM.MABM||'.'||BM.TENBM as TENTHONGBAO
                    ,DO.TOAANID as MACOQUANGUI,TN.MA_TEN as TENTOAAN,PKG_NOTINUMBER_VIEID.GEN_NOTINUMBER_CODE('HS') AS MATHONGBAO
                    ,BA.NGAYBANAN as NGAYBANHANHTHONGBAO
                    ,DTA.SO_CCCD as SODINHDANHCONGDAN,DTA.TENDUONGSU,'Hình sự' as LOAIAN,'HS.'||DTA.ID as MaTB_VNEID
                     FROM AHS_TONGDAT TD 
                     INNER JOIN (SELECT DT.id,DT.tongdatid,BCBC.SO_CCCD, BCBC.HOTEN TENDUONGSU
                            ,BCBC.ID AS DUONGSUID,BCBC.TAMTRU,DT.NGAYPHATHANH_HETHONG FROM AHS_TONGDAT_DOITUONG DT 
                                                    LEFT JOIN AHS_BICANBICAO BCBC ON DT.DUONGSUID = BCBC.ID
                                                    where DT.TRANGTHAI = 1 and NVL(DT.DUONGSUID,0) >0 )DTA ON dta.tongdatid =td.id
                    INNER JOIN AHS_VUAN DO ON TD.VUANID=DO.ID     
                    INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                    INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
--                    LEFT JOIN AHS_ANPHI AI ON DTA.DUONGSUID=AI.DUONGSU_ID

                    LEFT JOIN DM_HANHCHINH HC ON DTA.TAMTRU=HC.ID
--                    LEFT JOIN AHS_FILE FL ON FL.id=TD.FILEID --AND FL.BIEUMAUID=67
                    INNER JOIN AHS_SOTHAM_BANAN BA ON BA.ID = TD.MAPID
/*                    LEFT JOIN DVCQG_THANH_TOAN TT ON tt.DUONGSU_ID=AI.DUONGSU_ID AND TT.ANPHI_ID=AI.ID AND TT.MALOAIVUVIEC='2'
                    LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID*/
--                    WHERE DTA.TUCACHTOTUNG_MA IN('NGUYENDON', 'BIDON') 
                    AND TD.URL_FILE is not NULL
                    --AND TD.BIEUMAUID IN(67,381) --Thông báo nộp tiền tạm ứng án phí    
                    AND DTA.ID = V_DOITUONGID 
                    AND TD.id = V_TONGDAT
                )
            LOOP
                v_table.extend;
                v_table(v_table.count) := R_DVCQG_VNEID(
                 item_tp.id,item_tp.NGAYTAO,l_MaLoaiTB,item_tp.MaTB_VNEID, item_tp.URL_FILE,item_tp.TENTHONGBAO
                ,item_tp.MACOQUANGUI,item_tp.TENTOAAN,item_tp.SOTHONGBAO,item_tp.NGAYBANHANHTHONGBAO,item_tp.SODINHDANHCONGDAN
                ,item_tp.TENDUONGSU,item_tp.LOAIAN,item_tp.MATHONGBAO);
            END LOOP;

 END IF;


     OPEN curReturn FOR
            select DS.* from (

                SELECT 
                    TP.TONGDAT_ID as "tongdatId"
                    ,'TBTA' as "notiTypeCode"
                    ,TP.TENTHONGBAO as "notiName"
                    ,TP.MATHONGBAO as "notiNumber"
                    ,TP.MACOQUANGUI as "sendPlaceCode"
                    ,TP.TENTOAAN as "sendPlaceName"
                    ,TP.SODINHDANHCONGDAN  as "citizenNumber"
                    ,TP.TENDUONGSU AS "citizenName"
                    ,TP.LOAIAN as "area"
                    -- vnpt 291025 update gui thong tin documentNumber
                    ,TP.SOTHONGBAO as "documentNumber"
                    ,TO_CHAR(TP.NGAYBANHANHTHONGBAO, 'yyyy-MM-dd') as "publishDate"  
                    ,TP.FILEID as "fileId"
                    ,V_FILENAME as "fileName"
                    ,'["'|| TP.LOAIAN || '", ""]' AS  "note"
                    FROM TABLE(v_table) TP 
                    WHERE 
                         LENGTH(trim(TP.SODINHDANHCONGDAN))  = 12 
                         -- AND TP.MATHONGBAO = '9TN7RG3H66'
            ) DS 
            --WHERE DS.STT>=MININDEX AND DS.STT<=MAXINDEX
            ;


END THONGBAO_TONGDAT_VNEID_BANAN_ST;

-- vnpt: hoangndh, sua tong dat quyet dinh phuc tham vneid an HS, 20/11/2025 10:30:00
PROCEDURE THONGBAO_TONGDAT_VNEID_QD_PT
(
    V_LOAIVUVIEC IN NUMBER,
    V_TONGDAT IN NUMBER,
    V_DOITUONGID IN NUMBER,
    V_FILENAME IN VARCHAR2,
    curReturn OUT SYS_REFCURSOR
) IS
    l_count number;
    l_blob       BLOB;
    l_filename   VARCHAR2 (200);

     MinIndex	number;V_LOAITOA VARCHAR2(150):=NULL; VV_DATE_FROM VARCHAR2(150):=NULL;VV_DATE_TO VARCHAR2(150):=NULL;
      MaxIndex	number;var_arrsx  varchar2(250); V_EXPORT_TEXT CLOB; 
      v_cursor SYS_REFCURSOR;v_table T_DVCQG_VNEID;V_STT number:=0;

      l_date_from  DATE;
    l_MaLoaiTB varchar2(100);
    v_cursor_pdf SYS_REFCURSOR;
BEGIN  

    DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
    v_table := T_DVCQG_VNEID(); --dung bang ding nghia

  -----------------------

     l_MaLoaiTB := 'TBTA';
 IF (V_LOAIVUVIEC = 1) THEN
     FOR item_tp IN 
            (
                    SELECT 
                        TD.ID
                        ,TD.NGAYTAO
                        ,QD.SOQUYETDINH||'/TB-TA' as SOTHONGBAO
                        ,TD.URL_FILE
                        ,BM.MABM||'.'||BM.TENBM as TENTHONGBAO
                    ,DO.TOAPHUCTHAMID as MACOQUANGUI,TN.MA_TEN as TENTOAAN,PKG_NOTINUMBER_VIEID.GEN_NOTINUMBER_CODE('HS') AS MATHONGBAO
                    ,QD.NGAYQD as NGAYBANHANHTHONGBAO
                    ,DTA.SO_CCCD as SODINHDANHCONGDAN,DTA.TENDUONGSU,'Hình sự' as LOAIAN,'HS.'||DTA.ID as MaTB_VNEID
                     FROM AHS_TONGDAT TD 
                     INNER JOIN (SELECT DT.id,DT.tongdatid,BCBC.SO_CCCD, BCBC.HOTEN TENDUONGSU
                            ,BCBC.ID AS DUONGSUID,BCBC.TAMTRU,DT.NGAYPHATHANH_HETHONG FROM AHS_TONGDAT_DOITUONG DT 
                                                    LEFT JOIN AHS_BICANBICAO BCBC ON DT.DUONGSUID = BCBC.ID
                                                    where DT.TRANGTHAI = 1 and NVL(DT.DUONGSUID,0) >0 )DTA ON dta.tongdatid =td.id
                    INNER JOIN AHS_VUAN DO ON TD.VUANID=DO.ID     
                    INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAPHUCTHAMID
                    INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
--                    LEFT JOIN AHS_ANPHI AI ON DTA.DUONGSUID=AI.DUONGSU_ID

                    LEFT JOIN DM_HANHCHINH HC ON DTA.TAMTRU=HC.ID
--                    LEFT JOIN AHS_FILE FL ON FL.id=TD.FILEID --AND FL.BIEUMAUID=67
                    INNER JOIN AHS_PHUCTHAM_QUYETDINH_VUAN QD ON QD.ID = TD.MAPID
/*                    LEFT JOIN DVCQG_THANH_TOAN TT ON tt.DUONGSU_ID=AI.DUONGSU_ID AND TT.ANPHI_ID=AI.ID AND TT.MALOAIVUVIEC='2'
                    LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID*/
--                    WHERE DTA.TUCACHTOTUNG_MA IN('NGUYENDON', 'BIDON') 
                    AND TD.URL_FILE is not NULL
                    --AND TD.BIEUMAUID IN(67,381) --Thông báo nộp tiền tạm ứng án phí    
                    AND DTA.ID = V_DOITUONGID 
                    AND TD.id = V_TONGDAT
                )
            LOOP
                v_table.extend;
                v_table(v_table.count) := R_DVCQG_VNEID(
                 item_tp.id,item_tp.NGAYTAO,l_MaLoaiTB,item_tp.MaTB_VNEID, item_tp.URL_FILE,item_tp.TENTHONGBAO
                ,item_tp.MACOQUANGUI,item_tp.TENTOAAN,item_tp.SOTHONGBAO,item_tp.NGAYBANHANHTHONGBAO,item_tp.SODINHDANHCONGDAN
                ,item_tp.TENDUONGSU,item_tp.LOAIAN,item_tp.MATHONGBAO);
            END LOOP;

 END IF;


     OPEN curReturn FOR
            select DS.* from (

                SELECT 
                    TP.TONGDAT_ID as "tongdatId"
                    ,'TBTA' as "notiTypeCode"
                    ,TP.TENTHONGBAO as "notiName"
                    ,TP.MATHONGBAO as "notiNumber"
                    ,TP.MACOQUANGUI as "sendPlaceCode"
                    ,TP.TENTOAAN as "sendPlaceName"
                    ,TP.SODINHDANHCONGDAN  as "citizenNumber"
                    ,TP.TENDUONGSU AS "citizenName"
                    ,TP.LOAIAN as "area"
                    -- vnpt 291025 update gui thong tin documentNumber
                    ,TP.SOTHONGBAO as "documentNumber"
                    ,TO_CHAR(TP.NGAYBANHANHTHONGBAO, 'yyyy-MM-dd') as "publishDate"  
                    ,TP.FILEID as "fileId"
                    ,V_FILENAME as "fileName"
                    ,'["'|| TP.LOAIAN || '", ""]' AS  "note"
                    FROM TABLE(v_table) TP 
                    WHERE 
                         LENGTH(trim(TP.SODINHDANHCONGDAN))  = 12 
                         -- AND TP.MATHONGBAO = '9TN7RG3H66'
            ) DS 
            --WHERE DS.STT>=MININDEX AND DS.STT<=MAXINDEX
            ;


END THONGBAO_TONGDAT_VNEID_QD_PT;

-- vnpt: hoangndh, sua tong dat quyet dinh ban an vneid an HS, 20/11/2025 10:30:00
PROCEDURE THONGBAO_TONGDAT_VNEID_BANAN_PT
(
    V_LOAIVUVIEC IN NUMBER,
    V_TONGDAT IN NUMBER,
    V_DOITUONGID IN NUMBER,
    V_FILENAME IN VARCHAR2,
    curReturn OUT SYS_REFCURSOR
) IS
    l_count number;
    l_blob       BLOB;
    l_filename   VARCHAR2 (200);

     MinIndex	number;V_LOAITOA VARCHAR2(150):=NULL; VV_DATE_FROM VARCHAR2(150):=NULL;VV_DATE_TO VARCHAR2(150):=NULL;
      MaxIndex	number;var_arrsx  varchar2(250); V_EXPORT_TEXT CLOB; 
      v_cursor SYS_REFCURSOR;v_table T_DVCQG_VNEID;V_STT number:=0;

      l_date_from  DATE;
    l_MaLoaiTB varchar2(100);
    v_cursor_pdf SYS_REFCURSOR;
BEGIN  

    DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
    v_table := T_DVCQG_VNEID(); --dung bang ding nghia

  -----------------------

     l_MaLoaiTB := 'TBTA';
 IF (V_LOAIVUVIEC = 1) THEN
     FOR item_tp IN 
            (
                    SELECT 
                        TD.ID
                        ,TD.NGAYTAO
                        ,BA.SOBANAN||'/TB-TA' as SOTHONGBAO
                        ,TD.URL_FILE
                        ,BM.MABM||'.'||BM.TENBM as TENTHONGBAO
                    ,DO.TOAPHUCTHAMID as MACOQUANGUI,TN.MA_TEN as TENTOAAN,PKG_NOTINUMBER_VIEID.GEN_NOTINUMBER_CODE('HS') AS MATHONGBAO
                    ,BA.NGAYBANAN as NGAYBANHANHTHONGBAO
                    ,DTA.SO_CCCD as SODINHDANHCONGDAN,DTA.TENDUONGSU,'Hình sự' as LOAIAN,'HS.'||DTA.ID as MaTB_VNEID
                     FROM AHS_TONGDAT TD 
                     INNER JOIN (SELECT DT.id,DT.tongdatid,BCBC.SO_CCCD, BCBC.HOTEN TENDUONGSU
                            ,BCBC.ID AS DUONGSUID,BCBC.TAMTRU,DT.NGAYPHATHANH_HETHONG FROM AHS_TONGDAT_DOITUONG DT 
                                                    LEFT JOIN AHS_BICANBICAO BCBC ON DT.DUONGSUID = BCBC.ID
                                                    where DT.TRANGTHAI = 1 and NVL(DT.DUONGSUID,0) >0 )DTA ON dta.tongdatid =td.id
                    INNER JOIN AHS_VUAN DO ON TD.VUANID=DO.ID     
                    INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAPHUCTHAMID
                    INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
--                    LEFT JOIN AHS_ANPHI AI ON DTA.DUONGSUID=AI.DUONGSU_ID

                    LEFT JOIN DM_HANHCHINH HC ON DTA.TAMTRU=HC.ID
--                    LEFT JOIN AHS_FILE FL ON FL.id=TD.FILEID --AND FL.BIEUMAUID=67
                    INNER JOIN AHS_PHUCTHAM_BANAN BA ON BA.ID = TD.MAPID
/*                    LEFT JOIN DVCQG_THANH_TOAN TT ON tt.DUONGSU_ID=AI.DUONGSU_ID AND TT.ANPHI_ID=AI.ID AND TT.MALOAIVUVIEC='2'
                    LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID*/
--                    WHERE DTA.TUCACHTOTUNG_MA IN('NGUYENDON', 'BIDON') 
                    AND TD.URL_FILE is not NULL
                    --AND TD.BIEUMAUID IN(67,381) --Thông báo nộp tiền tạm ứng án phí    
                    AND DTA.ID = V_DOITUONGID 
                    AND TD.id = V_TONGDAT
                )
            LOOP
                v_table.extend;
                v_table(v_table.count) := R_DVCQG_VNEID(
                 item_tp.id,item_tp.NGAYTAO,l_MaLoaiTB,item_tp.MaTB_VNEID, item_tp.URL_FILE,item_tp.TENTHONGBAO
                ,item_tp.MACOQUANGUI,item_tp.TENTOAAN,item_tp.SOTHONGBAO,item_tp.NGAYBANHANHTHONGBAO,item_tp.SODINHDANHCONGDAN
                ,item_tp.TENDUONGSU,item_tp.LOAIAN,item_tp.MATHONGBAO);
            END LOOP;

 END IF;


     OPEN curReturn FOR
            select DS.* from (

                SELECT 
                    TP.TONGDAT_ID as "tongdatId"
                    ,'TBTA' as "notiTypeCode"
                    ,TP.TENTHONGBAO as "notiName"
                    ,TP.MATHONGBAO as "notiNumber"
                    ,TP.MACOQUANGUI as "sendPlaceCode"
                    ,TP.TENTOAAN as "sendPlaceName"
                    ,TP.SODINHDANHCONGDAN  as "citizenNumber"
                    ,TP.TENDUONGSU AS "citizenName"
                    ,TP.LOAIAN as "area"
                    -- vnpt 291025 update gui thong tin documentNumber
                    ,TP.SOTHONGBAO as "documentNumber"
                    ,TO_CHAR(TP.NGAYBANHANHTHONGBAO, 'yyyy-MM-dd') as "publishDate"  
                    ,TP.FILEID as "fileId"
                    ,V_FILENAME as "fileName"
                    ,'["'|| TP.LOAIAN || '", ""]' AS  "note"
                    FROM TABLE(v_table) TP 
                    WHERE 
                         LENGTH(trim(TP.SODINHDANHCONGDAN))  = 12 
                         -- AND TP.MATHONGBAO = '9TN7RG3H66'
            ) DS 
            --WHERE DS.STT>=MININDEX AND DS.STT<=MAXINDEX
            ;


END THONGBAO_TONGDAT_VNEID_BANAN_PT;

END PKG_DVCQG_VNEID_HS;