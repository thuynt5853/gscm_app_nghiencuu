create or replace NONEDITIONABLE PACKAGE BODY PKG_VGDKT_BAOCAO_V2 AS
FUNCTION BC_VGDKT_24
( 
    V_CANBO_TK_ID  IN VARCHAR2,
    V_LANHDAO_TK_ID  IN VARCHAR2,
    vToaAnID in number,
    vPhongBanID  in number,
    vTuNgay in date,
    vDenNgay in date,
    vLanhDaoID number
)
RETURN T_BC_TP_THULY_GQ
IS 
            v_table T_BC_TP_THULY_GQ;
BEGIN
            v_table := T_BC_TP_THULY_GQ(); 
            -----------------
             FOR item_tp IN (
                SELECT V.THAMPHANID,CB.HOTEN FROM GDTTT_VUAN V
               -- SELECT  d.THAMPHANID ,CB.HOTEN FROM GDTTT_DON d
                LEFT JOIN DM_CANBO CB ON CB.ID= V.THAMPHANID
                WHERE  V.TOAANID=vToaAnID and CB.chucdanhid in(486,2318)--486 TPTATC,2318 TPBAC3
                AND V.PHONGBANID=vPhongBanID
                AND  V.THAMPHANID!=0 AND V.THAMPHANID IS NOT NULL
                AND ( V.NGAYTAO>=vTuNgay AND  V.NGAYTAO<=vDenNgay)
                GROUP BY  V.THAMPHANID,CB.HOTEN
              )
             LOOP
             --cũ còn lại
              FOR item IN (
                    SELECT count(C.id) TONG  FROM 
                    ( SELECT d.THAMPHANID,d.ID 
                      FROM GDTTT_DON d 
                      --LEFT JOIN GDTTT_VUAN V ON V.ID=D.VUVIECID
                      where  NVL(d.LOAIDON,0) NOT IN(4)  AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                      AND d.toaanid = vToaAnID --sau se truyen don vi vao
                      AND  d.THAMPHANID = item_tp.THAMPHANID
                      AND D.ISTHULY = 1  AND d.CD_LOAI = 0                                         
                      AND  d.TL_NGAY < vTuNgay 
                          AND ((nvl(d.BAQD_LOAIAN,0) != 1 
                                    AND (  EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON DKQ   
                                            LEFT JOIN GDTTT_VUAN_KETQUA KQ ON DKQ.VUAN_KETQUA_ID = KQ.ID
                                            WHERE DKQ.DONID = D.ID AND DKQ.TRANGTHAI = 1  AND KQ.GDQ_NGAY >= vTuNgay)  or  not EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA DKQ   
                                            LEFT JOIN GDTTT_VUAN_KETQUA_DON KQ ON DKQ.ID = KQ.VUAN_KETQUA_ID
                                            WHERE KQ.DONID = D.ID)
                                        )
                                  )
                                 or (nvl(d.BAQD_LOAIAN,0) != 1 AND NOT EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON DKQ  WHERE DKQ.DONID = D.ID  AND DKQ.TRANGTHAI = 1) )
                                 or (nvl(d.BAQD_LOAIAN,0) = 1  AND NOT EXISTS(SELECT 'X' FROM GDTTT_VUAN v WHERE v.ID = D.vuviecid and v.gqd_loaiketqua in (0,1,2,3,4))  )  
                                 OR (nvl(d.BAQD_LOAIAN,0) = 1  AND EXISTS(SELECT 'X' FROM GDTTT_VUAN v  WHERE v.ID = D.vuviecid and v.gqd_loaiketqua in (0,1,2,3,4)and v.GDQ_NGAY >= vTuNgay)  )     
                          )
                      AND d.id !=319292
                    )C
                   )
                       LOOP
                         v_table.extend;
                         v_table(v_table.count) := R_BC_TP_THULY_GQ(item_tp.THAMPHANID,item.TONG,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
                END LOOP;
--                SELECT count(C.id) TONG
--                         FROM (
--                                 SELECT v.THAMPHANID,v.ID FROM GDTTT_VUAN v
--                                        left join GDTTT_DON d on d.vuviecid=v.id
--                                          where 
--                                          NVL(d.LOAIDON,0) NOT IN(4)
--                                          AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
--                                          AND d.toaanid = vToaAnID --sau se truyen don vi vao
--                                          AND  v.THAMPHANID = item_tp.THAMPHANID
--                                          AND D.ISTHULY = 1 
--                                          AND d.CD_LOAI = 0
--                                          AND  d.TL_NGAY < vTuNgay                            
--                                                 and ((nvl(d.BAQD_LOAIAN,0) != 1 AND (  EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON DKQ   
--                                                                    LEFT JOIN GDTTT_VUAN_KETQUA KQ ON DKQ.VUAN_KETQUA_ID = KQ.ID
--                                                                    WHERE DKQ.DONID = D.ID
--                                                                            AND DKQ.TRANGTHAI = 1
--                                                                            AND KQ.GDQ_NGAY >= vTuNgay)
--
--                                                                            or
--                                                                                not EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA DKQ   
--                                                                                                        LEFT JOIN GDTTT_VUAN_KETQUA_DON KQ ON DKQ.ID = KQ.VUAN_KETQUA_ID
--                                                                                                        WHERE KQ.DONID = D.ID)
--                                                                             )
--                                                                            )
--                                                        or (nvl(d.BAQD_LOAIAN,0) != 1 AND NOT EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON DKQ  
--                                                                                                        WHERE DKQ.DONID = D.ID 
--                                                                                                        AND DKQ.TRANGTHAI = 1))            
--                                                         or (nvl(d.BAQD_LOAIAN,0) = 1  AND NOT EXISTS(SELECT 'X' FROM GDTTT_VUAN v 
--                                                                               WHERE v.ID = D.vuviecid and v.gqd_loaiketqua in (0,1,2,3,4))  )  
--                                                         OR (nvl(d.BAQD_LOAIAN,0) = 1  AND EXISTS(SELECT 'X' FROM GDTTT_VUAN v 
--                                                                               WHERE v.ID = D.vuviecid and v.gqd_loaiketqua in (0,1,2,3,4)
--                                                                                                        and v.GDQ_NGAY >= vTuNgay)  )                      
--                                                                    )
--                                        AND d.id !=319292
--                                    )C

                -----------Mới thụ lý----------
               FOR item IN (
                SELECT count(C.id) TONG
                         FROM (
                                SELECT d.THAMPHANID,d.ID 
                                          FROM GDTTT_DON d 
                                          where 
                                          NVL(d.LOAIDON,0) NOT IN(4)
                                          AND d.ngaytao>= to_Date('01/01/2024','dd/MM/yyyy')
                                          AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                          AND d.THAMPHANID = item_tp.THAMPHANID
                                          AND D.ISTHULY = 1  
                                          AND d.CD_LOAI = 0
                                          AND d.TL_NGAY between vTuNgay and vDenNgay
                                    )C
                 )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_BC_TP_THULY_GQ(item_tp.THAMPHANID,0,item.TONG,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
                END LOOP;
             ------ Đã giải quyết xong
                FOR item IN 
                (
                SELECT count(V.id) TONG FROM GDTTT_VUAN V
                                  LEFT JOIN GDTTT_DON d ON D.vuviecid=v.id
                                  where 
                                  NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao > to_Date('01/01/2024','dd/MM/yyyy')
                                  AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND  V.THAMPHANID = item_tp.THAMPHANID
                                  AND D.ISTHULY = 1
                                   AND d.CD_LOAI = 0
                                  AND( (nvl(d.BAQD_LOAIAN,0) != 1 and  EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON DKQ   
                                                            LEFT JOIN GDTTT_VUAN_KETQUA KQ ON DKQ.VUAN_KETQUA_ID = KQ.ID
                                                            WHERE DKQ.DONID = D.ID 
                                                                AND DKQ.TRANGTHAI = 1
                                                                AND KQ.GQD_NGAYPHATHANHCV between vTuNgay and vDenNgay))

                                  OR (nvl(d.BAQD_LOAIAN,0)  = 1 and ( EXISTS(SELECT 'X' FROM GDTTT_VUAN v 
                                                                                                        WHERE v.ID = D.vuviecid 
                                                                                                            and v.gqd_loaiketqua in (2,3,4) 
                                                                                                            and v.GQD_NGAYPHATHANHCV between vTuNgay and vDenNgay) ---XEP DON
                                                                               OR  EXISTS(SELECT 'X' FROM GDTTT_DON_TRALOI kqd 
                                                                                                        WHERE kqd.DONID = D.ID 
                                                                                                            and kqd.TYPETB in (3,4)
                                                                                                            and kqd.NGAY between vTuNgay and vDenNgay 
                                                                                                            )    --TLD;KN                    
                                                                                )                                                                                            
                                                    )                                                                      
                                  )


                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_BC_TP_THULY_GQ(item_tp.THAMPHANID,0,0,0,item.TONG,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
                END LOOP;  
                --còn lại
                FOR item IN (
                        select COUNT(v.id)TONG
                        from GDTTT_VUAN v
                        LEFT JOIN gdttt_don d ON D.VUVIECID=V.ID 
                        where v.THAMPHANID=item_tp.THAMPHANID
                        and v.TOAANID=vToaAnID
                        AND d.isthuly= 1 and d.CD_TRANGTHAI = 2  
                        and v.LOAIAN != 1
                        and (
                            Not Exists(select 'X' from GDTTT_VUAN_KETQUA where TRANGTHAI != 0 and vuanid = v.id)--trang thái 0 bị xóa ,1 hiệu lực
                            OR Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                            where  TRANGTHAI = 1 
                                            and ( GQD_NGAYPHATHANHCV >=vDenNgay )
                                            and vuanid = v.id
                            )       )
                                              )
                LOOP
                   v_table.extend;
                   v_table(v_table.count) := R_BC_TP_THULY_GQ(item_tp.THAMPHANID,0,0,0,0,item.TONG,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0); 
                END LOOP;
--                        select COUNT(tT.id)id,sum(tt.cThulymoi)TONG from (
--                        select v.id,
--                        (select count(id) from gdttt_don d where d.VUVIECID = v.id and d.isthuly= 1 and d.CD_TRANGTHAI = 2 )cThulymoi
--                        from GDTTT_VUAN v
--                        where v.THAMPHANID=item_tp.THAMPHANID
--                        and v.TOAANID=vToaAnID
--                       -- and NVL(v.truonghopthuly,0) not in (8,10,1)--1:HO SO KN, 8:DON KHIEU NAI TU PHAP; DON KHIEU NAI TU PHAP KEM CV
--                        and v.LOAIAN != 1
--                        and (
--                            Not Exists(select 'X' from GDTTT_VUAN_KETQUA where TRANGTHAI != 0 and vuanid = v.id)--trang thái 0 bị xóa ,1 hiệu lực
--                            OR Exists(select 'X' from GDTTT_VUAN_KETQUA 
--                                            where  TRANGTHAI = 1 
--                                            and ( GQD_NGAYPHATHANHCV >=vDenNgay )
--                                            and vuanid = v.id
--                            )       )
--                        )tt
--                    SELECT count(C.id) TONG
--                              FROM(
--                                SELECT v.ID FROM GDTTT_VUAN v
--                                   left join GDTTT_DON d on d.vuviecid=v.id
--                                    LEFT JOIN GDTTT_VUAN_KETQUA_DON DKQ ON DKQ.DONID = D.ID AND DKQ.TRANGTHAI = 1
--                                    LEFT JOIN GDTTT_VUAN_KETQUA KQ ON DKQ.VUAN_KETQUA_ID = KQ.ID
--                                  where 
--                                  NVL(d.LOAIDON,0) NOT IN(4)
--                                  AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
--                                  AND d.toaanid = vToaAnID --sau se truyen don vi vao
--                                  AND  v.THAMPHANID = item_tp.THAMPHANID
--                                  AND D.ISTHULY = 1
--                                   AND d.CD_LOAI = 0
--                                  AND d.TL_NGAY <= vDenNgay 
--                                  AND nvl(d.BAQD_LOAIAN,0) != 1 
--                                  and (KQ.gqd_loaiketqua IS NULL OR KQ.GDQ_NGAY > vDenNgay)
--                                  and NVL(v.truonghopthuly,0) not in (8,10,1)--1:HO SO KN, 8:DON KHIEU NAI TU PHAP; DON KHIEU NAI TU PHAP KEM CV
--                                 UNION
--                               SELECT v.ID
--                                  FROM GDTTT_VUAN V
--                                  LEFT JOIN GDTTT_DON d  ON V.ID = D.VUVIECID
--                                  where 
--                                  NVL(d.LOAIDON,0) NOT IN(4)
--                                  AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
--                                  AND d.toaanid = vToaAnID --sau se truyen don vi vao
--                                  AND  d.THAMPHANID = item_tp.THAMPHANID
--                                  AND D.ISTHULY = 1
--                                   AND d.CD_LOAI = 0
--                                  AND d.TL_NGAY <= vDenNgay 
--                                  AND nvl(d.BAQD_LOAIAN,0) = 1              
--                                  and ( v.gqd_loaiketqua IS NULL 
--                                        OR  v.GDQ_NGAY > vDenNgay
--                                        )   
--                                 )C


           --------------------             
           END LOOP;
         RETURN v_table;    
END BC_VGDKT_24;
FUNCTION BC_VGDKT_22
( 
    V_CANBO_TK_ID  IN VARCHAR2,
    V_LANHDAO_TK_ID  IN VARCHAR2,
    vToaAnID in number,
    vPhongBanID  in number,
    vTuNgay in date,
    vDenNgay in date,
    vLanhDaoID number
)
RETURN T_BC_TP_THULY_GQ
IS 
            v_table T_BC_TP_THULY_GQ;v_table_all T_TINHTRANG; V_CURSOR sys_refcursor; 
            LOAIAN_ID VARCHAR2(150);LOAIAN_TEN VARCHAR2(150);VUANID NUMBER;LANHDAOID NUMBER;TINHTRANGID NUMBER;NGAYTRA DATE; TOTRINH_ID NUMBER;NGAYTRINH  DATE;ISCAPTRINHTIEP NUMBER;THUTU_CAPTRINH NUMBER;
BEGIN
            v_table := T_BC_TP_THULY_GQ();  v_table_all := T_TINHTRANG(); 
                   ----------------------------------------tạo du lieu cac cap trinh chuyển vào bảng v_table_ld
                  PKG_GDTTT_BAOCAO_APP.GDTTTT_QLTOTRINH_ALL(
                                  vToaAnID,vPhongBanID,null,--vToaAnID,vPhongBanID,vLoaiAn
                                  null,vDenNgay,--tt_tungay,tt_denngay
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
            -----------------
             FOR item_tp IN (
                SELECT V.THAMPHANID,CB.HOTEN FROM GDTTT_VUAN V
               -- SELECT  d.THAMPHANID ,CB.HOTEN FROM GDTTT_DON d
                LEFT JOIN DM_CANBO CB ON CB.ID= V.THAMPHANID
                WHERE  V.TOAANID=vToaAnID and CB.chucdanhid in(486,2318)--486 TPTATC,2318 TPBAC3
                AND V.PHONGBANID=vPhongBanID
                AND  V.THAMPHANID!=0 AND V.THAMPHANID IS NOT NULL
                AND ( V.NGAYTAO>=vTuNgay AND  V.NGAYTAO<=vDenNgay)
                GROUP BY  V.THAMPHANID,CB.HOTEN
              )
             LOOP
             --cũ còn lại
              FOR item IN (
                    SELECT count(C.id) TONG  FROM 
                    ( SELECT d.THAMPHANID,d.ID 
                      FROM GDTTT_DON d 
                      LEFT JOIN GDTTT_VUAN V ON V.ID=D.VUVIECID
                      where  NVL(d.LOAIDON,0) NOT IN(4)  AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                      AND d.toaanid = vToaAnID --sau se truyen don vi vao
                      AND V.PHONGBANID=vPhongBanID 
                      AND  d.THAMPHANID = item_tp.THAMPHANID
                      AND D.ISTHULY = 1  AND d.CD_LOAI = 0                                         
                      AND  d.TL_NGAY < vTuNgay 
                          AND ((nvl(d.BAQD_LOAIAN,0) != 1 
                                    AND (  EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON DKQ   
                                            LEFT JOIN GDTTT_VUAN_KETQUA KQ ON DKQ.VUAN_KETQUA_ID = KQ.ID
                                            WHERE DKQ.DONID = D.ID AND DKQ.TRANGTHAI = 1  AND KQ.GDQ_NGAY >= vTuNgay)  or  not EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA DKQ   
                                            LEFT JOIN GDTTT_VUAN_KETQUA_DON KQ ON DKQ.ID = KQ.VUAN_KETQUA_ID
                                            WHERE KQ.DONID = D.ID)
                                        )
                                  )
                                 or (nvl(d.BAQD_LOAIAN,0) != 1 AND NOT EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON DKQ  WHERE DKQ.DONID = D.ID  AND DKQ.TRANGTHAI = 1) )
                                 or (nvl(d.BAQD_LOAIAN,0) = 1  AND NOT EXISTS(SELECT 'X' FROM GDTTT_VUAN v WHERE v.ID = D.vuviecid and v.gqd_loaiketqua in (0,1,2,3,4))  )  
                                 OR (nvl(d.BAQD_LOAIAN,0) = 1  AND EXISTS(SELECT 'X' FROM GDTTT_VUAN v  WHERE v.ID = D.vuviecid and v.gqd_loaiketqua in (0,1,2,3,4)and v.GDQ_NGAY >= vTuNgay)  )     
                          )
                      AND d.id !=319292
                    )C
                   )
                       LOOP
                         v_table.extend;
                         v_table(v_table.count) := R_BC_TP_THULY_GQ(item_tp.THAMPHANID
                         ,item.TONG,0,0,0,0
                         ,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
                END LOOP;
                -----------Mới thụ lý----------
               FOR item IN (
                SELECT count(C.id) TONG
                         FROM (
                                SELECT d.THAMPHANID,d.ID 
                                          FROM GDTTT_DON d
                                           LEFT JOIN GDTTT_VUAN V ON V.ID=D.VUVIECID
                                          where 
                                          NVL(d.LOAIDON,0) NOT IN(4)
                                          AND d.ngaytao>= to_Date('01/01/2024','dd/MM/yyyy')
                                          AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                         --  AND V.PHONGBANID=vPhongBanID 
                                          AND d.THAMPHANID = item_tp.THAMPHANID
                                          AND D.ISTHULY = 1  
                                          AND d.CD_LOAI = 0
                                          AND d.TL_NGAY between vTuNgay and vDenNgay
                                    )C
                 )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_BC_TP_THULY_GQ(item_tp.THAMPHANID
                        ,0,item.TONG,0,0,0
                        ,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
                END LOOP;
             ------ Đã giải quyết xong
                FOR item IN 
                (
                SELECT count(V.id) TONG FROM GDTTT_VUAN V
                                  LEFT JOIN GDTTT_DON d ON D.vuviecid=v.id
                                  where 
                                  NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao > to_Date('01/01/2024','dd/MM/yyyy')
                                  AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                   AND V.PHONGBANID=vPhongBanID 
                                  AND  V.THAMPHANID = item_tp.THAMPHANID
                                  AND D.ISTHULY = 1
                                   AND d.CD_LOAI = 0
                                  AND( (nvl(d.BAQD_LOAIAN,0) != 1 and  EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON DKQ   
                                                            LEFT JOIN GDTTT_VUAN_KETQUA KQ ON DKQ.VUAN_KETQUA_ID = KQ.ID
                                                            WHERE DKQ.DONID = D.ID 
                                                                AND DKQ.TRANGTHAI = 1
                                                                AND KQ.GQD_NGAYPHATHANHCV between vTuNgay and vDenNgay))

                                  OR (nvl(d.BAQD_LOAIAN,0)  = 1 and ( EXISTS(SELECT 'X' FROM GDTTT_VUAN v 
                                                                                                        WHERE v.ID = D.vuviecid 
                                                                                                            and v.gqd_loaiketqua in (2,3,4) 
                                                                                                            and v.GQD_NGAYPHATHANHCV between vTuNgay and vDenNgay) ---XEP DON
                                                                               OR  EXISTS(SELECT 'X' FROM GDTTT_DON_TRALOI kqd 
                                                                                                        WHERE kqd.DONID = D.ID 
                                                                                                            and kqd.TYPETB in (3,4)
                                                                                                            and kqd.NGAY between vTuNgay and vDenNgay 
                                                                                                            )    --TLD;KN                    
                                                                                )                                                                                            
                                                    )                                                                      
                                  )


                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_BC_TP_THULY_GQ(item_tp.THAMPHANID
                        ,0,0,0,item.TONG
                        ,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
                END LOOP;  
                 --Đã có hồ sơ
               FOR item IN 
                 (          
                    SELECT COUNT(V.ID)TONG FROM GDTTT_VUAN V 
                    WHERE V.TOAANID=vToaAnID 
                    AND V.PHONGBANID=vPhongBanID 
                   -- AND v.NGAYTAO>vTuNgay AND v.NGAYTAO<vDenNgay
                    --AND V.LOAIAN!=1
                    and  V.THAMPHANID=item_tp.THAMPHANID
                    --and (v.gqd_loaiketqua is null)
                    and Not Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                  where TRANGTHAI != 0 and vuanid = v.id
                                  )  
                    and EXISTS (select ID from GDTTT_QUANLYHS where v.ID = VUANID 
                                            and NgayTao>=vTuNgay AND NgayTao<=vDenNgay                                          
                                            and ( NGAYNHAN is not null or LOAI = 3 )
                                )
                    --LOAI:-0:Phieu muon/1:Phieu Tra/2:Phieu chuyen/3:Phieu nhan
                    )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_BC_TP_THULY_GQ(item_tp.THAMPHANID
                        ,0,0,0,0,item.TONG
                        ,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
                END LOOP;  
               --Chưa có hồ sơ
               FOR item IN 
                 (          
                    SELECT COUNT(V.ID)TONG FROM GDTTT_VUAN V 
                    WHERE V.TOAANID=vToaAnID 
                    AND V.PHONGBANID=vPhongBanID 
                    -- AND v.NGAYTAO>vTuNgay AND v.NGAYTAO<vDenNgay
                    --AND V.LOAIAN!=1
                    and  V.THAMPHANID=item_tp.THAMPHANID
                    and Not Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                  where TRANGTHAI != 0 and vuanid = v.id
                                  )  
                    --and (v.gqd_loaiketqua is null)
                    and not EXISTS (select ID from GDTTT_QUANLYHS where v.ID = VUANID --and LOAI = 3
                    and ( NGAYNHAN is not null or LOAI = 3 )
                                )
                    )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_BC_TP_THULY_GQ(item_tp.THAMPHANID
                        ,0,0,0,0,0
                        ,item.TONG,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
                END LOOP; 
                --Thẩm tra viên đang nghiên cứu chưa có tờ trình
                 FOR item IN 
                 (          
                    SELECT COUNT(V.ID)TONG FROM GDTTT_VUAN V 
                    WHERE V.TOAANID=vToaAnID 
                    AND V.PHONGBANID=vPhongBanID 
                    --vTuNgay and vDenNgay
                    AND v.NGAYTAO>vTuNgay AND v.NGAYTAO<vDenNgay
                    --AND V.LOAIAN!=1
                    and  V.THAMPHANID=item_tp.THAMPHANID
                    and Not Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                  where TRANGTHAI != 0 and vuanid = v.id
                                  )  
--                    and (v.gqd_loaiketqua is null)
                    and NOT EXISTS(SELECT 'X' FROM GDTTT_TOTRINH WHERE v.ID = VUANID)
                    and  EXISTS (select ID from GDTTT_QUANLYHS where v.ID = VUANID and ( NGAYNHAN is not null or LOAI = 3 ))
                    )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_BC_TP_THULY_GQ(item_tp.THAMPHANID
                        ,0,0,0,0,0
                        ,0,item.TONG,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
                END LOOP;  
        --Đang trình Lãnh đạo Vụ (có cấp trình nhưng chưa có Ngày trả)
          FOR item IN 
                 (   
                 SELECT COUNT(V.ID)TONG  FROM GDTTT_VUAN V 
                 WHERE V.TOAANID=VTOAANID 
                 AND V.PHONGBANID=VPHONGBANID 
                 and  V.THAMPHANID=item_tp.THAMPHANID
                 AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18))
                 AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA WHERE V.ID=PA.VUANID AND PA.TINHTRANGID IN (4 ,100))
                 AND  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and TINHTRANGID IN (4 ,100,5 ,101))  AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18))
                 AND ((v.LOAIAN = 1 AND NVL(v.GQD_LOAIKETQUA,5) = 5 and NVL(v.TrangthaiID,0) not in (13,14,15,16,18))
                    OR (v.LOAIAN != 1 AND Not Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where TRANGTHAI != 0 and vuanid = v.id)))
               )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_BC_TP_THULY_GQ(item_tp.THAMPHANID
                        ,0,0,0,0,0
                        ,0,0,item.TONG,0,0,0,0,0,0,0,0,0,0,0,0,0);
                END LOOP;  
        -- Đang trình Thẩm phán chưa có ngày trả)
         FOR item IN 
                 (   
                    SELECT COUNT(V.ID)TONG FROM GDTTT_VUAN V 
                    WHERE V.TOAANID=VTOAANID 
                    AND V.PHONGBANID=VPHONGBANID  
                    and  V.THAMPHANID=item_tp.THAMPHANID
                    AND ((v.LOAIAN != 1 AND Not Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                    where TRANGTHAI != 0 and vuanid = v.id)))
                    --Chưa có ý kiến                                                                                
                    --AND EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NULL  and TINHTRANGID = 6) 
                    --Trình Thẩm phán
                    AND EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and (TINHTRANGID = 6 or CAPTRINHTIEP=6) ) AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18)) 
                   --Chưa có bước giải quyết kế tiếp
                    AND ( vPhongBanID!=0 AND  EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA  
                                                           WHERE PA.VUANID=V.ID AND ((instr(','||6||',',','||PA.TINHTRANGID||',')>0 AND instr(','||6||',',',0,')=0) OR (instr(','||6||',',',0,')>0) )
                                                                                     AND ((PA.NGAYTRA IS NOT NULL AND 0>=1 AND 0!=2) OR (0=2) OR (0=0 AND PA.NGAYTRA IS NULL) ) 
                                                                ) 
                           )
                 )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_BC_TP_THULY_GQ(item_tp.THAMPHANID,0,0,0,0,0,0,0,0,item.TONG,0,0,0,0,0,0,0,0,0,0,0,0);
                END LOOP; 
          --Yêu cầu xác minh/ báo cáo lại (Ý kiến là "Nghiên cứu lại, xác minh, bổ sung" và chưa có bước tiếp theo)
         FOR item IN 
                 (   
                        SELECT COUNT(V.ID)TONG FROM GDTTT_VUAN V 
                        WHERE V.TOAANID=VTOAANID AND V.PHONGBANID=VPHONGBANID 
                        AND V.PHONGBANID=VPHONGBANID  
                        and  V.THAMPHANID=item_tp.THAMPHANID
                        AND ((v.LOAIAN = 1 AND NVL(v.GQD_LOAIKETQUA,5) = 5 and NVL(v.TrangthaiID,0) not in (13,14,15,16,18))
                        OR (v.LOAIAN != 1 AND Not Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                    where TRANGTHAI != 0 and vuanid = v.id)))
                        --and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and loaiykien = 10)
                        AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA WHERE V.ID=PA.VUANID AND PA.TINHTRANGID=10)
                       )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_BC_TP_THULY_GQ(item_tp.THAMPHANID
                        ,0,0,0,0,0
                        ,0,0,0,0,item.TONG
                        ,0,0,0,0,0,0,0,0,0,0,0);
                END LOOP; 
       --Dự thảo trả lời đơn(lấy theo cấp trình)
      FOR item IN 
                 (   
                    SELECT COUNT(V.ID)TONG FROM GDTTT_VUAN V 
                    WHERE V.TOAANID=VTOAANID AND V.PHONGBANID=VPHONGBANID
                    and  V.THAMPHANID=item_tp.THAMPHANID
                    AND ((v.LOAIAN = 1 AND NVL(v.GQD_LOAIKETQUA,5) = 5 and NVL(v.TrangthaiID,0) not in (13,14,15,16,18))
                    OR (v.LOAIAN != 1 AND Not Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                            where TRANGTHAI != 0 and vuanid = v.id))) 
                    -- and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID  and TINHTRANGID = 11)
                    AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA WHERE V.ID=PA.VUANID AND PA.TINHTRANGID=11)
                    --Dự thảo kháng nghị(lấy theo cấp trình)
                    )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_BC_TP_THULY_GQ(item_tp.THAMPHANID
                        ,0,0,0,0,0
                        ,0,0,0,0,0
                        ,item.TONG,0,0,0,0,0,0,0,0,0,0);
                END LOOP; 
         --Dự thảo kháng nghị(lấy theo cấp trình)
      FOR item IN 
                 (   
                    SELECT COUNT(V.ID)TONG FROM GDTTT_VUAN V 
                    WHERE V.TOAANID=VTOAANID AND V.PHONGBANID=VPHONGBANID
                    and  V.THAMPHANID=item_tp.THAMPHANID
                    AND ((v.LOAIAN = 1 AND NVL(v.GQD_LOAIKETQUA,5) = 5 and NVL(v.TrangthaiID,0) not in (13,14,15,16,18))
                    OR (v.LOAIAN != 1 AND Not Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                            where TRANGTHAI != 0 and vuanid = v.id))) 
                    -- and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID  and TINHTRANGID = 11)
                    AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA WHERE V.ID=PA.VUANID AND PA.TINHTRANGID=12)
                    --Dự thảo kháng nghị(lấy theo cấp trình)
                    )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_BC_TP_THULY_GQ(item_tp.THAMPHANID
                        ,0,0,0,0,0
                        ,0,0,0,0,0
                        ,0,item.TONG,0,0,0,0,0,0,0,0,0);
                END LOOP;  
         --Đang trình PCA/ Báo cáo Tổ TP/ Báo cáo CA(chỉ cần tồn tại 1 trong 3 trường hợp trên - chưa có ngày trả)  
          FOR item IN 
                 (   
                        SELECT COUNT(V.ID)TONG  FROM GDTTT_VUAN V 
                        WHERE V.TOAANID=VTOAANID AND V.PHONGBANID=VPHONGBANID 
                        and  V.THAMPHANID=item_tp.THAMPHANID
                        AND ((v.LOAIAN = 1 AND NVL(v.GQD_LOAIKETQUA,5) = 5 and NVL(v.TrangthaiID,0) not in (13,14,15,16,18))
                        OR (v.LOAIAN != 1 AND Not Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                    where TRANGTHAI != 0 and vuanid = v.id)))
                        -- AND  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and TINHTRANGID = 7)
                        AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA WHERE V.ID=PA.VUANID AND PA.TINHTRANGID in(7,8,9))-- TINHTRANGID 7 Phó CA; 9 Báo cáo Tổ Thẩm phán; 8 Trình Chánh án
                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_BC_TP_THULY_GQ(item_tp.THAMPHANID
                        ,0,0,0,0,0
                        ,0,0,0,0,0
                        ,0,0,item.TONG,0,0,0,0,0,0,0,0);
                END LOOP;  
          --Chờ lịch báo cáo HĐTP (cấp trình CA và Yêu cầu trình tiếp là BC hội đồng thẩm phán và chưa có cấp trình tiếp theo)
           FOR item IN 
                 (   
                        SELECT COUNT(V.ID)TONG  FROM GDTTT_VUAN V 
                        WHERE V.TOAANID=VTOAANID AND V.PHONGBANID=VPHONGBANID 
                        and  V.THAMPHANID=item_tp.THAMPHANID
                        AND ((v.LOAIAN = 1 AND NVL(v.GQD_LOAIKETQUA,5) = 5 and NVL(v.TrangthaiID,0) not in (13,14,15,16,18))
                        OR (v.LOAIAN != 1 AND Not Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                    where TRANGTHAI != 0 and vuanid = v.id)))
                        AND EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and TINHTRANGID = 8 -- 8 Trình Chánh án là tờ trình mới nhất
                                    and id in(SELECT id FROM TABLE(v_table_all) PA WHERE V.ID=PA.VUANID AND PA.TINHTRANGID in(17))
                                   )
                        AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA WHERE V.ID=PA.VUANID AND PA.TINHTRANGID in(17))
                        --17 Báo cáo Hội đồng thẩm phán --là do cấp trình tiếp theo được insert vào bảng R_TINHTRANG dùng chung với trường TINHTRANGID
                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_BC_TP_THULY_GQ(item_tp.THAMPHANID
                        ,0,0,0,0,0
                        ,0,0,0,0,0
                        ,0,0,0,item.TONG,0,0,0,0,0,0,0);
                END LOOP;  
           --------------------   
           END LOOP;
         RETURN v_table;    
