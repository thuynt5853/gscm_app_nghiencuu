--------------------------------------------------------
--  DDL for Package Body PKG_GDTTT_APP
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_GDTTT_APP" AS
PROCEDURE THONGKE_THEO_THAMPHAN_JOB
 AS
  ma_chucvu varchar2(10); curr_thamphan_id number; V_CURSOR sys_refcursor;V_SYSDATE DATE;
   VLOAIAN varchar2(255);
  -----
  TYPE ARRAY_T IS VARRAY(3) OF NUMBER;
  array array_t := array_t(0,1,3);  
 -- array array_t := array_t(0); 
  -----    
    v_TT NUMBER; 
    LoaiAn number;TenLoaiAn varchar2(250);
    COLUMN_1 number;COLUMN_2 number;COLUMN_3 number;COLUMN_4 number;COLUMN_5 number;COLUMN_6 number;COLUMN_7 number;COLUMN_8 number;
    COLUMN_9 number;COLUMN_10 number;COLUMN_11 number;COLUMN_12 number;COLUMN_13 number;COLUMN_14 number;COLUMN_15 number;COLUMN_16 number;
    COLUMN_17 number;COLUMN_18 number;COLUMN_19 number;COLUMN_20 number;COLUMN_21 number;COLUMN_22 number;COLUMN_23 number;COLUMN_24 number;COLUMN_25 number;
    THAMPHANID number;YEAR_BC varchar2(250);  
  BEGIN 
   ---------------
    DELETE GDTTT_THONGKE_THAMPHAN 
    WHERE TOAANID=1 AND CREATE_DATE<=SYSDATE-2;
   -- AND THAMPHANID=20325;--364;
    COMMIT;
   ----------------
--   DELETE GDTTT_THONGKE_THAMPHAN WHERE 
--   WHERE THAMPHANID=20325;
   ------------
-- EXECUTE IMMEDIATE 'TRUNCATE TABLE GSCM.GDTTT_THONGKE_THAMPHAN'; 
    ------------------------  
    ------------------------
        SELECT SYSDATE INTO V_SYSDATE FROM DUAL;
        -----------
        FOR tp IN (SELECT c.ID,DECODE(d.MA,NULL,c.id,'PCA',0,'CA',0,c.ID) THAMPHANID,c.HOTEN,SUBSTR(c.HOTEN,INSTR(c.HOTEN,' ',-1)+ 1)ORDER_TEN,
                 d.MA FROM DM_CANBO c
                 inner join (select i.ID, i.TEN from DM_DATAITEM i where i.MA in ('TPTATC') and i.GROUPID=12 ) d1 on d1.ID=c.CHUCDANHID  
                 left join (select ii.ID,ii.MA,ii.TEN from DM_DATAITEM ii where ii.GROUPID=13)d on d.ID=c.CHUCVUID
                 WHere c.TOAANID=1 and c.HieuLuc=1 and (c.MaDongBo is not null or Length(NVL(c.Madongbo,''))>0)
--                 and C.ID=3374
                 ------
--                 AND C.ID=20325--364 ----Nguyễn Thị Hoàng Anh -- AND C.ID=364 - Đặng Xuân đào
                 ------
                 ORDER BY SUBSTR(c.HOTEN,INSTR(c.HOTEN,' ',-1)+ 1)
                )
        LOOP
              FOR year_item IN (SELECT TT.NGAYTAO YEAR_ID,'Năm '||TT.NGAYTAO YEAR_TEN FROM (
                             select EXTRACT(year FROM a.NGAYTAO)NGAYTAO from GDTTT_VUAN a 
                             where a.TOAANID=1 AND a.NGAYTAO IS NOT NULL and ((a.ThamPhanID=tp.THAMPHANID AND tp.THAMPHANID!=0) OR tp.THAMPHANID=0)
                            ------------
--                             AND EXTRACT(year FROM a.NGAYTAO) IN (2019,2018,2017) ----lấy 3 năm để test
                            ------------
                             )TT WHERE TT.NGAYTAO>=2018 GROUP BY TT.NGAYTAO ORDER BY TT.NGAYTAO DESC
                            --)TT WHERE TT.NGAYTAO>=2019 GROUP BY TT.NGAYTAO ORDER BY TT.NGAYTAO DESC
                           )
              LOOP
             FOR I IN 1..ARRAY.COUNT --trường hợp array(i)= 0 tất cả,1 án quốc hội, 3 án thời hiệu
                LOOP      
                    PKG_GDTTT_APP.TK_THAMPHAN_CREATE_DATA(1,tp.ID,NULL,NULL,array(I),year_item.YEAR_ID,V_CURSOR);
                    -- V_CURSOR:=V_CURSOR;
                    -----------------------
                   LOOP 
                    FETCH V_CURSOR --chạy từng dòng dữ liệu gán vào các biến
                      INTO  v_TT,
                            LoaiAn,TenLoaiAn,
                            COLUMN_1,COLUMN_2,COLUMN_3,COLUMN_4,COLUMN_5,COLUMN_6,COLUMN_7,COLUMN_8,
                            COLUMN_9,COLUMN_10,COLUMN_11,COLUMN_12,COLUMN_13,COLUMN_14,COLUMN_15,COLUMN_16,
                            COLUMN_17,COLUMN_18,COLUMN_19,COLUMN_20,COLUMN_21,COLUMN_22,COLUMN_23,COLUMN_24,COLUMN_25;
                      EXIT WHEN V_CURSOR%NOTFOUND;
                      ----INSERT DATA TO TABLE
                        insert into GDTTT_THONGKE_THAMPHAN
                        (LoaiAn,TenLoaiAn,YEAR_BC,THAMPHANID,LOAIANDB,
                                COLUMN_1,COLUMN_2,COLUMN_3,COLUMN_4,COLUMN_5,COLUMN_6,COLUMN_7,COLUMN_8,
                                COLUMN_9,COLUMN_10,COLUMN_11,COLUMN_12,COLUMN_13,COLUMN_14,COLUMN_15,COLUMN_16,
                                COLUMN_17,COLUMN_18,COLUMN_19,COLUMN_20,COLUMN_21,COLUMN_22,COLUMN_23,COLUMN_24,COLUMN_25,CREATE_DATE,TOAANID)
                        values 
                        (LoaiAn,TenLoaiAn,year_item.YEAR_ID,tp.ID,array(I),
                                COLUMN_1,COLUMN_2,COLUMN_3,COLUMN_4,COLUMN_5,COLUMN_6,COLUMN_7,COLUMN_8,
                                COLUMN_9,COLUMN_10,COLUMN_11,COLUMN_12,COLUMN_13,COLUMN_14,COLUMN_15,COLUMN_16,
                                COLUMN_17,COLUMN_18,COLUMN_19,COLUMN_20,COLUMN_21,COLUMN_22,COLUMN_23,COLUMN_24,COLUMN_25,V_SYSDATE,1);
                       COMMIT;          
                   END LOOP;
                  CLOSE V_CURSOR;
              ---------------
            END LOOP;
         END LOOP;
    END LOOP;
END THONGKE_THEO_THAMPHAN_JOB;
PROCEDURE TK_THAMPHAN_CREATE_DATA
    (
        vToaAnID in number,
        vThamphanID  in number,
        vTuNgay in date,
        vDenNgay in date,
        LoaiAnDB in number,--thuộc án
        vYears in varchar2,
        curReturn OUT SYS_REFCURSOR
    ) AS    
       V_CURSOR sys_refcursor; v_table T_THONGKE_THAMPHAN;v_table_all T_TINHTRANG;v_table_all_conlai T_TINHTRANG;
        -------------------------------
        v_TT NUMBER;v_Tongso number;ma_chucvu varchar2(10); curr_thamphan_id number;
        LOAIAN_ID VARCHAR2(150);LOAIAN_TEN VARCHAR2(150);VUANID NUMBER;LANHDAOID NUMBER;TINHTRANGID NUMBER;NGAYTRA DATE; TOTRINH_ID NUMBER;NGAYTRINH  DATE;ISCAPTRINHTIEP NUMBER;THUTU_CAPTRINH NUMBER;
        -------------------------------
        vvTuNgay date;vvDenNgay date;vvTuNgay_01 date;
        V_LOAI_AN_PCA VARCHAR2(2000);
  BEGIN    
    v_table := T_THONGKE_THAMPHAN(); v_table_all := T_TINHTRANG(); v_table_all_conlai := T_TINHTRANG(); 
    --------------------------------
    select b.Ma  into ma_chucvu  from DM_CanBo a left join DM_DataItem b on a.ChucVuID = b.ID where a.Id = vThamphanID;
    curr_thamphan_id:=0;
       if  (ma_chucvu is null)then 
            curr_thamphan_id:= vThamphanID;
        elsif(ma_chucvu='CA')then  
          curr_thamphan_id:=0; 
        ELSIF(ma_chucvu='PCA')THEN
          curr_thamphan_id:=0; 
            ------
--            SELECT  LISTAGG(TS.LOAIAN_ID,',') WITHIN GROUP (ORDER BY TS.LOAIAN_ID) 
--            INTO V_LOAI_AN_PCA FROM
--                
--                (SELECT LA.LOAIAN_ID,LA.LOAIAN_TEN FROM  (
--                    SELECT DECODE(TT.COL_LOAIAN,'ISHINHSU',1,'ISDANSU',2,'ISHNGD',3,'ISKDTM',4,'ISLAODONG',5,'ISHANHCHINH',6)LOAIAN_ID,
--                    DECODE(TT.COL_LOAIAN,'ISHINHSU','HÌNH SỰ','ISDANSU','DÂN SỰ','ISHNGD','HÔN NHÂN VÀ GIA ĐÌNH','ISKDTM','KINH DOANH, THƯƠNG MẠI','ISLAODONG','LAO ĐỘNG','ISHANHCHINH','HÀNH CHÍNH')LOAIAN_TEN
--                     FROM (
--                                SELECT * FROM (SELECT PB.ISHINHSU,PB.ISDANSU, PB.ISHNGD,PB.ISKDTM,PB.ISHANHCHINH,PB.ISLAODONG FROM DM_CanBo 
--                                PB WHERE PB.Id = 1666
--                             )
--                        UNPIVOT --chuyển từ cột thành dòng
--                        (CHECK_LOAIAN for COL_LOAIAN in (ISHINHSU, ISDANSU, ISHNGD, ISKDTM,ISHANHCHINH,ISLAODONG) )
--                        )TT WHERE CHECK_LOAIAN=1 
--                    )LA   WHERE LA.LOAIAN_ID IS NOT NULL  
--                   GROUP BY LA.LOAIAN_ID,LA.LOAIAN_TEN
--               )TS;
           -------       
        ELSE
            curr_thamphan_id:= vThamphanID;
        end if;
    --------------------------------
    vvTuNgay:=to_date('01/01/'||vYears||'00:00:00','dd/MM/yyyy  hh24:mi:ss');
