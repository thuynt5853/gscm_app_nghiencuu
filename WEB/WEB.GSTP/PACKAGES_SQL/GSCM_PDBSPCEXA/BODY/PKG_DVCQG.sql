create or replace NONEDITIONABLE PACKAGE BODY      PKG_DVCQG
AS
PROCEDURE TB_TU_ANPHI_SEARCH (
         V_MA_THONGBAO   IN     VARCHAR2,
         V_CURSOR           OUT SYS_REFCURSOR
         )
   AS
      v_THANH_TOAN_ID   NUMBER;V_NGAY_LAM_VIEC NUMBER;V_MALOAIVUVIEC VARCHAR2(250);
   BEGIN
    ------------------
   SELECT TT.MALOAIVUVIEC INTO V_MALOAIVUVIEC FROM DVCQG_THANH_TOAN TT WHERE TT.MA_THONGBAO=V_MA_THONGBAO;

            IF(V_MALOAIVUVIEC='2')THEN 
              -------------------
             OPEN V_CURSOR FOR
                   SELECT V_MA_THONGBAO || '-' || TO_CHAR (SYSDATE, 'yymmddhh24miss') MATRACUUTT,
                    HT.MA MALOAIHINHTHU,
                    AP.MA_THONGBAO,
                    TK.SOTK_KHOBAC SOTAIKHOANKB,
                    TK.MA_KHOBAC MAKHOBAC,
                    TK.TENTK_KHOBAC TENKHOBAC,
                    THA.MA_DINH_DANH MACHICUC,
                    TK.TEN_TK_THUHUONG TENCHICUC,
                    --DECODE(AP.TEN_TK_THUHUONG,NULL,AP.TENCHICUC,AP.TEN_TK_THUHUONG)TENCHICUC,
                    AI.NGAYTHONGBAO,
                    AI.SOTHONGBAO,
                    TA.MA_TEN TENTOATHONGBAO,
                    HT.TEN TENLOAIHINHTHU,
                    AP.HOTENNGUOINOP,
                    AP.SOCMNDNGUOINOP,
                    AP.DIACHINGUOINOP,
                    AP.HUYENNGUOINOP,
                    AP.TINHNGUOINOP,
                    AP.TONGTIEN
                   FROM DVCQG_THANH_TOAN AP
                   LEFT JOIN DM_DONVITHIHANHAN THA ON THA.ID=AP.DONVITHA_ID
                   LEFT JOIN DM_TOAAN TA ON TA.ID=THA.ARRTOAANID
                   LEFT JOIN DM_TK_THANHTOAN TK ON TK.THA_ID=AP.DONVITHA_ID
                   LEFT JOIN DM_LOAIHINH_THU HT ON HT.ID=TK.MA_LOAIHINHTHU
                   ------
                   LEFT JOIN ADS_TONGDAT TD ON TD.ID=AP.TONGDATID
                   LEFT JOIN ADS_ANPHI AI ON AI.ID=AP.ANPHI_ID
                   --09/01/2025 NGAYNHANTONGDAT lấy ra  1 đương sự có NGAYGUI cũ nhất
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
                              )DT on DT.tongdatid=TD.ID and instr(','||AP.DUONGSU_ID||',',','||DT.DUONGSUID||',')>0 
                   WHERE  AP.MA_THONGBAO = V_MA_THONGBAO
                    AND AP.TRANGTHAITHANHTOAN = 0
                    AND AP.TONGDATID IS NOT NULL
                    AND DT.NGAYPHATHANH IS NOT NULL   
                    AND( ( 
                            (  (DT.NGAYNHANTONGDAT is null and COMMON_APP.GET_NGAY_LAMVIEC(AI.NGAYTHONGBAO,SYSDATE)<=7) 
                               OR(DT.NGAYNHANTONGDAT is not null and COMMON_APP.GET_NGAY_LAMVIEC(DT.NGAYNHANTONGDAT,SYSDATE)<=7)
                             )
                           AND TD.BIEUMAUID=67
                          )
                         OR (
                             (  (DT.NGAYNHANTONGDAT is null and COMMON_APP.GET_NGAY_LAMVIEC(AI.NGAYTHONGBAO,SYSDATE)<=5)
                               OR((DT.NGAYNHANTONGDAT is NOT null and COMMON_APP.GET_NGAY_LAMVIEC(DT.NGAYNHANTONGDAT,SYSDATE)<=5))
                             )
                            AND TD.BIEUMAUID=381
                            )
                       )
                    ;
              ELSIF(V_MALOAIVUVIEC='3')THEN 
                    OPEN V_CURSOR FOR
                    SELECT V_MA_THONGBAO || '-' || TO_CHAR (SYSDATE, 'yymmddhh24miss') MATRACUUTT,
                    HT.MA MALOAIHINHTHU,
                    AP.MA_THONGBAO,
                    TK.SOTK_KHOBAC SOTAIKHOANKB,
                    TK.MA_KHOBAC MAKHOBAC,
                    TK.TENTK_KHOBAC TENKHOBAC,
                    THA.MA_DINH_DANH MACHICUC,
                    TK.TEN_TK_THUHUONG TENCHICUC,
                    --DECODE(AP.TEN_TK_THUHUONG,NULL,AP.TENCHICUC,AP.TEN_TK_THUHUONG)TENCHICUC,
                    -- to_char(AI.NGAYTHONGBAO,'dd/MM/yyyy') NGAYTHONGBAO,
                    AI.NGAYTHONGBAO,
                    AI.SOTHONGBAO,
                    TA.MA_TEN TENTOATHONGBAO,
                    HT.TEN TENLOAIHINHTHU,
                    AP.HOTENNGUOINOP,
                    AP.SOCMNDNGUOINOP,
                    AP.DIACHINGUOINOP,
                    AP.HUYENNGUOINOP,
                    AP.TINHNGUOINOP,
                    AP.TONGTIEN
                   FROM (SELECT DECODE(DVT.DUONGSU_ID,NULL,DVT.DUONGSU_IDS,DVT.DUONGSU_ID)DUONGSU_IDSS,DVT.* FROM DVCQG_THANH_TOAN DVT) AP
                   LEFT JOIN DM_DONVITHIHANHAN THA ON THA.ID=AP.DONVITHA_ID
                   LEFT JOIN DM_TOAAN TA ON TA.ID=THA.ARRTOAANID
                   LEFT JOIN DM_TK_THANHTOAN TK ON TK.THA_ID=AP.DONVITHA_ID
                   LEFT JOIN DM_LOAIHINH_THU HT ON HT.ID=TK.MA_LOAIHINHTHU
                   ------
                   LEFT JOIN AHN_TONGDAT TD ON TD.ID=AP.TONGDATID
                   LEFT JOIN AHN_ANPHI AI ON AI.ID=AP.ANPHI_ID
                   --09/01/2025 NGAYNHANTONGDAT lấy ra  1 đương sự có NGAYGUI cũ nhất
                   LEFT JOIN(select decode(tts.NGAYNHANTONGDAT,null,tts.NGAYNHANTONGDATS,tts.NGAYNHANTONGDAT)NGAYNHANTONGDAT
                       ,DECODE(TTS.DUONGSUID,NULL,TTS.DUONGSUIDS,TTS.DUONGSUID)DUONGSUID,TTS.tongdatid
                       from (
                       SELECT SUBSTR(TT.NGAYNHANTONGDATS,0,instr(TT.NGAYNHANTONGDATS,',')-1)NGAYNHANTONGDAT
                       ,SUBSTR(TT.DUONGSUIDS,0,instr(TT.DUONGSUIDS,',')-1)DUONGSUID,TT.NGAYNHANTONGDATS,TT.DUONGSUIDS,TT.tongdatid
                                FROM (
                                    select tongdatid,LISTAGG(DUONGSUID, ',')WITHIN GROUP (ORDER BY NGAYGUI)DUONGSUIDS,
                                    LISTAGG(NGAYNHANTONGDAT,',')WITHIN GROUP (ORDER BY NGAYGUI)NGAYNHANTONGDATS from AHN_TONGDAT_DOITUONG
                                    group by tongdatid
                                )TT 
                        )tts 
                    )DT on DT.tongdatid=TD.ID and instr(','||AP.DUONGSU_IDS||',',','||DT.DUONGSUID||',')>0 
                   WHERE     AP.MA_THONGBAO = V_MA_THONGBAO
                    AND AP.TRANGTHAITHANHTOAN = 0
                    AND AP.TONGDATID IS NOT NULL 
                        AND( ( 
                            (  (DT.NGAYNHANTONGDAT is null and COMMON_APP.GET_NGAY_LAMVIEC(AI.NGAYTHONGBAO,SYSDATE)<=7) 
                               OR(DT.NGAYNHANTONGDAT is not null and COMMON_APP.GET_NGAY_LAMVIEC(DT.NGAYNHANTONGDAT,SYSDATE)<=7)
                             )
                           AND TD.BIEUMAUID=67
                          )
                         OR (
                             (  (DT.NGAYNHANTONGDAT is null and COMMON_APP.GET_NGAY_LAMVIEC(AI.NGAYTHONGBAO,SYSDATE)<=5)
                               OR((DT.NGAYNHANTONGDAT is NOT null and COMMON_APP.GET_NGAY_LAMVIEC(DT.NGAYNHANTONGDAT,SYSDATE)<=5))
                             )
                            AND TD.BIEUMAUID=381
                            )
                       )