END BC_VGDKT_22;

FUNCTION BC_VGDKT_22V
( 
    V_CANBO_TK_ID  IN VARCHAR2,
    V_LANHDAO_TK_ID  IN VARCHAR2,
    vToaAnID in number,
    vPhongBanID  in number,
    vTuNgay in date,
    vDenNgay in date,
    vLanhDaoID number
)
RETURN SYS_REFCURSOR
IS 
      V_CURSOR sys_refcursor;       
BEGIN

     OPEN V_CURSOR FOR
     select ROW_NUMBER() OVER (ORDER BY cb.HOTEN) STT,cb.HOTEN,sum(pa.column_1)column_1,sum(pa.column_2)column_2,SUM(pa.column_1+pa.column_2)column_3 
        ,sum(pa.column_4)column_4
        ,SUM(PA.COLUMN_5) COLUMN_5,SUM(PA.COLUMN_6) COLUMN_6,SUM(PA.COLUMN_7) COLUMN_7,SUM(PA.COLUMN_8) COLUMN_8,SUM(PA.COLUMN_9) COLUMN_9,SUM(PA.COLUMN_10) COLUMN_10,SUM(PA.COLUMN_11) COLUMN_11,SUM(PA.COLUMN_12) COLUMN_12,SUM(PA.COLUMN_13) COLUMN_13,SUM(PA.COLUMN_14) COLUMN_14
        ,SUM(PA.COLUMN_9+PA.COLUMN_10+PA.COLUMN_11+PA.COLUMN_12+PA.COLUMN_13+PA.COLUMN_14) COLUMN_15
        ,SUM(PA.COLUMN_5+PA.COLUMN_6+PA.COLUMN_7+PA.COLUMN_8+PA.COLUMN_9+PA.COLUMN_10+PA.COLUMN_11+PA.COLUMN_12+PA.COLUMN_13+PA.COLUMN_14) COLUMN_16
        --from TABLE(PKG_VGDKT_BAOCAO_V2.BC_VGDKT_22(null,null,1,401,to_date('01/01/2025','dd/MM/yyyy'),to_date('12/02/2026','dd/MM/yyyy'),null))pa 
        from TABLE(PKG_VGDKT_BAOCAO_V2.BC_VGDKT_22(null,null,vToaAnID,vPhongBanID,vTuNgay,vDenNgay,null))pa 
        left join Dm_Canbo Cb On Cb.Id=Pa.Thamphan_Id
        group by cb.HOTEN;--Pa.Thamphan_Id
       ------------ 
      RETURN V_CURSOR;   
