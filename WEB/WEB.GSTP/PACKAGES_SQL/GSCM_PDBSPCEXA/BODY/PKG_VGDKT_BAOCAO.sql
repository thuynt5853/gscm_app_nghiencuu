--------------------------------------------------------
--  DDL for Package Body PKG_VGDKT_BAOCAO
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_VGDKT_BAOCAO" AS


PROCEDURE TONGHOPSOLIEU_8A_EXP
(  
    V_ToaAnID	in	VARCHAR2,
    vTuNgay	in VARCHAR2,
    vDenNgay	in VARCHAR2,
    curReturn OUT sys_refcursor 
)
AS
    v_TIME_FROM VARCHAR2(50);v_TIME_TO VARCHAR2(50);  
    V_TABLE T_GDTTT_THONGKE_8A;
    V_TABLE_ALL T_GDTTT_THONGKE_8A;
    vvToaAnID NUMBER;
    vCursur sys_refcursor;
    vCheck number;
    vTongCOLUMN_1 NUMBER:=0;vTongCOLUMN_2 NUMBER:=0;vTongCOLUMN_3 NUMBER:=0;vTongCOLUMN_4 NUMBER:=0;vTongCOLUMN_5 NUMBER:=0;vTongCOLUMN_6 NUMBER:=0;vTongCOLUMN_7 NUMBER:=0;vTongCOLUMN_8 NUMBER:=0;vTongCOLUMN_9 NUMBER:=0;vTongCOLUMN_10 NUMBER:=0;vTongCOLUMN_11 NUMBER:=0;vTongCOLUMN_12 NUMBER:=0;
    vTongCOLUMN_13 NUMBER:=0;vTongCOLUMN_14 NUMBER:=0;vTongCOLUMN_15 NUMBER:=0;vTongCOLUMN_16 NUMBER:=0;vTongCOLUMN_17 NUMBER:=0;vTongCOLUMN_18 NUMBER:=0;vTongCOLUMN_19 NUMBER:=0;vTongCOLUMN_20 NUMBER:=0;vTongCOLUMN_21 NUMBER:=0;vTongCOLUMN_22 NUMBER:=0;vTongCOLUMN_23 NUMBER:=0;vTongCOLUMN_24 NUMBER:=0;
    vTongCOLUMN_25 NUMBER:=0;vTongCOLUMN_26 NUMBER:=0;vTongCOLUMN_27 NUMBER:=0;vTongCOLUMN_28 NUMBER:=0;vTongCOLUMN_29 NUMBER:=0;vTongCOLUMN_30 NUMBER:=0;vTongCOLUMN_31 NUMBER:=0;vTongCOLUMN_32 NUMBER:=0;vTongCOLUMN_33 NUMBER:=0;vTongCOLUMN_34 NUMBER:=0;vTongCOLUMN_35 NUMBER:=0;vTongCOLUMN_36 NUMBER:=0;

    vTongALLCOLUMN_1 NUMBER:=0;vTongALLCOLUMN_2 NUMBER:=0;vTongALLCOLUMN_3 NUMBER:=0;vTongALLCOLUMN_4 NUMBER:=0;vTongALLCOLUMN_5 NUMBER:=0;vTongALLCOLUMN_6 NUMBER:=0;vTongALLCOLUMN_7 NUMBER:=0;vTongALLCOLUMN_8 NUMBER:=0;vTongALLCOLUMN_9 NUMBER:=0;vTongALLCOLUMN_10 NUMBER:=0;vTongALLCOLUMN_11 NUMBER:=0;vTongALLCOLUMN_12 NUMBER:=0;
    vTongALLCOLUMN_13 NUMBER:=0;vTongALLCOLUMN_14 NUMBER:=0;vTongALLCOLUMN_15 NUMBER:=0;vTongALLCOLUMN_16 NUMBER:=0;vTongALLCOLUMN_17 NUMBER:=0;vTongALLCOLUMN_18 NUMBER:=0;vTongALLCOLUMN_19 NUMBER:=0;vTongALLCOLUMN_20 NUMBER:=0;vTongALLCOLUMN_21 NUMBER:=0;vTongALLCOLUMN_22 NUMBER:=0;vTongALLCOLUMN_23 NUMBER:=0;vTongALLCOLUMN_24 NUMBER:=0;
    vTongALLCOLUMN_25 NUMBER:=0;vTongALLCOLUMN_26 NUMBER:=0;vTongALLCOLUMN_27 NUMBER:=0;vTongALLCOLUMN_28 NUMBER:=0;vTongALLCOLUMN_29 NUMBER:=0;vTongALLCOLUMN_30 NUMBER:=0;vTongALLCOLUMN_31 NUMBER:=0;vTongALLCOLUMN_32 NUMBER:=0;vTongALLCOLUMN_33 NUMBER:=0;vTongALLCOLUMN_34 NUMBER:=0;vTongALLCOLUMN_35 NUMBER:=0;vTongALLCOLUMN_36 NUMBER:=0;

BEGIN
    v_table := T_GDTTT_THONGKE_8A();
    V_TABLE_ALL := T_GDTTT_THONGKE_8A();
    
    v_TIME_FROM:=to_date(trim(vTuNgay)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');v_TIME_TO:=to_date(trim(vDenNgay)||' 23:59:59','dd/MM/yyyy HH24:MI:SS');
                ----COLUMN_5-----------------
               FOR item IN ( SELECT dmta.CAPCHAID,dmta.TEN,d.BAQD_LOAIAN
                                ,Decode(NVL(d.BAQD_LOAIAN,0),1,'Hình sự',2,'Dân sự',5,'Lao động',3,'HNGD',4,'KDTM',6,'Hành chính','') TENLOAIAN
                                ,count(D.id) colnum_5
                                  FROM GDTTT_DON d  
                                  LEFT JOIN dm_toaan dmta on dmta.id= DECODE(d.BAQD_CAPXETXU,4,d.BAQD_TOAANID,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID_ST)
                                  --left join BCTK_APP_V3.tc_courts v3 on v3.MADONGBO=dmta.MADONGBO                                 
                                  where 
                                  dmta.madongbo is not null  
                                  AND D.LOAIDON NOT IN(4,5)--4 Văn bản hành chính, Tài liệu chung 5 Hồ sơ Kháng nghị GĐT,TT
                                  AND d.toaanid = V_ToaAnID --sau se truyen don vi vao
                                  AND D.NGAYNHANDON  <= Trunc(to_date(vDenNgay,'dd/mm/yyyy'))
                                  AND d.NGAYXULYDON between Trunc(to_date(vTuNgay,'dd/mm/yyyy')) and Trunc(to_date(vDenNgay,'dd/mm/yyyy'))
                                  AND ( (D.ISTHULY =2 AND D.CD_LOAI=0) -- Da thu ly
                                            OR d.CD_LOAI in (1,2)  -- Khong thuoc tham quyen
                                            ) 
                                  AND NVL(d.BAQD_LOAIAN,0) > 0                                  
                                  GROUP BY  dmta.CAPCHAID,dmta.TEN,d.BAQD_LOAIAN
                                 
                                  
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_THONGKE_8A(
                        item.CAPCHAID,item.BAQD_LOAIAN,item.TEN,item.TENLOAIAN,
                        0,0,0,0,item.colnum_5,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0
                        );   
                END LOOP;
                
                ----COLUMN_6-----------------
               FOR item IN ( SELECT dmta.CAPCHAID,dmta.TEN,d.BAQD_LOAIAN
                                 ,Decode(NVL(d.BAQD_LOAIAN,0),1,'Hình sự',2,'Dân sự',5,'Lao động',3,'HNGD',4,'KDTM',6,'Hành chính','') TENLOAIAN
                                 ,count(D.id) colnum_6
                                  FROM GDTTT_DON d 
                                  LEFT JOIN dm_toaan dmta on dmta.id= DECODE(d.BAQD_CAPXETXU,4,d.BAQD_TOAANID,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID_ST)
                                  --left join BCTK_APP_V3.tc_courts v3 on v3.MADONGBO=dmta.MADONGBO                                 
                                  where 
                                  dmta.madongbo is not null  
                                  AND D.LOAIDON NOT IN(4,5)--4 Văn bản hành chính, Tài liệu chung 5 Hồ sơ Kháng nghị GĐT,TT
                                  AND d.toaanid = V_ToaAnID --sau se truyen don vi vao
                                  AND D.NGAYNHANDON  <= Trunc(to_date(vDenNgay,'dd/mm/yyyy'))
                                  AND d.NGAYXULYDON between Trunc(to_date(vTuNgay,'dd/mm/yyyy')) and Trunc(to_date(vDenNgay,'dd/mm/yyyy'))
                                  AND D.ISTHULY =1 
                                  AND D.CD_LOAI=0
                                  AND NVL(d.BAQD_LOAIAN,0) > 0
                                  GROUP BY  dmta.CAPCHAID,dmta.TEN,d.BAQD_LOAIAN
                                 
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_THONGKE_8A(
                        item.CAPCHAID,item.BAQD_LOAIAN,item.TEN,item.TENLOAIAN,
                        0,0,0,0,0,item.colnum_6,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0
                        );   
                END LOOP;

                 ----COLUMN_7-----------------
               FOR item IN ( SELECT dmta.CAPCHAID,dmta.TEN,d.BAQD_LOAIAN
                                   ,Decode(NVL(d.BAQD_LOAIAN,0),1,'Hình sự',2,'Dân sự',5,'Lao động',3,'HNGD',4,'KDTM',6,'Hành chính','') TENLOAIAN
                                   ,count(D.id) colnum_7
                                  FROM GDTTT_DON d  
                                  LEFT JOIN dm_toaan dmta on dmta.id= DECODE(d.BAQD_CAPXETXU,4,d.BAQD_TOAANID,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID_ST)
                                  --left join BCTK_APP_V3.tc_courts v3 on v3.MADONGBO=dmta.MADONGBO                                 
                                  where dmta.madongbo is not null AND 
                                  D.LOAIDON NOT IN(4,5)--4 Văn bản hành chính, Tài liệu chung 5 Hồ sơ Kháng nghị GĐT,TT
                                  AND d.toaanid = V_ToaAnID --sau se truyen don vi vao
                                  AND D.NGAYNHANDON  <= Trunc(to_date(vDenNgay,'dd/mm/yyyy'))
                                  AND d.NGAYXULYDON between Trunc(to_date(vTuNgay,'dd/mm/yyyy')) and Trunc(to_date(vDenNgay,'dd/mm/yyyy'))
                                  AND D.ISTHULY =1 
                                  AND D.CD_LOAI=0
                                  AND NVL(d.BAQD_LOAIAN,0) > 0
                                  GROUP BY  dmta.CAPCHAID,dmta.TEN,d.BAQD_LOAIAN
                                 
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_THONGKE_8A(
                        item.CAPCHAID,item.BAQD_LOAIAN,item.TEN,item.TENLOAIAN,
                        0,0,0,0,0,0,item.colnum_7,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0
                        );   
                END LOOP;
                
            ----COLUMN_9-----------------Cũ còn lại
               FOR item IN ( SELECT dmta.CAPCHAID,dmta.TEN,d.BAQD_LOAIAN
                                   ,Decode(NVL(d.BAQD_LOAIAN,0),1,'Hình sự',2,'Dân sự',5,'Lao động',3,'HNGD',4,'KDTM',6,'Hành chính','') TENLOAIAN
                                   ,count(D.id)  colnum_9
                                  FROM GDTTT_DON d  
                                  LEFT JOIN dm_toaan dmta on dmta.id= DECODE(d.BAQD_CAPXETXU,4,d.BAQD_TOAANID,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID_ST)
                                  --left join BCTK_APP_V3.tc_courts v3 on v3.MADONGBO=dmta.MADONGBO   
                                  LEFT JOIN GDTTT_VUAN v on d.VUVIECID = v.id
                                  where 
                                  dmta.madongbo is not null AND D.LOAIDON NOT IN(4,5)--4 Văn bản hành chính, Tài liệu chung 5 Hồ sơ Kháng nghị GĐT,TT
                                  AND d.toaanid = V_ToaAnID --sau se truyen don vi vao
                                  AND d.NGAYXULYDON between Trunc(to_date(vTuNgay,'dd/mm/yyyy')) and Trunc(to_date(vDenNgay,'dd/mm/yyyy'))
                                  AND D.ISTHULY =1 
                                  AND D.CD_LOAI=0
                                  AND D.TL_NGAY < Trunc(to_date(vTuNgay,'dd/mm/yyyy'))
                                  AND (d.VUVIECID IS NULL
                                        OR v.gqd_loaiketqua NOT IN (0,1,2,3,4)
                                        OR(v.gqd_loaiketqua in (0,1,2,3,4)
                                                  and (CASE WHEN (V.GQD_NGAYPHATHANHCV IS NOT NULL AND V.GDQ_NGAY IS NOT NULL)  THEN  V.GDQ_NGAY 
                                                            WHEN ( V.GQD_NGAYPHATHANHCV IS  NULL AND V.GDQ_NGAY IS NOT NULL)  THEN  V.GDQ_NGAY 
                                                            WHEN (V.GQD_NGAYPHATHANHCV IS NOT NULL AND V.GDQ_NGAY IS NULL) THEN  V.GQD_NGAYPHATHANHCV END) > Trunc(to_date(vTuNgay,'dd/mm/yyyy'))
                                             )
                                       )
                                                     
                                               
                                  AND NVL(d.BAQD_LOAIAN,0) > 0
                                  GROUP BY  dmta.CAPCHAID,dmta.TEN,d.BAQD_LOAIAN
                                 
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_THONGKE_8A(
                        item.CAPCHAID,item.BAQD_LOAIAN,item.TEN,item.TENLOAIAN,
                        0,0,0,0,0,0,0,0,item.colnum_9,0,
                        0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0
                        );   
                END LOOP;
                
                ----COLUMN_10-----------------Mới thụ lý
               FOR item IN ( SELECT dmta.CAPCHAID,dmta.TEN,d.BAQD_LOAIAN
                                   ,Decode(NVL(d.BAQD_LOAIAN,0),1,'Hình sự',2,'Dân sự',5,'Lao động',3,'HNGD',4,'KDTM',6,'Hành chính','') TENLOAIAN
                                   ,count(D.id)  colnum_10
                                  FROM GDTTT_DON d  
                                  LEFT JOIN dm_toaan dmta on dmta.id= DECODE(d.BAQD_CAPXETXU,4,d.BAQD_TOAANID,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID_ST)
                                  --left join BCTK_APP_V3.tc_courts v3 on v3.MADONGBO=dmta.MADONGBO   
                                  LEFT JOIN GDTTT_VUAN v on d.VUVIECID = v.id
                                  where 
                                  dmta.madongbo is not null AND D.LOAIDON NOT IN(4,5)--4 Văn bản hành chính, Tài liệu chung 5 Hồ sơ Kháng nghị GĐT,TT
                                  AND d.toaanid = V_ToaAnID --sau se truyen don vi vao
                                  AND D.ISTHULY =1 
                                  AND D.CD_LOAI=0
                                  AND D.TL_NGAY between Trunc(to_date(vTuNgay,'dd/mm/yyyy')) and Trunc(to_date(vDenNgay,'dd/mm/yyyy'))
                                         
                                  AND NVL(d.BAQD_LOAIAN,0) > 0
                                  GROUP BY  dmta.CAPCHAID,dmta.TEN,d.BAQD_LOAIAN
                                 
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_THONGKE_8A(
                        item.CAPCHAID,item.BAQD_LOAIAN,item.TEN,item.TENLOAIAN,
                        0,0,0,0,0,0,0,0,0,item.colnum_10,
                        0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0
                        );   
                END LOOP;
                
                 ----COLUMN_13-------Phải giải quyết---------MA = 9.3.5-Có kiến nghị của đại biểu Quốc hội 
               FOR item IN ( SELECT dmta.CAPCHAID,dmta.TEN,d.BAQD_LOAIAN
                                   ,Decode(NVL(d.BAQD_LOAIAN,0),1,'Hình sự',2,'Dân sự',5,'Lao động',3,'HNGD',4,'KDTM',6,'Hành chính','') TENLOAIAN
                                   ,count(D.id) colnum_13
                                  FROM GDTTT_DON d  
                                  LEFT JOIN dm_toaan dmta on dmta.id= DECODE(d.BAQD_CAPXETXU,4,d.BAQD_TOAANID,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID_ST)
                                  --left join BCTK_APP_V3.tc_courts v3 on v3.MADONGBO=dmta.MADONGBO   
                                  LEFT JOIN GDTTT_VUAN v on d.VUVIECID = v.id
                                  LEFT JOIN DM_DATAITEM cv on d.LOAICONGVAN = cv.id
                                  where 
                                  dmta.madongbo is not null AND D.LOAIDON NOT IN(4,5)--4 Văn bản hành chính, Tài liệu chung 5 Hồ sơ Kháng nghị GĐT,TT
                                  AND d.toaanid = V_ToaAnID --sau se truyen don vi vao
                                  AND D.ISTHULY =1 
                                  AND D.CD_LOAI=0
                                  AND (D.TL_NGAY between Trunc(to_date(vTuNgay,'dd/mm/yyyy')) and Trunc(to_date(vDenNgay,'dd/mm/yyyy'))
                                        OR
                                            (D.TL_NGAY < Trunc(to_date(vTuNgay,'dd/mm/yyyy'))
                                                  AND (d.VUVIECID IS NULL
                                                        OR v.gqd_loaiketqua NOT IN (0,1,2,3,4)
                                                        OR(v.gqd_loaiketqua in (0,1,2,3,4)
                                                                  and (CASE WHEN (V.GQD_NGAYPHATHANHCV IS NOT NULL AND V.GDQ_NGAY IS NOT NULL)  THEN  V.GDQ_NGAY 
                                                                            WHEN ( V.GQD_NGAYPHATHANHCV IS  NULL AND V.GDQ_NGAY IS NOT NULL)  THEN  V.GDQ_NGAY 
                                                                            WHEN (V.GQD_NGAYPHATHANHCV IS NOT NULL AND V.GDQ_NGAY IS NULL) THEN  V.GQD_NGAYPHATHANHCV END) > Trunc(to_date(vTuNgay,'dd/mm/yyyy'))
                                                             )
                                                       )
                                            )
                                  )
                                  AND cv.MA = '9.3.5'      
                                  AND NVL(d.BAQD_LOAIAN,0) > 0
                                  GROUP BY  dmta.CAPCHAID,dmta.TEN,d.BAQD_LOAIAN
                                 
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_THONGKE_8A(
                        item.CAPCHAID,item.BAQD_LOAIAN,item.TEN,item.TENLOAIAN,
                        0,0,0,0,0,0,0,0,0,0,
                        0,0,item.colnum_13,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0
                        );   
                END LOOP;
                
                  ----COLUMN_14-------Phải giải quyết---------MA = 9.3.8-Có kiến nghị của Ủy ban tư pháp của Quốc hội 
               FOR item IN ( SELECT dmta.CAPCHAID,dmta.TEN,d.BAQD_LOAIAN
                                   ,Decode(NVL(d.BAQD_LOAIAN,0),1,'Hình sự',2,'Dân sự',5,'Lao động',3,'HNGD',4,'KDTM',6,'Hành chính','') TENLOAIAN
                                   ,count(D.id)  colnum_14
                                  FROM GDTTT_DON d  
                                  LEFT JOIN dm_toaan dmta on dmta.id= DECODE(d.BAQD_CAPXETXU,4,d.BAQD_TOAANID,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID_ST)
                                  --left join BCTK_APP_V3.tc_courts v3 on v3.MADONGBO=dmta.MADONGBO   
                                  LEFT JOIN GDTTT_VUAN v on d.VUVIECID = v.id
                                  LEFT JOIN DM_DATAITEM cv on d.LOAICONGVAN = cv.id
                                  where 
                                  dmta.madongbo is not null AND D.LOAIDON NOT IN(4,5)--4 Văn bản hành chính, Tài liệu chung 5 Hồ sơ Kháng nghị GĐT,TT
                                  AND d.toaanid = V_ToaAnID --sau se truyen don vi vao
                                  AND D.ISTHULY =1 
                                  AND D.CD_LOAI=0
                                  AND (D.TL_NGAY between Trunc(to_date(vTuNgay,'dd/mm/yyyy')) and Trunc(to_date(vDenNgay,'dd/mm/yyyy'))
                                        OR
                                            (D.TL_NGAY < Trunc(to_date(vTuNgay,'dd/mm/yyyy'))
                                                  AND (d.VUVIECID IS NULL
                                                        OR v.gqd_loaiketqua NOT IN (0,1,2,3,4)
                                                        OR(v.gqd_loaiketqua in (0,1,2,3,4)
                                                                  and (CASE WHEN (V.GQD_NGAYPHATHANHCV IS NOT NULL AND V.GDQ_NGAY IS NOT NULL)  THEN  V.GDQ_NGAY 
                                                                            WHEN ( V.GQD_NGAYPHATHANHCV IS  NULL AND V.GDQ_NGAY IS NOT NULL)  THEN  V.GDQ_NGAY 
                                                                            WHEN (V.GQD_NGAYPHATHANHCV IS NOT NULL AND V.GDQ_NGAY IS NULL) THEN  V.GQD_NGAYPHATHANHCV END) > Trunc(to_date(vTuNgay,'dd/mm/yyyy'))
                                                             )
                                                       )
                                            )
                                  )
                                  AND cv.MA = '9.3.8'      
                                  AND NVL(d.BAQD_LOAIAN,0) > 0
                                  GROUP BY  dmta.CAPCHAID,dmta.TEN,d.BAQD_LOAIAN
                                 
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_THONGKE_8A(
                        item.CAPCHAID,item.BAQD_LOAIAN,item.TEN,item.TENLOAIAN,
                        0,0,0,0,0,0,0,0,0,0,
                        0,0,0,item.colnum_14,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0
                        );   
                END LOOP;
                
              ----COLUMN_15-------Phải giải quyết---------MA = 9.3.7-Các cơ quan khác của Quốc hội
               FOR item IN ( SELECT dmta.CAPCHAID,dmta.TEN,d.BAQD_LOAIAN
                                   ,Decode(NVL(d.BAQD_LOAIAN,0),1,'Hình sự',2,'Dân sự',5,'Lao động',3,'HNGD',4,'KDTM',6,'Hành chính','') TENLOAIAN
                                   ,count(D.id)  colnum_15
                                  FROM GDTTT_DON d  
                                  LEFT JOIN dm_toaan dmta on dmta.id= DECODE(d.BAQD_CAPXETXU,4,d.BAQD_TOAANID,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID_ST)
                                  --left join BCTK_APP_V3.tc_courts v3 on v3.MADONGBO=dmta.MADONGBO   
                                  LEFT JOIN GDTTT_VUAN v on d.VUVIECID = v.id
                                  LEFT JOIN DM_DATAITEM cv on d.LOAICONGVAN = cv.id
                                  where 
                                  dmta.madongbo is not null AND D.LOAIDON NOT IN(4,5)--4 Văn bản hành chính, Tài liệu chung 5 Hồ sơ Kháng nghị GĐT,TT
                                  AND d.toaanid = V_ToaAnID --sau se truyen don vi vao
                                  AND D.ISTHULY =1 
                                  AND D.CD_LOAI=0
                                  AND (D.TL_NGAY between Trunc(to_date(vTuNgay,'dd/mm/yyyy')) and Trunc(to_date(vDenNgay,'dd/mm/yyyy'))
                                        OR
                                            (D.TL_NGAY < Trunc(to_date(vTuNgay,'dd/mm/yyyy'))
                                                  AND (d.VUVIECID IS NULL
                                                        OR v.gqd_loaiketqua NOT IN (0,1,2,3,4)
                                                        OR(v.gqd_loaiketqua in (0,1,2,3,4)
                                                                  and (CASE WHEN (V.GQD_NGAYPHATHANHCV IS NOT NULL AND V.GDQ_NGAY IS NOT NULL)  THEN  V.GDQ_NGAY 
                                                                            WHEN ( V.GQD_NGAYPHATHANHCV IS  NULL AND V.GDQ_NGAY IS NOT NULL)  THEN  V.GDQ_NGAY 
                                                                            WHEN (V.GQD_NGAYPHATHANHCV IS NOT NULL AND V.GDQ_NGAY IS NULL) THEN  V.GQD_NGAYPHATHANHCV END) > Trunc(to_date(vTuNgay,'dd/mm/yyyy'))
                                                             )
                                                       )
                                            )
                                  )
                                  AND cv.MA = '9.3.7'      
                                  AND NVL(d.BAQD_LOAIAN,0) > 0
                                  GROUP BY  dmta.CAPCHAID,dmta.TEN,d.BAQD_LOAIAN
                                 
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_THONGKE_8A(
                        item.CAPCHAID,item.BAQD_LOAIAN,item.TEN,item.TENLOAIAN,
                        0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,item.colnum_15,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0
                        );   
                END LOOP;
                
            ----COLUMN_17-------Phải giải quyết---------Viện kiểm sát đang giải quyết
               FOR item IN ( SELECT dmta.CAPCHAID,dmta.TEN,d.BAQD_LOAIAN
                                   ,Decode(NVL(d.BAQD_LOAIAN,0),1,'Hình sự',2,'Dân sự',5,'Lao động',3,'HNGD',4,'KDTM',6,'Hành chính','') TENLOAIAN
                                   ,count(D.id) colnum_17
                                  FROM GDTTT_DON d  
                                  LEFT JOIN dm_toaan dmta on dmta.id= DECODE(d.BAQD_CAPXETXU,4,d.BAQD_TOAANID,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID_ST)
                                  --left join BCTK_APP_V3.tc_courts v3 on v3.MADONGBO=dmta.MADONGBO   
                                  LEFT JOIN GDTTT_VUAN v on d.VUVIECID = v.id
                                  LEFT JOIN DM_DATAITEM cv on d.LOAICONGVAN = cv.id
                                  where 
                                  dmta.madongbo is not null AND D.LOAIDON NOT IN(4,5)--4 Văn bản hành chính, Tài liệu chung 5 Hồ sơ Kháng nghị GĐT,TT
                                  AND d.toaanid = V_ToaAnID --sau se truyen don vi vao
                                  AND D.ISTHULY =1 
                                  AND D.CD_LOAI=0
                                  AND V.GQD_LOAIKETQUA = 4--'Thông báo VKS đang giải quyết'
                                  AND ((CASE WHEN (V.GQD_NGAYPHATHANHCV IS NOT NULL AND V.GDQ_NGAY IS NOT NULL)  THEN  V.GDQ_NGAY 
                                            WHEN ( V.GQD_NGAYPHATHANHCV IS  NULL AND V.GDQ_NGAY IS NOT NULL)  THEN  V.GDQ_NGAY 
                                            WHEN (V.GQD_NGAYPHATHANHCV IS NOT NULL AND V.GDQ_NGAY IS NULL) THEN  V.GQD_NGAYPHATHANHCV END) 
                                             between Trunc(to_date(vTuNgay,'dd/mm/yyyy')) and Trunc(to_date(vDenNgay,'dd/mm/yyyy'))
                                        )     
                                  AND cv.MA = '9.3.8'      
                                  AND NVL(d.BAQD_LOAIAN,0) > 0
                                  GROUP BY  dmta.CAPCHAID,dmta.TEN,d.BAQD_LOAIAN
                                 
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_THONGKE_8A(
                        item.CAPCHAID,item.BAQD_LOAIAN,item.TEN,item.TENLOAIAN,
                        0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,item.colnum_17,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0
                        );   
                END LOOP;
                
                  ----COLUMN_19-------Trả lời đơn--Có kiến nghị của đại biểu QH, đoàn ĐBQH
               FOR item IN ( SELECT dmta.CAPCHAID,dmta.TEN,d.BAQD_LOAIAN
                                   ,Decode(NVL(d.BAQD_LOAIAN,0),1,'Hình sự',2,'Dân sự',5,'Lao động',3,'HNGD',4,'KDTM',6,'Hành chính','') TENLOAIAN
                                   ,count(D.id) colnum_19
                                  FROM GDTTT_DON d  
                                  LEFT JOIN dm_toaan dmta on dmta.id= DECODE(d.BAQD_CAPXETXU,4,d.BAQD_TOAANID,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID_ST)
                                  --left join BCTK_APP_V3.tc_courts v3 on v3.MADONGBO=dmta.MADONGBO   
                                  LEFT JOIN GDTTT_VUAN v on d.VUVIECID = v.id
                                  LEFT JOIN DM_DATAITEM cv on d.LOAICONGVAN = cv.id
                                  where 
                                  dmta.madongbo is not null AND D.LOAIDON NOT IN(4,5)--4 Văn bản hành chính, Tài liệu chung 5 Hồ sơ Kháng nghị GĐT,TT
                                  AND d.toaanid = V_ToaAnID --sau se truyen don vi vao
                                  AND D.ISTHULY =1 
                                  AND D.CD_LOAI=0
                                  AND V.GQD_LOAIKETQUA = 0--Trả lời đơn
                                  AND ((CASE WHEN (V.GQD_NGAYPHATHANHCV IS NOT NULL AND V.GDQ_NGAY IS NOT NULL)  THEN  V.GDQ_NGAY 
                                            WHEN ( V.GQD_NGAYPHATHANHCV IS  NULL AND V.GDQ_NGAY IS NOT NULL)  THEN  V.GDQ_NGAY 
                                            WHEN (V.GQD_NGAYPHATHANHCV IS NOT NULL AND V.GDQ_NGAY IS NULL) THEN  V.GQD_NGAYPHATHANHCV END) 
                                             between Trunc(to_date(vTuNgay,'dd/mm/yyyy')) and Trunc(to_date(vDenNgay,'dd/mm/yyyy'))
                                        )     
                                  AND cv.MA = '9.3.5'      
                                  AND NVL(d.BAQD_LOAIAN,0) > 0
                                  GROUP BY  dmta.CAPCHAID,dmta.TEN,d.BAQD_LOAIAN
                                 
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_THONGKE_8A(
                        item.CAPCHAID,item.BAQD_LOAIAN,item.TEN,item.TENLOAIAN,
                        0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,item.colnum_19,0,
                        0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0
                        );   
                END LOOP;
                
               ----COLUMN_20-------Trả lời đơn--Có kiến nghị của Ủy ban tư pháp của QH
               FOR item IN ( SELECT dmta.CAPCHAID,dmta.TEN,d.BAQD_LOAIAN
                                   ,Decode(NVL(d.BAQD_LOAIAN,0),1,'Hình sự',2,'Dân sự',5,'Lao động',3,'HNGD',4,'KDTM',6,'Hành chính','') TENLOAIAN
                                   ,count(D.id)  colnum_20
                                  FROM GDTTT_DON d  
                                  LEFT JOIN dm_toaan dmta on dmta.id= DECODE(d.BAQD_CAPXETXU,4,d.BAQD_TOAANID,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID_ST)
                                  --left join BCTK_APP_V3.tc_courts v3 on v3.MADONGBO=dmta.MADONGBO   
                                  LEFT JOIN GDTTT_VUAN v on d.VUVIECID = v.id
                                  LEFT JOIN DM_DATAITEM cv on d.LOAICONGVAN = cv.id
                                  where 
                                  dmta.madongbo is not null AND D.LOAIDON NOT IN(4,5)--4 Văn bản hành chính, Tài liệu chung 5 Hồ sơ Kháng nghị GĐT,TT
                                  AND d.toaanid = V_ToaAnID --sau se truyen don vi vao
                                  AND D.ISTHULY =1 
                                  AND D.CD_LOAI=0
                                  AND V.GQD_LOAIKETQUA = 0--Trả lời đơn
                                  AND ((CASE WHEN (V.GQD_NGAYPHATHANHCV IS NOT NULL AND V.GDQ_NGAY IS NOT NULL)  THEN  V.GDQ_NGAY 
                                            WHEN ( V.GQD_NGAYPHATHANHCV IS  NULL AND V.GDQ_NGAY IS NOT NULL)  THEN  V.GDQ_NGAY 
                                            WHEN (V.GQD_NGAYPHATHANHCV IS NOT NULL AND V.GDQ_NGAY IS NULL) THEN  V.GQD_NGAYPHATHANHCV END) 
                                             between Trunc(to_date(vTuNgay,'dd/mm/yyyy')) and Trunc(to_date(vDenNgay,'dd/mm/yyyy'))
                                        )     
                                  AND cv.MA = '9.3.8'      
                                  AND NVL(d.BAQD_LOAIAN,0) > 0
                                  GROUP BY  dmta.CAPCHAID,dmta.TEN,d.BAQD_LOAIAN
                                 
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_THONGKE_8A(
                        item.CAPCHAID,item.BAQD_LOAIAN,item.TEN,item.TENLOAIAN,
                        0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,item.colnum_20,
                        0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0
                        );   
                END LOOP;
                
               ----COLUMN_21-------Trả lời đơn--Các cơ quan khác của Quốc hội
               FOR item IN ( SELECT dmta.CAPCHAID,dmta.TEN,d.BAQD_LOAIAN
                                   ,Decode(NVL(d.BAQD_LOAIAN,0),1,'Hình sự',2,'Dân sự',5,'Lao động',3,'HNGD',4,'KDTM',6,'Hành chính','') TENLOAIAN
                                   ,count(D.id)  colnum_21
                                  FROM GDTTT_DON d  
                                  LEFT JOIN dm_toaan dmta on dmta.id= DECODE(d.BAQD_CAPXETXU,4,d.BAQD_TOAANID,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID_ST)
                                  --left join BCTK_APP_V3.tc_courts v3 on v3.MADONGBO=dmta.MADONGBO   
                                  LEFT JOIN GDTTT_VUAN v on d.VUVIECID = v.id
                                  LEFT JOIN DM_DATAITEM cv on d.LOAICONGVAN = cv.id
                                  where 
                                  dmta.madongbo is not null AND D.LOAIDON NOT IN(4,5)--4 Văn bản hành chính, Tài liệu chung 5 Hồ sơ Kháng nghị GĐT,TT
                                  AND d.toaanid = V_ToaAnID --sau se truyen don vi vao
                                  AND D.ISTHULY =1 
                                  AND D.CD_LOAI=0
                                  AND V.GQD_LOAIKETQUA = 0--Trả lời đơn
                                  AND ((CASE WHEN (V.GQD_NGAYPHATHANHCV IS NOT NULL AND V.GDQ_NGAY IS NOT NULL)  THEN  V.GDQ_NGAY 
                                            WHEN ( V.GQD_NGAYPHATHANHCV IS  NULL AND V.GDQ_NGAY IS NOT NULL)  THEN  V.GDQ_NGAY 
                                            WHEN (V.GQD_NGAYPHATHANHCV IS NOT NULL AND V.GDQ_NGAY IS NULL) THEN  V.GQD_NGAYPHATHANHCV END) 
                                             between Trunc(to_date(vTuNgay,'dd/mm/yyyy')) and Trunc(to_date(vDenNgay,'dd/mm/yyyy'))
                                        )     
                                  AND cv.MA = '9.3.7'      
                                  AND NVL(d.BAQD_LOAIAN,0) > 0
                                  GROUP BY  dmta.CAPCHAID,dmta.TEN,d.BAQD_LOAIAN
                                 
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_THONGKE_8A(
                        item.CAPCHAID,item.BAQD_LOAIAN,item.TEN,item.TENLOAIAN,
                        0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,
                        item.colnum_21,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0
                        );   
                END LOOP;
                
                
                
                    ----COLUMN_24-------Kháng nghị--Có kiến nghị của đại biểu QH, đoàn ĐBQH
               FOR item IN ( SELECT dmta.CAPCHAID,dmta.TEN,d.BAQD_LOAIAN
                                   ,Decode(NVL(d.BAQD_LOAIAN,0),1,'Hình sự',2,'Dân sự',5,'Lao động',3,'HNGD',4,'KDTM',6,'Hành chính','') TENLOAIAN
                                   ,count(D.id)  colnum_24
                                  FROM GDTTT_DON d  
                                  LEFT JOIN dm_toaan dmta on dmta.id= DECODE(d.BAQD_CAPXETXU,4,d.BAQD_TOAANID,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID_ST)
                                  --left join BCTK_APP_V3.tc_courts v3 on v3.MADONGBO=dmta.MADONGBO   
                                  LEFT JOIN GDTTT_VUAN v on d.VUVIECID = v.id
                                  LEFT JOIN DM_DATAITEM cv on d.LOAICONGVAN = cv.id
                                  where 
                                  dmta.madongbo is not null AND D.LOAIDON NOT IN(4,5)--4 Văn bản hành chính, Tài liệu chung 5 Hồ sơ Kháng nghị GĐT,TT
                                  AND d.toaanid = V_ToaAnID --sau se truyen don vi vao
                                  AND D.ISTHULY =1 
                                  AND D.CD_LOAI=0
                                  AND V.GQD_LOAIKETQUA = 1--Kháng nghị
                                  AND ((CASE WHEN (V.GQD_NGAYPHATHANHCV IS NOT NULL AND V.GDQ_NGAY IS NOT NULL)  THEN  V.GDQ_NGAY 
                                            WHEN ( V.GQD_NGAYPHATHANHCV IS  NULL AND V.GDQ_NGAY IS NOT NULL)  THEN  V.GDQ_NGAY 
                                            WHEN (V.GQD_NGAYPHATHANHCV IS NOT NULL AND V.GDQ_NGAY IS NULL) THEN  V.GQD_NGAYPHATHANHCV END) 
                                             between Trunc(to_date(vTuNgay,'dd/mm/yyyy')) and Trunc(to_date(vDenNgay,'dd/mm/yyyy'))
                                        )     
                                  AND cv.MA = '9.3.5'      
                                  AND NVL(d.BAQD_LOAIAN,0) > 0
                                  GROUP BY  dmta.CAPCHAID,dmta.TEN,d.BAQD_LOAIAN
                                 
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_THONGKE_8A(
                        item.CAPCHAID,item.BAQD_LOAIAN,item.TEN,item.TENLOAIAN,
                        0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,
                        0,0,0,item.colnum_24,0,0,0,0,0,0,
                        0,0,0,0,0,0
                        );   
                END LOOP;
                
               ----COLUMN_25-------Kháng nghị--Có kiến nghị của Ủy ban tư pháp của QH
               FOR item IN ( SELECT dmta.CAPCHAID,dmta.TEN,d.BAQD_LOAIAN
                                   ,Decode(NVL(d.BAQD_LOAIAN,0),1,'Hình sự',2,'Dân sự',5,'Lao động',3,'HNGD',4,'KDTM',6,'Hành chính','') TENLOAIAN
                                   ,count(D.id)  colnum_25
                                  FROM GDTTT_DON d  
                                  LEFT JOIN dm_toaan dmta on dmta.id= DECODE(d.BAQD_CAPXETXU,4,d.BAQD_TOAANID,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID_ST)
                                  --left join BCTK_APP_V3.tc_courts v3 on v3.MADONGBO=dmta.MADONGBO   
                                  LEFT JOIN GDTTT_VUAN v on d.VUVIECID = v.id
                                  LEFT JOIN DM_DATAITEM cv on d.LOAICONGVAN = cv.id
                                  where 
                                  dmta.madongbo is not null AND D.LOAIDON NOT IN(4,5)--4 Văn bản hành chính, Tài liệu chung 5 Hồ sơ Kháng nghị GĐT,TT
                                  AND d.toaanid = V_ToaAnID --sau se truyen don vi vao
                                  AND D.ISTHULY =1 
                                  AND D.CD_LOAI=0
                                   AND V.GQD_LOAIKETQUA = 1--Kháng nghị
                                  AND ((CASE WHEN (V.GQD_NGAYPHATHANHCV IS NOT NULL AND V.GDQ_NGAY IS NOT NULL)  THEN  V.GDQ_NGAY 
                                            WHEN ( V.GQD_NGAYPHATHANHCV IS  NULL AND V.GDQ_NGAY IS NOT NULL)  THEN  V.GDQ_NGAY 
                                            WHEN (V.GQD_NGAYPHATHANHCV IS NOT NULL AND V.GDQ_NGAY IS NULL) THEN  V.GQD_NGAYPHATHANHCV END) 
                                             between Trunc(to_date(vTuNgay,'dd/mm/yyyy')) and Trunc(to_date(vDenNgay,'dd/mm/yyyy'))
                                        )     
                                  AND cv.MA = '9.3.8'      
                                  AND NVL(d.BAQD_LOAIAN,0) > 0
                                  GROUP BY  dmta.CAPCHAID,dmta.TEN,d.BAQD_LOAIAN
                                 
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_THONGKE_8A(
                        item.CAPCHAID,item.BAQD_LOAIAN,item.TEN,item.TENLOAIAN,
                        0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,item.colnum_25,0,0,0,0,0,
                        0,0,0,0,0,0
                        );   
                END LOOP;
                
               ----COLUMN_26-------Kháng nghị--Các cơ quan khác của Quốc hội
               FOR item IN ( SELECT dmta.CAPCHAID,dmta.TEN,d.BAQD_LOAIAN
                                   ,Decode(NVL(d.BAQD_LOAIAN,0),1,'Hình sự',2,'Dân sự',5,'Lao động',3,'HNGD',4,'KDTM',6,'Hành chính','') TENLOAIAN
                                   ,count(D.id) colnum_26
                                  FROM GDTTT_DON d  
                                  LEFT JOIN dm_toaan dmta on dmta.id= DECODE(d.BAQD_CAPXETXU,4,d.BAQD_TOAANID,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID_ST)
                                  --left join BCTK_APP_V3.tc_courts v3 on v3.MADONGBO=dmta.MADONGBO   
                                  LEFT JOIN GDTTT_VUAN v on d.VUVIECID = v.id
                                  LEFT JOIN DM_DATAITEM cv on d.LOAICONGVAN = cv.id
                                  where 
                                  dmta.madongbo is not null AND D.LOAIDON NOT IN(4,5)--4 Văn bản hành chính, Tài liệu chung 5 Hồ sơ Kháng nghị GĐT,TT
                                  AND d.toaanid = V_ToaAnID --sau se truyen don vi vao
                                  AND D.ISTHULY =1 
                                  AND D.CD_LOAI=0
                                   AND V.GQD_LOAIKETQUA = 1--Kháng nghị
                                  AND ((CASE WHEN (V.GQD_NGAYPHATHANHCV IS NOT NULL AND V.GDQ_NGAY IS NOT NULL)  THEN  V.GDQ_NGAY 
                                            WHEN ( V.GQD_NGAYPHATHANHCV IS  NULL AND V.GDQ_NGAY IS NOT NULL)  THEN  V.GDQ_NGAY 
                                            WHEN (V.GQD_NGAYPHATHANHCV IS NOT NULL AND V.GDQ_NGAY IS NULL) THEN  V.GQD_NGAYPHATHANHCV END) 
                                             between Trunc(to_date(vTuNgay,'dd/mm/yyyy')) and Trunc(to_date(vDenNgay,'dd/mm/yyyy'))
                                        )     
                                  AND cv.MA = '9.3.7'      
                                  AND NVL(d.BAQD_LOAIAN,0) > 0
                                  GROUP BY  dmta.CAPCHAID,dmta.TEN,d.BAQD_LOAIAN
                                 
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_THONGKE_8A(
                        item.CAPCHAID,item.BAQD_LOAIAN,item.TEN,item.TENLOAIAN,
                        0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,item.colnum_26,0,0,0,0,
                        0,0,0,0,0,0
                        );   
                END LOOP;
                
               ----COLUMN_27-------Kháng nghị--Các cơ quan Trung ương khác
               FOR item IN ( SELECT dmta.CAPCHAID,dmta.TEN,d.BAQD_LOAIAN
                                   ,Decode(NVL(d.BAQD_LOAIAN,0),1,'Hình sự',2,'Dân sự',5,'Lao động',3,'HNGD',4,'KDTM',6,'Hành chính','') TENLOAIAN
                                   ,count(D.id)  colnum_27
                                  FROM GDTTT_DON d  
                                  LEFT JOIN dm_toaan dmta on dmta.id= DECODE(d.BAQD_CAPXETXU,4,d.BAQD_TOAANID,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID_ST)
                                  --left join BCTK_APP_V3.tc_courts v3 on v3.MADONGBO=dmta.MADONGBO   
                                  LEFT JOIN GDTTT_VUAN v on d.VUVIECID = v.id
                                  LEFT JOIN DM_DATAITEM cv on d.LOAICONGVAN = cv.id
                                  where 
                                  dmta.madongbo is not null AND D.LOAIDON NOT IN(4,5)--4 Văn bản hành chính, Tài liệu chung 5 Hồ sơ Kháng nghị GĐT,TT
                                  AND d.toaanid = V_ToaAnID --sau se truyen don vi vao
                                  AND D.ISTHULY =1 
                                  AND D.CD_LOAI=0
                                   AND V.GQD_LOAIKETQUA = 1--Kháng nghị
                                  AND ((CASE WHEN (V.GQD_NGAYPHATHANHCV IS NOT NULL AND V.GDQ_NGAY IS NOT NULL)  THEN  V.GDQ_NGAY 
                                            WHEN ( V.GQD_NGAYPHATHANHCV IS  NULL AND V.GDQ_NGAY IS NOT NULL)  THEN  V.GDQ_NGAY 
                                            WHEN (V.GQD_NGAYPHATHANHCV IS NOT NULL AND V.GDQ_NGAY IS NULL) THEN  V.GQD_NGAYPHATHANHCV END) 
                                             between Trunc(to_date(vTuNgay,'dd/mm/yyyy')) and Trunc(to_date(vDenNgay,'dd/mm/yyyy'))
                                        )
                                  AND d.LOAIDON in (6,9)
                                  AND cv.MA != '9.3.7' AND  cv.MA != '9.3.8' AND  cv.MA != '9.3.5'    
                                  AND NVL(d.BAQD_LOAIAN,0) > 0
                                  GROUP BY  dmta.CAPCHAID,dmta.TEN,d.BAQD_LOAIAN
                                 
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_THONGKE_8A(
                        item.CAPCHAID,item.BAQD_LOAIAN,item.TEN,item.TENLOAIAN,
                        0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,item.colnum_27,0,0,0,
                        0,0,0,0,0,0
                        );   
                END LOOP;
               ----COLUMN_28-------Giai quyet khác: xep don + VKS dang giai quyet + Giai quyet khac
               FOR item IN ( SELECT dmta.CAPCHAID,dmta.TEN,d.BAQD_LOAIAN
                                   ,Decode(NVL(d.BAQD_LOAIAN,0),1,'Hình sự',2,'Dân sự',5,'Lao động',3,'HNGD',4,'KDTM',6,'Hành chính','') TENLOAIAN
                                   ,count(D.id) colnum_28
                                  FROM GDTTT_DON d  
                                  LEFT JOIN dm_toaan dmta on dmta.id= DECODE(d.BAQD_CAPXETXU,4,d.BAQD_TOAANID,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID_ST)
                                  --left join BCTK_APP_V3.tc_courts v3 on v3.MADONGBO=dmta.MADONGBO   
                                  LEFT JOIN GDTTT_VUAN v on d.VUVIECID = v.id
                                  LEFT JOIN DM_DATAITEM cv on d.LOAICONGVAN = cv.id
                                  where 
                                  dmta.madongbo is not null AND D.LOAIDON NOT IN(4,5)--4 Văn bản hành chính, Tài liệu chung 5 Hồ sơ Kháng nghị GĐT,TT
                                    AND d.toaanid = V_ToaAnID --sau se truyen don vi vao
                                    AND D.ISTHULY =1 
                                    AND D.CD_LOAI=0
                                    AND V.GQD_LOAIKETQUA in (2,3,4)--xep don + Giai quyet khac + VKS dang giai quyet 
                                    AND ((CASE WHEN (V.GQD_NGAYPHATHANHCV IS NOT NULL AND V.GDQ_NGAY IS NOT NULL)  THEN  V.GDQ_NGAY 
                                            WHEN ( V.GQD_NGAYPHATHANHCV IS  NULL AND V.GDQ_NGAY IS NOT NULL)  THEN  V.GDQ_NGAY 
                                            WHEN (V.GQD_NGAYPHATHANHCV IS NOT NULL AND V.GDQ_NGAY IS NULL) THEN  V.GQD_NGAYPHATHANHCV END) 
                                             between Trunc(to_date(vTuNgay,'dd/mm/yyyy')) and Trunc(to_date(vDenNgay,'dd/mm/yyyy'))
                                        )
                                    AND NVL(d.BAQD_LOAIAN,0) > 0
                                    GROUP BY  dmta.CAPCHAID,dmta.TEN,d.BAQD_LOAIAN
                                   
                                )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_THONGKE_8A(
                        item.CAPCHAID,item.BAQD_LOAIAN,item.TEN,item.TENLOAIAN,
                        0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,item.colnum_28,0,0,
                        0,0,0,0,0,0
                        );   
                END LOOP;                                
            ----COLUMN_29---Cộng---- = COLUMN_18 + COLUMN_23 + COLUMN_28
            ----COLUMN_30---Tỷ lệ giải quyết/ thụ lý = COLUMN_29/COLUMN_12
            ----COLUMN_31--Còn lại- COLUMN_12 - COLUMN_29
            ----COLUMN_32---Còn lại-----Có kiến nghị của đại biểu QH, đoàn ĐBQH
              FOR item IN ( SELECT dmta.CAPCHAID,dmta.TEN,d.BAQD_LOAIAN
                                   ,Decode(NVL(d.BAQD_LOAIAN,0),1,'Hình sự',2,'Dân sự',5,'Lao động',3,'HNGD',4,'KDTM',6,'Hành chính','') TENLOAIAN
                                   ,count(D.id)  colnum_32
                                  FROM GDTTT_DON d  
                                  LEFT JOIN dm_toaan dmta on dmta.id= DECODE(d.BAQD_CAPXETXU,4,d.BAQD_TOAANID,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID_ST)
                                  --left join BCTK_APP_V3.tc_courts v3 on v3.MADONGBO=dmta.MADONGBO   
                                  LEFT JOIN GDTTT_VUAN v on d.VUVIECID = v.id
                                  LEFT JOIN DM_DATAITEM cv on d.LOAICONGVAN = cv.id
                                  where 
                                  dmta.madongbo is not null AND D.LOAIDON NOT IN(4,5)--4 Văn bản hành chính, Tài liệu chung 5 Hồ sơ Kháng nghị GĐT,TT
                                  AND d.toaanid = V_ToaAnID --sau se truyen don vi vao
                                  AND D.ISTHULY =1 
                                  AND D.CD_LOAI=0
                                  AND D.TL_NGAY <= Trunc(to_date(vDenNgay,'dd/mm/yyyy'))
                                  AND (d.VUVIECID IS NULL
                                        OR v.gqd_loaiketqua NOT IN (0,1,2,3,4)
                                        OR(v.gqd_loaiketqua in (0,1,2,3,4)
                                                  and (CASE WHEN (V.GQD_NGAYPHATHANHCV IS NOT NULL AND V.GDQ_NGAY IS NOT NULL)  THEN  V.GDQ_NGAY 
                                                            WHEN ( V.GQD_NGAYPHATHANHCV IS  NULL AND V.GDQ_NGAY IS NOT NULL)  THEN  V.GDQ_NGAY 
                                                            WHEN (V.GQD_NGAYPHATHANHCV IS NOT NULL AND V.GDQ_NGAY IS NULL) THEN  V.GQD_NGAYPHATHANHCV END) > Trunc(to_date(vDenNgay,'dd/mm/yyyy'))
                                             )
                                       )
                                                     
                                  AND cv.MA = '9.3.5'      
                                  AND NVL(d.BAQD_LOAIAN,0) > 0
                                  GROUP BY  dmta.CAPCHAID,dmta.TEN,d.BAQD_LOAIAN
                                 
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_THONGKE_8A(
                        item.CAPCHAID,item.BAQD_LOAIAN,item.TEN,item.TENLOAIAN,
                        0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,
                        0,item.colnum_32,0,0,0,0
                        );   
                END LOOP;
            ----COLUMN_33---Còn lại-----Có kiến nghị của Ủy ban tư pháp của QH
              FOR item IN ( SELECT dmta.CAPCHAID,dmta.TEN,d.BAQD_LOAIAN
                                   ,Decode(NVL(d.BAQD_LOAIAN,0),1,'Hình sự',2,'Dân sự',5,'Lao động',3,'HNGD',4,'KDTM',6,'Hành chính','') TENLOAIAN
                                   ,count(D.id)  colnum_33
                                  FROM GDTTT_DON d  
                                  LEFT JOIN dm_toaan dmta on dmta.id= DECODE(d.BAQD_CAPXETXU,4,d.BAQD_TOAANID,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID_ST)
                                  --left join BCTK_APP_V3.tc_courts v3 on v3.MADONGBO=dmta.MADONGBO   
                                  LEFT JOIN GDTTT_VUAN v on d.VUVIECID = v.id
                                  LEFT JOIN DM_DATAITEM cv on d.LOAICONGVAN = cv.id
                                  where 
                                  dmta.madongbo is not null AND D.LOAIDON NOT IN(4,5)--4 Văn bản hành chính, Tài liệu chung 5 Hồ sơ Kháng nghị GĐT,TT
                                  AND d.toaanid = V_ToaAnID --sau se truyen don vi vao
                                  AND D.ISTHULY =1 
                                  AND D.CD_LOAI=0
                                  AND D.TL_NGAY <= Trunc(to_date(vDenNgay,'dd/mm/yyyy'))
                                  AND (d.VUVIECID IS NULL
                                        OR v.gqd_loaiketqua NOT IN (0,1,2,3,4)
                                        OR(v.gqd_loaiketqua in (0,1,2,3,4)
                                                  and (CASE WHEN (V.GQD_NGAYPHATHANHCV IS NOT NULL AND V.GDQ_NGAY IS NOT NULL)  THEN  V.GDQ_NGAY 
                                                            WHEN ( V.GQD_NGAYPHATHANHCV IS  NULL AND V.GDQ_NGAY IS NOT NULL)  THEN  V.GDQ_NGAY 
                                                            WHEN (V.GQD_NGAYPHATHANHCV IS NOT NULL AND V.GDQ_NGAY IS NULL) THEN  V.GQD_NGAYPHATHANHCV END) > Trunc(to_date(vDenNgay,'dd/mm/yyyy'))
                                             )
                                       )
                                                     
                                  AND cv.MA = '9.3.8'      
                                  AND NVL(d.BAQD_LOAIAN,0) > 0
                                  GROUP BY  dmta.CAPCHAID,dmta.TEN,d.BAQD_LOAIAN
                                 
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_THONGKE_8A(
                        item.CAPCHAID,item.BAQD_LOAIAN,item.TEN,item.TENLOAIAN,
                        0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,
                        0,0,item.colnum_33,0,0,0
                        );   
                END LOOP;
            ----COLUMN_34---Còn lại-----Các cơ quan khác của Quốc hội
              FOR item IN ( SELECT dmta.CAPCHAID,dmta.TEN,d.BAQD_LOAIAN
                                   ,Decode(NVL(d.BAQD_LOAIAN,0),1,'Hình sự',2,'Dân sự',5,'Lao động',3,'HNGD',4,'KDTM',6,'Hành chính','') TENLOAIAN
                                   ,count(D.id)  colnum_34
                                  FROM GDTTT_DON d  
                                  LEFT JOIN dm_toaan dmta on dmta.id= DECODE(d.BAQD_CAPXETXU,4,d.BAQD_TOAANID,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID_ST)
                                  --left join BCTK_APP_V3.tc_courts v3 on v3.MADONGBO=dmta.MADONGBO   
                                  LEFT JOIN GDTTT_VUAN v on d.VUVIECID = v.id
                                  LEFT JOIN DM_DATAITEM cv on d.LOAICONGVAN = cv.id
                                  where 
                                  dmta.madongbo is not null 
                                  AND D.LOAIDON NOT IN(4,5)--4 Văn bản hành chính, Tài liệu chung 5 Hồ sơ Kháng nghị GĐT,TT
                                  AND d.toaanid = V_ToaAnID --sau se truyen don vi vao
                                  AND D.ISTHULY =1 
                                  AND D.CD_LOAI=0
                                  AND D.TL_NGAY <= Trunc(to_date(vDenNgay,'dd/mm/yyyy'))
                                  AND (d.VUVIECID IS NULL
                                        OR v.gqd_loaiketqua NOT IN (0,1,2,3,4)
                                        OR(v.gqd_loaiketqua in (0,1,2,3,4)
                                                  and (CASE WHEN (V.GQD_NGAYPHATHANHCV IS NOT NULL AND V.GDQ_NGAY IS NOT NULL)  THEN  V.GDQ_NGAY 
                                                            WHEN ( V.GQD_NGAYPHATHANHCV IS  NULL AND V.GDQ_NGAY IS NOT NULL)  THEN  V.GDQ_NGAY 
                                                            WHEN (V.GQD_NGAYPHATHANHCV IS NOT NULL AND V.GDQ_NGAY IS NULL) THEN  V.GQD_NGAYPHATHANHCV END) > Trunc(to_date(vDenNgay,'dd/mm/yyyy'))
                                             )
                                       )
                                                     
                                  AND cv.MA = '9.3.7'      
                                  AND NVL(d.BAQD_LOAIAN,0) > 0
                                  GROUP BY  dmta.CAPCHAID,dmta.TEN,d.BAQD_LOAIAN
                                 
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_THONGKE_8A(
                        item.CAPCHAID,item.BAQD_LOAIAN,item.TEN,item.TENLOAIAN,
                        0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,
                        0,0,0,item.colnum_34,0,0
                        );   
                END LOOP;            
                   ----COLUMN_35---Còn lại-----Các cơ quan khác của Quốc hội
              FOR item IN ( SELECT dmta.CAPCHAID,dmta.TEN,d.BAQD_LOAIAN
                                   ,Decode(NVL(d.BAQD_LOAIAN,0),1,'Hình sự',2,'Dân sự',5,'Lao động',3,'HNGD',4,'KDTM',6,'Hành chính','') TENLOAIAN
                                   ,count(D.id)  colnum_35
                                  FROM GDTTT_DON d  
                                  LEFT JOIN dm_toaan dmta on dmta.id= DECODE(d.BAQD_CAPXETXU,4,d.BAQD_TOAANID,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID_ST)
                                  --left join BCTK_APP_V3.tc_courts v3 on v3.MADONGBO=dmta.MADONGBO   
                                  LEFT JOIN GDTTT_VUAN v on d.VUVIECID = v.id
                                  LEFT JOIN DM_DATAITEM cv on d.LOAICONGVAN = cv.id
                                  where 
                                  dmta.madongbo is not null 
                                  --AND D.LOAIDON NOT IN(4,5)--4 Văn bản hành chính, Tài liệu chung 5 Hồ sơ Kháng nghị GĐT,TT
                                  AND d.toaanid = V_ToaAnID --sau se truyen don vi vao
                                  AND D.ISTHULY =1 
                                  AND D.CD_LOAI=0
                                  AND D.TL_NGAY <= Trunc(to_date(vDenNgay,'dd/mm/yyyy'))
                                  AND (d.VUVIECID IS NULL
                                        OR v.gqd_loaiketqua NOT IN (0,1,2,3,4)
                                        OR(v.gqd_loaiketqua in (0,1,2,3,4)
                                                  and (CASE WHEN (V.GQD_NGAYPHATHANHCV IS NOT NULL AND V.GDQ_NGAY IS NOT NULL)  THEN  V.GDQ_NGAY 
                                                            WHEN ( V.GQD_NGAYPHATHANHCV IS  NULL AND V.GDQ_NGAY IS NOT NULL)  THEN  V.GDQ_NGAY 
                                                            WHEN (V.GQD_NGAYPHATHANHCV IS NOT NULL AND V.GDQ_NGAY IS NULL) THEN  V.GQD_NGAYPHATHANHCV END) > Trunc(to_date(vDenNgay,'dd/mm/yyyy'))
                                             )
                                       )
                                                     
                                    AND d.LOAIDON in (6,9)
                                  AND cv.MA != '9.3.7' AND  cv.MA != '9.3.8' AND  cv.MA != '9.3.5'       
                                  AND NVL(d.BAQD_LOAIAN,0) > 0
                                  GROUP BY  dmta.CAPCHAID,dmta.TEN,d.BAQD_LOAIAN
                                 
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_THONGKE_8A(
                        item.CAPCHAID,item.BAQD_LOAIAN,item.TEN,item.TENLOAIAN,
                        0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,item.colnum_35,0
                        );   
                END LOOP;  
                
              ----COLUMN_36---Còn lại-----Số vụ đương sự tiếp tục khiếu nại sau khi Tòa án đã trả lời đơn
--              FOR item IN ( SELECT dmta.CAPCHAID,dmta.TEN,d.BAQD_LOAIAN
--                                   ,Decode(NVL(d.BAQD_LOAIAN,0),1,'Hình sự',2,'Dân sự',5,'Lao động',3,'HNGD',4,'KDTM',6,'Hành chính','') TENLOAIAN
--                                   ,count(D.id)  colnum_36
--                                  FROM GDTTT_DON d  
--                                  LEFT JOIN dm_toaan dmta on dmta.id= DECODE(d.BAQD_CAPXETXU,4,d.BAQD_TOAANID,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID_ST)
--                                  --left join BCTK_APP_V3.tc_courts v3 on v3.MADONGBO=dmta.MADONGBO   
--                                  LEFT JOIN GDTTT_VUAN v on d.VUVIECID = v.id
--                                  LEFT JOIN DM_DATAITEM cv on d.LOAICONGVAN = cv.id
--                                  where 
--                                  dmta.madongbo is not null 
--                                  AND D.LOAIDON NOT IN(4,5)--4 Văn bản hành chính, Tài liệu chung 5 Hồ sơ Kháng nghị GĐT,TT
--                                  AND d.toaanid = V_ToaAnID --sau se truyen don vi vao
--                                  --AND D.ISTHULY =1 
--                                  AND D.CD_LOAI=0
--                                  AND d.NGAYXULYDON between Trunc(to_date(vTuNgay,'dd/mm/yyyy')) and Trunc(to_date(vDenNgay,'dd/mm/yyyy'))
--                                  AND EXISTS(select 'X' from gdttt_vuan v WHERE 
--                                              v.gqd_loaiketqua = 0 -- Tra loi don  
--                                               AND (d.BAQD_CAPXETXU = 4 
--                                                        AND v.NGAYQD = to_date(d.BAQD_NGAYBA,'dd/MM/yyyy')
--                                                        AND v.TOAQDID = d.BAQD_TOAANID
--                                                        AND lower(DECODE(INSTR(v.SO_QDGDT,'/'),0
--                                                                            ,decode(INSTR(v.SO_QDGDT,'0'),1
--                                                                                        ,regexp_replace(v.SO_QDGDT,'0','',1,1)
--                                                                                        ,v.SO_QDGDT )
--                                                                            ,decode(INSTR(v.SO_QDGDT,'0'),1
--                                                                                        ,SUBSTR(regexp_replace(v.SO_QDGDT,'0','',1,1),1,instr(regexp_replace(v.SO_QDGDT,'0','',1,1),'/')-1)
--                                                                                        ,SUBSTR(v.SO_QDGDT,1,instr(v.SO_QDGDT,'/')-1) )
--                                                                            ))
--                                                                   = 
--                                                                    lower(DECODE(INSTR(d.BAQD_SO,'/'),0
--                                                                            ,decode(INSTR(d.BAQD_SO,'0'),1
--                                                                                        ,regexp_replace(d.BAQD_SO,'0','',1,1)
--                                                                                        ,d.BAQD_SO)
--                                                                            ,decode(INSTR(d.BAQD_SO,'0'),1
--                                                                                        ,SUBSTR(regexp_replace(d.BAQD_SO,'0','',1,1),1,instr(regexp_replace(d.BAQD_SO,'0','',1,1),'/')-1)
--                                                                                        ,SUBSTR(d.BAQD_SO,1,instr(d.BAQD_SO,'/')-1) )
--                                                                            ))
--                                                        ) 
--                                                    OR 
--                                                      (d.BAQD_CAPXETXU = 3 
--                                                        AND v.NGAYXUPHUCTHAM = to_date(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')
--                                                        AND v.TOAPHUCTHAMID = d.BAQD_TOAANID_PT
--                                                        AND  lower(DECODE(INSTR(v.SOANPHUCTHAM,'/'),0
--                                                                        ,decode(INSTR(v.SOANPHUCTHAM,'0'),1
--                                                                                    ,regexp_replace(v.SOANPHUCTHAM,'0','',1,1)
--                                                                                    ,v.SOANPHUCTHAM )
--                                                                        ,decode(INSTR(v.SOANPHUCTHAM,'0'),1
--                                                                                    ,SUBSTR(regexp_replace(v.SOANPHUCTHAM,'0','',1,1),1,instr(regexp_replace(v.SOANPHUCTHAM,'0','',1,1),'/')-1)
--                                                                                    ,SUBSTR(v.SOANPHUCTHAM,1,instr(v.SOANPHUCTHAM,'/')-1) )
--                                                                        ))
--                                                               = 
--                                                                lower(DECODE(INSTR(d.BAQD_SO_PT,'/'),0
--                                                                        ,decode(INSTR(d.BAQD_SO_PT,'0'),1
--                                                                                    ,regexp_replace(d.BAQD_SO_PT,'0','',1,1)
--                                                                                    ,d.BAQD_SO_PT)
--                                                                        ,decode(INSTR(d.BAQD_SO_PT,'0'),1
--                                                                                    ,SUBSTR(regexp_replace(d.BAQD_SO_PT,'0','',1,1),1,instr(regexp_replace(d.BAQD_SO_PT,'0','',1,1),'/')-1)
--                                                                                    ,SUBSTR(d.BAQD_SO_PT,1,instr(d.BAQD_SO_PT,'/')-1) )
--                                                                        ))
--                                                        )
--                                                    OR 
--                                                      (d.BAQD_CAPXETXU = 2 
--                                                        AND v.NGAYXUSOTHAM = to_date(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')
--                                                        AND v.TOAANSOTHAM = d.BAQD_TOAANID_ST
--                                                        AND  lower(DECODE(INSTR(v.SOANSOTHAM,'/'),0
--                                                                        ,decode(INSTR(v.SOANSOTHAM,'0'),1
--                                                                                    ,regexp_replace(v.SOANSOTHAM,'0','',1,1)
--                                                                                    ,v.SOANSOTHAM )
--                                                                        ,decode(INSTR(v.SOANSOTHAM,'0'),1
--                                                                                    ,SUBSTR(regexp_replace(v.SOANSOTHAM,'0','',1,1),1,instr(regexp_replace(v.SOANSOTHAM,'0','',1,1),'/')-1)
--                                                                                    ,SUBSTR(v.SOANSOTHAM,1,instr(v.SOANSOTHAM,'/')-1) )
--                                                                        ))
--                                                               = 
--                                                                lower(DECODE(INSTR(d.BAQD_SO_ST,'/'),0
--                                                                        ,decode(INSTR(d.BAQD_SO_ST,'0'),1
--                                                                                    ,regexp_replace(d.BAQD_SO_ST,'0','',1,1)
--                                                                                    ,d.BAQD_SO_ST)
--                                                                        ,decode(INSTR(d.BAQD_SO_ST,'0'),1
--                                                                                    ,SUBSTR(regexp_replace(d.BAQD_SO_ST,'0','',1,1),1,instr(regexp_replace(d.BAQD_SO_ST,'0','',1,1),'/')-1)
--                                                                                    ,SUBSTR(d.BAQD_SO_ST,1,instr(d.BAQD_SO_ST,'/')-1) )
--                                                                        ))
--                                                        )
--                                                    )
--                                                      
--                                  AND NVL(d.BAQD_LOAIAN,0) > 0
--                                  GROUP BY  dmta.CAPCHAID,dmta.TEN,d.BAQD_LOAIAN
--                                   
--                                  )
--                LOOP
--                        v_table.extend;
--                        v_table(v_table.count) := R_GDTTT_THONGKE_8A(
--                        item.CAPCHAID,item.BAQD_LOAIAN,item.TEN,item.TENLOAIAN,
--                        0,0,0,0,0,0,0,0,0,0,
--                        0,0,0,0,0,0,0,0,0,0,
--                        0,0,0,0,0,0,0,0,0,0,
--                        0,0,0,0,0,item.colnum_36
--                        );   
--                END LOOP; 



       
--    OPEN curReturn FOR
--        SELECT TA.ARRTHUTU,ta.ten, A.* from  dm_toaan ta
--                          LEFT JOIN (
--                                    SELECT tk.CAPCHAID,tk.LOAIAN,tk.TENTOAAN,tk.TENLOAIAN,
--                                        sum(tk.COLUMN_1) COLUMN_1,sum(tk.COLUMN_2) COLUMN_2,sum(tk.COLUMN_3) COLUMN_3,sum(tk.COLUMN_4) COLUMN_4,sum(tk.COLUMN_5) COLUMN_5,
--                                        sum(tk.COLUMN_6) COLUMN_6,sum(tk.COLUMN_7) COLUMN_7,sum(tk.COLUMN_8) COLUMN_8,sum(tk.COLUMN_9) COLUMN_9,sum(tk.COLUMN_10) COLUMN_10,
--                                        sum(tk.COLUMN_11) COLUMN_11,sum(tk.COLUMN_12) COLUMN_12,sum(tk.COLUMN_13) COLUMN_13,sum(tk.COLUMN_14) COLUMN_14,sum(tk.COLUMN_15) COLUMN_15,
--                                        sum(tk.COLUMN_16) COLUMN_16,sum(tk.COLUMN_17)COLUMN_17,sum(tk.COLUMN_18) COLUMN_18,sum(tk.COLUMN_19) COLUMN_19,sum(tk.COLUMN_20) COLUMN_20,
--                                        sum(tk.COLUMN_21) COLUMN_21,sum(tk.COLUMN_22) COLUMN_22,sum(tk.COLUMN_23) COLUMN_23,sum(tk.COLUMN_24) COLUMN_24,sum(tk.COLUMN_25) COLUMN_25,
--                                        sum(tk.COLUMN_26) COLUMN_26,sum(tk.COLUMN_27) COLUMN_27,sum(tk.COLUMN_28) COLUMN_28,sum(tk.COLUMN_29) COLUMN_29,sum(tk.COLUMN_30) COLUMN_30,
--                                        sum(tk.COLUMN_31) COLUMN_31,sum(tk.COLUMN_32) COLUMN_32,sum(tk.COLUMN_33) COLUMN_33,sum(tk.COLUMN_34) COLUMN_34,sum(tk.COLUMN_35) COLUMN_35,
--                                        sum(tk.COLUMN_36) COLUMN_36               
--                                                FROM table(v_table) tk  
--                                                            group by tk.CAPCHAID,tk.LOAIAN,tk.TENTOAAN,tk.TENLOAIAN
--                            ) A on ta.ten = A.TENTOAAN 
--                        WHERE   ta.MADONGBO is not null
--                            AND ta.LOAITOA != 'TOICAO' AND ta.LOAITOA != 'CAPCAO' 
--                            AND instr(TA.ARRSAPXEP,'0/1/'||V_ToaAnID)>0
--                            
--                            ORDER BY TA.ARRSAPXEP
--                                 
--                                    ;    
                vTongALLCOLUMN_1 :=0;vTongALLCOLUMN_2 :=0;vTongALLCOLUMN_3 :=0;vTongALLCOLUMN_4 :=0;vTongALLCOLUMN_5 :=0;vTongALLCOLUMN_6 :=0;vTongALLCOLUMN_7 :=0;vTongALLCOLUMN_8 :=0;vTongALLCOLUMN_9 :=0;vTongALLCOLUMN_10 :=0;vTongALLCOLUMN_11 :=0;vTongALLCOLUMN_12 :=0;
                vTongALLCOLUMN_13 :=0;vTongALLCOLUMN_14 :=0;vTongALLCOLUMN_15 :=0;vTongALLCOLUMN_16 :=0;vTongALLCOLUMN_17 :=0;vTongALLCOLUMN_18 :=0;vTongALLCOLUMN_19 :=0;vTongALLCOLUMN_20 :=0;vTongALLCOLUMN_21 :=0;vTongALLCOLUMN_22 :=0;vTongALLCOLUMN_23 :=0;vTongALLCOLUMN_24 :=0;
                vTongALLCOLUMN_25 :=0;vTongALLCOLUMN_26 :=0;vTongALLCOLUMN_27 :=0;vTongALLCOLUMN_28 :=0;vTongALLCOLUMN_29 :=0;vTongALLCOLUMN_30 :=0;vTongALLCOLUMN_31 :=0;vTongALLCOLUMN_32 :=0;vTongALLCOLUMN_33 :=0;vTongALLCOLUMN_34 :=0;vTongALLCOLUMN_35 :=0;vTongALLCOLUMN_36 :=0;

-- Lay ra theo don vi cap tinh
        FOR itemta IN (SELECT * FROM dm_toaan ta 
                        where ta.MADONGBO is not null 
                            And TA.LOAITOA = 'CAPTINH' 
                             AND instr(TA.ARRSAPXEP,'0/1/'||V_ToaAnID||'/')>0
                            ORDER BY TA.ARRSAPXEP) 
        LOOP
                IF (itemta.LOAITOA = 'CAPTINH')THEN 
                             V_TABLE_ALL.extend;
                             V_TABLE_ALL(V_TABLE_ALL.count) := R_GDTTT_THONGKE_8A(
                                itemta.CAPCHAID,NULL,'CAPTINH',REPLACE(itemta.TEN, 'Tòa án nhân dân '),
                                NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
                                NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
                                NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
                                NULL,NULL,NULL,NULL,NULL,NULL
                                ); 
                END IF;
                    -------them tung don vi voi loai an----------------------------------
                vTongCOLUMN_1 :=0;vTongCOLUMN_2 :=0;vTongCOLUMN_3 :=0;vTongCOLUMN_4 :=0;vTongCOLUMN_5 :=0;vTongCOLUMN_6 :=0;vTongCOLUMN_7 :=0;vTongCOLUMN_8 :=0;vTongCOLUMN_9 :=0;vTongCOLUMN_10 :=0;vTongCOLUMN_11 :=0;vTongCOLUMN_12 :=0;
                vTongCOLUMN_13 :=0;vTongCOLUMN_14 :=0;vTongCOLUMN_15 :=0;vTongCOLUMN_16 :=0;vTongCOLUMN_17 :=0;vTongCOLUMN_18 :=0;vTongCOLUMN_19 :=0;vTongCOLUMN_20 :=0;vTongCOLUMN_21 :=0;vTongCOLUMN_22 :=0;vTongCOLUMN_23 :=0;vTongCOLUMN_24 :=0;
                vTongCOLUMN_25 :=0;vTongCOLUMN_26 :=0;vTongCOLUMN_27 :=0;vTongCOLUMN_28 :=0;vTongCOLUMN_29 :=0;vTongCOLUMN_30 :=0;vTongCOLUMN_31 :=0;vTongCOLUMN_32 :=0;vTongCOLUMN_33 :=0;vTongCOLUMN_34 :=0;vTongCOLUMN_35 :=0;vTongCOLUMN_36 :=0;

                
                FOR itemdv IN (SELECT dv.LOAITOA,tk.CAPCHAID,tk.LOAIAN,tk.TENTOAAN,tk.TENLOAIAN,
                                        sum(tk.COLUMN_1) COLUMN_1,sum(tk.COLUMN_2) COLUMN_2,sum(tk.COLUMN_3) COLUMN_3,sum(tk.COLUMN_4) COLUMN_4,sum(tk.COLUMN_5) COLUMN_5,
                                        sum(tk.COLUMN_6) COLUMN_6,sum(tk.COLUMN_7) COLUMN_7,sum(tk.COLUMN_8) COLUMN_8,sum(tk.COLUMN_9) COLUMN_9,sum(tk.COLUMN_10) COLUMN_10,
                                        sum(tk.COLUMN_11) COLUMN_11,sum(tk.COLUMN_12) COLUMN_12,sum(tk.COLUMN_13) COLUMN_13,sum(tk.COLUMN_14) COLUMN_14,sum(tk.COLUMN_15) COLUMN_15,
                                        sum(tk.COLUMN_16) COLUMN_16,sum(tk.COLUMN_17)COLUMN_17,sum(tk.COLUMN_18) COLUMN_18,sum(tk.COLUMN_19) COLUMN_19,sum(tk.COLUMN_20) COLUMN_20,
                                        sum(tk.COLUMN_21) COLUMN_21,sum(tk.COLUMN_22) COLUMN_22,sum(tk.COLUMN_23) COLUMN_23,sum(tk.COLUMN_24) COLUMN_24,sum(tk.COLUMN_25) COLUMN_25,
                                        sum(tk.COLUMN_26) COLUMN_26,sum(tk.COLUMN_27) COLUMN_27,sum(tk.COLUMN_28) COLUMN_28,sum(tk.COLUMN_29) COLUMN_29,sum(tk.COLUMN_30) COLUMN_30,
                                        sum(tk.COLUMN_31) COLUMN_31,sum(tk.COLUMN_32) COLUMN_32,sum(tk.COLUMN_33) COLUMN_33,sum(tk.COLUMN_34) COLUMN_34,sum(tk.COLUMN_35) COLUMN_35,
                                        sum(tk.COLUMN_36) COLUMN_36               
                                                  FROM table(v_table) tk 
                                                        LEFT JOIN dm_toaan dv on dv.ten = tk.TENTOAAN
                                                        WHERE tk.CAPCHAID = itemta.ID Or tk.TENTOAAN = itemta.ten
                                                        group by dv.LOAITOA,tk.CAPCHAID,tk.LOAIAN,tk.TENTOAAN,tk.TENLOAIAN
                                    )
                                    
                LOOP
                    IF (itemdv.LOAITOA = 'CAPHUYEN')THEN 
                         V_TABLE_ALL.extend;
                                 V_TABLE_ALL(V_TABLE_ALL.count) := R_GDTTT_THONGKE_8A(
                                    itemdv.CAPCHAID,NULL,'CAPHUYEN',REPLACE(itemdv.TENTOAAN, 'Tòa án nhân dân '),
                                    NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
                                    NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
                                    NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
                                    NULL,NULL,NULL,NULL,NULL,NULL
                                    ); 
                    END IF;
                    
                    vCheck := 0;
                    vCheck :=  itemdv.COLUMN_1 + itemdv.COLUMN_2 + itemdv.COLUMN_3 + itemdv.COLUMN_4 + itemdv.COLUMN_5 + itemdv.COLUMN_6 + itemdv.COLUMN_7 + itemdv.COLUMN_8 + itemdv.COLUMN_9 + itemdv.COLUMN_10 + 
                        itemdv.COLUMN_11 + itemdv.COLUMN_12 + itemdv.COLUMN_13 + itemdv.COLUMN_14 + itemdv.COLUMN_15 + itemdv.COLUMN_16 + itemdv.COLUMN_17 + itemdv.COLUMN_18 + itemdv.COLUMN_19 + itemdv.COLUMN_20 + 
                        itemdv.COLUMN_21 + itemdv.COLUMN_22 + itemdv.COLUMN_23 + itemdv.COLUMN_24 + itemdv.COLUMN_25 + itemdv.COLUMN_26 + itemdv.COLUMN_27 + itemdv.COLUMN_28 + itemdv.COLUMN_29 + itemdv.COLUMN_30 + 
                        itemdv.COLUMN_31 + itemdv.COLUMN_32 + itemdv.COLUMN_33 + itemdv.COLUMN_34 + itemdv.COLUMN_35 + itemdv.COLUMN_36;
                        
                        IF (vCheck > 0) THEN  
                            V_TABLE_ALL.extend;
                            V_TABLE_ALL(V_TABLE_ALL.count) := R_GDTTT_THONGKE_8A(
                                itemdv.CAPCHAID,itemdv.LOAIAN,itemdv.TENTOAAN,itemdv.TENLOAIAN,
                                itemdv.COLUMN_1,itemdv.COLUMN_2,itemdv.COLUMN_3,itemdv.COLUMN_4,itemdv.COLUMN_5,itemdv.COLUMN_6,itemdv.COLUMN_7,itemdv.COLUMN_8,itemdv.COLUMN_9,itemdv.COLUMN_10,
                                itemdv.COLUMN_11,itemdv.COLUMN_12,itemdv.COLUMN_13,itemdv.COLUMN_14,itemdv.COLUMN_15,itemdv.COLUMN_16,itemdv.COLUMN_17,itemdv.COLUMN_18,itemdv.COLUMN_19,itemdv.COLUMN_20,
                                itemdv.COLUMN_21,itemdv.COLUMN_22,itemdv.COLUMN_23,itemdv.COLUMN_24,itemdv.COLUMN_25,itemdv.COLUMN_26,itemdv.COLUMN_27,itemdv.COLUMN_28,itemdv.COLUMN_29,itemdv.COLUMN_30,
                                itemdv.COLUMN_31,itemdv.COLUMN_32,itemdv.COLUMN_33,itemdv.COLUMN_34,itemdv.COLUMN_35,itemdv.COLUMN_36
                                ); 
                        END IF;
                        -----Tong tung don vi
                            vTongCOLUMN_1:=vTongCOLUMN_1+itemdv.COLUMN_1;
                            vTongCOLUMN_2:=vTongCOLUMN_2+itemdv.COLUMN_2;
                            vTongCOLUMN_3:=vTongCOLUMN_3+itemdv.COLUMN_3;
                            vTongCOLUMN_4:=vTongCOLUMN_4+itemdv.COLUMN_4;
                            vTongCOLUMN_5:=vTongCOLUMN_5+itemdv.COLUMN_5;
                            vTongCOLUMN_6:=vTongCOLUMN_6+itemdv.COLUMN_6;
                            vTongCOLUMN_7:=vTongCOLUMN_7+itemdv.COLUMN_7;
                            vTongCOLUMN_8:=vTongCOLUMN_8+itemdv.COLUMN_8;
                            vTongCOLUMN_9:=vTongCOLUMN_9+itemdv.COLUMN_9;
                            vTongCOLUMN_10:=vTongCOLUMN_10+itemdv.COLUMN_10;
                            vTongCOLUMN_11:=vTongCOLUMN_11+itemdv.COLUMN_11;
                            vTongCOLUMN_12:=vTongCOLUMN_12+itemdv.COLUMN_12;
                            vTongCOLUMN_13:=vTongCOLUMN_13+itemdv.COLUMN_13;
                            vTongCOLUMN_14:=vTongCOLUMN_14+itemdv.COLUMN_14;
                            vTongCOLUMN_15:=vTongCOLUMN_15+itemdv.COLUMN_15;
                            vTongCOLUMN_16:=vTongCOLUMN_16+itemdv.COLUMN_16;
                            vTongCOLUMN_17:=vTongCOLUMN_17+itemdv.COLUMN_17;
                            vTongCOLUMN_18:=vTongCOLUMN_18+itemdv.COLUMN_18;
                            vTongCOLUMN_19:=vTongCOLUMN_19+itemdv.COLUMN_19;
                            vTongCOLUMN_20:=vTongCOLUMN_20+itemdv.COLUMN_20;
                            vTongCOLUMN_21:=vTongCOLUMN_21+itemdv.COLUMN_21;
                            vTongCOLUMN_22:=vTongCOLUMN_22+itemdv.COLUMN_22;
                            vTongCOLUMN_23:=vTongCOLUMN_23+itemdv.COLUMN_23;
                            vTongCOLUMN_24:=vTongCOLUMN_24+itemdv.COLUMN_24;
                            vTongCOLUMN_25:=vTongCOLUMN_25+itemdv.COLUMN_25;
                            vTongCOLUMN_26:=vTongCOLUMN_26+itemdv.COLUMN_26;
                            vTongCOLUMN_27:=vTongCOLUMN_27+itemdv.COLUMN_27;
                            vTongCOLUMN_28:=vTongCOLUMN_28+itemdv.COLUMN_28;
                            vTongCOLUMN_29:=vTongCOLUMN_29+itemdv.COLUMN_29;
                            vTongCOLUMN_30:=vTongCOLUMN_30+itemdv.COLUMN_30;
                            vTongCOLUMN_31:=vTongCOLUMN_31+itemdv.COLUMN_31;
                            vTongCOLUMN_32:=vTongCOLUMN_32+itemdv.COLUMN_32;
                            vTongCOLUMN_33:=vTongCOLUMN_33+itemdv.COLUMN_33;
                            vTongCOLUMN_34:=vTongCOLUMN_34+itemdv.COLUMN_34;
                            vTongCOLUMN_34:=vTongCOLUMN_35+itemdv.COLUMN_35;
                            vTongCOLUMN_34:=vTongCOLUMN_36+itemdv.COLUMN_36;
                            
                            
                END LOOP;  
        -- tinh tong cua don vi tinh va huyen
                        V_TABLE_ALL.extend;
                            V_TABLE_ALL(V_TABLE_ALL.count) := R_GDTTT_THONGKE_8A(
                                NULL,NULL,'Tổng cộng của đơn vị','Tổng cộng của đơn vị',
                                vTongCOLUMN_1,vTongCOLUMN_2,vTongCOLUMN_3,vTongCOLUMN_4,vTongCOLUMN_5,vTongCOLUMN_6,vTongCOLUMN_7,vTongCOLUMN_8,vTongCOLUMN_9,vTongCOLUMN_10,
                                vTongCOLUMN_11,vTongCOLUMN_12,vTongCOLUMN_13,vTongCOLUMN_14,vTongCOLUMN_15,vTongCOLUMN_16,vTongCOLUMN_17,vTongCOLUMN_18,vTongCOLUMN_19,vTongCOLUMN_20,
                                vTongCOLUMN_21,vTongCOLUMN_22,vTongCOLUMN_23,vTongCOLUMN_24,vTongCOLUMN_25,vTongCOLUMN_26,vTongCOLUMN_27,vTongCOLUMN_28,vTongCOLUMN_29,vTongCOLUMN_30,
                                vTongCOLUMN_31,vTongCOLUMN_32,vTongCOLUMN_33,vTongCOLUMN_34,vTongCOLUMN_35,vTongCOLUMN_36
                                ); 
                    -- Tong tat ca bao cao
                            vTongALLCOLUMN_1:=vTongALLCOLUMN_1+vTongCOLUMN_1;
                            vTongALLCOLUMN_2:=vTongALLCOLUMN_2+vTongCOLUMN_2;
                            vTongALLCOLUMN_3:=vTongALLCOLUMN_3+vTongCOLUMN_3;
                            vTongALLCOLUMN_4:=vTongALLCOLUMN_4+vTongCOLUMN_4;
                            vTongALLCOLUMN_5:=vTongALLCOLUMN_5+vTongCOLUMN_5;
                            vTongALLCOLUMN_6:=vTongALLCOLUMN_6+vTongCOLUMN_6;
                            vTongALLCOLUMN_7:=vTongALLCOLUMN_7+vTongCOLUMN_7;
                            vTongALLCOLUMN_8:=vTongALLCOLUMN_8+vTongCOLUMN_8;
                            vTongALLCOLUMN_9:=vTongALLCOLUMN_9+vTongCOLUMN_9;
                            vTongALLCOLUMN_10:=vTongALLCOLUMN_10+vTongCOLUMN_10;
                            vTongALLCOLUMN_11:=vTongALLCOLUMN_11+vTongCOLUMN_11;
                            vTongALLCOLUMN_12:=vTongALLCOLUMN_12+vTongCOLUMN_12;
                            vTongALLCOLUMN_13:=vTongALLCOLUMN_13+vTongCOLUMN_13;
                            vTongALLCOLUMN_14:=vTongALLCOLUMN_14+vTongCOLUMN_14;
                            vTongALLCOLUMN_15:=vTongALLCOLUMN_15+vTongCOLUMN_15;
                            vTongALLCOLUMN_16:=vTongALLCOLUMN_16+vTongCOLUMN_16;
                            vTongALLCOLUMN_17:=vTongALLCOLUMN_17+vTongCOLUMN_17;
                            vTongALLCOLUMN_18:=vTongALLCOLUMN_18+vTongCOLUMN_18;
                            vTongALLCOLUMN_19:=vTongALLCOLUMN_19+vTongCOLUMN_19;
                            vTongALLCOLUMN_20:=vTongALLCOLUMN_20+vTongCOLUMN_20;
                            vTongALLCOLUMN_21:=vTongALLCOLUMN_21+vTongCOLUMN_21;
                            vTongALLCOLUMN_22:=vTongALLCOLUMN_22+vTongCOLUMN_22;
                            vTongALLCOLUMN_23:=vTongALLCOLUMN_23+vTongCOLUMN_23;
                            vTongALLCOLUMN_24:=vTongALLCOLUMN_24+vTongCOLUMN_24;
                            vTongALLCOLUMN_25:=vTongALLCOLUMN_25+vTongCOLUMN_25;
                            vTongALLCOLUMN_26:=vTongALLCOLUMN_26+vTongCOLUMN_26;
                            vTongALLCOLUMN_27:=vTongALLCOLUMN_27+vTongCOLUMN_27;
                            vTongALLCOLUMN_28:=vTongALLCOLUMN_28+vTongCOLUMN_28;
                            vTongALLCOLUMN_29:=vTongALLCOLUMN_29+vTongCOLUMN_29;
                            vTongALLCOLUMN_30:=vTongALLCOLUMN_30+vTongCOLUMN_30;
                            vTongALLCOLUMN_31:=vTongALLCOLUMN_31+vTongCOLUMN_31;
                            vTongALLCOLUMN_32:=vTongALLCOLUMN_32+vTongCOLUMN_32;
                            vTongALLCOLUMN_33:=vTongALLCOLUMN_33+vTongCOLUMN_33;
                            vTongALLCOLUMN_34:=vTongALLCOLUMN_34+vTongCOLUMN_34;
                            vTongALLCOLUMN_34:=vTongALLCOLUMN_35+vTongCOLUMN_35;
                            vTongALLCOLUMN_34:=vTongALLCOLUMN_36+vTongCOLUMN_36;              
        END LOOP;
             -- Tong ca bao cao
                 V_TABLE_ALL.extend;
                            V_TABLE_ALL(V_TABLE_ALL.count) := R_GDTTT_THONGKE_8A(
                                NULL,NULL,'Tổng cộng','Tổng cộng',
                                vTongALLCOLUMN_1,vTongALLCOLUMN_2,vTongALLCOLUMN_3,vTongALLCOLUMN_4,vTongALLCOLUMN_5,vTongALLCOLUMN_6,vTongALLCOLUMN_7,vTongALLCOLUMN_8,vTongALLCOLUMN_9,vTongALLCOLUMN_10,
                                vTongALLCOLUMN_11,vTongALLCOLUMN_12,vTongALLCOLUMN_13,vTongALLCOLUMN_14,vTongALLCOLUMN_15,vTongALLCOLUMN_16,vTongALLCOLUMN_17,vTongALLCOLUMN_18,vTongALLCOLUMN_19,vTongALLCOLUMN_20,
                                vTongALLCOLUMN_21,vTongALLCOLUMN_22,vTongALLCOLUMN_23,vTongALLCOLUMN_24,vTongALLCOLUMN_25,vTongALLCOLUMN_26,vTongALLCOLUMN_27,vTongALLCOLUMN_28,vTongALLCOLUMN_29,vTongALLCOLUMN_30,
                                vTongALLCOLUMN_31,vTongALLCOLUMN_32,vTongALLCOLUMN_33,vTongALLCOLUMN_34,vTongALLCOLUMN_35,vTongALLCOLUMN_36
                                ); 
        
        
   --------------------------
   OPEN curReturn FOR 
        select * from table(V_TABLE_ALL);


END;


PROCEDURE GDT13_Export
(   V_ToaAnID	in	VARCHAR2,
    V_PhongbanID	in	VARCHAR2,
    V_LOAIAN_ID in  VARCHAR2,
    vTuNgay	in VARCHAR2,
    vDenNgay	in VARCHAR2,
    curReturn OUT sys_refcursor
)
IS 
    TotalItem number;MinIndex	number;MaxIndex	number;
    vvTuNgay date;vvDenNgay date;
BEGIN
    vvTuNgay:=to_date(trim(vTuNgay)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');vvDenNgay:=to_date(trim(vDenNgay)||' 23:59:59','dd/MM/yyyy HH24:MI:SS');
  --------------
  OPEN curReturn FOR
    select /*GSCM.PKG_VGDKT_BAOCAO.GDT13_Export */
        ROW_NUMBER() OVER (ORDER BY a.XXGDTTT_SOQD desc) STT, a.* 
        from (
             Select 
                v.XXGDTTT_SOQD 
                , case when (Length(NVL(v.XXGDTTT_NGAYQD,''))=0 or (to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') ='01/01/0001')) then ''
                                     when Length(NVL(v.XXGDTTT_NGAYQD,'')) >0 then to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy')
                                end  XXGDTTT_NGAYQD
               , DECODE( NVL(v.IsVienTruongKN,0),0,to_char(v.GDQ_Ngay,'dd/MM/yyyy'),to_char(v.vientruongkn_ngay,'dd/MM/yyyy'))
                             || '  '||DECODE( NVL(v.IsVienTruongKN,0), 0, 'CA TANDCC', 1, Decode(v.VIENTRUONGKN_NGUOIKY,818,'CA TANDTC','VKSCC tại '|| DECODE(v.TOAANID,4,'HN',5,'ĐN',6,'HCM','')))
                              
                        INFOR_KN
                ,Decode(NVL(V.LOAIAN,0),1,'Hình sự',2,'Dân sự',5,'Lao động',3,'HNGD',4,'KDTM',6,'Hành chính','') LOAIAN 
                ,DM_CanBo_TenToaVT(txx.Ma_Ten) DIAPHUONG               
               ,DECODE(v.BAQD_CAPXETXU,4,v.so_qdgdt,3,v.SOANPHUCTHAM,2,v.SOANSOTHAM,v.SOANPHUCTHAM) ||'/ '|| 
                DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd.MM.yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd.MM.yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd.MM.yyyy')) infoBA        
               --hinh su thi bi cao dau vu la nguyen don
               -- bi cao khieu nai la bi don
               ,DECODE(NVL(V.LOAIAN,0),1,DECODE(v.BIDON,NULL,DECODE(BD.BIDON_BD,null,v.NGUYENDON,BD.BIDON_BD),v.BIDON),DECODE(v.NGUYENDON,NULL,ND.NGUYENDON_ND,v.NGUYENDON)) NGUYENDON
               ,DECODE(NVL(V.LOAIAN,0),1,null,DECODE(v.BIDON,NULL,BD.BIDON_BD,v.BIDON)) BIDON
               ,Decode(NVL(V.loaian,0),1,case when NguyenDon is not null then NVL(qhpl.TENQHPL, Replace(v.TenVuAn,(NguyenDon ||' - ')))
                                      when NguyenDon is null and BiDon is not null  then NVL(qhpl.TENQHPL, Replace(v.TenVuAn,(BiDon ||' - ')))
                                      end
                            , decode(Trim(v.QHPL_TEXT),null,qhpl.TENQHPL,v.QHPL_TEXT) )  as QHPLDN             
               ,kq.TEN ketqua
               ,ttvxx.hoten ||'; '||pb.TENPHONGBAN 
                from GDTTT_VUAN v 
                         --Ket qua xet xu GDT
                        inner join (select * from gscm.GDTTT_VUAN_XETXUGDTTT where ISHOAN = 0) kqxx on kqxx.VUANID = v.id  
                        ---------
                        left join (select ID,MA_TEN from DM_TOAAN) txx on decode(v.BAQD_CAPXETXU,2, v.TOAANSOTHAM,3,v.TOAPHUCTHAMID,v.TOAQDID)=txx.ID
                        left join DM_PHONGBAN pgq on v.PhongBanID=pgq.ID
                        left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
                        left join DM_CANBO ttvxx on v.XXGDT_THAMTRAVIENID=ttvxx.ID
                        
                        left join (select ID,TENPHONGBAN from DM_PHONGBAN) pb on v.PhongBanID=pb.ID
                        left join (select ID,TEN from DM_DAtaItem) kq on kq.ID = v.XXGDTTT_KETQUAID
                        ----lấy tên đương sự được khiếu nại --anhvh add 29/05/2021
                              LEFT JOIN (SELECT  KN.VUANID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  BICAO
                                        FROM GDTTT_VUAN_DS_KN KN
                                        LEFT JOIN GDTTT_VUAN_DUONGSU DS ON DS.ID=KN.BICAOID
                                        LEFT JOIN GDTTT_VUAN_DUONGSU DSS ON DSS.ID=KN.NGUOIKHIEUNAIID
                                        GROUP BY KN.VUANID
                                    )HSKN ON HSKN.VUANID=V.ID
                             LEFT JOIN (SELECT  DS.VUANID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  NGUYENDON_ND
                                        FROM GDTTT_VUAN_DUONGSU DS
                                        WHERE DS.TUCACHTOTUNG='NGUYENDON' 
                                        GROUP BY DS.VUANID
                                )ND ON ND.VUANID=V.ID     
                             LEFT JOIN (SELECT  DS.VUANID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  BIDON_BD
                                        FROM GDTTT_VUAN_DUONGSU DS
                                        WHERE DS.TUCACHTOTUNG='BIDON' 
                                        GROUP BY DS.VUANID
                                )BD ON BD.VUANID=V.ID   
                                -----
                      where  v.TOAANID=V_ToaAnID  
                            AND (V_PhongbanID=0 Or (V_PhongbanID>0 And v.PhongBanID=V_PhongbanID)) --Phong ban nhan
                            AND (V_LOAIAN_ID = 0 Or (V_LOAIAN_ID != 0 And v.Loaian= REPLACE(V_LOAIAN_ID,'0',''))) --Loai an 
                            AND v.gqd_loaiketqua = 1 --KHáng nghị
                            AND NVL(v.truonghopthuly,0) not in (8,10) -- Khong phai Giai quyet khiếu nại tư pháp 
                             -- da xet xu GDT 
                            AND kqxx.KETQUAID > 1 
                            AND (kqxx.NGAYMOPT BETWEEN vvTuNgay and vvDenNgay
                                    Or v.XXGDTTT_NGAYQD BETWEEN vvTuNgay and vvDenNgay)
                           
            ) a;
END GDT13_Export;

PROCEDURE GDT12_Export
(   V_ToaAnID	in	VARCHAR2,
    V_PhongbanID	in	VARCHAR2,
    V_LOAIAN_ID in  VARCHAR2,
    v_LOAIXULY in	VARCHAR2,
    vTuNgay	in VARCHAR2,
    vDenNgay	in VARCHAR2,
    curReturn OUT sys_refcursor
)
IS 
    TotalItem number;MinIndex	number;MaxIndex	number;
    vvTuNgay date;vvDenNgay date;
BEGIN
    vvTuNgay:=to_date(trim(vTuNgay)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');vvDenNgay:=to_date(trim(vDenNgay)||' 23:59:59','dd/MM/yyyy HH24:MI:SS');
  --------------
  OPEN curReturn FOR
    select /*GSCM.PKG_VGDKT_BAOCAO.GDT12_Export */
        ROW_NUMBER() OVER (ORDER BY a.SOTHULYXXGDT desc) STT, a.* 
        from (
             Select 
              'Số '||v.SOTHULYXXGDT ||'  '||
                    case when (Length(NVL(v.NGAYTHULYXXGDT,''))=0 or (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') ='01/01/0001')) then ''
                                     when Length(NVL(v.NGAYTHULYXXGDT,'')) >0 then to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy')
                                end  INFOTL 
               ,DECODE(NVL(V.LOAIAN,0),1,'BC: '||v.BIDON --DECODE(v.BIDON,NULL,HSKN.BICAO,v.BIDON)
               ,'NĐ: '||DECODE(v.NGUYENDON,NULL,ND.NGUYENDON_ND,v.NGUYENDON) ||' BĐ: '||DECODE(v.BIDON,NULL,BD.BIDON_BD,v.BIDON))
                    InfoVuViec
               ,Decode(NVL(V.LOAIAN,0),1,BC.HS_TENTOIDANH ,decode(Trim(v.QHPL_TEXT),null,qhpl.TenQHPL,v.QHPL_TEXT)) Loaivuviec
               ,'Số '|| DECODE(v.BAQD_CAPXETXU,4,v.so_qdgdt,3,v.SOANPHUCTHAM,2,v.SOANSOTHAM,v.SOANPHUCTHAM) ||' '|| 
                DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')) infoBA        
               ,Decode(NVL(V.LOAIAN,0),1,'Hình sự',2,'Dân sự',5,'Lao động',3,'HNGD',4,'KDTM',6,'Hành chính','') LOAIAN 
               ,DM_CanBo_TenToaVT(txx.Ma_Ten) DIAPHUONG 
                , case when NVL(v.GQD_LOAIKETQUA,5) > 0 then ('Số '|| DECODE( NVL(v.IsVienTruongKN,0),0,v.GDQ_So,v.vientruongkn_so) 
                                                    || '  ' || DECODE( NVL(v.IsVienTruongKN,0),0,to_char(v.GDQ_Ngay,'dd/MM/yyyy'),to_char(v.vientruongkn_ngay,'dd/MM/yyyy'))
                                                    || '  '||DECODE( NVL(v.IsVienTruongKN,0), 0, 'CA TANDCC', 1, Decode(v.VIENTRUONGKN_NGUOIKY,818,'CA TANDTC','VKSCC')))
                  when NVL(v.GQD_LOAIKETQUA,5) = 0 then '' 
                end  LoaiKQ_GiaiQuyetDon
                ,pgq.TENPHONGBAN NOINHAN
                , (v.XXGDTTT_SOQD 
                    ||  (case when (Length(NVL(v.XXGDTTT_NGAYQD,''))=0 or (to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(v.XXGDTTT_NGAYQD,'')) >0 then (' - '||to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy'))
                            end)
                    ) as ThongTinKQ_XXGDTTT
                ,Decode(NVL(v.XXGDTTT_KETQUAID,0),0,'',kq.Ten) NOIDUNG
                ,'' GHICHU
                ,v.SOTHULYXXGDT
                from GDTTT_VUAN v 
                        left join (select ID,MA_TEN from DM_TOAAN) txx on decode(v.BAQD_CAPXETXU,2, v.TOAANSOTHAM,3,v.TOAPHUCTHAMID,v.TOAQDID)=txx.ID
                        left join DM_PHONGBAN pgq on v.PhongBanID=pgq.ID
                        left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
                        left join DM_CANBO tp on v.THAMPHANID=tp.ID
                        left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
                        left join DM_CANBO ld on v.LANHDAOVUID=ld.ID
                        left join DM_DataITem cv on ld.ChucVuID = cv.ID
                        left join (select ID,TENPHONGBAN from DM_PHONGBAN) pb on v.PhongBanID=pb.ID
                        left join (select ID,TEN from DM_DAtaItem) kq on kq.ID = v.XXGDTTT_KETQUAID
                        ----lấy tên đương sự được khiếu nại --anhvh add 29/05/2021
                              LEFT JOIN (SELECT  KN.VUANID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  BICAO
                                        FROM GDTTT_VUAN_DS_KN KN
                                        LEFT JOIN GDTTT_VUAN_DUONGSU DS ON DS.ID=KN.BICAOID
                                        LEFT JOIN GDTTT_VUAN_DUONGSU DSS ON DSS.ID=KN.NGUOIKHIEUNAIID
                                        GROUP BY KN.VUANID
                                    )HSKN ON HSKN.VUANID=V.ID
                             LEFT JOIN (SELECT  DS.VUANID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  NGUYENDON_ND
                                        FROM GDTTT_VUAN_DUONGSU DS
                                        WHERE DS.TUCACHTOTUNG='NGUYENDON' 
                                        GROUP BY DS.VUANID
                                )ND ON ND.VUANID=V.ID     
                             LEFT JOIN (SELECT  DS.VUANID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  BIDON_BD
                                        FROM GDTTT_VUAN_DUONGSU DS
                                        WHERE DS.TUCACHTOTUNG='BIDON' 
                                        GROUP BY DS.VUANID
                                )BD ON BD.VUANID=V.ID     
                       LEFT JOIN (SELECT  DS.VUANID,DS.TENDUONGSU BICAO_DV,DS.HS_TENTOIDANH 
                                        FROM GDTTT_VUAN_DUONGSU DS
                                        WHERE NVL(DS.HS_BICANDAUVU,0)=1 
                                )BC ON BC.VUANID=v.ID 
                      --anhvh add 21/11/2019 check ngày của vụ và ngày công văn dùng cho việc truy vấn phí dưới
                        LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                          END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                      --anhvh--án quốc hội gồm công văn 8.1 và 9.3
                        LEFT JOIN (select D.VuViecID from GDTTT_DON d 
                                 WHERE d.LOAICONGVAN in(Select I.ID from DM_DATAITEM I where (I.ID=546 OR I.CAPCHAID=546 OR I.ID = 1023 OR I.CAPCHAID=1023))
                                 GROUP BY d.VuViecID)AQH ON AQH.VuViecID=V.ID
                       ---lấy danh sách thụ lý đơn anhvh add 31/03/2020        
                        LEFT JOIN (
                                SELECT CV.VUVIECID,LISTAGG(CASE WHEN LENGTH(NVL(CV.TL_SO, ''))>0 THEN (CV.TL_SO ) ELSE '' END
                                              || CASE WHEN LENGTH(NVL(CV.TL_NGAY, ''))>0 THEN ('  ' || TO_CHAR(CV.TL_NGAY,'dd/MM/yyyy') ) ELSE '' END                         
                                        , '  ')
                                        WITHIN GROUP (ORDER BY CV.TL_NGAY DESC, CV.NGAYTAO DESC) LISTHULYDON
                                    ,LISTAGG(CV.NGUOIGUI_HOTEN,'; ')
                                        WITHIN GROUP (ORDER BY CV.NGUOIGUI_HOTEN DESC) NGUOIGUI_HOTEN
                                    FROM GDTTT_DON CV  
                                    WHERE  CV.CD_TRANGTHAI=2 AND CV.ISTHULY=1
                                    GROUP BY CV.VUVIECID
                                )DD ON DD.VUVIECID=v.ID
                        --Ket qua xet xu GDT
                    left join (select * from gscm.GDTTT_VUAN_XETXUGDTTT where ISHOAN = 0) kqxx on kqxx.VUANID = v.id         
                                -----
                      where  v.TOAANID=V_ToaAnID  
                            AND (V_PhongbanID=0 Or (V_PhongbanID>0 And v.PhongBanID=V_PhongbanID)) --Phong ban nhan
                            AND (to_number(V_LOAIAN_ID)=0 Or (to_number(V_LOAIAN_ID)>0 And v.Loaian=to_number(V_LOAIAN_ID))) --Loai an 
                            AND v.gqd_loaiketqua = 1 --KHáng nghị
                            AND NVL(v.truonghopthuly,0) not in (8,10) -- Khong phai Giai quyet khiếu nại tư pháp 
                             -- da xet xu GDT AND 
                           AND  ( v_LOAIXULY =0 -- Tat ca
                                   Or (v_LOAIXULY = 1 -- Da xet xu
                                        and kqxx.KETQUAID > 1 
                                        and kqxx.NGAYMOPT BETWEEN vvTuNgay and vvDenNgay)
                                    Or( v_LOAIXULY = 2 --Chua xet xu
                                         and ( v.XXGDTTT_KETQUAID is null
                                                Or (kqxx.KETQUAID > 1 and kqxx.NGAYMOPT > vvDenNgay))
                                        )
                                )
                                    
                            AND (v.NGAYTHULYXXGDT is not null and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001')) 
                            AND (v.NGAYTHULYXXGDT between vvTuNgay AND  vvDenNgay)      -- Ngày thuly
           UNION
           --Lay ra các Thu ly Ho so Khang nghị VKS ma chua chuyen xuong cá phòng GDKT hoặc đã chuyển nhưng chưa nhận
            select 'Số '||d.tl_so ||'  '||
                        case when (Length(NVL(d.tl_ngay,''))=0 or (to_char(d.tl_ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                                         when Length(NVL(d.tl_ngay,'')) >0 then to_char(d.tl_ngay,'dd/MM/yyyy')
                                    end  INFOTL 
                                    
                   ,DECODE (d.BAQD_LOAIAN,1,BC.BICAO_DV,('NĐ: '||ND.NGUYENDON_ND ||'u BĐ: '|| BD.BIDON_BD)) InfoVuViec
                   ,DECODE (d.BAQD_LOAIAN,1,BC.HS_TENTOIDANH,d.QHPL_TEXT) Loaivuviec
                   ,'Số '|| decode(d.BAQD_CAPXETXU,2,d.BAQD_SO_ST,3,d.BAQD_SO_PT, d.BAQD_SO) ||' '||
                    DECODE(d.BAQD_CAPXETXU,2,to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy'),3,to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy'),to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')) infoBA        
                   ,Decode(NVL(d.BAQD_LOAIAN,0),1,'Hình sự',2,'Dân sự',5,'Lao động',3,'HNGD',4,'KDTM',6,'Hành chính','') LOAIAN 
                   ,DM_CanBo_TenToaVT(txx.Ma_Ten) DIAPHUONG 
                   , 'Số '||d.SO_HSKN || ' ' || to_char(d.NGAY_HSKN,'dd/MM/yyyy') ||' '
                    ||DECODE(d.DONVICHUYEN_HSKN,1,'Viện Trưởng VKSTC',4,'Viện Trưởng VKSCC tại Hà Nội',5,'Viện Trưởng VKSCC tại Đà Nẵng',6,'Viện Trưởng VKSCC tại HCM',818,'Chánh án TANDTC')  LoaiKQ_GiaiQuyetDon
                    ,pgq.TENPHONGBAN NOINHAN
                    ,'' ThongTinKQ_XXGDTTT
                    ,'' NOIDUNG
                    ,'' GHICHU
                    ,d.tl_so as SOTHULYXXGDT
                    from  GDTTT_DON d 
                         LEFT JOIN (SELECT  DS.DONID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  NGUYENDON_ND
                                        FROM GDTTT_DON_DUONGSU_CC DS
                                        WHERE DS.TUCACHTOTUNG='NGUYENDON' 
                                        GROUP BY DS.DONID
                                )ND ON ND.DONID=d.ID     
                         LEFT JOIN (SELECT  DS.DONID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  BIDON_BD
                                        FROM GDTTT_DON_DUONGSU_CC DS
                                        WHERE DS.TUCACHTOTUNG='BIDON' 
                                        GROUP BY DS.DONID
                                )BD ON BD.DONID=d.ID 
                        LEFT JOIN (SELECT  DS.DONID,DS.TENDUONGSU BICAO_DV,DS.HS_TENTOIDANH 
                                        FROM GDTTT_DON_DUONGSU_CC DS
                                        WHERE NVL(DS.HS_BICANDAUVU,0)=1 
                                )BC ON BC.DONID=d.ID 
                        left join (select ID,MA_TEN from DM_TOAAN) txx on decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID)=txx.ID
                        left join DM_PHONGBAN pgq on d.CD_TA_DONVIID=pgq.ID
                        where d.TOAANID=V_ToaAnID 
                            AND (V_PhongbanID=0 Or (V_PhongbanID>0 And d.CD_TA_DONVIID=V_PhongbanID)) --Phong ban nhan
                            AND (to_number(V_LOAIAN_ID)=0 Or (to_number(V_LOAIAN_ID)>0 And d.BAQD_LOAIAN=to_number(V_LOAIAN_ID))) --Loai an 
                            and d.cd_trangthai in (0,1) -- chua chuyen va da chuyen chua nhan
                            and d.LOAIDON = 4 -- Ho so KN cua VKS
                             AND (d.tl_ngay is not null and (to_char(d.tl_ngay,'dd/MM/yyyy') !='01/01/0001')) 
                            AND (d.tl_ngay between vvTuNgay AND  vvDenNgay)      -- Ngày Thu ly
            ) a;

END GDT12_Export;

PROCEDURE GDT11_Export
(   V_ToaAnID	in	VARCHAR2,
    V_PHONGBANID	in	VARCHAR2,
    V_LOAIAN_ID in  VARCHAR2,
    v_THAMTRAVIEN_ID in	VARCHAR2,
    VTUNGAY in VARCHAR2,
    VDENNGAY in VARCHAR2,
    curReturn OUT sys_refcursor
)
IS 
    TotalItem number;MinIndex	number;MaxIndex	number;
    vvTuNgay date;vvDenNgay date;v_Tongso number:=0;
    
    v_table T_THONGKE_HCTP_CC;
BEGIN
    v_table := T_THONGKE_HCTP_CC();
    -----------------------
    vvTuNgay:=to_date(trim(vTuNgay)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');vvDenNgay:=to_date(trim(vDenNgay)||' 23:59:59','dd/MM/yyyy HH24:MI:SS');
    --------------
   FOR item in  (
                    select a.ID ThamTraVienID, a.HoTen HoTenTTV
                                   from 
                                    (  Select c.ID,c.HoTen,1 HieuLuc From DM_CANBO c
                                                     inner join (select i.ID,i.TEN from DM_DATAITEM i 
                                                                  where i.GROUPID=12 and i.MA in ('TTV','TTVCC','TTVC','TK1','TK','TKA','TKVC','C027','C010','C008','C009')
                                                                ) d1 on d1.ID=c.CHUCDANHID           
                                                WHere c.TOAANID=V_ToaAnID  
                                                    and (c.Phongbanid=V_PHONGBANID Or V_PHONGBANID = 0)
                                                    and c.HieuLuc=1
                                                    
                                    ) a order by a.ID desc, a.HoTen
                 )
    LOOP
             -----Tổng số Vu viec TLD
              Select Count(v.ID) into v_Tongso  FROM  GDTTT_VUAN v
                Where v.TOAANID=V_ToaAnID 
                    AND v.LOAI_GDTTTT != 8 --không phải la Khieu nai tu phap  
                     AND (V_LOAIAN_ID = 0 OR  v.LOAIAN =to_number(V_LOAIAN_ID))
                    And  v.gqd_loaiketqua = 0  -- Tra loi don
                    AND (v.GDQ_NGAY between vvTuNgay AND  vvDenNgay)      -- Ngày giai quyet 
                    AND v.thamtravienid = item.ThamTraVienID;
                    
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_HCTP_CC(
                        item.ThamTraVienID,item.HoTenTTV,
                         v_Tongso,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0
                        );
             --Số TLD phát hành
            Select Count(v.ID) into v_Tongso  FROM  GDTTT_VUAN v
                Where v.TOAANID=V_ToaAnID 
                    AND v.LOAI_GDTTTT != 8 --không phải la Khieu nai tu phap  
                    AND (V_LOAIAN_ID = 0 OR  v.LOAIAN =to_number(V_LOAIAN_ID)) 
                    And  v.gqd_loaiketqua = 0  -- Tra loi don
                    AND (v.GDQ_NGAY between vvTuNgay AND  vvDenNgay)      -- Ngày giai quyet 
                     AND v.thamtravienid = item.ThamTraVienID;
                    
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_HCTP_CC(
                        item.ThamTraVienID,item.HoTenTTV,
                         0,v_Tongso,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0
                        );   
                        
            --Người ký kháng nghị
            Select Count(v.ID) into v_Tongso  FROM  GDTTT_VUAN v
                Where v.TOAANID=V_ToaAnID
                    AND v.LOAI_GDTTTT != 8 --không phải la Khieu nai tu phap  
                     AND (V_LOAIAN_ID = 0 OR  v.LOAIAN =to_number(V_LOAIAN_ID))
                    And  v.gqd_loaiketqua = 1  -- Kháng nghị
                    AND NVL(v.TRUONGHOPTHULY,0) !=1 --Không phải KN của VKS 
                    AND (v.GDQ_NGAY between vvTuNgay AND  vvDenNgay)      -- Ngày giai quyet                   
                    AND v.thamtravienid = item.ThamTraVienID;
                    
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_HCTP_CC(
                        item.ThamTraVienID,item.HoTenTTV,
                         0,0,v_Tongso,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0
                        ); 
                        
            --Tổng số được phân công giải quyết Án GDT (Ngày xét xử GDTTT)
            Select Count(v.ID) into v_Tongso  FROM  GDTTT_VUAN v
                            --Ket qua xet xu GDT
                        left join (select * from gscm.GDTTT_VUAN_XETXUGDTTT where ISHOAN = 0) kqxx on kqxx.VUANID = v.id 
                Where v.TOAANID=V_ToaAnID 
                    AND (V_LOAIAN_ID = 0 OR  v.LOAIAN = to_number(V_LOAIAN_ID))
                    AND  v.gqd_loaiketqua = 1  -- Kháng nghị
                    AND kqxx.KETQUAID > 1 
                    AND (kqxx.NGAYMOPT BETWEEN  vvTuNgay AND  vvDenNgay)
                    --AND NVL(v.THAMQUYENXXGDT,0) = V_ToaAnID
                     AND v.XXGDT_THAMTRAVIENID = item.ThamTraVienID;
                    
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_HCTP_CC(
                        item.ThamTraVienID,item.HoTenTTV,
                         0,0,0,v_Tongso,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0
                        );  
--             Phân công Giải quyết khiếu nại
            Select Count(v.ID) into v_Tongso  FROM  GDTTT_VUAN v
                            Where v.TOAANID=V_ToaAnID 
                                 AND (V_LOAIAN_ID = 0 OR  v.LOAIAN =to_number(V_LOAIAN_ID))
                                AND  v.gqd_loaiketqua in (0,1,2,3)  
                                AND v.GQD_LOAIKETQUA IS NOT NULL  
                                AND v.LOAI_GDTTTT = 8 --măc dinh la Khieu nai tu phap            
                                AND v.TRUONGHOPTHULY = 8
                                AND v.GDQ_NGAY > vvTuNgay AND v.GDQ_NGAY < vvDenNgay
                                AND v.thamtravienid = item.ThamTraVienID;
                    
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_HCTP_CC(
                        item.ThamTraVienID,item.HoTenTTV,
                         0,0,0,0,v_Tongso,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0
                        );
--             --Giai quyet khac = Xep don + VKS Dang giai quyet
                Select Count(v.ID) into v_Tongso  FROM  GDTTT_VUAN v
                        Where v.TOAANID=V_ToaAnID
                            AND v.LOAI_GDTTTT != 8 --không phải la Khieu nai tu phap  
                             AND (V_LOAIAN_ID = 0 OR  v.LOAIAN =to_number(V_LOAIAN_ID))
                            And  v.gqd_loaiketqua in (2,3,4) 
                            AND v.LOAI_GDTTTT != 8 --không phải la Khieu nai tu phap    
                            AND (v.gqd_ngayphathanhcv between vvTuNgay AND  vvDenNgay)      -- Ngày giai quyet 
                             AND v.thamtravienid = item.ThamTraVienID;
                    
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_HCTP_CC(
                        item.ThamTraVienID,item.HoTenTTV,
                                     0,0,0,0,0,v_Tongso,
                                     0,0,0,0,0,0,
                                     0,0,0,0,0,0,
                                     0,0,0,0,0,0,
                                     0
                                    );
    END LOOP;
    
    OPEN curReturn FOR
        SELECT   PP.STT ,PP.TENTHAMPHAN,PP.SOVUTLD,PP.SOCVTLD,PP.NGUOIKN
                ,PP.ANGDT,PP.GQ_KHIEUNAI,PP.GQK,PP.QD_THHP,PP.TSVB_PHATHANH FROM (
                                    SELECT ROW_NUMBER() OVER (ORDER BY PA.TenLoaiAn asc) STT,PA.LOAIAN THAMPHANID,PA.TenLoaiAn TENTHAMPHAN, SUM(PA.COLUMN_1) SOVUTLD,SUM(PA.COLUMN_2) SOCVTLD,
                                            SUM(PA.COLUMN_3) NGUOIKN, SUM(PA.COLUMN_4) ANGDT,SUM(PA.COLUMN_5) GQ_KHIEUNAI,SUM(PA.COLUMN_6) GQK,'' QD_THHP,
                                            ( SUM(PA.COLUMN_2) +  SUM(PA.COLUMN_3) + SUM(PA.COLUMN_4) + SUM(PA.COLUMN_5) + SUM(PA.COLUMN_6)) TSVB_PHATHANH
                                          FROM TABLE(v_table) PA
                                          GROUP BY PA.LOAIAN,PA.TenLoaiAn ORDER BY PA.TenLoaiAn
                            )PP
     UNION ALL
        SELECT 0,'TỔNG CỘNG',SUM(PA.COLUMN_1) COLUMN_1,SUM(PA.COLUMN_2) COLUMN_2,SUM(PA.COLUMN_3)COLUMN_3,SUM(PA.COLUMN_4)COLUMN_4
              ,SUM(PA.COLUMN_5)COLUMN_5,SUM(PA.COLUMN_6)COLUMN_6,'',( SUM(PA.COLUMN_2) +  SUM(PA.COLUMN_3) + SUM(PA.COLUMN_4) + SUM(PA.COLUMN_5) + SUM(PA.COLUMN_6)) TSVB_PHATHANH
              FROM TABLE(v_table) PA GROUP BY NULL;
END GDT11_Export;

PROCEDURE GDT10_Export
(   V_ToaAnID	in	VARCHAR2,
    V_PHONGBANID	in	VARCHAR2,
    V_LOAIAN_ID in  VARCHAR2,
    v_THAMPHAN_ID in	VARCHAR2,
    VTUNGAY in VARCHAR2,
    VDENNGAY in VARCHAR2,
    curReturn OUT sys_refcursor
)
IS 
    TotalItem number;MinIndex	number;MaxIndex	number;
    vvTuNgay date;vvDenNgay date;v_Tongso number:=0;
    
    v_table T_THONGKE_HCTP_CC;
BEGIN
    v_table := T_THONGKE_HCTP_CC();
    -----------------------
    vvTuNgay:=to_date(trim(vTuNgay)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');vvDenNgay:=to_date(trim(vDenNgay)||' 23:59:59','dd/MM/yyyy HH24:MI:SS');
    --------------
   FOR item in  (
                    select a.ID ThamphanID, a.HoTen HoTenTP
                                   from 
                                    (  Select c.ID,c.HoTen,1 HieuLuc From DM_CANBO c
                                         inner join (select i.ID, i.TEN from DM_DATAITEM i 
                                                     where i.GROUPID=12 
                                                          and i.MA in ('TP','TPSC','TPTC','TPCC','TPTATC')
                                                    ) d1 on d1.ID=c.CHUCDANHID    
                                         left join (select c.ID, c.TEN from DM_DATAITEM c 
                                                      where c.GROUPID=13  and c.Ma in ('CA', 'PCA')
                                                    ) d on d.ID=c.CHUCVUID    
                                          WHere c.TOAANID=V_ToaAnID and c.HieuLuc=1 and (c.MaDongBo is not null or Length(NVL(c.Madongbo,''))>0 OR C.ID=40599)-- C.ID=40599 anhvh 16/09/2020 add ngoai lệ TP Dương văn Thăng vẫn được phân án                                   
                                          And c.HIEULUC=1 
--                                          and (c.ISHINHSU=1 Or c.ISDANSU=1 Or c.ISHNGD=1 Or c.ISKDTM=1 Or
--                                                              c.ISLAODONG=1 Or c.ISHANHCHINH=1 Or c.ISPHASAN=1)
                                    ) a order by a.HieuLuc desc, a.HoTen
                 )
    LOOP
             -----Tổng số Vu viec TLD
              Select Count(v.ID) into v_Tongso  FROM  GDTTT_VUAN v
                Where v.TOAANID=V_ToaAnID 
                    AND v.LOAI_GDTTTT != 8 --không phải la Khieu nai tu phap  
                     AND (V_LOAIAN_ID = 0 OR  NVL(v.LOAIAN,0) = V_LOAIAN_ID)
                    And  v.gqd_loaiketqua = 0  -- Tra loi don
                    AND (v.GDQ_NGAY between vvTuNgay AND  vvDenNgay)      -- Ngày giai quyet 
                    AND v.thamphanid = item.ThamphanID;
                    
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_HCTP_CC(
                        item.ThamphanID,item.HoTenTP,
                         v_Tongso,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0
                        );
             --Số TLD phát hành
            Select Count(v.ID) into v_Tongso  FROM  GDTTT_VUAN v
                Where v.TOAANID=V_ToaAnID 
                    AND v.LOAI_GDTTTT != 8 --không phải la Khieu nai tu phap  
                    AND (V_LOAIAN_ID = 0 OR  NVL(v.LOAIAN,0) = V_LOAIAN_ID)
                    And  v.gqd_loaiketqua = 0  -- Tra loi don
                    AND (v.GDQ_NGAY between vvTuNgay AND  vvDenNgay)      -- Ngày giai quyet 
                    AND v.thamphanid = item.ThamphanID;
                    
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_HCTP_CC(
                        item.ThamphanID,item.HoTenTP,
                         0,v_Tongso,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0
                        );   
                        
            --Người ký kháng nghị
            Select Count(v.ID) into v_Tongso  FROM  GDTTT_VUAN v
                Where v.TOAANID=V_ToaAnID 
                    AND v.LOAI_GDTTTT != 8 --không phải la Khieu nai tu phap  
                    AND (V_LOAIAN_ID = 0 OR  NVL(v.LOAIAN,0) = V_LOAIAN_ID)
                    And  v.gqd_loaiketqua = 1  -- Kháng nghị
                    AND NVL(v.TRUONGHOPTHULY,0) !=1 --Không phải KN của VKS 
                    AND (v.GDQ_NGAY between vvTuNgay AND  vvDenNgay)      -- Ngày giai quyet                   
                    AND Upper(Trim(v.GDQ_NGUOIKY)) = Upper(Trim(item.HoTenTP));
                    
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_HCTP_CC(
                        item.ThamphanID,item.HoTenTP,
                         0,0,v_Tongso,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0
                        ); 
                        
            --Tổng số được phân công giải quyết Án GDT (Thụ lý xét xử GDTTT)
            Select Count(v.ID) into v_Tongso  FROM  GDTTT_VUAN v
                Where v.TOAANID=V_ToaAnID
                    AND v.LOAI_GDTTTT != 8 --không phải la Khieu nai tu phap  
                    AND (V_LOAIAN_ID = 0 OR  NVL(v.LOAIAN,0) = V_LOAIAN_ID)
                    AND  v.gqd_loaiketqua = 1  -- Kháng nghị
                    AND v.NGAYTHULYXXGDT IS NOT NULL   
                    AND v.NGAYTHULYXXGDT > vvTuNgay AND v.NGAYTHULYXXGDT < vvDenNgay
                    AND NVL(v.THAMQUYENXXGDT,0) = V_ToaAnID
                    AND NVL(v.ISVIENTRUONGKN,0) = 0 -- CA KN
                    AND v.thamphanid = item.ThamphanID;
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_HCTP_CC(
                        item.ThamphanID,item.HoTenTP,
                         0,0,0,v_Tongso,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0
                        );  
--             Phân công Giải quyết khiếu nại
            Select Count(v.ID) into v_Tongso  FROM  GDTTT_VUAN v
                            Where v.TOAANID=V_ToaAnID 
                                AND (V_LOAIAN_ID = 0 OR  NVL(v.LOAIAN,0) = V_LOAIAN_ID)
                                AND  v.gqd_loaiketqua in (0,1,2,3)  
                                AND v.GQD_LOAIKETQUA IS NOT NULL  
                                AND v.LOAI_GDTTTT = 8 --măc dinh la Khieu nai tu phap            
                                AND v.TRUONGHOPTHULY = 8
                                AND v.GDQ_NGAY > vvTuNgay AND v.GDQ_NGAY < vvDenNgay
                                AND v.THAMPHANID = item.ThamphanID;
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_HCTP_CC(
                         item.ThamphanID,item.HoTenTP,
                         0,0,0,0,v_Tongso,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0
                        );
--             --Giai quyet khac = Xep don + VKS Dang giai quyet
                Select Count(v.ID) into v_Tongso  FROM  GDTTT_VUAN v
                        Where v.TOAANID=V_ToaAnID 
                            AND v.LOAI_GDTTTT != 8 --không phải la Khieu nai tu phap  
                             AND (V_LOAIAN_ID = 0 OR  v.LOAIAN =V_LOAIAN_ID)
                            And  v.gqd_loaiketqua in (2,3,4) 
                            AND (v.GDQ_NGAY between vvTuNgay AND  vvDenNgay)      -- Ngày giai quyet 
                            AND v.thamphanid = item.ThamphanID;
                          v_table.extend;
                          v_table(v_table.count) := R_THONGKE_HCTP_CC(
                                     item.ThamphanID,item.HoTenTP,
                                     0,0,0,0,0,v_Tongso,
                                     0,0,0,0,0,0,
                                     0,0,0,0,0,0,
                                     0,0,0,0,0,0,
                                     0
                                    );
    END LOOP;
    
    OPEN curReturn FOR
        SELECT   PP.STT ,PP.TENTHAMPHAN,PP.SOVUTLD,PP.SOCVTLD,PP.NGUOIKN
                ,PP.ANGDT,PP.GQ_KHIEUNAI,PP.GQK,PP.QD_THHP,PP.TSVB_PHATHANH FROM (
                                    SELECT ROW_NUMBER() OVER (ORDER BY PA.TenLoaiAn asc) STT,PA.LOAIAN THAMPHANID,PA.TenLoaiAn TENTHAMPHAN, SUM(PA.COLUMN_1) SOVUTLD,SUM(PA.COLUMN_2) SOCVTLD
                                            ,SUM(PA.COLUMN_3) NGUOIKN, SUM(PA.COLUMN_4) ANGDT,SUM(PA.COLUMN_5) GQ_KHIEUNAI,SUM(PA.COLUMN_6) GQK,'' QD_THHP
                                            ,( SUM(PA.COLUMN_2) +  SUM(PA.COLUMN_3) + SUM(PA.COLUMN_4) + SUM(PA.COLUMN_5) + SUM(PA.COLUMN_6)) TSVB_PHATHANH
                                            ,( SUM(PA.COLUMN_1) + SUM(PA.COLUMN_2) +  SUM(PA.COLUMN_3) + SUM(PA.COLUMN_4) + SUM(PA.COLUMN_5) + SUM(PA.COLUMN_6)) Tong
                                          FROM TABLE(v_table) PA
                                          GROUP BY PA.LOAIAN,PA.TenLoaiAn ORDER BY PA.TenLoaiAn
                            )PP WHERE PP.TONG > 0
     UNION ALL
        SELECT 0,'TỔNG CỘNG',SUM(PA.COLUMN_1) COLUMN_1,SUM(PA.COLUMN_2) COLUMN_2,SUM(PA.COLUMN_3)COLUMN_3,SUM(PA.COLUMN_4)COLUMN_4
              ,SUM(PA.COLUMN_5)COLUMN_5,SUM(PA.COLUMN_6)COLUMN_6,'',( SUM(PA.COLUMN_2) +  SUM(PA.COLUMN_3) + SUM(PA.COLUMN_4) + SUM(PA.COLUMN_5) + SUM(PA.COLUMN_6)) TSVB_PHATHANH
              FROM TABLE(v_table) PA GROUP BY NULL;
END GDT10_Export;

PROCEDURE GDT09_Export
(   V_ToaAnID	in	VARCHAR2,
    V_Donvi_KNID	in	VARCHAR2,
    V_LOAIAN_ID in  VARCHAR2,
    v_LOAIXULY in	VARCHAR2,
    VTUNGAY in VARCHAR2,
    VDENNGAY in VARCHAR2,
    curReturn OUT sys_refcursor
)
IS 
    TotalItem number;MinIndex	number;MaxIndex	number;
    vvTuNgay date;vvDenNgay date;v_Tongso number:=0;
    
    v_table T_THONGKE_HCTP_CC;
BEGIN
    v_table := T_THONGKE_HCTP_CC();
    -----------------------
    vvTuNgay:=to_date(trim(vTuNgay)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');vvDenNgay:=to_date(trim(vDenNgay)||' 23:59:59','dd/MM/yyyy HH24:MI:SS');
    --------------
   FOR item in  (
                    select v.BAQD_LOAIAN,DECODE(V.BAQD_LOAIAN,1,'Hình sự',2,'Dân sự',3,'HNGĐ',4,'Kinh tế',5,'Lao động',6,'Hành chính',7,'Phá sản',55,'Chưa xác định')LOAIAN_TEN
                    From (select nvl(d.BAQD_LOAIAN,55)BAQD_LOAIAN from GDTTT_DON d) v 
                    where V.BAQD_LOAIAN IS NOT NULL AND V.BAQD_LOAIAN != 0
                    group by V.BAQD_LOAIAN,DECODE(V.BAQD_LOAIAN,1,'Hình sự',2,'Dân sự',3,'HNGĐ',4,'Kinh tế',5,'Lao động',6,'Hành chính',7,'Phá sản',55,'Chưa xác định')
                 )
    LOOP
             -----Tổng số đơn đã nhận HCTP
             SELECT COUNT(*) INTO v_Tongso From GDTTT_DON d
             LEFT JOIN VT_CHUYEN_NHAN CN ON CN.GDTTT_DON_ID=D.ID
              Where d.TOAANID=V_ToaAnID 
              AND  NOT EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN WHERE GDTTT_DON_ID=D.ID AND TRANG_THAI_XLY=3)
              --AND ( V_XEM_ALL=1 OR(V_XEM_ALL=0 AND d.nguoitao=VstrUsername) )
              AND NVL(d.BAQD_LOAIAN,0)= item.BAQD_LOAIAN
              AND d.CD_LOAI not in (1,2) -- Khong bao Chuyen toa khac và Ngoài Tòa
              AND(
                  (d.NGAYTAO>=vvTuNgay AND d.NGAYTAO<=vvDenNgay)
              );
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_HCTP_CC(
                        item.BAQD_LOAIAN,item.LOAIAN_TEN,
                         v_Tongso,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0
                        );
             --Thụ lý mới
            SELECT COUNT(*) INTO v_Tongso From GDTTT_DON d
              Where d.TOAANID=V_ToaAnID            
                    AND NVL(d.BAQD_LOAIAN,0)= item.BAQD_LOAIAN
                    AND d.CD_LOAI=0 -- Noi chuyen Nội bộ
                    AND d.isthuly = 1 -- Thụ lý mới
                    AND d.CD_TA_TRANGTHAI=0
                    AND( (d.NGAYTAO>=vvTuNgay AND d.NGAYTAO<=vvDenNgay)
                        --Or  ( d.TL_NGAY>=vvTuNgay and d.TL_NGAY <= vvDenNgay )
                        );
              -----
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_HCTP_CC(
                        item.BAQD_LOAIAN,item.LOAIAN_TEN,
                         0,v_Tongso,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0
                        );   
                        
            --Đơn yêu cầu bổ sung
            SELECT COUNT(*) INTO v_Tongso From GDTTT_DON d
                                  LEFT JOIN GDTTT_DON_YEUCAU_BOSUNG bs ON bs.DONID = d.id
              Where d.TOAANID=V_ToaAnID 
                AND NVL(d.BAQD_LOAIAN,0)= item.BAQD_LOAIAN
                AND d.CD_LOAI=0  AND d.CD_TA_TRANGTHAI=1 --Don chua đủ điều kiện
                AND( (d.NGAYTAO>=vvTuNgay AND d.NGAYTAO<=vvDenNgay)
--               Or  ( bs.NGAYTHONGBAO>=vvTuNgay and bs.NGAYTHONGBAO <= vvDenNgay )
              )
              ;
              ----- 
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_HCTP_CC(
                        item.BAQD_LOAIAN,item.LOAIAN_TEN,
                         0,0,v_Tongso,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0
                        ); 
            --Trả lại đơn do quá thời hiệu
            SELECT COUNT(*) INTO v_Tongso From GDTTT_DON d
              Where d.TOAANID=V_ToaAnID            
                    AND NVL(d.BAQD_LOAIAN,0)= item.BAQD_LOAIAN
                    AND d.CD_LOAI=3 -- Trả lại đơn
                    AND d.CD_TRALAI_LYDOID IN (1717,1718) -- Hết thời hiệu
                    AND (d.NGAYTAO>=vvTuNgay AND d.NGAYTAO<=vvDenNgay);
              -----
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_HCTP_CC(
                        item.BAQD_LOAIAN,item.LOAIAN_TEN,
                         0,0,0,v_Tongso,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0
                        );  
             --Đơn trùng và Xếp đơn; chuyển đơn
            SELECT COUNT(*) INTO v_Tongso From GDTTT_DON d
              Where d.TOAANID=V_ToaAnID            
                    AND NVL(d.BAQD_LOAIAN,0)= item.BAQD_LOAIAN
                    AND (d.CD_LOAI IN (4) -- xếp đơn;
                         Or (d.CD_LOAI=0 AND d.CD_TA_TRANGTHAI=0 And d.isthuly = 2)
                            )
                    AND (d.NGAYTAO>=vvTuNgay AND d.NGAYTAO<=vvDenNgay);
              -----
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_HCTP_CC(
                        item.BAQD_LOAIAN,item.LOAIAN_TEN,
                         0,0,0,0,v_Tongso,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0
                        );
             --Đã thụ lý xx GĐT
             --CA TANDCC Kháng nghị
             Select Count(v.ID) into v_Tongso  FROM  GDTTT_VUAN v
                Where v.TOAANID=V_ToaAnID 
                    AND  NVL(v.LOAIAN,0)= item.BAQD_LOAIAN
                    And  v.gqd_loaiketqua = 1 and v.NGAYTHULYXXGDT IS NOT NULL   
                    AND v.NGAYTHULYXXGDT>vvTuNgay AND v.NGAYTHULYXXGDT<vvDenNgay
                    AND NVL(v.THAMQUYENXXGDT,0) = V_ToaAnID
                    AND NVL(v.ISVIENTRUONGKN,0) = 0; -- CA KN
                    
                ------
                v_table.extend;
                v_table(v_table.count) := R_THONGKE_HCTP_CC(
                        item.BAQD_LOAIAN,item.LOAIAN_TEN,
                         0,0,0,0,0,v_Tongso,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0
                        );
            --VKSNDCC Kháng nghị
             Select Count(v.ID) into v_Tongso  FROM  GDTTT_VUAN v
                Where v.TOAANID=V_ToaAnID 
                    AND v.LOAI_GDTTTT != 8 --không phải la Khieu nai tu phap  
                    AND  NVL(v.LOAIAN,0)= item.BAQD_LOAIAN
                    And  v.gqd_loaiketqua = 1 and v.NGAYTHULYXXGDT IS NOT NULL   
                    AND v.NGAYTHULYXXGDT>vvTuNgay AND v.NGAYTHULYXXGDT<vvDenNgay
                    AND   NVL(v.THAMQUYENXXGDT,0) = V_ToaAnID
                    AND NVL(v.ISVIENTRUONGKN,0) = 1; --VKS KN
                    
                ------
                v_table.extend;
                v_table(v_table.count) := R_THONGKE_HCTP_CC(
                        item.BAQD_LOAIAN,item.LOAIAN_TEN,
                         0,0,0,0,0,0,
                         v_Tongso,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0
                        );
            --TANDTC Kháng nghị
             Select Count(v.ID) into v_Tongso  FROM  GDTTT_VUAN v
                Where v.TOAANID=V_ToaAnID 
                    AND  NVL(v.LOAIAN,0)= item.BAQD_LOAIAN 
                    And  v.gqd_loaiketqua = 1 and v.NGAYTHULYXXGDT IS NOT NULL   
                    AND v.NGAYTHULYXXGDT>vvTuNgay AND v.NGAYTHULYXXGDT<vvDenNgay
                    AND   NVL(v.THAMQUYENXXGDT,0) = 1 --TANDTC
                    AND NVL(v.ISVIENTRUONGKN,0) = 0; --CA TANDTC KN
                    
                ------
                v_table.extend;
                v_table(v_table.count) := R_THONGKE_HCTP_CC(
                        item.BAQD_LOAIAN,item.LOAIAN_TEN,
                         0,0,0,0,0,0,
                         0,v_Tongso,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0
                        );            
            --VKSTC Kháng nghị
             Select Count(v.ID) into v_Tongso  FROM  GDTTT_VUAN v
                Where v.TOAANID=V_ToaAnID 
                    AND v.LOAI_GDTTTT != 8 --không phải la Khieu nai tu phap  
                    AND  NVL(v.LOAIAN,0)= item.BAQD_LOAIAN
                    And  v.gqd_loaiketqua = 1 and v.NGAYTHULYXXGDT IS NOT NULL   
                    AND v.NGAYTHULYXXGDT>vvTuNgay AND v.NGAYTHULYXXGDT<vvDenNgay
                    AND   NVL(v.THAMQUYENXXGDT,0) = 1 --VKS TC
                    AND NVL(v.ISVIENTRUONGKN,0) = 1; --VC VKSTC KN
                    
                ------
                v_table.extend;
                v_table(v_table.count) := R_THONGKE_HCTP_CC(
                        item.BAQD_LOAIAN,item.LOAIAN_TEN,
                         0,0,0,0,0,0,
                         0,0,v_Tongso,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0
                        ); 
            --Xu ly don khong thuoc tham quyen
            --Chuyển đơn
            SELECT COUNT(*) INTO v_Tongso From GDTTT_DON d
              Where d.TOAANID=V_ToaAnID            
                    AND NVL(d.BAQD_LOAIAN,0)= item.BAQD_LOAIAN
                    AND d.CD_LOAI IN (1,2) -- đơn chuyển Tòa khác; đơn chuyển ngoài Tòa
                    AND (d.NGAYTAO>=vvTuNgay AND d.NGAYTAO<=vvDenNgay);
              -----
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_HCTP_CC(
                        item.BAQD_LOAIAN,item.LOAIAN_TEN,
                         0,0,0,0,0,0,
                         0,0,0,v_Tongso,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0
                        );
             --Trả lại đơn trường hợp khác
            SELECT COUNT(*) INTO v_Tongso From GDTTT_DON d
              Where d.TOAANID=V_ToaAnID            
                    AND NVL(d.BAQD_LOAIAN,0)= item.BAQD_LOAIAN
                    AND d.CD_LOAI IN (3) -- Tra lai don 
                    AND d.CD_TRALAI_LYDOID NOt IN (1717,1718)
                    AND (d.NGAYTAO>=vvTuNgay AND d.NGAYTAO<=vvDenNgay);
              -----
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_HCTP_CC(
                        item.BAQD_LOAIAN,item.LOAIAN_TEN,
                         0,0,0,0,0,0,
                         0,0,0,0,v_Tongso,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0
                        );             
    END LOOP;
    
    OPEN curReturn FOR
        SELECT   PP.TENLOAIAN,PP.TONGDANHAN,PP.THULYMOI,PP.YCBS,PP.TRALAIDON
                ,PP.DONKHAC,PP.TACC_KN,PP.VKSCC_KN,PP.TATC_KN,PP.VKSTC_KN,PP.CHUYENDON,
                PP.TRALAIDON_2 FROM (
                                    SELECT PA.LOAIAN,PA.TenLoaiAn TENLOAIAN, SUM(PA.COLUMN_1) TONGDANHAN,SUM(PA.COLUMN_2) THULYMOI, SUM(PA.COLUMN_3) YCBS, SUM(PA.COLUMN_4) TRALAIDON
                                          ,SUM(PA.COLUMN_5) DONKHAC,SUM(PA.COLUMN_6) TACC_KN,SUM(PA.COLUMN_7) VKSCC_KN,SUM(PA.COLUMN_8) TATC_KN,SUM(PA.COLUMN_9) VKSTC_KN
                                          ,SUM(PA.COLUMN_10) CHUYENDON,SUM(PA.COLUMN_11) TRALAIDON_2
                                          FROM TABLE(v_table) PA
                                          GROUP BY PA.LOAIAN,PA.TenLoaiAn ORDER BY PA.LOAIAN
                            )PP
     UNION ALL
        SELECT 'TỔNG CỘNG',SUM(PA.COLUMN_1) COLUMN_1,SUM(PA.COLUMN_2) COLUMN_2,SUM(PA.COLUMN_3)COLUMN_3,SUM(PA.COLUMN_4)COLUMN_4
              ,SUM(PA.COLUMN_5)COLUMN_5,SUM(PA.COLUMN_6)COLUMN_6,SUM(PA.COLUMN_7)COLUMN_7,SUM(PA.COLUMN_8)COLUMN_8,SUM(PA.COLUMN_9)COLUMN_9
              ,SUM(PA.COLUMN_10)COLUMN_10,SUM(PA.COLUMN_11)COLUMN_11
              FROM TABLE(v_table) PA GROUP BY NULL;
END GDT09_Export;

PROCEDURE GDT08_Export
(   V_ToaAnID	in	VARCHAR2,
    V_PhongbanID	in	VARCHAR2,
    V_LOAIAN_ID in  VARCHAR2,
    v_LOAIXULY in	VARCHAR2,
    V_NGAY_FROM	in date,
    V_NGAY_TO	in date,
    curReturn OUT sys_refcursor
)
IS 
    TotalItem number;MinIndex	number;MaxIndex	number;
    vdenngay date;
BEGIN
 SELECT DECODE(V_NGAY_TO,null,sysdate,to_date(to_char(V_NGAY_TO,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS')) into vdenngay from dual;
  --------------
  OPEN curReturn FOR
   select /*GSCM.PKG_VGDKT_BAOCAO.GDT08_Export (Danh sach Don HCTP) */ a.* from (
      Select ROW_NUMBER() OVER (ORDER BY V.GDQ_SO desc) STT
       ,v.GDQ_SO SO
       --Xu ly khac; xep don, VKS dang giai quyet  ngay ket qua là GQD_NGAYPHATHANHCV; 
       ,DECODE(to_char(v.GQD_NGAYPHATHANHCV,'dd/MM/yyyy'),'01/01/0001','',to_char(v.GQD_NGAYPHATHANHCV,'dd/MM/yyyy')) NGAY
       ,Decode(NVL(V.loaian,0),1,'Hình sự',2,'Dân sự',5,'Lao động',3,'HNGD',4,'KDTM',6,'Hành chính','') LOAIAN
       ,DM_CanBo_TenToaVT(txx.Ma_Ten) DIAPHUONG 
       
       ,DECODE(v.BAQD_CAPXETXU,4,v.so_qdgdt,3,v.SOANPHUCTHAM,2,v.SOANSOTHAM,v.SOANPHUCTHAM) ||' '|| 
        DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')) infoBA
       ,DECODE(v.NGUYENDON,NULL,ND.NGUYENDON_ND,v.NGUYENDON) NGUYENDON
       ,decode(v.loaian,1,DECODE(v.BIDON,NULL,HSKN.BICAO,v.BIDON),DECODE(v.BIDON,NULL,BD.BIDON_BD,v.BIDON)) BIDON
       ,Decode(NVL(V.loaian,0),1,case when NguyenDon is not null then NVL(qhpl.TENQHPL, Replace(v.TenVuAn,(NguyenDon ||' - ')))
                                      when NguyenDon is null and BiDon is not null  then NVL(qhpl.TENQHPL, Replace(v.TenVuAn,(BiDon ||' - ')))
                                      end
                            , decode(Trim(v.QHPL_TEXT),null,qhpl.TENQHPL,v.QHPL_TEXT) )  as QHPLDN
       ,DD.LISTHULYDON infoThuLy
       ,DD.NGUOIGUI_HOTEN NGUOIKHIEUNAI
       ,v.gqd_ketqua NOIDUNG
       ,DECODE(NVL(ttv.ID,0),0,'','TTV '||ttv.HOTEN) ||' ' ||pb.TENPHONGBAN NOICHUYEN  
        from GDTTT_VUAN v 
                left join (select ID,MA_TEN from DM_TOAAN) txx on decode(v.BAQD_CAPXETXU,2, v.TOAANSOTHAM,3,v.TOAPHUCTHAMID,v.TOAQDID)=txx.ID
                left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
                left join DM_CANBO tp on v.THAMPHANID=tp.ID
                left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
                left join DM_CANBO ld on v.LANHDAOVUID=ld.ID
                left join DM_DataITem cv on ld.ChucVuID = cv.ID
                left join (select ID,TENPHONGBAN from DM_PHONGBAN) pb on v.PhongBanID=pb.ID
                left join DM_DAtaItem kq on kq.ID = v.XXGDTTT_KETQUAID
                ----lấy tên đương sự được khiếu nại --anhvh add 29/05/2021
                      LEFT JOIN (SELECT  KN.VUANID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  BICAO
                                FROM GDTTT_VUAN_DS_KN KN
                                LEFT JOIN GDTTT_VUAN_DUONGSU DS ON DS.ID=KN.BICAOID
                                LEFT JOIN GDTTT_VUAN_DUONGSU DSS ON DSS.ID=KN.NGUOIKHIEUNAIID
                                GROUP BY KN.VUANID
                            )HSKN ON HSKN.VUANID=V.ID
                     LEFT JOIN (SELECT  DS.VUANID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  NGUYENDON_ND
                                FROM GDTTT_VUAN_DUONGSU DS
                                WHERE DS.TUCACHTOTUNG='NGUYENDON' 
                                GROUP BY DS.VUANID
                        )ND ON ND.VUANID=V.ID     
                     LEFT JOIN (SELECT  DS.VUANID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  BIDON_BD
                                FROM GDTTT_VUAN_DUONGSU DS
                                WHERE DS.TUCACHTOTUNG='BIDON' 
                                GROUP BY DS.VUANID
                        )BD ON BD.VUANID=V.ID     
              --anhvh add 21/11/2019 check ngày của vụ và ngày công văn dùng cho việc truy vấn phí dưới
                LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                  WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                  WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                  END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
              --anhvh--án quốc hội gồm công văn 8.1 và 9.3
                LEFT JOIN (select D.VuViecID from GDTTT_DON d 
                         WHERE d.LOAICONGVAN in(Select I.ID from DM_DATAITEM I where (I.ID=546 OR I.CAPCHAID=546 OR I.ID = 1023 OR I.CAPCHAID=1023))
                         GROUP BY d.VuViecID)AQH ON AQH.VuViecID=V.ID
              ----
               ---lấy danh sách thụ lý đơn anhvh add 31/03/2020        
                LEFT JOIN (
                        SELECT CV.VUVIECID,LISTAGG(CASE WHEN LENGTH(NVL(CV.TL_SO, ''))>0 THEN (CV.TL_SO ) ELSE '' END
                                      || CASE WHEN LENGTH(NVL(CV.TL_NGAY, ''))>0 THEN (' ' || TO_CHAR(CV.TL_NGAY,'dd/MM/yyyy') ) ELSE '' END                         
                                , '  ')
                                WITHIN GROUP (ORDER BY CV.TL_NGAY DESC, CV.NGAYTAO DESC) LISTHULYDON
                            ,LISTAGG(CV.NGUOIGUI_HOTEN,'; ')
                                WITHIN GROUP (ORDER BY CV.NGUOIGUI_HOTEN DESC) NGUOIGUI_HOTEN
                            FROM GDTTT_DON CV  
                            WHERE  CV.CD_TRANGTHAI=2 AND CV.ISTHULY=1
                            GROUP BY CV.VUVIECID
                        )DD ON DD.VUVIECID=v.ID
                        -----
              where  v.TOAANID=V_ToaAnID   
                    AND (V_LOAIAN_ID = 0 OR  NVL(v.LOAIAN,0) = to_number(V_LOAIAN_ID))
                    AND (V_PhongbanID=0 Or (V_PhongbanID>0 And v.PhongBanID=V_PhongbanID)) --Phong ban nhan
                    AND v.gqd_loaiketqua IN (2,3,4) --Xếp đơn; VKS đang giải quyết; Xử lý khác
                    AND NVL(v.truonghopthuly,0) not in (8,10) -- Khong phai Giai quyet khiếu nại tư pháp 
                    AND ((v.GDQ_NGAY between V_NGAY_FROM AND  V_NGAY_TO)  
                          Or (v.gqd_ngayphathanhcv between V_NGAY_FROM AND  V_NGAY_TO))  -- Ngày giai quyet
                    ) a;

END GDT08_Export;

PROCEDURE GDT07_Export
(   V_ToaAnID	in	VARCHAR2,
    V_PhongbanID	in	VARCHAR2,
    V_LOAIAN_ID in  VARCHAR2,
    v_LOAIXULY in	VARCHAR2,
    V_NGAY_FROM	in date,
    V_NGAY_TO	in date,
    curReturn OUT sys_refcursor
)
IS 
    TotalItem number;MinIndex	number;MaxIndex	number;
    vdenngay date;
BEGIN
 SELECT DECODE(V_NGAY_TO,null,sysdate,to_date(to_char(V_NGAY_TO,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS')) into vdenngay from dual;
  --------------
  OPEN curReturn FOR
   select /*GSCM.PKG_VGDKT_BAOCAO.GDT07_Export */ a.* from (
      Select ROW_NUMBER() OVER (ORDER BY V.GDQ_SO asc) STT
       ,v.GDQ_SO SOTLD
       ,DECODE(to_char(v.GDQ_NGAY,'dd/MM/yyyy'),'01/01/0001','',to_char(v.GDQ_NGAY,'dd/MM/yyyy')) NGAYTLD
       ,Decode(NVL(V.loaian,0),1,'Hình sự',2,'Dân sự',5,'Lao động',3,'HNGD',4,'KDTM',6,'Hành chính','') LOAIAN
       ,DM_CanBo_TenToaVT(txx.Ma_Ten) DIAPHUONG 
       
       ,DECODE(v.BAQD_CAPXETXU,4,v.so_qdgdt,3,v.SOANPHUCTHAM,2,v.SOANSOTHAM,v.SOANPHUCTHAM) ||' '|| 
        DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')) infoBA
       ,DECODE(v.NGUYENDON,NULL,ND.NGUYENDON_ND,v.NGUYENDON) NGUYENDON
       ,decode(v.loaian,1,DECODE(v.BIDON,NULL,HSKN.BICAO,v.BIDON),DECODE(v.BIDON,NULL,BD.BIDON_BD,v.BIDON)) BIDON
       ,Decode(NVL(V.loaian,0),1,case when NguyenDon is not null then NVL(qhpl.TENQHPL, Replace(v.TenVuAn,(NguyenDon ||' - ')))
                                      when NguyenDon is null and BiDon is not null  then NVL(qhpl.TENQHPL, Replace(v.TenVuAn,(BiDon ||' - ')))
                                      end
                            , decode(Trim(v.QHPL_TEXT),null,qhpl.TENQHPL,v.QHPL_TEXT) )  as QHPLDN
       ,DD.LISTHULYDON infoThuLy
       ,DD.NGUOIGUI_HOTEN NGUOIKHIEUNAI
       ,DECODE(NVL(ttv.ID,0),0,'','TTV '||ttv.HOTEN)  ||' ' ||pb.TENPHONGBAN NOICHUYEN  
        from GDTTT_VUAN v 
               left join (select ID,MA_TEN from DM_TOAAN) txx on decode(v.BAQD_CAPXETXU,2, v.TOAANSOTHAM,3,v.TOAPHUCTHAMID,v.TOAQDID)=txx.ID
                left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
                left join DM_CANBO tp on v.THAMPHANID=tp.ID
                left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
                left join DM_CANBO ld on v.LANHDAOVUID=ld.ID
                left join DM_DataITem cv on ld.ChucVuID = cv.ID
                left join (select ID,TENPHONGBAN from DM_PHONGBAN) pb on v.PhongBanID=pb.ID
                left join DM_DAtaItem kq on kq.ID = v.XXGDTTT_KETQUAID
                ----lấy tên đương sự được khiếu nại --anhvh add 29/05/2021
                      LEFT JOIN (SELECT  KN.VUANID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  BICAO
                                FROM GDTTT_VUAN_DS_KN KN
                                LEFT JOIN GDTTT_VUAN_DUONGSU DS ON DS.ID=KN.BICAOID
                                LEFT JOIN GDTTT_VUAN_DUONGSU DSS ON DSS.ID=KN.NGUOIKHIEUNAIID
                                GROUP BY KN.VUANID
                            )HSKN ON HSKN.VUANID=V.ID
                     LEFT JOIN (SELECT  DS.VUANID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  NGUYENDON_ND
                                FROM GDTTT_VUAN_DUONGSU DS
                                WHERE DS.TUCACHTOTUNG='NGUYENDON' 
                                GROUP BY DS.VUANID
                        )ND ON ND.VUANID=V.ID     
                     LEFT JOIN (SELECT  DS.VUANID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  BIDON_BD
                                FROM GDTTT_VUAN_DUONGSU DS
                                WHERE DS.TUCACHTOTUNG='BIDON' 
                                GROUP BY DS.VUANID
                        )BD ON BD.VUANID=V.ID     
              --anhvh add 21/11/2019 check ngày của vụ và ngày công văn dùng cho việc truy vấn phí dưới
                LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                  WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                  WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                  END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
              --anhvh--án quốc hội gồm công văn 8.1 và 9.3
                LEFT JOIN (select D.VuViecID from GDTTT_DON d 
                         WHERE d.LOAICONGVAN in(Select I.ID from DM_DATAITEM I where (I.ID=546 OR I.CAPCHAID=546 OR I.ID = 1023 OR I.CAPCHAID=1023))
                         GROUP BY d.VuViecID)AQH ON AQH.VuViecID=V.ID
              ----
               ---lấy danh sách thụ lý đơn anhvh add 31/03/2020        
                LEFT JOIN (
                        SELECT CV.VUVIECID,LISTAGG(CASE WHEN LENGTH(NVL(CV.TL_SO, ''))>0 THEN (CV.TL_SO ) ELSE '' END
                                      || CASE WHEN LENGTH(NVL(CV.TL_NGAY, ''))>0 THEN ('  ' || TO_CHAR(CV.TL_NGAY,'dd/MM/yyyy') ) ELSE '' END                         
                                , '  ')
                                WITHIN GROUP (ORDER BY CV.TL_NGAY DESC, CV.NGAYTAO DESC) LISTHULYDON
                            ,LISTAGG(CV.NGUOIGUI_HOTEN,'; ')
                                WITHIN GROUP (ORDER BY CV.NGUOIGUI_HOTEN DESC) NGUOIGUI_HOTEN
                            FROM GDTTT_DON CV  
                            WHERE  CV.CD_TRANGTHAI=2 AND CV.ISTHULY=1
                            GROUP BY CV.VUVIECID
                        )DD ON DD.VUVIECID=v.ID
                        -----
              where  v.TOAANID=V_ToaAnID   
                    AND (V_LOAIAN_ID = 0 OR  NVL(v.LOAIAN,0) = to_number(V_LOAIAN_ID))
                    AND (V_PhongbanID=0 Or (V_PhongbanID>0 And v.PhongBanID=V_PhongbanID)) --Phong ban nhan
                    AND v.gqd_loaiketqua = 0 --Trả lơi đơn
                    AND NVL(v.truonghopthuly,0) not in (8,10) -- Khong phai Giai quyet khiếu nại tư pháp 
                    AND (v.GDQ_NGAY between V_NGAY_FROM AND  V_NGAY_TO)      -- Ngày giai quyet
                    ) a;

END GDT07_Export;

PROCEDURE GDT06_Export
(   V_ToaAnID	in	VARCHAR2,
    V_Donvi_KNID	in	VARCHAR2,
    V_LOAIAN_ID in  VARCHAR2,
    v_LOAIXULY in	VARCHAR2,
    V_NGAY_FROM	in date,
    V_NGAY_TO	in date,
    curReturn OUT sys_refcursor
)
IS 
    TotalItem number;MinIndex	number;MaxIndex	number;
    vdenngay date;
BEGIN
 SELECT DECODE(V_NGAY_TO,null,sysdate,to_date(to_char(V_NGAY_TO,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS')) into vdenngay from dual;
  --------------
  OPEN curReturn FOR
   select /*GSCM.PKG_VGDKT_BAOCAO.GDT06_Export */ a.* from (
      Select ROW_NUMBER() OVER (ORDER BY V.GDQ_NGAY desc) STT
        ,DECODE(v.ISVIENTRUONGKN,1,v.vientruongkn_so,v.GDQ_SO) SOKN
       ,DECODE(to_char(v.GDQ_NGAY,'dd/MM/yyyy'),'01/01/0001','',to_char(v.GDQ_NGAY,'dd/MM/yyyy')) NGAYKN
       ,Decode(NVL(V.loaian,0),1,'Hình sự',2,'Dân sự',5,'Lao động',3,'HNGD',4,'KDTM',6,'Hành chính','') LOAIAN
        ,DM_CanBo_TenToaVT(txx.Ma_Ten) DIAPHUONG 
       ,DECODE(v.BAQD_CAPXETXU,4,v.so_qdgdt,3,v.SOANPHUCTHAM,2,v.SOANSOTHAM,v.SOANPHUCTHAM) ||' '|| 
        DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')) infoBA
       ,DECODE(v.NGUYENDON,NULL,ND.NGUYENDON_ND,v.NGUYENDON) NGUYENDON
       ,decode(v.loaian,1,DECODE(v.BIDON,NULL,HSKN.BICAO,v.BIDON),DECODE(v.BIDON,NULL,BD.BIDON_BD,v.BIDON)) BIDON
       --, decode(Trim(v.QHPL_TEXT),null,qhpl.TENQHPL,v.QHPL_TEXT) QHPLDN
       ,Decode(NVL(V.loaian,0),1,case when NguyenDon is not null then NVL(qhpl.TENQHPL, Replace(v.TenVuAn,(NguyenDon ||' - ')))
                                      when NguyenDon is null and BiDon is not null  then NVL(qhpl.TENQHPL, Replace(v.TenVuAn,(BiDon ||' - ')))
                                      end
                            , decode(Trim(v.QHPL_TEXT),null,qhpl.TENQHPL,v.QHPL_TEXT) )  as QHPLDN
       ,v.SOTHULYXXGDT ||' '|| case when (Length(NVL(v.NGAYTHULYXXGDT,''))=0 or (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') ='01/01/0001')) then ''
                               when Length(NVL(v.NGAYTHULYXXGDT,'')) >0 then to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy')  end  THULYXXGDT
       ,v.XXGDTTT_SOQD||' '|| case when (Length(NVL(v.XXGDTTT_NGAYQD,''))=0 or (to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') ='01/01/0001')) then ''
                                       when Length(NVL(v.XXGDTTT_NGAYQD,'')) >0 then to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') end  XXGDTTT
       , NVL(kq.Ten,' ') KetQuaXXGDT   
       ,DECODE(NVL(ttv.ID,0),0,'','TTV '||ttv.HOTEN) ||' ' ||pb.TENPHONGBAN NOICHUYEN  
        from GDTTT_VUAN v 
                left join (select ID,MA_TEN from DM_TOAAN) txx on decode(v.BAQD_CAPXETXU,2, v.TOAANSOTHAM,3,v.TOAPHUCTHAMID,v.TOAQDID)=txx.ID
                left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
                left join DM_CANBO tp on v.THAMPHANID=tp.ID
                left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
                left join DM_CANBO ld on v.LANHDAOVUID=ld.ID
                left join DM_DataITem cv on ld.ChucVuID = cv.ID
                left join (select ID,TENPHONGBAN from DM_PHONGBAN) pb on v.PhongBanID=pb.ID
                left join DM_DAtaItem kq on kq.ID = v.XXGDTTT_KETQUAID
                ----lấy tên đương sự được khiếu nại --anhvh add 29/05/2021
                      LEFT JOIN (SELECT  KN.VUANID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  BICAO
                                FROM GDTTT_VUAN_DS_KN KN
                                LEFT JOIN GDTTT_VUAN_DUONGSU DS ON DS.ID=KN.BICAOID
                                LEFT JOIN GDTTT_VUAN_DUONGSU DSS ON DSS.ID=KN.NGUOIKHIEUNAIID
                                GROUP BY KN.VUANID
                            )HSKN ON HSKN.VUANID=V.ID
                     LEFT JOIN (SELECT  DS.VUANID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  NGUYENDON_ND
                                FROM GDTTT_VUAN_DUONGSU DS
                                WHERE DS.TUCACHTOTUNG='NGUYENDON' 
                                GROUP BY DS.VUANID
                        )ND ON ND.VUANID=V.ID     
                     LEFT JOIN (SELECT  DS.VUANID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  BIDON_BD
                                FROM GDTTT_VUAN_DUONGSU DS
                                WHERE DS.TUCACHTOTUNG='BIDON' 
                                GROUP BY DS.VUANID
                        )BD ON BD.VUANID=V.ID     
              --anhvh add 21/11/2019 check ngày của vụ và ngày công văn dùng cho việc truy vấn phí dưới
              LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                  WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                  WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                  END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
              --anhvh--án quốc hội gồm công văn 8.1 và 9.3
              LEFT JOIN (select D.VuViecID from GDTTT_DON d 
                         WHERE d.LOAICONGVAN in(Select I.ID from DM_DATAITEM I where (I.ID=546 OR I.CAPCHAID=546 OR I.ID = 1023 OR I.CAPCHAID=1023))
                         GROUP BY d.VuViecID)AQH ON AQH.VuViecID=V.ID
              ----
              where  v.TOAANID=V_ToaAnID   
                    --AND (V_PhongbanID=0 Or (V_PhongbanID>0 And v.PhongBanID=V_PhongbanID)) --Phong ban nhan
                    AND (V_LOAIAN_ID = 0 OR  NVL(v.LOAIAN,0) = to_number(V_LOAIAN_ID))
                    AND v.gqd_loaiketqua = 1 --khang nghị CA + VKS
                    AND (V_Donvi_KNID = '0' 
                                --VKS kháng nghị hoac CA TANDTC voi Cap cao
                                Or (V_Donvi_KNID not like '%/TA' and NVL(v.IsVienTruongKN,0) = 1 and NVL(v.THAMQUYENXXGDT,0) = V_Donvi_KNID) 
                                -- Chanh án Khang nghi 
                                Or (V_Donvi_KNID like '%/TA' and NVL(v.IsVienTruongKN,0) = 0) 
                         ) -- Don vi KN
                    AND NVL(v.truonghopthuly,0) not in (8,10) -- Khong phai Giai quyet khiếu nại tư pháp 
                    AND (v.GDQ_NGAY between V_NGAY_FROM AND  vdenngay)      -- Ngày thụ lý kháng nghị
                    AND (v_LOAIXULY = 0 
                          Or (v_LOAIXULY = 1 AND NVL(v.XXGDTTT_ISKETQUA,0)>0) -- Da xet xu GDT
                          Or  (v_LOAIXULY = 2 AND NVL(v.XXGDTTT_ISKETQUA,0)=0))  -- Chua xet xu GDT 
                    ) a;

END GDT06_Export;


PROCEDURE GDT05_Export
(   V_ToaAnID	in	VARCHAR2,
    V_PhongbanID	in	VARCHAR2,
    V_LOAIAN_ID in  VARCHAR2,
    v_LOAIXULY in	VARCHAR2,
    V_NGAY_FROM	in date,
    V_NGAY_TO	in date,
    curReturn OUT sys_refcursor
)
IS 
    TotalItem number;MinIndex	number;MaxIndex	number;
    vdenngay date;
BEGIN
 SELECT DECODE(V_NGAY_TO,null,sysdate,to_date(to_char(V_NGAY_TO,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS')) into vdenngay from dual;
  --------------
  OPEN curReturn FOR
   select /*GSCM.PKG_VGDKT_BAOCAO.GDT05_Export */ a.* from (
      Select ROW_NUMBER() OVER (ORDER BY d.NGAYTAO desc) STT
       ,vbd.SODEN SODONDEN
      ,DECODE(D.LOAIDON,4,to_char(d.NGAY_HSKN,'dd/MM/yyyy'),5,to_char(d.CV_NGAY,'dd/MM/yyyy'),to_char(d.NGAYGHITRENDON,'dd/MM/yyyy')) NGAYTRENDON
      ,DECODE(to_char(vbd.NGAY_BT,'dd/MM/yyyy'),'01/01/0001','',to_char(vbd.NGAY_BT,'dd/MM/yyyy')) NGAYTRENBI
      ,d.TL_SO ||' '|| DECODE(to_char(d.TL_NGAY,'dd/MM/yyyy'),'01/01/0001','',to_char(d.TL_NGAY,'dd/MM/yyyy')) INFOTHULY   
      ,d.NGUOIGUI_HOTEN NGUOIKHIEUNAI
     ,Decode(NVL(d.BAQD_LOAIAN,0),1,'Hình sự',2,'Dân sự',5,'Lao động',3,'HNGD',4,'KDTM',6,'Hành chính','') LOAIAN
      ,DM_CanBo_TenToaVT(txx.Ma_Ten) DIAPHUONG 
      ,(Case d.BAQD_LOAIQDBA When 1 then (d.KN_SOQD) Else decode(d.BAQD_CAPXETXU,2,(d.BAQD_SO_ST),3,(d.BAQD_SO_PT), (d.BAQD_SO)) END)
          ||' '||(Case d.BAQD_LOAIQDBA When 1 then to_char(d.KN_NGAY,'dd/MM/yyyy') Else decode(d.BAQD_CAPXETXU,2,to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy'),3,to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy'),to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')) END) info_BAQD_NGAYBA
       ,DECODE(NVL(d.BAQD_LOAIAN,0),1,bd.TENDUONGSU,nd.TENDUONGSU)||' ' ||d.NOIDUNGDON   info_VUVIEC  
       ,DECODE(NVL(va.TTVID,0),0,'','TTV '||va.HOTEN) ||' ' ||(case d.CD_LOAI when 0 then cast(pb.TENPHONGBAN as nvarchar2(250))
              when 1 then cast(tk.MA_TEN as nvarchar2(250)) when 2 then  cast(d.CD_NTA_TENDONVI as nvarchar2(250))
              end ) NOICHUYEN      
      , DECODE(va.GQD_LOAIKETQUA,3,decode(LENGTH(NVL(va.GDQ_SO,'')),0,va.GQD_KETQUA, 'TB số: '||va.GDQ_SO||' Ngày: '||to_char(va.GDQ_NGAY,'dd/MM/yyyy'))
                                , 2,'Xếp đơn '
                                , 1, 'Không chấp nhận khiếu nại '||decode(LENGTH(NVL(va.GDQ_SO,'')),0,va.GQD_KETQUA, va.GDQ_SO||'/'||to_char(va.GDQ_NGAY,'dd.MM.yyyy'))
                                , 0,'Chấp nhận khiếu nại '||decode(LENGTH(NVL(va.GDQ_SO,'')),0,va.GQD_KETQUA, va.GDQ_SO||'/'||to_char(va.GDQ_NGAY,'dd.MM.yyyy'))
                                ,'Đang giải quyết') KQ_GQD        
    from GDTTT_DON d 
        LEFT JOIN (select v.ID, v.GQD_LOAIKETQUA, v.GQD_KETQUA, v.GDQ_SO,v.GDQ_NGAY,v.GQD_NgayPhatHanhCV,v.XXGDTTT_SOQD,v.XXGDTTT_NGAYQD,ttv.HOTEN,ttv.ID TTVID
                                        from GDTTT_VuAn v 
                                        left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
                                                ) va on va.ID = d.VuViecID
        LEFT JOIN (
             SELECT LA.ID,LA.LOAI_AN_TEN FROM DM_LOAIAN LA ORDER BY LA.THUTU
             )LA ON LA.ID=D.BAQD_LOAIAN
     -----
        left join (select id,MA_TEN from DM_HANHCHINH) h on d.NGUOIGUI_HUYENID=h.ID
        left join (select id,MA_TEN from DM_HANHCHINH) hv on d.CV_HUYENID=hv.ID
        left join (select ID,MA_TEN from DM_TOAAN) tk on d.CD_TK_DONVIID=tk.ID
        left join (select ID,MA_TEN from DM_TOAAN) txx on decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID)=txx.ID
        left join (select ID,MA_TEN from DM_TOAAN) txxPT on d.BAQD_TOAANID_PT = txxPT.ID
        left join (select ID,MA_TEN from DM_TOAAN) txxST on d.BAQD_TOAANID_ST = txxST.ID
        left join (select ID,TENPHONGBAN from DM_PHONGBAN) pb on d.CD_TA_DONVIID=pb.ID
        left join (select ID,HOTEN from DM_CANBO) c on d.THAMPHANID=c.ID
        left join (select USERNAME,GHICHU from QT_NGUOISUDUNG) nsd on nsd.USERNAME=d.NGUOITAO
        left join (select id, TEN from DM_DATAITEM) i on d.NGUOIKHANGNGHI=i.ID
         ----van thu den anhvh 19/10/2020--    
            left join VT_CHUYEN_NHAN vt on vt.GDTTT_DON_ID=d.id
            LEFT JOIN VT_VANBANDEN vbd on vbd.id=vt.VANBANDEN_ID
            LEFT JOIN DM_TOAAN pbvt ON pbvt.ID=VT.DONVI_CHUYEN_ID
            LEFT JOIN DM_TOAAN TA ON TA.ID=vbd.TOAAN_BAQD_DON
             -------------------
            LEFT JOIN GDTTT_DON_DUONGSU_CC nd on nd.DONID = d.id and nd.TUCACHTOTUNG ='NGUYENDON'
            LEFT JOIN GDTTT_DON_DUONGSU_CC bd on bd.DONID = d.id and bd.TUCACHTOTUNG ='BIDON'
      where d.TOAANID=V_ToaAnID 
        AND (V_PhongbanID=0 Or (V_PhongbanID>0 And d.CD_TA_DONVIID=V_PhongbanID)) --Phong ban nhan
        AND d.CD_LOAI = 0 --Noi bo
        AND  d.CD_TA_TRANGTHAI = 0 -- Don du dieu kien
        AND (V_LOAIAN_ID=0
            OR(d.BAQD_LOAIAN=to_number(V_LOAIAN_ID) and V_LOAIAN_ID!=55 and V_LOAIAN_ID!=0)
            OR(V_LOAIAN_ID=55 AND d.BAQD_LOAIAN IS NULL)
          )   
        AND (d.NGAYXULYDON>=V_NGAY_FROM AND d.NGAYXULYDON<=vDenNgay)
        AND d.isthuly = 1 -- Don thu ly moi
        AND (   v_LOAIXULY = 0  -- Tất cả
                OR (v_LOAIXULY = 1 AND va.GQD_LOAIKETQUA in (0,1,2,3,4)) -- Đa co ket qua giai quyet
                OR (v_LOAIXULY = 2 AND NVL(va.GQD_LOAIKETQUA,5) = 5) -- Chua co ket qua
            )
         AND d.LOAIDON in (8,10) -- Loai: Đơn khiếu nại tư pháp
        
        ) a;

END GDT05_Export;

PROCEDURE GDT04_Export
(   V_ToaAnID	in	VARCHAR2,
    V_PhongbanID	in	VARCHAR2,
    V_LOAIAN_ID in  VARCHAR2,
    v_LOAIXULY in	VARCHAR2,
    V_NGAY_FROM	in date,
    V_NGAY_TO	in date,
    curReturn OUT sys_refcursor
)
IS 
    TotalItem number;MinIndex	number;MaxIndex	number;
    vdenngay date;
BEGIN
 SELECT DECODE(V_NGAY_TO,null,sysdate,to_date(to_char(V_NGAY_TO,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS')) into vdenngay from dual;
  --------------
  OPEN curReturn FOR
   select /*GSCM.PKG_VGDKT_BAOCAO.GDT04_Export */ a.* from (
      Select ROW_NUMBER() OVER (ORDER BY d.NGAYTAO desc) STT
      ,d.CV_SO||' ' || DECODE(to_char(d.CV_NGAY,'dd/MM/yyyy'),'01/01/0001','',to_char(d.CV_NGAY,'dd/MM/yyyy')) infoCV 
      ,d.CV_TENDONVI
      ,d.NGUOIGUI_HOTEN NGUOIGUIDON
      ,d.NOIDUNGDON NOIDUNGDENGHI
      ,Decode(NVL(d.BAQD_LOAIAN,0),1,'Hình sự',2,'Dân sự',5,'Lao động',3,'HNGD',4,'KDTM',6,'Hành chính','') LOAIAN
      ,Decode(d.CD_LOAI,4,'Xếp đơn',3,'Trả lại đơn',2,'Chuyển đơn',1,'Chuyển đơn','Thụ lý')  XULYDON
      , Decode (d.isthuly,1,'Thụ lý đơn số '||d.TL_SO|| ' ngày '|| to_char(d.TL_NGAY,'dd/MM/yyyy'),'Đơn trùng')  THULYDON
      , case when d.CD_LOAI= 0 and NVL(d.VuViecId, 0)>0
                  then case when NVL(va.GQD_LOAIKETQUA,5)=5 then 'Chưa giải quyết'
                            when NVL(va.GQD_LOAIKETQUA,5)<>5 
                              then (DECODE(NVL(va.GQD_LOAIKETQUA,5)
                                          , 4, 'VKS đang GQ'  
                                          , 3, 'Xử lý khác'                            
                                          , 2, u'X\1ebfp \0111\01a1n'
                                          , 1, u'Kh\00e1ng ngh\1ecb', 0,u'Tr\1ea3 l\1eddi \0111\01a1n' )

                                    || case when Length(NVL(va.GDQ_SO, ''))>0 then ' số '||va.GDQ_SO
                                            else '' end 
                                    || case when (Length(NVL(va.GDQ_NGAY,''))=0 
                                                  or (to_char(va.GDQ_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
                                            when Length(NVL(va.GDQ_NGAY,'')) >0 
                                                  then ' ngày ' || to_char(va.GDQ_NGAY,'dd/MM/yyyy') end 
                                    ) end                      
              else 'Chưa giải quyết' end  KQGQNoiBo
      ,DECODE(NVL(va.TTVID,0),0,'','TTV '||va.HOTEN) ||' ' ||(case d.CD_LOAI when 0 then cast(pb.TENPHONGBAN as nvarchar2(250))
              when 1 then cast(tk.MA_TEN as nvarchar2(250)) when 2 then  cast(d.CD_NTA_TENDONVI as nvarchar2(250))
              end ) NOICHUYEN

    from GDTTT_DON d 
        left join (select v.ID, v.GQD_LOAIKETQUA, v.GDQ_SO,v.GDQ_NGAY,v.XXGDTTT_SOQD,v.XXGDTTT_NGAYQD,ttv.HOTEN,ttv.ID TTVID
                                        from GDTTT_VuAn v 
                                        left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
                                                ) va on va.ID = d.VuViecID
        LEFT JOIN (
             SELECT LA.ID,LA.LOAI_AN_TEN FROM DM_LOAIAN LA ORDER BY LA.THUTU
             )LA ON LA.ID=D.BAQD_LOAIAN
     -----
        left join (select id,MA_TEN from DM_HANHCHINH) h on d.NGUOIGUI_HUYENID=h.ID
        left join (select id,MA_TEN from DM_HANHCHINH) hv on d.CV_HUYENID=hv.ID
        left join (select ID,MA_TEN from DM_TOAAN) tk on d.CD_TK_DONVIID=tk.ID
        left join (select ID,MA_TEN from DM_TOAAN) txx on decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID)=txx.ID
        left join (select ID,MA_TEN from DM_TOAAN) txxPT on d.BAQD_TOAANID_PT = txxPT.ID
        left join (select ID,MA_TEN from DM_TOAAN) txxST on d.BAQD_TOAANID_ST = txxST.ID
        left join (select ID,TENPHONGBAN from DM_PHONGBAN) pb on d.CD_TA_DONVIID=pb.ID
        left join (select ID,HOTEN from DM_CANBO) c on d.THAMPHANID=c.ID
        left join (select USERNAME,GHICHU from QT_NGUOISUDUNG) nsd on nsd.USERNAME=d.NGUOITAO
        left join (select id, TEN from DM_DATAITEM) i on d.NGUOIKHANGNGHI=i.ID
         ----van thu den anhvh 19/10/2020--    
            left join VT_CHUYEN_NHAN vt on vt.GDTTT_DON_ID=d.id
            LEFT JOIN VT_VANBANDEN vbd on vbd.id=vt.VANBANDEN_ID
            LEFT JOIN DM_TOAAN pbvt ON pbvt.ID=VT.DONVI_CHUYEN_ID
            LEFT JOIN DM_TOAAN TA ON TA.ID=vbd.TOAAN_BAQD_DON
             -------------------
            LEFT JOIN GDTTT_DON_DUONGSU_CC nd on nd.DONID = d.id and nd.TUCACHTOTUNG ='NGUYENDON'
            LEFT JOIN GDTTT_DON_DUONGSU_CC bd on bd.DONID = d.id and bd.TUCACHTOTUNG ='BIDON'
      where d.TOAANID=V_ToaAnID 
        AND (V_PhongbanID=0 Or (V_PhongbanID>0 And d.CD_TA_DONVIID=V_PhongbanID)) --Phong ban nhan
        --AND d.CD_LOAI = 0 --Noi bo
        AND  d.CD_TA_TRANGTHAI = 0 -- Don du dieu kien
        AND (V_LOAIAN_ID=0
            OR(d.BAQD_LOAIAN=to_number(V_LOAIAN_ID) and V_LOAIAN_ID!=55 and V_LOAIAN_ID!=0)
            OR(V_LOAIAN_ID=55 AND d.BAQD_LOAIAN IS NULL)
          )   
        AND (d.NGAYXULYDON>=V_NGAY_FROM AND d.NGAYXULYDON<=vDenNgay)
        AND d.isthuly = 1 -- Don thu ly moi
        AND (   v_LOAIXULY = 0  -- Tất cả
                OR (v_LOAIXULY = 1 AND va.GQD_LOAIKETQUA in (0,1,2,3,4)) -- Đa co ket qua giai quyet
                OR (v_LOAIXULY = 2 AND NVL(va.GQD_LOAIKETQUA,5) = 5) -- Chua co ket qua
            )
         AND d.LOAIDON in (3,31) -- Loai: Don+CV
          --án quốc hội gồm công văn 8.1 và 9.3
         AND d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
        ) a;

END GDT04_Export;

PROCEDURE GDT03_Export
(   V_ToaAnID	in	VARCHAR2,
    V_PhongbanID	in	VARCHAR2,
    V_LOAIAN_ID in  VARCHAR2,
    v_LOAIXULY in	VARCHAR2,
    V_NGAY_FROM	in date,
    V_NGAY_TO	in date,
    curReturn OUT sys_refcursor
)
IS 
    TotalItem number;MinIndex	number;MaxIndex	number;
    vdenngay date;
BEGIN
 SELECT DECODE(V_NGAY_TO,null,sysdate,to_date(to_char(V_NGAY_TO,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS')) into vdenngay from dual;
  --------------
  OPEN curReturn FOR
   select /*GSCM.PKG_VGDKT_BAOCAO.GDT03_Export */ a.* from (
      Select ROW_NUMBER() OVER (ORDER BY d.NGAYTAO desc) STT
      ,d.CV_SO
      ,DECODE(to_char(d.CV_NGAY,'dd/MM/yyyy'),'01/01/0001','',to_char(d.CV_NGAY,'dd/MM/yyyy')) CV_NGAY
      ,d.CV_TENDONVI 
      ,DM_CanBo_TenToaVT(txx.Ma_Ten) DIAPHUONG 
      ,(Case d.BAQD_LOAIQDBA When 1 then (d.KN_SOQD) Else decode(d.BAQD_CAPXETXU,2,(d.BAQD_SO_ST),3,(d.BAQD_SO_PT), (d.BAQD_SO)) END)||' '||(Case d.BAQD_LOAIQDBA When 1 then to_char(d.KN_NGAY,'dd/MM/yyyy') Else decode(d.BAQD_CAPXETXU,2,to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy'),3,to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy'),to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')) END) infoBAQD
      
      ,Decode(NVL(d.BAQD_LOAIAN,0),1,'Hình sự',2,'Dân sự',5,'Lao động',3,'HNGD',4,'KDTM',6,'Hành chính','') LOAIAN
      ,DECODE(NVL(d.BAQD_LOAIAN,0),1,bd.TENDUONGSU,nd.TENDUONGSU)   NGUYENDON
      ,DECODE(NVL(d.BAQD_LOAIAN,0),1,'',bd.TENDUONGSU)   BIDON
       ,DECODE(NVL(d.BAQD_LOAIAN,0),1,bd.HS_TenToiDanh,d.QHPL_TEXT) QUANHEPL
      ,d.NOIDUNGDON NOIDUNGDENGHI      
    , case when d.CD_LOAI= 0 and NVL(d.VuViecId, 0)>0
                  then case when NVL(va.GQD_LOAIKETQUA,5)=5 then 'Chưa giải quyết'
                            when NVL(va.GQD_LOAIKETQUA,5)<>5 
                              then (DECODE(NVL(va.GQD_LOAIKETQUA,5)
                                          , 4, 'VKS đang GQ'  
                                          , 3, 'Xử lý khác'                            
                                          , 2, u'X\1ebfp \0111\01a1n'
                                          , 1, u'Kh\00e1ng ngh\1ecb', 0,u'Tr\1ea3 l\1eddi \0111\01a1n' )

                                    || case when Length(NVL(va.GDQ_SO, ''))>0 then ' số '||va.GDQ_SO
                                            else '' end 
                                    || case when (Length(NVL(va.GDQ_NGAY,''))=0 
                                                  or (to_char(va.GDQ_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
                                            when Length(NVL(va.GDQ_NGAY,'')) >0 
                                                  then ' ngày ' || to_char(va.GDQ_NGAY,'dd/MM/yyyy') end 
                                    ) end                      
              else 'Chưa giải quyết' end  KQGQNoiBo
    , va.HOTEN as TENTHAMTRAVIEN
    from GDTTT_DON d 
        left join (select v.ID, v.GQD_LOAIKETQUA, v.GDQ_SO,v.GDQ_NGAY,v.XXGDTTT_SOQD,v.XXGDTTT_NGAYQD,ttv.HOTEN 
                                        from GDTTT_VuAn v 
                                        left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
                                                ) va on va.ID = d.VuViecID
        LEFT JOIN (
             SELECT LA.ID,LA.LOAI_AN_TEN FROM DM_LOAIAN LA ORDER BY LA.THUTU
             )LA ON LA.ID=D.BAQD_LOAIAN
     -----
        left join (select id,MA_TEN from DM_HANHCHINH) h on d.NGUOIGUI_HUYENID=h.ID
        left join (select id,MA_TEN from DM_HANHCHINH) hv on d.CV_HUYENID=hv.ID
        left join (select ID,MA_TEN from DM_TOAAN) tk on d.CD_TK_DONVIID=tk.ID
        left join (select ID,MA_TEN from DM_TOAAN) txx on decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID)=txx.ID
        left join (select ID,MA_TEN from DM_TOAAN) txxPT on d.BAQD_TOAANID_PT = txxPT.ID
        left join (select ID,MA_TEN from DM_TOAAN) txxST on d.BAQD_TOAANID_ST = txxST.ID
        left join (select ID,TENPHONGBAN from DM_PHONGBAN) pb on d.CD_TA_DONVIID=pb.ID
        left join (select ID,HOTEN from DM_CANBO) c on d.THAMPHANID=c.ID
        left join (select USERNAME,GHICHU from QT_NGUOISUDUNG) nsd on nsd.USERNAME=d.NGUOITAO
        left join (select id, TEN from DM_DATAITEM) i on d.NGUOIKHANGNGHI=i.ID
         ----van thu den anhvh 19/10/2020--    
            left join VT_CHUYEN_NHAN vt on vt.GDTTT_DON_ID=d.id
            LEFT JOIN VT_VANBANDEN vbd on vbd.id=vt.VANBANDEN_ID
            LEFT JOIN DM_TOAAN pbvt ON pbvt.ID=VT.DONVI_CHUYEN_ID
            LEFT JOIN DM_TOAAN TA ON TA.ID=vbd.TOAAN_BAQD_DON
             -------------------
            LEFT JOIN GDTTT_DON_DUONGSU_CC nd on nd.DONID = d.id and nd.TUCACHTOTUNG ='NGUYENDON'
            LEFT JOIN GDTTT_DON_DUONGSU_CC bd on bd.DONID = d.id and bd.TUCACHTOTUNG ='BIDON'
      where d.TOAANID=V_ToaAnID 
        AND (V_PhongbanID=0 Or (V_PhongbanID>0 And d.CD_TA_DONVIID=V_PhongbanID)) --Phong ban nhan
        AND d.CD_LOAI = 0 --Noi bo
        AND  d.CD_TA_TRANGTHAI = 0 -- Don du dieu kien
        AND (V_LOAIAN_ID=0
            OR(d.BAQD_LOAIAN=to_number(V_LOAIAN_ID) and V_LOAIAN_ID!=55 and V_LOAIAN_ID!=0)
            OR(V_LOAIAN_ID=55 AND d.BAQD_LOAIAN IS NULL)
          )   
        AND (d.NGAYXULYDON>=V_NGAY_FROM AND d.NGAYXULYDON<=vDenNgay)
        AND d.isthuly = 1 -- Don thu ly moi
        AND (   v_LOAIXULY = 0  -- Tất cả
                OR (v_LOAIXULY = 1 AND va.GQD_LOAIKETQUA in (0,1,2,3,4)) -- Đa co ket qua giai quyet
                OR (v_LOAIXULY = 2 AND NVL(va.GQD_LOAIKETQUA,5) = 5) -- Chua co ket qua
            )
         AND d.LOAIDON in (6,9) -- Loai: Công văn kiến nghị, CV kiến nghị + hồ sơ
        
        ) a;

END GDT03_Export;

PROCEDURE GDT02_Export
(   V_ToaAnID	in	VARCHAR2,
    V_PhongbanID	in	VARCHAR2,
    V_LOAIGDT	in	VARCHAR2,
    V_LOAIAN_ID in  VARCHAR2,
    v_LOAIXULY in	VARCHAR2,
    V_NGAY_FROM	in date,
    V_NGAY_TO	in date,
    curReturn OUT sys_refcursor
)
IS 
    TotalItem number;MinIndex	number;MaxIndex	number;
    vdenngay date;
BEGIN
 SELECT DECODE(V_NGAY_TO,null,sysdate,to_date(to_char(V_NGAY_TO,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS')) into vdenngay from dual;
  --------------
  OPEN curReturn FOR
   select /*GSCM.PKG_VGDKT_BAOCAO.GDT02_Export */ a.* from (
      Select ROW_NUMBER() OVER (ORDER BY d.TL_NGAY desc) STT
      ,Decode(NVL(d.BAQD_LOAIAN,0),1,'Hình sự',2,'Dân sự',5,'Lao động',3,'HNGD',4,'KDTM',6,'Hành chính','') LOAIAN
      ,decode(vbd.NGUON_DEN,1,'Bưu điện',2,'Tiếp công dân','Trực tiếp') NGUONDON
      ,d.TL_SO SOTHULY
      ,DECODE(to_char(d.TL_NGAY,'dd/MM/yyyy'),'01/01/0001','',to_char(d.TL_NGAY,'dd/MM/yyyy')) NGAYTHULY
       ,vbd.SODEN SODONDEN
       ,DECODE(to_char(d.NGAYNHANDON,'dd/MM/yyyy'),'01/01/0001','',to_char(d.NGAYNHANDON,'dd/MM/yyyy')) NGAYNHANDON
      ,DECODE(to_char(vbd.NGAY_BT,'dd/MM/yyyy'),'01/01/0001','',to_char(vbd.NGAY_BT,'dd/MM/yyyy')) NGAYTRENBI
      ,DM_CanBo_TenToaVT(txx.Ma_Ten) DIAPHUONG 
      ,(Case d.BAQD_LOAIQDBA When 1 then (d.KN_SOQD) Else decode(d.BAQD_CAPXETXU,2,(d.BAQD_SO_ST),3,(d.BAQD_SO_PT), (d.BAQD_SO)) END) BAQD
      ,(Case d.BAQD_LOAIQDBA When 1 then to_char(d.KN_NGAY,'dd/MM/yyyy') Else decode(d.BAQD_CAPXETXU,2,to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy'),3,to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy'),to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')) END) BAQD_NGAYBA
       ,DECODE(NVL(d.BAQD_LOAIAN,0),1,bd.TENDUONGSU,nd.TENDUONGSU)   NGUYENDON
      ,DECODE(NVL(d.BAQD_LOAIAN,0),1,'',bd.TENDUONGSU)   BIDON
       ,DECODE(NVL(d.BAQD_LOAIAN,0),1,bd.HS_TenToiDanh,d.QHPL_TEXT) QUANHEPL
      ,d.NGUOIGUI_HOTEN NGUOIKHIEUNAI
    ,(case d.CD_LOAI when 0 then cast(pb.TENPHONGBAN as nvarchar2(250))
              when 1 then cast(tk.MA_TEN as nvarchar2(250)) when 2 then  cast(d.CD_NTA_TENDONVI as nvarchar2(250))
              end ) NOICHUYEN
    , case when d.CD_LOAI= 0 and NVL(d.VuViecId, 0)>0
                  then case when NVL(va.GQD_LOAIKETQUA,5)=5 then 'Chưa giải quyết'
                            when NVL(va.GQD_LOAIKETQUA,5)<>5 
                              then (DECODE(NVL(va.GQD_LOAIKETQUA,5)
                                          , 4, 'VKS đang GQ'  
                                          , 3, 'Xử lý khác'                            
                                          , 2, u'X\1ebfp \0111\01a1n'
                                          , 1, u'Kh\00e1ng ngh\1ecb', 0,u'Tr\1ea3 l\1eddi \0111\01a1n' )

                                    || case when Length(NVL(va.GDQ_SO, ''))>0 then ' số '||va.GDQ_SO
                                            else '' end 
                                    || case when (Length(NVL(va.GDQ_NGAY,''))=0 
                                                  or (to_char(va.GDQ_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
                                            when Length(NVL(va.GDQ_NGAY,'')) >0 
                                                  then ' ngày ' || to_char(DECODE(va.GQD_LOAIKETQUA,3,va.GQD_NGAYPHATHANHCV,va.GDQ_NGAY),'dd/MM/yyyy') end 
                                    ) end                      
              else 'Chưa giải quyết' end  KQGQNoiBo
    ,'' GHICHU
    from GDTTT_DON d 
        left join (select ID, GQD_LOAIKETQUA, GDQ_SO,GDQ_NGAY,GQD_NGAYPHATHANHCV,XXGDTTT_SOQD,XXGDTTT_NGAYQD from GDTTT_VuAn) va on va.ID = d.VuViecID
        LEFT JOIN (
             SELECT LA.ID,LA.LOAI_AN_TEN FROM DM_LOAIAN LA ORDER BY LA.THUTU
             )LA ON LA.ID=D.BAQD_LOAIAN
     -----
        left join (select id,MA_TEN from DM_HANHCHINH) h on d.NGUOIGUI_HUYENID=h.ID
        left join (select id,MA_TEN from DM_HANHCHINH) hv on d.CV_HUYENID=hv.ID
        left join (select ID,MA_TEN from DM_TOAAN) tk on d.CD_TK_DONVIID=tk.ID
        left join (select ID,MA_TEN from DM_TOAAN) txx on decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID)=txx.ID
        left join (select ID,MA_TEN from DM_TOAAN) txxPT on d.BAQD_TOAANID_PT = txxPT.ID
        left join (select ID,MA_TEN from DM_TOAAN) txxST on d.BAQD_TOAANID_ST = txxST.ID
        left join (select ID,TENPHONGBAN from DM_PHONGBAN) pb on d.CD_TA_DONVIID=pb.ID
        left join (select ID,HOTEN from DM_CANBO) c on d.THAMPHANID=c.ID
        left join (select USERNAME,GHICHU from QT_NGUOISUDUNG) nsd on nsd.USERNAME=d.NGUOITAO
        left join (select id, TEN from DM_DATAITEM) i on d.NGUOIKHANGNGHI=i.ID
         ----van thu den anhvh 19/10/2020--    
            left join VT_CHUYEN_NHAN vt on vt.GDTTT_DON_ID=d.id
            LEFT JOIN VT_VANBANDEN vbd on vbd.id=vt.VANBANDEN_ID
            LEFT JOIN DM_TOAAN pbvt ON pbvt.ID=VT.DONVI_CHUYEN_ID
            LEFT JOIN DM_TOAAN TA ON TA.ID=vbd.TOAAN_BAQD_DON
             -------------------
            LEFT JOIN GDTTT_DON_DUONGSU_CC nd on nd.DONID = d.id and nd.TUCACHTOTUNG ='NGUYENDON'
            LEFT JOIN GDTTT_DON_DUONGSU_CC bd on bd.DONID = d.id and bd.TUCACHTOTUNG ='BIDON'
      where d.TOAANID=V_ToaAnID 
        AND (V_PhongbanID=0 Or (V_PhongbanID>0 And d.CD_TA_DONVIID=V_PhongbanID)) --Phong ban nhan
        AND d.CD_LOAI = 0 --Noi bo
        AND  d.CD_TA_TRANGTHAI = 0 -- Don du dieu kien
        AND (V_LOAIAN_ID=0
            OR(d.BAQD_LOAIAN=to_number(V_LOAIAN_ID) and V_LOAIAN_ID!=55 and V_LOAIAN_ID!=0)
            OR(V_LOAIAN_ID=55 AND d.BAQD_LOAIAN IS NULL)
          )   
 
        AND d.TL_NGAY between V_NGAY_FROM and vDenNgay
        AND d.isthuly = 1 -- Don thu ly moi
        AND (   v_LOAIXULY = 0  -- Tất cả
                OR (v_LOAIXULY = 1 AND va.GQD_LOAIKETQUA in (0,1,2,3,4)) -- Đa co ket qua giai quyet
                OR (v_LOAIXULY = 2 AND NVL(va.GQD_LOAIKETQUA,5) = 5) -- Chua co ket qua
            )
        AND (V_LOAIGDT=0 OR d.LOAI_GDTTTT= V_LOAIGDT)
        AND d.LOAIDON in (1,3,31) -- Loai: Don, Don+CV       
        ) a;

END GDT02_Export;

PROCEDURE GDT01_Export
(   V_ToaAnID	in	VARCHAR2,
    V_LOAIAN_ID in  VARCHAR2,
    v_LOAIXULY in	VARCHAR2,
    V_NGAY_FROM	in date,
    V_NGAY_TO	in date,
    curReturn OUT sys_refcursor
)
IS 
    TotalItem number;MinIndex	number;MaxIndex	number;
    vdenngay date;
BEGIN
 SELECT DECODE(V_NGAY_TO,null,sysdate,to_date(to_char(V_NGAY_TO,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS')) into vdenngay from dual;
  --------------
  OPEN curReturn FOR
   select /*GSCM.PKG_VGDKT_BAOCAO.GDT01_Export */ a.* from (
      Select ROW_NUMBER() OVER (ORDER BY d.NGAYTAO desc) STT
      ,Decode(NVL(d.BAQD_LOAIAN,0),1,'Hình sự',2,'Dân sự',5,'Lao động',3,'HNGD',4,'KDTM',6,'Hành chính','') LOAIAN
      ,decode(vbd.NGUON_DEN,1,'Bưu điện',2,'Tiếp công dân','Trực tiếp') NGUONDON
      ,'' SOTHULY
      ,'' NGAYTHULY
      ,vbd.SODEN SODONDEN
      ,DECODE(to_char(d.NGAYNHANDON,'dd/MM/yyyy'),'01/01/0001','',to_char(d.NGAYNHANDON,'dd/MM/yyyy')) NGAYNHANDON
      ,DECODE(to_char(vbd.NGAY_BT,'dd/MM/yyyy'),'01/01/0001','',to_char(vbd.NGAY_BT,'dd/MM/yyyy')) NGAYTRENBI
      ,DM_CanBo_TenToaVT(txx.Ma_Ten) DIAPHUONG 
      ,(Case d.BAQD_LOAIQDBA When 1 then (d.KN_SOQD) Else decode(d.BAQD_CAPXETXU,2,(d.BAQD_SO_ST),3,(d.BAQD_SO_PT), (d.BAQD_SO)) END) BAQD
      ,(Case d.BAQD_LOAIQDBA When 1 then to_char(d.KN_NGAY,'dd/MM/yyyy') 
                            Else decode(d.BAQD_CAPXETXU,2,to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy'),3,to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy'),to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')) 
                            END) BAQD_NGAYBA
       ,DECODE(NVL(d.BAQD_LOAIAN,0),1,bd.TENDUONGSU,nd.TENDUONGSU)   NGUYENDON
     ,DECODE(NVL(d.BAQD_LOAIAN,0),1,'',bd.TENDUONGSU)   BIDON
      ,DECODE(NVL(d.BAQD_LOAIAN,0),1,bd.HS_TenToiDanh,d.QHPL_TEXT) QUANHEPL
      ,d.NGUOIGUI_HOTEN NGUOIKHIEUNAI
    ,(case d.CD_LOAI when 0 then cast(pb.TENPHONGBAN as nvarchar2(250))
              when 1 then cast(tk.MA_TEN as nvarchar2(250)) when 2 then  cast(d.CD_NTA_TENDONVI as nvarchar2(250))
              end ) NOICHUYEN
    ,(case d.CD_LOAI when 0 then DECODE(NVL(CD_TA_TRANGTHAI,0),0,cast('Đơn trùng' as nvarchar2(250)),cast('Đơn yêu cầu bổ sung' as nvarchar2(250)))
              when 1 then cast('Chuyển đơn' as nvarchar2(250)) when 2 then  cast('Chuyển đơn' as nvarchar2(250))
              when 3 then  cast('Trả lại đơn' as nvarchar2(250)) when 4 then  cast('Xếp đơn' as nvarchar2(250))  end ) GHICHU
    from GDTTT_DON d    
        LEFT JOIN (
                 SELECT LA.ID,LA.LOAI_AN_TEN FROM DM_LOAIAN LA ORDER BY LA.THUTU
                 )LA ON LA.ID=D.BAQD_LOAIAN
     -----
        left join (select id,MA_TEN from DM_HANHCHINH) h on d.NGUOIGUI_HUYENID=h.ID
        left join (select id,MA_TEN from DM_HANHCHINH) hv on d.CV_HUYENID=hv.ID
        left join (select ID,MA_TEN from DM_TOAAN) tk on d.CD_TK_DONVIID=tk.ID
        left join (select ID,MA_TEN from DM_TOAAN) txx on decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID)=txx.ID
        left join (select ID,MA_TEN from DM_TOAAN) txxPT on d.BAQD_TOAANID_PT = txxPT.ID
        left join (select ID,MA_TEN from DM_TOAAN) txxST on d.BAQD_TOAANID_ST = txxST.ID
        left join (select ID,TENPHONGBAN from DM_PHONGBAN) pb on d.CD_TA_DONVIID=pb.ID
        left join (select ID,HOTEN from DM_CANBO) c on d.THAMPHANID=c.ID
        left join (select USERNAME,GHICHU from QT_NGUOISUDUNG) nsd on nsd.USERNAME=d.NGUOITAO
        left join (select id, TEN from DM_DATAITEM) i on d.NGUOIKHANGNGHI=i.ID
         ----van thu den anhvh 19/10/2020--    
            left join VT_CHUYEN_NHAN vt on vt.GDTTT_DON_ID=d.id
            LEFT JOIN VT_VANBANDEN vbd on vbd.id=vt.VANBANDEN_ID
            LEFT JOIN DM_TOAAN pbvt ON pbvt.ID=VT.DONVI_CHUYEN_ID
            LEFT JOIN DM_TOAAN TA ON TA.ID=vbd.TOAAN_BAQD_DON
             -------------------
            LEFT JOIN GDTTT_DON_DUONGSU_CC nd on nd.DONID = d.id and nd.TUCACHTOTUNG ='NGUYENDON'
            LEFT JOIN GDTTT_DON_DUONGSU_CC bd on bd.DONID = d.id and bd.TUCACHTOTUNG ='BIDON'
      where d.TOAANID=V_ToaAnID 
        AND (V_LOAIAN_ID=0
            OR(d.BAQD_LOAIAN=to_number(V_LOAIAN_ID) and V_LOAIAN_ID!=55 and V_LOAIAN_ID!=0)
            OR(V_LOAIAN_ID=55 AND d.BAQD_LOAIAN IS NULL)
          )   
        AND (d.NGAYXULYDON>=V_NGAY_FROM AND d.NGAYXULYDON<=vDenNgay)
        AND (   v_LOAIXULY = 0  -- Tất cả
                OR (v_LOAIXULY = 1 AND d.CD_LOAI = 0 AND  d.CD_TA_TRANGTHAI = 1) -- Đơn yêu cầu bổ sung
                OR (v_LOAIXULY = 5 AND d.CD_LOAI in (1,2)) -- Chuyển đơn
                OR (v_LOAIXULY = 3 AND d.CD_LOAI in (3)) -- Trả lại đơn
                OR (v_LOAIXULY = 2 AND d.CD_LOAI in (0) AND d.isthuly = 2) -- Đơn trùng
                OR (v_LOAIXULY = 4 AND d.CD_LOAI in (4)) -- Xếp đơn
            )
        AND d.LOAIDON in (1,11,3,31) -- Loai: Don va Don+CV
        
        ) a;

END GDT01_Export;


FUNCTION  GDTTTT_VUAN_SEARCH_BC1
( 
  V_CONLAI_ in varchar2,
  v_colume  in varchar2,
  v_asc_desc in varchar2,
  vToaAnID in number,
  vPhongBanID  in number,
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in varchar2,
  vNguoiGui in varchar2,
  vCoquanchuyendon in varchar2,
  vNguyendon in varchar2,
  vBidon in varchar2,
  vLoaiAn in number,
  vThamtravien in number,
  vLanhdao in number,
  vThamphan in number,
  vQHPLID in number,
  vQHPLDNID in number,
  vTraloidon in varchar2,
  vLoaiCVID in number,
  vNgayThulyTu in date,
  vNgayThulyDen in date,
  vSoThuly in varchar2, 

  vTrangthai in number,
  vCapTrinhTiep in number,
  vIsDangKyBC in number,

  vKetquathuly in number,
  vKetquaxetxu in number,  

  isTTMuonHS in number,
  isTTToTrinh in number,
  isTTYKienKLTotrinh in number,
  isBuocTT in number,
  LoaiAnDB in number,
  vLoaiAnDB_TH in varchar2,
  IsHoanTHA in number,
  vTypeTB in number,
  vTypeHDTP in number,
  v_ISXINANGIAM in number,
  v_GDT_ISXINANGIAM in number,
  PageIndex	in	int,
  PageSize	in	int
)
RETURN SYS_REFCURSOR
IS 
  TotalItem number;  MinIndex	number;  MaxIndex	number;vvvNgayThulyTu date;vvvNgayThulyDen date;
  vvngaythulyden date;vvloaian VARCHAR2(150);vvLoaidon number;
  temp_sobanan nvarchar2(50);
  ----------------------
  V_CURSOR sys_refcursor;V_EXPORT_TEXT CLOB;V_EXPORT_TEXT_ITEM CLOB;CountAll_S number:=0;vvKetquathuly varchar2(250);vLoaiAn_name varchar2(250);V_BIDON_CHECK varchar2(250);
  ----------------------
  v_table_tp T_TINHTRANG; curr_thamphan_id number:=0;ma_chucvu varchar2(10); vTrangthai_s varchar2(150);
  LOAIAN_ID VARCHAR2(150);LOAIAN_TEN VARCHAR2(150);VUANID NUMBER;LANHDAOID NUMBER;TINHTRANGID NUMBER;NGAYTRA DATE; TOTRINH_ID NUMBER;NGAYTRINH DATE;ISCAPTRINHTIEP NUMBER;THUTU_CAPTRINH NUMBER;
  -----------------------
  v_table_all T_TINHTRANG; vNgayThulyDen_all date;
  LOAIAN_ID_ALL VARCHAR2(150);LOAIAN_TEN_ALL VARCHAR2(150);VUANID_ALL NUMBER;LANHDAOID_ALL NUMBER;TINHTRANGID_ALL NUMBER;NGAYTRA_ALL DATE; TOTRINH_ID_ALL NUMBER;NGAYTRINH_ALL DATE;ISCAPTRINHTIEP_ALL NUMBER;THUTU_CAPTRINH_ALL NUMBER;
  ----------------
   vvTuNgay date;vvDenNgay date;
    v_ghichu  varchar2(2000);
   v_check_kq number;
   v_check_tt number;
   v_check_hs number;
BEGIN
   DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT_ITEM,true);
    -----
  SELECT DECODE(vngaythulyden,null,sysdate,to_date(to_char(vngaythulyden,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS')) into vvngaythulyden from dual;
  -- vvTuNgay:=to_date('01/01/2019 00:00:00','dd/MM/yyyy  hh24:mi:ss');vvDenNgay:=to_date('31/12/2019 23:59:59','dd/MM/yyyy  hh24:mi:ss');
  v_table_tp := T_TINHTRANG();  v_table_all := T_TINHTRANG(); 
  -------------------------
  if(vThamphan !=0 and vThamphan is not null) then
          select b.Ma  into ma_chucvu  from DM_CanBo a left join DM_DataItem b on a.ChucVuID = b.ID where a.Id = vThamphan;
           if  (ma_chucvu='PCA' OR ma_chucvu='CA')then 
               curr_thamphan_id:=0;
                 ---------lấy loại án khi thẩm phán chọn ô tổng (nghĩa là không xác định được loại án) của form login sẽ lấy những loại án theo năm truyền vào
                       SELECT  LISTAGG(TTS.LOAIAN_ID, ',') WITHIN GROUP (ORDER BY TTS.LOAIAN_ID) INTO vvloaian  FROM (
                                    SELECT LA.LOAIAN_ID,LA.LOAIAN_TEN FROM  (
                                    SELECT DECODE(TT.COL_LOAIAN,'ISHINHSU',1,'ISDANSU',2,'ISHNGD',3,'ISKDTM',4,'ISLAODONG',5,'ISHANHCHINH',6)LOAIAN_ID,
                                    DECODE(TT.COL_LOAIAN,'ISHINHSU','HÌNH SỰ','ISDANSU','DÂN SỰ','ISHNGD','HÔN NHÂN VÀ GIA ĐÌNH','ISKDTM','KINH DOANH, THƯƠNG MẠI','ISLAODONG','LAO ĐỘNG','ISHANHCHINH','HÀNH CHÍNH')LOAIAN_TEN
                                    FROM (
                                            SELECT * FROM (SELECT PB.ISHINHSU,PB.ISDANSU, PB.ISHNGD,PB.ISKDTM,PB.ISHANHCHINH,PB.ISLAODONG FROM DM_CanBo 
                                            PB WHERE PB.Id = vThamphan
                                         )
                                    UNPIVOT --chuyển từ cột thành dòng
                                    (CHECK_LOAIAN for COL_LOAIAN in (ISHINHSU, ISDANSU, ISHNGD, ISKDTM,ISHANHCHINH,ISLAODONG) )
                                    )TT WHERE CHECK_LOAIAN=1 
                                )LA   WHERE LA.LOAIAN_ID IS NOT NULL  
                               GROUP BY LA.LOAIAN_ID,LA.LOAIAN_TEN 
                 )TTS;
                       -----------------------------------------------
            ELSE
                curr_thamphan_id:= vThamphan;
            end if;
      else
      curr_thamphan_id:=0;
  end if;
         -----Bao cao TTP,HDTP,CA,PCA---------------
         IF(vTrangthai=-1)THEN
            vTrangthai_s:='7,8,9,17';
         ELSE
         vTrangthai_s:=vTrangthai;
         END IF;
         ------------------------
  if (vSoBAQD || ' ') <> ' ' then  
    temp_sobanan := Replace(Replace(Replace(lower(vSoBAQD), ' ', ''), '_',''), '-','');
  else 
    temp_sobanan := vSoBAQD;
  end if;
    -----Thẩm phán---------------
        IF(vPhongBanID=0) THEN
               PKG_GDTTT_BAOCAO_APP.GDTTTT_QLTOTRINH_TP(
                                              vThamphan,vToaAnID,0,vLoaiAn,--vThamphanID,vToaAnID,vPhongBanID,vLoaiAn
                                              null,vNgayThulyDen,--tt_tungay,tt_denngay
                                              V_CURSOR);
                  LOOP 
                  FETCH V_CURSOR 
                        INTO   LOAIAN_ID,LOAIAN_TEN,VUANID,LANHDAOID,TINHTRANGID,NGAYTRA,TOTRINH_ID,NGAYTRINH,ISCAPTRINHTIEP,THUTU_CAPTRINH;
                        EXIT WHEN V_CURSOR%NOTFOUND;
                         v_table_tp.extend;
                         v_table_tp(v_table_tp.count) := R_TINHTRANG(
                                     LOAIAN_ID,LOAIAN_TEN,VUANID,LANHDAOID,TINHTRANGID,NGAYTRA,TOTRINH_ID,NGAYTRINH,ISCAPTRINHTIEP,THUTU_CAPTRINH
                                    );
                  END LOOP;    
                  CLOSE V_CURSOR;  
         END IF;
       ----------------------------------------tạo du lieu cac cap trinh chuyển vào bảng 
                  PKG_GDTTT_BAOCAO_APP.GDTTTT_QLTOTRINH_ALL(
                                  vToaAnID,vPhongBanID,vLoaiAn,--vToaAnID,vPhongBanID,vLoaiAn
                                  null,vNgayThulyDen,--tt_tungay,tt_denngayto_date
                                  V_CURSOR);
                  LOOP 
                  FETCH V_CURSOR 
                       INTO   LOAIAN_ID_ALL,LOAIAN_TEN_ALL,VUANID_ALL,LANHDAOID_ALL,TINHTRANGID_ALL,NGAYTRA_ALL,TOTRINH_ID_ALL,NGAYTRINH_ALL,ISCAPTRINHTIEP_ALL,THUTU_CAPTRINH_ALL;
                        EXIT WHEN V_CURSOR%NOTFOUND;
                         v_table_all.extend;
                         v_table_all(v_table_all.count) := R_TINHTRANG(
                                     LOAIAN_ID_ALL,LOAIAN_TEN_ALL,VUANID_ALL,LANHDAOID_ALL,TINHTRANGID_ALL,NGAYTRA_ALL,TOTRINH_ID_ALL,NGAYTRINH_ALL,ISCAPTRINHTIEP_ALL,THUTU_CAPTRINH_ALL
                                    );
                  END LOOP;    
                  CLOSE V_CURSOR;  
       ---------------------------------
   FOR item IN (
        WITH HD1 as (select hd.VUANID,DECODE(hd.TYPEHD,1,'<br/><span style="">Hội đồng: <b> Toàn thể</b></span>',2,'<br/><span style="">Hội đồng: <b> 5</b></span>','')HOIDONGXX from GDTTT_VUAN_XXGDTT_HOIDONG hd GROUP BY hd.VUANID, hd.TYPEHD)
          ,HD2 as (select hd.VUANID,DECODE(hd.TENCANBO,NULL,NULL,'<br/><span style="">Chủ tọa: <b>'||hd.TENCANBO||'</b></span>')TEN_CHUTOA,hd.CANBOID from GDTTT_VUAN_XXGDTT_HOIDONG hd WHERE hd.ISCHUTOA=1)
          select a.* ,'' arrDONID , '' arrCV81ID   , '' arrCHIDAOID
                    from (
                    Select  COUNT(1) OVER () as CountAll,
                    ROW_NUMBER() OVER (ORDER BY CASE WHEN V_ASC_DESC = 'ASC' AND V_COLUME = 'NGAYTHULYDON' THEN V.NGAYTHULYDON END, CASE WHEN V_ASC_DESC = 'DESC' AND V_COLUME = 'NGAYTHULYDON' THEN V.NGAYTHULYDON END DESC,CASE WHEN V_ASC_DESC = 'ASC' AND V_COLUME = 'TENTHAMTRAVIEN' THEN ttv.HOTEN END,CASE WHEN V_ASC_DESC = 'DESC' AND V_COLUME = 'TENTHAMTRAVIEN' THEN ttv.HOTEN END DESC
                                      ) STT   
                      ,DECODE(v.TongDon,NULL,'','<br/>Số đơn '||v.TongDon) as TongDon 
                      ,dECODE(AQH.VuViecID,NULL,null,'<br/>Án quốc hội')SoCV81--NVL(v.IsAnQuocHoi, 0) as SoCV81,'
                      ,DECODE(v.IsAnChiDao,'NULL','','0','','<br/>Án chỉ đạo ') as IsAnChiDao 
                      ,DECODE(AQH_F.VuViecID,NULL,NULL,'X')CV93
                       , v.ID, v.LoaiAn,v.MAVUAN,DD.LISTHULYDON  
                        ,(select count(id) from gdttt_don d where d.VUVIECID = v.id and d.isthuly= 1 and CD_TRANGTHAI = 2) cThulymoi
                       , v.SOTHULYDON,to_char(v.NGAYTHULYDON,'dd/MM/yyyy')NGAYTHULYDON , v.NGUYENDON,v.BIDON
                       ,DECODE(v.TRUONGHOPTHULY,1,'<b>Kháng nghị của VKS</b>',2,'<b>Rút Hồ sơ đoàn kiểm tra</b>',3,'<b>Chủ động GĐT qua Bản án</b>',NVL(v.ARRNGUOIKHIEUNAI,v.NGUOIKHIEUNAI)) NGUOIKHIEUNAI
                        ,DECODE(v.BAQD_CAPXETXU,4,v.so_qdgdt,3,v.SOANPHUCTHAM,2,v.SOANSOTHAM,v.SOANPHUCTHAM) SOANPHUCTHAM
                        ,DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')) NGAYXUPHUCTHAM
                        ,DECODE(v.BAQD_CAPXETXU,4,DM_CanBo_TenToaVT(tqd.Ma_Ten),2,DM_CanBo_TenToaVT(tst.Ma_Ten),DM_CanBo_TenToaVT(txx.Ma_Ten)) TOAXX_VietTat
                        ,DECODE(v.BAQD_CAPXETXU,4,tqd.Ma_Ten,2,tst.Ma_Ten,txx.Ma_Ten) ToaXX
                 --manhnd
                      , case when BAQD_CAPXETXU = 4 
                                        then NVL(v.SO_QDGDT, NVL(v.SO_QDGDT, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NGAYQD,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYQD,'dd/MM/yyyy'))||
                                             '<br/>'|| DM_CanBo_TenToaVT(tqd.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-GĐT)</i>'||
                                              decode (v.SOANPHUCTHAM,null,'',' ','','<br/><br/>'||v.SOANPHUCTHAM||'<br/>'||to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')||
                                                        '<br/>'||DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>')||
                                              decode (v.SoAnSoTham,null,'',' ','','<br/>'||v.SoAnSoTham||'<br/>'||to_char(v.NgayXuSoTham,'dd/MM/yyyy')||
                                                    '<br/>'||DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)')
                             when BAQD_CAPXETXU = 3  then
                                             NVL(v.SOANPHUCTHAM, NVL(v.SOANPHUCTHAM, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))||
                                             '<br/> '|| DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>'||
                                              decode (v.SoAnSoTham,null,'',' ','','<br/><br/>'||v.SoAnSoTham||'<br/>'||to_char(v.NgayXuSoTham,'dd/MM/yyyy')||
                                              '<br/> '||DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>')

                             when BAQD_CAPXETXU = 2 
                                        then NVL(v.SoAnSoTham, NVL(v.SoAnSoTham, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NgayXuSoTham,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NgayXuSoTham,'dd/MM/yyyy'))||
                                             '<br/>'|| DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>'
                             else
                                            NVL(v.SOANPHUCTHAM, NVL(v.SoAnSoTham, ''))
                                            ||'<br/>'|| decode(to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'),null,to_char(v.NgayXuSoTham,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))
                                            ||'<br/> '|| DM_CanBo_TenToaVT(NVL(txx.Ma_Ten, tst.Ma_Ten ))        
                             end InforBA
                      --

                         ,qhpl.TENQHPL QHPLDN
                         ,case when NguyenDon is not null then NVL(qhpl.TENQHPL, Replace(v.TenVuAn,(NguyenDon ||' - ')))
                               when NguyenDon is null and BiDon is not null  then NVL(qhpl.TENQHPL, Replace(v.TenVuAn,(BiDon ||' - ')))
                            end as QHPNDN_Report
                        ,tp.HOTEN as TENTHAMPHAN
                        ,ttv.HOTEN TENTHAMTRAVIEN
                        , case when (Length(NVL(v.NGAYPHANCONGTTV,''))=0 or (to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(v.NGAYPHANCONGTTV,'')) >0 then to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy')
                            end  NGAYPHANCONGTTV
                        , ld.HOTEN as TENLANHDAO   

                        , cv.Ten ChucVuLanhDao   , cv.Ma MaChucVuLD  , v.GHICHU,v.NGUOITAO ,to_char(v.NGAYTAO,'dd/MM/yyyy HH24:MI') NGAYTAO, v.NGUOISUA,to_char(v.NGAYSUA,'dd/MM/yyyy HH24:MI') NGAYSUA   
                         ----------anhvh 12/10/2019 
                        ,CASE WHEN  (vtrangthai >=4 OR vtrangthai=-1) THEN TA.TINHTRANGID ELSE v.TRANGTHAIID END TRANGTHAIID
                        ,CASE WHEN   (vtrangthai >=4 OR vtrangthai=-1)  THEN tts.TenTinhTrang ELSE tt.TenTinhTRang END TenTinhTrang
                        ,CASE WHEN   (vtrangthai >=4 OR vtrangthai=-1) AND vKetquathuly =4  THEN tts.GiaiDoan ELSE NVL(tt.GiaiDoan,0) END GiaiDoanTrinh
                         ---------
                        ,case when  NVL(v.GQD_LOAIKETQUA,3)<> 1 then v.QUATRINH_GHICHU
                            when NVL(v.GQD_LOAIKETQUA,3) =1 then (u'Kháng nghị '||DECODE( NVL(v.IsVienTruongKN,0), 0, '(CA)', 1, 'VKS'))  end QUATRINH_GHICHU
                        , v.GDQ_SO 
                        , case  when (Length(NVL(v.GDQ_NGAY,''))=0 or (to_char(v.GDQ_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(v.GDQ_NGAY,'')) >0 then to_char(v.GDQ_NGAY,'dd/MM/yyyy')  end  GDQ_NGAY
                          , case when NVL(v.LoaiAn, 0)<>1 then ''
                                else (SELECT LISTAGG(cast(dt.So as varchar2(10))||case when (Length(NVL(dt.Ngay,''))=0   or (to_char(dt.Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                                                                                       when Length(NVL(dt.Ngay,'')) >0 then ' - '||to_char(dt.Ngay,'dd/MM/yyyy')  end , ',<br/>'
                                                     )
                                       WITHIN GROUP (ORDER BY dt.So asc, dt.Ngay asc) FROM GDTTT_DON_TRALOI dt  
                                       WHERE  dt.VuAnID=v.ID and dt.TypeTB=3
                                     )
                                end as AHS_ThongTinGQD
                        , NVL(v.GQD_LOAIKETQUA,5) KQ_GQD_ID
                        --anhvh edit
                        , DECODE(v.GQD_LOAIKETQUA,3,v.GQD_KETQUA, 2,u'X\1ebfp \0111\01a1n' , 1, u'Kh\00e1ng ngh\1ecb', 0,u'Tr\1ea3 l\1eddi \0111\01a1n',v.GQD_KETQUA ) KQ_GQD
                        ,CASE WHEN v.GQD_LOAIKETQUA=3 or v.GQD_LOAIKETQUA=4 THEN v.GQD_KETQUA
                            WHEN NVL(v.GQD_LOAIKETQUA,5) = 5 then null
                            else DECODE(v.GQD_LOAIKETQUA,0,'TLĐ',1,'KN',2,'XĐ')||'-'||DECODE(v.LoaiAn,1,'HS',2,'DS',3,'KDTM',4,'LĐ',5,'HC')
                     || ' Số: '||translate(v.GDQ_SO using nchar_cs)|| ' Ngày: '||to_char(V.GDQ_NGAY,'dd/MM/yyyy')
                     end KQ_GQDS
                        , NVL(v.IsVienTruongKN,0) IsVienTruongKN
                        , case when NVL(v.GQD_LOAIKETQUA,3)<> 1 then ''
                                when NVL(v.GQD_LOAIKETQUA,3)=1 
                                     then DECODE( NVL(v.IsVienTruongKN,0), 0, '(CA)', 1, 'VKS')  end LoaiKN   
                        , NVL(v.GQD_SoCV , '') GQD_SoCV
                        , case when (Length(NVL(v.GQD_NgayPhatHanhCV,''))=0 or (to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(v.GQD_NgayPhatHanhCV,'')) >0 then to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy') end  GQD_NgayPhatHanhCV  
                        , NVL(v.GQD_IsHoanTHA, 0) GQD_IsHoanTHA,NVL( v.GQD_HoanTHA_So ,'') GQD_HoanTHA_So
                        , case when (Length(NVL(v.GQD_HoanTHA_Ngay,''))=0 or (to_char(v.GQD_HoanTHA_Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(v.GQD_HoanTHA_Ngay,'')) >0 then to_char(v.GQD_HoanTHA_Ngay,'dd/MM/yyyy')   end  GQD_HoanTHA_Ngay  
                        , NVL( v.GQD_HoanTHA_TenNguoiKy ,'') GQD_HoanTHA_TenNguoiKy 
                        -------------------------------
                        , NVL(v.IsHoSo,0) IsHoSo, NVL(v.HoSoID,0)
                        , case when (Length(NVL(hs.NgayTao,''))=0 or (to_char(hs.NgayTao,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(hs.NgayTao,'')) >0 then to_char(hs.NgayTao,'dd/MM/yyyy')  end  NgayTTVNhanHS
                        , v.NGAYTTVNHAN_THS,NVL(v.IsToTrinh,0) IsToTrinh , NVL(v.ISANTRAODOICV,0)  ISANTRAODOICV , v.SOTHULYXXGDT
                        , case when (Length(NVL(v.NGAYTHULYXXGDT,''))=0 or (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') ='01/01/0001')) then ''
                               when Length(NVL(v.NGAYTHULYXXGDT,'')) >0 then to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy')  end  NGAYTHULYXXGDT
                        , case when (Length(NVL(v.XXGDTTT_NGAYVKSTRAHS,''))=0 or (to_char(v.XXGDTTT_NGAYVKSTRAHS,'dd/MM/yyyy') ='01/01/0001')) then ''
                               when Length(NVL(v.XXGDTTT_NGAYVKSTRAHS,'')) >0 then to_char(v.XXGDTTT_NGAYVKSTRAHS,'dd/MM/yyyy')  end  XXGDTTT_NGAYVKSTRAHS
                        , NVL(v.XXGDTTT_ISHOANPT, 0) XXGDTTT_ISHOANPT 
                         , case when (Length(NVL(v.XXGDTTT_NGAYHOAN,''))=0 or (to_char(v.XXGDTTT_NGAYHOAN,'dd/MM/yyyy') ='01/01/0001')) then ''
                                       when Length(NVL(v.XXGDTTT_NGAYHOAN,'')) >0 then to_char(v.XXGDTTT_NGAYHOAN,'dd/MM/yyyy')  end  XXGDTTT_NGAYHOAN
                        , NVL(v.XXGDTTT_LYDOHOAN, '') XXGDTTT_LYDOHOAN,v.XXGDTTT_SOQD
                         , case when (Length(NVL(v.XXGDTTT_NGAYQD,''))=0 or (to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') ='01/01/0001')) then ''
                                       when Length(NVL(v.XXGDTTT_NGAYQD,'')) >0 then to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') end  XXGDTTT_NGAYQD
                        , case when (Length(NVL(v.NGAYXUGIAMDOCTHAM,''))=0 or (to_char(v.NGAYXUGIAMDOCTHAM,'dd/MM/yyyy') ='01/01/0001')) then ''
                                       when Length(NVL(v.NGAYXUGIAMDOCTHAM,'')) >0 then to_char(v.NGAYXUGIAMDOCTHAM,'dd/MM/yyyy')   end  NGAYXUGIAMDOCTHAM
                        , NVL(kq.Ten,' ') KetQuaXXGDT, NVL(v.IsRutKN,0) IsRutKN , NVL(v.SORUTKN, '') SORUTKN
                        , case when (Length(NVL(v.NGAYRUTKN,''))=0 or (to_char(v.NGAYRUTKN,'dd/MM/yyyy') ='01/01/0001')) then ''
                               when Length(NVL(v.NGAYRUTKN,'')) >0 then to_char(v.NGAYRUTKN,'dd/MM/yyyy') end  NGAYRUTKN,HD1.HOIDONGXX,HD2.TEN_CHUTOA
                         ,TTVSS.PHANCONGTTV
                         ,v.TRUONGHOPTHULY
                      from GDTTT_VUAN v 
                      left join DM_TOAAN txx on v.TOAPHUCTHAMID=txx.ID
                      left join DM_TOAAN tst on v.TOAANSOTHAM=tst.ID
                      left join DM_TOAAN tqd on v.TOAQDID=tqd.ID
                      left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
                      left join DM_CANBO tp on v.THAMPHANID=tp.ID
                      left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
                      left join DM_CANBO ld on ld.ID = decode (NVL(v.XXGDT_LANHDAOVUID,0),0,v.LANHDAOVUID,v.XXGDT_LANHDAOVUID)
                      left join DM_CANBO ldxx on v.XXGDT_LANHDAOVUID=ldxx.ID
                      left join DM_DataITem cv on ld.ChucVuID = cv.ID
                      left join GDTTT_DM_TINHTRANG tt on tt.ID= NVL(v.TRANGTHAIID,1)
                      left join DM_DAtaItem kq on kq.ID = v.XXGDTTT_KETQUAID
                      left join (Select ID, NgayTao from GDTTT_QUanLyHS where Loai=3) hs on hs.ID = NVL(v.HoSoID,0)
                      ----anhvh
                      left join HD1 ON HD1.VUANID=v.ID
                      left join HD2 ON HD2.VUANID=v.ID
                      LEFT JOIN TABLE(v_table_all) TA ON TA.VUANID=V.ID
                      LEFT JOIN GDTTT_DM_TINHTRANG tts on tts.ID= TA.TINHTRANGID
                      --anhvh add 21/11/2019 check ngày của vụ và ngày công văn dùng cho việc truy vấn phía dưới
                      LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                          END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                      --anhvh--án quốc hội gồm công văn 8.1 và 9.3
                      LEFT JOIN (select D.VuViecID from GDTTT_DON d 
                                WHERE d.LOAICONGVAN in(Select I.ID from DM_DATAITEM I where (I.ID=546 OR I.CAPCHAID=546 OR I.ID = 1023 OR I.CAPCHAID=1023))
                                GROUP BY d.VuViecID)AQH ON AQH.VuViecID=V.ID
                      --anhvh edit-30/03/2020 thêm cột theo ý kiến của chú Hào lấy theo 9.3
                        LEFT JOIN (select D.VuViecID from GDTTT_DON d 
                                 WHERE d.LOAICONGVAN in(Select I.ID from DM_DATAITEM I where (I.ID=546 OR I.CAPCHAID=546))
                                 AND EXISTS (--chỉ lấy chánh án và phó chánh an
                                    SELECT C.ID,C.HOTEN FROM DM_CANBO C
                                    WHERE EXISTS(SELECT dt.ID, dt.ten FROM dm_dataitem dt WHERE dt.ma IN ('CA', 'PCA')  AND dt.groupid =13 AND dt.ID=C.chucvuid)
                                    AND C.TOAANID=1 AND C.HIEULUC=1 
                                    AND C.ID=D.CHIDAO_LANHDAOID 
                                     )
                                  GROUP BY d.VuViecID
                                  )AQH_F ON AQH_F.VuViecID=V.ID
                   ----anhvh add 31/03/2020 lấy tất cả thẩm tra viên đã được phân công
                   LEFT JOIN (
                        SELECT TTVS.VUANID,LISTAGG(TTVS.HOTEN, '<br/>') WITHIN GROUP (ORDER BY TTVS.STT  DESC)PHANCONGTTV
                          FROM (
                               SELECT TT.VUANID,TT.HOTEN,TT.STT FROM (
                                    SELECT VV.ID VUANID,'<b>'||TO_CHAR(TTV.HOTEN)|| DECODE(VV.XXGDT_NGAYPHANCONGTTV,null,DECODE(VV.NGAYPHANCONGTTV,NULL,NULL,' ('||To_char(VV.NGAYPHANCONGTTV,'dd/MM/yyyy')||')'),DECODE(VV.XXGDT_NGAYPHANCONGTTV,NULL,NULL,' ('||To_char(VV.XXGDT_NGAYPHANCONGTTV,'dd/MM/yyyy')||')'))||'</b>' HOTEN,1 STT FROM GDTTT_VUAN VV 
                                    LEFT JOIN DM_CANBO TTV ON DECODE(VV.XXGDT_THAMTRAVIENID,null,VV.THAMTRAVIENID,VV.XXGDT_THAMTRAVIENID)=TTV.ID
                                 UNION ALL    
                                 -- Can lay dung Lich su cua giai doan
                                   SELECT SS.VUANID,SS.HOTEN,SS.STT FROM (
                                        SELECT A.VUANID,'<i>'||TO_CHAR(b.HOTEN)||' ('||To_char(DECODE(a.TUNGAY,NULL,VS.NGAYPHANCONGTTV,a.TUNGAY),'dd/MM/yyyy')||')</i>'HOTEN,0 STT FROM GDTTT_VUAN_PHANCONGCB_HISTORY A
                                        LEFT JOIN GDTTT_VUAN VS ON VS.ID=A.VUANID
                                        INNER JOIN DM_CanBo b on a.CanBoID = b.ID
                                        WHERE a.Loai=1 
                                        ORDER BY DECODE(a.TUNGAY,NULL,VS.NGAYPHANCONGTTV,a.TUNGAY) DESC
                                    )SS
                                )TT GROUP BY TT.VUANID,TT.HOTEN,TT.STT
                            )TTVS GROUP BY TTVS.VUANID
                         )TTVSS ON TTVSS.VUANID=V.ID
                      ---lấy danh sách thụ lý đơn anhvh add 31/03/2020        
                      LEFT JOIN (
                        SELECT CV.VUVIECID,LISTAGG(CASE WHEN LENGTH(NVL(CV.TL_SO, ''))>0 THEN ('Số ' || CV.TL_SO ) ELSE '' END
                                      || CASE WHEN LENGTH(NVL(CV.TL_NGAY, ''))>0 THEN (' - ' || TO_CHAR(CV.TL_NGAY,'dd/MM/yyyy') ) ELSE '' END                         
                                , ',<br/>')
                            WITHIN GROUP (ORDER BY CV.TL_NGAY DESC, CV.NGAYTAO DESC)LISTHULYDON            
                            FROM GDTTT_DON CV  
                            WHERE  CV.CD_TRANGTHAI=2 AND CV.ISTHULY=1
                            GROUP BY CV.VUVIECID
                        )DD ON DD.VUVIECID=v.ID
                        -----
                     where  v.TOAANID=vToaAnID 
                            And (NVL(vPhongBanID,0)=0 Or v.PhongBanID=vPhongBanID)
                            And NVL(V.ISVIENTRUONGKN,0) = 0
                            And (NVL(vloaian,0) = 0 Or vloaian = v.LOAIAN) 
                            -- Chưa có kết quả đến ngày 
                            And v.NGAYTAO<=vvngaythulyden 
                            And ((v.gqd_loaiketqua in (0,1,2,3,4) and VA.GQD_NGACVS > vvngaythulyden  AND VA.GQD_NGACVS IS NOT NULL) 
                                            OR v.gqd_loaiketqua IS NULL ) 
               )a
       )
    LOOP
    -------TẠO DỮ LIỆU CỦA BÁO CÁO
    CountAll_S:=item.CountAll;
      DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
         <tr style="font-size: 11pt;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.STT||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||replace(replace(item.LisThuLyDon,'-',''),';',', <br/>')||item.TONGDON||item.SoCV81||item.arrCHIDAOID||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.SOANPHUCTHAM||'<br/>'||item.NGAYXUPHUCTHAM||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TOAXX_VietTat||'</td>                
        ');  
        if(vLoaiAn=01)THEN--vLoaiAn=01 là hình sự
                IF(item.NGUYENDON=item.BIDON)THEN
                  V_BIDON_CHECK:=item.NGUYENDON;
                ELSIF(item.NGUYENDON!=item.BIDON AND item.NGUYENDON !='' AND item.BIDON!='') THEN
                  V_BIDON_CHECK:=item.NGUYENDON||', <br/>'||item.BIDON;
                ELSE
                 V_BIDON_CHECK:=replace(item.NGUYENDON||item.BIDON,',','');
                END IF;
               DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.QHPNDN_Report||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||V_BIDON_CHECK||'</td>          
                ');
          else
               DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
               <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.QHPLDN||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.NGUYENDON||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.BIDON||'</td>
                ');
          end if;
          DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||replace(item.NGUOIKHIEUNAI,',',',<br/>')||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||to_char(item.NGAYTTVNHAN_THS,'dd/MM/yyyy')||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.NgayTTVNhanHS||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TenThamTraVien||'</td>');
                      v_ghichu := null;
                v_check_kq :=0;
                select  count(id) into v_check_kq from gdttt_vuan 
                                                where id = item.id 
                                                And GQD_LOAIKETQUA in (0,1,2,3,4);
                if v_check_kq = 1 then
                --- đã có kq
                     select (DECODE(GQD_LOAIKETQUA
                                          , 2, u'X\1ebfp \0111\01a1n'
                                          , 1, u'Kh\00e1ng ngh\1ecb'
                                          , 0,u'Tr\1ea3 l\1eddi \0111\01a1n' 
                                          ,4,'Thông báo VKS đang giải quyết')
                                    || DECODE(GDQ_SO,null,'',' số '||GDQ_SO)
                                    || DECODE(GDQ_NGAY,null,'',decode(to_char(GDQ_NGAY,'dd/MM/yyyy'),'01/01/0001','',' ngày ' || to_char(GDQ_NGAY,'dd/MM/yyyy') ))
                                    ) into v_ghichu  
                            from gdttt_vuan 
                                                where id = item.id 
                                                And GQD_LOAIKETQUA in (0,1,2,3,4);
                else 
                    v_check_tt:=0;
                    select  count(id) into v_check_tt from GDTTT_TOTRINH 
                                                where vuanid = item.id;
                    if v_check_tt > 0 then
                    
                    -- đã có tờ trình
                     select g.ghichu into v_ghichu  from(
                         select vuanid, LISTAGG(to_char(NGAYTRINH,'dd/MM/yyyy')||' '||
                            decode(TINHTRANGID,9,REPLACE(REPLACE((select TENTINHTRANG from GDTTT_DM_TINHTRANG where id = TINHTRANGID),'Phó Chánh án',''),'Chánh án',''),17,REPLACE(REPLACE((select TENTINHTRANG from GDTTT_DM_TINHTRANG where id = TINHTRANGID),'Phó Chánh án',''),'Chánh án',''),REPLACE(REPLACE(REPLACE((select TENTINHTRANG from GDTTT_DM_TINHTRANG where id = TINHTRANGID),'Phó Chánh án',''),'Chánh án',''),'Thẩm phán',''))||
                            decode(TINHTRANGID,7,' PCA ',8,' Chánh án ',6,' TP ',12,decode((select chucvuid from DM_CANBO  where id = lanhdaoid),74,' PCA ',45,' Chánh án ',' TP '),11,decode((select chucvuid from DM_CANBO  where id = lanhdaoid),74,' PCA ',45,' Chánh án ',' TP ')) ||
                            (select hoten from DM_CANBO  where id = lanhdaoid) 
                            ||'; '||
                             
                                to_char(NGAYTRA,'dd/MM/yyyy')||
                               decode(NGAYTRA, null,'',decode(TINHTRANGID,7,' PCA ',8,' Chánh án ',6,' TP ',12,decode((select chucvuid from DM_CANBO  where id = lanhdaoid),74,' PCA ',45,' Chánh án ',' TP '),11,decode((select chucvuid from DM_CANBO  where id = lanhdaoid),74,' PCA ',45,' Chánh án ',' TP '))) ||
                                decode(NGAYTRA, null,'',(select hoten from DM_CANBO  where id = lanhdaoid)) || 
                                decode(loaiykien,1,' duyệt KN ',0,' duyệt TLĐ ',loaiykien)||
                                decode(loaiykien,null,' '||YKIEN,null)                 
                                , '; '
                                )
                             WITHIN GROUP( ORDER BY  NGAYTRA ) AS GHICHU  
                                        from  (SELECT SS.* FROM GDTTT_TOTRINH SS WHERE  SS.VUANID = item.id
                                                            and ss.ID >=(SELECT MAX(ID) FROM GDTTT_TOTRINH S WHERE  S.VUANID = item.id)   
                                                              ORDER BY SS.NGAYTRINH ASC) a group by vuanid) g;
                        
                    else
                        v_check_hs:=0;
                        select  count(id) into v_check_hs from GDTTT_QUANLYHS 
                                                where vuanid = item.id and NGAYTAO is not null And LOAI = 3 ;
                        if v_check_hs > 0 then
                            v_ghichu:='Đang nghiên cứu hồ sơ';
                        else
                            v_ghichu:='Đang rút hồ sơ';
                        end if;                   
                    end if;
                end if;
                
        DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_ghichu||'</td>
            </tr>
        ');
  END LOOP;
    -------TẠO BÁO CÁO
    SELECT DECODE(vLoaiAn,01,'Tội danh','Quan hệ pháp luật') INTO vLoaiAn_name FROM DUAL;
    -----------
        --Insert số trang
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
      <div style="mso-element: footer" id="f1">
            <w:sdt sdtdocpart="t"
            docparttype="Page Numbers (Bottom of Page)" docpartunique="t" id="644013658">
            <p class=MsoFooter align=right style="text-align:right"><!--[if supportFields]><span
            style="mso-element:field-begin"></span><span
            style="mso-spacerun:yes"> </span>PAGE<span style="mso-spacerun:yes">  
            </span>\* MERGEFORMAT <span style="mso-element:field-separator"></span><![endif]--><span
            style="mso-no-proof:yes;display:none">2</span><!--[if supportFields]><span
            style="mso-no-proof:yes"><span style="mso-element:field-end"></span></span><![endif]--><w:sdtPr></w:sdtPr></p>
            </w:sdt>
            <p class="MsoFooter" align="right" style="text-align: right;"><o:p></o:p> </p>
      </div>');
       DBMS_LOB.APPEND(V_EXPORT_TEXT,'
          <table cellpadding="1" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;">
            <tr>
                <td colspan="13" style="height: 0pt;"></td>
            </tr>
            <tr>
                <td colspan="13" style="line-height: 100%; font-size: 14pt"><b>TỔNG HỢP DANH SÁCH ÁN CHƯA CÓ KẾT QUẢ GIẢI QUYẾT</b>
                    <br />
                    <i style="font-size: 12pt;">(Số liệu tính từ ngày '||to_char(vNgayThulyTu,'dd/MM/yyyy')||'  đến ngày '||to_char(vNgayThulyDen,'dd/MM/yyyy')||')</i>
                </td>
            </tr>
            <tr>
                <td colspan="13" style="height: 15pt; text-align: left;">Tổng số án '||vvKetquathuly||' là: '||CountAll_S||'</td>
            </tr>
            <tr style="font-weight:bold;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; height: 50pt;">STT</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Số - Ngày 
                    <br />
                    thụ lý </td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Số án
                    <br />
                    ngày xử</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Tòa án xử</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||vLoaiAn_name||'</td>
                 '); 
            if(vLoaiAn=01)THEN
             DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
              <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Bị cáo</td>             
            ');   
            ELSE
              DBMS_LOB.APPEND(V_EXPORT_TEXT,'    
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Nguyên đơn/ Người khởi kiện</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Bị đơn/ Người bị kiện</td>
               ');   
            END IF;
             DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Người khiếu nại</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ngày nhận THS</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ngày nhận HS</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thẩm tra viên</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ghi chú</td>
            </tr>
            ');  
       ------ADD DỮ LIỆU VÀO THÂN BÁO CÁO
       DBMS_LOB.APPEND(V_EXPORT_TEXT,V_EXPORT_TEXT_ITEM );
       --------------------------------
       DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
           <tr style="height: 1pt;">
                <td style="width: 20pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 120pt"></td>
                 ');
             if(vLoaiAn=01)THEN
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'       
                <td style="width: 80pt"></td>
                 ');
             else
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'       
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                 ');
             end if;
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'      
                <td style="width: 120pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
            </tr>
        </table>
      ');
      --------------------------------    
   DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                 <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
                    <tr>
                        <td style="vertical-align: top;text-align:left;font-size: 10pt;"> NLBC:'||TO_CHAR(sysdate,'dd/MM/yyyy HH24:MI:SS')||'</td>
                        <td>
                        </td>
                    </tr>
                </table>
                    ');   
 --------------------------------      
      OPEN V_CURSOR FOR
--      SELECT curr_thamphan_id curr_thamphan_idS FROM DUAL;
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;     
END GDTTTT_VUAN_SEARCH_BC1;
FUNCTION  GDTTTT_VUAN_SEARCH_BC2
( 
  V_CONLAI_ in varchar2,
  v_colume  in varchar2,
  v_asc_desc in varchar2,
  vToaAnID in number,
  vPhongBanID  in number,
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in varchar2,
  vNguoiGui in varchar2,
  vCoquanchuyendon in varchar2,
  vNguyendon in varchar2,
  vBidon in varchar2,
  vLoaiAn in number,
  vThamtravien in number,
  vLanhdao in number,
  vThamphan in number,
  vQHPLID in number,
  vQHPLDNID in number,
  vTraloidon in varchar2,
  vLoaiCVID in number,
  vNgayThulyTu in date,
  vNgayThulyDen in date,
  vSoThuly in varchar2, 

  vTrangthai in number,
  vCapTrinhTiep in number,
  vIsDangKyBC in number,

  vKetquathuly in number,
  vKetquaxetxu in number,  

  isTTMuonHS in number,
  isTTToTrinh in number,
  isTTYKienKLTotrinh in number,
  isBuocTT in number,
  LoaiAnDB in number,
  vLoaiAnDB_TH in varchar2,
  IsHoanTHA in number,
  vTypeTB in number,
  vTypeHDTP in number,
  v_ISXINANGIAM in number,
  v_GDT_ISXINANGIAM in number,
  PageIndex	in	int,
  PageSize	in	int
)
RETURN SYS_REFCURSOR
IS 
  TotalItem number;  MinIndex	number;  MaxIndex	number;vvvNgayThulyTu date;vvvNgayThulyDen date;
  vvngaythulyden date;vvloaian VARCHAR2(150);vvLoaidon number; 
  temp_sobanan nvarchar2(50);
  ----------------------
  V_CURSOR sys_refcursor;V_EXPORT_TEXT CLOB;V_EXPORT_TEXT_ITEM CLOB;CountAll_S number:=0;vvKetquathuly varchar2(250);vLoaiAn_name varchar2(250);V_BIDON_CHECK varchar2(250);
  ----------------------
  v_table_tp T_TINHTRANG; curr_thamphan_id number:=0;ma_chucvu varchar2(10); vTrangthai_s varchar2(150);
  LOAIAN_ID VARCHAR2(150);LOAIAN_TEN VARCHAR2(150);VUANID NUMBER;LANHDAOID NUMBER;TINHTRANGID NUMBER;NGAYTRA DATE; TOTRINH_ID NUMBER;NGAYTRINH DATE;ISCAPTRINHTIEP NUMBER;THUTU_CAPTRINH NUMBER;
  -----------------------
  v_table_all T_TINHTRANG; vNgayThulyDen_all date;
  LOAIAN_ID_ALL VARCHAR2(150);LOAIAN_TEN_ALL VARCHAR2(150);VUANID_ALL NUMBER;LANHDAOID_ALL NUMBER;TINHTRANGID_ALL NUMBER;NGAYTRA_ALL DATE; TOTRINH_ID_ALL NUMBER;NGAYTRINH_ALL DATE;ISCAPTRINHTIEP_ALL NUMBER;THUTU_CAPTRINH_ALL NUMBER;
  ----------------
   vvTuNgay date;vvDenNgay date;V_SOANPHUCTHAM  VARCHAR2(255);
  ----------------
  v_arrCongvan VARCHAR2(500);v_count_cv NUMBER;v_count_yk NUMBER;v_ghichu VARCHAR2(1000);
  v_check_kq number;v_check_tt number;v_check_hs number; 
BEGIN
   DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT_ITEM,true);
    -----
  SELECT DECODE(vngaythulyden,null,sysdate,to_date(to_char(vngaythulyden,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS')) into vvngaythulyden from dual;
  -- vvTuNgay:=to_date('01/01/2019 00:00:00','dd/MM/yyyy  hh24:mi:ss');vvDenNgay:=to_date('31/12/2019 23:59:59','dd/MM/yyyy  hh24:mi:ss');
  v_table_tp := T_TINHTRANG();  v_table_all := T_TINHTRANG(); 
  -------------------------
  if(vThamphan !=0 and vThamphan is not null) then
          select b.Ma  into ma_chucvu  from DM_CanBo a left join DM_DataItem b on a.ChucVuID = b.ID where a.Id = vThamphan;
           if  (ma_chucvu='PCA' OR ma_chucvu='CA')then 
               curr_thamphan_id:=0;
                 ---------lấy loại án khi thẩm phán chọn ô tổng (nghĩa là không xác định được loại án) của form login sẽ lấy những loại án theo năm truyền vào
                       SELECT  LISTAGG(TTS.LOAIAN_ID, ',') WITHIN GROUP (ORDER BY TTS.LOAIAN_ID) INTO vvloaian  FROM (
                                    SELECT LA.LOAIAN_ID,LA.LOAIAN_TEN FROM  (
                                    SELECT DECODE(TT.COL_LOAIAN,'ISHINHSU',1,'ISDANSU',2,'ISHNGD',3,'ISKDTM',4,'ISLAODONG',5,'ISHANHCHINH',6)LOAIAN_ID,
                                    DECODE(TT.COL_LOAIAN,'ISHINHSU','HÌNH SỰ','ISDANSU','DÂN SỰ','ISHNGD','HÔN NHÂN VÀ GIA ĐÌNH','ISKDTM','KINH DOANH, THƯƠNG MẠI','ISLAODONG','LAO ĐỘNG','ISHANHCHINH','HÀNH CHÍNH')LOAIAN_TEN
                                    FROM (
                                            SELECT * FROM (SELECT PB.ISHINHSU,PB.ISDANSU, PB.ISHNGD,PB.ISKDTM,PB.ISHANHCHINH,PB.ISLAODONG FROM DM_CanBo 
                                            PB WHERE PB.Id = vThamphan
                                         )
                                    UNPIVOT --chuyển từ cột thành dòng
                                    (CHECK_LOAIAN for COL_LOAIAN in (ISHINHSU, ISDANSU, ISHNGD, ISKDTM,ISHANHCHINH,ISLAODONG) )
                                    )TT WHERE CHECK_LOAIAN=1 
                                )LA   WHERE LA.LOAIAN_ID IS NOT NULL  
                               GROUP BY LA.LOAIAN_ID,LA.LOAIAN_TEN 
                 )TTS;
                       -----------------------------------------------
            ELSE
                curr_thamphan_id:= vThamphan;
            end if;
      else
      curr_thamphan_id:=0;
  end if;
         -----Bao cao TTP,HDTP,CA,PCA---------------
         IF(vTrangthai=-1)THEN
            vTrangthai_s:='7,8,9,17';
         ELSE
         vTrangthai_s:=vTrangthai;
         END IF;
         ------------------------
  if (vSoBAQD || ' ') <> ' ' then  
    temp_sobanan := Replace(Replace(Replace(lower(vSoBAQD), ' ', ''), '_',''), '-','');
  else 
    temp_sobanan := vSoBAQD;
  end if;
    -----Thẩm phán---------------
        IF(vPhongBanID=0) THEN
               PKG_GDTTT_BAOCAO_APP.GDTTTT_QLTOTRINH_TP(
                                              vThamphan,vToaAnID,0,vLoaiAn,--vThamphanID,vToaAnID,vPhongBanID,vLoaiAn
                                              null,vNgayThulyDen,--tt_tungay,tt_denngay
                                              V_CURSOR);
                  LOOP 
                  FETCH V_CURSOR 
                        INTO   LOAIAN_ID,LOAIAN_TEN,VUANID,LANHDAOID,TINHTRANGID,NGAYTRA,TOTRINH_ID,NGAYTRINH,ISCAPTRINHTIEP,THUTU_CAPTRINH;
                        EXIT WHEN V_CURSOR%NOTFOUND;
                         v_table_tp.extend;
                         v_table_tp(v_table_tp.count) := R_TINHTRANG(
                                     LOAIAN_ID,LOAIAN_TEN,VUANID,LANHDAOID,TINHTRANGID,NGAYTRA,TOTRINH_ID,NGAYTRINH,ISCAPTRINHTIEP,THUTU_CAPTRINH
                                    );
                  END LOOP;    
                  CLOSE V_CURSOR;  
         END IF;
       ----------------------------------------tạo du lieu cac cap trinh chuyển vào bảng 
                  PKG_GDTTT_BAOCAO_APP.GDTTTT_QLTOTRINH_ALL(
                                  vToaAnID,vPhongBanID,vLoaiAn,--vToaAnID,vPhongBanID,vLoaiAn
                                  null,vNgayThulyDen,--tt_tungay,tt_denngayto_date
                                  V_CURSOR);
                  LOOP 
                  FETCH V_CURSOR 
                       INTO   LOAIAN_ID_ALL,LOAIAN_TEN_ALL,VUANID_ALL,LANHDAOID_ALL,TINHTRANGID_ALL,NGAYTRA_ALL,TOTRINH_ID_ALL,NGAYTRINH_ALL,ISCAPTRINHTIEP_ALL,THUTU_CAPTRINH_ALL;
                        EXIT WHEN V_CURSOR%NOTFOUND;
                         v_table_all.extend;
                         v_table_all(v_table_all.count) := R_TINHTRANG(
                                     LOAIAN_ID_ALL,LOAIAN_TEN_ALL,VUANID_ALL,LANHDAOID_ALL,TINHTRANGID_ALL,NGAYTRA_ALL,TOTRINH_ID_ALL,NGAYTRINH_ALL,ISCAPTRINHTIEP_ALL,THUTU_CAPTRINH_ALL
                                    );
                  END LOOP;    
                  CLOSE V_CURSOR;  
       ---------------------------------
   FOR item IN (
       WITH HD1 as (select hd.VUANID,DECODE(hd.TYPEHD,1,'<br/><span style="">Hội đồng: <b> Toàn thể</b></span>',2,'<br/><span style="">Hội đồng: <b> 5</b></span>','')HOIDONGXX from GDTTT_VUAN_XXGDTT_HOIDONG hd GROUP BY hd.VUANID, hd.TYPEHD)
          ,HD2 as (select hd.VUANID,DECODE(hd.TENCANBO,NULL,NULL,'<br/><span style="">Chủ tọa: <b>'||hd.TENCANBO||'</b></span>')TEN_CHUTOA,hd.CANBOID from GDTTT_VUAN_XXGDTT_HOIDONG hd WHERE hd.ISCHUTOA=1)
          select a.* ,'' arrDONID , '' arrCV81ID   , '' arrCHIDAOID
                    from (
                    Select  COUNT(1) OVER () as CountAll,
                    ROW_NUMBER() OVER (ORDER BY CASE WHEN V_ASC_DESC = 'ASC' AND V_COLUME = 'NGAYTHULYDON' THEN V.NGAYTHULYDON END, CASE WHEN V_ASC_DESC = 'DESC' AND V_COLUME = 'NGAYTHULYDON' THEN V.NGAYTHULYDON END DESC,CASE WHEN V_ASC_DESC = 'ASC' AND V_COLUME = 'TENTHAMTRAVIEN' THEN ttv.HOTEN END,CASE WHEN V_ASC_DESC = 'DESC' AND V_COLUME = 'TENTHAMTRAVIEN' THEN ttv.HOTEN END DESC
                                      ) STT   
                      , NVL(v.TongDon,0 ) as TongDon 
                      ,DECODE(AQH.VuViecID,NULL,0,1)SoCV81--NVL(v.IsAnQuocHoi, 0) as SoCV81,
                      ,DECODE(AQH_F.VuViecID,NULL,NULL,'X')CV93
                      ,NVL(v.IsAnChiDao, 0) as IsAnChiDao 
                       , v.ID, v.LoaiAn,v.MAVUAN,DD.LISTHULYDON  
                        ,(select count(id) from gdttt_don d where d.VUVIECID = v.id and d.isthuly= 1 and CD_TRANGTHAI = 2) cThulymoi
                       , v.SOTHULYDON,to_char(v.NGAYTHULYDON,'dd/MM/yyyy')NGAYTHULYDON , v.NGUYENDON,v.BIDON
                       ,DECODE(v.TRUONGHOPTHULY,1,'<b>Kháng nghị của VKS</b>',2,'<b>Rút Hồ sơ đoàn kiểm tra</b>',3,'<b>Chủ động GĐT qua Bản án</b>',NVL(v.ARRNGUOIKHIEUNAI,v.NGUOIKHIEUNAI)) NGUOIKHIEUNAI
                        ,DECODE(v.BAQD_CAPXETXU,4,v.so_qdgdt,3,v.SOANPHUCTHAM,2,v.SOANSOTHAM,v.SOANPHUCTHAM) SOANPHUCTHAM
                        ,DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')) NGAYXUPHUCTHAM
                        ,DECODE(v.BAQD_CAPXETXU,4,DM_CanBo_TenToaVT(tqd.Ma_Ten),2,DM_CanBo_TenToaVT(tst.Ma_Ten),DM_CanBo_TenToaVT(txx.Ma_Ten)) TOAXX_VietTat
                        ,DECODE(v.BAQD_CAPXETXU,4,tqd.Ma_Ten,2,tst.Ma_Ten,txx.Ma_Ten) ToaXX
                 --manhnd
                      , case when BAQD_CAPXETXU = 4 
                                        then NVL(v.SO_QDGDT, NVL(v.SO_QDGDT, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NGAYQD,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYQD,'dd/MM/yyyy'))||
                                             '<br/>'|| DM_CanBo_TenToaVT(tqd.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-GĐT)</i>'||
                                              decode (v.SOANPHUCTHAM,null,'',' ','','<br/><br/>'||v.SOANPHUCTHAM||'<br/>'||to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')||
                                                        '<br/>'||DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>')||
                                              decode (v.SoAnSoTham,null,'',' ','','<br/>'||v.SoAnSoTham||'<br/>'||to_char(v.NgayXuSoTham,'dd/MM/yyyy')||
                                                    '<br/>'||DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)')
                             when BAQD_CAPXETXU = 3  then
                                             NVL(v.SOANPHUCTHAM, NVL(v.SOANPHUCTHAM, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))||
                                             '<br/> '|| DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>'||
                                              decode (v.SoAnSoTham,null,'',' ','','<br/><br/>'||v.SoAnSoTham||'<br/>'||to_char(v.NgayXuSoTham,'dd/MM/yyyy')||
                                              '<br/> '||DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>')

                             when BAQD_CAPXETXU = 2 
                                        then NVL(v.SoAnSoTham, NVL(v.SoAnSoTham, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NgayXuSoTham,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NgayXuSoTham,'dd/MM/yyyy'))||
                                             '<br/>'|| DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>'
                             else
                                            NVL(v.SOANPHUCTHAM, NVL(v.SoAnSoTham, ''))
                                            ||'<br/>'|| decode(to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'),null,to_char(v.NgayXuSoTham,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))
                                            ||'<br/> '|| DM_CanBo_TenToaVT(NVL(txx.Ma_Ten, tst.Ma_Ten ))        
                             end InforBA
                      --

                         ,qhpl.TENQHPL QHPLDN
                         ,case when NguyenDon is not null then NVL(qhpl.TENQHPL, Replace(v.TenVuAn,(NguyenDon ||' - ')))
                               when NguyenDon is null and BiDon is not null  then NVL(qhpl.TENQHPL, Replace(v.TenVuAn,(BiDon ||' - ')))
                            end as QHPNDN_Report
                        ,tp.HOTEN as TENTHAMPHAN
                        ,ttv.HOTEN TENTHAMTRAVIEN
                        , case when (Length(NVL(v.NGAYPHANCONGTTV,''))=0 or (to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(v.NGAYPHANCONGTTV,'')) >0 then to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy')
                            end  NGAYPHANCONGTTV
                        , ld.HOTEN as TENLANHDAO   

                        , cv.Ten ChucVuLanhDao   , cv.Ma MaChucVuLD  , v.GHICHU,v.NGUOITAO ,to_char(v.NGAYTAO,'dd/MM/yyyy HH24:MI') NGAYTAO, v.NGUOISUA,to_char(v.NGAYSUA,'dd/MM/yyyy HH24:MI') NGAYSUA   
                         ----------anhvh 12/10/2019 
                        ,CASE WHEN  (vtrangthai >=4 OR vtrangthai=-1) THEN TA.TINHTRANGID ELSE v.TRANGTHAIID END TRANGTHAIID
                        ,CASE WHEN   (vtrangthai >=4 OR vtrangthai=-1)  THEN tts.TenTinhTrang ELSE tt.TenTinhTRang END TenTinhTrang
                        ,CASE WHEN   (vtrangthai >=4 OR vtrangthai=-1) AND vKetquathuly =4  THEN tts.GiaiDoan ELSE NVL(tt.GiaiDoan,0) END GiaiDoanTrinh
                         ---------
                        ,case when  NVL(v.GQD_LOAIKETQUA,3)<> 1 then v.QUATRINH_GHICHU
                            when NVL(v.GQD_LOAIKETQUA,3) =1 then (u'Kháng nghị '||DECODE( NVL(v.IsVienTruongKN,0), 0, '(CA)', 1, 'VKS'))  end QUATRINH_GHICHU
                        , v.GDQ_SO 
                        , case  when (Length(NVL(v.GDQ_NGAY,''))=0 or (to_char(v.GDQ_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(v.GDQ_NGAY,'')) >0 then to_char(v.GDQ_NGAY,'dd/MM/yyyy')  end  GDQ_NGAY
                          , case when NVL(v.LoaiAn, 0)<>1 then ''
                                else (SELECT LISTAGG(cast(dt.So as varchar2(10))||case when (Length(NVL(dt.Ngay,''))=0   or (to_char(dt.Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                                                                                       when Length(NVL(dt.Ngay,'')) >0 then ' - '||to_char(dt.Ngay,'dd/MM/yyyy')  end , ',<br/>'
                                                     )
                                       WITHIN GROUP (ORDER BY dt.So asc, dt.Ngay asc) FROM GDTTT_DON_TRALOI dt  
                                       WHERE  dt.VuAnID=v.ID and dt.TypeTB=3
                                     )
                                end as AHS_ThongTinGQD
                        , NVL(v.GQD_LOAIKETQUA,5) KQ_GQD_ID
                        --anhvh edit
                        , DECODE(v.GQD_LOAIKETQUA,3,v.GQD_KETQUA, 2,u'X\1ebfp \0111\01a1n' , 1, u'Kh\00e1ng ngh\1ecb', 0,u'Tr\1ea3 l\1eddi \0111\01a1n',v.GQD_KETQUA ) KQ_GQD
                        ,CASE WHEN v.GQD_LOAIKETQUA=3 or v.GQD_LOAIKETQUA=4 THEN v.GQD_KETQUA
                            WHEN NVL(v.GQD_LOAIKETQUA,5) = 5 then null
                            else DECODE(v.GQD_LOAIKETQUA,0,'TLĐ',1,'KN',2,'XĐ')||'-'||DECODE(v.LoaiAn,1,'HS',2,'DS',3,'KDTM',4,'LĐ',5,'HC')
                     || ' Số: '||translate(v.GDQ_SO using nchar_cs)|| ' Ngày: '||to_char(V.GDQ_NGAY,'dd/MM/yyyy')
                     end KQ_GQDS
                        , NVL(v.IsVienTruongKN,0) IsVienTruongKN
                        , case when NVL(v.GQD_LOAIKETQUA,3)<> 1 then ''
                                when NVL(v.GQD_LOAIKETQUA,3)=1 
                                     then DECODE( NVL(v.IsVienTruongKN,0), 0, '(CA)', 1, 'VKS')  end LoaiKN   
                        , NVL(v.GQD_SoCV , '') GQD_SoCV
                        , case when (Length(NVL(v.GQD_NgayPhatHanhCV,''))=0 or (to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(v.GQD_NgayPhatHanhCV,'')) >0 then to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy') end  GQD_NgayPhatHanhCV  
                        , NVL(v.GQD_IsHoanTHA, 0) GQD_IsHoanTHA,NVL( v.GQD_HoanTHA_So ,'') GQD_HoanTHA_So
                        , case when (Length(NVL(v.GQD_HoanTHA_Ngay,''))=0 or (to_char(v.GQD_HoanTHA_Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(v.GQD_HoanTHA_Ngay,'')) >0 then to_char(v.GQD_HoanTHA_Ngay,'dd/MM/yyyy')   end  GQD_HoanTHA_Ngay  
                        , NVL( v.GQD_HoanTHA_TenNguoiKy ,'') GQD_HoanTHA_TenNguoiKy 
                        -------------------------------
                        , NVL(v.IsHoSo,0) IsHoSo, NVL(v.HoSoID,0)
                        , case when (Length(NVL(hs.NgayTao,''))=0 or (to_char(hs.NgayTao,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(hs.NgayTao,'')) >0 then to_char(hs.NgayTao,'dd/MM/yyyy')  end  NgayTTVNhanHS
                        , v.NGAYTTVNHAN_THS,NVL(v.IsToTrinh,0) IsToTrinh , NVL(v.ISANTRAODOICV,0)  ISANTRAODOICV , v.SOTHULYXXGDT
                        , case when (Length(NVL(v.NGAYTHULYXXGDT,''))=0 or (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') ='01/01/0001')) then ''
                               when Length(NVL(v.NGAYTHULYXXGDT,'')) >0 then to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy')  end  NGAYTHULYXXGDT
                        , case when (Length(NVL(v.XXGDTTT_NGAYVKSTRAHS,''))=0 or (to_char(v.XXGDTTT_NGAYVKSTRAHS,'dd/MM/yyyy') ='01/01/0001')) then ''
                               when Length(NVL(v.XXGDTTT_NGAYVKSTRAHS,'')) >0 then to_char(v.XXGDTTT_NGAYVKSTRAHS,'dd/MM/yyyy')  end  XXGDTTT_NGAYVKSTRAHS
                        , NVL(v.XXGDTTT_ISHOANPT, 0) XXGDTTT_ISHOANPT 
                         , case when (Length(NVL(v.XXGDTTT_NGAYHOAN,''))=0 or (to_char(v.XXGDTTT_NGAYHOAN,'dd/MM/yyyy') ='01/01/0001')) then ''
                                       when Length(NVL(v.XXGDTTT_NGAYHOAN,'')) >0 then to_char(v.XXGDTTT_NGAYHOAN,'dd/MM/yyyy')  end  XXGDTTT_NGAYHOAN
                        , NVL(v.XXGDTTT_LYDOHOAN, '') XXGDTTT_LYDOHOAN,v.XXGDTTT_SOQD
                         , case when (Length(NVL(v.XXGDTTT_NGAYQD,''))=0 or (to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') ='01/01/0001')) then ''
                                       when Length(NVL(v.XXGDTTT_NGAYQD,'')) >0 then to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') end  XXGDTTT_NGAYQD
                        , case when (Length(NVL(v.NGAYXUGIAMDOCTHAM,''))=0 or (to_char(v.NGAYXUGIAMDOCTHAM,'dd/MM/yyyy') ='01/01/0001')) then ''
                                       when Length(NVL(v.NGAYXUGIAMDOCTHAM,'')) >0 then to_char(v.NGAYXUGIAMDOCTHAM,'dd/MM/yyyy')   end  NGAYXUGIAMDOCTHAM
                        , NVL(kq.Ten,' ') KetQuaXXGDT, NVL(v.IsRutKN,0) IsRutKN , NVL(v.SORUTKN, '') SORUTKN
                        , case when (Length(NVL(v.NGAYRUTKN,''))=0 or (to_char(v.NGAYRUTKN,'dd/MM/yyyy') ='01/01/0001')) then ''
                               when Length(NVL(v.NGAYRUTKN,'')) >0 then to_char(v.NGAYRUTKN,'dd/MM/yyyy') end  NGAYRUTKN,HD1.HOIDONGXX,HD2.TEN_CHUTOA
                         ,TTVSS.PHANCONGTTV
                         ,v.TRUONGHOPTHULY
                      from GDTTT_VUAN v 
                      left join DM_TOAAN txx on v.TOAPHUCTHAMID=txx.ID
                      left join DM_TOAAN tst on v.TOAANSOTHAM=tst.ID
                      left join DM_TOAAN tqd on v.TOAQDID=tqd.ID
                      left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
                      left join DM_CANBO tp on v.THAMPHANID=tp.ID
                      left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
                      left join DM_CANBO ld on ld.ID = decode (NVL(v.XXGDT_LANHDAOVUID,0),0,v.LANHDAOVUID,v.XXGDT_LANHDAOVUID)
                      left join DM_CANBO ldxx on v.XXGDT_LANHDAOVUID=ldxx.ID
                      left join DM_DataITem cv on ld.ChucVuID = cv.ID
                      left join GDTTT_DM_TINHTRANG tt on tt.ID= NVL(v.TRANGTHAIID,1)
                      left join DM_DAtaItem kq on kq.ID = v.XXGDTTT_KETQUAID
                      left join (Select ID, NgayTao from GDTTT_QUanLyHS where Loai=3) hs on hs.ID = NVL(v.HoSoID,0)
                      ----anhvh
                      left join HD1 ON HD1.VUANID=v.ID
                      left join HD2 ON HD2.VUANID=v.ID
                      LEFT JOIN TABLE(v_table_all) TA ON TA.VUANID=V.ID
                      LEFT JOIN GDTTT_DM_TINHTRANG tts on tts.ID= TA.TINHTRANGID
                      --anhvh add 21/11/2019 check ngày của vụ và ngày công văn dùng cho việc truy vấn phía dưới
                      LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                          END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                      --anhvh--án quốc hội gồm công văn 8.1 và 9.3
                      LEFT JOIN (select D.VuViecID from GDTTT_DON d 
                                WHERE d.LOAICONGVAN in(Select I.ID from DM_DATAITEM I where (I.ID=546 OR I.CAPCHAID=546 OR I.ID = 1023 OR I.CAPCHAID=1023))
                                GROUP BY d.VuViecID)AQH ON AQH.VuViecID=V.ID
                      --anhvh edit-30/03/2020 thêm cột theo ý kiến của chú Hào lấy theo 9.3
                        LEFT JOIN (select D.VuViecID from GDTTT_DON d 
                                 WHERE d.LOAICONGVAN in(Select I.ID from DM_DATAITEM I where (I.ID=546 OR I.CAPCHAID=546))
                                 AND EXISTS (--chỉ lấy chánh án và phó chánh an
                                    SELECT C.ID,C.HOTEN FROM DM_CANBO C
                                    WHERE EXISTS(SELECT dt.ID, dt.ten FROM dm_dataitem dt WHERE dt.ma IN ('CA', 'PCA')  AND dt.groupid =13 AND dt.ID=C.chucvuid)
                                    AND C.TOAANID=1 AND C.HIEULUC=1 
                                    AND C.ID=D.CHIDAO_LANHDAOID 
                                     )
                                  GROUP BY d.VuViecID
                                  )AQH_F ON AQH_F.VuViecID=V.ID
                   ----anhvh add 31/03/2020 lấy tất cả thẩm tra viên đã được phân công
                   LEFT JOIN (
                        SELECT TTVS.VUANID,LISTAGG(TTVS.HOTEN, '<br/>') WITHIN GROUP (ORDER BY TTVS.STT  DESC)PHANCONGTTV
                          FROM (
                               SELECT TT.VUANID,TT.HOTEN,TT.STT FROM (
                                    SELECT VV.ID VUANID,'<b>'||TO_CHAR(TTV.HOTEN)|| DECODE(VV.XXGDT_NGAYPHANCONGTTV,null,DECODE(VV.NGAYPHANCONGTTV,NULL,NULL,' ('||To_char(VV.NGAYPHANCONGTTV,'dd/MM/yyyy')||')'),DECODE(VV.XXGDT_NGAYPHANCONGTTV,NULL,NULL,' ('||To_char(VV.XXGDT_NGAYPHANCONGTTV,'dd/MM/yyyy')||')'))||'</b>' HOTEN,1 STT FROM GDTTT_VUAN VV 
                                    LEFT JOIN DM_CANBO TTV ON DECODE(VV.XXGDT_THAMTRAVIENID,null,VV.THAMTRAVIENID,VV.XXGDT_THAMTRAVIENID)=TTV.ID
                                 UNION ALL    
                                 -- Can lay dung Lich su cua giai doan
                                   SELECT SS.VUANID,SS.HOTEN,SS.STT FROM (
                                        SELECT A.VUANID,'<i>'||TO_CHAR(b.HOTEN)||' ('||To_char(DECODE(a.TUNGAY,NULL,VS.NGAYPHANCONGTTV,a.TUNGAY),'dd/MM/yyyy')||')</i>'HOTEN,0 STT FROM GDTTT_VUAN_PHANCONGCB_HISTORY A
                                        LEFT JOIN GDTTT_VUAN VS ON VS.ID=A.VUANID
                                        INNER JOIN DM_CanBo b on a.CanBoID = b.ID
                                        WHERE a.Loai=1 
                                        ORDER BY DECODE(a.TUNGAY,NULL,VS.NGAYPHANCONGTTV,a.TUNGAY) DESC
                                    )SS
                                )TT GROUP BY TT.VUANID,TT.HOTEN,TT.STT
                            )TTVS GROUP BY TTVS.VUANID
                         )TTVSS ON TTVSS.VUANID=V.ID
                      ---lấy danh sách thụ lý đơn anhvh add 31/03/2020        
                      LEFT JOIN (
                        SELECT CV.VUVIECID,LISTAGG(CASE WHEN LENGTH(NVL(CV.TL_SO, ''))>0 THEN ('Số ' || CV.TL_SO ) ELSE '' END
                                      || CASE WHEN LENGTH(NVL(CV.TL_NGAY, ''))>0 THEN (' - ' || TO_CHAR(CV.TL_NGAY,'dd/MM/yyyy') ) ELSE '' END                         
                                , ',<br/>')
                            WITHIN GROUP (ORDER BY CV.TL_NGAY DESC, CV.NGAYTAO DESC)LISTHULYDON            
                            FROM GDTTT_DON CV  
                            WHERE  CV.CD_TRANGTHAI=2 AND CV.ISTHULY=1
                            GROUP BY CV.VUVIECID
                        )DD ON DD.VUVIECID=v.ID
                        -----
                       where v.TOAANID=vToaAnID 
                            And ((v.PhongBanID=vPhongBanID) OR (vPhongBanID=0 or vPhongBanID is null))
                         -- Chưa có kết quả đến ngày 
                           And v.NGAYTAO<=vvngaythulyden 
                           And ((v.gqd_loaiketqua in (0,1,2,3,4) and VA.GQD_NGACVS> vvngaythulyden AND VA.GQD_NGACVS IS NOT NULL) 
                                OR v.gqd_loaiketqua IS NULL )
                            
                 --Án thời hiệu 3 năm và 5 nam
                        AND ( vLoaiAnDB_TH IS NULL
                          or (vLoaiAnDB_TH = 35 
                                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), 
                                    DECODE(v.BAQD_CAPXETXU,4,v.NGAYQD,2,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM),
                                    v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90
                                )
                          or (vLoaiAnDB_TH = 55  --năm năm
                                and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), 
                                    DECODE(v.BAQD_CAPXETXU,4,v.NGAYQD,2,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM),
                                    v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<1825
                                )  
                         ) 
               )a
       )
    LOOP
    -------TẠO DỮ LIỆU CỦA BÁO CÁO
    CountAll_S:=item.CountAll;
    SELECT DECODE(SUBSTR(item.SOANPHUCTHAM,0,INSTR(item.SOANPHUCTHAM, '/',1,2)-1),NULL,SUBSTR(item.SOANPHUCTHAM,0,INSTR(item.SOANPHUCTHAM, '/',1,1)-1),SUBSTR(item.SOANPHUCTHAM,0,INSTR(item.SOANPHUCTHAM, '/',1,2)-1)) INTO V_SOANPHUCTHAM FROM DUAL;
    SELECT COUNT(*) INTO v_count_cv FROM GDTTT_DON D WHERE D.VUVIECID=item.ID AND d.CV_SO IS NOT NULL;
    IF(v_count_cv>0)THEN
        SELECT ( Case d.LOAIDON when 3 then (' - Công văn số ' || d.CV_SO || ' ngày ' || TO_CHAR(d.CV_NGAY,'dd/MM/yyyy')||' của '|| TO_CHAR(d.CV_TENDONVI)) else '' End) 
        INTO v_arrCongvan FROM GDTTT_DON D WHERE D.VUVIECID=item.ID AND d.CV_SO IS NOT NULL
        FETCH FIRST 1 ROWS ONLY;
    END IF;
  
    -----------------
      DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
         <tr style="font-size: 11pt;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.STT||'</td>               
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||V_SOANPHUCTHAM||'<br />'||SUBSTR(item.SOANPHUCTHAM,INSTR(item.SOANPHUCTHAM, '/',-1))||'<br/>'||item.NGAYXUPHUCTHAM||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TOAXX_VietTat||'</td>                
        ');  
        if(vLoaiAn=01)THEN--vLoaiAn=01 là hình sự
                IF(item.NGUYENDON=item.BIDON)THEN
                  V_BIDON_CHECK:=item.NGUYENDON;
                ELSIF(item.NGUYENDON!=item.BIDON AND item.NGUYENDON !='' AND item.BIDON!='') THEN
                  V_BIDON_CHECK:=item.NGUYENDON||', <br/>'||item.BIDON;
                ELSE
                 V_BIDON_CHECK:=replace(item.NGUYENDON||item.BIDON,',','');
                END IF;
               DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.QHPNDN_Report||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||V_BIDON_CHECK||'</td>          
                ');
          else
               DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
               <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.QHPLDN||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.NGUYENDON||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.BIDON||'</td>
                ');
          end if;
          DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||to_char(item.NGAYTTVNHAN_THS,'dd/MM/yyyy')||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.NgayTTVNhanHS||'</td>
                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||v_arrCongvan||'</td> 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TenThamTraVien||'</td>');
                
                v_ghichu := null;
                v_check_kq :=0;
                select  count(id) into v_check_kq from gdttt_vuan 
                                                where id = item.id 
                                                And GQD_LOAIKETQUA in (0,1,2,3,4);
                if v_check_kq = 1 then
                --- đã có kq
                     select (DECODE(GQD_LOAIKETQUA
                                          , 2, u'X\1ebfp \0111\01a1n'
                                          , 1, u'Kh\00e1ng ngh\1ecb'
                                          , 0,u'Tr\1ea3 l\1eddi \0111\01a1n' 
                                          ,4,'Thông báo VKS đang giải quyết')
                                    || DECODE(GDQ_SO,null,'',' số '||GDQ_SO)
                                    || DECODE(GDQ_NGAY,null,'',decode(to_char(GDQ_NGAY,'dd/MM/yyyy'),'01/01/0001','',' ngày ' || to_char(GDQ_NGAY,'dd/MM/yyyy') ))
                                    ) into v_ghichu  
                            from gdttt_vuan 
                                                where id = item.id 
                                                And GQD_LOAIKETQUA in (0,1,2,3,4);
                else 
                    v_check_tt:=0;
                    select  count(id) into v_check_tt from GDTTT_TOTRINH 
                                                where vuanid = item.id;
                    if v_check_tt > 0 then
                    
                    -- đã có tờ trình
                     select g.ghichu into v_ghichu  from(
                         select vuanid, LISTAGG('- Ngày '||to_char(NGAYTRINH,'dd/MM/yyyy')||' '||
                            decode(TINHTRANGID,9,REPLACE(REPLACE((select TENTINHTRANG from GDTTT_DM_TINHTRANG where id = TINHTRANGID),'Phó Chánh án',''),'Chánh án',''),17,REPLACE(REPLACE((select TENTINHTRANG from GDTTT_DM_TINHTRANG where id = TINHTRANGID),'Phó Chánh án',''),'Chánh án',''),REPLACE(REPLACE(REPLACE((select TENTINHTRANG from GDTTT_DM_TINHTRANG where id = TINHTRANGID),'Phó Chánh án',''),'Chánh án',''),'Thẩm phán',''))||
                            decode(TINHTRANGID,7,' PCA ',8,' Chánh án ',6,' TP ',12,decode((select chucvuid from DM_CANBO  where id = lanhdaoid),74,' PCA ',45,' Chánh án ',' TP '),11,decode((select chucvuid from DM_CANBO  where id = lanhdaoid),74,' PCA ',45,' Chánh án ',' TP ')) ||
                            (select hoten from DM_CANBO  where id = lanhdaoid) 
                            ||'; '||
                             
                                to_char(NGAYTRA,'dd/MM/yyyy')||
                               decode(NGAYTRA, null,'',decode(TINHTRANGID,7,' PCA ',8,' Chánh án ',6,' TP ',12,decode((select chucvuid from DM_CANBO  where id = lanhdaoid),74,' PCA ',45,' Chánh án ',' TP '),11,decode((select chucvuid from DM_CANBO  where id = lanhdaoid),74,' PCA ',45,' Chánh án ',' TP '))) ||
                                decode(NGAYTRA, null,'',(select hoten from DM_CANBO  where id = lanhdaoid)) || 
                                decode(loaiykien,1,' duyệt KN ',0,' duyệt TLĐ ',loaiykien)||
                                decode(loaiykien,null,' '||YKIEN,null)                 
                                , '; '
                                )
                             WITHIN GROUP( ORDER BY  NGAYTRA ) AS GHICHU  
                                        from  (SELECT SS.* FROM GDTTT_TOTRINH SS WHERE  SS.VUANID = item.id
                                                            and ss.ID >=(SELECT MAX(ID) FROM GDTTT_TOTRINH S WHERE  S.VUANID = item.id)   
                                                              ORDER BY SS.NGAYTRINH ASC) a group by vuanid) g;
                        
                    else
                        v_check_hs:=0;
                        select  count(id) into v_check_hs from GDTTT_QUANLYHS 
                                                where vuanid = item.id and NGAYTAO is not null And LOAI = 3 ;
                        if v_check_hs > 0 then
                            v_ghichu:='Đang nghiên cứu hồ sơ';
                        else
                            v_ghichu:='Đang rút hồ sơ';
                        end if;                   
                    end if;
                end if;
                
        DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_ghichu||'</td>
            </tr>
        ');
  END LOOP;
    -------TẠO BÁO CÁO
    SELECT DECODE(vLoaiAn,01,'Tội danh','Quan hệ pháp luật') INTO vLoaiAn_name FROM DUAL;
    -----------
        --Insert số trang
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
      <div style="mso-element: footer" id="f1">
            <w:sdt sdtdocpart="t"
            docparttype="Page Numbers (Bottom of Page)" docpartunique="t" id="644013658">
            <p class=MsoFooter align=right style="text-align:right"><!--[if supportFields]><span
            style="mso-element:field-begin"></span><span
            style="mso-spacerun:yes"> </span>PAGE<span style="mso-spacerun:yes">  
            </span>\* MERGEFORMAT <span style="mso-element:field-separator"></span><![endif]--><span
            style="mso-no-proof:yes;display:none">2</span><!--[if supportFields]><span
            style="mso-no-proof:yes"><span style="mso-element:field-end"></span></span><![endif]--><w:sdtPr></w:sdtPr></p>
            </w:sdt>
            <p class="MsoFooter" align="right" style="text-align: right;"><o:p></o:p> </p>
      </div>');
       DBMS_LOB.APPEND(V_EXPORT_TEXT,'
          <table cellpadding="1" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;">
            <tr>
                <td colspan="12" style="height: 0pt;"></td>
            </tr>
            <tr>
                <td colspan="12" style="line-height: 100%; font-size: 14pt"><b>DANH SÁCH ÁN SẮP HẾT THỜI HIỆU '||SUBSTR(vLoaiAnDB_TH,1,1)||' NĂM CHƯA CÓ KẾT QUẢ GIẢI QUYẾT</b>
                    <br />
                    <i style="font-size: 12pt;">(Tính đến ngày '||to_char(vNgayThulyDen,'dd/MM/yyyy')||')</i>
                </td>
            </tr>
            <tr>
                <td colspan="12" style="height: 15pt; text-align: left;">Tổng số án '||vvKetquathuly||' là: '||CountAll_S||'</td>
            </tr>
            <tr style="font-weight:bold;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; height: 50pt;">STT</td>
                 <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Bản án
                    <br />
                    số và ngày</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Tòa án xử</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||vLoaiAn_name||'</td>
                 '); 
            if(vLoaiAn=01)THEN
             DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
              <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Bị cáo</td>             
            ');   
            ELSE
              DBMS_LOB.APPEND(V_EXPORT_TEXT,'    
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Nguyên đơn/ Người khởi kiện</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Bị đơn/ Người bị kiện</td>
               ');   
            END IF;
             DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ngày nhận THS</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ngày nhận HS</td>
                 <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">CV chuyển đơn</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thẩm tra viên</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ghi chú</td>
            </tr>
            ');  
       ------ADD DỮ LIỆU VÀO THÂN BÁO CÁO
       DBMS_LOB.APPEND(V_EXPORT_TEXT,V_EXPORT_TEXT_ITEM );
       --------------------------------
       DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
           <tr style="height: 1pt;">
                <td style="width: 20pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 100pt"></td>
                 ');
             if(vLoaiAn=01)THEN
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'       
                <td style="width: 120pt"></td>
                 ');
             else
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'       
                <td style="width: 120pt"></td>
                <td style="width: 120pt"></td>
                 ');
             end if;
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'    
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 100pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 180pt"></td>
            </tr>
        </table>
      ');
      --------------------------------    
   DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                 <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
                    <tr>
                        <td style="vertical-align: top;text-align:left;font-size: 10pt;"> NLBC:'||TO_CHAR(sysdate,'dd/MM/yyyy HH24:MI:SS')||'</td>
                        <td>
                        </td>
                    </tr>
                </table>
                    ');   
 --------------------------------      
      OPEN V_CURSOR FOR
--      SELECT curr_thamphan_id curr_thamphan_idS FROM DUAL;
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;     
END GDTTTT_VUAN_SEARCH_BC2;
FUNCTION  GDTTTT_VUAN_SEARCH_BC6
( 
  V_CONLAI_ in varchar2,
  v_colume  in varchar2,
  v_asc_desc in varchar2,
  vToaAnID in number,
  vPhongBanID  in number,
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in varchar2,
  vNguoiGui in varchar2,
  vCoquanchuyendon in varchar2,
  vNguyendon in varchar2,
  vBidon in varchar2,
  vLoaiAn in number,
  vThamtravien in number,
  vLanhdao in number,
  vThamphan in number,
  vQHPLID in number,
  vQHPLDNID in number,
  vTraloidon in varchar2,
  vLoaiCVID in number,
  vNgayThulyTu in date,
  vNgayThulyDen in date,
  vSoThuly in varchar2, 

  vTrangthai in number,
  vCapTrinhTiep in number,
  vIsDangKyBC in number,

  vKetquathuly in number,
  vKetquaxetxu in number,  

  isTTMuonHS in number,
  isTTToTrinh in number,
  isTTYKienKLTotrinh in number,
  isBuocTT in number,
  LoaiAnDB in number,
  vLoaiAnDB_TH in varchar2,
  IsHoanTHA in number,
  vTypeTB in number,
  vTypeHDTP in number,
  v_ISXINANGIAM in number,
  v_GDT_ISXINANGIAM in number,
  PageIndex	in	int,
  PageSize	in	int
)
RETURN SYS_REFCURSOR
IS 
  TotalItem number;  MinIndex	number;  MaxIndex	number;vvvNgayThulyTu date;vvvNgayThulyDen date;
  vvngaythulyden date;vvloaian VARCHAR2(150);vvLoaidon number; 
  temp_sobanan nvarchar2(50);
  ----------------------
  V_CURSOR sys_refcursor;V_EXPORT_TEXT CLOB;V_EXPORT_TEXT_ITEM CLOB;CountAll_S number:=0;vvKetquathuly varchar2(250);vLoaiAn_name varchar2(250);V_BIDON_CHECK varchar2(250);
  ----------------------
  v_table_tp T_TINHTRANG; curr_thamphan_id number:=0;ma_chucvu varchar2(10); vTrangthai_s varchar2(150);
  LOAIAN_ID VARCHAR2(150);LOAIAN_TEN VARCHAR2(150);VUANID NUMBER;LANHDAOID NUMBER;TINHTRANGID NUMBER;NGAYTRA DATE; TOTRINH_ID NUMBER;NGAYTRINH DATE;ISCAPTRINHTIEP NUMBER;THUTU_CAPTRINH NUMBER;
  -----------------------
  v_table_all T_TINHTRANG; vNgayThulyDen_all date;
  LOAIAN_ID_ALL VARCHAR2(150);LOAIAN_TEN_ALL VARCHAR2(150);VUANID_ALL NUMBER;LANHDAOID_ALL NUMBER;TINHTRANGID_ALL NUMBER;NGAYTRA_ALL DATE; TOTRINH_ID_ALL NUMBER;NGAYTRINH_ALL DATE;ISCAPTRINHTIEP_ALL NUMBER;THUTU_CAPTRINH_ALL NUMBER;
  ----------------
   vvTuNgay date;vvDenNgay date;V_SOANPHUCTHAM  VARCHAR2(255);
  ----------------
  v_arrCongvan VARCHAR2(500);v_count_cv NUMBER;v_count_yk NUMBER;V_YKien VARCHAR2(1000);
  v_vLanhdao_ten VARCHAR2(250):=NULL;v_tieu_de VARCHAR2(255);
   v_ghichu  varchar2(2000);
   v_check_kq number;
   v_check_tt number;
   v_check_hs number;
BEGIN
   DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT_ITEM,true);
    -----
  SELECT DECODE(vngaythulyden,null,sysdate,to_date(to_char(vngaythulyden,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS')) into vvngaythulyden from dual;
  -- vvTuNgay:=to_date('01/01/2019 00:00:00','dd/MM/yyyy  hh24:mi:ss');vvDenNgay:=to_date('31/12/2019 23:59:59','dd/MM/yyyy  hh24:mi:ss');
  v_table_tp := T_TINHTRANG();  v_table_all := T_TINHTRANG(); 
  -------------------------
  if(vThamphan !=0 and vThamphan is not null) then
          select b.Ma  into ma_chucvu  from DM_CanBo a left join DM_DataItem b on a.ChucVuID = b.ID where a.Id = vThamphan;
           if  (ma_chucvu='PCA' OR ma_chucvu='CA')then 
               curr_thamphan_id:=0;
                 ---------lấy loại án khi thẩm phán chọn ô tổng (nghĩa là không xác định được loại án) của form login sẽ lấy những loại án theo năm truyền vào
                       SELECT  LISTAGG(TTS.LOAIAN_ID, ',') WITHIN GROUP (ORDER BY TTS.LOAIAN_ID) INTO vvloaian  FROM (
                                    SELECT LA.LOAIAN_ID,LA.LOAIAN_TEN FROM  (
                                    SELECT DECODE(TT.COL_LOAIAN,'ISHINHSU',1,'ISDANSU',2,'ISHNGD',3,'ISKDTM',4,'ISLAODONG',5,'ISHANHCHINH',6)LOAIAN_ID,
                                    DECODE(TT.COL_LOAIAN,'ISHINHSU','HÌNH SỰ','ISDANSU','DÂN SỰ','ISHNGD','HÔN NHÂN VÀ GIA ĐÌNH','ISKDTM','KINH DOANH, THƯƠNG MẠI','ISLAODONG','LAO ĐỘNG','ISHANHCHINH','HÀNH CHÍNH')LOAIAN_TEN
                                    FROM (
                                            SELECT * FROM (SELECT PB.ISHINHSU,PB.ISDANSU, PB.ISHNGD,PB.ISKDTM,PB.ISHANHCHINH,PB.ISLAODONG FROM DM_CanBo 
                                            PB WHERE PB.Id = vThamphan
                                         )
                                    UNPIVOT --chuyển từ cột thành dòng
                                    (CHECK_LOAIAN for COL_LOAIAN in (ISHINHSU, ISDANSU, ISHNGD, ISKDTM,ISHANHCHINH,ISLAODONG) )
                                    )TT WHERE CHECK_LOAIAN=1 
                                )LA   WHERE LA.LOAIAN_ID IS NOT NULL  
                               GROUP BY LA.LOAIAN_ID,LA.LOAIAN_TEN 
                 )TTS;
                       -----------------------------------------------
            ELSE
                curr_thamphan_id:= vThamphan;
            end if;
      else
      curr_thamphan_id:=0;
  end if;
         -----Bao cao TTP,HDTP,CA,PCA---------------
         IF(vTrangthai=-1)THEN
            vTrangthai_s:='7,8,9,17';
         ELSE
         vTrangthai_s:=vTrangthai;
         END IF;
         ------------------------
  if (vSoBAQD || ' ') <> ' ' then  
    temp_sobanan := Replace(Replace(Replace(lower(vSoBAQD), ' ', ''), '_',''), '-','');
  else 
    temp_sobanan := vSoBAQD;
  end if;
    -----Thẩm phán---------------
        IF(vPhongBanID=0) THEN
               PKG_GDTTT_BAOCAO_APP.GDTTTT_QLTOTRINH_TP(
                                              vThamphan,vToaAnID,0,vLoaiAn,--vThamphanID,vToaAnID,vPhongBanID,vLoaiAn
                                              null,vNgayThulyDen,--tt_tungay,tt_denngay
                                              V_CURSOR);
                  LOOP 
                  FETCH V_CURSOR 
                        INTO   LOAIAN_ID,LOAIAN_TEN,VUANID,LANHDAOID,TINHTRANGID,NGAYTRA,TOTRINH_ID,NGAYTRINH,ISCAPTRINHTIEP,THUTU_CAPTRINH;
                        EXIT WHEN V_CURSOR%NOTFOUND;
                         v_table_tp.extend;
                         v_table_tp(v_table_tp.count) := R_TINHTRANG(
                                     LOAIAN_ID,LOAIAN_TEN,VUANID,LANHDAOID,TINHTRANGID,NGAYTRA,TOTRINH_ID,NGAYTRINH,ISCAPTRINHTIEP,THUTU_CAPTRINH
                                    );
                  END LOOP;    
                  CLOSE V_CURSOR;  
         END IF;
       ----------------------------------------tạo du lieu cac cap trinh chuyển vào bảng 
                  PKG_GDTTT_BAOCAO_APP.GDTTTT_QLTOTRINH_ALL(
                                  vToaAnID,vPhongBanID,vLoaiAn,--vToaAnID,vPhongBanID,vLoaiAn
                                  null,vNgayThulyDen,--tt_tungay,tt_denngayto_date
                                  V_CURSOR);
                  LOOP 
                  FETCH V_CURSOR 
                       INTO   LOAIAN_ID_ALL,LOAIAN_TEN_ALL,VUANID_ALL,LANHDAOID_ALL,TINHTRANGID_ALL,NGAYTRA_ALL,TOTRINH_ID_ALL,NGAYTRINH_ALL,ISCAPTRINHTIEP_ALL,THUTU_CAPTRINH_ALL;
                        EXIT WHEN V_CURSOR%NOTFOUND;
                         v_table_all.extend;
                         v_table_all(v_table_all.count) := R_TINHTRANG(
                                     LOAIAN_ID_ALL,LOAIAN_TEN_ALL,VUANID_ALL,LANHDAOID_ALL,TINHTRANGID_ALL,NGAYTRA_ALL,TOTRINH_ID_ALL,NGAYTRINH_ALL,ISCAPTRINHTIEP_ALL,THUTU_CAPTRINH_ALL
                                    );
                  END LOOP;    
                  CLOSE V_CURSOR;  
       ---------------------------------
   FOR item IN (
        WITH HD1 as (select hd.VUANID,DECODE(hd.TYPEHD,1,'<br/><span style="">Hội đồng: <b> Toàn thể</b></span>',2,'<br/><span style="">Hội đồng: <b> 5</b></span>','')HOIDONGXX from GDTTT_VUAN_XXGDTT_HOIDONG hd GROUP BY hd.VUANID, hd.TYPEHD)
          ,HD2 as (select hd.VUANID,DECODE(hd.TENCANBO,NULL,NULL,'<br/><span style="">Chủ tọa: <b>'||hd.TENCANBO||'</b></span>')TEN_CHUTOA,hd.CANBOID from GDTTT_VUAN_XXGDTT_HOIDONG hd WHERE hd.ISCHUTOA=1)
          select a.* ,'' arrDONID , '' arrCV81ID   , '' arrCHIDAOID
                    from (
                    Select  COUNT(1) OVER () as CountAll,
                    ROW_NUMBER() OVER (ORDER BY CASE WHEN V_ASC_DESC = 'ASC' AND V_COLUME = 'NGAYTHULYDON' THEN V.NGAYTHULYDON END, CASE WHEN V_ASC_DESC = 'DESC' AND V_COLUME = 'NGAYTHULYDON' THEN V.NGAYTHULYDON END DESC,CASE WHEN V_ASC_DESC = 'ASC' AND V_COLUME = 'TENTHAMTRAVIEN' THEN ttv.HOTEN END,CASE WHEN V_ASC_DESC = 'DESC' AND V_COLUME = 'TENTHAMTRAVIEN' THEN ttv.HOTEN END DESC
                                      ) STT   
                      , NVL(v.TongDon,0 ) as TongDon 
                      ,DECODE(AQH.VuViecID,NULL,0,1)SoCV81--NVL(v.IsAnQuocHoi, 0) as SoCV81,
                      ,DECODE(AQH_F.VuViecID,NULL,NULL,'X')CV93
                      ,NVL(v.IsAnChiDao, 0) as IsAnChiDao 
                       , v.ID, v.LoaiAn,v.MAVUAN,DD.LISTHULYDON  
                        ,(select count(id) from gdttt_don d where d.VUVIECID = v.id and d.isthuly= 1 and CD_TRANGTHAI = 2) cThulymoi
                       , v.SOTHULYDON,to_char(v.NGAYTHULYDON,'dd/MM/yyyy')NGAYTHULYDON , v.NGUYENDON,v.BIDON
                       ,DECODE(v.TRUONGHOPTHULY,1,'<b>Kháng nghị của VKS</b>',2,'<b>Rút Hồ sơ đoàn kiểm tra</b>',3,'<b>Chủ động GĐT qua Bản án</b>',NVL(v.ARRNGUOIKHIEUNAI,v.NGUOIKHIEUNAI)) NGUOIKHIEUNAI
                        ,DECODE(v.BAQD_CAPXETXU,4,v.so_qdgdt,3,v.SOANPHUCTHAM,2,v.SOANSOTHAM,v.SOANPHUCTHAM) SOANPHUCTHAM
                        ,DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')) NGAYXUPHUCTHAM
                        ,DECODE(v.BAQD_CAPXETXU,4,DM_CanBo_TenToaVT(tqd.Ma_Ten),2,DM_CanBo_TenToaVT(tst.Ma_Ten),DM_CanBo_TenToaVT(txx.Ma_Ten)) TOAXX_VietTat
                        ,DECODE(v.BAQD_CAPXETXU,4,tqd.Ma_Ten,2,tst.Ma_Ten,txx.Ma_Ten) ToaXX
                 --manhnd
                      , case when BAQD_CAPXETXU = 4 
                                        then NVL(v.SO_QDGDT, NVL(v.SO_QDGDT, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NGAYQD,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYQD,'dd/MM/yyyy'))||
                                             '<br/>'|| DM_CanBo_TenToaVT(tqd.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-GĐT)</i>'||
                                              decode (v.SOANPHUCTHAM,null,'',' ','','<br/><br/>'||v.SOANPHUCTHAM||'<br/>'||to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')||
                                                        '<br/>'||DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>')||
                                              decode (v.SoAnSoTham,null,'',' ','','<br/>'||v.SoAnSoTham||'<br/>'||to_char(v.NgayXuSoTham,'dd/MM/yyyy')||
                                                    '<br/>'||DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)')
                             when BAQD_CAPXETXU = 3  then
                                             NVL(v.SOANPHUCTHAM, NVL(v.SOANPHUCTHAM, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))||
                                             '<br/> '|| DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>'||
                                              decode (v.SoAnSoTham,null,'',' ','','<br/><br/>'||v.SoAnSoTham||'<br/>'||to_char(v.NgayXuSoTham,'dd/MM/yyyy')||
                                              '<br/> '||DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>')

                             when BAQD_CAPXETXU = 2 
                                        then NVL(v.SoAnSoTham, NVL(v.SoAnSoTham, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NgayXuSoTham,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NgayXuSoTham,'dd/MM/yyyy'))||
                                             '<br/>'|| DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>'
                             else
                                            NVL(v.SOANPHUCTHAM, NVL(v.SoAnSoTham, ''))
                                            ||'<br/>'|| decode(to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'),null,to_char(v.NgayXuSoTham,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))
                                            ||'<br/> '|| DM_CanBo_TenToaVT(NVL(txx.Ma_Ten, tst.Ma_Ten ))        
                             end InforBA
                      --

                         ,qhpl.TENQHPL QHPLDN
                         ,case when NguyenDon is not null then NVL(qhpl.TENQHPL, Replace(v.TenVuAn,(NguyenDon ||' - ')))
                               when NguyenDon is null and BiDon is not null  then NVL(qhpl.TENQHPL, Replace(v.TenVuAn,(BiDon ||' - ')))
                            end as QHPNDN_Report
                        ,tp.HOTEN as TENTHAMPHAN
                        ,ttv.HOTEN TENTHAMTRAVIEN
                        , case when (Length(NVL(v.NGAYPHANCONGTTV,''))=0 or (to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(v.NGAYPHANCONGTTV,'')) >0 then to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy')
                            end  NGAYPHANCONGTTV
                        , ld.HOTEN as TENLANHDAO   

                        , cv.Ten ChucVuLanhDao   , cv.Ma MaChucVuLD  , v.GHICHU,v.NGUOITAO ,to_char(v.NGAYTAO,'dd/MM/yyyy HH24:MI') NGAYTAO, v.NGUOISUA,to_char(v.NGAYSUA,'dd/MM/yyyy HH24:MI') NGAYSUA   
                         ----------anhvh 12/10/2019 
                        ,CASE WHEN  (vtrangthai >=4 OR vtrangthai=-1) THEN TA.TINHTRANGID ELSE v.TRANGTHAIID END TRANGTHAIID
                        ,CASE WHEN   (vtrangthai >=4 OR vtrangthai=-1)  THEN tts.TenTinhTrang ELSE tt.TenTinhTRang END TenTinhTrang
                        ,CASE WHEN   (vtrangthai >=4 OR vtrangthai=-1) AND vKetquathuly =4  THEN tts.GiaiDoan ELSE NVL(tt.GiaiDoan,0) END GiaiDoanTrinh
                         ---------
                        ,case when  NVL(v.GQD_LOAIKETQUA,3)<> 1 then v.QUATRINH_GHICHU
                            when NVL(v.GQD_LOAIKETQUA,3) =1 then (u'Kháng nghị '||DECODE( NVL(v.IsVienTruongKN,0), 0, '(CA)', 1, 'VKS'))  end QUATRINH_GHICHU
                        , v.GDQ_SO 
                        , case  when (Length(NVL(v.GDQ_NGAY,''))=0 or (to_char(v.GDQ_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(v.GDQ_NGAY,'')) >0 then to_char(v.GDQ_NGAY,'dd/MM/yyyy')  end  GDQ_NGAY
                          , case when NVL(v.LoaiAn, 0)<>1 then ''
                                else (SELECT LISTAGG(cast(dt.So as varchar2(10))||case when (Length(NVL(dt.Ngay,''))=0   or (to_char(dt.Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                                                                                       when Length(NVL(dt.Ngay,'')) >0 then ' - '||to_char(dt.Ngay,'dd/MM/yyyy')  end , ',<br/>'
                                                     )
                                       WITHIN GROUP (ORDER BY dt.So asc, dt.Ngay asc) FROM GDTTT_DON_TRALOI dt  
                                       WHERE  dt.VuAnID=v.ID and dt.TypeTB=3
                                     )
                                end as AHS_ThongTinGQD
                        , NVL(v.GQD_LOAIKETQUA,5) KQ_GQD_ID
                        --anhvh edit
                        , DECODE(v.GQD_LOAIKETQUA,3,v.GQD_KETQUA, 2,u'X\1ebfp \0111\01a1n' , 1, u'Kh\00e1ng ngh\1ecb', 0,u'Tr\1ea3 l\1eddi \0111\01a1n',v.GQD_KETQUA ) KQ_GQD
                        ,CASE WHEN v.GQD_LOAIKETQUA=3 or v.GQD_LOAIKETQUA=4 THEN v.GQD_KETQUA
                            WHEN NVL(v.GQD_LOAIKETQUA,5) = 5 then null
                            else DECODE(v.GQD_LOAIKETQUA,0,'TLĐ',1,'KN',2,'XĐ')||'-'||DECODE(v.LoaiAn,1,'HS',2,'DS',3,'KDTM',4,'LĐ',5,'HC')
                     || ' Số: '||translate(v.GDQ_SO using nchar_cs)|| ' Ngày: '||to_char(V.GDQ_NGAY,'dd/MM/yyyy')
                     end KQ_GQDS
                        , NVL(v.IsVienTruongKN,0) IsVienTruongKN
                        , case when NVL(v.GQD_LOAIKETQUA,3)<> 1 then ''
                                when NVL(v.GQD_LOAIKETQUA,3)=1 
                                     then DECODE( NVL(v.IsVienTruongKN,0), 0, '(CA)', 1, 'VKS')  end LoaiKN   
                        , NVL(v.GQD_SoCV , '') GQD_SoCV
                        , case when (Length(NVL(v.GQD_NgayPhatHanhCV,''))=0 or (to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(v.GQD_NgayPhatHanhCV,'')) >0 then to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy') end  GQD_NgayPhatHanhCV  
                        , NVL(v.GQD_IsHoanTHA, 0) GQD_IsHoanTHA,NVL( v.GQD_HoanTHA_So ,'') GQD_HoanTHA_So
                        , case when (Length(NVL(v.GQD_HoanTHA_Ngay,''))=0 or (to_char(v.GQD_HoanTHA_Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(v.GQD_HoanTHA_Ngay,'')) >0 then to_char(v.GQD_HoanTHA_Ngay,'dd/MM/yyyy')   end  GQD_HoanTHA_Ngay  
                        , NVL( v.GQD_HoanTHA_TenNguoiKy ,'') GQD_HoanTHA_TenNguoiKy 
                        -------------------------------
                        , NVL(v.IsHoSo,0) IsHoSo, NVL(v.HoSoID,0)
                        , case when (Length(NVL(hs.NgayTao,''))=0 or (to_char(hs.NgayTao,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(hs.NgayTao,'')) >0 then to_char(hs.NgayTao,'dd/MM/yyyy')  end  NgayTTVNhanHS
                        , v.NGAYTTVNHAN_THS,NVL(v.IsToTrinh,0) IsToTrinh , NVL(v.ISANTRAODOICV,0)  ISANTRAODOICV , v.SOTHULYXXGDT
                        , case when (Length(NVL(v.NGAYTHULYXXGDT,''))=0 or (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') ='01/01/0001')) then ''
                               when Length(NVL(v.NGAYTHULYXXGDT,'')) >0 then to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy')  end  NGAYTHULYXXGDT
                        , case when (Length(NVL(v.XXGDTTT_NGAYVKSTRAHS,''))=0 or (to_char(v.XXGDTTT_NGAYVKSTRAHS,'dd/MM/yyyy') ='01/01/0001')) then ''
                               when Length(NVL(v.XXGDTTT_NGAYVKSTRAHS,'')) >0 then to_char(v.XXGDTTT_NGAYVKSTRAHS,'dd/MM/yyyy')  end  XXGDTTT_NGAYVKSTRAHS
                        , NVL(v.XXGDTTT_ISHOANPT, 0) XXGDTTT_ISHOANPT 
                         , case when (Length(NVL(v.XXGDTTT_NGAYHOAN,''))=0 or (to_char(v.XXGDTTT_NGAYHOAN,'dd/MM/yyyy') ='01/01/0001')) then ''
                                       when Length(NVL(v.XXGDTTT_NGAYHOAN,'')) >0 then to_char(v.XXGDTTT_NGAYHOAN,'dd/MM/yyyy')  end  XXGDTTT_NGAYHOAN
                        , NVL(v.XXGDTTT_LYDOHOAN, '') XXGDTTT_LYDOHOAN,v.XXGDTTT_SOQD
                         , case when (Length(NVL(v.XXGDTTT_NGAYQD,''))=0 or (to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') ='01/01/0001')) then ''
                                       when Length(NVL(v.XXGDTTT_NGAYQD,'')) >0 then to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') end  XXGDTTT_NGAYQD
                        , case when (Length(NVL(v.NGAYXUGIAMDOCTHAM,''))=0 or (to_char(v.NGAYXUGIAMDOCTHAM,'dd/MM/yyyy') ='01/01/0001')) then ''
                                       when Length(NVL(v.NGAYXUGIAMDOCTHAM,'')) >0 then to_char(v.NGAYXUGIAMDOCTHAM,'dd/MM/yyyy')   end  NGAYXUGIAMDOCTHAM
                        , NVL(kq.Ten,' ') KetQuaXXGDT, NVL(v.IsRutKN,0) IsRutKN , NVL(v.SORUTKN, '') SORUTKN
                        , case when (Length(NVL(v.NGAYRUTKN,''))=0 or (to_char(v.NGAYRUTKN,'dd/MM/yyyy') ='01/01/0001')) then ''
                               when Length(NVL(v.NGAYRUTKN,'')) >0 then to_char(v.NGAYRUTKN,'dd/MM/yyyy') end  NGAYRUTKN,HD1.HOIDONGXX,HD2.TEN_CHUTOA
                         ,TTVSS.PHANCONGTTV
                         ,v.TRUONGHOPTHULY
                      from GDTTT_VUAN v 
                      left join DM_TOAAN txx on v.TOAPHUCTHAMID=txx.ID
                      left join DM_TOAAN tst on v.TOAANSOTHAM=tst.ID
                      left join DM_TOAAN tqd on v.TOAQDID=tqd.ID
                      left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
                      left join DM_CANBO tp on v.THAMPHANID=tp.ID
                      left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
                      left join DM_CANBO ld on ld.ID = decode (NVL(v.XXGDT_LANHDAOVUID,0),0,v.LANHDAOVUID,v.XXGDT_LANHDAOVUID)
                      left join DM_CANBO ldxx on v.XXGDT_LANHDAOVUID=ldxx.ID
                      left join DM_DataITem cv on ld.ChucVuID = cv.ID
                      left join GDTTT_DM_TINHTRANG tt on tt.ID= NVL(v.TRANGTHAIID,1)
                      left join DM_DAtaItem kq on kq.ID = v.XXGDTTT_KETQUAID
                      left join (Select ID, NgayTao from GDTTT_QUanLyHS where Loai=3) hs on hs.ID = NVL(v.HoSoID,0)
                      ----anhvh
                      left join HD1 ON HD1.VUANID=v.ID
                      left join HD2 ON HD2.VUANID=v.ID
                      LEFT JOIN TABLE(v_table_all) TA ON TA.VUANID=V.ID
                      LEFT JOIN GDTTT_DM_TINHTRANG tts on tts.ID= TA.TINHTRANGID
                      --anhvh add 21/11/2019 check ngày của vụ và ngày công văn dùng cho việc truy vấn phía dưới
                      LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                          END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                      --anhvh--án quốc hội gồm công văn 8.1 và 9.3
                      LEFT JOIN (select D.VuViecID from GDTTT_DON d 
                                WHERE d.LOAICONGVAN in(Select I.ID from DM_DATAITEM I where (I.ID=546 OR I.CAPCHAID=546 OR I.ID = 1023 OR I.CAPCHAID=1023))
                                GROUP BY d.VuViecID)AQH ON AQH.VuViecID=V.ID
                      --anhvh edit-30/03/2020 thêm cột theo ý kiến của chú Hào lấy theo 9.3
                        LEFT JOIN (select D.VuViecID from GDTTT_DON d 
                                 WHERE d.LOAICONGVAN in(Select I.ID from DM_DATAITEM I where (I.ID=546 OR I.CAPCHAID=546))
                                 AND EXISTS (--chỉ lấy chánh án và phó chánh an
                                    SELECT C.ID,C.HOTEN FROM DM_CANBO C
                                    WHERE EXISTS(SELECT dt.ID, dt.ten FROM dm_dataitem dt WHERE dt.ma IN ('CA', 'PCA')  AND dt.groupid =13 AND dt.ID=C.chucvuid)
                                    AND C.TOAANID=1 AND C.HIEULUC=1 
                                    AND C.ID=D.CHIDAO_LANHDAOID 
                                     )
                                  GROUP BY d.VuViecID
                                  )AQH_F ON AQH_F.VuViecID=V.ID
                   ----anhvh add 31/03/2020 lấy tất cả thẩm tra viên đã được phân công
                   LEFT JOIN (
                        SELECT TTVS.VUANID,LISTAGG(TTVS.HOTEN, '<br/>') WITHIN GROUP (ORDER BY TTVS.STT  DESC)PHANCONGTTV
                          FROM (
                               SELECT TT.VUANID,TT.HOTEN,TT.STT FROM (
                                    SELECT VV.ID VUANID,'<b>'||TO_CHAR(TTV.HOTEN)|| DECODE(VV.XXGDT_NGAYPHANCONGTTV,null,DECODE(VV.NGAYPHANCONGTTV,NULL,NULL,' ('||To_char(VV.NGAYPHANCONGTTV,'dd/MM/yyyy')||')'),DECODE(VV.XXGDT_NGAYPHANCONGTTV,NULL,NULL,' ('||To_char(VV.XXGDT_NGAYPHANCONGTTV,'dd/MM/yyyy')||')'))||'</b>' HOTEN,1 STT FROM GDTTT_VUAN VV 
                                    LEFT JOIN DM_CANBO TTV ON DECODE(VV.XXGDT_THAMTRAVIENID,null,VV.THAMTRAVIENID,VV.XXGDT_THAMTRAVIENID)=TTV.ID
                                 UNION ALL    
                                 -- Can lay dung Lich su cua giai doan
                                   SELECT SS.VUANID,SS.HOTEN,SS.STT FROM (
                                        SELECT A.VUANID,'<i>'||TO_CHAR(b.HOTEN)||' ('||To_char(DECODE(a.TUNGAY,NULL,VS.NGAYPHANCONGTTV,a.TUNGAY),'dd/MM/yyyy')||')</i>'HOTEN,0 STT FROM GDTTT_VUAN_PHANCONGCB_HISTORY A
                                        LEFT JOIN GDTTT_VUAN VS ON VS.ID=A.VUANID
                                        INNER JOIN DM_CanBo b on a.CanBoID = b.ID
                                        WHERE a.Loai=1 
                                        ORDER BY DECODE(a.TUNGAY,NULL,VS.NGAYPHANCONGTTV,a.TUNGAY) DESC
                                    )SS
                                )TT GROUP BY TT.VUANID,TT.HOTEN,TT.STT
                            )TTVS GROUP BY TTVS.VUANID
                         )TTVSS ON TTVSS.VUANID=V.ID
                      ---lấy danh sách thụ lý đơn anhvh add 31/03/2020        
                      LEFT JOIN (
                        SELECT CV.VUVIECID,LISTAGG(CASE WHEN LENGTH(NVL(CV.TL_SO, ''))>0 THEN ('Số ' || CV.TL_SO ) ELSE '' END
                                      || CASE WHEN LENGTH(NVL(CV.TL_NGAY, ''))>0 THEN (' - ' || TO_CHAR(CV.TL_NGAY,'dd/MM/yyyy') ) ELSE '' END                         
                                , ',<br/>')
                            WITHIN GROUP (ORDER BY CV.TL_NGAY DESC, CV.NGAYTAO DESC)LISTHULYDON            
                            FROM GDTTT_DON CV  
                            WHERE  CV.CD_TRANGTHAI=2 AND CV.ISTHULY=1
                            GROUP BY CV.VUVIECID
                        )DD ON DD.VUVIECID=v.ID
                        -----
                      where v.TOAANID=vToaAnID 
                            And (NVL(vPhongBanID,0)=0 Or v.PhongBanID=vPhongBanID)
                            And NVL(V.ISVIENTRUONGKN,0) = 0
                            And (NVL(vloaian,0) = 0 Or vloaian = v.LOAIAN) 
                              -- Thuộc án
                              and ( LoaiAnDB = 0
                                    or (LoaiAnDB = 1 
                                         --án quốc hội gồm công văn 8.1 và 9.3
                                         AND EXISTS(select 'X' from GDTTT_DON d 
                                                                        where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                                        AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                                        GROUP BY d.VuViecID) 
                                       )
                                    or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)   
                                    or(LoaiAnDB = 3  AND AQH_F.VuViecID IS NOT NULL)
                               )
                 
                             --------------------Thông báo
                              and ( vTypeTB = 0 
                                    or (vTypeTB =1 and GDTTT_TB_CountTB(v.ID, 1)=0
                                       -- Chưa có kết quả đến ngày 
                                        And v.NGAYTAO<=vvngaythulyden 
                                        And ((v.gqd_loaiketqua in (0,1,2,3,4) and VA.GQD_NGACVS> vvngaythulyden  AND VA.GQD_NGACVS IS NOT NULL) 
                                            OR v.gqd_loaiketqua IS NULL ) 
                                        )-- chua co tb tt
                                    or (vTypeTB =2 and GDTTT_TB_CountTB(v.ID, 1)>0) -- da co tb tt
                                    or (vTypeTB =3 and GDTTT_TB_CountTB(v.ID, 2)=0
                                            -- Đã có kết quả đến ngày
                                            And v.NGAYTAO<=vvngaythulyden 
                                            And (v.gqd_loaiketqua in (0,1,2,3,4) and VA.GQD_NGACVS <= vvngaythulyden  AND VA.GQD_NGACVS IS NOT NULL)     
                                        )-- chua co tb TLdon
                                    or (vTypeTB =4 and GDTTT_TB_CountTB(v.ID, 2)>0)-- da co tb TL don
                                    or (vTypeTB =5 and (select NVL(count(ID),0) from GDTTT_DON_TRALOI where VuAnId=v.ID)=0)--chua co ca 2
                                    or (vTypeTB =6 and GDTTT_TB_CountTB(v.ID, 1)>0 and GDTTT_TB_CountTB(v.ID, 2)>0)-- da co ca 2
            
                                    )
               )a
       )
    LOOP
    -------TẠO DỮ LIỆU CỦA BÁO CÁO
    CountAll_S:=item.CountAll;
    SELECT DECODE(SUBSTR(item.SOANPHUCTHAM,0,INSTR(item.SOANPHUCTHAM, '/',1,2)-1),NULL,SUBSTR(item.SOANPHUCTHAM,0,INSTR(item.SOANPHUCTHAM, '/',1,1)-1),SUBSTR(item.SOANPHUCTHAM,0,INSTR(item.SOANPHUCTHAM, '/',1,2)-1)) INTO V_SOANPHUCTHAM FROM DUAL;
    SELECT COUNT(*) INTO v_count_cv FROM GDTTT_DON D WHERE D.VUVIECID=item.ID AND d.CV_SO IS NOT NULL;
    IF(v_count_cv>0)THEN
        SELECT ( Case d.LOAIDON when 3 then (' - Công văn số ' || d.CV_SO || ' ngày ' || TO_CHAR(d.CV_NGAY,'dd/MM/yyyy')||' của '|| TO_CHAR(d.CV_TENDONVI)) else '' End) 
        INTO v_arrCongvan FROM GDTTT_DON D WHERE D.VUVIECID=item.ID AND d.CV_SO IS NOT NULL
        FETCH FIRST 1 ROWS ONLY;
    END IF;

    -----------------
      DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
         <tr style="font-size: 11pt;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.STT||'</td>               
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||V_SOANPHUCTHAM||'<br />'||SUBSTR(item.SOANPHUCTHAM,INSTR(item.SOANPHUCTHAM, '/',-1))||'<br/>'||item.NGAYXUPHUCTHAM||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TOAXX_VietTat||'</td>                
        ');  
        if(vLoaiAn=01)THEN--vLoaiAn=01 là hình sự
                IF(item.NGUYENDON=item.BIDON)THEN
                  V_BIDON_CHECK:=item.NGUYENDON;
                ELSIF(item.NGUYENDON!=item.BIDON AND item.NGUYENDON !='' AND item.BIDON!='') THEN
                  V_BIDON_CHECK:=item.NGUYENDON||', <br/>'||item.BIDON;
                ELSE
                 V_BIDON_CHECK:=replace(item.NGUYENDON||item.BIDON,',','');
                END IF;
               DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.QHPNDN_Report||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||V_BIDON_CHECK||'</td>          
                ');
          else
               DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
               <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.QHPLDN||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.NGUYENDON||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.BIDON||'</td>
                ');
          end if;
          DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||v_arrCongvan||'</td> 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"></td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TenThamTraVien||'</td>');
                v_ghichu := null;
                v_check_kq :=0;
                select  count(id) into v_check_kq from gdttt_vuan 
                                                where id = item.id 
                                                And GQD_LOAIKETQUA in (0,1,2,3,4);
                if v_check_kq = 1 then
                --- đã có kq
                     select (DECODE(GQD_LOAIKETQUA
                                          , 2, u'X\1ebfp \0111\01a1n'
                                          , 1, u'Kh\00e1ng ngh\1ecb'
                                          , 0,u'Tr\1ea3 l\1eddi \0111\01a1n' 
                                          ,4,'Thông báo VKS đang giải quyết')
                                    || DECODE(GDQ_SO,null,'',' số '||GDQ_SO)
                                    || DECODE(GDQ_NGAY,null,'',decode(to_char(GDQ_NGAY,'dd/MM/yyyy'),'01/01/0001','',' ngày ' || to_char(GDQ_NGAY,'dd/MM/yyyy') ))
                                    ) into v_ghichu  
                            from gdttt_vuan 
                                                where id = item.id 
                                                And GQD_LOAIKETQUA in (0,1,2,3,4);
                else 
                    v_check_tt:=0;
                    select  count(id) into v_check_tt from GDTTT_TOTRINH 
                                                where vuanid = item.id;
                    if v_check_tt > 0 then
                    
                    -- đã có tờ trình
                     select g.ghichu into v_ghichu  from(
                         select vuanid, LISTAGG(to_char(NGAYTRINH,'dd/MM/yyyy')||' '||
                            decode(TINHTRANGID,9,REPLACE(REPLACE((select TENTINHTRANG from GDTTT_DM_TINHTRANG where id = TINHTRANGID),'Phó Chánh án',''),'Chánh án',''),17,REPLACE(REPLACE((select TENTINHTRANG from GDTTT_DM_TINHTRANG where id = TINHTRANGID),'Phó Chánh án',''),'Chánh án',''),REPLACE(REPLACE(REPLACE((select TENTINHTRANG from GDTTT_DM_TINHTRANG where id = TINHTRANGID),'Phó Chánh án',''),'Chánh án',''),'Thẩm phán',''))||
                            decode(TINHTRANGID,7,' PCA ',8,' Chánh án ',6,' TP ',12,decode((select chucvuid from DM_CANBO  where id = lanhdaoid),74,' PCA ',45,' Chánh án ',' TP '),11,decode((select chucvuid from DM_CANBO  where id = lanhdaoid),74,' PCA ',45,' Chánh án ',' TP ')) ||
                            (select hoten from DM_CANBO  where id = lanhdaoid) 
                            ||'; '||
                             
                                to_char(NGAYTRA,'dd/MM/yyyy')||
                               decode(NGAYTRA, null,'',decode(TINHTRANGID,7,' PCA ',8,' Chánh án ',6,' TP ',12,decode((select chucvuid from DM_CANBO  where id = lanhdaoid),74,' PCA ',45,' Chánh án ',' TP '),11,decode((select chucvuid from DM_CANBO  where id = lanhdaoid),74,' PCA ',45,' Chánh án ',' TP '))) ||
                                decode(NGAYTRA, null,'',(select hoten from DM_CANBO  where id = lanhdaoid)) || 
                                decode(loaiykien,1,' duyệt KN ',0,' duyệt TLĐ ',loaiykien)||
                                decode(loaiykien,null,' '||YKIEN,null)                 
                                , '; '
                                )
                             WITHIN GROUP( ORDER BY  NGAYTRA ) AS GHICHU  
                                        from  (SELECT SS.* FROM GDTTT_TOTRINH SS WHERE  SS.VUANID = item.id
                                                            and ss.ID >=(SELECT MAX(ID) FROM GDTTT_TOTRINH S WHERE  S.VUANID = item.id)   
                                                              ORDER BY SS.NGAYTRINH ASC) a group by vuanid) g;
                        
                    else
                        v_check_hs:=0;
                        select  count(id) into v_check_hs from GDTTT_QUANLYHS 
                                                where vuanid = item.id and NGAYTAO is not null And LOAI = 3 ;
                        if v_check_hs > 0 then
                            v_ghichu:='Đang nghiên cứu hồ sơ';
                        else
                            v_ghichu:='Đang rút hồ sơ';
                        end if;                   
                    end if;
                end if;
                
    DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'
        <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||v_ghichu||'</td>
            </tr>
        ');
  END LOOP;
    IF(vLanhdao!=0)THEN
            SELECT '<br/><span style="font-weight:100">Lãnh đạo phụ trách: '||cb.HOTEN||'</span>' INTO v_vLanhdao_ten FROM DM_CANBO cb WHERE ID=vLanhdao;
           -- FETCH FIRST 1 ROWS ONLY;
    END IF;
     ---
    IF(vTypeTB=1)THEN
      v_tieu_de:='TRẢ LỜI TÌNH THẾ'; 
    ELSIF(vTypeTB=3)THEN
      v_tieu_de:='THÔNG BÁO KẾT QUẢ';
    END IF;
    -------TẠO BÁO CÁO
    SELECT DECODE(vLoaiAn,01,'Tội danh','Quan hệ pháp luật') INTO vLoaiAn_name FROM DUAL;
    -----------
        --Insert số trang
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
      <div style="mso-element: footer" id="f1">
            <w:sdt sdtdocpart="t"
            docparttype="Page Numbers (Bottom of Page)" docpartunique="t" id="644013658">
            <p class=MsoFooter align=right style="text-align:right"><!--[if supportFields]><span
            style="mso-element:field-begin"></span><span
            style="mso-spacerun:yes"> </span>PAGE<span style="mso-spacerun:yes">  
            </span>\* MERGEFORMAT <span style="mso-element:field-separator"></span><![endif]--><span
            style="mso-no-proof:yes;display:none">2</span><!--[if supportFields]><span
            style="mso-no-proof:yes"><span style="mso-element:field-end"></span></span><![endif]--><w:sdtPr></w:sdtPr></p>
            </w:sdt>
            <p class="MsoFooter" align="right" style="text-align: right;"><o:p></o:p> </p>
      </div>');
       DBMS_LOB.APPEND(V_EXPORT_TEXT,'
          <table cellpadding="1" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;">
            <tr>
                <td colspan="10" style="height: 0pt;"></td>
            </tr>
            <tr>
                <td colspan="10" style="line-height: 100%; font-size: 14pt"><b>DANH SÁCH ÁN QUỐC HỘI CHƯA '||v_tieu_de||v_vLanhdao_ten||'</b>
                    <br />
                    <i style="font-size: 12pt;">(Số liệu tính đến ngày '||to_char(vNgayThulyDen,'dd/MM/yyyy')||')</i>
                </td>
            </tr>
            <tr>
                <td colspan="10" style="height: 15pt; text-align: left;">Tổng số án '||vvKetquathuly||' là: '||CountAll_S||'</td>
            </tr>
            <tr style="font-weight:bold;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; height: 50pt;">STT</td>
                 <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Bản án
                    <br />
                    số và ngày</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Tòa án xử</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||vLoaiAn_name||'</td>
                 '); 
            if(vLoaiAn=01)THEN
             DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
              <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Bị cáo</td>             
            ');   
            ELSE
              DBMS_LOB.APPEND(V_EXPORT_TEXT,'    
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Nguyên đơn/ Người khởi kiện</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Bị đơn/ Người bị kiện</td>
               ');   
            END IF;
            DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                 <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Công văn số và ngày</td>');
            IF(vTypeTB=1)THEN
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'    
                     <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Trả lời tình thế</td>');
            ELSIF(vTypeTB=3)THEN
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'    
                     <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thông báo kết quả</td>');   
            END IF;
               
            DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thẩm tra viên</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ghi chú</td>
            </tr>
            ');  
       ------ADD DỮ LIỆU VÀO THÂN BÁO CÁO
       DBMS_LOB.APPEND(V_EXPORT_TEXT,V_EXPORT_TEXT_ITEM );
       --------------------------------
       DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
           <tr style="height: 1pt;">
                <td style="width: 20pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 100pt"></td>
                 ');
             if(vLoaiAn=01)THEN
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'       
                <td style="width: 120pt"></td>
                 ');
             else
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'       
                <td style="width: 120pt"></td>
                <td style="width: 120pt"></td>
                 ');
             end if;
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'    
                <td style="width: 150pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 100pt"></td>
                <td style="width: 170pt"></td>
            </tr>
        </table>
      ');
      --------------------------------    
   DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                 <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
                    <tr>
                        <td style="vertical-align: top;text-align:left;font-size: 10pt;"> NLBC:'||TO_CHAR(sysdate,'dd/MM/yyyy HH24:MI:SS')||'</td>
                        <td>
                        </td>
                    </tr>
                </table>
                    ');   
 --------------------------------      
      OPEN V_CURSOR FOR
--      SELECT curr_thamphan_id curr_thamphan_idS FROM DUAL;
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;     
END GDTTTT_VUAN_SEARCH_BC6;

FUNCTION  GDTTTT_VUAN_SEARCH_BC8_GROUP
( 
  V_CONLAI_ in varchar2,
  v_colume  in varchar2,
  v_asc_desc in varchar2,
  vToaAnID in number,
  vPhongBanID  in number,
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in varchar2,
  vNguoiGui in varchar2,
  vCoquanchuyendon in varchar2,
  vNguyendon in varchar2,
  vBidon in varchar2,
  vLoaiAn in number,
  vThamtravien in number,
  vLanhdao in number,
  vThamphan in number,
  vQHPLID in number,
  vQHPLDNID in number,
  vTraloidon in varchar2,
  vLoaiCVID in number,
  vNgayThulyTu in date,
  vNgayThulyDen in date,
  vSoThuly in varchar2, 

  vTrangthai in number,
  vCapTrinhTiep in number,
  vIsDangKyBC in number,

  vKetquathuly in number,
  vKetquaxetxu in number,  

  isTTMuonHS in number,
  isTTToTrinh in number,
  isTTYKienKLTotrinh in number,
  isBuocTT in number,
  LoaiAnDB in number,
  vLoaiAnDB_TH in varchar2,
  IsHoanTHA in number,
  vTypeTB in number,
  vTypeHDTP in number,
  v_ISXINANGIAM in number,
  v_GDT_ISXINANGIAM in number,
  PageIndex	in	int,
  PageSize	in	int
)
RETURN SYS_REFCURSOR
IS 
  TotalItem number;  MinIndex	number;  MaxIndex	number;vvvNgayThulyTu date;vvvNgayThulyDen date;
  vvngaythulyden date;vvloaian VARCHAR2(150);vvLoaidon number; 
  temp_sobanan nvarchar2(50);
  ----------------------
  V_CURSOR sys_refcursor;V_EXPORT_TEXT CLOB;V_EXPORT_TEXT_ITEM CLOB;CountAll_S number:=0;vvKetquathuly varchar2(250);vLoaiAn_name varchar2(250);V_BIDON_CHECK varchar2(250);
  ----------------------
  v_table_tp T_TINHTRANG; curr_thamphan_id number:=0;ma_chucvu varchar2(10); vTrangthai_s varchar2(150);
  LOAIAN_ID VARCHAR2(150);LOAIAN_TEN VARCHAR2(150);VUANID NUMBER;LANHDAOID NUMBER;TINHTRANGID NUMBER;NGAYTRA DATE; TOTRINH_ID NUMBER;NGAYTRINH DATE;ISCAPTRINHTIEP NUMBER;THUTU_CAPTRINH NUMBER;
  -----------------------
  v_table_all T_TINHTRANG; vNgayThulyDen_all date;
  LOAIAN_ID_ALL VARCHAR2(150);LOAIAN_TEN_ALL VARCHAR2(150);VUANID_ALL NUMBER;LANHDAOID_ALL NUMBER;TINHTRANGID_ALL NUMBER;NGAYTRA_ALL DATE; TOTRINH_ID_ALL NUMBER;NGAYTRINH_ALL DATE;ISCAPTRINHTIEP_ALL NUMBER;THUTU_CAPTRINH_ALL NUMBER;
  ----------------
   vvTuNgay date;vvDenNgay date;V_SOANPHUCTHAM  VARCHAR2(255);
  ----------------
  v_arrCongvan VARCHAR2(500);v_count_cv NUMBER;v_count_yk NUMBER;V_YKien VARCHAR2(1000);
  -------
    type array_t is varray(3) of number;V_EXPORT_TEXT_TITLE CLOB;
    array array_t := array_t(0,1,2);  v_isTTToTrinh NUMBER;v_isTTMuonHS NUMBER;v_title_group VARCHAR2(255);
    CountAll_SS number:=0;v_stt number:=0; v_vLanhdao_ten VARCHAR2(250):=NULL;v_tbtt  VARCHAR2(1000);v_count_ttbt number:=0;
    v_tt_arr number:=0;v_colspan VARCHAR2(250);
BEGIN
   DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
   DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT_TITLE,true);  DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT_ITEM,true);
    -----
  SELECT DECODE(vngaythulyden,null,sysdate,to_date(to_char(vngaythulyden,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS')) into vvngaythulyden from dual;
  -- vvTuNgay:=to_date('01/01/2019 00:00:00','dd/MM/yyyy  hh24:mi:ss');vvDenNgay:=to_date('31/12/2019 23:59:59','dd/MM/yyyy  hh24:mi:ss');
  v_table_tp := T_TINHTRANG();  v_table_all := T_TINHTRANG(); 
  -------------------------
  if(vThamphan !=0 and vThamphan is not null) then
          select b.Ma  into ma_chucvu  from DM_CanBo a left join DM_DataItem b on a.ChucVuID = b.ID where a.Id = vThamphan;
           if  (ma_chucvu='PCA' OR ma_chucvu='CA')then 
               curr_thamphan_id:=0;
                 ---------lấy loại án khi thẩm phán chọn ô tổng (nghĩa là không xác định được loại án) của form login sẽ lấy những loại án theo năm truyền vào
                       SELECT  LISTAGG(TTS.LOAIAN_ID, ',') WITHIN GROUP (ORDER BY TTS.LOAIAN_ID) INTO vvloaian  FROM (
                                    SELECT LA.LOAIAN_ID,LA.LOAIAN_TEN FROM  (
                                    SELECT DECODE(TT.COL_LOAIAN,'ISHINHSU',1,'ISDANSU',2,'ISHNGD',3,'ISKDTM',4,'ISLAODONG',5,'ISHANHCHINH',6)LOAIAN_ID,
                                    DECODE(TT.COL_LOAIAN,'ISHINHSU','HÌNH SỰ','ISDANSU','DÂN SỰ','ISHNGD','HÔN NHÂN VÀ GIA ĐÌNH','ISKDTM','KINH DOANH, THƯƠNG MẠI','ISLAODONG','LAO ĐỘNG','ISHANHCHINH','HÀNH CHÍNH')LOAIAN_TEN
                                    FROM (
                                            SELECT * FROM (SELECT PB.ISHINHSU,PB.ISDANSU, PB.ISHNGD,PB.ISKDTM,PB.ISHANHCHINH,PB.ISLAODONG FROM DM_CanBo 
                                            PB WHERE PB.Id = vThamphan
                                         )
                                    UNPIVOT --chuyển từ cột thành dòng
                                    (CHECK_LOAIAN for COL_LOAIAN in (ISHINHSU, ISDANSU, ISHNGD, ISKDTM,ISHANHCHINH,ISLAODONG) )
                                    )TT WHERE CHECK_LOAIAN=1 
                                )LA   WHERE LA.LOAIAN_ID IS NOT NULL  
                               GROUP BY LA.LOAIAN_ID,LA.LOAIAN_TEN 
                 )TTS;
                       -----------------------------------------------
            ELSE
                curr_thamphan_id:= vThamphan;
            end if;
      else
      curr_thamphan_id:=0;
  end if;
         -----Bao cao TTP,HDTP,CA,PCA---------------
         IF(vTrangthai=-1)THEN
            vTrangthai_s:='7,8,9,17';
         ELSE
         vTrangthai_s:=vTrangthai;
         END IF;
         ------------------------
  if (vSoBAQD || ' ') <> ' ' then  
    temp_sobanan := Replace(Replace(Replace(lower(vSoBAQD), ' ', ''), '_',''), '-','');
  else 
    temp_sobanan := vSoBAQD;
  end if;
    -----Thẩm phán---------------
        IF(vPhongBanID=0) THEN
               PKG_GDTTT_BAOCAO_APP.GDTTTT_QLTOTRINH_TP(
                                              vThamphan,vToaAnID,0,vLoaiAn,--vThamphanID,vToaAnID,vPhongBanID,vLoaiAn
                                              null,vNgayThulyDen,--tt_tungay,tt_denngay
                                              V_CURSOR);
                  LOOP 
                  FETCH V_CURSOR 
                        INTO   LOAIAN_ID,LOAIAN_TEN,VUANID,LANHDAOID,TINHTRANGID,NGAYTRA,TOTRINH_ID,NGAYTRINH,ISCAPTRINHTIEP,THUTU_CAPTRINH;
                        EXIT WHEN V_CURSOR%NOTFOUND;
                         v_table_tp.extend;
                         v_table_tp(v_table_tp.count) := R_TINHTRANG(
                                     LOAIAN_ID,LOAIAN_TEN,VUANID,LANHDAOID,TINHTRANGID,NGAYTRA,TOTRINH_ID,NGAYTRINH,ISCAPTRINHTIEP,THUTU_CAPTRINH
                                    );
                  END LOOP;    
                  CLOSE V_CURSOR;  
         END IF;
       ----------------------------------------tạo du lieu cac cap trinh chuyển vào bảng 
                  PKG_GDTTT_BAOCAO_APP.GDTTTT_QLTOTRINH_ALL(
                                  vToaAnID,vPhongBanID,vLoaiAn,--vToaAnID,vPhongBanID,vLoaiAn
                                  null,vNgayThulyDen,--tt_tungay,tt_denngayto_date
                                  V_CURSOR);
                  LOOP 
                  FETCH V_CURSOR 
                       INTO   LOAIAN_ID_ALL,LOAIAN_TEN_ALL,VUANID_ALL,LANHDAOID_ALL,TINHTRANGID_ALL,NGAYTRA_ALL,TOTRINH_ID_ALL,NGAYTRINH_ALL,ISCAPTRINHTIEP_ALL,THUTU_CAPTRINH_ALL;
                        EXIT WHEN V_CURSOR%NOTFOUND;
                         v_table_all.extend;
                         v_table_all(v_table_all.count) := R_TINHTRANG(
                                     LOAIAN_ID_ALL,LOAIAN_TEN_ALL,VUANID_ALL,LANHDAOID_ALL,TINHTRANGID_ALL,NGAYTRA_ALL,TOTRINH_ID_ALL,NGAYTRINH_ALL,ISCAPTRINHTIEP_ALL,THUTU_CAPTRINH_ALL
                                    );
                  END LOOP;    
                  CLOSE V_CURSOR;  
       ---------------------------------
    -------TẠO BÁO CÁO
    SELECT DECODE(vLoaiAn,01,'Tội danh','Quan hệ pháp luật') INTO vLoaiAn_name FROM DUAL;
    SELECT DECODE(vLoaiAn,01,'10','11') INTO v_colspan FROM DUAL;
    ------
    v_isTTToTrinh:=isTTToTrinh;
    v_isTTMuonHS:=isTTMuonHS;
   FOR I IN 1..ARRAY.COUNT      
    LOOP
    CountAll_S:=0;
    IF(ARRAY(I)= 0)THEN
      v_isTTToTrinh:=1;v_title_group:='CÁC VỤ ĐÃ CÓ TỜ TRÌNH';
      v_isTTMuonHS:=1;
    ELSIF(ARRAY(I)= 1)THEN  
      v_isTTToTrinh:=0;
      v_isTTMuonHS:=0;v_title_group:='CÁC VỤ CHƯA CÓ HỒ SƠ';
     ELSIF(ARRAY(I)= 2)THEN  
      v_isTTToTrinh:=0;v_title_group:='CÁC VỤ ĐÃ CÓ HỒ SƠ NHƯNG CHƯA CÓ TỜ TRÌNH';
      v_isTTMuonHS:=1;
    END IF;
      DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT_ITEM,true);
    -----------------
      FOR item IN (
        WITH HD1 as (select hd.VUANID,DECODE(hd.TYPEHD,1,'<br/><span style="">Hội đồng: <b> Toàn thể</b></span>',2,'<br/><span style="">Hội đồng: <b> 5</b></span>','')HOIDONGXX from GDTTT_VUAN_XXGDTT_HOIDONG hd GROUP BY hd.VUANID, hd.TYPEHD)
          ,HD2 as (select hd.VUANID,DECODE(hd.TENCANBO,NULL,NULL,'<br/><span style="">Chủ tọa: <b>'||hd.TENCANBO||'</b></span>')TEN_CHUTOA,hd.CANBOID from GDTTT_VUAN_XXGDTT_HOIDONG hd WHERE hd.ISCHUTOA=1)
          select a.* ,'' arrDONID , '' arrCV81ID   , '' arrCHIDAOID
                    from (
                    Select  COUNT(1) OVER () as CountAll,
                    ROW_NUMBER() OVER (ORDER BY CASE WHEN V_ASC_DESC = 'ASC' AND V_COLUME = 'NGAYTHULYDON' THEN V.NGAYTHULYDON END, CASE WHEN V_ASC_DESC = 'DESC' AND V_COLUME = 'NGAYTHULYDON' THEN V.NGAYTHULYDON END DESC,CASE WHEN V_ASC_DESC = 'ASC' AND V_COLUME = 'TENTHAMTRAVIEN' THEN ttv.HOTEN END,CASE WHEN V_ASC_DESC = 'DESC' AND V_COLUME = 'TENTHAMTRAVIEN' THEN ttv.HOTEN END DESC
                                      ) STT   
                      , NVL(v.TongDon,0 ) as TongDon 
                      ,DECODE(AQH.VuViecID,NULL,0,1)SoCV81--NVL(v.IsAnQuocHoi, 0) as SoCV81,
                      ,DECODE(AQH_F.VuViecID,NULL,NULL,'X')CV93
                      ,NVL(v.IsAnChiDao, 0) as IsAnChiDao 
                       , v.ID, v.LoaiAn,v.MAVUAN,DD.LISTHULYDON  
                        ,(select count(id) from gdttt_don d where d.VUVIECID = v.id and d.isthuly= 1 and CD_TRANGTHAI = 2) cThulymoi
                       , v.SOTHULYDON,to_char(v.NGAYTHULYDON,'dd/MM/yyyy')NGAYTHULYDON , v.NGUYENDON,v.BIDON
                       ,DECODE(v.TRUONGHOPTHULY,1,'<b>Kháng nghị của VKS</b>',2,'<b>Rút Hồ sơ đoàn kiểm tra</b>',3,'<b>Chủ động GĐT qua Bản án</b>',NVL(v.ARRNGUOIKHIEUNAI,v.NGUOIKHIEUNAI)) NGUOIKHIEUNAI
                        ,DECODE(v.BAQD_CAPXETXU,4,v.so_qdgdt,3,v.SOANPHUCTHAM,2,v.SOANSOTHAM,v.SOANPHUCTHAM) SOANPHUCTHAM
                        ,DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')) NGAYXUPHUCTHAM
                        ,DECODE(v.BAQD_CAPXETXU,4,DM_CanBo_TenToaVT(tqd.Ma_Ten),2,DM_CanBo_TenToaVT(tst.Ma_Ten),DM_CanBo_TenToaVT(txx.Ma_Ten)) TOAXX_VietTat
                        ,DECODE(v.BAQD_CAPXETXU,4,tqd.Ma_Ten,2,tst.Ma_Ten,txx.Ma_Ten) ToaXX
                 --manhnd
                      , case when BAQD_CAPXETXU = 4 
                                        then NVL(v.SO_QDGDT, NVL(v.SO_QDGDT, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NGAYQD,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYQD,'dd/MM/yyyy'))||
                                             '<br/>'|| DM_CanBo_TenToaVT(tqd.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-GĐT)</i>'||
                                              decode (v.SOANPHUCTHAM,null,'',' ','','<br/><br/>'||v.SOANPHUCTHAM||'<br/>'||to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')||
                                                        '<br/>'||DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>')||
                                              decode (v.SoAnSoTham,null,'',' ','','<br/>'||v.SoAnSoTham||'<br/>'||to_char(v.NgayXuSoTham,'dd/MM/yyyy')||
                                                    '<br/>'||DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)')
                             when BAQD_CAPXETXU = 3  then
                                             NVL(v.SOANPHUCTHAM, NVL(v.SOANPHUCTHAM, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))||
                                             '<br/> '|| DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>'||
                                              decode (v.SoAnSoTham,null,'',' ','','<br/><br/>'||v.SoAnSoTham||'<br/>'||to_char(v.NgayXuSoTham,'dd/MM/yyyy')||
                                              '<br/> '||DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>')

                             when BAQD_CAPXETXU = 2 
                                        then NVL(v.SoAnSoTham, NVL(v.SoAnSoTham, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NgayXuSoTham,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NgayXuSoTham,'dd/MM/yyyy'))||
                                             '<br/>'|| DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>'
                             else
                                            NVL(v.SOANPHUCTHAM, NVL(v.SoAnSoTham, ''))
                                            ||'<br/>'|| decode(to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'),null,to_char(v.NgayXuSoTham,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))
                                            ||'<br/> '|| DM_CanBo_TenToaVT(NVL(txx.Ma_Ten, tst.Ma_Ten ))        
                             end InforBA
                      --

                         ,qhpl.TENQHPL QHPLDN
                         ,case when NguyenDon is not null then NVL(qhpl.TENQHPL, Replace(v.TenVuAn,(NguyenDon ||' - ')))
                               when NguyenDon is null and BiDon is not null  then NVL(qhpl.TENQHPL, Replace(v.TenVuAn,(BiDon ||' - ')))
                            end as QHPNDN_Report
                        ,tp.HOTEN as TENTHAMPHAN
                        ,ttv.HOTEN TENTHAMTRAVIEN
                        , case when (Length(NVL(v.NGAYPHANCONGTTV,''))=0 or (to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(v.NGAYPHANCONGTTV,'')) >0 then to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy')
                            end  NGAYPHANCONGTTV
                        , ld.HOTEN as TENLANHDAO   

                        , cv.Ten ChucVuLanhDao   , cv.Ma MaChucVuLD  , v.GHICHU,v.NGUOITAO ,to_char(v.NGAYTAO,'dd/MM/yyyy HH24:MI') NGAYTAO, v.NGUOISUA,to_char(v.NGAYSUA,'dd/MM/yyyy HH24:MI') NGAYSUA   
                         ----------anhvh 12/10/2019 
                        ,CASE WHEN  (vtrangthai >=4 OR vtrangthai=-1) THEN TA.TINHTRANGID ELSE v.TRANGTHAIID END TRANGTHAIID
                        ,CASE WHEN   (vtrangthai >=4 OR vtrangthai=-1)  THEN tts.TenTinhTrang ELSE tt.TenTinhTRang END TenTinhTrang
                        ,CASE WHEN   (vtrangthai >=4 OR vtrangthai=-1) AND vKetquathuly =4  THEN tts.GiaiDoan ELSE NVL(tt.GiaiDoan,0) END GiaiDoanTrinh
                         ---------
                        ,case when  NVL(v.GQD_LOAIKETQUA,3)<> 1 then v.QUATRINH_GHICHU
                            when NVL(v.GQD_LOAIKETQUA,3) =1 then (u'Kháng nghị '||DECODE( NVL(v.IsVienTruongKN,0), 0, '(CA)', 1, 'VKS'))  end QUATRINH_GHICHU
                        , v.GDQ_SO 
                        , case  when (Length(NVL(v.GDQ_NGAY,''))=0 or (to_char(v.GDQ_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(v.GDQ_NGAY,'')) >0 then to_char(v.GDQ_NGAY,'dd/MM/yyyy')  end  GDQ_NGAY
                          , case when NVL(v.LoaiAn, 0)<>1 then ''
                                else (SELECT LISTAGG(cast(dt.So as varchar2(10))||case when (Length(NVL(dt.Ngay,''))=0   or (to_char(dt.Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                                                                                       when Length(NVL(dt.Ngay,'')) >0 then ' - '||to_char(dt.Ngay,'dd/MM/yyyy')  end , ',<br/>'
                                                     )
                                       WITHIN GROUP (ORDER BY dt.So asc, dt.Ngay asc) FROM GDTTT_DON_TRALOI dt  
                                       WHERE  dt.VuAnID=v.ID and dt.TypeTB=3
                                     )
                                end as AHS_ThongTinGQD
                        , NVL(v.GQD_LOAIKETQUA,5) KQ_GQD_ID
                        --anhvh edit
                        , DECODE(v.GQD_LOAIKETQUA,3,v.GQD_KETQUA, 2,u'X\1ebfp \0111\01a1n' , 1, u'Kh\00e1ng ngh\1ecb', 0,u'Tr\1ea3 l\1eddi \0111\01a1n',v.GQD_KETQUA ) KQ_GQD
                        ,CASE WHEN v.GQD_LOAIKETQUA=3 or v.GQD_LOAIKETQUA=4 THEN v.GQD_KETQUA
                            WHEN NVL(v.GQD_LOAIKETQUA,5) = 5 then null
                            else DECODE(v.GQD_LOAIKETQUA,0,'TLĐ',1,'KN',2,'XĐ')||'-'||DECODE(v.LoaiAn,1,'HS',2,'DS',3,'KDTM',4,'LĐ',5,'HC')
                     || ' Số: '||translate(v.GDQ_SO using nchar_cs)|| ' Ngày: '||to_char(V.GDQ_NGAY,'dd/MM/yyyy')
                     end KQ_GQDS
                        , NVL(v.IsVienTruongKN,0) IsVienTruongKN
                        , case when NVL(v.GQD_LOAIKETQUA,3)<> 1 then ''
                                when NVL(v.GQD_LOAIKETQUA,3)=1 
                                     then DECODE( NVL(v.IsVienTruongKN,0), 0, '(CA)', 1, 'VKS')  end LoaiKN   
                        , NVL(v.GQD_SoCV , '') GQD_SoCV
                        , case when (Length(NVL(v.GQD_NgayPhatHanhCV,''))=0 or (to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(v.GQD_NgayPhatHanhCV,'')) >0 then to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy') end  GQD_NgayPhatHanhCV  
                        , NVL(v.GQD_IsHoanTHA, 0) GQD_IsHoanTHA,NVL( v.GQD_HoanTHA_So ,'') GQD_HoanTHA_So
                        , case when (Length(NVL(v.GQD_HoanTHA_Ngay,''))=0 or (to_char(v.GQD_HoanTHA_Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(v.GQD_HoanTHA_Ngay,'')) >0 then to_char(v.GQD_HoanTHA_Ngay,'dd/MM/yyyy')   end  GQD_HoanTHA_Ngay  
                        , NVL( v.GQD_HoanTHA_TenNguoiKy ,'') GQD_HoanTHA_TenNguoiKy 
                        -------------------------------
                        , NVL(v.IsHoSo,0) IsHoSo, NVL(v.HoSoID,0)
                        , case when (Length(NVL(hs.NgayTao,''))=0 or (to_char(hs.NgayTao,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(hs.NgayTao,'')) >0 then to_char(hs.NgayTao,'dd/MM/yyyy')  end  NgayTTVNhanHS
                        , v.NGAYTTVNHAN_THS,NVL(v.IsToTrinh,0) IsToTrinh , NVL(v.ISANTRAODOICV,0)  ISANTRAODOICV , v.SOTHULYXXGDT
                        , case when (Length(NVL(v.NGAYTHULYXXGDT,''))=0 or (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') ='01/01/0001')) then ''
                               when Length(NVL(v.NGAYTHULYXXGDT,'')) >0 then to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy')  end  NGAYTHULYXXGDT
                        , case when (Length(NVL(v.XXGDTTT_NGAYVKSTRAHS,''))=0 or (to_char(v.XXGDTTT_NGAYVKSTRAHS,'dd/MM/yyyy') ='01/01/0001')) then ''
                               when Length(NVL(v.XXGDTTT_NGAYVKSTRAHS,'')) >0 then to_char(v.XXGDTTT_NGAYVKSTRAHS,'dd/MM/yyyy')  end  XXGDTTT_NGAYVKSTRAHS
                        , NVL(v.XXGDTTT_ISHOANPT, 0) XXGDTTT_ISHOANPT 
                         , case when (Length(NVL(v.XXGDTTT_NGAYHOAN,''))=0 or (to_char(v.XXGDTTT_NGAYHOAN,'dd/MM/yyyy') ='01/01/0001')) then ''
                                       when Length(NVL(v.XXGDTTT_NGAYHOAN,'')) >0 then to_char(v.XXGDTTT_NGAYHOAN,'dd/MM/yyyy')  end  XXGDTTT_NGAYHOAN
                        , NVL(v.XXGDTTT_LYDOHOAN, '') XXGDTTT_LYDOHOAN,v.XXGDTTT_SOQD
                         , case when (Length(NVL(v.XXGDTTT_NGAYQD,''))=0 or (to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') ='01/01/0001')) then ''
                                       when Length(NVL(v.XXGDTTT_NGAYQD,'')) >0 then to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') end  XXGDTTT_NGAYQD
                        , case when (Length(NVL(v.NGAYXUGIAMDOCTHAM,''))=0 or (to_char(v.NGAYXUGIAMDOCTHAM,'dd/MM/yyyy') ='01/01/0001')) then ''
                                       when Length(NVL(v.NGAYXUGIAMDOCTHAM,'')) >0 then to_char(v.NGAYXUGIAMDOCTHAM,'dd/MM/yyyy')   end  NGAYXUGIAMDOCTHAM
                        , NVL(kq.Ten,' ') KetQuaXXGDT, NVL(v.IsRutKN,0) IsRutKN , NVL(v.SORUTKN, '') SORUTKN
                        , case when (Length(NVL(v.NGAYRUTKN,''))=0 or (to_char(v.NGAYRUTKN,'dd/MM/yyyy') ='01/01/0001')) then ''
                               when Length(NVL(v.NGAYRUTKN,'')) >0 then to_char(v.NGAYRUTKN,'dd/MM/yyyy') end  NGAYRUTKN,HD1.HOIDONGXX,HD2.TEN_CHUTOA
                         ,TTVSS.PHANCONGTTV
                         ,v.TRUONGHOPTHULY
                      from GDTTT_VUAN v 
                      left join DM_TOAAN txx on v.TOAPHUCTHAMID=txx.ID
                      left join DM_TOAAN tst on v.TOAANSOTHAM=tst.ID
                      left join DM_TOAAN tqd on v.TOAQDID=tqd.ID
                      left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
                      left join DM_CANBO tp on v.THAMPHANID=tp.ID
                      left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
                      left join DM_CANBO ld on ld.ID = decode (NVL(v.XXGDT_LANHDAOVUID,0),0,v.LANHDAOVUID,v.XXGDT_LANHDAOVUID)
                      left join DM_CANBO ldxx on v.XXGDT_LANHDAOVUID=ldxx.ID
                      left join DM_DataITem cv on ld.ChucVuID = cv.ID
                      left join GDTTT_DM_TINHTRANG tt on tt.ID= NVL(v.TRANGTHAIID,1)
                      left join DM_DAtaItem kq on kq.ID = v.XXGDTTT_KETQUAID
                      left join (Select ID, NgayTao from GDTTT_QUanLyHS where Loai=3) hs on hs.ID = NVL(v.HoSoID,0)
                      ----anhvh
                      left join HD1 ON HD1.VUANID=v.ID
                      left join HD2 ON HD2.VUANID=v.ID
                      LEFT JOIN TABLE(v_table_all) TA ON TA.VUANID=V.ID
                      LEFT JOIN GDTTT_DM_TINHTRANG tts on tts.ID= TA.TINHTRANGID
                      --anhvh add 21/11/2019 check ngày của vụ và ngày công văn dùng cho việc truy vấn phía dưới
                      LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                          END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                      --anhvh--án quốc hội gồm công văn 8.1 và 9.3
                      LEFT JOIN (select D.VuViecID from GDTTT_DON d 
                                WHERE d.LOAICONGVAN in(Select I.ID from DM_DATAITEM I where (I.ID=546 OR I.CAPCHAID=546 OR I.ID = 1023 OR I.CAPCHAID=1023))
                                GROUP BY d.VuViecID)AQH ON AQH.VuViecID=V.ID
                      --anhvh edit-30/03/2020 thêm cột theo ý kiến của chú Hào lấy theo 9.3
                        LEFT JOIN (select D.VuViecID from GDTTT_DON d 
                                 WHERE d.LOAICONGVAN in(Select I.ID from DM_DATAITEM I where (I.ID=546 OR I.CAPCHAID=546))
                                 AND EXISTS (--chỉ lấy chánh án và phó chánh an
                                    SELECT C.ID,C.HOTEN FROM DM_CANBO C
                                    WHERE EXISTS(SELECT dt.ID, dt.ten FROM dm_dataitem dt WHERE dt.ma IN ('CA', 'PCA')  AND dt.groupid =13 AND dt.ID=C.chucvuid)
                                    AND C.TOAANID=1 AND C.HIEULUC=1 
                                    AND C.ID=D.CHIDAO_LANHDAOID 
                                     )
                                  GROUP BY d.VuViecID
                                  )AQH_F ON AQH_F.VuViecID=V.ID
                   ----anhvh add 31/03/2020 lấy tất cả thẩm tra viên đã được phân công
                   LEFT JOIN (
                        SELECT TTVS.VUANID,LISTAGG(TTVS.HOTEN, '<br/>') WITHIN GROUP (ORDER BY TTVS.STT  DESC)PHANCONGTTV
                          FROM (
                               SELECT TT.VUANID,TT.HOTEN,TT.STT FROM (
                                    SELECT VV.ID VUANID,'<b>'||TO_CHAR(TTV.HOTEN)|| DECODE(VV.XXGDT_NGAYPHANCONGTTV,null,DECODE(VV.NGAYPHANCONGTTV,NULL,NULL,' ('||To_char(VV.NGAYPHANCONGTTV,'dd/MM/yyyy')||')'),DECODE(VV.XXGDT_NGAYPHANCONGTTV,NULL,NULL,' ('||To_char(VV.XXGDT_NGAYPHANCONGTTV,'dd/MM/yyyy')||')'))||'</b>' HOTEN,1 STT FROM GDTTT_VUAN VV 
                                    LEFT JOIN DM_CANBO TTV ON DECODE(VV.XXGDT_THAMTRAVIENID,null,VV.THAMTRAVIENID,VV.XXGDT_THAMTRAVIENID)=TTV.ID
                                 UNION ALL    
                                 -- Can lay dung Lich su cua giai doan
                                   SELECT SS.VUANID,SS.HOTEN,SS.STT FROM (
                                        SELECT A.VUANID,'<i>'||TO_CHAR(b.HOTEN)||' ('||To_char(DECODE(a.TUNGAY,NULL,VS.NGAYPHANCONGTTV,a.TUNGAY),'dd/MM/yyyy')||')</i>'HOTEN,0 STT FROM GDTTT_VUAN_PHANCONGCB_HISTORY A
                                        LEFT JOIN GDTTT_VUAN VS ON VS.ID=A.VUANID
                                        INNER JOIN DM_CanBo b on a.CanBoID = b.ID
                                        WHERE a.Loai=1 
                                        ORDER BY DECODE(a.TUNGAY,NULL,VS.NGAYPHANCONGTTV,a.TUNGAY) DESC
                                    )SS
                                )TT GROUP BY TT.VUANID,TT.HOTEN,TT.STT
                            )TTVS GROUP BY TTVS.VUANID
                         )TTVSS ON TTVSS.VUANID=V.ID
                      ---lấy danh sách thụ lý đơn anhvh add 31/03/2020        
                      LEFT JOIN (
                        SELECT CV.VUVIECID,LISTAGG(CASE WHEN LENGTH(NVL(CV.TL_SO, ''))>0 THEN ('Số ' || CV.TL_SO ) ELSE '' END
                                      || CASE WHEN LENGTH(NVL(CV.TL_NGAY, ''))>0 THEN (' - ' || TO_CHAR(CV.TL_NGAY,'dd/MM/yyyy') ) ELSE '' END                         
                                , ',<br/>')
                            WITHIN GROUP (ORDER BY CV.TL_NGAY DESC, CV.NGAYTAO DESC)LISTHULYDON            
                            FROM GDTTT_DON CV  
                            WHERE  CV.CD_TRANGTHAI=2 AND CV.ISTHULY=1
                            GROUP BY CV.VUVIECID
                        )DD ON DD.VUVIECID=v.ID
                        -----
                      where  v.TOAANID=vToaAnID 
                            And (NVL(vPhongBanID,0)=0 Or v.PhongBanID=vPhongBanID)
                            And NVL(V.ISVIENTRUONGKN,0) = 0
                            And (NVL(vloaian,0) = 0 Or vloaian = v.LOAIAN) 
                            -- Chưa có kết quả đến ngày 
                            And v.NGAYTAO<=vvngaythulyden 
                            And ((v.gqd_loaiketqua in (0,1,2,3,4) and VA.GQD_NGACVS> vvngaythulyden  AND VA.GQD_NGACVS IS NOT NULL) 
                                            OR v.gqd_loaiketqua IS NULL ) 
                              -- Thuộc án
                              and ( LoaiAnDB = 0
                                    or (LoaiAnDB = 1 
                                         --án quốc hội gồm công văn 8.1 và 9.3
                                         AND EXISTS(select 'X' from GDTTT_DON d 
                                                                        where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                                        AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                                        GROUP BY d.VuViecID) 
                                       )
                                    or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)   
                                    or(LoaiAnDB = 3  AND AQH_F.VuViecID IS NOT NULL)
                               )
               )a
       )
    LOOP
    -------TẠO DỮ LIỆU CỦA BÁO CÁO
    CountAll_S:=item.CountAll;
    v_stt:=v_stt+1;
    SELECT DECODE(SUBSTR(item.SOANPHUCTHAM,0,INSTR(item.SOANPHUCTHAM, '/',1,2)-1),NULL,SUBSTR(item.SOANPHUCTHAM,0,INSTR(item.SOANPHUCTHAM, '/',1,1)-1),SUBSTR(item.SOANPHUCTHAM,0,INSTR(item.SOANPHUCTHAM, '/',1,2)-1)) INTO V_SOANPHUCTHAM FROM DUAL;
    SELECT COUNT(*) INTO v_count_cv FROM GDTTT_DON D WHERE D.VUVIECID=item.ID  and (d.CV_SO is not null or d.CV_TENDONVI is not null);
    IF(v_count_cv>0)THEN
        SELECT ( Case d.LOAIDON when 3 then (' - Công văn số ' || d.CV_SO || ' ngày ' || TO_CHAR(d.CV_NGAY,'dd/MM/yyyy')||' của '|| TO_CHAR(d.CV_TENDONVI)) else '' End) 
        INTO v_arrCongvan FROM GDTTT_DON D WHERE D.VUVIECID=item.ID  and (d.CV_SO is not null or d.CV_TENDONVI is not null)
        FETCH FIRST 1 ROWS ONLY;
    END IF;
        -----------------
        Select  count(*) into v_count_ttbt  from GDTTT_DON d 
        inner join ( select Max(ID) DONID,CV_TENDONVI from GDTTT_DON  
        where vUVIECID=item.ID and NVL(CD_TRANGTHAI, 4)=2  Group By CV_TENDONVI ) g on g.DONID=d.ID   
        where NVL(d.CD_TRANGTHAI, 4)=2 
        and d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023);
        ------
        if(v_count_ttbt>0) then
            SELECT DECODE(TT.So,NULL,DECODE(tt.Ngay,NULL,NULL,'<br/>- Thông báo tình thế số ***** '|| tt.Ngay),'<br/>- Thông báo tình thế số '||TT.So || tt.Ngay) into v_tbtt FROM (
                Select  NVL(t.So,'') So ,case when (Length(NVL(t.Ngay,''))=0 or (to_char(t.Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                           when Length(NVL(t.Ngay,'')) >0 then ' Ngày '||to_char(t.Ngay,'dd/MM/yyyy')
                        end as Ngay 
                from GDTTT_DON d 
                inner join ( select Max(ID) DONID,CV_TENDONVI from GDTTT_DON  
                         where vUVIECID=item.ID and NVL(CD_TRANGTHAI, 4)=2  Group By CV_TENDONVI ) g on g.DONID=d.ID      
                left join (select ID, DonID, VuAnID, So,Ngay, GhiChu, NguoiNhan from GDTTT_Don_TraLoi 
                     where TypeTB=1 and  VuAnID=item.ID) t on t.DonID= d.ID
                where NVL(d.CD_TRANGTHAI, 4)=2 
                and d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                Order by d.NgayNhanDon desc, d.NgayGhiTrenDon desc
            )TT FETCH FIRST 1 ROWS ONLY;
        END IF;
   ------------
        SELECT count(*) into v_count_yk  FROM GDTTT_TOTRINH t
        inner join GDTTT_DM_TINHTRANG d on d.ID=t.TINHTRANGID
        left join GDTTT_DM_TINHTRANG ct on ct.ID = t.CAPTRINHTIEP
        left join DM_CANBO c on c.ID=t.LANHDAOID
        WHere t.VUANID=item.ID--1187938--4583--1183805 
         AND ((t.NGAYTRINH<=vNgayThulyDen and vNgayThulyDen IS NOT NULL)
                  OR (t.NGAYTRINH<=SYSDATE AND vNgayThulyDen IS NULL))
        FETCH FIRST 1 ROWS ONLY;
    IF(v_count_yk>0)THEN
          SELECT REPLACE(RTRIM(TT.YKien,': '),'Trả lời đơn','TLD') INTO V_YKien
            FROM (
            SELECT '- '||d.TENTINHTRANG||'<br/> '||DECODE(c.chucvuid,74,'PCA',c.HOTEN) 
            ||' duyệt '
            ||'ngày '|| to_char(t.NgayTrinh,'dd/MM/yyyy') 
            || ': '||DECODE(NVL(t.YKien, ''),NULL,Decode(NVL(t.LoaiYKien,11), 0, 'Trả lời đơn',1,'Kháng nghị', 3,'Xếp đơn'
                                               , 10,'Nghiên cứu lại, xác minh, bổ sung', 11, '' )
                                               ,NVL(t.YKien, '')) YKien
            FROM GDTTT_TOTRINH t
            inner join GDTTT_DM_TINHTRANG d on d.ID=t.TINHTRANGID
            left join GDTTT_DM_TINHTRANG ct on ct.ID = t.CAPTRINHTIEP
            left join DM_CANBO c on c.ID=t.LANHDAOID
            WHere t.VUANID=item.ID--1187938--4583--1183805 
            AND ((t.NGAYTRINH<=vNgayThulyDen and vNgayThulyDen IS NOT NULL)
                  OR (t.NGAYTRINH<=SYSDATE AND vNgayThulyDen IS NULL))
            order by t.NGAYTRINH desc,d.ThuTu desc
            FETCH FIRST 1 ROWS ONLY
         )TT;
     END IF;
    -----------------
      DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
         <tr style="font-size: 11pt;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_stt||'</td>               
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||V_SOANPHUCTHAM||'<br />'||SUBSTR(item.SOANPHUCTHAM,INSTR(item.SOANPHUCTHAM, '/',-1))||'<br/>'||item.NGAYXUPHUCTHAM||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TOAXX_VietTat||'</td>                
        ');  
        if(vLoaiAn=01)THEN--vLoaiAn=01 là hình sự
                IF(item.NGUYENDON=item.BIDON)THEN
                  V_BIDON_CHECK:=item.NGUYENDON;
                ELSIF(item.NGUYENDON!=item.BIDON AND item.NGUYENDON !='' AND item.BIDON!='') THEN
                  V_BIDON_CHECK:=item.NGUYENDON||', <br/>'||item.BIDON;
                ELSE
                 V_BIDON_CHECK:=replace(item.NGUYENDON||item.BIDON,',','');
                END IF;
               DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.QHPNDN_Report||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||V_BIDON_CHECK||'</td>          
                ');
          else
               DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
               <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.QHPLDN||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.NGUYENDON||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.BIDON||'</td>
                ');
          end if;
          DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||to_char(item.NGAYTTVNHAN_THS,'dd/MM/yyyy')||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.NgayTTVNhanHS||'</td>
                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||v_arrCongvan||'</td> 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TenThamTraVien||'</td>
                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||V_YKien||v_tbtt||'</td>
            </tr>
        ');
  END LOOP;
      IF(CountAll_S>0) THEN
      v_tt_arr:=v_tt_arr+1;
      --V_EXPORT_TEXT_TITLE-- tiêu đề theo từng nhóm
    DBMS_LOB.APPEND(V_EXPORT_TEXT_TITLE,'
             <tr style="font-weight:bold;background-color:#e1dfdf;">
                <td colspan="'||v_colspan||'" style="height: 15pt;text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||v_tt_arr||'. '||v_title_group||'</td>
            </tr>
             <tr style="font-weight:bold;background-color:#e1dfdf;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; height: 50pt;">STT</td>
                 <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Bản án
                    <br />
                    số và ngày</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Tòa án xử</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||vLoaiAn_name||'</td>
                 '); 
            if(vLoaiAn=01)THEN
             DBMS_LOB.APPEND(V_EXPORT_TEXT_TITLE,' 
              <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Bị cáo</td>             
            ');   
            ELSE
              DBMS_LOB.APPEND(V_EXPORT_TEXT_TITLE,'    
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Nguyên đơn/ Người khởi kiện</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Bị đơn/ Người bị kiện</td>
               ');   
            END IF;
             DBMS_LOB.APPEND(V_EXPORT_TEXT_TITLE,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ngày nhận THS</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ngày nhận HS</td>
                 <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">CV quốc hội</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thẩm tra viên</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ghi chú</td>
            </tr>
            '); 
       CountAll_SS:=CountAll_SS+CountAll_S;
       DBMS_LOB.APPEND(V_EXPORT_TEXT_TITLE,V_EXPORT_TEXT_ITEM);
      END IF;
    END LOOP;
     IF(vLanhdao!=0)THEN
            SELECT '<br/><span style="font-weight:100">Lãnh đạo phụ trách: '||cb.HOTEN||'</span>' INTO v_vLanhdao_ten FROM DM_CANBO cb WHERE ID=vLanhdao;
           -- FETCH FIRST 1 ROWS ONLY;
    END IF;
    -----------
        --Insert số trang
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
      <div style="mso-element: footer" id="f1">
            <w:sdt sdtdocpart="t"
            docparttype="Page Numbers (Bottom of Page)" docpartunique="t" id="644013658">
            <p class=MsoFooter align=right style="text-align:right"><!--[if supportFields]><span
            style="mso-element:field-begin"></span><span
            style="mso-spacerun:yes"> </span>PAGE<span style="mso-spacerun:yes">  
            </span>\* MERGEFORMAT <span style="mso-element:field-separator"></span><![endif]--><span
            style="mso-no-proof:yes;display:none">2</span><!--[if supportFields]><span
            style="mso-no-proof:yes"><span style="mso-element:field-end"></span></span><![endif]--><w:sdtPr></w:sdtPr></p>
            </w:sdt>
            <p class="MsoFooter" align="right" style="text-align: right;"><o:p></o:p> </p>
      </div>');
       DBMS_LOB.APPEND(V_EXPORT_TEXT,'
          <table cellpadding="1" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;">
            <tr>
                <td colspan="'||v_colspan||'" style="height: 0pt;"></td>
            </tr>
            <tr>
                <td colspan="'||v_colspan||'" style="line-height: 100%; font-size: 14pt"><b>DANH SÁCH ÁN QUỐC HỘI CHUYỂN ĐƠN CHƯA CÓ KẾT QUẢ GIẢI QUYẾT '||v_vLanhdao_ten||'</b>
                    <br />
                    <i style="font-size: 12pt;">(Số liệu tính đến ngày '||to_char(vNgayThulyDen,'dd/MM/yyyy')||')</i>
                </td>
            </tr>
            <tr>
                <td colspan="'||v_colspan||'" style="height: 15pt; text-align: left;font-weight:bold;">TỔNG CỘNG '||CountAll_SS||' VỤ, CHIA RA:</td>
            </tr>
           '); 
       ------ADD DỮ LIỆU VÀO THÂN BÁO CÁO
       DBMS_LOB.APPEND(V_EXPORT_TEXT,V_EXPORT_TEXT_TITLE );
       --------------------------------
       DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
           <tr style="height: 1pt;">
                <td style="width: 20pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 100pt"></td>
                 ');
             if(vLoaiAn=01)THEN
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'       
                <td style="width: 120pt"></td>
                 ');
             else
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'       
                <td style="width: 120pt"></td>
                <td style="width: 120pt"></td>
                 ');
             end if;
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'    
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 100pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 180pt"></td>
            </tr>
        </table>
      ');
      --------------------------------    
   DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                 <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
                    <tr>
                        <td style="vertical-align: top;text-align:left;font-size: 10pt;"> NLBC:'||TO_CHAR(sysdate,'dd/MM/yyyy HH24:MI:SS')||'</td>
                        <td>
                        </td>
                    </tr>
                </table>
                    ');   
 --------------------------------      
      OPEN V_CURSOR FOR
--      SELECT curr_thamphan_id curr_thamphan_idS FROM DUAL;
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;     
END GDTTTT_VUAN_SEARCH_BC8_GROUP;
FUNCTION  GDTTTT_VUAN_SEARCH_BC8_ALL
( 
  V_CONLAI_ in varchar2,
  v_colume  in varchar2,
  v_asc_desc in varchar2,
  vToaAnID in number,
  vPhongBanID  in number,
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in varchar2,
  vNguoiGui in varchar2,
  vCoquanchuyendon in varchar2,
  vNguyendon in varchar2,
  vBidon in varchar2,
  vLoaiAn in number,
  vThamtravien in number,
  vLanhdao in number,
  vThamphan in number,
  vQHPLID in number,
  vQHPLDNID in number,
  vTraloidon in varchar2,
  vLoaiCVID in number,
  vNgayThulyTu in date,
  vNgayThulyDen in date,
  vSoThuly in varchar2, 

  vTrangthai in number,
  vCapTrinhTiep in number,
  vIsDangKyBC in number,

  vKetquathuly in number,
  vKetquaxetxu in number,  

  isTTMuonHS in number,
  isTTToTrinh in number,
  isTTYKienKLTotrinh in number,
  isBuocTT in number,
  LoaiAnDB in number,
  vLoaiAnDB_TH in varchar2,
  IsHoanTHA in number,
  vTypeTB in number,
  vTypeHDTP in number,
  v_ISXINANGIAM in number,
  v_GDT_ISXINANGIAM in number,
  PageIndex	in	int,
  PageSize	in	int
)
RETURN SYS_REFCURSOR
IS 
  TotalItem number;  MinIndex	number;  MaxIndex	number;vvvNgayThulyTu date;vvvNgayThulyDen date;
  vvngaythulyden date;vvloaian VARCHAR2(150);vvLoaidon number; 
  temp_sobanan nvarchar2(50);
  ----------------------
  V_CURSOR sys_refcursor;V_EXPORT_TEXT CLOB;V_EXPORT_TEXT_ITEM CLOB;CountAll_S number:=0;vvKetquathuly varchar2(250);vLoaiAn_name varchar2(250);V_BIDON_CHECK varchar2(250);
  ----------------------
  v_table_tp T_TINHTRANG; curr_thamphan_id number:=0;ma_chucvu varchar2(10); vTrangthai_s varchar2(150);
  LOAIAN_ID VARCHAR2(150);LOAIAN_TEN VARCHAR2(150);VUANID NUMBER;LANHDAOID NUMBER;TINHTRANGID NUMBER;NGAYTRA DATE; TOTRINH_ID NUMBER;NGAYTRINH DATE;ISCAPTRINHTIEP NUMBER;THUTU_CAPTRINH NUMBER;
  -----------------------
  v_table_all T_TINHTRANG; vNgayThulyDen_all date;
  LOAIAN_ID_ALL VARCHAR2(150);LOAIAN_TEN_ALL VARCHAR2(150);VUANID_ALL NUMBER;LANHDAOID_ALL NUMBER;TINHTRANGID_ALL NUMBER;NGAYTRA_ALL DATE; TOTRINH_ID_ALL NUMBER;NGAYTRINH_ALL DATE;ISCAPTRINHTIEP_ALL NUMBER;THUTU_CAPTRINH_ALL NUMBER;
  ----------------
   vvTuNgay date;vvDenNgay date;V_SOANPHUCTHAM  VARCHAR2(255);
  ----------------
  v_arrCongvan VARCHAR2(500);v_count_cv NUMBER;v_count_yk NUMBER;V_YKien VARCHAR2(1000);
  -------
    type array_t is varray(3) of number;V_EXPORT_TEXT_TITLE CLOB;
    array array_t := array_t(0,1,2);  v_isTTToTrinh NUMBER;v_isTTMuonHS NUMBER;v_title_group VARCHAR2(255);
    CountAll_SS number:=0;v_stt number:=0; v_vLanhdao_ten VARCHAR2(250):=NULL;v_tbtt  VARCHAR2(1000);v_count_ttbt number:=0;
    v_tt_arr number:=0;v_colspan VARCHAR2(250);
BEGIN
   DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
   DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT_TITLE,true);  DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT_ITEM,true);
    -----
  SELECT DECODE(vngaythulyden,null,sysdate,to_date(to_char(vngaythulyden,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS')) into vvngaythulyden from dual;
  -- vvTuNgay:=to_date('01/01/2019 00:00:00','dd/MM/yyyy  hh24:mi:ss');vvDenNgay:=to_date('31/12/2019 23:59:59','dd/MM/yyyy  hh24:mi:ss');
  v_table_tp := T_TINHTRANG();  v_table_all := T_TINHTRANG(); 
  -------------------------
  if(vThamphan !=0 and vThamphan is not null) then
          select b.Ma  into ma_chucvu  from DM_CanBo a left join DM_DataItem b on a.ChucVuID = b.ID where a.Id = vThamphan;
           if  (ma_chucvu='PCA' OR ma_chucvu='CA')then 
               curr_thamphan_id:=0;
                 ---------lấy loại án khi thẩm phán chọn ô tổng (nghĩa là không xác định được loại án) của form login sẽ lấy những loại án theo năm truyền vào
                       SELECT  LISTAGG(TTS.LOAIAN_ID, ',') WITHIN GROUP (ORDER BY TTS.LOAIAN_ID) INTO vvloaian  FROM (
                                    SELECT LA.LOAIAN_ID,LA.LOAIAN_TEN FROM  (
                                    SELECT DECODE(TT.COL_LOAIAN,'ISHINHSU',1,'ISDANSU',2,'ISHNGD',3,'ISKDTM',4,'ISLAODONG',5,'ISHANHCHINH',6)LOAIAN_ID,
                                    DECODE(TT.COL_LOAIAN,'ISHINHSU','HÌNH SỰ','ISDANSU','DÂN SỰ','ISHNGD','HÔN NHÂN VÀ GIA ĐÌNH','ISKDTM','KINH DOANH, THƯƠNG MẠI','ISLAODONG','LAO ĐỘNG','ISHANHCHINH','HÀNH CHÍNH')LOAIAN_TEN
                                    FROM (
                                            SELECT * FROM (SELECT PB.ISHINHSU,PB.ISDANSU, PB.ISHNGD,PB.ISKDTM,PB.ISHANHCHINH,PB.ISLAODONG FROM DM_CanBo 
                                            PB WHERE PB.Id = vThamphan
                                         )
                                    UNPIVOT --chuyển từ cột thành dòng
                                    (CHECK_LOAIAN for COL_LOAIAN in (ISHINHSU, ISDANSU, ISHNGD, ISKDTM,ISHANHCHINH,ISLAODONG) )
                                    )TT WHERE CHECK_LOAIAN=1 
                                )LA   WHERE LA.LOAIAN_ID IS NOT NULL  
                               GROUP BY LA.LOAIAN_ID,LA.LOAIAN_TEN 
                 )TTS;
                       -----------------------------------------------
            ELSE
                curr_thamphan_id:= vThamphan;
            end if;
      else
      curr_thamphan_id:=0;
  end if;
         -----Bao cao TTP,HDTP,CA,PCA---------------
         IF(vTrangthai=-1)THEN
            vTrangthai_s:='7,8,9,17';
         ELSE
         vTrangthai_s:=vTrangthai;
         END IF;
         ------------------------
  if (vSoBAQD || ' ') <> ' ' then  
    temp_sobanan := Replace(Replace(Replace(lower(vSoBAQD), ' ', ''), '_',''), '-','');
  else 
    temp_sobanan := vSoBAQD;
  end if;
    -----Thẩm phán---------------
        IF(vPhongBanID=0) THEN
               PKG_GDTTT_BAOCAO_APP.GDTTTT_QLTOTRINH_TP(
                                              vThamphan,vToaAnID,0,vLoaiAn,--vThamphanID,vToaAnID,vPhongBanID,vLoaiAn
                                              null,vNgayThulyDen,--tt_tungay,tt_denngay
                                              V_CURSOR);
                  LOOP 
                  FETCH V_CURSOR 
                        INTO   LOAIAN_ID,LOAIAN_TEN,VUANID,LANHDAOID,TINHTRANGID,NGAYTRA,TOTRINH_ID,NGAYTRINH,ISCAPTRINHTIEP,THUTU_CAPTRINH;
                        EXIT WHEN V_CURSOR%NOTFOUND;
                         v_table_tp.extend;
                         v_table_tp(v_table_tp.count) := R_TINHTRANG(
                                     LOAIAN_ID,LOAIAN_TEN,VUANID,LANHDAOID,TINHTRANGID,NGAYTRA,TOTRINH_ID,NGAYTRINH,ISCAPTRINHTIEP,THUTU_CAPTRINH
                                    );
                  END LOOP;    
                  CLOSE V_CURSOR;  
         END IF;
       ----------------------------------------tạo du lieu cac cap trinh chuyển vào bảng 
                  PKG_GDTTT_BAOCAO_APP.GDTTTT_QLTOTRINH_ALL(
                                  vToaAnID,vPhongBanID,vLoaiAn,--vToaAnID,vPhongBanID,vLoaiAn
                                  null,vNgayThulyDen,--tt_tungay,tt_denngayto_date
                                  V_CURSOR);
                  LOOP 
                  FETCH V_CURSOR 
                       INTO   LOAIAN_ID_ALL,LOAIAN_TEN_ALL,VUANID_ALL,LANHDAOID_ALL,TINHTRANGID_ALL,NGAYTRA_ALL,TOTRINH_ID_ALL,NGAYTRINH_ALL,ISCAPTRINHTIEP_ALL,THUTU_CAPTRINH_ALL;
                        EXIT WHEN V_CURSOR%NOTFOUND;
                         v_table_all.extend;
                         v_table_all(v_table_all.count) := R_TINHTRANG(
                                     LOAIAN_ID_ALL,LOAIAN_TEN_ALL,VUANID_ALL,LANHDAOID_ALL,TINHTRANGID_ALL,NGAYTRA_ALL,TOTRINH_ID_ALL,NGAYTRINH_ALL,ISCAPTRINHTIEP_ALL,THUTU_CAPTRINH_ALL
                                    );
                  END LOOP;    
                  CLOSE V_CURSOR;  
       ---------------------------------
    -------TẠO BÁO CÁO
    SELECT DECODE(vLoaiAn,01,'Tội danh','Quan hệ pháp luật') INTO vLoaiAn_name FROM DUAL;
    SELECT DECODE(vLoaiAn,01,'10','11') INTO v_colspan FROM DUAL;
    ------
    v_isTTToTrinh:=isTTToTrinh;
    v_isTTMuonHS:=isTTMuonHS;
    DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT_ITEM,true);
    -----------------
      FOR item IN (
        WITH HD1 as (select hd.VUANID,DECODE(hd.TYPEHD,1,'<br/><span style="">Hội đồng: <b> Toàn thể</b></span>',2,'<br/><span style="">Hội đồng: <b> 5</b></span>','')HOIDONGXX from GDTTT_VUAN_XXGDTT_HOIDONG hd GROUP BY hd.VUANID, hd.TYPEHD)
          ,HD2 as (select hd.VUANID,DECODE(hd.TENCANBO,NULL,NULL,'<br/><span style="">Chủ tọa: <b>'||hd.TENCANBO||'</b></span>')TEN_CHUTOA,hd.CANBOID from GDTTT_VUAN_XXGDTT_HOIDONG hd WHERE hd.ISCHUTOA=1)
          select a.* ,'' arrDONID , '' arrCV81ID   , '' arrCHIDAOID
                    from (
                    Select  COUNT(1) OVER () as CountAll,
                    ROW_NUMBER() OVER (ORDER BY CASE WHEN V_ASC_DESC = 'ASC' AND V_COLUME = 'NGAYTHULYDON' THEN V.NGAYTHULYDON END, CASE WHEN V_ASC_DESC = 'DESC' AND V_COLUME = 'NGAYTHULYDON' THEN V.NGAYTHULYDON END DESC,CASE WHEN V_ASC_DESC = 'ASC' AND V_COLUME = 'TENTHAMTRAVIEN' THEN ttv.HOTEN END,CASE WHEN V_ASC_DESC = 'DESC' AND V_COLUME = 'TENTHAMTRAVIEN' THEN ttv.HOTEN END DESC
                                      ) STT   
                      , NVL(v.TongDon,0 ) as TongDon 
                      ,DECODE(AQH.VuViecID,NULL,0,1)SoCV81--NVL(v.IsAnQuocHoi, 0) as SoCV81,
                      ,DECODE(AQH_F.VuViecID,NULL,NULL,'X')CV93
                      ,NVL(v.IsAnChiDao, 0) as IsAnChiDao 
                       , v.ID, v.LoaiAn,v.MAVUAN,DD.LISTHULYDON  
                        ,(select count(id) from gdttt_don d where d.VUVIECID = v.id and d.isthuly= 1 and CD_TRANGTHAI = 2) cThulymoi
                       , v.SOTHULYDON,to_char(v.NGAYTHULYDON,'dd/MM/yyyy')NGAYTHULYDON , v.NGUYENDON,v.BIDON
                       ,DECODE(v.TRUONGHOPTHULY,1,'<b>Kháng nghị của VKS</b>',2,'<b>Rút Hồ sơ đoàn kiểm tra</b>',3,'<b>Chủ động GĐT qua Bản án</b>',NVL(v.ARRNGUOIKHIEUNAI,v.NGUOIKHIEUNAI)) NGUOIKHIEUNAI
                        ,DECODE(v.BAQD_CAPXETXU,4,v.so_qdgdt,3,v.SOANPHUCTHAM,2,v.SOANSOTHAM,v.SOANPHUCTHAM) SOANPHUCTHAM
                        ,DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')) NGAYXUPHUCTHAM
                        ,DECODE(v.BAQD_CAPXETXU,4,DM_CanBo_TenToaVT(tqd.Ma_Ten),2,DM_CanBo_TenToaVT(tst.Ma_Ten),DM_CanBo_TenToaVT(txx.Ma_Ten)) TOAXX_VietTat
                        ,DECODE(v.BAQD_CAPXETXU,4,tqd.Ma_Ten,2,tst.Ma_Ten,txx.Ma_Ten) ToaXX
                 --manhnd
                      , case when BAQD_CAPXETXU = 4 
                                        then NVL(v.SO_QDGDT, NVL(v.SO_QDGDT, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NGAYQD,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYQD,'dd/MM/yyyy'))||
                                             '<br/>'|| DM_CanBo_TenToaVT(tqd.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-GĐT)</i>'||
                                              decode (v.SOANPHUCTHAM,null,'',' ','','<br/><br/>'||v.SOANPHUCTHAM||'<br/>'||to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')||
                                                        '<br/>'||DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>')||
                                              decode (v.SoAnSoTham,null,'',' ','','<br/>'||v.SoAnSoTham||'<br/>'||to_char(v.NgayXuSoTham,'dd/MM/yyyy')||
                                                    '<br/>'||DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)')
                             when BAQD_CAPXETXU = 3  then
                                             NVL(v.SOANPHUCTHAM, NVL(v.SOANPHUCTHAM, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))||
                                             '<br/> '|| DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>'||
                                              decode (v.SoAnSoTham,null,'',' ','','<br/><br/>'||v.SoAnSoTham||'<br/>'||to_char(v.NgayXuSoTham,'dd/MM/yyyy')||
                                              '<br/> '||DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>')

                             when BAQD_CAPXETXU = 2 
                                        then NVL(v.SoAnSoTham, NVL(v.SoAnSoTham, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NgayXuSoTham,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NgayXuSoTham,'dd/MM/yyyy'))||
                                             '<br/>'|| DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>'
                             else
                                            NVL(v.SOANPHUCTHAM, NVL(v.SoAnSoTham, ''))
                                            ||'<br/>'|| decode(to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'),null,to_char(v.NgayXuSoTham,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))
                                            ||'<br/> '|| DM_CanBo_TenToaVT(NVL(txx.Ma_Ten, tst.Ma_Ten ))        
                             end InforBA
                      --

                         ,qhpl.TENQHPL QHPLDN
                         ,case when NguyenDon is not null then NVL(qhpl.TENQHPL, Replace(v.TenVuAn,(NguyenDon ||' - ')))
                               when NguyenDon is null and BiDon is not null  then NVL(qhpl.TENQHPL, Replace(v.TenVuAn,(BiDon ||' - ')))
                            end as QHPNDN_Report
                        ,tp.HOTEN as TENTHAMPHAN
                        ,ttv.HOTEN TENTHAMTRAVIEN
                        , case when (Length(NVL(v.NGAYPHANCONGTTV,''))=0 or (to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(v.NGAYPHANCONGTTV,'')) >0 then to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy')
                            end  NGAYPHANCONGTTV
                        , ld.HOTEN as TENLANHDAO   

                        , cv.Ten ChucVuLanhDao   , cv.Ma MaChucVuLD  , v.GHICHU,v.NGUOITAO ,to_char(v.NGAYTAO,'dd/MM/yyyy HH24:MI') NGAYTAO, v.NGUOISUA,to_char(v.NGAYSUA,'dd/MM/yyyy HH24:MI') NGAYSUA   
                         ----------anhvh 12/10/2019 
                        ,CASE WHEN  (vtrangthai >=4 OR vtrangthai=-1) THEN TA.TINHTRANGID ELSE v.TRANGTHAIID END TRANGTHAIID
                        ,CASE WHEN   (vtrangthai >=4 OR vtrangthai=-1)  THEN tts.TenTinhTrang ELSE tt.TenTinhTRang END TenTinhTrang
                        ,CASE WHEN   (vtrangthai >=4 OR vtrangthai=-1) AND vKetquathuly =4  THEN tts.GiaiDoan ELSE NVL(tt.GiaiDoan,0) END GiaiDoanTrinh
                         ---------
                        ,case when  NVL(v.GQD_LOAIKETQUA,3)<> 1 then v.QUATRINH_GHICHU
                            when NVL(v.GQD_LOAIKETQUA,3) =1 then (u'Kháng nghị '||DECODE( NVL(v.IsVienTruongKN,0), 0, '(CA)', 1, 'VKS'))  end QUATRINH_GHICHU
                        , v.GDQ_SO 
                        , case  when (Length(NVL(v.GDQ_NGAY,''))=0 or (to_char(v.GDQ_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(v.GDQ_NGAY,'')) >0 then to_char(v.GDQ_NGAY,'dd/MM/yyyy')  end  GDQ_NGAY
                          , case when NVL(v.LoaiAn, 0)<>1 then ''
                                else (SELECT LISTAGG(cast(dt.So as varchar2(10))||case when (Length(NVL(dt.Ngay,''))=0   or (to_char(dt.Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                                                                                       when Length(NVL(dt.Ngay,'')) >0 then ' - '||to_char(dt.Ngay,'dd/MM/yyyy')  end , ',<br/>'
                                                     )
                                       WITHIN GROUP (ORDER BY dt.So asc, dt.Ngay asc) FROM GDTTT_DON_TRALOI dt  
                                       WHERE  dt.VuAnID=v.ID and dt.TypeTB=3
                                     )
                                end as AHS_ThongTinGQD
                        , NVL(v.GQD_LOAIKETQUA,5) KQ_GQD_ID
                        --anhvh edit
                        , DECODE(v.GQD_LOAIKETQUA,3,v.GQD_KETQUA, 2,u'X\1ebfp \0111\01a1n' , 1, u'Kh\00e1ng ngh\1ecb', 0,u'Tr\1ea3 l\1eddi \0111\01a1n',v.GQD_KETQUA ) KQ_GQD
                        ,CASE WHEN v.GQD_LOAIKETQUA=3 or v.GQD_LOAIKETQUA=4 THEN v.GQD_KETQUA
                            WHEN NVL(v.GQD_LOAIKETQUA,5) = 5 then null
                            else DECODE(v.GQD_LOAIKETQUA,0,'TLĐ',1,'KN',2,'XĐ')||'-'||DECODE(v.LoaiAn,1,'HS',2,'DS',3,'KDTM',4,'LĐ',5,'HC')
                     || ' Số: '||translate(v.GDQ_SO using nchar_cs)|| ' Ngày: '||to_char(V.GDQ_NGAY,'dd/MM/yyyy')
                     end KQ_GQDS
                        , NVL(v.IsVienTruongKN,0) IsVienTruongKN
                        , case when NVL(v.GQD_LOAIKETQUA,3)<> 1 then ''
                                when NVL(v.GQD_LOAIKETQUA,3)=1 
                                     then DECODE( NVL(v.IsVienTruongKN,0), 0, '(CA)', 1, 'VKS')  end LoaiKN   
                        , NVL(v.GQD_SoCV , '') GQD_SoCV
                        , case when (Length(NVL(v.GQD_NgayPhatHanhCV,''))=0 or (to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(v.GQD_NgayPhatHanhCV,'')) >0 then to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy') end  GQD_NgayPhatHanhCV  
                        , NVL(v.GQD_IsHoanTHA, 0) GQD_IsHoanTHA,NVL( v.GQD_HoanTHA_So ,'') GQD_HoanTHA_So
                        , case when (Length(NVL(v.GQD_HoanTHA_Ngay,''))=0 or (to_char(v.GQD_HoanTHA_Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(v.GQD_HoanTHA_Ngay,'')) >0 then to_char(v.GQD_HoanTHA_Ngay,'dd/MM/yyyy')   end  GQD_HoanTHA_Ngay  
                        , NVL( v.GQD_HoanTHA_TenNguoiKy ,'') GQD_HoanTHA_TenNguoiKy 
                        -------------------------------
                        , NVL(v.IsHoSo,0) IsHoSo, NVL(v.HoSoID,0)
                        , case when (Length(NVL(hs.NgayTao,''))=0 or (to_char(hs.NgayTao,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(hs.NgayTao,'')) >0 then to_char(hs.NgayTao,'dd/MM/yyyy')  end  NgayTTVNhanHS
                        , v.NGAYTTVNHAN_THS,NVL(v.IsToTrinh,0) IsToTrinh , NVL(v.ISANTRAODOICV,0)  ISANTRAODOICV , v.SOTHULYXXGDT
                        , case when (Length(NVL(v.NGAYTHULYXXGDT,''))=0 or (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') ='01/01/0001')) then ''
                               when Length(NVL(v.NGAYTHULYXXGDT,'')) >0 then to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy')  end  NGAYTHULYXXGDT
                        , case when (Length(NVL(v.XXGDTTT_NGAYVKSTRAHS,''))=0 or (to_char(v.XXGDTTT_NGAYVKSTRAHS,'dd/MM/yyyy') ='01/01/0001')) then ''
                               when Length(NVL(v.XXGDTTT_NGAYVKSTRAHS,'')) >0 then to_char(v.XXGDTTT_NGAYVKSTRAHS,'dd/MM/yyyy')  end  XXGDTTT_NGAYVKSTRAHS
                        , NVL(v.XXGDTTT_ISHOANPT, 0) XXGDTTT_ISHOANPT 
                         , case when (Length(NVL(v.XXGDTTT_NGAYHOAN,''))=0 or (to_char(v.XXGDTTT_NGAYHOAN,'dd/MM/yyyy') ='01/01/0001')) then ''
                                       when Length(NVL(v.XXGDTTT_NGAYHOAN,'')) >0 then to_char(v.XXGDTTT_NGAYHOAN,'dd/MM/yyyy')  end  XXGDTTT_NGAYHOAN
                        , NVL(v.XXGDTTT_LYDOHOAN, '') XXGDTTT_LYDOHOAN,v.XXGDTTT_SOQD
                         , case when (Length(NVL(v.XXGDTTT_NGAYQD,''))=0 or (to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') ='01/01/0001')) then ''
                                       when Length(NVL(v.XXGDTTT_NGAYQD,'')) >0 then to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') end  XXGDTTT_NGAYQD
                        , case when (Length(NVL(v.NGAYXUGIAMDOCTHAM,''))=0 or (to_char(v.NGAYXUGIAMDOCTHAM,'dd/MM/yyyy') ='01/01/0001')) then ''
                                       when Length(NVL(v.NGAYXUGIAMDOCTHAM,'')) >0 then to_char(v.NGAYXUGIAMDOCTHAM,'dd/MM/yyyy')   end  NGAYXUGIAMDOCTHAM
                        , NVL(kq.Ten,' ') KetQuaXXGDT, NVL(v.IsRutKN,0) IsRutKN , NVL(v.SORUTKN, '') SORUTKN
                        , case when (Length(NVL(v.NGAYRUTKN,''))=0 or (to_char(v.NGAYRUTKN,'dd/MM/yyyy') ='01/01/0001')) then ''
                               when Length(NVL(v.NGAYRUTKN,'')) >0 then to_char(v.NGAYRUTKN,'dd/MM/yyyy') end  NGAYRUTKN,HD1.HOIDONGXX,HD2.TEN_CHUTOA
                         ,TTVSS.PHANCONGTTV
                         ,v.TRUONGHOPTHULY
                      from GDTTT_VUAN v 
                      left join DM_TOAAN txx on v.TOAPHUCTHAMID=txx.ID
                      left join DM_TOAAN tst on v.TOAANSOTHAM=tst.ID
                      left join DM_TOAAN tqd on v.TOAQDID=tqd.ID
                      left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
                      left join DM_CANBO tp on v.THAMPHANID=tp.ID
                      left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
                      left join DM_CANBO ld on ld.ID = decode (NVL(v.XXGDT_LANHDAOVUID,0),0,v.LANHDAOVUID,v.XXGDT_LANHDAOVUID)
                      left join DM_CANBO ldxx on v.XXGDT_LANHDAOVUID=ldxx.ID
                      left join DM_DataITem cv on ld.ChucVuID = cv.ID
                      left join GDTTT_DM_TINHTRANG tt on tt.ID= NVL(v.TRANGTHAIID,1)
                      left join DM_DAtaItem kq on kq.ID = v.XXGDTTT_KETQUAID
                      left join (Select ID, NgayTao from GDTTT_QUanLyHS where Loai=3) hs on hs.ID = NVL(v.HoSoID,0)
                      ----anhvh
                      left join HD1 ON HD1.VUANID=v.ID
                      left join HD2 ON HD2.VUANID=v.ID
                      LEFT JOIN TABLE(v_table_all) TA ON TA.VUANID=V.ID
                      LEFT JOIN GDTTT_DM_TINHTRANG tts on tts.ID= TA.TINHTRANGID
                      --anhvh add 21/11/2019 check ngày của vụ và ngày công văn dùng cho việc truy vấn phía dưới
                      LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                          END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                      --anhvh--án quốc hội gồm công văn 8.1 và 9.3
                      LEFT JOIN (select D.VuViecID from GDTTT_DON d 
                                WHERE d.LOAICONGVAN in(Select I.ID from DM_DATAITEM I where (I.ID=546 OR I.CAPCHAID=546 OR I.ID = 1023 OR I.CAPCHAID=1023))
                                GROUP BY d.VuViecID)AQH ON AQH.VuViecID=V.ID
                      --anhvh edit-30/03/2020 thêm cột theo ý kiến của chú Hào lấy theo 9.3
                        LEFT JOIN (select D.VuViecID from GDTTT_DON d 
                                 WHERE d.LOAICONGVAN in(Select I.ID from DM_DATAITEM I where (I.ID=546 OR I.CAPCHAID=546))
                                 AND EXISTS (--chỉ lấy chánh án và phó chánh an
                                    SELECT C.ID,C.HOTEN FROM DM_CANBO C
                                    WHERE EXISTS(SELECT dt.ID, dt.ten FROM dm_dataitem dt WHERE dt.ma IN ('CA', 'PCA')  AND dt.groupid =13 AND dt.ID=C.chucvuid)
                                    AND C.TOAANID=1 AND C.HIEULUC=1 
                                    AND C.ID=D.CHIDAO_LANHDAOID 
                                     )
                                  GROUP BY d.VuViecID
                                  )AQH_F ON AQH_F.VuViecID=V.ID
                   ----anhvh add 31/03/2020 lấy tất cả thẩm tra viên đã được phân công
                   LEFT JOIN (
                        SELECT TTVS.VUANID,LISTAGG(TTVS.HOTEN, '<br/>') WITHIN GROUP (ORDER BY TTVS.STT  DESC)PHANCONGTTV
                          FROM (
                               SELECT TT.VUANID,TT.HOTEN,TT.STT FROM (
                                    SELECT VV.ID VUANID,'<b>'||TO_CHAR(TTV.HOTEN)|| DECODE(VV.XXGDT_NGAYPHANCONGTTV,null,DECODE(VV.NGAYPHANCONGTTV,NULL,NULL,' ('||To_char(VV.NGAYPHANCONGTTV,'dd/MM/yyyy')||')'),DECODE(VV.XXGDT_NGAYPHANCONGTTV,NULL,NULL,' ('||To_char(VV.XXGDT_NGAYPHANCONGTTV,'dd/MM/yyyy')||')'))||'</b>' HOTEN,1 STT FROM GDTTT_VUAN VV 
                                    LEFT JOIN DM_CANBO TTV ON DECODE(VV.XXGDT_THAMTRAVIENID,null,VV.THAMTRAVIENID,VV.XXGDT_THAMTRAVIENID)=TTV.ID
                                 UNION ALL    
                                 -- Can lay dung Lich su cua giai doan
                                   SELECT SS.VUANID,SS.HOTEN,SS.STT FROM (
                                        SELECT A.VUANID,'<i>'||TO_CHAR(b.HOTEN)||' ('||To_char(DECODE(a.TUNGAY,NULL,VS.NGAYPHANCONGTTV,a.TUNGAY),'dd/MM/yyyy')||')</i>'HOTEN,0 STT FROM GDTTT_VUAN_PHANCONGCB_HISTORY A
                                        LEFT JOIN GDTTT_VUAN VS ON VS.ID=A.VUANID
                                        INNER JOIN DM_CanBo b on a.CanBoID = b.ID
                                        WHERE a.Loai=1 
                                        ORDER BY DECODE(a.TUNGAY,NULL,VS.NGAYPHANCONGTTV,a.TUNGAY) DESC
                                    )SS
                                )TT GROUP BY TT.VUANID,TT.HOTEN,TT.STT
                            )TTVS GROUP BY TTVS.VUANID
                         )TTVSS ON TTVSS.VUANID=V.ID
                      ---lấy danh sách thụ lý đơn anhvh add 31/03/2020        
                      LEFT JOIN (
                        SELECT CV.VUVIECID,LISTAGG(CASE WHEN LENGTH(NVL(CV.TL_SO, ''))>0 THEN ('Số ' || CV.TL_SO ) ELSE '' END
                                      || CASE WHEN LENGTH(NVL(CV.TL_NGAY, ''))>0 THEN (' - ' || TO_CHAR(CV.TL_NGAY,'dd/MM/yyyy') ) ELSE '' END                         
                                , ',<br/>')
                            WITHIN GROUP (ORDER BY CV.TL_NGAY DESC, CV.NGAYTAO DESC)LISTHULYDON            
                            FROM GDTTT_DON CV  
                            WHERE  CV.CD_TRANGTHAI=2 AND CV.ISTHULY=1
                            GROUP BY CV.VUVIECID
                        )DD ON DD.VUVIECID=v.ID
                        -----
                      where  v.TOAANID=vToaAnID 
                            And (NVL(vPhongBanID,0)=0 Or v.PhongBanID=vPhongBanID)
                            And NVL(V.ISVIENTRUONGKN,0) = 0
                            And (NVL(vloaian,0) = 0 Or vloaian = v.LOAIAN) 
                            -- Chưa có kết quả đến ngày 
                            And v.NGAYTAO<=vvngaythulyden 
                            And ((v.gqd_loaiketqua in (0,1,2,3,4) and VA.GQD_NGACVS> vvngaythulyden  AND VA.GQD_NGACVS IS NOT NULL) 
                                            OR v.gqd_loaiketqua IS NULL ) 
                              -- Thuộc án
                              and ( LoaiAnDB = 0
                                    or (LoaiAnDB = 1 
                                         --án quốc hội gồm công văn 8.1 và 9.3
                                         AND EXISTS(select 'X' from GDTTT_DON d 
                                                                        where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                                        AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                                        GROUP BY d.VuViecID) 
                                       )
                                    or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)   
                                    or(LoaiAnDB = 3  AND AQH_F.VuViecID IS NOT NULL)
                               )
               )a
       )
    LOOP
    -------TẠO DỮ LIỆU CỦA BÁO CÁO
    CountAll_S:=item.CountAll;
    v_stt:=v_stt+1;
    SELECT DECODE(SUBSTR(item.SOANPHUCTHAM,0,INSTR(item.SOANPHUCTHAM, '/',1,2)-1),NULL,SUBSTR(item.SOANPHUCTHAM,0,INSTR(item.SOANPHUCTHAM, '/',1,1)-1),SUBSTR(item.SOANPHUCTHAM,0,INSTR(item.SOANPHUCTHAM, '/',1,2)-1)) INTO V_SOANPHUCTHAM FROM DUAL;
    SELECT COUNT(*) INTO v_count_cv FROM GDTTT_DON D WHERE D.VUVIECID=item.ID  and  (d.CV_SO is not null or d.CV_TENDONVI is not null);
    IF(v_count_cv>0)THEN
        SELECT ( Case d.LOAIDON when 3 then (' - Công văn số ' || d.CV_SO || ' ngày ' || TO_CHAR(d.CV_NGAY,'dd/MM/yyyy')||' của '|| TO_CHAR(d.CV_TENDONVI)) else '' End) 
        INTO v_arrCongvan FROM GDTTT_DON D WHERE D.VUVIECID=item.ID and  (d.CV_SO is not null or d.CV_TENDONVI is not null)
        FETCH FIRST 1 ROWS ONLY;
    END IF;
        -----------------
        Select  count(*) into v_count_ttbt  from GDTTT_DON d 
        inner join ( select Max(ID) DONID,CV_TENDONVI from GDTTT_DON  
        where vUVIECID=item.ID and NVL(CD_TRANGTHAI, 4)=2  Group By CV_TENDONVI ) g on g.DONID=d.ID   
        where NVL(d.CD_TRANGTHAI, 4)=2 
        and d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023);
        ------
        if(v_count_ttbt>0) then
            SELECT DECODE(TT.So,NULL,DECODE(tt.Ngay,NULL,NULL,'<br/>- Thông báo tình thế số ***** '|| tt.Ngay),'<br/>- Thông báo tình thế số '||TT.So || tt.Ngay) into v_tbtt FROM (
                Select  NVL(t.So,'') So ,case when (Length(NVL(t.Ngay,''))=0 or (to_char(t.Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                           when Length(NVL(t.Ngay,'')) >0 then ' Ngày '||to_char(t.Ngay,'dd/MM/yyyy')
                        end as Ngay 
                from GDTTT_DON d 
                inner join ( select Max(ID) DONID,CV_TENDONVI from GDTTT_DON  
                         where vUVIECID=item.ID and NVL(CD_TRANGTHAI, 4)=2  Group By CV_TENDONVI ) g on g.DONID=d.ID      
                left join (select ID, DonID, VuAnID, So,Ngay, GhiChu, NguoiNhan from GDTTT_Don_TraLoi 
                     where TypeTB=1 and  VuAnID=item.ID) t on t.DonID= d.ID
                where NVL(d.CD_TRANGTHAI, 4)=2 
                and d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                Order by d.NgayNhanDon desc, d.NgayGhiTrenDon desc
            )TT FETCH FIRST 1 ROWS ONLY;
        END IF;
   ------------
        SELECT count(*) into v_count_yk  FROM GDTTT_TOTRINH t
        inner join GDTTT_DM_TINHTRANG d on d.ID=t.TINHTRANGID
        left join GDTTT_DM_TINHTRANG ct on ct.ID = t.CAPTRINHTIEP
        left join DM_CANBO c on c.ID=t.LANHDAOID
        WHere t.VUANID=item.ID--1187938--4583--1183805 
         AND ((t.NGAYTRINH<=vNgayThulyDen and vNgayThulyDen IS NOT NULL)
                  OR (t.NGAYTRINH<=SYSDATE AND vNgayThulyDen IS NULL))
        FETCH FIRST 1 ROWS ONLY;
    IF(v_count_yk>0)THEN
          SELECT REPLACE(RTRIM(TT.YKien,': '),'Trả lời đơn','TLD') INTO V_YKien
            FROM (
            SELECT '- '||d.TENTINHTRANG||'<br/> '||DECODE(c.chucvuid,74,'PCA',c.HOTEN) 
            ||' duyệt '
            ||'ngày '|| to_char(t.NgayTrinh,'dd/MM/yyyy') 
            || ': '||DECODE(NVL(t.YKien, ''),NULL,Decode(NVL(t.LoaiYKien,11), 0, 'Trả lời đơn',1,'Kháng nghị', 3,'Xếp đơn'
                                               , 10,'Nghiên cứu lại, xác minh, bổ sung', 11, '' )
                                               ,NVL(t.YKien, '')) YKien
            FROM GDTTT_TOTRINH t
            inner join GDTTT_DM_TINHTRANG d on d.ID=t.TINHTRANGID
            left join GDTTT_DM_TINHTRANG ct on ct.ID = t.CAPTRINHTIEP
            left join DM_CANBO c on c.ID=t.LANHDAOID
            WHere t.VUANID=item.ID--1187938--4583--1183805 
            AND ((t.NGAYTRINH<=vNgayThulyDen and vNgayThulyDen IS NOT NULL)
                  OR (t.NGAYTRINH<=SYSDATE AND vNgayThulyDen IS NULL))
            order by t.NGAYTRINH desc,d.ThuTu desc
            FETCH FIRST 1 ROWS ONLY
         )TT;
     END IF;
    -----------------
      DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
         <tr style="font-size: 11pt;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_stt||'</td>               
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||V_SOANPHUCTHAM||'<br />'||SUBSTR(item.SOANPHUCTHAM,INSTR(item.SOANPHUCTHAM, '/',-1))||'<br/>'||item.NGAYXUPHUCTHAM||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TOAXX_VietTat||'</td>                
        ');  
        if(vLoaiAn=01)THEN--vLoaiAn=01 là hình sự
                IF(item.NGUYENDON=item.BIDON)THEN
                  V_BIDON_CHECK:=item.NGUYENDON;
                ELSIF(item.NGUYENDON!=item.BIDON AND item.NGUYENDON !='' AND item.BIDON!='') THEN
                  V_BIDON_CHECK:=item.NGUYENDON||', <br/>'||item.BIDON;
                ELSE
                 V_BIDON_CHECK:=replace(item.NGUYENDON||item.BIDON,',','');
                END IF;
               DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.QHPNDN_Report||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||V_BIDON_CHECK||'</td>          
                ');
          else
               DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
               <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.QHPLDN||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.NGUYENDON||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.BIDON||'</td>
                ');
          end if;
          DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||to_char(item.NGAYTTVNHAN_THS,'dd/MM/yyyy')||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.NgayTTVNhanHS||'</td>
                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||v_arrCongvan||'</td> 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TenThamTraVien||'</td>
                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||V_YKien||v_tbtt||'</td>
            </tr>
        ');
  END LOOP;
      v_tt_arr:=v_tt_arr+1;
      --V_EXPORT_TEXT_TITLE-- tiêu đề theo từng nhóm
    DBMS_LOB.APPEND(V_EXPORT_TEXT_TITLE,'
             <tr style="font-weight:bold;background-color:#e1dfdf;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; height: 50pt;">STT</td>
                 <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Bản án
                    <br />
                    số và ngày</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Tòa án xử</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||vLoaiAn_name||'</td>
                 '); 
            if(vLoaiAn=01)THEN
             DBMS_LOB.APPEND(V_EXPORT_TEXT_TITLE,' 
              <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Bị cáo</td>             
            ');   
            ELSE
              DBMS_LOB.APPEND(V_EXPORT_TEXT_TITLE,'    
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Nguyên đơn/ Người khởi kiện</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Bị đơn/ Người bị kiện</td>
               ');   
            END IF;
             DBMS_LOB.APPEND(V_EXPORT_TEXT_TITLE,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ngày nhận THS</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ngày nhận HS</td>
                 <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">CV quốc hội</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thẩm tra viên</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ghi chú</td>
            </tr>
            '); 
       CountAll_SS:=CountAll_SS+CountAll_S;
       DBMS_LOB.APPEND(V_EXPORT_TEXT_TITLE,V_EXPORT_TEXT_ITEM);

     IF(vLanhdao!=0)THEN
            SELECT '<br/><span style="font-weight:100">Lãnh đạo phụ trách: '||cb.HOTEN||'</span>' INTO v_vLanhdao_ten FROM DM_CANBO cb WHERE ID=vLanhdao;
           -- FETCH FIRST 1 ROWS ONLY;
    END IF;
    -----------
        --Insert số trang
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
      <div style="mso-element: footer" id="f1">
            <w:sdt sdtdocpart="t"
            docparttype="Page Numbers (Bottom of Page)" docpartunique="t" id="644013658">
            <p class=MsoFooter align=right style="text-align:right"><!--[if supportFields]><span
            style="mso-element:field-begin"></span><span
            style="mso-spacerun:yes"> </span>PAGE<span style="mso-spacerun:yes">  
            </span>\* MERGEFORMAT <span style="mso-element:field-separator"></span><![endif]--><span
            style="mso-no-proof:yes;display:none">2</span><!--[if supportFields]><span
            style="mso-no-proof:yes"><span style="mso-element:field-end"></span></span><![endif]--><w:sdtPr></w:sdtPr></p>
            </w:sdt>
            <p class="MsoFooter" align="right" style="text-align: right;"><o:p></o:p> </p>
      </div>');
       DBMS_LOB.APPEND(V_EXPORT_TEXT,'
          <table cellpadding="1" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;">
            <tr>
                <td colspan="'||v_colspan||'" style="height: 0pt;"></td>
            </tr>
            <tr>
                <td colspan="'||v_colspan||'" style="line-height: 100%; font-size: 14pt"><b>DANH SÁCH ÁN QUỐC HỘI CHUYỂN ĐƠN CHƯA CÓ KẾT QUẢ GIẢI QUYẾT '||v_vLanhdao_ten||'</b>
                    <br />
                    <i style="font-size: 12pt;">(Số liệu tính đến ngày '||to_char(vNgayThulyDen,'dd/MM/yyyy')||')</i>
                </td>
            </tr>
             <tr>
                <td colspan="'||v_colspan||'" style="height: 15pt; text-align: left;font-weight:bold;">Tổng số án là:  '||CountAll_SS||'</td>
            </tr>
           '); 
       ------ADD DỮ LIỆU VÀO THÂN BÁO CÁO
       DBMS_LOB.APPEND(V_EXPORT_TEXT,V_EXPORT_TEXT_TITLE );
       --------------------------------
       DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
           <tr style="height: 1pt;">
                <td style="width: 20pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 100pt"></td>
                 ');
             if(vLoaiAn=01)THEN
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'       
                <td style="width: 120pt"></td>
                 ');
             else
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'       
                <td style="width: 120pt"></td>
                <td style="width: 120pt"></td>
                 ');
             end if;
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'    
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 100pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 180pt"></td>
            </tr>
        </table>
      ');
      --------------------------------    
   DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                 <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
                    <tr>
                        <td style="vertical-align: top;text-align:left;font-size: 10pt;"> NLBC:'||TO_CHAR(sysdate,'dd/MM/yyyy HH24:MI:SS')||'</td>
                        <td>
                        </td>
                    </tr>
                </table>
                    ');   
 --------------------------------      
      OPEN V_CURSOR FOR
--      SELECT curr_thamphan_id curr_thamphan_idS FROM DUAL;
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;     
END GDTTTT_VUAN_SEARCH_BC8_ALL;
END PKG_VGDKT_BAOCAO;