--                    AND( (COMMON_APP.GET_NGAY_LAMVIEC(AI.NGAYTHONGBAO,SYSDATE)<=7 AND TD.BIEUMAUID=67)
--                        OR (COMMON_APP.GET_NGAY_LAMVIEC(AI.NGAYTHONGBAO,SYSDATE)<=5 AND TD.BIEUMAUID=381)
--                       )
                    ;
              ELSIF(V_MALOAIVUVIEC='4')THEN 
               OPEN V_CURSOR FOR
                    SELECT V_MA_THONGBAO || '-' || TO_CHAR (SYSDATE, 'yymmddhh24miss') MATRACUUTT,
                    HT.MA MALOAIHINHTHU,
                    AP.MA_THONGBAO,
                    TK.SOTK_KHOBAC SOTAIKHOANKB,
                    TK.MA_KHOBAC MAKHOBAC,
                    TK.TENTK_KHOBAC TENKHOBAC,
                    THA.MA_DINH_DANH MACHICUC,
                    TK.TEN_TK_THUHUONG TENCHICUC,
                    --DECODE(AP.TEN_TK_THUHUONG,NULL,AP.TENCHICUC,AP.TEN_TK_THUHUONG)TENCHICUC,
                    AI.NGAYTHONGBAO,
                    AI.SOTHONGBAO,
                    TA.MA_TEN TENTOATHONGBAO,
                    HT.TEN TENLOAIHINHTHU,
                    AP.HOTENNGUOINOP,
                    AP.SOCMNDNGUOINOP,
                    AP.DIACHINGUOINOP,
                    AP.HUYENNGUOINOP,
                    AP.TINHNGUOINOP,
                    AP.TONGTIEN
                   FROM DVCQG_THANH_TOAN AP
                   LEFT JOIN DM_DONVITHIHANHAN THA ON THA.ID=AP.DONVITHA_ID
                   LEFT JOIN DM_TOAAN TA ON TA.ID=THA.ARRTOAANID
                   LEFT JOIN DM_TK_THANHTOAN TK ON TK.THA_ID=AP.DONVITHA_ID
                   LEFT JOIN DM_LOAIHINH_THU HT ON HT.ID=TK.MA_LOAIHINHTHU
                   ------
                   LEFT JOIN AKT_TONGDAT TD ON TD.ID=AP.TONGDATID
                   LEFT JOIN AKT_ANPHI AI ON AI.ID=AP.ANPHI_ID
                    --09/01/2025 NGAYNHANTONGDAT lấy ra  1 đương sự có NGAYGUI cũ nhất
                   LEFT JOIN(select decode(tts.NGAYNHANTONGDAT,null,tts.NGAYNHANTONGDATS,tts.NGAYNHANTONGDAT)NGAYNHANTONGDAT
                                ,DECODE(TTS.DUONGSUID,NULL,TTS.DUONGSUIDS,TTS.DUONGSUID)DUONGSUID,TTS.tongdatid 
                                from (
                                    SELECT SUBSTR(TT.NGAYNHANTONGDATS,0,instr(TT.NGAYNHANTONGDATS,',')-1)NGAYNHANTONGDAT
                                    ,SUBSTR(TT.DUONGSUIDS,0,instr(TT.DUONGSUIDS,',')-1)DUONGSUID,TT.NGAYNHANTONGDATS,TT.DUONGSUIDS,TT.tongdatid
                                    FROM (
                                        select tongdatid,LISTAGG(DUONGSUID, ',')WITHIN GROUP (ORDER BY NGAYGUI)DUONGSUIDS,
                                        LISTAGG(NGAYNHANTONGDAT,',')WITHIN GROUP (ORDER BY NGAYGUI)NGAYNHANTONGDATS from AKT_TONGDAT_DOITUONG
                                        group by tongdatid
                                    )TT 
                             )tts 
                    )DT on DT.tongdatid=TD.ID and instr(','||AP.DUONGSU_ID||',',','||DT.DUONGSUID||',')>0 
                   WHERE     AP.MA_THONGBAO = V_MA_THONGBAO
                    AND AP.TRANGTHAITHANHTOAN = 0
                    AND AP.TONGDATID IS NOT NULL
                    AND( ( 
                            (  (DT.NGAYNHANTONGDAT is null and COMMON_APP.GET_NGAY_LAMVIEC(AI.NGAYTHONGBAO,SYSDATE)<=7) 
                               OR(DT.NGAYNHANTONGDAT is not null and COMMON_APP.GET_NGAY_LAMVIEC(DT.NGAYNHANTONGDAT,SYSDATE)<=7)
                             )
                           AND TD.BIEUMAUID=67
                          )
                         OR (
                             (  (DT.NGAYNHANTONGDAT is null and COMMON_APP.GET_NGAY_LAMVIEC(AI.NGAYTHONGBAO,SYSDATE)<=5)
                               OR((DT.NGAYNHANTONGDAT is NOT null and COMMON_APP.GET_NGAY_LAMVIEC(DT.NGAYNHANTONGDAT,SYSDATE)<=5))
                             )
                            AND TD.BIEUMAUID=381
                            )
                       )
