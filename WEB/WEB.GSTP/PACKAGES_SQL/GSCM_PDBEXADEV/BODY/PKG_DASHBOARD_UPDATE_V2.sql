--------------------------------------------------------
--  DDL for Package Body PKG_DASHBOARD_UPDATE_V2
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_DASHBOARD_UPDATE_V2" AS

PROCEDURE        DASHBOARD_GET_DANHSACH_TOAAN
( DONVIID IN NUMBER,
	CURRETURN    OUT       SYS_REFCURSOR
)
IS 
    VAR_ARRSX  NVARCHAR2(250);
BEGIN

    IF DONVIID>0 THEN
        SELECT T.ARRSAPXEP INTO VAR_ARRSX FROM DM_TOAAN T WHERE T.ID=DONVIID;
    ELSE
        VAR_ARRSX:='0';
    END IF;

    OPEN CURRETURN FOR 
        SELECT T.ID, CASE T.SOCAP WHEN 4 THEN '-- ' ELSE '' END || T.MA_TEN AS TENDONVI
        FROM DM_TOAAN T
        WHERE T.HIEULUC = 1 AND (T.ARRSAPXEP LIKE (VAR_ARRSX ||'/%') OR T.ARRSAPXEP=VAR_ARRSX )
        ORDER BY T.ARRTHUTU;

END DASHBOARD_GET_DANHSACH_TOAAN;

PROCEDURE DASHBOARD_M1_TPTATC
(  
    vToaAnID	in	VARCHAR2,
    vThamphanid in number,
    vTuNgay	in VARCHAR2,
    vDenNgay	in VARCHAR2,
    curReturn OUT sys_refcursor 
)
AS
    v_TIME_FROM VARCHAR2(50);v_TIME_TO VARCHAR2(50);  
    V_TABLE T_DASHBOARD_THAMPHAN;
    V_TABLE_ALL T_DASHBOARD_THAMPHAN;
    vvToaAnID NUMBER;
    vCursur sys_refcursor;

    vCheck number;

BEGIN
    v_table := T_DASHBOARD_THAMPHAN();
    V_TABLE_ALL := T_DASHBOARD_THAMPHAN();

    v_TIME_FROM:=to_date(trim(vTuNgay)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');
    v_TIME_TO:=to_date(trim(vDenNgay)||' 23:59:59','dd/MM/yyyy HH24:MI:SS');

               ----COLUMN_1------- cũ còn lại----------
               FOR item IN (

                SELECT C.THAMPHANID,count(C.id) colnum_2
                         FROM (
                                 SELECT d.THAMPHANID,d.ID 
                                          FROM GDTTT_DON d 
                                          where 
                                          NVL(d.LOAIDON,0) NOT IN(4)
                                          AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                          AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                          AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                          AND D.ISTHULY = 1 
                                           AND d.CD_LOAI = 0
                                          AND  d.TL_NGAY < v_TIME_FROM                            
                                                 and ((d.BAQD_LOAIAN != 1 AND (  EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON DKQ   
                                                                    LEFT JOIN GDTTT_VUAN_KETQUA KQ ON DKQ.VUAN_KETQUA_ID = KQ.ID
                                                                    WHERE DKQ.DONID = D.ID
                                                                            AND DKQ.TRANGTHAI = 1
                                                                            AND KQ.GDQ_NGAY >= v_TIME_FROM)
                                                                           
                                                                            or
                                                                                not EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA DKQ   
                                                                                                        LEFT JOIN GDTTT_VUAN_KETQUA_DON KQ ON DKQ.ID = KQ.VUAN_KETQUA_ID
                                                                                                        WHERE KQ.DONID = D.ID)
                                                                             )
                                                                            )
                                                        or (d.BAQD_LOAIAN != 1 AND NOT EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON DKQ  
                                                                                                        WHERE DKQ.DONID = D.ID 
                                                                                                        AND DKQ.TRANGTHAI = 1))            
                                                         or (d.BAQD_LOAIAN = 1  AND NOT EXISTS(SELECT 'X' FROM GDTTT_VUAN v 
                                                                               WHERE v.ID = D.vuviecid and v.gqd_loaiketqua in (0,1,2,3,4))  )  
                                                         OR (d.BAQD_LOAIAN = 1  AND EXISTS(SELECT 'X' FROM GDTTT_VUAN v 
                                                                               WHERE v.ID = D.vuviecid and v.gqd_loaiketqua in (0,1,2,3,4)
                                                                                                        and v.GDQ_NGAY >= v_TIME_FROM)  )                      
                                                                    )
                                        AND d.id !=319292
                                    )C

                                GROUP BY  C.THAMPHANID

                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_DASHBOARD_THAMPHAN(
                        0,item.THAMPHANID,
                        item.colnum_2,0,0,0,0,0,0,0,
                        0,0
                        );   
                END LOOP;

               ----COLUMN_2-------Mới thụ lý----------
               FOR item IN (

                SELECT C.THAMPHANID,count(C.id) colnum_2
                         FROM (
                                SELECT d.THAMPHANID,d.ID 
                                          FROM GDTTT_DON d 
                                          where 
                                          NVL(d.LOAIDON,0) NOT IN(4)
                                          AND d.ngaytao>= to_Date('01/01/2024','dd/MM/yyyy')
                                          AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                          AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                          AND D.ISTHULY = 1  
                                          AND d.CD_LOAI = 0
                                          AND d.TL_NGAY between v_TIME_FROM and v_TIME_TO
                                    )C

                                GROUP BY  C.THAMPHANID

                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_DASHBOARD_THAMPHAN(
                        0,item.THAMPHANID,0,
                        item.colnum_2,0,0,0,0,0,0,
                        0,0
                        );   
                END LOOP;


                ------COLUMN_3 Đã giải quyết xong
                FOR item IN ( SELECT d.THAMPHANID,count(D.id) colnum_3
                                  FROM GDTTT_DON d 
                                  where 
                                  NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao > to_Date('01/01/2024','dd/MM/yyyy')
                                  AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                  AND D.ISTHULY = 1
                                   AND d.CD_LOAI = 0
                                  AND( (d.BAQD_LOAIAN != 1 and  EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON DKQ   
                                                            LEFT JOIN GDTTT_VUAN_KETQUA KQ ON DKQ.VUAN_KETQUA_ID = KQ.ID
                                                            WHERE DKQ.DONID = D.ID 
                                                                AND DKQ.TRANGTHAI = 1
                                                                AND KQ.GDQ_NGAY between v_TIME_FROM and v_TIME_TO))

                                  OR (d.BAQD_LOAIAN  = 1 and ( EXISTS(SELECT 'X' FROM GDTTT_VUAN v 
                                                                                                        WHERE v.ID = D.vuviecid 
                                                                                                            and v.gqd_loaiketqua in (2,3,4) 
                                                                                                            and v.GDQ_NGAY between v_TIME_FROM and v_TIME_TO) ---XEP DON
                                                                               OR  EXISTS(SELECT 'X' FROM GDTTT_DON_TRALOI kqd 
                                                                                                        WHERE kqd.DONID = D.ID 
                                                                                                            and kqd.TYPETB in (3,4)
                                                                                                            and kqd.NGAY between v_TIME_FROM and v_TIME_TO 
                                                                                                            )    --TLD;KN                    
                                                                                )                                                                                            
                                                    )                                                                      
                                  )

                                  GROUP BY  d.THAMPHANID
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_DASHBOARD_THAMPHAN(
                        0,item.THAMPHANID,0,
                        0,item.colnum_3,0,0,0,0,0,
                        0,0
                        );   
                END LOOP;

                -- ----COLUMN_7-----------------
               FOR item IN (
                    SELECT C.THAMPHANID,count(C.id) colnum_7
                              FROM(
                                SELECT d.THAMPHANID,d.ID
                                   FROM GDTTT_DON d 
                                    LEFT JOIN GDTTT_VUAN_KETQUA_DON DKQ ON DKQ.DONID = D.ID AND DKQ.TRANGTHAI = 1
                                    LEFT JOIN GDTTT_VUAN_KETQUA KQ ON DKQ.VUAN_KETQUA_ID = KQ.ID
                                  where 
                                  NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                  AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                  AND D.ISTHULY = 1
                                   AND d.CD_LOAI = 0
                                  AND d.TL_NGAY <= v_TIME_TO 
                                  AND d.BAQD_LOAIAN != 1 
                                  and (KQ.gqd_loaiketqua IS NULL OR KQ.GDQ_NGAY > v_TIME_TO)
                                 UNION
                               SELECT d.THAMPHANID,d.ID
                                  FROM GDTTT_DON d 
                                  LEFT JOIN GDTTT_VUAN V ON V.ID = D.VUVIECID
                                  where 
                                  NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                  AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                  AND D.ISTHULY = 1
                                   AND d.CD_LOAI = 0
                                  AND d.TL_NGAY <= v_TIME_TO 
                                  AND d.BAQD_LOAIAN = 1              
                                  and ( v.gqd_loaiketqua IS NULL 
                                        OR  v.GDQ_NGAY > v_TIME_TO
                                        )   
                                 )C

                                  GROUP BY C.THAMPHANID   

                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_DASHBOARD_THAMPHAN(
                        0,item.THAMPHANID,0,
                        0,0,item.colnum_7,0,0,0,0,
                        0,0
                        );   
                END LOOP;

                ----COLUMN_8-----------------Tong phải xet xu
              FOR item IN (select c.THAMPHANID, count(c.id) colnum_8 
                                from(
                                    SELECT d.toaanid,d.id
                                           ,d.THAMPHANID
                                             FROM GDTTT_VUAN d  
                                      where 
                                      d.toaanid = vToaAnID --sau se truyen don vi vao
                                       AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)  
                                       AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                      AND (d.NGAYTHULYXXGDT between v_TIME_FROM and v_TIME_TO
                                           OR  (d.NGAYTHULYXXGDT < v_TIME_FROM and (d.XXGDTTT_NGAYQD is null OR to_char(d.XXGDTTT_NGAYQD,'dd/MM/yyyy') = '01/01/0001' ) )
                                           OR  (d.NGAYTHULYXXGDT < v_TIME_FROM and d.XXGDTTT_NGAYQD is not null and to_char(d.XXGDTTT_NGAYQD,'dd/MM/yyyy') != '01/01/0001' and d.XXGDTTT_NGAYQD >= v_TIME_FROM))     
                                      AND d.THAMQUYENXXGDT = 1
                                      AND d.NGAYTHULYXXGDT is not null
                                      )C
                                    group by c.THAMPHANID
                                  )
                LOOP
                         v_table.extend;
                        v_table(v_table.count) := R_DASHBOARD_THAMPHAN(
                        0,item.THAMPHANID,0,
                        0,0,0,item.colnum_8,0,0,0
                        ,0,0
                        );   
                END LOOP;


--                ----COLUMN_11-----------------Đã  xét xử gdtt
              FOR item IN (                                     
                      select c.THAMPHANID, count(c.id) colnum_11
                                from(
                                    SELECT d.toaanid,d.id
                                           ,d.THAMPHANID
                                             FROM GDTTT_VUAN d  
                                      where 
                                      d.toaanid = vToaAnID --sau se truyen don vi vao
                                       AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)  
                                       AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                      --AND  EXISTS(select 'X' from gdttt_vuan_xetxugdttt kq where d.ID = kq.VUANID and NVL(kq.ishoan,0) = 0 and kq.NGAYMOPT between v_TIME_FROM and v_TIME_TO )
                                      AND ( d.XXGDTTT_NGAYQD between v_TIME_FROM and v_TIME_TO 
                                            OR d.ISRUTKN = 1)
                                      AND d.THAMQUYENXXGDT = 1
                                       AND d.NGAYTHULYXXGDT is not null
                                      --GROUP BY  d.toaanid,d.id,d.LOAIAN
                                      )C
                                    group by c.THAMPHANID       

                                  )
                LOOP
                         v_table.extend;
                        v_table(v_table.count) := R_DASHBOARD_THAMPHAN(
                        0,item.THAMPHANID,0,
                        0,0,0,0, item.colnum_11,0,0,0,0
                        );   
                END LOOP;                
 --                ----COLUMN_12-----------------Chua xét xử gdtt
              FOR item IN (     
                         select c.THAMPHANID, count(c.id) colnum_12
                                from(
                                    SELECT d.toaanid,d.id
                                           ,d.THAMPHANID
                                             FROM GDTTT_VUAN d  
                                      where 
                                      d.toaanid = vToaAnID --sau se truyen don vi vao
                                       AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)   
                                       AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                      AND (d.NGAYTHULYXXGDT between v_TIME_FROM and v_TIME_TO
                                           OR  (d.NGAYTHULYXXGDT < v_TIME_FROM and (d.XXGDTTT_NGAYQD is null OR to_char(d.XXGDTTT_NGAYQD,'dd/MM/yyyy') = '01/01/0001' ) )
                                           OR  (d.NGAYTHULYXXGDT < v_TIME_FROM and d.XXGDTTT_NGAYQD is not null and to_char(d.XXGDTTT_NGAYQD,'dd/MM/yyyy') != '01/01/0001' and d.XXGDTTT_NGAYQD >= v_TIME_FROM))     
                                      AND (NVL(d.ISRUTKN,0) = 0 ) 
                                      AND (d.XXGDTTT_NGAYQD is null OR to_char(d.XXGDTTT_NGAYQD,'dd/MM/yyyy') = '01/01/0001' ) 
                                       AND d.NGAYTHULYXXGDT is not null
                                      AND d.THAMQUYENXXGDT = 1
                                      --GROUP BY  d.toaanid,d.id,d.LOAIAN
                                      )C
                                    group by c.THAMPHANID               


                                  )
                LOOP
                         v_table.extend;
                        v_table(v_table.count) := R_DASHBOARD_THAMPHAN(
                        0,item.THAMPHANID,0,
                        0,0,0,0,0,item.colnum_12,0,0
                        ,0
                        );   
                END LOOP;               

                FOR itemdv IN (SELECT   
                                        LA.HOTEN THAMPHAN_HOTEN,
                                        LA.ID THAMPHANID,
                                        sum(tk.COLUMN_1) COLUMN_1,sum(tk.COLUMN_2) COLUMN_2,
                                        sum(tk.COLUMN_3) COLUMN_3,sum(tk.COLUMN_4) COLUMN_4,
                                        sum(tk.COLUMN_5) COLUMN_5,sum(tk.COLUMN_6) COLUMN_6,
                                        sum(tk.COLUMN_7) COLUMN_7,sum(tk.COLUMN_8) COLUMN_8,
                                        sum(tk.COLUMN_9) COLUMN_9,sum(tk.COLUMN_10) COLUMN_10
                                                  FROM table(v_table) tk 
                                                   INNER JOIN (SELECT LA.HOTEN, LA.ID FROM DM_CANBO LA 
                                                                LEFT JOIN DM_DATAITEM CD ON CD.ID = LA.CHUCDANHID AND CD.MA LIKE 'TPTATC'
                                                                WHERE LA.HIEULUC = 1 AND LA.CHUCVUID IS NULL
                                                                ) LA ON LA.ID= tk.THAMPHANID 
                                                        group by LA.HOTEN, LA.ID--,la.loai_an_ten 
                                                                ORDER BY LA.HOTEN

                                    )

                LOOP

                        V_TABLE_ALL.extend;
                        V_TABLE_ALL(V_TABLE_ALL.count) := R_DASHBOARD_THAMPHAN(
                            itemdv.THAMPHAN_HOTEN, itemdv.THAMPHANID,itemdv.COLUMN_1,itemdv.COLUMN_2,itemdv.COLUMN_3,
                            itemdv.COLUMN_4,itemdv.COLUMN_5,itemdv.COLUMN_6,itemdv.COLUMN_7,itemdv.COLUMN_8,itemdv.COLUMN_9,itemdv.COLUMN_10
                            ); 



                END LOOP;  

   OPEN curReturn FOR 
     --   select * from table(V_TABLE_ALL);
            SELECT 
                            THAMPHAN_HOTEN,THAMPHANID, 
                            COLUMN_1,COLUMN_2,COLUMN_3,COLUMN_4,
                            COLUMN_5,COLUMN_6,COLUMN_7,COLUMN_8,
                            COLUMN_9,COLUMN_10
                        FROM (
                            SELECT 
                                THAMPHAN_HOTEN,THAMPHANID,
                                COLUMN_1,COLUMN_2,COLUMN_3,COLUMN_4,
                                COLUMN_5,COLUMN_6,COLUMN_7,COLUMN_8,
                                COLUMN_9,COLUMN_10
                            FROM TABLE(V_TABLE_ALL)
                            
--                            UNION ALL
--                        
--                            SELECT 
--                                'Tổng' as THAMPHAN_HOTEN, 0 as THAMPHANID,
--                                SUM(COLUMN_1),SUM(COLUMN_2),SUM(COLUMN_3),SUM(COLUMN_4),
--                                SUM(COLUMN_5),SUM(COLUMN_6),SUM(COLUMN_7),SUM(COLUMN_8),
--                                SUM(COLUMN_9),SUM(COLUMN_10)
--                            FROM TABLE(V_TABLE_ALL)
                            --Group by THAMPHAN_HOTEN, THAMPHANID
                           )
--                        ORDER BY 
--                            CASE 
--                                WHEN THAMPHAN_HOTEN = 'Tổng' THEN 0
--                                ELSE 100
--                            END
                            ;

END;

PROCEDURE DASHBOARD_M1_PCA
(  
    vToaAnID	in	VARCHAR2,
    vThamphanid in number,
    vTuNgay	in VARCHAR2,
    vDenNgay	in VARCHAR2,
    curReturn OUT sys_refcursor 
)
AS
    v_TIME_FROM VARCHAR2(50);v_TIME_TO VARCHAR2(50);  
    V_TABLE T_DASHBOARD_PCA;
    V_TABLE_ALL T_DASHBOARD_PCA;
    vvToaAnID NUMBER;
    vCursur sys_refcursor;

    vCheck number;

