CREATE OR REPLACE PACKAGE BODY GSCM.PKG_DVCQG_VNEID_DS
AS
-- Package body
-- vnpt: hoangndh, sua tong dat thu ly vneid an DS, 30/10/2025 17:30:00
PROCEDURE THONGBAO_TONGDAT_VNEID_THULY_DS
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
   
     l_MaLoaiTB := 'TBTA';
 IF (V_LOAIVUVIEC = 2) THEN
     FOR item_tp IN 
            ( 
                    SELECT 
                        TD.ID
                        ,TD.NGAYTAO
                        ,TL.SOTHONGBAO||'/TB-TA' as SOTHONGBAO
                        ,TD.URL_FILE
                        ,BM.MABM||'.'||BM.TENBM as TENTHONGBAO
                    ,DO.TOAANID as MACOQUANGUI,TN.MA_TEN as TENTOAAN,PKG_NOTINUMBER_VIEID.GEN_NOTINUMBER_CODE('DS') AS MATHONGBAO
                    ,TL.NGAYTHONGBAO as NGAYBANHANHTHONGBAO
                    ,DTA.SO_CCCD as SODINHDANHCONGDAN,DTA.TENDUONGSU,'Dân sự' as LOAIAN,'DS.'||DTA.ID as MaTB_VNEID
                     FROM ADS_TONGDAT TD 
                     INNER JOIN (SELECT DT.id,DT.tongdatid,DS.SO_CCCD, decode(ds.LOAIDUONGSU,2,DS.NGUOIDAIDIEN,3,DS.NGUOIDAIDIEN, DS.TENDUONGSU) TENDUONGSU
                            ,DS.TUCACHTOTUNG_MA ,DS.TAMTRUID,DS.ID AS DUONGSUID,DT.NGAYPHATHANH_HETHONG FROM ADS_TONGDAT_DOITUONG DT 
                                                    LEFT JOIN ADS_DON_DUONGSU DS ON DT.DUONGSUID = DS.ID
                                                    where DT.TRANGTHAI = 1 and NVL(DT.DUONGSUID,0) >0 AND DS.XACTHUC_DLDCQG = 1 )DTA ON dta.tongdatid =td.id
                    INNER JOIN ADS_DON DO ON TD.DONID=DO.ID     
                    INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                    INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
--                    LEFT JOIN ADS_ANPHI AI ON DTA.DUONGSUID=AI.DUONGSU_ID
                
                    LEFT JOIN DM_HANHCHINH HC ON DTA.TAMTRUID=HC.ID
                   -- LEFT JOIN ADS_FILE FL ON FL.id=TD.FILEID --AND FL.BIEUMAUID=67
                    -- Tích hợp tống đạt nhiều lần
                    INNER JOIN ADS_SOTHAM_THULY TL ON TL.ID = TD.MAPID
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
                    ,'Thông_báo_về_việc_thụ_lý_vụ_án.pdf' as "fileName"
                    ,'["'|| TP.LOAIAN || '", ""]' AS  "note"
                    FROM TABLE(v_table) TP 
                    WHERE 
                         LENGTH(trim(TP.SODINHDANHCONGDAN))  = 12 
                         -- AND TP.MATHONGBAO = '9TN7RG3H66'
            ) DS 
            --WHERE DS.STT>=MININDEX AND DS.STT<=MAXINDEX
            ;
          

END THONGBAO_TONGDAT_VNEID_THULY_DS;