END BC_VGDKT_22V;    
FUNCTION BC_VGDKT_24V
( 
    V_CANBO_TK_ID  IN VARCHAR2,
    V_LANHDAO_TK_ID  IN VARCHAR2,
    vToaAnID in number,
    vPhongBanID  in number,
    vTuNgay in date,
    vDenNgay in date,
    vLanhDaoID number
)
RETURN SYS_REFCURSOR
IS 
      V_CURSOR sys_refcursor;       
BEGIN

     OPEN V_CURSOR FOR
   SELECT ROW_NUMBER() OVER (ORDER BY TT.HOTEN) STT,tt.HOTEN,TT.column_1,TT.column_2,TT.column_3,decode(TT.column_1,0,0,ROUND((TT.column_2/TT.column_1)*100,2))TYLE FROM (  
     select cb.HOTEN,SUM(pa.column_4+pa.column_5)column_1 
        ,sum(pa.column_4)column_2 ,sum(pa.column_5)column_3
        --from TABLE(BC_VGDKT_24(null,null,1,401,to_date('01/01/2026','dd/MM/yyyy'),to_date('28/01/2026','dd/MM/yyyy'),null))pa 
        from TABLE(PKG_VGDKT_BAOCAO_V2.BC_VGDKT_24(null,null,vToaAnID,vPhongBanID,vTuNgay,vDenNgay,null))pa 
        left join Dm_Canbo Cb On Cb.Id=Pa.Thamphan_Id
        group by cb.HOTEN
        )TT
        ;
       ------------ 
      RETURN V_CURSOR;   
END BC_VGDKT_24V;
FUNCTION BC_TUAN_VGDKT_2
( 
    V_CANBO_TK_ID  IN VARCHAR2,
    V_LANHDAO_TK_ID  IN VARCHAR2,
    vToaAnID in number,
    vPhongBanID  in number,
    vTuNgay in date,
    vDenNgay in date,
    vLanhDaoID number
)
RETURN T_BC_TUAN_VGDKT
IS 
            v_table T_BC_TUAN_VGDKT;v_table_all T_TINHTRANG; V_CURSOR sys_refcursor; 
             V_TONG NUMBER;
             v_daunamCongtac date;
             v_thang number;
             v_nam number;
