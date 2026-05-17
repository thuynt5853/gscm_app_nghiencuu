--------------------------------------------------------
--  DDL for Package Body PKG_GDTTT_VUAN_TEST
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_GDTTT_VUAN_TEST" AS
PROCEDURE THONGKE_THEO_THAMPHAN_JOB
 AS
  ma_chucvu varchar2(10); curr_thamphan_id number; V_CURSOR sys_refcursor;V_SYSDATE DATE;
  -----
  TYPE ARRAY_T IS VARRAY(3) OF NUMBER;
  -- array array_t := array_t(0,1,3);  
  array array_t := array_t(0); 
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
    AND THAMPHANID=364;--1666;--20325;--364;
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
                 AND C.ID=364--1666--20325--364  --20325 ----Nguyễn Thị Hoàng Anh -- AND C.ID=364 - Đặng Xuân đào
                 ------
                 ORDER BY SUBSTR(c.HOTEN,INSTR(c.HOTEN,' ',-1)+ 1)
                )
        LOOP
              FOR year_item IN (SELECT TT.NGAYTAO YEAR_ID,'Năm '||TT.NGAYTAO YEAR_TEN FROM (
                             select EXTRACT(year FROM a.NGAYTAO)NGAYTAO from GDTTT_VUAN a 
                             where a.TOAANID=1 AND a.NGAYTAO IS NOT NULL and ((a.ThamPhanID=tp.THAMPHANID AND tp.THAMPHANID!=0) OR tp.THAMPHANID=0)
                            ------------
                             AND EXTRACT(year FROM a.NGAYTAO) IN (2019,2018,2017) ----lấy 3 năm để test
                            ------------
                             )TT GROUP BY TT.NGAYTAO ORDER BY TT.NGAYTAO DESC
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
END PKG_GDTTT_VUAN_TEST;

/