-- VNPT quanvv GIAI QUYETDON
PROCEDURE TONGDAT_VNEID_GIAIQUYETDON_DS
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
 IF (V_LOAIVUVIEC = 2) THEN
     FOR item_tp IN 
            (
                    SELECT 
                        TD.ID
                        ,TD.NGAYTAO
                        ,TL.SOTHONGBAO||'/TB-TA' as SOTHONGBAO
                        ,TD.URL_FILE
                        ,BM.MABM||'.'||BM.TENBM as TENTHONGBAO
                    ,DO.TOAANID as MACOQUANGUI,TN.MA_TEN as TENTOAAN,PKG_NOTINUMBER_VIEID.GEN_NOTINUMBER_CODE('DS') AS MATHONGBAO
                    ,TL.NGAYTHONGBAO as NGAYBANHANHTHONGBAO
                    ,DTA.SO_CCCD as SODINHDANHCONGDAN,DTA.TENDUONGSU,'Dân sự' as LOAIAN,'DS.'||DTA.ID as MaTB_VNEID
                     FROM ADS_TONGDAT TD 
                     INNER JOIN (SELECT DT.id,DT.tongdatid,DS.SO_CCCD, decode(ds.LOAIDUONGSU,2,DS.NGUOIDAIDIEN,3,DS.NGUOIDAIDIEN, DS.TENDUONGSU) TENDUONGSU
                            ,DS.TUCACHTOTUNG_MA ,DS.TAMTRUID,DS.ID AS DUONGSUID,DT.NGAYPHATHANH_HETHONG FROM ADS_TONGDAT_DOITUONG DT 
                                                    LEFT JOIN ADS_DON_DUONGSU DS ON DT.DUONGSUID = DS.ID AND DS.XACTHUC_DLDCQG = 1
                                                    where DT.TRANGTHAI = 1 and NVL(DT.DUONGSUID,0) >0 AND DS.XACTHUC_DLDCQG = 1 )DTA ON dta.tongdatid =td.id
                    INNER JOIN ADS_DON DO ON TD.DONID=DO.ID     
                    INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                    INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
--                    LEFT JOIN ADS_ANPHI AI ON DTA.DUONGSUID=AI.DUONGSU_ID
                
                    LEFT JOIN DM_HANHCHINH HC ON DTA.TAMTRUID=HC.ID
    -- vnpt quanvv 26/11/2025 tich hop tong dat nhieu lan
    --                LEFT JOIN ADS_FILE FL ON FL.id=TD.FILEID 
                    
                    LEFT JOIN ADS_FILE AF ON AF.DONID = TD.DONID AND TD.BIEUMAUID = AF.BIEUMAUID 
                    INNER JOIN ADS_DON_XULY TL ON TL.ID = TD.MAPID --TL.FILEID = AF.ID AND 

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
          
END TONGDAT_VNEID_GIAIQUYETDON_DS;


-- vnpt: hoangndh, sua tong dat quyet dinh so tham vneid an DS, 14/11/2025 17:30:00
PROCEDURE THONGBAO_TONGDAT_VNEID_QDVUVIEC_ST_DS
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
 IF (V_LOAIVUVIEC = 2) THEN
     FOR item_tp IN 
            (
                    SELECT 
                        TD.ID
                        ,TD.NGAYTAO
                        ,QD.SOQD||'/TB-TA' as SOTHONGBAO
                        ,TD.URL_FILE
                        ,BM.MABM||'.'||BM.TENBM as TENTHONGBAO
                    ,DO.TOAANID as MACOQUANGUI,TN.MA_TEN as TENTOAAN,PKG_NOTINUMBER_VIEID.GEN_NOTINUMBER_CODE('DS') AS MATHONGBAO
                    ,QD.NGAYQD as NGAYBANHANHTHONGBAO
                    ,DTA.SO_CCCD as SODINHDANHCONGDAN,DTA.TENDUONGSU,'Dân sự' as LOAIAN,'DS.'||DTA.ID as MaTB_VNEID
                     FROM ADS_TONGDAT TD 
                     INNER JOIN (SELECT DT.id,DT.tongdatid,DS.SO_CCCD, decode(ds.LOAIDUONGSU,2,DS.NGUOIDAIDIEN,3,DS.NGUOIDAIDIEN, DS.TENDUONGSU) TENDUONGSU
                            ,DS.TUCACHTOTUNG_MA ,DS.TAMTRUID,DS.ID AS DUONGSUID,DT.NGAYPHATHANH_HETHONG FROM ADS_TONGDAT_DOITUONG DT 
                                                    LEFT JOIN ADS_DON_DUONGSU DS ON DT.DUONGSUID = DS.ID
                                                    where DT.TRANGTHAI = 1 and NVL(DT.DUONGSUID,0) >0 AND DS.XACTHUC_DLDCQG = 1 )DTA ON dta.tongdatid =td.id
                    INNER JOIN ADS_DON DO ON TD.DONID=DO.ID     
                    INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                    INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
--                    LEFT JOIN ADS_ANPHI AI ON DTA.DUONGSUID=AI.DUONGSU_ID
                
                    LEFT JOIN DM_HANHCHINH HC ON DTA.TAMTRUID=HC.ID
                    LEFT JOIN ADS_FILE FL ON FL.id=TD.FILEID --AND FL.BIEUMAUID=67
                    INNER JOIN ADS_SOTHAM_QUYETDINH QD ON QD.ID = TD.MAPID --AND QD.FILEID = FL.ID
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
          

END THONGBAO_TONGDAT_VNEID_QDVUVIEC_ST_DS;



-- vnpt: hoangndh, sua tong dat quyet dinh phuc tham vneid an DS, 17/11/2025 13:30:00
PROCEDURE THONGBAO_TONGDAT_VNEID_QDVUVIEC_PT_DS
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
 IF (V_LOAIVUVIEC = 2) THEN
     FOR item_tp IN 
            (
                    SELECT 
                        TD.ID
                        ,TD.NGAYTAO
                        ,QD.SOQD||'/TB-TA' as SOTHONGBAO
                        ,TD.URL_FILE
                        ,BM.MABM||'.'||BM.TENBM as TENTHONGBAO
                    ,DO.TOAPHUCTHAMID as MACOQUANGUI,TN.MA_TEN as TENTOAAN,PKG_NOTINUMBER_VIEID.GEN_NOTINUMBER_CODE('DS') AS MATHONGBAO
                    ,QD.NGAYQD as NGAYBANHANHTHONGBAO
                    ,DTA.SO_CCCD as SODINHDANHCONGDAN,DTA.TENDUONGSU,'Dân sự' as LOAIAN,'DS.'||DTA.ID as MaTB_VNEID
                     FROM ADS_TONGDAT TD 
                     INNER JOIN (SELECT DT.id,DT.tongdatid,DS.SO_CCCD, decode(ds.LOAIDUONGSU,2,DS.NGUOIDAIDIEN,3,DS.NGUOIDAIDIEN, DS.TENDUONGSU) TENDUONGSU
                            ,DS.TUCACHTOTUNG_MA ,DS.TAMTRUID,DS.ID AS DUONGSUID,DT.NGAYPHATHANH_HETHONG FROM ADS_TONGDAT_DOITUONG DT 
                                                    LEFT JOIN ADS_DON_DUONGSU DS ON DT.DUONGSUID = DS.ID AND DS.XACTHUC_DLDCQG = 1
                                                    where DT.TRANGTHAI = 1 and NVL(DT.DUONGSUID,0) >0 AND DS.XACTHUC_DLDCQG = 1 )DTA ON dta.tongdatid =td.id
                    INNER JOIN ADS_DON DO ON TD.DONID=DO.ID     
                    INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAPHUCTHAMID
                    INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
--                    LEFT JOIN ADS_ANPHI AI ON DTA.DUONGSUID=AI.DUONGSU_ID
                
                    LEFT JOIN DM_HANHCHINH HC ON DTA.TAMTRUID=HC.ID
                    LEFT JOIN ADS_FILE FL ON FL.id=TD.FILEID --AND FL.BIEUMAUID=67
                    INNER JOIN ADS_PHUCTHAM_QUYETDINH QD ON QD.ID = TD.MAPID --AND QD.FILEID = FL.ID
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
          

END THONGBAO_TONGDAT_VNEID_QDVUVIEC_PT_DS;

-- vnpt: hoangndh, sua tong dat quyet dinh ban an vneid an DS, 17/11/2025 15:30:00
PROCEDURE THONGBAO_TONGDAT_VNEID_BANAN_PT_DS
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
 IF (V_LOAIVUVIEC = 2) THEN
     FOR item_tp IN 
            (
                    SELECT 
                        TD.ID
                        ,TD.NGAYTAO
                        ,BA.SOBANAN||'/TB-TA' as SOTHONGBAO
                        ,TD.URL_FILE
                        ,BM.MABM||'.'||BM.TENBM as TENTHONGBAO
                    ,DO.TOAPHUCTHAMID as MACOQUANGUI,TN.MA_TEN as TENTOAAN,PKG_NOTINUMBER_VIEID.GEN_NOTINUMBER_CODE('DS') AS MATHONGBAO
                    ,BA.NGAYTUYENAN as NGAYBANHANHTHONGBAO
                    ,DTA.SO_CCCD as SODINHDANHCONGDAN,DTA.TENDUONGSU,'Dân sự' as LOAIAN,'DS.'||DTA.ID as MaTB_VNEID
                     FROM ADS_TONGDAT TD 
                     INNER JOIN (SELECT DT.id,DT.tongdatid,DS.SO_CCCD, decode(ds.LOAIDUONGSU,2,DS.NGUOIDAIDIEN,3,DS.NGUOIDAIDIEN, DS.TENDUONGSU) TENDUONGSU
                            ,DS.TUCACHTOTUNG_MA ,DS.TAMTRUID,DS.ID AS DUONGSUID,DT.NGAYPHATHANH_HETHONG FROM ADS_TONGDAT_DOITUONG DT 
                                                    LEFT JOIN ADS_DON_DUONGSU DS ON DT.DUONGSUID = DS.ID AND DS.XACTHUC_DLDCQG = 1
                                                    where DT.TRANGTHAI = 1 and NVL(DT.DUONGSUID,0) >0 AND DS.XACTHUC_DLDCQG = 1)DTA ON dta.tongdatid =td.id
                    INNER JOIN ADS_DON DO ON TD.DONID=DO.ID     
                    INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAPHUCTHAMID
                    INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
--                    LEFT JOIN ADS_ANPHI AI ON DTA.DUONGSUID=AI.DUONGSU_ID
                
                    LEFT JOIN DM_HANHCHINH HC ON DTA.TAMTRUID=HC.ID
                      -- vnpt quanvv 26/11/2025 tich hop tong dat nhieu lan
                  --  LEFT JOIN ADS_FILE FL ON FL.id=TD.FILEID --AND FL.BIEUMAUID=67
                    INNER JOIN ADS_PHUCTHAM_BANAN BA ON BA.ID = TD.MAPID
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
          

END THONGBAO_TONGDAT_VNEID_BANAN_PT_DS;


--vnpt/quanvv TONG DAT THONG TIN DON
PROCEDURE TONGDAT_VNEID_THONGTINDON_DS
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
 IF (V_LOAIVUVIEC = 2) THEN
     FOR item_tp IN 
            (
                    SELECT 
                        TD.ID
                        ,TD.NGAYTAO
                        ,'' as SOTHONGBAO -- Không có trường số thông báo giá trị rỗng
                        ,TD.URL_FILE
                        ,BM.MABM||'.'||BM.TENBM as TENTHONGBAO
                    ,DO.TOAANID as MACOQUANGUI,TN.MA_TEN as TENTOAAN,PKG_NOTINUMBER_VIEID.GEN_NOTINUMBER_CODE('DS') AS MATHONGBAO
                    ,AD.NGAYNHANDON as NGAYBANHANHTHONGBAO -- HIện tại chưa có trường ngày này
                    ,DTA.SO_CCCD as SODINHDANHCONGDAN,DTA.TENDUONGSU,'Dân sự' as LOAIAN,'DS.'||DTA.ID as MaTB_VNEID
                     FROM ADS_TONGDAT TD 
                     INNER JOIN (SELECT DT.id,DT.tongdatid,DS.SO_CCCD, decode(ds.LOAIDUONGSU,2,DS.NGUOIDAIDIEN,3,DS.NGUOIDAIDIEN, DS.TENDUONGSU) TENDUONGSU
                            ,DS.TUCACHTOTUNG_MA ,DS.TAMTRUID,DS.ID AS DUONGSUID,DT.NGAYPHATHANH_HETHONG FROM ADS_TONGDAT_DOITUONG DT 
                                                    LEFT JOIN ADS_DON_DUONGSU DS ON DT.DUONGSUID = DS.ID AND DS.XACTHUC_DLDCQG = 1
                                                    where DT.TRANGTHAI = 1 and NVL(DT.DUONGSUID,0) >0 AND DS.XACTHUC_DLDCQG = 1 )DTA ON dta.tongdatid =td.id
                    INNER JOIN ADS_DON DO ON TD.DONID=DO.ID     
                    INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                    INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                
                    LEFT JOIN DM_HANHCHINH HC ON DTA.TAMTRUID=HC.ID
                    LEFT JOIN ADS_FILE FL ON FL.id=TD.FILEID 
                   -- LEFT JOIN ADS_DON_XULY TL ON TL.DONID = TD.DONID
                      -- vnpt quanvv 26/11/2025 tich hop tong dat nhieu lan
                    INNER JOIN ADS_DON AD ON AD.ID = TD.DONID

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
          
END TONGDAT_VNEID_THONGTINDON_DS;

PROCEDURE TONGDAT_VNEID_THULY_PT_DS
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
 IF (V_LOAIVUVIEC = 2) THEN
     FOR item_tp IN 
            (
                    SELECT 
                        TD.ID
                        ,TD.NGAYTAO
                        ,AL.SOTHONGBAO||'/TB-TA' as SOTHONGBAO
                        ,TD.URL_FILE
                        ,BM.MABM||'.'||BM.TENBM as TENTHONGBAO
                    ,DO.TOAPHUCTHAMID as MACOQUANGUI,TN.MA_TEN as TENTOAAN,PKG_NOTINUMBER_VIEID.GEN_NOTINUMBER_CODE('DS') AS MATHONGBAO
                    ,AL.NGAYTHONGBAO as NGAYBANHANHTHONGBAO
                    ,DTA.SO_CCCD as SODINHDANHCONGDAN,DTA.TENDUONGSU,'Dân sự' as LOAIAN,'DS.'||DTA.ID as MaTB_VNEID
                     FROM ADS_TONGDAT TD 
                     INNER JOIN (SELECT DT.id,DT.tongdatid,DS.SO_CCCD, decode(ds.LOAIDUONGSU,2,DS.NGUOIDAIDIEN,3,DS.NGUOIDAIDIEN, DS.TENDUONGSU) TENDUONGSU
                            ,DS.TUCACHTOTUNG_MA ,DS.TAMTRUID,DS.ID AS DUONGSUID,DT.NGAYPHATHANH_HETHONG FROM ADS_TONGDAT_DOITUONG DT 
                                                    LEFT JOIN ADS_DON_DUONGSU DS ON DT.DUONGSUID = DS.ID AND DS.XACTHUC_DLDCQG = 1
                                                    where DT.TRANGTHAI = 1 and NVL(DT.DUONGSUID,0) >0 AND DS.XACTHUC_DLDCQG = 1 )DTA ON dta.tongdatid =td.id
                    INNER JOIN ADS_DON DO ON TD.DONID=DO.ID     
                    INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAPHUCTHAMID
                    INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                
                    LEFT JOIN DM_HANHCHINH HC ON DTA.TAMTRUID=HC.ID
                    -- vnpt quanvv 26/11/2025 tich hop tong dat nhieu lan
                    --LEFT JOIN ADS_FILE FL ON FL.id=TD.FILEID 
                    
                 --   LEFT JOIN ADS_FILE AF ON AF.DONID = TD.DONID AND TD.BIEUMAUID = AF.BIEUMAUID 
                    INNER JOIN ADS_PHUCTHAM_THULY AL ON AL.ID = TD.MAPID 

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
          
END TONGDAT_VNEID_THULY_PT_DS;



-- VNPT quanvv Ban an so tham
PROCEDURE THONGBAO_TONGDAT_VNEID_BANAN_ST_DS
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
 IF (V_LOAIVUVIEC = 2) THEN
     FOR item_tp IN 
            (
                    SELECT 
                        TD.ID
                        ,TD.NGAYTAO
                        ,TL.SOBANAN||'/TB-TA' as SOTHONGBAO
                        ,TD.URL_FILE
                        ,BM.MABM||'.'||BM.TENBM as TENTHONGBAO
                    ,DO.TOAANID as MACOQUANGUI,TN.MA_TEN as TENTOAAN,PKG_NOTINUMBER_VIEID.GEN_NOTINUMBER_CODE('DS') AS MATHONGBAO
                    ,TL.NGAYTUYENAN as NGAYBANHANHTHONGBAO
                    ,DTA.SO_CCCD as SODINHDANHCONGDAN,DTA.TENDUONGSU,'Dân sự' as LOAIAN,'DS.'||DTA.ID as MaTB_VNEID
                     FROM ADS_TONGDAT TD 
                     INNER JOIN (SELECT DT.id,DT.tongdatid,DS.SO_CCCD, decode(ds.LOAIDUONGSU,2,DS.NGUOIDAIDIEN,3,DS.NGUOIDAIDIEN, DS.TENDUONGSU) TENDUONGSU
                            ,DS.TUCACHTOTUNG_MA ,DS.TAMTRUID,DS.ID AS DUONGSUID,DT.NGAYPHATHANH_HETHONG FROM ADS_TONGDAT_DOITUONG DT 
                                                    LEFT JOIN ADS_DON_DUONGSU DS ON DT.DUONGSUID = DS.ID AND DS.XACTHUC_DLDCQG = 1
                                                    where DT.TRANGTHAI = 1 and NVL(DT.DUONGSUID,0) >0 AND DS.XACTHUC_DLDCQG = 1 )DTA ON dta.tongdatid =td.id
                    INNER JOIN ADS_DON DO ON TD.DONID=DO.ID     
                    INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                    INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
--                    LEFT JOIN ADS_ANPHI AI ON DTA.DUONGSUID=AI.DUONGSU_ID
                
                    LEFT JOIN DM_HANHCHINH HC ON DTA.TAMTRUID=HC.ID
                    LEFT JOIN ADS_FILE FL ON FL.id=TD.FILEID 
                    
                    --LEFT JOIN ADS_FILE AF ON AF.DONID = TD.DONID AND TD.BIEUMAUID = AF.BIEUMAUID 
                    INNER JOIN ADS_SOTHAM_BANAN TL ON  TL.ID = TD.MAPID

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
          
END THONGBAO_TONGDAT_VNEID_BANAN_ST_DS;
-- quanvv tongdat quyet dinh so tham
PROCEDURE THONGBAO_TONGDAT_VNEID_QUYETDINH_ST_DS
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
 IF (V_LOAIVUVIEC = 2) THEN
     FOR item_tp IN 
            (
                    SELECT 
                        TD.ID
                        ,TD.NGAYTAO
                        ,TL.SOQD||'/TB-TA' as SOTHONGBAO
                        ,TD.URL_FILE
                        ,BM.MABM||'.'||BM.TENBM as TENTHONGBAO
                    ,DO.TOAANID as MACOQUANGUI,TN.MA_TEN as TENTOAAN,PKG_NOTINUMBER_VIEID.GEN_NOTINUMBER_CODE('DS') AS MATHONGBAO
                    ,TL.NGAYQD as NGAYBANHANHTHONGBAO
                    ,DTA.SO_CCCD as SODINHDANHCONGDAN,DTA.TENDUONGSU,'Dân sự' as LOAIAN,'DS.'||DTA.ID as MaTB_VNEID
                     FROM ADS_TONGDAT TD 
                     INNER JOIN (SELECT DT.id,DT.tongdatid,DS.SO_CCCD, decode(ds.LOAIDUONGSU,2,DS.NGUOIDAIDIEN,3,DS.NGUOIDAIDIEN, DS.TENDUONGSU) TENDUONGSU
                            ,DS.TUCACHTOTUNG_MA ,DS.TAMTRUID,DS.ID AS DUONGSUID,DT.NGAYPHATHANH_HETHONG FROM ADS_TONGDAT_DOITUONG DT 
                                                    LEFT JOIN ADS_DON_DUONGSU DS ON DT.DUONGSUID = DS.ID AND DS.XACTHUC_DLDCQG = 1
                                                    where DT.TRANGTHAI = 1 and NVL(DT.DUONGSUID,0) >0 AND DS.XACTHUC_DLDCQG = 1 )DTA ON dta.tongdatid =td.id
                    INNER JOIN ADS_DON DO ON TD.DONID=DO.ID     
                    INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                    INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
--                    LEFT JOIN ADS_ANPHI AI ON DTA.DUONGSUID=AI.DUONGSU_ID
                
                    LEFT JOIN DM_HANHCHINH HC ON DTA.TAMTRUID=HC.ID
                    LEFT JOIN ADS_FILE FL ON FL.id=TD.FILEID 
                    
                  --  LEFT JOIN ADS_FILE AF ON AF.DONID = TD.DONID AND TD.BIEUMAUID = AF.BIEUMAUID 
                    INNER JOIN ADS_SOTHAM_QUYETDINH TL ON  TL.ID = TD.MAPID--TL.FILEID = AF.ID AND

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
          
END THONGBAO_TONGDAT_VNEID_QUYETDINH_ST_DS;

END PKG_DVCQG_VNEID_DS;