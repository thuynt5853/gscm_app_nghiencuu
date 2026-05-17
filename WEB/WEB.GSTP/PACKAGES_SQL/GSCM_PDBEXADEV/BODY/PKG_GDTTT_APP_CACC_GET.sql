--------------------------------------------------------
--  DDL for Package Body PKG_GDTTT_APP_CACC_GET
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_GDTTT_APP_CACC_GET" AS
FUNCTION THONGKE_THEO_THAMPHAN_GET
    (
        VTHAMPHANID_PCA  IN NUMBER,
        VTOAANID IN NUMBER,
        VTHAMPHANID  IN NUMBER,
        VTUNGAY IN DATE,
        VDENNGAY IN DATE,
        VLOAIANDB IN NUMBER,
        VYEARS IN VARCHAR2
    ) 
RETURN SYS_REFCURSOR
    AS  V_CURSOR sys_refcursor;V_CREATE_DATE DATE;v_table T_THONGKE_THAMPHAN;
    V_COUNT_TP NUMBER; V_LOAIAN varchar2(255); V_LOAITOA VARCHAR2(100);V_MA VARCHAR2(100);
    ma_chucvu varchar2(10); 
 BEGIN
          v_table := T_THONGKE_THAMPHAN();
          ----
          SELECT LOAITOA INTO V_LOAITOA FROM DM_TOAAN WHERE ID=VTOAANID;
          IF(V_LOAITOA='TOICAO') THEN
              V_MA:='TPTATC';
          ELSIF(V_LOAITOA='CAPCAO') THEN
              V_MA:='TPCC';  
          END IF;
          ----
           select COUNT(*)INTO V_COUNT_TP from DM_CANBO a
              inner join (select c.ID,c.TEN from DM_DATAITEM c  where c.GROUPID=12 and  instr(','||V_MA||',',','||c.MA||',')>0 ) b on b.ID=a.CHUCDANHID 
              left join (select c.ID,c.TEN from DM_DATAITEM c where c.GROUPID=13) d on d.ID=a.CHUCVUID
              where a.TOAANID=vToaAnID  And a.HIEULUC=1-- AND D.ID=74
              AND A.ID=VTHAMPHANID_PCA;
          ---
            select b.Ma  into ma_chucvu  from DM_CanBo a left join DM_DataItem b on a.ChucVuID = b.ID where a.Id = vThamphanID;  
      ------------    
     IF(V_COUNT_TP=0 OR VTHAMPHANID_PCA=VTHAMPHANID) THEN
          SELECT TT.CREATE_DATE INTO V_CREATE_DATE FROM(
                SELECT TH.CREATE_DATE FROM GDTTT_THONGKE_THAMPHAN TH 
                WHERE 
                (ma_chucvu ='CA' OR TH.THAMPHANID=VTHAMPHANID) AND
                TH.YEAR_BC=VYEARS AND TH.LOAIANDB=VLOAIANDB AND TOAANID=VTOAANID
                ORDER BY TH.CREATE_DATE DESC
          )TT WHERE ROWNUM=1;
         
          ----------------
          IF (ma_chucvu ='CA') THEN
               FOR item IN(
                  SELECT TT.loaian,TT.TENLOAIAN, SUM(COLUMN_1) COLUMN_1, SUM(COLUMN_2) COLUMN_2,SUM(COLUMN_3) COLUMN_3,SUM(COLUMN_4) COLUMN_4
                        ,SUM(COLUMN_5) COLUMN_5,SUM(COLUMN_6) COLUMN_6,SUM(COLUMN_7) COLUMN_7,SUM(COLUMN_8) COLUMN_8,SUM(COLUMN_9) COLUMN_9
                        ,SUM(COLUMN_10) COLUMN_10,SUM(COLUMN_11) COLUMN_11,SUM(COLUMN_12) COLUMN_12,SUM(COLUMN_13) COLUMN_13,SUM(COLUMN_14) COLUMN_14
                        ,SUM(COLUMN_15) COLUMN_15,SUM(COLUMN_16) COLUMN_16,SUM(COLUMN_17) COLUMN_17,SUM(COLUMN_18) COLUMN_18,SUM(COLUMN_19) COLUMN_19
                        ,SUM(COLUMN_20) COLUMN_20,SUM(COLUMN_21) COLUMN_21,SUM(COLUMN_22) COLUMN_22,SUM(COLUMN_23) COLUMN_23,SUM(COLUMN_24) COLUMN_24
                        ,SUM(COLUMN_25) COLUMN_25  FROM  GDTTT_THONGKE_THAMPHAN TT 
                  WHERE 
                  TT.YEAR_BC=VYEARS AND TOAANID=VTOAANID
                  AND TT.LOAIANDB=VLOAIANDB AND CREATE_DATE=V_CREATE_DATE   
                  AND TT.TENLOAIAN IS NOT NULL
                  AND TT.THAMPHANID not in (2115,5318,5066,1666,40599)
                  group by TT.loaian,TT.TENLOAIAN
                  )
                 LOOP
                     v_table.extend;--chuyen vao bang dinh nghia
                     v_table(v_table.count) := R_THONGKE_THAMPHAN(
                                item.LOAIAN,item.TENLOAIAN,
                                item.COLUMN_1,item.COLUMN_2,item.COLUMN_3,item.COLUMN_4,item.COLUMN_5,item.COLUMN_6,--dòng dâu tiên có 6 giá trị do thêm cột cũ còn lại
                                item.COLUMN_7,item.COLUMN_8,item.COLUMN_9,item.COLUMN_10,item.COLUMN_11,--5 giá trị
                                 item.COLUMN_12,item.COLUMN_13,item.COLUMN_14,item.COLUMN_15,item.COLUMN_16,--5 giá trị
                                 item.COLUMN_17,item.COLUMN_18,item.COLUMN_19,item.COLUMN_20,item.COLUMN_21,--5 giá trị
                                 item.COLUMN_22,item.COLUMN_23,item.COLUMN_24,item.COLUMN_25--4 giá trị
                                );
                 END LOOP;
             ELSE 
                 FOR item IN(
                      SELECT TT.* FROM  GDTTT_THONGKE_THAMPHAN TT 
                      WHERE 
                      TT.THAMPHANID=VTHAMPHANID AND 
                      TT.YEAR_BC=VYEARS AND TOAANID=VTOAANID
                      AND TT.LOAIANDB=VLOAIANDB AND CREATE_DATE=V_CREATE_DATE
                      
                      )
                     LOOP
                         v_table.extend;--chuyen vao bang dinh nghia
                         v_table(v_table.count) := R_THONGKE_THAMPHAN(
                                    item.LOAIAN,item.TENLOAIAN,
                                    item.COLUMN_1,item.COLUMN_2,item.COLUMN_3,item.COLUMN_4,item.COLUMN_5,item.COLUMN_6,--dòng dâu tiên có 6 giá trị do thêm cột cũ còn lại
                                    item.COLUMN_7,item.COLUMN_8,item.COLUMN_9,item.COLUMN_10,item.COLUMN_11,--5 giá trị
                                     item.COLUMN_12,item.COLUMN_13,item.COLUMN_14,item.COLUMN_15,item.COLUMN_16,--5 giá trị
                                     item.COLUMN_17,item.COLUMN_18,item.COLUMN_19,item.COLUMN_20,item.COLUMN_21,--5 giá trị
                                     item.COLUMN_22,item.COLUMN_23,item.COLUMN_24,item.COLUMN_25--4 giá trị
                                    );
                     END LOOP;
             END IF;
         ELSIF(V_COUNT_TP>0)THEN
           Select replace(DECODE(c.ISHINHSU,1,','||1||',','')||DECODE(c.ISDANSU,1,','||2||',','')|| DECODE(c.ISHNGD,1,','||3||',','')||DECODE(c.ISKDTM,1,','||4||',','')||DECODE(c.ISHANHCHINH,1,','||6||',','')||DECODE(c.ISLAODONG,1,','||5||',',''),',,',',')
           INTO V_LOAIAN From DM_CANBO c where c.id=VTHAMPHANID_PCA;
           ----
            SELECT TT.CREATE_DATE INTO V_CREATE_DATE FROM (
                SELECT TH.CREATE_DATE FROM GDTTT_THONGKE_THAMPHAN TH 
                WHERE TH.THAMPHANID=VTHAMPHANID AND TH.YEAR_BC=VYEARS AND TH.LOAIANDB=VLOAIANDB
                AND  instr(V_LOAIAN,','||TH.LOAIAN||',')>0 
                ORDER BY TH.CREATE_DATE DESC
          )TT WHERE ROWNUM=1;
        ---------------------
           FOR item IN (
              SELECT TT.* FROM  GDTTT_THONGKE_THAMPHAN TT 
              WHERE TT.THAMPHANID=VTHAMPHANID AND TT.YEAR_BC=VYEARS AND TT.LOAIANDB=VLOAIANDB AND CREATE_DATE=V_CREATE_DATE
              AND  instr(V_LOAIAN,','||TT.LOAIAN||',')>0 
              ORDER BY TT.LOAIAN 
           )
           LOOP
               v_table.extend;--chuyen vao bang dinh nghia
                 v_table(v_table.count) := R_THONGKE_THAMPHAN(
                            item.LOAIAN,item.TENLOAIAN,
                            item.COLUMN_1,item.COLUMN_2,item.COLUMN_3,item.COLUMN_4,item.COLUMN_5,item.COLUMN_6,--dòng dâu tiên có 6 giá trị do thêm cột cũ còn lại
                            item.COLUMN_7,item.COLUMN_8,item.COLUMN_9,item.COLUMN_10,item.COLUMN_11,--5 giá trị
                             item.COLUMN_12,item.COLUMN_13,item.COLUMN_14,item.COLUMN_15,item.COLUMN_16,--5 giá trị
                             item.COLUMN_17,item.COLUMN_18,item.COLUMN_19,item.COLUMN_20,item.COLUMN_21,--5 giá trị
                             item.COLUMN_22,item.COLUMN_23,item.COLUMN_24,item.COLUMN_25--4 giá trị
                            );
           END LOOP;    
        FOR item IN (  
           SELECT '<span class="tong_cong_tp">TỔNG CỘNG</span>' TENLOAIAN,SUM(PA.COLUMN_1)COLUMN_1,SUM(PA.COLUMN_2)COLUMN_2,SUM(PA.COLUMN_3)COLUMN_3,SUM(PA.COLUMN_4)COLUMN_4
          ,SUM(PA.COLUMN_5)COLUMN_5,SUM(PA.COLUMN_6)COLUMN_6,SUM(PA.COLUMN_7)COLUMN_7,SUM(PA.COLUMN_8)COLUMN_8,SUM(PA.COLUMN_9)COLUMN_9
          ,SUM(PA.COLUMN_10)COLUMN_10,SUM(PA.COLUMN_11)COLUMN_11,SUM(PA.COLUMN_12)COLUMN_12,SUM(PA.COLUMN_13)COLUMN_13,SUM(PA.COLUMN_14)COLUMN_14
          ,SUM(PA.COLUMN_15)COLUMN_15,SUM(PA.COLUMN_16)COLUMN_16,SUM(PA.COLUMN_17)COLUMN_17,SUM(PA.COLUMN_18)COLUMN_18,SUM(PA.COLUMN_19)COLUMN_19
          ,SUM(PA.COLUMN_20)COLUMN_20,SUM(PA.COLUMN_21)COLUMN_21,SUM(PA.COLUMN_22)COLUMN_22,SUM(PA.COLUMN_23)COLUMN_23,SUM(PA.COLUMN_24)COLUMN_24,SUM(PA.COLUMN_25)COLUMN_25
          FROM TABLE(v_table) PA GROUP BY NULL
          )
          LOOP
               v_table.extend;--chuyen vao bang dinh nghia
                 v_table(v_table.count) := R_THONGKE_THAMPHAN(
                            NULL,item.TENLOAIAN,
                            item.COLUMN_1,item.COLUMN_2,item.COLUMN_3,item.COLUMN_4,item.COLUMN_5,item.COLUMN_6,--dòng dâu tiên có 6 giá trị do thêm cột cũ còn lại
                            item.COLUMN_7,item.COLUMN_8,item.COLUMN_9,item.COLUMN_10,item.COLUMN_11,--5 giá trị
                             item.COLUMN_12,item.COLUMN_13,item.COLUMN_14,item.COLUMN_15,item.COLUMN_16,--5 giá trị
                             item.COLUMN_17,item.COLUMN_18,item.COLUMN_19,item.COLUMN_20,item.COLUMN_21,--5 giá trị
                             item.COLUMN_22,item.COLUMN_23,item.COLUMN_24,item.COLUMN_25--4 giá trị
                            );
          END LOOP;
     END IF;
      ------------
        OPEN V_CURSOR FOR 
--        SELECT V_THAMPHANID_PCA V_THAMPHANID_PCAS FROM DUAL;
        SELECT PA.* FROM  TABLE(v_table) PA 
        ORDER BY PA.LOAIAN;
       -------------
       RETURN V_CURSOR;     
      --
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
      RETURN null;
 END THONGKE_THEO_THAMPHAN_GET; 
 PROCEDURE SOTHAM_CA
(
    V_CAPXX in varchar2,
    V_TOAAN_ID in varchar2,
    curReturn OUT sys_refcursor
)
IS 
BEGIN
    OPEN curReturn FOR 
    SELECT LA.* FROM DM_LOAIAN LA WHERE LA.ID!=7;
END SOTHAM_CA;
 PROCEDURE PHUCTHAM_CA
(
    V_CAPXX in varchar2,
    V_TOAAN_ID in varchar2,
    curReturn OUT sys_refcursor
)
IS 
BEGIN
    OPEN curReturn FOR 
    SELECT LA.* FROM DM_LOAIAN LA WHERE LA.ID!=7;
END PHUCTHAM_CA;
END PKG_GDTTT_APP_CACC_GET;

/
