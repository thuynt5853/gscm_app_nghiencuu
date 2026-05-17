CREATE OR REPLACE PACKAGE BODY GSCM.PKG_DVCQG_VNEID AS


PROCEDURE THONGBAO_TONGDAT_VNEID
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
                       	--,TT.MA_THONGBAO as MATHONGBAO
                       	--vnpt 11/11/2025: truong MA_THONGBAO ko dap ứng trường hợp khi tống đạt 2 đối tượng nhưng chỉ 1 đối tượng phải nộp án phí
                        ,PKG_NOTINUMBER_VIEID.GEN_NOTINUMBER_CODE('DS') as MATHONGBAO
                        ,TD.URL_FILE,BM.MABM||'.'||BM.TENBM as TENTHONGBAO
                    ,DO.TOAANID as MACOQUANGUI,TN.MA_TEN as TENTOAAN,AI.SOTHONGBAO||'/TB-TA' AS SOTHONGBAO
                    ,AI.NGAYTHONGBAO as NGAYBANHANHTHONGBAO
                    ,DTA.SO_CCCD as SODINHDANHCONGDAN,DTA.TENDUONGSU,'Dân sự' as LOAIAN,'DS.'||DTA.ID as MaTB_VNEID
                     FROM ADS_TONGDAT TD 
                     INNER JOIN (SELECT DT.id,DT.tongdatid,DS.SO_CCCD, decode(ds.LOAIDUONGSU,2,DS.NGUOIDAIDIEN,3,DS.NGUOIDAIDIEN, DS.TENDUONGSU) TENDUONGSU
                            ,DS.TUCACHTOTUNG_MA ,DS.TAMTRUID,DS.ID AS DUONGSUID,DT.NGAYPHATHANH_HETHONG FROM ADS_TONGDAT_DOITUONG DT 
                                                    LEFT JOIN ADS_DON_DUONGSU DS ON DT.DUONGSUID = DS.ID 
                                                    where DT.TRANGTHAI = 1 and NVL(DT.DUONGSUID,0) >0 AND DS.XACTHUC_DLDCQG = 1 )DTA ON dta.tongdatid =td.id
                    INNER JOIN ADS_DON DO ON TD.DONID=DO.ID     
                    INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                    INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                    LEFT JOIN ADS_ANPHI AI ON DTA.DUONGSUID=AI.DUONGSU_ID
                
                    LEFT JOIN DM_HANHCHINH HC ON DTA.TAMTRUID=HC.ID
                    LEFT JOIN ADS_FILE FL ON FL.id=TD.FILEID --AND FL.BIEUMAUID=67