--                    AND( (COMMON_APP.GET_NGAY_LAMVIEC(AI.NGAYTHONGBAO,SYSDATE)<=7 AND TD.BIEUMAUID=67)
--                        OR (COMMON_APP.GET_NGAY_LAMVIEC(AI.NGAYTHONGBAO,SYSDATE)<=5 AND TD.BIEUMAUID=381)
--                       )
                    ;
               ELSIF(V_MALOAIVUVIEC='5')THEN 
               OPEN V_CURSOR FOR
                    SELECT V_MA_THONGBAO || '-' || TO_CHAR (SYSDATE, 'yymmddhh24miss') MATRACUUTT,
                    HT.MA MALOAIHINHTHU,
                    AP.MA_THONGBAO,
                    TK.SOTK_KHOBAC SOTAIKHOANKB,
                    TK.MA_KHOBAC MAKHOBAC,
                    TK.TENTK_KHOBAC TENKHOBAC,
                    THA.MA_DINH_DANH MACHICUC,
                    TK.TEN_TK_THUHUONG TENCHICUC,
                    --DECODE(AP.TEN_TK_THUHUONG,NULL,AP.TENCHICUC,AP.TEN_TK_THUHUONG)TENCHICUC,
                    AI.NGAYTHONGBAO,
                    AI.SOTHONGBAO,
                    TA.MA_TEN TENTOATHONGBAO,
                    HT.TEN TENLOAIHINHTHU,
                    AP.HOTENNGUOINOP,
                    AP.SOCMNDNGUOINOP,
                    AP.DIACHINGUOINOP,
                    AP.HUYENNGUOINOP,
                    AP.TINHNGUOINOP,
                    AP.TONGTIEN
                   FROM DVCQG_THANH_TOAN AP
                   LEFT JOIN DM_DONVITHIHANHAN THA ON THA.ID=AP.DONVITHA_ID
                   LEFT JOIN DM_TOAAN TA ON TA.ID=THA.ARRTOAANID
                   LEFT JOIN DM_TK_THANHTOAN TK ON TK.THA_ID=AP.DONVITHA_ID
                   LEFT JOIN DM_LOAIHINH_THU HT ON HT.ID=TK.MA_LOAIHINHTHU
                   ------
                   LEFT JOIN ALD_TONGDAT TD ON TD.ID=AP.TONGDATID
                   LEFT JOIN ALD_ANPHI AI ON AI.ID=AP.ANPHI_ID
                    --09/01/2025 NGAYNHANTONGDAT lấy ra  1 đương sự có NGAYGUI cũ nhất
                    LEFT JOIN(select decode(tts.NGAYNHANTONGDAT,null,tts.NGAYNHANTONGDATS,tts.NGAYNHANTONGDAT)NGAYNHANTONGDAT
                            ,DECODE(TTS.DUONGSUID,NULL,TTS.DUONGSUIDS,TTS.DUONGSUID)DUONGSUID,TTS.tongdatid 
                            from (
                            SELECT SUBSTR(TT.NGAYNHANTONGDATS,0,instr(TT.NGAYNHANTONGDATS,',')-1)NGAYNHANTONGDAT
                            ,SUBSTR(TT.DUONGSUIDS,0,instr(TT.DUONGSUIDS,',')-1)DUONGSUID,TT.NGAYNHANTONGDATS,TT.DUONGSUIDS,TT.tongdatid
                              FROM (
                                    select tongdatid,LISTAGG(DUONGSUID, ',')WITHIN GROUP (ORDER BY NGAYGUI)DUONGSUIDS,
                                    LISTAGG(NGAYNHANTONGDAT,',')WITHIN GROUP (ORDER BY NGAYGUI)NGAYNHANTONGDATS from ALD_TONGDAT_DOITUONG
                                    group by tongdatid
                                )TT 
                        )tts 
                    )DT on DT.tongdatid=TD.ID and instr(','||AP.DUONGSU_ID||',',','||DT.DUONGSUID||',')>0
                   WHERE     AP.MA_THONGBAO = V_MA_THONGBAO
                    AND AP.TRANGTHAITHANHTOAN = 0
                    AND AP.TONGDATID IS NOT NULL
                     AND( ( 
                            (  (DT.NGAYNHANTONGDAT is null and COMMON_APP.GET_NGAY_LAMVIEC(AI.NGAYTHONGBAO,SYSDATE)<=7) 
                               OR(DT.NGAYNHANTONGDAT is not null and COMMON_APP.GET_NGAY_LAMVIEC(DT.NGAYNHANTONGDAT,SYSDATE)<=7)
                             )
                           AND TD.BIEUMAUID=67
                          )
                         OR (
                             (  (DT.NGAYNHANTONGDAT is null and COMMON_APP.GET_NGAY_LAMVIEC(AI.NGAYTHONGBAO,SYSDATE)<=5)
                               OR((DT.NGAYNHANTONGDAT is NOT null and COMMON_APP.GET_NGAY_LAMVIEC(DT.NGAYNHANTONGDAT,SYSDATE)<=5))
                             )
                            AND TD.BIEUMAUID=381
                            )
                       )