BEGIN
    v_table := T_DASHBOARD_PCA();
    V_TABLE_ALL := T_DASHBOARD_PCA();

    v_TIME_FROM:=to_date(trim(vTuNgay)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');
    v_TIME_TO:=to_date(trim(vDenNgay)||' 23:59:59','dd/MM/yyyy HH24:MI:SS');

----COLUMN_1-------------kn-------------
               FOR item IN ( SELECT d.BAQD_LOAIAN ,count(D.id) colnum_1
                                  FROM GDTTT_DON d 
                                  where 
                                  NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                  AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                  AND D.ISTHULY = 1
                                   AND d.CD_LOAI = 0
                                  AND( (d.BAQD_LOAIAN  != 1 and  EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON KQD   
                                                            LEFT JOIN GDTTT_VUAN_KETQUA KQ ON KQD.VUAN_KETQUA_ID = KQ.ID
                                                            WHERE KQD.DONID = D.ID 
                                                            AND KQ.GDQ_NGAY between v_TIME_FROM and v_TIME_TO
                                                            AND KQ.GQD_LOAIKETQUA = 1
                                                            AND KQD.TRANGTHAI = 1
                                                            )
                                                        )
                                       OR (d.BAQD_LOAIAN  = 1 and  EXISTS(SELECT 'X' FROM GDTTT_DON_TRALOI kqd 
                                                                                            WHERE kqd.DONID = D.ID 
                                                                                                and kqd.TYPETB in (4)
                                                                                                and kqd.NGAY between v_TIME_FROM and v_TIME_TO 
                                                                                                )    --KN                   
                                                               )                                                                                                               
                                                    )                                                    
                                  GROUP BY  d.BAQD_LOAIAN
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_DASHBOARD_PCA(
                        0,item.BAQD_LOAIAN,item.colnum_1,0,0,0,
                        0,0,0,0,0,
                        0, 0
                        );   
                END LOOP;
                
----COLUMN_2---------tra loi don-------------
                FOR item IN ( SELECT d.BAQD_LOAIAN,count(D.id) colnum_2
                                  FROM GDTTT_DON d 
                                  where 
                                  NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                  AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                  AND D.ISTHULY = 1
                                   AND d.CD_LOAI = 0
                                  AND( (d.BAQD_LOAIAN  != 1 and  EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON KQD   
                                                                                                        LEFT JOIN GDTTT_VUAN_KETQUA KQ ON KQD.VUAN_KETQUA_ID = KQ.ID 
                                                                                                        WHERE KQD.DONID = D.ID 
                                                                                                        AND KQ.GDQ_NGAY between v_TIME_FROM and v_TIME_TO
                                                                                                        AND KQ.GQD_LOAIKETQUA = 0
                                                                                                        AND KQD.TRANGTHAI = 1
                                                                                                        )
                                                        )
                                                   OR (d.BAQD_LOAIAN  = 1 and  EXISTS(SELECT 'X' FROM GDTTT_DON_TRALOI kqd 
                                                                                                        WHERE kqd.DONID = D.ID 
                                                                                                            and kqd.TYPETB in (3)
                                                                                                            and kqd.NGAY between v_TIME_FROM and v_TIME_TO 
                                                                                                            )    --TLD                   
                                                            )                                                                                                              
                                                    )                                                                      

                                  GROUP BY  d.BAQD_LOAIAN
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_DASHBOARD_PCA(
                        0,item.BAQD_LOAIAN,0,item.colnum_2,0,0,
                        0,0,0,0,0,
                        0, 0
                        );  
                END LOOP;
                
----COLUMN_3-------------Xep don-------------
               FOR item IN ( SELECT d.BAQD_LOAIAN,count(D.id) colnum_3
                                  FROM GDTTT_DON d 
                                  where 
                                  NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                  AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                  AND D.ISTHULY = 1
                                   AND d.CD_LOAI = 0
                                  AND ( (d.BAQD_LOAIAN  != 1 and  EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON KQD   
                                                            LEFT JOIN GDTTT_VUAN_KETQUA KQ ON KQD.VUAN_KETQUA_ID = KQ.ID
                                                            WHERE KQD.DONID = D.ID 
                                                            AND KQ.GDQ_NGAY between v_TIME_FROM and v_TIME_TO
                                                            AND KQ.GQD_LOAIKETQUA not IN (0,1)
                                                            AND KQD.TRANGTHAI = 1
                                                            )
                                                        )
                                          OR (d.BAQD_LOAIAN  = 1 
                                                                        and  EXISTS(SELECT 'X' FROM GDTTT_VUAN v 
                                                                            WHERE v.ID = D.vuviecid 
                                                                                --and v.gqd_loaiketqua  in (2,3,4) 
                                                                                and v.GDQ_NGAY between v_TIME_FROM and v_TIME_TO) ---XEP DON
                                                               )
                                            )
                                  GROUP BY  d.BAQD_LOAIAN
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_DASHBOARD_PCA(
                        0,item.BAQD_LOAIAN,0,0,item.colnum_3,0,
                        0,0,0,0,0,
                        0, 0
                        ); 
                END LOOP;

----COLUMN_4-------------Xin ý kiến Tổ Thẩm phán/Hội đồng toàn thể-------------
               FOR item IN (
                    SELECT C.BAQD_LOAIAN,count(C.id) colnum_4
                              FROM(
                                SELECT d.BAQD_LOAIAN,d.ID
                                  FROM GDTTT_DON d 
                                    LEFT JOIN GDTTT_VUAN_KETQUA_DON DKQ ON DKQ.DONID = D.ID AND DKQ.TRANGTHAI = 1
                                    LEFT JOIN GDTTT_VUAN_KETQUA KQ ON DKQ.VUAN_KETQUA_ID = KQ.ID
                                  where 
                                  NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                  AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                  AND D.ISTHULY = 1
                                   AND d.CD_LOAI = 0
                                  AND d.TL_NGAY <= v_TIME_TO 
--                                  And exists ( select 'x' from GDTTT_TOTRINH tt where tt.vuanid = d.VUVIECID and tt.TINHTRANGID in (9,17) -- 9 -Báo cáo Tổ Thẩm phán; 17 - Báo cáo Hội đồng thẩm phán
--                                                                                                                                                                  and tt.NGAYTRINH is not null and tt.NGAYTRA is null)
--                               
--                               
                                                                 AND exists (SELECT 'x'
                                                    FROM GDTTT_TOTRINH t
                                                    JOIN (
                                                        SELECT VUANID, MAX(NGAYTRINH) AS MAX_NGAYTRINH
                                                        FROM GDTTT_TOTRINH
                                                        GROUP BY VUANID
                                                    ) lastTrinh
                                                      ON t.VUANID = lastTrinh.VUANID
                                                     AND t.NGAYTRINH = lastTrinh.MAX_NGAYTRINH
                                                     and t.TINHTRANGID in (9,17)
                                                     and t.NGAYTRA is null  
                                                     and t.ykien is null
                                                     and t.vuanid = d.VUVIECID)
                               
                               
                                 )C

                                  GROUP BY C.BAQD_LOAIAN   

                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_DASHBOARD_PCA(
                        0,item.BAQD_LOAIAN,0,0,0,item.colnum_4,
                        0,0,0,0,0,
                        0, 0
                        ); 
                END LOOP;

----COLUMN_5-----------------Chưa có ý kiến-------------
               FOR item IN (
               
               SELECT C.BAQD_LOAIAN, count(c.ID)  colnum_5
               from  ( select d.BAQD_LOAIAN,d.ID
                                  FROM GDTTT_DON d 
                                  where 
                                  NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                  AND d.toaanid = 1 --sau se truyen don vi vao
                                  --AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                  AND D.ISTHULY = 1
                                   AND d.CD_LOAI = 0
                                  AND d.TL_NGAY <= to_Date('07/08/2025','dd/MM/yyyy') 
                                  AND exists (SELECT 'x'
                                                    FROM GDTTT_TOTRINH t
                                                    JOIN (
                                                        SELECT VUANID, MAX(NGAYTRINH) AS MAX_NGAYTRINH
                                                        FROM GDTTT_TOTRINH
                                                        GROUP BY VUANID
                                                    ) lastTrinh
                                                      ON t.VUANID = lastTrinh.VUANID
                                                     AND t.NGAYTRINH = lastTrinh.MAX_NGAYTRINH
                                                     and t.TINHTRANGID = 7
                                                     and t.NGAYTRA is null  
                                                     and t.ykien is null
                                                     and t.vuanid = d.VUVIECID)
                                                     ) c
               GROUP BY C.BAQD_LOAIAN   
               
               
--                    SELECT C.BAQD_LOAIAN,count(C.id) colnum_5
--                              FROM(
--                                SELECT d.BAQD_LOAIAN,d.ID
--                                  FROM GDTTT_DON d 
--                                            
--                                  where 
--                                  NVL(d.LOAIDON,0) NOT IN(4)
--                                  AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
--                                  AND d.toaanid = vToaAnID --sau se truyen don vi vao
--                                  AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
--                                  AND D.ISTHULY = 1
--                                   AND d.CD_LOAI = 0
--                                  AND d.TL_NGAY <= v_TIME_TO 
--                                  
--                                AND exists (SELECT 'x'
--                                                    FROM GDTTT_TOTRINH t
--                                                    JOIN (
--                                                        SELECT VUANID, MAX(NGAYTRINH) AS MAX_NGAYTRINH
--                                                        FROM GDTTT_TOTRINH
--                                                        GROUP BY VUANID
--                                                    ) lastTrinh
--                                                      ON t.VUANID = lastTrinh.VUANID
--                                                     AND t.NGAYTRINH = lastTrinh.MAX_NGAYTRINH
--                                                     and t.TINHTRANGID = 7
--                                                     and t.NGAYTRA is null  
--                                                     and t.ykien is null
--                                                     and t.vuanid = d.VUVIECID)
                                                     
--                                   And exists (
--                                  SELECT tt.NGAYTRINH
--                                                        FROM GDTTT_VUAN v
--                                                        inner JOIN (
--                                                            SELECT tt.*
--                                                            FROM (
--                                                                SELECT tt.*, ROW_NUMBER() OVER (PARTITION BY tt.vuanid ORDER BY tt.NGAYTRINH desc, tt.id desc) AS rn
--                                                                FROM GDTTT_TOTRINH tt
--                                                            ) tt
--                                                            WHERE rn = 1 
--                                                        ) tt ON tt.vuanid = v.id and tt.TINHTRANGID = 7  and tt.NGAYTRA is null and tt.NGAYTRINH is not null and tt.ykien is null
--                                                        WHERE v.id =d.VUVIECID 
--                                       )
                                  
--                                  select 'x' from GDTTT_TOTRINH tt where tt.vuanid = d.VUVIECID and tt.TINHTRANGID = 7 --  Trình Phó Chánh án	
--                                                                                                                                                                  and tt.NGAYTRINH is not null and tt.NGAYTRA is null
                                                                                                                                                                                            
                                                                                                                                                                  
                         --        )C

                           --       GROUP BY C.BAQD_LOAIAN   

                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_DASHBOARD_PCA(
                        0,item.BAQD_LOAIAN,0,0,0,
                        0,item.colnum_5,0,0,0,0,
                        0, 0
                        ); 
                END LOOP;             
             
----COLUMN_7-----------------Tồn kỳ trước-------------
              FOR item IN (
   select c.LOAIAN, count(c.id) colnum_6
                                from(
                                    SELECT d.toaanid,d.id
                                           ,d.LOAIAN LOAIAN
                                             FROM GDTTT_VUAN d  
                                      where 
                                      d.toaanid = vToaAnID --sau se truyen don vi vao
                                       AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)  
                                       AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                      AND (
                                             (d.NGAYTHULYXXGDT < v_TIME_FROM and (d.XXGDTTT_NGAYQD is null OR to_char(d.XXGDTTT_NGAYQD,'dd/MM/yyyy') = '01/01/0001' ) )
                                           OR  (d.NGAYTHULYXXGDT < v_TIME_FROM and d.XXGDTTT_NGAYQD is not null and to_char(d.XXGDTTT_NGAYQD,'dd/MM/yyyy') != '01/01/0001' and d.XXGDTTT_NGAYQD >= v_TIME_FROM))     
                                      AND d.THAMQUYENXXGDT = 1
                                      AND d.NGAYTHULYXXGDT is not null
                                      GROUP BY  d.toaanid,d.id,d.LOAIAN)C
                                    group by c.LOAIAN           
                                  )
                LOOP                        
                        v_table.extend;
                        v_table(v_table.count) := R_DASHBOARD_PCA(
                        0,item.LOAIAN,0,0,0,
                        0,0,item.colnum_6,0,0,0,
                        0, 0
                        ); 
                END LOOP;
                
----COLUMN_8-----------------Thụ lý mới-------------	
              FOR item IN (select c.LOAIAN, count(c.id) colnum_7 
                                from(
                                    SELECT d.LOAIAN, d.id
                                             FROM GDTTT_VUAN d  
                                      where 
                                      d.toaanid = vToaAnID --sau se truyen don vi vao
                                       AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)  
                                       AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                      AND (d.NGAYTHULYXXGDT between v_TIME_FROM and v_TIME_TO)     
                                      AND d.THAMQUYENXXGDT = 1
                                      AND d.NGAYTHULYXXGDT is not null
                                      )C
                                    group by c.LOAIAN
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_DASHBOARD_PCA(
                        0,item.LOAIAN,0,0,0,
                        0,0,0,item.colnum_7,0,0,
                        0, 0
                        );   
                END LOOP;   

----COLUMN_9-----------------Đã xét xử-------------	
              FOR item IN (                                     
                      select c.LOAIAN, count(c.id) colnum_8
                                from(
                                    SELECT d.LOAIAN, d.id
                                             FROM GDTTT_VUAN d  
                                      where 
                                      d.toaanid = vToaAnID --sau se truyen don vi vao
                                       AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)  
                                       AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                      AND ( d.XXGDTTT_NGAYQD between v_TIME_FROM and v_TIME_TO 
                                            OR d.ISRUTKN = 1)
                                      AND d.THAMQUYENXXGDT = 1
                                       AND d.NGAYTHULYXXGDT is not null
                                    )C
                                    group by c.LOAIAN       

                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_DASHBOARD_PCA(
                        0,item.LOAIAN,0,0,0,
                        0,0,0,0,item.colnum_8,0,
                        0, 0
                        ); 
                END LOOP;       

----COLUMN_10-----------------Đình chỉ xét xử GĐT-------------
              FOR item IN (                                     
                      select c.LOAIAN, count(c.id) colnum_9
                                from(
                                    SELECT d.LOAIAN, d.id
                                             FROM GDTTT_VUAN d  
                                                     left join (select * from gscm.GDTTT_VUAN_XETXUGDTTT where ISHOAN = 0) kqxx on kqxx.VUANID = d.id 

                                      where 
                                      d.toaanid = vToaAnID --sau se truyen don vi vao
                                       AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)  
                                       AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                      AND ( d.XXGDTTT_NGAYQD between v_TIME_FROM and v_TIME_TO 
                                            OR d.ISRUTKN = 1)
                                      AND d.THAMQUYENXXGDT = 1
                                       AND d.NGAYTHULYXXGDT is not null
                                         AND kqxx.KETQUAID = 1322
                                      )C
                                    group by c.LOAIAN       

                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_DASHBOARD_PCA(
                        0,item.LOAIAN,0,0,0,
                        0,0,0,0,0,item.colnum_9,
                        0, 0
                        ); 
                END LOOP;       

 ----COLUMN_11-----------------Chua xét xử gdtt-------------
              FOR item IN (     
                         select c.LOAIAN, count(c.id) colnum_10
                                from(
                                    SELECT d.LOAIAN, d.id
                                             FROM GDTTT_VUAN d  
                                      where 
                                      d.toaanid = vToaAnID --sau se truyen don vi vao
                                       AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)   
                                       AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                      AND (d.NGAYTHULYXXGDT between v_TIME_FROM and v_TIME_TO
                                           OR  (d.NGAYTHULYXXGDT < v_TIME_FROM and (d.XXGDTTT_NGAYQD is null OR to_char(d.XXGDTTT_NGAYQD,'dd/MM/yyyy') = '01/01/0001' ) )
                                           OR  (d.NGAYTHULYXXGDT < v_TIME_FROM and d.XXGDTTT_NGAYQD is not null and to_char(d.XXGDTTT_NGAYQD,'dd/MM/yyyy') != '01/01/0001' and d.XXGDTTT_NGAYQD >= v_TIME_FROM))     
                                      AND (NVL(d.ISRUTKN,0) = 0 ) 
                                      AND (d.XXGDTTT_NGAYQD is null OR to_char(d.XXGDTTT_NGAYQD,'dd/MM/yyyy') = '01/01/0001' ) 
                                       AND d.NGAYTHULYXXGDT is not null
                                      AND d.THAMQUYENXXGDT = 1
                                      )C
                                    group by c.LOAIAN               


                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_DASHBOARD_PCA(
                        0,item.LOAIAN,0,0,0,
                        0,0,0,0,0,
                        0,item.colnum_10, 0
                        );  
                END LOOP;            


                FOR itemdv IN (SELECT
                                         TK.THAMPHAN_HOTEN,
                                        tk.THAMPHANID,
                                    COLUMN_1, COLUMN_2,
                                         COLUMN_3, COLUMN_4,
                                      COLUMN_5, COLUMN_6,
                                        COLUMN_7, COLUMN_8,
                                        COLUMN_9, COLUMN_10,COLUMN_11
                                                  FROM table(v_table) tk 

                                    )

                LOOP

                        V_TABLE_ALL.extend;
                        V_TABLE_ALL(V_TABLE_ALL.count) := R_DASHBOARD_PCA(
                            itemdv.THAMPHAN_HOTEN, itemdv.THAMPHANID,itemdv.COLUMN_1,itemdv.COLUMN_2,itemdv.COLUMN_3,
                            itemdv.COLUMN_4,itemdv.COLUMN_5,itemdv.COLUMN_6,itemdv.COLUMN_7,itemdv.COLUMN_8,itemdv.COLUMN_9,itemdv.COLUMN_10,itemdv.COLUMN_11
                            ); 



                END LOOP;  

   OPEN curReturn FOR 
   
            Select cb.ID THAMPHANID,CB.HOTEN THAMPHAN_HOTEN,                 
                          sum(COLUMN_1) COLUMN_1,sum(COLUMN_2) COLUMN_2,
                                        sum(COLUMN_3) COLUMN_3,sum(COLUMN_4) COLUMN_4,
                                        sum(COLUMN_5) COLUMN_5,sum(COLUMN_6) COLUMN_6,
                                        sum(COLUMN_7) COLUMN_7,sum(COLUMN_8) COLUMN_8,
                                        sum(COLUMN_9) COLUMN_9,sum(COLUMN_10) COLUMN_10
            From dm_canbo cb
                Inner join dm_dataitem dt on dt.id = cb.chucvuid and dt.ma like 'PCA'
                Inner join GDTTT_PCA_PHUTRACH dta on dta.canboid = cb.id
                left join table(V_TABLE_ALL)  a on a.THAMPHANID = dta.loaian
                WHERE TOAANID = 1 AND CB.HIEULUC = 1
                Group by CB.HOTEN, cb.ID
                ;
END;

PROCEDURE  GET_THAMPHAN_TOICAO
(
  vToaAnID in VARCHAR2,
  vThamphan_id IN NUMBER,
  CurReturn OUT sys_refcursor 
) AS 


BEGIN

   open CurReturn for
        SELECT * FROM (   
            SELECT 0 ID, TRANSLATE ('--- Tất cả Thẩm phám ---' USING NCHAR_CS) AS HOTEN, TRANSLATE ('--- Tất cả Thẩm phám ---' USING NCHAR_CS) AS  FULL_HOTEN
            FROM DUAL

            UNION ALL

            SELECT D.ID, D.HOTEN || DECODE(CV.ID, 45, ' - CA', 74, ' - PCA', 446, ' - PCA', 1938, ' - PCA', '') AS HOTEN, DECODE(CV.TEN, NULL, '', CV.TEN || ' ') || D.HOTEN  AS FULL_HOTEN
            FROM DM_CANBO D
                LEFT JOIN DM_DATAITEM CV ON CV.ID = D.CHUCVUID AND CV.MA NOT LIKE 'CA'
                LEFT JOIN DM_DATAITEM CD ON CD.ID = D.CHUCDANHID
            WHERE D.TOAANID = vToaAnID AND D.HIEULUC = 1 
                AND (vThamphan_id = 0 OR vThamphan_id = D.ID)
                AND CD.MA LIKE 'TPTATC' -- Chỉ lấy TP TANDTC
                AND NOT EXISTS(SELECT DT.ID, DT.TEN FROM DM_DATAITEM DT WHERE DT.MA IN ('CA') AND DT.ID=D.CHUCVUID) -- Loại Chánh án ra khỏi danh sách
        )
        ORDER BY 
            CASE 
                WHEN ID = 0 THEN 1  -- Đưa ID = 0 lên đầu
                WHEN FULL_HOTEN LIKE '%Thường trực%' THEN 2
                WHEN HOTEN LIKE '%PCA' THEN 3  -- Đưa Phó Chánh án (PCA) sau ID = 0
                ELSE 4  -- Các nhân vật còn lại
            END,
            HOTEN;

END GET_THAMPHAN_TOICAO;

PROCEDURE DASHBOARD_GDT_EXP
(  
    vToaAnID	in	VARCHAR2,
    vThamphanid in number,
    vTuNgay	in VARCHAR2,
    vDenNgay	in VARCHAR2,
    curReturn OUT sys_refcursor 
)
AS
    v_TIME_FROM VARCHAR2(50);v_TIME_TO VARCHAR2(50);  
    V_TABLE T_GDTTT_DASHBOARD_V2;
    V_TABLE_ALL T_GDTTT_DASHBOARD_V2;
    vvToaAnID NUMBER;
    vCursur sys_refcursor;

BEGIN
    v_table := T_GDTTT_DASHBOARD_V2();
    V_TABLE_ALL := T_GDTTT_DASHBOARD_V2();

    v_TIME_FROM:=to_date(trim(vTuNgay)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');
    v_TIME_TO:=to_date(trim(vDenNgay)||' 23:59:59','dd/MM/yyyy HH24:MI:SS');

               ----COLUMN_1-------Tổng số đơn Cũ chuyển sang	----------
               FOR item IN (
                        SELECT C.BAQD_LOAIAN TENLOAIAN,count(C.id) colnum_2
                         FROM (
                                 SELECT d.BAQD_LOAIAN,d.ID 
                                          FROM GDTTT_DON d 
                                          where 
                                          NVL(d.LOAIDON,0) NOT IN(4)
                                          AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                          AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                          AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                          AND D.ISTHULY = 1 
                                           AND d.CD_LOAI = 0
                                          AND  d.TL_NGAY < v_TIME_FROM                            
                                                 and ((d.BAQD_LOAIAN != 1 AND (  EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON DKQ   
                                                                    LEFT JOIN GDTTT_VUAN_KETQUA KQ ON DKQ.VUAN_KETQUA_ID = KQ.ID
                                                                    WHERE DKQ.DONID = D.ID
                                                                            AND DKQ.TRANGTHAI = 1
                                                                            AND KQ.GDQ_NGAY >= v_TIME_FROM)
                                                                           
                                                                            or
                                                                                not EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA DKQ   
                                                                                                        LEFT JOIN GDTTT_VUAN_KETQUA_DON KQ ON DKQ.ID = KQ.VUAN_KETQUA_ID
                                                                                                        WHERE KQ.DONID = D.ID)
                                                                             )
                                                                            )
                                                        or (d.BAQD_LOAIAN != 1 AND NOT EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON DKQ  
                                                                                                        WHERE DKQ.DONID = D.ID 
                                                                                                        AND DKQ.TRANGTHAI = 1))            
                                                         or (d.BAQD_LOAIAN = 1  AND NOT EXISTS(SELECT 'X' FROM GDTTT_VUAN v 
                                                                               WHERE v.ID = D.vuviecid and v.gqd_loaiketqua in (0,1,2,3,4))  )  
                                                         OR (d.BAQD_LOAIAN = 1  AND EXISTS(SELECT 'X' FROM GDTTT_VUAN v 
                                                                               WHERE v.ID = D.vuviecid and v.gqd_loaiketqua in (0,1,2,3,4)
                                                                                                        and v.GDQ_NGAY >= v_TIME_FROM)  )                      
                                                                    )
                                        AND d.id !=319292
                                    )C

                                GROUP BY  C.BAQD_LOAIAN

                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD_V2(
                        item.TENLOAIAN,
                        item.colnum_2,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0
                        );   
                END LOOP;
                
                ----COLUMN_2-------Tổng số đơn Mới thụ lý	---------- 
               FOR item IN (

                SELECT C.BAQD_LOAIAN TENLOAIAN,count(C.id) colnum_2
                         FROM (
                                SELECT d.BAQD_LOAIAN,d.ID 
                                          FROM GDTTT_DON d 
                                          where 
                                          NVL(d.LOAIDON,0) NOT IN(4)
                                          AND d.ngaytao>= to_Date('01/01/2024','dd/MM/yyyy')
                                          AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                          AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                          AND D.ISTHULY = 1  
                                          AND d.CD_LOAI = 0
                                          AND d.TL_NGAY between v_TIME_FROM and v_TIME_TO
                                    )C

                                GROUP BY  C.BAQD_LOAIAN

                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD_V2(
                        item.TENLOAIAN,0,
                        item.colnum_2,0,0,0,0,0,0,0,0,
                        0,0,0,0,0
                        );   
                END LOOP;
                
                ------COLUMN_3 Đã giải quyết xong
                FOR item IN ( SELECT d.toaanid
                                  ,d.BAQD_LOAIAN TENLOAIAN,count(D.id) colnum_3
                                  FROM GDTTT_DON d 
                                  where 
                                  NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao > to_Date('01/01/2024','dd/MM/yyyy')
                                  AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                  AND D.ISTHULY = 1
                                   AND d.CD_LOAI = 0
                                  AND( (d.BAQD_LOAIAN != 1 and  EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON DKQ   
                                                            LEFT JOIN GDTTT_VUAN_KETQUA KQ ON DKQ.VUAN_KETQUA_ID = KQ.ID
                                                            WHERE DKQ.DONID = D.ID 
                                                                AND DKQ.TRANGTHAI = 1
                                                                AND KQ.GDQ_NGAY between v_TIME_FROM and v_TIME_TO))

                                  OR (d.BAQD_LOAIAN  = 1 and ( EXISTS(SELECT 'X' FROM GDTTT_VUAN v 
                                                                                                        WHERE v.ID = D.vuviecid 
                                                                                                            and v.gqd_loaiketqua in (2,3,4) 
                                                                                                            and v.GDQ_NGAY between v_TIME_FROM and v_TIME_TO) ---XEP DON
                                                                               OR  EXISTS(SELECT 'X' FROM GDTTT_DON_TRALOI kqd 
                                                                                                        WHERE kqd.DONID = D.ID 
                                                                                                            and kqd.TYPETB in (3,4)
                                                                                                            and kqd.NGAY between v_TIME_FROM and v_TIME_TO 
                                                                                                            )    --TLD;KN                    
                                                                                )                                                                                            
                                                    )                                                                      
                                  )

                                  GROUP BY  d.toaanid,d.BAQD_LOAIAN
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD_V2(
                        item.TENLOAIAN,0,
                        0,item.colnum_3,0,0,0,0,0,0,0,
                        0,0,0,0,0
                        );   
                END LOOP;
      
--                ----COLUMN_4---------tra loi don--------
                FOR item IN ( SELECT d.toaanid
                                   ,d.BAQD_LOAIAN TENLOAIAN,count(D.id) colnum_4
                                  FROM GDTTT_DON d 
                                  where 
                                  NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                  AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                  AND D.ISTHULY = 1
                                   AND d.CD_LOAI = 0
                                  AND( (d.BAQD_LOAIAN  != 1 and  EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON KQD   
                                                            LEFT JOIN GDTTT_VUAN_KETQUA KQ ON KQD.VUAN_KETQUA_ID = KQ.ID 
                                                            WHERE KQD.DONID = D.ID 
                                                            AND KQ.GDQ_NGAY between v_TIME_FROM and v_TIME_TO
                                                            AND KQ.GQD_LOAIKETQUA = 0
                                                            AND KQD.TRANGTHAI = 1
                                                            )
                                                        )
                                   OR (d.BAQD_LOAIAN  = 1 and  EXISTS(SELECT 'X' FROM GDTTT_DON_TRALOI kqd 
                                                                                        WHERE kqd.DONID = D.ID 
                                                                                            and kqd.TYPETB in (3)
                                                                                            and kqd.NGAY between v_TIME_FROM and v_TIME_TO 
                                                                                            )    --TLD                   
                                                            )                                                                                                              
                                                    )                                                                      

                                  GROUP BY  d.toaanid,d.BAQD_LOAIAN
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD_V2(
                        item.TENLOAIAN,0,0,
                        0,item.colnum_4,0,0,0,0,0,0,
                        0,0,0,0,0
                        );   
                END LOOP;
--                 ----COLUMN_5---kn--------------
               FOR item IN ( SELECT d.toaanid
                                 ,d.BAQD_LOAIAN TENLOAIAN,count(D.id) colnum_5
                                  FROM GDTTT_DON d 
                                  where 
                                  NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                  AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                  AND D.ISTHULY = 1
                                   AND d.CD_LOAI = 0
                                  AND( (d.BAQD_LOAIAN  != 1 and  EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON KQD   
                                                            LEFT JOIN GDTTT_VUAN_KETQUA KQ ON KQD.VUAN_KETQUA_ID = KQ.ID
                                                            WHERE KQD.DONID = D.ID 
                                                            AND KQ.GDQ_NGAY between v_TIME_FROM and v_TIME_TO
                                                            AND KQ.GQD_LOAIKETQUA = 1
                                                            AND KQD.TRANGTHAI = 1
                                                            )
                                                        )
                                       OR (d.BAQD_LOAIAN  = 1 and  EXISTS(SELECT 'X' FROM GDTTT_DON_TRALOI kqd 
                                                                                            WHERE kqd.DONID = D.ID 
                                                                                                and kqd.TYPETB in (4)
                                                                                                and kqd.NGAY between v_TIME_FROM and v_TIME_TO 
                                                                                                )    --KN                   
                                                               )                                                                                                               
                                                    )                                                    
                                  GROUP BY  d.toaanid,d.BAQD_LOAIAN
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD_V2(
                        item.TENLOAIAN,0,0,0,0,
                        item.colnum_5,0,0,0,0,0,
                        0, 0,0,0,0
                        );   
                END LOOP;
--                 ----COLUMN_6----Xep don-------------
               FOR item IN ( SELECT d.toaanid
                                  ,d.BAQD_LOAIAN TENLOAIAN,count(D.id) colnum_6
                                  FROM GDTTT_DON d 
                                  where 
                                  NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                  AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                  AND D.ISTHULY = 1
                                   AND d.CD_LOAI = 0
                                  AND ( (d.BAQD_LOAIAN  != 1 and  EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON KQD   
                                                            LEFT JOIN GDTTT_VUAN_KETQUA KQ ON KQD.VUAN_KETQUA_ID = KQ.ID
                                                            WHERE KQD.DONID = D.ID 
                                                            AND KQ.GDQ_NGAY between v_TIME_FROM and v_TIME_TO
                                                            AND KQ.GQD_LOAIKETQUA IN (2,3,4)
                                                            AND KQD.TRANGTHAI = 1
                                                            )
                                                        )
                                          OR (d.BAQD_LOAIAN  = 1 and  EXISTS(SELECT 'X' FROM GDTTT_VUAN v 
                                                                            WHERE v.ID = D.vuviecid 
                                                                                and v.gqd_loaiketqua in (2,3,4) 
                                                                                and v.GDQ_NGAY between v_TIME_FROM and v_TIME_TO) ---XEP DON
                                                               )
                                            )
                                  GROUP BY  d.toaanid,d.BAQD_LOAIAN
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD_V2(
                        item.TENLOAIAN,0,0,0,0,
                        0,item.colnum_6,0,0,0,0,
                        0,0,0,0,0
                        );   
                END LOOP;

                -- ----COLUMN_7-----------------
               FOR item IN (
                    SELECT C.BAQD_LOAIAN TENLOAIAN,count(C.id) colnum_7
                              FROM(
                                SELECT d.BAQD_LOAIAN,d.ID
                                  FROM GDTTT_DON d 
                                    LEFT JOIN GDTTT_VUAN_KETQUA_DON DKQ ON DKQ.DONID = D.ID AND DKQ.TRANGTHAI = 1
                                    LEFT JOIN GDTTT_VUAN_KETQUA KQ ON DKQ.VUAN_KETQUA_ID = KQ.ID
                                  where 
                                  NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                  AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                  AND D.ISTHULY = 1
                                   AND d.CD_LOAI = 0
                                  AND d.TL_NGAY <= v_TIME_TO 
                                  AND d.BAQD_LOAIAN != 1 
                                  and (KQ.gqd_loaiketqua IS NULL OR KQ.GDQ_NGAY > v_TIME_TO)
                                 UNION
                               SELECT d.BAQD_LOAIAN,d.ID
                                  FROM GDTTT_DON d 
                                  LEFT JOIN GDTTT_VUAN V ON V.ID = D.VUVIECID
                                  where 
                                  NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                  AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                  AND D.ISTHULY = 1
                                   AND d.CD_LOAI = 0
                                  AND d.TL_NGAY <= v_TIME_TO 
                                  AND d.BAQD_LOAIAN = 1              
                                  and ( v.gqd_loaiketqua IS NULL 
                                        OR  v.GDQ_NGAY > v_TIME_TO
                                        )   
                                 )C

                                  GROUP BY C.BAQD_LOAIAN   

                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD_V2(
                        item.TENLOAIAN,0,0,0,0,
                        0,0,item.colnum_7,0,0,0,
                        0,0,0,0,0
                        );   
                END LOOP;

--   ----COLUMN_8-----------------Tong phải xet xu
              FOR item IN (select c.TENLOAIAN, count(c.id) colnum_8 
                                from(
                                    SELECT d.toaanid,d.id
                                           ,d.LOAIAN TENLOAIAN
                                             FROM GDTTT_VUAN d  
                                      where 
                                      d.toaanid = vToaAnID --sau se truyen don vi vao
                                       AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)  
                                       AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                      AND (d.NGAYTHULYXXGDT between v_TIME_FROM and v_TIME_TO
                                           OR  (d.NGAYTHULYXXGDT < v_TIME_FROM and (d.XXGDTTT_NGAYQD is null OR to_char(d.XXGDTTT_NGAYQD,'dd/MM/yyyy') = '01/01/0001' ) )
                                           OR  (d.NGAYTHULYXXGDT < v_TIME_FROM and d.XXGDTTT_NGAYQD is not null and to_char(d.XXGDTTT_NGAYQD,'dd/MM/yyyy') != '01/01/0001' and d.XXGDTTT_NGAYQD >= v_TIME_FROM))     
                                      AND d.THAMQUYENXXGDT = 1
                                      AND d.NGAYTHULYXXGDT is not null
                                      GROUP BY  d.toaanid,d.id,d.LOAIAN)C
                                    group by c.TENLOAIAN
                                  )
                LOOP
                         v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD_V2(
                        item.TENLOAIAN,0,0,0,0,
                        0,0,0,item.colnum_8,0,0
                        ,0,0,0,0,0
                        );   
                END LOOP;
 --            ----COLUMN_9----------------- Tong so kháng nghị CA
                FOR item IN ( select c.TENLOAIAN, count(c.id) colnum_9
                                from(
                                    SELECT d.toaanid,d.id
                                           ,d.LOAIAN TENLOAIAN
                                             FROM GDTTT_VUAN d  
                                      where 
                                      d.toaanid = vToaAnID --sau se truyen don vi vao
                                       AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)    
                                       AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                      AND (d.NGAYTHULYXXGDT between v_TIME_FROM and v_TIME_TO
                                           OR  (d.NGAYTHULYXXGDT < v_TIME_FROM and (d.XXGDTTT_NGAYQD is null OR to_char(d.XXGDTTT_NGAYQD,'dd/MM/yyyy') = '01/01/0001' )   )
                                           OR  (d.NGAYTHULYXXGDT < v_TIME_FROM and d.XXGDTTT_NGAYQD is not null  and to_char(d.XXGDTTT_NGAYQD,'dd/MM/yyyy') != '01/01/0001' and d.XXGDTTT_NGAYQD >= v_TIME_FROM))     
                                      AND NVL(d.TRUONGHOPTHULY,0) != 1
                                      AND d.THAMQUYENXXGDT = 1
                                      GROUP BY  d.toaanid,d.id,d.LOAIAN)C
                                    group by c.TENLOAIAN   

                                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD_V2(
                        item.TENLOAIAN,0,0,0,0,
                        0,0,0,0,item.colnum_9,0,
                        0,0,0,0,0
                        );   
                END LOOP;
 --            ----COLUMN_10----------------- Tong so kháng nghị VKS  d.NGAYXUGIAMDOCTHAM is null
                FOR item IN (
                       select c.TENLOAIAN, count(c.id) colnum_10
                                from(
                                    SELECT d.toaanid,d.id
                                           ,d.LOAIAN TENLOAIAN
                                             FROM GDTTT_VUAN d  
                                      where 
                                      d.toaanid = vToaAnID --sau se truyen don vi vao
                                       AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)  
                                       AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                      AND (d.NGAYTHULYXXGDT between v_TIME_FROM and v_TIME_TO
                                           OR  (d.NGAYTHULYXXGDT < v_TIME_FROM 
                                                            and (d.XXGDTTT_NGAYQD is null OR to_char(d.XXGDTTT_NGAYQD,'dd/MM/yyyy') = '01/01/0001' ) )
                                           OR  (d.NGAYTHULYXXGDT < v_TIME_FROM and d.XXGDTTT_NGAYQD is not null and to_char(d.XXGDTTT_NGAYQD,'dd/MM/yyyy') != '01/01/0001'  and d.XXGDTTT_NGAYQD >= v_TIME_FROM))     
                                      AND NVL(d.TRUONGHOPTHULY,0) = 1
                                      AND d.THAMQUYENXXGDT = 1
                                      GROUP BY  d.toaanid,d.id,d.LOAIAN)C
                                    group by c.TENLOAIAN   
                           )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD_V2(
                        item.TENLOAIAN,0,0,0,0,
                        0,0,0,0,0,item.colnum_10,
                        0,0,0,0,0
                        );   
                END LOOP;  
--                ----COLUMN_11-----------------Đã  xét xử gdtt
              FOR item IN (                                     
                      select c.TENLOAIAN, count(c.id) colnum_11
                                from(
                                    SELECT d.toaanid,d.id
                                           ,d.LOAIAN TENLOAIAN
                                             FROM GDTTT_VUAN d  
                                      where 
                                      d.toaanid = vToaAnID --sau se truyen don vi vao
                                       AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)  
                                       AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                      --AND  EXISTS(select 'X' from gdttt_vuan_xetxugdttt kq where d.ID = kq.VUANID and NVL(kq.ishoan,0) = 0 and kq.NGAYMOPT between v_TIME_FROM and v_TIME_TO )
                                      AND ( d.XXGDTTT_NGAYQD between v_TIME_FROM and v_TIME_TO 
                                            OR d.ISRUTKN = 1)
                                      AND d.THAMQUYENXXGDT = 1
                                       AND d.NGAYTHULYXXGDT is not null
                                      GROUP BY  d.toaanid,d.id,d.LOAIAN)C
                                    group by c.TENLOAIAN       

                                  )
                LOOP
                         v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD_V2(
                        item.TENLOAIAN,0,0,0,0,
                        0,0,0,0,0,0,
                        item.colnum_11,0,0,0,0
                        );   
                END LOOP;                
 --                ----COLUMN_12-----------------Chua xét xử gdtt
              FOR item IN (     
                         select c.TENLOAIAN, count(c.id) colnum_12
                                from(
                                    SELECT d.toaanid,d.id
                                           ,d.LOAIAN TENLOAIAN
                                             FROM GDTTT_VUAN d  
                                      where 
                                      d.toaanid = vToaAnID --sau se truyen don vi vao
                                       AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)   
                                       AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                      AND (d.NGAYTHULYXXGDT between v_TIME_FROM and v_TIME_TO
                                           OR  (d.NGAYTHULYXXGDT < v_TIME_FROM and (d.XXGDTTT_NGAYQD is null OR to_char(d.XXGDTTT_NGAYQD,'dd/MM/yyyy') = '01/01/0001' ) )
                                           OR  (d.NGAYTHULYXXGDT < v_TIME_FROM and d.XXGDTTT_NGAYQD is not null and to_char(d.XXGDTTT_NGAYQD,'dd/MM/yyyy') != '01/01/0001' and d.XXGDTTT_NGAYQD >= v_TIME_FROM))     
                                      AND (NVL(d.ISRUTKN,0) = 0 ) 
                                      AND (d.XXGDTTT_NGAYQD is null OR to_char(d.XXGDTTT_NGAYQD,'dd/MM/yyyy') = '01/01/0001' ) 
                                       AND d.NGAYTHULYXXGDT is not null
                                      AND d.THAMQUYENXXGDT = 1
                                      GROUP BY  d.toaanid,d.id,d.LOAIAN)C
                                    group by c.TENLOAIAN               


                                  )
                LOOP
                         v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD_V2(
                        item.TENLOAIAN,0,0,0,0,
                        0,0,0,0,0,0,0,item.colnum_12,0
                        ,0,0
                        );   
                END LOOP;               

                FOR itemdv IN (SELECT LA.THUTU,TK.TENLOAIAN,la.loai_an_ten LOAIAN,
                                        sum(tk.COLUMN_1) COLUMN_1,sum(tk.COLUMN_2) COLUMN_2,
                                        sum(tk.COLUMN_3) COLUMN_3,sum(tk.COLUMN_4) COLUMN_4,
                                        sum(tk.COLUMN_5) COLUMN_5,sum(tk.COLUMN_6) COLUMN_6,
                                        sum(tk.COLUMN_7) COLUMN_7,sum(tk.COLUMN_8) COLUMN_8,
                                        sum(tk.COLUMN_9) COLUMN_9,sum(tk.COLUMN_10) COLUMN_10,
                                        sum(tk.COLUMN_11) COLUMN_11     ,
                                        sum(tk.COLUMN_12) COLUMN_12     ,
                                        sum(tk.COLUMN_13) COLUMN_13     ,
                                        sum(tk.COLUMN_14) COLUMN_14     ,
                                        sum(tk.COLUMN_15) COLUMN_15     
                                                  FROM table(v_table) tk 
                                                   LEFT JOIN DM_LOAIAN LA ON LA.ID=tk.TENLOAIAN                                                    
                                                        group by LA.THUTU,tk.TENLOAIAN,la.loai_an_ten ORDER BY LA.THUTU
                                    )

                LOOP
                        V_TABLE_ALL.extend;
                        V_TABLE_ALL(V_TABLE_ALL.count) := R_GDTTT_DASHBOARD_V2(
                            itemdv.LOAIAN,itemdv.COLUMN_1,itemdv.COLUMN_2,itemdv.COLUMN_3,itemdv.COLUMN_4,itemdv.COLUMN_5,itemdv.COLUMN_6,
                            itemdv.COLUMN_7,itemdv.COLUMN_8,itemdv.COLUMN_9,itemdv.COLUMN_10,itemdv.COLUMN_11,
                            itemdv.COLUMN_12,itemdv.COLUMN_13,itemdv.COLUMN_14,itemdv.COLUMN_15
                            ); 
                END LOOP;  

   --------------------------
   OPEN curReturn FOR 
                        SELECT 
                            TENLOAIAN, 
                            COLUMN_1,COLUMN_2,COLUMN_3,COLUMN_4,
                            COLUMN_5,COLUMN_6,COLUMN_7,COLUMN_8,
                            COLUMN_9,COLUMN_10,COLUMN_11,COLUMN_12,
                            COLUMN_13,COLUMN_14,COLUMN_15
                        FROM (
                            SELECT 
                                TENLOAIAN,
                                COLUMN_1,COLUMN_2,COLUMN_3,COLUMN_4,
                                COLUMN_5,COLUMN_6,COLUMN_7,COLUMN_8,
                                COLUMN_9,COLUMN_10,COLUMN_11,COLUMN_12,
                                COLUMN_13,COLUMN_14,COLUMN_15
                            FROM TABLE(V_TABLE_ALL)
                        
                            UNION ALL
                        
                            SELECT 
                                'Tổng' as TENLOAIAN,
                                SUM(COLUMN_1),SUM(COLUMN_2),SUM(COLUMN_3),SUM(COLUMN_4),
                                SUM(COLUMN_5),SUM(COLUMN_6),SUM(COLUMN_7),SUM(COLUMN_8),
                                SUM(COLUMN_9),SUM(COLUMN_10),SUM(COLUMN_11),SUM(COLUMN_12),
                                SUM(COLUMN_13),SUM(COLUMN_14),SUM(COLUMN_15)
                            FROM TABLE(V_TABLE_ALL)
                        )
                        ORDER BY 
                            CASE 
                                WHEN TENLOAIAN = 'Tổng' THEN 0
                                WHEN TENLOAIAN = 'Hình sự' THEN 1
                                WHEN TENLOAIAN = 'Dân sự' THEN 2
                                WHEN TENLOAIAN = 'Hôn nhân và gia đình' THEN 3
                                WHEN TENLOAIAN = 'Kinh doanh, thương mại' THEN 4
                                WHEN TENLOAIAN = 'Lao động' THEN 5
                                WHEN TENLOAIAN = 'Hành chính' THEN 6
                                WHEN TENLOAIAN = 'Phá sản' THEN 7
                                ELSE 100
                            END;
    
