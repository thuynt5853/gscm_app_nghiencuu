create or replace NONEDITIONABLE PACKAGE BODY "PKG_TUPHAP_ANPHI" AS
PROCEDURE ANPHI_FILE_UPD_XOA
( 
    V_LOAIAN in varchar2,
    V_ANPHI_ID  in number,
    V_ACTION varchar2, --- A Thêm mới, S Thay thế, X Xóa file    
    V_COUNT_TL OUT number
)IS 
    V_FILEID NUMBER;V_COUNT NUMBER:=0;V_COUNT_TL_S NUMBER:=0;
BEGIN 
    V_COUNT_TL:=0;
    IF(V_LOAIAN='2')THEN
                SELECT COUNT(*)INTO V_COUNT_TL_S FROM ADS_SOTHAM_THULY TL WHERE  EXISTS(SELECT 'X' FROM ADS_ANPHI WHERE DONID=TL.DONID AND ID=V_ANPHI_ID AND ENABLE=1);
                   IF(V_COUNT_TL_S=0)THEN
                        select count(*) into v_count from ADS_FILE_THA where ANPHI_ID = V_ANPHI_ID and STATUS = 1;
                        if(v_count>0)then
                           select file_id into V_FILEID from ADS_FILE_THA where ANPHI_ID = V_ANPHI_ID and STATUS = 1;
                            UPDATE ADS_FILE_THA SET 
                                STATUS = 0,
                                ACTION = V_ACTION
                            WHERE FILE_ID  = V_FILEID;
                   END IF;
               end if;
   ELSIF(V_LOAIAN='3')THEN
         SELECT COUNT(*)INTO V_COUNT_TL_S FROM AHN_SOTHAM_THULY TL WHERE  EXISTS(SELECT 'X' FROM AHN_ANPHI WHERE DONID=TL.DONID AND ID=V_ANPHI_ID  AND ENABLE=1);
         IF(V_COUNT_TL_S=0)THEN
                    select count(*) into v_count from AHN_FILE_THA where ANPHI_ID = V_ANPHI_ID and STATUS = 1;
                    if(v_count>0)then
                    select file_id into V_FILEID from AHN_FILE_THA where ANPHI_ID = V_ANPHI_ID and STATUS = 1;
                    UPDATE AHN_FILE_THA SET 
                    STATUS = 0,
                    ACTION = V_ACTION
                    WHERE FILE_ID  = V_FILEID;
             end if;
           end if;     
    ELSIF(V_LOAIAN='4')THEN
             SELECT COUNT(*)INTO V_COUNT_TL_S FROM AKT_SOTHAM_THULY TL WHERE  EXISTS(SELECT 'X' FROM AKT_ANPHI WHERE DONID=TL.DONID AND ID=V_ANPHI_ID  AND ENABLE=1);
                  IF(V_COUNT_TL_S=0)THEN
                            select count(*) into v_count from AKT_FILE_THA where ANPHI_ID = V_ANPHI_ID and STATUS = 1;
                            if(v_count>0)then
                            select file_id into V_FILEID from AKT_FILE_THA where ANPHI_ID = V_ANPHI_ID and STATUS = 1;
                            UPDATE AKT_FILE_THA SET 
                            STATUS = 0,
                            ACTION = V_ACTION
                            WHERE FILE_ID  = V_FILEID;
                    end if;
               end if;
    ELSIF(V_LOAIAN='5')THEN
              SELECT COUNT(*)INTO V_COUNT_TL_S FROM ALD_SOTHAM_THULY TL WHERE  EXISTS(SELECT 'X' FROM ALD_ANPHI WHERE DONID=TL.DONID AND ID=V_ANPHI_ID  AND ENABLE=1);
                  IF(V_COUNT_TL_S=0)THEN
                    select count(*) into v_count from ALD_FILE_THA where ANPHI_ID = V_ANPHI_ID and STATUS = 1;
                    if(v_count>0)then
                    select file_id into V_FILEID from ALD_FILE_THA where ANPHI_ID = V_ANPHI_ID and STATUS = 1;
                    UPDATE ALD_FILE_THA SET 
                    STATUS = 0,
                    ACTION = V_ACTION
                    WHERE FILE_ID  = V_FILEID;
              end if;
               end if;
   ELSIF(V_LOAIAN='6')THEN
               SELECT COUNT(*)INTO V_COUNT_TL_S FROM AHC_SOTHAM_THULY TL WHERE  EXISTS(SELECT 'X' FROM AHC_ANPHI WHERE DONID=TL.DONID AND ID=V_ANPHI_ID  AND ENABLE=1);
                    IF(V_COUNT_TL_S=0)THEN
                    select count(*) into v_count from AHC_FILE_THA where ANPHI_ID = V_ANPHI_ID and STATUS = 1;
                    if(v_count>0)then
                    select file_id into V_FILEID from AHC_FILE_THA where ANPHI_ID = V_ANPHI_ID and STATUS = 1;
                    UPDATE AHC_FILE_THA SET 
                    STATUS = 0,
                    ACTION = V_ACTION
                    WHERE FILE_ID  = V_FILEID;
                    end if;
               end if;     
  ELSIF(V_LOAIAN='7')THEN
                 SELECT COUNT(*)INTO V_COUNT_TL_S FROM APS_SOTHAM_THULY TL WHERE  EXISTS(SELECT 'X' FROM APS_ANPHI WHERE DONID=TL.DONID AND ID=V_ANPHI_ID  AND ENABLE=1);
                    IF(V_COUNT_TL_S=0)THEN
                    select count(*) into v_count from APS_FILE_THA where ANPHI_ID = V_ANPHI_ID and STATUS = 1;
                    if(v_count>0)then
                    select file_id into V_FILEID from APS_FILE_THA where ANPHI_ID = V_ANPHI_ID and STATUS = 1;
                    UPDATE APS_FILE_THA SET 
                    STATUS = 0,
                    ACTION = V_ACTION
                    WHERE FILE_ID  = V_FILEID;
                    end if;
               end if;             
     END IF;
     V_COUNT_TL:=V_COUNT_TL_S;
END ANPHI_FILE_UPD_XOA;
PROCEDURE ANPHI_FILE_UPD
( 
    V_LOAIAN in varchar2,
    V_ANPHI_ID  in number,
    V_FILE_NAME  in varchar2,
    V_FILE_DATA  blob,
    V_FILE_TYLE  varchar2,
    V_ACTION varchar2 ---A Thêm mới, S Thay thế, X Xóa file 
)IS 
    V_FILEID NUMBER;V_COUNT NUMBER:=0;VV_ACTION VARCHAR2(50);
BEGIN
VV_ACTION:=V_ACTION;
    -- STATUS 1 đang sử dụng, 0 ko sử dụng
    --cap nhat file moi
    IF(V_LOAIAN='2')THEN
            -- chập nhật lại các file dinh kem nay sang trạng thai khong su dung
             select count(*) into v_count from ADS_FILE_THA where ANPHI_ID = V_ANPHI_ID;
                if(v_count>0)then
                    UPDATE ADS_FILE_THA
                    SET  STATUS = 0
                    WHERE ANPHI_ID = V_ANPHI_ID;
                    VV_ACTION:='S';
             end if;
            -- insert file tong dat moi khi la them moi,sua
            INSERT INTO ADS_FILE_THA(FILE_ID, ANPHI_ID ,FILE_DATA,FILE_TYLE,FILE_NAME,STATUS,ACTION,FILE_DATE)
                    VALUES (ADS_FILE_THA_SEQ.nextval,V_ANPHI_ID,V_FILE_DATA,V_FILE_TYLE,V_FILE_NAME,1,VV_ACTION,SYSDATE);
       elsif(V_LOAIAN='3')THEN   
              -- chập nhật lại các file dinh kem nay sang trạng thai khong su dung
             select count(*) into v_count from AHN_FILE_THA where ANPHI_ID = V_ANPHI_ID;
                if(v_count>0)then
                    UPDATE AHN_FILE_THA
                    SET  STATUS = 0
                    WHERE ANPHI_ID = V_ANPHI_ID;
                    VV_ACTION:='S';
             end if;
            -- insert file tong dat moi khi la them moi,sua
            INSERT INTO AHN_FILE_THA (FILE_ID, ANPHI_ID ,FILE_DATA,FILE_TYLE,FILE_NAME,STATUS,ACTION,FILE_DATE)
                    VALUES (AHN_FILE_THA_SEQ.nextval,V_ANPHI_ID,V_FILE_DATA,V_FILE_TYLE,V_FILE_NAME,1,VV_ACTION,SYSDATE);
        elsif(V_LOAIAN='4')THEN   
              -- chập nhật lại các file dinh kem nay sang trạng thai khong su dung
             select count(*) into v_count from AKT_FILE_THA where ANPHI_ID = V_ANPHI_ID;
                if(v_count>0)then
                    UPDATE AKT_FILE_THA
                    SET  STATUS = 0
                    WHERE ANPHI_ID = V_ANPHI_ID;
                    VV_ACTION:='S';
             end if;
            -- insert file tong dat moi khi la them moi,sua
            INSERT INTO AKT_FILE_THA (FILE_ID, ANPHI_ID ,FILE_DATA,FILE_TYLE,FILE_NAME,STATUS,ACTION,FILE_DATE)
                    VALUES (AKT_FILE_THA_SEQ.nextval,V_ANPHI_ID,V_FILE_DATA,V_FILE_TYLE,V_FILE_NAME,1,VV_ACTION,SYSDATE);    
        elsif(V_LOAIAN='5')THEN   
              -- chập nhật lại các file dinh kem nay sang trạng thai khong su dung
             select count(*) into v_count from ALD_FILE_THA where ANPHI_ID = V_ANPHI_ID;
                if(v_count>0)then
                    UPDATE ALD_FILE_THA
                    SET  STATUS = 0
                    WHERE ANPHI_ID = V_ANPHI_ID;
                    VV_ACTION:='S';
             end if;
            -- insert file tong dat moi khi la them moi,sua
            INSERT INTO ALD_FILE_THA (FILE_ID, ANPHI_ID ,FILE_DATA,FILE_TYLE,FILE_NAME,STATUS,ACTION,FILE_DATE)
                    VALUES (ALD_FILE_THA_SEQ.nextval,V_ANPHI_ID,V_FILE_DATA,V_FILE_TYLE,V_FILE_NAME,1,VV_ACTION,SYSDATE);    
         elsif(V_LOAIAN='6')THEN   
              -- chập nhật lại các file dinh kem nay sang trạng thai khong su dung
             select count(*) into v_count from AHC_FILE_THA where ANPHI_ID = V_ANPHI_ID;
                if(v_count>0)then
                    UPDATE AHC_FILE_THA
                    SET  STATUS = 0
                    WHERE ANPHI_ID = V_ANPHI_ID;
                    VV_ACTION:='S';
             end if;
            -- insert file tong dat moi khi la them moi,sua
            INSERT INTO AHC_FILE_THA (FILE_ID, ANPHI_ID ,FILE_DATA,FILE_TYLE,FILE_NAME,STATUS,ACTION,FILE_DATE)
                    VALUES (AHC_FILE_THA_SEQ.nextval,V_ANPHI_ID,V_FILE_DATA,V_FILE_TYLE,V_FILE_NAME,1,VV_ACTION,SYSDATE);           
         elsif(V_LOAIAN='7')THEN   
              -- chập nhật lại các file dinh kem nay sang trạng thai khong su dung
             select count(*) into v_count from APS_FILE_THA where ANPHI_ID = V_ANPHI_ID;
                if(v_count>0)then
                    UPDATE APS_FILE_THA
                    SET  STATUS = 0
                    WHERE ANPHI_ID = V_ANPHI_ID;
                    VV_ACTION:='S';
             end if;
            -- insert file tong dat moi khi la them moi,sua
            INSERT INTO APS_FILE_THA (FILE_ID, ANPHI_ID ,FILE_DATA,FILE_TYLE,FILE_NAME,STATUS,ACTION,FILE_DATE)
                    VALUES (APS_FILE_THA_SEQ.nextval,V_ANPHI_ID,V_FILE_DATA,V_FILE_TYLE,V_FILE_NAME,1,VV_ACTION,SYSDATE);           
        end if;
END ANPHI_FILE_UPD;
PROCEDURE GET_ANPHI_FILE
  (
     V_LOAI_AN IN VARCHAR2 DEFAULT NULL ,
     V_ANPHI_ID in number,
     V_FILE_NAME OUT VARCHAR2,
     ITEMS_CURSOR OUT SYS_REFCURSOR
  )    
    AS
    V_COUNT_CHECK NUMBER(10,0);
 BEGIN
  IF(V_LOAI_AN='2')THEN
            SELECT COUNT(*) INTO V_COUNT_CHECK FROM ADS_FILE_THA PF WHERE PF.ANPHI_ID=V_ANPHI_ID AND PF.STATUS=1;
            IF(V_COUNT_CHECK>0) THEN
            SELECT PF.FILE_NAME INTO V_FILE_NAME FROM ADS_FILE_THA PF WHERE PF.ANPHI_ID=V_ANPHI_ID AND PF.STATUS=1;
            END IF;
            ----
            OPEN ITEMS_CURSOR FOR
            SELECT PF.FILE_DATA FROM ADS_FILE_THA PF WHERE PF.ANPHI_ID=V_ANPHI_ID AND PF.STATUS=1;
     ELSIF(V_LOAI_AN='3')THEN
            SELECT COUNT(*) INTO V_COUNT_CHECK FROM AHN_FILE_THA PF WHERE PF.ANPHI_ID=V_ANPHI_ID AND PF.STATUS=1;
            IF(V_COUNT_CHECK>0) THEN
            SELECT PF.FILE_NAME INTO V_FILE_NAME FROM AHN_FILE_THA PF WHERE PF.ANPHI_ID=V_ANPHI_ID AND PF.STATUS=1;
            END IF;
            ----
            OPEN ITEMS_CURSOR FOR
            SELECT PF.FILE_DATA FROM AHN_FILE_THA PF WHERE PF.ANPHI_ID=V_ANPHI_ID AND PF.STATUS=1;  
    ELSIF(V_LOAI_AN='4')THEN
            SELECT COUNT(*) INTO V_COUNT_CHECK FROM AKT_FILE_THA PF WHERE PF.ANPHI_ID=V_ANPHI_ID AND PF.STATUS=1;
            IF(V_COUNT_CHECK>0) THEN
            SELECT PF.FILE_NAME INTO V_FILE_NAME FROM AKT_FILE_THA PF WHERE PF.ANPHI_ID=V_ANPHI_ID AND PF.STATUS=1;
            END IF;
            ----
            OPEN ITEMS_CURSOR FOR
            SELECT PF.FILE_DATA FROM AKT_FILE_THA PF WHERE PF.ANPHI_ID=V_ANPHI_ID AND PF.STATUS=1;      
     ELSIF(V_LOAI_AN='5')THEN
            SELECT COUNT(*) INTO V_COUNT_CHECK FROM ALD_FILE_THA PF WHERE PF.ANPHI_ID=V_ANPHI_ID AND PF.STATUS=1;
            IF(V_COUNT_CHECK>0) THEN
            SELECT PF.FILE_NAME INTO V_FILE_NAME FROM ALD_FILE_THA PF WHERE PF.ANPHI_ID=V_ANPHI_ID AND PF.STATUS=1;
            END IF;
            ----
            OPEN ITEMS_CURSOR FOR
            SELECT PF.FILE_DATA FROM ALD_FILE_THA PF WHERE PF.ANPHI_ID=V_ANPHI_ID AND PF.STATUS=1; 
      ELSIF(V_LOAI_AN='6')THEN
            SELECT COUNT(*) INTO V_COUNT_CHECK FROM AHC_FILE_THA PF WHERE PF.ANPHI_ID=V_ANPHI_ID AND PF.STATUS=1;
            IF(V_COUNT_CHECK>0) THEN
            SELECT PF.FILE_NAME INTO V_FILE_NAME FROM AHC_FILE_THA PF WHERE PF.ANPHI_ID=V_ANPHI_ID AND PF.STATUS=1;
            END IF;
            ----
            OPEN ITEMS_CURSOR FOR
            SELECT PF.FILE_DATA FROM AHC_FILE_THA PF WHERE PF.ANPHI_ID=V_ANPHI_ID AND PF.STATUS=1; 
       ELSIF(V_LOAI_AN='7')THEN
            SELECT COUNT(*) INTO V_COUNT_CHECK FROM APS_FILE_THA PF WHERE PF.ANPHI_ID=V_ANPHI_ID AND PF.STATUS=1;
            IF(V_COUNT_CHECK>0) THEN
            SELECT PF.FILE_NAME INTO V_FILE_NAME FROM APS_FILE_THA PF WHERE PF.ANPHI_ID=V_ANPHI_ID AND PF.STATUS=1;
            END IF;
            ----
            OPEN ITEMS_CURSOR FOR
            SELECT PF.FILE_DATA FROM APS_FILE_THA PF WHERE PF.ANPHI_ID=V_ANPHI_ID AND PF.STATUS=1;        
      END IF;
END GET_ANPHI_FILE;
PROCEDURE GET_THONGBAO_AP_FILE
  (
     V_LOAI_AN IN VARCHAR2 DEFAULT NULL ,
     V_FILEID in NUMBER,
     V_TENFILE OUT VARCHAR2,
     ITEMS_CURSOR OUT SYS_REFCURSOR
  )    
    AS
     V_COUNT_CHECK NUMBER(10,0);
 BEGIN
IF(V_LOAI_AN='2')THEN
            SELECT COUNT(*) INTO V_COUNT_CHECK FROM ADS_FILE PF WHERE PF.ID=V_FILEID;
            IF(V_COUNT_CHECK>0) THEN
            SELECT PF.TENFILE INTO V_TENFILE FROM ADS_FILE PF WHERE PF.ID=V_FILEID;
            END IF;
            ----
            OPEN ITEMS_CURSOR FOR
            SELECT PF.NOIDUNG FROM ADS_FILE PF WHERE PF.ID=V_FILEID;
     ELSIF(V_LOAI_AN='3')THEN
            SELECT COUNT(*) INTO V_COUNT_CHECK FROM AHN_FILE PF WHERE PF.ID=V_FILEID;
            IF(V_COUNT_CHECK>0) THEN
            SELECT PF.TENFILE INTO V_TENFILE FROM AHN_FILE PF WHERE PF.ID=V_FILEID;
            END IF;
            ----
            OPEN ITEMS_CURSOR FOR
            SELECT PF.NOIDUNG FROM AHN_FILE PF WHERE PF.ID=V_FILEID;  
    ELSIF(V_LOAI_AN='4')THEN
            SELECT COUNT(*) INTO V_COUNT_CHECK FROM AKT_FILE PF WHERE PF.ID=V_FILEID;
            IF(V_COUNT_CHECK>0) THEN
            SELECT PF.TENFILE INTO V_TENFILE FROM AKT_FILE PF WHERE PF.ID=V_FILEID;
            END IF;
            ----
            OPEN ITEMS_CURSOR FOR
            SELECT PF.NOIDUNG FROM AKT_FILE PF WHERE PF.ID=V_FILEID;      
     ELSIF(V_LOAI_AN='5')THEN
            SELECT COUNT(*) INTO V_COUNT_CHECK FROM ALD_FILE PF WHERE PF.ID=V_FILEID;
            IF(V_COUNT_CHECK>0) THEN
            SELECT PF.TENFILE INTO V_TENFILE FROM ALD_FILE PF WHERE PF.ID=V_FILEID;
            END IF;
            ----
            OPEN ITEMS_CURSOR FOR
            SELECT PF.NOIDUNG FROM ALD_FILE PF WHERE PF.ID=V_FILEID; 
      ELSIF(V_LOAI_AN='6')THEN
            SELECT COUNT(*) INTO V_COUNT_CHECK FROM AHC_FILE PF WHERE PF.ID=V_FILEID;
            IF(V_COUNT_CHECK>0) THEN
            SELECT PF.TENFILE INTO V_TENFILE FROM AHC_FILE PF WHERE PF.ID=V_FILEID;
            END IF;
            ----
            OPEN ITEMS_CURSOR FOR
            SELECT PF.NOIDUNG FROM AHC_FILE PF WHERE PF.ID=V_FILEID; 
       ELSIF(V_LOAI_AN='7')THEN
            SELECT COUNT(*) INTO V_COUNT_CHECK FROM APS_FILE PF WHERE PF.ID=V_FILEID;
            IF(V_COUNT_CHECK>0) THEN
            SELECT PF.TENFILE INTO V_TENFILE FROM APS_FILE PF WHERE PF.ID=V_FILEID;
            END IF;
            ----
            OPEN ITEMS_CURSOR FOR
            SELECT PF.NOIDUNG FROM APS_FILE PF WHERE PF.ID=V_FILEID;        
      END IF;
END GET_THONGBAO_AP_FILE;
FUNCTION TC_DANHSACH_ANPHI 
(
  V_TRANG_THAI IN VARCHAR2 DEFAULT NULL, 
  V_FILE_THA IN VARCHAR2 DEFAULT NULL, 
  V_GET_CHIL IN VARCHAR2 DEFAULT NULL, 
  V_LOAI_AN IN VARCHAR2 DEFAULT NULL, 
  V_TT_TRUCTUYEN IN VARCHAR2 DEFAULT NULL, 
  V_DATE_FROM IN VARCHAR2 DEFAULT NULL,  
  V_DATE_TO IN VARCHAR2 DEFAULT NULL, 
  V_STATUS IN NVARCHAR2 DEFAULT NULL,
  V_USERNAME IN NVARCHAR2 DEFAULT NULL,
  V_DONVITHA_ID IN NVARCHAR2 DEFAULT NULL,
  vTuKhoaBasic IN NVARCHAR2 DEFAULT NULL,
  PageIndex	in	int,
  PageSize	in	int
)
RETURN SYS_REFCURSOR
AS
      MININDEX	number;v_table T_TUPHAP_ANPHI;
      MAXINDEX	number;V_LOAITOA VARCHAR2(150):=NULL;V_TUNGAY DATE;V_DENNGAY DATE;
      V_CURSOR sys_refcursor;var_arrsx  varchar2(250);