--                   AND( (COMMON_APP.GET_NGAY_LAMVIEC(AI.NGAYTHONGBAO,SYSDATE)<=7 AND TD.BIEUMAUID=67)
--                        OR (COMMON_APP.GET_NGAY_LAMVIEC(AI.NGAYTHONGBAO,SYSDATE)<=5 AND TD.BIEUMAUID=381)
--                       )
                    ;
              ELSIF(V_MALOAIVUVIEC='6')THEN 
              OPEN V_CURSOR FOR
                    SELECT V_MA_THONGBAO || '-' || TO_CHAR (SYSDATE, 'yymmddhh24miss') MATRACUUTT,
                    HT.MA MALOAIHINHTHU,
                    AP.MA_THONGBAO,
                    TK.SOTK_KHOBAC SOTAIKHOANKB,
                    TK.MA_KHOBAC MAKHOBAC,
                    TK.TENTK_KHOBAC TENKHOBAC,
                    THA.MA_DINH_DANH MACHICUC,
                    TK.TEN_TK_THUHUONG TENCHICUC,
                    --DECODE(AP.TEN_TK_THUHUONG,NULL,AP.TENCHICUC,AP.TEN_TK_THUHUONG)TENCHICUC,
                     AI.NGAYTHONGBAO,
                    AI.SOTHONGBAO,
                    TA.MA_TEN TENTOATHONGBAO,
                    HT.TEN TENLOAIHINHTHU,
                    AP.HOTENNGUOINOP,
                    AP.SOCMNDNGUOINOP,
                    AP.DIACHINGUOINOP,
                    AP.HUYENNGUOINOP,
                    AP.TINHNGUOINOP,
                    AP.TONGTIEN
                   FROM (SELECT DECODE(DVT.DUONGSU_ID,NULL,DVT.DUONGSU_IDS,DVT.DUONGSU_ID)DUONGSU_IDSS,DVT.* FROM DVCQG_THANH_TOAN DVT) AP
                   LEFT JOIN DM_DONVITHIHANHAN THA ON THA.ID=AP.DONVITHA_ID
                   LEFT JOIN DM_TOAAN TA ON TA.ID=THA.ARRTOAANID
                   LEFT JOIN DM_TK_THANHTOAN TK ON TK.THA_ID=AP.DONVITHA_ID
                   LEFT JOIN DM_LOAIHINH_THU HT ON HT.ID=TK.MA_LOAIHINHTHU
                   ------
                   LEFT JOIN AHC_TONGDAT TD ON TD.ID=AP.TONGDATID
                   LEFT JOIN AHC_ANPHI AI ON AI.ID=AP.ANPHI_ID
                   --09/01/2025 NGAYNHANTONGDAT lấy ra  1 đương sự có NGAYGUI cũ nhất
                   LEFT JOIN(select decode(tts.NGAYNHANTONGDAT,null,tts.NGAYNHANTONGDATS,tts.NGAYNHANTONGDAT)NGAYNHANTONGDAT
                       ,DECODE(TTS.DUONGSUID,NULL,TTS.DUONGSUIDS,TTS.DUONGSUID)DUONGSUID,TTS.tongdatid
                       from (
                       SELECT SUBSTR(TT.NGAYNHANTONGDATS,0,instr(TT.NGAYNHANTONGDATS,',')-1)NGAYNHANTONGDAT
                       ,SUBSTR(TT.DUONGSUIDS,0,instr(TT.DUONGSUIDS,',')-1)DUONGSUID,TT.NGAYNHANTONGDATS,TT.DUONGSUIDS,TT.tongdatid
                                FROM (
                                    select tongdatid,LISTAGG(DUONGSUID, ',')WITHIN GROUP (ORDER BY NGAYGUI)DUONGSUIDS,
                                    LISTAGG(NGAYNHANTONGDAT,',')WITHIN GROUP (ORDER BY NGAYGUI)NGAYNHANTONGDATS from AHC_TONGDAT_DOITUONG
                                    group by tongdatid
                                )TT 
                        )tts 
                    )DT on DT.tongdatid=TD.ID and instr(','||AP.DUONGSU_IDS||',',','||DT.DUONGSUID||',')>0 
                   WHERE     AP.MA_THONGBAO = V_MA_THONGBAO
                    AND AP.TRANGTHAITHANHTOAN = 0
                    AND AP.TONGDATID IS NOT NULL
                    AND( ( 
                            (  (DT.NGAYNHANTONGDAT is null and COMMON_APP.GET_NGAY_LAMVIEC(AI.NGAYTHONGBAO,SYSDATE)<=10) 
                               OR(DT.NGAYNHANTONGDAT is not null and COMMON_APP.GET_NGAY_LAMVIEC(DT.NGAYNHANTONGDAT,SYSDATE)<=10)
                             )
                           AND TD.BIEUMAUID=121
                          )
                         OR (
                             (  (DT.NGAYNHANTONGDAT is null and COMMON_APP.GET_NGAY_LAMVIEC(AI.NGAYTHONGBAO,SYSDATE)<=5)
                               OR((DT.NGAYNHANTONGDAT is NOT null and COMMON_APP.GET_NGAY_LAMVIEC(DT.NGAYNHANTONGDAT,SYSDATE)<=5))
                             )
                            AND TD.BIEUMAUID=381
                            )
                       )