BEGIN          
            v_thang := EXTRACT(MONTH FROM vTuNgay);
            v_nam := EXTRACT(YEAR FROM vTuNgay);
            IF v_thang <10 then
                v_daunamCongtac:=TO_DATE('01/10/'|| TO_CHAR(v_nam-1) ||'00:00:00', 'dd/MM/yyyy hh24:mi:ss');
            else
                v_daunamCongtac:=TO_DATE('01/10/'|| TO_CHAR(v_nam) ||'00:00:00', 'dd/MM/yyyy hh24:mi:ss');
            end if;
            ---------------------
            v_table := T_BC_TUAN_VGDKT();  v_table_all := T_TINHTRANG();
            
      -----Xet xu giam doc tham------------------- 
     select count(v.id) into V_TONG from GSCM.gdttt_vuan v
                                    where v.toaanid = vToaAnID
                                    AND v.phongbanid = vPhongBanID
                                    AND NVL(v.truonghopthuly,0) not in (8,10)                                   
                                    AND ((NVL(v.XXGDTTT_ISKETQUA,0)=0 and NVL(v.XXGDTTT_KETQUAID,0)=0 and NVL(v.IsRutKN,0) = 0)
                                             or (v.XXGDTTT_KETQUAID>0  and (v.XXGDTTT_NGAYQD > v_daunamCongtac))
                                             or (NVL(v.IsRutKN,0) = 1 and v.ngayrutkn > v_daunamCongtac)
                                            )
                                    AND (v.NGAYTHULYXXGDT is not null and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001'))   
                                     ;  
             v_table.extend;
             v_table(v_table.count) := R_BC_TUAN_VGDKT(V_TONG,0,0,0,0
             ,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
                ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             );    
          ---Kháng nghị của Chánh An TANDTC
           select count(v.id) into V_TONG from GSCM.gdttt_vuan v
                                    where v.toaanid = vToaAnID
                                    AND v.phongbanid = vPhongBanID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)                                   
                                    AND ((NVL(v.XXGDTTT_ISKETQUA,0)=0 and NVL(v.XXGDTTT_KETQUAID,0)=0 and NVL(v.IsRutKN,0) = 0)
                                             or (v.XXGDTTT_KETQUAID>0 
                                                  and (v.XXGDTTT_NGAYQD > v_daunamCongtac))
                                             or (NVL(v.IsRutKN,0) = 1 and v.ngayrutkn > v_daunamCongtac)
                                            )
                                    AND (v.NGAYTHULYXXGDT is not null and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001')) 
                                    AND NVL(v.IsVienTruongKN,0) = 0
                                     ;  
             v_table.extend;
             v_table(v_table.count) := R_BC_TUAN_VGDKT(0,V_TONG,0,0,0
             ,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
                ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             );        
         ---Kháng nghị của Chánh An CCHCM
         select count(v.id) into V_TONG from GSCM.gdttt_vuan v
                                    where v.toaanid = vToaAnID
                                    AND v.phongbanid = vPhongBanID
                                    AND NVL(v.truonghopthuly,0) not in (8,10)                                   
                                    AND ((NVL(v.XXGDTTT_ISKETQUA,0)=0 and NVL(v.XXGDTTT_KETQUAID,0)=0 and NVL(v.IsRutKN,0) = 0)
                                             or (v.XXGDTTT_KETQUAID>0 
                                                  and (v.XXGDTTT_NGAYQD > v_daunamCongtac))
                                             or (NVL(v.IsRutKN,0) = 1 and v.ngayrutkn > v_daunamCongtac)
                                            )
                                    AND (v.NGAYTHULYXXGDT is not null and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001')) 
                                    AND NVL(v.IsVienTruongKN,0) = 1
                                    AND v.VIENTRUONGKN_NGUOIKY = 821
                                     ;    
             v_table.extend;
             v_table(v_table.count) := R_BC_TUAN_VGDKT(0,0,V_TONG,0,0
             ,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
                ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             );            
        ---Kháng nghị của Chánh An CCHN
         select count(v.id) into V_TONG from GSCM.gdttt_vuan v
                                    where v.toaanid = vToaAnID
                                    AND v.phongbanid = vPhongBanID
                                    AND NVL(v.truonghopthuly,0) not in (8,10)                                   
                                    AND ((NVL(v.XXGDTTT_ISKETQUA,0)=0 and NVL(v.XXGDTTT_KETQUAID,0)=0 and NVL(v.IsRutKN,0) = 0)
                                             or (v.XXGDTTT_KETQUAID>0 
                                                  and (v.XXGDTTT_NGAYQD > v_daunamCongtac))
                                             or (NVL(v.IsRutKN,0) = 1 and v.ngayrutkn > v_daunamCongtac)
                                            )
                                    AND (v.NGAYTHULYXXGDT is not null and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001')) 
                                    AND NVL(v.IsVienTruongKN,0) = 1
                                    AND v.VIENTRUONGKN_NGUOIKY = 819
                                     ; 
             v_table.extend;
             v_table(v_table.count) := R_BC_TUAN_VGDKT(0,0,0,V_TONG,0
             ,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
                ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             );        
          ---Kháng nghị của Chánh An CCDN
         select count(v.id) into V_TONG from GSCM.gdttt_vuan v
                                    where v.toaanid = vToaAnID
                                    AND v.phongbanid = vPhongBanID
                                    AND NVL(v.truonghopthuly,0) not in (8,10)                                   
                                    AND ((NVL(v.XXGDTTT_ISKETQUA,0)=0 and NVL(v.XXGDTTT_KETQUAID,0)=0 and NVL(v.IsRutKN,0) = 0)
                                             or (v.XXGDTTT_KETQUAID>0 
                                                  and (v.XXGDTTT_NGAYQD > v_daunamCongtac))
                                             or (NVL(v.IsRutKN,0) = 1 and v.ngayrutkn > v_daunamCongtac)
                                            )
                                    AND (v.NGAYTHULYXXGDT is not null and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001')) 
                                    AND NVL(v.IsVienTruongKN,0) = 1
                                    AND v.VIENTRUONGKN_NGUOIKY = 820
                                     ; 
             v_table.extend;
             v_table(v_table.count) := R_BC_TUAN_VGDKT(0,0,0,0,V_TONG
             ,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
                ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             );       
        ---Kháng nghị của VIEN TRUONG VKS
         select count(v.id) into V_TONG from GSCM.gdttt_vuan v
                                    where v.toaanid = vToaAnID
                                    AND v.phongbanid = vPhongBanID
                                    AND NVL(v.truonghopthuly,0) in (1)                                   
                                     AND ((NVL(v.XXGDTTT_ISKETQUA,0)=0 and NVL(v.XXGDTTT_KETQUAID,0)=0 and NVL(v.IsRutKN,0) = 0)
                                             or (v.XXGDTTT_KETQUAID>0 
                                                  and (v.XXGDTTT_NGAYQD > v_daunamCongtac))
                                             or (NVL(v.IsRutKN,0) = 1 and v.ngayrutkn > v_daunamCongtac)
                                            )
                                    AND (v.NGAYTHULYXXGDT is not null and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001')) 
                                    AND NVL(v.IsVienTruongKN,0) = 1
                                    AND v.VIENTRUONGKN_NGUOIKY = 1
                                     ;      
            v_table.extend;
             v_table(v_table.count) := R_BC_TUAN_VGDKT(0,0,0,0,0
             ,V_TONG,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
                ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             );   
             
        -- ĐA XET XU TRONG NAM
            select count(v.id) into V_TONG from GSCM.gdttt_vuan v
            where v.toaanid = vToaAnID
            AND v.phongbanid = vPhongBanID
            AND NVL(v.truonghopthuly,0) not in (8,10)
            AND NVL(v.XXGDTTT_ISKETQUA,0)>0
            AND V.XXGDTTT_NGAYQD BETWEEN v_daunamCongtac and vDenNgay
             ;
            v_table.extend;
            v_table(v_table.count) := R_BC_TUAN_VGDKT(0,0,0,0,0
            ,0,V_TONG,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
                ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             );    
         --còn lại
          select count(v.id) into V_TONG from GSCM.gdttt_vuan v
            where v.toaanid = vToaAnID
            AND v.phongbanid = vPhongBanID
            AND NVL(v.truonghopthuly,0) not in (8,10)
            AND NVL(v.IsRutKN,0) = 0
            AND NVL(v.XXGDTTT_ISKETQUA,0)=0 
            and NVL(v.XXGDTTT_KETQUAID,0)=0 
            AND (v.NGAYTHULYXXGDT is not null and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001')) 
           ;
             v_table.extend;
            v_table(v_table.count) := R_BC_TUAN_VGDKT(0,0,0,0,0
            ,0,0,V_TONG,0,0
             ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
                ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             );  
            
          --còn lại V1_CONLAI_CA
          select count(v.id) into V_TONG from GSCM.gdttt_vuan v
            where v.toaanid = vToaAnID
            AND v.phongbanid = vPhongBanID
            AND NVL(v.truonghopthuly,0) not in (8,10)
            AND NVL(v.IsRutKN,0) = 0
            AND NVL(v.XXGDTTT_ISKETQUA,0)=0 
            and NVL(v.XXGDTTT_KETQUAID,0)=0 
            AND (v.NGAYTHULYXXGDT is not null and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001')) 
            AND NVL(v.IsVienTruongKN,0) = 0
           ;
            v_table.extend;
            v_table(v_table.count) := R_BC_TUAN_VGDKT(0,0,0,0,0
            ,0,0,0,V_TONG,0
             ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
                ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             );       
            --còn lại V1_CONLAI_VKS
            select count(v.id) into V_TONG from GSCM.gdttt_vuan v
            where v.toaanid = vToaAnID
            AND v.phongbanid = vPhongBanID
            AND NVL(v.truonghopthuly,0) not in (8,10)
            AND NVL(v.IsRutKN,0) = 0
            AND NVL(v.XXGDTTT_ISKETQUA,0)=0 
            and NVL(v.XXGDTTT_KETQUAID,0)=0 
            AND (v.NGAYTHULYXXGDT is not null and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001')) 
            AND NVL(v.IsVienTruongKN,0) = 1
           ;
            v_table.extend;
            v_table(v_table.count) := R_BC_TUAN_VGDKT(0,0,0,0,0
            ,0,0,0,0,V_TONG
             ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
                ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             ); 
          --Tong phai giai quyet den ngay
          --kiem tra lai xem tu dau nam duong lich hay dau nam cong tac          
           select count(v.id) into V_TONG from GSCM.gdttt_vuan v
                                    where v.toaanid = VTOAANID
                                    AND v.phongbanid = VPHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND (NOT EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID  
                                                               AND kq.trangthai = 1
                                                               ) 
                                            OR 
                                            
                                            EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               AND kq.gdq_ngay > v_daunamCongtac
                                                               ) 
                                                    )
                            ;  
            v_table.extend;
            v_table(v_table.count) := R_BC_TUAN_VGDKT(
            0,0,0,0,0
            ,0,0,0,0,0
            ,V_TONG,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
               ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             ); 
             
          --------Tong da giai quyet---------------      
          select count(v.id) into V_TONG from GSCM.gdttt_vuan v
                    where v.toaanid = VTOAANID
                    AND v.phongbanid = VPHONGBANID
                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                    AND( EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ
                                               WHERE KQ.VUANID = V.ID
                                               AND kq.trangthai = 1
                                               AND kq.gdq_ngay BETWEEN  v_daunamCongtac and vDenNgay 
                                               ) 
                         )
                                                    
            ;
        v_table.extend;
        v_table(v_table.count) := R_BC_TUAN_VGDKT(
        0,0,0,0,0
        ,0,0,0,0,0
        ,0,V_TONG,0,0,0,0,0,0,0,0
        ,0,0,0,0,0,0,0,0,0,0
           ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
         ); 
      -- Tong tra loi don trong kỳ                             
      select count(v.id) into V_TONG from GSCM.gdttt_vuan v
                                    where v.toaanid = VTOAANID
                                    AND v.phongbanid = VPHONGBANID
                                    and NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.gdq_ngay BETWEEN v_daunamCongtac AND vDenNgay
                                                               AND kq.gqd_loaiketqua = 0
                                                               AND kq.trangthai = 1
                                                               ) 
                                     ;   
            v_table.extend;
            v_table(v_table.count) := R_BC_TUAN_VGDKT(
            0,0,0,0,0
            ,0,0,0,0,0
            ,0,0,V_TONG,0,0
            ,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
               ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             );         
      -- Tong khang nghi trong kỳ                               
        select count(v.id) into V_TONG from GSCM.gdttt_vuan v
                                    where v.toaanid = VTOAANID
                                    AND v.phongbanid = VPHONGBANID
                                    and NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.gdq_ngay BETWEEN v_daunamCongtac AND vDenNgay
                                                               AND kq.gqd_loaiketqua = 1
                                                               AND kq.trangthai = 1
                                                               ) 
                                     ;   
            v_table.extend;
            v_table(v_table.count) := R_BC_TUAN_VGDKT(
            0,0,0,0,0
            ,0,0,0,0,0
            ,0,0,0,V_TONG,0
            ,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
               ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             );           
      --  Tong xep don trong kỳ                                 
    select count(v.id) into V_TONG from GSCM.gdttt_vuan v
                                    where v.toaanid = VTOAANID
                                    AND v.phongbanid = VPHONGBANID
                                    and NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.gdq_ngay BETWEEN v_daunamCongtac AND vDenNgay
                                                               AND kq.gqd_loaiketqua in (2,3,4)
                                                               AND kq.trangthai = 1
                                                               ) 
                                     ;         
            v_table.extend;
            v_table(v_table.count) := R_BC_TUAN_VGDKT(
            0,0,0,0,0
            ,0,0,0,0,0
            ,0,0,0,0,V_TONG
            ,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
               ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             );  
     -----Còn lại------------------- 
     select count(v.id) into V_TONG from GSCM.gdttt_vuan v
                                    where v.toaanid = VTOAANID
                                    AND v.phongbanid = VPHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                                               
                                     ;
           v_table.extend;
            v_table(v_table.count) := R_BC_TUAN_VGDKT(
            0,0,0,0,0
            ,0,0,0,0,0
            ,0,0,0,0,0
            ,V_TONG,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
               ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             );   
     ----Đang trình
     select count(v.id) into V_TONG from GSCM.gdttt_vuan v
                                    where v.toaanid = VTOAANID
                                    AND v.phongbanid = VPHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
--                                    AND  EXISTS (
--                                                    SELECT 'X'
--                                                    FROM GDTTT_TOTRINH TT
--                                                    WHERE TT.VUANID=V.ID
--                                                    AND TT.NGAYTRINH BETWEEN vTuNgay AND vDenNgay
--                                                ) 
                                     AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN vTuNgay AND vDenNgay
                                                ) 
                                     ;    
                                     
            v_table.extend;
            v_table(v_table.count) := R_BC_TUAN_VGDKT(
            0,0,0,0,0
            ,0,0,0,0,0
            ,0,0,0,0,0
            ,0,V_TONG,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
               ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             );          
        --dang trinh LDV                             
       select count(v.id) into V_TONG from GSCM.gdttt_vuan v
                                    where v.toaanid = VTOAANID
                                    AND v.phongbanid = VPHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN vTuNgay AND vDenNgay
                                                    AND TT.TINHTRANGID in (4,5) --Trinh PVT hoac VT
                                                ) 
                                     ;  
           v_table.extend;
            v_table(v_table.count) := R_BC_TUAN_VGDKT(
            0,0,0,0,0
            ,0,0,0,0,0
            ,0,0,0,0,0
            ,0,0,V_TONG,0,0
            ,0,0,0,0,0,0,0,0,0,0
               ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             );                           
          select count(v.id) into V_TONG from GSCM.gdttt_vuan v          
                                    where v.toaanid = VTOAANID
                                    AND v.phongbanid = VPHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN vTuNgay AND vDenNgay
                                                    AND TT.TINHTRANGID in (6) --Trinh TP
                                                    --SELECT C.ID FROM DM_DATAITEM c WHERE c.GROUPID = 12 AND ma='TPBAC3';2318
                                                    AND EXISTS(SELECT 'X' FROM DM_CANBO CB WHERE cb.chucdanhid =2318 AND (CB.ID=TT.LANHDAOID or CB.ID=TT.TRINHTIEP_LANHDAO_ID))--TPBAC3
                                                ) 
                                   
                                                
                                     ;
           v_table.extend;
            v_table(v_table.count) := R_BC_TUAN_VGDKT(
            0,0,0,0,0
            ,0,0,0,0,0
            ,0,0,0,0,0
            ,0,0,V_TONG,0,0
            ,0,0,0,0,0,0,0,0,0,0
               ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             );    
          --Trình TPTC SELECT C.ID FROM DM_DATAITEM c WHERE c.GROUPID = 12 AND ma='TPTATC';--486
         select count(v.id) into V_TONG from GSCM.gdttt_vuan v          
                                    where v.toaanid = VTOAANID
                                    AND v.phongbanid = VPHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN vTuNgay AND vDenNgay
                                                    AND TT.TINHTRANGID in (6) --Trinh TP
                                                    ----Trình TPTC SELECT C.ID FROM DM_DATAITEM c WHERE c.GROUPID = 12 AND ma='TPTATC';--486
                                                    AND EXISTS(SELECT 'X' FROM DM_CANBO CB WHERE cb.chucdanhid =486 AND (CB.ID=TT.LANHDAOID or CB.ID=TT.TRINHTIEP_LANHDAO_ID) )--TPTATC
                                                ) 
                                   
                                                
                                     ;
           v_table.extend;
            v_table(v_table.count) := R_BC_TUAN_VGDKT(
            0,0,0,0,0
            ,0,0,0,0,0
            ,0,0,0,0,0
            ,0,0,0,V_TONG,0
            ,0,0,0,0,0,0,0,0,0,0
               ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             );   
             
    --  dang trinh BAO CAO TO THAM PHAN                            
       select count(v.id) into V_TONG from GSCM.gdttt_vuan v
                                    where v.toaanid = VTOAANID
                                    AND v.phongbanid = VPHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN v_daunamCongtac AND vDenNgay
                                                    AND TT.TINHTRANGID in (9)
                                                ) 
                                     ;  
             v_table.extend;
            v_table(v_table.count) := R_BC_TUAN_VGDKT(
            0,0,0,0,0
            ,0,0,0,0,0
            ,0,0,0,0,0
            ,0,0,0,0,V_TONG
            ,0,0,0,0,0,0,0,0,0,0
               ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             );            
      --dang trinh PCA                             
       select count(v.id) into V_TONG from GSCM.gdttt_vuan v
                                    where v.toaanid = VTOAANID
                                    AND v.phongbanid = VPHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN v_daunamCongtac AND vDenNgay
                                                    AND TT.TINHTRANGID in (7) --Trinh PCA
                                                ) 
                                     ; 
           v_table.extend;
            v_table(v_table.count) := R_BC_TUAN_VGDKT(
            0,0,0,0,0
            ,0,0,0,0,0
            ,0,0,0,0,0
            ,0,0,0,0,0
            ,V_TONG,0,0,0,0,0,0,0,0,0
               ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             );               
         --        dang trinh CA                             
       select count(v.id) into V_TONG from GSCM.gdttt_vuan v
                                    where v.toaanid = VTOAANID
                                    AND v.phongbanid = VPHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN v_daunamCongtac AND vDenNgay
                                                    AND TT.TINHTRANGID in (8) --Trinh CA
                                                ) 
                                     ;    
            v_table.extend;
            v_table(v_table.count) := R_BC_TUAN_VGDKT(
            0,0,0,0,0
            ,0,0,0,0,0
            ,0,0,0,0,0
            ,0,0,0,0,0
            ,0,V_TONG,0,0,0
            ,0,0,0,0,0
               ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             );                                        
          --dang trinh Dự thao tld                           
       select count(v.id) into V_TONG from GSCM.gdttt_vuan v
                                    where v.toaanid = VTOAANID
                                    AND v.phongbanid = VPHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN v_daunamCongtac AND vDenNgay
                                                    AND TT.TINHTRANGID in (11) 
                                                ) 
                                     ;    
               v_table.extend;
            v_table(v_table.count) := R_BC_TUAN_VGDKT(
            0,0,0,0,0
            ,0,0,0,0,0
            ,0,0,0,0,0
            ,0,0,0,0,0
            ,0,0,V_TONG,0,0
            ,0,0,0,0,0
               ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             );        
      -- dang trinh Dự thao khang nghi                           
       select count(v.id) into V_TONG from GSCM.gdttt_vuan v
                                    where v.toaanid = VTOAANID
                                    AND v.phongbanid = VPHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN v_daunamCongtac AND vDenNgay
                                                    AND TT.TINHTRANGID in (12) 
                                                ) 
                            ;    
            v_table.extend;
            v_table(v_table.count) := R_BC_TUAN_VGDKT(
            0,0,0,0,0
            ,0,0,0,0,0
            ,0,0,0,0,0
            ,0,0,0,0,0
            ,0,0,0,V_TONG,0
            ,0,0,0,0,0
               ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             );            
        -- dang Nghiên cứu lại, xác minh, bổ sung                      
       select count(v.id) into V_TONG from GSCM.gdttt_vuan v
                                    where v.toaanid = VTOAANID
                                    AND v.phongbanid = VPHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN v_daunamCongtac AND vDenNgay
                                                    AND TT.TINHTRANGID in (10) 
                                                ) 
                            ;    
            v_table.extend;
            v_table(v_table.count) := R_BC_TUAN_VGDKT(
            0,0,0,0,0
            ,0,0,0,0,0
            ,0,0,0,0,0
            ,0,0,0,0,0
            ,0,0,0,0,V_TONG
            ,0,0,0,0,0
               ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             );     
      -- Đang hoàn thiện tờ trình để báo cáo PCA                      
       select count(v.id) into V_TONG from GSCM.gdttt_vuan v
                                    where v.toaanid = VTOAANID
                                    AND v.phongbanid = VPHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN v_daunamCongtac AND vDenNgay
                                                    AND TT.CAPTRINHTIEP in (7) --Trinh PCA
                                                ) 
                            ;    
            v_table.extend;
            v_table(v_table.count) := R_BC_TUAN_VGDKT(
            0,0,0,0,0
            ,0,0,0,0,0
            ,0,0,0,0,0
            ,0,0,0,0,0
            ,0,0,0,0,0
            ,V_TONG,0,0,0,0
               ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             );   
           --Đang nghiên cứu - chưa có tờ trình 
            select count(v.id) into V_TONG from GSCM.gdttt_vuan v
                                    where v.toaanid = VTOAANID
                                    AND v.phongbanid = VPHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                    ) 
                                     and  NOT EXISTS ( SELECT 'X' FROM GDTTT_TOTRINH TT WHERE TT.VUANID =V.ID)
                                     ;
           v_table.extend;
            v_table(v_table.count) := R_BC_TUAN_VGDKT(
            0,0,0,0,0
            ,0,0,0,0,0
            ,0,0,0,0,0
            ,0,0,0,0,0
            ,0,0,0,0,0
            ,0,V_TONG,0,0,0
               ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             ,0,0,0,0,0,0,0,0,0,0
             );                             
        -- 4. Số vụ việc đã giải quyết được trong tuần từ ngày đến ngày
        --4.1. Trình Phó Chánh án Nguyễn Văn Tiến 87 vụ, trong đó: 
        --trinh PCA NGUYỄN VĂN TIẾN                            
       select count(v.id) into V_TONG from GSCM.gdttt_vuan v
                                    where v.toaanid = VTOAANID
                                    AND v.phongbanid = VPHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN vTuNgay AND vDenNgay
                                                    AND TT.TINHTRANGID in (7) --Trinh PCA
                                                    AND TT.LANHDAOID=2115--tp NGUYỄN VĂN TIẾN
                                                ) 
                                     ; 
            v_table.extend;
            v_table(v_table.count) := R_BC_TUAN_VGDKT(
            0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0
            ,0,0,V_TONG,0,0
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
             );                      
      --trinh PCA NGUYỄN VĂN TIẾN   
      ---Đang trình: (có ngày trình trong kỳ TK nhưng chưa có ngày trả) vụ
       select count(v.id) into V_TONG from GSCM.gdttt_vuan v
                                    where v.toaanid = VTOAANID
                                    AND v.phongbanid = VPHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN vTuNgay AND vDenNgay
                                                    AND TT.TINHTRANGID in (7) --Trinh PCA
                                                    AND TT.LANHDAOID=2115--tp NGUYỄN VĂN TIẾN
                                                    AND TT.NGAYTRINH IS NOT NULL
                                                    AND TT.NGAYTRA IS NULL
                                                ) 
                                     ; 
            v_table.extend;
            v_table(v_table.count) := R_BC_TUAN_VGDKT(
            0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0
            ,0,0,0,V_TONG,0
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
             );                  
       ---da duyet: có ngày trả
       select count(v.id) into V_TONG from GSCM.gdttt_vuan v
                                    where v.toaanid = VTOAANID
                                    AND v.phongbanid = VPHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN vTuNgay AND vDenNgay
                                                    AND TT.TINHTRANGID in (7) --Trinh PCA
                                                    AND TT.LANHDAOID=2115--tp NGUYỄN VĂN TIẾN
                                                    --AND TT.NGAYTRINH IS NOT NULL
                                                    AND TT.NGAYTRA IS not NULL
                                                ) 
                                     ; 
            v_table.extend;
            v_table(v_table.count) := R_BC_TUAN_VGDKT(
            0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0
            ,0,0,0,0,V_TONG
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
             );      
       ---PCA trình tiếp Tổ Thẩm phán ngày 
       select count(v.id) into V_TONG from GSCM.gdttt_vuan v
                                    where v.toaanid = VTOAANID
                                    AND v.phongbanid = VPHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN vTuNgay AND vDenNgay
                                                    AND TT.TINHTRANGID in (7) --Trinh PCA
                                                    AND TT.LANHDAOID=2115--tp NGUYỄN VĂN TIẾN
                                                    --AND TT.NGAYTRINH IS NOT NULL
                                                   -- AND TT.NGAYTRA IS not NULL
                                                   AND TT.CAPTRINHTIEP=9
                                                ) 
                                     ; 
            v_table.extend;
            v_table(v_table.count) := R_BC_TUAN_VGDKT(
            0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0           
            ,V_TONG,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
             ); 
      --4.2. Trình Thẩm phán TANDTC
      select count(v.id) into V_TONG from GSCM.gdttt_vuan v          
                                    where v.toaanid = VTOAANID
                                    AND v.phongbanid = VPHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN vTuNgay AND vDenNgay
                                                    AND TT.TINHTRANGID in (6) --Trinh TP
                                                    ----Trình TPTC SELECT C.ID FROM DM_DATAITEM c WHERE c.GROUPID = 12 AND ma='TPTATC';--486
                                                    AND EXISTS(SELECT 'X' FROM DM_CANBO CB WHERE cb.chucdanhid =486 AND (CB.ID=TT.LANHDAOID or CB.ID=TT.TRINHTIEP_LANHDAO_ID) )--TPTATC
