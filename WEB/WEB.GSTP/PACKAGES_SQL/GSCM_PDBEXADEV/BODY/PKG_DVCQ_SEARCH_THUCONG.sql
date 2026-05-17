--------------------------------------------------------
--  DDL for Package Body PKG_DVCQ_SEARCH_THUCONG
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_DVCQ_SEARCH_THUCONG" AS

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
                   WHERE     AP.MA_THONGBAO = V_MA_THONGBAO
                    AND AP.TRANGTHAITHANHTOAN = 0
                    AND AP.TONGDATID IS NOT NULL
--                    AND( (COMMON_APP.GET_NGAY_LAMVIEC(AI.NGAYTHONGBAO,SYSDATE)<=7 AND TD.BIEUMAUID=67)
--                        OR (COMMON_APP.GET_NGAY_LAMVIEC(AI.NGAYTHONGBAO,SYSDATE)<=5 AND TD.BIEUMAUID=381)
--                       )
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
                   FROM DVCQG_THANH_TOAN AP
                   LEFT JOIN DM_DONVITHIHANHAN THA ON THA.ID=AP.DONVITHA_ID
                   LEFT JOIN DM_TOAAN TA ON TA.ID=THA.ARRTOAANID
                   LEFT JOIN DM_TK_THANHTOAN TK ON TK.THA_ID=AP.DONVITHA_ID
                   LEFT JOIN DM_LOAIHINH_THU HT ON HT.ID=TK.MA_LOAIHINHTHU
                   ------
                   LEFT JOIN AHN_TONGDAT TD ON TD.ID=AP.TONGDATID
                   LEFT JOIN AHN_ANPHI AI ON AI.ID=AP.ANPHI_ID
                   WHERE     AP.MA_THONGBAO = V_MA_THONGBAO
                    AND AP.TRANGTHAITHANHTOAN = 0
                    AND AP.TONGDATID IS NOT NULL
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
                   WHERE     AP.MA_THONGBAO = V_MA_THONGBAO
                    AND AP.TRANGTHAITHANHTOAN = 0
                    AND AP.TONGDATID IS NOT NULL
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
                   WHERE     AP.MA_THONGBAO = V_MA_THONGBAO
                    AND AP.TRANGTHAITHANHTOAN = 0
                    AND AP.TONGDATID IS NOT NULL
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
                   FROM DVCQG_THANH_TOAN AP
                   LEFT JOIN DM_DONVITHIHANHAN THA ON THA.ID=AP.DONVITHA_ID
                   LEFT JOIN DM_TOAAN TA ON TA.ID=THA.ARRTOAANID
                   LEFT JOIN DM_TK_THANHTOAN TK ON TK.THA_ID=AP.DONVITHA_ID
                   LEFT JOIN DM_LOAIHINH_THU HT ON HT.ID=TK.MA_LOAIHINHTHU
                   ------
                   LEFT JOIN AHC_TONGDAT TD ON TD.ID=AP.TONGDATID
                   LEFT JOIN AHC_ANPHI AI ON AI.ID=AP.ANPHI_ID
                   WHERE     AP.MA_THONGBAO = V_MA_THONGBAO
                    AND AP.TRANGTHAITHANHTOAN = 0
                    AND AP.TONGDATID IS NOT NULL
--                    AND( (COMMON_APP.GET_NGAY_LAMVIEC(AI.NGAYTHONGBAO,SYSDATE)<=7 AND TD.BIEUMAUID=121)
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
                   WHERE     AP.MA_THONGBAO = V_MA_THONGBAO
                    AND AP.TRANGTHAITHANHTOAN = 0
                    AND AP.TONGDATID IS NOT NULL
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

END PKG_DVCQ_SEARCH_THUCONG;

/