END;

PROCEDURE DASHBOARD_GDT_QH_EXP
(  
    vToaAnID	in	VARCHAR2,
    vThamphanid in number,
    vTuNgay	in VARCHAR2,
    vDenNgay	in VARCHAR2,
    curReturn OUT sys_refcursor 
)
AS
    v_TIME_FROM VARCHAR2(50);v_TIME_TO VARCHAR2(50);  
    V_TABLE T_GDTTT_DASHBOARD_V2;
    V_TABLE_ALL T_GDTTT_DASHBOARD_V2;
    vvToaAnID NUMBER;
    vCursur sys_refcursor;

BEGIN
    v_table := T_GDTTT_DASHBOARD_V2();
    V_TABLE_ALL := T_GDTTT_DASHBOARD_V2();

    v_TIME_FROM:=to_date(trim(vTuNgay)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');
    v_TIME_TO:=to_date(trim(vDenNgay)||' 23:59:59','dd/MM/yyyy HH24:MI:SS');

               ----COLUMN_1-------Tổng số đơn Cũ chuyển sang	----------
               FOR item IN (
                        SELECT C.BAQD_LOAIAN TENLOAIAN,count(C.id) colnum_2
                         FROM (
                                 SELECT d.BAQD_LOAIAN,d.ID 
                                          FROM GDTTT_DON d 
                                          where 
                                          NVL(d.LOAIDON,0) NOT IN(4)
                                          AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                          AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                          AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                          AND D.ISTHULY = 1 
                                           AND d.CD_LOAI = 0
                                          AND  d.TL_NGAY < v_TIME_FROM                            
                                                 and ((d.BAQD_LOAIAN != 1 AND (  EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON DKQ   
                                                                    LEFT JOIN GDTTT_VUAN_KETQUA KQ ON DKQ.VUAN_KETQUA_ID = KQ.ID
                                                                    WHERE DKQ.DONID = D.ID
                                                                            AND DKQ.TRANGTHAI = 1
                                                                            AND KQ.GDQ_NGAY >= v_TIME_FROM)
                                                                            
                                                                            or
                                                                                not EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA DKQ   
                                                                                                        LEFT JOIN GDTTT_VUAN_KETQUA_DON KQ ON DKQ.ID = KQ.VUAN_KETQUA_ID
                                                                                                        WHERE KQ.DONID = D.ID)
                                                                            )
                                                                   )
                                                        or (d.BAQD_LOAIAN != 1 AND NOT EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON DKQ  
                                                                                                        WHERE DKQ.DONID = D.ID 
                                                                                                        AND DKQ.TRANGTHAI = 1))            
                                                         or (d.BAQD_LOAIAN = 1  AND NOT EXISTS(SELECT 'X' FROM GDTTT_VUAN v 
                                                                               WHERE v.ID = D.vuviecid and v.gqd_loaiketqua in (0,1,2,3,4))  )  
                                                         OR (d.BAQD_LOAIAN = 1  AND EXISTS(SELECT 'X' FROM GDTTT_VUAN v 
                                                                               WHERE v.ID = D.vuviecid and v.gqd_loaiketqua in (0,1,2,3,4)
                                                                                                        and v.GDQ_NGAY >= v_TIME_FROM)  )                      
                                                                    )
                                            and d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM 
                                                    where  TEM.ma like 'CV9.3%' OR TEM.ma like 'CV8.1%')
                                        AND d.id !=319292
                                    )C

                                GROUP BY  C.BAQD_LOAIAN

                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD_V2(
                        item.TENLOAIAN,
                        item.colnum_2,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0
                        );   
                END LOOP;
                
                ----COLUMN_2-------Tổng số đơn Mới thụ lý	---------- 
               FOR item IN (

                SELECT C.BAQD_LOAIAN TENLOAIAN,count(C.id) colnum_2
                         FROM (
                                SELECT d.BAQD_LOAIAN,d.ID 
                                          FROM GDTTT_DON d 
                                          where 
                                          NVL(d.LOAIDON,0) NOT IN(4)
                                          AND d.ngaytao>= to_Date('01/01/2024','dd/MM/yyyy')
                                          AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                          AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                          AND D.ISTHULY = 1  
                                          AND d.CD_LOAI = 0
                                          AND d.TL_NGAY between v_TIME_FROM and v_TIME_TO
                                            and d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM 
                                                    where  TEM.ma like 'CV9.3%' OR TEM.ma like 'CV8.1%')
                                    )C

                                GROUP BY  C.BAQD_LOAIAN

                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD_V2(
                        item.TENLOAIAN,0,
                        item.colnum_2,0,0,0,0,0,0,0,0,
                        0,0,0,0,0
                        );   
                END LOOP;
                
                ------COLUMN_3 Đã giải quyết xong
                FOR item IN ( SELECT d.toaanid
                                  ,d.BAQD_LOAIAN TENLOAIAN,count(D.id) colnum_3
                                  FROM GDTTT_DON d 
                                  where 
                                  NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao > to_Date('01/01/2024','dd/MM/yyyy')
                                  AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                  AND D.ISTHULY = 1
                                   AND d.CD_LOAI = 0
                                  AND( (d.BAQD_LOAIAN != 1 and  EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON DKQ   
                                                            LEFT JOIN GDTTT_VUAN_KETQUA KQ ON DKQ.VUAN_KETQUA_ID = KQ.ID
                                                            WHERE DKQ.DONID = D.ID 
                                                                AND DKQ.TRANGTHAI = 1
                                                                AND KQ.GDQ_NGAY between v_TIME_FROM and v_TIME_TO))

                                  OR (d.BAQD_LOAIAN  = 1 and ( EXISTS(SELECT 'X' FROM GDTTT_VUAN v 
                                                                                                        WHERE v.ID = D.vuviecid 
                                                                                                            and v.gqd_loaiketqua in (2,3,4) 
                                                                                                            and v.GDQ_NGAY between v_TIME_FROM and v_TIME_TO) ---XEP DON
                                                                               OR  EXISTS(SELECT 'X' FROM GDTTT_DON_TRALOI kqd 
                                                                                                        WHERE kqd.DONID = D.ID 
                                                                                                            and kqd.TYPETB in (3,4)
                                                                                                            and kqd.NGAY between v_TIME_FROM and v_TIME_TO 
                                                                                                            )    --TLD;KN                    
                                                                                )                                                                                            
                                                    )                                                                      
                                  )
                                            and d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM 
                                                    where  TEM.ma like 'CV9.3%' OR TEM.ma like 'CV8.1%')

                                  GROUP BY  d.toaanid,d.BAQD_LOAIAN
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD_V2(
                        item.TENLOAIAN,0,
                        0,item.colnum_3,0,0,0,0,0,0,0,
                        0,0,0,0,0
                        );   
                END LOOP;
      