--                                                    AND TT.NGAYTRINH IS NOT NULL
--                                                    AND TT.NGAYTRA IS NULL
                                                ) 
                                   
                                                
                                     ;
                  
           v_table.extend;
            v_table(v_table.count) := R_BC_TUAN_VGDKT(
            0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0           
            ,0,V_TONG,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
             );        
      --4.2. Trình Thẩm phán TANDTC
      --đã cho ý kiến (có ngày trả)
      select count(v.id) into V_TONG from GSCM.gdttt_vuan v          
                                    where v.toaanid = VTOAANID
                                    AND v.phongbanid = VPHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN vTuNgay AND vDenNgay
                                                    AND TT.TINHTRANGID in (6) --Trinh TP
                                                    ----Trình TPTC SELECT C.ID FROM DM_DATAITEM c WHERE c.GROUPID = 12 AND ma='TPTATC';--486
                                                    AND EXISTS(SELECT 'X' FROM DM_CANBO CB WHERE cb.chucdanhid =486 AND (CB.ID=TT.LANHDAOID or CB.ID=TT.TRINHTIEP_LANHDAO_ID) )--TPTATC
                                                    AND TT.NGAYTRA IS NOT NULL
                                                ) 
                                     ;
        v_table.extend;
            v_table(v_table.count) := R_BC_TUAN_VGDKT(
            0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0           
            ,0,0,V_TONG,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
             );             
       --Con lai chua co ngay tra
      select count(v.id) into V_TONG from GSCM.gdttt_vuan v          
                                    where v.toaanid = VTOAANID
                                    AND v.phongbanid = VPHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN vTuNgay AND vDenNgay
                                                    AND TT.TINHTRANGID in (6) --Trinh TP
                                                    ----Trình TPTC SELECT C.ID FROM DM_DATAITEM c WHERE c.GROUPID = 12 AND ma='TPTATC';--486
                                                    AND EXISTS(SELECT 'X' FROM DM_CANBO CB WHERE cb.chucdanhid =486 AND (CB.ID=TT.LANHDAOID or CB.ID=TT.TRINHTIEP_LANHDAO_ID) )--TPTATC
                                                    AND TT.NGAYTRA IS NULL
                                                ) 
                                     ;
        v_table.extend;
            v_table(v_table.count) := R_BC_TUAN_VGDKT(
            0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0           
            ,0,0,0,V_TONG,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
             );    
       --4.3. Lãnh đạo Vụ, Thẩm phán TAND bậc 3  
       --Trình Vụ trưởng 
         select count(v.id) into V_TONG from GSCM.gdttt_vuan v
                                    where v.toaanid = VTOAANID
                                    AND v.phongbanid = VPHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN vTuNgay AND vDenNgay
                                                    AND TT.TINHTRANGID in (5) --Trinh VT
                                                ) 
                                     ;  
               v_table.extend;
            v_table(v_table.count) := R_BC_TUAN_VGDKT(
            0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0           
            ,0,0,0,0,V_TONG,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
             );    
         --Trình các Phó Vụ trưởng 
         select count(v.id) into V_TONG from GSCM.gdttt_vuan v
                                    where v.toaanid = VTOAANID
                                    AND v.phongbanid = VPHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN vTuNgay AND vDenNgay
                                                    AND TT.TINHTRANGID in (4) --Trinh PVT
                                                ) 
                                     ;  
               v_table.extend;
            v_table(v_table.count) := R_BC_TUAN_VGDKT(
            0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0           
            ,0,0,0,0,0,V_TONG,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
             );     
      --- Trình Thẩm phán bậc 3
      select count(v.id) into V_TONG from GSCM.gdttt_vuan v
                                    where v.toaanid = VTOAANID
                                    AND v.phongbanid = VPHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN vTuNgay AND vDenNgay
                                                    AND TT.TINHTRANGID in (6) --Trinh TP 6
                                                    AND EXISTS(SELECT 'X' FROM DM_CANBO CB WHERE cb.chucdanhid =2318 AND (CB.ID=TT.LANHDAOID or CB.ID=TT.TRINHTIEP_LANHDAO_ID))--TPBAC3
                                                ) 
                                     ;  
            v_table.extend;
            v_table(v_table.count) := R_BC_TUAN_VGDKT(
            0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0           
            ,0,0,0,0,0,0,V_TONG,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
             );     
              --+ Án cho ý kiến để trình Thẩm phán TANDTC:
              select count(v.id) into V_TONG from GSCM.gdttt_vuan v
                                    where v.toaanid = VTOAANID
                                    AND v.phongbanid = VPHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN vTuNgay AND vDenNgay
                                                    AND (
                                                            (TT.TINHTRANGID in (6) --Trinh TP 6
                                                             AND EXISTS(SELECT 'X' FROM DM_CANBO CB WHERE cb.chucdanhid =2318 AND (CB.ID=TT.LANHDAOID or CB.ID=TT.TRINHTIEP_LANHDAO_ID))--TPBAC3
                                                            )
                                                            OR
                                                            (TT.TINHTRANGID in (5)) --Trinh VT
                                                        )
                                                    AND  TT.CAPTRINHTIEP=6   
                                                    AND EXISTS(SELECT 'X' FROM DM_CANBO CB WHERE cb.chucdanhid =486 AND (CB.ID=TT.LANHDAOID or CB.ID=TT.TRINHTIEP_LANHDAO_ID) )--TPTATC
                                                ) 
                                     ;  
            v_table.extend;
            v_table(v_table.count) := R_BC_TUAN_VGDKT(
            0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0           
            ,0,0,0,0,0,0,0,V_TONG,0,0
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
             );     
         --+ Án của Thẩm phán bậc 3 Đỗ Thị Hải Yến: 
              select count(v.id) into V_TONG from GSCM.gdttt_vuan v
                                    where v.toaanid = VTOAANID
                                    AND v.phongbanid = VPHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN vTuNgay AND vDenNgay
                                                    and TT.TINHTRANGID in (65) --Trinh VT
