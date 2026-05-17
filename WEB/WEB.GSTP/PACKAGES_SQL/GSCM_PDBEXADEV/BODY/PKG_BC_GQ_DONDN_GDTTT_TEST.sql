--------------------------------------------------------
--  DDL for Package Body PKG_BC_GQ_DONDN_GDTTT_TEST
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_BC_GQ_DONDN_GDTTT_TEST" AS
PROCEDURE THONGKE_THEO_THAMPHAN_JOB
 AS
  ma_chucvu varchar2(10); curr_thamphan_id number; V_CURSOR sys_refcursor;V_SYSDATE DATE;
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
    WHERE CREATE_DATE<=SYSDATE-2
    AND THAMPHANID=1944;--1418;--20325;--364;
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
                 inner join (select i.ID, i.TEN from DM_DATAITEM i where i.MA ='TPTATC' and i.GROUPID=12 ) d1 on d1.ID=c.CHUCDANHID  
                 left join (select ii.ID,ii.MA,ii.TEN from DM_DATAITEM ii where ii.GROUPID=13)d on d.ID=c.CHUCVUID
                 WHere c.TOAANID=1 and c.HieuLuc=1 and (c.MaDongBo is not null or Length(NVL(c.Madongbo,''))>0)
                 ------
                 AND C.ID=1944--1418--20325--364 ----Nguyễn Thị Hoàng Anh -- AND C.ID=364 - Đặng Xuân đào
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
                                COLUMN_17,COLUMN_18,COLUMN_19,COLUMN_20,COLUMN_21,COLUMN_22,COLUMN_23,COLUMN_24,COLUMN_25,CREATE_DATE)
                        values 
                        (LoaiAn,TenLoaiAn,year_item.YEAR_ID,tp.ID,array(I),
                                COLUMN_1,COLUMN_2,COLUMN_3,COLUMN_4,COLUMN_5,COLUMN_6,COLUMN_7,COLUMN_8,
                                COLUMN_9,COLUMN_10,COLUMN_11,COLUMN_12,COLUMN_13,COLUMN_14,COLUMN_15,COLUMN_16,
                                COLUMN_17,COLUMN_18,COLUMN_19,COLUMN_20,COLUMN_21,COLUMN_22,COLUMN_23,COLUMN_24,COLUMN_25,V_SYSDATE);
                       COMMIT;          
                   END LOOP;
                  CLOSE V_CURSOR;
              ---------------
            END LOOP;
         END LOOP;
    END LOOP;
END THONGKE_THEO_THAMPHAN_JOB;
FUNCTION GDTTTT_QLTOTRINH_TP
( 
  vThamphanID in number,
  vToaAnID in number,
  vPhongBanID  in number,
  vLoaiAn in number,
  tt_tungay in date,
  tt_denngay in date
)RETURN  T_TINHTRANG
IS 
         v_table T_TINHTRANG;V_THUTU NUMBER;ma_chucvu varchar2(10); curr_thamphan_id number;