--                ----COLUMN_4---------tra loi don--------
                FOR item IN ( SELECT d.toaanid
                                   ,d.BAQD_LOAIAN TENLOAIAN,count(D.id) colnum_4
                                  FROM GDTTT_DON d 
                                  where 
                                  NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                  AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                  AND D.ISTHULY = 1
                                   AND d.CD_LOAI = 0
                                  AND( (d.BAQD_LOAIAN  != 1 and  EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON KQD   
                                                            LEFT JOIN GDTTT_VUAN_KETQUA KQ ON KQD.VUAN_KETQUA_ID = KQ.ID 
                                                            WHERE KQD.DONID = D.ID 
                                                            AND KQ.GDQ_NGAY between v_TIME_FROM and v_TIME_TO
                                                            AND KQ.GQD_LOAIKETQUA = 0
                                                            AND KQD.TRANGTHAI = 1
                                                            )
                                                        )
                                   OR (d.BAQD_LOAIAN  = 1 and  EXISTS(SELECT 'X' FROM GDTTT_DON_TRALOI kqd 
                                                                                        WHERE kqd.DONID = D.ID 
                                                                                            and kqd.TYPETB in (3)
                                                                                            and kqd.NGAY between v_TIME_FROM and v_TIME_TO 
                                                                                            )    --TLD                   
                                                            )                                                                                                              
                                                    )
                                            and d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM 
                                                    where  TEM.ma like 'CV9.3%' OR TEM.ma like 'CV8.1%')                                                                      

                                  GROUP BY  d.toaanid,d.BAQD_LOAIAN
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD_V2(
                        item.TENLOAIAN,0,0,
                        0,item.colnum_4,0,0,0,0,0,0,
                        0,0,0,0,0
                        );   
                END LOOP;
--                 ----COLUMN_5---kn--------------
               FOR item IN ( SELECT d.toaanid
                                 ,d.BAQD_LOAIAN TENLOAIAN,count(D.id) colnum_5
                                  FROM GDTTT_DON d 
                                  where 
                                  NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                  AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                  AND D.ISTHULY = 1
                                   AND d.CD_LOAI = 0
                                  AND( (d.BAQD_LOAIAN  != 1 and  EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON KQD   
                                                            LEFT JOIN GDTTT_VUAN_KETQUA KQ ON KQD.VUAN_KETQUA_ID = KQ.ID
                                                            WHERE KQD.DONID = D.ID 
                                                            AND KQ.GDQ_NGAY between v_TIME_FROM and v_TIME_TO
                                                            AND KQ.GQD_LOAIKETQUA = 1
                                                            AND KQD.TRANGTHAI = 1
                                                            )
                                                        )
                                       OR (d.BAQD_LOAIAN  = 1 and  EXISTS(SELECT 'X' FROM GDTTT_DON_TRALOI kqd 
                                                                                            WHERE kqd.DONID = D.ID 
                                                                                                and kqd.TYPETB in (4)
                                                                                                and kqd.NGAY between v_TIME_FROM and v_TIME_TO 
                                                                                                )    --KN                   
                                                               )                                                                                                               
                                                    )
                                            and d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM 
                                                    where  TEM.ma like 'CV9.3%' OR TEM.ma like 'CV8.1%')                                                    
                                  GROUP BY  d.toaanid,d.BAQD_LOAIAN
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD_V2(
                        item.TENLOAIAN,0,0,0,0,
                        item.colnum_5,0,0,0,0,0,
                        0, 0,0,0,0
                        );   
                END LOOP;
--                 ----COLUMN_6----Xep don-------------
               FOR item IN ( SELECT d.toaanid
                                  ,d.BAQD_LOAIAN TENLOAIAN,count(D.id) colnum_6
                                  FROM GDTTT_DON d 
                                  where 
                                  NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                  AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                  AND D.ISTHULY = 1
                                   AND d.CD_LOAI = 0
                                  AND ( (d.BAQD_LOAIAN  != 1 and  EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON KQD   
                                                            LEFT JOIN GDTTT_VUAN_KETQUA KQ ON KQD.VUAN_KETQUA_ID = KQ.ID
                                                            WHERE KQD.DONID = D.ID 
                                                            AND KQ.GDQ_NGAY between v_TIME_FROM and v_TIME_TO
                                                            AND KQ.GQD_LOAIKETQUA IN (2,3,4)
                                                            AND KQD.TRANGTHAI = 1
                                                            )
                                                        )
                                          OR (d.BAQD_LOAIAN  = 1 and  EXISTS(SELECT 'X' FROM GDTTT_VUAN v 
                                                                            WHERE v.ID = D.vuviecid 
                                                                                and v.gqd_loaiketqua in (2,3,4) 
                                                                                and v.GDQ_NGAY between v_TIME_FROM and v_TIME_TO) ---XEP DON
                                                               )
                                            )
                                            and d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM 
                                                    where  TEM.ma like 'CV9.3%' OR TEM.ma like 'CV8.1%')
                                  GROUP BY  d.toaanid,d.BAQD_LOAIAN
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD_V2(
                        item.TENLOAIAN,0,0,0,0,
                        0,item.colnum_6,0,0,0,0,
                        0,0,0,0,0
                        );   
                END LOOP;

                -- ----COLUMN_7-----------------
               FOR item IN (
                    SELECT C.BAQD_LOAIAN TENLOAIAN,count(C.id) colnum_7
                              FROM(
                                SELECT d.BAQD_LOAIAN,d.ID
                                  FROM GDTTT_DON d 
                                    LEFT JOIN GDTTT_VUAN_KETQUA_DON DKQ ON DKQ.DONID = D.ID AND DKQ.TRANGTHAI = 1
                                    LEFT JOIN GDTTT_VUAN_KETQUA KQ ON DKQ.VUAN_KETQUA_ID = KQ.ID
                                  where 
                                  NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                  AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                  AND D.ISTHULY = 1
                                   AND d.CD_LOAI = 0
                                  AND d.TL_NGAY <= v_TIME_TO 
                                  AND d.BAQD_LOAIAN != 1 
                                  and (KQ.gqd_loaiketqua IS NULL OR KQ.GDQ_NGAY > v_TIME_TO)
                                            and d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM 
                                                    where  TEM.ma like 'CV9.3%' OR TEM.ma like 'CV8.1%')
                                 UNION
                               SELECT d.BAQD_LOAIAN,d.ID
                                  FROM GDTTT_DON d 
                                  LEFT JOIN GDTTT_VUAN V ON V.ID = D.VUVIECID
                                  where 
                                  NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                  AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                  AND D.ISTHULY = 1
                                   AND d.CD_LOAI = 0
                                  AND d.TL_NGAY <= v_TIME_TO 
                                  AND d.BAQD_LOAIAN = 1              
                                  and ( v.gqd_loaiketqua IS NULL 
                                        OR  v.GDQ_NGAY > v_TIME_to
                                        ) 
                                            and d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM 
                                                    where  TEM.ma like 'CV9.3%' OR TEM.ma like 'CV8.1%')  
                                 )C

                                  GROUP BY C.BAQD_LOAIAN   

                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD_V2(
                        item.TENLOAIAN,0,0,0,0,
                        0,0,item.colnum_7,0,0,0,
                        0,0,0,0,0
                        );   
                END LOOP;

--   ----COLUMN_8-----------------Tong phải xet xu
              FOR item IN (select c.TENLOAIAN, count(c.id) colnum_8 
                                from(
                                    SELECT d.toaanid,d.id
                                           ,d.LOAIAN TENLOAIAN
                                             FROM GDTTT_VUAN d  
                                      where 
                                      d.toaanid = vToaAnID --sau se truyen don vi vao
                                       AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)  
                                       AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                      AND (d.NGAYTHULYXXGDT between v_TIME_FROM and v_TIME_TO
                                           OR  (d.NGAYTHULYXXGDT < v_TIME_FROM and (d.XXGDTTT_NGAYQD is null OR to_char(d.XXGDTTT_NGAYQD,'dd/MM/yyyy') = '01/01/0001' ) )
                                           OR  (d.NGAYTHULYXXGDT < v_TIME_FROM and d.XXGDTTT_NGAYQD is not null and to_char(d.XXGDTTT_NGAYQD,'dd/MM/yyyy') != '01/01/0001' and d.XXGDTTT_NGAYQD >= v_TIME_FROM))     
                                      AND d.THAMQUYENXXGDT = 1
                                      AND d.NGAYTHULYXXGDT is not null
                                  And EXISTS(select 'X' from GDTTT_DON dd 
                                                        where dd.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM 
                                                                        where  TEM.ma like 'CV9.3%' OR TEM.ma like 'CV8.1%')
                                                            AND dd.VuViecID = d.ID)
                                      GROUP BY  d.toaanid,d.id,d.LOAIAN)C
                                    group by c.TENLOAIAN
                                  )
                LOOP
                         v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD_V2(
                        item.TENLOAIAN,0,0,0,0,
                        0,0,0,item.colnum_8,0,0
                        ,0,0,0,0,0
                        );   
                END LOOP;
 --            ----COLUMN_9----------------- Tong so kháng nghị CA
                FOR item IN ( select c.TENLOAIAN, count(c.id) colnum_9
                                from(
                                    SELECT d.toaanid,d.id
                                           ,d.LOAIAN TENLOAIAN
                                             FROM GDTTT_VUAN d  
                                      where 
                                      d.toaanid = vToaAnID --sau se truyen don vi vao
                                       AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)    
                                       AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                      AND (d.NGAYTHULYXXGDT between v_TIME_FROM and v_TIME_TO
                                           OR  (d.NGAYTHULYXXGDT < v_TIME_FROM and (d.XXGDTTT_NGAYQD is null OR to_char(d.XXGDTTT_NGAYQD,'dd/MM/yyyy') = '01/01/0001' )   )
                                           OR  (d.NGAYTHULYXXGDT < v_TIME_FROM and d.XXGDTTT_NGAYQD is not null  and to_char(d.XXGDTTT_NGAYQD,'dd/MM/yyyy') != '01/01/0001' and d.XXGDTTT_NGAYQD >= v_TIME_FROM))     
                                      AND NVL(d.TRUONGHOPTHULY,0) != 1
                                      AND d.THAMQUYENXXGDT = 1
                                  And EXISTS(select 'X' from GDTTT_DON dd 
                                                        where dd.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM 
                                                                        where  TEM.ma like 'CV9.3%' OR TEM.ma like 'CV8.1%')
                                                            AND dd.VuViecID = d.ID)
                                      GROUP BY  d.toaanid,d.id,d.LOAIAN)C
                                    group by c.TENLOAIAN   

                                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD_V2(
                        item.TENLOAIAN,0,0,0,0,
                        0,0,0,0,item.colnum_9,0,
                        0,0,0,0,0
                        );   
                END LOOP;
 --            ----COLUMN_10----------------- Tong so kháng nghị VKS  d.NGAYXUGIAMDOCTHAM is null
                FOR item IN (
                       select c.TENLOAIAN, count(c.id) colnum_10
                                from(
                                    SELECT d.toaanid,d.id
                                           ,d.LOAIAN TENLOAIAN
                                             FROM GDTTT_VUAN d  
                                      where 
                                      d.toaanid = vToaAnID --sau se truyen don vi vao
                                       AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)  
                                       AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                      AND (d.NGAYTHULYXXGDT between v_TIME_FROM and v_TIME_TO
                                           OR  (d.NGAYTHULYXXGDT < v_TIME_FROM 
                                                            and (d.XXGDTTT_NGAYQD is null OR to_char(d.XXGDTTT_NGAYQD,'dd/MM/yyyy') = '01/01/0001' ) )
                                           OR  (d.NGAYTHULYXXGDT < v_TIME_FROM and d.XXGDTTT_NGAYQD is not null and to_char(d.XXGDTTT_NGAYQD,'dd/MM/yyyy') != '01/01/0001'  and d.XXGDTTT_NGAYQD >= v_TIME_FROM))     
                                      AND NVL(d.TRUONGHOPTHULY,0) = 1
                                      AND d.THAMQUYENXXGDT = 1
                                  And EXISTS(select 'X' from GDTTT_DON d 
                                                        where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM 
                                                                        where  TEM.ma like 'CV9.3%' OR TEM.ma like 'CV8.1%')
                                                            AND d.VuViecID = d.ID)
                                      GROUP BY  d.toaanid,d.id,d.LOAIAN)C
                                    group by c.TENLOAIAN   
                           )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD_V2(
                        item.TENLOAIAN,0,0,0,0,
                        0,0,0,0,0,item.colnum_10,
                        0,0,0,0,0
                        );   
                END LOOP;  
--                ----COLUMN_11-----------------Đã  xét xử gdtt
              FOR item IN (                                     
                      select c.TENLOAIAN, count(c.id) colnum_11
                                from(
                                    SELECT d.toaanid,d.id
                                           ,d.LOAIAN TENLOAIAN
                                             FROM GDTTT_VUAN d  
                                      where 
                                      d.toaanid = vToaAnID --sau se truyen don vi vao
                                       AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)  
                                       AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                      --AND  EXISTS(select 'X' from gdttt_vuan_xetxugdttt kq where d.ID = kq.VUANID and NVL(kq.ishoan,0) = 0 and kq.NGAYMOPT between v_TIME_FROM and v_TIME_TO )
                                      AND ( d.XXGDTTT_NGAYQD between v_TIME_FROM and v_TIME_TO 
                                            OR d.ISRUTKN = 1)
                                      AND d.THAMQUYENXXGDT = 1
                                       AND d.NGAYTHULYXXGDT is not null
                                  And EXISTS(select 'X' from GDTTT_DON dd
                                                        where dd.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM 
                                                                        where  TEM.ma like 'CV9.3%' OR TEM.ma like 'CV8.1%')
                                                            AND dd.VuViecID = d.ID)
                                      GROUP BY  d.toaanid,d.id,d.LOAIAN)C
                                    group by c.TENLOAIAN       

                                  )
                LOOP
                         v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD_V2(
                        item.TENLOAIAN,0,0,0,0,
                        0,0,0,0,0,0,
                        item.colnum_11,0,0,0,0
                        );   
                END LOOP;                
 --                ----COLUMN_12-----------------Chua xét xử gdtt
              FOR item IN (     
                         select c.TENLOAIAN, count(c.id) colnum_12
                                from(
                                    SELECT d.toaanid,d.id
                                           ,d.LOAIAN TENLOAIAN
                                             FROM GDTTT_VUAN d  
                                      where 
                                      d.toaanid = vToaAnID --sau se truyen don vi vao
                                       AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)   
                                       AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                      AND (d.NGAYTHULYXXGDT between v_TIME_FROM and v_TIME_TO
                                           OR  (d.NGAYTHULYXXGDT < v_TIME_FROM and (d.XXGDTTT_NGAYQD is null OR to_char(d.XXGDTTT_NGAYQD,'dd/MM/yyyy') = '01/01/0001' ) )
                                           OR  (d.NGAYTHULYXXGDT < v_TIME_FROM and d.XXGDTTT_NGAYQD is not null and to_char(d.XXGDTTT_NGAYQD,'dd/MM/yyyy') != '01/01/0001' and d.XXGDTTT_NGAYQD >= v_TIME_FROM))     
                                      AND (NVL(d.ISRUTKN,0) = 0 ) 
                                      AND (d.XXGDTTT_NGAYQD is null OR to_char(d.XXGDTTT_NGAYQD,'dd/MM/yyyy') = '01/01/0001' ) 
                                       AND d.NGAYTHULYXXGDT is not null
                                      AND d.THAMQUYENXXGDT = 1
                                  And EXISTS(select 'X' from GDTTT_DON dd
                                                        where dd.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM 
                                                                        where  TEM.ma like 'CV9.3%' OR TEM.ma like 'CV8.1%')
                                                            AND dd.VuViecID = d.ID)
                                      GROUP BY  d.toaanid,d.id,d.LOAIAN)C
                                    group by c.TENLOAIAN               


                                  )
                LOOP
                         v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD_V2(
                        item.TENLOAIAN,0,0,0,0,
                        0,0,0,0,0,0,0,item.colnum_12,0
                        ,0,0
                        );   
                END LOOP;               

                FOR itemdv IN (SELECT LA.THUTU,TK.TENLOAIAN,la.loai_an_ten LOAIAN,
                                        sum(tk.COLUMN_1) COLUMN_1,sum(tk.COLUMN_2) COLUMN_2,
                                        sum(tk.COLUMN_3) COLUMN_3,sum(tk.COLUMN_4) COLUMN_4,
                                        sum(tk.COLUMN_5) COLUMN_5,sum(tk.COLUMN_6) COLUMN_6,
                                        sum(tk.COLUMN_7) COLUMN_7,sum(tk.COLUMN_8) COLUMN_8,
                                        sum(tk.COLUMN_9) COLUMN_9,sum(tk.COLUMN_10) COLUMN_10,
                                        sum(tk.COLUMN_11) COLUMN_11     ,
                                        sum(tk.COLUMN_12) COLUMN_12     ,
                                        sum(tk.COLUMN_13) COLUMN_13     ,
                                        sum(tk.COLUMN_14) COLUMN_14     ,
                                        sum(tk.COLUMN_15) COLUMN_15     
                                                  FROM table(v_table) tk 
                                                   LEFT JOIN DM_LOAIAN LA ON LA.ID=tk.TENLOAIAN                                                    
                                                        group by LA.THUTU,tk.TENLOAIAN,la.loai_an_ten ORDER BY LA.THUTU
                                    )

                LOOP
                        V_TABLE_ALL.extend;
                        V_TABLE_ALL(V_TABLE_ALL.count) := R_GDTTT_DASHBOARD_V2(
                            itemdv.LOAIAN,itemdv.COLUMN_1,itemdv.COLUMN_2,itemdv.COLUMN_3,itemdv.COLUMN_4,itemdv.COLUMN_5,itemdv.COLUMN_6,
                            itemdv.COLUMN_7,itemdv.COLUMN_8,itemdv.COLUMN_9,itemdv.COLUMN_10,itemdv.COLUMN_11,
                            itemdv.COLUMN_12,itemdv.COLUMN_13,itemdv.COLUMN_14,itemdv.COLUMN_15
                            ); 
                END LOOP;  

   --------------------------
   OPEN curReturn FOR 
                        SELECT 
                            TENLOAIAN, 
                            COLUMN_1,COLUMN_2,COLUMN_3,COLUMN_4,
                            COLUMN_5,COLUMN_6,COLUMN_7,COLUMN_8,
                            COLUMN_9,COLUMN_10,COLUMN_11,COLUMN_12,
                            COLUMN_13,COLUMN_14,COLUMN_15
                        FROM (
                            SELECT 
                                TENLOAIAN,
                                COLUMN_1,COLUMN_2,COLUMN_3,COLUMN_4,
                                COLUMN_5,COLUMN_6,COLUMN_7,COLUMN_8,
                                COLUMN_9,COLUMN_10,COLUMN_11,COLUMN_12,
                                COLUMN_13,COLUMN_14,COLUMN_15
                            FROM TABLE(V_TABLE_ALL)
                        
                            UNION ALL
                        
                            SELECT 
                                'Tổng' as TENLOAIAN,
                                SUM(COLUMN_1),SUM(COLUMN_2),SUM(COLUMN_3),SUM(COLUMN_4),
                                SUM(COLUMN_5),SUM(COLUMN_6),SUM(COLUMN_7),SUM(COLUMN_8),
                                SUM(COLUMN_9),SUM(COLUMN_10),SUM(COLUMN_11),SUM(COLUMN_12),
                                SUM(COLUMN_13),SUM(COLUMN_14),SUM(COLUMN_15)
                            FROM TABLE(V_TABLE_ALL)
                        )
                        ORDER BY 
                            CASE 
                                WHEN TENLOAIAN = 'Tổng' THEN 0
                                WHEN TENLOAIAN = 'Hình sự' THEN 1
                                WHEN TENLOAIAN = 'Dân sự' THEN 2
                                WHEN TENLOAIAN = 'Hôn nhân và gia đình' THEN 3
                                WHEN TENLOAIAN = 'Kinh doanh, thương mại' THEN 4
                                WHEN TENLOAIAN = 'Lao động' THEN 5
                                WHEN TENLOAIAN = 'Hành chính' THEN 6
                                WHEN TENLOAIAN = 'Phá sản' THEN 7
                                ELSE 100
                            END;
    