begin
  v_table := T_TUPHAP_ANPHI(); --dung bang ding nghia
  MININDEX := pagesize*(PAGEINDEX - 1) + 1;
  MAXINDEX := PAGEINDEX*pagesize ;
  -----------
  IF(V_DATE_FROM IS NOT NULL) THEN
        V_TUNGAY:=TO_DATE(V_DATE_FROM||'00:00:00','dd/mm/yyyy hh24:mi:ss');
     END IF;
     IF(V_DATE_TO IS NOT NULL)THEN
        V_DENNGAY:=TO_DATE(V_DATE_TO||'23:59:59','dd/mm/yyyy hh24:mi:ss');
     END IF;
 --------------
  FOR item_tp IN 
            (
                SELECT TD.NGAYTAO,THA.ID DONVITHA_ID,FL.TENFILE,'Dân sự' LOAIAN,TO_CHAR(DO.MAVUVIEC)MAVUVIEC,TD.BIEUMAUID,'2' AS MALOAIVUVIEC,TD.FILEID,TD.DONID,DU.ID DUONGSU_ID,AI.SOTHONGBAO||'/TB-TA' AS SOTHONGBAO,
                'Họ tên:<b> '||DU.TENDUONGSU||'</b><br/> Năm sinh: '||DU.NAMSINH||'<br/> CCCD: '||DU.SOCMND||'<br/> Điên thoại: '||DU.DIENTHOAI||'<br/> Email: '||DU.EMAIL||'<br/>' TENDUONGSU,DU.NAMSINH,DU.GIOITINH,DU.SOCMND,DU.DIENTHOAI,DU.EMAIL,TN.MA_TEN DONVI,AI.TAMUNGANPHI,
                DECODE(tt.TRANGTHAITHANHTOAN,0,'Chưa nộp án phí',1,'Đã nộp án phí') STATUS,HC.MA_TEN,
                DECODE(DU.TAMTRUCHITIET,NULL,HC.MA_TEN,REPLACE(DU.TAMTRUCHITIET,',')||', '||HC.MA_TEN) AS DIACHI,
                TA.HOANTRAAP_HOTEN,TA.HOANTRAAP_GIOITINH,TA.HOANTRAAP_NAMSINH,TA.HOANTRAAP_CMND,TA.HOANTRAAP_TEL,TA.HOANTRAAP_EMAIL,TA.HOANTRAAP_DIACHI,
                TA.NGAYBIENLAI,TA.SOBIENLAI,TA.NGUOITHUTIEN,DX.NGAYGQ_YC,
                TA.NOP_ISNGUYENDON,TA.NOP_GIOITINH,decode(tt.TT_TRUCTUYEN,1,TT.HOTENNGUOINOPTIEN,TA.NOP_HOTEN)NOP_HOTEN,TA.NOP_NAMSINH,decode(tt.TT_TRUCTUYEN,1,tt.SOCMNDNGUOINOP,TA.NOP_CMND)NOP_CMND,TA.NOP_TEL,TA.NOP_EMAIL,decode(tt.TT_TRUCTUYEN,1,TT.DIACHINGUOINOPTIEN,TA.NOP_DIACHI)NOP_DIACHI,TA.HOANTRAAP_ISNGUYENDON,DU.LOAIDUONGSU               
                ,TA.ANPHIHOANTRA,TA.NGAYHOANTRA,DECODE(DC.DONID,NULL,0,1) DINHCHI,TT.MA_THONGBAO,TT.TT_TRUCTUYEN,BL.FILE_NAME,TT.TRANGTHAITHANHTOAN,AI.ID ANPHI_ID,TT.ID DVCQG_TT_ID,AI.NGAYTHONGBAO
                ,FA.FILE_NAME ANPHI_FILE_NAME,TA.NGUOISUA,TA.NGAYSUA,TA.ID TUPHAP_ANPHI_ID
                FROM ADS_TONGDAT TD 
                INNER JOIN ADS_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN ADS_ANPHI AI ON TD.DONID=AI.DONID
                LEFT JOIN (select ANPHI_ID,FILE_NAME from ADS_FILE_THA WHERE STATUS=1) FA ON FA.ANPHI_ID=AI.ID
                --  LEFT JOIN (select ANPHI_ID,FILE_NAME from ADS_FILE_THA WHERE STATUS=1) FA ON FA.ANPHI_ID=AI.ID
                INNER JOIN ADS_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
               -- INNER JOIN ADS_TONGDAT_DOITUONG DO ON DO.DUONGSUID =DU.id
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN ADS_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN ADS_FILE FL ON FL.id=TD.FILEID --AND FL.BIEUMAUID=67
                LEFT JOIN (SELECT QD.DONID FROM ADS_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi    
                LEFT JOIN DVCQG_THANH_TOAN TT ON tt.DUONGSU_ID=AI.DUONGSU_ID AND TT.ANPHI_ID=AI.ID AND TT.MALOAIVUVIEC='2'
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.DUONGSU_ID=TT.DUONGSU_ID AND TA.anphi_id=AI.ID AND TA.MALOAIVUVIEC='2'
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                 --16/03/2025 NGAYPHATHANH 
               LEFT JOIN(select decode(tts.NGAYNHANTONGDAT,null,tts.NGAYNHANTONGDATS,tts.NGAYNHANTONGDAT)NGAYNHANTONGDAT
                              ,decode(tts.NGAYPHATHANH,null,tts.NGAYPHATHANHS,tts.NGAYPHATHANH)NGAYPHATHANH
                              ,DECODE(TTS.DUONGSUID,NULL,TTS.DUONGSUIDS,TTS.DUONGSUID)DUONGSUID,TTS.tongdatid 
                              from(SELECT SUBSTR(TT.NGAYNHANTONGDATS,0,instr(TT.NGAYNHANTONGDATS,',')-1)NGAYNHANTONGDAT
                                 ,SUBSTR(TT.NGAYPHATHANHS,0,instr(TT.NGAYPHATHANHS,',')-1)NGAYPHATHANH
                                 ,SUBSTR(TT.DUONGSUIDS,0,instr(TT.DUONGSUIDS,',')-1)DUONGSUID
                                 ,TT.NGAYNHANTONGDATS
                                 ,TT.NGAYPHATHANHS
                                 ,TT.DUONGSUIDS,TT.tongdatid
                                  FROM (    select tongdatid,LISTAGG(DUONGSUID, ',')WITHIN GROUP (ORDER BY NGAYGUI)DUONGSUIDS,
                                            LISTAGG(NGAYNHANTONGDAT,',')WITHIN GROUP (ORDER BY NGAYGUI)NGAYNHANTONGDATS,
                                            LISTAGG(NGAYPHATHANH,',')WITHIN GROUP (ORDER BY NGAYGUI)NGAYPHATHANHS 
                                            from ADS_TONGDAT_DOITUONG
                                            group by tongdatid 
                                        )TT 
                                 )tts
                          )DT on DT.tongdatid=TD.ID and instr(','||TT.DUONGSU_ID||',',','||DT.DUONGSUID||',')>0 
                WHERE DU.TUCACHTOTUNG_MA='NGUYENDON' AND TD.BIEUMAUID IN(67,381) --Thông báo nộp tiền tạm ứng án phí               
                AND AI.TAMUNGANPHI !=0
                AND DT.NGAYPHATHANH IS NOT NULL
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := R_TUPHAP_ANPHI(
        item_tp.NGAYTAO, item_tp.DONVITHA_ID,item_tp.TENFILE,item_tp.LOAIAN,item_tp.MAVUVIEC,item_tp.BIEUMAUID,item_tp.MALOAIVUVIEC,item_tp.FILEID,item_tp.DONID,item_tp.DUONGSU_ID,
        item_tp.SOTHONGBAO,item_tp.TENDUONGSU,item_tp.NAMSINH,item_tp.GIOITINH,item_tp.SOCMND,item_tp.DIENTHOAI,item_tp.EMAIL,item_tp.DONVI,item_tp.TAMUNGANPHI,item_tp.STATUS,item_tp.MA_TEN,item_tp.DIACHI,
        item_tp.HOANTRAAP_HOTEN,item_tp.HOANTRAAP_GIOITINH,item_tp.HOANTRAAP_NAMSINH,item_tp.HOANTRAAP_CMND,item_tp.HOANTRAAP_TEL,item_tp.HOANTRAAP_EMAIL,item_tp.HOANTRAAP_DIACHI,item_tp.NGAYBIENLAI,item_tp.SOBIENLAI,item_tp.NGUOITHUTIEN,item_tp.NGAYGQ_YC,
        item_tp.NOP_ISNGUYENDON,item_tp.NOP_GIOITINH,item_tp.NOP_HOTEN,item_tp.NOP_NAMSINH,item_tp.NOP_CMND,item_tp.NOP_TEL,item_tp.NOP_EMAIL,item_tp.NOP_DIACHI,item_tp.HOANTRAAP_ISNGUYENDON,item_tp.LOAIDUONGSU
        ,item_tp.ANPHIHOANTRA,item_tp.NGAYHOANTRA,item_tp.DINHCHI,item_tp.MA_THONGBAO,item_tp.TT_TRUCTUYEN,item_tp.FILE_NAME,NULL,item_tp.TRANGTHAITHANHTOAN,item_tp.ANPHI_ID,item_tp.DVCQG_TT_ID,item_tp.NGAYTHONGBAO
        ,item_tp.ANPHI_FILE_NAME,item_tp.NGAYSUA,item_tp.NGUOISUA,item_tp.TUPHAP_ANPHI_ID);  
    END LOOP;
      -----------
     FOR item_tp IN 
            (
                SELECT TD.NGAYTAO,THA.ID DONVITHA_ID,FL.TENFILE,'Hôn nhân ' LOAIAN,DO.MAVUVIEC,TD.BIEUMAUID,'3' AS MALOAIVUVIEC,TD.FILEID,TD.DONID,0 DUONGSU_ID,AI.SOTHONGBAO||'/TB-TA' AS SOTHONGBAO,
                AP.TENDUONGSU,null NAMSINH,null GIOITINH,null SOCMND,null DIENTHOAI,null EMAIL,TN.MA_TEN DONVI,AI.TAMUNGANPHI,
                DECODE(tt.TRANGTHAITHANHTOAN,0,'Chưa nộp án phí',1,'Đã nộp án phí') STATUS,null MA_TEN,
                null AS DIACHI,
                TA.HOANTRAAP_HOTEN,TA.HOANTRAAP_GIOITINH,TA.HOANTRAAP_NAMSINH,TA.HOANTRAAP_CMND,TA.HOANTRAAP_TEL,TA.HOANTRAAP_EMAIL,TA.HOANTRAAP_DIACHI,
                TA.NGAYBIENLAI,TA.SOBIENLAI,TA.NGUOITHUTIEN,DX.NGAYGQ_YC,
                TA.NOP_ISNGUYENDON,TA.NOP_GIOITINH,decode(tt.TT_TRUCTUYEN,1,TT.HOTENNGUOINOPTIEN,TA.NOP_HOTEN)NOP_HOTEN,TA.NOP_NAMSINH,decode(tt.TT_TRUCTUYEN,1,tt.SOCMNDNGUOINOP,TA.NOP_CMND)NOP_CMND,TA.NOP_TEL,TA.NOP_EMAIL,decode(tt.TT_TRUCTUYEN,1,TT.DIACHINGUOINOPTIEN,TA.NOP_DIACHI)NOP_DIACHI,TA.HOANTRAAP_ISNGUYENDON,null LOAIDUONGSU
                ,TA.ANPHIHOANTRA,TA.NGAYHOANTRA,DECODE(DC.DONID,NULL,0,1) DINHCHI,TT.MA_THONGBAO,TT.TT_TRUCTUYEN,BL.FILE_NAME, AI.DUONGSU_IDS,TT.TRANGTHAITHANHTOAN,AI.ID ANPHI_ID,TT.ID DVCQG_TT_ID,AI.NGAYTHONGBAO
                ,FA.FILE_NAME ANPHI_FILE_NAME,TA.NGUOISUA,TA.NGAYSUA,TA.ID TUPHAP_ANPHI_ID
                FROM AHN_TONGDAT TD 
                INNER JOIN AHN_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN AHN_ANPHI AI ON TD.DONID=AI.DONID
                LEFT JOIN (select ANPHI_ID,FILE_NAME from AHN_FILE_THA WHERE STATUS=1) FA ON FA.ANPHI_ID=AI.ID
                LEFT JOIN (SELECT LISTAGG('Họ tên:<b> '||HN.TENDUONGSU||'</b><br/> Năm sinh: '||HN.NAMSINH||'<br/> CCCD: '||HN.SOCMND||'<br/> Điên thoại: '||HN.DIENTHOAI||'<br/> Email: '||HN.EMAIL||'<br/>', '')
                                   WITHIN GROUP (ORDER BY 'Họ tên:<b> '||HN.TENDUONGSU||'</b><br/> Năm sinh: '||HN.NAMSINH||'<br/> CCCD: '||HN.SOCMND||'<br/> Điên thoại: '||HN.DIENTHOAI||'<br/> Email: '||HN.EMAIL||'<br/>') TENDUONGSU ,
                             DU.ANPHI_ID
                             FROM AHN_ANPHI_DUONGSU DU LEFT JOIN AHN_DON_DUONGSU HN ON HN.ID=DU.DUONGSU_ID
                             GROUP BY DU.ANPHI_ID
                          )AP ON AP.ANPHI_ID=AI.ID
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                LEFT JOIN AHN_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN AHN_FILE FL ON FL.id=TD.FILEID
                LEFT JOIN TUPHAP_ANPHI TA ON TA.anphi_id=AI.ID and TA.VUVIECID=TD.DONID AND TA.MALOAIVUVIEC='3'
                LEFT JOIN (SELECT QD.DONID FROM AHN_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
                LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.ANPHI_ID=AI.ID AND TT.MALOAIVUVIEC='3'
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                 --16/03/2025 NGAYPHATHANH 
                LEFT JOIN(select decode(tts.NGAYNHANTONGDAT,null,tts.NGAYNHANTONGDATS,tts.NGAYNHANTONGDAT)NGAYNHANTONGDAT
                              ,decode(tts.NGAYPHATHANH,null,tts.NGAYPHATHANHS,tts.NGAYPHATHANH)NGAYPHATHANH
                              ,DECODE(TTS.DUONGSUID,NULL,TTS.DUONGSUIDS,TTS.DUONGSUID)DUONGSUID,TTS.tongdatid 
                              from(SELECT SUBSTR(TT.NGAYNHANTONGDATS,0,instr(TT.NGAYNHANTONGDATS,',')-1)NGAYNHANTONGDAT
                                 ,SUBSTR(TT.NGAYPHATHANHS,0,instr(TT.NGAYPHATHANHS,',')-1)NGAYPHATHANH
                                 ,SUBSTR(TT.DUONGSUIDS,0,instr(TT.DUONGSUIDS,',')-1)DUONGSUID
                                 ,TT.NGAYNHANTONGDATS
                                 ,TT.NGAYPHATHANHS
                                 ,TT.DUONGSUIDS,TT.tongdatid
                                  FROM (    select tongdatid,LISTAGG(DUONGSUID, ',')WITHIN GROUP (ORDER BY NGAYGUI)DUONGSUIDS,
                                            LISTAGG(NGAYNHANTONGDAT,',')WITHIN GROUP (ORDER BY NGAYGUI)NGAYNHANTONGDATS,
                                            LISTAGG(NGAYPHATHANH,',')WITHIN GROUP (ORDER BY NGAYGUI)NGAYPHATHANHS 
                                            from AHN_TONGDAT_DOITUONG
                                            group by tongdatid 
                                        )TT 
                                 )tts
                          )DT on DT.tongdatid=TD.ID and instr(','||TT.DUONGSU_ID||',',','||DT.DUONGSUID||',')>0                      
                WHERE  TD.BIEUMAUID IN(67,381)               
                AND AI.TAMUNGANPHI !=0
                AND DT.NGAYPHATHANH IS NOT NULL
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := R_TUPHAP_ANPHI(
        item_tp.NGAYTAO, item_tp.DONVITHA_ID,item_tp.TENFILE,item_tp.LOAIAN,item_tp.MAVUVIEC,item_tp.BIEUMAUID,item_tp.MALOAIVUVIEC,item_tp.FILEID,item_tp.DONID,item_tp.DUONGSU_ID,
        item_tp.SOTHONGBAO,item_tp.TENDUONGSU,item_tp.NAMSINH,item_tp.GIOITINH,item_tp.SOCMND,item_tp.DIENTHOAI,item_tp.EMAIL,item_tp.DONVI,item_tp.TAMUNGANPHI,item_tp.STATUS,item_tp.MA_TEN,item_tp.DIACHI,
        item_tp.HOANTRAAP_HOTEN,item_tp.HOANTRAAP_GIOITINH,item_tp.HOANTRAAP_NAMSINH,item_tp.HOANTRAAP_CMND,item_tp.HOANTRAAP_TEL,item_tp.HOANTRAAP_EMAIL,item_tp.HOANTRAAP_DIACHI,item_tp.NGAYBIENLAI,item_tp.SOBIENLAI,item_tp.NGUOITHUTIEN,item_tp.NGAYGQ_YC,
        item_tp.NOP_ISNGUYENDON,item_tp.NOP_GIOITINH,item_tp.NOP_HOTEN,item_tp.NOP_NAMSINH,item_tp.NOP_CMND,item_tp.NOP_TEL,item_tp.NOP_EMAIL,item_tp.NOP_DIACHI,item_tp.HOANTRAAP_ISNGUYENDON,item_tp.LOAIDUONGSU
        ,item_tp.ANPHIHOANTRA,item_tp.NGAYHOANTRA,item_tp.DINHCHI,item_tp.MA_THONGBAO,item_tp.TT_TRUCTUYEN,item_tp.FILE_NAME,item_tp.DUONGSU_IDS,item_tp.TRANGTHAITHANHTOAN,item_tp.ANPHI_ID,item_tp.DVCQG_TT_ID,item_tp.NGAYTHONGBAO
       ,item_tp.ANPHI_FILE_NAME,item_tp.NGAYSUA,item_tp.NGUOISUA,item_tp.TUPHAP_ANPHI_ID);  
    END LOOP;
      -----------
     FOR item_tp IN 
            (
               SELECT TD.NGAYTAO,THA.ID DONVITHA_ID,FL.TENFILE,'Kinh tế' LOAIAN,DO.MAVUVIEC,DO.TENVUVIEC,TD.BIEUMAUID,'4' AS MALOAIVUVIEC,TD.FILEID,TD.DONID,DU.ID DUONGSU_ID,AI.SOTHONGBAO||'/TB-TA' AS SOTHONGBAO,
                'Họ tên:<b> '||DU.TENDUONGSU||'</b><br/> Năm sinh: '||DU.NAMSINH||'<br/> CCCD: '||DU.SOCMND||'<br/> Điên thoại: '||DU.DIENTHOAI||'<br/> Email: '||DU.EMAIL||'<br/>' TENDUONGSU,DU.NAMSINH,DU.GIOITINH,DU.SOCMND,DU.DIENTHOAI,DU.EMAIL,TN.MA_TEN DONVI,AI.TAMUNGANPHI,
                DECODE(tt.TRANGTHAITHANHTOAN,0,'Chưa nộp án phí',1,'Đã nộp án phí') STATUS,HC.MA_TEN,
                DECODE(DU.TAMTRUCHITIET,NULL,HC.MA_TEN,REPLACE(DU.TAMTRUCHITIET,',')||', '||HC.MA_TEN) AS DIACHI,
                TA.HOANTRAAP_HOTEN,TA.HOANTRAAP_GIOITINH,TA.HOANTRAAP_NAMSINH,TA.HOANTRAAP_CMND,TA.HOANTRAAP_TEL,TA.HOANTRAAP_EMAIL,TA.HOANTRAAP_DIACHI,
                TA.NGAYBIENLAI,TA.SOBIENLAI,TA.NGUOITHUTIEN,DX.NGAYGQ_YC,
                TA.NOP_ISNGUYENDON,TA.NOP_GIOITINH,decode(tt.TT_TRUCTUYEN,1,TT.HOTENNGUOINOPTIEN,TA.NOP_HOTEN)NOP_HOTEN,TA.NOP_NAMSINH,decode(tt.TT_TRUCTUYEN,1,tt.SOCMNDNGUOINOP,TA.NOP_CMND)NOP_CMND,TA.NOP_TEL,TA.NOP_EMAIL,decode(tt.TT_TRUCTUYEN,1,TT.DIACHINGUOINOPTIEN,TA.NOP_DIACHI)NOP_DIACHI,TA.HOANTRAAP_ISNGUYENDON,DU.LOAIDUONGSU
                ,TA.ANPHIHOANTRA,TA.NGAYHOANTRA,DECODE(DC.DONID,NULL,0,1) DINHCHI,TT.MA_THONGBAO,TT.TT_TRUCTUYEN,BL.FILE_NAME,TT.TRANGTHAITHANHTOAN,AI.ID ANPHI_ID,TT.ID DVCQG_TT_ID,AI.NGAYTHONGBAO
                ,FA.FILE_NAME ANPHI_FILE_NAME,TA.NGUOISUA,TA.NGAYSUA,TA.ID TUPHAP_ANPHI_ID
                FROM AKT_TONGDAT TD 
                INNER JOIN AKT_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN AKT_ANPHI AI ON TD.DONID=AI.DONID
                LEFT JOIN (select ANPHI_ID,FILE_NAME from AKT_FILE_THA WHERE STATUS=1) FA ON FA.ANPHI_ID=AI.ID
                INNER JOIN AKT_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
                --INNER JOIN AKT_TONGDAT_DOITUONG DO ON DO.DUONGSUID =DU.id
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN AKT_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.anphi_id=AI.ID AND TA.MALOAIVUVIEC='4'
                LEFT JOIN AKT_FILE FL ON FL.id=TD.FILEID
                LEFT JOIN (SELECT QD.DONID FROM AKT_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
                LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.ANPHI_ID=AI.ID AND TT.MALOAIVUVIEC='4'
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                --16/03/2025 NGAYPHATHANH 
                LEFT JOIN(select decode(tts.NGAYNHANTONGDAT,null,tts.NGAYNHANTONGDATS,tts.NGAYNHANTONGDAT)NGAYNHANTONGDAT
                              ,decode(tts.NGAYPHATHANH,null,tts.NGAYPHATHANHS,tts.NGAYPHATHANH)NGAYPHATHANH
                              ,DECODE(TTS.DUONGSUID,NULL,TTS.DUONGSUIDS,TTS.DUONGSUID)DUONGSUID,TTS.tongdatid 
                              from(SELECT SUBSTR(TT.NGAYNHANTONGDATS,0,instr(TT.NGAYNHANTONGDATS,',')-1)NGAYNHANTONGDAT
                                 ,SUBSTR(TT.NGAYPHATHANHS,0,instr(TT.NGAYPHATHANHS,',')-1)NGAYPHATHANH
                                 ,SUBSTR(TT.DUONGSUIDS,0,instr(TT.DUONGSUIDS,',')-1)DUONGSUID
                                 ,TT.NGAYNHANTONGDATS
                                 ,TT.NGAYPHATHANHS
                                 ,TT.DUONGSUIDS,TT.tongdatid
                                  FROM (    select tongdatid,LISTAGG(DUONGSUID, ',')WITHIN GROUP (ORDER BY NGAYGUI)DUONGSUIDS,
                                            LISTAGG(NGAYNHANTONGDAT,',')WITHIN GROUP (ORDER BY NGAYGUI)NGAYNHANTONGDATS,
                                            LISTAGG(NGAYPHATHANH,',')WITHIN GROUP (ORDER BY NGAYGUI)NGAYPHATHANHS 
                                            from AKT_TONGDAT_DOITUONG
                                            group by tongdatid 
                                        )TT 
                                 )tts
                          )DT on DT.tongdatid=TD.ID and instr(','||TT.DUONGSU_ID||',',','||DT.DUONGSUID||',')>0                      
                WHERE DU.TUCACHTOTUNG_MA='NGUYENDON' AND TD.BIEUMAUID IN(67,381)--Thông báo nộp tiền tạm ứng án phí               
                AND AI.TAMUNGANPHI !=0
                AND DT.NGAYPHATHANH IS NOT NULL  
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := R_TUPHAP_ANPHI(
        item_tp.NGAYTAO, item_tp.DONVITHA_ID,item_tp.TENFILE,item_tp.LOAIAN,item_tp.MAVUVIEC,item_tp.BIEUMAUID,item_tp.MALOAIVUVIEC,item_tp.FILEID,item_tp.DONID,item_tp.DUONGSU_ID,
        item_tp.SOTHONGBAO,item_tp.TENDUONGSU,item_tp.NAMSINH,item_tp.GIOITINH,item_tp.SOCMND,item_tp.DIENTHOAI,item_tp.EMAIL,item_tp.DONVI,item_tp.TAMUNGANPHI,item_tp.STATUS,item_tp.MA_TEN,item_tp.DIACHI,
        item_tp.HOANTRAAP_HOTEN,item_tp.HOANTRAAP_GIOITINH,item_tp.HOANTRAAP_NAMSINH,item_tp.HOANTRAAP_CMND,item_tp.HOANTRAAP_TEL,item_tp.HOANTRAAP_EMAIL,item_tp.HOANTRAAP_DIACHI,item_tp.NGAYBIENLAI,item_tp.SOBIENLAI,item_tp.NGUOITHUTIEN,item_tp.NGAYGQ_YC,
        item_tp.NOP_ISNGUYENDON,item_tp.NOP_GIOITINH,item_tp.NOP_HOTEN,item_tp.NOP_NAMSINH,item_tp.NOP_CMND,item_tp.NOP_TEL,item_tp.NOP_EMAIL,item_tp.NOP_DIACHI,item_tp.HOANTRAAP_ISNGUYENDON,item_tp.LOAIDUONGSU
        ,item_tp.ANPHIHOANTRA,item_tp.NGAYHOANTRA,item_tp.DINHCHI,item_tp.MA_THONGBAO,item_tp.TT_TRUCTUYEN,item_tp.FILE_NAME,NULL,item_tp.TRANGTHAITHANHTOAN,item_tp.ANPHI_ID,item_tp.DVCQG_TT_ID,item_tp.NGAYTHONGBAO
       ,item_tp.ANPHI_FILE_NAME,item_tp.NGAYSUA,item_tp.NGUOISUA,item_tp.TUPHAP_ANPHI_ID);  
    END LOOP;
       -----------
     FOR item_tp IN 
            (
                SELECT TD.NGAYTAO,THA.ID DONVITHA_ID,FL.TENFILE,'Lao động' LOAIAN,DO.MAVUVIEC,TD.BIEUMAUID,'5' AS MALOAIVUVIEC,TD.FILEID,TD.DONID,DU.ID DUONGSU_ID,AI.SOTHONGBAO||'/TB-TA' AS SOTHONGBAO,
                'Họ tên:<b> '||DU.TENDUONGSU||'</b><br/> Năm sinh: '||DU.NAMSINH||'<br/> CCCD: '||DU.SOCMND||'<br/> Điên thoại: '||DU.DIENTHOAI||'<br/> Email: '||DU.EMAIL||'<br/>'TENDUONGSU,DU.NAMSINH,DU.GIOITINH,DU.SOCMND,DU.DIENTHOAI,DU.EMAIL,TN.MA_TEN DONVI,AI.TAMUNGANPHI,
                DECODE(tt.TRANGTHAITHANHTOAN,0,'Chưa nộp án phí',1,'Đã nộp án phí') STATUS,HC.MA_TEN,
                DECODE(DU.TAMTRUCHITIET,NULL,HC.MA_TEN,REPLACE(DU.TAMTRUCHITIET,',')||', '||HC.MA_TEN) AS DIACHI,
                TA.HOANTRAAP_HOTEN,TA.HOANTRAAP_GIOITINH,TA.HOANTRAAP_NAMSINH,TA.HOANTRAAP_CMND,TA.HOANTRAAP_TEL,TA.HOANTRAAP_EMAIL,TA.HOANTRAAP_DIACHI,
                TA.NGAYBIENLAI,TA.SOBIENLAI,TA.NGUOITHUTIEN,DX.NGAYGQ_YC,
                TA.NOP_ISNGUYENDON,TA.NOP_GIOITINH,decode(tt.TT_TRUCTUYEN,1,TT.HOTENNGUOINOPTIEN,TA.NOP_HOTEN)NOP_HOTEN,TA.NOP_NAMSINH,decode(tt.TT_TRUCTUYEN,1,tt.SOCMNDNGUOINOP,TA.NOP_CMND)NOP_CMND,TA.NOP_TEL,TA.NOP_EMAIL,decode(tt.TT_TRUCTUYEN,1,TT.DIACHINGUOINOPTIEN,TA.NOP_DIACHI)NOP_DIACHI,TA.HOANTRAAP_ISNGUYENDON,DU.LOAIDUONGSU
               ,TA.ANPHIHOANTRA,TA.NGAYHOANTRA,DECODE(DC.DONID,NULL,0,1) DINHCHI,TT.MA_THONGBAO,TT.TT_TRUCTUYEN,BL.FILE_NAME,TT.TRANGTHAITHANHTOAN,AI.ID ANPHI_ID,TT.ID DVCQG_TT_ID,AI.NGAYTHONGBAO
                ,FA.FILE_NAME ANPHI_FILE_NAME,TA.NGUOISUA,TA.NGAYSUA,TA.ID TUPHAP_ANPHI_ID
                FROM ALD_TONGDAT TD 
                INNER JOIN ALD_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN ALD_ANPHI AI ON TD.DONID=AI.DONID
                LEFT JOIN (select ANPHI_ID,FILE_NAME from ALD_FILE_THA WHERE STATUS=1) FA ON FA.ANPHI_ID=AI.ID
                INNER JOIN ALD_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
               -- INNER JOIN ALD_TONGDAT_DOITUONG DO ON DO.DUONGSUID =DU.id
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN ALD_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.anphi_id=AI.ID AND TA.MALOAIVUVIEC='5'
                LEFT JOIN ALD_FILE FL ON FL.id=TD.FILEID
                LEFT JOIN (SELECT QD.DONID FROM ALD_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
                LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.ANPHI_ID=AI.ID AND TT.MALOAIVUVIEC='5'
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                --16/03/2025 NGAYPHATHANH 
                LEFT JOIN(select decode(tts.NGAYNHANTONGDAT,null,tts.NGAYNHANTONGDATS,tts.NGAYNHANTONGDAT)NGAYNHANTONGDAT
                              ,decode(tts.NGAYPHATHANH,null,tts.NGAYPHATHANHS,tts.NGAYPHATHANH)NGAYPHATHANH
                              ,DECODE(TTS.DUONGSUID,NULL,TTS.DUONGSUIDS,TTS.DUONGSUID)DUONGSUID,TTS.tongdatid 
                              from(SELECT SUBSTR(TT.NGAYNHANTONGDATS,0,instr(TT.NGAYNHANTONGDATS,',')-1)NGAYNHANTONGDAT
                                 ,SUBSTR(TT.NGAYPHATHANHS,0,instr(TT.NGAYPHATHANHS,',')-1)NGAYPHATHANH
                                 ,SUBSTR(TT.DUONGSUIDS,0,instr(TT.DUONGSUIDS,',')-1)DUONGSUID
                                 ,TT.NGAYNHANTONGDATS
                                 ,TT.NGAYPHATHANHS
                                 ,TT.DUONGSUIDS,TT.tongdatid
                                  FROM (    select tongdatid,LISTAGG(DUONGSUID, ',')WITHIN GROUP (ORDER BY NGAYGUI)DUONGSUIDS,
                                            LISTAGG(NGAYNHANTONGDAT,',')WITHIN GROUP (ORDER BY NGAYGUI)NGAYNHANTONGDATS,
                                            LISTAGG(NGAYPHATHANH,',')WITHIN GROUP (ORDER BY NGAYGUI)NGAYPHATHANHS 
                                            from ALD_TONGDAT_DOITUONG
                                            group by tongdatid 
                                        )TT 
                                 )tts
                          )DT on DT.tongdatid=TD.ID and instr(','||TT.DUONGSU_ID||',',','||DT.DUONGSUID||',')>0                     
                WHERE DU.TUCACHTOTUNG_MA='NGUYENDON' AND TD.BIEUMAUID IN(67,381)                
                AND AI.TAMUNGANPHI !=0
                AND DT.NGAYPHATHANH IS NOT NULL
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := R_TUPHAP_ANPHI(
        item_tp.NGAYTAO, item_tp.DONVITHA_ID,item_tp.TENFILE,item_tp.LOAIAN,item_tp.MAVUVIEC,item_tp.BIEUMAUID,item_tp.MALOAIVUVIEC,item_tp.FILEID,item_tp.DONID,item_tp.DUONGSU_ID,
        item_tp.SOTHONGBAO,item_tp.TENDUONGSU,item_tp.NAMSINH,item_tp.GIOITINH,item_tp.SOCMND,item_tp.DIENTHOAI,item_tp.EMAIL,item_tp.DONVI,item_tp.TAMUNGANPHI,item_tp.STATUS,item_tp.MA_TEN,item_tp.DIACHI,
        item_tp.HOANTRAAP_HOTEN,item_tp.HOANTRAAP_GIOITINH,item_tp.HOANTRAAP_NAMSINH,item_tp.HOANTRAAP_CMND,item_tp.HOANTRAAP_TEL,item_tp.HOANTRAAP_EMAIL,item_tp.HOANTRAAP_DIACHI,item_tp.NGAYBIENLAI,item_tp.SOBIENLAI,item_tp.NGUOITHUTIEN,item_tp.NGAYGQ_YC,
        item_tp.NOP_ISNGUYENDON,item_tp.NOP_GIOITINH,item_tp.NOP_HOTEN,item_tp.NOP_NAMSINH,item_tp.NOP_CMND,item_tp.NOP_TEL,item_tp.NOP_EMAIL,item_tp.NOP_DIACHI,item_tp.HOANTRAAP_ISNGUYENDON,item_tp.LOAIDUONGSU
        ,item_tp.ANPHIHOANTRA,item_tp.NGAYHOANTRA,item_tp.DINHCHI,item_tp.MA_THONGBAO,item_tp.TT_TRUCTUYEN,item_tp.FILE_NAME,NULL,item_tp.TRANGTHAITHANHTOAN,item_tp.ANPHI_ID,item_tp.DVCQG_TT_ID,item_tp.NGAYTHONGBAO
       ,item_tp.ANPHI_FILE_NAME,item_tp.NGAYSUA,item_tp.NGUOISUA,item_tp.TUPHAP_ANPHI_ID);  
    END LOOP;
    FOR item_tp IN 
            (
            SELECT TD.NGAYTAO,THA.ID DONVITHA_ID,FL.TENFILE,'Hành chính' LOAIAN,DO.MAVUVIEC,TD.BIEUMAUID,'6' AS MALOAIVUVIEC,TD.FILEID,TD.DONID,0 DUONGSU_ID,AI.SOTHONGBAO||'/TB-TA' AS SOTHONGBAO,
                AP.TENDUONGSU,null NAMSINH,null GIOITINH,null SOCMND,null DIENTHOAI,null EMAIL,TN.MA_TEN DONVI,AI.TAMUNGANPHI,
                DECODE(tt.TRANGTHAITHANHTOAN,0,'Chưa nộp án phí',1,'Đã nộp án phí') STATUS,null MA_TEN,
                null AS DIACHI,
                TA.HOANTRAAP_HOTEN,TA.HOANTRAAP_GIOITINH,TA.HOANTRAAP_NAMSINH,TA.HOANTRAAP_CMND,TA.HOANTRAAP_TEL,TA.HOANTRAAP_EMAIL,TA.HOANTRAAP_DIACHI,
                TA.NGAYBIENLAI,TA.SOBIENLAI,TA.NGUOITHUTIEN,DX.NGAYGQ_YC,
                TA.NOP_ISNGUYENDON,TA.NOP_GIOITINH,decode(tt.TT_TRUCTUYEN,1,TT.HOTENNGUOINOPTIEN,TA.NOP_HOTEN)NOP_HOTEN,TA.NOP_NAMSINH,decode(tt.TT_TRUCTUYEN,1,tt.SOCMNDNGUOINOP,TA.NOP_CMND)NOP_CMND,TA.NOP_TEL,TA.NOP_EMAIL,decode(tt.TT_TRUCTUYEN,1,TT.DIACHINGUOINOPTIEN,TA.NOP_DIACHI)NOP_DIACHI,TA.HOANTRAAP_ISNGUYENDON,null LOAIDUONGSU
                ,TA.ANPHIHOANTRA,TA.NGAYHOANTRA,DECODE(DC.DONID,NULL,0,1) DINHCHI,TT.MA_THONGBAO,TT.TT_TRUCTUYEN,BL.FILE_NAME,AI.DUONGSU_IDS,TT.TRANGTHAITHANHTOAN,AI.ID ANPHI_ID,TT.ID DVCQG_TT_ID,AI.NGAYTHONGBAO
                 ,FA.FILE_NAME ANPHI_FILE_NAME,TA.NGUOISUA,TA.NGAYSUA,TA.ID TUPHAP_ANPHI_ID
                FROM AHC_TONGDAT TD 
                INNER JOIN AHC_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN AHC_ANPHI AI ON TD.DONID=AI.DONID
                LEFT JOIN (select ANPHI_ID,FILE_NAME from AHC_FILE_THA WHERE STATUS=1) FA ON FA.ANPHI_ID=AI.ID
                LEFT JOIN (SELECT LISTAGG('Họ tên:<b> '||HN.TENDUONGSU||'</b><br/> Năm sinh: '||HN.NAMSINH||'<br/> CCCD: '||HN.SOCMND||'<br/> Điên thoại: '||HN.DIENTHOAI||'<br/> Email: '||HN.EMAIL||'<br/>', '')
                                   WITHIN GROUP (ORDER BY 'Họ tên:<b> '||HN.TENDUONGSU||'</b><br/> Năm sinh: '||HN.NAMSINH||'<br/> CCCD: '||HN.SOCMND||'<br/> Điên thoại: '||HN.DIENTHOAI||'<br/> Email: '||HN.EMAIL||'<br/>') TENDUONGSU ,
                             DU.ANPHI_ID
                             FROM AHC_ANPHI_DUONGSU DU LEFT JOIN AHC_DON_DUONGSU HN ON HN.ID=DU.DUONGSU_ID
                             GROUP BY DU.ANPHI_ID
                          )AP ON AP.ANPHI_ID=AI.ID
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                LEFT JOIN AHC_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.anphi_id=AI.ID and TA.VUVIECID=TD.DONID AND TA.MALOAIVUVIEC='6'
                LEFT JOIN AHC_FILE FL ON FL.id=TD.FILEID
                LEFT JOIN (SELECT QD.DONID FROM AHC_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
                LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.ANPHI_ID=AI.ID AND TT.MALOAIVUVIEC='6'
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                --16/03/2025 NGAYPHATHANH 
                LEFT JOIN(select decode(tts.NGAYNHANTONGDAT,null,tts.NGAYNHANTONGDATS,tts.NGAYNHANTONGDAT)NGAYNHANTONGDAT
                              ,decode(tts.NGAYPHATHANH,null,tts.NGAYPHATHANHS,tts.NGAYPHATHANH)NGAYPHATHANH
                              ,DECODE(TTS.DUONGSUID,NULL,TTS.DUONGSUIDS,TTS.DUONGSUID)DUONGSUID,TTS.tongdatid 
                              from(SELECT SUBSTR(TT.NGAYNHANTONGDATS,0,instr(TT.NGAYNHANTONGDATS,',')-1)NGAYNHANTONGDAT
                                 ,SUBSTR(TT.NGAYPHATHANHS,0,instr(TT.NGAYPHATHANHS,',')-1)NGAYPHATHANH
                                 ,SUBSTR(TT.DUONGSUIDS,0,instr(TT.DUONGSUIDS,',')-1)DUONGSUID
                                 ,TT.NGAYNHANTONGDATS
                                 ,TT.NGAYPHATHANHS
                                 ,TT.DUONGSUIDS,TT.tongdatid
                                  FROM (    select tongdatid,LISTAGG(DUONGSUID, ',')WITHIN GROUP (ORDER BY NGAYGUI)DUONGSUIDS,
                                            LISTAGG(NGAYNHANTONGDAT,',')WITHIN GROUP (ORDER BY NGAYGUI)NGAYNHANTONGDATS,
                                            LISTAGG(NGAYPHATHANH,',')WITHIN GROUP (ORDER BY NGAYGUI)NGAYPHATHANHS 
                                            from AHC_TONGDAT_DOITUONG
                                            group by tongdatid 
                                        )TT 
                                 )tts
                          )DT on DT.tongdatid=TD.ID and instr(','||TT.DUONGSU_ID||',',','||DT.DUONGSUID||',')>0                
                WHERE TD.BIEUMAUID=121               
                AND AI.TAMUNGANPHI !=0
                AND DT.NGAYPHATHANH IS NOT NULL 
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := R_TUPHAP_ANPHI(
        item_tp.NGAYTAO, item_tp.DONVITHA_ID,item_tp.TENFILE,item_tp.LOAIAN,item_tp.MAVUVIEC,item_tp.BIEUMAUID,item_tp.MALOAIVUVIEC,item_tp.FILEID,item_tp.DONID,item_tp.DUONGSU_ID,
        item_tp.SOTHONGBAO,item_tp.TENDUONGSU,item_tp.NAMSINH,item_tp.GIOITINH,item_tp.SOCMND,item_tp.DIENTHOAI,item_tp.EMAIL,item_tp.DONVI,item_tp.TAMUNGANPHI,item_tp.STATUS,item_tp.MA_TEN,item_tp.DIACHI,
        item_tp.HOANTRAAP_HOTEN,item_tp.HOANTRAAP_GIOITINH,item_tp.HOANTRAAP_NAMSINH,item_tp.HOANTRAAP_CMND,item_tp.HOANTRAAP_TEL,item_tp.HOANTRAAP_EMAIL,item_tp.HOANTRAAP_DIACHI,item_tp.NGAYBIENLAI,item_tp.SOBIENLAI,item_tp.NGUOITHUTIEN,item_tp.NGAYGQ_YC,
        item_tp.NOP_ISNGUYENDON,item_tp.NOP_GIOITINH,item_tp.NOP_HOTEN,item_tp.NOP_NAMSINH,item_tp.NOP_CMND,item_tp.NOP_TEL,item_tp.NOP_EMAIL,item_tp.NOP_DIACHI,item_tp.HOANTRAAP_ISNGUYENDON,item_tp.LOAIDUONGSU
       ,item_tp.ANPHIHOANTRA,item_tp.NGAYHOANTRA,item_tp.DINHCHI,item_tp.MA_THONGBAO,item_tp.TT_TRUCTUYEN,item_tp.FILE_NAME,item_tp.DUONGSU_IDS,item_tp.TRANGTHAITHANHTOAN,item_tp.ANPHI_ID,item_tp.DVCQG_TT_ID,item_tp.NGAYTHONGBAO
        ,item_tp.ANPHI_FILE_NAME,item_tp.NGAYSUA,item_tp.NGUOISUA,item_tp.TUPHAP_ANPHI_ID);   
    END LOOP;
     ------------------
    FOR item_tp IN 
            (
                SELECT TD.NGAYTAO,THA.ID DONVITHA_ID,FL.TENFILE,'Phá sản' LOAIAN,DO.MAVUVIEC,TD.BIEUMAUID,'7' AS MALOAIVUVIEC,TD.FILEID,TD.DONID,DU.ID DUONGSU_ID,AI.SOTHONGBAO||'/TB-TA' AS SOTHONGBAO,
                'Họ tên:<b> '||DU.TENDUONGSU||'</b><br/> Năm sinh: '||DU.NAMSINH||'<br/> CCCD: '||DU.SOCMND||'<br/> Điên thoại: '||DU.DIENTHOAI||'<br/> Email: '||DU.EMAIL||'<br/>' TENDUONGSU,DU.NAMSINH,DU.GIOITINH,DU.SOCMND,DU.DIENTHOAI,DU.EMAIL,TN.MA_TEN DONVI,AI.TAMUNGANPHI,
                DECODE(tt.TRANGTHAITHANHTOAN,0,'Chưa nộp án phí',1,'Đã nộp án phí') STATUS,HC.MA_TEN,
                DECODE(DU.TAMTRUCHITIET,NULL,HC.MA_TEN,REPLACE(DU.TAMTRUCHITIET,',')||', '||HC.MA_TEN) AS DIACHI,
                TA.HOANTRAAP_HOTEN,TA.HOANTRAAP_GIOITINH,TA.HOANTRAAP_NAMSINH,TA.HOANTRAAP_CMND,TA.HOANTRAAP_TEL,TA.HOANTRAAP_EMAIL,TA.HOANTRAAP_DIACHI,
                TA.NGAYBIENLAI,TA.SOBIENLAI,TA.NGUOITHUTIEN,DX.NGAYGQ_YC,
                TA.NOP_ISNGUYENDON,TA.NOP_GIOITINH,decode(tt.TT_TRUCTUYEN,1,TT.HOTENNGUOINOPTIEN,TA.NOP_HOTEN)NOP_HOTEN,TA.NOP_NAMSINH,decode(tt.TT_TRUCTUYEN,1,tt.SOCMNDNGUOINOP,TA.NOP_CMND)NOP_CMND,TA.NOP_TEL,TA.NOP_EMAIL,decode(tt.TT_TRUCTUYEN,1,TT.DIACHINGUOINOPTIEN,TA.NOP_DIACHI)NOP_DIACHI,TA.HOANTRAAP_ISNGUYENDON,DU.LOAIDUONGSU
                ,TA.ANPHIHOANTRA,TA.NGAYHOANTRA,DECODE(DC.DONID,NULL,0,1) DINHCHI,TT.MA_THONGBAO,TT.TT_TRUCTUYEN,BL.FILE_NAME,TT.TRANGTHAITHANHTOAN,AI.ID ANPHI_ID,TT.ID DVCQG_TT_ID,AI.NGAYTHONGBAO
                ,FA.FILE_NAME ANPHI_FILE_NAME,TA.NGUOISUA,TA.NGAYSUA,TA.ID TUPHAP_ANPHI_ID
                FROM APS_TONGDAT TD 
                INNER JOIN APS_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN APS_ANPHI AI ON TD.DONID=AI.DONID
                LEFT JOIN (select ANPHI_ID,FILE_NAME from APS_FILE_THA WHERE STATUS=1) FA ON FA.ANPHI_ID=AI.ID
                INNER JOIN APS_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
               -- INNER JOIN APS_TONGDAT_DOITUONG DO ON DO.DUONGSUID =DU.id
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN APS_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.anphi_id=AI.ID AND TA.MALOAIVUVIEC='7'
                LEFT JOIN APS_FILE FL ON FL.id=TD.FILEID
                LEFT JOIN (SELECT QD.DONID FROM APS_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
               LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.ANPHI_ID=AI.ID AND  TT.MALOAIVUVIEC='7'
               LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
               --16/03/2025 NGAYPHATHANH 
                LEFT JOIN(select decode(tts.NGAYNHANTONGDAT,null,tts.NGAYNHANTONGDATS,tts.NGAYNHANTONGDAT)NGAYNHANTONGDAT
                              ,decode(tts.NGAYPHATHANH,null,tts.NGAYPHATHANHS,tts.NGAYPHATHANH)NGAYPHATHANH
                              ,DECODE(TTS.DUONGSUID,NULL,TTS.DUONGSUIDS,TTS.DUONGSUID)DUONGSUID,TTS.tongdatid 
                              from(SELECT SUBSTR(TT.NGAYNHANTONGDATS,0,instr(TT.NGAYNHANTONGDATS,',')-1)NGAYNHANTONGDAT
                                 ,SUBSTR(TT.NGAYPHATHANHS,0,instr(TT.NGAYPHATHANHS,',')-1)NGAYPHATHANH
                                 ,SUBSTR(TT.DUONGSUIDS,0,instr(TT.DUONGSUIDS,',')-1)DUONGSUID
                                 ,TT.NGAYNHANTONGDATS
                                 ,TT.NGAYPHATHANHS
                                 ,TT.DUONGSUIDS,TT.tongdatid
                                  FROM (    select tongdatid,LISTAGG(DUONGSUID, ',')WITHIN GROUP (ORDER BY NGAYGUI)DUONGSUIDS,
                                            LISTAGG(NGAYNHANTONGDAT,',')WITHIN GROUP (ORDER BY NGAYGUI)NGAYNHANTONGDATS,
                                            LISTAGG(NGAYPHATHANH,',')WITHIN GROUP (ORDER BY NGAYGUI)NGAYPHATHANHS 
                                            from APS_TONGDAT_DOITUONG
                                            group by tongdatid 
                                        )TT 
                                 )tts
                          )DT on DT.tongdatid=TD.ID and instr(','||TT.DUONGSU_ID||',',','||DT.DUONGSUID||',')>0                  
                WHERE DU.TUCACHTOTUNG_MA='NGUYENDON'AND TD.BIEUMAUID IN(67,381) --Thông báo nộp tiền tạm ứng án phí               
                AND AI.TAMUNGANPHI !=0
                AND DT.NGAYPHATHANH IS NOT NULL    
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := R_TUPHAP_ANPHI(
        item_tp.NGAYTAO, item_tp.DONVITHA_ID,item_tp.TENFILE,item_tp.LOAIAN,item_tp.MAVUVIEC,item_tp.BIEUMAUID,item_tp.MALOAIVUVIEC,item_tp.FILEID,item_tp.DONID,item_tp.DUONGSU_ID,
        item_tp.SOTHONGBAO,item_tp.TENDUONGSU,item_tp.NAMSINH,item_tp.GIOITINH,item_tp.SOCMND,item_tp.DIENTHOAI,item_tp.EMAIL,item_tp.DONVI,item_tp.TAMUNGANPHI,item_tp.STATUS,item_tp.MA_TEN,item_tp.DIACHI,
        item_tp.HOANTRAAP_HOTEN,item_tp.HOANTRAAP_GIOITINH,item_tp.HOANTRAAP_NAMSINH,item_tp.HOANTRAAP_CMND,item_tp.HOANTRAAP_TEL,item_tp.HOANTRAAP_EMAIL,item_tp.HOANTRAAP_DIACHI,item_tp.NGAYBIENLAI,item_tp.SOBIENLAI,item_tp.NGUOITHUTIEN,item_tp.NGAYGQ_YC,
        item_tp.NOP_ISNGUYENDON,item_tp.NOP_GIOITINH,item_tp.NOP_HOTEN,item_tp.NOP_NAMSINH,item_tp.NOP_CMND,item_tp.NOP_TEL,item_tp.NOP_EMAIL,item_tp.NOP_DIACHI,item_tp.HOANTRAAP_ISNGUYENDON,item_tp.LOAIDUONGSU
       ,item_tp.ANPHIHOANTRA,item_tp.NGAYHOANTRA,item_tp.DINHCHI,item_tp.MA_THONGBAO,item_tp.TT_TRUCTUYEN,item_tp.FILE_NAME,NULL,item_tp.TRANGTHAITHANHTOAN,item_tp.ANPHI_ID,item_tp.DVCQG_TT_ID,item_tp.NGAYTHONGBAO
       ,item_tp.ANPHI_FILE_NAME,item_tp.NGAYSUA,item_tp.NGUOISUA,item_tp.TUPHAP_ANPHI_ID);    
    END LOOP;
    ----------------------------------------
     IF(V_DONVITHA_ID IS NOT NULL) THEN
        SELECT THA.LOAITOA INTO V_LOAITOA FROM DM_DONVITHIHANHAN THA WHERE THA.ID=V_DONVITHA_ID;
         select t.ARRSAPXEP into var_arrsx from DM_DONVITHIHANHAN t where t.ID=V_DONVITHA_ID;
      END IF;
 OPEN v_cursor FOR
 select DS.* from (
                SELECT TP.NGAYTAO,TP.DONVITHA_ID,TP.TENFILE,'<b>'||TP.LOAIAN||'</b>' LOAIAN,TP.MAVUVIEC,TP.BIEUMAUID,TP.MALOAIVUVIEC,TP.FILEID,COUNT(*) OVER()COUNTALL,ROW_NUMBER() OVER (ORDER BY TP.NGAYTAO DESC,TP.DONVI) STT,
                TP.DONID,TP.DUONGSU_ID,TP.SOTHONGBAO,
                TP.TENDUONGSU,TP.NAMSINH,TP.SOCMND,TP.DIENTHOAI,TP.EMAIL,TP.DONVI,
                rtrim(to_char(TP.TAMUNGANPHI, 'FM9G999G999G999G999G999D999', 'NLS_NUMERIC_CHARACTERS='',.'''),',') TAMUNGANPHI,
                DECODE(V_STATUS,1,'','- '||TP.STATUS)STATUS,TP.DIACHI,TP.HOANTRAAP_HOTEN,TP.HOANTRAAP_NAMSINH,TP.HOANTRAAP_CMND,TP.HOANTRAAP_TEL,TP.HOANTRAAP_EMAIL,TP.HOANTRAAP_DIACHI,
                TO_CHAR(TP.NGAYBIENLAI,'dd/MM/yyyy')NGAYBIENLAI,TP.SOBIENLAI,TP.NGUOITHUTIEN,TO_CHAR(TP.NGAYGQ_YC,'dd/MM/yyyy')NGAYGQ_YC
                , rtrim(to_char(TP.ANPHIHOANTRA, 'FM9G999G999G999G999G999D999', 'NLS_NUMERIC_CHARACTERS='',.'''),',')ANPHIHOANTRA,TO_CHAR(TP.NGAYHOANTRA,'MM/dd/yyyy')NGAYHOANTRA
                ,DECODE(TP.ANPHIHOANTRA,0,'- Chưa nhận hoàn trả',null,'','- Đã nhận hoàn trả') STATUS_HOANTRA,TP.MA_THONGBAO,decode(TP.TT_TRUCTUYEN,1,'Trực tuyến','Trực tiếp') HINH_THUC,TP.TT_TRUCTUYEN,TP.FILE_NAME
                ,TP.DUONGSU_IDS,TP.TRANGTHAITHANHTOAN,TP.ANPHI_ID,TP.DVCQG_TT_ID,TO_CHAR(TP.NGAYTHONGBAO,'dd/MM/yyyy')NGAYTHONGBAO
                ,TP.ANPHI_FILE_NAME,TP.NGUOISUA,to_char(TP.NGAYSUA,'dd/MM/yyyy HH24:MI:SS')NGAYSUA,TP.TUPHAP_ANPHI_ID
                ,decode(CN.TRANG_THAI,0,'- Đang lưu',1,'- Đã gửi',2,'- Đã thu hồi',NULL)TRANG_THAI
                FROM TABLE(v_table) TP 
                LEFT JOIN DM_DONVITHIHANHAN tha on tha.id=tp.DONVITHA_ID
                LEFT JOIN TUPHAP_ANPHI_CN CN ON CN.TUPHAP_ANPHI_ID=tp.TUPHAP_ANPHI_ID
                WHERE 
--               ( (tha.ID=V_DONVITHA_ID AND ((V_GET_CHIL=1 and V_GET_CHIL is not null) or (V_GET_CHIL is null) ) ) OR( (tha.ARRSAPXEP like (var_arrsx ||'/%') or tha.ARRSAPXEP=var_arrsx) AND ((V_GET_CHIL=0 and V_GET_CHIL is not null) or (V_GET_CHIL is null) ))
--                  OR (V_DONVITHA_ID IS NULL) )
                --hien tại dang lọc tạm theo dơn vị tòa án coi như là thi hành án
                ((TP.DONVITHA_ID=V_DONVITHA_ID AND V_DONVITHA_ID IS NOT NULL AND V_LOAITOA!='TOICAO') OR (V_DONVITHA_ID IS NULL OR V_LOAITOA='TOICAO')) 

                 AND( (((UPPER(TP.TENDUONGSU) LIKE '%'||UPPER(vTuKhoaBasic)||'%') AND vTuKhoaBasic IS NOT NULL) OR (vTuKhoaBasic IS NULL))
                     OR (((UPPER(TP.SOTHONGBAO)||'/TB-TA' LIKE '%'||UPPER(vTuKhoaBasic)||'%') AND vTuKhoaBasic IS NOT NULL) OR (vTuKhoaBasic IS NULL))    
                     OR (((UPPER(TP.SOCMND) LIKE '%'||UPPER(vTuKhoaBasic)||'%') AND vTuKhoaBasic IS NOT NULL) OR (vTuKhoaBasic IS NULL))  
                     OR (((UPPER(TP.NOP_CMND) LIKE '%'||UPPER(vTuKhoaBasic)||'%') AND vTuKhoaBasic IS NOT NULL) OR (vTuKhoaBasic IS NULL)) 
                     OR (((UPPER(TP.HOANTRAAP_CMND) LIKE '%'||UPPER(vTuKhoaBasic)||'%') AND vTuKhoaBasic IS NOT NULL) OR (vTuKhoaBasic IS NULL)) 
                     OR (((UPPER(TP.MA_THONGBAO) LIKE '%'||UPPER(vTuKhoaBasic)||'%') AND vTuKhoaBasic IS NOT NULL) OR (vTuKhoaBasic IS NULL)) 
                     )
                   AND (((TP.TRANGTHAITHANHTOAN=0 AND V_STATUS=0) OR (TP.TRANGTHAITHANHTOAN=1 AND V_STATUS=1) OR (TP.TRANGTHAITHANHTOAN=1 AND TP.ANPHIHOANTRA !=0 AND V_STATUS=2) OR (TP.TRANGTHAITHANHTOAN=1  AND TP.DINHCHI=1 AND V_STATUS=3) ) OR (V_STATUS IS NULL)) --check chua nop an phi or da nop an phi or da hoan tra --OR (TP.SOBIENLAI IS NULL AND V_STATUS=3) dinh chi nop an phi
--                 AND (((TP.SOBIENLAI IS NULL AND V_STATUS=0) OR (TP.SOBIENLAI IS NOT NULL AND V_STATUS=1) OR (TP.SOBIENLAI IS NOT NULL AND TP.ANPHIHOANTRA !=0 AND V_STATUS=2) OR (TP.DINHCHI=1 AND V_STATUS=3) ) OR (V_STATUS IS NULL)) --check chua nop an phi or da nop an phi or da hoan tra --OR (TP.SOBIENLAI IS NULL AND V_STATUS=3) dinh chi nop an phi
                  AND ((V_TUNGAY IS NULL OR TP.NGAYTHONGBAO>=V_TUNGAY) AND (V_DENNGAY IS NULL  OR TP.NGAYTHONGBAO<=V_DENNGAY))
               AND (V_TT_TRUCTUYEN IS NULL OR (TP.TT_TRUCTUYEN=V_TT_TRUCTUYEN)) AND (TP.MALOAIVUVIEC=V_LOAI_AN OR V_LOAI_AN IS NULL)
               AND TP.MA_THONGBAO IS NOT NULL
               AND (V_FILE_THA IS NULL
                                        OR (V_FILE_THA=1 AND TP.ANPHI_FILE_NAME IS NOT NULL )
                                        OR (V_FILE_THA=0 AND TP.ANPHI_FILE_NAME IS NULL )
                )
              AND (V_TRANG_THAI IS NULL OR CN.TRANG_THAI=V_TRANG_THAI)
        ) DS WHERE DS.STT>=MININDEX AND DS.STT<=MAXINDEX;
    RETURN v_cursor;   
END TC_DANHSACH_ANPHI;
FUNCTION TC_DANHSACH_ANPHI_QLTA 
(
  V_FILE_THA IN VARCHAR2 DEFAULT NULL, 
  V_GET_CHIL IN VARCHAR2 DEFAULT NULL, 
  V_LOAI_AN IN VARCHAR2 DEFAULT NULL, 
  V_TT_TRUCTUYEN IN VARCHAR2 DEFAULT NULL, 
  V_DATE_FROM IN VARCHAR2 DEFAULT NULL,  
  V_DATE_TO IN VARCHAR2 DEFAULT NULL, 
  V_STATUS IN NVARCHAR2 DEFAULT NULL,
  V_USERNAME IN NVARCHAR2 DEFAULT NULL,
  V_DONVITHA_ID IN NVARCHAR2 DEFAULT NULL,
  vTuKhoaBasic IN NVARCHAR2 DEFAULT NULL, 
  PageIndex	in	int,
  PageSize	in	int
)
RETURN SYS_REFCURSOR
AS
      MININDEX	number;v_table T_TUPHAP_ANPHI;
      MAXINDEX	number;V_LOAITOA VARCHAR2(150):=NULL;V_TUNGAY DATE;V_DENNGAY DATE;
      V_CURSOR sys_refcursor;var_arrsx  varchar2(250);
begin
  v_table := T_TUPHAP_ANPHI(); --dung bang ding nghia
  MININDEX := pagesize*(PAGEINDEX - 1) + 1;
  MAXINDEX := PAGEINDEX*pagesize ;
  -----------
  IF(V_DATE_FROM IS NOT NULL) THEN
        V_TUNGAY:=TO_DATE(V_DATE_FROM||'00:00:00','dd/mm/yyyy hh24:mi:ss');
     END IF;
     IF(V_DATE_TO IS NOT NULL)THEN
        V_DENNGAY:=TO_DATE(V_DATE_TO||'23:59:59','dd/mm/yyyy hh24:mi:ss');
     END IF;
 --------------
  FOR item_tp IN 
            (
                SELECT TD.NGAYTAO,THA.ID DONVITHA_ID,NULL TENFILE,'Dân sự' LOAIAN,TO_CHAR(DO.MAVUVIEC)MAVUVIEC,TD.BIEUMAUID,'2' AS MALOAIVUVIEC,TD.FILEID,TD.DONID,DU.ID DUONGSU_ID,AI.SOTHONGBAO||'/TB-TA' AS SOTHONGBAO,
                DO.TENVUVIEC TENDUONGSU,DU.NAMSINH,DU.GIOITINH,DU.SOCMND,DU.DIENTHOAI,DU.EMAIL,TN.MA_TEN DONVI,AI.TAMUNGANPHI,
                --DECODE(tt.TRANGTHAITHANHTOAN,0,'Chưa nộp án phí',1,'Đã nộp án phí') STATUS,
                DECODE(DO.MAGIAIDOAN,2,'Thông báo nộp tiền tạm ứng án phí',3,'Thông báo nộp tiền tạm ứng án phí phúc thẩm') STATUS,
                HC.MA_TEN,
                DECODE(DU.TAMTRUCHITIET,NULL,HC.MA_TEN,REPLACE(DU.TAMTRUCHITIET,',')||', '||HC.MA_TEN) AS DIACHI,
                TA.HOANTRAAP_HOTEN,TA.HOANTRAAP_GIOITINH,TA.HOANTRAAP_NAMSINH,TA.HOANTRAAP_CMND,TA.HOANTRAAP_TEL,TA.HOANTRAAP_EMAIL,TA.HOANTRAAP_DIACHI,
                TA.NGAYBIENLAI,TA.SOBIENLAI,
                --TA.NGUOITHUTIEN,
                DO.NGUOITAO NGUOITHUTIEN,
                DX.NGAYGQ_YC,
                TA.NOP_ISNGUYENDON,TA.NOP_GIOITINH,decode(tt.TT_TRUCTUYEN,1,TT.HOTENNGUOINOPTIEN,TA.NOP_HOTEN)NOP_HOTEN,TA.NOP_NAMSINH,decode(tt.TT_TRUCTUYEN,1,tt.SOCMNDNGUOINOP,TA.NOP_CMND)NOP_CMND,TA.NOP_TEL,TA.NOP_EMAIL,decode(tt.TT_TRUCTUYEN,1,TT.DIACHINGUOINOPTIEN,TA.NOP_DIACHI)NOP_DIACHI,TA.HOANTRAAP_ISNGUYENDON,DU.LOAIDUONGSU               
                ,TA.ANPHIHOANTRA,
                TT.THOIGIANTHANHTOAN NGAYHOANTRA ,
                DECODE(DC.DONID,NULL,0,1) DINHCHI,TT.MA_THONGBAO,TT.TT_TRUCTUYEN,BL.FILE_NAME,TT.TRANGTHAITHANHTOAN,AI.ID ANPHI_ID,TT.ID DVCQG_TT_ID,AI.NGAYTHONGBAO
                ,FA.FILE_NAME ANPHI_FILE_NAME,TA.NGUOISUA,TA.NGAYSUA,TA.ID TUPHAP_ANPHI_ID
                FROM ADS_TONGDAT TD 
                INNER JOIN ADS_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID 
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN ADS_ANPHI AI ON TD.DONID=AI.DONID
                LEFT JOIN (select ANPHI_ID,FILE_NAME from ADS_FILE_THA WHERE STATUS=1) FA ON FA.ANPHI_ID=AI.ID
                --  LEFT JOIN (select ANPHI_ID,FILE_NAME from ADS_FILE_THA WHERE STATUS=1) FA ON FA.ANPHI_ID=AI.ID
                INNER JOIN ADS_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
               -- INNER JOIN ADS_TONGDAT_DOITUONG DO ON DO.DUONGSUID =DU.id
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN ADS_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
               -- LEFT JOIN ADS_FILE FL ON FL.DONID=TD.DONID AND FL.BIEUMAUID=67
                LEFT JOIN (SELECT QD.DONID FROM ADS_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi    
                LEFT JOIN DVCQG_THANH_TOAN TT ON tt.DUONGSU_ID=AI.DUONGSU_ID AND TT.ANPHI_ID=AI.ID AND TT.MALOAIVUVIEC='2'
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.DUONGSU_ID=TT.DUONGSU_ID AND TA.anphi_id=AI.ID AND TA.MALOAIVUVIEC='2'
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE DU.TUCACHTOTUNG_MA='NGUYENDON' AND TD.BIEUMAUID IN(67,381) --Thông báo nộp tiền tạm ứng án phí
               --AND DU.ISDAIDIEN = 1 --AND NULL TENFILE IS NOT NULL
                AND AI.TAMUNGANPHI !=0
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := R_TUPHAP_ANPHI(
        item_tp.NGAYTAO, item_tp.DONVITHA_ID,item_tp.TENFILE,item_tp.LOAIAN,item_tp.MAVUVIEC, item_tp.BIEUMAUID,item_tp.MALOAIVUVIEC,item_tp.FILEID,item_tp.DONID,item_tp.DUONGSU_ID,
        item_tp.SOTHONGBAO,item_tp.TENDUONGSU,item_tp.NAMSINH,item_tp.GIOITINH,item_tp.SOCMND,item_tp.DIENTHOAI,item_tp.EMAIL,item_tp.DONVI,item_tp.TAMUNGANPHI,item_tp.STATUS,item_tp.MA_TEN,item_tp.DIACHI,
        item_tp.HOANTRAAP_HOTEN,item_tp.HOANTRAAP_GIOITINH,item_tp.HOANTRAAP_NAMSINH,item_tp.HOANTRAAP_CMND,item_tp.HOANTRAAP_TEL,item_tp.HOANTRAAP_EMAIL,item_tp.HOANTRAAP_DIACHI,item_tp.NGAYBIENLAI,item_tp.SOBIENLAI,item_tp.NGUOITHUTIEN,item_tp.NGAYGQ_YC,
        item_tp.NOP_ISNGUYENDON,item_tp.NOP_GIOITINH,item_tp.NOP_HOTEN,item_tp.NOP_NAMSINH,item_tp.NOP_CMND,item_tp.NOP_TEL,item_tp.NOP_EMAIL,item_tp.NOP_DIACHI,item_tp.HOANTRAAP_ISNGUYENDON,item_tp.LOAIDUONGSU
        ,item_tp.ANPHIHOANTRA,item_tp.NGAYHOANTRA,item_tp.DINHCHI,item_tp.MA_THONGBAO,item_tp.TT_TRUCTUYEN,item_tp.FILE_NAME,NULL,item_tp.TRANGTHAITHANHTOAN,item_tp.ANPHI_ID,item_tp.DVCQG_TT_ID,item_tp.NGAYTHONGBAO
        ,item_tp.ANPHI_FILE_NAME,item_tp.NGAYSUA,item_tp.NGUOISUA,item_tp.TUPHAP_ANPHI_ID);    
    END LOOP;
      -----------
     FOR item_tp IN 
            (
                SELECT TD.NGAYTAO,THA.ID DONVITHA_ID,NULL TENFILE,'Hôn nhân ' LOAIAN,DO.MAVUVIEC, TD.BIEUMAUID,'3' AS MALOAIVUVIEC,TD.FILEID,TD.DONID,0 DUONGSU_ID,AI.SOTHONGBAO||'/TB-TA' AS SOTHONGBAO,
                DO.TENVUVIEC TENDUONGSU,null NAMSINH,null GIOITINH,null SOCMND,null DIENTHOAI,null EMAIL,TN.MA_TEN DONVI,AI.TAMUNGANPHI,
                --DECODE(tt.TRANGTHAITHANHTOAN,0,'Chưa nộp án phí',1,'Đã nộp án phí') STATUS,
                DECODE(DO.MAGIAIDOAN,2,'Thông báo nộp tiền tạm ứng án phí',3,'Thông báo nộp tiền tạm ứng án phí phúc thẩm') STATUS,
                null MA_TEN,
                null AS DIACHI,
                TA.HOANTRAAP_HOTEN,TA.HOANTRAAP_GIOITINH,TA.HOANTRAAP_NAMSINH,TA.HOANTRAAP_CMND,TA.HOANTRAAP_TEL,TA.HOANTRAAP_EMAIL,TA.HOANTRAAP_DIACHI,
                TA.NGAYBIENLAI,TA.SOBIENLAI,
                --TA.NGUOITHUTIEN,
                DO.NGUOITAO NGUOITHUTIEN,
                DX.NGAYGQ_YC,
                TA.NOP_ISNGUYENDON,TA.NOP_GIOITINH,decode(tt.TT_TRUCTUYEN,1,TT.HOTENNGUOINOPTIEN,TA.NOP_HOTEN)NOP_HOTEN,TA.NOP_NAMSINH,decode(tt.TT_TRUCTUYEN,1,tt.SOCMNDNGUOINOP,TA.NOP_CMND)NOP_CMND,TA.NOP_TEL,TA.NOP_EMAIL,decode(tt.TT_TRUCTUYEN,1,TT.DIACHINGUOINOPTIEN,TA.NOP_DIACHI)NOP_DIACHI,TA.HOANTRAAP_ISNGUYENDON,null LOAIDUONGSU
                ,TA.ANPHIHOANTRA,
                TT.THOIGIANTHANHTOAN NGAYHOANTRA,
                DECODE(DC.DONID,NULL,0,1) DINHCHI,TT.MA_THONGBAO,TT.TT_TRUCTUYEN,BL.FILE_NAME, AI.DUONGSU_IDS,TT.TRANGTHAITHANHTOAN,AI.ID ANPHI_ID,TT.ID DVCQG_TT_ID,AI.NGAYTHONGBAO
                ,FA.FILE_NAME ANPHI_FILE_NAME,TA.NGUOISUA,TA.NGAYSUA,TA.ID TUPHAP_ANPHI_ID
                FROM AHN_TONGDAT TD  
                INNER JOIN AHN_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN AHN_ANPHI AI ON TD.DONID=AI.DONID
                LEFT JOIN (select ANPHI_ID,FILE_NAME from AHN_FILE_THA WHERE STATUS=1) FA ON FA.ANPHI_ID=AI.ID
                LEFT JOIN (SELECT LISTAGG('Họ tên:<b> '||HN.TENDUONGSU||'</b><br/> Năm sinh: '||HN.NAMSINH||'<br/> CCCD: '||HN.SOCMND||'<br/> Điên thoại: '||HN.DIENTHOAI||'<br/> Email: '||HN.EMAIL||'<br/>', '')
                                   WITHIN GROUP (ORDER BY 'Họ tên:<b> '||HN.TENDUONGSU||'</b><br/> Năm sinh: '||HN.NAMSINH||'<br/> CCCD: '||HN.SOCMND||'<br/> Điên thoại: '||HN.DIENTHOAI||'<br/> Email: '||HN.EMAIL||'<br/>') TENDUONGSU ,
                             DU.ANPHI_ID
                             FROM AHN_ANPHI_DUONGSU DU LEFT JOIN AHN_DON_DUONGSU HN ON HN.ID=DU.DUONGSU_ID
                             GROUP BY DU.ANPHI_ID
                          )AP ON AP.ANPHI_ID=AI.ID
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                LEFT JOIN AHN_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.anphi_id=AI.ID AND TA.MALOAIVUVIEC='3'
                LEFT JOIN (SELECT QD.DONID FROM AHN_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
                LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.ANPHI_ID=AI.ID AND TT.MALOAIVUVIEC='3'
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE  TD.BIEUMAUID IN(67,381) AND
                 AI.TAMUNGANPHI !=0
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := R_TUPHAP_ANPHI(
        item_tp.NGAYTAO, item_tp.DONVITHA_ID,item_tp.TENFILE,item_tp.LOAIAN,item_tp.MAVUVIEC,item_tp.BIEUMAUID,item_tp.MALOAIVUVIEC,item_tp.FILEID,item_tp.DONID,item_tp.DUONGSU_ID,
        item_tp.SOTHONGBAO,item_tp.TENDUONGSU,item_tp.NAMSINH,item_tp.GIOITINH,item_tp.SOCMND,item_tp.DIENTHOAI,item_tp.EMAIL,item_tp.DONVI,item_tp.TAMUNGANPHI,item_tp.STATUS,item_tp.MA_TEN,item_tp.DIACHI,
        item_tp.HOANTRAAP_HOTEN,item_tp.HOANTRAAP_GIOITINH,item_tp.HOANTRAAP_NAMSINH,item_tp.HOANTRAAP_CMND,item_tp.HOANTRAAP_TEL,item_tp.HOANTRAAP_EMAIL,item_tp.HOANTRAAP_DIACHI,item_tp.NGAYBIENLAI,item_tp.SOBIENLAI,item_tp.NGUOITHUTIEN,item_tp.NGAYGQ_YC,
        item_tp.NOP_ISNGUYENDON,item_tp.NOP_GIOITINH,item_tp.NOP_HOTEN,item_tp.NOP_NAMSINH,item_tp.NOP_CMND,item_tp.NOP_TEL,item_tp.NOP_EMAIL,item_tp.NOP_DIACHI,item_tp.HOANTRAAP_ISNGUYENDON,item_tp.LOAIDUONGSU
        ,item_tp.ANPHIHOANTRA,item_tp.NGAYHOANTRA,item_tp.DINHCHI,item_tp.MA_THONGBAO,item_tp.TT_TRUCTUYEN,item_tp.FILE_NAME,item_tp.DUONGSU_IDS,item_tp.TRANGTHAITHANHTOAN,item_tp.ANPHI_ID,item_tp.DVCQG_TT_ID,item_tp.NGAYTHONGBAO
       ,item_tp.ANPHI_FILE_NAME,item_tp.NGAYSUA,item_tp.NGUOISUA,item_tp.TUPHAP_ANPHI_ID);   
    END LOOP;
      -----------
     FOR item_tp IN 
            (
               SELECT TD.NGAYTAO,THA.ID DONVITHA_ID,NULL TENFILE,'Kinh tế' LOAIAN,DO.MAVUVIEC,TD.BIEUMAUID,'4' AS MALOAIVUVIEC,TD.FILEID,TD.DONID,DU.ID DUONGSU_ID,AI.SOTHONGBAO||'/TB-TA' AS SOTHONGBAO,
                DO.TENVUVIEC TENDUONGSU,DU.NAMSINH,DU.GIOITINH,DU.SOCMND,DU.DIENTHOAI,DU.EMAIL,TN.MA_TEN DONVI,AI.TAMUNGANPHI,
                --DECODE(tt.TRANGTHAITHANHTOAN,0,'Chưa nộp án phí',1,'Đã nộp án phí') STATUS,
                DECODE(DO.MAGIAIDOAN,2,'Thông báo nộp tiền tạm ứng án phí',3,'Thông báo nộp tiền tạm ứng án phí phúc thẩm') STATUS,
                HC.MA_TEN,
                DECODE(DU.TAMTRUCHITIET,NULL,HC.MA_TEN,REPLACE(DU.TAMTRUCHITIET,',')||', '||HC.MA_TEN) AS DIACHI,
                TA.HOANTRAAP_HOTEN,TA.HOANTRAAP_GIOITINH,TA.HOANTRAAP_NAMSINH,TA.HOANTRAAP_CMND,TA.HOANTRAAP_TEL,TA.HOANTRAAP_EMAIL,TA.HOANTRAAP_DIACHI,
                TA.NGAYBIENLAI,TA.SOBIENLAI,
                --TA.NGUOITHUTIEN,
                DO.NGUOITAO NGUOITHUTIEN,
                DX.NGAYGQ_YC,
                TA.NOP_ISNGUYENDON,TA.NOP_GIOITINH,decode(tt.TT_TRUCTUYEN,1,TT.HOTENNGUOINOPTIEN,TA.NOP_HOTEN)NOP_HOTEN,TA.NOP_NAMSINH,decode(tt.TT_TRUCTUYEN,1,tt.SOCMNDNGUOINOP,TA.NOP_CMND)NOP_CMND,TA.NOP_TEL,TA.NOP_EMAIL,decode(tt.TT_TRUCTUYEN,1,TT.DIACHINGUOINOPTIEN,TA.NOP_DIACHI)NOP_DIACHI,TA.HOANTRAAP_ISNGUYENDON,DU.LOAIDUONGSU
                ,TA.ANPHIHOANTRA,
                TT.THOIGIANTHANHTOAN NGAYHOANTRA,
                DECODE(DC.DONID,NULL,0,1) DINHCHI,TT.MA_THONGBAO,TT.TT_TRUCTUYEN,BL.FILE_NAME,TT.TRANGTHAITHANHTOAN,AI.ID ANPHI_ID,TT.ID DVCQG_TT_ID,AI.NGAYTHONGBAO
                ,FA.FILE_NAME ANPHI_FILE_NAME,TA.NGUOISUA,TA.NGAYSUA,TA.ID TUPHAP_ANPHI_ID
                FROM AKT_TONGDAT TD 
                INNER JOIN AKT_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN AKT_ANPHI AI ON TD.DONID=AI.DONID
                LEFT JOIN (select ANPHI_ID,FILE_NAME from AKT_FILE_THA WHERE STATUS=1) FA ON FA.ANPHI_ID=AI.ID
                INNER JOIN AKT_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
                --INNER JOIN AKT_TONGDAT_DOITUONG DO ON DO.DUONGSUID =DU.id
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN AKT_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.anphi_id=AI.ID AND TA.MALOAIVUVIEC='4'
--                LEFT JOIN AKT_FILE FL ON FL.DONID=TD.DONID AND FL.BIEUMAUID=67
                LEFT JOIN (SELECT QD.DONID FROM AKT_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
                LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.ANPHI_ID=AI.ID AND TT.MALOAIVUVIEC='4'
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE DU.TUCACHTOTUNG_MA='NGUYENDON' AND TD.BIEUMAUID IN(67,381)--Thông báo nộp tiền tạm ứng án phí
               -- AND DU.ISDAIDIEN = 1 --AND NULL TENFILE IS NOT NULL
                AND AI.TAMUNGANPHI !=0
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := R_TUPHAP_ANPHI(
        item_tp.NGAYTAO, item_tp.DONVITHA_ID,item_tp.TENFILE,item_tp.LOAIAN,item_tp.MAVUVIEC,item_tp.BIEUMAUID,item_tp.MALOAIVUVIEC,item_tp.FILEID,item_tp.DONID,item_tp.DUONGSU_ID,
        item_tp.SOTHONGBAO,item_tp.TENDUONGSU,item_tp.NAMSINH,item_tp.GIOITINH,item_tp.SOCMND,item_tp.DIENTHOAI,item_tp.EMAIL,item_tp.DONVI,item_tp.TAMUNGANPHI,item_tp.STATUS,item_tp.MA_TEN,item_tp.DIACHI,
        item_tp.HOANTRAAP_HOTEN,item_tp.HOANTRAAP_GIOITINH,item_tp.HOANTRAAP_NAMSINH,item_tp.HOANTRAAP_CMND,item_tp.HOANTRAAP_TEL,item_tp.HOANTRAAP_EMAIL,item_tp.HOANTRAAP_DIACHI,item_tp.NGAYBIENLAI,item_tp.SOBIENLAI,item_tp.NGUOITHUTIEN,item_tp.NGAYGQ_YC,
        item_tp.NOP_ISNGUYENDON,item_tp.NOP_GIOITINH,item_tp.NOP_HOTEN,item_tp.NOP_NAMSINH,item_tp.NOP_CMND,item_tp.NOP_TEL,item_tp.NOP_EMAIL,item_tp.NOP_DIACHI,item_tp.HOANTRAAP_ISNGUYENDON,item_tp.LOAIDUONGSU
        ,item_tp.ANPHIHOANTRA,item_tp.NGAYHOANTRA,item_tp.DINHCHI,item_tp.MA_THONGBAO,item_tp.TT_TRUCTUYEN,item_tp.FILE_NAME,NULL,item_tp.TRANGTHAITHANHTOAN,item_tp.ANPHI_ID,item_tp.DVCQG_TT_ID,item_tp.NGAYTHONGBAO
       ,item_tp.ANPHI_FILE_NAME,item_tp.NGAYSUA,item_tp.NGUOISUA,item_tp.TUPHAP_ANPHI_ID);   
    END LOOP;
       -----------
     FOR item_tp IN 
            (
                SELECT TD.NGAYTAO,THA.ID DONVITHA_ID,NULL TENFILE,'Lao động' LOAIAN,DO.MAVUVIEC,TD.BIEUMAUID,'5' AS MALOAIVUVIEC,TD.FILEID,TD.DONID,DU.ID DUONGSU_ID,AI.SOTHONGBAO||'/TB-TA' AS SOTHONGBAO,
                DO.TENVUVIEC TENDUONGSU,DU.NAMSINH,DU.GIOITINH,DU.SOCMND,DU.DIENTHOAI,DU.EMAIL,TN.MA_TEN DONVI,AI.TAMUNGANPHI,
                --DECODE(tt.TRANGTHAITHANHTOAN,0,'Chưa nộp án phí',1,'Đã nộp án phí') STATUS,
                DECODE(DO.MAGIAIDOAN,2,'Thông báo nộp tiền tạm ứng án phí',3,'Thông báo nộp tiền tạm ứng án phí phúc thẩm') STATUS,
                HC.MA_TEN,
                DECODE(DU.TAMTRUCHITIET,NULL,HC.MA_TEN,REPLACE(DU.TAMTRUCHITIET,',')||', '||HC.MA_TEN) AS DIACHI,
                TA.HOANTRAAP_HOTEN,TA.HOANTRAAP_GIOITINH,TA.HOANTRAAP_NAMSINH,TA.HOANTRAAP_CMND,TA.HOANTRAAP_TEL,TA.HOANTRAAP_EMAIL,TA.HOANTRAAP_DIACHI,
                TA.NGAYBIENLAI,TA.SOBIENLAI,
                --TA.NGUOITHUTIEN,
                DO.NGUOITAO NGUOITHUTIEN,
                DX.NGAYGQ_YC,
                TA.NOP_ISNGUYENDON,TA.NOP_GIOITINH,decode(tt.TT_TRUCTUYEN,1,TT.HOTENNGUOINOPTIEN,TA.NOP_HOTEN)NOP_HOTEN,TA.NOP_NAMSINH,decode(tt.TT_TRUCTUYEN,1,tt.SOCMNDNGUOINOP,TA.NOP_CMND)NOP_CMND,TA.NOP_TEL,TA.NOP_EMAIL,decode(tt.TT_TRUCTUYEN,1,TT.DIACHINGUOINOPTIEN,TA.NOP_DIACHI)NOP_DIACHI,TA.HOANTRAAP_ISNGUYENDON,DU.LOAIDUONGSU
               ,TA.ANPHIHOANTRA,
               TT.THOIGIANTHANHTOAN NGAYHOANTRA,
               DECODE(DC.DONID,NULL,0,1) DINHCHI,TT.MA_THONGBAO,TT.TT_TRUCTUYEN,BL.FILE_NAME,TT.TRANGTHAITHANHTOAN,AI.ID ANPHI_ID,TT.ID DVCQG_TT_ID,AI.NGAYTHONGBAO
                ,FA.FILE_NAME ANPHI_FILE_NAME,TA.NGUOISUA,TA.NGAYSUA,TA.ID TUPHAP_ANPHI_ID
                FROM ALD_TONGDAT TD 
                INNER JOIN ALD_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN ALD_ANPHI AI ON TD.DONID=AI.DONID
                LEFT JOIN (select ANPHI_ID,FILE_NAME from ALD_FILE_THA WHERE STATUS=1) FA ON FA.ANPHI_ID=AI.ID
                INNER JOIN ALD_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
               -- INNER JOIN ALD_TONGDAT_DOITUONG DO ON DO.DUONGSUID =DU.id
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN ALD_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.anphi_id=AI.ID AND TA.MALOAIVUVIEC='5'
--                LEFT JOIN ALD_FILE FL ON FL.DONID=TD.DONID AND FL.BIEUMAUID=67
                LEFT JOIN (SELECT QD.DONID FROM ALD_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
                LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.ANPHI_ID=AI.ID AND TT.MALOAIVUVIEC='5'
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE DU.TUCACHTOTUNG_MA='NGUYENDON' AND TD.BIEUMAUID IN(67,381) 
               -- AND DU.ISDAIDIEN = 1 --AND NULL TENFILE IS NOT NULL
                AND AI.TAMUNGANPHI !=0
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := R_TUPHAP_ANPHI(
        item_tp.NGAYTAO, item_tp.DONVITHA_ID,item_tp.TENFILE,item_tp.LOAIAN,item_tp.MAVUVIEC,item_tp.BIEUMAUID,item_tp.MALOAIVUVIEC,item_tp.FILEID,item_tp.DONID,item_tp.DUONGSU_ID,
        item_tp.SOTHONGBAO,item_tp.TENDUONGSU,item_tp.NAMSINH,item_tp.GIOITINH,item_tp.SOCMND,item_tp.DIENTHOAI,item_tp.EMAIL,item_tp.DONVI,item_tp.TAMUNGANPHI,item_tp.STATUS,item_tp.MA_TEN,item_tp.DIACHI,
        item_tp.HOANTRAAP_HOTEN,item_tp.HOANTRAAP_GIOITINH,item_tp.HOANTRAAP_NAMSINH,item_tp.HOANTRAAP_CMND,item_tp.HOANTRAAP_TEL,item_tp.HOANTRAAP_EMAIL,item_tp.HOANTRAAP_DIACHI,item_tp.NGAYBIENLAI,item_tp.SOBIENLAI,item_tp.NGUOITHUTIEN,item_tp.NGAYGQ_YC,
        item_tp.NOP_ISNGUYENDON,item_tp.NOP_GIOITINH,item_tp.NOP_HOTEN,item_tp.NOP_NAMSINH,item_tp.NOP_CMND,item_tp.NOP_TEL,item_tp.NOP_EMAIL,item_tp.NOP_DIACHI,item_tp.HOANTRAAP_ISNGUYENDON,item_tp.LOAIDUONGSU
        ,item_tp.ANPHIHOANTRA,item_tp.NGAYHOANTRA,item_tp.DINHCHI,item_tp.MA_THONGBAO,item_tp.TT_TRUCTUYEN,item_tp.FILE_NAME,NULL,item_tp.TRANGTHAITHANHTOAN,item_tp.ANPHI_ID,item_tp.DVCQG_TT_ID,item_tp.NGAYTHONGBAO
       ,item_tp.ANPHI_FILE_NAME,item_tp.NGAYSUA,item_tp.NGUOISUA,item_tp.TUPHAP_ANPHI_ID);  
    END LOOP;
    FOR item_tp IN 
            (
            SELECT TD.NGAYTAO,THA.ID DONVITHA_ID,NULL TENFILE,'Hành chính' LOAIAN,DO.MAVUVIEC,TD.BIEUMAUID,'6' AS MALOAIVUVIEC,TD.FILEID,TD.DONID,0 DUONGSU_ID,AI.SOTHONGBAO||'/TB-TA' AS SOTHONGBAO,
                DO.TENVUVIEC TENDUONGSU,null NAMSINH,null GIOITINH,null SOCMND,null DIENTHOAI,null EMAIL,TN.MA_TEN DONVI,AI.TAMUNGANPHI,
                --DECODE(tt.TRANGTHAITHANHTOAN,0,'Chưa nộp án phí',1,'Đã nộp án phí') STATUS,
                DECODE(DO.MAGIAIDOAN,2,'Thông báo nộp tiền tạm ứng án phí',3,'Thông báo nộp tiền tạm ứng án phí phúc thẩm') STATUS,
                null MA_TEN,
                null AS DIACHI,
                TA.HOANTRAAP_HOTEN,TA.HOANTRAAP_GIOITINH,TA.HOANTRAAP_NAMSINH,TA.HOANTRAAP_CMND,TA.HOANTRAAP_TEL,TA.HOANTRAAP_EMAIL,TA.HOANTRAAP_DIACHI,
                TA.NGAYBIENLAI,TA.SOBIENLAI,
                --TA.NGUOITHUTIEN,
                DO.NGUOITAO NGUOITHUTIEN,
                DX.NGAYGQ_YC,
                TA.NOP_ISNGUYENDON,TA.NOP_GIOITINH,decode(tt.TT_TRUCTUYEN,1,TT.HOTENNGUOINOPTIEN,TA.NOP_HOTEN)NOP_HOTEN,TA.NOP_NAMSINH,decode(tt.TT_TRUCTUYEN,1,tt.SOCMNDNGUOINOP,TA.NOP_CMND)NOP_CMND,TA.NOP_TEL,TA.NOP_EMAIL,decode(tt.TT_TRUCTUYEN,1,TT.DIACHINGUOINOPTIEN,TA.NOP_DIACHI)NOP_DIACHI,TA.HOANTRAAP_ISNGUYENDON,null LOAIDUONGSU
                ,TA.ANPHIHOANTRA,
                TT.THOIGIANTHANHTOAN NGAYHOANTRA,
                DECODE(DC.DONID,NULL,0,1) DINHCHI,TT.MA_THONGBAO,TT.TT_TRUCTUYEN,BL.FILE_NAME,AI.DUONGSU_IDS,TT.TRANGTHAITHANHTOAN,AI.ID ANPHI_ID,TT.ID DVCQG_TT_ID,AI.NGAYTHONGBAO
                 ,FA.FILE_NAME ANPHI_FILE_NAME,TA.NGUOISUA,TA.NGAYSUA,TA.ID TUPHAP_ANPHI_ID
                FROM AHC_TONGDAT TD 
                INNER JOIN AHC_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN AHC_ANPHI AI ON TD.DONID=AI.DONID
                LEFT JOIN (select ANPHI_ID,FILE_NAME from AHC_FILE_THA WHERE STATUS=1) FA ON FA.ANPHI_ID=AI.ID
                LEFT JOIN (SELECT LISTAGG('Họ tên:<b> '||HN.TENDUONGSU||'</b><br/> Năm sinh: '||HN.NAMSINH||'<br/> CCCD: '||HN.SOCMND||'<br/> Điên thoại: '||HN.DIENTHOAI||'<br/> Email: '||HN.EMAIL||'<br/>', '')
                                   WITHIN GROUP (ORDER BY 'Họ tên:<b> '||HN.TENDUONGSU||'</b><br/> Năm sinh: '||HN.NAMSINH||'<br/> CCCD: '||HN.SOCMND||'<br/> Điên thoại: '||HN.DIENTHOAI||'<br/> Email: '||HN.EMAIL||'<br/>') TENDUONGSU ,
                             DU.ANPHI_ID
                             FROM AHC_ANPHI_DUONGSU DU LEFT JOIN AHC_DON_DUONGSU HN ON HN.ID=DU.DUONGSU_ID
                             GROUP BY DU.ANPHI_ID
                          )AP ON AP.ANPHI_ID=AI.ID
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                LEFT JOIN AHC_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.anphi_id=AI.ID AND TA.MALOAIVUVIEC='6'
                LEFT JOIN (SELECT QD.DONID FROM AHC_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
                LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.ANPHI_ID=AI.ID AND TT.MALOAIVUVIEC='6'
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE TD.BIEUMAUID=121 AND
                 AI.TAMUNGANPHI !=0
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := R_TUPHAP_ANPHI(
        item_tp.NGAYTAO, item_tp.DONVITHA_ID,item_tp.TENFILE,item_tp.LOAIAN,item_tp.MAVUVIEC,item_tp.BIEUMAUID,item_tp.MALOAIVUVIEC,item_tp.FILEID,item_tp.DONID,item_tp.DUONGSU_ID,
        item_tp.SOTHONGBAO,item_tp.TENDUONGSU,item_tp.NAMSINH,item_tp.GIOITINH,item_tp.SOCMND,item_tp.DIENTHOAI,item_tp.EMAIL,item_tp.DONVI,item_tp.TAMUNGANPHI,item_tp.STATUS,item_tp.MA_TEN,item_tp.DIACHI,
        item_tp.HOANTRAAP_HOTEN,item_tp.HOANTRAAP_GIOITINH,item_tp.HOANTRAAP_NAMSINH,item_tp.HOANTRAAP_CMND,item_tp.HOANTRAAP_TEL,item_tp.HOANTRAAP_EMAIL,item_tp.HOANTRAAP_DIACHI,item_tp.NGAYBIENLAI,item_tp.SOBIENLAI,item_tp.NGUOITHUTIEN,item_tp.NGAYGQ_YC,
        item_tp.NOP_ISNGUYENDON,item_tp.NOP_GIOITINH,item_tp.NOP_HOTEN,item_tp.NOP_NAMSINH,item_tp.NOP_CMND,item_tp.NOP_TEL,item_tp.NOP_EMAIL,item_tp.NOP_DIACHI,item_tp.HOANTRAAP_ISNGUYENDON,item_tp.LOAIDUONGSU
       ,item_tp.ANPHIHOANTRA,item_tp.NGAYHOANTRA,item_tp.DINHCHI,item_tp.MA_THONGBAO,item_tp.TT_TRUCTUYEN,item_tp.FILE_NAME,item_tp.DUONGSU_IDS,item_tp.TRANGTHAITHANHTOAN,item_tp.ANPHI_ID,item_tp.DVCQG_TT_ID,item_tp.NGAYTHONGBAO
        ,item_tp.ANPHI_FILE_NAME,item_tp.NGAYSUA,item_tp.NGUOISUA,item_tp.TUPHAP_ANPHI_ID);   
    END LOOP;
     ------------------
    FOR item_tp IN 
            (
                SELECT TD.NGAYTAO,THA.ID DONVITHA_ID,NULL TENFILE,'Phá sản' LOAIAN,DO.MAVUVIEC,DO.TENVUVIEC,TD.BIEUMAUID,'7' AS MALOAIVUVIEC,TD.FILEID,TD.DONID,DU.ID DUONGSU_ID,AI.SOTHONGBAO||'/TB-TA' AS SOTHONGBAO,
                DO.TENVUVIEC TENDUONGSU,DU.NAMSINH,DU.GIOITINH,DU.SOCMND,DU.DIENTHOAI,DU.EMAIL,TN.MA_TEN DONVI,AI.TAMUNGANPHI,
                --DECODE(tt.TRANGTHAITHANHTOAN,0,'Chưa nộp án phí',1,'Đã nộp án phí') STATUS,
                DECODE(DO.MAGIAIDOAN,2,'Thông báo nộp tiền tạm ứng án phí',3,'Thông báo nộp tiền tạm ứng án phí phúc thẩm') STATUS,
                HC.MA_TEN,
                DECODE(DU.TAMTRUCHITIET,NULL,HC.MA_TEN,REPLACE(DU.TAMTRUCHITIET,',')||', '||HC.MA_TEN) AS DIACHI,
                TA.HOANTRAAP_HOTEN,TA.HOANTRAAP_GIOITINH,TA.HOANTRAAP_NAMSINH,TA.HOANTRAAP_CMND,TA.HOANTRAAP_TEL,TA.HOANTRAAP_EMAIL,TA.HOANTRAAP_DIACHI,
                TA.NGAYBIENLAI,TA.SOBIENLAI,
                --TA.NGUOITHUTIEN,
                DO.NGUOITAO NGUOITHUTIEN,
                DX.NGAYGQ_YC,
                TA.NOP_ISNGUYENDON,TA.NOP_GIOITINH,decode(tt.TT_TRUCTUYEN,1,TT.HOTENNGUOINOPTIEN,TA.NOP_HOTEN)NOP_HOTEN,TA.NOP_NAMSINH,decode(tt.TT_TRUCTUYEN,1,tt.SOCMNDNGUOINOP,TA.NOP_CMND)NOP_CMND,TA.NOP_TEL,TA.NOP_EMAIL,decode(tt.TT_TRUCTUYEN,1,TT.DIACHINGUOINOPTIEN,TA.NOP_DIACHI)NOP_DIACHI,TA.HOANTRAAP_ISNGUYENDON,DU.LOAIDUONGSU
                ,TA.ANPHIHOANTRA,
                TT.THOIGIANTHANHTOAN NGAYHOANTRA,
                DECODE(DC.DONID,NULL,0,1) DINHCHI,TT.MA_THONGBAO,TT.TT_TRUCTUYEN,BL.FILE_NAME,TT.TRANGTHAITHANHTOAN,AI.ID ANPHI_ID,TT.ID DVCQG_TT_ID,AI.NGAYTHONGBAO
                ,FA.FILE_NAME ANPHI_FILE_NAME,TA.NGUOISUA,TA.NGAYSUA,TA.ID TUPHAP_ANPHI_ID
                FROM APS_TONGDAT TD 
                INNER JOIN APS_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN APS_ANPHI AI ON TD.DONID=AI.DONID
                LEFT JOIN (select ANPHI_ID,FILE_NAME from APS_FILE_THA WHERE STATUS=1) FA ON FA.ANPHI_ID=AI.ID
                INNER JOIN APS_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
               -- INNER JOIN APS_TONGDAT_DOITUONG DO ON DO.DUONGSUID =DU.id
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN APS_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.anphi_id=AI.ID AND TA.MALOAIVUVIEC='7'
--                LEFT JOIN APS_FILE FL ON FL.DONID=TD.DONID AND FL.BIEUMAUID=67
                LEFT JOIN (SELECT QD.DONID FROM APS_SOTHAM_QUYETDINH  QD  
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
               LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.ANPHI_ID=AI.ID AND  TT.MALOAIVUVIEC='7'
               LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE DU.TUCACHTOTUNG_MA='NGUYENDON'AND TD.BIEUMAUID IN(67,381) --Thông báo nộp tiền tạm ứng án phí
               -- AND DU.ISDAIDIEN = 1 --AND NULL TENFILE IS NOT NULL
                AND AI.TAMUNGANPHI !=0
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := R_TUPHAP_ANPHI(
        item_tp.NGAYTAO, item_tp.DONVITHA_ID,item_tp.TENFILE,item_tp.LOAIAN,item_tp.MAVUVIEC,item_tp.BIEUMAUID,item_tp.MALOAIVUVIEC,item_tp.FILEID,item_tp.DONID,item_tp.DUONGSU_ID,
        item_tp.SOTHONGBAO,item_tp.TENDUONGSU,item_tp.NAMSINH,item_tp.GIOITINH,item_tp.SOCMND,item_tp.DIENTHOAI,item_tp.EMAIL,item_tp.DONVI,item_tp.TAMUNGANPHI,item_tp.STATUS,item_tp.MA_TEN,item_tp.DIACHI,
        item_tp.HOANTRAAP_HOTEN,item_tp.HOANTRAAP_GIOITINH,item_tp.HOANTRAAP_NAMSINH,item_tp.HOANTRAAP_CMND,item_tp.HOANTRAAP_TEL,item_tp.HOANTRAAP_EMAIL,item_tp.HOANTRAAP_DIACHI,item_tp.NGAYBIENLAI,item_tp.SOBIENLAI,item_tp.NGUOITHUTIEN,item_tp.NGAYGQ_YC,
        item_tp.NOP_ISNGUYENDON,item_tp.NOP_GIOITINH,item_tp.NOP_HOTEN,item_tp.NOP_NAMSINH,item_tp.NOP_CMND,item_tp.NOP_TEL,item_tp.NOP_EMAIL,item_tp.NOP_DIACHI,item_tp.HOANTRAAP_ISNGUYENDON,item_tp.LOAIDUONGSU
       ,item_tp.ANPHIHOANTRA,item_tp.NGAYHOANTRA,item_tp.DINHCHI,item_tp.MA_THONGBAO,item_tp.TT_TRUCTUYEN,item_tp.FILE_NAME,NULL,item_tp.TRANGTHAITHANHTOAN,item_tp.ANPHI_ID,item_tp.DVCQG_TT_ID,item_tp.NGAYTHONGBAO
       ,item_tp.ANPHI_FILE_NAME,item_tp.NGAYSUA,item_tp.NGUOISUA,item_tp.TUPHAP_ANPHI_ID);    
    END LOOP;
    ----------------------------------------
     IF(V_DONVITHA_ID IS NOT NULL) THEN
        SELECT THA.LOAITOA INTO V_LOAITOA FROM DM_DONVITHIHANHAN THA WHERE THA.ID=V_DONVITHA_ID;
         select t.ARRSAPXEP into var_arrsx from DM_DONVITHIHANHAN t where t.ID=V_DONVITHA_ID;
      END IF;
 OPEN v_cursor FOR
 select DS.* from (
                SELECT TP.NGAYTAO,TP.DONVITHA_ID,TP.TENFILE,'<b>'||TP.LOAIAN||'</b>' LOAIAN,TP.MAVUVIEC,TP.BIEUMAUID,TP.MALOAIVUVIEC,TP.FILEID,COUNT(*) OVER()COUNTALL,ROW_NUMBER() OVER (ORDER BY TP.NGAYTAO DESC,TP.DONVI) STT,
                TP.DONID,TP.DUONGSU_ID,TP.SOTHONGBAO,
                TP.TENDUONGSU,TP.NAMSINH,TP.SOCMND,TP.DIENTHOAI,TP.EMAIL,TP.DONVI,
                rtrim(to_char(TP.TAMUNGANPHI, 'FM9G999G999G999G999G999D999', 'NLS_NUMERIC_CHARACTERS='',.'''),',') TAMUNGANPHI,
                --DECODE(V_STATUS,1,'',TP.STATUS)STATUS,
                TP.STATUS,
                TP.DIACHI,TP.HOANTRAAP_HOTEN,TP.HOANTRAAP_NAMSINH,TP.HOANTRAAP_CMND,TP.HOANTRAAP_TEL,TP.HOANTRAAP_EMAIL,TP.HOANTRAAP_DIACHI,
                TO_CHAR(TP.NGAYBIENLAI,'dd/MM/yyyy')NGAYBIENLAI,TP.SOBIENLAI,
                TP.NGUOITHUTIEN,
                TO_CHAR(TP.NGAYGQ_YC,'dd/MM/yyyy')NGAYGQ_YC
                , rtrim(to_char(TP.ANPHIHOANTRA, 'FM9G999G999G999G999G999D999', 'NLS_NUMERIC_CHARACTERS='',.'''),',')ANPHIHOANTRA,TO_CHAR(TP.NGAYHOANTRA,'MM/dd/yyyy')NGAYHOANTRA
                ,DECODE(TP.ANPHIHOANTRA,0,'Chưa nhận hoàn trả',null,'','Đã nhận hoàn trả') STATUS_HOANTRA,TP.MA_THONGBAO,decode(TP.TT_TRUCTUYEN,1,'Trực tuyến','Trực tiếp') HINH_THUC,TP.TT_TRUCTUYEN,TP.FILE_NAME
                ,TP.DUONGSU_IDS,TP.TRANGTHAITHANHTOAN,TP.ANPHI_ID,TP.DVCQG_TT_ID,TO_CHAR(TP.NGAYTHONGBAO,'dd/MM/yyyy')NGAYTHONGBAO
                ,TP.ANPHI_FILE_NAME
                FROM TABLE(v_table) TP 
                LEFT JOIN DM_DONVITHIHANHAN tha on tha.id=tp.DONVITHA_ID
                WHERE 
--               ( (tha.ID=V_DONVITHA_ID AND ((V_GET_CHIL=1 and V_GET_CHIL is not null) or (V_GET_CHIL is null) ) ) OR( (tha.ARRSAPXEP like (var_arrsx ||'/%') or tha.ARRSAPXEP=var_arrsx) AND ((V_GET_CHIL=0 and V_GET_CHIL is not null) or (V_GET_CHIL is null) ))
--                  OR (V_DONVITHA_ID IS NULL) )
                --hien tại dang lọc tạm theo dơn vị tòa án coi như là thi hành án
                ((TP.DONVITHA_ID=V_DONVITHA_ID AND V_DONVITHA_ID IS NOT NULL AND V_LOAITOA!='TOICAO') OR (V_DONVITHA_ID IS NULL OR V_LOAITOA='TOICAO')) 

                 AND( (((UPPER(TP.TENDUONGSU) LIKE '%'||UPPER(vTuKhoaBasic)||'%') AND vTuKhoaBasic IS NOT NULL) OR (vTuKhoaBasic IS NULL))
                     OR (((UPPER(TP.SOTHONGBAO)||'/TB-TA' LIKE '%'||UPPER(vTuKhoaBasic)||'%') AND vTuKhoaBasic IS NOT NULL) OR (vTuKhoaBasic IS NULL))    
                     OR (((UPPER(TP.SOCMND) LIKE '%'||UPPER(vTuKhoaBasic)||'%') AND vTuKhoaBasic IS NOT NULL) OR (vTuKhoaBasic IS NULL))  
                     OR (((UPPER(TP.NOP_CMND) LIKE '%'||UPPER(vTuKhoaBasic)||'%') AND vTuKhoaBasic IS NOT NULL) OR (vTuKhoaBasic IS NULL)) 
                     OR (((UPPER(TP.HOANTRAAP_CMND) LIKE '%'||UPPER(vTuKhoaBasic)||'%') AND vTuKhoaBasic IS NOT NULL) OR (vTuKhoaBasic IS NULL)) 
                     OR (((UPPER(TP.MA_THONGBAO) LIKE '%'||UPPER(vTuKhoaBasic)||'%') AND vTuKhoaBasic IS NOT NULL) OR (vTuKhoaBasic IS NULL)) 
                     )
                   AND (((TP.TRANGTHAITHANHTOAN=0 AND V_STATUS=0) OR (TP.TRANGTHAITHANHTOAN=1 AND V_STATUS=1) OR (TP.TRANGTHAITHANHTOAN=1 AND TP.ANPHIHOANTRA !=0 AND V_STATUS=2) OR (TP.TRANGTHAITHANHTOAN=1  AND TP.DINHCHI=1 AND V_STATUS=3) ) OR (V_STATUS IS NULL)) --check chua nop an phi or da nop an phi or da hoan tra --OR (TP.SOBIENLAI IS NULL AND V_STATUS=3) dinh chi nop an phi
--                 AND (((TP.SOBIENLAI IS NULL AND V_STATUS=0) OR (TP.SOBIENLAI IS NOT NULL AND V_STATUS=1) OR (TP.SOBIENLAI IS NOT NULL AND TP.ANPHIHOANTRA !=0 AND V_STATUS=2) OR (TP.DINHCHI=1 AND V_STATUS=3) ) OR (V_STATUS IS NULL)) --check chua nop an phi or da nop an phi or da hoan tra --OR (TP.SOBIENLAI IS NULL AND V_STATUS=3) dinh chi nop an phi
                  AND ((V_TUNGAY IS NULL OR TP.NGAYTHONGBAO>=V_TUNGAY) AND (V_DENNGAY IS NULL  OR TP.NGAYTHONGBAO<=V_DENNGAY))
               AND (V_TT_TRUCTUYEN IS NULL OR (TP.TT_TRUCTUYEN=V_TT_TRUCTUYEN)) AND (TP.MALOAIVUVIEC=V_LOAI_AN OR V_LOAI_AN IS NULL)
               AND TP.MA_THONGBAO IS NOT NULL
               AND (V_FILE_THA IS NULL
                                        OR (V_FILE_THA=1 AND TP.ANPHI_FILE_NAME IS NOT NULL )
                                        OR (V_FILE_THA=0 AND TP.ANPHI_FILE_NAME IS NULL )
                )
        ) DS WHERE DS.STT>=MININDEX AND DS.STT<=MAXINDEX;
    RETURN v_cursor;   
END TC_DANHSACH_ANPHI_QLTA;

FUNCTION TC_DANHSACH_ANPHI_IN_DS 
(
  V_GET_CHIL IN VARCHAR2 DEFAULT NULL, 
  V_LOAI_AN IN VARCHAR2 DEFAULT NULL, 
  V_TT_TRUCTUYEN IN VARCHAR2 DEFAULT NULL, 
  V_DATE_FROM IN VARCHAR2 DEFAULT NULL,  
  V_DATE_TO IN VARCHAR2 DEFAULT NULL, 
  V_STATUS IN NVARCHAR2 DEFAULT NULL,
  V_USERNAME IN NVARCHAR2 DEFAULT NULL,
  V_DONVITHA_ID IN NVARCHAR2 DEFAULT NULL,
  vTuKhoaBasic IN NVARCHAR2 DEFAULT NULL,
  PageIndex	in	int,
  PageSize	in	int
)
RETURN SYS_REFCURSOR
AS
      MinIndex	number;V_LOAITOA VARCHAR2(150):=NULL; VV_DATE_FROM VARCHAR2(150):=NULL;VV_DATE_TO VARCHAR2(150):=NULL;
      MaxIndex	number;var_arrsx  varchar2(250); V_EXPORT_TEXT CLOB; 
      v_cursor SYS_REFCURSOR;v_table T_TUPHAP_ANPHI;V_STT number:=0;V_TUNGAY DATE;V_DENNGAY DATE;
BEGIN
 DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
 v_table := T_TUPHAP_ANPHI(); --dung bang ding nghia
  SELECT DECODE(V_DATE_FROM,NULL,'.....',V_DATE_FROM),DECODE(V_DATE_TO,NULL,'.....',V_DATE_TO) INTO VV_DATE_FROM,VV_DATE_TO FROM DUAL;
  -----------------------
     IF(V_DATE_FROM IS NOT NULL) THEN
        V_TUNGAY:=TO_DATE(V_DATE_FROM||'00:00:00','dd/mm/yyyy hh24:mi:ss');
     END IF;
     IF(V_DATE_TO IS NOT NULL)THEN
        V_DENNGAY:=TO_DATE(V_DATE_TO||'23:59:59','dd/mm/yyyy hh24:mi:ss');
     END IF;
 ------------------------
  FOR item_tp IN 
            (
                SELECT TD.NGAYTAO,THA.ID DONVITHA_ID,NULL TENFILE,'Dân sự' LOAIAN,TO_CHAR(DO.MAVUVIEC)MAVUVIEC,TD.BIEUMAUID,'2' AS MALOAIVUVIEC,TD.FILEID,TD.DONID,DU.ID DUONGSU_ID,AI.SOTHONGBAO||'/TB-TA' AS SOTHONGBAO,
                'Họ tên:<b> '||DU.TENDUONGSU||'</b><br/> Năm sinh: '||DU.NAMSINH||'<br/> CCCD: '||DU.SOCMND||'<br/> Điên thoại: '||DU.DIENTHOAI||'<br/> Email: '||DU.EMAIL||'<br/>' TENDUONGSU,DU.NAMSINH,DU.GIOITINH,DU.SOCMND,DU.DIENTHOAI,DU.EMAIL,TN.MA_TEN DONVI,AI.TAMUNGANPHI,
                DECODE(tt.TRANGTHAITHANHTOAN,0,'Chưa nộp án phí',1,'Đã nộp án phí') STATUS,HC.MA_TEN,
                DECODE(DU.TAMTRUCHITIET,NULL,HC.MA_TEN,REPLACE(DU.TAMTRUCHITIET,',')||', '||HC.MA_TEN) AS DIACHI,
                TA.HOANTRAAP_HOTEN,TA.HOANTRAAP_GIOITINH,TA.HOANTRAAP_NAMSINH,TA.HOANTRAAP_CMND,TA.HOANTRAAP_TEL,TA.HOANTRAAP_EMAIL,TA.HOANTRAAP_DIACHI,
                TA.NGAYBIENLAI,TA.SOBIENLAI,TA.NGUOITHUTIEN,DX.NGAYGQ_YC,
                TA.NOP_ISNGUYENDON,TA.NOP_GIOITINH,decode(tt.TT_TRUCTUYEN,1,TT.HOTENNGUOINOPTIEN,TA.NOP_HOTEN)NOP_HOTEN,TA.NOP_NAMSINH,decode(tt.TT_TRUCTUYEN,1,tt.SOCMNDNGUOINOP,TA.NOP_CMND)NOP_CMND,TA.NOP_TEL,TA.NOP_EMAIL,decode(tt.TT_TRUCTUYEN,1,TT.DIACHINGUOINOPTIEN,TA.NOP_DIACHI)NOP_DIACHI,TA.HOANTRAAP_ISNGUYENDON,DU.LOAIDUONGSU               
                ,TA.ANPHIHOANTRA,TA.NGAYHOANTRA,DECODE(DC.DONID,NULL,0,1) DINHCHI,TT.MA_THONGBAO,TT.TT_TRUCTUYEN,BL.FILE_NAME,TT.TRANGTHAITHANHTOAN,AI.ID ANPHI_ID,TT.ID DVCQG_TT_ID,AI.NGAYTHONGBAO
               ,FA.FILE_NAME ANPHI_FILE_NAME,TA.NGUOISUA,TA.NGAYSUA,TA.ID TUPHAP_ANPHI_ID
                FROM ADS_TONGDAT TD 
                INNER JOIN ADS_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN ADS_ANPHI AI ON TD.DONID=AI.DONID
                LEFT JOIN ADS_FILE_THA FA ON FA.ANPHI_ID=AI.ID AND FA.STATUS=1
               -- LEFT JOIN (select ANPHI_ID,FILE_NAME from ADS_FILE_THA WHERE STATUS=1) FA ON FA.ANPHI_ID=AI.ID
                INNER JOIN ADS_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
               -- INNER JOIN ADS_TONGDAT_DOITUONG DO ON DO.DUONGSUID =DU.id
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN ADS_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
               -- LEFT JOIN ADS_FILE FL ON FL.DONID=TD.DONID AND FL.BIEUMAUID=67
                LEFT JOIN (SELECT QD.DONID FROM ADS_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi    
                LEFT JOIN DVCQG_THANH_TOAN TT ON tt.DUONGSU_ID=AI.DUONGSU_ID AND TT.MALOAIVUVIEC='2'
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.DUONGSU_ID=TT.DUONGSU_ID AND TA.anphi_id=AI.ID AND TA.MALOAIVUVIEC='2'
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE DU.TUCACHTOTUNG_MA='NGUYENDON' AND TD.BIEUMAUID IN(67,381) --Thông báo nộp tiền tạm ứng án phí
               --AND DU.ISDAIDIEN = 1 --AND NULL TENFILE IS NOT NULL
                AND AI.TAMUNGANPHI !=0
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := R_TUPHAP_ANPHI(
        item_tp.NGAYTAO, item_tp.DONVITHA_ID,item_tp.TENFILE,item_tp.LOAIAN,item_tp.MAVUVIEC,item_tp.BIEUMAUID,item_tp.MALOAIVUVIEC,item_tp.FILEID,item_tp.DONID,item_tp.DUONGSU_ID,
        item_tp.SOTHONGBAO,item_tp.TENDUONGSU,item_tp.NAMSINH,item_tp.GIOITINH,item_tp.SOCMND,item_tp.DIENTHOAI,item_tp.EMAIL,item_tp.DONVI,item_tp.TAMUNGANPHI,item_tp.STATUS,item_tp.MA_TEN,item_tp.DIACHI,
        item_tp.HOANTRAAP_HOTEN,item_tp.HOANTRAAP_GIOITINH,item_tp.HOANTRAAP_NAMSINH,item_tp.HOANTRAAP_CMND,item_tp.HOANTRAAP_TEL,item_tp.HOANTRAAP_EMAIL,item_tp.HOANTRAAP_DIACHI,item_tp.NGAYBIENLAI,item_tp.SOBIENLAI,item_tp.NGUOITHUTIEN,item_tp.NGAYGQ_YC,
        item_tp.NOP_ISNGUYENDON,item_tp.NOP_GIOITINH,item_tp.NOP_HOTEN,item_tp.NOP_NAMSINH,item_tp.NOP_CMND,item_tp.NOP_TEL,item_tp.NOP_EMAIL,item_tp.NOP_DIACHI,item_tp.HOANTRAAP_ISNGUYENDON,item_tp.LOAIDUONGSU
        ,item_tp.ANPHIHOANTRA,item_tp.NGAYHOANTRA,item_tp.DINHCHI,item_tp.MA_THONGBAO,item_tp.TT_TRUCTUYEN,item_tp.FILE_NAME,NULL,item_tp.TRANGTHAITHANHTOAN,item_tp.ANPHI_ID,item_tp.DVCQG_TT_ID,item_tp.NGAYTHONGBAO
         ,item_tp.ANPHI_FILE_NAME,item_tp.NGAYSUA,item_tp.NGUOISUA,item_tp.TUPHAP_ANPHI_ID);    
    END LOOP;
      -----------
     FOR item_tp IN 
            (
                SELECT TD.NGAYTAO,THA.ID DONVITHA_ID,NULL TENFILE,'Hôn nhân' LOAIAN,DO.MAVUVIEC,TD.BIEUMAUID,'3' AS MALOAIVUVIEC,TD.FILEID,TD.DONID,0 DUONGSU_ID,AI.SOTHONGBAO||'/TB-TA' AS SOTHONGBAO,
                AP.TENDUONGSU,null NAMSINH,null GIOITINH,null SOCMND,null DIENTHOAI,null EMAIL,TN.MA_TEN DONVI,AI.TAMUNGANPHI,
                DECODE(tt.TRANGTHAITHANHTOAN,0,'Chưa nộp án phí',1,'Đã nộp án phí') STATUS,null MA_TEN,
                null AS DIACHI,
                TA.HOANTRAAP_HOTEN,TA.HOANTRAAP_GIOITINH,TA.HOANTRAAP_NAMSINH,TA.HOANTRAAP_CMND,TA.HOANTRAAP_TEL,TA.HOANTRAAP_EMAIL,TA.HOANTRAAP_DIACHI,
                TA.NGAYBIENLAI,TA.SOBIENLAI,TA.NGUOITHUTIEN,DX.NGAYGQ_YC,
                TA.NOP_ISNGUYENDON,TA.NOP_GIOITINH,decode(tt.TT_TRUCTUYEN,1,TT.HOTENNGUOINOPTIEN,TA.NOP_HOTEN)NOP_HOTEN,TA.NOP_NAMSINH,decode(tt.TT_TRUCTUYEN,1,tt.SOCMNDNGUOINOP,TA.NOP_CMND)NOP_CMND,TA.NOP_TEL,TA.NOP_EMAIL,decode(tt.TT_TRUCTUYEN,1,TT.DIACHINGUOINOPTIEN,TA.NOP_DIACHI)NOP_DIACHI,TA.HOANTRAAP_ISNGUYENDON,null LOAIDUONGSU
                ,TA.ANPHIHOANTRA,TA.NGAYHOANTRA,DECODE(DC.DONID,NULL,0,1) DINHCHI,TT.MA_THONGBAO,TT.TT_TRUCTUYEN,BL.FILE_NAME, AI.DUONGSU_IDS,TT.TRANGTHAITHANHTOAN,AI.ID ANPHI_ID,TT.ID DVCQG_TT_ID,AI.NGAYTHONGBAO
                ,NULL ANPHI_FILE_NAME,TA.NGUOISUA,TA.NGAYSUA,TA.ID TUPHAP_ANPHI_ID
                FROM AHN_TONGDAT TD 
                INNER JOIN AHN_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN AHN_ANPHI AI ON TD.DONID=AI.DONID
                LEFT JOIN (SELECT LISTAGG('Họ tên:<b> '||HN.TENDUONGSU||'</b><br/> Năm sinh: '||HN.NAMSINH||'<br/> CCCD: '||HN.SOCMND||'<br/> Điên thoại: '||HN.DIENTHOAI||'<br/> Email: '||HN.EMAIL||'<br/>', '')
                                   WITHIN GROUP (ORDER BY 'Họ tên:<b> '||HN.TENDUONGSU||'</b><br/> Năm sinh: '||HN.NAMSINH||'<br/> CCCD: '||HN.SOCMND||'<br/> Điên thoại: '||HN.DIENTHOAI||'<br/> Email: '||HN.EMAIL||'<br/>') TENDUONGSU ,
                             DU.ANPHI_ID
                             FROM AHN_ANPHI_DUONGSU DU LEFT JOIN AHN_DON_DUONGSU HN ON HN.ID=DU.DUONGSU_ID
                             GROUP BY DU.ANPHI_ID
                          )AP ON AP.ANPHI_ID=AI.ID
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                LEFT JOIN AHN_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.anphi_id=AI.ID AND TA.MALOAIVUVIEC='3'
                LEFT JOIN (SELECT QD.DONID FROM AHN_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
                LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='3'
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE  TD.BIEUMAUID IN(67,381) AND
                 AI.TAMUNGANPHI !=0
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := R_TUPHAP_ANPHI(
        item_tp.NGAYTAO, item_tp.DONVITHA_ID,item_tp.TENFILE,item_tp.LOAIAN,item_tp.MAVUVIEC,item_tp.BIEUMAUID,item_tp.MALOAIVUVIEC,item_tp.FILEID,item_tp.DONID,item_tp.DUONGSU_ID,
        item_tp.SOTHONGBAO,item_tp.TENDUONGSU,item_tp.NAMSINH,item_tp.GIOITINH,item_tp.SOCMND,item_tp.DIENTHOAI,item_tp.EMAIL,item_tp.DONVI,item_tp.TAMUNGANPHI,item_tp.STATUS,item_tp.MA_TEN,item_tp.DIACHI,
        item_tp.HOANTRAAP_HOTEN,item_tp.HOANTRAAP_GIOITINH,item_tp.HOANTRAAP_NAMSINH,item_tp.HOANTRAAP_CMND,item_tp.HOANTRAAP_TEL,item_tp.HOANTRAAP_EMAIL,item_tp.HOANTRAAP_DIACHI,item_tp.NGAYBIENLAI,item_tp.SOBIENLAI,item_tp.NGUOITHUTIEN,item_tp.NGAYGQ_YC,
        item_tp.NOP_ISNGUYENDON,item_tp.NOP_GIOITINH,item_tp.NOP_HOTEN,item_tp.NOP_NAMSINH,item_tp.NOP_CMND,item_tp.NOP_TEL,item_tp.NOP_EMAIL,item_tp.NOP_DIACHI,item_tp.HOANTRAAP_ISNGUYENDON,item_tp.LOAIDUONGSU
        ,item_tp.ANPHIHOANTRA,item_tp.NGAYHOANTRA,item_tp.DINHCHI,item_tp.MA_THONGBAO,item_tp.TT_TRUCTUYEN,item_tp.FILE_NAME,item_tp.DUONGSU_IDS,item_tp.TRANGTHAITHANHTOAN,item_tp.ANPHI_ID,item_tp.DVCQG_TT_ID,item_tp.NGAYTHONGBAO
        ,item_tp.ANPHI_FILE_NAME,item_tp.NGAYSUA,item_tp.NGUOISUA,item_tp.TUPHAP_ANPHI_ID);   
    END LOOP;
      -----------
     FOR item_tp IN 
            (
               SELECT TD.NGAYTAO,THA.ID DONVITHA_ID,NULL TENFILE,'Kinh tế' LOAIAN,DO.MAVUVIEC,TD.BIEUMAUID,'4' AS MALOAIVUVIEC,TD.FILEID,TD.DONID,DU.ID DUONGSU_ID,AI.SOTHONGBAO||'/TB-TA' AS SOTHONGBAO,
                'Họ tên:<b> '||DU.TENDUONGSU||'</b><br/> Năm sinh: '||DU.NAMSINH||'<br/> CCCD: '||DU.SOCMND||'<br/> Điên thoại: '||DU.DIENTHOAI||'<br/> Email: '||DU.EMAIL||'<br/>' TENDUONGSU,DU.NAMSINH,DU.GIOITINH,DU.SOCMND,DU.DIENTHOAI,DU.EMAIL,TN.MA_TEN DONVI,AI.TAMUNGANPHI,
                DECODE(tt.TRANGTHAITHANHTOAN,0,'Chưa nộp án phí',1,'Đã nộp án phí') STATUS,HC.MA_TEN,
                DECODE(DU.TAMTRUCHITIET,NULL,HC.MA_TEN,REPLACE(DU.TAMTRUCHITIET,',')||', '||HC.MA_TEN) AS DIACHI,
                TA.HOANTRAAP_HOTEN,TA.HOANTRAAP_GIOITINH,TA.HOANTRAAP_NAMSINH,TA.HOANTRAAP_CMND,TA.HOANTRAAP_TEL,TA.HOANTRAAP_EMAIL,TA.HOANTRAAP_DIACHI,
                TA.NGAYBIENLAI,TA.SOBIENLAI,TA.NGUOITHUTIEN,DX.NGAYGQ_YC,
                TA.NOP_ISNGUYENDON,TA.NOP_GIOITINH,decode(tt.TT_TRUCTUYEN,1,TT.HOTENNGUOINOPTIEN,TA.NOP_HOTEN)NOP_HOTEN,TA.NOP_NAMSINH,decode(tt.TT_TRUCTUYEN,1,tt.SOCMNDNGUOINOP,TA.NOP_CMND)NOP_CMND,TA.NOP_TEL,TA.NOP_EMAIL,decode(tt.TT_TRUCTUYEN,1,TT.DIACHINGUOINOPTIEN,TA.NOP_DIACHI)NOP_DIACHI,TA.HOANTRAAP_ISNGUYENDON,DU.LOAIDUONGSU
                ,TA.ANPHIHOANTRA,TA.NGAYHOANTRA,DECODE(DC.DONID,NULL,0,1) DINHCHI,TT.MA_THONGBAO,TT.TT_TRUCTUYEN,BL.FILE_NAME,TT.TRANGTHAITHANHTOAN,AI.ID ANPHI_ID,TT.ID DVCQG_TT_ID,AI.NGAYTHONGBAO
                 ,NULL ANPHI_FILE_NAME,TA.NGUOISUA,TA.NGAYSUA,TA.ID TUPHAP_ANPHI_ID
                FROM AKT_TONGDAT TD 
                INNER JOIN AKT_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN AKT_ANPHI AI ON TD.DONID=AI.DONID
                INNER JOIN AKT_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
                --INNER JOIN AKT_TONGDAT_DOITUONG DO ON DO.DUONGSUID =DU.id
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN AKT_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.anphi_id=AI.ID AND TA.MALOAIVUVIEC='4'
--                LEFT JOIN AKT_FILE FL ON FL.DONID=TD.DONID AND FL.BIEUMAUID=67
                LEFT JOIN (SELECT QD.DONID FROM AKT_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
                LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='4'
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE DU.TUCACHTOTUNG_MA='NGUYENDON' AND TD.BIEUMAUID IN(67,381) --Thông báo nộp tiền tạm ứng án phí
               -- AND DU.ISDAIDIEN = 1 --AND NULL TENFILE IS NOT NULL
                AND AI.TAMUNGANPHI !=0
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := R_TUPHAP_ANPHI(
        item_tp.NGAYTAO, item_tp.DONVITHA_ID,item_tp.TENFILE,item_tp.LOAIAN,item_tp.MAVUVIEC,item_tp.BIEUMAUID,item_tp.MALOAIVUVIEC,item_tp.FILEID,item_tp.DONID,item_tp.DUONGSU_ID,
        item_tp.SOTHONGBAO,item_tp.TENDUONGSU,item_tp.NAMSINH,item_tp.GIOITINH,item_tp.SOCMND,item_tp.DIENTHOAI,item_tp.EMAIL,item_tp.DONVI,item_tp.TAMUNGANPHI,item_tp.STATUS,item_tp.MA_TEN,item_tp.DIACHI,
        item_tp.HOANTRAAP_HOTEN,item_tp.HOANTRAAP_GIOITINH,item_tp.HOANTRAAP_NAMSINH,item_tp.HOANTRAAP_CMND,item_tp.HOANTRAAP_TEL,item_tp.HOANTRAAP_EMAIL,item_tp.HOANTRAAP_DIACHI,item_tp.NGAYBIENLAI,item_tp.SOBIENLAI,item_tp.NGUOITHUTIEN,item_tp.NGAYGQ_YC,
        item_tp.NOP_ISNGUYENDON,item_tp.NOP_GIOITINH,item_tp.NOP_HOTEN,item_tp.NOP_NAMSINH,item_tp.NOP_CMND,item_tp.NOP_TEL,item_tp.NOP_EMAIL,item_tp.NOP_DIACHI,item_tp.HOANTRAAP_ISNGUYENDON,item_tp.LOAIDUONGSU
        ,item_tp.ANPHIHOANTRA,item_tp.NGAYHOANTRA,item_tp.DINHCHI,item_tp.MA_THONGBAO,item_tp.TT_TRUCTUYEN,item_tp.FILE_NAME,NULL,item_tp.TRANGTHAITHANHTOAN,item_tp.ANPHI_ID,item_tp.DVCQG_TT_ID,item_tp.NGAYTHONGBAO
         ,item_tp.ANPHI_FILE_NAME,item_tp.NGAYSUA,item_tp.NGUOISUA,item_tp.TUPHAP_ANPHI_ID);    
    END LOOP;
       -----------
     FOR item_tp IN 
            (
                SELECT TD.NGAYTAO,THA.ID DONVITHA_ID,NULL TENFILE,'Lao động' LOAIAN,DO.MAVUVIEC,TD.BIEUMAUID,'5' AS MALOAIVUVIEC,TD.FILEID,TD.DONID,DU.ID DUONGSU_ID,AI.SOTHONGBAO||'/TB-TA' AS SOTHONGBAO,
                'Họ tên:<b> '||DU.TENDUONGSU||'</b><br/> Năm sinh: '||DU.NAMSINH||'<br/> CCCD: '||DU.SOCMND||'<br/> Điên thoại: '||DU.DIENTHOAI||'<br/> Email: '||DU.EMAIL||'<br/>'TENDUONGSU,DU.NAMSINH,DU.GIOITINH,DU.SOCMND,DU.DIENTHOAI,DU.EMAIL,TN.MA_TEN DONVI,AI.TAMUNGANPHI,
                DECODE(tt.TRANGTHAITHANHTOAN,0,'Chưa nộp án phí',1,'Đã nộp án phí') STATUS,HC.MA_TEN,
                DECODE(DU.TAMTRUCHITIET,NULL,HC.MA_TEN,REPLACE(DU.TAMTRUCHITIET,',')||', '||HC.MA_TEN) AS DIACHI,
                TA.HOANTRAAP_HOTEN,TA.HOANTRAAP_GIOITINH,TA.HOANTRAAP_NAMSINH,TA.HOANTRAAP_CMND,TA.HOANTRAAP_TEL,TA.HOANTRAAP_EMAIL,TA.HOANTRAAP_DIACHI,
                TA.NGAYBIENLAI,TA.SOBIENLAI,TA.NGUOITHUTIEN,DX.NGAYGQ_YC,
                TA.NOP_ISNGUYENDON,TA.NOP_GIOITINH,decode(tt.TT_TRUCTUYEN,1,TT.HOTENNGUOINOPTIEN,TA.NOP_HOTEN)NOP_HOTEN,TA.NOP_NAMSINH,decode(tt.TT_TRUCTUYEN,1,tt.SOCMNDNGUOINOP,TA.NOP_CMND)NOP_CMND,TA.NOP_TEL,TA.NOP_EMAIL,decode(tt.TT_TRUCTUYEN,1,TT.DIACHINGUOINOPTIEN,TA.NOP_DIACHI)NOP_DIACHI,TA.HOANTRAAP_ISNGUYENDON,DU.LOAIDUONGSU
               ,TA.ANPHIHOANTRA,TA.NGAYHOANTRA,DECODE(DC.DONID,NULL,0,1) DINHCHI,TT.MA_THONGBAO,TT.TT_TRUCTUYEN,BL.FILE_NAME,TT.TRANGTHAITHANHTOAN,AI.ID ANPHI_ID,TT.ID DVCQG_TT_ID,AI.NGAYTHONGBAO
                ,NULL ANPHI_FILE_NAME,TA.NGUOISUA,TA.NGAYSUA,TA.ID TUPHAP_ANPHI_ID
                FROM ALD_TONGDAT TD 
                INNER JOIN ALD_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN ALD_ANPHI AI ON TD.DONID=AI.DONID
                INNER JOIN ALD_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
               -- INNER JOIN ALD_TONGDAT_DOITUONG DO ON DO.DUONGSUID =DU.id
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN ALD_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.anphi_id=AI.ID AND TA.MALOAIVUVIEC='5'
--                LEFT JOIN ALD_FILE FL ON FL.DONID=TD.DONID AND FL.BIEUMAUID=67
                LEFT JOIN (SELECT QD.DONID FROM ALD_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
                LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='5'
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE DU.TUCACHTOTUNG_MA='NGUYENDON' AND TD.BIEUMAUID IN(67,381) --Thông báo nộp tiền tạm ứng án phí
               -- AND DU.ISDAIDIEN = 1 --AND NULL TENFILE IS NOT NULL
                AND AI.TAMUNGANPHI !=0
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := R_TUPHAP_ANPHI(
        item_tp.NGAYTAO, item_tp.DONVITHA_ID,item_tp.TENFILE,item_tp.LOAIAN,item_tp.MAVUVIEC,item_tp.BIEUMAUID,item_tp.MALOAIVUVIEC,item_tp.FILEID,item_tp.DONID,item_tp.DUONGSU_ID,
        item_tp.SOTHONGBAO,item_tp.TENDUONGSU,item_tp.NAMSINH,item_tp.GIOITINH,item_tp.SOCMND,item_tp.DIENTHOAI,item_tp.EMAIL,item_tp.DONVI,item_tp.TAMUNGANPHI,item_tp.STATUS,item_tp.MA_TEN,item_tp.DIACHI,
        item_tp.HOANTRAAP_HOTEN,item_tp.HOANTRAAP_GIOITINH,item_tp.HOANTRAAP_NAMSINH,item_tp.HOANTRAAP_CMND,item_tp.HOANTRAAP_TEL,item_tp.HOANTRAAP_EMAIL,item_tp.HOANTRAAP_DIACHI,item_tp.NGAYBIENLAI,item_tp.SOBIENLAI,item_tp.NGUOITHUTIEN,item_tp.NGAYGQ_YC,
        item_tp.NOP_ISNGUYENDON,item_tp.NOP_GIOITINH,item_tp.NOP_HOTEN,item_tp.NOP_NAMSINH,item_tp.NOP_CMND,item_tp.NOP_TEL,item_tp.NOP_EMAIL,item_tp.NOP_DIACHI,item_tp.HOANTRAAP_ISNGUYENDON,item_tp.LOAIDUONGSU
        ,item_tp.ANPHIHOANTRA,item_tp.NGAYHOANTRA,item_tp.DINHCHI,item_tp.MA_THONGBAO,item_tp.TT_TRUCTUYEN,item_tp.FILE_NAME,NULL,item_tp.TRANGTHAITHANHTOAN,item_tp.ANPHI_ID,item_tp.DVCQG_TT_ID,item_tp.NGAYTHONGBAO
        ,item_tp.ANPHI_FILE_NAME,item_tp.NGAYSUA,item_tp.NGUOISUA,item_tp.TUPHAP_ANPHI_ID);    
    END LOOP;
    FOR item_tp IN 
            (
            SELECT TD.NGAYTAO,THA.ID DONVITHA_ID,NULL TENFILE,'Hành chính' LOAIAN,DO.MAVUVIEC,TD.BIEUMAUID,'6' AS MALOAIVUVIEC,TD.FILEID,TD.DONID,0 DUONGSU_ID,AI.SOTHONGBAO||'/TB-TA' AS SOTHONGBAO,
                AP.TENDUONGSU,null NAMSINH,null GIOITINH,null SOCMND,null DIENTHOAI,null EMAIL,TN.MA_TEN DONVI,AI.TAMUNGANPHI,
                DECODE(tt.TRANGTHAITHANHTOAN,0,'Chưa nộp án phí',1,'Đã nộp án phí') STATUS,null MA_TEN,
                null AS DIACHI,
                TA.HOANTRAAP_HOTEN,TA.HOANTRAAP_GIOITINH,TA.HOANTRAAP_NAMSINH,TA.HOANTRAAP_CMND,TA.HOANTRAAP_TEL,TA.HOANTRAAP_EMAIL,TA.HOANTRAAP_DIACHI,
                TA.NGAYBIENLAI,TA.SOBIENLAI,TA.NGUOITHUTIEN,DX.NGAYGQ_YC,
                TA.NOP_ISNGUYENDON,TA.NOP_GIOITINH,decode(tt.TT_TRUCTUYEN,1,TT.HOTENNGUOINOPTIEN,TA.NOP_HOTEN)NOP_HOTEN,TA.NOP_NAMSINH,decode(tt.TT_TRUCTUYEN,1,tt.SOCMNDNGUOINOP,TA.NOP_CMND)NOP_CMND,TA.NOP_TEL,TA.NOP_EMAIL,decode(tt.TT_TRUCTUYEN,1,TT.DIACHINGUOINOPTIEN,TA.NOP_DIACHI)NOP_DIACHI,TA.HOANTRAAP_ISNGUYENDON,null LOAIDUONGSU
                ,TA.ANPHIHOANTRA,TA.NGAYHOANTRA,DECODE(DC.DONID,NULL,0,1) DINHCHI,TT.MA_THONGBAO,TT.TT_TRUCTUYEN,BL.FILE_NAME,AI.DUONGSU_IDS,TT.TRANGTHAITHANHTOAN,AI.ID ANPHI_ID,TT.ID DVCQG_TT_ID,AI.NGAYTHONGBAO
                ,NULL ANPHI_FILE_NAME,TA.NGUOISUA,TA.NGAYSUA,TA.ID TUPHAP_ANPHI_ID
                FROM AHC_TONGDAT TD 
                INNER JOIN AHC_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN AHC_ANPHI AI ON TD.DONID=AI.DONID
                LEFT JOIN (select ANPHI_ID,FILE_NAME from AHC_FILE_THA WHERE STATUS=1) FA ON FA.ANPHI_ID=AI.ID
                LEFT JOIN (SELECT LISTAGG('Họ tên:<b> '||HN.TENDUONGSU||'</b><br/> Năm sinh: '||HN.NAMSINH||'<br/> CCCD: '||HN.SOCMND||'<br/> Điên thoại: '||HN.DIENTHOAI||'<br/> Email: '||HN.EMAIL||'<br/>', '')
                                   WITHIN GROUP (ORDER BY 'Họ tên:<b> '||HN.TENDUONGSU||'</b><br/> Năm sinh: '||HN.NAMSINH||'<br/> CCCD: '||HN.SOCMND||'<br/> Điên thoại: '||HN.DIENTHOAI||'<br/> Email: '||HN.EMAIL||'<br/>') TENDUONGSU ,
                             DU.ANPHI_ID
                             FROM AHC_ANPHI_DUONGSU DU LEFT JOIN AHC_DON_DUONGSU HN ON HN.ID=DU.DUONGSU_ID
                             GROUP BY DU.ANPHI_ID
                          )AP ON AP.ANPHI_ID=AI.ID
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                LEFT JOIN AHC_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON  TA.anphi_id=AI.ID and TA.VUVIECID=TD.DONID AND TA.MALOAIVUVIEC='6'
                LEFT JOIN AHC_FILE FL ON FL.id=TD.FILEID
                LEFT JOIN (SELECT QD.DONID FROM AHC_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
                LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.ANPHI_ID=AI.ID AND TT.MALOAIVUVIEC='6'
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE TD.BIEUMAUID=121 AND TA.MALOAIVUVIEC='6'
                AND AI.TAMUNGANPHI !=0
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := R_TUPHAP_ANPHI(
        item_tp.NGAYTAO, item_tp.DONVITHA_ID,item_tp.TENFILE,item_tp.LOAIAN,item_tp.MAVUVIEC,item_tp.BIEUMAUID,item_tp.MALOAIVUVIEC,item_tp.FILEID,item_tp.DONID,item_tp.DUONGSU_ID,
        item_tp.SOTHONGBAO,item_tp.TENDUONGSU,item_tp.NAMSINH,item_tp.GIOITINH,item_tp.SOCMND,item_tp.DIENTHOAI,item_tp.EMAIL,item_tp.DONVI,item_tp.TAMUNGANPHI,item_tp.STATUS,item_tp.MA_TEN,item_tp.DIACHI,
        item_tp.HOANTRAAP_HOTEN,item_tp.HOANTRAAP_GIOITINH,item_tp.HOANTRAAP_NAMSINH,item_tp.HOANTRAAP_CMND,item_tp.HOANTRAAP_TEL,item_tp.HOANTRAAP_EMAIL,item_tp.HOANTRAAP_DIACHI,item_tp.NGAYBIENLAI,item_tp.SOBIENLAI,item_tp.NGUOITHUTIEN,item_tp.NGAYGQ_YC,
        item_tp.NOP_ISNGUYENDON,item_tp.NOP_GIOITINH,item_tp.NOP_HOTEN,item_tp.NOP_NAMSINH,item_tp.NOP_CMND,item_tp.NOP_TEL,item_tp.NOP_EMAIL,item_tp.NOP_DIACHI,item_tp.HOANTRAAP_ISNGUYENDON,item_tp.LOAIDUONGSU
       ,item_tp.ANPHIHOANTRA,item_tp.NGAYHOANTRA,item_tp.DINHCHI,item_tp.MA_THONGBAO,item_tp.TT_TRUCTUYEN,item_tp.FILE_NAME,item_tp.DUONGSU_IDS,item_tp.TRANGTHAITHANHTOAN,item_tp.ANPHI_ID,item_tp.DVCQG_TT_ID,item_tp.NGAYTHONGBAO
       ,item_tp.ANPHI_FILE_NAME,item_tp.NGAYSUA,item_tp.NGUOISUA,item_tp.TUPHAP_ANPHI_ID);  
    END LOOP;
     ------------------
    FOR item_tp IN 
            (
                SELECT TD.NGAYTAO,THA.ID DONVITHA_ID,NULL TENFILE,'Phá sản' LOAIAN,DO.MAVUVIEC,TD.BIEUMAUID,'7' AS MALOAIVUVIEC,TD.FILEID,TD.DONID,DU.ID DUONGSU_ID,AI.SOTHONGBAO||'/TB-TA' AS SOTHONGBAO,
                'Họ tên:<b> '||DU.TENDUONGSU||'</b><br/> Năm sinh: '||DU.NAMSINH||'<br/> CCCD: '||DU.SOCMND||'<br/> Điên thoại: '||DU.DIENTHOAI||'<br/> Email: '||DU.EMAIL||'<br/>' TENDUONGSU,DU.NAMSINH,DU.GIOITINH,DU.SOCMND,DU.DIENTHOAI,DU.EMAIL,TN.MA_TEN DONVI,AI.TAMUNGANPHI,
                DECODE(tt.TRANGTHAITHANHTOAN,0,'Chưa nộp án phí',1,'Đã nộp án phí') STATUS,HC.MA_TEN,
                DECODE(DU.TAMTRUCHITIET,NULL,HC.MA_TEN,REPLACE(DU.TAMTRUCHITIET,',')||', '||HC.MA_TEN) AS DIACHI,
                TA.HOANTRAAP_HOTEN,TA.HOANTRAAP_GIOITINH,TA.HOANTRAAP_NAMSINH,TA.HOANTRAAP_CMND,TA.HOANTRAAP_TEL,TA.HOANTRAAP_EMAIL,TA.HOANTRAAP_DIACHI,
                TA.NGAYBIENLAI,TA.SOBIENLAI,TA.NGUOITHUTIEN,DX.NGAYGQ_YC,
                TA.NOP_ISNGUYENDON,TA.NOP_GIOITINH,decode(tt.TT_TRUCTUYEN,1,TT.HOTENNGUOINOPTIEN,TA.NOP_HOTEN)NOP_HOTEN,TA.NOP_NAMSINH,decode(tt.TT_TRUCTUYEN,1,tt.SOCMNDNGUOINOP,TA.NOP_CMND)NOP_CMND,TA.NOP_TEL,TA.NOP_EMAIL,decode(tt.TT_TRUCTUYEN,1,TT.DIACHINGUOINOPTIEN,TA.NOP_DIACHI)NOP_DIACHI,TA.HOANTRAAP_ISNGUYENDON,DU.LOAIDUONGSU
               ,TA.ANPHIHOANTRA,TA.NGAYHOANTRA,DECODE(DC.DONID,NULL,0,1) DINHCHI,TT.MA_THONGBAO,TT.TT_TRUCTUYEN,BL.FILE_NAME,TT.TRANGTHAITHANHTOAN,AI.ID ANPHI_ID,TT.ID DVCQG_TT_ID,AI.NGAYTHONGBAO
                ,NULL ANPHI_FILE_NAME,TA.NGUOISUA,TA.NGAYSUA,TA.ID TUPHAP_ANPHI_ID
                FROM APS_TONGDAT TD 
                INNER JOIN APS_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN APS_ANPHI AI ON TD.DONID=AI.DONID
                INNER JOIN APS_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
               -- INNER JOIN APS_TONGDAT_DOITUONG DO ON DO.DUONGSUID =DU.id
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN APS_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.anphi_id=AI.ID AND TA.MALOAIVUVIEC='7'
--                LEFT JOIN APS_FILE FL ON FL.DONID=TD.DONID AND FL.BIEUMAUID=67
                LEFT JOIN (SELECT QD.DONID FROM APS_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
               LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='7'
               LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE DU.TUCACHTOTUNG_MA='NGUYENDON' AND TD.BIEUMAUID IN(67,381) --Thông báo nộp tiền tạm ứng án phí
               -- AND DU.ISDAIDIEN = 1 --AND NULL TENFILE IS NOT NULL
                AND AI.TAMUNGANPHI !=0
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := R_TUPHAP_ANPHI(
        item_tp.NGAYTAO, item_tp.DONVITHA_ID,item_tp.TENFILE,item_tp.LOAIAN,item_tp.MAVUVIEC,item_tp.BIEUMAUID,item_tp.MALOAIVUVIEC,item_tp.FILEID,item_tp.DONID,item_tp.DUONGSU_ID,
        item_tp.SOTHONGBAO,item_tp.TENDUONGSU,item_tp.NAMSINH,item_tp.GIOITINH,item_tp.SOCMND,item_tp.DIENTHOAI,item_tp.EMAIL,item_tp.DONVI,item_tp.TAMUNGANPHI,item_tp.STATUS,item_tp.MA_TEN,item_tp.DIACHI,
        item_tp.HOANTRAAP_HOTEN,item_tp.HOANTRAAP_GIOITINH,item_tp.HOANTRAAP_NAMSINH,item_tp.HOANTRAAP_CMND,item_tp.HOANTRAAP_TEL,item_tp.HOANTRAAP_EMAIL,item_tp.HOANTRAAP_DIACHI,item_tp.NGAYBIENLAI,item_tp.SOBIENLAI,item_tp.NGUOITHUTIEN,item_tp.NGAYGQ_YC,
        item_tp.NOP_ISNGUYENDON,item_tp.NOP_GIOITINH,item_tp.NOP_HOTEN,item_tp.NOP_NAMSINH,item_tp.NOP_CMND,item_tp.NOP_TEL,item_tp.NOP_EMAIL,item_tp.NOP_DIACHI,item_tp.HOANTRAAP_ISNGUYENDON,item_tp.LOAIDUONGSU
       ,item_tp.ANPHIHOANTRA,item_tp.NGAYHOANTRA,item_tp.DINHCHI,item_tp.MA_THONGBAO,item_tp.TT_TRUCTUYEN,item_tp.FILE_NAME,NULL,item_tp.TRANGTHAITHANHTOAN,item_tp.ANPHI_ID,item_tp.DVCQG_TT_ID,item_tp.NGAYTHONGBAO
        ,item_tp.ANPHI_FILE_NAME,item_tp.NGAYSUA,item_tp.NGUOISUA,item_tp.TUPHAP_ANPHI_ID);  
    END LOOP;
    ---------------------
     IF(V_DONVITHA_ID IS NOT NULL) THEN
        SELECT THA.LOAITOA INTO V_LOAITOA FROM DM_DONVITHIHANHAN THA WHERE THA.ID=V_DONVITHA_ID;
        select t.ARRSAPXEP into var_arrsx from DM_DONVITHIHANHAN t where t.ID=V_DONVITHA_ID;
      END IF;
    --------------------------
    SELECT DECODE(V_DATE_FROM,NULL,'.....',V_DATE_FROM),DECODE(V_DATE_TO,NULL,'.....',V_DATE_TO) INTO VV_DATE_FROM,VV_DATE_TO FROM DUAL;
    IF(V_STATUS='0' or V_STATUS='3' or V_STATUS is null)THEN
          DBMS_LOB.APPEND(V_EXPORT_TEXT,'
          <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center;">
            <tr style="text-align: center;">
                <th colspan="6" style="text-align: center; vertical-align: middle; font-size: 14pt; height:39px;">DANH SÁCH</th>
            </tr>
            <tr>
                <td colspan="6" style="text-align: center; vertical-align: top; font-style: italic; height: 30px;">Từ ngày '||VV_DATE_FROM||' đến ngày '||VV_DATE_TO||'</td>
            </tr>
            <tr style="">
                <th style="text-align: center; vertical-align: middle; border: 0.1pt solid Black; height: 61px;">STT</th>
                <th style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Thông tin vụ việc</th>
                <th style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Thông tin đương sự</th>
                <th style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Tòa án giải quyết</th>
                <th style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Số tiền tạm ứng án phí (VNĐ)</th>
                <th style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Trạng thái</th>
            </tr>
           <tr style="font-style: italic;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;" >1</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;" >2</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;" >3</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;" >4</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;" >5</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;" >6</td>
            </tr>
           ');
          elsif(V_STATUS='1')then
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
               <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center;">
                <tr style="text-align: center;">
                    <th colspan="6" style="text-align: center; vertical-align: middle; font-size: 14pt; height:39px;">DANH SÁCH</th>
                </tr>
                <tr>
                    <td colspan="6" style="text-align: center; vertical-align: top; font-style: italic; height: 30px;">Từ ngày '||VV_DATE_FROM||' đến ngày '||VV_DATE_TO||'</td>
                </tr>
                <tr style="">
                    <th style="text-align: center; vertical-align: middle; border: 0.1pt solid Black; height: 61px;">STT</th>
                    <th style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Thông tin vụ việc</th>
                    <th style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Thông tin đương sự</th>
                    <th style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Số tiền tạm ứng án phí (VNĐ)</th>
                    <th style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Trạng thái</th>
                    <th style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Thông tin nộp tiền tạm ứng án phí</th>
                </tr>
               <tr style="font-style: italic;">
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;" >1</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;" >2</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;" >3</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;" >4</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;" >5</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;" >6</td>
                </tr>
           ');
            elsif(V_STATUS='2')then
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
               <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center;">
                <tr style="text-align: center;">
                    <th colspan="6" style="text-align: center; vertical-align: middle; font-size: 14pt; height:39px;">DANH SÁCH</th>
                </tr>
                <tr>
                    <td colspan="6" style="text-align: center; vertical-align: top; font-style: italic; height: 30px;">Từ ngày '||VV_DATE_FROM||' đến ngày '||VV_DATE_TO||'</td>
                </tr>
                <tr style="">
                    <th style="text-align: center; vertical-align: middle; border: 0.1pt solid Black; height: 61px;">STT</th>
                    <th style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Thông tin vụ việc</th>
                    <th style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Thông tin đương sự</th>
                    <th style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Thông tin người nhận hoàn trả tiền tạm ứng án phí</th>
                    <th style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Số tiền hoàn trả (VNĐ)</th>
                    <th style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Thông tin nhận hoàn trả tiền tạm ứng án phí</th>
                </tr>
               <tr style="font-style: italic;">
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;" >1</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;" >2</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;" >3</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;" >4</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;" >5</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;" >6</td>
                </tr>
           ');
       END IF;    
          ----------------------
      FOR rec in (
                 SELECT TP.TENFILE,TP.LOAIAN,TP.MAVUVIEC,TP.BIEUMAUID,TP.MALOAIVUVIEC,TP.FILEID,COUNT(*) OVER()COUNTALL,ROW_NUMBER() OVER (ORDER BY TP.NGAYTAO DESC,TP.DONVI) STT,TP.DONID,TP.DUONGSU_ID,
                ('Số thông báo: ' ||TP.SOTHONGBAO|| '; Ngày: '|| TO_CHAR(TP.NGAYGQ_YC,'dd/MM/yyyy')||' Mã vụ việc: ' ||TP.MAVUVIEC||'; Loại án: '||TP.LOAIAN) SOTHONGBAO,
                 replace(TP.TENDUONGSU,'<br/>','')TENDUONGSU,
                TP.NAMSINH,TP.SOCMND,TP.DIENTHOAI,TP.EMAIL,TP.DONVI,
                TP.TAMUNGANPHI--TO_CHAR(TP.TAMUNGANPHI,'FM999G999G999G999')TAMUNGANPHI
                ,DECODE(V_STATUS,1,'',TP.STATUS)STATUS,TP.DIACHI,
                (TP.HOANTRAAP_HOTEN || '; Năm sinh '||TP.HOANTRAAP_NAMSINH || '; Số CMTND: '||TP.HOANTRAAP_CMND  || '; Email: '||TP.HOANTRAAP_EMAIL|| '; Số ĐT: '||TP.HOANTRAAP_TEL||'; Địa chỉ: '||REPLACE(TP.HOANTRAAP_DIACHI,','))HOANTRAAP_HOTEN,
                TP.HOANTRAAP_NAMSINH,TP.HOANTRAAP_CMND,TP.HOANTRAAP_TEL,TP.HOANTRAAP_EMAIL,TP.HOANTRAAP_DIACHI,
                TO_CHAR(TP.NGAYBIENLAI,'MM/dd/yyyy') NGAYBIENLAI,TP.SOBIENLAI,('Ngày nộp: '||TO_CHAR(TP.NGAYBIENLAI,'MM/dd/yyyy')||'; Số biên lai: '||TP.SOBIENLAI||'; Người thu: '||TP.NGUOITHUTIEN)NGUOITHUTIEN
                ,TP.ANPHIHOANTRA
                ,TO_CHAR(TP.NGAYHOANTRA,'MM/dd/yyyy')NGAYHOANTRA
                ,DECODE(TP.ANPHIHOANTRA,0,'Chưa nhận hoàn trả',null,'','Đã nhận hoàn trả') STATUS_HOANTRA,
                ('Ngày nhận: '||TO_CHAR(TP.NGAYHOANTRA,'MM/dd/yyyy')||'; Số biên lai: '||TP.SOBIENLAI||'; Người thu: '||TP.NGUOITHUTIEN) NGUOITHUTIEN_HOANTRA
                ,DECODE(TP.SOBIENLAI,NULL,TP.STATUS,TP.STATUS||'; '||DECODE(TP.ANPHIHOANTRA,0,'Chưa nhận hoàn trả',null,'','Đã nhận hoàn trả')) STATUS_ALL
                ,DECODE(V_DATE_FROM,NULL,'.....',V_DATE_FROM)DATE_FROM,DECODE(V_DATE_TO,NULL,'.....',V_DATE_TO)DATE_TO,TP.MA_THONGBAO,TP.DUONGSU_IDS
                FROM TABLE(v_table) TP
                LEFT JOIN DM_DONVITHIHANHAN tha on tha.id=tp.DONVITHA_ID
                WHERE 
--                 ( (tha.ID=V_DONVITHA_ID AND ((V_GET_CHIL=1 and V_GET_CHIL is not null) or (V_GET_CHIL is null) ) ) OR( (tha.ARRSAPXEP like (var_arrsx ||'/%') or tha.ARRSAPXEP=var_arrsx) AND ((V_GET_CHIL=0 and V_GET_CHIL is not null) or (V_GET_CHIL is null) ))
--                  OR (V_DONVITHA_ID IS NULL) )

                --hien tại dang lọc tạm theo dơn vị tòa án coi như là thi hành án
               ((TP.DONVITHA_ID=V_DONVITHA_ID AND V_DONVITHA_ID IS NOT NULL AND V_LOAITOA!='TOICAO') OR (V_DONVITHA_ID IS NULL OR V_LOAITOA='TOICAO')) 

                 AND( (((UPPER(TP.TENDUONGSU) LIKE '%'||UPPER(vTuKhoaBasic)||'%') AND vTuKhoaBasic IS NOT NULL) OR (vTuKhoaBasic IS NULL))
                     OR (((UPPER(TP.SOTHONGBAO)||'/TB-TA' LIKE '%'||UPPER(vTuKhoaBasic)||'%') AND vTuKhoaBasic IS NOT NULL) OR (vTuKhoaBasic IS NULL))    
                     OR (((UPPER(TP.SOCMND) LIKE '%'||UPPER(vTuKhoaBasic)||'%') AND vTuKhoaBasic IS NOT NULL) OR (vTuKhoaBasic IS NULL))  
                     OR (((UPPER(TP.NOP_CMND) LIKE '%'||UPPER(vTuKhoaBasic)||'%') AND vTuKhoaBasic IS NOT NULL) OR (vTuKhoaBasic IS NULL)) 
                     OR (((UPPER(TP.HOANTRAAP_CMND) LIKE '%'||UPPER(vTuKhoaBasic)||'%') AND vTuKhoaBasic IS NOT NULL) OR (vTuKhoaBasic IS NULL)) 
                     )
               AND (((TP.TRANGTHAITHANHTOAN=0 AND V_STATUS=0) OR (TP.TRANGTHAITHANHTOAN=1 AND V_STATUS=1) OR (TP.TRANGTHAITHANHTOAN=1 AND TP.ANPHIHOANTRA !=0 AND V_STATUS=2) OR (TP.TRANGTHAITHANHTOAN=1  AND TP.DINHCHI=1 AND V_STATUS=3) ) OR (V_STATUS IS NULL)) --check chua nop an phi or da nop an phi or da hoan tra --OR (TP.SOBIENLAI IS NULL AND V_STATUS=3) dinh chi nop an phi     
               AND ((V_TUNGAY IS NULL OR TP.NGAYTHONGBAO>=V_TUNGAY) AND (V_DENNGAY IS NULL  OR TP.NGAYTHONGBAO<=V_DENNGAY))
               AND (V_TT_TRUCTUYEN IS NULL OR (TP.TT_TRUCTUYEN=V_TT_TRUCTUYEN)) AND (TP.MALOAIVUVIEC=V_LOAI_AN OR V_LOAI_AN IS NULL)
               AND TP.MA_THONGBAO IS NOT NULL
              )
            LOOP
               IF(V_STATUS='0' or V_STATUS='3' or V_STATUS is null)THEN
                --  V_STT:=V_STT+1;
                   DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                   <tr>
                    <td style="border: 0.1pt solid Black; text-align: center; vertical-align: middle;">'||rec.STT||'</td>
                    <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">'||rec.SOTHONGBAO||'</td>
                    <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">'||rec.TENDUONGSU||'</td>
                    <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">'||rec.DONVI||'</td>
                    <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||rec.TAMUNGANPHI||'</td>
                    <td style="border: 0.1pt solid Black; text-align: center; vertical-align: middle;">'||rec.STATUS_ALL||'</td>
                   </tr> 
                  ');
                elsif(V_STATUS='1')THEN
                --  V_STT:=V_STT+1;
                   DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                   <tr>
                    <td style="border: 0.1pt solid Black; text-align: center; vertical-align: middle;">'||rec.STT||'</td>
                    <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">'||rec.SOTHONGBAO||'</td>
                    <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">'||rec.TENDUONGSU||'</td>
                    <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||rec.TAMUNGANPHI||'</td>
                    <td style="border: 0.1pt solid Black; text-align: center; vertical-align: middle;">'||rec.STATUS_HOANTRA||'</td>
                     <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">'||rec.NGUOITHUTIEN||'</td>
                   </tr> 
                  ');
                   elsif(V_STATUS='2')THEN
                --  V_STT:=V_STT+1;
                   DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                   <tr>
                    <td style="border: 0.1pt solid Black; text-align: center; vertical-align: middle;">'||rec.STT||'</td>
                    <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">'||rec.SOTHONGBAO||'</td>
                    <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">'||rec.TENDUONGSU||'</td>
                    <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">'||rec.HOANTRAAP_HOTEN||'</td>
                    <td style="border: 0.1pt solid Black; text-align: center; vertical-align: middle;">'||rec.ANPHIHOANTRA||'</td>
                     <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">'||rec.NGUOITHUTIEN_HOANTRA||'</td>
                   </tr> 
                  ');
                END IF;
            END LOOP;
    IF(V_STATUS='0' or V_STATUS='3' or V_STATUS is null)THEN     
         DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
         <tr style="height: 0px;">
                <td style="width: 47px"></td>
                <td style="width: 160px"></td>
                <td style="width: 188px"></td>
                <td style="width: 150px"></td>
                <td style="width: 80px"></td>
                <td style="width: 150px"></td>
            </tr> ');
       ELSIF(V_STATUS='1')THEN     
         DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
         <tr style="height: 0px;">
                <td style="width: 47px"></td>
                <td style="width: 160px"></td>
                <td style="width: 256px"></td>
                <td style="width: 100px"></td>
                <td style="width: 100px"></td>
                <td style="width: 240px"></td>
            </tr> ');     
           ELSIF(V_STATUS='2')THEN     
         DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
         <tr style="height: 0px;">
                <td style="width: 47px"></td>
                <td style="width: 160px"></td>
                <td style="width: 205px"></td>
                <td style="width: 170px"></td>
                <td style="width: 80px"></td>
                <td style="width: 240px"></td>
            </tr> ');       
     END IF;       
      DBMS_LOB.APPEND(V_EXPORT_TEXT,'        
   </table>
    ');

     OPEN v_cursor FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN v_cursor;   
END TC_DANHSACH_ANPHI_IN_DS;
FUNCTION LOAD_EDIT
(
  V_MA_THONGBAO IN VARCHAR2 DEFAULT NULL,
  V_MALOAIVUVIEC IN VARCHAR2 DEFAULT NULL,
  V_USERNAME IN VARCHAR2 DEFAULT NULL,
  V_DONID  IN NUMBER,
  V_DS_ID  IN VARCHAR2 DEFAULT NULL,
  V_DS_IDS  IN VARCHAR2 DEFAULT NULL
)
RETURN SYS_REFCURSOR
AS
      v_cursor SYS_REFCURSOR;V_COUNT NUMBER:=0;V_COUNT_DSU NUMBER:=0;
      V_NGUOITHUTIEN NVARCHAR2(200);v_table T_TUPHAP_ANPHI_EDIT;
BEGIN
        v_table := T_TUPHAP_ANPHI_EDIT(); --dung bang ding nghia
         select instr(V_DS_IDS,',') into V_COUNT_DSU from dual;
        --
  FOR item_tp IN 
            (
                SELECT TD.NGAYTAO,THA.ID DONVITHA_ID,NULL TENFILE,'Dân sự' LOAIAN,DO.MAVUVIEC,TD.BIEUMAUID,'2' AS MALOAIVUVIEC,TD.FILEID,TD.DONID,DU.ID DUONGSU_ID,AI.SOTHONGBAO||'/TB-TA' AS SOTHONGBAO,
                DU.TENDUONGSU,DU.NAMSINH,DU.GIOITINH,DU.SOCMND,DU.DIENTHOAI,DU.EMAIL,TN.MA_TEN DONVI,AI.TAMUNGANPHI,
                DECODE(tt.TRANGTHAITHANHTOAN,0,'Chưa nộp án phí',1,'Đã nộp án phí') STATUS,HC.MA_TEN,
                DECODE(DU.TAMTRUCHITIET,NULL,HC.MA_TEN,REPLACE(DU.TAMTRUCHITIET,',')||', '||HC.MA_TEN) AS DIACHI,
                TA.HOANTRAAP_HOTEN,TA.HOANTRAAP_GIOITINH,TA.HOANTRAAP_NAMSINH,TA.HOANTRAAP_CMND,TA.HOANTRAAP_TEL,TA.HOANTRAAP_EMAIL,TA.HOANTRAAP_DIACHI,
                TA.NGAYBIENLAI,TA.SOBIENLAI,TA.NGUOITHUTIEN,DX.NGAYGQ_YC,
                TA.NOP_ISNGUYENDON,TA.NOP_GIOITINH,decode(tt.TT_TRUCTUYEN,1,TT.HOTENNGUOINOPTIEN,TA.NOP_HOTEN)NOP_HOTEN,TA.NOP_NAMSINH,decode(tt.TT_TRUCTUYEN,1,tt.SOCMNDNGUOINOP,TA.NOP_CMND)NOP_CMND,TA.NOP_TEL,TA.NOP_EMAIL,decode(tt.TT_TRUCTUYEN,1,TT.DIACHINGUOINOPTIEN,TA.NOP_DIACHI)NOP_DIACHI,TA.HOANTRAAP_ISNGUYENDON,DU.LOAIDUONGSU
                ,TL.SOTHULY,TA.ANPHIHOANTRA,TA.NGAYHOANTRA,TA.GHICHU_HOANTRA,THA1.TEN,TT.MA_THONGBAO,TT.TT_TRUCTUYEN
                ,FD.FILE_NAME ANPHI_FILE_NAME,TA.NOPCHO_DUONGSUID,TA.NHANCHO_DUONGSUID
                FROM ADS_TONGDAT TD 
                INNER JOIN ADS_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN ADS_ANPHI AI ON TD.DONID=AI.DONID
                LEFT JOIN (SELECT FILE_NAME,ANPHI_ID FROM ADS_FILE_THA WHERE STATUS=1) FD ON FD.ANPHI_ID=AI.ID
                INNER JOIN ADS_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
             --   INNER JOIN ADS_TONGDAT_DOITUONG DO ON DO.DUONGSUID =DU.id
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN ADS_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                 LEFT JOIN DVCQG_THANH_TOAN TT ON tt.DUONGSU_ID=AI.DUONGSU_ID AND TT.MALOAIVUVIEC='2'
                 LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.DUONGSU_ID=TT.DUONGSU_ID AND TA.MALOAIVUVIEC='2'
                LEFT JOIN ADS_SOTHAM_THULY TL ON TL.DONID=TD.DONID AND TL.TRUONGHOPTHULY=1--thu ly lan dau
                LEFT JOIN DM_DONVITHIHANHAN THA1 ON THA1.ID=TA.DONVI_THUTIEN_ID
                WHERE DU.TUCACHTOTUNG_MA='NGUYENDON' AND TD.BIEUMAUID IN(67,381) --Thông báo nộp tiền tạm ứng án phí
                AND AI.TAMUNGANPHI !=0
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := R_TUPHAP_ANPHI_EDIT(
        item_tp.NGAYTAO, item_tp.DONVITHA_ID,item_tp.TENFILE,item_tp.LOAIAN,item_tp.MAVUVIEC,item_tp.BIEUMAUID,item_tp.MALOAIVUVIEC,item_tp.FILEID,item_tp.DONID,item_tp.DUONGSU_ID,
        item_tp.SOTHONGBAO,item_tp.TENDUONGSU,item_tp.NAMSINH,item_tp.GIOITINH,item_tp.SOCMND,item_tp.DIENTHOAI,item_tp.EMAIL,item_tp.DONVI,item_tp.TAMUNGANPHI,item_tp.STATUS,item_tp.MA_TEN,item_tp.DIACHI,
        item_tp.HOANTRAAP_HOTEN,item_tp.HOANTRAAP_GIOITINH,item_tp.HOANTRAAP_NAMSINH,item_tp.HOANTRAAP_CMND,item_tp.HOANTRAAP_TEL,item_tp.HOANTRAAP_EMAIL,item_tp.HOANTRAAP_DIACHI,item_tp.NGAYBIENLAI,item_tp.SOBIENLAI,item_tp.NGUOITHUTIEN,item_tp.NGAYGQ_YC,
        item_tp.NOP_ISNGUYENDON,item_tp.NOP_GIOITINH,item_tp.NOP_HOTEN,item_tp.NOP_NAMSINH,item_tp.NOP_CMND,item_tp.NOP_TEL,item_tp.NOP_EMAIL,item_tp.NOP_DIACHI,item_tp.HOANTRAAP_ISNGUYENDON,item_tp.LOAIDUONGSU
       ,item_tp.SOTHULY,item_tp.ANPHIHOANTRA,item_tp.NGAYHOANTRA,item_tp.GHICHU_HOANTRA,item_tp.TEN,item_tp.MA_THONGBAO,item_tp.TT_TRUCTUYEN,NULL,item_tp.ANPHI_FILE_NAME
       ,item_tp.NOPCHO_DUONGSUID,item_tp.NHANCHO_DUONGSUID); 
    END LOOP;
    -----------------------
    IF(V_COUNT_DSU=0)THEN
                 FOR item_tp IN 
                        (
                            SELECT TD.NGAYTAO,THA.ID DONVITHA_ID,NULL TENFILE,'Hôn nhân' LOAIAN,DO.MAVUVIEC,TD.BIEUMAUID,'3' AS MALOAIVUVIEC,TD.FILEID,TD.DONID,DU.ID DUONGSU_ID,AI.SOTHONGBAO||'/TB-TA' AS SOTHONGBAO,
                             DU.TENDUONGSU,DU.NAMSINH,DU.GIOITINH,DU.SOCMND,DU.DIENTHOAI,DU.EMAIL,TN.MA_TEN DONVI,AI.TAMUNGANPHI,
                            DECODE(tt.TRANGTHAITHANHTOAN,0,'Chưa nộp án phí',1,'Đã nộp án phí') STATUS,HC.MA_TEN,
                            DECODE(DU.TAMTRUCHITIET,NULL,HC.MA_TEN,REPLACE(DU.TAMTRUCHITIET,',')||', '||HC.MA_TEN) AS DIACHI,
                            TA.HOANTRAAP_HOTEN,TA.HOANTRAAP_GIOITINH,TA.HOANTRAAP_NAMSINH,TA.HOANTRAAP_CMND,TA.HOANTRAAP_TEL,TA.HOANTRAAP_EMAIL,TA.HOANTRAAP_DIACHI,
                            TA.NGAYBIENLAI,TA.SOBIENLAI,TA.NGUOITHUTIEN,DX.NGAYGQ_YC,
                            TA.NOP_ISNGUYENDON,TA.NOP_GIOITINH,decode(tt.TT_TRUCTUYEN,1,TT.HOTENNGUOINOPTIEN,TA.NOP_HOTEN)NOP_HOTEN,TA.NOP_NAMSINH,decode(tt.TT_TRUCTUYEN,1,tt.SOCMNDNGUOINOP,TA.NOP_CMND)NOP_CMND,TA.NOP_TEL,TA.NOP_EMAIL,decode(tt.TT_TRUCTUYEN,1,TT.DIACHINGUOINOPTIEN,TA.NOP_DIACHI)NOP_DIACHI,TA.HOANTRAAP_ISNGUYENDON,DU.LOAIDUONGSU
                            ,TL.SOTHULY,TA.ANPHIHOANTRA,TA.NGAYHOANTRA,TA.GHICHU_HOANTRA,THA1.TEN,TT.MA_THONGBAO,TT.TT_TRUCTUYEN,AI.DUONGSU_IDS
                            ,FD.FILE_NAME ANPHI_FILE_NAME,TA.NOPCHO_DUONGSUID,TA.NHANCHO_DUONGSUID
                            FROM AHN_TONGDAT TD 
                            INNER JOIN AHN_DON DO ON TD.DONID=DO.ID     
                            INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                            INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                            INNER JOIN AHN_ANPHI AI ON TD.DONID=AI.DONID
                             LEFT JOIN (SELECT FILE_NAME,ANPHI_ID FROM AHN_FILE_THA WHERE STATUS=1) FD ON FD.ANPHI_ID=AI.ID
                            INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                            LEFT JOIN AHN_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                            LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.MALOAIVUVIEC='3'
                            LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='3'
                            INNER JOIN (SELECT * FROM AHN_ANPHI_DUONGSU WHERE DUONGSU_ID=V_DS_IDS) AD ON AD.ANPHI_ID=TT.ANPHI_ID
                            INNER JOIN AHN_DON_DUONGSU DU ON DU.ID=AD.DUONGSU_ID
                            LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                            LEFT JOIN AHN_SOTHAM_THULY TL ON TL.DONID=TD.DONID AND TL.TRUONGHOPTHULY=1--thu ly lan dau
                            LEFT JOIN DM_DONVITHIHANHAN THA1 ON THA1.ID=TA.DONVI_THUTIEN_ID
                            WHERE DU.TUCACHTOTUNG_MA='NGUYENDON' AND TD.BIEUMAUID IN(67,381) --Thông báo nộp tiền tạm ứng án phí
                            AND AI.TAMUNGANPHI !=0
                       )
                LOOP
                    v_table.extend;
                    v_table(v_table.count) := R_TUPHAP_ANPHI_EDIT(
                    item_tp.NGAYTAO, item_tp.DONVITHA_ID,item_tp.TENFILE,item_tp.LOAIAN,item_tp.MAVUVIEC,item_tp.BIEUMAUID,item_tp.MALOAIVUVIEC,item_tp.FILEID,item_tp.DONID,item_tp.DUONGSU_ID,
                    item_tp.SOTHONGBAO,item_tp.TENDUONGSU,item_tp.NAMSINH,item_tp.GIOITINH,item_tp.SOCMND,item_tp.DIENTHOAI,item_tp.EMAIL,item_tp.DONVI,item_tp.TAMUNGANPHI,item_tp.STATUS,item_tp.MA_TEN,item_tp.DIACHI,
                    item_tp.HOANTRAAP_HOTEN,item_tp.HOANTRAAP_GIOITINH,item_tp.HOANTRAAP_NAMSINH,item_tp.HOANTRAAP_CMND,item_tp.HOANTRAAP_TEL,item_tp.HOANTRAAP_EMAIL,item_tp.HOANTRAAP_DIACHI,item_tp.NGAYBIENLAI,item_tp.SOBIENLAI,item_tp.NGUOITHUTIEN,item_tp.NGAYGQ_YC,
                    item_tp.NOP_ISNGUYENDON,item_tp.NOP_GIOITINH,item_tp.NOP_HOTEN,item_tp.NOP_NAMSINH,item_tp.NOP_CMND,item_tp.NOP_TEL,item_tp.NOP_EMAIL,item_tp.NOP_DIACHI,item_tp.HOANTRAAP_ISNGUYENDON,item_tp.LOAIDUONGSU
                   ,item_tp.SOTHULY,item_tp.ANPHIHOANTRA,item_tp.NGAYHOANTRA,item_tp.GHICHU_HOANTRA,item_tp.TEN,item_tp.MA_THONGBAO,item_tp.TT_TRUCTUYEN,item_tp.DUONGSU_IDS,item_tp.ANPHI_FILE_NAME
                   ,item_tp.NOPCHO_DUONGSUID,item_tp.NHANCHO_DUONGSUID);   
                END LOOP;
          ELSIF(V_COUNT_DSU>0)THEN  
                 FOR item_tp IN 
                        (
                            SELECT TD.NGAYTAO,THA.ID DONVITHA_ID,NULL TENFILE,'Hôn nhân' LOAIAN,DO.MAVUVIEC,TD.BIEUMAUID,'3' AS MALOAIVUVIEC,TD.FILEID,TD.DONID,0 DUONGSU_ID,AI.SOTHONGBAO||'/TB-TA' AS SOTHONGBAO,
                            AP.TENDUONGSU,NULL NAMSINH,NULL GIOITINH,NULL SOCMND,NULL DIENTHOAI,NULL EMAIL,TN.MA_TEN DONVI,AI.TAMUNGANPHI,
                            DECODE(tt.TRANGTHAITHANHTOAN,0,'Chưa nộp án phí',1,'Đã nộp án phí') STATUS,DT.MA_TEN,
                            NULL DIACHI,
                            TA.HOANTRAAP_HOTEN,TA.HOANTRAAP_GIOITINH,TA.HOANTRAAP_NAMSINH,TA.HOANTRAAP_CMND,TA.HOANTRAAP_TEL,TA.HOANTRAAP_EMAIL,TA.HOANTRAAP_DIACHI,
                            TA.NGAYBIENLAI,TA.SOBIENLAI,TA.NGUOITHUTIEN,DX.NGAYGQ_YC,
                            TA.NOP_ISNGUYENDON,TA.NOP_GIOITINH,decode(tt.TT_TRUCTUYEN,1,TT.HOTENNGUOINOPTIEN,TA.NOP_HOTEN)NOP_HOTEN,TA.NOP_NAMSINH,decode(tt.TT_TRUCTUYEN,1,tt.SOCMNDNGUOINOP,TA.NOP_CMND)NOP_CMND,TA.NOP_TEL,TA.NOP_EMAIL,decode(tt.TT_TRUCTUYEN,1,TT.DIACHINGUOINOPTIEN,TA.NOP_DIACHI)NOP_DIACHI,TA.HOANTRAAP_ISNGUYENDON,1 LOAIDUONGSU
                            ,TL.SOTHULY,TA.ANPHIHOANTRA,TA.NGAYHOANTRA,TA.GHICHU_HOANTRA,THA1.TEN,TT.MA_THONGBAO,TT.TT_TRUCTUYEN,AI.DUONGSU_IDS
                            ,FD.FILE_NAME ANPHI_FILE_NAME,TA.NOPCHO_DUONGSUID,TA.NHANCHO_DUONGSUID
                            FROM AHN_TONGDAT TD 
                            INNER JOIN AHN_DON DO ON TD.DONID=DO.ID     
                            INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                            INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                            INNER JOIN AHN_ANPHI AI ON TD.DONID=AI.DONID
                             LEFT JOIN (SELECT FILE_NAME,ANPHI_ID FROM AHN_FILE_THA WHERE STATUS=1) FD ON FD.ANPHI_ID=AI.ID
                            INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                            LEFT JOIN (SELECT LISTAGG(HN.TENDUONGSU, ', ')WITHIN GROUP (ORDER BY HN.TENDUONGSU)TENDUONGSU,DU.ANPHI_ID
                                 FROM AHN_ANPHI_DUONGSU DU LEFT JOIN AHN_DON_DUONGSU HN ON HN.ID=DU.DUONGSU_ID
                                 GROUP BY DU.ANPHI_ID
                               )AP ON AP.ANPHI_ID=AI.ID
                            LEFT JOIN AHN_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                            LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.MALOAIVUVIEC='3'
                            LEFT JOIN DM_TOAAN DT ON DT.ID=TD.TOAANID
                            LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='3'
                            LEFT JOIN AHN_SOTHAM_THULY TL ON TL.DONID=TD.DONID AND TL.TRUONGHOPTHULY=1--thu ly lan dau
                             LEFT JOIN DM_DONVITHIHANHAN THA1 ON THA1.ID=TA.DONVI_THUTIEN_ID
                            WHERE   TD.BIEUMAUID IN(67,381) AND--Thông báo nộp tiền tạm ứng án phí
                             AI.TAMUNGANPHI !=0
                       )
                LOOP
                    v_table.extend;
                    v_table(v_table.count) := R_TUPHAP_ANPHI_EDIT(
                    item_tp.NGAYTAO, item_tp.DONVITHA_ID,item_tp.TENFILE,item_tp.LOAIAN,item_tp.MAVUVIEC,item_tp.BIEUMAUID,item_tp.MALOAIVUVIEC,item_tp.FILEID,item_tp.DONID,item_tp.DUONGSU_ID,
                    item_tp.SOTHONGBAO,item_tp.TENDUONGSU,item_tp.NAMSINH,item_tp.GIOITINH,item_tp.SOCMND,item_tp.DIENTHOAI,item_tp.EMAIL,item_tp.DONVI,item_tp.TAMUNGANPHI,item_tp.STATUS,item_tp.MA_TEN,item_tp.DIACHI,
                    item_tp.HOANTRAAP_HOTEN,item_tp.HOANTRAAP_GIOITINH,item_tp.HOANTRAAP_NAMSINH,item_tp.HOANTRAAP_CMND,item_tp.HOANTRAAP_TEL,item_tp.HOANTRAAP_EMAIL,item_tp.HOANTRAAP_DIACHI,item_tp.NGAYBIENLAI,item_tp.SOBIENLAI,item_tp.NGUOITHUTIEN,item_tp.NGAYGQ_YC,
                    item_tp.NOP_ISNGUYENDON,item_tp.NOP_GIOITINH,item_tp.NOP_HOTEN,item_tp.NOP_NAMSINH,item_tp.NOP_CMND,item_tp.NOP_TEL,item_tp.NOP_EMAIL,item_tp.NOP_DIACHI,item_tp.HOANTRAAP_ISNGUYENDON,item_tp.LOAIDUONGSU
                   ,item_tp.SOTHULY,item_tp.ANPHIHOANTRA,item_tp.NGAYHOANTRA,item_tp.GHICHU_HOANTRA,item_tp.TEN,item_tp.MA_THONGBAO,item_tp.TT_TRUCTUYEN,item_tp.DUONGSU_IDS,item_tp.ANPHI_FILE_NAME
                   ,item_tp.NOPCHO_DUONGSUID,item_tp.NHANCHO_DUONGSUID); 
                END LOOP;
        END IF;  
    -----------------------
     FOR item_tp IN 
            (
               SELECT TD.NGAYTAO,THA.ID DONVITHA_ID,NULL TENFILE,'Kinh tế' LOAIAN,DO.MAVUVIEC,TD.BIEUMAUID,'4' AS MALOAIVUVIEC,TD.FILEID,TD.DONID,DU.ID DUONGSU_ID,AI.SOTHONGBAO||'/TB-TA' AS SOTHONGBAO,
                DU.TENDUONGSU,DU.NAMSINH,DU.GIOITINH,DU.SOCMND,DU.DIENTHOAI,DU.EMAIL,TN.MA_TEN DONVI,AI.TAMUNGANPHI,
                DECODE(tt.TRANGTHAITHANHTOAN,0,'Chưa nộp án phí',1,'Đã nộp án phí') STATUS,HC.MA_TEN,
                DECODE(DU.TAMTRUCHITIET,NULL,HC.MA_TEN,REPLACE(DU.TAMTRUCHITIET,',')||', '||HC.MA_TEN) AS DIACHI,
                TA.HOANTRAAP_HOTEN,TA.HOANTRAAP_GIOITINH,TA.HOANTRAAP_NAMSINH,TA.HOANTRAAP_CMND,TA.HOANTRAAP_TEL,TA.HOANTRAAP_EMAIL,TA.HOANTRAAP_DIACHI,
                TA.NGAYBIENLAI,TA.SOBIENLAI,TA.NGUOITHUTIEN,DX.NGAYGQ_YC,
                TA.NOP_ISNGUYENDON,TA.NOP_GIOITINH,decode(tt.TT_TRUCTUYEN,1,TT.HOTENNGUOINOPTIEN,TA.NOP_HOTEN)NOP_HOTEN,TA.NOP_NAMSINH,decode(tt.TT_TRUCTUYEN,1,tt.SOCMNDNGUOINOP,TA.NOP_CMND)NOP_CMND,TA.NOP_TEL,TA.NOP_EMAIL,decode(tt.TT_TRUCTUYEN,1,TT.DIACHINGUOINOPTIEN,TA.NOP_DIACHI)NOP_DIACHI,TA.HOANTRAAP_ISNGUYENDON,DU.LOAIDUONGSU
                ,TL.SOTHULY,TA.ANPHIHOANTRA,TA.NGAYHOANTRA,TA.GHICHU_HOANTRA,THA1.TEN,TT.MA_THONGBAO,TT.TT_TRUCTUYEN
                ,FD.FILE_NAME ANPHI_FILE_NAME,TA.NOPCHO_DUONGSUID,TA.NHANCHO_DUONGSUID
                FROM AKT_TONGDAT TD 
                INNER JOIN AKT_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN AKT_ANPHI AI ON TD.DONID=AI.DONID
                 LEFT JOIN (SELECT FILE_NAME,ANPHI_ID FROM AKT_FILE_THA WHERE STATUS=1) FD ON FD.ANPHI_ID=AI.ID
                INNER JOIN AKT_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
              --  INNER JOIN AKT_TONGDAT_DOITUONG DO ON DO.DUONGSUID =DU.id
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN AKT_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.MALOAIVUVIEC='4'
--                LEFT JOIN AKT_FILE FL ON FL.DONID=TD.DONID AND FL.BIEUMAUID=67
                LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='4'
                LEFT JOIN AKT_SOTHAM_THULY TL ON TL.DONID=TD.DONID AND TL.TRUONGHOPTHULY=1--thu ly lan dau
                LEFT JOIN DM_DONVITHIHANHAN THA1 ON THA1.ID=TA.DONVI_THUTIEN_ID
                WHERE DU.TUCACHTOTUNG_MA='NGUYENDON' AND TD.BIEUMAUID IN(67,381) --Thông báo nộp tiền tạm ứng án phí
                --AND DU.ISDAIDIEN = 1 --AND NULL TENFILE IS NOT NULL
                AND AI.TAMUNGANPHI !=0
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := R_TUPHAP_ANPHI_EDIT(
        item_tp.NGAYTAO, item_tp.DONVITHA_ID,item_tp.TENFILE,item_tp.LOAIAN,item_tp.MAVUVIEC,item_tp.BIEUMAUID,item_tp.MALOAIVUVIEC,item_tp.FILEID,item_tp.DONID,item_tp.DUONGSU_ID,
        item_tp.SOTHONGBAO,item_tp.TENDUONGSU,item_tp.NAMSINH,item_tp.GIOITINH,item_tp.SOCMND,item_tp.DIENTHOAI,item_tp.EMAIL,item_tp.DONVI,item_tp.TAMUNGANPHI,item_tp.STATUS,item_tp.MA_TEN,item_tp.DIACHI,
        item_tp.HOANTRAAP_HOTEN,item_tp.HOANTRAAP_GIOITINH,item_tp.HOANTRAAP_NAMSINH,item_tp.HOANTRAAP_CMND,item_tp.HOANTRAAP_TEL,item_tp.HOANTRAAP_EMAIL,item_tp.HOANTRAAP_DIACHI,item_tp.NGAYBIENLAI,item_tp.SOBIENLAI,item_tp.NGUOITHUTIEN,item_tp.NGAYGQ_YC,
        item_tp.NOP_ISNGUYENDON,item_tp.NOP_GIOITINH,item_tp.NOP_HOTEN,item_tp.NOP_NAMSINH,item_tp.NOP_CMND,item_tp.NOP_TEL,item_tp.NOP_EMAIL,item_tp.NOP_DIACHI,item_tp.HOANTRAAP_ISNGUYENDON,item_tp.LOAIDUONGSU
       ,item_tp.SOTHULY,item_tp.ANPHIHOANTRA,item_tp.NGAYHOANTRA,item_tp.GHICHU_HOANTRA,item_tp.TEN,item_tp.MA_THONGBAO,item_tp.TT_TRUCTUYEN,NULL,item_tp.ANPHI_FILE_NAME
       ,item_tp.NOPCHO_DUONGSUID,item_tp.NHANCHO_DUONGSUID); 
    END LOOP;
    -----------------------
     FOR item_tp IN 
            (
                SELECT TD.NGAYTAO,THA.ID DONVITHA_ID,NULL TENFILE,'Lao động' LOAIAN,DO.MAVUVIEC,TD.BIEUMAUID,'5' AS MALOAIVUVIEC,TD.FILEID,TD.DONID,DU.ID DUONGSU_ID,AI.SOTHONGBAO||'/TB-TA' AS SOTHONGBAO,
                DU.TENDUONGSU,DU.NAMSINH,DU.GIOITINH,DU.SOCMND,DU.DIENTHOAI,DU.EMAIL,TN.MA_TEN DONVI,AI.TAMUNGANPHI,
                DECODE(tt.TRANGTHAITHANHTOAN,0,'Chưa nộp án phí',1,'Đã nộp án phí') STATUS,HC.MA_TEN,
                DECODE(DU.TAMTRUCHITIET,NULL,HC.MA_TEN,REPLACE(DU.TAMTRUCHITIET,',')||', '||HC.MA_TEN) AS DIACHI,
                TA.HOANTRAAP_HOTEN,TA.HOANTRAAP_GIOITINH,TA.HOANTRAAP_NAMSINH,TA.HOANTRAAP_CMND,TA.HOANTRAAP_TEL,TA.HOANTRAAP_EMAIL,TA.HOANTRAAP_DIACHI,
                TA.NGAYBIENLAI,TA.SOBIENLAI,TA.NGUOITHUTIEN,DX.NGAYGQ_YC,
                TA.NOP_ISNGUYENDON,TA.NOP_GIOITINH,decode(tt.TT_TRUCTUYEN,1,TT.HOTENNGUOINOPTIEN,TA.NOP_HOTEN)NOP_HOTEN,TA.NOP_NAMSINH,decode(tt.TT_TRUCTUYEN,1,tt.SOCMNDNGUOINOP,TA.NOP_CMND)NOP_CMND,TA.NOP_TEL,TA.NOP_EMAIL,decode(tt.TT_TRUCTUYEN,1,TT.DIACHINGUOINOPTIEN,TA.NOP_DIACHI)NOP_DIACHI,TA.HOANTRAAP_ISNGUYENDON,DU.LOAIDUONGSU
               ,TL.SOTHULY,TA.ANPHIHOANTRA,TA.NGAYHOANTRA,TA.GHICHU_HOANTRA,THA1.TEN,TT.MA_THONGBAO,TT.TT_TRUCTUYEN
               ,FD.FILE_NAME ANPHI_FILE_NAME,TA.NOPCHO_DUONGSUID,TA.NHANCHO_DUONGSUID
                FROM ALD_TONGDAT TD 
                INNER JOIN ALD_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN ALD_ANPHI AI ON TD.DONID=AI.DONID
                 LEFT JOIN (SELECT FILE_NAME,ANPHI_ID FROM ALD_FILE_THA WHERE STATUS=1) FD ON FD.ANPHI_ID=AI.ID
                INNER JOIN ALD_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
             --   INNER JOIN ALD_TONGDAT_DOITUONG DO ON DO.DUONGSUID =DU.id
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN ALD_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.MALOAIVUVIEC='5'
--                LEFT JOIN ALD_FILE FL ON FL.DONID=TD.DONID AND FL.BIEUMAUID=67
                LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='5'
                LEFT JOIN ALD_SOTHAM_THULY TL ON TL.DONID=TD.DONID AND TL.TRUONGHOPTHULY=1--thu ly lan dau
                LEFT JOIN DM_DONVITHIHANHAN THA1 ON THA1.ID=TA.DONVI_THUTIEN_ID
                WHERE DU.TUCACHTOTUNG_MA='NGUYENDON' AND TD.BIEUMAUID IN(67,381) --Thông báo nộp tiền tạm ứng án phí
               -- AND DU.ISDAIDIEN = 1 --AND NULL TENFILE IS NOT NULL
                AND AI.TAMUNGANPHI !=0
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := R_TUPHAP_ANPHI_EDIT(
        item_tp.NGAYTAO, item_tp.DONVITHA_ID,item_tp.TENFILE,item_tp.LOAIAN,item_tp.MAVUVIEC,item_tp.BIEUMAUID,item_tp.MALOAIVUVIEC,item_tp.FILEID,item_tp.DONID,item_tp.DUONGSU_ID,
        item_tp.SOTHONGBAO,item_tp.TENDUONGSU,item_tp.NAMSINH,item_tp.GIOITINH,item_tp.SOCMND,item_tp.DIENTHOAI,item_tp.EMAIL,item_tp.DONVI,item_tp.TAMUNGANPHI,item_tp.STATUS,item_tp.MA_TEN,item_tp.DIACHI,
        item_tp.HOANTRAAP_HOTEN,item_tp.HOANTRAAP_GIOITINH,item_tp.HOANTRAAP_NAMSINH,item_tp.HOANTRAAP_CMND,item_tp.HOANTRAAP_TEL,item_tp.HOANTRAAP_EMAIL,item_tp.HOANTRAAP_DIACHI,item_tp.NGAYBIENLAI,item_tp.SOBIENLAI,item_tp.NGUOITHUTIEN,item_tp.NGAYGQ_YC,
        item_tp.NOP_ISNGUYENDON,item_tp.NOP_GIOITINH,item_tp.NOP_HOTEN,item_tp.NOP_NAMSINH,item_tp.NOP_CMND,item_tp.NOP_TEL,item_tp.NOP_EMAIL,item_tp.NOP_DIACHI,item_tp.HOANTRAAP_ISNGUYENDON,item_tp.LOAIDUONGSU
       ,item_tp.SOTHULY,item_tp.ANPHIHOANTRA,item_tp.NGAYHOANTRA,item_tp.GHICHU_HOANTRA,item_tp.TEN,item_tp.MA_THONGBAO,item_tp.TT_TRUCTUYEN,NULL,item_tp.ANPHI_FILE_NAME
       ,item_tp.NOPCHO_DUONGSUID,item_tp.NHANCHO_DUONGSUID);  
    END LOOP;
    ------------------------
     IF(V_COUNT_DSU=0)THEN
                 FOR item_tp IN 
                        (
                            SELECT TD.NGAYTAO,THA.ID DONVITHA_ID,NULL TENFILE,'Hành chính' LOAIAN,DO.MAVUVIEC,TD.BIEUMAUID,'6' AS MALOAIVUVIEC,TD.FILEID,TD.DONID,DU.ID DUONGSU_ID,AI.SOTHONGBAO||'/TB-TA' AS SOTHONGBAO,
                            DU.TENDUONGSU,DU.NAMSINH,DU.GIOITINH,DU.SOCMND,DU.DIENTHOAI,DU.EMAIL,TN.MA_TEN DONVI,AI.TAMUNGANPHI,
                            DECODE(tt.TRANGTHAITHANHTOAN,0,'Chưa nộp án phí',1,'Đã nộp án phí') STATUS,HC.MA_TEN,
                            DECODE(DU.TAMTRUCHITIET,NULL,HC.MA_TEN,REPLACE(DU.TAMTRUCHITIET,',')||', '||HC.MA_TEN) AS DIACHI,
                            TA.HOANTRAAP_HOTEN,TA.HOANTRAAP_GIOITINH,TA.HOANTRAAP_NAMSINH,TA.HOANTRAAP_CMND,TA.HOANTRAAP_TEL,TA.HOANTRAAP_EMAIL,TA.HOANTRAAP_DIACHI,
                            TA.NGAYBIENLAI,TA.SOBIENLAI,TA.NGUOITHUTIEN,DX.NGAYGQ_YC,
                            TA.NOP_ISNGUYENDON,TA.NOP_GIOITINH,decode(tt.TT_TRUCTUYEN,1,TT.HOTENNGUOINOPTIEN,TA.NOP_HOTEN)NOP_HOTEN,TA.NOP_NAMSINH,decode(tt.TT_TRUCTUYEN,1,tt.SOCMNDNGUOINOP,TA.NOP_CMND)NOP_CMND,TA.NOP_TEL,TA.NOP_EMAIL,decode(tt.TT_TRUCTUYEN,1,TT.DIACHINGUOINOPTIEN,TA.NOP_DIACHI)NOP_DIACHI,TA.HOANTRAAP_ISNGUYENDON,DU.LOAIDUONGSU
                            ,TL.SOTHULY,TA.ANPHIHOANTRA,TA.NGAYHOANTRA,TA.GHICHU_HOANTRA,THA1.TEN,TT.MA_THONGBAO,TT.TT_TRUCTUYEN,AI.DUONGSU_IDS
                            ,FD.FILE_NAME ANPHI_FILE_NAME,TA.NOPCHO_DUONGSUID,TA.NHANCHO_DUONGSUID
                            FROM AHC_TONGDAT TD 
                            INNER JOIN AHC_DON DO ON TD.DONID=DO.ID     
                            INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                            INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                            INNER JOIN AHC_ANPHI AI ON TD.DONID=AI.DONID
                            LEFT JOIN (SELECT FILE_NAME,ANPHI_ID FROM AHC_FILE_THA WHERE STATUS=1) FD ON FD.ANPHI_ID=AI.ID
                            INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                            LEFT JOIN AHC_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                            LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.MALOAIVUVIEC='6'
                            LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='6'
                            INNER JOIN (SELECT * FROM AHC_ANPHI_DUONGSU WHERE DUONGSU_ID=V_DS_IDS) AD ON AD.ANPHI_ID=TT.ANPHI_ID
                            INNER JOIN AHC_DON_DUONGSU DU ON DU.ID=AD.DUONGSU_ID
                            LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                            LEFT JOIN AHC_SOTHAM_THULY TL ON TL.DONID=TD.DONID AND TL.TRUONGHOPTHULY=1--thu ly lan dau
                            LEFT JOIN DM_DONVITHIHANHAN THA1 ON THA1.ID=TA.DONVI_THUTIEN_ID
                            WHERE DU.TUCACHTOTUNG_MA='NGUYENDON' --AND TD.BIEUMAUID=121
                            AND AI.TAMUNGANPHI !=0
                       )
                LOOP
                    v_table.extend;
                    v_table(v_table.count) := R_TUPHAP_ANPHI_EDIT(
                    item_tp.NGAYTAO, item_tp.DONVITHA_ID,item_tp.TENFILE,item_tp.LOAIAN,item_tp.MAVUVIEC,item_tp.BIEUMAUID,item_tp.MALOAIVUVIEC,item_tp.FILEID,item_tp.DONID,item_tp.DUONGSU_ID,
                    item_tp.SOTHONGBAO,item_tp.TENDUONGSU,item_tp.NAMSINH,item_tp.GIOITINH,item_tp.SOCMND,item_tp.DIENTHOAI,item_tp.EMAIL,item_tp.DONVI,item_tp.TAMUNGANPHI,item_tp.STATUS,item_tp.MA_TEN,item_tp.DIACHI,
                    item_tp.HOANTRAAP_HOTEN,item_tp.HOANTRAAP_GIOITINH,item_tp.HOANTRAAP_NAMSINH,item_tp.HOANTRAAP_CMND,item_tp.HOANTRAAP_TEL,item_tp.HOANTRAAP_EMAIL,item_tp.HOANTRAAP_DIACHI,item_tp.NGAYBIENLAI,item_tp.SOBIENLAI,item_tp.NGUOITHUTIEN,item_tp.NGAYGQ_YC,
                    item_tp.NOP_ISNGUYENDON,item_tp.NOP_GIOITINH,item_tp.NOP_HOTEN,item_tp.NOP_NAMSINH,item_tp.NOP_CMND,item_tp.NOP_TEL,item_tp.NOP_EMAIL,item_tp.NOP_DIACHI,item_tp.HOANTRAAP_ISNGUYENDON,item_tp.LOAIDUONGSU
                   ,item_tp.SOTHULY,item_tp.ANPHIHOANTRA,item_tp.NGAYHOANTRA,item_tp.GHICHU_HOANTRA,item_tp.TEN,item_tp.MA_THONGBAO,item_tp.TT_TRUCTUYEN,item_tp.DUONGSU_IDS,item_tp.ANPHI_FILE_NAME
                   ,item_tp.NOPCHO_DUONGSUID,item_tp.NHANCHO_DUONGSUID); 
                END LOOP;
          ELSIF(V_COUNT_DSU>0)THEN  
                 FOR item_tp IN 
                        (
                            SELECT TD.NGAYTAO,THA.ID DONVITHA_ID,NULL TENFILE,'Hành chính' LOAIAN,DO.MAVUVIEC,TD.BIEUMAUID,'6' AS MALOAIVUVIEC,TD.FILEID,TD.DONID,0 DUONGSU_ID,AI.SOTHONGBAO||'/TB-TA' AS SOTHONGBAO,
                            AP.TENDUONGSU,NULL NAMSINH,NULL GIOITINH,NULL SOCMND,NULL DIENTHOAI,NULL EMAIL,TN.MA_TEN DONVI,AI.TAMUNGANPHI,
                            DECODE(tt.TRANGTHAITHANHTOAN,0,'Chưa nộp án phí',1,'Đã nộp án phí') STATUS,DT.MA_TEN,
                            NULL DIACHI,
                            TA.HOANTRAAP_HOTEN,TA.HOANTRAAP_GIOITINH,TA.HOANTRAAP_NAMSINH,TA.HOANTRAAP_CMND,TA.HOANTRAAP_TEL,TA.HOANTRAAP_EMAIL,TA.HOANTRAAP_DIACHI,
                            TA.NGAYBIENLAI,TA.SOBIENLAI,TA.NGUOITHUTIEN,DX.NGAYGQ_YC,
                            TA.NOP_ISNGUYENDON,TA.NOP_GIOITINH,decode(tt.TT_TRUCTUYEN,1,TT.HOTENNGUOINOPTIEN,TA.NOP_HOTEN)NOP_HOTEN,TA.NOP_NAMSINH,decode(tt.TT_TRUCTUYEN,1,tt.SOCMNDNGUOINOP,TA.NOP_CMND)NOP_CMND,TA.NOP_TEL,TA.NOP_EMAIL,decode(tt.TT_TRUCTUYEN,1,TT.DIACHINGUOINOPTIEN,TA.NOP_DIACHI)NOP_DIACHI,TA.HOANTRAAP_ISNGUYENDON,1 LOAIDUONGSU
                            ,TL.SOTHULY,TA.ANPHIHOANTRA,TA.NGAYHOANTRA,TA.GHICHU_HOANTRA,THA1.TEN,TT.MA_THONGBAO,TT.TT_TRUCTUYEN,AI.DUONGSU_IDS
                            ,FD.FILE_NAME ANPHI_FILE_NAME,TA.NOPCHO_DUONGSUID,TA.NHANCHO_DUONGSUID
                            FROM AHC_TONGDAT TD 
                            INNER JOIN AHC_DON DO ON TD.DONID=DO.ID     
                            INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                            INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                            INNER JOIN AHC_ANPHI AI ON TD.DONID=AI.DONID
                             LEFT JOIN (SELECT FILE_NAME,ANPHI_ID FROM AHC_FILE_THA WHERE STATUS=1) FD ON FD.ANPHI_ID=AI.ID
                            INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                            LEFT JOIN (SELECT LISTAGG(HN.TENDUONGSU, ', ')WITHIN GROUP (ORDER BY HN.TENDUONGSU)TENDUONGSU,DU.ANPHI_ID
                                 FROM AHC_ANPHI_DUONGSU DU LEFT JOIN AHC_DON_DUONGSU HN ON HN.ID=DU.DUONGSU_ID
                                 GROUP BY DU.ANPHI_ID
                               )AP ON AP.ANPHI_ID=AI.ID
                            LEFT JOIN AHC_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                            LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.MALOAIVUVIEC='6'
                            LEFT JOIN DM_TOAAN DT ON DT.ID=TD.TOAANID
                            LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='6'
                            LEFT JOIN AHC_SOTHAM_THULY TL ON TL.DONID=TD.DONID AND TL.TRUONGHOPTHULY=1--thu ly lan dau
                             LEFT JOIN DM_DONVITHIHANHAN THA1 ON THA1.ID=TA.DONVI_THUTIEN_ID
                            WHERE  --TD.BIEUMAUID=121--Thông báo nộp tiền tạm ứng án phí
                             AI.TAMUNGANPHI !=0
                       )
                LOOP
                    v_table.extend;
                    v_table(v_table.count) := R_TUPHAP_ANPHI_EDIT(
                    item_tp.NGAYTAO, item_tp.DONVITHA_ID,item_tp.TENFILE,item_tp.LOAIAN,item_tp.MAVUVIEC,item_tp.BIEUMAUID,item_tp.MALOAIVUVIEC,item_tp.FILEID,item_tp.DONID,item_tp.DUONGSU_ID,
                    item_tp.SOTHONGBAO,item_tp.TENDUONGSU,item_tp.NAMSINH,item_tp.GIOITINH,item_tp.SOCMND,item_tp.DIENTHOAI,item_tp.EMAIL,item_tp.DONVI,item_tp.TAMUNGANPHI,item_tp.STATUS,item_tp.MA_TEN,item_tp.DIACHI,
                    item_tp.HOANTRAAP_HOTEN,item_tp.HOANTRAAP_GIOITINH,item_tp.HOANTRAAP_NAMSINH,item_tp.HOANTRAAP_CMND,item_tp.HOANTRAAP_TEL,item_tp.HOANTRAAP_EMAIL,item_tp.HOANTRAAP_DIACHI,item_tp.NGAYBIENLAI,item_tp.SOBIENLAI,item_tp.NGUOITHUTIEN,item_tp.NGAYGQ_YC,
                    item_tp.NOP_ISNGUYENDON,item_tp.NOP_GIOITINH,item_tp.NOP_HOTEN,item_tp.NOP_NAMSINH,item_tp.NOP_CMND,item_tp.NOP_TEL,item_tp.NOP_EMAIL,item_tp.NOP_DIACHI,item_tp.HOANTRAAP_ISNGUYENDON,item_tp.LOAIDUONGSU
                   ,item_tp.SOTHULY,item_tp.ANPHIHOANTRA,item_tp.NGAYHOANTRA,item_tp.GHICHU_HOANTRA,item_tp.TEN,item_tp.MA_THONGBAO,item_tp.TT_TRUCTUYEN,item_tp.DUONGSU_IDS,item_tp.ANPHI_FILE_NAME
                   ,item_tp.NOPCHO_DUONGSUID,item_tp.NHANCHO_DUONGSUID); 
                END LOOP;
        END IF;  
    ----PS
     FOR item_tp IN 
            (
                SELECT TD.NGAYTAO,THA.ID DONVITHA_ID,NULL TENFILE,'Phá sản' LOAIAN,DO.MAVUVIEC,TD.BIEUMAUID,'7' AS MALOAIVUVIEC,TD.FILEID,TD.DONID,DU.ID DUONGSU_ID,AI.SOTHONGBAO||'/TB-TA' AS SOTHONGBAO,
                DU.TENDUONGSU,DU.NAMSINH,DU.GIOITINH,DU.SOCMND,DU.DIENTHOAI,DU.EMAIL,TN.MA_TEN DONVI,AI.TAMUNGANPHI,
                DECODE(tt.TRANGTHAITHANHTOAN,0,'Chưa nộp án phí',1,'Đã nộp án phí') STATUS,HC.MA_TEN,
                DECODE(DU.TAMTRUCHITIET,NULL,HC.MA_TEN,REPLACE(DU.TAMTRUCHITIET,',')||', '||HC.MA_TEN) AS DIACHI,
                TA.HOANTRAAP_HOTEN,TA.HOANTRAAP_GIOITINH,TA.HOANTRAAP_NAMSINH,TA.HOANTRAAP_CMND,TA.HOANTRAAP_TEL,TA.HOANTRAAP_EMAIL,TA.HOANTRAAP_DIACHI,
                TA.NGAYBIENLAI,TA.SOBIENLAI,TA.NGUOITHUTIEN,DX.NGAYGQ_YC,
                TA.NOP_ISNGUYENDON,TA.NOP_GIOITINH,decode(tt.TT_TRUCTUYEN,1,TT.HOTENNGUOINOPTIEN,TA.NOP_HOTEN)NOP_HOTEN,TA.NOP_NAMSINH,decode(tt.TT_TRUCTUYEN,1,tt.SOCMNDNGUOINOP,TA.NOP_CMND)NOP_CMND,TA.NOP_TEL,TA.NOP_EMAIL,decode(tt.TT_TRUCTUYEN,1,TT.DIACHINGUOINOPTIEN,TA.NOP_DIACHI)NOP_DIACHI,TA.HOANTRAAP_ISNGUYENDON,DU.LOAIDUONGSU
                ,TL.SOTHULY,TA.ANPHIHOANTRA,TA.NGAYHOANTRA,TA.GHICHU_HOANTRA,THA1.TEN,TT.MA_THONGBAO,TT.TT_TRUCTUYEN
                ,FD.FILE_NAME ANPHI_FILE_NAME,TA.NOPCHO_DUONGSUID,TA.NHANCHO_DUONGSUID
                FROM APS_TONGDAT TD 
                INNER JOIN APS_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN APS_ANPHI AI ON TD.DONID=AI.DONID
                LEFT JOIN (SELECT FILE_NAME,ANPHI_ID FROM APS_FILE_THA WHERE STATUS=1) FD ON FD.ANPHI_ID=AI.ID
                INNER JOIN APS_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
             --   INNER JOIN APS_TONGDAT_DOITUONG DO ON DO.DUONGSUID =DU.id
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN APS_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                 LEFT JOIN DVCQG_THANH_TOAN TT ON tt.DUONGSU_ID=AI.DUONGSU_ID AND TT.MALOAIVUVIEC='7'
                 LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.DUONGSU_ID=TT.DUONGSU_ID AND TA.MALOAIVUVIEC='7'
                LEFT JOIN APS_SOTHAM_THULY TL ON TL.DONID=TD.DONID AND TL.TRUONGHOPTHULY=1--thu ly lan dau
                LEFT JOIN DM_DONVITHIHANHAN THA1 ON THA1.ID=TA.DONVI_THUTIEN_ID
                WHERE DU.TUCACHTOTUNG_MA='NGUYENDON' AND TD.BIEUMAUID IN(67,381) --Thông báo nộp tiền tạm ứng án phí
                AND AI.TAMUNGANPHI !=0
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := R_TUPHAP_ANPHI_EDIT(
        item_tp.NGAYTAO, item_tp.DONVITHA_ID,item_tp.TENFILE,item_tp.LOAIAN,item_tp.MAVUVIEC,item_tp.BIEUMAUID,item_tp.MALOAIVUVIEC,item_tp.FILEID,item_tp.DONID,item_tp.DUONGSU_ID,
        item_tp.SOTHONGBAO,item_tp.TENDUONGSU,item_tp.NAMSINH,item_tp.GIOITINH,item_tp.SOCMND,item_tp.DIENTHOAI,item_tp.EMAIL,item_tp.DONVI,item_tp.TAMUNGANPHI,item_tp.STATUS,item_tp.MA_TEN,item_tp.DIACHI,
        item_tp.HOANTRAAP_HOTEN,item_tp.HOANTRAAP_GIOITINH,item_tp.HOANTRAAP_NAMSINH,item_tp.HOANTRAAP_CMND,item_tp.HOANTRAAP_TEL,item_tp.HOANTRAAP_EMAIL,item_tp.HOANTRAAP_DIACHI,item_tp.NGAYBIENLAI,item_tp.SOBIENLAI,item_tp.NGUOITHUTIEN,item_tp.NGAYGQ_YC,
        item_tp.NOP_ISNGUYENDON,item_tp.NOP_GIOITINH,item_tp.NOP_HOTEN,item_tp.NOP_NAMSINH,item_tp.NOP_CMND,item_tp.NOP_TEL,item_tp.NOP_EMAIL,item_tp.NOP_DIACHI,item_tp.HOANTRAAP_ISNGUYENDON,item_tp.LOAIDUONGSU
       ,item_tp.SOTHULY,item_tp.ANPHIHOANTRA,item_tp.NGAYHOANTRA,item_tp.GHICHU_HOANTRA,item_tp.TEN,item_tp.MA_THONGBAO,item_tp.TT_TRUCTUYEN,NULL,item_tp.ANPHI_FILE_NAME
       ,item_tp.NOPCHO_DUONGSUID,item_tp.NHANCHO_DUONGSUID);   
    END LOOP;
    --------------------
         SELECT PN.HOTEN INTO V_NGUOITHUTIEN FROM TUPHAP_NGUOISUDUNG PN WHERE PN.USERNAME=V_USERNAME;
         OPEN v_cursor FOR
                SELECT DECODE(TP.NGUOITHUTIEN,NULL,V_NGUOITHUTIEN,TP.NGUOITHUTIEN)NGUOITHUTIEN,TP.NGAYTAO,TP.DONVITHA_ID,TP.TENFILE,TP.LOAIAN,TP.MAVUVIEC,TP.BIEUMAUID,TP.MALOAIVUVIEC,TP.FILEID,COUNT(*) OVER()COUNTALL,ROW_NUMBER() OVER (ORDER BY TP.NGAYTAO DESC,TP.DONVI) STT,
                TP.DONID,TP.DUONGSU_ID,TP.SOTHONGBAO,TP.TENDUONGSU,TP.NAMSINH,TP.NAMSINH,TP.GIOITINH,TP.SOCMND,TP.DIENTHOAI,TP.EMAIL,TP.MA_TEN,TP.DONVI,TP.TAMUNGANPHI,
                TP.STATUS,TP.DIACHI,TP.HOANTRAAP_HOTEN,TP.HOANTRAAP_GIOITINH,TP.HOANTRAAP_NAMSINH,TP.HOANTRAAP_CMND,TP.HOANTRAAP_TEL,TP.HOANTRAAP_EMAIL,TP.HOANTRAAP_DIACHI,
                TP.SOBIENLAI,TP.NOP_ISNGUYENDON,TP.NOP_GIOITINH,TP.NOP_HOTEN,TP.NOP_NAMSINH,TP.NOP_CMND,TP.NOP_TEL,TP.NOP_EMAIL,TP.NOP_DIACHI,TP.HOANTRAAP_ISNGUYENDON,
                TP.NGAYBIENLAI,EXTRACT(DAY FROM TP.NGAYBIENLAI)NGAY_BIENLAI,EXTRACT(MONTH FROM TP.NGAYBIENLAI)THANG_BIENLAI,EXTRACT(YEAR FROM TP.NGAYBIENLAI)NAM_BIENLAI,
                SUBSTR(EXTRACT(YEAR FROM TP.NGAYBIENLAI),-2) KH_BIENLAI,
                EXTRACT(DAY FROM TP.NGAYGQ_YC)NGAY_YEUCAU,EXTRACT(MONTH FROM TP.NGAYGQ_YC)THANG_YEUCAU,EXTRACT(YEAR FROM TP.NGAYGQ_YC)NAM_YEUCAU,
                rtrim(to_char(TP.TAMUNGANPHI, 'FM9G999G999G999G999G999D999', 'NLS_NUMERIC_CHARACTERS='',.'''),',') TAMUNGANPHI_01,TP.LOAIDUONGSU
                ,TP.SOTHULY,TP.ANPHIHOANTRA,TP.NGAYHOANTRA,TP.GHICHU_HOANTRA,TP.DONVI_THUTIEN_TEN,TP.MA_THONGBAO,TP.TT_TRUCTUYEN,TP.ANPHI_FILE_NAME
                ,TP.NOPCHO_DUONGSUID,TP.NHANCHO_DUONGSUID  
               --  ,decode(CN.TRANG_THAI,0,'- Đang lưu',1,'- Đã gửi',2,'- Đã thu hồi',NULL)TRANG_THAI
                FROM TABLE(v_table) TP
                --LEFT JOIN TUPHAP_ANPHI_CN CN ON CN.TUPHAP_ANPHI_ID=tp.TUPHAP_ANPHI_ID
                WHERE TP.MA_THONGBAO=V_MA_THONGBAO AND TP.DONID=V_DONID AND TP.MALOAIVUVIEC = V_MALOAIVUVIEC;
    RETURN v_cursor;   
END LOAD_EDIT;
FUNCTION GET_SOLUONG
(
   V_USERNAME IN VARCHAR2 DEFAULT NULL,
   V_DONVITHA_ID  IN VARCHAR2 DEFAULT NULL
)
RETURN SYS_REFCURSOR
AS
       v_cursor SYS_REFCURSOR;V_COUNT_ALL NUMBER;V_COUNT_CHUANOP NUMBER;V_COUNT_DANOP NUMBER;
       V_TIEN_ALL NUMBER;V_TIEN_DANOP NUMBER;V_TIEN_CHUANOP NUMBER;V_TIEN_HOANTRA NUMBER:=0;V_VUVIEC_HOANTRA NUMBER:=0;
       V_EXPORT_TEXT CLOB; v_table TUPHAP_ANPHI_COUNT;V_LOAITOA VARCHAR2(150):=NULL;
       V_COUNT_DINHCHI NUMBER;V_TIEN_DINHCHI NUMBER;
BEGIN
         DBMS_LOB.createtemporary(V_EXPORT_TEXT,TRUE);    
          v_table := TUPHAP_ANPHI_COUNT(); --dung bang ding nghia-
           IF(V_DONVITHA_ID IS NOT NULL) THEN
        SELECT THA.LOAITOA INTO V_LOAITOA FROM DM_DONVITHIHANHAN THA WHERE THA.ID=V_DONVITHA_ID;
      END IF;
          ----------------------
          FOR item_tp IN 
            (
             SELECT COUNT(*) VUVIEC_HOANTRA,SUM(TA.ANPHIHOANTRA)ANPHIHOANTRA
                FROM ADS_TONGDAT TD 
                INNER JOIN ADS_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN ADS_ANPHI AI ON TD.DONID=AI.DONID
                INNER JOIN ADS_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN ADS_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN (SELECT QD.DONID FROM ADS_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi    
                LEFT JOIN DVCQG_THANH_TOAN TT ON tt.DUONGSU_ID=AI.DUONGSU_ID AND TT.MALOAIVUVIEC='2'
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.DUONGSU_ID=TT.DUONGSU_ID AND TA.MALOAIVUVIEC='2'
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE DU.TUCACHTOTUNG_MA='NGUYENDON'
                AND ((THA.ID=V_DONVITHA_ID AND V_DONVITHA_ID IS NOT NULL AND V_LOAITOA!='TOICAO') OR (V_DONVITHA_ID IS NULL OR V_LOAITOA='TOICAO')) 
                AND TA.ANPHIHOANTRA !=0 AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID IN(67,381) 
                AND AI.TAMUNGANPHI !=0
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := TUPHAP_ANPHI_COUNT_ROW(
        '2','Dân sự',0,0,0,0,item_tp.VUVIEC_HOANTRA,item_tp.ANPHIHOANTRA,
        0,0
        );  
    END LOOP;
         FOR item_tp IN 
            (
             SELECT COUNT(*) COUNT_DANOP,SUM(AI.TAMUNGANPHI)TIEN_DANOP
             FROM ADS_TONGDAT TD 
                INNER JOIN ADS_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN ADS_ANPHI AI ON TD.DONID=AI.DONID
                INNER JOIN ADS_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN ADS_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN (SELECT QD.DONID FROM ADS_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi    
                LEFT JOIN DVCQG_THANH_TOAN TT ON tt.DUONGSU_ID=AI.DUONGSU_ID  AND TT.MALOAIVUVIEC='2'
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.DUONGSU_ID=TT.DUONGSU_ID AND TA.MALOAIVUVIEC='2'
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE DU.TUCACHTOTUNG_MA='NGUYENDON'
                AND ((THA.ID=V_DONVITHA_ID AND V_DONVITHA_ID IS NOT NULL AND V_LOAITOA!='TOICAO') OR (V_DONVITHA_ID IS NULL OR V_LOAITOA='TOICAO')) 
                 AND TT.TRANGTHAITHANHTOAN=1  AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID IN(67,381)
                 AND AI.TAMUNGANPHI !=0
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := TUPHAP_ANPHI_COUNT_ROW(
        '2','Dân sự',item_tp.COUNT_DANOP,0,item_tp.TIEN_DANOP,0,0,0,
        0,0
        );  
    END LOOP;
    FOR item_tp IN 
            (
              SELECT COUNT(*)COUNT_DINHCHI,SUM(AI.TAMUNGANPHI)TIEN_DINHCHI
             FROM ADS_TONGDAT TD 
                INNER JOIN ADS_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN ADS_ANPHI AI ON TD.DONID=AI.DONID
                INNER JOIN ADS_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN ADS_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                INNER JOIN (SELECT QD.DONID FROM ADS_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi    
                LEFT JOIN DVCQG_THANH_TOAN TT ON tt.DUONGSU_ID=AI.DUONGSU_ID AND TT.MALOAIVUVIEC='2'
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.DUONGSU_ID=TT.DUONGSU_ID AND TA.MALOAIVUVIEC='2'
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE DU.TUCACHTOTUNG_MA='NGUYENDON'
                AND ((THA.ID=V_DONVITHA_ID AND V_DONVITHA_ID IS NOT NULL AND V_LOAITOA!='TOICAO') OR (V_DONVITHA_ID IS NULL OR V_LOAITOA='TOICAO')) 
                AND TT.TRANGTHAITHANHTOAN=1  AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID IN(67,381)
                AND AI.TAMUNGANPHI !=0
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := TUPHAP_ANPHI_COUNT_ROW(
        '2','Dân sự',0,0,0,0,0,0,
        item_tp.COUNT_DINHCHI,item_tp.TIEN_DINHCHI
        );  
    END LOOP;
     FOR item_tp IN 
            (
              SELECT COUNT(*) COUNT_CHUANOP,SUM(AI.TAMUNGANPHI)TIEN_CHUANOP 
             FROM ADS_TONGDAT TD 
                INNER JOIN ADS_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN ADS_ANPHI AI ON TD.DONID=AI.DONID
                INNER JOIN ADS_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN ADS_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN (SELECT QD.DONID FROM ADS_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi    
                LEFT JOIN DVCQG_THANH_TOAN TT ON tt.DUONGSU_ID=AI.DUONGSU_ID AND TT.MALOAIVUVIEC='2'
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.DUONGSU_ID=TT.DUONGSU_ID AND TA.MALOAIVUVIEC='2'
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE DU.TUCACHTOTUNG_MA='NGUYENDON'
                AND ((THA.ID=V_DONVITHA_ID AND V_DONVITHA_ID IS NOT NULL AND V_LOAITOA!='TOICAO') OR (V_DONVITHA_ID IS NULL OR V_LOAITOA='TOICAO')) 
                 AND TT.TRANGTHAITHANHTOAN=0  AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID IN(67,381) 
                 AND AI.TAMUNGANPHI !=0
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := TUPHAP_ANPHI_COUNT_ROW(
        '02','Dân sự',0,item_tp.COUNT_CHUANOP,0,item_tp.TIEN_CHUANOP,0,0,
        0,0
        );  
    END LOOP;
     FOR item_tp IN 
            (
            with ap as (SELECT LISTAGG('Họ tên:<b> '||HN.TENDUONGSU||'</b><br/> Năm sinh: '||HN.NAMSINH||'<br/> CCCD: '||HN.SOCMND||'<br/> Điên thoại: '||HN.DIENTHOAI||'<br/> Email: '||HN.EMAIL||'<br/>', '')
                                   WITHIN GROUP (ORDER BY 'Họ tên:<b> '||HN.TENDUONGSU||'</b><br/> Năm sinh: '||HN.NAMSINH||'<br/> CCCD: '||HN.SOCMND||'<br/> Điên thoại: '||HN.DIENTHOAI||'<br/> Email: '||HN.EMAIL||'<br/>') TENDUONGSU ,
                             DU.ANPHI_ID
                             FROM AHN_ANPHI_DUONGSU DU LEFT JOIN AHN_DON_DUONGSU HN ON HN.ID=DU.DUONGSU_ID
                             GROUP BY DU.ANPHI_ID
                          )
            SELECT COUNT(*) VUVIEC_HOANTRA,SUM(TA.ANPHIHOANTRA)ANPHIHOANTRA 
                FROM AHN_TONGDAT TD 
                INNER JOIN AHN_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN AHN_ANPHI AI ON TD.DONID=AI.DONID
                LEFT JOIN AP ON AP.ANPHI_ID=AI.ID
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                LEFT JOIN AHN_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.MALOAIVUVIEC='3'
                LEFT JOIN (SELECT QD.DONID FROM AHN_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
                LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='3'
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE((THA.ID=V_DONVITHA_ID AND V_DONVITHA_ID IS NOT NULL AND V_LOAITOA!='TOICAO') OR (V_DONVITHA_ID IS NULL OR V_LOAITOA='TOICAO')) 
                AND TA.ANPHIHOANTRA !=0 AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID IN(67,381)
                AND AI.TAMUNGANPHI !=0
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := TUPHAP_ANPHI_COUNT_ROW(
        '3','Hôn nhân',0,0,0,0,item_tp.VUVIEC_HOANTRA,item_tp.ANPHIHOANTRA,
        0,0
        );  
    END LOOP;
         FOR item_tp IN 
            (
            with ap as (SELECT LISTAGG('Họ tên:<b> '||HN.TENDUONGSU||'</b><br/> Năm sinh: '||HN.NAMSINH||'<br/> CCCD: '||HN.SOCMND||'<br/> Điên thoại: '||HN.DIENTHOAI||'<br/> Email: '||HN.EMAIL||'<br/>', '')
                                   WITHIN GROUP (ORDER BY 'Họ tên:<b> '||HN.TENDUONGSU||'</b><br/> Năm sinh: '||HN.NAMSINH||'<br/> CCCD: '||HN.SOCMND||'<br/> Điên thoại: '||HN.DIENTHOAI||'<br/> Email: '||HN.EMAIL||'<br/>') TENDUONGSU ,
                             DU.ANPHI_ID
                             FROM AHN_ANPHI_DUONGSU DU LEFT JOIN AHN_DON_DUONGSU HN ON HN.ID=DU.DUONGSU_ID
                             GROUP BY DU.ANPHI_ID
                          )
               SELECT COUNT(*) COUNT_DANOP,SUM(AI.TAMUNGANPHI)TIEN_DANOP 
                FROM AHN_TONGDAT TD 
                INNER JOIN AHN_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN AHN_ANPHI AI ON TD.DONID=AI.DONID
                LEFT JOIN AP ON AP.ANPHI_ID=AI.ID
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                LEFT JOIN AHN_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID  AND TA.MALOAIVUVIEC='3'
                LEFT JOIN (SELECT QD.DONID FROM AHN_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
                LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='3'
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE((THA.ID=V_DONVITHA_ID AND V_DONVITHA_ID IS NOT NULL AND V_LOAITOA!='TOICAO') OR (V_DONVITHA_ID IS NULL OR V_LOAITOA='TOICAO')) 
                AND TT.TRANGTHAITHANHTOAN=1 AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID IN(67,381)
                AND AI.TAMUNGANPHI !=0
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := TUPHAP_ANPHI_COUNT_ROW(
        '3','Hôn nhân',item_tp.COUNT_DANOP,0,item_tp.TIEN_DANOP,0,0,0,
        0,0
        );  
    END LOOP;
     FOR item_tp IN 
            (
            with ap as (SELECT LISTAGG('Họ tên:<b> '||HN.TENDUONGSU||'</b><br/> Năm sinh: '||HN.NAMSINH||'<br/> CCCD: '||HN.SOCMND||'<br/> Điên thoại: '||HN.DIENTHOAI||'<br/> Email: '||HN.EMAIL||'<br/>', '')
                                   WITHIN GROUP (ORDER BY 'Họ tên:<b> '||HN.TENDUONGSU||'</b><br/> Năm sinh: '||HN.NAMSINH||'<br/> CCCD: '||HN.SOCMND||'<br/> Điên thoại: '||HN.DIENTHOAI||'<br/> Email: '||HN.EMAIL||'<br/>') TENDUONGSU ,
                             DU.ANPHI_ID
                             FROM AHN_ANPHI_DUONGSU DU LEFT JOIN AHN_DON_DUONGSU HN ON HN.ID=DU.DUONGSU_ID
                             GROUP BY DU.ANPHI_ID
                          )
                SELECT COUNT(*) COUNT_DINHCHI,SUM(AI.TAMUNGANPHI)TIEN_DINHCHI 
                FROM AHN_TONGDAT TD 
                INNER JOIN AHN_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN AHN_ANPHI AI ON TD.DONID=AI.DONID
                LEFT JOIN AP ON AP.ANPHI_ID=AI.ID
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                LEFT JOIN AHN_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.MALOAIVUVIEC='3'
                INNER JOIN (SELECT QD.DONID FROM AHN_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
                LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='3'
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE((THA.ID=V_DONVITHA_ID AND V_DONVITHA_ID IS NOT NULL AND V_LOAITOA!='TOICAO') OR (V_DONVITHA_ID IS NULL OR V_LOAITOA='TOICAO')) 
                AND TT.TRANGTHAITHANHTOAN=1  AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID IN(67,381)
                AND AI.TAMUNGANPHI !=0
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := TUPHAP_ANPHI_COUNT_ROW(
        '3','Hôn nhân',0,0,0,0,0,0,
        item_tp.COUNT_DINHCHI,item_tp.TIEN_DINHCHI
        );  
    END LOOP;


      FOR item_tp IN 
            (
                with ap as (SELECT LISTAGG('Họ tên:<b> '||HN.TENDUONGSU||'</b><br/> Năm sinh: '||HN.NAMSINH||'<br/> CCCD: '||HN.SOCMND||'<br/> Điên thoại: '||HN.DIENTHOAI||'<br/> Email: '||HN.EMAIL||'<br/>', '')
                                   WITHIN GROUP (ORDER BY 'Họ tên:<b> '||HN.TENDUONGSU||'</b><br/> Năm sinh: '||HN.NAMSINH||'<br/> CCCD: '||HN.SOCMND||'<br/> Điên thoại: '||HN.DIENTHOAI||'<br/> Email: '||HN.EMAIL||'<br/>') TENDUONGSU ,
                             DU.ANPHI_ID
                             FROM AHN_ANPHI_DUONGSU DU LEFT JOIN AHN_DON_DUONGSU HN ON HN.ID=DU.DUONGSU_ID
                             GROUP BY DU.ANPHI_ID)
             SELECT COUNT(*) COUNT_CHUANOP,SUM(AI.TAMUNGANPHI)TIEN_CHUANOP
                FROM AHN_TONGDAT TD 
                INNER JOIN AHN_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN AHN_ANPHI AI ON TD.DONID=AI.DONID
                LEFT JOIN AP ON AP.ANPHI_ID=AI.ID
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                LEFT JOIN AHN_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID  AND TA.MALOAIVUVIEC='3'
                LEFT JOIN (SELECT QD.DONID FROM AHN_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
                LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='3'
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE((THA.ID=V_DONVITHA_ID AND V_DONVITHA_ID IS NOT NULL AND V_LOAITOA!='TOICAO') OR (V_DONVITHA_ID IS NULL OR V_LOAITOA='TOICAO')) 
                AND TT.TRANGTHAITHANHTOAN=0  AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID IN(67,381)
                AND AI.TAMUNGANPHI !=0
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := TUPHAP_ANPHI_COUNT_ROW(
        '3','Hôn nhân',0,item_tp.COUNT_CHUANOP,0,item_tp.TIEN_CHUANOP,0,0,
        0,0
        );  
    END LOOP;
     FOR item_tp IN 
            (
               SELECT COUNT(*) VUVIEC_HOANTRA,SUM(TA.ANPHIHOANTRA)ANPHIHOANTRA
                FROM AKT_TONGDAT TD 
                INNER JOIN AKT_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN AKT_ANPHI AI ON TD.DONID=AI.DONID
                INNER JOIN AKT_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN AKT_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.MALOAIVUVIEC='4'
                LEFT JOIN (SELECT QD.DONID FROM AKT_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
                LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='4'
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE DU.TUCACHTOTUNG_MA='NGUYENDON' 
                AND ((THA.ID=V_DONVITHA_ID AND V_DONVITHA_ID IS NOT NULL AND V_LOAITOA!='TOICAO') OR (V_DONVITHA_ID IS NULL OR V_LOAITOA='TOICAO'))
                 AND TA.ANPHIHOANTRA !=0   AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID IN(67,381)
                 AND AI.TAMUNGANPHI !=0
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := TUPHAP_ANPHI_COUNT_ROW(
        '4','Kinh tế',0,0,0,0,item_tp.VUVIEC_HOANTRA,item_tp.ANPHIHOANTRA,
        0,0
        );  
    END LOOP;
    FOR item_tp IN 
            (
               SELECT COUNT(*) COUNT_DANOP,SUM(AI.TAMUNGANPHI)TIEN_DANOP
                FROM AKT_TONGDAT TD 
                INNER JOIN AKT_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN AKT_ANPHI AI ON TD.DONID=AI.DONID
                INNER JOIN AKT_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN AKT_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID  AND TA.MALOAIVUVIEC='4'
                LEFT JOIN (SELECT QD.DONID FROM AKT_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
                LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='4'
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE DU.TUCACHTOTUNG_MA='NGUYENDON' 
                AND ((THA.ID=V_DONVITHA_ID AND V_DONVITHA_ID IS NOT NULL AND V_LOAITOA!='TOICAO') OR (V_DONVITHA_ID IS NULL OR V_LOAITOA='TOICAO')) 
                AND TT.TRANGTHAITHANHTOAN=1 AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID IN(67,381)
                AND AI.TAMUNGANPHI !=0
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := TUPHAP_ANPHI_COUNT_ROW(
        '4','Kinh tế',item_tp.COUNT_DANOP,0,item_tp.TIEN_DANOP,0,0,0,
        0,0
        );  
    END LOOP;
    FOR item_tp IN 
            (
               SELECT COUNT(*) COUNT_DINHCHI,SUM(AI.TAMUNGANPHI)TIEN_DINHCHI 
                FROM AKT_TONGDAT TD 
                INNER JOIN AKT_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN AKT_ANPHI AI ON TD.DONID=AI.DONID
                INNER JOIN AKT_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN AKT_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.MALOAIVUVIEC='4'
                INNER JOIN (SELECT QD.DONID FROM AKT_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
                LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='4'
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE DU.TUCACHTOTUNG_MA='NGUYENDON' 
                AND ((THA.ID=V_DONVITHA_ID AND V_DONVITHA_ID IS NOT NULL AND V_LOAITOA!='TOICAO') OR (V_DONVITHA_ID IS NULL OR V_LOAITOA='TOICAO')) 
                AND TT.TRANGTHAITHANHTOAN=1 AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID IN(67,381)
                AND AI.TAMUNGANPHI !=0

           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := TUPHAP_ANPHI_COUNT_ROW(
        '4','Kinh tế',0,0,0,0,0,0,
         item_tp.COUNT_DINHCHI,item_tp.TIEN_DINHCHI
        );  
    END LOOP;
         FOR item_tp IN 
            (
                SELECT COUNT(*) COUNT_CHUANOP,SUM(AI.TAMUNGANPHI)TIEN_CHUANOP
                FROM AKT_TONGDAT TD 
                INNER JOIN AKT_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN AKT_ANPHI AI ON TD.DONID=AI.DONID
                INNER JOIN AKT_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN AKT_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.MALOAIVUVIEC='4'
                LEFT JOIN (SELECT QD.DONID FROM AKT_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
                LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='4'
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE DU.TUCACHTOTUNG_MA='NGUYENDON' 
                AND ((THA.ID=V_DONVITHA_ID AND V_DONVITHA_ID IS NOT NULL AND V_LOAITOA!='TOICAO') OR (V_DONVITHA_ID IS NULL OR V_LOAITOA='TOICAO')) 
                AND TT.TRANGTHAITHANHTOAN=0  AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID IN(67,381)
                AND AI.TAMUNGANPHI !=0
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := TUPHAP_ANPHI_COUNT_ROW(
        '4','Kinh tế',0,item_tp.COUNT_CHUANOP,0,item_tp.TIEN_CHUANOP,0,0,
        0,0
        );  
    END LOOP;
     FOR item_tp IN 
            (
                SELECT COUNT(*) VUVIEC_HOANTRA,SUM(TA.ANPHIHOANTRA)ANPHIHOANTRA
                FROM ALD_TONGDAT TD 
                INNER JOIN ALD_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN ALD_ANPHI AI ON TD.DONID=AI.DONID
                INNER JOIN ALD_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN ALD_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.MALOAIVUVIEC='5'
                LEFT JOIN (SELECT QD.DONID FROM ALD_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
                LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='5'
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE DU.TUCACHTOTUNG_MA='NGUYENDON'
                AND ((THA.ID=V_DONVITHA_ID AND V_DONVITHA_ID IS NOT NULL AND V_LOAITOA!='TOICAO') OR (V_DONVITHA_ID IS NULL OR V_LOAITOA='TOICAO')) 
                AND TA.ANPHIHOANTRA !=0   AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID IN(67,381)
                AND AI.TAMUNGANPHI !=0
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := TUPHAP_ANPHI_COUNT_ROW(
        '5','Lao động',0,0,0,0,item_tp.VUVIEC_HOANTRA,item_tp.ANPHIHOANTRA,
        0,0
        );  
    END LOOP;
      FOR item_tp IN 
            (
              SELECT COUNT(*) COUNT_DANOP,SUM(AI.TAMUNGANPHI)TIEN_DANOP
                FROM ALD_TONGDAT TD 
                INNER JOIN ALD_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN ALD_ANPHI AI ON TD.DONID=AI.DONID
                INNER JOIN ALD_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN ALD_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.MALOAIVUVIEC='5'
                LEFT JOIN (SELECT QD.DONID FROM ALD_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
                LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='5'
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE DU.TUCACHTOTUNG_MA='NGUYENDON' 
                AND ((THA.ID=V_DONVITHA_ID AND V_DONVITHA_ID IS NOT NULL AND V_LOAITOA!='TOICAO') OR (V_DONVITHA_ID IS NULL OR V_LOAITOA='TOICAO')) 
                AND TT.TRANGTHAITHANHTOAN=1 AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID IN(67,381)
                AND AI.TAMUNGANPHI !=0
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := TUPHAP_ANPHI_COUNT_ROW(
        '5','Lao động',item_tp.COUNT_DANOP,0,item_tp.TIEN_DANOP,0,0,0,
        0,0
        );  
    END LOOP;
    FOR item_tp IN 
            (
              SELECT COUNT(*) COUNT_DINHCHI,SUM(AI.TAMUNGANPHI)TIEN_DINHCHI
                FROM ALD_TONGDAT TD 
                INNER JOIN ALD_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN ALD_ANPHI AI ON TD.DONID=AI.DONID
                INNER JOIN ALD_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN ALD_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.MALOAIVUVIEC='5'
                INNER JOIN (SELECT QD.DONID FROM ALD_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
                LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='5'
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE DU.TUCACHTOTUNG_MA='NGUYENDON'
                AND ((THA.ID=V_DONVITHA_ID AND V_DONVITHA_ID IS NOT NULL AND V_LOAITOA!='TOICAO') OR (V_DONVITHA_ID IS NULL OR V_LOAITOA='TOICAO')) 
                AND TT.TRANGTHAITHANHTOAN=1 AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID IN(67,381)
                AND AI.TAMUNGANPHI !=0
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := TUPHAP_ANPHI_COUNT_ROW(
        '5','Lao động',0,0,0,0,0,0,
        item_tp.COUNT_DINHCHI,item_tp.TIEN_DINHCHI
        );  
    END LOOP;
      FOR item_tp IN 
            (
            SELECT COUNT(*) COUNT_CHUANOP,SUM(AI.TAMUNGANPHI)TIEN_CHUANOP
                FROM ALD_TONGDAT TD 
                INNER JOIN ALD_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN ALD_ANPHI AI ON TD.DONID=AI.DONID
                INNER JOIN ALD_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN ALD_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.MALOAIVUVIEC='5'
                LEFT JOIN (SELECT QD.DONID FROM ALD_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
                LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='5'
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE DU.TUCACHTOTUNG_MA='NGUYENDON'
                AND ((THA.ID=V_DONVITHA_ID AND V_DONVITHA_ID IS NOT NULL AND V_LOAITOA!='TOICAO') OR (V_DONVITHA_ID IS NULL OR V_LOAITOA='TOICAO')) 
                AND TT.TRANGTHAITHANHTOAN=0 AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID IN(67,381)
                AND AI.TAMUNGANPHI !=0
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := TUPHAP_ANPHI_COUNT_ROW(
        '5','Lao động',0,item_tp.COUNT_CHUANOP,0,item_tp.TIEN_CHUANOP,0,0,
        0,0
        );  
    END LOOP;
    FOR item_tp IN 
            (
            with ap as (SELECT LISTAGG('Họ tên:<b> '||HN.TENDUONGSU||'</b><br/> Năm sinh: '||HN.NAMSINH||'<br/> CCCD: '||HN.SOCMND||'<br/> Điên thoại: '||HN.DIENTHOAI||'<br/> Email: '||HN.EMAIL||'<br/>', '')
                                   WITHIN GROUP (ORDER BY 'Họ tên:<b> '||HN.TENDUONGSU||'</b><br/> Năm sinh: '||HN.NAMSINH||'<br/> CCCD: '||HN.SOCMND||'<br/> Điên thoại: '||HN.DIENTHOAI||'<br/> Email: '||HN.EMAIL||'<br/>') TENDUONGSU ,
                             DU.ANPHI_ID
                             FROM AHC_ANPHI_DUONGSU DU LEFT JOIN AHC_DON_DUONGSU HN ON HN.ID=DU.DUONGSU_ID
                             GROUP BY DU.ANPHI_ID
                          )
            SELECT COUNT(*) VUVIEC_HOANTRA,SUM(TA.ANPHIHOANTRA)ANPHIHOANTRA 
            FROM AHC_TONGDAT TD 
                INNER JOIN AHC_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN AHC_ANPHI AI ON TD.DONID=AI.DONID
                LEFT JOIN AP ON AP.ANPHI_ID=AI.ID
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                LEFT JOIN AHC_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.MALOAIVUVIEC='6'
                LEFT JOIN (SELECT QD.DONID FROM AHC_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
                LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='6'
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE ((THA.ID=V_DONVITHA_ID AND V_DONVITHA_ID IS NOT NULL AND V_LOAITOA!='TOICAO') OR (V_DONVITHA_ID IS NULL OR V_LOAITOA='TOICAO')) 
                AND TA.ANPHIHOANTRA !=0 AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID=121
                AND AI.TAMUNGANPHI !=0
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := TUPHAP_ANPHI_COUNT_ROW(
        '6','Hành chính',0,0,0,0,item_tp.VUVIEC_HOANTRA,item_tp.ANPHIHOANTRA,
        0,0
        );  
    END LOOP;
         FOR item_tp IN 
            (
            with ap as (SELECT LISTAGG('Họ tên:<b> '||HN.TENDUONGSU||'</b><br/> Năm sinh: '||HN.NAMSINH||'<br/> CCCD: '||HN.SOCMND||'<br/> Điên thoại: '||HN.DIENTHOAI||'<br/> Email: '||HN.EMAIL||'<br/>', '')
                                   WITHIN GROUP (ORDER BY 'Họ tên:<b> '||HN.TENDUONGSU||'</b><br/> Năm sinh: '||HN.NAMSINH||'<br/> CCCD: '||HN.SOCMND||'<br/> Điên thoại: '||HN.DIENTHOAI||'<br/> Email: '||HN.EMAIL||'<br/>') TENDUONGSU ,
                             DU.ANPHI_ID
                             FROM AHC_ANPHI_DUONGSU DU LEFT JOIN AHC_DON_DUONGSU HN ON HN.ID=DU.DUONGSU_ID
                             GROUP BY DU.ANPHI_ID
                          )
            SELECT COUNT(*) COUNT_DANOP,SUM(AI.TAMUNGANPHI)TIEN_DANOP
            FROM AHC_TONGDAT TD 
                INNER JOIN AHC_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN AHC_ANPHI AI ON TD.DONID=AI.DONID
                LEFT JOIN AP ON AP.ANPHI_ID=AI.ID
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                LEFT JOIN AHC_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.MALOAIVUVIEC='6'
                LEFT JOIN (SELECT QD.DONID FROM AHC_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
                LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='6'
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE ((THA.ID=V_DONVITHA_ID AND V_DONVITHA_ID IS NOT NULL AND V_LOAITOA!='TOICAO') OR (V_DONVITHA_ID IS NULL OR V_LOAITOA='TOICAO')) 
                AND TT.TRANGTHAITHANHTOAN=1 AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID=121
                AND AI.TAMUNGANPHI !=0
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := TUPHAP_ANPHI_COUNT_ROW(
        '6','Hành chính',item_tp.COUNT_DANOP,0,item_tp.TIEN_DANOP,0,0,0,
        0,0
        );  
    END LOOP;
       FOR item_tp IN 
            (
            with ap as (SELECT LISTAGG('Họ tên:<b> '||HN.TENDUONGSU||'</b><br/> Năm sinh: '||HN.NAMSINH||'<br/> CCCD: '||HN.SOCMND||'<br/> Điên thoại: '||HN.DIENTHOAI||'<br/> Email: '||HN.EMAIL||'<br/>', '')
                                   WITHIN GROUP (ORDER BY 'Họ tên:<b> '||HN.TENDUONGSU||'</b><br/> Năm sinh: '||HN.NAMSINH||'<br/> CCCD: '||HN.SOCMND||'<br/> Điên thoại: '||HN.DIENTHOAI||'<br/> Email: '||HN.EMAIL||'<br/>') TENDUONGSU ,
                             DU.ANPHI_ID
                             FROM AHC_ANPHI_DUONGSU DU LEFT JOIN AHC_DON_DUONGSU HN ON HN.ID=DU.DUONGSU_ID
                             GROUP BY DU.ANPHI_ID
                          )
            SELECT COUNT(*) COUNT_DINHCHI,SUM(AI.TAMUNGANPHI)TIEN_DINHCHI
            FROM AHC_TONGDAT TD 
                INNER JOIN AHC_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN AHC_ANPHI AI ON TD.DONID=AI.DONID
                LEFT JOIN AP ON AP.ANPHI_ID=AI.ID
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                LEFT JOIN AHC_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.MALOAIVUVIEC='6'
                INNER JOIN (SELECT QD.DONID FROM AHC_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
                LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='6'
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE ((THA.ID=V_DONVITHA_ID AND V_DONVITHA_ID IS NOT NULL AND V_LOAITOA!='TOICAO') OR (V_DONVITHA_ID IS NULL OR V_LOAITOA='TOICAO')) 
                AND TT.TRANGTHAITHANHTOAN=1 AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID=121
                AND AI.TAMUNGANPHI !=0
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := TUPHAP_ANPHI_COUNT_ROW(
        '6','Hành chính',0,0,0,0,0,0,
        item_tp.COUNT_DINHCHI,item_tp.TIEN_DINHCHI
        );  
    END LOOP;
    FOR item_tp IN 
            (
            with ap as (SELECT LISTAGG('Họ tên:<b> '||HN.TENDUONGSU||'</b><br/> Năm sinh: '||HN.NAMSINH||'<br/> CCCD: '||HN.SOCMND||'<br/> Điên thoại: '||HN.DIENTHOAI||'<br/> Email: '||HN.EMAIL||'<br/>', '')
                                   WITHIN GROUP (ORDER BY 'Họ tên:<b> '||HN.TENDUONGSU||'</b><br/> Năm sinh: '||HN.NAMSINH||'<br/> CCCD: '||HN.SOCMND||'<br/> Điên thoại: '||HN.DIENTHOAI||'<br/> Email: '||HN.EMAIL||'<br/>') TENDUONGSU ,
                             DU.ANPHI_ID
                             FROM AHC_ANPHI_DUONGSU DU LEFT JOIN AHC_DON_DUONGSU HN ON HN.ID=DU.DUONGSU_ID
                             GROUP BY DU.ANPHI_ID
                          )
            SELECT COUNT(*) COUNT_CHUANOP,SUM(AI.TAMUNGANPHI)TIEN_CHUANOP
            FROM AHC_TONGDAT TD 
                INNER JOIN AHC_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN AHC_ANPHI AI ON TD.DONID=AI.DONID
                LEFT JOIN AP ON AP.ANPHI_ID=AI.ID
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                LEFT JOIN AHC_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.MALOAIVUVIEC='6'
                LEFT JOIN (SELECT QD.DONID FROM AHC_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
                LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='6'
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE ((THA.ID=V_DONVITHA_ID AND V_DONVITHA_ID IS NOT NULL AND V_LOAITOA!='TOICAO') OR (V_DONVITHA_ID IS NULL OR V_LOAITOA='TOICAO')) 
                AND TT.TRANGTHAITHANHTOAN=0  AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID=121
                AND AI.TAMUNGANPHI !=0
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := TUPHAP_ANPHI_COUNT_ROW(
        '6','Hành chính',0,item_tp.COUNT_CHUANOP,0,item_tp.TIEN_CHUANOP,0,0,
        0,0
        );  
    END LOOP;
    FOR item_tp IN 
            (
               SELECT COUNT(*) VUVIEC_HOANTRA,SUM(TA.ANPHIHOANTRA)ANPHIHOANTRA
                FROM APS_TONGDAT TD 
                INNER JOIN APS_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN APS_ANPHI AI ON TD.DONID=AI.DONID
                INNER JOIN APS_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
               -- INNER JOIN APS_TONGDAT_DOITUONG DO ON DO.DUONGSUID =DU.id
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN APS_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.MALOAIVUVIEC='7'
--                LEFT JOIN APS_FILE FL ON FL.DONID=TD.DONID AND FL.BIEUMAUID=67
                LEFT JOIN (SELECT QD.DONID FROM APS_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
               LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='7'
               LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
               WHERE DU.TUCACHTOTUNG_MA='NGUYENDON' 
                AND ((THA.ID=V_DONVITHA_ID AND V_DONVITHA_ID IS NOT NULL AND V_LOAITOA!='TOICAO') OR (V_DONVITHA_ID IS NULL OR V_LOAITOA='TOICAO')) 
                AND TA.ANPHIHOANTRA !=0 AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID IN(67,381) 
                AND AI.TAMUNGANPHI !=0
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := TUPHAP_ANPHI_COUNT_ROW(
        '7','Phá sản',0,0,0,0,item_tp.VUVIEC_HOANTRA,0,
        0,0
        );  
    END LOOP;
         FOR item_tp IN 
            (
               SELECT COUNT(*) COUNT_DANOP,SUM(AI.TAMUNGANPHI)TIEN_DANOP
                FROM APS_TONGDAT TD 
                INNER JOIN APS_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN APS_ANPHI AI ON TD.DONID=AI.DONID
                INNER JOIN APS_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN APS_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.MALOAIVUVIEC='7'
                LEFT JOIN (SELECT QD.DONID FROM APS_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
               LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='7'
               LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
               WHERE DU.TUCACHTOTUNG_MA='NGUYENDON' 
               AND ((THA.ID=V_DONVITHA_ID AND V_DONVITHA_ID IS NOT NULL AND V_LOAITOA!='TOICAO') OR (V_DONVITHA_ID IS NULL OR V_LOAITOA='TOICAO')) 
               AND TA.ANPHIHOANTRA !=0 AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID IN(67,381)
               AND AI.TAMUNGANPHI !=0
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := TUPHAP_ANPHI_COUNT_ROW(
        '7','Phá sản',item_tp.COUNT_DANOP,0,item_tp.TIEN_DANOP,0,0,0,
        0,0
        );  
    END LOOP;
    FOR item_tp IN 
            (
              SELECT COUNT(*) COUNT_DINHCHI,SUM(AI.TAMUNGANPHI)TIEN_DINHCHI
                FROM APS_TONGDAT TD 
                INNER JOIN APS_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN APS_ANPHI AI ON TD.DONID=AI.DONID
                INNER JOIN APS_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN APS_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.MALOAIVUVIEC='7'
                INNER JOIN (SELECT QD.DONID FROM APS_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
               LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='7'
               LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
               WHERE DU.TUCACHTOTUNG_MA='NGUYENDON' 
               AND ((THA.ID=V_DONVITHA_ID AND V_DONVITHA_ID IS NOT NULL AND V_LOAITOA!='TOICAO') OR (V_DONVITHA_ID IS NULL OR V_LOAITOA='TOICAO')) 
              AND TT.TRANGTHAITHANHTOAN=1 AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID IN(67,381)
              AND AI.TAMUNGANPHI !=0
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := TUPHAP_ANPHI_COUNT_ROW(
        '7','Phá sản',0,0,0,0,0,0,
        item_tp.COUNT_DINHCHI,item_tp.TIEN_DINHCHI
        );  
    END LOOP;
    FOR item_tp IN 
            (
              SELECT COUNT(*) COUNT_CHUANOP,SUM(AI.TAMUNGANPHI)TIEN_CHUANOP
                FROM APS_TONGDAT TD 
                INNER JOIN APS_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN APS_ANPHI AI ON TD.DONID=AI.DONID
                INNER JOIN APS_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN APS_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.MALOAIVUVIEC='7'
                LEFT JOIN (SELECT QD.DONID FROM APS_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
               LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='7'
               LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
               WHERE DU.TUCACHTOTUNG_MA='NGUYENDON' 
               AND ((THA.ID=V_DONVITHA_ID AND V_DONVITHA_ID IS NOT NULL AND V_LOAITOA!='TOICAO') OR (V_DONVITHA_ID IS NULL OR V_LOAITOA='TOICAO')) 
               AND TT.TRANGTHAITHANHTOAN=0 AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID IN(67,381)
              AND AI.TAMUNGANPHI !=0
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := TUPHAP_ANPHI_COUNT_ROW(
        '7','Phá sản',0,item_tp.COUNT_CHUANOP,0,item_tp.TIEN_CHUANOP,0,0,
        0,0
        );  
    END LOOP;
    ----------------------
         SELECT SUM(TP.COUNT_DANOP+TP.COUNT_CHUANOP),SUM(TP.COUNT_DANOP),SUM(TP.COUNT_CHUANOP),
         SUM(TP.TIEN_DANOP+TP.TIEN_CHUANOP),SUM(TP.TIEN_DANOP),SUM(TP.TIEN_CHUANOP),SUM(TP.VUVIEC_HOANTRA),SUM(TP.TIEN_HOANTRA),
         SUM(TP.COUNT_DINHCHI),SUM(TP.TIEN_DINHCHI)
         INTO V_COUNT_ALL,V_COUNT_DANOP,V_COUNT_CHUANOP,V_TIEN_ALL,V_TIEN_DANOP,V_TIEN_CHUANOP,V_VUVIEC_HOANTRA,V_TIEN_HOANTRA,
         V_COUNT_DINHCHI,V_TIEN_DINHCHI
         FROM TABLE(v_table) TP ;--WHERE TP.MA_LOAIAN=3;
         ------------------
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
        <div class="leftmenu">
         <div class="leftmenu_header arrow"><span>Thống kê</span></div>
                <div class="leftmenu_content">
                    <ul class="thongke">
                       <li>Tổng số thông báo: <b style="font-size: 12pt;">'||V_COUNT_ALL||'</b></li>
                        <li>Tổng số thông báo đã nộp: <b style="font-size: 12pt; margin-left: 5px;">'||V_COUNT_DANOP||'</b></li>
                        <li>Tổng số thông báo chưa nộp : <b style="font-size: 12pt; margin-left: 5px;">'||V_COUNT_CHUANOP||'</b></li>
                        <li>Tổng số vụ việc hoàn trả: <b style="font-size: 12pt; margin-left: 5px;">'||V_VUVIEC_HOANTRA||'</b></li>
                        <li>Tổng số vụ việc đình chỉ: <b style="font-size: 12pt; margin-left: 5px;">'||V_COUNT_DINHCHI||'</b></li>
                    </ul>
                </div>
            </div>
            <div class="leftmenu">
                <div class="leftmenu_header arrow" style="height:1px;"></div>
                <div class="leftmenu_content">
                  <ul class="thongke">
                     <li>Tổng số phải thu:<b style="font-size: 12pt; margin-left: 5px;">'||rtrim(to_char(V_TIEN_ALL, 'FM9G999G999G999G999G999D999', 'NLS_NUMERIC_CHARACTERS='',.'''),',')||' VNĐ</b></li>
                    <li>Tổng số tiền đã thu:<b style="font-size: 12pt; margin-left: 5px;">'||rtrim(to_char(V_TIEN_DANOP, 'FM9G999G999G999G999G999D999', 'NLS_NUMERIC_CHARACTERS='',.'''),',')||' VNĐ</b></li>
                    <li>Tổng số tiền chưa nộp:<b style="font-size: 12pt; margin-left: 5px;">'||rtrim(to_char(V_TIEN_CHUANOP, 'FM9G999G999G999G999G999D999', 'NLS_NUMERIC_CHARACTERS='',.'''),',')||' VNĐ</b></li>      
                    <li>Tổng số tiền hoàn trả:<b style="font-size: 12pt; margin-left: 5px;">'||rtrim(to_char(V_TIEN_HOANTRA, 'FM9G999G999G999G999G999D999', 'NLS_NUMERIC_CHARACTERS='',.'''),',')||' VNĐ</b></li>        
                    <li>Tổng số tiền đình chỉ nộp:<b style="font-size: 12pt; margin-left: 5px;">'||rtrim(to_char(V_TIEN_DINHCHI, 'FM9G999G999G999G999G999D999', 'NLS_NUMERIC_CHARACTERS='',.'''),',')||' VNĐ</b></li>                    
                 </ul>
                </div>
           </div>
        ');
      OPEN v_cursor FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN v_cursor;   
END GET_SOLUONG;
PROCEDURE CREATE_SOBIENLAI_APP (
        V_DONVITHA_ID  IN NUMBER,
        CURRETURN OUT SYS_REFCURSOR
    )
 IS
BEGIN
           OPEN CURRETURN FOR
            SELECT NVL(MAX(TO_NUMBER(REGEXP_REPLACE(T.SOBIENLAI, '[^0-9]'))), 0)+1 SOBIENLAI   FROM TUPHAP_ANPHI T
            WHERE T.DONVI_THUTIEN_ID = V_DONVITHA_ID
                    AND T.NGAYBIENLAI >= to_date('01/01/'||EXTRACT(YEAR FROM  sysdate),'dd/MM/yyyy')
                    AND T.NGAYBIENLAI<to_date('31/12/'||EXTRACT(YEAR FROM  sysdate),'dd/MM/yyyy');
END CREATE_SOBIENLAI_APP;
FUNCTION BO_DAU_TIENG_VIET
(
p_string VARCHAR2
) 
RETURN VARCHAR2 AS BEGIN RETURN TRANSLATE(p_string, 'ăâđêôơưàảãạáằẳẵặắầẩẫậấèẻẽẹéềểễệếìỉĩịíòỏõọóồổỗộốờởỡợớùủũụúừửữựứỳỷỹỵýĂÂĐÊÔƠƯÀẢÃẠÁẰẲẴẶẮẦẨẪẬẤÈẺẼẸÉỀỂỄỆẾÌỈĨỊÍÒỎÕỌÓỒỔỖỘỐỜỞỠỢỚÙỦŨỤÚỪỬỮỰỨỲỶỸỴÝ', 'aadeoouaaaaaaaaaaaaaaaeeeeeeeeeeiiiiiooooooooooooooouuuuuuuuuuyyyyyAADEOOUAAAAAAAAAAAAAAAEEEEEEEEEEIIIIIOOOOOOOOOOOOOOOUUUUUUUUUUYYYYYDD'); 
END BO_DAU_TIENG_VIET;
PROCEDURE  CREATE_USER_THADS
IS 

BEGIN
--     tao user cap tinhTH.SOCAP=3 --cap tinh
    FOR REC IN (
            SELECT CC.DONVITHA_ID,CC.HOTEN,CC.USERNAME FROM(
            SELECT MM.HOTEN,MM.ID DONVITHA_ID,TRIM(LOWER(REPLACE(REPLACE(MM.TEN,' '),'-'))) USERNAME FROM (
            SELECT   TT.HOTEN,TT.ID,
            TRANSLATE(TT.TEN, 'ăâđêôơưàảãạáằẳẵặắầẩẫậấèẻẽẹéềểễệếìỉĩịíòỏõọóồổỗộốờởỡợớùủũụúừửữựứỳỷỹỵýĂÂĐÊÔƠƯÀẢÃẠÁẰẲẴẶẮẦẨẪẬẤÈẺẼẸÉỀỂỄỆẾÌỈĨỊÍÒỎÕỌÓỒỔỖỘỐỜỞỠỢỚÙỦŨỤÚỪỬỮỰỨỲỶỸỴÝ', 'aadeoouaaaaaaaaaaaaaaaeeeeeeeeeeiiiiiooooooooooooooouuuuuuuuuuyyyyyAADEOOUAAAAAAAAAAAAAAAEEEEEEEEEEIIIIIOOOOOOOOOOOOOOOUUUUUUUUUUYYYYYDD') TEN
            FROM (
            SELECT TH.TEN HOTEN,TH.ID,REPLACE(REPLACE(REPLACE(TH.TEN,'Cục Thi hành án'),'tỉnh ' ),'thành phố ')TEN FROM DM_DONVITHIHANHAN TH WHERE TH.SOCAP=3 --cap tinh
            )TT
            )MM)CC
        )
         LOOP
               INSERT INTO TUPHAP_NGUOISUDUNG                
                (ID,USERNAME,HOTEN,HIEULUC,NGUOITAO,NGAYTAO,NGUOISUA,NGAYSUA,PASSWORD,DONVITHA_ID)
                VALUES (TUPHAP_NGUOISUDUNG_SEQ.NEXTVAL,REC.USERNAME,REC.HOTEN,1,'admin',sysdate,'admin',sysdate,'2d55b3bf9341e4ed55b9dcb24aca01c4',REC.DONVITHA_ID);     
        END LOOP;
        COMMIT;      
END CREATE_USER_THADS;

END PKG_TUPHAP_ANPHI;