--                    AND( (COMMON_APP.GET_NGAY_LAMVIEC(AI.NGAYTHONGBAO,SYSDATE)<=10 AND TD.BIEUMAUID=121)--7->10 12/11/2024
--                        OR (COMMON_APP.GET_NGAY_LAMVIEC(AI.NGAYTHONGBAO,SYSDATE)<=5 AND TD.BIEUMAUID=381)
--                       )
                    ;
               ELSIF(V_MALOAIVUVIEC='7')THEN 
                OPEN V_CURSOR FOR
                    SELECT V_MA_THONGBAO || '-' || TO_CHAR (SYSDATE, 'yymmddhh24miss') MATRACUUTT,
                    HT.MA MALOAIHINHTHU,
                    AP.MA_THONGBAO,
                    TK.SOTK_KHOBAC SOTAIKHOANKB,
                    TK.MA_KHOBAC MAKHOBAC,
                    TK.TENTK_KHOBAC TENKHOBAC,
                    THA.MA_DINH_DANH MACHICUC,
                    TK.TEN_TK_THUHUONG TENCHICUC,
                    --DECODE(AP.TEN_TK_THUHUONG,NULL,AP.TENCHICUC,AP.TEN_TK_THUHUONG)TENCHICUC,
                    AI.NGAYTHONGBAO,
                    AI.SOTHONGBAO,
                    TA.MA_TEN TENTOATHONGBAO,
                    HT.TEN TENLOAIHINHTHU,
                    AP.HOTENNGUOINOP,
                    AP.SOCMNDNGUOINOP,
                    AP.DIACHINGUOINOP,
                    AP.HUYENNGUOINOP,
                    AP.TINHNGUOINOP,
                    AP.TONGTIEN
                   FROM DVCQG_THANH_TOAN AP
                   LEFT JOIN DM_DONVITHIHANHAN THA ON THA.ID=AP.DONVITHA_ID
                   LEFT JOIN DM_TOAAN TA ON TA.ID=THA.ARRTOAANID
                   LEFT JOIN DM_TK_THANHTOAN TK ON TK.THA_ID=AP.DONVITHA_ID
                   LEFT JOIN DM_LOAIHINH_THU HT ON HT.ID=TK.MA_LOAIHINHTHU
                   ------
                   LEFT JOIN APS_TONGDAT TD ON TD.ID=AP.TONGDATID
                   LEFT JOIN APS_ANPHI AI ON AI.ID=AP.ANPHI_ID
                   --09/01/2025 NGAYNHANTONGDAT lấy ra  1 đương sự có NGAYGUI cũ nhất
                   LEFT JOIN(select decode(tts.NGAYNHANTONGDAT,null,tts.NGAYNHANTONGDATS,tts.NGAYNHANTONGDAT)NGAYNHANTONGDAT
                       ,DECODE(TTS.DUONGSUID,NULL,TTS.DUONGSUIDS,TTS.DUONGSUID)DUONGSUID,TTS.tongdatid 
                       from (
                       SELECT SUBSTR(TT.NGAYNHANTONGDATS,0,instr(TT.NGAYNHANTONGDATS,',')-1)NGAYNHANTONGDAT
                       ,SUBSTR(TT.DUONGSUIDS,0,instr(TT.DUONGSUIDS,',')-1)DUONGSUID,TT.NGAYNHANTONGDATS,TT.DUONGSUIDS,TT.tongdatid
                                FROM (
                                    select tongdatid,LISTAGG(DUONGSUID, ',')WITHIN GROUP (ORDER BY NGAYGUI)DUONGSUIDS,
                                    LISTAGG(NGAYNHANTONGDAT,',')WITHIN GROUP (ORDER BY NGAYGUI)NGAYNHANTONGDATS from APS_TONGDAT_DOITUONG
                                    group by tongdatid
                                )TT 
                        )tts 
                    )DT on DT.tongdatid=TD.ID and instr(','||AP.DUONGSU_ID||',',','||DT.DUONGSUID||',')>0
                   WHERE     AP.MA_THONGBAO = V_MA_THONGBAO
                    AND AP.TRANGTHAITHANHTOAN = 0
                    AND AP.TONGDATID IS NOT NULL
                    AND( ( 
                            (  (DT.NGAYNHANTONGDAT is null and COMMON_APP.GET_NGAY_LAMVIEC(AI.NGAYTHONGBAO,SYSDATE)<=7) 
                               OR(DT.NGAYNHANTONGDAT is not null and COMMON_APP.GET_NGAY_LAMVIEC(DT.NGAYNHANTONGDAT,SYSDATE)<=7)
                             )
                           AND TD.BIEUMAUID=67
                          )
                         OR (
                             (  (DT.NGAYNHANTONGDAT is null and COMMON_APP.GET_NGAY_LAMVIEC(AI.NGAYTHONGBAO,SYSDATE)<=5)
                               OR((DT.NGAYNHANTONGDAT is NOT null and COMMON_APP.GET_NGAY_LAMVIEC(DT.NGAYNHANTONGDAT,SYSDATE)<=5))
                             )
                            AND TD.BIEUMAUID=381
                            )
                       )