END;

PROCEDURE DASHBOARD_GDT_THOIHIEU_EXP
(  
    vToaAnID	in	VARCHAR2,
    vThamphanid in number,
    vTuNgay	in VARCHAR2,
    vDenNgay	in VARCHAR2,
    curReturn OUT sys_refcursor 
)
AS
    v_TIME_FROM VARCHAR2(50);v_TIME_TO VARCHAR2(50);  
    V_TABLE T_GDTTT_DASHBOARD_V2;
    V_TABLE_ALL T_GDTTT_DASHBOARD_V2;
    vvToaAnID NUMBER;
    vCursur sys_refcursor;

BEGIN
    v_table := T_GDTTT_DASHBOARD_V2();
    V_TABLE_ALL := T_GDTTT_DASHBOARD_V2();

    v_TIME_FROM:=to_date(trim(vTuNgay)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');
    v_TIME_TO:=to_date(trim(vDenNgay)||' 23:59:59','dd/MM/yyyy HH24:MI:SS');

               ----COLUMN_1-------Tổng số đơn Cũ chuyển sang	----------
               FOR item IN (
                        SELECT C.BAQD_LOAIAN TENLOAIAN,count(C.id) colnum_2
                         FROM (
                                 SELECT d.BAQD_LOAIAN,d.ID 
                                          FROM GDTTT_DON d 
                                          where 
                                          NVL(d.LOAIDON,0) NOT IN(4)
                                          AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                          AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                          AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                          AND D.ISTHULY = 1 
                                           AND d.CD_LOAI = 0
                                          AND  d.TL_NGAY < v_TIME_FROM                            
                                                 and ((d.BAQD_LOAIAN != 1 AND (  EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON DKQ   
                                                                    LEFT JOIN GDTTT_VUAN_KETQUA KQ ON DKQ.VUAN_KETQUA_ID = KQ.ID
                                                                    WHERE DKQ.DONID = D.ID
                                                                            AND DKQ.TRANGTHAI = 1
                                                                            AND KQ.GDQ_NGAY >= v_TIME_FROM)
                                                                        
                                                                            or
                                                                                not EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA DKQ   
                                                                                                        LEFT JOIN GDTTT_VUAN_KETQUA_DON KQ ON DKQ.ID = KQ.VUAN_KETQUA_ID
                                                                                                        WHERE KQ.DONID = D.ID)
                                                                                )
                                                                            )
                                                        or (d.BAQD_LOAIAN != 1 AND NOT EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON DKQ  
                                                                                                        WHERE DKQ.DONID = D.ID 
                                                                                                        AND DKQ.TRANGTHAI = 1))            
                                                         or (d.BAQD_LOAIAN = 1  AND NOT EXISTS(SELECT 'X' FROM GDTTT_VUAN v 
                                                                               WHERE v.ID = D.vuviecid and v.gqd_loaiketqua in (0,1,2,3,4))  )  
                                                         OR (d.BAQD_LOAIAN = 1  AND EXISTS(SELECT 'X' FROM GDTTT_VUAN v 
                                                                               WHERE v.ID = D.vuviecid and v.gqd_loaiketqua in (0,1,2,3,4)
                                                                                                        and v.GDQ_NGAY >= v_TIME_FROM)  )                      
                                                                    )
                                         AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(d.BAQD_LOAIAN,0), 
                                                        DECODE(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,2,d.BAQD_NGAYBA_ST,d.BAQD_NGAYBA_PT),
                                                        d.BAQD_NGAYBA_ST, CASE 
                                                                    WHEN d.ISTHULY = 1 AND d.ARR_DON_ID IS NOT NULL THEN 1 
                                                                    ELSE 0 
                                                                END,d.TL_NGAY)<90  
                                        AND d.id !=319292
                                    )C

                                GROUP BY  C.BAQD_LOAIAN

                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD_V2(
                        item.TENLOAIAN,
                        item.colnum_2,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0
                        );   
                END LOOP;
                
                ----COLUMN_2-------Tổng số đơn Mới thụ lý	---------- 
               FOR item IN (

                SELECT C.BAQD_LOAIAN TENLOAIAN,count(C.id) colnum_2
                         FROM (
                                SELECT d.BAQD_LOAIAN,d.ID 
                                          FROM GDTTT_DON d 
                                          where 
                                          NVL(d.LOAIDON,0) NOT IN(4)
                                          AND d.ngaytao>= to_Date('01/01/2024','dd/MM/yyyy')
                                          AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                          AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                          AND D.ISTHULY = 1  
                                          AND d.CD_LOAI = 0
                                          AND d.TL_NGAY between v_TIME_FROM and v_TIME_TO
                                         AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(d.BAQD_LOAIAN,0), 
                                                        DECODE(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,2,d.BAQD_NGAYBA_ST,d.BAQD_NGAYBA_PT),
                                                        d.BAQD_NGAYBA_ST, CASE 
                                                                    WHEN d.ISTHULY = 1 AND d.ARR_DON_ID IS NOT NULL THEN 1 
                                                                    ELSE 0 
                                                                END,d.TL_NGAY)<90  
                                    )C

                                GROUP BY  C.BAQD_LOAIAN

                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD_V2(
                        item.TENLOAIAN,0,
                        item.colnum_2,0,0,0,0,0,0,0,0,
                        0,0,0,0,0
                        );   
                END LOOP;
                
                ------COLUMN_3 Đã giải quyết xong
                FOR item IN ( SELECT d.toaanid
                                  ,d.BAQD_LOAIAN TENLOAIAN,count(D.id) colnum_3
                                  FROM GDTTT_DON d 
                                  where 
                                  NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao > to_Date('01/01/2024','dd/MM/yyyy')
                                  AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                  AND D.ISTHULY = 1
                                   AND d.CD_LOAI = 0
                                  AND( (d.BAQD_LOAIAN != 1 and  EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON DKQ   
                                                            LEFT JOIN GDTTT_VUAN_KETQUA KQ ON DKQ.VUAN_KETQUA_ID = KQ.ID
                                                            WHERE DKQ.DONID = D.ID 
                                                                AND DKQ.TRANGTHAI = 1
                                                                AND KQ.GDQ_NGAY between v_TIME_FROM and v_TIME_TO))

                                  OR (d.BAQD_LOAIAN  = 1 and ( EXISTS(SELECT 'X' FROM GDTTT_VUAN v 
                                                                                                        WHERE v.ID = D.vuviecid 
                                                                                                            and v.gqd_loaiketqua in (2,3,4) 
                                                                                                            and v.GDQ_NGAY between v_TIME_FROM and v_TIME_TO) ---XEP DON
                                                                               OR  EXISTS(SELECT 'X' FROM GDTTT_DON_TRALOI kqd 
                                                                                                        WHERE kqd.DONID = D.ID 
                                                                                                            and kqd.TYPETB in (3,4)
                                                                                                            and kqd.NGAY between v_TIME_FROM and v_TIME_TO 
                                                                                                            )    --TLD;KN                    
                                                                                )                                                                                            
                                                    )                                                                      
                                  )
                                         AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(d.BAQD_LOAIAN,0), 
                                                        DECODE(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,2,d.BAQD_NGAYBA_ST,d.BAQD_NGAYBA_PT),
                                                        d.BAQD_NGAYBA_ST, CASE 
                                                                    WHEN d.ISTHULY = 1 AND d.ARR_DON_ID IS NOT NULL THEN 1 
                                                                    ELSE 0 
                                                                END,d.TL_NGAY)<90  

                                  GROUP BY  d.toaanid,d.BAQD_LOAIAN
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD_V2(
                        item.TENLOAIAN,0,
                        0,item.colnum_3,0,0,0,0,0,0,0,
                        0,0,0,0,0
                        );   
                END LOOP;
      
--                ----COLUMN_4---------tra loi don--------
                FOR item IN ( SELECT d.toaanid
                                   ,d.BAQD_LOAIAN TENLOAIAN,count(D.id) colnum_4
                                  FROM GDTTT_DON d 
                                  where 
                                  NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                  AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                  AND D.ISTHULY = 1
                                   AND d.CD_LOAI = 0
                                  AND( (d.BAQD_LOAIAN  != 1 and  EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON KQD   
                                                            LEFT JOIN GDTTT_VUAN_KETQUA KQ ON KQD.VUAN_KETQUA_ID = KQ.ID 
                                                            WHERE KQD.DONID = D.ID 
                                                            AND KQ.GDQ_NGAY between v_TIME_FROM and v_TIME_TO
                                                            AND KQ.GQD_LOAIKETQUA = 0
                                                            AND KQD.TRANGTHAI = 1
                                                            )
                                                        )
                                   OR (d.BAQD_LOAIAN  = 1 and  EXISTS(SELECT 'X' FROM GDTTT_DON_TRALOI kqd 
                                                                                        WHERE kqd.DONID = D.ID 
                                                                                            and kqd.TYPETB in (3)
                                                                                            and kqd.NGAY between v_TIME_FROM and v_TIME_TO 
                                                                                            )    --TLD                   
                                                            )                                                                                                              
                                                    )
                                         AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(d.BAQD_LOAIAN,0), 
                                                        DECODE(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,2,d.BAQD_NGAYBA_ST,d.BAQD_NGAYBA_PT),
                                                        d.BAQD_NGAYBA_ST, CASE 
                                                                    WHEN d.ISTHULY = 1 AND d.ARR_DON_ID IS NOT NULL THEN 1 
                                                                    ELSE 0 
                                                                END,d.TL_NGAY)<90                                                                        

                                  GROUP BY  d.toaanid,d.BAQD_LOAIAN
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD_V2(
                        item.TENLOAIAN,0,0,
                        0,item.colnum_4,0,0,0,0,0,0,
                        0,0,0,0,0
                        );   
                END LOOP;
--                 ----COLUMN_5---kn--------------
               FOR item IN ( SELECT d.toaanid
                                 ,d.BAQD_LOAIAN TENLOAIAN,count(D.id) colnum_5
                                  FROM GDTTT_DON d 
                                  where 
                                  NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                  AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                  AND D.ISTHULY = 1
                                   AND d.CD_LOAI = 0
                                  AND( (d.BAQD_LOAIAN  != 1 and  EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON KQD   
                                                            LEFT JOIN GDTTT_VUAN_KETQUA KQ ON KQD.VUAN_KETQUA_ID = KQ.ID
                                                            WHERE KQD.DONID = D.ID 
                                                            AND KQ.GDQ_NGAY between v_TIME_FROM and v_TIME_TO
                                                            AND KQ.GQD_LOAIKETQUA = 1
                                                            AND KQD.TRANGTHAI = 1
                                                            )
                                                        )
                                       OR (d.BAQD_LOAIAN  = 1 and  EXISTS(SELECT 'X' FROM GDTTT_DON_TRALOI kqd 
                                                                                            WHERE kqd.DONID = D.ID 
                                                                                                and kqd.TYPETB in (4)
                                                                                                and kqd.NGAY between v_TIME_FROM and v_TIME_TO 
                                                                                                )    --KN                   
                                                               )                                                                                                               
                                                    )
                                         AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(d.BAQD_LOAIAN,0), 
                                                        DECODE(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,2,d.BAQD_NGAYBA_ST,d.BAQD_NGAYBA_PT),
                                                        d.BAQD_NGAYBA_ST, CASE 
                                                                    WHEN d.ISTHULY = 1 AND d.ARR_DON_ID IS NOT NULL THEN 1 
                                                                    ELSE 0 
                                                                END,d.TL_NGAY)<90                                                      
                                  GROUP BY  d.toaanid,d.BAQD_LOAIAN
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD_V2(
                        item.TENLOAIAN,0,0,0,0,
                        item.colnum_5,0,0,0,0,0,
                        0, 0,0,0,0
                        );   
                END LOOP;
--                 ----COLUMN_6----Xep don-------------
               FOR item IN ( SELECT d.toaanid
                                  ,d.BAQD_LOAIAN TENLOAIAN,count(D.id) colnum_6
                                  FROM GDTTT_DON d 
                                  where 
                                  NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                  AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                  AND D.ISTHULY = 1
                                   AND d.CD_LOAI = 0
                                  AND ( (d.BAQD_LOAIAN  != 1 and  EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON KQD   
                                                            LEFT JOIN GDTTT_VUAN_KETQUA KQ ON KQD.VUAN_KETQUA_ID = KQ.ID
                                                            WHERE KQD.DONID = D.ID 
                                                            AND KQ.GDQ_NGAY between v_TIME_FROM and v_TIME_TO
                                                            AND KQ.GQD_LOAIKETQUA IN (2,3,4)
                                                            AND KQD.TRANGTHAI = 1
                                                            )
                                                        )
                                          OR (d.BAQD_LOAIAN  = 1 and  EXISTS(SELECT 'X' FROM GDTTT_VUAN v 
                                                                            WHERE v.ID = D.vuviecid 
                                                                                and v.gqd_loaiketqua in (2,3,4) 
                                                                                and v.GDQ_NGAY between v_TIME_FROM and v_TIME_TO) ---XEP DON
                                                               )
                                            )
                                         AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(d.BAQD_LOAIAN,0), 
                                                        DECODE(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,2,d.BAQD_NGAYBA_ST,d.BAQD_NGAYBA_PT),
                                                        d.BAQD_NGAYBA_ST, CASE 
                                                                    WHEN d.ISTHULY = 1 AND d.ARR_DON_ID IS NOT NULL THEN 1 
                                                                    ELSE 0 
                                                                END,d.TL_NGAY)<90  
                                  GROUP BY  d.toaanid,d.BAQD_LOAIAN
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD_V2(
                        item.TENLOAIAN,0,0,0,0,
                        0,item.colnum_6,0,0,0,0,
                        0,0,0,0,0
                        );   
                END LOOP;

                -- ----COLUMN_7-----------------
               FOR item IN (
                    SELECT C.BAQD_LOAIAN TENLOAIAN,count(C.id) colnum_7
                              FROM(
                                SELECT d.BAQD_LOAIAN,d.ID
                                  FROM GDTTT_DON d 
                                    LEFT JOIN GDTTT_VUAN_KETQUA_DON DKQ ON DKQ.DONID = D.ID AND DKQ.TRANGTHAI = 1
                                    LEFT JOIN GDTTT_VUAN_KETQUA KQ ON DKQ.VUAN_KETQUA_ID = KQ.ID
                                  where 
                                  NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                  AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                  AND D.ISTHULY = 1
                                   AND d.CD_LOAI = 0
                                  AND d.TL_NGAY <= v_TIME_TO 
                                  AND d.BAQD_LOAIAN != 1 
                                  and (KQ.gqd_loaiketqua IS NULL OR KQ.GDQ_NGAY > v_TIME_TO)
                                         AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(d.BAQD_LOAIAN,0), 
                                                        DECODE(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,2,d.BAQD_NGAYBA_ST,d.BAQD_NGAYBA_PT),
                                                        d.BAQD_NGAYBA_ST, CASE 
                                                                    WHEN d.ISTHULY = 1 AND d.ARR_DON_ID IS NOT NULL THEN 1 
                                                                    ELSE 0 
                                                                END,d.TL_NGAY)<90  
                                 UNION
                               SELECT d.BAQD_LOAIAN,d.ID
                                  FROM GDTTT_DON d 
                                  LEFT JOIN GDTTT_VUAN V ON V.ID = D.VUVIECID
                                  where 
                                  NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                  AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                  AND D.ISTHULY = 1
                                   AND d.CD_LOAI = 0
                                  AND d.TL_NGAY <= v_TIME_TO 
                                  AND d.BAQD_LOAIAN = 1              
                                  and ( v.gqd_loaiketqua IS NULL 
                                        OR  v.GDQ_NGAY > v_TIME_TO
                                        )
                                         AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(d.BAQD_LOAIAN,0), 
                                                        DECODE(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,2,d.BAQD_NGAYBA_ST,d.BAQD_NGAYBA_PT),
                                                        d.BAQD_NGAYBA_ST, CASE 
                                                                    WHEN d.ISTHULY = 1 AND d.ARR_DON_ID IS NOT NULL THEN 1 
                                                                    ELSE 0 
                                                                END,d.TL_NGAY)<90     
                                 )C

                                  GROUP BY C.BAQD_LOAIAN   

                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD_V2(
                        item.TENLOAIAN,0,0,0,0,
                        0,0,item.colnum_7,0,0,0,
                        0,0,0,0,0
                        );   
                END LOOP;

--   ----COLUMN_8-----------------Tong phải xet xu
              FOR item IN (select c.TENLOAIAN, count(c.id) colnum_8 
                                from(
                                    SELECT d.toaanid,d.id
                                           ,d.LOAIAN TENLOAIAN
                                             FROM GDTTT_VUAN d  
                                      where 
                                      d.toaanid = vToaAnID --sau se truyen don vi vao
                                       AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)  
                                       AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                      AND (d.NGAYTHULYXXGDT between v_TIME_FROM and v_TIME_TO
                                           OR  (d.NGAYTHULYXXGDT < v_TIME_FROM and (d.XXGDTTT_NGAYQD is null OR to_char(d.XXGDTTT_NGAYQD,'dd/MM/yyyy') = '01/01/0001' ) )
                                           OR  (d.NGAYTHULYXXGDT < v_TIME_FROM and d.XXGDTTT_NGAYQD is not null and to_char(d.XXGDTTT_NGAYQD,'dd/MM/yyyy') != '01/01/0001' and d.XXGDTTT_NGAYQD >= v_TIME_FROM))     
                                      AND d.THAMQUYENXXGDT = 1
                                      AND d.NGAYTHULYXXGDT is not null
                                   AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(d.LoaiAn,0), 
                                                        DECODE(d.BAQD_CAPXETXU,4,d.NGAYQD,2,d.NGAYXUSOTHAM,d.NGAYXUPHUCTHAM),
                                                        d.NGAYXUSOTHAM, NVL(d.ThuLyLai_VuAnId, 0),d.NGAYTHULYDON)<90
                                      GROUP BY  d.toaanid,d.id,d.LOAIAN)C
                                    group by c.TENLOAIAN
                                  )
                LOOP
                         v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD_V2(
                        item.TENLOAIAN,0,0,0,0,
                        0,0,0,item.colnum_8,0,0
                        ,0,0,0,0,0
                        );   
                END LOOP;
 --            ----COLUMN_9----------------- Tong so kháng nghị CA
                FOR item IN ( select c.TENLOAIAN, count(c.id) colnum_9
                                from(
                                    SELECT d.toaanid,d.id
                                           ,d.LOAIAN TENLOAIAN
                                             FROM GDTTT_VUAN d  
                                      where 
                                      d.toaanid = vToaAnID --sau se truyen don vi vao
                                       AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)    
                                       AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                      AND (d.NGAYTHULYXXGDT between v_TIME_FROM and v_TIME_TO
                                           OR  (d.NGAYTHULYXXGDT < v_TIME_FROM and (d.XXGDTTT_NGAYQD is null OR to_char(d.XXGDTTT_NGAYQD,'dd/MM/yyyy') = '01/01/0001' )   )
                                           OR  (d.NGAYTHULYXXGDT < v_TIME_FROM and d.XXGDTTT_NGAYQD is not null  and to_char(d.XXGDTTT_NGAYQD,'dd/MM/yyyy') != '01/01/0001' and d.XXGDTTT_NGAYQD >= v_TIME_FROM))     
                                      AND NVL(d.TRUONGHOPTHULY,0) != 1
                                      AND d.THAMQUYENXXGDT = 1
                                   AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(d.LoaiAn,0), 
                                                        DECODE(d.BAQD_CAPXETXU,4,d.NGAYQD,2,d.NGAYXUSOTHAM,d.NGAYXUPHUCTHAM),
                                                        d.NGAYXUSOTHAM, NVL(d.ThuLyLai_VuAnId, 0),d.NGAYTHULYDON)<90
                                      GROUP BY  d.toaanid,d.id,d.LOAIAN)C
                                    group by c.TENLOAIAN   

                                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD_V2(
                        item.TENLOAIAN,0,0,0,0,
                        0,0,0,0,item.colnum_9,0,
                        0,0,0,0,0
                        );   
                END LOOP;
 --            ----COLUMN_10----------------- Tong so kháng nghị VKS  d.NGAYXUGIAMDOCTHAM is null
                FOR item IN (
                       select c.TENLOAIAN, count(c.id) colnum_10
                                from(
                                    SELECT d.toaanid,d.id
                                           ,d.LOAIAN TENLOAIAN
                                             FROM GDTTT_VUAN d  
                                      where 
                                      d.toaanid = vToaAnID --sau se truyen don vi vao
                                       AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)  
                                       AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                      AND (d.NGAYTHULYXXGDT between v_TIME_FROM and v_TIME_TO
                                           OR  (d.NGAYTHULYXXGDT < v_TIME_FROM 
                                                            and (d.XXGDTTT_NGAYQD is null OR to_char(d.XXGDTTT_NGAYQD,'dd/MM/yyyy') = '01/01/0001' ) )
                                           OR  (d.NGAYTHULYXXGDT < v_TIME_FROM and d.XXGDTTT_NGAYQD is not null and to_char(d.XXGDTTT_NGAYQD,'dd/MM/yyyy') != '01/01/0001'  and d.XXGDTTT_NGAYQD >= v_TIME_FROM))     
                                      AND NVL(d.TRUONGHOPTHULY,0) = 1
                                      AND d.THAMQUYENXXGDT = 1
                                   AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(d.LoaiAn,0), 
                                                        DECODE(d.BAQD_CAPXETXU,4,d.NGAYQD,2,d.NGAYXUSOTHAM,d.NGAYXUPHUCTHAM),
                                                        d.NGAYXUSOTHAM, NVL(d.ThuLyLai_VuAnId, 0),d.NGAYTHULYDON)<90
                                      GROUP BY  d.toaanid,d.id,d.LOAIAN)C
                                    group by c.TENLOAIAN   
                           )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD_V2(
                        item.TENLOAIAN,0,0,0,0,
                        0,0,0,0,0,item.colnum_10,
                        0,0,0,0,0
                        );   
                END LOOP;  