BEGIN
         v_table := T_TINHTRANG(); 
         ------------------------
    select b.Ma  into ma_chucvu  from DM_CanBo a left join DM_DataItem b on a.ChucVuID = b.ID where a.Id = vThamphanID;
    curr_thamphan_id:=0; 
       if  (ma_chucvu is null)then 
            curr_thamphan_id:= vThamphanID;
        elsif(ma_chucvu='PCA' OR ma_chucvu='CA')then  
         curr_thamphan_id:=0; 
        ELSE
            curr_thamphan_id:= vThamphanID;
        end if;
          --------------------------------
 FOR item_vuan IN (
            SELECT ROW_NUMBER() OVER (ORDER BY v.ID DESC) Row_, COUNT(*) OVER () TotalRecord,MM.LOAIAN_TEN,V.* from GDTTT_VUAN v 
            INNER JOIN (
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
                             UNION ALL
                                        select  LAS.LOAIAN_ID,LAS.LOAIAN_TEN FROM(
                                        select V.LOAIAN LOAIAN_ID,DECODE(V.LOAIAN,1,'HÌNH SỰ',2,'DÂN SỰ',3,'HÔN NHÂN VÀ GIA ĐÌNH',4,'KINH DOANH, THƯƠNG MẠI',5,'LAO ĐỘNG',6,'HÀNH CHÍNH')LOAIAN_TEN From GDTTT_VUAN v 
                                        where v.THAMPHANID=vThamphanID AND V.LOAIAN IS NOT NULL
                                        group by V.LOAIAN
                                       )LAS 
                           )TT  GROUP BY TT.LOAIAN_ID,TT.LOAIAN_TEN  ORDER BY TT.LOAIAN_ID
                  )MM ON MM.LOAIAN_ID=V.LOAIAN
                  LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                      WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                      WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                      END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                    where v.TOAANID=vToaAnID and ((v.PhongBanID=vPhongBanID AND vPhongBanID!=0) OR vPhongBanID =0)
                    AND EXISTS (SELECT 'x' FROM GDTTT_TOTRINH DT WHERE DT.VUANID=V.ID AND ((DT.LANHDAOID=curr_thamphan_id and curr_thamphan_id!=0) OR curr_thamphan_id=0))
                    AND (v.LOAIAN=vLoaiAn OR (vLoaiAn IS NULL OR vLoaiAn=0) ) 
                    and (v.GQD_LOAIKETQUA is null OR (v.GQD_LOAIKETQUA IS NOT NULL AND VA.GQD_NGACVS>=tt_denngay) )
                    AND v.NGAYTAO<=tt_denngay
             )
       LOOP
               FOR item_tt IN (
                        SELECT TT1.* FROM (
                            SELECT TT.*,TR.THUTU FROM GDTTT_TOTRINH TT 
                             INNER JOIN GDTTT_DM_TINHTRANG TR ON TT.TINHTRANGID=TR.ID
                              WHERE TT.VUANID=item_vuan.ID
                             ORDER BY TT.NGAYTRINH DESC,TR.THUTU  DESC
                         )TT1 WHERE ROWNUM=1
                   )
             LOOP
             --if(item_tt.TINHTRANGID =7 or item_tt.TINHTRANGID =8 or item_tt.TINHTRANGID =9 or item_tt.TINHTRANGID =17  ) then
                 IF(item_tt.CAPTRINHTIEP IS NOT NULL AND item_tt.CAPTRINHTIEP !=0) THEN--AND item_tt.TINHTRANGID >=6 
                         SELECT TR.ID INTO V_THUTU FROM GDTTT_DM_TINHTRANG TR WHERE TR.ID=item_tt.CAPTRINHTIEP;
                        v_table.extend;
                        v_table(v_table.count) := R_TINHTRANG(
                        item_vuan.LOAIAN,item_vuan.LOAIAN_TEN,
                        item_tt.VUANID,item_tt.TRINHTIEP_LANHDAO_ID,item_tt.CAPTRINHTIEP,item_tt.NGAYTRA,item_tt.ID,item_tt.NGAYTRINH,1,V_THUTU --1 ton tai cap trinh tiep sử dụng lại giá trị LOAI_THANG thành Trạng thái của cấp trình
                        );
                  ELSE
                        IF(item_tt.LOAIYKIEN=10)THEN --Nghiên cứu lại, xác minh, bổ sung
                            v_table.extend;
                            v_table(v_table.count) := R_TINHTRANG(
                            item_vuan.LOAIAN,item_vuan.LOAIAN_TEN,
                            item_tt.VUANID,item_tt.LANHDAOID,10,item_tt.NGAYTRA,item_tt.ID,item_tt.NGAYTRINH,0,item_tt.THUTU
                            );
                         ELSE
                            v_table.extend;
                            v_table(v_table.count) := R_TINHTRANG(
                            item_vuan.LOAIAN,item_vuan.LOAIAN_TEN,
                            item_tt.VUANID,item_tt.LANHDAOID,item_tt.TINHTRANGID,item_tt.NGAYTRA,item_tt.ID,item_tt.NGAYTRINH,0,item_tt.THUTU
                            );
                         END IF;
                 END IF;
            -- end if;
            END LOOP;
 END LOOP;
  RETURN V_TABLE;
--       OPEN curReturn FOR
--      SELECT PA.* FROM  table(V_TABLE) PA ;
--     SELECT count(*) FROM  table(V_TABLE) PA  WHERE PA.TINHTRANGID IN(7,8,9,17);
-- SELECT pa.* FROM TABLE(V_TABLE) PA 
--                INNER JOIN GDTTT_VUAN V ON V.ID=PA.VUANID
--                WHERE instr(',7,8,9,17,',','||PA.TINHTRANGID||',')>0 
--                and v.NGAYTAO<sysdate
--                AND NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16);
END GDTTTT_QLTOTRINH_TP;
END PKG_BC_GQ_DONDN_GDTTT_TEST;

/