--    vvTuNgay_01:=to_date('01/01/'||(TO_NUMBER(vYears)-1)||'00:00:00','dd/MM/yyyy  hh24:mi:ss');
    vvDenNgay:=to_date('31/12/'||vYears||'23:59:59','dd/MM/yyyy  hh24:mi:ss');
    --for item Loai an
   FOR item IN (
                SELECT TT.LOAIAN_ID,TT.LOAIAN_TEN FROM (
                            SELECT LA.LOAIAN_ID,LA.LOAIAN_TEN FROM  (
                            SELECT DECODE(TT.COL_LOAIAN,'ISHINHSU',1,'ISDANSU',2,'ISHNGD',3,'ISKDTM',4,'ISLAODONG',5,'ISHANHCHINH',6)LOAIAN_ID,
                            DECODE(TT.COL_LOAIAN,'ISHINHSU','HÌNH SỰ','ISDANSU','DÂN SỰ','ISHNGD','HÔN NHÂN VÀ GIA ĐÌNH','ISKDTM','KINH DOANH, THƯƠNG MẠI','ISLAODONG','LAO ĐỘNG','ISHANHCHINH','HÀNH CHÍNH')LOAIAN_TEN
                            FROM (
                                    SELECT * FROM (SELECT PB.ISHINHSU,PB.ISDANSU, PB.ISHNGD,PB.ISKDTM,PB.ISHANHCHINH,PB.ISLAODONG FROM DM_CanBo 
                                    PB WHERE PB.Id = vThamphanID
                                 )
                            UNPIVOT --chuyển từ cột thành dòng
                            (CHECK_LOAIAN for COL_LOAIAN in (ISHINHSU, ISDANSU, ISHNGD, ISKDTM,ISHANHCHINH,ISLAODONG) )
                            )TT WHERE CHECK_LOAIAN=1 
                        )LA   WHERE LA.LOAIAN_ID IS NOT NULL  
                       GROUP BY LA.LOAIAN_ID,LA.LOAIAN_TEN 
                 UNION ALL --khong union với đối tượng là chánh án và phó chánh án khi đó dữ liệu sẽ là null
                        select LAS.LOAIAN_ID,LAS.LOAIAN_TEN FROM(
                            select DECODE(curr_thamphan_id,0,0,V.LOAIAN)LOAIAN_ID,DECODE(V.LOAIAN,1,'HÌNH SỰ',2,'DÂN SỰ',3,'HÔN NHÂN VÀ GIA ĐÌNH',4,'KINH DOANH, THƯƠNG MẠI',5,'LAO ĐỘNG',6,'HÀNH CHÍNH')LOAIAN_TEN From GDTTT_VUAN v 
                            where v.THAMPHANID=vThamphanID AND V.LOAIAN IS NOT NULL 
                           --anhvh edit 24/12/2019
                           --AND ((v.NGAYTAO>vvTuNgay AND v.NGAYTAO<vvDenNgay AND curr_thamphan_id=0) OR curr_thamphan_id!=0)
                           --AND v.NGAYTAO>vvTuNgay AND v.NGAYTAO<vvDenNgay
                            group by V.LOAIAN
                           )LAS WHERE LAS.LOAIAN_ID !=0 

               )TT  
               --WHERE ( (ma_chucvu='PCA' AND INSTR(','||V_LOAI_AN_PCA||',',','||TT.LOAIAN_ID||',')>0) OR(ma_chucvu!='PCA'))
               GROUP BY TT.LOAIAN_ID,TT.LOAIAN_TEN 
               ORDER BY TT.LOAIAN_ID
          )       

   LOOP
        ----------------------------------------------------------------------------------------------------
               PKG_GDTTT_BAOCAO_APP.GDTTTT_QLTOTRINH_TP(
                                              vThamphanID,vToaAnID,0,item.LOAIAN_ID,--vThamphanID,vToaAnID,vPhongBanID,vLoaiAn
                                              null,vvDenNgay,--tt_tungay,tt_denngay
                                              V_CURSOR);
               LOOP --tạo dữ liệu cho bảng lãnh đạo gồm các trạng thái cuối cùng của thẩm phán đó
                    FETCH V_CURSOR 
                    INTO   LOAIAN_ID,LOAIAN_TEN,VUANID,LANHDAOID,TINHTRANGID,NGAYTRA,TOTRINH_ID,NGAYTRINH,ISCAPTRINHTIEP,THUTU_CAPTRINH;
                    EXIT WHEN V_CURSOR%NOTFOUND;
                    v_table_all.extend;
                    v_table_all(v_table_all.count) := R_TINHTRANG( LOAIAN_ID,LOAIAN_TEN,VUANID,LANHDAOID,TINHTRANGID,NGAYTRA,TOTRINH_ID,NGAYTRINH,ISCAPTRINHTIEP,THUTU_CAPTRINH);
                    END LOOP;    
                    CLOSE V_CURSOR;  
         ----------------------------------------------------------------------------------------------------
          --------------------cũ còn lại--------------------------------------------------------------------------------
               PKG_GDTTT_BAOCAO_APP.GDTTTT_QLTOTRINH_TP(
                                              vThamphanID,vToaAnID,0,item.LOAIAN_ID,--vThamphanID,vToaAnID,vPhongBanID,vLoaiAn
                                              null,vvTuNgay,--tt_tungay,tt_denngay
                                              V_CURSOR);
               LOOP --tạo dữ liệu cho bảng lãnh đạo gồm các trạng thái cuối cùng của thẩm phán đó
                    FETCH V_CURSOR 
                    INTO   LOAIAN_ID,LOAIAN_TEN,VUANID,LANHDAOID,TINHTRANGID,NGAYTRA,TOTRINH_ID,NGAYTRINH,ISCAPTRINHTIEP,THUTU_CAPTRINH;
                    EXIT WHEN V_CURSOR%NOTFOUND;
                    v_table_all_conlai.extend;
                    v_table_all_conlai(v_table_all_conlai.count) := R_TINHTRANG( LOAIAN_ID,LOAIAN_TEN,VUANID,LANHDAOID,TINHTRANGID,NGAYTRA,TOTRINH_ID,NGAYTRINH,ISCAPTRINHTIEP,THUTU_CAPTRINH);
                    END LOOP;    
                    CLOSE V_CURSOR;  
         ----------------------------------------------------------------------------------------------------
         --Cũ còn lại của năm trước
             Select Count(v.ID) INTO v_Tongso From GDTTT_VUAN v
              --anhvh add 21/11/2019 check ngày của vụ và ngày công văn dùng cho việc truy vấn phí dưới
              LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                  WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                  WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                  END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                 Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID
                 AND ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0)
                 AND v.NGAYTAO<vvTuNgay
                 AND V.ISVIENTRUONGKN is null