--                    AND( (COMMON_APP.GET_NGAY_LAMVIEC(AI.NGAYTHONGBAO,SYSDATE)<=7 AND TD.BIEUMAUID=67)
--                        OR (COMMON_APP.GET_NGAY_LAMVIEC(AI.NGAYTHONGBAO,SYSDATE)<=5 AND TD.BIEUMAUID=381)
--                       )
                    ;
             END IF;
      --Insert bao bang Giao dich khi có tìm kiêm đúng V_MA_THONGBAO và chua thanh toan
      BEGIN
         SELECT ID
           INTO v_THANH_TOAN_ID
           FROM DVCQG_THANH_TOAN
          WHERE     MA_THONGBAO = V_MA_THONGBAO
                AND TRANGTHAITHANHTOAN = 0
                AND TONGDATID IS NOT NULL;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_THANH_TOAN_ID := 0;
      END;

      IF v_THANH_TOAN_ID > 0
      THEN
         INSERT INTO DVCQG_GIAODICH (MATRACUUTT, THANH_TOAN_ID, NGAYTAO)
                 VALUES (
                              V_MA_THONGBAO
                           || '-'
                           || TO_CHAR (SYSDATE, 'yymmddhh24miss'),
                           v_THANH_TOAN_ID,
                           SYSDATE);

         COMMIT;
      END IF;
   END TB_TU_ANPHI_SEARCH;

   PROCEDURE TB_TU_ANPHI_THANHTOAN (
      v_MATRACUUTT           IN     VARCHAR2,
      v_MA_THONGBAO          IN     VARCHAR2,
      v_HOTENNGUOINOPTIEN    IN     VARCHAR2,
      v_SOCMNDNGUOINOP       IN     VARCHAR2,
      v_DIACHINGUOINOPTIEN   IN     VARCHAR2,
      v_TINHNGUOINOPTIEN     IN     VARCHAR2,
      v_HUYENNGUOINOPTIEN    IN     VARCHAR2,
      v_XANGUOINOPTIEN       IN     VARCHAR2,
      v_URLBIENLAI           IN     VARCHAR2,
      v_SOTIEN               IN     VARCHAR2,
      v_TRANGTHAITHANHTOAN   IN     NUMBER,
      v_FILE_ATTACH          IN     BLOB,
      v_FILE_NAME            IN     VARCHAR2,
      v_SOBIENLAI            IN     VARCHAR2,
      v_NGAYBIENLAI          IN     DATE,
      v_DONVITHUTIEN         IN     VARCHAR2,
      l_Cursor_ERRO             OUT SYS_REFCURSOR)
   AS
      l_MALOAIVUVIEC         VARCHAR2 (250);
      l_THANH_TOAN_ID        VARCHAR2 (20);
      l_TONGDATID            NUMBER;
      l_DONID                NUMBER;
      l_TRANGTHAITHANHTOAN   NUMBER;
      -- l_Cursor_ERRO sys_refcursor;
      l_error_code           VARCHAR2 (250) DEFAULT '-1'; --0
      l_message              VARCHAR2 (250)
         DEFAULT 'Chưa nhận thông tin thanh toán'; --Nhận thông tin thanh toán thành công
               l_uri_ss               VARCHAR2 (250)
                                DEFAULT 'http://10.1.19.160:8080/VXPAdapter';
      l_exp                  NUMBER;
      V_COUNT                NUMBER;V_COUNT_BL NUMBER;V_COUNT_STATUS NUMBER;
      V_DUONGSUID     NUMBER;V_DUONGSUIDS    VARCHAR2 (512);
      V_SOBIENLAIS  NUMBER; V_DONVITHA_ID VARCHAR2 (100);V_ANPHI_ID NUMBER;
   BEGIN
         IF INSTR (trim(v_URLBIENLAI),
                'http',
                1,
                1) = 1
      THEN
      BEGIN
         --Lay ra ma Thanh Toan
         SELECT ID,DONID,MALOAIVUVIEC,TONGDATID,TRANGTHAITHANHTOAN,DUONGSU_ID,DUONGSU_IDS,DONVITHA_ID,ANPHI_ID
           INTO l_THANH_TOAN_ID,l_DONID,l_MALOAIVUVIEC,l_TONGDATID,l_TRANGTHAITHANHTOAN,V_DUONGSUID,V_DUONGSUIDS,V_DONVITHA_ID,V_ANPHI_ID
           FROM DVCQG_THANH_TOAN
          WHERE MA_THONGBAO = V_MA_THONGBAO AND TONGDATID IS NOT NULL;



         IF (l_TRANGTHAITHANHTOAN = 0)
         THEN
           -------------tạo số biên lai theo đơn vị
            SELECT NVL(MAX(TO_NUMBER(REGEXP_REPLACE(T.SOBIENLAI, '[^0-9]'))), 0)+1 INTO V_SOBIENLAIS   FROM TUPHAP_ANPHI T
            WHERE T.DONVI_THUTIEN_ID = V_DONVITHA_ID
                    AND T.NGAYBIENLAI >= to_date('01/01/'||EXTRACT(YEAR FROM  sysdate),'dd/MM/yyyy')
                    AND T.NGAYBIENLAI<to_date('31/12/'||EXTRACT(YEAR FROM  sysdate),'dd/MM/yyyy');
            ------------
            -- Cập nhật lại Thanh toán khi đã thanh toán
            UPDATE DVCQG_THANH_TOAN
               SET                            --  MA_THONGBAO = v_MA_THONGBAO,
                  HOTENNGUOINOPTIEN = v_HOTENNGUOINOPTIEN,
                   SOCMNDNGUOINOP = v_SOCMNDNGUOINOP,
                   DIACHINGUOINOPTIEN = v_DIACHINGUOINOPTIEN,
                   TINHNGUOINOPTIEN = v_TINHNGUOINOPTIEN,
                   HUYENNGUOINOPTIEN = v_HUYENNGUOINOPTIEN,
                   XANGUOINOPTIEN = v_XANGUOINOPTIEN,
                   SOBIENLAI = V_SOBIENLAIS,
                      URLBIENLAI =
                            l_uri_ss
                         || SUBSTR (v_URLBIENLAI,
                                    INSTR (v_URLBIENLAI,
                                           '/',
                                           1,
                                           4)),
                   SOTIEN = v_SOTIEN,
                   TRANGTHAITHANHTOAN = 1,--v_TRANGTHAITHANHTOAN,
                   TT_TRUCTUYEN=1,
                   THOIGIANTHANHTOAN=v_NGAYBIENLAI
             WHERE MA_THONGBAO = V_MA_THONGBAO;


            -- cập nhật bang BienLai V_COUNT_BL
            IF v_FILE_NAME IS NOT NULL THEN
             SELECT COUNT(*) INTO V_COUNT_BL FROM DVCQG_FILE_BIENLAI WHERE TP_THANH_TOAN_ID=l_THANH_TOAN_ID;
                IF(V_COUNT_BL=0)THEN
                       INSERT INTO DVCQG_FILE_BIENLAI 
                               (ID,TP_THANH_TOAN_ID,FILE_ATTACH,FILE_NAME)
                        VALUES (DVCQG_FILE_BIENLAI_SEQ.NEXTVAL,l_THANH_TOAN_ID,v_FILE_ATTACH,v_FILE_NAME);
                ELSIF(V_COUNT_BL>0)THEN      
                     UPDATE DVCQG_FILE_BIENLAI
                     SET FILE_ATTACH=v_FILE_ATTACH,FILE_NAME=v_FILE_NAME
                     WHERE TP_THANH_TOAN_ID=l_THANH_TOAN_ID;
                END IF;
            END IF;

            -- Cập nhật trạng thái về bảng án phí
            IF l_MALOAIVUVIEC = '2'
            THEN
               UPDATE ADS_ANPHI
                  SET SOBIENLAI = V_SOBIENLAIS,
                     -- NGAYNOPANPHI = v_NGAYBIENLAI,
                      TAMUNGANPHI = v_SOTIEN
                     -- NGAYNOPBIENLAI = v_NGAYBIENLAI
                WHERE DONID = l_DONID AND DUONGSU_ID=V_DUONGSUID;

            ELSIF l_MALOAIVUVIEC = '3'
            THEN
               -- Bang án phí hôn nhân
               UPDATE AHN_ANPHI
                  SET SOBIENLAI = V_SOBIENLAIS,
                      --NGAYNOPANPHI = v_NGAYBIENLAI,
                      TAMUNGANPHI = v_SOTIEN
                      --NGAYNOPBIENLAI = v_NGAYBIENLAI
                WHERE DONID = l_DONID AND DUONGSU_IDS=V_DUONGSUIDS;
            ELSIF l_MALOAIVUVIEC = '4'
            THEN
               -- Bang án phí Kinh doanh thuong mai
               UPDATE AKT_ANPHI
                  SET SOBIENLAI = V_SOBIENLAIS,
                      --NGAYNOPANPHI = v_NGAYBIENLAI,
                      TAMUNGANPHI = v_SOTIEN
                      --NGAYNOPBIENLAI = v_NGAYBIENLAI
                WHERE DONID = l_DONID AND DUONGSU_ID=V_DUONGSUID;
            ELSIF l_MALOAIVUVIEC = '5'
            THEN
               -- Bang án phí Lao dong
               UPDATE ALD_ANPHI
                  SET SOBIENLAI = V_SOBIENLAIS,
                      --NGAYNOPANPHI = v_NGAYBIENLAI,
                      TAMUNGANPHI = v_SOTIEN
                      --NGAYNOPBIENLAI = v_NGAYBIENLAI
                WHERE DONID = l_DONID AND DUONGSU_ID=V_DUONGSUID;
            ELSIF l_MALOAIVUVIEC = '6'
            THEN
               -- Bang án phí Hành chính
               UPDATE AHC_ANPHI
                  SET SOBIENLAI = V_SOBIENLAIS,
                      --NGAYNOPANPHI = v_NGAYBIENLAI,
                      TAMUNGANPHI = v_SOTIEN
                      --NGAYNOPBIENLAI = v_NGAYBIENLAI
                WHERE DONID = l_DONID AND DUONGSU_IDS=V_DUONGSUIDS;
            ELSIF l_MALOAIVUVIEC = '7'
            THEN
               -- Bang án phí Phá sản
               UPDATE APS_ANPHI
                  SET SOBIENLAI = V_SOBIENLAIS,
                     -- NGAYNOPANPHI = v_NGAYBIENLAI,
                      TAMUNGANPHI = v_SOTIEN
                    --  NGAYNOPBIENLAI = v_NGAYBIENLAI
                WHERE DONID = l_DONID AND DUONGSU_ID=V_DUONGSUID;
            END IF;

            --Đổ vào bảng ÁN PHÍ
        IF(l_MALOAIVUVIEC='2' OR l_MALOAIVUVIEC='4' OR l_MALOAIVUVIEC='5' OR l_MALOAIVUVIEC='7') THEN
                    SELECT COUNT(*)INTO V_COUNT FROM TUPHAP_ANPHI TP WHERE TP.DVCQG_TT_ID=l_THANH_TOAN_ID;
                    IF(V_COUNT=0)THEN
                        INSERT INTO TUPHAP_ANPHI 
                        (ID,MALOAIVUVIEC,VUVIECID,SOBIENLAI,NGAYBIENLAI,ANPHI,DONVI_THUTIEN_ID,
                         NGAYTAO,NGUOITAO,NGUOITAOID,NGUOITHUTIEN,NOP_ISNGUYENDON,NOP_HOTEN,NOP_GIOITINH,NOP_NAMSINH,NOP_CMND,NOP_TEL,NOP_EMAIL,NOP_DIACHI,
                         ANPHI_ID,DUONGSU_ID,DVCQG_TT_ID)
                     VALUES (TUPHAP_ANPHI_SEQ.NEXTVAL,l_MALOAIVUVIEC,l_DONID,V_SOBIENLAIS,SYSDATE,v_SOTIEN,V_DONVITHA_ID,
                        SYSDATE,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
                        V_ANPHI_ID,V_DUONGSUID,l_THANH_TOAN_ID);
                     ELSE
                       UPDATE TUPHAP_ANPHI
                       SET MALOAIVUVIEC=l_MALOAIVUVIEC,VUVIECID=l_DONID,SOBIENLAI=V_SOBIENLAIS,NGAYBIENLAI=SYSDATE,ANPHI=v_SOTIEN,DONVI_THUTIEN_ID=V_DONVITHA_ID,
                       NGAYTAO=SYSDATE,ANPHI_ID=V_ANPHI_ID,DUONGSU_ID=V_DUONGSUID,DVCQG_TT_ID=l_THANH_TOAN_ID
                       where DVCQG_TT_ID=l_THANH_TOAN_ID;
                     END IF;
                     -- INSERT INTO DVCQG_THANH_TOAN_ERRO VALUES (l_error_code,l_message);