--                                                    AND EXISTS(SELECT 'X' FROM DM_CANBO CB WHERE cb.chucdanhid =2318 AND (CB.ID=TT.LANHDAOID or CB.ID=TT.TRINHTIEP_LANHDAO_ID))--TPBAC3
                                                    and (TT.LANHDAOID =92668 OR TT.TRINHTIEP_LANHDAO_ID=92668)--92668 Đỗ Thị Hải Yến      
                                                       
                                                ) 
                                     ;  
            v_table.extend;
            v_table(v_table.count) := R_BC_TUAN_VGDKT(
            0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0           
            ,0,0,0,0,0,0,0,0,V_TONG,0
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
             );        
          --Trình các Vụ trưởng đã duyệt
         select count(v.id) into V_TONG from GSCM.gdttt_vuan v
                                    where v.toaanid = VTOAANID
                                    AND v.phongbanid = VPHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN vTuNgay AND vDenNgay
                                                    AND TT.TINHTRANGID in (5) --Trinh VT
                                                    AND TT.NGAYTRA IS NOT NULL
                                                ) 
                                     ;  
                v_table.extend;
            v_table(v_table.count) := R_BC_TUAN_VGDKT(
            0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0           
            ,0,0,0,0,0,0,0,0,0,V_TONG
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
             );              
         --Trình các Vụ trưởng còn lại
         select count(v.id) into V_TONG from GSCM.gdttt_vuan v
                                    where v.toaanid = VTOAANID
                                    AND v.phongbanid = VPHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN vTuNgay AND vDenNgay
                                                    AND TT.TINHTRANGID in (5) --Trinh VT
                                                    AND TT.NGAYTRA IS NULL
                                                ) 
                                     ;  
                v_table.extend;
            v_table(v_table.count) := R_BC_TUAN_VGDKT(
            0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0           
            ,0,0,0,0,0,0,0,0,0,0
            ,V_TONG,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
             );                
        --Trình các pvt da duyet
         select count(v.id) into V_TONG from GSCM.gdttt_vuan v
                                    where v.toaanid = VTOAANID
                                    AND v.phongbanid = VPHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN vTuNgay AND vDenNgay
                                                    AND TT.TINHTRANGID in (4) --Trinh pVT
                                                    AND TT.NGAYTRA IS not NULL
                                                ) 
                                     ;  
                v_table.extend;
            v_table(v_table.count) := R_BC_TUAN_VGDKT(
            0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0           
            ,0,0,0,0,0,0,0,0,0,0
            ,0,V_TONG,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
             );                
        --Trình các pvt con lai
         select count(v.id) into V_TONG from GSCM.gdttt_vuan v
                                    where v.toaanid = VTOAANID
                                    AND v.phongbanid = VPHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN vTuNgay AND vDenNgay
                                                    AND TT.TINHTRANGID in (4) --Trinh pVT
                                                    AND TT.NGAYTRA IS NULL
                                                ) 
                                     ;  
                v_table.extend;
            v_table(v_table.count) := R_BC_TUAN_VGDKT(
            0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0           
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,V_TONG,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
             );                
       --- Trình Thẩm phán bậc 3 da duyet
      select count(v.id) into V_TONG from GSCM.gdttt_vuan v
                                    where v.toaanid = VTOAANID
                                    AND v.phongbanid = VPHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN vTuNgay AND vDenNgay
                                                    AND TT.TINHTRANGID in (6) --Trinh TP 6
                                                    AND EXISTS(SELECT 'X' FROM DM_CANBO CB WHERE cb.chucdanhid =2318 AND (CB.ID=TT.LANHDAOID or CB.ID=TT.TRINHTIEP_LANHDAO_ID))--TPBAC3
                                                    AND TT.NGAYTRA IS NOT NULL
                                                ) 
                                     ;  
            v_table.extend;
            v_table(v_table.count) := R_BC_TUAN_VGDKT(
            0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0           
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,V_TONG,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
             );                          
              --- Trình Thẩm phán bậc 3 con lai
      select count(v.id) into V_TONG from GSCM.gdttt_vuan v
                                    where v.toaanid = VTOAANID
                                    AND v.phongbanid = VPHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN vTuNgay AND vDenNgay
                                                    AND TT.TINHTRANGID in (6) --Trinh TP 6
                                                    AND EXISTS(SELECT 'X' FROM DM_CANBO CB WHERE cb.chucdanhid =2318 AND (CB.ID=TT.LANHDAOID or CB.ID=TT.TRINHTIEP_LANHDAO_ID))--TPBAC3
                                                    AND TT.NGAYTRA IS NULL
                                                ) 
                                     ;  
            v_table.extend;
            v_table(v_table.count) := R_BC_TUAN_VGDKT(
            0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0           
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,V_TONG,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
             );  
           --+ Án cho ý kiến để trình Thẩm phán TANDTC: --Dã duyệt
              select count(v.id) into V_TONG from GSCM.gdttt_vuan v
                                    where v.toaanid = VTOAANID
                                    AND v.phongbanid = VPHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN vTuNgay AND vDenNgay
                                                    AND (
                                                            (TT.TINHTRANGID in (6) --Trinh TP 6
                                                             AND EXISTS(SELECT 'X' FROM DM_CANBO CB WHERE cb.chucdanhid =2318 AND (CB.ID=TT.LANHDAOID or CB.ID=TT.TRINHTIEP_LANHDAO_ID))--TPBAC3
                                                            )
                                                            OR
                                                            (TT.TINHTRANGID in (5)) --Trinh VT
                                                        )
                                                    AND  TT.CAPTRINHTIEP=6   
                                                    AND EXISTS(SELECT 'X' FROM DM_CANBO CB WHERE cb.chucdanhid =486 AND (CB.ID=TT.LANHDAOID or CB.ID=TT.TRINHTIEP_LANHDAO_ID) )--TPTATC
                                                    AND  TT.NGAYTRA IS NOT NULL --đã duyệt
                                                ) 
                                     ;    
              v_table.extend;
            v_table(v_table.count) := R_BC_TUAN_VGDKT(
            0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0           
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,V_TONG,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
             );                           
             --+ Án cho ý kiến để trình Thẩm phán TANDTC: --Chưa duyệt
              select count(v.id) into V_TONG from GSCM.gdttt_vuan v
                                    where v.toaanid = VTOAANID
                                    AND v.phongbanid = VPHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN vTuNgay AND vDenNgay
                                                    AND (
                                                            (TT.TINHTRANGID in (6) --Trinh TP 6
                                                             AND EXISTS(SELECT 'X' FROM DM_CANBO CB WHERE cb.chucdanhid =2318 AND (CB.ID=TT.LANHDAOID or CB.ID=TT.TRINHTIEP_LANHDAO_ID))--TPBAC3
                                                            )
                                                            OR
                                                            (TT.TINHTRANGID in (5)) --Trinh VT
                                                        )
                                                    AND  TT.CAPTRINHTIEP=6   
                                                    AND EXISTS(SELECT 'X' FROM DM_CANBO CB WHERE cb.chucdanhid =486 AND (CB.ID=TT.LANHDAOID or CB.ID=TT.TRINHTIEP_LANHDAO_ID) )--TPTATC
                                                    AND  TT.NGAYTRA IS NULL --chưa duyệt
                                                ) 
                                     ;    
              v_table.extend;
            v_table(v_table.count) := R_BC_TUAN_VGDKT(
            0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0           
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,V_TONG,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
             );             
             --+ Án của Thẩm phán bậc 3 Đỗ Thị Hải Yến: -DA DUYET
              select count(v.id) into V_TONG from GSCM.gdttt_vuan v
                                    where v.toaanid = VTOAANID
                                    AND v.phongbanid = VPHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN vTuNgay AND vDenNgay
                                                    and TT.TINHTRANGID in (65) --Trinh VT