--                    LEFT JOIN DVCQG_THANH_TOAN TT ON tt.DUONGSU_ID=AI.DUONGSU_ID AND TT.ANPHI_ID=AI.ID AND TT.MALOAIVUVIEC='2'
--                    LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                    WHERE
                    DTA.TUCACHTOTUNG_MA='NGUYENDON' 
                    AND TD.URL_FILE is not null
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
 ELSIF (V_LOAIVUVIEC = 3) THEN
          FOR item_tp IN 
            (
                        SELECT TD.ID
                                ,TD.NGAYTAO
                                --,TT.MA_THONGBAO||'_'||FL.TENFILE as MATHONGBAO
                        		--,TT.MA_THONGBAO as MATHONGBAO
                        		--vnpt 11/11/2025: truong MA_THONGBAO ko dap ứng trường hợp khi tống đạt 2 đối tượng nhưng chỉ 1 đối tượng phải nộp án phí
                                ,PKG_NOTINUMBER_VIEID.GEN_NOTINUMBER_CODE('HN') as MATHONGBAO
                                ,TD.URL_FILE,BM.MABM||'.'||BM.TENBM as TENTHONGBAO
                                ,DO.TOAANID as MACOQUANGUI,TN.MA_TEN as TENTOAAN,AI.SOTHONGBAO||'/TB-TA' AS SOTHONGBAO
                               --,DTA.NGAYPHATHANH_HETHONG NGAYBANHANHTHONGBAO
                                ,AI.NGAYTHONGBAO as NGAYBANHANHTHONGBAO
                                ,DTA.SO_CCCD as SODINHDANHCONGDAN,DTA.TENDUONGSU,'Hôn nhân gia đình' as LOAIAN,'HNGD.'||DTA.ID as MaTB_VNEID
                                 FROM AHN_TONGDAT TD 
                                 INNER JOIN (SELECT DT.id,DT.tongdatid,DS.SO_CCCD, decode(ds.LOAIDUONGSU,2,DS.NGUOIDAIDIEN,3,DS.NGUOIDAIDIEN, DS.TENDUONGSU) TENDUONGSU
                                            ,DS.TUCACHTOTUNG_MA,DS.TAMTRUID,DS.ID AS DUONGSUID,DT.NGAYPHATHANH_HETHONG FROM AHN_TONGDAT_DOITUONG DT 
                                                                LEFT JOIN AHN_DON_DUONGSU DS ON DT.DUONGSUID = DS.ID 
                                                                where DT.TRANGTHAI = 1 and NVL(DT.DUONGSUID,0) >0 AND DS.XACTHUC_DLDCQG = 1)DTA ON dta.tongdatid =td.id
                                INNER JOIN AHN_DON DO ON TD.DONID=DO.ID     
                                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                                LEFT JOIN AHN_ANPHI AI ON ',' || AI.DUONGSU_IDs || ',' LIKE '%,' || TO_CHAR(DTA.DUONGSUID) || ',%'
                            
                                LEFT JOIN DM_HANHCHINH HC ON DTA.TAMTRUID=HC.ID
                                LEFT JOIN AHN_FILE FL ON FL.id=TD.FILEID --AND FL.BIEUMAUID=67
--                                LEFT JOIN DVCQG_THANH_TOAN TT ON tt.DUONGSU_IDs=AI.DUONGSU_IDs AND TT.ANPHI_ID=AI.ID AND TT.MALOAIVUVIEC='3'
--                                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                                WHERE
                                    DTA.TUCACHTOTUNG_MA='NGUYENDON' 
                                    AND TD.URL_FILE is not NULL
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
 ELSIF (V_LOAIVUVIEC = 4) THEN
         FOR item_tp IN 
            (
              SELECT TD.ID
                        ,TD.NGAYTAO
                                
                                --,TT.MA_THONGBAO||'_'||FL.TENFILE as MATHONGBAO
--                        		,TT.MA_THONGBAO as MATHONGBAO
                        		--vnpt 11/11/2025: truong MA_THONGBAO ko dap ứng trường hợp khi tống đạt 2 đối tượng nhưng chỉ 1 đối tượng phải nộp án phí
                                ,PKG_NOTINUMBER_VIEID.GEN_NOTINUMBER_CODE('KT') as MATHONGBAO
                                ,TD.URL_FILE,BM.MABM||'.'||BM.TENBM as TENTHONGBAO
                                ,DO.TOAANID as MACOQUANGUI,TN.MA_TEN as TENTOAAN,AI.SOTHONGBAO||'/TB-TA' AS SOTHONGBAO
                               --,DTA.NGAYPHATHANH_HETHONG NGAYBANHANHTHONGBAO
                                ,AI.NGAYTHONGBAO as NGAYBANHANHTHONGBAO
                                ,DTA.SO_CCCD as SODINHDANHCONGDAN,DTA.TENDUONGSU,'Kinh doanh Thương mại' as LOAIAN,'KDTM.'||DTA.ID as MaTB_VNEID
                                 FROM AKT_TONGDAT TD 
                                 INNER JOIN (SELECT DT.id,DT.tongdatid,DS.SO_CCCD, decode(ds.LOAIDUONGSU,2,DS.NGUOIDAIDIEN,3,DS.NGUOIDAIDIEN, DS.TENDUONGSU) TENDUONGSU
                                 ,DS.TUCACHTOTUNG_MA,DS.TAMTRUID,DS.ID AS DUONGSUID,DT.NGAYPHATHANH_HETHONG FROM AKT_TONGDAT_DOITUONG DT 
                                                                LEFT JOIN AKT_DON_DUONGSU DS ON DT.DUONGSUID = DS.ID 
                                                                where DT.TRANGTHAI = 1  and NVL(DT.DUONGSUID,0) >0 AND DS.XACTHUC_DLDCQG = 1)DTA ON dta.tongdatid =td.id
                                INNER JOIN AKT_DON DO ON TD.DONID=DO.ID     
                                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                                LEFT JOIN AKT_ANPHI AI ON DTA.DUONGSUID=AI.DUONGSU_ID
                            
                                LEFT JOIN DM_HANHCHINH HC ON DTA.TAMTRUID=HC.ID
                                LEFT JOIN AKT_FILE FL ON FL.id=TD.FILEID --AND FL.BIEUMAUID=67
--                                LEFT JOIN DVCQG_THANH_TOAN TT ON tt.DUONGSU_ID=AI.DUONGSU_ID AND TT.ANPHI_ID=AI.ID AND TT.MALOAIVUVIEC='4'
--                                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                                WHERE
                                     DTA.TUCACHTOTUNG_MA='NGUYENDON' 
                                     AND TD.URL_FILE is not NULL
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
 ELSIF (V_LOAIVUVIEC = 5) THEN   
     FOR item_tp IN 
            (
                        SELECT TD.ID
                                ,TD.NGAYTAO
                                --,TT.MA_THONGBAO||'_'||FL.TENFILE as MATHONGBAO
                                --,TT.MA_THONGBAO as MATHONGBAO
                        		--vnpt 11/11/2025: truong MA_THONGBAO ko dap ứng trường hợp khi tống đạt 2 đối tượng nhưng chỉ 1 đối tượng phải nộp án phí
                                ,PKG_NOTINUMBER_VIEID.GEN_NOTINUMBER_CODE('LD') as MATHONGBAO
                                ,TD.URL_FILE,BM.MABM||'.'||BM.TENBM as TENTHONGBAO
                                ,DO.TOAANID as MACOQUANGUI,TN.MA_TEN as TENTOAAN,AI.SOTHONGBAO||'/TB-TA' AS SOTHONGBAO
                               --,DTA.NGAYPHATHANH_HETHONG NGAYBANHANHTHONGBAO
                                ,AI.NGAYTHONGBAO as NGAYBANHANHTHONGBAO
                                ,DTA.SO_CCCD as SODINHDANHCONGDAN,DTA.TENDUONGSU,'Lao động' as LOAIAN,'LD.'||DTA.ID as MaTB_VNEID
                                 FROM ALD_TONGDAT TD 
                                 INNER JOIN (SELECT DT.id,DT.tongdatid,DS.SO_CCCD, decode(ds.LOAIDUONGSU,2,DS.NGUOIDAIDIEN,3,DS.NGUOIDAIDIEN, DS.TENDUONGSU) TENDUONGSU
                                 ,DS.TUCACHTOTUNG_MA ,DS.TAMTRUID,DS.ID AS DUONGSUID,DT.NGAYPHATHANH_HETHONG FROM ALD_TONGDAT_DOITUONG DT 
                                                                LEFT JOIN ALD_DON_DUONGSU DS ON DT.DUONGSUID = DS.ID 
                                                                where DT.TRANGTHAI = 1 and NVL(DT.DUONGSUID,0) >0 AND DS.XACTHUC_DLDCQG = 1 )DTA ON dta.tongdatid =td.id
                                INNER JOIN ALD_DON DO ON TD.DONID=DO.ID     
                                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                                LEFT JOIN ALD_ANPHI AI ON DTA.DUONGSUID=AI.DUONGSU_ID
                            
                                LEFT JOIN DM_HANHCHINH HC ON DTA.TAMTRUID=HC.ID
                                LEFT JOIN ALD_FILE FL ON FL.id=TD.FILEID --AND FL.BIEUMAUID=67
--                                LEFT JOIN DVCQG_THANH_TOAN TT ON tt.DUONGSU_ID=AI.DUONGSU_ID AND TT.ANPHI_ID=AI.ID AND TT.MALOAIVUVIEC='5'
--                                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                                WHERE
                                    DTA.TUCACHTOTUNG_MA='NGUYENDON' 
                                    AND TD.URL_FILE is not NULL
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
    
ELSIF (V_LOAIVUVIEC = 6) THEN 
    FOR item_tp IN 
            (
             SELECT TD.ID
                        ,TD.NGAYTAO
                                --,TT.MA_THONGBAO||'_'||FL.TENFILE as MATHONGBAO
                        		--,TT.MA_THONGBAO as MATHONGBAO
                        		--vnpt 11/11/2025: truong MA_THONGBAO ko dap ứng trường hợp khi tống đạt 2 đối tượng nhưng chỉ 1 đối tượng phải nộp án phí
                                ,PKG_NOTINUMBER_VIEID.GEN_NOTINUMBER_CODE('HC') as MATHONGBAO
                                ,TD.URL_FILE,BM.MABM||'.'||BM.TENBM as TENTHONGBAO
                                ,DO.TOAANID as MACOQUANGUI,TN.MA_TEN as TENTOAAN,AI.SOTHONGBAO||'/TB-TA' AS SOTHONGBAO
                                --,DTA.NGAYPHATHANH_HETHONG NGAYBANHANHTHONGBAO
                                ,AI.NGAYTHONGBAO as NGAYBANHANHTHONGBAO
                                ,DTA.SO_CCCD as SODINHDANHCONGDAN,DTA.TENDUONGSU,'Hành chính' as LOAIAN,'HC.'||DTA.ID as MaTB_VNEID
                                 FROM AHC_TONGDAT TD 
                                 INNER JOIN (SELECT DT.id,DT.tongdatid,DS.SO_CCCD, decode(ds.LOAIDUONGSU,2,DS.NGUOIDAIDIEN,3,DS.NGUOIDAIDIEN, DS.TENDUONGSU) TENDUONGSU
                                                ,DS.TUCACHTOTUNG_MA,DS.TAMTRUID,DS.ID AS DUONGSUID,DT.NGAYPHATHANH_HETHONG FROM AHC_TONGDAT_DOITUONG DT 
                                                                LEFT JOIN AHC_DON_DUONGSU DS ON DT.DUONGSUID = DS.ID 
                                                                where DT.TRANGTHAI = 1 and NVL(DT.DUONGSUID,0) >0 AND DS.XACTHUC_DLDCQG = 1 )DTA ON dta.tongdatid =td.id
                                INNER JOIN AHC_DON DO ON TD.DONID=DO.ID     
                                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                                LEFT JOIN AHC_ANPHI AI ON ',' || AI.DUONGSU_IDs || ',' LIKE '%,' || TO_CHAR(DTA.DUONGSUID) || ',%'
                            
                                LEFT JOIN DM_HANHCHINH HC ON DTA.TAMTRUID=HC.ID
                                LEFT JOIN AHC_FILE FL ON FL.id=TD.FILEID --AND FL.BIEUMAUID=67
--                                LEFT JOIN DVCQG_THANH_TOAN TT ON tt.DUONGSU_IDs=AI.DUONGSU_IDs AND TT.ANPHI_ID=AI.ID AND TT.MALOAIVUVIEC='6'
--                                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                                WHERE
                                    DTA.TUCACHTOTUNG_MA='NGUYENDON' 
                                    AND TD.URL_FILE is not NULL
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
 ELSIF (V_LOAIVUVIEC = 7) THEN    
     FOR item_tp IN 
            (
            SELECT TD.ID
                        ,TD.NGAYTAO
                    --,TT.MA_THONGBAO||'_'||FL.TENFILE as MATHONGBAO
                    ,TT.MA_THONGBAO as MATHONGBAO
                    ,TD.URL_FILE,BM.MABM||'.'||BM.TENBM as TENTHONGBAO
                                ,DO.TOAANID as MACOQUANGUI,TN.MA_TEN as TENTOAAN,AI.SOTHONGBAO||'/TB-TA' AS SOTHONGBAO
                                --,DTA.NGAYPHATHANH_HETHONG NGAYBANHANHTHONGBAO
                                ,AI.NGAYTHONGBAO as NGAYBANHANHTHONGBAO
                                ,DTA.SO_CCCD as SODINHDANHCONGDAN,DTA.TENDUONGSU,'Phá sản' as LOAIAN,'PS.'||DTA.ID as MaTB_VNEID
                                 FROM APS_TONGDAT TD 
                                 INNER JOIN (SELECT DT.id,DT.tongdatid,DS.SO_CCCD, decode(ds.LOAIDUONGSU,2,DS.NGUOIDAIDIEN,3,DS.NGUOIDAIDIEN, DS.TENDUONGSU) TENDUONGSU
                                                ,DS.TUCACHTOTUNG_MA,DS.TAMTRUID,DS.ID AS DUONGSUID,DT.NGAYPHATHANH_HETHONG FROM APS_TONGDAT_DOITUONG DT 
                                                                LEFT JOIN APS_DON_DUONGSU DS ON DT.DUONGSUID = DS.ID
                                                                where DT.TRANGTHAI = 1 and NVL(DT.DUONGSUID,0) >0 )DTA ON dta.tongdatid =td.id
                                INNER JOIN APS_DON DO ON TD.DONID=DO.ID     
                                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                                LEFT JOIN APS_ANPHI AI ON DTA.DUONGSUID=AI.DUONGSU_ID
                            
                                LEFT JOIN DM_HANHCHINH HC ON DTA.TAMTRUID=HC.ID
                                LEFT JOIN APS_FILE FL ON FL.id=TD.FILEID --AND FL.BIEUMAUID=67
                                LEFT JOIN DVCQG_THANH_TOAN TT ON tt.DUONGSU_ID=AI.DUONGSU_ID AND TT.ANPHI_ID=AI.ID AND TT.MALOAIVUVIEC='7'
                                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                                WHERE
                                    DTA.TUCACHTOTUNG_MA='NGUYENDON' 
                                    AND TD.URL_FILE is not null
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
                    ,'Thông_báo_nộp_tiền_tạm_ứng_án_phí.pdf' as "fileName"
                    ,'["'|| TP.LOAIAN || '", ""]' AS  "note"
                    FROM TABLE(v_table) TP 
                    WHERE 
                         LENGTH(trim(TP.SODINHDANHCONGDAN))  = 12 
                         -- AND TP.MATHONGBAO = '9TN7RG3H66'
            ) DS 
            --WHERE DS.STT>=MININDEX AND DS.STT<=MAXINDEX
            ;
          

END THONGBAO_TONGDAT_VNEID;


PROCEDURE EXPORT_THONGBAO_VNEID
(
    V_DONVI IN NUMBER,
    V_LOAITB IN VARCHAR2,
    V_DATE_FROM IN VARCHAR2,
    V_DATE_TO IN VARCHAR2,
    curReturn OUT SYS_REFCURSOR
) IS
    l_count number;
    l_blob       BLOB;
    l_filename   VARCHAR2 (200);

     MinIndex	number;V_LOAITOA VARCHAR2(150):=NULL; VV_DATE_FROM VARCHAR2(150):=NULL;VV_DATE_TO VARCHAR2(150):=NULL;
      MaxIndex	number;var_arrsx  varchar2(250); V_EXPORT_TEXT CLOB; 
      v_cursor SYS_REFCURSOR;v_table T_DVCQG_VNEID;V_STT number:=0;
      V_TUNGAY DATE;V_DENNGAY DATE;
      l_date_from  DATE;
    l_MaLoaiTB varchar2(100);
    v_cursor_pdf SYS_REFCURSOR;
BEGIN  

    DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
    v_table := T_DVCQG_VNEID(); --dung bang ding nghia
    --SELECT DECODE(V_DATE_FROM,NULL,'.....',V_DATE_FROM),DECODE(V_DATE_TO,NULL,'.....',V_DATE_TO) INTO VV_DATE_FROM,VV_DATE_TO FROM DUAL;
     BEGIN
        SELECT DATE_TO into l_date_from  FROM DVCQG_VNEID_LICHSUCHAY 
                                WHERE id = (SELECT MAX(id) FROM DVCQG_VNEID_LICHSUCHAY);
     EXCEPTION
        WHEN OTHERS THEN
           l_date_from := NULL; 
     END;
  -----------------------
     IF(V_DATE_FROM IS NOT NULL) THEN
        V_TUNGAY:=TO_DATE(V_DATE_FROM||' 00:00:00','dd/MM/yyyy hh24:mi:ss');
     else
        V_TUNGAY:= l_date_from;        
     END IF;
     
     IF(V_DATE_TO IS NOT NULL)THEN
        V_DENNGAY:=TO_DATE(V_DATE_TO||' 23:59:59','dd/MM/yyyy hh24:mi:ss');
     ELSE 
        V_DENNGAY:= sysdate();
     END IF;
     l_MaLoaiTB := 'TBTA';

  FOR item_tp IN 
            (
                SELECT TD.ID,TD.NGAYTAO
                    --,TT.MA_THONGBAO||'_'||FL.TENFILE as MATHONGBAO
                    ,TT.MA_THONGBAO as MATHONGBAO
                    ,TD.FILEID,BM.MABM||'.'||BM.TENBM as TENTHONGBAO
                ,DO.TOAANID as MACOQUANGUI,TN.MA_TEN as TENTOAAN,AI.SOTHONGBAO||'/TB-TA' AS SOTHONGBAO
                --,DTA.NGAYPHATHANH_HETHONG NGAYBANHANHTHONGBAO
                                ,AI.NGAYTHONGBAO as NGAYBANHANHTHONGBAO
                ,DTA.SO_CCCD as SODINHDANHCONGDAN,DTA.TENDUONGSU,'Dân sự' as LOAIAN,'DS.'||DTA.ID as MaTB_VNEID
                 FROM ADS_TONGDAT TD 
                 INNER JOIN (SELECT DT.id,DT.tongdatid,DS.SO_CCCD, DS.TENDUONGSU,DS.TUCACHTOTUNG_MA
                            ,DS.TAMTRUID,DS.ID AS DUONGSUID,DT.NGAYPHATHANH_HETHONG FROM ADS_TONGDAT_DOITUONG DT 
                                                LEFT JOIN ADS_DON_DUONGSU DS ON DT.DUONGSUID = DS.ID)DTA ON dta.tongdatid =td.id
                INNER JOIN ADS_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                LEFT JOIN ADS_ANPHI AI ON DTA.DUONGSUID=AI.DUONGSU_ID
            
                LEFT JOIN DM_HANHCHINH HC ON DTA.TAMTRUID=HC.ID
                LEFT JOIN ADS_FILE FL ON FL.id=TD.FILEID --AND FL.BIEUMAUID=67
                LEFT JOIN DVCQG_THANH_TOAN TT ON tt.DUONGSU_ID=AI.DUONGSU_ID AND TT.ANPHI_ID=AI.ID AND TT.MALOAIVUVIEC='2'
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE
                DTA.TUCACHTOTUNG_MA='NGUYENDON' AND TD.BIEUMAUID IN(67,381) --Thông báo nộp tiền tạm ứng án phí     
                AND AI.TAMUNGANPHI !=0
                AND TT.TRANGTHAITHANHTOAN=0  --check chua nop an phi or da nop an phi or da hoan tra --OR (TP.SOBIENLAI IS NULL AND V_STATUS=3) dinh chi nop an phi
                AND DTA.NGAYPHATHANH_HETHONG is not null
                AND DTA.NGAYPHATHANH_HETHONG BETWEEN  V_TUNGAY AND V_DENNGAY
                AND INSTR( lower( FL.TENFILE),'.pdf') > 0
                AND lower(TN.ten) not like '%test%'
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := R_DVCQG_VNEID(
        item_tp.ID,item_tp.NGAYTAO,l_MaLoaiTB,item_tp.MaTB_VNEID, item_tp.FILEID,item_tp.TENTHONGBAO
        ,item_tp.MACOQUANGUI,item_tp.TENTOAAN,item_tp.SOTHONGBAO,item_tp.NGAYBANHANHTHONGBAO,item_tp.SODINHDANHCONGDAN
        ,item_tp.TENDUONGSU,item_tp.LOAIAN,item_tp.MATHONGBAO);  
    END LOOP;
      -----------
     FOR item_tp IN 
            (
                 SELECT TD.ID,TD.NGAYTAO
                                --,TT.MA_THONGBAO||'_'||FL.TENFILE as MATHONGBAO
                                ,TT.MA_THONGBAO as MATHONGBAO
                                ,TD.FILEID,BM.MABM||'.'||BM.TENBM as TENTHONGBAO
                                ,DO.TOAANID as MACOQUANGUI,TN.MA_TEN as TENTOAAN,AI.SOTHONGBAO||'/TB-TA' AS SOTHONGBAO
                               --,DTA.NGAYPHATHANH_HETHONG NGAYBANHANHTHONGBAO
                                ,AI.NGAYTHONGBAO as NGAYBANHANHTHONGBAO
                                ,DTA.SO_CCCD as SODINHDANHCONGDAN,DTA.TENDUONGSU,'Hôn nhân gia đình' as LOAIAN,'HNGD.'||DTA.ID as MaTB_VNEID
                                 FROM AHN_TONGDAT TD 
                                 INNER JOIN (SELECT DT.id,DT.tongdatid,DS.SO_CCCD, DS.TENDUONGSU,DS.TUCACHTOTUNG_MA
                                            ,DS.TAMTRUID,DS.ID AS DUONGSUID,DT.NGAYPHATHANH_HETHONG FROM AHN_TONGDAT_DOITUONG DT 
                                                                LEFT JOIN AHN_DON_DUONGSU DS ON DT.DUONGSUID = DS.ID)DTA ON dta.tongdatid =td.id
                                INNER JOIN AHN_DON DO ON TD.DONID=DO.ID     
                                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                                LEFT JOIN AHN_ANPHI AI ON DTA.DUONGSUID=AI.DUONGSU_ID
                            
                                LEFT JOIN DM_HANHCHINH HC ON DTA.TAMTRUID=HC.ID
                                LEFT JOIN AHN_FILE FL ON FL.id=TD.FILEID --AND FL.BIEUMAUID=67
                                LEFT JOIN DVCQG_THANH_TOAN TT ON tt.DUONGSU_ID=AI.DUONGSU_ID AND TT.ANPHI_ID=AI.ID AND TT.MALOAIVUVIEC='3'
                                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                                WHERE
                                DTA.TUCACHTOTUNG_MA='NGUYENDON' AND TD.BIEUMAUID IN(67,381) --Thông báo nộp tiền tạm ứng án phí     
                                AND AI.TAMUNGANPHI !=0
                                AND TT.TRANGTHAITHANHTOAN=0  --check chua nop an phi or da nop an phi or da hoan tra --OR (TP.SOBIENLAI IS NULL AND V_STATUS=3) dinh chi nop an phi
                                AND DTA.NGAYPHATHANH_HETHONG is not null
                                AND DTA.NGAYPHATHANH_HETHONG BETWEEN  V_TUNGAY AND V_DENNGAY
                                AND INSTR( lower( FL.TENFILE),'.pdf') > 0
                                AND lower(TN.ten) not like '%test%'
           )
    LOOP
        v_table.extend;
       v_table(v_table.count) := R_DVCQG_VNEID(
        item_tp.ID,item_tp.NGAYTAO,l_MaLoaiTB,item_tp.MaTB_VNEID, item_tp.FILEID,item_tp.TENTHONGBAO
        ,item_tp.MACOQUANGUI,item_tp.TENTOAAN,item_tp.SOTHONGBAO,item_tp.NGAYBANHANHTHONGBAO,item_tp.SODINHDANHCONGDAN
        ,item_tp.TENDUONGSU,item_tp.LOAIAN,item_tp.MATHONGBAO);
    END LOOP;
      -----------
     FOR item_tp IN 
            (
              SELECT TD.ID,TD.NGAYTAO
                                
                                --,TT.MA_THONGBAO||'_'||FL.TENFILE as MATHONGBAO
                                ,TT.MA_THONGBAO as MATHONGBAO
                                ,TD.FILEID,BM.MABM||'.'||BM.TENBM as TENTHONGBAO
                                ,DO.TOAANID as MACOQUANGUI,TN.MA_TEN as TENTOAAN,AI.SOTHONGBAO||'/TB-TA' AS SOTHONGBAO
                               --,DTA.NGAYPHATHANH_HETHONG NGAYBANHANHTHONGBAO
                                ,AI.NGAYTHONGBAO as NGAYBANHANHTHONGBAO
                                ,DTA.SO_CCCD as SODINHDANHCONGDAN,DTA.TENDUONGSU,'Kinh doanh Thương mại' as LOAIAN,'KDTM.'||DTA.ID as MaTB_VNEID
                                 FROM AKT_TONGDAT TD 
                                 INNER JOIN (SELECT DT.id,DT.tongdatid,DS.SO_CCCD, DS.TENDUONGSU,DS.TUCACHTOTUNG_MA
                                            ,DS.TAMTRUID,DS.ID AS DUONGSUID,DT.NGAYPHATHANH_HETHONG FROM AKT_TONGDAT_DOITUONG DT 
                                                                LEFT JOIN AKT_DON_DUONGSU DS ON DT.DUONGSUID = DS.ID)DTA ON dta.tongdatid =td.id
                                INNER JOIN AKT_DON DO ON TD.DONID=DO.ID     
                                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                                LEFT JOIN AKT_ANPHI AI ON DTA.DUONGSUID=AI.DUONGSU_ID
                            
                                LEFT JOIN DM_HANHCHINH HC ON DTA.TAMTRUID=HC.ID
                                LEFT JOIN AKT_FILE FL ON FL.id=TD.FILEID --AND FL.BIEUMAUID=67
                                LEFT JOIN DVCQG_THANH_TOAN TT ON tt.DUONGSU_ID=AI.DUONGSU_ID AND TT.ANPHI_ID=AI.ID AND TT.MALOAIVUVIEC='4'
                                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                                WHERE
                                DTA.TUCACHTOTUNG_MA='NGUYENDON' AND TD.BIEUMAUID IN(67,381) --Thông báo nộp tiền tạm ứng án phí     
                                AND AI.TAMUNGANPHI !=0
                                AND TT.TRANGTHAITHANHTOAN=0  --check chua nop an phi or da nop an phi or da hoan tra --OR (TP.SOBIENLAI IS NULL AND V_STATUS=3) dinh chi nop an phi
                                AND DTA.NGAYPHATHANH_HETHONG is not null
                                AND DTA.NGAYPHATHANH_HETHONG BETWEEN  V_TUNGAY AND V_DENNGAY
                                AND INSTR( lower( FL.TENFILE),'.pdf') > 0
                                AND lower(TN.ten) not like '%test%'
           )
    LOOP
        v_table.extend;
       v_table(v_table.count) := R_DVCQG_VNEID(
        item_tp.ID,item_tp.NGAYTAO,l_MaLoaiTB,item_tp.MaTB_VNEID, item_tp.FILEID,item_tp.TENTHONGBAO
        ,item_tp.MACOQUANGUI,item_tp.TENTOAAN,item_tp.SOTHONGBAO,item_tp.NGAYBANHANHTHONGBAO,item_tp.SODINHDANHCONGDAN
        ,item_tp.TENDUONGSU,item_tp.LOAIAN,item_tp.MATHONGBAO);
    END LOOP;
       -----------
     FOR item_tp IN 
            (

                        SELECT TD.ID,TD.NGAYTAO
                                --,TT.MA_THONGBAO||'_'||FL.TENFILE as MATHONGBAO
                                ,TT.MA_THONGBAO as MATHONGBAO
                                ,TD.FILEID,BM.MABM||'.'||BM.TENBM as TENTHONGBAO
                                ,DO.TOAANID as MACOQUANGUI,TN.MA_TEN as TENTOAAN,AI.SOTHONGBAO||'/TB-TA' AS SOTHONGBAO
                               --,DTA.NGAYPHATHANH_HETHONG NGAYBANHANHTHONGBAO
                                ,AI.NGAYTHONGBAO as NGAYBANHANHTHONGBAO
                                ,DTA.SO_CCCD as SODINHDANHCONGDAN,DTA.TENDUONGSU,'Kinh doanh Thương mại' as LOAIAN,'KDTM.'||DTA.ID as MaTB_VNEID
                                 FROM ALD_TONGDAT TD 
                                 INNER JOIN (SELECT DT.id,DT.tongdatid,DS.SO_CCCD, DS.TENDUONGSU,DS.TUCACHTOTUNG_MA
                                            ,DS.TAMTRUID,DS.ID AS DUONGSUID,DT.NGAYPHATHANH_HETHONG FROM ALD_TONGDAT_DOITUONG DT 
                                                                LEFT JOIN ALD_DON_DUONGSU DS ON DT.DUONGSUID = DS.ID)DTA ON dta.tongdatid =td.id
                                INNER JOIN ALD_DON DO ON TD.DONID=DO.ID     
                                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                                LEFT JOIN ALD_ANPHI AI ON DTA.DUONGSUID=AI.DUONGSU_ID
                            
                                LEFT JOIN DM_HANHCHINH HC ON DTA.TAMTRUID=HC.ID
                                LEFT JOIN ALD_FILE FL ON FL.id=TD.FILEID --AND FL.BIEUMAUID=67
                                LEFT JOIN DVCQG_THANH_TOAN TT ON tt.DUONGSU_ID=AI.DUONGSU_ID AND TT.ANPHI_ID=AI.ID AND TT.MALOAIVUVIEC='5'
                                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                                WHERE
                                DTA.TUCACHTOTUNG_MA='NGUYENDON' AND TD.BIEUMAUID IN(67,381) --Thông báo nộp tiền tạm ứng án phí     
                                AND AI.TAMUNGANPHI !=0
                                AND TT.TRANGTHAITHANHTOAN=0  --check chua nop an phi or da nop an phi or da hoan tra --OR (TP.SOBIENLAI IS NULL AND V_STATUS=3) dinh chi nop an phi
                                AND DTA.NGAYPHATHANH_HETHONG is not null
                                AND DTA.NGAYPHATHANH_HETHONG BETWEEN  V_TUNGAY AND V_DENNGAY
                                AND INSTR( lower( FL.TENFILE),'.pdf') > 0
                                AND lower(TN.ten) not like '%test%'
            )
    LOOP
        v_table.extend;
        v_table(v_table.count) := R_DVCQG_VNEID(
        item_tp.ID,item_tp.NGAYTAO,l_MaLoaiTB,item_tp.MaTB_VNEID, item_tp.FILEID,item_tp.TENTHONGBAO
        ,item_tp.MACOQUANGUI,item_tp.TENTOAAN,item_tp.SOTHONGBAO,item_tp.NGAYBANHANHTHONGBAO,item_tp.SODINHDANHCONGDAN
        ,item_tp.TENDUONGSU,item_tp.LOAIAN,item_tp.MATHONGBAO);
    END LOOP;
    FOR item_tp IN 
            (

             SELECT TD.ID,TD.NGAYTAO
                                --,TT.MA_THONGBAO||'_'||FL.TENFILE as MATHONGBAO
                                ,TT.MA_THONGBAO as MATHONGBAO
                                ,TD.FILEID,BM.MABM||'.'||BM.TENBM as TENTHONGBAO
                                ,DO.TOAANID as MACOQUANGUI,TN.MA_TEN as TENTOAAN,AI.SOTHONGBAO||'/TB-TA' AS SOTHONGBAO
                                --,DTA.NGAYPHATHANH_HETHONG NGAYBANHANHTHONGBAO
                                ,AI.NGAYTHONGBAO as NGAYBANHANHTHONGBAO
                                ,DTA.SO_CCCD as SODINHDANHCONGDAN,DTA.TENDUONGSU,'Hành chính' as LOAIAN,'HC.'||DTA.ID as MaTB_VNEID
                                 FROM AHC_TONGDAT TD 
                                 INNER JOIN (SELECT DT.id,DT.tongdatid,DS.SO_CCCD, DS.TENDUONGSU,DS.TUCACHTOTUNG_MA
                                            ,DS.TAMTRUID,DS.ID AS DUONGSUID,DT.NGAYPHATHANH_HETHONG FROM AHC_TONGDAT_DOITUONG DT 
                                                                LEFT JOIN AHC_DON_DUONGSU DS ON DT.DUONGSUID = DS.ID)DTA ON dta.tongdatid =td.id
                                INNER JOIN AHC_DON DO ON TD.DONID=DO.ID     
                                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                                LEFT JOIN AHC_ANPHI AI ON DTA.DUONGSUID=AI.DUONGSU_ID
                            
                                LEFT JOIN DM_HANHCHINH HC ON DTA.TAMTRUID=HC.ID
                                LEFT JOIN AHC_FILE FL ON FL.id=TD.FILEID --AND FL.BIEUMAUID=67
                                LEFT JOIN DVCQG_THANH_TOAN TT ON tt.DUONGSU_ID=AI.DUONGSU_ID AND TT.ANPHI_ID=AI.ID AND TT.MALOAIVUVIEC='6'
                                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                                WHERE
                                 TD.BIEUMAUID=121   
                                AND AI.TAMUNGANPHI !=0
                                AND TT.TRANGTHAITHANHTOAN=0  --check chua nop an phi or da nop an phi or da hoan tra --OR (TP.SOBIENLAI IS NULL AND V_STATUS=3) dinh chi nop an phi
                                AND DTA.NGAYPHATHANH_HETHONG is not null
                                AND DTA.NGAYPHATHANH_HETHONG BETWEEN  V_TUNGAY AND V_DENNGAY
                                AND INSTR( lower( FL.TENFILE),'.pdf') > 0
                                AND lower(TN.ten) not like '%test%'
           )
    LOOP
        v_table.extend;
       v_table(v_table.count) := R_DVCQG_VNEID(
        item_tp.ID,item_tp.NGAYTAO,l_MaLoaiTB,item_tp.MaTB_VNEID, item_tp.FILEID,item_tp.TENTHONGBAO
        ,item_tp.MACOQUANGUI,item_tp.TENTOAAN,item_tp.SOTHONGBAO,item_tp.NGAYBANHANHTHONGBAO,item_tp.SODINHDANHCONGDAN
        ,item_tp.TENDUONGSU,item_tp.LOAIAN,item_tp.MATHONGBAO);
    END LOOP;
     ------------------
    FOR item_tp IN 
            (

            SELECT TD.ID,TD.NGAYTAO
                    --,TT.MA_THONGBAO||'_'||FL.TENFILE as MATHONGBAO
                    ,TT.MA_THONGBAO as MATHONGBAO
                    ,TD.FILEID,BM.MABM||'.'||BM.TENBM as TENTHONGBAO
                                ,DO.TOAANID as MACOQUANGUI,TN.MA_TEN as TENTOAAN,AI.SOTHONGBAO||'/TB-TA' AS SOTHONGBAO
                                --,DTA.NGAYPHATHANH_HETHONG NGAYBANHANHTHONGBAO
                                ,AI.NGAYTHONGBAO as NGAYBANHANHTHONGBAO
                                ,DTA.SO_CCCD as SODINHDANHCONGDAN,DTA.TENDUONGSU,'Phá sản' as LOAIAN,'PS.'||DTA.ID as MaTB_VNEID
                                 FROM APS_TONGDAT TD 
                                 INNER JOIN (SELECT DT.id,DT.tongdatid,DS.SO_CCCD, DS.TENDUONGSU,DS.TUCACHTOTUNG_MA
                                            ,DS.TAMTRUID,DS.ID AS DUONGSUID,DT.NGAYPHATHANH_HETHONG FROM APS_TONGDAT_DOITUONG DT 
                                                                LEFT JOIN APS_DON_DUONGSU DS ON DT.DUONGSUID = DS.ID)DTA ON dta.tongdatid =td.id
                                INNER JOIN APS_DON DO ON TD.DONID=DO.ID     
                                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                                LEFT JOIN APS_ANPHI AI ON DTA.DUONGSUID=AI.DUONGSU_ID
                            
                                LEFT JOIN DM_HANHCHINH HC ON DTA.TAMTRUID=HC.ID
                                LEFT JOIN APS_FILE FL ON FL.id=TD.FILEID --AND FL.BIEUMAUID=67
                                LEFT JOIN DVCQG_THANH_TOAN TT ON tt.DUONGSU_ID=AI.DUONGSU_ID AND TT.ANPHI_ID=AI.ID AND TT.MALOAIVUVIEC='7'
                                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                                WHERE
                                DTA.TUCACHTOTUNG_MA='NGUYENDON' AND TD.BIEUMAUID IN(67,381) --Thông báo nộp tiền tạm ứng án phí     
                                AND AI.TAMUNGANPHI !=0
                                AND TT.TRANGTHAITHANHTOAN=0  --check chua nop an phi or da nop an phi or da hoan tra --OR (TP.SOBIENLAI IS NULL AND V_STATUS=3) dinh chi nop an phi
                                AND DTA.NGAYPHATHANH_HETHONG is not null
                                AND DTA.NGAYPHATHANH_HETHONG BETWEEN  V_TUNGAY AND V_DENNGAY
                                AND INSTR( lower( FL.TENFILE),'.pdf') > 0
                                AND lower(TN.ten) not like '%test%'
           )
    LOOP
        v_table.extend;
       v_table(v_table.count) := R_DVCQG_VNEID(
        item_tp.ID,item_tp.NGAYTAO,l_MaLoaiTB,item_tp.MaTB_VNEID, item_tp.FILEID,item_tp.TENTHONGBAO
        ,item_tp.MACOQUANGUI,item_tp.TENTOAAN,item_tp.SOTHONGBAO,item_tp.NGAYBANHANHTHONGBAO,item_tp.SODINHDANHCONGDAN
        ,item_tp.TENDUONGSU,item_tp.LOAIAN,item_tp.MATHONGBAO);
    END LOOP;
    ----------------------------------------
-- Xuất file An phi tong dat 
------v_cursor_pdf
--     OPEN v_cursor_pdf FOR
--            select DS.* from (
--                SELECT 
--                    TP.FILEID,TP.LOAIAN, TP.MATHONGBAO 
--                    FROM TABLE(v_table) TP 
--                    WHERE 
--                        LENGTH(TP.SODINHDANHCONGDAN)  = 12  
--                        --AND TP.MATHONGBAO = '9TN7RG3H66'
--            ) DS 
--            --WHERE DS.STT>=MININDEX AND DS.STT<=MAXINDEX
--            ;
--            --- Ghi file
--            pdf_to_file(p_content => v_cursor_pdf,
--                            p_dir        => 'DIR_BLOB_FILES');  
------------- insert thơi gian lấy dữ liệu
--        INSERT INTO DVCQG_VNEID_LICHSUCHAY  VALUES(DVCQG_VNEID_LICHSUCHAY_SEQ.nextval,V_TUNGAY,V_DENNGAY,sysdate);
-------------- Xuất dữ liệu theo yêu cầu 

     OPEN curReturn FOR
            select DS.* from (
                
                SELECT 
                --COUNT(*) OVER()COUNTALL,
                   ROW_NUMBER() OVER (ORDER BY TP.NGAYTAO DESC,TP.MACOQUANGUI) STT
                    ,'TBTA' as MALOAITHONGBAO, TP.MaSoThongBao, TP.TENTHONGBAO, TP.SOTHONGBAO
                    , TP.MACOQUANGUI,TP.TENTOAAN
                    
                    --,To_char(TP.NGAYBANHANHTHONGBAO,'dd/MM/yyyy hh24:mi:ss') AS NGAYBANHANHTHONGBAO 
                    ,To_char(TP.NGAYBANHANHTHONGBAO,'dd/MM/yyyy') AS NGAYBANHANHTHONGBAO 
                    --,'' AS NGAYBANHANHTHONGBAO
                    ,TP.SODINHDANHCONGDAN ,TP.TENDUONGSU AS TENCONGDAN
                    ,'[{ "endpointFile":"'|| TP.MATHONGBAO ||'.pdf","name": "'|| TP.MATHONGBAO ||'.pdf" }]' as fileATT
                    , '{"area": "'|| TP.LOAIAN ||'", "note": []}' as Noidung
   
                    FROM TABLE(v_table) TP 
                    WHERE 
                         LENGTH(TP.SODINHDANHCONGDAN)  = 12 
                         -- AND TP.MATHONGBAO = '9TN7RG3H66'
            ) DS 
            --WHERE DS.STT>=MININDEX AND DS.STT<=MAXINDEX
            ;
          

END EXPORT_THONGBAO_VNEID;


PROCEDURE pdf_to_file 
(
    p_content    IN SYS_REFCURSOR,
    p_dir        IN VARCHAR2
)
AS   

    l_FILEID nvarchar2(250);
    l_LOAIAN nvarchar2(250);

    l_MATHONGBAO  nvarchar2(250);
    l_blob       blob;


BEGIN

        LOOP
            FETCH p_content
               INTO l_FILEID,l_LOAIAN,l_MATHONGBAO;
            EXIT WHEN p_content%NOTFOUND;
           --lay ra noi dung file
              if (l_LOAIAN = 'Dân sự') then
                    SELECT NOIDUNG
                          INTO l_blob
                          FROM ADS_FILE
                         WHERE  id = l_FILEID;
              elsif (l_LOAIAN = 'Hôn nhân gia đình') then
                    SELECT NOIDUNG
                              INTO l_blob
                              FROM AHN_FILE
                             WHERE  id = l_FILEID;

               elsif (l_LOAIAN = 'Kinh doanh Thương mại') then
                    SELECT NOIDUNG
                              INTO l_blob
                              FROM AKT_FILE
                             WHERE  id = l_FILEID;
               elsif (l_LOAIAN = 'Lao động') then
                    SELECT NOIDUNG
                              INTO l_blob
                              FROM ALD_FILE
                             WHERE  id = l_FILEID; 
               elsif (l_LOAIAN = 'Hành chính') then
                    SELECT NOIDUNG
                              INTO l_blob
                              FROM AHC_FILE
                             WHERE  id = l_FILEID;                  
              end if;
                 -- xuat file
                 if (l_blob is not null) then
                      blob_to_file (p_blob       => l_blob,
                                    p_dir        => 'DIR_BLOB_FILES',
                                    p_filename   => l_MATHONGBAO||'.pdf'
                                    --p_filename   => substr(lower(l_MATHONGBAO),1,INSTR( lower(l_MATHONGBAO),'.')-1) ||'.pdf'
--                                    ||substr(lower(l_MATHONGBAO),INSTR( lower(l_MATHONGBAO),'.') +1)
                                    );
                 end if;



         END LOOP;

END pdf_to_file;

PROCEDURE blob_to_file (p_blob       IN BLOB,
                                          p_dir        IN VARCHAR2,
                                          p_filename   IN VARCHAR2)
AS
    l_file       UTL_FILE.FILE_TYPE;
    l_buffer     RAW (32767);
    l_amount     BINARY_INTEGER := 32767;
    l_pos        INTEGER := 1;
    l_blob_len   INTEGER;
BEGIN
    l_blob_len := DBMS_LOB.getlength (p_blob);

    -- Open the destination file.
    l_file :=
        UTL_FILE.fopen (p_dir,
                        p_filename,
                        'wb',
                        32767);

    -- Read chunks of the BLOB and write them to the file until complete.
    WHILE l_pos <= l_blob_len
    LOOP
        DBMS_LOB.read (p_blob,
                       l_amount,
                       l_pos,
                       l_buffer);
        UTL_FILE.put_raw (l_file, l_buffer, TRUE);
        l_pos := l_pos + l_amount;
    END LOOP;

    -- Close the file.
    UTL_FILE.fclose (l_file);
EXCEPTION
    WHEN OTHERS
    THEN
        -- Close the file if something goes wrong.
        IF UTL_FILE.is_open (l_file)
        THEN
            UTL_FILE.fclose (l_file);
        END IF;

        RAISE;
END blob_to_file;


PROCEDURE excel_to_file 
(
    p_content    IN SYS_REFCURSOR,
    p_dir        IN VARCHAR2,
    p_filename   IN VARCHAR2
)
AS   
    FILENAME  UTL_FILE.FILE_TYPE;
    FILENAME1 VARCHAR2(1000);
    C1 SYS_REFCURSOR;
    l_STT number;
    l_MALOAITHONGBAO nvarchar2(250);
    l_TENTHONGBAO nvarchar2(250);
    l_MACOQUANGUI nvarchar2(250);
    l_TENTOAAN nvarchar2(250);
    l_SOTHONGBAO  nvarchar2(250);
     l_NGAYBANHANHTHONGBAO nvarchar2(250);
     l_SODINHDANHCONGDAN  nvarchar2(250);
     l_TENCONGDAN nvarchar2(250);
     l_fileATT nvarchar2(250);
     l_Noidung nvarchar2(250);



BEGIN
     l_MALOAITHONGBAO:= 'Mã loại thông báo';
      FILENAME1   :=  p_filename || '_' || SYSDATE || '.CSV';
      FILENAME    := UTL_FILE.FOPEN(p_dir, FILENAME1, 'W');
      /* THIS WILL CREATE THE HEADING IN EXCEL SHEET */
--        UTL_FILE.PUT_LINE(FILENAME,  
--                         utl_raw.cast_to_varchar2 ( utl_raw.convert ( utl_raw.cast_to_raw (
--                        'STT' || ',' || 'Mã loại thông báo' || ',' || 'Mã/Số thông báo' || ',' ||
--                           'Tên thông báo'|| ',' || 'Số văn bản'|| ',' || 'Mã cơ quan gửi' || ',' || 
--                        'Cơ quan gửi'|| ',' || 'Ngày ban hành thông báo' || ',' ||'Số định danh công dân' || ','  ||
--                        'Tên công dân'|| ',' ||'Danh sách file đính kèm' || ',' ||'Nội dung chi tiết' 
--                         ) , 'we8mswin1252' , 'utf8' ) ) 
--                        );
        UTL_FILE.PUT_LINE(FILENAME,
                         utl_raw.cast_to_varchar2 ( utl_raw.convert ( utl_raw.cast_to_raw (l_MALOAITHONGBAO) , 'WE8MSWIN1252' , 'AL32UTF8' )) 
                        );                



--          LOOP
--            FETCH p_content
--               INTO l_STT,l_MALOAITHONGBAO,l_TENTHONGBAO,l_MACOQUANGUI,l_TENTOAAN,l_SOTHONGBAO,l_NGAYBANHANHTHONGBAO
--                    ,l_SODINHDANHCONGDAN,l_TENCONGDAN,l_fileATT,l_Noidung;
--            EXIT WHEN p_content%NOTFOUND;
--         /*  THIS WILL PRINT THE RECORDS IN EXCEL SHEET AS PER THE QUERY IN CURSOR */
--            UTL_FILE.PUT_LINE(FILENAME,
--                              '"' || l_STT || '"' || ' ,' || '"' ||
--                              l_MALOAITHONGBAO || '"' || ' ,' || '"' ||
--                              convert(l_TENTHONGBAO, 'AL32UTF8')  || '"' || ' ,' || '"' ||
--                              convert(l_MACOQUANGUI, 'AL32UTF8')   || '"' || ' ,' || '"' ||
--                               l_TENTOAAN || '"' || ' ,' || '"' ||
--                              l_SOTHONGBAO || '"' || ' ,' || '"' ||
--                              l_NGAYBANHANHTHONGBAO || '"' || ' ,' || '"' ||
--                              l_SODINHDANHCONGDAN || '"' || ' ,' || '"' ||
--                              l_TENCONGDAN || '"' || ' ,' || '"' ||
--                              convert(l_fileATT, 'EE8MSWIN1250') || '"' || ' ,' || '"' ||
--                              
--                              l_Noidung|| '"');
--    
--        
--            END LOOP;
    -- Close the file.
      UTL_FILE.FCLOSE(FILENAME);
      
END excel_to_file;

END PKG_DVCQG_VNEID;