--                 AND v.GQD_LOAIKETQUA IS NULL --edit by anhvh 09/03/2020
                 AND (v.GQD_LOAIKETQUA IS NULL OR (v.GQD_LOAIKETQUA IS NOT NULL AND VA.GQD_NGACVS>=vvTuNgay) )
                 --------------
                 AND ( LoaiAnDB = 0 -- Thuộc án
                    or (LoaiAnDB = 1 --án quốc hội
                         AND EXISTS(select 'X' from GDTTT_DON d 
                                                        where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                        AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                        GROUP BY d.VuViecID) 

                      )
                    or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                    or (LoaiAnDB = 3 and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
                    ) 
         ;          
          --
            v_table.extend;--chuyen vao bang dinh nghia
                 v_table(v_table.count) := R_THONGKE_THAMPHAN(
                            item.LOAIAN_ID,item.LOAIAN_TEN,
                            v_Tongso,0,0,0,0,0,--dòng dâu tiên có 6 giá trị do thêm cột cũ còn lại
                            0,0,0,0,0,--5 giá trị
                            0,0,0,0,0,--5 giá trị
                            0,0,0,0,0,--5 giá trị
                            0,0,0,0--4 giá trị
                            );
         --Tổng số vụ việc được phân công v_Tongso
            Select Count(TT.ID) into v_Tongso  FROM(
            SELECT V.ID From GDTTT_VUAN v
              Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID and ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0)
              AND v.NGAYTAO>=vvTuNgay AND v.NGAYTAO<=vvDenNgay
              -- AND V.ISVIENTRUONGKN is null
              AND ( LoaiAnDB = 0 -- Thuộc án
                or (LoaiAnDB = 1 --án quốc hội
                     AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                  )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                or (LoaiAnDB = 3 and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
               ) 
         UNION ALL 
               SELECT V.ID From GDTTT_VUAN v
               LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                  WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                  WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                  END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                 Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID
                 AND ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0)
                 AND v.NGAYTAO<vvTuNgay
                 AND (v.GQD_LOAIKETQUA IS NULL OR (v.GQD_LOAIKETQUA IS NOT NULL and VA.GQD_NGACVS>=vvTuNgay) )
                 --------------
                 AND ( LoaiAnDB = 0 -- Thuộc án
                    or (LoaiAnDB = 1 --án quốc hội
                         AND EXISTS(select 'X' from GDTTT_DON d 
                                                        where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                        AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                        GROUP BY d.VuViecID) 

                      )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                or (LoaiAnDB = 3 and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
                 )             
             )TT 
           ;
          --
            v_table.extend;--chuyen vao bang dinh nghia
                 v_table(v_table.count) := R_THONGKE_THAMPHAN(
                            item.LOAIAN_ID,item.LOAIAN_TEN,
                            0,v_Tongso,0,0,0,0,
                            0,0,0,0,0,
                            0,0,0,0,0,
                            0,0,0,0,0,
                            0,0,0,0
                            );
             --Đã phân công Phân công Thẩm tra viên;           
          Select Count(TT.ID) into v_Tongso  FROM(
            SELECT V.ID From GDTTT_VUAN v
            Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID and ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0)
            AND (v.THAMTRAVIENID IS NOT NULL OR TRIM(V.TenThamTRaVien) IS NOT NULL) 
            AND v.NGAYTAO>vvTuNgay AND v.NGAYTAO<vvDenNgay
--            AND v.NGAYTAO<vvTuNgay
             and ( LoaiAnDB = 0 -- Thuộc án
                or (LoaiAnDB = 1 --án quốc hội
                     AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                  )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
               or (LoaiAnDB = 3 
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
         ) 
         UNION ALL 
               SELECT V.ID From GDTTT_VUAN v
               LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                  WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                  WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                  END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                 Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID
                 AND ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0)
                 AND v.NGAYTAO<vvTuNgay
                 AND (v.THAMTRAVIENID IS NOT NULL OR TRIM(V.TenThamTRaVien) IS NOT NULL) 
                 AND (v.GQD_LOAIKETQUA IS NULL OR (v.GQD_LOAIKETQUA IS NOT NULL and VA.GQD_NGACVS>=vvTuNgay) )
                 --------------
                 AND ( LoaiAnDB = 0 -- Thuộc án
                    or (LoaiAnDB = 1 --án quốc hội
                         AND EXISTS(select 'X' from GDTTT_DON d 
                                                        where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                        AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                        GROUP BY d.VuViecID) 

                      )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                or (LoaiAnDB = 3 
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
               )             
             )TT 
           ;
            --
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_THAMPHAN(
                            item.LOAIAN_ID,item.LOAIAN_TEN,
                            0,0,v_Tongso,0,0,0,
                            0,0,0,0,0,
                            0,0,0,0,0,
                            0,0,0,0,0,
                            0,0,0,0
                            ); 
           --Chưa phân công Phân công Thẩm tra viên
           Select Count(TT.ID) into v_Tongso  FROM(
             SELECT V.ID From GDTTT_VUAN v
             Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID and ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0) 
             AND (v.THAMTRAVIENID IS NULL AND TRIM(V.TenThamTRaVien) IS NULL) 
             AND v.NGAYTAO>vvTuNgay AND v.NGAYTAO<vvDenNgay
             --and v.gqd_loaiketqua is null 
             --AND V.ISVIENTRUONGKN is null
             and ( LoaiAnDB = 0 -- Thuộc án
                or (LoaiAnDB = 1 --án quốc hội
                     AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                  )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
               or (LoaiAnDB = 3 
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
         ) 
          UNION ALL 
               SELECT V.ID From GDTTT_VUAN v
                 Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID
                 AND ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0)
                 AND v.NGAYTAO<vvTuNgay
                 AND (v.THAMTRAVIENID IS NULL AND TRIM(V.TenThamTRaVien) IS NULL) 
                 --AND V.ISVIENTRUONGKN is null 
                 and v.gqd_loaiketqua is null
                 --------------
                 AND ( LoaiAnDB = 0 -- Thuộc án
                    or (LoaiAnDB = 1 --án quốc hội
                         AND EXISTS(select 'X' from GDTTT_DON d 
                                                        where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                        AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                        GROUP BY d.VuViecID) 

                      )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                or (LoaiAnDB = 3 
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
               )             
             )TT 
           ;
             --
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_THAMPHAN(
                            item.LOAIAN_ID,item.LOAIAN_TEN,
                            0,0,0,v_Tongso,0,0,
                            0,0,0,0,0,
                            0,0,0,0,0,
                            0,0,0,0,0,
                            0,0,0,0
                            );   
        --Có hồ sơ        
        Select Count(TT.ID) into v_Tongso  FROM(
         SELECT V.ID From GDTTT_VUAN v
           Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID and ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0) 
           AND EXISTS (select ID from GDTTT_QUANLYHS HS where v.ID =  HS.VUANID and (  HS.NGAYNHAN is not null or  HS.LOAI = 3 )) 
           AND v.NGAYTAO>vvTuNgay AND v.NGAYTAO<vvDenNgay
           --AND V.ISVIENTRUONGKN is null 
           and v.gqd_loaiketqua is null
           and ( LoaiAnDB = 0 -- Thuộc án
                or (LoaiAnDB = 1 --án quốc hội
                     AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                  )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
               or (LoaiAnDB = 3 
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
         ) 
          UNION ALL 
                 SELECT V.ID From GDTTT_VUAN v
                 LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                  WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                  WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                  END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                 Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID
                 AND ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0)
                 AND v.NGAYTAO<vvTuNgay
                 AND EXISTS (select ID from GDTTT_QUANLYHS HS where v.ID =  HS.VUANID and (  HS.NGAYNHAN is not null or  HS.LOAI = 3 )) 
                 --AND V.ISVIENTRUONGKN is null 
                  AND (v.GQD_LOAIKETQUA IS NULL OR (v.GQD_LOAIKETQUA IS NOT NULL and VA.GQD_NGACVS>=vvTuNgay) )
                 --------------
                 AND ( LoaiAnDB = 0 -- Thuộc án
                    or (LoaiAnDB = 1 --án quốc hội
                         AND EXISTS(select 'X' from GDTTT_DON d 
                                                        where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                        AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                        GROUP BY d.VuViecID) 

                      )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                or (LoaiAnDB = 3 
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
               )             
             )TT 
           ;
           --
            v_table.extend;
              v_table(v_table.count) := R_THONGKE_THAMPHAN(
                            item.LOAIAN_ID,item.LOAIAN_TEN,
                            0,0,0,0,v_Tongso,0,
                            0,0,0,0,0,
                            0,0,0,0,0,
                            0,0,0,0,0,
                            0,0,0,0
                            );     
           --Chưa có hồ sơ
      Select Count(TT.ID) into v_Tongso  FROM(
         SELECT V.ID From GDTTT_VUAN v
         Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID and ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0)  
         and NOT EXISTS (select ID from GDTTT_QUANLYHS where v.ID = VUANID and ( NGAYNHAN is not null or LOAI = 3 ) ) 
         AND v.NGAYTAO>vvTuNgay AND v.NGAYTAO<vvDenNgay
         --AND V.ISVIENTRUONGKN is null --and v.gqd_loaiketqua is null
         and ( LoaiAnDB = 0 -- Thuộc án
                or (LoaiAnDB = 1 --án quốc hội
                     AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                  )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
               or (LoaiAnDB = 3 
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
         ) 
         UNION ALL 
               SELECT V.ID From GDTTT_VUAN v               
               LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                  WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                  WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                  END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                 Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID
                 AND ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0)
                 AND v.NGAYTAO<vvTuNgay
                and NOT EXISTS (select ID from GDTTT_QUANLYHS where v.ID = VUANID and ( NGAYNHAN is not null or LOAI = 3 ) ) 
               -- AND V.ISVIENTRUONGKN is null
                 AND (v.GQD_LOAIKETQUA IS NULL OR (v.GQD_LOAIKETQUA IS NOT NULL and VA.GQD_NGACVS>=vvTuNgay) )
                 --------------
                 AND ( LoaiAnDB = 0 -- Thuộc án
                    or (LoaiAnDB = 1 --án quốc hội
                         AND EXISTS(select 'X' from GDTTT_DON d 
                                                        where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                        AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                        GROUP BY d.VuViecID) 

                      )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                or (LoaiAnDB = 3 
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
               )             
             )TT 
           ;             
         --
            v_table.extend;
            v_table(v_table.count) := R_THONGKE_THAMPHAN(
                        item.LOAIAN_ID,item.LOAIAN_TEN,
                        0,0,0,0,0,v_Tongso,
                        0,0,0,0,0,
                        0,0,0,0,0,
                        0,0,0,0,0,
                        0,0,0,0
                        );                       
            --Chưa có tờ trình (Đã có hồ sơ) - Thẩm tra viên đang nghiên cứu                  
          Select Count(TT.ID) into v_Tongso  FROM(
            SELECT V.ID From GDTTT_VUAN v
            Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID and ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0) 
            and v.THAMTRAVIENID IS NOT NULL and v.THAMTRAVIENID != 0
            and NOT EXISTS(SELECT 'X' FROM GDTTT_TOTRINH WHERE v.ID = VUANID)
            and EXISTS (select ID from GDTTT_QUANLYHS where v.ID = VUANID and (NGAYNHAN is not null or LOAI = 3))
            and v.gqd_loaiketqua is null
            AND v.NGAYTAO>vvTuNgay AND v.NGAYTAO<vvDenNgay
            AND V.ISVIENTRUONGKN is null
             and ( LoaiAnDB = 0 -- Thuộc án
                or (LoaiAnDB = 1 --án quốc hội
                     AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                  )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
               or (LoaiAnDB = 3 
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
         ) 
          UNION ALL 
               SELECT V.ID From GDTTT_VUAN v               
               LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                  WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                  WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                  END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                 Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID
                 AND ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0)
                 AND v.NGAYTAO<vvTuNgay
                and v.THAMTRAVIENID IS NOT NULL and v.THAMTRAVIENID != 0
                and NOT EXISTS(SELECT 'X' FROM GDTTT_TOTRINH WHERE v.ID = VUANID)
                and EXISTS (select ID from GDTTT_QUANLYHS where v.ID = VUANID and (NGAYNHAN is not null or LOAI = 3))
                and v.gqd_loaiketqua is null
                 --------------
                 AND ( LoaiAnDB = 0 -- Thuộc án
                    or (LoaiAnDB = 1 --án quốc hội
                         AND EXISTS(select 'X' from GDTTT_DON d 
                                                        where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                        AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                        GROUP BY d.VuViecID) 

                      )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                or (LoaiAnDB = 3 
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
               )             
             )TT 
           ;        
            --
             v_table.extend;
              v_table(v_table.count) := R_THONGKE_THAMPHAN(
                            item.LOAIAN_ID,item.LOAIAN_TEN,
                            0,0,0,0,0,0,
                            v_Tongso,0,0,0,0,
                            0,0,0,0,0,
                            0,0,0,0,0,
                            0,0,0,0
                            ); 
            --Giải quyết tờ trình,Chưa có ý kiến       
            Select Count(TT.ID) into v_Tongso  FROM(
              SELECT V.ID From GDTTT_VUAN v
              Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID and ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0) 
              and v.GQD_LOAIKETQUA is null
              AND v.NGAYTAO>vvTuNgay AND v.NGAYTAO<vvDenNgay
              AND V.ISVIENTRUONGKN is null
              AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA WHERE V.ID=PA.VUANID AND PA.TINHTRANGID=6 AND PA.NGAYTRA IS NULL)
              and ( LoaiAnDB = 0 -- Thuộc án
                or (LoaiAnDB = 1 --án quốc hội
                     AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                  )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
               or (LoaiAnDB = 3 
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
         ) 
         UNION ALL 
               SELECT V.ID From GDTTT_VUAN v               
               LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                  WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                  WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                  END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                 Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID
                 AND ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0)
                 AND v.NGAYTAO<vvTuNgay
                 AND EXISTS(SELECT 'X' FROM TABLE(v_table_all_conlai) PA WHERE V.ID=PA.VUANID AND PA.TINHTRANGID=6 AND PA.NGAYTRA IS NULL)
                 AND V.ISVIENTRUONGKN is null AND v.GQD_LOAIKETQUA IS NULL
                 --------------
                 AND ( LoaiAnDB = 0 -- Thuộc án
                    or (LoaiAnDB = 1 --án quốc hội
                         AND EXISTS(select 'X' from GDTTT_DON d 
                                                        where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                        AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                        GROUP BY d.VuViecID) 

                      )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                or (LoaiAnDB = 3 
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
               )             
             )TT 
           ;        
               --
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_THAMPHAN(
                            item.LOAIAN_ID,item.LOAIAN_TEN,
                            0,0,0,0,0,0,
                            0,v_Tongso,0,0,0,
                            0,0,0,0,0,
                            0,0,0,0,0,
                            0,0,0,0
                            );        
             --Giải quyết tờ trình Đã có ý kiến              
            Select Count(TT.ID) into v_Tongso  FROM(
              SELECT V.ID From GDTTT_VUAN v
              Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID and ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0) 
              and v.GQD_LOAIKETQUA is null
              AND v.NGAYTAO>vvTuNgay AND v.NGAYTAO<vvDenNgay
              AND V.ISVIENTRUONGKN is null
              AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA WHERE V.ID=PA.VUANID AND PA.TINHTRANGID=6 AND PA.NGAYTRA IS NOT NULL)
              and ( LoaiAnDB = 0 -- Thuộc án
                or (LoaiAnDB = 1 --án quốc hội
                     AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                  )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
               or (LoaiAnDB = 3 
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
         ) 
          UNION ALL 
               SELECT V.ID From GDTTT_VUAN v               
               LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                  WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                  WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                  END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                 Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID
                 AND ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0)
                 AND v.NGAYTAO<vvTuNgay
                 AND EXISTS(SELECT 'X' FROM TABLE(v_table_all_conlai) PA WHERE V.ID=PA.VUANID AND PA.TINHTRANGID=6 AND PA.NGAYTRA IS NOT NULL)
                 AND V.ISVIENTRUONGKN is null AND v.GQD_LOAIKETQUA IS NULL
                 --------------
                 AND ( LoaiAnDB = 0 -- Thuộc án
                    or (LoaiAnDB = 1 --án quốc hội
                         AND EXISTS(select 'X' from GDTTT_DON d 
                                                        where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                        AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                        GROUP BY d.VuViecID) 

                      )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                or (LoaiAnDB = 3 
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
               )             
             )TT 
           ;     
              --
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_THAMPHAN(
                            item.LOAIAN_ID,item.LOAIAN_TEN,
                            0,0,0,0,0,0,
                            0,0,v_Tongso,0,0,
                            0,0,0,0,0,
                            0,0,0,0,0,
                            0,0,0,0
                            ); 
             --Đã đăng ký lịch báo cáo Thẩm phán
         Select Count(TT.ID) into v_Tongso  FROM(
              SELECT V.ID From GDTTT_VUAN v
              Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID and ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0) 
              and v.GQD_LOAIKETQUA is null
              AND v.NGAYTAO>vvTuNgay AND v.NGAYTAO<vvDenNgay
              AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA WHERE V.ID=PA.VUANID AND PA.TINHTRANGID=6)
              AND EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NgayDK IS NOT NULL  and (TINHTRANGID = 6 or CAPTRINHTIEP=6)  )
              AND V.ISVIENTRUONGKN is null
              AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18))             
              and ( LoaiAnDB = 0 -- Thuộc án
                or (LoaiAnDB = 1 --án quốc hội
                     AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                  )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
               or (LoaiAnDB = 3 
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
         ) 
          UNION ALL 
               SELECT V.ID From GDTTT_VUAN v              
               LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                  WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                  WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                  END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                 Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID
                 AND ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0)
                 AND v.NGAYTAO<vvTuNgay
                 AND EXISTS(SELECT 'X' FROM TABLE(v_table_all_conlai) PA WHERE V.ID=PA.VUANID AND PA.TINHTRANGID=6)
                 AND EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NgayDK IS NOT NULL  and (TINHTRANGID = 6 or CAPTRINHTIEP=6) )
                 AND V.ISVIENTRUONGKN is null AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18))
                 AND v.GQD_LOAIKETQUA IS NULL
                 --------------
                 AND ( LoaiAnDB = 0 -- Thuộc án
                    or (LoaiAnDB = 1 --án quốc hội
                         AND EXISTS(select 'X' from GDTTT_DON d 
                                                        where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                        AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                        GROUP BY d.VuViecID) 

                      )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                or (LoaiAnDB = 3 
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
               )             
             )TT 
           ;        
              --
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_THAMPHAN(
                            item.LOAIAN_ID,item.LOAIAN_TEN,
                            0,0,0,0,0,0,
                            0,0,0,v_Tongso,0,
                            0,0,0,0,0,
                            0,0,0,0,0,
                            0,0,0,0
                            ); 
           -----Báo cáo Phó Chánh án, Tổ Thẩm phán, Chánh án, Hội đồng Thẩm phán
           Select Count(TT.ID) into v_Tongso  FROM(
             SELECT PA.VUANID ID FROM TABLE(v_table_all) PA 
                INNER JOIN GDTTT_VUAN V ON V.ID=PA.VUANID AND v.LOAIAN =item.LOAIAN_ID 
                WHERE instr(',7,8,9,17,',','||PA.TINHTRANGID||',')>0 
                and v.gqd_loaiketqua is null
                AND v.NGAYTAO>vvTuNgay AND v.NGAYTAO<vvDenNgay
                AND NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18)
                AND V.ISVIENTRUONGKN is null
                and ( LoaiAnDB = 0 -- Thuộc án
                or (LoaiAnDB = 1 --án quốc hội
                     AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                  )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
               or (LoaiAnDB = 3 
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
         ) 
         UNION ALL  
                SELECT PA.VUANID ID FROM TABLE(v_table_all_conlai) PA 
                INNER JOIN GDTTT_VUAN V ON V.ID=PA.VUANID AND v.LOAIAN =item.LOAIAN_ID              
                LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                  WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                  WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                  END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                 Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID
                 AND ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0)
                 AND v.NGAYTAO<vvTuNgay
                 AND instr(',7,8,9,17,',','||PA.TINHTRANGID||',')>0 
                 AND NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18)
                 AND V.ISVIENTRUONGKN is null
                 AND (v.GQD_LOAIKETQUA IS NULL OR (v.GQD_LOAIKETQUA IS NOT NULL and VA.GQD_NGACVS>=vvTuNgay) )
                 --------------
                 AND ( LoaiAnDB = 0 -- Thuộc án
                    or (LoaiAnDB = 1 --án quốc hội
                         AND EXISTS(select 'X' from GDTTT_DON d 
                                                        where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                        AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                        GROUP BY d.VuViecID) 

                      )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                or (LoaiAnDB = 3 
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
               )             
             )TT
             ;    
                 --
                  v_table.extend;
                  v_table(v_table.count) := R_THONGKE_THAMPHAN(
                            item.LOAIAN_ID,item.LOAIAN_TEN,
                            0,0,0,0,0,0,
                            0,0,0,0,v_Tongso,
                            0,0,0,0,0,
                            0,0,0,0,0,
                            0,0,0,0
                            );   
             --Đã giải quyết xong,
          Select Count(TT.ID) into v_Tongso  FROM(
             SELECT V.ID From GDTTT_VUAN v
             Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID and ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0) 
             AND v.NGAYTAO>vvTuNgay AND v.NGAYTAO<vvDenNgay
             AND (v.gqd_loaiketqua = 0 OR v.gqd_loaiketqua = 1 OR v.gqd_loaiketqua = 2 OR v.gqd_loaiketqua = 3 
                )
              AND V.ISVIENTRUONGKN is null
              and ( LoaiAnDB = 0 -- Thuộc án
                or (LoaiAnDB = 1 --án quốc hội
                     AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                  )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
               or (LoaiAnDB = 3 
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
            ) 
         UNION ALL 
              SELECT V.ID From GDTTT_VUAN v              
              LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                  WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                  WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                  END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                 Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID
                 AND ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0)
                 AND v.NGAYTAO<vvTuNgay
                 AND V.ISVIENTRUONGKN is null 
                 AND (v.gqd_loaiketqua = 0 OR v.gqd_loaiketqua = 1 OR v.gqd_loaiketqua = 2 OR v.gqd_loaiketqua = 3 
                 )
                 AND (v.GQD_LOAIKETQUA IS NULL OR (v.GQD_LOAIKETQUA IS NOT NULL and VA.GQD_NGACVS>=vvTuNgay) )
                 --------------
                 AND ( LoaiAnDB = 0 -- Thuộc án
                    or (LoaiAnDB = 1 --án quốc hội
                         AND EXISTS(select 'X' from GDTTT_DON d 
                                                        where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                        AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                        GROUP BY d.VuViecID) 

                      )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                or (LoaiAnDB = 3 
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
               )             
             )TT
           ;        
              --