--                                                    AND EXISTS(SELECT 'X' FROM DM_CANBO CB WHERE cb.chucdanhid =2318 AND (CB.ID=TT.LANHDAOID or CB.ID=TT.TRINHTIEP_LANHDAO_ID))--TPBAC3
                                                    and (TT.LANHDAOID =92668 OR TT.TRINHTIEP_LANHDAO_ID=92668)--92668 Đỗ Thị Hải Yến      
                                                    AND  TT.NGAYTRA IS NOT NULL   
                                                ) 
                                     ;  
            v_table.extend;
            v_table(v_table.count) := R_BC_TUAN_VGDKT(
            0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0           
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,V_TONG,0,0
            ,0,0,0,0,0,0,0,0,0,0
             );        
              --+ Án của Thẩm phán bậc 3 Đỗ Thị Hải Yến: -CON LAI
              select count(v.id) into V_TONG from GSCM.gdttt_vuan v
                                    where v.toaanid = VTOAANID
                                    AND v.phongbanid = VPHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN vTuNgay AND vDenNgay
                                                    and TT.TINHTRANGID in (65) --Trinh VT
--                                                    AND EXISTS(SELECT 'X' FROM DM_CANBO CB WHERE cb.chucdanhid =2318 AND (CB.ID=TT.LANHDAOID or CB.ID=TT.TRINHTIEP_LANHDAO_ID))--TPBAC3
                                                    and (TT.LANHDAOID =92668 OR TT.TRINHTIEP_LANHDAO_ID=92668)--92668 Đỗ Thị Hải Yến      
                                                    AND  TT.NGAYTRA IS NULL   
                                                ) 
                                     ;  
            v_table.extend;
            v_table(v_table.count) := R_BC_TUAN_VGDKT(
            0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0           
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,V_TONG,0
            ,0,0,0,0,0,0,0,0,0,0
             );        
       --------Tong da giai quyet trong tuần---------------      
          select count(v.id) into V_TONG from GSCM.gdttt_vuan v
                    where v.toaanid = VTOAANID
                    AND v.phongbanid = VPHONGBANID
                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                    AND( EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ
                                               WHERE KQ.VUANID = V.ID
                                               AND kq.trangthai = 1
                                               AND kq.gdq_ngay BETWEEN  vTuNgay and vDenNgay 
                                               ) 
                         )
                                                    
            ;
        v_table.extend;
        v_table(v_table.count) := R_BC_TUAN_VGDKT(
         0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0           
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,V_TONG
            ,0,0,0,0,0,0,0,0,0,0
         ); 
      -- Tong tra loi don trong tuan                             
      select count(v.id) into V_TONG from GSCM.gdttt_vuan v
                                    where v.toaanid = VTOAANID
                                    AND v.phongbanid = VPHONGBANID
                                    and NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.gdq_ngay BETWEEN vTuNgay AND vDenNgay
                                                               AND kq.gqd_loaiketqua = 0
                                                               AND kq.trangthai = 1
                                                               ) 
                                     ;   
            v_table.extend;
            v_table(v_table.count) := R_BC_TUAN_VGDKT(
            0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0           
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
            ,V_TONG,0,0,0,0,0,0,0,0,0
             );         
      -- Tong khang nghi trong tuan                               
        select count(v.id) into V_TONG from GSCM.gdttt_vuan v
                                    where v.toaanid = VTOAANID
                                    AND v.phongbanid = VPHONGBANID
                                    and NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.gdq_ngay BETWEEN vTuNgay AND vDenNgay
                                                               AND kq.gqd_loaiketqua = 1
                                                               AND kq.trangthai = 1
                                                               ) 
                                     ;   
            v_table.extend;
            v_table(v_table.count) := R_BC_TUAN_VGDKT(
              0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0           
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
            ,0,V_TONG,0,0,0,0,0,0,0,0
             );           
      --  Tong xep don trong tuan                                 
    select count(v.id) into V_TONG from GSCM.gdttt_vuan v
                                    where v.toaanid = VTOAANID
                                    AND v.phongbanid = VPHONGBANID
                                    and NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.gdq_ngay BETWEEN vTuNgay AND vDenNgay
                                                               AND kq.gqd_loaiketqua in (2,3,4)
                                                               AND kq.trangthai = 1
                                                               ) 
                                     ;         
            v_table.extend;
            v_table(v_table.count) := R_BC_TUAN_VGDKT(
             0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0           
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,0,0,0,0,0,0,0,0
            ,0,0,V_TONG,0,0,0,0,0,0,0
             ); 
         RETURN v_table;    
END BC_TUAN_VGDKT_2;
FUNCTION BC_TUAN_VGDKT_2V
( 
    V_CANBO_TK_ID  IN VARCHAR2,
    V_LANHDAO_TK_ID  IN VARCHAR2,
    vToaAnID in number,
    vPhongBanID  in number,
    vTuNgay in date,
    vDenNgay in date,
    vLanhDaoID number
)
RETURN SYS_REFCURSOR
IS 
      V_CURSOR sys_refcursor; V1_KN_TANDCC VARCHAR2(3000);V2_DT_EXT VARCHAR2(3000);
      v_table T_BC_TUAN_VGDKT;V42_TT_TP_TATC_EXT VARCHAR2(3000);V43_T_VT_EXT VARCHAR2(3000);
      V43_T_PVT_EXT  VARCHAR2(3000);V43_T_TPB3_EXT VARCHAR2(3000);V43_YK_TPTC_EXT VARCHAR2(3000);
      V43_TTPB3_DOHAIYEN_EXT VARCHAR2(3000);V44_DA_GQ_TUAN_EXT VARCHAR2(3000);