--                     ELSE
--                        l_error_code := '1';
--                        l_message := 'TATC đã nhận được thông tin thanh toán';
--                     --   INSERT INTO DVCQG_THANH_TOAN_ERRO VALUES (l_error_code,l_message);
         END IF;
         ---------
         IF(l_MALOAIVUVIEC='3' OR l_MALOAIVUVIEC='6') THEN
                    SELECT COUNT(*)INTO V_COUNT FROM TUPHAP_ANPHI TP WHERE TP.DVCQG_TT_ID=l_THANH_TOAN_ID;
                    IF(V_COUNT=0)THEN
                        INSERT INTO TUPHAP_ANPHI 
                        (ID,MALOAIVUVIEC,VUVIECID,SOBIENLAI,NGAYBIENLAI,ANPHI,DONVI_THUTIEN_ID,
                         NGAYTAO,NGUOITAO,NGUOITAOID,NGUOITHUTIEN,NOP_ISNGUYENDON,NOP_HOTEN,NOP_GIOITINH,NOP_NAMSINH,NOP_CMND,NOP_TEL,NOP_EMAIL,NOP_DIACHI,
                         ANPHI_ID,DUONGSU_IDS,DVCQG_TT_ID)
                        VALUES (TUPHAP_ANPHI_SEQ.NEXTVAL,l_MALOAIVUVIEC,l_DONID,V_SOBIENLAIS,SYSDATE,v_SOTIEN,V_DONVITHA_ID,
                        SYSDATE,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
                        V_ANPHI_ID,V_DUONGSUIDS,l_THANH_TOAN_ID);
                     ELSE
                       UPDATE TUPHAP_ANPHI
                       SET MALOAIVUVIEC=l_MALOAIVUVIEC,VUVIECID=l_DONID,SOBIENLAI=V_SOBIENLAIS,NGAYBIENLAI=SYSDATE,ANPHI=v_SOTIEN,DONVI_THUTIEN_ID=V_DONVITHA_ID,
                       NGAYTAO=SYSDATE,ANPHI_ID=V_ANPHI_ID,DUONGSU_IDS=V_DUONGSUIDS,DVCQG_TT_ID=l_THANH_TOAN_ID
                      where DVCQG_TT_ID=l_THANH_TOAN_ID;
                     END IF;
                     -- INSERT INTO DVCQG_THANH_TOAN_ERRO VALUES (l_error_code,l_message);