--                ----COLUMN_11-----------------Đã  xét xử gdtt
              FOR item IN (                                     
                      select c.TENLOAIAN, count(c.id) colnum_11
                                from(
                                    SELECT d.toaanid,d.id
                                           ,d.LOAIAN TENLOAIAN
                                             FROM GDTTT_VUAN d  
                                      where 
                                      d.toaanid = vToaAnID --sau se truyen don vi vao
                                       AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)  
                                       AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                      --AND  EXISTS(select 'X' from gdttt_vuan_xetxugdttt kq where d.ID = kq.VUANID and NVL(kq.ishoan,0) = 0 and kq.NGAYMOPT between v_TIME_FROM and v_TIME_TO )
                                      AND ( d.XXGDTTT_NGAYQD between v_TIME_FROM and v_TIME_TO 
                                            OR d.ISRUTKN = 1)
                                      AND d.THAMQUYENXXGDT = 1
                                       AND d.NGAYTHULYXXGDT is not null
                                   AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(d.LoaiAn,0), 
                                                        DECODE(d.BAQD_CAPXETXU,4,d.NGAYQD,2,d.NGAYXUSOTHAM,d.NGAYXUPHUCTHAM),
                                                        d.NGAYXUSOTHAM, NVL(d.ThuLyLai_VuAnId, 0),d.NGAYTHULYDON)<90
                                      GROUP BY  d.toaanid,d.id,d.LOAIAN)C
                                    group by c.TENLOAIAN       

                                  )
                LOOP
                         v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD_V2(
                        item.TENLOAIAN,0,0,0,0,
                        0,0,0,0,0,0,
                        item.colnum_11,0,0,0,0
                        );   
                END LOOP;                
 --                ----COLUMN_12-----------------Chua xét xử gdtt
              FOR item IN (     
                         select c.TENLOAIAN, count(c.id) colnum_12
                                from(
                                    SELECT d.toaanid,d.id
                                           ,d.LOAIAN TENLOAIAN
                                             FROM GDTTT_VUAN d  
                                      where 
                                      d.toaanid = vToaAnID --sau se truyen don vi vao
                                       AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)   
                                       AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                      AND (d.NGAYTHULYXXGDT between v_TIME_FROM and v_TIME_TO
                                           OR  (d.NGAYTHULYXXGDT < v_TIME_FROM and (d.XXGDTTT_NGAYQD is null OR to_char(d.XXGDTTT_NGAYQD,'dd/MM/yyyy') = '01/01/0001' ) )
                                           OR  (d.NGAYTHULYXXGDT < v_TIME_FROM and d.XXGDTTT_NGAYQD is not null and to_char(d.XXGDTTT_NGAYQD,'dd/MM/yyyy') != '01/01/0001' and d.XXGDTTT_NGAYQD >= v_TIME_FROM))     
                                      AND (NVL(d.ISRUTKN,0) = 0 ) 
                                      AND (d.XXGDTTT_NGAYQD is null OR to_char(d.XXGDTTT_NGAYQD,'dd/MM/yyyy') = '01/01/0001' ) 
                                       AND d.NGAYTHULYXXGDT is not null
                                      AND d.THAMQUYENXXGDT = 1
                                   AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(d.LoaiAn,0), 
                                                        DECODE(d.BAQD_CAPXETXU,4,d.NGAYQD,2,d.NGAYXUSOTHAM,d.NGAYXUPHUCTHAM),
                                                        d.NGAYXUSOTHAM, NVL(d.ThuLyLai_VuAnId, 0),d.NGAYTHULYDON)<90
                                      GROUP BY  d.toaanid,d.id,d.LOAIAN)C
                                    group by c.TENLOAIAN               


                                  )
                LOOP
                         v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD_V2(
                        item.TENLOAIAN,0,0,0,0,
                        0,0,0,0,0,0,0,item.colnum_12,0
                        ,0,0
                        );   
                END LOOP;               

                FOR itemdv IN (SELECT LA.THUTU,TK.TENLOAIAN,la.loai_an_ten LOAIAN,
                                        sum(tk.COLUMN_1) COLUMN_1,sum(tk.COLUMN_2) COLUMN_2,
                                        sum(tk.COLUMN_3) COLUMN_3,sum(tk.COLUMN_4) COLUMN_4,
                                        sum(tk.COLUMN_5) COLUMN_5,sum(tk.COLUMN_6) COLUMN_6,
                                        sum(tk.COLUMN_7) COLUMN_7,sum(tk.COLUMN_8) COLUMN_8,
                                        sum(tk.COLUMN_9) COLUMN_9,sum(tk.COLUMN_10) COLUMN_10,
                                        sum(tk.COLUMN_11) COLUMN_11     ,
                                        sum(tk.COLUMN_12) COLUMN_12     ,
                                        sum(tk.COLUMN_13) COLUMN_13     ,
                                        sum(tk.COLUMN_14) COLUMN_14     ,
                                        sum(tk.COLUMN_15) COLUMN_15     
                                                  FROM table(v_table) tk 
                                                   LEFT JOIN DM_LOAIAN LA ON LA.ID=tk.TENLOAIAN                                                    
                                                        group by LA.THUTU,tk.TENLOAIAN,la.loai_an_ten ORDER BY LA.THUTU
                                    )

                LOOP
                        V_TABLE_ALL.extend;
                        V_TABLE_ALL(V_TABLE_ALL.count) := R_GDTTT_DASHBOARD_V2(
                            itemdv.LOAIAN,itemdv.COLUMN_1,itemdv.COLUMN_2,itemdv.COLUMN_3,itemdv.COLUMN_4,itemdv.COLUMN_5,itemdv.COLUMN_6,
                            itemdv.COLUMN_7,itemdv.COLUMN_8,itemdv.COLUMN_9,itemdv.COLUMN_10,itemdv.COLUMN_11,
                            itemdv.COLUMN_12,itemdv.COLUMN_13,itemdv.COLUMN_14,itemdv.COLUMN_15
                            ); 
                END LOOP;  

   --------------------------
   OPEN curReturn FOR 
                        SELECT 
                            TENLOAIAN, 
                            COLUMN_1,COLUMN_2,COLUMN_3,COLUMN_4,
                            COLUMN_5,COLUMN_6,COLUMN_7,COLUMN_8,
                            COLUMN_9,COLUMN_10,COLUMN_11,COLUMN_12,
                            COLUMN_13,COLUMN_14,COLUMN_15
                        FROM (
                            SELECT 
                                TENLOAIAN,
                                COLUMN_1,COLUMN_2,COLUMN_3,COLUMN_4,
                                COLUMN_5,COLUMN_6,COLUMN_7,COLUMN_8,
                                COLUMN_9,COLUMN_10,COLUMN_11,COLUMN_12,
                                COLUMN_13,COLUMN_14,COLUMN_15
                            FROM TABLE(V_TABLE_ALL)
                        
                            UNION ALL
                        
                            SELECT 
                                'Tổng' as TENLOAIAN,
                                SUM(COLUMN_1),SUM(COLUMN_2),SUM(COLUMN_3),SUM(COLUMN_4),
                                SUM(COLUMN_5),SUM(COLUMN_6),SUM(COLUMN_7),SUM(COLUMN_8),
                                SUM(COLUMN_9),SUM(COLUMN_10),SUM(COLUMN_11),SUM(COLUMN_12),
                                SUM(COLUMN_13),SUM(COLUMN_14),SUM(COLUMN_15)
                            FROM TABLE(V_TABLE_ALL)
                        )
                        ORDER BY 
                            CASE 
                                WHEN TENLOAIAN = 'Tổng' THEN 0
                                WHEN TENLOAIAN = 'Hình sự' THEN 1
                                WHEN TENLOAIAN = 'Dân sự' THEN 2
                                WHEN TENLOAIAN = 'Hôn nhân và gia đình' THEN 3
                                WHEN TENLOAIAN = 'Kinh doanh, thương mại' THEN 4
                                WHEN TENLOAIAN = 'Lao động' THEN 5
                                WHEN TENLOAIAN = 'Hành chính' THEN 6
                                WHEN TENLOAIAN = 'Phá sản' THEN 7
                                ELSE 100
                            END;
    
END;

PROCEDURE DASHBOARD_M1_VUGDKT
(  
    vToaAnID	in	VARCHAR2,
    vThamphanid in number,
    vTuNgay	in VARCHAR2,
    vDenNgay	in VARCHAR2,
    curReturn OUT sys_refcursor 
)
AS
    v_TIME_FROM VARCHAR2(50);v_TIME_TO VARCHAR2(50);  
    V_TABLE T_GDTTT_DASHBOARD_V2;
    V_TABLE_ALL T_GDTTT_DASHBOARD_V2;
    vvToaAnID NUMBER;
    vCursur sys_refcursor;