BEGIN
        v_table := T_BC_TUAN_VGDKT();
        
      for item in(
      select pa.* from
     -- TABLE(PKG_VGDKT_BAOCAO_V2.BC_TUAN_VGDKT_2(null,null,1,401,to_date('01/10/2025','dd/MM/yyyy'),to_date('26/02/2026','dd/MM/yyyy'),null))pa
      TABLE(PKG_VGDKT_BAOCAO_V2.BC_TUAN_VGDKT_2(null,null,vToaAnID,vPhongBanID,vTuNgay,vDenNgay,null))pa
      )
      loop
                v_table.extend;
                v_table(v_table.count) := R_BC_TUAN_VGDKT(
                item.COLUMN_1,item.COLUMN_2,item.COLUMN_3,item.COLUMN_4,item.COLUMN_5,
                item.COLUMN_6,item.COLUMN_7,item.COLUMN_8,item.COLUMN_9,item.COLUMN_10,
                item.COLUMN_11,item.COLUMN_12,item.COLUMN_13,item.COLUMN_14,item.COLUMN_15,
                item.COLUMN_16,item.COLUMN_17,item.COLUMN_18,item.COLUMN_19,item.COLUMN_20,
                item.COLUMN_21,item.COLUMN_22,item.COLUMN_23,item.COLUMN_24,item.COLUMN_25,
                item.COLUMN_26,item.COLUMN_27,item.COLUMN_28,item.COLUMN_29,item.COLUMN_30,
                item.COLUMN_31,item.COLUMN_32,item.COLUMN_33,item.COLUMN_34,item.COLUMN_35,
                item.COLUMN_36,item.COLUMN_37,item.COLUMN_38,item.COLUMN_39,item.COLUMN_40,
                item.COLUMN_41,item.COLUMN_42,item.COLUMN_43,item.COLUMN_44,item.COLUMN_45,
                item.COLUMN_46,item.COLUMN_47,item.COLUMN_48,item.COLUMN_49,item.COLUMN_50,
                item.COLUMN_51,item.COLUMN_52,item.COLUMN_53,item.COLUMN_54,item.COLUMN_55,
                item.COLUMN_56,item.COLUMN_57,item.COLUMN_58,item.COLUMN_59,item.COLUMN_60
            ); 
      end loop;
      ---------------------
   for item in( select 
        SUM(pa.column_3)V1_KN_TANDCC_HCM,sum(pa.column_4)V1_KN_TANDCC_HN
        ,SUM(PA.COLUMN_5) V1_KN_TANDCC_DN
        ----
        ,SUM(PA.COLUMN_18+PA.COLUMN_19+PA.COLUMN_20+PA.COLUMN_21+PA.COLUMN_22+PA.COLUMN_23+PA.COLUMN_24+PA.COLUMN_25+PA.COLUMN_26)V2_DT_TONG
        ,SUM(PA.COLUMN_18) V2_TT_LDV_TPB3
        ,SUM(PA.COLUMN_19) V2_TT_TPTC,SUM(PA.COLUMN_20) V2_TT_TOTP,SUM(PA.COLUMN_21) V2_TT_PCA,SUM(PA.COLUMN_22) V2_TT_CA
        ,SUM(PA.COLUMN_23) V2_TT_DUTHAO_TLD,SUM(PA.COLUMN_24) V2_TT_DUTHAO_KN,SUM(PA.COLUMN_25) V2_TT_NGHIENCUULAI
        ,SUM(PA.COLUMN_26) V2_TTL_PCA
        ,SUM(PA.COLUMN_29) V4_NVTIEN_DANG_TRINH
        ,SUM(PA.COLUMN_30) V4_NVTIEN_DA_DUYET
        ,SUM(PA.COLUMN_31) V4_T_TOTP
        ,SUM(PA.COLUMN_33+PA.COLUMN_34)V42_TP_TATC_EXT_TONG
        ,SUM(PA.COLUMN_33) V42_CO_YKIEN
        ,SUM(PA.COLUMN_34) V42_CON_LAI
        --,V43_T_VT_EXT V43_T_VT_EXT    
        ,SUM(PA.COLUMN_40) V43_T_VT_DADUYET
        ,SUM(PA.COLUMN_41) V43_T_VT_CONLAI
       --  ,V43_T_PVT_EXT V43_T_PVT_EXT    
        ,SUM(PA.COLUMN_42) V43_T_PVT_DADUYET
        ,SUM(PA.COLUMN_43) V43_T_PVT_CONLAI
       -- ,V43_T_TPB3_EXT V43_T_TPB3_EXT
        ,SUM(PA.COLUMN_44) V43_T_TPB3_DADUYET
        ,SUM(PA.COLUMN_45) V43_T_TPB3_CONLAI
        --,V43_YK_TPTC_EXT V43_YK_TPTC_EXT
        ,SUM(PA.COLUMN_46) V43_YK_TPTC_DADUYET
        ,SUM(PA.COLUMN_47) V43_YK_TPTC_CONLAI
        --,V43_TTPB3_DOHAIYEN_EXT V43_TTPB3_DOHAIYEN_EXT
        ,SUM(PA.COLUMN_48) V43_TTPB3_DOHAIYEN_DADUYET
        ,SUM(PA.COLUMN_49) V43_TTPB3_DOHAIYEN_CONLAI
        
        ,SUM(PA.COLUMN_50) V44_DA_GQ_TUAN
        --,V2_DA_GQ_TUAN_EXT V2_DA_GQ_TUAN_EXT
        ,SUM(PA.COLUMN_51) V44_GQ_TLD_TUAN
        ,SUM(PA.COLUMN_52) V44_GQ_KN_TUAN
        ,SUM(PA.COLUMN_53) V44_GQ_KHAC_TUAN
        -----
    from TABLE(v_table)pa
    )
      loop
        if(item.V44_DA_GQ_TUAN>0)then
             V44_DA_GQ_TUAN_EXT:='(';
             if(item.V44_GQ_TLD_TUAN>0)then
               V44_DA_GQ_TUAN_EXT:=V44_DA_GQ_TUAN_EXT||item.V44_GQ_TLD_TUAN||' vụ trả lời đơn';
             end if;  
              if(item.V44_GQ_KN_TUAN>0)then
               V44_DA_GQ_TUAN_EXT:=V44_DA_GQ_TUAN_EXT||', '||item.V44_GQ_KN_TUAN||' vụ kháng nghị';
             end if;  
                if(item.V44_GQ_KHAC_TUAN>0)then
               V44_DA_GQ_TUAN_EXT:=V44_DA_GQ_TUAN_EXT||', '||item.V44_GQ_KHAC_TUAN||' vụ xử lý khác';
             end if;  
              V44_DA_GQ_TUAN_EXT:=V44_DA_GQ_TUAN_EXT||')';
         end if;
         
      if((item.V43_YK_TPTC_DADUYET+item.V43_YK_TPTC_CONLAI)>0)then
             V43_YK_TPTC_EXT:='(';
             if(item.V43_YK_TPTC_DADUYET>0)then
               V43_YK_TPTC_EXT:=V43_YK_TPTC_EXT||'đã duyệt '||item.V43_YK_TPTC_DADUYET||' vụ';
             end if;  
              if(item.V43_YK_TPTC_CONLAI>0)then
               V43_YK_TPTC_EXT:=V43_YK_TPTC_EXT||' còn lại '||item.V43_YK_TPTC_CONLAI||' vụ';
             end if;  
              V43_YK_TPTC_EXT:=V43_YK_TPTC_EXT||')';
         end if;
            if((item.V43_TTPB3_DOHAIYEN_DADUYET+item.V43_TTPB3_DOHAIYEN_CONLAI)>0)then
             V43_TTPB3_DOHAIYEN_EXT:='(';
             if(item.V43_TTPB3_DOHAIYEN_DADUYET>0)then
               V43_TTPB3_DOHAIYEN_EXT:=V43_TTPB3_DOHAIYEN_EXT||'đã duyệt '||item.V43_TTPB3_DOHAIYEN_DADUYET||' vụ';
             end if;  
              if(item.V43_TTPB3_DOHAIYEN_CONLAI>0)then
               V43_TTPB3_DOHAIYEN_EXT:=V43_TTPB3_DOHAIYEN_EXT||' còn lại '||item.V43_TTPB3_DOHAIYEN_CONLAI||' vụ';
             end if;  
              V43_TTPB3_DOHAIYEN_EXT:=V43_TTPB3_DOHAIYEN_EXT||')';
         end if;
         if((item.V43_T_VT_DADUYET+item.V43_T_VT_CONLAI)>0)then
             V43_T_VT_EXT:='(';
             if(item.V43_T_VT_DADUYET>0)then
               V43_T_VT_EXT:=V43_T_VT_EXT||'đã duyệt '||item.V43_T_VT_DADUYET||' vụ';
             end if;  
              if(item.V43_T_VT_CONLAI>0)then
               V43_T_VT_EXT:=V43_T_VT_EXT||' còn lại '||item.V43_T_VT_CONLAI||' vụ';
             end if;  
              V43_T_VT_EXT:=V43_T_VT_EXT||')';
         end if;
          if((item.V43_T_PVT_DADUYET+item.V43_T_PVT_CONLAI)>0)then
             V43_T_PVT_EXT:='(';
             if(item.V43_T_PVT_DADUYET>0)then
               V43_T_PVT_EXT:=V43_T_PVT_EXT||'đã duyệt '||item.V43_T_PVT_DADUYET||' vụ';
             end if;  
              if(item.V43_T_PVT_CONLAI>0)then
               V43_T_PVT_EXT:=V43_T_PVT_EXT||' còn lại '||item.V43_T_PVT_CONLAI||' vụ';
             end if;  
              V43_T_PVT_EXT:=V43_T_PVT_EXT||')';
         end if;
           if((item.V43_T_TPB3_DADUYET+item.V43_T_TPB3_CONLAI)>0)then
             V43_T_TPB3_EXT:='(';
             if(item.V43_T_TPB3_DADUYET>0)then
               V43_T_TPB3_EXT:=V43_T_TPB3_EXT||'đã duyệt '||item.V43_T_TPB3_DADUYET||' vụ';
             end if;  
              if(item.V43_T_TPB3_CONLAI>0)then
               V43_T_TPB3_EXT:=V43_T_TPB3_EXT||' còn lại '||item.V43_T_TPB3_CONLAI||' vụ';
             end if;  
              V43_T_TPB3_EXT:=V43_T_TPB3_EXT||')';
         end if;
            IF(item.V1_KN_TANDCC_HCM>0)THEN
               V1_KN_TANDCC:=' Chánh án TANDCC tại Thành phố Hồ Chí Minh kháng nghị '||item.V1_KN_TANDCC_HCM||' vụ;';
             END IF;
             IF(item.V1_KN_TANDCC_HN>0)THEN
             V1_KN_TANDCC:=V1_KN_TANDCC||' Chánh án TANDCC tại Thành phố Hà Nội kháng nghị '||item.V1_KN_TANDCC_HN||' vụ;';
              END IF;
              IF(item.V1_KN_TANDCC_DN>0)THEN
             V1_KN_TANDCC:=V1_KN_TANDCC||' Chánh án TANDCC tại Thành phố Đà Nẵng kháng nghị '||item.V1_KN_TANDCC_DN||' vụ;';
              END IF;
              ---------
          IF(item.V2_DT_TONG>0)THEN
              V2_DT_EXT:='(gồm';
                    IF(item.V2_TT_LDV_TPB3>0)then
                       V2_DT_EXT:=V2_DT_EXT||' đang trình Lãnh đạo Vụ và Thẩm phán bậc 3 là '||item.V2_TT_LDV_TPB3||' vụ;';
                    end if;
                      IF(item.V2_TT_TPTC>0)then
                       V2_DT_EXT:=V2_DT_EXT||' trình Thẩm phán TANDTC '||item.V2_TT_TPTC||' vụ;';
                    end if;
                    IF(item.V2_TT_TOTP>0)then
                       V2_DT_EXT:=V2_DT_EXT||' trình Tổ Thẩm phán '||item.V2_TT_TOTP||' vụ;';
                    end if;
                      IF(item.V2_TT_PCA>0)then
                       V2_DT_EXT:=V2_DT_EXT||' đang trình Phó Chánh án '||item.V2_TT_PCA||' vụ;';
                    end if;
                     IF(item.V2_TT_CA>0)then
                       V2_DT_EXT:=V2_DT_EXT||' đang trình Chánh án '||item.V2_TT_CA||' vụ;';
                    end if;
                     IF(item.V2_TT_DUTHAO_TLD>0)then
                       V2_DT_EXT:=V2_DT_EXT||' đang dự thảo trả lời đơn '||item.V2_TT_DUTHAO_TLD||' vụ;';
                    end if;
                     IF(item.V2_TT_DUTHAO_KN>0)then
                       V2_DT_EXT:=V2_DT_EXT||' dự thảo kháng nghị '||item.V2_TT_DUTHAO_KN||' vụ;';
                    end if;
                    IF(item.V2_TT_NGHIENCUULAI>0)then
                       V2_DT_EXT:=V2_DT_EXT||' xác minh, báo cáo lại '||item.V2_TT_NGHIENCUULAI||' vụ;';
                    end if;
                     IF(item.V2_TTL_PCA>0)then
                       V2_DT_EXT:=V2_DT_EXT||' đang hoàn thiện tờ trình để báo cáo Phó Chánh án, Chánh án '||item.V2_TTL_PCA||' vụ;';
                    end if;
                      V2_DT_EXT:=rtrim(V2_DT_EXT,';')||');';
          END IF;
          IF(ITEM.V42_TP_TATC_EXT_TONG>0)THEN
          V42_TT_TP_TATC_EXT:='(';
          IF(ITEM.V42_CO_YKIEN>0)then
             V42_TT_TP_TATC_EXT:=V42_TT_TP_TATC_EXT||'đã cho ý kiến  '||ITEM.V42_CO_YKIEN||' vụ';
            end if; 
              IF(ITEM.V42_CON_LAI>0)then
             V42_TT_TP_TATC_EXT:=V42_TT_TP_TATC_EXT||', còn lại '||ITEM.V42_CON_LAI||' vụ';
            end if; 
          V42_TT_TP_TATC_EXT:=V42_TT_TP_TATC_EXT||').';
          END IF;
       end loop;

      OPEN V_CURSOR FOR      
        select
        
         SUM(PA.COLUMN_35) V43_T_VT
        ,SUM(PA.COLUMN_36) V43_T_PVT
        ,SUM(PA.COLUMN_37) V43_T_TPB3        
        ,SUM(PA.COLUMN_38) V43_YK_TPTC
        ,SUM(PA.COLUMN_39) V43_TTPB3_DOHAIYEN
        
        ,V43_T_VT_EXT V43_T_VT_EXT    
        ,SUM(PA.COLUMN_40) V43_T_VT_DADUYET
        ,SUM(PA.COLUMN_41) V43_T_VT_CONLAI
         ,V43_T_PVT_EXT V43_T_PVT_EXT    
        ,SUM(PA.COLUMN_42) V43_T_PVT_DADUYET
        ,SUM(PA.COLUMN_43) V43_T_PVT_CONLAI
        ,V43_T_TPB3_EXT V43_T_TPB3_EXT
        ,SUM(PA.COLUMN_44) V43_T_TPB3_DADUYET
        ,SUM(PA.COLUMN_45) V43_T_TPB3_CONLAI
        
        ,V43_YK_TPTC_EXT V43_YK_TPTC_EXT
        ,SUM(PA.COLUMN_46) V43_YK_TPTC_DADUYET
        ,SUM(PA.COLUMN_47) V43_YK_TPTC_CONLAI
        ,V43_TTPB3_DOHAIYEN_EXT V43_TTPB3_DOHAIYEN_EXT
        ,SUM(PA.COLUMN_48) V43_TTPB3_DOHAIYEN_DADUYET
        ,SUM(PA.COLUMN_49) V43_TTPB3_DOHAIYEN_CONLAI
        
        ,SUM(PA.COLUMN_50) V44_DA_GQ_TUAN
        ,V44_DA_GQ_TUAN_EXT V44_DA_GQ_TUAN_EXT
        ,SUM(PA.COLUMN_51) V44_GQ_TLD_TUAN
        ,SUM(PA.COLUMN_52) V44_GQ_KN_TUAN
        ,SUM(PA.COLUMN_53) V44_GQ_KHAC_TUAN
        
        ,sum(pa.column_1)V1_PHAI_XX 
        ,sum(pa.column_2)V1_KN_TANDTC
        ,V1_KN_TANDCC V1_KN_TANDCC
        ,SUM(pa.column_3)V1_KN_TANDCC_HCM,sum(pa.column_4)V1_KN_TANDCC_HN
        ,SUM(PA.COLUMN_5) V1_KN_TANDCC_DN,SUM(PA.COLUMN_6) V1_KN_VKSNDTC,SUM(PA.COLUMN_7) V1_TM_HDTP,SUM(PA.COLUMN_8) V1_CONLAI
        ,SUM(PA.COLUMN_9) V1_CONLAI_CA,SUM(PA.COLUMN_10) V1_CONLAI_VKS
        ,SUM(PA.COLUMN_11) V2_PHAIGQ,SUM(PA.COLUMN_12) V2_DA_GQ,SUM(PA.COLUMN_13) V2_GQ_TLD,SUM(PA.COLUMN_14) V2_GQ_KN,SUM(PA.COLUMN_15) V2_GQ_KHAC
        ,SUM(PA.COLUMN_16) V2_CONLAI,SUM(PA.COLUMN_17) V2_DANG_TRINH
        ,V2_DT_EXT V2_DT_EXT
        ,SUM(PA.COLUMN_18) V2_TT_LDV_TPB3
        ,SUM(PA.COLUMN_19) V2_TT_TPTC,SUM(PA.COLUMN_20) V2_TT_TOTP,SUM(PA.COLUMN_21) V2_TT_PCA,SUM(PA.COLUMN_22) V2_TT_CA
        ,SUM(PA.COLUMN_23) V2_TT_DUTHAO_TLD,SUM(PA.COLUMN_24) V2_TT_DUTHAO_KN,SUM(PA.COLUMN_25) V2_TT_NGHIENCUULAI
        ,SUM(PA.COLUMN_26) V2_TTL_PCA       
        ,SUM(PA.COLUMN_27) V2_CHUACO_TT  
        ,SUM(PA.COLUMN_28) V4_TT_PCA_NVTIEN
        ,SUM(PA.COLUMN_29) V4_NVTIEN_DANG_TRINH
        ,SUM(PA.COLUMN_30) V4_NVTIEN_DA_DUYET
        ,SUM(PA.COLUMN_31) V4_T_TOTP
        ,SUM(PA.COLUMN_32) V42_TT_TP_TATC
        ,V42_TT_TP_TATC_EXT V42_TT_TP_TATC_EXT
        ,SUM(PA.COLUMN_33) V42_CO_YKIEN
        ,SUM(PA.COLUMN_34) V42_CON_LAI
       from TABLE(v_table)pa 
        ;
       ------------ 
      RETURN V_CURSOR;   
END BC_TUAN_VGDKT_2V;
END PKG_VGDKT_BAOCAO_V2;