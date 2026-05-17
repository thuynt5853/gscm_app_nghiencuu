CREATE OR REPLACE PACKAGE BODY GSCM.PKG_DVCQG_VNEID_HC
AS
-- Package body
PROCEDURE THONGBAO_TONGDAT_VNEID_THULY_HC
(
    V_LOAIVUVIEC IN NUMBER,
    V_TONGDAT IN NUMBER,
    V_DOITUONGID IN NUMBER,
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
  IF (V_LOAIVUVIEC = 6) THEN
          FOR item_tp IN 
            (
                        SELECT TD.ID
                                ,TD.NGAYTAO
                                --,TT.MA_THONGBAO||'_'||FL.TENFILE as MATHONGBAO
                                -- vnpt 29102025 update mathongbao
                                ,TL.SOTHONGBAO||'/TB-TA' as SOTHONGBAO
                                ,PKG_NOTINUMBER_VIEID.GEN_NOTINUMBER_CODE('HC') as MATHONGBAO
                                ,TD.URL_FILE,BM.MABM||'.'||BM.TENBM as TENTHONGBAO
                                ,DO.TOAANID as MACOQUANGUI,TN.MA_TEN as TENTOAAN
                               --,DTA.NGAYPHATHANH_HETHONG NGAYBANHANHTHONGBAO
                                --,AI.NGAYTHONGBAO as NGAYBANHANHTHONGBAO
                                ,TL.NGAYTHONGBAO as NGAYBANHANHTHONGBAO
                                ,DTA.SO_CCCD as SODINHDANHCONGDAN,DTA.TENDUONGSU,'Hành chính' as LOAIAN,'HC.'||DTA.ID as MaTB_VNEID
                                 FROM AHC_TONGDAT TD 
                                 INNER JOIN (SELECT DT.id,DT.tongdatid,DS.SO_CCCD, decode(ds.LOAIDUONGSU,2,DS.NGUOIDAIDIEN,3,DS.NGUOIDAIDIEN, DS.TENDUONGSU) TENDUONGSU
                                            ,DS.TUCACHTOTUNG_MA,DS.TAMTRUID,DS.ID AS DUONGSUID,DT.NGAYPHATHANH_HETHONG FROM AHC_TONGDAT_DOITUONG DT 
                                                                LEFT JOIN AHC_DON_DUONGSU DS ON DT.DUONGSUID = DS.ID
                                                                where DT.TRANGTHAI = 1 and NVL(DT.DUONGSUID,0) >0 AND DS.XACTHUC_DLDCQG = 1)DTA ON dta.tongdatid =td.id
                                INNER JOIN AHC_DON DO ON TD.DONID=DO.ID     
                                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                                --LEFT JOIN AHC_ANPHI AI ON ',' || AI.DUONGSU_IDs || ',' LIKE '%,' || TO_CHAR(DTA.DUONGSUID) || ',%'
                            
                                LEFT JOIN DM_HANHCHINH HC ON DTA.TAMTRUID=HC.ID
--                                LEFT JOIN AHC_FILE FL ON FL.id=TD.FILEID --AND FL.BIEUMAUID=123
                                -- vnpt 20251201: map theo mapid tong dat
                                INNER JOIN AHC_SOTHAM_THULY TL ON TL.ID = TD.MAPID 
                                
                                --LEFT JOIN DVCQG_THANH_TOAN TT ON tt.DUONGSU_IDs=AI.DUONGSU_IDs AND TT.ANPHI_ID=AI.ID AND TT.MALOAIVUVIEC='6'
                                --LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                                WHERE
--                                    DTA.TUCACHTOTUNG_MA IN('NGUYENDON', 'BIDON') 
--                                    AND 
                                    TD.URL_FILE is not NULL
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
                    ,'Thông_báo_về_việc_thụ_lý_vụ_án.pdf' as "fileName"
					,'["'|| TP.LOAIAN || '", ""]' AS  "note"
                    FROM TABLE(v_table) TP 
                    WHERE 
                         LENGTH(trim(TP.SODINHDANHCONGDAN))  = 12 
                         -- AND TP.MATHONGBAO = '9TN7RG3H66'
            ) DS 
            --WHERE DS.STT>=MININDEX AND DS.STT<=MAXINDEX
            ;
END THONGBAO_TONGDAT_VNEID_THULY_HC;

-- vnpt: hoangndh, sua tong dat quyet dinh so tham vneid an DS, 14/11/2025 17:30:00
PROCEDURE THONGBAO_TONGDAT_VNEID_QDVUVIEC_ST_HC
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
 IF (V_LOAIVUVIEC = 6) THEN
     FOR item_tp IN 
            (
                    SELECT 
                        TD.ID
                        ,TD.NGAYTAO
                        ,QD.SOQD||'/TB-TA' as SOTHONGBAO
                        ,TD.URL_FILE
                        ,BM.MABM||'.'||BM.TENBM as TENTHONGBAO
                    ,DO.TOAANID as MACOQUANGUI,TN.MA_TEN as TENTOAAN,PKG_NOTINUMBER_VIEID.GEN_NOTINUMBER_CODE('HC') AS MATHONGBAO
                    ,QD.NGAYQD as NGAYBANHANHTHONGBAO
                    ,DTA.SO_CCCD as SODINHDANHCONGDAN,DTA.TENDUONGSU,'Hành chính' as LOAIAN,'HC.'||DTA.ID as MaTB_VNEID
                     FROM AHC_TONGDAT TD 
                     INNER JOIN (SELECT DT.id,DT.tongdatid,DS.SO_CCCD, decode(ds.LOAIDUONGSU,2,DS.NGUOIDAIDIEN,3,DS.NGUOIDAIDIEN, DS.TENDUONGSU) TENDUONGSU
                            ,DS.TUCACHTOTUNG_MA ,DS.TAMTRUID,DS.ID AS DUONGSUID,DT.NGAYPHATHANH_HETHONG FROM AHC_TONGDAT_DOITUONG DT 
                                                    LEFT JOIN AHC_DON_DUONGSU DS ON DT.DUONGSUID = DS.ID
                                                    where DT.TRANGTHAI = 1 and NVL(DT.DUONGSUID,0) >0 AND DS.XACTHUC_DLDCQG = 1 )DTA ON dta.tongdatid =td.id
                    INNER JOIN AHC_DON DO ON TD.DONID=DO.ID     
                    INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                    INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
--                    LEFT JOIN AHC_ANPHI AI ON DTA.DUONGSUID=AI.DUONGSU_ID
                
                    LEFT JOIN DM_HANHCHINH HC ON DTA.TAMTRUID=HC.ID
--                    LEFT JOIN AHC_FILE FL ON FL.id=TD.FILEID --AND FL.BIEUMAUID=67
                    -- vnpt 20251201: map theo mapid tong dat
                    INNER JOIN AHC_SOTHAM_QUYETDINH QD ON QD.ID = TD.MAPID
/*                    LEFT JOIN DVCQG_THANH_TOAN TT ON tt.DUONGSU_ID=AI.DUONGSU_ID AND TT.ANPHI_ID=AI.ID AND TT.MALOAIVUVIEC='2'
                    LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID*/
                    WHERE 
--                    DTA.TUCACHTOTUNG_MA IN('NGUYENDON', 'BIDON') 
--                    AND 
                    TD.URL_FILE is not NULL
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
          

END THONGBAO_TONGDAT_VNEID_QDVUVIEC_ST_HC;

PROCEDURE TONGDAT_VNEID_THULY_PT_HC
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
    v_table := T_DVCQG_VNEID(); 
  
  -----------------------
   
     l_MaLoaiTB := 'TBTA';
 IF (V_LOAIVUVIEC = 6) THEN
     FOR item_tp IN 
            (
                    SELECT 
                        TD.ID
                        ,TD.NGAYTAO
                        ,AL.SOTHONGBAO||'/TB-TA' as SOTHONGBAO
                        ,TD.URL_FILE
                        ,BM.MABM||'.'||BM.TENBM as TENTHONGBAO
                    ,DO.TOAPHUCTHAMID as MACOQUANGUI,TN.MA_TEN as TENTOAAN,PKG_NOTINUMBER_VIEID.GEN_NOTINUMBER_CODE('HC') AS MATHONGBAO
                    ,AL.NGAYTHONGBAO as NGAYBANHANHTHONGBAO
                    ,DTA.SO_CCCD as SODINHDANHCONGDAN,DTA.TENDUONGSU,'Hành chính' as LOAIAN,'HC.'||DTA.ID as MaTB_VNEID
                     FROM AHC_TONGDAT TD 
                     INNER JOIN (SELECT DT.id,DT.tongdatid,DS.SO_CCCD, decode(ds.LOAIDUONGSU,2,DS.NGUOIDAIDIEN,3,DS.NGUOIDAIDIEN, DS.TENDUONGSU) TENDUONGSU
                            ,DS.TUCACHTOTUNG_MA ,DS.TAMTRUID,DS.ID AS DUONGSUID,DT.NGAYPHATHANH_HETHONG FROM AHC_TONGDAT_DOITUONG DT 
                                                    LEFT JOIN AHC_DON_DUONGSU DS ON DT.DUONGSUID = DS.ID
                                                    where DT.TRANGTHAI = 1 and NVL(DT.DUONGSUID,0) >0 AND DS.XACTHUC_DLDCQG = 1 )DTA ON dta.tongdatid =td.id
                    INNER JOIN AHC_DON DO ON TD.DONID=DO.ID     
                    INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAPHUCTHAMID
                    INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                
                    LEFT JOIN DM_HANHCHINH HC ON DTA.TAMTRUID=HC.ID
--                    LEFT JOIN AHC_FILE FL ON FL.id=TD.FILEID 
--                    
--                    LEFT JOIN AHC_FILE AF ON AF.DONID = TD.DONID AND TD.BIEUMAUID = AF.BIEUMAUID 
                    -- vnpt 20251201: map theo mapid tong dat
                    INNER JOIN AHC_PHUCTHAM_THULY AL ON AL.ID = TD.MAPID

                    WHERE 
--                    DTA.TUCACHTOTUNG_MA IN('NGUYENDON', 'BIDON') 
--                    AND 
                    TD.URL_FILE is not NULL

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

                    ,TP.SOTHONGBAO as "documentNumber"
                    ,TO_CHAR(TP.NGAYBANHANHTHONGBAO, 'yyyy-MM-dd') as "publishDate"  
                    ,TP.FILEID as "fileId"
                    ,V_FILENAME as "fileName"
                    ,'["'|| TP.LOAIAN || '", ""]' AS  "note"
                    FROM TABLE(v_table) TP 
                    WHERE 
                         LENGTH(trim(TP.SODINHDANHCONGDAN))  = 12 

            ) DS 

            ;
          
END TONGDAT_VNEID_THULY_PT_HC;

-- vnpt: hoangndh, sua tong dat quyet dinh phuc tham vneid an HC, 18/11/2025 10:30:00
PROCEDURE THONGBAO_TONGDAT_VNEID_QDVUVIEC_PT_HC
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
 IF (V_LOAIVUVIEC = 6) THEN
     FOR item_tp IN 
            (
                    SELECT 
                        TD.ID
                        ,TD.NGAYTAO
                        ,QD.SOQD||'/TB-TA' as SOTHONGBAO
                        ,TD.URL_FILE
                        ,BM.MABM||'.'||BM.TENBM as TENTHONGBAO
                    ,DO.TOAPHUCTHAMID as MACOQUANGUI,TN.MA_TEN as TENTOAAN,PKG_NOTINUMBER_VIEID.GEN_NOTINUMBER_CODE('HC') AS MATHONGBAO
                    ,QD.NGAYQD as NGAYBANHANHTHONGBAO
                    ,DTA.SO_CCCD as SODINHDANHCONGDAN,DTA.TENDUONGSU,'Hành chính' as LOAIAN,'HC.'||DTA.ID as MaTB_VNEID
                     FROM AHC_TONGDAT TD 
                     INNER JOIN (SELECT DT.id,DT.tongdatid,DS.SO_CCCD, decode(ds.LOAIDUONGSU,2,DS.NGUOIDAIDIEN,3,DS.NGUOIDAIDIEN, DS.TENDUONGSU) TENDUONGSU
                            ,DS.TUCACHTOTUNG_MA ,DS.TAMTRUID,DS.ID AS DUONGSUID,DT.NGAYPHATHANH_HETHONG FROM AHC_TONGDAT_DOITUONG DT 
                                                    LEFT JOIN AHC_DON_DUONGSU DS ON DT.DUONGSUID = DS.ID
                                                    where DT.TRANGTHAI = 1 and NVL(DT.DUONGSUID,0) >0 AND DS.XACTHUC_DLDCQG = 1)DTA ON dta.tongdatid =td.id
                    INNER JOIN AHC_DON DO ON TD.DONID=DO.ID     
                    INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAPHUCTHAMID
                    INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
--                    LEFT JOIN AHC_ANPHI AI ON DTA.DUONGSUID=AI.DUONGSU_ID
                
                    LEFT JOIN DM_HANHCHINH HC ON DTA.TAMTRUID=HC.ID
--                    LEFT JOIN AHC_FILE FL ON FL.id=TD.FILEID --AND FL.BIEUMAUID=67
                    -- vnpt 20251201: map theo mapid tong dat
                    INNER JOIN AHC_PHUCTHAM_QUYETDINH QD ON QD.ID = TD.MAPID
/*                    LEFT JOIN DVCQG_THANH_TOAN TT ON tt.DUONGSU_ID=AI.DUONGSU_ID AND TT.ANPHI_ID=AI.ID AND TT.MALOAIVUVIEC='2'
                    LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID*/
                    WHERE 
--                    DTA.TUCACHTOTUNG_MA IN('NGUYENDON', 'BIDON') 
--                    AND 
                    TD.URL_FILE is not NULL
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
          

END THONGBAO_TONGDAT_VNEID_QDVUVIEC_PT_HC;

-- vnpt: hoangndh, sua phat hanh ban an vneid an HC, 18/11/2025 10:30:00
PROCEDURE THONGBAO_TONGDAT_VNEID_BANAN_PT_HC
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
 IF (V_LOAIVUVIEC = 6) THEN
     FOR item_tp IN 
            (
                    SELECT 
                        TD.ID
                        ,TD.NGAYTAO
                        ,BA.SOBANAN||'/TB-TA' as SOTHONGBAO
                        ,TD.URL_FILE
                        ,BM.MABM||'.'||BM.TENBM as TENTHONGBAO
                    ,DO.TOAPHUCTHAMID as MACOQUANGUI,TN.MA_TEN as TENTOAAN,PKG_NOTINUMBER_VIEID.GEN_NOTINUMBER_CODE('HC') AS MATHONGBAO
                    ,BA.NGAYTUYENAN as NGAYBANHANHTHONGBAO
                    ,DTA.SO_CCCD as SODINHDANHCONGDAN,DTA.TENDUONGSU,'Hành chính' as LOAIAN,'HC.'||DTA.ID as MaTB_VNEID
                     FROM AHC_TONGDAT TD 
                     INNER JOIN (SELECT DT.id,DT.tongdatid,DS.SO_CCCD, decode(ds.LOAIDUONGSU,2,DS.NGUOIDAIDIEN,3,DS.NGUOIDAIDIEN, DS.TENDUONGSU) TENDUONGSU
                            ,DS.TUCACHTOTUNG_MA ,DS.TAMTRUID,DS.ID AS DUONGSUID,DT.NGAYPHATHANH_HETHONG FROM AHC_TONGDAT_DOITUONG DT 
                                                    LEFT JOIN AHC_DON_DUONGSU DS ON DT.DUONGSUID = DS.ID
                                                    where DT.TRANGTHAI = 1 and NVL(DT.DUONGSUID,0) >0 AND DS.XACTHUC_DLDCQG = 1 )DTA ON dta.tongdatid =td.id
                    INNER JOIN AHC_DON DO ON TD.DONID=DO.ID     
                    INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAPHUCTHAMID
                    INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
--                    LEFT JOIN AHC_ANPHI AI ON DTA.DUONGSUID=AI.DUONGSU_ID
                
                    LEFT JOIN DM_HANHCHINH HC ON DTA.TAMTRUID=HC.ID
--                    LEFT JOIN AHC_FILE FL ON FL.id=TD.FILEID --AND FL.BIEUMAUID=67
                    -- vnpt 20251201: map theo mapid tong dat
                    INNER JOIN AHC_PHUCTHAM_BANAN BA ON BA.DONID = TD.DONID
/*                    LEFT JOIN DVCQG_THANH_TOAN TT ON tt.DUONGSU_ID=AI.DUONGSU_ID AND TT.ANPHI_ID=AI.ID AND TT.MALOAIVUVIEC='2'
                    LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID*/
                    WHERE 
--                    DTA.TUCACHTOTUNG_MA IN('NGUYENDON', 'BIDON') 
--                    AND 
                    TD.URL_FILE is not NULL
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
          

END THONGBAO_TONGDAT_VNEID_BANAN_PT_HC;


--vnpt/quanvv TONG DAT THONG TIN DON
PROCEDURE TONGDAT_VNEID_THONGTINDON_HC
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
    v_table := T_DVCQG_VNEID(); 
  
  -----------------------
   
     l_MaLoaiTB := 'TBTA';
 IF (V_LOAIVUVIEC = 6) THEN
     FOR item_tp IN 
            (
                    SELECT 
                        TD.ID
                        ,TD.NGAYTAO
                        ,'' as SOTHONGBAO -- HIện tại chưa có trường số thông báo dùng tạm cái này
                        ,TD.URL_FILE
                        ,BM.MABM||'.'||BM.TENBM as TENTHONGBAO
                    ,DO.TOAANID as MACOQUANGUI,TN.MA_TEN as TENTOAAN,PKG_NOTINUMBER_VIEID.GEN_NOTINUMBER_CODE('HC') AS MATHONGBAO
                    ,DO.NGAYNHANDON as NGAYBANHANHTHONGBAO -- HIện tại chưa có trường ngày này
                    ,DTA.SO_CCCD as SODINHDANHCONGDAN,DTA.TENDUONGSU,'Hành chính' as LOAIAN,'HC.'||DTA.ID as MaTB_VNEID
                     FROM AHC_TONGDAT TD 
                     INNER JOIN (SELECT DT.id,DT.tongdatid,HC.SO_CCCD, decode(HC.LOAIDUONGSU,2,HC.NGUOIDAIDIEN,3,HC.NGUOIDAIDIEN, HC.TENDUONGSU) TENDUONGSU
                            ,HC.TUCACHTOTUNG_MA ,HC.TAMTRUID,HC.ID AS DUONGSUID,DT.NGAYPHATHANH_HETHONG FROM AHC_TONGDAT_DOITUONG DT 
                                                    LEFT JOIN AHC_DON_DUONGSU HC ON DT.DUONGSUID = HC.ID
                                                    where DT.TRANGTHAI = 1 and NVL(DT.DUONGSUID,0) >0 AND HC.XACTHUC_DLDCQG = 1 )DTA ON dta.tongdatid =td.id
                    INNER JOIN AHC_DON DO ON TD.DONID=DO.ID     
                    INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                    INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                
                    LEFT JOIN DM_HANHCHINH HC ON DTA.TAMTRUID=HC.ID
--                    LEFT JOIN AHC_FILE FL ON FL.id=TD.FILEID 

                    WHERE 
--                    DTA.TUCACHTOTUNG_MA IN('NGUYENDON', 'BIDON') 
--                    AND 
                    TD.URL_FILE is not NULL

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
            select HC.* from (
                
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
                    ,TP.SOTHONGBAO as "documentNumber"
                    ,TO_CHAR(TP.NGAYBANHANHTHONGBAO, 'yyyy-MM-dd') as "publishDate"  
                    ,TP.FILEID as "fileId"
                    ,V_FILENAME as "fileName"
                    ,'["'|| TP.LOAIAN || '", ""]' AS  "note"
                    FROM TABLE(v_table) TP 
                    WHERE 
                         LENGTH(trim(TP.SODINHDANHCONGDAN))  = 12 

            ) HC 
            ;
END TONGDAT_VNEID_THONGTINDON_HC;


-- VNPT quanvv GIAI QUYETDON
PROCEDURE TONGDAT_VNEID_GIAIQUYETDON_HC
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
    v_table := T_DVCQG_VNEID(); 
  
  -----------------------
   
     l_MaLoaiTB := 'TBTA';
 IF (V_LOAIVUVIEC = 6) THEN
     FOR item_tp IN 
            (
                    SELECT 
                        TD.ID
                        ,TD.NGAYTAO
                        ,XL.SOTHONGBAO||'/TB-TA' as SOTHONGBAO
                        ,TD.URL_FILE
                        ,BM.MABM||'.'||BM.TENBM as TENTHONGBAO
                    ,DO.TOAANID as MACOQUANGUI,TN.MA_TEN as TENTOAAN,PKG_NOTINUMBER_VIEID.GEN_NOTINUMBER_CODE('HC') AS MATHONGBAO
                    ,XL.NGAYTHONGBAO as NGAYBANHANHTHONGBAO
                    ,DTA.SO_CCCD as SODINHDANHCONGDAN,DTA.TENDUONGSU,'Hành chính' as LOAIAN,'HC.'||DTA.ID as MaTB_VNEID
                     FROM AHC_TONGDAT TD 
                     INNER JOIN (SELECT DT.id,DT.tongdatid,HC.SO_CCCD, decode(HC.LOAIDUONGSU,2,HC.NGUOIDAIDIEN,3,HC.NGUOIDAIDIEN, HC.TENDUONGSU) TENDUONGSU
                            ,HC.TUCACHTOTUNG_MA ,HC.TAMTRUID,HC.ID AS DUONGSUID,DT.NGAYPHATHANH_HETHONG FROM AHC_TONGDAT_DOITUONG DT 
                                                    LEFT JOIN AHC_DON_DUONGSU HC ON DT.DUONGSUID = HC.ID
                                                    where DT.TRANGTHAI = 1 and NVL(DT.DUONGSUID,0) >0 AND HC.XACTHUC_DLDCQG = 1 )DTA ON dta.tongdatid =td.id
                    INNER JOIN AHC_DON DO ON TD.DONID=DO.ID     
                    INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                    INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID

                
                    LEFT JOIN DM_HANHCHINH HC ON DTA.TAMTRUID=HC.ID
--                    LEFT JOIN AHC_FILE FL ON FL.id=TD.FILEID 
--                    
--                    LEFT JOIN AHC_FILE AF ON AF.DONID = TD.DONID AND TD.BIEUMAUID = AF.BIEUMAUID 
                    INNER JOIN AHC_DON_XULY XL ON XL.ID = TD.MAPID

                    WHERE 
--                    DTA.TUCACHTOTUNG_MA IN('NGUYENDON', 'BIDON') 
--                    AND 
                    TD.URL_FILE is not NULL
                    
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
            select HC.* from (
                
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
            ) HC 
            ;
          
END TONGDAT_VNEID_GIAIQUYETDON_HC;


PROCEDURE TONGDAT_VNEID_BANAN_HC
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
 IF (V_LOAIVUVIEC = 6) THEN
     FOR item_tp IN 
            (
                    SELECT 
                        TD.ID
                        ,TD.NGAYTAO
                        ,BA.SOBANAN||'/TB-TA' as SOTHONGBAO
                        ,TD.URL_FILE
                        ,BM.MABM||'.'||BM.TENBM as TENTHONGBAO
                    ,DO.TOAANID as MACOQUANGUI,TN.MA_TEN as TENTOAAN,PKG_NOTINUMBER_VIEID.GEN_NOTINUMBER_CODE('HC') AS MATHONGBAO
                    ,BA.NGAYTUYENAN as NGAYBANHANHTHONGBAO
                    ,DTA.SO_CCCD as SODINHDANHCONGDAN,DTA.TENDUONGSU,'Hành chính' as LOAIAN,'HC.'||DTA.ID as MaTB_VNEID
                     FROM AHC_TONGDAT TD 
                     INNER JOIN (SELECT DT.id,DT.tongdatid,HC.SO_CCCD, decode(HC.LOAIDUONGSU,2,HC.NGUOIDAIDIEN,3,HC.NGUOIDAIDIEN, HC.TENDUONGSU) TENDUONGSU
                            ,HC.TUCACHTOTUNG_MA ,HC.TAMTRUID,HC.ID AS DUONGSUID,DT.NGAYPHATHANH_HETHONG FROM AHC_TONGDAT_DOITUONG DT 
                                                    LEFT JOIN AHC_DON_DUONGSU HC ON DT.DUONGSUID = HC.ID
                                                    where DT.TRANGTHAI = 1 and NVL(DT.DUONGSUID,0) >0 AND HC.XACTHUC_DLDCQG = 1 )DTA ON dta.tongdatid =td.id
                    INNER JOIN AHC_DON DO ON TD.DONID=DO.ID     
                    INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                    INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
--                    LEFT JOIN AHC_ANPHI AI ON DTA.DUONGSUID=AI.DUONGSU_ID
                
                    LEFT JOIN DM_HANHCHINH HC ON DTA.TAMTRUID=HC.ID
--                    LEFT JOIN AHC_FILE FL ON FL.id=TD.FILEID 
--                    
--                    LEFT JOIN AHC_FILE AF ON AF.DONID = TD.DONID AND TD.BIEUMAUID = AF.BIEUMAUID 
                    INNER JOIN AHC_SOTHAM_BANAN BA ON BA.ID = TD.MAPID

                    WHERE 
--                    DTA.TUCACHTOTUNG_MA IN('NGUYENDON', 'BIDON') 
--                    AND 
                    TD.URL_FILE is not NULL
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
            select HC.* from (
                
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
            ) HC 
            --WHERE DS.STT>=MININDEX AND DS.STT<=MAXINDEX
            ;
           
END TONGDAT_VNEID_BANAN_HC;
END PKG_DVCQG_VNEID_HC;