--                     ELSE
--                        l_error_code := '1';
--                        l_message := 'TATC đã nhận được thông tin thanh toán';
--                     --   INSERT INTO DVCQG_THANH_TOAN_ERRO VALUES (l_error_code,l_message);
         END IF;



     END IF;
     
---Hiepnt add 20/01/2025: update noi dung file bien lai
/*IF (l_TRANGTHAITHANHTOAN = 1)
    THEN
	
	IF(length(v_FILE_ATTACH)<1000)THEN
             UPDATE DVCQG_FILE_BIENLAI
                     SET FILE_ATTACH=v_FILE_ATTACH,FILE_NAME=v_FILE_NAME
                     WHERE TP_THANH_TOAN_ID=l_THANH_TOAN_ID;
	END IF;
	
	END IF;
*/
---Hiepnt end 20/01/2025
     

      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_exp := 1;
            l_error_code := '-1';
            l_message :=
                  'An error was encountered - '
               || SQLCODE
               || ' -ERROR- '
               || SQLERRM;
         WHEN OTHERS
         THEN
            ROLLBACK;
            l_exp := 2;
            l_error_code := '-1';
            l_message :=
                  'An error was encountered - '
               || SQLCODE
               || ' -ERROR- '
               || SQLERRM;
      --     INSERT INTO DVCQG_THANH_TOAN_ERRO VALUES (l_error_code,l_message);
      --OPEN l_Cursor_ERRO FOR select * from DVCQG_THANH_TOAN_ERRO;
      END;
      ELSE
         l_error_code := '-1';
         l_message :=
            'Chưa có URL biên lai thu tạm ứng án phí hoặc URL không đúng';
      END IF;
      /* Cập nhậtlogs trạng thái thanh toán */

                       -------------------
         SELECT COUNT(*) INTO V_COUNT_STATUS  FROM DVCQG_THANH_TOAN
         WHERE MA_THONGBAO = V_MA_THONGBAO AND TRANGTHAITHANHTOAN=1 AND URLBIENLAI IS NOT NULL;
            IF(V_COUNT_STATUS>0)THEN
                    l_error_code := '1';
                    l_message := 'TATC đã nhận được thông tin thanh toán';
                 --   INSERT INTO DVCQG_THANH_TOAN_ERRO VALUES (l_error_code,l_message);
             ELSE
         l_error_code := '-1';
         l_message :=
            'Chưa cập nhật được thông tin thanh toán tạm ứng án phí';
             END IF;
         -----------------

      INSERT INTO DVCQG_THANH_TOAN_LOGS (ID,
                                         MA_THONGBAO,
                                         ERROR_CODE,
                                         MESSAGE,
                                         CREATED_DATE)
           VALUES (DVCQG_TT_LOGS_SEQ.NEXTVAL,
                   v_MA_THONGBAO,
                   l_error_code,
                   l_message,
                   SYSDATE);

      COMMIT;

      IF l_exp = 1
      THEN
         l_message := 'Không tìm thấy mã thông báo';
      END IF;

      IF l_exp = 2
      THEN
         l_message := 'Không cập nhật được thông tin thanh toán';
      END IF;

      OPEN l_Cursor_ERRO FOR
         SELECT l_error_code AS ERROR_CODE, l_message AS MESSAGE FROM DUAL;
   --  return  l_Cursor_ERRO;
   END TB_TU_ANPHI_THANHTOAN;

   PROCEDURE THANH_TOAN_SEARCH (
    V_MAGIAIDOAN IN NUMBER,
    V_DONXULY_ID     IN     NUMBER, -- Trên app truyền vào giá trị DONID chứ không phải ID của XULYDON
    V_ANPHI_ID     IN     NUMBER,
    V_MALOAIVUVIEC   IN     VARCHAR2,
    curReturn           OUT SYS_REFCURSOR)
   IS
   BEGIN
      OPEN curReturn FOR
         SELECT *
           FROM DVCQG_THANH_TOAN
          WHERE (DONID = V_DONXULY_ID /*OR DONXULY_ID = V_DONXULY_ID*/) AND ANPHI_ID = V_ANPHI_ID AND MALOAIVUVIEC = V_MALOAIVUVIEC AND MAGIAIDOAN=V_MAGIAIDOAN;
   END THANH_TOAN_SEARCH;

   PROCEDURE THANH_TOAN_SEARCH_KC (
    V_MAGIAIDOAN IN NUMBER,
    V_DONXULY_ID     IN     NUMBER,
    V_MALOAIVUVIEC   IN     VARCHAR2,
    curReturn           OUT SYS_REFCURSOR)
   IS
   BEGIN
      OPEN curReturn FOR
         SELECT *
           FROM DVCQG_THANH_TOAN
          WHERE DONID = V_DONXULY_ID AND MALOAIVUVIEC = V_MALOAIVUVIEC AND MAGIAIDOAN=V_MAGIAIDOAN;
   END THANH_TOAN_SEARCH_KC;
END PKG_DVCQG;