--   -- Đã giải quyết xong, chưa bao gồm án quốc hội 
--         SELECT Count(V.ID) From GDTTT_VUAN v              
--              LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
--                                  WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
--                                  WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
--                                  END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
--                 Where v.TOAANID=1
--                 AND v.THAMPHANID=3274
--                 AND v.NGAYTAO<to_date('26/11/2022 00:00:00','dd/MM/yyyy  hh24:mi:ss')
--                 AND V.ISVIENTRUONGKN is null 
--                 AND v.gqd_loaiketqua in (0,1,2,3,4)    
--                 AND v.GQD_LOAIKETQUA IS NOT NULL 
--                 AND VA.GQD_NGACVS>=to_date('01/10/2022 00:00:00','dd/MM/yyyy  hh24:mi:ss') 
--                 AND VA.GQD_NGACVS <=to_date('25/11/2022 00:00:00','dd/MM/yyyy  hh24:mi:ss')      
--           ;            
                      v_table.extend;
                      v_table(v_table.count) := R_THONGKE_THAMPHAN(
                                item.LOAIAN_ID,item.LOAIAN_TEN,
                                0,0,0,0,0,0,
                                0,0,0,0,0,
                                v_Tongso,0,0,0,0,
                                0,0,0,0,0,
                                0,0,0,0
                                );               
            --còn lại chưa giải quyết xong
           Select Count(TT.ID) into v_Tongso  FROM(
             SELECT V.ID From GDTTT_VUAN v
              LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                  WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                  WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                  END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
             Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID and ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0) 
             AND v.NGAYTAO>vvTuNgay AND v.NGAYTAO<vvDenNgay
             AND V.ISVIENTRUONGKN is null
--             AND v.GQD_LOAIKETQUA IS NULL --edit by anhvh 09/03/2020
             AND (v.GQD_LOAIKETQUA IS NULL OR (v.GQD_LOAIKETQUA IS NOT NULL AND VA.GQD_NGACVS>=vvDenNgay) )
             and ( LoaiAnDB = 0 -- Thuộc án
                or (LoaiAnDB = 1 --án quốc hội
                     AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                  )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
               or (LoaiAnDB = 3 
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
              )
               UNION ALL 
              SELECT V.ID From GDTTT_VUAN v              
              LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                  WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                  WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                  END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                 Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID
                 AND ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0)
                 AND v.NGAYTAO<vvTuNgay
                 AND V.ISVIENTRUONGKN is null 
--                AND v.GQD_LOAIKETQUA IS NULL --edit by anhvh 09/03/2020
                 AND (v.GQD_LOAIKETQUA IS NULL OR (v.GQD_LOAIKETQUA IS NOT NULL AND VA.GQD_NGACVS>=vvDenNgay) )
                 --------------
                 AND ( LoaiAnDB = 0 -- Thuộc án
                    or (LoaiAnDB = 1 --án quốc hội
                         AND EXISTS(select 'X' from GDTTT_DON d 
                                                        where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                        AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                        GROUP BY d.VuViecID) 

                      )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                or (LoaiAnDB = 3 
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
               )             
             )TT;       
                --
                  v_table.extend;
                  v_table(v_table.count) := R_THONGKE_THAMPHAN(
                        item.LOAIAN_ID,item.LOAIAN_TEN,
                        0,0,0,0,0,0,
                        0,0,0,0,0,
                        0,v_Tongso,0,0,0,
                        0,0,0,0,0,
                        0,0,0,0
                        );              
            --Trả lời đơn----------------------------------
             Select Count(TT.ID) into v_Tongso  FROM(
             SELECT V.ID From GDTTT_VUAN v
             Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID and ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0) 
             AND v.gqd_loaiketqua = 0 
             AND v.NGAYTAO>vvTuNgay AND v.NGAYTAO<vvDenNgay
             AND V.ISVIENTRUONGKN is null
             and ( LoaiAnDB = 0 -- Thuộc án
                or (LoaiAnDB = 1 --án quốc hội
                     AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                  )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
               or (LoaiAnDB = 3 
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
               )  
           UNION ALL 
              SELECT V.ID From GDTTT_VUAN v              
              LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                  WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                  WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                  END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                 Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID
                 AND ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0)
                 AND v.NGAYTAO<vvTuNgay
                 AND V.ISVIENTRUONGKN is null AND v.gqd_loaiketqua = 0 
                 AND (v.GQD_LOAIKETQUA IS NULL OR (v.GQD_LOAIKETQUA IS NOT NULL and VA.GQD_NGACVS>=vvTuNgay) )
                 --------------
                 AND ( LoaiAnDB = 0 -- Thuộc án
                    or (LoaiAnDB = 1 --án quốc hội
                         AND EXISTS(select 'X' from GDTTT_DON d 
                                                        where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                        AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                        GROUP BY d.VuViecID) 

                      )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                or (LoaiAnDB = 3 
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
               )             
             )TT
         ;        
               --
                  v_table.extend;
                  v_table(v_table.count) := R_THONGKE_THAMPHAN(
                        item.LOAIAN_ID,item.LOAIAN_TEN,
                        0,0,0,0,0,0,
                        0,0,0,0,0,
                        0,0,v_Tongso,0,0,
                        0,0,0,0,0,
                        0,0,0,0
                        );  
             --Kháng nghị
          Select Count(TT.ID) into v_Tongso  FROM(    
            SELECT V.ID From GDTTT_VUAN v
            Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID and ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0)   
            and  v.gqd_loaiketqua = 1 
            AND v.NGAYTAO>vvTuNgay AND v.NGAYTAO<vvDenNgay
            AND V.ISVIENTRUONGKN is null
              --------------------
              and ( LoaiAnDB = 0 -- Thuộc án
                or (LoaiAnDB = 1 --án quốc hội
                     AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                  )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
               or (LoaiAnDB = 3 
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
         ) 
          UNION ALL 
              SELECT V.ID From GDTTT_VUAN v              
              LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                  WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                  WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                  END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                 Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID
                 AND ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0)
                 AND v.NGAYTAO<vvTuNgay
                 AND V.ISVIENTRUONGKN is null AND v.gqd_loaiketqua = 1 
                 AND (v.GQD_LOAIKETQUA IS NULL OR (v.GQD_LOAIKETQUA IS NOT NULL and VA.GQD_NGACVS>=vvTuNgay) )
                 --------------
                 AND ( LoaiAnDB = 0 -- Thuộc án
                    or (LoaiAnDB = 1 --án quốc hội
                         AND EXISTS(select 'X' from GDTTT_DON d 
                                                        where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                        AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                        GROUP BY d.VuViecID) 

                      )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                or (LoaiAnDB = 3 
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
               )
             )TT   
         ;        
            --
                  v_table.extend;
                  v_table(v_table.count) := R_THONGKE_THAMPHAN(
                        item.LOAIAN_ID,item.LOAIAN_TEN,
                        0,0,0,0,0,0,
                        0,0,0,0,0,
                        0,0,0,v_Tongso,0,
                        0,0,0,0,0,
                        0,0,0,0
                        ); 
              --Xếp đơn-------------------------------------------------                          
            Select Count(TT.ID) into v_Tongso  FROM
            (    
                SELECT V.ID From GDTTT_VUAN v
                Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID and ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0) 
                and  v.gqd_loaiketqua = 2 AND V.ISVIENTRUONGKN is null
                AND v.NGAYTAO>vvTuNgay AND v.NGAYTAO<vvDenNgay
                and ( LoaiAnDB = 0 -- Thuộc án
                or (LoaiAnDB = 1 --án quốc hội
                     AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                  )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                or (LoaiAnDB = 3 
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
                 )
                 UNION ALL 
              SELECT V.ID From GDTTT_VUAN v              
              LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                  WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                  WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                  END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                 Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID
                 AND ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0)
                 AND v.NGAYTAO<vvTuNgay
                 AND V.ISVIENTRUONGKN is null AND v.gqd_loaiketqua = 2 
                 AND (v.GQD_LOAIKETQUA IS NULL OR (v.GQD_LOAIKETQUA IS NOT NULL and VA.GQD_NGACVS>=vvTuNgay) )
                 --------------
                 AND ( LoaiAnDB = 0 -- Thuộc án
                    or (LoaiAnDB = 1 --án quốc hội
                         AND EXISTS(select 'X' from GDTTT_DON d 
                                                        where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                        AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                        GROUP BY d.VuViecID) 

                      )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                or (LoaiAnDB = 3 
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
               )
             )TT   
         ;        
            --
                      v_table.extend;
                      v_table(v_table.count) := R_THONGKE_THAMPHAN(
                                    item.LOAIAN_ID,item.LOAIAN_TEN,
                                    0,0,0,0,0,0,
                                    0,0,0,0,0,
                                    0,0,0,0,v_Tongso,
                                    0,0,0,0,0,
                                    0,0,0,0
                                    );       
             --Đang dự thảo trả lời đơn                           
            Select Count(TT.ID) into v_Tongso  FROM
            (    
            SELECT V.ID From GDTTT_VUAN v
             Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID and ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0)   
             and EXISTS(select ID from GDTTT_TOTRINH tt where v.ID = tt.VUANID  and (tt.TINHTRANGID = 11 or tt.CAPTRINHTIEP=11))
             AND v.GQD_LOAIKETQUA is null AND V.ISVIENTRUONGKN is null
             AND v.NGAYTAO>vvTuNgay AND v.NGAYTAO<vvDenNgay
--               AND EXISTS (SELECT 'X' FROM TABLE(v_table_all) PA  WHERE PA.VUANID=V.ID AND PA.TINHTRANGID =11)
--                SELECT COUNT(*) INTO v_Tongso FROM TABLE(v_table_all) PA 
--                INNER JOIN GDTTT_VUAN V ON V.ID=PA.VUANID AND v.LOAIAN =item.LOAIAN_ID 
--                WHERE instr(',11,',','||PA.TINHTRANGID||',')>0 
                and ( LoaiAnDB = 0 -- Thuộc án
                 or (LoaiAnDB = 1 --án quốc hội
                     AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                  )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
               or (LoaiAnDB = 3 
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
         ) 
         UNION ALL 
              SELECT V.ID From GDTTT_VUAN v              
              LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                  WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                  WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                  END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                 Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID
                 AND ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0)
                 AND v.NGAYTAO<vvTuNgay
                 AND V.ISVIENTRUONGKN is null
                 AND v.GQD_LOAIKETQUA IS NULL 
                 and EXISTS(select ID from GDTTT_TOTRINH tt where v.ID = tt.VUANID  and (tt.TINHTRANGID = 11 or tt.CAPTRINHTIEP=11))
                 --------------
                 AND ( LoaiAnDB = 0 -- Thuộc án
                    or (LoaiAnDB = 1 --án quốc hội
                         AND EXISTS(select 'X' from GDTTT_DON d 
                                                        where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                        AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                        GROUP BY d.VuViecID) 

                      )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                or (LoaiAnDB = 3 
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
               )             
             )TT
             ;
             --
                      v_table.extend;
                      v_table(v_table.count) := R_THONGKE_THAMPHAN(
                                    item.LOAIAN_ID,item.LOAIAN_TEN,
                                    0,0,0,0,0,0,
                                    0,0,0,0,0,
                                    0,0,0,0,0,
                                    v_Tongso,0,0,0,0,
                                    0,0,0,0
                                    );    
            --Đang dự thảo kháng nghị--     
             Select Count(TT.ID) into v_Tongso  FROM
            (    
            SELECT V.ID From GDTTT_VUAN v
            Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID and ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0)   
            AND EXISTS(select ID from GDTTT_TOTRINH tt where v.ID = tt.VUANID  and (tt.TINHTRANGID = 12 or tt.CAPTRINHTIEP=12)  )
            AND v.GQD_LOAIKETQUA is null AND V.ISVIENTRUONGKN is null
            AND v.NGAYTAO>vvTuNgay AND v.NGAYTAO<vvDenNgay