BEGIN
    v_table := T_GDTTT_DASHBOARD_V2();
    V_TABLE_ALL := T_GDTTT_DASHBOARD_V2();

    v_TIME_FROM:=to_date(trim(vTuNgay)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');
    v_TIME_TO:=to_date(trim(vDenNgay)||' 23:59:59','dd/MM/yyyy HH24:MI:SS');

               ----COLUMN_1-------Tổng số đơn Cũ chuyển sang----------
               FOR item IN (
                         SELECT C.PHONGBANID,count(C.id) colnum_1
                         FROM (
                                 SELECT PB.ID PHONGBANID,d.ID 
                                          FROM GDTTT_DON d 
                                                INNER JOIN GDTTT_VUAN V ON V.ID = D.VUVIECID
                                                INNER JOIN DM_PHONGBAN PB ON PB.ID = V.PHONGBANID
                                          where 
                                          NVL(d.LOAIDON,0) NOT IN(4)
                                          AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                          AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                          AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                          AND D.ISTHULY = 1 
                                           AND d.CD_LOAI = 0
                                          AND  d.TL_NGAY < v_TIME_FROM                            
                                                 and ((d.BAQD_LOAIAN != 1 AND (  EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON DKQ   
                                                                    LEFT JOIN GDTTT_VUAN_KETQUA KQ ON DKQ.VUAN_KETQUA_ID = KQ.ID
                                                                    WHERE DKQ.DONID = D.ID
                                                                            AND DKQ.TRANGTHAI = 1
                                                                            AND KQ.GDQ_NGAY >= v_TIME_FROM)
                                                                           
                                                                            or
                                                                                not EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA DKQ   
                                                                                                        LEFT JOIN GDTTT_VUAN_KETQUA_DON KQ ON DKQ.ID = KQ.VUAN_KETQUA_ID
                                                                                                        WHERE KQ.DONID = D.ID)
                                                                             )
                                                                            )
                                                        or (d.BAQD_LOAIAN != 1 AND NOT EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON DKQ  
                                                                                                        WHERE DKQ.DONID = D.ID 
                                                                                                        AND DKQ.TRANGTHAI = 1))            
                                                         or (d.BAQD_LOAIAN = 1  AND NOT EXISTS(SELECT 'X' FROM GDTTT_VUAN v 
                                                                               WHERE v.ID = D.vuviecid and v.gqd_loaiketqua in (0,1,2,3,4))  )  
                                                         OR (d.BAQD_LOAIAN = 1  AND EXISTS(SELECT 'X' FROM GDTTT_VUAN v 
                                                                               WHERE v.ID = D.vuviecid and v.gqd_loaiketqua in (0,1,2,3,4)
                                                                                                        and v.GDQ_NGAY >= v_TIME_FROM)  )                      
                                                                    )
                                        AND d.id !=319292
                                    )C

                                GROUP BY  C.PHONGBANID

                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD_V2(
                        ITEM.PHONGBANID,
                        item.colnum_1,0,0,0,0,0,0,0,0,0
                        ,0,0,0,0,0
                        );   
                END LOOP;
                
                ----COLUMN_2-------Tổng số đơn Mới thụ lý---------- 
               FOR item IN (
                SELECT C.PHONGBANID,count(C.id) colnum_2
                         FROM (
                                SELECT PB.ID PHONGBANID,d.ID 
                                          FROM GDTTT_DON d 
                                                INNER JOIN GDTTT_VUAN V ON V.ID = D.VUVIECID
                                                INNER JOIN DM_PHONGBAN PB ON PB.ID = V.PHONGBANID
                                          where 
                                          NVL(d.LOAIDON,0) NOT IN(4)
                                          AND d.ngaytao>= to_Date('01/01/2024','dd/MM/yyyy')
                                          AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                          AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                          AND D.ISTHULY = 1  
                                          AND d.CD_LOAI = 0
                                          AND d.TL_NGAY between v_TIME_FROM and v_TIME_TO
                                    )C

                                GROUP BY  C.PHONGBANID

                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD_V2(
                        ITEM.PHONGBANID,0,
                        item.colnum_2,0,0,0,0,0,0,0,0
                        ,0,0,0,0,0
                        );   
                END LOOP;
                
                ------COLUMN_3 Đã giải quyết xong
                FOR item IN ( SELECT PB.ID PHONGBANID,count(D.id) colnum_3
                                  FROM GDTTT_DON d 
                                                INNER JOIN GDTTT_VUAN V ON V.ID = D.VUVIECID
                                                INNER JOIN DM_PHONGBAN PB ON PB.ID = V.PHONGBANID
                                  where 
                                  NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao > to_Date('01/01/2024','dd/MM/yyyy')
                                  AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                  AND D.ISTHULY = 1
                                   AND d.CD_LOAI = 0
                                  AND( (d.BAQD_LOAIAN != 1 and  EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON DKQ   
                                                            LEFT JOIN GDTTT_VUAN_KETQUA KQ ON DKQ.VUAN_KETQUA_ID = KQ.ID
                                                            WHERE DKQ.DONID = D.ID 
                                                                AND DKQ.TRANGTHAI = 1
                                                                AND KQ.GDQ_NGAY between v_TIME_FROM and v_TIME_TO))

                                  OR (d.BAQD_LOAIAN  = 1 and ( EXISTS(SELECT 'X' FROM GDTTT_VUAN v 
                                                                                                        WHERE v.ID = D.vuviecid 
                                                                                                            and v.gqd_loaiketqua in (2,3,4) 
                                                                                                            and v.GDQ_NGAY between v_TIME_FROM and v_TIME_TO) ---XEP DON
                                                                               OR  EXISTS(SELECT 'X' FROM GDTTT_DON_TRALOI kqd 
                                                                                                        WHERE kqd.DONID = D.ID 
                                                                                                            and kqd.TYPETB in (3,4)
                                                                                                            and kqd.NGAY between v_TIME_FROM and v_TIME_TO 
                                                                                                            )    --TLD;KN                    
                                                                                )                                                                                            
                                                    )                                                                      
                                  )

                                  GROUP BY  PB.ID
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD_V2(
                        ITEM.PHONGBANID,0,0,
                        item.colnum_3,0,0,0,0,0,0,0
                        ,0,0,0,0,0
                        );   
                END LOOP;
      
--                ----COLUMN_4---------Thẩm tra viên--------
                FOR item IN ( SELECT PB.ID PHONGBANID,count(D.id) colnum_4
                                  FROM GDTTT_DON d 
                                                INNER JOIN GDTTT_VUAN V ON V.ID = D.VUVIECID
                                                INNER JOIN DM_PHONGBAN PB ON PB.ID = V.PHONGBANID
                                  where 
                                  NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                  AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                  AND D.ISTHULY = 1
                                   AND d.CD_LOAI = 0
                                  AND( (d.BAQD_LOAIAN  != 1 and  EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON KQD   
                                                            LEFT JOIN GDTTT_VUAN_KETQUA KQ ON KQD.VUAN_KETQUA_ID = KQ.ID 
                                                            WHERE KQD.DONID = D.ID 
                                                            AND KQ.GDQ_NGAY between v_TIME_FROM and v_TIME_TO
                                                            AND KQ.GQD_LOAIKETQUA = 0
                                                            AND KQD.TRANGTHAI = 1
                                                            )
                                                        )
                                   OR (d.BAQD_LOAIAN  = 1 and  EXISTS(SELECT 'X' FROM GDTTT_DON_TRALOI kqd 
                                                                                        WHERE kqd.DONID = D.ID 
                                                                                            and kqd.TYPETB in (3)
                                                                                            and kqd.NGAY between v_TIME_FROM and v_TIME_TO 
                                                                                            )    --TLD                   
                                                            )                                                                                                              
                                                    )                                                                      

                                  GROUP BY  PB.ID
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD_V2(
                        ITEM.PHONGBANID,0,0,0,
                        item.colnum_4,0,0,0,0,0,0
                        ,0,0,0,0,0
                        );   
                END LOOP;
--                 ----COLUMN_5---LĐ Vụ đã giải quyết--------------
               FOR item IN ( 
                              SELECT C.PHONGBANID,count(C.id) colnum_5
                              FROM(
                                SELECT PB.ID PHONGBANID,d.ID
                                  FROM GDTTT_DON d 
                                                INNER JOIN GDTTT_VUAN V ON V.ID = D.VUVIECID
                                                INNER JOIN DM_PHONGBAN PB ON PB.ID = V.PHONGBANID
                                    LEFT JOIN GDTTT_VUAN_KETQUA_DON DKQ ON DKQ.DONID = D.ID AND DKQ.TRANGTHAI = 1
                                    LEFT JOIN GDTTT_VUAN_KETQUA KQ ON DKQ.VUAN_KETQUA_ID = KQ.ID
                                  where 
                                  NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                  AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                  AND D.ISTHULY = 1
                                   AND d.CD_LOAI = 0
                                  AND d.TL_NGAY <= v_TIME_TO 
                                  And exists ( select 'x' from GDTTT_TOTRINH tt where tt.vuanid = d.VUVIECID and tt.TINHTRANGID in (9,17) -- 9 -Báo cáo Tổ Thẩm phán; 17 - Báo cáo Hội đồng thẩm phán
                                                                                                                                                                  and tt.NGAYTRINH is not null and tt.NGAYTRA is null)
                                 )C

                                  GROUP BY C.PHONGBANID   
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD_V2(
                        ITEM.PHONGBANID,0,0,0,0,
                        item.colnum_5,0,0,0,0,0
                        ,0,0,0,0,0
                        );   
                END LOOP;
--                 ----COLUMN_6----LĐ Vụ Còn lại-------------
               FOR item IN ( 
                              SELECT C.PHONGBANID,count(C.id) colnum_6
                              FROM(
                                SELECT PB.ID PHONGBANID,d.ID
                                  FROM GDTTT_DON d 
                                                INNER JOIN GDTTT_VUAN V ON V.ID = D.VUVIECID
                                                INNER JOIN DM_PHONGBAN PB ON PB.ID = V.PHONGBANID
                                    LEFT JOIN GDTTT_VUAN_KETQUA_DON DKQ ON DKQ.DONID = D.ID AND DKQ.TRANGTHAI = 1
                                    LEFT JOIN GDTTT_VUAN_KETQUA KQ ON DKQ.VUAN_KETQUA_ID = KQ.ID
                                  where 
                                  NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                  AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                  AND D.ISTHULY = 1
                                   AND d.CD_LOAI = 0
                                  AND d.TL_NGAY <= v_TIME_TO 
                                  And exists ( select 'x' from GDTTT_TOTRINH tt where tt.vuanid = d.VUVIECID and tt.TINHTRANGID in (9,17) -- 9 -Báo cáo Tổ Thẩm phán; 17 - Báo cáo Hội đồng thẩm phán
                                                                                                                                                                  and tt.NGAYTRINH is not null and tt.NGAYTRA is null)
                                 )C

                                  GROUP BY C.PHONGBANID   
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD_V2(
                        ITEM.PHONGBANID,0,0,0,0,0,
                        item.colnum_6,0,0,0,0
                        ,0,0,0,0,0
                        );   
                END LOOP;

                -- ----COLUMN_7------TP đã giải quyết -----------
               FOR item IN (

                    SELECT C.PHONGBANID,count(C.id) colnum_7
                              FROM(
                                SELECT PB.ID PHONGBANID,d.ID
                                  FROM GDTTT_DON d 
                                                INNER JOIN GDTTT_VUAN V ON V.ID = D.VUVIECID
                                                INNER JOIN DM_PHONGBAN PB ON PB.ID = V.PHONGBANID
                                    LEFT JOIN GDTTT_VUAN_KETQUA_DON DKQ ON DKQ.DONID = D.ID AND DKQ.TRANGTHAI = 1
                                    LEFT JOIN GDTTT_VUAN_KETQUA KQ ON DKQ.VUAN_KETQUA_ID = KQ.ID
                                  where 
                                  NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                  AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                  AND D.ISTHULY = 1
                                   AND d.CD_LOAI = 0
                                  AND d.TL_NGAY <= v_TIME_TO 
                                  And exists ( select 'x' from GDTTT_TOTRINH tt where tt.vuanid = d.VUVIECID and tt.TINHTRANGID in (9,17) -- 9 -Báo cáo Tổ Thẩm phán; 17 - Báo cáo Hội đồng thẩm phán
                                                                                                                                                                  and tt.NGAYTRINH is not null and tt.NGAYTRA is null)
                                 )C

                                  GROUP BY C.PHONGBANID   

                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD_V2(
                        ITEM.PHONGBANID,0,0,0,0,0,0,
                        item.colnum_7,0,0,0
                        ,0,0,0,0,0
                        );   
                END LOOP;

--   ----COLUMN_8---------------TP còn lại
              FOR item IN (
                            SELECT C.PHONGBANID,count(C.id) colnum_8
                              FROM(
                                SELECT PB.ID PHONGBANID,d.ID
                                  FROM GDTTT_DON d 
                                                INNER JOIN GDTTT_VUAN V ON V.ID = D.VUVIECID
                                                INNER JOIN DM_PHONGBAN PB ON PB.ID = V.PHONGBANID
                                    LEFT JOIN GDTTT_VUAN_KETQUA_DON DKQ ON DKQ.DONID = D.ID AND DKQ.TRANGTHAI = 1
                                    LEFT JOIN GDTTT_VUAN_KETQUA KQ ON DKQ.VUAN_KETQUA_ID = KQ.ID
                                  where 
                                  NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                  AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                  AND D.ISTHULY = 1
                                   AND d.CD_LOAI = 0
                                  AND d.TL_NGAY <= v_TIME_TO 
                                  And exists ( select 'x' from GDTTT_TOTRINH tt where tt.vuanid = d.VUVIECID and tt.TINHTRANGID in (9,17) -- 9 -Báo cáo Tổ Thẩm phán; 17 - Báo cáo Hội đồng thẩm phán
                                                                                                                                                                  and tt.NGAYTRINH is not null and tt.NGAYTRA is null)
                                 )C

                                  GROUP BY C.PHONGBANID   
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD_V2(
                        ITEM.PHONGBANID,0,0,0,0,0,0,0,
                        item.colnum_8,0,0
                        ,0,0,0,0,0
                        );   
                END LOOP;
 --            ----COLUMN_9-----------------PCA đã giải quyết
                FOR item IN ( 
                            SELECT C.PHONGBANID,count(C.id) colnum_9
                              FROM(
                                SELECT PB.ID PHONGBANID,d.ID
                                  FROM GDTTT_DON d 
                                                INNER JOIN GDTTT_VUAN V ON V.ID = D.VUVIECID
                                                INNER JOIN DM_PHONGBAN PB ON PB.ID = V.PHONGBANID
                                    LEFT JOIN GDTTT_VUAN_KETQUA_DON DKQ ON DKQ.DONID = D.ID AND DKQ.TRANGTHAI = 1
                                    LEFT JOIN GDTTT_VUAN_KETQUA KQ ON DKQ.VUAN_KETQUA_ID = KQ.ID
                                  where 
                                  NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                  AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                  AND D.ISTHULY = 1
                                   AND d.CD_LOAI = 0
                                  AND d.TL_NGAY <= v_TIME_TO 
                                  And exists ( select 'x' from GDTTT_TOTRINH tt where tt.vuanid = d.VUVIECID and tt.TINHTRANGID in (9,17) -- 9 -Báo cáo Tổ Thẩm phán; 17 - Báo cáo Hội đồng thẩm phán
                                                                                                                                                                  and tt.NGAYTRINH is not null and tt.NGAYTRA is null)
                                 )C

                                  GROUP BY C.PHONGBANID   
                                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD_V2(
                        ITEM.PHONGBANID,0,0,0,0,0,0,0,0,
                        item.colnum_9,0
                        ,0,0,0,0,0
                        );   
                END LOOP;
 --            ----COLUMN_10-----------------PCA còn lại
                FOR item IN (
                    SELECT C.PHONGBANID,count(C.id) colnum_10
                              FROM(
                                SELECT PB.ID PHONGBANID,d.ID
                                  FROM GDTTT_DON d 
                                                INNER JOIN GDTTT_VUAN V ON V.ID = D.VUVIECID
                                                INNER JOIN DM_PHONGBAN PB ON PB.ID = V.PHONGBANID
                                    LEFT JOIN GDTTT_VUAN_KETQUA_DON DKQ ON DKQ.DONID = D.ID AND DKQ.TRANGTHAI = 1
                                    LEFT JOIN GDTTT_VUAN_KETQUA KQ ON DKQ.VUAN_KETQUA_ID = KQ.ID
                                  where 
                                  NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                  AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                  AND D.ISTHULY = 1
                                   AND d.CD_LOAI = 0
                                  AND d.TL_NGAY <= v_TIME_TO 
                                  And exists ( select 'x' from GDTTT_TOTRINH tt where tt.vuanid = d.VUVIECID and tt.TINHTRANGID in (9,17) -- 9 -Báo cáo Tổ Thẩm phán; 17 - Báo cáo Hội đồng thẩm phán
                                                                                                                                                                  and tt.NGAYTRINH is not null and tt.NGAYTRA is null)
                                 )C

                                  GROUP BY C.PHONGBANID   
                           )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD_V2(
                        ITEM.PHONGBANID
                        ,0,0,0,0,0,0,0,0,0,item.colnum_10
                        ,0,0,0,0,0
                        );   
                END LOOP;              

                FOR itemdv IN (SELECT TK.TENLOAIAN PHONGBANID,
                                        sum(tk.COLUMN_1) COLUMN_1,sum(tk.COLUMN_2) COLUMN_2,
                                        sum(tk.COLUMN_3) COLUMN_3,sum(tk.COLUMN_4) COLUMN_4,
                                        sum(tk.COLUMN_5) COLUMN_5,sum(tk.COLUMN_6) COLUMN_6,
                                        sum(tk.COLUMN_7) COLUMN_7,sum(tk.COLUMN_8) COLUMN_8,
                                        sum(tk.COLUMN_9) COLUMN_9,sum(tk.COLUMN_10) COLUMN_10,
                                        sum(tk.COLUMN_11) column_11,sum(tk.COLUMN_12) column_12,
                                        sum(tk.COLUMN_13) column_13,sum(tk.COLUMN_14) COLUMN_14
                                                  FROM table(v_table) tk 
                                                  Group by TK.TENLOAIAN
                                    )

                LOOP
                        V_TABLE_ALL.extend;
                        V_TABLE_ALL(V_TABLE_ALL.count) := R_GDTTT_DASHBOARD_V2(
                            itemdv.PHONGBANID,itemdv.COLUMN_1,itemdv.COLUMN_2,itemdv.COLUMN_3,itemdv.COLUMN_4,itemdv.COLUMN_5,itemdv.COLUMN_6,
                            itemdv.COLUMN_7,itemdv.COLUMN_8,itemdv.COLUMN_9,itemdv.COLUMN_10,itemdv.COLUMN_11,itemdv.COLUMN_12,itemdv.COLUMN_13,
                            itemdv.COLUMN_14,0
                            ); 
                END LOOP;  

   --------------------------
   OPEN curReturn FOR 
                            SELECT 
                                PB.TENPHONGBAN,
                                A.TENLOAIAN PHONGBANID,
                                sum(A.COLUMN_1) column_1,
                                sum(A.COLUMN_2) column_2,
                                sum(A.COLUMN_3) column_3,
                                sum(A.COLUMN_4) column_4,
                                sum(A.COLUMN_5) column_5,
                                sum(A.COLUMN_6) column_6,
                                sum(A.COLUMN_7) column_7,
                                sum(A.COLUMN_8) column_8,
                                sum(A.COLUMN_9) column_9,
                                sum(A.COLUMN_10) column_10,
                                sum(A.COLUMN_11) column_11,
                                sum(A.COLUMN_12) column_12,
                                sum(A.COLUMN_13) column_13,
                                sum(A.COLUMN_14) column_14
                            FROM TABLE(V_TABLE_ALL) A
                            INNER JOIN DM_PHONGBAN PB ON PB.ID = A.TENLOAIAN -- PHONGBANID
                            group by PB.TENPHONGBAN, A.TENLOAIAN
                        ;
    
END;



--PROCEDURE DASHBOARD_STPT_EXP
--(  
--    vToaAnID	in	VARCHAR2,
--    vTuNgay	in VARCHAR2,
--    vDenNgay	in VARCHAR2,
--    vTuNgayTruoc	in VARCHAR2,
--    vDenNgayTruoc	in VARCHAR2,
--    curReturn OUT sys_refcursor 
--)
--AS
--    v_TIME_FROM VARCHAR2(50);v_TIME_TO VARCHAR2(50);  
--    v_from_truoc date;v_to_truoc date;
--    V_TABLE T_GDTTT_DASHBOARD_V2;
--    V_TABLE_ALL T_GDTTT_DASHBOARD_V2;
--    v_table_qlta  T_GDTTT_DASHBOARD_V2;
--    v_table_ds T_TYLEGQ_CA;
--
--
--
--    vvToaAnID NUMBER;
--    vCursur sys_refcursor;
--    vTren50  NUMBER;vDuoi50  NUMBER;
--    vCheck number;
--    vTongCOLUMN_2 NUMBER:=0;vTongCOLUMN_3 NUMBER:=0;vTongCOLUMN_4 NUMBER:=0;vTongCOLUMN_5 NUMBER:=0;
--    vTongCOLUMN_6 NUMBER:=0;vTongCOLUMN_7 NUMBER:=0;vTongCOLUMN_8 NUMBER:=0;
--
--    vTongALLCOLUMN_2 NUMBER:=0;vTongALLCOLUMN_3 NUMBER:=0;vTongALLCOLUMN_4 NUMBER:=0;vTongALLCOLUMN_5 NUMBER:=0;
--    vTongALLCOLUMN_6 NUMBER:=0;vTongALLCOLUMN_7 NUMBER:=0;vTongALLCOLUMN_8 NUMBER:=0;
--
--    vViewhuyen varchar2(50);
--    vTongThuLy number; vTongGiaiQuyet number; vTongTren50 number; vTyLeLech number;
--    vTongThuLy_truoc number; vTongGiaiQuyet_truoc number;
--    vTyleTruoc number; vTyle number;
--    vTangGiam varchar2(10);
--    vTongSoDonvi number; 
--
--
--BEGIN
--    v_table := T_GDTTT_DASHBOARD_V2();
--    V_TABLE_ALL := T_GDTTT_DASHBOARD_V2();
--    v_table_qlta := T_GDTTT_DASHBOARD_V2(); 
--    v_table_ds := T_TYLEGQ_CA(); 
--
--    v_TIME_FROM:=to_date(trim(vTuNgay)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');
--    v_TIME_TO:=to_date(trim(vDenNgay)||' 23:59:59','dd/MM/yyyy HH24:MI:SS');
--
--    v_from_truoc:=TO_DATE(vTuNgayTruoc ||'00:00:00', 'dd/MM/yyyy hh24:mi:ss');
--    v_to_truoc:=TO_DATE(vDenNgayTruoc||'23:59:59', 'dd/MM/yyyy  hh24:mi:ss');      
--
--If(TO_NUMBER(VTOAANID) in (0,1)) THEN
--    VVTOAANID := 0;
--ELSE
--    VVTOAANID := TO_NUMBER(VTOAANID);
--END IF;
--
--               ----COLUMN_2-------Tổng số vụ án thụ lý sơ thẩm và phuc thẩm----------
--             SELECT count(v.toaanid) into vTongThuLy
--                                  FROM DASHBOARD_STPT v 
--                                  where 
--                                   (VVTOAANID = 0 or v.toaanid = vToaAnID)
--                                  AND (v.NGAYTHULY between v_TIME_FROM and v_TIME_TO
--                                        OR (v.NGAYTHULY < v_TIME_FROM and v.KQLOAI is null)
--                                        OR (v.NGAYTHULY < v_TIME_FROM and v.KQLOAI is not null and v.KQNGAY>= v_TIME_FROM)
--                                  );
--
--            SELECT count(v.toaanid) into vTongThuLy_truoc
--                                  FROM DASHBOARD_STPT v 
--                                  where 
--                                   (VVTOAANID = 0 or v.toaanid = vToaAnID)
--                                  AND (v.NGAYTHULY between v_from_truoc and v_to_truoc
--                                        OR (v.NGAYTHULY < v_from_truoc and v.KQLOAI is null)
--                                        OR (v.NGAYTHULY < v_from_truoc and v.KQLOAI is not null and v.KQNGAY>= v_from_truoc)
--                                  );
--
--                ------COLUMN_3 Tổng số giải quyết	
--              SELECT count(v.toaanid) into vTongGiaiQuyet
--                                  FROM DASHBOARD_STPT v 
--                                  where 
--                                    (VVTOAANID = 0 or v.toaanid = vToaAnID)
--                                    AND (v.KQNGAY between v_TIME_FROM and v_TIME_TO)
--                                    AND v.KQLOAI is not null
--                             ;
--
--              SELECT count(v.toaanid) into vTongGiaiQuyet_truoc
--                                  FROM DASHBOARD_STPT v 
--                                  where 
--                                    (VVTOAANID = 0 or v.toaanid = vToaAnID)
--                                    AND (v.KQNGAY between v_from_truoc and v_to_truoc)
--                                    AND v.KQLOAI is not null
--                             ;
--
--                     if (vTongThuLy > 0) then     
--                        vTyle :=   ROUND((vTongGiaiQuyet/vTongThuLy)*100,1);  
--                     else
--                        vTyle :=   0;  
--                     end if;
--
--                     if (vTongThuLy_truoc > 0) then
--                        vTyleTruoc:=ROUND((vTongGiaiQuyet_truoc/vTongThuLy_truoc)*100,1) ;   
--                     else
--                        vTyleTruoc:=0 ;   
--                     end if;
--
--                     vTyLeLech := vTyle - vTyleTruoc;
--                     if (vTyle > vTyleTruoc ) then
--                        vTangGiam := 'Tăng';
--                     else
--                        vTangGiam := 'Giảm';
--                     end if;
--
----    tren50,( 765 - v_count_ta) as duoi50
--             ----01.Tong so phai giai quyet trong ky-COLUMN_1---------
--                 FOR item_sum IN 
--                        ( SELECT C.COURT_ID, count(C.COURT_ID) COLUMN_1 FROM(
--                            select hs.TOAANID COURT_ID from GSCM.DASHBOARD_STPT hs 
--                                            LEFT JOIN GSCM.dm_toaan TA on ta.id=hs.toaanid
--                                                where
--                                                  (VVTOAANID = 0 or hs.TOAANID = vToaAnID)
--                                                  AND( hs.ngaythuly BETWEEN v_TIME_FROM and v_TIME_TO
--                                                         OR (hs.ngaythuly < v_TIME_FROM and hs.KQLOAI is null)
--                                                         OR (hs.ngaythuly < v_TIME_FROM and hs.KQLOAI is not null and  hs.KQNGAY >= v_TIME_FROM))
--                                                  AND ta.BAOCAO=1               
--
--                                    ) C
--                                  GROUP BY C.COURT_ID               
--                            )
--                    LOOP 
--                            v_table_qlta.extend;
--                            v_table_qlta(v_table_qlta.count) := R_GDTTT_DASHBOARD_V2(
--                                    item_sum.COURT_ID,
--                                    item_sum.COLUMN_1,0,0,0,0,0,0,0,0,
--                                    0,0
--                                    );   
--
--                    END LOOP;
--
--                 ----02.Tong so đã giai quyet trong ky-COLUMN_1---------2
--                     FOR item_sum IN 
--                        ( SELECT C.COURT_ID, count(C.COURT_ID) COLUMN_2 FROM(
--                            select hs.TOAANID COURT_ID from GSCM.DASHBOARD_STPT hs 
--                                            LEFT JOIN GSCM.dm_toaan TA on ta.id=hs.toaanid
--                                                where
--                                                  (VVTOAANID = 0 or hs.TOAANID = vToaAnID)
--                                                  AND hs.KQNGAY BETWEEN v_TIME_FROM and v_TIME_TO
--                                                  AND ta.BAOCAO=1               
--
--                                    ) C
--
--                                  GROUP BY C.COURT_ID               
--                            )
--                    LOOP 
--                            v_table_qlta.extend;
--                            v_table_qlta(v_table_qlta.count) := R_GDTTT_DASHBOARD_V2(
--                                    item_sum.COURT_ID,
--                                    0,item_sum.COLUMN_2,0,0,0,0,0,0,0,
--                                    0,0
--                                    );   
--
--                    END LOOP;  
--
--                --- 03. Tông giai quyet cua ky truoc
--                  FOR item_sum IN 
--                        ( SELECT C.COURT_ID, count(*) COLUMN_3 FROM(
--                            select hs.TOAANID COURT_ID from GSCM.DASHBOARD_STPT hs 
--                                            LEFT JOIN GSCM.dm_toaan TA on ta.id=hs.toaanid
--                                                where
--                                                  (VVTOAANID = 0 or hs.TOAANID = vToaAnID)
--                                                  AND( hs.ngaythuly BETWEEN v_from_truoc and v_to_truoc
--                                                         OR (hs.ngaythuly < v_from_truoc and hs.KQLOAI is null)
--                                                         OR (hs.ngaythuly < v_from_truoc and hs.KQLOAI is not null and  hs.KQNGAY >= v_from_truoc))
--                                                  AND ta.BAOCAO=1       
--                                    ) C
--
--                                  GROUP BY C.COURT_ID               
--                            )
--                    LOOP 
--                            v_table_qlta.extend;
--                            v_table_qlta(v_table_qlta.count) := R_GDTTT_DASHBOARD_V2(
--                                    item_sum.COURT_ID,
--                                    0,0,item_sum.COLUMN_3,0,0,0,0,0,0,
--                                    0,0
--                                    );   
--
--                    END LOOP; 
--
--                  ---- Tinh ty le tang hoac giam   
--
--
--
--            ----04.Tong so phai giai quyet trong ky truoc-COLUMN_4---------
--                     FOR item_sum IN 
--                        ( SELECT C.COURT_ID, count(C.COURT_ID) COLUMN_4 FROM(
--                            select hs.TOAANID COURT_ID from GSCM.DASHBOARD_STPT hs 
--                                            LEFT JOIN GSCM.dm_toaan TA on ta.id=hs.toaanid
--                                                where
--                                                  (VVTOAANID = 0 or hs.TOAANID = vToaAnID)
--                                                  AND hs.KQNGAY BETWEEN v_from_truoc and v_to_truoc
--                                                  AND ta.BAOCAO=1     
--                                    ) C
--
--                                  GROUP BY C.COURT_ID               
--                            )
--                    LOOP 
--                            v_table_qlta.extend;
--                            v_table_qlta(v_table_qlta.count) := R_GDTTT_DASHBOARD_V2(
--                                    item_sum.COURT_ID,
--                                    0,0,0,item_sum.COLUMN_4,0,0,0,0,0,
--                                    0,0
--                                    );   
--
--                    END LOOP;
--                  -----Dem don vi Giai quyet tren 50% va duo 50%  
--                   vTongTren50 := 0;
--                    FOR item in (  SELECT JM.TENLOAIAN,TA.MA_TEN,
--                                            SUM(JM.COLUMN_1)COLUMN_1,SUM(JM.COLUMN_2)COLUMN_2,                           
--                                            DECODE(SUM(JM.COLUMN_1),0,0
--                                                    ,ROUND((SUM(JM.COLUMN_2)/SUM(JM.COLUMN_1))*100,1)
--                                                    ) TYLE,
--                                            DECODE(SUM(JM.COLUMN_3),0,0
--                                                    ,ROUND((SUM(JM.COLUMN_4)/SUM(JM.COLUMN_3))*100,1)
--                                                    ) TYLE_TRUOC
--
--                                            FROM TABLE(v_table_qlta) JM
--                                            LEFT JOIN GSCM.dm_toaan TA ON TA.id=JM.TENLOAIAN
--                                      GROUP BY JM.TENLOAIAN,TA.MA_TEN)
--                    LOOP
--                         if(item.TYLE >= 50) then
--                            v_table_ds.extend;
--                            v_table_ds(v_table_ds.count) := R_TYLEGQ_CA(item.TENLOAIAN,'TREN50',item.TYLE,item.TYLE_TRUOC,0,0,0);
--                            vTongTren50 := vTongTren50 + 1;
--                         end if;
--
--                    END LOOP;  
--
-- select count(*) into vTongSoDonvi from dm_toaan where baocao = 1 and hieuluc = 1;
--   --------------------------
--   OPEN curReturn FOR 
--
--SELECT 
--    a.COLUMN_1, 
--    a.COLUMN_2, 
--    a.COLUMN_3, 
--    a.COLUMN_4,
--    DECODE(A.TYLE_KYHIENTAI, '.0' || ' %', '0%', '0.' || ' %', '0 %', A.TYLE_KYHIENTAI) COLUMN_5, -- Tỷ lệ kỳ hiện tại 
--    DECODE(A.TYLE_TANGGIAM, '.0' || ' %', '0 %', '0.' || ' %', '0 %', A.TYLE_TANGGIAM) AS TYLE_TANGGIAM, -- X % --Tỷ lệ so sánh
--    A.vTangGiam AS TANGGIAM, -- Thêm dòng này để đọc được giá trị Tăng/Giảm trong C#
--    DECODE(A.TYLE_KYTRUOC, '.0' || ' %', '0 %', '0.' || ' %', '0 %', A.TYLE_KYTRUOC) AS TYLE_KYTRUOC -- X % -- Kỳ trước
--
--FROM (
--        SELECT 
--            RTRIM(TO_CHAR(vTongThuLy, 'FM9G999G999D999', 'NLS_NUMERIC_CHARACTERS='',.'''), ',') AS COLUMN_1,
--            RTRIM(TO_CHAR(vTongGiaiQuyet, 'FM9G999G999D999', 'NLS_NUMERIC_CHARACTERS='',.'''), ',') AS COLUMN_2,
--            vTongTren50 AS COLUMN_3,
--            (vTongSoDonvi - vTongTren50) AS COLUMN_4,
--
--            vTangGiam, -- String Tăng hoặc Giảm
--
--            CASE 
--                WHEN ABS(vTyLe - vTyleTruoc) < 1 THEN TO_CHAR(ABS(vTyLe - vTyleTruoc), 'FM0.9') || ' %'
--                ELSE TO_CHAR(ABS(vTyLe - vTyleTruoc), 'FM999.0') || ' %'
--            END AS TYLE_TANGGIAM, -- String tăng hay giảm so với kỳ trước có %
--
--            CASE 
--                WHEN vTyleTruoc < 1 THEN TO_CHAR(vTyleTruoc, 'FM0.9') || ' %'
--                ELSE TO_CHAR(vTyleTruoc, 'FM999.0') || ' %'
--            END AS TYLE_KYTRUOC, -- String Tỷ lệ kỳ trước có % kỳ trước
--
--            CASE 
--                WHEN vTyLe < 1 THEN TO_CHAR(vTyLe, 'FM0.9') || ' %'
--                ELSE TO_CHAR(vTyLe, 'FM999.0') || ' %'
--            END AS TYLE_KYHIENTAI -- String Tỷ lệ tăng giảm có % kỳ hiện tai
--
--        FROM dual
--) a;   
--
--END;
--
--PROCEDURE DASHBOARD_M2_STPT
--(  
--    VTOAANID	IN	VARCHAR2,
--    VTUNGAY	IN VARCHAR2,
--    VDENNGAY	IN VARCHAR2,
--    VTUNGAYTRUOC	IN VARCHAR2,
--    VDENNGAYTRUOC	IN VARCHAR2,
--    VCOLUMN         IN VARCHAR2,
--    CURRETURN OUT SYS_REFCURSOR 
--)
--AS
--    V_TIME_FROM VARCHAR2(50);V_TIME_TO VARCHAR2(50);  
--    V_FROM_TRUOC DATE;
--    V_TO_TRUOC DATE;
--    V_TABLE T_GDTTT_DASHBOARD_V2;
--    V_TABLE_ALL T_GDTTT_DASHBOARD_V2;
--    V_TABLE_QLTA  T_GDTTT_DASHBOARD_V2;
--    V_TABLE_DS T_TYLEGQ_CA;
--
--VAR_ARRSX  NVARCHAR2(250);
--
--    VVTOAANID NUMBER;
--    VCURSUR SYS_REFCURSOR;
--    VTREN50  NUMBER;VDUOI50  NUMBER;
--    VCHECK NUMBER;
--    VTONGCOLUMN_2 NUMBER:=0;VTONGCOLUMN_3 NUMBER:=0;VTONGCOLUMN_4 NUMBER:=0;VTONGCOLUMN_5 NUMBER:=0;
--    VTONGCOLUMN_6 NUMBER:=0;VTONGCOLUMN_7 NUMBER:=0;VTONGCOLUMN_8 NUMBER:=0;
--
--    VTONGALLCOLUMN_2 NUMBER:=0;VTONGALLCOLUMN_3 NUMBER:=0;VTONGALLCOLUMN_4 NUMBER:=0;VTONGALLCOLUMN_5 NUMBER:=0;
--    VTONGALLCOLUMN_6 NUMBER:=0;VTONGALLCOLUMN_7 NUMBER:=0;VTONGALLCOLUMN_8 NUMBER:=0;
--
--    VVIEWHUYEN VARCHAR2(50);
--    VTONGTHULY NUMBER; VTONGGIAIQUYET NUMBER; VTONGTREN50 NUMBER; VTYLELECH NUMBER;
--    VTONGTHULY_TRUOC NUMBER; VTONGGIAIQUYET_TRUOC NUMBER;
--    VTYLETRUOC NUMBER; VTYLE NUMBER;
--    VTANGGIAM VARCHAR2(10);
--
--    VTONGSODONVI NUMBER; 
--BEGIN
--    V_TABLE := T_GDTTT_DASHBOARD_V2();
--    V_TABLE_ALL := T_GDTTT_DASHBOARD_V2();
--    V_TABLE_QLTA := T_GDTTT_DASHBOARD_V2(); 
--    V_TABLE_DS := T_TYLEGQ_CA(); 
--
--    V_TIME_FROM:=TO_DATE(TRIM(VTUNGAY)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');
--    V_TIME_TO:=TO_DATE(TRIM(VDENNGAY)||' 23:59:59','dd/MM/yyyy HH24:MI:SS');
--
--    V_FROM_TRUOC:=TO_DATE(VTUNGAYTRUOC ||'00:00:00', 'dd/MM/yyyy hh24:mi:ss');
--    V_TO_TRUOC:=TO_DATE(VDENNGAYTRUOC||'23:59:59', 'dd/MM/yyyy  hh24:mi:ss');      
--
--If(TO_NUMBER(VTOAANID) in (0,1)) THEN
--    VVTOAANID := 0;
--ELSE
--    VVTOAANID := TO_NUMBER(VTOAANID);
--END IF;
--
--IF TO_NUMBER(VTOAANID)>1 THEN -- Nếu không phải là tất cả hoặc Tòa án nhân dân tối cao
-- SELECT T.ARRSAPXEP INTO VAR_ARRSX FROM DM_TOAAN T WHERE T.ID=TO_NUMBER(VTOAANID);
--ELSE
--  VAR_ARRSX:='0';
--END IF;
--
--                ----COLUMN_2-------Tổng số vụ án thụ lý sơ thẩm và phuc thẩm----------
--             SELECT COUNT(V.TOAANID) INTO VTONGTHULY
--                                  FROM DASHBOARD_STPT V 
--                                  WHERE 
--                                   (VVTOAANID = 0 OR V.TOAANID = VTOAANID)
--                                  AND (V.NGAYTHULY BETWEEN V_TIME_FROM AND V_TIME_TO
--                                        OR (V.NGAYTHULY < V_TIME_FROM AND V.KQLOAI IS NULL)
--                                        OR (V.NGAYTHULY < V_TIME_FROM AND V.KQLOAI IS NOT NULL AND V.KQNGAY>= V_TIME_FROM)
--                                  );
--
--            SELECT COUNT(V.TOAANID) INTO VTONGTHULY_TRUOC
--                                  FROM DASHBOARD_STPT V 
--                                  WHERE 
--                                   (VVTOAANID = 0 OR V.TOAANID = VTOAANID)
--                                  AND (V.NGAYTHULY BETWEEN V_FROM_TRUOC AND V_TO_TRUOC
--                                        OR (V.NGAYTHULY < V_FROM_TRUOC AND V.KQLOAI IS NULL)
--                                        OR (V.NGAYTHULY < V_FROM_TRUOC AND V.KQLOAI IS NOT NULL AND V.KQNGAY>= V_FROM_TRUOC)
--                                  );
--
--                ------COLUMN_3 Tổng số giải quyết	
--              SELECT COUNT(V.TOAANID) INTO VTONGGIAIQUYET
--                                  FROM DASHBOARD_STPT V 
--                                  WHERE 
--                                    (VVTOAANID = 0 OR V.TOAANID = VTOAANID)
--                                    AND (V.KQNGAY BETWEEN V_TIME_FROM AND V_TIME_TO)
--                                    AND V.KQLOAI IS NOT NULL
--                             ;
--
--              SELECT COUNT(V.TOAANID) INTO VTONGGIAIQUYET_TRUOC
--                                  FROM DASHBOARD_STPT V 
--                                  WHERE 
--                                    (VVTOAANID = 0 OR V.TOAANID = VTOAANID)
--                                    AND (V.KQNGAY BETWEEN V_FROM_TRUOC AND V_TO_TRUOC)
--                                    AND V.KQLOAI IS NOT NULL
--                             ;
--
--                     IF (VTONGTHULY > 0) THEN     
--                        VTYLE :=   ROUND((VTONGGIAIQUYET/VTONGTHULY)*100,1);  
--                     ELSE
--                        VTYLE :=   0;  
--                     END IF;
--
--                     IF (VTONGTHULY_TRUOC > 0) THEN
--                        VTYLETRUOC:=ROUND((VTONGGIAIQUYET_TRUOC/VTONGTHULY_TRUOC)*100,1) ;   
--                     ELSE
--                        VTYLETRUOC:=0 ;   
--                     END IF;
--
--                     VTYLELECH := VTYLE - VTYLETRUOC;
--                     IF (VTYLE > VTYLETRUOC ) THEN
--                        VTANGGIAM := 'Tăng';
--                     ELSE
--                        VTANGGIAM := 'Giảm';
--                     END IF;
--
----    tren50,( 765 - v_count_ta) as duoi50
--             ----01.Tong so phai giai quyet trong ky-COLUMN_1---------
--                 FOR ITEM_SUM IN 
--                        ( SELECT C.COURT_ID, COUNT(C.COURT_ID) COLUMN_1 FROM(
--                            SELECT HS.TOAANID COURT_ID FROM GSCM.DASHBOARD_STPT HS 
--                                            LEFT JOIN GSCM.DM_TOAAN TA ON TA.ID=HS.TOAANID
--                                                WHERE
--                                                  (VVTOAANID = 0 OR HS.TOAANID = VTOAANID)
--                                                  AND( HS.NGAYTHULY BETWEEN V_TIME_FROM AND V_TIME_TO
--                                                         OR (HS.NGAYTHULY < V_TIME_FROM AND HS.KQLOAI IS NULL)
--                                                         OR (HS.NGAYTHULY < V_TIME_FROM AND HS.KQLOAI IS NOT NULL AND  HS.KQNGAY >= V_TIME_FROM))
--                                                  AND TA.BAOCAO=1               
--
--                                    ) C
--                                  GROUP BY C.COURT_ID               
--                            )
--                    LOOP 
--                            V_TABLE_QLTA.EXTEND;
--                            V_TABLE_QLTA(V_TABLE_QLTA.COUNT) := R_GDTTT_DASHBOARD_V2(
--                                    ITEM_SUM.COURT_ID,
--                                    ITEM_SUM.COLUMN_1,0,0,0,0,0,0,0,0,
--                                    0,0
--                                    );   
--
--                    END LOOP;
--
--                 ----02.Tong so đã giai quyet trong ky-COLUMN_1---------2
--                     FOR ITEM_SUM IN 
--                        ( SELECT C.COURT_ID, COUNT(C.COURT_ID) COLUMN_2 FROM(
--                            SELECT HS.TOAANID COURT_ID FROM GSCM.DASHBOARD_STPT HS 
--                                            LEFT JOIN GSCM.DM_TOAAN TA ON TA.ID=HS.TOAANID
--                                                WHERE
--                                                  (VVTOAANID = 0 OR HS.TOAANID = VTOAANID)
--                                                  AND HS.KQNGAY BETWEEN V_TIME_FROM AND V_TIME_TO
--                                                  AND TA.BAOCAO=1               
--
--                                    ) C
--
--                                  GROUP BY C.COURT_ID               
--                            )
--                    LOOP 
--                            V_TABLE_QLTA.EXTEND;
--                            V_TABLE_QLTA(V_TABLE_QLTA.COUNT) := R_GDTTT_DASHBOARD_V2(
--                                    ITEM_SUM.COURT_ID,
--                                    0,ITEM_SUM.COLUMN_2,0,0,0,0,0,0,0,
--                                    0,0
--                                    );   
--
--                    END LOOP;  
--
--                --- 03. Tông giai quyet cua ky truoc
--                  FOR ITEM_SUM IN 
--                        ( SELECT C.COURT_ID, COUNT(*) COLUMN_3 FROM(
--                            SELECT HS.TOAANID COURT_ID FROM GSCM.DASHBOARD_STPT HS 
--                                            LEFT JOIN GSCM.DM_TOAAN TA ON TA.ID=HS.TOAANID
--                                                WHERE
--                                                  (VVTOAANID = 0 OR HS.TOAANID = VTOAANID)
--                                                  AND( HS.NGAYTHULY BETWEEN V_FROM_TRUOC AND V_TO_TRUOC
--                                                         OR (HS.NGAYTHULY < V_FROM_TRUOC AND HS.KQLOAI IS NULL)
--                                                         OR (HS.NGAYTHULY < V_FROM_TRUOC AND HS.KQLOAI IS NOT NULL AND  HS.KQNGAY >= V_FROM_TRUOC))
--                                                  AND TA.BAOCAO=1       
--                                    ) C
--
--                                  GROUP BY C.COURT_ID               
--                            )
--                    LOOP 
--                            V_TABLE_QLTA.EXTEND;
--                            V_TABLE_QLTA(V_TABLE_QLTA.COUNT) := R_GDTTT_DASHBOARD_V2(
--                                    ITEM_SUM.COURT_ID,
--                                    0,0,ITEM_SUM.COLUMN_3,0,0,0,0,0,0,
--                                    0,0
--                                    );   
--
--                    END LOOP; 
--
--                  ---- Tinh ty le tang hoac giam   
--
--
--
--            ----04.Tong so phai giai quyet trong ky truoc-COLUMN_4---------
--                     FOR ITEM_SUM IN 
--                        ( SELECT C.COURT_ID, COUNT(C.COURT_ID) COLUMN_4 FROM(
--                            SELECT HS.TOAANID COURT_ID FROM GSCM.DASHBOARD_STPT HS 
--                                            LEFT JOIN GSCM.DM_TOAAN TA ON TA.ID=HS.TOAANID
--                                                WHERE
--                                                  (VVTOAANID = 0 OR HS.TOAANID = VTOAANID)
--                                                  AND HS.KQNGAY BETWEEN V_FROM_TRUOC AND V_TO_TRUOC
--                                                  AND TA.BAOCAO=1     
--                                    ) C
--
--                                  GROUP BY C.COURT_ID               
--                            )
--                    LOOP 
--                            V_TABLE_QLTA.EXTEND;
--                            V_TABLE_QLTA(V_TABLE_QLTA.COUNT) := R_GDTTT_DASHBOARD_V2(
--                                    ITEM_SUM.COURT_ID,
--                                    0,0,0,ITEM_SUM.COLUMN_4,0,0,0,0,0,
--                                    0,0
--                                    );   
--
--                    END LOOP;
--                  -----Dem don vi Giai quyet tren 50% va duo 50%  
--                   VTONGTREN50 := 0;
--                    FOR ITEM IN (  SELECT JM.TENLOAIAN,TA.MA_TEN,
--                                            SUM(JM.COLUMN_1)COLUMN_1,SUM(JM.COLUMN_2)COLUMN_2,                           
--                                            DECODE(SUM(JM.COLUMN_1),0,0
--                                                    ,ROUND((SUM(JM.COLUMN_2)/SUM(JM.COLUMN_1))*100,1)
--                                                    ) TYLE,
--                                            DECODE(SUM(JM.COLUMN_3),0,0
--                                                    ,ROUND((SUM(JM.COLUMN_4)/SUM(JM.COLUMN_3))*100,1)
--                                                    ) TYLE_TRUOC
--
--                                            FROM TABLE(V_TABLE_QLTA) JM
--                                            LEFT JOIN GSCM.DM_TOAAN TA ON TA.ID=JM.TENLOAIAN
--                                      GROUP BY JM.TENLOAIAN,TA.MA_TEN)
--                    LOOP                   
--                         --vTyLeLech := vTyle - vTyleTruoc;
--                         IF (ITEM.TYLE > ITEM.TYLE_TRUOC ) THEN
--                            VTANGGIAM := '0';
--                         ELSE
--                            VTANGGIAM := '1';
--                         END IF;
--
--                         IF(ITEM.TYLE >= 50) THEN
--                            V_TABLE_DS.EXTEND;
--                            V_TABLE_DS(V_TABLE_DS.COUNT) := R_TYLEGQ_CA(ITEM.TENLOAIAN,'TREN50',ITEM.COLUMN_1,ITEM.COLUMN_2, ITEM.TYLE,ITEM.TYLE_TRUOC,TO_NUMBER(VTANGGIAM));
--                         ELSE
--                            V_TABLE_DS.EXTEND;
--                            V_TABLE_DS(V_TABLE_DS.COUNT) := R_TYLEGQ_CA(ITEM.TENLOAIAN,'DUOI50',ITEM.COLUMN_1,ITEM.COLUMN_2,ITEM.TYLE,ITEM.TYLE_TRUOC,TO_NUMBER(VTANGGIAM));
--                         END IF;
--
--                    END LOOP;  
--
--
--   OPEN CURRETURN FOR
--
--SELECT 
--A.LOAITOA,
--A.TEN,
--    a.COLUMN_1, 
--    a.COLUMN_2, 
--    DECODE(A.TYLE_KYHIENTAI, '.0' || ' %', '0%', '0.' || ' %', '0 %', A.TYLE_KYHIENTAI) COLUMN_3, -- Tỷ lệ kỳ hiện tại 
--    A.TANGGIAM, -- Thêm dòng này để đọc được giá trị Tăng/Giảm trong C#
--    DECODE(A.TYLE_TANGGIAM, '.0' || ' %', '0 %', '0.' || ' %', '0 %', A.TYLE_TANGGIAM) AS TYLE_TANGGIAM, -- X % --Tỷ lệ so sánh
--    DECODE(A.TYLE_KYTRUOC, '.0' || ' %', '0 %', '0.' || ' %', '0 %', A.TYLE_KYTRUOC) AS TYLE_KYTRUOC -- X % -- Kỳ trước
--FROM (
--                SELECT DMTA.LOAITOA,
--                       DMTA.MA_TEN TEN,
--                       A.COURT_ID, 
--                       Rtrim(to_char(A.COLUMN_1, 'FM9G999G999D999', 'NLS_NUMERIC_CHARACTERS='',.'''),',') AS COLUMN_1, -- Tổng số vụ án thụ lý
--                       Rtrim(to_char(A.COLUMN_2, 'FM9G999G999D999', 'NLS_NUMERIC_CHARACTERS='',.'''),',') AS COLUMN_2, -- Tổng số giải quyết
--
--                       CASE WHEN A.COLUMN_3 < 1 THEN TO_CHAR(A.COLUMN_3, 'FM0.9')|| ' %'
--                                ELSE TO_CHAR(A.COLUMN_3, 'FM999.0') || ' %'
--                                END AS TYLE_KYHIENTAI ,-- Tỷ lệ giải quyết 
--
--                       CASE WHEN A.COLUMN_4 < 1 THEN TO_CHAR(A.COLUMN_4, 'FM0.9')|| ' %'
--                                ELSE TO_CHAR(A.COLUMN_4, 'FM999.0') || ' %'
--                                END AS TYLE_KYTRUOC , -- Tỷ lệ giải quyết kỳ trước
--
--                       CASE WHEN ABS(A.COLUMN_3 - A.COLUMN_4) < 1 THEN TO_CHAR(ABS(A.COLUMN_3 - A.COLUMN_4), 'FM0.9')|| ' %'
--                                ELSE TO_CHAR(ABS(A.COLUMN_3 - A.COLUMN_4), 'FM999.0') || ' %'
--                                END AS TYLE_TANGGIAM , -- Tỷ lệ tăng giảm 
--
--                       DECODE(A.COLUMN_5,0,'Tăng',1,'Giảm') TANGGIAM -- Giải quyết so với cùng kỳ
--
--                FROM TABLE(V_TABLE_DS) A
--                    INNER JOIN (SELECT T.ID,T.MA,T.TEN,T.MA_TEN, T.LOAITOA,T.CAPCHAID, T.ARRSAPXEP,
--                                          ((CASE T.SOCAP WHEN 1 THEN '' WHEN 2 THEN '..' WHEN 3 THEN '....'  WHEN 4 THEN '......' END) || T.MA_TEN) AS ARRTEN,
--                                          CASE WHEN ROWNUM =1 THEN T.TEN WHEN ROWNUM>1 THEN '...'||T.TEN END AS TENDONVI
--                                    FROM DM_TOAAN T
--                                    WHERE T.HIEULUC=1 AND 
--                                     (T.ARRSAPXEP LIKE (VAR_ARRSX ||'/%') OR T.ARRSAPXEP=VAR_ARRSX )
--                                    ORDER BY T.ARRTHUTU) DMTA ON DMTA.ID = A.COURT_ID
--                    LEFT JOIN DM_TOAAN DMTACAPCHA ON DMTACAPCHA.ID = DMTA.CAPCHAID
--                WHERE (VCOLUMN LIKE '1') OR
--                      (VCOLUMN LIKE '2') OR 
--                      (VCOLUMN LIKE '3' AND COLUMN_3 >= 50) OR
--                      (VCOLUMN LIKE '4' AND COLUMN_3 < 50) OR
--                      (VCOLUMN LIKE '5') OR
--                      (VCOLUMN LIKE '7')
--
--                ORDER BY 
--                -- Sắp xếp loại tòa (Tòa cấp cao lên đầu)
--                CASE DMTA.LOAITOA
--                    WHEN 'CAPCAO' THEN 1    -- Tòa cấp cao lên đầu
--                    ELSE 4                  -- Các trường hợp khác
--                END,
--
--                CASE VCOLUMN WHEN '1' THEN A.COLUMN_1 -- Tổng số vụ án thụ lý
--                             WHEN '2' THEN A.COLUMN_2 -- Tổng số giải quyết
--                             WHEN '3' THEN A.COLUMN_3 -- Tỷ lệ giải quyết
--                             WHEN '4' THEN A.COLUMN_3 -- Tỷ lệ giải quyết
--                             WHEN '5' THEN A.COLUMN_3 -- Tỷ lệ giải quyết
--                             WHEN '7' THEN A.COLUMN_3 -- Tỷ lệ giải quyết so với cùng kỳ
--                    END DESC
--                    ) A;  
--
--END;

END PKG_DASHBOARD_UPDATE_V2;

/