--            SELECT COUNT(*) INTO v_Tongso FROM TABLE(v_table_all) PA 
--            INNER JOIN GDTTT_VUAN V ON V.ID=PA.VUANID AND v.LOAIAN =item.LOAIAN_ID 
--            WHERE instr(',12,',','||PA.TINHTRANGID||',')>0 
             and ( LoaiAnDB = 0 -- Thuộc án
                or (LoaiAnDB = 1 --án quốc hội
                     AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                  )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
               or (LoaiAnDB = 3 
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
         ) 
          UNION ALL 
              SELECT V.ID From GDTTT_VUAN v              
              LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                  WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                  WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                  END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                 Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID
                 AND ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0)
                 AND v.NGAYTAO<vvTuNgay
                 AND V.ISVIENTRUONGKN is null
                 AND v.GQD_LOAIKETQUA IS NULL 
                 AND EXISTS(select ID from GDTTT_TOTRINH tt where v.ID = tt.VUANID  and (tt.TINHTRANGID = 12 or tt.CAPTRINHTIEP=12)  )
                 --------------
                 AND ( LoaiAnDB = 0 -- Thuộc án
                    or (LoaiAnDB = 1 --án quốc hội
                         AND EXISTS(select 'X' from GDTTT_DON d 
                                                        where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                        AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                        GROUP BY d.VuViecID) 

                      )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                or (LoaiAnDB = 3 
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
               )             
             )TT
             ;
              --
                      v_table.extend;
                      v_table(v_table.count) := R_THONGKE_THAMPHAN(
                                    item.LOAIAN_ID,item.LOAIAN_TEN,
                                    0,0,0,0,0,0,
                                    0,0,0,0,0,
                                    0,0,0,0,0,
                                    0,v_Tongso,0,0,0,
                                    0,0,0,0
                                    );         
          --Tổng số kháng nghị của Chánh án và Viện kiểm sát     
         Select Count(TT.ID) into v_Tongso  FROM (  
            SELECT V.ID From GDTTT_VUAN v
            Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID and ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0)   
            and  v.gqd_loaiketqua = 1
            AND v.NGAYTAO>vvTuNgay AND v.NGAYTAO<vvDenNgay
             and ( LoaiAnDB = 0 -- Thuộc án
                or (LoaiAnDB = 1 --án quốc hội
                     AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                  )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
               or (LoaiAnDB = 3 
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
         ) 
         UNION ALL 
              SELECT V.ID From GDTTT_VUAN v              
              LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                  WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                  WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                  END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                 Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID
                 AND ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0)
                 AND v.NGAYTAO<vvTuNgay
                 AND  v.gqd_loaiketqua = 1 
                 AND (v.GQD_LOAIKETQUA IS NULL OR (v.GQD_LOAIKETQUA IS NOT NULL and VA.GQD_NGACVS>=vvTuNgay) )
                 --------------
                 AND ( LoaiAnDB = 0 -- Thuộc án
                    or (LoaiAnDB = 1 --án quốc hội
                         AND EXISTS(select 'X' from GDTTT_DON d 
                                                        where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                        AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                        GROUP BY d.VuViecID) 

                      )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                or (LoaiAnDB = 3 
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
               )
             )TT   
         ;             
            --
                      v_table.extend;
                      v_table(v_table.count) := R_THONGKE_THAMPHAN(
                                    item.LOAIAN_ID,item.LOAIAN_TEN,
                                    0,0,0,0,0,0,
                                    0,0,0,0,0,
                                    0,0,0,0,0,
                                    0,0,v_Tongso,0,0,
                                    0,0,0,0
                                    ); 
            --Đã thụ lý xx GĐT                       
         Select Count(TT.ID) into v_Tongso  FROM (  
            SELECT V.ID From GDTTT_VUAN v
            Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID and ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0)   
            and  v.gqd_loaiketqua = 1 and v.NGAYTHULYXXGDT IS NOT NULL   
            AND v.NGAYTAO>vvTuNgay AND v.NGAYTAO<vvDenNgay
             and ( LoaiAnDB = 0 -- Thuộc án
                or (LoaiAnDB = 1 --án quốc hội
                     AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                  )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
               or (LoaiAnDB = 3 
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
         ) 
         UNION ALL 
              SELECT V.ID From GDTTT_VUAN v              
              LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                  WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                  WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                  END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                 Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID
                 AND ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0)
                 AND v.NGAYTAO<vvTuNgay
                 and  v.gqd_loaiketqua = 1 and v.NGAYTHULYXXGDT IS NOT NULL 
                 AND v.GQD_LOAIKETQUA IS NOT NULL and VA.GQD_NGACVS>=vvTuNgay
                 --------------
                 AND ( LoaiAnDB = 0 -- Thuộc án
                    or (LoaiAnDB = 1 --án quốc hội
                         AND EXISTS(select 'X' from GDTTT_DON d 
                                                        where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                        AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                        GROUP BY d.VuViecID) 

                      )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                or (LoaiAnDB = 3 
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
               )
             )TT   
             ;                        
            --
             v_table.extend;
                      v_table(v_table.count) := R_THONGKE_THAMPHAN(
                                    item.LOAIAN_ID,item.LOAIAN_TEN,
                                    0,0,0,0,0,0,
                                    0,0,0,0,0,
                                    0,0,0,0,0,
                                    0,0,0,v_Tongso,0,
                                    0,0,0,0
                                    );    
           -----Chưa xét xử---------------   
        Select Count(TT.ID) into v_Tongso  FROM (  
            SELECT V.ID From GDTTT_VUAN v
            Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID and ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0)   
            AND v.NGAYTAO>vvTuNgay AND v.NGAYTAO<vvDenNgay
            and v.NGAYTHULYXXGDT IS NOT NULL AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)=0
             and ( LoaiAnDB = 0 -- Thuộc án
                or (LoaiAnDB = 1 --án quốc hội
                     AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                  )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
               or (LoaiAnDB = 3 
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
         )
          UNION ALL 
              SELECT V.ID From GDTTT_VUAN v              
              LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                  WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                  WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                  END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                 Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID
                 AND ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0)
                 AND v.NGAYTAO<vvTuNgay
                 and v.NGAYTHULYXXGDT IS NOT NULL AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)=0
                 AND v.GQD_LOAIKETQUA IS NOT NULL and VA.GQD_NGACVS>=vvTuNgay
                 --------------
                 AND ( LoaiAnDB = 0 -- Thuộc án
                    or (LoaiAnDB = 1 --án quốc hội
                         AND EXISTS(select 'X' from GDTTT_DON d 
                                                        where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                        AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                        GROUP BY d.VuViecID) 

                      )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                or (LoaiAnDB = 3 
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
               )
             )TT   
             ;    
             --
                      v_table.extend;
                      v_table(v_table.count) := R_THONGKE_THAMPHAN(
                                    item.LOAIAN_ID,item.LOAIAN_TEN,
                                    0,0,0,0,0,0,
                                    0,0,0,0,0,
                                    0,0,0,0,0,
                                    0,0,0,0,v_Tongso,
                                    0,0,0,0
                                    );    

          --Đã xét xử---------------   
           Select Count(TT.ID) into v_Tongso  FROM (  
            SELECT V.ID From GDTTT_VUAN v
            Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID and ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0)        
            AND EXISTS(select 'X' from gdttt_vuan_xetxugdttt xx where v.ID = xx.VUANID)  and v.NGAYTHULYXXGDT IS NOT NULL
            AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0
            AND v.NGAYTAO>vvTuNgay AND v.NGAYTAO<vvDenNgay
             and ( LoaiAnDB = 0 -- Thuộc án
                or (LoaiAnDB = 1 --án quốc hội
                     AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                  )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
               or (LoaiAnDB = 3 
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
         ) 
         UNION ALL 
              SELECT V.ID From GDTTT_VUAN v              
              LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                  WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                  WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                  END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                 Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID
                 AND ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0)
                 AND v.NGAYTAO<vvTuNgay
                  AND EXISTS(select 'X' from gdttt_vuan_xetxugdttt xx where v.ID = xx.VUANID)  and v.NGAYTHULYXXGDT IS NOT NULL
                  AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0
                 AND v.GQD_LOAIKETQUA IS NOT NULL and VA.GQD_NGACVS>=vvTuNgay
                 --------------
                 AND ( LoaiAnDB = 0 -- Thuộc án
                    or (LoaiAnDB = 1 --án quốc hội
                         AND EXISTS(select 'X' from GDTTT_DON d 
                                                        where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                        AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                        GROUP BY d.VuViecID) 

                      )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                or (LoaiAnDB = 3 
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
               )
             )TT   
             ;              
             --
                      v_table.extend;
                      v_table(v_table.count) := R_THONGKE_THAMPHAN(
                                    item.LOAIAN_ID,item.LOAIAN_TEN,
                                    0,0,0,0,0,0,
                                    0,0,0,0,0,
                                    0,0,0,0,0,
                                    0,0,0,0,0,
                                    v_Tongso,0,0,0
                                    ); 
              --Chủ tọa,v_Xetxu_ChuToa-------------------------------------------------                               
            Select Count(TT.ID) into v_Tongso  FROM (  
                SELECT V.ID From GDTTT_VUAN v
                Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID and ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0)        
                AND  EXISTS(select 'X' FROM GDTTT_VuAn_XXGDTT_HoiDong HD where HD.VuAnID =v.ID AND NVL(HD.IsChuToa,0)=1) 
                AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0
                and v.NGAYTHULYXXGDT IS NOT NULL
                AND v.NGAYTAO>vvTuNgay AND v.NGAYTAO<vvDenNgay
                and ( LoaiAnDB = 0 -- Thuộc án
                or (LoaiAnDB = 1 --án quốc hội
                     AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                  )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
               or (LoaiAnDB = 3 
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
         ) 
         UNION ALL 
              SELECT V.ID From GDTTT_VUAN v              
              LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                  WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                  WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                  END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                 Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID
                 AND ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0)
                 AND v.NGAYTAO<vvTuNgay
                 AND  EXISTS(select 'X' FROM GDTTT_VuAn_XXGDTT_HoiDong HD where HD.VuAnID =v.ID AND NVL(HD.IsChuToa,0)=1) 
                 AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0
                 and v.NGAYTHULYXXGDT IS NOT NULL
                 AND v.GQD_LOAIKETQUA IS NOT NULL and VA.GQD_NGACVS>=vvTuNgay
                 --------------
                 AND ( LoaiAnDB = 0 -- Thuộc án
                    or (LoaiAnDB = 1 --án quốc hội
                         AND EXISTS(select 'X' from GDTTT_DON d 
                                                        where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                        AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                        GROUP BY d.VuViecID) 

                      )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                or (LoaiAnDB = 3 
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
               )
             )TT   
             ;
             --
                      v_table.extend;
                      v_table(v_table.count) := R_THONGKE_THAMPHAN(
                                    item.LOAIAN_ID,item.LOAIAN_TEN,
                                    0,0,0,0,0,0,
                                    0,0,0,0,0,
                                    0,0,0,0,0,
                                    0,0,0,0,0,
                                    0,v_Tongso,0,0
                                    );   
              --------Hội đồng toàn thể-------------------          
              Select Count(TT.ID) into v_Tongso  FROM (  
                SELECT V.ID From GDTTT_VUAN v
                Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID and ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0)            
                and PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0
                AND EXISTS(select 'X' FROM GDTTT_VuAn_XXGDTT_HoiDong HD where HD.VuAnID =v.ID AND HD.TypeHD=1) --and ( (NVL(HD.CanBoID,0)=curr_thamphan_id and curr_thamphan_id!=0) OR curr_thamphan_id=0)
                and v.NGAYTHULYXXGDT IS NOT NULL 
                AND v.NGAYTAO>vvTuNgay AND v.NGAYTAO<vvDenNgay
              and ( LoaiAnDB = 0 -- Thuộc án
                or (LoaiAnDB = 1 --án quốc hội
                     AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                  )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
               or (LoaiAnDB = 3 
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
         ) 
         UNION ALL 
              SELECT V.ID From GDTTT_VUAN v              
              LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                  WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                  WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                  END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                 Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID
                 AND ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0)
                 AND v.NGAYTAO<vvTuNgay
                and PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0
                AND EXISTS(select 'X' FROM GDTTT_VuAn_XXGDTT_HoiDong HD where HD.VuAnID =v.ID AND HD.TypeHD=1) --and ( (NVL(HD.CanBoID,0)=curr_thamphan_id and curr_thamphan_id!=0) OR curr_thamphan_id=0)
                and v.NGAYTHULYXXGDT IS NOT NULL 
                 AND v.GQD_LOAIKETQUA IS NOT NULL and VA.GQD_NGACVS>=vvTuNgay
                 --------------
                 AND ( LoaiAnDB = 0 -- Thuộc án
                    or (LoaiAnDB = 1 --án quốc hội
                         AND EXISTS(select 'X' from GDTTT_DON d 
                                                        where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                        AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                        GROUP BY d.VuViecID) 

                      )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                or (LoaiAnDB = 3 
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
               )
             )TT   
             ;
             --
                      v_table.extend;
                      v_table(v_table.count) := R_THONGKE_THAMPHAN(
                                    item.LOAIAN_ID,item.LOAIAN_TEN,
                                    0,0,0,0,0,0,
                                    0,0,0,0,0,
                                    0,0,0,0,0,
                                    0,0,0,0,0,
                                    0,0,v_Tongso,0
                                    );             
            --Hội đồng 5   
          Select Count(TT.ID) into v_Tongso  FROM (  
            SELECT V.ID From GDTTT_VUAN v
            Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID and ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0)       
            and PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0
            AND EXISTS(select 'X' FROM GDTTT_VuAn_XXGDTT_HoiDong HD where HD.VuAnID =v.ID AND HD.TypeHD=2)
            and v.NGAYTHULYXXGDT IS NOT NULL 
            AND v.NGAYTAO>vvTuNgay AND v.NGAYTAO<vvDenNgay
             and ( LoaiAnDB = 0 -- Thuộc án
                or (LoaiAnDB = 1 --án quốc hội
                     AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                  )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
               or (LoaiAnDB = 3 
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
         ) 
         UNION ALL 
              SELECT V.ID From GDTTT_VUAN v             
              LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                  WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                  WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                  END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                 Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID
                 AND ((v.THAMPHANID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0)
                 AND v.NGAYTAO<vvTuNgay
                 and PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0
                AND EXISTS(select 'X' FROM GDTTT_VuAn_XXGDTT_HoiDong HD where HD.VuAnID =v.ID AND HD.TypeHD=2)
                and v.NGAYTHULYXXGDT IS NOT NULL 
                 AND v.GQD_LOAIKETQUA IS NOT NULL and VA.GQD_NGACVS>=vvTuNgay
                 --------------
                 AND ( LoaiAnDB = 0 -- Thuộc án
                    or (LoaiAnDB = 1 --án quốc hội
                         AND EXISTS(select 'X' from GDTTT_DON d 
                                                        where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                        AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                        GROUP BY d.VuViecID) 

                      )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                or (LoaiAnDB = 3 
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
               )
             )TT   
             ;                 
            --
                      v_table.extend;
                      v_table(v_table.count) := R_THONGKE_THAMPHAN(
                                    item.LOAIAN_ID,item.LOAIAN_TEN,
                                    0,0,0,0,0,0,
                                    0,0,0,0,0,
                                    0,0,0,0,0,
                                    0,0,0,0,0,
                                    0,0,0,v_Tongso
                                    ); 
            --được lấy từ các giá trị khác nên phải đặt ở cuối
   END LOOP;
    -----------------------------------
    OPEN curReturn FOR 
           SELECT PP.v_TT,PP.LoaiAn,PP.TenLoaiAn,PP.COLUMN_1,PP.COLUMN_2,PP.COLUMN_3,PP.COLUMN_4,
           PP.COLUMN_5,PP.COLUMN_6,PP.COLUMN_7,PP.COLUMN_8,PP.COLUMN_9,PP.COLUMN_10,
           PP.COLUMN_11,PP.COLUMN_12,PP.COLUMN_13,PP.COLUMN_14,PP.COLUMN_15,PP.COLUMN_16,PP.COLUMN_17,
           PP.COLUMN_18,PP.COLUMN_19, PP.COLUMN_20,PP.COLUMN_21,PP.COLUMN_22,PP.COLUMN_23,PP.COLUMN_24,PP.COLUMN_25 FROM 
           (
              SELECT NULL v_TT,PA.LoaiAn,PA.TenLoaiAn,SUM(PA.COLUMN_1)COLUMN_1,SUM(PA.COLUMN_2)COLUMN_2,SUM(PA.COLUMN_3)COLUMN_3,SUM(PA.COLUMN_4)COLUMN_4
              ,SUM(PA.COLUMN_5)COLUMN_5,SUM(PA.COLUMN_6)COLUMN_6,SUM(PA.COLUMN_7)COLUMN_7,SUM(PA.COLUMN_8)COLUMN_8,SUM(PA.COLUMN_9)COLUMN_9
              ,SUM(PA.COLUMN_10)COLUMN_10,SUM(PA.COLUMN_11)COLUMN_11,SUM(PA.COLUMN_12)COLUMN_12,SUM(PA.COLUMN_13)COLUMN_13,SUM(PA.COLUMN_14)COLUMN_14
              ,SUM(PA.COLUMN_15)COLUMN_15,SUM(PA.COLUMN_16)COLUMN_16,SUM(PA.COLUMN_17)COLUMN_17,SUM(PA.COLUMN_18)COLUMN_18,SUM(PA.COLUMN_19)COLUMN_19
              ,SUM(PA.COLUMN_20)COLUMN_20,SUM(PA.COLUMN_21)COLUMN_21,SUM(PA.COLUMN_22)COLUMN_22,SUM(PA.COLUMN_23)COLUMN_23,SUM(PA.COLUMN_24)COLUMN_24,SUM(PA.COLUMN_25)COLUMN_25
              ,SUM(PA.COLUMN_1+PA.COLUMN_2+PA.COLUMN_3+PA.COLUMN_4+PA.COLUMN_5+PA.COLUMN_6+PA.COLUMN_7+PA.COLUMN_8+PA.COLUMN_9+PA.COLUMN_10+PA.COLUMN_11+PA.COLUMN_12+PA.COLUMN_13+PA.COLUMN_14+PA.COLUMN_15+PA.COLUMN_16+PA.COLUMN_17+PA.COLUMN_18+PA.COLUMN_19+PA.COLUMN_20+PA.COLUMN_21+PA.COLUMN_22+PA.COLUMN_23              
              +PA.COLUMN_24+PA.COLUMN_25)COLUMN_26 FROM TABLE(v_table) PA
              GROUP BY PA.LoaiAn,PA.TenLoaiAn ORDER BY PA.LoaiAn
          )PP WHERE PP.COLUMN_26!=0--loại bỏ như những loại án nào có tất cả các cột đều trống
         UNION ALL
          SELECT NULL v_TT,NULL LoaiAn,'<span class="tong_cong_tp">TỔNG CỘNG</span>' TenLoaiAn,SUM(PA.COLUMN_1)COLUMN_1,SUM(PA.COLUMN_2)COLUMN_2,SUM(PA.COLUMN_3)COLUMN_3,SUM(PA.COLUMN_4)COLUMN_4
          ,SUM(PA.COLUMN_5)COLUMN_5,SUM(PA.COLUMN_6)COLUMN_6,SUM(PA.COLUMN_7)COLUMN_7,SUM(PA.COLUMN_8)COLUMN_8,SUM(PA.COLUMN_9)COLUMN_9
          ,SUM(PA.COLUMN_10)COLUMN_10,SUM(PA.COLUMN_11)COLUMN_11,SUM(PA.COLUMN_12)COLUMN_12,SUM(PA.COLUMN_13)COLUMN_13,SUM(PA.COLUMN_14)COLUMN_14
          ,SUM(PA.COLUMN_15)COLUMN_15,SUM(PA.COLUMN_16)COLUMN_16,SUM(PA.COLUMN_17)COLUMN_17,SUM(PA.COLUMN_18)COLUMN_18,SUM(PA.COLUMN_19)COLUMN_19
          ,SUM(PA.COLUMN_20)COLUMN_20,SUM(PA.COLUMN_21)COLUMN_21,SUM(PA.COLUMN_22)COLUMN_22,SUM(PA.COLUMN_23)COLUMN_23,SUM(PA.COLUMN_24)COLUMN_24,SUM(PA.COLUMN_25)COLUMN_25
          FROM TABLE(v_table) PA GROUP BY NULL;
        -----------------------------------
    END TK_THAMPHAN_CREATE_DATA;
PROCEDURE THONGKE_CHUNG
( 
  vToaAnID in number,
  vPhongBanID  in number,
  vLanhdaoVu number,
  vThamTraVien number,
  LoaiAnDB in number,--thuộc án
  curReturn OUT sys_refcursor
)
IS 
       V_CURSOR sys_refcursor; 
       TONG_ NUMBER;

BEGIN
         SELECT COUNT(V.ID) INTO TONG_ FROM GDTTT_VUAN V 
         WHERE V.TOAANID=VTOAANID AND V.PHONGBANID=VPHONGBANID 
         AND EXISTS(SELECT 'X' FROM  (
                                    SELECT DECODE(TT.COL_LOAIAN,'ISHINHSU',1,'ISDANSU',2,'ISHNGD',3,'ISKDTM',4,'ISLAODONG',5,'ISHANHCHINH',6)LOAIAN_ID,
                                    DECODE(TT.COL_LOAIAN,'ISHINHSU','HÌNH SỰ','ISDANSU','DÂN SỰ','ISHNGD','HÔN NHÂN VÀ GIA ĐÌNH','ISKDTM','KINH DOANH, THƯƠNG MẠI','ISLAODONG','LAO ĐỘNG','ISHANHCHINH','HÀNH CHÍNH')LOAIAN_TEN
                                    FROM (
                                    SELECT * FROM (SELECT PB.ISHINHSU,PB.ISDANSU, PB.ISHNGD, PB.ISKDTM,PB.ISHANHCHINH,PB.ISLAODONG FROM DM_PHONGBAN PB WHERE PB.TOAANID=vToaAnID AND PB.ID=vPhongBanID)
                                    UNPIVOT --chuyển từ cột thành dòng
                                    (CHECK_LOAIAN for COL_LOAIAN in (ISHINHSU, ISDANSU, ISHNGD, ISKDTM,ISHANHCHINH,ISLAODONG) )
                                    )TT WHERE CHECK_LOAIAN=1 
                                )LA 
                                WHERE LA.LOAIAN_ID IS NOT NULL AND V.LOAIAN=LA.LOAIAN_ID
                                GROUP BY LA.LOAIAN_ID,LA.LOAIAN_TEN 
                    )
         AND ((NVL(v.LANHDAOVUID,0)=vLanhdaoVu AND vLanhdaoVu !=0) OR(vLanhdaoVu=0))
         AND (vThamTraVien=0
              OR(v.THAMTRAVIENID=vThamTraVien AND vThamTraVien !=0)
             )
         AND NVL(v.GQD_LOAIKETQUA,5) = 5 --and v.GQD_KETQUA IS NULL
         and NVL(v.TrangthaiID,0) not in (13,14,15,16,18);
  OPEN curReturn FOR   
       SELECT TONG_ TONG_ALL FROM DUAL;
END THONGKE_CHUNG;
PROCEDURE THONGKE_TONGHOP
( 
  vToaAnID in number,
  vPhongBanID  in number,
  vLanhdaoVu number,
  vThamTraVien number,
  LoaiAnDB in number,--thuộc án
  curReturn OUT sys_refcursor
)
IS 
       V_CURSOR sys_refcursor; v_table T_THONGKE_TONGHOP;tong_cong_tp VARCHAR2(150);v_table_all T_TINHTRANG;
        -------------------------------
       TONG_ NUMBER;
       --------------------------------
       LOAIAN_ID VARCHAR2(150);LOAIAN_TEN VARCHAR2(150);VUANID NUMBER;LANHDAOID NUMBER;TINHTRANGID NUMBER;NGAYTRA DATE; TOTRINH_ID NUMBER;NGAYTRINH  DATE;ISCAPTRINHTIEP NUMBER;THUTU_CAPTRINH NUMBER;
BEGIN
   v_table := T_THONGKE_TONGHOP();  v_table_all := T_TINHTRANG(); 
 --for item Loai an
   FOR item IN (
    SELECT LA.LOAIAN_ID,LA.LOAIAN_TEN FROM  (
                        SELECT DECODE(TT.COL_LOAIAN,'ISHINHSU',1,'ISDANSU',2,'ISHNGD',3,'ISKDTM',4,'ISLAODONG',5,'ISHANHCHINH',6)LOAIAN_ID,
                        DECODE(TT.COL_LOAIAN,'ISHINHSU','HÌNH SỰ','ISDANSU','DÂN SỰ','ISHNGD','HÔN NHÂN VÀ GIA ĐÌNH','ISKDTM','KINH DOANH, THƯƠNG MẠI','ISLAODONG','LAO ĐỘNG','ISHANHCHINH','HÀNH CHÍNH')LOAIAN_TEN
                        FROM (
                        SELECT * FROM (SELECT PB.ISHINHSU,PB.ISDANSU, PB.ISHNGD, PB.ISKDTM,PB.ISHANHCHINH,PB.ISLAODONG FROM DM_PHONGBAN PB WHERE PB.TOAANID=vToaAnID AND PB.ID=vPhongBanID)
                        UNPIVOT --chuyển từ cột thành dòng
                        (CHECK_LOAIAN for COL_LOAIAN in (ISHINHSU, ISDANSU, ISHNGD, ISKDTM,ISHANHCHINH,ISLAODONG) )
                        )TT WHERE CHECK_LOAIAN=1 -- ORDER BY TO_NUMBER(LOAIAN_ID) DESC
                    )LA 
                    WHERE LA.LOAIAN_ID IS NOT NULL  GROUP BY LA.LOAIAN_ID,LA.LOAIAN_TEN ORDER BY LA.LOAIAN_ID 
       )

   LOOP
       ----------------------------------------tạo du lieu cac cap trinh chuyển vào bảng v_table_ld
                  PKG_GDTTT_BAOCAO_APP.GDTTTT_QLTOTRINH_ALL(
                                  vToaAnID,vPhongBanID,item.LOAIAN_ID,--vToaAnID,vPhongBanID,vLoaiAn
                                  null,sysdate,--tt_tungay,tt_denngay
                                  V_CURSOR);
                  LOOP 
                  FETCH V_CURSOR 
                       INTO   LOAIAN_ID,LOAIAN_TEN,VUANID,LANHDAOID,TINHTRANGID,NGAYTRA,TOTRINH_ID,NGAYTRINH,ISCAPTRINHTIEP,THUTU_CAPTRINH;
                        EXIT WHEN V_CURSOR%NOTFOUND;
                         v_table_all.extend;
                         v_table_all(v_table_all.count) := R_TINHTRANG(
                                     LOAIAN_ID,LOAIAN_TEN,VUANID,LANHDAOID,TINHTRANGID,NGAYTRA,TOTRINH_ID,NGAYTRINH,ISCAPTRINHTIEP,THUTU_CAPTRINH
                                    );
                  END LOOP;    
                  CLOSE V_CURSOR;  
    -------------------------------------------------------------------------------------------------
        --Chưa phân công TTV
         SELECT DECODE(vThamTraVien,0,COUNT(V.ID),0) INTO TONG_ FROM GDTTT_VUAN V 
         WHERE V.TOAANID=VTOAANID AND V.PHONGBANID=VPHONGBANID AND V.LOAIAN=ITEM.LOAIAN_ID 
         AND ((NVL(v.LANHDAOVUID,0)=vLanhdaoVu AND vLanhdaoVu !=0) OR(vLanhdaoVu=0))
         AND (v.THAMTRAVIENID IS NULL AND TRIM(V.TenThamTRaVien) IS NULL) 
         AND NVL(v.GQD_LOAIKETQUA,5) = 5 --and v.GQD_KETQUA IS NULL
         and NVL(v.TrangthaiID,0) not in (13,14,15,16,18)
         and ( LoaiAnDB = 0 -- Thuộc án
                or (LoaiAnDB = 1 
                     AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                  )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                or (LoaiAnDB = 3 AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18) AND v.GQD_LOAIKETQUA IS NULL)
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
         ) ; 
         --
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_TONGHOP(
                            item.LOAIAN_ID,item.LOAIAN_TEN,
                            TONG_,0,0,0,0,0,0,0,0,0,
                            0,0,0,0,0,0,0
                            );   
        --Đã phân công TTV,('Tổng số vụ việc được phân công' khi truyền vThamTraVien vào) 
        SELECT COUNT(V.ID) INTO TONG_ FROM GDTTT_VUAN V 
         WHERE V.TOAANID=VTOAANID AND V.PHONGBANID=VPHONGBANID AND NVL(v.LOAIAN,0)=ITEM.LOAIAN_ID 
         AND ((NVL(v.LANHDAOVUID,0)=vLanhdaoVu AND vLanhdaoVu !=0) OR(vLanhdaoVu=0))
         AND (
               ( v.THAMTRAVIENID=vThamTraVien AND vThamTraVien !=0)
                OR(vThamTraVien=0  AND (v.THAMTRAVIENID IS NOT NULL OR TRIM(V.TenThamTRaVien) IS NOT NULL)  )
              )
        AND NVL(v.GQD_LOAIKETQUA,5) = 5
        and NVL(v.TrangthaiID,0) not in (13,14,15,16,18)
        and ( LoaiAnDB = 0 -- Thuộc án
                or (LoaiAnDB = 1 
                     AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                  )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                or (LoaiAnDB = 3 AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18) AND v.GQD_LOAIKETQUA IS NULL)
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
         ) ; 
         --
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_TONGHOP(
                            item.LOAIAN_ID,item.LOAIAN_TEN,
                            0,TONG_,0,0,0,0,0,0,0,0,
                            0,0,0,0,0,0,0
                            );   
         --Đã có hồ sơ
         SELECT COUNT(V.ID) INTO TONG_ FROM GDTTT_VUAN V 
         WHERE V.TOAANID=VTOAANID AND V.PHONGBANID=VPHONGBANID AND V.LOAIAN=ITEM.LOAIAN_ID 
         AND ((NVL(v.LANHDAOVUID,0)=vLanhdaoVu AND vLanhdaoVu !=0) OR(vLanhdaoVu=0))
         AND (( NVL(v.THAMTRAVIENID,0)=vThamTraVien AND vThamTraVien !=0) OR(vThamTraVien=0))
         AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18))
         and EXISTS (select ID from GDTTT_QUANLYHS where v.ID = VUANID and ( NGAYNHAN is not null or LOAI = 3 ))
         AND NVL(v.GQD_LOAIKETQUA,5) = 5
        and ( LoaiAnDB = 0 -- Thuộc án
                or (LoaiAnDB = 1 
                     AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                  )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                or (LoaiAnDB = 3 AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18) AND v.GQD_LOAIKETQUA IS NULL)
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
         ) ; 
         --
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_TONGHOP(
                            item.LOAIAN_ID,item.LOAIAN_TEN,
                            0,0,TONG_,0,0,0,0,0,0,0,
                            0,0,0,0,0,0,0
                            );            
        --Chưa có hồ sơ
         SELECT COUNT(V.ID) INTO TONG_ FROM GDTTT_VUAN V 
         WHERE V.TOAANID=VTOAANID AND V.PHONGBANID=VPHONGBANID AND V.LOAIAN=ITEM.LOAIAN_ID 
         AND ((NVL(v.LANHDAOVUID,0)=vLanhdaoVu AND vLanhdaoVu !=0) OR(vLanhdaoVu=0))
         AND (( NVL(v.THAMTRAVIENID,0)=vThamTraVien AND vThamTraVien !=0) OR(vThamTraVien=0))
         AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18))
         AND NOT EXISTS (select HS.ID from GDTTT_QUANLYHS HS where v.ID = HS.VUANID and ( HS.NGAYNHAN is not null or HS.LOAI = 3 ) )
         AND  NVL(v.IsHoSo,0)=0 AND NVL(v.GQD_LOAIKETQUA,5) = 5
        and ( LoaiAnDB = 0 -- Thuộc án
                or (LoaiAnDB = 1 
                     AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                  )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                or (LoaiAnDB = 3 AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18) AND v.GQD_LOAIKETQUA IS NULL)
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
         ) ; 
         --
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_TONGHOP(
                            item.LOAIAN_ID,item.LOAIAN_TEN,
                            0,0,0,TONG_,0,0,0,0,0,0,
                            0,0,0,0,0,0,0
                            );    
         --Chưa có tờ trình
         SELECT COUNT(V.ID) INTO TONG_ FROM GDTTT_VUAN V 
         WHERE V.TOAANID=VTOAANID AND V.PHONGBANID=VPHONGBANID AND V.LOAIAN=ITEM.LOAIAN_ID 
         AND ((NVL(v.LANHDAOVUID,0)=vLanhdaoVu AND vLanhdaoVu !=0) OR(vLanhdaoVu=0))
         AND (  ( NVL(v.THAMTRAVIENID,0)=vThamTraVien AND vThamTraVien !=0) 
                OR(vThamTraVien=0 AND NVL(v.ThamTraVienID,0)>0 ) 
            )
        -- AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA WHERE V.ID=PA.VUANID AND PA.TINHTRANGID=3)
         AND (v.THAMTRAVIENID  IS NOT NULL and v.THAMTRAVIENID != 0 and NOT EXISTS(SELECT 'X' FROM GDTTT_TOTRINH WHERE v.ID = VUANID))
         AND  NVL(v.IsHoSo,0)>0 and (NVL(v.ISToTrinh,0)=0) AND NVL(v.GQD_LOAIKETQUA,5) = 5
        and ( LoaiAnDB = 0 -- Thuộc án
                or (LoaiAnDB = 1 
                     AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                  )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                or (LoaiAnDB = 3 AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18) AND v.GQD_LOAIKETQUA IS NULL)
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
         ) ; 
         --
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_TONGHOP(
                            item.LOAIAN_ID,item.LOAIAN_TEN,
                            0,0,0,0,TONG_,0,0,0,0,0,
                            0,0,0,0,0,0,0
                            );            
         --Phó Vụ trưởng
         SELECT COUNT(V.ID) INTO TONG_ FROM GDTTT_VUAN V 
         WHERE V.TOAANID=VTOAANID AND V.PHONGBANID=VPHONGBANID AND V.LOAIAN=ITEM.LOAIAN_ID 
         AND ((NVL(v.LANHDAOVUID,0)=vLanhdaoVu AND vLanhdaoVu !=0) OR(vLanhdaoVu=0))
         AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18))
         AND (( NVL(v.THAMTRAVIENID,0)=vThamTraVien AND vThamTraVien !=0) OR( vThamTraVien=0))
         AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA WHERE V.ID=PA.VUANID AND PA.TINHTRANGID IN (4 ,100))
         --AND EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and TINHTRANGID IN (4 ,100))
         AND NVL(v.GQD_LOAIKETQUA,5) = 5
         and ( LoaiAnDB = 0 -- Thuộc án
                or (LoaiAnDB = 1 
                     AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                  )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                or (LoaiAnDB = 3 AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18) AND v.GQD_LOAIKETQUA IS NULL)
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
         ) ; 
         --
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_TONGHOP(
                            item.LOAIAN_ID,item.LOAIAN_TEN,
                            0,0,0,0,0,TONG_,0,0,0,0,
                            0,0,0,0,0,0,0
                            );   
         --Vụ trưởng-phải sửa lại theo cách khác
         SELECT COUNT(V.ID) INTO TONG_ FROM GDTTT_VUAN V 
         WHERE V.TOAANID=VTOAANID AND V.PHONGBANID=VPHONGBANID AND V.LOAIAN=ITEM.LOAIAN_ID 
         AND ((NVL(v.LANHDAOVUID,0)=vLanhdaoVu AND vLanhdaoVu !=0) OR(vLanhdaoVu=0))
         AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18))
         AND (( NVL(v.THAMTRAVIENID,0)=vThamTraVien AND vThamTraVien !=0) OR( vThamTraVien=0))
         AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA WHERE V.ID=PA.VUANID AND PA.TINHTRANGID IN (5 ,101))
        -- AND EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and TINHTRANGID IN (5 ,101))
         and ( LoaiAnDB = 0 -- Thuộc án
                or (LoaiAnDB = 1 
                     AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                  )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                or (LoaiAnDB = 3 AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18) AND v.GQD_LOAIKETQUA IS NULL)
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
         ) ; 
         --
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_TONGHOP(
                            item.LOAIAN_ID,item.LOAIAN_TEN,
                            0,0,0,0,0,0,TONG_,0,0,0,
                            0,0,0,0,0,0,0
                            );            
         --Trình Thẩm phán Chưa có ý kiến
         SELECT COUNT(V.ID) INTO TONG_ FROM GDTTT_VUAN V 
         WHERE V.TOAANID=VTOAANID AND V.PHONGBANID=VPHONGBANID AND V.LOAIAN=ITEM.LOAIAN_ID 
         AND ((NVL(v.LANHDAOVUID,0)=vLanhdaoVu AND vLanhdaoVu !=0) OR(vLanhdaoVu=0))
         AND (( NVL(v.THAMTRAVIENID,0)=vThamTraVien AND vThamTraVien !=0) OR( vThamTraVien=0))
         --AND EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NULL  and TINHTRANGID = 6)
         AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA WHERE V.ID=PA.VUANID AND PA.TINHTRANGID=6 AND PA.NGAYTRA IS NULL)
         AND v.GQD_LOAIKETQUA IS NULL 
         AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18))
         and ( LoaiAnDB = 0 -- Thuộc án
                or (LoaiAnDB = 1 
                     AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                  )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                or (LoaiAnDB = 3 AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18) AND v.GQD_LOAIKETQUA IS NULL)
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
         ) ; 
         --
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_TONGHOP(
                            item.LOAIAN_ID,item.LOAIAN_TEN,
                            0,0,0,0,0,0,0,TONG_,0,0,
                            0,0,0,0,0,0,0
                            );  
       --Trình Thẩm phán đã có ý kiến
         SELECT COUNT(V.ID) INTO TONG_ FROM GDTTT_VUAN V 
         WHERE V.TOAANID=VTOAANID AND V.PHONGBANID=VPHONGBANID AND V.LOAIAN=ITEM.LOAIAN_ID 
         AND ((NVL(v.LANHDAOVUID,0)=vLanhdaoVu AND vLanhdaoVu !=0) OR(vLanhdaoVu=0))
         AND (( NVL(v.THAMTRAVIENID,0)=vThamTraVien AND vThamTraVien !=0) OR( vThamTraVien=0))
         --AND EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL  and TINHTRANGID = 6)
         AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA WHERE V.ID=PA.VUANID AND PA.TINHTRANGID=6 AND PA.NGAYTRA IS NOT NULL)
         AND NVL(v.GQD_LOAIKETQUA,5) = 5 
         AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18))
         and ( LoaiAnDB = 0 -- Thuộc án
                or (LoaiAnDB = 1 
                     AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                  )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                or (LoaiAnDB = 3 AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18) AND v.GQD_LOAIKETQUA IS NULL)
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
         ) ; 
         --
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_TONGHOP(
                            item.LOAIAN_ID,item.LOAIAN_TEN,
                            0,0,0,0,0,0,0,0,TONG_,0,
                            0,0,0,0,0,0,0
                            );  
         --Xác minh, Bổ sung
         SELECT COUNT(V.ID) INTO TONG_ FROM GDTTT_VUAN V 
         WHERE V.TOAANID=VTOAANID AND V.PHONGBANID=VPHONGBANID AND V.LOAIAN=ITEM.LOAIAN_ID 
         AND ((NVL(v.LANHDAOVUID,0)=vLanhdaoVu AND vLanhdaoVu !=0) OR(vLanhdaoVu=0))
         AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18))
         AND (( NVL(v.THAMTRAVIENID,0)=vThamTraVien AND vThamTraVien !=0) OR( vThamTraVien=0))
         --and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and loaiykien = 10)
           AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA WHERE V.ID=PA.VUANID AND PA.TINHTRANGID=10)
         and ( LoaiAnDB = 0 -- Thuộc án
                or (LoaiAnDB = 1 
                     AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                  )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                or (LoaiAnDB = 3 AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18) AND v.GQD_LOAIKETQUA IS NULL)
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
         ) ;                
           --
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_TONGHOP(
                            item.LOAIAN_ID,item.LOAIAN_TEN,
                            0,0,0,0,0,0,0,0,0,TONG_,
                            0,0,0,0,0,0,0
                            );  
        --Phó CA
         SELECT COUNT(V.ID) INTO TONG_ FROM GDTTT_VUAN V 
         WHERE V.TOAANID=VTOAANID AND V.PHONGBANID=VPHONGBANID AND V.LOAIAN=ITEM.LOAIAN_ID 
         AND ((NVL(v.LANHDAOVUID,0)=vLanhdaoVu AND vLanhdaoVu !=0) OR(vLanhdaoVu=0))
         AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18))
         AND (( NVL(v.THAMTRAVIENID,0)=vThamTraVien AND vThamTraVien !=0) OR( vThamTraVien=0))
        -- AND  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and TINHTRANGID = 7)
         AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA WHERE V.ID=PA.VUANID AND PA.TINHTRANGID=7)
         AND NVL(v.GQD_LOAIKETQUA,5) = 5 
        and ( LoaiAnDB = 0 -- Thuộc án
                or (LoaiAnDB = 1 
                     AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                  )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                or (LoaiAnDB = 3 AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18) AND v.GQD_LOAIKETQUA IS NULL)
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
         ) ;                    
           --
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_TONGHOP(
                            item.LOAIAN_ID,item.LOAIAN_TEN,
                            0,0,0,0,0,0,0,0,0,0,
                            TONG_,0,0,0,0,0,0
                            );       
        --Báo cáo Tổ Thẩm phán
         SELECT COUNT(V.ID) INTO TONG_ FROM GDTTT_VUAN V 
         WHERE V.TOAANID=VTOAANID AND V.PHONGBANID=VPHONGBANID AND V.LOAIAN=ITEM.LOAIAN_ID 
         AND ((NVL(v.LANHDAOVUID,0)=vLanhdaoVu AND vLanhdaoVu !=0) OR(vLanhdaoVu=0))
         AND (( NVL(v.THAMTRAVIENID,0)=vThamTraVien AND vThamTraVien !=0) OR( vThamTraVien=0))
       --  AND EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and TINHTRANGID = 9) 
         AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA WHERE V.ID=PA.VUANID AND PA.TINHTRANGID=9)
         AND ((NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18) AND NVL(v.GQD_LOAIKETQUA,5)= 5) ) 
        and ( LoaiAnDB = 0 -- Thuộc án
                or (LoaiAnDB = 1 
                     AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                  )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                or (LoaiAnDB = 3 AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18) AND v.GQD_LOAIKETQUA IS NULL)
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
         ) ;                 
           --
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_TONGHOP(
                            item.LOAIAN_ID,item.LOAIAN_TEN,
                            0,0,0,0,0,0,0,0,0,0,
                            0,TONG_,0,0,0,0,0
                            ); 
        --Trình Chánh án
         SELECT COUNT(V.ID) INTO TONG_ FROM GDTTT_VUAN V 
         WHERE V.TOAANID=VTOAANID AND V.PHONGBANID=VPHONGBANID AND V.LOAIAN=ITEM.LOAIAN_ID 
         AND ((NVL(v.LANHDAOVUID,0)=vLanhdaoVu AND vLanhdaoVu !=0) OR(vLanhdaoVu=0))
         AND (( NVL(v.THAMTRAVIENID,0)=vThamTraVien AND vThamTraVien !=0) OR( vThamTraVien=0))
         --AND EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and TINHTRANGID = 8) 
         AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA WHERE V.ID=PA.VUANID AND PA.TINHTRANGID=8)
         AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18) 
         AND NVL(v.GQD_LOAIKETQUA,5)= 5) 
        and ( LoaiAnDB = 0 -- Thuộc án
                or (LoaiAnDB = 1 
                     AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                  )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                or (LoaiAnDB = 3 AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18) AND v.GQD_LOAIKETQUA IS NULL)
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
         ) ;                
           --
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_TONGHOP(
                            item.LOAIAN_ID,item.LOAIAN_TEN,
                            0,0,0,0,0,0,0,0,0,0,
                            0,0,TONG_,0,0,0,0
                            );   
         --Báo cáo Hội đồng thẩm phán
         SELECT COUNT(V.ID) INTO TONG_ FROM GDTTT_VUAN V 
         WHERE V.TOAANID=VTOAANID AND V.PHONGBANID=VPHONGBANID AND V.LOAIAN=ITEM.LOAIAN_ID 
         AND ((NVL(v.LANHDAOVUID,0)=vLanhdaoVu AND vLanhdaoVu !=0) OR(vLanhdaoVu=0))
         AND EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and TINHTRANGID = 17) 
         AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18) 
         AND NVL(v.GQD_LOAIKETQUA,5)= 5) 
         and ( LoaiAnDB = 0 -- Thuộc án
                or (LoaiAnDB = 1 
                     AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                  )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                or (LoaiAnDB = 3 AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18) AND v.GQD_LOAIKETQUA IS NULL)
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
         ) ;                
           --
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_TONGHOP(
                            item.LOAIAN_ID,item.LOAIAN_TEN,
                            0,0,0,0,0,0,0,0,0,0,
                            0,0,0,TONG_,0,0,0
                            );  
         --Trình dự thảo trả lời đơn
         SELECT COUNT(V.ID) INTO TONG_ FROM GDTTT_VUAN V 
         WHERE V.TOAANID=VTOAANID AND V.PHONGBANID=VPHONGBANID AND V.LOAIAN=ITEM.LOAIAN_ID 
         AND ((NVL(v.LANHDAOVUID,0)=vLanhdaoVu AND vLanhdaoVu !=0) OR(vLanhdaoVu=0))
         AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18) 
         AND NVL(v.GQD_LOAIKETQUA,5)= 5) 
         AND (( NVL(v.THAMTRAVIENID,0)=vThamTraVien AND vThamTraVien !=0) OR( vThamTraVien=0))
        -- and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID  and TINHTRANGID = 11)
         AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA WHERE V.ID=PA.VUANID AND PA.TINHTRANGID=11)
        and ( LoaiAnDB = 0 -- Thuộc án
                or (LoaiAnDB = 1 
                     AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                  )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                or (LoaiAnDB = 3 AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18) AND v.GQD_LOAIKETQUA IS NULL)
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
         ) ;             
           --
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_TONGHOP(
                            item.LOAIAN_ID,item.LOAIAN_TEN,
                            0,0,0,0,0,0,0,0,0,0,
                            0,0,0,0,TONG_,0,0
                            );
         --Trình dự thảo kháng nghị
         SELECT COUNT(V.ID) INTO TONG_ FROM GDTTT_VUAN V 
         WHERE V.TOAANID=VTOAANID AND V.PHONGBANID=VPHONGBANID AND V.LOAIAN=ITEM.LOAIAN_ID 
         AND ((NVL(v.LANHDAOVUID,0)=vLanhdaoVu AND vLanhdaoVu !=0) OR(vLanhdaoVu=0))
         AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18) 
         AND NVL(v.GQD_LOAIKETQUA,5)= 5) 
         AND (( NVL(v.THAMTRAVIENID,0)=vThamTraVien AND vThamTraVien !=0) OR( vThamTraVien=0))
         AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA WHERE V.ID=PA.VUANID AND PA.TINHTRANGID=12)
         --and NVL(v.TrangthaiID,0)=12
        and ( LoaiAnDB = 0 -- Thuộc án
                or (LoaiAnDB = 1 
                     AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                  )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                or (LoaiAnDB = 3 AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18) AND v.GQD_LOAIKETQUA IS NULL)
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
         ) ;             
           --
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_TONGHOP(
                            item.LOAIAN_ID,item.LOAIAN_TEN,
                            0,0,0,0,0,0,0,0,0,0,
                            0,0,0,0,0,TONG_,0
                            );  
        ----Hoãn Thi Hành án
         SELECT COUNT(V.ID) INTO TONG_ FROM GDTTT_VUAN V 
         WHERE V.TOAANID=VTOAANID AND V.PHONGBANID=VPHONGBANID AND V.LOAIAN=ITEM.LOAIAN_ID 
         AND ((NVL(v.LANHDAOVUID,0)=vLanhdaoVu AND vLanhdaoVu !=0) OR(vLanhdaoVu=0))
         AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18) 
         AND NVL(v.GQD_LOAIKETQUA,5)= 5) 
         AND (( NVL(v.THAMTRAVIENID,0)=vThamTraVien AND vThamTraVien !=0) OR( vThamTraVien=0))
         and v.GQD_ISHOANTHA=1
         and ( LoaiAnDB = 0 -- Thuộc án
                or (LoaiAnDB = 1 
                     AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                  )
                or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                or (LoaiAnDB = 3 AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18) AND v.GQD_LOAIKETQUA IS NULL)
                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90)
         ) ;                    
           --
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_TONGHOP(
                            item.LOAIAN_ID,item.LOAIAN_TEN,
                            0,0,0,0,0,0,0,0,0,0,
                            0,0,0,0,0,0,TONG_
                            );                                             
   END LOOP;
   -- SELECT translate('<span class="tong_cong_tp">TỔNG CỘNG</span>' using char_cs) INTO tong_cong_tp  FROM DUAL;
   -----------------------------------
  OPEN curReturn FOR
   SELECT PP.LoaiAn,PP.TenLoaiAn||'<i> ('||(PP.COLUMN_1+PP.COLUMN_2)||')</i>' TenLoaiAn,PP.COLUMN_1,PP.COLUMN_2,PP.COLUMN_3,PP.COLUMN_4
   ,PP.COLUMN_5,PP.COLUMN_6,PP.COLUMN_7,PP.COLUMN_8,PP.COLUMN_9,PP.COLUMN_10,
   PP.COLUMN_11,PP.COLUMN_12,PP.COLUMN_13,PP.COLUMN_14,PP.COLUMN_15,PP.COLUMN_16,PP.COLUMN_17 FROM 
   (
      SELECT PA.LoaiAn,PA.TenLoaiAn,SUM(PA.COLUMN_1)COLUMN_1,SUM(PA.COLUMN_2)COLUMN_2,SUM(PA.COLUMN_3)COLUMN_3,SUM(PA.COLUMN_4)COLUMN_4
      ,SUM(PA.COLUMN_5)COLUMN_5,SUM(PA.COLUMN_6)COLUMN_6,SUM(PA.COLUMN_7)COLUMN_7,SUM(PA.COLUMN_8)COLUMN_8,SUM(PA.COLUMN_9)COLUMN_9
      ,SUM(PA.COLUMN_10)COLUMN_10,SUM(PA.COLUMN_11)COLUMN_11,SUM(PA.COLUMN_12)COLUMN_12,SUM(PA.COLUMN_13)COLUMN_13,SUM(PA.COLUMN_14)COLUMN_14
      ,SUM(PA.COLUMN_15)COLUMN_15,SUM(PA.COLUMN_16)COLUMN_16,SUM(PA.COLUMN_17)COLUMN_17
      FROM TABLE(v_table) PA
      GROUP BY PA.LoaiAn,PA.TenLoaiAn ORDER BY PA.LoaiAn
  )PP
 UNION ALL
  SELECT NULL LoaiAn,'<span class="tong_cong_tp">TỔNG CỘNG</span> <i>('||(SUM(PA.COLUMN_1)+SUM(PA.COLUMN_2))||')</i>' TenLoaiAn,SUM(PA.COLUMN_1)COLUMN_1,SUM(PA.COLUMN_2)COLUMN_2,SUM(PA.COLUMN_3)COLUMN_3,SUM(PA.COLUMN_4)COLUMN_4
  ,SUM(PA.COLUMN_5)COLUMN_5,SUM(PA.COLUMN_6)COLUMN_6,SUM(PA.COLUMN_7)COLUMN_7,SUM(PA.COLUMN_8)COLUMN_8,SUM(PA.COLUMN_9)COLUMN_9
  ,SUM(PA.COLUMN_10)COLUMN_10,SUM(PA.COLUMN_11)COLUMN_11,SUM(PA.COLUMN_12)COLUMN_12,SUM(PA.COLUMN_13)COLUMN_13,SUM(PA.COLUMN_14)COLUMN_14
  ,SUM(PA.COLUMN_15)COLUMN_15,SUM(PA.COLUMN_16)COLUMN_16,SUM(PA.COLUMN_17)COLUMN_17
  FROM TABLE(v_table) PA GROUP BY NULL;

END THONGKE_TONGHOP;
END PKG_GDTTT_APP;
